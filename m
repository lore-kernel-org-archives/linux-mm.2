Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A759AD172C6
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 04:55:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 988C26B008C; Sun,  1 Feb 2026 23:55:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 90C1E6B0092; Sun,  1 Feb 2026 23:55:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8188C6B0093; Sun,  1 Feb 2026 23:55:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 70D1C6B008C
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 23:55:04 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E2B868CAE2
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:55:03 +0000 (UTC)
X-FDA: 84398302086.22.1505729
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf06.hostedemail.com (Postfix) with ESMTP id DA00B180009
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 04:55:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K7xHFaVH;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770008102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iQMGuhj4v1Wf/hZq+ihAsexgXJVjJdPHN5MjuTUGtm4=;
	b=TzBQi7Pc+P7vOARSYjYeP+SpOEhN3DlSB8JDh1PPaW7AD7fAdPlW+sxUX60he7i0Wn6hZJ
	LjGmw0j768czGkf8H5qCZME/p75jCIA/KNs17HGsm8pHRdNEWV7nUXtoul2CpPpPpp8U9x
	gD1h3NbcTF6n0zAvljT+B6iEAjFHp7I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770008102; a=rsa-sha256;
	cv=none;
	b=F1Kf0cy4fdlGQhZEvuOgG9gghZx9MKei3li8HA+t1IVfdzG0PMWwDLDSu12vW+QoLBewae
	9ZYm3WGBucg3JhU2eQkIG2WYHznIvmTXw6vY7cvxg9wMlkzKim1WCgIGPLjFDCvYbkqCbl
	6aF3NjiCqphbo6Ll3RhkGWnz/YGt/Io=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=K7xHFaVH;
	spf=pass (imf06.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1770008099;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQMGuhj4v1Wf/hZq+ihAsexgXJVjJdPHN5MjuTUGtm4=;
	b=K7xHFaVH9oPc1Yh/xCOEHjVjZmuhacqZUTn0fta11OA0WnR0Dr+LIqDT7D0B84IMh2J6Gw
	T3unqGruLGEy02l4zvf1P4muxuoHYLbqQR9gEqrO6tXdtQ2j6CPXKIiRg6/EmZcUIB8x5F
	k/F2dWJsb0YCvxzTEmk8H8uxDGq5He4=
Date: Mon, 02 Feb 2026 04:54:56 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <51819ca5a15d8928caac720426cd1ce82e89b429@linux.dev>
TLS-Required: No
Subject: Re: [PATCH 1/4] memcg: use mod_node_page_state to update stats
To: "Dev Jain" <dev.jain@arm.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Johannes Weiner"
 <hannes@cmpxchg.org>, "Michal Hocko" <mhocko@kernel.org>, "Roman
 Gushchin" <roman.gushchin@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, "Harry Yoo" <harry.yoo@oracle.com>, "Qi Zheng"
 <qi.zheng@linux.dev>, "Vlastimil Babka" <vbabka@suse.cz>,
 linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kernel@vger.kernel.org, "Meta kernel team" <kernel-team@meta.com>
In-Reply-To: <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
References: <20251110232008.1352063-1-shakeel.butt@linux.dev>
 <20251110232008.1352063-2-shakeel.butt@linux.dev>
 <1052a452-9ba3-4da7-be47-7d27d27b3d1d@arm.com>
 <aYAmGc6lu973jRwu@linux.dev>
 <2638bd96-d8cc-4733-a4ce-efdf8f223183@arm.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: DA00B180009
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 4heq35iuwtyqqws49xsng41a6smkaz7r
X-HE-Tag: 1770008101-787698
X-HE-Meta: U2FsdGVkX1+sJ4LqS1ocDy51QhzNm0hqPAh3arKcu7a5m7j5ztOcAyIlc+5HdGY1sDDoMhc66YZNSxpx1IMhEVhOwbCJKGc5fDZAwyVXGK9TpgzFu5ull6IDy1ZoIjVOYyvV+REiZ7sWReV6w2aYCGzSZ6rBX6cjvpTqP6Wk4Ju2NttnT10G/J0lh9NKPw0BeqilJXwSsmWxXAsAYhBG38Ns4bRTfu+RkdUOeHy09077s0crkfKB6OBo+9wBP5HWXyCr0XJ8/dzn52Ht3Ziax2bufqVPul0VW2RpzhnjAS/oh+BAKSSo/ZbrJ5vChi6Otzv3h78Rbdz74h4J6//FvOEf7xBqGTJyz93Pj76nGeqWncd45anM7nskTclY7y2PplhfXqyirLlt5r7728kHPNx6b6TjBeRRdxNVOEnh9Yr+NKHaP+6gmlIoRE1ZlLQ5TicKDhkomsVtuDXzBtIdexzLFThciuGQhdaCCufXd2zoYK2KrmBz7LALqmF6eq7ikl5oAM7hh4TfcWHg4UTVt89Wmd+WwBOWjsiXjO28v+4Frf70F89UInhXjN4PYY8A74yvTmeMkwi9D7Ovo7cHn6HG8Pj370j0VnZmQuIDAeku0DgNYnOTyofHPnajiQQT6o6xiLPDsoxSU3inrK+s+iQk0fPoSRV49nyPr1KD675e4eSHx+iPg/QeZdVu+08eedk68yxIV6nEOCAhRNudrh4ijP2nDw6pVtrebDAGODgLcj3trXYLqY+ACKTI7xZZBMCTnquIhFA9bIUMzVexVXtgSYU31daCxJ3EiChUpjLxnWRjhFfzVSBlWsHIpO/FlqqkMqHgyobQKAdIhSg3O45z/zLP8z9UreTv3VvEj7/hF+dQ2nZWsYWNB+CBp1DiMWUshtuqoAh+RF3QuGdx90yllGYlh0dLm9JAkGE0h7pq8Dy5u8099nWhJZ7Y4as7EOiSryoTyAYtPpMmxEv
 42sBPFYv
 lW88/YjkugfrAtRMj5B4owtY5Mm3uJWU0NWiJWYneifGVnLViikGntS7EBt0D2HwgsP/sQLLJQ5pEmicKDITaEPeP6HmNg2CTSzfDzSIrqQN3D2McR8b1AmY5SinSRO3z7tabdf42W/MwMudAepoTE2UJamoHYO0MQoDghuFVJGOh/bnjxnrOHpkSasiSWd0oRUZ1JAp3xq/0iNTO88WF6Rx6bYCfzQnnwwkwP9vkTc3y3/mbk2o6lFk0O/P5zB4F0HMY
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> >=20
>=20> >=20
>=20> > Hello Shakeel,
> > >=20
>=20> >  We are seeing a regression in micromm/munmap benchmark with this=
 patch, on arm64 -
> > >  the benchmark mmmaps a lot of memory, memsets it, and measures the=
 time taken
> > >  to munmap. Please see below if my understanding of this patch is c=
orrect.
> > >=20
>=20>  Thanks for the report. Are you seeing regression in just the bench=
mark
> >  or some real workload as well? Also how much regression are you seei=
ng?
> >  I have a kernel rebot regression report [1] for this patch as well w=
hich
> >  says 2.6% regression and thus it was on the back-burner for now. I w=
ill
> >  take look at this again soon.
> >=20
>=20The munmap regression is ~24%. Haven't observed a regression in any o=
ther
> benchmark yet.

Please share the code/benchmark which shows such regression, also if you =
can
share the perf profile, that would be awesome.

