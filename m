Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65478CCD1A7
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 15:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C66018E0025; Tue, 21 Oct 2025 11:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEEFB8E0002; Tue, 21 Oct 2025 11:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADE398E0025; Tue, 21 Oct 2025 11:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 990248E0002
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 11:50:41 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 643B811A394
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:50:41 +0000 (UTC)
X-FDA: 84022559082.05.3420654
Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	by imf12.hostedemail.com (Postfix) with ESMTP id 78BAD40012
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 15:50:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="MG/gvjna";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761061839;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WSX4wv/8cP4pcdwROoiiFUZrKHWnfYkhVs1Qya+vg78=;
	b=xUnrCktCZia6Hl4lCdmEcmhJFIK6YA1uddLxvmDJNK+5sEccD8uSmWYFnb2oBC8VlwQGwS
	ebvSaeyVu3+4pi/gNJM4eEgDyzmI3yWKoXl/STreq6ltx9fAgxx7ZeqegozV9BywVfNNwv
	zb7C8A727rS0ypOCzmPnV04T9TU1yFs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761061839; a=rsa-sha256;
	cv=none;
	b=XCU+XBANcuiJ+VTf8f+NaKsj3ZeGyBBwEjM23b7KOqtBhSVrPxa8KpyHGfFY9qanVoxN6X
	CGZr4WGWif5bv2oG2ILr0wfKhty8Mt0OBpF44O/Xb/1rdygOL1oIU88cbpd2trcDKeETBe
	vpYC2FrRHhpHJkr27jRSUgaL+sFTGHI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b="MG/gvjna";
	dmarc=none;
	spf=pass (imf12.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.218.53 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-b54f55a290cso874731166b.2
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:50:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1761061838; x=1761666638; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WSX4wv/8cP4pcdwROoiiFUZrKHWnfYkhVs1Qya+vg78=;
        b=MG/gvjnaeP9694naA6EaX5/Km66iCSJDDM0N7HsAoIa7oKr+xzQdkJRM5gLQdgly/n
         3pvD8Jss6tGNxNvivS9frT1D/eeNq31HrjIp9ClqWWLmew/Diu4VMIIHpWQP7Ye9+Vx9
         5RNOlcILJNo29NGridOom2EU4FLjYBma5xcd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761061838; x=1761666638;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WSX4wv/8cP4pcdwROoiiFUZrKHWnfYkhVs1Qya+vg78=;
        b=XqjN0V6UsdQzhOY8rsnhe5hbFI0VcT/yIlnXeN9CamHA9KQqpyCdebfu6DYEQtS2PZ
         frpNDUimXDeVHd1TGrJyw+yw92l8ADc4KsUjvigwWnTSnsFa7cFieEzmBwuvdFEWMbRt
         fPK3jSQmhl0efxHdssFFPnonZS/7dBJZcyISbgpwSHgrWrrYwegjQP7C4wlqLw0kh44a
         yV6nQ42oZTJBT92gyuXrDkGos4iBAcPJC+G2arN0CsyXAXbHISHmHgigT40NA3vxUGle
         DjNA3eSeKHpOQtI9FMBq1knhlcIAPcMCS+zt6Pf4Xwrz3GP12jE8FG6ooONWCBdN4Y5B
         e3LA==
X-Forwarded-Encrypted: i=1; AJvYcCVRWwFWTds2j64oWfLEFUnDnkuV5NWtRRr7hzVcfEnH03ZbXWX4QR4bm8oj9D8YfbokB+mBQIOi3w==@kvack.org
X-Gm-Message-State: AOJu0YwFn/rvtSG7x3bk3H8iuMcHUK8858BNRxjOMERkyL9AvfQFPfss
	I+P0D/ZG7n7hI04I+q+vT+WZdqCwRYPFDN/aUZ/n0NCjPqKP48TfZwKNqc6P1uXJ/lbfVFKnSgV
	z8LyOFjFtTw==
X-Gm-Gg: ASbGncsINHO8PijqHDZuvwTJ2zl8igWpqzOi5rzW6n9x7a71r59lhK5R8XCZigdsoYU
	0x72ntbcW407DKFPkqzs8AtZ0utxrlyOQAYwfWSuoVOyji98dE3AYX8JG8PKMXvOcD6MJMDPn9c
	sXb0tkmCi2tUSE9+omG3CQwF5YSFMfzvCmilFgBToUE+zXJOeOGXrLyPPOh/fEzRj8QTLWI+z8W
	uDYLFb/w7mosTZSXJCqfEncBNZeXuDVQZ2cctiZV9a471m0iTl4JBXEeYNnES3894p4gKUSxMhk
	Ei5kut86emA8z9BBvIWImBxOHA4WOWBKbdT2fEgcaV3H71I+lf1wT8ilfjKE7XjLBLKfYdB4mM2
	xEgj/dtUFkPIvQgIM6MTklqwKN4dbgtJKDs7nrWyEMb1n5d663QLditaXH0ImS9UDDIAQqwDc8I
	EnEniSDp0S8InDNexNDKfRcI9pZCmEusw+wVHEJXJepu4KLSG1i09n8Qano9Ql
X-Google-Smtp-Source: AGHT+IGKOOe3gGOK0PMz5kRA6ZlG5uR0MhKBBNa2bZuEioytUzmEk+AgSTCry7Asgpy0Df3r5t+n8g==
X-Received: by 2002:a17:906:fd87:b0:b2b:63a9:223b with SMTP id a640c23a62f3a-b6474b365eamr2294472566b.31.1761061837775;
        Tue, 21 Oct 2025 08:50:37 -0700 (PDT)
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com. [209.85.208.48])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b65eb525dffsm1083309266b.61.2025.10.21.08.50.37
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 21 Oct 2025 08:50:37 -0700 (PDT)
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-63c31c20b64so7312124a12.1
        for <linux-mm@kvack.org>; Tue, 21 Oct 2025 08:50:37 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWioPYG0UcoESpL/3quhwb+2PWbjx/6ltAkkBWxgPi1Uk5EfznY/RN9C4Gq1CaoZezuDqdGgd7pRg==@kvack.org
X-Received: by 2002:a05:6402:3554:b0:63c:4d42:993d with SMTP id
 4fb4d7f45d1cf-63c4d429b92mr11883163a12.31.1761061836721; Tue, 21 Oct 2025
 08:50:36 -0700 (PDT)
MIME-Version: 1.0
References: <20251017141536.577466-1-kirill@shutemov.name> <20251019215328.3b529dc78222787226bd4ffe@linux-foundation.org>
 <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
In-Reply-To: <44ubh4cybuwsb4b6na3m4h3yrjbweiso5pafzgf57a4wgzd235@pgl54elpqgxa>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Tue, 21 Oct 2025 05:50:19 -1000
X-Gmail-Original-Message-ID: <CAHk-=wigaATtHqwU+KHRzf-t2jGmD=zT3tGnJVD+4MAk86tpNg@mail.gmail.com>
X-Gm-Features: AS18NWBOp9VJpCXyIKnJNta0lggyjzqPvsPMHPbiYL935bxgvLcEoC8FIS9Zxss
Message-ID: <CAHk-=wigaATtHqwU+KHRzf-t2jGmD=zT3tGnJVD+4MAk86tpNg@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: Implement fast short reads
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Alexander Viro <viro@zeniv.linux.org.uk>, 
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Queue-Id: 78BAD40012
X-Rspamd-Server: rspam02
X-Stat-Signature: 1bm9b1enxdyzt18pt7b18aahhwqkyezd
X-HE-Tag: 1761061839-449327
X-HE-Meta: U2FsdGVkX19QhuNj/YRxfdJFHOZI/reOM+4zsGuAkoOk4RvhZuGZrX913gLGHu5hu3ypt8xfHBpy4A0Kf7as2qseE1Gev4gMpsswbe9kCROb31427Ydkdsq7nsezswr7WeEuMBv8UyyolwaUYlr4NR4AFog2z36Np+pgfLU2+AP9aIjECBmxBzbNtRXKWNfS7GnJ29Q0jG5azdirngb3hSasWRTlO3RpMKeqMJ9bN9P3xPoOcqSa3Q+lowKdbijkKIi7CxwAPEGhx9JUCGuw9zY+p+d+kIdNTvmPLhjPFt/y/Y6dExWBrRb6I7sZp7p80T1bWk1Xm2hTrQPrtPuh7qsfREfAGXHumOgu7jGWls0se8xscfIxIpm1rK9nyw6P54LVY/sQtsFDw6FhEQn3ooGWBwn9Lx+nsD5Rbeb7/qt7tgetEUxWCajnEeDX1FVWCLNKOdUxKUnZqhDjmrlHoFdT2KWS/9Bu8AOn3uiEfl9A1I9UiuWnljeusXv+CBt+tHcds9Jsja40Tegxp0/5Z7HQR7VrjdIzrjyH5EQrEeMHihTvpXjPmfpuil31gI5usMknNaNX68Jx6b4X6EhvW2eXGT98yraSrwuWs3W5U9BS9Dqu7/KZLyIr0/ffq7lWVpDwIFqQQfhw95usrDbUj+mlbONJf2chyFkYlf3m2TawCtXFrhk0jIVMHrqzOZYRGQTv3wj3MOtbqP0ycPjMb71OE4AEl8c5XNnGY+GKI05ijuK9sfrEQX83mziYUrH3Ebxg8xjVROPkP4N2kjMvzuicFgzM1U6yrBu/F59fMG+DtSP+tPLlwg7QaDPLVMdl3TrFLDesHB2pddEZuSi+RN8VyNvmQtCI5aP0cnISWv6peIAE7wjvYrJrr8j67PLhKER1fPcOhMAk4jJN+SvhwVHAW1hGLfyRJWrxpujkzWEi3Eu61mvuOUqp1NCzyNWekGZoetS+VAfvuq72TMk
 qbIMSf4j
 BwRrC1yg1iv0kmgiUszsZ36HlgN6cspMBmxQj27HKSkL2V73d3sC+N3rJYWNuph4+6bSh6pzz9LrQl2QIfxgOg863wsyXOpQJkQfOiM4fvsjcKokbsbQjuFGAc6nc+5kxdVWP3nPfQV3cleSxwCO/C2mH3+3RbfqASbxnKxxMRIA1J9Q+0uYzW8va/A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 20 Oct 2025 at 01:33, Kiryl Shutsemau <kirill@shutemov.name> wrote:
>
> On Sun, Oct 19, 2025 at 09:53:28PM -0700, Andrew Morton wrote:
> >
> > A use case for alloca() or equiv.  That would improve the average-case
> > stack depth but not the worst-case.
>
> __kstack_alloca()/__builtin_alloca() would work and it bypassed
> -Wframe-larger-than warning.
>
> But I don't see any real users.

Yes, and we've walked away from alloca() (and on-stack VLAs, which are
really exactly the same thing as far as a compiler is concerned),
because it makes static analysis much *MUCH* harder.

Let's not ever re-introduce dynamic stack use in the kernel.

                Linus

