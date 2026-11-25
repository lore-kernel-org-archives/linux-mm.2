Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5708606A326
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 09:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=hnA8Claz
Received: by kanga.kvack.org (Postfix)
	id C561A6B095E; Wed, 25 Nov 2026 04:44:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2DBE6B096A; Wed, 25 Nov 2026 04:44:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B43726B096C; Wed, 25 Nov 2026 04:44:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 92B8B6B095E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 04:44:00 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 19CDC80E1C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:44:00 +0000 (UTC)
X-FDA: 85473155040.16.622849F
Received: from mta0.migadu.com (out-1.mta0.migadu.com [91.218.175.1])
	by imf17.hostedemail.com (Postfix) with ESMTP id EF64040005
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 09:43:57 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hnA8Claz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795599838;
	b=wxio7CmkISXoSwggOF/SmKllnwPc3ILiiJ3ahBy2lYuKUdLHtDHik9yj/sVilddbkfyJ/J
	dPau97ZZTUPYLHOA/9bqpNkNYUJ7coUP2r0MmDi+fZ3WRZxpxJeTg9nVZSPBrBMz/Cj1Wr
	+eYlak2Z9ThXlM/xV24oWBsVn57HS2E=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795599838;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zwkuh38kqQPWjrw5sO6Ui9U4FrRZxi9iAdmh8XWT6AY=;
	b=J1Pk6VsT013Oc7s5cM5rmcXfqb+snUHyfDBSBykZ1Yi1ubiwygzw8CiFCgXuhF4SD+aYHQ
	J5lcenMjQ9oYYK3MvaG7yGMGKneNZyJDmUrwZiV8TI94/0M3ll83h30ke4Fsj1nzQnjzxj
	3Jt6P88hq4HCSWVHW/n+gZ21VUrjVP4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=hnA8Claz;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf17.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.1 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=lp9Na6yrRCFt2uMGIt1uFGfQ40jg/3cfzehQNSW8iak=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795599836; v=1; x=1796204636;
 b=hnA8ClazjFqbRXyIFkrYAEehIQ5Mi/Y7gsNO2vlzm1fK9Bo9MQoikC2r8NAm4bhQy6XEVX6v
 alE/V++ltuEmUox1q4dO7cD50Jh/rgX6C/yG2VZN3ytdP+G0AuPVpmSHlPb++zmqIcBDV8M4DjV
 3dAcBwXgCra8TOsS+LgGRWLQ=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 8b77d8fc15c5aee1;
	Wed, 25 Nov 2026 09:43:56 +0000
X-Mizu-Trace-ID: 8b77d8fc15c5aee1
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v3 02/19] hugetlb_vmemmap: Always flush TLB if needed upon
 PTE remapping
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <CADrL8HV0artLopXqsRyEfxRd5FrAKKXnSotwrTYV+7Wcd=D9mg@mail.gmail.com>
Date: Wed, 25 Nov 2026 17:43:40 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 sashiko-reviews@lists.linux.dev,
 Will Deacon <will@kernel.org>,
 Catalin Marinas <catalin.marinas@arm.com>,
 Oscar Salvador <osalvador@suse.de>,
 Andrew Morton <akpm@linux-foundation.org>,
 Kefeng Wang <wangkefeng.wang@huawei.com>,
 Nikos Nikoleris <nikos.nikoleris@arm.com>,
 Linu Cherian <linu.cherian@arm.com>,
 Mark Rutland <mark.rutland@arm.com>,
 David Hildenbrand <david@kernel.org>,
 Ryan Roberts <ryan.roberts@arm.com>,
 Nanyong Sun <sunnanyong@huawei.com>,
 Yu Zhao <yuzhao@google.com>,
 Frank van der Linden <fvdl@google.com>,
 David Rientjes <rientjes@google.com>,
 linux-mm@kvack.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <EEFDA411-4490-46B0-A245-6DBC1F6C0FE6@linux.dev>
References: <20261122184453.2668189-1-jthoughton@google.com>
 <20261122184453.2668189-3-jthoughton@google.com>
 <sashiko-outbox-228631@kernel.org>
 <CADrL8HV0artLopXqsRyEfxRd5FrAKKXnSotwrTYV+7Wcd=D9mg@mail.gmail.com>
To: James Houghton <jthoughton@google.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspamd-Queue-Id: EF64040005
X-Stat-Signature: rm35rurjxfbbr3zueoh7em5muncmmfsa
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795599837-20505
X-HE-Meta: U2FsdGVkX1+zwod/9lHMPk6NvlH0428ll41NcEmvbNfF6FBVhIOr4yAUFgnuHYkq356rDp9mSWuOKldPt1s7BmEUdDyhWkUYtfAfHYC/uWvuv+CrmOqtFvbGQ6gicQfetkrTz3y32H/0yUDD0J4+ByDlHmlApAdSke8Rq/Zp2/1jzoF8JR5HHRlmkCII2wF5HuBKFjCbkCOo3GbvG/Fk20NZATQ/XsKucGJM4YQmdEUKwFdzZePNz/Vf8RDAIwfBMNRdl6kwrdVRTwIHAIa71OeKf1x/S1dh+QwiOnd+mXlVoiCnL79i5ulL3Mgj21wGZKoBa5x207vl4I2RvG212CKjmpnoC7ugimUQr3XqWAEaK6zHbrThy/VfccOoNlAp7fd8SnjyOanj5B+Y/VeVIoBo2vNfBhTcYT2I0Dm4WkDARo8y9n9eWXB6vAZjEFa09ebcOdtGd3ORNgb/25w92Qt4taGKz/KHYZUffEaDcE10Jdjy18L2xnm0hD1I7oVnYaNFdUvGyHGm5XSEwtD89aKtkEU4caUKUiLL+E7yraE1/4/AjSOcc4wsK+pvkpfbNfvipZF95YKuSgEHSSK1tQzob2LX9GBpPnjKwyiugOg1qDHwLojmGGwlFIOFxYX4FoRSRRxDaQTEfzNODASAwaSp9X3HLe8Vkpvf4X7fDI+c1FHGoXoAPqxidPeYjeGHrxetmzqkIzmz+u2CJj6VE4zBrDkCNEU06N96G5zWXGMZbIPtYzDrzkpxYPSgtubtCLFraADJuaTUWOwtk69bpYatFov1Wf3ACy2BZbkhzQGCP967hi5QJY7sBa810A39CnPGsSlzE8rv3kLagfe6t6nFNw5e02QqGYZpW7PHTWPjmw8tH1Dcf466zpz9ak4DWEWbl+EDp+/iK6cqjRJAoJjOD+oKF6Qm9jc1My4fl1wOi8HpoLNN760DzqAZa7iK5gOxk6EqMMmje8v3MNM
 tX+QJmrZ
 Aztj4sK8gEy9MhDQxGzTx5GiWma5i14FzHIuwpgkm0YTgYpJ/SD5TRDmIEPbFv6SOi3DOc6jlB+bN8h8lnzbt/t/N2Kjtx+JzGkMtSVWCLjohe43jRxXl4xKwGeT8Once+muHGNl+PyCclR4mLCR0m7DQtUOelvkqv8YMa9dnoTMyxk9KrGT/uikOR/O9sPCrKRYH5McyeVY6xg/1xm+E4iXrZT7Q+fTkgZt34XDCFsKM1KUDOiPk90zx0+D1QTdE02ChjTHOuKq9lJ98HSpyu2oXypwHtIkxlK8cvYYbXF1D0OgVGZriyDr3M9OLPOwK9MlSXc5GyCbjs1/Kc0t3dMzZvGY0S7WDVu0nhG07WW+qGtIiRTzRhVvJzmwuNl+vOqjSPathCMVtJkyty3EAlp8juIvRQ0pjnGdeD66EyP6vaSDNL5hhPDNh7VZQEguOTZ+okUGUuJHz9KkdJNUiZdztNbp3N3UaaCzIk5P6pOA7xtkjLI53ZEJt5PI/wTWA3P/ILhiKXC/idTyceHz6ZGy04SQXXyQFe1EMJBZXE7JtE0km/+YtqpsY2Pit9YZBVFyS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 25, 2026, at 00:37, James Houghton <jthoughton@google.com> =
wrote:
>=20
> On Sun, Nov 22, 2026 at 11:08=E2=80=AFPM <sashiko-bot@kernel.org> =
wrote:
>>=20
>> Thank you for your contribution! Sashiko AI review found 2 potential
>> issues to consider:
>> - [Medium] mm/hugetlb_vmemmap: unnecessary TLB flush in
>>  vmemmap_remap_range() on error
>> - [Medium] mm/hugetlb_vmemmap: partial HVO state retained in
>>  vmemmap_remap_range()
>> --
>>=20
>> commit ec5d75eb023f87eb7c8518a7fd62d721c52bb9db
>> Author: James Houghton <jthoughton@google.com>
>>=20
>> hugetlb_vmemmap: Always flush TLB if needed upon PTE remapping
>>=20
>> This commit removes the early return on error in =
vmemmap_remap_range() so
>> that flush_tlb_kernel_range() still runs when =
walk_kernel_page_table_range_lockless()
>> returns a non-zero error code.
>>=20
>>> diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
>>> index 09b9fd83c1985..7be08c68c2f18 100644
>>> --- a/mm/hugetlb_vmemmap.c
>>> +++ b/mm/hugetlb_vmemmap.c
>>> @@ -163,13 +163,11 @@ static int vmemmap_remap_range(unsigned long =
start, unsigned long end,
>>>=20
>>>      ret =3D walk_kernel_page_table_range_lockless(start, end, =
&vmemmap_remap_ops,
>>>                                                  NULL, walk);
>>> -     if (ret)
>>> -             return ret;
>>>=20
>>>      if (walk->remap_pte && !(walk->flags & =
VMEMMAP_DEFER_TLB_FLUSH))
>>>              flush_tlb_kernel_range(start, end);
>>>=20
>>> -     return 0;
>>> +     return ret;
>>> }
>>=20
>> [Severity: Medium]
>> Does this issue an unnecessary broadcast TLB flush across [start, =
end)
>> when walk_kernel_page_table_range_lockless() fails with =
walk->nr_walked =3D=3D 0?
>>=20
>> With memory_hotplug.memmap_on_memory enabled, every runtime =
single-folio
>> allocation via alloc_fresh_hugetlb_folio() -> =
hugetlb_vmemmap_optimize_folio()
>> hits PageVmemmapSelfHosted() in vmemmap_pmd_entry() and returns =
-ENOTSUPP
>> on the first PMD with walk.nr_walked =3D=3D 0, triggering a full
>> flush_tlb_kernel_range(start, end) despite modifying no PTEs.  When a =
walk
>> fails partway through with walk->nr_walked > 0, this also flushes the =
full
>> [start, end) range rather than [start, start + walk->nr_walked * =
PAGE_SIZE),
>> and vmemmap_optimize_folio() immediately flushes that prefix a second =
time
>> via vmemmap_restore_range().
>>=20
>> Should the flush be gated on walk->nr_walked > 0 and bounded to
>> start + walk->nr_walked * PAGE_SIZE?
>=20
> Yes, I will do this in v4. Thanks!

If we don't allow vmemmap_update_pte to return an error, we don't need =
patch 2,
3 and part of 4 at all.

Thanks,
Muchun

>=20
>>=20
>> [Severity: Medium]
>> As reported by Muchun Song on v2 [1], does this change and the =
follow-up
>> patches in the series still retain partially optimized vmemmap states
>> instead of preserving all-or-nothing HVO semantics?
>=20
> Yes, this is intended.



