Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A324BCC6B34
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 14:14:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C56B66B0096; Thu, 15 Oct 2026 10:14:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C083D6B009B; Thu, 15 Oct 2026 10:14:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1DC16B009E; Thu, 15 Oct 2026 10:14:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 983926B0096
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 10:14:51 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3BFA7409FC
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:14:51 +0000 (UTC)
X-FDA: 85325056782.17.04ED983
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id AC575A0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 14:14:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7oT4j2M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792073689;
	b=xod2uT8CqzO2IjXtzOEvWAvoBWWHJLwkAhNNHldQer8u14lzHHw7qZmsYulOnZfJ+bYkP0
	RU3T1fmpCRuM9RohA3ke6AqN3bV2sRu/na8xA15AKDZjHzyzUsnl7eIZsyPc2UOpLFoX9l
	Dh/ZyE/oQbsRjUGBrBl+79nddsNdXgE=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=U7oT4j2M;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792073689;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dEbkmTWrpR6q9/sWzznVAOdz9b4w+GRgYvyg0dkV3XY=;
	b=3y/uYe+2ARBAJu3s36bkSHb1dGvWbiyv0/VfAIXti7M9J+rwU24W8xSY4ewzlMBPm0RCNL
	OuKRhORgnlOdly9YzA+E5XlMl1ykNKizUrPAtaiVVwHM4wlTMNSufyzttyJIdpdmPJMxrN
	mveT/1QLCA9rOcp51Q7GM+GhPJ2K1Us=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F047D418B5;
	Thu, 15 Oct 2026 14:14:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6AAB1F000C4;
	Thu, 15 Oct 2026 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792073688;
	bh=dEbkmTWrpR6q9/sWzznVAOdz9b4w+GRgYvyg0dkV3XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U7oT4j2M/dxRJ5UNhePstb/qD65RJhAQPsJrp+OXO3aFNyn0N4VRuUNGOX8hLBunf
	 UyM7SVGnVPwsvtkw0f3lrVZT4exY43JBzW0zo6cW/wXCLEUThDQZpWnUiftQ/ysYb5
	 Wqhz5xrSpYdlnU63hDvFwcLOoBKxQ18mkZMNRq4ZQGPWR9nlaohdt3b7nKzihXv+OQ
	 8Yzi8UIkB/f+hMP9lgRzHgEx2fCTSlvK9Tvzlj9S9rwiJpyboAwbvE0ZebUUXTb3Jd
	 ukYMmmSomSgg/NxQSSqymmh8CC8QrQ3oNjoxhLcASqIhKEeTByRiBwDmlz7MvTVXTD
	 mAfZLXzrwXufg==
From: SJ Park <sj@kernel.org>
To: Aveline Noir <jm5905938@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] DAMON_STAT: 32-bit overflow reports wrong estimated bandwidth
Date: Thu, 15 Oct 2026 07:14:41 -0700
Message-ID: <20261015141442.88741-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CANOyQmFPJt=-=hJh9Gt-FPG6YiyeidyfUbnW0mF5bSmJ0m7P0w@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: o4rxdiyqfamc4kw698dewbbk13d19ego
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: AC575A0009
X-HE-Tag: 1792073689-544025
X-HE-Meta: U2FsdGVkX1/un631CJACK0Fl2rlkB0mi9OYkEViM2kLpW++m9+AGj7lpMzaMpf0Yn3Cm6gtFkCySsrr5xLO+0oBOGgI5EysybtJv+12yQy/XW2iQ1XCsGmQqRIoViSQh/wZUxtDcH4CPmu4mEqxdEjFe7c2h3qw8O28YmJeq/h+uwNsMivQxAhYllMCH52woyEdE5VNyb7bJNeNPaAf0RujMc1Y0VqwrAeFgeiPrj/s/e0ddmVe3hPxrN4FhKJ9jgsuA6MnQPU6mWmHaK5VFfVjNehXdd+8FrE34VnkPzMsvts0MUl0HNLVsZf2P6GANzri/qPVxMpWdBDX6qhoyWQU8RTRa5x3n/ZJ3eLn3v1SHt6ddliAvXEJL4wu/FtmxFpvOUn4t3TEVJjuAs3Tg8qLvqqNhAa0OwrcXyjZeOfBYUnfvaQwUd2N+Gy/13dYqBJ2wkyf5IpuR+4orruzEDNCiieRaBobHEBZqQ/VML4fxZj4y1VPxzqTO6vE3QHGZkZLrCrI52gwxEAXCNatvL40uJXXNnyu8OV7pKF7T3BqVuV5tidMwTbBHRdW2oySo+7P/n2vAQ+CSKEVKO0RCZnpxZ24TqvrubZFdK48GC4v2B3yEvuum4Sh9Yvcj1L4QreySTCjyjYlC5ifgB0QRD64JRs5XpBOPWW9gTvqZFRhg9bJsEzbNtgkAWK1x+hcVIbmOpgGLJ4yGJZnE/399jAe3VsZ47Yw83stg1FzIDuEiizxuto27Bcp1ypu9jBVXxLA7kh7O5Qd6KDSkfZqb/LNcD/cV3INXwpqW3gE+ROQBIKCxeV6FO9y7OetZ82smv5FqtIGcOJm8mI2CMFARNJb7o9VMPzzaI8rt5VA4e2B3GlIrW8bb1ySHv19sqne7ChIU81RpGcdwOkqP2zcW/UOL/HjxPmmTpdJsLgiR5MpHCS7AW1Kzo3HsAsdwWy5E+bp9cW86RUZy/OPXir2
 DIsxlUfS
 vKSMdJo1TxeAPKR2UAxEHJ3dTnvw9+TTE7/HkTUUnwOmFPnA0fk3jJHDIcT9GXJNK7tc+RKNztJBoP9fbZBu0OQ4Ttn9B/snG4twOrrSDGva8jNmZ8Im+cWfc8q1fqGU2qk5bXYst1EzKv0amonU4Jz1tgdk5EiU+Ogta82r1uXFl36ulkwr15pmrJZAu/+xpvLoi3z23B1y5Wyy7/N3ts6PFURNYF5opeYUC2AHsuXZ7eu6fd6LBwmAGtbB2ZSQUWRIWzekrcbMEkmU+qp/X7/biSg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Aveline,

On Thu, 15 Oct 2026 04:24:19 -0700 Aveline Noir <jm5905938@gmail.com> wrote:

> Hi,
> 
> On an unmodified i386 QEMU kernel at mm-new commit ad9f2d463666,
> DAMON_STAT reported an incorrect estimated_memory_bandwidth value.
> CONFIG_DAMON_STAT=y and CONFIG_DAMON_STAT_ENABLED_DEFAULT=y were set.
> The guest continuously wrote one byte per page across a 32 MiB mapping.
> I used QEMU's GDB stub and the matching vmlinux to stop just after
> damon_stat_set_estimated_memory_bandwidth() stored its result.  At each
> stop, I traversed the same target's regions separately and recomputed
> access_bytes with full-width integers.
> 
> Three nonzero callbacks, all with aggr_interval=100000 us, showed:
> 
>   access_bytes   independent sum   stored B/s   full-width B/s
>       33357824          33357824        31079        333578240
>       65200128          65200128        25244        652001280
>       41152512          41152512        24303        411525120
> 
> The final sysfs read was estimated_memory_bandwidth=24303, matching the
> last stored value.  The independent region sum matched the kernel's
> access_bytes in every callback, so the sum had not overflowed.  Each
> full-width result fits a 32-bit unsigned long.
> 
> In mm/damon/stat.c, the expression multiplies the unsigned long
> access_bytes by 1000000 before dividing by the aggregation interval.
> On i386 the product wraps.  In the first row it becomes 3107979264;
> dividing by 100000 gives the stored value, 31079.  Full-width arithmetic
> gives 333578240 B/s from the same inputs.  The other two rows show the
> same problem at the callback site.
> 
> The workload is synthetic; the test checks DAMON_STAT's arithmetic, not
> the accuracy of its traffic estimate.  The i386 config, guest init,
> disassembly, GDB probe, logs, and build/run steps are here:

Could you share more details about your use case that require this setup, and
how this becomes a problem?


Thanks,
SJ

[...]

