Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D4096FC72D0
	for <linux-mm@archiver.kernel.org>; Sun, 22 Mar 2026 17:48:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DA2B86B0005; Sun, 22 Mar 2026 13:48:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D53546B0088; Sun, 22 Mar 2026 13:48:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C6F076B0089; Sun, 22 Mar 2026 13:48:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B3F836B0005
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 13:48:04 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 625151404A0
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:48:04 +0000 (UTC)
X-FDA: 84574432488.08.74FBE6E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id AD1DF180007
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:48:02 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u+Gc/NZd";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774201682;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNEjBuZzvS0W4oSHpuL8RVAynxJbgguo9xRwlJKFTps=;
	b=10rQkzUVsZkk+YD8ztt5KbN+NaK/c1t67gdzgCseNBdDVDnwxQSkRkjuECxDLu0EV2MLm4
	5/UHavRKwwPq/Wkcm0Fx54MoKKnKfQs9s83RsgQSmSU3Dfwghe9pLD7C05lWJzeZKSq0vr
	RBGnMjkzQSW1+kADPIYdj3f3XdK45hY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="u+Gc/NZd";
	spf=pass (imf06.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774201682; a=rsa-sha256;
	cv=none;
	b=zh4mTKDU3DbBohN0NAlkF2DrGwbi5Dxq5ifVqtcQR24y+EPvu6TB8VpaaxfDQVzidC+aId
	ehkOQPpKhfA03tMv/AlbOp2ozjSlwE8Kr44LgZAQf3MsX9aQE8tUxArfOYMtK9gXIWPORv
	npiltEMhX2Pjr9ahJWKvlXfhyuzYiWw=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AF2B6443C4
	for <linux-mm@kvack.org>; Sun, 22 Mar 2026 17:48:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7906DC19424;
	Sun, 22 Mar 2026 17:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774201681;
	bh=zi3o3A260ASJFdf+1Gp2lU6cqFj7MS9SWJuu1snHJdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u+Gc/NZdkBJCF0cxaFYphh8WKAL1S9TP1n6tKc/WY0IXEU2ApipB8DRMs36wMSTux
	 u2WDazdplVo1gqG865TFto3CjqY7YDphPYq6D9zCop+VMaoKSD+7e5miZi98vI1+jJ
	 bU3hkpmEarDbts0j6t5NFaCPD/8c5MwCNIThZOCYM70ltK+JwPv868JzeUZKA+Wgy8
	 xfSvV2Y2iSn1+7cSUVP5N2xFfeJbaU2nUx3klPhIGHddrCvNth2piIyrG6lwaG9u5s
	 u8z91nif8wtU1urGowZM7c7QDOZSlS/67x/Bi8lfillLJBwIPrvUYXmAiVjIs1AgUd
	 CqMICrC1hCOuQ==
From: SeongJae Park <sj@kernel.org>
To: SeongJae Park <sj@kernel.org>
Cc: Shuah Khan <shuah@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: (sashiko review) [RFC PATCH v4 10/10] selftets/damon/sysfs.py: pause DAMON before dumping status
Date: Sun, 22 Mar 2026 10:47:57 -0700
Message-ID: <20260322174757.84332-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260322171534.83470-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: AD1DF180007
X-Rspamd-Server: rspam07
X-Stat-Signature: rqiuxrfwysyum8awopicep6rk37xt9wb
X-Rspam-User: 
X-HE-Tag: 1774201682-621859
X-HE-Meta: U2FsdGVkX18bxGNYwxe94BFE4VbRgq0K8tj0n4sN+gOGe3qEtOR4zQ1pqq4ZMeB3mgsCLVzu5guV5y7umLfzG/7A/xgD4mhaRu+oSIXJ8jZ3ZFOfjMNUoeAnauyWFlqnQP3axM54gaOxl3LNHnxPjfE6j+0Slb3DlPLzAV0yKvGuai9bmShHFgfCPmjH+pDsgZdEVHsbNrtoy6dsfQXhgX4Zl4rzgWniRZmCKfpBiAOx4ypruziB602mtrUKl9VmXoedJyuYBITyleQMJF8Npko3+uUom6xxeJO3DNLgiryZo36UBz0NSC8Bh40ydLK73nnC5MPTeS4WZwxuNQwID/gQx3QnS8NusPOrLKLdF/Tlk7sQQ5eUOljqKsGpPl7yxGCLpxA9OLeuUcJT/22fJ8U80qAudknB0ZW1NwHvcZz7izLslxqt7zntEsa9HdjenFGzTJTMMomwGuH+DCtrHrQXPzFxLWozANnE/nkXBsv+kfLtEt4eOaaLpcInyiHA82fgElBhb1uarDJBU+pKkyiPy6kXA9eb6IJINlLJp5yIedEeSrpzjJfKu1oG9+3LTpK2C9j/1AsJ/qLLfPzm7Qt0sg+bW93FMDCP57j6E+s5TQIVWVGNGOLnw/GKqHYdrGJROaVdlORj1f13MfZhTwant8xdxnYqwh1SIH4ZxcC/aMsiyDO6hfGU4T9429DLId6mKgSIY+oz+LE2aelx/ByGxoY4y8pOmTyC0PhAOdLnG6VS2pJPnfxw5d28lYYLs7T2821YjtbKKTYwmFmueJ6EL1+Tq4JDlISiMRfw9tuAG5/35mZ8/91AIR7FXxFLSvoupshDzt88wCHyh425fM/VBdj5Wx2NG31I6xqb8NV7Dq+FbiRS001B8z+KD1nPuxmIqRHNSotcERk5qo9tyKDikJLkaO8U0ShqdN9/qrZRE8irrfajPSWL2HDCEFfbGC8RzDLWwcmBA8wuxtZ
 0bInyGyd
 zQ7AqSAkGZZFFtbijpuME25MrV2QqF6r0U//S/KW9mj+J86aBwH2YdHAdakVw1i7vqji9uUr5GXwT9PK732zWVOX+IX4V7/dnuajKUjDqeidUHVg2KAYDr/EioLgforFDvIoTVwfzBeq5a0rImeA0JmqZVOsOvVOOvD1UzbadRFFUsVjofPBrZTdgstroIRt6yMfoX7HK8P+8J2Rz/waKkFQ1jkfy9674BTF6Mmy8et3Vl1Erz83SN0bqu4QmrFrYHDj25iEoaYvMkBmxNH22buDznnNuGUr0adN5woZSTku6u2cI8GSg1HzC/tJ7Ygn10QGMONiUJMNYa4mzqY6MJumOlZ8IL170aHOc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 22 Mar 2026 10:15:33 -0700 SeongJae Park <sj@kernel.org> wrote:

> Forwarding Sashiko review for doing discussions via mails.
> 
> # review url: https://sashiko.dev/#/patchset/20260322155728.81434-11-sj@kernel.org
> # start of sashiko.dev inline review
> commit 67adf8e7b8416252faf583e176f0e8424fd4fb95
> Author: SeongJae Park <sj@kernel.org>
> 
> selftets/damon/sysfs.py: pause DAMON before dumping status
> 
> The sysfs.py test commits DAMON parameters, dumps the internal DAMON
> state, and verifies the parameters. This commit pauses DAMON execution
> during the state dumping to avoid races that can result in false test
> results.
> 
> > selftets/damon/sysfs.py: pause DAMON before dumping status
> 
> This isn't a bug, but there's a typo (selftets) in the subject line.

Oops, Sashiko mentioned this in the previous one, but I forgot fixing this.
I will fix this in the next spin.

> 
> > diff --git a/tools/testing/selftests/damon/sysfs.py b/tools/testing/selftests/damon/sysfs.py
> > --- a/tools/testing/selftests/damon/sysfs.py
> > +++ b/tools/testing/selftests/damon/sysfs.py
> [ ... ]
> > @@ -193,18 +193,55 @@ def assert_ctx_committed(ctx, dump):
> >  def assert_ctxs_committed(kdamonds):
> > +    ctxs_paused_for_dump = []
> > +    kdamonds_paused_for_dump = []
> > +    # pause for safe state dumping
> > +    for kd in kdamonds.kdamonds:
> [ ... ]
> > +    # resume contexts paused for safe state dumping
> > +    for ctx in ctxs_paused_for_dump:
> > +        ctx.pause = False
> > +    if kd in kdamonds_paused_for_dump:
> > +        err = kd.commit()
> 
> Is this if statement intended to be a for loop?
> 
> Since kd is just retaining the value from the last iteration of the earlier
> loop, using an if statement here means that if there are multiple kdamonds,
> only the last one might have its state committed. 
> 
> Could this leave other kdamonds un-resumed in the kernel?

Ah, correct...  There is no multiple kdamonds use case, but let's make it
complete.  I will fix this in the next spin, like below.

'''
--- a/tools/testing/selftests/damon/sysfs.py
+++ b/tools/testing/selftests/damon/sysfs.py
@@ -226,7 +226,7 @@ def assert_ctxs_committed(kdamonds):
     # resume contexts paused for safe state dumping
     for ctx in ctxs_paused_for_dump:
         ctx.pause = False
-    if kd in kdamonds_paused_for_dump:
+    for kd in kdamonds_paused_for_dump:
         err = kd.commit()
         if err is not None:
             print('resume fail (%s)' % err)
'''


Thanks,
SJ

[...]

