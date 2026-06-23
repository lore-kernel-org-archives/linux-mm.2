Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC737CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 11:50:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BEB0D6B009D; Tue, 23 Jun 2026 07:50:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC2C26B009E; Tue, 23 Jun 2026 07:50:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADB616B009F; Tue, 23 Jun 2026 07:50:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7DFBA6B009D
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 07:50:04 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DA3ACC1E05
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:50:03 +0000 (UTC)
X-FDA: 84911008686.17.E5D7B5B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 0182C16000F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:50:01 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/jvcnkx";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782215402;
	b=hQm+cORK0SssNAhaqYjAvD+JCcXhD1Ox7f9aCrqHi6XH7L1v15vb3licZpDoPRPysBXVJo
	gcXWRX3L7vCphAUXMBNJP/Bm/W0pAZi0qkOGNbJMefuaYP1N10g/oWApaDjA+BlsS62eSL
	JIvsJVu/TXl3tqig0wQAV+GNKN9K9Oo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782215402;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n90/FCvkfLh5mKq5gig+7rKJkhz1HQOD5cIteVuMxhY=;
	b=iymsy+jzpZH9j39q782M8CEvto4yDmoUbV10cPjuRtoxD7rMuF5/lX6qAm3ddrAJkwKHoG
	4MrWM6QR8tCvgHX5FZ0DcAQRH4MX2yWdSGwuaE2rCjN7cKg2ERz+x44XW6HiMaan1YYNnJ
	vAaMjbIiRC/oi5qp0bCzP+X9b0Xdhgc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="b/jvcnkx";
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22E5A40325;
	Tue, 23 Jun 2026 11:50:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FEB51F000E9;
	Tue, 23 Jun 2026 11:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782215401;
	bh=n90/FCvkfLh5mKq5gig+7rKJkhz1HQOD5cIteVuMxhY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=b/jvcnkxcsYb8OCiXUklf4q+V6hHfrFnC2A5w8Cmf/D8R6/Y1ZUQq348w6dAC4Koa
	 MAXt3v9fxMPN0+afjplSrUMN7za/UhNPgrcqXAKMdL+6heEUWRsLm0pNKsdTuUxXYi
	 qQp2Br1Oxoh2fNjER1hiGe20qjKx8p0vQZ99vHt7B1MX48l4GkwYOeRN3EwZ/1ZBCk
	 kLno+hQOmhzCZiuvy1vEQNPSZoVDTR7zgNEETk5c0495fyG5EuUvGITr8/UWHzzbcc
	 GjqRoUFZhikwdOT9zUejhpkWFYvCeq8IjUEG3s38ldxaEzRwv58jnXDkbqlNOzD6XB
	 WrZI5OMSeOiWw==
Message-ID: <1ee68304-4e86-4519-93ea-d31ab5ee5bff@kernel.org>
Date: Tue, 23 Jun 2026 13:49:50 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 02/12] mm/rmap: Add try_to_unmap_hugetlb_one
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, ljs@kernel.org,
 chrisl@kernel.org, kasong@tencent.com, hughd@google.com, liam@infradead.org
Cc: riel@surriel.com, vbabka@kernel.org, harry@kernel.org, jannh@google.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, rppt@kernel.org,
 surenb@google.com, mhocko@suse.com, qi.zheng@linux.dev,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, shikemeng@huaweicloud.com,
 nphamcs@gmail.com, bhe@redhat.com, youngjun.park@lge.com,
 baolin.wang@linux.alibaba.com, pfalcato@suse.de, ryan.roberts@arm.com,
 anshuman.khandual@arm.com
References: <20260526063635.61721-1-dev.jain@arm.com>
 <20260526063635.61721-3-dev.jain@arm.com>
 <ee0d499c-de98-4860-bfd0-0bce0b4c1bdc@kernel.org>
 <6a85489f-8b26-4c4b-8333-38f8ae1b680a@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <6a85489f-8b26-4c4b-8333-38f8ae1b680a@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: e1wumo9fmt6p4zrfiqytqpgt78b3zfx1
X-Rspam-User: 
X-Rspamd-Queue-Id: 0182C16000F
X-Rspamd-Server: rspam02
X-HE-Tag: 1782215401-806452
X-HE-Meta: U2FsdGVkX192nn8zPEpcte5scKATQDFU9/K2tIrR7iSHzX/TOY3UrxxcXzAHimvGw+zL6Ctrh0MMtClEYwWUC3/NBX7JJOkEjDJXDHIdWoEWUluvnmjFzQrHsqutI8aj50mXyBVSZufFFblpKoehuLUCvoTVLuiN7XGsLpfNl+Kafbw0mE2WORnt319UiJa8e7O/i/JL0gD8I9ERydlKL/eiKRorLp0u9nn7JwFaiC9P5TQ5IA9t7ASXc6a0kCOHkPiaBrXcHg8ctmadNNDRs1EugNCcfJ+Hybf3u74aOr3nlS8MDkwMIQpoAzK9gj3s0XQylHlJqhxTuSTjT0tM1NEZ3wOWweFwFb6m+8faSsYri0pnur3aOgfsenbl1R4rJWgKndTGMCQkJSVFoHXSURbTPm8ijjfTn7u/3JlixPMpA3syIi538jyfgomk5UJ8EUQ7sCrgLIEAcXY42XRYyGhYk2WGpMy2f96tmpszbqkPmqb//vm5weL+pMW/2bGDK3e/vxarLZ5aDVg0gdspbh08OYs5OkBdzGn4+RRBB/2agyxdCnA+CxUVypvY3hGyQ2a7vxoTr5tevIczY2z6kffG7mMRlwZLEa48EFBg0Xm0QFGp/zRw0yFmj2h/L1/908soyZ6EiMGCiE/B5d97PTkPwQytFXPzQszb6KdwrrPt3ZkWjIefxpJmJavXBxTB3Fpx6T/dPIXbaHFBJjWrjnNcbVempMf3wlimV2exW0iTo+phCDqz+eMwc6NkxXtuDBOuN/nxcQmnws7Qu6spVq9p1aU4f5iDT3irfRNGk/IGZw5yF5HgjqF/tLgPI9Awv1WBZ5SBnr8dBrMa3KfUKYHOzMgESPZ4hYZ77+/YnytUJcbaMr8iKSzT5quFnPWXVwNiS8UItiUdDUpPfrrEsb1pumOECRfXtSvC3fvMsZUDpxCjs7yb00dpxKWDmqSJ2bJ+XotHHngWNsn5eFK
 rHcD26WJ
 Qpj4F8vaJDjNPtdHL2/mDgluaNWWLirytDOfgg3enctBvKIcrx+cgJoaMqIWm88NzLzVdt2uGvuvLAaRtyDtRSkFLeJ2EcMWtm+yn2702FWlTzQDq2DYfYss5uJDsRgwa45650k+WgIuvj6QHYQ8HU/MnWnja+H3kJgapw2t1uH2ulJatQkR8TFN12IzsQ4RV4LdQi7Nsa4cwgZhvGhXNmPykfgdX4WMgEYo+9pesIWKa1ZgLTvt16Ri0qbSmBpaK/EyTPc0VZQFig05SrO/tOvwY1vN8D330v1zfpbYJ7ihHllHOuXrXt/6Vsw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/23/26 10:40, Dev Jain wrote:
> 
> 
> On 09/06/26 7:46 pm, David Hildenbrand (Arm) wrote:
>> On 5/26/26 08:36, Dev Jain wrote:
>>> Simplify try_to_unmap_one by separating out the hugetlb parts into
>>> try_to_unmap_hugetlb_one.
>>>
>>> To understand the correctness of the refactoring, the following points
>>> are noted:
>>>
>>> 1. try_to_unmap() is called for hugetlb folios only when they are
>>>    hwpoisoned.
>>
>> Ack
>>
>>>
>>> 2. A hugetlb VMA cannot be mlocked.
>>
>> Ack
>>
>>>
>>> 3. The pvmw API sets pvmw.pte to the base of the hugetlb folio (pvmw.pmd
>>>    is NULL).
>>
>> Ack
>>
>>>
>>> 4. We won't ever process a softleaf entry that encodes a hugetlb folio;
>>>    hugetlb folios are never swapped out, migration entries will be skipped
>>>    (PVMW_MIGRATION not passed) and device-exclusive does not work for
>>>    hugetlb.
>>
>> Ack, we should always find present entries.
>>
>>>
>>> 5. uffd-wp bit is lost when converting pvmw.pte to hwpoison softleaf
>>>    (therefore no need to call pte_install_uffd_wp_if_needed after
>>>    clearing pvmw.pte)
>>
>> Are you sure? And if so, can you elaborate why + document?
> 
> If you see the current code, we construct pteval from the subpage, losing any
> bit state of the previous entry. Also it doesn't make sense anyways to keep
> uffd-wp for an hwpoisoned entry.

Ah, yes, makes sense. For some reason I confused hugetlb with hwpoison here ...
so yeah, this is good.

-- 
Cheers,

David

