Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2A22BFF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 20:44:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7703B6B0005; Sun, 26 Apr 2026 16:44:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 721086B008A; Sun, 26 Apr 2026 16:44:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 636AF6B008C; Sun, 26 Apr 2026 16:44:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4DC6D6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 16:44:57 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id DC50AA0601
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:44:56 +0000 (UTC)
X-FDA: 84701886192.15.7EF27EC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf24.hostedemail.com (Postfix) with ESMTP id A7C33180002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:44:53 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S4pLnzvZ;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777236295;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I/fTyPP7bqTqt5fNYUoxgKpJh1vpEuR3aFaCVhySFZA=;
	b=uSdfvf8LY0CVhZOG1nf19UkhPjx5MwU9uP3TNU5usA7NHu8Qg3lhEqyA67M+WXxzEDSkD3
	HXWOfJ701kY5jaRtetn67zNaqkqvQI8LdFFh/UNPdC4GST3KPCCm/JQity1x6gPcb1G4Fg
	THNYuZ/QnNMZ6rc7B19lwEcn1MfYgI4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=S4pLnzvZ;
	spf=none (imf24.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777236295; a=rsa-sha256;
	cv=none;
	b=NzpOGpQ2JBlhZfNMjUYSs6SwqfUDwop6dImYiIZZWifVGU84uHXiGByOT2WeQicnli7KSa
	y9nIzS6m2ORMQvZVHiw6A/LqpiPl2R1QvGn3QFocF/LvqqI599b9tLUc5pda/o/j91JFV6
	pEPCAX8iW0XzAchM++3hzHGxs/qnKS0=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=I/fTyPP7bqTqt5fNYUoxgKpJh1vpEuR3aFaCVhySFZA=; b=S4pLnzvZn8wrgvL75yH/njOHFS
	qi3So9o5mDIDheJ6DeCD+gLAKuPaApFP2a8iw+bbRYYCoD/CnPn4F/8/qF9X0VR82yMqoVLxjrGXD
	TJeQqJOfcmOUSNfU3NU4CENu6sp4ZXRaXpZAhne0g/1iAKHtEthPIWv7t8ZaiUYqynOAJAElxhNWZ
	xEfa8BbC6KdRILxUzJq1iyPFoHLd/DVKd4aDMy+TQq7ZRG161vtP/TDWWUAV4n7Q/AaBcDJxsR6C8
	LjDHkjlkKkPE5BdVjJlG2EGpbcUcbDhERYKOxZ5FbtGCS/ZPdO1ogRAMxRRB8lLq9Vn0ntAHBRU81
	GOxj8lHw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wH6LD-00000000zSI-3g9m;
	Sun, 26 Apr 2026 20:44:35 +0000
Date: Sun, 26 Apr 2026 21:44:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Mike Snitzer <snitzer@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Christoph Hellwig <hch@infradead.org>,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Barry Song <baohua@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Chuck Lever <chuck.lever@oracle.com>, linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-nfs@vger.kernel.org,
	linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/4] mm: kick writeback flusher for IOCB_DONTCACHE
 with targeted dirty tracking
Message-ID: <ae55M8xBIVYZXPFN@casper.infradead.org>
References: <20260426-dontcache-v3-0-79eb37da9547@kernel.org>
 <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260426-dontcache-v3-2-79eb37da9547@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: A7C33180002
X-Stat-Signature: k5x1u197e6nem6entmcipx3673a4kjsi
X-HE-Tag: 1777236293-130805
X-HE-Meta: U2FsdGVkX1/gFhzkLtCRf8ZmaxoQQpNYJTDl2v7hbOTxAOSwsLBrisXS0STU+7nlNoGUlEAhrxrHdr2/57wrFX8mxtyez5VFqLQ7nsamjhve0qmqVJfnLPhpTIFtKDHmFDq8semLKNcV+lbVhtIh/+UA6nh/SfLO2K4X/+JQluXczSILBdxOQZVTRrNMBYHd+VrUrtcgHLuOxvmFjvG+jTfd7yCMHvIZDZbgZNdxo5kOYM3xLquPXtUlY5XQ6YBaR9wfPAjX9quOSuuzwLce9/Mtzg0dfwIpCn0KbZ7RMJzXAziZFJ9/kR6wyyRI/jZP9zbHZqtwn+uWHZ8Xo6N1tnF4WqhY6rsHCSrcFujvKBOKZo5X08kJzCOdXBoFvKv2yfAF8X9m2pAGYwUrK7NQgGmmXqlYCySG6uWA8sVjfHSXpk1pqzPKSCqaSUTOtTCt39hzsNJHKxvpXPzDaXjIbTf20PScRStviYaBTsvFX2YopNdyCK8hk7q2AR6WAlM6p6xcrEdepuN76O9rXV5SdglS9ZYRI6ZlOOwZmGKTGfi/THl1SJBj6kAfTwjOeX/Vn0Z9GJPa/on/Sjx8CXcFjcTc4mjJB0ogPyfZl8cUJq+RnnmFAh+62V2Od7tfa1+Kyx1BGouKbht/y5rOlSn60LV0O7AaRrjEvCffrhBZjqZFk1SIFtutJcq1rp/X16aRFKC+GVfoIZj3NDMhZQoCbMkfx4F3jxTVT8kbAcgzoP48Cev10Bw3/w0r+g2xT+N6DCj+cToHnOKMatD5I0kcReXqpXMUz+xm3PnIqf2XuAlpi/ZYuMBN/bM3fA+A6E2XHeED/JLv+1+DSFHxwoSaB8AFUNuBllfFgB/hihVrh42djPtQemEKEjYJIAl9Zjl30M/6WDZvkArVOaqCqiYmfVBJ8+pEyI0GsURk+ooRBlkGOYwOVxUvZJGZ/RePM/9fmrVxAc5FqI4BxCtkKiw
 17rrGbg5
 V85eVYXSI3fgH46mTg653BtyOX5QYHC8bHU1QgmhCkiR6hWR6NAvwF6lLVixRwWP0H84CdCmZ4CWZquvlCfy+mo4Dwpc94JsGFObn1FY3a9DgNUyPW32rg9PLimSXbSdmJNJPdJ2cm7JDhyMckMRD4lywTCTwiaDhAGfmgOzDqTLPdAy7OHn4pyZburdgI5flwLKyfNh5sL4c0PaDgCyulnSAf8J02nFbjGNmdz2QZxmrbEm1TuXD1uAzc7zDZShAzXKnCfwNfb7duFZf9+tZ4teMfimfT3/TeJIjPZZ5nYKEsLcQHFxozHQ9nIhWD23/YJql0kWzI7wx/Z5AQrNuWyZP2xoS+yfLrJzw+oqvFN33GJVXNoK28btWTA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 07:56:08AM -0400, Jeff Layton wrote:
>   Mixed-mode noisy neighbor (dontcache writer + buffered readers):
>                        baseline    patched     change
>   writer (MB/s)         1297.6     1471.1     +13.4%
>   readers avg (MB/s)     855.0      462.4     -45.9%

hm.  This wasn't what I thought of when I thought of "noisy neighbour".
I'd have process A doing DONTCACHE writes to file A and process B doing
normal buffered writes to file B.


