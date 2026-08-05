Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C4EDC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 14:23:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 361066B0088; Wed,  5 Aug 2026 10:23:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3110F6B0093; Wed,  5 Aug 2026 10:23:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24F326B0096; Wed,  5 Aug 2026 10:23:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id F1AC56B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:23:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 7E8134029B
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:23:30 +0000 (UTC)
X-FDA: 85067433780.25.955543B
Received: from lgeamrelo13.lge.com (lgeamrelo13.lge.com [156.147.23.53])
	by imf01.hostedemail.com (Postfix) with ESMTP id 055CE40008
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 14:23:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785939807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ha9KQWLkp2Gheu5bzWgsLykQxMn2qQ1w0ZbUnt9u4Wk=;
	b=1JjhNb0NxFyJrlaMU2wgxLjJ/2+cI7+a/PtMEtD8Wz9V5KuqXMlrWUmNIK93M4FYA+/Rp+
	ZbGOU80bjer9s7D19QqKfihS3loTZsGKElmTbvuFgPfZIErM8ie3UnnFrMSMGR814aQBOI
	mLqAuS/MP8inETz0dfo6YIlZ3dDTGko=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785939807;
	b=RKbfzFdGVIoPsAS07MMsoKZBQm9LMUItef4wgave51+h0Oj1SeNBbPAsDns4yvgpvlCN71
	gmeiF8oKviy4U4nT/LetUV1DYAI+5qFDGz4+vOBJMAwPqnC/3xpKbsOeAO0dC/VadPz9bD
	pNIUSZ01jbWnaIVc4qb+wxOUAj+cBfM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=none;
	spf=pass (imf01.hostedemail.com: domain of youngjun.park@lge.com designates 156.147.23.53 as permitted sender) smtp.mailfrom=youngjun.park@lge.com;
	dmarc=pass (policy=none) header.from=lge.com
Received: from unknown (HELO lgemrelse7q.lge.com) (156.147.1.151)
	by 156.147.23.53 with ESMTP; 5 Aug 2026 23:23:21 +0900
X-Original-SENDERIP: 156.147.1.151
X-Original-MAILFROM: youngjun.park@lge.com
Received: from unknown (HELO yjaykim-PowerEdge-T330) (10.177.112.156)
	by 156.147.1.151 with ESMTP; 5 Aug 2026 23:23:21 +0900
X-Original-SENDERIP: 10.177.112.156
X-Original-MAILFROM: youngjun.park@lge.com
Date: Wed, 5 Aug 2026 23:23:21 +0900
From: Youngjun Park <youngjun.park@lge.com>
To: Kairui Song <ryncsn@gmail.com>
Cc: Youngjun Park <her0gyugyu@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>,
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] mm/swap: scan by cluster in find_next_to_unuse()
Message-ID: <anNHWTMmpfHV0waH@yjaykim-PowerEdge-T330>
References: <20260728155907.391820-1-youngjun.park@lge.com>
 <20260728155907.391820-3-youngjun.park@lge.com>
 <CAMgjq7B8-HuC4JS1oSL355QNMLOV3c1iaoaA8GJB6CPf0J_7Xg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMgjq7B8-HuC4JS1oSL355QNMLOV3c1iaoaA8GJB6CPf0J_7Xg@mail.gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 055CE40008
X-Rspam-User: 
X-Stat-Signature: ijjz5dmanmywo89smpq8kgowphu4q9cw
X-HE-Tag: 1785939805-89725
X-HE-Meta: U2FsdGVkX18C2La6302CDMNOW8e9iWn4ndweSHmjNS5Axl2KlVW87nhC+1+AOv6RDEOUr9KPpRln3nTk+IJgWkDD/T574NCvRX26cuJq7LtEldNL9nPACVntuFXyaCLq5n6k8Kx4xFJ5jbBPfcj3KvAC61GxozxU6czEi+rEPRxXqoskprr1hO+9WXP0HVxgOHVdC5XnoBX85wJAZdb7ovI9JMtShmHCBbk14Ykb4YyiAJfbg27RVXDbIA9rRzA/xQPZRE9F2RtoM+rheU+/Iv14mpdLvDfNacNz1e9Uu7JqK0QwnXjAEigM9n3Nl0H0Ur4njcsP2cIs1MEcF1ypzEOzWsvcRcHgQGRPHBuN1HXR0y9pnJtPgD5NdQjtP31O3fcYm66bwFVY/kt+arsZ4pr+lsLy21FT2HA156PKXRH5yLGtSo425B7JR4dTEsm/NxC+hbNTz2o8u49hYyIS8ykOZqp9MdiOkzgC38MdoUeK+qDLxtC+P1z6Ok1HOuPB8UTvwrfSP5wa4WQbbgPS3ILuFkeLZiUFMD3aizUdOXuhx5/0EwszpwZwWLh3Mp70JroJTCq7winxejmhBPoW4/aa2HCK6MiBthZ1xK94dPlszWLWs0QBhMNeRh7E1YjHK3xPIcysSX4V7yXfgx99FxjznKFPxy7cEw0Gu2MebB18SxWRqwBV2KJRzfqk/M/JFlhtzUcnHdPvTZHPUlU0JgD1ngIkYhkTVIKz/OSQW8t6NeW1NywXOgtajAySMI0mxiLl6MCbiJskzU0EU0p8M9d2C4pqMVzpzY+5nwfekYlDOUa8U1MdS/hCL1Fn8k/q56uCoeatdbnV+2SrP1qOKDCbHG6dif4lAE8sidSYxci8ED0KJn6WL+q1hTNbvKENJERSdnKFejqZR+L9OpO+1uxhxxIQQ8o4lqGAMhaJLaHgAR6dF53y9PQNw6OI1haLHQrWNu+FLb4DH/V0tjv
 rbqSz5Yu
 yAsCjAO6z+6U3riX8xiKoYs6n2SGVCH9cJn8Zon9sdcZIAYU38EN3kGIICVAYbhH+Y8UPvbxDAYwpgrGDU0QzETPRrHvIl7OWHoXynaBXlOPV/N59vCLmwMLEWkkwJYW360UiNy6kVCntnpSYHdUk3LV634YhYkn2hP0PpDkFdTTnLESDqyonqVk8G2+vjI0T7nQvtEbqZjH/bH5KBBZiDQTxxhEzink7JF4FQMh2Z+H0awA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

...

Hello Kairui
Thanks for the review.

> > -       for (i = prev + 1; i < si->max; i++) {
> > -               swp_tb = swap_table_get(__swap_offset_to_cluster(si, i),
> > -                                       i % SWAPFILE_CLUSTER);
> > -               if (!swp_tb_is_null(swp_tb) && !swp_tb_is_bad(swp_tb))
> > -                       break;
> > -               if ((i % LATENCY_LIMIT) == 0)
> > +       i = prev + 1;
> > +       while (i < si->max) {
> > +               ci = __swap_offset_to_cluster(si, i);
> > +               ci_off = i % SWAPFILE_CLUSTER;
> > +               end = min(si->max, i - ci_off + SWAPFILE_CLUSTER);
> 
> Do we need the min here? Table size is always SWAPFILE_CLUSTER aligned.

Yes. I remove it.

> > +
> > +               /*
> > +                * An empty cluster has no slot in use, so skip it whole.
> > +                * A slot is uncounted only after its folio left the swap
> > +                * cache, so there is nothing here for try_to_unuse() to act on.
> > +                */
> > +               if (cluster_is_empty(ci)) {
> 
> Hmm, it's not wrong, but this is indeed the only user calling
> cluster_is_empty without holding a lock, and not in initilization
> path, perhaps we should at least make it READ_ONCE? Maybe KCSAN will
> not be happy, I guess? Just nitpick.

Right it is better to use READ_ONCE. I also applied it and submited v2!

Youngjun

