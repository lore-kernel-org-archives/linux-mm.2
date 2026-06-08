Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D37E4CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:49:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DEE96B0005; Mon,  8 Jun 2026 17:49:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0908B6B0088; Mon,  8 Jun 2026 17:49:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EC0846B008A; Mon,  8 Jun 2026 17:49:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D6FFE6B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:49:35 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A73C3A030A
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:49:35 +0000 (UTC)
X-FDA: 84858087510.01.775F062
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf08.hostedemail.com (Postfix) with ESMTP id A536A160002
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:49:33 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dr09GYwo;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780955373;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/VPaRCEiFTRGJk9h7XnzGq6197n1Ij6plODDt3+seDY=;
	b=5JTRtWUWFLppQs5vZKOu9hrp0PxJkDrinVndigGP/j0HGxZYXWj8EeAXKODndfy1z6/VM6
	GZG+92KU5HE5heExzUG7aGDdM+JWOMFO3BHaYs/h7O6fVWHfx3Sz8G9G7vO3b71GUk4IJj
	cqnCR5+R61g0OcUODjp9Vc1J3RCqUTc=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dr09GYwo;
	spf=pass (imf08.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780955373;
	b=4Irh7qNBJFcmPyBrWT4M6FPlKN5Y7h5M+Bdu/7UL38VewSyh2L9HHvoGDotNvKR9ot09UX
	SpeTGCXDwA03khY0TCE752ylCGqO7fAGDRFEEo2im+xPIQQdX5svm5MyAuedb+CFAeLAxu
	U09Gu3mPjP7kkP/5j526mS1IMa5J3TQ=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-8422a92b6d6so2543431b3a.1
        for <linux-mm@kvack.org>; Mon, 08 Jun 2026 14:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780955372; x=1781560172; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=/VPaRCEiFTRGJk9h7XnzGq6197n1Ij6plODDt3+seDY=;
        b=dr09GYwoybNS6ZmvMCCVzpcFVppkjgBIZBHbfc90+1veEeYjxChoJ1bZ/4WUzkKrvY
         pWAgJTBFEFMbMQXkYdm5K/iSDIF6XobkJDS1w7dZe5TRyg+rynWgX0rZj1C28j5tpGx2
         2KYGKd1rRCaPFNmjlL/y9USwh9lx7vUovZRR08/NlBWAI7xTERi7/3W1YRTlNyJ1b80M
         PMy1JPFNV3Gd73hN+rfuq7C/nsXMfErgJllkZVy/j64TB664gSsMCxFjysEZ7fCzYAk1
         K+DIAmUUybKybztTZyDn/yfjFujV0mV2ux6JfNAOIMEO+1ma6Cjj6eE2aV/YWWFHveNI
         DPeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780955372; x=1781560172;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/VPaRCEiFTRGJk9h7XnzGq6197n1Ij6plODDt3+seDY=;
        b=aoIgWSD83HlyWfVNEynZsI223bC7LLOv4m0tkIAsYe3uCdVX7Q3vTb7eHLnyJhTVaZ
         ewq6vJm2gFUm4PH9Cgk3qqonImVc+v9Ut37Bcl+nlWeXB4lEQr3bpBd5sICdmqBXON16
         q7QuecoIiHi+G9gRGsK/822kzhfXQUZPomFRNJFMAO5abT5Mdi5iVfBJAEgvnIOoiT/i
         80yfHJ0MNGCQC/+xgNbPyKqeNIYb4eDJvWEWjT4viKkPU7hy/DOxrlgo1/M4SxPo6/Xh
         VlI0kBbxkYNEW2RHyOy6w+FIg1UZaggY+B+tg/hc/pcnCF8T6I88GlJogCEkFkEUWGCZ
         lpqA==
X-Forwarded-Encrypted: i=1; AFNElJ8lmULXMR2UFcfQ/ME//AvDR2gMfe94l75Lt9pel64BIjshVoDbaB/M/OiWt0ta7qt4Uwkyop+k6A==@kvack.org
X-Gm-Message-State: AOJu0Ywik/KNxioEhej52Luc/pO9Z8+q6YkL0IRHo8eT5vn9EJNDw4s/
	iYY59vQ879EiC4XKRsB18VrUJpAWjWl6sbTAh4HBxSt2lIUHjFm3VvFxUceyk2GJ4Q==
X-Gm-Gg: Acq92OFkEpk+zMyf8yzaKCaVhiFWwRg5cc5qCvUPV1d1KKk8dE/RHp+vHmvtYO24Avq
	5P3gLsUJ8oMxJKqZ/l4fURWpPz4RCJmveQ+qbQ6blhcMCbSotxtKGKA+3+r030Nq5tlpPBwnr9p
	tkxXyPhoLOEUegGxYZa/2j/NePHKWdd3Jii8SHht10sDoeRcxkXo18CnHCdUqPN0t9PZ096rBUm
	8xf8IkvjHlxhSmLOJHGIWNakgMwGNLtR7TfdTC71cOi/3hlN7HB1NP3XH4iWPVyviAETqfUskhX
	sUID/cOosTreLHd7G2rR5BZ3SCTGt7BC6/ae4oi0C/dUL7KT0QAw0GGBhoVKmkVFHBD4dutogyx
	GNU9TYa9M+//uVZBD9TLtP8Ycjaq6YnxcMc2TGIvUhSIHGdomXOpSYBOb8SaszF3cs/e40NSyzz
	g9m/MlksFaQFKv/N2wql1U/Wwb/BNBEWmdhe7m83wX2sPJ+DSQsRdJTGe0Q67guYBh/PJEjgBi
X-Received: by 2002:a05:6a00:4f81:b0:835:3861:812c with SMTP id d2e1a72fcca58-842b67b0a55mr12776470b3a.23.1780955372050;
        Mon, 08 Jun 2026 14:49:32 -0700 (PDT)
Received: from google.com (56.149.168.34.bc.googleusercontent.com. [34.168.149.56])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8428288002asm18941791b3a.31.2026.06.08.14.49.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Jun 2026 14:49:31 -0700 (PDT)
Date: Mon, 8 Jun 2026 21:49:28 +0000
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
Subject: Re: [PATCH v6 07/12] PCI: Refactor matching logic for pci_dev_acs_ops
Message-ID: <aic46OtIKfLhdoKy@google.com>
References: <20260522202410.3104264-1-dmatlack@google.com>
 <20260522202410.3104264-8-dmatlack@google.com>
 <aiW_M7y0fFwLN84G@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aiW_M7y0fFwLN84G@google.com>
X-Rspamd-Queue-Id: A536A160002
X-Stat-Signature: rgwytjg5bu8om8g5ka7mjird8mijor15
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1780955373-376482
X-HE-Meta: U2FsdGVkX1+cHkzA0d1F98xQi+m7Lix3Dhii5f8/IElPd9hm+ly95yC04lbcocSFs15JQcLprK/RRi4plZOeJJ1VIGWnFl1xbVPpKl+AkPZcSXbs+Yfh7CoQYJ/7y38uFhMTuipfePKmPNmYteY8c1w2yGO9sfgFt63BmAuu1CPqtG16pTa+9h8mc73RrXjtwdKot23LoeemRvLbDx2YfNG1v7hZWPCQ96H0/fPJKgNw82QgLia2Z78AmoHfgPPJVvOFAUKK5SYEOFtzJGLvlPjmA8bq+GlFmdiHrgKrfN1q17lZnXBXdtuBCgJyJvZiMCQB21Rm7u/zLOgocVp/jitIgcUeEbtIc93CA4zA4SREF+VOjgFy8aGTnh4zEwElhvxyS5SJ+z3z1Be735iwZyvcXFMNF4rUrCA46EGz7IByEW0W4nVcFy0hzkSDFl3Y4qXSNtyyTYs+YUk25WDKlNvpM7creXRVV8086T+TGhnrL8WWM/rGyOIsR6O/Yu/BVM61B5sTrmlPEaTMK2vfK3L7M4PtKFR3ksJV6h727vvdYkUPfLcfvZ78Y6AlnDEyi2eEwkNmrWKMNlSoxpL3hvHtnb/qIcv4DA8Qc02FkuOrwllYpj+Dn7Xo3mHCzGUOeejJTnbRLiCJyN99OFQkUN47GNlF/ek9eD0phVNMq6334/mcvs+bbWPZgZ1szt8f4G6t2+CfyXniIhv9/S9+S0m+uYfpwe0Z9PTCn4XdK0hef2emnDDhXXQsKm/P/HNFkVj+YwxwZRGZTGzYkQ/lWvgkK/flTT2qF1Is5fiTkednpi0MUEPIeXu/LYI8/MdjpGO/k574lhjqRWPW9/pk7JassqxzIeF00se2+JEwhItte+Y78BV7Rge3bt49IKhyrQY9PMcp5sD/J+TOFGqvt6cEDzsmYy5OXXHAqL6LKJ7Pl1WNCZbec5S1OFkn9Rlj39X5D0XAFkCY1Ov2LQS
 EhfBVaKN
 8ab91aZ24ONG3FJMCFbpGdxgByLtmLRoJQf3L1gzjitT8S1Ls/HArGyEzJRVg+uBqgbNpcenz8PBfWHoCpRx8bz70jh9WtFCGpnWIa8EJf5PyVxaLXWY9lFEoJZWBEE5bAGkE+w6U5ljp3dFah6ZOv2yKd1I7M/TXzcdEfUv4/1cLYh47DH/UublnAgobMjhO9vqw7yL42gSCA8gebc3MiXQfp3tcykJPQXtN2LuxmVY+IRkfDpGyALPNajJeDX+wxmWCq1ZBPy3Oe+TGLbFxJjECDRud4VNz6h/Ryec7Lgq/UYhW7jgwSKSOiWbCpiwfVMYa372ANvKi4DXyye9iagzlwPAWa2rrUusF0RvN+hStLkgrZ1gIkbBxV6AYu0FMuU8B3C4gNtyf+73v/MNz0xjUWWg7G/RfdgFMi7KAx5IDW95FIj+M6TGBOg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-06-07 07:01 PM, Pranjal Shrivastava wrote:
> On Fri, May 22, 2026 at 08:24:05PM +0000, David Matlack wrote:
> > Refactor the logic to match devices to pci_dev_acs_ops by factoring out
> > the loop and device matching into its own routine. This eliminates some
> > duplicate code between pci_dev_specific_enable_acs() and
> > pci_dev_specific_disable_acs_redir(), and will also be used in a
> > subsequent commit to check if a device requires device-specific
> > enable_acs() during a Live Update.
> > 
> > No functional change intended.
> > 
> > Signed-off-by: David Matlack <dmatlack@google.com>
> > ---
> >  drivers/pci/quirks.c | 50 ++++++++++++++++++--------------------------
> >  1 file changed, 20 insertions(+), 30 deletions(-)
> > 
> 
> [...]
> 
> >  } pci_dev_acs_ops[] = {
> >  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> > +	    .match = pci_quirk_intel_pch_acs_match,
> >  	    .enable_acs = pci_quirk_enable_intel_pch_acs,
> >  	},
> >  	{ PCI_VENDOR_ID_INTEL, PCI_ANY_ID,
> > +	    .match = pci_quirk_intel_spt_pch_acs_match,
> >  	    .enable_acs = pci_quirk_enable_intel_spt_pch_acs,
> >  	    .disable_acs_redir = pci_quirk_disable_intel_spt_pch_acs_redir,
> >  	},
> >  };
> >  
> > -int pci_dev_specific_enable_acs(struct pci_dev *dev)
> > +static const struct pci_dev_acs_ops *pci_dev_acs_ops_get(struct pci_dev *dev)
> >  {
> >  	const struct pci_dev_acs_ops *p;
> > -	int i, ret;
> > +	int i;
> >  
> >  	for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
> >  		p = &pci_dev_acs_ops[i];
> > @@ -5481,33 +5475,29 @@ int pci_dev_specific_enable_acs(struct pci_dev *dev)
> >  		     p->vendor == (u16)PCI_ANY_ID) &&
> >  		    (p->device == dev->device ||
> >  		     p->device == (u16)PCI_ANY_ID) &&
> > -		    p->enable_acs) {
> > -			ret = p->enable_acs(dev);
> > -			if (ret >= 0)
> > -				return ret;
> > -		}
> > +		    p->match(dev))
> > +			return p;
> 
> Nit:
> Should we check if (p->match != NULL) like we check for p->enable_acs &
> p->disable_acs_redir(). 
> 
> Otherwise, it seems like we're mandating the existence of a match op in
> the pci_dev_acs_ops here? Today, we just have two Intel entries in that
> array, both of which need the match op. However, AFAICT, it shouldn't be
> mandatory for future SoCs that might only need a simple vid + devid match

*shrug*

I would usually say those future SoCs should be the ones to make it
optional if and when they need to.

But making p->matc optional now isn't so bad:

        for (i = 0; i < ARRAY_SIZE(pci_dev_acs_ops); i++) {
                p = &pci_dev_acs_ops[i];
                if ((p->vendor == dev->vendor ||
                     p->vendor == (u16)PCI_ANY_ID) &&
                    (p->device == dev->device ||
-                    p->device == (u16)PCI_ANY_ID) &&
-                   p->enable_acs) {
-                       ret = p->enable_acs(dev);
-                       if (ret >= 0)
-                               return ret;
+                    p->device == (u16)PCI_ANY_ID)) {
+                       if (!p->match || p->match(dev))
+                               return p;
                }
        }

I can include this in v7 if you would like.


> 
> [...]
> 
> with that nit:
> Reviewed-by: Pranjal Shrivastava <praan@google.com>
> 
> Thanks,
> Praan

