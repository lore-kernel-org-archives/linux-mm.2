Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9A3CCCA472
	for <linux-mm@archiver.kernel.org>; Wed,  8 Oct 2025 14:05:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F3D438E0013; Wed,  8 Oct 2025 10:05:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EEEB28E0002; Wed,  8 Oct 2025 10:05:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DB5B78E0013; Wed,  8 Oct 2025 10:05:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C92308E0002
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 10:05:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66FFFBA39A
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:05:21 +0000 (UTC)
X-FDA: 83975119242.24.6F76E02
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6497B1C0027
	for <linux-mm@kvack.org>; Wed,  8 Oct 2025 14:05:19 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jtoAlc48;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759932319;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pnFNM1hwuEwchUfhEuJaKySc2Ut3Y6Tp66F6XTEbLGo=;
	b=XsnNCoifJxrfa0K3zZv99BfA20DEaVl1oXGgiuySjpORPb60GsnRz5GOmd8YsaqGErd32A
	GS3OiMR/aio6q5ugflO2U2fIxH5auFHxaL+OhI2HkOt6n8B90xuxh8/XtnpSYOT9M8q+tz
	iozhPCY9uj6pjqFHgpicJc2WisfSiNE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jtoAlc48;
	spf=pass (imf20.hostedemail.com: domain of aliceryhl@google.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=aliceryhl@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759932319; a=rsa-sha256;
	cv=none;
	b=fz/Af7Rf4/ax4CSyEHRxBvzgh2CkE6EAZmtkiUY/kMoghqIR4Fm7DV72WD9Qw6huFFIXoi
	v1BVNP76EuARMLeu21GWvrnw1vUilVuMUsY5n632dTH86JxAE5NDgGhlbh3XeoD/1bJ2m2
	Ia04rKe36v25wBM1CGefS8Q1v/oV1WQ=
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-3ee12332f3dso6625776f8f.2
        for <linux-mm@kvack.org>; Wed, 08 Oct 2025 07:05:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759932318; x=1760537118; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pnFNM1hwuEwchUfhEuJaKySc2Ut3Y6Tp66F6XTEbLGo=;
        b=jtoAlc48gLnUdXl8yrIP93TnJV0iFu0KO0+DuIkuHsPNIw6pjkmogthUwewB85IOkY
         N2ZSV8YyIFEuxVh3ZScALRtubtKbVNxCfhWaO9wwBY72y0Jio4YYKSrPVxproKjuppcR
         w08jtZ4A3TeDDzCzzqqbB/0LTbDAsTYENtX84E66YUlM7AGg6PD2O04Px4Kko4Q8QrKi
         Y9OIvY7exuPu3bmjzV3JLfpPx44SbapqxJ4Q/RbgyyVaTxE+zgzqy/fQl4G1DrVXPZ1a
         Kct/Ce4Fwo4o5x7ZQ15y/XpmxMff4AveQnUqW7P8Fux0X4b7ba6oEbH7fy6/X0PcfmAq
         riGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759932318; x=1760537118;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pnFNM1hwuEwchUfhEuJaKySc2Ut3Y6Tp66F6XTEbLGo=;
        b=Pb7+9RWjIMX7Ci8g4Zp6VRl3U62ok6o1ZFBoDSNhVBGR2DGIhHj+kJuNGBBylcK9rD
         466m9/xjKB+zJEtNzeoZE+VaUvie4rJG9RsdXDGakvTp6/5L0pvKHQuoIgcNlv4mWzpu
         gRTTjfvaVGHUcZ27VkoCq0wWmDh01yCpdUB/nRCfZ8nBqrkGoHKdop0fGXvhjjeVYuBC
         CDmTYTZXN1rXMJhPr45e4v6c1lfPmWLmzORYOzHehbgoCnKbvKa8OM+wgG3wzwdx7qpS
         rTit1lCpnZIQZT3oAhDAAvQMdl9DH3X2ALEBxMcBYNilCgENSEaV7ajXQB6fWORnzgUw
         J+Pg==
X-Forwarded-Encrypted: i=1; AJvYcCWSBzQOCU/tQtYkbz93+U+McrcNZRYN9LOGvPnYXK31TNN+3h6wO5v17K//GTUGxl35f2utrvCrHA==@kvack.org
X-Gm-Message-State: AOJu0Yw+rNrcUrAhqqIfzJ5Ub3U6Rmnmkuc3Gw3P8zhF+LINg8lC32+p
	8H6jXLyN8+eOraAreh7KBIJlmVuMWaHXu6O/blm5Cb12I8H6zOp62w12mH85JgjIRAgvWtyIxQM
	Mo1rAMey+d9joC+PgAaMFGDJWhwQZ30+iKlzBk6y0
X-Gm-Gg: ASbGncv+6NEzSV1RAK79XXI5OpEmTOQ+aTjW52nq4g6+7Wd4m4PXbCZHyjLlLO2YEqw
	+gsNMvcnJM1XVAzzenqlrSg/2HUnBeW+oCpZBcrVGsGHTFrmKyQir3vrMjuIMurEE7+ECNnA2vL
	2cXPJ18ntZGP1BcqXsw2YaFz2tIFRb9ZjvYqVDFL6K0KJBS8a894KCDfrIB+bbNlW2Bgazb1pQp
	sQTgMvBwgvrYl3k2dCMpO2GkNv0VoMisG6y1IlOa/4pi0LoZw1KbK9fRmpxmqrW50E=
X-Google-Smtp-Source: AGHT+IEtL1VUjwteFF0aUMusK9O6vaSfUkvwFkxXShRQV/K9msyLkRj+XdqkEBNkBGqLRAXp1DSu3/HCWH6QZ7gPJbw=
X-Received: by 2002:a05:6000:2c0d:b0:3ec:df2b:14e2 with SMTP id
 ffacd0b85a97d-4267260e143mr2316476f8f.51.1759932317676; Wed, 08 Oct 2025
 07:05:17 -0700 (PDT)
MIME-Version: 1.0
References: <20251008124619.3160-1-work@onurozkan.dev> <20251008124619.3160-3-work@onurozkan.dev>
 <aOZhS9nTDnH3Zh7N@google.com> <aOZpwUD50MwSBycB@casper.infradead.org>
In-Reply-To: <aOZpwUD50MwSBycB@casper.infradead.org>
From: Alice Ryhl <aliceryhl@google.com>
Date: Wed, 8 Oct 2025 16:05:05 +0200
X-Gm-Features: AS18NWCZJ-_06NHTt-9pvac60ma3Z_7vD0cIto5b6ZZ5rLx2-etkF4_odDy_JZs
Message-ID: <CAH5fLghoDEKnpq6WaD3zzV9UHm6gYzYXCOG_Q=pOUomcNcQhPg@mail.gmail.com>
Subject: Re: [PATCH v2 2/4] rust: xarray: abstract `xa_alloc`
To: Matthew Wilcox <willy@infradead.org>
Cc: =?UTF-8?Q?Onur_=C3=96zkan?= <work@onurozkan.dev>, 
	rust-for-linux@vger.kernel.org, ojeda@kernel.org, alex.gaynor@gmail.com, 
	boqun.feng@gmail.com, gary@garyguo.net, bjorn3_gh@protonmail.com, 
	lossin@kernel.org, tmgross@umich.edu, dakr@kernel.org, 
	linux-kernel@vger.kernel.org, acourbot@nvidia.com, airlied@gmail.com, 
	simona@ffwll.ch, maarten.lankhorst@linux.intel.com, mripard@kernel.org, 
	tzimmermann@suse.de, corbet@lwn.net, lyude@redhat.com, 
	linux-doc@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 6497B1C0027
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 5m15o9mfgzgo6fdjb45wc3eeb798ctb8
X-HE-Tag: 1759932319-347930
X-HE-Meta: U2FsdGVkX1+k7OScOqHpI78/MMw2mDFTm/HxooEzYhP1EEZoDlM0blEkinc/gSw+yz51KMZ+Fc6vNoLTmq1E1iTZNwR5lOlgOj6xA34iqFuOVlD0h41XvqR9xJEmVXUBVfne88O7EtNBgx3Sf4dsy1JP70nf4Nhju2pxhBqF6v8vMZrLsfMPdnMqt8HzeMR/qrUgQzViGIISoutcYInr7Fdy6/5J84ZC59f4v0kXmfvf3JdFUvccKUuT9bVivn1ch60YzQcLuokQgS2CIS5yxYrDm5ygSWYgKXh5JeKZeCDeX85KUakuoFwUjjCglBTExgFcZ17mg7I62jNdvaAmi6ZZB6Jnd5L99J7Yo9NkSZICT5VrDPwLIUcoGcwLiwv42CmvTDxELSCi8DaC/fuJRRRzS1Bpmj42HZW44qQC/Qg3NRlaSGtOnLcEhbCjya5z4V9xdI2FSKYSVPmlRDNanMcCjZ+95vs/W6KXbfpyHdSFZdVzBz6GfVHCj/y2FR7+OA9SDC5WzCFhc5Sd8r/wVd/1Sp44i+V6QIbnGBPriYM6KWK34NOIbZ6Ou3sSwfZjPx87sCBCz+kG9rQOZQPyIrDEwgX5NjaK0or+4QT2j0ZUYNNT7w0eksHG+ZiCAuXDYAA6NXCLCynetGA4/7NY0NRp8Ivs3+SXEFshIQQGjbVfLZ59VPgc75nu5Hlkb5Q/jjkUBvZ712xXpJdIY4VsbszcEmGdamgiV2pkbCKoUB1C4shAhbPLDHbpXxia/6EiVWxeGo4pEmWIY/rcOUP30PnuPTfpGb10kqPuNNsCgK9SKrBoRXhDs6Peg7/sg4AKkNDW1YqnxxlSxKFlXjgrgs1qOkwUNMX6dUo+0VOweaayWT85FTwrHGqWYcX7R7NiVcIi5sm2Dnm6ixpVJzHLnTWXB0Xgd3XKhMW9n7cxSCePxPI7i3iCiENWNWAsk3h6dz+ZznWTrf3Dydh9XSj
 6NyWHM6s
 fw7LSSNbBW8lHM4Z/TbUPQiRy6GppvwW/WsE4uU5jI0F1KMc78fInb4imzsIrp1+o0KGz0ncqA7Ot71WJ/Cy7m3PyBoxhX0/Wz2fAcAuparvMbDY0y6i7F0eVdtYxzzgu02M8lkFhaj+TNUVp3wAJJlOULAb9ENQ/ZtssPjW66M4fiTwGBF8pI6NYVtrN9gQ1XmzbjsaLS8jpFOI/xcz8l9aKs6SqakGXjFqeAhgP7UWW9q9NYWYx38sS5b62qJzmYGywexaN/RPaMrtJtV4soRKAcXrl3hKSC4XN41vQG6/h9Ukl8QVWKS+1dP3ADebQjlCd8vfvCpZGba3KENN+HVvMEFJ8LxuveBedO2ohQBKOGJJ6INznsFK/XQSNV3bYjflkUgXTF5nRGtI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 8, 2025 at 3:40=E2=80=AFPM Matthew Wilcox <willy@infradead.org>=
 wrote:
>
> On Wed, Oct 08, 2025 at 01:04:11PM +0000, Alice Ryhl wrote:
> > > +        limit: Range<u32>,
> >
> > The Range type is inclusive/exclusive but xa_limit is
> > inclusive/inclusive. They should match to avoid confusion.
>
> ... and xa_limit is inclusive at the top end to be sure that we can
> actually allocate 2^32-1.  Or does Range handle that by using 0 to mean
> that 2^32-1 is allowed?

Rust has multiple range types for inclusive and exclusive cases. The
Range type is usually used for indexing arrays where the length fits
in the integer type. To include 2^32-1, you have to use RangeInclusive
instead of Range. It should be possible to write code that handles all
of the range types without repetition.

Alice

