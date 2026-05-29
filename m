Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2D709CD6E50
	for <linux-mm@archiver.kernel.org>; Fri, 29 May 2026 14:44:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8F1586B0099; Fri, 29 May 2026 10:44:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8A1F16B009B; Fri, 29 May 2026 10:44:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B8346B009D; Fri, 29 May 2026 10:44:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 689CC6B0099
	for <linux-mm@kvack.org>; Fri, 29 May 2026 10:44:43 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1AF351C0188
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:44:43 +0000 (UTC)
X-FDA: 84820728846.02.DCDE1D1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 74CAEC000D
	for <linux-mm@kvack.org>; Fri, 29 May 2026 14:44:41 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F68S+BVI;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780065881;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eSDXs1iBErDS79NVdNdY9EDtRW55Oz5UnXhb1rHekmU=;
	b=8jbCqGpWqt6gnriHAlt7BOAN/lMEtbwyAYlzkeosaY6J+8XroPNSc5M2XfODkjtZEJ1wmM
	n6ZijmoachptEPRWhdHWwoyFqcALW5m8skzm0oSB2N3OenpPf1KUB6M7aWVSPG7trb7C4F
	4XdH/+MaTuqMA4G4XVxf4dnN+c8Uf80=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=F68S+BVI;
	spf=pass (imf10.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780065881; a=rsa-sha256;
	cv=none;
	b=O9mSHFk1xjAYur14/lcwgdAeh+/fwkO0vBhL5SLI3kdzPXP+UJy4Fnhwv0kXokqDP49hcV
	KY6PXfkyMzTuzQ23/cf+zo1Zy0szOTW+9O+dogeljHLg6arCZIcrzQb1wOx6vXfBBsRg7C
	sAzeMWv6ffAWBTI8Gdui4jC5Fln+6fY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2A6FC43B2C;
	Fri, 29 May 2026 14:44:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2ECF1F00893;
	Fri, 29 May 2026 14:44:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780065880;
	bh=eSDXs1iBErDS79NVdNdY9EDtRW55Oz5UnXhb1rHekmU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F68S+BVIcO7kPPYdQx2I1f5VR2PTd+HJbmJNR8WPxoi84zXHrZ9zTAZsBh28UzmuX
	 8RfsK7Jfs2M/rIkssc9Ka32W9NuMGY47tK0ipgDsnbEORXCko8nNHiEUFd9y6Nc6Cf
	 77XoF7ml7YHp+i5bFYPzNYM6DCKqzR8xu7fKTLgZXjwcIhuRlePiag944fUsLi/55H
	 8njBfyF5yy5Hx7Jc8zuGYrkvo47+S2qTt4mIP/hxJhYBhN6WaG1k6v9x+EpUybKQDl
	 gen8amrxTbYdeag/BrCtTZIRAyZt22LlLNVrmoZtpEucwti1eVD6zNW89zYVuPq/xT
	 vnP7LtiJjn1ZQ==
From: SeongJae Park <sj@kernel.org>
To: Yuho Choi <dbgh9129@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] mm/damon/stat: roll back context on damon_call() failure
Date: Fri, 29 May 2026 07:44:35 -0700
Message-ID: <20260529144435.83930-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260529031519.1617000-1-dbgh9129@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: nrybb77ydport4pxwn3ycprmchgf56as
X-Rspamd-Queue-Id: 74CAEC000D
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-HE-Tag: 1780065881-36609
X-HE-Meta: U2FsdGVkX18LmlPLNjLoaj0jqZh9gV1jvvv05ND6XtH3hJpvEhL/OP4iJaSQq/xZ7Vixl58OeLUq5gdRz6Ye5cEROVdZz4yk8fNmBCwv/IjW1unPt9xJLDxgLPBiDtB0M9VYIKoqQ/i1bko+EaSQvoRRmugvOt59PdVR10aHjYwiVGga3FhD/+SwU83Tr+GE1JfOBPTYR5cxjkFyYB6WJfzMRJpOJ/W0TormSHOjdC+N0vp9GEQwGgN/31TXK1ruPH2bo0B+qaw+BblnF3MOJk0UGOtB+IhfHf2d76TDsOurpjA0MYG/sPwxYsNeMoGjsnyVPcgn2FZlj20nA5Kp4kENHOgZCz+jEtOS9cDSNuvYfGgaZCocRO1L9GhwR0WgWgPFgqXaO5XnTZZirwFg60WngAlu4+xzd6Ctn8RZ3V22ickEUK25A/Bgz3B9ieIEyxCPM+lE3wzAKMT377jpCdzDh46E5NguZ2aUtCeaXMonBX4oANERMNIBgPiXi2YEIKHFQSZHbnoNpMgWwxdBMHQM51RoZuKzfcsZbGhJqghA26Voa30fB7edP4wP3jsT9v1C4bPAYAao0IIKC6+Zfe3H52hMbfwT/Ds6V/LkL7bpYqMN4b7chlJHl/7Vxf1yrq+KbgVm6WXsIue+mBW1lX8K+GX1GNNbcTbjCh9/JujB2tVqUSfq93q6RGWu1z7hxrcs+oUOfx0to8QnalF1/jYpA8bRbhqhquvp1PmdVVU4bWEXHlrFyJFCkbFNymmZXdfsuSsT0jGf/BE2i3e2XRKUdHDDvtEuD2oVwxWzEO7WV6KbVvxxCU2NZ0CpajH7BhMd13JiZ5oFNYexyDJFU3S9/B3o997Img54zz2EfqK+ci66xMrqch8l3EGoCsAx4XPmzWUFVbFEh0d4mguohtOz1dtwf8X6jZ1c683Klf2RfpxS8mujeytwVyv26vZaAxrA4/7BIJ4cCJGfig+
 /jPAnCDU
 ANwAX705eK9Z4HCu6jCLILRZH+CLhqD0wl76JcHy3nAP1AEmc49kLeXEefVNm0Iq3YxaXAi7SCNGbHXmAEBERg3A21wofh0t49Kj1bNhSWmFJfRGjIjrRvd+o15t+gkT2DC1/fL0rr92q4v3ghJHbTYG8kxPk3iIO90GPvwPSmAJ5YjYeISzTW45EFNtbfkMPEiKAwcxI+R40PrdqouCwI/bAJ9YCII6YqDEOIUQzW/mHQNf73uOMXTyMU9ywMqs1yni6r3sjCaGyxcMQQPsFdNX/JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hello Yuho,


Thank you for sharing this patch!

On Thu, 28 May 2026 23:15:19 -0400 Yuho Choi <dbgh9129@gmail.com> wrote:

> damon_stat_start() allocates and starts damon_stat_context before
> registering the repeated damon_call() callback.  If damon_call() fails,
> the function currently returns the error while leaving the context
> allocated and stored in the global pointer.
> 
> The retry-time cleanup added for this path only runs if users try to
> enable DAMON_STAT again.  If no retry happens, the failed start leaves
> the context allocated indefinitely.
> 
> Roll back the failed start by stopping the kdamond before destroying
> the context and clearing the global pointer.  damon_stop() waits for a
> live kdamond via kthread_stop_put(); if the worker has already completed
> teardown, there is no kdamond left to wait on and the context can be
> destroyed.

But, having one damon_ctx object in the memory is a real problem?  Why?


Thanks,
SJ

[...]

