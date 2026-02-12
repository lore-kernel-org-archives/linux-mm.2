Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 966C6ECD6F0
	for <linux-mm@archiver.kernel.org>; Thu, 12 Feb 2026 08:44:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E15DB6B0005; Thu, 12 Feb 2026 03:44:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC4116B008A; Thu, 12 Feb 2026 03:44:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B0E6B008C; Thu, 12 Feb 2026 03:44:24 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5A806B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 03:44:24 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7C9FC5A358
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:44:24 +0000 (UTC)
X-FDA: 84435168048.26.AABDE3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 994B1140006
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 08:44:22 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHj8cwZU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770885862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UTuLD0NRsdMObtunY4YwTBRtXGkzq2yALwbLzqMDPTk=;
	b=RswMBkjLfqozht2Fosr2o2rYldWcu+NpSmyJ03M2D7lfwJ8STa/o/DZuaz7/LH27GqO8VZ
	U6fzU+seJoCRNdzVWYtdDFGxK4Z8ARA2s+Iu72GjxyCdW2J7Ql4p1/h0O334NAQHqfSyfP
	Gzviz+UNmOZME6Q/pqrQuBQtWlfzzdo=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=jHj8cwZU;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770885862; a=rsa-sha256;
	cv=none;
	b=JwCdXtcOLX/jOeIiuePO0iZ21G+nWhbj3EFa+x5tzv3vzmyQKdBaay3uQZPpXnYDJcTVIv
	pAwJb963CsvQN7ioK+7BwxlYA5Cl0GnojyILRNyLd2d5+szeVsFhmDRHB8U0TRWZN8Qhcc
	f/I+1dxmNvS+BRXOBoDzgQ+kMBV7RZw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7E8AB41899;
	Thu, 12 Feb 2026 08:44:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DB23C4CEF7;
	Thu, 12 Feb 2026 08:44:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770885861;
	bh=khUwfsZrCJeC8y4xyRj4Ta7Ac2JXcbhabpcmZ5/6mug=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=jHj8cwZUzt0P3rDlFMaOsNHcHv1Al+LMyPc/k6q6ykwZi4kyKp3s1y/ZtiNbK7KEE
	 TFX+QBPCAfcJUJqGriUD1eyQbifA4Fj6qBN0q13+DAKcIU9C9G3LHSEO3ScJzArasX
	 5n4M4Z69hgXfG1xyXt5jmCNA3Vzbxny9+APfwTaPcspnnCgbSsI0PueSqFc/Mza6yH
	 0q8g+w0waGkFqNxgmLQSoy1fYxaAbXN2lYaoh7oJ3kB77lKXS6KYHzYxt1nhEwrbhF
	 +Sc8r/SWET+rWXG5aqU4pzhnX7RN1S5uF1g0kFWD2Q7RwYo+sdMDkHW5NLzXdacZ2o
	 E1coVw02xqjXg==
Message-ID: <3571cf8b-9fb3-41b2-a402-a8537ee2c399@kernel.org>
Date: Thu, 12 Feb 2026 09:44:13 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260211031512.261127-1-senozhatsky@chromium.org>
 <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
 <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <jftqdosilzfkd4ku6pjuevkvuwmhlqtua62jwsmmgdfcseitb4@gopt2xzqhyrk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: ae5uhtz7xe5k8k76uyr5fkxykomtc5m5
X-Rspamd-Queue-Id: 994B1140006
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1770885862-793762
X-HE-Meta: U2FsdGVkX1/AUcvw6VQVK003u9/Lh2j6hAzONgSPiDV4SUqRueBH5blH9+ebco8ISKXpd2XQgrldrzsafS7nR6TpYPtBC/Wvim8MDRaEJwG32Itb3O7A6OL7Vm7JFKsy+945lf6H9TOdcI/FLJmWdlyhq5n6YTSatRjEdo9XexqWou4g5qNm6KOU/KvRKKq0Tj7bHeWmQradxAM2bnGMYqg6Ia41W0RZqpxgaZwUUpyjtVFPMBG3xOyY8rFKgCSlLQrMIloOnGS/QWuiAuWO5AoB9bKae+ck1CaL0FJMTW6smkUEBvl5F+mPc9yMqktVtmmtG4smRhtlY0z4jisJV5pHWYfMnioydNrvLIIHiLs8tNbAT4kNyX+6e4eglfoTzAZSjdhI1xprepseAdjLpuCCsx8YnihSp3+f0d0nU923sN4mQiE0uqloVUlWZoXal46WrKe1AIuOL1m3IjY/tFqLV4jhFARuUxhXoscUyYCCPBFtGHGMRdlgBBuXgME0ZqCDB8Q8uCgI8UtNiVLoem74eXZzJcay7ZKkUfrXPiyxqjySU2g6hHt+qsuKv+0unj1zHQIzDFfXPWamv2nrAR7R2zDtLaAQUWgf3HeUtUT+Lf4oUsNargp1oAiy/w7sENqkNO2MX0Jm9BkZClWcY29xo5O2NvooVuT+vZ0hLEpidcTjsfH/eOdzBzd1S1FNwTuN9FLaEYaENM5DolkJY1ZPrpRbR3Fxse3ME3t4g/eIxsMHyrVt01aWtL0WyPd5rW/QydnS3sxqsZ430KR8VoMsyjFzXhge1FcORh+t1dvGWEElEthkKYFt154SUGzAog56FNx2pmNZ5lJMgPaTuQvSnG2lOXPCs956QDH0DG0GSRFw+y5sMnQnc8O7TQrVzKLJMUu1dwm1cZG4OMjje7NGClLep+ILT9Cz/zCY32XFcMPs1H0wOCO2fPgZZKuA3jM6LD89r6yggPrHU2f
 z2Da2+GO
 FLUQojKjN7oH3++vhQVbIGWSEABxeoAzL2Fi+o1hon14S1oBXcpaDEvcI64sA4MvpKjnnzpjglmF4bTxxtPNslC36EOkvTDJjJX2WeSbruPy+jR8YLjSNv5US4jjVn7ACYfov/WcGfOb3QPLEj88fIZP2jaEg+cAHBi1+/aQ7tuMZPpuRDd85wvQMXb92tZ32U/VGJ912FJ1geSjCjBF5kBxWMcKOVfxaxD0FMxiluYWKtYb2psVu1P90+b7rriYCJ8rhMHVQnkVraxEEF2y6Lw8MAIYUgINYWn/XYlbjXGg0O3v11I2aDEEHqw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 07:32, Sergey Senozhatsky wrote:
> On (26/02/11 10:50), David Hildenbrand (Arm) wrote:
>> On 2/11/26 04:15, Sergey Senozhatsky wrote:
>>> A number of khugepaaged's loops, e.g. khugepaged_scan_mm_slot(),
>>> are time unbound, which can become problematic during system
>>> suspend:
>>>
>>> PM: suspend entry (s2idle)
>>> Filesystems sync: 0.003 seconds
>>> Freezing user space processes
>>> Freezing user space processes completed (elapsed 0.003 seconds)
>>> OOM killer disabled.
>>> Freezing remaining freezable tasks
>>> Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
>>> task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
>>> Call Trace:
>>>    <TASK>
>>>    schedule+0x523/0x16a0
>>>    schedule_timeout+0x23b/0x6e0
>>>    io_schedule_timeout+0x3f/0x80
>>>    wait_for_completion_io_timeout+0xe4/0x170
>>>    submit_bio_wait+0x79/0xc0
>>>    swap_readpage+0x150/0x2d0
>>>    swap_cluster_readahead+0x3be/0x750
>>>    shmem_swapin+0xa7/0x100
>>>    shmem_swapin_folio+0xcd/0x2e0
>>>    shmem_get_folio+0x237/0x580
>>>    collapse_file+0x247/0x1280
>>>    hpage_collapse_scan_file+0x26e/0x380
>>>    khugepaged+0x43b/0x810
>>>    kthread+0xfb/0x120
>>>    </TASK>
>>>
>>> Make hpage_collapse_test_exit_or_disable() suspend aware so
>>> that khugepaaged's scan loops can terminate in a timely manner
>>> and let system enter the sleep state.
>>>
>>
>> Do we want a Fixes: tag, and maybe backport this to stable kernels?
> 
> I can Cc stable, but I don't know about Fixes - we are adding something
> that was never there, not fixing a regression.

Cc: stable is only possible with a valid Fixes:.

If we're fixing an issue, we usually try to identify which commit introduced the
issue.

For example, support for freezing was introduced in

commit 878aee7d6b5504e01b9caffce080e792b6b8d090
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Thu Jan 13 15:47:10 2011 -0800

     thp: freeze khugepaged and ksmd
     
     It's unclear why schedule friendly kernel threads can't be taken away by
     the CPU through the scheduler itself.  It's safer to stop them as they can
     trigger memory allocation, if kswapd also freezes itself to avoid
     generating I/O they have too.



Now that I am looking through the history, I find:

commit b39ca208403c8f2c17dab1fbfef1f5ecaff25e53
Author: Kevin Hao <haokexin@gmail.com>
Date:   Wed Dec 20 07:17:53 2023 +0800

     mm/khugepaged: remove redundant try_to_freeze()
     
     A freezable kernel thread can enter frozen state during freezing by either
     calling try_to_freeze() or using wait_event_freezable() and its variants.
     However, there is no need to use both methods simultaneously.  The
     freezable wait variants have been used in khugepaged_wait_work() and
     khugepaged_alloc_sleep(), so remove this redundant try_to_freeze().
     
     I used the following stress-ng command to generate some memory load on my
     Intel Alder Lake board (24 CPUs, 32G memory).


I wonder if that made the issue more likely to appear?


Interestingly, we also had in the past:

commit 1dfb059b9438633b0546c5431538a47f6ed99028
Author: Andrea Arcangeli <aarcange@redhat.com>
Date:   Thu Dec 8 14:33:57 2011 -0800

     thp: reduce khugepaged freezing latency
     
     khugepaged can sometimes cause suspend to fail, requiring that the user
     retry the suspend operation.


So it's a recurring theme.


Given that we only scan "khugepaged_pages_to_scan" pages/ptes/etc. before going back to sleep,
I wonder how that can take in your setup that long.

Why does it end up taking something around 20 seconds in your setup? How is khugepaged_pages_to_scan
set in your environment?


-- 
Cheers,

David

