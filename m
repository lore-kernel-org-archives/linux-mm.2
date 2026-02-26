Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 76C23FD9E1E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 23:31:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B1B276B0272; Thu, 26 Feb 2026 18:31:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC786B027A; Thu, 26 Feb 2026 18:31:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9D1746B0276; Thu, 26 Feb 2026 18:31:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 859286B027A
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 18:31:51 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5363557141
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:31:51 +0000 (UTC)
X-FDA: 84488207622.18.1679F7E
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
	by imf03.hostedemail.com (Postfix) with ESMTP id 794D220010
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 23:31:49 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jzt7dDCK;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772148709;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UQ19nP7LWyVtbwlYCJ4KZaeb2FLacueUWULaQoURJXE=;
	b=YK6zNiT+AUHahbyoj/ZwNHScuh96Airm8/WCUOo2AAHVAuC/Ll+1aBcHkN4kdrf+fCPplP
	QMXDOM+0uHNTszI0UzgPJbD9ZtGPZ+4d7BAFsx5rQVeHEqC9oaaZLW9vze6xrmPtjdb5aJ
	hMyhg2+X24qkDNI8OjGn7d4a4yy3JrI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=jzt7dDCK;
	spf=pass (imf03.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.171 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772148709; a=rsa-sha256;
	cv=none;
	b=xsEzx+f5DkNdVX36mJwYhbK5OA0Tpg/s92EMDUkgOQOFABTmusRlpA6jSUjjfNv4ExG7zO
	lEVSReZexQOpaw01kvp64EsYPNMhgZl76FeXWa7c991yQ0nGM4+4sQPJSFfW9ts6d+SGAK
	lVZKTb1a0p1wQwwqFEAAByQhe9smHgc=
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-2ad9f2ee29aso8851665ad.1
        for <linux-mm@kvack.org>; Thu, 26 Feb 2026 15:31:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772148708; x=1772753508; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=UQ19nP7LWyVtbwlYCJ4KZaeb2FLacueUWULaQoURJXE=;
        b=jzt7dDCKoAH2Tre/EneD+sX+a7b4YkHRuZL1dXXjza07h/Le4vPxvKxMkvnAl0paUt
         mvQ1HefNBA9lAtZ7le0yFFMbZCqRZAAXkTNGU+WMIqVhJ46evcLw7/y1t6IWkhfxVCFl
         4YDAv04xJ/I7mXEfyN4TAYfZ1fdFx3VVJjjO51dYJ54O1Y+6fcW0WP7hJQpHbeR3z+cP
         J8z8QbdXX4hMZdXmOyleI1n0TkAC37p7ib1xBWuzKlGuhYyDfcJctEI8ITTUb/gc30Lb
         URkSiKoGb/pYCIvahRyBnHla/Em12VnBl6hS2HqadTnTnFYArtw4NqlMBJ5s7FAo8ls1
         VV3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772148708; x=1772753508;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UQ19nP7LWyVtbwlYCJ4KZaeb2FLacueUWULaQoURJXE=;
        b=ez4ehVNSwVnB7aNIoRvJUmKT8QGAHuSIdyVDnT7IuH3BhYCk8ekpXm75x9SFcEYGx9
         V4NNzgCTBbyOvu3h9GlQYvyXpVl2WPwqm72KT9x7gNDc2S8KkRVwc5g37seAKhdGsNzK
         D2HX7GG7MA0entHF7onL4V0ZgsWd4kVufAvKvjU7+2E+UeEi1upl8g5P5x5slKk46KOS
         79vv3hfWs1CyB79m0a4lAxQ8SVJ8SlziZAlXK1BOGcLqCf28+ksS1b4BbRccWJ4DzuOU
         tQiBnrjZ8PFsUUUs3alvYAeo3JBJotpjM7YCo+qjnjRoi2uWXyq0Tj6F6xvLAiJHEMfi
         QLwg==
X-Forwarded-Encrypted: i=1; AJvYcCW6wJm9ki7v8ZwtYqX+9MNpUVuuaAxAW51Z20IA9vQQFZ1a8uLAQbFs+iNggpJ+udbTQYRYhq230Q==@kvack.org
X-Gm-Message-State: AOJu0Yxvp0EYQsSR3nbiTFtcgAHuf51qKGp2JNZEIbizmhSPdGTB14l1
	lOdn5rMTVQ+nyNaqOXzRpcZdXGPWL0uT37LL+5yik8TdjvoylrN7/XufXOvcfZgz1g==
X-Gm-Gg: ATEYQzzYzsezbwIP9g1BguT2n8zqlQFuJXZqrtp99rj6Xlkols8GAiCU0jF+EHdpxJw
	ALI5rS2xCfoy+5Ds9mmNovDERwggk5nXK4i7jIsKUN7x2gbJ4rB/A3EcY0M1cwbtNfTC7z/NsNJ
	g6Gv7D0W1nw/J21CmSL0ljjpAsNfwlWXJ1dUdHawBDoGqvEtv/fvISu0fFqxcJnjfr189JXLb9G
	aLjyGWnYxQOq7BNU0Ri6JwIxbUvfE6v2QMDfx1bhGcjP2HAmCRa4la9/AZKni6pPdnqUnarnN7V
	K1Rg4opd71KKCrvhhlD9UvAybnMr0mwX1o1Hn8RllL9mkgJIJWlyJB7r+L6IWAHwDsejJTo5MVj
	2wxN+Q1W2fjv9h9SshuYnd2ib88srorR3vF/3KL6V3EWuPQqsmh3nVF0i5W5Zjy9FJvAqycXx4v
	FQtSdvzc9AAqGUDiJyR7NE1ILQmfa1/7qLuoYJzx2Lr8BBQn3lO+srPynYVJefWA==
X-Received: by 2002:a17:902:dacb:b0:2a7:919c:34c6 with SMTP id d9443c01a7336-2ae2e4cd74bmr5371545ad.38.1772148707814;
        Thu, 26 Feb 2026 15:31:47 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2adfb6a0432sm53850525ad.52.2026.02.26.15.31.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Feb 2026 15:31:46 -0800 (PST)
Date: Thu, 26 Feb 2026 23:31:43 +0000
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
Subject: Re: [PATCH v2 07/22] vfio/pci: Notify PCI subsystem about devices
 preserved across Live Update
Message-ID: <aaDX34yT_3dwUi4I@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-8-dmatlack@google.com>
 <20260226160353.6f3371bc@shazbot.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260226160353.6f3371bc@shazbot.org>
X-Stat-Signature: 4wx5oaaesrekuj8ox4msghinqzhgrhek
X-Rspam-User: 
X-Rspamd-Queue-Id: 794D220010
X-Rspamd-Server: rspam04
X-HE-Tag: 1772148709-534343
X-HE-Meta: U2FsdGVkX1+dKJ7QEGKLPp3uVQLsRxGmzsnYOxyMJ4n7+QJjWwXmf46Q95H351LMsjE6ZEN1n90TlWuaVkO4IJ4O0zeHYaN1YN5gJWoxNZ6viHG8lywghO3nFfPp+5qmaFPyhiM5g3Vd9eU2FDg01zrspVKbdkYahtrdLpUx3nSqj1couMXf5TdI3RBzh99qHlfP8R7oyJdlbJttuZH/xpxwxWiuqhQvTb46ORNhqFjiV35QDjUJo75JTJ53um/EDTnGfo6Bi3lNxfH9lScat6CwimsgyqP/B+zTf3jOm2sjhpDnFviLafdXLkaD5UsM9qvW2wftKntdySfKMcrJjBeNUt4F+5Rr60l0tMC5tr2S80uhNBb1lmr4OvcDHmpWcoy9IXu68Gq6Iwtvz2dOb/99ndxpX5RmmaAdN+K+puvMRAEPIoHwLWwhhaMgn6XGr/9GBfDAupZbQH1IhR16839kv+B4qcrlcz2muqAmkYIXeCAiJJ3Vty9WDTC7EnUDleaP9fipw3DCcPipS1whKE+nphKC4EJ0fk1afXgH398MN2h+2sjbRvrqierSF7uoWDsHDnVur+/JSdziriFbdZIZU/ve6WMLtP4n8RdIHt72v5BiNikPb7kxIGIKmCPqg2uwrAbWbEAZETfjlVPr+otaQAU/8E5KTXkxbvf/beRZsIYxQkjt5w8hFNlb8SmmmYGYo9ohVBv4Xk0Su+iMYhO/edb2xo6cd7f91o4C4wnyxkcxW6O+Ts4+yx0RuOTBcDeWBGsAX6EyFZQpK2qYLTcLHycqi1OT52Y7HwErhdZQDi16ytwsCT4HFfxgI7+R6peB4h6ei2PxL5UrYzDWC0mcONRUYubG3uMTDYZC6Mc54GRn7vrkepqSQYG/ASRMz2LR/FzdmaUK2Er5U1dey2y9n3yMpI5q3GCSC6b9aZSPkBwsIGtZcw+yAuClQsnsltKCeFxTmbuR2R0RodJ
 c8w6bjhB
 UiI1y+7gTjX0yrHyNadhNlOCtGH0FJTypvWmXwe0vtSTlYrhZ+vHKalnlzmSIkIKJGEcZvhA/36NBOEUes5rQE5h/dP1rK+R9ScLIhiQw570Tu2nTDAjMjzNorT4CuixyDu2UsBBHxePu3eM7T/YOjp9xFaXxofrmzjwLwwjKbCr5a1seY8K33vMYKcAWyERfRbB3uc3Q06rDWCx0J2ApZuXMqTGcMjQ3RYdtBGLa/GPpjl2990W7OrVefZHDfXAEddjLB4C+jmWZ3Zb4Sg65OIdKbPcsu9JCp0Z3xAE45D6JTK4LyIjz9dZP8Lt9d+AbVqVz/5RWsGCBcXSV5D0c+kawMy7VqocTkX1x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-26 04:03 PM, Alex Williamson wrote:
> On Thu, 29 Jan 2026 21:24:54 +0000 David Matlack <dmatlack@google.com> wrote:

> > diff --git a/drivers/vfio/pci/vfio_pci_liveupdate.c b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > index 7f4117181fd0..ad915352303f 100644
> > --- a/drivers/vfio/pci/vfio_pci_liveupdate.c
> > +++ b/drivers/vfio/pci/vfio_pci_liveupdate.c
> > @@ -53,6 +53,8 @@ static int vfio_pci_liveupdate_preserve(struct liveupdate_file_op_args *args)
> >  	if (IS_ERR(ser))
> >  		return PTR_ERR(ser);
> >  
> > +	pci_liveupdate_outgoing_preserve(pdev);
> 
> Why do we get to ignore the return value here?

Ugh, we do not. This is a bug, thanks for catching.

> > @@ -203,5 +225,6 @@ void vfio_pci_liveupdate_cleanup(void)
> >  	if (!liveupdate_enabled())
> >  		return;
> >  
> > +	WARN_ON_ONCE(pci_liveupdate_unregister_fh(&vfio_pci_liveupdate_fh));
> 
> This is propagation of a poor API choice in liveupdate, the unregister
> should return void, it shouldn't be allowed to fail, IMO.  Thanks,

Ack. I'll make pci_liveupdate_unregister_fh() unable to fail and follow
up with the maintainers of LUO about liveupdate_unregister_flb().

