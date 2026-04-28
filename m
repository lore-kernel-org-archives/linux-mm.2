Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51612FF885A
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 17:50:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 917C86B0005; Tue, 28 Apr 2026 13:50:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C90D6B008A; Tue, 28 Apr 2026 13:50:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7B7976B008C; Tue, 28 Apr 2026 13:50:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A38A6B0005
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 13:50:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 11D5D16023D
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:50:41 +0000 (UTC)
X-FDA: 84708704682.15.9AEA0C6
Received: from mail-qv1-f43.google.com (mail-qv1-f43.google.com [209.85.219.43])
	by imf21.hostedemail.com (Postfix) with ESMTP id 2C0E41C0017
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 17:50:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QY78KlJc;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777398639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nLQfCSN8EWjiFZX7iYk3vg7MUEyfn/VCYlErQ2TNxjE=;
	b=kKBpCJDIiu8z9BOtlcBvArRGU0QCHEWRa7miod/Ll82lGbwlei7rsCmXTkwCDMrjiyu3r5
	1QipvgIKI3m3kUcOgpjmSnMBbJqPBgsZsmMYJF4fOV8BegCWyd3iR4KchSAwhjNwI7BIJn
	AEiA3rsr7ygstZd02m+NhLQ5/IKRU+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777398639; a=rsa-sha256;
	cv=none;
	b=2KCGzg3Puj6C9ZRXaV0FZ7uhjs3+kQRVT5q5Z4aARiTxlI+sfx6Bd5t+0GYxbHQ/Ab3CB5
	9/yL2HBZU7sYPLpWGoFFG1divNGSW3CexNVBv1qu3hzfWfOwtLSyrzbLcNUFPLIajyOnmL
	hjTSJVAYvZcXqDgyM9Dr1uUzGauZdUA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=QY78KlJc;
	spf=pass (imf21.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.219.43 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com;
	dmarc=pass (policy=reject) header.from=soleen.com
Received: by mail-qv1-f43.google.com with SMTP id 6a1803df08f44-8a3b0242631so147275876d6.3
        for <linux-mm@kvack.org>; Tue, 28 Apr 2026 10:50:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1777398638; x=1778003438; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nLQfCSN8EWjiFZX7iYk3vg7MUEyfn/VCYlErQ2TNxjE=;
        b=QY78KlJc+VLGOMRgR1p8iuCOGB4tMIICqxcN0H6ejni6I483IJCLZ9PbH3bnGJ8JZr
         06Vbv6K22s9NwTPSXRPnt/naFZbmYWIpWGeCpiv/fPDaH1O+zMD4x064y2qRUpUq3JZJ
         zM+Aizg/fhjFjR6xvlktizEWXBAIy50h/wsgZRYGMhXb0TCphod4Sk4dnnGPJJ5Cn7a6
         /upQhiY8yA4B7M7fw9cffNhRpU7WPs77jfJQwyiFVrbuiY45Q9wqgghNBS7e6q9GnvC5
         JZKZN5K1VVk1tKILpGXcizBliXtEr5kMTY8HCgemir4fFEe66X6pWX6k+CnJTU7ivXLy
         Rkmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777398638; x=1778003438;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nLQfCSN8EWjiFZX7iYk3vg7MUEyfn/VCYlErQ2TNxjE=;
        b=hls8134jh23LdhvQpAs7ULua7rB8cKyEzldugtZd2ls5BRFunT7IyfSDb5Xz2K0usn
         40x4Lka0isR9qMhMRjGy/2x7d9unzfTsHW/99hMG6lPhzuBgFYcvv65WM3qEP/nJOSDw
         JiuZ2fAhejCDNTkfWaz7ng0FVq+pJFIrusCxztYkJkmPBWcLwdNRP6s98sXFYUbLBiCO
         6PSIrzhC142GhMaQtvQicSkw6yItfLnUg5FE9W+1+lIpNbpFFXFiXPBEOORA0AflAghl
         hoTnx6GQaGBxEzx2g4J7Ib2smPBr9U3d+efdEUb8mg4nhBGVTsT0jTc3etqi3NmVUkeL
         CU6g==
X-Forwarded-Encrypted: i=1; AFNElJ/FbaHVDPhXRs2Qr/cr8IO8GH9+geHaxJuTky7CjHawW2cJEdj1SNmgLEttw8W1S8oN0jIYgdhsbA==@kvack.org
X-Gm-Message-State: AOJu0YxxtDhWV0ud3INgFK7ZwnfXUdPuI24v5yFN0a1ikcrmIIbtCqLD
	OEioxe7+GTQ8gsON6KI/zfqaR+SFPVBqHbSABnZcXZHOJHXWY2TYFQdybIHk5YbBlnw=
X-Gm-Gg: AeBDietKmGl6DQCe3k4/ADcIcJrMxDzA13/6mBnNJVkdA0jTmF5SdsoePDb5doFMZmH
	2qFbYDSEouiUxTbD0KEJKZ/6V4sX3itb65/4TJkLch32tX9I1jK4MM96Ub9JwF84UsCywGpzqrG
	KbvLZXVQnY8bHixWUNkoG/SOaCfdDZtEHdkaCM5CmczHiCtINOakPpADrsVkx93F19sWH3011/o
	Xq2tbRNpOMCu4weYTG42XsE4DslF2uoU2CTxUB5JdpKA01QyTJZYAIsRbdxQmWyQrg6fQZ780Qr
	oYypSJkXnTDMrxRrGoqGD/15vF6t/c1gA1dfDEn/bxskonNc89CEqym67e5lrEIHyslSCHphit3
	wh6PoEkzzwdiOzYfiNSu9eR7Fm69tKMWVOobIQq6GlK4Oli1Z0y5/nFC4H77nDgGN/JerMZn/1q
	D2H3ZMI3e+zv0t7atuNJMJ1OjU0EsXIFVxAEkPSatxYFOmZdHYP59UOx4N7dwlHw==
X-Received: by 2002:a0c:f40e:0:b0:8ac:b14d:fbe5 with SMTP id 6a1803df08f44-8b3e306950emr64326106d6.13.1777398637724;
        Tue, 28 Apr 2026 10:50:37 -0700 (PDT)
Received: from plex ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-8b3e281bd11sm26479316d6.8.2026.04.28.10.50.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Apr 2026 10:50:37 -0700 (PDT)
Date: Tue, 28 Apr 2026 17:50:35 +0000
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, iommu@lists.linux.dev, kexec@lists.infradead.org, 
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
	Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, 
	Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>, 
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <afDroRNDr9ttY4O9@plex>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-2-dmatlack@google.com>
 <2vxzeck45yin.fsf@kernel.org>
 <aetvAkM0y45WAmfV@plex>
 <ae_4fg_18Rli2_Nt@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae_4fg_18Rli2_Nt@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 2C0E41C0017
X-Stat-Signature: 1ino6z6js5e8e8dsc5g1srwtf91cxdfo
X-Rspam-User: 
X-HE-Tag: 1777398638-552090
X-HE-Meta: U2FsdGVkX1+NyTIbcSZR/T3hUMWyklNkfjCqCHB8UMMjiKB/L2qHDAT9/uk+or5LEK20/e7H4y2nIi3d1iXnrQ1MH5+CH1jZ5GUvjSJZdUGqMkHGfWwI7Gi7dFV4v63r1BBk2hzG8MMl8evyGFzuQlgc3Qd4bQwKWo/td5DY6NIoiVaBZto6LUGmmE8ikV5TlA3+kzUctclDpNsL87kmCNOR/xVU3lWFJtN1BzqHuftVlkhlOXiwH954HwM5mXOfHOgSLzWZ0g7V6b5HOnPCmmpZg2YAn3WDxZZyWweV93zCMMYYqGY03P/ByObf5piG+Rk+hRvTqqDy0p4efMiJ4XvmRulIAc6UHO4Hxyd4qgqFBXlKbPeetvnn8A1Isw8AImZhgbSgsX3Qx92dcr381wHnLtIuU9nCBpuAWL3lEi9BvES9KHL2yAfF/TtafcZmOBoRHyEpdhVaj7FsyA6xe7SwSDB7FE9hAOKLRAsRvM8pzpvXLaxhTCYIFzQTPOCVDQUU0cQ3+0u6QBVP4ZGfTSrT70GcyXzbUHkKu37u0o96icuxWZ+eKpw8tF3LMoHI4vb93yUDKciDb2B3F3gxntJWz5hhPwLLAf1jIhZL2vvjJJXEun8kyKdjrnYkPrd0gO4pge0vNHv1OFRZcUJpm0SBC7BCnni7fVw0T9NS5L7ZRR+LJEzMK3jxZjmxX6zatS8m41E0IY9tTuuZDnXxDaHT1ZGOYQ0NMt4ncFuMNeeynIkxkhWp52jmvWUKQ006WRh2EisWZgyuEzVaIVacw57F/EmCvUItkbWKBwTXDqlpK3QOw9WpUljTtBjFG2xW3qjXdz1ZZJzrcyUMbHMwXu3UK+7xaPlt9bZ8tcnxY2+esvjKD1Y3eYRus8O0pHX8GnJNBA7khfrxHSk0d43xY3LZLjsZWe+ltb0vXxm99lCdB+rWBm7kQR93PnTTlsUJxWJXjx4aWjo2aJUHjlT
 4syPojAA
 6ejyoicT/K5HkSkury65fKQRKmyx6FeTr3cm77ogNKLZTE5fYuPYYNyb/7DhbkCihf4na5RoXrZiMEdREagqPQx/KxhdGwwQnRUa0/LLJ+KDbiflT+W+X3KUrBthqJvsL+YbxTkETVCPwIZl15yENRihjDdbci3TO4A2aPcY1Ulrawx/jHdmtpYH6DhM6li3zGAszMb/LsmDq2br4EAXpliax6wmKSeh0BfigB8TM+6qUoYPqn93s+VFKjLXgoTK0mEpVUqDpwdoctQkkOfeIBcKjmROlJJyJORbBX45VEmaPiCdCv0K2pMime3nZq0Y77mqYghTA2L7x5aoFJD91lCBqi+ekYTDx3jAp6Jl61AOcP6k17tI9RelTaffQTkPHcD2gGS+8lfNnHlV94wVX5XdyL5tGIV/r3pRJh7Mh5bLcK9XAII7EVfAKdbZ1cdNPQrbOZFxs4CRaAtpmlpM0+pzePaALuZuscP4O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 04-27 23:59, David Matlack wrote:
> On 2026-04-24 01:29 PM, Pasha Tatashin wrote:
> > On 04-24 14:33, Pratyush Yadav wrote:
> > > Hi David,
> > > 
> > > On Thu, Apr 23 2026, David Matlack wrote:
> > > [...]
> > > > diff --git a/MAINTAINERS b/MAINTAINERS
> > > > index c9b7b6f9828e..94af31837375 100644
> > > > --- a/MAINTAINERS
> > > > +++ b/MAINTAINERS
> > > > @@ -20555,6 +20555,18 @@ L:	linux-pci@vger.kernel.org
> > > >  S:	Supported
> > > >  F:	Documentation/PCI/pci-error-recovery.rst
> > > >  
> > > > +PCI LIVE UPDATE
> > > > +M:	Bjorn Helgaas <bhelgaas@google.com>
> > > > +M:	David Matlack <dmatlack@google.com>
> > > > +L:	linux-pci@vger.kernel.org
> > > > +S:	Supported
> > > > +Q:	https://patchwork.kernel.org/project/linux-pci/list/
> > > > +B:	https://bugzilla.kernel.org
> > > > +C:	irc://irc.oftc.net/linux-pci
> > > > +T:	git git://git.kernel.org/pub/scm/linux/kernel/git/pci/pci.git
> > > > +F:	drivers/pci/liveupdate.c
> > > > +F:	include/linux/kho/abi/pci.h
> > > > +
> > > 
> > > Can we please also add these files under the "LIVE UPDATE" entry. The
> > > code here concerns both live update and PCI.
> 
> Covering that intersection of Live Update and PCI was exactly my
> intention with introducing this new PCI LIVE UPDATE entry. This ensures
> we have maintenance coverage with knowledge of that intersection.
> 
> > > We can figure out the
> > > maintenance details as we go along, but I think the live update
> > > maintainers should at least get all the patches for PCI live update.
> 
> Would adding kexec@ here be sufficient or do you want to be CC'd
> directly?
> 
> If you want to be CC'd directly do you think makes more sense to add the
> Live Update maintainers as Reviewers under PCI LIVE UPDATE, or add
> drivers/pci/liveupdate.c under LIVE UPDATE?
> 
> > > 
> > > Perhaps also add the kexec list here? We plan to use it to maintain the
> > > LUO patches, and adding it will make sure we get the patches in case
> > > someone updates the file list here but forgets to update it in the LIVE
> > > UPDATE entry.
> > 
> > +1
> > 
> > These files should also be added to the Live Update entry, and the kexec
> > mailing list should be included.
> > 
> > Changes specific to Live Update should be routed through the
> > liveupdate/linux.git tree, while generic PCI changes should go through
> > pci/pci.git. In either case, if liveupdate.c or abi/pci.h are modified,
> > acks are required from the Live Update group.
> 
> Do you want to merge changes to drivers/pci/liveupdate.c through the
> live update tree or PCI tree? We should probably decide now. I was
> assuming the PCI tree since its part of PCI core.
> 
> As we project this out there are going to be users of the Live Update
> API across different parts of the kernel: PCI core, IOMMU core, IOMMU
> drivers, VFIO core, VFIO PCI drivers, and KVM. I don't think it will
> scale to take all that code through the live update tree.

All Live-Update-specific changes should go through the liveupdate tree. 
The liveupdate tree is the only Linux tree that will cover full Live 
Update regression testing, and it contains reviewers and maintainers who 
know the details of the Live Update process, its lifecycle, and its 
requirements.

The request we are hearing from other subsystem maintainers is that they 
want to make sure Live Update is isolated enough not to make their lives 
harder. This means reducing the number of conflicts, the maintenance 
burden, and testing responsibilities.

Therefore, the "PCI LIVE UPDATE" entry should specify you as a 
maintainer, "kexec@lists.infradead.org" as the list to which all LU 
changes should be CC'd, and "liveupdate/linux.git" as the git tree 
against which changes should be applied.

It should also include "linux-pci@vger.kernel.org" so the PCI 
maintainers are CC'd. In case there are larger changes that touch core 
PCI and liveupdate.c/abi, we can ACK them, ensuring we are aware of 
incoming conflicts during the current or next merge cycle.

It should also specify the members of LU group so we can stage the 
changes.

This is the way we agreed to handle kexec changes: Baoquan He is the 
maintainer, and without his Reviewed-by tag, we won't take changes to 
kexec. This is the approach we follow with MM for KHO changes to 
memblock and memfd preservation, as well as the upcoming 
hugetlb/guestmemfd preservation. 

This is also the approach we should continue using when adding LUO 
support to other components like PCI, VFIO, IOMMU, and KVM. It keeps 
life easier for the core component maintainers and ensures we do not 
regress LU by staging everything in the same tree and sending LU merge 
requests from a single tree.

Pasha

