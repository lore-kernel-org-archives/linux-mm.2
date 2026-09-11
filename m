Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C297DC88E58
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 16:45:59 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7DC8E6B0095; Fri, 11 Sep 2026 12:45:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7B3EF6B0096; Fri, 11 Sep 2026 12:45:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 67EAA6B0098; Fri, 11 Sep 2026 12:45:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3273F6B0095
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:45:58 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 76C891402A6
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:45:57 +0000 (UTC)
X-FDA: 85202058354.15.2EFAF42
Received: from mail-pz2-f43.google.com (mail-pz2-f43.google.com [74.125.228.43])
	by imf04.hostedemail.com (Postfix) with ESMTP id 909C94000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 16:45:55 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S7bI0HUt;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789145155;
	b=FD7uhuHuTb0jDqnGXaAhiGGvcA8Usb80HEyFW63bq4geikne4IckyLfSURuRZbdO7Up6qq
	yuTDVOK1ed4HS4//BLTb1t1pIHe9lIW0CG0Myk/7edEL6IewUvy6yqhQx0Xchqk4hcH8RC
	veJXgl/EDn/GAuUDFmkl8wfZfEbiwH8=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=S7bI0HUt;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 74.125.228.43 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789145155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=atdgksBYk103iq7faoi4jk9ATkMw9i3avFodOi108iA=;
	b=J/daBUgiBH+ICpKvu9WFc2uJTrIPaE9KQmGqMYjMwDmbgHJofSnQp/sBAXoXSz8DO05RFB
	1zg/cf4nwHrL9klMqyMuDcjvkxLuFAvZsO4hTAUeXnWUeF38dr5CheGMHKxr92OaVP4fLU
	pBgv0QTRzxRUgjomqK1it4UpauudxAQ=
Received: by mail-pz2-f43.google.com with SMTP id d2e1a72fcca58-8692a856865so135133b3a.2
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 09:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789145154; x=1789749954; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=atdgksBYk103iq7faoi4jk9ATkMw9i3avFodOi108iA=;
        b=S7bI0HUteM/c0dULcjRg+bbFYIFOshGQFO2eWvD2hMMN/3nSUP4znOUSAlSDr+8Cwd
         u8qARU9szFtr6lBP8At4V6SoJUx2/KfAnw6xIT+zwyBbG7AaSdEqpMz9GjAaBWdJCtaq
         GcTiR5w23+PqSBxiUTHXhLNTSyY79sqnrk1mqKAS/CS/zyCVoD1AWJQYex/bIH4IsSRq
         Sddgs565b8yF0nCgHwsPk8wzOaDBpIu6/dvsV0MwulzkZT2r2sBETYN7imULs97OUwJq
         qj+xHefhGyUEKM/bF8SJ8kIxFc0vNbV/uSeYmZYRvMpx0TMzvB1gz10cqViPM9wzx3Hz
         j1Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789145154; x=1789749954;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=atdgksBYk103iq7faoi4jk9ATkMw9i3avFodOi108iA=;
        b=VCjV3ZEcVoVTTsIw9DiXGv45W3+ORJ5vI1L1Apeosi/cxfSzzufy5saM7EP9lleru6
         uyOxHOIm/GSACGHZ6E2UuJWOIYEcLc84Mh0FfdW3GY07pTqBeOm+xYIYSmHAxxAsjTxW
         cc8XmVv6mBoNczOyogHQzCIrhXO6ceJhcVz2ijym0Bs+kf2ZhxmoI58C/vWZpUAKUpYu
         qyinnE5EMdwaH5qqYML1Ys2LHr/XzKTOWSkBk/E+Ytnq+5bp2fJWb9EMzVj+MuFV1ytE
         jH0MLDODYzDsYUUPLZo5GL5H6oVQTafpYUwquER38ghKCVF7pIyAZ5HJuii0SbW0VrwQ
         k4EQ==
X-Forwarded-Encrypted: i=1; AKwUvByy2SAexaU9OLcFliOBuLG6o67WQDij6ye/pQwqyumk7yBj9g+bQQjZwcMffKbVDNJ4jKtgPmQeGg==@kvack.org
X-Gm-Message-State: AFuF++mnGZByuW10SyMLnq+aQf6HZ9WI3Al07Hiqp3FWzXyILK8y7i05
	sw6T8Sh/6umnW+FMsocckTm/M0eol2HzoEenBbFLgVufrFX4t1fZb0ZH248VBqoOIw==
X-Gm-Gg: AYBFou0hhTXVrj1/ZEK2gZj0Mf2w+K7CFk11OZCTm8izwb4RXnfhc1yhfxHzfbI9qXg
	VvcDyYn1UX0xKJjVVrH3wSvfQm6J3KMg4yf03HMRxNaaZcXgyQOL/SDLwljsXbhrf3uK7wjmUmq
	zIXA7eTcAu7WfvC8p1KO+fAd40mJqvE5rGtsFGfXsrpuScj+fDPCHd7AOzfWLQPEpddo35FfOPk
	kP7Hm9qiAwyll3K4wZ95cjwlVZcyIyp1gxco+zCleYVUrJEuwcLMSzcWzVWd+HEn5Xl4eBX6AGd
	dKb02zOp/z7qwIDvLT4XUbWDcKU+bkZYs0ORb+Ok27xqsMLZ3zQJkQu+7eIQVz3UFsOQbE7Gqop
	XVk+GlyQgvOcrusZAAjNemUM2nsR6yvOotey+UBRyzJpUFv7RsFdBOn8XpF5K2e2uR/GzMQTNLs
	jVPrU7NWxiBN673CTTeQE7owpBdY04ulFrIYwadtonu+RCc7qABEltizP1YmziJOU2w+J3FCn1c
	cgDb1OzRYeRMBlTqORkQjKwAqru2R1Wet2vLCGn
X-Received: by 2002:a05:6a00:4c9b:b0:857:72ba:ff0e with SMTP id d2e1a72fcca58-86b347ebbe6mr9035236b3a.22.1789145153852;
        Fri, 11 Sep 2026 09:45:53 -0700 (PDT)
Received: from google.com (192.150.203.35.bc.googleusercontent.com. [35.203.150.192])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-86b286c3f5asm1472296b3a.12.2026.09.11.09.45.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 11 Sep 2026 09:45:52 -0700 (PDT)
Date: Fri, 11 Sep 2026 16:45:50 +0000
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
Subject: Re: [PATCH v8 03/12] PCI: liveupdate: Track incoming preserved PCI
 devices
Message-ID: <aqQwPn4XOxC58vU3@google.com>
References: <20260728221007.2098560-4-dmatlack@google.com>
 <20260910234956.GA367108@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260910234956.GA367108@bhelgaas>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 909C94000C
X-Rspam-User: 
X-Stat-Signature: nigcfsp4kzw1yfj31kanff8m5dasewoe
X-HE-Tag: 1789145155-50644
X-HE-Meta: U2FsdGVkX18KLWENBk7P7iWKdu+Qnza4mFy58fWTiKQ2Qo6NMOCqkPrg+j341egomXYdSPvQbfpz7BuLq3W0iyzkXC3lSyEFpUcdh446v1JWyFKYnQgE9WGwdHhb1LOI43LfQBjpgmvX7Tmg3pfijd0/HN6ajw1WTNkX3UCvAatzz66H04vybtyOKIqkY8DslJIO99Bnajfajd9uf1dun1XgiIdyDZFAg22cRMyvwOno/IJmW0f2tASLUYSh33yJ+t7q5YgIpREA3EM/qFnx22p1ytqomn/IECGSTgoaQkb+9SSWXKNL517qXFLfOwH13ID31VHWzphSHdjX3bPNxrWlIHw6PWS5nvCFhlGoGfHqKhyO+3sB3468EB8lYGMCsOtGj5CZOcbRwoW13xTZ049KVU5PY4fER7HBVRodabJMNexeFsttf4riQfnMas+UslJWRGD7KpOmrTUFV+D05AcXmH3xZTIkQ8ccVKpCn5ElMqffEXnOMxLWjweYJM7nKK9/MZTJo63lKVMIgUN/ri42SqHqwg9UPefDSekQXvS9aqHIcMXgBC72b94C2v+DjgqmzQ7C/Bn3uqZ3EqZnBisPLHwlQadJ1V3LPJTeM9SIV6jX3GgGCPBwnpSKEV6F5gFJbFa82/SULZUNC1ohUZzg2ZVo5iuuS3GgRHjfNFk4wA40gGFnS1yuA73Ia3S5WBl/kQgUwMjQln0U6if9SHA1KtDmG7fQsAYt7gzc7nr4VsrVUlLqmE+BS5LO0VyN/+MvgHSuD7GxPi4nCcp5u7vHaE8tXxy4O7MMhZcnyvyAZuqcxymY99uBE832bUaCq2NusQL/9peayHIz5t+OmzgUwB/VyYK3nbkLae2Lk1ZVIlmVK/Vlw9uKvlLiRfPiRKElg6k4TbL2pFIKXYmrIP0RR6pIbiTvc87rnu89NYtNqS6Ok/HOe6pZ526TY6QWPUcipFAAlls4F/9sILY
 BoD9CR7r
 ylIwKBOTX56x6tBKsNQdDhDuUOQXYtgHFP/uO9d6aMZBPSwiKihoRw0P/i2+OecjLsK4hQUKwqRNfW8RgkIT4+BsrXoNQX7E9fau6kYN6FLduPVMxT0CqiquadsH6eqHnI0fu9PpXNHhLG8TaSwrmLofDak8ZTN/KDT1L1Q0bTHbxPob5wOqGXUng76np5YCwicZDApC/mUsQUY/Fx4mo23Xl+RNQy2YpMjgw3BA3wnWmYzUO1WRFFbpLfaovq6Bdu50A23WqEsHQl1DkXjOJaUB/bIn1W0pVLRPSutzUZ0Lg8DabToAP8Tw8YZvBJ7EVa8qEV/sIaPhdC9b6mOOJoeqvUymYZnj96PY6fDSDlRQasR0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-09-10 06:49 PM, Bjorn Helgaas wrote:
> On Tue, Jul 28, 2026 at 10:09:57PM +0000, David Matlack wrote:
> > During PCI enumeration, the previous kernel might have passed state about
> > devices that were preserved across kexec. The PCI core needs to fetch
> > this state to identify which devices are "incoming" and require special
> > handling.
> > 
> > Add pci_liveupdate_setup_device() which is called during device setup
> > to fetch the serialized state (struct pci_ser) from the Live Update
> > Orchestrator. The first time this happens, pci_flb_retrieve() will run
> > and convert the array of pci_dev_ser structs into an xarray so that it
> > can be looked up efficiently.
> 
> > + * The PCI core does not enforce any ordering of ``pci_liveupdate_finish()`` and
> > + * ``pci_liveupdate_preserve()``. i.e. A PCI device can be **outgoing**
> > + * (preserved for next kernel) and **incoming** (preserved by previous kernel)
> 
> Thinking about how this will be rendered in the formatted doc, I think
> "i.e." is really part of the sentence, so in U.S. usage this would be:
> 
>   ``pci_liveupdate_preserve()``, i.e., a PCI device can be ...
> 
> I understand British usage generally omits the comma after, so that's
> OK too, but IIUC the first part of the sentence shouldn't be
> terminated with a period, and the "A" shouldn't be capitalized as if
> it's a new sentence.
> 
> Similar issue in "PCI: liveupdate: Document driver binding
> responsibilities" later:
> 
>   bound to the correct driver. i.e. The PCI core does not protect ...

Ack I will fix up the use of "i.e." across the series.

> 
> > +static unsigned long pci_ser_xa_key(u32 domain, u16 bdf)
> > +{
> > +	return (unsigned long)domain << 16 | bdf;
> > +}
> 
> Add blank line.
> 
> >  static int pci_flb_preserve(struct liveupdate_flb_op_args *args)
> >  {

