Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0511710854D2
	for <linux-mm@archiver.kernel.org>; Thu, 19 Mar 2026 17:24:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4840C6B055F; Thu, 19 Mar 2026 13:24:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 434EF6B0560; Thu, 19 Mar 2026 13:24:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 323786B0561; Thu, 19 Mar 2026 13:24:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 2071B6B055F
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 13:24:30 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3085913B53A
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:24:29 +0000 (UTC)
X-FDA: 84563486658.19.E22CF15
Received: from mail-lf1-f43.google.com (mail-lf1-f43.google.com [209.85.167.43])
	by imf15.hostedemail.com (Postfix) with ESMTP id 2D977A0013
	for <linux-mm@kvack.org>; Thu, 19 Mar 2026 17:24:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G/TCtU/D";
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773941067;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bWL7Mvz3ZFb3DsvrD6klOpnMDDqkJa/pdjIb2Ow02uU=;
	b=AgOtvVpAwYt1YLGovIeCCd9/9WVipzD5hht0MZRkFSp1NZdlIZsH+e+8gkWbDiC9YnAj+O
	TT00sOSeI+P7BiWmMALi5N5vgDhxmwTR3X+yD5sbqe6+zxNGa/LiRxK+38CGD4byOqLBeZ
	QJlkaIOjBekVajMJ+w4ofbzjMbUwVYE=
ARC-Authentication-Results: i=2;
	imf15.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="G/TCtU/D";
	spf=pass (imf15.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1773941067; a=rsa-sha256;
	cv=pass;
	b=ufLQy/kZu+LDQC2Mrqqn+nqymDUr5nIwoLtC1rw55sgiHKzvrlIICslYiCiZep9IHweUel
	6fwe25hTU7PJX8lqi/qHqhENbDLZRQgtNvUMc1dYtUEe9Oe/T1pmFki+hv90vTTbHMwV80
	J9BzOc07ekbmQumPGOEekuZKIrD65IU=
Received: by mail-lf1-f43.google.com with SMTP id 2adb3069b0e04-59e4a04f059so1234458e87.2
        for <linux-mm@kvack.org>; Thu, 19 Mar 2026 10:24:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773941065; cv=none;
        d=google.com; s=arc-20240605;
        b=AGCLz9p9rhygd7NEZECDMJAQ+vOXX/cQp4dkH+/1gpwM28yu1KJ8sj4LshZ898la4E
         96Z1LeF2YT0rll6crOSLLb46LVrIxWfc7P4qUr+vrH4JnLyBiFPs6MYgFrL2JbJI1+i4
         79ahXhzCrXdy/sxwjrV7qAulezqvQ0V4CDRJgrBr+jVLu8NN0yRCIFJcatG0Q/oPCfQx
         T8atnkM3oyVlkhiC1ayBaZFXIB3kM3Oqbtc2Xu5XOPoKVp/GGD7QPr6FFUUq7HUy//Qe
         LsaNr1uclNiU0DJNDWd7YyTNtkon6vjnFFU8UTO5jZq/x2isMUSHbNLmRKDLeTpB0d9E
         x7yQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bWL7Mvz3ZFb3DsvrD6klOpnMDDqkJa/pdjIb2Ow02uU=;
        fh=VVs5oG2bertpAIvnv+u1sGKO1RZ79Hm9Xe7AwWg9gS8=;
        b=G5bUzcN7Qk+tVC4GfDTfgGaMX7wOxAPUR/miaAqRtX/QZJ1A9G7wlk4980Im/uKLu7
         hCHiKIisuxPlXy8kscbR4MjGNkn0L+k5mZCls0YhtenY7nO9vyR3DFlwHhNRTQbt35T2
         KUGKoMbUE9OrUsyxJkewB0vXRv4zVqEqxYGnU9Py2MZhEYg8NlPakUX1YWdovuUfmtdl
         UDbRYMAfb3ssPm4+8Dja2usqsUy8w9hkJlPZJORDVad+l53x76YZB8uQfg5Iugof4HEP
         WRE5791QdyEZOXZIwF+soAJO6485Jksl3IY2Lg5X2GlyaSAzxYhOlZFLF5b2jWymMpzx
         mYBA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773941065; x=1774545865; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bWL7Mvz3ZFb3DsvrD6klOpnMDDqkJa/pdjIb2Ow02uU=;
        b=G/TCtU/DKGlyDNfuHXBqUlhBPQBaUTcZJevi6DJX7vBr2kcTDxXI7MbM84whDpf0jw
         uP3+eVCW2fPXRu1+YEI+1/DR+fjHoZ1Aa9UAYBdGPS3kuFVTvOJV6A+W2u+6Lulhvvzl
         XEpXoG2WS2Fikz+S5TKnYBbGZm1M5FjpoYfq3N211xy6CHYLCR8vc4RYBUei2gjZwGhX
         kE+/ciTJZmmb3FbVxuwgLy3v0BHywudmyTKxshc83vgiPFPxgVbTTmE1l/qDZ4WFslDh
         EcH+LBO5u2dR8yhBEN5okHWJRx+BMdUpUksLl6gv+XJulpc0FKfBMoBVAMUbzb2DyP2N
         zTBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773941065; x=1774545865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bWL7Mvz3ZFb3DsvrD6klOpnMDDqkJa/pdjIb2Ow02uU=;
        b=g4LyDr2UfUAJJS7ALSnNKumMCijprjSPfZcNb7s4kWaediBMHB5vFGf1y0lXqJqFVG
         JLDoV78U0KYADhea5BYEZEovN0yNHwdQZHAth86mgUq0+wAa6xY4EGB/QSjwUu9Hokez
         7N+a4EMaBFspbSOcrhKwwk4XTF/v67rXgGFOdjHTfL+zSWf7qOFqEGnswTqbUvdTcH3n
         dd/ryVLljDWyKOhhcSH7U++QZkjQdcv26YXRB+lYA70tcbcq3eNKRYeoiZoLsOSrIfCZ
         WOJEWKq7pgc5KKlBWUoDpyXyW6DOSIz145SGEaER0HOTEcXiPr1VVY5VKT9tGzJW8W/b
         t2+w==
X-Forwarded-Encrypted: i=1; AJvYcCURuDpsmp9yF4SkOY8I71r6MCj2PWU8YlOTritbnf0qQS2BdeASBZY7VnO7GStjQ9yTu5AATk7+gg==@kvack.org
X-Gm-Message-State: AOJu0YygiNqH/ocbxxbUB13j+72C87NIQpcevtI33TGeV4/vZs9Xg15U
	vZpw2CrICO2IIagVTcwaIE6k40KPpN+wSJ8YYP7pU7+ocpSNZrDni9fkHMkzfumzPkEBFcjlcpb
	Kjs1csU1UYGXt7k3P7pE5Codk11ZrWxDQxoLbMKUB
X-Gm-Gg: ATEYQzyzZPj3/cEqXY7Jq85xBnIKEErlNLCVKFWRyidEpftKqyy7ZRUFBXD4FouvqX8
	MRcRQLCYEGs69qIC4/2yXRngKNHQ4Xj9xN0D3waJFdnDCPFJNa5UKfhgzB8+f69qXGlHlZmt4Un
	XlCNI5kiZPkbcliqUhygMAI/9RPx//bIGKzH7pJkKmDBr4Eme+cTFAL0xYuIYHou7ep6KhOWY8i
	n4pXGwP5YsLj9rpfLBBUX2bWnw91d75yYX4hW/T1xI288RA2Fz7aLYSJChQDePsTswQ5YXhtPcM
	eK7MB/UO
X-Received: by 2002:a05:6512:4016:b0:5a2:7e5b:5a48 with SMTP id
 2adb3069b0e04-5a27e5b5b70mr1566015e87.26.1773941064245; Thu, 19 Mar 2026
 10:24:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org> <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org> <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org> <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
 <abNOwcOTXqxCxNzt@google.com> <20260313083918.00005731@linux.microsoft.com>
 <CALzav=eGLpo5nrsHq5L8bUTC=FWZ-SgrTE1FoScrWB4p+NDgnA@mail.gmail.com> <20260319093932.000078c2@linux.microsoft.com>
In-Reply-To: <20260319093932.000078c2@linux.microsoft.com>
From: David Matlack <dmatlack@google.com>
Date: Thu, 19 Mar 2026 10:23:56 -0700
X-Gm-Features: AaiRm53rqLDO8igOEPnPEHv7Le9OPlkg99gzLBiOllDBuZj0inzOHo1IukO9vNo
Message-ID: <CALzav=fvG+s6MYNzxhuHFmQkmTRJJASXAGs=zQWWSnSv3Y=J9A@mail.gmail.com>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, 
	kexec@lists.infradead.org, kvm@vger.kernel.org, 
	Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	linux-mm@kvack.org, linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 2D977A0013
X-Rspamd-Server: rspam08
X-Stat-Signature: 8c5bi5cwous75cu59ca7kpmp5zgar3rx
X-HE-Tag: 1773941066-278241
X-HE-Meta: U2FsdGVkX1/NaOzDrThwAAAm5deW2qs4vusWsXDQXxUCjVVHvonmDd6R6VYDNUsgQ09hftgrQeAHslbfNejlopI/uLRUaaRuS51sVIDNciUL+1LvCRZLu8NlChy33rR3HrgFNxoGKOrRA1/eec6ZHDAwe3vynMGIG+CKIDyd8exPFBkdLtdagH3A5Med10xcR00dlMxe7oIdFNlILvf8LT1RjX6iIPgIY286/LAQKzouffgt9hNs21pVZm2aiCAKgOCH37ZMWCmjefYez+fI1+WstpS/1DxrVM5EuywOuEU9QjkREdhgzMv6Q/0wF81VZfxtxCyFFVVf++1/52VoUmxY+6yehFcgBCO+rPZcS47xakd62FkSo/bfahZkUZ33NTMXWdksI0VCyWha8FjGDgjmqRAfhNuwbCQgDC5Gl5rx5rjdPK+DwErOFoG8IvSYvbmK+2T1MwIanCq5edP6sU38BuPzWphHU7cJqFc5ygaE9HvVpntRrye7MT/4Fd6UlYqDHdPpXzPf1vW6CP66TObAkfgEr9SL7oVH4i2Oxs8+VZM8D4ZJquoJdcAoDhM/ukdrxE/cuum6pkWfuGeKcWOFrVHsQC03jzNWmKqYo9N2RYFMpwNZE2Rx3mDp2ihpoMBMKjtZawtPbyh8TVP736DFRvRUOI4A+3DzWbeViGs8QpNJOx4f+O7jJldmMcUr3BzopwRgW0G1UCvCvmlapY20CIzXs3DdHHLYGGQc/MNLeNBAm/bIY4W4P46uKnDWffOSkkiO49A1CGCFtkv351BIj0hw74LxNzGxTS//Q+cveVFmUa8aKSrEM9smBD3K8HOVwX1itPm1/RKlUL8+t0ezu5+36DTti6vjo0wGCcozErKSOnKgGPZ7C1WDPB0K2wDPbSCN97nT0gOZmNfoI9ucorHJWNI+sQHq8Cx37nsUpgpKaty89dywJVHu2/oFQW5iPo4NWP8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Mar 19, 2026 at 9:39=E2=80=AFAM Jacob Pan <jacob.pan@linux.microsof=
t.com> wrote:
>
> Hi David,
>
> On Mon, 16 Mar 2026 11:11:20 -0700
> David Matlack <dmatlack@google.com> wrote:
>
> > On Fri, Mar 13, 2026 at 8:39=E2=80=AFAM Jacob Pan
> > <jacob.pan@linux.microsoft.com> wrote:
> > > On Thu, 12 Mar 2026 23:39:45 +0000
> > > David Matlack <dmatlack@google.com> wrote:
> >
> > > > +config VFIO_PCI_LIVEUPDATE
> > > > +       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
> > > > +       depends on LIVEUPDATE && VFIO_PCI
> > > > +       help
> > > > +         Support for preserving devices bound to vfio-pci across
> > > > a Live
> > > > +         Update. The eventual goal is that preserved devices can
> > > > run
> > > > +         uninterrupted during a Live Update, including DMA to
> > > > preserved
> > > > +         memory buffers and P2P. However there are many steps
> > > > still needed to
> > > > +         achieve this, including:
> > > > +
> > > > +          - Preservation of iommufd files
> > > > +          - Preservation of IOMMU driver state
> > > In the interim, what do you think about moving forward with noiommu
> > > mode without preserving IOMMU driver state?
> >
> > I haven't gotten a chance to look at your noiommu patches yet, but I
> > do think noiommu will probably be a good way to develop the VFIO and
> > PCI support for Live Update without blocking on IOMMU driver support.
> >
> > > I=E2=80=99ve tested your
> > > vfio_pci_liveupdate_kexec_test with the noiommu cdev, and it works
> > > as expected.
> >
> > Would you be able to send patches to add noiommu support to VFIO
> > selftests? That would be very helpful toward allowing us to develop
> > and test Live Update support with noiommu.
>
> It is included in the noiommu patchset; the only difference is that the
> VFIO cdev name is prefixed with noiommu, which is not strictly required
> and is done out of caution.
>
> /dev/vfio/
> |-- devices
> |   `-- noiommu-vfio0
>
> https://lore.kernel.org/linux-iommu/20260312155637.376854-10-jacob.pan@li=
nux.microsoft.com/

This one flew under my radar. I will take a look and respond there, thanks!

