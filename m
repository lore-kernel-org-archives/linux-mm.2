Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B1F0BFD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 22:29:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC4AD6B0088; Wed, 25 Feb 2026 17:29:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E47F46B0089; Wed, 25 Feb 2026 17:29:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2A256B008A; Wed, 25 Feb 2026 17:29:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BA8C26B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 17:29:54 -0500 (EST)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 663C58C08E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:29:54 +0000 (UTC)
X-FDA: 84484422708.14.47321A6
Received: from mail-pl1-f179.google.com (mail-pl1-f179.google.com [209.85.214.179])
	by imf07.hostedemail.com (Postfix) with ESMTP id B81D440015
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 22:29:52 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DX60r2mT;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772058592;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EvlpF/Rbdy5yVGOyUM/AWdTkLEwWYWZDygf5cNk3LN8=;
	b=wynWqDBWwPCCR8fPs5lwV4g8ZmozbynMugkpRz6fFkgqCPL61B6v3SG04+Rs2W8V/TutX0
	QjWsUcih5fZbGRAq1mdF0CYq+Xm1ToiYyqIv+Np64fkxNbywsLEKpJvasH73aNkONpNprL
	7a+JrwOy1JWlFa9sRy4ut4Cz27hR0S8=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=DX60r2mT;
	spf=pass (imf07.hostedemail.com: domain of praan@google.com designates 209.85.214.179 as permitted sender) smtp.mailfrom=praan@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772058592; a=rsa-sha256;
	cv=none;
	b=fwDN1uH5jXADWAdrj4YWs3f9F2tFHqyj9oNfW352oHNjHyoKP1BoMNl9D0RkrYwSHA1FT2
	3D1tE3ioVak+kRLk8pjLiyzC6APPrI/z0SRzahpDB1w1USyB6kPuZBk+7PWUgoIKcs6jTk
	aBMdR5BEi03Z3ZXD4kxayuJZ3ToeiX8=
Received: by mail-pl1-f179.google.com with SMTP id d9443c01a7336-2a964077671so29595ad.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 14:29:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772058591; x=1772663391; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=EvlpF/Rbdy5yVGOyUM/AWdTkLEwWYWZDygf5cNk3LN8=;
        b=DX60r2mTxBPxIROcf/WfkH4KK8qoYLS8TBO7Z2gfoNC950cLtuVIqHkosgzqWFabQm
         oZaMqU2Wsw5aNCSb6rkBN+VbQ6JWCcwo0a9uXTGWQUefFCpVMj+d5SVc2O7RouxCnwsV
         9wcPk2HecyZiiqDfGufyz/PijYpqFbN8YlVDu8NYjSfnlBJOUK3UGVfFHRRhEq/fapGW
         TpAtLrtao6cwGXjXQ4SD8u/1vSFJOsBq1vGhRgkbU6iSlsl5GcEz6JWkmyaVK1HWJYsi
         J49BDbuIJ1Zm/y5nRDdRsWhQI6fpSJ1qA1FaH0pLqTAGWfFGEYTptu5L3HJh9m6RgBN5
         wMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772058591; x=1772663391;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EvlpF/Rbdy5yVGOyUM/AWdTkLEwWYWZDygf5cNk3LN8=;
        b=sZLX1HXi2Fmn7WpRcSSXOlDEvvoSTtrzbd2PAuORh7IKG6745woxqGJaOp5S3FjXEa
         IxL6bufnEUDF/bOHu+4KTyJEe7BDW3uO6BCSsoaZjMmltl37gOpryzzNAlN8YMPxgpON
         XagdWSv7/x17YEBOYFuh4DFwSITXdloi5QYUzpIq3CZHHDle0WHVYM4VB0GqgvVansvZ
         8/oQyNrJoIbXyM9YEZpqQ81WX2YfyfTEj6qTTjOiOyAq56iBv0n4YnXPZ29rrGHSRUAx
         OSrSxmHfR1n/T3pJ4oE+whLnGwNJQUSRXv0th9evPNO1LooGScsv6CpqLtak2Wadc9Tx
         BiMw==
X-Forwarded-Encrypted: i=1; AJvYcCUCoJSdiaMPVJLob6zi+sZAh9i7hyw0Cu5KW+JN5k9muUpvdg4Vl5pSrYvWXapMifHGiZk/zCo13w==@kvack.org
X-Gm-Message-State: AOJu0YztD7AnYsSwlDY509hsbSU82ALhdAWtSjFBXYMrYhcjKfYsADAd
	A7F2Ocg7BqMVDbWAFpXZhvcO4RpD8sI3GgeaJu11YRRwjTPSA7wMbF7AUb4lrQolCg==
X-Gm-Gg: ATEYQzwipxalnJ0XVFpifTbeqwORXddIJJ7dYwX7zUNFJNsovtlvfDq7+m7wVrE2yCw
	kPzlQsdaufJqsZgIYbMSLkrNzE/e8tPwp2+N5Qb0WGe5CLP/KKZ6t8PUPQwKJczCAFIiDatyL0L
	O9wzX8n0LYW/g0hZlrXTMckWvOQQs3Ri3fX+LEC6LaTB3kxk87MTEmdZ+cgOm2E4UO0uyo2QrD2
	vpar2i2sKs7UpmkvbFZPY5fwqjkY6O/K5eB6RN8sW1TdDQGkR8phyF+wOJK7K9/D4sV6r3Sf2L6
	sWFpHeE4bckvSIxVoS6PkLhSd8zy6rj4aetgXo8CUVvmFBZHPx5JzAwjURIwA7Z9H4kO39NzZ3b
	R1hwMqnpqgn0+3UjXsb+0QzSHhXQzn4a/5IN8pJkQF5lkqSdTv2NGbdTgL/9GGDxg2tHIVrhXyM
	7c8qUv1vpHqKuZKsQmhHpdKon7YXkBENrAErI8S75i5Hn/06N404w9IPVgrLHWt9bfe4Whm5k=
X-Received: by 2002:a17:903:15ce:b0:2a3:cd98:f07 with SMTP id d9443c01a7336-2adfefd95b6mr300155ad.3.1772058591084;
        Wed, 25 Feb 2026 14:29:51 -0800 (PST)
Received: from google.com (222.245.187.35.bc.googleusercontent.com. [35.187.245.222])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b2309sm2774685ad.19.2026.02.25.14.29.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 14:29:50 -0800 (PST)
Date: Wed, 25 Feb 2026 22:29:41 +0000
From: Pranjal Shrivastava <praan@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: David Matlack <dmatlack@google.com>,
	Adithya Jayachandran <ajayachandra@nvidia.com>,
	Alexander Graf <graf@amazon.com>, Alex Mastro <amastro@fb.com>,
	Alistair Popple <apopple@nvidia.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Ankit Agrawal <ankita@nvidia.com>,
	Bjorn Helgaas <bhelgaas@google.com>, Chris Li <chrisl@kernel.org>,
	David Rientjes <rientjes@google.com>,
	Jacob Pan <jacob.pan@linux.microsoft.com>,
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
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ931bYILhhkhW-Y@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org>
 <aZ9yWlcqs2b6FLxy@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZ9yWlcqs2b6FLxy@google.com>
X-Stat-Signature: xy17t5bf5dend3fg7xoisjjqx9dcp7ca
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Rspamd-Queue-Id: B81D440015
X-HE-Tag: 1772058592-999794
X-HE-Meta: U2FsdGVkX18ZuXwL08tLUBoOIF8IXdrI0OYsDHMiEJSXUPDL9fyW4TugHSmIKi6X+lfAvJ56/O1H3mmx9+f8wae+SzMoqonFYfQWFXwjM4BLNMXoffDQWBfZ+F5i9+3TcyEkyrqUCeU2m3BeX+boSsqCHfrsjSuAQs185XH7lZq+l94/6Su1PIr7St1neIiDXIX3vlKTAc4Cscn1DMGKjB0BTMVUAygt8YexS3Cnl8A2P0ZDiaFenvXxKGmSOdbNYRtZISzEbKGdSv/wmW5YakEmrqkfXlyUHRmTcUiHSsVxnyuS8JSNHaqdP8qvIcaA1hUUrw+USwLxeMJZltFHT5ZGPX00y/PoP/dDrDUKYt4Sy/3o2+l1Rq2D5PlidyjiE/wuysYOosKc6AayGzil0wiSxo/vYE2z8v9iWhBDNm8ZFclkGdxCE9HDRTUdfgqRxn7UgjNsMx41eq1Q1waW/tnFJQi99apU1KXFqrEvIn6ra9Iwvp3TBGbrV/rogUWhG62QA96LfjPsGKucKsWqLyjMc3tBmq14UKnXpKMyzf963caLu2QDtDWIT2D4s1z7tBAP++WiMzpfqbYxOHMZdduJO5nPbEFp9gcn1PCW5vPI6uQlujm7aAokexGRToE2tcKeYAnjsLbB1Q7b8jqietx66IakMeLgEUajJI1/AroIdlqQO1N9wv3H1CkYaFurOlXmg/7x1JdLPdIUhfQalWyBGm5hmg7m/vA5Ypn2vWWyp4InsFlXzEGy8LOhinCio+mhu/z381tqBNR7NVKqsNn3qIIPnT0xjId3SSyJ7oO0gQnfox7nx83RTjYhCOcgaGtKGm7+JQtkmwxy/oYr2O7HLwp1lAJpexIdOJ6aUMHHRSkpfgdyebWDmMIdu0rhAM0v0hpxKwBrp2+DmG/Q0DEFOeStNXxhbrqN4i4WSXFUsqk5oLyW+wAc9Bb08H5gMafVbs/JLnUVmM3Pmkj
 ZWzat5Az
 8HpNCGsovc5i57lEWrW++Ime5Rw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Feb 25, 2026 at 10:06:18PM +0000, Pranjal Shrivastava wrote:
> On Wed, Feb 25, 2026 at 02:33:28PM -0700, Alex Williamson wrote:
> > On Thu, 29 Jan 2026 21:24:51 +0000
> > David Matlack <dmatlack@google.com> wrote:
> > > diff --git a/drivers/vfio/pci/vfio_pci.c b/drivers/vfio/pci/vfio_pci.c
> > > index 0c771064c0b8..19e88322af2c 100644
> > > --- a/drivers/vfio/pci/vfio_pci.c
> > > +++ b/drivers/vfio/pci/vfio_pci.c
> > > @@ -258,6 +258,10 @@ static int __init vfio_pci_init(void)
> > >  	int ret;
> > >  	bool is_disable_vga = true;
> > >  
> > > +	ret = vfio_pci_liveupdate_init();
> > > +	if (ret)
> > > +		return ret;
> > > +
> > >  #ifdef CONFIG_VFIO_PCI_VGA
> > >  	is_disable_vga = disable_vga;
> > >  #endif
> > > @@ -266,8 +270,10 @@ static int __init vfio_pci_init(void)
> > >  
> > >  	/* Register and scan for devices */
> > >  	ret = pci_register_driver(&vfio_pci_driver);
> > > -	if (ret)
> > > +	if (ret) {
> > > +		vfio_pci_liveupdate_cleanup();
> > >  		return ret;
> > > +	}
> > >  
> > >  	vfio_pci_fill_ids();
> > >  
> > > @@ -281,6 +287,7 @@ module_init(vfio_pci_init);
> > >  static void __exit vfio_pci_cleanup(void)
> > >  {
> > >  	pci_unregister_driver(&vfio_pci_driver);
> > > +	vfio_pci_liveupdate_cleanup();
> > >  }
> > >  module_exit(vfio_pci_cleanup);
> > >  
> > > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > > new file mode 100644
> > > index 000000000000..b84e63c0357b
> > > --- /dev/null
> > > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > > @@ -0,0 +1,69 @@
> > ...
> > > +static const struct liveupdate_file_ops vfio_pci_liveupdate_file_ops = {
> > > +	.can_preserve = vfio_pci_liveupdate_can_preserve,
> > > +	.preserve = vfio_pci_liveupdate_preserve,
> > > +	.unpreserve = vfio_pci_liveupdate_unpreserve,
> > > +	.retrieve = vfio_pci_liveupdate_retrieve,
> > > +	.finish = vfio_pci_liveupdate_finish,
> > > +	.owner = THIS_MODULE,
> > > +};
> > > +
> > > +static struct liveupdate_file_handler vfio_pci_liveupdate_fh = {
> > > +	.ops = &vfio_pci_liveupdate_file_ops,
> > > +	.compatible = VFIO_PCI_LUO_FH_COMPATIBLE,
> > > +};
> > > +
> > > +int __init vfio_pci_liveupdate_init(void)
> > > +{
> > > +	if (!liveupdate_enabled())
> > > +		return 0;
> > > +
> > > +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > > +}
> > 
> > liveupdate_register_file_handler() "pins" vfio-pci with a
> > try_module_get().  Since this is done in our module_init function and
> > unregister occurs in our module_exit function, rather than relative
> > to any actual device binding or usage, this means vfio-pci CANNOT be
> > unloaded.  That seems bad.  Thanks,
> 
> Hmm... IIUC the concern here is about liveupdate policy if the user 
> wants to unload a module which was previously marked for preservation?
> 
> AFAICT, In such a case, the user is expected to close the LUO session FD,
> which "unpreserves" the FD. Finally, when rmmod is executed, the __exit 
> (vfio_pci_cleanup) calls vfio_pci_liveupdate_cleanup() which ends up 
> calling liveupdate_unregister_file_handler(), thereby dropping the ref
> held by the liveupdate orchestrator which allows the module to be
> unloaded.
> 

Ohh wait, You're right, Alex. I just realized the __exit won't even be 
reached because of the internal pin. The current implementation creates
a catch-22 where the module pins itself during init and can't reach the
unregister call in exit. I believe we should drop the ref when the user
closes the session FD? Additionally, should we move try_module_get out of
the global liveupdate_register_file_handler() and instead take the ref
only when a file is actually marked for preservation?

Thanks,
Praan

> I think we should document this policy somewhere or have a dev_warn to
> scream at the users when they try unloading the module without closing
> the session FD.
> 
> Thanks,
> Praan
> 
> > 
> > Alex
> > 
> > > +
> > > +void vfio_pci_liveupdate_cleanup(void)
> > > +{
> > > +	if (!liveupdate_enabled())
> > > +		return;
> > > +
> > > +	liveupdate_unregister_file_handler(&vfio_pci_liveupdate_fh);
> > > +}

