Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8EC0DC87FCB
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 04:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40036B007B; Fri,  1 Aug 2025 00:23:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BF0E56B0088; Fri,  1 Aug 2025 00:23:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ADF4F6B008A; Fri,  1 Aug 2025 00:23:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 98E366B007B
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 00:23:50 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1D2FD160FE8
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:23:50 +0000 (UTC)
X-FDA: 83726895420.26.0353F68
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf28.hostedemail.com (Postfix) with ESMTP id 5E21AC0007
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 04:23:48 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=edNb+fCD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754022228; a=rsa-sha256;
	cv=none;
	b=YsUN7XYM7AYkBAImN5rdxg39y1Qvcn3tPALoeGpAZNcKJ5xjGbEcwvTK3acjD570ZgaS+z
	WQFP1XF8740gbwoYQY5KTiVPfN8prcYj+zO1wzwHuqZ+5xty8NHjUrq97m2Nun6pkSoOc2
	0SH0XW/mLxBdskqwssBRFkN5vj5sWaU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=edNb+fCD;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf28.hostedemail.com: domain of ritesh.list@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754022228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=FNFG0goKRFNn6WAYQtw0Gyc6OtTnvSZYrWlxnJqfeJg=;
	b=UAveauDZxeX+6JWsfoiRKbykVpenZ5K5xrIsyq1W3Wr9AcXnVnd10m/02kTl1XKmSSt59C
	8VLCeKETSGIG2CSu6fYkNJfQr/TpVutpIp14NAfkzCdduQH+RzaWCjHIFB7HB0p/aFNVYB
	0CsDjsHlHWk0x1KJd3wRz6Ez1CFNst4=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-747e41d5469so572851b3a.3
        for <linux-mm@kvack.org>; Thu, 31 Jul 2025 21:23:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754022227; x=1754627027; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to;
        bh=FNFG0goKRFNn6WAYQtw0Gyc6OtTnvSZYrWlxnJqfeJg=;
        b=edNb+fCD5unkMQfHQ4HCRq/Njt57D75j049DtC6Qh4chDWusEyMgFCh/+4STBZUnoQ
         PLbmrKtsPyjB/U6BFdSPVDlhh73yzyBxbAgWsT1UQwdTWLB6E/sp6HokIaSDoOWQ2Pix
         YAl7T7iaPclUQaihrpbNLT4W14siwixpv1tShmPUuykNq00UmbD67Ohz85CIrwYKsuxp
         rQFwITaNEeWmMETwekVolnr46CCd6LsULg6T6we6j8FEdz4FO02Y7GezgdJ8pxR+vpwN
         /cd21v9KBB5rcCJEVpucj1+k9+t+HwPHtTMpbp7J0AzQHIx/WKRISO+332HLCSJA5I8+
         bKOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754022227; x=1754627027;
        h=references:message-id:date:in-reply-to:subject:cc:to:from
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=FNFG0goKRFNn6WAYQtw0Gyc6OtTnvSZYrWlxnJqfeJg=;
        b=R13fEK+x5w3+VVKeRpN+qd5KW+ukpXs/F3ZZ92Ae2w4CUuvA55LtID+BgliH+7Wt6I
         D5ZiPegSTJEgGN+vHsFJd62oskfhfp4teaBrcrENjome1RHyeeRJvybaVp3zTsmG+F20
         o2Va2+61+tyU4UdZxH/bWJp8tUXzozfeap2IffgM1f5S3VVh7jbc67OkOi0VdSG9etMo
         +IE6igr8VoIPJWjc1TYgb/Y+roqy+G+Ib2fjSqSQkbtUtTshNFxB7hCnyaSJOgFLwiwJ
         JOZdUqrtb9ybEFstnRqG9cyD15hvDRQWDjWeBZ8B2tpE09x4b+IV9jd8uUhshQBvXLkP
         4+qQ==
X-Forwarded-Encrypted: i=1; AJvYcCXZ6iOrdGirmwjj77sE4klC+MHbjbHnwcWuZZ0i2LKTtQPA9exP8pbbLz+ciF4rH7J514Uo/26nhQ==@kvack.org
X-Gm-Message-State: AOJu0YzzvvzusYAnwzI6x37DD3dyH94YiKzIYqsBSQBNFrTjvPZokBps
	i5G/kaIipCtwDSyxw9fDjhBjUTXPT2Eq/uK5o+QYVD6MaU5rIgnWaHtt
X-Gm-Gg: ASbGncs1gXlZJi7kEUmjQam1IWm9vmsMdJlRQEk0ZBb6yCYkc9qRfJ2I4gpoChi8OLg
	N23JxOA75nKyRxPvIG2F/X5fEb6tJn0Fa13VRoXKMzhq/mig7O3h2LLML/1ADQoSvcIhmX6r9fG
	4LTU6RDzIA5w1uifL/KA3FtnGwGGVR0YdP57HW24LiGQZxKZT3nZhLLfOfKxz6i1OwwVnvqNEPX
	VYO/2D5iCqIBMhE5n5qyVM52uEmJgbXus2+Fm/YoPm3vx/cqKJNqp+4KieXLDDvO7fODXNU6GW7
	BIQK9yBqpnsfp5peZzpLSSm/ccJBXxBWczCWWGU+s4dfUUtBTgMseKFhz8aqxqklZ5KAu34iT+5
	1X53abpi23S1hrDc=
X-Google-Smtp-Source: AGHT+IFYpTrv1dKIphQdIwKL1PvNWrKjfBnLAZqwJKaFm7GvpRXCHXO9Ik+FatBqLwjSU63HnQ9A9A==
X-Received: by 2002:a05:6a21:9998:b0:220:4750:1fb1 with SMTP id adf61e73a8af0-23dc0d0444emr17449915637.4.1754022227221;
        Thu, 31 Jul 2025 21:23:47 -0700 (PDT)
Received: from dw-tp ([49.205.218.89])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-76bcce8f800sm2922802b3a.42.2025.07.31.21.23.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Jul 2025 21:23:46 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "Pankaj Raghav (Samsung)" <kernel@pankajraghav.com>, Suren Baghdasaryan <surenb@google.com>, Ryan Roberts <ryan.roberts@arm.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Borislav Petkov <bp@alien8.de>, Ingo Molnar <mingo@redhat.com>, "H . Peter Anvin" <hpa@zytor.com>, Vlastimil Babka <vbabka@suse.cz>, Zi Yan <ziy@nvidia.com>, Mike Rapoport <rppt@kernel.org>, Dave Hansen <dave.hansen@linux.intel.com>, Michal Hocko <mhocko@suse.com>, David Hildenbrand <david@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Andrew Morton <akpm@linux-foundation.org>, Thomas Gleixner <tglx@linutronix.de>, Nico Pache <npache@redhat.com>, Dev Jain <dev.jain@arm.com>, "Liam R . Howlett" <Liam.Howlett@oracle.com>, Jens Axboe <axboe@kernel.dk>
Cc: linux-kernel@vger.kernel.org, willy@infradead.org, linux-mm@kvack.org, x86@kernel.org, linux-block@vger.kernel.org, linux-fsdevel@vger.kernel.org, "Darrick J . Wong" <djwong@kernel.org>, mcgrof@kernel.org, gost.dev@samsung.com, kernel@pankajraghav.com, hch@lst.de, Pankaj Raghav <p.raghav@samsung.com>
Subject: Re: [RFC v2 1/4] mm: rename huge_zero_page_shrinker to huge_zero_folio_shrinker
In-Reply-To: <20250724145001.487878-2-kernel@pankajraghav.com>
Date: Fri, 01 Aug 2025 09:48:18 +0530
Message-ID: <87v7n7r7xx.fsf@gmail.com>
References: <20250724145001.487878-1-kernel@pankajraghav.com> <20250724145001.487878-2-kernel@pankajraghav.com>
X-Rspamd-Queue-Id: 5E21AC0007
X-Stat-Signature: ohyfwhknud1o9oeu1eom9ueuwjkqeumn
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1754022228-828164
X-HE-Meta: U2FsdGVkX1/EuIbAMvvu6Q6c+p+vFjBfkHRZW6f92tfziCloeaFpVKqJ+eDzO827Xmq1lcm/ZuYpbJ2g1oTIDU2YXhROXuDC2aeJWQyyEcmQCPLP3GPy9UlPrNJPHoaTIJEAdxdrBPpLOC/62c5H5L30dyhC/1NZ89Y+ZUMu++UBzaVjvQMqtOEQjTtlI5pKm3MZWY2Xpp8duQfHLOkWY/qbCt87HdgVvH4IfVCCDpqdcBOnju/KAOjV+h/+wAT/5pdPaRkFvToizpQBMKorfbduTFUb4qoeoDqU6gCTO8HZlIEUEL+cpcIN81w9hJeBGzdno3rJuKXqw5nIaEE3vfoPtetUdGlE97XGrmWufOVqL0o4w37r0H7XhPHHt8BNlmFAdjD0wH3TR7G2rqnIxsbjrIlEy1rFWVOEBpeiXBLJetrAI4kIw00I1JLP9AOnpvYGU1XaqmxbG+6gqO+88dL3L0+f3X1FGLoUMyCfRtoVpSWfIAvIB4BV/2xFvx3Kj5JIvjedYBEHqg94xeyRcGSIrYNBMYlNSM5Dt4ayM9mxJeie9oW8WEXLh0Ps4Y+Se8V3oGXdoostgfUOPDRTb1UF82wMck4pRMY1SWW+JaxLzUXMLHXIgOlCCPHco6Yl38+sVGsi1P8CmgdiOA4iRtv9MTNAUCuA/dCBVxAHtjQWX1YmnBlO3CXzwKNDO3jvmhfqRt/9s/tpSt76QLkHkMflcyUiPdNWdwwPRaPV8Ru+ExlhBo0odOiHfBI7L8ME3jqE6+SCJEqt++RCe5G35AH5VNjKDEQhDAc2aiN3W0VI1SgLp2aCrHpUdaK9yAN4o9r2fRTKi7cRRlhkrXAMDJ+SdDEySQwLMgFXY2mVqm6C303STlbh5rFCF3Tq8qai4z9o0LqmL/CNSQ5bapBtMKunBnVJnysTBbTugNrGfKSmtvs1xE8fHqOOL3WJML7Wv2F1gv+M7UuIoPQbO3X
 dH096kgg
 /Vq/1JxiY15/V6b7oyW5kUbaEML6wRIbyP+3vnYCoTAJsgicPomuDgQb83obQAkcM6MfT76+58zAxjFqavlLFZTtqI8+jv0P4deI7Chn5s0mqDcGhO7rlia0yQwywCNI4qvoZrMd2TiXZyYKCf4EKo41fbtWmzx4GNEA/rrHAYAyH6JRBccd0bOIo2nR1cl5TF8afWHBsJQfnKELQR1br6QlsQphZ6OxFuLdU3+txLWwCvj4lnE6PKGbHYqytCMkcTEyYtmmAuN/Gh89v7kzrpuq/4AV83GfLeyhyY+F0Pyn+outsqtqFLGPmQBW44+fnfjocAgTSe7S0i0VZz98X/N2UeQM2kiHblfPdnsBUHVpaBeNqZg94zUITlZ66AZ55+mFTWPqUNOBw4GQefCv41x6H1oWDy7FgVn1zk0G3k5PzGj0q+v4BUjaUaIVAUh3NWTKPmJyi+gk98ZV8zeApjf5zCs6qu4Mw0GZVZqN9TLYL7MxIitfU+6aoDM8Fq7+yW+jxgYqal5+2AOF70NG+J0KkOSXCdhBUdKMtoEiX5+XCkNFOICSPt+L9r6QMSzNb5h2S
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

"Pankaj Raghav (Samsung)" <kernel@pankajraghav.com> writes:

> From: Pankaj Raghav <p.raghav@samsung.com>
>
> As we already moved from exposing huge_zero_page to huge_zero_folio,
> change the name of the shrinker to reflect that.
>

Why not change get_huge_zero_page() to get_huge_zero_folio() too, for
consistent naming?

> No functional changes.
>
> Suggested-by: David Hildenbrand <david@redhat.com>
> Acked-by: David Hildenbrand <david@redhat.com>
> Signed-off-by: Pankaj Raghav <p.raghav@samsung.com>
> ---
>  mm/huge_memory.c | 24 ++++++++++++------------
>  1 file changed, 12 insertions(+), 12 deletions(-)

-ritesh

