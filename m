Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3DF7EB594B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 03:04:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 636F26B0005; Tue, 10 Feb 2026 22:04:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E4B76B0089; Tue, 10 Feb 2026 22:04:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F0456B008A; Tue, 10 Feb 2026 22:04:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3F6256B0005
	for <linux-mm@kvack.org>; Tue, 10 Feb 2026 22:04:48 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A2FEBC101B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:04:47 +0000 (UTC)
X-FDA: 84430683414.27.5785682
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf02.hostedemail.com (Postfix) with ESMTP id 24C2B8000B
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 03:04:43 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c5QFIhh3;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770779086;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1fvkuiHH7HqSqBbMLyMhpWj5hv20P71nPqWvwq16YUQ=;
	b=k5oioX73cIQG4pkZwK3yALuE5JIVn4FizkZLa5bgaXslQLUm990Doxr8HgItkdR7pVKC1n
	0lrnabwj+QVfSk75b9gr/yF7YzRFv+m67LLKh+Uhv5xjGe+9ZZKE16aplppv/v1SKBjtis
	RoNLf6bAy0/TG71vT10MBqAsHtvL8NA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770779086; a=rsa-sha256;
	cv=none;
	b=RVDB+cZji84vGZ4xhE7RsDActrFd401jiRNM3yk1dggejkSoaOsQXnREbM8wNcXs16wDoD
	+xVpLDl+D0RyV00NeUazwwgDc5DXXGECPup6LGHc3M3JZThVtxmRlsBcpWryqkjjFQHMkg
	BuL8sr9lGpOiJmjEZlazYLJTpOob2B4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=c5QFIhh3;
	spf=pass (imf02.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1770779080; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=1fvkuiHH7HqSqBbMLyMhpWj5hv20P71nPqWvwq16YUQ=;
	b=c5QFIhh3ymebP4SJHZxYm/Ei2MSnbo7iwjMu6y8Wvkr37yYrudh1QveEAAYS6Wp/z0OKrq3CobtmOky3KxDC+ZhyoIcXFn6rbyiMeWsxe+iThtROw/0fqHSMECDf1CuSJdYygztbAbLENWnHJrnbZR3dcnlSGlCnSuaJGTHmQV8=
Received: from 30.74.144.106(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0Wz.HSpq_1770779079 cluster:ay36)
          by smtp.aliyun-inc.com;
          Wed, 11 Feb 2026 11:04:40 +0800
Message-ID: <a441c762-1f57-4124-93a8-aac55f32d846@linux.alibaba.com>
Date: Wed, 11 Feb 2026 11:04:39 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: khugepaged: make scan loops suspend aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>
Cc: "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260211030024.232964-1-senozhatsky@chromium.org>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <20260211030024.232964-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 24C2B8000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: p591xdw8zgojajjnjjkfri9za9xocohy
X-HE-Tag: 1770779083-51270
X-HE-Meta: U2FsdGVkX1+ci1OKRDoKW/0wkwnlqrxTj2zUhJyj5+ogEJRQqbeumdGxS2mq2bdJi6eLfTP5WZrKFtDoSINZQcS/0Qu45Z+JJ6PakxYXqYHYPHSFoY/miuvD+qjGYHG9kQMZ3QmKQiA0dFEWHEDOLeLt7Ze13JnIrO+4ksmf8ajl21z5hoUPl7YoPREsi0jBW/O4ly2MiI39Dbnzc+4RDxQ4ghf0+v7zq8cfm7mUI17AOMHT5NnxAD+b10+12nWaidlBsItXW8lqvlOrdX9dIKrExKuOgBLR0tJkrZn6QYQ4L3XnIGZ56xbuQNNcahjzbXjjqUy3rMR/cGcriYuOlt94ZpZ6B+HL5oXzK6aVL4hxiwZHjQ8tnA1WRBYefRvP/U0wdArsFGJGFdvyk2VskYB3IYj2Csm4t4bo+I8bBis6bA0W6H4shDIpMlCixXyA7Sybc+tbensfvzRVg+UBJphE4JcBpBBYNyV6TXbG6EjCPeuOkw0ijmdafx0JXqmF9KEEnShFyvAM1bm+gzKbXg4avxs2rxq/ZUkShRvErhBPtZ6pX3CTlX4ckDcsQmkWqE0tr4BkPL5B50PaVjuqWurMlDqmvBGtKXQrilNWJbR3mduEZeqJuS7z0WduzmWKkiYM453i47WkIoAmpdUWbnl/oqZ42H+GFVONqL+2jXwgmOBVLQxPTqnHA2wgo7iHBYbXiUlEofXlM1NW8mK0SQKa1itvFbkfZ5TVTy8dxZUhr/vGYSIdlNMYGpX3MLvWfNknEZKLly+WoCgCKbUWo7Pw9f7HwZybux4xL1vo0J1uixaSNy40Y9x6HZfy5ZcSHiz08iKLA7q3sB6xfZ1CyxSZ9+5S8KnJ9O1Onfz0Rkg1yh/+6d9+7s5PLCqoknwQCK25TqTfGw41z29VRy7+mmwm3Iago9gCtpMtNSqpEN+DtxpqIach1rJB5deRwjVYdRe32i+LoozaQeu/gNx
 OaEHdQke
 97Wu5gKJkyEOMjfYDQdzc57I7/H8L8gesBzVSY0+ppzOe5cZ0s2/+UI3kCpCXkt2HCCCjqKRAhWiiwKw0lKXpDZJJwff5YTTvr1F4kBNOMnsuFnQQjluALqE9TVHDrOvZeZrnhJecLmYvJ1PIuHiJDSi9nvRIXIWhMrYtwahMI33DFGaO2Cae+S/V7sZYCnCIernDFIFQUhBKW+qvuug9k/cwy1HRhjOLRiVDOfE0zhib9eqqPesOk/bZpRupOLThKWNLXpXLsCEA/4jEUZJkvVTww+5wi2M5rjuw44i4hQDWRLG4uckYdx1bz5PW+EdkfXH6ZJNOfR0/Ns5+S9hoGU7iQQiKXSdjOtY4pCibe+tH1yE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Sergey,

On 2/11/26 10:59 AM, Sergey Senozhatsky wrote:
> A number of khugepaaged's loops, e.g. khugepaged_scan_mm_slot(),
> are time unbound, which can become problematic during system
> suspend:
> 
> PM: suspend entry (s2idle)
> Filesystems sync: 0.003 seconds
> Freezing user space processes
> Freezing user space processes completed (elapsed 0.003 seconds)
> OOM killer disabled.
> Freezing remaining freezable tasks
> Freezing remaining freezable tasks failed after 20.004 seconds (1 tasks refusing to freeze, wq_busy=0):
> task:khugepaged      state:D stack:0     pid:1345  ppid:2      flags:0x00004000
> Call Trace:
>   <TASK>
>   schedule+0x523/0x16a0
>   schedule_timeout+0x23b/0x6e0
>   io_schedule_timeout+0x3f/0x80
>   wait_for_completion_io_timeout+0xe4/0x170
>   submit_bio_wait+0x79/0xc0
>   swap_readpage+0x150/0x2d0
>   swap_cluster_readahead+0x3be/0x750
>   shmem_swapin+0xa7/0x100
>   shmem_swapin_folio+0xcd/0x2e0
>   shmem_get_folio+0x237/0x580
>   collapse_file+0x247/0x1280
>   hpage_collapse_scan_file+0x26e/0x380
>   khugepaged+0x43b/0x810
>   kthread+0xfb/0x120
>   </TASK>
> 
> Make hpage_collapse_test_exit_or_disable() suspend aware so
> that khugepaaged's scan loops can terminate in a timely manner
> and let system enter the sleep state.
> 
> Co-developed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---

I just provided some sample code. Please make sure your patch can be 
built before submitting a formal patch.

Obviously, you should also modify the callers to pass in the 'cc' pointer.

>   mm/khugepaged.c | 12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index eff9e3061925..9b3201fb6840 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> +						struct collapse_control *cc)
>   {
> +	bool was_frozen = false;
> +
> +	if (cc->is_khugepaged &&
> +	    unlikely(kthread_freezable_should_stop(&was_frozen)))
> +		return 1;
> +
>   	return hpage_collapse_test_exit(mm) ||
> -		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> +		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
> +		was_frozen;
>   }
>   
>   static bool hugepage_pmd_enabled(void)


