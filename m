Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B5DEF606A331
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 02:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=pKqbz5+1
Received: by kanga.kvack.org (Postfix)
	id C6B916B00EF; Sun,  8 Nov 2026 21:52:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C1C986B05B0; Sun,  8 Nov 2026 21:52:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B31CD6B05B1; Sun,  8 Nov 2026 21:52:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 91DF16B00EF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 21:52:08 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03197C055D
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:52:07 +0000 (UTC)
X-FDA: 85414056336.03.649D0B6
Received: from mta1.migadu.com (out-74.mta1.migadu.com [95.215.58.74])
	by imf20.hostedemail.com (Postfix) with ESMTP id CB3271C0004
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 02:52:05 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKqbz5+1;
	spf=pass (imf20.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794192726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nWqWiduDQX/+eDY/lBNMvXq4xgQ2WR9If/niokbocYQ=;
	b=vFiNW9nhlBNWPSZUDVdFCT0qqa6nfKJEZfXrV4io4OPmrs/lAvNOgeXel6TcMAZsNkU9aE
	YMe9d9nswjXAsRS9yZwsEBqCv/9k/efBmi19ubYqto2X433lilJMliNQEb1Qtj2zOdytM4
	RzENW58YmZ95+b8tlOlZnSeeGQVGfMc=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794192726;
	b=FZgZfhYDEgvRNzx61Y5aHDv9/VhHHaQQHb5X7vQOwdGHjke/qeYwSTRAU+0vWX9hF9qlKS
	4BYZJRmvLTtJBbyyaQbjxjMgjNumwXNGZt7OjucHgBXWjIlsFaqrYxhyNAf3t+FTHJyJCH
	9NelONxmaTM1hEIyxostAB+ktIG1f+o=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=pKqbz5+1;
	spf=pass (imf20.hostedemail.com: domain of mengmeng.zhao@linux.dev designates 95.215.58.74 as permitted sender) smtp.mailfrom=mengmeng.zhao@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=1zQrA1miKQ/sO3U4FLD9eN7ND1EAn4eFHq58nFmS/2c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794192722; v=1; x=1794797522;
 b=pKqbz5+1nAKvoDjratDGIzCVYLRnYWqr1KkI/51AbwTsIOLh1H3KSkwjZnitIUapDrfX3moK
 iBDOjWlEa0LcAglhZ0IIVJXQpa10JvLhgoeorLL1bBrmrzYqTSk7F/F73Ux8tJumFsmES18Q1nY
 WVU2IQ4+YlREcEp/U62zWKW0=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f8a5242679d67f97;
	Mon, 09 Nov 2026 02:52:02 +0000
X-Mizu-Trace-ID: f8a5242679d67f97
X-Migadu-Flow: FLOW_OUT
Message-ID: <3f45a5f9-9c87-420d-b6a5-6145c834c0d1@linux.dev>
Date: Mon, 9 Nov 2026 10:51:46 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC 1/6] block: refuse a dma-buf bio that carries a crypto
 context
To: Christoph Hellwig <hch@lst.de>
Cc: Jens Axboe <axboe@kernel.dk>, Dan Williams <djbw@kernel.org>,
 Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, tytso@mit.edu,
 Andreas Dilger <adilger.kernel@dilger.ca>,
 Baokun Li <libaokun@linux.alibaba.com>, Ojaswin Mujoo
 <ojaswin@linux.ibm.com>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
 Zhang Yi <yi.zhang@huawei.com>, "Darrick J. Wong" <djwong@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>, asml.silence@gmail.com,
 Anuj Gupta <anuj1072538@gmail.com>, linux-block@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
 nvdimm@lists.linux.dev, linux-ext4@vger.kernel.org,
 linux-xfs@vger.kernel.org, linux-mm@kvack.org, Li Wang <liwang@kylinos.cn>
References: <20261105065847.196540-1-mengmeng.zhao@linux.dev>
 <20261105065847.196540-2-mengmeng.zhao@linux.dev>
 <20261106104119.GA5668@lst.de>
From: Mengmeng Zhao <mengmeng.zhao@linux.dev>
In-Reply-To: <20261106104119.GA5668@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: dobzjrfnkc9rr1ee6q4kc4xdppccp4x5
X-Rspamd-Queue-Id: CB3271C0004
X-Rspam-User: 
X-HE-Tag: 1794192725-552768
X-HE-Meta: U2FsdGVkX1+mQuaadEJEEWxWtVPr/zsU+nUslT1iaAV7bsd1DRU0yLPQIgvwpTdhg4AEopk2wvfgcN+FfWfV/lFQS4hf7eURejuW4LW/d4Gw+SGndTE1my2fUsa1B8nQmG8k/WudvqGT9YsZkXhimZg77cGwgqvO9gXw1Gr9Rww8Nk8XCF0BGBSLB8uS0y8auHTC75tMwmv6QqJW+m0I/eA5zhy5f7vbUcQDw4dkHvbmyAWNsvBDTtBJD3UHEJtFvETiKpyDnnAdqSnvbB+3cRbkZYFc9YBJT3bg0Mc0znLqN1kd13N8Sinp3G2P2GECqsTfaARYQVq7xbMVYUhb+Wssxcl3MXqtXC+Y5zb1weWIVRiiy8BoSelkkirdRkEpZS8nFKrG7e0h3v7lKQ7KFVOp081eBud7f5SadypvxweqN/NZ+1CWFfZtV1d0gvmw+z3H5UgLv6kGCgBgUEOmaQNJ4tgArZGn4MfLBkdYRV1ynT3VwaxCNRljkW3esauq1AISssKBZUWcoxG8wF27vx/P7gjIKJueaeQdjN9gX4hTnLO2mtnsQgp68eil/Pp+5AwimqNF60n2SILPjgF4gz4pkhWfZ9ymoxJMtNkWtho0YCzQp4nxn+nPnWbbQv0T3EDLzmLD+YsIBEg0euEu7twsgmPvT2D9MUy9VLT+IH1pJavmDzLSEjBMgp99z3nMnc5Lx+BncCGGXL+y37fVKQS4U0KcDTBI4eH8neOS6YHkw5zPFeQMCDviKGZcjvaErL0UcsaY3Ti/0Zr3cayMYXryGsAzJvlYKZ4o7KxWLb57bkfqj4AKc6GyFWOWJaEBgqVkI0d3GMmMopeXC4JFOUIC46gUmyckDMB2DxDen1ZO0XpXFZ7zvCLm+vJVlf1ZSLCNhf9zAd1hbievypS40PCL/4n1j2zzZj9gnLHh0H8wSJpRPl2Q9gKbpRhwj1DxWiBsBNYHJeax9H0lWDs
 OQZdYS84
 +0Ict+W3mYUX5ddHjDNm0DFCD2GwGBhFplknrBnVG2Z3Ijrq1ZmyfsjfvdQnIbVbpQLV3lPCLBQWD1xrvNOjfXUdT2f8/Xb9GudvSiXf+s5wgcgkrVNvnPWyhh9c56LjemxVRV0M9+dHDJC/5ZFrMM91LJtNtXzGHWlXBTff+Q/mrpi7+9G7cRB1zOWHAxFPdyVu07x2GdpbNpdHekMiDPn4u7emNM8n7Vs0vxuE9GiEq41FayFKlSYQ6E8Q/4wOmXsqcLMW1I3bC1g9gsS+IbzYFYDBvdPW4AGu5w9Nxn+7d8pl0MnAX6pWwI481KEyttvKfgQmpnscShZRd32fUnF8VXhsiQuiKAqM8YOCih/ZbYk1xfSo6hDFNNv1m1ychVQRf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/6/26 18:41, Christoph Hellwig wrote:
> On Thu, Nov 05, 2026 at 02:58:42PM +0800, Mengmeng Zhao wrote:
>> +	/* a dma-buf bio has no pages for integrity work or contents crypto */
>>  	if (unlikely(op_is_dmabuf(bio->bi_opf) &&
>> -		bdev_has_integrity_csum(bio->bi_bdev))) {
>> +	    (bdev_has_integrity_csum(bio->bi_bdev) ||
>> +	     bio_has_crypt_ctx(bio)))) {
> 
> This could really use a factored helper explaining all the refusals.
> And maybe we should use the chance to sit back and think what else
> would blow up and add it there as well.
> 
Hi Christoph, thanks for the review. I will extract a helper in V2 soon. 
There are several buffered io fallbacks, it's really necessary to discuss
how to avoid these. Glad to join it.

