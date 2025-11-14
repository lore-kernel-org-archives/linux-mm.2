Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 42C25CE8D4D
	for <linux-mm@archiver.kernel.org>; Fri, 14 Nov 2025 16:42:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7C53E8E0028; Fri, 14 Nov 2025 11:42:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 79C728E0005; Fri, 14 Nov 2025 11:42:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B2C18E0028; Fri, 14 Nov 2025 11:42:47 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 5A2E48E0005
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 11:42:47 -0500 (EST)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F280713AF47
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:42:46 +0000 (UTC)
X-FDA: 84109781532.21.A33A6B7
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	by imf24.hostedemail.com (Postfix) with ESMTP id 0763B18001D
	for <linux-mm@kvack.org>; Fri, 14 Nov 2025 16:42:44 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="AUyJsr5/";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763138565;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hNYC6T9taYLQmC4NDLJeJFJYG67obOWlv+u1sIQ+ETY=;
	b=0x8ERfe0jLt0i152MJv3BjG61oADu9C1aHJpo5CHyU11ZVdY3vnjvag+ve6FYGfybxykeq
	DTZyRKFg1DgHzT4yyzendMlbBhtRK8/G5q2A48RKhoWTLXScRHxEiQ7Q/6VdaLLJ2NuCzN
	KI0qmyCRmwpNOH7HHA22b1ZmD7JBekA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b="AUyJsr5/";
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.208.44 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763138565; a=rsa-sha256;
	cv=none;
	b=n75i/s2lXpYaxAselipIWiKpJa2s8TyTubJ0+rPrRdN8IZEuYIXeq2LKr0FpayYRrCHu0f
	AsQPf8KjNjtdmYLOLMIvtEi+CQ/RtfFkwd9uPVsCHWV1UfDwX6/muGE7HVfyIVcmXOtJXY
	wzSh+NEKlGD1fKOa34uF2L3/s+Adb/4=
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-64180bd67b7so3098808a12.0
        for <linux-mm@kvack.org>; Fri, 14 Nov 2025 08:42:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1763138563; x=1763743363; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hNYC6T9taYLQmC4NDLJeJFJYG67obOWlv+u1sIQ+ETY=;
        b=AUyJsr5/Lz1Jp37cBGrGtiqTbFvwf85pQOiHP8N/Yh+L+OrYuKzk48pryQ2lDvuwHN
         weJHgOH3knVqfzk0nN9F36OXWqNnbJ3/cO6EpDu3uzana1DFXuFTyqxDju7KtlwRXFOf
         G/KYDFItB1wYm1wAfNwus5ht4kVfAijHJ8g8rVYjDBz2Nw8UWzVsu51GiQPT6Orbjudn
         1tDkK0IaCg9n3C+7Htw1PKsK+3AjVCSs1/h5Ed7H8M/5vQLlgunWSIw4RBuUyJa0joz0
         6rnBgomIcqnpOxEYLmrvjwthgywrOxkXjt3IIEc5qxKWAE7gtOmlZBhab8yf3aUWkLQ6
         0wzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763138563; x=1763743363;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hNYC6T9taYLQmC4NDLJeJFJYG67obOWlv+u1sIQ+ETY=;
        b=NIff6qRkXchTNxu7R+YdQKQ0SajPJ7frZz2bbprxTG5C4OaMNs/wcx5ae396ZExfr3
         hMSgcFNxjV3/tVfihVQR+/x71ffIMUd0ilFKi8QukJ97eBmz5nlR90c00Q8RFpIhomvW
         oJUpj92f9/7+hbqHByhWrdJE2W7qX9utmjlxov2xL0rW3jPv0NKFF52Up86mKmWBpIoP
         Bje9p30/WNlaWQHWBPndQk6sRPSoKlF450TJz6XRlD56RBECHSUtN3egmZI9TNh3MpL1
         j8YbJusHW9qgM4qXxu/C1XLxzXF2FliQ+GwrulATW1ZLgx9skhKxqMtR5rqNPJL2OS5Z
         Z7yQ==
X-Forwarded-Encrypted: i=1; AJvYcCWHmahdAc0On2K0PAW8GkQtWGgcfCPZciQ8gHNKV4+9tPElJGn2V9vr72dJdgQkutZDIH8Sa41r/g==@kvack.org
X-Gm-Message-State: AOJu0YzrZb64jZeAr1aVmHNPquT59isWNH4AL3MmCncB9G0YoeGT/pFM
	1yq253PPIRX75lOkbkm4a8uEZTuI41J5gyyhvUtF0ao3/MVeycBu9pm1MDuZObdbiIzgm0S+M3b
	MjzRfgLft46s1qVChfwRvS+/dJxpozVIUUKfyu+28cg==
X-Gm-Gg: ASbGncvNtCpmOiPjwPgHylPYVLYTRA7f4MqhO1CmHn9DT/jwTY/2tVnIePKz7r3Qd0R
	uzzLiCe3cmn7Hz+mBavMxup82xI1vxraANxqnXwzrFTnZEPGVvWUX1j8mU8xxns/HJz62ljIju1
	tijcQ3FRehTvX89EuDLdm9n++RTDYKi2tiV0/qnW998Ng7G27GpQ8/oq5WXb6PUxadsME5LlgC+
	zvacJYcqY37hhnGQUtQd6cjvURA9VAN/KHpqOOR24470Nx284rDVsgxsIJ8GU+PkSROIdGk3F8v
	6Jo=
X-Google-Smtp-Source: AGHT+IHlfh4YdqFOb4m8lf+EaR+1dZhpIJjcSDucXM3q8/9kzn/c1d1ehTKfSLxh6hZh8WmQ8CCr+tqptNyxuPatxRM=
X-Received: by 2002:a05:6402:3507:b0:640:fb00:9b0b with SMTP id
 4fb4d7f45d1cf-64350ec2ff9mr3541795a12.32.1763138563523; Fri, 14 Nov 2025
 08:42:43 -0800 (PST)
MIME-Version: 1.0
References: <20251114155358.2884014-1-pasha.tatashin@soleen.com>
 <20251114155358.2884014-10-pasha.tatashin@soleen.com> <aRdVn-e3Wu_pFdmZ@kernel.org>
In-Reply-To: <aRdVn-e3Wu_pFdmZ@kernel.org>
From: Pasha Tatashin <pasha.tatashin@soleen.com>
Date: Fri, 14 Nov 2025 11:42:07 -0500
X-Gm-Features: AWmQ_blP7H688ljOem3Nsegg0ERAgHCS_X90A9If73ZSR4mI64llwOx6i_IsE_w
Message-ID: <CA+CK2bCHoHRX9wM+hF-G5G2prVYdDSWzLETPmVXooKsXda5xbw@mail.gmail.com>
Subject: Re: [PATCH v1 09/13] kho: Update FDT dynamically for subtree addition/removal
To: Mike Rapoport <rppt@kernel.org>
Cc: akpm@linux-foundation.org, bhe@redhat.com, jasonmiu@google.com, 
	arnd@arndb.de, coxu@redhat.com, dave@vasilevsky.ca, ebiggers@google.com, 
	graf@amazon.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	kexec@lists.infradead.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0763B18001D
X-Stat-Signature: k4fufijx88mx8366ho7oqheznc3osakk
X-Rspam-User: 
X-HE-Tag: 1763138564-6100
X-HE-Meta: U2FsdGVkX1+8mGx1A5WDbU22PjvhCb+0zo3L8fMKx4/c46gHWSNrbhyutDxUr4j3/sCy+oVkJxzixzgBQ7wjpvBCzEtaVIkBWhTkL695B4v5Ta0eiUk7xCRIbDNPvACoYHiGHDS5bXLUxEwCvHUjohfNykUJYndFyP/Dr5Fgga2IQMNfoF1rppuVEBL1Gcb9iflJTCSx123+sz/h3ltHOT/5WM+9CJoKXQ+od3IzAf6pwkpip3Hz0AnzXh/CkVdEMWPDX39YOkLfAoyLBrSAs7ExysZOo8+5h6VyKMG4x5L5sUuuH0IdbTU57uT3ovMYC3y96nUhHRvtpO59ysmQQC7PoGTMAqGm7Kp2IxyGrQ3uAB6AdQmafRmfxpcw1jcxxQCOc6qqZvPLcIJ/7tAytYnnZT8HX4KgjH/CLjv6pocd2/iDdtKx6ozw5j+L0RNvROAzXQ8QH8WZagW4tRCJxjkAMdnZtq/1QtSWkGmEh/I4bpryJh2q27fEj+hjwsG+F7bP98QNucUGaEIyfoVFTywqi/PxZpeALkacx6pk23PwvhUiWJutx5mkjNE9wJVEvqRgqndbweIG89X0MQVR9M/FHPcusI6oGW/n0y0G3KuHabkL6w5sRhnsoHvnRuUrzOi9Q1rRTdnEw08WgzrRjDU1Y95WrJ+/sdugqWy1p2tzoeoT/0Q+2L261dipkLa+pI1Tx/qBE2WFlQGJQkmJWjiMSVtrQ4EDGBzA6U5T01kxiXtS6aF3t164mwuZw4rd2KXiPSXS6xPAN6Ui6eUmHHjDysFjN+Lp4yYuCjpq+bjtV1yG5KkJ8Zx8IleK8nO1joVbmVd+kuCSCH+U1vJ13/RJ1NfFN+0u2Q+McTf5XfXysFYcrPHLmGD6KWlD/WKMl04EcyfMxiXgSQPTYPOyEA7acYcL1Eu1SBkipsxV9PuuBcfgUB5wUjGlplSIEoYlTZdP18IRhuPr/3UN67Z
 uGMJYlI9
 Z4SbXafiOI1+K+/5k6Pb8JasxS9j4My9u2/ZtGT2KEHYih34dWB6ZyCJk6XvE9ATG5lFVE+CRZuH/sshWP0H3Mb5wqzw+sBfSO43PO6EymRlKxYrLSONrgpG93HocGqwYysHg+ujdX+sLdVREObP4WrnzQW10qr2DHv/BZcp83YhCVfZcPcGoHhcu9qm5r7JUKj1W6wuZZrpUvbtq/jIuJVViLqQghrFUwvOmudbS2xdjDdLUuByX+Qhto24iGU5zV3nJ0RsjWqAcxfBafDKnw8FwKw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 14, 2025 at 11:15=E2=80=AFAM Mike Rapoport <rppt@kernel.org> wr=
ote:
>
> On Fri, Nov 14, 2025 at 10:53:54AM -0500, Pasha Tatashin wrote:
> > Currently, sub-FDTs were tracked in a list (kho_out.sub_fdts) and the
> > final FDT is constructed entirely from scratch during kho_finalize().
> >
> > We can maintain the FDT dynamically:
> > 1. Initialize a valid, empty FDT in kho_init().
> > 2. Use fdt_add_subnode and fdt_setprop in kho_add_subtree to
> >    update the FDT immediately when a subsystem registers.
> > 3. Use fdt_del_node in kho_remove_subtree to remove entries.
> >
> > This removes the need for the intermediate sub_fdts list and the
> > reconstruction logic in kho_finalize(). kho_finalize() now
> > only needs to trigger memory map serialization.
> >
> > Signed-off-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > ---
> >  kernel/liveupdate/kexec_handover.c | 144 ++++++++++++++---------------
> >  1 file changed, 68 insertions(+), 76 deletions(-)
> >
> > diff --git a/kernel/liveupdate/kexec_handover.c b/kernel/liveupdate/kex=
ec_handover.c
> > index 8ab77cb85ca9..822da961d4c9 100644
> > --- a/kernel/liveupdate/kexec_handover.c
> > +++ b/kernel/liveupdate/kexec_handover.c
> > @@ -724,37 +713,67 @@ static void __init kho_reserve_scratch(void)
> >   */
> >  int kho_add_subtree(const char *name, void *fdt)
> >  {
> > -     struct kho_sub_fdt *sub_fdt;
> > +     phys_addr_t phys =3D virt_to_phys(fdt);
> > +     void *root_fdt =3D kho_out.fdt;
> > +     int err =3D -ENOMEM;
> > +     int off, fdt_err;
> >
> > -     sub_fdt =3D kmalloc(sizeof(*sub_fdt), GFP_KERNEL);
> > -     if (!sub_fdt)
> > -             return -ENOMEM;
> > +     guard(mutex)(&kho_out.lock);
> > +
> > +     fdt_err =3D fdt_open_into(root_fdt, root_fdt, PAGE_SIZE);
> > +     if (fdt_err < 0)
> > +             return err;
> > -     INIT_LIST_HEAD(&sub_fdt->l);
> > -     sub_fdt->name =3D name;
> > -     sub_fdt->fdt =3D fdt;
> > +     off =3D fdt_add_subnode(root_fdt, 0, name);
>
>         fdt_err =3D fdt_add_subnode();
>
> and then we don't need off
>
> > +     if (off < 0) {
> > +             if (off =3D=3D -FDT_ERR_EXISTS)
> > +                     err =3D -EEXIST;
>
> Is it really -ENOMEM for other FDT_ERR values?

In practice, yes. There are some other errors like format mismatch,
magic values etc, but all of them are internal FDT problems. The only
error that really matters to users is the -ENOMEM one.

Pasha

>
> > +             goto out_pack;
> > +     }
> > +
> > +     err =3D fdt_setprop(root_fdt, off, PROP_SUB_FDT, &phys, sizeof(ph=
ys));
> > +     if (err < 0)
> > +             goto out_pack;
> >
> > -     guard(mutex)(&kho_out.fdts_lock);
> > -     list_add_tail(&sub_fdt->l, &kho_out.sub_fdts);
> >       WARN_ON_ONCE(kho_debugfs_fdt_add(&kho_out.dbg, name, fdt, false))=
;
> >
> > -     return 0;
> > +out_pack:
> > +     fdt_pack(root_fdt);
> > +
> > +     return err;
> >  }
> >  EXPORT_SYMBOL_GPL(kho_add_subtree);
>
> --
> Sincerely yours,
> Mike.

