Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA497CD98F9
	for <linux-mm@archiver.kernel.org>; Fri, 19 Jun 2026 00:10:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B3AD6B0088; Thu, 18 Jun 2026 20:10:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5641D6B008A; Thu, 18 Jun 2026 20:10:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 479CE6B008C; Thu, 18 Jun 2026 20:10:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B9756B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 20:10:27 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 71AEE1C1889
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:10:26 +0000 (UTC)
X-FDA: 84894730452.14.DFBB0D3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id CB44D40011
	for <linux-mm@kvack.org>; Fri, 19 Jun 2026 00:10:24 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wr+2uFbG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781827824;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=H4FbbuGK/OgsiogMEl+IcPPeV4umJ2OIQeFHkFCYa5Q=;
	b=CvcQDv0yaGsr9rg8zrMSuA4s9Ky/EjDVCJFZF2FmtwfeMvcy43bNuypFyr9Eq/azb7eFkZ
	a5jJB6tjWPYXfo4+NIE0Tc9cQr722WC9HGJmlolUtWlVGgPf9wQWdfH0BXmux4SHTE+vLh
	5GVxa0ILUbzbdd7RzmqV0WQZvSUXQAo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Wr+2uFbG;
	spf=pass (imf11.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781827824;
	b=vVaEXMZhTEic+sz2sktg2OCLkBG/nnpV9jP2O/+UxvBLBMOCjDjDOrgwCKpNjxaO2WAdPy
	gC4tbrPbekS1vxQu225MW8U0yQ9OPGLmvT6kgAQuXP91qx3D1In93YWpttJtXwwAuk0bpn
	alQgARQxH0eWHg/VSeBdI+ffYAFYH8w=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C248143BC8;
	Fri, 19 Jun 2026 00:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 561791F000E9;
	Fri, 19 Jun 2026 00:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781827823;
	bh=H4FbbuGK/OgsiogMEl+IcPPeV4umJ2OIQeFHkFCYa5Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Wr+2uFbGxWXOg/AYQVEaZzGNq9vi5/qaoWXS+u6Gd0X7LlnTsusgHnrVuwqUSRPek
	 Y5Gzc/2CqrjWHJ09h2LguuY9ODTJIJIoO85QLHnTtzraqiYXwF6Gu5bbvakzcNpArI
	 3c+hYOW/h7CRSCzdZgn+mcbqeCPCDqEsvJ50MpKvg9Rsyxz8h9djiDjjRcYYpHoweD
	 Mhdlp2D84ByFw2c1q3EPIBKak7qBaeuT6THzUxTVkCxuc/PRbZtU9tfcruv3YkkIJh
	 KcHSKe0+NBUGsk/4//G6ZFNoRWp1WA1cnJW9Jl5d/AiLQal7f7AMsxfOIu7HAfyGSx
	 JtxoGrpstrVRQ==
From: SeongJae Park <sj@kernel.org>
To: Ben Dooks <ben.dooks@codethink.co.uk>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/page_alloc: don't build vm_numa_stat_key if CONFIG_NUMA=n
Date: Thu, 18 Jun 2026 17:10:11 -0700
Message-ID: <20260619001012.8221-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260618100614.1321950-1-ben.dooks@codethink.co.uk>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: CB44D40011
X-Stat-Signature: rwdgzh73o58896sczfiesuy11uhmww16
X-HE-Tag: 1781827824-496875
X-HE-Meta: U2FsdGVkX1+YRVkq7reXHDNq9Plh+TRyX91B3Jmd5/shkNOOSsyRWzPLARjZAUEkrTsxnE8Uop3ZWOTizv5LydVZQZDBcwsbwvhTQwWUjvChSA8XtBOtvPt37eMxmi2O6IFAI6liQghDR82xuccPZUi3643GAc38FH81iMM7usiLJ7VcbLUEfWFaQbJJjj8Gr7Mgj6CAegK0gVGy9HdnBK9+phOB+ObPuel72a5v+wp0A7r3+B/pvSP8JhTkC+1YGqM4TbgcQ1MrFWsljJ8OkQfFLq5aAYEXmDv59lDd4quTFY3eclOQDGdzH+3HbssCeGKyy32rfG3R98lYK6kq6rcUtpTWjz93xFhAuI+egcHwcdsuyvhFvnp+zBDWkztcr461VZ8eO517pNgrwKtKzMXIBayDR3lUuevzc6UAzVbVQiCxk2aK+2KwD5Py1AggeX1N8R/j7vKpKx/O0J0poqWfxrSyVCAOJesYowmicM9WxgSmUsPf1eB+wB/Ugsn9GcnkuOGt4M7h/VNR3/BPwSdmJwHiJDN/sfDZycN6PNZhFzgxTNkz+a1rR5B8ZQj26AqouI2jLAYLCZoHIbFrOTT/IKEhh7Q05eESPbOzrP6Yjnk+gpZFSt2S7s1Sd8g53m5F9QEMmKMBPKt3UuaW6X2XE9myB8si5DsIR8OpyIk5XrJ/lXZS2dYzrNqrr4BFXblDZibCi95EowsC80sxteTrc7HjakXykfCahbS043ccw+C/OOf2K5dIOTzw/rBnzby2bplzg92iELOxUYdp/b0qh3u0zuJ11z/hsnmZEKLl+dEnWECI31NXjO8zf34jdc5aQ4n7k5n1LA9Df7pyJyndt1HSjlTha+PL30Z8gwHPBefZgLfzAQTJVp5QhC7oXTy/XyW+XbOXJ7Cm0qKYkVXji7LE8R9096FdTuNXH+39u+B4E2Z+Gfu5orBUbrs0/0et8Sf0nl2JcmAsmyv
 kRdpHzbe
 Q3GxeDRPaeRP6Pbyeh6JpbyZBiCQuGS5l1WsWdjnSd657Ytf0dNumcltWXSLUbKnYx1uz6oUX5q/G8U8eIyqzzwn/sLBPWOoedHem+ezegDETeWb0nmi6vT8xcK9taYNa8wBdZ4PIfnVx9ME8tNF6Hqt4V7C32pMNth6g32tCaDUaZzopd4L0qb4gPHZscfSeOcK9Qn0GydUoqjPhBBuW5bN5TLdK/bvZPRj2snCqvpGwjgRZm0Ll8uWYm7IUKdkEm9KKDDvLz4SjtXi6UtBKfx+L6YzABWW1hfr5nU19QYw+F7W8q9BtbQHfRZg2pRnsPxQfOi0N4sTTo0w3uHJ2VUyfw5BpBGxPBM306H0US61VTZg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 18 Jun 2026 11:06:14 +0100 Ben Dooks <ben.dooks@codethink.co.uk> wrote:

> The vm_numa_stat_key is only exported if CONFIG_NUMA is set,
> so avoid the following warning by guarding it in an #ifdef
> on CONFIG_NUMA:

Makes sense.

> 
> mm/page_alloc.c:165:1: warning: symbol 'vm_numa_stat_key' was not declared. Should it be static?
> 
> Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

