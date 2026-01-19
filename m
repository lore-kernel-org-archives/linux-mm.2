Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33E7ED29C3C
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 15:55:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C9E96B024B; Mon, 19 Jan 2026 10:55:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 777436B0253; Mon, 19 Jan 2026 10:55:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 679856B0255; Mon, 19 Jan 2026 10:55:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 573476B024B
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:55:56 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 149C0B61ED
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:55:56 +0000 (UTC)
X-FDA: 84349164312.27.D8CB3C5
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf22.hostedemail.com (Postfix) with ESMTP id 2DDA2C0007
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 15:55:54 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=schGeZFV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of smostafa@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1768838154; a=rsa-sha256;
	cv=pass;
	b=a5UqyO4OD50fdsshJxdu01wnMisIizo8gm1gDm/Ukmlu2f+3sgpddrJP5U1Y5wMpSMEZPD
	QEn5aEIAxxye8l97QUvjA93nsoSY0UKzuuosW49XrlXoFVVDaRVsVjxIwy868T0UrA1nVk
	f2O97F3SgSoXYBVxAD9lDM+2YZHydR8=
ARC-Authentication-Results: i=2;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=schGeZFV;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf22.hostedemail.com: domain of smostafa@google.com designates 209.85.160.182 as permitted sender) smtp.mailfrom=smostafa@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768838154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+CVQOz4f4pv4FZJxEWXVriYAxqFNoe7HY/c+6oYXd4=;
	b=xQdIFNl8Es2JLeS3BLkzWWxO1b/U4nh2X63zuAGn/YF3F8wi6kdCbQJkCv4V3xxG1NgrAv
	GMmb5VBqA2I/aixxspWaR5RZ2KSEYJmIqaLpAUqCEOmyjtI4gCDE9oZO1vSsO7YHPL8mjQ
	CcMgmmll7sJkKj/pnHoSNpJq54krjBc=
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5014acad6f2so19431cf.1
        for <linux-mm@kvack.org>; Mon, 19 Jan 2026 07:55:53 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768838153; cv=none;
        d=google.com; s=arc-20240605;
        b=AQLxJxmFaMWeZduwcOBYrReHR2hWaNUS0sKnqs+S6dQ2MCYvcFAhyOoIIgh3Kn05mH
         C6Vxe+ZBd2b+KXYifO9Bm4UecQotY03p/37kPt/4XkBorxnQvfN/LKOOnKj53QAvtItX
         GbFI6A9ctixVKtlXDOjrbaTQwkhg6YRXUqRcQdREI6B7R25lfn3GuQW3zFo8GvHtTwCR
         lExS/p1+le0f+NmouH7GlTqLLV3Tc4GGezWPwOtgdUxYnOgLf1rQwa0sRpsduYtnFfLI
         cYOwM+tj5NZmcu1+/PEST4VpXVbo3n/G9tm3BB0xem8KYFsICzcDbmKSgkJo0vcR+Sc6
         NVEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=t+CVQOz4f4pv4FZJxEWXVriYAxqFNoe7HY/c+6oYXd4=;
        fh=kvsWvEa3cRdWT7ZeJAtmxeosrcrlX+BojyDImiQCiTQ=;
        b=FwzpftHzgrCePhKohGx4QYybufiv6/EzWoQKDJG+Kr8Z/EMt1pK1wEEkN8JgUr+whQ
         SI9SOFQn2zstLLLzGCsSfXbtMfcshKZsLSPhNBWE8MQmzl6v2FGwoDbnFEK7GFGDe++/
         +Bs9MsSJDp2+WAmXLKJOYMIevl0lW9WAUXwyBflWTqKBSdCFZSM2UM1HZxTOE3Wknj+V
         pty/nTB4JFJM7mh1drXSOO0ZqLEzU8ArCqDm44gYOjJP4uuLkSWyi4B4ySTqOxWbDX6y
         hwuXFLFUuHgAZThC94SOGEK30UU3OrVZ9V86XrGwly0yUwBEFgSYTEVXdB1zh/jZAfhe
         O6VQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1768838153; x=1769442953; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t+CVQOz4f4pv4FZJxEWXVriYAxqFNoe7HY/c+6oYXd4=;
        b=schGeZFVuA7jltAee0gT9mB51g49bhD0ml+kcfmcVxqDoFy1Yvd3RjXUmb/tgsNt/a
         dbk0yD5f0OQ/fZ/A2Uy+8VZoGzWDK83eh8zHQ6b/u7RMMwkY8GoF2C0X4Jj+gv1GJRC9
         OwKPAqmBi3OCDjcoVfmEmcXlyFpG5/X0l+C3LpzH4CvDcHsHJap0J2gjmWlG5t5aujhR
         FLCCjHZoBkLksmYOJpNvEBWnNfGx16ipaekec8Jh+9EiuptIacnCsEeYeApO75KKRr1b
         Vt5efpZMFVlrr4qXbNSTq6supoC7R6AHSfrkf/ev4dWlRbVU2Ka8s3YfEp6VNjSaATlD
         DAng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768838153; x=1769442953;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=t+CVQOz4f4pv4FZJxEWXVriYAxqFNoe7HY/c+6oYXd4=;
        b=aJUXzlInVVb9+rAF5in186xgscwcbQjMnJ2RJd+SAqckOdCZ7eDXexgwIYkstZa54k
         D6wZdRGMAGKPh/KmjoCfR2cXuRE+KZfrSchM5KIgAbxZj1TFxLEZjevWWcQVWNaWx8d4
         y2m9uk0wVjqrQIUNGyc2qyGw3vWXlftstQw4CDFZnaR2f50YaJPGLulDXK7GChHI2B24
         FaTDv+tI/UN+8KvFtZOw7Umrwg+b+qmpcC5Hhj0I4/Dv+BjmMLe89sXzoawGNzQrAUIU
         L1YwjU7CaAKydu3OFOhVZRifV4vV/Yh6Vg7MDzP+mReZpzCaJ2R4m+tv8wEH4rBuG4Zx
         CW+g==
X-Gm-Message-State: AOJu0YyoSQKj7yltnYKwG2XcwZIKco5E6ODe+RGpos31G3lYK6+cj5K1
	3WoltaBRcATPNB4Bzenl/traCdQpZJfZC6K8OEqdl6tDrZRKwcLJoS9S/6zSvNn1ZYoBtHA9Ni4
	1IwU13f6geQXr026lzrfEUgcDh/LzSxvzraKV31BeI48U/VCKGIfWtGc/XOA=
X-Gm-Gg: AY/fxX7IxtBsID3S/q2wx1OpuQyjC1Q+zbMOG6lIcITs6YSD4bBXbLDwnhIkFwLBIQk
	ONUBxB4g9wATRy3QnlDp1K7gZuzK+lH5HC2ivVrSb9cHaZRw+uYboWA0lFQDEICyYTkQumFa8ru
	BypjprmUBrhwIgJn+xEevCDTJg0cIKe/q4xDCvMkv6vHRP18wQnGwMe7MLx4zA0GzYy7nc8oJTi
	ebxsYlzZ8UBbdAWeuaL6hjvVKL9LNnrBIwdH85Ll3DXWmHsXdzRx3YSRRenaxYBZAjYCp4=
X-Received: by 2002:ac8:57cc:0:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-502afaa0b9emr21378741cf.8.1768838152806; Mon, 19 Jan 2026
 07:55:52 -0800 (PST)
MIME-Version: 1.0
References: <20260119142246.3821052-1-smostafa@google.com> <20260119142246.3821052-2-smostafa@google.com>
 <qu5oksvcaytolppeeale6rwf4bzvckvfdg3iw77kowrg4fn24a@p4hmieukkttu>
In-Reply-To: <qu5oksvcaytolppeeale6rwf4bzvckvfdg3iw77kowrg4fn24a@p4hmieukkttu>
From: Mostafa Saleh <smostafa@google.com>
Date: Mon, 19 Jan 2026 15:55:41 +0000
X-Gm-Features: AZwV_Qiw2HdJaRcL1F81HFaiwCNZCPdmUTScO3KLcBRCPXV-fWTgDvtVV_i5AzY
Message-ID: <CAFgf54pFzyAj5MKBx8xcuME-BGGWS1ZZLkw5vSgN8sGPftq88A@mail.gmail.com>
Subject: Re: [PATCH 1/2] mm/page_ext: Add page_ext_get_phys()
To: =?UTF-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, 
	surenb@google.com, mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, 
	ziy@nvidia.com, david@redhat.com, lorenzo.stoakes@oracle.com, 
	Liam.Howlett@oracle.com, rppt@kernel.org, xiaqinxin@huawei.com, 
	baolu.lu@linux.intel.com, rdunlap@infradead.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 2DDA2C0007
X-Stat-Signature: 7gt43id95xuqngsqza1ycpm3bfrk4oki
X-Rspam-User: 
X-HE-Tag: 1768838154-266835
X-HE-Meta: U2FsdGVkX1/F8hYRCqZ9ftA49WC9U6nc/XmnodNeh5+DDQBYHhoArTm3a25GDd02xU/K7hvkuVeOpblJAkdw0QTD2JkUt/BipHiTj7qKQ+xJl3ztkITxiqib9v4dRujHXzDRfISCCX2VvmtAgVI0+R33ZwlWfrmEQhnQv7bGdyhEtXqoMzI0YqnIZBu9BHjSXdU0Dh4HklOIgVZYqJXJr+9bLAKBshq9vptQFvL0bEcrEFSec0PCSUxxKEDJcAmFHE02Lphg7r2AL40HoDE3HjbOxBNUy/OzMT/uO6AkiHhlgzvv3D9xHzFhwJ8ocEd9qIl2zqyUXxrU7BPyC+Xf010EoINH9mc6EuwTYZdCDGbV+msvdXoByXtyHmxa3kxvhHJPuWaNK3G2TFphfE5xqpdx3UBQtTaUpLWMalS8w/iZ4cyXshOlVsA9Qh/QyjIEnkRPBUllvmUmdpMIZU6XV7jztMSvO/hzfs+rxWIt8yCs0LN3ZDvX7mEGp3FpuOME9rkzpVwRN+2I3hPC6j/RlvThG0WZlZAUsGbQU8pYLq0It6qduRH5XGRPKAPfNocDVRyobIlOxaURxsvT5bPE5krLcZ/a72/GaQBI+cdK8xF0dWVWOjNS1C/zpO9sFKExIAXKA8mX8+qp6rGyRdfU9RUKqSbh3czDofhS+/MNY4ncuuwAv66N0U9vcn1tBTf80RDAsna5dhXxy28uq7uSHALZK1XGh5FfWW5WP3eTFFXIbknMN5YHv8XyRIDWppJksEzk7yXnMOJ12kZfz/WIwlqDpcEkdT+P1X0QFjbkEoZp6vzU9IZMxJLQ83G7f+jDhWHhG2fjSicA0sIIRHP2d4A+8N5FueO/Nd5PtegbVBp1GHdlCgNA5gvaPpeLGSkHJhl4YqVMasdST3/r8ZFHqJy5n1yY2sKZJCtnjr8U9XXp5VWU6q/UcKYnKtc9ADHYZlNzwGxsz8vSd5AEFCU
 UimuIlYO
 mWEwluksLF2Dx4SXws3pb7UIOnZcrm5zN2PoswxYjE6gRDS3nsPiMhT8uxlm0GjoHZQsLVpbM/iJkQp6sliycuErFoKI8sn79YfF13yUCq6gjAbQTJLKMELKHK6qaKm7NgliqIDTMkbe7GZshOpNMuqnuc1CQB7EzDhkFksTRVaDMPXRLYaGBjvLC/qMVC1LEDii6ZHQZs5AQufK+q6ISpJjrgBiTozMI9A5kVPvapDh1knwYhDsbEjsc3em02t8Yj2MoSOIsAepKmoPg/dRwUlPbpAElTaKMGXpfb57sgPOO7/8I/A42+bC6DjdyT/szSB2SvOjVVGjdNqJqX4ynr/kchg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.001008, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jan 19, 2026 at 3:49=E2=80=AFPM J=C3=B6rg R=C3=B6del <joro@8bytes.o=
rg> wrote:
>
> On Mon, Jan 19, 2026 at 02:22:45PM +0000, Mostafa Saleh wrote:
> > +static inline struct page_ext *page_ext_get_phys(phys_addr_t phys)
>
> The name is misleading as it indicates that the function returns a physic=
al
> address. Maybe name it page_ext_from_phys()?

I will update it.

>
> > +{
> > +     return NULL;
> > +}
> > +
> >  static inline void page_ext_put(struct page_ext *page_ext)
> >  {
> >  }
> > diff --git a/mm/page_ext.c b/mm/page_ext.c
> > index 297e4cd8ce90..5fe65a0ac4f3 100644
> > --- a/mm/page_ext.c
> > +++ b/mm/page_ext.c
> > @@ -538,6 +538,29 @@ struct page_ext *page_ext_get(const struct page *p=
age)
> >       return page_ext;
> >  }
> >
> > +/**
> > + * page_ext_get_phys() - Get the page_ext structure for a physical add=
ress.
> > + * @phys: The physical address to query.
> > + *
> > + * This function safely gets the `struct page_ext` associated with a g=
iven
> > + * physical address. It performs validation to ensure the address corr=
esponds
> > + * to a valid, online struct page before attempting to access it.
> > + * It should return NULL for (MMIO, ZONE_DEVICE, holes, offline memory=
)
>
> It should?
>

Yes, I can make it more definitive as "it returns"

Thanks,
Mostafa

> -Joerg

