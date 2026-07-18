Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65A67C44520
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 01:03:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 358E86B0110; Fri, 17 Jul 2026 21:03:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 307106B0111; Fri, 17 Jul 2026 21:03:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 21E1F6B0112; Fri, 17 Jul 2026 21:03:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id EDAB46B0110
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 21:03:23 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 748EF160282
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:03:23 +0000 (UTC)
X-FDA: 85000099086.25.36FC591
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id D8EC340009
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:03:21 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MtgFufK8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784336601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q6G9ezbIlMVkU6BcAV6AfIPu4SPtlwXOdQ5VEzE5oyQ=;
	b=Y9rtyELr43OReNP/ZMYqvafnE3NV0aZ0uYaEsp17726qliIBD38ftu7RvxQghRA+k2fhcz
	4OhufdAQLLLPOk0YGbmYu7SKkdTfFWmVGkI33o18RBWp9erEHmDnZZ5ki79D6smfbF4xn6
	m1xup2C5s9pl0fjIJDDhdZffp3MbqF0=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MtgFufK8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784336601;
	b=YVHfjuW9WOB/cbIP5SUb8SmgRZRe5n9J+2BJmPCTWvF+mMSVsO+RIbEunUJJtB1Ti8A3Gz
	c6CEVd0NjiEEwV8y4S2MqdJFyXCzTwr23TTSAuccaUVO2J7ju+5j01jTivGSU8klZ45PFZ
	S+QrghdtTHSMFxrrP4YGQNIjFomKzFk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A80674505A;
	Sat, 18 Jul 2026 01:03:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55F261F000E9;
	Sat, 18 Jul 2026 01:03:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784336600;
	bh=Q6G9ezbIlMVkU6BcAV6AfIPu4SPtlwXOdQ5VEzE5oyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MtgFufK82hKi0p92Oz2iEIH0bsV2mt+tfaM0nxTrX+TUBsz6ayYift2JGtxF8C/f8
	 l+CcrMJavpvyJvF3GWP4kiCLpWjjdytTSAV312rky/ber7d+dTjHMn45onaD1Orn9E
	 2e8H3Yb2Zm8u7wkMZDwwojymk5sfzCVRwKp/YtKAa96bhk6W9Dbb9m5lMEwd1805MH
	 pOpaGdmNfG246HUO6aANfY19rHMQo8/bol4sguYMcAgxSX13BhrhhN4OOVfwyQa02t
	 1GE0MBCV4ZdlZdg8IxMKADAkgB8Rd1JZTK8tItUpad4aPBE/njWrmLGo+uIzEYdBYp
	 R5qMY1JrsxXpw==
From: SJ Park <sj@kernel.org>
To: SJ Park <sj@kernel.org>
Cc: stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon/core: handle region split failure in apply_min_nr_regions()
Date: Fri, 17 Jul 2026 18:03:12 -0700
Message-ID: <20260718010312.90397-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260718004301.88883-1-sj@kernel.org>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D8EC340009
X-Stat-Signature: 3bmhuihmwdag4mbiqfty54u1nk6ihp3o
X-Rspam-User: 
X-HE-Tag: 1784336601-679127
X-HE-Meta: U2FsdGVkX1+zCLHjH8IY7qN237WAVMNUf+VBF7t3phcR4gyiOKY2f9OR8sHT9Pn+IDNgu8f5lZGvQ895Udjyf6mneCouqIAPs4zqeUduXc39hLkqkfSRpXyC2zwTDBfMr1jer2+oAL+DHfUujcEPDJUwntjpM/8yhmH3gVesSxn2837lgSZRJ/t7I2+i060ohLfR9zhGms1KZcGWDVZ64iybE3WmGFoQxx6HYedf5mJdYnUs+g5171HPraX3OBi4+ds2PeYiDpFZNAn7K/GNi6R3b5kxa9GKymgh6zCFIBmgiIeFIV7YtySZiSpJOKw2przKGGRPYMcs7VvTAVcndWuHE8NbTTnaxkBwuiY7lGeQVLIFegKqsKLMlKjbZ8VxhPZZcFTzRzWBOb7c0BRhEpPtCdFF/DYEnEQvvHy3/FuiYO9twYaiSwFAmTqNFr0z5rptkvxEyh5nmrWr+2vXMEvpsC1C703kY0rg6iQMdwUVGshQuIg6RhEM3oZiTQ2jCmSpHP5M0U9Bxad7QyDGNwiBAP+6IqT2BjWqaqBErIlueznKL4zvOU9Z3OF0gdGpNLtww5nADD+zXqC3lvpzxO+0x/MILxNrm+V0lR9B76MhzThneDmyC2/xsnGtknbD3RsKkjC73Ogynr/QUlYxraZzEnNFpxQjZ8LTrwDcJJ0h9IpEsjRj+7ZXFWwkWN77WoZTXWfX3j/u3k1VYR9m8Wr4x896Z76izaTEFGmszDq29KPUhbkzMP76pnyNB/K0JDIeD0J2ReX2iXaWMOPE92CzjaItaeZ1WXXu2Ya7l0haSAQNXOXeqXZ7KuxQr/IIuEQlhrpQjxANVEw0Ra7/glgdoKCBGJWPCeMOlCCgGUl2TWK8zKmi/dQzImZxLAUgcCoKwMCDpdYWwUi4BSXCN8WvmxDOPoj66zSrjkDtGeTyKdspxH8PiY7h6X+o5RE3rqyZbnHm8h30zvC2ORf
 jh0KQjl+
 3PwFSBQpX3TjQHvVZGWxYnDeCvH8wcuuuIuNdA+CC4cTGriPK1xIsB6wlAkM/Y/+Bx89J4RAxA6kgD6XRfIsxconaSCVSvcdMu9CRzFldGdwIRJrzN98uGrg1Oy/7K3JKiYoukLXfs0kz/uiknizn2k9Di8LAscsBwUyPHM95amjBI1AGT2vKFXY5rXEBt+/QPEr4hSrdfRx8UQ6+zMQUXkUFix/5ajPegqU5UYVmMu4iED+CLjWXQkiDZ3r3Ezd32h6KTTtPx2O5527bTGeHIjaWAw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 17 Jul 2026 17:43:00 -0700 SJ Park <sj@kernel.org> wrote:

> damon_apply_min_nr_regions() repeatedly split each region until its size
> becomes small enough to meet the user-defined low limit of the number of
> regions.  The loop assumes the split operation (damon_split_region_at())
> will always succeed and create the new region.  But the operation could
> silently fail for memory allocation failures, for example.  If such
> failure happens and the region was the last region, the linked
> list-based next region fetching returns invalid pointer.  As a result,
> invalid memory dereference and corruption could happen.  Fix by breaking
> the loop in the corner case.

Sashiko found no blocker for this series.  Sashiko sent findings to damon@
mailing list [1], and I replied to all the comments.  Please read those for
details.

[1] https://lore.kernel.org/damon/


Thanks,
SJ

[...]

