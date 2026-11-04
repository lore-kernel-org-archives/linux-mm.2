Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD68A6074A6B
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 18:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=soleen.com header.i=@soleen.com header.a=rsa-sha256 header.s=google header.b=fsl1FZP3
Received: by kanga.kvack.org (Postfix)
	id A5EBA6B05B2; Wed,  4 Nov 2026 13:00:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A0F726B05B3; Wed,  4 Nov 2026 13:00:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D7416B05C5; Wed,  4 Nov 2026 13:00:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 533CB6B05B2
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 13:00:28 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A3CB5160810
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:00:27 +0000 (UTC)
X-FDA: 85398201294.25.B392D9D
Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 8494618000A
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 18:00:25 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fsl1FZP3;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793815225;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JAX2rOFX3ps0z7E54cgly2XJNYqW8YfGnVzidzlyKN4=;
	b=llJZCwTG7W2qoNqNHAtJjjDTYEbexZNGoV3zWI+Dv+FMWcpievgeXIekz8RcpLO2Qj8Mom
	wcu8WpS3Wjbnd/EKKd1g/laXbrRH4FrFF6Tato1zSN3KZMD8BItUkiCwmvIn1B9wIo7STJ
	Z5D2v+8TabsTHuVkNsVQ9eCnK0SjAQs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793815225;
	b=txSmFT0rJoWbXWprle1L0yqhG2/sBA4B04jAtp6DCWQQD9KWzLBkIegByHlcxzwj8jPLye
	tuZBxzdeuN9lMEj5/q+XGlvMZBgFJEX0ZEJX5w336oGKsr/epfxy0V8oERTBbadsTdAUSv
	9FQqLgDNIqgWDMoJ+28h1TESmwMzCXA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=fsl1FZP3;
	spf=pass (imf24.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.217.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-7a6e560f580so689872137.1
        for <linux-mm@kvack.org>; Wed, 04 Nov 2026 10:00:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1793815224; x=1794420024; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=JAX2rOFX3ps0z7E54cgly2XJNYqW8YfGnVzidzlyKN4=;
        b=fsl1FZP3qIClu3aJmYAbmvu6S56jDVfjWiW1HR+5Ch6CXWyX1Kcay8k2+QqjtBIRP2
         bQVURg6N4/e3wjhXOpQenCm7hMa5VoZwBw7pDUAvswV+Ae1o3SG3o1BklbhnLq6dYggC
         rh6fAoKAiNFr2+PIjGZCn0mRfSiXZu9Vl9xyUcu/j2jN06Tf4/IluR5pk1nmVsAg6JJY
         pEWeZr2m5yL70f0CFt7yiWQ+7wzNJTUvU/ABdL/aWe/M7QkSBeZizfPS80FtaNgyQ5Mo
         WMkMI1B/a2Cd6VjTxTbRkrrau2J3Ea3TTs6eCf3U7Ca7yqyo+MrZi4mfn5zjMfF9SiZz
         SwAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793815224; x=1794420024;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JAX2rOFX3ps0z7E54cgly2XJNYqW8YfGnVzidzlyKN4=;
        b=Bow1bxd9SlpWiBE0jTBPrlqdGrYX0tg/g7CGE29ePYMR+3zpQqFPKwVHKBu31mx9zh
         DU2XSDkClw0+DuSS1uPRUrK12GV3vLt4ShEaaJdPfh/r9r0bIBr+wrSlt6n05MyMXJD6
         zmifc+n785FzEXsJBZA0cTBAkrcSuJeTCpWitl9I3KybToIBDe7t+HKir3iaoyDy2i3h
         LJNV7YFsm+MiRd+qIanYJFcQv2OfuVlr3i0fZyfr11IAagg3HIzMjsiSF0F5AgRe8ByU
         xCe3LzbKnUghFNIXJx0nleJY8zSbH3wbTNk+YDabQFOPrWAfRHTd+nKJqKrpM3/mb1dP
         Kl+w==
X-Forwarded-Encrypted: i=1; AKwUvBxi5XcyOTBThFHReJbJE+z9+9CxP3IDTKVZmDBKFCIPePRhVXAUuFNtzsD/2vC3XZcXVn0iJ0Opsg==@kvack.org
X-Gm-Message-State: APuU4Z+PjRrNNC2lRwtaBsRkr4LdfnsoqOfMVzP7+N8/0HiD/vD0PP+3
	jAn4Qv8dbPzDn7uXSM4M/Sb0EmoSpjiAE8OP6eL+utpdgpPo7U9YDATe8MQrVbYW7aM=
X-Gm-Gg: AYBFou2h7VT1e4CXBJo2Guvl/ii4a/r1P10wlqpDfUIWtfnbqz4EuQLxx1J6imfS5SS
	ZZIiFoDhRlMdxR2UoVL39qWgFQBPfiYCk8FYAzTlCWNtTISewbvOwHUp83wgvIzO0aZ/5l5R2w1
	vaeMp9uYSaQxyNivyNQFYC1TTYDEurJHgLufM90s97RDrgjbsbFGR3u7a5sgZkylYv56gl7lxC+
	ptSv4KElaGA/qgcWzWFXMUmHvy17l6ERlMZ0IENaqm3KZpZmIXRIze1xTzdJ1d4G5vTV7ZF5kTp
	wEOHiNozZGr0jbVsFUfLJmndFsVXkpNAPoSgcKTGEXU6TnlCyafVBruG1D24fHQpOZms3Q2YmuH
	3UI7RA66LofNh5R1+lc2YvuozscicZo7qAyFrhI7lEr1OU16DcXdAtb5qYIk5LjH1v+EXZpXZde
	H3YJdkckijHO/CJg+MnwE3Il2tq0GfbWhZD2/HCER8xUn7K3YMQQSB8XuLF24RAWhoN1GMbWXwO
	pij/7w0vwFIAw0StrdtpMbYhqbYSSew9kSHKDIwRuIHpLiJUdRlFJU4BwpEXOQX9Cjo13dDhaK6
	WQ319PVHn2JKvRUQAsDppULsjrYr9icikctgFneOkZ9pTXZNNqFNId0sFc+G0HdG8um3JRB4rEn
	BEaQZU+ckDk/XYFidD/5g+gfxzrsK
X-Received: by 2002:a05:6102:fa0:b0:7c3:9982:67d7 with SMTP id ada2fe7eead31-7d072670942mr7469213137.16.1793815224323;
        Wed, 04 Nov 2026 10:00:24 -0800 (PST)
Received: from google.com (16.49.199.35.bc.googleusercontent.com. [35.199.49.16])
        by smtp.gmail.com with ESMTPSA id a1e0cc1a2514c-998d91d2a3asm2383636241.8.2026.11.04.10.00.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Nov 2026 10:00:23 -0800 (PST)
Date: Wed, 4 Nov 2026 13:00:22 -0500
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>, 
	Bjorn Helgaas <bhelgaas@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pranjal Shrivastava <praan@google.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v10 00/13] PCI: liveupdate: PCI core support for Live
 Update
Message-ID: <autxCZPJ9yiE2ucq@google.com>
References: <20261013162529.1928093-1-dmatlack@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261013162529.1928093-1-dmatlack@google.com>
X-Stat-Signature: 8j61ommydnu8jtk5ze1xkue1ecu7r86i
X-Rspamd-Queue-Id: 8494618000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1793815225-847757
X-HE-Meta: U2FsdGVkX18WGu0gTqWLUd9drqH2a2FC1Rc9vb/2BziQgtUq90ZKwzjcxc7P1bftZoj6INDIhJTYegDWLDJHqxLWTHABAmAvLwmH5Gqk1Z+YaV847PolN2SvGqmsMk4l4GbwWRlEyeqaQWq2aU31kHwfau/XJR3p73udr/HkxpYmCksnf2QQoc94m4UhWgnx35bsHJc/K2lLmMHb6wa5sL6uxhxL6vakh6ikSL2QnIfefxbfH4oWNUMLaTmKKSNzyQGkCD36usj+DosQe2HyrUPi0JZHEYhMfoQY/bR6oCcjJP5Oz/PtIab14lv558makuWU+T5BqPmnGOX92u3MFmWW7/Y8wBfUZR7ZXzZlC+4rpGBg6HlUdScrqozqGIgoTX6P6YmCXdjIwcirY2F3JMdBWOPwyz42BlENuJFxKS0VoLRC+8FuxMZ+y7ZgFOl5vpD1OQOG0DyDogJUWy8ekskmwRIjtIu3dhcI+ZqJ43F6cRQY5g0HJrP39snSX6kjCiX4NpqUXyirwimG+bmeJ+FZQxDRb8C14VaGtkT9jnNaTtEGw3Sj9LR+Q8qdtUbRoDA99FgJWtQ1hW91Ids7+7h0wVShm94haQheT72MSp3STYvavgH9MB7sWPtjd+G+DREhBBfzPBjxnLm25Hph3iQEDkHY69dXiiNLxgAYTnmYXfKIT1s5gbuI88/JKrQZApmiEjfMGBoCaOTQAypiQWUuUmUTyLFN1+l2AFz1T1TdIomTkR77Q+mvHS6U2gFbTemAcbs1DUXXifRi5E2zrGPIulXsY4LtTLtVFEwQEPw7KFjV1l0C1Akp7DJ2CEeDrfFO6D1ITBtl31jFyM+mzGLucivDuNoLBJ3W9YrDogZKS+fUePuS2a58X7wx30db+j3OvQXkO4uqeZnKD74ptD/fwNVmA6y6SoPnLNhukDMMpPb6P0u7LAeln6klQu/RkMHP376ztBTL+7E1jbo
 RC2gIDAB
 UfUi8I5ZaAyqt64wjfj541vGMyQMm/I3PcQIfJAiHPAfFbbOgXwTlBlpc6uhhNXMSzG6obN5agLJ1bR+xx8Mv2AxtPYAHLQolqa7wtJ0JcDYqQY1E25HFmqJ3Fy8yElNBR4q8sAJ7EAJPJScAdKvaFXrV9gW6RaYcvEHM+GYlnXtv/4xQt844WUOWNqlALXHMkrOc4phYqa5k4niyY3rnnOk3CFv1Dhn9w70DhMgkMh74YbpJUIGbV+Lzyk+C/5a9JfORlSzIYQp3UEyz7fxSoB5DEfFf0cVq0A2nz2kN+VL2/z5u6Kk8c/MxZB8ovBvvGX1zqJkq0zJpQki5WIwOOmSDyjduAV81sdezn2W6Z7ebCCgN90JVgzThbzqj3CZ/2d6UzQM7gK/VXR2ihCCsyCmTvgitxH50XUrMaOu/GHfU5iE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10-13 16:25, David Matlack wrote:
> This series can be found on GitHub:
> 
>   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v10
> 
> This series introduces support in the PCI core for Live Update, enabling
> drivers to preserve PCI devices across a kexec-based kernel update
> without interrupting the device. This functionality is critical for
> minimizing downtime in environments where PCI devices (e.g., those
> assigned to VMs via VFIO) must continue operating or maintain state
> across a host kernel upgrade.
> 
> Specifically, this series allows preserved PCI devices to perform
> uninterrupted memory transactions (DMA) targeting system memory
> (specifically, preserved memfds) across a Live Update. These devices can
> be behind a bridge but must not be VFs. Support for P2P and VF
> preservation will be addressed in future series.
> 
> Series Overview
> ---------------
> 
> This series implements the following to support PCI device preservation
> across Live Update:
> 
>   1. Set up a File-Lifecycle-Bound (FLB) handler to track and preserve
>      PCI-specific state (struct pci_ser) across Live Update using Kexec
>      Handover (KHO).
> 
>   2. Add APIs for drivers to register devices for preservation
>      (outgoing) and for the PCI core to identify preserved devices
>      during enumeration (incoming)
> 
>   3. Automatically preserve all upstream bridges for any preserved
>      endpoint. Use reference counting to ensure bridges remain preserved
>      as long as any downstream device is preserved.
> 
>   4. Guarantee that preserved devices retain the same RequesterID (bus,
>      device, function) for the duration of their preservation by
>      inheriting secondary bus numbers, subordinate bus numbers, and ARI
>      Forwarding Enable on preserved bridges.
> 
>   5. Guarantee that memory transactions to/from preserved devices are
>      routed consistently by inheriting Access Control Services (ACS)
>      flags across a Live Update, from the endpoint up to the root port.
> 
>   6. Modify the PCI shutdown path to avoid disabling bus mastering on
>      preserved devices, thereby allowing preserved devices to perform
>      uninterrupted during kexec for Live Update.
> 
>   7. Provide comprehensive documentation for the FLB API, device
>      tracking mechanisms, and the division of responsibilities between
>      the PCI core, drivers, and userspace.
> 
> Merge Plan
> ----------
> 
> This series will be merged through liveupdate.git, matching the
> agreed-upon tree in the MAINTAINERS entry for PCI LIVE UPDATE.
> 
> Testing
> -------
> 
> This series was tested in conjunction with v5 of the VFIO PCI driver
> series:
> 
>   https://lore.kernel.org/kvm/20260714151505.3466855-1-vipinsh@google.com/
> 
> The full set of patches used for testing can be found on GitHub.
> 
>   https://github.com/dmatlack/linux/tree/liveupdate/pci/base/v10-with-vfio
> 
> Testing was performed using the new VFIO selftests:
> 
>   - vfio_pci_liveupdate_uapi_test
>   - vfio_pci_liveupdate_kexec_test
> 
> Both tests were run in a QEMU-based VM environment (using a single
> virtio-net PCIe device connected to a root port to exercise bridge
> support) and on bare metal using an Intel EMR server with 8x Intel DSA
> PCIe devices and 1x NVMe device.
> 
> Future Work
> -----------
> 
> Please see the PCI core Live Update Roadmap:
> 
>   https://lore.kernel.org/linux-pci/20261001232133.560284-1-dmatlack@google.com/
> 
> Changelog
> ---------
> 
> v10:
>  - Save and restore the ACS Egress Control Vector along with the ACS
>    Control register, sizing the save buffer from the HwInit Egress
>    Control Vector Size field (Alex) and drop Bjorn's R-b tag
>  - Make CONFIG_PCI_LIVEUPDATE depend on 64BIT from the first patch
>    rather than adding the dependency later in the series (Pratyush,
>    Mike)
>  - Reword kernel-doc comments to read better in the HTML docs and
>    spell out "reference count" (Mike)
>  - Replace the version number at the start of struct pci_ser with
>    required_flags and optional_flags, and record the size of struct
>    pci_dev_ser, so that the PCI FLB ABI can be extended (LPC BoF)

Hi Bjorn,

I am planning to target this series for the 7.5 merge window through the 
liveupdate tree, as we previously agreed. However, there are still 6 
patches that lack an Acked-by from you. I believe you might have 
reviewed some of them before, but the tags were lost during subsequent 
refactoring. Could you please take another look at the following to make 
sure everything is in order for us to merge the series:

PCI: liveupdate: Set up FLB handler for the PCI core
PCI: liveupdate: Track incoming preserved PCI devices
PCI: liveupdate: Document driver binding responsibilities
PCI: liveupdate: Auto-preserve upstream bridges across Live Update
PCI: Save and restore the ACS Control register and Egress Control Vector
PCI: liveupdate: Adopt ACS controls in incoming preserved devices

Thanks!

-- 
Pasha

