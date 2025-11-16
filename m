Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 38296CD4F3E
	for <linux-mm@archiver.kernel.org>; Sun, 16 Nov 2025 05:43:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 80B506B0007; Sun, 16 Nov 2025 00:43:57 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBE16B0008; Sun, 16 Nov 2025 00:43:57 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 684276B000A; Sun, 16 Nov 2025 00:43:57 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 523A46B0007
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 00:43:57 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DD181BBEEE
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 05:43:56 +0000 (UTC)
X-FDA: 84115378872.04.E43955B
Received: from mail-yx1-f52.google.com (mail-yx1-f52.google.com [74.125.224.52])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1871FC0003
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 05:43:54 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=dnz3wYrl;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in;
	spf=none (imf28.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 74.125.224.52) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763271835; a=rsa-sha256;
	cv=none;
	b=1kIyKwdrv2XPr2JeqnQeJOEPlGrPJ+/Hf9Ledr1TBT9Q2iN5whmwJg6+7qYNtjvxzkaEvA
	BZgKcSTYSdNnyhd6xTXLS4V0VtxZgGUk3vNqc5UA4Xzk+3MfXZdIE8huBHEkz3GFXQNt5T
	0KHOp2tFUUvB3HAm4op0g8mtvxhKDbk=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=vjti.ac.in header.s=google header.b=dnz3wYrl;
	dmarc=pass (policy=quarantine) header.from=vjti.ac.in;
	spf=none (imf28.hostedemail.com: domain of ssrane_b23@ee.vjti.ac.in has no SPF policy when checking 74.125.224.52) smtp.mailfrom=ssrane_b23@ee.vjti.ac.in
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763271835;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sirh6NDYx1jXZksmc9REBWYgPRZY1FFJRO7s3p+KRfI=;
	b=Kj7L37CbvcGim+tfXYBVGaXrr62Keik6py7Ta9DH1X3wIwqc+aWmliMJrIdYm3Da//k8N1
	Sm57i5Hudts0vMEfj2W29nRPEFhlVl+bXsJ52HeuFhTEIcy0GcvQ/AHPicO6EGGoQPzjCE
	pEcooSiY3t/joU3UGF2SkNJgMm4wq3M=
Received: by mail-yx1-f52.google.com with SMTP id 956f58d0204a3-63f97c4eccaso3102396d50.2
        for <linux-mm@kvack.org>; Sat, 15 Nov 2025 21:43:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=vjti.ac.in; s=google; t=1763271834; x=1763876634; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sirh6NDYx1jXZksmc9REBWYgPRZY1FFJRO7s3p+KRfI=;
        b=dnz3wYrl4xLac+Q3Np+qROw8qWJExCGCp/ZlbYKCEjM5wTxpI9VBvTQMCjgfCwYykJ
         tyBsGsUKt+60dXhfPebMVBImza9lhrRbbUEH7wHYQcyaCb1RHhpRAfZaKOm1S2vtw3lQ
         f0mulTBvRaVu5IW7oK5ePULcfbVLPFUStIt6w=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763271834; x=1763876634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Sirh6NDYx1jXZksmc9REBWYgPRZY1FFJRO7s3p+KRfI=;
        b=exrul1to3UYAZpTAz4qe7BMIdry1+vRvnPDk2hf+FZPpMC03exPdgwBY+rigB9lPEP
         W6exEyoG3cZu1LBJAr8p1Sh9nqKMguo/HAiCNoeqUnZAkmkUY9smv1TTb5sv3kMbVlRF
         ZpfnbmQ+xQwIN5prhW7cqZfRlrSirpDfvYoBo3+GFN+QIPlYDjiUOajIaC4TyEUEF/xG
         DvDbIBJOJKxq4di4Bw7O/JezPgmSvLO/h9hjV3CaoVNW6/6H9fk0hLZimsFI2Dym4Xcm
         xffyD8cERNuNPiZzwiij5JTtz5Y7ZXSj7MJWBXH9BE8SJKcBhZ2dK+6DD4ZWssOqIMEE
         d3Zg==
X-Forwarded-Encrypted: i=1; AJvYcCVfc+a7YvR75/26a/+h9JyYntGjCdpOshqcbv9VTfocrA/vK5dfS/5gDhZaXILgKKaQ3oidLKAWBw==@kvack.org
X-Gm-Message-State: AOJu0YxVVo7TgoXp4v8HBuBEpENsNKM1/sS+8uXfQEmghds/O4S3VaKe
	L5hHBHFC2+VpB65GAS1diYYKdrGSx7Yx/2d68gPN2ABttSPzjTC0KLEsuGmKMx8637wgt+Xi0RK
	Jfs4bb6Y3Jc6jG9o5E7VdDFJ7tu1QNF+wlGsiEPH68w==
X-Gm-Gg: ASbGnct+WR5WGn4y5++CWJgXeiu4mB3Qdd0bCfHxC8xjlVDCBjBkwnJtIVAuOaxeXbJ
	CwinteEqIpzj9HO5S34AWecdjqzVHyAcLQ2HHJ3U6+8dMASiDv0HYR/O3t8no22asnzJQ+Sfyb0
	rpFGyi5wZ6nrt9cOKp/bxaXWZDLd7AUbLS4uWYbXNuArEeeozwDGoY65IAGu3y5MUYTWIPqPRXp
	GLSQrJpP23xhoQdjjLxLueN8CVJ85mqQkN+u0A1YpqBr147KXyJuQfDPgEmFz7K6pywE0HpfHTJ
	Ux7bIOyV7qfAUTPjxgs/9eUr8ePcCQ==
X-Google-Smtp-Source: AGHT+IE+5DA78oTs53xtft4SWvilkCaz3ny9tzlKa2iQLr6n4dDJdZ1qZa1fVJLBqkojTcs9rHz8X3gNdwixSxrbVqw=
X-Received: by 2002:a05:690e:4296:20b0:636:d63e:5c1f with SMTP id
 956f58d0204a3-641e7681ef6mr5755482d50.49.1763271834121; Sat, 15 Nov 2025
 21:43:54 -0800 (PST)
MIME-Version: 1.0
References: <20251114193729.251892-1-ssranevjti@gmail.com> <aReUv1kVACh3UKv-@casper.infradead.org>
In-Reply-To: <aReUv1kVACh3UKv-@casper.infradead.org>
From: SHAURYA RANE <ssrane_b23@ee.vjti.ac.in>
Date: Sun, 16 Nov 2025 11:13:42 +0530
X-Gm-Features: AWmQ_blIHXWGYcdl0Doxe099dF8-mjHoCOkxYkSY-L1Qbxh_adlvYQhe5rWPRrM
Message-ID: <CANNWa07Y_GPKuYNQ0ncWHGa4KX91QFosz6WGJ9P6-AJQniD3zw@mail.gmail.com>
Subject: Re: [PATCH] mm/filemap: fix NULL pointer dereference in do_read_cache_folio()
To: Matthew Wilcox <willy@infradead.org>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, eddyz87@gmail.com, 
	andrii@kernel.org, ast@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-kernel-mentees@lists.linux.dev, skhan@linuxfoundation.org, 
	david.hunter.linux@gmail.com, khalid@kernel.org, 
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1871FC0003
X-Stat-Signature: i6kxgyk6tb4dspiuesgedjq68tus15b7
X-HE-Tag: 1763271834-643639
X-HE-Meta: U2FsdGVkX18kGU+OOnvORdIVPkLNFID5flGHXcuu0uibCfI08QfWBmWp+v6zGOVLr9oIhPm6vQ+AxqVvHCp2Sj2+ISPX6VJcBNLFe3l/63oMEVj3wnN07QfuD2A6nWzm6SmRPXr3tt899E3ppcFp6xcmu5eq4N+xnNIhXm3ZxAeJ7GQTBCJxDlkQHIsZyOtjmudosUU9tsY4l6a3nmF4qyzGoizDwA5k1BTZdlv9+MBWe8vx6EtGvYCusZc/wuBaCveIq8khT8CR997LMPYMp1aq/hD1s6dVYS3Wr/eDmMmgWpsPZ1ifEeNX2+1SvdJNp9A55x6Woq2ddDv1nOidSFv53AiGk3GNnNUwG5tTuAgE/IQt8B6eHUTiWFLUoJCfw0ZnQHJTjjW/eik6KGxGnPlyJEkJEcj3hGwT2xvVlJsN4SOXpzvUDAc0lENS3wEw5abOFBI84ZiJfhH65CL2jaSUXovPrPlLT2B+GbLbYGtZSXnvGjxHpf78UJe9ZoWO86CL7DhNfTrUuhshg8uZUd/EaFJ0j/woGh13ruTzFj9j13lcnmbV7HCrFkYEe6srG6JLuIDWgTw9Uj3zn8SWDkLrYvzOJ/jkaE4hI1RisS0tdWL1wwdQMBqSkebHIMgRw5F+kC9n4ZFxCd68U3ms6pelEDVEvdxLZrw0gGU7iOgGN/+JB0PF6G0gTHCDBNwXbd+ZIcdhlpJRgpMSjd7SHQQ0cXNDnl/WkitT1k/z7ek0dgaHP3eaBFtNJtZjE/rm6qh7r9LvBrjv6+vyTqz6dXvYisBSeevOL9wvq0xeI3+VCC5kysPd2oHcsZfJm4pDswQDQgpn3gVuWrKl/gnuz7+hQ6pg5xGe6FTMkYhgKwKI3Ing/E6TTBx7GL11TgWSgZepDpC7vZuh1gKOay4tTmLt9Y7xjq7dSDR1JB+2JSqPxNlXXpsPfU2LkclCsc6D+RoPll6pY+I66ipP3ty
 3ZTRCUlA
 6eZDQsN5dCVcpZgAFuD/lcZIeLQGWgqPhfVDS8SKSfflyfWoRralImD7/ha+EOi0mTjulhCTeQkZ5trik03iV1q36FPixD9n6OzlM5hc9SmIfeVOgVqSqT8ewa2Krl32qpAT+4nhJbUl4er6TEOkdtZ+JzhPG3u0TRXIZ331xZT3RdGlB/EOOfSliacHe0SJBAXnvQSxT4TqUKsozc9ygFXTR6Swa0uB1hwiK/TqrxlIKTcs1ge1s/mswiMTAlzKfUVEDLzy17fqFh0zztfJKvBSU6Cb3QDHdx0I7K81UH17lXcvaR6Sdn12sJYrIudpKtydL4ovDx37xrEgkHehVX2Foz7n+HNdGNdcI6eRh4vJHEGSyoqI3a4rffY/BSDfVYZKa
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Nov 15, 2025 at 2:14=E2=80=AFAM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Sat, Nov 15, 2025 at 01:07:29AM +0530, ssrane_b23@ee.vjti.ac.in wrote:
> > When read_cache_folio() is called with a NULL filler function on a
> > mapping that does not implement read_folio, a NULL pointer
> > dereference occurs in filemap_read_folio().
> >
> > The crash occurs when:
> >
> > build_id_parse() is called on a VMA backed by a file from a
> > filesystem that does not implement ->read_folio() (e.g. procfs,
> > sysfs, or other virtual filesystems).
>
> Not a fan of this approach, to be honest.  This should be caught at
> a higher level.  In __build_id_parse(), there's already a check:
>
>         /* only works for page backed storage  */
>         if (!vma->vm_file)
>                 return -EINVAL;
>
> which is funny because the comment is correct, but the code is not.
> I suspect the right answer is to add right after it:
>
> +       if (vma->vm_file->f_mapping->a_ops =3D=3D &empty_aops)
> +               return -EINVAL;
>
> Want to test that out?
Thanks for the suggestion.
Checking for
    a_ops =3D=3D &empty_aops
is not enough. Certain filesystems for example XFS with DAX use
their own a_ops table (not empty_aops) but still do not implement
->read_folio(). In those cases read_cache_folio() still ends up with
filler =3D NULL and filemap_read_folio(NULL) crashes.
Since build_id_parse() only works for true page-backed mappings, I think th=
e
most reliable fix is to fail even earlier in _build_id_parse() before
we even reach the filemap path:

    if (!vma->vm_file->f_mapping->a_ops->read_folio)
        return -EINVAL;

This catches XFS+DAX and any other filesystem that lacks ->read_folio,
and it fails fast at the correct layer rather than deeper in mm/filemap.

I think this is the right approach. I=E2=80=99ll send a v2 shortly.

