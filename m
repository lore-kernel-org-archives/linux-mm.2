Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC98BD2E022
	for <linux-mm@archiver.kernel.org>; Fri,  5 Dec 2025 07:41:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C456D6B0135; Fri,  5 Dec 2025 02:41:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C496B0136; Fri,  5 Dec 2025 02:41:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B59126B0137; Fri,  5 Dec 2025 02:41:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id A847D6B0135
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 02:41:17 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 526F2C04EB
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:41:17 +0000 (UTC)
X-FDA: 84184621794.24.4FDEC42
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id AFE121C000D
	for <linux-mm@kvack.org>; Fri,  5 Dec 2025 07:41:15 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NV3YL29e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764920475; a=rsa-sha256;
	cv=none;
	b=iYdb+wAn7gOUwkkOzntT12OpjU0pLJrIs1fhMmx3zPezt8Na3S0DkVx3u6ZHUNVviBeH30
	amWne+7qtfGm5ypySTPGbUCvFsBIpsvTL6rxlfHG45LUdZns9F+uX4A/lfwyITsY5OYskY
	dT5gqq71JJyPLvMGGdQjmWJqS/TPJw0=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=NV3YL29e;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of chleroy@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chleroy@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764920475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1RnddoaNuyVKAO0UJEB8nPFQJfYmgRWcKSaHJbTft4s=;
	b=FuMGQ8LnmT/Tie5TIi+lFc6WEjKhQR/JMER3ZnofqyoPhDV24up6ZniF4iDIDS3e7+ZWEi
	7XiUDJMWq0c0GaMCmnMU+3ctVcshvE7LqCHszSgkCAh24L1/uV65SitfqxdHFscCeM3YIt
	5INjMpz/OcbdHuKXhH3Tlx+vO+F9oIE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BFDCE43661;
	Fri,  5 Dec 2025 07:41:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F3D0C113D0;
	Fri,  5 Dec 2025 07:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764920474;
	bh=JNIyYc/7yP1M4TvP6ofkJrx/viH5F1sL/Inc63ohX0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=NV3YL29eliNneTWlA8ePGTMtSS/n+uTN5J5jvZlhhbhGID3WpRpsny7Z93D360p8z
	 CcD2Jpu0zNvCPb9wT5veXmNC3bd1s1KSysRMJEunjTUGnYrmaFBFaE2UG4qBOFZHYt
	 IentCY9LrG+gTxkx+aGEz8vL6BwXVoyc6pTklOkA98XKMXmy2ONe2ESzjdrXoEwSW7
	 9p7mC8TL2SZ6Ob8vUY5B6UT0OIdXu0pG1+/F/uYupAeHJaiyZGsxI7HtgMMT7YGq6E
	 cP1MUhOOe5SLYbudGokd7AeJKtjSzSj50EYV7+Vd3YPBiPkwLBJ0uqcWjvirqmQi0z
	 6Xs4n124j53Tg==
Message-ID: <057ff845-6ab3-46a2-82df-067c25bef56e@kernel.org>
Date: Fri, 5 Dec 2025 08:41:07 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Revert "mm: fix MAX_FOLIO_ORDER on powerpc configs with
 hugetlb"
To: "David Hildenbrand (Red Hat)" <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Andrew Morton <akpm@linux-foundation.org>
Cc: Shuah Khan <skhan@linuxfoundation.org>, maddy@linux.ibm.com,
 mpe@ellerman.id.au, npiggin@gmail.com, lorenzo.stoakes@oracle.com,
 Liam.Howlett@oracle.com, vbabka@suse.cz, surenb@google.com, mhocko@suse.com,
 masahiroy@kernel.org, linuxppc-dev@lists.ozlabs.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20251204023358.54107-1-skhan@linuxfoundation.org>
 <20251204135746.6d291cc861b4507b1fe95aaa@linux-foundation.org>
 <aTKDRF2sMdM_5aRB@kernel.org>
 <dc22e2e2-a62b-4b9f-9fb0-f3a42a57b00f@kernel.org>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <dc22e2e2-a62b-4b9f-9fb0-f3a42a57b00f@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: AFE121C000D
X-Stat-Signature: 6g8w51siy3rw77a9qqauxb1owqzs1toq
X-Rspam-User: 
X-HE-Tag: 1764920475-422942
X-HE-Meta: U2FsdGVkX18JlozNXElmeC8n8ni8qX2Nx5DPMsZlH4xZXtdGj8EFUZyzUVyqYsgzzFomacyd5Kh5aSDa45KEZUKCx5T0q+xoJi9aPqDMva2bnloKEyCKqzkbW2I8OrVvO39DJaB3PMM0xVUt1Fu0PuTBLLY5NcHAzPhljxEB9DHcOuA1Zy8ur4Yr32ka2acK3zJcbMY0LK+UlUvp620lo4knBgzAE2B03TsW0ShBO9qi+fpPRTOw1Vz3ESCZHAFM/ubA90v/xLGZiJqAogEVCrXA/J/sqkdJ+XgCS0KJE31m9olm7YjYJ2dJYomRdZ5+A/wtm6NoG6ouvlEWCly5r1jFh3E0zvQyGyJ9F0nV1iV+ACChYrEEEHWAw/ZlLdpntcU8QEpjxuT3YJcSswCjMHSFFSsYJF/nbZCN4B2AvTNtxI8QTzlwrHSQAkkvCMJ6wYSEaZgPvFYDwx0FaUUzrAfBqLnr22iE+Ii1d29Aah/NpKvHqwoYN2LGYPtvGhj8V2S0VGHO1f5yutrE0TDl5wnvF++pqK5PkUMKlRkS7ewT7QenXlhehHDBI5B9LwcB67k1r9Bws+22ZD2fXi5X8HKXdmYsUFqaM8KVC9ETFkDAug7BgLbmN5cLF2aE/Jdb5K/Bq5kR7a8eM7ruqTdzTkCzefGKvWkTD4zyU+/H0hL3yYWTkNbJZqlfgKfdkkI3598/Gei9XvEmBQ+BWQ7E3GwE94gAW3hA0MqyNOj3keHN+i6aMX7K2LpblmsNr52iqgMnZTtz+fhXhMNMOW4mSnO0+cQlJ/U+Nl76V0RjdFpNmvrCgrTWDQCoVJ0DdCWt0qa/3/1W6r8ni5bqhNKHh1qIGUOOV9kpxxsA8H7ifBsjU2UG1J3MtSeuC0ZuPyBaSgfHMBPDTdsnvoupdAU62vba3A4F2MNf31qbiBOrgqlfWkLB3dGpGXqKJfmokCkDpTo7t9kWcLxC9BdT9r9
 z1TeEzFs
 obSl0lo3KfWDNZRE=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


Le 05/12/2025 à 08:05, David Hildenbrand (Red Hat) a écrit :
>>> 39231e8d6ba7 simply shuffles ifdefs and Kconfig items, so I assume it
>>> exposed a pre-existing bug.
>>>
>>> Reverting 39231e8d6ba7 will re-hide that bug.
>>
>> Shuah confirmed that the bugs were on v6.18-rc6 and they were fixed in
>> 6.18 [1].
>>
>> I verified that reverting 39231e8d6ba7 from v6.18-rc6 does not solve
>> anything, but applying 5bebe8de19264 does [2].
>>
> 
> Thanks!
> 
>> So reverting 39231e8d6ba7 does not change anything and there is no bug it
>> hides. The bug was introduced by adfb6609c680 ("mm/huge_memory: 
>> initialise
>> the tags of the huge zero folio"), was fixed by 5bebe8de1926
>> ("mm/huge_memory: Fix initialization of huge zero folio") ...
>>
>>> And that isn't a bad thing.  If we re-hide the bug in 6.18.x and in
>>> mainline then that relieves the people who are hitting this and it
>>> takes the pressure off David, Mike and yourself to get the underlying
>>> bug fixed in a hurry.
>>>
>>> So I think I'll queue this as a hotfix, plan to send it Linuswards in a
>>> couple of days.
>>>
>>> Or Linus may choose to apply it directly or to do a local revert of
>>> 39231e8d6ba7.  But I don't see how a local revert will get communicated
>>> to the 6.18.x maintainers.
>>>
>>> David, Linus, opinions please?
>>>
>>>> Signed-off-by: Shuah Khan <skhan@linuxfoundation.org>
>>>
>>> Let's have a cc:stable here, just to be sure.
>>
>> ... and we can skip all this hassle.
> 
> Yes.
> 
> Thinking about reverting arbitrary commits after Shuah clearly tested 
> something wrong is completely unreasonable.
> 

That irrelevant revert has already been applied on mm-hotfixes-unstable, 
see https://lore.kernel.org/all/20251204215938.750D3C4CEFB@smtp.kernel.org/

Andrew, could you please drop it ?

Thanks
Christophe


