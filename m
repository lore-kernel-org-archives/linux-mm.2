Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65532FD9E2A
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 00:51:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9CF276B0134; Thu, 26 Feb 2026 19:51:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 97B536B027B; Thu, 26 Feb 2026 19:51:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 874D06B0289; Thu, 26 Feb 2026 19:51:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 699C46B0134
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 19:51:27 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0E970C1ABF
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:51:27 +0000 (UTC)
X-FDA: 84488408214.10.BBD6F44
Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	by imf29.hostedemail.com (Postfix) with ESMTP id 31ADA120008
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 00:51:24 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m7d9w3d3;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772153485;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbrSIpDE3Y8TNhyTW+6lYUs18ku3UAynLvTznEtk/Vk=;
	b=DMLUQ6SItogl3G3f3TumJETFXx2V9R1xi9uuPtp9iIm+J0n/UA1Y3L/pMRBv1X4/zCR2Bk
	phrTehXTGuWd+snvMSHMJhOhCdQCbOPXal+M2jNgzlV56kP4YKj9HK2k4VAfEp413kQjgq
	EXBHdlkvWAqSE4B60qYqB8nze61BROg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772153485; a=rsa-sha256;
	cv=none;
	b=bWQlyoqHi4SPKiD12umDA/DSA+h5b/Dij7OxPt3ummOlugZHXilowTs/v4UloyUNZgA4OW
	ljvhNnKR06EKf6CVGHOQQkq0gsxJayZ2r5dLHrobEGhfR/76sI1m8zWNgJUz6fN8hGHatH
	iClE8dqO50WrAyrXV3LHF2IL3uFTn5Y=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=m7d9w3d3;
	spf=pass (imf29.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-2ab077e3f32so6414385ad.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 16:51:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772153484; x=1772758284; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=MbrSIpDE3Y8TNhyTW+6lYUs18ku3UAynLvTznEtk/Vk=;
        b=m7d9w3d3lvokUsnAFepVG5IuolpOXmIuE3HZ4LNqc/7Zfc3mG67xJe6A9f0a7bwqP7
         swP9rp/H7bn1S9JSK66FuX8ZxEMlL83TpjD5e4VwbTRZQjRYbdaB2rV+yp0K2h7tFGeJ
         9/X/naKeqIySzQrd+SgrO7ooOkG4PX3Cir1+kE1+IqVIfyfaG616xrJv5S6F2qkz2P7j
         W/tukX0VX+zi7gO9tsbs+f/lAfKepPtyJkpS6oIdVNMc8CYUH/3CfZpQ9KeMlf4YclJ6
         aelzhzhPzuVbr0Es1hG5oyGLo3rac3vfxzXOQ5wdnlvutEgqkx+kAz+1aHjeOiKkD3hn
         Wjgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772153484; x=1772758284;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MbrSIpDE3Y8TNhyTW+6lYUs18ku3UAynLvTznEtk/Vk=;
        b=ZGmqCBLBd6SmqyJzMfmhyeJylmbktUcKgER0UP68m4a1a/6iytoz2veusw3L9rk7nD
         Aqr2Ujy6uyJ+DkZbXKgLvkAukSk2+nyLoqvZz1UwMofIgixZemgTaTWfk53RP6a28XVr
         ICraRjXefJ/scR95GtMCfJGTfzzG8hyvbeRR0zmeROrbhv17Herpu7UsUMU4Txqx9MCk
         Mz0Cve/1Dzp7zgPQubqFsVVNvI21De78r0e5YcjeqVpbc3WbHjHDuqQS5v+HcV4lnEjn
         IpiVQApqHjyTX4JeC8ONhlRQPPwofRSIuyq9D31OWvqqRCaMQJ8NK8PaKsfQRkdngA0L
         rhzg==
X-Forwarded-Encrypted: i=1; AJvYcCUZyjnGf8DrNUp+eKo/RgUbwY5uMaGvEOUf7VqnRwpPAyy1PN6JjD216JgzgJPVcc9LyO0yt0z4eA==@kvack.org
X-Gm-Message-State: AOJu0YxPCGSIxejUUulD+90CCQH/23KMQ0HY7hfO6N0KfEFtd1m4dto2
	8LETxD3yo9eELdwbD107TZeSohVt42Xzc/JnUiu5uP50JwjKOcYnLIXOmXNl88nQTQ==
X-Gm-Gg: ATEYQzw3O7SRqMR0MM7sQk4QUCseQ5vD+QisWqnxlpH4xO83uYXtmDjbhRV+XMq48Yz
	EYGKLKv1WnPnOQiCxn3hOkRPoq9+IuSBqopSdB07sxiYLuT+lExEXMtErW/veMV8VvZBD5TIzKk
	hZYGCK8ytFKL0PF9syJv9UtcfWhxf/lsVbaZi0NRxcuYYnyj3ZLe8gfe63xL5r9boI6lcu7cHua
	slZKAfMdRqk0wBbO5kxWTMzem4Uu859aOO+x9kgye6juTWqujJg8Crj9/LVjr6n7E+u9CJ5jCB5
	GEVdtqpOEjvgVyQspCPxdis1VMvjHQPpwpBrqh77DWNbQu4eJzPgatwAXA5bAME+3KQTQvG7dDI
	uqdQL5ROLkONOGTOu+Yu+iEO7SxaFf2Ss+tG7U3dmsdmVxTaWsjQ2gyyoWjzrmmXLI6RSCgqsL5
	jsiie7yZYjMCUzOhtKvWQ1NpdvrvSKzi4CrM3YPKFTSRpV4Jq7XlmAsYWdXjE6sg==
X-Received: by 2002:a17:903:41cb:b0:2ad:ba04:40ca with SMTP id d9443c01a7336-2ae2e419430mr8325415ad.25.1772153483265;
        Thu, 26 Feb 2026 16:51:23 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6b974csm34254135ad.65.2026.02.26.16.51.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 16:51:22 -0800 (PST)
Date: Fri, 27 Feb 2026 00:51:18 +0000
From: David Matlack <dmatlack@google.com>
To: Alex Williamson <alex@shazbot.org>
Cc: Adithya Jayachandran <ajayachandra@nvidia.com>,
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
Message-ID: <aaDqhjdLyf1qSTSh@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-11-dmatlack@google.com>
 <20260226170030.5a938c74@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226170030.5a938c74@shazbot.org>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 31ADA120008
X-Stat-Signature: 36oaxc34a9cxfcpo5tgtwr4uyg6zxyz1
X-Rspam-User: 
X-HE-Tag: 1772153484-57063
X-HE-Meta: U2FsdGVkX18MlUhk13lnvi5NEer3wQAEUt0ZMysBLFAdB6ZE5ZY0rQOwIAA73Qr5hUxS2lx4COjyyoEKGPj7g0fPCHqwQvOVI7Q0Cl0ZsqiqdBblOmT3GzDK8laZY2RbY+TT2i4+RmhVyK6iRzVXXX0q0Yjg/zhRLdzh9+K7vMRLgP1S19qZ8F7Oh5a9zYGYHjwWlnsCQw4qpeMvZ4XKza9sn5BGaltiicjIfxyRjopnmQRlAxefMYxr9NlciikAlyRlHNynoCXnz9uQGC4Cx+M3Iq/GfWHepSYdCUC6cc8h6OroY7TLWPmxVI49Lzs12K6Q/HtCDmgbwn1/iFHWHypCecKPBT58zOt7uPFg618E0iX0R2B78RlQ/2ZFt6rH8rxwnSW8lsFF9dowbqETaRg9YG/NknzYpEGZ7zQZNBTqtGhcU04own1oolv55y/2Ktz7sxRfZoUqO55hxuijAFGouvsdDgjTtr+9RUa0VnYmiGtLVNpBEg4PDTB1r85+LuWCy2s3P+GTlp4FOCxl/gfhhQZHl/RRReNO8z+PsAgV5hWBZH3J+OaoPHg7plK8XNfurj25nPaaXWJVw/R4rNFVim+h7nbVv33ZOIiZOzWNTYQ4FW+QRCLMS+aSp5MVvrza4xlejPyn8J8ZybYI8FziUHWa3o1yDEB6ju4S34uCHFq+MZuLoj4pj+LZvLYA73v4QH5iICrrd+kcI89G8BymI/7zKJIlUoUY8+YB3h3z+IAPRzakXpG2K+3pBdqTX4kq5RjPQc3uXu7hAmSFUwmgMhbi/AeAV4Myj6Blpozo3/NdQRRECINsTD+IgFh8NI0wZQlHP4y84bUkqNJGGOCZBpA39Gpr7gmGNsK9jLoQ5KTmq9eAbNJGtS9mUkJkrjwXoXTJMuheTAADwsMq/KDukqqkQPAHFZQubzWoxuB0RTw3NWf5J0+l54dn0tKUL2VRhMdONcrHIyhzjPe
 Vru6OIpO
 I80WMMjXN5IEntE74bZ0/X99WSEjsCXBJn+15eiDIxKrbvB+VtCsq0cjZoQoJw7cBF5rUUVWScnnmScQQwfcZ18W3XpTY/n1udfZNNGmkFdeA4OQKJ/KeEJLQ+b0Tx8w+uTyVwzghFGzSiaDacVvz/z4YavvLhM7iGGJUtabxqWbqjcy4LdKEOltlCaTVRb88nmDZvhpwPQ7OK/kcM7+oJ2zVSvaJw8uCUhBc0LFf4cpq3i8DzyyzjbJWulOwxTf9sRjIFQeYnOoRoCOg8kzOzOBHs4wHxqZj6q1N69N6SnJkAOIVae+VlIt16jKVhQfEhvbvNvXpOVpMY9gFvBvSZ2GtRQFCzJ+mjNWT5DeSkKwI4HLiIJZFwrI/BdXNS9xUgLaGiB345ke19YJgFy2h+dlxzsJisWZdBDXZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-26 05:00 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:57 +0000
> David Matlack <dmatlack@google.com> wrote:

> > -	/* If reset fails because of the device lock, fail this path entirely */
> > -	ret = pci_try_reset_function(pdev);
> > -	if (ret == -EAGAIN)
> > -		goto out_disable_device;
> > +	if (vdev->liveupdate_incoming_state) {
> > +		/*
> > +		 * This device was preserved by the previous kernel across a
> > +		 * Live Update, so it does not need to be reset.
> > +		 */
> > +		vdev->reset_works = vdev->liveupdate_incoming_state->reset_works;
> > +	} else {
> > +		/*
> > +		 * If reset fails because of the device lock, fail this path
> > +		 * entirely.
> > +		 */
> > +		ret = pci_try_reset_function(pdev);
> > +		if (ret == -EAGAIN)
> > +			goto out_disable_device;
> > +
> > +		vdev->reset_works = !ret;
> > +	}
> 
> This could maybe be incrementally cleaner in a
> int vfio_pci_core_probe_reset(struct vfio_pci_core_device *vdev)
> helper.

Will do.

> >  
> > -	vdev->reset_works = !ret;
> >  	pci_save_state(pdev);
> >  	vdev->pci_saved_state = pci_store_saved_state(pdev);
> 
> Isn't this a problem too?  In the first kernel we store the initial,
> post reset state of the device, now we're storing some arbitrary state.
> This is the state we're restore when the device is closed.

The previous kernel resets the device and restores it back to its
post reset state in vfio_pci_liveupdate_freeze() before handing off
control to the next kernel. So my intention here is that VFIO will
receive the device in that state, allowing it to call
pci_store_saved_state() here to capture the post reset state of the
device again.

Eventually we want to drop the reset in vfio_pci_liveupdate_freeze() and
preserve vdev->pci_saved_state across the Live Update. But I was hoping
to add that in a follow up series to avoid this one getting too long.

> > diff --git a/include/linux/vfio_pci_core.h b/include/linux/vfio_pci_core.h
> > index 350c30f84a13..95835298e29e 100644
> > --- a/include/linux/vfio_pci_core.h
> > +++ b/include/linux/vfio_pci_core.h
> > @@ -16,6 +16,7 @@
> >  #include <linux/types.h>
> >  #include <linux/uuid.h>
> >  #include <linux/notifier.h>
> > +#include <linux/kho/abi/vfio_pci.h>
> >  
> >  #ifndef VFIO_PCI_CORE_H
> >  #define VFIO_PCI_CORE_H
> 
> Wouldn't a forward declaration do, and the kho/abi include can be kept
> out of the public header?  Also should be in the previous patch?

Will do.

