Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7DECF45DB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 02:36:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CBCA6B0005; Mon, 12 Jan 2026 21:36:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 279896B0088; Mon, 12 Jan 2026 21:36:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 178ED6B008A; Mon, 12 Jan 2026 21:36:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 03F936B0005
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:36:59 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B6FF1901DC
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:36:58 +0000 (UTC)
X-FDA: 84325378116.29.104F9EE
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf28.hostedemail.com (Postfix) with ESMTP id CB1E8C000D
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 02:36:56 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dwc8oLvi;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768271816; a=rsa-sha256;
	cv=none;
	b=fEz/fhH3N8qIC7fwwfJwSQAk+KQB+fbWjeTW+ZEYfVcJkZTv7DMjRoRExBQjxY9ag09Ya0
	M60bJzHzuf+93M2Hxq4vvMo0vM5crsr91ZWb0MnLolqvXQzRHTV01s4sXrCY40qPt5U/dv
	5j78uzDUDkI19K3UKXVrNZbmvgxfOT4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=chromium.org header.s=google header.b=dwc8oLvi;
	spf=pass (imf28.hostedemail.com: domain of senozhatsky@chromium.org designates 209.85.210.170 as permitted sender) smtp.mailfrom=senozhatsky@chromium.org;
	dmarc=pass (policy=none) header.from=chromium.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768271816;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sR1MdGNjXardEy2VcI3+2GHuqhiYVHk795AqKEzJcIs=;
	b=YyPUTZXWYX5Ibxaw9S4xX5B4Ey2qzFhpb1Xeuv7Grpp9iC6Rkl37KtaUVPaaoOyGTXNx8c
	/QSBbu0w44uqOUzUZ/Ro/sEv89ACEpy/uc6uJm2d6GeakU+kKhoxyDvYMfBQuBErUjKlMl
	G2bhdLRfmnLYCqNmUh8q/lXp7/t96dg=
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-81f47610542so939736b3a.0
        for <linux-mm@kvack.org>; Mon, 12 Jan 2026 18:36:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1768271816; x=1768876616; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sR1MdGNjXardEy2VcI3+2GHuqhiYVHk795AqKEzJcIs=;
        b=dwc8oLviff2c18iK80B7aD4003WzqA2IIXD4StalWiMR3EtvDiKOuEPpKQ64CRwkyV
         iT9IN5KO6pbqlGQDBC5gJv/Qw1vmo3OOP7h1DqGKajhV2rFNu+ln/LbqeNLc+GA9tivZ
         DbszkrHn3uwC0TyRVZkAf+L+2TNoyxCd3BXQs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768271816; x=1768876616;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sR1MdGNjXardEy2VcI3+2GHuqhiYVHk795AqKEzJcIs=;
        b=UQ8NwNwjhORFyirTVa+98Q/rSWAgEW+dCc3U0SU8kJMNExW0GH6BuXtiKhPokQF+3E
         hFGXsmY7XxkBRyVRsuGE0J0u779qOSAH6LIlGowck9Bthi07MiR0Ktz7NDgdKjFfaIuo
         0A0jpa1HPi1Fax+CGTY0E9nfU7IcMb3gCOlqNflwY+Oxm8l1vbLLGTtI5UwmguZZejJs
         eqXHjjZl7o2LkZiiTDvK32my19s/LlkI96z9X748S+Rjlh8TuPW5TlkwpH13Y7AwrxbJ
         kEoe8faIs4BTXtN714bXnl++p1dM9Essg+7nu1XmdHMrp9BQyrScFAIv+uN+WamQA4W6
         WIEQ==
X-Forwarded-Encrypted: i=1; AJvYcCVInlkJEU4YKukeyxhT5TIHORvauBcw85uOLxwAz7aTwELJtiKnErUXYENzsfoJ33GEgwH1okRMrA==@kvack.org
X-Gm-Message-State: AOJu0YwR5Dk8p5GQydTLOtczJs0MFHTEMlPiku7Lu5NoTS42fh47WsDJ
	FOT2AYTalEwD39XRIaKuE5KwVYbOzmUJ73xo2HsGHy/MSmU8NPwRU9p0V7F551E9TA==
X-Gm-Gg: AY/fxX4Vk/1mt28uTuViC/D878knlnaUs6tBRQdWz0cYFIFrFe4mmbp2J4dzzZwOW2T
	eeYQX3dbnFvYFmhu0RV2ZQ22FXalqJxOA+tlFgFPU+cARHBKT3qlYw2wMJYrJuM2uHmTy5L7TlM
	sAcP6BKcVqWsC84G626E2JJsZMeCs0OJZaqOU2YxcmnaB8Z5BoMNwqOC81FZfO9Egjn1XSEYMjt
	qoXZSUPOzcNrskXBTQkmWnQ+3KGZw8O9Kat7gJ7Rja3g88n03oYZnrg3CnIW/F5hEqQH8Hp3zok
	oHLsqFVivVn0Bs97Vp8pd3uFNKlkaumAbrMSR3q/tGp4TyuMPikc77Y5YXG+39Wq5GKO8gP/N9X
	W+9NXULa3osrq9+tY0zut9kDoMtJ+yq/6DwMGmCG+FKePnUlHwqZ+8XKUrSoR4DxZaMEzywsHnx
	o/dEzQfGAkT1PLhsrJ7eiYJTJK340NWrLdGMoSM2J7RHE2fFGpW3o=
X-Google-Smtp-Source: AGHT+IEeWhGG+m6tkeAzXIURkimoWW1Zn7M+bYKbacz0tiWkGRVW/rKyT9oXqrUt4jCfMkoJQovJfw==
X-Received: by 2002:a05:6a00:8088:b0:7e8:450c:61b8 with SMTP id d2e1a72fcca58-81b806c8389mr17495049b3a.40.1768271815598;
        Mon, 12 Jan 2026 18:36:55 -0800 (PST)
Received: from google.com ([2a00:79e0:2031:6:3c61:f146:e418:e233])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-81f4433488esm6978569b3a.2.2026.01.12.18.36.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 12 Jan 2026 18:36:54 -0800 (PST)
Date: Tue, 13 Jan 2026 11:36:47 +0900
From: Sergey Senozhatsky <senozhatsky@chromium.org>
To: Yosry Ahmed <yosry.ahmed@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Herbert Xu <herbert@gondor.apana.org.au>, Andrew Morton <akpm@linux-foundation.org>, 
	Nhat Pham <nphamcs@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Brian Geffon <bgeffon@google.com>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Subject: Re: [RFC PATCH 2/2] zsmalloc: chain-length configuration should
 consider other metrics
Message-ID: <5n73klpww36wzux64rmfa6iialqkrgw2ft34vtarwkzdq65yct@txn2ylzkfmr3>
References: <9b7d6e6292c64f21b8d09def1b6723f02faffe88@linux.dev>
 <53zplsrqc66z4ea64cosy53zvttuuhgxr2ik7uw6i2zgluegyz@d3ulgntwnyw4>
 <llj3jf5evsp7f2wl2hmm6mouqzwzolvdnu4yquhxbgsgaqvsda@ltct5tqpzmyo>
 <utnvn4oupcmohosp6d3qti54qmdppg2xfw622dq6zz7t66a6ma@2pentzdw3zgk>
 <yxpn4gan74uryy6huzulsqvqvbsqiehdqe6lu7m3hjf3tjjdop@a6cifoycstso>
 <2iophcy2e6vk72ypxeshmen66e7jhr52zr34parn4uw6vdyjef@frnpfrltrky2>
 <mldy4ayvdlmdz2c6spsmbuwiekvqtnxoj2lzg2ktehmdefsees@wdi7vw7kliuq>
 <aWSAF4s7SYjWP9mq@gondor.apana.org.au>
 <xjykydutkvth5k6vqbxhv4tozudw44dipqphnotpkrolx65wka@ugubqmsfu2ln>
 <e62r7pj6622u6oko7i7b5qtzil75mwjnpat2q2stk7m4e7zmn3@enmdxmq7zt4f>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e62r7pj6622u6oko7i7b5qtzil75mwjnpat2q2stk7m4e7zmn3@enmdxmq7zt4f>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: CB1E8C000D
X-Stat-Signature: yg5ecewcmepfx5z9oo8rnzn5154efcbp
X-Rspam-User: 
X-HE-Tag: 1768271816-485238
X-HE-Meta: U2FsdGVkX19aRZREPL+1/G8JrFhkJ5WBqQ02zgPn7zy263/AgMapDG8P5znA+lyeqijulaNhzw1kPp0Qu1hL02BZZR41qm7AdfGZ39str1fBYIpmY0zxipOxAssnDG4xVf2s8IniF8hxhj3WPUOW4mxPaFrLKEJcKrtn+K9pHxadQKdskwy3E0vxjejH+T987uan8XiuJjskg1aavn8APT0blw8Nq9KvKrbfBB5z6/NwiWC0qp/d6zFgX90ZuqHiXiEMz+pp78SqiPv83/5giz1+P5QMM9cOnvsbwiB9iI7zNFMQREuwze9QEeVWm7LLgTonW5QiaXLWQuTaGJKr3GsTBy8aa5EkB/mtaAVSYMZDBJfDy5jtkOh4mLG/CxmVW4Sx58/gxAQ8dWULYwnuMQRz4tPqYNX+5MBwPpurcV8inR0DYKuvCX6dXuZFZ+AZNVeVh36O4Hp5WuER3LZvWxXY0Nw5YsLMdkRzgr1j0g9CM0WZ3yigVGLIvmOd0icvH6oK2ljv73YrlR1nFSqMSt2HtAx0I1x/W0OMQ8945D6w3hDo4nVqNyTy+pS0AZN1HBF3/OKrzZxmII5yUc4Ru0hUotOvIiEkcwW7+O5Z6YzFBaHOE/B+Z/R5ggycLji1z4nPqM+8kq71wQFueeHc6hOxRy4aMJ2gh4OA+ogVKJUF9DRPfgXomNVmekP/s7VnD2Y2ydhkEeKgXx5jOd6ZW8UNg8OlwuiFwUDSPg2ettVR3SwATBLEy+PXaVrTWwKnTrbQHwV4oRycuMFtHr1OXSwd3He32adostKAGp0csQqa9nx/A46S1RzGtKrrFwMJo0470kAqQe1n7UaSs65/4CJQTUO++UtfoQT3k4cJVrMW9Qz+H9AMoTN97TmEs2JqrZFU0SqMIBDAfD80KODLn0UQrxBvc4N4VxS/zXsPl5V2wgd1yw+/+yNd2+c7ixQK16DBrk0x1rc+1gjNoBs
 3TB7NHCw
 NA3451t4bumIu9ELFpc54180hQYAJdk9uap1DndQ7OZkV3pd6sXC6hCxrwtskEIE9XWX98iuUHIbVZfv99WsOY/UVPoeM+q0LTXNAwOn4wsLeqak4k7b36M2ZYr5LsZx+OVTlt7RAPi+xgAFK1R0Hua7rKj7b8H1pVIHiNyoBzRQfD74pld9DkIH0knMv8oWs0TxQsyOd9GhrN6L0fkL+hHmxSy/c7/y4dJph2qUQVO5aCmTmSHjC/A39gGQIKs27wzMDfTulm8DAkr7i6wZagG9XURs0sf/JFA1TN/5wKnWQ1jzTkfjcGr2LtDwKQlNGh7s1AxePvpe020+J3YXSFTM6wy5RLz3C00AlsSa2rKz7YOo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On (26/01/12 20:56), Yosry Ahmed wrote:
> > > Looks alright to me too.
> > > 
> > > > > +		size_t sizes[2];
> > > > > +
> > > > > +		/* this object spans two pages */
> > > > > +		sizes[0] = PAGE_SIZE - off;
> > > > > +		sizes[1] = mem_len - sizes[0];
> > > > > +
> > > > > +		sg_init_table(sg, 2);
> > > > > +		sg_set_page(sg, zpdesc_page(zpdesc), sizes[0], off);
> > > > > +
> > > > > +		zpdesc = get_next_zpdesc(zpdesc);
> > > > > +		sg = sg_next(sg);
> > > > 
> > > > Is this stateful? Will the SG list be returned pointing at the second
> > > > page now?
> > > 
> > > It makes no difference because we just called sg_init_table(sg, 2),
> > > so sg_next(sg) is equivalent to &sg[1].
> > 
> > I did it this way for (sort of) consistency: sg next follows zpdesc next.
> 
> Makes sense, I think I confused myself earlier. Do you plan to switch
> the existing interfaces to use SG lists for both zswap and zram? Or does
> zram still need the old interfaces?

That's a good question.  I don't know.  I was thinking of providing
SG-list based API for zswap first and keeping zram as is, for now.
zram doesn't use crypto API at the moment so supporting new interface
will come with extra work.

