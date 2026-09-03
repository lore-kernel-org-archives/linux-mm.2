Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A6DBBC624A4
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 12:44:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CBF56B00A5; Thu,  3 Sep 2026 08:44:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 87D2D6B00A7; Thu,  3 Sep 2026 08:44:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7937E6B00A9; Thu,  3 Sep 2026 08:44:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4BBA06B00A5
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 08:44:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B9D1B14051B
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:44:17 +0000 (UTC)
X-FDA: 85172418954.14.1E50F8B
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf17.hostedemail.com (Postfix) with ESMTP id D633840008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 12:44:15 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YfVkxm7z;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788439455;
	b=2tZ9RGxap5OpowgATB0lofWbuhkQjSaZfT+0DCYKsr61KteZVW9dmr79SqJFyaBv5MlYqg
	pyKH/7kgM7npt8nCf4VzXN7hPAiIz99H7S1ERFWvIABlfL6OP/yX+6XxhtUVLxzkUF0YHx
	w+DNS1KjEXE4IO757xQbFg54sEZFBnc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788439455;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=v1JpLmeHcDYci9TjzZaOlT2Qs79rEF11KvKmH8LlIEc=;
	b=ptisIiSJIj91BMuGlrMiXJq111RusxGTHY/blesrNgRktmZEfLfPCsrvD8+OHXPzkaN6a2
	5smQtn0UmV9gs21pe3W8gN1QpP8knaorYg0+tYBlmGANO7DAWgYCy2EwSlxLXhumNPvMAr
	sfE3jArVU3QIDPBchWR0e5I7QFXiXII=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YfVkxm7z;
	spf=pass (imf17.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-39266382df6so2100025a91.3
        for <linux-mm@kvack.org>; Thu, 03 Sep 2026 05:44:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788439454; x=1789044254; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=v1JpLmeHcDYci9TjzZaOlT2Qs79rEF11KvKmH8LlIEc=;
        b=YfVkxm7zWL4DRFWO20cbdn3n6gUjpoAbQdS/d5IxkI9h+5YDjXgNue/75BibixCDzo
         jbcnyUgnKjl/SnzYlaQhp7qVhDzjgXjCeNk7JGCwpYOtjFzwS3boAgjEsWxoNhocMzpS
         +YGR63vXRTbhWldzutKyz1FV8EsOjdHjBfyt2LdYo4k0UOqpWhVIOVDfzAMorAEQzEr3
         13aJULIokDezLANC9Rn4s02U57LTPyn6563kNDWl48UOUx0/NHJJQL4UMzXPTxzkxWiX
         2N+WDfrfcbHm3Urd1RM6uBFkXrV/DCf0NcJLkXbI1Yx8I50hX+SjaAGAo6AtVWfXI/bc
         w9CA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788439454; x=1789044254;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=v1JpLmeHcDYci9TjzZaOlT2Qs79rEF11KvKmH8LlIEc=;
        b=eNITRZ3jrjdnZWRLo4IV7lbbDGuAZpXB0jVgh9/ldP7hoXSqUL76itM7/2Q5xhPSio
         OCYadCkwmNTdmRBM8clGLmueuPtIxAkVR7mAQcT8WFZNpVGoXLsIjMgxTkVRa3QJd0lt
         G/P3rfXY/2ZkjI9n6vbMs7Rb0G58ltQX/L32Yxeh1nlvkdW1gC5ghdqZFEogkoF8WQsc
         BALHga9GGItf24hzWg86a/0wkVaJDZSWy6CZC/5V3NbvyBo3M51lA7tT9aIlqb6KpCTn
         pzUQXNndfU+eKtl9i43rC4vmaKD+x1CpU47Fgunxo2frySFMybf7SH2IDB4tu5eNrkMr
         E2Xg==
X-Forwarded-Encrypted: i=1; AKwUvBycF1WpQTS4w5eAddaDdyrxp62ei+Lr18JgsQKnHJGKjdnKEOSTmNU2JAhaXaY8peOU1v+uBDgL4A==@kvack.org
X-Gm-Message-State: AFuF++lmqNdWGErP3TUguPFxqG5YZ/D0J/O/ozd8lhT77GnUqM0+Ap1H
	v/moKznV4Z3yyAqyA60QRHu5az1ttqEnAOFFMdHQur51l1BFq7qnRhtGi+yEDg==
X-Gm-Gg: AYBFou0PJS9MjxRyuL6wWFH6xKV9b/ao3BxCOJ/SPaBDWbl0Qv0rctJ8J8hf0PhLir8
	mOpr+EsgO/uY0LB+4rjZ4r/p+gxswLpXkupU1xH4B/Uf1eblL/ZVsR+ioppfScF9TDSTGZI347E
	ZbSghqw73dk1rbuUEq6keSW8NNVTcs7KQ2uJDKVnWbCbynOKHtULpHbXDxd0QkYGr6Bx61H5xaH
	yRa1T+l30Cz8QrotmmYyuwP5COLeUc+HP50hsjFUSMls2BlzD8hZdn/BmAAe/DytDbC523ZgBXn
	fOYR6B+zSrWRSF1Di0FU9lGDpFKGlvFcibQQD4HmWyVO8NjQUoLOS/bAq5jBvNx0n7m8aLUzak/
	MsbKEHgy8Idye3qExSBbtxOoXnmpRM0PA5Yc2ZJXTPh373gy1JQ7Hx+GIuKu4RUx+vsj41LTIZ3
	sEV3Uk6UkHekHRZVPJ3+MOuJuKt6zgI6U3dut0fvFm2R8BrrauHzV9LTqQ7tnRwTG11xXEn3daO
	N119/oj6WAxzlrn
X-Received: by 2002:a17:90b:264e:b0:398:dcf6:d40e with SMTP id 98e67ed59e1d1-39aee0c16cdmr19784168a91.17.1788439454461;
        Thu, 03 Sep 2026 05:44:14 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39b08bcc060sm6268339a91.3.2026.09.03.05.44.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 03 Sep 2026 05:44:14 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Thu,  3 Sep 2026 20:41:48 +0800
Message-ID: <20260903124422.5340-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260903003351.91088-1-sj@kernel.org>
References: <20260903003351.91088-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D633840008
X-Stat-Signature: gh65f9zk6aer7zpaprk9otxxkd357dx5
X-HE-Tag: 1788439455-245748
X-HE-Meta: U2FsdGVkX19l0MHBMDDRyT81PN6qdzmNCJ/jfOPoxh3oVokWpSGFVD203V7xN4nGW5EkHqr5Rex2tZLh06JDN0lcWTjhL9O9wVOAQ+OV/NtzhOGvmWBdyi0fmWkg6jRQK2gcjxhua5X8rbGP7WSJ+WqBmtMhCS1zUtmnvqvVMmBZqA3qRmHOUyZ3gu7evpluJaOIr3KurCa+XGCdpYjYQq11e5SxZ1f2oCmJsEav9fWFrF0v2BYLqTb/50xhaxjPsKVtasBysXzzlT9G5HMPwZzfvOGx4e/JprByuo0c3YVFOeeIvIJKLD6Mue1QfpQWwZwXR7f8pwaHAvAxETNW9iBNQV66R81V3Yx4CM2MitUARZy5LCOwZLRHNHw6fkgECzJ9qYIU8pbMdoPSYHL3LgevGWHN3mybFzvyg/HcX3ifF/90PlNGgLR35uBGLob7YsXuQpe08/3eIdGKEDWX4/0hgoodByEkFuOfSunv2o7UjHe3DFbVYVOV60AV9hsfPMyiIn0PbJHraTLqvvKgxA6zQLuiGHvj8vE5WYtyCanobbGg9PrCiFYOPtRbGeq5zIBmbZ2Wj4c5h+koV46HSrw3woqVdGq6794vA1Ir2Xma1Nxlsd47GOCOVLiMsz5XdfYBz8NAR/aG65vkxbwgBPgXIo9DGuxhgSvcVMC/qmaoqn8PlxwOVBB/E5MBQ4gYAPSOZH+bnPOrLv6oEBBuFQ4oBR/+fxnzgYsuV6JR1HWkfKptcV7EDJJNRloWBVi1ncJPLkXsJoV4uTvm7LBWdG6lSYx5WI+sY0mPquwQXsUA1QFXyPnx5R6ZQZOnnJ/r6j47Q+ZoiEjPNtfargpcwL77YQLuPoeDc8JD7Tc5g/2OqlU3jz1suM7YhOy+M9n45NKfd8Ngnlmc3HppfeX1svFGCzJhTvERybh2bBinof5LdJQOecPY58vi1KlfGDX7aBRHQOQSxbO9JMvgwFq
 7uXf5Zu3
 2FAWoqqOxuCBdsZ0Tc8Jt4Gzseuy8l4TTbtsKBqOx7GXubEWlP0g8S4XxMFekZscUP16M5MHSyqOFsv4J+REh+p0ZpEaCZx+y/OzO1ep/AN6kVC14zLJ2Tkq7td0BZI/JuyZqkdFMJjooTdwYKe/WtAysBLZNj4nfePyeiCsrOt2eyrka356GIkXK953l4/MSY5aCvQreXk4wGCFu3/PbBEH/JCQQocDvjt/giNNopVd9y6GRAZNS9ySlJXPtR+3/pdAvetSn9JQsjJMx0W20aX+RKJBcwCaZtx72ceYoETLaw/izKpNU7Q/o3j6lRhdhDzVOHJi2wyWB+aFSuV8OGTtte5+rsDCsybxVMq5QAF7dIgJ6CV1a3fvtCJE6WRbhbzStpNCDU23dpaOHMYyIANcSL56bAf0LcS322hOPhlWm9ZtHrKmXcxU66YFVEzYhDVLDycU0tZtDP0cj9mqAjDwH4WutLnC1t+Y17Ca6F42RYOY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 17:33:50 -0700 SJ Park <sj@kernel.org> wrote:

> On Thu,  3 Sep 2026 06:31:38 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Wed, 02 Sep 2026 07:48:03 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Wed,  2 Sep 2026 22:22:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > On Wed, 02 Sep 2026 07:10:00 -0700 SJ Park <sj@kernel.org> wrote:
> > > > 
> > > > > On Wed,  2 Sep 2026 16:44:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > > > 
> > > > > > When setting goal_tuner to 'temporal', if the goal is achieved,
> > > > > > quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> > > > > > will always return true, even if no regions have been tried to apply at
> > > > > > all.  This causes qt_exceeds to increase unexpectedly.
> > > > > 
> > > > > To me, this looks logically correct.  Could this cause any user issue?
> > > > 
> > > > Yes, I think this might cause unnecessary confusion for users,
> > > 
> > > If it is _might_ kind thing, please ask questions first, or add RFC tag at
> > > least.
> > > 
> > > > at least
> > > > it did for me.
> > > 
> > > If it confused you, definitely we need to fix it.  But if it is just confusing,
> > > let's try to clarify by adding documentation, rather than changing existing
> > > behaviors.
> > 
> > I agree that we should avoid unnecessary code changes if the issue is
> > merely a matter of confusion.
> > 
> > However, I believe a code change is necessary in this specific case,
> > rather than just adding documentation, for the following reasons:
> > 
> > First, this distorts the semantics of qt_exceeds.  It is a statistic
> > meant to track actual quota full/overflows.  Incrementing qt_exceeds
> > when the quota is completely unused (because the temporal goal is
> > already met) misleads users and could break user-space monitoring tools
> > or scripts that rely on this metric's accuracy.
> 
> As I mentioned in the previous comment, this doesn't look wrong to me.  I
> understand some people could think differently.  That's why I think this is a
> matter of clarification, not a bug to fix.
> 
> > 
> > Second, considering its original behavior when it was first introduced,
> > the recent changes [2] have inadvertently altered this behavior.
> > 
> > When qt_exceeds was first introduced [1], the conditional check was:
> > 
> >     if (quota->esz && quota->charged_sz >= quota->esz)
> >             s->stat.qt_exceeds++;
> > 
> > Later, to handle cases where 'remaining quota < min_region_sz',
> > damos_quota_is_full() was added [2].  When this function was added,
> > quota->esz was replaced with !damos_quota_is_set(quota).
> 
> I don't find what's wrong with this.
> 
> > 
> >     static bool damos_quota_is_full(struct damos_quota *quota,
> >             unsigned long min_region_sz)
> >     {
> >         if (!damos_quota_is_set(quota))
> >             return false;
> >         if (quota->charged_sz >= quota->esz)
> >             return true;
> >         /*
> >          * DAMOS action is applied per region, so <min_region_sz remaining
> >          * quota means the quota is effectively full.
> >          */
> >         return quota->esz - quota->charged_sz < min_region_sz;
> >     }
> > 
> > With the introduction of DAMOS_QUOTA_GOAL_TUNER_TEMPORAL [3], quota->
> > esz == 0 carries two meanings: "unlimited quota" and "should not
> > be applied".
> 
> I don't find how you think this way.
> 
> > This overlap causes the damos_quota_is_full() check to
> > return true incorrectly in the temporal goal scenario, leading to the
> > false positive in the statistic.
> 
> That still sounds like just a matter of different interpretations.  Let me know
> if I'm missing something.

Thank you for keeping this discussion going!

First, I would like to clarify my intention to avoid any
misunderstanding.  My actual goal is to fix the semantic of the
qt_exceeds statistic, rather than necessarily changing the underlying
logic of damos_quota_is_full().

Currently, there is an issue with how qt_exceeds is incremented.  When
the quota is set very small, qt_exceeds increases frequently.  This
produces a statistical trend that looks almost identical to the
continuous increments caused by the Temporal Goal being achieved.

The original intent of introducing qt_exceeds is to let users easily
notice if the quota is too small.

Commit Messages [1]:

    mm/damon/schemes: account how many times quota limit has exceeded

    If the time/space quotas of a given DAMON-based operation scheme is too
    small, the scheme could show unexpectedly slow progress.  However, there
    is no good way to notice the case in runtime.  This commit extends the
    DAMOS stat to provide how many times the quota limits exceeded so that
    the users can easily notice the case and tune the scheme.

However, under the current behavior, users are forced to manually ignore
or filter out the qt_exceeds increments that occur after the Temporal
Goal is achieved.  This adds an unnecessary burden to the users and
contradicts the core goal of making it "easy" for them to tune the
scheme.

If we agree that this adds unnecessary burden, perhaps we could explore
a minimal fix at the point where qt_exceeds is incremented, to skip the
count when the Temporal Goal is already achieved, without touching
damos_quota_is_full().

Please let me know if I'm misunderstanding anything or missing some
context!

[...]

> > [1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
> >     (Fri Jan 14 14:10:202022 -0800)
> > [2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
> >     (Mon Apr 27 18:33:50 2026 -0700)
> > [3] af738a6a00c1f ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
> >     (Mon Mar 9 18:05:19 2026 -0700)

Best regards,
Rui Yan

