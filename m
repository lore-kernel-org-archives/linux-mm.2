Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AC91FCD5BDE
	for <linux-mm@archiver.kernel.org>; Wed, 27 May 2026 06:38:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 116A26B0099; Wed, 27 May 2026 02:38:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C78E6B009B; Wed, 27 May 2026 02:38:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F1FBD6B009D; Wed, 27 May 2026 02:38:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DFDF06B0099
	for <linux-mm@kvack.org>; Wed, 27 May 2026 02:38:22 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 828F514020F
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:38:22 +0000 (UTC)
X-FDA: 84812245644.21.8160763
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf17.hostedemail.com (Postfix) with ESMTP id AA4D540006
	for <linux-mm@kvack.org>; Wed, 27 May 2026 06:38:20 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779863901;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=gZgZctWa5ONazx80/7HbIooktEB0G9aNY31hGL5HdbI=;
	b=mKbRJPdkH045w5Iv3dHgii0NryQvpkzZqE1hvwawZVBW94PPOjhlqe97RcquC89cGyJgat
	8FKbapVwlqDfhALKe8IgrPX5Tvh0znvbpl9FACxTpAgozDmdDqshbPdLHKcOP4zeU6nGWl
	YZmYu7iZ4duD/mXqam9pPydTvZvXL+I=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779863901; a=rsa-sha256;
	cv=none;
	b=H6laVpLohbv6CAIQZAxYqoxoO8hW6XvP+maeS4dBYKBbsHSc0GzcadIlos7JdxJqJpyIQ2
	GLL2gY6DygnNq/J8raKJCMc3ddjMz/kkOyY5z6DhidgyrVrBuAWmXRNsG5gE6W6eR5nXez
	68kcmcJiQeZI0cW/vlm7e1yTsSzhipw=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf17.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 47D3D68C4E; Wed, 27 May 2026 08:38:15 +0200 (CEST)
Date: Wed, 27 May 2026 08:38:14 +0200
From: Christoph Hellwig <hch@lst.de>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Song Liu <song@kernel.org>, Yu Kuai <yukuai@fnnas.com>,
	Li Nan <linan122@huawei.com>, Xiao Ni <xiao@kernel.org>,
	David Laight <david.laight.linux@gmail.com>,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-raid@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH v2 2/2] lib/raid6: use kvmalloc() in raid6_select_algo()
Message-ID: <20260527063814.GA17042@lst.de>
References: <20260526-lib-v2-0-ca3f0fc24b14@kernel.org> <20260526-lib-v2-2-ca3f0fc24b14@kernel.org> <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260526103424.0d884374dee8cbc4f9f17c3a@linux-foundation.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Queue-Id: AA4D540006
X-Stat-Signature: ndkwr1377adrr3h3zr3gwdtorcphj7fr
X-Rspamd-Server: rspam06
X-HE-Tag: 1779863900-710317
X-HE-Meta: U2FsdGVkX1/YbTltVKSQZ56+FgHzAnV/sUTIzzTx5/QDhASbd7VbN57TQSevDgbE5yJdCo5bDecskTRikhIFpDn1qfgvvvzzYuavQQJJyN1hxrORKv8zhHBN+/fkuC1zAYCTp2/9rMOPCoWFxXmv5qUNrfMoXtsfpdMNCnPmxUvA6F+qm1fE78B1CP5axj9m4oKufqGG96RIkN3u5cgQBl9C3BBD59eT/VEnUMHEXljjpjrM+z2DEg+bM4Y0n1zGuQEfRMqdu92I0AUIP2OGLSoV88kFoI0AWaGnUHlXczOr2bl/3JJeFZE7Llaz4ZcKFYJ9fKjFvT3yJHkhT96pnBeMC7feDZggfWtVFOtEMXFy/0t/ElQuF7UvQmojpSbG3uXotDVWShr3P29NpTBPcvOHLN3MBBcLV5fQbiPm4Gq3uLuF0XqY+hur6Uybri2ULPi5jP74eywTmCuUJttUtrRqQRqJ68zjyWkRG2nVBycxF5PmQfSM6MXcZH8thv1PMxgabQ5+z5ODWMon4y3OH+VxkUwHyF9dzlfubtR+eMnNkc3enwuhNpngHuDq3JmJ6Re4yvQSdLMuiveMUqHR9NyqY3PZ429TQmVpkoM23B6rAR7HopNKNWPKHRMIMmIf8H0bOiXWYF6Upo40RWAZQVnlAAkYIG9fJCfNNH3onpiLfH6wxu4C5Ow7ycpHULPuPFoXBsjPxYyQoi5UEoD/vZvOUP3/ZQZgwzF1a53p/5DReN+wZBLjCjtuo1VgmShATMaBZ2PigUliBuEm8RmpozetTK/sShsqI/DgsGwkkFdOKDt+tddZQ3JXHftqBpgcPXbOC2q2/djvE4YNoPy0S8LHgdTrIAa2xVjxVWeAeM8/v+09JFYB1gs7emzF9qttUgigieEKRdyi1L+Q7MkfNdstXdIRmkuHY69ujwte0k/lAUZQXZutRCz1xMoL5/xNHNK7K/fSfeqL24+qlQ6
 5Yb+QhfY
 Y+e1AeuxqyWBT+LMtiRVSF7NwHc3pEjO4xT90z0Jemw3un8HEzy9YIwRCsd+hnqimrwXlaavScgRnIQGL0afVqR+8qAVtL+neW2go6JBiFzcG9RsooBGlOKg1TYcf3mjVmb5y6dZPrqJMv5k2A4JzWyLBqgOrdqKewJNE/XvejxJkHiX8GSNOOb+wXGY5tlcjO1k6/fFEnyg1+BXxIowgP4Dp9g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, May 26, 2026 at 10:34:24AM -0700, Andrew Morton wrote:
>  	/* prepare the buffer and fill it circularly with gfmul table */
> -	disk_ptr = (char *)__get_free_pages(GFP_KERNEL, RAID6_TEST_DISKS_ORDER);
> +	disk_ptr = kvmalloc(PAGE_SIZE * RAID6_TEST_DISKS, GFP_KERNEL);

This changes to vmalloc for no good reason.  It also doesn't use
the _array version for overflow-safe multiplying (not that it matters
much here..)


