Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB980CA1015
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 12:11:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E5FA18E0010; Thu,  4 Sep 2025 08:11:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E103C8E0001; Thu,  4 Sep 2025 08:11:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4CDB8E0010; Thu,  4 Sep 2025 08:11:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id C247E8E0001
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 08:11:04 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 53D5C1DAA85
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:11:04 +0000 (UTC)
X-FDA: 83851452048.28.63E26AD
Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5AC5C40009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 12:11:02 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=L9DR4+c2;
	spf=pass (imf04.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.170 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756987862; a=rsa-sha256;
	cv=none;
	b=LUZSFY0Y6IDVaOx3GnVlSme5oJMpQXy6k58M4SlyVzqb0t6314olobe7QnvZVYHqTrvK1+
	bBFIGFN43ZuwPKbFVealHDRJtMn8GzWe1Qz3+Jpv0hDXPi1Ah7P9v5N+tu3oUBVC3lEp/i
	jTcjuCtCWsGi42KbNcwJ7hPbB4QWQAY=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=L9DR4+c2;
	spf=pass (imf04.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.222.170 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756987862;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gjlVq8FpVKFgiAyllL0wB2r8/I9yHjQu5VbHsqkQxiU=;
	b=57bZCbXFpuQdBVVQiP09JUmox9oRPt5aXZdE1P/ofO/ax+hwIy1ZWcMf5qNKie+2EeuMC7
	Hkqa5nORjqOTLlTGyPW6PjeRNlnTp/jQgGf3OWqGn1UtZ6XLGD/WUII0+ESnGB6NgKzZSn
	QxlXOY8WucrCHUOl9C86Eid65hy7vQs=
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-809f849bdd6so99072785a.0
        for <linux-mm@kvack.org>; Thu, 04 Sep 2025 05:11:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1756987861; x=1757592661; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=gjlVq8FpVKFgiAyllL0wB2r8/I9yHjQu5VbHsqkQxiU=;
        b=L9DR4+c28TI4manGSkLpdAOLcQskPg92LeATfdLbk3XZQK/s8ZaSBD0pIljosgG8l5
         H1H82gO0aJwMgD4imHdmQJuamBc4Xoq6LgbrtroZzgFQ+qTMJEqyC+2Sa3oVM7vFgm0q
         9slREXAXoe2ur34UW5IEHSHljpFHbxWvJyP+w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756987861; x=1757592661;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=gjlVq8FpVKFgiAyllL0wB2r8/I9yHjQu5VbHsqkQxiU=;
        b=K7bFCSYL6s30bfTHPSI38YVSBz9MH566HzsAJJ2QtaHzjX9N4IUbATPe8KdWMCnQyn
         tTjLqtTs9+ouo8WMNOnW3gJ/kzb3GzvCQttSbQTlHfJKR7zfbjNc4ehfn0HseO3yitHc
         nDCrWMOkq7SUkP6F2qaJdxjG0uTV6J6Uq3XO10otKqJ5KT6Xw7BGjetql1MgtFF5jKoz
         4i3Gs+Ju6kfmBpf/bU09pzrICRL2EtiZrhmXc7FR5npJBVhz6PNjhAyYWPg27ZVOFbq8
         csjs9B4mzgVLqOxz8fwVJvgaSU4O45wtQTjCFuASH7ceBaIUKrob/GAQVJM/JmkvkGur
         0dvQ==
X-Forwarded-Encrypted: i=1; AJvYcCV5IWt5zLswUL+cnelJDfyxGrYmvv4/Cji3TaPjPluRyNbWu4MgLtYo90OM9Y2p9VKurg+CGl875A==@kvack.org
X-Gm-Message-State: AOJu0Yy75k8CHxfSjLgg2WC0P8l//jMOmeuq+ROB719T+CM5x6cjyM2D
	dcrIbAhuLF+xjqbQ62a9CO5lQrM9xNnll8wJ54kZFpXDoeWRzn823nZzRnl/9S/gZ9k9Nt5bWy3
	lyNymc4Z3pyYDfY49pgC+3hUzxZEW7/h5DPAAuEEq+w==
X-Gm-Gg: ASbGnctqRToERdvkpXuCfsQtlSFJiXouqw1sd7429uV5Ivrd1y8J85mtGyUa5fDqNES
	EvfRNCXdJzDoL4dDdjBaYdubmlnX2IhTpj+6poju8XJd9gT4vXRe6Lm9UpRst4s4H10N5p5ReaH
	6aqS8iC8HWKqzE4/+ko0I6ikTx8Vaso7HExEznOABh7qfl7VsKLLt1L08qJCI9jtPEQY7EjavsR
	PqO+0m4fjF87aZnIzfmMVGjtxu98QhIs9i3DB1gPHjtDZKfCSKE
X-Google-Smtp-Source: AGHT+IHRBKQCViOy+3E5ogp9zVpNMNg0Q43pXtgHycVq8ia8hUOj1ReM9zgzxUU55FO82PBbTz+ok2x7oLUwMlmTuHY=
X-Received: by 2002:a05:620a:2948:b0:7fc:c964:38df with SMTP id
 af79cd13be357-7ff2b5a713dmr2135908485a.55.1756987861094; Thu, 04 Sep 2025
 05:11:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250904120339.972-1-haiyuewa@163.com>
In-Reply-To: <20250904120339.972-1-haiyuewa@163.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 4 Sep 2025 14:10:45 +0200
X-Gm-Features: Ac12FXxDCj7qXFPJlrrixUNL9wFH0RfwVg8nWGcK3mUz3g-juiYtolyxpTYsSD8
Message-ID: <CAJfpegswS_KRpOxsCYCR9-z3uCGKrJz_=-c1__CHimHC7Y=M2Q@mail.gmail.com>
Subject: Re: [PATCH v2] fuse: virtio_fs: fix page fault for DAX page address
To: Christian Brauner <brauner@kernel.org>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Haiyue Wang <haiyuewa@163.com>, David Hildenbrand <david@redhat.com>, Vivek Goyal <vgoyal@redhat.com>, 
	Stefan Hajnoczi <stefanha@redhat.com>, =?UTF-8?Q?Eugenio_P=C3=A9rez?= <eperezma@redhat.com>, 
	Jason Gunthorpe <jgg@ziepe.ca>, 
	"open list:VIRTIO FILE SYSTEM" <virtualization@lists.linux.dev>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 5AC5C40009
X-Stat-Signature: wojer15chhhar45p1dsbmuzb58r7q16z
X-Rspam-User: 
X-HE-Tag: 1756987862-657581
X-HE-Meta: U2FsdGVkX19Q/GPSkG9O4j4biOZ8SQDJFBwGA8YgXOJzt/4dXPowJBij9u+lci6X7mCaFftnjQFhlfGA28XzoH76rLe5gzwKBNXxxU9njqg60XVVX/0Z55PrRMszbn4NwnQZbLf33kcF6UHs1IRCwTXqji1+hc/8zpVow8Mq6y18UDGhx7MPZGhCdvfLsFuyvudILTKiDy4oQ7pGhTtxlD4g0i170pY0ukcXgldkthZpHIN0fYrlElczruoo7PAkHmyjKcSEnajBnsakAiUv9Tgv2FkJf2cGthrkPoniLAu3x4K3KwNNIvfspanVhrMyRfwmhw2QrEUUMf+B0svmPuMgu7v/HNaWlSiDfLygPF9MqDSadl8YAARbl/dlaWYlWrVemRs7oKSgW5gX5EXnWC7BOZ42vcEwjduMZXjEEnwEl7oHaqk4TarpftTLVcSZm0VUEWPiURbfMt8XBX1+Bw7NzfSFkvR7BvTBGQHvrmsxJeJ7mzFWOTPvwAT6+/C9ihaEd8CkqCnblq9jLPJ6I2AgsnRM5TePkXVK1hhNw6aKrzn7jlovvDNfgFwmiXEGbupvF8C00uhAyIP0hraZlE0CX/iw1UTJWqWkpq/QkEl7nEwNlMyB0kgZWd2D8jHb4PBpkv+KBYcZ0qYIgcsfTGRiwg/vncdZnKgxFC/mLln558YQmEI3EnEAOcOwC4elMCdqw4h7MSG1Ca73xSPLP/u65iJ0hij8s4hX8RSQrAFC3eFaGJIjz6AnjO182hpKacDSJbaLXHuImlDPEFTozQaTLxOIFTo4gZHIUSvrdZ5KBD+5aN9jMv1ox/iHiRi+kT1KZiC54FXauCUrni1E74BJOpyVOA40PErueSW/rQpbvj1EZewSXqBWe/s3ayj7UDilkWbXpOMBUSBqusWeGbbCOVDWD2xKAo87te7D50BiEyNfbB8obPBgKQ6+l8tZ+ptl9jWwCrjr0Vo2Ai/
 VME/7+M7
 XzXxjmfVs2cLZd3HsgN/QfNUC1J0KTGmswLl8jNe0V2zjEIR22UDvQK4YwO6Nc61byFjlXd8TjlYGxf5lPrtYx4+zSVyHIit0zhxwPjpwX3glZAmR/0fNHz0kMPi5+jIzbYEBBbjXpqfvmC8pmsic+ccSzdm9dUaKtR5K0ckRj80AgXZAOVkUKAiC6CBDkVHM80170x6bOJarb1MNwlCy6GLVp88b4fwQ9XZD79Ya8l6YYqKa/L8nRvjrAc2zH5k8oeSUu2mhMU2saP8OzvYSxDpxg3lcSM11AYNu
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 4 Sept 2025 at 14:04, Haiyue Wang <haiyuewa@163.com> wrote:
>
> The commit ced17ee32a99 ("Revert "virtio: reject shm region if length is zero"")
> exposes the following DAX page fault bug (this fix the failure that getting shm
> region alway returns false because of zero length):
>
> The commit 21aa65bf82a7 ("mm: remove callers of pfn_t functionality") handles
> the DAX physical page address incorrectly: the removed macro 'phys_to_pfn_t()'
> should be replaced with 'PHYS_PFN()'.

Reviewed-by: Miklos Szeredi <mszeredi@redhat.com>

Christian, can you please pick this up?

Thanks,
Miklos

