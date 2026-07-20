Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3294AC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 23:19:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C67EE6B008C; Mon, 20 Jul 2026 19:19:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF1E36B0092; Mon, 20 Jul 2026 19:19:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABC5D6B0093; Mon, 20 Jul 2026 19:19:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6CB516B008C
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:19:31 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D4585120348
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:19:30 +0000 (UTC)
X-FDA: 85010723700.18.60E6A03
Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	by imf13.hostedemail.com (Postfix) with ESMTP id E782B20004
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 23:19:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rtnCLB+f;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784589568;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PYpxNurdbA4XJ/6Vuk5WIdVnSVbgksTgEkNwHBXbZV0=;
	b=vpw+VjiwwAmyGilyrKb28ls7V5O34xqnOWD/SbadKd2/VwfoxmPYANmDhRxXiGmsWefYhI
	lWwi1xycLm0QpKpb8wGPMJXr2GmwNSNBlWsPjcOB9Woqj21CrKbLVnnxj7QxN00RA7rG/v
	CbHxdip1mVrDA8YBIXKnZEWcU6WyzCU=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784589568;
	b=s726DYNrWIJHnemJ/Em5MkUIKz7eMfLqSk+MWaNWdJKUpFEwN9eWO+ba8Vc/uZCUxzJ3H9
	hSq/OzxET9+eSrW3yAgMIhUlOsFpUq5cZKjcoj/MWlz/Fj8ZeKgqXiQUepN7cBuWE9Neer
	6yGfjBERK4vZUBVVrjgyLiIWzt0aHFg=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=rtnCLB+f;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.44 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-pj1-f44.google.com with SMTP id 98e67ed59e1d1-38e071ed6aeso6711301a91.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 16:19:28 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784589568; cv=none;
        d=google.com; s=arc-20260327;
        b=QomNXSd4XmSziMGR2A4YhsfRI4g3pnRY5pTE4oUhuPa5xNrxaTQL7xdm9AjW4Mnlhi
         uF0R24iPo4gPQJk93EKgAHKGS5+q6mbKoGNH7tklvVQZAzVRerjbkJd7euN9ILOuiYSG
         gmLo1tV8ykBO1ZRiOOoOZ1Q8637emgb6T7mTFe3aoWqjLGh0oI6pVI5Inhbssxx0UGfz
         2y1nQdo7nuBlkuyBQjB3SShMEY1njP5/tXlvCooGLeixdv0w3dCv9KWX82hvlzc67q32
         Kho4gxAVoPo74hyPnCboOXVO+pthNF0GHu+aw9pe58EEsouWZyM4dfcbaW5rwQvr/RL7
         mERA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=PYpxNurdbA4XJ/6Vuk5WIdVnSVbgksTgEkNwHBXbZV0=;
        fh=cmKGeqofFutmQiZPH2lDM9twdiMBAl91vNowurILtbg=;
        b=sX9DHJ6hvRJCNW+sLnDlC25efHm0oKKmD5M9Bt3rjhPWactPaZXephCJcovi40ojc8
         qM5c1ARkmVl3Sd3geqeTjz0YiIXL0CGF/wpqdz/v/1tsNTJpHuzZKQ757/NHZDtUK65d
         2QxrppkeUp9BPVOWjhrU8qxaueuTUj7tGpoG/YHsxApndDN/J5eM6nz9Xw6ENOhTozv4
         zVq/7Rr9FIgtKhJgHViOVW+nnJVLbzSqL19u8/v4vQZosJpj9+65qm7WUYhullIvtDvA
         srO3ZZZ4XN4wRJmLfxfhjgMiMGpNXokriDucK1mEx3As3uTdcCPcLUX6VF3tsgSI20H1
         /96g==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784589568; x=1785194368; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=PYpxNurdbA4XJ/6Vuk5WIdVnSVbgksTgEkNwHBXbZV0=;
        b=rtnCLB+f7Oay06umppsWolseLD+UMUFBhvvXRZPyoNZDTwPd6ihLjeSMqT5HcHHMM4
         ZYnG+jT8A7AYVn1TJs8fUhOH9a3DPcRAb4K7GdQFejpZf2ZJ2Fdb/k71SWA3oV7UiRRL
         AZLXbWnnJsDmKicTH9cOF+MHkqsszTScyAG9iLA9ZstNzTgkJcpivTIjipdmOCiOOHFs
         Ig8RQk0xxo3ShEd8D+oTZOprb7YhyrMVetWJayv0PmzLUBFyHi72n6SDnxsqeJwM4WNZ
         R2IueDwUMI4yF77JsNjoONcULXdaF7SF1kICdGuVAH6CMmFVNOojuMcGj27rzjuWkfTA
         xlLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784589568; x=1785194368;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=PYpxNurdbA4XJ/6Vuk5WIdVnSVbgksTgEkNwHBXbZV0=;
        b=giIfl1N4AOiY2HLCshB7u3KXruOn5hp5VLWrftaRNviFzAk1/w4wDbvP42qFz4hIhl
         arppTaMe6l5XB6cFWn+uEjTbBhGnRTA8kYELsHedy/wm62Sxiz9PSu3rS5kMs52Q5m7i
         QFjbtG9veyGB7gX+Th43HL7KWndtCYSI7UKTZ0JKZmTAUh0+Y/4kIMY2Z5znIxppHxoq
         NSr2cjyLYckh2+qscgzvGyTQa1lUdOLVfP5teBHR7EyINUsB8+frD2kRLmLsNidUSuAV
         apTrmGh/rtFq8a00rqq7cfhtoBw8nTa+3oZ4Faiw2rNteRgx+5jiMVqbW/WthMZgnBZ1
         2w3A==
X-Forwarded-Encrypted: i=1; AHgh+Rpu4ENGk8t2D/E45v2Oi2ljdCu5VRU1x5+Xb6GSubulwy9HgC0X2QXBKkmxw4HOVDkRQU4ElCl5xQ==@kvack.org
X-Gm-Message-State: AOJu0YyaYPpAdTO6BhSIn3WkStNcYCIuA+Iwhp+QUg7fhTALYOXvpk//
	B/gZMFWdYF047LpgoaBx4Fti5RGS3+HXFz0/o/uIKQGrsLZFnu8RGW8cXMkVK9/fPuxWJC7LXqT
	vHyVUYX6XXqJHHWuFkWrkzPFILM+FRIGzGzWcmd2ZNr534+/LWysL5dkkePAt8A==
X-Gm-Gg: AR+sD10bm9vwakS0hapJgeYDQbbSidoegSnRD8fuKXxHzmqDcV6l8Cf91VcH8ll49pB
	FcnahWjCfP7u8ccslj3G00xQClCjg2OlsV1unPs9qtVfzR0d4L8UcvGHxMEl5kh63H7+A5uKjEd
	ZtLHRfZXjsYf/XRnlnbPrberMJc10dUF+mMx+KwBmQ1nF1qS1x+CAEH/1y4lbOgOE35lNWKecnY
	lAi6J8+ZlGojx0Eg3FAs1anAAaXqItjwcObKrf2I0muzHcj1Nx6ksJ8UWqXNA==
X-Received: by 2002:a17:90b:5905:b0:381:23d5:693f with SMTP id
 98e67ed59e1d1-38e4b534bedmr15548062a91.28.1784589567330; Mon, 20 Jul 2026
 16:19:27 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-10-dmatlack@google.com>
 <178433098576.189683.2364970585754668266.b4-review@b4>
In-Reply-To: <178433098576.189683.2364970585754668266.b4-review@b4>
From: David Matlack <dmatlack@google.com>
Date: Mon, 20 Jul 2026 16:19:00 -0700
X-Gm-Features: AUfX_mzMp9DAjORlO4Z9lJDkbL8nPaOLaXiKeGO1DzMTd_1FqdXSUAFnXR38zlo
Message-ID: <CALzav=eZYfYYKAGEzk4TsGFLp1TPb2iFePNmqGsjX4jEZNJ9XA@mail.gmail.com>
Subject: Re: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
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
X-Stat-Signature: y5hmsac54waou6ppbd9iaz67hk3uw4p3
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E782B20004
X-HE-Tag: 1784589568-115585
X-HE-Meta: U2FsdGVkX1/xTwVb92Cfbm5SY4TfQxFdujBg/1TDmJasmUChm+oaZFlzPZNEzfDKUw3K8FCYQzxReCZdPjcAw2KEqGu+JjPzlrAs7hi4IwZHE5sJSMHJLiHeM965IfVHnU+oFt0zehUPxVkfpyOyi1oV5sJ70MGUKSAWjTQIVun60l+uGhV/dRqKvl/vdTaoPTJ3unaOfwwTbysQN/jxxI9GiBhkj9wqwb+jCFUn33WsnuVPL0VKDpIHvhPClpK6qT0rWYOm1DuLJqb9GFhXcGDFr4QS2JFKm2I/S/73y8SDFhl4m0ILgiCcoSgKZI2XIsKZMcsUnNp9XYQvx3v2T12TB164OR4cMjeMv/mccpgfHs3u/QYwNimZIR96lSkNX/sPaNhFxpCye7GWxmC1pDlit9X30ewWJHyvBLEntKu1qn/SSxj5V5P1AYI67MUKN+xjTn6RVnjn7ZVxPJBhP+1X9ysMA530KdmTcYE/GuZBqBNqJS5SjT3pHCc1HkVRx+k+4XfMnsTluHhhgwIZf5O5bWv2RCIAJS/PPxDqZU1bTEgf+zX4UHRNAQLlvuSiD39ZswO+Oy9wir2DbVxiK/ZP+xZMKrJ/DecZQe2mjk9nsGBa064Jwl4YkVR7auc/Mnls2yGX2RFGIP1HWODJiV5QgDnKvGxchVXvwNEjFnpWRj58xvdhxJPHIzWAX7Folxkckcg9XRSKV7P6TiGRg7+wMMtVs2f6V6MjxITnN3XfHHkPMC10I0nmHWYqwOny0C8tYWeViq61BDQdbVKoSfpOs8pY4xGlpbo87NTqallyz7VesCEUaSYtlpFk3GVyNOMpc8rpm+9QqAEd4U5t+0iBWpsFrY4wX3UO+0l3BohPsGkFSDwfWMKXjzIJbi3fka/VcUA76v01rtQUtrxBx4MFu/Bh7tQeSfEt4PP87zPRL92gNpHe0WQCChDB/+XxNgn4QTTaIXbQA25o4ku
 NayGx3CR
 Ar1qW/xUFZlxIHub6eaJ6CGa4Ph+MwsPmXdl63iCt8Ssrv22Ik/c/u5Nw+sgpNndrvAUWcNBray5DQhcP1MPeFalJaz0F32jusSDs7vYxhN9CwYKUNRsjvi+3/Fj3/tRBMixSUMDYuetf60XEYR182nmdm8Mikp370ATKnG11zfGYXKYkTLUg7aovOQV29ibUY6XyowcGXon+3dU+lNmfjRZG9Q/Os0KQahRl0Zc8ekGjHtaoyj94XLPX3YaqNNCNCOKlDCPzBmJOyfftETIwrbx5C+ej50GQIC0+tRfvCo3kQRaYT9rbZi3P0UnFRqJH3LhP
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 4:29=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On Fri, 10 Jul 2026 21:26:12 +0000, David Matlack <dmatlack@google.com> w=
rote:
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > index a95bfe5eff77..74a11e520f0d 100644
> > --- a/drivers/pci/liveupdate.c
> > +++ b/drivers/pci/liveupdate.c
> > @@ -816,6 +820,20 @@ int pci_liveupdate_enable_acs(struct pci_dev *dev)
> >       return 0;
> >  }
> >
> > +int pci_liveupdate_configure_ari(struct pci_dev *dev)
> > +{
> > +     u16 val;
> > +
> > +     guard(rwsem_read)(&pci_liveupdate.rwsem);
> > +
> > +     if (!dev->liveupdate.incoming)
> > +             return -EINVAL;
> > +
> > +     pcie_capability_read_word(dev, PCI_EXP_DEVCTL2, &val);
> > +     dev->ari_enabled =3D !!(val & PCI_EXP_DEVCTL2_ARI);
>
> unsigned int    ari_enabled:1;
>
> Sashiko asks a valid question, what protects other bits in this word
> during modication?  At a very list a comment is needed.

This was my reply to Sashiko, not sure if you saw it:

.  pci_liveupdate_configure_ari() is called from pci_configure_ari()
.  which also sets dev->ari_enabled=3D1 and is pre-existing code.
.
.  If writing to dev->ari_enabled in this path is indeed unsafe then that
.  is a pre-existing bug.

I figured that a comment wouldn't be needed for continuing an
established precedent (it's ok to write to ari_enabled during this
path).

>
> --
> Pasha Tatashin <pasha.tatashin@soleen.com>

