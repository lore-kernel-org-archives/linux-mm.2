Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ACB71C982D7
	for <linux-mm@archiver.kernel.org>; Sat, 19 Sep 2026 21:22:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F9C56B0088; Sat, 19 Sep 2026 17:22:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4AB726B008A; Sat, 19 Sep 2026 17:22:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 39FD86B008C; Sat, 19 Sep 2026 17:22:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EF3DA6B0088
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 17:22:15 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 22EAA8029A
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:22:15 +0000 (UTC)
X-FDA: 85231785030.16.B1AF2CE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf31.hostedemail.com (Postfix) with ESMTP id 2264120005
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:22:12 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvxvYiL3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dvxvYiL3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf31.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789852933;
	b=YaC5GWJwcNXg+K/0oc4VdDZhBf8ccyfn+28fh8/5BKnxjqzRrdWaan5Buha9vAR3IoiiUG
	PSQMjr/FfFUoV/CnvEKIG+pIq/JgakJg9Cd7x7PT1q6pNjTfDzco6dgNM4QMMnsI2s1l02
	X2WMO8mbiOGBuhWvxEOBad3PYPiFIBo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789852933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KE5aURhmFeQqffPNpopHGYL3hq2scKvdY2jkmvGLyo=;
	b=yp2wNQ8yuH2nU/YdYrMRWnhLvwudmH6gkZBqpVlfgYHUcMN6gNOCHKrUrqR6iVK3wWGUX8
	/ikdw+AocxgIG9sqRcE//DmhWia2UhDuO7RSw46MPbOLFs668DEFGGrOs3ERpq/4s2dEtH
	TeY62Qdk4gsHUcm6poRJGYxVwKUyx/E=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8E075447B7
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:22:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048B1F008A0
	for <linux-mm@kvack.org>; Sat, 19 Sep 2026 21:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789852931;
	bh=9KE5aURhmFeQqffPNpopHGYL3hq2scKvdY2jkmvGLyo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=dvxvYiL3h4r8ovEqY5Mh4f6NhdN7+bguAVTX4+urpf3GoZamkP+ErBEtKFU4bHQmN
	 H68Wtp6494+yz30jy/m5d/RagA2pKfWwJkhqA7emGBXMdCN2ZrErMQhbcwngaZpAE5
	 Q8vwzHr8pmXA7IIVBZXC/U05n4OxzxVbxq/4AEBYKJcGv21tMp4NC7VWPsAkM2DZQ4
	 nRU+TKvcRokByfRcQddCmKVnGVAxA2MPHZnugbTe2PQjpV/u1CNfDmFUJfe8stKdW+
	 Dewl9VykVXDI6pXLrW5sA7fWZVAW7SMzPc22GVHslUWFFbF0bCks4NqF+9nAStVy18
	 qmCnUcgEbkYhw==
Received: by mail-yx2-f13.google.com with SMTP id 956f58d0204a3-66e4ab201f9so1553251d50.0
        for <linux-mm@kvack.org>; Sat, 19 Sep 2026 14:22:11 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzm3noZ2y9tEISXX38abR0EAINA0g4x3SYzyR8AnogJ7zbcmfC9eACquSCwqzlj3dMo9Rjon7Nxaw==@kvack.org
X-Gm-Message-State: AFuF++n1vovzQ24Sc0Ussm/Lp9ZZiXv7MbwQw3r8in83SxIkM7116p3u
	GbmS3BaC0WojjQGziekVeAnLVFKrhO6zXBUyq7BoFVKGlYRG+Cb5DqT7TJWmki5MqPh2LNpH/TS
	5IBv30g1udHux09mIfwZJZ6Rs1sfIrkIxGBDeZQZixA==
X-Received: by 2002:a05:690e:4888:10b0:66f:c1bc:87ef with SMTP id
 956f58d0204a3-6717fde9f96mr1259997d50.72.1789852930667; Sat, 19 Sep 2026
 14:22:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora> <aqLZ5TVDAqEbIeMN@linux.dev> <aqP81aqNbwAbs2P0@fedora>
 <aqQrPLPXHXiuKup0@linux.dev> <aqjcFb6MFNiA6n4V@fedora> <aqjpYHbZ14A8xRtK@fedora>
 <CACePvbUwTxcMPVK_1GAz5gPDdh0BV9JZSnKXaUFLqDHBzBmPQg@mail.gmail.com> <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
In-Reply-To: <7ee199ddee81bf8026688def82f78ad9db09be9e.camel@surriel.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 19 Sep 2026 11:21:59 -1000
X-Gmail-Original-Message-ID: <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
X-Gm-Features: AcwNN1V3fN8BiarqwCTVlFEX0OtGz4WToCWoAzNrsMF1T-3gjKneuvYzb3JnUKQ
Message-ID: <CACePvbVA+DnDJprMx3qOrGb98y1ORQ-LfaENy_Btfx3uW=E4eQ@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Rik van Riel <riel@surriel.com>
Cc: Baoquan He <baoquan.he@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Nhat Pham <nphamcs@gmail.com>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Barry Song <baohua@kernel.org>, 
	YoungJun Park <youngjun.park@lge.com>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Kairui Song <ryncsn@gmail.com>, Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2264120005
X-Stat-Signature: zabu6jc84jqjhhq7cqxjoeiozoxd9zis
X-Rspamd-Server: rspam01
X-HE-Tag: 1789852932-586578
X-HE-Meta: U2FsdGVkX19CeCs2aHflmTSK89v5666P1QFJJ8nyGV1g+gU8VgqEhEjyWZVaD/sieIkAuE3CmCgpDRk4gOUjwA+a/lqqtwOZUgwndAxnIyVU5uraUJGLh3xtIvaXYBAXc/lccjDLU8QY9RZJOXGquRbIniAQbSs4G8LM+DCFqMeyUe4J8VnTOnc99C53BZ/6tcFxSjDheRqJ/CSdkeXom9N7Ie7TmCSLTAucFpq+TJmSLw8ILRU7zYZvukY/tnaWTlh8PMxG4Unmy5caR307YmUY8HaQAA1ptMYn58S4qpql5OWRFRlGbbZJ3l8OLvDy0WzWaIuwZQyzV6iS/y1l0ZsnCXpBjuYNiPM+bn+Ov28/ehHgKLEGM9JOkomKcMVx/9DZCg4FJWKqJt03/I1l9ELey8HsYENLQnbFGVhqoaequGr+XZFTXjzvFPKLsy1uBV7oi5TjMgJaT5XZmn5hWrrtbnl4YGpRCRo3i4dWPo5kHE1n2Ty2qjXTN27DKQmQhkYfxduf+7ehnMVw4sxnPUavO/WtG8vmY0aYUUMxzBFnKX6lT4+yM+4j2YZKOGHHWJgx8SjB751hvwSEcYaOrNySq2s0SQIGCMBMPlFIonJVh3cuEiR8zae63yfVu140FSbakdEPlwclFQy2ppkU4trUSTi0iPCSIYOVlOMWrsaCBhBzoqYV5nGUhhSfJq/Xq2p2gUJWybDcFyHoRh6nt/dzrg6s4Q7gdK8vdvtx1TrEjkTtM2jT86FRWI3W8cY3k5usSddaguX29qtBj92fFyurMmrEXHnDQEYY4d19aHnOSUp2qnpuGNeHgT5FjD5I8HpTi7O3c0KTaYLHIwRCHIpzywJBmTZ8zX6tYsrYWbiCYG0YtmdgTxdxkECCqvJ6Fef1OppVdEtQWF2RKXW0HyAlKcEuaDTuWakn9Ia9/+RRR9AfSMBvXT7pH+/Ml8yEwcYwIrcN0juMOH5Ng5w
 rqbKDTi2
 sUSV38eqWdpWFYRg0h6ZXtt1TsgooHqHz5h1SUv3xXt9IlxsIqmk6kchzLKOwYXGDqU2QQ1iO9XiHvR9YLo3/GI6ejaEatgEJOKn4Jf4c+/yzMQipHHEUIyr/YpOgaanL/dxeEHWviWsu+UOBB7c6buw+tyLH3/Wukxl/3KPyQqzkVOj6NyDc3GqjlPG5JsUezHvz3XnBubV/Up17rcWqUN+Tqs6hIKNaoM/vxhgLnAV1B0AjSafJeuZiBJMCd9r7mq/rcSpPhvI+lXF3HuHGPwispnvTrYjm+9jIz/MkHDl6Gw4aakFEV04blAmgYAdJjwSnrx6kDh3gyd6w/7t4Qb/iaeY96mJnpwrIzoHVPyb/S/tOaNHH6slRkOVRj8WLL3r0L+6L7Iko/mexfYlqmxEQ/6dzA+7waUkgcVMT74QhNX/6yanP77KvaIM50LHKpnloMr5bLcFjgcKsuwWhb8R76Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 19, 2026 at 6:16=E2=80=AFAM Rik van Riel <riel@surriel.com> wro=
te:
>
> On Sat, 2026-09-19 at 01:55 -0500, Chris Li wrote:
> >
> > We don't have to address all issues in one series. I actually advise
> > against lump too many patches into one series.
> >
> There are two things here.
>
> I totally agree that we can merge things piecemeal,
> and not aim for perfection at the start.

Agree.

> However, I believe we do need to take care that
> whatever design we go with is actually able to
> support the end user functionality we want.

Agree. I want to add that we should support new functionality without
sacrificing existing user functionality.

> We have to make sure that the path we pick does
> allow us to very easily add the user visible
> functionality that people need.

Agree.

> We can always swap out technical details behind
> the scenes later, but user interfaces are supposed
> to be stable.

I think we agree on all aspects.

Chris

