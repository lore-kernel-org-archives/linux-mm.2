Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DF8C1CD8CB9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Jun 2026 09:55:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52D256B0093; Wed, 10 Jun 2026 05:55:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 503896B0095; Wed, 10 Jun 2026 05:55:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 441136B0096; Wed, 10 Jun 2026 05:55:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 361FA6B0093
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 05:55:46 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0399D120949
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:45 +0000 (UTC)
X-FDA: 84863546292.07.230955B
Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0EBA1140004
	for <linux-mm@kvack.org>; Wed, 10 Jun 2026 09:55:43 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGpfeFjm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781085344;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DXXf5kDNkZaZma579LeFr3+QRDi52FtRCi+F8Ah0BJ0=;
	b=HQ7B/hGfyuoTvZdMwvRctVrbXVHtENZIsXe++1Ez4WoLrB0xVHEftPnRVZXvYwrvEWycaV
	XauUMAdK0IECGFt95eSccvK3MBcMRTeSHd4syR6AY4UBSkaLblXd79fsDkxTH5H8CGgmd8
	aYowoGwV/aUHszRc+f74s3XMT+PGh4k=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=kGpfeFjm;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf26.hostedemail.com: domain of david.laight.linux@gmail.com designates 209.85.128.46 as permitted sender) smtp.mailfrom=david.laight.linux@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781085344;
	b=8Qo7bTZwjHa/qR9FaxKoWjGa3t87RnkOeBvknsj7uJ+LQNuGNygb0jzBeiOliswiRCIl+5
	aGHlPdkLSXrMjYQR8A2kt0J7dIOWqOHh5irtcAsG9HB/LlbAPGT8flawjFrfeNcnldESag
	WlMgsgfiTQ8tIcyWklcVhz6eZMN654k=
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490bc6a7958so58146145e9.1
        for <linux-mm@kvack.org>; Wed, 10 Jun 2026 02:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781085342; x=1781690142; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DXXf5kDNkZaZma579LeFr3+QRDi52FtRCi+F8Ah0BJ0=;
        b=kGpfeFjmKwz5R32zm46ukwPADIYjBSBqFfmuMpceDjkmr6IuLhznYdvvGJIEHToMHr
         4ztzYfdqLVrtEuOhFwsI5osUM7f1pp9V2u+e2u1/P7Akg5jtvxvFpxCSonfOnJzg+FmL
         hgpqGAoiUVYYNPA+3f1rLtuZhes3V/L9llfluYfdJiA6X5+DC4zrcl0G+a4zwD4M8mHx
         Z3n8RgymomUqipl6ZRhlEtn3bhr3YjTAC8yOcvsRwnFDy1wcZVzCqlEEJuCValXlaDpp
         zP384gPn/20sezN6fDePMfQGIM9RpYVWjBCSihfEhZXsrVfetyzj4gaxgfd04XMKPpgg
         E3KA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781085342; x=1781690142;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DXXf5kDNkZaZma579LeFr3+QRDi52FtRCi+F8Ah0BJ0=;
        b=h2diUQXz6BpkJiLfa4KZKzt8aAAS/1PBCM/ZiJlIPRkDsRpHEGyuJhzdgC1ZEHfSyS
         KoU2oqcfFVQT2J41uT6rpX2AX36Z7x6LvuIO1k7dYX1EbFAA+UONQWzMxcn9cYdVRgum
         LuAj1qlLA4lsvQtEACtKZbWw9CN4feSZHB8e7CiCJbPMMsZnFxstuy0RfsQzJc8TZVGm
         4LS4qEyQOjpEWPz7LsjtjRoxujlng4sY43ZnwazHZlEf4vhGo4wClZFVM00D46+zfqEE
         gwlF15c2TFk9VaGvU6g0hXzOrrx+kZUggjVm0opx/ONaln6Ed0/eKio6bJH04o+jYtHo
         heyQ==
X-Forwarded-Encrypted: i=1; AFNElJ8hyhW+k7F4lcGYgptOGQu7Aol7jF84jMM+XaRFSupJIMc2v2+uUs5GBjh7ojBblsypkSzvZPljDw==@kvack.org
X-Gm-Message-State: AOJu0YxGY11V8qxZhF2duMousdXYRkIJO5QZx+Bzct45+aqwX+2WcNKM
	Mm7DPBpf1Za2Yx7vcR0q14qBDO8DcXjKZ1IrIgbL28nR8Ncrrr14jAtg
X-Gm-Gg: Acq92OGyRnJtSFJwemrwVuqnwVoLSIbedRVb6bAy6D0BTaaZlTw5WBq3+iguzN4jeXN
	Nur/fBozfARrEIjCpaUMftowQZNRTiiJbXOT11Op4aK/F5u8ql4JE4+El4HTJTjFt8QcQW5VxrE
	X9dKBINyZSmnuZREcBBbIl1nJaQciWlGoFKqtaifqNNby6W2nMMLCnFd9QWBSmVxR8Oms84lEEh
	7eHc8dKJfnpA2MjE6XxjQfsliL7P5AZ1qe/toU8fIQDk3lAYejECkcU+7bdTDIW+N3jTMLZUwnk
	Q1DloMVK9/h5TimC7obVVxfgXQWOdJ3IS+42eO134ZC8foHxfCUNsfITsinvOikHvJXlBKa4Md4
	5O+7+p3RDNlMauSknuPUn88MTyr3jOKZtqK++LcJ6mxIU5c8UBYkpTh93mk0NjI6CTJw7s70xeQ
	vIADKkDNhfiegPGg13IDCPBu8tYctyxvSLvy/bsBNhC4Qy2DpjF6VzSdf3UtZ22R/8y7jRLUcaE
	mjoXVqCCw==
X-Received: by 2002:a05:600c:6096:b0:490:c1cb:48f4 with SMTP id 5b1f17b1804b1-490c2d038e8mr309043665e9.12.1781085342059;
        Wed, 10 Jun 2026 02:55:42 -0700 (PDT)
Received: from pumpkin (82-69-66-36.dsl.in-addr.zen.co.uk. [82.69.66.36])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490be1f69bcsm591850845e9.8.2026.06.10.02.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Jun 2026 02:55:41 -0700 (PDT)
Date: Wed, 10 Jun 2026 10:55:40 +0100
From: David Laight <david.laight.linux@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, luto@amacapital.net,
 safinaskar@gmail.com, akpm@linux-foundation.org, axboe@kernel.dk,
 brauner@kernel.org, david@kernel.org, dhowells@redhat.com,
 hch@infradead.org, jack@suse.cz, linux-api@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, miklos@szeredi.hu, netdev@vger.kernel.org,
 patches@lists.linux.dev, pfalcato@suse.de, viro@zeniv.linux.org.uk,
 willy@infradead.org
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260610105540.5901a5be@pumpkin>
In-Reply-To: <aijxfxXrWLCVqV6-@gondor.apana.org.au>
References: <CAHk-=wh5bFj1a7eaGp9sixDg3UXu7xUGfU=YJo+ckpGxGAyhXQ@mail.gmail.com>
	<aijxfxXrWLCVqV6-@gondor.apana.org.au>
X-Mailer: Claws Mail 4.1.1 (GTK 3.24.38; arm-unknown-linux-gnueabihf)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspam-User: 
X-Stat-Signature: u5ktej818qbe4ekfbdi8fwd9bob8rdx4
X-Rspamd-Queue-Id: 0EBA1140004
X-HE-Tag: 1781085343-201483
X-HE-Meta: U2FsdGVkX185HwQw5t5EFKK7QTi+R1U1RlBpEwee3mLBF/lXOs/PyCQJdxcDhs8McmDDqVTlIWNeByW2cYe2sh8odQ/WV86cH4gUW+8qqXZNkHULYY7L8DdQDkRUmarjki3hVmiWxknupfIWeDNxN9TZvXQCNJ9DfzDKrjCxP/o1XKCmqPpbr2wsN8jcV+JpWJwnPXEghbUsDiKn4xTCFjqqb5RTcLHUKkNvyizEg8rCHX+WZFJmWquq15abQKHVe6rRZWQSJPdQjvLEVECsXr72B6rYYkSmoGUmyIBRbps7dsx+hViY1vcMuOWMATIwFAS6VDQKb3oLDECspkKeDNqBe/nOq4WpL6FutX0QkBHQaWuo9KeKMEeI0DyZhD4mkouQYdW7mm5UuFUfMYHfXMSnw2cz3CLrAizs9ZjpqM7LKNCs23rwNCzZf2/+KzpKtyTbPlpLCfat0D/q3uoZ8bEu+7gOVDOHXSVF3+LFrEMNzQzkwN9tyJ9mkcx+chBPkg+KFC7HTUvsD0LCPYheybQt/4LZuZ2Iw+BuvDzYti1Y5/w7EiXJBBJI1bVFpATbBPmbcEYzpZq1o4nNP6CF76xVR7R5Rh3sYc3Si6e2vSGU3N5SbnNOLwaqKjzFm+31PDnN4r1Mkvq0WIAselgTz1ttTIlqi9E5SFmcHacrD819NcF/UyJQaMSSRNCB6sGhvbflBuvvBFtVx/LJJuT1XznycOpNBp99l6IJS3WcSN4HNMFGW6vmNAw1700DoFs/zK1sYridEMRtpYzlLjyZYsEYGFyBRpt4aNu2lIzNyXcD3L2WugEjAfEes6zJkmRQfseNRIm+ZkObPrfZfmMentA3JocNZjbXyj7/LGT633kWkC7oXhDnfK/hPN+wXxCFyZgyKI3o/PHG6x/0X1qMXciuzghGSBF5nK/451SfZJQQ7vYFa0zjv1OxOB9f/gL1iRQ0V6cre7NRXw45xMF
 cn91dghn
 dyTNDzQTwjX3hmaQq13gl59hBD0yDO4q1rKuQq9cugvUGe5nwTq2c7bbuS1AGQNFtrlaZ/CLO/jAwGh93zIU+AYBt/TEZc70nryJNyZMzAtyYigS2jv+/G3UCG5WICkUwpA1C6Xhn1bhxq7LrfC5WwcEfrHYVeufAPxaGM+m6zzPGe6QNdL+IPzBnoVhJA3oy9eWjKhYJpJCdpXoHnT9L+R2UV0Q1gRyU93vBbtkueL1f6ZdK+VCg8BglXjGmgNqphPG1bqLw574vAButhYQUKgePyPq8VD8PRfY9PslBvion1Vk+78BBACLcVIW04MhVaXuaJVO8u7LHu79XzRiCSp3hEq2pU/h990ygNRVpCVOayILgMXajdcpi0LcCziGOvhW7yHd+M+5NtqvnTsX64jiGQOhNCL7bKOeT/8ERHY5PA0EAT+ARKV0vmwcTipdHSk+lxpBcB8kh1QaeYm+SF4To3EsbGL3RcNqEhDyu17e7Z+hi/lVcHhyKUxFxRr6oklo22iDvaUEOtslum/FKsgWf4qdOBUTy9qMww1YfGjtjasRny3hC1CD8WrngHQvHKCiY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 10 Jun 2026 13:09:19 +0800
Herbert Xu <herbert@gondor.apana.org.au> wrote:

> Linus Torvalds <torvalds@linux-foundation.org> wrote:
> >
> > Because I think splice() is a *cool* feature. It was always *clever*.
> > I just don't think it's worth the pain it has cause.
> > 
> > And it's been around for a long long time, and after more than two
> > decades it's still most definitely not _widely_ used.  
> 
> A couple of years ago I used tee(2) in dash(1) so that we could
> avoid reading the input line byte-by-byte which is what every other
> shell does in order to pass the rest of stdin to the executed
> command.

The shell just needs something like MSG_PEEK to do a non-consuming
read from a pipe.
(Without the strange behaviour of a second offset.)

That would be simple and could have been implemented 40 years ago.

-- David

> 
> https://git.kernel.org/pub/scm/utils/dash/dash.git/commit/?id=44b15ea09a9ee5872cf477e4ffc6b42ef37d1e46
> 
> It's definitely niche but made a huge performance difference to
> this rather common scenario:
> 
> echo 'command
> ...
> rest of stdin' | sh
> 
> I didn't even know tee(2) prior to this, even though it was added
> way back.
> 
> Thanks,


