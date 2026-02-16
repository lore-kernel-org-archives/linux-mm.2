Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 216AAE7BDA8
	for <linux-mm@archiver.kernel.org>; Mon, 16 Feb 2026 12:15:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CED26B0005; Mon, 16 Feb 2026 07:15:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A6BD6B0088; Mon, 16 Feb 2026 07:15:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 27B736B0089; Mon, 16 Feb 2026 07:15:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FBEF6B0005
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 07:15:51 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B461D160D47
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:15:50 +0000 (UTC)
X-FDA: 84450216060.09.F9652A4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id 0E353180016
	for <linux-mm@kvack.org>; Mon, 16 Feb 2026 12:15:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AVXrh8Bj;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771244149;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SdYpqeQXImu32z4zZ0GX0vrUoE01wz/xIHP7g6aO/xg=;
	b=ZLo9h/r4KHfxWoGhW/b4+HGHbXBDvXxSM1Ga4l7bhtsfLpePpD+eHeM+m1eYA/HlUKoXQ7
	een0mVkyqz2dZdfp8SfQS4m5Gm/Txy8coTfjarEDOzinkFZJaOWx3Z9pp0NZyjAEU34NEv
	hPl29lwJ9HXgf2+tlwEpcG7xj5G61BQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AVXrh8Bj;
	spf=pass (imf16.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771244149; a=rsa-sha256;
	cv=none;
	b=5STAmfbOVGMH+XvNGFB8yPMyU91D6jZrdIXD2VFT8BW1rpdZj3tsNf2JRfK1tnolHJyQsH
	J1x9WvnWOj2z18ufYA1SdGA02kWnUBVR8bgdrJ0pYdAlFiTEr2kA5KFln6+b+lM6PQa83/
	oii5hr34cVQVfqat2Xgn8lH6VOuVg8c=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 695176012B;
	Mon, 16 Feb 2026 12:15:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96160C19423;
	Mon, 16 Feb 2026 12:15:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771244148;
	bh=yVXbmrozFUX7lxzw8jVfric8iiV/l74dHezhvXM0gRY=;
	h=Date:Subject:To:References:From:In-Reply-To:From;
	b=AVXrh8BjTet237u9QvLtZKUMdQywnXodPYrNYJHMOvqIp8MvMHfnX3yh1Ss00Jka2
	 tHje6vzf9uu1aGurYdlX0NDkh5ooifFxOZFjreBPiplMSWImSxV0T69nX/FXgmva5M
	 EYYET4JF1tZVWOZ3MANeLlUZ+SZd8wmk0byEkO1GgO5PSD6HY84j78C8aXtkjZoLNj
	 zOg8SbK7r5sb9Llwaww3xS88RwCuD8cWCehRR15b4f/+31UhDGgbt8R6octtYObmHP
	 fVTYLKlcaDgAQHUKROovHHfDm/H4sLYrvgZum5Ad03ATRfs8vagQDwODPp4s+Nvz4n
	 ltZBXb7nZsceg==
Message-ID: <db1fa367-0fd1-48a1-a58c-73e72cfbdc05@kernel.org>
Date: Mon, 16 Feb 2026 13:15:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: Add AnonZero accounting for zero-filled anonymous
 pages
To: Wenchao Hao <haowenchao22@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260214084514.2842745-1-haowenchao22@gmail.com>
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
In-Reply-To: <20260214084514.2842745-1-haowenchao22@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 34p7bj7k7wg694pqgheuwzuqzd5bzkbo
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 0E353180016
X-HE-Tag: 1771244148-318453
X-HE-Meta: U2FsdGVkX18CFOgGXYO4bAy8A0V837UoOsMeYFNX2gGxIoxTuvKcdacKQ7JGb7l8M/3JeO+PaX8nKwi882kZVePaFPZX/L2HOQgtU9t04JOunZ/ApXhvJyXd7WTl4Xqmybqmg2zS/ATPtUo1nx1gMkawj+DlNFHeG+41G/Y7PyJ1lqoXvnyPNB39fe7ejrec36uTYPf29jgrmK50Ubm8NzcJ5b93pOF2+We5YjXfauRusNve9jKCsqvMnfLvDpwlhQJ7HVbhtsNYhognBnpmtFa1VKipW1nBjcs+T60KpwCjz/SCI5nLvxKoMIhhymYiAm1A8UIN1ifZ5LZEBp/frmR7zfHYNIaRGOjtaPA3SlxyOe2tuspJtygsFbr1BnqglYcausX4ydIWWshbsttK8JykeIrlATeFbbsVMjBiuBLBRVUvfipJhYLvZy4sgbaQfDZl9uk2KLj2ZvTDSWfv/W9Wz6f9TN6vEVpTyPu9vTRkjcY9LigRnAeWujXGLcvivWl2Nq2PdcuRyZ0xV7iwqIePjD4bblGe9qM3L2kSMnfuHgEvNPvmupKwor6YjcPxD6uqboroVP64z10Fuo+nUj81KJsYG3mz380k+H9jq3rETTt4M7ThUKSVF7MY4GApc4LgvkQKS6kvz5ezxawHs2Fx5SULwDnFxUKDaw/i+rQA6whuDZBGFqzQ/SnBIO9YnaGk2lgtkf8JOjBixZCGs4kImHIF78NaqgkOOsVo/M0AprilQqG75LkbAjfip3O75fAkvQ1WMt3a1/PTPAg0g4c+5eLqNLFy55ynBM6gcUg4XAGFACOOv1rMaHV9omhRRbv0CuOWSxJi4Fnb3Zx0CN9SQoWzL1pJxJ4hYHOBkI5qQ2k71yBAutzBXLFhZZaLb0md24ERfiOpzOgvCe4YErAQn3pawEvbv8GRO6f5N2PXQhOsNIovVWhhR7bcGGDQwS2NkpF4uFQBv03SsCX
 oSzNpI44
 j6zLGWXBFIMgcccCXF7/ftf7fKETiNo5nwFPazXRoWktEQmsvCtrBFDKhfAAkG4xBsCPB2sHG5ZNW67gqtMTGuVwkcuARbLY8BC3bmSqc3WgRU4l2pvkM+Ate+kFuA9rhYMo+HyvWROiAvap1KZXMrD+7K/l+4ljvSG651JA9Ri3K15yNhw5jZtsS2T05w8wLEhgBFOEeDLTGveNdQN4v4pPUtw+gBXWSirxZE/aiBf0SwboXiL0bBSwFA5swMVF04fg6K47f2hIp7YEKdMNWajCTqbshmvt08TAxcOzKXT1bWMo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/14/26 09:45, Wenchao Hao wrote:
> Add kernel command line option "count_zero_page" to track anonymous pages
> have been allocated and mapped to userspace but zero-filled.

"count_zero_page" is rather sub-optimal parameter name. "anonzero_in_smaps" or sth like that?

Still wondering if there could be a better way to enable this dynamically.

In particular, not using a core parameter.

If you use a module parameter, you can just set on the cmdline

	proc.anonzero_in_smaps=1

And dynamically set/observe it in

	/sys/module/proc/parameters/anonzero_in_smaps


diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index d7d52e259055..0301b9cd28f8 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -34,6 +34,10 @@
  
  #define SEQ_PUT_DEC(str, val) \
                 seq_put_decimal_ull_width(m, str, (val) << (PAGE_SHIFT-10), 8)
+
+static bool anonzero_in_smaps;
+module_param(anonzero_in_smaps, bool, 0644);
+
  void task_mem(struct seq_file *m, struct mm_struct *mm)
  {
         unsigned long text, lib, swap, anon, file, shmem;


> 
> This feature is mainly used to debug large folio mechanism, which
> pre-allocates and map more pages than actually needed, leading to memory
> waste from unaccessed pages.
> 
> Export the result in /proc/pid/smaps as "AnonZero" field.
> 
> Link: https://lore.kernel.org/linux-mm/20260210043456.2137482-1-haowenchao22@gmail.com/
> Signed-off-by: Wenchao Hao <haowenchao22@gmail.com>
> ---
>   Documentation/filesystems/proc.rst |  5 +++++
>   fs/proc/task_mmu.c                 | 10 ++++++++++
>   2 files changed, 15 insertions(+)
> 
> diff --git a/Documentation/filesystems/proc.rst b/Documentation/filesystems/proc.rst
> index b0c0d1b45b99..573c8b015e39 100644
> --- a/Documentation/filesystems/proc.rst
> +++ b/Documentation/filesystems/proc.rst
> @@ -545,6 +545,11 @@ replaced by copy-on-write) part of the underlying shmem object out on swap.
>   does not take into account swapped out page of underlying shmem objects.
>   "Locked" indicates whether the mapping is locked in memory or not.
>   
> +"AnonZero" shows the size of anonymous pages that have never been accessed
> +after mapping, and it can reflect the memory waste caused by huge pages.

That's not correct. They could be read/written, but with zeroes.

> +Implemented by scanning the size of zero-filled pages of the VMA. It
> +is default disabled, and enabled via cmdline param "count_zero_page=true".

Probably best to keep it simpler:

"AnonZero" shows the size of anonymous pages that contain zeroes. Zero-filled
pages can indicate memory waste caused by memory-overallocation with (m)THPs.
Availability is controlled through XYZ.

-- 
Cheers,

David

