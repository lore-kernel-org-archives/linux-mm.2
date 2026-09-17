Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1821FC982D7
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 23:38:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F0A896B008A; Thu, 17 Sep 2026 19:38:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EBB476B0092; Thu, 17 Sep 2026 19:38:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DAA386B0093; Thu, 17 Sep 2026 19:38:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B5A106B008A
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 19:38:40 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 51F5E1A04AA
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:38:40 +0000 (UTC)
X-FDA: 85224871200.02.2499FE9
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf12.hostedemail.com (Postfix) with ESMTP id 6BF2440003
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 23:38:38 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t0E8sJK9;
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789688318;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7fnbLCpb26KXPMnHq1G3sv+CyiTND7rvG+kHXBaTg0g=;
	b=codH14RxvTxddoWjIco2QXM3gUbyeXD7zlQGgqg4mW8wnzv2XIA6qX2+q2MVhvUOMjlib+
	70DHL4KdOpq5axZcuc1S8ab2akgZrq67uMXq3IJTpmxifsU1AMpooHG5zAHL5vnyJs6Z3y
	krJhDrpQklsWgNpsviaGVMS28QotJWE=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=t0E8sJK9;
	spf=pass (imf12.hostedemail.com: domain of dmatlack@google.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789688318;
	b=zQuRAhf8T3nt1scx0CuTQh+i6n+R5PGrpH8VI0j9WR8wDZBeDkKTIbNRPdjLNnNea5cIs7
	PFsEO268jz7B4dXcBaqVkWrTeBvpGjPDGoQFmehWM5+xO+BFgwMS7vnVmeBsFj3b1ru1GR
	4yF1T5qPI7sRYVkLxeT1Dxd6osJ/lNY=
Received: by mail-pj2-f12.google.com with SMTP id d9443c01a7336-2d8fdc579daso1742695ad.1
        for <linux-mm@kvack.org>; Thu, 17 Sep 2026 16:38:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789688317; x=1790293117; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7fnbLCpb26KXPMnHq1G3sv+CyiTND7rvG+kHXBaTg0g=;
        b=t0E8sJK9VoQm/nXeC2SLV0D+EifweFoWADWnb+TAt49Yi9q04PONFds7S74xw5WDr9
         RghbRVBcfookyfIaY68wiHg3WJoxJrzd5121P+nxxHpGuEOyjBU+8yOPG6oI1LYo4lVk
         6MV3wHiKlp2pbxVPnS7BhRsUX09omPYfdqanlu/lK9RDluF/DRPbom4vXRgy1R6Z6qCt
         VcG0WlV+7KX3H9BoriZZUiJBAC0PUzLrhaAcjttThlXb7vWo70leWbZDpNmn+8zDf4hT
         Tv26HdQrVEjLlXouyFiHH7LvLRu0Q12qJ2qO9EGGFVG4EuqCPU4FrwGKdhrdN4Z5Sqxk
         oevA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789688317; x=1790293117;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7fnbLCpb26KXPMnHq1G3sv+CyiTND7rvG+kHXBaTg0g=;
        b=dwjfUZNUGXRy3Uz4xQ4Tr8X76DhfR/vhh+lRC26ha5eCZT+y0ypRRWb8AMpaITqFHR
         Gu8S8pIWNQr70fDvtoNpDe273SwD64wUjelINPUg9PJq5QK5EXOCWXNOSpPCjdev8+zx
         QNaITz3BZiOOU9YRwK7fC3Ra1X2P75jvUTpDroQIwFW2pBCEph/+2Q3VsDrnZvUkLQ7w
         IfvEf6MDgHGqo6a1i6IyFuDm2qTPh1Yre6JFMsoBxwS3VQvdGeln5GHrTyz1kEaG2nGf
         lvxnclDSnKqS6zFJbKNW6q0mKXwbhWQkcVQAsgkbcg0o06BWWnVuS1VQef5Qt7JkWKsn
         Pjmg==
X-Forwarded-Encrypted: i=1; AKwUvBwxsf3mDmXOwdA+8ecSCdQ/KnfBneM41UPAauvO+e7Cda143QmPa1/oaovN9eH2G2df9ky7uUu7uw==@kvack.org
X-Gm-Message-State: AFuF++nxlBCNNrsYow74qL14aRuFgU8BI0SOHcUWNRpgB+AL4KYs6r37
	Fk9ZIVaxqzmm9zpMBTTBgg7GuvteT7DdlwAPdrCDeAw/X8qQwwR0kiU5hvGAmQG2lw==
X-Gm-Gg: AYBFou0ZtYZG49gjyqXEFpLhnDHcYHrXRobv1n7Ab+9oRXa0N/NlTE0ek80HzgzV+ie
	mFljYNe6W2f/cNjqmV3PFLMgDwWmqr+FPtSPkY2ggSg6HC0Z/j12G3lIDbGjRK7hW0TXIiysxmM
	vHkWhoYvus0MbnXc9BAPeNXXOCsFmQxPCgwWJstLwOtuKDiDE/lhiQX+RxTpz34F/Nc6gBZLCrG
	MEdIRLHMC6helLKIsVPgHxu3PzOO06Wtl1zpk/GhTav2LhWoXiLMJu87DaiMc5GY7KZ5TYnv3m3
	50Vslmo9bofhiHlCZVcIRfKgtUwJC/S+u0H611VIjlzVW2l2irxHzSK1ruR04me2itJDB0gPrY7
	Dt/bTr/vDE3cHiYnbz16QWdEKJkA1zrGPKHCUDI9gyTLNctrtvTM+x+agw1pFduAr19KDGTV1yq
	rlGetG2NVC71WVBlB8fk70xZ7eFH23wH2S+TIWmMzc7t/4KkDRaxj+xK5w/c/S0wtGPLiGGQ4v6
	oJcW7oLdWrH0orw6oXx0FkdRKBJmlscooO+Ur7ofRnSeg1A+yM=
X-Received: by 2002:a17:902:c944:b0:2d6:ffa1:429b with SMTP id d9443c01a7336-2ddb1adf381mr15539635ad.7.1789688316616;
        Thu, 17 Sep 2026 16:38:36 -0700 (PDT)
Received: from google.com (132.200.185.35.bc.googleusercontent.com. [35.185.200.132])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2dd89e96cccsm32897375ad.22.2026.09.17.16.38.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Sep 2026 16:38:35 -0700 (PDT)
Date: Thu, 17 Sep 2026 23:38:32 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
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
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>,
	Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 10/12] PCI: liveupdate: Freeze preservation status
 during shutdown
Message-ID: <aqx5-KH_GcSvsvqs@google.com>
References: <20260728221007.2098560-11-dmatlack@google.com>
 <20260917201737.GA1047708@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260917201737.GA1047708@bhelgaas>
X-Rspam-User: 
X-Stat-Signature: 4gtnydtz44xcpdfmgmzyoqpk61jbrmh8
X-Rspamd-Queue-Id: 6BF2440003
X-Rspamd-Server: rspam07
X-HE-Tag: 1789688318-50023
X-HE-Meta: U2FsdGVkX1/xHG02Td5eKSRw0U7ZeTdJABH3aUVC6Mx55OdxgLa+blcGb+193dZz6D/m3upqgiP0hzW4V21jeOGkX4itOOXJASvWgNCtOWL514kF4at8yEqte3JR4SnMqgfBaCYVaHjVCSqbcqS60K2eLXiU+egL3EOBcQ3F5PBxtqF7416voRkxYAL76uqzLdqgHAqzjVqzX6pZx9FcdkrBRtYp4aGz9WV3jeHRM0QsIg84ukXslezrKBVmcUoH+UaQ1bNBiQex/BukvVBosSapvywYAJqzU0sXx4lVG1g0dFMttYR8E/qVF7B6oiTgEm11BEpg2LejFcSGZajysy6JW5IIGdmgldNUgVmFibiQum0q5kc79EEHrsiAE+ThvLbaqx78M798zBR8QeBsQU2/rbFX7IsBlBWQJsQq22zEo1Ssh5NvXjSv57ZoZ1Dm4y1dlg+fsekMJy//Iii6yM8FZCnAF3MT5fwG7o9GIAXhvkleli3i1C6/X3SOWyNTwNHJbL4TIg8FceJ3U2r5crGAHmB4pTCn9ZGEPhNLCUgUjIS/KWVUPPd1S7gQK/SNsZRfzOY9dvMO4dp1sCRvmjTbAKvOzKsXD9k6Eqq6WESJvTQSQpA0kJqnXhULhnilpJd6Q5avcpG2dSZgoKGIDZoGnUpFp6GTJ7zedgKaZWKpKVFoTxAUCjMnqqoAIL8O5LAY0Vm/XkT/By/Rj/N1Swzay8OxTO4zF8qnfsWJFIPeTxB9SKFR4yIz9YPYKMUI56njP2eRwIQJSapTORlhU20XRZ8LdfytqXEzYgcrS7s+ppmpcz8o2HEuUN6ZeUl9pm9UJw0zDep20vlNrMn+6qz21oCGQQV2Kup4Sn25SasyqnYm9YYbvGv5wQlC1LG+uZzhddeRFX8/jbVRv6k4yF4b60OhyCEScdxRt5YypFTQkM4Qef8d0GscvbGCVb0hcHmCJpCoUuTcTgjfLuO
 Sk4r2jtX
 vFeqcFnXZXfqdPz2X/KBQsAx0V/m8cR0bAyQEp4mK/OMnNZG9aAmRzcYPmVj2iOxtnlwEPLjoug78G1uow+Cg2SEk9tydz6Yl+Fu1By0JAMaBWaxjwmc9ZZ76hAvAGNlzybJ/wqmYwqmJKVwV5x0OITG2HMT1+KG2Yw5CXVnrIvjZrCS9BKTjiCZVUR6WhLOZbzyJCHYnvpCzAYWnegqf6TtDhRbZzgoKbV0lV0rnRYC8OHyvrO4Y5qFKnhQ5om+xhC4+vvehmcCzVQOtzL5ntXjxCpFPA0gCi5Et+jvBmJ7jJRMLNuDCUNmI3Y0FjEQHXzBNdsGaefmbHIaVTyj8UdOS8bnfUcTpoUom2U2IkM0KGCcoJmPRYSwAslGmqc2K/tgE/lNcOjREnfLCLlEDyQTNfQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-17 03:17 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:10:04PM +0000, David Matlack wrote:
> > Freeze a device's outgoing preservation status (preserved or not
> > preserved) during shutdown. This enables the PCI core and drivers to
> > safely make decisions based on the device's preservation status during
> > shutdown.
> > 
> > Note that pci_liveupdate_freeze() is triggered by the PCI core rather
> > than from drivers participating in Live Update so that all devices can
> > have their status frozen (i.e. prevent non-preserved devices from
> > getting preserved late).
> 
> This calls pci_liveupdate_freeze() from pci_device_shutdown(), the
> pci_bus_type .shutdown() method, which I think is only called from
> device_shutdown() in the kexec or restart paths.
> 
> Since there's no error exit after we get as far as device_shutdown(),
> and this applies to all devices and dev->liveupdate.frozen is never
> set to false (at least at this point in the series), is there benefit
> to tracking this per-device?

I think this could be global. But I don't see any obvious place to add
that hook and keeping it per device is one less global variable to
worry about.

> > Reviewed-by: Pranjal Shrivastava <praan@google.com>
> > Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
> > Signed-off-by: David Matlack <dmatlack@google.com>
> 
> Reviewed-by: Bjorn Helgaas <bhelgaas@google.com>
> 
> > ---
> >  drivers/pci/liveupdate.c       | 16 ++++++++++++++++
> >  drivers/pci/liveupdate.h       |  4 ++++
> >  drivers/pci/pci-driver.c       |  2 ++
> >  include/linux/pci_liveupdate.h |  3 +++
> >  4 files changed, 25 insertions(+)
> > 
> > diff --git a/drivers/pci/liveupdate.c b/drivers/pci/liveupdate.c
> > index 744513ee11ed..65bcecb1b64e 100644
> > --- a/drivers/pci/liveupdate.c
> > +++ b/drivers/pci/liveupdate.c
> > @@ -394,6 +394,11 @@ static int pci_liveupdate_unpreserve_device(struct pci_flb_outgoing *outgoing,
> >  {
> >  	struct pci_dev_ser *dev_ser = dev->liveupdate.outgoing;
> >  
> > +	if (dev->liveupdate.frozen) {
> > +		pci_warn(dev, "Cannot unpreserve device after it is frozen!\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (!dev_ser) {
> >  		pci_warn(dev, "Cannot unpreserve device that is not preserved\n");
> >  		return -EINVAL;
> > @@ -447,6 +452,11 @@ static int pci_liveupdate_preserve_device(struct pci_flb_outgoing *outgoing,
> >  		return -EINVAL;
> >  	}
> >  
> > +	if (dev->liveupdate.frozen) {
> > +		pci_warn(dev, "Cannot preserve device after it is frozen!\n");
> > +		return -EINVAL;
> > +	}
> > +
> >  	if (dev->liveupdate.outgoing) {
> >  		if (!dev->liveupdate.outgoing->refcount) {
> >  			pci_WARN(dev, 1, "Preserved device with 0 refcount!\n");
> > @@ -718,6 +728,12 @@ void pci_liveupdate_cleanup_device(struct pci_dev *dev)
> >  		pci_WARN(dev, 1, "Destroying incoming-preserved device!\n");
> >  }
> >  
> > +void pci_liveupdate_freeze(struct pci_dev *dev)
> > +{
> > +	guard(rwsem_write)(&pci_liveupdate.rwsem);
> > +	dev->liveupdate.frozen = 1;
> 
> Nit, the series assigns "true" to other booleans
> (preserve_bus_numbers, was_preserved).

Ack, will fix.

