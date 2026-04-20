Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 41F24F588E4
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 14:57:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E3726B0089; Mon, 20 Apr 2026 10:57:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 393B96B008A; Mon, 20 Apr 2026 10:57:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D15B6B008C; Mon, 20 Apr 2026 10:57:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1E8526B0089
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 10:57:39 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id D5A62140555
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:57:38 +0000 (UTC)
X-FDA: 84679238196.16.46DFEC0
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf02.hostedemail.com (Postfix) with ESMTP id 023F480012
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 14:57:36 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PFCQv7UY;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776697057; a=rsa-sha256;
	cv=none;
	b=GHY6kuNaQHQCPuLpCAfu4GfvJ05MMNDU36h7j0YY1sjYyB+XYfgycnxLpel5rMe8B08A/u
	hv9QXXHcPOHSQqta4ImyISvWjAqBhxzHUzVY7GKZgyUjByb9SnUX42xl2iam9Ruv4IpDuF
	n5XwyQw/vBWdD9IK9tLaLxBZqquZ6pA=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=PFCQv7UY;
	spf=pass (imf02.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.160.177 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776697057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uImRWdptQ584i7GlHtwZAdnn1w2zI7sMRH2fpFKWYnM=;
	b=OCfajdN8r+/RfXtbeZb50ZagpjjEBPwXptvn13IQ1cABxO/TrqJDw0W5ywHr2h158krLqN
	N1trsXXq6vg0G5M29NndCJnXqSPJTA1JShv3zCFMyzp8EqDpZotHnfXB45l+8g16JG3iq5
	sIw5vSG5V0fGTWNphiqQL7/b5Oontns=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-50335b926c2so25268761cf.2
        for <linux-mm@kvack.org>; Mon, 20 Apr 2026 07:57:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1776697056; x=1777301856; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uImRWdptQ584i7GlHtwZAdnn1w2zI7sMRH2fpFKWYnM=;
        b=PFCQv7UYoTTF4FggTC95jXdg7OyVIr9qpCUC/eJqFwtSNECuLEoE9MydyJWxfpteyu
         Ot53VA1ilVR4a3YAKm1pzvUmHUJoMsIBhrSVMciFcsQkN0CYBj4nR9n4Ha4V4Hwfj0vQ
         GgH7Yg/aTaC7j07f6vnGqKIYZmOhWwkdbUYnv6tMcIzDW/quGRYaAV6Lao4q7q7RQU1B
         5ClAs8zi1iXTL/FWsTXh9rBj9R6z1lKA8BqzBZu6IhZnYUuDZwwq0Mw7MGyGBxJcN95m
         xz5Z9jVsVHxz8Ofe2jiL0qCF8iCkJwNEZb2R7xdXodVcDS4l2vXFlBzu8xWzjKaNsYFS
         4XwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776697056; x=1777301856;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uImRWdptQ584i7GlHtwZAdnn1w2zI7sMRH2fpFKWYnM=;
        b=iCKHYQveEktU/Ew6M2Wi26W4NTfApJWhEZhD1fUkn/fixfK3u5jPjrLCx0fP5ndBp+
         p4R0fa17mxBiRp+DYLMSxaNpvtb6imXJJ9de7roaaodjhv8uOi4i7U2ZIoj/RoybzN83
         jMyXwzAgTccQXgxyIO0JNchKEQwt/s+PrR5h8IXELRRG3ka4JPYcMc1JlIO3qF3Mr3Dq
         FtW5uJy25irph0HIfJ5rVhgnGDKe8E5NpTjW7WCYB+ftoOgxrsLcE/KP9PUhE/scjc74
         uIJNDRvyvWJ9v+05RGANIppz0AIzbr8l/jKo2MZkKEA+yKvSmlVIdF5Be7eYE+4cBVy4
         UhxQ==
X-Forwarded-Encrypted: i=1; AFNElJ9JiNsUjz/P7Sq6WkqUeU66Ww8mpqUwCyqfXWFEt0S/kuwFdO1ks2eNRHD7YkIml04haf10iiaXkg==@kvack.org
X-Gm-Message-State: AOJu0YwDuvgZlsWbTQ0k8Y/phsSrJvTFtf/4LUMWm9Qm8BW2gCSnc+NS
	/0ZjyYYwwn+5Ng3YMME2FTwQJnEf3XkxM3heQ1CBPV5pnNNZCb8sk4FCKloyIBAcEUM=
X-Gm-Gg: AeBDievP0kQeF1UL0UVX8P6WaD2ehE49lXseqGbOwG/f7hJ+fw9tSZ/zDhlehMbc2tT
	46pI2HTb4avs8qX8ZYh57S+NhJaJZe9ARzeGlo64RrXz1BVX5UOcRLvSDKFkAqMr/LLsLSqCKxf
	E5yr/3f6U2VBN0XfX/hyBE2a8I/pAVm28NriiU63Karm3sudiw3fRrR29VRTUFcycF6Y4NBY5uQ
	s7Bup8VKr1ypYy7BE7lS6Ppkm5hBJXuPrtKSoY9gJS5JbhgxVfsUxmpncRMIXuA/nXzoIbwnux2
	ouuXcZYXwIozge2HKNHUA+xtOGensieyEX0a2S6o1rKKPvMBo9kNk1uW/yqjrHDOHWE6h7NelA7
	3/VnZKj83KKWL6rPr9FgdshGbpeD3vn3kMJexL9rX7z0GR26VOwpStjjYw0ZqmNtCkbGX6zUFJD
	/2xI+p5DUjNeEwn0NAe5oyeGM8j2Mp766O8/M3LFQVqpYKWEw2Z72vzAMbNyQT
X-Received: by 2002:a05:622a:4c14:b0:50d:9c1f:bbe3 with SMTP id d75a77b69052e-50e36be3a8amr203453451cf.16.1776697055992;
        Mon, 20 Apr 2026 07:57:35 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50fafe9674csm1837191cf.3.2026.04.20.07.57.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2026 07:57:35 -0700 (PDT)
Date: Mon, 20 Apr 2026 14:57:34 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Luca Boccassi <luca.boccassi@gmail.com>
Cc: Christian Brauner <brauner@kernel.org>, linux-mm@kvack.org, 
	kexec@lists.infradead.org, graf@amazon.com, rppt@kernel.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/6] liveupdate: add LUO_SESSION_MAGIC magic inode type
Message-ID: <2furrcrld62f4l4vejskwhzzsj4wxgdt2wmrujlfqnf7ypgkny@yzzftym3vggy>
References: <20260418163358.2304490-1-luca.boccassi@gmail.com>
 <20260418163358.2304490-4-luca.boccassi@gmail.com>
 <20260420-unbeeindruckt-besprach-910fd241c32e@brauner>
 <CAMw=ZnR0uVrHUNzNGu5BtZuSKDJAYmZGUX-HzSw7c4VnoeQgiA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMw=ZnR0uVrHUNzNGu5BtZuSKDJAYmZGUX-HzSw7c4VnoeQgiA@mail.gmail.com>
X-Rspamd-Queue-Id: 023F480012
X-Stat-Signature: ekp3ksu1qmnpzkq1jzy7n39ec8ddyxhx
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1776697056-861857
X-HE-Meta: U2FsdGVkX183OgXimS3p/r0bbjKYqFE78Ffk6EiXpcXNPccUNpetGk2EIOBKSe/wA6aSVC9LjVtxpmhcDtDY1UHnX2nrUdR6vckyeZkEb1KIB0L9+asdehDcY4dh/JUxk2Aan6/kiefM8bpWF3ahqdU5MPIRECHgJVfFe4J++V2QRlv2aMxWwcdd6lSaBtDP5US+gZFWG6JccBY+I+CpwMgM8m7ZJ32GaNJs+yunxlDjIW9HeLMEBIxRfDvqwfUvVC5TIXFovAqzCGevpztqz9am8k1q3YRoaipM5tduNPvhERiDhf3Z2hYUyKXAojS+3dQ1mXS831HLDCNBX//kdlT2RmaD2zHLakKgBu/biIoNA0QpdF6Oa0XMyD7QQd3EQWgwKLbp3scUOX1oyVzTpm7VexWWa9ojUcik2laR3MR4WHbwAK855TfjLd5HhgdRzzv6/FBuM0xaQxvqFpdV+VsEf7TvSBU2jkmROBq5rm0c9+Xml7Qp5HtlULAs29iCofvxbo41H9U5b9hoIUsrT+JpZK8XOOJ0MqpGZZGlGOa3SkVe2U2Yn/WmIfqTkNIcsPxab5ofXZVWGBZTHEKoMXAYzMcsyBX9MlA36INKEXgKCEKuhB1g9H9YudeChCnEReDqp5wZJQTsGb/j7kobIip6WkFFTzIpaVKmV8kI/a0kLaPPYxKyrkKnyiNX72pMjiDGPFwDHoP2qfeOShz0k7/IEo7zmRHHGBcQZHNxXJxBdf31+an1zj0+THjuMz5QpD/LDVZpyQyGPaM24tLyfUVRvc2bkintD8Wghh5q9ZzwJmKt8TgfhFYYM9E0dG22D3XLVi49nRGP8726mvFqdSri93gall8oUFrv7LsokYUBcIB1XDzz/BWGprq7+qOXNp/gcdwPK6V5ugipUFHxi6FuYRWT8I7R9UtvMcUxyFwOAKJrYe4pNHuq/X0KipOTpGlXP6MXfAnR66/JQPO
 T9rkwWgr
 qSNxQiXMa59caZMpRug3o/R12/9Hoc/Id+aVk6Buu/VbIt4FAQhwZuQ27tu2b9+jNifEROZaYCbeiHYZqn/E4Iq47tv1a0tWEU1a6oOUoqcUrNcfzGEGzwV6AwxdFg3MOj3xH15G+k5YMMOtfB27tny7h0dJT7JMqIYKDwfv+9t01CHrF+SgRZD9gGKGwia6krDkvIa+C7UTFF1vWtuoCBMhLOHdb0CSG/ZMIO6FIcvTR36g3BEZuTdOpKnoLIOHycU4mYQ8b6+tqKKV4IWbyPzxk5UnCtCBOmfpm6dV6+sUysdjZmSNKGiePvULE4kEPVmQbdyUgbWswRZMXAoW8/AbQ8R0Zjl/NPi66Z8c77kcN/poE6ANAS/BBl1B2Cl/FUJCdMWbzdRjZ4UE+5VRnGpQvxSWBTEz4Dt7lUi5tzphc/vHTD15NDYquiN+dpxAqfs/2pQnC1VoEWRp1vCkx86FnvL4oUwZfdqsK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-20 15:22, Luca Boccassi wrote:
> On Mon, 20 Apr 2026 at 13:26, Christian Brauner <brauner@kernel.org> wrote:
> >
> > On Sat, Apr 18, 2026 at 05:28:20PM +0100, luca.boccassi@gmail.com wrote:
> > > +}
> > > +
> > > +static const struct dentry_operations luo_session_dentry_operations = {
> > > +     .d_dname        = luo_session_dname,
> > > +};
> > > +
> > > +static int luo_session_init_fs_context(struct fs_context *fc)
> > > +{
> > > +     struct pseudo_fs_context *ctx;
> > > +
> > > +     ctx = init_pseudo(fc, LUO_SESSION_MAGIC);
> >
> > I'd just call that LUO_FS_MAGIC.
> 
> It's specific for the session fd, so I'd rather keep it as-is. Pasha
> what do you think?

I am OK with what Christian is proposing.

Luca, please wait before sending the new versions, lets discussion 
settle.

Pasha

