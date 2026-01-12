Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD05AD2502F
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 05:01:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 306C46B0005; Mon, 12 Jan 2026 00:01:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 29D8E6B0089; Mon, 12 Jan 2026 00:01:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B3706B008A; Mon, 12 Jan 2026 00:01:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 096C46B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 00:01:52 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 9AC8CC143B
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:01:51 +0000 (UTC)
X-FDA: 84322114422.14.33C0D77
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	by imf10.hostedemail.com (Postfix) with ESMTP id BCC13C000D
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 05:01:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=A5Ty4nLd;
	spf=pass (imf10.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768194110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tyzpqUZ7yNMiE15jNn2+/Ob6xCGrAy07kXSER8vdYjg=;
	b=P7Yvs0Ywa8xMpy0oZhr9dcsf4g3eQL767OfYPiw6rOtL3IpgTFXAkPgkI2nbX9zu7bfeTq
	5kf5V+0T89IMoehWOmiZ9hoanoz39eRnQmDQi1VzYHH4Aoj6qBUE7j+kRTtHlCN0f/yBPF
	VWXd0XURk1ws8tiAxBZZWzkmx6qUekM=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gondor.apana.org.au header.s=h01 header.b=A5Ty4nLd;
	spf=pass (imf10.hostedemail.com: domain of herbert@gondor.apana.org.au designates 180.181.231.80 as permitted sender) smtp.mailfrom=herbert@gondor.apana.org.au;
	dmarc=pass (policy=quarantine) header.from=apana.org.au
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768194110; a=rsa-sha256;
	cv=none;
	b=aMOe07AVs9/nxzWzIVbJbI5TTl2h3lr1sVyDBBWquHphvdEHXzpD0ZV3kE4Srnq62OK4gU
	HMcXHB1F7m/dycHswIGMfBhSr4vITyQrggGNj51BEWwvxqboQAAjeqLVrHFabUedJkseK2
	MKjoJpZteG3hm0B1t/7Yqqc3t7H9T3g=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=tyzpqUZ7yNMiE15jNn2+/Ob6xCGrAy07kXSER8vdYjg=; 
	b=A5Ty4nLdPydlZ+W/lnQN936T/XphStVxvBtLUF5Zq6jZ67vtVvusfDLEf2Cd+c7MzlWq/SeqqpZ
	BkNJxLeynjTDwx0DdspCpe2VdazZYD5A63fvGXhfBHOQBrhUIcMIMQm+OC1+OzIBNDjAxRpRf1o+u
	ODPD3KquG8cGDfQNPpcUNKevjaisViLQ35vGLKZmo1dIkj79gGkfBI3DOTnFFqF5kX5amdraWjrFg
	sisHg65uzYtiMynWpB+J0SA9iT3CllulmGFHSI3v65e4mRa1UOkKGqW/NA9Zt+w/EbaRBDgMICp/u
	U0AhE2u+dDCxUGpiT95vBTlmQW1Um+oHHHdA==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1vfA3D-00Fxah-2j;
	Mon, 12 Jan 2026 13:01:12 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Mon, 12 Jan 2026 13:01:11 +0800
Date: Mon, 12 Jan 2026 13:01:11 +0800
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <aWSAF4s7SYjWP9mq@gondor.apana.org.au>
References: <aVyYuS_usi-lpHkM@gondor.apana.org.au>
 <dou7g3n5fpynsab7hmxf4bgmqdewtdhkkiriwlghxzyduick7h@bsi3q2kivvbs>
 <aV3uXguDCaVAbY53@gondor.apana.org.au>
 <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
 <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
 <mldy4ayvdlmdz2c6spsmbuwiekvqtnxoj2lzg2ktehmdefsees@wdi7vw7kliuq>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mldy4ayvdlmdz2c6spsmbuwiekvqtnxoj2lzg2ktehmdefsees@wdi7vw7kliuq>
X-Stat-Signature: rqubok139pi536nbi5kdzyit3sbfsowa
X-Rspamd-Queue-Id: BCC13C000D
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1768194108-149289
X-HE-Meta: U2FsdGVkX19eA5T3v59/oqpwF5QXi2B88dOC+FJOnFBXTdZ55rh76zyNPXnhBiTbBCn1rpeUG2SRynZY5qBdv5FHSwLVN34LCX2KeAglSxObqyZ50Mj/GofoHHgEE+xJO5DTiPIDj5QEsrDf0rrMZHGGMuBEEdfjFm9kIUHPRCOBsx4Ig+rn6ueKYLdznoHV83akcwxoFIsLsJOMrcJxi7it5MQa8w7Tu4bYzCiHrjEwRQIT7AoFFqkY195AxKWl6IPShhBVs2OZv7VKXh1XHFLRtcRyLbYYI0F+1kDwI88ptxye8Fts5uN+z8omT7g2RmcfgdP34Gc0MNjEBCtYY+sX6jdX7CMJUmX1GJsiVnM6uYhmvaCowBmlXvuMG4/nCiBBc9K2CcbjxE7vQKqx+3IL9G3rP5yz2xb4AJOd84nddvOn4dQPmi5i/ILVXjLFz6UP+hEpdyGG6ByRp+c0rDgv1KhXm/96Lsb9u2864Ly9CpchKUX/dbe9Jrsfove4DxOCnl7A+hXd7lCcSoabCiZQKobRZH5+vdjv+G4sJOf0PQp/hvnv2qUGT6C7KcjlIBKQtneJx+F3A1b5GiBMHdp8XEiR7syAPWT93PuBt7F2PZmexD/1IWUeBVOmPOup36+vOiPb9k9rgyzYY/omI9pDXDxRCTovYN6yAEviF4zt2ji0ydSFDXu34MBymLfmBalYeRVOHpdWCaQczLJW75htmViP2ozaeHUNBEVVZ28t8bPHPovM8pOqdsTUotJT2u0rPVBh234Qn2STMPKLwBdSScS5+6QeOc3eMPcmAAFkHjPo4dca57X88kTUZcNPj0E5vF7qx2XeK/9TjOI074mvhzwdWBZ/5LJrmo8vA3ZZwPkyYZrki1GwvhJL+AjnX4pj1oKTR6uGxmRcmTB7qZrY4FYi04BI7V7S+c3C9adBhZ7I7qm8oGhsCjgZSaTSazR7KWaqjUdlWA0gwl+
 LMTHtcPl
 yT9hXaWBQwv9nDkQZWc9710mkqo8RcNFiNT3RT5H0GpjCPLMQvuFRPNkMCQyZ1XhFxFfrFznb+j7vIvnSKntFVAp1YOfBgkoIFZcMAyVzjnNJomLMDd5KSBUjhQmGtHjdfkU3qdksJ2YEBystg6A5SikJ1XZl5jOYY2IZpMn5BQ6eDYRtA8nSzwBYR42gPxQaV+kLrs+g1SOtMEwQzoAgC+xcSvT2GRGX+c9kPhZwi5DpNMCOKQslk8A+OdZ9DcwFrvOn2XX9C3OhM5ohmfWy1Bq8RNNQou1B19Mc
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 04:02:51PM +0000, Yosry Ahmed wrote:
> 
> Herbert, do you mind taking a look at this? It looks sane to me except
> for one question below.

Looks alright to me too.

> > +		size_t sizes[2];
> > +
> > +		/* this object spans two pages */
> > +		sizes[0] = PAGE_SIZE - off;
> > +		sizes[1] = mem_len - sizes[0];
> > +
> > +		sg_init_table(sg, 2);
> > +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> > +
> > +		zpdesc = get_next_zpdesc(zpdesc);
> > +		sg = sg_next(sg);
> 
> Is this stateful? Will the SG list be returned pointing at the second
> page now?

It makes no difference because we just called sg_init_table(sg, 2),
so sg_next(sg) is equivalent to &sg[1].

Cheers,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

