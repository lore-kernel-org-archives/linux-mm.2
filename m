Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 78FBDCD98ED
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:31:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 142206B0088; Thu, 18 Jun 2026 09:31:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0F37D6B008A; Thu, 18 Jun 2026 09:31:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24806B008C; Thu, 18 Jun 2026 09:31:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id C7C4B6B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:31:06 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D67A7A071D
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:31:05 +0000 (UTC)
X-FDA: 84893119290.01.712B64C
Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	by imf28.hostedemail.com (Postfix) with ESMTP id E555FC0013
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:31:03 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Y/MhBcyZ";
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781789464;
	b=1teXJK3/ArorE7p32nFsuSbj2u9hnGlfwerHF/Po93woBzK2A/HHpikTEpLskOsgLCne6F
	cMST1VmxddsneFyZ8hWTmHDI60c1PI2CTlY0nrvhkYqBC4E/LRTs2rkr2pBMEvhISBJs5S
	vFFZ1dipEGmNg3JwK0S/aKMOuH1I8lU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b="Y/MhBcyZ";
	spf=pass (imf28.hostedemail.com: domain of praan@google.com designates 209.85.214.181 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781789464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=97YgfxmG6Chl0Ir+S9QMmQ5bxu5X/S2hJhh/DZ4TYTw=;
	b=JLT62h9lxZ8lLH4B20aPan2dFSKfuyl5urCAVjNL2K66UUIThsAbqHeZA6Pneb7sZdOg0V
	4ncX85SIw20KQoI/NcAAJO/4yIWW0zdEkzkg486L4iEJTwskLhHYnxl8MSJ9FNX+sYI+Ha
	28SegB+9d6tBjommDWFDmf2Iu9ALv+g=
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2c6a4eccab1so50195ad.1
        for <linux-mm@kvack.org>; Thu, 18 Jun 2026 06:31:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781789463; x=1782394263; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=97YgfxmG6Chl0Ir+S9QMmQ5bxu5X/S2hJhh/DZ4TYTw=;
        b=Y/MhBcyZQ+hJtupzu2oSyXsq7z+kgR79q42PDh4HDLns2jCmgZRXFKrHezt3VGsGv8
         CcJm9jp2DZ38kJrT3KcIKGTUT4AclDCOhcaXQeJWz/TrHGcyMMhDeD1C1t4viO0M5sjY
         t8HvBXjDF8AYpC6J027JeNV76Nk96m7FHWpR887RWaRoKUaFJUFbdtRxU5knGdD5yyLR
         D3fWp21Y434WD/lf1iQDoV1aND8hHlGixUdn+Fq8mggnAoPTiNozwZqmoVsD/oFBGuDd
         /PHNMCxp0b12TtzhqTT2Tr58phJYJqskJFiRRj34CHQ3QTRY0lq/EBCD2mKRkl9QwEYY
         Vzvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781789463; x=1782394263;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=97YgfxmG6Chl0Ir+S9QMmQ5bxu5X/S2hJhh/DZ4TYTw=;
        b=GwwmcsMkjQGlOb+7desupWz1CQFr1xrTPHfE/HnTy0Qp7bQj2btHpg3t+Zjt8Y/DGk
         ng/TgPQObcd3lvtEBgsrGSfKmJPGe8a/zyTP/i8JINu3LP4UWyproTjqV6F9j5XKqZjP
         quAR7Z9jadXdTGanSvbx9wCfinsugqswpTMhIkhZ27IHpVE+ufB+vObmwrr4CpnxY07D
         7Ui8zIzK1LSYIzjyL8PiZtgExbLqCzGZYI7ls7SnHgAUjiedYFsFxvCgxb8yNqOQAWwi
         rro0DWOEjv87zg26aksA2uqeWs7Gg23Hs53Zh8JQoOv6e7PKUZJT2+dxx9lUYp0BJI3E
         yBMA==
X-Forwarded-Encrypted: i=1; AFNElJ/wYKku7BGCfUwPmmcPzU95dvBDgwLGkirMvy5r3lYfZ/178ZCHOKL6BODl21UMlRKfM921APQGIA==@kvack.org
X-Gm-Message-State: AOJu0YymCDRkNZI+ItELgMeTkaVduRETNE1EqXBkVvKFAHNlzPjkTrQt
	WbqJaoVFfBkyf+IRuI8Uj77AXn8ais75dRcBRiwrRXGohlYIpQAru212gxx5J0kp7g==
X-Gm-Gg: AfdE7ck0f5havOxX5cvmTKLgKQr6x8kEfMoVy1EBRQfOdvblG4KDXYqATUZysaj/9Kz
	7aUh4SVs8jqjjE1YvP5xRzdZKaENn9LyKbIn/QaCwq3Ogkh3tWB7rvZeaFKfaI0KraClFPLXlk+
	p7hc1jyxKYb9euDhTvUA+dFiG5WlJKoTn2FUtJCw9twVBSCrU4OatIcYZcCwDf+Q/U1LvMl+u+i
	+KgM8A9iSoRTychsssi89H7iEIQgN5WYEofy98p8BT0JubYUW1GlB2smj8vr7torRoMhQaeFmPV
	uC4LFIzN6N8u+RZGD847PkjQrsZxJKEqbt8Hi22MM9c9j3mvx2TGKXYzRW1cL7t3w6vkS2n1Cbb
	daB4RDifxho0PMZ5HEIs/zYrTEUIeeTu26dKsHpK7EHps+hSiBxT3vF3Qk01rcjYMnx4oiPf9On
	Rjeu5ErOHTNBGceWm2xHc9hcitV1CpR9p2eF9nKY/mQdVOTXYUfg==
X-Received: by 2002:a17:902:d587:b0:2b4:58ad:e987 with SMTP id d9443c01a7336-2c6e8692cdamr1747625ad.17.1781789461980;
        Thu, 18 Jun 2026 06:31:01 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-37c521aa16fsm9477952a91.4.2026.06.18.06.30.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Jun 2026 06:31:00 -0700 (PDT)
Date: Thu, 18 Jun 2026 13:30:51 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
Cc: Pasha Tatashin <pasha.tatashin@soleen.com>,
	Mike Rapoport <rppt@kernel.org>, kexec@lists.infradead.org,
	linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>,
	Alex Williamson <alex@shazbot.org>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jonathan Corbet <corbet@lwn.net>,
	Josh Hilke <jrhilke@google.com>,
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>,
	Parav Pandit <parav@nvidia.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 01/12] PCI: liveupdate: Set up FLB handler for the PCI
 core
Message-ID: <ajPzC2Xh1NMbfokP@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-2-dmatlack@google.com>
 <178124130274.908199.14827357870284807134.b4-review@b4>
 <aiutNINqxhtlm2Dt@kernel.org>
 <178126123047.908199.12042730612990730743.b4-reply@b4>
 <ajB6V6yBHOjgK5ew@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ajB6V6yBHOjgK5ew@google.com>
X-Rspamd-Queue-Id: E555FC0013
X-Stat-Signature: a7edke4mheyxtzj1ahfgshzj8rcg4qaf
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-HE-Tag: 1781789463-142569
X-HE-Meta: U2FsdGVkX19G9ZUojiHyHSs44+FDieCofbwIIRe6q0UavFHYiuiyk5V+S06dUjl3CzbZtsTcBKFb2ilUZAl5YqX78IDdO1X1A1urkKJzXMEoSlt0kpyjY93dZOHNrLkGXzsMs62I+2bu6vY380TzxJq/tkXv5+0Gl3jyIqKBbI8HT5cYqCwo+1KE/eCP4Xx5PinQBKsu+aWA4yVaaZT1XXoBxJFSebxLpmnPrQNGv2X8hzl+DR/IAHYiYH6LNi9RrqH2/ON7UJHERDouCngii8OO9DtfYdj4qKy9NPlpffER/iSZZqizQuWfGlkW/XnBVVLPeGQ5/XTt+NMmvZlxgFLJQt3PUG+jVA7D5ZJ3NFdx684nHVfC8GuZxh3Uj9WUOefdF6XP1z7RbHT/rrO4GLXJlf7uWnU7cbz96rgLn0vXI9/yUNXN/SIRVVciXwv5hvchD0ReSMl9GTLNr/VQ9o1VCBI6UcjNfZuM4KCOU+rxDQolF/EYr7jsfuJlk9iXTEmHN1w5GP/BW5SSFaC/67iZgK9t100xwY4VPyfLK64MKH2fe6kCKuCs84EW5NnPhghZkWcQzYBW3XYscIUFR5SNltY9wqs7X0ngBBiOaS1g+szT4+0oP2r+y9pab+C4OzTEtYeZGjsptKvGURtJd1j6OlAd9EBgLrUz57615sMz00Btt96zjtw8GdKtoYykG97RNHOLHU2Xlw3hmyBu7g0Buz01CZvQPK6aYAqD9hNGaE5s4AyKQRyzPtaQucjCoqdOJDCwL+bRjIe7Osx0Mo66+2g8hI/809g7VZuH4RfgMe8g85bKtbOtC3qrDfeq4PsY/W5dAMpRtT15S93/fyvw0XBug9PvWHjXhj6MeJ6DcJfQ35eNAnDGhCoR016dRgSC+ax2+B4mMfJmTCZ4SEHZOAthURKsQG4Cke0onUEM9GNIUYKWhIkl+/2bNAYBRGgLDrdMeTxhSutNY7M
 7fBSqk6+
 VVm8KsGzWo8hnYeJtdLS+JhsPnxsfYWjy2SwDQVuvIWoRDV6eYdCP2aeuSQDntn+1AIX7YcrrwSMSCSMDqbu0Nz05HkKdHtgLVpRzvbvqWzMq2jmfmcMt1BoguqDG0lnN5s4H6V/8Y/dfpMAVSvh04t97L8B54kwlBi39as6q0fZgHdkxEutdwgee64k7k2ui62pFRErClGndaB3xGrFauTSB8b4zIIWrsklLRcGSzBjNreJtmerF/Wuo4OoNHDYxuPT8WiJBP9n0Ai4KkH/p0u9fRaVOyi5//IkS50Gri0M/mE5VJn2ZYR4N/JqBl/qYY0flHoExKtutU0I2l/vF53scSx7UADAXd5xk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 10:19:03PM +0000, David Matlack wrote:
> On 2026-06-12 10:47 AM, Pasha Tatashin wrote:
> > On 2026-06-12 09:54:44+03:00, Mike Rapoport wrote:
> > > On Fri, Jun 12, 2026 at 05:15:02AM +0000, Pasha Tatashin wrote:
> > > 
> > > > On Fri, 22 May 2026 20:23:59 +0000, David Matlack <dmatlack@google.com> wrote:
> > > > 
> > > > Please add Pratyush, Mike, and myself so we are notified directly of 
> > > > incoming patches, the same as with other areas where the liveupdate/ 
> > > > tree is specified.
> > > 
> > > Or we can add PCI liveupdate files to LIVEUPDATE entry.
> > 
> > That will not work, as we cannot serve as maintainers for 
> > PCI/VFIO/IOMMU/KVM, etc. David Matlack will be the maintainer for the 
> > PCI components, and we will accept patches once they have been approved 
> > by him.
> > 
> > The simplification we could do is to create an email alias 
> > for the live-update tree maintainers. This would allow us to use a 
> > single entry instead of listing all three of us individually.
> 
> We could create a Live Update mailing list for all code that can be CCed
> on all patches that must be merged through the Live Update tree. I would
> also be interested in subscribing to that list.

+1. I'd like if there's a specific Live Update mailing list for
submissions & discussion about the Live Update tree.

Thanks,
Praan

