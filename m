Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A3350C61DD9
	for <linux-mm@archiver.kernel.org>; Sun, 30 Aug 2026 18:19:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BA926B008C; Sun, 30 Aug 2026 14:19:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76B566B0092; Sun, 30 Aug 2026 14:19:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6816E6B0095; Sun, 30 Aug 2026 14:19:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 476CF6B008C
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 14:19:29 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id CDD0B160331
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:19:28 +0000 (UTC)
X-FDA: 85158748416.05.C141749
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 410FC80002
	for <linux-mm@kvack.org>; Sun, 30 Aug 2026 18:19:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9J6Lw8P;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788113967;
	b=F4fgisig8vOrF8qAWE3ITxCKBSVBjMi3HKaTYSd/AmWhqLlFAfhs9Lezzl1MKv486nA4q1
	32P5LUwXO5WnV4+F4vt0HUHYMX2FnMrZw88Mm5gf+ZIU5I9+uQSVdqJx9X/HIHitcWc+qq
	VnOfJPhVUaK19/CkDMxlzmaMSejvn3k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788113967;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7jy1ZWnPaxiHrahLaXjgCWS5cxp3bEGhVPgp+yEdgqI=;
	b=1s27CYC4m7vVHWb+r27bqCZWwPkOJHOB5Yv3dblAMAH+1d2U9DvkOny7s5afxnBtmxKct5
	kD1ku2KX617XRlG2si55MkJRbvr7v7WKK3k/YRS0rnkZ5fdhh4RCUkXlP1rGiurbHFmQs8
	WImUIyd/Ttf8h0m4uwgye+fh32i28YI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=l9J6Lw8P;
	spf=pass (imf30.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5455140466;
	Sun, 30 Aug 2026 18:19:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F01B61F000E9;
	Sun, 30 Aug 2026 18:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788113966;
	bh=7jy1ZWnPaxiHrahLaXjgCWS5cxp3bEGhVPgp+yEdgqI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=l9J6Lw8PFf0Qbwatxu+AJWYvWKkEtVP5XYWvNymlcl8IwFuA2UcGFVLwvH1EKR+VZ
	 F5qknpWvt/3eXbHDXbH+R2eSXv0QQffh9mm/DV/E5/QPbTaX+Td/P7D0a8Fx4XEwvV
	 pZPfMxM7QstlHKnPyFIyWUFEQIwz+RYp17E3XvG2sOsLyOWcsBPF+cagHo9rvsvDgi
	 9Jec2A0StZgJH8A0iDTCzb4WpLs4dFOGBR++W1mEXXoXnfAWZgTSokf/zXBOQsMYgP
	 l2AXGAQr83dV13fdpHw4lxaYPMaffvfqIgYGSB1WrQGzrUCrjN8ycffAmIA2u2mwzl
	 LuFlt/DPYR91Q==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: Liew Rui Yan <aethernet65535@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	stable@vger.kernel.org
Subject: Re: [PATCH v2] mm/damon/core: fix unconditionally skip last region
Date: Sun, 30 Aug 2026 11:19:18 -0700
Message-ID: <20260830181918.105052-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260830181445.104859-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 410FC80002
X-Stat-Signature: 6hpxqyzip788k96i1hgrcsmfx5nzx9i1
X-HE-Tag: 1788113967-897692
X-HE-Meta: U2FsdGVkX19YLXjsqdGx0guyGPfNeGziPxPg0XR2rLXJcosBHLxClRIli194r2dFfR0mVZ1+GLXUErbqBhtmcucHR775WQ1HwI0O1J4ur6FGF+gZWdcYlKtxoQDLGyRQ9DJdBHaAFbkiF9JrGMTx3Zcektd7HcP/aT4X/TNYTqXLKZR23Ix9pAz7Bo23m2lwbLGbZ9vqgM1KZ0S/ADcYOOL4MUmrNkRFWmkLZvSEIfsKyjPUuOnv7NDfGX5XYHFBaRYl8ZNryxjF7taruyFkYEzluw4mK9I7YJfAOpH+lJAsVVsVbVrYkWdv9p/sObK8VW3csPPa3ZyEr/2B2A7dpcZVd2B54VTk0MFWJVJ/Rq88yZzBcTQgds7T4ekeSUFfDPVGcC85OTzqB1l1wlzD1zGs5gkJ6jURAfpDqmaDYjdFR5FFQc9vqmYrwon60+/dhXfO1itCfgFhEp5H6PMxJBAZQQvRhLCzmGYNgwGOSubXIc3VwMkV0Kajq/+whNumuTXMNMS3h8emjV1TwE5lLhPENqijapNQRWToEi/D8eSmAj5kjnFirEv0Y2iberXB+ZEzQzDxLQ2Mm9xAGy7U72DgtbPBiXMRA8Vx/XcPMhjv7CBr0EiJNEkAb7sENr6qsLDTsYG3gFBRAGJGruDME+XLdRolohieZsR/LTI4ZZeWeChfWI+/H0x3aeIF38vZnZFvWTj5B5rkuxCigIyLoGrxZER2epDLSDtCRmBIrywaisK4mYEu9KQSNdxPnBi9Xc5sEmYP8XR15yZqeKy7VvnBI/vlbTYYwBGWZjODrq87rtqyDfWxGNjfRmYlsn5qzFeCaK49ySfEVTB8r5bCIfA2MTBQCCpVYuEXyzCdUqqE2wAfnl+N6cUc8pB1rVcXd12DxpDjpwaCvle1M2U9FHPIV750FlOOaA/gigsX9sqfkw32iBDbLsdKxwUXFOEfsodIC6e+0Toj4apyQbw
 CYMQe43J
 KJX8XOppI3B29/1XOod5O+lrBkQUkX6VJ4KbFRlSkjy0WAJROgGAXBsw5TwQS5fDNgfEc2vmTxjDM16nZpdipqi71qLJpp+DGRFQ4yTykdLIkrBY1rGLDO4ydM/8orDQ7Kb+l+lkVC2jqtOex+ju3RO9wzIqvec+aXFV/qeVLWsBJbYQ9z54HfHiL+y3C8EmPilG5e3BipM3bZRF4wRqDtwXvoeoKG9fcQJPI0rbYvAmkZ5a9+XpkKAN4Kuq9q8cqu90J3yBlM9DF1buH5IgZOTU2+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 30 Aug 2026 11:14:52 -0700 SJ Park <sj@kernel.org> wrote:

> On Sun, 30 Aug 2026 14:31:50 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > Once quota set, the charge_{target,addr}_from unconditionally skips and
> > resets at the last region of the tracked target, so the last region can
> > be skipped even when it has not been processed.
> > 
> > Example:
> > 
> >     1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).
> >     2. Quota is configured to process only 100 bytes per window.
> >     3. Window 1: Processes R1 (0-100).  Quota is full.  charge_{target,
> >        addr}_from is saved at (Target, 100).
> >     4. Window 2: The loop reaches R2.  Because R2 is
> >        damon_last_region(t), the old code unconditionally returns true,
> >        skipping R2 entirely and resetting the charge_{target,addr}_from.
> > 
> >     Result: R2 is permanently skipped even though it has never been
> >     processed.
> > 
> > However, it is important to note that this is a very minor issue.  This
> > is because it is triggered only when the previous window saved/kept
> > charge_{target,addr}_from, and in the next window, all regions except
> > the last region were skipped by damos_skip_charged_region().
> > 
> > Fix this by only resets the charge_{target,addr}_from when last region
> > is reached, only skips when it applied or cannot split.
> 
> Looks good to me!
> 
> > 
> > Fixes: 50585192bc2e ("mm/damon/schemes: skip already charged targets and regions")
> > Cc: <stable@vger.kernel.org> # v5.16.x
> > Signed-off-by: Liew Rui Yan <aethernet65535@gmail.com>
> 
> Reviewed-by: SJ Park <sj@kernel.org>

This patch is applied to damon/next [1] tree.  If this patch is not added to
mm.git in short term (~1 week?), I will ask mm.git maintainer (Andrew Morton)
to pick this.  So, no action from your side is needed for now.  If it seems I
also forgot doing that or you cannot wait for my action, please feel free to
directly ask that to Andrew.

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees


Thanks,
SJ

[...]

