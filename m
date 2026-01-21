Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F257C4450D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 11:52:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0FD86B0005; Wed, 21 Jan 2026 06:52:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9B96B6B0088; Wed, 21 Jan 2026 06:52:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8BB8B6B0089; Wed, 21 Jan 2026 06:52:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7B9946B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 06:52:12 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id EEBF213C1EB
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:52:11 +0000 (UTC)
X-FDA: 84355807662.04.3948A45
Received: from mail.8bytes.org (mail.8bytes.org [85.214.250.239])
	by imf06.hostedemail.com (Postfix) with ESMTP id 112E818000B
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 11:52:09 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=4QbZz+Ur;
	spf=pass (imf06.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768996330;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=O1s4bVh2Rsv/3h6xv/qTf0E+2TTmsrjI97ETgfwYeUM=;
	b=Eg4MvkJZemQhfZJHOpKi1DgAX+9SvaUT057GMP4u46Z4m2ZZe33JpbhVlG7b3JJm7E4hjf
	USW++VMchSWqeKFUDL8wDgkCN5ia5V35K+6S/lLJUkBbGXHX4QkhLDBtjKs6AmlLigzbHG
	6oz9gimXdxNybWZnKQAiNvh6gyzkRI0=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=8bytes.org header.s=default header.b=4QbZz+Ur;
	spf=pass (imf06.hostedemail.com: domain of joro@8bytes.org designates 85.214.250.239 as permitted sender) smtp.mailfrom=joro@8bytes.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768996330; a=rsa-sha256;
	cv=none;
	b=x7YAuLFEhI2W9gM5IzbMP+rOAgu3xYAVCJiPubF5n2+G1+DatjokG9SZASWM6vn2VIgbiN
	1PKziSxhAYLWqQBLJzXTcOktUZvghIvMYAgN+dX4lRfsHMZ+AYG0kMU1vuF3zjg2ESePYT
	59AlHa9yI7uKxChNky38sgWzmT5u4qA=
Received: from 8bytes.org (p4ffe051a.dip0.t-ipconnect.de [79.254.5.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mail.8bytes.org (Postfix) with ESMTPSA id 386A61A268D;
	Wed, 21 Jan 2026 12:52:08 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=8bytes.org;
	s=default; t=1768996328;
	bh=e/LSjLy480JOTxFI01dXHOL1Q7hisUSXSCINws+Rksc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=4QbZz+Ur+wTdgiVgjwQfU//4PR+9fqRE2V2CokJ8fBPzWHPdMSkLrGxLcRN8IGvAs
	 K4iDoYct8JcmgnNpkDM6kVWHbaCeZRBgQgQEJ+ZDdC4rjN6b4atN2tmIlkSIN/uh2G
	 Fs92BppThSWJsOzqhj2gcoRMpBHGzpb0WNOkrcbevepuNmt+H8PQU4c9MNpdAFVkyU
	 jl3EgiMBVgazb12ZF6SqRWCeduDP6hpnKlyuzaXHscswbYPgBn9jeLmO9iY/QcAP37
	 BpvO8WPu0MIrmuKaLSWYpfvsmK2k6NrxkHJDg2PdrgHkMMWHLT+0S3AstXtszkUYQN
	 Uk13cbOy/t3AQ==
Date: Wed, 21 Jan 2026 12:52:07 +0100
From: =?utf-8?B?SsO2cmcgUsO2ZGVs?= <joro@8bytes.org>
To: Mostafa Saleh <smostafa@google.com>
Cc: linux-mm@kvack.org, iommu@lists.linux.dev, 
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org, corbet@lwn.net, will@kernel.org, 
	robin.murphy@arm.com, akpm@linux-foundation.org, vbabka@suse.cz, surenb@google.com, 
	mhocko@suse.com, jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com, 
	david@redhat.com, lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, 
	rppt@kernel.org, xiaqinxin@huawei.com, baolu.lu@linux.intel.com, 
	rdunlap@infradead.org
Subject: Re: [PATCH v2 0/2] iommu: debug-pagealloc: Remove pfn_valid() usage
Message-ID: <p7j3zm4epypqkjmbecxzkfbyqggtbdoee5phfldjlbbxi47oti@fdxe3mt2r77m>
References: <20260120091926.670155-1-smostafa@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260120091926.670155-1-smostafa@google.com>
X-Rspam-User: 
X-Rspamd-Queue-Id: 112E818000B
X-Stat-Signature: 8zbmpj4fcb8toujbtfs6jhui4qwyigp8
X-Rspamd-Server: rspam02
X-HE-Tag: 1768996329-198494
X-HE-Meta: U2FsdGVkX19TPoGel8xBd7NzYrN1DSJhAwhXvVnA07bUuZ2+tW/o2Xx6tbglo2nitAH15D9T2zfqzXB7tMhfPRMpb/zfn5SX0N/ms/uAIWwJEl4jl8BWB9uGEOrBdpZ26B9cqsNxCPhCaLW9H6BDBBsKxZeGIJFGOQGAGqA29c1317fs9ZeXu0qNKj51hXbBlO7sCmKyWyeC5nV3N6IT8MIcIBZsJ3TsdXAd6kwETD+fKj63Qt9RFeCekelmxEX1BW54QcsEMg1qGpg39uQG3N2qermKcQF7sNE8ex0ccPNW8TkJR1LBUAjhNRTqNYVzSsr3OOSUl0Ys4zb7qQzCzfHpipIDmKa3QfTbUekquP8yGmcA640qKOte01nDsX9CoLepMSov0CJZIrrmXPTWYR78qri5/CdOQ+TTADFVXwECta/c59uXT7KiKvgcDCnnMarG20yA/qsvcupxNvf6YAyBrZA60NPwBDKsJSRl0RgDKg2nIMMFGQNVXMafKg3aG6pfmNPV8L46SCBiQ+03/vjgHvMl18NG5iPltZL7HYERLD1Z9vwAwx6gO4hJSRvFGm2Qi6JO2vyOOQOsvVLUy7OtrK0qaQkN3dnRXe7ww7X0e/PxPPadSJm+sDlkyplkwtkG1ljotCsX2OMfNt1V2Z6/WHWw0WWzpU1OIIFiEe0UkgyNc4GweVpk8xDR9Js6KdQRbkX3N15xeyKgHpOrlfwwrjAzst0Q9/3JV+7iqquBILvNP0oAZgdC+upBpI8L+CMOqXFhJt7lI7uiDGCPBfKr7I4fo2PW/CRZsouYspQllpGx4+6zQYL4GsiVCBBfluZsoNCHAr7ARa96IJMB4Y8XLR2Fm9UBxeEuWCC6rx2n1HrUBc0WO2fpxPBd8XVT38E2Irj+HHM4pY0Z2lmfAnifsREFqfLfJKJchura0KQzjxQOexaq6HC064LnYB3LIEOcxHZiRDJ9eQrPq/q
 o6dl9u5a
 eJ2pz54jJAOwGFcADVNvvMKR+0gcW2DweMX/yfddHNX1Jw6JZKH+qMXB+/b/ELtiCZURwPqd9Ibbdg82PCwGgS+etODjWfAwM0FDn+iEFvwwErB8V6Tf5OWQ9wahijpPdyisfDZeQxniT70e7+UR0kX7VdN+xUoiYPKbP4ropPQhWavmAejg/IbdFnm8KQwax3wgiJVvTmFgA73dEVp9q1C9N7RdjQuMlhXOsG4dJ+rOnSD95OL9nFzMaZqTjQZxOndBV7tw9Jh2sjRdZxVbqv+68wxCsxtsIyz+fy2zWQmomj22s8cYHa9PzBVM+iU+cDEIIwvcfz1sF/HOaBRi4Ypg3vPkexsTEFRaC
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 09:19:24AM +0000, Mostafa Saleh wrote:
> Mostafa Saleh (2):
>   mm/page_ext: Add page_ext_get_from_phys()
>   iommu: debug-pagealloc: Use page_ext_get_from_phys()
> 
>  drivers/iommu/iommu-debug-pagealloc.c | 31 ++++++++++++---------------
>  include/linux/page_ext.h              |  6 ++++++
>  mm/page_ext.c                         | 23 ++++++++++++++++++++
>  3 files changed, 43 insertions(+), 17 deletions(-)

Applied, thanks.

