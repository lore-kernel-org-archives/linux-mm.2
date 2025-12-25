Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 028CEE784A9
	for <linux-mm@archiver.kernel.org>; Thu, 25 Dec 2025 01:17:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3B5CE6B0088; Wed, 24 Dec 2025 20:17:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 363F16B0089; Wed, 24 Dec 2025 20:17:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26F516B008A; Wed, 24 Dec 2025 20:17:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 166486B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 20:17:15 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B0F4DC1842
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:17:14 +0000 (UTC)
X-FDA: 84256229988.05.81D6BF2
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf26.hostedemail.com (Postfix) with ESMTP id 62317140008
	for <linux-mm@kvack.org>; Thu, 25 Dec 2025 01:17:11 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JmOcZEDZ;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766625433; a=rsa-sha256;
	cv=none;
	b=EK40DxzCG5a+eW66J1KkmxBakJIF6xhD6i69Ebow9tKul4/yk3SpBNnJ0B9z+QTMRgEg46
	3uXAPIUDQ5bDQO7DdKz0vcnS412e9jC7pvYjdqytX1C30OEtwFSa6lMgCup+E4jC3bhtdJ
	RL11lJeiiI7lE7egRAHmZ1waF70jpus=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=JmOcZEDZ;
	spf=pass (imf26.hostedemail.com: domain of roman.gushchin@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=roman.gushchin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766625433;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sX9PtPc4xL/CYh2SYTyc/emBz8y2Tnv1KscJeiPt0Gs=;
	b=ZCQTHA0Ih2YtRxjuFXd5FFfEKHZsaCwwefygbPrR4ar1NQVRU5lqalvfs3cAjH7PyQxQc0
	7ZjJtRKQmBzEw9HIxrGHmr35xV0egr9i7Y2/o5XHVhKklfiL0bQ5Va3X1auc4jVgDf4V1+
	OJLV/25dbb73OD1ldXG2DkYNIQB4a4o=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1766625429;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sX9PtPc4xL/CYh2SYTyc/emBz8y2Tnv1KscJeiPt0Gs=;
	b=JmOcZEDZ8YezgFbsYJC+3/mj2M4nKIJInN27YuvCQmUB5YpCV5Z7vmUMNjxLTopf++M0oC
	0wtGPuKuVfFSdZNoB+y+iRezqHFw2MJ4Kz82lH4GJ1/SuuXcLsFj4YrIOTrRY6sKEzyKqN
	y+ZnCtw4Mvo6TPd+86At27TI8iUn2lA=
From: Roman Gushchin <roman.gushchin@linux.dev>
To: Yafang Shao <laoar.shao@gmail.com>
Cc: bpf@vger.kernel.org,  linux-mm@kvack.org,  linux-kernel@vger.kernel.org,
  JP Kobryn <inwardvessel@gmail.com>,  Alexei Starovoitov <ast@kernel.org>,
  Daniel Borkmann <daniel@iogearbox.net>,  Shakeel Butt
 <shakeel.butt@linux.dev>,  Michal Hocko <mhocko@kernel.org>,  Johannes
 Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH bpf-next v4 0/6] mm: bpf kfuncs to access memcg data
In-Reply-To: <CALOAHbAQQ59mSmh8aO47jnDjOu9S+FESxKw+YUp9g2Q2qvqedA@mail.gmail.com>
	(Yafang Shao's message of "Wed, 24 Dec 2025 11:01:18 +0800")
References: <20251223044156.208250-1-roman.gushchin@linux.dev>
	<CALOAHbAQQ59mSmh8aO47jnDjOu9S+FESxKw+YUp9g2Q2qvqedA@mail.gmail.com>
Date: Wed, 24 Dec 2025 17:16:53 -0800
Message-ID: <87cy439x8a.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 62317140008
X-Rspamd-Server: rspam04
X-Stat-Signature: dg9d1674nipgbzkfxzg6e3xjqtrob7nn
X-HE-Tag: 1766625431-673031
X-HE-Meta: U2FsdGVkX19/CN0GSHR00ZVwngsLDT8gbV+GGlFi2liI+uwQ5rPqQ0s7FD9WetP9JOQLc7dJRmGeIWCM00MwuvIfsautEMqEr/HEOsC/GMNvdMBPH2Aqfz4ydgnoM+KtuEVRqPDJyyOYLmZAMg+FDgC/QrmGNWVtndV3EhBpp0w7vsV9BTTOGx658XYk9R5m5Z5Y75i1PC2POAwF3bBuT6yQRMm+yl6oLsHC4unOL5hDQY+HImL3xKLV+Gx2k3Pw4N1fSoVAhSbWWnzO7NCZZUZOu+ELE3yhNBn/Ae9jUQ2NHp+LCzj9EXdS1PkSWpR/4irwS/Yr+FJ/+gmD2gKrgxgKcS7CEEIC1KW3zuNTs+key7a2JNgb82WsLczl5d5QBkNDCGqkBLTrpYPHlOSuCEGLxdM0P8A0bS52i3zKtjrW5SkHvAhN8lldlp4d7mcsjPtbeaL5aUjXwI/VFssQsjNrqcpSV+96+jewuxTnIqZ+OPjzBuFjUX8jb7WCBRfgzd1nW3EV99jbF/RPoTmaFacBPbJQSv8L63LLDD1OxX7aOxjjSnTVDyqPEOgVi5gwe30+3jDoX8o+VGrk7JCchkoQwTG9AsWgO5C0bgKX5dQtji1K8kvUIvzv/q+eK9VKnvnD4XW5OPftY262T+FaUN9U/y18SzH6j4BDFxV134N+VgLQlzUr8DSLOoXWFLw59+QJdXQsEUiIWhzga2KnZNrxi+1Fye7KyvoWcXaEZ9QqUhf1sZmKZDssfJqr6ZlfXr4RUPTzrtKu7+Ecqg6ksY0jMS+hWsCFa77UySKw2YyoOxeUFLUhvnprP579Xga1Y6vo6ltqQNG7QvJxthx7ShUjy74RbogDW1HzHPYurqGZqNQK3L/ZTmOp4LabJ5HapNNk84MpLG+H56yHRL4hcyzWJtaQsOB70ss4oJ1lhy3b8SyHT4TJRxqX01Y9ThPO3qrHPsf8i8x68Hehqx5
 6TWZdHxu
 J79EKBIzJE220EzkrJ7bzk2lnyqLMS1nKZZX7lZxzMnrLsRy5cUBJb/sbyoRH1nPLQEmFYZ/IigCXjguTA4B8kUhPc6eN7uEFKQsDMjOdRl0irMxbF5kZYYfUKeJwASbViDPWtl+96AXh9OCWBgFP58Phf5dJGzIwatOm2RS4vwxnRuXjd6KU4dk20TIZsg8zUbaysJAXUzBz3JugiwRx9+N0Tg/OuHh7ei92hfHCbvJEeh9b8CtcyQYoMXD5Wx5UCzeEXXhTSP8ar569EriKJwngw8FAKFqyATR+Lv31o6Lgif1ZrQhpDSG6HiPMOyFAnixSsG8v8yrGO2w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Yafang Shao <laoar.shao@gmail.com> writes:

> On Tue, Dec 23, 2025 at 12:43=E2=80=AFPM Roman Gushchin
> <roman.gushchin@linux.dev> wrote:
>>
>> Introduce kfuncs to simplify the access to the memcg data.
>> These kfuncs can be used to accelerate monitoring use cases and
>> for implementing custom OOM policies once BPF OOM is landed.
>>
>> This patchset was separated out from the BPF OOM patchset to simplify
>> the logistics and accelerate the landing of the part which is useful
>> by itself. No functional changes since BPF OOM v2.
>
> Hello Roman,
>
> Thanks for driving the BPF-MM upstreaming work=E2=80=94this is great prog=
ress.
>
> Would it be possible to upstream the bpf_st_ops and cgroups patch as a
> standalone series as well? [0]

Hello Yafang,

this is in my plan for next few weeks: I'll probably try to upstream
it altogether with bpfoom, but if there will be any delays with bpfoom,
we can split the patchset further.

Thanks!

