Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 04A68CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:49:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C92C6B0005; Mon, 15 Jun 2026 07:49:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A1496B008A; Mon, 15 Jun 2026 07:49:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B8166B008C; Mon, 15 Jun 2026 07:49:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F0FDE6B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:49:27 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9CA97C36A2
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:49:27 +0000 (UTC)
X-FDA: 84881976774.20.E2DA78E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf08.hostedemail.com (Postfix) with ESMTP id D9AA8160004
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:49:25 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AEw+KAKo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781524165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqRcBEf3cpBlAxRxD81om6Hb6nO5tAf5Wi1yiOZJ8GE=;
	b=4uhRLvRPLDzd5HCor+EFyynnQnEQMveAoQjX4HNd6B/EbR5MbYHj0psdwumM/2T86nACgG
	RPYhqy1Yp5Ht0uFVaNbdFE61i+E3gjs+FJNOaxNKbKxbQospA7+qaLMKzK1uJs/tgDHaC8
	FtQivIpudDKguSScNUcu9xgm7MEE9HE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AEw+KAKo;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781524165;
	b=57Mah9XqkF2wRUNNQ2yuOgCtzMigKeRITFhfh0VDf0KlcSWg6iOFi81MZUHvW5NUKbAHv7
	3GUKxa4te6TE38nIeEqrIfvJOXcBVptczGbq93F2j42NG1LoOEubcnj1zYKfrFUigWkwh3
	rgM5noNbmsocdOJsqQOkqxh0LtaIJq0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D34E6008A;
	Mon, 15 Jun 2026 11:49:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3D491F000E9;
	Mon, 15 Jun 2026 11:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781524165;
	bh=NqRcBEf3cpBlAxRxD81om6Hb6nO5tAf5Wi1yiOZJ8GE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AEw+KAKoyMIt5WUA0I+U+zx52uQMZaoXINZiiPEWIquiun/uiYDSxVYTwE8oULF/u
	 RhaJMoo6G0XQIXH++yQU6ZUaytHDOXbs07S4afKqRIABqnm7jAoGEVN+OeumGXE5Fs
	 sh59nAMWLtM0dev1x0cbgC9awXS1Uz4xmDd5APFVu1yW5BjCbPPTsALxPGsZGawoTj
	 rfvZsbbclcfK/jrR+gny+hNhEigtUTXuasQPhBYwUk7AS1KPBnqBTLvGiDhTrX0MCE
	 ug5zZCRvRm/U4h/2MmIGoJwbNAQCYe3CI2kEzMZQwWv1shxYJzRLSk1x5jhCLEmNwV
	 AcLD45iSyVhJQ==
Message-ID: <f6e87467-2fa1-4edc-a739-9899be36196c@kernel.org>
Date: Mon, 15 Jun 2026 13:49:18 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] mm: Add ptep_try_set() for lockless empty-slot
 installs
To: Tejun Heo <tj@kernel.org>, Will Deacon <will@kernel.org>
Cc: David Vernet <void@manifault.com>, Andrea Righi <arighi@nvidia.com>,
 Changwoo Min <changwoo@igalia.com>, Alexei Starovoitov <ast@kernel.org>,
 Andrii Nakryiko <andrii@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Martin KaFai Lau <martin.lau@linux.dev>,
 Kumar Kartikeya Dwivedi <memxor@gmail.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Catalin Marinas <catalin.marinas@arm.com>, Thomas Gleixner
 <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>,
 Emil Tsalapatis <emil@etsalapatis.com>, sched-ext@lists.linux.dev,
 bpf@vger.kernel.org, x86@kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260522172219.1423324-1-tj@kernel.org>
 <20260522172219.1423324-2-tj@kernel.org> <ai50IpfcvBiTZ7Ss@willie-the-truck>
 <ai8PO0NThJeuQYzy@slm.duckdns.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <ai8PO0NThJeuQYzy@slm.duckdns.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D9AA8160004
X-Stat-Signature: 5yei3c1rhd4zmk76zj7ta8keo5ey1imo
X-HE-Tag: 1781524165-227672
X-HE-Meta: U2FsdGVkX18A/d0nAcUg0xm25WiwdOt0M9u1/ZekMZpU1ZyioUEvZ3TFwD9lin6ZYdDtBiwd0g7ogSx1FnDaPJtc7wsrsLTxuo1y2VIZLJUUzOHp/HT5RYPMoy93phBHypUfnbyV38MJzMUKbDfhxL6hpWkPSTUbpmrgpcjpL1/CDy0v9F1n2hlfZ9lYm/cskyI+41Q93MhQkNe9SDvg6XQUmb7vU34LyxKlmqIVxlV9a9M1vZ6TfSpN0/JMXigaZy9XuBJPlRxR61Rd5Ip40uLjs+cyTHbtfmFXm2rqkW9IR/6TcAtz0SLQq4oBuCnpTfFxLmsXgm4LtWaTBbErwr9lJXMg+BLIXcrBs7gH23GeZUW6joCtFGe/1F7pKGwC6F26BiLIr4RJLNo7Z1UIT4aDMOKcv6KIvA3bw6j/RxpkCS5CO2dlTgafUnp5QjJWp/sdfKhB60tPlR63aON39QJ1xQyuzzWcUwI0LvI1Mmajm1dKfvWna22UYoaH07cwIxAnJeuccWW3g4j6JFDC9bkMMrnUozflrdrrJAU7gidP3BoBYe24zAb02cIjZTDfzQkPxA2fhPHntuS3J1SpXwiaIzP9t84bqPEieYwCFzhSSvTeoMGKluq+Z5f09YFSjZMIaCeRc405y37R8/23zRVxrEPgUOUMGib3J6irVes/rkAyw8UHoJ83jQXfePXVRJ7FM9LenCwlU4IaYYwvI1lmEVXCjOSj/6eIRIoeH+8gxGglKaJ90euOE11bOLKa75xSuBtJaFvT5K/mEe4hThxWhFdAM+pVLoZ73qGh6ZyxXYQ1Xl/M5yidqRwtoX6Rgpzj+cV/mNx09ieXbHVgvMdGnLZl0X6JOwrDiCP7371mGMsBvaDHrUoKqv40tSOqvwAY82IJnoaX1eFnTI9HoA16xKx3Vke0pxylg2Hstgb+aAtyzUDfDln5c2k4aUuvdcFaXTek2XggJS77B/Q
 eI0OxjB9
 i1Jbnl2unKksfDr2+2dgEOtVQogtytk05YGjdJ5uDOLHjJTF2YX6ojvS7wnHdDAi0S1NmSBSkf4BZGNMx9wYkFbIBL0cZOMvaKV+4JtQlCjCOicIDP+guHaXNUB1tOZJNsQpSflt0o8LAx1iTFbEbUFd2kcBSk32aVudem2u7IhUzKRqRr9SmWc6iPUKfiTR1EQOI3FRS/ASYULu6p4lzprh/EnVEwObLTsIS2OB1uyk4YDTjsqqkj0WobXb/ORXkHEjnHg6yIcu2xB+EFORCuGe2Zxq9zoe9olJXHKJ/gsLk2vDlwze4SFcMpg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/14/26 22:29, Tejun Heo wrote:
> Hello,
> 
> On Sun, Jun 14, 2026 at 10:28:02AM +0100, Will Deacon wrote:
>>> +/*
>>> + * Note: strictly-zero compare is narrower than pte_none(), but the gap is
>>> + * harmless: a fresh kernel PTE has no software bits set.
>>> + */
>>
>> This comment really confused me :/
>>
>> What is a "fresh" kernel PTE and why do you specifically call out "software
>> bits" if the CAS requires all 64 bits to be 0? Why is that narrower than
>> pte_none() given that pte_none() for arm64 is:
>>
>> #define pte_none(pte)           (!pte_val(pte))
> 
> Yeah, that's complete non-sense for arm. The comment is about x86's
> pte_none() excluding DIRTY and ACCESSED due to an erratum when testing none
> and how that doesn't matter here. This shouldn't have been copied to arm.
> I'll send a patch to remove that.

Is BPF maybe picking up patches from other subsystems up too early without
waiting for acks?

-- 
Cheers,

David

