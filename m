Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0BFBCD4851
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:44:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EA606B0005; Wed, 13 May 2026 01:44:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 09B476B008A; Wed, 13 May 2026 01:44:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED0106B008C; Wed, 13 May 2026 01:44:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D8E936B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:44:11 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7FD5F1C01F7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:44:11 +0000 (UTC)
X-FDA: 84761305902.23.D059F84
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf29.hostedemail.com (Postfix) with ESMTP id B95F4120009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:44:08 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=M9LcoS8f;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778651050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VH1edBJdBGzw5mNVeuwXmCELmWasSoSUvztaIxLYKcc=;
	b=AGYVwhSlBdx7FekhV74a89sQgMGI7Da5mQCXqb10hUql4MuAmKkrzZ9JFVLF05ZEyXfM92
	wr8oQTR0Qh8LOx2EZSBwQ2uHHSnqGe/McsZEy0vh6VcawDkss0uNQ2XEnJLV8KoOqJzd2t
	IZ5AerbpxgBttUUR91ngszhMCJNWL0k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=M9LcoS8f;
	spf=pass (imf29.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778651050; a=rsa-sha256;
	cv=none;
	b=ZgbHHsc+yc9KK4frlMwm4hkbxRxhA5Cz/2xQ6uvF0dOTJIiyEnzOO5S9sMO1fL12MKzBbf
	x4GfOj68UIuF7ruFwqL888XVL5AJoLF9ixSbJm9KgLg6bVzfBDyTtb7gobNkqeUV/jcGYD
	dvjsdsJBZV+I/6+sujjo48t3JjCmRN4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=VH1edBJdBGzw5mNVeuwXmCELmWasSoSUvztaIxLYKcc=; 
	b=M9LcoS8fZVm4OVfdXJJyg4R9GvShiV7gUmavpAYWDUU65Sisf/xAS6ZVn3aM1XnaHEmB8Xn7pnC
	QSjeZ84VCxLkhRNd/aWvRgfDYEPG26ibuJ2nZB5GBCEunEI/+9onWOakJvS1l7TZjZXGmP1alhqMz
	mkMGEiBSwkTkV4i36lWWBOIJk4yGXV0n6Ryc2xMj96yWKSVQn2jEJXQftxdG06tP9VDAz+9AUfJD4
	dzYGMtwKi45PLEypLLKCrmumbfJJ3+hxUzKjHnY8vg/Hwae5SrhXerqLm53qSjFyh/RTbBVgHGwvW
	7+8sfqQXJAblmYNYcuwCSA0bcD/9ozlQWhrA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1wN2Ny-00DhFl-1i;
	Wed, 13 May 2026 13:43:59 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Wed, 13 May 2026 13:43:58 +0800
Date: Wed, 13 May 2026 13:43:58 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Yosry Ahmed <yosry@kernel.org>,
	Kartik Nair <contact.kartikn@gmail.com>, minchan@kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	syzbot+8f77ff6144a73f0cf71b@syzkaller.appspotmail.com,
	Nhat Pham <nphamcs@gmail.com>
Subject: Re: [PATCH] zsmalloc: zero-initialize zspage memory to prevent KMSAN
 uninit reads
Message-ID: <agQPnkSH2cdWHToE@gondor.apana.org.au>
References: <20260511213658.25273-1-contact.kartikn@gmail.com>
 <20260512144733.9132c83e392a109743e92f71@linux-foundation.org>
 <agPjfGO6zh9HLPBE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <agPjfGO6zh9HLPBE@google.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B95F4120009
X-Rspam-User: 
X-Stat-Signature: 5ga5qxg3y5xoy989j7gob3d6zq93ny3e
X-HE-Tag: 1778651048-908357
X-HE-Meta: U2FsdGVkX19jallqBcN5yAlWvuFlcT05NVPog7U1PL0DPEFJF6OdVvhE2aIm8UVtzbs9MPVwfpeqy/ZwYLFTY9/3FVD1VgNq2vEqtU7UDruVhCJuM8fmapCTt6q4Kpck0AxvSUYiZuY3+d+t6UwIh+FQJPERc1uEMyAjLu/YsUwVdrSMjraI2qOE+HvZHPt+qNUaNUdpTuHTUkqnHzyIXPTgr6FVfFe/Wc/c6Qqn78AEMkJWB1EJDU5SomKuBpDA6eM0yF324S38D5lFf2rWwZUQU4xO/+kmfkuoI0rspev+2RwLSl4a3uekdDRgpu/tm6NapkqEvI9MsfU9qDepFJL4Y4ZqqSPpCVaaH0+RbNd86ZN0CGPkZ21swKuNLSSL1mIvmdzB4TZ4bQNMfnntiqnvxYdKAIUSk7jLPvyBD5LbUqhYCjvSOjOQuCdjcZGDse8QPnN9+jf4EE5LFjiH8Cv5egRzTeznu+53KPrD6YfV9DctlWnpGn6L45AqDe2GDzLQyQgoA7FX0ub2ZR84K2yB07+e4fK8W5uGPihZE6HCkzeK1WgDifhLpllVyp2NQaKp13FZFePsYvpeCrgERysG2hJFIUw39DJcwZJ5DaIRurhPr8vIGFUHp5efgc7jbX60TVQlE/rl9ylIq5b2S3DOxl/UOV9ZfR+A3bg+xWmomRoXD2MgbDwUd8gB6fGjVJUJddrE1/49HMPvHssv9M3WlAfgV6ngLUkgBqVeYmQjC26ce+o8nEAHsQfjVvyr1qsbFLLQkbq60iDFyUWifxpaj1VIwC8qe4SjLqZaTX0ufiyutijr4Zm1l7PMpBjhIesPTr/ZUr/B/kcN0/QFmpm4TrGOaXjhLCRS/lUlcPAMRKh/tN3B0F5T5SjY4rbBZkukDyIhRjuMGg2JJ5KVpSz/fZFuHvBaivnHghzwNF3tx1eFFHt5Yj8tf2YgwMS1DpY88AltyaYI8g6pBt2
 SRKFAz2L
 NlsaSoAcZf498eN3OgSWuivjuucr35yDS0dEVgmr3aj6RFc+nT/SlsPePBuwdyKLor4HG7xqk5z0qj/EsORB7DTxubBQIyy9AxPgjIv7wPRqn3euYIT8+w10RM7VSbbua2qPe+xN2tJR4aPhkaHepiPGf2tilLHavw34w3+gm17bSiDfxeKpUkK2Av5rB6f9YwPSisnaXV1Rv+08VtJHg4n9T6l1v69iMdKEcmg360XwKCN1iGU/J+KkXmDsw4sZ0KIJC5OjfprvfWJhMBrW+ospRZWl9gSZcI3Vy3ib9xYWZnPq/F1WNimFY0c7V0Ywc1UmLGOnTQx/t5cpI6BecUgjO0yM5O2/5IIwBlughL+AJhrsf59OEjbirq6dlrEXhRLkN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, May 13, 2026 at 11:47:41AM +0900, Sergey Senozhatsky wrote:
> Adding Yosry and Herbert,
> 
> On (26/05/12 14:47), Andrew Morton wrote:
> > > Pages allocated via alloc_zpdesc() use alloc_pages_node() without
> > > __GFP_ZERO, leaving physical memory uninitialized. When a compressed
> > > object spans two physical pages in a zspage, zs_obj_read_sg_begin()
> > > sets up a scatterlist pointing directly at the raw second page. If the
> > > second page was freshly allocated and never written beyond the object
> > > boundary, KMSAN detects reads of uninitialized memory downstream in
> > > the decompressor (e.g. sw842_decompress reading the CRC trailer).
> 
> I don't get this.  How can sw842_decompress() read more bytes than
> it's told to decompress.  We first compress and store the object,
> before we load and decompress, reading past the known compressed
> object size (which we pass to decompress function) should not happen.
> Yosry, Herbert, any ideas?

It sounds like a bug in 842.  I'll look into it.

Thanks for pointer.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

