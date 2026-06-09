Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 74509CD8CB9
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 18:41:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D18D36B0092; Tue,  9 Jun 2026 14:41:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF0AF6B0093; Tue,  9 Jun 2026 14:41:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C06B26B0095; Tue,  9 Jun 2026 14:41:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B16EF6B0092
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 14:41:10 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 59C70120788
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:41:10 +0000 (UTC)
X-FDA: 84861241500.07.A9B0D3C
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf04.hostedemail.com (Postfix) with ESMTP id 45E5D4000B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 18:41:08 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ad3fQ/Ru";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781030468;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rp2AVHnvaLdz2Pq3FiqBKoQWbYzwYe73io7ef1uKgPQ=;
	b=d6KgDDgPpmWy99p5BKQ7dp0+8YdJYVWkodd2/z8DiZA/0WShUD1Y6j6ZaR17TjV//J5+ua
	VCnotcDJHorVuopxliOzluou23qZNAboyhwZ0+/yTD9Pmw6E2Zfz5LZT1kc2hHKvv11bw+
	Ks/mD4EB9ls1i49XHeoYbepfOl01iR0=
ARC-Authentication-Results: i=2;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="ad3fQ/Ru";
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1781030468;
	b=l5oCApR8wjh0sKSocUfzTWWefxupfsjJ1RTrdKigz2qghwkSX2Nj57JBGh5xZ34Qjj7/KD
	qXL3XGG8PILrOrVu/OrxRzi9eqWWHcxhuyZ5yqvDfx1LS9323/QshtghgZvf0Y7eh/10cA
	Ylo4gueXtlrWdSN6z82F4CXv/QRkBd0=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-137dd4cc208so3804080c88.1
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 11:41:08 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781030467; cv=none;
        d=google.com; s=arc-20240605;
        b=XhanL94mFjQ26/t6y+OP56hqMSGgEMCnPwQVQFadfIm4XYdoO0qtOOMu4O1MQxS7Js
         i4VJE/HopdMU5CeYDZ7GjoJUjmlC1YNubYlaxgkVWtoku9A31c/NP/FrNC4BgnqRVI25
         OMC/Lr7BvL2JWGmT7lRTJVecZeW1sGBgW7W7RbmOZ0XpdlaY1AvAzS1aXY5n1poUEy+7
         1tcxkcvFFsWpaZ0gZCaNZGloanyDAAxOWTk9mUvjSiNZRbpJ5rfLC/lWyYIRYOm1rfqp
         798BemxjhZcaytYqPnwrAoymEnM1EWvJ7KWy8l3LUU9oU+AmKRh2dCzbX6YdQwZhCPyy
         4xWQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rp2AVHnvaLdz2Pq3FiqBKoQWbYzwYe73io7ef1uKgPQ=;
        fh=PG0QKZbmmNvlV8mG9oaoq37H92JndIQnDBpQVTS5F7s=;
        b=VDulp1Lw677p7iriTl5I0gsqYaWkV9RBEv0WFRoXLAGq0yFrZMO0890Awd4f+Fq7WX
         945+VX4bHwQjXhw8/ZsryYkI8ck7Ilg13KwuP9BmGTtxsoboniv/Cq3hfyO1SV+elMCP
         3iipP5iAaU/d+Ct8RFiKY95KMdNLs4QFDwILVDs/mR7AaEEY6VxeVD7zWZu2l4DYAEfq
         Eu8vrKmDPeBguFVeTZN/ienJ75f9CstTz00xUuo0BkwuAdKtqAgzrEooFOp2J4CxdCyQ
         iozdhE03oSLm/oXC1FifjhCrQ+vF2blywy0Ui5yg9iIRWpUP/oO0zKtwwcLu5yNrKC8+
         UVtg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781030467; x=1781635267; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rp2AVHnvaLdz2Pq3FiqBKoQWbYzwYe73io7ef1uKgPQ=;
        b=ad3fQ/RuFnjyD+0xmL+sMRTdqwNH/sc4W3th4w8h0dbwxrkH7fxPXdQeXJlyWFD17e
         m/qFrIFGk9KLnC7jbu6oCtzBqZK1bLiW4mXjbP53C28LlZzDOYhOYdjuzjH6SN5Yzdgi
         +4ju8OTfLlFOQ3ZtNBIBOk0a+PaNPvfCGKmnpXNS2NgCb2YcYH4JSPmob71Cv7jyK4Ls
         lapQo0HIkFr8zBnLkjM6XlAUs8lgeK3bkaIF3fCDfghHXBfI4JnV0RrxUHa0pXoqiNUq
         4wEwXc1YZ+PHy60ikKStG2orUWsGCn0OlM0gl1Z4q2DEW9Fc3Gk4XgsWBB8FKHVKNUcD
         J4qA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781030467; x=1781635267;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rp2AVHnvaLdz2Pq3FiqBKoQWbYzwYe73io7ef1uKgPQ=;
        b=WZZFWFurFZTPneW+QJne9upEfOTG0lkjb+4cL1cgq1qbgYU/lCVX455susbYrlF3A4
         x7hgMv5iyXd7sxfeaSfvthHPp+/OfB2Jt7KV6QvkeKL0W85HwiOVHJref2qqIg4bAQMu
         LZttCNFw2/YboCoZ0PiSRLVHQMnZ2nKT+IVXHBO8lz3ZNfOw5vDPmakbfwgX1TMQXqm0
         bVhvi9xgufCBIM8KFryQa8nB8bqqSpn6XQUsZsmprIUyRJqKol5LnMB4KW9fCO8tORvf
         YPOwWESMWd5Qx6F5YUr8AlJGqKIG9nl2m7TFn6ZhTPjb49HYicK13POoitMW8pAUIxbV
         Z7pw==
X-Forwarded-Encrypted: i=1; AFNElJ8yV3seR4o75vDitc8xDVSZOnedP1TGsSLSjbh1tbnJHnUwzxHcLwSe9shvWOjql2LcoStFR/yiGg==@kvack.org
X-Gm-Message-State: AOJu0Ywkel4GT6MuAzrLgRxNqxf+qNSDhtNayg4vJgtzLNqhztipQ3NR
	hIe3PkiLrj6714ipoOLhxEP2wAAeDdQ3naoKMcRDQ8fHXM4u8M44VtLeBpKLJhxL65GnwAoO2xk
	B5Wpe+5i9aE730NvGaDbyyU0sIQNr9ZJrg/U2RarS
X-Gm-Gg: Acq92OFUmTn1xNBnTs/u6z5Ciaj9hqrTmSFADTjR/YAD0jwYEPinK82guiyhlQ1dTh3
	XBnXQINSuj4wdMcv7xx//4/Bdn1SbcnXJB8Kgzu3bJQW9NRtjJtL1d2Sb1wsKJEPPVth+66t/qY
	/KsBSmdZtpglNqlkmQDTPMiy+kSLoaJLKEPJZxqovRREE4F/ayB25lpBvMaFfjnHwBRABDeKGKp
	DW9ndKiWrILWCMP+AuS58goMlPR6PZffvFAiWEcLc3CHli2eRfm4noZUDqIcXogX26+2w9cszxJ
	99U8lyBJ5n5h815osIe9/9bhhl9Z
X-Received: by 2002:a05:7022:327:b0:133:39b9:9720 with SMTP id
 a92af1059eb24-13807d7f8a8mr10097032c88.16.1781030466370; Tue, 09 Jun 2026
 11:41:06 -0700 (PDT)
MIME-Version: 1.0
References: <20260522202410.3104264-1-dmatlack@google.com> <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com> <aic6mdiZ0qUJpFca@google.com> <aihLTgs1Y49OXQaV@google.com>
In-Reply-To: <aihLTgs1Y49OXQaV@google.com>
From: David Matlack <dmatlack@google.com>
Date: Tue, 9 Jun 2026 11:40:39 -0700
X-Gm-Features: AVVi8CfFJIkIzWoDM1n34NzkGcY8xgKn7goqY8e0r212_RJvyRI4sWlWr6KLrxY
Message-ID: <CALzav=dagHvcS8kbTti5rmMoks9DXuCpO3AjptkQ8z_PdG9JyQ@mail.gmail.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
To: Pranjal Shrivastava <praan@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: facejuwu44ts3yncycwusdp41w7u18y8
X-Rspamd-Queue-Id: 45E5D4000B
X-HE-Tag: 1781030468-515686
X-HE-Meta: U2FsdGVkX1+YK/QnmgcCSbTaiK3TSHrxhy7McgVkdSGQuGYm/6/a0HI/+lRo5CU6ILZnMZGIJ04HSpu6Bs4miygXaNDV0P5804mCDBskbU/Iyci9deiMB90HCv1seilaZP8uZ/o93TcdEWLxMZkaxZ41xSirpa+YpV1ll3V5JzBg+WBbrCh2X4P5/3TFXW6OJTkIT1nP9QwCJmvvkALOn5dq4GBUTvNWMQWbTB5HdSqESFvMatKE5BUJyK8aea7NACzGETZeWm2vnhyZxqKpjn9M1MOZ96Lnc9xYh6IA8K8xmNFM+YMwNtUh2PyXWMvwNPyqtH06O+2rirVOz/n9PLrG1BQE6fLAaK1D52PCA2nFPIJ+nucIRxq+5PutJrswIT2te1unJp6TmvONV8qNNc4j2329p+u4gnRrarGUnSG9/R1JlxQpmBGIkXaPDHVKu9cFjova6bUXA7/jNpo8c0IlbVqHZ3qM0d+s1iB5jEPpQNx5GdfOHXZ31ZKFlQcTvOXxQhQnIQup5LRd6GYgU+Ac9fQXp6sA3h4K+6DmoAGnAeSQz/Z8+OjmfmytRy+8FffmIeaNknOwHmTzjLLQhJ09pkdZoxog+XiolGZtju2J+dghZufqNNirWXCEKGTHdykg6hlkdvrRLBptU/Co1Ec9xL8JrC4Ze6LFk3jGWE2YAQskA2E4pCLFMTkV0vAUXv75Efap2K+yhhC742sPEVKwFKChp2cEGyfZ7gwdz0p9F/Lq3PChkwpM2yXpCdoM10vKAcgIItZJZukmPZi8+m4AmmzsSZqkrqOCBH8/3wvhGDS1ZNMLo/B4JeL36LWcFcnaBhplBlnM4K1Rqfdd1MlqDkzCsPu5Qq7BoLGq89qcF8UoTkhmv3Db9TJzANana2NaiQd4tbypSj88AHQkZZds8feaRWu4K00sOgDxlyxF9QIT/t38b3O0Sit/oF0TAz4ELywDa5EBFiVjgt3
 dzHaDIK+
 m/nGrd8j2aSp9sKVg7rwZhx1pAbCFnV4zY0LdiLoYR0vdQS0nINLLpjtL3UONlL+CpyWM4VkZatjKrJB32xQ0AqnNLQ+babwHDfHRfqw1rM/pEgoFTmOF+y/fEOvI0dCYmvKngHKvbM7GDPZpElDl+2ASiwEW9T/ILQMaXxHudc7g+71g+zV/SAsdGEJavHpX06zXbkMGY7Vv05NaKr2VRU9uEECeziGIc/JOxACKrr4nSXC2PFvewMSl3J5ber2i2mK+QjkRKTgRMxxWyLmD2w1A/Ne/GC64kzMIadIblcyrExZHTU91z0PxEcbcsZuG5ZwJjnMpQiEB9+YUxjzlB1TjZH53rg43+dnG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 10:20=E2=80=AFAM Pranjal Shrivastava <praan@google.c=
om> wrote:
>
> On Mon, Jun 08, 2026 at 09:56:41PM +0000, David Matlack wrote:
> > On 2026-06-07 08:37 PM, Pranjal Shrivastava wrote:
> > > On Fri, May 22, 2026 at 08:24:06PM +0000, David Matlack wrote:
> > > > Inherit Access Control Services (ACS) flags on all incoming preserv=
ed
> > > > devices (endpoints and upstream bridges) during a Live Update.
> > > >
> > > > Inheriting ACS flags avoids changing routing rules while memory
> > > > transactions are in flight from preserved devices. This is also str=
ictly
> > > > necessary to ensure that IOMMU group assignments do not change acro=
ss
> > > > a Live Update for preserved devices, as changing ACS configurations=
 can
> > > > split or merge IOMMU groups.
> > > >
> > > > Cache the inherited ACS controls established by the previous kernel=
 in
> > > > struct pci_dev so that ACS controls do not change after a reset
> > > > (pci_restore_state() calls pci_enable_acs()).
> > > >
> > > > To simplify ACS inheritance, reject preserving any devices that req=
uire
> > > > quirks to enable ACS as those quirks would also have to take Live U=
pdate
> > > > into account.
> > > >
> > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > ---
> > > >  drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++=
++++
> > > >  drivers/pci/liveupdate.h       | 11 ++++++
> > > >  drivers/pci/pci.c              |  5 +++
> > > >  drivers/pci/pci.h              |  5 +++
> > > >  drivers/pci/quirks.c           |  7 ++++
> > > >  include/linux/pci_liveupdate.h |  6 +++
> > > >  6 files changed, 102 insertions(+)
> > > >
> > >
> > > [...]
> > >
> > > >
> > > > +void pci_liveupdate_init_acs(struct pci_dev *dev)
> > > > +{
> > > > + guard(rwsem_read)(&pci_liveupdate.rwsem);
> > > > +
> > > > + if (!dev->acs_cap || !dev->liveupdate.incoming)
> > > > +         return;
> > > > +
> > > > + pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->live=
update.acs_ctrl);
> > >
> > > I might be thinking out loud here, but as an attacker, this motivates=
 me
> > > to somehow hack the EP FW to mis-report the PCI_ACS_CTRL register acr=
oss
> > > a liveupdate to fool the incoming kernel. If the FW feeds a 0, it sil=
ently
> > > strips ACS protections.
> > >
> > > Should we also serialize ACS state in ser somehow to ensure we aren't
> > > fooled by something like this?
> >
> > What does "EP FW" mean?
>
> I was referring to the Endpoint Firmware (basically any SW running on
> a downstream device)
>
> >
> > Does such an attacker even need Live Update to attack the system? It
> > seems like such an attacker could route TLPs in whatever malicious way
> > they want regardless of Live Update.
> >
>
> I agree that compromised PCIe devices are a menace anyway. But I was
> talking about the potential window opened up by Live Update here,
> suppose we have Device A & B assigned to 2 different VMs (implying they
> are in separate IOMMU groups because the switch set ACS_RR =3D 1).
>
> Now, the attacker has an opportunity with Liveupdate, since the devices
> are already assigned, if *somehow* it flips a bit like ACS_RR, the
> incoming kernel might see both the devices in the same IOMMU group.
> Who detects this case and what happens if this happens if the devices
> are kept assigned to these VMs?

I suspect that would be caught during the restore of the iommufds to
which those devices are attached.

The kernel would attempt to restore each device into a separate domain
(since that's how they were preserved before the Live Update) but that
will fail because they are in the same group now. Even if one of the
devices was not preserved, that will still cause a failure when a user
tries to start using that device (e.g. to try to attach it to a
different VM).

