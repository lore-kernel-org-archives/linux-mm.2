Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7EE04CF2564
	for <linux-mm@archiver.kernel.org>; Wed, 19 Nov 2025 01:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA5E86B002C; Tue, 18 Nov 2025 20:52:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7D296B0089; Tue, 18 Nov 2025 20:52:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AB9FD6B008A; Tue, 18 Nov 2025 20:52:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9D7096B002C
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 20:52:57 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 637791402CF
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:52:57 +0000 (UTC)
X-FDA: 84125683194.21.0F85EBE
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id BFF49A0015
	for <linux-mm@kvack.org>; Wed, 19 Nov 2025 01:52:55 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dpz8PnXd;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763517175;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bbyRZ/PMyT5AooI8iO3av138qB0SaPMTi8n8joHABBM=;
	b=RlacfXXJWFmreXfjckoUmF+lPvl6Fs6DhsToqgYs6ms/VYrgAlPLBMWwOCzkeiWaY4te9E
	cec7X34mDq+/CpQQoIhetoE57xT8KD7v0gjIb1gnTmYOvtwdT3YKCHr1USNloKVX0oIMIt
	XvWgW4vhk75j/kOVwpo5amX4Ly7zr2g=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763517175; a=rsa-sha256;
	cv=none;
	b=CjjrMUr+GsTNXGkLuiLnnglWHyXFDeLRCrPV979NZJoarJ/p36qMS9ISvjt0fNOXnOUUN0
	b6/TDjxP0IrPi5D2xpmBIttpVxLNHEQI1QBhUkd9zKs4kV0Gx1gHnHXY5MaP4K5aw+RQWH
	cgehYUI58+Bxlc1IBU5qk+RLIgQN6UQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dpz8PnXd;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id AC723402E2;
	Wed, 19 Nov 2025 01:52:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5520FC2BCB5;
	Wed, 19 Nov 2025 01:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763517174;
	bh=TCEqzR6zBDhattucvhy5/nwMOLb1P6FH1l3zgtrIhIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dpz8PnXdicz9rP0/tPu2fRyD4FTob2uHNpXFq0i6VjQk0MbyoTeQmxk40SpreMZ1D
	 ksFjxM1bDpaD6tRqKcQbe837NDpvVn3D96TNbTiDCQ+sckkkz7VDUwt6E5Y53s6x9p
	 z3fueSAnatoBMU6o1geoOpjSNCHOfBD3DsOmIq/tfXaLwlJLFv177lhoObz78/8joG
	 0Id4ydQgLdOEPyn28shQFynLFMSltstbXal5p6qVm83/QLafSk8o66ABAPpr3OQRRO
	 AXOueqI75vdGXJDFgI3HYut2oEH3wD0AGsJMrGElAem1h5sXyiz09YAtpTeRg72uX5
	 gcQvExbw9/mIA==
From: SeongJae Park <sj@kernel.org>
To: Sahil Chandna <chandna.sahil@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@redhat.com,
	lorenzo.stoakes@oracle.com,
	mhocko@suse.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	hannes@cmpxchg.org,
	shakeel.butt@linux.dev,
	zhengqi.arch@bytedance.com,
	Liam.Howlett@oracle.com,
	weixugc@google.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	yosry.ahmed@linux.dev,
	nphamcs@gmail.com,
	chengming.zhou@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm/vmscan: use %pe to print PTR_ERR() values
Date: Tue, 18 Nov 2025 17:52:43 -0800
Message-ID: <20251119015243.72791-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <94ba6ef88d97eb1a5e20eeab9f913be8fdc46fd5.1763227530.git.chandna.sahil@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspam-User: 
X-Rspamd-Queue-Id: BFF49A0015
X-Stat-Signature: w47fqofymk3cxs5t3nbi7rdguabssjh7
X-HE-Tag: 1763517175-502991
X-HE-Meta: U2FsdGVkX194cyQc/Xwr4Lhnuzmwydq11qEnpLJLyebmJUCb4RPgLVZPmcO1U3WmVuiOTUI3Aw15APDe/tnpL0g2rZdtQFIGBdi4TsBr5fBju8iqe1Wn8kM0ithOqHoA4omKos+pyWYVQR95vylgmVNm6UcTiP5WNO0yYnmMoTT8dK9nuMWuqAM/nZt2XmEHi1JVz7jL0Hm6qQWlrKdkpbVVCRNzC+VUWdgkX3KPZqqvPYMPx/n8fG93uBnd5LoQsfTiSrSco9rqFtnpZSW7L88FFQb1aPr4RwWEkvVp2AMcdNg6+GztMMNyEu7lJa2F3LV0pybyA9j91L62TlacZ+dZ33zNU8IB3GXYygn2jH0Gop8yuifpHxQSAve5AKu91OxhEqX5r6BJVgw5oFddAqICWI0bXlbfQTP/KhWliLO9wHdVR3fFFVdixhtdv9tfkgvYGBoG5JEkk1Dk1AeTumLAikKQAE5pVbBgdB9Bo81MC22BfUz1WMCdQDeQP2WXJtJr3t4yEBMBJz8qKX70wHthARqTF50uWVFO5NWxtv9GGbCB5gvyKHkox/sGmv3g4+OlBXACUBeOkSxo2dD/IEl7F/2lfkZ1UBooCQ1keOGQfxutY9jH4YzFcoDpY0GQkpT1RpyaMeFAQH7HVZ5LS0xvelWeb9IbK8jOl8eiljBQS2uQ/VwCeecLLj9hngvwXfNQn9azmu4jV+9e+1RZsbGH1unPtgzb8/sPSe8YIaWuoBcZRkIFGEqveWhDd0PQ7hvsEtd3HPr41xEGzOQCikHwHee6Tvd4gCiQNR53Ir8L+QaqwYhytNp+heg3HlGad1I6IhthwliJREt/Z7PhskoiZwtvinvBwgpb+6CCTiLOKroBCo+oWqDHzObsR+JLJ9Al+Qmv8WVxyfcfML0YjXD7ql8AgV6f/o8ecKdgd3BmuvoILOQDDPJKc6gpBOjRRPFiZLlUcLhhkQU/qe6
 Iy6r7PTf
 Q+QCZaDlklzCnqlB3OnawFT4PI5gjs53+MEMB1iXbczFvqhazFw/ZvL8Z7spKvtzALDIsB4FuIqtSkmaw2g6DQrn+AAspJl2UbvvfZ8GtcqOrpcdX/OA2rrXBbfPo2U8sujexaHF2VYrZPXL1J9/iq0URNUyKhT6enK7Iyh9fWgntGU2vPJ+/guTK5Bwox4MiZH6bGtpVhZEQxnGDJQhNkXR8gpvpH6s9eJCd40mFcM+s2S85Sxi+QDsyENu0VvvChoItGDar+CYNSHiOA40vcMrMFluHZ7YBYaIQyW2igVLmvXwwp6B35xhvu8czm48zOITVbFk/rTPOKPPAh5UE8WUkvw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 18 Nov 2025 11:38:50 +0530 Sahil Chandna <chandna.sahil@gmail.com> wrote:

> Use the %pe printk format specifier to report error pointers directly
> instead of printing PTR_ERR() as a long value. This improves clarity,
> produces more readable error messages.
> 
> This instance was flagged by the Coccinelle script
> (misc/ptr_err_to_pe.cocci) as an opportunity to adopt %pe.
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended
> 
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

