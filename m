Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B951BCCF2D6
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 13:27:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C13E76B00E0; Mon, 19 Oct 2026 09:27:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BC3E46B0256; Mon, 19 Oct 2026 09:27:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADBF66B0258; Mon, 19 Oct 2026 09:27:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8AD536B00E0
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 09:27:06 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 21EF5A828D
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:27:06 +0000 (UTC)
X-FDA: 85339451652.26.419B072
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf13.hostedemail.com (Postfix) with ESMTP id 7C5EE20011
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 13:27:04 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YoO97zB5;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792416424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mZ/yJ4dwS0nFEA/LwTAGUHV7Cz0xHftBUnFwL0NH36A=;
	b=tx5WjBi325BgydkpCiduk76hYZ3CcHsI2GdhdahiFBPDwcaD744ejOL99/AjCtSBzoG99i
	iq8LH4hSDkchIByu7ZbbpTjdnF9o1xTcQuytM0Q3yspiuSUR0T/2Wra40kwaPvV9cwuEKp
	rsMR9lkRO74OL7XG8Aue1p2NlPRdNa0=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YoO97zB5;
	spf=pass (imf13.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792416424;
	b=rqhHwemuJNNDhS33rYpTJJkUq0dkgitts0t400sQ6WqaHiJRzSRmLiNp7uq4br+1FgamIo
	OSq8//2N9jkivmXWkaz3iXCdPVhhBn5kdSRbOXGb/iYObRiBudfX2wc0+px2Qgm5ZE0JzY
	jISJbh/ICrJOgEeGjTBuf+TsaC0k8vk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DCA5060136;
	Mon, 19 Oct 2026 13:27:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25A0A1F000C4;
	Mon, 19 Oct 2026 13:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792416423;
	bh=mZ/yJ4dwS0nFEA/LwTAGUHV7Cz0xHftBUnFwL0NH36A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YoO97zB5l64bkgGGRHVPrac5zt4TgQBHFw8dQ6KbkSJLpA8ekU6CJ+u+NzM8vAHU5
	 qntGXOzMdi7UI99ZlQ6uC5G8+plqCHWSg7kwDtggOLoW18k/GrwWpSOMd9o9OGd+o1
	 vccqzwUfqlnb4ySkhIN04iSfzLK6XSj8XdNC97tmzdWg3tDx5AFPF+6FXgrLkscngc
	 TrHXsu8bGQtMio/5ceUpfT/TqSDXGvCggZNggvGYQELY2n2OJe08ZDUwPWiLzY/Icz
	 9BUSvn2jhfje8yUwI7NZy3xA7pXcdf25LYM/7ajs0JZDnMKmAYsfq4R7e9YMnDa+HD
	 BazwhF0WgBzIA==
Date: Mon, 19 Oct 2026 14:27:01 +0100
From: Harry Yoo <harry@kernel.org>
To: Vitaly Wool <vitaly.wool@konsulko.se>
Cc: akpm@linux-foundation.org, cl@gentwo.org, hao.li@linux.dev, hch@lst.de, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, nickolai@csail.mit.edu, rientjes@google.com, 
	roman.gushchin@linux.dev, vbabka@kernel.org, vitaly.vul@partner.samsung.com
Subject: Re: [PATCH v1] mempool: fix min_nr exceeding the elements array
 after concurrent resizes
Message-ID: <atYZnuRTTG7iweuK@thinkstation>
References: <atTh-yyVIPQ-zNWJ@thinkstation>
 <20261018160315.1465504-1-vitaly.wool@konsulko.se>
 <atTv1tg9q9n92kZv@thinkstation>
 <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <F846CE95-6D2A-4D53-9C09-5C8630E2C8A7@konsulko.se>
X-Stat-Signature: ynx36zkbsfprnsegagx5e6k5tgiiq7oy
X-Rspamd-Queue-Id: 7C5EE20011
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1792416424-31762
X-HE-Meta: U2FsdGVkX1/QoxF5iLHHzi6bgkUeZKr90jfnNH7QOiL/HQ+RL2BJ3uAEi64oNmmnIPND8geMedgTfIyRZ5HB9Hy8F4wSW8f1FGwYCRMAbcdNAPOwREWXD11cloTr+DaVTcjR6f1YQz+4uE9VAiySK+NAlbOsNCigXnmRSMu0n3DPHAFb6WTd0VU1PVOO/KGdKUMAolvL8K9Ww4Hz6Mv22EokGRRkceDmN0mhfkR2tJy+6vGOk823+DG1tadcaAQ+R72rswzu+WZwVZ/HcKSitchH/5jV4zWR0/gzmMPG4O37vKUhDQN3jMm0P81o7RvIw99VhIXyIMUI9UORsFPuiaUGclzP8CwV8EgukcvwE6SRzys1ZQeJpa6EVE/5zsLMoOC12YQUva3N4+ck/S87Kx2bIae6lzRrfI113cXTV/xxBVabSz9myd/m3I8Kh8KdE07gt/qFfB3XJiX2ugVimH3SGtK70z/uT2270gUfWcAKkZh4L8mSMQviGAVNHvqU4l6YGsPu7M1J4QuhLGvo6iXzvxI3J+E1sb4HGRMxwKfkaXEFNxXRMitbUB3uH7CTid+ivJ5OddDyyla9HsOzplqDFZvSnwGCS/4s9uQgTlUQrf1pFOzrOF1Yucb1EyZoFEZSR3AVoxGiZ3mdNeZZrPJ4uaU9t1HpXNAIwnXQVlUQHAe82nD9c6Od3uA0k/NoIOXCspYDZOLLZqsbMA2e+iKnggseBlr0y8oi0hzXaNFltrFupSBZh1StZsvq13qOQwDCyXSokCeyTRtJJy7sR217Y3J+VQiOOh2hx+SymCBAo5nT1JZvp4HCCqKHxgTM/tYvoXh1Nhm0nsU4jYD3jTMo0Ox5PoBj9Lh7rM0makQ32XicYmb7j2vA/cWZaPe+2YxbWW0739Wd4MVU97hXwlP5H9xhKzLpVTUNOTts11L1Q0vGEHORveiji7t90EaG/OnlJdY9jgeVHon8SWZ
 dYQ3neoH
 LbWeSVYVAGsOFqD4r8LXijzZZKS3B76cPrFoV//JPLbEx4w0UZBiBHSRBZdKcW9rZyim5x3aDTeqWkgCXyzq8rP2K8ecGO+X+gKUVG3oeZNrOG5LgsP4Y9AV3EBNdvmT1tNaFgJcSG935s02O5u0fpviYDq2vrexvE2Q2AC4lxLk8aN/5qj5qAmMsNYXYHMvRU7nCYILUoKHjm2SOSMMPzugFXNGBH4bN6dcAytdjYrlzYUo9aNmw0SDkCevoyUgKNaifloPCUr0g/mVWyOIu/No4AYtSMgAAvO1JbQ8cvX2DPJNPHWTWrba1iJFMGxxvx2rl1sebX1zgexjzK0RdeiLqO6/QNtUqEgGT
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 19, 2026 at 08:45:55AM +0200, Vitaly Wool wrote:
> 
> 
> > On Oct 18, 2026, at 6:15 PM, Harry Yoo <harry@kernel.org> wrote:
> > 
> > On Sun, Oct 18, 2026 at 06:03:15PM +0200, Vitaly Wool wrote:
> >>>> How about we take my patch [1] instead since
> >>>> it isn't prone to this bug and is a nice optimization to the existing
> >>>> mempool_resize() at the same time?
> >>> 
> >>> It is not a good idea to squeeze a bug fix and an optimization
> >>> into one patch.
> >> 
> >> Generally speaking, yes. But that patch had been submitted before the fix
> >> popped up, so there was no sqeezing per se.
> > 
> > I mean the patch you've submitted does two things (wihch is not good).
> > 
> > It should be split into two patches that 1) fixes the bug and 2)
> > optimizes it.
> 
> I don’t think this is a fair statement. I would say that the patch
> I’ve submitted improves mempool_resize() to be rid of unnecessary
> reallocations and data copying, and that (improved) implementation is
> *not* prone to the race found in the previous version of this function.

We backport bugfixes to -stable, but don't want to backport
performance optimizations to -stable in general.

-- 
Cheers,
Harry / Hyeonggon

