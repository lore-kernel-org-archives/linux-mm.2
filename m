Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBD97EB7EA5
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 10:23:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 660276B008A; Wed,  4 Mar 2026 05:23:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6016B6B008C; Wed,  4 Mar 2026 05:23:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EFE86B0092; Wed,  4 Mar 2026 05:23:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 401326B008A
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 05:23:41 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2A118BD2E
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:23:40 +0000 (UTC)
X-FDA: 84507994200.05.155021E
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf10.hostedemail.com (Postfix) with ESMTP id C6B71C0003
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 10:23:38 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OT+rf5ED
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772619818;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=62A7LeZ9IpCSBCgrNHLXMjzMVlSh0j3tAfN1CDmHNwU=;
	b=ESFILq7mGZc0Bl0KufF/7aeKcNH3pncjqI3/HjpG1nz/v9sfnfbwNwz80uJMuVMgCILL7r
	3fTZufdof9yvYYOc5ZXgrMzPZJwr5Ue0Of7XBb6+pDP1KxDTme8HWLqzm2NbnIb+4jgJ8w
	J+5FvCKPVfYMFDYpF5Kj5r4w++kzQUw=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=OT+rf5ED;
	spf=none (imf10.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772619818; a=rsa-sha256;
	cv=none;
	b=0S3BztbeYqXhualwjsu+QTIP6rTffkKNunP+0ZAgIub3X5gi3z6oKO2C7+71bO4G6yninc
	9L01otgMt8RygZsr4fHuQxoK2VpzKTdXdg1tVOW54mzCk6VlLaxQfdWSy6VuOeIquC8jYW
	3a4/YTMhEyrMKTzjCMX0OZ7YMDc98zI=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=62A7LeZ9IpCSBCgrNHLXMjzMVlSh0j3tAfN1CDmHNwU=; b=OT+rf5EDn/BQXidGHrc0PmRbCD
	2HwOMfFsiuAMNqxNx+bfYsJcpenvNKh0//ey0EunlLAuswzUCHWFpPpC+WA4JBKosBmW4orTNb7mD
	8ATDyZC1Q96BKDEEsPDayfF39P1CemzWEhZOtR+2ZRCTAMnpW2SzN3+25g6XABogxIfUPF6kDKJNd
	WifGiCLgDllDGfpwHunvz9wE53AOhHS5WfrYqTicnmkjyktigxQvaU3wl7dS9lUQYew51oajFoN0C
	RK9wzPtwoZerNmnbOKxrr8CWCoM2IuH4a0pwZtTz63dHlMJBCWcfRXKXC8Ap89pdmqIZxyoiXnFU+
	PkoML/uA==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vxjNv-00Ft4K-VI; Wed, 04 Mar 2026 10:23:20 +0000
From: Breno Leitao <leitao@debian.org>
Date: Wed, 04 Mar 2026 02:22:34 -0800
Subject: [PATCH 2/2] mm: thp: avoid calling start_stop_khugepaged() in
 enabled_store()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260304-thp_logs-v1-2-59038218a253@debian.org>
References: <20260304-thp_logs-v1-0-59038218a253@debian.org>
In-Reply-To: <20260304-thp_logs-v1-0-59038218a253@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.15-dev-f4305
X-Developer-Signature: v=1; a=openpgp-sha256; l=2206; i=leitao@debian.org;
 h=from:subject:message-id; bh=DYGJrnPPlP2gd8MfbcdjO+tkpdphLuDPYa9VQ0u4QcM=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqAgHXd3XgvmFZqVfvSfOACS/eEUJxgb7CLYR2
 N4lClDYjAOJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaagIBwAKCRA1o5Of/Hh3
 bRbgD/4xe2mql9zlE3u+QPlwFTvwUhxUcVOHRkiTki6BrK1R2IPEBYgcPpzUMOny71xKwQht31C
 Jbyvch9ttzyssxsLF9+l/6lprsxFDu8WM8isJk11KhXoxBVNEDhB59zSTwdSecZP8s5hkwzMWFy
 A9fFRa4wYw+UCJAGQ3uwKCY3964CwnxM1kmBi584uwnxCv0HO8ERbBXUXwtGG5LRQHRT3C89ekJ
 O6SQL8Be/AbujIiuWkgYC2+t0jr9rKb6FbG15+paKfbMWkizUYdJTzv5PrDikolb7H+kqLpzgIp
 cEG3FSQWqt18S9/2oeHSG7AnP4BxZn5V0lE8d4ElJVIlOd8fMq5XnPxVHzCjX5R9oGJXejVqA+1
 bQT4tmJGU0/V1t7BXb+A/x06ZN5GbNQ82iSkzxBI8jPywvOhj3v1/21afnTLoRo/TnahNYv6ONk
 MlTbpA75G4GJdB7soF5c/sRLletU9fch4TOLrdBf9GuIwfxZnfhkOIt7eXG5vFYtSbnzt3vIRCJ
 UrPqgmTM2FyAU1RibHViK50b0BWVhpYO98xPwlpVUjTwQ/+mXR4Uq/pANxhVpehmyTcyCFocq9v
 crBagC7gzlJGOaTwonlZBMxNMw/iUtFuc/Y0ikvtOgVmtsYUJhpkPG+oID+KvFL9DS0phU4+hbs
 XkBQnefaXXpkIFQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: C6B71C0003
X-Stat-Signature: 67gx3ahkenfhzjj39cxjqdnhwzibgibi
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1772619818-152257
X-HE-Meta: U2FsdGVkX19GNP0AQ6Ch8E6eoqRk5FPPwVXAgogiOw2CV8f60u51RPzhVIwJqNrCL/w1w+6i71nZckAyCrMBkRDp3CyBQE+vi8yQ/aGjpfL4O0XEjiriBr8UgdL4aKG/9agSDJFZDQvPsvvKHEV7fxE8zRf2e3CbHnIs3GNftMhOjVA8PRuODcUMfq3puYPi3gCFhDfHx0E4rId8qhk0RnPKh0OoIitS54TNDVPih+bP0cPLXruhgK2LwzSBpggjnP2snMXfkGqftu1RMhTbh5rA8RNDD2NhGbH85L36UVtsMEW9qAa01KEkwB8+fWoRZniyVNJ1OuEqYBbKtrUVTw6JpMuhRUUwih5e3K56OljJDcVjFzhxOQtfUkAQ94w6ttvSYM1hlmYW4bvibJqfF2jD3mKGrZBl60CXTEME9vbDvUGjruXuZxbBm+1uQ8uZTHJfAy7VrIRukOLvcgtMlpdwq/HspfOEk7KxzLvEt+gjG2xPz6u8+O/T777k+zS5m81R1QOkUR9mkB89LVwKg1U992KmCBVD7bg3Zt7mn0rPzxvNgfJrAH/d+C6JGzHouvcSyD7B4GYCMC20tPHeV7PB36OeHHftRDTjmJ/0OfRf9LEcP6FLPQioRoYvs2J9gnyFUW+zjqrRBUWykEjLjVCM55kYbCC9dO9gJhH1dwSV2vRRlGRlTuExJBU/SsNd8w7WFnpIruwf/vt3ZpF14h5+gY9CMsvfK/0h47G/+WRTP2XLksNL2lgYcdSwLZjnVp+yxbvXWJ0L+FpxhDz+2lkpnVtmhxM0hm7zhuvSVph8Pbjvzdo9uckOmr5zbtOD+pEvW+0UJFG41KfhAeqT3QD/CaK3QCAclUBZwT7Kd92WuURHXuJk29/p/N1jStsD6OJxNBocUepvrwASZuQaiXvlHkxutdDJr4zh481CXmmggAeLRFs8M28t8LBK6N78AElj2KSEg8X8csnG++7
 kTT+2HHD
 ymy5q9HwMv0Oi1MucBxR3mecdQCrEDjEast65ouKuL4VDBXhNHmW3PpQXo5bZMTZrSIyHTAMjVUjBXl50Vr1Psy1dbL+zZdCGOjkXuiLI4O1cYvQpZPnZKRsLsWE4i2SMNAFUpKO7SOrjHW8EEeaX8lZESHZq6kH959bnBgDvaQUsa79/Fde0VYgEdHK6X5oKJPmCCm1HVPpB2QE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Avoid calling start_stop_khugepaged() at the top-level enabled_store()
for /sys/kernel/mm/transparent_hugepage/enabled. Use test_and_set_bit()
and test_and_clear_bit() to detect whether the configuration
actually changed before calling start_stop_khugepaged().

This avoid calling start_stop_khugepaged() unnecessary.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/huge_memory.c | 21 ++++++++++++++-------
 1 file changed, 14 insertions(+), 7 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 9abfb115e9329..b6ed44b6e8c02 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -320,21 +320,28 @@ static ssize_t enabled_store(struct kobject *kobj,
 			     struct kobj_attribute *attr,
 			     const char *buf, size_t count)
 {
+	bool changed = false;
 	ssize_t ret = count;
 
 	if (sysfs_streq(buf, "always")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
+		changed = test_and_clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+					     &transparent_hugepage_flags);
+		changed |= !test_and_set_bit(TRANSPARENT_HUGEPAGE_FLAG,
+					     &transparent_hugepage_flags);
 	} else if (sysfs_streq(buf, "madvise")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		changed = test_and_clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
+					     &transparent_hugepage_flags);
+		changed |= !test_and_set_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+					     &transparent_hugepage_flags);
 	} else if (sysfs_streq(buf, "never")) {
-		clear_bit(TRANSPARENT_HUGEPAGE_FLAG, &transparent_hugepage_flags);
-		clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG, &transparent_hugepage_flags);
+		changed = test_and_clear_bit(TRANSPARENT_HUGEPAGE_FLAG,
+					     &transparent_hugepage_flags);
+		changed |= test_and_clear_bit(TRANSPARENT_HUGEPAGE_REQ_MADV_FLAG,
+					     &transparent_hugepage_flags);
 	} else
 		ret = -EINVAL;
 
-	if (ret > 0) {
+	if (ret > 0 && changed) {
 		int err = start_stop_khugepaged();
 		if (err)
 			ret = err;

-- 
2.47.3


