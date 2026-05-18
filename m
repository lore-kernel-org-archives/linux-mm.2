Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92BFDCD4F52
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 09:53:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D43FE6B00A5; Mon, 18 May 2026 05:53:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1BC96B00A6; Mon, 18 May 2026 05:53:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C322A6B00A7; Mon, 18 May 2026 05:53:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B313B6B00A5
	for <linux-mm@kvack.org>; Mon, 18 May 2026 05:53:52 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 8364DC2B7B
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:53:52 +0000 (UTC)
X-FDA: 84780079104.30.3223EFD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9A53D1C000A
	for <linux-mm@kvack.org>; Mon, 18 May 2026 09:53:50 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pd65kd8G;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779098030;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Bc0qUG5ezu0fBTIae+Gg2HH0O7czfnS/tLixkncMJ94=;
	b=27JE3A5g7rw8C5wxmM6KWtOJcYowr4TVMDQnSsModvr1incn5QonKbgbyR7R4xtad+yRxo
	fmmQzvnswbexdV58h/AUwU/N02iibjgnltQztTre5fsQFFLyZXaAcwU65FX8HKRfDfa1uD
	yDev1LAkTJEHgyJ9plfhL6q/Q2s66RA=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pd65kd8G;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779098030; a=rsa-sha256;
	cv=none;
	b=eis4JIPan+lVgUJkbi7dQprQ/plU5J/LPqRWKtWcdr8KtWX3B6BjbxcuxB3Ge/501cXpKr
	AAsA6W6RsldOnIBzaRyJ4MIx3ygqPneXcDyDrwgL/zau9oc3QQpTCkCrxwDBEjCgEj8xZ3
	QWDZ6qf8JKuOV/lniY8PjtX3Zq1zTTY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 66FE542A71;
	Mon, 18 May 2026 09:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A1DCC2BCB7;
	Mon, 18 May 2026 09:53:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779098029;
	bh=W8Y9KhF7UdtIAt1c+NPri553EDOVp1AAPUaE7TKCmjc=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=pd65kd8GwKjdONJbfTVC0Cbl/3yXe5p7s3Odr3JoeXeW5LNYe95k6Po6QAxURYpS7
	 B/fp4Vt5Z3BIPBT6bfhGi63GZlBdT1O4IjpTSFgqkdrl1GS76ZEqwVPiCihl8mgw25
	 ewkaG1poBVEHGPVLrhZkCfUmmYcBYaMy8YNHSrh0SLnR/GsnPO8dcDE7DsfBCg+0WR
	 zKuF/vEy1e8RoDYGByJjQS7ArI72vcW8qFhPO+TFbT+RYPfD0MuVuXglet+3AD+81z
	 MO7vGLYPvMjA8AvRMC7wYWoPCUZs2JpKZdhJml4rhXSJWvwHBF9InDkR9UY50YRVCV
	 Cp57Dwam949Zg==
Message-ID: <b65722ee-6476-4038-bfbb-44a32b3544fd@kernel.org>
Date: Mon, 18 May 2026 11:53:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/5] mm: reduce mmap_lock contention and improve page
 fault performance
To: Barry Song <baohua@kernel.org>, Matthew Wilcox <willy@infradead.org>,
 surenb@google.com
Cc: akpm@linux-foundation.org, linux-mm@kvack.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, mhocko@suse.com,
 jack@suse.cz, pfalcato@suse.de, wanglian@kylinos.cn, chentao@kylinos.cn,
 lianux.mm@gmail.com, kunwu.chan@gmail.com, liyangouwen1@oppo.com,
 chrisl@kernel.org, kasong@tencent.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
 loongarch@lists.linux.dev, linuxppc-dev@lists.ozlabs.org,
 linux-riscv@lists.infradead.org, linux-s390@vger.kernel.org,
 Nanzhe Zhao <nzzhao@126.com>
References: <20260430040427.4672-1-baohua@kernel.org>
 <afNM-gIqxpyJ6ro7@casper.infradead.org>
 <CAGsJ_4w0qcYmukHqsyRd0jomoyYkJjOt8b-Cgp53BgP-8QQghw@mail.gmail.com>
 <afS_L-5XeWIldTXA@casper.infradead.org>
 <CAGsJ_4wk=SDtgin+84Ev2TamU-JFfmrg_SUay=-tcYmnFvK6Nw@mail.gmail.com>
 <afTpoL3FklpQZNMM@casper.infradead.org>
 <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <CAGsJ_4ysMcrmDLSOwBkf7qwCQrcDWeEMXkHDajTJFMLKUk0bSQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: d5yqgyzjmd63o5ua3hd7k5utstqdkwkk
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 9A53D1C000A
X-Rspam-User: 
X-HE-Tag: 1779098030-226503
X-HE-Meta: U2FsdGVkX1/CHwj3FHE03Q93mNeVy2Fkz/GIx3WmcSOhvmTpiBmNDBld1wEdmmsl3YnoZCrSU/xyW2llD7Z6G8fPJW0nqTpg3CcCLbDyMCwqa0JTMNjECSgX4RRHFQzXsZUoiIRqu5bR5bT4xlclhSsPAKkWgZpmo4mzuN+f+BmrjgLw1lPQrOEX0TQ0uE1UoiGcrT01cps2/c3UkF617i+/DxyIFbSCJn5LSaPO+wHxfsTlkS8xnYZgOQmTjptC5K3g+t0zyUcQvBnlzekgDnUih2yO+r10wAqQze1K0xfElsaj5RfI94FRTzDVnKG5K9RiL701YVXkOBn1poSYKDrxTp1HKgKOmJGF7JlU4FUAzuFUAD2f9VkRu4VwKMwy4xrPz6J8ZDpYFqEiUyXn/WrzvpgTcN9yCIe/WktDm0xINw45KfNDUtk0506zh6AsJy/IO+4inUUYWxTc4Nq8xRutN+C9h5sylxfZZ6xeBfEegz0v2fpJHdaGsozMzuCWWxsHGfmg3z+fT94+iIDNrMk6bdR1Yw4YsZePBintConwuWE8vF3lsLLte0KIL4cKBgY/HJSQAcg16B4aG2rrlROebCAH0V6JsZzQCHGTTLhq6h/r0AshSrhCfqRi+Bm887g+j+p36ZTVdR9Amo7meSskDb2a7FvH3u6SLw6WR887VFGYet7+Acp7k2Ma2g/v9zquWk3fyGJihQM1FJiP4mVA0Kme1M4ivAWoy06jQ07CKdY4nG5jDjG5AeaVv3rGpreR6cnPSZucEq37szTOMQyk9M1IHXEvqzlkzaBKQZIyy96g7mTgLCA5fQAvEQXqg4HcakAdB7COHV8BvH1u70sYsPykWMOh23XgwS3p/Fkrqi/xWTLG+nfBQA+neRfuLCpHul1H+7UxjJW7Kl/qoer1TbJkFsQwyfd97geUytUyO81hLKUZfgZKS4QyXJL/0i8DFgU+RHs6K/Sjs0B
 ZrcTM4Lf
 Cto0vOM4teCcvqudPhrisGBs2kUxInp3waU6UNnaesL4PNVHyyysGsRTc3eZEXTeofBr160tiQ5eC3JIiCETSU90BgW/PRNTlso1Q+XCemfdmHrmBZWDAtmrRKSweI5RCkOAtjWHRQ26Jk6KXtkdKmSvwcWAWC0q8WKH2NywGbl4bjFIj6cyyVo1B5PE95AZdEmfQxs7eLNQFbzx1Vr1Z0qHZvREYsiRBmqMrlvB61TuKOOQLwF8RMXGpLIeBIBzVYTmmGrPpneKe4w0zkw2HvYazbnqRTz31tsEqSUQV1ODkPQzqy/kMYfhuwj3iN5VeN22IBTqPtylZJaKWQCoOMOA+cDwH4jW3/gBM+n3Y8IYMpVUcEKWr+H3WoM4Wz3tqLnZ2xPVgbdg6WlYSDM8dOu4fXmJS09/p2S4YCsBCdh+aQ8evzos8EPWumz+PvRYmJKvIdhzJ7ZlAIUnWfLDhZ4NZ7g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 5/17/26 10:45, Barry Song wrote:
> On Sat, May 2, 2026 at 1:58 AM Matthew Wilcox <willy@infradead.org> wrote:
>>
>> On Sat, May 02, 2026 at 01:44:34AM +0800, Barry Song wrote:
>>>
>>> It doesn’t have to involve unmapping or applying mprotect to
>>> the entire VMA—just a portion of it is sufficient.
>>
>> Yes, but that still fails to answer "does this actually happen".  How much
>> performance is all this complexity in the page fault handler buying us?
>> If you don't answer this question, I'm just going to go in and rip it
>> all out.
>>
> 
> Hi Matthew (and Lorenzo, Jan, and anyone else who may be
> waiting for answers),
> 
> As promised during LSF/MM/BPF, we conducted thorough
> testing on Android phones to determine whether performing
> I/O in `filemap_fault()` can block `vma_start_write()`.
> I wanted to give a quick update on this question.
> 
> Nanzhe at Xiaomi created tracing scripts and ran various
> applications on Android devices with I/O performed under
> the VMA lock in `filemap_fault()`. We found that:
> 
> 1. There are very few cases where unmap() is blocked by
>    page faults. I assume this is due to buggy user code
>    or poor synchronization between reads and unmap().
> So I assume it is not a problem.
> 
> 2. We observed many cases where `vma_start_write()`
>    is blocked by page-fault I/O in some applications.
>    The blocking occurs in the `dup_mmap()` path during
>    fork().
> 
> With Suren's commit fb49c455323ff ("fork: lock VMAs of
> the parent process when forking"), we now always hold
> `vma_write_lock()` for each VMA. Note that the
> `mmap_lock` write lock is also held, which could lead to
> chained waiting if page-fault I/O is performed without
> releasing the VMA lock.
> 
> My gut feeling is that Suren's commit may be overshooting,
> so my rough idea is that we might want to do something like
> the following (we haven't tested it yet and it might be
> wrong):
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 2311ae7c2ff4..5ddaf297f31a 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1762,7 +1762,13 @@ __latent_entropy int dup_mmap(struct mm_struct
> *mm, struct mm_struct *oldmm)
>         for_each_vma(vmi, mpnt) {
>                 struct file *file;
> 
> -               retval = vma_start_write_killable(mpnt);
> +               /*
> +                * For anonymous or writable private VMAs, prevent
> +                * concurrent CoW faults.
> +                */
> +               if (!mpnt->vm_file || (!(mpnt->vm_flags & VM_SHARED) &&
> +                                       (mpnt->vm_flags & VM_WRITE)))
> +                       retval = vma_start_write_killable(mpnt);

Likely is_cow_mapping() is what you would want to check to handle VMAs that
could have anonymous pages in them.

-- 
Cheers,

David

