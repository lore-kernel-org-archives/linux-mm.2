Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4FECC5AC67
	for <linux-mm@archiver.kernel.org>; Thu,  6 Aug 2026 21:20:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CEAD6B00A0; Thu,  6 Aug 2026 17:20:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 27FA96B00A2; Thu,  6 Aug 2026 17:20:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195446B00A4; Thu,  6 Aug 2026 17:20:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5F2C6B00A0
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 17:20:06 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5901AC01E3
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:20:06 +0000 (UTC)
X-FDA: 85072112412.22.00CABB9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9559C140010
	for <linux-mm@kvack.org>; Thu,  6 Aug 2026 21:20:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hrEk5wHD;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786051204;
	b=QMOcYmj6hjAOXN4PrTFgqbfgWBkxx57yuWwN6sikvhdtuWAbD6WzXmhMbC/4TaUM+2vLIe
	MZv1mLIhMpr/haiAeBtR8BZFZ5/9r7L+3emh5Xl77OO8cfWESBR52JkoIfr2eznwvw9bJh
	KPUkdes27r3joq4ip8sILe917e9/RQs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hrEk5wHD;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786051204;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OH/jGTweKLDj5ljGoHRyVAtI3RPLntAr3emVuir6R8g=;
	b=twHWFFqKPEGeLrqGBj1TxLM/vLmSagqtWyvvbSRDzXpUCCjkz8+a8YU+6CbUnW1iiZxaQ8
	sWWiCYcNm1wllPIsPt7wZKH7+5blnQ39H2VFCx7GA0TRUz164dEHbydkr81gr+Yt2zmSSt
	57ajHgDRsH0fx7qHEN4NPUeWlpNuUW0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C29026004E;
	Thu,  6 Aug 2026 21:20:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31A131F000E9;
	Thu,  6 Aug 2026 21:20:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1786051203;
	bh=OH/jGTweKLDj5ljGoHRyVAtI3RPLntAr3emVuir6R8g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hrEk5wHDENIjlMUpYglMp8AUOxthBoNHko2cDBo4ILhPkeNeGv2vbzVajd5Cl9KfZ
	 r8kXXsvuRJo4k6nCzL+cAmjIX2Fcqm3OH37dKA4zq5jQ7cn9cTcWxFOrJfszmY8k1h
	 cDxyhIGIMzo11FQs4+okpNRoF+TcEYUhcJFsCUWI=
Date: Thu, 6 Aug 2026 14:20:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Jianlin Shi <shijianlin11@foxmail.com>, linux-mm@kvack.org,
 vbabka@kernel.org, surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 ziy@nvidia.com, linux-kernel@vger.kernel.org, Joel Granados
 <joel.granados@kernel.org>
Subject: Re: [PATCH v5] mm/page_alloc: only update lowmem_reserve_ratio on
 sysctl write
Message-Id: <20260806142002.ac4a349730f3ce15154a71a5@linux-foundation.org>
In-Reply-To: <anSRGASe5FIrqwlg@cmpxchg.org>
References: <tencent_FFD4F4D728AAE8A8AE0AF277A59854A29A06@qq.com>
	<tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com>
	<anSRGASe5FIrqwlg@cmpxchg.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 9559C140010
X-Stat-Signature: wzocggaypstiapaws3tomnt7gtitsksk
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1786051204-244253
X-HE-Meta: U2FsdGVkX1+w0yBG0KgdptbneBFa25F0PoIZWR6doDVkHP6bpZXM6+Mm0ZMPZny/FHqYl/4y2s99yP9cAP3Q/xpA1gqGFVKnaqS3kXYOEQkoNNJr3uY5dEbmTIrbhHeDumZwzUpm5FNfu4ADS35qJRYUxdLyr0YhPiAlEWEZoFfreRZJlxnbFqt2bOB6nLtasUND4l+zBj3BOrf71hG3Q70waZ2FFo+pX9wsHq/JZp/uahcmE7dm1gi12LXowcgrHqlX6HFlZjP67r31i5sSBwIn1ZVpELek4G63+xmdCIwcfqmsoiKpK3trLubQF6oV7FWs4pUtiqDrA6zO33NisYXn9m2j3L4vMM7RPiZVPWudQT5udTch0AnaVrCJDvJ/UeVjO9IZfuVLPzxQnuV5n1SzIRl9tWFf6dgNKlRi189zPIkzkcLJXdKP0EKwr/oT6jsb3PZNC0tfCDQqrwOa8vmcIOFRKjZY/KcTE4BykpCinE6JIG27acTyLPziSCyThyV/jREvjmuRSPibzPPJJNS01j9a0cE6iBO8Zp9MOTdel4Ilxbcyh0iJQYK0lhpy9MPJ1lrOgD2H6ox0m+9z9mpYblMah8kBxWbH/Qc4ll3dxWcrmnaGSwx6iKW4z/bHWLg3KahjnGfHjmocQjNbVqKznVq6gIMwtVGLVJw7I5Lky/jOY6q4DNCyxcXP7JmlztHNfEmkh/yFO6dlfsCpHYlhtvsDAPXif+ioy6G7+ltn1k7gxLnh4DYKJfQ16ZtJOGBjqEVHfAz+uFjUcmXbCyIkzV6v0akk2WZ0egc/mfwaBd+zQWJJG+pGHspARXQMSHin/frvhQWbNdYnZrpTAl5z2mHLBbFkzSLDiGSKVnb2o539ahluhhCcPwz3cWSSmjD4xrlK0dlNeA7ZvNiV1N2m9JTAivL/jYyJIiejEkKdtgvsVdQ5cvsKzDxXry/nuv+Ddve6M9pytn+eGxI
 rCtVs4lK
 Xw/7+p9Dgg6hi5PEpWyDCuOsOgSjsr+3WaqNscQSLlAKrlFm9LsTQy1w2J3DmalFc7HfV/p4I13u1Vh+AUMTWfsAZcIRpjb4hACqgZD8UJ5d9t6foIGY7ieT3OXYcM8/e4wkTCUu8U6+0kOGFZe8qPwxB/PysJ9ibNTbNaVgKLgjdhggE2JfZPbhjAtJgnjFbkyMbsfj6BadMH2yHdhLh/tt0rVybLrAtooA0VfaYKvuui9LxM1cypknzGB+iIVnwGF3KKtwgQKeqaZlYG4aAyDoO1mdbsJowfwKrX/1OZPx5VG294hBuUMUXptDhugwgR37N0f/U5w7fXWJUZoALvArIJIJdKwEWYY0GA25G1T7NQ0VbQlXBzjOEBfIFr9MePh5exexAYvIPG+sgr8wBMEX6J3gLe0AkDQgZJcKi6/LjBFaEmFBVYl02XQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 6 Aug 2026 09:50:16 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:

> > -	proc_dointvec_minmax(table, write, buffer, length, ppos);
> > +	if (!write)
> > +		return proc_dointvec_minmax(table, write, buffer, length, ppos);
> >  
> > -	for (i = 0; i < MAX_NR_ZONES; i++) {
> > -		if (sysctl_lowmem_reserve_ratio[i] < 1)
> > -			sysctl_lowmem_reserve_ratio[i] = 0;
> > -	}
> 
> This could use a comment. How about:
> 
> 	/*
> 	 * proc_dointvec_max() works incrementally. Use a buffer
> 	 * and only set the values if all of them parse cleanly.
> 	 */
> 

I added a fixlet:

--- a/mm/page_alloc.c~mm-page_alloc-only-update-lowmem_reserve_ratio-on-sysctl-write-fix
+++ a/mm/page_alloc.c
@@ -6932,6 +6932,10 @@ static int lowmem_reserve_ratio_sysctl_h
 	if (!write)
 		return proc_dointvec_minmax(table, write, buffer, length, ppos);
 
+	/*
+	 * proc_dointvec_max() works incrementally. Use a buffer and only set
+	 * the values if all of them parse cleanly.
+	 */
 	memcpy(ratio, sysctl_lowmem_reserve_ratio, sizeof(ratio));
 	tmp.data = ratio;
 
_

Sashiko got all upset about concurrency issues:

	https://sashiko.dev/#/patchset/tencent_A860C873956A52E26AD8D309A308A241BA08@qq.com

But I think I'm hearing from Joel is that the longer-term plan is to fix
all this up within proc_dointvec_minmax()?

