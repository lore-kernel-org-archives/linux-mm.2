Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AA5A2E94623
	for <linux-mm@archiver.kernel.org>; Mon,  9 Feb 2026 23:16:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A7A916B0092; Mon,  9 Feb 2026 18:16:58 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A28DB6B0095; Mon,  9 Feb 2026 18:16:58 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 927436B0096; Mon,  9 Feb 2026 18:16:58 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7F8FF6B0092
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 18:16:58 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A87A413A619
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:16:57 +0000 (UTC)
X-FDA: 84426480474.18.CD3E64F
Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	by imf07.hostedemail.com (Postfix) with ESMTP id CAC5F4000E
	for <linux-mm@kvack.org>; Mon,  9 Feb 2026 23:16:55 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gETDV3hY;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770679015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9KPSiJIKj/b8QQwFvGSiwvCphuT1m/bq196d1vnTPzE=;
	b=P5jDkxh46gKueY3skuW2oxajB04ZdkCTFMryenb/GGUXSkwmSk0I9vWK/+treHRqr1D8Ns
	SJC0C6KdbDZ5vFiN3on/EYReUE6mRBK5a5jtMgmww7zcl8pxp39upwj9CnvDJnnJzw8YeV
	pvzI0z0Hu3qFxmL+QvS4K6MymXtkGDQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=gETDV3hY;
	spf=pass (imf07.hostedemail.com: domain of joshua.hahnjy@gmail.com designates 209.85.161.41 as permitted sender) smtp.mailfrom=joshua.hahnjy@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770679015; a=rsa-sha256;
	cv=none;
	b=i+Xl4BbZCX1xi3AqSi9SAJuXYnlhp2QzEVj4POiHqyysdPsSI87qckOtUiEGoE1aV+HD3Z
	SS7rALTSsiMaxGHxXU4xuEX2dqDXb0ZJgTigZEIdWCYEHdztUQMk1J/3Nwi6WI4wq3FDoJ
	LO21R4hYbR2oF4p4UU87PW3QWGf06FA=
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-66a2278a37dso1816310eaf.0
        for <linux-mm@kvack.org>; Mon, 09 Feb 2026 15:16:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770679015; x=1771283815; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9KPSiJIKj/b8QQwFvGSiwvCphuT1m/bq196d1vnTPzE=;
        b=gETDV3hY6DAC5+6IppNjYYfATpLazUXKeYJu1SIYtB3Sa2Cx6oDoLXhq7q7NWw6XIl
         IhFGU2vAptgXlteKAiCclNdM7FPEoEmSa0fHEO6O3GR9hjTD92Ske0txOAwvNS3dQZpY
         ZltrsnpJy/ymZxD6aqJHL8IOioRvcrIiEyuZUPZ9gKfixclZO3QZVKYZ4aoqfb2lcv3/
         KBeHxbedfZ+Qon8pbttB2OSO1R5p9LE7iPWuVk2O8dCYEwdbAbOYnmjFFVMRXFPpuPI9
         ubhwMFYEFpj1gjvQpzQb8HFipECRFYhHN0LF9gi1W0CoR7mV8+bljv4HdmO6FywzTR2r
         cKqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770679015; x=1771283815;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9KPSiJIKj/b8QQwFvGSiwvCphuT1m/bq196d1vnTPzE=;
        b=HxwxRRw9AEPMM0JsACY6r2f6WhNCUka9HRZdEDmUxbVHGyPEApOao+MEiaCE0O2gJr
         PbqsFarPyX/Ubgx+D2pz3ReqVDeZHwMRcGesmtd+fp7JZyJn3zXhgVvP1G2LdNozfwRC
         T3636QYQJCMpo9pnlrZ/9xqusAC0VjxLghYhC8mNEHV5P4F/OhNR1pklcr2prwtTkpXX
         gGi6dN/IR9ldEpFvHiQYn86NhtpdZk8KQ+CoH9SOlld5p7W3/0UAlMOO+oIg5FdVtJy8
         9P8HG53U/I7TLPVJCtcOJc84r3KWCjdNbhBLp0eu24bvZNhE6xskWwOK/C0mXbH1GEmq
         C5fQ==
X-Forwarded-Encrypted: i=1; AJvYcCWfqfC5sTEIuyjWhc6jaPICtoqJcxv0gX4Epqeb/L5YWz3qbhTywzZcSUxPVPzaZNuQYPOlnY2dvA==@kvack.org
X-Gm-Message-State: AOJu0Yw/i+Ka3cftX2Ff5CyDtdImOTKTv+RoJlukEirZtvc6O8aH7ghB
	z8ci8vpNpYiQ96dNsel2eJ+fVJUNj6jUka5nCfBp6ji9xktQNSUeyWO3
X-Gm-Gg: AZuq6aL6nHXmPqUKr3MQjUFImO2upoWkk/6MCJMrdB9yGKb7ovTZYgeE4+Q8I+Re2Gq
	nt3COi8W4DDSEXxJJd6v8IlcncN7lRC2ulT5mQAqlQ37OUES1H8540RkJFDalwmUFTAA9JO4/KH
	zQ6SiuWm5p7I+JGPemoQ3irrpFwVbRAv97JrIeMb+jiumdZa5153T7Q8B9NnKqfJY0X+Xoy89Q6
	W98H7zlx5+mCRXhkw+iEG2XcYEMaIHB6k1cOlWjgHo8z75aBBHzzDzFRf93bfsOactlk8a+a3fz
	27LrFkGwkuQf/I3w+wPqcLuWcWrHD5YMeYvZ1qCXmu4pQieE7EkpyqaVYWDyQbxM7Y47U/kkXxt
	6y2XEm7SGSOoCxZO6BapIMPTByrFTaPJ+1gwNHcOsGw4o1cmBPrbV4HtBNFwWGxI9HX/5Xz7K8M
	4yaEB4f9BEj3txMCD3RBZ5
X-Received: by 2002:a05:6820:3088:b0:662:f91f:4a98 with SMTP id 006d021491bc7-66d0c18aba2mr5686178eaf.41.1770679014745;
        Mon, 09 Feb 2026 15:16:54 -0800 (PST)
Received: from localhost ([2a03:2880:10ff:70::])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-66d3adcae3csm6928357eaf.9.2026.02.09.15.16.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Feb 2026 15:16:54 -0800 (PST)
From: Joshua Hahn <joshua.hahnjy@gmail.com>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Minchan Kim <minchan@kernel.org>,
	Michael Fara <mjfara@gmail.com>,
	senozhatsky@chromium.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
Subject: Re: [PATCH] mm/zsmalloc: fix NULL pointer dereference in get_next_zpdesc
Date: Mon,  9 Feb 2026 15:16:52 -0800
Message-ID: <20260209231652.1806289-1-joshua.hahnjy@gmail.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260209225018.1541260-1-joshua.hahnjy@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAC5F4000E
X-Stat-Signature: gmzj1ssyfyo4azgjwor93h9ghysmbxsh
X-Rspam-User: 
X-HE-Tag: 1770679015-287300
X-HE-Meta: U2FsdGVkX18GggW2RaqmyTpyMwzhMCvsbQpJV1kYk19f7QhWe8AbUZtjAyn/Fr+PUEi6ZfRsr1RwVJG7yQPFIHInd246SPqgBJuWO8S4YWLh4rutHwwCgUjSHxwa91sRuQsTLvc2P+1WG3aMMU07bmNdzuvZcclymMOdqsgrZnEpn78GVROnqDughXdE3DBZ9SeJz4LHuv/1QTrBK2a4LpfylaWq8o0U61T5i/cO/OlMU+xmGQXyCMrhEnLTbhf/8ooE4/RD9c02iPnYR5Z5W9bF/pRCvS44wD01qsfgJ4ujeDVuX6wQje2dnLsBCJ7BFS2A/5F+J8XeECpI37dkkZcHJ9jVijnRNzeIU8W+wnxr+MqdRtUsWGU+6lGODnUMaTEJR1nQ7rP/726984i6cjPd1Z225Tbwuv3vaOvaz6a8MBwAiSbd6LYBw482DqzA6xvz+shaJFPJyCnIWNLKDEMT5FQXEN9BZth1nC1QfXB5/HvHPy04MqytlW098Xm8HmNzPKaP0Xmeiu/NIGGUVupLML2gJr/dsLInP+id+pe6iWQZm30aTEaMggiZHSxyoJULs89S6JJGARGBFq1nu2clESDMjFnc6f2LrzyfkchPmfhSQCDP6uRhtT/DX9T3bwZyemyFUIYxbh56kyWwIe9T/o2vIvTJocM+tS0u14yatd0hT3F4FH3ZK2TR7Pn9sxplpltxyLEPn5z+GXCFwKbt9Ujtoj8RZqSiaJtfmtPwt1GJfK3Ymx6iImnPtjFrS4HHgMTOS731EethlNaS2DQk+ZWTajDtJFeQV6UsQpllF8jxj6viUbAD785pF5BRbwOF3zgpMFD4oZ1Rrvsa2/GvVlHRdcU4c0nohOOx+w+jeXZMt6FCTuL7oZLZ/KZRIDVdKcUimtSTNbd+wJ1ueZ1ACVukU8Iq93TD4HzwRhhsBbLdn+/giN6ZCZdJ56A0ZafXqVJQm0yqT9f29jD
 JFQAB7t0
 hcuu8cCsFQXvl3Bwu/dKR34AeN+6XyPw7vBiqaAjKjljg1TEBPLV6MpSh/ElfZihuRpD2qU3sTH656D87fia+txuFXt+OPxsyPetLkjztXYQlSGYGbxsjRffc74VRt+1J4/o5T14T2zCAgN6xxv3mSRrT1eNU5ZN4RbDa+X1uvjEjatISy8hHn/pGFWeeqcxUV9UmIfchuvK7CVHNJIIrGhM4cB9NfSKmy1BzeesJA11hLLu3Egmqf6Thy1lnb8iehRsq2eyZG1cNrGp4ZdKgG0+C1r/PDDmrGe+K3ZzEGJdkpxJpopnWjGeo0x1vPUOA4rLbRe1dPw9u+fTHyg0X7ijy+Yf2CYE0iRg6/tHyeDTmZgeHLLwjFPbDe9OKqVBMxiw4EVMqp2boXkGJOWBrHs+z4EViXsbl0SdrEINjFA4uCl5EJ8FfjSTe//LeBN4BP5Xew7OAV/ZKqPq98+p2YGf9VVK/wE8zF07AQoBhqwkTwVBwbqYZIZirim64tbqXJ/AvITjtGR6l9jLRIjUWiiEwXIMw/xDf9jis94CmySweZyzUy3wcP1t+xc04bNGP7tMHUi1fZDE+1wwP30WqrXdT66yXn96wV8K11qXFRSR6MUc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I just noticed that Minchan wasn't Cc-ed in the patch. Adding him to the
conversation here.

On Mon,  9 Feb 2026 14:50:16 -0800 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> On Mon,  9 Feb 2026 19:32:57 +0000 Michael Fara <mjfara@gmail.com> wrote:
> 
> Hello Michael,
> 
> I hope you are doing well! Thank you for the patch. I'm not entirely sure if
> the race condition that you note here is correct, and also if this is the
> right fix.
> 
> > get_next_zpdesc() calls get_zspage() which unconditionally dereferences
> > zpdesc->zspage without a NULL check. This causes a kernel oops when
> > zpdesc->zspage has been set to NULL by reset_zpdesc() during a race
> > between zspage destruction and page compaction/migration.

[...snip...]

Should we add a Fixes tag here as well?
> > Signed-off-by: Michael Fara <mjfara@gmail.com>
> > ---
> >  mm/zsmalloc.c | 14 +++++++++++++-
> >  1 file changed, 13 insertions(+), 1 deletion(-)
> > 
> > diff --git a/mm/zsmalloc.c b/mm/zsmalloc.c
> > --- a/mm/zsmalloc.c
> > +++ b/mm/zsmalloc.c
> > @@ -735,7 +735,19 @@ static struct zspage *get_zspage(struct zpdesc *zpdesc)
> > 
> >  static struct zpdesc *get_next_zpdesc(struct zpdesc *zpdesc)
> >  {
> > -	struct zspage *zspage = get_zspage(zpdesc);
> > +	struct zspage *zspage = zpdesc->zspage;
> > +
> > +	/*
> > +	 * If the backpointer is NULL, this zpdesc was already freed via
> > +	 * reset_zpdesc() by a racing async_free_zspage() while isolated
> > +	 * for compaction. See the TODO comment in zs_page_migrate().
> > +	 */
> > +	if (unlikely(!zspage)) {
> > +		WARN_ON_ONCE(1);
> > +		return NULL;
> > +	}
> > +
> > +	BUG_ON(zspage->magic != ZSPAGE_MAGIC);
> > 
> >  	if (unlikely(ZsHugePage(zspage)))
> >  		return NULL;
> > --
> > 2.39.0

