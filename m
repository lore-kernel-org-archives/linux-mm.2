Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CDF1F8A16C
	for <linux-mm@archiver.kernel.org>; Thu, 16 Apr 2026 12:12:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B6F36B0005; Thu, 16 Apr 2026 08:12:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 468176B0089; Thu, 16 Apr 2026 08:12:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 356F76B008A; Thu, 16 Apr 2026 08:12:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1FFAE6B0005
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 08:12:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8DCCEBB77F
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:12:52 +0000 (UTC)
X-FDA: 84664307784.01.D1AE24A
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2583F40015
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 12:12:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=do1uEFxp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.219.43 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776341570;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xs4hGlZiJqAV9QCGrkSslLomiSfE5gcr4xqzLhglwS4=;
	b=BGixrj7cvatJ+DyzGk1sMp/1WFXHbLuaNrF8wiXyiWJ4yOYpROzCm90XcsxDJ0SP5u3Y5Z
	FY58+7Y9rW75z9cWcZPwuLY72VWGYaCTamI879PdM2JHYA+PkV5J2BHg+XtCyp5xfhvMe3
	z7secTs+RSqye/yeOSkNVXtxw8mImog=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776341570; a=rsa-sha256;
	cv=pass;
	b=blCJfVFzOK5ovs5z79yGnMtIuW8eOEagJsCV32xe2FoO072nxbbIlbX3t2wRE3UtV4MZOq
	PGFGvVGULJO8lvvm+k2qU8dm8aJrHRa5G/dsd11Uo68RNF3L8CNoQCFaDQ1MMC0kigX2PR
	We5kJgZGLwCEGJWkkIS16hccGai3ow8=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=szeredi.hu header.s=google header.b=do1uEFxp;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf27.hostedemail.com: domain of miklos@szeredi.hu designates 209.85.219.43 as permitted sender) smtp.mailfrom=miklos@szeredi.hu;
	dmarc=pass (policy=quarantine) header.from=szeredi.hu
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a016799d2cso85057866d6.1
        for <linux-mm@kvack.org>; Thu, 16 Apr 2026 05:12:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776341569; cv=none;
        d=google.com; s=arc-20240605;
        b=CcGnM6dY0gIgDBy5V6fyUWDHEj4xNypZmQraUsyOTceCPBt2BsH33muTDK/nsbq1cJ
         AALWhxEHzRwvx86xVdt3MqBMc9cTsTocm522umKfx1NBQb9htIQcLcQnCHVhpXe1QAZI
         YAONHmFEAD9nQT8L61v9BxhywHj5LT0BLaF5o4L5WwukSQnPfQ/h+iZLfripZPt2e6i7
         5c6dT4bE3ZPuaqGU33zYQI6Qu4wr8cq8PWZwFhm75LPSxgAknl0bslShp85OyDwN6Vu+
         UdA0mtNltldUCV1xTVlGqcOcTf8DTKjzPsrx6SoYOJiDp/dfCDTLNfo9nMP9LBSQwoK6
         ryrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=xs4hGlZiJqAV9QCGrkSslLomiSfE5gcr4xqzLhglwS4=;
        fh=Tr+yDhr4X3nfVZoREwn3gm1dB66/BUqH+Qg2Qk6RamI=;
        b=lySiErLQpK4cNq+UXUaMKqlOx6LwHCP+8zUvzZmH8j+b6bly1Lrao4YD7VqwkOsCa7
         fnsnFqI1FCeu348Aa2vJeQCbpos8tE2OombGbMgzbVVN21EfQj84KLirL45jKQAHeroU
         XWbPXd2/AUSdWo4OqKSadmeELY0mcz//XynKi/5dkXsU2HuEN1O2Fj8gLLxpGXHiuHbF
         Xun9uH0d+gjd5MLxc7/ZGOTpS1Cdm3wVzeLZeWJ1vJOWiTHygUBSuDmo54fC999kaXMo
         3kL3FRipuYUaxN5L6maOnqDUKfiN+uSczfy9KTlFXrld6b7BxLHQNw/GxPVzHV0WcWZd
         1RKA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=szeredi.hu; s=google; t=1776341569; x=1776946369; darn=kvack.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=xs4hGlZiJqAV9QCGrkSslLomiSfE5gcr4xqzLhglwS4=;
        b=do1uEFxpqUs7pgKiI3ee0NX7A+CXZzVNLyuEa536Zc904FaSE7feSFOTE2obxQ7tc+
         fHgmUEdFzFm/pgCu+39d3txrBY0MPeazUyHnlSvkJaDkQYXeEqf9+o7pi7rBfdYQRoN/
         OHDa0sJrVRKBcx9PRIm2/hS6RO97FIKEnuS3I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776341569; x=1776946369;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xs4hGlZiJqAV9QCGrkSslLomiSfE5gcr4xqzLhglwS4=;
        b=rvO+I79wX2fNrLWIaB5ccJMgaetbIbOyzEobN5EkiPPezx+Uja6Duvb+mDrpj6tKPf
         Z9P9fFfaoWsd4+vSEG/dEm+knyCmv1/lp9cJuNssbt6rysrx7hhz48+rV7ZN9woQ9ngv
         R0N7xQHd4dyk+O/c2uG9zUdclWnc56b7IKvcl9EuSmkZQzXXuuKHk+NHse5xQeKAhH9B
         rVw+Ltzg3CXDySwpwwpy0jctn3fIR8M216eqdpemuDwcQrogY6HQY4kZgCfE0ooEA5yD
         vuqhHls3KQ5lCeYtClqgA1qXsi9SIBUxZF4mME/HvfvBmJ5sNz3qTsypJDHxKHNGU6df
         ObYg==
X-Forwarded-Encrypted: i=1; AFNElJ97TOVja7cSQhwoFmty8nmHzJk8vyjtvjIXxzCZM31DL71KuMiLHUl6fkyPlecqiID3W28i4g4m+Q==@kvack.org
X-Gm-Message-State: AOJu0YwkEwxVxzXv28qsl9TTbPEfBCRQO7qUR3/L4w03mP7uNaoQzVBu
	I4jNNFu2wRXmAVyh8SgIR39WLhpFt/zt2BXnNI2fM+3KH+uyQlHga1jml6hsAn68ClV95/LKl77
	gunNsxa+zEGmO1FH3yWlYBnbNX8xxzBp3lPJDZgzuHg==
X-Gm-Gg: AeBDieunZzGwSxebEENq7ViOqPLMnPYPbGIa5B6qKydFb3Z2W/vAbhMP+WSa9HDw1OG
	6yxkHUiUR3Ghjpkr/qVxyFWKIRpepB8mNCaDV4n9/mh93/Bic60ohH8JmnAnuuup02uk+E9/PBW
	OwdlyiaFvd3N68dBV0zo1vqm5zg954Q3ZULPvV1v4d6rHZicYZ9RepBhwjWEoc7r1MMea90JfFR
	g48EtEWoQy/XyzWY2a8lhjQ3LzQRb3rAiBjSG5BpXVCvb8r0KLbTaG0lNAJwIlPvEr0bOnRUrf/
	qOh1EVByNoW1aBALxBSIOO98dtkLGJBqSUQT
X-Received: by 2002:ad4:5e85:0:b0:8ac:bb62:fe5b with SMTP id
 6a1803df08f44-8acbb630feemr194285446d6.12.1776341569011; Thu, 16 Apr 2026
 05:12:49 -0700 (PDT)
MIME-Version: 1.0
References: <898a4e10-6193-4671-b3b1-7c7bc562a671@fmap.me> <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
In-Reply-To: <CAOQ4uxjoS-PvnZ2poh0bx0C6ocTYwuEpfV0q5md15SjS620OMg@mail.gmail.com>
From: Miklos Szeredi <miklos@szeredi.hu>
Date: Thu, 16 Apr 2026 14:12:37 +0200
X-Gm-Features: AQROBzBX4a19crGk_XkETxKLhmewGXqK0FtKuy_vUEQL4x7MLk1p9L_bODNm4ek
Message-ID: <CAJfpegvxF7F+XKFKokSH4eOgCA0V2RNm6B54MS9nr9wG=U66OA@mail.gmail.com>
Subject: Re: [fuse-devel] Debugging a stale kernel cache during file growth
To: Matthew Wilcox <willy@infradead.org>
Cc: Nikolay Amiantov <ab@fmap.me>, fuse-devel@lists.sourceforge.net, 
	linux-fsdevel <linux-fsdevel@vger.kernel.org>, Amir Goldstein <amir73il@gmail.com>, 
	fuse-devel@lists.linux.dev, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 8dfnbdfg96sz161jh9xsndi9176p5aen
X-Rspam-User: 
X-Rspamd-Queue-Id: 2583F40015
X-Rspamd-Server: rspam05
X-HE-Tag: 1776341570-296191
X-HE-Meta: U2FsdGVkX18usZ1onVMDWtwTBYt/FL+zd++C+I6+vVs1oYgl/KpypbYVcIwAF7W+n6VuL8X79TV6mzw6BC+UcLQfJUqOyGqDnylViuzLDhXbf2DoNkZWQNC0gzZpu2C96WUplZf8duHbUkkY09omraCuArkLM6FBAdu/gt5OZ9+EN5mZl5wsdUpOTWJ7bINMoWbA88HRl7kZhC59edGPcBpb1yQO8JdhSFzfZW1pDIhlm626besdFtOhKyAw5bs5gHU8gxv9qaFF+/+6jlp4xzA4ry1DhLhd3co/ugmrt4l+J5aruosqS3Y1c2Mx1sGFfquXpqdSQdPX1ofDwUHZPbKUyKASnGUy4O7UZc5+MwaK/5rakoaqB9/qpUgX+vJeued8A/P+IwMucaAHPxIn5Q/LGyQGud2rGok/giwr2lVPFpgAYGqtfzLzE8BD68niYPqUG0Wm0yTyQ4Pm51X7OZ3UdReHOktcjkN9mw2V/RJjBrn2AVkyiQ0KRXrb24hF+evOlh2Vg3SqjrsJ3FwiupnrWX51rAo/onwE3ng7iTySDD82dYAg3MOR+qnXZor+pc6qrFLSBzvOx/qkGehIo954dnp6uOFD62NGzHU/MQPajMvPe6BxQwdLkIGbq6r5cz68/t22RDctOOviaLfehmn5b3nFTWTeDk76q/+lyhD0WoX/z+ceBZC/5JpfzAjItLhAkJt/YIrM9gsNUG3gEgY6H3FwEqzEitHhtecZJt9PN7hCmQYiOCSi1JDy/AFHSWmvo7aAvScNFPRvgkDuR20NaInYhYi87Y9BQ52SK521xEuP/tJPA8+XwJkeKNOiTI0AdJOy4BOXCqVxXp8ndn5F+X7sDw/i1KOVBs9zmo4VqfUflcOjzTHjp6bQLXnQ0t0CdW5TrOOAFuIjDodXosO3qMZGpBFXQe9jPvVzaAuC+tYO3icQrJktYyXoGSlAKO35skSOGg0xrJa7y5G
 hapyE3Bv
 wdxovhyCYujgrI6ubb5T/RsxqZUggeTtGTRN1yxEFF5nftOVsgmjnB0eny4xC4TbJzgecR1qj+dmS/lrsRR30ynHw+YZUmr9hbsK8axlWbQPf4TNKQCv/60pzQVSV/WxUvVpfuqxnKncIPLG58oKtSjujzyUGTtk9XWzlyAZ+1DAL8ysdNCGBWNBxfNyWsz+zQjZo+/cB7Q/4BeWqokkRVFwOCgX3G3braOxGBcH+8KivNTijuQg55swLFOk0YWbbBo+Z5raRkRjy/NE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 16 Apr 2026 at 09:24, Amir Goldstein <amir73il@gmail.com> wrote:

> > I've recently encountered a weird issue with JuiceFS [1], a network FS
> > which uses FUSE. tl;dr: when a file was being slowly appended, a reader
> > of the same file on another host would periodically read a block of zero
> > bytes instead of the actual data.

Thanks for the report.

I wonder if we could clear PG_uptodate on the page which had its zero
bytes exposed by the i_size increase?

Willy?

Thanks,
Miklos

