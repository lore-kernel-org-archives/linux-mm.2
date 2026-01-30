Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1DE49E6BF1E
	for <linux-mm@archiver.kernel.org>; Fri, 30 Jan 2026 15:47:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 861956B008A; Fri, 30 Jan 2026 10:47:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843646B008C; Fri, 30 Jan 2026 10:47:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71B7D6B0092; Fri, 30 Jan 2026 10:47:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 63C606B008A
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 10:47:55 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 23E4D16072F
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:47:55 +0000 (UTC)
X-FDA: 84389060910.28.1B048F0
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6BA1114000B
	for <linux-mm@kvack.org>; Fri, 30 Jan 2026 15:47:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O8212qwq;
	spf=pass (imf26.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769788073;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pxOhs+WyOFBYP4PFdYY37ifiIeS/JU2+awwr69rdPxQ=;
	b=h7CStPxsoFivwzqfkw+QtXe4XUtZNQHltB67hEYNtv0NWgVXVpLm5yjbwu2ZpFDO4VoOR9
	M9pjzbc4EyBD4WKE2mT3DQSaQVYg9yYe2brcdSCWlYWDXlUb2nZkoy/VasWuiUw1vveWff
	0u/koAJIfqsT2+GR/MgTn227TTIZsqo=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O8212qwq;
	spf=pass (imf26.hostedemail.com: domain of mikhail.v.gavrilov@gmail.com designates 209.85.210.54 as permitted sender) smtp.mailfrom=mikhail.v.gavrilov@gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1769788073; a=rsa-sha256;
	cv=pass;
	b=i6JZ9xwhqSgsJOrsmEPOlGMGEJlOhHQOL9rzWwQ4yryX1qRVt4hMWgKycho4YHG4gkFu4l
	Sh4UAjjUiL6kM5C36iRejZAlhw3xHvuGFfjN4BXb5sjEcrvymqEclit6wXlQFq/FZbCTSU
	kpBCnieeGD3W9/yyF+LRd1tKJRlmgfk=
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7d15b8feca3so2248062a34.3
        for <linux-mm@kvack.org>; Fri, 30 Jan 2026 07:47:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769788072; cv=none;
        d=google.com; s=arc-20240605;
        b=gMquZF8+m4M1IJ4EDVVRTzyyl9aI3XtACogfwbL4q5Uz8U08ki13/+/ceyu5t99K9s
         t+nV41EnpL5T3n+G9jNKFNaGmuzxS6o7/pdyuIOVoRfBFzRbsMoyska2hSIP+I2C2b7q
         BEd+ByziSFCab0tdMiWMGDMqrAQ9dh725/Gy0o2u8HIkwphi85iutPZg4xYKz23tgomk
         ZZhmf1k5jsYqEwKFwDXX7sEecDWSamaBaHt3GdrKEhhzmx42gCl4YzrizDl3f0PDFjCB
         XOXsVk+zkcdQP86MLWXZWDk/wcxz7JCQoTpA8OiIsKkxEigLxIy6I0nJrDNgf8QJuHgw
         JQqA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=pxOhs+WyOFBYP4PFdYY37ifiIeS/JU2+awwr69rdPxQ=;
        fh=tbeQlM8hLPIR0hT3CckfjQxRq1i4wHTdIY5Cq+hVZj8=;
        b=SbyMlFNHdFQyMbSqE9h/RmRNrKh3V/TMRtt4H7JTz0OE1bs/pb/O8Ep2pY381FKJqT
         wKX/Axo9fsqCH9dWBfapfcCJCYyyxIwmRgCSLXLlXoMbvkLsKE1RkUpKT0wELZ3BK007
         Q6AUY9F/sctG8fA7KOMHrLjaSnzNrOJmSyuW27nFHGzQdC0BJGszP0gfLCG3+cCuF8oi
         0/RE1FZ3ONYWW+mqHs0D867Yio1SWCIY4WcO805n4NjBVb7+/SifJuQCVNLPxRom/ULT
         EwZW+SOOJtVqQQpHwbmcoS0mLwsXx5dxl2gyjAyqU2z6eQDTILnWaYVUP01OGdxmih+6
         8Onw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1769788072; x=1770392872; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pxOhs+WyOFBYP4PFdYY37ifiIeS/JU2+awwr69rdPxQ=;
        b=O8212qwqCWSuFl/bwu8tc9T/wodtW13RJeTI2KgDHfYGR5FtwIMAKrs59kUAT2aesF
         yYZsZruHgmX19yMH1WLGTdD58lXT31RjEO63QHkRCSDQLOxBHbwP6LdDKaDPsYVtAxE1
         V6MyL1OPW84IYASHwP16EJh9Iio/3HWbOC90rhn0FhLt2efDXqIJl+ACiCgvvxwT/kug
         VoBVr4ULwg26BfAECEnXz6mbPgXr1RwhcKBlBBpQvbTHuFm2ob0pVgBejbFTyCAKWP64
         j7a+MzG9YLRMx7Gfd2E6t9Z2X0y9geeguamzZYM80UrQ6z6+FDk23x+/JwS2NkTLxWwI
         Gk6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769788072; x=1770392872;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pxOhs+WyOFBYP4PFdYY37ifiIeS/JU2+awwr69rdPxQ=;
        b=c7x52a2YRxdvHk46Ub3Z4lPrbZjNszvfP8jTyzflk0WmtQe5y/EisLkKxAbHLiEsgh
         8X01LuEagVpGKGHdsThJFbmBOcPch4XVa9A+bq86LD5j6wfgt4AC8johDGC+ldE6GGoF
         DwCcigvwMssDq34kx3HYa2+TIWW0bTB8iYI3kKVId7d6utrLk+2srtZf5D16jAmUkzsA
         uxjszs/SfdSoosxhpgPC3HZsMOds8w4dMdgQSpFDMRpzz7xgqyyCH2vbVg3NamVKKBGg
         unhS2vUpuF4GGGXXXIBg4nqnDtzCwjP0baM3Yma3PDq8voUNm3WSI68SwnPYcuWkScpm
         5jtg==
X-Gm-Message-State: AOJu0YwTs1KJG7Em1GsvcON5VvkUVZCLJ/yY3B92XQH2y5JYl2ckIW1i
	J0CXKzy8JfFlOeQujh66hWlGCnTjB7ZzwCQgw5vAIRhKTemzAvWrxIz79kZ5ZAQSUnh6QJ2NM6f
	hljtRKqkCuKAzFfjR7YDd8i4jqmjtCLU=
X-Gm-Gg: AZuq6aLcjK7v+vRHcA4+WLx1FXcjnhTdf2a2MAMyd+W2Pkoojg2+avYxm4KovFKeKB6
	9j57xXn2QyeVFBKQueVhxTiArSZZh9E3Zi4MFd3dKCRf3xIX6fRAwfI1LgkuMgwJkfJXXjR8w7s
	GR6jD19dQItYIollWR8OxrrjDcXypiEaKQ+yvrotZhigtvMNkUtxadVWuw24J8oQH0S3BgL9p85
	fZWELkT3LUGS97kHFVHr1MCNOFZxnVWr30SqESXxs7dDkXINKWv+4WCa5WhG+6hJztqAmjp8Q==
X-Received: by 2002:a05:6830:3103:b0:7cf:d168:1f3e with SMTP id
 46e09a7af769-7d1a52a738bmr2227022a34.3.1769788072280; Fri, 30 Jan 2026
 07:47:52 -0800 (PST)
MIME-Version: 1.0
References: <CABXGCsNqk6pOkocJ0ctcHssCvke2kqhzoR2BGf_Hh1hWPZATuA@mail.gmail.com>
 <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
In-Reply-To: <CAMgjq7BM0QFvk3_D4qyggjJ4W_+nHAupQnpAYehGq50CYNJV7w@mail.gmail.com>
From: Mikhail Gavrilov <mikhail.v.gavrilov@gmail.com>
Date: Fri, 30 Jan 2026 20:47:39 +0500
X-Gm-Features: AZwV_QjCsm_Ku_IZQSnm8GMCRxWJL4TOWjpCGiPhq9KD-_1KYwdgqG5WXEBv7FE
Message-ID: <CABXGCsPrpLubmjt5vGacPcmQnOYj1EVei3G3=L_2X_-Wfa3kcA@mail.gmail.com>
Subject: Re: [RFC PATCH] mm/page_alloc: fix use-after-free in swap due to
 stale page data after split_page()
To: Kairui Song <ryncsn@gmail.com>
Cc: Linux Memory Management List <linux-mm@kvack.org>, 
	Linux List Kernel Mailing <linux-kernel@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Vlastimil Babka <vbabka@suse.cz>, chrisl@kernel.org, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Stat-Signature: 81hsm7ghasq5femgqd6mfapupq9hgbd6
X-Rspam-User: 
X-Rspamd-Queue-Id: 6BA1114000B
X-HE-Tag: 1769788073-774094
X-HE-Meta: U2FsdGVkX18ai4WENQgOOnoQpYYiikPwOzp3vdd7ceWbBZnmZxU3+2hC+sPmJNX0eHvTpPYd92fL6LsH1wpCeIK2yNA/Otd3bYlwKfMumqP8Bepcyr4uwD1ol9+zJ8OTMEYZjJ5DzCl60E+/kwxV0/BHkWPdBGjGNQg9KB22Jt2vHLcc7lvo8B99Yw5VMKQvlw5RpSV9A54zfMttYhGiClgKqEvBFYgh1xivhwiWEuh3oeR2VPtpWWGK7u9XJ6NT1TFdJAf8Mr3HXEbNT0a7I23wqwLrvB0DdXgkZeV03rOx6OjlVQrs6eG6+2KtjDTAzXtvPnYWqa/h2J863H7eTROGcmkZ6/gMylCAvq4+Mlxtu5wySA2ulcl3VEZ0yRTmuFqw/NUBp0ccPkNEXi9iQkgNEk6iZzBYUv9DxbU8h0ctajfLcROW7uxL1nsyygHSHnKoPt9DwZBgO3OkbStP6DXtyMW9kI5N7pL61rw6+52m2rK53yhRcSdH6ZkR4yxa28P0W7Lxv5oWSFnN5Xry4qWnlIviUO5wEX/yLMfb/uEYh8/rFJJaKyGnv3nMBUCP8FXutA5RGca8KpjW980SOFJW/l85rHQewxw6a4OjJqpoPquFoHeZa1YX+ADsvny75u18AgeWTKY5HldxLiNh6wJRjp0fSgAANqZo7iW4bOGAFppyE+HPoyojvHng4EcyGPrO0gesmeupbLXPU0uxWRpE6pEXHxp2IJ0A3EgiVAuaS/IjHL00vrIwFEk3xNvZZatEIr65JVlljwSOwh6QtBxTildUiL6IVWn+sdjBHMZRQy9KDrm3H3yABl+YZN2B1UZPOtnXy4/991SH+c8I4FOZZM6kySvXiTLfCq3fyQKs3izSlb2Hm4pGCSmVdHVLK0ZTptpr7LNERlvXAXGfJt1Uq0ZzRz1c8BxnrcJMQzeFEMSYjLMZAUARQPUUyujs7mp/+pJUooRmJXBIFjX
 wTSMx2kF
 jtgvm/fEembDBDN+y7/tEDrzDVWVchfA5WfsQ9pYEQAmmR5pYAgcWRt7qqpL6iXsc3uGrkvhzBtxLjNHPX48cOsktHHcDjheql/4Nea9LqSkc8zDr7JjXbFEKp+KQjtdUrR+3ZDi8n74h/rU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 30, 2026 at 8:31=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> Hi Mikhail,
>
> Thanks for reporting this issue.
>
> So the problem starts with `swap_map =3D vzalloc(maxpages);` right? Will
> it be enough if we just pass GFP_COMP here?

No, __GFP_COMP won't help here. vmalloc always calls split_page() for
high-order allocations to treat them as independent pages (see
mm/vmalloc.c around line 3730). The compound page would be split
anyway.

> And worth noting, mm/swapfile.c already have following code:
>
> /*
> * Page allocation does not initialize the page's lru field,
> * but it does always reset its private field.
> */
> if (!page_private(head)) {
>     BUG_ON(count & COUNT_CONTINUED);
>     INIT_LIST_HEAD(&head->lru);
>     set_page_private(head, SWP_CONTINUED);
>     si->flags |=3D SWP_CONTINUED;
> }

Yes, this comment is the root of the problem - the assumption is
incorrect for vmalloc pages obtained via split_page().
post_alloc_hook() only clears page->private for the head page
(page[0]). When split_page() breaks a high-order page into individual
pages, tail pages keep their stale page->private values.
We could fix this in swapfile.c by always calling INIT_LIST_HEAD(),
but that would only fix swap. The comment in vmalloc.c suggests other
users also rely on these fields:

"Some drivers do their own refcounting on vmalloc_to_page() pages,
some use page->mapping, page->lru, etc."

So fixing it in split_page() seems like the right place to ensure all
callers get properly initialized pages.

What do you think?

--=20
Best Regards,
Mike Gavrilov.

