Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071D0C98324
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 04:36:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A8BE86B0088; Sun, 27 Sep 2026 00:36:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A3E336B008A; Sun, 27 Sep 2026 00:36:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 953996B008C; Sun, 27 Sep 2026 00:36:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6F52A6B0088
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 00:36:57 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DE294A09F5
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:36:56 +0000 (UTC)
X-FDA: 85258282032.10.C15ECDA
Received: from mta0.migadu.com (out-102.mta0.migadu.com [91.218.175.102])
	by imf16.hostedemail.com (Postfix) with ESMTP id 8FB0B180002
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 04:36:54 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QBRVzqxH;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790483815;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dWYY41y+TIjqcwweYzZvn+Hoo22jk67SO0H7HNpMlbA=;
	b=z0UG/bE+1KpfjrE1hdjG15LwiL3eAitzqQ6HMpUpp2IVmVdU4uQw6CkrPqXBSgtJVRM1zx
	4xE7cq/oj1wXh++AVO1QEOa7IfAAeiA1kNqRMLAIM2qYe0EK8o70zkR9MpAeInjyUHetHB
	apoeVPy22KWMDGrJIzIDOGlkH30NV0o=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=QBRVzqxH;
	spf=pass (imf16.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.102 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790483815;
	b=QycsLU51P1KakNG2kzGyEvNnyI9/iI5XrkJw4+ATsIEjWqjFcMLT1PdRSVJ16dwrbfEhBc
	1/6t24zquFJ8G3GfM/04PhVq6yctP/VPIlgUX3T5iVcmZcZk7q7vz3dlT8WqYYkfb3h+yh
	L5RdxQa4SxrgfNDtKkz1GCpMTzchQTg=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=IceE4e/RLvwU0VGaJlE66jbhYKSpqTO1ckygmdlKcrE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790483812; v=1; x=1791088612;
 b=QBRVzqxHLh8BFjRVPlNnXTPSs9MopLL0sYT3b2GMKDdIQUb43NA7Cuiv6HNDAm5Z30o8Dhug
 Izbh6l8PiMHgSQGGzVJjXnvcYYScziszMLShd2vflN1uSegQs7kVk04d0pUMLLvClw9kVjhkv8i
 FvBGO9/sBDS83XreDqbCmSC4=
X-Envelope-To: linux-mm@kvack.org
Received: by mta12.migadu.com with ESMTPS id 232d4b177b281d97;
	Sun, 27 Sep 2026 04:36:52 +0000
X-Mizu-Trace-ID: 232d4b177b281d97
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.100.1.1.11\))
Subject: Re: [PATCH v3] mm/hugetlb: fix overbroad MMU notifiers for unshared
 PMDs
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <83eefc56-cdb3-4e9b-9a2c-13819493afaa@bytedance.com>
Date: Sun, 27 Sep 2026 12:36:36 +0800
Cc: linux-kernel@vger.kernel.org,
 linux-mm@kvack.org,
 aiqi.i7@bytedance.com,
 akpm@linux-foundation.org,
 david@kernel.org,
 osalvador@suse.de
Content-Transfer-Encoding: quoted-printable
Message-Id: <34FA9F7E-F38A-4CF6-B994-83B75E6E4CBF@linux.dev>
References: <20260924082004.82450-1-lizhe.67@bytedance.com>
 <76ee3d7a-cee9-4ff3-9d4c-068a46883e30@linux.dev>
 <83eefc56-cdb3-4e9b-9a2c-13819493afaa@bytedance.com>
To: Li Zhe <lizhe.67@bytedance.com>
X-Mailer: Apple Mail (2.3901.100.1.1.11)
X-Stat-Signature: acw53byiqe6fsedapqc3juq9jffqaf3a
X-Rspamd-Queue-Id: 8FB0B180002
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1790483814-236471
X-HE-Meta: U2FsdGVkX1/O4e7OMt/oaNgtgyRF7C7p7L+WbnUoxLIPX56/XkTpHQ29Q0GV9RcGxCIWb/j0oOvAiCCZzyvxq8qQxGYLU66jLc8LkAdtN4xSPsSPPetG5Y95CiS4xnYd48LlO9Uq/y6GWFvypZdKxvw95gLM/U3YwWv3RXpjYrpH4D0bOyHUb++bcnNFJ+e7yy/t9/0Z6dqbAQk7dgWQ2HTFl6zZuTeTETlVpAp/7RbZ6z6x0wjFUDmy/9OWRtGgOLBpkZaZdpgq+NFHPQlAHzFW+vedGTfiZCKLziHb4xcFU7VbL0nBq+mJZyBWxl2+h/tsLILy3ttDtjRrgLakW1+ogOhbtx2m8ipHQzSyuK1c+1OGJhS6U4FiYbZl5BuBKurytho5DZpmZgQK1vS9M1zVp2HWuXJouFJuwcxyJnhnqxMva99gJSnuvtZ1pnTomyZZ7emBYjZmI2w1AMmKTYhCKcNlnaXiIoLKa/uwUM8XypGDWhcKXFh19nWqDbbUqmgyMhrUFJOZ4/riMYbC6UwIaPL64AoluKlXqtYpFDXsgSIv8zzbXmYBs8YQJR0Gn6pXnOELoBbUaCC5HcViH+dSiv5sDNVLQXjHEurT0m7n7jlx3pYmKDdLMiLgpyhckkjP81obsNueLmB6hhwaz2cgPVm+yvZmBE+xpevN8v3YvmJK49T1UCor1901uSBNHKXWw4WLSVT7o8z4x6x4cfOQrFxZpqniNGGKRBSUL4vYJ/Bdss9hXaw8vCs5gif+4ATPOIpn3Q0u2RcTJNQ1EcWMs/LSBbtLulrXcSW4IGNnXbmdm7wd+Ximr2OZLV+iZWtJrRXN/plxqDP0zOOspeAc3GP/biNSyWwsmX3ENvH+CPCGXy86xncQFFGZeTJRXvz0a3jKCvPjWQs+aE7BHguaE4yEhmLP0J1Xmj0JaNQLEsy+DGaVR+2zBAja532ZJ4F509r/AzkHVf+6uSr
 2nlHfZuJ
 Ejpt20USB/ORtC0+a0fjJh1C1vnrBnoSYTWFaXVNpjIss/3Obi8Wx8oVnNgEOfGvs5QOlEmvGZFGVbx4wjV9JNWAz8NP44CZx9lXbMrecywtFWNOfw43ga3WupPde5jk4chLQzk9lHW7sVGaUvZWIE2eBxkSNp98RB4QYySrC8V1wUGLgSaXb2lVhucZZv/V0RUD7JXuvaihCQZv4xYEUBle8vEmrhuYCzONxvCnkWEIPD8vNQxhkaZ6GmhEjHE/3vhIk4PoC21hQ4JJNu3p3A+8KACXRMQnMLFzUcIS/bUV9ukQHWbwJw9iQbw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 24, 2026, at 19:20, Li Zhe <lizhe.67@bytedance.com> wrote:
>=20
> On 9/24/26 5:51 PM, Muchun Song wrote:
>>=20
>>=20
>> On 2026/9/24 16:20, Li Zhe wrote:
>>> Hugetlb currently expands MMU notifier ranges to PUD boundaries =
whenever
>>> PMD sharing is possible. That is only needed when huge_pmd_unshare()
>>> actually detaches a shared PMD page table, because clearing the PUD
>>> invalidates the whole PUD-sized virtual address range.
>>>=20
>>> For hugetlbfs hole punch, and similarly for other hugetlb unmap =
paths,
>>> a shared mapping can pass the "PMD sharing is possible" range test =
in
>>> adjust_range_if_pmd_sharing_possible() even when the hugetlbfs file =
does
>>> not currently have any shared PMD page tables. KVM then receives a =
1G
>>> invalidation for a 2M operation and zaps unrelated secondary =
mappings,
>>> so the guest has to fault them back in.
>>>=20
>>> Avoid this by tracking active PMD-sharing attachments per hugetlbfs
>>> inode. The count is incremented only after huge_pmd_share() =
successfully
>>> installs a shared PMD table, and decremented when =
__huge_pmd_unshare()
>>> actually detaches one. Since huge_pmd_share() can run concurrently =
under
>>> i_mmap_lock_read(), use atomic operations for the count. A zero =
count is
>>> used to skip the conservative notifier range expansion only after
>>> excluding concurrent PMD sharing with the mapping write lock.
>>>=20
>>> On a Redis-in-VM workload that punches cold 2M hugetlb pages, this =
patch
>>> improves P99 QPS stability while punching pages, reducing the QPS
>>> degradation ratio from 7.09% to 1.45%.
>>>=20
>>> Reported-by: aiqi.i7 <aiqi.i7@bytedance.com>
>>> Signed-off-by: Li Zhe <lizhe.67@bytedance.com>
>>> ---
>>> v2:=20
>>> =
https://lore.kernel.org/all/20260922090749.24905-1-lizhe.67@bytedance.com/=

>>> v1:=20
>>> =
https://lore.kernel.org/all/20260831091023.66581-1-lizhe.67@bytedance.com/=

>>>=20
>>> ChangeLogs:
>>> v2->v3:
>>> - Rework the sticky state based on Andrew's feedback: use a =
per-inode
>>>    counter of active PMD-sharing attachments, so files can return to =
the
>>>    no-active-sharing state after PMD sharing ends.
>>>=20
>>> v1->v2:
>>> - Rework the implementation based on David's suggestion: remember
>>>    whether PMD sharing ever happened for a hugetlbfs file, and skip =
the
>>>    conservative notifier range expansion while it has not. This =
avoids
>>>    the per-unmap page-table walk.
>>>=20
>>>   fs/hugetlbfs/inode.c    |  1 +
>>>   include/linux/hugetlb.h | 43 =
+++++++++++++++++++++++++++++++++++++++++
>>>   mm/hugetlb.c            | 13 ++++++++++---
>>>   3 files changed, 54 insertions(+), 3 deletions(-)
>>>=20
>>> diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
>>> index 7611a8470ea26..78e27ce0a6f63 100644
>>> --- a/fs/hugetlbfs/inode.c
>>> +++ b/fs/hugetlbfs/inode.c
>>> @@ -921,6 +921,7 @@ static struct inode *hugetlbfs_get_inode(struct=20=

>>> super_block *sb,
>>>           simple_inode_init_ts(inode);
>>>           info->resv_map =3D resv_map;
>>>           info->seals =3D F_SEAL_SEAL;
>>> +        hugetlbfs_pmd_sharing_init(inode);
>>>           switch (mode & S_IFMT) {
>>>           default:
>>>               init_special_inode(inode, mode, dev);
>>> diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
>>> index 16c4c4caa126c..6b4f92b7f7ae4 100644
>>> --- a/include/linux/hugetlb.h
>>> +++ b/include/linux/hugetlb.h
>>> @@ -12,6 +12,7 @@
>>>   #include <linux/page_ref.h>
>>>   #include <linux/list.h>
>>>   #include <linux/kref.h>
>>> +#include <linux/atomic.h>
>>>   #include <linux/pgtable.h>
>>>   #include <linux/gfp.h>
>>>   #include <linux/userfaultfd_k.h>
>>> @@ -509,6 +510,9 @@ struct hugetlbfs_inode_info {
>>>       struct inode vfs_inode;
>>>       struct resv_map *resv_map;
>>>       unsigned int seals;
>>> +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>>> +    atomic_t pmd_sharing_count;
>>> +#endif
>>>   };
>>>     static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct=20
>>> inode *inode)
>>> @@ -516,6 +520,45 @@ static inline struct hugetlbfs_inode_info=20
>>> *HUGETLBFS_I(struct inode *inode)
>>>       return container_of(inode, struct hugetlbfs_inode_info,=20
>>> vfs_inode);
>>>   }
>>>   +#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
>>> +static inline void hugetlbfs_pmd_sharing_init(struct inode *inode)
>>> +{
>>> +    atomic_set(&HUGETLBFS_I(inode)->pmd_sharing_count, 0);
>>> +}
>>> +
>>> +static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode)
>>> +{
>>> +    atomic_inc(&HUGETLBFS_I(inode)->pmd_sharing_count);
>>> +}
>>> +
>>> +static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode)
>>> +{
>>> +    atomic_dec(&HUGETLBFS_I(inode)->pmd_sharing_count);
>>> +}
>>> +
>>> +/*
>>> + * A 32-bit counter can theoretically wrap, but doing so would =
require
>>> + * billions of active PMD-sharing attachments to the same inode and=20=

>>> is not
>>> + * expected in practice. Treat any non-zero value as active so a=20
>>> wrapped
>>> + * negative value still takes the conservative notifier range.
>>> + */
>>> +static inline bool hugetlbfs_pmd_sharing_active(struct inode =
*inode)
>>> +{
>>> +    return atomic_read(&HUGETLBFS_I(inode)->pmd_sharing_count) !=3D =
0;
>>=20
>> Testing for non zero covers the negative half of the cycle,
>> but the 2^32nd increment changes the value back to zero.
>>=20
>> The inode-wide total is not bounded by PID_MAX_LIMIT because
>> one mm can have an attachment in every PUD-sized part of a
>> large mapping.  For example, a 4-level x86 mm has about
>> 131,000 user PUD slots.  Roughly 32,769 child mms can therefore
>> create more than 2^32 attachments by faulting one address in
>> each PUD of a single large inherited MAP_SHARED hugetlb VMA.
>> This also does not require one backing huge page per
>> attachment: huge_pte_alloc() installs or shares the PMD table
>> before hugetlb_no_page() attempts to obtain the huge page.
>>=20
>> At the zero value, an unmap can take i_mmap_rwsem for write,
>> observe no active sharing, and issue only the original narrow
>> notifier.  Its subsequent __huge_pmd_unshare() can still
>> clear a PUD and decrement the counter from zero to -1, leaving
>> the rest of the PUD-sized invalidation unreported.
>>=20
>> Could this use a 64-bit or saturating counter so an active
>> count can never be mistaken for zero?
>>=20
>> Therefore, I recommend using atomic64_t.
>>=20
>> Thanks,
>> Muchun
>=20
>=20
> Thanks for the detailed explanation.
>=20
> I did consider that such an extreme case could theoretically cause a
> problem, but I expected it to be practically unreachable. But since we
> can cover this corner case simply by using atomic64_t, that is =
definitely
> better.
>=20
> I will switch the counter to atomic64_t in v4 and drop the 32-bit wrap
> comment.

Another option would be use refcount infrastructure since it already
consider the 32-bit wrap issue itself.

>=20
> Thanks,
> Zhe
>=20
>>=20
>>> +}
>>> +#else
>>> +static inline void hugetlbfs_pmd_sharing_init(struct inode *inode) =
{}
>>> +
>>> +static inline void hugetlbfs_pmd_sharing_inc(struct inode *inode) =
{}
>>> +
>>> +static inline void hugetlbfs_pmd_sharing_dec(struct inode *inode) =
{}
>>> +
>>> +static inline bool hugetlbfs_pmd_sharing_active(struct inode =
*inode)
>>> +{
>>> +    return false;
>>> +}
>>> +#endif
>>> +
>>>   extern const struct vm_operations_struct hugetlb_vm_ops;
>>>   struct file *hugetlb_file_setup(const char *name, size_t size,=20
>>> vma_flags_t acct,
>>>                   int creat_flags, int page_size_log);
>>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>>> index 4f6f58bf3db6c..cb27c06d1f7a7 100644
>>> --- a/mm/hugetlb.c
>>> +++ b/mm/hugetlb.c
>>> @@ -5361,10 +5361,12 @@ void __hugetlb_zap_begin(struct=20
>>> vm_area_struct *vma,
>>>       if (!vma->vm_file)    /* hugetlbfs_file_mmap error */
>>>           return;
>>>   -    adjust_range_if_pmd_sharing_possible(vma, start, end);
>>>       hugetlb_vma_lock_write(vma);
>>> -    if (vma->vm_file)
>>> +    if (vma->vm_file) {
>>>           i_mmap_lock_write(vma->vm_file->f_mapping);
>>> +        if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
>>> +            adjust_range_if_pmd_sharing_possible(vma, start, end);
>>> +    }
>>>   }
>>>     void __hugetlb_zap_end(struct vm_area_struct *vma,
>>> @@ -5403,7 +5405,10 @@ void unmap_hugepage_range(struct=20
>>> vm_area_struct *vma, unsigned long start,
>>>         mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, =
vma->vm_mm,
>>>                   start, end);
>>> -    adjust_range_if_pmd_sharing_possible(vma, &range.start,=20
>>> &range.end);
>>> +    i_mmap_assert_write_locked(vma->vm_file->f_mapping);
>>> +    if (hugetlbfs_pmd_sharing_active(file_inode(vma->vm_file)))
>>> +        adjust_range_if_pmd_sharing_possible(vma, &range.start,
>>> +                             &range.end);
>>>       mmu_notifier_invalidate_range_start(&range);
>>>       tlb_gather_mmu(&tlb, vma->vm_mm);
>>>   @@ -7006,6 +7011,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm,=20=

>>> struct vm_area_struct *vma,
>>>       if (pud_none(*pud)) {
>>>           pud_populate(mm, pud,
>>>                   (pmd_t *)((unsigned long)spte & PAGE_MASK));
>>> +        hugetlbfs_pmd_sharing_inc(file_inode(vma->vm_file));
>>>           mm_inc_nr_pmds(mm);
>>>       } else {
>>>           ptdesc_pmd_pts_dec(virt_to_ptdesc(spte));
>>> @@ -7037,6 +7043,7 @@ static int __huge_pmd_unshare(struct =
mmu_gather=20
>>> *tlb,
>>>       pud_clear(pud);
>>>         tlb_unshare_pmd_ptdesc(tlb, virt_to_ptdesc(ptep), addr);
>>> +    hugetlbfs_pmd_sharing_dec(file_inode(vma->vm_file));
>>>         mm_dec_nr_pmds(mm);
>>>       return 1;



