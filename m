Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9443CDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:33:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 70DFC6B0088; Tue, 23 Jun 2026 14:33:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BEBB6B008A; Tue, 23 Jun 2026 14:33:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5B5396B008C; Tue, 23 Jun 2026 14:33:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 354476B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:33:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AEE1A1205E0
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:33:54 +0000 (UTC)
X-FDA: 84912026388.21.C60A596
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id 20BE9180006
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:33:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HmuvRFHe;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782239633;
	b=3p8MS1i7Gg2yByOfCKVp9t95Ns9G2Y5PFGp8CDChj5/Zc6XNCVO0eMraLwkoZDqF24OEf9
	5qr59AkQnsHwaHf52jRjDhSwHL56slEHo9VSqyUaVmiIvftslnQPAlBBiz8PRliKA+UYt3
	gN3zsrFpSrxSy3u+FvrAEEmnRuJ8dn4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782239633;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8gavGOESHLq3+poxJrUxbYbmCuo9oiYFM15F/Tg6AEA=;
	b=tQNbCPVH9RQSxGrwcoO12Ztd745D0/7iGFU0kEsQHrGMplHkc5drot+fknrTKTiUHccfRW
	1Cg4VE2lzJu0QgfkCsEIWezuz/QUrhNVbeewsPPP31uqo8vWd0PyilUvV56oHPe0I34x4h
	0gK6ppXVZwO1oZcQlKnNa7+ikFzqWkg=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=HmuvRFHe;
	spf=pass (imf06.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=8gavGOESHLq3+poxJrUxbYbmCuo9oiYFM15F/Tg6AEA=; b=HmuvRFHeDE7oJMQz0vOstfzrQZ
	caCfhKNV7npiQ9lxy2BfPq+mh/C3C0nm5oPCSr7DO2Ubc61J6uJxhYZAcprNT9gWiDtpO3JhMIZH2
	c+B9CuXL30eQZ5nTU+FlHZlGMM2IvnROwgBxPkEkByNe8jxasvwd57rX42o3l8KDJrWErQVxVtP1N
	1fQSn62S/yX4og+7pYw/D3lQZaO50zuxLbxspWGoPQ9PCq14W+crmwXsT//eJqlEDBqfpHLwo7E7W
	AM2fCdu0SwaipdbFyBVeOXcAWPMIYGJ8MbM0jgjYmElkgn/tir72WYvOGIew7cMxKvt6S9NmfddqV
	ZYaUEwqA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wc5wM-00000006cwF-1Y3h;
	Tue, 23 Jun 2026 18:33:42 +0000
Date: Tue, 23 Jun 2026 19:33:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: "Christian A. Ehrhardt" <lk@c--e.de>
Cc: Boris Brezillon <boris.brezillon@collabora.com>,
	dri-devel@lists.freedesktop.org,
	Steven Price <steven.price@arm.com>,
	Liviu Dudau <liviu.dudau@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] drm/panthor: Check VMA boundaries for PMD mappings
Message-ID: <ajrRhpVH6uhOABnV@casper.infradead.org>
References: <20260623181942.1536598-1-lk@c--e.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260623181942.1536598-1-lk@c--e.de>
X-Stat-Signature: aueir161dhdqdhd67ni6tpa9in9336kt
X-Rspamd-Queue-Id: 20BE9180006
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782239632-954780
X-HE-Meta: U2FsdGVkX1+8ay+DaOEzJIrQppMdcLMLFqIfvgw5DFMQICEtX5K/XyzpIgNP1rpzg7T3a4wuuhDwFO7UT+YboV10KQrocBLQvrDBNVNFCre9DrUubR83QF9LSedaagLYxKO8E5AkUlNrr/5P7cOLHW0LJ/Yh8rmF3logxq9FU0e12SizPwWJv1bds0/ig21GTlfrw6emoLwZMMUwo51EgBPrCOxmgF3h6gSMfVTNAepfXLHrtteWI14tkkRVcyWoY/4zFD6xGERcdha4NZNFLP6IF8BaVEkhq5XJQfaNkdSehAFTikPhV7pZJISxWkh+2cIiAiS/rcoLMcAd32JcJ1n+WdoloCcNZlzvrifqieAiaoJ/dOmJjCqpMBZq7Oo1Ub8tnAS6G26+b/ip4XZacHgyUw3pXKRDkrOviY/VFl1jL2HfW/cIQ+6ZtxyvhcYRKBmW0CIKe6q9anKk7/3I34+iRtOADD5l60X1fW8QzazhlVs/KuzrhpYvv4wkEvViBossUtgrr4VDchHpvZjVLx9wjOdHg0cl11M0Yt/KWLk/AnMNNsdroTuHJWBDymkCsc4y8TWgRiyugGASjaRMGbYVuzxh+DpUbh2K3/6MvNdFyK+1V18EGWT3D0IiZj5q10Bpj30LCrNv++bbulGFnnb+QhGeJRQEFv7/wWk/MCBJWRzpdUv3NVbgei6W9berFZ4ocE+ieq1hbm65bWyI6gP2njuAnmwkk9TdI9Z9b7hEwc1z16agCuqZDRHtefgOBG58aUx3o6bhI9qtNBxCNavYZxqMx16R7HsAMFmo7fPkrKL/qbS//4q0InLLfu06m/1hvrEvGcjgzicx008EWdQ0lwiq7WFA5+QGLeTPCi/Vg+zxPAZaBhFf9whjGFluNTi9dvv1XRVQUxxOmb1y9ZPM5wc40FoQWK6FGZNpVXIUb4T/pAeoflt2y5/6lE9bIkptJ94U1WwhJTnp/sR
 fSQlGXBl
 I1naFv91lsgbfvu8oDOWCDSYT/AVlWDKtM8QyKrwQfOY2hI9/+8mzZ5n+JJUhNpfEyk/H20d1bPztDPBq3L/SE5Ixk73BXEd989mkSzhh7XiPQgV53cIigpPYhEESMnNLeCs9KcpCAKahCafhFXpFyvKM4bA9ScEIvapqx+cmB4Az1v5hEGbSVRg7CJgs6P8VqkInLJJqM4HxDo610V11e67zcGcKWG1XbOcr7IXEFY2vWBFl4mu9XnIVU4Rhb8w90v0Z5mD9w7WCliMEie2WQUc0sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 23, 2026 at 08:19:42PM +0200, Christian A. Ehrhardt wrote:
> The panthor version is only compile tested because I don't
> have the hardware. However, the code is identical to that
> fixed in [1] and I have a reproducer for that.
> 
> No need for for stable backports. The code is new in 7.1.

What documentation did you need to see to persuade you to use
map_pages instead of writing a huge_fault handler?

(yes, you're all Doing It Wrong, please stop, but help us help you)

