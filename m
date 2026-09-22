Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BB536C982FA
	for <linux-mm@archiver.kernel.org>; Tue, 22 Sep 2026 18:54:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A07566B0095; Tue, 22 Sep 2026 14:53:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B85B6B0096; Tue, 22 Sep 2026 14:53:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 882B56B0098; Tue, 22 Sep 2026 14:53:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59CCD6B0095
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 14:53:59 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4CD111205AD
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:53:58 +0000 (UTC)
X-FDA: 85242297756.13.A69C810
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	by imf24.hostedemail.com (Postfix) with ESMTP id 5E8A7180008
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 18:53:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nmp+m73H;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790103236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Mk9DB7qPIG0z2a0BppKMxU3ch/ZxTA+4gqsB2SAa/tM=;
	b=eBIP5FCpgvcPXS0scpQDwvoXQqtTleS6R6VP6toUqz/LqM288R1PyhVSq+In1SH6JXYb2U
	FHhT/vqTYwn/fUznfguesxemoDlhO1blZNUp0Vj/MorkOzC8R+DucOOH/Leylw6Vypaj1x
	dtl5kJxqO5Grmy/7UlI90U7dmTR+DoE=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790103236;
	b=n8jS9wSZKMXWF1ey+uQ/w1x7WwYsx47qyVfAyYJVfSnSyxv9xfJg6pSb1UkYd7i60z9flH
	WwuUoxFWvFXhlnwNVffhMOKyTBuawWs8jhN4cAqTxZ2eV3xahf0C1MVAypgWI9mfyE4Q9i
	VPJMzCH1HL+2ApLShy8OLvJLvsAJ3h4=
ARC-Authentication-Results: i=2;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=Nmp+m73H;
	spf=pass (imf24.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c29d50b7cf9so17180066b.2
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 11:53:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790103235; cv=none;
        d=google.com; s=arc-20260327;
        b=ER9xD8YCGH8ct9KXsrRTl/ASV/2y05REf2IR+uOE0oGfU3Fg7dP/qEgDSQLf1ZHj+E
         PyD2wl7wS60ENlqm3xDQ/ey1/EuNvixcMo7VnuET8qy2H/pOIKEehj+AB/LjmPIbjeR5
         f7BlcZHjrw31B3M+bRrcOg+ZEbCUMo7VTFBUdouaicmtqcLCNWXbJMOFXwL1+xV082e4
         g8pMwaw8G7OI7tj/fVzIqfh2XHBqtHxMZZSGK2F9tcflbXEsrECVE2VtijM1c3GSC9Hi
         dT+/FEaO548YXmE9it8eDP1KVj6RcVuuBcdweTwhMGr1FymyoRYbx1knN+YPQKX6FDvw
         bnEA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Mk9DB7qPIG0z2a0BppKMxU3ch/ZxTA+4gqsB2SAa/tM=;
        fh=wbpxcjmjncUwCTN0+zRaXBH0aITo1MQA3Wfii97taHE=;
        b=lSZ3Rnk8fr+HoE1a96ql71W3kS/64PnWSmCHXWNQVaRjXUw7QVQ4Wl2/dZIXUlRF99
         gN658V4cZqbHbvg5EdoQPDUsIuFGORN0UceviWR9JHXthctLg5z4SiW/TxJr+S/QBraI
         IS2Sop+xKhJxFelGpgWnYqkPfqFmbR+OUvl1d6tnC0k4RM05nPuWNAuz4x+WWZj7FB9k
         +t7YPlzIYvtoCYv/BoImdD/uYOlti8pzqGDQNbhDKHXHbnGYHIZ1dZV3DVJKY5YaxDOV
         lqhlLhk3TQ1hzC/AtDVw4x86/lx2l2UG0mctHnAVVtl0bu0vaATs08QinzXa+Mk2NGyF
         J7wg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790103235; x=1790708035; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Mk9DB7qPIG0z2a0BppKMxU3ch/ZxTA+4gqsB2SAa/tM=;
        b=Nmp+m73H0SGmUPrSQGkyq1iAg5rCrGVGpfZGTdJe+iTxhV4y0G0MlvzXEtV6gU8n1+
         /xsGoW0gTDwKAXSUCdtuXB7YZZt615tOk3OGpZt1YeVI1G+M04AwcdrJqMIABC9i6YBq
         d2ngrINCjcoc1lN1Xo3w2J5dsx42ukBVhZ8uNv9SnO8COMc2i9iaR8gVc2hJTG0I1VJZ
         saYb4pTs2HhVEmVNKoTThovMtI8rWyLXiT+6/t06l4zlPIogLk3OS4LIxKENCm6GkeXG
         /28hEdyhxUeAE2dY5d+gza03u1nNJs4vRERih3RLiRKC06iQs2sctQQ81ZkbZCYfBlGf
         5Vtg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790103235; x=1790708035;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mk9DB7qPIG0z2a0BppKMxU3ch/ZxTA+4gqsB2SAa/tM=;
        b=y6WxDA9ec+F8ne61ZU59Pj0CarnM+sSiJmHw+0EAQEBRSWeXgiD1pswB7ze2T9FnpP
         fdZtaAiDH1hCCp9s8paARHegTXL2pSRwuWQW9OgwTn1WiQGZ/qQ8TOVPf9n9Sn4Ggt/F
         Optg+3BnQ/H9cJ6VvGG+NxkpuxlTKKV6NDMYj1Yr6IRMyIcvM5LmoNoW5YmWchXELJJf
         3g84SYeP/g8Ckt1z3GmAcmZidzpdHNFVxwS/iiF/vEG/xcViNTwNTwOY16ysBSIJguer
         vL/d1nlXb1sFlMNQHj07ajSYYz9fy1KyNsM7W/3xAxXgPT0+0KvsgB8yAfckC0ttf6Ed
         MpMg==
X-Forwarded-Encrypted: i=1; AKwUvBxFLbsCwTiRm5jJoQ4RGoYzG2C0DVioxXcb7dzmmnsUxkzs9PDG0nHJvl9kihu8ZNsyIFSeXCmCkQ==@kvack.org
X-Gm-Message-State: AFuF++ltY+N3crD+Kgc8cHWphH0lzLtFCUPZqs71xFUW1sj/HoUmuzAB
	OHjNf8knA/50JH5lP2BFU1QdSoyAskzbp9Zq+9ZjD3yDmNWQCDYGYZl88lIb5ZaN8ymsi/Fcr7W
	J9DD3Oeq8Ds2tQwV7CDxLndck7a7Cu5SWLkEszVXD
X-Gm-Gg: AYBFou09T100/9q5mZ68E6K6R+ffy5zZO4JzxYcjD9v0AI+nMeC9EbALxf2syRX7Qic
	YUDtRPQP8Atg2PbOQ+BFq7FYXWuyLj4WLkMzcjfAbzZNTibmHJq6Jya3KGyZdiv2GOXvu+x/qNZ
	Sd/jub/04bwRmQlgx4pLejU73Vl42jHU0Raa07swl3SDvf2ge4N8lRuhgkwgBqNXFHy0Oo2UNf3
	c3ZJKNaoDbjPi+Z3CqQm7fcaJjdVZUcqcKpr4d/JQjE7eEvS0VTrMU/l6M6Uz5De/F8ufFDqn0y
	YyzgRBITeow698srwtuT0MhOw/+vQ6hT5xmg8O7lVMIuNOG7v0rSp+v+ug==
X-Received: by 2002:a17:906:f58c:b0:c29:448b:f5d4 with SMTP id
 a640c23a62f3a-c2aae2b0595mr11895766b.35.1790103234240; Tue, 22 Sep 2026
 11:53:54 -0700 (PDT)
MIME-Version: 1.0
References: <20260918200640.887030-1-dmatlack@google.com> <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
In-Reply-To: <2e88b92a-d3f2-41f7-bdbe-11fd71690606@linux.dev>
From: David Matlack <dmatlack@google.com>
Date: Tue, 22 Sep 2026 11:53:26 -0700
X-Gm-Features: AclHuK_mAcmGN2d4gu0q1ERBsbnyv84fOIFniqxdriBGbAgM5X1zIuozEi_ewvI
Message-ID: <CALzav=eJU+fnPr-QN4s7gY_Lj8Pc3T6KXfC9kiQQ=g4rPEDMuA@mail.gmail.com>
Subject: Re: [PATCH v9 00/13] PCI: liveupdate: PCI core support for Live Update
To: Zhu Yanjun <yanjun.zhu@linux.dev>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
	David Rientjes <rientjes@google.com>, Jacob Pan <jacob.pan@linux.microsoft.com>, 
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Randy Dunlap <rdunlap@infradead.org>, Saeed Mahameed <saeedm@nvidia.com>, 
	Samiullah Khawaja <skhawaja@google.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: c1iempc8uer6z7pzpkmh4ufbqunikd6w
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 5E8A7180008
X-HE-Tag: 1790103236-124240
X-HE-Meta: U2FsdGVkX1+maeadpCrwy3Zj3deobG7xF5rrgvpeQSC/4eOh/de2dycFvNpZZ7V/+HGu1Gx5JdRUBcpYtMfTZYEjf/figeABt19tBw4wOcBg42LGOcS4dlhT+sQWbY4lJqogblmx8OuW6iqeoEICmXt/5SnUz9TiFjv/qmERGDJMm1R1va4twWz2ElSp2t/L9IIYC2jBMpsXy+6VrXCiupXFq/ahTNVjvwNA5GCkuCoE2EQeVttfO6nhNuaqv3WZ8OJ9PpdAVjuuwpTjYbXxHXcsfKNPhYYFVyaBVxwoYaH0jjA/NTbZk9nvNLSmf9LEYENzpolzVCWYPkkPrU7xJktRREQpRnV6RW8C/NQmLxPGxQQp/05SKHNEC5yPJ4m5+0KbCB57N+N5MqpYjV2HgMK7Bwwjc4tVCkjelLniGAvwPJI1Xv7nBZNCRBAS8dMpAw5hiIeUEfIg55qxHE8szjMIIxvK6YLOW1nuUZ1rjH2j4MnJRlK3WuaDzNKPgV01qJ5XIgqhpy/MbCJQXsWlQnpiP81N86fX9Eqlmxi8ck/g4ERV5cyHxpgPK0EscVJzxqE2m21Dkl4mpbmReQaNDouMwcvHsiw9QKb24L/cFd0P2svLvM10zd2ZY5EFzc4F6/OUV7P3GnWl77YPBmScWl4bZwPKJEhe6hs4rK+WjMmEKpGabtHnmCh6Shp+1BCraWjYFzpHRD53ykMF1pJk0A16psGIqzo+CgKFmSirv86P7Boed5q2fRGqtmTDi9k46VvK6uJXRfl2EkQgLgG+LX9fHlqKqKPIEpHepQsvwUWw9/RXZrcG3u9yVxAp0uOEd7GhzoCbxinOtVvt4LQeiBnKTcKYY/NJlQht6L7DtDdf8Or7v4uuofno2y9BiBtrkJjD026scMhhtK1VoESN3Els3g37qTktubWI1q1sy4ROR79oChdm3qHnkM6TRpjWY72NsZdPd6eQTcqwatU
 F18Ybkty
 05s2Xq9XU3nKrJXuM8+RBGluE61JPGFBDH73hm4OtgFvp23+hS/dKIYj3xZGJ+bfJ2Z9eAcO8EkiaGdi8uhIKtXYnGualI8ek94Cs6d1nNEyefEBh15bYDwYUEo31u3+cVZrlph9DqdiUR9kQIoHUgK4qd/t7ixEgxHJlBDpuywvds5FFyb5ZZJDSJZgYuDHA/fGClFA1MLlmFQHT9yZfL52qEN0EaoVFjY9qHTGTAyUQBeHZw/BvM8VodVTpgK5TpmeZ1HvzuJSQxM69IRaTZL1QY/KNm5kVI1vy
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 22, 2026 at 11:36=E2=80=AFAM Zhu Yanjun <yanjun.zhu@linux.dev> =
wrote:
> =E5=9C=A8 2026/9/18 13:06, David Matlack =E5=86=99=E9=81=93:
> > Future Work
> > -----------
> >
> > Following this series, we expect to make further improvements to the PC=
I
> > core support for Live Update:
> >
> >    - Allow P2P across Live Update by avoiding resizing or moving
> >      preserved device BARs and preserving all upstream bridge windows.
> >
> >    - Support preserving Virtual Functions by preserving SR-IOV
> >      configuration on PFs and enumerating VFs after Live Update.
>
> Preserving the PCIe topology, bus numbers, ACS, and Bus Mastering across
> kexec is a foundational step for minimizing downtime.
>
> As we look toward complete end-to-end support for DMA preservation
> across Live Update=E2=80=94especially for VFIO device passthrough and dma=
-buf
> sharing scenarios=E2=80=94IOMMU table/domain preservation becomes crucial=
 to
> prevent IOMMU page faults when devices continue performing DMA during kex=
ec.
>
> I would like to ask about the current status and roadmap regarding IOMMU
> Live Update / KHO (Kexec Handover) support:
>
> Is there an ongoing effort or RFC series for IOMMU handover / page-table
> preservation currently in development or under discussion?
>
> How is the coordination between the PCI core Live Update mechanisms and
> the IOMMU subsystem being envisioned for preserving IOVA mappings (e.g.,
> restoring domains or handing over root tables)?
>
> Any pointers to active discussion threads, RFCs, or future plans
> regarding IOMMU participation in Live Update would be greatly appreciated=
.

The first IOMMU series to support Live update, can be found here:

  https://lore.kernel.org/linux-iommu/20260921004834.2601285-1-skhawaja@goo=
gle.com/

The IOMMU series builds on top of the PCI core support (this series)
and the VFIO series linked further up in the cover letter.

