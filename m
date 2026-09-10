Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3AA0FC79F9F
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 06:40:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55F7B6B0092; Thu, 10 Sep 2026 02:40:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 538476B0093; Thu, 10 Sep 2026 02:40:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 44EAA6B0095; Thu, 10 Sep 2026 02:40:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 19CA46B0092
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 02:40:02 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4196FA0313
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:40:01 +0000 (UTC)
X-FDA: 85196902602.30.8941A1A
Received: from va-1-114.ptr.blmpb.com (va-1-114.ptr.blmpb.com [209.127.230.114])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4E43B120006
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 06:39:59 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GPA0mHuj;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789022399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mhx/dsFP2CMObhPGokTuIC/TPYYGoTzzepENJHonJ3Y=;
	b=crDaOxcczsQtRbPfNQzQN1YsLHgJ2Jz77uk8wyFjNxEQWKeVlKWOTJihYp32UPcMNnIc06
	9HLEqoJk2ZrKMr0dgt4WPDyO2hON/7a2wkYSaR9G7GWl2mzfUUqHFe1LzgmA7tGLZ9Mu2a
	Fy7Nyq1LDbaj93dOD1UGZY31gCg3SlA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789022399;
	b=q92pVkVB0a8hP/czR6x++tfqWep027Wk6xNH3MaxaA1Yvo+LwLGQEpd0avYYaVCodl543S
	nfzc6RAYBXsPVqjtjEqQGbxOD6cBWAWHOzaIM4/rUn7Z7wnrwlLSbIyu4sc+Fm/nlj3lfl
	gb+xn84getNdJ4kjygSRl2gAssbtxUo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=2212171451 header.b=GPA0mHuj;
	spf=pass (imf29.hostedemail.com: domain of lizhe.67@bytedance.com designates 209.127.230.114 as permitted sender) smtp.mailfrom=lizhe.67@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=2212171451; d=bytedance.com; t=1789022388; h=from:subject:
 mime-version:from:date:message-id:subject:to:cc:reply-to:content-type:
 mime-version:in-reply-to:message-id;
 bh=mhx/dsFP2CMObhPGokTuIC/TPYYGoTzzepENJHonJ3Y=;
 b=GPA0mHujZ95LwWo5+atmqbNiTFaW7PcToEuLh4rVZhtaMpPaxSC3HsdvKWvl8S/Plca8xY
 HcG0/pTSw03zCwvxMh3aAdiz9I74+sWalKTTkHyHuxaigbWDH2leaT6Mc9C8NH3r14zeiQ
 RHKZZJA66n2UhixeRymHQDwNIUYhJu9L8urETx1OpsEAePJtea/l/njYJ62Z4TAaRi5g8o
 zxFN/tD+YUGu1LqceS8vFXYjh4scfpX8M+Zp1pinMotjvaLUcr3AxbdjBZ6LJKI4Xr2qmq
 zpYJIXtEAS2LgI0fFYBtrtno5d6hqK1jglRQbSieGse4CaeesaCpeCuuLpUA6A==
Content-Type: text/plain; charset=UTF-8
In-Reply-To: <d1ede193-bc56-46de-9d0d-fc037ddf835d@kernel.org>
From: "Li Zhe" <lizhe.67@bytedance.com>
User-Agent: Mozilla Thunderbird
Cc: <muchun.song@linux.dev>, <osalvador@suse.de>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <aiqi.i7@bytedance.com>
Subject: Re: [PATCH] mm/hugetlb: fix overbroad MMU notifiers for unshared PMDs
Message-Id: <ab3d20db-380b-4b37-8a8f-2a0d9a6f7d6e@bytedance.com>
Content-Transfer-Encoding: quoted-printable
X-Original-From: Li Zhe <lizhe.67@bytedance.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, 
	"Andrew Morton" <akpm@linux-foundation.org>
Date: Thu, 10 Sep 2026 14:39:29 +0800
Mime-Version: 1.0
References: <20260831091023.66581-1-lizhe.67@bytedance.com> <20260831173220.72ab28190a44a305dacf4d04@linux-foundation.org> <47a6817e-e98e-4a00-8e2c-6a66d15ddb37@kernel.org> <874e7793-877a-40a5-97ce-11dd5b9ee9ba@bytedance.com> <d1ede193-bc56-46de-9d0d-fc037ddf835d@kernel.org>
X-Lms-Return-Path: <lba+26aa250b2+1d25d9+kvack.org+lizhe.67@bytedance.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 4E43B120006
X-Stat-Signature: stjiz9n41emq8n9piie7mxohrhqr56zx
X-Rspam-User: 
X-HE-Tag: 1789022399-251992
X-HE-Meta: U2FsdGVkX19JHczsHuu3sfwLIkaKkOVu7RplsYumMbJidnqwiRIPh9xIjhSrNL8SeREJkqJLkK1O5rOAvLrNrZ6Vextys37Mw/bfVKCuu//KS1Nui3E6gd8U9oJc3Dr5lkyZgmoS28aaTJ2+a62tBEjSbprvA5vp64NL3zNshZIHAMF5adArz0GAvYlamE3AECnOK5TdchRULkzZWkXq4pqt7eTO4R6hBncZX/Yw9MLao1+yr6ZBukr62r3KGfhyFmXSgNkW6hQaqfSm1gD7rI+LbMcgyDf7AuoscvCgn63Oauge0rphaZhnT2uoAV+dvthRy0kBABiLKS26CN3P5PgvySQ9kNjsA4v6l6kNYn4yA2AYDV9/ZixmX+xFuJbSp/+nh07kVo1VDzr0dZYpL0qx88YVMln/Vn+eHzdx5V17Fr4ShVQX8Spc6YAaRmZqFGgUzUcbPWrEhPbxZzulRUjAQ8BMf/r7wGF+NyMMEJaTINRzYKe9DLyUjhJ13JgIH0HWgFO78NLxjPuEXhw49GND5gGSqzb9vDPa7jllgMf/IMyGVfE/zXdlUr60iba97x/+w0xSlGFgTB5c2DW2ttrapFIud8BAOXS03FC5P78D+Gnhee6XTTbBVzjuCyLdfMHgUD0ssOit4DuJJnWD4EOBL2/fSpMUEzcAvbfI4EEC7LPSoLooeGV1Gfk8y28dPVKZYc09xzz1oMbIzvkahfHzphcvMJonL0Xy43k6nPxASnZmy5X4JkyPrbvutF6JrafRf0x7TeD5vZBlHXBtPcBZdNnYpQZCdkzV27jmOx2mQcc/viloZHcSiBb4N+c/MY1pqXQ8AJYjEuRoU30CX16JOv/jaDns4YftcX+4F+fb3hZFNEZuRXE8TsLIL9jhYTZlnGMJTvQxJDB991CL/nEZ6LC6OCIUyRPuThuvSgUdfgwxZj+pAJPcfZzGRgebqueyJmloeS5mkTftl2X
 dCSxSq/m
 xvv3C3siTcsUWvsx/7MDg6KnlFCzjvmkn2D6BluvcNG7iVW4jAgw3j2jYf6re+IgEPrekIZ3cCjYIBEWBUIskXpDX5ogiCFvR5pIemhPuZM+s86/Nys1N+EWiG1tBTuxtJTH8jNa7KeqKwkJ8/L+I3N8xJ1RA7G+0JVFLucB8JwzwWuBFljzicduC9WjUDeji2T5OO7QvepR7ssyLZ8zczCrPZ0/0zJu09VOYRrkkUNPJW4xWaIcu7HlCcmu1TUxxiNfvLKja2Nev/rUL9te2bJQXqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/10/26 12:59 AM, David Hildenbrand (Arm) wrote:
> On 9/8/26 09:09, Li Zhe wrote:
>> On 9/7/26 11:29 PM, David Hildenbrand (Arm) wrote:
>>> On 9/1/26 02:32, Andrew Morton wrote:
>>>> Thanks.
>>>>
>>>> So a modest performance improvement?
>>> Is that worth the complexity, though?
>>
>> That is a fair concern.
> In you setup, are the page tables ever being shared? I suspect you just r=
un a VM
> with no other processes actually sharing the memory?


Yes. In the tested setup, there is only one QEMU process mapping the
hugetlbfs file for the VM. The hugetlb page tables are not actually shared.

>
> One idea would be to just remember whether any sharing ever happened for =
a
> hugetlb file.


I reworked the patch based on your suggestion. Instead of walking the
page tables during unmap, this version records, per hugetlbfs inode,
whether PMD sharing has ever actually been established for the file. The
flag is set only after huge_pmd_share() successfully populates a shared
PMD table.

For the hugetlbfs zap/unmap paths, the conservative PUD-sized MMU
notifier expansion is skipped while the file has never seen PMD
sharing. Once PMD sharing has ever happened for the file, the code falls
back to the existing conservative behavior.

>
>> I tried to simplify the approach. Instead of computing the exact PUD
>> sub-ranges that contain shared PMD tables, this version keeps the
>> existing adjust_range_if_pmd_sharing_possible() logic unchanged and only
>> adds an actual shared-PMD check as a gate before it.
>>
>> So the behavior becomes:
>>
>>   =C2=A0 - if no shared PMD table is found, keep the notifier range unch=
anged;
>>   =C2=A0 - if any shared PMD table is found, fall back to the existing
>>   =C2=A0 =C2=A0 conservative PUD-sized expansion.
>>
>> This should still avoid the unnecessary 1G KVM invalidation for the
>> common unshared-PMD case, while keeping the range expansion policy
>> unchanged when a shared PMD is present.
>>
>> The resulting diff would look like this:
>>
>> diff --git a/mm/hugetlb.c b/mm/hugetlb.c
>> index 816dde7..7a61fc3 100644
>> --- a/mm/hugetlb.c
>> +++ b/mm/hugetlb.c
>> @@ -5355,10 +5357,12 @@ void __hugetlb_zap_begin(struct vm_area_struct *=
vma,
>>   =C2=A0 =C2=A0 =C2=A0if (!vma->vm_file)=C2=A0 =C2=A0 /* hugetlbfs_file_=
mmap error */
>>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;
>>
>> -=C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, start, end);
>>   =C2=A0 =C2=A0 =C2=A0hugetlb_vma_lock_write(vma);
>> -=C2=A0 =C2=A0 if (vma->vm_file)
>> +=C2=A0 =C2=A0 if (vma->vm_file) {
>>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i_mmap_lock_write(vma->vm_file->f_ma=
pping);
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (range_has_shared_pmd(vma, *start, *end)=
)
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 adjust_range_if_pmd_sharing_p=
ossible(vma, start, end);
>> +=C2=A0 =C2=A0 }
>>   =C2=A0}
>>
>>   =C2=A0void __hugetlb_zap_end(struct vm_area_struct *vma,
>> @@ -5397,7 +5401,9 @@ void unmap_hugepage_range(struct vm_area_struct
>> *vma, unsigned long start,
>>
>>   =C2=A0 =C2=A0 =C2=A0mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, =
0, vma->vm_mm,
>>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0start, e=
nd);
>> -=C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, &range.start, &=
range.end);
>> +=C2=A0 =C2=A0 if (range_has_shared_pmd(vma, range.start, range.end))
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, &=
range.start,
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =
=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&range.end);
>>   =C2=A0 =C2=A0 =C2=A0mmu_notifier_invalidate_range_start(&range);
>>   =C2=A0 =C2=A0 =C2=A0tlb_gather_mmu(&tlb, vma->vm_mm);
>>
>> @@ -6958,6 +6964,52 @@ void adjust_range_if_pmd_sharing_possible(struct
>> vm_area_struct *vma,
>>   =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0*end =3D ALIGN(*end, PUD_SIZE);
>>   =C2=A0}
>>
>> +static bool range_has_shared_pmd(struct vm_area_struct *vma,
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0unsigned =
long start, unsigned long end)
>> +{
>> +=C2=A0 =C2=A0 unsigned long v_start =3D ALIGN(vma->vm_start, PUD_SIZE);
>> +=C2=A0 =C2=A0 unsigned long v_end =3D ALIGN_DOWN(vma->vm_end, PUD_SIZE)=
;
>> +=C2=A0 =C2=A0 struct hstate *h =3D hstate_vma(vma);
>> +=C2=A0 =C2=A0 struct mm_struct *mm =3D vma->vm_mm;
>> +=C2=A0 =C2=A0 unsigned long address;
>> +
>> +=C2=A0 =C2=A0 if (huge_page_size(h) !=3D PMD_SIZE)
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
>> +
>> +=C2=A0 =C2=A0 /*
>> +=C2=A0 =C2=A0 =C2=A0* First apply the same cheap test as
>> +=C2=A0 =C2=A0 =C2=A0* adjust_range_if_pmd_sharing_possible(). Only the =
PUD-aligned
>> +=C2=A0 =C2=A0 =C2=A0* intersection can contain shared PMD tables.
>> +=C2=A0 =C2=A0 =C2=A0*/
>> +=C2=A0 =C2=A0 if (!(vma->vm_flags & VM_MAYSHARE) || !(v_end > v_start) =
||
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 end <=3D v_start || start >=3D v_end)
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 return false;
>> +
>> +=C2=A0 =C2=A0 start =3D max(ALIGN_DOWN(start, PUD_SIZE), v_start);
>> +=C2=A0 =C2=A0 end =3D min(ALIGN(end, PUD_SIZE), v_end);
>> +
>> +=C2=A0 =C2=A0 hugetlb_vma_assert_locked(vma);
>> +=C2=A0 =C2=A0 i_mmap_assert_write_locked(vma->vm_file->f_mapping);
>> +
>> +=C2=A0 =C2=A0 for (address =3D start; address < end; address +=3D PUD_S=
IZE) {
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 pte_t *ptep;
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 bool shared;
>> +
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 ptep =3D hugetlb_walk(vma, address, PMD_SIZ=
E);
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (!ptep)
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 continue;
>> +
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_lock(huge_pte_lockptr(h, mm, ptep));
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 shared =3D ptdesc_pmd_is_shared(virt_to_ptd=
esc(ptep));
>> +=C2=A0 =C2=A0 =C2=A0 =C2=A0 spin_unlock(huge_pte_lockptr(h, mm, ptep));
> I really don't like this piece of code to optimize something that is alre=
ady
> questionable in practice: overcommiting hugetlb folios for VMs.
>
> Can you share some more details which mechanism ends up zapping hugetlb f=
olios
> for the VM?
>
> If it's virtio-balloon's free-page-reporting, you should likely disable t=
hat for
> the VM.


It is not virtio-balloon free-page-reporting.

The setup uses a downstream, out-of-tree QEMU/KVM reclaim mechanism for
hugetlb-backed VM memory. KVM maintains hot/cold information for guest
memory. QEMU then asks KVM to select cold guest ranges and releases the
corresponding hugetlbfs-backed host ranges after taking care of the
required device-side unmapping.

The release path uses PUNCH_HOLE on the hugetlbfs file for 2M hugetlb
pages.

This is the case where the current conservative range expansion becomes
unnecessarily broad.

Does this patch look reasonable to you?

The updated patch looks like this:

---
diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 7611a84..1e24b8d 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -921,6 +921,9 @@ static struct inode *hugetlbfs_get_inode(struct=20
super_block *sb,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0simple_inode_init_ts(inode);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info->resv_map =3D resv_map;
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0info->seals =3D F_SEAL_SEAL;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 info->pmd_sharing_seen =3D false;
+#endif
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0switch (mode & S_IFMT) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0default:
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0init_special_inode(inode, =
mode, dev);
diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 16c4c4c..8f1f899 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -509,6 +509,9 @@ struct hugetlbfs_inode_info {
 =C2=A0 =C2=A0 =C2=A0struct inode vfs_inode;
 =C2=A0 =C2=A0 =C2=A0struct resv_map *resv_map;
 =C2=A0 =C2=A0 =C2=A0unsigned int seals;
+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+=C2=A0 =C2=A0 bool pmd_sharing_seen;
+#endif
 =C2=A0};

 =C2=A0static inline struct hugetlbfs_inode_info *HUGETLBFS_I(struct inode=
=20
*inode)
@@ -516,6 +519,27 @@ static inline struct hugetlbfs_inode_info=20
*HUGETLBFS_I(struct inode *inode)
 =C2=A0 =C2=A0 =C2=A0return container_of(inode, struct hugetlbfs_inode_info=
, vfs_inode);
 =C2=A0}

+#ifdef CONFIG_HUGETLB_PMD_PAGE_TABLE_SHARING
+static inline void hugetlbfs_set_pmd_sharing_seen(struct inode *inode)
+{
+=C2=A0 =C2=A0 HUGETLBFS_I(inode)->pmd_sharing_seen =3D true;
+}
+
+static inline bool hugetlbfs_pmd_sharing_seen(struct inode *inode)
+{
+=C2=A0 =C2=A0 return HUGETLBFS_I(inode)->pmd_sharing_seen;
+}
+#else
+static inline void hugetlbfs_set_pmd_sharing_seen(struct inode *inode)
+{
+}
+
+static inline bool hugetlbfs_pmd_sharing_seen(struct inode *inode)
+{
+=C2=A0 =C2=A0 return false;
+}
+#endif
+
 =C2=A0extern const struct vm_operations_struct hugetlb_vm_ops;
 =C2=A0struct file *hugetlb_file_setup(const char *name, size_t size,=20
vma_flags_t acct,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0int creat_fl=
ags, int page_size_log);
diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 7857728..e370960 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -5359,10 +5359,12 @@ void __hugetlb_zap_begin(struct vm_area_struct *vma=
,
 =C2=A0 =C2=A0 =C2=A0if (!vma->vm_file)=C2=A0 =C2=A0 /* hugetlbfs_file_mmap=
 error */
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0return;

-=C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, start, end);
 =C2=A0 =C2=A0 =C2=A0hugetlb_vma_lock_write(vma);
-=C2=A0 =C2=A0 if (vma->vm_file)
+=C2=A0 =C2=A0 if (vma->vm_file) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0i_mmap_lock_write(vma->vm_file->f_mappin=
g);
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 if (hugetlbfs_pmd_sharing_seen(file_inode(vma-=
>vm_file)))
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 adjust_range_if_pmd_sharing_poss=
ible(vma, start, end);
+=C2=A0 =C2=A0 }
 =C2=A0}

 =C2=A0void __hugetlb_zap_end(struct vm_area_struct *vma,
@@ -5401,7 +5403,9 @@ void unmap_hugepage_range(struct vm_area_struct=20
*vma, unsigned long start,

 =C2=A0 =C2=A0 =C2=A0mmu_notifier_range_init(&range, MMU_NOTIFY_CLEAR, 0, v=
ma->vm_mm,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0start, end);
-=C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, &range.start, &ran=
ge.end);
+=C2=A0 =C2=A0 if (hugetlbfs_pmd_sharing_seen(file_inode(vma->vm_file)))
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 adjust_range_if_pmd_sharing_possible(vma, &ran=
ge.start,
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=
=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0&range.end);
 =C2=A0 =C2=A0 =C2=A0mmu_notifier_invalidate_range_start(&range);
 =C2=A0 =C2=A0 =C2=A0tlb_gather_mmu(&tlb, vma->vm_mm);

@@ -7004,6 +7008,7 @@ pte_t *huge_pmd_share(struct mm_struct *mm, struct=20
vm_area_struct *vma,
 =C2=A0 =C2=A0 =C2=A0if (pud_none(*pud)) {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0pud_populate(mm, pud,
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0(pmd_t *)((u=
nsigned long)spte & PAGE_MASK));
+=C2=A0 =C2=A0 =C2=A0 =C2=A0 hugetlbfs_set_pmd_sharing_seen(mapping->host);
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0mm_inc_nr_pmds(mm);
 =C2=A0 =C2=A0 =C2=A0} else {
 =C2=A0 =C2=A0 =C2=A0 =C2=A0 =C2=A0ptdesc_pmd_pts_dec(virt_to_ptdesc(spte))=
;
--=20


Thanks,
Zhe

>

