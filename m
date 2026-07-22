Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 071B2C4453C
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 17:00:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0EFFE6B00B7; Wed, 22 Jul 2026 13:00:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C8646B00B9; Wed, 22 Jul 2026 13:00:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EFA456B00C3; Wed, 22 Jul 2026 13:00:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C61A46B00B7
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 13:00:38 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5B252A0B4A
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:00:38 +0000 (UTC)
X-FDA: 85017026556.22.C9E2640
Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	by imf27.hostedemail.com (Postfix) with ESMTP id 5A7B24001F
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 17:00:36 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="o1e/A5XZ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784739636;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=b6BLtSCxCp7M8WEIqu/WUMj2zfCCYaejhLZ7J9DExtM=;
	b=k2tRys/rTSF5ytFZW8JJ67CnfEv0KDzPqvPs/s9HBuZpEpsTswhXodhthRq5pMipPxbdJf
	AEivYj93zVia7W6hcO0d2tK9NvN87OdLJyCtJqcCrr7mPMgkiiwZiJ73QZF+4qfC73pIlv
	4RTwm5BRcpmeW/ELehh8EMh6AGH+VBs=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="o1e/A5XZ";
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf27.hostedemail.com: domain of dmatlack@google.com designates 209.85.216.45 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1784739636;
	b=3ZqG47z9TU+F5m/+IynpmDSdismCIYeEViy2jNQQoIlp/hYmi8CX3H4hcXCt71/BzfK0hI
	TBXDSwL8zTwbvJzaDa61dYiuwCcTn4laWFqIGsqc8yach0P2WkdGRtmYQv8UoHrKy3FCB3
	2vOvl5Ws9xF9og6B7Ppf6dVWNDfZoLg=
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so87506a91.2
        for <linux-mm@kvack.org>; Wed, 22 Jul 2026 10:00:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784739635; cv=none;
        d=google.com; s=arc-20260327;
        b=nWaKVL7BDhiL6Z99t+/4xJhHWHULi7CxHqm9XkJD8v02J3tzhAlyX5K2UH/P5NsE+g
         jTO4GMUqcNADbZwZxBPAlXPxw9ISSefsToBlYyz0aQx97C+xND6Vd+zvz7BhIrC/vv10
         XssORMyc04fzd7/B8D7oZNOsDVSiDC9/7A5GSh3HPbpz4bYhWVGau04A6QZHxxOuiGEd
         Qf5irFftG54dBfNYrJPMkwMOnwu/8ceOpTk/hxNmTw+u/RXMth3pqh75J44NrWam9jsR
         Xvtl7TzwkIknnSKn6DNHmdUZrK3xfG74gmV1xd6vfGnlAZCkueWdJA18Une3+GvcLk2b
         Uipw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=b6BLtSCxCp7M8WEIqu/WUMj2zfCCYaejhLZ7J9DExtM=;
        fh=kfJoYHDJudlcdRUAGOf1c327rMBekaVxo2Z/5MjWkWw=;
        b=rFF2UBouOSdTx1PrbgttcWVeyFsMQx8fQRuRm+I9519lQIDEQUsEbeWx0zeZVC80dJ
         L+1e2o4foDRo0M+leXwk62b5e5YQHx9/V4EZKMJIjQQCJxjPRHxGqMWP1HVWBvORznkj
         t8stvopFXrUY5odCxAzlAVBq9eq+S8Kwj6iknKSFVSEmAxDwsiPFRVoabBcqer9tYg4B
         JLF6IYrH/935xq46EPvpkKRyjfFqDEm4aew2c23HCzRNk/CD5z43vb/NxUU0/DEld5qY
         KHudAK7xUBPlf3zathDUtZ7q4qckbEX2ZkmmqkG7Mx7W0gcZ6AYSvYoXzgyLOYTssRmE
         4xJw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784739635; x=1785344435; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b6BLtSCxCp7M8WEIqu/WUMj2zfCCYaejhLZ7J9DExtM=;
        b=o1e/A5XZg1LCaoodWbXa+jFqEL5bDF78/eMDAqN1bPa/XCC16eqSQvAKjbgKv+c2Vf
         9AJXTfmSEpU1xtYvGcrPyGQIScYfvZTqDgIiyuJ/B3xCX54JkA+ABhm9ntnyWS4ZCIl2
         AslTTPB1KkssA9oKWeFmEX8ogg2HRQQ/Ixk8CGce38i/o5V1FIuT2ObIgcy1QcYOU7rU
         eKyZNdav7Rnyr1icFq4PtrBufDyRdxyX7Ct/2Hjk/3+Lh3PDaYtBOeM2My6FrQE9pv8m
         w2cuHsAFeb9xJgmp6xv6R+TVCW/mEw3UK2F5DlC4bdKxNxhY0Vt0hezLqAwVacnb6ZLQ
         jzJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784739635; x=1785344435;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b6BLtSCxCp7M8WEIqu/WUMj2zfCCYaejhLZ7J9DExtM=;
        b=AudX2Sjx/qkKeM0/e7N5vHxjOeKaGmq4yfUEtqLP4CUFO9qX2alrpVatri3F3Ak1Gu
         NSRz9MuooERrDnskM2DsgCke04c3VeG2KC9PmVSgq+nnRc+g10OlXtjrcfShSw1NnQIC
         Jz+d2eXoQLTkQs+/DPgn8F0S00MlNFkJwkW2XY708niCwdoTqRd5Ia3oUegj/y+3VFs3
         dz26+VaYhPT9tBmZ911hfZkjh5VNqtgGC+xVcTD7NgIO9SNDwKczChZLZSgdfnx+YYBH
         7x7FIf0E7xZ3hOK809gCJhE5UFheV5oOYN2Jl64a3C56I6TdJX31TNw3X0BRPJs97Aro
         sAoA==
X-Forwarded-Encrypted: i=1; AHgh+RovB71OkW+YvUrvRjV/+k0YNz8/9XD7BH+SwZ58Jorbs1VL85oBzu1B4SOFRH7FTfvAWOY9A6ByKA==@kvack.org
X-Gm-Message-State: AOJu0YzZpWWBPpzmbwz/78ebQeqOJkpkF4bGAGeYt0dvS6Pix4b7ZVnB
	jNIcKRUvaeVabyls201TLY6YY+mgWeKpXy7e0vPU83+r1CjTLDkXB4jO88OwNJ4Mv7Tvk+WUHMS
	Mep4/mKaak0sCrhTDnt96k8YpI4JoJQ96WmvmO19i
X-Gm-Gg: AR+sD126G8Mq9NvsNdbhZqUa1Ex8SmMQeZHPUgB0mTpn8sBAVDWyEHIJzxWSRVhzn0Z
	A/H4QVrxaZvrXaB37Hhk1GbQc9bpbXqKybGYZHmjhy0FOAzXDa7ca5volm+84p6AZpbkYoHBLHw
	+BcIzMzVIR2LQNbDO8D+pC178TDyv3apYzmNCneOnRGFLHECy8sVr9wXHqwDCLeNvDsi8MMxXzB
	JC2tt0/aM4oV3hIQYFz+HTPa9lQ/K7aqdOfizrGtL/UzlnRpqZgKMgGXsq2z1oXEkEcnwlxVaNE
	NeRRONrTWuvfXiQ=
X-Received: by 2002:a17:90b:1f88:b0:38d:f1a4:1116 with SMTP id
 98e67ed59e1d1-38e4b537bedmr20414674a91.33.1784739634476; Wed, 22 Jul 2026
 10:00:34 -0700 (PDT)
MIME-Version: 1.0
References: <20260710212616.1351130-1-dmatlack@google.com> <20260710212616.1351130-4-dmatlack@google.com>
 <178432481253.189683.3297727348836286619.b4-review@b4> <CALzav=e1Gcu-9TD7F--41cYqKBrStKOE4VqQ4K3PKdNuYnNmcQ@mail.gmail.com>
 <al_3nOssZoa6RoCq@google.com> <CALzav=dvc_bdmFtV1U2APfs1FM-6Zi5=VShcAYQjZ0wwNRfC-Q@mail.gmail.com>
 <CALzav=fYx7R7c6FTQ5bC4bbQ+_KNaC3gopcPihOtKmHGaB6s1Q@mail.gmail.com> <amAExy1vqMbx31WU@plex>
In-Reply-To: <amAExy1vqMbx31WU@plex>
From: David Matlack <dmatlack@google.com>
Date: Wed, 22 Jul 2026 10:00:07 -0700
X-Gm-Features: AUfX_mw9U43t-da8vfCp9-yZYFJuwnLedP2gk2wgS7EP9CWA2swr-hVEqcna6rY
Message-ID: <CALzav=dHJ6g9FZmoWC5hFRCwCtf=BTHOmEFqbFFaDZiYDbRBvw@mail.gmail.com>
Subject: Re: [PATCH v7 03/12] PCI: liveupdate: Track incoming preserved PCI devices
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Samiullah Khawaja <skhawaja@google.com>, kexec@lists.infradead.org, 
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 5A7B24001F
X-Rspamd-Server: rspam01
X-Stat-Signature: bqj4ff9d9hbzhx9b43st81roz8mtu939
X-HE-Tag: 1784739636-695313
X-HE-Meta: U2FsdGVkX1+ViDnGHMgtKUvXoxcHDT69P/oro/WBwHjxErSD61UJ+CtoBtvYPh0PpMI278igOg4H9kuE8MV5m//evtUXSztESPa29zfu0M8eIpOdJngqaoWyxEiyHomuLUphSNeaGcOB+TefpCIAQgcY4PqXHxtk61Lhyd0kWE/sRHw4yuQGZJ+cLJGyPpwKePTD6BhGI++8BIIJUnrAzgKa4yfK6NMVH/sAfyJNI1hgCypOEp88tUH6QrwBml1seouO5r3TA9YssIVCEfqt1ia6Ug4lPLNs6ld8FhSXdnj4chayZnJcu3EN49X2pO0NIz1zxhStak3Zw/rT1WuRmOC4qqIm1gprhshI95mEIschhO3kqM7byfqpK8RWsBuI2qD2g6Qdv7egXIqfX09uoa4qNqUPro75VumXtZTyKHMMIiuKbu3BokD+KjtICke0xq+PUrvG3ZX2rN37arYPNyGnawmqfskdx9q+PnPzw9L1QWK2gIXsBzdu6qpWtDwFzmbv6g3d4s2OdYQmMBrAbnbmTcY1sVNR67aktpZ0C/ydiM2IWf0LZbpQWktr/2uySQOd0U8lMZmX71dzaAZGy84zKxrsy/YkZ3RIQaO5sH4Cm2WOIRs1DRvto921T9QfwfRgnaaJA/x83Co7GYUagTUwGNicZaWLxGbxx+Dbd58Pv9sAvFmxqOo4hSbuO+PA3zUt3D4g+Jqiwuiin3JthKkEMah/ljT5eSUgNJpcMkpX+Ao8xttOywpH+z6znYV2AkqBf52eTP/60vzrtWaVJXGjmvhOn1qtxkmSW2UKlN4ixYOtwDHW7dp6BhrNiFslic1Dr8Rfc2uDEELcTjYeVuXUMcPypiIr21MwotRDVbCNlhSB0AC6m8R5sZvACsWd6q9lpXxBUHxKMoCwC8Glxj9vc4EBRLd8oCKxsv2pNjPW0S5Z7IWuMlzSTa6xnbUjxxoLmLU6TxXo2hzvLRa
 51Z6fbpr
 vsZ2ZQwG/aGsqnnAyMySbgnc5EG0Qx06eboLBW+RWUHLJ1uANZhpI5Q3IaYuXxucsrvzJeKGv3RlwRnccUXVRVftwObGfEcRgux8OmyIejg5pkxLjhT9EaSP2r5HHRbTjwdGVk3Hz1dubX2hJzzM3pCC/5ONCVuvhlWzdmEu/aY1Amge1kUG9YgwEMlsu9Pc6NOdldU1UwKX4uAgxMEsLJ9xMR9W12EmxlivoULacMY58exAG5wLfzKC3ZgwZBGT+OV0feIx7LQ0O9lpAG1s1KH7eZGg3Z7VA3Ub9K+IRkM0XcNZexZk/UcOS9VSuB5R+vnvf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 21, 2026 at 4:46=E2=80=AFPM Pasha Tatashin
<pasha.tatashin@soleen.com> wrote:
>
> On 07-21 16:18, David Matlack wrote:
> > On Tue, Jul 21, 2026 at 4:16=E2=80=AFPM David Matlack <dmatlack@google.=
com> wrote:
> > >
> > > On Tue, Jul 21, 2026 at 4:02=E2=80=AFPM Samiullah Khawaja <skhawaja@g=
oogle.com> wrote:
> > > >
> > > > On Mon, Jul 20, 2026 at 02:54:51PM -0700, David Matlack wrote:
> > > > >On Fri, Jul 17, 2026 at 2:47=E2=80=AFPM Pasha Tatashin
> > > > ><pasha.tatashin@soleen.com> wrote:
> > > > >>
> > > > >> On Fri, 10 Jul 2026 21:26:06 +0000, David Matlack <dmatlack@goog=
le.com> wrote:
> > > > >> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate=
.c
> > > > >> > index 03075ce06ac9..df6a02240aa4 100644
> > > > >> > --- a/drivers/pci/liveupdate.c
> > > > >> > +++ b/drivers/pci/liveupdate.c
> > > > >> > @@ -298,6 +377,87 @@ void pci_liveupdate_unpreserve(struct pci=
_dev *dev)
> > > > >> > [ ... skip 76 lines ... ]
> > > > >> > +     /*
> > > > >> > +      * Hold the ref on the incoming FLB until pci_liveupdate=
_finish() so
> > > > >> > +      * that dev->liveupdate.incoming cannot get freed while =
the PCI core
> > > > >> > +      * has a pointer to it. It's better to leak the incoming=
 FLB than do a
> > > > >> > +      * use-after-free if driver does not call pci_liveupdate=
_finish().
> > > > >> > +      */
> > > > >>
> > > > >> I am confused by this. Each preserved PCI device must have an as=
sociated
> > > > >> FD preserved with it via LUO. I.e., vfiofd would need to be pres=
erved. If
> > > > >> the vfiofd was not reclaimed, and finish is not possible, that v=
fiofd
> > > > >> would still be owned by LUO, and therefore PCI FLB refcount woul=
d stay
> > > > >> positive.
> > > > >>
> > > > >> However, if finish is possible, and this is the last vfiofd that=
 is
> > > > >> finished, FLB will be freed as soon as the reference count reach=
es zero,
> > > > >> which I would think is the expected behavior.
> > > > >>
> > > > >> What is the point of holding a reference here, instead of only f=
or the
> > > > >> duration of FLB access, i.e. to make sure we are accessing a val=
id data?
> > > > >
> > > > >The duration of the access is from here until pci_liveupdate_finis=
h()
> > > > >because that it when the pointer (dev->liveupdate.incoming) is
> > > > >cleared. So that is why the PCI core holds the reference from here
> > > > >until pci_liveupdate_finish().
> > > >
> > > > I think LUO gives you guarantee that this pointer remains valid unt=
il
> > > > the FLB finish(), because all the vfiofd that were preserved have n=
ot
> > > > finished. And when all vfiofd have finished, LUO lets you know that=
 the
> > > > pointer is becoming invalid so you can unset these in the finish()
> > > > callback from LUO?
> > > >
> > > > If I understand this correctly, I think by keeping long references =
until
> > > > finish you are replicating the vfiofd bound lifecycle that LUO alre=
ady
> > > > gives you.
> > >
> > > Yes that's right. I am taking the approach of not trusting drivers
> > > (i.e. VFIO) and having the PCI core maintain it's own references so
> > > that FLB finish() is guaranteed to never be called while a device has
> > > device->liveupdate.incoming set.
> > >
> > > Alternatively, the PCI core could avoid taking a reference and instea=
d
> > > check for driver bugs in FLB finish(). I previously explored that
> > > approach and ran into a circular lock dependency between the FLB mute=
x
> > > and pci_liveupdate.rwsem. But I can look into that again, or just do =
a
> > > lockless walk of all PCI devices and panic if any still has
> > > dev->liveupdate.incoming set. It will only happen if the driver is
> > > completely broken so panicking seems fine.
> >
> > Pasha what do you think of this approach?
>
> I like it, let's do lockless sanity checking in flb finish callback, and
> avoid messing with references.

Great! I'll take this approach in v8.

> >
> > It avoids the PCI core taking a long reference (your conern) and also
> > avoids the PCI core needing to take lots of short references to access
> > dev->liveupdate.incoming (my concern). So seems like a good
> > compromise.

