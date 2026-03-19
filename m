Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BCF07109024C
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 16:20:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 166E76B0544; Thu, 19 Mar 2026 12:20:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 117A46B0546; Thu, 19 Mar 2026 12:20:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 006476B0547; Thu, 19 Mar 2026 12:20:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id E01646B0544
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 12:20:49 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0D4ABA404
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:20:49 +0000 (UTC)
X-FDA: 84563326218.30.C9FFC0E
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	by imf09.hostedemail.com (Postfix) with ESMTP id 869A4140012
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 16:20:47 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TaBiXGmm;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773937247;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N7HRpg1MypstlMT2teVNYM4udnGH00Ejcr+QGOzXvFU=;
	b=lTEGrohSopWkHtJuhTlutd29uSwKU58re2vCsk7WKkPT1PMkha7GoJTzbd8sUqcjO5iz3k
	0dFbSuq9s+whvRVNyy87uan/sOP+yeWdUFeDQrIFoAlhNrvkTsYLht8t5C52cWwesJpn+A
	BZ+ZQDdQpnbDaRszvfvJ3jveTIGKtrw=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=TaBiXGmm;
	spf=pass (imf09.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.54 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773937247; a=rsa-sha256;
	cv=pass;
	b=Q2xHbzwD2mEb/AINP9EgFVTynBJsXlaqQOODDcFw0FtP+blS3/X+/2rhK0Y9GY6oc9Vpds
	sFsQVKYwJqjCXg05mZxyLhJg5e+OK8A9tsYfXQjq5c4lxR15lpVsvxV+vUVuuXGLX3T3Lv
	ZXjcucKJ8TvtGDdNqbkOIATQclynDe0=
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6670ba39400so2041943a12.3
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 09:20:47 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773937246; cv=none;
        d=google.com; s=arc-20240605;
        b=TS9tpoy/2TLy5EJtVVRlPKOOnQ0eidA4OJmMBJzw79rerqLJs0jYTfUVkq/bjCz5lV
         oYRHZQtua4yTtH/6mN4b9rOFvc9bXs7/T+mqnqywW07cJqsTxpSnLegiKShc/SXCVTZ0
         faS/h5XHjupa6wfF5lSUA2hs2xWRFsP0MJB/fBJFPuAkpZhPfZZ/0vbmWnyo2Mme9MRN
         egZbzfqiJmedZjF1UP6feXt3scjKn4CRI6iCxA2jqo+nPEwe7R4G+MZeYp9LbI/XLAvT
         cOYowEvhkuKq46VNb3lpahyc3w2/yMSbG/3JCKiiiYJNwjUkZPZsBw7C4D2AvnovUK1Q
         IMIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=N7HRpg1MypstlMT2teVNYM4udnGH00Ejcr+QGOzXvFU=;
        fh=bMydq89yXJSWd7CpkCaabD2PuZ1R/E5j47Frj+cL1vk=;
        b=EHt719BhsmQD/gOlLGrUqL17ik35W9aniyp3PW9OXBbI4GkwXr262P3GeHql9TOPeX
         BgdbfrURxd2nCNa8fSLiGu3yd1xeU3QurWdYnwJjAPKRCO33402xR4QRiZw69Q59V2ps
         B4qfNqesIOUh2oLM76JYrmM9bjZGqaQGRDTe1j+ftL4qvZ/4hqkeV0nbzFwohpNaAWki
         RmZi4afgyuDcxDE7rxVAvQDmaZtM71aFKX+T1QTUrntQyBIbJIaWuTHTUn+z7QemOIew
         INg7mKpdNTovEqetZfVPpUfMG9KLRwO/73dpIYVvAjKhvrxnHN3dD7RH8lO3gmhBggKe
         uOyg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1773937246; x=1774542046; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=N7HRpg1MypstlMT2teVNYM4udnGH00Ejcr+QGOzXvFU=;
        b=TaBiXGmmLbsBjsBfZuIy6KfmLIg7F/tcQN9IeyaQwrs6xa6KLDzjjNbtzmqy9WLpB+
         hgQACAknpq3NW2UKwgGN6OQgyrpKCvszweVzVr/2IWla5xDVneOQUq2Une+xMPbIOhYx
         cRMaWmmbj/9GlzFs9Yolx7RNn8lKPDO5+Gyr9G1qxKohXBKFhrogJ/X6RnLXWX1Wgj+w
         C5ruTS9MLPaxJPGr/0vmqBTElZF8HrUILIHLuuFnmaNss8mAqVd08JuHscIWYBYxumFH
         aRbFdd4nIM6ua6m85ut2LdyaiecZtPSWr5pR1vqmpv6I+rGjPEuGOttOfrxumED/+cDQ
         WzwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773937246; x=1774542046;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=N7HRpg1MypstlMT2teVNYM4udnGH00Ejcr+QGOzXvFU=;
        b=FWFLwAXMF8S58He//xb+F+vlsIhqV/DCE3ht1/ztQPYaPJVGU+DfUvMyjJHfaIoWIn
         mSZKe/Ca4oTnj+EzD3nKb+D3SchmlW1iYv2qFj3zTVVIocurh+mQHiwiKLobsOgrZxHm
         xmOR9WOtWGdsBTK/WgmIoiDNY4F2Q+igPVma+wtH4YVRv7IcQa2D7fkSsfTm2FTFtIMr
         7+K+jHcr9wEFxDJ3DQdZncHtDZ1EjxNIlk4hTFkvhlUbnBjeuEUTjr77s8Oru/aQBSYS
         sumS2VL8/YNjO92FJ4dhKjgqhKa/XsK/IiHuw0CYtNHLvjgk1GipLLIa1esaNmre2lRY
         owUw==
X-Forwarded-Encrypted: i=1; AJvYcCUOP1pop2fiFFVQF21wCt9tBH0474siaemAMUs193xgQYSqSlfvvXs0idlZ/t38CH+3paNsLJBpmg==@kvack.org
X-Gm-Message-State: AOJu0Yz+Oin2uLuO3Gz0lMHtSf0eu3rX2EVbRVFIx+rI6wUfehsmN3+l
	DrS4z1URoayJRCi33E5mcnmaWCpORXYMESh4bqihHRWT89ngZsNPAuYH1mgnJuHXaQF3ITFj2RX
	5PgGik4VNsgVANoLLmmIzFr9jqcVwot98WKEjqSCVHg==
X-Gm-Gg: ATEYQzyGNY/LnoGJls3gE8P8eM5ccWzF60enMSb10mDEb0oxYDxbGBCzN9ked8WotW0
	T/tYvzpaQyIwNCnoZdayfrSfXNI4Py57yc/qAZpTpdAeORJCkx6jjZT1pBYXTdxsePDcPmWRUX3
	3svTVhHOI3Wt5T/3xD/oER9GjL9FcmqcWPFfzrhaGQ07IiyunAWbtnN2Mbus/wWiURjC5QISUN9
	wvfx7qjllnuRTl+JatRlAuwAUj3VCDt/2TNXla3oTgj9xZDexMN5p4eFJ7HD6adct/+xBrC0Q9B
	MvyXV/bCrna7SVJb2ABV/3XXD83gK8fl2VeE0w==
X-Received: by 2002:a05:6402:4005:b0:663:71dc:127e with SMTP id
 4fb4d7f45d1cf-668c9528336mr52528a12.13.1773937245840; Thu, 19 Mar 2026
 09:20:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260319012845.29570-1-duanchenghao@kylinos.cn> <20260319012845.29570-3-duanchenghao@kylinos.cn>
In-Reply-To: <20260319012845.29570-3-duanchenghao@kylinos.cn>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Thu, 19 Mar 2026 12:20:09 -0400
X-Gm-Features: AaiRm50mmOOYRVP6K1HR019Yvp16ZATrTx9aIGrEDNP8gkve-Gc1CInuCVVDXXY
Message-ID: <CA+CK2bCCh6p_qvchGFwS_QOkk64Z0WOc5_Xo2T0OjtmjyyeoNg@mail.gmail.com>
Subject: Re: [PATCH v1 2/3] mm/memfd_luo: remove unnecessary memset in
 zero-size memfd path
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: rppt@kernel.org, pratyush@kernel.org, akpm@linux-foundation.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 869A4140012
X-Stat-Signature: d8tgujmj54du9s9cg9yehjpxih97qcmm
X-Rspam-User: 
X-HE-Tag: 1773937247-134327
X-HE-Meta: U2FsdGVkX1/Xh2kULFs33tb+NZeiwX0ev7lUNok53cj6uJ++MzxqyXpLdOr5N/QMjOqJwQ8a7ec8mgQ13cMXcCDK96vEJhzjrSD3eHgPMd3QWy+cSNMwxVkIVWpqvh7f+99Htx7t72oB2Ci4PhL4hoC9N7XsYm/YPUIxS0XVQkMWip/vY1p+4dwVhzOxG7/KZzsJJ29LEtsg4Fmror7lELV+BMTukv0RsU08IX0UdKuIDCmMyV3IP6xzNFZbaZHG8IKneUWEv6irSFgDk4GLEuv+YAxwWAvtiL6BewR6HQOjBtMXqrd60tChCGeTZ55L1+49DUAhPVhZ/FPPkC/FumIpDDaMmKyFB3p+QtBRbenCdmvsJe33R8gpdR/OtpJ6ayQSsKoekA1nmHICOcC16+4tiCjUs+kgpVWlb0FqOmuezoAMmdDad++02yjeB6YEluNRlVrVnAxOKgqrKcYvz9LelxnEIienVXzrHZGzghGUjzb5vqw0pvL+p6JkZwauB3KssLKsET6QWGUdrXzJHVuZk/xuMIJJzP9zK0lOEjtlYQ3xIEyBoFjaro1tnIspfshVpzRuY4KwyQRrbWO1lXey3qD+TXh7Sj69OoMWCUNLeHiuC+4MI/4HxjGv2F2g1yDgrQ6UGTQIQ+gcZRMYOdSnOA6TzFJWZb6/Q9IqGEProQ89w271/2ZHK/QgpQGQpc/9c8LLv4e/fUU8VVINY1x6p5/I/iojVUG3k8S7+eWJfKceO3RDkMId1E19DBtPccctTvQosUnkpNME+eIoYBECqATbf6suYZQuFrEX39wziA5DHMKhc0zUtZb0/+TuNb0BNUklNEHGR/KcD//MIr8d9yMEeHRZl7E5StQKneGGHJ/pbGyjvf+rN50cc7Znk1iWB9j5GVPvNilXYiP7bkm3irzwn/bNCnppYzB4by/1YERMcPWZGlEhsp5udNrRTOL8eJc8UFnnvshpBeY
 cgw4isan
 5dmqT5FQu5QS6XG7N/R2Qd/u6xiA35QZYEo7nocOYg69XBNja6hAAVzRKaO7Vz2VS+m5wudA99D41PvGktzOEn8Q5UkZQFnerA22bZO8tTms7omD0FJ6TaInIZ/UEO0wpIO9eMlYAjV8VNYFVEw5uhawsSRt/R57c85KnQoCCjqMUPIerSXQTG2byfghmIuQEyFQU5vwBU/sr0StVjrYSHUNekoU5c1leltAgbIIKSRL9NO0JA5aN1TKpXnqdRm6YEBeFEezIXgTmiXEXMl7D6P5CRBU+/vHSPgfpopmjbGrNbNLMW0qH5oao+TSgGo0LyfkqXMLUGlCwJtYR3/OLpzz/kw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 18, 2026 at 9:29=E2=80=AFPM Chenghao Duan <duanchenghao@kylinos=
.cn> wrote:
>
> The memset(kho_vmalloc, 0, sizeof(*kho_vmalloc)) call in the zero-size
> file handling path is unnecessary because the allocation of the ser
> structure already uses the __GFP_ZERO flag, ensuring the memory is
> already zero-initialized.
>
> Signed-off-by: Chenghao Duan <duanchenghao@kylinos.cn>
> ---
>  mm/memfd_luo.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/mm/memfd_luo.c b/mm/memfd_luo.c
> index 5ddd3657d8be..413df8c75c1d 100644
> --- a/mm/memfd_luo.c
> +++ b/mm/memfd_luo.c
> @@ -103,7 +103,6 @@ static int memfd_luo_preserve_folios(struct file *fil=
e,
>         if (!size) {
>                 *nr_foliosp =3D 0;
>                 *out_folios_ser =3D NULL;
> -               memset(kho_vmalloc, 0, sizeof(*kho_vmalloc));
>                 return 0;
>         }
>
> --
> 2.25.1
>

Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>

