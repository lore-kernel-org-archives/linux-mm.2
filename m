Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A28D2606A323
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 00:24:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=PRWW/5t7
Received: by kanga.kvack.org (Postfix)
	id 86FBB6B08B9; Tue, 24 Nov 2026 19:24:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F93C6B08BB; Tue, 24 Nov 2026 19:24:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6E73F6B08BC; Tue, 24 Nov 2026 19:24:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4C6646B08B9
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 19:24:21 -0500 (EST)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BCF04C0D6E
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:24:20 +0000 (UTC)
X-FDA: 85471744680.23.2699C64
Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	by imf14.hostedemail.com (Postfix) with ESMTP id DCB65100006
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:24:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="PRWW/5t7";
	spf=pass (imf14.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795566259;
	b=oG8U0ji+HRAFWtt7xn9EPgM/8+ecdeycVihx2uIz6JmAZij3q5hflMousXHvC/0XjivA1k
	4rDlX1nqZxRexLxIndJ7mFJoBYDmaZqINNsOo9Zo+TJsr/dJJcr+AoRpCl7ioofjBHaozW
	FnM9wS+qFGrR8P1NwK5UWLH/UIN8ZXU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795566259;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YMO/Q4LHoS6IxvSYVAkwFpWA6bWqlpOH+BNCvhBFP1g=;
	b=yE2wq+IFi1Ub3sGHyCixvXlIwG4Vn6gq1L2Y6JcI221R64XHG9JB65FQKkW6wesFptvmdy
	psAZg3HHuP4Ygrn7dRSOuLAULaiqTCrhw2hQSIwoRP0o84XifbfDYgq+gNCaOVMH1bTamQ
	9YayEbpNW5hHLMKz4g+Vxu0LrAUFxrc=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b="PRWW/5t7";
	spf=pass (imf14.hostedemail.com: domain of vipinsh@google.com designates 209.85.214.169 as permitted sender) smtp.mailfrom=vipinsh@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2f0afdb97abso162645ad.1
        for <linux-mm@kvack.org>; Tue, 24 Nov 2026 16:24:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795566258; x=1796171058; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=YMO/Q4LHoS6IxvSYVAkwFpWA6bWqlpOH+BNCvhBFP1g=;
        b=PRWW/5t7131NkyhorN0r3v7GbZ86xUebB9TenoW6Anen7EM8sV2zToV+7KjzQsmOC4
         lpY/Hsg/4MoQAwzBFFtwrSC8XmANB2YofbImvIqRGpbasOw/uAUcAx750tokwqcHTHW7
         RaHu4KEE8D/RBHq+CECvm6F3gnpkKndl1DOMWIuNQnfS+KuNLfwiEAeNZflwvv54Xf+X
         Vonl2k0sEk3Y9kjFrm2MEB2wbSq2k+ob7nbbCWln/F4cpPHggbEqiqxs+Bqw8kwSPUYg
         MIlWJAXVHK0Vq2RwHIJGuNadl58wzzjnK9eGeSGPRPKJ8Tk8uaaZiFrV28sbrXFzXeWW
         4Ucg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795566258; x=1796171058;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=YMO/Q4LHoS6IxvSYVAkwFpWA6bWqlpOH+BNCvhBFP1g=;
        b=ZvWKQVuUQtCzm/FG43cFr4L45+pd30vb5YqhMhP382wrZWUOkCRcAv/xFAlgj34HIn
         QrRU58kiD4UuOQ2eWUOfuhQXHwxyl2zwcLiH/EDQ5eqKNkFV4iWgbH2U3F34boa55ntC
         zZVJU6FJ9dlvXrKSpfCoChxEy9hfw1fghUvdQp5gScalfRuPNAlN/+sGFQhsw3lyjp/N
         gcngOo3VEOSqwAzeIZlitlVtN3GQi4ge2WZNVGs22chFtiUgnJU8hr/FLVlKruag5CAl
         gRMffgfPtqJixWk+7TsOlfqT+QR+iVWCrTi790tDTakAfapD6wjoNrfTFh5rLKjJIKRc
         wdaw==
X-Forwarded-Encrypted: i=1; AL+hErG6GlVgrYDrwmDoU5z5EHA/1vm2kQyRX6hS5fjZZuYJkRJi6XiCoiczhNxp6eVS3SMTd+UQvp/HoQ==@kvack.org
X-Gm-Message-State: APuU4Z/+pVItcghSrdDfSEYR3/eST5aC8RL/9UIgrLOcjFSoRM/Ycx4m
	YTnW4as5tUNZ9ezi5iJiqsJBqBvJzbpolSI9YwbiZPZb1IY8ObmSEnqPtRO64biBuA==
X-Gm-Gg: AZFdTZfYF+IjZ3St7sSqd6KUc0No6dTnbOc/MnFzQeT24yu8uebF1YEyWVCPEoR0BDH
	eXa/XeFt5SWNw5gvHypn7e5b2sMvgQqdPHaFDVwm9qv3PQ+4V6f5f4UavWuz47OaQjpxCS/eT7N
	aPn0pgaiPI6tqvXnuZONtZqC/q84J2j7d6yyT+aoKJ7zXczpLjW6vrYqWvJj2SgepDOUMkmhRRD
	EsWxpSE27MMQJX0ESlZljGB5vf84Pz6T7o0qPP1wtrIE8hJnxVQUtmmI8NQZ6DGwvx29q7JMhFQ
	r+8juEbg6dXa4vjjsFbkgHrJC/E3GsR2BHOQE9NZ9pnJhbAjaobGvDBhLC28i9iBnrdHmgohNXZ
	xAu++LzjkG02CyH28pe0IJsuDYtG3X/K/taq0y/CdW4JzNr4lK86cAwHCbfVvWnmWsnZk3ZIlEE
	nZ67T8bm6nMlzPTp+sWRFcvVn4kzlG7t499lP5anx4SQGGHwhM0LpSIGmP5XyJD5K6klP8H/vaa
	fmd4KP4MXmhxwsxR4oDLWv57datG58Mzorw04qTbJiUy7JXRJoLnwZXrPJcYzDyPQXbR2ctbS31
	es9RoCnChYfeuZcwX4GVVKWXFxJ75pJmzdiNr7tF3v4vMSQyK6HwbFMM103GyrptbLoIe91HckE
	bdsLTIguXm/jJ
X-Received: by 2002:a17:902:e950:b0:2d5:c090:3810 with SMTP id d9443c01a7336-2f06242bd42mr16475105ad.2.1795566257244;
        Tue, 24 Nov 2026 16:24:17 -0800 (PST)
Received: from google.com (176.13.105.34.bc.googleusercontent.com. [34.105.13.176])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-cde6cff4c1asm7632022a12.15.2026.11.24.16.24.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 24 Nov 2026 16:24:16 -0800 (PST)
Date: Tue, 24 Nov 2026 16:24:12 -0800
From: Vipin Sharma <vipinsh@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, kvm@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-pci@vger.kernel.org, ajayachandra@nvidia.com, 
	alex@shazbot.org, amastro@fb.com, ankita@nvidia.com, apopple@nvidia.com, 
	bhelgaas@google.com, chrisl@kernel.org, christian.koenig@amd.com, corbet@lwn.net, 
	graf@amazon.com, jacob.pan@linux.microsoft.com, jgg@nvidia.com, jgg@ziepe.ca, 
	jrhilke@google.com, julianr@linux.ibm.com, kees@kernel.org, kevin.tian@intel.com, 
	leon@kernel.org, leonro@nvidia.com, lukas@wunner.de, mattev@meta.com, 
	michal.winiarski@intel.com, parav@nvidia.com, pasha.tatashin@soleen.com, praan@google.com, 
	pratyush@kernel.org, rananta@google.com, rdunlap@infradead.org, rientjes@google.com, 
	rodrigo.vivi@intel.com, rppt@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com, 
	skhan@linuxfoundation.org, skhawaja@google.com, vivek.kasireddy@intel.com, witu@nvidia.com, 
	yanjun.zhu@linux.dev, yi.l.liu@intel.com
Subject: Re: [PATCH v6 12/27] vfio: Enforce preserved devices are retrieved
 via LIVEUPDATE_SESSION_RETRIEVE_FD
Message-ID: <20261125002302.GC3545683.vipinsh@google.com>
References: <20261102153656.1431701-1-vipinsh@google.com>
 <20261102153656.1431701-13-vipinsh@google.com>
 <DMZLVV5YW6GW.1HMW8L8NIQ1XR@google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DMZLVV5YW6GW.1HMW8L8NIQ1XR@google.com>
X-Stat-Signature: nmhbxf517pnddtwxch4xmktaphqgtbpg
X-Rspam-User:
X-Spam-Status: No, score=-18.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_IN_DEF_DKIM_WL autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: DCB65100006
X-HE-Tag: 1795566258-751780
X-HE-Meta: U2FsdGVkX19a8MXuuzOqo1jRRTgkD0P0SDfjY98axVpzRnkcgaZ2oPepkmETbVTBoXKuG0fDD8b2G4tPdPRzko3VTVR4d4WiUl5zHWEbouLQcyNFHA0KRt8zREOF0TiN5SpPyi746phbbBMngO7CO5cJ3MRi0J/1AQ6m+RaqhXFk7X3V3UDDNsvFK7AhI0JBa1r7B2KayfIDueO0q8FvZebLWxbVVi9cldFDdvHeyk5vSCO4/I5LxtqcBa+c9wwus1yEmPp8rvlXeKskgRUiimFGJNzP8ac+XpdubSmsreJLXWkVA+mREpreRdIwy7KfIUW3bYa5cK/SLmDWOf68UjLyTis/G8V6BbJVJLncQOD2NgNZ/e6ZkAqx4rJ8sNlsIlScXUSSlOFQkFRN4wr+u4Aev2Dz62rfsPs9rRal/bgIrv6G62itZEHGKh/ds89HbV7R2ZeO4LneHUHvgs27XPm2lc4iGsWdbUmsep07VKNyV0Dw/vTiPC6RZngIi1oVE8MXwqmc5sfvFbXF1vOr9Ui/jGo1emk+1XRcbI9V7a2a1MFD6AOzROCztY/x24TRVKqSs1AkSKR+0RoNiHc2axF6dUwQYqY2mFQUXaQDeZcWvvIl6NyrYBgVbOEeKWWM9yGByPMc+sOJ0GR57pFgBkVFkMfZnbx2H6DWRLFWXfpQhfLWiVrGJeyUj0Dil0w433DkZ3wpTGghx7yPLttJE3iBajl5cEQiqp8VUP6Z4UsF/UneDAKYzHtYGC0vlzsbXVZTnGVD7BNl+ZKtgl1pNmQSO8VQNq1KrzIKljHgIINVyc0aX+tR2m+lk78EuyrwhrVU3RQUEf5SxrS2MKqboLBvvseQs15oBhYW1iAR9XKhJV/DzYr4YCLTcn0p5uL2t3LSnmSLsZXla/qkiA40Rt3W5jL0/VfmuIfPPyuFD+HGFls/gGV5HN52CQBlvwkXLSwABCYjEVKhpsMX5CM
 U9cONOIW
 odPWb9+S86AaA8BmGE1BonIwhY/hwN/3DaQMXKa2/cEZeJJ0hlmpuXT+wzRglmTc400gA7kMw1PKhC7GdqnGStJ8IXhjh+GPnYwfZuUN87vT3aVNBk5Jb/5oeiuHZv7vawxTT7+tDofqi5MngOXS3MUO/9CgwRTFYmYMwW/xdLJ7J41Q19NncTFF6/06UYfYvZcu3Y07daWGkUlJpPrpCj6R8ln4DS3g+D6yHJvI9gPl+eBD8drwpsFgwy69xGLcyiPzzMnjpBzNYhh/8yfCgEP6/OpNEJJdLkqwyVdXz0rlJp/KF7/Qa98ccfQUCwrRdS1tceFYD2T1gUlqKF4rMVCvWJPQ9G/5/VewUCKtVzzqEx+NuhbuUQRG2qSuiwLOj3uKKa5OoyRS7NG6JKQafTvhmQ2b45seJnfd7X+qX3YXiU8xgHV9p3/nulmrG8TQqjR3bQ6m1YXZt9lw74diRCJ1zAqBNLj3nRc5+HJyzqHiS33zIQyaY3VSNaNa88mh7hEY6J81R5ai9Fk1cqz2Jf3v6HW0YM+qBogXV72QFpJeHOx7ITYBR3B53fEXMGJQC6IXJet3G4Svy2GgQBAE3TfkC2DeEWSW/klVQjl47WW5CLGy25FA+EaqCUzTj6vVqAyY2
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 04:19:34PM -0800, David Matlack wrote:
> On Mon Nov 2, 2026 at 7:36 AM PST, Vipin Sharma wrote:
> > diff --git a/drivers/vfio/vfio.h b/drivers/vfio/vfio.h
> > index 12557d45dfee..e6ca4c3fda06 100644
> > --- a/drivers/vfio/vfio.h
> > +++ b/drivers/vfio/vfio.h
> > @@ -11,6 +11,7 @@
> >  #include <linux/cdev.h>
> >  #include <linux/module.h>
> >  #include <linux/vfio.h>
> > +#include <linux/pci.h>
> >  
> >  struct iommufd_ctx;
> >  struct iommu_group;
> > @@ -446,4 +447,21 @@ static inline void vfio_device_debugfs_init(struct vfio_device *vdev) { }
> >  static inline void vfio_device_debugfs_exit(struct vfio_device *vdev) { }
> >  #endif /* CONFIG_VFIO_DEBUGFS */
> >  
> > +#ifdef CONFIG_VFIO_PCI_LIVEUPDATE
> > +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> > +{
> > +	struct device *d = device->dev;
> > +
> > +	if (dev_is_pci(d))
> > +		return pci_liveupdate_is_incoming(to_pci_dev(d));
> > +
> > +	return false;
> > +}
> > +#else
> > +static inline bool vfio_liveupdate_incoming_is_preserved(struct vfio_device *device)
> > +{
> > +	return false;
> > +}
> > +#endif /* CONFIG_VFIO_PCI_LIVEUPDATE */
> 
> No need for the ifdef here and 2 definitions here. If
> CONFIG_PCI_LIVEUPDATE is not enabled then the compiler should be able to
> optimize vfio_liveupdate_incoming_is_preserved() to false.

Okay, I will remove it.

