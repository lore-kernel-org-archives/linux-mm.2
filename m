Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0C281CD3423
	for <linux-mm@archiver.kernel.org>; Fri,  1 May 2026 16:57:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 030E56B0005; Fri,  1 May 2026 12:57:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F239A6B008A; Fri,  1 May 2026 12:57:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E121A6B008C; Fri,  1 May 2026 12:57:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CF6146B0005
	for <linux-mm@kvack.org>; Fri,  1 May 2026 12:57:56 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7CB0385E7A
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:57:56 +0000 (UTC)
X-FDA: 84719458152.17.585F507
Received: from mail-dl1-f46.google.com (mail-dl1-f46.google.com [74.125.82.46])
	by imf26.hostedemail.com (Postfix) with ESMTP id 78500140009
	for <linux-mm@kvack.org>; Fri,  1 May 2026 16:57:54 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Un0GSSEV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777654674;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=G34ikY2DD+u+VVE3dDOd4ruOH6p/Jku1HJ+Euceqccc=;
	b=0F/XFngEgF1q3B4Mzwa90PCQPY8Q67yfR4c29qLWPzzm3LXG3rcM8C3bis79Y/QSLUfB8t
	Ii7iGHGP/HlNXG2xKuR62xVmN4sDoH3uZCLylc5eAfF+1bI9ytJZv4C5zdWPzlqKC7NNGu
	arp8n1g88T7Iv2jBm8cCYTAAXxkrr0A=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777654674; a=rsa-sha256;
	cv=pass;
	b=CcsnBYV8+QGr4uNftoqVJkhPvfSLWtFI1gVKM+xeQXPYRVpM3Bapk7PfnYVd/WAO41uG+d
	y60Aj4EdqVZiRG9Zohngg5q3ylWjjjVGERBmUZdemOJ5jLM1Tbgiv58TV85PakaKlRDf2K
	Iw7DK29jUnMNe56FSVO3i8XLfNgHIEM=
ARC-Authentication-Results: i=2;
	imf26.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Un0GSSEV;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf26.hostedemail.com: domain of dmatlack@google.com designates 74.125.82.46 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-dl1-f46.google.com with SMTP id a92af1059eb24-12c726f46baso3325581c88.1
        for <linux-mm@kvack.org>; Fri, 01 May 2026 09:57:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777654673; cv=none;
        d=google.com; s=arc-20240605;
        b=MBP2UiakCSo0bzT96bJnx7yXFDFysFf3fHKL8XTnCOJyKsiKuEDmpLW2c7sJGZoAaz
         7Xi3MQWbtscj0KiLcvijWD7yBj7o5giQjUA08QvnTc9geLMhORMBKlGZ8xb8djA1dtZl
         N991MMN3sgvpErYNDhno3nzrtHZoM0z1/UaU7v5DosQ4tpRmQ6xh0/fXVRrXkrKaMS2+
         MH2FluDfmAFA1FKzaHDg7bqdr3UF+WQGUh4nQ411NwXjeaZG6qkhmzLF1GjKiNISOYYR
         yfcBR3I+WuenB/Adjrm/HBMFMAx9P7yZHu7J+lc+iaHwu1hNgu214FJf1H7ptenJ38ss
         ziNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=G34ikY2DD+u+VVE3dDOd4ruOH6p/Jku1HJ+Euceqccc=;
        fh=Syts1hHY06uSjvypKsgOfyLVptlM3SHavi4qNNyT5XM=;
        b=PxEz8k3yp0XfRgLzGev0Tsjf1IFS25OLqpHOM0KMLtXzB4wmvbeNrwFORsHmo7b5eO
         c3zx67i0JomLPa0S1JNlPIryI5+KEVTBTA0mE54FNwO7c4F3JiucYOEU6fwBr8sVJiq2
         DhR0KF1Hxqrgl3Q/e8+cuDjcQ5uLUM+tEq7F02523ijyaPmz24entA0GxHjgFqgNKIjL
         gTZrh2Nux7w848YlzCVcM6/+p3HOnMXEDEI7fV3UTnQlu+fPzCi666TraS7XMNcM3FvA
         k7nLqvbTUwTnVKkKkv9W0D+ANvywjvP00wvWk4uvq9xhn813dlcZy2s2Tu/uuJbrKroU
         nu8w==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777654673; x=1778259473; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=G34ikY2DD+u+VVE3dDOd4ruOH6p/Jku1HJ+Euceqccc=;
        b=Un0GSSEVUdYkUv2fJ/NYCnfaiFGQXNyiMuM6CMjIE7dVbWoxd6rNxhSicbxq4taCj7
         SLnzkoKPb8fZQOFLjKdAU1Owo7huGKlXZ0vgMUgi+gyRybDN3Ru07L8RIIRFVNnoC4dl
         stvTotEkxPx5LFldlcZ+Uo/UTB9emuZk1XPQaJNh08XlanOvutRfJ434whO053xnJABo
         m1in9L+LyAh2WNBPa3QoBOAza8oUBl/0yOX3ogO/evImzddjjX7Cy4SHkSCRfuTo0WpW
         UHv1MNvy3vzVegB4wPSZ2T28rBK5EH51ImGqyh3weQ60fFEkvUPbGN3HeKmFwIO0P6mH
         doLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777654673; x=1778259473;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=G34ikY2DD+u+VVE3dDOd4ruOH6p/Jku1HJ+Euceqccc=;
        b=deLSv4opDrbTFHM6JzqXTEUQ+HCCiyzFWx8AqGhzdM5LkP1L2AS9gfZFWvmDwlovWG
         AfZbAe0SUntEwubnrYfIN2epvwKQd4Zwh+WJXuDjZUMLkU/+5BBzyccc4t86H0ezrpCK
         HVGOPPOr8nif0JXjD9olc0sAMzG3ZQOb/wmjdu98z02L2fx+jaXFa+Ac54/ipALvYJxr
         ctmHSokNv09sHep75bRtnzy1KI3uYIL7VBo6SKfsuDOgcYwqHwPx+jVBQu1mre9ih52H
         3OiDWv6N85E+NlpwzSUUC65D8Tc33vXTE6GFWgHaBxfbujntkQXt3+J+XP3uyssey7J2
         /ezg==
X-Forwarded-Encrypted: i=1; AFNElJ/tWyjLUckd0vyta/SDQpsteRKUY+0yn4bewgcvmqoknWVUV8jvsTOl5Kkfnmzl4Ey2F8g021KkHg==@kvack.org
X-Gm-Message-State: AOJu0YzXJfPpRT5FoZJQHmsF2K5X5wzBA8Q0memrvzaKOzk2yvuz4nwm
	Ow6PZ/6XiZarTyxeY+sqpoCSijyyZNGc1QJ1JZ8khVewiSKpZzzn4v0VV6LNeBHfuded+yucgS6
	gSy1q3Ula2u+3d8pSylS+KTsF6/rehu7rjgzmxra/
X-Gm-Gg: AeBDieturTWA8h3pjfF/hZAHEGZqnuFXh8cq47Xqjztk3kAgrwBAcAo7Uvl67mGmAKh
	KlEU9XBGI5X1L2XQySHaI/wfBhvxy+gVHge06Jugf79mACy/4KABt33pCK+zTGIDk6/bXOV0OCe
	AlcFbqUggXbSYK68xEk+OL328GgqOX3+0DTwiQFw425ptdVt/cl94qsPsLPGPZLZRtnCaUgNrmU
	OSFdpC8xluWS0j1jx3GW2yOIm1yo4v1M6It/XBgn+FuJgBSq2QvLcDwNqsZbQBcfJZUeA7GE08V
	8x4RizjMQ/deJPCVeAOET3jknBMytQ==
X-Received: by 2002:a05:7022:6187:b0:12d:b2e9:b20f with SMTP id
 a92af1059eb24-12dfd821474mr32517c88.21.1777654672480; Fri, 01 May 2026
 09:57:52 -0700 (PDT)
MIME-Version: 1.0
References: <afFHC6C1Qbwio4pH@google.com> <20260430210642.GA439800@bhelgaas>
In-Reply-To: <20260430210642.GA439800@bhelgaas>
From: David Matlack <dmatlack@google.com>
Date: Fri, 1 May 2026 09:57:25 -0700
X-Gm-Features: AVHnY4KFLnH4p2pRBeiWD3uz1DZ5zLD14tslYZKT6G5Ma2DKmFI_8zfdZMWusuU
Message-ID: <CALzav=exRqf3XZWDwUx-OXp8TgzpmQ-iUTixpT4SVRk8nxctrQ@mail.gmail.com>
Subject: Re: [PATCH v4 01/11] PCI: liveupdate: Set up FLB handler for the PCI core
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	iommu@lists.linux.dev, kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>, 
	Josh Hilke <jrhilke@google.com>, Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
	Pranjal Shrivastava <praan@google.com>, Robin Murphy <robin.murphy@arm.com>, 
	Saeed Mahameed <saeedm@nvidia.com>, Samiullah Khawaja <skhawaja@google.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Will Deacon <will@kernel.org>, 
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 78500140009
X-Stat-Signature: axhcx64dza7794zis5axcyobtu6hsj15
X-Rspam-User: 
X-HE-Tag: 1777654674-833061
X-HE-Meta: U2FsdGVkX181oLLmEbV+HN+19Scg1NPeaR7JRNAlvcEtVTbj9WohkOAENMwlySTLj8Z559AYPghiWarf11cJ8vvrD3Gaz5bgUz5u8bQ/M+f548ouGPazQm/lXaKev6D4SSw6u3jDHhLV6q6KBv/phR62FDLQKkQHVss296vBacIBwPnF2FytI+PfI708T8+I9cuuOoIm/1WXCCYbiYyVhWEMZAqc7dlzf4pWsIgWil65EnEnc3iv4f+ho2fi0cxE5ePjHFc6s6yb/XZgwV12HUQxh7gw2ylPoKslqmPKKI9NIUL2Exj0CEi6RdUFyEcXBgiXjUGnUtZ7SNjHAlg2++TWQm8QpBHaY30AfZdfws8RcMSaJh/W8DFZaPIBS7EbHMdwHjdVsjzZmbJSSG/iWJHPZwAn7cQFCURw9VUiDlQYJ14zcQpL9BEu9Lm1n0lG3HyM9kl8nqjsz/CT7tg3+rcI4JFQkKJxCNGWrA0zpLtu43Vhnz2UHGaxWNX9ZKqrIOojpkEtjDaQNeIrkrNeTDrTVsDKGztAbhZ0+xnADS2NeNkak5q4FCjO8zjquS4rNzsCdgLCX5gA3THvnaSmRx1LJzONzB8cATIJUfqo+f0hn+lgpJ0Wleyl/6IROxs+al1HpSb1ntR+SSAUHDVngfbxwo85t4xSLcXq9Y/f+RBe7o6X4oI/EDlf+6LHHkjAaZbUI7WmPTAPxPLV14HlZ5BM89CUlto3oeQQE9nTgNw2e2xep9ihgcfKCuO9jXwzHHYwimLq5qMYZjCkoYHN9Gr8DGSp1bg2s84xDoFpfAbFAGIA9DRGBZOH9QxPHQVMqTiey337bV3PO7IUzUS32ZwXxvgasDdV16tev7y+PzoOD+6P05Qk+9T9BJZdY6SRa3uP3SqDVi0jkW9KOfobsZCRaDrOS540UhOngU6v6oMIU2KXBQXvarmw2lmZlgqn9HLhNLDQ6u52Rw6codw
 X3GvSCS4
 bytZMg5YS+Q7liNdj+93ymCSdCMvA92k7S7tXZ82spVRkz+anENbcNkUIzpmhxTcwlrK+AxO/qp0VAhLgVy/RtZHmx5kXjLqHVDISdUFDefoAVCA6fPEfV60KuD0s1m9vMLLbYDAOVRZVKKSBkn63XE4G8WwQs+7WAapbS+5MtuSWl+dzr64ZwJ1tTobNggo0PK+elIP4Z8YiXpZU88He1ZVqkLCuV57ILTx1yA0tWM/u1F//icapwRyNL2kaH+rMJR/TuxgH2rgPsxsP8uZpAj3yvFIA5jat16VWafN/Tp0uRKtkfBPpPbRGIL6gkFVm84ZzuYFXM7w/JuQ2MQaSzqG6JQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 2:06=E2=80=AFPM Bjorn Helgaas <helgaas@kernel.org> =
wrote:
> On Tue, Apr 28, 2026 at 11:47:23PM +0000, David Matlack wrote:
> > On 2026-04-28 05:50 PM, Pasha Tatashin wrote:

> > > This is the way we agreed to handle kexec changes: Baoquan He is the
> > > maintainer, and without his Reviewed-by tag, we won't take changes to
> > > kexec. This is the approach we follow with MM for KHO changes to
> > > memblock and memfd preservation, as well as the upcoming
> > > hugetlb/guestmemfd preservation.
> > >
> > > This is also the approach we should continue using when adding LUO
> > > support to other components like PCI, VFIO, IOMMU, and KVM. It keeps
> > > life easier for the core component maintainers and ensures we do not
> > > regress LU by staging everything in the same tree and sending LU merg=
e
> > > requests from a single tree.
> >
> > Ok it sounds like we are aligned on keeping drivers/pci/liveupdate.c,
> > include/linux/kho/abi/pci.h, and Documentation/PCI/liveupdate.rst in th=
e
> > PCI LIVE UPDATE entry and not duplicating them in the LIVE UPDATE entry=
.
> >
> > I think the only open question is what tree to use for the PCI LIVE
> > UPDATE entry, PCI tree or Live Update tree. You are proposing the Live
> > Update tree.
> >
> > Bjorn are you ok with that approach?
>
> Yes, I think that makes sense, at least to start.  In early days, it
> would probably be a headache to coordinate LU things across multiple
> trees.

Sounds good. I will swap the trees in v5. Thanks all.

