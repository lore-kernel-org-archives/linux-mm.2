Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF437C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 16:35:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9CA56B0088; Wed,  5 Aug 2026 12:35:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4CE56B008A; Wed,  5 Aug 2026 12:35:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3F056B0092; Wed,  5 Aug 2026 12:35:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B3E36B0088
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 12:35:27 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 062DCA03A3
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:35:27 +0000 (UTC)
X-FDA: 85067766294.27.2D3FCF5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id C71AF1C0003
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 16:35:24 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TLCmxcFt;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785947725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2IZsfPpsux+E527CUuTRqT8JGlvoLVPd2Xo1Wt0WcE=;
	b=78piMQjkoDKvKkE0fXeNetKGPdq828YpyJWBgcY3z36B8Ikl9idnn8/JV9W8XOVnfWL1bi
	HzX5+5UVQbd4OgfP8qXRJlbNMmdipMMSQtaQrhkB1IroujItZqlIdaLGMKeZIjKYuRjOYc
	X06/3HqqmzQWhz8CIjI0fewBNsHSvz0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785947725;
	b=fSayB4cngOjE1Y+djryzYH/KbsKUNm5k9THnqNCM+BhT1LSDDKMYqNi/CYVaYIVGlwucp7
	dtzJPaiZ24V38a4FiTMIvSiVLCREm1nTDTPLimZo0eXj+HtWKEry8RHMqKTrVSNp9cANBT
	0Ag9Y8tcyGSAxZt7Te67Z/EGE0jDTgI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=TLCmxcFt;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D00D0411E1;
	Wed,  5 Aug 2026 16:35:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3506C1F000E9;
	Wed,  5 Aug 2026 16:35:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785947723;
	bh=B2IZsfPpsux+E527CUuTRqT8JGlvoLVPd2Xo1Wt0WcE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=TLCmxcFtPmKmJw3b6jjHmbr4CL+s1zDyuXlk6OFlCRwEhNIeNLHi35W7Ls7YE82EW
	 W2p6+rK5IAg3hawJdr5lWGCY21Pj2UGg+57kqKrm+SqfUZJeBQvYI5o9Ut2TMonPTZ
	 QKuBORqJS01zEJaSl245TvO96PhQnIC2dTJFe1rs=
Date: Wed, 5 Aug 2026 09:35:22 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Karl Erik Hofseth <karl.e.hofseth@opoint.com>
Cc: linux-mm@kvack.org, qi.zheng@linux.dev, kasong@tencent.com,
 shakeel.butt@linux.dev, baohua@kernel.org, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev,
 david@kernel.org, ljs@kernel.org, cgroups@vger.kernel.org,
 regressions@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [REGRESSION] mm/memcg: folio/lruvec mismatch after cgroup
 offline: lru_size underflow and list_del corruption (7.1)
Message-Id: <20260805093522.e3ba46aca3a143207d68a65e@linux-foundation.org>
In-Reply-To: <anMmd1ADrDVwMO6v@work>
References: <anMmd1ADrDVwMO6v@work>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C71AF1C0003
X-Stat-Signature: ta9dmhc3wna3ddwk5dt4aqg6wxpjpaof
X-HE-Tag: 1785947724-654588
X-HE-Meta: U2FsdGVkX19ZiliK1lZw7cKQob58VLNMeF1Ri0QKNuXTwytABA54wLkHmqN2mUKNz5JnrFBh4csUbbJbZU6Rs3s23fwj4uHvFPowxpU6bIUgnvuB8WW1hnJQOz/ROZJOsOth/g8A9hEBVRgVmm0xMi/PwLLe9vB8jcG1o5cFpyN3G2uk7knVlvfI+Dh/4uC5FJ+udQQDLEPWf/u2ihSMrpo01ld60MDDaHlUwyQUx7jOYtI3x49lHZs6zt9+rCuPuHXYmHxMPpxHuxSawW8sWP2zvV/RJT6DUf5or5EbCzBwW3Nc5IoexkQzLcOf5L3M9/PXgR2nkbVF2eX5JJeRGuTOfZn5bwiO/7Uq3S42LL4DZsg6daT+4aoV/Q0yuDKPDyDwlmOi1nAlhiUOCOp7+jXl6KLYyC+jDFnikrmn7MbZF/Wy/Q0cSm7XeSV6kCUmhbFsxu0deCQdHmfXZxSIIvpusqA6GxQjkzOOL3UF7IpT/VwD2x74wyNsBI95viPC2H0Q6eiX9dGzfA08/9KNsfHe/+E6jFkXIzyH5n9zjKkWzEibKLFg+CSMJhjKBPmoVDWKt8bP6tNhVGFFZRHh8UBnGVWrNVcc3sUBoYeReLYuBPlutKP2TxF+5UqHRGH3nYA0k2y1QgDzqEUsKlu7ZIaw01t1VhuFvi/A9fch9DtfkWFuW7CBrk3DM+K4EfHjj8Boxg+2AljG8xVMmbr4okQiFSuKp3F9ecyxvC50S6KB886pBqT6VMlrJqWbKb803SWRMJ8lbCJFB28BJLf2hRuUD5OX0wHrxnX2sqbWdcsqXksjie0yLkpNze1rNIL+tDCuoC44tJL7gGCGC/LgcM+q+YqzOH7tbK8EUkFpiY4ncAesvwfUckW+uqXIk7OMTJOu2OiMl6CcLklvVAFgdMldX+1gOgEDp5GX5DR/ZbUcGRgIlO12HNCpAsEe5toVpW6FuBce5mPsJkfm9MJ
 4c0qnX4R
 rFsltAreFJJxKpgopQ/Jht1l0/Slp7/H7VnimaX4NahVuYs8YJcK9Prwu24nLcZjzevsBbglp5gNsxnl81Wo2/+xFyDDFWnQi/yT8V9qbottGP1xw5wIyYCbpKQfLWTh9y2snVvY7nE8bCffaPQ8lmHIjoD/uU8IVh3IvFQtKdtZ+l/l1Le5escofe1VHvwPvPbmI6LNcNC5BDuy7ASevAxTk4SZVJSgQ9OFO+MpWwHqQ1RBKfCJ5c2RLRgtvH6duR6bKg2sI63sZsKrPjNvxmEnTk5x/s8Qe9+CNtzKqWHX9WQvnSSBRgpQYmSuQwHyrFzFFhwGintqNXhHvaXj0FR8IYeyQNLqSu6CnpaOBIWBmuC9XQ/+tXo+qLSfYgxVOaMHfDBwLwBJjSJabJp6K7gJ9R1rh2zoi3B5C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 05 Aug 2026 14:03:03 +0200 (CEST) Karl Erik Hofseth <karl.e.hofseth@opoint.com> wrote:

> The following KASAN slab-use-after-free comes from a Fedora debug kernel
> build of 7.1.6 with de4660898b7a applied on top, provoked with the
> attached script. Further down are OOPSes generated by workloads in
> production on stock Fedora kernels. MGLRU on/off makes no difference.

Thanks.  It does appear to be a race between migration and memcg
removal.

Gemini provides some thoughts, although I've found these AI crash
interpretations to be a bit unreliable.

	https://share.gemini.google/Y6dMvOlHIFuV


