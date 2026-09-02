Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7E70CC624D7
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 22:32:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6ACEC6B00CB; Wed,  2 Sep 2026 18:31:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 65E8C6B00CE; Wed,  2 Sep 2026 18:31:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54F8E6B00CF; Wed,  2 Sep 2026 18:31:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2D4B06B00CB
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 18:31:59 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B94871403D4
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:31:58 +0000 (UTC)
X-FDA: 85170271116.11.C895822
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id E72D9160006
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 22:31:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KI48qx2d;
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788388316;
	b=dsTz2Yo8YZKT8+wVSmGY/iCG9wTOo6Djm36/fTml8ojunhRVIMs+XQnHh5ArQajqrdxMq1
	ma+7+zNM4F478KwXq6dtk6iRdhEgUbY/+8RZ+h+lbuwrve7zos/N28K+m2FHqzINUZkQm6
	XN0yVNsrjwHGH6BYiBwp4hPU2yZ5nik=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KI48qx2d;
	spf=pass (imf08.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788388316;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rfj489snHAgcjqYCzxpw7R2gTXTEyikU7ldTqChZJq0=;
	b=YhmZquNXsiIRJcGJLyc6DjeA6qw8cgelhDDwS+zs96lbbrG+81vxDQqc25t346nIxjeC0T
	KDy5Bi7CMYmzuJ++BpsIH5jjZ7xQHbMWQjbAQbSjFSRlas+pHjAGfn0COoXJ2ae5kUW09N
	oEjias6WHZJKR8/XFbuFQpiMjtDD+h4=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2d8fd3b729dso15032095ad.1
        for <linux-mm@kvack.org>; Wed, 02 Sep 2026 15:31:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788388316; x=1788993116; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Rfj489snHAgcjqYCzxpw7R2gTXTEyikU7ldTqChZJq0=;
        b=KI48qx2dQ1PMQ8ZYiIO4vuO48CLc8P2AHBkeed5CXMDjn/07ic9L6cyyJu45hpucEe
         Nx0cAGWf3EQOJn0RbP8u+2RQNDnt1s1Xs3ADEysEv6mbQiEEgoSKBOGW9gUccsasv7Gr
         RGg34mIb64NWOoESMurNRwr8m4TegnKxOdlbqzK+6O25uc0FjHyEGr+Bho2TeTbjQiGL
         nn6EhDjNSzKj/diYM2/F88tjYXa0XBG0S0EKu/j8Fc0WYALVLm2KJNXbq9hBC0j5n38F
         jCQVBLV8jACDBF4WE4mflnJWzzLCvmnoSoFsY+/68Qk4Tvmta+IMyBv1WFwDzowIVA9p
         Iddg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788388316; x=1788993116;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Rfj489snHAgcjqYCzxpw7R2gTXTEyikU7ldTqChZJq0=;
        b=ndrGmKxfv2CzHYu5IYnXZJGV7/ZulRc9ae3wtR3LR/gaOv5AKWYhsHESgl/uznQWZR
         Iwu+RhUx2/jUQmf8UV4zrrijCDKZFr2UXXR9ck3r1OoAdvNDec4RtGjj0kKiQ5dlpRQ2
         pdVPiAH3encrKfHQEnaVy9wn74v50m2lZo6T6t/z97//y/MmpNMXpROeYBJqoGIyWUHU
         oxxkkH6UC3Tcyp/3PYjztIoI6y11XFf+6QQtjL3Qq2MrNFouJJPdrgXVBN95vJ+0WKsT
         Deon8Cu5j+KCJcSXOWLHV58InUieIUkugjm9kNjB50PkMSVpRsKUwB6MnhSasApm+Ne2
         ragA==
X-Forwarded-Encrypted: i=1; AKwUvBwqvQmFKrsoZjmWmqishwqZ24H01R7nHxHBwWGDyBY3A8NQi5W5V2Bu9FrW89peiiD36f7wAZGnvw==@kvack.org
X-Gm-Message-State: AFuF++lang+Hr5c+lZ9itrCI4dHNhZptWbVrbSGCJvqSG8ZgQmqg6h1M
	9dsJyOmqkNUiwpno0MAtRw0khWVYHjqRB9Ud9p/B8H75id+SeydmDnVO
X-Gm-Gg: AYBFou1ULkP+YnZtgSoIROrCuz5JdCcU6YRk6AaJoevzUvg0dcKPsuBwEsFWGYQP7/d
	ASVL/wkR/67hk4F1vlKzhedcXYkC+kme8OUuCl4OoRgCkXiK1rGWYGSA88DeMSNW6on5TTANoni
	2W2RCjseLuXX2CAxuYj2FIGCo0FtNGqEOQDDLKrNJXr1nZYnCdn93BbB1E/QQxC1PcYIFKVJZ4T
	wQXZbu9zapABsPOkscdbjX+nONTn2qyPhGVvlG4+xwC+DGytEZ/IYPhqv6YtiY450PzQh1ZUKXG
	qlR/Moj+lX9pG5Ww4/A6xm1Jlvq5rC+pfqmgb5TnYI6Bp+8t8iSXwdeVezSZ2pwyOq8sAvEZJCj
	m0LIiadd23MISy2NaZXJvAYM3kmlzRtsjToE4PTjWbMnkrGMZPqXGIUbTJcJp45ZN7e+x+pzrfK
	MowtA+6pA0rZzigwsUXDOl4QGRKOu2QJCTdEeW+Jp4wYKnHAQuwBJQeZdy8WcxGcbH
X-Received: by 2002:a17:903:1a0d:b0:2d8:d4d3:da50 with SMTP id d9443c01a7336-2daec7a70a2mr111190875ad.20.1788388315442;
        Wed, 02 Sep 2026 15:31:55 -0700 (PDT)
Received: from celestia ([2402:1980:9c5:2de5:8b4e:3f3c:b637:4ca5])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dafe0e24basm1215945ad.2.2026.09.02.15.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Sep 2026 15:31:55 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2.1] mm/damon/core: fix false positive in damos_quota_is_full() when esz is zero
Date: Thu,  3 Sep 2026 06:31:38 +0800
Message-ID: <20260902223203.14871-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260902144804.88298-1-sj@kernel.org>
References: <20260902144804.88298-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: E72D9160006
X-Stat-Signature: 56g584yrnyggtqy7c8ce64yb6rza3nbf
X-Rspam-User: 
X-HE-Tag: 1788388316-393886
X-HE-Meta: U2FsdGVkX1/IWpDhi1kj7WUfRzrtE0Jd4KfP1KD45rZgCQPesHAlO4oUgfFnxMsDvUYR9J5y7Kgxuk+AmlmGzMoReYquCX+l8MVJaCpq7VnLzHhHnD8YYs5jGwInrTQR6fD7ilZwZHlMV9/i9R+w4JkK+eaY/yqOu4RTjF8TnuuRp95O3hDTi5M7t47fvV1Hd+qUTHOOhd8bGe2tKHUTvP+FIE4D8lzg5HVPlJN36UwbNZvT6vETt/nREVfF/YC/oUANaFxlCQBJLOtomxLzP7BDTAd1FDiVoDteU1jBtf09vwosOY8zoTd6rl48YTzdqMotL+dF8DqP7xsLGm4vc8P92ghEilc8b5l1EMUqWJJly82H1eWOTIj1X3QScVC+IPpIYNMwWdZqYADR4mVDFWNcfkL7oJjTCPffBNzkmVwqu4BXkqnbXNI0pxvu1g3/C0856vn8XFceXe5ZRIHE0RnvcfeAeGIgV0iF1mZVHDcVBISzktmyvkfGmQHLHlfKFqmw1NfiTfp8DyFBaWltIZsi+UFPi6izT2GcRmkaqOFGnX3HP7dTEqhtEqYrM4wgnN4eCeXmUmkgt6VPd9TuOT+nNhXkS40tLwgCH58+opOH8w41Msx0Js9TrOrt/41eNrhyxNW0YV7yDi9QhCJvOqHR8gft3bCgEDi/Y4fEiVeLkGiNMXA9FDyYDQoLvwBEa52F+OMBjDnhiNQGgMwsFwN/RVjgZMSV9+6+6Mm3SYGfVeGoe7w0nbtEEK9FrFKCr0LcSOfHifiahDceXpuevU3Vey/31FWSdVhOeKUAts9fjT1YZMgnK38jj3Y07WTj5dCPOA4GrkTE3l0nekhIXQQ9V5cFOjjzPujwug3TktXV5WYgFIS/0A5m3cVmMx22DOje35YR/d7uySTV8gvXRAVznCH7aXLfK22HSKqbpXXYIa7TX65BD7v4+yOvPdjTjIS5twtnoTqNMkERtql
 iyiiv+pM
 wLin9KqhkplvSTYae6e+f2mTWOXUkmMl8h5gLBcfsE/m08e8k2N1kFAUci4ufUI23GbAyTqbwMA4qzXBSKg8twqKCR4coRQko97+ZSVfTU+7rSOuPUTapt3CJOBpdV7WAPMbiYEVyh2TK3tVvY3BpDBetIEU7TbdOEj/ruZWWJFm8Dv0gt0oSg2HiZl9Q90vnAw+gOFxzXvJ+oR/KEmgQQUC6QbAwhhIUdhGNBlBhDcJGhB8K5A5ST3gQHxUxqtusGixBh+GvpVV/9+w/iyqXbH8xnqh4zHJLwTG73FVXju8PCIGMophCc1SCic++ZGd9+YjXkM9o0fTXr8KiaXiBOqI4n8XyXINDigX3vB06vEipP1MbwcGlo8JNBfLfo8G/XtsDi/6PSFTMCgneueNNV5Yb7eYLCDtDmx0PaZQXwJSS8H6B7OrsD8IUjxlMiwHWlksIB+ehbm6kNLcAabkB8iv1BseO3M6N7WB8oFDQfmb5tJI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 02 Sep 2026 07:48:03 -0700 SJ Park <sj@kernel.org> wrote:

> On Wed,  2 Sep 2026 22:22:31 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > On Wed, 02 Sep 2026 07:10:00 -0700 SJ Park <sj@kernel.org> wrote:
> > 
> > > On Wed,  2 Sep 2026 16:44:45 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> > > 
> > > > When setting goal_tuner to 'temporal', if the goal is achieved,
> > > > quota->esz_bp will be set to zero.  In this case, damos_quota_is_full()
> > > > will always return true, even if no regions have been tried to apply at
> > > > all.  This causes qt_exceeds to increase unexpectedly.
> > > 
> > > To me, this looks logically correct.  Could this cause any user issue?
> > 
> > Yes, I think this might cause unnecessary confusion for users,
> 
> If it is _might_ kind thing, please ask questions first, or add RFC tag at
> least.
> 
> > at least
> > it did for me.
> 
> If it confused you, definitely we need to fix it.  But if it is just confusing,
> let's try to clarify by adding documentation, rather than changing existing
> behaviors.

I agree that we should avoid unnecessary code changes if the issue is
merely a matter of confusion.

However, I believe a code change is necessary in this specific case,
rather than just adding documentation, for the following reasons:

First, this distorts the semantics of qt_exceeds.  It is a statistic
meant to track actual quota full/overflows.  Incrementing qt_exceeds
when the quota is completely unused (because the temporal goal is
already met) misleads users and could break user-space monitoring tools
or scripts that rely on this metric's accuracy.

Second, considering its original behavior when it was first introduced,
the recent changes [2] have inadvertently altered this behavior.

When qt_exceeds was first introduced [1], the conditional check was:

    if (quota->esz && quota->charged_sz >= quota->esz)
            s->stat.qt_exceeds++;

Later, to handle cases where 'remaining quota < min_region_sz',
damos_quota_is_full() was added [2].  When this function was added,
quota->esz was replaced with !damos_quota_is_set(quota).

    static bool damos_quota_is_full(struct damos_quota *quota,
            unsigned long min_region_sz)
    {
        if (!damos_quota_is_set(quota))
            return false;
        if (quota->charged_sz >= quota->esz)
            return true;
        /*
         * DAMOS action is applied per region, so <min_region_sz remaining
         * quota means the quota is effectively full.
         */
        return quota->esz - quota->charged_sz < min_region_sz;
    }

With the introduction of DAMOS_QUOTA_GOAL_TUNER_TEMPORAL [3], quota->
esz == 0 carries two meanings: "unlimited quota" and "should not
be applied".  This overlap causes the damos_quota_is_full() check to
return true incorrectly in the temporal goal scenario, leading to the
false positive in the statistic.

> 
> I feel like we also found similar case that people send patches to change some
> behaviors that confusing them, but not really problematic.  That sometimes
> waste unnecessary time for understanding the intention of the patch.  Please
> feel free to ask question first, if you found some confusing behaviors and
> don't know why it behaves in the way or if it is a real problem.

I will ask questions on the first in the future when I encounter
ambiguous behaviors, to ensure we are aligned on whether it's a real
problem before drafting a patch.

[1] 6268eac34ca30 ("mm/damon/schemes: account how many times quota limit has exceeded")
    (Fri Jan 14 14:10:202022 -0800)
[2] c7ec7d5f6b3d1 ("mm/damon/core: handle <min_region_sz remaining quota as empty")
    (Mon Apr 27 18:33:50 2026 -0700)
[3] af738a6a00c1f ("mm/damon/core: introduce DAMOS_QUOTA_GOAL_TUNER_TEMPORAL")
    (Mon Mar 9 18:05:19 2026 -0700)

Best regards,
Rui Yan

