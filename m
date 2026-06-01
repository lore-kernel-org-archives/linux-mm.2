Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BCD8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 15:03:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0A2606B03FF; Mon,  1 Jun 2026 11:03:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 079E86B0401; Mon,  1 Jun 2026 11:03:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2926B0402; Mon,  1 Jun 2026 11:03:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD52E6B03FF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 11:03:28 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id A5BC8C0586
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:03:28 +0000 (UTC)
X-FDA: 84831662496.28.A524AD5
Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	by imf11.hostedemail.com (Postfix) with ESMTP id A3EE44000C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:03:26 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K2XSA5gR;
	spf=pass (imf11.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780326206;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jOPuvve0GGHfgoNvEY/UT1iUdehbmxAd3MGizN3iksE=;
	b=Nt/Uci3eXXmhOrLdS+3riNu15Sx9lte7iEsI7qfRJpg4dpnNE0pZNQySexWZCXmafij/LC
	p2aiCBTkCERk0hTt91gG77AQq6UrVahjWbyUs3nxFtBbQOyULcNKLsvYiq0ezOBeMwhg6W
	vM3HGh4Q+t+C/kLbUP4+sTRh4by5Xr8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780326206;
	b=xEDST9ktujkbwfhm8Vn4Un6Vm1qSw9kzQ/OcYCG6iB5atMoZFe6kkRgi858dOdJ/wu5ENL
	4VsXERtAJ6xebijmI5Cs/CCkjW/0Qplve5Z4XVesiokwTkPCRHMwtP9QNmu7X4Oou8ehFN
	bEDGB7q9XPur6lDNvpnd5WP6LSAP/nk=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=K2XSA5gR;
	spf=pass (imf11.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.128.43 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-490426d72f7so89684065e9.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 08:03:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780326205; x=1780931005; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=jOPuvve0GGHfgoNvEY/UT1iUdehbmxAd3MGizN3iksE=;
        b=K2XSA5gRuNAkAR4PuCL599Hl+346H1q4zoCuNk434ginFjWTyiA9SFGX0w79ikCDT8
         UZIzx3vX0bI7li2LWPfFUmOgKX9wQrjTlxyMANEhSK7OMAjKX3TUSXZbnVBpCc/+16RO
         9ziSer1ihakMR8xfMjVqcaRV1i4Z03eIFANssG+xLXrgiIHoiaM6AZZ9lOXrdpXESLiD
         D8pUuD+7Ec8iOf7+5uysEwf/tuQoJlk/vlW6F61nLi/mTgov/gg5EYdUvepSD0pBuc+S
         RB2i8AC+5MZZMj/sbDwd1TwntKNADT0MdcIyv6X/mKOVBfG+/kgUSZlK4VSrBQeE1NwY
         B3tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780326205; x=1780931005;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jOPuvve0GGHfgoNvEY/UT1iUdehbmxAd3MGizN3iksE=;
        b=nxTagbzw/IIQYExSSFC0ZBK3TayI8c9+++vml0Cqs9UN2xekefQ0d1lWOod10iAAuY
         Db8qPqKtKEC6kKLdoQelCrjngaEWcZf8CfAMAZdjrl292u34nuXbHhi/TPwtKkBFJRq6
         Hi0aBEgc6lRl89Ij3VgUSL2FHl8DwRV6rNcA02XXC2tggjfL2EgnEBn436IJ98Noo+tG
         WJUZ64p8H1RlxhCGg9qy7t6bFW5fRCzlAXHSnpodmeScv7xAJuykveZunLLE/exE4/6k
         W1oYmfNy+qmb/gr93e38hOm4WXATwqi8wfpPZwQHBzAnJrfUukaYB6GFAsklEC+a3kEQ
         fNGw==
X-Forwarded-Encrypted: i=1; AFNElJ84yEZQy3K91um42yXty064OTJJ50yRcQ6fQa1r0Q4Zximf0PnOGZha8ANCa/xVdHFZke/+uQyi3A==@kvack.org
X-Gm-Message-State: AOJu0Yw0JxHblwVLhNKjDVjL2Xh4aSMjLS7LP6qv7x2dbCagFgppyc+b
	cyGf1Mn3D6TSsSeDcV0JhNkLMZTtgMQ1rkFqljN+H4bSPVdAS4TOuC3g
X-Gm-Gg: Acq92OHVquUqJexFRh+YEOIibwOf+B6J4dlJit7zxoJEUBT4jvrP4zyZ81ykGe6pvyD
	xhjBClrhPZcil5p8gSejG8riv8ZAUoER2F8EAlxDoT49PNL02/I/3pxA6zoV64cF9/0BaZHWMXS
	BCW7oMcYccssUrxIsEOorJ6H/OcLws0i3O+3C93FBMnp5837BuZYfn8d9LKjzk6BcHm8OwklWDc
	Ga4KIAD9hxaqKDcz/rsvgHoq6xjk1rTayrwgIq4Ln8CAU1ydThrB5fzpdT0q+nTPvKM2Lty6CAV
	9et0uiufdwVRGemx4GXgFAfXCJYWa8/ezjpR6nsy+fVesfMz3nYpYBxx6ZlrVkwUvIsuUB84p5Q
	2iOH1+vK+a5smRJalMzLyyCPE4+jCU3AOwOetgQ080mbJIPCBGNiyVge/+kX+dLQTrMJ1ZoN2jp
	zQD00wTFpMDArNb6ZSOG2EPkpCkOP1Tz1JfywJjBlsXvCx/q6G5Qj0OcvWBcGp0+ct5kTQl7Pur
	ZRJ7TQ7sQ==
X-Received: by 2002:a05:600c:8b30:b0:490:adb6:7957 with SMTP id 5b1f17b1804b1-490adb67fafmr48270735e9.33.1780326204677;
        Mon, 01 Jun 2026 08:03:24 -0700 (PDT)
Received: from f (cst-prg-92-135.cust.vodafone.cz. [46.135.92.135])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4909c127befsm80837185e9.31.2026.06.01.08.03.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Jun 2026 08:03:23 -0700 (PDT)
Date: Mon, 1 Jun 2026 17:02:01 +0200
From: Mateusz Guzik <mjguzik@gmail.com>
To: Matthew Wilcox <willy@infradead.org>
Cc: Chi Zhiling <chizhiling@163.com>, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, Jan Kara <jack@suse.cz>, 
	Andrew Morton <akpm@linux-foundation.org>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Chi Zhiling <chizhiling@kylinos.cn>
Subject: Re: [PATCH v2 3/5] mm/shmem: introduce copy_zero_to_iter() for large
 zeroing
Message-ID: <rvvwfa4dp2wovn4vlglajxwpumiudvcgbnrj6fwh4dxtxemawh@rbav4cliyraj>
References: <20260601055704.167436-1-chizhiling@163.com>
 <20260601055704.167436-4-chizhiling@163.com>
 <ah2HfH3jJZDiNAQc@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <ah2HfH3jJZDiNAQc@casper.infradead.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A3EE44000C
X-Stat-Signature: osa4si599xt1idim3s4gepmffoggekqk
X-HE-Tag: 1780326206-483185
X-HE-Meta: U2FsdGVkX18i/EiP+6oGREYSkmc/q2DgTHrUvIMyfuOpSy4JqMP2a87pLMWj3Zh/xh0eVPpRLVNdPIqocIJTdo1F/KRkosBxnaGELmh23JF2hMpSk13mky90B9gLdzhclodrErvdTC75YdojYQC/G5YR4kbZRZ0BwRHpotA8lttBgCb1lzBzcSpCNEmqJ9IDINL0Je6RfBDNDOmaooUA3eIJwRQbzclHM9iUZQBozR5UM6Yj+4/e0yupo9Cwa1V0eYgr1pYVNpjpTw70F0ufO4qKNNRy0Riy0JoUNBAzj9DN0ORqCRyDnpcx3ZfEx0SmlwxVh0eLQi7XFQy4igj/Wf/Lc7MYIExDOB4zNtfHfpMGHNU3NLU3M2QQ7b2ZsAKcGzptavQ4dLRmwqjJ8uvjmSuOas22nRLrmnqPePvdfQmq6kDKnDGjsYAJzlxitnsIToScu/pxNIlvqIa3v1LR9FEn+rp2eboYfrqmAVJYfRlg/f/kCdbZpFnjLUitkdh71qTFC6ESfyJVpfpQ7xWz5YmucPzKpJnOB6Tewrq6B8ZK4EkLPQ2f+3q5xm1sZ2KCH+GbJ2r9xLMIJ52wyspWmtw+8aKuiEcYzOd7ldOcyLs8Hmod2YevkkTRhkCVyNTphPf+V2qVpV+yzQOEoPb+2e5XnheZ2gSPsHbLZKxzCHXlCWuHEpsjFik1WH7Xs6RsqFBCEZY5C0B7/Y+S8ccN4Ygz55+cUyDGFcWkRYpKjX2b8Zk4+y/gHLow+34XeR2zunK02May3ZyrumYRx7ol5Un8xDIMJU8c9eL+J4jIUtpNgIrpLvDIkNa7/qARLal99LYa8qLGllL3aX+Zg70fr2djmSZZexTtHsdNjJfgax7uQkgq+SuJ7CDErSFXB0MMRnd3w1a9m6yPujoVbFhIAg5irTYnc+qMOivLzX5O+/xG1vzaU2IElF5SaB4WBTQ7mP8DWZ/cQTT+CUP9JAF
 V59GPdYo
 cbr3+ZsR62FJrOZghJ6wJXHPDBaWbGD3hd76Gxt4s4XamEtBaREVHnxDipw+EpSGxPJuJQwcCYnWC0iLQ10XXD4WKkipjAVuD1DFyPplz15TdVrZh0fw9OQ38tQ+8N8Dixd/gqhC3S1VnMKUWnnPJf1aTVcFBkwO4UxFreZjR0Y5CA9BUfn411MVHqPuPcozw2eBy+0B5mnguum/v/6/fdwd7U+rnEPRZ8RPxjwu/ERhAfGU/arvA00fkupP20QFhybKtD0Sdh+vMtoVNSm0lUPHvILAJAeqBrEKMLS0D9ddsC4qRCWUJT6xs19bIGP8nGKKSLdcX5KiabrL5qcj2EfSUce440i2DrhcgcOlfPHCxtJFTLVE66vDLftxW3Hf7VMQ7g5GYJGhaakG+2gGn8NWlYhm7tlCUc3UWvL4toXdU/Ntv9y5zyCo5qaRB4ftcCaNm/fnITWye16wE10AGkz07wGChGl038BMv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 02:22:04PM +0100, Matthew Wilcox wrote:
> On Mon, Jun 01, 2026 at 01:57:02PM +0800, Chi Zhiling wrote:
> > Currently, holes larger than PAGE_SIZE cannot be handled because
> > ZERO_PAGE is limited to a single page. Add copy_zero_to_iter() as a
> > wrapper to support copying larger zero ranges to the iterator.
> 
> I think Hugh put this optimisation in the wrong place, and you're
> perpetuating that ;-)
> 
> So perhaps we can start by moving this optimisation to lib/iov_iter.c?
> And then you can redo your optimisation on top of that.
> 
> diff --git a/lib/iov_iter.c b/lib/iov_iter.c
> index 243662af1af7..06c54d719fcd 100644
> --- a/lib/iov_iter.c
> +++ b/lib/iov_iter.c
> @@ -451,7 +451,23 @@ static __always_inline
>  size_t zero_to_user_iter(void __user *iter_to, size_t progress,
>  			 size_t len, void *priv, void *priv2)
>  {
> -	return clear_user(iter_to, len);
> +	/*
> +	 * it is noticeably faster to copy the zero page instead of
> +	 * calling clear_user().  Shame.
> +	 */


This is a rather suspicious claim. If clear_user is indeed so terrible
that it is faster to copy, the routine needs to get unfucked instead of
the problem being worked around.

I can't speak for arm64 or other non-amd64 archs, maybe these are
horrendeously broken.

On amd64 some archeology shows the following:
1. 0db7058e8e23e6bb ("x86/clear_user: Make it faster")

2022 vintage, replaces thoroughly terrible 8-byte per-iteration write
with rep stos usage

2. 8c9b6a88b7e2f33c ("x86: improve on the non-rep 'clear_user' function")

inlines rep stosb at the callsite if the CPU has FSRS, otherwise
fallsback to a new routine which does 64-byte writes per loop iteration.

FSRS is reasonably popular by now and chances are decent the test jig
used by Chi has it.

For a size like 4096 bytes, the 64-byte loop will be slower than rep
movsb and even rep stosq. This needs to be patched and maybe I'll get
around to doing the needful(tm) in few days (it's not hard to write, but
some care with testing is needed).

I could not be bothered to check how the workaround showed up, but it
definitely needs to be removed as opposed to being perpetuated.

