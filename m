Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3CAFCC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 21:55:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 92EB06B007B; Mon, 20 Jul 2026 17:55:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8DFA56B008A; Mon, 20 Jul 2026 17:55:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA0C6B008C; Mon, 20 Jul 2026 17:55:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3B4B46B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:55:22 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 97B20402E9
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:55:21 +0000 (UTC)
X-FDA: 85010511642.04.BEC68E1
Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	by imf03.hostedemail.com (Postfix) with ESMTP id A5C4D20004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 21:55:19 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i5Njji5u;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784584519;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9mE0sfVA6cta9/M5CvPkkpA0kKt/DbFANSsjRo5aapo=;
	b=NsfEpl91QvWg4WzonxYOf2LgN/CAtbg5VaryBSwv6FKFxsWu08B5ogTKizwUdKrHkyYdsI
	uCx44pIe8nS47YiNC64NxGB6zVP9MlNlxSC/BquNVDP1KS8Ag9KWST05JH3J/YarkVtmxV
	eoXqMLn+93pND4ieSPH7Tq+lrypjxPc=
ARC-Authentication-Results: i=2;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=i5Njji5u;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.50 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784584519;
	b=BexAKOGPQ+nr8Fy7DCniVQreHglFA0Ym6sucOeisLm9Vi5N12VW95CSjA7u3M6TvDHwNav
	9mLGPK6crIyzY+kyX9ZtzACCZhlNDkl/RbdfLmk2ISxI0WcbK4WMUxQJyZC1rqX6muL0yz
	I20GOO4Y+LK6hbNWu1FN+xUVlbBB/7U=
Received: by mail-pj1-f50.google.com with SMTP id 98e67ed59e1d1-38101f85591so3514742a91.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 14:55:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784584518; cv=none;
        d=google.com; s=arc-20260327;
        b=dSyDU4xF7AZ0/cenT04QN95+m9TzqVBXf2Uq1SW1Xn0ltoIOaow0L3kDrV1mR/7oOm
         tvuhTjhHpwWwo1Hb6B9ml0Uf4441RoaYK6KIOcQeRh51HYjNepBU0Mi9240C8oc1s2tW
         rHKiuTrbN8P85uHvfqu8IzLShSgjWmk07qfjuWha7NM8kY4FIY0QMUlHFP87VxSIIHpa
         GrFm1g3fRnEqRwPJt/ZtW03Sd3QYEGhtEc5udisTbK6T4PCtNTMtt6w8/LxdP3fUolf+
         R4k2EmhZG07H73XqJ86Kw0P4Q2y6DEOVxcmsZap5LTNWJ1YkoJHKLTSp3rjmqceVcDK0
         qEGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9mE0sfVA6cta9/M5CvPkkpA0kKt/DbFANSsjRo5aapo=;
        fh=KMUXFAbJXaRFLxEPTmmAg7shuMILBNck8IVoRcKx/2M=;
        b=sUIRZ3CBAEu9cF7Kgq0liGg+SUBqErm/j7YU/vYELU6lWynaKzz0eCUZJYnyfwS5KS
         ZYafF5KRLGV7O46d2j/NWNT0QAfN4PDWtpKiKUF15fCYQghJ2FS89GFlEaT8uYgufl33
         8MXvKvQKpf1x46aKzzn+gnY56QXgKCGLPdjukL11bQjziLDLGmbkB7tX6tWil/O8zXFT
         QHzKjUKk62mMHGcVdsPPUol8Lgjcq0AeOJnBLvAGQ+c66OSAORkhh/U4+pw86jqq0ne7
         yQBOqHLBnitOAl1vE8Pxcd6Euvcu4v5OuehjM1rWhAkODCHO5puy7H1LpDjbQWyP9zDw
         waBQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784584518; x=1785189318; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=9mE0sfVA6cta9/M5CvPkkpA0kKt/DbFANSsjRo5aapo=;
        b=i5Njji5uvKxVGKFYWB66DElJ2zBo7W9fOSXfMQ0ej91GHZwPkhRwthP5xUTtjPux7l
         AbnblsYgsqfiCqpGSu3VqDsq2Y7v2Ui6UJjGUew5QAZO62pP7oKEWwRnC5+t699sXWfS
         VAchkvHISxpx/qHdBMmOnYpAcxoBt2tZfQe7XMPny8QIfEVuAqXmgGgDpeiOw64Y0QDk
         VhmeIQ9uffq5/Dgjo6vltOtyq1LRmWziu4s6smRrT5ZQNeF5hR+UZ146uqKs5g0/Uawy
         dHqXwj2tlhQ7ZFqze6jpmWppnR9umzDm9BajqpaJUzqBFAAQvb/c1kFBx/C1bY9dcF1b
         HHMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784584518; x=1785189318;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9mE0sfVA6cta9/M5CvPkkpA0kKt/DbFANSsjRo5aapo=;
        b=dOBLI8lVLMEYp3WsU0OxU67IUrxzpn51dqLgP5KM2TLCaU6UV1YG2WXT05qzreBAYU
         VB0cTR3toqYO9Ut0zE2pJvOH0yzKvHgVs5u4U95dF+u20xwapR83FH0NsXak9dAOeRr1
         27331gs7fYUIht2n9hda+b+8otfHk4UbufYEgWCr4tCYSEwhCszgyQeLUUxD7mbowKwZ
         vZJ1St1So4NNyVYgwrCRKJ2SM0sZN7jRwH1Ft2lrourJpRBDCWj1CyLe3Gef8ZWf3PsH
         vmGfpETYoO1vpd5VVU/vR6Qp1s8UzxDI3LQL77mPxuQKhqTPSqgwHVcBGkMbr9I53RWe
         gcsA==
X-Forwarded-Encrypted: i=1; AHgh+Rq8sQLqLfMA1Cx2ESzmiEpaypDOWd34UeKDPPMA1BSe5x+sBF0wH3/orfUuI2XDXm4LFREgswWuqQ==@kvack.org
X-Gm-Message-State: AOJu0YxCoKRE+4prvDHJKuxPWGMRRfawQW8wIzPgbyPhi9yJtXQ8ygmf
	MqeI3lOQIWGkH/7gBwvCJ/uNjMPtKeK0asQQN6VlRQpCxHVm7dRcAP23DCDguaG5LqsuPora/Jm
	GwuXXh1qKd7ohBKs3F50vVVtjIZ0BYxuL8FCit+9a
X-Gm-Gg: AR+sD13w4vRBGL0O9EQiOo066Z9eUO8KAdmLZ3mPK4MBkvgSxKJHop+hyAZF/hR9FB8
	FhHDqs6PsIgvOSwGT1YqogglQSQyIvhyJ3+RPNYBSKeLx0BBS7NVm/stWnpgKP95A2zZ8uWOQEI
	g6xiZ64/7Ls5YNXnDnXuVjbMQjBFR8i11y10RvgDkGBv0XvOK9hDVW8OXGoAGCe6ER4Mv4+YXPx
	BzudwUU3EIxkKRyz1VkM4ekiuD0qhHfFez21SMwMWSrPeiGo6lrllBTm2rNRPxHDgN4BdHI
X-Received: by 2002:a17:90b:1d01:b0:380:8bb9:aba9 with SMTP id
 98e67ed59e1d1-38e3d13426cmr20701271a91.3.1784584518042; Mon, 20 Jul 2026
 14:55:18 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4>
In-Reply-To: <178432481253.189683.3297727348836286619.b4-review@b4>
From: David Matlack <dmatlack@google.com>
Date: Mon, 20 Jul 2026 14:54:51 -0700
X-Gm-Features: AUfX_mzVY7YuVDoFqhrPV6EULV5udJxArm79VLoT9W377bOVTdCDKuzAWRnUCOk
Message-ID: <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A5C4D20004
X-Rspam-User: 
X-Stat-Signature: 5t6p8yf7sfydortohep88k1sxsyjxb5o
X-Rspamd-Server: rspam04
X-HE-Tag: 1784584519-424974
X-HE-Meta: U2FsdGVkX19rIRnusK0v9jBv7tw/vDh2RO5NX8MSWSj3VeEIUWJMPjqDbgDrAXz/bdilubsCba8akFcd86zGHqHoTLIvexg82VIPP68L3MRv+J6rSYT6rDPNK2hp0noa4zd6fMr24NrJxBaToIBUEW4UCjgRervTEWKCK1Jnu7cNJMYIpYqU195RdLkFWbVe98/BXEI+v6ygUDXmaarb0LiUEVAonU2ZrqD4dRx8PfTeMrz+ZAt27perEDNQAHdwFbrocZBY5If+F3g7bKrGbMmkz070qC1BKpEIO8POs590uDDXyU8QQrxYzf5lLlbsuKL4WECkjR22eM7UIqgkqXZW8XdB58vpuDGcbgE1waEOMdMrSZ8hrO1Kq30zs4yvn5/UvDY8Jh69trmHAgHEXIucUJGU+i6st0rdfzOy5FqUYLXL6+Z5ZsFM6UAJzjIyfRQu06eEITVattJbl7+unFOyQWQy+nYrE6vhA2FmGDj2/9fXuWxW45PK894WPD3gTYtSgx1n9LZChflRm7P7uEHQfdj6qLO/YszhiK4FM7qD/0q3WTd3/AqZRVV7ZgNkXAJHPDWk/mYzthq/ID15U852EM7jZfEJVRk8xSZUqcRMRgt5W+nprLl2/shztzD3KM+zDky4PLW2tX7spfh5B7romb5bBtAc+Sn5rbuofksTFRwpsujFmzVTpvIL3vV65UNhW0pd6fG7g/06CQSnF/MJ7mZMVQaTvIYvyiRNmfrjW4VaypjPQHQTw+o62DxzQRkkAaOLHTHTwPj84gTKv2qoplmCfDVicwLHxV4JY5Is0rUuWbOGGY/LTuCBFMMHrsADxR6oeGpFHNEMF0id6zsUqSxeXn4mH7i84+wV36/Jz1T3hVB0EL06c0X8SAo7b51V8oeYXY1EZqOh9Ad31SWSEe5VrolEX2jnkDcveTmouc1m9wo3+VLIZCyw+rJE95ZcB9mEDqxMy9iJe1U
 I7yia5jZ
 lAlnAB9fZsP6DnsGSFovNoHoU4V7Xpg6JKRhc01m0HXAqrnW+4vWBAlzYtB/9Bi6r34FdChLZvkNLI/dV37MPIxbYu9F7VtgsctvdtdC4dePtSzw0uQNXEiXQZtqPrzy+j4IK/qCrOlS2W5lPXE27fhFQScC/3DJbZ1EYhPoh1jz4KYvDI8iB87zwSr9wP90Tmi4ghEJq5LsLyEjbE8UX6DpXcozV11hjHijpqh2A0hZN4qE1WWI3scnfLid76GOH66GyxgR5Vgz00BPDKLMJTXU/p2VVilHKje7IK5ukl9CH3HH/fTQlKUmIYRihL7sLAIFW
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 2:47=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.com> w=
rote:
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > index 03075ce06ac9..df6a02240aa4 100644
> > --- a/drivers/pci/liveupdate.c
> > +++ b/drivers/pci/liveupdate.c
> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev=
)
> > [ ... skip 76 lines ... ]
> > +     /*
> > +      * Hold the ref on the incoming FLB until pci_liveupdate_finish()=
 so
> > +      * that dev->liveupdate.incoming cannot get freed while the PCI c=
ore
> > +      * has a pointer to it. It's better to leak the incoming FLB than=
 do a
> > +      * use-after-free if driver does not call pci_liveupdate_finish()=
.
> > +      */
>
> I am confused by this. Each preserved PCI device must have an associated
> FD preserved with it via LUO. I.e., vfiofd would need to be preserved. If
> the vfiofd was not reclaimed, and finish is not possible, that vfiofd
> would still be owned by LUO, and therefore PCI FLB refcount would stay
> positive.
>
> However, if finish is possible, and this is the last vfiofd that is
> finished, FLB will be freed as soon as the reference count reaches zero,
> which I would think is the expected behavior.
>
> What is the point of holding a reference here, instead of only for the
> duration of FLB access, i.e. to make sure we are accessing a valid data?

The duration of the access is from here until pci_liveupdate_finish()
because that it when the pointer (dev->liveupdate.incoming) is
cleared. So that is why the PCI core holds the reference from here
until pci_liveupdate_finish().

We could avoid this by deleteing dev->liveupdate.incoming and,
instead, fetching the incoming FLB and doing the xarray lookup every
atime the PCI core needs to access the device's incoming ser struct,
but that would be inefficient.

