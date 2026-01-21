Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E84AAD262AD
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 02:34:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DC866B0005; Tue, 20 Jan 2026 21:34:20 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 05FDE6B0088; Tue, 20 Jan 2026 21:34:19 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE536B0089; Tue, 20 Jan 2026 21:34:19 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id DA6B96B0005
	for <linux-mm@kvack.org>; Tue, 20 Jan 2026 21:34:19 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6FA441AEB46
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:34:19 +0000 (UTC)
X-FDA: 84354401838.22.8C92740
Received: from out-183.mta0.migadu.com (out-183.mta0.migadu.com [91.218.175.183])
	by imf25.hostedemail.com (Postfix) with ESMTP id 73D05A000D
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 02:34:17 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BsKb/3ZR";
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768962857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8f6m2HPmk6WMQ3NY9h7R0tW9D/vQBCsl6eojaocvr1E=;
	b=Gk44UOGlnC8xcijHiVDW/xb0QRG2mJfR3kWS4euh+8GX+bxSk5e39EYYvQBvGK6s737zoK
	mtb9A+y0rk0LGuqpe1pYJIIyY9szhmtDZ9g8RZxbnlJUnLhXZBEHZLkUDMvCKGfhTDkZEV
	E3hWloamCiQsMkJw1hftTmlJ1+hK/7M=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768962857; a=rsa-sha256;
	cv=none;
	b=NN+fdFsJgA9hBX/EwRzikcqTjlCuIFDEDx0u4K4jNFxChrGWsEJPEoh1VkwNbQsuRKb0Te
	H5hhpdsgXRGCMHzQjuE7JJLOOKzRNoB+9hgTJcP6vFPw2Lyh/UC+J+JUzZZtQtjYSmwdVT
	zrqfTG71gLHTNKr7eLsF2d+Y5oJDgVM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="BsKb/3ZR";
	spf=pass (imf25.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.183 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1768962855;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=8f6m2HPmk6WMQ3NY9h7R0tW9D/vQBCsl6eojaocvr1E=;
	b=BsKb/3ZRYb888kSb/TmdehQrM56VT/cSpzUpB7O2toLKhIFH6a83lMnB+ZVe6rBlCpt3iC
	KB8cr2mgrJGZ4uVRKHIMlf3Pk+iU51rse+lhh22K4/2FFEo8BU9tPZcJ9tCgEiun4if/B1
	vlNLMQ3ACgshYFCbHq0GGcPPGqFGenU=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.300.41.1.7\))
Subject: Re: [PATCH] mm/hugetlb_vmemmap: Use max() macro to simplify the code
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260121015114.560424-1-zenghongling@kylinos.cn>
Date: Wed, 21 Jan 2026 10:33:36 +0800
Cc: osalvador@suse.de,
 david@kernel.org,
 akpm@linux-foundation.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 zhongling0719@126.com
Content-Transfer-Encoding: 7bit
Message-Id: <536E49BE-7247-4628-8DA4-42573ED7098F@linux.dev>
References: <20260121015114.560424-1-zenghongling@kylinos.cn>
To: zenghongling <zenghongling@kylinos.cn>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 73D05A000D
X-Rspam-User: 
X-Stat-Signature: fsamk8xdhu8sn9nj4oo8yuj19nsn93bp
X-HE-Tag: 1768962857-114840
X-HE-Meta: U2FsdGVkX19GVEdxJXNLkTHxr7wIGBg5bIH7mFcZF61pD6TMylI24gfKBhXYcE2jOoM2NSJsNIj2CjYTpQNcuzGXTgdfKvg4+72BYCw90nWq7Rhxw8rf3oVUH/hSBLW7V1tzjxtP6c7XwgDcjUYoGCiE4suf/mFzmWFoPKAHG1gWRPQqqeb7u7lq4vIYG9sPcgKyFJpS4Mun+RIdS5AyD9IrqU7W5Ka/yPtbTQvMw6hzTRxSdWHjnvO8Yo5SRkRWa60o65BO4PCjmkTcsERyvzjVz9JU3VO5DbweZquIC6CIsaT2ZBOQBPgrPe7ikqz4V5QffLvQyipqXf24lrKArCJcdvQ83cBVHZDVFDebpNTl7vaa3jljrZt8nYBENlE3B8jJHfAAiXt+4KND1iNN+AdC58P9MTSjrzgGFK9rd8NCMU36GZSFkCRmnLzEYu5uoR4bVqVB2grALyVlWM9OixIURFibMIZ/u4B9bT/AdNuMt+cH2UoD5xK/X0zbQBR5svT1b4Tm4a/CA9hpQVBuX+oDa0OHISFxxdpKm++O69Sri5e69LtQFnusI0C2+DIwvNK7oaGmY9oiTvSOv4++SYeoIz3GobkmuEWAShzqqwUYOKqfUD/RsPdpGPOPMth/CQILst3nEPUS52RIjaXY8S7Ki0s7qgW5X08wm5pOfQzBZUOOFnaP5xd77XeSrRVsCpca/GRF2NxjGY4yO4v7jdqHAUSdtoToxDI3HXRN+8qW9DZ2qcyF/whikb0srnwLwGVhPz3wWh7S2AY1wByPHFdSWrq3zVr/wkVpcVA6TFP46lXtrwZTVAOx8sE4PEb9bhVnfecFEUPnwwijojSECKibSYB4MBFJzAx/V5sfVne8E3xWSlQS/Zb78zeWcYWGPMglsk3YBSTFFevMAsZI/Ctdf1FC2O0D2gdQzyHscTgMDVDVIoyzmbPIbj8+9YIX/GVv4p3nAREpDXXNSyh
 jdgWjI0q
 dVv3bxFg6JvvPyJp25u5XUxC9MeZK93DCxwrwE5EQlJERCgUg3MU5X/yrhgInE5S1zLfPyClMwQsrVdjfKsVbyzI08jQIZZHfHJHMs/TYZFMmIOC9DSu2m2G4E2/mjbx9LnVnnSMqhwNMK9RAi3+c1FhvM6NTv0lvWfbr4D0/XJWqWJNZezm0WVLdze9He21R14NJAPMUUaAZCNH3MB/LDBS0n7DelDOdg6E+o/G8Y3p2pKgmxxnVA1mylx+NBVe3EzJ3Vp0eg/I1FPWYOjcB519sH5RRFbnoDcghRVNqzcnHx3IvtDCy/xTGRQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jan 21, 2026, at 09:51, zenghongling <zenghongling@kylinos.cn> wrote:
> 
> Use the max() macro to simplify the function and improve
> its readability.
> 
> Signed-off-by: zenghongling <zenghongling@kylinos.cn>

Reviewed-by: Muchun Song <muchun.song@linux.dev>



