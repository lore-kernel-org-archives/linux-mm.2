Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0888EC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 23:23:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1B7856B008C; Sat, 29 Aug 2026 19:23:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1690D6B0092; Sat, 29 Aug 2026 19:23:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 057EA6B0095; Sat, 29 Aug 2026 19:23:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDB0A6B008C
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 19:23:55 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0D5C1A01EC
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:23:53 +0000 (UTC)
X-FDA: 85155886746.06.1ACF3EA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 0EAAEA0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 23:23:51 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DpOSND2m;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788045832;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=49gEV2enQJtI6Pn8/a36/WznBZaUenfunZ5KLnItoNQ=;
	b=UycF9gcQaEKGIdq6aAORsbN8bBlF5lNiS3ISqERUDLsemH+L/SPFwUEDb3GT2WWDy3VSoT
	L6AixB/PuTyK2jIF7F3QB8XHPRn6rrfKRLgeO+iLZMsi4i9WnjuUjQ9XGzGrvU3KqC2GtO
	T6vaUUbTg60e9yWkWsz8yRz/Fh4yL+E=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788045832;
	b=o1mPpyI4vXGAxZ4rAjsdPX82lrltuXYnAs14fBMO54d3i+62k4CAQzS0UoHZLycOkoRmcm
	JWNNsxpM4IeRamIyJmpvP3iD5uT7nGwqXMgjHMCFINPV+GgEWgLIMH1SsEkVmYB93RpwS0
	AFkxkA9V3bPb0PRdIcq/lquILkHU41U=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=DpOSND2m;
	spf=pass (imf15.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 7E4C8600AA;
	Sat, 29 Aug 2026 23:23:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6E441F000E9;
	Sat, 29 Aug 2026 23:23:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788045831;
	bh=49gEV2enQJtI6Pn8/a36/WznBZaUenfunZ5KLnItoNQ=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=DpOSND2miLdB1GD5NgJn8Stt66Q+x8L4/1SQCLOD5EQ3kWTnN/TrSIEIfa5MfX6LU
	 sONM0Q3H4a1+VLJ00yg8SklvsdoZMBWr4HhzvLTHFrUOHXBUoZ23UXcirnTwWzqtTN
	 i3r6cI4OE2Xvfv/Q7cD0BU7+VzIvg587WFDWUg3U=
Date: Sat, 29 Aug 2026 16:23:50 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Qi Zheng <qi.zheng@linux.dev>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, usama.arif@linux.dev,
 brauner@kernel.org, david@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Qi Zheng <zhengqi.arch@bytedance.com>
Subject: Re: [PATCH v4 1/4] fs: fix missed removal of
 super_fs_objects_eligible()
Message-Id: <20260829162350.1ee9e17d71a297b06b171941@linux-foundation.org>
In-Reply-To: <eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
References: <cover.1786955972.git.zhengqi.arch@bytedance.com>
	<3b038d373c70ebac7cdabfb0035bb91d1d6e6cfe.1786955972.git.zhengqi.arch@bytedance.com>
	<20260828114129.909edbfb7e42b36af2da6a98@linux-foundation.org>
	<eeae0d48-4d50-4dd4-9e16-b4f9902d84f4@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 0EAAEA0004
X-Stat-Signature: fdmui51zs3eo6drzpheoqgfmu34z9mhz
X-HE-Tag: 1788045831-22746
X-HE-Meta: U2FsdGVkX18xquHu0La8iI5PPYzBaHQECqXQmiS03OAZtrqm7VL/rkC2YVbMWGjwcgCndMP/urTIepz41TlkNMifHT6ios65N6PxfWYPwGrJo5SQ5F9P48o+ilrAAJg/nuWR3ipvnRYyhx+ou4t0k4FxryVQ2iMN2dyXs3J2Oye0mEwNMBtf7AcSpZYi5y3XQx9mhDjlRy4VGfaPw83Dqb7JZnXz3UI2DvkzC16a8eZxG5OVK4gbRV/SKathzPoSq/8WipHfxNFUeIEIhOcSnDkxAedtn0QsN3iunWgeCvRIZsqeCO/53k37rylL0K096iS5rGV9TUzwknfCgHQByOjswHsNc01INhMhj3BsziFJ/V9lo+QGeqbiueonHpgonlqYto3pnkzNejboak/eLF4DPjLkcMfr2PjBUyM1fKs7xK9WFKScux6rAQKfkdsIIA8bdx41DaRafd9B9OSJX24Uppx2UvKAv2+j2COFvip8roX6ZZCUT6xX10Sl2NEVYaZVxq0zh4ZOrOzRRQhzJkg0FHZscsj4WUYtbctXMNzcWu/W/qadSN/BlEILDKVx1tK6/QkO1xjE4o/oEJQPJjSQU41+5bbVfGfejIhuqAmRqQna2AH5C2FqG8NaXnaIPx1cD8dMShQB/96YInVLwRIFa2LN4KsCQrt5/AHkjGenDu99AiTXkg8aZE6BbDlVexHWnFXbZrbR4ciJMLmfxGUbumCb4RH5c6Gjj/EQyJYV3eKSHpiCoHvWyhXRpHqPNmXs75q7PonjhO4M3hsJKxJGJXQCjeA0MqETHDlotSzfqFT4HLhDhZpCHGRtV/s8Kr+SCK81Se4nX4+vNEwDS404lzdU4ETeW7OazqsgvHxjfwP69w4uZMZzh/dMfCicpbneyNqpyu5mgao4uxO+6PRCoPRF+4quuS0G3nYReIRzCRbLMC2lx/cUsRZRyxYnSI5PHaGJjKoSVHbWQ1I
 BkWsvXir
 M6zdDt0YhnMPsozARHgBl1QsOITXOOLwgGVGOyB+Udxuo/wfAUP5M2/60lgpFSf5n8642BCAs0Hy/0LuvzrpfonKAFVuNOOnOzK2U/u31JqNGsndsPP/8lZQPWhBU5MSDDEmTOBvsEx2FCfaRvFhp5uzYKwrxVJp8LjUXB4T9qQSAjveKFmUuPLp75Oy1EjO5IKDQG0derIQ9BkTEEkd3aGkSyzucPUmJnbGa0yz8kXVE6dVn/0Ar/oDacUOTAq/ZxP45Ok2o3C7o0CWjsiEOrSaCzzUzVTgLace85gbqx1nfzfmR4dx2d9HOcUhtIkLOebGz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 29 Aug 2026 09:49:44 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:

> Hi Andrew,
> 
> On 8/29/26 2:41 AM, Andrew Morton wrote:
> > On Mon, 17 Aug 2026 17:03:25 +0800 Qi Zheng <qi.zheng@linux.dev> wrote:
> > 
> >> From: Qi Zheng <zhengqi.arch@bytedance.com>
> >>
> >> Commit 0ef8faff490be ("fs: push nr_cached_objects memcg gating into
> >> individual filesystems") forgot to drop the super_fs_objects_eligible(),
> >> just fix it.
> > 
> > Oh.  Why?  Please can we have a description of what's wrong with the
> > current code?
> 
> As I replied in another thread [1], this fix and commit 0ef8faff490be
> together make up the complete patch originally sent by Usama [2], so
> they should be squashed together.

0ef8faff490be is upstream so they can't be squashed!

> Without this fix, all memcg-aware
> nr_cached_objects() will be skipped during memcg-level shrinking.
> Besides the newly added memcg-aware shmem huge shrinker, XFS will also
> run into issues.

OK, please add this info to this patch's changelog.  Please also decide
whether a cc:stable should be added and if so, ensure the changelog
makes clear why we're recommending a backport.

As part of this, let's expand on "XFS will also run into issues".

Thanks.


