Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 343BCC61DFD
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 22:27:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0108F6B0088; Mon, 31 Aug 2026 18:27:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F03626B008A; Mon, 31 Aug 2026 18:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E19766B008C; Mon, 31 Aug 2026 18:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B35AC6B0088
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 18:27:06 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 24F0C140271
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:27:06 +0000 (UTC)
X-FDA: 85163001252.07.2B0D46F
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 4F089C0008
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 22:27:04 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gi0AdDvI;
	spf=pass (imf22.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788215224;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IRt+Et4enRDJl2yrF6XadJrav4xwHstUxCtXFADfmWk=;
	b=EM7xMvdtwtOpheI+t7Prf36Zjxw1m0L0LwVlSvWVxMlp0vxOqQH7PuOlICZsRSGa2FO1FS
	2B+vyz10ZKRS4DnBR3KFhrvzFOTrXBEGFqDEZPiKbncUQR37NPSAR7nzHKpkU+PyqG2syJ
	axXK3q2eltivLAoFTQOmkSQJFnBENII=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788215224;
	b=Mr2EbZlsdr01gqbjxjV65HO+SBzlXt/Ye9gJvOGE++QUimw2j1ho74jvZp4PFOYkyen9KX
	dleLNhLWyHxUh+RoADqLKr1pGCqof+ZeGjaJfOFaVv/8yQcAoiUbecqO5cXDXjy9d5XPV7
	GMWl9XCuWss+KUmD2ifJhJZvjuEE05I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Gi0AdDvI;
	spf=pass (imf22.hostedemail.com: domain of cmllamas@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=cmllamas@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2d3b445a84fso18085ad.1
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:27:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788215223; x=1788820023; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IRt+Et4enRDJl2yrF6XadJrav4xwHstUxCtXFADfmWk=;
        b=Gi0AdDvIymBGxaQ0ngMEUn4U6wjCrTF3W26Rt3OKCF6SebjCtkrsXiKqbQT/orXXyJ
         Z+28rs6XyhDV0VQ1HEPo0vpHhAxZ/YL7Nc0EBuI9q7VrFpENFx0vjQLMCGeYewqTbyoz
         bEQuS9NLySXkXaV7F0TC8vF7M2Y2GhwBU+NsHVUYs0t93LuRrHOFHj9RrMkWoNW3/6B7
         HuO19IiIgshxrgYu2z93hQSyNZA5ECnLQr3mFi+X3uULzBXFY2qGBxsNA7O4hSkSIjAZ
         FITJOOtcePSdVOAn5jKnqWP+iqXx51LteuiGQ14F2VgGSYTlbezf0OdVjC2GYS6KXjSY
         RASw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788215223; x=1788820023;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IRt+Et4enRDJl2yrF6XadJrav4xwHstUxCtXFADfmWk=;
        b=c5iMRRKkiuCwIdI0CpLbHmIOmeaOaMAwq/n7/Mjg80/gpzUqePEbIfOzM8oSvveWQo
         OWg5byiSY977F3GHyo3kc8XOrNS3v8EJkkKJ1BcMerHq64d4HQ4hk+bjz5HsBeLIN4ot
         1XX0IbjBp1GC1QqbRO3IzBH9J+LHI1SH3C+68eHPRGQ33yQl5K4lNGV+qLbC7aKta327
         Y6KK+DZH4f3aWa3PRj6+DgHK0GhGEuqwWJsxgB1QnQPc+qVnyvAzh6Em5npD9xmcKLh8
         8xWudWOnVS8LwPZubdUcbKH30iFg/h15XFuXtL5LdJBvULHKdBFWoroWWd388ssyvxVq
         HisA==
X-Forwarded-Encrypted: i=1; AKwUvBw4AhuMZXkG9NcKC1t6yXtzciJ2ERWtvZ90hA+wvDBgTLlw3jfRimC5n2rCXW7X3yiIajr6TmF64A==@kvack.org
X-Gm-Message-State: AFuF++ld2NSprxpufRgJ1cfXdJoKUVAzLD0QLSWr1RG68gDKcXCcV3CT
	baCIQxjBDtJVFfZbwugZVH1RRiNSYrjz+aZHQAn40ltMts9LAdoKZpKumMNoCAPtAw==
X-Gm-Gg: AYBFou2x65tWQ8PweAWHCwrr/+Txxk3gsXglhZmqEpuX/YPXlZlwpYKgnh5mTQa40st
	MoP78F0XLKg+9W7slXcWDWl+7pB6jv61VfwwLe8alx7hJ1VGsI357uFFjhwrdDour80VnoXbEL+
	inbD4vRvUJI2g8oYKoFQgAdXeu0rlU6UvSe2bmKwUQicwykc+KHO47CoqYD7hMUsLz/gewk3mJU
	8h/xWWQb5zWJExa1ysD/xcfXQEOk2py4yrQr0GikZ1QJWKzbCoI5mNhmXw+DOV4hNKDeAt8o5SR
	NOUborad3Cqo1AZwsnjLLIfflaAyIXgfPJBt0dqNW6DB01cZjnLGdTku+K/8m/2S8WTMI48qmgP
	OgPNY2puBU51bkq50uc95wIhcjIKVP4Ts4W7+Bgq8tJlFSna0x51qOKsCgGjKXNnG1gHWwNEubt
	jNmV2i7XvE/d5EXagjsv8GBzm6jLepnEeZlzxttD27IvoAhzQLsPTZpi8YKy8DcQVR2JXgJqvsf
	8KutTLjct7ysWrp/kigS6ZBzxi7setkCJXRl8BcPV/nAAWGtaDfGK7v5O5hmwnoV6we0ki3ixTS
	4w16ngM=
X-Received: by 2002:a17:903:174e:b0:2d5:db3d:1a43 with SMTP id d9443c01a7336-2d95213ffffmr2991545ad.16.1788215222431;
        Mon, 31 Aug 2026 15:27:02 -0700 (PDT)
Received: from google.com (193.67.125.34.bc.googleusercontent.com. [34.125.67.193])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-396d7759bd1sm5651120a91.3.2026.08.31.15.27.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 Aug 2026 15:27:01 -0700 (PDT)
Date: Mon, 31 Aug 2026 22:26:55 +0000
From: Carlos Llamas <cmllamas@google.com>
To: Alice Ryhl <aliceryhl@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Suren Baghdasaryan <surenb@google.com>, dave.hansen@linux.intel.com,
	Liam.Howlett@oracle.com, ljs@kernel.org, david@redhat.com,
	willy@infradead.org, shakeel.butt@linux.dev, vbabka@kernel.org,
	jannh@google.com, arve@android.com, christian@brauner.io,
	tkjos@android.com, dsahern@kernel.org, davem@davemloft.net,
	gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, netdev@vger.kernel.org
Subject: Re: [PATCH v6 0/5] mm: Unconditional per-VMA locks and cleanups
Message-ID: <apX_r59k4e-XiI-C@google.com>
References: <20260813193433.3318288-1-surenb@google.com>
 <20260829185625.f5ee1b2931818843a78af88d@linux-foundation.org>
 <apVhzM2501wSiGGg@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <apVhzM2501wSiGGg@google.com>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 4F089C0008
X-Stat-Signature: 4hjdxwhxshiytr3d6erww864351wbcr1
X-HE-Tag: 1788215224-142694
X-HE-Meta: U2FsdGVkX1+jjQA2YzcagB9L+V1sdnriI9NBDuJBVSxsYb1Pk+/h6LYMuFgaG6uFP2L0Yej2rQOYKMfQAQG5z3ZWE8Qm4D4LM908Qc5LcJnof6+TsXZqsOZqCMZCtt7DgRXcvKhnxlAt2WxMQ4aTCjpwHkl4DYdt6hmMu0TPuBdvlyZbK6xBQNwiOks8rJGS2Kw1Al/w9Pz3P5ptkNOobYhzOaObiPz2g6XReZ8GOMd192UX5CgFH3HWs0wvRp6bbXuMPggOeqnN121pRZjnvtMZXuUl2xbqNkjUUZxR8xC9mA9zIrqESfKE8mJVyk01gu98zsD8Cekr/VIEhkC5D875KxHUGvqS1gFsS8TXU0HpNjDIperkKzqhzvt8c9F7TEllSwBzJTOAaAphWiZ65Va4Gr8ATsLeypjjp/eHuhJ1hS4OX1vcZ7n6Mh1D64RvGjld48mYKSUlaFalRRRNZ3aHVJFnrmuwzgTc/dEPhoRtwpF088nwZC6mct3xeu2am27DfKYhfY1bL9oSBVIB8xKazuCrjGfVFXiXZbT7BT3SRJODQzsvocfdoM85xyUpHiAqua6/0Ccejyl+vbD/sH2MEO+iwzWybhVPx0MHcRioLu+EHqJ83cgZ2iM3Mi6ZBn3gR2JhR0t36BCwXYINBVfNvWPQ/ntsvusaCyuLoTX6Kj3RdXYjEFdeGOyHvF+7JLHlUMoH+b1vLNRwpNhNQKpikZTqukaUbb9vXeZoSjdg+7/JyUSaoqF+joRwxrLBesJdvsaFlweNxpbC3FJRuBGsdb+hpBTSG4iB1g9BpYZ6V5MqG3I21QCnAhg/PDccS7I0JRlQQ6zwNhiSVO2+86mbWzptl+Zjn5pVeiLKZJxGkTAJ7UZWdeaRZfytkrBrk5LwsbW2TXmIoydaCPMdRINo0kILgnXKeDsB/A7XMCDPGHtgdmm3Mc8U/59Hlw3UHvHmaaoZv9TvkaJP5oT
 qEKLATTv
 +p42s4/L1Xp/9qvoXNpraIwp7ybfBffI9BzeZxsK4eqGMcXGqwxUfvKbMylv2sXqcUdrkfzzu6kdAcHqQmx0/4Ihg0Th0w/+TnAzRIpIeAxPSl741Wx38wSze6geiMjVPsQ5AMXemzYCmF/NX4YkI9FCbVVEqXC+KMm5nT6vx9djkMPa5NHBgd1SrXyUHIKNbfSWLrSuYAPrYy0P1ap7GIELIebxvzRyA7ojSKr2pc0Xuz1clxN/L4WZlCW/uekRbttVaDYoi7Jwo8Ix05j1PUuUSN+ofCdpnD9rpmCqCxrTIh2VY5sAEydJTAAuIjJL7RIIh03iYeWgHYzQA30/+CZ+8Gtz9pqme6TUnlHEpIytpaNry8XMPW6ssQKjUc9Tw/s65IaG8Nb4fzG1KybcIJKOXg24VriCQ4uvnAd+zwqAy0f4H0R4INAubADnVKNVHcvrCNbHK3O+/z7avizzAu1G534UOMFUxS1eJ6mGtbAr95eg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 31, 2026 at 11:13:16AM +0000, Alice Ryhl wrote:
> On Sat, Aug 29, 2026 at 06:56:25PM -0700, Andrew Morton wrote:
> > On Thu, 13 Aug 2026 12:34:28 -0700 Suren Baghdasaryan <surenb@google.com> wrote:
> > 
> > > v2 version of this patchset [1] was written by Dave Hansen and per his
> > > request, I'm taking over this series.
> > > 
> > > tl;dr: Make per-VMA locks available in all configs. Simplify some
> > > of the per-VMA lock users now that they can rely on them being
> > > always available.
> > 
> > It's been 2+ weeks so perhaps a refresh-and-remind would be helpful.
> > 
> > But it applies well enough and is adequately reviewed so I put it in
> > there for testing, thanks.
> > 
> > AI review might have found a couple of pre-existing binder bugs:
> > 
> > 	https://sashiko.dev/#/patchset/20260813193433.3318288-1-surenb@google.com
> > 
> > and a small rusty thing which you might wish to attend to.
> 
> The binder bug is not actually a bug. When using VM_MIXEDMAP and
> vm_insert_page(), the vma takes a refcount on the page, so there is no
> use-after-free even if free_page() is invoked without removing it from
> the vma.

Exactly! I agree the refcount on the page would prevent the UAF.

However, we should still reject mremap() because this leaves the page in
limbo since it is not given back to the shrinker and also binder can't
make use of it anymore. I'll send out a patch to fix this.

Thanks,
--
Carlos Llamas

