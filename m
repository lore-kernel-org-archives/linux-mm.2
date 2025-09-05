Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B913CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:59:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8E12E8E0011; Fri,  5 Sep 2025 15:59:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8B8A68E0006; Fri,  5 Sep 2025 15:59:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F59C8E0011; Fri,  5 Sep 2025 15:59:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 6FC808E0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:59:15 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 319231DA8C1
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:59:15 +0000 (UTC)
X-FDA: 83856260670.18.66DFC42
Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	by imf23.hostedemail.com (Postfix) with ESMTP id 419CB14000E
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:59:13 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UAhEBRlq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757102353;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kPcGZxnKXbZjc5LXwo68zrNMzrsx0r/f8oHKhVbqs4w=;
	b=6oi/SjcSz6vx+E1h5Yfcthhi1HJD6z0coj/5txEJdPftqPO5BztR41Oe6hXMBDztd9RcYI
	gvf34Xkjmw1mXnIxSd2Es6CXQso0tyvzgzC7oUvj1P/I2mUqnKzXTMXsd8FoFNCzJMDW/3
	J5ApQk/i3haCTw2b7HTRKKtVM6Q4xoE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=UAhEBRlq;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of jiaqiyan@google.com designates 209.85.128.45 as permitted sender) smtp.mailfrom=jiaqiyan@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757102353; a=rsa-sha256;
	cv=none;
	b=WcZI9RqfbR9hXXj7aU6FhuNoonaqIT7XCJrfEi7tz3TUmXrCqyrpKYEzHlGm5cuBu1oLuT
	dyIQ4BptXHaaDv2srNSPRRZYnMH/xFMeNfy27d9HglONs0CZAytnoU5Gwg+O2K62Ovi59e
	01tB+p1sy2ombemCL/1NJVTWCtsKk7c=
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-45dd9d72f61so16715e9.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757102352; x=1757707152; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kPcGZxnKXbZjc5LXwo68zrNMzrsx0r/f8oHKhVbqs4w=;
        b=UAhEBRlqN/yUSFOFcvHcSSTT+fYcAlvTEDaecI2P+ZZduBZuVnJS6mpP0gJv4DSCJK
         BElmBnugcuhYKCkF9t1F1LPAsRv/9bkM+5Az2gKIiBITbreCHU9JjwDVgL4DwXZjYuc9
         BPxN7NQBkCYwyDes7NYfn6+kAAyAoQ645+PrtAvknDzMBumCnXEGVGMU3DLIXWUswxYl
         g1vyGkVpVb9pOmAexx3Az2l6Lwe1Q4XHHVrjfijyUgyHlvzqlvRRgNlQtgsw8NyEHFPW
         pxdxLHsbGyHkPC7jf/zPH4/5chOGXOxBGhQ0KDIJNWfIMuNFj7e2FW+F9PxCYIyxkxd+
         Bhag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757102352; x=1757707152;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kPcGZxnKXbZjc5LXwo68zrNMzrsx0r/f8oHKhVbqs4w=;
        b=db2pS2hfn4oWk7JN5JZ63HjqyR1lJqkH6Aramiim74qi7MuDDDizOD45UWQu5UhY++
         5S4KMhBvsrDBJJSW0P7moTWNgxJwk5P/OZCCB64aMUsszUUFqGUs2Zjd2uXzJxXAQ5t6
         MeYJakhf8aDD13OTS6ig6iISX+13RGNazMjUOvXJ6rAlNBU4/NORCJ0kZujYopBhhiIt
         LNywQh4zrL0gDETMmHUnQX9jnKWzdRRPcfL/e87Hemxcj8RwVC2YbEK83ThP1un2brfo
         FuXvjVxZWekGSh0/VlsYe4AKxQcNqrbhKK01M5AEe9nYlG99TzvjRJJbJsVp73tCnIdC
         e5MA==
X-Forwarded-Encrypted: i=1; AJvYcCUoults9Mr6GzbdbuoupM6J7AAwnRRfBE5R1QV3WmzGBtv/XCzWtrY0csBBORpVSw7pa1FH2fZR/g==@kvack.org
X-Gm-Message-State: AOJu0YxPtukLcn4DcpOyX++E5ZXOGqgk5i2Gj8ZmGL3eP5fhrS5uA54d
	Kb6zmQGgPP2mnUVhujOejExHFhYF5VwZpDEMTmfafb8D4AMQsnXmSemzIgwHqF2IXCU1WXekAi1
	4K7mxjlcjcN4PZgG/HJtthUxOD7CRFgLEij5gb6iK
X-Gm-Gg: ASbGncuL4IGGFjlj9VCYXvnfU5hOmXTKLBJBeig32L/Aau5dTygCflHB5rQ3YWsr7is
	iAmpya1zJ2Eczx0fn7B3OUVDGftM9+9+V4johhAevaa5BTPEqxLy2PRuiTAeh55nB/q5fddgjbf
	5E4+oN/aYsmfHcMhZYSqpsI8g88rVaTIMao69KhzrcIdvDrk50aike3foHfRPDXz3DaTlmKz38b
	0EHbuIPUsT0GTV62G8PGrFwmKfQLqZUFEzBh4lkCd1kL4HPqBsh3Ho=
X-Google-Smtp-Source: AGHT+IGS90KLyGGX5srXBtIiKQCUAFaGimJMeYsja8yPWy0QHghibtIhzRV7homXu3nDuj1kGEU2ICQp5naEBqxMPRg=
X-Received: by 2002:a05:600c:8b6b:b0:453:672b:5b64 with SMTP id
 5b1f17b1804b1-45ddda84d71mr223665e9.2.1757102351419; Fri, 05 Sep 2025
 12:59:11 -0700 (PDT)
MIME-Version: 1.0
References: <20250904155720.22149-1-tony.luck@intel.com> <brfqzhbipg35twgv22vnnotbv3t3grwh2dxugvtbgqduuhsvst@f7exibz7i7tk>
 <aLsHh70jI6BGHjaN@agluck-desk3> <bwu744g3qzbzylxvfgt7v4tnf2k2eosqbkg7alm6u5roa7j3bn@gmut2l5227kw>
 <aLspJ5Tpqp4qRDk2@agluck-desk3> <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
In-Reply-To: <cf05bc8e-fc79-49e4-a90a-47e661b4ae69@oracle.com>
From: Jiaqi Yan <jiaqiyan@google.com>
Date: Fri, 5 Sep 2025 12:59:00 -0700
X-Gm-Features: Ac12FXxHINd3qYDaZlwQQ89HLW2T-j_NQxkA_uJ8_hkcYnzLr5gduEyyYyn_TWE
Message-ID: <CACw3F538k+dshTs1_rxbpYoRdFyX3tLYzfaWj-_d7Lq5Dd2Jsg@mail.gmail.com>
Subject: Re: PATCH v3 ACPI: APEI: GHES: Don't offline huge pages just because
 BIOS asked
To: jane.chu@oracle.com
Cc: "Luck, Tony" <tony.luck@intel.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	"Rafael J. Wysocki" <rafael.j.wysocki@intel.com>, surenb@google.com, 
	"Anderson, Russ" <russ.anderson@hpe.com>, rppt@kernel.org, osalvador@suse.de, 
	nao.horiguchi@gmail.com, mhocko@suse.com, lorenzo.stoakes@oracle.com, 
	linmiaohe@huawei.com, david@redhat.com, bp@alien8.de, 
	"Meyer, Kyle" <kyle.meyer@hpe.com>, akpm@linux-foundation.org, linux-mm@kvack.org, 
	vbabka@suse.cz, linux-acpi@vger.kernel.org, Shawn Fan <shawn.fan@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 419CB14000E
X-Stat-Signature: 1dp4f65nnfc6j4ybt6be4ba58go7fosp
X-Rspam-User: 
X-HE-Tag: 1757102353-683966
X-HE-Meta: U2FsdGVkX1+S9J14uVclYFYfuCPBNMrtfnzIpqkfrebnIyybfVueVJVGOWX8P/4tBF+tVFQ0hRrTE9vZL0aBZOlH1O4+TZlMtqCcVpgf49Ygm5JIDfGk80bBDMlc9JfUokJ530xwrOdZttThioe3+/GCXgHAlhFhJFddPxt3fuld2t2iMVTH04nbZ8nhpiJHVd5drWCtysXFHr/3vS3cgV/npY2n/quQ5co9Oe/rrs/SLCtkiUCId4dgNw1TgdmC+6ZX/ePOI2yEXwcfiaaehs3Qc7EeeZgpWyYAd4yEmIJ/ZnorY57nuzwUYzE/lYkmaHPhhL/UoP9WWGZkngN3hwst+gDLM6SEYTy/OGbELEk29KUOT7LerZiORWS8AqJOv68DripTt915cLpiLoVU8rfuKOwieGmldLoKz/1MWKrWdZ2QXg2CwU2xUYRjGpUT4bEjiFF8QLdIN3cZC2mZcsLzddrf1W8Gjn1cqi+0cZLHdU3ZVNCRpj0KDuLYRby73GAEGt9p6rLg5cupBTNiPO6qJN/44wijXNbkXX290MliQuaQ65SrT+QxMjdCjc9powTtZz2a0iZUGT+tCsrH1Q8bPuM6DzmPWeYbzxZPLtIfGENMob/T2AEJVhaZXouWx/WZ6jqAxvlyWvcSuj4of8EP0NVoOlZelrHShTX58VkE6SdM7ArjEb+fEKlmcfkqHELuDbPqPWJFOv3CVHqTCOp9ADs17wvvyPCJ0d101H4Sm2h0ZzW9w0AjMnfttsTayqcOK/LAZqLyLRd58Wrj7ivr6acFDJnh3GESINGqFzlyr7PZqRHsQHKdcYvg+cqvneemy6O5nnJ3Zhxlgm8o387klYe1w/EdIEy7UymMEgPUBYfgv7g6Gpg6vWVrRtnTGrChbCnPUqlFTBuFykPna9zQ9M4i6hgPek0x5bcbL4+cqbZ1jQ/LgElOCj0bzpLmXa7JXRvcZWYRd/2+Yw6
 7E1kqauq
 gy0cmW8Xrw7D23HBG431g3cDwBzIFwOP4/yYbNUqtUSEfB6C2KWjHKC/kt/7IG8sjh5L/zU9fkTii6431iVZzbx49pHqeb2toK0RjGQmwVC20rIYPMBghrCEusrRJRRF3DZoFL+1ji3rVnwCJ2WF0kynx1foC0xt+tUFyRV7V1ic7JdxRTALlJkffiJO7F2TBBS49j9IlJEOAXPCzQIX3Hel96xj9t3gvS29l3wzefYvnGoW3Ewy3pD3+Uzbmci1HynL+VZnF/WG1JqAewplc8YzOl8mN2xbIiDDJSgC2YZhRIM9BgCWyKJlKdcNTWWI66G5L3vtTX33eEiBBFf6KqbUtvD1R19btr5zrrx9hnc7Yz50=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 12:39=E2=80=AFPM <jane.chu@oracle.com> wrote:
>
>
> On 9/5/2025 11:17 AM, Luck, Tony wrote:
> > BIOS can supply a GHES error record that reports that the corrected
> > error threshold has been exceeded. Linux will attempt to soft offline
> > the page in response.
> >
> > But "exceeded threshold" has many interpretations. Some BIOS versions
> > accumulate error counts per-rank, and then report threshold exceeded
> > when the number of errors crosses a threshold for the rank. Taking
> > a page offline in this case is unlikely to solve any problems. But
> > losing a 4KB page will have little impact on the overall system.

Hi Tony,

This is exactly the problem I encountered [1], and I agree with Jane
that disabling soft offline via /proc/sys/vm/enable_soft_offline
should work for your case.

[1] https://lore.kernel.org/all/20240628205958.2845610-3-jiaqiyan@google.co=
m/T/#me8ff6bc901037e853d61d85d96aa3642cbd93b86

> >
> > On the other hand, taking a huge page offline will have significant
> > impact (and still not solve any problems).
> >
> > Check if the GHES record refers to a huge page. Skip the offline
> > process if the page is huge.
> >
> > Reported-by: Shawn Fan <shawn.fan@intel.com>
> > Signed-off-by: Tony Luck <tony.luck@intel.com>
> > ---
> >
> > Change since v2:
> >
> > Me: Add sanity check on the address (pfn) that BIOS provided. It might
> > be in some reserved area that doesn't have a "struct page" which would
> > likely result in an OOPs if fed to pfn_folio().
> >
> > The original code relied on sanity check of the pfn received from the
> > BIOS when this eventually feeds into memory_failure(). That used to
> > result in:
> >       pr_err("%#lx: memory outside kernel control\n", pfn);
> > which won't happen with this change, since memory_failure is not
> > called. Was that a useful message? A Google search mostly shows
> > references to the code. There are few instances of people reporting
> > they saw this message.
> >
> >
> >   drivers/acpi/apei/ghes.c | 13 +++++++++++--
> >   1 file changed, 11 insertions(+), 2 deletions(-)
> >
> > diff --git a/drivers/acpi/apei/ghes.c b/drivers/acpi/apei/ghes.c
> > index a0d54993edb3..c2fc1196438c 100644
> > --- a/drivers/acpi/apei/ghes.c
> > +++ b/drivers/acpi/apei/ghes.c
> > @@ -540,8 +540,17 @@ static bool ghes_handle_memory_failure(struct acpi=
_hest_generic_data *gdata,
> >
> >       /* iff following two events can be handled properly by now */
> >       if (sec_sev =3D=3D GHES_SEV_CORRECTED &&
> > -         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED))
> > -             flags =3D MF_SOFT_OFFLINE;
> > +         (gdata->flags & CPER_SEC_ERROR_THRESHOLD_EXCEEDED)) {
> > +             unsigned long pfn =3D PHYS_PFN(mem_err->physical_addr);
> > +
> > +             if (pfn_valid(pfn)) {
> > +                     struct folio *folio =3D pfn_folio(pfn);
> > +
> > +                     /* Only try to offline non-huge pages */
> > +                     if (!folio_test_hugetlb(folio))
> > +                             flags =3D MF_SOFT_OFFLINE;
> > +             }
> > +     }
> >       if (sev =3D=3D GHES_SEV_RECOVERABLE && sec_sev =3D=3D GHES_SEV_RE=
COVERABLE)
> >               flags =3D sync ? MF_ACTION_REQUIRED : 0;
> >
>
> So the issue is the result of inaccurate MCA record about per rank CE
> threshold being crossed. If OS offline the indicted page, it might be
> signaled to offline another 4K page in the same rank upon access.
>
> Both MCA and offline-op are performance hitter, and as argued by this
> patch, offline doesn't help except loosing a already corrected page.
>
> Here we choose to bypass hugetlb page simply because it's huge.  Is it
> possible to argue that because the page is huge, it's less likely to get
> another MCA on another page from the same rank?
>
> A while back this patch
> 56374430c5dfc mm/memory-failure: userspace controls soft-offlining pages
> has provided userspace control over whether to soft offline, could it be
> a more preferable option?
>
> I don't know, the patch itself is fine, it's the issue that it has
> exposed that is more concerning.
>
> thanks,
> -jane
>
>
>
>

