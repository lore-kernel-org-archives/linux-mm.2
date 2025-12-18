Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4555D6ACD7
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 09:29:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3737A6B0088; Thu, 18 Dec 2025 04:29:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F6C46B0089; Thu, 18 Dec 2025 04:29:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 202636B008A; Thu, 18 Dec 2025 04:29:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 10FA76B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 04:29:25 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C37361A0DC5
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:29:24 +0000 (UTC)
X-FDA: 84232068648.20.72D2C49
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3B44240004
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 09:29:22 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzYkT75b;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766050163;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P2K3+afPCUktaUGfoI5j58XpJEomrprdk2zpsO1N5R8=;
	b=QBNi3VLp64VhQPjURSaLdnH+pxHx/Zi1LL0SoBusHrhKoSHVNkwX7MUC6KkedUUC/UwfkX
	yvxLLF0Y3ZsqEtD5+RxnwEFxQMCbOwYXcd2iii2ybO7Yjx4ZI1AXIvLBzLZHLS7gy1KjS3
	RKf048ynVVCnW3E5/oHpgONOEUbXE4I=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NzYkT75b;
	spf=pass (imf07.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766050163; a=rsa-sha256;
	cv=none;
	b=HZCH+3ghKdoyYw0rSBGq2QYT9nD0IbeVt/qR81HQZPd8kBUDYtdQ5yaEqqeIHWonQ/T1pL
	rQPV6bOwUgHfLD/hicjoKXL37cow7iQKiaaU2mOjVbkLLf3ShplAmCm5f/W8NPfyUJCkeY
	jAU5325vBfWWQn8ycFwYD8pyByjj6H0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3F9AE44252;
	Thu, 18 Dec 2025 09:29:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6AECC4CEFB;
	Thu, 18 Dec 2025 09:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766050162;
	bh=PwfhwNBp4OTVlzrnBYQt+m4yQcf5Ez56MmgeevhN+yQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NzYkT75bJMXUIzr1h1EQdvkNi+7yiwjbuzRLg7JIonZ4kq7iN2GkaOPOarRVTV8Vz
	 A6wqun+XI0Xa+GJdF0SIvRxl3zNPUgbu0AWh96UN/6X7ti/AKtRSIrmQUPk0UBbM43
	 aZhkFIuXQMNjORk/9Ag+soufMSU+0P6Odgap6egDcTtws/1vaNsEmPG+o8Ow+O9ODc
	 D5KZVSmef0biiV5olr6UzsY5dfTz+r52zBFSUcK9mm5R9ZiLvcUWJKHLlC7mFmQNM+
	 dOg6mxI2rZkIsSn+ez3I+7D+ZRmTup+c+kQGQBvM6Lb1yFJKVFg3BWBdAPe3TkcU0F
	 Aq7AnUrU4W0Tg==
Message-ID: <26e65878-f214-4890-8bcb-24a45122bfd6@kernel.org>
Date: Thu, 18 Dec 2025 10:29:18 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/4] mm: khugepaged: remove mm when all memory has been
 collapsed
To: Vernon Yang <vernon2gm@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, npache@redhat.com, baohua@kernel.org,
 lance.yang@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Vernon Yang <yanglincheng@kylinos.cn>
References: <20251215090419.174418-1-yanglincheng@kylinos.cn>
 <20251215090419.174418-3-yanglincheng@kylinos.cn>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251215090419.174418-3-yanglincheng@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 31yf3d375bjf68zf3hho1q1tx7oy7ytf
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 3B44240004
X-HE-Tag: 1766050162-201889
X-HE-Meta: U2FsdGVkX1+IjJ8uzNgM1ieib2h6WBw9w4aUugdHxu+5ltR7aWsTgsb5VKwBsodZSF6Ut5wcx27Za/dsSPVkLTKer4/AqruevAGDITJQm2xW4hUXc2aUZfUnOeHV04JRimsHnwj26s3Za6mUHdLifeP+fG7MF0o2bGSeJMvnA55iaPpm2w/Hh921uDqCPm1FEqcijEJ9FH6Rf2mRvWSMYx7/6X+/2gYqvjGG89GiJ9E1x+0ye99rX1NgDTDMqPnyhVmbWDwQDRWpPk00LVKNZRK6T8CEc6Cs3L+uaz7mN2Sh+QifEChwlPkZSfcHA+Ixh7T+LQIkon4yTLcmrWnXgMRKKt5D9y2FWFFrGjkDVZvuMQ98ll9Ko+cc/kuRkF4mSH0C+ELLfY80o/v5jnJFukD5YLH7S+qeFzLAZoCpO6JDJVH7IRwBRpbiU+2c0XghvIWaY3+FYcmjJ0yrCqFPLzHrP0NLo+2JS7fQQxHFtke0Jp5j7/mAA6FwJXxUZpMHc3ip7azO0D4W+8nImfCN8apUDO/zv5sB0uAb51bp2/LtBwn83ekBGqnE0FGzN+0sKGToJ93K9r0B8mv2AZEVjvpKPDTkLFC4uNNZH1hNXO+nzLwli5PLgX44Ic5qD2Ve6In1eH7gIvfX/mZagrk2flc+pCY0XtDEupuEePRlNlHgGplemDUddcqLY+QyVknJvHMg9I9mX1tPeeBEM+ocz/hlhlQx9Ao7Ap6vRZKUlzmK8XtvQ+JEZVz9cl+HCMO3GY7opd/A3czNAcnCBdheLYgh82buvxPC0p2FJ3NHwx2ckrhRX8pOnL+nq9qRJS0ydIQzKD1YsyoayprVyrtnHsHYh+WLjkkgpZJXL5rhmYzl4xCIKbu5tHpbwAcu6drlrzdEp3W8wPHgBPKAwAvOzYkz43U3ADFkGAHVH7c6bZ0QMrJpYmY6xQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/15/25 10:04, Vernon Yang wrote:
> The following data is traced by bpftrace on a desktop system. After
> the system has been left idle for 10 minutes upon booting, a lot of
> SCAN_PMD_MAPPED or SCAN_PMD_NONE are observed during a full scan by
> khugepaged.
> 
> @scan_pmd_status[1]: 1           ## SCAN_SUCCEED
> @scan_pmd_status[4]: 158         ## SCAN_PMD_MAPPED
> @scan_pmd_status[3]: 174         ## SCAN_PMD_NONE
> total progress size: 701 MB
> Total time         : 440 seconds ## include khugepaged_scan_sleep_millisecs
> 
> The khugepaged_scan list save all task that support collapse into hugepage,
> as long as the take is not destroyed, khugepaged will not remove it from
> the khugepaged_scan list. This exist a phenomenon where task has already
> collapsed all memory regions into hugepage, but khugepaged continues to
> scan it, which wastes CPU time and invalid, and due to
> khugepaged_scan_sleep_millisecs (default 10s) causes a long wait for
> scanning a large number of invalid task, so scanning really valid task
> is later.
> 
> After applying this patch, when all memory is either SCAN_PMD_MAPPED or
> SCAN_PMD_NONE, the mm is automatically removed from khugepaged's scan
> list. If the page fault or MADV_HUGEPAGE again, it is added back to
> khugepaged.

I don't like that, as it assumes that memory within such a process would 
be rather static, which is easily not the case (e.g., allocators just 
doing MADV_DONTNEED to free memory).

If most stuff is collapsed to PMDs already, can't we just skip over 
these regions a bit faster?

-- 
Cheers

David

