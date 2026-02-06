Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4DA6ECD9BE
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 03:33:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E84E26B008A; Thu,  5 Feb 2026 22:33:39 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E32776B0092; Thu,  5 Feb 2026 22:33:39 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D315B6B0093; Thu,  5 Feb 2026 22:33:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BED346B008A
	for <linux-mm@kvack.org>; Thu,  5 Feb 2026 22:33:39 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 367E214071C
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:33:39 +0000 (UTC)
X-FDA: 84412612158.04.233A630
Received: from out30-124.freemail.mail.aliyun.com (out30-124.freemail.mail.aliyun.com [115.124.30.124])
	by imf18.hostedemail.com (Postfix) with ESMTP id D1E651C0006
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 03:33:34 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AjBrFt6M;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770348817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nfwuNC8piLwTY/hUFLM5kDRlEuRZjguUamVqe3iMLTU=;
	b=2FXJNLM1XeilR4r1vANHKfcdaSHym9courhaBA3rwqfzuEiMVOJAk+epN9gr4+vAgeAxyn
	7tNmnVciZ5izgAGAb1rlffg+94kyCd79FOon8Mi07b6fv4zWU9hmkqVgjsFIjgKU4V8umJ
	6c0kFxsepbYe/nLW9lRFQfiv9+ov4eo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=AjBrFt6M;
	spf=pass (imf18.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.124 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770348817; a=rsa-sha256;
	cv=none;
	b=6sa0lUtY4fBVHTz4kmPCeFnAhZ/kLI3Ag2rOFvWvFTGGiINKoFhFHdSV//j/sbM4hukMVF
	qmL45HuSZxNJOn1i8r3bvr/JS4r6CsdOyrZoMDUb/Rd+goUUAOMXcjvZrOLyyVwaTuSlg1
	3mRUQSQygxQwz4cumKMYxzc4MtJCNBc=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770348812; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=nfwuNC8piLwTY/hUFLM5kDRlEuRZjguUamVqe3iMLTU=;
	b=AjBrFt6M97VgKfUdkvHFARu2sacfZuN/Km7CM0IfzpWjFPdrZsVHP5X2D3pZS3NNSfnHUsWeW2a0nQRFx94weYF6EbBtZWAziK9W95L0Q2zxnwEanLnmDFfFidChUoxTgxlNbPQXmNGDJSyEeRb0AmPI8krA+k2Ewk4dL0qMxzk=
Received: from 30.74.144.131(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WydAEKS_1770348810 cluster:ay36)
          by smtp.aliyun-inc.com;
          Fri, 06 Feb 2026 11:33:31 +0800
Message-ID: <3d0f189b-faab-4452-b9cc-8f4e7a15025f@linux.alibaba.com>
Date: Fri, 6 Feb 2026 11:33:30 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [stable-6.6.y] mm: khugepaged refuses to freeze
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <gp3foqukne5ukrssvx64svhcpogmrskyyzjatofstfrl3vplrk@onxbnxdjrswu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: D1E651C0006
X-Rspamd-Server: rspam07
X-Stat-Signature: p4y6ezw4c9qdc33yhankgyr13whyjnhg
X-HE-Tag: 1770348814-430318
X-HE-Meta: U2FsdGVkX18yaucbULrBlqZDIziwq3zyVv744qNjwvns4j+UzqEo+pznRXvD0hVQX2H2/fbJrHIsk4lF2s3F7U2DGY5uRguoYfCiHAe1L6m6VCn/q8637+uzLLmBwRp9bLMuFSy0wm2HFZbgvFGT6reKuuhXIXwt/lTDG2cPR+AosQKH6QbH5FcSjhxsiqlffYzhoaP4AdhmIVJBGyCqaybOSSSr3Hb4zm0nmQxHQAUGp+BhYajBK0/IQoM5gGU8twfCaQe5QE3jcPDSslQ+3PNGF74eX3Qc+yKFIfnNnlhrMlSg78AehacSBiKObsZBHDcpfWcVbfCAR3qm8svgcBi/GknQN8K9eiKiUBiJFLebYdoSwICwAEuqx65Hw/9rGUTBF2zGLcu5M7ZQMT+xvxjbABZdom4uGhmaT2M6MB77IIuBFy+jE9r1M220DaslPV/NJiopUJpvfBPiTQkQSJyrqpyyzXgWjPTV1rRlNDXh18tpy4owp+wr5u/MxGEpMSGhl63RXApf7VnyML8HdSCyXBdYv9uyHeZsvkxHB2crOA3VUgq9C2ySRaq5/TatlEEqfzfQIV3SplIuH2u4t0UJ1BYYiHqB7txpfKyIuHXSWXpicw3b+3h0xtzXBFKIrMMQwadzWAxHTiYYAiJmKBH5Os/6YPGYD+cHdgXmDL/XScAwEDI1wVChpnsM1dNOlCK8+VGyG0AO+yVC2uOc8omHD3yI4B5mmdVOzymsCoi2z45RLtKexCYJ0yN5yQ4OASqbiQdCt2kgqoW8M654cI7ctBx92qTM1dp6z3Ydf266wAFAKavKmojUapSiLHhqqBxntd37tGTN3r56pCnoI+NGACLanIetv4wXpxkI+v7XkdXq5SX02sIFyihDvg3pHAG9b5AQBtsosErPAhbWufhDSLArzvwcHau8V37Y4cr3OhrQAOkVg6uoNchvJv8mIaRCk4kHanndorxAfCY
 tgwJfIw0
 sOkd74tGiZWJ6fXFzYbphB2ISE5zg2a2Gjvq9eVP1xhp8X4ZqTZIxgiUPzWAi9RgRG4iaYvHln/ivJgnDAmBifRegaN7sKpOE9W6ngL0lcwDfyWSmnZ90OdQQ0Z40kmP5/h+EN/wxOVcXsOwIG2I9VoZFjuPRyr7RneCKI6qn/s+lgEXQB5UT3P+zIU7yzbRbRGAC89zPQ3052l45VC4OU4194KGhx2diVyTD2unu7NCFx55ATcZVmVoyzObycfEMvW9YWmVx6NGglsbMQ6Ynq3No+ripTvYfp8MMWufUJMCkKxFJH0vHiaYwGTVp3vhxGnJTIPcdElvESOvccNbJVMXGQg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2/6/26 10:47 AM, Sergey Senozhatsky wrote:
> Greetings,
> 
> I'm looking at a slightly unusual issue where khugepaged refuses to
> freeze during system suspend:
> 
> ...
>   PM: suspend entry (s2idle)
>   Filesystems sync: 0.003 seconds
>   Freezing user space processes
>   Freezing user space processes completed (elapsed 0.003 seconds)
>   OOM killer disabled.
>   Freezing remaining freezable tasks
>   Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
>   task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
>   Call Trace:
>    <TASK>
>    schedule+0x523/0x16a0
>    ? sysvec_apic_timer_interrupt+0xf/0x90
>    ? asm_sysvec_apic_timer_interrupt+0x16/0x20
>    ? wait_for_completion_io_timeout+0xc5/0x170
>    schedule_timeout+0x23b/0x6e0
>    ? __pfx_process_timeout+0x10/0x10
>    ? wait_for_completion_io_timeout+0xc5/0x170
>    io_schedule_timeout+0x3f/0x80
>    wait_for_completion_io_timeout+0xe4/0x170
>    submit_bio_wait+0x79/0xc0
>    swap_readpage+0x150/0x2d0
>    ? __pfx_submit_bio_wait_endio+0x10/0x10
>    swap_cluster_readahead+0x3be/0x750
>    ? __pfx_workingset_update_node+0x10/0x10
>    shmem_swapin+0xa7/0x100
>    shmem_swapin_folio+0xcd/0x2e0
>    shmem_get_folio+0x237/0x580
>    collapse_file+0x247/0x1280
>    hpage_collapse_scan_file+0x26e/0x380
>    khugepaged+0x43b/0x810
>    kthread+0xfb/0x120
>    ? __pfx_khugepaged+0x10/0x10
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork+0x38/0x50
>    ? __pfx_kthread+0x10/0x10
>    ret_from_fork_asm+0x1b/0x30
>    </TASK>
> ...
> 
> The system is using zram swap.  I wonder if khugepaged should
> be suspend/freeze aware.  Does something like below make sense?
> Or is the problem elsewhere?
> 
> ---
>   mm/khugepaged.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index eff9e3061925..fa6a018b20a8 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -1894,6 +1894,9 @@ static enum scan_result collapse_file(struct mm_struct *mm, unsigned long addr,
>   		xas_set(&xas, index);
>   		folio = xas_load(&xas);
>   
> +		if (try_to_freeze())
> +			goto xa_unlocked;
> +
>   		VM_BUG_ON(index != xas.xa_index);
>   		if (is_shmem) {
>   			if (!folio) {

Your analysis is reasonable. When the system is freezing, khugepaged is 
still trying to swap-in shmem to collapse, which prevents the system 
from entering suspend state. However, it’s not only shmem that will swap 
in, collapsing anonymous folios may also trigger swap-in operations.

Therefore, I think we should skip all collapse scans for anonymous and 
file pages in the main scan function khugepaged_do_scan() if the system 
is attempting to freeze.

Some sample code is as follows:

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index fa1e57fd2c46..cfa7882585ad 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -2560,9 +2560,18 @@ static void khugepaged_do_scan(struct 
collapse_control *cc)
         lru_add_drain_all();

         while (true) {
+               bool was_frozen;
+
                 cond_resched();

-               if (unlikely(kthread_should_stop()))
+               if (unlikely(kthread_freezable_should_stop(&was_frozen)))
+                       break;
+
+               /*
+                * We can speed up thawing tasks if we don't call 
khugepaged_scan_mm_slot()
+                * after returning from the refrigerator
+                */
+               if (was_frozen)
                         break;

                 spin_lock(&khugepaged_mm_lock);

