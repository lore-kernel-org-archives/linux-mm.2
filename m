Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 97E6E606A332
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 16:58:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=I4AaxRQK
Received: by kanga.kvack.org (Postfix)
	id 35D8B6B05B9; Tue, 10 Nov 2026 11:58:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0B76B05BA; Tue, 10 Nov 2026 11:58:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A8276B05BB; Tue, 10 Nov 2026 11:58:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E01626B05B9
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 11:58:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 84E101A09EB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:58:02 +0000 (UTC)
X-FDA: 85419816804.17.1A07331
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id C0B5FC0003
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 16:58:00 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4AaxRQK;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794329880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=h2OspRC6i0T4Wp5dMT6Pjhd2/n2ZVXU+zFPBnXHjmVw=;
	b=KleTv1y3/gWqwmRExOtEu8LMNaI7A9WcA3ErcPEiebjTaBRnmlUC3snxsqWykIQusrnDBn
	9/WmZHUgcQr2z86W+gXd4fN9EuErRMv7mM/4/uMZh3egLAd/baVQn8tXHGcWO9UYbF0vnD
	wt2qxJVC9+3zXpXaWnHudLnBe0hSwyA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794329880;
	b=vaQ7uHCjZd84BlXUA0L2ErNo+UEXd6W9Qjh630fWglUyyY3Z3h9wM0umvu8EBE4EkXNP+p
	8RuQS/oCmXox+DjAs/h6zRKdpQtPltMbPZ95Wefvtf+Wz4IE/E+kgDEEoUbkvKqc/R/SET
	+kQykk+xb7oWIyLM3JeqL8NNpHnOzHg=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=I4AaxRQK;
	spf=pass (imf10.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 17582470EB;
	Tue, 10 Nov 2026 16:58:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9F141F008A5;
	Tue, 10 Nov 2026 16:57:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794329880;
	bh=h2OspRC6i0T4Wp5dMT6Pjhd2/n2ZVXU+zFPBnXHjmVw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=I4AaxRQKe0zCFqKZd3E6YaKCFCJSc6GB29noLsrvUVFMTmIZKfViJvgQTEcsyh6xP
	 FLGOOYDHJrQrgSOszmbHVL7cCd4pql5+TTyu8MkdDYkg6FEKg2n+DGjMVomUBGUcSn
	 LMlacXfvPo/cb2Hi+H/VY6wP48MZArQfkWNdEXQSkTT6ar7Mu3f/AToWUWK3wog3EK
	 0Zcc9GZYWm5gdOBP5RHO08v8ZPKeknY+aqfT1WOXy2qQIA9ciYfYQ+Kbunj+5NJUgO
	 5RoJpjP4PCzHRTczKGPO2D+VIXvHXvDJVN7+yQfbgydmykh03jJIuJ3fMYiMyhjMQd
	 Fme/rs2ZyjVNQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 16:57:45 +0000
Subject: [PATCH 3/3] mm: convert WARN_ON_ONCE()'s to VM_WARN_ON_ONCE() in
 VMA lock code
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-tame-vma-asserts-v1-3-be293ff499a7@kernel.org>
References: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
In-Reply-To: <20261110-tame-vma-asserts-v1-0-be293ff499a7@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>
Cc: ljs@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=1503; i=ljs@kernel.org;
 h=from:subject:message-id; bh=PYq4aNCNbT3IejiBpxaZmcA0sFtPdPhHHBku2mVa8k4=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI++/JuKaspO225fWOfTvuGZ0Fzynf+SKp8+e1qkr5qr
 GSdq9vHjlIWBjEuBlkxRZbnX8T3B4mEzeu84O8GM4eVCWQIAxenAEzEQZThn57JihunXdc+lzls
 1eUisuoxk/KX+UWqHd8rGWepqlVJ8TAybH/YcYP7Es8ZjjmcM/J2Jvy6aD0r2Iz3xH8f7TrloA1
 RbAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: C0B5FC0003
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: xe1wef7u9yh1okm16hq7a47z1mwj7xp1
X-Rspam-User: 
X-HE-Tag: 1794329880-944439
X-HE-Meta: U2FsdGVkX188dxSvvWxbALV1mRykGnduHAOpYp477WIYDde2hECdqC0MUkrQfoUDuvIDGAi2Z8vn8lY/S7QTTazCwi4JbEzGj9tROT5AYyPPD/FAa76j2eiXBz9dBy5Y+CRZvB7ZHgX5yWbv1vv1qEPS8cg0gDKZEDVYEbzAX1ItX0/bCYJd0WQjqodkdlhSDVNx8zz15oynXXrtUesvmCzGydQagFemH7zSUWwPgM5J/ipJL895UDHhCzXVd+WlAflm+hXZZjEYgyL1ye7Hx2fyjaxNb1O84uGkNAgF2iAiiom/yPkscsBb2cW0O1fNcs6M956oCM3I3qCRg6EMYgrBGX0Dq5Vs7dq6RqWlMdpR1GAlBhP8nLgvw/q43yoUwlRen/c6y8T0Adp5015ebL3MuDrixR30qtIghMJk8Bu9KT/P7hpImV+2Y7qSgNryowFca5X+xkTCsUlfnv3zOIJY0fWsNJWcf6Oe5HUJtbwV5SLRrMVLRijFe2XXk3lpuE8Pk0WMHTMemAfboPX1HMLNuBZowZtgneiCU7HW6n0qq/60S45a8dDsZhyZZfxWbfhfZqtyzcWAqo17tiFyeEgG28RrPLFPymgONAUtEpwk9lPqXaTgazl8CuxFqmKRE+oozj0Cq8OglBbQTYasnIBeYy3wwfPIlnw8XPENVfz3TH79JpyRHVEtJ/KXQ7OHIl+8bSFjsuC6b0BLE6ZB72axENWACT6shj4tfitqaXmjRGPUUj+E/621OzoPvLeY4MbL/9JYpR9lkWOOKJjX/wrTvhmgwNkv4rpCGkXcUkoJZ9TCUcXlxSmzyn2j4NwDMBBG2TGhDAc9yFnFuhLuSiDnlPJhre+lndubN7b9xjCn618L+cawFqOcUCLZPGPLQ5Hzj+ZgIBWTLHF/czNz4p5pTyslJs2rBBIEikBur0VXVVnJDIBQ8nT762SkzZ9IvwRh/b3U40ABMwB3RaQ
 DLkt9su1
 0hZCK+gyBHMTNiCA7j+R8kEBcGRuCHAmND6zDGyHcdmwHqU1HXmPhqBPoBKRQyiXbHSP/XFU5wwpFqEjM8W0BgS/zv1x6gkOYpqnLAYDfTQdRS06KflfBs3a1atHzIoDwWrZK4HcfN1MqslWJJSIQd2BTRBluEHV+2PFnfiX2gX4e+mc90GJmj7d5ZumoM2IctZJ0RI8CTDg8yKzoJLec97s3g7AKMqYZW506nMeHKgBRJeWYv6UOuFxFO1gF746HrWXmyx0WroTV21wnGv7CBdjnLOQ47kDZMmez
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Now that VMA assertions are predicated on CONFIG_DEBUG_VM, it makes sense
to convert existing unconditional WARN_ON_ONCE()'s in VMA lock code to
VM_WARN_ON_ONCE()'s.

These are asserting programmatic invariants which are in most other cases
asserted using VM_WARN_ON_ONCE(), and there is simply no need for these to
be unconditionally checked, so no longer do so.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 mm/mmap_lock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/mmap_lock.c b/mm/mmap_lock.c
index 834bbf86e004..073c5125b424 100644
--- a/mm/mmap_lock.c
+++ b/mm/mmap_lock.c
@@ -146,7 +146,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
 
 	err = __vma_start_exclude_readers(&ves);
 	if (err) {
-		WARN_ON_ONCE(ves.detached);
+		VM_WARN_ON_ONCE(ves.detached);
 		return err;
 	}
 
@@ -161,7 +161,7 @@ int __vma_start_write(struct vm_area_struct *vma, int state)
 	if (ves.exclusive) {
 		__vma_end_exclude_readers(&ves);
 		/* VMA should remain attached. */
-		WARN_ON_ONCE(ves.detached);
+		VM_WARN_ON_ONCE(ves.detached);
 	}
 
 	return 0;
@@ -193,7 +193,7 @@ void __vma_exclude_readers_for_detach(struct vm_area_struct *vma)
 		__vma_end_exclude_readers(&ves);
 	}
 	/* If an error arose but we were detached anyway, we don't care. */
-	WARN_ON_ONCE(!ves.detached);
+	VM_WARN_ON_ONCE(!ves.detached);
 }
 
 /* Do the VMA, mm seqcounts indicate the VMA is write locked? */

-- 
2.56.0


