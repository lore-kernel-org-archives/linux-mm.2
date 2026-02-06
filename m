Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CCA26EE6B66
	for <linux-mm@archiver.kernel.org>; Fri,  6 Feb 2026 23:14:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D4FC6B0099; Fri,  6 Feb 2026 18:14:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 158E26B009D; Fri,  6 Feb 2026 18:14:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 03A496B009E; Fri,  6 Feb 2026 18:14:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E6F276B0099
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 18:14:55 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9379C13A71B
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:14:55 +0000 (UTC)
X-FDA: 84415588950.01.0680176
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf14.hostedemail.com (Postfix) with ESMTP id CFB41100005
	for <linux-mm@kvack.org>; Fri,  6 Feb 2026 23:14:53 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VUnuFhx5;
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770419693;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xORO1Htmm6YxNYM1C9oAOOlxqgAaEPMiLYXG8QXy21k=;
	b=OfcTdahSM6sPoSYSEn2e8qC8Td4iOijeMCoU+C7uWCE8x1k+cKiRS6klqMzTswehEtNM+J
	twoHICO4TYe1b2aZDvA5T01pjn/iJpWUXarWLtjSva13lfHbtcw89oxnJJotX/bF9gkH+9
	dSsChRMH15YeyG4U6zQMKqdlZOQknxs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=VUnuFhx5;
	spf=pass (imf14.hostedemail.com: domain of dmatlack@google.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=dmatlack@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770419693; a=rsa-sha256;
	cv=none;
	b=HrMtB6t0fg+FYyj+W9Yd3TNdAg33Jmw42kqeJxLKM2PUVlceB+gGy5D3xy8jivlmzOdhbj
	x4yAa/UtCFPC/84jKXozUKsivhh1YR31MjB5lIgIE8AS6/pepYpnFKRtGd7TX6ghBAUR71
	jIaT7r8URfeCl1+YN1IDtFrVYV1Qwh8=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso18422625ad.1
        for <linux-mm@kvack.org>; Fri, 06 Feb 2026 15:14:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770419692; x=1771024492; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=xORO1Htmm6YxNYM1C9oAOOlxqgAaEPMiLYXG8QXy21k=;
        b=VUnuFhx5yYpHrV56BXOG6Y4raT23EC5qc0frXks96nfGxDZSZWIPVQBP7R+afCQiLR
         PT3qGjMUehOpixCp2/oDvUNuvtnMZaONp8R2zF50zw3kjA99UG8uoiiiOwmnLQGPerlG
         7ovnaviA1EiIPx2h+iYqG2Ju0aOxjQiKF1Ldy2PxBXSY6rFCtAyUIqXAUF3bb09/GPuN
         qMLFt0qpPscFTYI4x65KOKy6mzZB0ytV1cM/a7And/UeENCHrYs5hNFDs07v2dh6+IKs
         1VVCnfycIKx5X5aW9Gno3yRyXSREH/rihoGTcKre0HeCwcB+GJadIEfKtnyl9WQZ+tpY
         U0sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770419692; x=1771024492;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xORO1Htmm6YxNYM1C9oAOOlxqgAaEPMiLYXG8QXy21k=;
        b=fDXFlLJdrEHit6visG6wjn7yRcHFc2lqTLDb7o6QHcajGOsl2kFzypWiRUFuGNMbE/
         M4IYtLKLCfAFGb2F7pPyuvgEwoaMtRHkF4L0+FvJ2407L8RNmY5KIKHTEG5aTsITWgih
         blLTVZZWd4NSzUPknerXnSwea8rG7HV0F9hZeOsdRsb28UENr+EATcu2CSw+vJ7Y5cUk
         HA4if532aco7AlPFpxJRXqxR2YZrjNA/mkcJehzZd08XEezxUUlHvxl2kxLPj8sgzLTj
         3XitQ2Nwv0Dd7Z5k4IHT5n9aTjUxTeMUyAFXATq0Krxe8A9PRilcrhDJ8oJiAR0sSpuH
         X8Qw==
X-Forwarded-Encrypted: i=1; AJvYcCVgcxVnuw23iMf2NfolQw9k612wk3602jHikviWXzxaJWoKQBBLdwczihEBqB76HdIzkHZUbyTM7A==@kvack.org
X-Gm-Message-State: AOJu0YwZJUR7qFg5wFhpALQNefkYqSsH30i5r71OGYUNF4vMMxpMShcm
	Oy8emxg1zoyaKL5ZBRwRVN81xOyB9OOVT/DdjcA2kL/k0JDnWmy50XW/A+y/REtjFg==
X-Gm-Gg: AZuq6aL0JNhDc6PpvpgzTD9rQtYaoJ3RJ/7wOL89+RtkU/rPxXKmEzRZb/rLZ7ZsJ34
	3qh7cFve2StXkBPJk5bZbCL1H5FsqdVtTycLWwUPw3h5JwAHemlz+6+tzI5M2egiwMZz13zEAQJ
	HasfnqJwHjUMRJmH5taWAegxi2XhGb93QP6nDysDLjuv5Lw6ASMvIThwBuOiDvIfZ4bcxVwJCoW
	2giPEBcBeVysBJF6arpupncVZzj6IbQMDBsCrfhQYXvR5S0dEc9CTCDDe7XjpxDG2I6hiepYXW8
	5U/Yf+NFh7eumaWkud98NgScYw1rxovL+WK834+HuJlzKi0hGSN66rJqdqnklqrQwoigHJaIor4
	XFNWyourZIzGUnlHfERT8D56hdJGzoBpYMGw1Dft44WWjpYtcDJEX6G1n6SxlPqtMPNcn1ko0Wu
	ZPyh0dEPI0wFX/l7fz1th7ZuSqRfkUhNHNN3bQu9W42SQvp4jRHg==
X-Received: by 2002:a17:903:3bcb:b0:2a0:c1ed:c8c2 with SMTP id d9443c01a7336-2a95191f76emr38694515ad.55.1770419692202;
        Fri, 06 Feb 2026 15:14:52 -0800 (PST)
Received: from google.com (79.217.168.34.bc.googleusercontent.com. [34.168.217.79])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a9521eb87fsm33865195ad.71.2026.02.06.15.14.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Feb 2026 15:14:51 -0800 (PST)
Date: Fri, 6 Feb 2026 23:14:46 +0000
From: David Matlack <dmatlack@google.com>
To: "Yanjun.Zhu" <yanjun.zhu@linux.dev>
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
	William Tu <witu@nvidia.com>, Yi Liu <yi.l.liu@intel.com>
Subject: Re: [PATCH v2 04/22] vfio/pci: Register a file handler with Live
 Update Orchestrator
Message-ID: <aYZ15u120FEa8Qw2@google.com>
References: <20260129212510.967611-1-dmatlack@google.com>
 <20260129212510.967611-5-dmatlack@google.com>
 <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6dc423bd-36e6-4f97-b2b2-c7030575a3a1@linux.dev>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CFB41100005
X-Stat-Signature: xghz393b3irxu8f7xfnnur4ru5s4uak7
X-Rspam-User: 
X-HE-Tag: 1770419693-407999
X-HE-Meta: U2FsdGVkX19LkqcohF8Cjupd2vTbKm3z87ujj537e1qPSgEruqnjls/eMb/BfjmbVGVjC9RLuL1akO/rY3Ti+vz/vf/yzmgkJb3XwtKrKj7lwbfXnRNtr2Ud8PQNfNx7Ue25LRuwJkaekbyyK6Quq/Lm6tGqipFd6lh6lC+3ZF0/+LXPq6cfUCOckxfjMFgkRNiL4q9xxGFZzTcSAJopieDgPwG2yl9p3hWjC5IrMwCOm7oC7L7B8JDC+G9ETP0zdyMd3/28+DgSArxJQ/Go2+ILKeIQXOSiwfDck82w5H+HCnq9qa/0sgpPNG+Y+S6/JIZ8XuLnsaek7PSulO8q68RBhUeRwIEDNPx46VbZZNTquJ9U9JxLXcV8NYiwg4dB2cxh8mmB96FUg5kPuiiAEGyuNdcmz0Idz3P1cy1vWQdb63IVTNtG+dfLX6yC6UZ0fHCqVBaax1fJ+eh672AkFxJYv8dg9VLXa/rEYA8asWsMOv0Oi2zH2WxeHVATk9r2l10pktt9PTXhjVL8j6EwA0OYE2zq4+7J5whM6CYTw5nZ+R+bC1iPYa2BpAxC9ZdniGPNhSa1kQGHfKCgYmpcAs8NgEQhRYGGKdgXNI/66b09ekeJtuhvjK7DemYlPFz2QrHfgDeiyOS2xyul9Gc804JaG4jfTuizWAs6coBZF25fQcDR8c8YPVRr5wXSCTV/k5z2MHeAb8n8/M9s8dUMRwHeHMARk0RmkcXc78dROPjFx/w0FLbdint5c4N7972y4iSP/7vuRmwWaEJbPRUHtg8JGOP0hrjHHU4qu8zA8tbMjcyKk/djIuSHgy+3dgxp8WMBaaCJZY4NpuKl4QZsnXDlou+RfRN/CFm6vGIrVN2SaSk88hjaS/asE1LJm+h47iR7rtA53yjB+btTJqDJoGVRQgXoWJjzsikvcd3XjprU6HdBzy0deaju+gizi/Rlkrr4dZdY0my0vSTOEug
 cPbo+2AF
 Ba2lxpOveyVp1IVyu8wZ32l0GZA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2026-02-06 02:37 PM, Yanjun.Zhu wrote:
> On 1/29/26 1:24 PM, David Matlack wrote:

> > +int __init vfio_pci_liveupdate_init(void)
> > +{
> > +	if (!liveupdate_enabled())
> > +		return 0;
> 813 int liveupdate_register_file_handler(struct liveupdate_file_handler *fh)
> 814 {
> 815         struct liveupdate_file_handler *fh_iter;
> 816         int err;
> 817
> 818         if (!liveupdate_enabled())
> 
> 819                 return -EOPNOTSUPP;
> 
> In the function liveupdate_register_file_handler, liveupdate_enabled is also checked.
> as such, it is not necessary to check here?

Yeah that is a bit odd. I see that memfd_luo_init() just checks for
-EOPNOTSUPP. We can do the same thing here.

