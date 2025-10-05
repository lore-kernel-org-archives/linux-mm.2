Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB8A6CAC5BB
	for <linux-mm@archiver.kernel.org>; Sun,  5 Oct 2025 02:35:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D591B8E0005; Sat,  4 Oct 2025 22:35:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D30E88E0002; Sat,  4 Oct 2025 22:35:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6DB08E0005; Sat,  4 Oct 2025 22:35:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B314E8E0002
	for <linux-mm@kvack.org>; Sat,  4 Oct 2025 22:35:53 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4E357861D1
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:35:53 +0000 (UTC)
X-FDA: 83962495386.26.45A1058
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf15.hostedemail.com (Postfix) with ESMTP id 80E71A0009
	for <linux-mm@kvack.org>; Sun,  5 Oct 2025 02:35:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOFLrU8G;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759631751;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rzegS9FRnJ2j9ah3b1IUHaBCWuWvwbJb5MYOfqPsxeI=;
	b=LWkOjh15EBJ4m0ZGTb8B9id6f4Sbh+Yt+ePlFdMoW/Xx2H/+DENY2/cmfo+8idxf+7CBkI
	PH+5Wh+xuNKgNn8vaNFIbzFLZICmy2LG4b9ydL1yNRtt2TYT3zRL4639XHPxXanms8UvZ/
	LxTH7ck+/JhWMmThIc2Cdnc37GvSiH8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JOFLrU8G;
	spf=pass (imf15.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759631751; a=rsa-sha256;
	cv=none;
	b=qJyNUzo2X8PgL+NomQaB0BQUeTEZHpKbU9wYGpTvP4dSbFnt7+3iwhXy36kdq9n4o5Ndzv
	LRXAJfPtWMGgAZ4q1gT1sCki17KjpNPAZ5yCaIj4WeeHiEqk1ytt+Pe01gSxlMw/leolBf
	itZ2rY4bgn1pcMxsHzRFZOsxGRrMxnU=
Message-ID: <054ca3f1-b219-49dc-9c4a-6f648b9df7f1@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759631749;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=rzegS9FRnJ2j9ah3b1IUHaBCWuWvwbJb5MYOfqPsxeI=;
	b=JOFLrU8G99lkQF3OoatNpr66U50Pfg1ZU/7dq5EBnDcJgt4aEWA316Jrgw5CizIXFRoihi
	0NBV3vaWX2cGINyeNUZ1qsEUDP1P71ltkzyl/GVVuis5iKIA0s4rIm1eFTzFNdvM++Xzk1
	YH9zzU0ITLVrl7d0EsspbGMgK6RsLco=
Date: Sun, 5 Oct 2025 10:35:39 +0800
MIME-Version: 1.0
Subject: Re: [PATCH mm-new 2/2] mm/khugepaged: merge PTE scanning logic into a
 new helper
Content-Language: en-US
To: Wei Yang <richard.weiyang@gmail.com>, Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, lorenzo.stoakes@oracle.com,
 ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20251002073255.14867-1-lance.yang@linux.dev>
 <20251002073255.14867-3-lance.yang@linux.dev>
 <0d55d763-81ff-4b99-bb13-3dbb9af53cdc@arm.com>
 <20251004094217.bah5q2zxczrqontm@master>
 <f235a557-d031-4fcd-8c68-81d9ab7b54e0@arm.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <f235a557-d031-4fcd-8c68-81d9ab7b54e0@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 80E71A0009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: a6muno1oo7ai7y8qqzmrkartotq7smyu
X-HE-Tag: 1759631751-809179
X-HE-Meta: U2FsdGVkX190U7K0fmVrMoOb7o/EWSMYI0VbWv1IrtqHlwFU7kYZITxU13i8/z32TYJFl2Q88XiYK9jwJPLZbMQo9hvwikMvYUS0A7+Zq1wmZw3+HHYdcxKDE54Ju4Ym4zZeg3rw8VTCUfo8FQMwaFIapdbVQK1ZfCvnpFTbgiN+ILzctT6p04EAkOvpS+XEhEJzf8Mb+E2uGFkBdHQ4V5I3sXWajOhDvVW3m+hUEOJ0kkwYCH0GMFoWQjrAM/vMoGVdFtJnDay0afUE6Tn7bmBIrPK+PPi2ZHp75xqJm67FcojdG5+cOPmt823k/hDiAvrkhuYH9qrTGme0K/hoSHbAQa7rfRLc6F1RIkDVuzDkYGHv392AGMHhkF/E+C+byAvZm9oBx+TuMEO549J5AGRWYCpKBwS2LwdCOrSEga2lTBgYkUHFPL2JpKBWvw40Xv7HvHa9Zhjh8ohqjQBY5pldvu1D8DNX1ie6cY/6oya4TEzRGg2XVZeaVYiYzxUmSA7595rBNbPw1fnHTsQukn29D13oMpzAEaUn4WdVkuylMUBpnzIz338sqWL/HV+QO9gH1G+5aAkJHi2qRzrlm36qhUmhlLQpUfL2egpvaPIRW8+OM8uzcDFBiBTFGniLQpCTfW9OmQSkkF8zgGt9nQgsBAbOpFsf/g5Slfz285bnQVtGs+hcEh4PA5DhFjny39m71x1PeO2JRC5S/H6orqHhGu588h/zC/5q9qWLYoW2M4IY6JBKcDBPtiBkz1A7hd7nPSSOTS6dsO2aGKM7gPHDwGXwh8warxoW0s9pDEHh43KuYzkDuvQrFe3SIijQBfBfVi/tvvmpjbvwxkOJSMQN8yoCbf4gLwFBlE0CsIsOOKX6FRsR3EAC+XMEGRyNA6ASBXvMFx51Q8G6V1/nmrlVImntyRF47PI3LZGeM2zVOEkqywjIr51+n6odh9znnjmueAWAQCIMfq+45A5
 eIFwHDQK
 SrGGnjjWWVBZPpy4dAAi9AeZUyZmeSz1AzWUEh20sSxXM0Zz8ZClQvDsj8N7XQH+en9AGcd+Om+0g+1fjg2SIPIcplwlgBj1CXEfMfqchDk+0h/LMh3Y3HGW0nlGLUDQAOOcBaDEtVQD+JmYi7lig+7FIiF6TcHoD59pHUnXxko6YIohpBUDxwlaPP59wiGx8G0oSECgkT1ts5Wnh9sVCwTPx4UHxEqSFYyju2Cw2hEHHY7gVN5SB0dxBvGirpH5g8EZgVdL233AuMBQcGQJ7QxFMJNKcAN52Lnv/KK9qsmOj+RQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 2025/10/4 21:11, Dev Jain wrote:
> 
> On 04/10/25 3:12 pm, Wei Yang wrote:
>> On Fri, Oct 03, 2025 at 10:35:12PM +0530, Dev Jain wrote:
>>> On 02/10/25 1:02 pm, Lance Yang wrote:
>>>> From: Lance Yang <lance.yang@linux.dev>
>>>>
>>>> As David suggested, the PTE scanning logic in hpage_collapse_scan_pmd()
>>>> and __collapse_huge_page_isolate() was almost duplicated.
>>>>
>>>> This patch cleans things up by moving all the common PTE checking logic
>>>> into a new shared helper, thp_collapse_check_pte().
>>>>
>>>> Suggested-by: David Hildenbrand <david@redhat.com>
>>>> Signed-off-by: Lance Yang <lance.yang@linux.dev>
>>>> ---
>>> In hpage_collapse_scan_pmd(), we enter with mmap lock held, so for
>> This is true for the first loop, but we will unlock/lock mmap and 
>> revalidate
>> vma before isolation.
>>
>>> an anonymous vma, is it even possible to hit if (! 
>>> folio_test_anon(folio))?
>>> In which case we can replace this with VM_BUG_ON_FOLIO and abstract away
>>> till the folio_maybe_mapped_shared() block?
>> But it looks still valid, since hugepage_vma_revalidate() will check 
>> the vma
>> is still anonymous vma after grab the mmap lock again.
>>
>> My concern is would VM_BUG_ON_FOLIO() be too heavy? How about warn on and
>> return?
> 
> Frankly I do not have much opinion on the BUG_ON/WARN_ON debate since I 
> haven't
> properly understood that, but this BUG_ON is under CONFIG_DEBUG_VM 
> anways. But

Yeah, VM_BUG_ON_FOLIO() is under CONFIG_DEBUG_VM, so it won't affect
production kernels.

> if you want to change this to WARN then you can do it at both places.

It should flag such an impossible condition there during development.
So, I'd prefer to stick with VM_BUG_ON_FOLIO().

@Wei please let me know if you feel strongly otherwise :)

