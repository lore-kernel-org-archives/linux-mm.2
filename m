Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 985B4FD45FA
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:51:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 056326B0088; Wed, 25 Feb 2026 17:51:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 02EE76B0089; Wed, 25 Feb 2026 17:51:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E1D5C6B008A; Wed, 25 Feb 2026 17:51:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C9B666B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:51:02 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FF8D1C7C9
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:51:02 +0000 (UTC)
X-FDA: 84484475964.30.7094889
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf02.hostedemail.com (Postfix) with ESMTP id 7BF898000F
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:51:00 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vK8OTRkn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772059860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
	b=HluYIMPMOnAFBctEnrkyt4FcbOC99AXGf3iCOj2/eJvMSw2dUUstP2v1UsTYBZPerFrHx8
	tkseD9/Or+mxUUcQ8LOD6PRBNqHiUYoDU3xcbpJMpLPqEvhIWLc7cq4Lmy5B/ORbW41E9U
	4cZFaZMSBeJ+c9jv0LokuiZzT2Au6tE=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1772059860; a=rsa-sha256;
	cv=pass;
	b=lzHj8BR0QokQJ6qpgmcE4NinzG0zxBfwHv2RDh7/yCYIIQuKgmwsk39KhtGj943qdGe7/M
	gEg/IDDJhnV0U29CbHHfrLs8NVGhE3kkahciGWaiScE69qbcmU3p7qhA438kukGQKBBcE7
	vKoe+rDX1vfH5xMW+RHmfET859svSJQ=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=vK8OTRkn;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf02.hostedemail.com: domain of skhawaja@google.com designates 209.85.160.175 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-505d3baf1a7so93191cf.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:51:00 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772059859; cv=none;
        d=google.com; s=arc-20240605;
        b=TNYVeelXKkCSFT2NNen1rpb8houELi3hi3PtPb02YrNSNNHkhxNsB/TcvKRG9jMjTs
         RCKCxMd6sTkvIo3ZoHPt+qVILgNRmLsaSQmkn1XNKKOwoi7/JxV44GBgK8/TtKKYOo9Z
         ACxtVtM68MRUo4SAziBrthuWHG3whDtPyzOyia0oEgZE1YAZE82yRzhukoTX57I7cOBE
         SV1JvRxVSjlaJzZe7hNnllE6PtPJizsKztrrzNx0AegdpUGq8Qdp2xSn0m4+tAT8UlNq
         jUKNd85AT5q62f6Yi7TjLox/pQTjciAdOEWbQmznsp8gbL1oIlrLMvFmQAzhcMRwvGXo
         RObA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
        fh=Yo1/pkrrL2y/xe6u02smL/Jn+G1N1t3LutvDuZpoS18=;
        b=ArfW5oJYPRdk3o+ECrmnPIq5eylRJMylFr8/vw2Jkja6yPvJncDDI7xQReVFVlKOU4
         GGRsdREWSZb/7LI7EExt89p8Y2VUxiLD2YcXk7aoJnpNL4t+m0vGdaBoVZ0iB+/dDCb/
         y9mFInMoFEk2c3IYkls0y1gKmihNnp0DhYyFTCKdLhZH/CdkKitsSkevNfWe4g1jBKwo
         +vpUaDWSNuA9jky5tJEEXk8foQMJFTKMDC60EKH66kEmx0PVr0/E/sjyT863Jym0x9ST
         1u+o9RLldXDi9x/8NwEFkxiPW+9HcXnRmPMM7h0Fn4l7ned/RdQO2n94JCc+dgrVbYQn
         yoMw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772059859; x=1772664659; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
        b=vK8OTRkn/11cj4Z2+lFIphJ2xu80y9lYHx4qOH1T4Bd6OmmgY+I2RLyhyu152SwB4p
         3jvIty/6Jl0pjHeTkZg/zVODsl4cKd97VaQ55MICrKWiTQT9fAHXs6Vfd5SaFc3PUzyj
         1DrLXWsuY7C+8Bv4VvgP+g1Wzp8hiiSU6XRWzZDLNOA60TdL8YVxslDF639snE7zb/9C
         XZoopK/UiZcklQMI2EnghbvbODPOa3PHkOdndX9WBMWE5yFIvsKTXwQd7UlSsoC6Qpya
         E7icznTGCSp/d54Luh+LImZCOhHFULW4+50eiOu5IeS1r05iCubqfVJZ8AzDyEEmt2xG
         WgPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772059859; x=1772664659;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=MsOXiL/6Qn9m7Yd1SU2mFbssuofZOBkFUGv1WIDmPB0=;
        b=dfNSi4Lyk760mv6d32roi49LruUP30utGeCzYa04KzQ9WGl8iwO32XV7sY1/uIJrFd
         J8cv5TJ9eUkuI5jiicZav9E5gQmwu6+5X9vRb6sudnjO0YuhewiDkojkTVkqUfTY6vmg
         3PpZyNSSz/2H4wCvzF7Zs2guOXxRTqzJV1Ipt1hQZxXU0ocGybQL7ANRae9G/ZP2sCKu
         O0ZBJ0ASp18/mgJU62h7pedCtpukqIKFXYQM/SKV6nRPucQMLm8kiN4yUVUGTFUHslpR
         ZsUKX0A7oc24WbPVLJINw8TJTR23M4oXJF7+qDvq+qQlZIKForQrgVpjy+w+lkveXZvX
         KamQ==
X-Forwarded-Encrypted: i=1; AJvYcCX1tjCahEBxLYGQCJwlXywA/0DEZpTvWnpGlSOvATZ080UzXDG4Psizu+ysgKhPyUz6iIi6NU9QmA==@kvack.org
X-Gm-Message-State: AOJu0Yxz4JHCCid5jkLHxdZqGOeWUM6I+QA7M7zyrqLdXkqfA5ZNBzin
	WAH1EsTHRubvnxWEazOFtcLr0R75wvLop94RWhbYhhpRR1nVxX85S3RX6jbdbnnLbyilRiUIJNy
	wAxQb4QOKmm0Dj+xFAmopP3Hwn8NWWcbOdXI2IBRF
X-Gm-Gg: ATEYQzx9DQi3+24+7dsZ2uppRHsT9kGqvo2lSkqqQQF6uAyP5yC78orZAsBraJ6bOHr
	KEcxPLOjnf1Gm7ntC1bIHtoeCEB9ayNEgFvkPDvAeVNiwl57a9kNl4gEYynMzGPFomGjHgfeY7p
	GJfSuVfx0DXsKcaHOuaC37mfZuz4yTykEzTrgoH0JKMywvN25ptfoMiumUdxEmX2erxvqOn0IM5
	JuSdrIcOC4vth14+BapY8dsjJcrQzWVSbpzOeG2dMPExIp4kJtVEtdCJAEDG3aDIH6odElIMk/g
	8mDCngBt4tMV/H0B70DelBR55FCJNf4AAp2oOwGlHpgV+QIYJlJC
X-Received: by 2002:a05:622a:10c:b0:4f3:5475:6b10 with SMTP id
 d75a77b69052e-507441cb73fmr3920551cf.8.1772059858971; Wed, 25 Feb 2026
 14:50:58 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org> <aZ9yWlcqs2b6FLxy@google.com> <aZ931bYILhhkhW-Y@google.com>
In-Reply-To: <aZ931bYILhhkhW-Y@google.com>
From: Samiullah Khawaja <skhawaja@google.com>
Date: Wed, 25 Feb 2026 14:50:47 -0800
X-Gm-Features: AaiRm51aoTymXymwCHLQ9gcq3ldQPi6BvUrjqTLQO_zSuAjigNCnBqzqKSIxD-4
Message-ID: <CAAywjhShWTQbkwhDYB=9a_PZjGHnJ-=HTLAzDBvnDsmtvP=Auw@mail.gmail.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
To: Pranjal Shrivastava <praan@google.com>
Cc: Alex Williamson <alex@shazbot.org>, David Matlack <dmatlack@google.com>, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, 
	Alistair Popple <apopple@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Ankit Agrawal <ankita@nvidia.com>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Raghavendra Rao Ananta <rananta@google.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam09
X-Stat-Signature: fbsmtkygu77mn8bnc1f6txw19uemyqn1
X-Rspamd-Queue-Id: 7BF898000F
X-Rspam-User: 
X-HE-Tag: 1772059860-422376
X-HE-Meta: U2FsdGVkX1+YaC1FEYZje9Zv0lP3GQy9ykganR42dX6WlZFR7Jn9kwl3ZrItfN1xxjZXRRYgf9+HcacWW5cdyNnG8K2Jy0QkOCxCNc3BvR5zGNCAt8bh4JGt8AzcveHSdjF13usIfJV7FGceo4Y1GgZsVxlWJs/tIYtB52PbW32gA3863+35OuRKpNqKHUDP/7HcyZFHA/OhOnSD5UF1nQK+hBs5r1HfWj5SE54IriybI48c4FUPJTgBYlgFizgOBfnKQZiC6+SqowGOHbmNxy3qBnw8K9L/HCflHAqOvE1oAlWE/YhbqgjdK8s/+5rnti10fsGOB9pxjOwS9WqpmA+yn8SoIg+1BwIHo7kvcTKQgKiZSoRcWXkZQIR9p6H8vQ355nCQ6nkydX63KNy09Bw3TUBWU4J5+Wup4843uYn5Il32GlSS6dKjbyD6UKR2qZHT7JOvUehNakzhHtsaOEaa9vuu7dqzOm2ZH/PCPXsaCZ+hxYYQM746OOBgXKJVTnl3LfMEM0iQ7aZ+0D6Pi24LcWA504lwKOY+hIaeRDcBmvIp4j/xbvEmgDAfMLPqscZaoCZ6lWC2anvzSlvt0QNW0ROelLV0YOMxOGvsvx0n3iG3imZny2s7aqZa6l1EkoneaW0tKBVzTaaRRz8rKYuBctnkb1jGM02W+vedanByH5V/VpbNxoN5oOsS9DQZQ/I8f4tVJ1kwJFi16m4GF4RcwzvHcZrsV4iRcGlqoOgft4XLzXSHeE6bhD7icmg1vyxkPy6XtB4oUaX2dzCigL+T8YkGT7bfvdG8BBCAF/d8slKQygEYzZrLFKn4Ci9LTm+aknKusjl3VAh5BmTbrssWCUE93N1lpVOdRepKINdO91KJYncHUYET85haGN8ULIuDHaMo6i0U8374W4d/go47WqC+aYhXVbXKrNr5ocJBnFH8uWgCzC4REBvWi+S89LZ5gPL7xHVme6RzX/I
 SuwqA21Z
 m7vBRwarzYj9Tk4QzfRAhVSjnrFufBXGLwb1CPb6Ktjqcd06sn8wbsN/7VfzNM0eLtenTAz4fzo6Fxwgf5kT94QvBXnjYq42lrA7QkBTWfUHldNUDVVMtUuX2qJsmINvYlEThYOp074KdOxZhu9A16AwgtCbXNhp7j84O/nKr15GFyJFM4q0wKa1eTgdJdP88kxytHKNxVuT/OBLoYU78MFLNuKnwgxKVHh0DQezuC2td1bRQHbXQgqxcHoELpfCxh5KT7zH/6nc+s6Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 2:29=E2=80=AFPM Pranjal Shrivastava <praan@google.c=
om> wrote:
>
> On Wed, Feb 25, 2026 at 10:06:18PM +0000, Pranjal Shrivastava wrote:
> > On Wed, Feb 25, 2026 at 02:33:28PM -0700, Alex Williamson wrote:
> > > On Thu, 29 Jan 2026 21:24:51 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> > > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pc=
i.c
> > > > index 0c771064c0b8..19e88322af2c 100644
> > > > --- a/drivers/vfio/pci/vfio_pci.c
> > > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > > @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
> > > >   int ret;
> > > >   bool is_disable_vga =3D true;
> > > >
> > > > + ret =3D vfio_pci_liveupdate_init();
> > > > + if (ret)
> > > > +         return ret;
> > > > +
> > > >  #ifdef CONFIG_VFIO_PCI_VGA
> > > >   is_disable_vga =3D disable_vga;
> > > >  #endif
> > > > @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
> > > >
> > > >   /* Register and scan for devices */
> > > >   ret =3D pci_register_driver(&vfio_pci_driver);
> > > > - if (ret)
> > > > + if (ret) {
> > > > +         vfio_pci_liveupdate_cleanup();
> > > >           return ret;
> > > > + }
> > > >
> > > >   vfio_pci_fill_ids();
> > > >
> > > > @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
> > > >  static void __exit vfio_pci_cleanup(void)
> > > >  {
> > > >   pci_unregister_driver(&vfio_pci_driver);
> > > > + vfio_pci_liveupdate_cleanup();
> > > >  }
> > > >  module_exit(vfio_pci_cleanup);
> > > >
> > > > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/=
pci/vfio_pci_liveupdate.c
> > > > new file mode 100644
> > > > index 000000000000..b84e63c0357b
> > > > --- /dev/null
> > > > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > > > @@ -0,0 +1,69 @@
> > > ...
> > > > +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_o=
ps =3D {
> > > > + .can_preserve =3D vfio_pci_liveupdate_can_preserve,
> > > > + .preserve =3D vfio_pci_liveupdate_preserve,
> > > > + .unpreserve =3D vfio_pci_liveupdate_unpreserve,
> > > > + .retrieve =3D vfio_pci_liveupdate_retrieve,
> > > > + .finish =3D vfio_pci_liveupdate_finish,
> > > > + .owner =3D THIS_MODULE,
> > > > +};
> > > > +
> > > > +static struct liveupdate_file_handler vfio_pci_liveupdate_fh =3D {
> > > > + .ops =3D &vfio_pci_liveupdate_file_ops,
> > > > + .compatible =3D VFIO_PCI_LUO_FH_COMPATIBLE,
> > > > +};
> > > > +
> > > > +int __init vfio_pci_liveupdate_init(void)
> > > > +{
> > > > + if (!liveupdate_enabled())
> > > > +         return 0;
> > > > +
> > > > + return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > > > +}
> > >
> > > liveupdate_register_file_handler() "pins" vfio-pci with a
> > > try_module_get().  Since this is done in our module_init function and
> > > unregister occurs in our module_exit function, rather than relative
> > > to any actual device binding or usage, this means vfio-pci CANNOT be
> > > unloaded.  That seems bad.  Thanks,
> >
> > Hmm... IIUC the concern here is about liveupdate policy if the user
> > wants to unload a module which was previously marked for preservation?
> >
> > AFAICT, In such a case, the user is expected to close the LUO session F=
D,
> > which "unpreserves" the FD. Finally, when rmmod is executed, the __exit
> > (vfio_pci_cleanup) calls vfio_pci_liveupdate_cleanup() which ends up
> > calling liveupdate_unregister_file_handler(), thereby dropping the ref
> > held by the liveupdate orchestrator which allows the module to be
> > unloaded.
> >
>
> Ohh wait, You're right, Alex. I just realized the __exit won't even be
> reached because of the internal pin. The current implementation creates
> a catch-22 where the module pins itself during init and can't reach the
> unregister call in exit. I believe we should drop the ref when the user
> closes the session FD? Additionally, should we move try_module_get out of
> the global liveupdate_register_file_handler() and instead take the ref
> only when a file is actually marked for preservation?

If we don't do try_module_get during registration, the registered file
handler can go away on module unload while LUO is using the handler
during FD preservation. This makes it racy. Maybe register/unregister
need to move outside the module_init/exit.
>
> Thanks,
> Praan
>
> > I think we should document this policy somewhere or have a dev_warn to
> > scream at the users when they try unloading the module without closing
> > the session FD.
> >
> > Thanks,
> > Praan
> >
> > >
> > > Alex
> > >
> > > > +
> > > > +void vfio_pci_liveupdate_cleanup(void)
> > > > +{
> > > > + if (!liveupdate_enabled())
> > > > +         return;
> > > > +
> > > > + liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> > > > +}

