Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8425E10F2853
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:53:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B92F06B0095; Fri, 27 Mar 2026 12:53:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B6A756B0096; Fri, 27 Mar 2026 12:53:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AA7096B0098; Fri, 27 Mar 2026 12:53:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 98FC96B0095
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:53:48 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 42C0A5E991
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:53:48 +0000 (UTC)
X-FDA: 84592439736.25.618CBA6
Received: from out-180.mta0.migadu.com (out-180.mta0.migadu.com [91.218.175.180])
	by imf30.hostedemail.com (Postfix) with ESMTP id 57B5D8000B
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:53:46 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f75mPENZ;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774630426;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I9csAY2Lvawgp7Rsam87YjKnm7rldK4hTm6EIfaKTPo=;
	b=jEHF6xeKXLL0f6co8TRZyBuR+VidZZ8vTyOMBtVz0Ph9YZepniPlnB4FvXhjgRtBpbNMlK
	AvDP4naxIW3JPRjXKR5gR0iw9mym+erGWvvgFARo+M/3Lq0YwVpfEGMt9uWpKzX5eoyZR2
	686s0DdgdXwuaKAht9MbA/YgtOaKgPU=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=f75mPENZ;
	spf=pass (imf30.hostedemail.com: domain of usama.arif@linux.dev designates 91.218.175.180 as permitted sender) smtp.mailfrom=usama.arif@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774630426; a=rsa-sha256;
	cv=none;
	b=h7frjMDHXfV2duQ5lVf2JPlEA82tHXy0mSHmjWDuoCwIxnNaSTF9NAufdadEgKNk9xtxa5
	eEYxZVevDO8NfQlwD4NWq812oVvnEZv61pykty0sV3jFUwuQJ6TInqJd3u/tX4ltm3wp5h
	0VQDmZBJ4AvGNC84eJA0TxnIfTp9Mc8=
Message-ID: <0725ce97-b8a3-47c9-952f-7b512873cc35@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774630424;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=I9csAY2Lvawgp7Rsam87YjKnm7rldK4hTm6EIfaKTPo=;
	b=f75mPENZ/0pogd7iZftgXzxU1U3uP/uDnUH51xNQ/Zl5ECBs158ZiTywN4eeQRE3ZbgIbD
	SOe/t2tapJrZ/LL8Ctf7vJeDgJkGGx5TgRBO6QFlILAZ2e8der8tSRw0PhdSMLZ2+GanQJ
	v6cbU9Vsavrir2wRkkI4EJWCx3V2d4c=
Date: Fri, 27 Mar 2026 12:53:34 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 3/4] elf: align ET_DYN base to max folio size for PTE
 coalescing
Content-Language: en-GB
To: WANG Rui <r@hev.cc>
Cc: Liam.Howlett@oracle.com, ajd@linux.ibm.com, akpm@linux-foundation.org,
 apopple@nvidia.com, baohua@kernel.org, baolin.wang@linux.alibaba.com,
 brauner@kernel.org, catalin.marinas@arm.com, david@kernel.org,
 dev.jain@arm.com, jack@suse.cz, kees@kernel.org, kevin.brodsky@arm.com,
 lance.yang@linux.dev, linux-arm-kernel@lists.infradead.org,
 linux-fsdevel@vger.kernel.l, linux-fsdevel@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, npache@redhat.com,
 pasha.tatashin@soleen.com, rmclure@linux.ibm.com, rppt@kernel.org,
 ryan.roberts@arm.com, surenb@google.com, vbabka@kernel.org,
 viro@zeniv.linux.org.uk, willy@infradead.org
References: <20260320140315.979307-4-usama.arif@linux.dev>
 <20260320160519.80962-1-r@hev.cc>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Usama Arif <usama.arif@linux.dev>
In-Reply-To: <20260320160519.80962-1-r@hev.cc>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57B5D8000B
X-Stat-Signature: zft9ngxxc3zz6wsj44ouzjtkxr1uts75
X-Rspam-User: 
X-HE-Tag: 1774630426-955054
X-HE-Meta: U2FsdGVkX191RzZg8+B6/kq2GXgjI/xTh2j4MidxUwjVh9zoslI+E+T4NiLf1AR4KTd69U5/z/04Hxubr3+fJlvdJePJ9tnLG46g4RtgvbSJZsuOs+TOxul8vU4N1Nh0RkiwNwJSj6Z6/qvG6NApG5mJRABeNnQmW07BAzclUD/sO1vmjvCe1JJvs8oJiVv8UoUSZ+aT5gLLxphxBegBNd3HswTn6u1Ixvorv8uWGmbantsjuXHvygXq4h8zV0t1N5Je26kUAsAZgUwPN7VQ3knUiWbEE7iU/ypDVSbS3ysdJ3hMOeiFY/dOGUfdStSXRg6ozSla3ZNjg/SCstS2egFLSYLrW+X9KcGZ6f5kaEHu9lCXS/raBH+evH+3YvYNjZHjHXbwACUHMq5pnwVRef7AVh+/MYMHxProTJvw7TRsShPdF7bbRjtkOGKShOhI9ZqldvoR8qkcq7t9HJGY2UQPoSnJmpjCXKbgyvdFulwcPGbmCiGUxgFw4sl9TsjB8SDXz0cCjoZXnpu2trlmjkWPdfUQtp/H1mXKhrPw9s2VqUwN7upCve3JdovYxOPKJgSU3vK9y63kf73eXB4qpu5TCrAteadfIypyjkP5e1He5TPdKayj5AvzGkDIauY+39B1euCa+08FJJynQiS74lHnCr5WGzoj4wk5z70H0hS13Ed3W+JK7Pe0IJX6ChvfQ0TkESodHp3P4xly13wQdsead5vwQedrzgxJ4CLu2Yqmw6rm1pjRlZcsKJqVxD4gGjzxqBS+05Sd7zEa1dkMaGIVVCE154RrmsXIcVvH0qs+i/TM98nNbrB9pVVdrpHEb3mPs0dE2czpWAKyByo26cizawfd51ou9tx30TA8TZ+rE1agx+/3/+iFsGM6Z/u3NoQGarNVrY+TsUmqzld41xlFbLS3tcMiqvMCF8k2euMGBBSCvJ41umVd+3LhYYJqsMA9FM4VpEmWzCibqxo
 f+ULt3XF
 3vhPrrhA1B417isgjNa+A4y1Af0GTMuQhIyPfIUD73zHVq1wE7K0FfKuyYgTJiyesUYItYU2WMVtt9A8pthGDsN5lir4q+AdAODdN4q883E3TbRPRUaInodSdCMOOEofSCrwdGQT3Y0UoBk7SAKPagPKieqqAOFDtfPMsXJRta3QoQf4wQzb+hvEYLxNxOUr0PeJUU/UXDzRXLNfq//dgxd6fC2XiRyJm0fvcRmtQdcVkYUpEbZgsyah3XkQozTEj4+cVmhRgYP9q75fzLBpksRqZ5bxGSVf6AmgMnhg8LTm50vfXtMntk9CMyzG+jLigJ4aL6865UIul7FjcNg3eMBGjvA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 20/03/2026 19:05, WANG Rui wrote:
> Hi Usama,
> 
> On Fri, Mar 20, 2026 at 10:04 PM Usama Arif <usama.arif@linux.dev> wrote:
>> diff --git a/fs/binfmt_elf.c b/fs/binfmt_elf.c
>> index 8e89cc5b28200..042af81766fcd 100644
>> --- a/fs/binfmt_elf.c
>> +++ b/fs/binfmt_elf.c
>> @@ -49,6 +49,7 @@
>>  #include <uapi/linux/rseq.h>
>>  #include <asm/param.h>
>>  #include <asm/page.h>
>> +#include <linux/pagemap.h>
>>
>>  #ifndef ELF_COMPAT
>>  #define ELF_COMPAT 0
>> @@ -488,19 +489,51 @@ static int elf_read(struct file *file, void *buf, size_t len, loff_t pos)
>>         return 0;
>>  }
>>
>> -static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr)
>> +static unsigned long maximum_alignment(struct elf_phdr *cmds, int nr,
>> +                                      struct file *filp)
>>  {
>>         unsigned long alignment = 0;
>> +       unsigned long max_folio_size = PAGE_SIZE;
>>         int i;
>>
>> +       if (filp && filp->f_mapping)
>> +               max_folio_size = mapping_max_folio_size(filp->f_mapping);
> 
> From experiments (with 16K base pages), mapping_max_folio_size() appears to
> depend on the filesystem. It returns 8M on ext4, while on btrfs it always
> falls back to PAGE_SIZE (it seems CONFIG_BTRFS_EXPERIMENTAL=y may change this).
> This looks overly conservative and ends up missing practical optimization
> opportunities.

mapping_max_folio_size() reflects what the page cache will actually
allocate for a given filesystem, since readahead caps folio allocation
at mapping_max_folio_order() (in page_cache_ra_order()). If btrfs
reports PAGE_SIZE, readahead won't allocate large folios for it, so
there are no large folios to coalesce PTEs for, aligning the binary
beyond that would only reduce ASLR entropy for no benefit.

I don't think we should over-align binaries on filesystems that can't
take advantage of it.

> 
>> +
>>         for (i = 0; i < nr; i++) {
>>                 if (cmds[i].p_type == PT_LOAD) {
>>                         unsigned long p_align = cmds[i].p_align;
>> +                       unsigned long size;
>>
>>                         /* skip non-power of two alignments as invalid */
>>                         if (!is_power_of_2(p_align))
>>                                 continue;
>>                         alignment = max(alignment, p_align);
>> +
>> +                       /*
>> +                        * Try to align the binary to the largest folio
>> +                        * size that the page cache supports, so the
>> +                        * hardware can coalesce PTEs (e.g. arm64
>> +                        * contpte) or use PMD mappings for large folios.
>> +                        *
>> +                        * Use the largest power-of-2 that fits within
>> +                        * the segment size, capped by what the page
>> +                        * cache will allocate. Only align when the
>> +                        * segment's virtual address and file offset are
>> +                        * already aligned to the folio size, as
>> +                        * misalignment would prevent coalescing anyway.
>> +                        *
>> +                        * The segment size check avoids reducing ASLR
>> +                        * entropy for small binaries that cannot
>> +                        * benefit.
>> +                        */
>> +                       if (!cmds[i].p_filesz)
>> +                               continue;
>> +                       size = rounddown_pow_of_two(cmds[i].p_filesz);
>> +                       size = min(size, max_folio_size);
>> +                       if (size > PAGE_SIZE &&
>> +                           IS_ALIGNED(cmds[i].p_vaddr, size) &&
>> +                           IS_ALIGNED(cmds[i].p_offset, size))
>> +                               alignment = max(alignment, size);
> 
> In my patch [1], by aligning eligible segments to PMD_SIZE, THP can quickly
> collapse them into large mappings with minimal warmup. That doesn’t happen
> with the current behavior. I think allowing a reasonably sized PMD (say <= 32M)
> is worth considering. All we really need here is to ensure virtual address
> alignment. The rest can be left to THP under always, which can decide whether
> to collapse or not based on memory pressure and other factors.
> 
> [1] https://lore.kernel.org/linux-fsdevel/20260313005211.882831-1-r@hev.cc
> 
>>                 }
>>         }
>>
>> @@ -1104,7 +1137,8 @@ static int load_elf_binary(struct linux_binprm *bprm)
>>                         }
>>
>>                         /* Calculate any requested alignment. */
>> -                       alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum);
>> +                       alignment = maximum_alignment(elf_phdata, elf_ex->e_phnum,
>> +                                                     bprm->file);
>>
>>                         /**
>>                          * DOC: PIE handling
>> --
>> 2.52.0
>>
> 
> Thanks,
> Rui


