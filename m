Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D26C4C5DF7D
	for <linux-mm@archiver.kernel.org>; Fri, 21 Aug 2026 11:27:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 96D276B0095; Fri, 21 Aug 2026 07:27:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 944876B009B; Fri, 21 Aug 2026 07:27:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 859F16B009D; Fri, 21 Aug 2026 07:27:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5DAB96B0095
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 07:27:03 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E1A15A30AA
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:27:02 +0000 (UTC)
X-FDA: 85125049884.07.F9AAFEC
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	by imf28.hostedemail.com (Postfix) with ESMTP id 004C4C0004
	for <linux-mm@kvack.org>; Fri, 21 Aug 2026 11:27:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=I2e9BbXi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787311621;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y0+Hytv4UMojIA2Hs8fG8+n+8sWIYR+hpSfJmDuymH4=;
	b=WxWkzVLQSi62nS24mucqe2T65yBWFhqF2VTtu9UuasI8UeDEAxPSkCWKakT6/bX0Ps60I/
	29xIi08ejLF1GFmC+avhTZ6d9/2hKPPvu57STCC/63Ril/V1uP/fBH8VzF8NWwGNxrniqO
	v231L+GgQ6ZxMhx9EfRtccW651MV/NE=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=I2e9BbXi;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf28.hostedemail.com: domain of mhocko@suse.com designates 209.85.208.48 as permitted sender) smtp.mailfrom=mhocko@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787311621;
	b=XBur2l6X9ijdX8X5O0PZuGhmjJfG8HW2GYzNOJcM18rV21CzBfKOATlg4fDn1PTgVGSukI
	9vtqglEvibN+PJfF7dn96DFyBO/dY4Ev6eU5SDPeSHRzIvZ8jxWcvHcuAQcJgk+EhahF3U
	NZX8v+Q3c/8K3kmtYUc9ggyrGvhNPEY=
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6a41191c9a9so1981713a12.3
        for <linux-mm@kvack.org>; Fri, 21 Aug 2026 04:27:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1787311619; x=1787916419; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Y0+Hytv4UMojIA2Hs8fG8+n+8sWIYR+hpSfJmDuymH4=;
        b=I2e9BbXixFG3yQagMHpzGlI4eHcmwq54JVfatzHeFduSOCZlcY6a6KaLBovYqaxth1
         N/gqpczBf9Z8/vKGBPrUxKttMr9kPn2HaJ6LjH39qu9Y1C4R6Fc0ntwwGoBPLrwm1AzS
         NxNizTo5/lX9pFRBMpYjy8D6VNCHZarfVyj18fId5ez1c2SB1d+VRfBSb30KD+OR56ZU
         NdXcAdUUHCg88LFH0/lbnoxWvBjzjrjzcFQeYJrt0XyiNoT+x2aOo3eDhbQSAeJp5M9g
         pbJt+umRvGD1M8tvUIhWZYz41U0yhD5NGfva8YRYFi2HAQRzZzOlFjRerbxKA1gImTFN
         5TzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787311619; x=1787916419;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Y0+Hytv4UMojIA2Hs8fG8+n+8sWIYR+hpSfJmDuymH4=;
        b=bjCxdQ0lqHltITTYiGyoBVaEE+URyFLA8nS13wlqwa2WPr7WyJmhSrDTGyPjhb40xe
         DSOD+25vsDRhM/ASkglXgG9fj4tJ8bPgYOixoc3Hi7c/didxZhVu8DJF+vLPCJosBZOV
         sHFmtt4PfkXzeF21uBhcuAWCAR6reTGALwI8Qok3Qjf5unkFWTQf+0nitCJyeVK9A2Ke
         XbbrgGmh2S9fwKH7vqgvyyDsBWoXFeWPhJHueZ59EdDym5u0cPWGntE/bqXNl5Wr/+ps
         tcLgJO7zBzGz8Ej8NcYv2ND9hWt+9T4oIJClrFV87EZCa6MHLqhEKg/qkw8DNAYc7qQ8
         dYgw==
X-Forwarded-Encrypted: i=1; AHgh+Rr5IVHjyQPexifX6/e89VlwMamtImH9wGkgBgOMqYd4CiO9BrzY2PqFbU8HVDho6FkNtjdgvy7kqQ==@kvack.org
X-Gm-Message-State: AFuF++kLM0EG722ZodUwXBG4bGiqsiXPKqPlNPMeQZiI2zYGYOfVQ8my
	EjE2OSQI21ZXAeeGARLJLkzSZtQ6IOCZgQVE0eTXX2xs/5dCkq3TLtx+zJ/8VSBoezU=
X-Gm-Gg: AR+sD11BXR8r9RyrJXWHwo8FqCy+95rxtu/P4NIuQt8rRF4r7nu2nB+3q/qmW5gMYs8
	dlA4wY1RBwjZVPEu2B0gdjwAZPVLMLbgTvHfvz08J/eW3RfHtS2xrSTGTauWIi3K5isgJhVL/x6
	WfbkeenvQwMWCsVys9aheDkUjFc8hily/zIaIRzBHf0X0oRj8xXvdEYA7OeeYuyWBteriJ9MAiL
	kdINC04efetie5Pspz7mAZLOQjeB6F1p9UVTMDix6NV8Mgj1iiDmf3KkdpHFB1keAQlySbfccuN
	tGCtZF8dRgOk4ZMRVUbljNIV5T7CEQ+cTCeT3wxiQpfm+Gd+74f+wdn66BErbzBMgVKOKJ5hPtJ
	zJpYmfTvQYJ60vSsTpwyBNkZcjv838RD5LvISzwHSJSltaUC64m0zekh3Mdnci0vIkBk18qaMGX
	88mThVpQvC9l72NAEB2rhOGvCp+YlOL+MG5gDiGFkbPV8yQn/kblZwDZNTG5fquxHIC/0rg+W4l
	gxHh2ZCHGVg
X-Received: by 2002:a17:906:100a:20b0:c16:8799:fcb4 with SMTP id a640c23a62f3a-c246a6a93fbmr429118866b.19.1787311619449;
        Fri, 21 Aug 2026 04:26:59 -0700 (PDT)
Received: from localhost (109-81-81-112.rct.o2.cz. [109.81.81.112])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c24591df622sm433233966b.46.2026.08.21.04.26.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2026 04:26:59 -0700 (PDT)
Date: Fri, 21 Aug 2026 13:26:57 +0200
From: Michal Hocko <mhocko@suse.com>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Ridong Chen <ridong.chen@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@kernel.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Ridong Chen <chenridong@xiaomi.com>,
	Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH 0/4] mm/vmscan: honour node reclaim limits per type
Message-ID: <aog2AeQ2X4KSCkOk@tiehlicka>
References: <20260821081741.1340277-1-ridong.chen@linux.dev>
 <aogMyu5R_DZRqp2J@tiehlicka>
 <aogQ6iDA7RkuTtDG@gremlin>
 <aogYm0fKNsYVyBM8@tiehlicka>
 <aogxgLSLNixXvuUR@gremlin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aogxgLSLNixXvuUR@gremlin>
X-Stat-Signature: esygtkg36eeo1ug81gacu4syo7cqxmph
X-Rspamd-Queue-Id: 004C4C0004
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1787311620-27807
X-HE-Meta: U2FsdGVkX18Yw1Ik5btTwcqvGK7cupY8Vjv+RXcsLzejAh/kuFowSDCMlfsRQDP3EC+TT0oj3mDmB1xPJkmBc4nfWjMJHF6XmHAQkLRrnA2tP9AyUmN3fkmKSsG7IOdGeV3hFqzzWY4wSNZKCUccwSRXKhzYv79gTZjUQfyjpLYBBeQOICKMo2wB+tLE5tayBc+Amta+KLkvdONmlDoi6HJNx/TiGMx2TOMDMoFTHFRR+j9Vv1mOizhJpTLRSad1d7PCaRw6lx4C6UDxtQalVtWbx3GGbTxW69ktHmkiIiE1ODtwtVaJtfCTdQUrqjiu79ak/Ev89mmuV2g5Fs7Sx1atUxHXrdHEGaLpnzghdEnzdkCQYVqMTJ/+ycoR9FfdmuHkSn2V47pmLmoMV7Nf1kUyPif+q4EsmxEo4X/nyPi+jSUw+mYH+5PMhegCKIo8EpBGBt6h2RCq2+pszcyrku4MTyYPiHq7UgSqMLpkP6NmV/A8MAOumBtrBm83WIJH/i2ykLYKAXDOaqq7jOeWuZGL/OSskIkEdINAhfL0TF508tUNQ/6RAaQO6mmoD/n+4qIq1yTu4AXXEWvSqZdHCi71z2mbK1fCXiJV/fz/xmLtED2fPPQAyxVWsJ9pdWrqzkaKf08i6ufgcYXxHR1sMgB2Sx4AVgKpqyHS99QxC2YXbThdYE39zDfdwtvwl8MTGW/16cI9SqFYT5ikqX77semsS5/V4XAV7Q1edqxWEzuQa1o+MPaf+EqD41wtQ0IuEPeJVOXcTmEpxcPmn9//c5lsphLir2sMn9ESCAZlhWZwN1TwHBX1zHBOhEPaaTJOxtZhI7kIPAYxyNIhypqsbrRX+6mB1bDZXRuBVS4vJpmzTJYoIJREd0/SJojlNk7z3MMfXn0otalg/SCBqlmhO9e7tddqpYjkNAnWXMos9Ok9ugYd05WAW7bp+KcKVjk6+FIPGb4fxqfUs/Gh3UZ
 TVcVnk5o
 f9Jjk8Nn0SQEAS53ehfbNfLjWqLR3IZy2/wqFrkrZKpcv/LsS7uEWJwHZ/wKiBryrWm9vbimsNpldmxNwOBA0HTNiXzGwDkfC+33bEVUNQy8aa4U5q+dIkZXZa+hNN2o0KilBcqhcw0LhfEI1sdH2xzOIrp+DgN7FZiv+xLTR4tmzRFd8DpwnBGCfyYFbGLnDZ6c0TPjqeMWuiC3OTJUUPqOsvNmcWoRAce1vlDs12fHQOzlHIh7ViM9F0VChtd0VWC33fE2NswhN3776gpA6itSOgGova2bCUxYSW32jJY1vvMpQF9B1kyvqyXBWxL6kpwcltosPN1+BZR21E5USzEfB9sMREbjsc5RRAwkckdBK0v0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri 21-08-26 12:16:47, Lorenzo Stoakes (ARM) wrote:
> On Fri, Aug 21, 2026 at 11:21:31AM +0200, Michal Hocko wrote:
> > On Fri 21-08-26 09:58:52, Lorenzo Stoakes (ARM) wrote:
> > > +cc Roman for suggestion.
> > >
> > > On Fri, Aug 21, 2026 at 10:31:06AM +0200, Michal Hocko wrote:
> > > > You are explaining what but missing the most important part _Why_ do we
> > > > need to have this addressed? Is this just addressing Sashiko review
> > > > refernced below? Is there any real usecase where the current behavior
> > > > matters?
> > >
> > > This is exactly the issue with these 'unrelated to your patch but' suggestions
> > > from sashiko.
> > >
> > > You end up in loops:
> > >
> > >         AI generated patch --------------->  AI generated review
> > >                   ^                                  |
> > >                   |                                  |
> > >                   |                                  v
> > >                  AI generated 'unrelated to your patch but'
> > >
> > > And _at every stage_ reviewers have to do _additional work_ (with ~50% signal/noise).
> > >
> > > This isn't sustainable.
> > >
> > > We already had _too much work_ prior to the slopgeddon. Now we have a multiple
> > > of that.
> > >
> > > Roman - I really think we a way of switching off the 'unrelated to your patch
> > > but' stuff per-subsystem would be useful.
> > >
> > > Maybe we could figure out a way of funnelling this stuff somewhere separately
> > > longer term.
> > >
> > > (I have I think 2 slopped fixes to rewrite after the previous what like 7 or 8
> > > this cycle? So forgive the grumpiness :)
> >
> > I wouldn't blame Sashiko on this really. Yes it points to a theoretical
> > problem. That is fine. But we should encourage people to not blindly
> 
> I mean it's not only this case, it's a pattern I've been observing for a
> while.

Yes, I know.

> > follow that lead and immediately jump at fixing something that is not a
> > real problem. Quite honestly I even haven't looked into patches until it
> > is clear that the usecase is sound. We should enforce this more and
> > leave patches lingering if they are not sufficiently justified.
> 
> Yes this is a needed change in mm, but until we fully transition workflow
> any patch might still land.
> 
> And I still find those kinds of suggestions deeply problematic for reviewer
> workload.
> 
> If you had a person repeatedly say 'hey unrelated to this series but...'
> you'd very quickly ask them to stop and if they persisted, >/dev/null them.
> 
> I get that passive passes are too expensive and it's not that much more
> work to have sashiko point this stuff out, but it's not that much more work
> for _it_, it's substantially increasing workload for reviewers.
> 
> As I said on a recent call - it's fine as long as you don't care about
> reviewer/maintainer burnout.
> 
> But I do so :)

Hey, do not get me wrong. I very much care about reviewers as well. I
merely wanted to say that we've had peaks of tool driven patches no
matter what. Things have eventually normalized but people need to be
educated about expectations of maintainers. Sashiko suggesting "but this
might need attention as well..." certainly contribute to more noise but
keep in mind that AI driven people are going to find a tool of their
choice to arm them with ideas to implement and post so focusing on
Sashiko is not going to help all that much. My main message is to
establish and enforce a notion that patches are going to be ignored if
they are not justified properly (even if they might seem technically
correct or fixing a theoretical problem).
-- 
Michal Hocko
SUSE Labs

