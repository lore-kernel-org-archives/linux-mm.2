Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83B67CAC598
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 20:37:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D80A98E006F; Wed, 17 Sep 2025 16:37:03 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D2FA88E006B; Wed, 17 Sep 2025 16:37:03 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C1E8C8E006F; Wed, 17 Sep 2025 16:37:03 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id ACD158E006B
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 16:37:03 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 84C505A34C
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:37:03 +0000 (UTC)
X-FDA: 83899901526.09.6505567
Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	by imf13.hostedemail.com (Postfix) with ESMTP id 47B352000F
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 20:37:01 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=blcAYM78;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758141421;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Chf7X+qGiFJJFnzlWxmYJPQYQ0EzCnC9UbWxIFQaqrI=;
	b=mumSwojHkzPY9ctKijN2qlqjirpuKZ9wZTdWbak6HokEwbL8AJS6mKVqKjH0/lKkk5KSxA
	8x3Nm19pSC1lQhc0tNTryvTmK3p406+jJAjZQ/Us/eVmOVXfaZ4oo6FqLS+FlOb7twFnK2
	cGBfF7E/+dJNl2VHn6r87RQAAkGzUQE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758141421; a=rsa-sha256;
	cv=none;
	b=Y26PWG9M7IYZkmqUEzYLaq0mnZVCiOj4DcY+c9114dkIuypgovfzilppqLIqs7doB6RL29
	eH6jCsPuk8ywbkFpJ8v5UHoZbZUdv3WWhJeufl5FvwcK3tKQPcc2FP2Uln3O9hKW+d2WQG
	yQgVHXr00tya5jyznGAtEEIWVEfQmlg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ionos.com header.s=google header.b=blcAYM78;
	spf=pass (imf13.hostedemail.com: domain of max.kellermann@ionos.com designates 209.85.218.46 as permitted sender) smtp.mailfrom=max.kellermann@ionos.com;
	dmarc=pass (policy=reject) header.from=ionos.com
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-afcb7ae31caso36459166b.3
        for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:37:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ionos.com; s=google; t=1758141420; x=1758746220; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Chf7X+qGiFJJFnzlWxmYJPQYQ0EzCnC9UbWxIFQaqrI=;
        b=blcAYM780ONAsZYn5cqn8x8S3BYnkQv0HD8EA60DFSyPauUPFbetIr/nadxRfNgbFg
         L06GQJtUDcW4G3xTf+eJGSeVykUYXUppMAF2Wyh89fueYHpyzfwuUsNVHUTd31vwubQP
         kqETduK6yH/qwG6hxy/Q+7u2oDkDuw5Gznp34kWjA91UktsdpIyXxhvi1G9OrAN8Os7q
         de5N3rDfWBx3DdczQJ9AdN2Cai4j562wzelrieYwt9Y1yUaKix0H3OkJ2p+3MTJJ6z0p
         z2Y81NWpBTYp5QT66x5pRPxv7afKfxMVgfyrJdmuCy6h4V6K43NMAxODTk1j0R6a0Z2R
         oE9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758141420; x=1758746220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Chf7X+qGiFJJFnzlWxmYJPQYQ0EzCnC9UbWxIFQaqrI=;
        b=bhEiUt3f7Q1fk2lorhxcScXKbxj/jjyeEJKTF7HEVSU3qGTZt2eBrLmvZVi5zICLUI
         fYAa5U0bOpEQndQqDT4dndqQPt+qNURgo55GoCTiK3wJL2T569BHMLnleIZINCklLq7R
         Hqf90IEt3PBuyvDNXJNovNdVWu8NkDG744RVV0Le+p44VYlm0veSW9Y6fuHmm5irw2oH
         qlKxTGMbr2mKNR4EaxoIh8bTNeZwJlUd5DhPXUruFz9HCx8ESb2Fa377zUq2sV33SK5D
         BsZv2J2EzKtf36jFIVtVFsQT5C1wim1r+r1oESdc9zVynmwodXLb5Z15PuJbc3fpd7a5
         eWCQ==
X-Forwarded-Encrypted: i=1; AJvYcCVxoFrpccxoATkh7YwZjzhNIUR/T0dGLIO67DlR5DFKljkzJFVUVX7eG1RzOxC6j0o0aq1KnABCtg==@kvack.org
X-Gm-Message-State: AOJu0Yy8dZY43Q2XgzM62o+gHSqZwvOhG2zXBImyiWRWoPUsQS4EbvmJ
	ymX+Qh/M6wxqirKGx62mXSHXszUm/b5AQ2WVGMBDjb6fw4/eY5xm2YDGsqKMOO8GP6hSnfXyIFL
	tDgWvatTAuQ0hwx/ORwo7ONzyd5Fm+5s27r2fHhP8Kg==
X-Gm-Gg: ASbGncvs2ezqnfM7rqg5aCOnNwd4XxaUD+uNCJZBWpq042wBhlTLGjtUs4//fvxR8D8
	Ry5wsLWEqqkrvJcZ7pwBjlEsaYGGNpNeVQEhr7FFJ2gbtY85QZBxWdNnLv6i52gezKSI0vyW2h3
	V3gdATD5VIJn1m0r8J0nXNZZ1e1cOJME4Os0asikTATrS9+bKI1QuYpuXcN+O2jg9zI1gphzm1e
	KZXbgYQFNHR30KZGqWonN0rpMyzuoOgSr0N
X-Google-Smtp-Source: AGHT+IGfptemIFohfTy+lGP+G94GDKuCT6cuywROwctnniSHmTHsaA0aWmc8jBz7sUxZychQu36GLP7/p/srVhhMhOs=
X-Received: by 2002:a17:907:dac:b0:afe:e1e3:36a2 with SMTP id
 a640c23a62f3a-b1bb6beec18mr411560666b.31.1758141419817; Wed, 17 Sep 2025
 13:36:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAKPOu+-QRTC_j15=Cc4YeU3TAcpQCrFWmBZcNxfnw1LndVzASg@mail.gmail.com>
 <4z3imll6zbzwqcyfl225xn3rc4mev6ppjnx5itmvznj2yormug@utk6twdablj3>
 <CAKPOu+--m8eppmF5+fofG=AKAMu5K_meF44UH4XiL8V3_X_rJg@mail.gmail.com>
 <CAGudoHEqNYWMqDiogc9Q_s9QMQHB6Rm_1dUzcC7B0GFBrqS=1g@mail.gmail.com>
 <20250917201408.GX39973@ZenIV> <CAGudoHFEE4nS_cWuc3xjmP=OaQSXMCg0eBrKCBHc3tf104er3A@mail.gmail.com>
 <20250917203435.GA39973@ZenIV>
In-Reply-To: <20250917203435.GA39973@ZenIV>
From: Max Kellermann <max.kellermann@ionos.com>
Date: Wed, 17 Sep 2025 22:36:48 +0200
X-Gm-Features: AS18NWCHuKu5FkRi5MWoSntMnfUkf_rpkIBRpCjAVUQOvwmxI5LYn5BBnB2B2gI
Message-ID: <CAKPOu+8wLezQY05ZLSd4P2OySe7qqE7CTHzYG6pobpt=xV--Jg@mail.gmail.com>
Subject: Re: Need advice with iput() deadlock during writeback
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Mateusz Guzik <mjguzik@gmail.com>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, 
	Linux Memory Management List <linux-mm@kvack.org>, ceph-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 47B352000F
X-Stat-Signature: fo1cftdpgptnpwtpxco353yebtjuma53
X-Rspam-User: 
X-HE-Tag: 1758141421-744709
X-HE-Meta: U2FsdGVkX19g4WaB2WWhJywZ6xiJhwvHOMqGpHS6kJ8gXOGgbTI/HJDlEUH1jojCZ9YCiG6Yo4i+VCEpiTLkmxt/sbAD8xa4azh5MnYfzva95wMojkYIAutLtMea0zMs7S1CIVcwljyjWaoUjrYicMFQacIYqrQhFCrLrMr7rb8TqLa/B0ITApmRjfoX2n7o0n7hHytYOWgEnBRRf+R7rbPacurrwUlODRl2cAs5CSElT8zfV9BGjO+/4jmG7ntAqS8aFd0Utb1b3cMTUsXnWCrjmbsphMJzlxPINynh+BFBytnOsTX47v7smleUaCQ0viH/myC2XhRmLhiD7BbodVvi6C2ZZKjd9B5q1KFWjV0DfW0cAvHfSLe14lHasrmvaCaIYrl2YMtZ4+uG+HXx6e2z4zTyrx//+7KnJYHySb0tG8ydseFlerVla4cdbB0zObv3SGTYGFhN6hqeJAlzMFIaWHPNA7bTbjQkLSTseOmGlgn6NKIAsuAOnaxGnMbC2yT79xUX67IdchpUZ2FeWtPUyq8/WyEj2hqnGEhAQ9hagGMYW10Nek/Myogn738FBkgMp9DuGDeFvUr6ffh6A4fOg9Lp2yUOMVLd3gJU/uK+anaNf51HDqqjpCgSJU2dSlL0r+2P+LwCmpXDOt7soK2rTKT1m5jqVfiCCgYJbrTJmF7KDY6g7SJV/nekb/J4rW4AZdo38GSFzQTQKkZkcRTjtVSLZejb0VIZ3W6SkmjsZomsAN8NNl1Zs7PqtMzhgMo3gK8ZH/ztSOHT/bbdJVXOCaM/B4Z2vE45PFXMHxYklY3+/Ulwez0Uv3bJMQIqNbamYRlNINPbfZeTmZfbDN0AJZcty+2vvNxpdkt5PMyJHlpWS7GFpit2qWrEAp5pL4Yw/jNao3mdopW41AXdYxaHcSU7zvyJG140jqqUhHLukWgHJsLbRygh+VlLNsJY36Gcx5d4mFy+G1F9uFL
 k2PRH08/
 b73bR68WP2HQhSMLLjdTY749RtERJVi9qfKtITNOyp01g0ApD9YpAGggzLrRbf1hfJKqpjav+9vn93AtgR7axT1rufdZPvtjzzV1SOZCOvYZaQZxgYEXKC6jxK1dtw0ec1dTjf7svf0ahLuIzDmUIXiKQYlFcI6PG7+d1NjncO27hVb/bTt4Ie8rEHGOyHcZdK+LuBD4WdsF1NipNLGBA9lnZXco01H8fbdsdEBr6spUoSKcLMs0OW7bkeA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 17, 2025 at 10:34=E2=80=AFPM Al Viro <viro@zeniv.linux.org.uk> =
wrote:
> Suppose two threads do umount() on two different filesystems.  The first
> one to flush picks *everything* you've delayed and starts handling that.
> The second sees nothing to do and proceeds to taking the filesystem
> it's unmounting apart, right under the nose of the first thread doing
> work on both filesystems...

Each filesystem (struct ceph_fs_client) has its own inode_wq.

