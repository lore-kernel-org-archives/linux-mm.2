Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1F89CD6E55
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 16:23:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 16B1B6B045F; Mon,  1 Jun 2026 12:23:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F5BF6B0461; Mon,  1 Jun 2026 12:23:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F26DB6B0462; Mon,  1 Jun 2026 12:23:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DD48A6B045F
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 12:23:18 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 246B0C08DF
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:23:18 +0000 (UTC)
X-FDA: 84831863676.13.427D361
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf15.hostedemail.com (Postfix) with ESMTP id EAB82A0016
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 16:23:15 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CiCKJY1T;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780330996;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5aZ4vAk82i6DVnbVmOCwCzllylMU3ucK3p4smWm5Ow=;
	b=orx9ZV1zZ9hViwmm0SBLSppQD9DGojgNSAmi90txGuDBpvbv9QQ+8BvDZzHtApzFgOd2d6
	S268isFUJIlguD/NAc0n1ZnvjnS0o6wuaJrDCI1vHAb8k+qhHXVxFdWSjsTAVCcn9W34cn
	dU7AGUU3inlgOUQZd4GxIiGbFxpQMks=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=CiCKJY1T;
	dmarc=none;
	spf=pass (imf15.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.44 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780330996;
	b=IyZyOMbkEuYvxuBmxg7EWJwnbjPpiKGcJnQxl7kRxxAu6bPcnCsWBWmg03LIuA+9bCCS55
	nX+WTL4W+ujz6fuSaqtcXUZqEaOovXkThsQ4hHzLo/6sk5L6O6Bb4ZMHozdbjhrJk7kUUy
	OiqJDsX65k33U4UgHJ/TqvyZbhTgh+o=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6896c54a7easo9860301a12.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:23:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1780330994; x=1780935794; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=K5aZ4vAk82i6DVnbVmOCwCzllylMU3ucK3p4smWm5Ow=;
        b=CiCKJY1TWOUqhjz5jme+OUGjC2B/E9P7/Sqj+JF2B4RPrzi0/0d7REAp0gHTSMmnTk
         2YqvRDLqM4jc2mpLGZDltiMQIEbBIXY/u7+NSDH6ofKK5Kvl7N8Xy5Gk8wE8O86uSrhY
         PFBkRA1M8icSuywph4VqHh/6m+W/bYx89qAXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780330994; x=1780935794;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K5aZ4vAk82i6DVnbVmOCwCzllylMU3ucK3p4smWm5Ow=;
        b=ifq0wZF9pX5ZlbnTSh0RvzsCG2S34S0Eg1AT4du/80kR21im3CeYyMAKXBjHiKM3G+
         Nkr4tNmU6UCCgMYFUXtafceiohGYzwjtDgOXuUigaP+AJW1B6nmYVhbUD+BSV0xUM0Wj
         CJxNlbimzoNxLoZzrxRc1gnpXpoOmSGYgaksF1KSEePQzViq+OSooqLveGgkphDaYshC
         UGXoiMplmzfnqncaAz/g3bmA5FMk9fS3dzA0oJ1gK5CDtkqa5XUXvB5M6369+ObF01Up
         pKACTt3Lz3H+n6vze2IIJKxhbaafOG2A0zcblZ/RislrRbj8Ifcq28chziqW57mTpurr
         na1A==
X-Forwarded-Encrypted: i=1; AFNElJ9uCGWz1JwsWnkm5df+o6/Px/BTbDwCO679o4FRpbRbWTReOC+gHa0uiiRmbn16B1tmZWujQOk6yQ==@kvack.org
X-Gm-Message-State: AOJu0YwPcZPcYf3uwc6epDkyM/t+ex0Z24w5uHJ+uBVV7kJ8GBLnrVk9
	1vlZmgjyj9VqPGQvpJRoSk2MiqhAsbT+HJOe5ycQ1ZETD0tHmmzH73i6jdriM0sykEkCIHSwl/C
	iKKZU3mA=
X-Gm-Gg: Acq92OENPKF7PvqOy15SnHQIJx1sl6fvvclIgRoEMQwdcJlJvH4jsYCUYqtWLh54GNa
	GhenVEofl/85pjYZR0uW5ItImxt7HZ3gCGKX1PFOjlNFLYf4EFVbDq500+cLg/vVPxqNKJ2WFCN
	CsRaX7WODehjCkFuM+prbpXfLwkOeHbsYqiWqIkwg89OwDbWnrWbOmnTiiyefdTEu6VOSCINr6R
	stzjv2xiUIkuE89Bsym8BqZMEMFKTX3Og2DI1WcwTCcvxHH4kt0rHFE/cKvFNUKPPtlK5p0NrhS
	oRmoALVWHHemLEkjY8EApZJrcUxu97RGvR+eZHE1YApLfXZVVb2K83a/tcaC5U+9ml48oU5MHD2
	+KuGi754wDRLQOcrMU5iO2YCC2LgyYYSU2lg4TRloAj2l6qM8qeYhqnGRSdjWsXnpPLIqTOnXum
	T0MfBjrI9OXG1kRn8U4vEYuoeiXI02ix21CbXvd7Od6Z3klqEndxuNeQ0Cgq+lus0EzHF7+usPx
	Z3J5kGcy4w=
X-Received: by 2002:a17:907:c16:b0:bd5:7c2:7622 with SMTP id a640c23a62f3a-beab2e4c7c1mr685438766b.49.1780330994274;
        Mon, 01 Jun 2026 09:23:14 -0700 (PDT)
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com. [209.85.218.46])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-be9d2de53dasm363965666b.14.2026.06.01.09.23.13
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 01 Jun 2026 09:23:13 -0700 (PDT)
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-bebb72b845aso279305066b.3
        for <linux-mm@kvack.org>; Mon, 01 Jun 2026 09:23:13 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AFNElJ83YMUO13/3zPQl4e+OBAeJkUhrBcM40rfg+xIoj5SnataGlnI6PrwLWijSvhog/ait66EW1In+cg==@kvack.org
X-Received: by 2002:a17:907:3d45:b0:be3:b3fb:e2 with SMTP id
 a640c23a62f3a-beab207a691mr724400066b.32.1780330992765; Mon, 01 Jun 2026
 09:23:12 -0700 (PDT)
MIME-Version: 1.0
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <CALCETrW__=8mSusayfXG7UFCfue5BGbx+vqESj1d9wqOfX4s8w@mail.gmail.com>
 <ah2nBAdsE5vVJ2PL@casper.infradead.org> <CAHk-=wiFuud0Nn3B9YpTWyQja08TeXVk2AB-aAkmVXyigOagbQ@mail.gmail.com>
 <20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner>
In-Reply-To: <20260601-aufweichen-dissens-ausrechnen-0d9b84728113@brauner>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 1 Jun 2026 09:22:56 -0700
X-Gmail-Original-Message-ID: <CAHk-=wj1dSKpF=NMJmm9d-7kJY=BEVkchTaxsL1LGL3n89KtBg@mail.gmail.com>
X-Gm-Features: AVHnY4Kn-EiKMLw7r2InJ00RsvMx_ZNQz4aALUAoaty1wqi8l1c2ToY4hj4PgVo
Message-ID: <CAHk-=wj1dSKpF=NMJmm9d-7kJY=BEVkchTaxsL1LGL3n89KtBg@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Christian Brauner <brauner@kernel.org>
Cc: Matthew Wilcox <willy@infradead.org>, Andy Lutomirski <luto@amacapital.net>, 
	Askar Safin <safinaskar@gmail.com>, linux-fsdevel@vger.kernel.org, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-api@vger.kernel.org, netdev@vger.kernel.org, 
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>, David Howells <dhowells@redhat.com>, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Pedro Falcato <pfalcato@suse.de>, Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: zahdudtup8u8gzrobrjsmrrg1y9yxrur
X-Rspamd-Queue-Id: EAB82A0016
X-HE-Tag: 1780330995-448087
X-HE-Meta: U2FsdGVkX18FZgCAli/MOQ9LZiY6sC1auXrhGlYhwqyT+IAyCm/6XHtjmvYKXaxxTwWgRy/u++k4UNI09eeF5TU1NGsiJMZXRvvDjx/4bIYJPHhY1+aqKuRHhHNyNU2l8yRjMOyNcT1c7enYO26FOP4wbjiljIQehA0GOg+6kDtV1DzOyzPz0gvZWCAjxniZh6V/9bMQpaHghcWlSgrtWDmkIEpJw1Z0hRFolUgBJKobGIxq8Wq5xV8o5VM6heaPkWC0Yg1TLBm/WH3LOXITY75ppvtax7PMA4qriV5D+W2zdcH269EgXQoPK4iQ8FVixj9tgOwvTxzLURmPjfD2faYZCZGzAEi9e9QmGxuF63vKWZCYHjf4lulQp/Z5dzurvEWylelzD2fs0ib81Z3M+omK0wXMZLimssSpm/Gj5k0Qf9OhHHkfu5KT/4hgWy9/h/zWvnH+Epukx9MxDIdd47vnwTz7ZB6FTPb3rplL9sBHWb4fmavAoOwdJOmkXK7dXqbdHEZhVYGsYzj6LOipOFEZNDswAxjo24RAF+/OzM0L9sA/pbNIEUa6BWvREQGA1YAlA3vrpp93qN0s8H8stTTSH4u393AllvCODiKkgPcbT6zb+JguYu6FbrVgSK1P4CShoFVbs6PPP5t0fkD4/VaZioSNj/jZKXswHw+v+cSF5bx4py/k7DdL8SrpBxdE7RJecnpcYp0ysYEtadPVhGxqRVUZQh04UGUerrJ1bEbow62eJSf3LuGp4kYDmkG7d6mi/lqwfBnqofavq1HwDSEY3lN/jnXJ3GITodxa0H4DSYOoMMQx2RnpYaImKDseG+AA1AegVPT77obGk0MU2mkwnTJHkopUMwsTJkSx0XmEUbqUyBjW3QmrsT0ksgHwlPzGWT+ibEI7n+JlNU13eKxb+eWqvi2gCy6c+i66pezVyYYHs3lJk4I0vz0mSVCFsgAxglQ5fxSCbi/SJxI
 7eZWe1/n
 4dh9aIuvW6dkbHU9uwJkNYtZlipC7tbkCjMp4c73v7hO65r60IC6drN9TU/w0zRn8fiziGJdfznzYWdQku8ulC85MgwzpkPnEeob5buIJ/UJf5udJ4bt0uhMa3e5c6+/PngmhMRYs4YmqAK4srR6HMSsSlV1wADRUhWCTdEnrzg/KRhtEWSwimghwyZQrGwGd1iCUYRBTACVwDkrisjN1O0vpj45qQKZZDLU7uE5xVHejRsruCA3JyFSO49Lc7yw63xnc+C/i3+9sT1MNLcn1FL00BnlAZ1vK5h/tFQA0xUjmiTlto6ujQPm+OgTCSmegbW1RABlInyHMziTqjtxidqSysypz8aBbu19kubxrM7zegNETiaOYzhv/D62VzbYXCwFjQUEntG/0cwyQLUGM98qBmN3Bs6D+W0X3kb96gxB1oYyXRM7Sc+QanZjg7Uaxca7DTz/prU3sOvHB2AOPKcnJlVs3PxIG/DJgA0ft0eZR7EMoRwzvJdelTN25BQVp/t5JLfsq3AzKI8/m+z47k9qup8+bpmg++Ysj30rNIDk3/JDsE/t2y4GsARDUVPPTmOO2nUgu0hRc12TOuTYg18rYixg2ixUx2cHmtKGZpm0j8ufNy+X6FfoGjZ6Zq1VXWDaD8InFKcB7VJQ5dMxSQwZMFg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 1 Jun 2026 at 09:17, Christian Brauner <brauner@kernel.org> wrote:
>
> As usual I would argue to accept it and revert in case we get actual
> regression reports...

Yes, likely the only way we'd ever find out ..

          Linus

