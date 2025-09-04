Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC663CA1012
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:53:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E96168E0009; Thu,  4 Sep 2025 19:53:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4AC18E0003; Thu,  4 Sep 2025 19:53:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D338B8E0009; Thu,  4 Sep 2025 19:53:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BE7D58E0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:53:15 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5B362C044F
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:53:15 +0000 (UTC)
X-FDA: 83853221550.26.E489D09
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf21.hostedemail.com (Postfix) with ESMTP id 7C17C1C0003
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:53:13 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lr5mwcDc;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757029993;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/2RtdVXkTODsXddtzD5LID5X8DGXKOHDe70pXEgZ9X8=;
	b=N7NdfW7Da/zW5SPDXxH3iOMIYucousNbGtEeaRXdI4qF4YvOMxUgnohrwIwXyUbUy4BPW1
	cL8KlS1Qv/5Ln3GWcJQlxCPdfZyl7hr++NH1LsPjVP1xMHcm15uDxV1dT7pxG8xhHIIHJf
	KqsaNyFFqbzIID17yjZHXlUQsSHNZ3k=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=lr5mwcDc;
	spf=pass (imf21.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757029993; a=rsa-sha256;
	cv=none;
	b=Ie0rEBTorwhEb8JrBux9YhwbH5t+4vpd3nhhs8NSKBmXuqYRaDw4ajCpx6bT1HpQQWld5s
	ad9mlx3T2/KqgZ6PdLNuxmjWnxCP28bMZ9jq1UhENlKMtAWz7Od4cjF8gPGbiv/KdWkl65
	Y2EU01wzpZgcC8BBMKQSwSLGY/+QbDw=
Date: Thu, 4 Sep 2025 16:53:03 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757029991;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=/2RtdVXkTODsXddtzD5LID5X8DGXKOHDe70pXEgZ9X8=;
	b=lr5mwcDcyNFZleBt/+LopcJ4pLfJXlGwW5bnE8uS1XZKSmmuBC4G07KILcJn20ZL7g4cOP
	ZR4Exm0UGHKG0GsaUOHJRMlkkd3X1e1sCQCp0u2MJAo8lvFUlBJVRtQSuwh0EH8zBIGM3E
	nzKPyB1gUIHwtEwilh7Cq5YJPr34iAY=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] mm/show_mem: Dump the status of the mem alloc
 profiling  before printing
Message-ID: <6bbrnimtosca457kn3hatu2tqvhx6mfrswgxwes6jo2w54cuxa@kq3nem4jtlis>
References: <cover.1756897825.git.pyyjason@gmail.com>
 <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7998ea0ddc2ea1a78bb6e89adf530526f76679a.1756897825.git.pyyjason@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: zxfs4pqco4ekbdh8abk4xf8tcgzkegju
X-Rspam-User: 
X-Rspamd-Queue-Id: 7C17C1C0003
X-Rspamd-Server: rspam01
X-HE-Tag: 1757029993-50967
X-HE-Meta: U2FsdGVkX1/L0FEKnFpx5zMg6oS+JpOG+5s2mFR+8nukAfq5o7s77ZX8dtsvb4kJiJmn3tcd05qavjY0/NOGF/raivrfDiJ1K5gi5jeOeKFGdSzjcPDF9x5l6d/Upo5fpkGPbbx8OHjae1DyOzjQSQa3jZq/M6ZwoG/ocbQYCqygA86Tvo7Vvjco/Gd1vXPAFCyF+NrT4/5NpEq95xfr3Ht7gTlH5mYsO3W96xcnGZZWBEq11bNwrD7XHvMwSQl6SBmgE4geeF/ttgb8emRGJydX97jl1HPVrIWEjTxizhV7tjKkdDTSEQQZFJHzjnyD7uYJd7K8k5B8B7ZqycgVa1nlNOuhZ8siHvbj2GY9qX6uZ+g+z1sfMN1QFZVmL/qLEwGJrpgkz/EublW9G4lstW+Q/BD1tvak0ptWuZLwmxuVQLrWhQMSDTHR9ZGcpkfpCmfGdO/wfc7KWTxR/G7dJe6/bmYyYWOAjZvPGA1sDgaHTBscmQ7vb1RdrQVeejq32hoin5kftBsFMq0PBxxQyEgq9Li+teq+kc5ah/Dj0/fS1BUnWrno5mxT+/QUT81oVFfokyBzxDdJ8VyHPI+BI0ryxpeQ882s51m0vxM4QWFEXD5nwD2h0j1ncDtBcpSRi71G7txrz+gNa4CSlt957YAQQMI4jUW3oeZRLHBITnjLJ81613AhJpune4dcdDfn4X0qXFBP/yGNDseKJ57KScJ0dH8FuWgi1vXpEUmtlaBs7JzmIctCc+rV3x19J9Mh+bIl6Ip9glJAh5ftRn7IV1YBlbFItabGrVSG1sbDVK1zMCuu4FaroyOvUZ8+BopnLE+XKEUFCP173xcwSDisALhb8fbAF3R/21lRVqSdySYBgrAs39z94vkn99XWsMkWoQXD54COg+pbZRCUnvosvr2V08SytgZgb0doAh49U+EMrCgrv/z+bQVnTdAfSAWRftnY4X1x5V3rUMY4knl
 yxYAYu+w
 JLiUwBilGiOCB7Gw+K3I+LUUGZoeA44zIIkxFaQimxQUsRdGJB1u+6Bpb1JfcaHY94idgVHgPqoRUf/HA+ERNVqROfpS4j990vbTiUt8LD1L/CVB4gGJsXdSNx0bdT/ojLT7PzUglebGMeF2cRkigPp364OxxUReHPgRE/vWtS/wsHjeetCr1pOFq6h+I2EMKaPWyY3yj/9v9B68UbwmaMcP/ltCUfH9WjPe7932bdrYWNyAYAHToeDnlsqW8sfBo9S3DPIMFX1B6tQEz5oHoR8ha4q7VBfNI6Zo1nWNhdAvaXQNWKFwtrNgosaTQYuIEXYOdNonyXq1BHpKFhknqLNrKHhn4Vl1RLUi/
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:16:13AM -0700, Yueyang Pan wrote:
> This patch prints the status of the memory allocation profiling
> before __show_mem actually prints the detailed allocation info.
> This way will let us know the `0B` we saw in allocation info is
> because the profiling is disabled or the allocation is actually
> 0B.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

