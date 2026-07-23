Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1623DC531CC
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 23:01:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B90D86B0092; Thu, 23 Jul 2026 19:01:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B40956B0095; Thu, 23 Jul 2026 19:01:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A57E66B0096; Thu, 23 Jul 2026 19:01:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 674B26B0092
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 19:01:41 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CDEF2A0ABA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:01:40 +0000 (UTC)
X-FDA: 85021565160.24.37C7955
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id EEA171C0009
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 23:01:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="qyGh/9Et";
	spf=pass (imf21.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784847699;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6FoDnuIQXevfuc8nCvkdqJumo9L7Gv87izvbO8ewc4c=;
	b=ddKqZXNazylUAHSUT0iItfKs8h8oPG+wnjS9XOfokA/fySHYJGteNY6RaJ8u/qyf/NcIOm
	ALp4WwkscI6hJW5g7kqcNpmXS//Jy9mInA6kbWx9XkknukblTO/YKVzIg3Ox41g/IyTFS+
	ecgytWHbXh+QichKVVKjMGaJiAMGGQI=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="qyGh/9Et";
	spf=pass (imf21.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784847699;
	b=aLM7988BhF2QZqmVN99LZBi0O1tieb1eOSfKlw4Qwv2PIJxE8q3OmYeHN6NMun88vCmX6s
	97pBWWvfKApnwZYNpwuFyn2UmOorzsHoBWYe1Pu19u1aPDGcNwKQloVdIhsXVa+j2Jr/4z
	dqoU1/R1U2lDPX+DVUHZ0Ci46CUJXb0=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2ccdf36f63dso5415ad.0
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 16:01:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784847698; x=1785452498; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=6FoDnuIQXevfuc8nCvkdqJumo9L7Gv87izvbO8ewc4c=;
        b=qyGh/9Et0PnnTQz7s8P/yyUCXb1q9O6s/ONfCV35xziz8SveFklMvQTE+/x6No/jrZ
         Vxl15Dm2qcl9g6CYYLH2My+h/RmemEkgfhkEze6iJAUs5PFfbF5dopEwKqh6u1LDtxaU
         lnUJ6lrxyEO5dS9MAfZgRQ3NCxV4x4h+xQvYjwwbX0n98Ch/eOQ7cawfKRhicEQIF+//
         FuiAyzqpkKvg5bFg30J6A9mPlUvPmdufcWBa7Q6anBOrOcefEdDUIKBanmrG+I/VR30Z
         mDhvQZmHPeuZmgjuyxVr8F0Rto0fD6HUhiTiigG3/Qx1zWpujTx4M7EIEfY1U32JgIiL
         xSHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784847698; x=1785452498;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6FoDnuIQXevfuc8nCvkdqJumo9L7Gv87izvbO8ewc4c=;
        b=Ocb05b7HL5J0HmDn6Jy8zETvBDUlXEoYJpf+2W+wFfz7ZpCnsMGB11IOG7ubBufkTD
         uD8k7dl22M8C+DxZ03FWBEmGzfucCe1+/Lhov6VYS/uEkD3zmN8I+6WW6ig1g35Xy3Kx
         Egh4YSJfKQWYlGFDF0lotexB6/IkZTh46MWwCyrjHl6wkqi3+nhpbUgIGdauxoB2zZnh
         FBX9PJ3Tt9mDSpTFHuOevwtC1d7OPiuyjTXpWtPlr9EVz25T65Fbg4gChT08gT0Xb/jh
         SRxkdq+Nrpk+AXsS4pDFocU3EfNLNkD6v8vKq8HIuh6bckXEOhk6awxVEyLXzlVvWSS5
         1E3A==
X-Forwarded-Encrypted: i=1; AHgh+Rpgiu4ujg5JACAcVwkGHJtAUjmYetYucZx92sUPXLtB9fgz5wP9Vd46FvTbUfgL07uQKsIgsuJIpA==@kvack.org
X-Gm-Message-State: AOJu0YxbaEe4vvDDPa9/uZ1uKuNgo4VBqVJQ3S9tj073iJapBdOiCoTM
	DSZtydl/CwDwYyR5l1Jt33ni/xzJBI9xoRtLKnyDZ+BYJJBY524bUkHjfBGAD8TyCw==
X-Gm-Gg: AR+sD134UVZZH1NFDQH/2stmyPzQNuOxcBcEs3R3MDQT/oABkC0TP7wvn/h4wrc7uyc
	z51XC2wcioODfqWQjVSUU1wVxXxLAd0wFDFZMl/gvgJs+xZq8ZO68ZjAtpZAigUcjV5HujxUcAQ
	Ccx+QziPlGbmzAd1KRQCuIlkBbl0EZa8BSS07eyHdo+utQExGlybRn4vWalYGQOzwM+5Wi+mRjY
	MuS6z0ImDLDCZl5gMFcuQM7Vrne7VUlXEMKNyVhhep+jLjm7WNMABD0eyKIjOiDIFyNGmvec6kE
	2oIB6boDut3MSOoZuCClbvnPRjLBnMFQQplfbHK8GsC3BPW61a08nCEYrMENJzrc9mla8PY9cts
	F4g5j2XzrJBj7RrdKx/ZGEUEYwRWuRcarTlxCepYgpqKUNmCqzFzFHkY7C2RjaEjwODUcZeBzzC
	xc4I65tFLMtUh7zgufvLrRze00dg+8KG4ATnyh
X-Received: by 2002:a17:902:f687:b0:2b9:e831:5e5c with SMTP id d9443c01a7336-2cfc01915f2mr1772685ad.4.1784847697393;
        Thu, 23 Jul 2026 16:01:37 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f310644sm40753485ad.55.2026.07.23.16.01.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 16:01:35 -0700 (PDT)
Date: Thu, 23 Jul 2026 16:01:31 -0700
From: Vipin Sharma <vipinsh@google.com>
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, ajayachandra@nvidia.com, alex@shazbot.org, amastro@fb.com, 
	ankita@nvidia.com, apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, 
	christian.koenig@amd.com, corbet@lwn.net, dmatlack@google.com, graf@amazon.com, 
	jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, 
	julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, 
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com, 
	parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, pratyush@kernel.org, 
	rananta@google.com, rientjes@google.com, rodrigo.vivi@intel.com, rppt@kernel.org, 
	saeedm@nvidia.com, schnelle@linux.ibm.com, skhan@linuxfoundation.org, 
	skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, yi.l.liu@intel.com
Subject: Re: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
Message-ID: <20260723225943.GE260824.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev>
 <8fd94fad-e457-4839-9e41-ae257a138bee@linux.dev>
 <20260720163452.GC1191959.vipinsh@google.com>
 <cebd1045-5dd7-4f35-8750-9c39790ceae9@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cebd1045-5dd7-4f35-8750-9c39790ceae9@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: EEA171C0009
X-Stat-Signature: dq7o9gw7sujq47w8dpsi77wcjznhjm47
X-HE-Tag: 1784847698-409622
X-HE-Meta: U2FsdGVkX19l1gvQEWkLb2IIH//Rbr8OLqMmV216mTrawJLyNJs0hlc/vOozbKNsGI730kM6fpg3t1OwNCoP0PHTbP+OXffVksDtovgjITOirt9DKbVIJWAHcNhMKtNVxwxxhyM12hy1p5eWv+XYsOQ3DncHreTTiTf7g4hNZBxinV8g6kd7ryE3RSIAQ8T4a5aq73efrlAF2BVEwg/V5dp2PGEk2gunHwnvaFE+buN1iDZsdr0vBE+IblPlOSuzs7iBCSuMLDYrP0bw7nQBqzPxwdSLPsVEwKrHbJ/k2GzALYPr67cY6Vkl3kUfUWUOsu0DhlT0MFCVCdb0JrsFr31RvvrYZPremMdCSvi4I4kI0ECx/THYnUwV4Fdzo+j0Nsgz5sJgubwQM9of3WgoPBZGBQBWK28XwkYfgxsbRqV3Zc8RPv6pxHt0Udib4EmSkS5bmZ8rAChpgUki2Zyk8B0ODykhJiUvUqF7VuuNJhqeMjn+mA2smPrdUobyj8rXTUpMgen6yoRVtdCx3++lG7gCblv9prfRQuTYUZuIrHWdlJGPxsTrt4OLuwmbn9jIBGzncNYb4MzZSXU+EuJdNDiSa81PmtgfVxj+AVmqgsSbI+0T66FEVfMcPw+2e2vP3YoVb+/uNhyaNaSQHulEXFtg/gV8zXFMSgk13rtFyVme6sQctqPqS10K9EIXD9SYfcHht1We3Cs736tSjROUmyI6wK1KzQTYImTGOW6gZeCTuGgKmltQYTl7jqwPH0CUy3651ByVfDch34FjIwWRN7aEMkVGXjaur/nnNoe68jVRKAinrWIgHCy7/F/+weNWQ08a7d3vxZKlTl5EskszbFfsH8OsOiQo/zUdGhW3vsUD6NfwIRM0SSCCigrwfxS/kkkp6W16U8NQ8VUQpU7/MXqiNGzS4pvXm3lWCPRel1hXLPuKoRa8pAg8TACD9MXxVbXOCaLG3qHOw9Kb/dv
 OX1YPwAN
 +0E0GEmS6UgyiJzflV5DowuWeCpjuoYhsrj/PufjBUg/rz9GGK/4WAYplmflVyCzHpZeGi+fm5z0QCU/BWwQ0sLT7yHj7vAqssAhu0eYaoSoFXG2CFPWtnCafppiO3qP9GrRYI5CkaawNUcYT4mzbHZyt7Qk74TqK6e/nGyG0z/8tP6DtdrajpZo9y+BTxxxovDKYxijAu6cPDBEpHQlXx09k/wd5sL1DXjhLhnbceDuwwiVy84BYoIzDHn9U8zI8wS7ncvP22rt2UrZdSVL3kWqEWvSljoWBfJ5i9EvpXWX3kTcsqNAAKC2fRhTxZqcOksjqeD0XwfoLkovKSNuA87+u9ZLsDUHIqwAVBSd4mW9YzHXgiFWuAxo7lA6C5Pj7KdW7VSHg+Z+yBmQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 23, 2026 at 03:18:55PM -0700, Yanjun.Zhu wrote:
> 
> On 7/20/26 10:08 AM, Vipin Sharma wrote:
> > On Thu, Jul 16, 2026 at 06:22:07PM -0700, Yanjun.Zhu wrote:
> > > On 7/16/26 4:24 PM, Yanjun.Zhu wrote:
> > > > 
> > > > On 7/14/26 8:14 AM, Vipin Sharma wrote:
> > > > > Testing
> > > > > -------
> > > > > 
> > > > > Tested using VFIO Live Update selftests in both QEMU and bare-metal
> > > > > environment (Intel DSA PCIe device).
> > > > I want to make tests VFIO Live Update selftests in QEMU. But how to
> > > > select a PCIe device?
> > > > 
> > > > what device do the PCI ID 0000:00:04.0 and 0000:6a:01.0 mean in the
> > > > following testcase?
> > Sorry, this was my copy-paste mistake when combining things from both
> > qemu and baremetal. You only need one device not two separate ones.
> > 
> > For testing using QEMU, you can use QEMU PCI test device.
> > 
> >    -device pci-testdev
> > 
> > In VM, use `lspci` command to find the BDF of the PCI device. It will show
> > output like:
> > 
> >    00:04.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
> > 
> > Then prefix the domain (generally, 0000) to the BDF and use the testing
> > commands.
> > 
> > `0000:6a:01.0` was the BDF of the Intel DSA device on my host. I
> > incorrectly mixed two devices during my copy-paste.
> > 
> > Limitation of qemu pci-testdev is that it does not have the DMA
> > capability. I used physical host with Intel DSA to verify that the
> > device performing DMA during live update gets reset.
> > 
> > > In my qemu,
> > > 
> > > 00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest
> > > Service
> > >      Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> > > Stepping- SERR- FastB2B- DisINTx-
> > >      Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> > > <MAbort- >SERR- <PERR- INTx-
> > >      Interrupt: pin A routed to IRQ 20
> > >      Region 0: I/O ports at d040 [size=32]
> > >      Region 1: Memory at f0400000 (32-bit, non-prefetchable) [size=4M]
> > >      Region 2: Memory at f0800000 (32-bit, prefetchable) [size=16K]
> > >      Kernel driver in use: vboxguest
> > >      Kernel modules: vboxguest
> > > 
> > > I am wondering if the above pci device can work well with this patch set or
> > > not.
> > I think you should be able to test Live Update with any PCI device which
> > can be attached vfio-pci driver.
> > 
> > `vfio_pci_liveupdate_kexec_test` will initiate DMA if the VFIO selftest
> > framework has the driver for the passed device (Intel DSA) otherwise it
> > will just skip over the DMA flow and do the remaining things.
> 
> Thanks a lot. I'll run some tests with QEMU's `pci-testdev`.
> 
> If I understand correctly, when using `pci-testdev`, only the DMA test case
> is expected not to work, while all the other test cases should work
> correctly.
> 

Yes, other test cases should work.


