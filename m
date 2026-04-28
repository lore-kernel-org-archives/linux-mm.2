Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC01EFF886C
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 21:12:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EB0116B00E0; Tue, 28 Apr 2026 17:12:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E60FE6B00E2; Tue, 28 Apr 2026 17:12:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D68716B00E6; Tue, 28 Apr 2026 17:12:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C5AFA6B00E0
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:12:45 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 5674D1A0475
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:12:45 +0000 (UTC)
X-FDA: 84709213890.17.A58D9DE
Received: from mail-lj1-f170.google.com (mail-lj1-f170.google.com [209.85.208.170])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4533C1C000D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 21:12:43 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmHsGiPI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777410763;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y1c0hsfQ1G9nhDHLSFuAkEDbfJtF8fRH5TAPVGQIJWY=;
	b=kfaNzMPiuRd8MbPEEMGNVSfAHy1BpDJ/nMOJf+Ar03Z0+ZzEKfuwHEM/jV2eqyY+ipYcpI
	DO95yCMll9VJOXe3gY+TupGVoeuAitdcem/tfFK0N83HnUBAaVusfKr/X07S7AMrtxldyf
	Py0nFnJ7UYeNWNmWgCTXpQcUnaQc6O4=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777410763; a=rsa-sha256;
	cv=pass;
	b=C3NNmbKNW9cOdmHxYeWltcWqTI2ctixYoQ0mgYlDo3n0/ev4AOTaJPdIw9KtZrrp4iGd7Y
	AAkDYrq7olLvrvBKk6TlGhXzBbzHeI8Fxwmn//J+nOcAXegJ6A9TXjV4aYSSAuMJaDYmAR
	aIn2PfDL/gNlxX2YUN7qh1QxANEmrNg=
ARC-Authentication-Results: i=2;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=EmHsGiPI;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf21.hostedemail.com: domain of dmatlack@google.com designates 209.85.208.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-lj1-f170.google.com with SMTP id 38308e7fff4ca-38dd575bca3so2573761fa.1
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 14:12:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777410761; cv=none;
        d=google.com; s=arc-20240605;
        b=Vyy9gm6MpqsjOhao6L1U8Q+Ml2pZKSCZYMMQJYLHYoHXTYIz247bMCaTX509Zv7dCm
         eIGJwUoc4xztK2E8D/9f31SzqGwWqwYNhhRh9vbcGkjGckh0mYSk1Gz3tlDoaz1aGbGk
         RmM9D/g1vG/HqdFPG73nwufLrsT4TpBlSuyqTMJu6KeFk78FsD/R6kJuOaXbilwApJP7
         lrDi+o659GhhS2Ux8IAkXLcp6VuLhH534dTEddq7Wd9AitV0pCDnbFD5VViQQNEZPghe
         F5FdAk9gntj1TeG0RTKCXknO63KeGlDMH9M22ciWLTaJIWCsvZ1aI2xgRLYVpkvA2Mrk
         6wQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Y1c0hsfQ1G9nhDHLSFuAkEDbfJtF8fRH5TAPVGQIJWY=;
        fh=cgQVoDJG7R3qKOHHbS1xUMM7Cqt8Eo0Mb4ajCB3uePg=;
        b=dv5wCHS3KMeCYdlGfgaaHE8i21u4Z97tfXqiOxOpJ2BDj32qPT9and1rvxLS5iYB8i
         RHbt3o1zaMBQ6xy3subVICY2ulxyXCELxgGYegRkHiL9Ud29gBrA6TSQSMDuFv5q7aZo
         vXtkKlZHSbzr7jEtXoOvS4NNnu6AJEh8VEuVv9eXx1p0augxX4ZeN3fSQf6yj6GkZ4l3
         GjX8DFKN+VSuIT2+eysn7E5taOwiGYFklDc/ZzTzAtPyyecyzq3GTIQXhgjjDCZIO7Dm
         4BNTnRwtXKdgBs1kKJ4kjvWY/GmXVdyY+5lgFB/LR/8qUPewVRH1txJXCPqt2M2E72g4
         OOFA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777410761; x=1778015561; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Y1c0hsfQ1G9nhDHLSFuAkEDbfJtF8fRH5TAPVGQIJWY=;
        b=EmHsGiPIZ4/PF2EtFSc9otWFIeaxbLn/U8sHmraE+Jiw2pOF9M8jTAzIwIhqZzSZ9K
         dPImz/OYDbGE0voxhCU+K2wg2FxhtOWbI612y+ebm38MfTZVmFDu2z/eKr+Pd5rtuF7t
         QJwb9HOJKYx5dE67zJS/Wrq1xURSxCC+UgkkQILUNJpYxKIgUA4W5LbEVHI/B0NhBlgv
         9EyjpTIrfdf1tkYgD5qwFWXnKuNoQEOK04qnslcE0uroL2HLrACZyYwN3LpH83nwDvd8
         ApgIR5MW8eWfViXPuEfnt9i6ltowBHMV1V2mqA143DaMADVdxHDwB7wJQBRB9/xqmoJy
         da+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777410761; x=1778015561;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Y1c0hsfQ1G9nhDHLSFuAkEDbfJtF8fRH5TAPVGQIJWY=;
        b=g9lUELVT9dM1AcFnTgopIzZ+rE0m0GVUNBCAvu7JtpkJ1P28Ef2MykUtPPbeT8y15m
         XLIIE+VgvX338Kx0cA0SM4ZqR6Ts9ualMT+JoZR7krreh3WMb9WCn8Ehc1EJdMwNU0P6
         QPKvvpkdHaeWOps/XNikn3KufPPHy3m+VTEQA+VZeWfboWN3+wrN30tMsEMj8LHahrfV
         zDTlnp5RzKPxe4+nxXBGo6vjAMi4zsPJADTIq8nrVUKOD02NBuF7xdR6zE9yVwr9VMj0
         Harg7ZPlgMXONjisbATA82Y0lIepKZ9g5QRK76QbZwb453DQSl3pWXdXls/vjKw+izKx
         096A==
X-Forwarded-Encrypted: i=1; AFNElJ+v7wlmfIu0RG4DyMio0IDs5Csmym8n0FVAKjs8FsSGGDiv7dgEaz6HVZI4yQ+VtxOTx86SQaGZjQ==@kvack.org
X-Gm-Message-State: AOJu0YxSMwa7TCFvYIpBFgTcm/XbLtPRKFkm4IDl8MeIzXem1zorwbYH
	bwBoXT4NhgJf0n4rnpEjFl138Z3HxYJrEwucauMe55AHiNGH5BXAPn/JPWEzFfTgFlADYZzXX6n
	P7xeBlnOYsjM3Cgapg+ZUNhDBtcHQIvS0VbeDi3gN
X-Gm-Gg: AeBDievzicWtM0t+7BtCM3AfEuKxyE6kjXxaY5TA2CYbuPGjsNQ/SHnd+1OGZKcvBmK
	tmOnFjmVrv6XSF7ba87MUTqbk5BB8hdd3uvEsCceU782FrwWUWKfPvwM4KnK3KNcqL29qesx8RT
	pbiot2e+EguwKBROk9n4VUiSifx8qXZLn9VCQVsaJZ5KNlBVNnDJsbZ4gSZeSQld/459AmKr+gF
	X5EliYifW5F1T9EkgUFRWmNM8v65gzdNovpN6h/VNFhc64CkcC4IBdDm/XtRzCLA6uvYtg9cwAs
	XdvBF5eRzDKMKRZa48lj7sZbxeXJJA==
X-Received: by 2002:a05:6512:1390:b0:5a3:4692:61ce with SMTP id
 2adb3069b0e04-5a74a32f180mr148152e87.1.1777410760874; Tue, 28 Apr 2026
 14:12:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-1-dmatlack@google.com> <20260423212316.3431746-3-dmatlack@google.com>
 <20260428201231.GA3885809.vipinsh@google.com>
In-Reply-To: <20260428201231.GA3885809.vipinsh@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 28 Apr 2026 14:12:13 -0700
X-Gm-Features: AVHnY4K7jpha36hMRH-mQGhZech3LSC3uUxVbVP_4PPgBDawCFAtuaz99Nxadcw
Message-ID: <CALzav=dfLtdrPhkBkGwHpDAWUBMHnbGPccwhy1__doziNVZQJQ@mail.gmail.com>
Subject: Re: [PATCH v4 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
To: Vipin Sharma <vipinsh@google.com>
Cc: iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Robin Murphy <robin.murphy@arm.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 4533C1C000D
X-Stat-Signature: 6hdw513ojcuji8ck3hq1j5uta6twzsfm
X-Rspam-User: 
X-HE-Tag: 1777410763-481501
X-HE-Meta: U2FsdGVkX19JE9hXMWhJxSGSv04px1wToO6RP2xK0ZGS7fJP0hCHEgGu48bAI8qmLml0SQhsXKTgPDLaHhQi8nnsPmr//Xza1jBYRJwjXAaxW8vTLUCAdwjrSVSsYbxWTHrPYEoaYUjTwowHUXmyEovh9BUYlctIE9zjfwy3H4G11mZryPdasNvn9P733uDf8aOForjhxqT8wekrjT7uidckQE9fWAvl0n2F/765/Qa5g+hjw+7mnuhossPLcFtcH0iVYIe3JW0mOu7D1P3RCJEG75a7Coag8ToNXpxHpSGa71y1ef58w5+W5ESTdjm6J5kqcnRUwfYO8TuGjPv1oyHf38tmizkkJAta/hmBsdiEj8qdZazaMxKjCiK9Z8jM23TdDfbQkhTa61ycAOSGCu5S9RcQ8GWHfUkWWy1VKw9ntE7O0mPuNLZ+gk56Y8Imt41VpHeMMPhC483Sj5VRZ8UmtCRBcoY5tKa0sbD4Se9LPotGjrxDOQXhrcKbGT9Y9TcWDwwIfUYRqgIe9LicsbJniIHW2/PBhza9fLRfYzu8wl4NWxpn4QwtthK49JDL+ehOuByQNSjWuR0UT3byLls6qasXjlAwIfql5pDc9LYJDTj1BHcKPQLpq+RZFENp4cycuHCfIS1u+JgqFRhXgQ5w+dKl4CcktTN+i8tw3IEuEnCZ92mOXI72KP6IqRQPVnYMvYStxfW0olVPnf0MUjAWdp6k3Nki299JHHxQCGkZ3rlK6z6/rDdCPPz0dYnLM2eUzUBms5QzzGwsfB0UcM6cDBkkDSEiO+hPgib3ATJVYeCw0lW+LIvhuFYrthSuJ/DEsLguu7bv2HiHQ7AclFiDmUavbcJTw+xQClBlQKDpUydmA7a7tul15cPSvrxiLDK3SdlRK2Ctk5/CSJnR7g6Ay1h76RSEbD25H0FXOmRWMYRHQcwIVNtBTADX37iCexCkOX2i/fLiTf2qQPp
 4CbT6VQX
 ErYIuyfFaY4t9tvcE89lOVofauV/3LOm9wnVYpXw9ji0ZWUr3CgIHTbGucoYjX9yyQCiUVA09ZES6IqwXu6kddAKnkMmxkXuabZwrTCSoY7s/L0uYjVTJX1PxdHKwx4afKpcyLZ8Nf2dmoNSWQm/7HvHxuZ4AzgCISolftbi3tiqoLSfc4b9aROgZgEZkQMryyLlBiY5umd0kogTN3HbOg34DUS1wPcjLumQQsllO6cDIrPgU+jjdZxO1E3ZFLWp7rmlpQCrfaAX4OdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 28, 2026 at 1:20=E2=80=AFPM Vipin Sharma <vipinsh@google.com> w=
rote:
>
> On Thu, Apr 23, 2026 at 09:23:06PM +0000, David Matlack wrote:
> > +int pci_liveupdate_preserve(struct pci_dev *dev)
> > +{
> > +     struct pci_ser *ser;
> > +     int i, ret;
> > +
> > +     guard(mutex)(&pci_flb_outgoing_lock);
> > +
> > +     ret =3D liveupdate_flb_get_outgoing(&pci_liveupdate_flb, (void **=
)&ser);
> > +     if (ret)
> > +             return ret;
> > +
> > +     if (!ser)
> > +             return -ENOENT;
> > +
> > +     if (dev->is_virtfn)
> > +             return -EINVAL;
> > +
> > +     if (dev->liveupdate_outgoing)
> > +             return -EBUSY;
> > +
> > +     if (ser->nr_devices =3D=3D ser->max_nr_devices)
> > +             return -ENOSPC;
> > +
> > +     for (i =3D 0; i < ser->max_nr_devices; i++) {
> > +             /*
> > +              * Start searching at index ser->nr_devices. This should =
result
> > +              * in a constant time search under expected conditions (d=
evices
> > +              * are not getting unpreserved).
> > +              */
> > +             int index =3D (ser->nr_devices + i) % ser->max_nr_devices=
;
> > +             struct pci_dev_ser *dev_ser =3D &ser->devices[index];
> > +
> > +             if (dev_ser->refcount)
> > +                     continue;
> > +
> > +             pci_info(dev, "Device will be preserved across next Live =
Update\n");
> > +             ser->nr_devices++;
> > +
> > +             dev_ser->domain =3D pci_domain_nr(dev->bus);
> > +             dev_ser->bdf =3D pci_dev_id(dev);
> > +             dev_ser->refcount =3D 1;
> > +
> > +             dev->liveupdate_outgoing =3D dev_ser;
> > +             return 0;
> > +     }
> > +
> > +     return -ENOSPC;
>
> Since it is executing under a mutex, and we already failed
> 'if (ser->nr_devices =3D=3D ser->max_nr_devices) check above, will we eve=
r reach
> here and return -ENOSPC?

Yeah I wouldn't expect to ever reach here.

> > diff --git a/include/linux/kho/abi/pci.h b/include/linux/kho/abi/pci.h
> > index 5c0e92588c00..5b4c8d9e462c 100644
> > --- a/include/linux/kho/abi/pci.h
> > +++ b/include/linux/kho/abi/pci.h
> > @@ -23,19 +23,20 @@
> >   * incrementing the version number in the PCI_LUO_FLB_COMPATIBLE strin=
g.
> >   */
> >
> > -#define PCI_LUO_FLB_COMPATIBLE "pci-v1"
> > +#define PCI_LUO_FLB_COMPATIBLE "pci-v2"
>
> Just curious, why did we change the version here?

Because a field in struct pci_dev_ser changed.

> It's not like just
> previous patch is working enough to perform a live update. As the config
> is experimental, can't we just keep it PCI-v1 for the whole series?

What is the benefit of keeping "pci-v1"?

I think it makes sense to follow the rule we set which is to update
the compatibility string in any commit that changes the ABI.

