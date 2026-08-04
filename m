Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D447CC55838
	for <linux-mm@archiver.kernel.org>; Tue,  4 Aug 2026 23:42:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FCC26B0092; Tue,  4 Aug 2026 19:42:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C85B6B0098; Tue,  4 Aug 2026 19:42:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E339B6B0095; Tue,  4 Aug 2026 19:42:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B60F16B0093
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 19:42:39 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1D8F2140296
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:42:39 +0000 (UTC)
X-FDA: 85065214038.23.E3426BD
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id AF138A0006
	for <linux-mm@kvack.org>; Tue,  4 Aug 2026 23:42:36 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WNMaRDqS;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785886957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SgPfd1vWJv9VMjxLkdcbY3fOZgi9Hm1oyp5+bOca4VU=;
	b=zWmLXfFr4V7sV4E00Z6Cdx97muE19/rW7/Qlpvicy9YHdscc4WXUQNEPd+Gq8CahCTef+0
	n6C30lbnrHMSE29Dr2gm42WXCSMSZIIkEE+GY0jbaTHkZ79etWtvuEPFuNdLVSNnFh7hdB
	wZNQEJx/zUCVlKYz23HEpCAevePwMI4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=WNMaRDqS;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785886957;
	b=O5KfLr3ybtoJ0To5BriFmGbEpqnsIrMJTJLdHYcIuOAbyag4MXaKjDDp3cKzeYPvGjZj1q
	rbUYL4YEzytu+q6sv3DOeoY7Wn/yxQ5Kdw1TIl66wYMwCwd3iHqjj3mlfndppaMYHTI0xj
	PBDG6phGRPFQ/0xj33xRug5SR0+O/Kw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=SgPfd1vWJv9VMjxLkdcbY3fOZgi9Hm1oyp5+bOca4VU=; b=WNMaRDqSCSBUUlGBay1cyFZnkU
	e+Wvan9+u3JSGYm5Sbpjr8yOnb6zQiP/f+Leip6u7U3R5MYSU9vhdDR5gQT2jsTpZi0w6n+L54NiK
	nMOVVJcb1xO057pFWx0Z/NvQ6KZ9zuoID/Dh1JgEq/RgaHUddMYAx8SFuDm228pZ/WzqfG1aBRnLK
	gC40Rp725xJeFpWFjORymbUeyOsLDxL0Toy3QAW01TdgS5JBI4clidRO86tPzREdN1xotN8w/Ul26
	VlXcxYd4ZACD7AbPPWy0IEIfgQl/XmLVX8Dtth4tmkrei+zVHXpitlXRaHJPWkE1B8F9pbKh+Ztv9
	yZ3/QWsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrOmA-0000000524Y-0wVJ;
	Tue, 04 Aug 2026 23:42:26 +0000
Date: Wed, 5 Aug 2026 00:42:26 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Tal Zussman <tz2294@columbia.edu>
Cc: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Zi Yan <ziy@nvidia.com>,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH v2 01/10] ceph: add ceph_folio_snap_context()
Message-ID: <anJ44lo6HHFLlkNZ@casper.infradead.org>
References: <20260804-remove-wait-on-page-writeback-v2-0-81f0ab065284@columbia.edu>
 <20260804-remove-wait-on-page-writeback-v2-1-81f0ab065284@columbia.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260804-remove-wait-on-page-writeback-v2-1-81f0ab065284@columbia.edu>
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AF138A0006
X-Stat-Signature: o9i6ddf8yidteu1wt51yupr1qbyudua4
X-Rspam-User: 
X-HE-Tag: 1785886956-678373
X-HE-Meta: U2FsdGVkX1+xe+1/d3GcuvxqFUiyS3nKTOZjx4KpwUB5oKi2izx8dwsacZweHgcejVo6rW0z8+uMBJulU1c3qCj+xi9ca6iD/uXEUjVsI/YamSqyP0hRVadT+dKY/wY7vwqG99ajOVwmZrnmSjWiFEgkd4yuVla1wCzubtFb62A1B6iEXNkWZo5HctHecnAzu+0FspORTFoapdLMO9BsRFLA3K9n7FTynKJDidUagC/KkIquU7Qj6RE31orbK3rMDXQ6pjm75PTpoGierg/lC6MnDrGiTH0sQPp+AXd67UHdtRqUpI64P8krhCjl4eiOyNbOxrcoChf55yiZRrv8mR1GuY8ym95mJf6gs1agUTh0B4sO4RUz63U5zoY1U2/ZBxnGsHeXgia7beNIKMFAlyEYXRPDZ7QjPNBCqPvJmjpQDx/32VXhUALorNEiII7SFKR5eT1csp3SScXgshMaj+YI6j8u9kx2YUO1wE16XEIFvc3UEcXMDHhjaDuSyJsmLooYqWq7L98RtD4USF5Awx4xmRtiDZ7DshaSoK9tlStV/zAyb8ON2ig0iBFE0q9X+e06ZkV0zJfdup9g92U2sT2dPJvcDPofqS70My9amtuZ5+VS2zeIE6H4uQrOxKDirLXH/VRZApCbfC0FHaTib+J2SKDAUqEopoAd5suBA5+YH85+O2Iv4mxke9P3Nv9TZYQpPpbquoKC7jDzWbaQtQ1NGJRaYSawQ3SB5TvKNjUZIBSLz51WVFrWuRQu6qnOfFzpPZTnsJ02qJDBr22ONNv7pxjizBm9cwG2NmwMIbOCAM4eWO+ycHM4CnDuIIeIlh0rZ32yxHE+nEIkeP2GDfVr2i1ev/aXvd5GpVfWMCkfSBoPDVW4lgo9ufmUQnj66cY87/fFVn/wqGQ6c1eB79+kXWv4+Brp5/5EEC9bmlMQBIRITtLbT/rYBRxSSMIfUw13wh/qepy7JrH7ykX
 nBlVIrug
 1z4yRa2K4JFWrZw2wBdbickhQ7UL9Wkf2fRyBmYjYNyBOhCM37xrYRm90Gv9GuIQsxHP21HR04mqklX0Z38z92dZXhdqOLawCIJ31AGuPjGZ7rULAJh9lDZXsVd53gONqz01IauhQfFWAUBXuYmDNYzP1etZGW+PAGcp/hGqGYhrhWbL0ZDH2M+Cs9ZzUNSAUSff6C2IIaxTyq6hvhXQZtwDT4orJJqAeKb3i/GLpU9yaF2ZukAko2+kxFU/gKKWiMXs8MMPdbLjG65xRyvevBXqAUHG/qNSu78srDCM5roPyp4+KC83o1gmrgtzIi11cfakRs+MX6z3heg0M45EB8nq4lThAEsEQPOGgS/XSFKVwOFbxSXhK+0ra8nNqdCYl2Xqz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 04, 2026 at 02:52:09PM -0400, Tal Zussman wrote:
> Add a folio-based counterpart to page_snap_context() that reads the
> snap context from folio->private directly.
> 
> Convert the three writeback paths that passed &folio->page to
> page_snap_context() to ceph_folio_snap_context(), removing three
> open-coded folio-to-page conversions. No functional change.
> 
> Signed-off-by: Tal Zussman <tz2294@columbia.edu>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

