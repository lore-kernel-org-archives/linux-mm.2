Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6722D73E87
	for <linux-mm@archiver.kernel.org>; Thu, 29 Jan 2026 22:33:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCBC16B00A7; Thu, 29 Jan 2026 17:33:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D7EB76B00A8; Thu, 29 Jan 2026 17:33:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C23AC6B00A9; Thu, 29 Jan 2026 17:33:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B04016B00A7
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 17:33:23 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 85FB71A0323
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:33:23 +0000 (UTC)
X-FDA: 84386453886.09.E25C1FC
Received: from mail-pf1-f182.google.com (mail-pf1-f182.google.com [209.85.210.182])
	by imf11.hostedemail.com (Postfix) with ESMTP id 983A14000C
	for <linux-mm@kvack.org>; Thu, 29 Jan 2026 22:33:21 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WZpqvLXw;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769726001;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dBZ3PFz9KqTT7KdM5e4cMtXwD446xZIZixlzxugjwak=;
	b=GBXRXbaXpaySAb6cPY/Kt8tOlCf1SMRcSuto++VHNY7TP+CqhiYX9JV6V3o6LtXCyzK2wj
	CxT7yb7IylYjOMANmkfF5UMuhnsdmgSJFsFyERdzfOTAYNqYnWxdidS9KsB6ojFjnyLik7
	mRQ+g8AIuGeXbegjtDkU51rmSz+voiI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769726001; a=rsa-sha256;
	cv=none;
	b=w0OP6M3GR8f1bcoDrVfsjK6YHuaCmhCw3DY35LKvsyU6r4CVckEsMZ4Li+H+ezMgGRDmir
	jA+VhlzU0pjVpA/M73rr7Ug47lQKZXTVI2BPzu4q9fJnithRUlX7FTx60qUOVHBwXN8FMo
	L0jSkEQOSyt/lJdeGnff54Gc34pGn2c=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=WZpqvLXw;
	spf=pass (imf11.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f182.google.com with SMTP id d2e1a72fcca58-8230c33f477so699060b3a.2
        for <linux-mm@kvack.org>; Thu, 29 Jan 2026 14:33:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769726000; x=1770330800; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=dBZ3PFz9KqTT7KdM5e4cMtXwD446xZIZixlzxugjwak=;
        b=WZpqvLXwXtcnRyz/tZxZ417QR7EEoUGbwKBSt8e0+gtLYP5En1OLxdaBn/H89CkfOT
         8IxYcdNVInLO0KrBV+cHVAWf9iyYLZ1JTussHp7fmzAnq7/Ks9lnLj42Pbjgk8wDW+Iw
         8mrU0LkmGIPyUUaxI3T2AjiANyWp9DUkDeNXTEv6eILgJotaWzq2dQnSom/OiaMEwFrG
         Kspxp7FJAVh2NlTu71AGping0vPpZmrZBmO2Rf1/oF/7RjLrgjLM/7M0Qskb4YftzoO3
         kXXFnxWdZHhGxaGSq8wUCNqlnd4pk9eIpiK4/dPfoEWE397oQeetTAUsQKCbJXF4kH6w
         68Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769726000; x=1770330800;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dBZ3PFz9KqTT7KdM5e4cMtXwD446xZIZixlzxugjwak=;
        b=TVPg2aENISI2nimI0cA8d+cne/LjvKrS6lrWmprjmexX0FsJoMKfFmol9LsKPPZWNP
         OJR+Hb51Q7v6Hxl0w/i+58EISvyPlFOBrtMHpkeWDjczmFeSVbRlO8pxRp9jCueEZvfF
         s9I5/feKezGCvadx4CwDJf9jtKwZkAOt/l4LxrCwBBwyO6yWKCJinE5vA5zLtYzaSka6
         lW6PWrNlowUmHuRwDfy01ZKVqx18Cd8d3P6y/nr0Ypp/zl6M7glVXEAXSMuvr9v3yogd
         uOGd7kyqSqYMhxXbTH5rH8uDR5l0oKng0idgfA9a4IYclez4G1XW2pkOsKQnkPytjg6D
         tFTQ==
X-Forwarded-Encrypted: i=1; AJvYcCW4Ii0K+xOE6IeQ++nk6CEPDx5idKZu2kHN8w/EgYDos+hI/g72gBqFeT4yhaccS8tt8JkCRBE43A==@kvack.org
X-Gm-Message-State: AOJu0Yzs5W7jewOkYH5Ftt71zTtH8Ug8fJ1gDyway5gRlJJPuNPLyoCE
	uKQrrVMxzI1Hu82AD/xXmx/NW8h/qRIFMHgVV4ntZKbe2M0hA9lMrwNEGBSQrcu9aw==
X-Gm-Gg: AZuq6aKcNIUyxwnTAbp49w1i6umH1oGkRU+BBz0XS8AtEZ9xL881CU0aHJXRa2cHgxL
	h0nf9yawsWqfrSv7s0Nf0/2do0YnwlD0qt/VHXYS5LH25vidTdG6srwvqS0GqJAuJmGnLtX6ovU
	aE63yP5rfkb25n0ETjIw2f+NikQz8LYyFOcRYifU4TK2A6YvNH01RfdnuQG0QS57ARuVRzBaOk3
	HYPm9JJaJWEfgSSkt8RisG/CnnjXqsXxnK3aMjsr3fRhHOl/DnxqVowCgA9bhNIv5n3rnAQefCv
	lIxjBeQECMoEbP64agV6el9N4BhLSO1xF8kbaRTH3EzI9ZIfk6BYtq+Uef8WhNBRbZhtKytk7GM
	CUXoDIZChwEqI1u3MGUSzQnSoY3lAkfaAEIOAXMnb9x9SlWoJdB6SXU1FN0kS/bNtzSmFNDi9Gw
	Wj7/8D/ipJ4AG2cGA10kVGI1cF8L0MLf4iI5BLtHKj9ZDiithSIw==
X-Received: by 2002:a05:6a00:1f0d:b0:81f:5ec1:8bcd with SMTP id d2e1a72fcca58-823ab684bffmr621422b3a.20.1769726000049;
        Thu, 29 Jan 2026 14:33:20 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82379bfd797sm6165100b3a.43.2026.01.29.14.33.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Jan 2026 14:33:17 -0800 (PST)
Date: Thu, 29 Jan 2026 22:33:13 +0000
From: David Matlack <dmatlack@google.com>
To: Jacob Pan <jacob.pan@linux.microsoft.com>
Cc: Alex Williamson <alex@shazbot.org>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jason Gunthorpe <jgg@nvidia.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>,
	Kevin Tian <kevin.tian@intel.com>, kexec@lists.infradead.org,
	kvm@vger.kernel.org, Leon Romanovsky <leon@kernel.org>,
	Leon Romanovsky <leonro@nvidia.com>, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, linux-pci@vger.kernel.org,
	Lukas Wunner <lukas@wunner.de>,
	=?utf-8?Q?Micha=C5=82?= Winiarski <michal.winiarski@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Parav Pandit <parav@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pranjal Shrivastava <praan@google.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Raghavendra Rao Ananta <rananta@google.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Samiullah Khawaja <skhawaja@google.com>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Thomas =?iso-8859-1?Q?Hellstr=F6m?= <thomas.hellstrom@linux.intel.com>,
	Tomita Moeko <tomitamoeko@gmail.com>,
	Vipin Sharma <vipinsh@google.com>,
	Vivek Kasireddy <vivek.kasireddy@intel.com>,
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>
Subject: Re: [PATCH v2 10/22] vfio/pci: Skip reset of preserved device after
 Live Update
Message-ID: <aXvgKRrbfymW5NKb@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260129142158.00004cdc@linux.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260129142158.00004cdc@linux.microsoft.com>
X-Rspamd-Queue-Id: 983A14000C
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: qfh5d4diqmh3jz48ohdjctimx1ux7jfr
X-HE-Tag: 1769726001-157058
X-HE-Meta: U2FsdGVkX1+goaR2Ntf4qSEBRPUrBri6NUAIPC6ipvZQRpZfhkJAEvyfexX0KTd2u6LgqSuOpOpWMhUuqAsSTUdsZffUGMr/o5rOa3rEjbWoGW6YKi5DK907USgPblK4iuyPuCdOfLZdzSUDic52uCOu4mFQvekd8gRpywOabZeKfLpzQiFgenxicohmfJvBfJasM0S6Zs0MFwQQIImSqyatG9op8UmJ2tfmu1Is4iXE36BjnYuU2kmfl54ZaioEHnwNWWmHwhH4OyK0/rolxmlrCCQPSRdWfY+pi9PEq+Da2cwdAqm3YTgpRU5aQ38QMxrzrXdg1ze1/1SE2HhuRha4siDplXF6fFEUo+yzeYBtzs/kXYx8mNCKcmz5cqOPa2vftXK1+AzXeAb7FQ6yKG0nLKJvnigRoBqOMnubxRQZxfxcBXib1sm2Ip5ey/IUlhwpyGb+ntLd4SIAnBbo79a2IEvekavU38zPckyqvGJAYN6M661qNXOt4v8zOzu7mvJGRClbo1NhF/+/qPWkXpuw/aLWWHQhk8JHJZwTFYHwkq/eDCoUZP5ENvgiqUIGgCu/2ESnKwl+6nOgGnlLo8AGlErjVNlaZ+VtJ4+o7Aa0ZAIgYrsC74MIc+ltKaLIid/Q390Vxhf68GvzgzNhFIkrR+zygvy9ERkz7XvZCscSrufVdz9AhrjM9DfuO7Iv79aez0rgjtyEOgeUvsSHxX68eA9EVtF6neugPoj9fuwrjR+bDBpQ0WLtz8Nn0geBE+X6ijVysiCshzl+Qw0z6EHvhs3UhTM8g9srjqlO2nC26YdC2b276/sKLaMlHy3gmiHsoLPCrXjP93Tgv6IBu/Ew9JfNLr9zLkNyIzNjC7Mzgq7S/sKbYLJXVEX/AldO4p1whQY44IFdKlf9OFkU4zpoqC1xzPUiHId+/Yqf8LhPkVRkKqFRaVgEmEmYG4O1Uqm8r0/F398T4VuxdaR
 tYzgcYZ8
 5Ad3SWSa0Y7xqDdK+z0xqqMqvweVPtp03mpg/4U5zGdzG9BeM5DRMZp1vNSPoXWmKlmrFytgTx7PPjBgpqjhePV+SKcgiX0WyoLm1MYf1W/ok4cnhfj54zZyjGGRi8CUcGFWOjLGRJr95z9NdadAHSXKTBpVMaZsZL9Tb6Ww2MRSqCGp+pFsrV+3EI1Mr9905Hw/desg18qNcAO3waWvKVYB+JfjqGagtHNOQ43z+TYEZ4LIFbmBvAt++6zm8KplvreSUkCfGHjgQcg2Qi2wW1F0njBsNNKUYKrhoA2V66Va1ytx8+h9Kfi9Zo6LEJu18jB9sQ0LkLhblAn9GhXS1sGPtbWOaFlrwAUXKKDME0zQS+OmUuXevTM4jMcYMUgTcUqUX5UCvF13+YMAq07uHNNaPDm09FalIzph8KJe0pVQlm6gNl2HeQg31955T+HUuqxbMuovl19wRyuQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-01-29 02:21 PM, Jacob Pan wrote:
> On Thu, 29 Jan 2026 21:24:57 +0000 David Matlack <dmatlack@google.com> wrote:

> > diff --git a/drivers/vfio/pci/vfio_pci_core.c
> > b/drivers/vfio/pci/vfio_pci_core.c index b01b94d81e28..c9f73f597797
> > 100644 --- a/drivers/vfio/pci/vfio_pci_core.c
> > +++ b/drivers/vfio/pci/vfio_pci_core.c
> > @@ -515,12 +515,24 @@ int vfio_pci_core_enable(struct
> > vfio_pci_core_device *vdev) if (ret)
> >  		goto out_power;
> >  
> > -	/* If reset fails because of the device lock, fail this path
> > entirely */
> > -	ret = pci_try_reset_function(pdev);
> > -	if (ret == -EAGAIN)
> > -		goto out_disable_device;
> > +	if (vdev->liveupdate_incoming_state) {
> > +		/*
> > +		 * This device was preserved by the previous kernel
> > across a
> > +		 * Live Update, so it does not need to be reset.
> > +		 */
> > +		vdev->reset_works =
> > vdev->liveupdate_incoming_state->reset_works;
>
> Just wondering what happened to skipping the bus master clearing. I
> understand this version does not preserve the device itself yet; I’m
> just curious whether there were specific difficulties that led to
> dropping the earlier patch which skipped clearing bus master.

Hi Jacob,

There's several places where bus master gets cleared that we need to
eventually eliminate to fully preserve the device.

 1. vfio_pci_liveupdate_freeze() clears it during shutdown when it
    restores vdev->pci_saved_state.
 2. pci_device_shutdown() clears it during shutdown.
 3. vfio_pci_core_enable() clears it when the preserved device file
    is bound to an iommufd after the Live Update (in
    vfio_pci_core_enable()).

I think it would be safe to skip (3) in this series, since that's very
similar to how this series skips resets during vfio_pci_core_enable()
for preserved devices.

But I don't think it would be safe to skip (1) or (2) until the attached
iommufd is fully preserved.

If you are just asking about (3) then I agree it could be skipped and I
can include that in the next version.

