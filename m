Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEDA1C5AD5A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 21:02:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 975B76B0178; Wed, 12 Aug 2026 17:02:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 926E76B0179; Wed, 12 Aug 2026 17:02:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8631A6B017C; Wed, 12 Aug 2026 17:02:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD696B0178
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 17:02:03 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A0F7440513
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:02:02 +0000 (UTC)
X-FDA: 85093839684.24.6891EA9
Received: from smtpout10.mo539.mail-out.ovh.net (smtpout10.mo539.mail-out.ovh.net [51.210.91.49])
	by imf06.hostedemail.com (Postfix) with ESMTP id 0583A18000A
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 21:01:59 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=pixelcluster.dev header.s=ovhmo-selector-1 header.b=tAgVcEJU;
	spf=pass (imf06.hostedemail.com: domain of nat@pixelcluster.dev designates 51.210.91.49 as permitted sender) smtp.mailfrom=nat@pixelcluster.dev;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786568520;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=T9TIIVYfyP1hghPMhmTqChfXDcPUAairEBLRBsUqb64=;
	b=PdRsEsG46afLMQdaElqsXWljKeEjswMVkYVUM0DAv8VxnSIhjGD7aZR8DnS9Vp2/vGqLZ4
	JYdONdSDxXObsiw+vsueTuxRZxjwsLEbIpVjCLeiJ6ljs+Bkb0R1bXjSjH88Toyp17+dfW
	fgWeq6HLm7GrfffG9TdA9Jm8XsMeGUA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=pixelcluster.dev header.s=ovhmo-selector-1 header.b=tAgVcEJU;
	spf=pass (imf06.hostedemail.com: domain of nat@pixelcluster.dev designates 51.210.91.49 as permitted sender) smtp.mailfrom=nat@pixelcluster.dev;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786568520;
	b=wabN+rd1DM/wjYCeCO2n6JsZNmqnNQS5dU26gh5h5gsIoeu4w7m80whSBUJ++zsO04BjjH
	UMKDzKFP2+JMBRcTo/L69STXjkrma6HD6p6cDzzgjZrVFJmVO+4xTpGrBPW2hfqmwGHddv
	PotFszXlJXDKxCMiR+dAi3eVKbHMT70=
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net [57.128.106.70])
	by mo539.mail-out.ovh.net (Postfix) with ESMTPS id 4hL1Bs3dNvz4LdM;
	Wed, 12 Aug 2026 21:01:57 +0000 (UTC)
Received: from director5.derp.mail-out.ovh.net (director5.derp.mail-out.ovh.net. [127.0.0.1])
        by director5.derp.mail-out.ovh.net (inspect_sender_mail_agent) with SMTP
        for <rppt@kernel.org>; Wed, 12 Aug 2026 21:01:57 +0000 (UTC)
Received: from mta7.priv.ovhmail-u1.ea.mail.ovh.net (unknown [10.110.54.185])
	by director5.derp.mail-out.ovh.net (Postfix) with ESMTPS id 4hL1Bs1GNbz7tBb;
	Wed, 12 Aug 2026 21:01:57 +0000 (UTC)
Received: from pixelcluster.dev (unknown [10.1.6.5])
	(Authenticated sender: nat@pixelcluster.dev)
	by mta7.priv.ovhmail-u1.ea.mail.ovh.net (Postfix) with ESMTPSA id 541D5B81AA5;
	Wed, 12 Aug 2026 21:01:56 +0000 (UTC)
X-OVh-ClientIp:88.133.252.134
Message-ID: <d5ea3344-24e7-4834-b743-4dec812ada70@pixelcluster.dev>
Date: Wed, 12 Aug 2026 23:01:55 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Natalie Vock <nat@pixelcluster.dev>
Subject: userfaultfd wp-async support for (GPU) special mappings?
To: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
 dri-devel@lists.freedesktop.org
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-ovh-tracer-id: 16088265245785350599
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: dmFkZTENcapTGTz/DtMtzR+tulh/8IgOfyIAy0E7ZgGfgzt0x74nGHh+Af3SCltyISvAhYfN6Z7W2WI2lZ3YF0HhjPH8NaVRVJWyLTlPnSkCyvKLSsrgx8uQSSEYJmqvFhv9doqO1afN+znBMTHSLsSPTRbm3L40g5TnT0RiDSV2tTBsPCZPvK1g6U+c3VRFTZ8rn7ubQ+L3LBwKIik4bISvuP8+brxWUKsr/gAuWiH8s4gdYxTqJgseIC2pJP/jCh2K+U0UrqM96Whd9X/P8jww509uNsZZpw28RiTl8wYkI6JXilvJ3F1h52e65djX8/xuAvMbzEqdSWOLaKQ5GPiaz65dlwA2Wy64PKJJmFRbPPWRx2i4afiKZ4I+3E90qbeWK9TDyHM9afmrxASKpwfBkQq3Hm6s8ZL1KmZgharmd90YcIHRGvFW6KufR5nr5lc4BSRLfol4pNeefqHmySjGiWXfAdYEFJNBtqKWvdhhOSDtrf0TJWGbH2jVSh621iCYOGFs7vaMAYPjVSGy91UDPiGfQpq/w3Uc8Q9s3oZ/8D9WTyHySxgo35FEtiX6vUfobicwzrFFr6X++cdJ1u+iXaSJaekySfcul/BNAaVMsGSTlbN5FuyC3wZcyMA35dQk8Zci2Hyh8aIxNXJlpERVDIqQh+mvTgs+xX4wd+iIEjq1og
DKIM-Signature: a=rsa-sha256; bh=T9TIIVYfyP1hghPMhmTqChfXDcPUAairEBLRBsUqb64=;
 c=relaxed/relaxed; d=pixelcluster.dev; h=From; s=ovhmo-selector-1;
 t=1786568518; v=1;
 b=tAgVcEJUgwum9/qzkJD9U/EPxozVngErwQYmskct11W/P4U/l8s4hfu6xmNtfV2PysHPtAgX
 9ZdbcxPMWdNJQ8Ub+m8e4AMGWOSrHVPN10ewceX+VHgqYp+cZhO1SQvamUstEa8q1jdzKBY2zlc
 AyL9PTdtuvjW8TZwl4P0JFEHPbiEpdd+yXB81+g+lcXjgtfCxBdvedn7KUtehh2F0tVzgF+ejeX
 yZ5W/6d/9iwC38svX9Dha4JFCLe2w2eWRv8zhtHvyTSWBQXk29UEVkmm9ugphTWDQQ/Tl4TLEEg
 hSawDqVce05rpx62adpjrEQnfz/7/FIVTkQgWI3LR0zmA==
X-Stat-Signature: hkfb1znhuhtka1oawphw6rpye9zdtgjq
X-Rspamd-Queue-Id: 0583A18000A
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1786568519-281626
X-HE-Meta: U2FsdGVkX1/8MYB3ssGSnSXvCjBMohzQbVsYzYAF8T2ZUyYB1/uFcGl6p8Cfdxd1b58eslk/eeWk46N/ALZ4fzen52tixpru7FzFedO4Cv/cErDrGa1kG+7pE6+DsjJCD2rvuMcXshUd1Wk6muJawoevM0xf46E5fBhUpkaz6SKtPd/UMaJ6gg3SDXY1unGdPIgtyfBcgdD/vZtyEcxtK5Wf7y9y0rEUlNLe4UWvUIlYZw6N3HzI6Eork/BwwTzAcNSOHOwJ5zqNNo+kQod+qgTf3P6WeUsyDiMT+jU67uGGFgYidiv3BSQsEX2143BcqlLqZng0EzCan7XjrQ7UcFPEj84ToPp9Kts6ETcEMomobsuCihcfkaYu0LpZ11XNSHkwF6QGjo5AgwjcChHLOeEx2uCsEd1vAWYeqBwbg/vaoubiC1Mw9SKNIu2aY5RBCvnxT+L8exYCGHF74PA60mpD+oWXPEwysyvkM2XjbFPMfgc6ZnpU4sr3dNHpxMynSXFiMq7sIj0+XjI+2SK+yHbTm3B7WtMDdvcTVLlaAasvbhODM7SeRUDDFv08tlItXwFxdjHek9aK7EZ+1OdI/kynRKGjf66WELet4qkbnrYAG4goXoiVfLEReSa7RXH71ARCpFw4RyLEmcIgBNTNzxnt+murWaEc7K+7B9bj+btbp7TFvlRAoaWG8lBAaoaVQBNN1NNRdgoT3nlTzBPRWAJHaTeJpd4WmIjsZm0WgQekk9EV8wNNAvdu4M3sg2srhGRaOS6UEJLxVMDTqxxeg3hvkdOSM2hsrPMGiQw/IJfRw7sSGIKFacNd57yMRxB4Ni5qxUc+2sTE+uPaG2nMma4BE1NDJBKlE39Y7gfVJ/AsKNVp/1BZh/sSpcHUW/ndhQShfXJyfBxFvcLsbFlC+dqNHhUkVjSPc77vtcf4TN9RFdpa11spbOnJHF+YPueul9nhw01N9J9ohUdgHq+
 jcwUJS7D
 zmijzOCzuoIpQwFvqGPWp4oehvBLbWhMkbIFeB4Wl7T14no1/5pnMpYJiMF1V6vZ/pzNpInYFAC9m02iLtn+zrovwHU4BUJ+BtwlzC/bU3umgatNJhq8j6sQcncUR0BHhGpbvR9lSwRLTBI/IKBlF2F5M2xJpgiOfpAQxpM1Ct3Iq4gKw8eNqLbT+PkBgWa3oUebG/zIKw2hTtXJHTwKVJ4fxEPaFmSNjlIGzVk/D2nPAIssqoXD1jFqZFKR2mUjBGSUvVX2CQYalemKKpqvHMrkVg8TtJvSr4Kiv6PvWJpRn65wzeJ7LbIe2gb4Zhl6O8b820HJQDS6MMJwpadjD0dOZrIW2HK3d7jRdRXQY6D5ruYTO3AP83fVAFrb7fOA/95FsWS6TqRrMPJW2gFDp7fKAAXlKi6uy98+v
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi all,

lately I've been investigating some ways to efficiently query for 
whether particular memory has been written to or not. The functionality 
I'm looking for is pretty much exactly what userfaultfd's wp-async mode 
exposes, but with a twist: The memory I'm interested in is GPU memory 
mapped into users' address spaces.

The broader context here is writing a "capture/replay" tool for the 
Vulkan graphics API: The tool lives in a .so that is injected into some 
app at runtime (LD_PRELOAD style). All graphics API calls (rendering 
commands etc.) are then intercepted, making a copy of any call 
parameters and writing ("capturing") them to disk. Later, these calls 
can be read back from the file and "replayed", reproducing the exact 
same sequence of rendering commands again (hopefully leading to the same 
rendering output, too).
However, one of the commands is a simple wrapper over mmap(), where the 
input is a GPU resource and the output is a mapped pointer for free use 
by applications. To correctly reproduce the behavior of apps using this 
command, the capture/replay tool needs some side-channel to know which 
parts of this mapped memory have been overwritten by the CPU, so that it 
can perform the same modifications when replaying API calls.

The only part I'm interested here are writes done by the CPU. The GPU 
may also write to the mapped memory itself, but there's no need to track 
where it wrote.

userfaultfd wp-async tracking would be a pretty great match for this, if 
only it could be made to work with GPU mappings, too. I've been hacking 
around in the kernel and I did get my use case working fairly well with 
only a few modifications:

First, I mostly-reverted commit 3c58f641e81 ("userfaultfd: prevent 
registration of special VMAs") for rather obvious reasons :)
Then, all I had to change to get things to work was add handling for 
encountering uffd-wp marker PTEs on a read fault inside insert_pfn(), 
and allow the PM_SCAN ioctl for /proc/<pid>/pagemap to process vmas 
marked with VM_PFNMAP if ioctl only does uffd wp-async bookkeeping.

I included a complete diff of these changes at the end of this email, 
but their quality is very much proof-of-concept only; it's not remotely 
in an upstreamable state.

Is this something upstream would consider supporting at all? I'm not 
familiar enough with memory management to judge whether there are 
fundamental pitfalls making this whole idea impossible (but for what 
it's worth, it worked really well on every program I tried 
capturing/replaying :P)

Best,
Natalie

---

Here's the diff for my dirty hacks making uffd work with GPU mappings, 
based on commit f5098b6bae ("Linux 7.2-rc5"):

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d32408f7cd5ed..7ac75ac0a7794 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -2426,6 +2426,19 @@ struct pagemap_scan_private {
  	struct page_region __user *vec_out;
  };

+static bool pagemap_exclusively_mark_wp(struct pagemap_scan_private *p)
+{
+	return (p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out;
+}
+
+static bool
+pagemap_exclusively_mark_and_query_wp(struct pagemap_scan_private *p)
+{
+	return !p->arg.category_anyof_mask && !p->arg.category_inverted &&
+	       p->arg.category_mask == PAGE_IS_WRITTEN &&
+	       p->arg.return_mask == PAGE_IS_WRITTEN;
+}
+
  static unsigned long pagemap_page_category(struct pagemap_scan_private *p,
  					   struct vm_area_struct *vma,
  					   unsigned long addr, pte_t pte)
@@ -2689,7 +2702,9 @@ static int pagemap_scan_test_walk(unsigned long 
start, unsigned long end,
  		 */
  	}

-	if (vma->vm_flags & VM_PFNMAP)
+	if ((vma->vm_flags & VM_PFNMAP) &&
+	    !(pagemap_exclusively_mark_wp(p) ||
+	      pagemap_exclusively_mark_and_query_wp(p)))
  		return 1;

  	if (wp_allowed)
@@ -2844,7 +2859,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, 
unsigned long start,

  	lazy_mmu_mode_enable();

-	if ((p->arg.flags & PM_SCAN_WP_MATCHING) && !p->vec_out) {
+	if (pagemap_exclusively_mark_wp(p)) {
  		/* Fast path for performing exclusive WP */
  		for (addr = start; addr != end; pte++, addr += PAGE_SIZE) {
  			pte_t ptent = ptep_get(pte);
@@ -2860,9 +2875,7 @@ static int pagemap_scan_pmd_entry(pmd_t *pmd, 
unsigned long start,
  		goto flush_and_return;
  	}

-	if (!p->arg.category_anyof_mask && !p->arg.category_inverted &&
-	    p->arg.category_mask == PAGE_IS_WRITTEN &&
-	    p->arg.return_mask == PAGE_IS_WRITTEN) {
+	if (pagemap_exclusively_mark_and_query_wp(p)) {
  		for (addr = start; addr < end; pte++, addr += PAGE_SIZE) {
  			unsigned long next = addr + PAGE_SIZE;
  			pte_t ptent = ptep_get(pte);
diff --git a/mm/memory.c b/mm/memory.c
index ff338c2abe923..a06a31f7f45cc 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2698,6 +2698,10 @@ static vm_fault_t insert_pfn(struct 
vm_area_struct *vma, unsigned long addr,
  			entry = maybe_mkwrite(pte_mkdirty(entry), vma);
  			if (ptep_set_access_flags(vma, addr, pte, entry, 1))
  				update_mmu_cache(vma, addr, pte);
+		} else if (pte_uffd_wp(entry)) {
+			entry = pte_mkspecial(pfn_pte(pfn, prot));
+			entry = pte_mkuffd_wp(entry);
+			goto out_set_pte;
  		}
  		goto out_unlock;
  	}
@@ -2710,6 +2714,7 @@ static vm_fault_t insert_pfn(struct vm_area_struct 
*vma, unsigned long addr,
  		entry = maybe_mkwrite(pte_mkdirty(entry), vma);
  	}

+out_set_pte:
  	set_pte_at(mm, addr, pte, entry);
  	update_mmu_cache(vma, addr, pte); /* XXX: why not for insert_page? */

diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index c3adedaaf7d54..aa1553ec5a3bb 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -2114,8 +2114,8 @@ static bool vma_can_userfault(struct 
vm_area_struct *vma, vm_flags_t vm_flags,
  	if (vma->vm_flags & (VM_DROPPABLE | VM_SHADOW_STACK))
  		return false;

-	if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
-		return false;
+	//if (!is_vm_hugetlb_page(vma) && (vma->vm_flags & VM_SPECIAL))
+	//	return false;

  	vm_flags &= __VM_UFFD_FLAGS;

-- 
2.55.0


