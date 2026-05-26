Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B35FCCD5BB4
	for <linux-mm@archiver.kernel.org>; Tue, 26 May 2026 06:10:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1EDE06B0005; Tue, 26 May 2026 02:10:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 19EBF6B0088; Tue, 26 May 2026 02:10:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B4A66B008A; Tue, 26 May 2026 02:10:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id EFCD26B0005
	for <linux-mm@kvack.org>; Tue, 26 May 2026 02:10:05 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8A9B91402AC
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:10:05 +0000 (UTC)
X-FDA: 84808545570.02.D5FFF8B
Received: from lgeamrelo03.lge.com (lgeamrelo03.lge.com [156.147.51.102])
	by imf28.hostedemail.com (Postfix) with ESMTP id 83D4DC000A
	for <linux-mm@kvack.org>; Tue, 26 May 2026 06:10:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779775804;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iJQqT8UCzVo5WQp27/yLdiHJhJxRRxeDWDwAgz3p4ew=;
	b=WEmoh4i0XKlZ+jrAa5UpRBwxl+03GCnwSu9BhGWKr3FP1Qs/xFHPmEdyQeJ0Pcy3/G/Yfg
	TibmVP8mFvUJwrEvVNeKjuedZMkoF2UaoJcodOEe+UyEIuGRhIw/UPx28bDaLyuDpOnE0o
	icVR9QxvCChmWc3nnfHGvyC7IFL+ys8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779775804; a=rsa-sha256;
	cv=none;
	b=E7JAo0MuhDYbX2nfAPTsjVqrcfKvk3C8PBp0pg5gwo5H2ra6oJqSzp9aBm813SXtqUAEOw
	IU6olWquopHYC1VavMlETFX3kKHL76/BmsILjxaTeWS1+4Wy/8tS0jg3JXbUeCAncf+NMa
	xeN55mooLn7hmTM8BJ5zeigir/2ihz0=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lge.com;
	spf=pass (imf28.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.51.102 as permitted sender) smtp.mailfrom=youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.51.102 with ESMTP; 26 May 2026 15:09:59 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Tue, 26 May 2026 15:09:59 +0900
From: YoungJun Park <youngjun.park@lge.com>
To: Baoquan He <baoquan.he@linux.dev>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, linux-mm@kvack.org,
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org,
	kasong@tencent.com, hannes@cmpxchg.org, mhocko@kernel.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	muchun.song@linux.dev, shikemeng@huaweicloud.com, nphamcs@gmail.com,
	bhe@redhat.com, baohua@kernel.org, gunho.lee@lge.com,
	taejoon.song@lge.com, hyungjun.cho@lge.com, mkoutny@suse.com,
	baver.bae@lge.com, matia.kim@lge.com
Subject: Re: [PATCH v6 1/4] mm: swap: introduce swap tier infrastructure
Message-ID: <ahU5N1Yi2Ww+vN21@yjaykim-PowerEdge-T330>
References: <20260421055323.940344-1-youngjun.park@lge.com>
 <20260421055323.940344-2-youngjun.park@lge.com>
 <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ahTTv5OWpaUF6S1S@MiWiFi-R3L-srv>
X-Rspam-User: 
X-Rspamd-Queue-Id: 83D4DC000A
X-Stat-Signature: jbhatyscfm4aw1n4etsi89871j5y7qkw
X-Rspamd-Server: rspam06
X-HE-Tag: 1779775802-952570
X-HE-Meta: U2FsdGVkX18bzbxiRdRxMSibCNkpA29EieVMIzfb8HPfZa+E5KdkQ70XXathr4VyPYJ6d3w+NIp+yAwzXJaNp6i1NwLZGhIWx9QEEKKiMXpodmh6Li2tdxkPoDMC5oLWoe5z14782NUirj00c61+Z68zPOmC5fF7OQWnmsVfBxqg0w29uHNOlNzzy3iuNRLIRY5DeOLtNepmR/0QOaOR8YfeEoYWUlOKz0ITDmp1uEjZLLbCAYeYx2/n6p8+pOSsx87l/5G1FmmqtLOZ1pQ29+v6lB0c56qh1fFXcw78SqqTMW7wDsIxTZbV0KkL9qP0YiwC77J17LCsUowKv8+Kg427qwTLrkNokm1DRTS/8p1MbL/3zxnYTCoXCceDsdJ6cyRSDITJArUbgssPy6FcLeWEVbtl42tS9wNbh7mTFEsOSTb/wQ/D2iXvlaxV4RH/LO2SOS9v5QCZvlcIKct2KqTNH/d6h0CkH7NvcoahZeRP7RqTN0iIVrBqDdHx3+2UGK+aNkVc73wLgz8BRpUs2gxk2WK8dfCwZDHdeemmRF8FxbTbHVJO+SDvHPVRlYANr1IkoT/eeu8yyv4u5vRkSBqd2RoiKfjeoG+kEkgZMWWb2bBkmh5nK0rdyKpiS3o4ZRH7BinXR2/Ru6VyDqCPMTkA2LmdMhOZCIQO+4BrsuA8shcZF6rVkaHvZw4JE4wg+eubP0THErdUEHb3sCl+zNAI05CVyE43XjXHhZs060hGtDJKt+7iyA/H+AZEnB7f6RuMSVU5Gb9V3dzdN4eg4wMbWlIwB/0MR+YtCyC/XjDjo4jn95Wotn8SMBgwJAL7A0m/5EvE/SOHyO1oWSPXpFVGRp7Zhwtq1dbp328YOe9jum4WCIyRVbuP7Ei6y0b2taN63lw1nmOsSwpYLLZyii/d2moB69nvsd297uWiTSOaKPv9IwK0lJM8R0rt+jE7TPuaw5ZUb9V0l0ylT56
 u5QGKloJ
 Tbp+TvYpmbbY+lQ7+51I+BDTumcREhidmZ0GliJY3BBnS7rhRDv57QWarpEr+b8znNmvE06653fxpUSmBnc4jtgiIkvu1+OovIFisBlzguQVPWwRVyvCzH/DoremD6do/GRQ2wK2PzHwFhjE8PHSIcv0ozCr3RmFF7RRUghnWTvtbAkg5s/o6JDHpzz6DbGsHuXgr/Y+PIwzSqQGZRH7qNkrE0yHYA3TR00KtbREtqCU/cz2pS8dB0MVW8g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 06:57:03AM +0800, Baoquan He wrote:
> On 04/21/26 at 02:53pm, Youngjun Park wrote:
> ...snip...
> > +bool swap_tiers_validate(void)
> > +{
> > +	struct swap_tier *tier;
> > +
> > +	/*
> > +	 * Initial setting might not cover DEF_SWAP_PRIO.
> > +	 * Swap tier must cover the full range (DEF_SWAP_PRIO to SHRT_MAX).
> > +	 */
> 
> If so, do we need check if the upmost boundary SHRT_MAX is covered?

Hello Baoquan

It naturally covers SHRT_MAX.
Because  all swap_tier object prio represents start of priority
and the prio value is assured on the range of DEF_SWAP_PRIO ~ SHAR_MAX
on the privious routine.

swap_tier_validate function is for checking the first tier cover DEF_SWAP_PRIO.
if it is not, it breaks the assumtion "cover DEF_SWAP_PRIO to SHRT_MAX"

Thanks for the review.
Youngjun Park

