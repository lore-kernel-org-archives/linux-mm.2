Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09C87C44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 17:08:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B870F6B0088; Mon, 20 Jul 2026 13:08:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B38686B0098; Mon, 20 Jul 2026 13:08:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A26AA6B0099; Mon, 20 Jul 2026 13:08:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 66CDC6B0088
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 13:08:43 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D35A7A021D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:08:42 +0000 (UTC)
X-FDA: 85009789284.25.45E594C
Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id 053DC4000D
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 17:08:40 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jo69wKS8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784567321;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aiMphJN0hEb752W3IjRxFzmLe0gtZmSXKy+eltAZsyI=;
	b=ak1w7Lh2jDBsD05cFXWyiWYB5KSScujTmpYIyLLHVj5H+B0PS3DVGNDllspDONVHzZj3ih
	kBLx5EuuPPoGKeNsa+ST1JVqAvd0lLNtsvXXmgQ69nP1KI43SjPdADau0Hqg+8kWFL2vM0
	dzpugvo+znat3tletuYCwaUf2mFM5RE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Jo69wKS8;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf01.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.175 as permitted sender) smtp.mailfrom=vipinsh@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784567321;
	b=44E6BHHbgKZFCSDOVcaAe7yR0+iVTW3IrUiBJjHQeLUXcuKiiNYRnlYnHQhQxa7HdKOKEU
	vA1GhbU7nT9w0C5YGhVX/uitkhlHwPfne/71p1yf9JPFdihm2r5HOUG/P3mBVehYtWJxO2
	oIk/yu/CccO+qqZcUMSBLJn5hyml3s0=
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-2cede6375caso345715ad.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 10:08:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784567320; x=1785172120; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=aiMphJN0hEb752W3IjRxFzmLe0gtZmSXKy+eltAZsyI=;
        b=Jo69wKS8unKJQvhTEcRcjaMQMoRa4Vg7gbwz0PHd9RShqYe2zJK/gEiyzClvVMZf63
         NJ8kEMRhpGu20wl9O0GUqBEonitpPP+Ndr+4NSU0vUloG+xcfOV6a21nxB2+e5abHR4M
         CuFtPzGK+fvzYOyVX1kRyCPJQz9ZP9ST7S7Gy58tjIPKgE0U7im/NWnl3xnStH+1D9/E
         AY6/I/0wR+j0C5pDSg+rqiTH3vKkZhRL1UKelcL6YoCbvyVw06kh6aDlz8LEhO7hwluI
         Z9ZpiKEFypUBlQfFjLZsX/7xEUfMu9Lx5SKJB/MZYSvHfsIQtOGxyaHZnQhHucnMV4ru
         w9nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567320; x=1785172120;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=aiMphJN0hEb752W3IjRxFzmLe0gtZmSXKy+eltAZsyI=;
        b=Y9cMwCV8NTxtf3+ijtC6R/50IiqvitOpRwPphP/HJJEM1Vf/I1t7yQbQQ3wryWuVqj
         trxyZEVDYyps32dFwskBIbgKUpamDp99UGZE8hgRdqJ0VIoqUMqbzt+aYWQsLyNegp/r
         PLiFMPFSeDYkBUDUo3IZNxv3SeT6STc/pxidfjPBZs72VgXDV6B5nsF0x0pqP6Ev9dFm
         TJIy1agiMwJF4DoVplqPuGQcKHfzQoIajO7HCkMyA3osZIijHh+cqrFr/LDVnkzqvmut
         JxiUdg76Z/RouneYN4NBMZ8tsjqiTXy5abuddTnV2UgzOikGiXOpGJXVe5LEKf0wW5wC
         VWMg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3RwWblVBOWhHEel23nyRy0uuNa1XPg8F+nHgBct9siVVSVnpKWUT7+cz5NfWSahtgzV5ptDh4+A==@kvack.org
X-Gm-Message-State: AOJu0YxouDDB2AINIU/VgyEPRFzNdzb+rd4Bz7+aZ6Ikkm4EODdIhsgJ
	qvFJcPxvhedqL7MtvcLVESgQoKo6R9hU/u0Jvsbqg/O3Rh6A2jpYflf0bQeHQTZtYQ==
X-Gm-Gg: AR+sD11iJgMcuI4o3E8F7nI0cOuh1hgtgtGxx2fcJ+Xg3oXZP9vX3Tlua3QfIVEOJel
	h7N7Mi4jG/ikOw38ZEQxAMYP/48MtAUYOPA20zTq2KFiHI/EeOfM1llVb4WMl+q38jAKPkN22CG
	PCrlA+iiThfzViz4SpCfNTq3jmxOIEyCk3GtD122SvBDHiYDwZel8Z2pOAmNp0Y+eiXnj6qdOGu
	BmwJxmpJ7cTiZ0h3/9GSFFXtg9XPLHs33BiQ9FW8vTL5ZD4IvLc28U4m57enVx2NbPgS8oA7N4M
	XciymKa+72YommsKfWtTjSf2R+un4/wA52ZfTgsYsbQXeILz78PgwdCD7UqzLxucM7MqsIKK/28
	1rjEhlctCMj/v9JlB44QGBFX+FnMV4MFt6jkbFgZPjRfgkEI5cPvSiAj8jEefqxs3ObBmtTY4VJ
	7IhQP9y6IRAQlS3GuVd89CJhrKYFWORxXIpRHV
X-Received: by 2002:a17:903:4084:b0:2cf:4353:f117 with SMTP id d9443c01a7336-2cf7b35e690mr923005ad.0.1784567319236;
        Mon, 20 Jul 2026 10:08:39 -0700 (PDT)
Received: from google.com (60.89.247.35.bc.googleusercontent.com. [35.247.89.60])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e92091875sm91751a91.7.2026.07.20.10.08.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 10:08:38 -0700 (PDT)
Date: Mon, 20 Jul 2026 10:08:33 -0700
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
Message-ID: <20260720163452.GC1191959.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <2c03ac97-60a6-4352-a942-27dcebae8d22@linux.dev>
 <8fd94fad-e457-4839-9e41-ae257a138bee@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <8fd94fad-e457-4839-9e41-ae257a138bee@linux.dev>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 053DC4000D
X-Rspam-User: 
X-Stat-Signature: nrc4sgm5nq3ahdny7m4ss8cd8udzd4bf
X-HE-Tag: 1784567320-47352
X-HE-Meta: U2FsdGVkX18ZA3/dYtw7tgY2helRsJ/zXJttH7orhFqFV4KooA68drkwCIhlSs5nz2JydVF4B44KN9i5aaZo5uZ36FY3xbkmK22W5ovIihh28MUXkSWtqBvSnsrTHpzGa6mI+MBVJuAPQZl1IWfx1ZcVBjvWAaislc4pdr3Ziphu2XLhlyJ73RIsvqirozaHHANXVfcvOKZk4asFe9J9JnWoaSLdrAFI5/PuyxnUWx9ovxfciQbhWVOIT7Ta/coa0NvEW0cm5paUObGTdAlAE6KaBhcHTKqjDEZ0hO4XOghV0Z+wgoHf590By1JSSsh2RAWeM4sfUXlsK9L+Q7LxXFG2OLr3sIK3RPXQkbeyc9OelMJ9i0+2n8sLmeoJceNiCGaOgtGwdx8NZCsgER5MQnjV/UebA04OZ9mch/po76jxSKSPPP+zHFjLT2PfKFnd8/TQk2pn2Qw2ODPNRRBe2AoTsjpZDUk9G1TZK0WY1ASiUBRQX2+H2uOFINkjkTwHEIoZOGARQ83xsYseWfiRr/UmlXvW0O6kCMRaPKydq/m00ItR/dk0oINb8zvmLa9Jg4Ni9bHedj7jzoBn/rjUcuK0QHSvoz26gvIDZFTMSTXHE+Hvq2ePuTZf9Fj69wYp+0wfAdE4Jth4JsY2lJ6UVKtAx2CFQg61Z5Ges4Y+5bcyZ5S6kBJdy8O0lEgDe1c8ZKUGCq/c8zcz7gf1QqiY3yqYL3z350Vr/0C8v1zkBMlDbkOCASaoBrC+/EgIf+gSjPHokGqiZvsOL2ujO2atQ1vHm3bRK0yNATT/4Xk8Ka7P3bob5forfMs0jNXzKMIOhxSq7jEYhMT9DcXn3aDzL0koSYlnEXcdkqGQo/p3iNPCSyv07UsBlD1F8GcogA6eAlyT3kRtwxSNiSX7Q+LbNiV3EQhusjgABOfM6h1YeOcro5BMj33geRzHtSYQWwqqlSbj+ZVozoEVXRmekAD
 6X15d/KK
 gl7++DYCoFThWJbTHHgadoTSAUmC7dQNkbDUl/mMpY7LWSTk9QHM2SkJ4hjkx8obBvLfdZNFDasDbFiSNy0Yknlc5sTvvIV3MzmL3qh67ZvNyDbWJl0Qbaqlsew+Qgj1yzw9wsbGFPHxodVVO1YgDZ9dtJSc1phGv/5QvGaZV6A/W/BCEi719QeJ6FA0Ya0RwrI01Vutvlz/70JJRzUG6JVzk65zGw5x0v0QkVrDfJNhOg9ACKMMFGRwD9kRN+37qhECIOLE3h1DJ5A/qecqQ3AA2Y4DYPnebDQZGq6iZSyVyqTZ2zpQM0wErEj6myIc254pdv5JNCFo7Vv8jIWolAAlYMEIqXp7a6ydMqPHMX4bk55btJMlvNfeOI4zHXgpgr6fgxOofw0xzU9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jul 16, 2026 at 06:22:07PM -0700, Yanjun.Zhu wrote:
> 
> On 7/16/26 4:24 PM, Yanjun.Zhu wrote:
> > 
> > 
> > On 7/14/26 8:14 AM, Vipin Sharma wrote:
> > > Testing
> > > -------
> > > 
> > > Tested using VFIO Live Update selftests in both QEMU and bare-metal
> > > environment (Intel DSA PCIe device).
> > 
> > I want to make tests VFIO Live Update selftests in QEMU. But how to
> > select a PCIe device?
> > 
> > what device do the PCI ID 0000:00:04.0 and 0000:6a:01.0 mean in the
> > following testcase?

Sorry, this was my copy-paste mistake when combining things from both
qemu and baremetal. You only need one device not two separate ones.

For testing using QEMU, you can use QEMU PCI test device.

  -device pci-testdev

In VM, use `lspci` command to find the BDF of the PCI device. It will show
output like:

  00:04.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device

Then prefix the domain (generally, 0000) to the BDF and use the testing
commands.

`0000:6a:01.0` was the BDF of the Intel DSA device on my host. I
incorrectly mixed two devices during my copy-paste.

Limitation of qemu pci-testdev is that it does not have the DMA
capability. I used physical host with Intel DSA to verify that the
device performing DMA during live update gets reset.

> > 
> In my qemu,
> 
> 00:04.0 System peripheral: InnoTek Systemberatung GmbH VirtualBox Guest
> Service
>     Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR- FastB2B- DisINTx-
>     Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort- <TAbort-
> <MAbort- >SERR- <PERR- INTx-
>     Interrupt: pin A routed to IRQ 20
>     Region 0: I/O ports at d040 [size=32]
>     Region 1: Memory at f0400000 (32-bit, non-prefetchable) [size=4M]
>     Region 2: Memory at f0800000 (32-bit, prefetchable) [size=16K]
>     Kernel driver in use: vboxguest
>     Kernel modules: vboxguest
> 
> I am wondering if the above pci device can work well with this patch set or
> not.

I think you should be able to test Live Update with any PCI device which
can be attached vfio-pci driver. 

`vfio_pci_liveupdate_kexec_test` will initiate DMA if the VFIO selftest
framework has the driver for the passed device (Intel DSA) otherwise it
will just skip over the DMA flow and do the remaining things.

Let me know if you still face some issue in running Live Update, I will
be happy to provide more details.

Thanks
Vipin

