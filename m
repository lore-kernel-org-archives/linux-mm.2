Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0534FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:16:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CADF86B0088; Thu, 30 Apr 2026 11:16:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5E816B008A; Thu, 30 Apr 2026 11:16:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B9B8C6B008C; Thu, 30 Apr 2026 11:16:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id AA87B6B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:16:06 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 395CF105293
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:22:40 +0000 (UTC)
X-FDA: 84715438080.08.C0F3C79
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2BCF620019
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 14:22:37 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lwIdnL0V;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777558958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hAF1Kw9w3AlMs/7ik3R3v+TIGUdlxEBdwR69iwai4JY=;
	b=CjpFnVMVUy84RPm9g9J+WIJSy+OGsvdG80SLOx87IUGIoHX65XCD1w/W5DWDL/MA8W9mXM
	9+hxiTbxoWD1Yj6pOyKX9LIBgEIj6CykF86Y1jfykQEpz6wqU6iSNyDEh9gF6vwr0ihlv2
	Uyw1IHPgRT5VXm2mOymm5ctGM69VtpU=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=lwIdnL0V;
	spf=pass (imf13.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777558958; a=rsa-sha256;
	cv=none;
	b=SDdHlrS17pqcE9Hp1modRt3rDhr4WZL4CBDRQ/PNSqJy9+5kJcGGjJ+qqUVnR1txux9Flt
	IgkVNaIJ9vW2BAG/NW1oPpr+sRgXAU1JGY51pJtpvupQ2cHN2lkEF5nE7cGqMvdPTj2OYg
	uKOW5Z9caO38ypgKVNSnlkwPkh3lRTU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05B1E43BCE;
	Thu, 30 Apr 2026 14:22:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CDDBC2BCB8;
	Thu, 30 Apr 2026 14:22:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777558956;
	bh=3UVBOBagPXYOyYlAsvxW9a8qwwwtxiXGL65ZGxXUs0g=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=lwIdnL0V6B1xgbXh1rsqi180ml/YIQuwwmVrz8pReUB3hO+1SFrjb31YvG3wuQL3U
	 pMkAfwtAgAxI1epLbRAhdgm49Cf68DKmh9Q551UbXS9SNeTcbyPdYTnSGopt1IB9oc
	 EjXZUhVZ+wVon7RjnY9n+1msH7KPAxbuFiO9sTzs=
Date: Thu, 30 Apr 2026 07:22:35 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vineet Agarwal <agarwal.vineet2006@gmail.com>
Cc: hannes@cmpxchg.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 kasong@tencent.com, qi.zheng@linux.dev, shakeel.butt@linux.dev,
 baohua@kernel.org, axelrasmussen@google.com, yuanchu@google.com,
 weixugc@google.com, david@kernel.org, mhocko@kernel.org, ljs@kernel.org,
 linuszeng@tencent.com
Subject: Re: [PATCH] mm/vmscan: fix delayed flusher wakeup in MGLRU
Message-Id: <20260430072235.006c67550ab3d182d6cdce19@linux-foundation.org>
In-Reply-To: <20260429185441.486804-1-agarwal.vineet2006@gmail.com>
References: <20260429185441.486804-1-agarwal.vineet2006@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 2BCF620019
X-Stat-Signature: hcrdi4urbsetyq75ihaaw4skiaiq6ys6
X-HE-Tag: 1777558957-435780
X-HE-Meta: U2FsdGVkX19tmm93cEbByvYctSHmBgxLnm8hLVT+6A7ITkv9zne9PgWVAsP11vcjhXIpJdE3vg7FjHv2S2zlxTqaT4NySY8x710L9bM5SM2WLduYfmxgQmwO59h9oHjT0eEzLPiAb+GLSRLkX3CAMHmGaoyqVlCIKq5L5rMubAi2PHHm5//qcGaqmLcj0vtgJP23RaDIJSNXQ0c78pzN1ss0BI9BDwA8+iPsI6HXy8KWMKYdcynkT5ASKBvug9229wrLLWgI3FzgVnOxewB1SnpjvK8Z6QRA/TiMYgBwUoHqJS5KylPWrH1tw9ekYFDoJCTFt7PIeLrCZig4BZz5eWDZNP1t7VDxb1p+iKbonpH88AaQnsCLjeX7w1Zjy2tOXsACK73X89bfhOBRFHFEpFqaMjXZX3lHUlyLPq6F+Hv6B/CyzGoeiPTeosZeQVpAplRQIkjy716wHVrxHM2eWzJH8m1W7v506HqeFu1DWf0wQG+Wxw0LiHyubE/bQrbL6KYCCuslICShuAXAjqimE1mPuD0T1+RtZSuaU2OG5Vv2CcdZUtfzIYZe7GgQ+jHGEIZrExnqgq3GT7svJwp022BV6T2zu7bXfH5xPOJpKY+veWTCGPLwPRkEVpZhAXC8LXMfrTKD/42yC+Ync3QFDxHRFoWHF3X1hm9fwz6z/8rv6YXMbWfmP66QD3PAEZWotTDt0kqiItLEO36jhTsL/JDZ4bh97jgg412lRF7e5eiFypepoM+y5B/4BnHR3gh/OUqXMr0Vr+FjABF4GP8yLGh7fKvYPkwGmfVZOrxrLHr+qnI5olrUh6rP0aXvvJzdpg6jiNcuXQbsFcsN1KDphVvTgw+owwGpRVfinL8RbfcXbAs82KOSfKLuSpEmcwaXvDGcxZR2yhIowv6FtLbl25oLTAoUZ4sRElkZ8sIE+lV2Lw8g4FTvG2j5/rj0Q2DDd6AGElsLyX5oy4U03Df
 ehKIkiAc
 turDkADvN3H5mEzYguv2UVhKW0tygWg12Sz70LpCH6IldEiKtAs0Id6kAW+9XEUBMqr3GYE0zyJIxem41SdBktnU8eWx4+2NqvrpCPUBckJ6IIsKMI9qz9kNTtnmX1rLf7DPeyo4ZW/tKAJx9r4JCAsiybKOEAq5osUA9AIjcGPAZHyJA8xC6Nke4o+L0cLp7sz7NNiEbgQQTnRm3rCz8FQXjIf5qiFi4aan3+j0cX5i+wyTQVtdDtjlGS7syVc8VWs8/E7YXuzGLnMXAiwpmOB9RG2V1qSuIF68EmLWmwXSO9MIQfeBtIX5IHtzSnayaY6YqWPgH16loICDRkJrmju3/AbX6i4fFz1vcLYasyBvW0MX13U+9oK7LTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 30 Apr 2026 00:24:41 +0530 Vineet Agarwal <agarwal.vineet2006@gmail.com> wrote:

> MGLRU currently decides whether to wake flusher threads in
> try_to_shrink_lruvec() using cumulative reclaim counters:
> 
> ...
> 
> Make MGLRU use the same per-batch flusher wakeup behavior as classic
> reclaim by moving the flusher wakeup into evict_folios(), using
> batch-local isolation results from scan_folios() instead of the
> cumulative counters checked later in try_to_shrink_lruvec().

Thanks.  AI review asked a couple of questions:
	https://sashiko.dev/#/patchset/20260429185441.486804-1-agarwal.vineet2006@gmail.com

