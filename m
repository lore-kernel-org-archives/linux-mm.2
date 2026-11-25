Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 639DE606A31E
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:19:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=oeQU556j
Received: by kanga.kvack.org (Postfix)
	id 7AC346B0AEE; Wed, 25 Nov 2026 17:19:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 75D2C6B0AEF; Wed, 25 Nov 2026 17:19:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 673E06B0AF0; Wed, 25 Nov 2026 17:19:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 44AA26B0AEE
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:19:27 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2C1388016C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:19:25 +0000 (UTC)
X-FDA: 85475058690.08.CDB28E3
Received: from mail-dy1-f197.google.com (mail-dy1-f197.google.com [74.125.82.197])
	by imf08.hostedemail.com (Postfix) with ESMTP id 72A7216000D
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:19:23 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oeQU556j;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 36V4HawUKCCQELKINGOOGLE.COMLINUX-MMKVACK.ORG@flex--elkin.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=36V4HawUKCCQELKINGOOGLE.COMLINUX-MMKVACK.ORG@flex--elkin.bounces.google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795645163;
	b=dzhAy9MMAR1c2Jah5HGUkOBw2HaaQW9UPMR4iCyBNz2zWFMl+PmgKmNyCzLRiiV+euIjGs
	eg/Gy79sKmSh+cgVqDOdCKzk5/4OnCJNlleFdFFscjC40qMitaoZxQNe3itOtt7lcoGmJ8
	BDZGvvWbpQgnq/M8HBkoOMBU+HIJnUs=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795645163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=/mM0J1a71Wn6f8VLov8bY8YKxe1QvMRR/3m9TE5bYfk=;
	b=ukd2HCLHSN3OjHrNw41tVLxiFIqSP4JsA9KR3EIYFYzXjXuIUCZiStAHxCE02TicmT6YM2
	ZFmFjNQN/9DJOjWNt0lvbs13evo/fqCayJLzkgJmGPz0MtmrmRUrGjykkvUJ7V7R2NFnwd
	6Ua1gNnNUD16FD+K3vq5cfL9arxR59s=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=oeQU556j;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf08.hostedemail.com: domain of 36V4HawUKCCQELKINGOOGLE.COMLINUX-MMKVACK.ORG@flex--elkin.bounces.google.com designates 74.125.82.197 as permitted sender) smtp.mailfrom=36V4HawUKCCQELKINGOOGLE.COMLINUX-MMKVACK.ORG@flex--elkin.bounces.google.com
Received: by mail-dy1-f197.google.com with SMTP id 5a478bee46e88-3854627c1c8so8708223eec.1
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:19:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795645162; x=1796249962; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:mime-version:date:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=/mM0J1a71Wn6f8VLov8bY8YKxe1QvMRR/3m9TE5bYfk=;
        b=oeQU556jQe7/ovX/SJMUQT/iPFGdcVIWG9pvDoaxg7otMtbtP/F68P62aU+m3WIf6x
         QuApHvENT4VrDQvbSMqTpbMmo7edKFrBgRjYAq8RWzDbYrogJ0LdpfO0YVnmMZ6fFdMA
         kkaqhnA5jpDMBgjbYVSpBqDbOpXShi+lbv/Rlsnmn4tuYb0hhfWDo9l0ZO/YAZnAuekh
         93cR1/nUp1LJ3xPjldVSieumV0XQ/+u8fJyrxKX+M1ovdFSgPHfxv1ouCtpmkFEGxdV3
         O4ruGmyPNPqfEyzd8qM02cFCMtT1rg4ibL6g8DhW95SexqOdaeBuRWSLx59w08cVhP4r
         0QKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795645162; x=1796249962;
        h=content-type:cc:to:from:subject:message-id:mime-version:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/mM0J1a71Wn6f8VLov8bY8YKxe1QvMRR/3m9TE5bYfk=;
        b=fsQHtJmoJvOuXp9IvjYsGRqFWCPEaDyOjlIdugEyAKesWyJ5fle/kVHaGT4SrbWlgR
         1/XmTWRts8QNPMrW6sU+zN9IGcy3afCZmJNMpf8LjX9uiulztiwl//kn8dXalwMgq5bG
         jJE7WEm4vzwpdMEfwK/cUF+CNPoXMp3C3oA2H46UkC3lygqRlrbHzM3FER/Izcc+NPLL
         1GcSd2cdg1OagrjEZVU+OaOkPyq3fDqGYOPrKbZUzxShfpOYXMlH1oKuQornVxUXPejQ
         RAlrwEKQkwMhCDh8tMqBfAmi4n/D6lL3KOw4yn2htVFAAJVattCcnMYjzSnBpxq86drK
         wV1g==
X-Forwarded-Encrypted: i=1; AL+hErHVDNDwqoyRGYfeeI4ExZBVw5GdHzof/43W6Lgq/R/e4flXQ9W4/RtlNs1FAtcbvenXI8ao46g/Ug==@kvack.org
X-Gm-Message-State: APuU4Z8sTlYwKzBPJ5ljEvGtWbqhQPl9SkU7/lQ6vncwX1gqZ/mjnb7c
	CHsWizXNKu+WyDBNOKxXcqFab4A0kDp+J4O+pYgZhK62S6JrXlSpaAQVxz5P6WsraTfUA4l/rg6
	RpQ==
X-Received: from dycmb5-n2.prod.google.com ([2002:a05:693c:20c5:20b0:369:fc78:c914])
 (user=elkin job=prod-delivery.src-stubby-dispatcher) by 2002:a05:693c:8955:10b0:386:9cae:abef
 with SMTP id 5a478bee46e88-386bf39f8b9mr6889141eec.36.1795645161387; Wed, 25
 Nov 2026 14:19:21 -0800 (PST)
Date: Wed, 25 Nov 2026 22:19:11 +0000
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
X-Mailer: git-send-email 2.56.1.839.g22a8290db9-goog
Message-ID: <20261125221911.1425213-1-elkin@google.com>
Subject: [PATCH] mm/huge_memory: check VMA end bounds in insert_pmd() and insert_pud()
From: Elkin Cruz <elkin@google.com>
To: David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>
Cc: Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com, 
	Elkin Cruz <elkin@google.com>, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 72A7216000D
X-Rspam-User:
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9yyew5hypuitd1ytkctnowiwzjmfyeyg
X-HE-Tag: 1795645163-867902
X-HE-Meta: U2FsdGVkX1/bGtgSojhv4BgmF+ja+H+R9lFoWqkgXsU8OMVN23dcs7Z8M+ZvLnEMFGStSc7qa60dSZPIsWsBHi89+Or0442i/F916MuAV/umiOZ5wttXhQYjw16jZIa4ywjPRm5Do2cT4QfNr4v6C8k3g9ZdMJPT0ZQ8BS4aXwmSsNWwYnmjPCDgRvp6/vrZTe8sApkMszAOSBlt8p682UaamwtO33YoLASykw7UFXA8t5DrXLHTGHqhVGArU27ZxJqdsSJjjNE+fdqHlO3SGfZg/BuzYkkQNuHKRXmvoZxgyfK0lsbipUuHZQtNITZsjOMbU/UoHbkHaxvrf6UYahHJ5gKERlfYL8LACSCP9uvYxYOZJLxioMFBLfjS2UP6yY7Hi1O6eyumvWJKE4NjAuhYzw8shMvhhCrjwqrzKp/yj7XzWKBC9mSrko/+kMvG/+RtU4X7iD3qB4m8wAW/8+l+v1z5pPi+YvB8WevKqsmmabkFb39FIf6GGaEzQetZu6mHgrS4670/P68S7+jN5KHZovW6dwWK/XWiNz6qOP+Ie/RPMJtP/xkQ95E+8UQ/auSYUyZ/Q27chcJ5UxlNpG7Q6kaaNBK2M+NWmiP2aworjBbY1NhLrevXCGnovuV8MbkWd4UDQoO+AXGhzgkJpa/qy+johUyM2cPz7krG5z7G3v5eF0C0MhKncDy1EqJX7m+Ja+shK6qNn0VLBzXd+T/2MxohVEcgHvwnXZYgWGY3TkHPYTh0urgeUcxXqwF64sg+daEzHs0UUBoOsPascNnr6yI6cmllRxdvFbRZaXelW5T1A1VEJHLfCxCuI8Mg8fsFFj6Fok/aO0/Dv04cxcVVVmM5X6LKNkAoDPAQCiF4jRtpo+Z4RyHN5Z7KQbAcG1fmNM+trYrR32ZJtrxe/kpBoXnHUIvvYoOIzHKAFOSIOdg0kROxCBR+Ukqd2y/aryn54rhHj+BmvzqX8nH
 9ziPWjvs
 ey1GFHA3hv/IPzUEEBuElByZ03yCaNyD92ygsPfxbrGVGwySpLVVnMvIwQQ+uXBc2B7ka4v+Xp2pMML7cUgKU4l6/P+88MRLA/rzaU0A+NFVMMEqKQlVDZYNjmUH8QwYfryQgnR8PiBE2RNFKN8A4dtGdpc5C8VKDCbAPFbcUlh/Ev5cHr2zemqjpdKkW7zk4Aqj9ubm8vpu4F7YEEAH/Ew15JUM34OMJQKH4pcnX6PiZwDFl8RoJ88kP3ivmo0xWR2hZN0h/1MhA6Ch+XFatcSF5MvWDl6TB1uShFSE0kDZj6MtZFsgBmLemGD/f/UpLO/sRn1kkoNWSu4HZcS7JHKqhKYkopEoldS/fes86slSunKn9+r0peZndxohTkbXZQrN2BFReEpvRLH7d0ANcd28YKnJzeRSC4WQFtXDLvpsLCQG+8m2CXLUFbqZGcCIVmAP9dHWwUSy5ZUQsuc0nK1H/uZSC5x7ig2jdm7tAU7jPN/r+aL9KebSopFQkf71X7ABxuTSO9WnfmMhYeIsFiZptPRcm+qpletbL4Xs7SZvW1FNHiZtnsmfwK6R5XaHX0eQU8POOSJ0RZ49rVKe2+H2qJXuZeUtOafMrLNNCPxt7a/8a4Fp6vk7jUtdyTJw83EnianJSiEK4qyj56JvRcGQ0gBVE590OwA3CmXKy2f6qwuMGRFoFa0gLSczGZ6kswrmPc4TdHlDCPlh0tMhsG2pyx84EHchDqFERQxvscqyR679uRNIPgTn2PpTMmOnY7AJNZ3zU68LlM2hoIeI11d+MWWi3yLhud7/kqzWGrtI1/6NgQZXRVWmAMApkw2BdeixOQl6q87bBY6Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

insert_pmd() and insert_pud() only check that addr lies within
[vma->vm_start, vma->vm_end) without verifying that the full PMD or PUD
mapping fits below vma->vm_end. On a VMA whose end is not PMD- or
PUD-aligned, inserting a huge mapping at the tail straddles past
vma->vm_end.

Require vma->vm_end - addr >= HPAGE_PMD_SIZE in insert_pmd() and
vma->vm_end - addr >= HPAGE_PUD_SIZE in insert_pud().

Fixes: 5cad465d7fa6 ("mm: add vmf_insert_pfn_pmd()")
Fixes: a00cc7d9dd93 ("mm, x86: add support for PUD-sized transparent hugepages")
Cc: stable@vger.kernel.org
Signed-off-by: Elkin Cruz <elkin@google.com>
---

I am trying out new Clang static analysis checks for kernel bug
classes, and they flagged this code as possibly buggy. The findings
were triaged/fixed and commit descriptions were drafted with help of AI,
then checked against linux-next (not runtime-tested on hardware).

Thanks,
Elkin

 mm/huge_memory.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index e167c9ea4609..683f0c68d6b2 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -1630,7 +1630,8 @@ static vm_fault_t insert_pmd(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 	pmd_t entry;
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
+	if (addr < vma->vm_start || addr >= vma->vm_end ||
+	    vma->vm_end - addr < HPAGE_PMD_SIZE)
 		return VM_FAULT_SIGBUS;
 
 	if (arch_needs_pgtable_deposit()) {
@@ -1771,7 +1772,8 @@ static vm_fault_t insert_pud(struct vm_area_struct *vma, unsigned long addr,
 	spinlock_t *ptl;
 	pud_t entry;
 
-	if (addr < vma->vm_start || addr >= vma->vm_end)
+	if (addr < vma->vm_start || addr >= vma->vm_end ||
+	    vma->vm_end - addr < HPAGE_PUD_SIZE)
 		return VM_FAULT_SIGBUS;
 
 	ptl = pud_lock(mm, pud);
-- 
2.56.1.839.g22a8290db9-goog


