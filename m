Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB86ACA101F
	for <linux-mm@archiver.kernel.org>; Fri, 12 Sep 2025 10:52:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 24CFB8E0003; Fri, 12 Sep 2025 06:52:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1F6F76B00A6; Fri, 12 Sep 2025 06:52:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E5F88E0003; Fri, 12 Sep 2025 06:52:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id ECDAB6B00A5
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 06:52:57 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A33795B31E
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:52:57 +0000 (UTC)
X-FDA: 83880285594.14.A1548F4
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf08.hostedemail.com (Postfix) with ESMTP id DEB82160002
	for <linux-mm@kvack.org>; Fri, 12 Sep 2025 10:52:55 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X5yHn2qV;
	spf=pass (imf08.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757674376;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1S29IK27tvLbwH90GVH1O/PVAm4A4OJpS41gFvWUg6U=;
	b=SYBA5kJFh0rvoc7ACEv4qa1JOqnvEtXm+/MzeRSWLkwOjU3YBndEyXcpY07CEyCeDbusXb
	/gQoVC81dMKTgxiKx5V3erhITn+71r4vF4JEvI345rJEnQjC467LZGVy41GZ/Imf0edRJn
	zqrK0TkYZWrBPEk8GKWpyUcPyRTbwaU=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=X5yHn2qV;
	spf=pass (imf08.hostedemail.com: domain of pyyjason@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=pyyjason@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757674376; a=rsa-sha256;
	cv=none;
	b=p4y4iB3F5ydR+CI7xiK5Htbfq0/+wBu4GWJDNNCTZFHK4PLOOlkzjcvf1JsKKo+a3eBp+C
	Vvr4SMzUCECzDmoW2utHrLtFcKCwsRt7cpHr0NQbN2tJpN1ctZ6SrmAdojLwANc88PtFXr
	1f+zvPv0FDZeHBOmNQglwOMykf4rwQg=
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-3e76766a172so458758f8f.0
        for <linux-mm@kvack.org>; Fri, 12 Sep 2025 03:52:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757674374; x=1758279174; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=1S29IK27tvLbwH90GVH1O/PVAm4A4OJpS41gFvWUg6U=;
        b=X5yHn2qV3in17EeIlLyzCkD49UqbIwoCIrDGPkRLHGaObC9ywhF5Tw2ht2GlwSfM1b
         14AemZ7/y+tkGqpo9x7kpa4tVnPkNz+nFC5i0WjQ7hDCJ8x9CmL2P7rihvi5loIqktja
         E5t/YsZjF57n36F4YZLerEnoOx/x0kXftoqpSchVZTLKyuBho8C6ju2h9+B67V1fU2wc
         c6WaPCdD+kQhypB2waaI8T9SvXj9nFErpWc22DeyFfhjv8lTwRSuCmTwZwy1K5lZVjGq
         g4n85/zBB4f8eBAfDnWF4GnOKnydbh+G2hhdx+TZ3Qojo5eANkp2PsveNvczyYW+iQs+
         Bzhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757674374; x=1758279174;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1S29IK27tvLbwH90GVH1O/PVAm4A4OJpS41gFvWUg6U=;
        b=YjAqNhP9qFU+iWoHzkIwXiVTJBdxtYlDcBPNrF4hnzq8JRIeow/aZDddt7+fu8oONw
         a0JvXNfpu7JYvk5L93mhJ6E68iYoX9phAUl/oY6cBkCKo2Al+V2bUg181yOXjMMuRo+b
         gDVlUWJxt6JklGi8BMXoRLg15D9tybzVRsfeMh8PBgwiAAUxmUlYEOnMICudNziUkb21
         7illvZ0Y1XmnMlF1/v4Xq+Y8XYgt1zPx6W51CmmPW9QHKg3KEIJNQ96ystSq0lFMfNA5
         MEu+k9cbI7M3IcTvcc3vODETJLeoh8/U/Z8h6W16AAvCDmVwI4v2GV3xyzduUYyajBt8
         +p6Q==
X-Forwarded-Encrypted: i=1; AJvYcCVh9Y8TBmPrp71izJhfL3bFBukGLLuCApseaXVhwB6nRNYD/2ZSQYNvWKa0gAzFgbNPxyfLBs5dgg==@kvack.org
X-Gm-Message-State: AOJu0YyjLj48pgeEOFf8hJfwXTADEl9/h6phg8WyOstqfd5EG0ZJNj/J
	XNVGO1hQrlKzSid8+xSgSbeTz1HuohvXiuH2vuUp3jA68EtUZVgc4ZZT
X-Gm-Gg: ASbGnctBxTWY88ZGBPv13XtFIxANvxJXFA34I5hwNLNh8Afd3voWLHpJ853AqkQT4yO
	kbadCqKi6nn3drR5gTaqARwhYC+KFjhp/feKMZupN1+yxIqDyoHFdza2AB/vvzmkPKyuQIGP9qm
	H4oM1UX0evz2Oo9DQF5QQMi0W1StyLGqiK9LQwYtxTXqSSpdml3i6QgIQBExE5hGQja1NLMPSl7
	S1pR8FgwirbVDeAfRvZODwcCcnoj738KA4G2t4lOK1ENme9lywV97ZaXBdOgSu6JhMDiq7UA9sG
	2gcDt6PAHErbW4CL9oljYkUs50K3sOC2iyZsUH7HquMiACN9yezS/Q/WE4gm4hSUkoaHmTi+mU0
	8Z4Hb317Zqrq+Qm/LFqQlX9djcIQl9oEeI9fdaA==
X-Google-Smtp-Source: AGHT+IHKIxSqLjisSEAZCL3MgYJBWWQLMULmTpoAMEA3vgmwbnbaVLhvHvX9Jz1tbqtWEw2s1ZyCnQ==
X-Received: by 2002:a05:6000:228a:b0:3a4:d6ed:8df8 with SMTP id ffacd0b85a97d-3e7659e7a52mr2326013f8f.39.1757674373954;
        Fri, 12 Sep 2025 03:52:53 -0700 (PDT)
Received: from devbig569.cln6.facebook.com ([2a03:2880:31ff:5::])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3e7607cd27dsm5993202f8f.41.2025.09.12.03.52.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Sep 2025 03:52:53 -0700 (PDT)
Date: Fri, 12 Sep 2025 03:52:51 -0700
From: Yueyang Pan <pyyjason@gmail.com>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Usama Arif <usamaarif642@gmail.com>, David Wang <00107082@163.com>,
	kent.overstreet@linux.dev, vbabka@suse.cz, hannes@cmpxchg.org,
	rientjes@google.com, roman.gushchin@linux.dev, harry.yoo@oracle.com,
	shakeel.butt@linux.dev, pasha.tatashin@soleen.com,
	souravpanda@google.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] alloc_tag: mark inaccurate allocation counters in
 /proc/allocinfo output
Message-ID: <aMP7g7ts8n2Gubql@devbig569.cln6.facebook.com>
References: <20250909234942.1104356-1-surenb@google.com>
 <20cafc1c.a658.199394de44e.Coremail.00107082@163.com>
 <aMLvCCZbmpSE/aql@devbig569.cln6.facebook.com>
 <902f5f32-2f03-4230-aab0-a886fd8e4793@gmail.com>
 <20250911143132.ca88948c48df874f71983218@linux-foundation.org>
 <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJuCfpEoWtgv8k4vApkGsNNUYFBnvS-N2DPQu2JrreCUPbT5dA@mail.gmail.com>
X-Rspamd-Queue-Id: DEB82160002
X-Stat-Signature: erqojn34o6fo63w3zxuzxnmci4ppcfey
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1757674375-836993
X-HE-Meta: U2FsdGVkX19G02Esf0nNiewwU//CjBkVfvjfcvo+K0we3XjTWBz4TiyP0xyiVY8HOAWc7cU0R5MZWKNSVXJYaa4jPTbotlnV7N6pOfEHJouTpSo5iKXHqEmlXiTiTTd2Ery56FySb1VXVBu3Zck/ZnJHAmaCYPzt98Nia+8unR4ImYNR4V6jPAwInTjTMC5D0k+/O6fZoDV2P0csyRkflzmEaq+0IHzBmmOysx8qthtU7X8U0UoMOBCNUowWDLfT5j8esPJi9F0dx/WeXA82vIy2cn0Q68b7McP5UnrdpmcoaLRaN5cPTwV9mlOPyc1S+5cmZCoRsyl55X96Ediy7wGp41709jZ9vFkzuIPocsnVNVsIGlyYUy7tlFMeV+yK8iLLp4qL61Hkzdogd3aatNJQQx6BSBcKffOxSNgtAHQSp4tSKXt/6dUOMYz45UYLTU70q+bb2aK0X/SP5SMGAZKr8P+6wEbr0pQv2qzBu0kxS8OmwG5qLHw2t6vo97SG2H5DxwX5HzOPYtGjnb1nZ0FUPciIRjQ+DodBZfWQPni8iaDA+1JRprnpAYnIVu166Vu1QL8bAm7e8pFRH/BiV8dAUUzg/ipOgWXLc+vQ8DJHc2a+/I98wOBVnG0ozkkO6JXEeBnmEQAvbULuo1bEFoBLoURVbVilapavt/3Tqh9UZ4Unjglhedop14J09nQr/7ratkYb7kP+K1CnAmiQ89/7Ao9wlXYx6/EQNE6kJM6j+4qYK6Ad5jC4KGphs53GAq8r4KHINSZIv0krqgqroiK0zyFZDTLwesQdvZ1tUmwLW/GEpGvjhb2Uboszoj81ueXzfpJN1yZOqzuxoCI0qVkkWndj3dXFvuPly+ZKtvDI92LKU9dlcsQ5IvYFoFIEFJwZylgnbALFHwqvcpm86AIa5bpncA7XkUb+Liy7xwgpf6JMtWku2l4wBEbUsF2xG3ennR4Pnj507TLtDJh
 2lIYf9zy
 kJ4ymZIscecp4pG6CU4COGFe9IbUvtyEcL+hqwa4TNAoqupz2rCuBh534dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 11, 2025 at 05:25:12PM -0700, Suren Baghdasaryan wrote:
> On Thu, Sep 11, 2025 at 2:31 PM Andrew Morton <akpm@linux-foundation.org> wrote:
> >
> > On Thu, 11 Sep 2025 12:00:23 -0400 Usama Arif <usamaarif642@gmail.com> wrote:
> >
> > > > I think simply adding * to the end of function name or filename is sufficient
> > > > as they are already str.
> > > >
> > >
> > > Instead of:
> > >
> > > 49152*      48* arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create
> > >
> > > Could we do something like:
> > >
> > > 49152      48 arch/x86/kernel/cpu/mce/core.c:2709 func:mce_device_create(inaccurate)
> >
> > Can we add another row, saying "the previous row was inaccurate"?  I
> > guess that would break parsers also.
> >
> >
> >
> > I don't know if this was by design, but the present format does provide
> > extensibility.  It is basically
> >
> >         NNNN NNN name:value name:value
> >
> > one could arguably append a third name:value and hope that authors of
> > existing parsers figured this out.
> 
> Actually that sounds like the best idea so far. Currently the format is:
> 
> <bytes> <count> <file>:<line> [<module>] func:<function>
> 
> We can adopt a rule that after this, the line can contain additional
> key:value pairs. In that case for inaccurate lines we can add:
> 
> 49152      48 arch/x86/kernel/cpu/mce/core.c:2709
> func:mce_device_create accurate:no
> 
> In the future we can append more key:value pairs if we need them.
> Parsers which don't know how to parse a new key can simply ignore
> them.
> 
> Does that sound good to everyone?

Yeah I agree on this proposal. We can keep this convention.

> 
> >
> >
> > Whatev.  I'll drop this version from mm.git.

