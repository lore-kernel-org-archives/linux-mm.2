Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9A5E2CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 19:26:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B11F56B009B; Tue,  9 Jun 2026 15:26:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC2056B00A4; Tue,  9 Jun 2026 15:26:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B12E6B00A7; Tue,  9 Jun 2026 15:26:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 86BC36B009B
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 15:26:10 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2F1F21A070A
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:26:10 +0000 (UTC)
X-FDA: 84861354900.30.C970F9F
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf18.hostedemail.com (Postfix) with ESMTP id 4DFFE1C0007
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 19:26:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cmWuXs3s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781033168;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpDQMG3B/X+zmrU+8qfo8gbz7yy+2Hc3r+dRrwN0wsk=;
	b=z5hv0NYYILELXwFZFgIXDBKMAcbtEpXhbUrWxJIWDn3NxIPV3yG35zp34FzuDhSDUhQRvv
	r/78Lh1Xpu2uywOXjGq0jFUSX9rirZ0ZxvjnbBOqr9/JQBWjDsPg3/yBaR0sQu/Au00sLx
	hHNp0Z5WngwR2I2YHq3W+FVbFcUr9mI=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=cmWuXs3s;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf18.hostedemail.com: domain of praan@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=praan@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781033168;
	b=mBLY/OrCnhV2lxh4+ViQBed4N1vOH9c4jAsQC4LrVvxernWdj5GpQFjhLN2OqujPdixNs4
	yxoaZtUnRDNOmxLN2cX/9wk75SXbHdruPwsQOm+WOwXcE+L3LqPyH88NlMCFbZqDKX7PHm
	XeZ3iyngQWvDULJbDMJC+OV4bmKVJhU=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2c0b1a48855so552255ad.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 12:26:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781033167; x=1781637967; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vpDQMG3B/X+zmrU+8qfo8gbz7yy+2Hc3r+dRrwN0wsk=;
        b=cmWuXs3sF/QQbywkAFcnBeytvKr79W3Yveu8CxuMvADF8UkXkse5sxywOk3EWab0oQ
         NpTQ42YkIjl0lfnQv1Y5f66X++q28lsflG3Ym9QDKbOCykcNEtpOWg/EhejZkw7ZRGRJ
         /DppzmdlUoDi9T4yR1hdjxHajzWFotJFPgW85hO++L4wm9FYUWnAHSCOsAEkQl9X0YH4
         okjt41vUNXGoPqoHNxVXG6jxcvnuuQnZcyV2Z4HGmT8XNIXNeKgsHS9OATDI1kIpRE44
         nBybbzBn9Fg/O4LvzbV7rn6yQ4QsbYmK838d2XCB7YjJoGPNswFiCRb8Tu1S+IKEdFeJ
         ow/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781033167; x=1781637967;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vpDQMG3B/X+zmrU+8qfo8gbz7yy+2Hc3r+dRrwN0wsk=;
        b=qXuTnjWmJ5B2RHOI9DRxq1mynRxvG1/o0/qfl3/nfJctFWoAq6b8CfZL64KR4oTsQW
         oth8EgsWd77dFu4/O1qpdUO6SFm/guGVaThNdTCo1zMHz6jJe8fOGMrkqETZTk0C90VH
         yvJUwQrQTpeYN8ZVcrzKYzrmMeyj6TPTN/G/+swq2qJYICqXUeDQrhQ+o58ysjkld38d
         iH2RUR3Nm7Yr7BIy1QCckeu6B78Vp0FAk72tm/jyBsBaN50sqzzqbKcAAUufvFgaKHKB
         dHP6p1A9yppsUbMgIYg1AXQD0bwuwxZBho6p2ShookUHXlXQrxuhbBh/BpskzZFdCAOZ
         v8qA==
X-Forwarded-Encrypted: i=1; AFNElJ/hcy9AI7je7a3xP6ZFIFvOBXC8DQiAIQvp82u4Eh6W22EYSVw959K+5l2dvOZuTj1NzA/NPkL61Q==@kvack.org
X-Gm-Message-State: AOJu0YyU7oR6jlJ/iBdlMfiF9gt2QxIQv1jqxE1jS0Vxry/P4WKmSIhe
	3w705YdiGVXXtsEb+FgtenZq6LBC72OKT7bGghIn+jatnKnMD1mEfMlyL36weCUlaw==
X-Gm-Gg: Acq92OGDHIuDq7g16cSsOHLfxbMlsOwc7e1KNgyOlY/TQC+p4lWlBESj/Dvx/iQFxQb
	m6wRF6dA9iU5wkoYjyPD1Cpm+TIXlIXoneRTOHwUia+hL4Ee7FEMhkVWNt0bB0ff1cljQMnBIjo
	oN1D9LRdpCKc4pVZUhC8OaHveAXtPp9g+EVhOBtb1LXLtig9BXn40giq0gJKs17SK+8Rrsvjdi0
	aiZWHCFkz5yLDa+WudI0CvSzOw/BwQuAR/0WEQO/eLk4jkB916HJHtbPPzXwngbIKcJOMrkdASy
	zTP5txOyOHlDfziKk3ZiFHa2jrOPaOmBd67EYYX3wp2yxZ9QYY6+Hsl4Q8bRz+9ecoB0PnDeqqM
	5YTVpK+jLmtCmImbSAyRy9MM0ZvqMvRQUJGuPp6/HTxw80LX2zH0RVc26iJwWJrnxux/8tItui+
	1gR/hTe/MvfvBIopiKSFx7pyCrN6C6sJvKvFQhMEnmFPTHF/+iwldUFwrmbH6DP6FnygbbKe4=
X-Received: by 2002:a17:903:19ed:b0:2bf:3579:cdaa with SMTP id d9443c01a7336-2c1eb942782mr8088245ad.10.1781033166370;
        Tue, 09 Jun 2026 12:26:06 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428237430esm20445672b3a.21.2026.06.09.12.26.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 12:26:05 -0700 (PDT)
Date: Tue, 9 Jun 2026 19:25:56 +0000
From: Pranjal Shrivastava <praan@google.com>
To: David Matlack <dmatlack@google.com>
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
Message-ID: <aihoxGlb-ruwAaWC@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-9-dmatlack@google.com>
 <aiXWmR-ettxin4LC@google.com>
 <aic6mdiZ0qUJpFca@google.com>
 <aihLTgs1Y49OXQaV@google.com>
 <CALzav=dagHvcS8kbTti5rmMoks9DXuCpO3AjptkQ8z_PdG9JyQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CALzav=dagHvcS8kbTti5rmMoks9DXuCpO3AjptkQ8z_PdG9JyQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4DFFE1C0007
X-Stat-Signature: 1otn76numdse1st3ihxn36o4ey5piuca
X-Rspam-User: 
X-HE-Tag: 1781033168-61191
X-HE-Meta: U2FsdGVkX18fsSCuM3LKa8z7T6MDrgu3SAVi+muy5zKLKQrHiMtiwtNgrBBhi21xWVo1NRr7HiGmNuf6Lmh3OjT0hHuf+0fV8bgl7kri45OLedeIUN/9sbd5QdW+PfZSes9Ivo3YDh5RXA1aLGIzI4IktPZU2YhT2vrDBIoyuyhn2VVZSA8ZmNrganMbk5UiATyx9SEy2sDe5tdr20Dz/WwsGpw3vxz6+3zUCoWOkP7+Sb3+HNeWXGC0pK0fGFczUkUa22a31RnRcYEtRJItP6KKRIeQ/MrWC0eW5+A1PDuTFMT/eYZXMXU3+vUnKFD/FeqlMWZRIpFfeBqe+Hspd2tIOg86OYLUiPSasYRF4ZECpvoMs+LL+7VWLD/NL7sbUgG93KpF1pdtC65VBZMod/EHaND59/Js697anCsagzePEGvYqU6b99CcRSAtG6wP7716mqbwiDfvPoGtc0fIRQP6XTMIF/oe+5ymhv/J6Uh4OS3pXtj9d5ELZ3sZKDf51OlfbjXl8l8Z8rUqP21NiL6BUD1n7hFjuQwJBDnpf9AcHbSPL+TaeNOvvn8vPFyAv5gZ+BNNfzwuYnKIyIYa1uie1EIxs3PXtn6PVk5YGY0zSpimvWULXXdfgRO28d3kyx4P2RUYlnILhglgWhwsF7y8q7lKe9CItX/OB+mD/JYwmAYqAkffm9BWKZy8vhh0BdlnjZVpA8FnRmkGxMAwsc6+nbO9CQCQT2xqjXf6wuBt/SRgPOYcg5o9gH8i+k/UOgR7cQH52E9YmjFliS6jOyiIGd1+jaLERkd23NnFe3LmN8Nh9+MOHvOtkvn27ONpc/GlcIIdziWZxivZgHLCnaqjKHhGfkzwYXyFD2rwVqkNMly1VAHxr7/pZFdSLDNBGi33oN3OMIHy+AKGwoNCCIpDn1Zs6lSPbvLe4j1JZRmhxRsvBuntsbQBuqUCX5A+c/qC/FP+zMsKXa3xW9v
 f0zXAp9S
 hooPCaB2Sp9hWB5wQfqa0i9vGVk6FLp2fIpgO8UXGNZeATFmo5jkzqyX0wgxzu5Q6F3w0AHfzbcmjm4umGKADVXMmz3cThoBsz5UHpomaxyrWbkcRGaKtrzanRGttD5JQRXiSLaqgd4N104eaK+wCF6RKqaRyT2RdICTXuJuKFWqi30r+GFR5+crXxoz2AWISWiKChZ0bALlHUS1E1MxIz4WI12U+2Ufyd2Tu+xyG8fBgtMwJAUlkKuIMafC1vAl+paaNw0hfkApEurinkG3cOC6oiLZq2MjX9gcw1fM7ruvIKqKUjIRoFTzoE8c8lI+9gJWGkJLInhk68IUHFzc+U+mRQ1/Ao2JOwEoAn6kNMdS1oPePiORpkmj5qw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 09, 2026 at 11:40:39AM -0700, David Matlack wrote:
> On Tue, Jun 9, 2026 at 10:20 AM Pranjal Shrivastava <praan@google.com> wrote:
> >
> > On Mon, Jun 08, 2026 at 09:56:41PM +0000, David Matlack wrote:
> > > On 2026-06-07 08:37 PM, Pranjal Shrivastava wrote:
> > > > On Fri, May 22, 2026 at 08:24:06PM +0000, David Matlack wrote:
> > > > > Inherit Access Control Services (ACS) flags on all incoming preserved
> > > > > devices (endpoints and upstream bridges) during a Live Update.
> > > > >
> > > > > Inheriting ACS flags avoids changing routing rules while memory
> > > > > transactions are in flight from preserved devices. This is also strictly
> > > > > necessary to ensure that IOMMU group assignments do not change across
> > > > > a Live Update for preserved devices, as changing ACS configurations can
> > > > > split or merge IOMMU groups.
> > > > >
> > > > > Cache the inherited ACS controls established by the previous kernel in
> > > > > struct pci_dev so that ACS controls do not change after a reset
> > > > > (pci_restore_state() calls pci_enable_acs()).
> > > > >
> > > > > To simplify ACS inheritance, reject preserving any devices that require
> > > > > quirks to enable ACS as those quirks would also have to take Live Update
> > > > > into account.
> > > > >
> > > > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > > > ---
> > > > >  drivers/pci/liveupdate.c       | 68 ++++++++++++++++++++++++++++++++++
> > > > >  drivers/pci/liveupdate.h       | 11 ++++++
> > > > >  drivers/pci/pci.c              |  5 +++
> > > > >  drivers/pci/pci.h              |  5 +++
> > > > >  drivers/pci/quirks.c           |  7 ++++
> > > > >  include/linux/pci_liveupdate.h |  6 +++
> > > > >  6 files changed, 102 insertions(+)
> > > > >
> > > >
> > > > [...]
> > > >
> > > > >
> > > > > +void pci_liveupdate_init_acs(struct pci_dev *dev)
> > > > > +{
> > > > > + guard(rwsem_read)(&pci_liveupdate.rwsem);
> > > > > +
> > > > > + if (!dev->acs_cap || !dev->liveupdate.incoming)
> > > > > +         return;
> > > > > +
> > > > > + pci_read_config_word(dev, dev->acs_cap + PCI_ACS_CTRL, &dev->liveupdate.acs_ctrl);
> > > >
> > > > I might be thinking out loud here, but as an attacker, this motivates me
> > > > to somehow hack the EP FW to mis-report the PCI_ACS_CTRL register across
> > > > a liveupdate to fool the incoming kernel. If the FW feeds a 0, it silently
> > > > strips ACS protections.
> > > >
> > > > Should we also serialize ACS state in ser somehow to ensure we aren't
> > > > fooled by something like this?
> > >
> > > What does "EP FW" mean?
> >
> > I was referring to the Endpoint Firmware (basically any SW running on
> > a downstream device)
> >
> > >
> > > Does such an attacker even need Live Update to attack the system? It
> > > seems like such an attacker could route TLPs in whatever malicious way
> > > they want regardless of Live Update.
> > >
> >
> > I agree that compromised PCIe devices are a menace anyway. But I was
> > talking about the potential window opened up by Live Update here,
> > suppose we have Device A & B assigned to 2 different VMs (implying they
> > are in separate IOMMU groups because the switch set ACS_RR = 1).
> >
> > Now, the attacker has an opportunity with Liveupdate, since the devices
> > are already assigned, if *somehow* it flips a bit like ACS_RR, the
> > incoming kernel might see both the devices in the same IOMMU group.
> > Who detects this case and what happens if this happens if the devices
> > are kept assigned to these VMs?
> 
> I suspect that would be caught during the restore of the iommufds to
> which those devices are attached.
> 
> The kernel would attempt to restore each device into a separate domain
> (since that's how they were preserved before the Live Update) but that
> will fail because they are in the same group now. Even if one of the
> devices was not preserved, that will still cause a failure when a user
> tries to start using that device (e.g. to try to attach it to a
> different VM).

Yes, IOMMU would eventually catch-up but what about the DMAs that were
done already? Say to an NVMe disk? We'll have to wipe the entire disk in
such a case? Also, we wouldn't know the offending device..

If such situations aren't a problem, then I guess it's fine.

Thanks,
Praan


