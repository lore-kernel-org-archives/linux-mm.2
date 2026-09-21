Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B2D60C982E6
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 17:03:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F3066B0088; Mon, 21 Sep 2026 13:03:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9CB336B00B0; Mon, 21 Sep 2026 13:03:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BA5D6B00BF; Mon, 21 Sep 2026 13:03:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 60E396B00B0
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 13:03:01 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DDB3CA563C
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:03:00 +0000 (UTC)
X-FDA: 85238389320.06.8B298FB
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf14.hostedemail.com (Postfix) with ESMTP id D6681100007
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 17:02:58 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZHWmDRFP;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=ZHWmDRFP;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.180 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790010178;
	b=BKVTfxG94dkD1ZJ9uVT5HO3mzIVKzXb+gGCTKlkwcX+ql82edrkMmsD0ljyBprP+xXGk2n
	HEvE+NR1RkRIr8O5UlkMGaFqNhTL/7l3inMk7Eleo5wQAeY7B99t2ZYte4s3tJTV2NQwv8
	mK6/hc2Yr6HsnHbsIhfirNZ4ZhlOluM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790010178;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zam1HuieMGo4IVtIDS9XVWJbvXE11Q3uTiDlxDLMxb4=;
	b=ivylA59x+k6DIvTujp2p2JSlcIULeHjziLtthhL8cdRHX70cq+QI6tgd1org7HG5cKS3Pe
	ijX2wXgZMqlK9cHwi+d4eKXQZRrxHLCVccfP8h9PHz8s2GnxNaJuBUb47TY8VHA4SrKtFt
	IekoRRLUhiCrGE9X/oofXvFmAG+5FLs=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-52f9fc510e1so559981cf.0
        for <linux-mm@kvack.org>; Mon, 21 Sep 2026 10:02:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1790010178; x=1790614978; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zam1HuieMGo4IVtIDS9XVWJbvXE11Q3uTiDlxDLMxb4=;
        b=ZHWmDRFPBQtPUHup5d2DowdQX04SCrhYMKagAckZkzNQL1NoiQ6PlZsmUEhYM1Zyq6
         c+oVDzyd4HiVGCmxy1gGNIj7mySe/wBDA4Mx99fvPZ9c+ewOI+sXY/KrfBQD2I4OC4ZX
         uK/40+JPPsO8R+CHKUEgfIDFR94iYkxM2uljSF0TzjKLh0WHj1ytn231cxZjztpQLQj1
         1wQTwUCK8a+SA1kao2XPxJtJ5s8f1+WiuYN790KNLgge3ZMlYRGyWyCXKFxvgTdMrgSy
         kHWEArcj09mdjU/FyGq1YXqA9orhUloXekVpAUiuZmXIxRxES2xK7PXHL/t3tt67rlgQ
         mwqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790010178; x=1790614978;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=zam1HuieMGo4IVtIDS9XVWJbvXE11Q3uTiDlxDLMxb4=;
        b=hUdw5rZAPQS1nA9ScaOZ+/nGNKf7OM/BAcL+JVTD4UEdimgwn7zRRof86XQ2dLUR+M
         OyANxG7z37UDZNKSr5s4LdIclsUGy7hcW+jbm4uD93HFaSiobopZPTjtgm+AvP9J4aaj
         grbo1A+XHFvIFNyYE++7pIDSKr0jDoV7LOaolcVxOCQ6E8plcjcv5MWOSUMuZvOzi2N+
         CovuCr4V5vZcESu5a0myFeVHEVyOXngdSddt4aeqnbJAKhTnb6eGIgFEZeVQ5KrILUrg
         PCZPhWNi/XkHjDAVCU0CkUJ0P958MxsghaqbNdRgHjPiae+fJoJ/d9bXx2qmt+6b7mIi
         gx+A==
X-Forwarded-Encrypted: i=1; AKwUvBwpzMvEzk5izOWVV9QfymPEG/3GlskbPHk6tvL9N1IAG7XmWRnIBZucBYfECgVoPqvAlTcWNjaPAA==@kvack.org
X-Gm-Message-State: AFuF++nSelepVWfqXLiKG4qDZST7OH1vwfaCQAQ/yOJul/B6DAVkUrza
	m4SDZ+Kpje+yPdJrn55KHynOvpjh1FLRatHJPgWNv+qK8jODX9t0yRERygledR5poFY=
X-Gm-Gg: AYBFou0FjVULFQFF7lRxOBOva1ayAlkX415MFxL5J3/UpQXMH7L7VsekuKdQigiQWEw
	OeHuC1l1vZjLcdN5WmEZtGggmmVkQKbQyRrQ4Xg8bHm+FtAq1oJvCn4TzandmOq1BPfHrMf+6xS
	lJEzuOBTfK2A7kcqMxg5vu2TsoJCg4/QWdBVUMVpJmS/RB9Z2S6iy7ammqLX4WDAAHHsW2TeoS3
	Ydjrq7PnMq9wUrXgMItXEkzIfBAzLxsrbQe6v8ru0rtpCAoZCGJrUixOjz+slzMYSy6ZyjbCQAm
	U/vPH7+b+6kOwEnFbihdKH+7qvvkFZ3CWlEiJcuKkLF3FpWyBjd5vD+2pQRTEZ5fpWWpUlJpwxA
	Z8CQtJGSphxyc7tmJIa8RA+Olp9FZVR5a6opzqosRSnFLFYnpYxXsKv/fzXbgsFSa0kLmRAx/AD
	QTRtDhDztSb3U8fqOKoNPJHNGrx3L2sdLlIeWfWyCwLSualsFUOMGCALmoNNPYc9f/LSZs4vFct
	tSfJ0/tVxneeS6C6wW3vWE=
X-Received: by 2002:a05:622a:6110:b0:530:fbd3:2038 with SMTP id d75a77b69052e-532db89fda7mr2849411cf.26.1790010177750;
        Mon, 21 Sep 2026 10:02:57 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([152.186.177.174])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-532ae618698sm68095611cf.16.2026.09.21.10.02.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Sep 2026 10:02:57 -0700 (PDT)
Date: Mon, 21 Sep 2026 13:02:10 -0400
From: Gregory Price <gourry@gourry.net>
To: Chris Li <chrisl@kernel.org>
Cc: Kairui Song <ryncsn@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nhat Pham <nphamcs@gmail.com>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Barry Song <baohua@kernel.org>, YoungJun Park <youngjun.park@lge.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, "Vlastimil Babka (SUSE)" <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren =?utf-8?B?QmFnaGRhc2FyeWFu77+8?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Wenchao Hao <haowenchao22@gmail.com>, Jonathan Corbet <corbet@lwn.net>, 
	Hugh Dickins <hughd@google.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Tejun Heo <tj@kernel.org>, Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Subject: Re: Path forward for Virtualized Swap?
Message-ID: <arFe215hUcjLhvmS@gourry-fedora-PF4VCD3F>
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <aqJXx2vtbKaRLt3x@fedora>
 <aqLi6cIjD2wJwk0B@cmpxchg.org>
 <CACePvbUG1ApMzMdEzf-63rpjgGVNsRk21pT72OQGJpM=OtRUew@mail.gmail.com>
 <aq6cVXPLUUwJA7-2@gourry-fedora-PF4VCD3F>
 <CACePvbVaPDnva8X-Xmz84r7j5HjTuih-w5phpw7cerK2uPnK6w@mail.gmail.com>
 <CAMgjq7CJBHkoZmg9oKNgGA8czL0djyBTCAkPz8ETm-tX=Qci4g@mail.gmail.com>
 <arEotFqE7ZZoxMHd@gourry-fedora-PF4VCD3F>
 <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACePvbXb1WLz=OAAzVawf3oc3+dE3Z7qfPdagQ2dYuf3OALc2g@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: D6681100007
X-Stat-Signature: ijf3ek8y5cwqnxsfeajnkai4ytoroc7d
X-Rspamd-Server: rspam01
X-HE-Tag: 1790010178-923510
X-HE-Meta: U2FsdGVkX1/GUC5aiL6uK3FCuWL8qZypr6g6hJRyh4U5omjbrQ5DfgxvZT7fWmTawV1nx6n5/HdHTZyqcOSRY4tO9SuuJqwJRXaiZlaWMFVIxsNs3sh/rKPAB0osOEjRy0WdVJcxW77UiM9xR7hp2z4n4PwWAhfgmpAb4yqyOjiEZbqII6W8Z2jNG8OZIIHvw5EHgjs34bU+/uLKyyxGdF9HyrKt3IbWiuyqVjXVBz2XfUWLcAyWqHBRCRrT1y8eNQDTjMuRXealfUwan4uAhJ+88uj0FSOAR4tDZ3Qb203+RRPwKJxFPXu6ouxc/LlgyA6xs/cg4Cs/hbKnLVc3y9r+XKsqn1+GnqJtx0MC0A8W63C5gvHiO4bRpP1WWYmDYa/OK91bLpxbr63D8PUjmR1PrbPNJ2dyBro+l7dphoE0y/DpaEYsvIoHibLeGww5uFIzCmWoCczKyehC/wiwbv0qMywY051n0yjDE7YR9qo4Ggc6YMMYnoYNkGxkO0KsFewS2Baq2IMlhuFfDTw40yaDCeJNuAWTb/jYv1FVQknxBIlIBqJRi1fmfQyIYCt/AnS4IW7/uRXXt9thiWDGQxEWe/FRnaRaZJWd4UkEK4oBQyvjn4Dli28GpOVLWOo0e2wxTir1APkq275WHmND+nH1Y9ye8QqqZNx0+e5V5AxjGs0ndUxAmsIrZETl3iFoKYkI407g96ATHi3CVpH5So+UANaW/4o4oQBpxXuuIRo9IX5SvejQGg/GI2fbeQYFRkCak1MZc6hVZ9Ky+HZkj1Eb4jWFE4oHwaPKc5xqnxO0aPrq0LPhO5kIkjsbsroE62DZtpHoC20otpBzUXWCYGglf8O3LXzZvwqzmEyGeODh7er/1wLMS074ruOZXt62Q3Rpsddph/as9AZu5JVBDPXnQODHUUI9rE2ZwHDDCsAfLqL0gjWv5j4ARJhxmyvMJPHwcVguGJ/YMrqf+0s
 3LnqUhxT
 C3sJoYdUwqKf5s3jpkY2CZ688A9sYwx9myzDCn201yzyq4JK9vRMiDgCvP5NZ5vPAfwQFUYPCuRcYW+lU/4+d8PCmmbtjn2maGzKeccKAza3EvxC9eYcuDPPFZFd6JRVFOQBP3myF7di2+kG3EFVkxcyWjg83jeysFovLGgi1NHhLbS8G5sFckKi3QvzehR5vOXkKfYF01PFcVKg7DjgIpYtP2RlQf64G805i/GujwhvvJTkqrlNtvjVsGxQw9Q7MLvDMEKgbgOYQ1M5MQr8TyETYZhjW9urODe+joTV2NExsvxaX2F4jSx+buo8nCSD8cRHHOXRznfscbxBeGgR5GB/2pe8Fu0q9w7I6Z3SZx7KVXs5jtplI4GQEAAAsTSR2ZtGiIhhRaRuHI2XzWFDL9+mYfKGU9rYJH+uZ4i12w63t92DhPkhHy/3Oa60nJrxSJXGCRDJq9AIds74aKohmemSMckD5Gsfl3WLXl7zjTykxP3qDC9okpivybnYEWbcZzpI2ZWrQBugEP9dC1303299RsFO1e4PuV198
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 06:32:56AM -1000, Chris Li wrote:
> On Mon, Sep 21, 2026 at 3:27 AM Gregory Price <gourry@gourry.net> wrote:
> >
> > This would preserve the existing memory.swap semantics while allowing
> > both backing resources to be constrained independently.
> 
> It sounds like you want memory.tiers have limit enforced.
> 
> I suppose it is possible. Again I want to see how people would
> actually use this feature.
> 

Possible, but arguably not needed. the swap and zswap counters already
work for this existing interaction.

As I pointed to in my response to Rik, in every reasonable use of
pswap+zswap the global swap counter is pointless.

So then pswap=swap and we're left with zswap and swap.

And I'm not convinced your reading of the swap counter as a limit on the
*logical* memory allowed to be swapped out is actually accurate.

  memory.swap.current
        The total amount of swap currently being used by the cgroup
        and its descendants.

  memory.swap.max
        Swap usage hard limit.  If a cgroup's swap usage reaches this
        limit, anonymous memory of the cgroup will not be swapped out.

There is no documentation I can find that has ever documented these
counters as "the amount of memory requiring a fault".  If you put a
compression system in front of physical swap - the counters as-described
would still be accurate, while your reading would be broken.

"swap" here is highly implied to mean "storage" as opposed to memory,
which is why "zswap" defines its limits in terms of memory.

  memory.zswap.current
        The total amount of memory consumed by the zswap compression
        backend.

  memory.zswap.max
        Zswap usage hard limit. If a cgroup's zswap pool reaches this
        limit, it will refuse to take any more stores before existing
        entries fault back in or are written out to disk.

If you're presently using swap.max to mean the "logical amount of memory
allowed to be swapped" - then your usage does not meet the definition of
the knob.  You need to justify that your use case cannot be expressed
via memory.min/low controls:

  memory.min
        Hard memory protection.  If the memory usage of a cgroup
        is within its effective min boundary, the cgroup's memory
        won't be reclaimed under any conditions. If there is no
        unprotected reclaimable memory available, OOM killer
        is invoked. Above the effective min boundary (or
        effective low boundary if it is higher), pages are reclaimed
        proportionally to the overage, reducing reclaim pressure for
        smaller overages.

That's an SLO interface.  memory.swap is a provisioning interface.

As it stands, I'm left viewing zswap's counter inclusion in swap as more
of a bug than a feature - they account for different things (memory vs
storage usage).

~Gregory


