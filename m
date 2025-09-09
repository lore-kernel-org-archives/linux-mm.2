Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E6B16CAC582
	for <linux-mm@archiver.kernel.org>; Tue,  9 Sep 2025 20:08:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 347A16B000C; Tue,  9 Sep 2025 16:08:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31ED16B000D; Tue,  9 Sep 2025 16:08:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 25C0C6B000E; Tue,  9 Sep 2025 16:08:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1702F6B000C
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 16:08:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D800911A763
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:08:16 +0000 (UTC)
X-FDA: 83870798592.14.C939A8D
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 080C518000F
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 20:08:14 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PnsaUOQK;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757448495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nHiAt8SZC9VGc5jH6Z1uTisOoAikme/EPt+RV5cfjq0=;
	b=brX5Sy7+x1Wv29Ji+9bgB6eCv2QDcuXU9ZECHepgbgMc5j2QOFsRNZFAk9CwkSNaprR9Oe
	bIutqipVOLRpWVctJ/5S4/U4HJGVTOM1J1wU5iRh1nS1oCw4xYJPQTyrqoRqbnBM0vT2+j
	/jR88O3/5sCQIi/ddzwKbUTa9sIRlE4=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=PnsaUOQK;
	spf=pass (imf16.hostedemail.com: domain of yosry.ahmed@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757448495; a=rsa-sha256;
	cv=none;
	b=aQHy1KeJLc7JoGVr/xjs2rOkrMFMx5zjwtMMjSB6Dd5zkj0lYUwdOggLj7EBCbKe3xGPPo
	A2qXowOev5XipFnAqnwxRcnlf1KdVmzsBte7AoKK78a5tbe83645wHP1QyeuVpxmSJdHPf
	g9vKpsGJC7EqSqcsiZNcy2mJsz6Pqgc=
Date: Tue, 9 Sep 2025 20:08:08 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757448492;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nHiAt8SZC9VGc5jH6Z1uTisOoAikme/EPt+RV5cfjq0=;
	b=PnsaUOQK/8KazG0GY3kaADlGBLkrZLA4mVczpKQWH1EleIquSvWRrZTWltHxRPPKi67TwY
	7g9Nz4Vo+TOaVn6BxcHIOjQT7htlPNNKGSeM5xH7t1v3oyYYq0UETW1Ye9i6PgEnfOHahT
	QM9TNHbgKMeOc/3Xs7bmemvxjVzU4WA=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Johannes Weiner <hannes@cmpxchg.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <zhouchengming@bytedance.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] mm: remove unused zpool layer
Message-ID: <pmpmejmw4swnconhf3u5uzzhwtki2fdnwvt73vf7lzkigrhwmb@sarxlksng7nb>
References: <20250829162212.208258-1-hannes@cmpxchg.org>
 <20250829162212.208258-3-hannes@cmpxchg.org>
 <rcxmemdxbxuvtag2qv4sjxoh7ho4z3bz3od6i76rc5yholx2rc@vncn6iuuee7b>
 <20250909151639.GF1474@cmpxchg.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250909151639.GF1474@cmpxchg.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 080C518000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: qhd3r96c6mocc76i85txxeiryd71aiou
X-HE-Tag: 1757448494-899257
X-HE-Meta: U2FsdGVkX1/ZWNo3eO84fRvIWkbopt3Z1zDxGKyCtrrQ6OmmogdWrU5iDcmTEK6hdj31fm8h+ctw1cpzi9sUZtmNGC/iEpj4Xb3yvZLkX21beYrD9aVhPxoBpe5IFv8Vb7P0U8XJ5CxS1p+wZE5Qu4RdDxwJifR+CHI0VJK7eo0wVpVyVAroQnDt0WARng8NpbcyanHU+Q76y4vLtuSaJnYJ5/xTUXHPjEn5+nBHQhE1K7S/sqP9FD6Gqk5138iMb+GSEKe0wHNNLM19b9zO3dBRhO/7NRWok8NA0VuFu0nU0fjXF/qJN94KtqXprlhD7OBSoQTzltEdaq8pxSy8riQfKcBRdpd6DL+OjRvURiYOe7Uf5qm2WznCZ6RMe+4GpHzm+MDaxOB86mZF78cuMx4Zg9nyWitk7XiDxtljxj5tJOMu9VVp5ls05xU2hvDeDdwFAyMmoYULkWLDyw9VUInONwDDf0zFc+NAMONFS2B+ty1qdFhabQl7HwrjZIPMhKRziHip2q6Yd7MFYfN/l3hD0snLDA8HbWrpMIC6fFAUuhfyu/Hb6ciGyZ7gsRT0PlbhqmH/iXXSVZl482sQA+fRTQosSlNzrAkQcaPBvwk+XsdPWwyisEmJNKeRJr/r1WFQUcmi4jsvAG0mb7/batuhy3+DqpAbFE6j9fl/J818VFM3lU24UUK+hSz2xSBoPb5UF498q8o0QHsW26BqiAfRPEbnKA/O2GAAXlaqpQlQBI5wMd5ZcHQU2/BS0N7SZgRyX4fF3iQaWrezamxalYLwx7O/SPZh7IeiBQdn5kyQj1W6/9mkAQgl2nKoBBCWudIYdcpnCxvBZX9hmRACjMNFCC57/Kmueu7aEipHqCZRhjPW7XV3AZNzR/JlEbM7Yd1llXJHZB5LMSR37ZA85QrrjcAbZT2EuqNiKSp4nXnfFfsbtamJHckDlEflQd0B66K3yYe4F1sZbIR/YK0
 OUB6+Rby
 3UdMDNc6Gewfj7TSOHR2mqcwgKZUPdNRwjB2oby23hCfc5PSgDpmpf0L/pAE6YOD1aS97YFy8vlcHBOwAv1y/w4p95wfRfdFNpBx3xumc2783tRYssow+Pa2kJz8hlub5iIOQG/IsLQf+CGX6RRx0P73lTyqqGgMKvgTQRtXqKIRDl9Q6RFpbXogYuaRm/oOsZ66tvNnnBFgEoQBoPPxIjuj7XJGGfDwB/+430PM7Yeo0iXHoBxIWSlh7LRTDARM+POV3gYHL+ojjnZ0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 04:16:39PM +0100, Johannes Weiner wrote:
> On Fri, Sep 05, 2025 at 06:58:47PM +0000, Yosry Ahmed wrote:
> > On Fri, Aug 29, 2025 at 05:15:27PM +0100, Johannes Weiner wrote:
> > > With zswap using zsmalloc directly, there are no more in-tree users of
> > > this code. Remove it.
> > > 
> > > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> > > ---
> > [..]
> > > @@ -125,45 +122,18 @@ config ZSWAP_COMPRESSOR_DEFAULT
> > >         default "zstd" if ZSWAP_COMPRESSOR_DEFAULT_ZSTD
> > >         default ""
> > >  
> > > -choice
> > > -	prompt "Default allocator"
> > > -	depends on ZSWAP
> > > -	default ZSWAP_ZPOOL_DEFAULT_ZSMALLOC if MMU
> > > -	help
> > > -	  Selects the default allocator for the compressed cache for
> > > -	  swap pages.
> > > -	  The default is 'zbud' for compatibility, however please do
> > > -	  read the description of each of the allocators below before
> > > -	  making a right choice.
> > > -
> > > -	  The selection made here can be overridden by using the kernel
> > > -	  command line 'zswap.zpool=' option.
> > > +config ZSMALLOC
> > > +	tristate
> > >  
> > > -config ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > > -	bool "zsmalloc"
> > > -	select ZSMALLOC
> > > -	help
> > > -	  Use the zsmalloc allocator as the default allocator.
> > > -endchoice
> > > +if ZSMALLOC
> > >  
> > > -config ZSWAP_ZPOOL_DEFAULT
> > > -       string
> > > -       depends on ZSWAP
> > > -       default "zsmalloc" if ZSWAP_ZPOOL_DEFAULT_ZSMALLOC
> > > -       default ""
> > > +menu "Zsmalloc allocator options"
> > > +	depends on ZSMALLOC
> > >  
> > > -config ZSMALLOC
> > > -	tristate
> > > -	prompt "N:1 compression allocator (zsmalloc)" if (ZSWAP || ZRAM)
> > > -	depends on MMU
> > > -	help
> > > -	  zsmalloc is a slab-based memory allocator designed to store
> > > -	  pages of various compression levels efficiently. It achieves
> > > -	  the highest storage density with the least amount of fragmentation.
> > 
> > Why remove the prompt and help text here?
> 
> We shouldn't ask users unnecessary questions. Zswap and zram are the
> user-visible kernel options; if one of them is selected, they should
> just quietly pull in the zsmalloc code.

That's fair, although ideally we should call it out in the commit log :P

