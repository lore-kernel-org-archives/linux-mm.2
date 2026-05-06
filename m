Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EF2CD343B
	for <linux-mm@archiver.kernel.org>; Wed,  6 May 2026 15:22:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB0396B0005; Wed,  6 May 2026 11:22:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A618E6B0088; Wed,  6 May 2026 11:22:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9506A6B008C; Wed,  6 May 2026 11:22:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 855236B0005
	for <linux-mm@kvack.org>; Wed,  6 May 2026 11:22:45 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 223B2A029A
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:22:45 +0000 (UTC)
X-FDA: 84737362290.29.D978966
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
	by imf26.hostedemail.com (Postfix) with ESMTP id 2F43E14000F
	for <linux-mm@kvack.org>; Wed,  6 May 2026 15:22:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mhfe7SPi;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778080963;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TJ9acGiAG6XaPTcTh1H7eLELFD+lKZSJybnsS85i+kI=;
	b=bmICj5zs+OhR5bf0Bv5nyPOlhnlRPUxHYmR1NC4brixgh0Y790Eza9MzTNPakZSASLGGqV
	53dWC0GjjpwEqhDNYYstk/j0FQtCDw7Y6N/sA2AerYSoek/pTl19UsGaI0vQyNwWPC/Ney
	GftBD1RjP2QciBy1YpP1ATWgVplrgyM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778080963; a=rsa-sha256;
	cv=none;
	b=QdnSCuoKXw3OGGFAjgdtQThF4su3cBcRz3M6wjznf0icmZXK2zmJ5RiD0y1zXf2ByHvuM0
	AiNVlzJKu2JJqu2T+c+kskjxNF/yOrGiHKalT6W/SCBZDlFm2Sqx8feKazLfb5jPIohfNj
	9zg9Cv/KVBDVgYZ2CttDY+rXCv02vHA=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=mhfe7SPi;
	dmarc=none;
	spf=pass (imf26.hostedemail.com: domain of gourry@gourry.net designates 209.85.221.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-wr1-f42.google.com with SMTP id ffacd0b85a97d-43d77f6092eso4140099f8f.2
        for <linux-mm@kvack.org>; Wed, 06 May 2026 08:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1778080961; x=1778685761; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=TJ9acGiAG6XaPTcTh1H7eLELFD+lKZSJybnsS85i+kI=;
        b=mhfe7SPiEE3IoW78VouJzAnVQjbjGvaZ/IqsdaK2pgwoPkWXsKBqLAQERBHbhz1GZM
         qwNUxUdg4RBpYUeUgqnWwHdE+2Z0Rhi0Vb8XgG74lZDNxCGxMDifHRBaZsuxTdTr8kan
         +Ag2DXs/4d2BsaT/Jx3UE3OAPF4WC03CXrfU1/mzMWU80YsyZnwYETl+4Ut3pk8GFhGs
         XB8CfgeqEI4hH9sFmixcZ0lmqWxqRU3JffrT85JagAQ6upQh+NQ9kq+7+gIMKupq/QGP
         YbP5+CfJO8DhLZS/toe3l1qShXTxMFcOZvadLuUnZsF8aMjwokUEV0yzWDG59J8X5FXj
         Gr4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778080961; x=1778685761;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=TJ9acGiAG6XaPTcTh1H7eLELFD+lKZSJybnsS85i+kI=;
        b=f24OhVpttOxwy+FSL84u6+rBgCshd2MLXlzX3Owf1VJXElCg9KQmUFtUEHBuSL5C7N
         pi1WvhCtZWanvnLr61rlAi+xj+ZcVOi0j0Vi1PLQ1LQtki9Cjs7yc58W7RiTi26om6xR
         rnK1XONy2StrfjPLdMxLCjYgkhFmOwT/UczehT7nriU3/zTZeDFyn6MOV2YblK3hIbJt
         7cHG3dYsxl7MJ3jqDZ2tneFRlWoVWgrEIThtVS3TTzRKsv2cRvi0h7eHH8utlcalxpJK
         k1hwqWOHEFdq+Td4+GEDUChmZcfWAListB1zCAQyalTSr6TROyDZfqToj7tYpuklkQhx
         2Fow==
X-Forwarded-Encrypted: i=1; AFNElJ/njn1W18lR4bvJvaBKjxvgHeb9ii9lO2v92x+O0H88tZUGxKHk8GvGd1FAhgqNbWy4znWHxcds0w==@kvack.org
X-Gm-Message-State: AOJu0YxZnXauEjYK1PipibKWn7PQhu5Exs25D870DLJO8dRIlD+XleUZ
	0bpR9DAvXAxn6QggwSihlgf4f5e1KfrO/VscPOx/UaGpeiTEX2O35wAs2+feUxwsaQs=
X-Gm-Gg: AeBDievGVYj9ibylO1lfCVuRCPYahlfdFKk8je+Bd2NPtOfNNJqwPFMrqzITERrTLpJ
	ZFvVOXzo7Irj1CiWGR7c1lfNJOXTKHgaHKsCd+32BZ2IyGzJmM0BT18hNkbXwHASMqKXUvuuf4M
	rJ6/nPnWdfnM4oKTF+Evqd1VBxysdAX6/hylsgzAWKNXEv8Na43IJgvf2qMpT+o3faVfz5BrNeh
	dzmclcBHzaB6D+QrzR+1546QIp8nYxS7+0z5ApedX5AF1D0hvJZnFc2XJSgr6Be2k0WbJdWCVSF
	E/RLK29OG9ayLd+AuGyMyG15Capdtv34cxWI+sykU0JOPCAlhqXQKOtsy9IN7pjsO4hFqoX5y1J
	G4PKiWcn48Am9r9nZwbBxPBBbhO0y7jyi99b6iz737GRwO2xVGRJHjnSFSmghO5qWxirCQrkZ3F
	X942c76Bkjgn473lG0ja3oczQIuEUOOXy6gW2VOIiZzr89ZQ==
X-Received: by 2002:a05:6000:2386:b0:43f:dfc3:555f with SMTP id ffacd0b85a97d-4515d99d991mr6702833f8f.43.1778080961460;
        Wed, 06 May 2026 08:22:41 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F ([185.194.185.26])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45054b02802sm13350178f8f.17.2026.05.06.08.22.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 May 2026 08:22:40 -0700 (PDT)
Date: Wed, 6 May 2026 16:22:34 +0100
From: Gregory Price <gourry@gourry.net>
To: Matthew Wilcox <willy@infradead.org>
Cc: Bharata B Rao <bharata@amd.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, Jonathan.Cameron@huawei.com,
	dave.hansen@intel.com, mgorman@techsingularity.net,
	mingo@redhat.com, peterz@infradead.org, raghavendra.kt@amd.com,
	riel@surriel.com, rientjes@google.com, sj@kernel.org,
	weixugc@google.com, ying.huang@linux.alibaba.com, ziy@nvidia.com,
	dave@stgolabs.net, nifan.cxl@gmail.com, xuezhengchu@huawei.com,
	yiannis@zptcorp.com, akpm@linux-foundation.org, david@kernel.org,
	byungchul@sk.com, kinseyho@google.com, joshua.hahnjy@gmail.com,
	yuanchu@google.com, balbirs@nvidia.com, alok.rathore@samsung.com,
	shivankg@amd.com, donettom@linux.ibm.com
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
Message-ID: <aftcuvXzHSywFL8g@gourry-fedora-PF4VCD3F>
References: <20260504060924.344313-1-bharata@amd.com>
 <afkDNR9yVRjire4T@casper.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <afkDNR9yVRjire4T@casper.infradead.org>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 2F43E14000F
X-Stat-Signature: qru77ido3s5px57rnpn8bkbmcx9yc9ya
X-Rspam-User: 
X-HE-Tag: 1778080962-61198
X-HE-Meta: U2FsdGVkX18CQBIgUBE7DyVQjLVwAunceUfI+Y5OkkB+wB4obkiotbuE0NcavdcTv0/pKOGwlmnM8I+imgJflIf5ePOOrrctj9+lXhy5NjtR58ahZANuDFHCOH37CpqTirjBQ+mG4UjLQU3knW2GipeEUqTFPF8fCTTY0LkWHDZymZmsVp2Jr0DAJMaaRULLG2CcooqdlaOMYIL3KsUiCJAeKizOgOEtUybmE/g7vnEud0TUXk1zNWuJdK9oLXKwbkyQdCDtZHfuCJhvz8v/DgqTz9iSsDwfAHGuVwWh+dijWIeT3yXdx3lt6KgbuXK3Uap4OiCH6j0jpRKko8B4Pase6UMnv3V+Uy+Uap9v3LnrQZ4tHMT4rCUn0elPzFVKYSzXhVj0xzYay3Bt+KdcFUdpnm0ljbOvDtrKqkXT2XA5M5ytvaA9jKSR7u3DJunHA3xCo7PHL2LVqPri3lC4c7nHfSISNX91wAiv8z/XPDAN1W/0JkruYlVnEsR2U+Ji+0IQBPHBYRIpvgtWS4Y+v9moo0svHPTq1WaR/qe/ueRb8NzggeaWB3xRBSLdR8PL+r2ZjtL6XMHsxIGs3MzEh2z7MB+TJlqPumeSah2XepIoGPI86XMy/6V9fwU2oF1tqXPLkB0gTPThPkYkjXptaxy5+OSHpK2pB93adA6ClZwZVjKF15y0O9m7GOtdBAMD/mq2Bf5Y+KnQxiDnneblPPJu5bb2mLlxSJVGviMxlAQ45FyMF1jUjcWGK7SlOOGwsdKOmGP7ywmSLCkcy7hkWwxPgt60KKws1xN5A+zkjwD3xj+XOlHt753Ps1bDRsOZ8EUik6KMRSdXlZo/Qc+bz0g6Zo76in3OHhymIIxcuJpfta1ys8nK10TWPkgRrwAFKxWRZ+nmwhT3xYwUxpg9h5EthFtSsvoYqbJKI88dLoQuEitOxWx22Ipm3Qw3+m2l79zJ4rvE51g90SOTQ3s
 9UaO4woY
 cveLt1f7RoQQ0+fYeOw99JyWa9g5pQKmLv4F31vhKAk2ldxIU+BnoFZp8wjqhGZAKzLb+eyakB/CcPB44kNl1KE5tgQHuIbgQtaeZxPyhaGDlENvfiIkdYItDINpnZOsWXwRZ6k5c6uJ+ps8YCrU46fuuhdz++fdxnHRxlfWF0fNavOfI8hM4R+EjRi6Ljs1ymYxpHush2Xl5/cd3CyyPKQpoS3R/b9XcHZv4wWBi72hRElZxHRQgwBcrmbSO18aOQCgOedfxwO7wmVXq9ojIXfswcR9rBCxDV+NKQzLXW5R8Up0cKrns0wbP56/cwVTmYpe60orIzqPVa1E5P69W+qrCvqmfGgCW+2+z4I/pOEnDfukLpMlvid8F51EJwhTkuQKDjXMBDWuy8VJPfm40En0xGw3SBbrKY1qQVoin9M2UHfySwko8igXqlFyJJazL5fOcsyK83hkJPh8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 09:36:05PM +0100, Matthew Wilcox wrote:
> On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
> > This is v7 of pghot, a hot-page tracking and promotion subsystem. The
> 
> I continue to think we should not do this.

My only pushback on the general "we should not do this" is that we need
something to counter-balance the demotion bit in vmscan.c, and the
current implementation (prot_none faults) is rather :[

I think this series needs to greatly limit its complexity and provide
some gentle correction for LRU inversions, and I think they're making a
decent attempt at that.

But then I think local memory expansion on CXL is going pretty
swimmingly in our datacenters :], others may not feel the same.

~Gregory

