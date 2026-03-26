Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CBB9910AB82B
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 22:24:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 513126B009F; Thu, 26 Mar 2026 18:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4EAA86B00A0; Thu, 26 Mar 2026 18:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4003F6B00A1; Thu, 26 Mar 2026 18:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2E2A96B009F
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 18:24:50 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id EA9E88D53A
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:49 +0000 (UTC)
X-FDA: 84589645098.27.7004FB5
Received: from mail-pf1-f202.google.com (mail-pf1-f202.google.com [209.85.210.202])
	by imf11.hostedemail.com (Postfix) with ESMTP id 095214000E
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 22:24:47 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mq4LZ2Ck;
	spf=pass (imf11.hostedemail.com: domain of 3LrLFaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3LrLFaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774563888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nCgdcXsysKW/U1BkGMVZDbqNfZApi8yNye51/HQjjFw=;
	b=EoRs3GW2R8hVkuEiT4Of17cmX0anhQs2JUIwEGe9rBCnTI4+EVvaHyW+1ZF7E/w+c5xmgB
	91mgb92geeMhIpmgCKyD/48dhplFr8ikx9jbouBwRnwrtA/MLk2uYD6yxlln2EQ6M52xQ9
	8p83VNcxslQbK5ovCgMDX9w/gBl9o+k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=mq4LZ2Ck;
	spf=pass (imf11.hostedemail.com: domain of 3LrLFaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com designates 209.85.210.202 as permitted sender) smtp.mailfrom=3LrLFaQsKCP0fhpjwqj3ysllttlqj.htrqnsz2-rrp0fhp.twl@flex--ackerleytng.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774563888; a=rsa-sha256;
	cv=none;
	b=p+8kX1tKblIsUq6TDuRd5UZw4LMh9k/gy2BE99TwGSQ/lnVONIBBy7p5ZLt6uN27veHzzg
	/pYGj8FkT0md6ftTn/kAQTNLBu4VlwTT/KtBAJSO0TlkyIJtfHRKsooeeSgaJfWzDtWYus
	ZsXOfK3Uh2w0llX7v1qi1KHXRoN4wHo=
Received: by mail-pf1-f202.google.com with SMTP id d2e1a72fcca58-82c70d1f65aso1085958b3a.1
        for <linux-mm@kvack.org>; Thu, 26 Mar 2026 15:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774563887; x=1775168687; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=nCgdcXsysKW/U1BkGMVZDbqNfZApi8yNye51/HQjjFw=;
        b=mq4LZ2CkpkhqB4tg2GWYMQb093nnqTiDwogrVWkYMEE8kEK9UVk/OwjKw1z7qucqcB
         mDPCRPr4CGba7qz/rLzSk43U/K+OBWKnjEmrLBbXgz57VuEUbBkCI1Ru3B7HiBA7gE7c
         acA7pTlQvbPd4g1/48T2Q/LzPoS6Y4kXt7miSUN1KjoSsqWvjo03AZh0KrkNMrBVUW3q
         3f1g74OCXlPZKv197+iRdsg3QNXcz84NDF7E4C1xoD48TzuPWaURDz0r3/YejhPwreZz
         2lELHmkAfvV83kJPsPAKK4cSY3SuPyqDu8hyGhsWBUcIKBrfkF/oFNzc+FyFkm1TvKfc
         rDjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774563887; x=1775168687;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=nCgdcXsysKW/U1BkGMVZDbqNfZApi8yNye51/HQjjFw=;
        b=PVI6NK2QvBcHimoVVo3fBETH8EMeWbUeX2qCiiGX77Co7CBSe5Ht75TFsGhkaVH/Q2
         l/+kNwdFrqUlV2PIgpRzOPI4wLf6LB7WOjRimW+lyuCyo6bnOxkqiBDJ4LPauiiWYoFU
         Nvd7ncNyttGz3j6DSowpCDOf5dCsQSNe1GYPqsQGqmzCyxJvL6dQL7Kt1/2EmbZulMCw
         JLpyR90SXSvvHixQjX4lX+iT7KHXdq8VF1M438fug5DPzJ2j6w0UmDFacN5A3E2hAbyt
         X1za3p8bt8ZgGeAklYAEsL6OI7lwuL8HUdFHHAnsy7KWCv6vMeoZzkN07a/3LZTPXxLt
         47IQ==
X-Forwarded-Encrypted: i=1; AJvYcCXeJFuqoSiVkQeCXThaRgNLSii2AadlYjoAO6pZ1ZWDH/CizxI/AS9wUtbtG9cgUamFtBhRf7I74g==@kvack.org
X-Gm-Message-State: AOJu0YwoWTy6LtwpZs72G2bV+dXnNIqFXqu7o/agsEynlxA+WQHPq/CM
	ffGPOC6e+dvvgRTBUw2YeYUzyjLFvNKAn2cwPO4VV0jDSvRbaMRDF2Zhd2uAANDl4KY1RH8JZmz
	XY2Jy7ilPM7ag3fhrhoLUbUoBfQ==
X-Received: from pfgt12.prod.google.com ([2002:a05:6a00:138c:b0:829:7493:545c])
 (user=ackerleytng job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6a00:1c96:b0:823:12cb:f5d1 with SMTP id d2e1a72fcca58-82c95d35b57mr160274b3a.6.1774563886617;
 Thu, 26 Mar 2026 15:24:46 -0700 (PDT)
Date: Thu, 26 Mar 2026 15:24:20 -0700
In-Reply-To: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
Mime-Version: 1.0
References: <20260326-gmem-inplace-conversion-v4-0-e202fe950ffd@google.com>
X-Developer-Key: i=ackerleytng@google.com; a=ed25519; pk=sAZDYXdm6Iz8FHitpHeFlCMXwabodTm7p8/3/8xUxuU=
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774563861; l=3273;
 i=ackerleytng@google.com; s=20260225; h=from:subject:message-id;
 bh=ZJiMvoi/meyCAH/H680tKhOQBTf6lB9IuvXAsiQfyOo=; b=WRe5ynfWZSuX+kx9jMY0JasXB4rIPKpI9ql6ibZPHFbe+yzbcDGcpqU1uX+402hGD156NdMiH
 L7DiNdokHKID+cbe2SXtvZ5GHdpaoaiPi/BbdGDX1VVbt0wzzcHVT/X
X-Mailer: b4 0.14.3
Message-ID: <20260326-gmem-inplace-conversion-v4-11-e202fe950ffd@google.com>
Subject: [PATCH RFC v4 11/44] KVM: guest_memfd: Handle lru_add fbatch
 refcounts during conversion safety check
From: Ackerley Tng <ackerleytng@google.com>
To: aik@amd.com, andrew.jones@linux.dev, binbin.wu@linux.intel.com, 
	brauner@kernel.org, chao.p.peng@linux.intel.com, david@kernel.org, 
	ira.weiny@intel.com, jmattson@google.com, jroedel@suse.de, 
	jthoughton@google.com, michael.roth@amd.com, oupton@kernel.org, 
	pankaj.gupta@amd.com, qperret@google.com, rick.p.edgecombe@intel.com, 
	rientjes@google.com, shivankg@amd.com, steven.price@arm.com, tabba@google.com, 
	willy@infradead.org, wyihan@google.com, yan.y.zhao@intel.com, 
	forkloop@google.com, pratyush@kernel.org, suzuki.poulose@arm.com, 
	aneesh.kumar@kernel.org, Paolo Bonzini <pbonzini@redhat.com>, 
	Sean Christopherson <seanjc@google.com>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>, Steven Rostedt <rostedt@goodmis.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>, 
	Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
	Shuah Khan <shuah@kernel.org>, Vishal Annapurve <vannapurve@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, Vlastimil Babka <vbabka@kernel.org>
Cc: kvm@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-trace-kernel@vger.kernel.org, linux-doc@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	Ackerley Tng <ackerleytng@google.com>
Content-Type: text/plain; charset="utf-8"
X-Rspamd-Queue-Id: 095214000E
X-Stat-Signature: jrc3ihnzs1dinmmcjtaazzqihse3z7rh
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774563887-376009
X-HE-Meta: U2FsdGVkX18MFHsTU1r2IPEzM6RXkFpJNgvOwoNrpSxzOadokbe7WwAg8tCghePcJKpo5YO+sGS+UNd1YC6xHQTlJF9wu+fnrvwPGxR0HS1Rw0vRzGZ0771BCj/ZAz7jo75qigjd+Hm/glPurpcJ6VaGSl/+Yki43/fQA09Jpaxlsj3M5e6R1zgSi5vwhxpHdJig8VRGLFpBPxADI+IGujYSXNaOTMEQLg37TzGUJtQy8+q8Vohax0wm9P7/RZKeA4XAkSEE5JyKrDJoQ2tLTTIofeyVx/WXP1JP4e4QVzn0CCekROkAD0st61EmHRpCHmRtIU17sTDghqlLj2nf/h1F1FLpBayQd8/kSQRQrmhbFrfaUKkXR3JWZ0VwwPwK0Fd7M1gQZIvl4ccAEhmUCulL49UBdgN9ZTEDuOx+ihqFkvBk0lC8IuyKAvBSciDyA4wO9gRWnN1UFUHI7Ya7L1rxm21VwPfdgAa+HdehSeUyPsLT6yOWKc6zXio5/9oifDKf362cxgzqU8bnRyhh/HcKxEDUdnak3REH4Cs4sQLbCsG7KWzLccIAMna72DPsUURVb4oSJAnTm3XuwNFci9BYs99bXhLakVZpTm52OhsMc+Nc75L8pNIt5X8fjlO9KML1EoucxMOHsxnzzN0sd32wDBVE/25pJYtiHB1ZMye9iG6yYuvAQKL07Et1TXpksmxYlYH/u3KrIcefTm0+y9UpHSgfKzlV0P4ON9GDZ3wztumRDX1GKV+GslKSMyq/wjKHFxLXC7zVxa4zG8oqjGf/pXxkTvM68Gmn8zyhMmnOIJInEle91EQp7yGLQN83AxANHgVwfU4G0cwRI2JBl2p0eTS4Z1bBZbDGuzKE6/PRrukyQUxNVf0ggONqTH+nmHl2GxyGaUR5AErLszQxe+3DI/AmqMFmq/5HlXikaUD2/Bh7rLEM4RHyANbu59usuzStbOmJaO99GUtmIUU
 nHkR7bs6
 JBXhHWpDPvULemebe+ay+HtzxNX96Pzn4Cq64NvrB5N1DMnK8wN1vwHpRQVp63v1stre/zjYERFt5PML4b9PuqhvKxU5FN0dJqRA1KZeXHn7UiqmHr+RSrOGIXlAsY6nNk4xYBTbA1brfybViiyafP5fv8lO1xJeE3MwpK+/o75xvquVQ1N5qlZxH5kBh1KNYtECMezPzobCRTzLx7r5uXyGFoerJgXZ6QVVWSHjYin8bmAKuSMnpMpL0ntUa/lalM4fuG3Hg26wj3kC2k0d+ue5fFLCHKtYEcFTNzc3X2dGpjiUXYSv+zJY1oJPghFHpiGXkaFa8wWLimA143nb56XBNhCKR/roWPOC6bG3Q2ZmKiN/wgVsb4C/70u0t9Yzt9xllsllKcXSu7XKsEHIm2OdRj8+8B6s1Hk1OJ2BjcNzIa5FQxh3dRfM+smeb9+kEqRF19RTYaUGyI1ZW5CsEPz0xYzl1EYM0iFveAOM6KyKF1ktvFoDp5lJp2ZI1avq1adPViKR/zfhOtJzxw86xc8qjj108VjLMckd6N+xTZIhuq6FcOz7RtaXYUYpmnmoHsQDaO9+2g1HXVx+wEfs9kfDVYFWzSvpLBQH9TYZUtaTQx2n7KoQvhlBA9tI03/7eZCPK3ekOepSfo8os+SV9dXddYvY7KSeNU/g5m4qsxFU4ImxChPCYhwRAJtfrAFP8xsfPRlUSvS0oyx4Ya3MdS/l8bw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When checking if a guest_memfd folio is safe for conversion, its refcount
is examined. A folio may be present in a per-CPU lru_add fbatch, which
temporarily increases its refcount. This can lead to a false positive,
incorrectly indicating that the folio is in use and preventing the
conversion, even if it is otherwise safe. The conversion process might not
be on the same CPU that holds the folio in its fbatch, making a simple
per-CPU check insufficient.

To address this, drain all CPUs' lru_add fbatches if an unexpectedly high
refcount is encountered during the safety check. This is performed at most
once per conversion request. Draining only if the folio in question may be
lru cached.

guest_memfd folios are unevictable, so they can only reside in the lru_add
fbatch. If the folio's refcount is still unsafe after draining, then the
conversion is truly deemed unsafe.

Signed-off-by: Ackerley Tng <ackerleytng@google.com>
---
 mm/swap.c              |  2 ++
 virt/kvm/guest_memfd.c | 23 +++++++++++++++++------
 2 files changed, 19 insertions(+), 6 deletions(-)

diff --git a/mm/swap.c b/mm/swap.c
index bb19ccbece464..4861661c71fab 100644
--- a/mm/swap.c
+++ b/mm/swap.c
@@ -37,6 +37,7 @@
 #include <linux/page_idle.h>
 #include <linux/local_lock.h>
 #include <linux/buffer_head.h>
+#include <linux/kvm_types.h>
 
 #include "internal.h"
 
@@ -898,6 +899,7 @@ void lru_add_drain_all(void)
 	lru_add_drain();
 }
 #endif /* CONFIG_SMP */
+EXPORT_SYMBOL_FOR_KVM(lru_add_drain_all);
 
 atomic_t lru_disable_count = ATOMIC_INIT(0);
 
diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index 0cff9a85a4c53..20a09d9bbcd2b 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -8,6 +8,7 @@
 #include <linux/mempolicy.h>
 #include <linux/pseudo_fs.h>
 #include <linux/pagemap.h>
+#include <linux/swap.h>
 
 #include "kvm_mm.h"
 
@@ -571,25 +572,35 @@ static bool kvm_gmem_range_has_attributes(struct maple_tree *mt,
 	return true;
 }
 
-static bool kvm_gmem_is_safe_for_conversion(struct inode *inode, pgoff_t start,
-					    size_t nr_pages, pgoff_t *err_index)
+static bool kvm_gmem_is_safe_for_conversion(struct inode *inode,
+					    pgoff_t start, size_t nr_pages,
+					    pgoff_t *err_index)
 {
 	struct address_space *mapping = inode->i_mapping;
 	const int filemap_get_folios_refcount = 1;
 	pgoff_t last = start + nr_pages - 1;
 	struct folio_batch fbatch;
+	bool lru_drained = false;
 	bool safe = true;
 	int i;
 
 	folio_batch_init(&fbatch);
 	while (safe && filemap_get_folios(mapping, &start, last, &fbatch)) {
 
-		for (i = 0; i < folio_batch_count(&fbatch); ++i) {
+		for (i = 0; i < folio_batch_count(&fbatch);) {
 			struct folio *folio = fbatch.folios[i];
 
-			if (folio_ref_count(folio) !=
-			    folio_nr_pages(folio) + filemap_get_folios_refcount) {
-				safe = false;
+			safe = (folio_ref_count(folio) ==
+				folio_nr_pages(folio) +
+				filemap_get_folios_refcount);
+
+			if (safe) {
+				++i;
+			} else if (folio_may_be_lru_cached(folio) &&
+				   !lru_drained) {
+				lru_add_drain_all();
+				lru_drained = true;
+			} else {
 				*err_index = folio->index;
 				break;
 			}

-- 
2.53.0.1018.g2bb0e51243-goog


