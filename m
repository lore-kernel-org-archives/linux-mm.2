Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 065AC606A319
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 08:28:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=PM53I5cc
Received: by kanga.kvack.org (Postfix)
	id 252776B0664; Wed, 21 Oct 2026 04:28:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 202096B0666; Wed, 21 Oct 2026 04:28:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0CAD86B0667; Wed, 21 Oct 2026 04:28:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E0D026B0664
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 04:28:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E06981604B5
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:28:03 +0000 (UTC)
X-FDA: 85345955646.25.9963A99
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2AF66140003
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 08:28:02 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PM53I5cc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792571282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j31Wa+4Xf0QQi5l0YauHX7WiMP7itq7ljmmvwGJrI04=;
	b=KtdzK3IXVm2j8XcVWJl+7gcccZKt23vI3JOm2zjJsBNmj2akU4E/kL9upatbwPI68usXyy
	JgMOQPtNzQO5bu3opG+nrt2s/eOs/5BtuoeuD8Xowyap30ei4yhtbQbuqDo1G6sv3miknh
	wdAC7jIm5dGfSIbZtq2SWhcDhGr7Vx4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792571282;
	b=JrJx/HTFQJ+Kjl214R3aQUjhFhOqftM0KyF8l5h7oloPKuj7TzaFL2NJfKA79Ar0UuRFII
	jGtcbiBRWnROtg/sOl8GB1GYGvcil0LyA5GdeMJvooW2OJNyZ09g/aU7h6Z3DVAHfAjOUE
	r3AivzMbnxm8EE2SANNavaN9WOdzaAQ=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PM53I5cc;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B4C0F60098;
	Wed, 21 Oct 2026 08:28:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E3051F000CA;
	Wed, 21 Oct 2026 08:27:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792571281;
	bh=j31Wa+4Xf0QQi5l0YauHX7WiMP7itq7ljmmvwGJrI04=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=PM53I5cc33ohdAjMTn0Uf70/koVDQJId9SXhNgrzvyHoQ5uH+/rGSI/nTuEG5RoNz
	 udGMlFW3HYIlwcK2oNmsvavkXhxbnjFC14MirI+Veow+/hPQ4myfQPbLxwVI/zBOqx
	 9iqTuqLrYwWlxGbsB5uRE1Uxfi7UV/+uOZ1EoYkwquIiZvv3HK5mujkfojeCsuF//7
	 mFmD7b1tk6hbEIUt8HSU0Llv0RHdvDXgN+4lvXrFsSBinD87FnMRdxApxuiOH91akE
	 UsfN12Z3nKK4+gCOoYjdMBIC8/3kTmH7KOdEzmTZrAgcXSplXrKCz+XzDpp6uvsP/+
	 lkRxHk+ZribPQ==
Message-ID: <e4c3ce3a-c19b-418a-a92e-40e077f1ea63@kernel.org>
Date: Wed, 21 Oct 2026 10:27:55 +0200
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] mm/compaction: skip folios containing hwpoisoned
 pages
To: Kaitao Cheng <kaitao.cheng@linux.dev>,
 "Huang, Ying" <ying.huang@linux.alibaba.com>,
 Yuanhe Shu <xiangzao@linux.alibaba.com>
Cc: akpm@linux-foundation.org, vbabka@kernel.org, linmiaohe@huawei.com,
 nao.horiguchi@gmail.com, ziy@nvidia.com, wangkefeng.wang@huawei.com,
 tujinjiang@huawei.com, mgorman@techsingularity.net, chengkaitao@kylinos.cn,
 muchun.song@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260928105805.1215770-1-xiangzao@linux.alibaba.com>
 <20260928105805.1215770-2-xiangzao@linux.alibaba.com>
 <99cbd960-439d-4672-aba9-6b49697db8b3@kernel.org>
 <20260929034123.2705745-1-xiangzao@linux.alibaba.com>
 <877bjowf9i.fsf@DESKTOP-5N7EMDA>
 <fbd5ae06-b6da-48f6-9c46-188fb6ba9684@linux.dev>
 <bc1b3255-99f7-49c8-bb52-bada6df80f72@kernel.org>
 <23d3756c-1a87-402d-80b4-c838dfc29f4d@linux.dev>
 <9da90d76-031f-4211-b9de-439cbf7bc63d@kernel.org>
 <49966df8-c092-40de-a05a-ff6d69382dd4@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <49966df8-c092-40de-a05a-ff6d69382dd4@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2AF66140003
X-Stat-Signature: uofpjhe341rzukn51z7wux4c4s51feij
X-Rspam-User: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792571281-980750
X-HE-Meta: U2FsdGVkX18oDVdowwzQ3+iXz3s8tuZFMDUErrJpwfAl8Hmfu2CF1RPXMV4s6UpPMBnPDwX7e/0SYNXJRAAWrxY0Xwa3Rf+AVd5GCo3+MraAOyYkQ2zt8OZLe2hvKywyvRKtAluAtNzztW7OTuKdrzePMhNTZ7q2rpSq3eDUua9mBH97Ik97HvRKfZ3ERrlTumbj8f9zoXhn9wHAi2iLrvBvwHAzmYtHneh+i6FilmkUIpOlRJ3XV1xr1iXcdjHivbCtaBvRVlzu+9apRn44v8SQW8RucgM4KhIiUdTGmXVZnDEQAtQUoZLbJyLvIqXGzcv+d1MavJu2kreZdBOm9EWuwuXntIUrCjpeLyng+opevjZognklKmZhQvCIQrSp2gKZRdeS3S+nzWJMFilqakNj4OQWlq0us6YJSs++Gs7kcgzt5EHOPdFSDJchuRgfUTFa2pwpFBynmUl0OzCx16m/Lub+rIRURud4EXv6pzx8DyUTLwz42vWxqijnGMUWdhUqMoVJkLU9ml4mGaL0DQ9z3zCuwtHtKJ6WpkT4MyXM3TVc4ceuzoKzTWUEdYZDxEfEHj1vy8L7UyC4sk8sIXKUk+5+4FwhTEv8GS6Ty+uwmiDFxNepldnLWlXSQzW7+RN+5A+WYwnlDvGpMCPKAb+QODMcgSj92ErQxk3NdzhGuSfSIprKr1G74k6VskQzS6UkoEpCT22XJlCXDVm3041AHuiHBa4gnG1C9RD3iBk1HCqPXLtJDfi8wknPNVx6yAifj6OHJ00RLpP/yNoZsVeUkErECBbqOLz252p4Tvn+75kvWzbdYTBkFoKkn1JvqiSczLqq1kC1j5nRnB/BWr8VPPGufwmteH8J4iY8ayEHhF46b+sFu8V9b+jp3RkdXLssWaHS0GVcZjPy/Po6WFO6BuBe/A2T8OjZPEFLdMdIeaqF9OV65TZr0tAcw5AcCptYTRzKCRVc7+Q99ks
 66r3bPyC
 g8n0IfAPIoQkXV2k16m5Lf8f6Uhq5dunBK5Pq5eFfPbFpZ7bYzM/lxKhmy5InT/gyNPNVW/4H6KAAP03dHvXXfpEz4TH+Ll44ypJCe+1k5+1b0IY04HEjt9WMZSRqg+RbUL+nElItGYywwgGs1SZGUF/8RhGo1e8ff669EPtiTEsTdFlrG+7dj65UDYzy4/c252Owt+NDrWwpo4uHiPIAR4XwVg4BWMlfx8gz/Tb3eYJbGlYhJmFgO715ujuZFWC2X+1usicYhHob67Q0o85LAv0wdT5PmgcXGopV15vNdPf6IlArVPRBq9HD6z85eMsk60HCo3B/5EGRXvyDHWLhEDz5pLO8RxWwirUj81UOtRL1eZ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/21/26 04:49, Kaitao Cheng wrote:
> 
> 
> 在 2026/10/20 21:58, David Hildenbrand (Arm) 写道:
>> On 10/20/26 15:31, Kaitao Cheng wrote:
>>>
>>>
>>> 在 2026/10/20 21:07, David Hildenbrand (Arm) 写道:
>>>
>>> It does require architecture support, but that doesn't seem practical, haha.
>>
>> Well, but that's required when an arch wants to rule out all races.
>>
>>>
>>>
>>> Do we need to check both before and after the copy? This feels a bit
>>> redundant, and I'm not sure whether such a small race window warrants
>>> an additional check.
>>>
>>
>> I don't see how checking after the copy makes any sense? :)
>>
>> You already crashed if there was a problem, why check? Or what am I missing?
> In cases such as transient errors, software poison injection, repeated
> bit flips in memory, or bit flips in the ECC check bits themselves, a
> page may be faulty while memcpy() still completes normally. If the copied
> data is correct, only the PG_hwpoison flag is lost during migration. But
> if the copied data is corrupted and the kernel or a process subsequently
> treats it as valid, I think the consequences could be more serious than
> an immediate crash. However, I cannot estimate how likely this is to happen.
That's the point, me neither. I'm happy to perform checks before access, or
after, in the default copy implementation, but I want to have properly
documented how this makes sense and which races exist.

-- 
Cheers,

David

