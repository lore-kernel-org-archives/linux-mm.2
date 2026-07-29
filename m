Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F29B8C53200
	for <linux-mm@archiver.kernel.org>; Wed, 29 Jul 2026 13:59:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 192376B00B2; Wed, 29 Jul 2026 09:59:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 16AA36B00B3; Wed, 29 Jul 2026 09:59:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 081686B00B4; Wed, 29 Jul 2026 09:59:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D51976B00B2
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 09:59:27 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6078C1405F1
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:24:10 +0000 (UTC)
X-FDA: 85041882660.09.9030DD0
Received: from lobo.ruivo.org (lobo.ruivo.org [173.14.175.98])
	by imf18.hostedemail.com (Postfix) with ESMTP id 6BE4D1C0004
	for <linux-mm@kvack.org>; Wed, 29 Jul 2026 13:24:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=uEN+UMJP;
	dkim=pass header.d=ruivo.org header.s=mail header.b=FKTSo2F+;
	spf=pass (imf18.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785331448;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ixtrt6XGyRBDGUWsSPh7QPapamhFNFlpNmguhXoJlGg=;
	b=dfFgjnd4lPT7X4iUh+EDVF8fwf7e+IPk4wZ0MbtCsilakpnICBKKSywSkfxXaq/qPMBM2B
	OjoCJHmSt8AvfEAiCHcODFby6rZw56qjcErUVfCmlcRHezKbqblLBony7P/YGHJmM6qOpN
	7j/s7s2+lHZrFqP8CqvGt2ERpnZZ488=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785331448;
	b=LYVhmKeUg3xpZpPzE9hqmn5PE1s2ODyUVLtgG2blusqzbfYKvi2y3fp/JS0AVJEJtT2ARL
	Wh1VgsWs6dkfwWgBurqU7RU/O7qfB0vULuToDDgAUsvquGGPeFv7vetazuDayRplG2qRdW
	S32rMvyt3P95OF3xQjCBx6x9/qoZRjE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ruivo.org header.s=mail header.b=uEN+UMJP;
	dkim=pass header.d=ruivo.org header.s=mail header.b=FKTSo2F+;
	spf=pass (imf18.hostedemail.com: domain of aris@ruivo.org designates 173.14.175.98 as permitted sender) smtp.mailfrom=aris@ruivo.org;
	dmarc=pass (policy=reject) header.from=ruivo.org
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785331447; bh=w5rDY8+UQopQ6re24/tZRqTsPvelrgUXHI/ysPwHa+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=uEN+UMJPGAeLG1bU782g2REEHo+bwgkC4Tstfem6PV724SqmhAhlC8oLdT0HWMNEV
	 0O+RFx54diXnfAXbZ7OZbiFoAXRCMDLhcPFbPY59RIFI0NAjDGPhlsiSCtGY4+D8OK
	 mLEDOBzLumaIZVoHVcDlwMpSVsb3iFttbHvO4o3c=
Received: by lobo.ruivo.org (Postfix, from userid 1011)
	id 74E06529A7; Wed, 29 Jul 2026 09:24:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ruivo.org; s=mail;
	t=1785331437; bh=w5rDY8+UQopQ6re24/tZRqTsPvelrgUXHI/ysPwHa+w=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=FKTSo2F+jjaxOtySg+9M5QvSLvQxxItd6zUNjcyaw2BS9WIGu6kXeX6lnzyINOcE4
	 9GGXPSQPBF+XWJ6G/5Gju0zUC+UEygiY5JOLmox5DZ68tL9CmeAFuszOEj7hIY64Ky
	 FT7c8PVTa3vIS+QwxHX5CivhKEIq8LCey2itjlpc=
Received: from jake.ruivo.org (bob.qemu.ruivo [192.168.72.19])
	by lobo.ruivo.org (Postfix) with ESMTPSA id 0D0095296D;
	Wed, 29 Jul 2026 09:23:57 -0400 (EDT)
Received: by jake.ruivo.org (Postfix, from userid 1000)
	id EA63315C541F; Wed, 29 Jul 2026 09:23:56 -0400 (EDT)
Date: Wed, 29 Jul 2026 09:23:56 -0400
From: Aristeu Rozanski <aris@ruivo.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>,
	Jason Gunthorpe <jgg@ziepe.ca>, John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>
Subject: Re: [PATCH 0/2] mm: gup: cleanup gup_fast call chain
Message-ID: <20260729132356.GC1736962@cathedrallabs.org>
References: <20260219050250.061598056@ruivo.org>
 <8b1cefc4-93b5-4138-9ab5-2dd1cdc7ec78@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8b1cefc4-93b5-4138-9ab5-2dd1cdc7ec78@kernel.org>
User-Agent: Mutt/2.4.0 (2026-06-19)
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 6BE4D1C0004
X-Stat-Signature: qq4ygafdge7tn9uh4p1eo3cdj3emo6py
X-Rspam-User: 
X-HE-Tag: 1785331448-753935
X-HE-Meta: U2FsdGVkX19WgHquXkPFRipGZcZA/sGeHsu3TclLvGBVRkBPafli14asbYEVlrXUnSGqW9fCMKYgmNBKWBUiXCnJFzD+i8aVo0GWn/gfTcDEYRGKb4coPCloLXcx7rM08NGR30EbF4PDdZVU6G//tmIASjmzM64ODSW9mOfwDeYMBFnp3+F2D1tIAGdo1/M/IigfAeTMhHE92OokkoA+AMm8QNJ/QEYNhSXZXneGvgZqMr6KXc73kMu2RIFsRad6nXZ71HRPZSrebr86U9GSzASz+qu7VC/M0v51sgb7obdSZktwnM1pcaVSLboaT0Xd9TbCvGNHiJNz77OK2nxY1vIyZxyjny9Jz5ONovQ9ycrKX7UssdS0GhxW04YejHkX5Jn0v5Ih5MYdMNOUAIku1b93dH1u/kh2jv9JYvZmuMypnV7CGfILQfyUolBLG9GMEGBlGq2rcshlhgWVElciBb6qyAjuczXn6wF7z1esHZkVLMrlzUcMiB4zmHjj1pIFaFPC1ceU1OiuQhfWBaDrSLB6RV7e3qync+cDjy7GUfs0Tm2I2Mqk0nXJjQe8f0i2kjRNStVXFW2ORWEQsr97DAD/BT0H5po7KW+cBT+rGpiXBQl1KPuy99XmZONog2XL+NSALtA87shz9i3HI1P5u0G0T72uwqB+d/HESTlTrWjH/nuX500NEu420U0dY6zLHDw1QwTATZiPiCB6FaPUh8DB8r3xkkvFknRfOD1N4b4ZoUwSoqUCEcCzS7xz1D/IauH8qgBhGEnma5E2d/NMDtpDec+NeppRTuDr3rGL6RZcCKDP6XBuVYFjnHwE5kVxrJpsCyE+wfnOXnXM5tBv5k/XyCcLxANlzsKs/4DlptgNz1aMTu8S0W52HakrlB2CDiKfJIKU4WH0r5gzwKsrGM3BH03um7AEuTkTwxm6/FTWGpriHH0az+fL31T/FSZ84WZ7zMpYPz+hrXW6K10
 9kcE6Ps9
 eTbD93PT+rYgh3VWU8wZiahxxyOaaxMZDBVtZAXeBuHwT5C2pFTq5fO7rYQMsYHuV9NEH2YFwC9udJkr1yTW1MdGMtqxnl8cJPdtx8+Bdl0yonlcG90EOZVuh2UY320kk6yGQlH/GKDrZQNQwDLsqBzaZOKuSEya/+gilQr/r3ZABFnBzR5wKBzNAtibt9NVXWL7D
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi David,

On Wed, Jul 29, 2026 at 08:49:49AM +0200, David Hildenbrand (Arm) wrote:
> Aristeu, I think there were only minor things on the second patch. Can you fix
> these up and respin?
> 
> We might only queue this after the next merge window, but I don't expect a lot
> of conflicts.

will do

-- 
Aristeu


