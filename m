Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 182CDCAC58A
	for <linux-mm@archiver.kernel.org>; Mon,  8 Sep 2025 23:22:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 489FA8E0009; Mon,  8 Sep 2025 19:22:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 43ADC8E0007; Mon,  8 Sep 2025 19:22:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 377578E0009; Mon,  8 Sep 2025 19:22:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 2763A8E0007
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 19:22:25 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id BE4CC11935A
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:22:24 +0000 (UTC)
X-FDA: 83867659008.03.F1812E9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 17BF44000E
	for <linux-mm@kvack.org>; Mon,  8 Sep 2025 23:22:22 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KIA54G99;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757373743;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eYh9/YxENPVIiL4bSKRIgSVOH1pez+hoaivpjUTRnXQ=;
	b=pomGIjgfrOkRp+yHmGWI1OZIQlzZkTgp8xd5BBQwnvRuBpAOkpkfR4ZK+zJhRLc3uAKkKh
	6bU3Xce8oTxzN8LZvCDZCzpTqAA3GngaFHkvkfOFxIAtyz1FwS7KhLMgZVr5CE7xVUazVp
	v2fwnf9e344GF5jOsKgtJsTI5eZB0ps=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757373743; a=rsa-sha256;
	cv=none;
	b=IW5Q9ghD4ix0zX72BMP4N01wWPvOJzZVGSl/AX+WbPVUYAj/FYtsnS1AxBXT1dcZ85iDPv
	DJue0tNe8SCsysUjzdsK6dvA2xISyF6DpZmS2W3eX3sHLD9BIH/Cn5/hMTYlXML8KeASLK
	8FjJOJlsQk/ldJj9H8uJzLszxqGshmg=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=KIA54G99;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 144B26013F;
	Mon,  8 Sep 2025 23:22:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55235C4CEF1;
	Mon,  8 Sep 2025 23:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757373741;
	bh=PGOjmTeDDIr1B4cY4+ySaxe5KyHC4GKYSebwfsJjMn4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=KIA54G99aZ/SbV3nV5TTXVGVXCoktdxmU0ZGeJa/ej2vW3PYBVwvR2YM/am6bsXMO
	 3ErRqUje2RCK6wmQI9vJksf43BD1LRY/Anurm4T+e2IHvHKoQ28dL6m5WrCC8hsL1L
	 heIcW5pfsue1NRscA1YgEE/fXZF4FF4o9IT/5/G8=
Date: Mon, 8 Sep 2025 16:22:20 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Vernon Yang <vernon2gm@gmail.com>
Cc: hughd@google.com, baolin.wang@linux.alibaba.com, da.gomez@samsung.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Vernon Yang
 <yanglincheng@kylinos.cn>
Subject: Re: [PATCH] mm: shmem: fix too little space for tmpfs only fallback
 4KB
Message-Id: <20250908162220.480d7014cc6c6ad2e14748c5@linux-foundation.org>
In-Reply-To: <20250908123128.900254-1-vernon2gm@gmail.com>
References: <20250908123128.900254-1-vernon2gm@gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 17BF44000E
X-Stat-Signature: w5569zkojnwocnzfa4c9xd7doonj73zo
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757373742-650998
X-HE-Meta: U2FsdGVkX18cRv/2/XD9QqTOwHjOjPSiaF960ZmWjWq4qRKlLMfVwLH1LO5d6yBHRNM229UoACiAYenw1R4W/UiqU8bd5OMpuXiVAc3AxXsITJjp7QZ+3V3kGEqq/+kaUBATAB5Hslre0GfMPu/ovLy+QYl4YwbpP5viK326cxUsXqoMKqXZub6BTnQ6M5203GPStLERwvBiVK2AIh64mXwkb3Kc6w8PePf7Qtp6fF6h+6GWW12zCQXcv+FyZQUkvLTmpL8q3X7diEVJ59f5BSJ7448i7O2BIEZ9BCHZpeKKcajCyIOzbxF8woj8dEc8lELmegRJS7uUKYtMdMKInXoTEnQKbWtrS1NbUaLyFDpedhESe9SH29yf7RGpmKGyI20TSHNPV9+14ez+oRysoIsDbFE5QmVLtZpxT+mXI3llrddPSFDl3EtePEzzYkQCgm6yIl1R7y6qGjbP4pu7JOvftKeNzD989BT0kxRAfc/b21tEPLtV+axLTRX68WCRXIjKO2Cl6uu9MifbbrZbyn7akzOG8TPUIoLvs9duQYw4cKPtnTXvbMHg1PYzeY/c9hwiwMymGS7nL3JjHc/bA9gI0OTwv9QvLNZwu1kqqgngG+dLSLzccaCbYpwkUSEucFUZkZAwC4fegeevwtCkJn776Lmy194C6aXqwPbAaqgL56sXy6kGRn9k0MDwQG8kODfNhfst23U0zj6JfDQe81KirSWeVVsHyHq5VaOljLf2qqYcHdo5Z2p5DnGzZPeuGAvrvLbR6ISTc7CCWCx2fRAeEWv+SJxLPxAULVnbJ0S03zjyRsdSwKqSkDJuskTB4DfeIoABlLB8/SDUszoasDAu1QR7G0qwIyd2qY3vIOGp/nd5o29gVgSosPtOHYWvmcNAP0DHQNffQneRAnRtxEqNlG/R7nYddUJ4hx2/HaMFCrvKBVrr3vS2t7KxAHbN082E3ZASA6RWVyJ+o1A
 4sG7aXdv
 1GB6GS9VCBb3/SoyJh+Ot1Csir7CppEZ8wSeiI/FTGM/Meb2TffWM2DWP0+QS9qk5qpA60Q6d5F7wnwfXdFYn2i4HC5mfGMPGMqDI5YodVtpSwuo7tSiUCkZvn/pKmjWVeaMXh71nW2HesPCMHFtRezmMciQfLGMAGnlUugtoy3NmYs4jmqc1/KDi4Gu+ba6tn0mo1gSTgUFd2y2c1zZIgNoAF//2/lYrqTTzOXmJyQiu69E=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon,  8 Sep 2025 20:31:28 +0800 Vernon Yang <vernon2gm@gmail.com> wrote:

> From: Vernon Yang <yanglincheng@kylinos.cn>
> 
> When the system memory is sufficient, allocating memory is always
> successful, but when tmpfs size is low (e.g. 1MB), it falls back
> directly from 2MB to 4KB, and other small granularity (8KB ~ 1024KB)
> will not be tried.
> 
> Therefore add check whether the remaining space of tmpfs is sufficient
> for allocation. If there is too little space left, try smaller large
> folio.

Thanks.

What are the effects of this change?  I'm assuming it's an
*improvement*, rather than a fix for some misbehavior?


