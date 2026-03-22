Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C736D58CA3
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 22:00:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 41FE36B0005; Sun, 22 Mar 2026 18:00:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D1156B0088; Sun, 22 Mar 2026 18:00:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2E6DF6B0089; Sun, 22 Mar 2026 18:00:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2069C6B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 18:00:03 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BF7F21E45E
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:00:02 +0000 (UTC)
X-FDA: 84575067444.19.BA32CDD
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf25.hostedemail.com (Postfix) with ESMTP id A90ABA0002
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 22:00:00 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fxNZhfFB;
	spf=pass (imf25.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774216801;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q5SBfcXWoZKMehLKAOaodzbx+qJB2kcIdSj54XofiDw=;
	b=xG3IF/G2ZZ8zx0SB90mEnKQnIZn+M5Us1Cj+BKTl7wxn1iLY+kYhZH3E8ZfCGeG6mmOvne
	/Bpgew8LdJs/XahG/2Q/RlZ6uQ5W9owqGgicKR/3lMcPOKmrevD3Yyesqtv/1PXIx7mLs1
	bCyPCM00xUbbjrYva72DxZ/CLhpL8CA=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=fxNZhfFB;
	spf=pass (imf25.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	dmarc=pass (policy=quarantine) header.from=objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774216801; a=rsa-sha256;
	cv=pass;
	b=Na8eBf8bgD0wag/wzDJW1a3dUSchQ5WkoHCNhNiTAP0vQ95JhjW1OVG8HVOtkBJaQNIOQb
	ze2c7cVXlvexf0ia5S1xiEf6xti85zah2bQg/bDep4hTX6R2Dm8XYOxWcCBVjEqyYXFtJD
	/8siSyKltUe7WoZKS2laz59Lf83zjoM=
ARC-Seal: i=1; a=rsa-sha256; t=1774216788; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=EKuccVsvfUIJRgw7tycR80l5VpmyxcRpgC13lfLNAZMKQ54ycbbB3H6NCTjhTxbI4JUgq9rre247wKJGaIIIBBDQLVXCXN0vyal34YyyViPU9GkmQUcjTZZOiRmFOm/72k11JbNKhz46Le+I3qXNPMqgFaP0nlXRQRQx2juqwOY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774216788; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=q5SBfcXWoZKMehLKAOaodzbx+qJB2kcIdSj54XofiDw=; 
	b=NYXzc+OHfPK4EVs45DKdQyGlLoP12uWaymMcBsaL1ZNS8DXvWi+qb54zD4tzyBi0KzqCiXPBoH3Eu2jGQA/YGeMPav71Je2GF66QfeMXrgB3+OZcNWA/s9hFZYTXNRs4e940cuvHEGUhexCWcJ+9XhwqO5jKQLOOXTbVW9VTDgw=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774216788;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=q5SBfcXWoZKMehLKAOaodzbx+qJB2kcIdSj54XofiDw=;
	b=fxNZhfFBq5whhE1w6Mw+L+aVzRP1aEkxdGImtwtkeewvXhFyyohIF1TxBSItrdIB
	XuAGie/RPS+eN+i5P52dDeQx7yCgb2oVLakv+CFrxTQjM3+caxxZfynEBNls36pOmF6
	iy1T2rxXozNhnwLvfo68TBEZ/maspX1ldfBFWJKs=
Received: by mx.zoho.eu with SMTPS id 1774216786422857.3733260462551;
	Sun, 22 Mar 2026 22:59:46 +0100 (CET)
Date: Sun, 22 Mar 2026 21:59:45 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/2=5D_mm/damon/core=3A_optimize_kdamond=5Fap?=
 =?US-ASCII?Q?ply=5Fschemes=28=29_by_inverting_scheme_and_region_loops?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260322214419.89419-1-sj@kernel.org>
References:  <20260322214419.89419-1-sj@kernel.org>
Message-ID: <C9B59023-161D-405F-8941-1B0E0B8E1D6B@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Queue-Id: A90ABA0002
X-Rspamd-Server: rspam08
X-Stat-Signature: 549mw8tpcbbow3zrbn3m1ykfxn5edfuw
X-HE-Tag: 1774216800-820205
X-HE-Meta: U2FsdGVkX18bBEQ0NGt6MzIzClg+HNrycYUUYcFrDWkNyfAWLYPFdqg6T6RcbvHpYGXP4PYpPZepXhYYtr+3xFtP1x9ORXWrdOpQED4b8WjSEkGRreGGxp8FtXey5XgBeveHjonHdOEdix4WsF/QB7NV7RkrZSNDStgiSHUCYyu+wq+ld9jHJpsx4Hh3lCSMUcnT9D2AzCTmldnNwoMaew3eegwtbCeuq9DA3dEDtVykPfJMAtCthtbH1HBYJlYccMZDPmRaE6Hk0dZHQt+yNjkM3dbzogkPrWScebalX9cYt+UqLQwNEMycPzSTczNf9ORo5cMSNvDep7MIHNsVk7TMwFuH75TT2++wfB0XkYouGQ2XcXU/cgnqVsKjEVyE2RfsFvjuP7m/2Ib3o/has/quO9guTHIosoNTrvSojAMHdoO/PGdcN9K48aTnzKyUbMB+a2IVJFp82G+TOp1iHnjSx2a2nIXrWbsNxjhSNjXC0gfhqKhtjNxy+8iKzHSoMyy7SRMIw+R7BLdUBxF1v3YE4EobSfHARRtai1eWQ/VskplpiR+xCREMx+aBT67ig3V+9IGzs2LwTi++30cBOyrdg2LsxgcDr2p+LMaWvUWkwRxs+qjEDZb4i/gfO8mdYRKGR4LO5ec5YMuUwv4EmpNECUIkuV7Lica82wfPTZ3laAZN5QlfwhX2b2Fclz6Y3zEqHU4lG5nE5RoOMYL7y+Qx1s73Vmymk2mlWrhcPAr2EhhuLQI5JWZNd5QWdyA+r52J8HAaKFHngF93kBKOKBeTua/W9ccHCk+j1jKqT4H6kDo08IlrukhqFfdgzbbPPfAEVG8/tK7RGfpogxrbc3wtka+aRXhh9DUlfkTFpKsOtMDEgHFSPpBb7ShnLUxxxiyOQMktcHE/HyPFyjh2RsmAHGmSgT4SuCBgmjii/nd1gHC2PY7Eade1HnzSWrhAvVfGkduIIkhD4U1d9yL
 GbJc73Au
 217gcjVMEGbzB/wGAIgVpRLs4h3gGcNFTtEshwbOcoEx3U0YsJ2g/tk31/0psfrE2qBMv75EnuLyhXrtlN2ETA9Cqlzg3xtEqBMgkR/znDafHCVQ8YyvlO+9xy1grkdebpzlgLInUVIgm7WgH4JDRMmJGY/enRapR98DXv1XqB14PHsrA0pDKXCbN7xQblU4jQ8RPUSV/aq4E1Esu6345jiuLZ/gGcSyJhtRL2fmcoDbENMk9F6DbSmLChggDoXflUS9jt+dHA6BkLJe4JKDQ+NsSbIrMQY+0jWXvIb32OB9QR5L9PPzN64HNU+fXT37IO7f5ZQ6uCb7VXDrq3Z3TkKgwMLbtpAKeIQr4ET0A/O6iti4Sp6j3o3DDHpsUjXC5XIKQTtWRPrAvB4X9+QPLDD14t5p4TRXeGNrVVP/v0VB3YlL1yqdCnZiGWibthSdAs7bXL3YuRMYkgECarF188BYxgdNZA2/Q32yoqJqdqhWgKA5lrbiOXkGciOTKCVCsV9mPld8ve7j+Z6vKFLKQL2I3juG61GFIvZdA/MnOehy4+0PMv62RC8NKNzFjouwvv5VlTGfe5hekPFq2HpcsoJT/Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 22 March 2026 21:44:18 GMT, SeongJae Park <sj@kernel=2Eorg> wrote:
>Hello Josh,
>
>On Sun, 22 Mar 2026 18:46:40 +0000 Josh Law <objecting@objecting=2Eorg> w=
rote:
>
>> Currently, kdamond_apply_schemes() iterates over all targets, then over=
 all
>> regions, and finally calls damon_do_apply_schemes() which iterates over
>> all schemes=2E This nested structure causes scheme-level invariants (su=
ch as
>> time intervals, activation status, and quota limits) to be evaluated in=
side
>> the innermost loop for every single region=2E
>>=20
>> If a scheme is inactive, has not reached its apply interval, or has alr=
eady
>> fulfilled its quota (quota->charged_sz >=3D quota->esz), the kernel sti=
ll
>> needlessly iterates through thousands of regions only to repeatedly
>> evaluate these same scheme-level conditions and continue=2E
>>=20
>> This patch inlines damon_do_apply_schemes() into kdamond_apply_schemes(=
)
>> and inverts the loop ordering=2E It now iterates over schemes on the ou=
tside,
>> and targets/regions on the inside=2E
>>=20
>> This allows the code to evaluate scheme-level limits once per scheme=2E
>> If a scheme's quota is met or it is inactive, we completely bypass the
>> O(Targets * Regions) inner loop for that scheme=2E This drastically red=
uces
>> unnecessary branching, cache thrashing, and CPU overhead in the kdamond
>> hot path=2E
>
>That makes sense in high level=2E  But, this will make a kind of behavior=
al
>difference that could be user-visible=2E  I am failing at finding a clear=
 use
>case that really depends on the old behavior=2E  But, still it feels like=
 not a
>small change to me=2E
>
>So, I'd like to be conservative to this change, unless there are good evi=
dences
>showing very clear and impactful real world benefits=2E  Can you share su=
ch
>evidences if you have?
>
>
>Thanks,
>SJ
>
>[=2E=2E=2E]


My last email:

Hi SeongJae,

I've looked into this further and ran some extra benchmarks on the kdamond=
 hot path to see if the gains were actually meaningful=2E

The main issue right now is that kdamond spends a lot of time "spinning" t=
hrough regions even when there's no work to do=2E For example, if a user ha=
s 10,000 regions and a few schemes that have already hit their quotas or ar=
e disabled by watermarks, the current code still iterates through every sin=
gle region just to check those same flags 10,000 times=2E

In my tests:

Typical setup (10 schemes, 2k regions): ~3=2E4x faster=2E

Large scale (10k regions, hitting quotas): ~7x faster=2E

Idle schemes (watermarks off): ~7x faster=2E


It's also a cache locality win=2E Right now the CPU has to bounce between =
different scheme metadata inside the innermost loop for every region=2E Inv=
erting the loops lets us process one scheme completely, which keeps the hot=
 data in L1/L2 and gives about a 10% gain even when everything is active=2E

The goal isn't just to shave cycles, but to make DAMON scale better on hig=
h-memory systems (512GB+) where the region count is high=2E This keeps the =
background "CPU floor" much lower when DAMON is supposed to be idle or thro=
ttled=2E

V/R



Josh Law

