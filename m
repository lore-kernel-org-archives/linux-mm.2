Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 32FD1CE8D6B
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 01:40:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 740408E0016; Mon, 17 Nov 2025 20:40:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C9888E0002; Mon, 17 Nov 2025 20:40:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5DF718E0016; Mon, 17 Nov 2025 20:40:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4A1B18E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 20:40:30 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id E750EC031E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:40:29 +0000 (UTC)
X-FDA: 84122022978.16.8866555
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 499EE4000E
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 01:40:28 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K0OFoAo9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763430028; a=rsa-sha256;
	cv=none;
	b=GDK15WQeaodh0t2T8x1NGGoWzicfptT2dy+jVikgIzBQJnbrt0CdaYC9fC4btFciU7dTJ1
	yD5jhCbaMv663KGXBlEbnqxNgtSF8qz/Gx298p61u2xiGO0YHdWTSB3h9pnLvBiPrSa9Ij
	Flm7Nd1z40MDO+XR+Q1DiZsCQCwRJ+U=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=K0OFoAo9;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763430028;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m18BP2IdsDGFqKtpfq/YXCq57SkwYNWOh9NFp5h+cQM=;
	b=pr3re+GdlaIWv69sMgnE9/7lvF9LCgnlOXbAkgC+X4BPXwtfC5sAJ6+o4X+lkr7dQFVzWQ
	EMdK8Bi+Q2sGkDUvzEeqgS+m1ggHw7lyefS9+xDJn9MFChKkicTU/rB9da4e5KU6WPfDHy
	XnbGQ/H20lbqqZe+Xr/AdsZYhvao+w8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5172541A76;
	Tue, 18 Nov 2025 01:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37554C2BCB7;
	Tue, 18 Nov 2025 01:40:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1763430026;
	bh=HC0wW5cR4LQyHkZxX4Q3FPGBPQk+o6MWSt6ijm5OY7g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K0OFoAo9hpMJaYk5dmE4U3o6J0wqXWjvkf49BV9l17fiB/Tw7ezuWPcWRCFpF6+uq
	 wB0dp0idRFjw1AqdQc5nCqdC01DOyUjjegb/Kxn3XdvGfTnFrm9h+cK8h9D8bbGc8a
	 8QpsqCE3j3TVhs8W2DjNfqv7TgELBFr4Q1PecDPxpyOrGIZ/r8BB+hNQCRQz94pBjY
	 H5izwudDqYftYs3d7Wg0AGeaWq1IVd2akkkB4xpKeTxRqlGJF1A4aZDSkcE8d0C4d/
	 //g9njU4SUGowAIELm7VJEPS+BRjl2e4ZQoCGl3BRZhFdMuz+Xd/VGFYF7u217x+m0
	 kRfdEb4aQmS9Q==
From: SeongJae Park <sj@kernel.org>
To: Jean Delvare <jdelvare@suse.de>
Cc: SeongJae Park <sj@kernel.org>,
	linux-mm@kvack.org,
	LKML <linux-kernel@vger.kernel.org>,
	David Hildenbrand <david@redhat.com>,
	Oscar Salvador <osalvador@suse.de>
Subject: Re: [PATCH RFC 2/2] mm/cma: Consolidate accounting in dedicated functions
Date: Mon, 17 Nov 2025 17:40:20 -0800
Message-ID: <20251118014021.75804-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20251117121502.6db0fd7a@endymion>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 499EE4000E
X-Rspamd-Server: rspam07
X-Stat-Signature: m3zgy7yaaq5szg9o5pizrejkay68wkq7
X-Rspam-User: 
X-HE-Tag: 1763430028-349235
X-HE-Meta: U2FsdGVkX19Q3gI0qnA0OBW9AMme1w1PrP46pw1pUMXaMwFUYWEMI/uUz+NaLPKEMSXwXARHY1qSEZXydDQU/TIrHwvzAazTawhwStj2OFa4YhCL2X2DRTTpPCRYQKnKyFXb4EYYYNUuzsVAblJV05sX26KgN9uGvSqUAIrnVjaZaE2UEBoPJfqX0OMn0aEtuCIms6Z9f4GNkPEM3RKvva8GSuMWvlBcPlMz4ywvM2quP6L2NiyHspb2IZDqmsI5tyUXExqe7nlJ63pfSvuNHxAhNMI0ZYWDrAIEV6bstToBNwbIgYwjlHWbxNCuF24ktovi14PKXMAEPAA4bWzF5KnKwuUQP0H4iFRSE4fDIdalSOZwLcbD/R/yALQk5VouK6YGZO3WCWYEXFdWYrfATaJMJ84G0RXpW1c8WWJ622Oo2GnTlNBBsniY8VaChd7pJoeIFW3ZGNNtzYwJNZu1zDdplIHzjqusuOD7DiqRmfNL24ZOUYRLzpBxOOkf3XTONYnQepsYtgVmlbTnVnZUbGgXtDWnIu0ld5ceD1wfjyQmrTFm0kZUaKV7EjAsOmn6/fC17sF+u7onVdHBqb7nIrHAfvPmiPtXkmvIiVuBtsm61bsanDMumSjT/vB+9jva9Wj2WMxpeL5KGkHVBc47DX7Tf8FE03qozJgQ2lOwSOxufFkYTbB7EPW5lj6oXhQkznxxhiGGMHbc7hBzz2/6rhczG3Jw0VQskSypZvW1s3T6dp8554GRWcH/BfnY0HGbLJOmzevz9RLF1IW4RItV7LFqeRXEZKeJpgqutm9rlIA20JN0tA22Ixx97tHudieuyqjK6wW0b8H6QZ2t/B3mJwK8ybURZoll+h/oA1reNqcqsU4hp9Jwc4oIybPdROEOwiuEIJRMDKoAs0L9wp4DUSQBBzrJLbbAFAjBU7ax7wsrN+QUZ6VV1vZ3921+RBQ3ruogjrbSXmwWLxyZSo6
 mmGqwq6k
 jH7bamhKkhNOBXKiljV5MjWjqA7QlKi2N2jns/FBck+4wpoU0mUikbmJNztQRCLKNmpJ/iylGIoktnrvILm8610h5Qvz/331YxD/Q0IfaUrmOOEycu6FHx3o1ulR00noj/9Othfk1jkC9dia1fQSd4fBnIG5QpPDNSvpLN04mSO83z/V38fvZqH8BPKVh2OfwrirPqKcGbZ3cd8GglFRD/Ivvws5gnbFhIbaHQT0EKqbFnEM=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Nov 2025 12:15:02 +0100 Jean Delvare <jdelvare@suse.de> wrote:

> Move all accounting to dedicated functions and rename them
> accordingly.
> 
> Signed-off-by: Jean Delvare <jdelvare@suse.de>

Reviewed-by: SeongJae Park <sj@kernel.org>

> ---
> This is based on a suggestion by SeongJae Park. Comments welcome.
> 
>  mm/cma.c |   43 ++++++++++++++++++-------------------------
>  1 file changed, 18 insertions(+), 25 deletions(-)
> 
> --- linux-6.17.orig/mm/cma.c
> +++ linux-6.17/mm/cma.c
[...]
> @@ -1029,7 +1022,7 @@ bool cma_release(struct cma *cma, const
>  
>  	free_contig_range(pfn, count);
>  	cma_clear_bitmap(cma, cmr, pfn, count);
> -	cma_sysfs_account_release_pages(cma, count);
> +	cma_account_release(cma, count);
>  	trace_cma_release(cma->name, pfn, pages, count);

I was thinking we could further move trace_*() function calls to the new
functions, but this version also looks good to me.


Thanks,
SJ

[...]

