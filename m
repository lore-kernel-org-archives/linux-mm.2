Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18DA6CA5FFB
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 07:48:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ED8A6B012A; Mon, 19 Jan 2026 02:48:19 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29B2C6B012B; Mon, 19 Jan 2026 02:48:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 19D586B012C; Mon, 19 Jan 2026 02:48:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 05D856B012A
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 02:48:19 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 834B7140693
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:48:18 +0000 (UTC)
X-FDA: 84347935476.17.6BE275E
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
	by imf28.hostedemail.com (Postfix) with ESMTP id BD1BDC0005
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:48:16 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Bv81rIR2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IcfOFdBp;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768808897;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4nyquV9IFp9+ZLI3g6GqUmUmB328l0PHMKo2ZocZs3c=;
	b=RmAdNo3tjxMZ7UoB87xQL0pgPTiMuVtXL1I3VxDiiOfXFd9p0N89p9alat2F3GSP2yv4v/
	/n+cqwbK7w3pHW824zWAIT3JoU4JIgCaGWpxRllSh2fTOKnp6ZM0t1nmaSOCDR06u7AgOO
	e26YMEvUAum7KwCeBclYvojczSNAxos=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768808897; a=rsa-sha256;
	cv=none;
	b=jyI2Xkinjga8vxWk39gR5ivJT1Xxf6OIeiAZayWa6Y/dIyuCHiHHKLy2imVG856du5Xy4y
	HKdV39VqcSRnRZHHeWHPpZdOiFKSqH/FVBTc9H4s7JYYptV9KBkVb6k6Vt+Jm2IPh9fBjR
	tW6pHPGIPP2cotaiOtfoVW3Fs9yrtew=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linutronix.de header.s=2020 header.b=Bv81rIR2;
	dkim=pass header.d=linutronix.de header.s=2020e header.b=IcfOFdBp;
	spf=pass (imf28.hostedemail.com: domain of bigeasy@linutronix.de designates 193.142.43.55 as permitted sender) smtp.mailfrom=bigeasy@linutronix.de;
	dmarc=pass (policy=none) header.from=linutronix.de
Date: Mon, 19 Jan 2026 08:48:13 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020; t=1768808894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4nyquV9IFp9+ZLI3g6GqUmUmB328l0PHMKo2ZocZs3c=;
	b=Bv81rIR2pZAs9TIDBF5rKWZpxsY2yA2hAbXgEtGAvpbo5L/SPxv6BhexP4iJINZ9sQmYAN
	swmNZZ3CGwNadUiIWH2Q67pgjJEUCV9cX5VHqSAo5gYpROW3FWuUDTVjFiwY1T/wnOCgTt
	anW/W2g7/klFNi5o9lWe9dAHQVh4a0dkhxsj0aAhwkaO4Czo/RFqdoG/m++l7ZPQmMlvY8
	bANc11dV035+QQ4rl75p+zVXWwdoLME3FbZi0/9PD/otzWlIaBhOTUd2SNZRZSIo0ULQRY
	sCWyyVT5TwIXO9RbhCnLaGrxl98j5bMZ8oWhNfwHhUx4yB5+HpCxBxurQFl3lg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
	s=2020e; t=1768808894;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=4nyquV9IFp9+ZLI3g6GqUmUmB328l0PHMKo2ZocZs3c=;
	b=IcfOFdBpzy2Qqgay8Es8uS0xjVyqhcHbAtbnCTUV+AFwM9H1b/gUzNWrpqm9+kBEU5HKg0
	4m50jDF9QZb0qaDg==
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Dennis Zhou <dennis@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@linux.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] percpu: add basic double free check
Message-ID: <20260119074813.ecAFsGaT@linutronix.de>
References: <20260116023216.14515-1-dennis@kernel.org>
 <20260116191548.7df814c2a9eea1a9fa3c4cb5@linux-foundation.org>
 <aWsa9SdO9kLJTfz4@snowbird>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <aWsa9SdO9kLJTfz4@snowbird>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: BD1BDC0005
X-Rspam-User: 
X-Stat-Signature: mpns8eqqeycsdde8wfr15f7ra4g4tcm8
X-HE-Tag: 1768808896-276848
X-HE-Meta: U2FsdGVkX1/3+sRYKYGC4QiLW2XDiaaov1Bl0hsfiOHcY0RIz3XPVHMOwY03sLKezyAfjZbDxZF70oAJZpWZ0jw5WmAt0nPEVGtnhFSORVkKV9BMMgSYvXzUniB7LXjquSFabAu4r5qd9pcP7sq3rm91PdD6/xiRYy9bNfe+0PLCBoAcZ1hiU7WZRaDw6IJbfU33kyuWY2uOXobW8yQflAbEMufw3XO5rNHuO1Kv+hnuRdfoPOJ+uvo4oT5MY5lFb7OAZ0BaTRq5gqZjEV/pFRQuLIrM/gvBiy/IUnUCgpV3U0ttzZ923z+0C1RZh+lAA8XyS+SEurw5rFLoJLr2S/20DYEBslQ+ykXOw2XEV36OWvN7dC5f+wOyGCUUucZwf39097GnmZjKiJi36OamlnygBNx+EWNBZ9qz/Y9XgBAsz5o6TshXvOe516JN02pm51NFHUF9u1UnDL2pivK7SMudZpGS3NshB0AIo36YbCOT59t98lVB1NP8kJ+yAgJuIsF+/pfJnrUMAKfazqNjj6C4HYFgX5pn+0+6QVC8KIyYfzsF5iWPEQ7orxwcCS7w5Kv0LrIq/s9Siv9WmAx/fi+mwlnzxne8tU7HEm4Ulj8hnVveZ8HwaEV0F9fU6Myfcopke+nhtRyvtkyZ+AwHayP5cJf+WRAYllGUSRfOKbxvTgQJVtaVvXXG2+7y8fjoYsFdW44p3JpZhbYHOoJRkJFK+PlDBvi0dXqYjFxlgLRYFYNjPvxuMd/8NEstFW3IHWwJeln1GjscT260IayzvzmVtmrdGPl7nd0bVwC2foVcCZJk0weA2vlpbtdzMG0Iizs7h222FNqC96JUwY7JZ4mj3zByTtcTV/zAlr6CAQaILMq0xvCOVDmCQ/8JAqDYwPSG03wUigl97zb298aVHpEulBLqAglV7yM8E4xQUqa+wgtZnh6BxkNzY0P7QGRsX4hSkfy58h5pt+7LWL8
 KHO47Shu
 9cEPIeYcaEWlSJbBg+DMZvFVcBrJpNVlF4XEoa2CaTuto4NxUpEePxcEbK9ItCAYshQk4K0SpU5TyXr/2VnPpSnRbm9X4Y8BEPu6il9vfjiSv94X2QNyRo79z07MKahbEgdr+OLss/0CSYwYJSxNwN9kimg5/Li5Tk7R75o6Rw6Lw+ghWOZ9qQQTFqYKK4w6fAxcq6mBccFopoqkfm63VsJkmuw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-16 21:15:33 [-0800], Dennis Zhou wrote:
> > The patch does appear to do that which it set out to do.  But do we
> > want to do it?  Is there a history of callers double-freeing percpu
> > memory?  Was there some bug which would have been more rapidly and
> > easily solved had this change been in place?
> > 
> 
> Originally, Sebastian posted he ran into the issue where he double freed
> in [1] (linked in patch). Maybe he can elaborate how that bug was
> introduced.
> 
> Wrt do we want to do it - I think it doesn't hurt and makes it more
> explicit that something very wrong occurred. Percpu memory really 
> expects users to be good samaritans. If you do happen to accidentally
> double free without the warning, in a contrived case you could
> experience unexplained behavior for some time before crashing in a spot
> that would leave your head scratching. If anything I think there could
> be an argument to fail louder.

I did write some code and there was a free path I did not expect to
happen. While it was rare to happen, it did not always crash right away.
Once I had the pattern I was wondering why none of the memory debug
switches did something. 
Adding this does not look expensive, allocating per-CPU is hardly done
in a hot path so I did not add anything but I don't mind hiding it
behind a config switch similar to SLAB_DEBUG.
While we do have way less per-CPU allocations compared to SLAB, I think
it is important to have some kind of sanity checks for it to ensure it
is used properly.
I would go with a WARN_ON_ONCE but if there is a desire for rate limited
multiple warnings, fine.

> [1] https://lore.kernel.org/linux-mm/20250904143514.Yk6Ap-jy@linutronix.de/
> 
> Thanks,
> Dennis

Sebastian

