Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4EABC44515
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 22:00:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 84EA46B007B; Mon, 20 Jul 2026 18:00:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 800366B008C; Mon, 20 Jul 2026 18:00:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE826B0092; Mon, 20 Jul 2026 18:00:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 329326B007B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 18:00:53 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id A186D120306
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:00:52 +0000 (UTC)
X-FDA: 85010525544.28.254286D
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf13.hostedemail.com (Postfix) with ESMTP id A245720014
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 22:00:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IXKtZ7Po;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784584850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gj82UvWIC9kB06K4+/XSzH6MrQ6ehsQ00zZOFqHM1MQ=;
	b=DNuvHE7YVuggpRKCU2Zp5Z3OlJ9tk8MY4MnE35eyyO+OYdhr2Axz+dt69DpFwcWuQssJny
	gunGyvd5Q+dDYdmUG5n1lZ0tCAgWyausfcIPIi3RUiQg1dlpsHy/UyJmkec4UEQm3wd1qd
	FNInqkY5h2DMGmVt/sELKm557gAovfY=
ARC-Authentication-Results: i=2;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=IXKtZ7Po;
	spf=pass (imf13.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784584850;
	b=GcMKeew74VIySptOyTo2SsOrMRuK3dHG8q3162jvsZ+7vpGd0H4whvoInt2V2UHqBXU8k9
	xGY+vcgkiUaQz2Pa8f6s2B0x0HahsXuJd05Vy7xl7yjVncc/RRQ9JyxsJgMLFuXLbIcmsd
	N3pYqeNjfF9arzlxvXUzpJZDRVrbqbg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-38a0c7e841fso8397063a91.2
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:00:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784584849; cv=none;
        d=google.com; s=arc-20260327;
        b=jlZ2gsVC9HNhTzC1MTkSUvyuWAg24QgKadnahWfrZD7kqU2j+Wk/tFfsYj6rC4sPlO
         BlmBAglqjzPCfWmmuDnIeSDmYoNivgoeOwyr8uydGTlZVvy1a8Qfaru64qLSWo+CgAUg
         Tv7op0GQwI3/g7U8J0jvyX1D17JYluVHrk5qTfD2PkRellKH5rfqaBwP9DZYdyb5EXSE
         8IbMUcAUxjC3xo94sic6aGvk+4jcc3wDBqmpjW9toLdTx/GyxqNTzMLZpqG3CY0MXSR7
         M9g3+/yys+4iOg04FSOd5vZOK3IgC7dIgW9AUW8lxRhtQ+hPamRhS/+CU9hGU1kYAJKy
         ZjLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gj82UvWIC9kB06K4+/XSzH6MrQ6ehsQ00zZOFqHM1MQ=;
        fh=K2lI1COWmUoKvKB84XX4278fmFONb4PWO7V8KfQkuLc=;
        b=dpertqzz8TPQUeYJDNO6SyRbLNdbYWuwqRhDxqWzjOF/yIW7Jt1QkMxlLX3yGS04wT
         yOcB222D5A7+3JNbgMJhEaQ4Fm0gdTwPvgVeDAc6fXMHDU9+eKb2HJItEZS2MYk6v9RU
         cmRuXWr4YJRP8T5NqsVsu0xGvuWLTLdc4BpXGLjUFVQ9nT52z4zGdCBtNufhWrzXkmGC
         9HyVuD2TsA1xooV0mCIoXrbAXZXql4bEN5g2qXTcn6S7p/y+dUZjoKWfArPIzmGIxw6/
         QnPmgsB78zUq9PBH3sAa0mNV22ak3VSlX4fr3i8r5C7uEKDrdM9B7b+/CkZqWbdYsVpU
         /tbw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784584849; x=1785189649; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gj82UvWIC9kB06K4+/XSzH6MrQ6ehsQ00zZOFqHM1MQ=;
        b=IXKtZ7PoQi5YkhqqWtl7ltINl/DGLyDevIyAALcGoY830L7E9Y+R+UbGcGQ7QBr7pt
         ysxAUNfTAKUXpkFQujSs1lKJN4XvtXx7mAYjw5a+0WEJp3jJJkKxNPNBebDupzztLzvY
         4gIcUFMvsmZAlIl4N3KZ4VhbcBpHYuDcv6MkJpvGC9nCnhiM3Wtshbg2m0ygwcv0+c6X
         2Z9uVAmTzDUfAz8sadpXOh+xe3wW5qryOo3KhD8jh+rVj+8oxuW1cbdU6kC504wX33cz
         5Yd/obbH3MGnwf+gN6KM0jwKA6IiC3G1kiu9GhpSFT562WSRweD5qvpIEbU2FbOXGkjp
         oWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784584849; x=1785189649;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gj82UvWIC9kB06K4+/XSzH6MrQ6ehsQ00zZOFqHM1MQ=;
        b=shet7CPHJgrIvoGugOOXeBEWS0PXsJQJYgTHKBHEiK8iAjV6ZyCfVLWizPp/PEK3Si
         0nri3YeyVavcOB+glD10UndCe5BWyqeaCY5JKcBhlWs9XuMZYIwmky0MeccocB9uXNRw
         +1WBGRBxEtc65uOuFBFmubwAKRkkxIc/zwp0EyWGA1LQMKdQDLg9u7RDRarQUmWNT4D0
         MJPO2EloWV2BD4YZwJDVjVd+ijJw0+ynYB0WQxTTkz55RHvryD6TiFFu1cUwbrZ8KG/0
         qbIoFpzo568HGC3d+x4SHZAmJaCaMLNrZeQDdijBEx2MeSNImIqY1T/Gkcqn02xVflwd
         SwGA==
X-Forwarded-Encrypted: i=1; AHgh+Rp30/mnd8u5qETwHwJLiwZHBrGuUGWayzrtzHwYm/SjmjswrrDFSlLSsRl9ecJiFAbCJDRz6GDtyQ==@kvack.org
X-Gm-Message-State: AOJu0Yy+TZ/z2xf0j4ikRUUnV2iirJrk03bZ27O+JVTtgUkLNND4NVfU
	dDGhutBXduNBsT/DBNl2qWj7CkzMRQWHKC2uVN61FdEYNWnngzMt0+UKdsLQDF3m77pL6RjEexS
	zpGUWdW8ZGMqM7S+Oa4WWHTWwN+owVMcMrcZYXFXG
X-Gm-Gg: AR+sD1373HYwmqLc6f+yPFkPWojf4JjUR9CVkpN3vNcOMdFKgW07Wfi6weQFQcYEb2x
	Vn0iys6qC6CaOWDVT7M8+iJhJZiTFDMFZz2i1QQIZ6bJ9ol0MfPnwa89LYo+DM2Kd2mUWm1oZB/
	jMBhpImITozhwHLXDZCdNcV0YR5CI34Vgaq533MG9xPqrG2Kp19cb2Q0RpScGQVSwgd0WiSldoL
	NpbLq4qqXZxXpGtI/YrOQzVSBmLbd+4oLe/rGCSnC6ioujOTZXsGm8NxuCcQQ==
X-Received: by 2002:a17:90b:1dca:b0:38d:ef48:b04 with SMTP id
 98e67ed59e1d1-38e4b454d1cmr17323817a91.10.1784584848356; Mon, 20 Jul 2026
 15:00:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <20260717163820.6bc8c13b@shazbot.org>
In-Reply-To: <20260717163820.6bc8c13b@shazbot.org>
From: David Matlack <dmatlack@google.com>
Date: Mon, 20 Jul 2026 15:00:21 -0700
X-Gm-Features: AUfX_mzNR0w-MD4Mb6dfdU632NpNdotxFCmghB3mJDm5NOOEi_E54XencSYW9rk
Message-ID: <CALzav=eQ-0rbxh6Eekbt4zUoNGNZc_THmSCvVWVwE3om1BPtdw@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Alex Williamson <alex@shazbot.org>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: A245720014
X-Rspam-User: 
X-Stat-Signature: njb93fjcjk5o8hfqrfsfuyktejki8qe6
X-Rspamd-Server: rspam04
X-HE-Tag: 1784584850-579079
X-HE-Meta: U2FsdGVkX1+XiCyk26B1zEzs3pZ6LzZcyArbTZMnPQO0gYo8BcX/cBBnM7BHc8U+alxgBGZZqcdh8IXGkNDIHEkpbf1zTw8HnlJBh3QCAKxOY0RBe49AdViovnCVtwhSuxZMcOf4WP2RnqxjzaafDsD4td/IeRhgcjMD4OFe9ikOHpH9diB5o0DCu9xCSSV+8Q7UTwt/qdRyAzQRhGXg+mO3JTK8pyDFVRlnu6aqTNHVuVuTNpI0goyYeGfqL8Gy0oTPGiadLTeTbDSlaFyLB/kr8q0JW+cxD4NmbZY3GUK5xEDWvQDBrl+/dh52oasxKdAShalQBPuuavoRaAudp1FL2L0Y7rau3hJigRZjd0SsOuLtx7vjCiFas7V1vxQdu24YgzpN3/fQcJVCHnMz6hc/GEFG464gvR/ecshIuGme6zIzTGxb4AREuixHPsaqNgxipjigrOGToZ0VvmfWgWmEu1rp3hYrVvjQIWZ2sVlg3SGojgqAP1nDkVBjuDAENRHjRhp5mZLC37eBMx5JFXMpwT+IEwbyAyTdUCNmHJl0SiJKd18puHTyX2FYmJNu7RRzG47lBo03sKzExTNwB8liluuWvayUWBjUiqAhsuCPB6qJSyob+XiHyJLXE/5OVGtsmqxedd5zYvAQOFVokF71iPXwH9wpN5PWXEFCRScT5zcmYsMEzMzLsFWQhlwCjziYpEkGMs1bM4AmeZ97ma7rnXcWdKt2P3JasOPUkvOQsHfYD1DY7zgSjFGHZCeBzdCZRoUcStDmOrqmtNNNSiONIxj4Xlfmf1fxQMLFFpoBzgdAuMUs5DfxMujLTEwgmJX2jufjmtfEoXaTOdPk+0WMj4gfAA+1OevanRg6veGrchGOT3U15gRb4medRwtrCer7nbNaNRfr20QDreC88s7FK5SBa9Eu87wKBHtpEb7oyTBIk0m+S4VV4vkqhy8UPmUuu55Jdw4G+k0Sg0B
 Sx1Ta2BM
 1drQBIZmux7TD5KcZu7ehA5QCRNJbpu3yhDwu/9VI0tEZIcXox9gVohuukR/hhY84LYfkoFbIv/kspuBBOFIiifDAnQFyLEHqt5HNl/d5rWDdu44goqFPXte/EzPc3hXni6m0verf0e16sv2p31ZaTOw02JcLTJi64nbxO11GtJZL4d9NjULYo2FvUD4q+pHY2+B7t6gnKjP0ivwfKxSG/JewEjU6KooxL5vDHOuXmou5V7vAUiNoxfTA5KC/2wPHTzxQkEXzEeQBJw7seatcNBj16RxpbQEtsopI+onf9dfYwUUlcu7P7kzugST8SLc2kL+B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 17, 2026 at 3:38=E2=80=AFPM Alex Williamson <alex@shazbot.org> =
wrote:
>
> On Fri, 10 Jul 2026 21:26:06 +0000
> David Matlack <dmatlack@google.com> wrote:
>
> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev *dev=
)
> >  }
> >  EXPORT_SYMBOL_GPL(pci_liveupdate_unpreserve);
> >
> > +static struct pci_flb_incoming *pci_liveupdate_flb_get_incoming(void)
> > +{
> > +     struct pci_flb_incoming *incoming =3D NULL;
> > +     int ret;
> > +
> > +     ret =3D liveupdate_flb_get_incoming(&pci_liveupdate_flb, (void **=
)&incoming);
> > +
> > +     /* Live Update is not enabled. */
> > +     if (ret =3D=3D -EOPNOTSUPP)
> > +             return NULL;
> > +
> > +     /* Live Update is enabled, but there is no incoming FLB data. */
> > +     if (ret =3D=3D -ENODATA)
> > +             return NULL;
> > +
> > +     /*
> > +      * Live Update is enabled and there is incoming FLB data, but non=
e of it
> > +      * matches pci_liveupdate_flb.compatible.
> > +      *
> > +      * This could mean that no PCI FLB data was passed by the previou=
s
> > +      * kernel, but it could also mean the previous kernel used a diff=
erent
> > +      * compatibility string (i.e. a different ABI).
> > +      */
> > +     if (ret =3D=3D -ENOENT) {
> > +             pr_info_once("No incoming FLB matched %s\n", pci_liveupda=
te_flb.compatible);
> > +             return NULL;
> > +     }
> > +
> > +     /*
> > +      * There is incoming FLB data that matches pci_liveupdate_flb.com=
patible
> > +      * but it cannot be retrieved.
> > +      */
> > +     if (ret)
> > +             panic("Failed to retrieve incoming FLB data (%d)\n", ret)=
;
> > +
> > +     return incoming;
> > +}
>
> I'm having trouble following the error escalation here.  What's
> fundamentally the difference between FLB data being provided and not
> compatible (subtle log message) versus FLB data being provided and
> compatible but we cannot access it (panic!)?

There is no fundamental difference IMO and I think we should handle
them the same way (panic). The problem is the PCI core cannot actually
distinguish between "PCI FLB provided and not compatible" (should
panic) and "no PCI FLB provided" (should log). I would like to propose
changes to LUO so that the FLB handlers can detect the former
situation but that requires some non-trivial work that I didn't want
to block on.

For now, I guess you could say it is up to the user to not perform
Live Update between incompatible versions. I can update the
documentation.

>
> Don't both suggest devices are running but we can't get their FLB data
> to continue letting them run?
>
> The errno interpretation is also slightly different than the comment
> above liveupdate_flb_get_incoming():
>
>  * Return: 0 on success, or a negative errno on failure. -ENODATA means n=
o
>  * incoming FLB data, -ENOENT means specific flb not found in the incomin=
g
>  * data, -ENODEV if the FLB's module is unloading, and -EOPNOTSUPP when
>  * live update is disabled or not configured.

I think the only disagreement is the lack of specific -ENODEV
handling. Is that what you are referring to?

>
> Thanks,
> Alex

