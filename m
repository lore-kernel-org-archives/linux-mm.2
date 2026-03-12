Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13FBE106ACFC
	for <linux-mm@archiver.kernel.org>; Thu, 12 Mar 2026 23:39:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A2866B00A0; Thu, 12 Mar 2026 19:39:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C796B00A2; Thu, 12 Mar 2026 19:39:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 565E36B00A4; Thu, 12 Mar 2026 19:39:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 45A146B00A0
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:39:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0F8DCB992C
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:39:55 +0000 (UTC)
X-FDA: 84539031150.23.0046AF4
Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2D58E40004
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 23:39:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="wfKBQHk/";
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773358793;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tuWxuj0biLq2l1xmhqHdX16m/kzH5EhGtvvF3ksAcvQ=;
	b=Ltvh2tgoUl4l/ACnSOb6vBUsNLH+lf21MdbTo2iKLeMCafDWFH3hrzhicFTXal5BZqLL/5
	h4ble4V6b4HsY9hDtvfuHQfDeTNC0GaiZ+3EFEj/sDAbwl3D7eTMkA10Lzih1y+FpdOVKR
	NwiM6WiYkkR14MoMKlm4Qw7tMlbJRuE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773358793; a=rsa-sha256;
	cv=none;
	b=1q5G98xqMBo9jmYMwdVIE/wt7Qe10LBqCvaspSVFwzYgFWNffcd/1JJGgt/zNq0whBotmV
	YEXVz/Cn6ZOSL3YgTw6BxFTyzK17ACNYONv5xyGi9HtPVS/zKW8MQhVlK1j7S4bZ9+ufxT
	kkEoVqlAmdn9479wotXxoztonznKsI4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b="wfKBQHk/";
	spf=pass (imf17.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-2ae4988e039so17948955ad.1
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 16:39:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773358792; x=1773963592; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=tuWxuj0biLq2l1xmhqHdX16m/kzH5EhGtvvF3ksAcvQ=;
        b=wfKBQHk/+ixdGVt1v9vjv0Bhbiw/3WT/Seng0SmGQg8hDZv8xx/MQvLLHbGkB63st5
         Q3HNGEuohNP/mHpYZpu1B6ooT1QL/QrEFemzVZzxaHY4y2BPwHHJvN1hJJ65ySJS228D
         +dks0bmuyZu92wKSC4CvFZRNn4eHGjcPr4LwGULhgNvfJk1tkuFQ9fBebC9EnGh1e3+5
         yIQ3jnysS1xbUE7wejcPlph50AwqaZhG/MxT45L4UucMVUyzJgfxe2u/rF8ScRMQIDwQ
         2A3Jr8S1zM+dZ8nIiDkPU/uGoS4DVyRx5CCm9/Kv1yogbh3U4fXm0lzqselBAyRAdLdE
         Ta4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773358792; x=1773963592;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tuWxuj0biLq2l1xmhqHdX16m/kzH5EhGtvvF3ksAcvQ=;
        b=WeQ8MOUyKzOUtk5aV5DmC6uxoj7PABl4Lkl/S13K0zyXB71Sn2dewOFQHYktDKOqeo
         15gYH/DHU+6cv+gacT57q7cqUNoI1R6hGfJGSH/AGeW2WEbWfZnbymxLkflx+DBWBOgm
         jffAGzBIOWV9vDooLDCDTZzC9gdVrGt6m/tyfWVnrQuRaGkbWXVhu3Ni1jto7l6/u8Hb
         XLaijdt/kPdou2K7uGWIfsWLUVkVwOYDfNsqr1kaxJ/UZAieDekIF2yOfqr/nMag9XYO
         3yzQuNOM7fZ+VgvpF64Fg1gl5872tTrunIPs1j1nkhNjJylcDkxniCYpscIYgedqC02s
         Cujg==
X-Forwarded-Encrypted: i=1; AJvYcCVXEzw4UN+sSfKo9zzzIMUXMpycd3GkrMO7uLC5Q6gRKgoaFFAzKp+XgLOhGCw9dSHFE5Nb5ct+tw==@kvack.org
X-Gm-Message-State: AOJu0YzAmM5jnjuL9I4rm8S8d6+gMv7dKX3a2qk1HBHMrhUHi46TXCZF
	OqF5/2qchihh2rqBGqEDd3GxODKGIMP66Jp1nTUTw3BPpcdo/Rh1RPQl183RYfpl9g==
X-Gm-Gg: ATEYQzz2L+7O3EQap+CdYZIXgfvIRrr5HO5CCng1roQOtpH41nYq0HVgiyoiPVJjqmO
	D0DkMWT9F7OP/XhAsMhyWCWjOv9OlfzJH6WGu/p3UVY3xNImx+G/Pc+0rR/lQob2eimZtSEpDuB
	6OuGt7NsLjwZvUCHLHq1Mb/mHOsQXVEfEYwOB1lavkuvzstfhcHh6HhXMBzTbniVsgRKPfebE2R
	jLTsV5+o1iEbQeXb4KfxFQ8x9io2bhk0OgImGinGCxMCIYf1Nkk85MSP0cv/ceVvqgR196k09JU
	nNvYd7VZynLJo5JU9C2L669BWjenK4xxOEU1sChlQFltappOnRoKW8iFG504xV7/wnAJ7OSPDA/
	op4oXU3UZgZywbRzzAAR+aH6irJ2DUPMWtt1MoqiTa2SXMEB1TJjIkFP90GiZKs2/lBs/Cjfyph
	SHj/GlkNj8ekMREj43y+SeI6QJfNKF/g7cYcKEx+93zJ1Dzot9EvtMuaZE0Qw31w==
X-Received: by 2002:a17:90b:3d4b:b0:35a:117:9521 with SMTP id 98e67ed59e1d1-35a21fdb67bmr847337a91.10.1773358791623;
        Thu, 12 Mar 2026 16:39:51 -0700 (PDT)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-35a03034401sm6609677a91.16.2026.03.12.16.39.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2026 16:39:49 -0700 (PDT)
Date: Thu, 12 Mar 2026 23:39:45 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <abNOwcOTXqxCxNzt@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org>
 <aaDqhjdLyf1qSTSh@google.com>
 <20260227084658.3767d801@shazbot.org>
 <CALzav=fHy23RAzhgkdaL+JA5T2tL9FT6aPgRfXUh7i9zvYCGPA@mail.gmail.com>
 <20260227105720.522ca97f@shazbot.org>
 <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=fjRPa_ZbXu7iFXyemcf_8Kq_dZTWT6c-A0bc6czF_Rdw@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 2D58E40004
X-Stat-Signature: 63kfpffngb16pp5sn5mik5mx38j3oz91
X-Rspam-User: 
X-HE-Tag: 1773358792-744650
X-HE-Meta: U2FsdGVkX19b4pUMLCG5OZnrAN16QNMnK3kpnYuEvbsIuDqpVYs0IQ7kGj7fsdNlMlbnw/cily71IQ+GXOj6zqJIC2GrSlr3OWY3vmmMvHZwUjrd11ak98t9pZnv6pviYQAPVM8OYOFoXG2gYSm4aVjQyNfqDczGG4R8spL96T+HSz66QGnRIyLwPTtWUIA+b1ld98usFczVj5V9FAHFp/8T18EIGHWK7E/5YXiQl6oQugmCWeS93llN4gBL5sybGDyMx/cb7C5OB80RdhBdciqFBUqTa3Y79v1whSm1Z9HlQKqZd3J7AXx9oHEvvZlMLPdXLfDCoa6cYbftzDhpHqLczMx5Q0VfqbYHVgHBVOaMp52b6FS+NOqzv7WEM/KC2trpTU6nEoK5ptpoRL0V1JYkr9CzgKg3ZGvS4Gy8jBUtr7h9gYW9pjlU4Gey7wgD3u7x16PZDmvA1Kj1i7JPxy/JoqRhzeq8u/rn5Nt+ef12cmvRuOzuTG4eJDnhOUmrs9P/S32df4Ueo8yWJlVrikjFWGL4Et5ki8y67pGeflygmVLtIYrlE0mLVbdIdcV4Ckvst1VOWYU3+8uC2zmgbgIWptJe1ueaHvmBj12SrngvGI/I/SOvAUg8wchEVXIfeUaKVcOwyv7RThonm/LSuA82Voym3pUKpGl03eeF1tv2eQE0bSyuugl3xkW0hk8qBEB4DXmiJviJBm7tWjHivhrhAcBwWMR/5t1BbVhqelCfmV15IxpE0K0/6dH7uR5FosU8tN/V9xUHJhoTHaJmuA6mSKDnEeEmw1jNaatMVHj0GoDLNImJfJHzCd3BQjXmAmmHqVHiM+vKlrOtK2GizhLX0EZ463UKWP5tCzZGTblQDvX3FeiUOQo4cK2DbabBa67h3WVOuvA5fR1qunpz/xOiPwa4Pbl3rFEEv+IdhwST10OyGtnpxz17ZHmMqrqZDPQ21Ct5HCE3ylscz3k
 TVvltgGT
 u2YFa9GOcZhbKGY/w3197h4QD1gdcfewlP/HZy0FaPJJtqYDSvjq1kkivXgdjeI4L91/wvurt+vZeotNp0QI5Wn6Pzs0ucOuouke6qMETJCnpQtZdCc/aDEFDCAVlERZ0vivHXScWypxwJ7uedOX8FibMZhtNcVmr4Vr0C9ol7NUKLVMYVrtFAmzMzrVUzw/7CZfwNuQyPfaIRns3+QJmet5cs9c490okxwiAXnL5vCj2yv1WP0vs5AeDaLPLltQNhSUOL4NVU2HudEwH19DgEyqfqoTq0z/WjtTWRFrjPoK/GOwbgv7nKytFeAXtMzKEhMVJW+u8K0Xd4/Ww6ABjpWe3TObv0tX/AGxTdFsPdEUul/70GxBJj4bObJ1jNEsyRLQXXPXPUDXNVPa7EY/IL+35Ug+O+VJs14du+og+C6Dho/ZhpRgcXkv1wDiU6NeSTaPb
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-03-09 10:32 AM, David Matlack wrote:
> On Fri, Feb 27, 2026 at 9:57 AM Alex Williamson <alex@shazbot.org> wrote:

> > Sorry if I don't have the whole model in my head yet, but is exposing
> > the restriction to the vfio user of the device sufficient to manage the
> > liveupdate orchestration?  For example, a VFIO_DEVICE_INFO_CAP pushes
> > the knowledge to QEMU... what does QEMU do with that knowledge?  Who
> > imposes the policy decision to decide what support is sufficient?
> 
> Hm.. good questions. I don't think we want userspace inspecting bits
> exposed by the kernel and trying to infer exactly what's being
> preserved and whether it's "good enough" to use. And such a UAPI would
> become tech debt once we finish development, I suspect.
> 
> A better approach would be to hide this support from userspace until
> we decide it is ready for production use-cases.
> 
> To enable development and testing, we can add an opt-in mechanism

Here is what I am trending towards sending in v3 as the opt-in mechanism:

diff --git a/drivers/vfio/pci/Kconfig b/drivers/vfio/pci/Kconfig
index 1e82b44bda1a..770231554221 100644
--- a/drivers/vfio/pci/Kconfig
+++ b/drivers/vfio/pci/Kconfig
@@ -58,6 +58,27 @@ config VFIO_PCI_ZDEV_KVM
 config VFIO_PCI_DMABUF
        def_bool y if VFIO_PCI_CORE && PCI_P2PDMA && DMA_SHARED_BUFFER

+config VFIO_PCI_LIVEUPDATE
+       bool "VFIO PCI support for Live Update (EXPERIMENTAL)"
+       depends on LIVEUPDATE && VFIO_PCI
+       help
+         Support for preserving devices bound to vfio-pci across a Live
+         Update. The eventual goal is that preserved devices can run
+         uninterrupted during a Live Update, including DMA to preserved
+         memory buffers and P2P. However there are many steps still needed to
+         achieve this, including:
+
+          - Preservation of iommufd files
+          - Preservation of IOMMU driver state
+          - Preservation of PCI state (BAR resources, device state, ...)
+          - Preservation of vfio-pci driver state
+
+         This option should only be enabled by developers working on
+         implementing this support. Once enough support has landed in the
+         kernel, this option will no longer be marked EXPERIMENTAL.
+
+         If you don't know what to do here, say N.
+
 source "drivers/vfio/pci/mlx5/Kconfig"

 source "drivers/vfio/pci/hisilicon/Kconfig"


