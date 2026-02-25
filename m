Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70737FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:15:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9F4C46B0088; Wed, 25 Feb 2026 18:15:52 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9A2B26B0089; Wed, 25 Feb 2026 18:15:52 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884596B008A; Wed, 25 Feb 2026 18:15:52 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 772526B0088
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:15:52 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0E154BB058
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:15:52 +0000 (UTC)
X-FDA: 84484538544.07.42A0DD2
Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	by imf05.hostedemail.com (Postfix) with ESMTP id 37BEC10000A
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:15:50 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IpvEwr+9;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772061350;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+aqTMCmmaBlC6BgaLKDJu82UvyrNA1bTtUP5fONJU9U=;
	b=N6UCu2F5NaSR7hwUcM4jUxpEWo2i8quKJZHDchO3rme4reGpRhipKX9DoXYWMWc1bekyJX
	KMcSQ1jCqAf/Uf2g+SHBnL4WfvU5dbLIdTpPhW4JExG7EW8RaxTA4HBEYye/zqcsfy3BF5
	q39dCrMPmbESeQGagij0xKCmlVoFQI8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772061350; a=rsa-sha256;
	cv=none;
	b=KK/9sq4788tX5n1zxaEsnWgXC2mWN3v8772o/SJqy2afEYhg7UVoFYNp2ZqQiVIy98aDM4
	93sU9iZt05pE0e5OfuTimDkLHe772fFX0jici8LMjjde9udSVOHwJXRxJNZodLmMKtUgOv
	rs/ww2+xXQ/+LXnQe8jsvlf0oaaqYvg=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=IpvEwr+9;
	spf=pass (imf05.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.170 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-827390e8a3cso154522b3a.0
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:15:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772061349; x=1772666149; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=+aqTMCmmaBlC6BgaLKDJu82UvyrNA1bTtUP5fONJU9U=;
        b=IpvEwr+9EEheU9DF+Vy14RrETnnZVefClJDaMoKwtz842lpRpecK9mpX1xx6wwbq2W
         jaaPi4T5PvXnoNXKuviZZ8Kpl83dMo9LW0xrBm4U5JJ/FhGEl5Uw1vXA8Uc/FwBxDQ0/
         FA4E7tVUDUe9lndHMo+QKBGH00ritx6Y+RAD4WrGAXu6hjhRHXVILaH5mxiSzvs4kv+7
         GZFF+btdU1lEaybBYPY+Aenllg8BNc7eFIT+99VKawqg4iB1Rmrb5suuhjn5bLEnT4Ny
         RvA4j53BEd98+uV+GjF58D5avn6VlscoALXn3YKJCoYgR9712GnA+ezFcFANoDU7au7w
         x0mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061349; x=1772666149;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+aqTMCmmaBlC6BgaLKDJu82UvyrNA1bTtUP5fONJU9U=;
        b=YfXVutDOAk7RO7kUHZ2cB/e6jHLHKjsA7o5ZhxFQwr8sJy/kzJIETf3ulUzEWfv3L9
         /aNvvZvFnBpAXaVDtv4m7IwsUY3Cx1IYEnKYEor4+pmseuKBR/CLPSG0IvOOnoU5uNnG
         NEcu+MWydkkmaybAOmDs24L+V/NjpovQO4uj5qGKXZbJOa+KsNZVObGkbnWUOLWEqGQ1
         CJSuQjjCQdrYqm/hz9nb3RqB0z5qs6y+Pd8KTuhvV96N3kD64gAHO19uR9WqLpQphftc
         dksaZOK6DZgElbSHRviVv5IthVpBzpnhMHdlo8OOk57PQ3Qt7/quBZRsovKzGIiBTtZ6
         5eTw==
X-Forwarded-Encrypted: i=1; AJvYcCXtvOr7xDKbcJeU0Q1k6ynAu2t5ca75JlMjpI936RmZAWfA9xUyidXmC9PmnbCBWZ1o2RrDmF/g+g==@kvack.org
X-Gm-Message-State: AOJu0Yzi/YGuAU1VdG36SxsInEeA0R5qC7MnLvx7K2slNPaOQ5bGTzFo
	zmA2/05XhlEG2k2A+le0jUsSz4q9lGWLLzp2QpBp19MHWGw7MY2QEqvTdD0AhA4V9Q==
X-Gm-Gg: ATEYQzxRY3canU8hD3Wer66AVJW9OKjpVjY+Zs8dshN8tboIQgfxWrYWTosXZng+uTU
	Ve0twKMwpnsuIa7aNtt63HUU3BpjpFFzmkdeDMPof7Z0I1YXZ2F96Vq+4tW5nRaFY2qyOcwmKIp
	uX8n/1GuD2aC06/dbZubnHP9DEHEYLmHhx1PSmtcgrY/DAcQ0gYtCWyQzX5Ds4exQlPu6Yi79ap
	Ao3yDFXM/xSb2YTD6b5Tu9F4wq+A3OS9VW5SZ+8CNGq8IfgbBQi9O0XaQ2WZmJarouXSQ1FfB1A
	wBgPBjkkSb9Xa6suAOuGZh+b/k2Ptcz59Y6O8Xq3WuNagnBaIVqx0/I/fsx91tDRERWNsFVR7If
	M0BGGvWTtCoeuCydyVBqWCqLfPWNo/GSl4qeJ2jQtdlfZCRag/qzbKBcOKb0YF7ShuKH4dQVXsn
	wAKeKqDLq5tZwiTf0W4PX74JbTkcVrcHXx1E9STzv8wF8brIRUGiYvckO3Gg4nEQ==
X-Received: by 2002:a05:6a21:7e0c:b0:395:46aa:4467 with SMTP id adf61e73a8af0-395b1d39ecdmr623014637.14.1772061348571;
        Wed, 25 Feb 2026 15:15:48 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-c70fa8479aasm89953a12.31.2026.02.25.15.15.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:15:47 -0800 (PST)
Date: Wed, 25 Feb 2026 23:15:43 +0000
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
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aZ-CnywNgMnr6f1k@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <20260225143328.35be89f6@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225143328.35be89f6@shazbot.org>
X-Rspamd-Queue-Id: 37BEC10000A
X-Stat-Signature: 493dowt3yxibztbx1fm5pwfhbbrksr3t
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1772061350-170433
X-HE-Meta: U2FsdGVkX1+jJudb9/6+5x/NrJD8q5H31sETcIYRW9AlBp1iWJaSvEHqgz/sYBPYj7+V/05IclBNZnYXdL3K5ocVmB25e06qyQWi1Z2HZsHpdttyEdfdiYxnrmcfk9gFi95BXoBZIuxU0iG8D5E3wMtn0YGk28XUgMsp5l5ylvsJ31F5VM2QiABprs+buYOY2WO4jDTxkrdt8sRV8vXoeFoO7eFxmiwyiyEOQP5R+++46VbdKgQm+OZME+nQy9ER7jkjvrOGJ2YZsiXtNY4YZ573R53YwPqU30wNdcrOPL+TQ+J5aJDFbEQ4Ut/SEgd1AY0a6zMjYIS89lFsecy2Ah1ui94oIQZ0u2bp3shC2Cx6DddJZ8fX8wGZTPUFuGwVYJNGuj5of+Awe9as544DkbMLwUa7a9viGCnbt2NZncmOzARiGju9Wqm3xVIw/dbb45ruTMS6bPskSSGqORRYQ1n3P9/7SvZ8V5yNfVJxgw513bzjvwNXGOoR/8Hrtg/KsmSppLUdEJo05XZk0C6uY4dSLo199clJ//oQ7p9lNTEtYUCJDrmvtM/cUJDA1yh9lIApWdlT+4OyGDBVfQMwwIp2BLB5NLW40cGxERJ4C+upQsary50shL3npO+ZYGGNLH2cY+W0VnWGHDPtIe/fnlOSxByqCfPmiIPeoyxaQOdOASzl6zmnonb+UeVX58LGXtGd2lAZRZygEoPvlNm2qVSXchGtav1z1cW3NYEhKst8vxsO0fiSWlAhZqSO7n5KEN1BAuMJzkg7UzPf4L49D1BwAdFo6WQ2UmZrjoUN2D+hWP6JbquxFf7V+jvKgvb74/Qs5et9IppHnGnAShh7QQiLHiP0kg03PB3RemZeofzYysSNpY4yxzJomcGqERr+qxJkPuAEEEqq5vja49o5FkWpCZqcqoVIBBO+uVEef18hclSjNgA7OVNg1Cxhue5t8w3aYLAHahkijwk7/wg
 bBWk+6e0
 mZWT+37BqsQG+LpCc+xz5ofPdbzas1Hzwkc/6Xqp1hXuiaXAHl1DxXfwKtAEL76jXzFXrSQdQvqStyQDX4/9fuyaWI0W5i3pulJ6v657zeC1tdeu9nB1D/9rbPdQdSgvtROSTdKW2/WgFwIKdfbBWQQwoPEY6ZaY8Yfd9ZWacY3cXm6Mw5h+2gsMITvKLEbJm7L4Bd4pXo6rP4tBzwuIlXLsydavTQ/2KBoj3aqIlEtIZLj4mdB1hMXrWPK3OXCnTbngAReBzd7oUGjT53O0BWrKCTcHzm2DU1+sQChtVWh48Z08RVApd0pHOp0wfuwanr1egrDzc0cNTVKUDz5a2pgztIxYoGXKIfRZF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-25 02:33 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:51 +0000
> David Matlack <dmatlack@google.com> wrote:

> > +int __init vfio_pci_liveupdate_init(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return 0;
> > +
> > +	return liveupdate_register_file_handler(&vfio_pci_liveupdate_fh);
> > +}
> 
> liveupdate_register_file_handler() "pins" vfio-pci with a
> try_module_get().  Since this is done in our module_init function and
> unregister occurs in our module_exit function, rather than relative
> to any actual device binding or usage, this means vfio-pci CANNOT be
> unloaded.  That seems bad.  Thanks,

Good point. So a better approach that would allow vfio-pci to be
unloaded would be to register the file handler when the number of
devices bound to vfio-pci goes from 0->1 and then unregister on 1->0.

