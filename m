Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 83477FD9E1F
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:27:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B04FF6B0266; Thu, 26 Feb 2026 18:27:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AAC6A6B0271; Thu, 26 Feb 2026 18:27:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 980346B0279; Thu, 26 Feb 2026 18:27:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7D5B66B0266
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:27:56 -0500 (EST)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 31133B8A15
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:27:56 +0000 (UTC)
X-FDA: 84488197752.25.1A877C0
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf06.hostedemail.com (Postfix) with ESMTP id 5A5F2180009
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:27:54 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PkmvWdGF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772148474; a=rsa-sha256;
	cv=none;
	b=4BT+2SdouwQOuZutpdwXSoEHqLXZ4H/YL8lFqWFxFyJrzxmhDTU3alCSJmv0SBzrpv6s+/
	XvKfU8NH4C9dzuss4RkSlKAMGjMKn/DdzAYITx+1Bnd3TOXWpsjUmjqZ6dvR3q92R1HKVR
	ZawgL6T/B0P2f6Jgik69HYWzDKEWcws=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=PkmvWdGF;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf06.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772148474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=uUrZ9rZ9RlW3x07tCEk7xJ4J4Vz88lZHdKC8XE8Cxsc=;
	b=yoPpoKeyF7qe8y0pFWyUzOVEm9qzt3BubwTul0DvuzNIEVhfd3wWPRYj/JZkxYR1ZtMEfY
	ZKlE9nzOvVk0kLxgP+8yAr/A+bx8aaXb97HrO6be2W3f/iQYx5ErPpMWY83+VBbxKErhcu
	WAXcG7IdTDAXukEQrAHtKIol1wo0vZU=
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-82746ed8cb1so477490b3a.3
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:27:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772148473; x=1772753273; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=uUrZ9rZ9RlW3x07tCEk7xJ4J4Vz88lZHdKC8XE8Cxsc=;
        b=PkmvWdGFvwN85iua9zmVMRhDh/WCX7lUn0oVRgP09adaJkF6VHuJlENp0+SODCKlIY
         ix/6EHl6Hh6V9aFwbkIQTsCYpWpjrn19UXbr3yo//kCORqno6xi3qM2lA7j0hwLJNhVB
         1h1hF9SluWt8pgIPXUX1pUu3eBG2D5Fzm5DkAsLSQncZlQCLHcwuGEbArpPRr/zKw/j4
         fnsLMKToZ4hyPP8NigCe2SgPUoBLpKhRxhBE5azNu2jtjvHrZhZuf0Phs2tJRG7nSoM5
         5aMHUhz8fgL+LstZatj0+H/zZgC9TxIph4oMaAjNTUrxuAfPQT+qQ9CoZInIVpo6bukO
         Z79A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772148473; x=1772753273;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uUrZ9rZ9RlW3x07tCEk7xJ4J4Vz88lZHdKC8XE8Cxsc=;
        b=ILH76kzvT5vGgbzmZamRyF5GBR/6zTsiFvAuzds+IeL7zjiCmyVEAPQ1WrAvd1DDJV
         4cZIqlBz/RXfnGL1CrXzkwX4YBao16S+CWFKynCB8vk+Z/93K8rBELNeY88CaIJmkZhv
         qgjDoA/dX3zvY/KfXwAnXD72E6gt/M2Qx0C33KZhBXaX5f3ogT3m677XWnkT9sA2syxP
         IrUmsnuzvEX1CU/IR5ylwafSSxDNCSAFlpApzmdB2X1DWwAYyJ1tMx1INXy6nCMBXmsg
         LlSuywT76l1HkljZg4IAr7NQUYjXw2m6KY27vfJ+V+OD1a0R7tcvzR3tFWfjQrDIf3MU
         dADg==
X-Forwarded-Encrypted: i=1; AJvYcCXS9hs/7sr0rsjevOYUeZ4orhmAPaAsS7acrkGfx00LPyQkjqO8k1bJKpSq5oA+xa6+mXcoRWXt6Q==@kvack.org
X-Gm-Message-State: AOJu0YxzyQTydxJdCEqaV1QQpkcb8bkXFN6jpwa/AdJowoWRjUY/Kdsw
	2VK+wj2JMCNbR+No4h4rHdlorKfc3qPlcxqplOecDGSjt7JzSwYijv8wRIdRS93lSA==
X-Gm-Gg: ATEYQzzBLEz4IXQdkCc6QjQGPzM/pfg/d85ahC3ZyS2+8ebvY27pBMyqrW+BQEbu36o
	L8gRhCQRs/Ap92OJis1pYDDNrZHvpImnXILQGUZQ31SFKqsqPPGt/VD/tqrq8jeQbtWnoL0CV8P
	4/8KiZ1ACqSyACMgI4m92W9UnYz45J862Y36AqrIvp63fNxpfjI84HKUGyA8VvHbhSWXM1gxjsB
	YuFZkiaoHYZrsYuzBwGgjVz6fwhyasfxsxSWDP1jmoeAlgh5lwRu2nk2jI+8BAPQbxZtBcqXVIh
	ZlJ86UTVq18axwtcpEAT5XOumZaJ8/RzEUy8zYZK6mbRkYNFudhLoUBL+btRVqcbrKd/CuJ9gns
	W8DFEFDvgGWJiuaC3zFiA2S8EnHjzybrBBmjms+lGhB1vcP4DY1bD0HybKcGFo0i34Ph77yUAyj
	vHoUr8BThIa8oOgJpa1ipNySwMfCd1t/HEuJsIxOvezHFF827AwRM9BkDH0DVjz3eDnc9yJNdE
X-Received: by 2002:a05:6a20:1585:b0:38b:e9eb:b12b with SMTP id adf61e73a8af0-395c3ae6d18mr701611637.41.1772148472659;
        Thu, 26 Feb 2026 15:27:52 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6a03fbsm48080705ad.43.2026.02.26.15.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:27:51 -0800 (PST)
Date: Thu, 26 Feb 2026 23:27:47 +0000
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
Subject: Re: [PATCH v2 08/22] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <aaDW86eWuQLZ3cfP@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-9-dmatlack@google.com>
 <20260226161512.532609ec@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226161512.532609ec@shazbot.org>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 5A5F2180009
X-Stat-Signature: h9ha14db45f1g5c78yz3imzoxc6t4wuz
X-HE-Tag: 1772148474-237353
X-HE-Meta: U2FsdGVkX1/UVJYeWoBVdvbmkcuWbK7p0Xh2w7F79dKJErhA23/bp3il99WQq1s+qKfS3pBI49TBupNLfIdyPHSyBr5ctKfRcFuNFnQO5P14nmXhTClpiHbEvv0uzayAUJbHJvUqzlVAT57mTnsQlaQSkA0vnovbzHYmv/rTw+x7c1PEiQMgowCjWkpghAgIAEmnkAlIHkZ0Tm/iWeDmEo54paJxBm33h5NUiStWOLWVYnx0TdnesK6FGynRb2QF5jAjLSC5zH1ToQR9WzZ5AU/F15f+IT18FLiotK+gp+Bc/B8923h474tdgAmvrq6BaDkYh3w6cqJa2omFiMKYoXI6RQtsYgqmDeHWIMb6CJwpAXt3lVaNScT1FK0kdhxrEj4GuBsoDrsVyqZ0KB9EgPKbC64pbQ7oCPgzCFsKh2Z8Kpah34yhltZuqaI+aozYCBWuTjNgaERgpX88x96Kp99ypFNpGuVEqnEtYg+3Yd9GTJ8aQWbV3yuX9O4S/8tceo9NcOq9exu7uwgZDJUe7psJ7bqaxxwyDj1Y+GQqMGnxiTXntF8foEFT2GNZ2CPN34DPbb7T2ZVASXrUX7iWtUG4VV/0A/EAcK4L1fMLjkKeRGdWH14GsPyDnZZaSTOUmDbTwLpducGZzHDJsoqn9R/tptmwGbWdQo5gFgk8+QoF5CEM4S0d2huJWPpuI3z6zhSRnzadKk5lRnlSd9K8T/Pob+zvhqObNP3hrsy9yxeGEnN/wQKVcR4SpZZyiEAeYxVliRZ6FHre7jFfC9wpaVKjpYr3Du/yEJ12b0gqJqikLORgFI+RqKlc8C3M2sCSD3iqwOyjRhgKWUW8kVl8TZxa5vjq4jlE+57BH66PMHcwodyoa2JD3//wESWsS1Lm/4WdBwHoz26goQQKsKcHB/wdU2WbQvL1dhZcZ6IWS/5Kw0zLfE2atHf6hFD6Fl7o5exvd3o0b+5rqWqYrqJ
 nsXAnSXQ
 4JaSIpauA+/mx81XkLFETx23jDvHYnIyRk+A0+P4ehG6kNAHCcOBtUj0zZhcCsenvqqsLGQNs8FFfCCCbaeZBTnXzsSE/5SS+jvxyXK3+Zwihpf4cZOsloLfFM3E6s80gSEWeyohZCv5nh+8AeEB7rJKQwXukF78yA0y4XUvH+t09kcDL6ML1eSbbTMTJOsZ6WSjP+dLwaCBjDyWJ9npzhuMdIQdMVyvKguM4oGXzG1C4+kdchqiAV6dgZd+COyYWlO23hoKZD48rkpthZ9KWl+TWAyb0jjGA7S+nTo7yHTOMCSdLaJwIF+B7TfcIKmEBVRZKixAdw3osh4/u3E9ym8kQgDrr8MqUoauzpb4Pb3hhWzrt8L1XFN5TM9WWP6t+URMu6/h/cDlRnmV4RhLuOphcxCnfYkt8wfuq8mNf25dgCgre2HgADk1bN8/brFVR5vEUhWUoMp+tMVF5zbl+wgQm1nVzz//uMjGYE7cHzOM03XA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-26 04:15 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:55 +0000 David Matlack <dmatlack@google.com> wrote:

> > +	/*
> > +	 * This device was preserved across a Live Update. Accessing it via
> > +	 * VFIO_GROUP_GET_DEVICE_FD is not allowed.
> > +	 */
> > +	if (vfio_liveupdate_incoming_is_preserved(device)) {
> > +		vfio_device_put_registration(device);
> > +		return -EBUSY;
> 
> Is this an EPERM issue then?

I was thinking EBUSY in the sense that the device is only temporarily
inaccesible through this interface due it being in a preserved state as
part of a Live Update. Once the preserved device file is retreived and
closed, the device can be accessed again through
VFIO_GROUP_GET_DEVICE_FD.

EPERM might lead to confusion that there is a filesystem permission
issue?

> > +#ifdef CONFIG_LIVEUPDATE
> > +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> > +{
> > +	struct device *d = device->dev;
> > +
> > +	if (dev_is_pci(d))
> > +		return to_pci_dev(d)->liveupdate_incoming;
> > +
> > +	return false;
> > +}
> > +#else
> > +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> > +{
> > +	return false;
> > +}
> > +#endif
> 
> Why does this need to be in the public header versus
> drivers/vfio/vfio.h?

No good reason. I'll make it private.

