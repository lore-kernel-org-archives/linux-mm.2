Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D82EEF532E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 08:05:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 265EF6B008A; Tue, 24 Mar 2026 04:05:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 216426B008C; Tue, 24 Mar 2026 04:05:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 105566B0092; Tue, 24 Mar 2026 04:05:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id F29576B008A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 04:05:35 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7D2CFE08D1
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:05:35 +0000 (UTC)
X-FDA: 84580222230.29.2FA30CB
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf22.hostedemail.com (Postfix) with ESMTP id 8942BC0005
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:05:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W1mtzGNm;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=pmladek@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774339533;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q0NpOffqjMqcV8jV0/vhM5nPOC+eRNL/BePS9aFCdNM=;
	b=xhhUeLlQYtBQ9tZ0FStztzH4jzp1/6cwW2TDTLXS+Z1oko8in1rUFiOhP4m2A6oJkyFgda
	GrwvX0NUbGpnyHMHcAikKiS9aOao7hCOk9XmuHKQhcl+xr1C7XdA8IEr6euOKezNiOx4Ae
	KFl4+N8iIO81anS57sWFmM0Llmey5hk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774339533; a=rsa-sha256;
	cv=none;
	b=eGTHmcxro8cY2AISKT4kZ63pfONDh6RPCi1DDU0+CB+43SSUc7XCY0QJl3MVHBh2vTxlJY
	fLDJ/twqwn0H00xunOd+qZ36Fl9g/5e2uZrvXieLVmkvgfIVcpd3iaBZLNwTbTenALTbox
	9UetbilEVuKq1LNdEFBzlvhBipXmSNE=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=W1mtzGNm;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf22.hostedemail.com: domain of pmladek@suse.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=pmladek@suse.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4870206f73bso20421415e9.3
        for <linux-mm@kvack.org>; Tue, 24 Mar 2026 01:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1774339532; x=1774944332; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Q0NpOffqjMqcV8jV0/vhM5nPOC+eRNL/BePS9aFCdNM=;
        b=W1mtzGNm2u8oEwxbIHKMhCFwGVB9gUsxPrDupXnK/QiWoqoBh6YjNLIOjjZZzlxs6g
         c5YXVrmEfl+Y4YLh9iJc6rkIKwEYNfC8YaeR6wreBa2/erNRY5juuEucGbRY/BxZQBhY
         PkZC1VD5WmbKE5KHpwmVPGebeWm95GXdNrKSNpGVzi2N1CRzafoeM8YrHWCicDMGz+XU
         UsfzbzlljnpcBvJl9Fahtc4OEYsD9Ywgqea9VOaXczMLMuSLy1ZoAhGaSpuq0QLBMvZd
         tmhalvCHkv4/Qsj9g+fDd2wdwSqtoLxWrAb/fY1mwMEnunWT9ht08Nabe53S1jCpF2Iu
         hesA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774339532; x=1774944332;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q0NpOffqjMqcV8jV0/vhM5nPOC+eRNL/BePS9aFCdNM=;
        b=qF8PtIJsVVDZUdM99qTJyTTlKPpzPl4WAaxBXdDnaPsur/BfBqsWD2q9DYyr4uvS5G
         upk9A5Kx6ROv78hNuVdW5Kaovcns+4la+xkpMab41zYP0llDpZrpW6O884qBtg4g0rIn
         9R537PBZFTjjmYq84O/Ko/BfL77qGO5GSncVNE5hlBbGHagaEluoXp3SQaWLA6Btn/2w
         v0bzV1w/JUreq9i6d56sFJRrE3JfNYNjg3IrhFvTR9Y7yHymG/vSlO05CZcvMXwF+4MZ
         qqxtD7hIm5MUd4WKbxBubZh6NMUj1o0QDtaDqxePVHW1+v9xTx1lo11mKXPFXQWyZ9+u
         bj8Q==
X-Forwarded-Encrypted: i=1; AJvYcCVr/mbCCHoS8FMeo7gd7TBHbz0d3kVIO8AD86KjSG3qhBWLSOSWbnjnwMONheTpEOap0JgC0QPbXw==@kvack.org
X-Gm-Message-State: AOJu0YzmZQKwk0ulQIgcUPO71A0ksd1qsCxzihOsZYr06gG2DShvdwOs
	LZyBCK53X0QRUIXjn/+0HHjjPfkRdJco3mwe22oUgf2WMwyo6jVY/A0pRmdcpnDmOCw=
X-Gm-Gg: ATEYQzys0deYslFT9SqO5e6W9WRlE5LEiP+jHhb4cqUqwAmBgWQ/wqDS9JfFLBj+c9Z
	dDPlojXKn/p+kjCx3PFm7kNBVThRPnFVyE5YSQiMK41G6cLtpD1JOVgQAd15fv/6AaZ18cp1694
	Y5LygPqpgQVxplMKRSMWOAXtcEVZU5f39t95bZuBL8lucCRcevfR8plL/A7mN8+pkyOhDAniaEQ
	KVjWfnpAiX+16UZS5tCrqqA5j01t6RAb3cZvPq++DbST63cb1aKaMKnbcjSCVvYI8plbl/owZ3B
	+Yr0fKbA7izh+JN2MHMzpJDQpMzGfzT38JMPNrjyRqb2poOUsXst3jig9eRirKL+agUJ70q6m1L
	eobALVchvL1kGDOMUSrsaimGoFNnTQY5yOBXRhlNiWZIGqRpn603f0oBC/pcQ+B+vxx07Q8KiFJ
	cEVTwUFxiO+/opNTZQEquc5aiTWw==
X-Received: by 2002:a05:600c:3549:b0:485:3fe6:21f5 with SMTP id 5b1f17b1804b1-486fedb5928mr203551635e9.10.1774339531769;
        Tue, 24 Mar 2026 01:05:31 -0700 (PDT)
Received: from pathway.suse.cz ([176.114.240.130])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4871105d17csm14847475e9.14.2026.03.24.01.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Mar 2026 01:05:31 -0700 (PDT)
Date: Tue, 24 Mar 2026 09:05:29 +0100
From: Petr Mladek <pmladek@suse.com>
To: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	John Ogness <john.ogness@linutronix.de>,
	Sergey Senozhatsky <senozhatsky@chromium.org>
Subject: Re: [RFC] mm, page_alloc: reintroduce page allocation stall warning
Message-ID: <acJFyXIaMspV383t@pathway.suse.cz>
References: <30945cc3-9c4d-94bb-e7e7-dde71483800c@google.com>
 <acFwIJTk0L6CWuW2@tiehlicka>
 <9c21e9e9-7347-18cc-9dd5-76fad75719dc@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9c21e9e9-7347-18cc-9dd5-76fad75719dc@google.com>
X-Rspamd-Queue-Id: 8942BC0005
X-Stat-Signature: xtqnssurzwe9squf1xtrsacorxd9apqn
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1774339533-695853
X-HE-Meta: U2FsdGVkX19Bs/67XDLGdoKPt+SyA6jQ+JpG0drCg9A76ERzKMAtmjPMt9Dv0IkATyyx7jOfawQpTi0jlIAkz5K1IzOH2WLsYuex7OPPMmmvJ/lpqvStl3kC2VUkd+dCJk57gBJheBZm4SoGJPqUXNVyN68ilY1BlI/wmh29aqghrVatiBEmB1XWuv9H6gEF6kGula0QtqHzZGwXGFN7rUfKFHdQfaghGtYPowMr0KV5h7nNPMlTbEDVG+7xiKZBfFZ6c3b09rEFZcHD3539pWBtCIkXnZRAzUr5oHFo8pelKiUtjHydh6308AROqOPRuPe65BBoOrpCarLE/ezWuxLBrr1y9t23d+I+LiuQshT1cSauYxeEdWiJUwLl68LeEAONIsUkk/M7wD/5tMppVlXFlcBZrcbUaaSb9VOAPHy4X55IAibnEOfnchZ8oBGiTC5QI9gQZaYA2AwS7DXmTBVsyFt7jj1gDcvg1GKkTZU+rUgJK5MIZblvxq0DE77llgOkr2ohUdHa0bGxxxRA7SzraJHFiXtWX+bOTSSuVRjrPA3prBtX0iEav32MmhCV18RZOFDGb+LFgjUUo2Xgc24eec7wIdJKlEUWeotNGRwHcZAR18hVOb7Bu4JDZ0sytjQ04LjD2HU/e2iWOMxwzj2nOKVp6/Q0tJAIVAbNSHLwmoRbeXHO6mxEcuUYTxTRjC4nnb7gE+s71re80PhA8GjwLgy7pzm5OgXAEUymOybXddv6VL6epW4VHv3Aa49mfz1og5L3PYaqowqec/MbSWP6qVomse/zmrhdGhE1Ov+PX2J9s1MnG2lVDQC/7IKfaeYTJ0IVVBdifBHR8audo64GmolYIIaVQXsD0ErHb0xVwH5puGiV95Oj0UrhET53+h6RHxCdOnNMXsoyfpvZ1POT5vB3kAUVflgFygwKh5AX43cJ2Rckbiy0Lx1ElbkNb63P8Ayn2iVAJr0Rxzb
 NlOC71Pu
 g9S97C0jVQQK5PtSnHAigslZbbIR4jP2kKTZQvLd4w8l/tpIZOvparwfKp5yjq1yFJDOZx8e94KQDTEaWAILu6RuxTGG5daG7NjWJRM9FyoZb6rovMmcCXr7st/y45ZjY+P90hUEuheCyvXXELWPVVvDhAkYulO+oUuevCxIQQ+KKdlJcSD2s95qxkyg4Hpo9oc+kd4tPp/Rk2tmX7OjNVc07OEw7O+2otQYW2CAbPnAk8sifGga1wNyKnDGVlefsbDv+VpDeSuzDkmp94ThlyZgzxEEzbXX9HLCNvYpWOLSegzlWe416ggKjYtjD8Hho81On
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 2026-03-23 18:13:21, David Rientjes wrote:
> On Mon, 23 Mar 2026, Michal Hocko wrote:
> 
> > On Sat 21-03-26 20:03:16, David Rientjes wrote:
> > > Previously, we had warnings when a single page allocation took longer
> > > than reasonably expected.  This was introduced in commit 63f53dea0c98
> > > ("mm: warn about allocations which stall for too long").
> > > 
> > > The warning was subsequently reverted in commit 400e22499dd9 ("mm: don't
> > > warn about allocations which stall for too long") but for reasons
> > > unrelated to the warning itself.
> > > 
> > > Page allocation stalls in excess of 10 seconds are always useful to debug
> > > because they can result in severe userspace unresponsiveness.  Adding
> > > this artifact can be used to correlate with userspace going out to lunch
> > > and to understand the state of memory at the time.
> > > 
> > > There should be a reasonable expectation that this warning will never
> > > trigger given it is very passive, it starts with a 10 second floor to
> > > begin with.  If it does trigger, this reveals an issue that should be
> > > fixed: a single page allocation should never loop for more than 10
> > > seconds without oom killing to make memory available.
> > > 
> > > Unlike the original implementation, this implementation only reports
> > > stalls that are at least a second longer than the longest stall reported
> > > thus far.
> > 
> > Am all for reintroducing the warning in some shape. The biggest problem
> > back then was printk being too eager to stomp all the work at a single
> > executing context. Not sure this is still the case. Let's add printk
> > maintainers.

printk() is still a constraint. There is an API which allows to
offload printk() into a kthread but only few console drivers have been
converted so far. Most console drivers, including the most common
uart 8250, are still using the legacy loop in
printk()/console_unlock().

In addition, the new API introduced an emergency context which forces
synchronous flush of printk messages even for the converted console
drivers. The emergency context is currently used, for example, by
WARN() or RCU stall report. So, there always will be a risk that
too many pending messages might cause a stall.

> > Also it makes some sense to differentiate stalled callers and show_mem
> > which is more verbose. The former tells us who is affected and the
> > second will give us more context and we want to get some information
> > about all of them. The latter can be printed much less often as it will
> > describe situation for a batch of concurrent ones.
> >
>
> Based on Vlastimil's suggestion I think this is trending in the direction
> of 10-second reporting windows system wide unless that doesn't work for
> some reason.

This is a wise idea.

> I do worry about reporting many stalls even without
> show_mem(), however.  In situations where the allocations are
> unconstained, all userspace goes out to lunch for 10 seconds and that can
> result in thousands of threads all reporting stalls and spamming the
> kernel log.

Yeah, this looks scary even when all console drivers handled messages
in kthreads. I believe that printing details about all the stalled
tasks is not worth it. It might be enough to add an atomic counter
and print the number of stalled tasks within last 10 seconds.

> Idea is a 10 second threshold for reporting stalls and then only one stall 
> report across a 10 second sliding window globally.

I wonder if this even could be added to the existing watchdog,
aka report the number of stalled allocations in watchdog_timer_fn().

Best Regards,
Petr

