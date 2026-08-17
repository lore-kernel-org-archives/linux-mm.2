Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37641C5DF7D
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 21:12:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED1956B0852; Mon, 17 Aug 2026 17:12:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E832C6B0857; Mon, 17 Aug 2026 17:12:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D49E16B085C; Mon, 17 Aug 2026 17:12:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A83586B0852
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 17:12:56 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 418A8A09B2
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:12:21 +0000 (UTC)
X-FDA: 85112009682.26.133F63E
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf06.hostedemail.com (Postfix) with ESMTP id 6D8BA180006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 21:12:19 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PYl1wBGY;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787001139;
	b=kTkbt9ZMad87iqO9Qu6x3eNbYCfkP2DfA+vgpXjWhQUu2lBXfPLe1OZEZr7YmVa9GTpBQL
	JasDMh2Q/PvomOMaJSKOmj6jEYbXRTttdRjKVl1W/9h5kQhUvATGQ4g9NDMHD1wXm0C+jN
	BvvrHwiPt0/oXakGCJ5ybR//aoIn4qI=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=PYl1wBGY;
	spf=pass (imf06.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=skhawaja@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787001139;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oma5+/tlfa1RRzhj7JpkkV8zgHZVnZM8SsuwDuMX0+U=;
	b=G17QQViuTns8jVd+cr7GW5oQvyRx1DvilHx22G/O81NbJi0biCbOFLXh7jxfpn86viN19l
	smqo13WoSDMS1MX9h7xQz1jTdzul+pNZ2XUf7l7kjbkYEzDa9JKUHFELdnH+L9/c5ipUIC
	BlYNAAAZXe+RBmY24qFElrRaf3muAQY=
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2d3b440b97aso15405ad.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 14:12:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787001138; x=1787605938; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=oma5+/tlfa1RRzhj7JpkkV8zgHZVnZM8SsuwDuMX0+U=;
        b=PYl1wBGYri3pnrhwWDWt+SCkYvGvcPJG7TF3rDhcCJ2/3nUzfzWr1fZV5b1ZSzvJdl
         kZdxIcz/FQDuI0Uy9fP0DyUCTkbHzdjfbjzfqPf8T/LT8ktmJzamDPVFrgGBXW0+Fp2B
         5fuWIMBAVGKDoCmtj/g4A4rj8izrUcLjmIivvcXYDFEOC5MbjfST/wKNCMHR+Bi3nUI5
         e34aiAxL4LX2g/1QqGQb+hMtIv5LE4RaLjWWEsR5T6plXEWhofD6dc6ml0QTsg5cMqal
         JEenDNQ8EK7XhOF5L+jJO7erb9xfGhJHmm02bgWbC3L5E5QZ1CEUOPk6G0VEpzv8JFbB
         NayQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787001138; x=1787605938;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oma5+/tlfa1RRzhj7JpkkV8zgHZVnZM8SsuwDuMX0+U=;
        b=HMVw2YaC5wCTfyO0fEhKlowRo3Ewk+INBw3l6aqN2MIkeKe7INp4kSUiGDWKfzKjZ7
         rji3VpNWa8NZCJTiaRVN7bxU4TDHZPglIMbC2TIhRZytJn6rEAcpnd+i6CR0fOJUcIeu
         2aN4FCqeEYPW1OWcA1CEYjWcNfj0yydV6VkVpX4JEPABm7kpxYQYuqOvVEtxAHHYZs73
         WjQPdKo6UD/C4wvUuwAQYfV5Jnkxm4JjviILRe7B7ItljmZtoUbEymqtGxu+C7OZwv0L
         K2u/mAINlUOUP9NiYE2DC5nKmls7lz8h7HyYDb8KpECMd8qY6h6ntlpAss/Srb2cuKp+
         iOrA==
X-Forwarded-Encrypted: i=1; AHgh+RrguGrwvAGT8DUKImhgI46Nv/2iOGgVBXS+f9qB5u/Me4jWaWh8Fpd3gcZPCOTF3P18lESPLUADyA==@kvack.org
X-Gm-Message-State: AOJu0YyRXXiFI3wUOV0Sgm/o0lYZ8nugSACpelp+w0YoddTKGAN/YNmy
	sE6V7wMKBUQqE5KdRtzowh/ZWN3BZ8k/f6LYbGen8000c+oFv4Yr6vyd2jXwqK1Iyw==
X-Gm-Gg: AR+sD12LDhKUGUUUZLcOQd6SwgHAaJf34G4yjHLG1BrgjkEUwAiqiM88RM4KXtLRCeK
	kbm+/sSupKhV8QKlFA8p4/Gtipu0Fl3mwE1+xuu9ReFKj1Wh/Jy2FSmDj6PBwMwnPrBAuBFbni9
	eCbpQ5wXt/WduHFdSun/SLaW8dPnnfoh/GB7SWD6kOD94BP/mYyoagZy3hwdNojLCUyjOZHfdL2
	kXIHXoOv8f+LYoS/i+lcx9Sh0RpiZwrfZ0W5/9GrSiwo6ay/jJwbEj4uTMwP6PXrhCh+lTVnVbu
	VAUrHvyzeyF1bmrevZZEMX4AXdlYYEGIsfSswWNfpttWeSEV4Qk6IpeNf5FLMVPuzhFVEVYt338
	lqJqRZw4tpkm8ZQ5VT3RpR6I7oHbU9Q/hpDvcfim10EbtWxKZOnJ8nu2imVQ4+7Qn4TKuFu/5tL
	VdANKezFxIwP15lAW70/UK9HT89l+f66Z+2O3sLIHiHNnzG5y95DRkeaus+jbccz8N7Kg1qfV4X
	21IdLkcopjeYZN4bvTevGnOIjnyaykQSF+VZ6RUgjRQ0qSL/gASMgcgCpF9O7vHu4nwzw==
X-Received: by 2002:a17:903:1b6c:b0:2c9:d89f:fd98 with SMTP id d9443c01a7336-2d5ccb2615emr3070545ad.1.1787001137341;
        Mon, 17 Aug 2026 14:12:17 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2d5c1e528b3sm7631765ad.46.2026.08.17.14.12.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Aug 2026 14:12:15 -0700 (PDT)
Date: Mon, 17 Aug 2026 21:12:12 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <aoN4YxRo1TEcVuaP@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-2-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-2-dmatlack@google.com>
X-Rspamd-Queue-Id: 6D8BA180006
X-Rspam-User: 
X-Stat-Signature: 7rw7pkn5pzu334z5afmp83hs4hbuahpw
X-Rspamd-Server: rspam06
X-HE-Tag: 1787001139-135748
X-HE-Meta: U2FsdGVkX18mwvKeVZ04LZ3DkWDCUdG7kUbO2pyMD3OvSKFoMgvYgqFH+Txad0tlxqO759uPG5boKiPW5+Tam2ttD7Bx0mq6BMd8lznkppdXa+Trwa1mu0Pd5tO6VoZE9UHoDghmqomj1CA425d7wXue+mUca7YG+r0gjAbvpdAJWt2ACr25OORrIvXqRs5A3I4bSTARbo8PyRke1Hv5ewYlk1Xw5x5Ae0zYaqLQi976Xchvck9Zx324/Dvu7mFR2SSKgWM+8Dms6erW6qfR8+JNjjIiMX1FOaNDqs+nuICNyC3/XCEI25xi1j3h/0KJKlpr7myWFeRHSUQBHxwfB/ysjNa6Ah5AC0s84mCrmXl1HRLxUxURtgETr8R3zM2PtolxE/M0s+Q1R2+581Z+Et9JATEn3v/yl63dqJ8uxf3rkZFRN6dWDfm8pGnfhZv2YJpzGg1oQmJdgoN6sJSFSwwyktxl0mfB0EYdKvqSeg9Oy+WFbdwMin2egWSAx8PngZeqI8Ztlub+0yHy/Ilf7ZZbZz4aa0VjxIG3a5YMwwCGoT1/blF4p3CdSIcb/2wsBvMjXXudBOXmYWBeGYR8tNG00gK11N1b5nuZI54rYXkOnmmi7bP22hdd8/G2JPNGdw3V9vyOs8wN7wDfEo6nSvMRLx0AKIeDLC89GuCQHrRbVBxkN7BQycM4nYCDzgt3n1DxQs0HCeGPbaEiQa33C5lfW1W6R3kFbnZKsE5+8vIsCExtF4TbFM65dn95ji5Ug8sgNL8VctQ3Awt6hXCqjjeLTJpJcv7LuFmM75VIft/HiDu0GpokwZV7xC0qss0YX2znLO6nL9FPlwERVxb1zKJ5l8lRpKRqP3Im6L3QnqtjQrOvHsTaY/qPg08XvHZfmEYSEw5k57oLOTOiqy6B3K/Ce4hpge2zk7hzZxJCLMIgHV9vDv5S/tPmApsxW2x+l0JoQ6F/e3P3D2OW8u1
 rJbHJImA
 bUq3XUbzZZ/dlpJRPATxvAjRRcx0D6tnZmwndQbYdzNBGmcKho0ys59QKIsKjU/zD9j3ZRFw9ZeRUMw4COJScHo/5hd/u5Kv0drYDnWOO2QFlCicPzQA5YTbdwWt34721N0lYKfuuVqL0N+32/iLNyOp2hP6Blsq6c5qoPQcielTf9PYr2xBXMTwbw7kmVSFaJGIGWhMdTW8tHcgBdX35DhADNJcTOeTrD5L9zStU5Y9jI8l8hk1skLIcILQE0/HLeAcAl1qS63mFEcw3aPjWh3Zvmm4ATAgmMSihBciEGdnVFl1ZvO0SCzrMAfZHu4V/XfyOfWpWpVlkkEVLK7l4NeYqnX+isBm5Kd3S
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:09:55PM +0000, David Matlack wrote:
>Set up a File-Lifecycle-Bound (FLB) handler for the PCI core to enable
>it to participate in the preservation of PCI devices across Live Update.
>Essentially, this commit enables the PCI core to allocate a struct
>(struct pci_ser) and preserve it across a Live Update whenever at least
>one device is preserved.
>
>Preserving PCI devices across Live Update is built on top of the Live
>Update Orchestrator's (LUO) support for file preservation. Drivers are
>expected to expose a file to userspace to represent a single PCI device
>and support preservation of that file. This is intended primarily to
>support preservation of PCI devices bound to VFIO drivers.
>
>This commit enables drivers to register their liveupdate_file_handler
>with the PCI core so that the PCI core can do its own tracking and
>enforcement of which devices are preserved.
>
>  pci_liveupdate_register_flb(driver_file_handler);
>  pci_liveupdate_unregister_flb(driver_file_handler);
>
>When the first file (with a handler registered with the PCI core) is
>preserved, the PCI core will be notified to allocate its tracking struct
>(pci_ser). When the last file is unpreserved (i.e. preservation
>cancelled) the PCI core will be notified to free struct pci_ser.
>
>This struct is preserved across a Live Update using KHO and can be
>fetched by the PCI core during early boot (e.g. during device
>enumeration) so that it knows which devices were preserved.
>
>Note: This commit only allocates struct pci_ser and preserves it across
>Live Update. A subsequent commit will add an API for drivers to tell the
>PCI core exactly which devices are being preserved.
>
>Note: There is no reason to check for kho_is_enabled() since it can be
>assumed to return true. If KHO was not enabled then Live Update would
>not be enabled and these routines would never run.
>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> Documentation/core-api/liveupdate.rst |   4 +
> MAINTAINERS                           |  13 +++
> drivers/pci/Kconfig                   |  15 +++
> drivers/pci/Makefile                  |   1 +
> drivers/pci/liveupdate.c              | 158 ++++++++++++++++++++++++++
> include/linux/kho/abi/pci.h           |  63 ++++++++++
> include/linux/pci.h                   |   1 +
> include/linux/pci_liveupdate.h        |  30 +++++
> 8 files changed, 285 insertions(+)
> create mode 100644 drivers/pci/liveupdate.c
> create mode 100644 include/linux/kho/abi/pci.h
> create mode 100644 include/linux/pci_liveupdate.h
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

Thanks,
Sami

