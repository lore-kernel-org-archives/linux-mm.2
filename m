Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED426D58CBF
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 23:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3CBAC6B0088; Mon, 23 Mar 2026 19:08:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 37CCA6B0089; Mon, 23 Mar 2026 19:08:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2932A6B008A; Mon, 23 Mar 2026 19:08:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BF806B0088
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 19:08:10 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C39D3160D60
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:08:09 +0000 (UTC)
X-FDA: 84578867898.02.12A0F44
Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id C415180003
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 23:08:07 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RGFvT0hu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774307287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9JXxIITZUqLojFNaAg2BcoK4kPwEnMd2cIAorTUEsYQ=;
	b=YEtsFCZL+I4kpbHH6nNBN5dQi2MTGITSKzZ8xMmPRQ5WZAuy+sb98pRxjd9rLYogI238aO
	lNkj1SfNSwyDhRVGWzggZ+n3Hgs8zzvaF+HD5TfBOafr5ldHhUncHZRJDguzG0CQNy7yeO
	LDtlBagLgQetF9W3T37Wl11bQvowYf4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1774307287; a=rsa-sha256;
	cv=pass;
	b=QuqYDEUocW47UzNUy0kI0d6rocRJp2U9OOW5ZfmYkHefXeXgRnndHTO/xyMT4Khug2SQs8
	yqxYa6LxaISARN48bBSHHHTY9XN4sEAy9mvLoD+rGBwV0XYhuys5ptf5dnkCXW+M2OPX+u
	4FlH21tEddF1jxId737GgKKU3lQXazs=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=RGFvT0hu;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of devnexen@gmail.com designates 209.85.160.51 as permitted sender) smtp.mailfrom=devnexen@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4042fe53946so1077655fac.3
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 16:08:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774307287; cv=none;
        d=google.com; s=arc-20240605;
        b=X856HhXIapyjwlux0BePGuGHmjj0opm9x5wMVxJcctQIpiuyr/d73wFzd4whVKnRPJ
         JuxeT3CVie18o1+vxa4IkPl46SrT1dr621vcMBswqJEgKeixEIKIn8dh3aRPfZRhMf/+
         MAzQJejfJmaU12czBHCiW9fqfzPp+CM8lDY2R+nofwgbU1xlJqvTVWhoF3j7H506HGCx
         U1JELmo8YLQeUQGs5+t/3TQ42RIEt9yEIIPORcMjJ9eE3VKlGhDkQhzISXrjexAedvbw
         VlRQfHh7CTr0kER2WYeLYSQz6LBYAfSmlafAiowImhWN4TFR+hhwAFq2RP0vNhPVICet
         DOiA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9JXxIITZUqLojFNaAg2BcoK4kPwEnMd2cIAorTUEsYQ=;
        fh=9gpKODPQFztpPibA4TPXaAgztr1EJQbFoF32e+9Qtwk=;
        b=NPZpFLIYo76YZCBMUK/+GIxO9pyGqBhMQt4cyHkx+g75EXWDwNAZVWvAQ5vZwP48VX
         +4lcKohbsbqzPyqj9scOk7OfOmQixgPCB5UIKlooeWGJSCvXFoN/WbEbVhV79wAvRPcQ
         Uh+uMpSXlfLZ9vuSMobuHfQa3HiHRCxzSw+0CICz5nxL79g16rK4pYxhXpBT5Uu+jScQ
         ppPFeXG67GV1kMZnRyLjCrD+zx6uc4XCx+9sBMp0g9USzqL/O6nxEOdjOkIQYo0jm5gT
         qdCOixLPZWQe4hlSeifS0ayWziMpGoI3WJzEMsc+Obv3t0HlltJJp1LPujmCBi7+muJk
         EG1A==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774307287; x=1774912087; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9JXxIITZUqLojFNaAg2BcoK4kPwEnMd2cIAorTUEsYQ=;
        b=RGFvT0huQwNZQZIboimUKIOeGgZwpurGmN8XyApGJUJp3477Yc54DF71N4ImEI6hhi
         4eLy3fi84LEr6ojZbilZmYmi6A2YLqTGiB7KWv9RXBhCQIT3O3RDSKGd2vX5j6+uOCTu
         uUvWUFOKJIDwYfxvidhGz/FLJuVpo7bJ2Klg6pZSy6pPMO0rC8WybU19gU2THHqp+iXf
         o5FqR/JJYxhdfFp69ivjiCi6esc4hrXvM1vwcaXZstz9/n0pKowe3n0aWoKqAcrwxfMC
         u+7DWTxbdgz835LBKvfqVgUlQvjXqLvLSGUh1ueKnt5T1tWDPFJOakqV09/KJmlPKI2m
         QqVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774307287; x=1774912087;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9JXxIITZUqLojFNaAg2BcoK4kPwEnMd2cIAorTUEsYQ=;
        b=dlaatm7xbTbxpbnviFylmigw/RL6jbGBNouS7n7JYqwtBQjT3/D4eXzviqgWyVTA5W
         5A6S7oq5wNEHtnpT0V/Da2lxxfbF7WVpkg3wUNYQZ1o27QvunOc2GGoRn0dr7ey/MOF5
         GjptOgWFYl3V2CQHWrzrc5zpMGJa96Dbi3yan/5jxI/F2s+mGGGzPO+iDFInwBolCMKb
         TmojETqHAr3Z2ukS12NEjib6FJXS2g1CNn4KYzAsEfhpecSwiHt3bSDD+6vuGPX9SmQW
         7jQsGDfjeS5ro6pLmRcw5unSxDhnYUVYycL5E91DXedy0MQHbiIqK+paGSidF2q2z77c
         QTAw==
X-Forwarded-Encrypted: i=1; AJvYcCWGMIrAn1hrFT/SWSujdhZn3uA3cqjcFZp+7nGo/NgBzSil6vSx6ZzMmKPSlrnxG00a6BlOsBTLUQ==@kvack.org
X-Gm-Message-State: AOJu0Ywu8kbi+dcIlJf54ITiH5WCpMq0o5foIitOUeI2SdoYDaNDSF50
	n5kp1Bt8o2Z/SQSoe+d5GRMX6HJtxhBfD2D7yJPCAwawnn81R37IjsK0zkcoIOKOe/PQKKEcBQb
	p2mCmsJIm/+yOSfq4i7yR1dN7zJvjzJ0=
X-Gm-Gg: ATEYQzz8u3S3gIMhfXUcJNnmToXENfWZolwTwVG7B1wFSYVn+iqBKrxdMLIBqPeCbnt
	YTI2SPrdOHAUPz6HiSdl+od3nfyUXuAqSOIvtrH+FizEWi0b7aWI/DZd4ZTSEJFeWPXBrpfEXuv
	k9PACrZN03Dz5Qb8gx0zcloa5GxOHXt+SBepS9UNlndvy7Dfa4lxZwCluxa5NNkja4osKOeP+3d
	BZnMLA3EyWylapdMcTD9YYiFeza+QbZRHNB0ry1jvz0H3Tx0SLresXHMeuM1+hbY760RNNCtDaB
	3VSK9qoaTigFg0+tEZSPA+Da+nfwQMjX9niR0w==
X-Received: by 2002:a05:6870:a796:b0:41c:5212:2c7e with SMTP id
 586e51a60fabf-41c52125fbfmr4112994fac.20.1774307286458; Mon, 23 Mar 2026
 16:08:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260323170449.26333-1-devnexen@gmail.com> <20260323155423.96bf426cfe9b3b8e080a2106@linux-foundation.org>
In-Reply-To: <20260323155423.96bf426cfe9b3b8e080a2106@linux-foundation.org>
From: David CARLIER <devnexen@gmail.com>
Date: Mon, 23 Mar 2026 23:07:55 +0000
X-Gm-Features: AQROBzAUq9BzmGpMChTsQBLikKITFWvveDo8F-x8nHOUM1H3q5KbcTh7vtRXxhY
Message-ID: <CA+XhMqxcS0PQioxNwq9FFGdMi40Mm8__NsHzEUWfFCLB6YU=pg@mail.gmail.com>
Subject: Re: [PATCH] mm/page_io: use folios in sio_write_complete()
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kairui Song <kasong@tencent.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: C415180003
X-Stat-Signature: nw7eaau1q1ktm5qf5teg86rrtn841qsm
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1774307287-315769
X-HE-Meta: U2FsdGVkX19js3TxNuhJLy6F0C89FANq0PNyCr2sAL6SdV98Oq1tHxaL3LHLzYWiFk6swhcISr2lOCZW9u0On7WuYP98924uvieptq28PUTA6L/qFPcu6/oJ4u97A9sVvZgRN3tzggFC62Ff/+Vti/KPJKLdqKF7Dz52xP5RAQUM28GwZvkh7zSCZhwbZZoXF+7YXiSf8HX6B7pnfqYEKQg7L9css+guOK1zBbg8rxnJG9f6gIpGmpWGDaI1/THRpDCdHbgD8S0a879nvWxdXXclFizRJ81mteXOv3//xemIlIVJPg2L/H4fcfFygceCL8/5qsWCoG9kWWRdz5fbdF0qXCuxSOlu2O/Z8RGcOhvhXnH4SB2219t6gLtCZyPC5ocayj7a1vDUOWf7iSX0EJQNHb9BLYe3mi+8rSUwcX6myb7WIuFtOa+YwtumjmkO2Xp7S7ih+LOA6fOnGs1AAvCcO3PVb2I1ljQnmIFD+qw8vILaL6lE1JqSVp/DcIA4xpHXDn8NWwZVHrAsUThtAo4pcSzw/wUyRImsK5/sRN7dcmglFmS58AArE4++/z1ntlo6Z2K819+/gacmsO5Y7vgnNjl0vWNJSg5Rmb6ZTuWmcvoMhfQkYkKc6qMEvcUri0DdW1QrGAB6ujauIslk99E6XtL67uYw7bVibVQjXPbCUqIMQm4sm1/h4/LOTfTaygBqjtFiGRTm/0bXgJX/pSLg0KXScBJmtKNdTq/yaqgHO2Og8r9NKatnyYlcy+JcjgWsXqp8VhuBpYBhTpTPlZqC64lF4GuUS8ckv6PzaQsysnpCbAMei35ePNqPNRAgYe2zr6rZgV7z4vv2cHqfAisiUMj4y0D2JnhUeciX3IOGksiOw3eYO/s3M55D622aTvhjwDLyM2NIVspAPAInbhWA143NiHBOPv5G9jAlznT3yRDN/VvRYucABbQUyGAuOlHUKWz/HztUvxNmvhK
 snyknTrD
 iUZ6DsrvlJN8Wx5m1iiF0UeICsc9UImH73r52NAf9QZoV3oUEetr1ByWF0iMMO63lks4CsrCcAzxoY55emVv5AlhUlWniy/U2z04T+cTXyEb5YKvUJ2OvcRWKPFnAOK5+3OTq5GjQRrEEDxiEUT/nLfEyMngh4E+MzeUY4RG6nfvas7vhkKXqAtz31VmjmQQf+bCYVd9nMOcA129Z9x+ggSTFm7GYomfwCULZkE0eu1QZtd+qirDLUpcyhSSJ/RILEtNR792osVWJGPyNMUdLmD8RN31uyhm5Upb1hPSeGlFnE9Dfab1v6LoqpGeY96UZFR/o/2GmYe2bYU4dm624fRTm5z2HXAovkhuVn8dk5/ROfaVNIHOtt7oYmJxGb5565Wfm5LzVUm6nDjaurBg3z7hYmqZ9Nrj4E02lWkaQRKV1NMHZ+DZmYQE+a/W7pnRRn6w0pH6oie89lF0LMYUcIFybkc0VYgHL/G4GlLFkHt2ofQG/os2wNLvTufEHExazWubaEL+K9OXDxdXNx8+JK9okp8a4KmcUKfRP24VngsPX4J+yN13pB9J3ZYKW0OCrL2xROJtnJjIOUqo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

  Thanks for pointing that out. I'll park the folio conversion until
  after -rc1.

  Sashiko's observation is correct =E2=80=94 sio_read_complete() undercount=
s
  PSWPIN for large folios. sio->pages tracks bvec entries (folios), not
  base pages. The bdev paths correctly use folio_nr_pages(folio) but the
  sio path doesn't.

  I'll send a fix replacing sio->pages with sio->len >> PAGE_SHIFT,
  which gives the correct base page count since sio->len is accumulated
  via folio_size(folio).

Cheers !

On Mon, 23 Mar 2026 at 22:54, Andrew Morton <akpm@linux-foundation.org> wro=
te:
>
> On Mon, 23 Mar 2026 17:04:49 +0000 David Carlier <devnexen@gmail.com> wro=
te:
>
> > Convert sio_write_complete() from legacy page APIs to folio equivalents=
,
> > matching the conversion already done for sio_read_complete() in commit
> > 6a8c068774ad ("mm/page_io: use a folio in sio_read_complete()").
> >
> > Replace set_page_dirty(), ClearPageReclaim() and end_page_writeback()
> > with folio_mark_dirty(), folio_clear_reclaim() and folio_end_writeback(=
)
> > respectively, saving implicit calls to compound_head().
> >
> > Also replace page_swap_entry() with a direct folio->swap access since
> > bvec entries are always set via bvec_set_folio(), meaning bv_page is
> > always the head page.
> >
>
> This prompted AI review to look at sio_read_complete() and it didn't
> like what it saw.  Can you please check
> https://sashiko.dev/#/patchset/20260323170449.26333-1-devnexen@gmail.com?
>
> Also, mm.git is (over)full.  Can we please park the nice-to-have
> cleanups until after next -rc1?

