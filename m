Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 25588606A331
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 18:36:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Y5V33Lza
Received: by kanga.kvack.org (Postfix)
	id 3ABF16B05B5; Fri, 13 Nov 2026 13:36:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35D236B05B6; Fri, 13 Nov 2026 13:36:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 29CFD6B05B7; Fri, 13 Nov 2026 13:36:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0916A6B05B5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 13:36:52 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 791881202A7
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:36:51 +0000 (UTC)
X-FDA: 85430952222.25.B18B1BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id CFA80A000B
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 18:36:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y5V33Lza;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794595010;
	b=FIgmRLu9pOvQwcGIJXVYbJeIht/uqxMVIFGGlFvzC9o124hhZ+inTEj4zqvhJS4tzbQaTC
	Zy0AWuLpZc4uGSzVf8Wf/rMdbCWBRVp7kcxfmvkjlciwBcN1qxwkEW1/nS41bg07svl3ee
	sPsTPigkeSBDpLFLcSOspwzJ/+DUtp0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794595010;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jmkU0n0KGNaX67NEI1E6pDmmFAUmU35EaMfakgIfL60=;
	b=mcJNjFnTP5LQBduJvSiolyPMhJlZbu0qODlhhu7jyC9Q0mRdLoHVozTY1P/YRTf5Kz63Mj
	nvVNLbpXCYH2H8w1Oly5MTemfCsayWAppzQrsHfHnA/Mjn6gUFz/1Yc/lDudXY4jgI/izD
	ULel+FDrxx2Ihs3/3oepgk4OeVtm24c=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Y5V33Lza;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3073D45541;
	Fri, 13 Nov 2026 18:36:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 979881F000C4;
	Fri, 13 Nov 2026 18:36:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794595009;
	bh=jmkU0n0KGNaX67NEI1E6pDmmFAUmU35EaMfakgIfL60=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Y5V33LzaOo0yZjlfI+RpIMkePLOEWMJvSVIc99TZ6biEuCehXTyteLbCL3MBrabuT
	 IAfVZ38dyLQVENsHoBvTVdiCg0Kw+bSk9dumAnxJmtztoz1gmHhS5SsVaNtivmacY6
	 ePunxP7ukPZJyth6eg3N9Bz6oPo3Du08RFixIMxlq7Vq5wo5yyvt5/2XxvBkKnwF0+
	 vSCWEjjaVzM4ckNauVm1aOgkRuY2Xm0QVYakOTPpr1unqQeca2N2komHaNZj0pp8XF
	 68FZkDxAHnjo19HPw9KFfkz0BXfG0NOLwyez2FiCZrGUDGB05d2eyhJWEDP4cqNifz
	 waRawah3Vo0Lg==
Date: Fri, 13 Nov 2026 18:36:47 +0000
From: Harry Yoo <harry@kernel.org>
To: Marco Elver <elver@google.com>
Cc: Chris Down <chris@chrisdown.name>, Vlastimil Babka <vbabka@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Kees Cook <kees@kernel.org>, GONG Ruiqi <gongruiqi@huaweicloud.com>, 
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org, linux-hardening@vger.kernel.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 0/6] mm/slab: Support selecting slab hardening
 features at boot
Message-ID: <avdQEBP70kK8W7d0@thinkstation>
References: <cover.1794506262.git.chris@chrisdown.name>
 <CANpmjNP0cWB_670hYj7p+Dd=do1qEu4XHeW+c7sTv-MXi0UBTg@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANpmjNP0cWB_670hYj7p+Dd=do1qEu4XHeW+c7sTv-MXi0UBTg@mail.gmail.com>
X-Rspamd-Queue-Id: CFA80A000B
X-Rspamd-Server: rspam12
X-Stat-Signature: 9k6yrbo7gmp5ssatu5zsckrrojmjie6e
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794595009-905454
X-HE-Meta: U2FsdGVkX1+A0d3ZdZAfOVOKqwnWUe7Yg1vQzYKf7M21eqDcC7Jj15sAdSYAe2f97+C1I1df0k1XYDAsF1+fRcmKIPnlok7lTW3a8FYa1NXie14YGgiVm5AJ7HV1waGOWOm4S9ZhEBKL6PfoBZxomoVV0L8ls/mAJ0lbqW38nyRlJY5KBUbCqOZuFq9VIGnxJZKQW3X5ExPqWiVoUiuYthLlBHIn5q89Xe8Soa4h/Hn5XxLRuG8f8nAwvzwqLYa1jMWZ6mZ6vFfBpfejMS5Hi3CX3wXAl9SOpqNoDZBbldrEQ+c1trA7T9ly904sXIUEslfjH43RXSrhYAvu6UJLoh6X+CVq4i3JM1/sQSLq0E4w/z/MBQ7RjulCnk2bZV7gtobuynRTXDFfOHKd6yYa6qYoGTrXPICsROLYADgKZjoqgMiYpDePQDcZoVh66G+36F4DUr5kWgffM/WfZiY70PDvOYWPa+HhaTpPoDFa6eyFRW1lpODsLqw8YHhjoDnrzsZIswZcfFoLOpgqKIeiBDXmKS5fRWpG2+pAj5K23mJt8AFABZBlv/2DF+dLB8rrL79fwyXJ0fcn1doceclyK5xskZKKwNR0VPOffpLGM9BBsfx0lTQp5yn85Nlgz8l9VNZ6UypLcmu0sUZzUVNWFGyJQf14+bmEuPkTLPdeNIWdLZuviRhXwdnlpk/y9zjUKJWVfnZtxXBU6ZQOSRJG7ATGoDU89R3Ab+aeqA5Zk66d7gaTRq2IZXVdpo7yZ3zPW3Nzdls1prbRb/8E7hRu7YwfV3oXgGHSFg+urLLR1mppOjTr1KEIB042yCPw8/+YCZQT+bTS2V11/1TXOhXRaCtOjhbcB2jrdtf6HdHtDlCJV6Wl0PUKe6I5M4rEyFVWZn/ETo407LYzEoGIrET0BnolBGNR2RiMwGU7Zhi2Zr8yi02LvC9zetoceYzMXyboIboHplAsPcbgJz4LsEN
 JwgtmS4D
 S8gnnuWYUst65rOMqGFe3+LKGmZHSFMQ94OCb3phKGIbkTwkC6Tt0U1m8iabI+bTsubDrp033YOZvD1OVjkU74TNVPt08J0E/9KJkTkSnkqrdQTCr/tcuLYslrmad9FOu+W/7nRmwOvTAU+PPLLrqQFJCyTtBN2zfbYoUi630J0TQre3WXSfVc1UG16KUyoVCRvtUaiSWsyf1+t7Clg4XMqHbnzXPX1xDh0hBwFYVFVhhXRkhbdlnHuVnPSUTLHpr8ZB3QJ9I9m+pm8YG5y0yY+rhdH7QylHgEL8s44pjkQS1/dHjOgq1Zy2Y7EMVihW2WlR/xUF56g9vTpwdgRbVLcUwI7TInziDJFNMhpuYAXnaWINOq8cM6Ps5gfukf8QI6jj/TjZ76egdUFf6lCf1y544eQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 11:56:20AM +0100, Marco Elver wrote:
> On Fri, 13 Nov 2026 at 09:51, Chris Down <chris@chrisdown.name> wrote:
> >
> > Slab hardening settings are currently all build time choices. This means
> > that, unfortunately, hosts with different requirements end up needing
> > separate kernel images. At Meta, for example, some hosts are built with
> > these options and the rest of the fleet isn't, and that's one of the
> > things that keeps those kernels apart.
> >
> > This series does two things:
> >
> > - SLAB_FREELIST_HARDENED and SLAB_FREELIST_RANDOM are cheap enough with
> >   sheaves that it makes more sense to just enable them by default than
> >   to make them switchable. With both on, system level benchmarks didn't
> >   change measurably, only slowpath heavy microbenchmarks did [1].
> >
> > - SLAB_BUCKETS and KMALLOC_PARTITION_CACHES cost memory (Harry measured
> >   about 1 MiB and 18 MiB respectively after boot on a 64 CPU VM [2]), so
> >   they get slab_buckets= and kmalloc_partition= boot parameters, which
> >   default to on when the option is built in.
> >
> > Whether those two should be folded into a single slab_hardening= is
> > still open [3].
> 
> A coarse slab_hardening= option can easily be replaced by
> documentation. While less knobs is better, an intransparent coarse
> variant of slab_hardening= just makes the admin wonder "what does that
> actually to, and do I want it?". They still have to go and look up
> what it actually does, and at that point it doesn't add much value
> (alternative suggestion below).
> 
> > > > light: "I'm willying to sacrifice _some_ memory and CPU for security"
> > > > full: "I'm willying to sacrifice more overhead for security
> 
> Who will decide what is light and full? I think there just won't be
> any consensus reached.

You're probably right.

> One thing that users may want is an "all off" option, similar to
> mitigations=off, should they wish to get max performance back with a
> single option. So you could consider slab_hardening=off.

slab_hardening=off sounds good to me.

However this assumes "all on" is the right thing to do by default,
but not enabling slab hardening is not as nearly critical as not
enabling mitigations to CPU vulnerabilities, no?

I'd rather mirror hardened_usercopy= instead of mitigations=off.

slab_hardening=on (turn on all slab hardening features)
slab_hardening=off (turn off all slab hardening features)
(Otherwise it is determined by CONFIG_*.)

> But at that point it may be more consistent to drop slab_buckets= and
> kmalloc_partition= in favor of arguments to slab_hardening=, such as
> slab_hardening=nobuckets,partition. This would mirror mitigations=,
> and should cater to the usecase of slab_hardening=off to get max
> performance with a single option.

I hope we don't reach this point, but more fine-grained control should
be achivable if it is indeed required.

> But I would not add options such as 'light', 'full'.

Fair enough.

> Thanks,
> -- Marco

-- 
Cheers,
Harry / Hyeonggon

