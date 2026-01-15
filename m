Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 64EBED46617
	for <linux-mm@archiver.kernel.org>; Thu, 15 Jan 2026 19:43:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B5CE6B0088; Thu, 15 Jan 2026 14:43:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 872A36B00B3; Thu, 15 Jan 2026 14:43:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A94B6B00D2; Thu, 15 Jan 2026 14:43:27 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 674606B0088
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 14:43:27 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 192E513AF24
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:43:27 +0000 (UTC)
X-FDA: 84335222454.02.CEE8386
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf17.hostedemail.com (Postfix) with ESMTP id 16D7340004
	for <linux-mm@kvack.org>; Thu, 15 Jan 2026 19:43:24 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=evK83rBN;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768506205;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A23V1QRMEvs5cA8OvtUBzyK5zu+Y6qwqjP41AnCooiw=;
	b=gB3LOdbmemOWd/K7cqlNbhTKIKxmzOnsyRUSpoxmSTL6U2MFDESBcEBhSQKPQweP6l+DSQ
	mGV3NxC9YV2DX1JnWWuWhts8sJ5YRUbkJ3p5B7JxhvudhBLTjwdYKLk4Fyb7IslOtKXR53
	Zz6DxFdBD24S3H+WTOgR6c9yTNZHAL0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=evK83rBN;
	spf=none (imf17.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768506205; a=rsa-sha256;
	cv=none;
	b=7+cgJORBGqdIMWWTsqiKKnUC6GekqWtVroQjkIjuwfUPyCBwBbJC2i2aalRB8dBPsOW08n
	97xT3U1Bae/FV91Xj0BXWblpRhhR1l/KeoyQQbz7C6oLosEV9szlePLtlT+1Sohep/D4A0
	j2eNzN+VrO6IlRYvyr1S8ObKKXzrCYs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=A23V1QRMEvs5cA8OvtUBzyK5zu+Y6qwqjP41AnCooiw=; b=evK83rBNBmurb078aDPg0RCpe5
	lBegr58Fcbk5MC+bakyDeXD3jhwiYBs8JKTAdfCioAd9gwHOydNi/1JhvqQ6xQSdWrncKN4rB+bfU
	mTNAnm6fdzc+68gQX5nqz5slJy7F8I+DUiA8XM7TB6135ZWJdNNtGLQ7ryIOGKlstTGrIkkyNH4ud
	hpVK8rQd1i63UxCsMT6n5ecuybCO+5+EmxNdKr1CdSzBPm4QXAjKo9lyvCuVY1N807YsGqpwTZJj6
	JJzlzjc17yVqocbJ2Q7Ymg52LUIeqNo0p6XKgkY+td698I58vUVYgy3gJ6Mnw8O+woybuwuV4TWOb
	VVFPcVwg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99 #2 (Red Hat Linux))
	id 1vgTH0-00000002NbF-3BWn;
	Thu, 15 Jan 2026 19:44:50 +0000
Date: Thu, 15 Jan 2026 19:44:50 +0000
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Christoph Lameter (Ampere)" <cl@gentwo.org>
Cc: linux-mm@kvack.org, Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Mateusz Guzik <mguzik@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 00/15] kmem_cache instances with static storage
 duration
Message-ID: <20260115194450.GA3634291@ZenIV>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <0727b5a1-078f-0055-fc52-61b80bc5d59e@gentwo.org>
 <20260115020850.GX3634291@ZenIV>
 <806cbde4-fc0b-7bf7-d22a-2205b46eaa96@gentwo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <806cbde4-fc0b-7bf7-d22a-2205b46eaa96@gentwo.org>
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 16D7340004
X-Stat-Signature: f13fhxb67hstkjrpi9dw46tiiopddccw
X-HE-Tag: 1768506204-670441
X-HE-Meta: U2FsdGVkX19PT+aJ+AXMIysbvB8ujyOyLntgtex3Mvl0+BCLxqNQpqoVxiqXF1MvnSxQB/y7ocVKMSSWDRp/IvU4pbZyAItqHgnKyCiF3WqM/kbeF7pDJnSPvt9a/rzyeIvsWk2myUsnqv/CnTFo3/tnWrA+5rjBwGkE3IPYnfE2Q9m/hhOs55PvMcedIZ+ZvwdDmm1MI2vHGRML5G9mnVSA5gqMtoe4K+ex9mcSMk16C5iZVtKjxyHugkxikVMYweB1D34Xguy8kQxZBCyfhEnThgM1q2MBYCaag/8cjO4yjPy9KJoYL1mEU/+71piQKI7pYaBKOf7MAd6it2vz8AEicq/LXOM6Zafa0pV8y3621tHOrPWFCo4ytWPczP274bSFz/crwcLEihK9F3mhy/ip2rtzTVmExtbI/q0YLjqmq6VPbi5DjTvpzKb0CbZcheoYzH57ivHoIOvwskb1SkEgPMAQs+5nI97vewUk/s8MxnJhWf0VxiZD1lRBUoe/dsVjhFUWJaleCI+8bmMmSzkUr7mChUWhFYqk0Jvn1EXv46WrqtrKJOrTcfeHS4rUI1WPKA67s3+yxsisTaHQ5J6s9DDo8eUv56Iv66A1LiS6hiYY1kRIwPAdRNA5UItCF9PQFpImWKsSipRZ7/zJgWp8864v48+E79x9MeTugiQ1TG3bcJAdZEJxYrC7MiZpwyVtBRh26wABCAJLfOxz4GRFCqA9xzeYaV1Why7WRiz0hm29elldqyjRHeW8U22siPCCqrGPdVaPu6yyQTuWYC9WY6H8IZJbBax33OZVSNLtnSZFcIsR1ymB6wP+DcEbGh0LvR4QMjx7toYEGCmBtrp7iSN78B4wbmpu4Qiz+urqd1L3bI6ZwnsRJSXLsbvFOzgJ1tLgyltyZqCNFer3PD3nEDXmG+mi6Eyq0b1vfb7bOaN6rDttQYJCB4ts74o9kHiYi9KULKHsx7dMRBI
 Rq/KYcm5
 tfT6Md3CJ9PD6QawkTfZd77BC7Cb6G4L2vvijItZnCKuanelyWlIbmacFn5oZJovxYrY1N/US2k35SVd/TufOhJc5U1Mo60LkJYpHmGSwCs17Axgj4x3BFjn40R44ebIJeI6q7OFfxegUCl71zaEwOnG8TjInJwhscb3K4lYLWdNZ9wltfb5K73lVwAk5p4h9KtOqrZle3wrrt4YmEReELV44plpYSc0SxJoyfQDNLtZXk9+mU3aAQOW5Sudb13UzJr9XW5dJjBKJxCBt8ok7gnwIhCmnVOwMAHbsSnUPnLHFJ7ciq/BXSu0ib7q4MK2h9OtrtjhydZ/wl+X5knn33ztpZswm+1RcDlxMpNZXblD6VpTwWie5F2GQI7Mq/OGyA3hM70oWbQ/hMC1zlAUaHZ64PmkCTR08yDw2N8jQoehB2OzLcD0hd2/pg7vo39obeHqFKotef4jRWEbU8ipgFbVai5YTFGsS7BRTA5drhLwgxOQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 11:10:00AM -0800, Christoph Lameter (Ampere) wrote:

> Internal functions exist in the slab allocator that do what you want if
> the opaqueness requirement is dropped. F.e. for the creation of kmalloc
> caches we use do_kmem_cache_create():

Yes, I know.  Do you really want to expose e.g. slab_caches and slab_mutex
to the rest of the kernel?  Surgery needed to have __kmem_cache_create()
do everything is not large - see the mm/slab_common.c parts in the first
two commits in this series.

