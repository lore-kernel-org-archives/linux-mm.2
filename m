Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0F60CD6E55
	for <linux-mm@archiver.kernel.org>; Wed,  3 Jun 2026 22:49:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 210226B0005; Wed,  3 Jun 2026 18:49:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1C1126B0088; Wed,  3 Jun 2026 18:49:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0B0056B0092; Wed,  3 Jun 2026 18:49:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EB5646B0005
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 18:49:42 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8CC674061D
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:49:42 +0000 (UTC)
X-FDA: 84840095004.20.A559BCD
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf29.hostedemail.com (Postfix) with ESMTP id 7B97C120003
	for <linux-mm@kvack.org>; Wed,  3 Jun 2026 22:49:40 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=XcUZUF7+;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.54 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780526980;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
	b=KbkkHtRUnJTE336uMmsAU9BB2Xxna69vjJPRTXijv3XejQ1hsYijNIqPaztgEcThoCCv22
	p6T1mqXocQLgfb6OTsuwIksXh1SrpHNAYBWvej9vY/m3rSjNBbtzX1EnPCrEgmbJCt1VN5
	tLPayLk6XhUu5lXfTWvXKpKDqo7J594=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=amacapital-net.20251104.gappssmtp.com header.s=20251104 header.b=XcUZUF7+;
	dmarc=none;
	spf=pass (imf29.hostedemail.com: domain of luto@amacapital.net designates 209.85.167.54 as permitted sender) smtp.mailfrom=luto@amacapital.net;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1780526980;
	b=aRbJwDwixWlEL2kT19i6wpPFazVWlG4ScwnUsds6BLpRbg+6HehGV08dW3TglNkwS66Xkw
	8CL4Axiqhd9yc2RU1C5MmgQlQ71ylt+JGOTugnUsH/sTZ26feKzLIfPfPXN5kqbQ8sC99I
	8S6exJV/uAwO69/pHmnn0KmWeW+4JI4=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5aa4bb157c6so13911e87.3
        for <linux-mm@kvack.org>; Wed, 03 Jun 2026 15:49:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780526979; cv=none;
        d=google.com; s=arc-20240605;
        b=EjcebWtvaTA5AJfkJHTtw070wZNOWhxciYgKJlCSi2Py7ZOeP4wLRG/JEn6CCK/aKu
         rDEKmGPelpxPjKgwGKavNT4xt8qjfaNnJjcw1UoWtHPsXS3JaXmNLxNk+9QgVLdl6JXs
         TNHIlfUN/mbm0Fca1PB9pkjRWolZrOIq1lC5Bcy91Sq8Dnad88x38o6HrkvZ+bjVblkB
         jbWR0aOp68KR581RG1EklckIhwnffebSCzKXZ5NMmwRf374U2sAtd3z439r7XJozVDdO
         XkflB3dskhnNz4byRxYwCin9IQBT32m6yOsMB3Wc033LoFR1w5tISFh38uJ5LUufAnNC
         P+vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        fh=YbDqBQO67tSTng/fWOTD1keP2NV0X/WFkzsAGe+0aiU=;
        b=idVV1wv9byGESfYImr2svO9rV5U3dS2CeO4VRnU/rNwMKZR6hOdd8pLsftWMUPeYqP
         EWp7E3pjQaZbftC3LuRI98skS5ROvnZbQaOpAPyRyAd6tORQPjmeIaavbW6l5TeqhFwk
         h5AhjjmXN4ZFB2ccIQu/u3KO38v0kCeHUWdPocLht4dGfOCroYYxAZz1LRYytGYBhW9V
         g44v/evwMPcifLZHOijDXbmDi2BxQu9wHT8zCzzCDGwG1Wvfx2exgduyg6C6K1bDnvEn
         nDoLMCSmiSIUYLOcCQQibTmeedW8IQ9JErjt5k1beiQWlGcIW4aA2xBUzaTJrYnYIkQe
         w2zw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=amacapital-net.20251104.gappssmtp.com; s=20251104; t=1780526979; x=1781131779; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        b=XcUZUF7++9bHFN0w/ebL34f54oLMnafe1R5pLSrTyHNNYhvomSimQX/xvSdhM/tikz
         fHOcz5ZeyTM2CddXRDQcjL/E/0xEmoJ07H6yKVFdPtFS/JNpqK8dZGFK7NasKfffTihH
         LN/sd7lQuXHhXnlk1saZYnhYYMGKH9MXVIZmz7JzySIONvzEysLz07Di1aWhzmhHl/Yd
         zo+VsitnjgTtMebwXB0b+jW8/FL3E/PwEStz5tHGLcBFH67qDZNqoUP3QHanrkSqktww
         C6H/K94osRYRNMFimpndooJOqGS8n5E6GWjkAavt3wqRmYg/c1ACwGEzBCSbVzvKQm58
         vknw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780526979; x=1781131779;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nThpP6AT70OYHi5mSxqfquLQYax1sVYjIai5D2em8kM=;
        b=nOja6m74lsBnkXtrXB7KQnWySLd9nvOxORaaVTZPYKy3JS/Xxc1fcaX9g4xL7w671s
         hFt++dB6rvPnYkSuxp4mrGSYwCYBEwZcPmHqFsJ6lSOu6+jJjgz9DvzFMd7XAojVRcsD
         2bNPB5Mq0IJVtph/RP/LhAqdYUufmK6enyiN9pf1fZzScDLhIOUiyzHNiH7VgsJa6v/f
         qZTFwOYD08A71waTqcz1ekWf/ZaQ3Ucc3KXVs9NNynUICsNayS5KTXCWwh/CHGphtShn
         yM+lDN8P1cU6wC+FjBUqs5YMOdRqrNkx8PWVhhYKpZA/KsZc86Qfrx3ALAKrMC/fWZNy
         sWGg==
X-Forwarded-Encrypted: i=1; AFNElJ9wG5xUNh/90PD5ssVvG4ONtPdWIVMCkjRvcH5qFgbfRbGjG0yFY/iCEMD6qcJtpMOkoSJceYxgpg==@kvack.org
X-Gm-Message-State: AOJu0Yyn4GKnLrWLvlBwLqXgyXS8xz3Kmq+AFW2mxmsgp5suIxwgSBKz
	A+/IXL46B7t89dHeLPTeed7ROMMPjn7cShVx/DBTxs4m4YINIsN54k1knWP1ZmKeB93WG7BV43J
	wpuZrgBdoBub+CZ/LVv3+g0KYHQWCH+fdYUzQm9Uu
X-Gm-Gg: Acq92OG939+7b8YHG/NVheqePjGjCn5s1WyTjczROCngTrqeBDaKVy9ZnMVIvWc/Lm5
	CkQS67UhXUMfb0xOcwIzIb03kiSqm7TFW/84b2sIwmCXMdh2Fe87hT06wqz+W6I6etwcOQhTF12
	hODOm2rUt54wuYJP0RtHTVb3mIAjCDuVFghmkR6VhWhwt7rveHPNp3Qw8/X6bgHhQ7gfCcRfJH7
	wg85C/SZFj+MgLyStjmGMN8rBC5Dkg5+vejGXuv0q+y2dLqOBOgBKOvlBNqscb02fmSKUdQ7n/r
	fRVRRCFRQFKkW8K85n0=
X-Received: by 2002:a05:6512:a88:b0:5aa:7126:c661 with SMTP id
 2adb3069b0e04-5aa7c06347emr1703733e87.7.1780526978614; Wed, 03 Jun 2026
 15:49:38 -0700 (PDT)
MIME-Version: 1.0
References: <CALCETrW3XcNLuB1Y6PSkxQDSK2o+=EB2AAd25SjWQqcJemwnbw@mail.gmail.com>
 <20260603224311.834796-1-safinaskar@gmail.com>
In-Reply-To: <20260603224311.834796-1-safinaskar@gmail.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Wed, 3 Jun 2026 15:49:26 -0700
X-Gm-Features: AVHnY4LigDaMGEZAFdtnNoXIyXd96f1pywv43JDsz9J-Er1-wYhHVKm162Sc_xY
Message-ID: <CALCETrU94ja56CA5CRtXrm1v_7gBaPUNOHKQzS=JNF9JZ7Fznw@mail.gmail.com>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for preadv2/pwritev2
To: Askar Safin <safinaskar@gmail.com>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, brauner@kernel.org, 
	david@kernel.org, dhowells@redhat.com, hch@infradead.org, jack@suse.cz, 
	linux-api@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, miklos@szeredi.hu, 
	netdev@vger.kernel.org, patches@lists.linux.dev, pfalcato@suse.de, 
	torvalds@linux-foundation.org, viro@zeniv.linux.org.uk, willy@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 7B97C120003
X-Rspam-User: 
X-Stat-Signature: datqj6d1sw8ohudkujtjwm9h9ftcdhte
X-Rspamd-Server: rspam09
X-HE-Tag: 1780526980-368939
X-HE-Meta: U2FsdGVkX18y3AYICQnU1NHyyX/Rg1gKzWBkFSKQ0bAF3bJaE4MXfeIYYEj60PkGQ3kWC+z00zUhtxXAa5AmCkbhBWGV79cx1jtKNgr1IzhLoWIIgFG79L+0Yraki8/+SWPwz0GYR2+/na/TQsA/9pwjsR1B5/k+uNxR8q4NCmS+ybmkTbWQkspi+Z/XQXXnmNiX2nD66VsPnGmgH5w9sedX5yEv+YdJPfTT7/xXAMo4gyEhuYBlCg7IfV6ZCTf8fPdYadHn46YGaJRtN2RMjxhHq5div4ijKS3iC47It2WPMYdfKvv9mwl57Q6OYTcQE1cJLCzBM8R/XulesJpoAR6xaL+70uA5Q+/8vDq+GzxGQ1/nnyXERjGnTeOM0HUgenuNjopXNLG6wbQSjw/ViQACRSpagh6Fm13/N9I/PjFWZmj7/v/OfhT226NeHQNAmkZwWplZanAbZJwBIXqZm/AgAY/AV28RscRbU4VmZ7uw15SXbUU8JX64bBbsjknx1wDO33d66qpFk9ptFPjXXmfOv3fggAXsYqzoKWcgaYDWsmhw70o9isYdVRijrKwOevdDab19nngJq20kNsuy2Hn33hMBpymgg9oxz1ExJ/xZ0nN+BT4Aa281ayIwA77RSWmp1VZe654LWvA072ci2yCP5i0EZhdHqDESXx4f6OyAntQHeWfNN079r2FjJAt/gouBkaMn3AKBwOUUbPsVP7cTD5CW61UKBYWt7Ve6xAlApIGfk+l8oUlcTBvPjr5cB/ytiZJvDt/1qphy8dlSehI8gfmNzOMZRQmy+dO8zIon1VhdcJ+JGKO2zxTr8tdtuHdmd9SDUwGj8mJQ5OdgtMa2iAXddxH5rKILVoB8F+l4N+gZTveg0J2gk2DYDjMLkuE27OxpT6IPeIm7qtFTGzX9HcYAquC5BAEULmPbdOd5LN7l0Rmv6XAiwif/FYjB0yw7wmTer6hufLct4BB
 1RYuWq9d
 pQCT2WGohnBebYE33ZT5U42ACTCA/VYedAVM/+Vjs+cqahD3YRkwJ3a7Y83VsFGVkVA9qRmD9QBZZLslT8AMoCDHB515cOEvcbP/IV0NmY0AsMsuWjK08E7nTYcl1EfyL43xtU8Hl76oIXTYjMlb34bxyxq8bq+Z2DItv76fsW0AhxKUHbz/GLE65U3mn9utCuZgfZVmi+5ByrABVHAbC1H0+XMI+BAQGQL/nPNo5e8030ZPk4N29rocMtf3byUaEi7gzZvi1w2S1U2QVU2rWLIm2WXm3AZXRyS+b2DKdCeXTdBmbWO8kojnza/BkWKZECYxMsOqWG1AM1ZXS88elrdlDyojiVaVIhSJGlHNa8WTMbI4M8GEgUjDEll2jZuajSmzcggmVfv+RtL6EGlI+y49Z1O6EjvnycbnN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jun 3, 2026 at 3:43=E2=80=AFPM Askar Safin <safinaskar@gmail.com> w=
rote:
>
> Andy Lutomirski <luto@amacapital.net>:
> > Maybe we should keep an API that does an optimized copy, from one fd
> > to another, that can send from a file to the network with at most ONE
> > cpu-side copy.  Not aiming for zero like sendfile / splice.  Aiming
> > for one.
>
> Yes, this is what my hypothetical future patch will do.
>
> One copy from pagecache to pipe, and then network uses that buffer
> directly.
>
> > But splice_to_socket involves
> > MSG_SPLACE_PAGES, which I think is a part of the mess that you
> > dislike.  And the path where one does copy_splice_read and then
> > splice_to_socket has to be a bit complex because of tee and (I think)
> > because splice_to_socket cannot assume that the incoming data is just
> > ordinary unshared buffers.
>
> My future patch will provide new guarantee: pipe buffers are always
> stable, i. e. they will not be externally-modified.
>
> So hopefully network code will be adjusted to use this guarantee.
>
> But pipe buffers will not be "ordinary unshared buffers".
>
> They still may be shared with other things because of tee(2).
> (But they are still stable! They will not be randomly modified!)
>
> But network code can do "pipe_buf_try_steal" and thus ensure that
> these buffers are not shared with anything else.
>
> So, network code can be modified to use "pipe_buf_try_steal", and you
> will get "ordinary unshared buffers" exactly as you want. This will
> give you in total exactly one copy.
>
> Also: as well as I understand, previously, pipe_buf_try_steal was
> kind of lie. It may return true for buffers created via vmsplice with
> GIFT. (I did not check this, but I think so.) I. e. pipe_buf_try_steal wi=
ll
> return "true" in this case, but pages are still shared! But, thanks to my
> vmsplice patchset (which is already applied), this is no longer true!
> So now pipe_buf_try_steal is absolutely safe to use!
>
> Finally, we can degrade tee(2) to copy, and hopefully this will
> allow us to always be sure that pipe buffers are not shared with anything=
.
> This is possible future direction.

I'm a bit nervous that, if I've read the code correctly (a big if),
then iscsi and nvme will still send *shared* buffers via
MSG_SPLICE_PAGES, but that normal user code will not be able to do
this, and that something will bitrot.

