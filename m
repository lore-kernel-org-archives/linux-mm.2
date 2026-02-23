Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E661EEC2AC
	for <linux-mm@archiver.kernel.org>; Mon, 23 Feb 2026 23:08:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4C4E36B0088; Mon, 23 Feb 2026 18:08:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 472B36B0089; Mon, 23 Feb 2026 18:08:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 354016B008A; Mon, 23 Feb 2026 18:08:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1D6E46B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 18:08:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B65D81B5CC2
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:08:51 +0000 (UTC)
X-FDA: 84477263262.17.20735BA
Received: from mail-lf1-f51.google.com (mail-lf1-f51.google.com [209.85.167.51])
	by imf09.hostedemail.com (Postfix) with ESMTP id 9BE2314000C
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 23:08:49 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wdp25TWd;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771888129;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
	b=SAW36b2Nv8gFQSj7/HTB71TLi+32b+PzSRsR8m4V2j9nbto4wmkKwcCyJlryqB1gbHj7/t
	iDKwiMD5nGByv1K33UeSvg7DSb1mCOxZfkwi08WYFrADNYm/t/ntkmRF8sOLJ34rVHpRAk
	ovXkj4MY0oTHO+fZpeXpcMuShZymNX0=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1771888129; a=rsa-sha256;
	cv=pass;
	b=2IQ0Ajp2UUSjpsNGyT/LqovTRq1Mkwe3MOjWRL4z3Wd4kV82XoYhZCQfOCkXNiMThQgssi
	RI0lJAL3NuZmo0/4etE/ANcEA+B5AbY3T+zIjDoOWMvZkZTLxeMHkTCuX8NhSFIVfqaOsR
	x/G+SJjRp4g9c2Rfc8519u+eBr+vsE0=
ARC-Authentication-Results: i=2;
	imf09.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Wdp25TWd;
	spf=pass (imf09.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.51 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-lf1-f51.google.com with SMTP id 2adb3069b0e04-5a0faa0d15cso25206e87.0
        for <linux-mm@kvack.org>; Mon, 23 Feb 2026 15:08:49 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771888128; cv=none;
        d=google.com; s=arc-20240605;
        b=LTdMUQpYtcfOn6ToZb7uusvoDC9oEIhOp6lmce9ck4hU7okR7q8zpABoUOeQt4Ujae
         NkJ28DENC3ugVmOn/IlnABN666yH7df9ImhFkR/wtYXupoW3nBMLYjTF1+F+pdu0SHSW
         kHl2O1tB8im9r+iA6IS+KjbC/pPK2wT0r/oYan9SG8QtdCd28o1oHeC+sfY9Den2pnwr
         QZo1FirnUOd2pctwCTRsZgtwiUJSaXc7hlADqCRDpfqAvLNdoKixg5/UfveHua1I2iym
         lERTHmC0YXbsnvBZWR8UlBz6TpL8kThjd8xvjcpgKdnXl0U0AkzjfxaaolLTAWBTlu0q
         meWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
        fh=pVSnEyvtqCSbAld6/xUNW81r4snSOOzoMHC9cOABuV0=;
        b=XkjqshSStSJ+/VbzeFQso0Cd9+sZBDB99XJ/m09DilC0xgU/Ie2mthk1SFoOeovvu7
         U2YWa4G2zGJm1PVErkf2ABMYSsjmOPHcqS6BYCyRyVTv2BhDgJXoyBEq18CgSqtLo/6G
         PL11FpR8LQkc6Wi3Lh4UGOBEvVOiG6ZJeh4bAfZIaPn6Q8iR0APxzt7vnYnMM7jbzHGl
         GCcqKTT52frf+26Kq2sbqYBbxSxfbx0xhA1q6kYeOd6fZPavrBrXh1iDkonovBu+evK3
         AYXbEcZajH3ftIUcI6d2jDbJZS5AP8hQFOdOZFROByBKjJzIVFOphhW2QgcxsCSd3UYh
         GGGg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771888128; x=1772492928; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
        b=Wdp25TWdpGi5sNq/jY/Jv7SAt/JSw6A/DsBBQpVMHTIl4bC6um8OGJtnodTUMct299
         hs80oGy3iiTXzIbGg8CEEgagMuvnaHQAQkD1UMjibJIwFQKMZABIcMi+dSzP7+ffukRu
         yLaze9DlcWLpXF0TN7p0p+OYxKO0psDVYL65lQ0YCdVenReIQeFY9JX4gTqP4PZEx+J6
         ScvwUju+mcU9qecZW+7hwCceYvUgebroUKiWyQqPvonSRCWGcP3TYTPsanWnSH+Yhjoh
         DXSC3c2qJHWwu7X93SAsRBikU10sExd8Exub6/xiAF854vVPEwkU/ZA41mueuEzplvW6
         QrsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771888128; x=1772492928;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=c4ne1Ls/uKmuDNTWcMVVG01PBoi2SfFbs/naiop9R80=;
        b=eMlKakKj5TPAqKI2hcBEbVn/aI2Zf65nuT5Oo7dXNcMy4B8NAxFz7ZF5rBCI+meLXV
         OGNMmSUK/2S4pKrg8iDCNGAuFQKWqu53bHCCwuQ78vjf51qzT/L1h32poxsWBdozDAIG
         Ze/fDEwXwOtP9nCA8w66xW2c0ebOqakvIEDsZTEM91QLLeDJddv4KSfF5lmXAZCSbw/g
         RSm8PF0mZKZOlzbJOWd2+u18LlMH6KN5utKIXUVd+uZNbi64XwnMsa859zJAL657YJLB
         YoSZ7baZsWc5lj+zJtJ9KInf0ohcA0JQN7ocgiNfFIVGTTpAdeAVwQYRyUM3J8IU/Tx/
         mJIg==
X-Forwarded-Encrypted: i=1; AJvYcCWMjD+MOGLIoJtllYo6Rkv3JicybkRR/5Sd7f+mp5TWzNkd3O2iQYJhf80qRXbf05cvytDl0woV6w==@kvack.org
X-Gm-Message-State: AOJu0YwfWW2ruFRwwya/ZYdat/So/pMh6meUk7hWuxsQ0WN+OpyVMdqn
	6gFdDfI3qAmcQhITaoGm7S2A1LEodnMA3A3Pkyjl5xFeeQ/f9OWA8XDaN2Ip0TSwCG2tVWk+cVt
	3xL3BbbQMXdcAD8TKiyrsfxkVC/pl8OhpbC6zmtDw
X-Gm-Gg: ATEYQzzeppSIziCPgr5gfswwy26qc4cMTlJs+fcpwIXGWwYOEmKFaAdMjnJ+PG5HbF4
	Dhs5tYFLSMU/dudaPLkTE8jPdZGlIO9S/yBgznw4GyrojM2r9DGiyZH5d5NfDI/SuctU82NgdKJ
	CrUDieaPC9xV879/CNi0hcua32dxVnpPnMdWcoFlvZh3MYPO+TvdIFlLN09x0qf5G87Q9hzrP7I
	65oSLb6Ft3zrcAdXPkYDPqkrYf2PsHX+xUCl8BKxa6cPfBCnf8zFBpfVRtHzhSO0czcDUgmbCti
	JXgBdTc=
X-Received: by 2002:a05:6512:3b9c:b0:59f:8546:1899 with SMTP id
 2adb3069b0e04-5a0ed87de41mr2986457e87.11.1771888127316; Mon, 23 Feb 2026
 15:08:47 -0800 (PST)
MIME-Version: 1.0
References: <20260129212510.967611-1-dmatlack@google.com> <20260129212510.967611-3-dmatlack@google.com>
 <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
In-Reply-To: <4mbhcmimhin2ulz57mbzpe5p5dkhfziiyep5k3vgls4zmom3sb@g6jlouyvmpuz>
From: David Matlack <dmatlack@google.com>
Date: Mon, 23 Feb 2026 15:08:19 -0800
X-Gm-Features: AaiRm50_OD8BarR0N1ju3iFQZFALazFmYS4w16LFHF58C19D7VPNrgpsKvMORCE
Message-ID: <CALzav=eXY=ZBshmpi9axt+_0SxaAm0Xbo7w==nCWJwKK3xcThw@mail.gmail.com>
Subject: Re: [PATCH v2 02/22] PCI: Add API to track PCI devices preserved
 across Live Update
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Alex Williamson <alex@shazbot.org>, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>, Alistair Popple <apopple@nvidia.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Ankit Agrawal <ankita@nvidia.com>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org, 
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>, Leon Romanovsky <leonro@nvidia.com>, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Lukas Wunner <lukas@wunner.de>, 
	=?UTF-8?Q?Micha=C5=82_Winiarski?= <michal.winiarski@intel.com>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Raghavendra Rao Ananta <rananta@google.com>, 
	Rodrigo Vivi <rodrigo.vivi@intel.com>, Saeed Mahameed <saeedm@nvidia.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, 
	=?UTF-8?Q?Thomas_Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>, 
	Tomita Moeko <tomitamoeko@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vivek Kasireddy <vivek.kasireddy@intel.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ptyq4rnmbctqyp9s6h9wxeuhfz8yshxt
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 9BE2314000C
X-HE-Tag: 1771888129-612977
X-HE-Meta: U2FsdGVkX199oTWFvICgZ5CUx8roifRjIghCWq3hWw3eF1xMKy51U8tIyEMACuQryipcFH6+pSKxt/YaP1lnb0M1Ve5SRNY+Br+uyUJMQNpfhZvfVBXMzLuM4V1+neewurp6W2pDyTY7sest4f71YEeVzjOZ9wIM/ldC8GnchmkEySt3N+C9lry7RrLnvMPNYXGm8iMc5agFxzRrBFOInpwSbECFrl0tI3jju4wdk3BWU1Vk2Yvv9Ky9uxKHCHk6kbJhnB8JMaiUUVKPDHEqSEIvgmudgYTRai790Ge1yXQ6NLZsM7x2I+E54SZHQkMB3fD2oXa9VGstGm7IsrCxbcSeXzGle6nvb22tOjy7u8rE8eET3GcMe2Y//mrVlwMMWrluY5Vc8y988xkdB8tygkibMjGfsU5dvkUTj/bzVqyQFOX9J0Tfs3i1GaLzX2dFHqnUFV6Q4J2NjoYXelPZ61n+yvATdg/GTMIRV65TntaOXOnwwTq+fRwRx51uniL7e//XOCvas60DdLACvWTFZyQ8Vt7Tox3XXZ87QkIPMCV8U8sYL02crBdYvEYt5euV9Jm40mXmIZqeEie9ZGdOvqhQn+bnx1pt4/SI3Nr2Uwli7rQihtcE7ssg2Pl1cXk3PoMVygKxh+YfSciwYOf+HqPXE63sT91oLSv/b8YGvaZ0RyBjJMSbrJVMehf0UhLkNbs6BI1j4tJ/Mx07IyFIsmhCcQxkQDHFlI/Ymuo2uflJwPuI4Wr5aqKNb5s1uAeI8ybKviPF/+Ar7+EStP88jGs6LJezgKVSbhPcmmbOikLUfqurkRm2FI1Wg+A1mDTb5WjMYXEB9HBga9XoMDQ0l3f+eBiGTbdJgh3WKHBHV5K/ZNDHsizMN4ffIE+GaVK5qvaPt61oknkP0TTmidjxLoiCNzq2YGP29e860Xfo7PUAa0fXnlhZjj9k48FUf5SuY7fCZMt2lXXQjZecblg
 Cg2mHO+L
 JIFqnP/NY5+l6AwArhajQOgl0RysR1vqBw9AFdN68wv20ZI1S0Ezv37yhLCR2H+kDc+2UlpJa3VFXDnZIc9q0FxO1so84lUQTjqFAlWvkRPPVX6Puw3OCZdY+kUJ9FYCIPsXg1mWLYcl5qrmMsYWn1jkXkPctPxDAKCd7/SCEg1+9Hlma42yHtTm0gOWXJhkeMrU1g83zv7NzqqFCqXFbFNcGW134zZCQaU/PPkzMZJ43kmAjdoRsAz7ztJYIVit9v3G4D8I7uVXnJ4w=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 23, 2026 at 2:04=E2=80=AFPM Samiullah Khawaja <skhawaja@google.=
com> wrote:
> On Thu, Jan 29, 2026 at 09:24:49PM +0000, David Matlack wrote:

> >Drivers can notify the PCI subsystem whenever a device is preserved and
> >unpreserved with the following APIs:
> >
> >  pci_liveupdate_outgoing_preserve(pci_dev)
> >  pci_liveupdate_outgoing_unpreserve(pci_dev)
>
> nit: Preserve and Unpreserve can only be done from outgoing kernel, maybe
> remove the "outgoing" from the function name.

That's reasonable, I can make that change in v3.

> >+static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> >+{
> >+      struct pci_dev *dev =3D NULL;
> >+      int max_nr_devices =3D 0;
> >+      struct pci_ser *ser;
> >+      unsigned long size;
> >+
> >+      for_each_pci_dev(dev)
> >+              max_nr_devices++;
>
> This will not work for SRIOV as new devices will be registered when
> sriov is enabled and the max will increase. As we are not handling VFs
> with this patch series, this can be fine?

That's right. Since this series does not support VFs
(pci_liveupdate_outgoing_preserve(VF) will return -EINVAL), I dropped
the logic from v1 that included the maximum possible number of VFs in
max_nr_devices.

Once we add support for preserving VFs, we can update this logic.

Another way that pci_liveupdate_outgoing_preserve() could fail due to
running out of room is if hot-plugged devices are preserved. But I
don't think that's an important problem to solve right now.

