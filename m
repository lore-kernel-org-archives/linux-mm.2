Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C23E8F94CD9
	for <linux-mm@archiver.kernel.org>; Wed, 22 Apr 2026 07:27:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 06E066B008C; Wed, 22 Apr 2026 03:27:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01ED06B0092; Wed, 22 Apr 2026 03:27:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4F9D6B0093; Wed, 22 Apr 2026 03:27:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D20A66B008C
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 03:27:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8589BBE592
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:27:52 +0000 (UTC)
X-FDA: 84685362384.25.65F25D8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id A186D40003
	for <linux-mm@kvack.org>; Wed, 22 Apr 2026 07:27:50 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LSO7R61w;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776842870;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l8CwnswrIF3HDiZpCARJrUz5W8Vb/5OI5Z6IZXW/er8=;
	b=12pSqzLmYd0nbn9QZp7+5WdoJ26dMX92iJGxTPTwwwoMD+Hw6OK3wUHlg3Wk/+/cDdjqdr
	Dj118hcAKvuFOVOb8wc42BXjuw8pVEwS6n+4vnPmzlbiqkbZiMr4zyNfdU+rbLXP6AKZIA
	aDt5N77l9uX2O0RAzU1Fs60EdK53VDg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=LSO7R61w;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776842870; a=rsa-sha256;
	cv=none;
	b=pC/el3iC4E1BfWN/VRSdjICuljpDZ/k5ZvaT/+pz/6Av0mNsWHkw12o/gGPhpqAdnoRtxz
	h+gLJQwegWYIpxqS2H80Vs7XWCq54UCKgs3F8jhUGSZC7ND6GI4IU/qnir264vcmRpZQWS
	uYx2h3O/xvXHJJHEAigT8Mh0VSDpHPM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 723FA44379;
	Wed, 22 Apr 2026 07:27:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E814C19425;
	Wed, 22 Apr 2026 07:27:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776842869;
	bh=kyW/H7rmWbDFYKIRV2cP1lpKsHg1XGw394/LBXDvvCE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=LSO7R61wL+aLO6KbAwe0jWoNWM1FAzOzCMNhg8aS2Yo8Z6Sh2e6ZhiEgV6gGZp+7g
	 TKvjymHtBxm13ODqKbgk/8bN+82kmzGGzou1qqNE8IFrtUtjc1Ov1XSqjTClGDsYki
	 XidPsUY42Fs64GVSKn80bxAWxBhpjxni5k4O/Ta211VYccQpQpyNpfCvZLZL0f/or1
	 Sukjag9jvAqv3c941+wWOrAp1H6wCPU01831ivgBotybb7Qoz+CPijLK4zEcLx45KZ
	 IQldhlbIaJrrhBfppaWGoVfa/I35WQo0MMLtRI5zQtXTHHogdNsefN0FtZkdXhvhV7
	 Ek8K4hCZDCNpQ==
Message-ID: <286425bc-e2a2-4e29-abdf-666e798e6cf4@kernel.org>
Date: Wed, 22 Apr 2026 09:27:44 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH] mm/hmm: Add userfaultfd support to fault handling
To: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>, jgg@ziepe.ca,
 leon@kernel.org, akpm@linux-foundation.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <177499585916.169073.8313365481186071940.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <177499585916.169073.8313365481186071940.stgit@skinsburskii-cloud-desktop.internal.cloudapp.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A186D40003
X-Stat-Signature: 1c47q4f6i466ynnqfpt5cdeuksm56ws4
X-Rspam-User: 
X-HE-Tag: 1776842870-359436
X-HE-Meta: U2FsdGVkX1/Vj/YgJrZU7nFuddsF8QXathe23wvQKggIeOyDRw7/NspmtMD1l/Z+kmW2wahaK2o4MJhLGGNiyqLB078XUFPpJxHoTMnmQkVOVD++NDGQ+6TQSvCFmJTV/qthmrgB3ltV9iADjBIjzmZCUsQlL94f3u+1z0nRN+cJY682PlMILY4BWQw+OzSMIMAAnrngjPxvbaZdcE/Qu9E6SYMM5Eg7IWl8PS0i2sbjN131n3K575Wh5TyyIVDt68yhshoI+z8tsFgs0QUqHn5fi5tpseP/xgPtZL63dXQedYz/c3fN29HsZouzOVqMI88fnWS1lfGVk2zRQfmk8lPEqAK3mFwzrjxJjeXSxIk3VkDfj/x/3tuv6EUqDhyon4hBrKL+u6z82DgoVyukQI5NXI854VD5WHiT6c1s2evN5RwnvMFZhhXxnAzK5q/hfKKX22zcpZYV1gRAl2AilL1s/Ukac1J+rh5Bsjt3qrOq564RIfyb0fgoUNzcRzOPgclX7XDBWfAmY4tjszQIDBOGYN2Hed5mQlHliAzHTFZzaKFxFwxK5G62qdmU6R+5t0OZaNQHRi1ICXV4qtCTsSBo/RmEWjvgMiP81VyCnTK0qQoN1YxBDqdF+mmc3RbHzZYYBebL5ORBlPT9lGrGMUcPxEp/ipq2V2wF316yfm9pwF5DFdX0iDKoJk2TrzDngJ6ykUBxMQGshk08OXsu7K6tvkeEIZbue6068HXaZwYDvxsuwoF5LyNNIUqivhU5SnTGwEVnhs2IWgNFrKl9rnlky+bVcKwiQQbmCXrxZSnpQx38ALaKw2lw7FixESTkmoDGbRJ7Zi5USi5pb8aMCnatxIzRb5AAe1Leszhy6tJUzWSAkMEPvYfCjL/V9AKW/qgtvGVFUtVVB1ZZhZIt+RcIUyWuG35BQlcsFzS4Ozkxwxxf0JrbJ3RxiS6Y+C1+he2NKI8EG80NwKtOdrD
 quCyX7oC
 mK4L3QR63yXoELO5lvOTCOHp+IVU4SstoO2syqkgeXNNOp01tEeYjuzK7YVTVLAi/bYK9rrIWXWOCxLvCEH1tATabm4QuI3/GDHfUivWZlg9QAQahaIR/R94uGevDq1g7HC3h7wNR9JBAZREnhGFeDkLTd3EFV+lrCqmZFI3lrZgjwIfe5pZMvqxOQf+zoExS1hV3SsoqmjzP1I380WkXqB2J6fIX15hLeon/Mn0HMlFuE61Vtmbgi4m/FZcTycZKqppJ6u4BCzLIA/kTOegcEralYQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/1/26 00:24, Stanislav Kinsburskii wrote:
> Add support for userfaultfd-enabled VMAs to the HMM framework.
> 
> Extract fault handling logic into hmm_handle_mm_fault() to handle both
> regular and userfaultfd-backed mappings. The implementation follows
> fixup_user_fault() for handling VM_FAULT_RETRY and VM_FAULT_COMPLETED, with
> a key difference: instead of retrying or moving forward respectively,
> return -EBUSY after reacquiring mmap_read_lock. Since the lock was
> released, the VMA could have changed, so defer retry logic to the caller.
> 
> This approach is inefficient for userfaultfd-backed VMAs, as HMM can only
> populate one page at a time, but keeps the framework simple by avoiding
> complex retry logic within HMM itself.
> 
> Signed-off-by: Stanislav Kinsburskii <skinsburskii@linux.microsoft.com>
> ---
>  mm/hmm.c |   40 ++++++++++++++++++++++++++++++++++++----
>  1 file changed, 36 insertions(+), 4 deletions(-)
> 
> diff --git a/mm/hmm.c b/mm/hmm.c
> index f6c4ddff4bd6..d04d68e21473 100644
> --- a/mm/hmm.c
> +++ b/mm/hmm.c
> @@ -59,6 +59,35 @@ static int hmm_pfns_fill(unsigned long addr, unsigned long end,
>  	return 0;
>  }
>  
> +static int hmm_handle_mm_fault(struct vm_area_struct *vma,
> +			       unsigned long addr,
> +			       unsigned int fault_flags)
> +{
> +	int ret;
> +
> +	if (userfaultfd_missing(vma)) {
> +		struct mm_struct *mm = vma->vm_mm;
> +
> +		fault_flags |= FAULT_FLAG_ALLOW_RETRY |
> +			       FAULT_FLAG_USER;
> +
> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> +
> +		if (ret & (VM_FAULT_COMPLETED | VM_FAULT_RETRY)) {
> +			mmap_read_lock(mm);
> +			return -EBUSY;
> +		}
> +
> +		if (ret & VM_FAULT_ERROR)
> +			return vm_fault_to_errno(ret, 0);
> +	} else {
> +		ret = handle_mm_fault(vma, addr, fault_flags, NULL);
> +		if (ret & VM_FAULT_ERROR)
> +			return vm_fault_to_errno(ret, 0);
> +	}

I'm surprised that there is userfaultfd_missing() logic required here at
all.

What prevents us from always calling handle_mm_fault() in a way +
handling return values, such that we will just do the right thing
independent of userfaultfd_missing()?

-- 
Cheers,

David

