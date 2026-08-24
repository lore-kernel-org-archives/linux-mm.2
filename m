Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C99CAC5DF9C
	for <linux-mm@archiver.kernel.org>; Mon, 24 Aug 2026 20:02:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C50846B0092; Mon, 24 Aug 2026 16:02:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDA136B0099; Mon, 24 Aug 2026 16:02:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7AC26B009B; Mon, 24 Aug 2026 16:02:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 679C96B0092
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 16:02:53 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id E545A140255
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:02:52 +0000 (UTC)
X-FDA: 85137236184.13.CB0B2B6
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	by imf24.hostedemail.com (Postfix) with ESMTP id 1AC79180003
	for <linux-mm@kvack.org>; Mon, 24 Aug 2026 20:02:50 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H0tdPHxX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787601771;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2JSlxwskXTbuoDvNvgTyyULaG2qnymU60jxRuo89A6s=;
	b=B13fZKh1VuNDnEQOOsQoPobR7dzZ6hCTww95UxDwOMOdxMK7EWXvu4vh+dWmDPeu+zLMMu
	N32627vKBHoLuy3V4lL9zf31rZdPxVAdMpL4sdG52zaAqQKiVYlq3+YmwEdVB1h4jVgd7J
	LqvXJpQb7t5LVKkUVs/QVVhxJahMwqA=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=H0tdPHxX;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf24.hostedemail.com: domain of skhawaja@google.com designates 209.85.214.178 as permitted sender) smtp.mailfrom=skhawaja@google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787601771;
	b=ozE0OJ/Vfn8l53AdrzYQ9VIYdIx8y8Tha7axS/i7tdhxIXDPczqLbR6LybzzNNKrJPpV55
	vNjQEDg8Uh4IgjHBc4mXmG9v1SbHvbZf5P2qKClQPeqvBBM4lrtD/Q//5on9A/HcRLYjEF
	TxYTnd8cdUzWSZTp1e45h3CWztY7A1I=
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2cede6375caso34555ad.0
        for <linux-mm@kvack.org>; Mon, 24 Aug 2026 13:02:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787601770; x=1788206570; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2JSlxwskXTbuoDvNvgTyyULaG2qnymU60jxRuo89A6s=;
        b=H0tdPHxXV5r+bgKlMDYrER4+Jlll01bOSHkq16JxuBO4iAyHYrDoceiaudtvS9S3UJ
         diiysS4CjqyqY+fXhtwXuvy4Uqoh6OK2oe8lEgCZZq6FvlIQHeoEpJox+Xn0VUFVf+pt
         GEOBomUcPm+ZqcjKBs1BHTNHDMVEIFHb88Fz9AY01ciIPVw+YPLUWhgv5GnVnNZb1ldn
         KZDWWAkLGoSRQU3Pv7od9klZOskKUpPNdLN3WSm91sxoPa+TNBJwKDUcC0+nMGCEuYVq
         uwImVUGdmkJAygDCWhgssZpQu2321YLPzzGSsBlhQM0DqyPmlfTbxihe/nf4xywOGQMo
         SnrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787601770; x=1788206570;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2JSlxwskXTbuoDvNvgTyyULaG2qnymU60jxRuo89A6s=;
        b=e3pX4Op2Nq4B34hxhPUJIoE1Zlqn9KNNWiRMePcuT6UD40RL4Wwf55yf6kM/0gwsJ3
         ufB40j+u6aFwOgwsC1iVorAb0xPbcmte5AiQf4AXMp4d+hqSRHM7YO+yxv6Gq6r7KLRo
         67bGHTLWVaaqPztOAePbWjecCbQ+/LoHxTUehuRXQiPYmltXmgCgeUvzQye690upzZyY
         oOhEmFphZrteFgLKBZnEmTPBXCzYjz4oo4AUl9Na3LVO9cSf6xCndrLpjui9Z4iigbmk
         E7HFeP+JgRj5+LIHUEfBBsWTH8rQAbctgzYZfJY9fLsA5i5bPtz9eV7ipZuL78y379LS
         2abA==
X-Forwarded-Encrypted: i=1; AHgh+RruE5vmFcyOdDe6vz82IP4hZgpRswYdCswCofkFrTjb36sqlIJl0rlUQkQdiMipUgS8rEGYI/MDiw==@kvack.org
X-Gm-Message-State: AFuF++lBOWuzNLuTPn1yATj9FYW4zfukbTwV3XWpLF3zBqssCH6TC2XH
	e/i1/am/laBG3KJAKmqRZugNCgUZl++xj0s2GJNQub/rJSmw3vTL++qYiemtyHqxUw==
X-Gm-Gg: AR+sD13CNjnvPd3yYYaSBtZrr3eP6M4gTA3nWBGvfp/ruUA3lhnTnprvT4uKibHBtPx
	zl89yn6WnQRcKeZ8kVkAznBVpzZFL2sVeh0UV9tmSzlttoyERQ3L/ce5CIZihNIyRBRvv9X3Dob
	Lt7YG+ktz0mdebS1gmLwFggNcbz6xau53QowGjrhs4mp4qdj39awrUZ6S2Xv1iMin5Ai/w64bjV
	uAQn9ftwYu86drmF8mObQpA+JqrTqsgK+RQQqOVv+UhXhGqa3aTF7p6koFA0mPBXMw5Qn5JACMn
	H4J/vLcheS1oqlK0gfvGp28wBA8p3MzDKFtyVmM9wseT3GJ3KjV8XesiXlMmStJYIJoHMbBENgB
	GZ2welVuDJaCV1H8KXH/ux2+ZZLuNGJkRLDILX/7IVM0sA8nHZ9LxMvB8CNkBxfeKz+Sg3pkM3G
	EfmXGgCfEpqVX7Ii8zELiV+t8aRA4c+cFIsx07hQVITBDEaiPVmn9WhvY796JBp6TpKecaaEM2B
	aHF7UEbRbEgGIEoEAK7oY1DaQnnvCjuPpnxkW0zSqAR5DdxoAdmEOTUfro=
X-Received: by 2002:a17:902:cecb:b0:2d0:1aaf:daec with SMTP id d9443c01a7336-2d6e0830038mr894155ad.9.1787601769181;
        Mon, 24 Aug 2026 13:02:49 -0700 (PDT)
Received: from google.com (210.87.127.34.bc.googleusercontent.com. [34.127.87.210])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-39645da08desm723671a91.17.2026.08.24.13.02.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Aug 2026 13:02:48 -0700 (PDT)
Date: Mon, 24 Aug 2026 20:02:45 +0000
From: Samiullah Khawaja <skhawaja@google.com>
To: David Matlack <dmatlack@google.com>
Cc: kexec@lists.infradead.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pci@vger.kernel.org, 
	Adithya Jayachandran <ajayachandra@nvidia.com>, Alexander Graf <graf@amazon.com>, 
	Alex Williamson <alex@shazbot.org>, Bjorn Helgaas <bhelgaas@google.com>, 
	Chris Li <chrisl@kernel.org>, David Rientjes <rientjes@google.com>, 
	Jacob Pan <jacob.pan@linux.microsoft.com>, Jason Gunthorpe <jgg@nvidia.com>, 
	Jonathan Corbet <corbet@lwn.net>, Josh Hilke <jrhilke@google.com>, 
	Leon Romanovsky <leonro@nvidia.com>, Lukas Wunner <lukas@wunner.de>, Mike Rapoport <rppt@kernel.org>, 
	Parav Pandit <parav@nvidia.com>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pranjal Shrivastava <praan@google.com>, Pratyush Yadav <pratyush@kernel.org>, 
	Saeed Mahameed <saeedm@nvidia.com>, Shuah Khan <skhan@linuxfoundation.org>, 
	Vipin Sharma <vipinsh@google.com>, William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v8 11/12] PCI: liveupdate: Do not disable bus mastering
 on preserved devices during kexec
Message-ID: <aoyjVL6sjG7xh9jB@google.com>
References: <20260728221007.2098560-1-dmatlack@google.com>
 <20260728221007.2098560-12-dmatlack@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20260728221007.2098560-12-dmatlack@google.com>
X-Rspamd-Queue-Id: 1AC79180003
X-Stat-Signature: 7qdityxb9mjdnumrspcaj7fatnnd3gyh
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-HE-Tag: 1787601770-767073
X-HE-Meta: U2FsdGVkX1/M/Q6vvrRFtHlFer/qRJKRPt8DKLIzG5QY0Y+Az6M2rJt2p7qmbZOwa9Fa+05DVESUphjEN8Gb3OlCOLzKw1DQMH4UcO8YB/UFbX9VqLNF6iaWUbjLAlJIiiOoeNVO5am5Qpr0YyOscNjozSFDU/80oOM4r12zEnGxE662k3Q9zQ+0mYjx3QoBOoEA3nsyBUmpXnzf7y0jo76Tqc2Pzem3fbOqaTCkFzfvsf+onZT7kO4c8FNK++MK/horaDJ6PYklmgaxYxM55Kz/zTW2tcUR64MQMql7CJCyzuSzebI870UBi1RbrcR2UuZDdo5RhJ/yzPMh/vCu/m0HFwzl05fwhb2LfYOS3gTdFtMA5uboO4rmO/fI4XVs9RHARvDcRredpMPXAh2iBgY3oZdG/9L4lXupI880jN/vY+7x8rkkDxPg/6wcPvEkeJ8ZmfrLi/WVWdpxYjvSBEG87tjXtHRs+i9EMLCxsgX0ddR54SG/vsi6T4HWARrfKDmc5t9UGl7ilK8W28OsWkg/MkAOWf+CXW/VMnJwEEO5Gls3Jtl4wXS9W7r8ix9EZv1A+ff7OOwjL2gaY2x9/Rn7x3Uz+kEyzZPIsBzPJa9iR5xPnEHEnfpt4kCW4n4FUI8SI33jZM6+kIWJ4OsSXBkrn777Q++aEklt5aKPlMzY5PWEAxHniHvXA3Ci7VxnQCc/a3FmEHc593iu2Sp5pyjV4gnIFIQIqXM5AY/yccqBUUy2PXBzO51XkSyV8jGSEx5jtwXsehrJFKcl7A3eBjjYzbPngFg6GLZw6CKobaPnch6rBHzDytqOiiEA81F2o7A+TNxFe8uICZ3l0/Uuj+k1eJUUTrVUWUThgmSuLwLraH0IzICulEGKGc9SacjfP0VF5C0G2n3TuD7EMM1KH3LOL78u/upMMSiZ0LdIoRdQKa0bMUTJfupR1t/+nZStgO/0m8tH8OW9teJ+AzT
 78dyNpRg
 kGk4S+q90CR+6OV64z3qk6S0F5Dn9A8sJPOUOAir3HL0SzuhX4qFassPJO62vc/st5/8t62KkD8epjXBRvPSpP2yIP54OHB1EamMLtOcLt3foUIeBp4BdPUGKWmVMxbPeRdN0FOnyuFD2koEdz+fqr9LWQPiDHjftb+pMXvrLv5Ly7Ijb4HqBZhARMZLyfMaDm+/Jsoda2uuNKLE1V+RC4R6QSxu0nkuVgtp633FV0cr2GDCuWD2fIPvrFRk361fmUB8Md/Nc1NK9qUrUExx4RRHrZxTQ59T0L8n3lxQu7DlJTIFNDcBlSpo0i03KpKjzM2xxQMgDTiBba6r5MMqnFeiFvyIjUGMa+oiz7yQTfIQaWyhUdGAErd5FnNQlSlru6lIZ0aPt6As1DAFY2YZ1A8CklrQW+RFCrglV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 10:10:05PM +0000, David Matlack wrote:
>Do not disable bus mastering on outgoing preserved devices during
>pci_device_shutdown() for kexec.
>
>Preserved devices must be allowed to perform memory transactions during
>a Live Update to ensure continuous operation.  Clearing the bus
>mastering bit would prevent these devices from issuing any memory
>requests while the new kernel boots.
>
>Because bridges upstream of preserved endpoint devices are also
>automatically preserved, this change also avoids clearing bus mastering
>on them. This is critical because clearing bus mastering on an upstream
>bridge prevents the bridge from forwarding memory requests upstream (i.e.
>it would prevent the endpoint device from accessing system RAM and doing
>peer-to-peer transactions with devices not downstream of the bridge).
>
>Reviewed-by: Pranjal Shrivastava <praan@google.com>
>Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
>Signed-off-by: David Matlack <dmatlack@google.com>
>---
> drivers/pci/liveupdate.c | 11 +++++++++++
> drivers/pci/liveupdate.h |  6 ++++++
> drivers/pci/pci-driver.c |  7 +++++--
> 3 files changed, 22 insertions(+), 2 deletions(-)
>

Reviewed-by: Samiullah Khawaja <skhawaja@google.com>

