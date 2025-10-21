Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C1FE1CCD184
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 08:53:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1FA028E0018; Tue, 21 Oct 2025 04:53:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A9588E0002; Tue, 21 Oct 2025 04:53:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C0008E0018; Tue, 21 Oct 2025 04:53:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id E89F68E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 04:53:44 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7B1D258825
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:53:44 +0000 (UTC)
X-FDA: 84021508368.18.812C303
Received: from mail-m2492.xmail.ntesmail.com (mail-m2492.xmail.ntesmail.com [45.195.24.92])
	by imf07.hostedemail.com (Postfix) with ESMTP id 34A6F4000B
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:53:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf07.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.92 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761036823;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references; bh=mMZlYmMD+XhlkRmbbcKkVBfZUtqiR7wxpGdQMUPrbMI=;
	b=7dJinvCCoYDbEwoW3yL8ijNBtIEBE5ri7jxy0AnipkhguEVmZLKw6PwuMnrGunYZnWlmaQ
	/V5lIkeoyG9HV4xn2+tPSZJ3gB8FJ/kKXawCHcMFqpQ8XBvcgi//ZM9Nor9IS8+RZOTa6g
	GAwY2b1pqsgEmpBwmYTq2jZ9n+h9c+w=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761036823; a=rsa-sha256;
	cv=none;
	b=G+96X72AAs0pXwu2NulC4Ihnj8kmsxzxm9LPyX56TJ0neGjhzggG69CFb8Q8Jbne44NMDm
	3B8j2wvaSrAVwOGUeEYVIkzvrwvo8mjLxQxSaw4USVV4kBe4p32LSFf6s4DSbHBD/qyW7b
	QIZnxaecC5X6Kv4OrjUoM2Wu/CMPnDk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=easystack.cn;
	spf=pass (imf07.hostedemail.com: domain of zhen.ni@easystack.cn designates 45.195.24.92 as permitted sender) smtp.mailfrom=zhen.ni@easystack.cn
Received: from localhost.localdomain (unknown [218.94.118.90])
	by smtp.qiye.163.com (Hmail) with ESMTP id 11df8098c;
	Tue, 21 Oct 2025 16:53:36 +0800 (GMT+08:00)
From: Zhen Ni <zhen.ni@easystack.cn>
To: akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com
Cc: linux-mm@kvack.org,
	Zhen Ni <zhen.ni@easystack.cn>
Subject: [PATCH] mm: Refactor vm_mixed_ok() for more maintainable
Date: Tue, 21 Oct 2025 16:53:28 +0800
Message-Id: <20251021085328.1900589-1-zhen.ni@easystack.cn>
X-Mailer: git-send-email 2.20.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-HM-Tid: 0a9a05f9511d0229kunmd1c93becb17f33
X-HM-MType: 1
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgPGg8OCBgUHx5ZQUlOS1dZFg8aDwILHllBWSg2Ly
	tZV1koWUFJQjdXWS1ZQUlXWQ8JGhUIEh9ZQVkZGkwfVkJCHR1OTUtPGR5DT1YVFAkWGhdVGRETFh
	oSFyQUDg9ZV1kYEgtZQVlJSkNVQk9VSkpDVUJLWVdZFhoPEhUdFFlBWU9LSFVKS0lPT09IVUpLS1
	VKQktLWQY+
X-Rspamd-Server: rspam01
X-Stat-Signature: iqcyisqum1khidc518cr189hi68zg53w
X-Rspam-User: 
X-Rspamd-Queue-Id: 34A6F4000B
X-HE-Tag: 1761036821-588583
X-HE-Meta: U2FsdGVkX1++DpJZJNJ3x50vizx7GFCbh1L+MHiV669vVl4HM2XxzgWcvT/+lP+Lc6Ik7lnvBmwIIGxUQaml2zU530cB6dr1DV2Gmxch8oeHReUlDWE2SpLQyTOn2MU9MmH6dRSooEWDxMeWVMWFhlAOEmBniubYNhVUy/yZQs7RGfog6kEgpL2P4Vd6MkWcMClUqHTxTZOAoOYrq0gV6TQSctksNXWNd4HJfwgjQwe9tWFjqrWPDFirl/ohmVCP5ncjHXR1wFfqIRu12IC3f3ip9PWhWJtwy0jil+jLK4crKBT6V2ad39BUL0mO1NskYjcmbDxFCSepEkWRQ456ZE5sxfmsUYYaaHKu7iFPxsUNWH+C6YdxgiHhunJDGwZAF5tXmx9sJAFmVlKQHyE4nlp4i7XDDvqgLhGLNxESqADla1lHm6O4IE3Df22BBBO3YmL3YyVObGdbW6pj+qBJ8abxq94mssb9ulLneHRkfx0CQ2fzGXO410N3RpQytKL8rHfufM+uPO3ESF/q1j9abpp8Aj22E0y2UlI7QUf5igPyaUJyzSgdH0WJmXLm1e33Teh3sPRAOwZEKyK3NHBw6SBVdIrnmZqxYTbWiqJovdBLTW69+fhnhlXUCHaSnj6iIlTNwQm17ekkP1wlGvhixvM8YcPr1eya8GLgjHTW5FELPlh4nRETxtM8gSqp7ZX5HqtyB7kbZKnAzmjz3yxyQ+Oy7RXgatjg+hQfAoDDabJtWX49keuxLHR13XwKlJu0DmGUCI8VRiz4f0kwxsLQjXIxXlE2qwAUxTjDHxKM4uHlPYf+CfIqOJCVk/AO213wj1ybiZOfmrlhxkAoekue5mFwh3MsCds5qHNn/6/lfQr1sCuhHbMqwaTTANQRBOrAd4OCyXQKJRaTfSQHuS6jxIwgIfht4R1oALQgygF2Hq2YnxK5Fx4sz9WPwFVhMaP7bZwpCjnYDLONNXeiM//
 NtppnEfn
 ERhPjuJbIOfIFA+YPOYV7lV+p1TgDh0o18gZGoxfAAYX0ybj4ylJG4Jh9Y4dahH7Z7VdZf7exv5+A+h/lGAGIibHbh5man/KF+sJy/QiUTkqYqHjVc79aslHFgIwyT1PCSV34pQRzzrqsJ/EgpB7sjYmNjOwAwT8EzBY4lnBy3Q+es2q0OkKOPJiIxg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000033, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Restructure the function without altering its logic:
- Check the VM_MIXEDMAP flag first as a fast path.
- Consolidate the zero page handling logic into a single, dedicated
block.

These changes improve code organization and maintainability.

Signed-off-by: Zhen Ni <zhen.ni@easystack.cn>
---
 mm/memory.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 74b45e258323..4f882c58dbc2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2706,14 +2706,17 @@ EXPORT_SYMBOL(vmf_insert_pfn);
 static bool vm_mixed_ok(struct vm_area_struct *vma, unsigned long pfn,
 			bool mkwrite)
 {
-	if (unlikely(is_zero_pfn(pfn)) &&
-	    (mkwrite || !vm_mixed_zeropage_allowed(vma)))
-		return false;
 	/* these checks mirror the abort conditions in vm_normal_page */
 	if (vma->vm_flags & VM_MIXEDMAP)
 		return true;
-	if (is_zero_pfn(pfn))
+	if (unlikely(is_zero_pfn(pfn))) {
+		/* Zero pages can only be mapped read-only and if VMA
+		 * allows them.
+		 */
+		if (mkwrite || !vm_mixed_zeropage_allowed(vma))
+			return false;
 		return true;
+	}
 	return false;
 }
 
-- 
2.20.1


