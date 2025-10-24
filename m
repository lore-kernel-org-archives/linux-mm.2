Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E260ACCF9E0
	for <linux-mm@archiver.kernel.org>; Fri, 24 Oct 2025 14:20:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15BBD8E009E; Fri, 24 Oct 2025 10:20:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 132838E0042; Fri, 24 Oct 2025 10:20:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06FDA8E009E; Fri, 24 Oct 2025 10:20:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EA1548E0042
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 10:20:18 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 90955BE623
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:20:18 +0000 (UTC)
X-FDA: 84033217716.12.9C80BCE
Received: from mail-qv1-f54.google.com (mail-qv1-f54.google.com [209.85.219.54])
	by imf23.hostedemail.com (Postfix) with ESMTP id 8AF5714000A
	for <linux-mm@kvack.org>; Fri, 24 Oct 2025 14:20:16 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AYQMNY19;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.54 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761315616;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dMM6jx2qjRnMcPOV+lvbPLel1TW60YL6/vWevUW1Pqg=;
	b=IQXVvA/F9tq6jLk9ZDHEHZhaEGcNaRWs+7ZQOawmlKEFNFEiTlsdbJYa0IaNDfrxf+vdas
	7YKYfsRj8iS5u4A9MjTHhSiieQlgE5+CZ4G0zdsWKR7yNBtmw1QzWzj5Q4Pf5S0rEmkA/+
	fgIqrgGhss6PXm78PrtNhuhL4HkS3Bg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761315616; a=rsa-sha256;
	cv=none;
	b=O8y6Mb5qlSvQf6k2YYmBm9FtSDROG30gZBkQSJOu8F8/CdYUyQTly93fsoz/88iCrTs0Np
	eYg9jW5gwh+oXSzuAyKs8TPIW7irgYMD2TXy9qzgEfrhdVY9lipxyHR9t1cmcdvlYlYsbL
	PtBR5zl7H/H+sVBb86/ekeyQQ5sLA3Q=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=ziepe.ca header.s=google header.b=AYQMNY19;
	dmarc=none;
	spf=pass (imf23.hostedemail.com: domain of jgg@ziepe.ca designates 209.85.219.54 as permitted sender) smtp.mailfrom=jgg@ziepe.ca
Received: by mail-qv1-f54.google.com with SMTP id 6a1803df08f44-79599d65f75so18710106d6.2
        for <linux-mm@kvack.org>; Fri, 24 Oct 2025 07:20:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ziepe.ca; s=google; t=1761315616; x=1761920416; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=dMM6jx2qjRnMcPOV+lvbPLel1TW60YL6/vWevUW1Pqg=;
        b=AYQMNY193xpIupVrDzfxp6AwEdow0is/Ouv2rqenyMcYmLVSRdP8rZGxGXmg1e/np5
         MAt3CchnDiiOZ55UmucgyLyjXq0hmhZfwZGgrgQA3rMpOhMj3/99JUItOnmm711Hwfj8
         MWg3Ng/CoSQLX7aC3noicuOfNwU3lFchrF2XepxmpVAioPQFo6ONEnwyZM/CUckWIfjb
         5mo3RAa+c2tq9+GXaRAQzhmi/m7lX16jb+osrABRm8YTaiqbCmuvH3P4OFKhnLes5dSk
         CncbdItn54+RqIZwjWrxvfGes/IuzyJsNbkdwKWacBkczef3LTxlkUXvcQDLSooNwRXm
         Ad0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761315616; x=1761920416;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dMM6jx2qjRnMcPOV+lvbPLel1TW60YL6/vWevUW1Pqg=;
        b=onPMA4j1yj/2BoTPxLQ3JF22N7P5Ioc0q7a037ggZ6/86rhRRJSZjK5riWmBS85m+i
         eNfxZncBegzD9QlUTYoJo3cSsh669ldz1NasLM2qzLbHZNnoJiD5V3wV8Q/z1Xi5P4jP
         nd3lLvY6Kxo5wZv82JBOvIQnDvFhSr2D8z7a78Sh3DBMHT0wqw/UN8nfmcp5eRVNFzY9
         qLfZFgMa5oSNZpp2hU5jEzNmlxjHbPmVsN6xl+QN5BUQxlImy8OQuE4jna120QaYxjqv
         Q0Wjwl2sDAQsemA73eIGSCayIIva6vAOU/SR6Vjq4mdgXK1CwiE5HhNV33hV3Jdr4Awa
         cwlA==
X-Forwarded-Encrypted: i=1; AJvYcCVW+43eOG9DsHVEd0De0VqKMoetJ68TkQZ+uDWxjV6qPPk3xaW8DDqa17yPsaWPYhxb0qReigKkYA==@kvack.org
X-Gm-Message-State: AOJu0Yz1CLnaffW6oKcLz4xVHuTAWZPOGLfIRSsJ59DjZ+2sqaFd/qX0
	mKALc9N4nZRTp2MShxUfZLjoeGiDet9Lgm/AM1ZpTtfyL2hcv8WsuBlWr+8d1+UEUaI=
X-Gm-Gg: ASbGnctjAuEIOHl+wtxI/+3+VYESmgg+4ISIBDxzl7dBAHXrfL223noGVDuXQpa2HhS
	EXeZXZSXsJiaJAiQIh9J1IJBDhG5dX0FCO2pZKSY17/ZPobshyf+tmeo7sxWLDGRDQidG2bcD16
	nAAbh83p7xMW+5RJ8sJLyQRdgcYUxZGB1kQATD5H+Ry2h89djfosfet3zN69muD/YlQlSG+3Cry
	KLV5oJsDTovbWKm59mOGNzxuBup7OfCxq6bz2ZacsnaJjk1GsWvayBZccNKemFnWwoS+wTTRSEi
	SXib+pOmcIH6gDQQtPSlWUep2NDKU/GsKJGBmLDB7v2V9AhpSVX4rcbb4PAGDAfmR+SZ/df1kLp
	WsubEDXOZDjik9WBvL30KQW8JcVrav+xxmgG6cEC+6h6P51/c35UhDcnAJ+Lc4Z+yh2Wip/Bzhb
	+zMrb6m4N8avfrKraUGZopQeDvZ3+qYyM3H3BKFuumRgJPQ0fUCouEQnfw
X-Google-Smtp-Source: AGHT+IFeDksjp1ulZ1Jx2CLnCwxxUl6vBkLTwJZHNmUsnFK2qP03K8WdGRN+VgPtJR0tDr8FPMO6aw==
X-Received: by 2002:a05:6214:2021:b0:87b:ca1c:1aa1 with SMTP id 6a1803df08f44-87fb6458d24mr22936406d6.46.1761315615589;
        Fri, 24 Oct 2025 07:20:15 -0700 (PDT)
Received: from ziepe.ca (hlfxns017vw-47-55-120-4.dhcp-dynamic.fibreop.ns.bellaliant.net. [47.55.120.4])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-87f9e8237cdsm36788926d6.56.2025.10.24.07.20.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Oct 2025 07:20:15 -0700 (PDT)
Received: from jgg by wakko with local (Exim 4.97)
	(envelope-from <jgg@ziepe.ca>)
	id 1vCIeM-00000003j94-10Nr;
	Fri, 24 Oct 2025 11:20:14 -0300
Date: Fri, 24 Oct 2025 11:20:14 -0300
From: Jason Gunthorpe <jgg@ziepe.ca>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Pratyush Yadav <pratyush@kernel.org>, akpm@linux-foundation.org,
	brauner@kernel.org, corbet@lwn.net, graf@amazon.com,
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org, masahiroy@kernel.org, ojeda@kernel.org,
	rdunlap@infradead.org, rppt@kernel.org, tj@kernel.org,
	jasonmiu@google.com, dmatlack@google.com, skhawaja@google.com,
	glider@google.com, elver@google.com
Subject: Re: [PATCH 2/2] liveupdate: kho: allocate metadata directly from the
 buddy allocator
Message-ID: <20251024142014.GC760669@ziepe.ca>
References: <20251015053121.3978358-1-pasha.tatashin@soleen.com>
 <20251015053121.3978358-3-pasha.tatashin@soleen.com>
 <mafs0v7kgjoxq.fsf@kernel.org>
 <CA+CK2bCG011xf7v9nGMq4WQAUta9wDt05+W8KmRuc-JE7ZTwqg@mail.gmail.com>
 <20251024132509.GB760669@ziepe.ca>
 <CA+CK2bA_Qb9csWvEQb-zpxgMg7vy+gw9eh0z88QBEdiFdtopMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+CK2bA_Qb9csWvEQb-zpxgMg7vy+gw9eh0z88QBEdiFdtopMQ@mail.gmail.com>
X-Rspamd-Server: rspam01
X-Stat-Signature: gwzstucb59xdypio6ccg3xn114jc5d1k
X-Rspam-User: 
X-Rspamd-Queue-Id: 8AF5714000A
X-HE-Tag: 1761315616-500742
X-HE-Meta: U2FsdGVkX1+84qfSU9n3kRDiv1bm2KYawrZfOEtaGRbsQR9TpUsNK2RdmBuUAgTG4gc+0vn98SHRDEKUOZuTR5Rwef8vL0H1A2az8CrT2e9w0CiBau3krnwNuH9js5rlVYKDgbeRSbG7GszLF/bnTTM1RPxKpYic7TTAzNq4gUf0Qxumlf4bxkfMhTTVAG2eFHZjk+LG/9om1LY45ceu1bz/BvQJU+ZtRRhPUDMumR5UTL5vKMPpJ4fRPh3Eg1kTvcEFKx+yKzssCsCyKunFCzmkexnQNLYqofwOTNlOqw2lttSlTHCE+bIXDQ1F8G4B6MWckNrAREz85GwDtc+KOEla6P6kzmq9YZ1LtjrUTVpNr7fZTl0WyxMWob2zyS6WpP7Y/SGjqppA0TG/7skyp57tZk1Kl8S2rxkBlK4iS2lMIvNCz6GNF4/2fnQ+05m4Ymp+uimj9MqlDWXSJPQI8sXIXGiueMXE8cL31Bwnq9XuN5BfdLomNWrdSu4TUlKEk9a0PyvnfU/3zMbhygMztkB09tsOyMbH7BlxkTG9cT1D1ik2f3UNnvo4CcxyBWCu5xSlPX2etacpoLTKIOeq0Fc8abHmzzKCDlssGkuVMwtW8XjGReGKeLQ9CN/kLivnLDgU6pdFZ5AOcdUN6rbuuvG2auP3PyzKIlbkOshMCwvILXZEsV8f1MDb1UybEqX7Dwv1iLZvvp+XdlJPP/HKi3YNXvMDOF2XPkKGUriadVzJvox5qnN7aBVkNS8p2HKl8W5coGS/k8tnGE2DBU8g/wfM2ooEf04zXLNuRed6UJA/Puae5LZ2l7zPGemOP+v3tzbqgPOmmJk3TXra8tgwqbD0yIDT/ppCEUsJh4sUUVYU0Hv69NoMCBsOz6UfY5A6W1ZiIWAgjbCTZP/S8zSaQXRwln6mZ+pAzDglkYtl7b2o7RO305DhMqCSct0J4Rj3t1GsDwHlQpeAi9ueHrB
 74VyqyX8
 XHgnbF+2hy3Q/BJYDkR7SgYMH3zN4AZEUxAdh4zi1bfGGc4Nq8UkO3Rh0MhEXVF17zPGZa66pO0w2fz8jSgtD/gum/2bp3PaouQaS0n5aOgiFlZ9tuSA6h6GqSJ7G59CboNhpN+NQhnrC1OyjHc7uokHOzUnjCSGxj33UqQazvxIAakRTktLeOIsDGhwUUO4383Uh7Bk3/oAj1nE6VuKWNYBj0vI1GKFtL/396kMkg2gCLWYvaKi2nHa2SNGzAk9982XdtThgbZQNlBC/8u0AiL20eAY+Mk/qeCkb
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 24, 2025 at 09:57:24AM -0400, Pasha Tatashin wrote:

> You're right the new kernel will eventually zero memory, but KHO
> preserves at page granularity. If we preserve a single slab object,
> the entire page is handed off. When the new kernel maps that page
> (e.g., to userspace) to access the preserved object, it also exposes
> the unpreserved portions of that same page. Those portions contain
> stale data from the old kernel and won't have been zeroed yet,
> creating an easy-to-miss data leak vector. 

Do we zero any of the memory on KHO? Honestly, I wouldn't worry about
the point it zeros, slab guarentees it will be zero when it should be
zero.

> There's also the inefficiency. The unpreserved parts of that page are
> unusable by the new kernel until the preserved object is freed.

Thats not how I see slab preservation working. When the slab page
is unpreserved all the free space in that page should be immediately
available to the sucessor kernel.

> As I see it, the only robust solution is to use a special GFP flag.
> This would force these allocations to come from a dedicated pool of
> pages that are fully preserved, with no partial/mixed-use pages and
> also retrieved as slabs.

It is certainly more efficient to preserve fewer slab pages in total
and pooling would help get there.

> That said, I'm not sure preserving individual slab objects is a high
> priority right now. It might be simpler to avoid it altogether.

I think we will need something, a lot of the structs I'm seeing in
other patches are small and allocating a whole page is pretty wasteful
too.

Jason

