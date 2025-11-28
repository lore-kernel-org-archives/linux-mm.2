Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 92F21CFD376
	for <linux-mm@archiver.kernel.org>; Fri, 28 Nov 2025 15:09:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DB4CF6B000C; Fri, 28 Nov 2025 10:09:49 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D659B6B0011; Fri, 28 Nov 2025 10:09:49 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7B826B0027; Fri, 28 Nov 2025 10:09:49 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9B6E6B000C
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 10:09:49 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6CE505A115
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:09:49 +0000 (UTC)
X-FDA: 84160350498.15.C0CAB08
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id 85C8614001B
	for <linux-mm@kvack.org>; Fri, 28 Nov 2025 15:09:46 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nAZtPLjV;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764342587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=deXTwbDIKs9JQLaQPnholrd8uRGRoXWWQE0vJWC870s=;
	b=t2zi6fZnvTgw5I2dlR3akq2YGzTnib59DlDxtq+ntkgFj3tzQ3vGl6wn/tKKxkwFh39cuF
	IIFbUv5bJFjY+2Z/5eNtGLfJyJg3IE3sOlWoSfjeo9ZKQJ66ce6KlkE6TmXnBPxS5hlW0b
	QSSesMM6yoy3xCTIJ5jnZxY1kpoy6Yg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=nAZtPLjV;
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764342587; a=rsa-sha256;
	cv=none;
	b=nFUbSoLVYBhqHvtU+/iMgt/WRI8rXokc58VaIeL1ch7BLdMwlSN5ZoHgIMxZM/3v37FTIt
	QldNO/eq+xk5eATNm+kH/Dm1UTPaq/eSKw1DzlH8pPe1yhjGGep9OiBZnc3npurtuChYdm
	DCvq6e4rypn5DZju6b20ELdbMUi6zzo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=deXTwbDIKs9JQLaQPnholrd8uRGRoXWWQE0vJWC870s=; b=nAZtPLjV8PFjQDFEYcBUeJl4cx
	sUhx+y7Yk8L6G787cH2nx2wVLFyNpxdWD0ERiN3dK4tFZR2wgSyEnW5gitBxk/69XNE2pLbLR9gJZ
	rhDhKLd3shzKnQZRZ7uu7huJUVTwBVM80/EErs4R38LJ2Q0WSkV1pBxoBsKRZQxCr1cqE680IZ7Dt
	oEQwqfo3ScvTk5SBwsKUNAr8kHCYIMqmQ4YYYbpruVX9FfzGoJyGFf5YxUeBLjt3qM6xYWhdcBjxb
	YI/7cNQQfbE7NF9MfemZQ5+EQeZKRYVjkJzsYUvRe4zMoytWH46VhJ9vfUbs1eiJLETqo4U9Co47E
	6ZbLcNSA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vP06Q-0000000DM7x-0Atr;
	Fri, 28 Nov 2025 15:09:42 +0000
Date: Fri, 28 Nov 2025 15:09:41 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jordan Niethe <jniethe@nvidia.com>
Cc: linux-mm@kvack.org, balbirs@nvidia.com, matthew.brost@intel.com,
	akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
	dri-devel@lists.freedesktop.org, david@redhat.com, ziy@nvidia.com,
	apopple@nvidia.com, lorenzo.stoakes@oracle.com, lyude@redhat.com,
	dakr@kernel.org, airlied@gmail.com, simona@ffwll.ch,
	rcampbell@nvidia.com, mpenttil@redhat.com, jgg@nvidia.com
Subject: Re: [RFC PATCH 0/6] Remove device private pages from physical
 address space
Message-ID: <aSm7NTtNfGcXbuwr@casper.infradead.org>
References: <20251128044146.80050-1-jniethe@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251128044146.80050-1-jniethe@nvidia.com>
X-Stat-Signature: knjrwjy46f9hoaugfmehfj5tft34xzad
X-Rspam-User: 
X-Rspamd-Queue-Id: 85C8614001B
X-Rspamd-Server: rspam09
X-HE-Tag: 1764342586-478003
X-HE-Meta: U2FsdGVkX1862Allli4b08LZ23PO2cGjINwNNdhFiygfXhXP/CA8kZy8D6/k9UdzEm7W4TjhuLgwvw8pRM8hZ/AV+EGn5NaNTaIjqE6+TU8KasvyLhKrMoUEPfJFg0lmVqzEmhYzkP8QeEJKivHUvf/BtE5fLfyBiBsjIEtoLqAJKroi0nnqyDcFE7OPzNf/j9yAXrntbEOkB/E+coAgaf7yH9n4gCvDYX7xED1/dGbwQGHPp/iHteKQHgtXHJHekdregguLBzFBqWYJ88BcJVFlpJPMxxq0jWdboWFgBN5eL9EsaDLaEkf/WtoZceagjOlf+wwLANatXIU/Py/WsE+ERo48NbByplHT2IqZXHhnUMUaiyATGcAJkvm5BKUanyw7xqrL3GRpDpDBFL+k/Rb85EuZiuuyT47sdbSaKzh857+Dc8zq9DZjQInc+hTicwxNBR8tiyj/vM8JzVK+moZOy4abiVk34ChrNFyg4oS23kkJju9nZ/WF9ncFQag1rvi2JcZvlDk0SDNTC3IsU+IlSOvFJ8my1pxHH8u+Fw9g4MUFu5XPMRSmhQx6FCbs1xD0pAMtpxD75a+/9gr8nvNGNuIXiAiUMfeJTTSnK6ExPD6az14XVot0M4LbMtfWIrAHcasvuCWlDCgkY7D/4zBWIxhMoDMeVUcTT5PQpb525wYcFtJl9dsUbKQ4je04BPtSurykVYjwL5ZMgCTmNywlVm30wXl399sGatEtuHvw+DgPThNTsQv17NX3hXhAjRVY1GL94oaO5iO62knPCRB2PPflfUSjejVo99xaNK6NcvpsjFJ2bS8bX6OFuKpc6Di6Nke04WJTE21pX7cot7eZmAou2pAz+yt2I70PRXEqn7ve7fBOZvSfR0QGWf8XEJ8BdA7kY6MxwQEnXlkYuNh0szkU74DYySy1oMbRuWRZ+YMEmqZlYKykeHd2D47H/HtLTwboQ3xYcFPJZeu
 sMtxD9qG
 +yYHEoei32cm/JMFf+2VKVzPJrlfVvuZLK1IbWId5MFDIrGbm4zlU/7UUaTYFvhOOXdAiDw6d3O9TpMUwF6+MwD1YEPXEMCndktHlJN77N2dxavrk2s6au7ztfaygfqIycoj3Bu8mYtQpn2K7ngAGenLlv6bxhGtirvoBwRIQpMJetywzvDUrnTFJ2Iv9v5vi+lyBwu0iBu0X62NOo+WEPyzm87RSNo4SX6y8pAVw+E1/zBVQZTEwrSXzCIcPYOrQEtRt
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Nov 28, 2025 at 03:41:40PM +1100, Jordan Niethe wrote:
> A consequence of placing the device private pages outside of the
> physical address space is that they no longer have a PFN. However, it is
> still necessary to be able to look up a corresponding device private
> page from a device private PTE entry, which means that we still require
> some way to index into this device private address space. This leads to
> the idea of a device private PFN. This is like a PFN but instead of

Don't call it a "device private PFN".  That's going to lead to
confusion.  Device private index?  Device memory index?

> By removing the device private pages from the physical address space,
> this RFC also opens up the possibility to moving away from tracking
> device private memory using struct pages in the future. This is
> desirable as on systems with large amounts of memory these device
> private struct pages use a signifiant amount of memory and take a
> significant amount of time to initialize.

I did tell Jerome he was making a huge mistake with his design, but
he forced it in anyway.

