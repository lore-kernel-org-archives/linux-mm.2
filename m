Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5DEB8C531D1
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 22:58:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 327106B008A; Thu, 23 Jul 2026 18:58:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2D7346B008C; Thu, 23 Jul 2026 18:58:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1C7B66B0092; Thu, 23 Jul 2026 18:58:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D0FC46B008A
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 18:58:54 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 50750C01E6
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:58:54 +0000 (UTC)
X-FDA: 85021558188.06.B251698
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 8604920006
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 22:58:52 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=op+0I2r0;
	spf=pass (imf13.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784847532;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zj8yGGu0ZvQspv+dm8spEGL6AmJp5gd8JQ+4SasQ24M=;
	b=nKi35l2hfxjQDgpebAxMoKJe8JDZPMSvPar4H9bV3WJmlnLUTQzZAcK3nyPPDO4Oc/hE3d
	Kqw1TW/WscMf2PzUFH4aTmfR9kO30RnSA5XUbY+VXor64i0OkLVaGVcxZ6+9GEb0sedmdS
	NTmdd9vjjyxveEdB83rhZkstP/ID1iA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=op+0I2r0;
	spf=pass (imf13.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784847532;
	b=vUTZOsDzm05uiOIzocagyEzyy9hv1cwTrMSFuB1pMHJS1+K5pS3FVvy3LQOeSUv0ZDSqIo
	MheqhNNEimEqajHN0JAffshXQAoGZrSkDOf6NNu1800Hca2mQvoYqkaLV2p7Ns9p7d3olN
	u+V4BXvq+bEiYfpS+cMbnpMUuFowtnM=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2cacef7d299so3055ad.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 15:58:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784847531; x=1785452331; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Zj8yGGu0ZvQspv+dm8spEGL6AmJp5gd8JQ+4SasQ24M=;
        b=op+0I2r0UcC9zwoz2t/WAO3OWAhNrSYZPRo+++8hlwqCv1PcKbxdcLLvDlSdA3Jdey
         NCt/Hk0w1M4SITiE2rsdnfEcZmcKOb+Rl8BdmvUFxivNXVEFPz7A4ngg2ODoMOCrKAWv
         FqIwTXdOyiZO/CQGjty/NVQikPIUpOkaa1SKkIiikWVSdZMEOup3Nw9oyDdJdmf5L1VG
         d6N0s0w/rb3KIVkM3TPH9usVJGmOuDgF7sOiI6/SdtH2pzPV+XuAoIexAGELzUkCQlsp
         rLVceykrewI+cVZP5xQpx5M0TFO1XHyF2B4/JClxuF1fj1he4F93jbGtQHIds1Ttzda5
         bF+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784847531; x=1785452331;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Zj8yGGu0ZvQspv+dm8spEGL6AmJp5gd8JQ+4SasQ24M=;
        b=lh/vwilsHFoWi8+kryDPf4JgzHIHiW66s55qA6aYDo8ivG9bNa/rtIb1eAM17IFyQa
         +TIDrfs4eCwR9uOoc2utnT+mTyAHS6wCbI1KwoOL3SsRhs1fnZeA8oD90/OlC1ju5Hmt
         RkrJAnVtGRsZDIitcASozBHT2v/5+hoXA+7LmWawF8Fm8T+H52pT+tumJHTrCVss9taF
         nINEdw3smBT5V7/l2aMCU4P3XQUb9i+f5Fxc4xDkSB21wU7geO8G/PuvG0sdLyALhtiA
         BiQUnbDI8T3amS+r/i9Y1Pn/tCM0fq+RPrW+DyvNfkUHrPS3Br7d4AvQ1lQxrf70tTey
         u+PQ==
X-Forwarded-Encrypted: i=1; AHgh+RoSNXOcuQ1chzNqRf8IkIfkXS0vkDs2T7mcZzQGAG/ixBi40ByhDcIcKCbejuCrviTo3qc3CFm0nQ==@kvack.org
X-Gm-Message-State: AOJu0YzHgPI6NhGzByfzQbOBBFJV8zIRrv4sDL6zJsbsM2Szw0KsFQBI
	+v2dQZEodteRuq8SZQWRjOxBwcTET8cspVJVG/bm1MJbqm58PZHWDZnqpIRvRz7HMA==
X-Gm-Gg: AR+sD10D4+weQFaL4AGNhdmghrHF+i9CyFLY0rqP+eozMcm8HXtO0ZIygsS055QyCLP
	rYqsKMXbqEYo/EukIh75jzahsxspzDmEep8QEAKD+RNgs7j8mfRsgT/GlKsu5nP/5XQhAVKAWn9
	jgifNz0HmZ4vur8qdPCzPcUNAfK9Mc5lnasmGgIZxDWEnN7/kQcrUq/i1EiXmwJtiub97C/16yz
	LjP2d+vnfw5bn+PVbUh5YbqdVEBI/LbRW6BaPwTYKQeu9LMyTdWWoKah2HUwkozxfKzP3aCxEqo
	i4XYj6ApFOS6VUr41XK2/2iHojrZ75fF7bCsrrwugn9tqsWdoxnkLWy1+qeOZnsg6NCB1Mr09JP
	RUlB0vIHMI2z79/I+xIK8bovpFXjQA5JatBICfdZhYvcuGXc5/WyAhL16JKpWta6jcOscpN+ihp
	hchMeeUmoI3C8SNdJ6+MtChybGWsVTsPv3SKhhtpY=
X-Received: by 2002:a17:902:d4c6:b0:2c9:a222:47e0 with SMTP id d9443c01a7336-2cfc049d8efmr1917685ad.20.1784847530903;
        Thu, 23 Jul 2026 15:58:50 -0700 (PDT)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-84e17236924sm3686474b3a.7.2026.07.23.15.58.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Jul 2026 15:58:50 -0700 (PDT)
Date: Thu, 23 Jul 2026 15:58:45 -0700
From: Vipin Sharma <vipinsh@google.com>
To: alex@shazbot.org, rppt@kernel.org, pasha.tatashin@soleen.com, 
	pratyush@kernel.org
Cc: ajayachandra@nvidia.com, amastro@fb.com, ankita@nvidia.com, 
	apopple@nvidia.com, bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, 
	corbet@lwn.net, dmatlack@google.com, graf@amazon.com, 
	jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, jrhilke@google.com, 
	julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, leon@kernel.org, 
	leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, michal.winiarski@intel.com, 
	parav@nvidia.com, praan@google.com, rananta@google.com, rientjes@google.com, 
	rodrigo.vivi@intel.com, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com, kexec@lists.infradead.org, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, kvm@vger.kernel.org, 
	linux-mm@kvack.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v5 00/20] vfio/pci: Base Live Update support for VFIO
Message-ID: <20260723215749.GC260824.vipinsh@google.com>
References: <20260714151505.3466855-1-vipinsh@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260714151505.3466855-1-vipinsh@google.com>
X-Rspamd-Queue-Id: 8604920006
X-Rspam-User: 
X-Stat-Signature: j496395xyknyn7zffse9tq8a79edyidt
X-Rspamd-Server: rspam04
X-HE-Tag: 1784847532-389262
X-HE-Meta: U2FsdGVkX1/i/k+JdHrnF7EHiddY0iq4hjXVzFwqBHGfl6b23VkHyo+Yyc/eB3xNLqx0c282/gQ4XXHB8vMDdUkeg0PWAfKULB/iE0ITHHYhZ8DTOZ3uDAP1vSiYLmUkuNZp5nhno8Q7X2DkP14rIYEiIXVokbX3mOFAgvljEkGX8tDXypcwG3wdAs2frFQaBiSGTnQapP02dQxI7gPWeDEROwTLkkNTrIFqIR9mhh1uwvWNJyMJ63Ohk/4Iko5mkqEihSQtafIH2XXuNMcYj/Sq1hrd9rnJpMVahUe3Zs8xJE5+eauNCZvq4YvJmVNpwdsLHRHWoTeuDpIdMHzENVOGGJZT7nraFohY/OJ3uxgIWfQ/WbZzvchWNS8nkZeOLMPBsixE82r17g+Rto2tW+TkKWJ9KzNNznubYeo3gk5yKbylQYWItbsObRKVk2g5S50VD2jyY45RITOy++BNzd/xdUjFwVo/uDPeVYQNxM8RHXUpXUKp8lJY4y+9U9pf4nT51K5gRec2QlAny43loPDw8hd6QO9yecpzq0pqB4UhF1/KvacP+by3qFZ+jtLDhRoRjgboSM2bgh11cCfFk/tD5kiW34C63m8jDYmt0uSqkg51dSvWc/lI0AQpiqnkk4QfErtBxL/zEKZE2IHub33UMYTcsVx3y3eY2w1tGFM/waYTeMmddXX8XVx6iIGIf32y0GgfcNKsmR928/0Qw549rnDkmk9EjOsAxpX+2G81AqWEoT+b9VcS7vxwSehzPCzP8H9V0Bu9QmqTEegCK/FXC70KGt5288jTPkF/DDz3aW+br4cY15Kpiu4MOf9DGJf1JqBiOCn15sJbo2mspbVoy0nCxzP5xsU+++rU9AXsiehnMJFhI/CvJ8jZRAlNN8J7WJqIhYi/BWmhitUeEFsZGGtzi/FO6pR4FcaPfHRBptUqrn06Z0C+9lEo13pYHvHwmuyF+aZMwJRxGwX
 d82SB8P4
 w+idNYFZPu8ioiKrdVvhgKk+fwyl32fVU5Mu3TNhbgSlyq/sPycIOftXJQ9lspLsW1TPPYulKKS9TrfOnx/o5AvakeefE8kU2AYULY8LEcq15a3ImT/gHifebq+VZjAteYNcHmdXI3A3dC2c6N7O4QvKR6A+kKqfhSGBB3XWuErKGfyevLbYPIXQNhn4pjMfhvK2pGzAeKPeZdRw5nKiQgv0RqWEblhDNk2nqq+jzhjhRMpdTrjeYmjKHVSIwCkFY3Mqt+EmtOC6NqwGllY6huKvdN+UR2CnEH7eeXGJBQdaccacGYR16mh4qxhw3eLO997Q+T3DH6Ig95v9mhIYmCzMviZ3nxU1hnUKr+bTB7CCrfcS18PzsFlHXttql21CFUiC11+TZmKzMKyU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 08:14:45AM -0700, Vipin Sharma wrote:
> Hello,
> 
> This series can be found on Github:
> 
>   https://github.com/shvipin/linux vfio/liveupdate/v5
> 
> This series provides the base support to enable Live Update feature for
> VFIO PCI devices using the Live Update Orchestrator (LUO) and Kexec
> Handover (KHO).
> 

Hi Alex, Pasha, Mike, and Pratyush,

I'd like to discuss which maintainer tree should take the VFIO Live
Update series.

For context on related efforts:

  - PCI Live Update is targeting the Live Update tree (maintained by
    Pasha, Mike, and Pratyush, with David Matlack maintaining the
    PCI-specific code).
    https://lore.kernel.org/linux-pci/20260710212616.1351130-2-dmatlack@google.com/

  - IOMMU Live Update is planned to go through the IOMMU tree.
    https://lore.kernel.org/linux-iommu/20260614233728.2212104-3-skhawaja@google.com/

Given these different approaches, what is your preference for routing
the VFIO Live Update code?

Thanks
Vipin Sharma


