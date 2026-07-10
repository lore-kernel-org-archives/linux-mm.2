Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1655C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:43:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 83DE66B0088; Fri, 10 Jul 2026 04:43:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7EF1C6B008A; Fri, 10 Jul 2026 04:43:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 704B36B008C; Fri, 10 Jul 2026 04:43:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4CAFE6B0088
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:43:36 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B1EA41C3807
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:43:35 +0000 (UTC)
X-FDA: 84972228390.23.A256E07
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf10.hostedemail.com (Postfix) with ESMTP id 1D6DAC0006
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:43:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783673014;
	b=oaT15ibmtyVWVfFSYWhH8IUi4e59OylarkECoV4dt13xOMzrkX2AOdKwLcq+Z8XXnM0tB4
	M7H1Z/anvhxjxaSoC2X9ZDGcyQOQwea6YymbTuwXTe/lrd89gczz30Kzn6w1c8JjJA/YNd
	0GalPWS8I49daysjZMxusLqMdxIhBv4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf10.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783673014;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=GNgVTJmk7//MW+YuNuPcKNlJE2aD4OdDO2UaxJvZFUk=;
	b=pEbI8yCCdmC7Ckcl0KSQQujz18ZOI+WXLrR6SuSisse/lOXiTAmlR0pj/jNPdNQZiP69xX
	1wQzTpDAEyxdT0fGaOYEE4y4r2MTHPccPIzLgUsIH5V4evGXTw4bHKB5LdruRpBS8bij+0
	IsuOavSgGqxPMhzFBC110g80gMzLsp8=
Received: by verein.lst.de (Postfix, from userid 2407)
	id EF08568B05; Fri, 10 Jul 2026 10:43:28 +0200 (CEST)
Date: Fri, 10 Jul 2026 10:43:28 +0200
From: Christoph Hellwig <hch@lst.de>
To: baoquan.he@linux.dev, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, kasong@tencent.com, nphamcs@gmail.com,
	shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-mm@kvack.org
Subject: Re: better block swap batching and a different take on swap_ops v4
Message-ID: <20260710084328.GA14592@lst.de>
References: <20260710063927.1891452-1-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260710063927.1891452-1-hch@lst.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspamd-Queue-Id: 1D6DAC0006
X-Rspam-User: 
X-Stat-Signature: o4krxmgrnjoyxytcdx4xekdr7fuee8n6
X-Rspamd-Server: rspam03
X-HE-Tag: 1783673013-248744
X-HE-Meta: U2FsdGVkX19XUR/PP+8NCFeHLVLoJpIvYShlc9oeQfW/d0tWQsXm+0oixDgGs08GBmIeqXRi10q4wv4hLUCpvvnvwqsl7mODHfs0EJPHYK27uDhOYHdB34c8VuxPA3lm7cN2nPwwjy7qCtJjzg2VrRPGjOQ7AaDF9649yXayZ28U6+iqcJdssDwk1CFMsBfAIjmtHlOuHhbjnV1w0MMgnydQ8AKEDZ5igs5aoo/qc29/89ZkAUN8hu7fV8EZxGq6zE6KRp0ioGTa0UGkiq83c9jXrzr3H1aA7pL5qyDdkt7+4RKOxwjXOtHszUK4cp4MRgmOL3JF9QH/0OoNNdu9E8Rw0sU3Z9MArgev5sH+VMURRmDGUbktl7ekXZlynwlisgsR3A6hjoi2tMr6ZSgMgHEjOPIA16RoRtDPXJrOmxetcpCLHq944wk0Jie6Od+DhX927eUPjL76/R7aeguZNC0tCgELzw5VmHy1K6rkwjXxzyh71cSnHgZZhYvPFdFEM+7aliZwurT7D9d4PrptDS4hULwgC6mWk34tullO/RmWupAdEfqgqOsMVYVVkDDc1fduky14N9h2Ttu/I8o4ZT88dSVuImloPn4Lmmly3n3Ifwj75kWNTtPBAo8xCHKLxoW1rV2BUr22PUNRiW4ggYhd04dbi4AHs1aWRJWNkgb4d6VVzJcFtnz4j9ztmiJzFCSDCYPytAQHoMsEWVxhnkB4yiR4HeqITiBYRWvT1/CNfcznOaT39zsmYCIfiyjRW6c9bRg+cciejJyVDpOQGCb8vv95ncGHhueJ2BJ4ppcqmaAMushePMKpOo0FJIzRewuOVhseRsWQY1Ye8vowHSnnlUfnAv/u9ki22G2I7lkNPbP8sYE0FnXNnx2ro0fXimSVYgHrFwou5gmCda2HV/3wQqmqJrg+zHS7+rpwphw73OSUddHPM5sHCi6qfISvyVMTv1Krxvt3Xk7ORfG
 r5KzQN0o
 fgXBLjOPXJzjGM+sACs969C5xlCwLrJvtKf7QtJh6FhaLkT2NjJ9swVO+9QvsxHxQhOHFhONSjOgcsrTYPExEXdoGXA8qrhc9xchqyDfVlPBcZcpHCJhJ80QcalpWvrRenAe5zkusZCg9uFuV1nTrK+oiEzCtzGOSyAQDmB8IgXAdhts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 10, 2026 at 08:39:11AM +0200, Christoph Hellwig wrote:
>  - don't merge charged and non-charge folios into a single bio
>    or fs swap request

.. and that fix got the polarity wrong.  New version on Monday.


