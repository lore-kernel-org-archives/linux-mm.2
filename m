Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 67774CD98CE
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 14:00:02 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B60E36B0095; Thu, 11 Jun 2026 10:00:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B115A6B0096; Thu, 11 Jun 2026 10:00:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A27B96B0098; Thu, 11 Jun 2026 10:00:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 95A056B0095
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 10:00:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46FBD140633
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 14:00:01 +0000 (UTC)
X-FDA: 84867790602.05.F76878C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id E497A20003
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:59:58 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PjKu1KWB;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781186399;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CUxPEqooOCnvy8vKSlOOoS0NIVVGGJbXo27C3roXzDQ=;
	b=x7bUp7xCxOryzN+Od1jKF3raBxQ5Li0iaB0vZYLGEt7LumdkcwPjZ8N4Ht6ws/Km2BB5CR
	qLrERSMxXf7p0a9TcTLSa4nXfnk+AZqGYR278abzWFyFMUMGHl3oSvG3zj8GQikShIEAAw
	pV/Xfoe/fWi0Uj5Q5sW62pnl9qZrXCo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781186399;
	b=IeV0DqGGQ1Qu8pYhkJ/4SRtRqCwfkd2Lo7AlrGhwcLd7kQGCI6UqEcGQD+rkKzsyXjIxIe
	sOFai7z6oDmzC6JMnwZJoiVzn1dPNjCjho1cc1jf3uEQRqXiaR+uZwvdjzouygyq2YDraO
	fo2wEqXLEYO5kNyT22NiEWMirH6EOUg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=PjKu1KWB;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CUxPEqooOCnvy8vKSlOOoS0NIVVGGJbXo27C3roXzDQ=; b=PjKu1KWBNt2xwOToKxdQY7e+Ez
	M8XDwHokFUZ+SfiCkxoQjF1AJYhYZSZCfOaPl3zBnPPjbS/ALDUI/JUeBB5FTEkfrWy1HZFPCGZZV
	RsSBm+kgrRC7qQcGqMxIoZNlEvXHD3ro/K+NByZptmx3D4gn+V/OiUYlaaY2ZwY3eS/E9wXTaENwa
	CoZVcQuhtbroSFD9KXKlLvp9mfP4p1PsaICVR5MDRQjtslxA1D4LheA1BmCrbcQfIVDpkk46q68/2
	qsfSxLeUJ8+Yunvq1mY+ZsHgrvPuJTV3GgfAjwc7tOdWvSVBJr/rNSNlEaHd4R/J1jutv5CJGmPys
	224BouNw==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wXfwp-00000001zqQ-1E1q;
	Thu, 11 Jun 2026 13:59:55 +0000
Date: Thu, 11 Jun 2026 14:59:55 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miklos Szeredi <miklos@szeredi.hu>
Cc: Nikolay Amiantov <ab@fmap.me>, fuse-devel@lists.sourceforge.net,
	linux-fsdevel <linux-fsdevel@vger.kernel.org>,
	Amir Goldstein <amir73il@gmail.com>, fuse-devel@lists.linux.dev,
	linux-mm <linux-mm@kvack.org>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
Message-ID: <aiq_W6PD7dZhTYPL@casper.infradead.org>
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me>
 <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
 <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
 <59ab54f6-680e-456e-91f4-0a26889844ef@fmap.me>
 <aeFuarTL7xBbut0F@casper.infradead.org>
 <CAJfpegtAeyMRENdneJkJrMKu8Uwnyk9LYBThjvTrFjHmPr6O_g@mail.gmail.com>
 <9fe5ff50-4c1c-49ee-a8c2-4cacc3c6781d@fmap.me>
 <CAJfpegum=LJTCGqMUfLHehQE19kgdZbE2eXS_002fdpX_sd6jw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAJfpegum=LJTCGqMUfLHehQE19kgdZbE2eXS_002fdpX_sd6jw@mail.gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E497A20003
X-Stat-Signature: xu3h4856f97nnewdtiyk9kk5b4nmor39
X-HE-Tag: 1781186398-358983
X-HE-Meta: U2FsdGVkX183VSNrTdEqC9Jt6kRvHJVTTHZgkHlcqxTHXwOlnkSaKbcdVTSCdJ5qhT5JsagyY1+dt6RF1XttcDAfcxRgz+JojEZw++WXL698DvFUTLbHiSOqVk6RSsifcC3LCaxm24xUvpdZXb76PRWss8GNTQcvxoFMMcU6cLhmQPpWwkoHKrmx7wWbodkVlfRzKQqKURJT3AwiQR6avSVzcwpt96WfGplnTZ6XqQcA6FjAd786DtkGXCfIfIri6LQ0B4UKoGZQvBEkUbmkghp1dOEMA6vewqz78y7syUxlhcCvNWhEWBpoBQHO8UJE7bdimO6MYwtHOPpFW9BqbV7EVrnjtjKWMxsQC/mHlWUvCjwAY7OX57wy3EatBHx0/93bGGi0/+Kpue20jyKN5ZERg+XkGSvzDRExeQV56V01u8N9i17EuP6bfRKQj2z/3R/LAJ1Xt3Hb7MugHXr27ThOcAUhDwCgQaV1s/iIamMlU0uvKuPpJsE4/w4pc8DkjtNluos37ymwW9cX57/yIUpehhncKQ0WQGDF3Kk1fc/b7FrDIZu5KCI/t+w+eMQTPyvhaLAWlMLuZWimVXZ/AnPfnDdPUsNv8jJxZt5LdpSrKIamr+NK83nHHCZjeIl8E34Xm3o2a/wFVsUFyiUFomLUX/oMGU7MzR2wzlDNLoBfMVSGUKF/5sPiyTRtIbjgytnCSp0yHMSMi8Tu8ik0UvcNNuizPri8/5GyWR3ab911oMi7FE4ErNji++4Vk4G73Kk2iJwRDl5YgjYri6waIjDC9wmDY8AN33NfO9saC2yvgl2Djiy7uZ1U6xTnS9y1w/s9dxIh6DPax+MbIxDTYS11LYh2jvWEUs41LuPKcKrxoTkpYCYFOqs7GdA0ARmp5oYFU5M/KkKpVUEXTK7c97YhFbFRqmkW0vxnSPYqi2zqguhP/iUyeGDSYUipIAs7J0EPCfTiFp6lMTG+Lpp
 Aicn8Lev
 RfeBAq1GNEwbPaZvOlkkvm0xvQ6A3GMmn4mPajuCmGpPZRBD7OfbVC4cEojHUqqs7oIfQ6eFy2LCyZ19EoZojbsrr8rBRSdWr0niZLkJNnAMgTrsdpqsK4ENOYTs16BFNjK5C4uGV4WRTQWucMSRonMaSOdHypIJKgFY9PyCcjeR/WEXU6huJc/JAtQchLLcgE9g4ta8WGOXXYGUqDzf+cO7YH1HN7nU7ELdkNVSlF6UQTXJkLYIT0Z112Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jun 11, 2026 at 01:36:56PM +0200, Miklos Szeredi wrote:
> Sorry, this got lost in the noise.

Uh, yeah, mea culpa.

> I was thinking of something like the below for fixing the invalidation
> race (untested, whitespace damaged):
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 4e636647100c..c9ab0eb35afb 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -2856,6 +2856,14 @@ ssize_t filemap_read(struct kiocb *iocb, struct
> iov_iter *iter,
> 
>                         copied = copy_folio_to_iter(folio, offset, bytes, iter);
> 
> +                       /*
> +                        * Has the folio been truncated?  In that case we could
> +                        * have been copying stale info (including zeroes after
> +                        * EOF) for a distributed fs.
> +                        */
> +                       if (folio->mapping != mapping)
> +                               break;

But we've already advanced the iter, so we need to rewind it too.

			/*
			 * A truncated folio may contain stale data
			 * from a distributed filesystem
			 */
			if (!folio->mapping) {
				iov_iter_revert(iter, bytes);
				break;
			}


