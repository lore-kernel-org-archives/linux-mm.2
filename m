Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9167D58CAC
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:39:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 286CF6B0005; Sun, 22 Mar 2026 18:39:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 210666B0088; Sun, 22 Mar 2026 18:39:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D8756B0089; Sun, 22 Mar 2026 18:39:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EA8206B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:39:27 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8203D5B323
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:39:27 +0000 (UTC)
X-FDA: 84575166774.03.065B0E6
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4DFA9180005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:39:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=RVsXarFb;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774219165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7htVmUNWgWhZ4WZhbE/1OPjn0u09igwJQNEcQ7skU9Y=;
	b=BK8e52KEge9yC1zCOZ02qJ5SlGkh8aKNFwAWffcLMHRv7zH9rc8DxF0ZDMiBigcaFBe28V
	B8xbpadO+zadyNbOBcMCCS6qWae+x1Ip1HrBNs1NxoeIgdeuKuwQgZ793lgnzAhdj/e43y
	RTKdqGcAQe8k9Ioyc8nhAVuxX9mXQF0=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=RVsXarFb;
	spf=pass (imf24.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774219165; a=rsa-sha256;
	cv=pass;
	b=E0U3EEOuwnoM4UPAuDy5j+ArBlC9b8ZfwbiBoSZhgqVrYGxbx3/Q649e+2cbP3/q11JNUV
	ioDnds7O+BW+hiD0DUejYKnZlU4SPqV0LNEC3w/GtWcFXWehdYouciqnat59Ls7VE/FNJW
	kxmxDR5eN5d4X6CcaQ4fS7Nxk7IcopU=
ARC-Seal: i=1; a=rsa-sha256; t=1774219153; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=G9pDd8PfxJI8tQuY+537qK/OfSryAtiAEMxsL6FKwfUYK2h+tmPa81TR55s37edP7ptkCVkL5CXz2lnu1CADy0XPCpc4Ux+5Nb+JgWKrJtAeG4EmTFvv6GjZcIfSCn0hSXpCB7Cjy+FO9HSBDKXPAcLFY04R9U3bipGQWBgtoms=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774219153; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=7htVmUNWgWhZ4WZhbE/1OPjn0u09igwJQNEcQ7skU9Y=; 
	b=Jz7PS3SSlCwYgr+2m0HwA8GyrFOZosmHupD+LrhStX4TXH8zPHYXHaV2VBptmyFvitHsiIPF/HoKW53VoZeCoHFjfJdbqzNKL2ZhRWvrnc6rhxef3Xfcf/j+FzZ3nOByUQ7jz+OzZe84TCuFOkhh5LfMUDEaD685F32q/VU26g4=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774219153;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=7htVmUNWgWhZ4WZhbE/1OPjn0u09igwJQNEcQ7skU9Y=;
	b=RVsXarFbJ8pUm293gwQoaLVz6ag+yxu/xfCSgp58Ixx0xV6YQZcXOmQoK7A9qX/9
	Q3fPXQA8NPISbkC2x+mWf54DG/QXch+vrZSuYLEJEbyVF1cTCNnmUglJ4Q4v6oPLEkF
	KMQmrWLHliIov9VvxaZ1m36NU8yjbVNCstslnN5U=
Received: by mx.zoho.eu with SMTPS id 1774219152622890.3867755718165;
	Sun, 22 Mar 2026 23:39:12 +0100 (CET)
Date: Sun, 22 Mar 2026 22:39:11 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/2=5D_mm/damon/core=3A_optimize_kdamond=5Fap?=
 =?US-ASCII?Q?_ply=5Fschemes=28=29_by_inverting_scheme_and_region_loops?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260322222845.89757-1-sj@kernel.org>
References:  <20260322222845.89757-1-sj@kernel.org>
Message-ID: <FEBF344D-3A99-4360-A286-705260B68704@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Stat-Signature: x918cufpft3wb8oudf5fjpxijpyuqk4b
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 4DFA9180005
X-HE-Tag: 1774219165-799355
X-HE-Meta: U2FsdGVkX19Cb7qPSKiSrmOKpUvh/HYH8m0kuOuXPtjRN3uV6hiXAErWzJPCH0jLFHVqqcJ4YMoldHfpH3ENjjfnvDTTqlrx7N/C76xOMdszkia58z2Hi4d6iBO2JdtTA3UR+RVaoywAwqIwDAJRPaZDJnbmyRR7vOyOGnyo6UhfP4s93zSPn8ZfP4uCIUy0H/LLgcqL1FGbimzA1DNmuMRSXJTAzF0j8cDMG5xQKt6Q1mYjKKpSFArq/3rAyx0DRDxoh9fBy3inVNjsusi99LQGV4EdLaOVr/9I5RvnPOAbG884+21j5b86Kw/zEqVcfyKFEZL8U8SXd4r7dLc+e9MNaZJIpEryfpEa9wqFluh+b8IUB0U30VK7Upe3efwTPi8p01It3xcjVItFHr8qcY3oPbF38tvsV/2LzDn3NXD057WUMfzyY5/zTRITg1GjLb4vAMicwlVI6d1eluzPwPsKq5GvMpVOq89LwECNGKnE3sakOJWOj7reLrOTWa50VvLFbU66yhd41IhURmG3aZFSPFVwioECeMEscS2c/VLW3oCyCDNPE+GxE88jUDa+7S4gkPsa/w4h1bZ0dfqBw9m6bL03Vf+WzeczLMCk5GwEp8CB5ona5f88dUBdaa7SZVofx+zY8WOIGOd/sIoLduXJRFGRTaeIITpq1MrblEveTahZGXxXo+IlGjecHX33Hs8dla2OpI15CUJDIK8nYs64rAMc0yAqBnvld2NTR6kAFVJJY3Xp8Bi7KVZp7fC3Pw5E6ASRncghxetjaMmBzlrGR3jDJkUApB/Y1YKpOx0hpPQHM7s3YKiwnooGiCXN2KtFIlQqNOKdysQrp4P9klNazTbzeMPly5yeR21MUNrfIN1mzjsBM4qcpOi1Op6RPNXpZnhh9XgSn67YI8MyVO87mopxktccc0JkB85lmkewy4Bo69jjgEAraSB9SZl11o5R6CP8+T2s1iT5T7N
 FOq89Ilw
 Sk3CbdiOQ2RFhmey1UYDJaf8HKEvm3IY+yLcVhTtkty19e4lnPlNNxPS6ZyhFp6FeqPgbNBh7JXHadeYtQI4kfUnmINlsF85/xSQvjocJ8jsaYAxkjY561P0w3DxcMso8AtY10ebAVNJpuP3bBoj6yFoC8ciQ4SD5lmH/woWMhfvlrYIdJp3719g73iu/QbkzXcZkPuWZvpZhaqrMkElc9+4UvQMo+qRkxvFv9AlutW3tzCYYGyvK2r6yOfbnpNGzaVhU1QxCZ/85izj+eM8KiVVgCu/4XpiAiQ7ww/r0RHPT+vJ/wePJ0R/g1w/pqmgbR2ATEZph6C/pgBvp3cwm0BOJ0ZjU4LeRohKzvzlFDQGS1zUx54FdNMgpNbHlScWZoRM8XgaLhpJ5h7eLFqEf5G9d6SXqiVugiWz/2xOpP8mMsSOWIn2nfh0/9oDfJWD1O7eNM4hvncIL/+4IOncIgaLrI3005DjVzLBUndw6iK4p02slcRiNBL9Gbx3ZH0ifTM/EMaUoqiyIQvI5iLzms8ZB7yVS7lUXpnJy02RQ7oEOAH90EoCMzYARxZQQXWfM2qXWQgSMvMaFAiFTPgtJhIN6Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22 March 2026 22:28:44 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>On Sun, 22 Mar 2026 21:59:45 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>>=20
>>=20
>> On 22 March 2026 21:44:18 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>> >Hello Josh,
>> >
>> >On Sun, 22 Mar 2026 18:46:40 +0000 Josh Law <objecting@objecting=2Eorg=
> wrote:
>> >
>> >> Currently, kdamond_apply_schemes() iterates over all targets, then o=
ver all
>> >> regions, and finally calls damon_do_apply_schemes() which iterates o=
ver
>> >> all schemes=2E This nested structure causes scheme-level invariants =
(such as
>> >> time intervals, activation status, and quota limits) to be evaluated=
 inside
>> >> the innermost loop for every single region=2E
>> >>=20
>> >> If a scheme is inactive, has not reached its apply interval, or has =
already
>> >> fulfilled its quota (quota->charged_sz >=3D quota->esz), the kernel =
still
>> >> needlessly iterates through thousands of regions only to repeatedly
>> >> evaluate these same scheme-level conditions and continue=2E
>> >>=20
>> >> This patch inlines damon_do_apply_schemes() into kdamond_apply_schem=
es()
>> >> and inverts the loop ordering=2E It now iterates over schemes on the=
 outside,
>> >> and targets/regions on the inside=2E
>> >>=20
>> >> This allows the code to evaluate scheme-level limits once per scheme=
=2E
>> >> If a scheme's quota is met or it is inactive, we completely bypass t=
he
>> >> O(Targets * Regions) inner loop for that scheme=2E This drastically =
reduces
>> >> unnecessary branching, cache thrashing, and CPU overhead in the kdam=
ond
>> >> hot path=2E
>> >
>> >That makes sense in high level=2E  But, this will make a kind of behav=
ioral
>> >difference that could be user-visible=2E  I am failing at finding a cl=
ear use
>> >case that really depends on the old behavior=2E  But, still it feels l=
ike not a
>> >small change to me=2E
>> >
>> >So, I'd like to be conservative to this change, unless there are good =
evidences
>> >showing very clear and impactful real world benefits=2E  Can you share=
 such
>> >evidences if you have?
>> >
>> >
>> >Thanks,
>> >SJ
>> >
>> >[=2E=2E=2E]
>>=20
>>=20
>> My last email:
>>=20
>> Hi SeongJae,
>>=20
>> I've looked into this further and ran some extra benchmarks on the kdam=
ond hot path to see if the gains were actually meaningful=2E
>>=20
>> The main issue right now is that kdamond spends a lot of time "spinning=
" through regions even when there's no work to do=2E For example, if a user=
 has 10,000 regions and a few schemes that have already hit their quotas or=
 are disabled by watermarks, the current code still iterates through every =
single region just to check those same flags 10,000 times=2E
>>=20
>> In my tests:
>>=20
>> Typical setup (10 schemes, 2k regions): ~3=2E4x faster=2E
>>=20
>> Large scale (10k regions, hitting quotas): ~7x faster=2E
>>=20
>> Idle schemes (watermarks off): ~7x faster=2E
>
>Thank you for sharing these=2E  This seems like not a real world workload=
 test
>but some micro-benchmarks for only the code path, though=2E
>
>In real world DAMOS usages, I think most of time will be spent on applyin=
g
>DAMOS action=2E  Compared to that, I think the time spent for the unneces=
sary
>iteration will be quite small=2E
>
>>=20
>>=20
>> It's also a cache locality win=2E Right now the CPU has to bounce betwe=
en different scheme metadata inside the innermost loop for every region=2E =
Inverting the loops lets us process one scheme completely, which keeps the =
hot data in L1/L2 and gives about a 10% gain even when everything is active=
=2E
>>=20
>> The goal isn't just to shave cycles, but to make DAMON scale better on =
high-memory systems (512GB+) where the region count is high=2E This keeps t=
he background "CPU floor" much lower when DAMON is supposed to be idle or t=
hrottled=2E
>
>DAMON does adaptive regions adjustment for such large memory system
>scalability=2E  I understand some users might dislike the adaptive mechan=
ism and
>stick to a fixed granular monitoring, though=2E
>
>So I'm not yet convinced to this change as is=2E
>
>Meanwhile, I'm thinking about a way to make similar optimization without
>changing the behavior=2E
>
>We already have the first loop of kdamond_apply_schemes() to minimize som=
e of
>the inefficiency that this patch is aiming to optimize out=2E  Maybe we c=
an
>further optimize the first loop=2E  For example, modifying the first loop=
 to
>build a list or array that contains schemes that passed the next_apply_si=
s and
>wmarks=2Eactivated test, and make damon_do_apply_schemes() to use the tes=
t-passed
>schemes instead of the all schemes in the context=2E
>
>This will keep the behavior but have a performance gain that similar to w=
hat
>this patch is aiming to=2E  If this can be done with a fairly simple way =
that can
>justify the maintenance burden, I think that's a way path forward=2E  But=
, from
>this point, I realize I want it to be *very* simple, and I have no idea a=
bout
>the simple way=2E
>
>So I wanted to help making this be merged=2E  But I fail at finding a goo=
d path
>forward on my own=2E
>
>In my humble and frank opinion, finding other place to work on insted of =
this
>specific code path optimization might be a better use of the time=2E
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


Hi SeongJae,
=E2=80=8BI understand your concerns regarding the behavioral changes and t=
he adaptive regions mechanism=2E If the loop inversion is too intrusive for=
 the current DAMOS semantics, I agree it's better not to force it=2E

=E2=80=8BYour suggestion to optimize the first loop by pre-filtering activ=
e schemes into a temporary list/array is interesting=2E It would achieve th=
e O(Targets * Regions) skip for inactive schemes without changing the appli=
cation order for active ones=2E

=E2=80=8BI'll take a look at whether that can be implemented simply enough=
 to justify the overhead of managing the temporary list=2E If it looks too =
complex, I'll move on to other areas as you suggested=2E
=E2=80=8BThanks for the detailed feedback and the guidance on DAMON's scal=
ing philosophy=2E


=E2=80=8BV/R


Josh

