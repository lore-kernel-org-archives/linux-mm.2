Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25742E87821
	for <linux-mm@archiver.kernel.org>; Tue,  3 Feb 2026 13:04:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8769D6B00A1; Tue,  3 Feb 2026 08:04:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 833A86B00A2; Tue,  3 Feb 2026 08:04:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 743B56B00A3; Tue,  3 Feb 2026 08:04:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 62B866B00A1
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 08:04:33 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 2C162D4F04
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:04:33 +0000 (UTC)
X-FDA: 84403164426.25.276FBF0
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	by imf08.hostedemail.com (Postfix) with ESMTP id 138A516000E
	for <linux-mm@kvack.org>; Tue,  3 Feb 2026 13:04:30 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WMy+Y0Ch;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770123871;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uBPpNKanZj6K3Gi0ydO3+Vz58hBdosQfpGmuDZsKE14=;
	b=A/VqhVn1cowk8tVklRQRodqyXNW7yCDKtkKIFdT8lhi24IV4zgFWro61Al1/PJR1YX58oX
	fOYdAVhjDyxb50hPGx7waQImB68picDurTRh4PezX28WLA29eShx7XrALx7zBH3ymib9zk
	RNVX0zu14+BFUsL+UorJfWi6pjQlhpw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=WMy+Y0Ch;
	spf=pass (imf08.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.208.49 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770123871; a=rsa-sha256;
	cv=none;
	b=IF4TcoHWQwiBL0FtkGMJrw/l6tXcUCcJptyM1N03xXQStcHuNc+f1+15NZoamUPAvnxeWv
	e6DGnbFGGnnH8CNV/qEYMmW/tlxzFl7JsnPM2AKMwNW0QOnGP/nXjsy9smLVHzaQXsB0JP
	em7UonkVb0pmdgzR0KFbDD5tGo+Jv6k=
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6580dbdb41eso8464060a12.0
        for <linux-mm@kvack.org>; Tue, 03 Feb 2026 05:04:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770123869; x=1770728669; darn=kvack.org;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uBPpNKanZj6K3Gi0ydO3+Vz58hBdosQfpGmuDZsKE14=;
        b=WMy+Y0Chl6DTVCzxFXfdxRvv+Z3qkH6Y2myDjNNQPB/P54zwv8GdyNUXWStp+wps22
         BbOHYzRMrisTv+Mn0lFxJ1RyMRCtHkgSKhjHwnwKEZ5+Dy1hVkA0AEdH1fZTbeo9Fd1Z
         iB0hSGfnItemmw0hvIyyzwBSNCh3dFTOxv8NA0QUhEdX4QhHhSn1cEepVqEwdmmnsgFU
         JdBlqdWpDdKD/xIyPNkHobEp4RDlDN0U/iSaZ57tH5MNQMQytU2i5oQinbeDv4SubPXh
         hehhwTnTTjkQGukAKSld0SEzdZnHMnFDYY0m4MvmJQ4Rziyl2R9UoU18oMwiQ51JsbeE
         NSYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770123869; x=1770728669;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :reply-to:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uBPpNKanZj6K3Gi0ydO3+Vz58hBdosQfpGmuDZsKE14=;
        b=KPvSFt1EpPPkAmG2FCBf8uu/mI4UCTFYhPuJpBI6RQWsMJF5AQg8ZXY0+E06RJSKp0
         OBIl2ELLTMDISdj+Yv+f/D8w9OR5Sn8hVIrKSBDq85HaLXBBYf3MDinNK1VRdUKPn1cz
         PpNCpYJlduy9AwBwc/lTLeVFwwhIwZof5Zi4mUOi0fDiUuK/UqvExX/hOdFb5Im3d/fr
         QF4zAWcxp0e+Fl5IEP7S941CSNYkmFxvWITrw+0X6ZI8GTLBS8L620B5Zqgo2VQF7cng
         GG0Jg9QXsITgouen1efrDXcTEp9jM1eMW4L6slFG3ZNgnkigpjklWCBKNwlUNNsVWYaH
         hsOQ==
X-Forwarded-Encrypted: i=1; AJvYcCXTDGVpq4HSRhrO/7njNeeS1gvbdO6OQ0B59zTRe6rameTwXdjwDwHO20QfwWo/wYvbIHPJ6fDeZg==@kvack.org
X-Gm-Message-State: AOJu0YzJxzAXdO2OjEmUtsQcVpbKsd7ZluCUdycVC8KikHTEsppJddFY
	Bqy1QqrtBmTiokRYctQl1ZY1qQaQjrYg+Y2hAru6cpt/ZyBpZqBa2xbi
X-Gm-Gg: AZuq6aJoCUietolK+B88kIawXLLjO7Mv8e7VMjVDnMyG+/KfL4/v2aW2ZDrSQqj/L77
	ZLd5yWVFeIx0U4IvG+nZrbY4Rm91GxcR1disklYVuYYHRQ0yTUBLNVJV7YEkqjXOfbkpZRIQ3MD
	+dVHRe2166ohS/5ymAvAWGyW4eya2BieMOuq/S8elrWzlOnhcEpOCM8m+ed+Sf7mqCLhEajY1xn
	JSrex9CxUG5k6BP+riGwi5LW/JD0QKEuMZaIcR37zrlj9meEL37iQcs/X/hP/j1ND7WYAf7/NgR
	HwYeZ7MCGCEQMsOLNGlJRFF70TM8zkEyB3HPiOJb2ONlUYHJzSxnW6T3XKXRE6ns4CCatEMrJLn
	2xJuVZdcopceXToeV7L1hdh1SEdfhHBJ9L60tfmdm+foQQvCf5GoOdYn4LJ3R9VJSzpJA251T82
	fx6p0CdLVV5Q==
X-Received: by 2002:a05:6402:84e:b0:64d:1d2b:238f with SMTP id 4fb4d7f45d1cf-658de58b535mr8663098a12.19.1770123869007;
        Tue, 03 Feb 2026 05:04:29 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-658b46aba2fsm9311104a12.30.2026.02.03.05.04.28
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 03 Feb 2026 05:04:28 -0800 (PST)
Date: Tue, 3 Feb 2026 13:04:27 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Zi Yan <ziy@nvidia.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, Gavin Guo <gavinguo@igalia.com>,
	david@kernel.org, akpm@linux-foundation.org,
	lorenzo.stoakes@oracle.com, riel@surriel.com,
	Liam.Howlett@oracle.com, vbabka@suse.cz, harry.yoo@oracle.com,
	jannh@google.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
	stable@vger.kernel.org, Gavin Shan <gshan@redhat.com>
Subject: Re: [PATCH] mm/huge_memory: fix early failure try_to_migrate() when
 split huge pmd for shared thp
Message-ID: <20260203130427.n2td43cb275ybi7j@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20260130230058.11471-1-richard.weiyang@gmail.com>
 <178ADAB8-50AB-452F-B25F-6E145DEAA44C@nvidia.com>
 <20260201020950.p6aygkkiy4hxbi5r@master>
 <C620202F-685A-4B9E-B51B-078EBE5BF0C4@nvidia.com>
 <08f0f26b-8a53-4903-a9dc-16f571b5cfee@igalia.com>
 <4D8CC775-A86C-4D80-ADB3-6F5CD0FF9330@nvidia.com>
 <20260203000035.opgq74myrja54zir@master>
 <EF19148C-5365-4D00-AF21-B0D71E799740@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <EF19148C-5365-4D00-AF21-B0D71E799740@nvidia.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspamd-Server: rspam11
X-Stat-Signature: tewb14eay5nqso1jpdnbueyppuenbrou
X-Rspam-User: 
X-Rspamd-Queue-Id: 138A516000E
X-HE-Tag: 1770123870-55708
X-HE-Meta: U2FsdGVkX1/HfW+bcK054MWad+edQWaSTUQ25eK1sj13wETGL3OpHsCyebeGoByCjm7s4iBCINIRIP/t4h5Ozyizh1m7dle493U+r53alfVLP65h2Wn/VWNZlx2yN9dzlZ6+0QckfeX5Ej8P50btPOoXK1PVVFm+xDfcBwpTL8+8t9E3lhYvW3bvB2EWNAX5Zn8plhCn1DVe7wNJ9hX/PwYgE7KzekVWD+Ykg2s25zHUIG5TqNC1cfetWn5Vn8Eefl7RROX4JuS/bWaUlKVOFiMpAqOPqjbBY2OrSbvYr2P45xghrXU4oNJssdpZbkQw/1Xq7HPL3SbfeC7giIj6FerLqCGuIxEMr+/bwTAQ1EmtBMGIweIZQ0pRUED+UuXkROg6spbK6ZCl6GbLuM3O1Yoebs1E3fzC0DWD/tTROlCA7+bzrJHkqaMZV9TU5nndsNFV84W23ZOeqn14gm2SM/056ScO+i12XZDDS/2cMwI5CBwGuZye/5e475E6PnYUnyCZTrUGjj07BzmhiQ9cJ/QGn3ZmSg7P+4abCD9Q9XKuoOYVqUHwTdKEk5pD+SbOw9srU72qqKzs3iziJd3P+zUuDylcm2vLyMMB+Yr8A2tkW1gKuqrGOBk1wnAAFD++Q/pkcpwYC9KDLPeyS5umyvDJfLFyIpuvPAx+TDim8kxJAvd42nm75JOcGFORj2ZeaRgf3E/HfAMkg1UwYw58R9+aJDAldWp3iAy5+Qb1VRwknpuIHrWfbdc7TBhvhzmsguWw58yObiN8yz0uDBETepbRzOGRkQHjOx9oYPTawIE+jjTHn4RmI3OEGs2bi5hF0ngaKIiT1avgfqdobJfnnI4oLPSXDxCE4EKEKWqaAxkTWjyObgt6oO4D/+FlSgba0HaaCWjns+c8K1ECLI4PLqheM5QGu3ZEX5mTrcMcXSdO4MDcAktWYIW7mGULy5+1qMli6FsIvi94AYtOPJi
 CwdwguYV
 AxFm8u9AEnECxBCCfqYBQ4AZPTW0sIqXvjUwyENean064BAHf4pT2LX+pW96ApfLJ8l4fqU+QBXDcf+SqBMWovLKmWG8aJrvqgpC27icbeueFTrXQhWf5e+wIIhVba52VZFF2303gRftDNi0Lt8Yf+Bwfz3CSIEPPKNvKoLUv1dhogjf8eg9HTmjnmEscj22AXgXezPUEW7IJYsgSJ68/S02ZzlsGDzltvgLAsJlR8JyEmsgbppCCWL//pYDHRwPz87kPIiWQH5wpNSWwwj1CpcLApEKodo0TECHAJELw/nTl8Orb57897yApWOsPtRLTMX+/uM+kh796NQszmgUSEC/lgb9X1uKZF93h/a/q89o66yUqCp4pQKy48kxUH5gJlgjw01bVaHIepWgdUfGoPfpnb+b67enpOgmOd/vLntyHJzK5Ea/wy9crr2PNeBRiEnmG6ePucLzvwSwe2jmDb9AF70Mfog9Po//uy1k6jyhlOM2hzGZbqGr/VhY6EanGkKll5BVDMy2O4++wB9xbDOheWrhjtGHxAncBCmSv6tqogR32Vdi+y4h8Cs59U+B6CjTx2tkXshraL0ucTT9UTQQKmZKDsM6bmgQk7I0kW7X835idqxYcy/z3FKLfFLtW8aLZ0FgbDZJXjtTicrLkZXG6k4DQjs9K6Tb54tqfD0WYZEPbBYzcv07MuTDj+0ZTA2rzBg0Kgp6iDEamV3JY86wen0SA3D1adnGOKYOjl36YgCLS5kycxj4aX6Cido1WHM6V/vvYAZ6RzVX6EGKCtXBeSJ3yTFrzWaa8Y0sx2ykxEHywlzpkMUDDYSURNFxlxEnt3VfvyD0X+B3i2t/B5MV9NePCUKTpWHQifOunUiPgUl/toY/RsdnwOXeNOwhBaPKM4CT7ZgvvyZ1AoTQaDIE6LA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 07:07:12PM -0500, Zi Yan wrote:
>On 2 Feb 2026, at 19:00, Wei Yang wrote:
>
>> On Sun, Feb 01, 2026 at 09:20:35AM -0500, Zi Yan wrote:
>>> On 1 Feb 2026, at 8:04, Gavin Guo wrote:
>>>
>>>> On 2/1/26 11:39, Zi Yan wrote:
>>>>> On 31 Jan 2026, at 21:09, Wei Yang wrote:
>>>>>
>>>>>> On Fri, Jan 30, 2026 at 09:44:10PM -0500, Zi Yan wrote:
>>>>>>> On 30 Jan 2026, at 18:00, Wei Yang wrote:
>>>>>>>
>>>>>>>> Commit 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and
>>>>>>>> split_huge_pmd_locked()") return false unconditionally after
>>>>>>>> split_huge_pmd_locked() which may fail early during try_to_migrate() for
>>>>>>>> shared thp. This will lead to unexpected folio split failure.
>>>>>>>>
>>>>>>>> One way to reproduce:
>>>>>>>>
>>>>>>>>      Create an anonymous thp range and fork 512 children, so we have a
>>>>>>>>      thp shared mapped in 513 processes. Then trigger folio split with
>>>>>>>>      /sys/kernel/debug/split_huge_pages debugfs to split the thp folio to
>>>>>>>>      order 0.
>>>>>>>>
>>>>>>>> Without the above commit, we can successfully split to order 0.
>>>>>>>> With the above commit, the folio is still a large folio.
>>>>>>>>
>>>>>>>> The reason is the above commit return false after split pmd
>>>>>>>> unconditionally in the first process and break try_to_migrate().
>>>>>>>
>>>>>>> The reasoning looks good to me.
>>>>>>>
>>>>>>>>
>>>>>>>> The tricky thing in above reproduce method is current debugfs interface
>>>>>>>> leverage function split_huge_pages_pid(), which will iterate the whole
>>>>>>>> pmd range and do folio split on each base page address. This means it
>>>>>>>> will try 512 times, and each time split one pmd from pmd mapped to pte
>>>>>>>> mapped thp. If there are less than 512 shared mapped process,
>>>>>>>> the folio is still split successfully at last. But in real world, we
>>>>>>>> usually try it for once.
>>>>>>>>
>>>>>>>> This patch fixes this by removing the unconditional false return after
>>>>>>>> split_huge_pmd_locked(). Later, we may introduce a true fail early if
>>>>>>>> split_huge_pmd_locked() does fail.
>>>>>>>>
>>>>>>>> Signed-off-by: Wei Yang <richard.weiyang@gmail.com>
>>>>>>>> Fixes: 60fbb14396d5 ("mm/huge_memory: adjust try_to_migrate_one() and split_huge_pmd_locked()")
>>>>>>>> Cc: Gavin Guo <gavinguo@igalia.com>
>>>>>>>> Cc: "David Hildenbrand (Red Hat)" <david@kernel.org>
>>>>>>>> Cc: Zi Yan <ziy@nvidia.com>
>>>>>>>> Cc: Baolin Wang <baolin.wang@linux.alibaba.com>
>>>>>>>> Cc: <stable@vger.kernel.org>
>>>>>>>> ---
>>>>>>>>   mm/rmap.c | 1 -
>>>>>>>>   1 file changed, 1 deletion(-)
>>>>>>>>
>>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>>> index 618df3385c8b..eed971568d65 100644
>>>>>>>> --- a/mm/rmap.c
>>>>>>>> +++ b/mm/rmap.c
>>>>>>>> @@ -2448,7 +2448,6 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>>>   			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>>>   				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>>>   						      pvmw.pmd, true);
>>>>>>>> -				ret = false;
>>>>>>>>   				page_vma_mapped_walk_done(&pvmw);
>>>>>>>>   				break;
>>>>>>>>   			}
>>>>>>>
>>>>>>> How about the patch below? It matches the pattern of set_pmd_migration_entry() below.
>>>>>>> Basically, continue if the operation is successful, break otherwise.
>>>>>>>
>>>>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>>>>> index 618df3385c8b..83cc9d98533e 100644
>>>>>>> --- a/mm/rmap.c
>>>>>>> +++ b/mm/rmap.c
>>>>>>> @@ -2448,9 +2448,7 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>>>> 			if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>>>> 				split_huge_pmd_locked(vma, pvmw.address,
>>>>>>> 						      pvmw.pmd, true);
>>>>>>> -				ret = false;
>>>>>>> -				page_vma_mapped_walk_done(&pvmw);
>>>>>>> -				break;
>>>>>>> +				continue;
>>>>>>> 			}
>>>>>>
>>>>>> Per my understanding if @freeze is trur, split_huge_pmd_locked() may "fail" as
>>>>>> the comment says:
>>>>>>
>>>>>> 		 * Without "freeze", we'll simply split the PMD, propagating the
>>>>>> 		 * PageAnonExclusive() flag for each PTE by setting it for
>>>>>> 		 * each subpage -- no need to (temporarily) clear.
>>>>>> 		 *
>>>>>> 		 * With "freeze" we want to replace mapped pages by
>>>>>> 		 * migration entries right away. This is only possible if we
>>>>>> 		 * managed to clear PageAnonExclusive() -- see
>>>>>> 		 * set_pmd_migration_entry().
>>>>>> 		 *
>>>>>> 		 * In case we cannot clear PageAnonExclusive(), split the PMD
>>>>>> 		 * only and let try_to_migrate_one() fail later.
>>>>>>
>>>>>> While currently we don't return the status of split_huge_pmd_locked() to
>>>>>> indicate whether it does replaced PMD with migration entries successfully. So
>>>>>> we are not sure this operation succeed.
>>>>>
>>>>> This is the right reasoning. This means to properly handle it, split_huge_pmd_locked()
>>>>> needs to return whether it inserts migration entries or not when freeze is true.
>>>>>
>>>>>>
>>>>>> Another difference from set_pmd_migration_entry() is split_huge_pmd_locked()
>>>>>> would change the page table from PMD mapped to PTE mapped.
>>>>>> page_vma_mapped_walk() can handle it now for (pvmw->pmd && !pvmw->pte), but I
>>>>>> am not sure this is what we expected. For example, in try_to_unmap_one(), we
>>>>>> use page_vma_mapped_walk_restart() after pmd splitted.
>>>>>>
>>>>>> So I prefer just remove the "ret = false" for a fix. Not sure this is
>>>>>> reasonable to you.
>>>>>>
>>>>>> I am thinking two things after this fix:
>>>>>>
>>>>>>    * add one similar test in selftests
>>>>>>    * let split_huge_pmd_locked() return value to indicate freeze is degrade to
>>>>>>      !freeze, and fail early on try_to_migrate() like the thp migration branch
>>>>>>
>>>>>> Look forward your opinion on whether it worth to do it.
>>>>>
>>>>> This is not the right fix, neither was mine above. Because before commit 60fbb14396d5,
>>>>> the code handles PAE properly. If PAE is cleared, PMD is split into PTEs and each
>>>>> PTE becomes a migration entry, page_vma_mapped_walk(&pvmw) returns false,
>>>>> and try_to_migrate_one() returns true. If PAE is not cleared, PMD is split into PTEs
>>>>> and each PTE is not a migration entry, inside while (page_vma_mapped_walk(&pvmw)),
>>>>> PAE will be attempted to get cleared again and it will fail again, leading to
>>>>> try_to_migrate_one() returns false. After commit 60fbb14396d5, no matter PAE is
>>>>> cleared or not, try_to_migrate_one() always returns false. It causes folio split
>>>>> failures for shared PMD THPs.
>>>>>
>>>>> Now with your fix (and mine above), no matter PAE is cleared or not, try_to_migrate_one()
>>>>> always returns true. It just flips the code to a different issue. So the proper fix
>>>>> is to let split_huge_pmd_locked() returns whether it inserts migration entries or not
>>>>> and do the same pattern as THP migration code path.
>>>>
>>>> How about aligning with the try_to_unmap_one()? The behavior would be the same before applying the commit 60fbb14396d5:
>>>>
>>>> diff --git a/mm/rmap.c b/mm/rmap.c
>>>> index 7b9879ef442d..0c96f0883013 100644
>>>> --- a/mm/rmap.c
>>>> +++ b/mm/rmap.c
>>>> @@ -2333,9 +2333,9 @@ static bool try_to_migrate_one(struct folio *folio, struct vm_area_struct *vma,
>>>>                         if (flags & TTU_SPLIT_HUGE_PMD) {
>>>>                                 split_huge_pmd_locked(vma, pvmw.address,
>>>>                                                       pvmw.pmd, true);
>>>> -                               ret = false;
>>>> -                               page_vma_mapped_walk_done(&pvmw);
>>>> -                               break;
>>>> +                               flags &= ~TTU_SPLIT_HUGE_PMD;
>>>> +                               page_vma_mapped_walk_restart(&pvmw);
>>>> +                               continue;
>>>>                         }
>>>>  #ifdef CONFIG_ARCH_ENABLE_THP_MIGRATION
>>>>                         pmdval = pmdp_get(pvmw.pmd);
>>>
>>> Yes, it works and definitely needs a comment like "After split_huge_pmd_locked(), restart
>>> the walk to detect PageAnonExclusive handling failure in __split_huge_pmd_locked()".
>>> The change is good for backporting, but an additional patch to fix it properly by adding
>>> a return value to split_huge_pmd_locked() is also necessary.
>>>
>>
>> If my understanding is correct, this approach is good for backporting.
>>
>> And yes, we could further improve it by return a value to indicate whether
>> split_huge_pmd_locked() do split to migration entry.
>>
>> Thanks both for your thoughtful inputs.
>
>Are you going to send two patches in a series, one is the above fix with a comment
>and the other changes split_huge_pmd_locked() to return a value?
>

Hmm... as the above fix is supposed to be cc stable and backported, I think
separate them is the correct process. And for the return value of
split_huge_pmd_locked(), I will take another look at all the call places. Are
you ok with this? 

Well, do you think we need to wait for David's comment? If not, I will prepare
the v2 fix with the above change.

>Best Regards,
>Yan, Zi

-- 
Wei Yang
Help you, Help me

