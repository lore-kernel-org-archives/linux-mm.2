Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EF72C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 05:35:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 55A0F6B008A; Tue, 28 Jul 2026 01:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 50AC16B0096; Tue, 28 Jul 2026 01:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3F9856B00AC; Tue, 28 Jul 2026 01:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 15FF16B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:35:05 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9FBC3402C1
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:35:04 +0000 (UTC)
X-FDA: 85037071728.09.5B333E8
Received: from mail-pl1-f176.google.com (mail-pl1-f176.google.com [209.85.214.176])
	by imf28.hostedemail.com (Postfix) with ESMTP id C5489C000C
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 05:35:02 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H62tD31l;
	spf=pass (imf28.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785216902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NSd0Snni0h0/tE0vaFb4D1at9rHpTmqJbpcAV8DTvqQ=;
	b=WPUyNM2l1Sq18auXHw4O8ghKm1915QSoF2ibPJmXaYgXj8crFR3ed0vnbxddZXNFh+xMg5
	GC9tnspK+hGcYptQXnqpQV/8Gr3XktnGVLV3vhurVpjQDaWk3HHLPTQ6BamBGR2zOvmo6E
	vN0BSamD5mwVnhlK8S3VZqL+1I1u8jQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785216902;
	b=PGUZYYHwQEMo+BOn+YgfZWqDVaCdVB4ZzAQ9PVKt/uUW9MuZLEzL+lf/a4x1KXYjS/CJ7i
	EtRqoZrNHl5wxs+wkKSJkaUg9IAYNJ4RBuADMLTBKbruszYE2P4J/OQufoOGKRmckH0lBS
	7v+AFaD9qF0HwxaRN9LGi1OKfyGW58U=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H62tD31l;
	spf=pass (imf28.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.176 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f176.google.com with SMTP id d9443c01a7336-2cacef7d299so49425ad.1
        for <linux-mm@kvack.org>; Mon, 27 Jul 2026 22:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785216902; x=1785821702; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=NSd0Snni0h0/tE0vaFb4D1at9rHpTmqJbpcAV8DTvqQ=;
        b=H62tD31lrhqZ+PxlpZYv5Rd8AsgHq4fMy0CqfQ2ewd9GJ9VSohCpjcKv4TqAjDh+Jb
         BqUt+IE4hJfBljtMUTnL8WP1C12OwuBeRMkFIt12+JyNbuzopesX9BpIG2KnyYHkUmyC
         woDp5yZ3Eu8VITbxB79mi270tfZLmkzVTMB+NFx2ynldYiaUC4i2UaQOXK1w9gmVbB/I
         5NOXC3rjBWfRMUaBbJqJO6XnDSoyzooeJEyXWKvul2aYlp+qKZ4VbSbnF/Uc6djHpL0r
         sLK91GT9xAWKj4JZ0XWjA36VvwXKc0suxTfSn9XU25s2Kx+bhcXuRzwf80Nzq23vfZt3
         uKpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785216902; x=1785821702;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=NSd0Snni0h0/tE0vaFb4D1at9rHpTmqJbpcAV8DTvqQ=;
        b=q8keiFKud3fqBGQBwte6aiu+z0wDro9eg+b9WJyEQCn27UVypTmp5wQKxu/NkV2wWb
         trOr9hPWzyfj9oJRnMS1/dCzX9dcwHUcVOXupwBCA8Vb3cAXNUFnRuNIGG9PAHp1Fe+H
         xl8gLasVaNu7V1HmfGikVOLXmbH5z9OyrEym8X+jLgSDYVrRX9zV9YUSR47UDEGVWZbk
         4Ka51Z8wBF1HsPe0knc9X9AqhUjDJRjpAHB/esiqWF4ocHzmQmTqN6AFUrUaOPfvlg0p
         IKRqTL0fiEzIe9JrtzOvB2FppfKF8hvRAj37qlk/zRpfXC3GgULXCPmOfL+5D2uz0set
         z7SA==
X-Forwarded-Encrypted: i=1; AHgh+RoMczLIItZjW94xoynfGQb1IwBagYb4iVcXb5/JBpmgot0uBrlUCn1oqlQXeP9i8xY4UQ2rqCE9GA==@kvack.org
X-Gm-Message-State: AOJu0YyQqUmAnFGrFddqTUh/CDGvjQ2W7Dm2y9SUJ/gfW4bH5rBRv9/y
	utadK4rRQRTRWZHC4CoeFeuAyDk/qJmwZdIPUIf1EQ2MO038PML4cvUeUYSDF7pyIw==
X-Gm-Gg: AR+sD12FajJizLTB7RW2rBFGwL0PGxjOuFKXAafr0ohSn5l/DoXykkg8PisfxHrL8LN
	/eGXnbKFEbZ/depIxATTSRXgj0wBTbnDsPwgTCcl3xcQ2dFrq19Y7xdivkRSSzUq72Yd1fJB1uq
	R9SgPJJC2T5BxRyFdl/rSYyajrpkwLHbl0Gg4x0Qf8WCenL0nKYtqkZ9uU8UE1FbXoTaohxN6wl
	lbCQrhAUERbelX10KaKaOu5g9k+N4bpmEhOkuIph6gRTaDZP+c8WKx9V1l4XyehBOR2PlwLSc8U
	FVUN6ja+alDPcobJD/W/cD/C3+txZ7z5JSCxUU68Z3Sd82UkiHTuHCq02SUp6cZuogWJJnTdMNV
	PwUblI5Vcefuy4WKFrE2v5ESP9UXaJms7YGXA7wm7et/aUvf0qVB0SP4PnajGIHZ4RdEdIts18O
	GL9UJWKDMWcaou/UTpCL5WXHYeQzaKMTHJfSDh3jFB12CedRRYwA==
X-Received: by 2002:a17:902:f1d3:b0:2c7:9e6a:1a8d with SMTP id d9443c01a7336-2cfdb75acb4mr15516765ad.12.1785216900834;
        Mon, 27 Jul 2026 22:35:00 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38f08ae3079sm3822540a91.3.2026.07.27.22.34.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 22:34:59 -0700 (PDT)
Date: Mon, 27 Jul 2026 22:34:54 -0700
From: Vipin Sharma <vipinsh@google.com>
To: Zhu Yanjun <yanjun.zhu@linux.dev>
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
Subject: Re: [PATCH v5 17/20] vfio: selftests: Add
 vfio_pci_liveupdate_kexec_test
Message-ID: <20260728052011.GA736369.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
 <20260714151505.3466855-18-vipinsh@google.com>
 <c3440ed3-0fc2-44e5-a05a-922344eb34d1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <c3440ed3-0fc2-44e5-a05a-922344eb34d1@linux.dev>
X-Stat-Signature: np7bdr4o3asyxupix3h1y48h788u354o
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: C5489C000C
X-HE-Tag: 1785216902-53800
X-HE-Meta: U2FsdGVkX18OJTjB58v2nKkf7nGV9TfPnF3FPnYf7k74BMwRouvI4noopfgxR7OAQ/UQ4AA5r0LjfOFoG+olj/uzHR7LNzd6mJPQKkfEIqBr4ysnKep8foBUxYbQjlO3tleBIh1T7CWy6EgEbTdcNTrf1QTRtWsjyTqoIne/iNEwbfjnE+fTObGlKmAX/H2g5Kn+T1xd87zNP5G8v4DfE4NL8aXxhGt0ULNtwKG0gl8+lQjfMKVLUhaKqv4RWPRKpo0qoFagtwu86bEu056zrQEJuMqHjkfXrHVXXXPEO5gzPqQtN5Hva97vamqbBxH7z2fGk8SnkziB1lfHfTCpH6mr3PD0xLdsOtXYiQ5D9vHEsYrHNsxfSkMMoRVC3gcFlTL0UcL6h6aaXD/INyKjTPKZjvg6uhjrSIRjUPkbsGjVqgZ7Z3oUS/k9WCi27n5OWsBIG+zTxCkNhJ1Kom1O3mTQ1zpcngLKD2honr9mpWH0nve0XZlJd22KOJAxbjfWSeLMkyhbbBnJvSC5EKnrBaEuS5IFH/T2wV15CfAEad6Ji15LnqiQp1KFuMAa0jzuq2Ti6GuRbtIGcy7HI8unbVHOsuf2377RWmo3D+p90uMZu1WFQDYXjhAfExKfSZ3LnueAS/cwdEvMlkzshP1GESa+NlTt7X/jVV/qHudoEY45v37qIKLX1jf7kS7i13N8iN67fVlBR/tndQ4xGl5ekEAGwONHStHoxn8T7UPV7LmsRvNFEOlxmD5domt2dDh2LAt/W9Xorbz521IyMIdK8B4tZeKj4TcvaJTm7UXLaurY5SzDsg+uxnlsMEZgr3DQzTuZ+nmGhTOH4iIbiRQ/6Q2g2fpPB6/aBeEKjyTQhnNAYIF6d5s05MieeTb2FVt36jaMQ3VWBS1nJ60u3Y+Wz4Hha+Po6ypNlVx0WrBUHk6N1uKIcdLMDQK6W9TDHprOt31BVF8jzOfspQQOJh5
 Eg/TxlgN
 96hlEkOxqqm+ZJT75zRt09ID1NN6WgTPQoOKmrAJiHCa/b7q6KEn26aLiKnRBZJ1mL+fONmuf8qt1y4mUuwtm6yxogF3PFFv4iMH9Z/V0t2L+JbXNSI/xX321rLY8xgBbnXMr6UIVDlIytDwfG/XdywHrlS+q5f1Y7Yw362dzRaJAnURGERdOWIMrOcHRDNmVXKsFEFPUXt3DWU7oQOF42UIl9oiS//yiDLjlLQBxnSFcA84bl3H6rmmsRouCzkiwVEXYkHvdEQdbrL4tKJgwCtuL7cy1BF+C1yt6P95i/IzyB8ubacbuw8YAnJZ8DVCc8LNoL4No4tZbkZhFXJdHwKGXSEpd0Ay354dA0aKFw+3ppavAgV18gspgOJ4nFomSnUQWUVSXMeCx3sUWyhW6itdo2vep6vuQGbGfQcUI1xNC4pY39Unbd1axEA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Jul 26, 2026 at 05:40:54PM -0700, Zhu Yanjun wrote:
> 
> 在 2026/7/14 8:15, Vipin Sharma 写道:
> > Add a selftest to exercise preserving a vfio-pci device across a Live
> > Update. For now the test is extremely simple and just verifies that the
> > device file can be preserved and retrieved. In the future this test will
> > be extended to verify more parts about device preservation as they are
> > implemented.
> > 
> > This test is added to TEST_GEN_PROGS_EXTENDED since it must be run
> > manually along with a kexec.
> > 
> > To run this test manually:
> > 
> >   $ tools/testing/selftests/vfio/scripts/setup.sh 0000:00:04.0
> >   $ tools/testing/selftests/vfio/vfio_pci_liveupdate_kexec_test --stage 1 0000:00:04.0
> # ls /dev
> autofs           disk       iommu         mem     rtc0      tty10 tty21 
> tty32  tty43  tty54  tty8    ttyS18  ttyS29   uinput  vcs6   vcsu4       
> virtio-ports
> block            dma_heap   kmsg          mqueue  sg0       tty11 tty22 
> tty33  tty44  tty55  tty9    ttyS19  ttyS3    urandom vcsa   vcsu5       
> vport2p1
> bsg              dri        kvm           net     shm       tty12 tty23 
> tty34  tty45  tty56  ttyS0   ttyS2   ttyS30   usbmon0 vcsa1  vcsu6       
> vsock
> btrfs-control    fd         liveupdate    null    snapshot  tty13 tty24 
> tty35  tty46  tty57  ttyS1   ttyS20  ttyS31   usbmon1 vcsa2  vda         
> watchdog
> bus              full       log           nvram   snd       tty14 tty25 
> tty36  tty47  tty58  ttyS10  ttyS21  ttyS4    usbmon2 vcsa3  vda1       
>  watchdog0
> cdrom            fuse       loop-control  port    sr0       tty15 tty26 
> tty37  tty48  tty59  ttyS11  ttyS22  ttyS5    userfaultfd vcsa4  vda2       
>  zero
> char             hidraw0    lp0           ppp     stderr    tty16 tty27 
> tty38  tty49  tty6   ttyS12  ttyS23  ttyS6    vcs vcsa5  vda3         zram0
> console          hpet       lp1           ptmx    stdin     tty17 tty28 
> tty39  tty5   tty60  ttyS13  ttyS24  ttyS7    vcs1  vcsa6  vfio
> core             hugepages  lp2           pts     stdout    tty18 tty29 
> tty4   tty50  tty61  ttyS14  ttyS25  ttyS8    vcs2  vcsu   vga_arbiter
> cpu              hwrng      lp3           random  tty       tty19 tty3 
>  tty40  tty51  tty62  ttyS15  ttyS26  ttyS9    vcs3  vcsu1  vhci
> cpu_dma_latency  i2c-0      mapper        rfkill  tty0      tty2  tty30 
> tty41  tty52  tty63  ttyS16  ttyS27  udmabuf  vcs4  vcsu2  vhost-net
> cuse             input      mcelog        rtc     tty1      tty20 tty31 
> tty42  tty53  tty7   ttyS17  ttyS28  uhid     vcs5  vcsu3  vhost-vsock
> 
> 
> # tools/testing/selftests/vfio/scripts/setup.sh 0000:00:08.0
> 
> + echo "vfio-pci" > /sys/bus/pci/devices/0000:00:08.0/driver_override
> + echo "0000:00:08.0" > /sys/bus/pci/drivers/vfio-pci/bind
> tools/testing/selftests/vfio/scripts/lib.sh: line 9: echo: write error:
> Invalid argument    <--- the error is here.
> 
> 
> # lspci -vvv -s 0000:00:08.0
> 
> 00:08.0 Unclassified device [00ff]: Red Hat, Inc. QEMU PCI Test Device
>         Subsystem: Red Hat, Inc. QEMU Virtual Machine
>         Control: I/O+ Mem+ BusMaster- SpecCycle- MemWINV- VGASnoop- ParErr-
> Stepping- SERR+ FastB2B- DisINTx-
>         Status: Cap- 66MHz- UDF- FastB2B- ParErr- DEVSEL=fast >TAbort-
> <TAbort- <MAbort- >SERR- <PERR- INTx-
>         Region 0: Memory at fea1f000 (32-bit, non-prefetchable) [size=4K]
>         Region 1: I/O ports at c000 [size=256]
> 
> Hi, Vipin
> 
> I worked with QEMU PCI Test Device. But the following error occur.
> 
> "tools/testing/selftests/vfio/scripts/lib.sh: line 9: echo: write error:
> Invalid argument"
> 
> Is this a known problem?
> 

Can you please check if you have passed iommu device in your QEMU
command? This is what I pass to my QEMU command

 -device intel-iommu,intremap=on,caching-mode=on,device-iotlb=on

Also, add the following to your guest kernel commandline

 intel_iommu=on

This should fix the issue you are seeing.

Alternatively, you can also enable noiommu mode in VFIO by executing:

  echo Y > /sys/module/vfio/parameters/enable_unsafe_noiommu_mode 

This should allow device to be bound to VFIO.

If none of the above approach works can you please share your QEMU
command and your guest VM /proc/cmdline.

Thanks
Vipin

