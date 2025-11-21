Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 75D81CFA47B
	for <linux-mm@archiver.kernel.org>; Fri, 21 Nov 2025 07:47:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5BD36B0026; Fri, 21 Nov 2025 02:47:14 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B0C4C6B0029; Fri, 21 Nov 2025 02:47:14 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9FB436B0093; Fri, 21 Nov 2025 02:47:14 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8DB336B0026
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 02:47:14 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4CBF51404D2
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:47:14 +0000 (UTC)
X-FDA: 84133833588.21.371515C
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf20.hostedemail.com (Postfix) with ESMTP id 621CC1C0009
	for <linux-mm@kvack.org>; Fri, 21 Nov 2025 07:47:12 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=U07e40b8;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763711232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qchs2neNeJ+pT407GR8IfWvCXYGTWBsYqw1z/CNcSjE=;
	b=BHQh9HIBxQogZgvnV1nmU94g1/NOnxF8SSfLVINQoaa0OjxXK/1dE1coOd1+glfcT5H0V8
	w2ZRNCby3jvuJIUwCGTwSt7XM5pi8fFi3HaVpOai8p4UuCoECil3Q3DugWs3Tj8u7gDh8P
	giS018zsjBFBjBZlXY2JhCcaHhKGQ+E=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=U07e40b8;
	spf=pass (imf20.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.214.175 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763711232; a=rsa-sha256;
	cv=none;
	b=j5DOYSH0OMyfG3EWvPUB7iYRKSBqf0cEI5d/X/Hrgl8MIJRlwMBfjn+H9bsGD+002bEEZc
	VlAFqFJ8j5Okvq+adCtRkWv63l6006TPEw0O9YiNYRqQ4djboGvrLeXgw23BWkiC/Eg9Vg
	pOdAp/gK1rZ/4eicvUQDCXIBB6DWhPc=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-297d4ac44fbso15721715ad.0
        for <linux-mm@kvack.org>; Thu, 20 Nov 2025 23:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1763711231; x=1764316031; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=qchs2neNeJ+pT407GR8IfWvCXYGTWBsYqw1z/CNcSjE=;
        b=U07e40b8aeh1LjTA0iauwoVkxbMse9Th6HJET0gJfhAvkZ3NNwRnhfgFLVPA6Ti+z4
         GU7IQAPobpbjuQ4qVAdX38XbKAN8V6pP/vUGirc7i9NtxfMkBQJecxcGTj6uH9gJIB/R
         JL7aUnRjoNDZao7BYvk4DWpCH0Li7fg2mLlGo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763711231; x=1764316031;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qchs2neNeJ+pT407GR8IfWvCXYGTWBsYqw1z/CNcSjE=;
        b=mjtuD52aSQ3Z4tvwmTaMy1xelPuR1HXiLIlo7Fk9R0h/Yv+Dj8g0wwl4lmLITa/1tF
         IZmohTSAH5JpbFBp1voyaKB0Fy1qUJ5flKKP40ahVj8NMAsDPP9WUFpvksbjbkmAjGTF
         ViD41uLYWgpw41z0j5AcZyb6WzzlH6bkAMYY0npikgXZ9Ua8whniyFP6hVoaM6wcrz9M
         D276gI8w+OQg8QDfJkcVUEp9yJ7DPrEW1DU05BK4INYwrwUx1aBUUjLsPJJ1IveOvzpD
         wOM74CDug4PwhqofKEcKDyck5CHEJmj61xfI3rOMB+Wbwo4PTw3YXyY2dl7BFg+d69Nv
         8RiA==
X-Forwarded-Encrypted: i=1; AJvYcCXcG148UQp9zueULdVF4qhG4zWN6+aIk7Fh5Hx/XKEpz6AZ3iXw5dWi9+0j6njaBjoLm9l0krPwuA==@kvack.org
X-Gm-Message-State: AOJu0YwAx4bXN6IIbkoy0D1mV/EgnscbC14T3BZNsKLp8q+oufVyRBjm
	m9Xvzj3pvlc1AO6gXChv/SNKhITh2JGa/gVXTN+aFI84TUkOhPEIqvd/O5xo0Xsw8g==
X-Gm-Gg: ASbGncsUhBrxZF13/ak19RAQKb+zshWVB+uBQm6M1sl9D1PVTsExV0occ4YQb/hXXKW
	P5/4QQMjKNeg9NgoPaQh4MdCSct5emIxAEMUXaapF32ESRtE/uMsb3VGj+lkhZCYxaWLpv4cMdA
	NG35fl93pa6DTo3bMWj0ECULelVIqRk3Xbku+am4zsxwL+dRKrjSgai+hHsP1vXoM2q2f/WiS6C
	T2l6Pdihsm8gbsvJbzLB3RHXxSOC41SVO8lSzI+GSWGfPyXednWPp4/BPxCxZQG8oAUvu0s4Ra0
	Wc9pcE1yxiSGHsOzmstxxCpy8tfl3ctI+yHGsT+AC2Gw3txx246i3P9zSDYOS0mxVvJVH/EbVAr
	d71V3HYrdXT4eiDF2oiYr/pBu3OkcpdJASy3wC33E6wTkJ2uQuIn+tP5fsSjdy/vizix9Qtc6yd
	ewwS9exnjweMDf1A==
X-Google-Smtp-Source: AGHT+IERlPIR7f/KYSSe+hXGKVpwH6YQfYqAT+vYeEopjrPnED6e4Dd4YOHg16rCMKqdZL/q+sSp3g==
X-Received: by 2002:a17:903:384f:b0:29a:4a5:d688 with SMTP id d9443c01a7336-29b5e38c2efmr72888255ad.15.1763711231236;
        Thu, 20 Nov 2025 23:47:11 -0800 (PST)
Received: from google.com ([2401:fa00:8f:203:b321:53f:aff8:76e2])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-345af1e7c9dsm5602910a91.1.2025.11.20.23.47.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 20 Nov 2025 23:47:10 -0800 (PST)
Date: Fri, 21 Nov 2025 16:47:05 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Hannes Reinecke <hare@suse.de>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Minchan Kim <minchan@kernel.org>, 
	Yuwen Chen <ywen.chen@foxmail.com>, Richard Chang <richardycc@google.com>, 
	Brian Geffon <bgeffon@google.com>, Fengyu Lian <licayy@outlook.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-block@vger.kernel.org, Minchan Kim <minchan@google.com>
Subject: Re: [RFC PATCHv5 1/6] zram: introduce writeback bio batching
Message-ID: <6yyispyqlczqeu2jjiwb5ypg26jq6gbnyxnmibtztl5ivzw6qa@h7abf3e5twqn>
References: <20251120152126.3126298-1-senozhatsky@chromium.org>
 <20251120152126.3126298-2-senozhatsky@chromium.org>
 <90c06ff6-009f-430a-9b81-ca795e3115b0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <90c06ff6-009f-430a-9b81-ca795e3115b0@suse.de>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 621CC1C0009
X-Stat-Signature: 6z4n53ygpdb45b8dtdcct8o483tcihsb
X-Rspam-User: 
X-HE-Tag: 1763711232-617592
X-HE-Meta: U2FsdGVkX19IFSKBZPPK8P/XRgp9FNGpziaLuP2KJYUw0qovjQgCi8JsxKeFvTSeXEpjABeQkVFjGNoUNqxFJQXo1Yo6MfbPC09VXC0eczEWGzLLYx+LQmneFld8PW7B4ZGv+rbJ0vmTAQKsnZJ/LnHnpocF6yBHrJ5ygbXMsMOxVXb+B9Urb1WZrJMyoa0KhW30gw4MXGD1js8Y87qOHTV9QeBbD86psmLHjou74XROXY+osiUocf57Yoe9I0Pzw0L3zB7U07FDKWtx9JmtlM7zka6aohpX+ddR8wh5dCgfy8uiIVAmkDkgTQvdz7l1olP6Lzl339XVqK78niqo1hhWeElK5fcj0VMP6mF63wvtuItfBWhP2+tjxUxBOz4idHvxRQrINyvUXr16k049VQeQKjJ5SDrkaBFabNFmsvO1duYpo/bFAPksH/4gblNSHKkZo9XcvrX92Mw1/2NN494PdBuN/IcZhGO2uvB3SC7MblnWflpQGsCsgFXTHIHi3h14i5DFPe4PHMc8xV5TKvY1qvcZmQL+B6sxovDQAQNIU7j1UQorR+j7guB5D7926HCDNWVHKdXhLpwlCf27wXrr5G2sdRIQvL4uBS6EmqnFdPex8TLxq13H1FJGyjhGAD1Sbq5HM9kxQMuWKtI5JuKolL7qrFEDErwByN2hq8kEmQSC5djsy9pYohaByFgC/2pn6QTATFiXE2Ca2IoOmjDgrRvn5+4HuwXXz8f1FPAVDdTg29mhk+KBf8OblzaMQZifMoEtpioI/wHOGKI4TzTQGGybXech9CxmyZ1P0sQ28PKJZ2xKvJooRXk7CNaSCuZX1a3aXt3CtIKnENSJYfAtHIaJp6MMhRNJfz6jPMvLNBUTBB9azIt5oLwEXgpN5gdIhrB3ZBy9HJXxZSoYcboJIbW2ojZxIEjOdaP4kLdAZMk76Gpew0mB8tufrPucW2VUbEVteRdwT/rkzj4
 FaW0AJqt
 /kNxjg92Uixgq/KItmbxFsTmxDqrv7yyMLPcr4vcixcSRpqWgQV6bsA9deoeA1/uVHCVfdK6C+wE5PWkd2dPv2FWA222e+iOxLg/JTM74xVH/OkvqI+Pd06dMnv6pQaiF49NODHBBnQlPv4eAuca8fhLKzn9T5fYALqECnvI9LVgfPVEA9Ijeh4rhPbeIW6JecFfP0FP1PT7bdclcozBlXxtOGopw/WX37AtBjZTOPUulj2RRFRR8FF+NDLZAUhA2q4QE66UHli6eU94ZmDNchMHtgmStHEQBu4jH9R5Ex9zaIZPTt5nbAIveaM3Owa+ari+ojHeI0kcT1RUsMyO4ylmT7hxjhez5oAYR4JFxkVQjj6g=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (25/11/21 08:40), Hannes Reinecke wrote:
> > +static int zram_complete_done_reqs(struct zram *zram,
> > +				   struct zram_wb_ctl *wb_ctl)
> > +{
> > +	struct zram_wb_req *req;
> > +	unsigned long flags;
> >   	int ret = 0, err;
> > -	u32 index;
> > -	page = alloc_page(GFP_KERNEL);
> > -	if (!page)
> > -		return -ENOMEM;
> > +	while (1) {
> > +		spin_lock_irqsave(&wb_ctl->done_lock, flags);
> > +		req = list_first_entry_or_null(&wb_ctl->done_reqs,
> > +					       struct zram_wb_req, entry);
> > +		if (req)
> > +			list_del(&req->entry);
> > +		spin_unlock_irqrestore(&wb_ctl->done_lock, flags);
> > +
> > +		if (!req)
> > +			break;
> > +
> > +		err = zram_writeback_complete(zram, req);
> > +		if (err)
> > +			ret = err;
> > +
> > +		atomic_dec(&wb_ctl->num_inflight);
> > +		release_pp_slot(zram, req->pps);
> > +		req->pps = NULL;
> > +
> > +		list_add(&req->entry, &wb_ctl->idle_reqs);
> 
> Shouldn't this be locked?

See below.

> > +	}
> > +
> > +	return ret;
> > +}
> > +
> > +static struct zram_wb_req *zram_select_idle_req(struct zram_wb_ctl *wb_ctl)
> > +{
> > +	struct zram_wb_req *req;
> > +
> > +	req = list_first_entry_or_null(&wb_ctl->idle_reqs,
> > +				       struct zram_wb_req, entry);
> > +	if (req)
> > +		list_del(&req->entry);
> 
> See above. I think you need to lock this to avoid someone stepping in
> here an modify the element under you.

->idle_reqs list is mutated by one and one task only: the one that
does writeback.  ->done_reqs list, on the other hand, is accessed
both from IRQ (bio completion) and from the writeback task.

