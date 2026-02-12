Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 56B50EB491B
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 12:42:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 91F856B0089; Thu, 12 Feb 2026 07:42:44 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D7276B008A; Thu, 12 Feb 2026 07:42:44 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 803926B008C; Thu, 12 Feb 2026 07:42:44 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6D9FD6B0089
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 07:42:44 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 356FE1A014D
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:42:44 +0000 (UTC)
X-FDA: 84435768648.25.033F908
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 78F8B4000C
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 12:42:42 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISOEqVa3;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770900162;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4aN0n/stHIDSrcfz4S9sCl8VTa6J0duIgqhiRPpFEVg=;
	b=AGFIAd3+QbhtjrcvC6+62xR0/ZR9SjHOcY3+fkSmzHx8uD7/LgpGO188thFlyaAyCerj5l
	YuGKF+Ef29EjBtGwskasXNSD7JOmMCEo8dLUlHC0BKuNdTyJFo9d/8tWRK3N8V/O1Xoptu
	EMFpFTSmFhtjaL6JQITlyohf2Pess20=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=ISOEqVa3;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770900162; a=rsa-sha256;
	cv=none;
	b=4UUmSTn1KbU7d44h0C5ycpDhu3xUyzj8zb6uh7riKOVK7nwwM6OZ48rMFy+U1rZcI0QCzy
	3+Sqw48xUQprMQpQPl8v1Ack17FOd//TpuAxkfYVNBLwGaF1u8hFkFcByUw3uuDOdMOu/a
	MK6nfwp2F0SoqgF3gfXm+JE6IFMoZIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id D3BCB60010;
	Thu, 12 Feb 2026 12:42:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48B75C4CEF7;
	Thu, 12 Feb 2026 12:42:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770900161;
	bh=wmTC1zu+zmunjiFksRhBkChGjxTo30uCWZ1S6ET6yuY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=ISOEqVa3YZ/Gs/St4vAPo3iDSwGIKu0JbJijbAGxag/+gbsim8Whh2tTquG3A06z+
	 JZMlYovC0qX6jEecChJgzyRtvlSxKPWTN5e3M/XwwQ9fP+/cbXNQ7iRcmnLQVO2ENX
	 IhWmc2SZCt7VwlxTwR33Y+fjNabKSjQc7WRffdu9AohH/wtbxianQ0a1tsfIVcY2a+
	 N22NVCBXxMd8HJNxZpp5DlKT9aDN5bO5wlvGFkT5GGID68d5E8sT7Y39N0Qq5Ao8tm
	 JsGxwdMfPwRoL/HxYGBRUhd6H9iq355rDWpFui5n8G2D/L/BKbeXJug7Ch0jLwZfVr
	 1zFLCvbphdOQA==
Message-ID: <94a21bda-5677-4949-a1df-3f0d90348021@kernel.org>
Date: Thu, 12 Feb 2026 13:42:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] smaps: Report correct page sizes with THP
To: Andi Kleen <ak@linux.intel.com>, linux-mm@kvack.org
Cc: linux-fsdevel@vger.kernel.org, akpm@linux-foundation.org,
 willy@infradead.org
References: <20260209201731.231667-1-ak@linux.intel.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260209201731.231667-1-ak@linux.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: q8rwzmr9ut1to5caiss5ypiah9hax4sp
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 78F8B4000C
X-HE-Tag: 1770900162-317486
X-HE-Meta: U2FsdGVkX1/o++c9qHgok+fDfs53mUjGpHxy03n30ICMG2AFN7Q5mv/M5UzWHUekcbssaGjebNWk7fbxxcRG0OWEmrfopL7G1nKMRNm3kU8e3OdDN66nAE2we06GS/qR+VjlIxQ2v4OQ4IKAneStQvEbG7Cze5subvOjPEH2YMhKpugICuNonS5mR8ktUB8pE+5AnXniUayyj7rNK6r2G6oAE2nfBKkVvabxq9yo80DS6BebnRHl8nTfvF0+z759s1kntqPTHn9zHDGS9NmdrO3VQvF6WX8yHRblDqhI+mQEbrR0i/EOKFG1fS3OXVy+22r4dhQnucEOWfbwslZ5Jty6MbLepjlg3cb5sQEzGjR8/NVy4gAEzLA2Kc67VtGKRbtON3vsDz3BXWYfpzect3OpEnUQe6csU2/qr0jfEFHFIBKcELH8Du+KoDP8wUr9NQqFqnPprhbB+D+eHlQs3ga5iJsjN5dJbC9JGyKDA+X/BUBqdCqGbdjmHWgruKqGJ1hpPWQdvvDhzlncoIfRSp2Fx6EOzmIx8hOTFBg+NxAabfrtQxKf8byIPIOvcyf959qJogtqC4sfwHjF2ScBKlqkqPkbhDfoRY/aVX2h7qj7sbYeLze32rI5vQyjeDumsbN+JCdLqVntYqSiPXnt1RF2frOiloz2o37NLwAoRfN0Tn2Cp0yKtWl95yt6oG8srfh53ozkeUxE2+A5oDA5Jux2ro87C4QrLpcAGgQtTSb714czd4KzzzM4tjSvifm68785Y+Y3CXaVARdqExEVgPL+sMgI+eSZp2mOWg2MEGy2v+SikhOJsjQdL5JQvyRsF/gFiQdZi3NUKGeslDfCd3lYDhXffQrfGxZv4Cxz+3Ot+VdNobfMsXEGPT48al+2CbrM5wbrI81P/8hYqmM7DVvYBxuPeopeT6zsWkoHrbajTCYOS5BsLfd9ShALsx+5zh3hmahLdrPdF2e5cOb
 A7w6ksP6
 B4pBV+C5I1f6iCkCpgftrtuGTopj04YBlzxbNLEGLh/Kdt7lPx723iNRseqef0hzqN5X75DBZBtfZrmbIc981P/BiaT5A1VD6d+2Sg0DOgFFDxjRh+qfYfKRS32YXqtaii7VnzMDhnljcSjNPWHvDSpKfvkSvge6ZUcLuZs30Fg3UBPRoTZO9b7VQYxZs1ALnaW8mVDXA/3cmynUiBOSYvDJZWcC1cuGBNB8/ZbIM5L8vTOeHnAl2V8SdK+HYBc5tSx8K3LSLVmsJsgdmVj0rWXR7lw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 21:17, Andi Kleen wrote:
> Recently I wasted quite some time debugging why THP didn't work, when it
> was just smaps always reporting the base page size. It has separate
> counts for (non m) THP, but using them is not always obvious. For
> standard THP the page sizes can be actually derived from the existing
> counts, so do just do that. I left KernelPageSize alone.
> The mixed page size case is reported with a new MMUPageSize2 item.
> This doesn't do anything about mTHP reporting, but even the basic
> smaps is not aware of it so far.
> 
> Signed-off-by: Andi Kleen <ak@linux.intel.com>
> ---
>   Documentation/filesystems/proc.rst |  2 +-
>   fs/proc/task_mmu.c                 | 14 +++++++++++++-
>   2 files changed, 14 insertions(+), 2 deletions(-)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index 8256e857e2d7..7c776046d15a 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -483,7 +483,7 @@ entries; the page size used by the MMU when backing a VMA (in most cases,
>   the same as KernelPageSize); the amount of the mapping that is currently
>   resident in RAM (RSS); the process's proportional share of this mapping
>   (PSS); and the number of clean and dirty shared and private pages in the
> -mapping.
> +mapping. If the mapping has multiple page size there might be a MMUPageSize2.
>   
>   The "proportional set size" (PSS) of a process is the count of pages it has
>   in memory, where each page is divided by the number of processes sharing it.
> diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
> index 26188a4ad1ab..9123e59dcf4c 100644
> --- a/fs/proc/task_mmu.c
> +++ b/fs/proc/task_mmu.c
> @@ -1377,7 +1377,19 @@ static int show_smap(struct seq_file *m, void *v)
>   
>   	SEQ_PUT_DEC("Size:           ", vma->vm_end - vma->vm_start);
>   	SEQ_PUT_DEC(" kB\nKernelPageSize: ", vma_kernel_pagesize(vma));
> -	SEQ_PUT_DEC(" kB\nMMUPageSize:    ", vma_mmu_pagesize(vma));
> +
> +	/* Only THP? */
> +	if (mss.shmem_thp + mss.file_thp + mss.anonymous_thp == mss.resident &&
> +	    mss.resident > 0) {
> +		SEQ_PUT_DEC(" kB\nMMUPageSize:    ", HPAGE_PMD_SIZE);
> +	} else {
> +		unsigned ps = vma_mmu_pagesize(vma);
> +		/* Will need adjustments when more THP page sizes are added. */
> +		SEQ_PUT_DEC(" kB\nMMUPageSize:    ", ps);
> +		if (mss.shmem_thp + mss.file_thp + mss.anonymous_thp > 0 &&
> +		    ps != HPAGE_PMD_SIZE)
> +			SEQ_PUT_DEC(" kB\nMMUPageSize2:   ", HPAGE_PMD_SIZE);
> +	}
>   	seq_puts(m, " kB\n");
>   
>   	__show_smap(m, &mss, false);

We have AnonHugePages:, ShmemPmdMapped: and FilePmdMapped: that tell you 
exactly what you want to know.

Especially the mixed thing is just nasty.

Once we go into cont-pte territory (or automatic pte coalescing by 
hardware) it all gets confusing.

Sorry, NAK.

-- 
Cheers,

David

