Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EEB43CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:45:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66A4C6B008A; Wed, 13 May 2026 01:45:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C006B008C; Wed, 13 May 2026 01:45:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532226B0092; Wed, 13 May 2026 01:45:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 404926B008A
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:45:55 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D69568DF46
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:45:54 +0000 (UTC)
X-FDA: 84761310228.22.2F60492
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4280B180009
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:45:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="3X7/lU+4";
	spf=none (imf24.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778651153;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kCOjq/VsA7iCs12DiLnqafDe3qdguO0vapzWucYAl8g=;
	b=YIqDLhm9CGMsd6xVvxS3kzjm3bgwQ0g/8y60JOzAuro5OPX/oPoN9Oml4scxfBCZOpzTt2
	hsDU7LgzyZPDKTuMrBpFFFdhO/623rpmss1XfPDWdH8nwXiWiKAuqoB/7YDWtblcFChV9R
	CSJXhTkaxVO5HponKGZm1ZlSfhnFKCI=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778651153; a=rsa-sha256;
	cv=none;
	b=IKR82BLzEFmnTHbEg9ZqJ7F/uiUA5Gfzvo88mdAt5vtgfPN6/LApG+4W26Cyh5tLmODzuf
	EyEy3uE8PQ7AqVpbVF5ypk5//fKeLVwaQizm1955bfZQXOoPhK+yRYICEOp5S7LlTAOT/F
	hV0aOiRhj8ni4Lt66BNj2+URmOcMAEw=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="3X7/lU+4";
	spf=none (imf24.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=kCOjq/VsA7iCs12DiLnqafDe3qdguO0vapzWucYAl8g=; b=3X7/lU+4mWfhs5iNNSdlJFsH0F
	AmuyqInwXN1Y6Yu1FUcIspAM5niIHfNNymcWcDmos1fE/gXiq1ty7jpAJnJb3Cr1pLn2MO03sLSFt
	rQnHJh8sNGeBVsh8Kq51sYs66UGWOrY9xbHbF0POUtJKs1NadQWW4xIUxorBsTCWvX5OCXVP8o+BF
	dvf7sjZ5Pyscc8YHFoin4OVOY1uwHkGn+CEO+77dN0QxLK5xlBRvKdYaAqTjhnzfN+HwcO+pH0dQS
	icrSRMNpEvMvtmiYvjJSbqDSi4h83OZFzDPW1DSh66r/xUNLMcefhoD14Ps1pX14hhP0CvmWs2af7
	SWYFPKjQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN2Ph-00000001MPx-1zgm;
	Wed, 13 May 2026 05:45:45 +0000
Date: Tue, 12 May 2026 22:45:45 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 2/3] mm/swap: use swap_ops to register swap device's
 methods
Message-ID: <agQQCeJSAjBkg5FW@infradead.org>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-3-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512104201.716213-3-baoquan.he@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4280B180009
X-Stat-Signature: 7zuwsge7iimk3jbja6zxw4psbzmrj6nc
X-Rspam-User: 
X-HE-Tag: 1778651153-174823
X-HE-Meta: U2FsdGVkX1/MBQuu9hPhWTk8c0dJ6cGl3blE9RdrfrTO98kZusrOHx1N54/KwwfTkvJbAZtEAxNaiBrQQa3x3GOgdI1upjTUVoLdIR9OuHVcQ+1goPCyQQ/xUi2g5PDmmSHMFcuMrMKA57CpNd3Jr9KFAZryRv7/2JEQtibWJQ5MHlT5Qs2I3bDM+n2xWiNZs1vof6qshGdm1ALbIfAQbVQgwrnBZnTsSBbZA9/tiacDEvypPFmh6ox1uHG3MXTV+jFwyHHXZ0/gipnfjE8YDfHB+KmWgDCK5znGZhgnSob2KKVo+BPRBT8HL5BrVVFFMqhB/57Q4ddr0AFZVRkRs/dzyoybld7kX6CbqJqloicd+v4uKkuYGQY3WMa4cBYvl3pIB5OS9gRsUsxwjwG4+QtT9ZTSNbXhr550tmlgYMOa0Rx8v5fTngp7rWmmWrUqeXUcE5XGLCzh+ghdl8SRCyKICA05e3TXNVa7usdEjpTJv1WdLhi1hktKbKmYx2On6WgselKTMI7vQUkklCT8eVXgp33J6ZzWNuRCgPb1AoYOcDPdbKRHuNAlV0X4X5NBW1lsXl+sIChBXe0l3Jt9d54XgG4rar4rH9ZFYK7KjRxMK50jiu/Zo/SyAdDxVbAsZE17gmkZnmfhjX7eSbtUMkabCXioUkpBJ0xqopfsObTZhLgurmG03fQgspnN1OlIgMwRcaf+JqGUE6gVfoib2WW/BOmpN5YpVn0eo3CC2xy5K8KWebF5JkuVqBpGkcaYFaPfKUTy54ClaqtDOp7QKOK7MP9IYpZOResy/yIy3ip9+PO2/zK/XcJ/HJnY8k5lFtcME8YSO1msMYdfpyqbmBgM4FypdXSY+dc6LjOM1kbBJ2XPVdtZeIzg+uthWGNtuzzTEhGb1XgkeNVwfO/deX0PBer6qmLSfBf0Ypyr3Tu6YcifT+Pqv9ffZEQqVIMl/xEI3BvmwWHwc9Yv2DZ
 a09OD0dE
 +gZwK5Qmp2ntJFmB+w72fmFzjXAnG8xEePXVZr3OIE1LXT7KYyUdr1hTXTwH5HEqYF2WRhxFqIx5cymKrwK7Ce1rvGw5CDKjVEiMP5UQq6rPbDZry/RejJzqt/Zyl0eRn2yioFbQk/ENhLxKWf4XqrRhphA16Ompx1AV+RcUqo0BS/BI92czBT6adVCbuczi5O8iYhDoHrAxnPcu2U6UdGA+pH1oK5s80PfZdLOzTZcaigLYPYno9TYu5hrYwI+ESzzkTw6KFuo8RIfgZlNPgtranix6DNe0QmqjnXuLlbZ8Qn/uoZcUVKdo2Ks3q+c/yFMSQ/8tBlAf+WlXlGMueymwaxUyp0PxksG8a9bPZndu55Cf3qLGexhmkh9H8W+IHbV8CZSADW8V77ycseosNlHdnW0RALMvMuK6YzSh4v48M+d/7ikJ7gFLo51akCPRex/vXzn5TadjMcZCF8ZaOcILMhRpl78e6IQ5cW7lYd7KIe/aqOZzV0fyOHsrqXbs4K08RhEjRWCuNjDK7K14L0KTcCTQ02P/KC87CXqlC/Xm3a9o=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Looking a bit more I also think this abastraction is still leaky because
the unplug calls for fs based swap aren't properly abstracted out.

(note that it would make sense to use them for block based swap as well,
as building a single bio will be a lot more efficient than relying on
block layer plugging, but that's a separate issue)

