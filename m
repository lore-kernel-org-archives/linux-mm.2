Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7F3C9C4451B
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 639C66B0119; Fri, 17 Jul 2026 21:22:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E9BE6B011B; Fri, 17 Jul 2026 21:22:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4B1236B011C; Fri, 17 Jul 2026 21:22:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1F2BE6B0119
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:22:36 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A33C51C03A4
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:22:35 +0000 (UTC)
X-FDA: 85000147470.24.9C5680C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CA92A16000C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:22:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IblG8h8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784337753;
	b=Bffqcz68gUcReaaTJWxZYzIqTP/XrKEJPyVqUGF9ybpsrJqWiuBjjf8NEQdQry7kVh54hV
	EIgtLEAZLj97MHzGqxDaRUaCdx6BcaNFsyM2TJbFCi2WCU1I6bgj0fKgCilpz2q4eFyFda
	opcH9FzOx8PiOKL4ex2mkixKRtYA/mg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IblG8h8q;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784337753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1sLoppV8+TdV+Vhsdxce2LoaHXJJ1H5bqgRw/kxgZF0=;
	b=61H2BA98Td0zqxj/+xVEtnmKySrhedu6Ina9C5cSkEP/nHzjITxm2lw3XdugPluD/wkNZD
	9K2DWBqlViYs8HP1CJ+8E8kwyNoXduNTsLwc3GLwymvyXzT7W56PasMroAYqM1QHwufaA+
	Hp1bPu8rHD6FSv3Pjl8bJMOo/fbH+Vs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F0FC045166
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:22:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C54821F01559
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:22:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784337752;
	bh=1sLoppV8+TdV+Vhsdxce2LoaHXJJ1H5bqgRw/kxgZF0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IblG8h8qor2f0ewW9cZsNWUp9KWaVF1ciHPOez+379N0xGhaazRCkYuHol4rzeGa7
	 T79d3YqgahD2LHpft0zSHQ8ZTdRkggvcJfW2y6YV9o9FIKKepz1B6EpjD50xn1LUj0
	 B8CjDgLUZA3xjBnCffI2XBmMGxCxfSgLVsnSIcVALIpCwqIb9ejjccoDDPRfDcS0wu
	 VbUSb9kGgF9olEYNcNxKx/suPI7B9Lnzd6bvgkTQCpl1vbd0gcUBqTJNkEslZcvZv2
	 9lKAWvobEcHhSBBbWBDnqlfZOkRM/AFk1vpXUG+bARG9OR1YngiaEL3dYmywfqeNq9
	 QdbkK3SSewbig==
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c15cf78d1a2so676991166b.1
        for <linux-mm@kvack.org>; Fri, 17 Jul 2026 18:22:32 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrmpVASQdrEDNGN+lvw+bVf1/XavJi1cR82xf2+qGVa//ssgelvOYbwmHw+673Pf9jqQU+DV5cHtA==@kvack.org
X-Gm-Message-State: AOJu0YxobUaqKAfPH9LLLRXlRhSeBFwu94PjyojT0r1c6IbCqcH2urjm
	z0ta+lzhOp8sLiSE8aRjVOp3ufYryNEQhvEz4stul4Dvi7wssgZl6G15GMwyM9Pu+4Epbb4WZcs
	+BiPHmzU1BrMS/h7gY2NOxFOrak7Scrc=
X-Received: by 2002:a17:907:8e0f:b0:c19:45e2:b3c2 with SMTP id
 a640c23a62f3a-c1945e2b59fmr152919866b.10.1784337751563; Fri, 17 Jul 2026
 18:22:31 -0700 (PDT)
MIME-Version: 1.0
References: <20260717085151.22822-1-jiahao.kernel@gmail.com> <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
In-Reply-To: <20260717181839.c94d0335ccef0084707d3d85@linux-foundation.org>
From: Yosry Ahmed <yosry@kernel.org>
Date: Fri, 17 Jul 2026 18:22:20 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMB5ujLvaE=Vqo-TMBmuNEsjxKbhQZXdvxH2BokK=s25w@mail.gmail.com>
X-Gm-Features: AUfX_mwCz7mSEnlf0zMh4BWAJigaOLZBXo3xjsSIEftA2Oqygiglol4aExmseqc
Message-ID: <CAO9r8zMB5ujLvaE=Vqo-TMBmuNEsjxKbhQZXdvxH2BokK=s25w@mail.gmail.com>
Subject: Re: [PATCH v2 0/2] mm/zswap: Fixes and improves the zswap global shrinker
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hao Jia <jiahao.kernel@gmail.com>, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: CA92A16000C
X-Rspam-User: 
X-Stat-Signature: azaa5e783b3jed5td87zd5yciawtd13t
X-Rspamd-Server: rspam03
X-HE-Tag: 1784337753-353353
X-HE-Meta: U2FsdGVkX1/aKfP4dVNfUcVGekX9Rlqgz6oPxn4ZITZzGAZc2iMNGvBcV2mRoJ9cLkCrPiK0a3tChxCqNEM7f8HHXFNluGCih4D8pc29OHSoE5/cqGpWazYusdkj2/hDapDI2EJKAKlXcMI1060t+NnGqauxbk5xDOc58HThq+x9jnKWRqP51gzPBMFVDawltXRUjura+TABbydAulngX6/+xgS/ioHM4b7UoJNi+nltQDvaZ5K8L+ky/SuHvACTL5Uwb+Ccjp7XgsANptuU/CysCq1FfhsBLFXI/sg3L6wh2KAiEi2Q8XO5Xl6aynAvlUtPQ+N93dTKnBHz0+KQCaEq90i06vtGYuVI560ustMRUfOxcH4XJQpJCP23jeunK0gPUI5DQ25bIX4L7vD9QzdejJuHRSozZBv5bUw6bnkN9ietbhOZSmgxL5u0MRujRRLqLLny0Vfl8PiKjLq2V8mRWlziwJus1tN8TN5hVecyUsDupd2cvbMiEHu8wTI83+DNLy8FqN0maQ2fv/G8VqLz3qXnVW27b6mEBvdKHptcaPinaPdk5/+b0HNMR44ukPwDcs9mYCiR5nqZsiCI7khw0wegZWGRzBN0f5xloU8PK3TTNIwlLcYzAa1skXSYXPbZKa2yIMkGgup4APT+1Hdloz7EF1Sq+ZSV+Izrnf4IhcwsiDp1pTnSD8z4y9F9a+TWE4CuqYOhyo6ezaBXqyZYHJpToHWSAAcn3gDIVNRjs3qG6YE7ldO8BYX7/xwUFMFkD57ALeLjCcnMxtGZy6iZzYewzJtPhbrqeglzOKvT+eIlKiGsZTuaHZjg0bqVWUBfSBje29dgarjElb3SlDlo8YqNWaKzuJcfkzXzwtXrqG10SmekKSTywv3Tkm2WH+RQ398zS48FNFPQfTsx70J4Ru9e6XGvP6J8Taq6i8UyH6eUnDUCVAh76czBegxf+Ss+tOAzOzPTIsJTApH
 JWirdB17
 nVB/2J9Jp1QuKk7lC8Td3kMDwb4NXpV2Tnklx9w48Mj3pe94AHfx4ysjqxc+C2l8blvqTzWX1mBpr9YY67B7UfX5q75UI75DOJzzM93c61iFWBg3uQ/UdVYfob2CBntRJSkH0bUanBIs3TRtWfR5VZbrT+go40Q+B+5fwp5fzVm5X6ECPm0QqhlRvIwmg2zA0btORhPlOa8adJl+8jBNDWY0sTV8S89sH+Zn2SQNXzaWeD2OQN+uCnX2o8hbEd8VOEu4zmCKqrKUauohsLEHi9G432vEKl4y8/kjSODRa6xhlL6hF7AQybe6t3yfl61XP1XWFanvaTBvkvC6Yy2ICiA7GK2xcCVggT5lR3d0SxmF8+YYSCPOUT7e929QJlIc/S8d0498wal1EqkOOtb68z5Ydcv6tbwT4V552knFnVbH5InAHhBj7eYINApNwY7ch6TxS+og2J5mj3Z3tku9pFJCqNGb6007dKSV1cb6Q3XpR+qni1/wIQ0sMUQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 6:18=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 17 Jul 2026 16:51:49 +0800 Hao Jia <jiahao.kernel@gmail.com> wrot=
e:
>
> > This series fixes and improves the zswap global shrinker (shrink_worker=
()):
> > Patch 1: Fix missing global shrinker when memory cgroup is disabled.
> > Patch 2: Extend shrink_memcg() to support batch writeback and update it=
s
> >          return value semantics, thereby improving the writeback effici=
ency
> >          in the shrink_worker() path.
>
> Thanks.
>
> [1/2] is a cc:stable fix so it isn't really appropriate to combine this
> with [2/2] which doesn't fix any bugs.  Because the two patches may
> take different paths into mainline, with different timings.  But that's
> OK, I can deal with the splitup if needed.
>
> The [1/2] changelog lacks a description of how the flaw impacts users.
> Please describe this fully and maintain that info within the
> changelogging.  This info helps -stable maintainers and others
> understand why we're proposing a backport and helps myself and others
> with timing decisions.
>
> Finally, AI review might have found an issue:
>         https://sashiko.dev/#/patchset/20260717085151.22822-1-jiahao.kern=
el@gmail.com

We discussed this one in the previous version, it's a theoretical
scenario that can already happen today.

