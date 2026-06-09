Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BBFF4CD8CAA
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 10:56:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E54316B0005; Tue,  9 Jun 2026 06:56:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E055C6B0088; Tue,  9 Jun 2026 06:56:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CF3B56B008A; Tue,  9 Jun 2026 06:56:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B748A6B0005
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 06:56:14 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5BF4E1C262E
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:56:14 +0000 (UTC)
X-FDA: 84860069868.21.ED93E27
Received: from mail-pl1-f177.google.com (mail-pl1-f177.google.com [209.85.214.177])
	by imf14.hostedemail.com (Postfix) with ESMTP id 7D563100002
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 10:56:12 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AjtFR0yL;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781002572;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zdMxQIDs+l/KSPJFUNCwvqWbxtsN9baWYoGyb/P1vPg=;
	b=MifBkSYFbzXMNnIjgByQ2J9YD0bg4167LeYvgX9Rx2IeznDIsD+sdarqDt0LL89Ll8JLn8
	vVqa4JI1Uam6pk4sU9RCA53CX5PSNw8KDYEO6VkEuXk4smZfpn41YxChRJjUqVDyvPpikW
	V60RXhoO1MYAXI1oYhl8F2p5OuOUhyE=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=AjtFR0yL;
	spf=pass (imf14.hostedemail.com: domain of praan@google.com designates 209.85.214.177 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781002572;
	b=7T8r3T2HS7TYkU0XEvYywjK6+6OxBvo1f7nxWO0f4m3cHEO3UdtQrezyal1ISM2PMzqIxo
	rF/ltBl4ej2OaOLnuL5AIyYR774QVasFbvtuYl4L6JAQOQ3/RlotjrSjjXLfdFH4RqWebd
	45St7AqTQQADFaAyVbr6uQ/X2g5DOVg=
Received: by mail-pl1-f177.google.com with SMTP id d9443c01a7336-2c0b1a48855so496435ad.0
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 03:56:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781002571; x=1781607371; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=zdMxQIDs+l/KSPJFUNCwvqWbxtsN9baWYoGyb/P1vPg=;
        b=AjtFR0yLC+Am9huN2UgMZ8EhR680wkaBsON2fcojfYw5ZZSAjc5P62cd4wDcF48nkI
         r5bOZIYCHj97Irptm/cnuA7U/1nHo/dZrEDpUOnDKGyEwT0xXVS/K5sv+wt5t2fmPh8j
         7A0fOAgDdMjZ4qhB0rDF4uE0VATsynrmOYI1XIZelGuOkbrMHyio1tvDmUfkPKEXT2z8
         zpNo93mV5qBvpmXcqhhvPA51LYuvrUrnUEWTCEg08X0wJStjyNBet3s1ox/ezJV4UX58
         vx0T+iMhy1qDNueCp1csV1qTjfG2ygtrCtPlnzaQEljbAeMEQ1d+jZB+shx27wiDYFhA
         8Clw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781002571; x=1781607371;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zdMxQIDs+l/KSPJFUNCwvqWbxtsN9baWYoGyb/P1vPg=;
        b=moimshdgDYIPRRjiLXXNdJzs9nfJWR0PnsO4T8CDSxY+GWR8HaZUSnvNKHZjELzoVq
         rQrTIwWV3F5uEPRmgGR6csqSTPvNneiO8eGk8YNw+Woc12KZoqWTu5ddOhUwwfrOaD1d
         n+2K3gYo6ujaQrBLkACBbULO+VOEAeXhFIY7p5atsPy+sA9ucKPr/2298gOq0w4c2jQF
         cdYe2KIqhdIGBE7d/qUxpFAC/T8QDD4puTGnzCePz1XJZ0y2MxGua5wCHr0tNgCi2vse
         WSg7dsUPdNnsIyT3WS50QicIrNXDPQPbinDrMCeHLnzKScmq105nWWvSlHshyunCyZ7s
         /D2Q==
X-Forwarded-Encrypted: i=1; AFNElJ+J8qMRGPzU8xVaZJfD/Bc0+aP+zMgSFHI7Ld+PzTTPYsZEpufP0+X4XZ2dCxnMlkIl3ecmd4J6oA==@kvack.org
X-Gm-Message-State: AOJu0YwyKCjkN4CH21PSgAzLldFHGACgX9taGVl8djYO6I4b3Ozo+kui
	pqk8z6DeRmrOXzJFPdGe9PA/jqmQT//vRvvbulc4bU26o1hLg2k2/mWfOEuNOK+nIw==
X-Gm-Gg: Acq92OEX9/f7HEK0wkpxwBitdda3g7J0gkbe6Luxe3VZlvFrhBZFIAxDfyq8UYcL7tM
	pTkG8bHvwP8AGwa8JWwnPXJ5JzFFhRPgjux0f8U4QVe+HMFWiYCEsIDRWgPBYNOEnE0z5w04XEE
	Y4B3e8X0Nwlt+nz4fior1fhNflwvEns9puSjDp0x7JnBhnLMA+H0CAv7x0SGbr7oR8+XPkLtfkA
	eZ0TdfNKnUJf7syMOY1NImzIah529AeLTz1ERY1f+Zp/zB5awWz0kZCr3enb6kbpTGQNkUFYAQW
	WPW+VjOsYyVs0oEOC2zSp0WcK5axgFi8IwrvdoISrop2CKPEFgeVmvyq7abjU4ELNchpDOqakQQ
	UaGm4UDYe7zMEScwBSIij0ZwKGG1ljtzCkxv00/QV0bNofn/UfVYwUxCNmBY8gUbPv2yQRRoLzA
	tM65ydH6sv5YmQkqFkGhKdniSaL6l55IG+9Tay/dKFEbBwug/r9WRv3NrLDCDgxihAtMakLHA=
X-Received: by 2002:a17:902:f708:b0:2c1:ee6e:be23 with SMTP id d9443c01a7336-2c1ee6ec5ebmr6732565ad.33.1781002570788;
        Tue, 09 Jun 2026 03:56:10 -0700 (PDT)
Received: from google.com (199.255.142.34.bc.googleusercontent.com. [34.142.255.199])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-36f711e52b0sm19480623a91.15.2026.06.09.03.56.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 09 Jun 2026 03:56:10 -0700 (PDT)
Date: Tue, 9 Jun 2026 10:56:01 +0000
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
Subject: Re: [PATCH v6 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
Message-ID: <aifxQalxwM_hic6F@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-8-dmatlack@google.com>
 <aiW_M7y0fFwLN84G@google.com>
 <aic46OtIKfLhdoKy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aic46OtIKfLhdoKy@google.com>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 7D563100002
X-Stat-Signature: skzgwndkwhfenpumsjnsxpr593bycmse
X-Rspam-User: 
X-HE-Tag: 1781002572-122458
X-HE-Meta: U2FsdGVkX187/2NPRwXnaH5Vggc06hI1suSAqpqdcDPioB0nm+otss9JjEUrizp0BctmG1aOx50SSmgfC20j9HN3w7Hz58sDTz6Y8zuHxMdOFpu8sEeFri306z9oy2VgMOgM57mIR6j3JVfCQvlxgaJmELXIPKmIJ8YpfZYXa3NQtIpn0mdJzmwlNZoBFT/14QPCWmODog21VdJ1KP7dvUnI2+gFHtAZ7Ghk7iWM9YuISZM9Qm1TScS7/92yfySinCKEoAkZMh/GoXvMLNMCu7z/aOJ7Iib310H0zwz+WyDmPlEeu8tpT8sR9yyPnkrRq6PK8zJ03pM9JVMVCV1WJnEtIKqwL3imHKQ3GouTgCOBcJkTkMgWptVzM8GBUhTBoKs9ppO/z7LUPkLRhQw45vNb7nX7emXQqXPxwZKf/o3NWJg6tBNBKMlQdFE1EDa2JAzsLrzcoBOK5rfvC7yaG3orwyJS468oQGCJmIStr+A5grRA/x1E8ACrud98zt18qlT5bZkrAHGbtknoD5Rwt7cukVsizd133NrohQuBzsIxuoWKjuSM8a67e9AVQndFUOeGRErmG/y20p4AiKv7UFGaa1W8aK35Ta7jnk/Q8AYEApuhO1P638XEEQ/Wcvzq4PSCCKIhdCXOtLF5utJNWRKvVuKgCTYTg9QyzY2fgUzUrJXTch1OKzbwbt+SY7wRIIXQ1Uc6jPdtyg8UCrTMiCLmxAtjWdpAdq3ED4ZYL/2DUTvnYCa0m0lB9BGbVoZbHkl9cV1K6rsA/+0bdki5zKrvDo17oqhXfYaL0+fQK0FwDxstDy0ZlkXUjGq+pner0RE29U77mdzpvMLbQAFeKKJsG0YBRyq9F7ccIQiacQsRPe1cENXFpwWQHOG7LWJUr22a+RDFibZ7CAxRF7wZCT2RRx/nb0ay3wFIBwtg1A8eiG+mKgFPhjBpTHoV26Ej4f8Z0ghk9ehk0RcmGU/
 n7EoEurh
 pOPLQPt6rag7qnqZG3FiLiklrhkSarFJeZE3jNj2+zoSGlxW+FOd+I2yAD2giEHB/Vk1TpbMinggjkRkAWnJ2GNQP1uA2xldfxEO7dK3uRUplwmaRflkArSQu26Uhn8S0nIl3tmfxsABS2SjqZfgVCdhk4kxYkCbsJFydL8mLdQrW/8MgECFAm9ZOIIdyIV38JOsDHpQkWEYpVaFUN/WQcoIsPbNq0ZMJtnDdPm9nnLMCiy/Li/q06vQi04xqR5UU7buOUT2Y+pSBmdmhbvEmHp4kGV3ag18LI3QNNNvU4MdQq/Kz5EpwXwyC8/umFOpUhhDQrfkSEBRBOB1dK3wWdfwlcOVGRUjryO54l/ZdSLYircG2JC1LoNTB3dLEb8edRHBUZQc+zahHhzDQ9JfleFkUnsRhOVav5Qjn8R5gJejns3fEa0qqbXB5Rg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 08, 2026 at 09:49:28PM +0000, David Matlack wrote:
> On 2026-06-07 07:01 PM, Pranjal Shrivastava wrote:
> > On Fri, May 22, 2026 at 08:24:05PM +0000, David Matlack wrote:
> > > Refactor the logic to match devices to pci_dev_acs_ops by factoring out
> > > the loop and device matching into its own routine. This eliminates some
> > > duplicate code between pci_dev_specific_enable_acs() and
> > > pci_dev_specific_disable_acs_redir(), and will also be used in a
> > > subsequent commit to check if a device requires device-specific
> > > enable_acs() during a Live Update.
> > > 
> > > No functional change intended.
> > > 
> > > Signed-off-by: David Matlack <dmatlack@google.com>
> > > ---
> > >  drivers/pci/quirks.c | 50 ++++++++++++++++++--------------------------
> > >  1 file changed, 20 insertions(+), 30 deletions(-)
> > > 
> > 
> > [...]
> > 
> > >  } pci_dev_acs_ops[] = {
> > >  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> > > +	    .match = pci_quirk_intel_pch_acs_match,
> > >  	    .enable_acs = pci_quirk_enable_intel_pch_acs,
> > >  	},
> > >  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> > > +	    .match = pci_quirk_intel_spt_pch_acs_match,
> > >  	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
> > >  	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
> > >  	},
> > >  };
> > >  
> > > -int pci_dev_specific_enable_acs(struct pci_dev *dev)
> > > +static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
> > >  {
> > >  	const struct pci_dev_acs_ops *p;
> > > -	int i, ret;
> > > +	int i;
> > >  
> > >  	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
> > >  		p = &pci_dev_acs_ops[i];
> > > @@ -5481,33 +5475,29 @@ int pci_dev_specific_enable_acs(struct pci_dev *dev)
> > >  		     p->vendor == (u16)PCI_ANY_ID) &&
> > >  		    (p->device == dev->device ||
> > >  		     p->device == (u16)PCI_ANY_ID) &&
> > > -		    p->enable_acs) {
> > > -			ret = p->enable_acs(dev);
> > > -			if (ret >= 0)
> > > -				return ret;
> > > -		}
> > > +		    p->match(dev))
> > > +			return p;
> > 
> > Nit:
> > Should we check if (p->match != NULL) like we check for p->enable_acs &
> > p->disable_acs_redir(). 
> > 
> > Otherwise, it seems like we're mandating the existence of a match op in
> > the pci_dev_acs_ops here? Today, we just have two Intel entries in that
> > array, both of which need the match op. However, AFAICT, it shouldn't be
> > mandatory for future SoCs that might only need a simple vid + devid match
> 
> *shrug*
> 
> I would usually say those future SoCs should be the ones to make it
> optional if and when they need to.

Well.. that's fair I guess.

> 
> But making p->matc optional now isn't so bad:
> 
>         for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
>                 p = &pci_dev_acs_ops[i];
>                 if ((p->vendor == dev->vendor ||
>                      p->vendor == (u16)PCI_ANY_ID) &&
>                     (p->device == dev->device ||
> -                    p->device == (u16)PCI_ANY_ID) &&
> -                   p->enable_acs) {
> -                       ret = p->enable_acs(dev);
> -                       if (ret >= 0)
> -                               return ret;
> +                    p->device == (u16)PCI_ANY_ID)) {
> +                       if (!p->match || p->match(dev))
> +                               return p;
>                 }
>         }
> 
> I can include this in v7 if you would like.

I don't have a strong opinion here, this should be fine.
It's just that we have NULL checks for p->enable_acs and 
disable_acs_redir too. It'd be nice to keep the same pattern.

Thanks,
Praan

