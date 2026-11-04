Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 176C6606A33A
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 11:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ASgKkr5c
Received: by kanga.kvack.org (Postfix)
	id 3920A6B05B9; Wed,  4 Nov 2026 06:07:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3429C6B05BA; Wed,  4 Nov 2026 06:07:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 259AE6B05BB; Wed,  4 Nov 2026 06:07:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0B5906B05B9
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 06:07:11 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9AFE51606C1
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:07:10 +0000 (UTC)
X-FDA: 85397159820.07.4E3F55C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id F0BDA40005
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 11:07:08 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASgKkr5c;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793790429;
	b=iYogo60eh/TX95NVmU+tAvFRwcpbTVm5QK9F1+D02YMKWiAZ98ekDKRw06Ae92TbT+Ixt1
	ckl12wrlMKLnFdVzdteWBS5pJ2TN/5T6q6lHOdzvsCaLW0nrfBOsZtDmpyehBY8bBwbjJ+
	eGdWuRo4wuGzc3lF1QBP1s5j8FjSF/M=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ASgKkr5c;
	spf=pass (imf11.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793790429;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4d6wA3vxHnyiaccvvRFg3MmHydefrlcpFn4MY6KT/xk=;
	b=QscAxc+A9FI5xsWmcoQ2ko3YNHC3ORYtsm2Yr7Ek8TjXqJp6oRY/QLttnA4H0ULlYeAzSP
	QP0gqRNvLpeYsuhelqWxZczSjMSyPCGzECC1LAHKaCOLyP8Ozxz2l+9o0UVEtkgBfALZXz
	Y4J7wSSWJtASgRmy6riQn+syMfKd0mM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4968A43643;
	Wed,  4 Nov 2026 11:07:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5771F000C1;
	Wed,  4 Nov 2026 11:07:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793790428;
	bh=4d6wA3vxHnyiaccvvRFg3MmHydefrlcpFn4MY6KT/xk=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=ASgKkr5c8Jwki2bMhb0nB2JvgvmPhtdOfN9BJmvuUhPe42D0TyWNERtR/objACkFN
	 ro/rRW242zVNXpW0JVlBrjTNAeaeg9x6dvmSjhWuwROLvKEBWvQafeA9NXjrgOhNvu
	 l76TbHCLv/JbElvbSlQBjsVQghaRM2pUWAmdeWfZjsZzkCpuFkjTJAspPW8JTcZYk/
	 rq6Ubrt/RyezyV+tTAzdJcmRiYXRPP2dU4W5lx2pUmew/iyltwIAsjSN0SzUrmGgvr
	 hRKbEGwTHLHwneEwKakp7cOxCK9FV021KGwvbtrH+4x/YkncsK5Cm7aqlewcn/1nFZ
	 yPAts5ELjsSuA==
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 04/12] mm: hugetlb_vmemmap: generalize vmemmap page
 allocation
From: Mike Rapoport <rppt@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Oscar Salvador <osalvador@suse.de>, 
 Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport <rppt@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Lance Yang <lance.yang@linux.dev>, 
 James Houghton <jthoughton@google.com>, 
 David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20261104023510.260766-5-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
 <20261104023510.260766-5-songmuchun@bytedance.com>
Date: Wed, 04 Nov 2026 13:06:58 +0200
Message-Id: <179379041864.1868318.5211459990803925675.b4-review@b4>
X-Mailer: b4 0.16.1-dev
X-Stat-Signature: jzgazk84w86n9hs3bi1pe3giuc8a6q73
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: F0BDA40005
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793790428-835651
X-HE-Meta: U2FsdGVkX18HX3O+CHVEoFPTJjJbFHyMbEGtNRAZ6TsXt57IwhKSsVeHi/3M3DvGJd9D9lMBglRIMjJY67Twq+6SUmxsxj63HKWoNYCMliOj489BzRfZcoUnYV60EqY+IL+UacGjdr9lmvDV0M71hkJ3WMeGp2d02bRCrfsZRNSazSTfB2blH+dYiQH/PqVf/7D2Y3impbmllLiHAWa8o8y+DW/FfcHnxGS5vFErvhZnRatekMEFLn5LxAzNgfQxILaFZIuXWWEyk7izLSFKHc4+Pwzy+aGWeNe3PFssNYo8Z4s31DiW77Le7leTZjpNsgKJ+mi+OzMrvCyxCCMPZAQauMDIf11znbN1RPmJDZ7TfKL/qyqiYvcHmMHE0HlyUWqRfwV0L2KGR4c6GIcYysCNa/EiwbZpkpu/n9YBknERInmD7llpSHhGPvdQ4iFhmybxqWOay+P4p4PexSEvHu+15HKgyVsL8mYL+4qeeGjTfNC09Q/b52K34sAzonVqb2a4v1xfFbQJ5ER7koG62XfvLhGmmv6OMYsWBm157Z/r5nMLrSZQj5PPi4CJO+iBaVW2k9doI5LD5iKg9+KxJhmEAR5K8gHX5ZUIzoqid/0n6X/yf5D+gVwcX3EaBzwbt+RYo1Fas85Anlp1SCeESZraGp5wJXNgyXfYJUmgTEMqDBulAVBYYEgwK8S8wGgzdSz5G/ayQ5hx5aUK+5OwWGtMa2JksV2kJ2cdKYv6fTXtijd7Tcr+417ZQD78lMvJx99TQoven/iuoZk/vznni2bzOTBP6Thk0mHRC58KPwqFQfrpFL/LzVATgWYCZuT87DLGBPr7FSU9W2sg2NFBYs3Rr/QY8QgkIlRryQ9zuyUWdLnkJAcAV34OOMUB3v/+zHDBETyH7dgfaPzq2dEpR+sXNOb2Q9m/j1KORkHPeLKdt4QZu8W+mFR9RacpOLXAUcn2rtOnIOKymL1tgJ3
 o7H85vZC
 fwtgk7wxGvNrHvwQ1pNiTZPZ/uS56UXXaxT+yvF8w0ogLP3Ww9QdFdCIT+Ja8Y6C5TH5SbkG6AX/4vGqdKm8KsFu+Giq1lluL58ErcCXyIb6Y+r0kOhYkbGWNIMc8+jTsxZe3bwy6+GRLw6uxHjTDZ+/uThbVsKOdMq//FZlxVsvV9YQAK10JyVK1R3OiURha+d98UB0hKt1ba7cDWyhpeTtBhhz0bVnDIzsK4xkcXbJVbre8BktGRO54Yqacpedr6+AE1tDiccO0r2M02hqZRPwZK4UWjCQDP2yduY/g8LG9Ym2G6DunJFQaMrkpm+hcLtqxHmKkqPnVrXBepjLanoFNlg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, 04 Nov 2026 10:35:02 +0800, Muchun Song <songmuchun@bytedance.com> wrote:
> Vmemmap page allocation is currently tied to restoring a virtual range
> and assumes an empty destination list.  These constraints prevent it from
> being reused when pages are requested independently of a vmemmap range or
> appended to an existing list.
> 
> Generalize the allocator and give it an all-or-nothing list contract so
> the restore and optimization paths can share the same allocation policy.
> This also allows HVO head-page allocation to fail gracefully under memory
> pressure without triggering the OOM killer.
> 
> [...]

Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>

-- 
Sincerely yours,
Mike.


