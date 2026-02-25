Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D68D1FD45F1
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 23:20:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2FB026B0089; Wed, 25 Feb 2026 18:20:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B1876B008A; Wed, 25 Feb 2026 18:20:20 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CB316B008C; Wed, 25 Feb 2026 18:20:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0A1106B0089
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 18:20:20 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id BD5685A2A5
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:20:19 +0000 (UTC)
X-FDA: 84484549758.30.5D19C8C
Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	by imf04.hostedemail.com (Postfix) with ESMTP id E119340010
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 23:20:17 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OVNuV2aY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772061618; a=rsa-sha256;
	cv=none;
	b=NUI1zW6HsJW1H20Jw45hHkNTLP4UomplWvvHFP7DZ16veCqOjZ5AF79gO8FGnYXZsAnXol
	BaeJg0gv880RNTvtVZgVOgxf16L0hjGENpEvjEU6ui6RjorF3V6I7EFFlrRE6Rl5w8TGAO
	3TUxS4xn+B/dQ8HEeTHS35v3xDa5PjM=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=OVNuV2aY;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf04.hostedemail.com: domain of dmatlack@google.com designates 209.85.210.175 as permitted sender) smtp.mailfrom=dmatlack@google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772061618;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aEWfuL1WgCP/eH/o3qO74sPfk+Pg3+xsCKw2mq2gLYE=;
	b=7sgPFh7sHbfcgoUXEIdAOFq7vvTOgrx5CsQxD2qQ445zjLCI5kDhtruSldX7MkarGVcCXF
	twN54/typNj/RfZP0S37mR+jNVulA4EVbr5VBLB9IRjtwj5OjihPcnOrpEcfVve9n1t2ZF
	TM8+xRbqvEe4/MzB5l7FYGynPB36LDI=
Received: by mail-pf1-f175.google.com with SMTP id d2e1a72fcca58-8272a56b91cso284636b3a.1
        for <linux-mm@kvack.org>; Wed, 25 Feb 2026 15:20:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772061617; x=1772666417; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=aEWfuL1WgCP/eH/o3qO74sPfk+Pg3+xsCKw2mq2gLYE=;
        b=OVNuV2aYncrcQzNT+5fz2f0w3ohXq5mdIA5KEFfwE6tcP8Y8ltsaw0C6Z1vWOKtgrf
         vUOScO2K1uNzRMTsmdiyZjb66GYpFq99Cee6wdiDnxlZfeGCbYMQQnA4GFfVQhFOAaSU
         f0pxkEwMtlvRPokZU6yV1UME48Y6VoSt90AgitqSbF75qOL/r5VTQnl9elUtWOzZ7fEd
         ttdMLYaejTrhfvduKPYi0lZKBK7oyrPu+UWZZbT5Kpc5sfrYk+OP2KP11SzB2UF2uS3a
         MzZEDPtUEGrX1FHpVZfSgMDDIY4fq51XdjZz+FuYuQ2RMFDFvUqRhQhGDdX9ctxIxI+V
         jA6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772061617; x=1772666417;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aEWfuL1WgCP/eH/o3qO74sPfk+Pg3+xsCKw2mq2gLYE=;
        b=e/TgsulUTpdfKdCEvkpiH1inKgZowmCwQaHH9kMLMgOOyZBwgzSgGaNEPLoFtIt2Pd
         gXdqaGtw0ngMzohhoxyiVvO7GKDMJrhxZ4EfJ3T99OsKUc4C9G4pGV5xJ8aNVmoh8/Br
         YRc9QXJIJXyT0QmR78OpU71fFzA9gwdNWx5WC2qGhEn/Ei4SejQ7/NDdC8LYptg6rcCX
         wYIt5Y550LbNknhU+uxhMlCWH3kfdlUMsDHDG0lRwYGpukJaoguGmQwwnhyOVFxUHTpj
         fOgILM1ww4ftT845T1i825z2lPt8hkqqvh9XUWpc6rJOnoTKGK/8OaOVNmitiCFmKYK1
         DCnw==
X-Forwarded-Encrypted: i=1; AJvYcCX1wCxPl86SQwu/WXV2/lOotWEU6W8Ob6mG9x4/ym4qTW7yoe8qYO8aDxPgcnW3Ns2d7q/Le4zJHg==@kvack.org
X-Gm-Message-State: AOJu0Yy8gLMh1s9w6AkYGQ64nk8zbobx6LOiEoUQ7jVwE4vE0+TxGN8h
	nrGM+V9gtLzb2+sqLteZmqhKo/KNk3vMt6CjElLQzPJpsVSG4iihUDPI+6ocmxqBMw==
X-Gm-Gg: ATEYQzxyDF+6x6An8Ls2mYgUdx3BJDbN1jVQGhvkIm6PKfbCfSySHHbZOgGnpSfne6a
	b+qQUAwf46snPymruYYLG3KP/RdfMd91UNweGv9HM4UFiGT9fhLORjWaRni52FYFepUZ29ELMAG
	8WAeq9jQJNx5FVJuzO0wv3/vppjOn+ARpxy1T0xkFRgub2PjTdcVlRExj2FGS4koRI5pTXNo1vV
	iXOBu5D2nt4Q/8UwTYpgD6GP1rWKFV1BOpZbhTlAQ2PQK9EVU9xGfbfrnms721rgYNgHxpjV+TA
	/nPU9keH1b2JQsB5SZD+NxnKXCBvZ3Uq1694SX1GVEOll50BYVVTLTxaXoIodwLGWH7lQ6SpGFc
	4R/dHS4KMmQYQys/NuyYDzrx0maWKY4GKkvlS/vxXBwOcJ4yMNC0yun10GRrHsh2uXEJ/WOUicp
	ccfqSJSG9uQNCZxJWu44d70eY0nP0mmA6y9cx2n4WBtvPX33ENvUZZ1nEnA34BEw==
X-Received: by 2002:a05:6a00:18a7:b0:81f:852b:a91c with SMTP id d2e1a72fcca58-8273390dcc3mr1547131b3a.64.1772061616376;
        Wed, 25 Feb 2026 15:20:16 -0800 (PST)
Received: from google.com (239.23.105.34.bc.googleusercontent.com. [34.105.23.239])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-82739ff37f1sm347240b3a.40.2026.02.25.15.20.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 Feb 2026 15:20:14 -0800 (PST)
Date: Wed, 25 Feb 2026 23:20:10 +0000
From: David Matlack <dmatlack@google.com>
To: Bjorn Helgaas <helgaas@kernel.org>
Cc: Alex Williamson <alex@shazbot.org>,
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
Subject: Re: [PATCH v2 03/22] PCI: Inherit bus numbers from previous kernel
 during Live Update
Message-ID: <aZ-Dqi782aafiE_-@google.com>
References: <20260129212510.967611-4-dmatlack@google.com>
 <20260225224746.GA3714478@bhelgaas>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260225224746.GA3714478@bhelgaas>
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E119340010
X-Stat-Signature: zccj7b61ow1fcsfocwpcbhxab5dy7jpa
X-HE-Tag: 1772061617-873403
X-HE-Meta: U2FsdGVkX191lU8iHb1u3SWIDR8Mzsr/+BPWulJjWkWDPGnKpK88iyulKJ9J8TVMkO5mXSuC5y2EefntSMHJ9v4J56KfcNPPhlUtVg5q9GK5nQJ1H+OKsWeKmH6dZDwTG4JNFSEtkKW+hRYyFu3wXAHJ2siNaF1JWycuSmRuM8SMKeoWxnEtt+BZXEkuBlvJIYd0PZvg20YFDevNY/4CVSeRWmx63NNCH/iMBsIWUHGgSpyJ184wxwPiLMofzf/XcUIiEpmP6shBLvxRXygFlWja9OEXARi9z3epMXfq8obt6Mgadl+ZjL+Zu/fotri7SC+5luy52csbEJQBSNNRcGuNpvPxTuis2NruYDxKHFOjZEHKi6DccLyjpBHjOrC/7NYvh8A96NnGhhSOKhsxDNqTryegKzsiNZfKWyXtAX/Im+U0LI708sFi93mgeAXgOC9SAirH2kxCZkgre+gXYsxF1fZjWoNCyWG4XJrkSntsRc+ljD/2cTN5fzwOGnsbXZrHpSKwwWlEKh382KKYhBIB1ro6Xo2gs2203ZYwZZxMi0lHvgAqkUZqnBrVv+dtCuybuvpcoAB0WeKLM5c5mMUds3+jLz2sLCYNkIbMJJ/qgpDoMz14R10pFJhxfRI8LvmV5NYzCcMI5dBbTkvAF4M7kuTZ3O7aBHCxAlTJpVfBytVSZqRMVklZ/+/zMRN1jb46PFwPhQBmaaw8OBQouYs9Zrb3H2f3LbMbqNKh1IurYdaH3qgFRJr3c/3wSNDt3oS7OuAYOWTC5Jl5D04MPEawXUXY7ncFrSvwjf4Q40/UOfgGPSqeZUJtxKUGKgGqFDkJrARDA7yVuMxxpwm/y3sbRMepfUEAh8N9/CuskskcrLw+kEBAoh5VZO8vwxU9z2UXMCFn64NmULe/uSzo4wTzh/EsC0LS/y+j9gd0SkZfQmaeAQI4eoJB+OnLhbbfgZPuIo9ly3AEEwkEm7C
 hkuysi6Q
 W7669ZjcJG+hwBAXQgy8hWxo3MdZw6H/gY/ZASSAH0zTyouO7k8ziSKMCNJ2Iq1l6SDNzG5tNvePtkWMq/xvalPlyql+q8053B0iKTWUQKhcJQqupmqafJskpfiBOt2NX7trZPgjUa7zKiKyBareq2FuI81ulx4HNTfJGCu0dzu87Y5Hc8w7qyV5xrR1iq44+Evb0qarbcmqH5P6R2oPm5ZFYdNbjs7nTs3Md602TP1g7XBOhIoI3Hh3EacppxVBCVlyKi5uTF+4/NKu/D2FeM8qIsPmME74qZySDblQnn70MvN0w6FVBoUrKWkhvJvb8h4cRd+euyO0EkCyb3pLnijBMOVbPa/DvsNeUv9AnnrY09PA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-25 04:47 PM, Bjorn Helgaas wrote:
> On Thu, Jan 29, 2026 at 09:24:50PM +0000, David Matlack wrote:
> > Inherit bus numbers from the previous kernel during a Live Update when
> > one or more PCI devices are being preserved. This is necessary so that
> > preserved devices can DMA through the IOMMU during a Live Update
> > (changing bus numbers would break IOMMU translation).
> 
> I think changing bus numbers would break DMA regardless of whether an
> IOMMU is involved.  Completions carrying the data for DMA reads are
> routed back to the Requester ID of the read.

Ahh, makes sense. I'll clarify the commit message in the next version.

