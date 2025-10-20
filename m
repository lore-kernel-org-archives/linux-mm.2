Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1736DCCD199
	for <linux-mm@archiver.kernel.org>; Mon, 20 Oct 2025 14:22:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 739828E002C; Mon, 20 Oct 2025 10:22:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 711118E0002; Mon, 20 Oct 2025 10:22:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6260C8E002C; Mon, 20 Oct 2025 10:22:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 4FD2C8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 10:22:53 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1ECC01401CB
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:22:53 +0000 (UTC)
X-FDA: 84018709026.01.E639616
Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	by imf11.hostedemail.com (Postfix) with ESMTP id 39CB940008
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 14:22:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Di4+tJdT;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760970171;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ome1K21U8OKmqIh6cxr7UpkIOBQ/Su9V9X20JROSYuM=;
	b=kh8RcusBF77AymOZEEs3lsprIAy6DgZOnTRnLsnuAaQLNSgjYaSehkHbWBYZWmK2N3dQBF
	5O1xmy+71xN0SynNUgnRL54BpTVdUh5R+2YyHb7cZ0YeApb/Kb9NVr1gwnsEsKCoZdcUk+
	OpZtuGhYo8BadexFI8Emer2HUsy4jlA=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Di4+tJdT;
	spf=pass (imf11.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.47 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760970171; a=rsa-sha256;
	cv=none;
	b=6ke478W5oUlm+lWfJ2cRIW2VrqaJNuEb+kE3lvC7xx/SWTxbHdfAPe96zK2HAdjKsBoFLx
	orHZcwRRrNQsU8bOTMxnftluEkBbBxVTufQs0XzH/T3JdXlETVwevFoV2iVq5wtwjHCLJw
	FvImX1i6mWcpHp085d0ZC0S6WkXGCt4=
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-78ed682e9d3so60773936d6.0
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 07:22:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1760970170; x=1761574970; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Ome1K21U8OKmqIh6cxr7UpkIOBQ/Su9V9X20JROSYuM=;
        b=Di4+tJdTBoz1atxQO84Fmn0Jjh5wt+LUM+nuh4d7p335yDGL3kx5to/ysisjS+UV4S
         5TyRJ90J9r1nobB3BDqnKWDe10wCLnK0TserLQC4x0vyndBKQgp3+OvF2yYxPpYzNTVL
         D1f22a2I5xyCCZQ/+yRklfHGamXot+2H6+8na+A87GKQHnEkf5cTvDAGuv25ul9h07eL
         rlcloWGDCBuytp9j5p4az/YVDzYtZkJvwjj8FFgU67vBxA0SCFUMKMGtcOGMeCxKJ3KH
         rXGcFf0rHNBbK8q3u1O+IEzCB/c33lgNI0OAXtTckuZqORDZ0OKxlyiZCRO6hvYwilQZ
         /y/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760970170; x=1761574970;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ome1K21U8OKmqIh6cxr7UpkIOBQ/Su9V9X20JROSYuM=;
        b=FK+ouH0UlggaICTwYZxpHJrOdnDjFLmpHSeg4HR2tWTSfcL18R5mNIHgGJBxGwhH2t
         MjXvHv9IcqkRnMZNs9/iuAR0pwVibfmxXmX5Pmzd85fcNsXRcGv64mw/4aWT0rSJxh4v
         DVjcECG+7GFBbAyAMB5OrkP8fXTudyABRC6A4bYhaQKoijr53mOqIA49Xxj+BGJY3rEt
         nkye8ueZlgHLInjEd9x05QU0sAttRg9nds92vh0IMR0fOGRl5k1OJq70al11ZCGRua1L
         kBBD8OXhZaMyKYmDCp62fhsg934t8CJwIEvyRRexDmyDLe1e90JQzRynYRhtdA7YFqMW
         PqsQ==
X-Gm-Message-State: AOJu0Ywi7z0gpY/rnUXQ2sZ7rSrrKhb56gf0KtFBcx/SB26RVftyk6lI
	sxzwItna5jZTrguTMhheH6if6QBNP+hgTqRPTYzaL/Hu2ku7Hhbq7trqFj7N3rttUVo=
X-Gm-Gg: ASbGnctyYjHmqy43V2uVN00UjamGbJAlpI11ckLYYR0Mvonr5N+wPvD5ppoo/ENcvfh
	DswPDy8kKXKTlbWi4lT7J41eniP9IgtUGPHNi4B2PreSyrmBYLTS+2IF69xKSFLNinlA+elA/84
	Z+n27M7+kwdKtdH6EGQolqJ24/d0mo2zYBAo9BgG3L6KgmFTPMJjZ+C52ByWvfhwoSTzsGWWllK
	vvMf7pIgBIxSL2epZJcVq9stWcTY75nAWdXwZmSj1S0juTwqN8FDLIjI6ozp7JIyphLOnQsF2lp
	ZSzRSyHBX+r/bHj8lUYk+2kcYOxeCJdZXdVksPXeX3VQemqgZS/k7ROEnynE/sftmVOTYwkUzix
	8ZwIF5vh0LEtUgvdz2Jys5cz7f6oK3cutahc9qUEbpd7hRLRGOcU3WSFfV8iv5L6Vzi9WsMNFkb
	/KhHE4v39O4Md4/10IjDIXci4zghMSxPxa29RZ991TP3bHEHNTa9jua4XLUov1U+CG+v6ENA==
X-Google-Smtp-Source: AGHT+IGL/jp9+4xUfY50jcRRy/t4MGHpw6jQ2O094KKD/LfcVRUdB+PlhBahj0B9OuP95IOnQE5uVw==
X-Received: by 2002:a05:622a:306:b0:4e8:a85f:e4a6 with SMTP id d75a77b69052e-4e8b7cdf3cbmr81951421cf.81.1760970170265;
        Mon, 20 Oct 2025 07:22:50 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F (pool-96-255-20-138.washdc.ftas.verizon.net. [96.255.20.138])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-891cf0af579sm568871285a.41.2025.10.20.07.22.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 07:22:49 -0700 (PDT)
Date: Mon, 20 Oct 2025 10:22:47 -0400
From: Gregory Price <gourry@gourry.net>
To: David Hildenbrand <david@redhat.com>
Cc: linux-mm@kvack.org, osalvador@suse.de, corbet@lwn.net,
	muchun.song@linux.dev, akpm@linux-foundation.org,
	hannes@cmpxchg.org, laoar.shao@gmail.com, mclapinski@google.com,
	joel.granados@kernel.org, jack@suse.cz, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
	Michal Hocko <mhocko@suse.com>,
	Alexandru Moise <00moses.alexander00@gmail.com>,
	David Rientjes <rientjes@google.com>
Subject: Re: [RFC PATCH] mm, hugetlb: implement movable_gigantic_pages sysctl
Message-ID: <aPZFt05GcyTkGNQ5@gourry-fedora-PF4VCD3F>
References: <20251009161515.422292-1-gourry@gourry.net>
 <6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fe3562d-49b2-4975-aa86-e139c535ad00@redhat.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 39CB940008
X-Stat-Signature: hh67x3j3u19p5firci9a3zkce4sthhm7
X-Rspam-User: 
X-HE-Tag: 1760970171-883174
X-HE-Meta: U2FsdGVkX18ZzXfovoPwW8q8trqiSc6cloOEpfu71NvrZvTeI1TK069yShp1LKkahnwf/GJtXwT07sOGtOXvioXJACKbY2aZx371xFYinxV79Uypd+mAN+NQf2VmOtbkmxWvzKcK25+aQTboWd29MrNkilYKnxvc0ArVcqIjOsg7Hy2XKdTCaAfwFH/UH3Tb/JDxmlxVhJ53pcJlysoxs+GKglKLcNi7fEzwbnjQWj6IeqHpzeX6WUuPY6qpXkTGdb1YGDKaVfFmBQ0ceFw1QEka4pCVeN1XPQck5LOK/XgmKSM5/fLDQdHQIHa+sLLuciVBV94eLlcOix5ztMLBku59ljBnwzWSo37WCjJr3zKzGnRuxc1Ak4e4deGnN5aKV65Ym6HG43aZjxCWIBjk7D/NxutaYKr7AMkJyFeP0VhBLQl3yFrQrd0DO0j+t2dw0oKubhNBjryaScjw2jAjRldwJWCKUmyCAeVco6kdzzD43pdfvKNtuJsorpC9+lD9WXKLYfl/LecUIyhLJA7hfrMag84N+pk23mih/duyjv1sPeKZPz9CUUo8C7zGkm5p+mFcurBhje+uvE00YgCg0RxfMb0OHjsMcAZsS/VGLiwDyLIXO46pPKna+YCUwOvLBFJR95alyVRo4OhDT1SlTqlRBH7Far3G7Xz+7HX/gLKCQJxs0aRGum2LtUZtFbKlKcnJHBMGEO74dyMpPc1QtQcHaXX2Ui9KDLWclzQ1hXrsioiklBSaL8CUEVUt+ageF1HtHMaEqofPEeJMDNWSYk3D1DNEu9u+9IA7RPts/gRCARc1NcoseK8jgnFG/waRRTlO7LR9o9gRZwNODw0MOn7dTC1VSbI7FiEUO0593J+aTMsbrbLueXNrW8XyWLHqRyqZP82nUa+lC9+a/BpDuaETQ4bDcsN9YVd5sBQQDAs5gm73/0pVqzYucIlb3LX/qRGQj9FtlE8RWxHAc11
 aRuDAfgV
 94l1b/w//r/IUM1f6Le1BH5UH/9XNXvDmq98JkfhfUPSnkRejGoCehCwS/LqR7N1QaSDJA0DnJvt/3OY6niBUFX0eXi1+5LbR7Cb3mktqLbWkM2bXhF+1Y/zEUAPHez7Cp6YB3klv272WeQtviKCEtGLN3RY92NKUEimGCMcPpNl86/Ei7UoiJS0QuE7c1PvY2RUNlg3kR3Ivb45YBbtNTl3dSIpFz6+aLmXuJBvKXq30VSIf9DjvX7o4BxEHwGU6mEq5tEoj0iIkI3glSKTBATsnoQeozp/DVq+dFMM7fUA030H/SISQGZ9svheThLyzsQwDNhqHULMGpVdCcCexmrCcPZARwp6BvwFi7BYKd32vKxGeO+z3Mwkh2cb5iLRMWxfahmJ3VVH9N2weOWwIOqKZGuTrrBXnyHbjZA3O1feDQ1hhd3VwUfh7vUs6tXG3Yefz
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Oct 20, 2025 at 04:17:06PM +0200, David Hildenbrand wrote:
> On 09.10.25 18:15, Gregory Price wrote:
> 
> However, it also means that we won't try moving 2MB folios to free up a 1GB
> folio.
>

This may actually explain some other behavior we've been seeing, re:
reliability of 1GB allocations.  Let me ask some folks to look at this.

Thanks David,
~Gregory


