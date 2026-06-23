Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4525CDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 01:30:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1C86D6B0093; Mon, 22 Jun 2026 21:30:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 152E36B0095; Mon, 22 Jun 2026 21:30:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 040F96B0096; Mon, 22 Jun 2026 21:30:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C3C2C6B0093
	for <linux-mm@kvack.org>; Mon, 22 Jun 2026 21:30:00 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 272B11C5539
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:30:00 +0000 (UTC)
X-FDA: 84909446160.26.F02A48E
Received: from lgeamrelo12.lge.com (lgeamrelo12.lge.com [156.147.23.52])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1568140009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 01:29:56 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782178198;
	b=JX2PtjDJYCVCz7VTNvn2qavO9dN/ZX5h11giprw2frGNNrSegHsGs3VmzV8jxlUe+b6yM7
	imHg1iuMZktzDvU5L1JvUnT4H1Lxl3wHNZUA9sGijPuzR/3jvWgCeWrJ5hY/M7WJFYUjDP
	17muSgKTM5XZkGvqWv61CJOpdYbVQco=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782178198;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=bVtT8Z60CmRfiFt3TG8n0q/MjEeoQcxixq0qeXU4+ew=;
	b=sjrazq8c1qr3Z4xNOFhxmv7z0bU37VvXvZ5TgYh/1y79ZNzuMY8nIo8l0+e2EfhQuStV7R
	KfTyU74GIOZVu3mYyuoS3PzJ+4MCiZWw5GTolm7UilnMvbqfMjcyLvZZXKAlysguWdsN1W
	fAeoBMwG2Bg/4OpQJrmyEfvugXU2K+4=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=none;
	spf=pass (imf07.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.52 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgeamrelo02.lge.com) (156.147.1.126)
	by 156.147.23.52 with ESMTP; 23 Jun 2026 10:29:52 +0900
X-Original-SENDERIP: 156.147.1.126
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.154)
	by 156.147.1.126 with ESMTP; 23 Jun 2026 10:29:52 +0900
X-Original-SENDERIP: 10.177.112.154
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 23 Jun 2026 10:29:52 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Yosry Ahmed <yosry@kernel.org>
Cc: Youngjun Park <her0gyugyu@gmail.com>, akpm@linux-foundation.org,
	chrisl@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org,
	linux-kernel@vger.kernel.org, kasong@tencent.com,
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
	shakeel.butt@linux.dev, muchun.song@linux.dev,
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev,
	baohua@kernel.org, gunho.lee@lge.com, taejoon.song@lge.com,
	hyungjun.cho@lge.com, mkoutny@suse.com, baver.bae@lge.com,
	matia.kim@lge.com
Subject: Re: [PATCH v9 0/6] mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
Message-ID: <ajnhkK/dT4MsqyAR@yjaykim-PowerEdge-T330>
References: <20260620181635.299364-1-youngjun.park@lge.com>
 <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAO9r8zOy99szvC4W0+SUv4b3P2UxppJuBeZDV3HZzQuHUc1P1g@mail.gmail.com>
X-Stat-Signature: 43nhms9mb8g8m61hauor7aonhr64n6en
X-Rspam-User: 
X-Rspamd-Queue-Id: 1568140009
X-Rspamd-Server: rspam02
X-HE-Tag: 1782178196-611635
X-HE-Meta: U2FsdGVkX19D2JBoLJ4ixHeGBSM9uojECZ0lVN7OEVLH6+fUa4kMMl0mV8NQ/IivERduXcpn7dqVjor2kCdA0jNQPZ+haMY/6xXLa726IvCvuFGq2dpC+5VrCKH6inS51OIZVgQDr5nGAudbbzMdhEfscBK/yyXuG+wadPHE00H8cLeJpkOWv5kYVy3Ey7ouSZyD2i1mYCynk5wQqpd3uSISMUabYY9JYiWgR/S09Z1ff+PovXQdprq/KsQ8kFDJEqqY40M8naSEHjVWKGYJBsQ4h05+BAiOWsOfRvPk9UYLEYBmPv2uIUGZf0tXsCNb6bEyW3P5r20OezBfSv3WPhN1KKWtK28JfeBrKahQ3/ZMZ+pK9RqRqvyCdLxXNAN7gDOcHMD/tShsd9shoMfySczAJb7ENsh3EUtIiYJ60O9xy479NKpKcO6kjsiJha3Is72eQaB/dts5h5Oquss8Fr8StkbadHjvs0H9l3LpdyZ2BngDyORvNIVu5K/e8+PVBkoH9eO+EiUle1ZTOGrYBqk++LuSdYzbAaI/Cd2vpVlabFj31RN3j9RrnOMTzLfMWQSU8zPsvvfuqDLroJL/7iejygU+1X/8saPEAkh3oZ6cb+AXE8CklxcMOa/CJB0RJA9slk1NSOttCT6k8KFuwKmy/AArASL04zC6fOByTWlvfhoBPI6Jncw7Cs1/RkPrwaT02OqXQy+Bo7ko15rXkuzlGFxy3xGVDctzmOfgUCUeuvC3NSGRwUPnhezz/14RJPZZhFtWUiZ+XWP6TutTkQmpB7Kxgjzfjgy6ONMowicJ6LXZNWHeYiXpCxBkYwlrDQU2IdH8m9W8M8Hna0aUXkVlx5SNoX+dxMZgfRkIBgnA+R+kE7+f9a2NJYha2cOv8Ax2yiCqOmA++H8nSWMEJ18uQCUveHBrgDxU0kLMf4nI3RMkQ+Wsgz7myt4tbNxrPuB++odb6v8F0SjDtot
 CwDs/QjP
 dZKRnnzSz+SdvVCNlT5siSNvDD2TIElyztX+MVY+RU//f4dCPZWzjMqHOxYkU4goCA46sohuukYnLpq3kDysURHz2CxmsxKoMbIE76K+6tW9YABpLjQqx9KURG691C4LwNjGDL/C3X7Qb0ohNRjvZfIpfy/1UW4sb/E+QIifqG5SibHKQwSv9pGvy6d8cwYm4ax+sum7k84ITHuhyvR4xJJpw5sslIR4DUE2rE3tfwJeW3p8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 02:23:40PM -0700, Yosry Ahmed wrote:
> On Sat, Jun 20, 2026 at 11:16 AM Youngjun Park <her0gyugyu@gmail.com> wrote:
> >
> > This is the v9 series of the swap tier patchset.
> >
> > The main change in this version is the addition of selftests for the tier
> > interfaces, requested by Nhat; see the changelog below for the other changes.
> > I designed the test cases and wrote the selftests with some AI assistance.
> >
> > For context, the bulk of the series is unchanged since v8, with great thanks
> > to Shakeel Butt and Yosry for the reviews and discussions [1] that shaped it.
> > The main change in v8 was the interface change to use memory.swap.tiers.max
> > with '0' (disable) and 'max' (enable) values. This mechanism was suggested
> > by Shakeel and Yosry.
> >
> > This change allows for future extensions to control swap between tiers and
> > aligns better with existing memcg interfaces. It is confined to patch #3's
> > user-facing interface; internally, patch #3 still uses the existing mask
> > processing method, which is implementation-efficient.
> >
> > We also discussed tier extensions. Thanks to Yosry, Nhat and Shakeel for their
> > valuable feedback.
> >
> > Here is a brief summary of our tentative conclusions. Please correct me
> > if anything is misrepresented (details in references):
> >
> > * Zswap tiering [2]:
> >   Tiering applies only to the vswap + zswap combo. Zswap itself will
> >   not be tiered, as the current architecture requires a physical device
> >   for zswap allocation.
> 
> I thought we agreed that zswap should be a tier, so that proactive
> zswap writeback can be implemented as proactive swap demotion?
> 
> The only restriction we talked about is that zswap cannot be the only
> allowed tier as long as vswap isn't supported. We can lift the
> restriction when vswap support is added.

Okay, I misunderstood that part. Thanks for the clarification.

To summarize our agreement.
zswap can be the first tier regardless of vswap support.

- With vswap: zswap can be the only allowed tier, as it can operate
  independently.
- Without vswap: zswap cannot be the only allowed tier, as it cannot
  operate without a physical backing device.

I will proceed with this understanding.

Youngjun Park

