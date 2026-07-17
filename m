Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29FA4C4451B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 23:16:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 290DE6B00E7; Fri, 17 Jul 2026 19:16:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 242256B00E8; Fri, 17 Jul 2026 19:16:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 130E86B00E9; Fri, 17 Jul 2026 19:16:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D0B8C6B00E7
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 19:16:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D35EA06FA
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:16:32 +0000 (UTC)
X-FDA: 84999829824.05.38CAF3E
Received: from mail-yw1-f171.google.com (mail-yw1-f171.google.com [209.85.128.171])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4928940006
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 23:16:30 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=St5upEjM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of shermanpauldylan@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=shermanpauldylan@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784330190;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Whm4jZa43igZwN7cS/CfJYk9DtbneKig663jvNEluns=;
	b=uSgVajFFYnRmmjGWb7fQ0ONvuZ31I2zCkCuXJQgPwiBX/8nakH3Rnk6KnrvxrKdPwbkIuX
	Pt3HySd8E6cskSvPbWt9NHrxB3E/cnDdz7sfrdyR8nOwNXNc/GYFbNw1I42NG/T91+hw7j
	YNNQhR+Xuc9PQsMJjIaR4cRLpGeWyHc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=St5upEjM;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of shermanpauldylan@gmail.com designates 209.85.128.171 as permitted sender) smtp.mailfrom=shermanpauldylan@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784330190;
	b=OxJSdmkmYx0lFOz+ncPJZTNkqIcPLPk9fRiF3ob5KLSI09j973fbgZI8WoBKXo2VkAe3Iy
	5SIl4H9mAkogfm3/ubBm94WDeFvIP57BnC7C85xJC/r+oZyD1RgA8JaSnEyhZ/3utvlT0u
	pGiIN4k6gIdDKFLuBPVGW/a7Wv4Re0o=
Received: by mail-yw1-f171.google.com with SMTP id 00721157ae682-80814edb536so52738107b3.2
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 16:16:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784330189; x=1784934989; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=Whm4jZa43igZwN7cS/CfJYk9DtbneKig663jvNEluns=;
        b=St5upEjMF3rD5dIcQq8FhQxwApC+yKLJgtX/bGuFpqZxAScSW7Gu4mTo1pbSnOY09b
         QQvI+wbOUnWLVJKjVeF67CZlBhe04M6JBuJqAvix969DAluztcThZcRvDiT3Nsh7GBG0
         CAzHOWmQkFQdIx+yzHNuiYxj1IR16TkGMRo3u/xYGn4C+qu0Gz1+Uojt8L6kZfyKLpwd
         1nPyDjkY8PYPaUHhW+t+e7jGkN2cCUcW9aOlyM05kTVlWAANimSsPD1ClfXZE9E+c0yH
         dH2mrn0rrFmSxpB1ufdRqmBAhZYIUiCWzVoPx1jHhmpH0MwbpbaQ2GSxKvRUh6++mofg
         iymQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784330189; x=1784934989;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Whm4jZa43igZwN7cS/CfJYk9DtbneKig663jvNEluns=;
        b=sMuK5OH0L+iHIdKCCiTPaj4pQ8+masvy7jK9Huryxc2iRy1INJoRuW400vPx/SYU65
         mQx1LXHQYu6Xi+oCWlCrH402MzQneE/H4Fz2DQ3v2zElcdH3Fqzoggo+zp51lQiuh0YD
         kn8u/+zUtVpMR0EVHWErx5yxLqzamH6hQJp27HJfW7aguMXDmWX49LulHDvY2S35AiaT
         6v/aS+Keyi5PRLrIb8oQWrdB0VmvP7MPtPLTSKcRkg/UFGAgJJ5m+VmcRvQNbI8XqJHx
         xzf3+96DaDPIkdIzLuYgFK+3K91wkkNZMB0Kn+klcf+lHn7izS7iRO4tgpAHxGDP6hjW
         r4+w==
X-Gm-Message-State: AOJu0Ywoufk483dnAxIUh7HH1AkYfYp17rNHtuOqi9LE3M+TklA6L74i
	v3bFqHYaoHkxdPZ36CEw6HEhWBr2DGL3oJex3dz6R2iw6yt+dcRDdm0pOMxUp5TY
X-Gm-Gg: AfdE7cm/ZE0RIdZj9q4aDgxnvPvtwNU7sn/MTf4nxjRNjPVCjcx4h3hcqXb7gu6x8nc
	VpB0J59X1a/BTyYRw0kCd1Hzo4m3w1qpU2jGtpBFv+fOuau6GsvJXEcaEQ/Iusg+SI3MLS6ckpF
	92oithcuoyNIeogOWc6mxRLtNMPev+qeG/eB4fT1MM6wXMDxt0iZnYfLQvwqw2teN+VeCNVJeko
	9OlGtMnDPHP1XzpzBvKq3H9s12nakpSQXLnEqJhO6E0dXAEsYHEZINVMhkLlHCH6Y6BnptJrm0h
	3HMXpH4i2Se8vLtFBasgfCEMZwY/6dzZf3FLN7hWSTfzNgfuuNMLwbv49BeLlq2cBPYFSIrGmk9
	zvFW7H2ctHILof+F+6cXqhFfDn9cEx3gBERULSFrCOf94vU1FpwptFFoXnxYhQOCZBayBtN5W8E
	/3gOq0I+CoAy5Ul5eTCG97zyxv3IqKRVRySzu37jf7LG09dq5EPE6rjyQ=
X-Received: by 2002:a05:690e:154b:20b0:667:b57b:8697 with SMTP id 956f58d0204a3-6683bd2fa43mr1100245d50.61.1784330189257;
        Fri, 17 Jul 2026 16:16:29 -0700 (PDT)
Received: from localhost.localdomain ([107.198.84.185])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6683b5645a3sm2597231d50.6.2026.07.17.16.16.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 17 Jul 2026 16:16:28 -0700 (PDT)
From: Paul Sherman <shermanpauldylan@gmail.com>
To: linux-mm@kvack.org
Cc: tj@kernel.org,
	vbabka@suse.cz,
	dennis@kernel.org,
	akpm@linux-foundation.org,
	linux-kernel@vger.kernel.org,
	Paul Sherman <shermanpauldylan@gmail.com>
Subject: [PATCH] mm/percpu: allow embed allocator when total size fits in vmalloc
Date: Fri, 17 Jul 2026 16:16:16 -0700
Message-ID: <20260717231616.9126-1-shermanpauldylan@gmail.com>
X-Mailer: git-send-email 2.53.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4928940006
X-Stat-Signature: d89kwsb7qu3dokb1ahtompmmdrsknqeq
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1784330190-121696
X-HE-Meta: U2FsdGVkX1/DkP5TUJUh6cFtnqD/6b3LO4M8D4K6qv+vTeLxU3OJu6OYJU6KIQyZUkL9hLdPM38c+WcCh4wyuder5oGgDQ1y4fr15B3VqHO6dHxrItGlvLy2NNRYng5UIgtx6FSOe5KpYI1bVksHwjgf4A2HYENJjDoMil95HdaKu1FaylSxW5mxhovwqCVx7ZcsLMbLY19WFQSSrEGWvEgGecKpq6pmOn7r6NR7k+/Zlmcm5EXqjp0pjCA/JwZrVe3v4lAheF/DnlVwQO9wqn+nV8iVDGsjIlAOEMi5crSexiQPuBDvPC05CrwmAaealVqN2knuYN7ok4ZHrKDP+UOOUiesKA/Z+rW9CPKYdv/gRg6s/nk5qqGfXWKI79bpKaw+7mLu/QjyBfWn3niI+czG9BO4ODBPNOo5S456MLJYQ05uE4qRgu4BilYiYKgPf6wWvR5uUiW5uuMKukB42jBnOmNqaYwgDuFXLQoql5oQJKnjKgbKx3J7fpb+70rG8JyaanSE39oTzR0uUnbXkApXNREZWyfl01ji9zYGCJ7sAi8KZMZmSjigNGcbFCiYc70Z3met40QB+CUhy/wWlO7o28UrMYjbqEXI0Ia7nM6BUSidu8Ivev1kJcf4W92H+dRD83wn2UbDwtbT1HIyzw/tATn2zxom0x1C4s91m34DmSGAFLHbAyN953wWX40cOevLn+zG7mVIkvm1boolRho5f8fioOgOtwADO3op/bLqZsnfl7LsuiiF9wBwNu0fnFFuV6ADKepj9qh8xRP+aicODbGZWUYi5eM0OXBaYDsJcf2yr9zXxlKAY0IabQIwmtCQdX2aQLdrBm08mzaANquNRjzXc1in0LdvIvtJklmMx21+ZGUtgfdI9THTrUKdKTBrMhV8nTXRfLCGNOg8y41DhwZQXq83r9A4YBd/IUdOK2y8ednCBVkGGmiNdznE4gV3WsIrJw2capoDpyl
 KrQgPdLf
 WDVJ+WFPKvCOgGpCfC/Kal3ptKDr3Pw7wq+jGirTEXDSz8AGyJmFtahqHCP897vUjWVogNwFHvNjQVYiJZfEoerMHQtHllipniKsP02P/vP8t0kv26Cc+BpvhwcTxoG6kM37Nt5A8Mbw8CRuiiDz1g4aT5n/eZYiezec3aZLR7SsC2UesSE3y/VKRf4PXb55R6USntlpp4kygaW9ed3NlZrWAxBasj4rTsSbq0HMj0/HyGJ4eaGP3rI20IRkZAvvFjbb9gC+FLD2nurTXAp38MOg+SnExtZ5IIPlxZCx88n5VI4rkGaCUF2ujBELYjdYYZ5FkxeIfQQ36S+OavoK5nx84T1M4EtZ5JU0SkM3YHbmZveAF6EsQxVsqtyWfnLtyC3xxKINLwjK47vi/bo9w6MEkwXrJRLJpQAxa4f7zdW2HzujknsFZcEBVoTZakzw9hU0dMeNSk7S7x1KodnmwJSSTGoBmL1ljBSGI0Supk/Cfs3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On large NUMA systems (e.g. 4-node 128GB), the physical span between
NUMA nodes may exceed 75% of vmalloc space even though the total percpu
allocation is tiny (e.g. ~6MB for 64 CPUs).

The 75% check was designed for pcpu_get_vm_areas() used by dynamic
percpu chunks, where vmalloc congruency is required. The embed
allocator uses the linear map directly for the first chunk -- physical
addresses are accessible as virtual addresses without vmalloc mapping.
The relevant constraint is total percpu size, not physical span.

Replace the unconditional fallback with a total-size check: if the
aggregate percpu allocation fits within 75% of vmalloc space, proceed
with embed regardless of physical NUMA span. Systems where total percpu
size genuinely exceeds the vmalloc bound retain the page allocator
fallback.

Tested on Sophgo SG2042 (64-hart, 4-NUMA, 128GB DDR4, RISC-V Sv39):
  percpu: embed: span 0x17def7a000 > vmalloc 75% but total 0x5c0000
          fits -- linear map used
  percpu: Embedded 23 pages/cpu s54168 r8192 d31848 u94208

Link: https://lkml.iu.edu/hypermail/linux/kernel/1707.3/00337.html
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Paul Sherman <shermanpauldylan@gmail.com>
---

This fix is inert on systems where the original check never fired;
it only activates when physical span exceeds 75% of vmalloc but total
percpu size does not.

Architecture analysis:

  Architecture   | vmalloc      | phys span    | total percpu | result
  ---------------|--------------|--------------|--------------|--------
  RISC-V Sv39    | ~88 GB       | ~102 GB      | ~6 MB        | fixed
  RISC-V Sv48    | ~88 TB       | ~102 GB      | ~6 MB        | unaffected
  RISC-V Sv57    | ~44 PB       | ~102 GB      | ~6 MB        | unaffected
  ARM64 large    | ~248 TB      | varies       | tiny         | unaffected
  32-bit NUMA    | ~128 MB      | varies       | may exceed   | correct fallback

Tejun Heo noted in 2017 [Link] that the only constraint is vmalloc
size relative to NUMA node distances, and that making vmalloc bigger
would be the best fix. On RISC-V Sv39 with 88GB vmalloc and 102GB
physical NUMA span that is not an option -- but the embed allocator
does not need congruent vmalloc mapping for the first chunk anyway.

 mm/percpu.c | 29 ++++++++++++++++++++++++-----
 1 file changed, 24 insertions(+), 5 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index b0676b8054ed..72695778872c 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -3069,13 +3069,32 @@ int __init pcpu_embed_first_chunk(size_t reserved_size, size_t dyn_size,
 
 	/* warn if maximum distance is further than 75% of vmalloc space */
 	if (max_distance > VMALLOC_TOTAL * 3 / 4) {
-		pr_warn("max_distance=0x%lx too large for vmalloc space 0x%lx\n",
+		pr_warn("percpu: embed: max_distance=0x%lx too large for vmalloc space 0x%lx\n",
 				max_distance, VMALLOC_TOTAL);
 #ifdef CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK
-		/* and fail if we have fallback */
-		rc = -EINVAL;
-		goto out_free_areas;
-#endif
+		/*
+		 * The embed allocator uses the linear map directly for the
+		 * first chunk -- physical addresses are accessible as virtual
+		 * addresses without vmalloc mapping. The 75% check was designed
+		 * for pcpu_get_vm_areas() (dynamic chunks) where vmalloc
+		 * congruency is required. On large NUMA systems, physical span
+		 * between nodes may exceed vmalloc bounds even though total
+		 * percpu size is tiny. Check total size, not physical span.
+		 */
+		{
+			unsigned long total_size = 0;
+			for (group = 0; group < ai->nr_groups; group++)
+				total_size += (unsigned long)ai->unit_size *
+					ai->groups[group].nr_units;
+			if (total_size > VMALLOC_TOTAL * 3 / 4) {
+				rc = -EINVAL;
+				goto out_free_areas;
+			}
+			pr_info("percpu: embed: span 0x%lx > vmalloc 75%%"
+				" but total 0x%lx fits -- linear map used\n",
+				max_distance, total_size);
+		}
+#endif /* CONFIG_NEED_PER_CPU_PAGE_FIRST_CHUNK */
 	}
 
 	/*
-- 
2.53.0


