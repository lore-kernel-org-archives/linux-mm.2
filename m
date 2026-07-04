Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2F37EC43458
	for <linux-mm@archiver.kernel.org>; Sat,  4 Jul 2026 00:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E98A06B00B5; Fri,  3 Jul 2026 20:52:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E497C6B00B6; Fri,  3 Jul 2026 20:52:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D38AA6B00B7; Fri,  3 Jul 2026 20:52:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 995A36B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 20:52:10 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BEB3A037D
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:52:10 +0000 (UTC)
X-FDA: 84949267620.09.8BBCAB1
Received: from mail-yx1-f49.google.com (mail-yx1-f49.google.com [74.125.224.49])
	by imf31.hostedemail.com (Postfix) with ESMTP id 54F8520009
	for <linux-mm@kvack.org>; Sat,  4 Jul 2026 00:52:08 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U3160mzR;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783126328;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t+/wZjP3VRbBrZYdXJhzA9JgmkyKgho4uGcN4xy9Q+s=;
	b=osNDl55IEZf44KqbeUcyMWxWkZGvKg+8W/xpqn/RM5o6P76eaJ/ItflcnRmKTZPskWvqj7
	sWpsaVfv60+8NRznb52/u/qJvJXVWowUVjfrk4h8qWbooxxB+0PbJa8R+7TWtYGZt718vQ
	ptoJFvoPPxBWnpr179uIWwd6WXuNw3o=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=U3160mzR;
	spf=pass (imf31.hostedemail.com: domain of pasha.tatashin@soleen.com designates 74.125.224.49 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783126328;
	b=ELuNdzQxmjG3GjptlLWaiyNE8Vtip9fdbBznRyRba9vpbRVrXfte1TioC9rZWc7dSLrZsa
	7+WzYfLaW/jqF9jaZjrwtqepfGguB8Q376jSUnpXrUAxQRyv11V0iVQNpjGHRpd5Z0YCLU
	mE3TRGZjZsO5acIJu5X1JKmvXjo1sFE=
Received: by mail-yx1-f49.google.com with SMTP id 956f58d0204a3-664ee752958so1531683d50.1
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 17:52:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1783126327; x=1783731127; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=t+/wZjP3VRbBrZYdXJhzA9JgmkyKgho4uGcN4xy9Q+s=;
        b=U3160mzR4F2yGKKOZ7PzW9S4LZLgfy4taAxs7drolk1KN4/VRAEtVLpOruXh5P1/IX
         NwGJjU05l4Xw6ePpqqjmBge7/3aXQCzDe5d82c45L/udUy7wka2PofljP5w4fmyPWfOC
         GiSoq3PK44wYRvUi7Br0veftwTuiKLQ31RgAgiTLo8RPiNrsecszGsm+SJQun0xHCenv
         Wlhcm/9sBQVOKazuvNdYriLuBXTOs9dPMcgaX+WiAS+SQCNYVXEV516ZLcVjD+I6Q0BE
         YRqOFZUZose34CTK9cqLvdZaTNqgPavLHV+d8Dz6R5eFbxAxrnSlEJWwBwKR5a3A+ayV
         oFxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783126327; x=1783731127;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t+/wZjP3VRbBrZYdXJhzA9JgmkyKgho4uGcN4xy9Q+s=;
        b=f/MJJ3iuCCLsLI9jhZ+hWSzZAHsQZbpcCP6b6W0steTbqQGZyUtiB2oATLzQrfPKpr
         ZTw4r5aqKlwb/cZSERJ0rTuU7UNi4zwHUNxUT+/4gW5aOmC40vIB6OSheZUg5YmqKWM8
         mGxlMSUn6cfRTZbgHl+AQrMFqsoV9+mGiFkAM8QlFbszr/CdN//KUfAMrKAiks9dwOlv
         m8tCmSwI7Nn3LGU91HPd3BuNxkP08S0UwB1P6i+hQD4ihBuSivAlx8Bwfd1rS2dSz6hH
         osgsD5rJvi/+bsjgltrMESHkV7BjtkeW9OJAzZ0kLEiSLV2NNLCJyU0I2KX7oa48uFEC
         ScHA==
X-Gm-Message-State: AOJu0YxHQCf0kPkqoHRRtV3awqzn+xXRYORpNUjGwc5+XAAYpr5di8k9
	qlMZ6PBHj5K0NiEgys8Lv7C0ay75x8bp0nXD1k2IDkAJ1N8NhtEivBgCap+QXgb6Bdk=
X-Gm-Gg: AfdE7cl+Y34jz7rX1oqSFA7cm64KlK6DtjVti6ttDJCxAsOzS0A0wa8tJjUmaMpoFyi
	qR9FFwliNTDfsY6mKV+ZFCTOqahKJWBkzSfVNhJTqw9y8WyrN4WA9n4s7uCyiB9u2OvwFdUd1Yi
	WuNHjh4r3nETG83DXBGDk3XwKdEKYbIsE9zVrG5RJMIJ4rRCW282Z4Xuq+y1F6FKNa3SPdd84cv
	cwCbbwYssEcpX0Y46vcxg1lwPY455YfN60Oy2RFfxpdjZMMWn/sB2R9XBObOdENIz1YlO3oxi+T
	JtwSw+GO0SVF9ikIk97tuKgYQKLn3XdpStb7jfdeYJQA0nA9FFI9oTSKueyg/fhXRMwhpg2gpJR
	PgHMp2G8srAnq6GiQWFJkRd+g1IrXX0o7y+piaoXJqmv+n8Lwn/diDpe+x+xL1TC8smhVcqQKNJ
	JrYYqISQqJAaEtk6RgdnACTlajuyZlCDXJl2PpGPFxxAg4of6zV0YWNK3FpRGdPk0cXemPdUdtA
	QOuPkCWEFtfk/mI5L5TZOg=
X-Received: by 2002:a05:690e:4506:10b0:665:1e31:9164 with SMTP id 956f58d0204a3-66652eb898dmr968746d50.47.1783126327338;
        Fri, 03 Jul 2026 17:52:07 -0700 (PDT)
Received: from google.com (212.255.145.34.bc.googleusercontent.com. [34.145.255.212])
        by smtp.gmail.com with ESMTPSA id 956f58d0204a3-6664083f9f6sm1511013d50.16.2026.07.03.17.52.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 03 Jul 2026 17:52:06 -0700 (PDT)
Date: Fri, 3 Jul 2026 20:52:05 -0400
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Alexander Graf <graf@amazon.com>, "Andersen, Tycho" <Tycho.Andersen@amd.com>, 
	Anthony Yznaga <anthony.yznaga@oracle.com>, Baolu Lu <baolu.lu@linux.intel.com>, 
	David Hildenbrand <david@kernel.org>, David Matlack <dmatlack@google.com>, 
	"Heyne, Maximillian" <mheyne@amazon.de>, James Gowans <jgowans@amazon.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Mike Rapoport <rppt@kernel.org>, 
	Pankaj Gupta <pankaj.gupta.linux@gmail.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Praveen Kumar <kpraveen.lkml@gmail.com>, Vipin Sharma <vipinsh@google.com>, 
	Vishal Annapurve <vannapurve@google.com>, "Woodhouse, David" <dwmw@amazon.co.uk>, 
	Luca Boccassi <luca.boccassi@gmail.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Jork Loeser <jloeser@linux.microsoft.com>, Chenghao Duan <duanchenghao@kylinos.cn>, 
	Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: linux-mm@kvack.org, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org
Subject: Re: [Hypervisor Live Update] Notes from June 15 and June 29, 2026
Message-ID: <akhY7Njh6LqzyWyz@google.com>
References: <20260704004316.1109918-1-pasha.tatashin@soleen.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260704004316.1109918-1-pasha.tatashin@soleen.com>
X-Stat-Signature: o3jme5xn5mk6qikeqq6p5cskoyamx65c
X-Rspamd-Queue-Id: 54F8520009
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1783126328-336300
X-HE-Meta: U2FsdGVkX18FkuCvcuNNndB6hZ3nOwmqQEy4qvTTW5QW5S3lWpwNYYhs1HUCo8y2cNQ7Io9uoRcPQY9NiP802gvBY+t8XDgxcf1LO6rXB6QbyVXbgYbWg/tGTf0OnkZwMOeKDzVZYqH4rZAAf2vYfn8zD35LBjpN5FzoTniILWTZHY9jVr7P95wEY/lNTLd5tensGgZEeAu9aaN9JXyQXRcxFY37wV2eCtpzGKZYyAzzVOdTVVrL6soEHVGCHnJ3KLO4vyO0UJYoA6BTryPdS5jP44UHEva2Xane0wwzpLanaoSE0+2kOXYI40xZb0bHknppITrnq6PjTAfJXxv7seGfbJZ81qfkB7dXmyZd8Vu9icSsenvegtTYFQY2yYjNPypv7VlNgowukZcqNFpARtB8sxhECRHAm2qHYpWFRCcn/+tdptz6fwkPcRbGz40KVBy/BmSFbhn1oVUJV0I1V5lDHB+FdMyfX8BF1m8kVKUVwJ8mcbf6mtJtKKdabEOet1hDHcLZFnUpc24Z5aiZg4zpgqKZVJylh1rBglsNFvyQZhqGA7PbIphWixAhtVWTyzH9BFij+bHQKFUeuYULg4aSsncUqxEsB7IzsDWscTZPSOKEBPBMHoehlKagnDHse407uk0UJ0RFOvVTbH8wFmW0B4TJGlqDabAHYbnpcdSSHTF+o+Dp+/3goT73SEGnyfq4BWPez4hpkd5fucp6wjcilXDLlKrmTQuvGMs8i9tQlK79yt7X3b+9v2AAJ7DPoL3ff9NuMYqe8F382GQFS9SsyXWyWlDgCyBwL1/vJuH2pe1fsGZxeN/6ytacWP1lA1Ji6pthcaH/UDdfGDxi3JRByjADBgmtNd7zQzNAD6RPyGOBokuZ3fdjqcAGc+tDC1UDc3xvlzf3b54RtTT0ja2LauOlLneFagWp4qxkSVTgjvMPrkyEk7yJplpH+WfG1M1BoM5R0lf5eU7fxgc
 pGXp3Vrh
 7mHdW8gFDMQRzYXWE9LxwPuhfqSQ9L6Tdjxr+AZ3MBj4+yAIHS9wIflzbi+uX/kQk4gUpOASWG9Fw4S5e1PDJjJiDfKB0A3ZtSdoEl1EmIFDzkHR/VoxCeGx+/KK42ceu8YePBO4d+hqKZH5Fm3SuIokVPv0GUTayG+LWOPpCqfDzXiNvOqdWcLPX/DgnLQFOaLP3alvYNNwPPjxzk0VnSnN9WnGd+qLCWqGdQy42ssVD/Z7gqBM8Y7mIUfbss34EdPqWdNFcXSdmIl+nu2+LjmYPJc2IyRPl9E9dRuyH2xwLOAc4Q5YDRt46bwFNyFv7oqNf/V/5QTzTZ5NMr6Kz79ZU3LjDIVIeX8H8XLcg69JBOnQLtBKM3/CG69EkVqAPRz3CSM4QBPrpAiqGgAnpSGKlyxihbeJfGmU5WJbYDlKBq5kBxxMegZ2kpQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adding missing CCs to the mailing lists.

On 07-03 20:43, Pasha Tatashin wrote:
> Hi everybody,
> 
> Here are the combined notes from our last two Hypervisor Live Update
> calls, held on June 15 and June 29. These notes are intended to bring
> those who could not attend up to speed and to keep the momentum going
> between meetings.
> 
> ----->o-----
> LPC 2026 Call for Proposals
> 
> The Call for Proposals for the Live Update Microconference at LPC 2026
> in Prague is open. Please make sure to submit your topics and abstracts
> before the upcoming deadline on July 24th.
> 
> https://lore.kernel.org/all/ahcc3Qyuy7Oy03Iq@plex
> 
> ----->o-----
> VFIO & PCIe Persistence Roadmap
> 
> * Roadmap Recap (June 15): Vipin Sharma outlined the five-milestone
>   roadmap for preserving PCIe endpoint functions (and upstream bridges)
>   across live updates without disrupting registers or ongoing DMA.
> 
> * Status Update (June 29): Vipin has addressed feedback on the v4
>   submission. Revision v5 is currently undergoing internal validation
>   and is on track for the mailing list before our next sync.
> 
> PCIe Core Updates
> 
> * v6/v7 Evolution: David Matlack is preparing the v7 PCI series. The
>   group aligned on deploying an FLB reference-counting model to maintain
>   symmetry for incoming/outgoing sessions across kexec.
> 
> * Pratyush Yadav suggested that drivers should explicitly isolate
>   structural "probe" routines from "retrieve" logic and separate
>   "shutdown" from "finish" callbacks. David is evaluating the
>   feasibility of deferring probes until the retrieve phase to improve
>   driver cleanliness.
> 
> * David is refactoring the PCI series to utilize KHO blocks.
> 
> IOMMU & Dependency Management
> 
> * v3 Status: Samiullah has posted v3 of the IOMMU persistence series,
>   addressing hot-plug handling and context entry preservation.
> 
> * Dependency Policy: The group agreed that the Live Update framework
>   will not enforce a hardcoded preservation sequence. Instead,
>   individual subsystem file handlers will verify dependency states
>   locally during their freeze/finish callbacks.
> 
> LUO, KHO
> 
> * Terminology Updates: "Scratch" memory is now designated as
>   "unpreserved memory" (memblock perspective). KHO "Scratch" is renamed
>   to "KHO boot memory".
> 
> * LUO Limits: Limits on the number of sessions and preserved files have
>   been removed and landed in upstream Linux.
> 
> Guest Memory (guest_memfd)
> 
> * Naming Conventions: Regarding the KVM file binding debate, the team is
>   moving away from the debugfs-based incremented value approach (due to
>   production compilation concerns). We are exploring using unique names
>   derived from user-space file-handler compatibility strings. Tarun will
>   escalate this to the KVM maintainers.
> 
> ----->o-----
> Action Items & Next Steps
> 
> Pasha: Consult with Mike regarding KHO component splitting without
> versioning support.
> 
> David M: Send next version of the FLB ref-count patch; refactor PCI
> series to use KHO blocks; share recording link from June 29.
> 
> Pratyush: Implement rename of KHO scratch/boot mem.
> 
> Vipin: Submit VFIO v5.
> 
> Group: Review Guest Memory Preservation V3 series (Pasha/David).
> 
> ----->o-----
> 
> Next meeting will be on Monday, July 13 at 8am PDT (UTC-7), everybody is
> welcome!
> 
> Join Here: https://meet.google.com/rjn-dmzu-hgq
> 
> Please let me know if you'd like to propose additional topics for
> discussion, thank you!
> 
> Best regards,
> Pasha

