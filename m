Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 91643CA0FFE
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 12:06:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AAE7B8E0002; Tue,  2 Sep 2025 08:06:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A876A8E0001; Tue,  2 Sep 2025 08:06:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99C0B8E0002; Tue,  2 Sep 2025 08:06:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 88A678E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 08:06:31 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3E197160C0B
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:06:31 +0000 (UTC)
X-FDA: 83844182982.09.71CC4B1
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2ECEF20011
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 12:06:29 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=XB0dzz3H;
	spf=pass (imf13.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756814789; a=rsa-sha256;
	cv=none;
	b=V1XhWJl/GtzMsPr1uAtSygrnKsoH9GyXbEM4DPuvUU8Ke6Y5E7tqVRmRKChWnCPuJWhHZ4
	704lhNHsqSysRGCoBLG7aC+e50K/IfyERvlSG2afxup+bAmnIS4VTRsSL2Bi/JRYFtF5XJ
	DckYUvTpy8zp37kUVezoV7vUkaiA67I=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=XB0dzz3H;
	spf=pass (imf13.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.160.175 as permitted sender) smtp.mailfrom=jgg@ziepe.ca;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756814789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ae26jb7eMgKo9jPZq9aVW5MuaO6TSCdU+50Vy/SJX5k=;
	b=j6vA2N+UMIFM5Iu50EGldmzdenGpMFVvcvLmUPN5qpOt/2E19VFTMiNpzUNYknm9m8Hr12
	M4qutSaaha1gpKPVr7TAdK0+Wp45ECf7E7Ta2RX8ilqZitScgnWrSXaMo+TRwNl6PX1Iqp
	B4z6+vB63A++6wkmtcNLDPVtyMCy8pI=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-4b38d4de61aso1236781cf.0
        for <linux-mm@kvack.org>; Tue, 02 Sep 2025 05:06:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1756814788; x=1757419588; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ae26jb7eMgKo9jPZq9aVW5MuaO6TSCdU+50Vy/SJX5k=;
        b=XB0dzz3HVNO3akiVnevxGqTKd/cJPtuhIW2gHZF4DRbrNpFwc96kS9DwxwPSMKaUD5
         3+9vnAtLXg2lc3xL6PeCJKTymJgkt7fp6zBqPD78LVlBV323aWc9qNIXmRQlhLNhSHHy
         ghnxjevX+idNjOr9xS2tzIpJ/5bUHL0k0PyAbEs0zHts1epYZTCuXnsd0xFWaBd4Y9rR
         GfPg7+1wf7AWTXfz6Lz88Ey+lUqqfGDNP8zwGj8XMx4Bcyc6MrZ79OzMQWKNjV6o6Zd9
         vv2CkaRBFIWn4dilr0hmMWVBd9rgr2OR2JQAYuUWARsGrkyeYsdzwZJOP8tRcEOrj2GW
         7T/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756814788; x=1757419588;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ae26jb7eMgKo9jPZq9aVW5MuaO6TSCdU+50Vy/SJX5k=;
        b=CBxegWYOcdjbZyuidXOTnQB1PvwIqJ9/9w85PyCwX+aqGJicpM0zhVSoDJ+nSL7Uj6
         aqaKMh+EsRiM2tGr2NOXKTKSpS/s8I4AMOqs14dgHuOXE7/037N5bYwuhoPvO38OiItG
         F0eXAEhSuoHCLd6ybV1T9ASFW/CkM2Ij81dbRwbLxzdiln1TcH13PwlR+0btWNLadYLo
         gGgwfDFwtC2gZyw2v7BplBGoaHFVB+7gmCQNRzLfzw/uBGK4w7bGy5EcXcZc8X14Z7xD
         3kTdXhnPfRNjWTNWoq9rhnbk5P0FuE6KOMY/GpfG8Xm8mjOulOZDIakafz0msu/aSfz8
         uECg==
X-Gm-Message-State: AOJu0YxuKlg/Bs1wcT3MGi1O5jl2CvviY8uKDY8j8vo8onHu+8wE5RK3
	9HacPGgKUOfT7Z939UeGi3y6N9da1vaQ6/rcV/SakKWHCetHmGH1J0oRRQqNQw6yVLSpm2IIDgd
	FpyFA
X-Gm-Gg: ASbGncs4c4sPxes+Mdrp/5h9BBIr06f8g4gG9WIYHuYmY9/GCvdCiZIHtinH9T2a0rB
	2ZSdSoVgS8TCX9XsGGVq8bOcMCquvtpn44F4SEye5mjh65lml68vSTyLRfYA4UjUB3yrs5wDAXF
	8yAas/Y8USguPbIkdrHwfRzbhat23S8fTfGKh+wkP9rFKYXYWiqPm29M/G/CE8Doe6GOsRwAIfe
	e/wBWtM59tIUs1hJsQHIyaKUdAknDyuOe5J4NiWO7qZFSx4necJFyr/Q+hlUKhQ2VSdAZhOy38i
	cbWjOxWkPKY/CnHfYooWDD5WRcU0gvGBhbiQNu83zH9ZpB/OG3+KLsUkfELObenKpDdW/LfHUpk
	5X9jMjkyav6GRxr4cd2oaPhJly/7e6HP/tRsXzySgZfKVhYVqGvYIL3EcRTX7ErFTbhDqRWsoG2
	KX4Vg=
X-Google-Smtp-Source: AGHT+IGq+b8MukhXiFM3oGQJBiAc7TI3DsYh7Y+rH0+wkWrBkgjU/7jW1I73b1PVVaTQ6nJ+pi8pJA==
X-Received: by 2002:a05:622a:5b91:b0:4b2:8ac5:27bc with SMTP id d75a77b69052e-4b31dd55c80mr136582951cf.71.1756814788218;
        Tue, 02 Sep 2025 05:06:28 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-4b3462ca49fsm11168561cf.31.2025.09.02.05.06.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 02 Sep 2025 05:06:27 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1utPmM-00000000saf-2PL1;
	Tue, 02 Sep 2025 09:06:26 -0300
Date: Tue, 2 Sep 2025 09:06:26 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Alistair Popple <apopple@nvidia.com>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, david@redhat.com,
	osalvador@suse.de, jhubbard@nvidia.com, peterx@redhat.com,
	linux-kernel@vger.kernel.org, dan.j.williams@intel.com
Subject: Re: [PATCH 1/2] mm/gup: Remove dead pgmap refcounting code
Message-ID: <20250902120626.GA184112@ziepe.ca>
References: <20250902051421.162498-1-apopple@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250902051421.162498-1-apopple@nvidia.com>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2ECEF20011
X-Stat-Signature: x8rqaae4m6dac1y6wtcxh4t77skd65jh
X-Rspam-User: 
X-HE-Tag: 1756814789-550937
X-HE-Meta: U2FsdGVkX19d5j46CnEbVlUu06Mrt0ESjBeLQzXP8Gane9ZRICEgeG1Gb6f6cCion8wCOthhC/UmQTF59hSS8RDZdworAlqrWttr0UdC4ovJB5gAbTnGIohqV9VwqDe/DiYzLhACTRpriT+wo/nrZagI38zKPbv1IPA6LBDw7qLOrywtHjYkcHhbpiwHdA1paqnfOdoszO4FsbXn2RLUzUrZTNwY3tETmD/HLKNsgNJoIUcqQ2WQBkADHNIXuMAhCL+DPPOWYCZ9m3IfYETMU2rGkpXrbj3ZoM3n19Jpe8zeOlIaBrGaSiN0v44Nt6MnUtbT73RTUjtLGS4Yx5CqFh0oTrsjRKCDsydgv7X7A7tBthizku4rMzJP8zuDlfPgkYtScQNgag2f2s6ofuGP+RLpjEwoqUSOfW9I1ogSRzoHOT4TTlUdXKZrzvt+Spi0XcsMUP10jB6pVRCdF+5TOLPC48cwwkv2NeSg5i4Kr5l5T+tRXz2hup33DggB+zgLP/w2f21oHCpJBU7va41mg2tP2G4KXP/6MoxzIFGnK41qsyWux4XIjdpIvzlegtbRAmI6LGRcSiw8RG0CnoM4LW+WqiJty+TeVm/nUBvWToZwj0fnWEKEGaeWkd1KDkQOoQOZVhO5l4GREk3hIVMv+xs8ca53NjGShGM0TSjADc6kUgJDdQoroBAW9ShJkjDP/tqNdw/nFdVETUdNj0WIcHmDJZ5eCK9djt7IfN+Wy1exbaS+dmLORWhCmvK5tPb04Woj1NvQ/hBEVs7j7IMViTYGtBq+dw7danKnSLSxz/xpKfz+lEWSlcEvfg1lm3XgYxkqi51GUNNtmQmZerD9AyDNlJXim4E9/6oWJWXJKBik4AdRZ8kVMXkJ5qaYvM2wvw+s37FCmxNvQC6+CXyQD39sNzDfGhNCUoA94jX9zTN52qXECi5TnkCmqhxnaIHj6NLAkFnG690cNRqn+LC
 yMv63yWa
 7LOBusle9An+2GbW+jVVgZt2zmjsDwAz0lyfBLHg/w4Lp2zyGw7SbbnUXuizZ6DYkblihovaO4HKjQideTALBqJxGALM7K4YciEfQjsBisB+w5I9tA/X2B+4F+WFEjHxhbWcFa8e6WYk3ERqvfi2w5WVHmUzr3euIRD2WMGxmnO81vdWVe4wl6p0tQLevXb7bdymhuIrRaNtF5VKHD2+EXUyA86NECXcdcR4dHRVjS8RI14OOYeV3nAiQ0Zt0fEEXlKQvTImlGaq/dp7bC27rLrzwJLfESRJ0SfYoV3UZ2o5DdqIO4Sgyvu4vGQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 02, 2025 at 03:14:20PM +1000, Alistair Popple wrote:
> Prior to aed877c2b425 ("device/dax: properly refcount device dax pages
> when mapping") ZONE_DEVICE pages were not fully reference counted when
> mapped into user page tables. Instead GUP would take a reference on the
> associated pgmap to ensure the results of pfn_to_page() remained valid.
> 
> This is no longer required and most of the code was removed by
> fd2825b0760a ("mm/gup: remove pXX_devmap usage from get_user_pages()").
> Finish cleaning this up by removing the dead calls to put_dev_pagemap()
> and the temporary context struct.
> 
> Signed-off-by: Alistair Popple <apopple@nvidia.com>
> ---
>  mm/gup.c | 67 ++++++++++++++++++++++----------------------------------
>  1 file changed, 26 insertions(+), 41 deletions(-)

Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>

Yay! This never made alot of sense :\

Jason

