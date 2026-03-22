Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0CEFBD58CA1
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 21:47:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F2BF6B0089; Sun, 22 Mar 2026 17:47:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 67C966B008A; Sun, 22 Mar 2026 17:47:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 543A86B008C; Sun, 22 Mar 2026 17:47:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3DD226B0089
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:47:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DF65C8C719
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:47:18 +0000 (UTC)
X-FDA: 84575035356.28.DF6F277
Received: from sender-of-o55.zoho.eu (sender-of-o55.zoho.eu [136.143.169.55])
	by imf15.hostedemail.com (Postfix) with ESMTP id CD652A000D
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 21:47:16 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=EYmLpwQv;
	spf=pass (imf15.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774216037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HXLmepxkAT3ih7z9DVRd6OmLc/Oq1zcUKdvohFufYtQ=;
	b=cMMvF9GPRDMsm2+RVD3phnLAJCCCNlkl8f9rRLMCiwfplitqXQ/acIpfmYsllfLFGwRWD0
	X4eQPzfkGLEcth04MLecSCybs0UDmOgAtuBc2Q0tDcm0NUcDWMQ1xzNDzIs6ZaokMt+7YJ
	86NedJGBkmXzfKsb+gKc6pYLwk4ZV60=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774216037; a=rsa-sha256;
	cv=pass;
	b=Bl+kzWqELg5l4IIoUyKA4bFx4kI7XjJnXr37HKpfTyf9WYMgTxTC9KIGZzzXwdUsE6dWD+
	3GLsZZXEbHRVles9Az3lGU0/5vDzE1VR/nXqSc0/gGcwo28Rg4pu3MNCwIG6pgFeFAhM0I
	r8sgye3ZisQfD/5a6qGOP5ugQ+NpG0Y=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=objecting.org header.s=zmail header.b=EYmLpwQv;
	spf=pass (imf15.hostedemail.com: domain of objecting@objecting.org designates 136.143.169.55 as permitted sender) smtp.mailfrom=objecting@objecting.org;
	arc=pass ("zohomail.eu:s=zohoarc:i=1");
	dmarc=pass (policy=quarantine) header.from=objecting.org
ARC-Seal: i=1; a=rsa-sha256; t=1774216026; cv=none; 
	d=zohomail.eu; s=zohoarc; 
	b=aORaaBr1yeo41PxBuHQdK6K8udCh54dJoBCqmvPyoprvo0MR1jCr0dZKuhvTPn/GJyksBq8vw0+e3I67CiPn3bhugqM91cSuQ9ULtjpndotlcJ5a9g8hFopUkWBPZO0gq8qiGHl49fCLuJe15zFlFO2LnSndS+QvBTrMP240rQE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
	t=1774216026; h=Content-Type:Content-Transfer-Encoding:Cc:Cc:Date:Date:From:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:Subject:To:To:Message-Id:Reply-To; 
	bh=HXLmepxkAT3ih7z9DVRd6OmLc/Oq1zcUKdvohFufYtQ=; 
	b=AvUoD6Y8VVDmn15C909wcXbCUJJFbo4P/fpThfIbdny/4+xlVSERS3qUyHrbvKolVaRcJ1rGLhQihS8TkoStXsggsfjcPQQMNHGHnB9J5GY6yexVevA5GO202QBJBeMTLs7pbNEwIURfiH5LCDQZ4egfSm2IAGWrHknlJodpfKc=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
	dkim=pass  header.i=objecting.org;
	spf=pass  smtp.mailfrom=objecting@objecting.org;
	dmarc=pass header.from=<objecting@objecting.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1774216026;
	s=zmail; d=objecting.org; i=objecting@objecting.org;
	h=Date:Date:From:From:To:To:CC:Subject:Subject:In-Reply-To:References:Message-ID:MIME-Version:Content-Type:Content-Transfer-Encoding:Message-Id:Reply-To:Cc;
	bh=HXLmepxkAT3ih7z9DVRd6OmLc/Oq1zcUKdvohFufYtQ=;
	b=EYmLpwQvilR/nwMiiZx9YWXrFbyb7NkauJ33x63jnNKLc87W8RmjMIviXB4iNia3
	7kCbxbSJV0SYJk5cssJk2fMLRevJ1SaqEYiEGU6kMlAKxC0dicJo2Ml0sD9/aPCHDNx
	q7mHF0FE11LbkHwbLxuRcVSe3k28bBnNElY3KZ+c=
Received: by mx.zoho.eu with SMTPS id 1774216024676308.1049291411887;
	Sun, 22 Mar 2026 22:47:04 +0100 (CET)
Date: Sun, 22 Mar 2026 21:47:03 +0000
From: Josh Law <objecting@objecting.org>
To: SeongJae Park <sj@kernel.org>
CC: akpm@linux-foundation.org, damon@lists.linux.dev, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: =?US-ASCII?Q?Re=3A_=5BPATCH_1/2=5D_mm/damon/core=3A_optimize_kdamond=5Fap?=
 =?US-ASCII?Q?ply=5Fschemes=28=29_by_inverting_scheme_and_region_loops?=
User-Agent: Thunderbird for Android
In-Reply-To: <20260322214419.89419-1-sj@kernel.org>
References:  <20260322214419.89419-1-sj@kernel.org>
Message-ID: <668B87EC-A893-433F-AC0F-412854A6F95D@objecting.org>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-ZohoMailClient: External
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: CD652A000D
X-Stat-Signature: ypj3ge4wr1c9eno6kg61enx7kw9h5cue
X-HE-Tag: 1774216036-199451
X-HE-Meta: U2FsdGVkX1+bdSkmwItoajaRJrCpoXp8Bn7p8icU2Xc11nLA/V/PBCtVGzTnk5Ez3xZprM8j2ASV47sdW+AGQnWR1mjwWYaLa2lXPhfrhuardE6EBxhFH7fxW3XD0YPT4+KIG13iGoHpHuCQZkIHpmTHVzN03nbMIMjiL+Gl5gPVquuksvnJtqe3SG3oHYXSv8SUcOlyZ8ChCSlWJJSFOw6X4uWaeqg+mGieyj0RT9hhYea251vwOEwP23TimLiX5nh6YvFRfTgvEZm3XagiiZNWfEPwTRYEfT1QPnZXzkhkcfmdB1L5WFil06rvNzLgW/BeCRQP1pKEc0jlGdkdYbwhJsQOI5hpbqaQdUBR4NpyLNi+pwmk56/tWATv7lblUpxs48Pr7GmeZjZEdUzjSqY+5sQuNTg91Ig06tdsvEwzn/q2FOliyfQaGHGk+DN+c56IM7LSiMOLzP9hgWsZ+ucCMMEgp7yrjhiDobBadqnDJQMBsDt+D0jeAXf3EczHMQ1pF0eLNOFHF8HWN/N4cenIIspT4P3MAIhttUO76LeH1+S2whxGk7yu/2lT+SrJeMrz/S32F107+72bSgpIxBzccS9kVK0XyJgoSy3Zr/wNGv/s9/0b/9dI3mjrXJlkaWgasjMOkkKrBWN8pRr63LZGGUicS/+WdLrAixC2q+gpCBSmG0wb8+TBC2WB6l0SsC8o5fIlFwGi2Ib9CnmdsAbyvwvDJt3uPkcO7DO49LaPk5keR9wJJV0WHNM+HNSLQ4fjzRwsTZ1W9v9nczSoN26z0Oqu9AVmqNKDJfL+6d4WIpmIQ+yjlQsxINziyrEO1X42cXYJIFG0WuP05Gd+it6EJ1fDGZTpz9hmu0/oqpVpZEzfRRHAzCDiV1BwR/x/+07mljWDTLVeSH/exKHOcS6OXQsgRRiwlYXeDvrJp1cDo/jr8bTxxTVJhMAPShfBZ05cFyCJKN5LW+RRlmp
 qlW/XXvb
 DyepemUv7KpHPuwXjv6Wuv7rGqK8X0ZiUzeKyhUzN3qSjiNtqhTeveaL3yrfnxmvN1144XZERATLRhGrjVjFhOf9l6Td8DCHXxMYkuLztMgXmtcctdjspRXOrfgj9+od3TaD+uOZNJ6R3h6fx/wdNh5ljGbjVqaIlxS+lZUor2Wb7T/2g5Xs+AszqDepK64dC5GwyJ8EVCUKzqux7up/SroNbJzE5K7bdOJtWpkjqldYMqyLMQqOg9DOd9TDDjgYTvrbmJ2FmWjTJR+fhd48hD3jV2g6VbRgKsmL+u4ulAf+bAz8gCUwDhs5CF19+eTGcQuzosCEBOwyEqCpSTr2U8rD8lOj7k+bQDNbZJSuW5UVr3bTkOU29yF05wNRRtw02ktbwG9crN/VOwHRN0WUIGu9HFo7xKj2p7QzyGpRsoU2solLGaXTeR0yZdFfBlRxWNiwmClUCx3QKN42/Jni26S9HXpQ9Cq48TD91rsFbT0cH8wfcFaZgr04iB3O0fPW0ZG+bsxiHdOOAm6izyVIIgnqDvKQqouIIimEE/61UsUJl6Ht7RvpTcDiM/43TRi66sjepGTZZwIuTV2JrNsaFsdsMiA==
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


Hello,


Here are some benchmark results for both patches indicating the need


Benchmarking Patch 2 (Division elimination) with 1024 different attrs=2E=
=2E=2E
Old (with division): 0=2E376372 s
New (cached value): 0=2E265899 s
Speedup: 1=2E42x


Benchmarking Patch 1 (Loop inversion) with 10 schemes, 5 targets, 2000 reg=
ions=2E=2E=2E
Old (nested regions): 0=2E055627 s
New (inverted schemes): 0=2E016167 s
Speedup: 3=2E44x




