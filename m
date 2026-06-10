Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E3914CD8CB2
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 15:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 537D06B008C; Wed, 10 Jun 2026 11:40:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50F9D6B0092; Wed, 10 Jun 2026 11:40:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44C7F6B0093; Wed, 10 Jun 2026 11:40:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 326116B008C
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 11:40:31 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id DA1C7120192
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:30 +0000 (UTC)
X-FDA: 84864415020.17.0D2179B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 47BBE1C0010
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 15:40:29 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SEYUC121;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781106029;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EcPADI751DZUFmAf8tMZbq8OK7pAbO29bPO2oNj30UI=;
	b=QOPxPowDnMVciMcYaCvSVm9ZJpF9KiSB9wW3na2QkrARilnVELKWbSYaCFcqmb4aKow8x+
	E8e6rchyBywzY0kuVBOasbW79HIRytxp2vrFa/b4AG42V7QzRTwK0W6TXhCz3l43MgA8ri
	rdGSITo7Bn+DCQpnlLCyztlUNB40rdM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SEYUC121;
	spf=pass (imf20.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781106029;
	b=wYyJwsfHbu/pLzLRk/6n7E+UEMrhu4Hn09s7bo95R5EB9BSYNm7f4O8u/OzOeyedgRa7nN
	odgjaemKFe8fWrNevG8G1G26bEZft2/oSKy44jggtsQwRYOH3oDkjZ3/n7Pf5lRTIFBumR
	8AOJAP7Mrd6cscuWOiht/Zh3Ui54RP8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id E366960172;
	Wed, 10 Jun 2026 15:40:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 119E41F00899;
	Wed, 10 Jun 2026 15:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781106028;
	bh=EcPADI751DZUFmAf8tMZbq8OK7pAbO29bPO2oNj30UI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SEYUC121sf/7PG2uBKmnFs6RVfZUcO9yIuyUGVekneIQcQDdInxcAael6nek53to7
	 OWDpMOwTekAxg2MUzrujVjDdFt9FLj40D+spbz2KEUqE3j6X6Ny1RHH+I0XUqxZoei
	 ysoQaGoHsOJSu6fINHXSgWRiMcemPkOXRnsqNuPxfIkrb1lMyd67U5atQNkKqeRcwb
	 T5YWpOd1i98Ijvk4JyrVX6LWWmzrninQe1gP+7mGwW0lqBlMiWmRcE6D5cCtc95wno
	 NItL0t3TzcaOWPAXW1sFVOuxprpWbxzV17wOoQkkVMqAdBgfr0op1nU2QIhqjGYScW
	 psTFj/44omEEQ==
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Date: Wed, 10 Jun 2026 17:40:03 +0200
Subject: [PATCH v2 01/16] mm/slab: do not limit zeroing to orig_size when
 only red zoning is enabled
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260610-slab_alloc_flags-v2-1-7190909db118@kernel.org>
References: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
In-Reply-To: <20260610-slab_alloc_flags-v2-0-7190909db118@kernel.org>
To: Harry Yoo <harry@kernel.org>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, 
 Roman Gushchin <roman.gushchin@linux.dev>, 
 Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
 Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 47BBE1C0010
X-Stat-Signature: 6gxg9hgbk459danx6hsbfscwubn5euri
X-Rspam-User: 
X-HE-Tag: 1781106029-693603
X-HE-Meta: U2FsdGVkX1+xwSnfaANVQ4a9ybmO/0DJHBgSegFlyLF/ahPf7qalibZ8uNvINtulTpaZ2WdUDzECOH0KBGCAyaK6gDbq+ItuxJuRpdb9YUaNC5XOS6YEOM88qOxdWFhBc96y8JeWZxiCUV6RD+hATD0a0tVbMf+tbIrijp5Py4VmeUrtU1lGv9JruuY19VAW+Ta3oaIU/ijjZHec+3eF3qzfsWCfkjMKvI0YcAQzlHL0/TkBXm0zbPC2Yswv1u/f/jxM1fXOoXlYZ0KH2WGe77x1Oinvh1RFcM6CT01rVQWdL5HBlcbhu/YfF9LBc8qdkFuvb1NOLYQGoppxfZhcct20DkomqjcM+eQ+L/iW7voitPNm7G9yyam2CymBogsGYBTKcCTXOSQyrv4IqqyZoXGpMIym9UN8KPcvj/FSd7LZMqK8L90ilP8uya9LIStB4f2naVuyglfgyp2wCHBy04nK7nadgqlf3CwkpCZOcpG3qwL4oSw+VSp3EhjuuU5mvd0lz8r3z+ZlC/TAp4+eJyJbohjhHVfZh+3bVQYEEndenx26oGcr4puomzmqVujSwZWpqx/+0jfGdQh5JwKgiZcJrIERi3Gd6d5kWgvaKqHUdZf+npaZ0rCVQ9MqQRxC1bgLOnn2aC0xYBpLnIJLDypGexnGN/4VfWBR2yiP3h7Ugb9L/NZ0mZJR4BLSTnVXy90+xkUeeSgg9V96oQH76Zgg8BFs2EFZc5OtgdbpCk2C8DshfjxWnj97dDlBtwSzKlxxO+HZpHcLPbG5sU1Oz11NrpbL7NswWu4LNm1E9tE2zI3GgguSwfFOvxiJJphZRRLPNnYkd7JdHKWfor3t7+jWuutGROiPGpHWQTBaLFjTtXHwzISjcI7iZpGJn3954lHBXuUxYYBIYGaNuxiHZhn2HQsDpQN+hvyZbTYiFYMTCbvpeRGcEQqUjiKEYx0s8VbcpireXHk4WZwzSDW
 d5jy9OQ3
 lGi79bbOhFixMcdteWKsBfnMFFifWAMPYy1bCTTioKbj9z/hDsTTG+J47ooKmLB78+dNphoAcZ0d1fWms0yc5y010TX96EFnk9tkl++8wSZkojpz71F7IENKzRzSyS2KNlWI5l0X0K4963Svz/0HgY/w3rAz+yeXA5hGOtOAawT0oFk6KyAbtFV9vZy5X4Mk78dyWUJl1TcTNLwB6bcZDrKoV4efAIa0vqto0BoxjBpX3fsUjDWQ4AAQa709FHOwtoR8Ag6C/7L0c2SizNH32FXnGHcZwRFFD61xrjoYLJCQfHJ40C7adZMgZbodjeePkifr5
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When init (zeroing) on allocation is requested, for kmalloc() we
generally have to zero the full object size even if a smaller size is
requested, in order to provide krealloc()'s __GFP_ZERO guarantees.

But if we track the requested size, krealloc() uses that information to
do the right thing. With red zoning also enabled, any unused size
became part of the red zone, so it must not be zeroed.

However the check is imprecise, and will trigger also when only
SLAB_RED_ZONE is enabled without SLAB_STORE_USER. This means enabling
red zoning alone can compromise krealloc()'s __GFP_ZERO contract.

Fix this by using slub_debug_orig_size() instead, which is the exact
check for whether the requested size is tracked. We don't need to care
if red zoning is also enabled or not. Also update and expand the
comment accordingly.

Fixes: 9ce67395f5a0 ("mm/slub: only zero requested size of buffer for kzalloc when debug enabled")
Cc: <stable@vger.kernel.org>
Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/slub.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/mm/slub.c b/mm/slub.c
index 63c1ef998dd3..e2ee8f1aaccf 100644
--- a/mm/slub.c
+++ b/mm/slub.c
@@ -4574,15 +4574,17 @@ bool slab_post_alloc_hook(struct kmem_cache *s, struct list_lru *lru,
 	gfp_t init_flags = flags & gfp_allowed_mask;
 
 	/*
-	 * For kmalloc object, the allocated memory size(object_size) is likely
-	 * larger than the requested size(orig_size). If redzone check is
-	 * enabled for the extra space, don't zero it, as it will be redzoned
-	 * soon. The redzone operation for this extra space could be seen as a
-	 * replacement of current poisoning under certain debug option, and
-	 * won't break other sanity checks.
+	 * For kmalloc object, the allocated size (object_size) can be larger
+	 * than the requested size (orig_size). We however need to zero the
+	 * whole object_size to handle possible later krealloc() with
+	 *__GFP_ZERO properly.
+	 *
+	 * But if we keep track of the requested size, krealloc() uses that
+	 * information. Additionally if red zoning is enabled, the extra space
+	 * is also red zone, so we should not overwrite it. So limit zeroing to
+	 * orig_size if we track it.
 	 */
-	if (kmem_cache_debug_flags(s, SLAB_STORE_USER | SLAB_RED_ZONE) &&
-	    (s->flags & SLAB_KMALLOC))
+	if (slub_debug_orig_size(s))
 		zero_size = orig_size;
 
 	/*

-- 
2.54.0


