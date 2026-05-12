Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 414B7CD37AC
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 05:17:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 460D96B008A; Tue, 12 May 2026 01:17:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4123F6B008C; Tue, 12 May 2026 01:17:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 327A66B0092; Tue, 12 May 2026 01:17:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 21F256B008A
	for <linux-mm@kvack.org>; Tue, 12 May 2026 01:17:17 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BB51416039D
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:17:16 +0000 (UTC)
X-FDA: 84757609272.04.65DA0A4
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47A2E140012
	for <linux-mm@kvack.org>; Tue, 12 May 2026 05:17:14 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GihDNh/U";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778563035;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ooIMIpbtp1Z/aecZraXYLs0rDJdmEKM2S78Nsyr9CDU=;
	b=QuUXji/xY7wbKpsjz9FD4QSy49cN1Mv663ri2kZ+0WfKYqrE1O+m3rXQy2aQhVkU2sa/2T
	im1x6nOJ8yJKX++U7pO9jp7jwgtCKfEtO7g3+nTX0oEWpq3F8ffADNbC6xQtiMeAsZ85+j
	v81Mi5xeYe81Jdd4Owqrz0HVYDstCH4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778563035; a=rsa-sha256;
	cv=none;
	b=5ORHQNY89dn57UOF6Z16jTb02cv6uaGhSkJ7jxm0MRJzv1lvNSExgaKL0CUpzdwp7SHbkZ
	OEuodQ0wbSJ5EI+N51OBB12HGEwkTnQA/jdn5AOqtm8z0KgCdCRr8lzVjgKW9i5orqcsYK
	QA8DUv6sueVaB7OvnJdtq9x4oBNWnlc=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="GihDNh/U";
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf26.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 4F0991596;
	Mon, 11 May 2026 22:17:07 -0700 (PDT)
Received: from [10.164.148.42] (MacBook-Pro.blr.arm.com [10.164.148.42])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id ACA673F85F;
	Mon, 11 May 2026 22:17:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1778563032; bh=Y4hGigY0F9k70BpiU31xna9CXeOYZ7Z0XhPEYNRXNWY=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=GihDNh/UxpQCpJ+FvS6Wyg4+HgnGHcPwyHpcTelQDiTKPgD+Iq+5OebZZbAOzANAd
	 dR4rW31deuyFdastyRpBh4IStBOJUurje6HR6tSh/qiyOQ+Cs0YaRxrPVKkYzy+Yxc
	 Pv7r7oyT9HxNy8Pq3oHiS3JbijllXMO2jHBnVEtw=
Message-ID: <6b835925-99bd-4d93-b976-7fafe71a5143@arm.com>
Date: Tue, 12 May 2026 10:46:54 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/9] mm/rmap: refactor hugetlb pte clearing in
 try_to_unmap_one
To: Barry Song <baohua@kernel.org>, "David Hildenbrand (Arm)"
 <david@kernel.org>
Cc: akpm@linux-foundation.org, ljs@kernel.org, hughd@google.com,
 chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, liam@infradead.org,
 vbabka@kernel.org, harry@kernel.org, jannh@google.com, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 axelrasmussen@google.com, yuanchu@google.com, weixugc@google.com,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com,
 baolin.wang@linux.alibaba.com, shikemeng@huaweicloud.com, nphamcs@gmail.com,
 bhe@redhat.com, youngjun.park@lge.com, pfalcato@suse.de,
 ryan.roberts@arm.com, anshuman.khandual@arm.com
References: <20260506094504.2588857-1-dev.jain@arm.com>
 <20260506094504.2588857-3-dev.jain@arm.com>
 <5a4c3c3d-66c8-4ef6-bb6a-2ec0e32694a1@kernel.org>
 <CAGsJ_4wJ3pr0+s3+a5fd3vBpqbu0zDOE4RN2Lf1DkUcupHXw0Q@mail.gmail.com>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <CAGsJ_4wJ3pr0+s3+a5fd3vBpqbu0zDOE4RN2Lf1DkUcupHXw0Q@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 47A2E140012
X-Rspamd-Server: rspam04
X-Stat-Signature: qibq73dju5zcz44s1t63ibghczndzc1t
X-HE-Tag: 1778563034-510179
X-HE-Meta: U2FsdGVkX1/eeS5I3B4n1LpgWkh8N2PiHYrNScJRNrNd0Z7/9lZGD5l7KgMj5zk/FrYpdKqFlidYJ4fAYiPPHNjU7XTviBluNpCAlt6ydkE2dlFOuV+rl5jYFShtiJdarTPirZof//kk647JMN+OMX/LrsbeUSgsnJdk8wwWudLxME0PSk1D7NA64W17MMMDuzkFHFn1LVBXRbhhOFBz1stGBf2ENsh3VGI98Ffe7SCy2uVJiSJlWXHHJO9jWphB8GbrEji66CA6caIQSWx5rbYsviKJC2PHdydkg/DXaQFhETmotnv/jQRrjgRpt9lh5/Mgiec+467XcHJrbmL+QRELsMuV+t+udIi2mtmnpIbkPeDgAPGe30VWVNyFUXx4ej88xUh7LdIXj6o0DgEe7lwPKzWMuYWpkwWahn6nG7j61O8iMPlRHzOXwLjFMWrA1/kFJw3vGsa9qNYmUz20IM1OZydloQeIuAAnNm9J7zKRuGRov5pf6bboMw6Py4j+Pp/TMYvXL2oeGzKEAOT2t1Rynt9c6Uq37oBY+vWc2hU2GbHOWxIsDXA9WyJf//INn2g3bUIP9G6/z5GTWIty3zVTykSSngDjrt3vNi2zafOVAKr2V75stPnKLH9RLDLhPGJytZgP8WItXKL7BA5+KZSdibTvm3QA74TdWBD3BZq+Oji6KJRiy1OK9fJ6VBlPPNkcfzIJ8DICIgCVE8iUs1IKMtPW5/c55ynFIiXxo32Rxm88GEGbDUObiQvkUuBPPkDdfU/pI7KNN9fwKN4BLZn4VQekMUMTSYxf3/T1/M81Vr2Vdeu5jOuz+aJ2HN7A7EBHIT1MfvnJyrms0O1m29DFeQ+oo8FhLGypJt0qEwv6iFPqPJO1DY3PmF4G5T/iGAWBU+k5yx5cL2TZ2qEgXT0hssERPFvrctnkvQ0KJvUHNzXf+xedLEbiJJS1Fq0hALMKBbVElQc7fIbHceY
 wzOTUmHI
 qdeWnu8alMn0s2TldJ0UKtHu/WToUmICdFnlKHfiwtBNBGRyp8S2cmAfYQCsqUeEgPgyQDfr1HGa1Uh3+45j6niUMcDHqwBjDNUBBAp0QUu5zVpWITHLpr/tRP46KoA6ewZpEZ2i8rDC4mQWio4jamBDImyD3doo/mpLdeT2XcBw8pdKr3jKSharied3wxk/h95BGe2Rg+mEYR6vcZvr4Rqr2fB/px3df1e8r8utEYC0EwSERkrZqK3OBHDvN9WCzd5b9kbT8nU3Z4o7m7thX+4fufKLR/Z94fGVwhpbkNuomf9DBNHff+n8ZbJyEBrz3ERsD1d3QhK4pmNqraay4ltXO5bvTTq3KJvps
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 12/05/26 3:50 am, Barry Song wrote:
> On Mon, May 11, 2026 at 3:10 PM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> [...]
>>> +     *pteval = huge_ptep_clear_flush(vma, pvmw->address, pvmw->pte);
>>> +     if (pte_dirty(*pteval))
>>> +             folio_mark_dirty(folio);
>>> +
>>> +     *exit_walk = false;
>>> +     return true;
>>
>>
>> Can we instead introduce some enum that tells the caller how to proceed?
>>
>> I assume we have
>>
>> (a) Abort walk (ret = false + page_vma_mapped_walk_done())
>>
>> (b) Walk done (ret = true + page_vma_mapped_walk_done())
>>
>> (c) Continue walk (call page_vma_mapped_walk())
>>
>> enum ttu_walk_result {
>>         TTU_WALK_CONTINUE,
>>         TTU_WALK_ABORT,
>>         TTU_WALK_DONE
>> }
>>
> [...]
>>
>> In the old walk_abort case you wouldn't set ret = false?
>>
>> When returning the enum you could simply do something like
>>
>> switch (ret) {
>> case TTU_WALK_ABORT:
>>         goto walk_abort;
>> case TTU_WALK_DONE:
>>         goto walk_done;
>> default:
>>         break;
>> }
>>
> 
> I believe I suggested the exact same approach in v2[1], but Dev didn’t agree :-)
> 
> [1] https://lore.kernel.org/linux-mm/CAGsJ_4zK1W71iSP14gi=8yWSg80EjgYiBXqLChB2i+X+RSTWcw@mail.gmail.com/

I did mention your suggestion in my reply to David haha :)

I'll see if I can do even more refactoring with the tristate - it doesn't feel nice to
do the tristate at one place and then leave all others as it is.


