Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 82CEDEB5954
	for <linux-mm@archiver.kernel.org>; Wed, 11 Feb 2026 09:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A3CC16B0005; Wed, 11 Feb 2026 04:51:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9EA6C6B0089; Wed, 11 Feb 2026 04:51:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8CC4B6B008A; Wed, 11 Feb 2026 04:51:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DCE06B0005
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 04:51:02 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 15E4BD6806
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:51:02 +0000 (UTC)
X-FDA: 84431707164.17.63337B8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 12EF2A0008
	for <linux-mm@kvack.org>; Wed, 11 Feb 2026 09:50:59 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrMsKA4u;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770803460;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sj0sah4VH9KTOHdfbdaQs1GgmaRHR/mXBHJT0TnWSVE=;
	b=4SmPWz89Ql752Z5jqUE+3wSMUgRhySeRtvlSvx1V7j3w+yISGiWAH/laQ501T3VXQMDs4D
	kaVSBrTWdqugd6VgKkkr4NV3KS4OmkfRLYzudRKB6LCPf3KI99NHeLIecbhvKejrtcDgXP
	FnpWP4Ufz59L/ZiO3ITrFG9JvALTOBM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=nrMsKA4u;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770803460; a=rsa-sha256;
	cv=none;
	b=Y9lvRaw9KngqqjMv+aHonDef0ek00UO4VojWIAmBfD6uvR/TD+/a6pCuQ0thH4QQbcf50a
	UwjevNxZBP9XyOPyL5Q0TIeqr3SZCS//0KUrdXZvvO6WEVL4drITeStz+xDpRNVkT/ukhR
	H9IKOk1Y48H3sU2TVPomfS/BktPaSWE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 2035040851;
	Wed, 11 Feb 2026 09:50:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F5EBC4CEF7;
	Wed, 11 Feb 2026 09:50:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770803459;
	bh=ZVeXWMRpsI+QKoTo0IuGPihZpAUQgyQRlBxDPNaqAvw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=nrMsKA4uTT5YLaV0n/vYdPqUxTR6HUY2N2/XMJ50J7UPYQOQQ472+MQHXX80z356o
	 /58G5utRAeOUcJ3jlg0R1Blqrjh2vyn4UoSmkUn00AHsCQCfS4z1owbET8rWJ2s2oQ
	 3sxAR2X+JQC8oHJF3OR+VfApferqYuy6+An4ISPVIRppOg/WP4hoqzv9HtntBggdxW
	 PjScxcT9zwZsuzWxZ2ZJgQXMM/Qc6VwtZHkWR6tcAmQM4/WXTsg2tK+uDAROAkKLMq
	 +uTWkllbRatVvON50IRAMpAs9qoJqZkI4PvZJfSyoclfvnLVnonAkGoQph+E9PohJ8
	 jg0pys/2B4vqw==
Message-ID: <104bc764-5a20-4ac2-95a8-b31f41255766@kernel.org>
Date: Wed, 11 Feb 2026 10:50:52 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCHv2] mm: khugepaged: make scan loops suspend aware
To: Sergey Senozhatsky <senozhatsky@chromium.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
 Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>,
 Lance Yang <lance.yang@linux.dev>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260211031512.261127-1-senozhatsky@chromium.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260211031512.261127-1-senozhatsky@chromium.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 12EF2A0008
X-Rspamd-Server: rspam07
X-Stat-Signature: batinmkqbycg9cxcou1mepwo8hiw5hx6
X-HE-Tag: 1770803459-885665
X-HE-Meta: U2FsdGVkX1++PFCfoCuWtaveTAFV6LrwSe8BJ5mq8W4FeuytSB7MkfB3mxFqAt0TdH3hBHy0JD4tFcZpz7Ka4+iRAicshS7LeO5nTP18VRmnQf62wgSkK8FN6uqpKfP5BSENgGmYGgE8C0KkhnLMo+qSxDbbvdx2dx0DFLeA2hl8Vd4KJitHEDYeML/Vk88ran3UsFA1H9DG8DzMTmpstLliZ0DlPd9WxuL+wJkuGtT5D1X1MgA2RG4c8IVa6FYpLfZDDu+80TYrJiupdYR95RAty79Z6QVcnUxNRNPUoemYbkpneVUl/w0XSTPeyLqsGRK7hDs3znx0uyxysf89y6WblHY1RFNA3eIyCBYGA6yD9Cm4WkApNSQwLDAiDCY1yiTjveGBTXgkXlZ0zJ0OuuLTNUOVwJ+1p4QdkK8mreXQE8roNKbNkobRVkpq6s1ZQ4HxCjfvOA3+9/4m1mriCqJmD3qtOyw82BZ1FjWbi3oZ7zzhM6IzgPYsxbDAIHTYK6bTUNtxyxtAftLVJFzodTwdDoYsGfZR4JPnuuno8uyGe3i65ZUueDxSUsowM0ffLWc7t/dZDsO/ncYavDfms8Icm+e+SiLr5h+xFEYIqfp8cdu/5FMFGjoy2c17EBReNCScSUFLX1lwQ/N/HImzb19aiv/NvfafcPZkbajrOgjTFrSgQf+Z+CfdfUgko55XhsNNjd+LKMXL0LME+Gu3VXFHwKeIkqCBoHsx8JzBEL97j7pa6KYiFFANA+MTYgpGgdAE9W62XDUI6pML6aiXSpRGVmcS9JxF/2skzwkHeaVJ61eD6WzkIpKHot0nLfliC9Kc/5Sgm0j4vaGAqGCgTH99Z/fDNGKQ/vRaQ4PxuZ3QAFhsK72drpuyAhxrP+Xkad61/3dK/0y7OtY+79zo463AGnNmud7Q2CWfv/NQDgkAntUf/qLJ8qIzMAG62LDmMU9fN0kIw5vTR8K2wdI
 bdnHsXTq
 ID/fcUHk0/1UdsXJOTRCwTOR80dbYtoZp+flzlyQDXVrfevo720X232vfWtaDr7uElXECg2Z1r1DQ1PVUnTFi3KRfOiTZ0ytGfZ2pqQtHOf06SCGIzaY3xKIdfjCI0yEf5v5Z9YokV715K/eW4OV+OiMazCVX7FkdGk1tdzOOO8u2NBVCrQaU0T2A3zK/mEwtbvyMA1ZBYaHCAbP8WYE4uvSLWi4bdkeJoPOlwUOuhKHwkPuvl+Da/ctSysvvw3S1EZq1J39q2k2jz/0IowJEXpbWh0rfoUZselKBtcHWy2CJXLn0dWdNsd1/Ww==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/11/26 04:15, Sergey Senozhatsky wrote:
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

Do we want a Fixes: tag, and maybe backport this to stable kernels?

> Co-developed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Signed-off-by: Sergey Senozhatsky <senozhatsky@chromium.org>
> ---
> 
> v1->v2: Actually pass "cc" to hpage_collapse_test_exit_or_disable()
> 
>   mm/khugepaged.c | 22 +++++++++++++++-------
>   1 file changed, 15 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/khugepaged.c b/mm/khugepaged.c
> index eff9e3061925..d32a5ad27097 100644
> --- a/mm/khugepaged.c
> +++ b/mm/khugepaged.c
> @@ -392,10 +392,18 @@ static inline int hpage_collapse_test_exit(struct mm_struct *mm)
>   	return atomic_read(&mm->mm_users) == 0;
>   }
>   
> -static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm)
> +static inline int hpage_collapse_test_exit_or_disable(struct mm_struct *mm,
> +						struct collapse_control *cc)

Two-tab indent, please.

>   {
> +	bool was_frozen = false;
> +
> +	if (cc->is_khugepaged &&
> +	    unlikely(kthread_freezable_should_stop(&was_frozen)))
> +		return 1;

I'm trying to understand why kthread_freezable_should_stop() is so 
confusing.

It has this !kthread_should_stop() logic in there, which, IIUC, is not 
really required for the issue here.

But it doesn't hurt to check here whether the kthread is getting shut down.

Relevant for the fix is for us to quit when was_frozen is set, so we can 
end up in khugepaged_wait_work()->wait_event_freezable_timeout().


So using kthread_freezable_should_stop() is fine.


> +
>   	return hpage_collapse_test_exit(mm) ||
> -		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm);
> +		mm_flags_test(MMF_DISABLE_THP_COMPLETELY, mm) ||
> +		was_frozen;
>   }


Do we also have to enlighten the kthread_should_stop() check in 
khugepaged_do_scan() to check kthread_freezable_should_stop() instead?

-- 
Cheers,

David

