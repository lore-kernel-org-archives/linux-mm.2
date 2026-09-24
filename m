Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC066C9830E
	for <linux-mm@archiver.kernel.org>; Thu, 24 Sep 2026 20:02:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8734E6B008A; Thu, 24 Sep 2026 16:02:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 824796B0092; Thu, 24 Sep 2026 16:02:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 713506B0093; Thu, 24 Sep 2026 16:02:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 56C3F6B008A
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 16:02:51 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E333E1A04A8
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:02:50 +0000 (UTC)
X-FDA: 85249728900.05.A5F9AF6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id F029820006
	for <linux-mm@kvack.org>; Thu, 24 Sep 2026 20:02:48 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X5Q+OOML;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790280169;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Erz4LJe6kh7QPf4uqg2zepfaCHHFYn+vw8D8/ABgOjc=;
	b=GJhbW6c1PiLb4tRE6N+kMlAeeCjAV+yaWs9KELh0p5P1QWKJou3LZQEScri7y6P69Obtvd
	G0uIDPWFQAdlEblu46HXuwC4irsbjGcKYrhWK5qTLLJZHec6ZBTrMKSOZpYZF2BoBESlyF
	6A+Zn4fA/Z1mj8KFIKpiDrD1Jesrv1E=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=X5Q+OOML;
	spf=pass (imf03.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790280169;
	b=SbojmW4S/HHkqohYekYAYFawkaGT3j4rD1zODqMRplmRAes9ajEIdmlobN9ePJJ5dn09nM
	OcinTDy+w7uGAq0W2oVRcAbozsw0IeKFmXZxVnqIznYpKHCKNcj5rjDI1yucXmDO8qh1XR
	aZdySSr8/bRwzgpkWfl+cqTYIzKB/kM=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1991E43BA5;
	Thu, 24 Sep 2026 20:02:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B8ABC1F000FF;
	Thu, 24 Sep 2026 20:02:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1790280168;
	bh=Erz4LJe6kh7QPf4uqg2zepfaCHHFYn+vw8D8/ABgOjc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=X5Q+OOML5RdDvgXB/ebimQyLK5pgYR+e6utm0gk1qQh6f5y8GR/TWIGI0J0g9vTTq
	 p+1ac+96Njuu0l76rymBs0ZmDMeM1ByrUii8EkSpLaxdzYb2o0C3mtjgbx7K06OczK
	 5P0RsSEsvnCi/hFrZnBe3dcsMZ+bLiikMBse9oIU=
Date: Thu, 24 Sep 2026 13:02:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SJ Park <sj@kernel.org>
Cc: Karl Mehltretter <kmehltretter@gmail.com>, stable@vger.kernel.org, Kunwu
 Chan <kunwu.chan@gmail.com>, Lian Wang <lianux.mm@gmail.com>,
 damon@lists.linux.dev, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v3 mm-unstable] mm/damon/core: keep the temporal tuner
 quota over an unmeasured PSI round
Message-Id: <20260924130247.07bf24d96794d28a4d8a83a9@linux-foundation.org>
In-Reply-To: <20260923055139.2982-1-sj@kernel.org>
References: <20260923055139.2982-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: F029820006
X-Stat-Signature: c37q3eozpb3yrwx4gaimeo97crxcydfx
X-HE-Tag: 1790280168-689386
X-HE-Meta: U2FsdGVkX19cm84eqa6uRMdTkep4Wit8581eeSeyiJvSxIWo1wZWKyYjxLZdfoJ3ZUuHePIq2laF8QU9SD/LxGwJWwKacOAmjpvccoTxy5QUBgAd5FBifMQLQeRAc6D/xQau5kt/E8QEP20TsHPNUGPjtl8LOXa/5tSXwIAOro5ZC8aYto3p/XP96cavHMZ02kqq2/MM/5J66Y/P3a5pv4uSJjhnPdrw8UwONsNGw1cAOoAFTNGchb7aj4z6AkCbH6IQvZbWreKQa/wJvceB/mAYrowmm7BHbX9N/D2HAtMQ9etdTKlldoGNxbVeO8pbDcFrehLlqzONNWK1ajRMkJLnlf2cvDJE6nxgnimBM7rz0e2NiBcfVGF9YWJzOL/os1E7MR1pT68FlszQbF9DJJXa4wRsg86AfOTK5wyzEKsvTjepxB8yiXhVTgp0PbKxwwbkftMPgWHVgynvTD5X4W4GvkDurToVV1TQd+wvS+BWyUGVu3yoj1ZAcl57S/B/ahcr2oNeIbT1BHI/L8p8zTfsjcRleAQ9JaU61elGQe5+CT4PTGxbG5UnFTflA4/LMye41cihrg6NxOO2dMOIqneo5aa4Jo0h+NPEOmfJ+hJWdIp0PWlUDwGCl9AKQsbmwNYyEltNcmQEf6fltnsg/FYQmhPJS/4bFlQRTvoWp9oT0se+0H87fEVrRNTNTBuC3957HOoIa2BMW1diKSj9UCt7/XJInh9Zph2orkGGYuYNPxpSLHiWveWwPp5bLSzcpHrtGxZPjFLrJEgRl/nrioEM0jH4IfjUZ13m1/KkqOVsVU/VnZFL4PsuCVPOvd7/NmQPWEgz/6+8T0o8z3c+yyyjazRQ7p0ydbMaZSMYBgiYeeiO0IrW9TbbeHtBW1lt7QjvV9cBq4Wue7Y1SFr0WA8YACSvC1/jfqLlP/qya/8Pe8/6nxblAd3wyMr9cefSTIaISnRACZFx/78ZUlU
 LunKNguQ
 HVpE4w99B5hcdxw8s/Ph3YzIssTNl0QvC5ZplZbeVfHNoHAaUygPCtg+Ig/DxiJ8PGfT0SO6LHGoKpRF25qV7U1hZUHR759+VdQhyFKhpAwC6BPqAQ6F7RQSRaUOqkKvJhxzlLS8Qn6WfrSkucxyuvTiq21qH2zcAXUShznNnSvXptZfKJb0dosj1WVbLyRF219zALcgRRJRqZKuxtbztcm8YCA2P76uCouMkpDEO0X/e80GEdXfgJwXjhgd13SDBFGc+D3Q7Y99lCT1VZA3PYdTqlBEDAc/6yByucaRSJ3hrnjsSqAeHSmLZmV8pCqIgkFvRpfARWiuJBClA0VxR9guJTfqH17SAiecKft43z46Ge4eurhjeMtTQng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 22 Sep 2026 22:51:37 -0700 SJ Park <sj@kernel.org> wrote:

> From: Karl Mehltretter <kmehltretter@gmail.com>
> 
> The patch in mm-unstable of subject "mm/damon/core: handle uninitialized
> damos_quota_goal->last_psi_total" scores a PSI quota goal without a
> previous sample as achieved. This leaves the consist tuner's input
> unchanged, but the temporal tuner sets its quota to zero for an achieved
> goal. A running scheme with a nonzero temporal quota therefore loses a
> charge window after a quota-goal commit.
> 
> Use the effective quota to preserve the temporal tuner's previous
> goal-achievement state during an unmeasured round, as SJ suggested [1].
> Score the goal as achieved when the effective quota is zero and as not
> achieved otherwise. A new scheme's initially zero quota stays zero, and
> the consist tuner's behavior is unchanged.
> 
> Move the PSI current-value calculation and last_psi_total update into a
> helper that takes the current PSI total. This lets a unit test cover the
> unmeasured and measured rounds without depending on system memory
> pressure.
> 
> ...
>
> This is a fixup of a patch [1] that is still in mm-unstable tree.
> 
> [1] https://lore.kernel.org/20260902002725.108635-3-sj@kernel.org

thanks, I'll queue this as a squashable fix against "mm/damon/core:
handle uninitialized damos_quota_goal->last_psi_total".

Which means I locally named it
mm-damon-core-handle-uninitialized-damos_quota_goal-last_psi_total-fix.patch
and shall squash it in before moving things into mm-stable.  Karl's
contribution will be captured in a footer note and a Signed-off-by:.


