Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 34E69CD98C5
	for <linux-mm@archiver.kernel.org>; Sun, 14 Jun 2026 14:01:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73FD36B008A; Sun, 14 Jun 2026 10:01:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CA1F6B008C; Sun, 14 Jun 2026 10:01:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 56AD56B0092; Sun, 14 Jun 2026 10:01:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4168D6B008A
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 10:01:13 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id DBAD290F96
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 14:01:12 +0000 (UTC)
X-FDA: 84878679984.17.BB06523
Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	by imf17.hostedemail.com (Postfix) with ESMTP id BA7184000E
	for <linux-mm@kvack.org>; Sun, 14 Jun 2026 14:01:10 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NEKhsFrd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781445670;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fF8u6DKkckQuJavK70W0G+qrxbgEHWN1DTuCSFFIGv8=;
	b=2BEWsS8/1X1UM9vUEJD5sRBfjSaZ0yYN/NwYkQmSa4eZKRSayG3BwTU1A26E8xuw1xLosF
	fvDRLzxF3p8i9QTnOw5CJTfEgAqlm2JtaOOMuIgdJEu3Xbenn7OqMqkUzqrWKb9vtKdD7g
	ZCXgFf6z0GSnBlkjEPsgda9iG8pq7J0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=NEKhsFrd;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf17.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.174 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781445670;
	b=v8nU0jCrGqF8G0PAJK2N5MtwaGsKQ+TOXGVne1x0lsU8KeB+8WI9Pnj1tWpcz1fAi1Aha5
	WfUatFJ7tRevNROVGn5CHsabrztGDviYBTAl5Spp6a0a0I+9naWDn/7dJ7FG6p/QOKLlcW
	wyB5BRRXtsfs1ifC4xUaXlBt/7YTrW4=
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-9158fbaa4bbso290955385a.1
        for <linux-mm@kvack.org>; Sun, 14 Jun 2026 07:01:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1781445670; x=1782050470; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fF8u6DKkckQuJavK70W0G+qrxbgEHWN1DTuCSFFIGv8=;
        b=NEKhsFrdQrn2eUZ2S7UY9eCjVgcNStPmkzuWO7YqqSC4zRrkSPI9IdMEjprqJlju1t
         UY9Gx2///C+Jsdz8zR4mOdX9p3IU9nwmQOklosxMnEm3aCd9OpDPlNqHJLFBBXLQ38yX
         +KltKkc1JXlkvpA+qka3cFfZF6V1YzSX2liVsMBTkcXguMO8IDS0j+/CBHffjbwZgpiK
         tvG05t5qKaE5P6qztk+G5YJ0uuRLwn0W3xIDtU+6BiIsUoE0cZZs+T+sdFXY6ALjxMVU
         g4XwCcx9dOKOH78mk+d4aHZMhjU763NR/CC8uZj/ILQoJ1TRR1cqc1J/MY3CQQ4OWGC0
         FspQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781445670; x=1782050470;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:mime-version:x-gm-gg:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fF8u6DKkckQuJavK70W0G+qrxbgEHWN1DTuCSFFIGv8=;
        b=KlNFWX4n8q77IN3mMoWOTjL3208yzjKeASzl3JzrZUGBGX0+b1wb2sy3rjHD2jnFTi
         TBEvO2kbFFBc6mfa7PGm4T60bQtB2TZSuLfye0eu1H1vCMRCKcs096+8UbRmvoabDA1l
         /cCPw34oju5eTGZMw1fqILRTMsoDGPP7JjarXPTpMGVNpOEbIebkuP7I8RoTmgmou+/+
         4UlZHv0z1qdnQFUALFJtAYSWXUiZdr8HpKluX/ZSLM3CIe/VZJIz9g0o/6QoOeV0+Vtg
         B5xFLrNhmmAiiJw9icSrabRUwUctLX5tPoFXol3hYsFvC3E4NsNGCsClzIIOWJF6b9+i
         5tJg==
X-Forwarded-Encrypted: i=1; AFNElJ9nhLcDrUHMoqPEO/sKxcj6y0CYs+JeKe44uow9sv+nRXmYsyTtG8Bg5vIRS0EOIsAuJktJjMPn7A==@kvack.org
X-Gm-Message-State: AOJu0YzREfEF8pRMlsvK4qpRVDTDnDnWhO2sl/w+BHWi/fCUEGeYoRcK
	rPKqicVdR2JdWOE5rHUEndLAVcabojkrSS7Xrv+zfT6slKSFViKxht0vF99tb+nc99Q=
X-Gm-Gg: Acq92OGJ49a7ChtA26xZVh5UvivNlJSjAu2r3pcS+AJPz3AIdTXxBB6Qul1qVDYGLuA
	3sOb2e+L0NUZXs2bI1PZ71ZyZXwM+8Rvd+rSsiSZYcq0emXM7MWCd572KOcMiQnfWxK4/Defxdh
	6JmYfHMmy66EngsFntyBYWWIwotp4f33uHnEsccjmixYgC+OW5DMmi5+TOkm9/5gV+8TtUhY4V0
	xNgiQQ3+OFIg4NNRBbzKg7eQbo21JWl+h6aXQead320qeBLcY+uIAiJU9xRcJ9VATVlkVzlwGW8
	o1cBkA3Aj3t42k+EsWHPr9TbZOLhNGVQ3PEussJtjapcRUznc0CL0nO6y0Kbknw148lJ7wfoQli
	48mLNnrNY4WbGAd3jdokBy0JBg8o9DrgI9zW+wfeAqswIqr6bm7rj0K0h8o/GbIybAPHTKkDa4k
	O/rg3a1toLaqKPnzK6tGKHWJ2u+9i4AvAp8rSXvgh1/o+/U/76iOtEGRQOUizLfvw6ZNJKhjw=
X-Received: by 2002:a05:620a:3705:b0:914:ac45:a98 with SMTP id af79cd13be357-9161bb03ad9mr1608583285a.17.1781445669356;
        Sun, 14 Jun 2026 07:01:09 -0700 (PDT)
Received: from [127.0.1.1] ([71.181.43.54])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-91619f05fe7sm806892185a.12.2026.06.14.07.01.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Jun 2026 07:01:08 -0700 (PDT)
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v6 05/12] PCI: liveupdate: Keep bus numbers constant
 during Live Update
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: Pranjal Shrivastava <praan@google.com>
Cc: David Matlack <dmatlack@google.com>, kexec@lists.infradead.org, 
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-pci@vger.kernel.org, Adithya Jayachandran <ajayachandra@nvidia.com>, 
 Alexander Graf <graf@amazon.com>, Alex Williamson <alex@shazbot.org>, 
 Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>, 
 David Rientjes <rientjes@google.com>, 
 Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
 Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, 
 Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Saeed Mahameed <saeedm@nvidia.com>, 
 Samiullah Khawaja <skhawaja@google.com>, 
 Shuah Khan <skhan@linuxfoundation.org>, Vipin Sharma <vipinsh@google.com>, 
 William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
In-Reply-To: <aiQAJRINEKiwCmVm@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-6-dmatlack@google.com>
 <aiQAJRINEKiwCmVm@google.com>
Date: Sun, 14 Jun 2026 14:01:06 +0000
Message-Id: <178144566685.1266136.10385355007970146916.b4-reply@b4>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=openpgp-sha256; l=4053;
 i=pasha.tatashin@soleen.com; h=from:subject:message-id;
 bh=0/f3k6YhFFNYqylgqcMG4vpeDMtx34OA88JRI3jDl7g=;
 b=owEBbQKS/ZANAwAKAbt3KEzbc3reAcsmYgBqLrQjWixclC4MmfNpLIwWFqBCFzofhX0Jr8QQJ
 bpVL95JpeyJAjMEAAEKAB0WIQRBMaqT7LRvGvB/NmK7dyhM23N63gUCai60IwAKCRC7dyhM23N6
 3kUaEACol4WdgDqN/9YA64JobY3TtWyKckwy4VgKxaRGy/1HiRGiXX5khGnvPxf/QUt2GqkrOAD
 9bfcRjR/HmwRhjEO8hkWUhHd5uwowgrsW2sn3Y0fs3qD3jwY1OCZ9WdrkMReE8b3B3ii5wzbOQd
 +dlUHARMl3hjaiT9TSaHtHOkmSDKHM1UKPlzTWRDrCmh6+LnpuOakhfPOKFldJYDgw/YIBKmZQG
 +YIWAWmBPRFGkUgCD9FoglbeuyIym39QFmBpPde0isIetl86PwQReKOb5H2Zi+aD+mm4ine49jq
 KLbeKAxjqxMj1cXWKk84Xe40fr4H4wkU4vsfGH/eGK1o3wiQVoBbu2TPp1LCeB9N0cNWCVE9DH0
 7EizDfLEBK/1DKZaUprLyucUu/eA2S/S254GS3Jn5LDRzlNOj1al3yHR68VyCLeMWcZA/VgxYI5
 dqQYd/bN6gOvwDlFB/xexPatXErOhIo0iGC1i84tXL4C1OQEi9uIY1CtDZ+Ztv0pgUNlVOhFyGb
 kqDZniluCNmnn8OGPvNMZz+sCPJtmqQBEATH2Hv8dlOdlb4s8lSUeGD1aBMvKPKB5Bh0hAczvNh
 Sj5W6biG4ZUAj1L8BivCr0gTvsEJ2WSr9VMRTzsZ+0+dMV96HGvU4RyHQY7IY0Mx6kLObjr8TRS
 KOqR+oScoluku5w==
X-Developer-Key: i=pasha.tatashin@soleen.com; a=openpgp;
 fpr=CAAAB722DD22A081F0D49F35633A6A993D43B569
X-Rspamd-Queue-Id: BA7184000E
X-Rspam-User: 
X-Stat-Signature: 9daoaqd5ccjsjdhrrgf8th1nckq3e48z
X-Rspamd-Server: rspam09
X-HE-Tag: 1781445670-675382
X-HE-Meta: U2FsdGVkX1/IF6em7iXAn+L9hBOCrS9gKYuf0a53/D8t+eI+vJpGK9RchGbUorlIEev1pJTdI9xWcUsIaU1HergzHe23XxJ+G27Y6SWxfPAzgbdzMvTeQCG22/XSh8rJhq3SLnHEclh3wxV0qLUC75Az6hlO+V3s8OdyVRGpW6FGYl9I4gSVtvVIy23ngWxMYPi7TgCV4UfTmGTj4r3bxHwB/gXZ20YkbmnGI0VZU7+ETNvMomK9myhBRSt5E8U941ddw+uSgftNbBTSS+J0XbaFm0OuHRkleH3G6C4b0R3TO8MBIhmXa2ow1gfy4FFJgWDJwunmSIJWh9sRJHmEhww8GeEawkz7qZ3WyW60i4RGgMX2QSsl20K1stNsuyalrI4xT/6Qv3LFWsWLg3fuWKLVhSOrtwtODbmG3w0pao63Ja/r9nJOTWEWlf3wgeEegof+8kJJ/4v6SFCAXPvOlBUUmm2sezQn41dcxSarHqVAEbz/uIhnqcTePaXwisKKjA/nFdWUa2mkLxT5MjXxe6zzbwVempsxCJu1rDleOChJumkU80l7rPsbrX2Lv1eu07mciXpo3Qd1ETNXT4MGA7poizsuUvCv2XnLw4F2SCcfFI5cHSB+ML77VKO/Fm47s9AzN29nQ8QE2PhngJfFZutGbAwLPNfxvpJ+oH2r3V43zaK8ehRI28AVv7iFHQfgN5Zaj5a+rowtEflJWet1kKMnnmobGzTTDG9j8oqrWga5QoaZ6ZasB0ySaHlGs6u8mMg4VjkRsfTknmnOHiEhnvQFIgVMqPZZsTRuENMnph0ShNQJAWMrmwcpgwIKobW+55q6R1NGDz8qVc6zm8GkxSj/b2BePvRc8O0T3cxDxOS9+LhA7K6+Mgcqe6teuUSUEjKnpjEBKaFa72ter6ZnSZ7txPYxB8CvhGtWWqluh6iJ+jD1kmOaSAx6tzvMrl8KzH8gzd8LY2svh8LIGEY
 aTx0bnvL
 PG79ffNRvnYpvM7/CH1HTG5jE3RAuaaWf8XNvzkBgWSoZPTuKg3tQXXYpz8gTpq5PH5V+biphKx53Ca0HDAsBATGp3LPWX+XyqbPueVpyJIN/oFzS51TMfbdaR2SnwKZ6Sw4bs9AiIP9cy6G+fNsDqHxKPlDr9h/295WkAu7uaa6uWObhSbibfnE7jgeTyEAoGXo42jJw3sta61XE1pVRAlfUdP1JLyDFhE2npo1KR/iqeKsLxCr+QFRwzuEsGlZEBkhmAXpZ7Hyqm9Cti67W4Ts0+rz6Nj3BlQIQ6irWXp0zzX0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-06 11:10:29+00:00, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:03PM +0000, David Matlack wrote:
> 
> > During a Live Update, preserved devices must be allowed to continue
> > performing memory transactions so the kernel cannot change the fabric
> > topology, including bus numbers, since that would require disabling
> > and flushing any memory transactions first.
> > 
> > To keep bus numbers constant, always inherit the secondary and
> > subordinate bus numbers assigned to bridges during scanning, instead of
> > assigning new ones, if any PCI devices are being preserved. Note that
> > the kernel inherits bus numbers even on bridges without any downstream
> > endpoints that were preserved. This avoids accidentally assigning a
> > bridge a new window that overlaps with a preserved device that is
> > downstream of a different bridge.
> > 
> > If a bridge is scanned with a broken topology or has no bus numbers
> > set during a Live Update, refuse to assign it new bus numbers and refuse
> > to enumerate devices below it until the Live Update is finished. This is
> > a safety measure to prevent topology conflicts.
> > 
> > Require that CONFIG_CARDBUS is not enabled to enable
> > CONFIG_PCI_LIVEUPDATE since inheriting bus numbers on PCI-to-CardBus
> > bridges requires additional work but is not a priority at the moment.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  .../admin-guide/kernel-parameters.txt         |  6 +-
> >  drivers/pci/Kconfig                           |  2 +-
> >  drivers/pci/liveupdate.c                      | 83 ++++++++++++++++++-
> >  drivers/pci/liveupdate.h                      | 14 ++++
> >  drivers/pci/probe.c                           | 17 +++-
> >  include/linux/pci_liveupdate.h                |  4 +
> >  6 files changed, 119 insertions(+), 7 deletions(-)
> 
> [...]
> 
> > +		incoming = pci_liveupdate_flb_get_incoming();
> > +		if (!incoming) {
> > +			dev->liveupdate.inherit_buses = false;
> > +			goto out;
> > +		}
> > +
> > +		/*
> > +		 * It is safe to sample incoming->ser->nr_devices and then
> > +		 * drop the rwsem since nr_devices will only decrease. Thus the
> > +		 * only "race" is that the current scan will be overly
> > +		 * conservative and force bus inheritance.
> > +		 */
> > +		dev->liveupdate.inherit_buses = incoming->ser->nr_devices;
> 
> Nit: inherit_buses is a bool, while compiler will handle it correctly,
> maybe we could:
> 
> dev->liveupdate.inherit_buses = !!incoming->ser->nr_devices 

+1

> 
> OR
> 
> dev->liveupdate.inherit_buses = (incoming->ser->nr_devices > 0)
> 
> for readability?
> 
> > +		pci_liveupdate_flb_put_incoming();
> > +	}
> > +
> > +out:
> > +	return dev->liveupdate.inherit_buses;
> > +}
> > +
> 
> [...]
> 
> >  		/*
> > @@ -1497,8 +1501,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
> >  		 * do in the second pass.
> >  		 */
> >  		if (!pass) {
> > -			if (pcibios_assign_all_busses() || broken)
> > -
> > +			if (assign_new_buses || broken)
> >  				/*
> >  				 * Temporarily disable forwarding of the
> >  				 * configuration cycles on all bridges in
> > @@ -1512,6 +1515,11 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
> >  			goto out;
> >  		}
> >  
> > +		if (liveupdate) {
> > +			pci_err(dev, "Cannot reconfigure bridge during Live Update, skipping\n");
> > +			goto out;
> > +		}
> 
> Quite helpful! Thanks :)
> 
> > +
> >  		/* Clear errors */
> >  		pci_write_config_word(dev, PCI_STATUS, 0xffff);
> >  
> > @@ -1572,6 +1580,7 @@ static int pci_scan_bridge_extend(struct pci_bus *bus, struct pci_dev *dev,
> >  	pci_write_config_word(dev, PCI_BRIDGE_CONTROL, bctl);
> >  
> >  	pm_runtime_put(&dev->dev);
> > +	pci_liveupdate_scan_bridge_end(dev, pass);
> >  
> >  	return max;
> >  }
> 
> With the minor nit above,
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> 
> Thanks,
> Praan



