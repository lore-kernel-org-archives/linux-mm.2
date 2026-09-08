Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCCA7C79F99
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 14:08:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C21B66B0096; Tue,  8 Sep 2026 10:08:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B835E6B009B; Tue,  8 Sep 2026 10:08:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A4E076B009D; Tue,  8 Sep 2026 10:08:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7371E6B0096
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 10:08:00 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6C3CE1C28DD
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:07:59 +0000 (UTC)
X-FDA: 85190773878.30.00688A0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf03.hostedemail.com (Postfix) with ESMTP id A6ADC2000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 14:07:57 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQGU4RuN;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788876477;
	b=EH3yRW3Su3mv8xzokeQZvx6RlWQ8lVERxqxREKweSob5ksRdYo8F2Fhr8XSDC5qqhHLSef
	5k0wQvbXqgUqtoqPxrwCV6qoWK9OEO0lScVJH31QdyDqxYtQz7W5bMG9pn8u/91i92piMJ
	5ORXfbhwkBcPaE5SWeLA9VOPxRwToGM=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kQGU4RuN;
	spf=pass (imf03.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788876477;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=R4WFBW494Ued1je39zGeN2tdJow2EgtUwmTrd9cYNqk=;
	b=ctQvZFuFNUXGKJLr/qqT0W3TEAxI4Y/I6UmVb3RG1UX9P85u1Wmr6zHbg/rz4oD40oMsyX
	Wya9aLmtSJUwHFiNGHFjoiNHYEhjdrVng2/kDBWE+wR9wsUxSriZLdTAvVgPFtvPcV+RUq
	glMTMze6qCd3OQ1BGqvYNCmpIu8gIc0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4B449601F6;
	Tue,  8 Sep 2026 14:07:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDE451F00A3D;
	Tue,  8 Sep 2026 14:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788876477;
	bh=R4WFBW494Ued1je39zGeN2tdJow2EgtUwmTrd9cYNqk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=kQGU4RuNAJOY3rsUeHdoZ1orFmipJPWkwfJXBCa3wYKVxTgNb9DT9WtoGg3nfnWgd
	 mJpV7XsVp10l98a7OX+BOYBcsQqqKcQS6n8mrWQdImuJTR5dRNX5InWjZyZOcEZZKG
	 HfQqjUbU6drW3G0iyxhJw7VsBh/x4q71/fI3nejJloGv1cwjlE8dUAHlt4vJ1eDaAs
	 0333NzULtWV4NvQZQxcO/U47nlo4Uf6jYh0MBD+U7kL37fhJtTHmz0OG1HNPXMLIv0
	 TDnt+5Cpt8ji+rqowMPVVjN84maLB3/3hGzUWoHOrwFP3nY1zvhVvpxaOVi8fWWiKo
	 MNjMhE4/9fHAQ==
Message-ID: <211391a9-7283-498d-bef8-41ba5dfcc549@kernel.org>
Date: Tue, 8 Sep 2026 16:07:40 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next v6 1/5] mm: Add copy_remote_mm_str()
To: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>, bpf@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, akpm@linux-foundation.org, andrii@kernel.org,
 ast@kernel.org, brauner@kernel.org, daniel@iogearbox.net, eddyz87@gmail.com,
 kpsingh@kernel.org, ljs@kernel.org, matt@bobrowski.net, memxor@gmail.com,
 song@kernel.org, sun.jian.kdev@gmail.com, utilityemal77@gmail.com,
 viro@zeniv.linux.org.uk
References: <20260908135302.74963-1-tasos.papagiannnis@gmail.com>
 <20260908135302.74963-2-tasos.papagiannnis@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 xsFNBFXLn5EBEAC+zYvAFJxCBY9Tr1xZgcESmxVNI/0ffzE/ZQOiHJl6mGkmA1R7/uUpiCjJ
 dBrn+lhhOYjjNefFQou6478faXE6o2AhmebqT4KiQoUQFV4R7y1KMEKoSyy8hQaK1umALTdL
 QZLQMzNE74ap+GDK0wnacPQFpcG1AE9RMq3aeErY5tujekBS32jfC/7AnH7I0v1v1TbbK3Gp
 XNeiN4QroO+5qaSr0ID2sz5jtBLRb15RMre27E1ImpaIv2Jw8NJgW0k/D1RyKCwaTsgRdwuK
 Kx/Y91XuSBdz0uOyU/S8kM1+ag0wvsGlpBVxRR/xw/E8M7TEwuCZQArqqTCmkG6HGcXFT0V9
 PXFNNgV5jXMQRwU0O/ztJIQqsE5LsUomE//bLwzj9IVsaQpKDqW6TAPjcdBDPLHvriq7kGjt
 WhVhdl0qEYB8lkBEU7V2Yb+SYhmhpDrti9Fq1EsmhiHSkxJcGREoMK/63r9WLZYI3+4W2rAc
 UucZa4OT27U5ZISjNg3Ev0rxU5UH2/pT4wJCfxwocmqaRr6UYmrtZmND89X0KigoFD/XSeVv
 jwBRNjPAubK9/k5NoRrYqztM9W6sJqrH8+UWZ1Idd/DdmogJh0gNC0+N42Za9yBRURfIdKSb
 B3JfpUqcWwE7vUaYrHG1nw54pLUoPG6sAA7Mehl3nd4pZUALHwARAQABzS5EYXZpZCBIaWxk
 ZW5icmFuZCAoQ3VycmVudCkgPGRhdmlkQGtlcm5lbC5vcmc+wsGQBBMBCAA6AhsDBQkmWAik
 AgsJBBUKCQgCFgICHgUCF4AWIQQb2cqtc1xMOkYN/MpN3hD3AP+DWgUCaYJt/AIZAQAKCRBN
 3hD3AP+DWriiD/9BLGEKG+N8L2AXhikJg6YmXom9ytRwPqDgpHpVg2xdhopoWdMRXjzOrIKD
 g4LSnFaKneQD0hZhoArEeamG5tyo32xoRsPwkbpIzL0OKSZ8G6mVbFGpjmyDLQCAxteXCLXz
 ZI0VbsuJKelYnKcXWOIndOrNRvE5eoOfTt2XfBnAapxMYY2IsV+qaUXlO63GgfIOg8RBaj7x
 3NxkI3rV0SHhI4GU9K6jCvGghxeS1QX6L/XI9mfAYaIwGy5B68kF26piAVYv/QZDEVIpo3t7
 /fjSpxKT8plJH6rhhR0epy8dWRHk3qT5tk2P85twasdloWtkMZ7FsCJRKWscm1BLpsDn6EQ4
 jeMHECiY9kGKKi8dQpv3FRyo2QApZ49NNDbwcR0ZndK0XFo15iH708H5Qja/8TuXCwnPWAcJ
 DQoNIDFyaxe26Rx3ZwUkRALa3iPcVjE0//TrQ4KnFf+lMBSrS33xDDBfevW9+Dk6IISmDH1R
 HFq2jpkN+FX/PE8eVhV68B2DsAPZ5rUwyCKUXPTJ/irrCCmAAb5Jpv11S7hUSpqtM/6oVESC
 3z/7CzrVtRODzLtNgV4r5EI+wAv/3PgJLlMwgJM90Fb3CB2IgbxhjvmB1WNdvXACVydx55V7
 LPPKodSTF29rlnQAf9HLgCphuuSrrPn5VQDaYZl4N/7zc2wcWM7BTQRVy5+RARAA59fefSDR
 9nMGCb9LbMX+TFAoIQo/wgP5XPyzLYakO+94GrgfZjfhdaxPXMsl2+o8jhp/hlIzG56taNdt
 VZtPp3ih1AgbR8rHgXw1xwOpuAd5lE1qNd54ndHuADO9a9A0vPimIes78Hi1/yy+ZEEvRkHk
 /kDa6F3AtTc1m4rbbOk2fiKzzsE9YXweFjQvl9p+AMw6qd/iC4lUk9g0+FQXNdRs+o4o6Qvy
 iOQJfGQ4UcBuOy1IrkJrd8qq5jet1fcM2j4QvsW8CLDWZS1L7kZ5gT5EycMKxUWb8LuRjxzZ
 3QY1aQH2kkzn6acigU3HLtgFyV1gBNV44ehjgvJpRY2cC8VhanTx0dZ9mj1YKIky5N+C0f21
 zvntBqcxV0+3p8MrxRRcgEtDZNav+xAoT3G0W4SahAaUTWXpsZoOecwtxi74CyneQNPTDjNg
 azHmvpdBVEfj7k3p4dmJp5i0U66Onmf6mMFpArvBRSMOKU9DlAzMi4IvhiNWjKVaIE2Se9BY
 FdKVAJaZq85P2y20ZBd08ILnKcj7XKZkLU5FkoA0udEBvQ0f9QLNyyy3DZMCQWcwRuj1m73D
 sq8DEFBdZ5eEkj1dCyx+t/ga6x2rHyc8Sl86oK1tvAkwBNsfKou3v+jP/l14a7DGBvrmlYjO
 59o3t6inu6H7pt7OL6u6BQj7DoMAEQEAAcLBfAQYAQgAJgIbDBYhBBvZyq1zXEw6Rg38yk3e
 EPcA/4NaBQJonNqrBQkmWAihAAoJEE3eEPcA/4NaKtMQALAJ8PzprBEXbXcEXwDKQu+P/vts
 IfUb1UNMfMV76BicGa5NCZnJNQASDP/+bFg6O3gx5NbhHHPeaWz/VxlOmYHokHodOvtL0WCC
 8A5PEP8tOk6029Z+J+xUcMrJClNVFpzVvOpb1lCbhjwAV465Hy+NUSbbUiRxdzNQtLtgZzOV
 Zw7jxUCs4UUZLQTCuBpFgb15bBxYZ/BL9MbzxPxvfUQIPbnzQMcqtpUs21CMK2PdfCh5c4gS
 sDci6D5/ZIBw94UQWmGpM/O1ilGXde2ZzzGYl64glmccD8e87OnEgKnH3FbnJnT4iJchtSvx
 yJNi1+t0+qDti4m88+/9IuPqCKb6Stl+s2dnLtJNrjXBGJtsQG/sRpqsJz5x1/2nPJSRMsx9
 5YfqbdrJSOFXDzZ8/r82HgQEtUvlSXNaXCa95ez0UkOG7+bDm2b3s0XahBQeLVCH0mw3RAQg
 r7xDAYKIrAwfHHmMTnBQDPJwVqxJjVNr7yBic4yfzVWGCGNE4DnOW0vcIeoyhy9vnIa3w1uZ
 3iyY2Nsd7JxfKu1PRhCGwXzRw5TlfEsoRI7V9A8isUCoqE2Dzh3FvYHVeX4Us+bRL/oqareJ
 CIFqgYMyvHj7Q06kTKmauOe4Nf0l0qEkIuIzfoLJ3qr5UyXc2hLtWyT9Ir+lYlX9efqh7mOY
 qIws/H2t
In-Reply-To: <20260908135302.74963-2-tasos.papagiannnis@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: A6ADC2000D
X-Stat-Signature: ycadhkqowfibne1z39ud46w9n7kfcnkr
X-HE-Tag: 1788876477-786584
X-HE-Meta: U2FsdGVkX1/qzUU1dwX+lLQw6x2bpR52ecVKbAMCI9OoC40NmvhZUj+rCnfXNX7dhc1BrlkHmua6n22PBPvq62zfvebmCLaIePKojuyQF7WkCV0QisnPKJCG3B5QBrH3mBsyEVFc9BUDvdSIesB3HLu4k8JHtt50uxb2veGZC4UqdXl8z9THGXKbP5he90Zamh22cCKyEZ7kfQN+uAvs1m2fJlEIq3DK7DyCZQt4ZQB5T+ai+QyblOo7XcktmMXurU8CaECdQQwV5R1CurSo0D2bl2NmMlUz2zofiG73AdPG9foM/d8/4XXq+VOyCCN3CNErFATH2LtHnmnejBAa+idyM0yebNH+1/cwx5E6A8FoCrwkvX2Q4yc/OYhdXkg0Y1eWotvvhCGP3P1FFnoF1kXJYRW9SWaRS2Lh/ax/6aRTiyobctB8mpVuLA1cOa6UEGepFJAMh3MtTvylLPhkcn9yfxKQEyrDYn/jEQCVVOWc4WQy1RXZIqwZtAe2soRdqgzDARfcJuN93QPkEJPLpgDcdiLn26p1xRfC7khhIcWbBw+msqDPb4ItubkTwmtu9hkFGTqf9tMtQnxEdeYWAjYfEQPkNHruDm3u6ScRCLHEWZp7boaNM/Uj+EQtVWEznvbMQoJSeTHNrKRz03mNjw4666OiQchtUryTL2B5A5wdzvQaPc52jC9NWhsPs8w/jMh50ZCKUQQCxfo+xAyqY8vKVuIgAak2LG7seOs0CY0EeO9SKtOueTnab4vlNLrB04DZ4bAsNg3tLov1s8vfdn6Fxr/dsAING5s2ZTiiV44muuYOLTHWyY5xVmZj4e5Z8p9H9mjVmiKbBSCXhNAntpWLvGSgdRa5/c9ja8pwyymGkQprrmZ+YLG4f1JBX0bgyHhqmFHTRLxr4Ld/S8dcJU74OFWPHzzxMgrePN7HO8953uX1Z5ODWo5O3cLMlOi1DcdQFoN6VQ6mKfllf9+
 rY9c+0fa
 gwb+3vFOGUJTaiYCPodqHXW4mllEGjABNtQ330kCtuijzmGll/KBSIvMPytOaIFeXAXtW1YMzEqOVq4ps2FjQAWgRMxrpFtTwCIJsqMY6H/psO/5fP5ScxVZ8xiEr9SioH+k0i97jehftNPywWzMqhMRUNSU2H8/DSyzw2LhyzfZWAdrTpJor8AefdSR1127NSMduyP+8LcH/xktqXVF81lwLK0c20CNipsD9RXy+uf9G82LbPqS/rqcP2W0cPOisEtFf9uQAnIhvpFiTP2sP/aHzGFDLy9S6n2ksQM7m1ieIlEr7CGrlAxcDsd6SK4iHJ4USWgG0qHmAM8Xb1oFgkYv0NK/C50YyJoTPHU1ti1GRVJiSFHPeWe8LRjoOWbfZh8oVZRi6gVoU/33CEDCn0NOcUriOvCwL0Y+I3C2B6m5eV8g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/8/26 15:52, Anastasios Papagiannis wrote:
> copy_remote_vm_str() gets the target address space from a struct
> task_struct. This does not work for an address space that exists but is
> not yet associated with a task_struct, such as the mm held by struct
> linux_binprm during exec.
> 
> Add copy_remote_mm_str(), which operates directly on a struct mm_struct.
> 
> Use a common internal interface for the MMU and NOMMU implementations
> and define both public wrappers in mm/util.c. Preserve the existing
> copy_remote_vm_str() behavior, including handling zero-length requests
> before acquiring the task's mm.
> 
> Signed-off-by: Anastasios Papagiannis <tasos.papagiannnis@gmail.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> ---
>  include/linux/mm.h |  8 +++---
>  mm/internal.h      |  3 +++
>  mm/memory.c        | 41 ++----------------------------
>  mm/nommu.c         | 41 ++----------------------------
>  mm/util.c          | 62 ++++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 73 insertions(+), 82 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index dd09c438fa23..6f10ce315eaa 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -3325,10 +3325,10 @@ extern int access_process_vm(struct task_struct *tsk, unsigned long addr,
>  extern int access_remote_vm(struct mm_struct *mm, unsigned long addr,
>  		void *buf, int len, unsigned int gup_flags);
>  
> -#ifdef CONFIG_BPF_SYSCALL
> -extern int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> -			      void *buf, int len, unsigned int gup_flags);
> -#endif
> +int copy_remote_mm_str(struct mm_struct *mm, unsigned long addr,
> +		       void *buf, int len, unsigned int gup_flags);
> +int copy_remote_vm_str(struct task_struct *tsk, unsigned long addr,
> +		       void *buf, int len, unsigned int gup_flags);

Two nits I didn't realize earlier ...

We use two-tab indent on the second parameter line in MM.

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

