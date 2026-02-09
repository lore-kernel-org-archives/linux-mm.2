Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A7D16EE6B73
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 20:13:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB6C76B00A6; Mon,  9 Feb 2026 15:13:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D64026B00A7; Mon,  9 Feb 2026 15:13:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C70716B00A9; Mon,  9 Feb 2026 15:13:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B65136B00A6
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 15:13:48 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 58975B7A26
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:13:48 +0000 (UTC)
X-FDA: 84426018936.09.CD95B97
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 66C824000C
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 20:13:46 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XFHatLmw;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770668026;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IUj5HJIBhj4RZxavIu4pGQfYLUmFK/ENqXYJC/iaU+4=;
	b=KXUmJAXf7+2B7Ki2R1LnupD+zcKSQP5Bzs5QQ8I7pVrmnJGjJC3nPOy9cUncyKQaV0rQ2D
	qDBHUDUFcrcwR4DTJaPQOJkZjTHFcokcUsoqUPsb7Jsr9hou5pt/0LczCs5ULqgQqwLWjV
	tzeN05V774Re6yhPI/J3tpZH85Lo6A8=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=XFHatLmw;
	spf=pass (imf12.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770668026; a=rsa-sha256;
	cv=none;
	b=KQXF+u3yhnbxJJIYfvacCe6EGiJoogoarQzmZEZhWzkLIJAy7La+3Zm62nhsukSnCly6DR
	Z7E7kJCjQLztoYDW0kS2wwmPdNEpmx4T789dC3iPtl56UQ8aoTWWql5yHlSXKc992aROdK
	mrlCE8kueqe5rWUNdNEK2/iNQ7Rg7nQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id F092044009;
	Mon,  9 Feb 2026 20:13:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501DEC116C6;
	Mon,  9 Feb 2026 20:13:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1770668024;
	bh=p5Kus+gwRqvoUsn0bc/m8wis6xhF8DCIaqMFKMsTxyo=;
	h=Date:Subject:From:To:Cc:References:In-Reply-To:From;
	b=XFHatLmwxVDK/4nKyyifL1reTue+cEidv8miAEIj5c4SxMxEUa7wmgYGpxQvssWvs
	 /R4DGHrOVkxzVnURO1DXkqyVk0IIhK1O/zgYlyMvt4kLx0e3xL0u3RbSeGJ4jBbLnx
	 ENuL/zm2PUkBxqKWjwM1hX9P7Niwllq3Up1PdngFf0aFkc5YXfeShOTLIhLDou3mBo
	 vtsfYGBzygwaGeSuxWsyzZjrpSj4PcnQkIs62InMdwjiaoLpP9Uo98gVyakdBD+v5z
	 RCF85kr6xGYbtpMiVsNbFnz7900wXM0K8D4nC2qBh0xuF6VF2bNcOIHXgaQgoj3AT0
	 DgcYYBbWreDtw==
Message-ID: <8f188d73-fc97-414b-bdaa-e72032b2bf82@kernel.org>
Date: Mon, 9 Feb 2026 21:13:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm: thp: Deny THP for guest_memfd and secretmem in
 file_thp_enabled()
From: "David Hildenbrand (Arm)" <david@kernel.org>
To: Ackerley Tng <ackerleytng@google.com>,
 Deepanshu Kartikey <kartikey406@gmail.com>
Cc: akpm@linux-foundation.org, lorenzo.stoakes@oracle.com,
 baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com, npache@redhat.com,
 ryan.roberts@arm.com, dev.jain@arm.com, baohua@kernel.org,
 seanjc@google.com, pbonzini@redhat.com, michael.roth@amd.com,
 vannapurve@google.com, ziy@nvidia.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 syzbot+33a04338019ac7e43a44@syzkaller.appspotmail.com
References: <20260209033558.22943-1-kartikey406@gmail.com>
 <0d9cada8-7148-4a5c-a09d-120ef54559d7@kernel.org>
 <cbf76e1d-6b5d-4072-9f46-027cea4c0478@kernel.org>
 <CADhLXY5nrTXmWMPeiLg37euyVeQsNDRUvKmQaPdxtE1YhPq_jQ@mail.gmail.com>
 <CAEvNRgEoPs5ia+u0ODra6N4BdOwpYa04j8nDxwfNVyfCOWnM6g@mail.gmail.com>
 <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <4ed1b111-f2f1-4f89-9308-fdd9d706ca37@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Stat-Signature: 9p746mw5axxzxyn8s4knk87ku7tq8qaa
X-Rspam-User: 
X-Rspamd-Queue-Id: 66C824000C
X-HE-Tag: 1770668026-35387
X-HE-Meta: U2FsdGVkX1+u5Zi4rp1WGsFUzvkpnmysINA3gKF/spFb1B+4fPOBbbU8/ulyX+mBHfJaF339m60eozMEIb04O8f6Irb73xL3r8phfaa6tA9Vn8EQgRB3UmU9FxRK7VlnwnIgBYiiEq1RpOErvsoC/m4Vwtwc2XAWzNgbdJVDVqJvmoUa9E1UObh+uFJ4CDBpjHuA/Ba6K5WvvEgZyi0sgF0CRdLFs7+bj9u7xz9kxvkV9xyS0CaTZPjga00RSblocy2VDXvmZhSe7ojuKokkThvXrUDaFHk1o3Fwi2+lpihSOrmTo8T/CD8hSsPEwYqEhUG/VGHQU5/CookwFwJsuCV2V/nrihYkjybPRgX0SIO/fuvvroHdBfJ43fAhof6j6Mhxva1FwotRYlZ41qk+Obx28qDvCmhlFJOZ58Fn68Noi3AUUmLbUyQpa0MSdHIhhxs7VK7JJ5YNKtfsHiBAui2MElo+MFSe0iFBghZI747xvzqpC8Ybmghg8ptxUvGgiTafSlE3pNXgjggUAh2VAxY2Tlg+rfgNziTW9sbd3YinLVEvxuhwd7FZf97e9MHW88G5aHK63h79SUuMAlCrzZ4cL9Bw5svDE3cwMWfzrM65n6Okkn6ikvZq9zB5jVLze/MupOhzjJobq863EBN+vMDD7BvfI/T8Ggr+aZAnwZNM9McMXaogrrnffQaL4gBA2p3I7Taho6BHcwfJqdRcltuPEYex8P2wLEf1Vwef01u/z/60JfqYAdQ5MKukMSm/BbgurjMtOMinYub575hyEDNYBYu+gt7agd+BWqtC4rZZCDuyaks9tFKryZGWPkpHeMa1jWxIy8mVgMLHMFgh/ODr6j06UBwA3IT8QMEPVc4ZPhyb//mFKu8SchYKw3Rat0cmczztgu8FZrHPHzuFzbMEVw/85JhbRn4wmzfP+Vrar2UiDnZkwxnLT1wWv4OAXSd3Sbl0uM8mAzjnh1P
 3ITx9Fd7
 EbqKil9EIJBybJgI/W26GQQtUz6OCKzyKuht69LWcr1gW7QQv88DEn2tjb/U0v4VCpRa9gOUocwCyEG5wvsWMRB948TfPmt1MuCF0KQN258hAn6tApdoC4hOqxcpu9gt/4fh1yxT4iTMUMynU7ToDhY3uQcXKtdfcuGEDt6GEtS5Oqy5JELnR4nl7k7wgZXwkgxI3AeioohDTm8BKY3RhXFlOgH/3IcIPdMsCuApyC6xFBbby7MKKGhoM8K80o1YDB9IHARQty0QAP8XYdrYo5DzvpSztWr6hLuCTCuBwZuG7t697RasYoR2obB5rSAXags8Dg2bw6w1eXaeR8HGL3J9SmpO6IfNghfeAavgLqLJqOpXakEdkOSzrwilDQUVzAp6Lfkca57mals59E0X/alYcqzTD4OXnIoHQW/HgYwj6ixmITrY1vm3QZ4x69+YuRgM9vI9R9J3hu7BxGhi7UEPCu7Q6uA+WeVxedG2Rp8vxUQ8xcI3Te4KSZa6HWPM/PKn2p7CGucX59PQKK6xCFsYHaQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/9/26 20:45, David Hildenbrand (Arm) wrote:
> On 2/9/26 19:22, Ackerley Tng wrote:
>> Deepanshu Kartikey <kartikey406@gmail.com> writes:
>>
>>> On Mon, Feb 9, 2026 at 4:12 PM David Hildenbrand (Arm) 
>>> <david@kernel.org> wrote:
>>>
>>> Hi David,
>>>
>>> Thanks for the suggestion. I looked into the get_write_access() path.
>>>
>>> Both guest_memfd and secretmem use alloc_file_pseudo() which skips
>>> calling get_write_access(), so i_writecount stays 0. That's why
>>> file_thp_enabled() sees them as read-only files.
>>>
>>> We could add get_write_access() after alloc_file_pseudo() in both, but
>>> I think that would be a hack rather than a proper fix:
>>>
>>> - i_writecount has a specific semantic: tracking how many fds have the
>>> file open for writing. We'd be bumping it just to influence
>>> file_thp_enabled() behavior.
>>>
>>
>> I agree re-using i_writecount feels odd since it is abusing the idea of
>> being written to. I might have misunderstood the full context of
>> i_writecount though.
> 
> i_writecount means "the file is open with write access" IIUC. So one can 
> mmap(PROT_WRITE) it etc.
> 
> And that's kind of the thing: the virtual file is open with write 
> access. That's why I am still wondering whether mimicking that is 
> actually the right fix.
> 
>>
>>> - It doesn't express the actual intent. The real issue is that
>>> CONFIG_READ_ONLY_THP_FOR_FS was never meant for pseudo-filesystem
>>> backed files.
>>>
>>> I think the AS_NO_READ_ONLY_THP_FOR_FS flag you suggested earlier is
>>> the cleaner approach. It is explicit, has no side effects, and is easy
>>> to rip out when CONFIG_READ_ONLY_THP_FOR_FS goes away.
>>>
>>
>> I was considering other address space flags and I think the best might
>> be to make khugepaged respect AS_FOLIO_ORDER_MAX and have somewhere in
>> __vma_thp_allowable_orders() check the maximum allowed order for the
>> address space.
> 
> The thing is that CONFIG_READ_ONLY_THP_FOR_FS explicitly bypasses these 
> folio order checks. Changing it would degrade filesystems that do not 
> support large folios yet. IOW, it would be similar to ripping out 
> CONFIG_READ_ONLY_THP_FOR_FS. Which we plan for one of the next releases :)
> 
>>
>> khugepaged is about consolidating memory to huge pages, so if the
>> address space doesn't allow a larger folio order, then khugepaged should
>> not operate on that memory.
>>
>> The other options are
>>
>> + AS_UNEVICTABLE: Sounds like khugepaged should respect AS_UNEVICTABLE,
>>    but IIUC evictability is more closely related to swapping and
>>    khugepaged might operate on swappable memory?
> Right, it does not really make sense
> 
>> + AS_INACCESSIBLE: This is only used by guest_memfd, and is mostly used
>>    to block migration. khugepaged kind of migrates the memory contents
>>    too, but someday we want guest_memfd to support migration, and at that
>>    time we would still want to block khugepaged, so I don't think we want
>>    to reuse a flag that couples khugepaged to migration.
> 
> It could be used at least for the time being and to fix the issue.

mapping_inaccessible(mapping) indeed looks like the easiest fix, given that
shmem "somehow" works, lol.

BUT, something just occurred to me.

We added the mc-handling in

commit 98c76c9f1ef7599b39bfd4bd99b8a760d4a8cd3b
Author: Jiaqi Yan <jiaqiyan@google.com>
Date:   Wed Mar 29 08:11:19 2023 -0700

     mm/khugepaged: recover from poisoned anonymous memory
     
..

So I assume kernels before that would crash when collapsing?

Looking at 5.15.199, it does not contain 98c76c9f1e [1].

So I suspect we need a fix+stable backport.

Who volunteers to try a secretmem reproducer on a stable kernel? :)


The following is a bit nasty as well but should do the trick until we rip
out the CONFIG_READ_ONLY_THP_FOR_FS stuff.


diff --git a/mm/huge_memory.c b/mm/huge_memory.c
index 03886d4ccecc..4ac1cb36b861 100644
--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -40,6 +40,7 @@
  #include <linux/pgalloc.h>
  #include <linux/pgalloc_tag.h>
  #include <linux/pagewalk.h>
+#include <linux/secretmem.h>
  
  #include <asm/tlb.h>
  #include "internal.h"
@@ -94,6 +95,10 @@ static inline bool file_thp_enabled(struct vm_area_struct *vma)
  
         inode = file_inode(vma->vm_file);
  
+       if (mapping_inaccessible(inode->i_mapping) ||
+           secretmem_mapping(inode->i_mapping))
+               return false;
+
         return !inode_is_open_for_write(inode) && S_ISREG(inode->i_mode);
  }


[1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/mm/khugepaged.c?h=v5.15.199

-- 
Cheers,

David

