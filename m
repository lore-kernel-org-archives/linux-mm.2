Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD630CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 20:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B39D16B0088; Tue, 23 Jun 2026 16:20:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B02916B008A; Tue, 23 Jun 2026 16:20:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D99D6B008C; Tue, 23 Jun 2026 16:20:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 70ECB6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 16:20:18 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E88CB1A012F
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:20:17 +0000 (UTC)
X-FDA: 84912294474.14.45F7B24
Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	by imf09.hostedemail.com (Postfix) with ESMTP id F0E03140002
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 20:20:15 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sraFKk5R;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782246016;
	b=2s/1msyIAFUAIaWBUz1XCT/xqt+8aoNHAHIlhaxZzMwCvDA7uW+7IHf6zClR9Co5LxX41t
	9JXwdd0Eu98/AJkoDtz2X8WnnYqNJAoC13PH49H4WDQwsf5pH1oD8DygIszSUpO9griRrv
	OkuWzbAi81sDe0wRIlWO7t+GMUR1qQI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782246016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Dlda4oAsQumV8NATBu2dETgjrgOcL8S9Z7OS1/x6sqE=;
	b=VXQzxRJpLD+T0qTkGoV3TtkczvKMzPkmqWq2N+/WjLE8ZJl/C+Lu2tcuQbUPTZj9V3peZj
	IoWGhr/DwyoKWkQy8M5htifK0s17qer8Krwx1PY+yuzpBSJW528fpNIitqbvSUeOHP+GxL
	7yRzRXXOxcvAN/1lsDHd6dwKITDSegQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=sraFKk5R;
	spf=pass (imf09.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.160.45 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43cce8288c7so187988fac.3
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 13:20:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782246015; x=1782850815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Dlda4oAsQumV8NATBu2dETgjrgOcL8S9Z7OS1/x6sqE=;
        b=sraFKk5RiIn3yBtWvO9aflc7Uaq7/wNPyzaG5usmv+3W1tNT+yhRq0Uapjx+4TVKYI
         bfKHHWuuwOqE6936ufygQdhHaetMG901FX54+LwLaP00uU/gHhz4l51z4qMLuGm3Tb1B
         ZWAu/m6V4vABJP2z41aALjymzY8RsiTbfrwYQh41RKISRBL1CC4WTQVrfGCl014eznwK
         rZI9W/bcP7fIkveGas0doudHfn771KS0XItqb23YBa1Ly6tmicJkdXR/Zp6FJsOq3iqR
         X4w51R+AaBT7E28BIt+wT706PmhqtBFdSIw4HaOYbm3sdDA725fLJ0a/A9eClUWzC/xO
         ZeWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782246015; x=1782850815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Dlda4oAsQumV8NATBu2dETgjrgOcL8S9Z7OS1/x6sqE=;
        b=YJmg0RCGeH6k7WMmVv4C/QAhADKLmDUqNpP/W5ulCnJnU6AdFMDeeS+Tu2RwLhHP9P
         jdlxE3NGsFgZ52dOLx9FJldgfnP7tvEPAmR25Du9DbsRgLqtbiyb7Vsh4fZHNhGe33Xg
         xKuJtulThYsGLdRNxd4aFWIPLCmQYliLm2Cy0cLaW/Q3i0LynRnppCbbLyBPMy9MEy1j
         CWxMXw5Qnw/PeO/shCTj+12rFEdjXf9NskUoZ5DBVFgV/5rjl7342T6ZNeWT21oGzdY3
         v4QaOMCbGjGJv0WUh/SVKrg6hvykFqzw0pyF40CJNdJ8hdLjbjVsH9RT9bZQMzceQUsL
         xSYA==
X-Forwarded-Encrypted: i=1; AFNElJ8JziOk0Y9ljq1tZdME+8cehJiNqhiBabgHjCUKtcoXkIruDiDqcPbojYsNF0aTe3te6Ucwv6JgOQ==@kvack.org
X-Gm-Message-State: AOJu0Yyzv+xo6/k3Sxu3k4SvF8tJ1MLejF0v2F0/uudq/NGGHHqTZKtr
	WzWI6w6b6zcVSx0psmkdVH0nmAbT7Xfq/xMi8hap4sz2Swr/bR1ZRj31
X-Gm-Gg: AfdE7clhjU2Pv1FA4uq9+A3oOppvARKppj8FnJJUqEFEXhRS6HMJO+gfYqkw0DYsIER
	OxpjewkEBkkN4iFl5LUSRw8yDOrX62BhIGN4rB9WEKjBtXgWG+AjL8rEVkyW9CbySVruWIjbLZ8
	ytyNzJ0cMcIVGaZvkg3KqdvmyAvGBAQvOIiePsq4uHEXduPJRHXLPP0/wkBm2R4hsUmEycNxbcm
	KDtV/Jbs57aCKQek3PyGBN2n0tZ/0OsgkIhTVpXxszVowGxvDNrfI3RC6FPrLKTCTcBl2JtDWBG
	fkYh6DRuWL/ijfmV5p0tTPhUGy1vskb+8JYMwIEjYiDc+EnVEjoyI9HO66hJ3jVCruf/3lKRa1z
	ULM59mqCf5jZ6QkW12orah4JideANPgjZYvBDJeaSd4Wby6fBvv5DCTeLf3qyI2NWgZXDi+Yb/Z
	ZIbhDIrhXgGvv4lVIgF65J6CUfuwPtqTOun4+7it+bDjY=
X-Received: by 2002:a05:6870:3c8a:b0:447:3081:a4c5 with SMTP id 586e51a60fabf-447dcdd5400mr288139fac.10.1782246014730;
        Tue, 23 Jun 2026 13:20:14 -0700 (PDT)
Received: from localhost ([2a03:2880:10ff:5c::])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4472efa8860sm8765027fac.9.2026.06.23.13.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Jun 2026 13:20:13 -0700 (PDT)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	akpm@linux-foundation.org,
	chrisl@kernel.org,
	youngjun.park@lge.com,
	linux-mm@kvack.org,
	cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	kasong@tencent.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	baoquan.he@linux.dev,
	baohua@kernel.org,
	gunho.lee@lge.com,
	taejoon.song@lge.com,
	hyungjun.cho@lge.com,
	mkoutny@suse.com,
	baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 3/6] mm: memcontrol: add interface for swap tier selection
Date: Tue, 23 Jun 2026 13:20:10 -0700
Message-ID: <20260623202012.2446676-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAO9r8zPwHYj284gyyjqnH6Z-NNLLbftKqzoOKycaMzm3+ifSdA@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: F0E03140002
X-Rspam-User: 
X-Stat-Signature: 341rwpebyha7bby8np3y359jswbup3if
X-HE-Tag: 1782246015-17134
X-HE-Meta: U2FsdGVkX1/pekSer+RapVC74MKoj+llNKl6jcatpF5ywC7tcCCOyiBoKpWUWGT9fH43QYy0rJBFjPwvKovSKV4I5lSZhLOoUwJ8DgIqa5Hy02OdpmqfWw7dedbIecahlJBhr/Aad3agmBPobe7bnnKzYTw/mcbX4j+F3u/MoQ5RWg5y3jHV1VT9lBAZmWnXhiMmxqLEYgOSyWKK81ydSQN20xCbCTW2eIY9ed9NIT4njckPJnVMker15gXHzAmFutnKubtxp1N+GLRg9apE0mQzSEFzWfpPaCRe+r6I3bmDMpa+2zQqzBc7HPDRIOsEgaWALFe23z444mgHfzD/a/biQnoucvr9HoSGBdleB7D1hE0Ny7WXlpJt6EFVWf/+BDvnCT2iAA6xB6zWgXpe0TX4dW08YG/heKYSGSn6bLeH+iOYTE7+ldMQRY12IXJ96rUQspoj+9Dwq/HOauMrZ9BekV+VGAE4kcU3Y+x8Weo6pzvlIS1Voby7+EWkf5ZAFjsZdRhbVlUdlZUC3VGmw61gWZKnLHpxMxCgyYtV7XBkQS1ujIhZKNM/eWOVNAlj0/2WTMF4W10e65e4x68Mv5xk5JPiJJXm+dvcTGUxYSC1WehsROeN8FbZcDV7OqCBB/aFPLN5EPgFFXJG5buZeYr2mGdvaZ5yhYy+IK7yO1QLMpstTchrdSjqTK6UjjNvp0W5Vtz2ArJtnv67DxdQtTUeGn7UFcCr3CmWSuk0RA2ckrUf/PqnBxPJSFU3obt8A+Lo7YnmdLTWMeZJdmAtxuyNSFlK9NBPbD07MakmmTstCKfyRAhbnXjmXp+F3awXweA56xXADBlZ/n9xLpzYRgWaiKZe4D0Y3ZrjJE9kpGni6SgUetp8P5+kU6uM6GSFrm62hj5oSWLRLLs8d5ZdnURuU3dGGYA+gKQp//b0lqCwnKubBZyEaGCsNjvnRepHlDP1BK6aVyducbziwKR
 bP6rxEjq
 RdwzN8YPjndgj81pNCWw5Dm1NCx+a8vKCWASkL4+MhFlEp98LR6h961YbK1DZzzAyvwd1L/u+prd21pMbjtbpIBJjcr+bXv/R+O560dtSLtPB9KwTBeotmpvBbNK74+Eo69yQVUpHZFf/E+4Ywd5rIO9lyo5JVMxgNPdkMI6aKnjHkgyz9U3KqCz9wU1fgmhyQsajunrY9QpnIGG/QhkCI9KNV2q3xJRr4LTOAUUBCYJrqNLn+PWuO6BD2TqFH/2UmiHNgvaNDISM5dZQ48gzyYuBWI4VAxXroHxaYY1+Kg5RnUQXiCluhovl31P3Y5i59RaMkjI8uRhLVxBUoGDxqgsfJzwcJgJPbcXz+3CbRmmrbhWd0yxJ2mCCcO6JAAP+J3h80LfB0/xFD+glUmrX1/UIlkMeqWiLf8kPpbpeSjyfxXBvakG8rMZqvpaGwAhQHfpFfX/FqCDcDgU/wKUGae+AeNk3AyvoJQeOTg++31a8srJHABubirhzNXfVBSKVMQfiUF/eTHm+5ZFj4/Ff/4sQ25uCV16jweTLYgQUvEAWVBbMJOGi9IQUvB2JFXOVt+og
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 23 Jun 2026 13:06:10 -0700 Yosry Ahmed <yosry@kernel.org> wrote:

> On Tue, Jun 23, 2026 at 11:56 AM Joshua Hahn <joshua.hahnjy@gmail.com> wrote:
> >
> > On Tue, 23 Jun 2026 11:10:32 -0700 Yosry Ahmed <yosry@kernel.org> wrote:
> >
> > > > To get back to the question of how the auto-tuning should work, the
> > > > main question is to which ratio we scale the swap limits to.
> > > > Do we set the swap limits proportional to how much swap is present
> > > > in the system, or how much swap is available to the cgroup?
> > > >
> > > > So if we have 3 swap tiers A, B, C, with 50G, 30G, and 20G capacity
> > > > respectively, how much should a cgroup with swap.max = 10G have if
> > > > it is limited to tiers A and B?
> > > >
> > > > This is what I was getting at earlier when I said we have to calculate
> > > > different ratios for different cgroups, based on what tiers they have
> > > > access to.
> > >
> > > That's a good question. I think the case that is particularly
> > > interesting is whether or not the limits of other tiers should change
> > > when another tier is disabled/enabled.
> > >
> > > So basically in your example, assuming everything starts as "max",
> > > when swap.max is set to 10G, the autoscaled limits would be: (tier A,
> > > 5G), (tier B, 3G), (tier C, 2G). Now the question becomes, if
> > > userspace sets the limit of tier C to 0, should the limits for tiers A
> > > and B change?
> > >
> > > On one hand, it's simpler to just keep the autoscaled limits unchanged
> > > in this case. However, this means that the effective swap limit is now
> > > 8G, which is not great :/
> > >
> > > The alternative is to recalculate all the limits when one of them
> > > changes, in which case the limits of A and B would change to 6.25G and
> > > 3.75G. But I don't know if this will work well if we allow custom
> > > limits. What happens if the limit of tier C is written as 1 (or 4096)
> > > instead of 0? It's effectively the same scenario, but the tier is
> > > technically allowed.
> >
> > I think the one problem with this is that it becomes quite easy to
> > accidentally overcommit. As a toy example, if you have 10 workloads and
> > 100G swap (as in the example I gave above), intuitively setting
> > swap.max = 10G for all 10 workloads shouldn't ever cause any contention
> > on capacity. But if you start excluding some tiers from some workloads,
> > you actually get overcommitting on the tiers that can service the
> > most workloads.
> >
> > I am not sure how concerning swap overcommit was, but at least in the
> > memory tiering scenario accidental overcommitting of toptier memory
> > seemed bad enough that I wanted to avoid the problem entirely.
> >
> > > The more I think about it, the more I realize it may be best to drop
> > > the autoscaling thing. I imagine memory tiering might run into similar
> > > issues too :/
> >
> > And that's why I didn't include opt-in/opt-out for any of the tiers;
> > if you have system-wide ratios, there's no need to change the ratios
> > at all, and as long as the sum of your memory.limit for each workload
> > is under the total capacity, all tiers will also not be overcommitted.
> 
> I think eventually there may be use cases to opt some memcgs out for
> some memory tiers. For example, limit sensitive workloads to the top
> tier (or vice versa).

Yup, that makes sense to me too.

One of the things that did concern me a bit with my model for tiered
memcg limit was that system-critical processes would also be susceptible
to being demoted and churned, when we would much rather make sure
those are kept protected at the toptier.

> > Now, all of these complications aside, I think we might be overthinking
> > a bit here : -) The auto-scaling should just provide some sort of
> > "reasonable" default, the users can always override the per-tier
> > limits if they are unhappy with the autoscaled values.
> 
> I agree, but it seems like both options are not ideal here. I think it
> might make more sense to not present a default value at all, have
> "max" be the default for all the tiers, even if memory.max or swap.max
> isn't. Userspace can set the limits if they need to. Autoscaling the
> limits in userspace should be easy.

I like this idea a lot. That would basically make swap tiers a no-op
unless you opt-into setting the limits yourself, so we don't run the
risk of accidentally enabling tiers.

On that note, maybe it makes sense for me to change my
memory tiering series to also just not present a default setting for
tiered limits, and instead just set them as max until the user comes
and configures them?

I think this is a better question for the memcg maintainers, who might
have more to say on this. Johannes, Michal, Roman, and Shakeel,
what do you guys think? Could an approach to just make the memory
tier limits writable from the get-go and not expose any defaults
make sense to you?

I think that would simplify the code quite a bit and also help mitigate
the possible side effects on system-critical workloads.

Thanks!
Joshua

