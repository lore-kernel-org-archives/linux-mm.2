Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCAE5F589DB
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:27:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 29BA76B008A; Thu, 23 Apr 2026 10:27:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24C436B008C; Thu, 23 Apr 2026 10:27:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1628F6B0092; Thu, 23 Apr 2026 10:27:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 045BE6B008A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:27:30 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8987F885B8
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:27:29 +0000 (UTC)
X-FDA: 84690048618.01.C1041A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id D35DA4000A
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:27:27 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eCuQFsqX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776954447;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ul6hfEDGlhDLgBPG6P5Ep9CMBWO11jZvFumyRmBdYqQ=;
	b=IUJM9fi7v9NKZo3RaO8NLeluvY+hn3D6wp79I82fUoTOE0Q4X6rsYVHlDG+x+wmk4dD55h
	EOEfWq0X9j9weKUTKHjOvnV2BlliOHEgKeYEAq4hejryZUC/+Xa8yoEPObXHTAUnl/NjZF
	HhdQYBK1rVK3MmTGowCcGZMilbRrwjo=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=eCuQFsqX;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776954447; a=rsa-sha256;
	cv=none;
	b=mzQk0zJyAuocZEQ2amQKCM9ZPzZ+juAhyBi2medm+TyfsWd8+x+bOt+e2wrhr5Vmyfwhgn
	ugedgf+f5s1oxw87cquZ0f3rHSampwOTRtjE87v6kXfpCIez5j6KMTdPJD79DrTzRnQItm
	r81DfKfxoYeO3EibRCw93VUN81rYE30=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D41EB60172;
	Thu, 23 Apr 2026 14:27:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB172C2BCB3;
	Thu, 23 Apr 2026 14:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776954446;
	bh=2ZnCInGMmaglcEP4fiF1RXp7oGVSZVQ14PcgFK137SI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=eCuQFsqX0RlSNvadGGdwqeOAq7SEK1GckH7LMbV7URFlMoYrKPKpCEyLLemHVFqQ7
	 vHvoaXG9YJe8+d5/wi5v25ybaLs6vJfcHKYBOyx3sF6d85do50FPIlwMxrCbczoYCb
	 ZQCyOAYXAcw06cZVTttOgm5lN7JCuvuQLovkwLdWyw3pnT0L5ymykHGeUixiyQ7r8k
	 exrr43zrvRu+LM0Fr9YVP8RuXic2UKGegO8eoQmNI1i8d8wlsKV1YvbEo4JDrgeQeD
	 FQcFRE7sVB2vVjSUCGmlPPH+1GCZWObs/yNaiAWpAu8J7YfRZZjvf3eu2/5MlayITU
	 p6l5OyYxPHnxw==
Message-ID: <19f5f950-d0f9-49c2-acf6-7b0ab277ab23@kernel.org>
Date: Thu, 23 Apr 2026 16:27:21 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] mm/memory: update stale locking comments for fault
 handlers
To: Aditya Sharma <adi.sharma@zohomail.in>, linux-mm@kvack.org
Cc: akpm@linux-foundation.org, ljs@kernel.org, Liam.Howlett@oracle.com,
 vbabka@kernel.org, rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 linux-kernel@vger.kernel.org
References: <20260331142936.229667-1-adi.sharma@zohomail.in>
 <20260405171834.15971-1-adi.sharma@zohomail.in>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260405171834.15971-1-adi.sharma@zohomail.in>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D35DA4000A
X-Stat-Signature: ijc6cnxpjmyeqiwxqctof6qjn4ka8oum
X-HE-Tag: 1776954447-780258
X-HE-Meta: U2FsdGVkX18KyP4IthizB2reJ2bL3Bv9ST9lxkDvKS264JAfLEyHX0l8H5MuwepKoR7/bTRWhEzSnD6Byyt1qTuq7PrKTFVcB11aF1uv9go2IUAfX0WbEVtXvb54cqfkO814Crhsvt7156BVIhgUAQ6P8YUFbY6qjGZlP4LcryFqGcQQG1C/j7eMqG1BT7qAzo2+mXsQLxRgPm0PxgpFnF996l6n5tmPFtMALhYZHr9JoHaBBA0lFZD0BV+2Q9BY2qbl8ovaqkMmgIgYkFWtPRcEtjVr1d5dgNojm8GZMPVNESfNfXLRXtwLOx9s1BhQR0Qary0FWNjoKPklEUtSX2XdLTA2Vlr1WN8OtRs47tpFduvmnt05O+hflJ3H9Xa/s3bdGwhDtf34BhWZWpha1TBzYOp6xEY9nwMgtB5/KI6IZZGQjLGkMQr+gs8LMdppH8ZvHDvk/SK6HMNpoyOzhT3tHWQIjCp9itbO0H+i9G6SFydf/Srx1UG3J6+4zNgSp+DfY61HbOfYnLW69hTCyUm6he2zkdiQvdYdft3b9c4a6dzL6Z8fiiDsVy3uMpCuOQeluYfuo3+6Ibyo0FKNj2SFIGoS4tfu66EeYkYr3LHhxsWuTIdXj/HFwUoEUF2zp27PXgvk/J/GL1iOtpaSXOo22V4mXpvbzozLm5sKWFrnTQoB6THnHrG5/BhyXDYAsCmUMproWNyiJ8uz7kIlNpayFtMCZDLj1/gs94uAAMbZLOCdDJrOX63cl6B44PLrgdglyVxmXGwVfTzzTVIVMDVd6M+LY2ae4xqtJrzARA/qwyb9vSAEZiOTBZvsLYs9p92VpPn6G9V5fafYmkBWI0ew2JZREc+H+LTV1mJKCsKCcA4hNqXWoOuSV94Mns+ncCnI0zWYc5Xk531xyaXJ9sAJ8V/FvYNXFnSKbAxPmsnRJmdRXnFhhIeNpbvqzkWKQp9BX/XJllxTmqov7xB
 F4DAyhks
 sSTv83N2soV5ueBo8og/A/IBfercbyVSft6BO8cqO5aP/XtpiTY7sa3psjlJCcBfbtxuKRS2ykqeT0ZXda+TxyhG2Yy7mqtiU4l9pon3Ruh6Yg77qJNSKIBg5/EZJ4meP96X9kQZy5hon//XxMXRzsEs8QMwUw6zuX3xoKbvYL774pfyFcl00dtY5lG12t4qs9u/+c1p+mNXrAR8UwZceMcdQHQZSp6cHbZspoR0yhYQMODj8LV4w7aj8R2fW5exoRlfN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/5/26 19:18, Aditya Sharma wrote:
> Update the comments for wp_page_copy(), do_wp_page(), do_swap_page(),
> do_anonymous_page(), __do_fault(), do_fault(), handle_pte_fault(),
> __handle_mm_fault(), and handle_mm_fault() to concisely clarify that
> they can be entered holding either the mmap_lock or the VMA lock,
> and that the lock may be released upon returning VM_FAULT_RETRY.
> 
> Additionally, make the following corrections:
> - In do_anonymous_page(), correct the outdated claim that the function
>   is entered with the PTE "mapped but not yet locked". Since
>   handle_pte_fault() unmaps the empty PTE before routing to
>   do_pte_missing(), the comment now correctly states it is entered
>   with the PTE unmapped and unlocked.
> - In __do_fault(), update the stale reference from __lock_page_retry()
>   to __folio_lock_or_retry().
> 
> Signed-off-by: Aditya Sharma <adi.sharma@zohomail.in>

Next time, please don't send as reply to your previous version

> ---
> v2:
> - Simplified the comment to concisely state "either the VMA lock or 
>   the mmap_lock" instead of a verbose explanation (per David Hildenbrand).
> - Expanded the scope to cover 8 other fault handlers in mm/memory.c 
>   that suffered from the same stale mmap_lock comments.
> - Fixed an additional historical inaccuracy in do_anonymous_page() 
>   regarding the PTE mapping state on entry.
> - Updated a stale reference in __do_fault() from __lock_page_retry() 
>   to __folio_lock_or_retry().
> 
> 
>  mm/memory.c | 49 ++++++++++++++++++++++++++-----------------------
>  1 file changed, 26 insertions(+), 23 deletions(-)
> 
> diff --git a/mm/memory.c b/mm/memory.c
> index c65e82c86..2b407e3f9 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -3742,8 +3742,8 @@ vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
>   * Handle the case of a page which we actually need to copy to a new page,
>   * either due to COW or unsharing.
>   *
> - * Called with mmap_lock locked and the old page referenced, but
> - * without the ptl held.
> + * Called with either the VMA lock or the mmap_lock (FAULT_FLAG_VMA_LOCK
> + * tells you which) 

"Called with either the VMA lock or the mmap_lock *held*"

Same for other cases.

Can we shorten "FAULT_FLAG_VMA_LOCK tells you which" to "see FAULT_FLAG_VMA_LOCK"

?

-- 
Cheers,

David

