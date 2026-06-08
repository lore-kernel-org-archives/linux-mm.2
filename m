Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91C93CD8CA7
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:56:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D1F2B6B0088; Mon,  8 Jun 2026 17:56:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF64D6B008A; Mon,  8 Jun 2026 17:56:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C0C126B0092; Mon,  8 Jun 2026 17:56:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B20416B0088
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:56:48 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 73BDC40344
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:56:48 +0000 (UTC)
X-FDA: 84858105696.11.F548E24
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 9EAB71C0007
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:56:46 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=USuQHJLv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955806;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sXXyfmnFaXTXjgYYiyfgw2DtQ2NRAhcXZrd2mOcuVWY=;
	b=CS/rrMsXo5IsMu8OC3da6waOdKo6TV2KEmSP5TOqDNMJdfVUiCzUFgrSG6kikMuupYovc5
	wVpeXTEagydZeYtT3rOFPBOe32TRd9xi/2B4+Bo3leANEZOS/3JaR/O/3epHbQv2JJmRZ9
	t646svpa4vYtv1AztxWFzhjD1XuPdLo=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=USuQHJLv;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955806;
	b=zrUATwf9J/UcsEZmKKDWKRrvwc7mio1sFbyvwfJSt1m4AnqNx9KLi0cfBjWvJsF4xV+hjv
	2VYE0M+sqmC9ZIwM58IFbxLHLfQQIhNokeoHA6jLMmxQ8Jfb+fY7iuaNlt/aDRAClFhjSu
	WiTWagVmtKSQxhZIEmIg1Smjk/2Cdo8=
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2c0c379e8ffso32824425ad.3
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:56:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780955805; x=1781560605; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=sXXyfmnFaXTXjgYYiyfgw2DtQ2NRAhcXZrd2mOcuVWY=;
        b=USuQHJLvRngcAt2/yA/8TKAYkQgK2zUIwzghHF+RS5FPJznpXxB9qdjrEtl+GIw+uv
         hzabf6EsfwzOmGEU+35VCu4frXJVB9pLl8k5X5szyPJ74kyrITfbCVDmF0BjszLB315g
         dSTdgK9pPrp0/0tg298utc5w4uckA63Pk2R7LxgPr/m0b/1+oXpKTIh1RpmJUYQSpofS
         o64QxuGeLVRVpbCzCoO1fsjY50qSrhDdzGezYaUbf9qmz+b0HKPcX78jeBayLMvT0PSk
         mgRAQgfbWucQaXNJbswIa9SJjABzzYcULda5BXBlwwzpkcxq96S5xJPABzubEk8uJQZh
         0N3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955805; x=1781560605;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sXXyfmnFaXTXjgYYiyfgw2DtQ2NRAhcXZrd2mOcuVWY=;
        b=GbnQV73eU3oeMQ3RVO5KhufS6vjQpivKX4Z6WyCzjZDlylQpAKdLGM+8R1X4T11KAd
         Dp4XHHZ905Y4W/sgnnzOJhKVIofOtBTDA5d2hjRNo46GzK1W0r9SwyWPt2BRSllKkyO8
         1zT1KEI/o2X6v0uu2ptATgk0MC8GcdNZiVtEEGSfin2ahPyMtvh9I6qN0GcIeLeBYqFC
         iPNsJk0Lg6sPG4tztCx9Y3OuFqH2+qthV+rFSZhD5xtBh3+x5SEgWGOq/rF821SAe/gg
         eQThMvpN/cfhEVOYO3XHiAjS2GC6uT1CaHUqzuGAN9a9XCtuDgxuqDHVWQcpFbATdA3e
         BbNg==
X-Forwarded-Encrypted: i=1; AFNElJ/8yVtvkwZ7h0GcJTdCLvvmSfemJF9+PfyZgCXgylhjbOjTyj+k+f2kOfZbSqfcrT6SUFIuB2hhWg==@kvack.org
X-Gm-Message-State: AOJu0YxiiuyXtJ6GNn4XOXhn/EjZLN/5uIS2heYX0SozEUmbSB7WDB77
	izOMQLZ2rRS1cdNpHpDGVhzuLgYW4mbLBjOJcI8QMqJHn9nihKOUt6oKpVqok2TEfg==
X-Gm-Gg: Acq92OEEaXZCbQRyBJaoyBLb8I5DvgJQrhzkM8AYnS5mGWOaFpwU/nUjANZcuPAwitM
	GfKAljAl8hjybWrl6HtKQZHaCKeszbtEGkyQ0e4Dy1crTvaBdvsbBslLupMjvbmNgxPoTkQWOw1
	dQw8hXzpPItlPgchjfFQ2d1gl9zpY+oLYRyDHfkjgSJKR6Ksb8lv7dzeZSwNlDpykaTtI2AASUt
	QsA6tJltWZdeFHxRlFgmsW1b6+jQEecNLPFsI14lB45aRHc1XHoc9RXgLZHguASmPmDfnxLMVWE
	fMzjilLx0NKa/gzi6iIjEjQOQALi+ouJ/IIOMAIXndJwV3vZIetRX/pDe2sSXgvVN+j54oT5u3S
	+h0pSEsg/kPhY6PkkURW6r/f2T2wF5H1725bn5XlTs5qHfvuPkv0cnFVAZ7ArD5aWdV24DhJ4WA
	vrnW5VXII65pKUXuJgZCWQnXXrp7UZcKz2fm1rblZOW1OrER0ExkfnzA4akb7NZ54dhlDavOru
X-Received: by 2002:a17:902:f542:b0:2c0:ab82:6bb8 with SMTP id d9443c01a7336-2c1e80cfb97mr203347285ad.27.1780955804952;
        Mon, 08 Jun 2026 14:56:44 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c16649d2d4sm177346225ad.77.2026.06.08.14.56.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:56:44 -0700 (PDT)
Date: Mon, 8 Jun 2026 21:56:41 +0000
From: David Matlack <dmatlack@google.com>
To: Pranjal Shrivastava <praan@google.com>
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
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v6 08/12] PCI: liveupdate: Inherit ACS flags in incoming
 preserved devices
Message-ID: <aic6mdiZ0qUJpFca@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiXWmR-ettxin4LC@google.com>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 1bdacw7414puzzgnaopu5oqciwhrw5uy
X-Rspamd-Queue-Id: 9EAB71C0007
X-HE-Tag: 1780955806-996613
X-HE-Meta: U2FsdGVkX18ysYSjlUL35grzQB4zpsBfJXTSs/oURr0vze1s2qbgaJiEqqR+yEtsiq3T3mZF6WGZZ+CrlimPECSIPjsBpRzLOYbxO2j+GKQgJj/T77RrnS3ehyf2hwaUiEYou9AcLiUTZqK+OsxQT8+NF9viq8MgC+oQvwKJzeG9AUSwrpC0fKQAM4MEPWNsRCfMZG22927OE2c8oGbGDKOFu/Q+ISQEvdg+1UwatmRv7AxsX8+M6tYZgxTdsOt2YnmRs88b/sy80REbb64AaYCOpnnUCpvQ2tRAVUjA7lWUN+5cXCvFkUSRiNb5D7I32P36nPVF3ImUuUxlbH4fq2PPQs65mg9mvyNZvOoA44xAd9r9CtoSkH4z1IuJRmtCxr9eBWKQPlEqzxet085c94UJboY0g9qrSKJsAvehIyL99zL0VEQ1K28JTzARA2FifQkf7KpYi0ElJilFQYpNPo9A1cRJnZmo9KgDTeIDlKuClufmkCxyTMFacoyJJKfNBUwOMhzgKG1UPHJIuGN1DJgWkdTMbhMY6huN+CFeXYR6eVyFzmKe1g9RxZLCrEYrxf+B4MMuZLG6Aq5Yw4R8tgtn6HSTVdVfTTdxVWKPULoPuAXGCtKIwrRTDaCRtV5//y/dBlEUloH8rghWWnhASLHuQDNvU50Brfi3JXP1cf6lXP3V1f3+0VEYCKKhGve0tMg3kAKppDOoFvXcZP2Jgt0h+PP1KKmh5ryuEeyqqteVOtfcn+KXWoffS/v0byjBWb/eHIVlp5BEH8ENudrNLZA7CSvch157qVKCMSf2hloq1IcN/WPJngPiIKbMBvLWUYrzTM6zPC+Gc48ZUQRDdClUbrkU2hjNct+QmcCDaJjoT+WnmghZz6DaiqX+bIY4Oy4AYJnYaxppCgVTCHTxrkkmKxyb0yVYvNeBkF+iWqRTXtG0JI4+rfAIqKD3nBBTYqfmnT5b+Il2xN2cXUP
 Tev/K8FY
 D/SpYBhsPYdacZ7nt9VoEp0RXm0iNg7RtDES1lGSdgzY8TZCWPE4JcWZDgYwIiIwK9vsu+zspXJkp6Nuq3CW53G5n8GDygJvrgPXKC4MnEy7nbFuAxAZDbpeLqT/dN/ZSr2AifvEh+V8aI+AfJt5kBC4gFWJjMlhGJyZRXHXo8LqI07T7QvAajp5S/5LEjdUMoDj+gih/RaBeXvU3QjLwFJrYBVLLWqiDe9LbmTsgmCTY0be+zIO90QpNCBs2TADWnHqI7cPpVAxki5+AOF/Rgjds0edlfKCXweY6oIsWEyA0Gd2GSmQ5aOcmWeFAKWiz9iu7lncaoYp60G7EiK1tY9vWVzRvV8aErxZC
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-07 08:37 PM, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:06PM +0000, David Matlack wrote:
> > Inherit Access Control Services (ACS) flags on all incoming preserved
> > devices (endpoints and upstream bridges) during a Live Update.
> > 
> > Inheriting ACS flags avoids changing routing rules while memory
> > transactions are in flight from preserved devices. This is also strictly
> > necessary to ensure that IOMMU group assignments do not change across
> > a Live Update for preserved devices, as changing ACS configurations can
> > split or merge IOMMU groups.
> > 
> > Cache the inherited ACS controls established by the previous kernel in
> > struct pci_dev so that ACS controls do not change after a reset
> > (pci_restore_state() calls pci_enable_acs()).
> > 
> > To simplify ACS inheritance, reject preserving any devices that require
> > quirks to enable ACS as those quirks would also have to take Live Update
> > into account.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
> >  drivers/pci/liveupdate.h       | 11 ++++++
> >  drivers/pci/pci.c              |  5 +++
> >  drivers/pci/pci.h              |  5 +++
> >  drivers/pci/quirks.c           |  7 ++++
> >  include/linux/pci_liveupdate.h |  6 +++
> >  6 files changed, 102 insertions(+)
> > 
> 
> [...]
> 
> >  
> > +void pci_liveupdate_init_acs(struct pci_dev *dev)
> > +{
> > +	guard(rwsem_read)(&pci_liveupdate.rwsem);
> > +
> > +	if (!dev->acs_cap || !dev->liveupdate.incoming)
> > +		return;
> > +
> > +	pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
> 
> I might be thinking out loud here, but as an attacker, this motivates me
> to somehow hack the EP FW to mis-report the PCI_ACS_CTRL register across
> a liveupdate to fool the incoming kernel. If the FW feeds a 0, it silently
> strips ACS protections.
> 
> Should we also serialize ACS state in ser somehow to ensure we aren't 
> fooled by something like this?

What does "EP FW" mean?

Does such an attacker even need Live Update to attack the system? It
seems like such an attacker could route TLPs in whatever malicious way
they want regardless of Live Update.

> 
> > +}
> > +
> > +int pci_liveupdate_enable_acs(struct pci_dev *dev)
> > +{
> > +	u16 acs_ctrl = dev->liveupdate.acs_ctrl;
> > +	u16 acs_cap = dev->acs_cap;
> > +
> > +	/*
> > +	 * Use liveupdate.was_preserved instead of liveupdate.incoming since the
> > +	 * device's ACS controls should not change even after the device is
> > +	 * finished participating in the Live Update.
> > +	 */
> > +	if (!dev->liveupdate.was_preserved)
> > +		return -EINVAL;
> > +
> > +	/*
> > +	 * The previous kernel should not have preserved any devices that
> > +	 * require device-specific quirks to enable ACS, but if such a device is
> > +	 * detected, log a big warning and fall back to the normal enable ACS
> > +	 * path.
> > +	 */
> 
> Nit: It might be worth adding a note here that this can also happen if a
> new device-specific ACS quirk is introduced in the incoming kernel for a
> device that was preserved by the old kernel (which didn't have the quirk).
> In such cases, the two kernels are essentially non-LUO-compatible..

Yes will do.

> 
> > +	if (pci_need_dev_specific_enable_acs(dev)) {
> > +		pci_warn(dev, "Device-specific quirk required to enable ACS!\n");
> > +		WARN_ON_ONCE(true);
> > +		return -EINVAL;
> > +	}
> > +
> > +	if (acs_cap)
> > +		pci_write_config_word(dev, acs_cap + PCI_ACS_CTRL, acs_ctrl);
> > +
> > +	return 0;
> > +}
> > +
> >  /**
> >   * pci_liveupdate_is_incoming() - Check if a device is incoming-preserved
> >   * @dev: The PCI device to check
> 
> [...]
> 
> Thanks,
> Praan

