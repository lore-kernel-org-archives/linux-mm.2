Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0BBCD232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:06:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97876B0088; Thu,  8 Jan 2026 23:06:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D44856B0089; Thu,  8 Jan 2026 23:06:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C50286B008A; Thu,  8 Jan 2026 23:06:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id B4E096B0088
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:06:38 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 64EEC1B4AC
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:06:38 +0000 (UTC)
X-FDA: 84311088876.19.A75A746
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id 237DD180006
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:06:35 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="W/gu4hcT";
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767931596;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0FuZozzq9Ji0XXviZ5M+Le/bG+Ru+Zg/0Cbvo7TXLts=;
	b=wc1RwxQkrAuPiPD5vBJPE6eh/Rx1kFMowLVh/F7ldu2o8hBuD8O5nFbjfhjsG0EYxLpWS8
	mtes1UwJFjNRWLnnrF/VVOq1oy+at7h+ADNS48mk99fNtXIxUD8KtYjoBacmKupD9SheI5
	y4DKjwdqclxsk6wH2b6p/sD/yo7Hdyk=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="W/gu4hcT";
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767931596; a=rsa-sha256;
	cv=none;
	b=XsHnG7T2LFPJ3JHIdWVKwTIKVzPyxOdMdmRhPbkWh/ULNbHwYoKCNGqHx10RLU6JrHWP3T
	wL+QrhVtCD/IqEOqz0YvJP1P7QdRMd8PE56gAN1nwc8Bx58x4SbTSeZTlDsF/iKl1IUcxB
	leichTKni/zUzC4rAYDT0OS4Bv2uSac=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=0FuZozzq9Ji0XXviZ5M+Le/bG+Ru+Zg/0Cbvo7TXLts=; b=W/gu4hcTERQhQ++lYB0/jrPQRX
	dyXCh7k8ltq3wulQvp5xVvTCx3cZWYUK3gt7wppBd6s+Oj3rICui6c64VuVIjhlzBFbew7HFTNJE2
	LGdQbzrbbkSLZUZgg9iEK7/4nOcMNRlHgCB68iI/g3rLycGa3cGRv4AH/9mBQDFE2GFog+SvK1JJu
	Gia+c9eJTciqsVCmsY9HrJU5iD4EDnpV1xxp3zVWdI9+TXrGRH3sbXQXW3A7wRP+xUatg9jPj0QaK
	QnWResWxTXwD3iMFSxDv5VNCsCHbvVncx1XTbxD9mXAJjGa48XMZWkLEJ2CKRnlYfS9aBajPy3F9t
	g+msONVw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ve3lW-0000000GCb2-101y;
	Fri, 09 Jan 2026 04:06:22 +0000
Date: Fri, 9 Jan 2026 04:06:22 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jinchao Wang <wangjinchao600@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
Subject: Re: [PATCH] mm/migrate: fix hugetlbfs deadlock by respecting lock
 ordering
Message-ID: <aWB-vt6VUJ6fQPcC@casper.infradead.org>
References: <20260109034723.1342798-1-wangjinchao600@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260109034723.1342798-1-wangjinchao600@gmail.com>
X-Rspam-User: 
X-Stat-Signature: z9ex68nqoeowiwo8ys63j3s8fskx1ewk
X-Rspamd-Queue-Id: 237DD180006
X-Rspamd-Server: rspam04
X-HE-Tag: 1767931595-308484
X-HE-Meta: U2FsdGVkX1/DBXJOq3jDnEjcvQSAUGjIXmlpAleMA0xgOacRW92AuCVsyDZVpClswxKCvepolpNXHgcOB9cc69qUwypbmQGdZbLfDojXsQsv4ktoHbQwyzJc1AapNEaA5GWOmBh3sUcUDjCvbqloede4hTQy1xdEnOrkwssTHFU2Gq8xmA5Vcx5d28f9pHvMbBk51RvG6fqVd00vkjFEG7hjgk2lHsf2mUh68Ziur+OOXcLlvd5VJX19WV0VtWdFgkM3BukPjkkpuuU4HS29Pu2ehaU5y5if3QUdg2KibWnFiLHhh6aEt4yAXiYo+NHAaXCWxNFUSgxXHoqlwkYeDRGY6jYAR5IgP2otW/1SHhGaPyaZxPob5CH7zfGNRnvankH0JQD0P2hYC+C8Gk7Tyt70+JOG17TyEaMvlnKg+kkIJWKbwJM0byd2KEBKOYoIyN98Khl5Csm9MEUYWS+bLf6BbCKqcFoJABx3XUIshmUeROmNAIqb3dpNGCMmpzgWTK9b420JlluNaNXsGEBqY14XEr1h1qYEUICHQ6+6JcgkjBhW69OIqR1r78e1rKG+kUnIlrpWhlS4HUT85hby+NA1PzyPedG86YcU46xUO82YnSULPM2ndjvpn8hBEDwCir3evCX//W78CyBmU5Uv1xzNFzBYQllDiycZIbOEyTky7BXbdnUsajkmSEwAo44T1G1bKuFlhQGKnYWzoWgc5cS89AaUpq5YOXmRmvQrcWh+hJuG5fNnpQz/vRD3RJ3P4d9NuSusY4iCh0Hjhiqsnc8Qvbek9+vppP93M+KhR9ehCPvB/2WKANVH4cXsHoC9myGuasjRCQq0rvk5BGZ0A0C2e+6Bpmwkwam+xSwgMjpHE3CjTZVDjaP+ES1mTNmf3IQSyMHDG0YLihTmdeySGBT9dKE5wzLis/SlzGFcvD9zbRSXlclKGXWiIaCo6JEZWjwmg2eF787arsOk6Ft
 jCfHf9Ls
 YiZk6Dp3x9fZbQN4Dizreda/fUbSiZErqPzpX8aRPxMrNtnRyS9xn9UxrYDJXDVEotjyrWlyX2rEswscpeZ4/g/FcgNTLG0v8J/FT0NpBrtqVYh6cBPMq97VgUHQRIFxxN500gjQM/sMwvz8j9r3I4coUnmKNHu4l6Gu22Gsgnkq31HAsaQeFcHDvfu7xoU8+tiZ2sM5rjVo5ceWOlDpaqJEBD7sci+kq+YVFf+y66odO/gNjXRftrqOcHH5we1jkZm86YxR/I9ZIOcnRu12j96KYrqlrayxBDBdZEI90LTcIP9a+l4lsqzMZw/kFdooJy0+KjMAVC+12IObQu/SvmQdkAL+etiLYiHSxlFEzDCqg9EjqJZIyvD6Im1x6au1R/U/h99tu23VpX+sbldWFz6n1t+5m226+EkEc3vgcgnkrcLRD58wj+CHZn6TywL3xQUqn6UsZc3vFQ3gVfxVTOWZqK4DwHleTG9LC+BxmTgiVPu2KimYv2Xufp9SoelDlaF5SzMDfpahf8ziHSYpmlA6Go+jBsufG+Br0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jan 09, 2026 at 11:47:16AM +0800, Jinchao Wang wrote:
> Link: https://lore.kernel.org/all/68e9715a.050a0220.1186a4.000d.GAE@google.com/
> Link: https://lore.kernel.org/all/20260108123957.1123502-2-wangjinchao600@gmail.com
> Reported-by: syzbot+2d9c96466c978346b55f@syzkaller.appspotmail.com
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Signed-off-by: Jinchao Wang <wangjinchao600@gmail.com>

... and by "Suggested-by", you mean "completely written by", right?

Or did you change it in some way?

