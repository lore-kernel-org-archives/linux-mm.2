Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 043B5CFD646
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:42:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 39B676B0088; Wed,  7 Jan 2026 09:42:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 373236B0092; Wed,  7 Jan 2026 09:42:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A96D6B0095; Wed,  7 Jan 2026 09:42:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7C46B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:42:50 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C09601B1EA
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:42:49 +0000 (UTC)
X-FDA: 84305434458.20.B6D0D95
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf16.hostedemail.com (Postfix) with ESMTP id 40427180008
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:42:48 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767796968; a=rsa-sha256;
	cv=none;
	b=0PvxvqP97ax6qoKAM0gehNErpghOjjTi/DA+vOydPJ+owcUCcNfQ82FnCC2m+bjorOWh00
	G6gMgGbeLhgMyIkxWEpVI8cnqCbNFq4s53PgxDOPmKbToOwgscwBMiupE+B3FjcIvFdenm
	lVZqWL2XdpszlYd/1cDINgFJQ1lE3vM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf16.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767796968;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=f0wWC8TE/hWdr1e40O7JPX4+48/35Q8yjX+wJXDlvlQ=;
	b=Zj2hGx9e6uPt1vdR3NXah3746eTq0xL+Pro3UBebXXC6eHHqm0B5CiJkMeH20n5i497nou
	t3PkinnbTA7QxHPWQ1buYXX3QtW4Nj/Wghz4UkqgCTZlAlAvBq4IjkXwApJ1Kdxz71zIRX
	LRCcV7zwCW/YD5hGcotAsqI7DAiNvrc=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 45DFD227AAA; Wed,  7 Jan 2026 15:42:44 +0100 (CET)
Date: Wed, 7 Jan 2026 15:42:43 +0100
From: Christoph Hellwig <hch@lst.de>
To: Chuck Lever <cel@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>, Mike Snitzer <snitzer@kernel.org>,
	linux-nfs@vger.kernel.org, Chuck Lever <chuck.lever@oracle.com>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 1/2] NFSD: Add aggressive write throttling control
Message-ID: <20260107144243.GA15228@lst.de>
References: <20251219141105.1247093-1-cel@kernel.org> <20251219141105.1247093-2-cel@kernel.org> <20260107075501.GA19005@lst.de> <cb269767-688d-46f1-8d82-1fd6dc32e94d@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cb269767-688d-46f1-8d82-1fd6dc32e94d@kernel.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 40427180008
X-Stat-Signature: gw4aymw8cz4m56419m6ps6cshoft4owo
X-HE-Tag: 1767796968-134346
X-HE-Meta: U2FsdGVkX1/cXJGbtnwobllZxXTdAXjV1dhLuX/DMzZXAji4zPiHd0F9bFAU4ITb4saIF3JWq42VMaW/WXlTsShmWvoek2sgFik1Clr4epLeoyJtvH/on7dLxjCDbkBL9GMUXpMOAum/JWD2n5WRqWpjz4CF7wDLiKH94UAam3xT1R7A7OgGxKnusK3R7JrY4s7zOoXvUPjxtFkRoa4fx3E+ufTVuzB6zTPi86Uz+J89ilWWqyVULvgUs0qlI2tvLppKmXPhmW6TJWeCNdu4ZTPJ/0jKeF39K1rlLhrrLesGegTj8rF+yQnFNOMTeEi6PXZJ5spdqXDXKbMbB1jWdQDOwiglk5PnRg/QX0gmkVk0rRERnTzrIWQ1ZORL3KXPHaLLqsBE9c2wTQZzRnEgjGWOn4JV8iRI5a21RWJPj0D/X2bQgcwthGnw5imTsSr6SUCAHQbF5jqBWI0aDhN5NAkGC2yMb80CRf1vXiE9DTiGU/U8VgfuwJzQG3jhG2HheqjPs0EGQbDgaSNBRf9+FAGiInG9DUEvg3WufYLmW1NLynjaD0PXYdVVueboPVitDnIBju1T1KVCwQUoBsQXH5AjWENsm/T366zHL1R5xLoXwCW1Xjix5FJ/yaSQvmoR7Gzf7zEdPQAuB1GlnzhqU0YsqKc9CpCP27VQ0gA+LpNPluNqZF9JHa1VyXhinDsnzFgGBVS9WoZh26LREh1xWq8jXBaArUv7CyoGnKIV0Npo2tVkSvJNlh5x7tkJAocC8GuYroyuJz3jEaqC6KgXZpfh3FVFKT+qXn4094+8v1Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 09:36:39AM -0500, Chuck Lever wrote:
> > What makes NFSD so special here vs say a userspace process with a bunch
> > of threads?  Also what is the actual problem we're trying to solve?
> 
> The problem, as I see it, is that the system is not providing enough
> backpressure to slow down noisy clients, allowing them to overwhelm
> the server's memory with UNSTABLE WRITE traffic.
> 
> This is the same issue, IMO, that Mike's direct I/O is attempting to
> address. Our implementation of UNSTABLE WRITE is a denial-of-service
> vector.

But how is this different from Samba or a userspace NFS server?


