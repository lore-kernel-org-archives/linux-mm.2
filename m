Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6539FCCFA13
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 20:46:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1886B0095; Thu, 30 Apr 2026 16:46:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC9076B009D; Thu, 30 Apr 2026 16:46:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BDE846B009E; Thu, 30 Apr 2026 16:46:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id AC4B26B0095
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 16:46:58 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5656F86090
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:46:58 +0000 (UTC)
X-FDA: 84716406516.20.5CFED2B
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf25.hostedemail.com (Postfix) with ESMTP id 718F6A000A
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 20:46:56 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BGRCdKiD;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777582016;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkf0FFUPX2DRAnC583F6L6pCpn6Z3D9oHd6oyEqtOrY=;
	b=H/vWdub4lh2u7VQZfEaVg65U7Ch6SZuoSF1mnSodKG2cX4g8j7Upfty6FcmfqHookPpLmj
	+tr7peE8mIxWRnaWSnB6AqLyBEDdFelw6FCuUy9ntuKDe7kF3MGYB7ZEay0RvadlMV1Ooj
	DWiWOVyZHtrdl5navNdtwg0X5e8DmzM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777582016; a=rsa-sha256;
	cv=none;
	b=no81topqgosgFtT7zcWH3LzGr5cgQLsWNxowfDQsuU3BhMxLR1f3fo6rnBLRWNtV/EPq94
	grIkx4i/fGGC21JTcPfGyazJxHWdg/NEnp4DKOEFojDGABFDWlkyeZ3biU+aIOeZDl8SMr
	n4CfW1+/hvAINw0ToQWyQTapjEpDwTI=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=BGRCdKiD;
	spf=pass (imf25.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-82f9fdfc965so645319b3a.1
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 13:46:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777582015; x=1778186815; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=jkf0FFUPX2DRAnC583F6L6pCpn6Z3D9oHd6oyEqtOrY=;
        b=BGRCdKiD+4BC7WT9gExU36EcUJCRqrWAiuv/1BPuZLIdZcMOm15Ap3/jiMx9ZLXP1X
         J/tl1aATTO/jxOj+gXJEy6MkTCUC29yaoCWRvZ57OgJFF2OEF+kMMhYDZSeQRbMgTl06
         KS/sclM+0xqgLHF4GBAfM5kzP+Kk3mcfrUHwrEhoxSBhLhnK+aM2vogLxI+lMtzFkPjY
         jCv/996fQ/MzYSwO6+1d1LKDIEs0mUxuhhyBPSeKD6+JjCj6ThyhJbrlBkIHWNudcru2
         JXRu/95PTxo1R58b6jPmCmgfmyMJ43XwyGBE9QrZd9FpjmhBKBjmiSEcUVWww6eeEvFK
         E1pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777582015; x=1778186815;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=jkf0FFUPX2DRAnC583F6L6pCpn6Z3D9oHd6oyEqtOrY=;
        b=jHfmT0WCEZW+JoSqxEcPb+gLuzeGl3OhOZTDuLqIA7b2GiJkkbgtgw3fTcOyr8C1gf
         q4ZdUkUhhUDwWAka0lv68J1Sodwkx9gXBAUo4xgeUnDPR1A/2gS5BuF45u+8IhTdAMkV
         1Z2onLqgE5OQ+1HybTpof0XAObakb4XlAQoALTtHjyg34GKKFBHL/qzU+fv7x5QQSddx
         EDmGgXSayzcRlPV7zqm2DHQEm5vEwg8OpCZY0uf4MgK5qLcFhF/ZGrrrlN5iSKVDq8hR
         /gu9zH06ikSMaPVGuodQ6viH7u9uYW7Ch5QhelIhvRE2T+I5Fluu1PsljRO4VCofkjnM
         FT5w==
X-Forwarded-Encrypted: i=1; AFNElJ+Nv2znXZ/1EpQra85cf6D5JJvE6iFIxq9ELKVH3Dgp1XRSaHFdhfVetyh3KcMGsxB917WXr1pfuQ==@kvack.org
X-Gm-Message-State: AOJu0YyF1Ao8YRPyvKunq6ZoMuTJL9mdgUXe44c6TjmBfb/e/bUteaQz
	0uXmyHYbE3M35JC8vPuxMYNJzbDmEz7YMMzg+dIg0wA1KQWieXISzp9Bv3fn6/geNA==
X-Gm-Gg: AeBDieuMe/OYFodlmR70Saqe+zSfVqRTGGOS5dGy2WkpCk/BXx9Svq7M0N+pDP8lzd0
	AhnqYoD+h15MYb0DhOs44hi0Kyfs0Ii2Z+USJdKRMRc+a5eeVPoIgVYobgIvgkEDxx8ziDCWwVM
	7TXbhkmYLv8c4Bt895zXMav5aGIJ3K8AL9X50k0M1RfRu0yWBrBy+ES8rpcLYpxU4X1lpLXkj3E
	ABx2O0CrXtmbL5MXhQKK4z3rMOZz2o+fqolhB2VqVTARCu19/kyVr3r6SediYbNmTj07S5ZGvtM
	cGoajEhEcBVrvHFsZM6bdTIGi+z4OHtLPJva5OtPUfqvn6BVCgdEUk3341YFeHdht0W8CrEPPBI
	XR3v1j69MN8fZNWywJeNn7rooGfWbvSAIY9rk2Dm4wVoB8pMqplFXSZ7ZLTp31ugsmR0g5nRgOD
	EpQAJGf/1680rnJkd88HyBSAM4y2TXbLxERZm9bbhGY6px4ChZ+Ra0JUf3XM2Q1IcQqMlE1s31Q
	iMU7g==
X-Received: by 2002:a05:6a00:2384:b0:834:dfb5:6e73 with SMTP id d2e1a72fcca58-834fe061295mr5131011b3a.5.1777582014798;
        Thu, 30 Apr 2026 13:46:54 -0700 (PDT)
Received: from google.com (76.9.127.34.bc.googleusercontent.com. [34.127.9.76])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-83515ad8eb6sm491387b3a.37.2026.04.30.13.46.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Apr 2026 13:46:54 -0700 (PDT)
Date: Thu, 30 Apr 2026 20:46:50 +0000
From: David Matlack <dmatlack@google.com>
To: Samiullah Khawaja <skhawaja@google.com>
Cc: Jason Gunthorpe <jgg@nvidia.com>, iommu@lists.linux.dev,
	kexec@lists.infradead.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Joerg Roedel <joro@8bytes.org>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Will Deacon <will@kernel.org>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v4 08/11] PCI: liveupdate: Require preserved devices are
 in immutable singleton IOMMU groups
Message-ID: <afO_ulcut4GNgEpy@google.com>
References: <20260423212316.3431746-1-dmatlack@google.com>
 <20260423212316.3431746-9-dmatlack@google.com>
 <CALzav=dGpHEnEjyp8qc50iZrGeKJ47vjLvwtvkLCyNzOMJhozw@mail.gmail.com>
 <20260423225253.GA3444440@nvidia.com>
 <CALzav=fraXLgGs-XMc-=whMPhMbS99twFskGtV5Eo=UQ9mU5Fg@mail.gmail.com>
 <aeqpJ7BeBtzoPIx4@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aeqpJ7BeBtzoPIx4@google.com>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 718F6A000A
X-Stat-Signature: rbh35ejgm1s9c43o6qaeahefg9foumir
X-Rspam-User: 
X-HE-Tag: 1777582016-150109
X-HE-Meta: U2FsdGVkX19ULLnt8R+Fkr/QtgKbsWFoPEV/M08eULLnkma9rpZFqCBa4UJn3E0glYtlTykdu/bb6Uji3H6wEnKhexqOFiFTZQuLFCxMXVCMwvoy/p4lKerkccZqYiMIXlAqu5P+zajMoKthok1LuhYKCn0/WjLgqfT/XPiqqtpJdbZC5ReGZEFHTa1EuhE/dXj7k3GRdvBHMe+IM/N1bj01RFUDfnG0NrVn8dKZ752u9xExtqrUxbZ95M1roTCkthV9wXHC7Qj+S09jPcq2gvLtr6eJAwVgFmjUeWlJsJduRQPxZfk1OpAEXYDC17kNTPlik8JxJJbQb02EEAiMskqifsZ+U9X01y09gpqRIwn5ju7MAHTeHRfHE53gHWplCIFeufk34BPkQY3vUSoxWzbeBPEQE89K5bUzaexMKxf6NxAfOPSOVnmS34UDKSpTPYsycvfK/Zyxnv1Mmvj1IyF9Ntg3FuSAnyp2FDot5L81BsjuVWwDmnZvu5SHKTHpjsbWwYPlLOhyY6UlcEC/gngB7OPPz2kXYiko54LV4CbrZecr7fmGtM9eh0wL0iTtLGt6pNzU15d7aPvqTze6cgEHfGfEk2N06qc/XjlmAW+ccAXZBUwEsvQXCC5Df/q5QsZaPGGrJ/9OcokdLVDnenkb+98twi8VtfuFmxVlnhbDtAbQjvEPNEkOt198aEbz12bwxaYZW13WLT+NFoZnC2aAEa/XKwP7QAgGFr/+MlHDxMYsjFCbB5OyJEIhdctkZzcws1C5aoWhEJ03uxrXSV6BplD8DFfXc+Ub2QcCQCD04WCA7Yz8qT64fRnyHFvzCRjsz63tSU3ePj2NdEOq8MJtjngmG9XTWsvxT7XoJcNQoXjNG1ezVpO+HJnTT5r9QZmjDaeLQigPwnT4knwbhSXLCqfncUS8Odj86PUioIMDMX9miLKldBK4gCzqD/IcP1qnM1yoQTCZ0OuX5sO
 /wKvirUS
 004qHW9jMxQi/iWiPKkG9jazXIHf/+couOpbLucZ0jM2hUuGa4mOJjogkUwV/nVBYhjl7oloEmQgFE4PZ6W3FKzpSC5nX/dYCSYqiPlRLlgP0Vy6kogtqXijldRzri/GTQvJWyV5VjfiSebZ8SALK48wsmllFIoOs9nnf6J5abd6VP0HwRCF7MS8q6bFTpF2skRTExZKUos7dg7K6eAS0WqSdk+bjgIoMXYv06rB2M4dIslpLOFiucXEjaN0im1jtGMcWlD9eucoh4Lhbf8ybnkD+lCUiuS5lbzxBBVVot8eCpZr4kGuJQtGmz+0PKfAZR/PmQS8a3fIsDPUDBViuo3uLu9isgMGi7xLNoBQzX5eYpGEO/SPKJfMsFZL8TTfl00H1TkebehQn4RljfvbShJFY0tkcGvV1/Ear60FR5CTI8vY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-04-23 11:27 PM, Samiullah Khawaja wrote:
> On Thu, Apr 23, 2026 at 04:09:01PM -0700, David Matlack wrote:
> > On Thu, Apr 23, 2026 at 3:53 PM Jason Gunthorpe <jgg@nvidia.com> wrote:
> > > 
> > > On Thu, Apr 23, 2026 at 03:10:55PM -0700, David Matlack wrote:
> > > > On Thu, Apr 23, 2026 at 2:23 PM David Matlack <dmatlack@google.com> wrote:
> > > > >
> > > > > Restrict support for preserving PCI devices across Live Update to
> > > > > devices in immutable singleton IOMMU groups. A device's group is
> > > > > considered immutable if all bridges upstream from the device up to the
> > > > > root port have the required ACS features enabled.
> > > > >
> > > > > Since ACS flags are inherited across a Live Update for preserved devices
> > > > > and all the way up to the root port, the preserved device should be in a
> > > > > singleton IOMMU group after kexec in the new kernel.
> > > > >
> > > > > This change should still permit all the current use-cases for PCI device
> > > > > preservation across Live Update, since it is intended to be used in
> > > > > Cloud enviroments which should have the required ACS features enabled
> > > > > for virtualization purposes.
> > > > >
> > > > > If a device is part of a multi-device IOMMU group, preserving it will
> > > > > now fail with an error. This restriction may be lifted in the future if
> > > > > support for preserving multi-device groups is desired.
> > > > >
> > > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > >
> > > > Jason, do you think requiring singleton iommu groups is still
> > > > necessary/useful now that this series preserves ACS flags on preserved
> > > > devices and upstream bridges?
> > > 
> > > I have forgotten why we introduced that? There are alot of funky
> > > things about iommu groups that might be important upon restoration..
> > 
> > You had originally suggested it in this thread:
> > 
> >  https://lore.kernel.org/kvm/20260301192236.GQ5933@nvidia.com/
> > 
> > > Like if you preserve one group member but not the other what do you ?
> > 
> > Yeah I imagine there could be some tricky cases there...
> > 
> > I wonder if PCI core is the right layer to enforce this. Maybe this
> > fits better into Sami's IOMMU core series since that is where all
> > those tricky cases will be (I imagine?).
> 
> +1
> 
> Also I think this should probably be checked by iommufd and invoked
> through vfio cdev. Basically when vfio cdev calls into iommufd to
> preserve IOMMU specific aspects of device (PASID table etc), iommufd can
> check this and return error.

Ok I will drop this patch from v5. The IOMMU core can check for it if it
makes life simpler, but I can't think of anything in the PCI core that
cares about this check.

