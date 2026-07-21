Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1E830C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 20:27:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B05AB6B008A; Tue, 21 Jul 2026 16:26:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB6A46B008C; Tue, 21 Jul 2026 16:26:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 981736B0092; Tue, 21 Jul 2026 16:26:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 62FC86B008A
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 16:26:58 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D5EC7402C1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:26:57 +0000 (UTC)
X-FDA: 85013917674.21.BA495E5
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id F024E180004
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:26:55 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F7bDoCAB;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784665616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bht7YFPW2nLJyME+XdIc/6Xfh+QtNInRSN0Il3SMOm4=;
	b=j4LsDH0PvHftnc6Ls3TavYhfjaFqi2MnzAk/x7t3dYHFoVf+BgnInysZ37Ys4uihJLUVy7
	9jDLn1mKHYD6xIVGUyPIDiyJ+Ru7Pewy2VgIagJ6hiWHWp1HlqTChcM87BlOM4sW81py3C
	2Q4Wbt5bMXaITV+HfqChlD1TMgK6vWI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784665616;
	b=sdP94fYeLlRNCWhZfIUqAfWLF4gKUV3OchnILNlnMUdjYGwCrC0YCAN+goGeFu6piw7nAT
	8dCNtdtKYAPiLTLh/EyPIB6MYPZpOnr9ND8mqDXpjK2De4+/xmVAhtWRjVnGb/bNazKL7g
	/J2AZVmjmaKvb7FJXr+vLB3dfeKneDU=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=F7bDoCAB;
	spf=pass (imf16.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2cc73e322dbso140779685ad.1
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 13:26:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784665615; x=1785270415; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=bht7YFPW2nLJyME+XdIc/6Xfh+QtNInRSN0Il3SMOm4=;
        b=F7bDoCAB+YlU6q1VBTOknn5G9Pvg5gxKRm5+8v281qXNVAIOisPUAooQlaOVwoD7kF
         PBMLY3qEqvk3Bps8AIlPtSR8Auuf5ENcwi174cdjhQOYqpdP8lRNSr/kGT/ZwnTj7TEY
         Wlaxxx2siWOtqVN8i2oDaL+p/w0XF53X6/U9VKbYTdCf7o21joVxCSysusGOwObGZdKG
         Hii5yngJ9WWdRBhHmGM+aPtOUBRR4+O7sKRqpTJviJ4KAxn5Mb1+lMHnC9CuCM4gugeN
         oK+yxsf/sFsODqmJczaYU2WFX29M+DqR2rnJ2a7uXidepDCUzeKbfVjz8+9z5BaVFy/r
         omiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784665615; x=1785270415;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=bht7YFPW2nLJyME+XdIc/6Xfh+QtNInRSN0Il3SMOm4=;
        b=oDILg2BKIqOSJTOa+8kmvXqe0sydswIjk9JqcbzenjCR9ASYc1v2upVwxChl8Qd/Sk
         lDfxqN3xmK2oDXT7cgTIShV5fBHd7jahk8MISXmAoN2s/lirQTLUTBJzzbOIjiZo9Qbk
         VychI+1ocJzmiFDYpdymj+fmUcU7iHLNN1c2WCkLNt6FIkMXn6iFIxQ34c2JIdJX9iRQ
         tjuiC2MWhiqxHMuOk3CokNGEpwvfZUgdjgkxxJbH3ibOZ65McKN4BVt4gftyTBhHj5Ap
         lCCgMRbaJnvQcPpIZTZg0YBf94Il3Xdiq9HyRSIcA+B97I8jJ9vqESXM8Xp6bINThKty
         1Z3Q==
X-Forwarded-Encrypted: i=1; AHgh+Rpn+dhEvL+CtPTIyKwUU76FmgETaKsk93XHvtoheVmA7HUYHGBtpY38LtPfAf1ahkgkbn7qL9CzIQ==@kvack.org
X-Gm-Message-State: AOJu0YzXhQmKiM5mmArDmxBK4xTi1xsp0APJa4qfyPUS7E7iv5gXqtvQ
	Jd5Mg8Ewqpmu6Aqaxrz2qhl72zaXRy902jly1NjSky30VSRWTp3i1OBVu4Nb2gf08LDGC/NcBAe
	NDnS/axwN
X-Gm-Gg: AR+sD11S9hU1ALLXaB2PpMyEwDsojoa2J4xNwLlGmEByFTPQ6SRGFk4dlFiLdegS3Oz
	BIw+lpqeS4e1CCltMhv8o9iqUHYUZ+dPXe8/+uTc8E4J4jcTYN9SeMQ0WqR7c1B9i0H3zVfViJr
	FmxwjnFbWfheAHXnCQml0rPxoSDkQTH5CwI0304p4I/h4Hm3NrnvMb47ylnWyPIrvyuN7Mvne2x
	Gy9miH2IOjjzDi6kKnHPicG3Blb4liSfQXOiqPuKdtSC3TtVql4O/B8PcVXdO8U+iqR3GEMq2Si
	RvyHIruum1hpHBJnRUW7Pd73Tul0geHzWlsgMbxshS2ziUKJH8NT9SPadWxKSiSIBtLEjZ8gJ9W
	gSj1TdqMgIu7hTTDiEY8ifFO1pBTw/EFnWMRqcacxe9ixKzhHeC913s9B9pFO/8I7jzTzAgQYVL
	hx6vk4Feug9xeVNOwz9LQ7YSy/z3y5I++at77Ulh4J
X-Received: by 2002:a17:903:4b43:b0:2c0:a555:80d6 with SMTP id d9443c01a7336-2cf3481d1b6mr200020005ad.2.1784665614286;
        Tue, 21 Jul 2026 13:26:54 -0700 (PDT)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8efde5cfsm2738235ad.31.2026.07.21.13.26.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jul 2026 13:26:53 -0700 (PDT)
Date: Tue, 21 Jul 2026 20:26:50 +0000
From: David Matlack <dmatlack@google.com>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v7 09/12] PCI: liveupdate: Inherit ARI Forwarding Enable
 on preserved bridges
Message-ID: <al_WCh-G-H1kDU1h@google.com>
References: <20260710212616.1351130-1-dmatlack@google.com>
 <20260710212616.1351130-10-dmatlack@google.com>
 <178433098576.189683.2364970585754668266.b4-review@b4>
 <CALzav=eZYfYYKAGEzk4TsGFLp1TPb2iFePNmqGsjX4jEZNJ9XA@mail.gmail.com>
 <178465783370.437204.17382376546970842455.b4-reply@b4>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <178465783370.437204.17382376546970842455.b4-reply@b4>
X-Stat-Signature: 4psydm4px8bpd3w9qq313zt6awwsq6bi
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: F024E180004
X-HE-Tag: 1784665615-1715
X-HE-Meta: U2FsdGVkX18hxiKmh4SFTZxh4UvGgfMy+XnpmK80ZXfgW0a0qml63G5Mn3Z9J/xbmW9stGKV2Y4zkp8lMF4mHzcq0TR/FhAW6415HLfgLWv2o2JpSazLAgrTyYcrjxOsyGxBSlriN72S/H0EljvlVQPcfXApTmejudpZcBVTMSZMWhaOjBA4ESDbqcJQSojyu+5rJWzD2HdaTnbma3S86THGoZyJczPs4mQ2fivEaqg97NvhIx6atMWUnkNN4LHdGibA6745NtCB2aM2ubVF22r6cdxqw0m614EAmWrZCR1zBqUUt2xnJtBwMG6XR/vHEH3959jRNW5q4lmNFt8NoOYWInswqgiNQFQJLz52CRuMiNpDo3OWUyTfTwtSWGx2Rib15PhZB08cBGJGn+OVBUEeh2talkcIFj7BqSod7wNBFvl+i7thirwwJIDBoMLeQGfPaoRKZ7AA532m98rOGo04+EbKgnY2d+yyh580kLrWOU9JKGvutGvaX5/1LHGKVhp5GVx02TAOXV4Kd0z5eCveFYR9Xkj/IJBYppB7wHCxRjnodRHaxRMCvaMbm8CTPjjRRcEeg7l5vf9ANltFBaVB3QJbsGmBb+BJvfEVmtXSa5okSNt/YkHOKkf/xadqJWdobnMSQ/5CfRSX9IQOJO3N7AHvpGfzZDeoQmJLwSRwOG+eVVBKHXCcReYzUz+/wQO/IMHikdiuo6GNw6Qgn22uRq3tNmnuJWs0B7TVO279gtjFsQwtgxFIFeMB5A6LeDCVGaZsrTpT8Cr/sjCbDoz2vdDAp4PZROtUFeoNA2xx3p0EfCRuHEG5GCxaKZoi3908YwX6UqWDhSCS1hPMc7At78FahsYkRQCyXeFdRKP6q7m7dNT1UNbesX8G0LXJUYeaU15GXrajTiolPc07qV8pt6k8eGi3kEBc2Li9sxvpUU++XwBtl/203PfKvZ2DQq6bzO7/G8cFQqpiw7o
 bLP2e3Kg
 t9mnoeKC1w5RmFkiaiuhBVxZ8w0ORinGA/tIB4cm6H3pL7xaWRL2koghEwy1YzkAxvbYWYgNFBga4/nl0DQh/IjhiVRlVYDZsi7snsWv7GPXmBtUIM3EFdo+5noUZi9674o2s9eYCyM0R2qP/sCgciXa5obOrhV9ySoxQw9l5NcsSJjcf5VFMS6MGvCR1naW1q5yQje9Hy3DgUZj9MB267USdVmG1pRhdNrqW5dtyQzU/Fa/hMzWFAuzpWLFgd/C2AgAZv2XTCpsXWmDzVlDqZniZEwI4FbKRYIgIlfIRWTn7VVDNqEuKKYrlw8QEu8VST6Wm16If7m8VStOxUJO89sh0ZUBeWAQ18U2kMxzwuFW5kZaqibmK3xzRf5YwJaTu7JY15NTjuc2VjZ39X21ZnJh62NIMZwoOJaNWRJoLQO/7aJmTh/j9z8+5xQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-07-21 06:17 PM, Pasha Tatashin wrote:
> On 2026-07-20 16:19:00-07:00, David Matlack wrote:
> > On Fri, Jul 17, 2026 at 4:29 PM Pasha Tatashin
> > <pasha.tatashin@soleen.com> wrote:
> > 
> > > On Fri, 10 Jul 2026 21:26:12 +0000, David Matlack <dmatlack@google.com> wrote:
> > >
> > > unsigned int    ari_enabled:1;
> > >
> > > Sashiko asks a valid question, what protects other bits in this word
> > > during modication?  At a very list a comment is needed.
> > 
> > This was my reply to Sashiko, not sure if you saw it:
> > 
> > .  pci_liveupdate_configure_ari() is called from pci_configure_ari()
> > .  which also sets dev->ari_enabled=1 and is pre-existing code.
> > .
> > .  If writing to dev->ari_enabled in this path is indeed unsafe then that
> > .  is a pre-existing bug.
> > 
> > I figured that a comment wouldn't be needed for continuing an
> > established precedent (it's ok to write to ari_enabled during this
> > path).
> 
> Overall, I agree that if there is a bug it is pre-existing. But we 
> should also take opportunities to improve existing code and make it 
> safer. In my opinion, Sashiko raises a valid concern that is not 
> obvious, since there is no comment explaining the access of non-atomic 
> bitfields in the header before the struct pci_dev definition.
> 
> In this path, it is safe because we run inside pci_device_add(), where 
> dev is brand new and has not yet been added to the public devices list.
> 
> However, it would be great to:
> 
> 1. Review the access patterns to ensure there are no concurrent writers 
>    on any other paths.
> 2. Add a brief comment in this patch right before setting ari:
> /* Safe to write without locking; device is not yet publicly visible */

Ack, will do this one in v8.

> 
> or:
> 
> 3. Create a new separate patch that adds a comment before the struct 
> pci_dev definition explaining the bitfield access pattern, and how 
> concurrent writes are avoided.

