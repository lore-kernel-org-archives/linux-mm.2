Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 80C16CA0ED1
	for <linux-mm@archiver.kernel.org>; Mon, 18 Aug 2025 12:15:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E65A28E0034; Mon, 18 Aug 2025 08:15:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16BF8E0003; Mon, 18 Aug 2025 08:15:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C418E0034; Mon, 18 Aug 2025 08:15:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id BE6608E0003
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 08:15:47 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 746B71391E6
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:15:47 +0000 (UTC)
X-FDA: 83789774334.21.AC3F82F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf08.hostedemail.com (Postfix) with ESMTP id 99401160016
	for <linux-mm@kvack.org>; Mon, 18 Aug 2025 12:15:45 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qAY4WqD7
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755519345; a=rsa-sha256;
	cv=none;
	b=nlt2qfPkN2HgDxxpcZQSAV1hGFlfvBHFeBliFGhmphoRbTUndou1q7dvjq4f4Cdx0N8fFv
	y92WZu76wVvZQGjnEsOcF1X7Hg8nqRr2u8R4qxaLYRcVXiUBVzqoDF5TlMDUBBY13OjGsM
	ECqp8RyG6B5hxIxN826GOYer2up+p5U=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=qAY4WqD7;
	dmarc=none;
	spf=none (imf08.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755519345;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XKIyrvFr1ktn3DGEI4ZXxd1B671yEcSeAAYlQV3Mq5c=;
	b=nRUDkBXFTZtW4DHyOQ2j4aMGN0L0GsySIK9YyDNLxJ5ZLdQKAQbIXHfxINpaB6voQCqshY
	owKR3Cy8Wj7c12SJyS801pLL7WNcbvrV6vmU3RaPb+hWFkBvfWenJ/qvsT5fCZ8mpj8CYL
	PRCz8DSmOlBoj2p4kWUp2NoCKYaxXVc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XKIyrvFr1ktn3DGEI4ZXxd1B671yEcSeAAYlQV3Mq5c=; b=qAY4WqD7Hem6x3+hBtdRuHIR/l
	U2lwkA9MuICuo4dxGoN7hFzJwJPKC80e10V8EMpEF1AFSgW7J8EymNddlMQPxzq8Hwf1kxeWkukMJ
	EPjHHHgV2l0meRkjyoCTTkCUt/rXtQGcZZskdWGC4iqJIeKNS0ic8BbFoV/RwD2n91SpAaSueXHEW
	K+XmzA2DlCrJTnQuOqA50BzFAa/UAm27Nd8PDtrs3tfZLYGMfqrP9B+KdSW2kd/UHxofdKhuW032l
	gWbXfNf2NqsPYO4zKGVsLhpJS6yCc6XAeCdcVL2HL41ez1u19mt8lbgOu7TUIt6YeuIgrE/lTRBbZ
	WVbWSsew==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1unym6-00000005eRR-1rob;
	Mon, 18 Aug 2025 12:15:42 +0000
Date: Mon, 18 Aug 2025 13:15:42 +0100
From: Matthew Wilcox <willy@infradead.org>
To: kernel test robot <lkp@intel.com>
Cc: llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Linux Memory Management List <linux-mm@kvack.org>
Subject: Re: [akpm-mm:mm-new 166/188] arch/arm/mm/flush.c:307:41: error:
 incompatible pointer types passing 'memdesc_flags_t *' to parameter of type
 'volatile unsigned long *'
Message-ID: <aKMZbtsa4msTYAuo@casper.infradead.org>
References: <202508181807.zhZF5TQ0-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202508181807.zhZF5TQ0-lkp@intel.com>
X-Rspamd-Queue-Id: 99401160016
X-Stat-Signature: 5hjpd1rccjco13syxi9ri4y7sru7arh3
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755519345-735428
X-HE-Meta: U2FsdGVkX1/CD3Kr+1ZPgJlTPMPKZNSMBINCbB4/HRGP+AvNY42i5069PdiS/nKZ0nsHoHTmjK/7q2H8nEdx/FxG7t3ItLufuL8RsNDheUN2UfDCp8wZhFv7eXnBqPZmgAxxbXJjNRR9mMF562U9bsiKxVblqBCzHS8CZzBK4ASc2dVXQ/vimlNoy7t20RZYGzsFUGnNFk0AN2f14pKB7EcYk3oVBz+7EE1YUhGxqZnNnibeKTQYNSTyciRgBW62SKmH0aeqLE+W5ZHbZmhpn7pWmFw1EQheuf8BJE242zBgBRDhsiKygC9IS9URa2cM+kXhjW6LwiJ+nvA39qW0lPYYUYOTlsgG10IUOhv/b/v2UsTAJ5eBiYOa31PBXmWPaa/o72PrU0h5v+DtKrsUE9JUVa3wODcD4djon4cIQG7mO1Ove1ZfJqPp+81mYjgF4eVBIj2Oyh2BMPgrdK8BCJgWQN/z74MP+rZ6c1/Q71s0PQ5PBtVEi2ckK6rhTOvg+yjF3ckKmOjZwenJ8DS8m0bWGm3wkEau++YMFajhTM30gLgYfIKYboF0fLhjaRQOi/N5tlamIQy3F6J3hVM7QbXzCaz09Vo8Jo05isFknkN7rDOcRPdR8gF6JuCsiLrRoD/M9nCkxoME61qxMGg0fIadB5lghIS8oCNI0OR6QKtYxjEllcg6dRn4hQV6Gbfg26GJjyNbOZoaCN2V1A7ztbUxdEjgpGwNhHYBD7+PKNkDAOmf9LfUfjO9B56re6qN/L0dMC/4qTkUVnb39ve7/vqJC8v8GLJhY1hVfloTr2ho9bkuvtYP1aOVEHkc8PQoIaxUAotW85x/7htTRsdHYuiIQbO+8ThCFOh/2OtK5wXcc6bLT1BM3vLz+rN0p0X4tf+pqRCBlgAqvan5gILkinXs/E7qWhX59eNMXpyj3jxkq6+xIBs90vk2NYPZiN7jzQf0U7neBXpnUFCnf74
 An+SHnr1
 YCSi0w165b/kIDgbzG/uDyzWnrzL87w8UBG26XBSVR/uQmrV4TLdDHA4HqwrJ4Ny6KQA3qKhxTGhVOIJWOq7nE3geLiq5jiPtV4mGHhxH5xDIOHsOQ72C8q6eBeG7lAXrF80TSf9xngHcVjcsg6MOeozaF9/q2A39Kl0gh0t+BHUs6XOHHUecBpYZc3058hXBH0Y0/e78uXOgE1rC+tzLOzLafLXUQneVVtBkM98nnqrsAHx7u1zvw2bs1/FR7ef+DZos/NmsBYftZxR+DW1/OdASl/sSVDi3DrrLxZkotzn6UWduoeB6gcFpSw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 06:17:13PM +0800, kernel test robot wrote:
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/akpm/mm.git mm-new
> head:   dd1510cefdfec9dc3fa2bae40e0f16f1bf825567
> commit: a2004477b3282318589bf43a786d952856adcaee [166/188] mm: introduce memdesc_flags_t

I've had this commit sitting in
https://git.infradead.org/?p=users/willy/pagecache.git;a=shortlog;h=refs/heads/folio-page-split
for over two weeks now.  Are you no longer testing pagecache.git?

(the fix is trivial, I'll send it)

