Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90DDBE6F085
	for <linux-mm@archiver.kernel.org>; Tue, 23 Dec 2025 17:11:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBECB6B0005; Tue, 23 Dec 2025 12:11:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6C2B6B0089; Tue, 23 Dec 2025 12:11:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C77D06B008A; Tue, 23 Dec 2025 12:11:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B4F7C6B0005
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 12:11:55 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 4F0A91A03E1
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:11:55 +0000 (UTC)
X-FDA: 84251378190.04.BF3CB02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id BEDD340010
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 17:11:53 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fa+0Ubgf;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766509913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NlmwdZqhPExcGZgM/pVZiC2lUJhmTkXwAn+qNuohbBI=;
	b=uUYaCoHpdhu8OfTUvOEFQ3HYwC8eFehaQ2E7M8MuqBfTnBbuQ1N/vdWJQ0sQF3U6/kIzhF
	+GBdPEWmj9FonCZXScs5uxHn1Du2dVyykbh2b/K3Jq6b19XX3Q7wvVw/aP96PAnWr9Xlzz
	Qrma4pINaLnEmk1pl0Jd1WluETnm7YU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fa+0Ubgf;
	spf=pass (imf04.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766509913; a=rsa-sha256;
	cv=none;
	b=22AJOokA5iw6aVUAGNBjCA6hAxgWqt1tmjrYCNfVq1zzClAQM9AdrYN1P1K04keWQKBl8I
	yFoOBYuJGpU1h8J0OesU5NylBKLtmGAYOre7/aARgST5SZubyG2xInffrDRnHBpQM7KA2B
	+fCRYPPso89a1u/PDt4L6O23Mm1MIjU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B5E6C41E5B;
	Tue, 23 Dec 2025 17:11:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59005C113D0;
	Tue, 23 Dec 2025 17:11:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766509912;
	bh=3um8NkjnKfQWblw0ttBXC1gQUUqnZlPZFVjmKn1p7PE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=fa+0UbgfGH0MW7oBnwI79BEfDFeL2kz26p3mGx0sCirQiG+ODvVSzIvze2Y4eZ39e
	 WIzrCovlU7u1ZaXeiidmAy+OfcAiEQyWBxBq8TEgBFblUeLzUl71pnP8IwQYxRxZtl
	 JU7DoafiH8mxnn2LoNc4c4dJAdE2oBfmG5UhDjQJJJ432y4bbFEKAVbwNtMFpz/VKJ
	 6AlMqdnjsTFz7IjJg58q5KShlRT8jwNW+ZHfTHRSECk5n7n3KNXCVAxif2wK9xXXXT
	 E+/IjLB2oCGTQ1JX1lHXV5bbVjgxm5fyavrfeDQFfoQJYkrnbzjVcvXusb6YT55ENG
	 LaGk5PAMnNqlg==
Date: Tue, 23 Dec 2025 12:11:51 -0500
From: Sasha Levin <sashal@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Red Hat)" <david@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Borislav Petkov <bp@alien8.de>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Heiko Carstens <hca@linux.ibm.com>, Ingo Molnar <mingo@redhat.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vasily Gorbik <gor@linux.ibm.com>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-s390@vger.kernel.org,
	x86@kernel.org, linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6] mm/hugetlb: ignore hugepage kernel args if hugepages
 are unsupported
Message-ID: <aUrNVyuSaQrQLGZP@laps>
References: <20251221104907.032abf56c67f3e50c9c94e31@linux-foundation.org>
 <20251223013045.4579-1-sj@kernel.org>
 <20251222183055.88c3cc1f0705c1dc29c7f011@linux-foundation.org>
 <aUqAcf2405H0pRW1@laps>
 <20251223085434.a6d6ae08c3aedf420908f404@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20251223085434.a6d6ae08c3aedf420908f404@linux-foundation.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: BEDD340010
X-Stat-Signature: ipj197ibpwgcao1sajbexik3epxqmogx
X-Rspam-User: 
X-HE-Tag: 1766509913-763745
X-HE-Meta: U2FsdGVkX18D7remn1kK75yvq2DfVlArg3dJXfU+lU+Mg2slgW5Q7hobeSR6Ywx2IzEkqLTDCwEi+QztbtkxnAGADIMlYZFQEmwYfxA391BvfREf/RBKg64u1z4cXXWx4cry0ibCq9qCOL2sXwghZmXaD8cv+j2jJG9Woq4LYv9lixKtJsIYAvIOjJULvfoZaVpRPCTgLtQtgs0ztqBWAm8ysgMOMPrObh8C7e5W0SsmLJYDgnfpF8ZbS9UAZ67FdoU4QL19d5I4DbZRGNSHyDqFv8NsaniyzNWC+h/uqTVbsDBjrIgYtyRz9Wo0oVXPt0aN1m6+6e31sX2pv2PUvmwWoY3oNO0C9zjybmLMXLRKtPFKBBYc6TA2r4q2YyDqr4bVq/60x+jogQfcBUsDmSReGZPYyOaZBQ7tVOFws8L3HosGdKQJCQp6ocxT/uPOO1ndW5R6/AYxtnkh7iIktd/VxoPVTZ29Fv7HKAIAVSf37WvCUEVyh40K++0VpNUobK/GqN4/uFQRBeazKHU+XJ9GDKxWWwqnJO1vgoKE3G+gU3agGwD1S9aXqr5l5f6WHEMh2uREOVlAUYT9KtyoniytDrqoInIGgM8OyW2DA5FfElNEjJCHwHjy2gRNqUVXkpJTj7g6RZcTUTnEygXqWDo4Y8XmO2ci3hfdDoyOvtcdT5aReNk3NsYpcTuCKiEVsI23VeOUfzuO+iinDPnUzv63p/9yNVl+HZyUB6cGeFwtLuBv/4iV0b4ibm9u6bO9zJnnO5SBCbga3P5FSNbDLAj1OpxPdilM678yRsfBPWSxUPMfXJTDSLivu8g6k+2XltSgXqMfMYBiyv5g65Q+nqmPmvGkq1zZDxuX7xUQlKRnMX+QHRdrdovsxob/elklL1c7BEQcLZ7iRtSVRyH3cDhZGzgp1WW5xrqaUMLSHHEdUkwhm70TjYQSc4nS0vhPplSEzPj4vdhRuKTsSCx
 aO/83lW/
 DpDxKn7zsP80ZHY4XSAmyjBFN8A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Dec 23, 2025 at 08:54:34AM -0800, Andrew Morton wrote:
>On Tue, 23 Dec 2025 06:43:45 -0500 Sasha Levin <sashal@kernel.org> wrote:
>
>> >> > Yes, -stable maintainers have been asked to only backport patches where
>> >> > the MM developers asked for that, with cc:stable.  There may be
>> >> > slipups, but as far as I know this is working.
>> >> >
>> >> > I don't actually know how they determine which patches need this
>> >> > special treatment.  Pathname?  Signed-off-by:akpm?
>> >>
>> >> I guess it is pathname, based on ignore_list file [1] of stable-queue repo.
>> >>
>> >> [1] https://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git/tree/ignore_list#n16
>> >>
>> >
>> >Oh, that's a bit sad.
>> >
>> >- other trees sometimes mess with mm/ and they probably aren't aware
>> >  that they need an explicit cc:stable.
>> >
>> >- misses drivers/block/zram and probably various other things that
>> >  the MM team maintains.
>> >
>> >Oh well, I guess simple mm/* coverage is good enough.  But I do worry a
>> >little that useful fixes coming into mm/ via other trees without
>> >cc:stable will get missed.
>>
>> How should we improve the filter? mm/ AND signed off by akpm?
>
>I think just signed-off-by:akpm please.  That way, mm fixes which come
>in via other trees without cc:stable get backported.

Ack

>Obviously we'd prefer that such patches get appropriate consideration
>by the MM developers but sometimes other-tree people aren't that
>cooperative.  In this case it's better to backport the thing rather
>than missing a fix?

I tend to err on the side of taking one extra thing rather than missing
something :)

Would you be interested in trying out AUTOSEL for mm/ again? In the current
workflow I give about 2-3 weeks for review, and all it takes to have a patch
dropped is to just reply with a "no".

I can generate a series with mm/ patches from v6.18..v6.19-rc2 that don't have
a Fixes/stable tag but the LLM thinks that it should be backported as a way for
you and other mm/ folk to gauge the current state of AUTOSEL, if that helps?

-- 
Thanks,
Sasha

