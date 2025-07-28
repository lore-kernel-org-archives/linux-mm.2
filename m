Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30876C87FCE
	for <linux-mm@archiver.kernel.org>; Mon, 28 Jul 2025 06:29:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB12E6B0088; Mon, 28 Jul 2025 02:29:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A61F36B0089; Mon, 28 Jul 2025 02:29:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 977A66B008A; Mon, 28 Jul 2025 02:29:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 86D096B0088
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 02:29:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 10FB31D3B03
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:29:33 +0000 (UTC)
X-FDA: 83712697026.09.FDAF2DB
Received: from out30-112.freemail.mail.aliyun.com (out30-112.freemail.mail.aliyun.com [115.124.30.112])
	by imf04.hostedemail.com (Postfix) with ESMTP id 1BF5F40003
	for <linux-mm@kvack.org>; Mon, 28 Jul 2025 06:29:28 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T2Ji77X7;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1753684170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=61qzhtxumno+s72FV7o+Yq7d1PwT8D3g7Ax8dIA0Pwo=;
	b=JxKxN1voMBTW6tLF1vL0+nNDn6XPoA4cILSP7BoryRIt9mnpjoWoJ2ddhGHB89ETn/1BQO
	Yd5jNI5fQqgb6D6i8rMltQC2+6vSMmHNdGTflGu2AfGxnuseSQOz52FJmwQGx03SGWms0M
	5s0FnNQql08R/XeePFLY5RTgdVFJG+s=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=T2Ji77X7;
	spf=pass (imf04.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.112 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1753684170; a=rsa-sha256;
	cv=none;
	b=PxpAoz+l5CMY8OcLzLvLKdJDb9BeVd14Fw9Eq32EVQg5HeNMMCCSuUFAij4O33bxS99WfQ
	licj15ELqcdXQDBTbtSBE9UtQghGriB0hwlT1SsyYRgj1NmY8THtOw2HxDP2iw9DEhkG/i
	R/wvJnSy8dqhnszEYAhFGl/2Icth+Ss=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1753684166; h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
	bh=61qzhtxumno+s72FV7o+Yq7d1PwT8D3g7Ax8dIA0Pwo=;
	b=T2Ji77X7o+FOUlIvAuKrvQmKgzqM25xorSPHXi6iWtEO9DjDZmVHBX5jHlWygTwaJ2MrCnRwZPI5/Gy5w7sCWtDxrD3t8aodf+RfSLczVHKsQRQeoUvQNPbQ0LHmGqrZ6YROLN+Hu4nGnj8m4tBYWLMwyKFYhqnCfzDr1gK0Qzs=
Received: from 30.74.144.111(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WkD.cJF_1753684163 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 28 Jul 2025 14:29:24 +0800
Message-ID: <dce00acf-bbf6-4e4f-a646-d939998f979a@linux.alibaba.com>
Date: Mon, 28 Jul 2025 14:29:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: regression - mm: shmem: add large folio support for tmpfs affect
 GPU performance.
To: Hugh Dickins <hughd@google.com>
Cc: David Hildenbrand <david@redhat.com>,
 Patryk Kowalczyk <patryk@kowalczyk.ws>, da.gomez@samsung.com,
 baohua@kernel.org, wangkefeng.wang@huawei.com, ioworker0@gmail.com,
 willy@infradead.org, ryan.roberts@arm.com, akpm@linux-foundation.org,
 eero.t.tamminen@intel.com, =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?=
 <ville.syrjala@linux.intel.com>, "linux-mm@kvack.org" <linux-mm@kvack.org>
References: <CAJCW39JCDX6_S2Ojt1HMmX-h_qAKm2eBRzxX5kOHNJz60Zu=vw@mail.gmail.com>
 <d5c6ac93-1af0-4093-afea-94a29a387903@redhat.com>
 <63b69425-2fd1-2c77-06d6-e7ea25c92f34@google.com>
 <3f204974-26c8-4d5f-b7ae-4052cbfdf4ac@redhat.com>
 <a8ac7ec3-4cb3-4dd8-8d02-ede6905f322e@linux.alibaba.com>
 <da2ab844-98c9-4eb2-82ac-01d01bec30f3@linux.alibaba.com>
 <dab283bf-a9cf-30be-02ed-da0d7c8ffcf0@google.com>
 <0c9dc2fa-34c9-4db5-bea3-af4caf05ee6b@linux.alibaba.com>
 <df580afe-f7c2-c5eb-b575-373908e0f6a1@google.com>
From: Baolin Wang <baolin.wang@linux.alibaba.com>
In-Reply-To: <df580afe-f7c2-c5eb-b575-373908e0f6a1@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BF5F40003
X-Rspamd-Server: rspam06
X-Stat-Signature: yw6wkj8ffywk4fmxhsgpwxmmx3appae7
X-HE-Tag: 1753684168-245622
X-HE-Meta: U2FsdGVkX1/8/l2+EzR+gZMHT8yEPiKdcRFB0CLkrle7a/wzYpS5rxV1FADkAk5jqFHMsB7uHQTHG9yD9SN9o9jJEv3NRqC8qcMzltlDUt0mJcQ554h78YWTQ1QcBe3CJG0SAq4cixDk9MOvZxAZUVNtfeT4e0ltMwdEUGaK8/FaSPwvRvalisl6qJnKc9exdCpN70FTDgE4uMliP3kGhybNfNulNssQNof1FpJzcieCRftJGlLJ8/CRjmGRmwFcRvaA0UyuyxtFgjl++Nr8zaqmlwIQ5pzqPYKoFncd+IZttiW1kZiQeV3CGa4RqB6oDuKWVEwJGwHUtuUuaiKC3PekWjqQ08NIQ4VXp3lxMd9GwWXnbe9iQzTSrjzN9KM+nqM3VWZUvlLzjGiLV+Ea7aYuGrnnKVt/iOCoR6y8ydeD+IUoVUF6rTkSbaBcg6Y/5se8dkkQR+lXLlosKrb0cHrUq6nDHHF60UOFCCgdEeXQ/4MaWNeNFfxgYgYbREm9cO2WYXVGesPDxx5k8G9C1CI0YK2a0Cmj8ICkrpOaW/08m+0iR4CYARP2znSIDCqcuub0bE1sEgVFWmfHuw4MUz0RcnFYaim02RDDrw0gBKmNkIi/NfXLk78BE55wtOf81rZDOzfadPL7PEmXzwcBE7E7XkJFOONyxNUXOsF6pTw5iRvlUiQg2+wwpTXYPItry0ACQl/gFmo2tR0VrtNnT7l3WEvCNphMAJeunZ7RMMC+/oAT5IfQiQGi7rgouiGMflPQ+z66WutZhMQ9y3gVAvHT7CDW1I+Qnf0NEs/rbJzhcD2TqWRWuf1wCcH+DvBfX3omMTSVDWzeXtMraAjuY2ZCRLDILk5L55JSF6PaN/wCbp1JveK7I1MCn0f+7zj1Vppd85Jw7Lp5wopL6tfC3xu+IIo05K6xLuFS3SVqSDbLwTYcd2va8M/LIOB8CVntrkUkteg1rtRLBAR4BlA
 bzga8r/N
 rTtqDni1TPvrRo5/syJiZJiNm2ckYFwWDu4xFjNWd9JcG9vjLaMW/aLj4zrrza7vMZkMgPr4BsCxXF3kkCP5vPXntexTUP9OyOnmRFIE0qBoV2qFqCCsQHbt1q7TUZmSa5/nIhFnD4fNdiClRmFWSU6+6FTvZjsL2i3JPKeaSAQcarGzzTF6AhTuDf4ts5me/3t65HApqffTOLgv8vDtm2aYBxXduDZJg+xbvkk6G48zD0T2OCVjwQD22ghbqFLBZJ53yVepBCefdgnr2s2Zr5xZ1vg0NBSsFgJYw4uEj2RBVnWholS0L/G5Lcs1Y4RBqDbQ/lgxN6zfxdo5t38BvuuCFA9tdKhJL8EsI514cBzOIi5FaBwFowinhzvd13Ly2YR0vl3e8hrQWgUU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/7/28 13:35, Hugh Dickins wrote:
> On Fri, 25 Jul 2025, Baolin Wang wrote:
>> On 2025/7/25 12:47, Hugh Dickins wrote:
>>> On Fri, 25 Jul 2025, Baolin Wang wrote:
>>>>>
>>>>> I hope to correct the logic of i915 driver's shmem allocation, by
>>>>> extending
>>>>> the shmem write length in the i915 driver to allocate PMD- sized THPs.
>>>>> IIUC,
>>>>> some sample fix code is as follows (untested). Patryk, could you help test
>>>>> it to see if this resolves your issue? Thanks.
>>>
>>> This patch cannot be the right fix.  It may be a very sensible workaround
>>> for some in-kernel drivers (I've not looked or tried); but unless I
>>> misunderstand, it does nothing to restore userspace behaviour on a
>>> huge=always tmpfs.
>>
>> Yes. Initially, we wanted to maintain compatibility with the 'huge=' option,
>> meaning that 'huge=always' tmpfs mount would still allocate PMD-sized THPs.
>> However, the current implementation is the consensus we reached after much
>> debate:
>>
>> 1. “When using tmpfs as a filesystem, it should behave like other filesystems.
>> No more special mount options.” Per Matthew.
> 
> That's okay, I've not proposed a new mount option at all (though that is
> rather how "never" came to end up meaning "not usually": our shared dislike
> for adding yet more options).  I'm proposing (shock horror) respecting the
> long-standing meaning of "huge=always".

OK.

>> 2. “Do not let the 'huge=' mount option mean 'PMD-sized' when other sizes
>> exist.” Per David.
> 
> That's less obvious.  The collision in tmpfs between anon mTHP, file large
> folio, and huge mount option (where shmem_enabled in sysfs provides that
> mount option for the internal mounts) is certainly difficult to resolve
> in any way pleasing to all (or any) of us.
> 
> But what remains clear is that we should not degrade the behaviour of
> "huge=always" for existing users: they were given PMD-sized when possible
> before, and they should be given PMD-sized when possible now (not suited
> to all usages, when "huge=within_size" may be more suitable).

This is the most contentious point. When we agree on the principle that 
'when using tmpfs as a filesystem, it should behave like other 
filesystems,' it means that tmpfs's large folio allocations should also 
be consistent with other filesystems, i.e., ‘tmpfs will allow getting a 
highest order hint based on the size of write and fallocate paths, and 
then will try each allowable huge order’ (see shmem_huge_global_enabled()).

So, based on the above principle, we allocate large folios in the same 
way when ‘huge=always’ option. However, as you mentioned, this will 
break the previous behavior where 'huge=always' option always meant 
PMD-sized large folio allocation.

>> At the time, we should have sought your advice, but we failed. The long
>> historical discussion is in this thread[1]. So now the strategy for tmpfs
>> supporting large folios is:
> 
> Yes, it's a pity how limited and unresponsive I am, then and now and forever;
> but the principle of not regressing userspace is not a topic on which my
> special input should be needed.
> 
>>
>> "
>> Considering that tmpfs already has the 'huge=' option to control the PMD-sized
>> large folios allocation, we can extend the 'huge=' option to allow any sized
>> large folios. The semantics of the 'huge=' mount option are:
>> huge=never: no any sized large folios
>> huge=always: any sized large folios
>> huge=within_size: like 'always' but respect i_size
>> huge=advise: like 'always' if requested with madvise()
>>
>> Note: For tmpfs mmap() faults, due to the lack of a write size hint, still
>> allocate the PMD-sized large folios if huge=always/within_size/advise is set.
>>
>> Moreover, the 'deny' and 'force' testing options controlled by
>> '/sys/kernel/mm/transparent_hugepage/shmem_enabled' still retain the same
>> semantics. The 'deny' can disable any sized large folios for tmpfs, while the
>> 'force' can enable PMD sized large folios for tmpfs.
>> "
> 
> Thanks for the summary, I'll have to come back to it another time: on
> first reading, it is not incompatible with "huge=always" always trying
> for PMD-sized, but falling back to smaller large folios when unsuccessful.
> 
> (I'll mention in passing that I find it strange the way shmem is getting
> large folios of a selected subset of sizes from one direction, but large
> folios of all possible sizes from another direction - often dependent
> on whether i_nlink is 0 at the time, but maybe not.  My own preference,
> so long as those tunings exist, is that shmem should always be restricted
> to the selected subset of sizes; but I may well alienate everyone I've
> not already annoyed with that opinion, and it's probably "not a hill I'm
> prepared to die on", nor even directly relevant here - except that I'd
> better mention that unhappiness while I'm in the area.)
> 
>>
>> Currently, we have observed regression in the i915 driver but have not yet
>> seen userspace regression on a huge=always tmpfs.
> 
> I shall not object to a temporary workaround to suit the i915 driver; but
> insist it not be taken as excuse not to fix the userspace regression later.

OK. Let me fix the i915 driver first.

>> If you have better suggestions, please feel free to point them out. Thanks.
> 
> Sounds like you're disinclined to fix it yourself, and I'll lose the

No, I do intend to address this incompatibility myself. However, I 
wanted to clearly describe our previous discussions and decisions to you 
first, and then make a decision after fully understanding your opinion.

Now I see your point and I can create a patch to fix the semantics of 
'huge=always,' but I think there will still be a lot of contention and 
discussion. Let's continue the discussion in that patch.

Thanks for your input.

> argument if it's not fixed during this cycle (since 6.17-next will become
> 6.18 LTS); so I'd better carve out the time to get into it in coming weeks.

