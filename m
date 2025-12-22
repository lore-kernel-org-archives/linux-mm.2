Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC42DE6748D
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 10:28:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5830C6B0088; Mon, 22 Dec 2025 05:28:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5316E6B0089; Mon, 22 Dec 2025 05:28:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 43C5F6B008A; Mon, 22 Dec 2025 05:28:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 30A8F6B0088
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 05:28:54 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id DDEEE1A0A7A
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:28:53 +0000 (UTC)
X-FDA: 84246733746.24.1E930ED
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 18D6A1A0015
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 10:28:51 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mzi5UKY+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766399332; a=rsa-sha256;
	cv=none;
	b=HNQoNfqpTEX1byTxzdD1NUr25DuLLxhoodP+bKCu186cxxmTu7K7cd0vZP03RIJ22qFcTz
	yM0cOe48QAfW5H/ga1gLNUNQzSXtWXeIz69HYXmh+RrFgODDOmJQo5iIB2Br+SIgZp5DB6
	n7dnMijKTc0jY8Qxz8aYTmidmncFtY8=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mzi5UKY+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766399332;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMa4TpGP7tPnCT3xmqQAoDtMNFmQhiNkcFkEgqznJC8=;
	b=IpVvndBDVeqFWDXIZFts6znQza7sLiAE6v0M89H7X3EHzfWXE4z7b5URqN63RykJBGZ0gw
	iMWxpnR6hLcZ1atsmKb4V6v18vp3gc8+x7bAcHMBOVS1Seu6j0PzNj/KU06eQBmrcErhfr
	uc1aXJn9xKykACsCIif7ZraLY84U3g8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 307FD40180;
	Mon, 22 Dec 2025 10:28:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAFE9C4CEF1;
	Mon, 22 Dec 2025 10:28:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766399331;
	bh=gpI81CYAZDI5HhhxXAwfSCUYaYR7sSbyLFN423qq0Z8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mzi5UKY+SCvVFYHfm5csTU5OI5er+dNklX9M5m/zec7X5fgX33WqOMbRBtk83enAa
	 OvCxPPfAahY/yFpkkTd4hZ530UhdVQLFACAX1EHZBBAxzMcBLg3RdOTdKs8s0OGnoa
	 laMPM1Rh+W/W8wsGe4ej6Ds3yrnXVkVDiZTlkHGUJvPTdBlxF2qE0V2hDFEEeXLyWZ
	 hBDQGVdCa4J8o3OUq9ldWfnMXOi3+kNjaTgBbDq3Q0mjCHIm6QPqAlD2604+OaiqMJ
	 2AZ4wdtOrh99mmswzzFltUtta6Xn7nX84Aodf9HucX2Yc7T6xHrHjnlug9uPBbpQTE
	 0HhhJWryqziRg==
Message-ID: <051628be-ed70-4a56-8704-f2b8cdea1984@kernel.org>
Date: Mon, 22 Dec 2025 11:28:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
To: Sourabh Jain <sourabhjain@linux.ibm.com>,
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Borislav Petkov <bp@alien8.de>,
 Christophe Leroy <christophe.leroy@csgroup.eu>,
 Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
 Madhavan Srinivasan <maddy@linux.ibm.com>,
 Michael Ellerman <mpe@ellerman.id.au>, Muchun Song <muchun.song@linux.dev>,
 Oscar Salvador <osalvador@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
 Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
 linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org, x86@kernel.org,
 linux-riscv@lists.infradead.org, linux-kernel@vger.kernel.org
References: <20251221053611.441251-1-sourabhjain@linux.ibm.com>
 <87a4zcml36.ritesh.list@gmail.com>
 <655cc605-2ce1-4ccb-8cc0-a0a31a9c89fd@kernel.org>
 <87fr93ky5i.ritesh.list@gmail.com>
 <16fef7a5-6853-4a6f-8d27-e005fa351eb7@linux.ibm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <16fef7a5-6853-4a6f-8d27-e005fa351eb7@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 18D6A1A0015
X-Stat-Signature: g8xa6thxfnfaebh49df1kg9boqfozef7
X-HE-Tag: 1766399331-867763
X-HE-Meta: U2FsdGVkX1/HO9T80IXRtzszRmE7cKlcTWt8ZaNfCKfleKKkO8c3HBdvp/sZtob4jirXdvW6lvpK3ARyYYIEFMkD2sQ0XavU1e4gr/XGKECypJxDyx1EtWkut2p0uMasNYrDeXZMR8PyKr5qdm+rKVQBi3DDxeVJ1P2JYFaFcZUbE4lOaGs4TNPnD95SHalfHeeS1Eqtm/qduMTYKzsE37lj3BrMqvvRXyptGqWZV+k5oMyM+TEckE2lzg9rVQmq1ZOgrV4ZGnkDVpwNVWQ+Eub3xmDTfDhAnMBUsnEevfilLEXiF6hUaBm6a7fDODlIedergWJynbbaiYoilAmxlGpSxAbVHypJklbfqg8tn+odyEc6ircrXHoJ2awIt2qEUf5i2Qup5N/cokDJaqDnBYOBwEJATTrdXifg2FYuiUTxduVjzrv85XjJyW4YBOmyk57wGrYp4D6UE/fEI25pJOgW2zohjB/Atgwm3aEiyidQ8foO6Chr+7fL1FAq2h/Emt0mPf75yThSQYGENH8PLxa9fIbwMTl5Xf0CdAe8FqMAk198XMzAQI6NNTWAO/BakSCF/D18lZ5XyMf6fbbB367f1Se4P/kA1GV4zJxYnlkf1STT0Mf5R2NTPqqTJcKRv4ShqgQ2o1hKNXuQehRjjxqntwGNpBZokrfMeckn5+7bsv/cfv0Nk37MVDihYA+wFiE+BF9ie/N1R4wrxyzTFnd/Cq6eDsfrktQXdXATUW8Akhd8MbRTuouPkkbbnbbPW3rtky5FiTbG93m/o25xZpjCZtc7ef1lsZyV2iiv8upfhapgKBQo5Q0p+Yv3/fM9iiXbHn5Z3jEyQF8sO1LvMVz4LYxdqWWCt4xopaOqaR4dfP4qBM3JQUKjzLznu/tQ9zTWxeONed0cI6SV0VbjwX3Mc3zuYZMUFxTIjFLRw0Zq/Fx3bRegPWREtcBZcZZ11qpSElV1x8/NlpDZyZb
 0TxiFaq6
 dLNRs7KDyKwutTJZLVXJYgDF9/4vd2ZBSxkagvSmgxro+Hsvi8YH3nqloVXNsbCDTgvtYud6OOW+hFOLBMvhpO0ZpGnIvKvAagasP9PJT/bnWlgrPzZRM4UUULrnr1ISLNkUXIHC/VQtB5VBnQ5e50WywK+iDqQwuHXZQh4/uvvE0cqGggdgzG2gHBgr5BgOFQFThHRgjPZcV0MICYEoSLrx5/mCBlJhXYThxRvAnjnx26iNC4j8mkCGkcmnvdFzaxH84ansnvMoI2lvrUa3TKG2Iw2OrQvagDpUg10BhW9czxndeGXQLI+KAh4XGdN4h1ejE9vsre3JR/CBZ0oVV9twOdOUSEMBmKN8+1YFQaXkv06+CEQbLXSY+sbeTNxcOxeHpqpkRzLH2r806DlVW4ShivA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/22/25 06:57, Sourabh Jain wrote:
> 
> 
> On 22/12/25 08:42, Ritesh Harjani (IBM) wrote:
>> "David Hildenbrand (Red Hat)" <david@kernel.org> writes:
>>
>>>> Coming back to the fixes tag. I did mention a bit of a history [2] of
>>>> whatever I could find while reviewing this patch. I am not sure whether
>>>> you have looked into the links shared in that email or not. Here [2]:
>>>>
>>>> [2]: https://lore.kernel.org/linuxppc-dev/875xa3ksz9.ritesh.list@gmail.com/
>>>>
>>>> Where I am coming from is.. The current patch is acutally a partial
>>>> revert of the patch mentioned in the fixes tag. That means if this patch
>>>> gets applied to the older stable kernels, it would end up bringing the
>>>> same problem back, which the "Fixes" tagged patch is fixing in the 1st
>>>> place, isnt' it? See this discussion [3]...
>>>>
>>>> [3]: https://lore.kernel.org/all/b1f04f9f-fa46-c2a0-7693-4a0679d2a1ee@oracle.com/T/#m0eee87b458d93559426b8b0e78dc6ebcd26ad3ae
>>>>
>>>> ... So, IMO - the right fixes tag, if we have to add, it should be the
>>>> patch which moved the hpage_shift initialization to happen early i.e. in
>>>> mmu_early_init_devtree. That would be this patch [4]:
>>>>
>>>> [4]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=2354ad252b66695be02f4acd18e37bf6264f0464
>>>>
>>>> Now, it's not really that the patch [4] had any issue as such. But it
>>>> seems like, that the current fix can only be applied after patch [4] is
>>>> taken.
>>>>
>>>> Do we agree?
>>> I think we should document all that in the cover letter, an describe
>>> that this partial revert is only possible after [4],
>> Yes, I agree. Let's add the above details in the commit msg.
>>
>>> and that that must
>>> be considered when attempting any kind of stable backports.
>> Sure. I would prefer if we change the Fixes tag to the one which I
>> pointed in above [4] (with explaination in the commit msg). However I am
>> still ok if we would like to retain the existing fixes tag and show [4]
>> as a dependency.
> 
> I think we should keep the current Fixes tag with an explanation for
> dependency
> on [1] in the commit message.
> 
> Would anyone have a different view?

Whatever introduced the issue should be called out in the Fixes tag; if 
there are dependencies for the fix through other patches that were 
already merged, that can be documented in the patch description 
(relevant for stable or distro backports only).

-- 
Cheers

David

