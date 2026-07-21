Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DD296C4452D
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 23:18:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E89D06B0096; Tue, 21 Jul 2026 19:18:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3A886B0098; Tue, 21 Jul 2026 19:18:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D29ED6B0099; Tue, 21 Jul 2026 19:18:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1A6F6B0096
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 19:18:55 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 28B9EA0312
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:18:55 +0000 (UTC)
X-FDA: 85014351030.27.96BFADA
Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	by imf26.hostedemail.com (Postfix) with ESMTP id 440C614000B
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 23:18:53 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tEiuR4Cw;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784675933;
	b=UjB74Yz9sFXxpVu2iA7cO4ytg8juNFCWG7O2SqERVeUr64Fvz491J96efDl9vvVQoHZ9XT
	hHdoz238aaDCX5/kCnIdTYX1elD4OREyajYJ3LLPF+/RX5/1Ss08aLc1SHzhRa7VVS08qq
	XoSKtuZE7bJ++knybH8NLZMAvI9ThiM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=tEiuR4Cw;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.47 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784675933;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SWaHQpsMmrxTrkWgIFegEM8fU8LCXLhjFNzfjSgjkGU=;
	b=K81QhfsH19qriCh/LOAbDRpIjby5C/ssRBqpLit66mLcf9Z3yBlf3uAibhGvSoLsiiz1wy
	PTbirY6Nap4cqrV2PXiNXocNBNRu01NM6tsYVfbPOv5Yg9JD+SR9L4TbsCxTtt0mPFoBem
	e6osH35p3qKg9Esa6BYpwZ52pq6cY94=
Received: by mail-pj1-f47.google.com with SMTP id 98e67ed59e1d1-385ea3ce80dso11957234a91.2
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:18:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784675932; cv=none;
        d=google.com; s=arc-20260327;
        b=AgvxtgMpgfc/QPfj7nSelPyvtpEAKgXp9DaeL4zPpc7nhLG+Qq9qkZTiv59cLwCV90
         3rSXeG9OMFpbk1A/QsViTb5GMHIZ1O+4AxeJE6LJYLxhpLdPQo7OVkWia2QtzKnkoPNI
         gF7DBp5d6bVc8SjFpOacutrZIe9PcPNGfRg/Hj59WqUKSRwg2PxpMoSMSBEY/ndZcRI+
         BT8qZ6WJjkRiyu4dTdOUOsXr0YPcVPzG/LUqohx9RAhdRGooKQ8LVeZIEd+Esa9xizeo
         CN9LYse9dRqCcYQzJFExyxzzoezxS4Xi0bcxbGce8b8ZfHob98qzA6jlweg+JYH9NZY5
         l/5Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SWaHQpsMmrxTrkWgIFegEM8fU8LCXLhjFNzfjSgjkGU=;
        fh=vP1FDOdD3JY7tGTtNWBiYor5mo8M3JtlUMEZAMrzKEI=;
        b=cNhi8GUqOKJf+TQHsX26US3UkQBLXdbHu/SbiXsPzqUjRDuBcN1N0GUtiN9fZjSxia
         EHlrp0smfVwWByJkOxRIjhYWusqkXksagAbAtxiPJmII5agIrOBOQ2j1VVuhYrSSTrAQ
         wTziEtIJT+qWPTKTGyP6Ud1Tm/WswY4M+7VNjkdfY2IjsmcB1BpU+ULSRbakbNxnsOZy
         ++TDPeaRYScQUWVqsxBDQk2AcnmDnacd3e5g3Jf6gKGLUmz+ieSyuV7/uloVq3Gt1YjX
         pF5ZMTNtMFnsQvWm5N5+9lnuTQiJZgY3GJTLpaXBo+OHzonEuyjb0obMqmjo1ds4sk0+
         xjHA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784675932; x=1785280732; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=SWaHQpsMmrxTrkWgIFegEM8fU8LCXLhjFNzfjSgjkGU=;
        b=tEiuR4Cwam+lx3RhKfHwn2LgKjhGWRZx+Nc3spasHzt5q6yRX8rIPoklwZHEoffrFW
         LhOsweF27Sl80uwYt7q0jkaCmWKKxdc9Lja5TBGoVWGn/KxdQJyab6oBPPlZLvuPCxkb
         z3xyNXREqOMFTOMmEEGFDXtLjwreqYXbttBTkVA5dqfhbXQd9LCv0kR0evlAPg4hlOwq
         xnKGoa4xIhA7k2r1fjaV42NAhJBQZ0jteLZ+xtuxKdAx19iIDTVusISQmIgK2Ci4Y9mW
         YfKVXQXwgn0O2Ee/pMZS64FXZmg//azpzm/1aYdQIwHPHvOtAIlTF2vIadosBsG4aCNR
         /5Rg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784675932; x=1785280732;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SWaHQpsMmrxTrkWgIFegEM8fU8LCXLhjFNzfjSgjkGU=;
        b=UO4wBZck9XI+p4awVJD+ogYtiRlOGPdvkQ2D8E3bGRm/e6n28Jbr/y0/56iH6WSUBF
         DB+ThVDdkJzu4ibEW2Lq0NSv26KJxTCeqIrYR/y+oahpx0wrsQgEpJBtyicko7Fz2vAd
         qjreVnAB+1kuYW8ct9NeC+ydZYkvUWIK1pCli68VGTPP+BJ9/tg/lI2OnfxBzDvsarsE
         5h3pF8eluccy6QyJCipRQLe3l6VhfFWe8mFSSymWq/zFX5O2Z8I4nLf9l0DF0fcrW8xQ
         HLDZ+1bqbiae4TMKTKKWwpmeXGCRQ2jhAvizk8FniVU8CBcxkxwvLE8n2e/d4eZffOtA
         gCwA==
X-Forwarded-Encrypted: i=1; AHgh+RoK6lKuBx5I4CAElyq+6S+VeB89hJs9UPa9SnO4cqHP7jvkgHJXb8uHxli/h87pjJuOASmtqDTTGg==@kvack.org
X-Gm-Message-State: AOJu0YyqvZWc5AWBxqrAw42bGH+Htb4lF9KF6gp5lii/6Iaq4DbN439Z
	f/BXetblSWxlYWysWatsKYUkzTrv7A7Ju0cqiZB8HxGc7RkUfzf8VY76PVIZoBciD/UyTw+bc9R
	JvIGg1KU61fN/IOR5sdp8uRb83jxrgfOCGosDzD70
X-Gm-Gg: AR+sD10r1SKttpt0uFPw2qAHkvpP5jf8lp/dINuqvVhWJm7TOJRVZVDjg8OiUEdjo10
	k7ZFB61giYkMhJNadH6bb2TRaBWa68IabuwZhLGMTOxYR66r7Z6mMpGn2nBkM8bgg7jbQ5nAyoc
	ixb/ZDWpsu9TKOVzAWM7druGAi9B1uhOwDcO2X7c+jungD3GAqdsgKMaiEDDu5K93uX3FnvWpA4
	EEJmCwFEaJQlzeFGciI8L+BDOiSLa3qshCu053py5+homcelATGCZ3QT0V/SpjNC5IdCZUr
X-Received: by 2002:a17:90a:f94e:b0:38e:500:3975 with SMTP id
 98e67ed59e1d1-38e4b476b7bmr20562050a91.18.1784675931394; Tue, 21 Jul 2026
 16:18:51 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4> <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <al_3nOssZoa6RoCq@google.com> <CALzav=dvc_bdmFtV1U2APfs1FM-6Zi5=VShcAYQjZ0wwNRfC-Q@mail.gmail.com>
In-Reply-To: <CALzav=dvc_bdmFtV1U2APfs1FM-6Zi5=VShcAYQjZ0wwNRfC-Q@mail.gmail.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 21 Jul 2026 16:18:24 -0700
X-Gm-Features: AUfX_mw8WVTULDGM5fg02urMXenJj0foOmNcG_--0euC3EYm6G6QAbnPcLHsH0I
Message-ID: <CALzav=fYx7R7c6FTQ5bC4bbQ+_KNaC3gopcPihOtKmHGaB6s1Q@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: d7jhdks88wqhs1em7b6zbpcsd8rfb8mb
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 440C614000B
X-Rspam-User: 
X-HE-Tag: 1784675933-906865
X-HE-Meta: U2FsdGVkX1/FD3YUPJFmearUrSK59C6BFPH/7dTHVy87G+qzJ4nnfoYmv1JH4VRm7APlu06S5MR/YlawGS0JfQsl2y2czTbr9NDzHianGJeLJWoBmg45HOtnJLJRTqLBCnj6n9iW/Z56UIIKP1wgFREuqw/kaQyqqSWUjQwV+BQghPWicDCe5BoBkBLWqHTvgwsT/zFFPk/1DZ37IGIqHJP/ibk4AcY40rKXS8GDIhKAg8UXiCzFIIbBcg8WhUrCg3wFKIIhso9lIHRZaL+dwBkBGKYwv2u0iSPLQzCRdGmK81mxdNTd6erus1QXy4aKWfKKapRjYW/+1Gc55r89k5ApZ9+nZ9lWTwxcc3+iYWdib1wlu85f12QOBfA6Pz7HfiW5OwUjMmnznpEBzWT+uUHWGdK9tEAStivk+9m9QYOzsVAR3rDd1p04koE4QGGGP/uawSW7rN1SiORVt9C/U7/k1BKfGM5X1pqpz6b+mV5bgbLm+cj36mYu5hSSuWueUJ6oSoi2Velw4sTvqlM/xP/QUZ9IAg747hiWOZiIwQ4kXtrxFFRKhN73LHkWd824ix9Mk16TqSyyD0k4tqDX9cTEIkHzxjpDPYd1ncifS+NRVrjsfthZBFxdD77UrBMZfU9uTJPrAkV3KemprNJbaYQbTlOTpedNoNXAShRClmPO2ZD08WKRNGGsUrSHpgqzmo5BsSC3YJoDEgjmf2huWLMuSxgGGz/S2kb7da5fDIzFvKDLf2a6O3BUzA/ROqNP+rngrXStVA83VCd+mtTlVu7UaO4XVZq7SGw3ExAAjY6X8BhsQBUYb7Zobx7ddNjivxnXBxH1hhFyXDs3To+pflHMrA7tZDqDYjNYdNHKYlA7c1z6QYMz6/4IbMpU0QD4p9Ljpfr335qMbj/TgOQRRKJvbgmjCHdLllRleMqn2V0g7RLqrK/cc19pG3JeURlKni60ldDUL3RrQJP//D6
 BJWDctBy
 wrWtbDpLtMBQrOz9OwhIqMmLzyN+VIn8asiNsM+E7VfglsFJqT1HrBN//9dZ5vc5zzmOcDxCwFMbHPeQZCtDlhyASWM1OWJWRmbQidh1sG1PTkb/NnrJLFjYiWnvGLz1uMVCroZiR84YrFs2UaK/4FbU/h4+wMFXQRV/Ff12mqg+z4ST0qsU8y0OUaY08CYPq6aECbQ3AQ6G4XjNIVibwNk2aIUMx/1XPlgUB7R5jkdt54NS9crH9d6sV55PY7vCjIqIxEI2GUe6IS42nDwGo73GlRA4az5Vis4+lCNGiyjHxh60R8mNI7bED74GTa5vswhJc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 4:16=E2=80=AFPM David Matlack <dmatlack@google.com>=
 wrote:
>
> On Tue, Jul 21, 2026 at 4:02=E2=80=AFPM Samiullah Khawaja <skhawaja@googl=
e.com> wrote:
> >
> > On Mon, Jul 20, 2026 at 02:54:51PM -0700, David Matlack wrote:
> > >On Fri, Jul 17, 2026 at 2:47=E2=80=AFPM Pasha Tatashin
> > ><pasha.tatashin@soleen.com> wrote:
> > >>
> > >> On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@google.c=
om> wrote:
> > >> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > >> > index 03075ce06ac9..df6a02240aa4 100644
> > >> > --- a/drivers/pci/liveupdate.c
> > >> > +++ b/drivers/pci/liveupdate.c
> > >> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci_dev=
 *dev)
> > >> > [ ... skip 76 lines ... ]
> > >> > +     /*
> > >> > +      * Hold the ref on the incoming FLB until pci_liveupdate_fin=
ish() so
> > >> > +      * that dev->liveupdate.incoming cannot get freed while the =
PCI core
> > >> > +      * has a pointer to it. It's better to leak the incoming FLB=
 than do a
> > >> > +      * use-after-free if driver does not call pci_liveupdate_fin=
ish().
> > >> > +      */
> > >>
> > >> I am confused by this. Each preserved PCI device must have an associ=
ated
> > >> FD preserved with it via LUO. I.e., vfiofd would need to be preserve=
d. If
> > >> the vfiofd was not reclaimed, and finish is not possible, that vfiof=
d
> > >> would still be owned by LUO, and therefore PCI FLB refcount would st=
ay
> > >> positive.
> > >>
> > >> However, if finish is possible, and this is the last vfiofd that is
> > >> finished, FLB will be freed as soon as the reference count reaches z=
ero,
> > >> which I would think is the expected behavior.
> > >>
> > >> What is the point of holding a reference here, instead of only for t=
he
> > >> duration of FLB access, i.e. to make sure we are accessing a valid d=
ata?
> > >
> > >The duration of the access is from here until pci_liveupdate_finish()
> > >because that it when the pointer (dev->liveupdate.incoming) is
> > >cleared. So that is why the PCI core holds the reference from here
> > >until pci_liveupdate_finish().
> >
> > I think LUO gives you guarantee that this pointer remains valid until
> > the FLB finish(), because all the vfiofd that were preserved have not
> > finished. And when all vfiofd have finished, LUO lets you know that the
> > pointer is becoming invalid so you can unset these in the finish()
> > callback from LUO?
> >
> > If I understand this correctly, I think by keeping long references unti=
l
> > finish you are replicating the vfiofd bound lifecycle that LUO already
> > gives you.
>
> Yes that's right. I am taking the approach of not trusting drivers
> (i.e. VFIO) and having the PCI core maintain it's own references so
> that FLB finish() is guaranteed to never be called while a device has
> device->liveupdate.incoming set.
>
> Alternatively, the PCI core could avoid taking a reference and instead
> check for driver bugs in FLB finish(). I previously explored that
> approach and ran into a circular lock dependency between the FLB mutex
> and pci_liveupdate.rwsem. But I can look into that again, or just do a
> lockless walk of all PCI devices and panic if any still has
> dev->liveupdate.incoming set. It will only happen if the driver is
> completely broken so panicking seems fine.

Pasha what do you think of this approach?

It avoids the PCI core taking a long reference (your conern) and also
avoids the PCI core needing to take lots of short references to access
dev->liveupdate.incoming (my concern). So seems like a good
compromise.

