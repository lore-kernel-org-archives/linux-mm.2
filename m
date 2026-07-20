Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FC4FC4452A
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 14:17:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CD576B00A4; Mon, 20 Jul 2026 10:17:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97E8A6B00A5; Mon, 20 Jul 2026 10:17:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 86CC66B00A6; Mon, 20 Jul 2026 10:17:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D8D36B00A4
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:17:05 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 0001E1601C6
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:04 +0000 (UTC)
X-FDA: 85009356810.03.0BFC9DD
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 3C31F2000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:17:03 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=egnIImWA;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784557023;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J2QHy+8aDvUuK1lYAmgQR7tOtfpX0R/pRz+K12b83rg=;
	b=5CTf7lxwwJrMYzWV5BsecCm9erdWqRcLO3URmKBlYBXpYWMr+et9q13+4jAF7iOoveSGtj
	KJ1zoZ5LkRUWKCTssufAD2WBjkRxhXoEw7vsU2iJksHZCREOZKhvfGOys7G+I3ZlIrqtZv
	AwHEfwSrhjNfQmeWk1ws7xX+ibSDHfs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784557023;
	b=eqBJ5GAM8rSam8xqylD2mtl9cXPQqrLDdpVE26RzpzvMT6X1PhHvx3tpaqZiATd3bLWcRu
	rp4PV0lu7KNu6TuyojaJVJE1/uIIBwS69YofP8H3haAh6fhmZRV6L7FzRqmmwDjr9d6jLm
	hq2L1X7OvhtXGb5gHQ03fTokciCHAz8=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=egnIImWA;
	spf=pass (imf31.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CBDD360254;
	Mon, 20 Jul 2026 14:17:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB38C1F000E9;
	Mon, 20 Jul 2026 14:16:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784557022;
	bh=J2QHy+8aDvUuK1lYAmgQR7tOtfpX0R/pRz+K12b83rg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=egnIImWAjekWM0hyh5G7FSbHakblC40grDwPP0aXTYu/nLY3GNOU4WJwFVBI8QzvF
	 NpjLHTmr9QdDTg1pR3ejvqLf0NPsYbOGW74VEYYtfiVp1V4h5V1UWYu2nv+z0z5J0w
	 XNAm20w1ucPg26aUEcjVxU0L20wNDXViVjPkoOnaBoKziKP6ZSZ2b3VZ6P8J5DUegw
	 iaItZCo24oMkV/NtY1OO1xYeBqmQ1WpUgas+y4ly2QnGzsX6NkWIjxmHBb18fgDIZJ
	 GwoTUKeNPa0trKdMm9oyPvukyGBv5Cc81mEQ7X9+0umyyPbdlGhBhH/RNCjSk54t8P
	 qQPvI4ATQTkFQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Mon, 20 Jul 2026 16:16:25 +0200
Subject: [PATCH v2 11/13] mm/slab: reduce slabobj_ext memory with
 allocation profiling disabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260720-b4-objext_split-v2-11-2fa7c6f60dbe@kernel.org>
References: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
In-Reply-To: <20260720-b4-objext_split-v2-0-2fa7c6f60dbe@kernel.org>
To: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>
Cc: Hao Li <hao.li@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
X-Mailer: b4 0.15.2
X-Rspamd-Queue-Id: 3C31F2000F
X-Stat-Signature: o9cqiapgx1qbbjxekowkkag4qk57rehn
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784557023-873743
X-HE-Meta: U2FsdGVkX1/izVnCyjDRphMXjMi6pVkpncJRYOZ3r1f0teEs241t2A8LJyR4oYmHBpgPQVV5m5RL3qe7TU7uzg4chgofIRFIpYkSc+11pQHlAZPhEsTvc1vqdfHaDxwLoQUA50sEVRJZj7LMIJXTt9V4L+hy2DoO8Qe59JHSmrygEZzOnCio5yHjMqBQZrVMuvzNOiPz6zuSv4xP86l3PXAR3nlLhC32gPfmzwURZk1eVnsKC1iNknESIvWBuCqy8bKeHvxz43PqJZkVo3mASYaLjCQYFmBDmYussTjXpAOSYF/H7n656c8Ora50Fwx57ib9m+xAXy9tKDKsEp+CkMIm7Gv3aLPQ6NHNf1Bk7jqCj6+AmdsL1GEhxW4oWGo8n1TumnjtZdRjYafHjKTVmr7i4kXKFJg+qWIRKUKJgXgflK8tljDIleQu/C86TxSkGlZ7ldu2cvl9lQsGVVwhZjDcglJpxNo9RfBfU8NDnvZpMcMbtJePkMdet8BAFC032lESyPiWN7lVMsIl2l5FEXYFknIt2rTTrLMnNcEfECeff1tPZiG9HsMVReOolXTubVzbHpVAzQHvYOUEcpbH4DbnUqudHvaUpd6Ah+/OAC9d+5eD29atXcQvUgo6u8W9BzaJ0IVoTz7rL5/zRptd9uNTyaMdb8dosXv/cmLj+QGTlLh5e5eywbJ/QiRaXoAdCJuu7E7O6d6tGg+7V3OrDNVgc8IAYprOW5wYtswEaaA8QHbvMBG6eBXoB0D9maCrX40isvaBLa2WiErl4Q/VPF6OhMl6P5LSTEwBBzIzXAt0Q3jj/0bff02FMcm/+oQNs6eFGQblcqodz51po3zQ8nril0xDyBHXG9WAX1r8g0VDkpsKOouTjCBsKns0CylI1nnzGbQw6aRnYh97Qom5Y6NEt17pFs8VnLFpz6fZvIKSbaamiN89ffp6jLhWutCBLjiLEcNvHNKF1+SiNKb
 VsD+qpf2
 9soakD39PxHDCXklpzvbGIeJdQ4c/1nGyPMKUbBAmPHq6l4wTT7FCSuVooSpJrrksoiUE3eyTbyKv2wuvr0cldvM3Q92KpxnSK5HiCEklF3vnZT8WDrzUWGHMuEttWvFOweq5ZrjIX+/E3w8X/OWxOJH03Mm6AepgmDAHkWaCEtKaX7IkAr0k4aYF+BZRbDuuK0XyhICYNVUoKQ8X3NG0xDxZiZUovuP8qas8vM9mD2Pv5adbBGXzL+qsSwFNGY+daHmj0cN/w9Jh9A5Ny4k6T05WCg8gWgIuDtD3M0KI9EQEGEphKkEw0qDqpw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory allocation profiling is compiled in but permanently disabled
on boot with (implicit or explicit) "never" parameter, stop allocating
(wasting) memory for the codetag_ref parts of slabobj_ext metadata.

Reviewed-by: Suren Baghdasaryan <surenb@google.com>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slab.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/slab.h b/mm/slab.h
index 983cb1119a76..c5f37a46434e 100644
--- a/mm/slab.h
+++ b/mm/slab.h
@@ -591,7 +591,7 @@ static inline size_t cache_obj_ext_size(struct kmem_cache *s)
 	if (IS_ENABLED(CONFIG_MEMCG))
 		sz += 1;
 
-	if (IS_ENABLED(CONFIG_MEM_ALLOC_PROFILING))
+	if (slab_obj_ext_has_codetag())
 		sz += 1;
 
 	return sizeof(struct slabobj_ext) * sz;

-- 
2.55.0


