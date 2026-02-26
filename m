Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A367BFD9E1F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:40:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA9426B0139; Thu, 26 Feb 2026 18:40:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C55A66B024F; Thu, 26 Feb 2026 18:40:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24AB6B027B; Thu, 26 Feb 2026 18:40:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 99A606B0139
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:40:52 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 641131401B5
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:40:50 +0000 (UTC)
X-FDA: 84488230260.17.4A7461C
Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	by imf19.hostedemail.com (Postfix) with ESMTP id 821751A0006
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:40:48 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9LRNVdb;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772149248;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dweZEP9P9syIIaIBNbJewu0YbCAV1KvejPrlkY4pDLk=;
	b=JQw4PefQ+yLCQCMjBNIxPnY94rlH7ECpNWpiYFbbLxjvYMnyjR/jOt4OPqX+G8+8u9lcGH
	S/FDGFL3u/AwMKtJbdTlkvnUzFP8EesR44mQdnRq+cSu+PFxh3532lexVG5rURMydTx05P
	kad0EoTy0q7fh7f2vk7y5ZZLQLDHgaY=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=u9LRNVdb;
	spf=pass (imf19.hostedemail.com: domain of dmatlack@google.com designates 209.85.215.182 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772149248; a=rsa-sha256;
	cv=none;
	b=T06v7Kt8taEbgBYQhg8gA0lAwjG9VstzAFe1tRhAacvbgsAq7YpVnLlqOYBJh7O6utI0lL
	1FffRxcrz3FMUoO/ut1d7M2VCVoDYDpxpJrb45V1n45A7yS/+5Fgpub34cCblrJHIy4Q2b
	gA3qqXo6aX+ctj8NP+9O62HoVrd9Yls=
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-c70378ddaafso926291a12.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:40:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772149247; x=1772754047; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dweZEP9P9syIIaIBNbJewu0YbCAV1KvejPrlkY4pDLk=;
        b=u9LRNVdbIJTRCMXhTqjPLDSsAiTONl5YifsvwE4m93g5hVrXUskfZcK8axBMRO49cD
         0vXdho8qo7MZHA0+2+98dLJZVGWG8i+ui5REJYw4adzWp//Tl9oleNkcIVgvb0lEtT8j
         iIvpp2KapY7kDsUyrWupYRzvyktc7gCaJCFhZTXASe3BmiWc1Mg+/fWsssZmXJSwpkeG
         9IR4HPNMWtDRMMBspj8ORjY5sL8qpxYsY49FXlC5xwNz3fzwQxvHb/EeislV/jm0b0hF
         t/lBzfbNZvJ8Hr3RqPpZE6uaNoIZ/mzB6gNMBKAeHul4LW0EzTyoZZLXIA1/5y9xcmbS
         CjTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772149247; x=1772754047;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dweZEP9P9syIIaIBNbJewu0YbCAV1KvejPrlkY4pDLk=;
        b=ejmUJ1JBIaS0Wh3lB8P0E2RxEEfPcHuKQGQi1Inr0QDemyjsivzK4OInXwmiJ6YxKs
         Rw982xCVyteuer2rFgSP1uJ5srKT7lvg/xPN0cZkQK94j+GRKZKvbnz6mmwxeI/udjMZ
         P/F2f8J5z6+Q2iRfVFdU1NcAJd8M4aRfyUp3KoujchPzSfW+PK8/ePi6M8v2KlCUtnp1
         FyqG8Ol2hzMd88/+2z6Z5srW6D8hA5XaeCB+kZIOhBMIqmutlJT+IIiqeQ7wXlvhvbAH
         s0G99LgS/t+g1z5inHwFuSM3iL4zlvowptAZMdPXTl1mTIzQ8OGBMn5gNGI05BLEJF6c
         Hi/A==
X-Forwarded-Encrypted: i=1; AJvYcCWyVtZ1VtEzbcIf+aUeAtM9mVWbDk3Row4Qptof2avZAloH3X/oIrVAvNGfWLynTKD9PZcmBQDPPg==@kvack.org
X-Gm-Message-State: AOJu0YybXOEjhZcteRgJQo1CkGNnBayZWLuRdIfxtuNYn2Wc0P8qSg5M
	tAUW0jszR3sX8tMdHGgNOI8DtNYNrioVoaXvSSsQzmkKtFAektVro3quYYDQLRqnaQ==
X-Gm-Gg: ATEYQzz0ypIapL9llr0FYYWJNmiztkRljiqBwKut1XvFz3hO9uDHmd1jZaYfiH7WCKG
	JjqCkEUPhbTP6FdHtEMVnKG9ehdWIoA3gcQzfyn9cy5N5UcLl4JpUy9a2jPxDqljaMb7H+yasAQ
	2A/pYBRx4W4+xrPK8uNRSN5/CcbHcq20j9OH/b7R8mMxlRk6gbb7XbcCK4F48AFcEkKre+WTvZJ
	z2dr46WkhPna9tKGvsLQwBNulAXVFrVRMAHr0ZQwIAAAXeR2hu3ytUQMzkLnxm3xT/ILclqzTZx
	ni1ad/RQxZ3diQvVcmiNRY96k5N1FwhuVwUftpMMlivlQcPECYEZpLyATR7hwsw/wpOavGEVg+r
	IznbZoWL4G1dAYMesYkaeniAsZsV330zvZD9yeOGyb3ca93OEGdMttOFoHCrD+ch0uTix9NebN1
	/Iil3lv+vwdGMH8GIxf+/t2/VTrE9psyGOPMMXB28C7YkgGVahjmNznKu/wJOKmg==
X-Received: by 2002:a17:903:22c9:b0:2ad:cede:3a18 with SMTP id d9443c01a7336-2ae2e46bd8emr6748745ad.33.1772149246778;
        Thu, 26 Feb 2026 15:40:46 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb5b257esm36167495ad.4.2026.02.26.15.40.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:40:45 -0800 (PST)
Date: Thu, 26 Feb 2026 23:40:41 +0000
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
Subject: Re: [PATCH v2 06/22] vfio/pci: Retrieve preserved device files after
 Live Update
Message-ID: <aaDZ-ffs4kiUo3GY@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-7-dmatlack@google.com>
 <20260226155222.5452a741@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226155222.5452a741@shazbot.org>
X-Rspam-User: 
X-Stat-Signature: cf4ijneaitd8u5om6m8xksywsoiy1h8t
X-Rspamd-Queue-Id: 821751A0006
X-Rspamd-Server: rspam10
X-HE-Tag: 1772149248-541855
X-HE-Meta: U2FsdGVkX18VhmGq4/BvSeNeMakQe+IEWs9FBx6SpDlDDdEKnx8P7YrbQR7KN3kgfuz9PadoXat1kOJMcx7XTQLlSHKM/uzWL9PLuJCvq82m8eReG+g380sJBVLGjI0XykaHnqgE0P3E42Dboaj16Rbrptry7q77bnnX3LKHdmn3sJQkRc5zCRtbYeZOqx5f81FScWqFf1kubSSZCmoTUlI8ygb0VgxH6IsusYVKddTsEmBZSIXzgFuHhkOM8h2KfVgjwx3IrnFMBP/xPde6QRWrBsa9aZ6YbAL49kI9fRP9BAPCvdSg280x8bVEchdL6BK9y8vcEKK4nfxKiBBC37pv+P5lPa4jSLnrYoSZOEa2NX/flxLfyCvCPRZikM5b3qtGx6zj9+pQk3wzHuu4Qq0trVFyO6RpwqO26Cid00doRgvR1Qnefb3TWzvsdTNxDXajxieoYBx7aTmzVzMT06U5XwGuivjZ1OqAdGYG6UkRNwRCR/pS6nFaNPFoSk3bTDnnF8junMv+6xP2IT1NOPrDrilLNLVJlZrjFAeZXx+R3OTh9nv3e30MB1K5rNPv5ZPep+47J7fi+gnWTJ3iIBQpXApR49B1OIdl0eW83cD9IdM5ccvDH/6D30MJDDa1Kx9vxpk2h/S349T5b7pgkl18FZPwXJYru5BRc5pjgb7YJ8PGlefoYp5EzRBN+jV/A0FltB8/bNyDTzQFbGf5PudA3IsZC/uolrBbUGQJUpF1MSpI7c+GLtAWLP0402NX/4M+AdIApJc3Se11QYxeR+4WsSQvikc8lFG/HLoK2/yjpZpFr20j1LXSvTcrSfCpl6/80p6WqMxUZTg1tDX+uVOpo35xH4DVIWtCNaUU41g8XWQwA+B66ZTltcyzWUzfWUuePJ/XJ7itjJVRXRuCxkfW6NmaxrEVr+o9WboDUq6eWvb4sCKlh5ijYWf6nI1U7V573Wut19eYFh5Ns4F
 gugfT0Gm
 y/qDBpHMEAiRptwuC8/yi4zk08PlAtTIt/40Fh/YQfm7S3HsLYUGYuk5QlOJKydfLCTuWOdKpBo4wgClJ3vkQxFfetqytHymfg/WwN6QyKfcHwIoG/WK4xEDwf5uqR/H5XuIkAWyRfNDuQCClkYsDyZActMmFh9jXlMbd7Nkto4Dc4C5Scy3CZAU3Jh2VjVvJJmQ+6bQMqTv2K/b+FmLoukgzdG+AvBoUdt1IIzrTRWNS2ZTMYigdHAPOv5KqV1A8CClZU2ZxzDNzApq6hqBXF+/QMxnT6bvEwbQqUfwsedxYBG2X4unsZDFcAgvBcn2ldCTD/X3yiY7CjuAqACMuS9nU0/o+7hKhm1id
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-26 03:52 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:53 +0000 David Matlack <dmatlack@google.com> wrote:

> > diff --git a/drivers/vfio/device_cdev.c b/drivers/vfio/device_cdev.c
> > index 8ceca24ac136..935f84a35875 100644
> > --- a/drivers/vfio/device_cdev.c
> > +++ b/drivers/vfio/device_cdev.c
> > @@ -52,6 +46,19 @@ int vfio_device_fops_cdev_open(struct inode *inode, struct file *filep)
> >  	vfio_device_put_registration(device);
> >  	return ret;
> >  }
> > +EXPORT_SYMBOL_GPL(__vfio_device_fops_cdev_open);
> 
> I really dislike that we're exporting the underscore variant, which
> implies it's an internal function that the caller should understand the
> constraints, without outlining any constraints.
> 
> I'm not sure what a good alternative is.  We can drop fops since this
> isn't called from file_operations.  Maybe vfio_device_cdev_open_file().

Ack. Due to the bug you pointed out below, I think the changes in this
file will look fairly different in the next version. But no matter what
I'll avoid exporting a underscore variant without outlining the
constraints.

> > +	/*
> > +	 * Simulate opening the character device using an anonymous inode. The
> > +	 * returned file has the same properties as a cdev file (e.g. operations
> > +	 * are blocked until BIND_IOMMUFD is called).
> > +	 */
> > +	file = anon_inode_getfile_fmode("[vfio-device-liveupdate]",
> > +					&vfio_device_fops, NULL,
> > +					O_RDWR, FMODE_PREAD | FMODE_PWRITE);
> > +	if (IS_ERR(file)) {
> > +		ret = PTR_ERR(file);
> > +		goto out;
> > +	}
> > +
> > +	ret = __vfio_device_fops_cdev_open(device, file);
> > +	if (ret) {
> > +		fput(file);
> 
> Don't we end up calling vfio_device_fops.release with NULL
> file->private_data here with inevitable segfaults?  Thanks,

Yes indeed. In that case I think we need to call
vfio_device_try_get_registration() and vfio_allocate_device_file()
before anon_inode_getfile_fmode(). We could play games with file->fops
to avoid it calling vfio_device_fops.release here instead, but that
feels hacky.

