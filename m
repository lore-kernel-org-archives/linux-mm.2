Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39115FF8867
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 21:31:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B0606B008C; Mon, 27 Apr 2026 17:31:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 960ED6B0092; Mon, 27 Apr 2026 17:31:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8287E6B0093; Mon, 27 Apr 2026 17:31:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 718FA6B008C
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 17:31:45 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1A5541601E5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:31:45 +0000 (UTC)
X-FDA: 84705632970.18.CDA6286
Received: from mail-lf1-f41.google.com (mail-lf1-f41.google.com [209.85.167.41])
	by imf19.hostedemail.com (Postfix) with ESMTP id 087F01A0012
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:31:42 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wbYoe4Hw;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777325503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4fbSZrcbEX7pFS60K+snXC2z4cFQZ67H6ZAP0NTDTDM=;
	b=gYW5D3H0cLvvKw82GkkDEAiAebcHdPxzjmoROvOTxrKue67JF/NVHkNzDJYQiftkcxL9zk
	2uHogqXVhmx8kgkf+4q7PjtF0djry2sNyoSDmRx7DNBw2vzAPo1TsCHDBwBKJBVQZN5ZM/
	sM8Pi17IRhs8M6AtFJ2C3JkraBMdsao=
ARC-Authentication-Results: i=2;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=wbYoe4Hw;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.167.41 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777325503; a=rsa-sha256;
	cv=pass;
	b=co3MS61jYRDkfcprSK9++sUH6OxozRBjm+skzuekb7MKnICrpU6kNy3xTDRoLA5F/AYjLX
	KiabsAMkG4ooO4mSOuZ2kncJiawcDSRli0evbYib+3RL7KB7VBxHKcTefTM7jbin/kIGOP
	lJAtecVauzjlpEZ1Xe3Q33Smtgr8Fp0=
Received: by mail-lf1-f41.google.com with SMTP id 2adb3069b0e04-5a3af1b7549so13262201e87.1
        for <linux-mm@kvack.org>; Mon, 27 Apr 2026 14:31:42 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777325501; cv=none;
        d=google.com; s=arc-20240605;
        b=UfnsMVI4fXJqXMqDM7r92BXZR1A2h+tLdkPWeoxpx07D127euY8oDd0qUZQHupN96W
         BYdzI+zkFD6CalMdu/eowX8uw0RhSZnqRY/FTHHmPuSLEgdHAsW38kti5l+vcHLGYphP
         /b3sRxtWMoRmtPwohJZn2c/2uic+reyVLsPfuL9ezdl1kMh3Yr8tf0UkeDKBpzPgXTcD
         bzN4O356J/cp4ZgWqfKWS7dtHy+Yynbj1oLi8CdQHwNvX46ru+302+w5f/hT162IZawx
         M8BjGI/KZd6HeR8RO5MP+PaA4lOzli3OQqDgf7JIT+qyMXjPvTofmAhYjOtTNxIyfD86
         l7gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4fbSZrcbEX7pFS60K+snXC2z4cFQZ67H6ZAP0NTDTDM=;
        fh=k/d0ZcRzayQuXzQUL9ROuhZ6uFFZSoG5gA3Qq9LiN3g=;
        b=cG+4sWnqdoPxRf1VJTQ+RUhGhJ95LbQ+J/+fXhn4JIKshaQLvk3jnU01ifrMqKptfS
         ml1RHSRJwBF9br26XMUa5MUCrc5R64a8s7LCA2zq4BggK61hCRcqorCSywuOjKiOYLyl
         jUt6tme6FrWyTmL6c42MykuqSK4C8Qtd0h5lpFJf3z8Xft284FGIMDgQ6u5VSsiiTs/T
         AUaqt+7/kPTFeOp50Os5bSeCLFOcv4PFskZ/5GnYvO/mqfBAwceK25E5r9ygdaH867zd
         gyKyAdPIIBU0k9aknivPKJI2z3nsd+Ieyxa4JHP9bAlBOy6Z3nAZQA/p/LU6gpqATzqp
         M0iw==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777325501; x=1777930301; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4fbSZrcbEX7pFS60K+snXC2z4cFQZ67H6ZAP0NTDTDM=;
        b=wbYoe4HwOYy79uR60aRin+zhXOEJzUwfwKhsWmzoGxek2gjNu/32i/cPlPSCfq1bJ8
         ybMmVvhvn5qqOxijRJrphJIVTOgZjW3V8QQT/36I9s2NDTfGS25W8sAQQ4oPU0HTqyQJ
         4gut8H08LPNTb7s7go06hBB7LqUyIBrEeVPMbCSJCzJJS7VtGViMeL+qKRCDFMhr2/In
         u7pen5jIHM1cSLE5aLi91OFtwp4AxA/OCvQI1tRbugItPLfdp4EMSRa6tcTcva4F/t9W
         hjxL1ynEqyQpGCt5ZzuqCu9ynB5A9g5U9hNmEB+Uzs96NhXOawfrWGgLt1TQV631fml7
         lu+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777325501; x=1777930301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4fbSZrcbEX7pFS60K+snXC2z4cFQZ67H6ZAP0NTDTDM=;
        b=o+oCyJ6IdZr40geTXYCsCG77RJ9XJk/W0Sz30J+e3p0mBVwPHryFPSjKHpFwYCpLW/
         AhxVQjJu/z+2NEYF7/SRFIKoKJ0zxMLUjs5ekSw4+IU7o1sowcNWVzHw3mowl+DXxhbk
         jeIp1YE/j5lpt7nc5PW/UfgL+PAN7DXCY7N2JCV67vG9o5S/G9qjnTjNK1SaulwcJGKR
         em1/CL2rA6OV21blmhZwdVVlhDzPFHDq89JUpkgButiuS27Y3TGbR27Fj8E5Y9dyhhVd
         AAmiCYYs0uznmn2EcfWtDwOP9bxXbNubWUsWvb29mrh0ICkXToRB8H57vy7fKFlI+t2f
         3ljQ==
X-Forwarded-Encrypted: i=1; AFNElJ8QdHTO4ivoau1JQh8zoGBSNLLxOTxEZ4xbWAsCqCTSpDp2mHM/PnYVxs4IGcJtX/w4ho+hurf+/g==@kvack.org
X-Gm-Message-State: AOJu0Yw2c/m650UwvpXJBsZKPaEK46tZsu5cI6bxd9WX7wd6H86lMvRL
	BRG6LO245w72WIWEMtXl7g9hzad7SDdOcdlBPqOqp/augEWWTlIWU64pl9KotqXl80Qv0NaqdVU
	fNUpWfPP94nORR+Tez7JHo5ILo40bOD7yEkKtcEoO
X-Gm-Gg: AeBDiesR+P0VkwpysCMqAClVAdEtLqUZsAlAoSA8eC2y5dSkl3NfqihinpuYyOe2et+
	1QEM+Be8dplkf0oI++VM8KWJua8iemqSLh4Lbk5TnWc++xFTkRia9J7zq1G2ZOsMlNbr9HDBaGi
	gDmFHuk05ZTKSPQHscBW2rzVRpRbo/c0Bl3L493501edARdyyPQrQ/Xb4zMDf7tB54DxNSbF/+v
	9HlL8Z/tfrI1AJzzgsp1+mWn9hXaHDFDXpseB3c0lOpWN1Xx6s9SWmPqQ3HqqEaCdIOqYkZ1SXH
	SWfuUmyzqowj5un9HR2HF+TIiIsRiQ==
X-Received: by 2002:a05:6512:3c8f:b0:5a4:505:f62f with SMTP id
 2adb3069b0e04-5a746411871mr173644e87.6.1777325500555; Mon, 27 Apr 2026
 14:31:40 -0700 (PDT)
MIME-Version: 1.0
References: <20260423212316.3431746-2-dmatlack@google.com> <20260427210529.GA186381@bhelgaas>
In-Reply-To: <20260427210529.GA186381@bhelgaas>
From: David Matlack <dmatlack@google.com>
Date: Mon, 27 Apr 2026 14:31:11 -0700
X-Gm-Features: AVHnY4K95rEzKgWcXKT0jFnCdsBpr0VFFFUI48Oher6g49BqIzQIKoHjNP8bc8M
Message-ID: <CALzav=c=99653vuRa0S6cyAuTfP-PWFpOdopYArihOBLor6eQA@mail.gmail.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI core
To: Bjorn Helgaas <helgaas@kernel.org>
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
X-Rspam-User: 
X-Rspamd-Queue-Id: 087F01A0012
X-Rspamd-Server: rspam06
X-Stat-Signature: 4obocg9frh3ngefzc45eex4hr48nruj5
X-HE-Tag: 1777325502-988105
X-HE-Meta: U2FsdGVkX1/F5Y6mvV7CvPM0T4jZwmvGkrNA4cZiiPF2mtLvmfEaQEtOyq9MLpey2QEqvNnPQpc83RrOTR/jeDdfMDHbnWLxiPb4YaZlwk9tm9POYuqaIhKdLs9rZ3QglEJJS7mi3YDaCgrK0FtmWafpqb5rzA9Cd0+4jh16mFHav/g3velWYzDnJy765dE1Idz+wupdyFXV18nrUl3u9Rs4ztr/K4Sxik6iMzcfjCquy0t+de6hHG9556IxXPBFzA8zkT7owaDUH5hZT+X2E42IJ22l9BJdPfdhEagtjFk4EZCAlPyNt09x4p9VxoheE1gQL1TKSSnuQrAxLPqNWrtYdVD0/Gnrt0erKx8rKgGRIHme3LK6fKwOYuymbFAy2TeFSRhSyMezE1EWyqu+8mZNXpHWh2furTXe4wzr33/VaZp3GQprRZ5ux0Q/W9Y8C12kkGQbZtDPrEYCxSVj6sSwjU1FRt0+0eptYGQQV3S5V0VWbQIFWLAoyQIQxh0RpcEl+FVg/3SRIeRW8LyeMH9aNJDPc/6x/KANZKO3RopNMOogNHlS3yq94oUETGKbs28291mtcOrxtqEOXnYuSSFKFH9/QAjE5FzeIYIV56WmdwhABya7SshcaF6fJcFl+ESDUxuGjopEb/hpDrZoxqzEnBUWahBZ+3/+JpXWtlUBw385dnq1V2F5mEkDm6a70ASnThmAu4/xsSp1dnfgxvudgXBQynyukt27bjkpljmNTF6NNLaEBBWCrSUQ1kP5cMmRe+Lc3n9z+XgokOrQzK2HFZBIS3hbXdGIQR84+ysKHwHxXK4Ndt0oJmj9Cui06IVZb8RcBQ0/VkQZCdonM/LBkl/gXxMAcM+oZ35QRuP1P/P0WTl/vZVTtaAJXzppELArrsk026+numH7Jbauw8Z8n5C1mw0rpYpjG/1cuvACp5VCaBACWWRaCt04Y0EFFl3I1kRzehuQ8EhrUGJ
 Qt2K/VqR
 L/8t5Bc0djAqkA4o+n7P5kdMtgpSEvNgFyqggJPcLEav6s9nUOk2joKmGUarIOLcJ/8KtGNv5B6bTW9hZXn46DAoBS+k5woUCi4HFgpINopX9l7KQmcU7MjqumL3jFy6btm9KOzGcFejLUP1s8EVNVl+6k1BUJRz1LC+WUAlrUQyGaKEyVDwemOiIv8ESl6qt8ifJV0x8Vw2pjst0fTf/81nI0/96CNZJ+c9MZytBt1GRSkzTQp16Y/7JEFh0fSFxfRoBAhXf+9F8CQEfWo12DFX4Uo7csHl7bnhnlA4YALReymjOBW/GnWG0ztTlhKuJ0Foq5+NG+SQ18QlGz2COclFuMhsSHBnsYdFnVcDlPfth6E5CUE/V+UquxCPRuz0hoSm7VQy/fzD2/fw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Apr 27, 2026 at 2:05=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:

> > +++ b/MAINTAINERS
> > @@ -20555,6 +20555,18 @@ L:   linux-pci@vger.kernel.org
> >  S:   Supported
> >  F:   Documentation/PCI/pci-error-recovery.rst
> >
> > +PCI LIVE UPDATE
> > +M:   Bjorn Helgaas <bhelgaas@google.com>
>
> I don't think I want to be the primary contact here.  I'll see patches
> regardless since they're on linux-pci.

Ack, I will drop this line from v5.

