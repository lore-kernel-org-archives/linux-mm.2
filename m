Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66B67C624D3
	for <linux-mm@archiver.kernel.org>; Wed,  2 Sep 2026 14:33:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 68B2B6B008A; Wed,  2 Sep 2026 10:33:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 63C096B00CE; Wed,  2 Sep 2026 10:33:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 553B36B00CF; Wed,  2 Sep 2026 10:33:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2E59D6B008A
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 10:33:00 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B0FD5140261
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:32:59 +0000 (UTC)
X-FDA: 85169064078.24.6336282
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf13.hostedemail.com (Postfix) with ESMTP id 3D57620008
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 14:32:57 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="lvyoeX4/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788359577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ab01GFbRgvcQHW6lL+IHXL/vCP0OE9+HzNvqx7bK8Yc=;
	b=ii08b4uALKLUzAGFnt1N3GPlLOiCz+ZHWGBpPOK8Cpa4lbb1tGJvDYlSSihWNsnlwByIwy
	RJqtWVtVDY1bQ3rjKNPpHsQskUVi8c49iGN5dOAck501Dt+o3v+aNIvQt0oAb5nTrlSceF
	D4srNzls85cBuj1EJbw0bHUGLJ8Z52c=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="lvyoeX4/";
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf13.hostedemail.com: domain of BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+92e025b455efe38d25f3+8410+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788359577;
	b=A6BGbhyn20TPhj1a/GI2OBHGZIHgxooM4gH+al+rwVhWZZvbC4O6G34Gqx4V/5HuATHpjI
	k4ztDFZpNykOJzpNasBGJB0qzwtuZdq2+cdlk1QhPzytWXDI8kw0mUtFBixxwPM91D73yf
	OSYhIs3r27g+B5rY5AAiGKAOpvkn5I4=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Ab01GFbRgvcQHW6lL+IHXL/vCP0OE9+HzNvqx7bK8Yc=; b=lvyoeX4/6Vwomt2sMai7wj14hi
	ARoojLR0eZqqFcrrSL/ug31s4vdX7ivDA1QDLkXUuWaz6Y/Y53G9xR6NRn3ynXfAbZvO73Ew1bSNc
	YS74Y40H3Sl+gVS/uY1xopeaBGrzmlE9kcBMz/pj++3feuBNVX4fy2ATX/v8ZU9ADL21Mq3UV+7tN
	aRGqshmRXmmq4e0aPivaolpHUnmi8xDq5rjTy3utjWf/hnuFNiQGVh8FLCGU0/puWrg/+tVBBmh84
	0DHeT+0gdmoP3eebKfUW0vZ70D0t4u4Sf6SmdcgVKZ0GFCVbNWOUx8BKnft8AAFNfqYyR72SiNFvZ
	TSdaW+PQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x1m1E-0000000ExRN-3hmi;
	Wed, 02 Sep 2026 14:32:52 +0000
Date: Wed, 2 Sep 2026 07:32:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: brauner@kernel.org, djwong@kernel.org, cem@kernel.org,
	akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com,
	mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org,
	ziy@nvidia.com, david@kernel.org, qi.zheng@linux.dev,
	shakeel.butt@linux.dev, ljs@kernel.org, linux-xfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/4] iomap: simplify writepages reclaim guard
Message-ID: <apgzlDZiLthAD25Q@infradead.org>
References: <20260902131653.1338227-1-wangkefeng.wang@huawei.com>
 <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260902131653.1338227-3-wangkefeng.wang@huawei.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 3D57620008
X-Stat-Signature: uu8ondyyb67xfdwn5judjho16scqytz4
X-Rspam-User: 
X-HE-Tag: 1788359577-551132
X-HE-Meta: U2FsdGVkX19HxYVShSLeI4gkCynEhEJCpmOnDwT5uxsZiJK8U2Ymnff283MmduLEyvvi6BYmcEbaJvMYkbNlFuW2M1j0yzt4r/gHSiMh5ZjY85k9EtAxGZcdWrzoGoi7hhBc1wZ0X1kbaaVWFT2Lz9Gx+w+RrRtDCZOzpLYGRcPW2EmMxi4l6VO/CyHgq0JYmmjJ55bkqLFYq1mB9cgIZ7v2haI3RD/vLKZwSNL+gBT+T/M7zjPYFct337VgZKQbSNTC9kByOo9+aMVgFH3W8NwOfmi6Igoi6BBRrZoz2P+y4tRgWxScls8TSic18CgqnvG8c1OGHvWLyFDqAr5v3rDoW3ENNHR7WFlL7sjH43D4dYgNXJ/PXKLhsQppV7xKU4zUatbmlHufeZgOw6bWtTEum0Skveor4sEqaRnvoGoefZ7/Jc2HGIa+D5ud/HGcPwxF2VWSNoYGx0IXbbhL1KcthyGBnTfWZ3CPQIrCb4aaXhUD+gXCMqHSyzIgbDCuPKVA48IepjUIGZPzpKJ8BxRwx5/iZrTRKR0eaNnJWsJ15L/fG+B3FLput9ITpLuh37CGosmJsjjpFURN48I89DUhwn5Gb6NQwHAeKlLN3UwCifbUy9bS1a1nadq79fDdurICY3DjZBW46FxcrPcDxNyFO8hX/zbnWRSG3Has3gNgMbMj/RIWhh4mPZ79nqjwKdCYehNkcqzTIgsDEYT3HdAIGJTiQbPxf3+muWILmSQ2kY9ydtlAgsSGFPJwbY79XgLf9zZz4LT9gbxBuAFp+inCoHo0Y8lF8O/ApScA6KRwQOmhFVXBHYwS3v4leDFtTtTlmoNTXr/Myn3PxDgRyd0iv1WOVig54GH4A4iiEv4se21/H1pqSLWQJIup9++ngfXNwZnoG/w+1qRtugKo7VKHFApN6ZrpPqy2+skWw3krr+DrOXdC3x7REITUCfEbd4aBv8u8Hvs/NJs3RIY
 sIv7eFVy
 ucssltqYsZLdEK3YXzhFK+GrEo3c6OmaCOuHvGIXMCasreAGn3K/PWXcfUmy1SUEp5GHmFM2/DQQD6ZKSCxmn462Pk03damUlRPV7beWpYuFj42Pv7pUruYTIisQtgdhpQAw2Jmtiyb4MOoshKBBf/a3OsVF9bcScHEq5SK00VNVa5kiAmrpSjK/ycmHJWRAz+9HVlganS18/VkAkN47P2FW9sXsEDDa4UkbUazGg5vXB5A8p5ZXryVbcyh2stg8Abq63bzOMSV7KpmzDWxaODjt1uoo3e4wiaW3AfoyQQZVfT1fo/QF8FBMtq3l66xzO2GiXkEX9wUawxYe1ErcpxdJSkf/nITVw/Q5b358XB7kmD0NNwow/IAVlbq4P4aRi+O3XdRNZjsDniw0LWVsv3LBPgH0O3uJ47O3kPSSwPtwTd8g5/QgZDMTmjKFAbr0tgwtLCj0I0vfb6wHsmbwSqZmMeDmAK36+U5cADVb/AF1HVuwWvQPRjHH2XPGWVAv69tN7xpWIzF3u7PDhQFS41uykC+Aky2DEArv8
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 02, 2026 at 09:16:51PM +0800, Kefeng Wang wrote:
> index 0a5ebfda90f1..6306ca747f3b 100644
> --- a/fs/iomap/buffered-io.c
> +++ b/fs/iomap/buffered-io.c
> @@ -2077,8 +2077,7 @@ iomap_writepages(struct iomap_writepage_ctx *wpc)
>  	 * Writeback from reclaim context should never happen except in the case
>  	 * of a VM regression so warn about it and refuse to write the data.
>  	 */
> -	if (WARN_ON_ONCE((current->flags & (PF_MEMALLOC | PF_KSWAPD)) ==
> -			PF_MEMALLOC))
> +	if (WARN_ON_ONCE((current->flags & PF_MEMALLOC)))

You can drop one set of braces here.  Otherwise this looks good.


