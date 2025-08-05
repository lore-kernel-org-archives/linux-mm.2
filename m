Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E132C87FD1
	for <linux-mm@archiver.kernel.org>; Tue,  5 Aug 2025 12:27:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 79F616B009E; Tue,  5 Aug 2025 08:27:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 776E66B009F; Tue,  5 Aug 2025 08:27:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6B4176B00A0; Tue,  5 Aug 2025 08:27:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 56F256B009E
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 08:27:51 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F3CC3115005
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:27:50 +0000 (UTC)
X-FDA: 83742630300.10.6181659
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id C29ED14000C
	for <linux-mm@kvack.org>; Tue,  5 Aug 2025 12:27:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="u/7NLC+w"
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754396869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2H3dqoKmt6KewF6OX4iOpk3CnBRoHquSoV1EUu8cvP4=;
	b=tEWno9N2iLz/QgOkfTJLjjNZErrfIaOqnvjjuyG/Yjvp6UdtoSy0atkxczh13meh/MB7ge
	glh4yczsR+zkWNTjc6Gckxa1BXv1K9bZ7iCSkvs8e7W1/Zn/LlHuLGFg+8Oybfqad3NmS9
	n9pirCELPQbX7u2/Xj+WKom5i0jBTXc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754396869; a=rsa-sha256;
	cv=none;
	b=CGmP2fqOVBXx2PVh6Bi8QxTrQdoR96xlmmXNoaASwKYxJF0sd0kZoGx+fduDyoAc1fB/RJ
	G8m5AoF3pKtJ1GyL4kvKLULQg/pHIV873S8N+k1tgPf7x7vobuLL7UrDUkMjrJqHCGz1VB
	uaTYUMDlkv8NsktV7Myrz0YeRMATVQE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="u/7NLC+w";
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=2H3dqoKmt6KewF6OX4iOpk3CnBRoHquSoV1EUu8cvP4=; b=u/7NLC+wDABpTbOiEDLDfUsppe
	+OJasgD+bTLSJSnR1VvtqAMk8GpNv+75SpohojYB+5uHWxT6cwkGYR007Qk1cnAJ8a6cjKAQuQM+a
	qMtYlBfMvH6HCwmcZPpkz3uTOxHmv+RFXSE1fsbkV4T5EPCibh24JZkjTTa0qK2KJiXc//MU1vrRE
	zkd3/dSUY/FjOt7PBZH7CeudNu+ivL33wAKE7XHlVFXYaegQdwdMLwN3PVP3NWl5Tss7hQ9Fva4YQ
	DV+5mWlCTg9ly3CiH/jqC+Qg98oARm/JkN82+MJDnQBcK4kRIe5b9LgXCZY/1Kgbyvx3pgFUOuleR
	Y0BZY6Hw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ujGlV-00000001QWt-1LGx;
	Tue, 05 Aug 2025 12:27:37 +0000
Date: Tue, 5 Aug 2025 13:27:37 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Li Qiong <liqiong@nfschina.com>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Harry Yoo <harry.yoo@oracle.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH v6] mm/slub: avoid accessing metadata when pointer is
 invalid in object_err()
Message-ID: <aJH4uT0DwryhE3im@casper.infradead.org>
References: <20250804025759.382343-1-liqiong@nfschina.com>
 <a5fb57c6-fc32-4014-a4ef-200b41ddd877@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a5fb57c6-fc32-4014-a4ef-200b41ddd877@suse.cz>
X-Rspamd-Queue-Id: C29ED14000C
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Stat-Signature: rm5hcpszt984y61anhmdiasa6nsi8m3u
X-HE-Tag: 1754396868-809777
X-HE-Meta: U2FsdGVkX18vfZW931id5PkvG8iupLVSSJzJHYvXVQYTWWtv0gE8jDT9BOmP36zBtKXMwesxFVlHtQAVK5tLSM+2W2txKUnyEaazqH67kYPUJ9B6qhzukM8hNU+o3DInJu/e0243SpJefQe1rMGYyyCDgJeEPJ6ttKNHC4rkg+dwbTrejjDYaJ2zdMckrNBZf/qOvS36qa5h/KNzojwRyWW6nzDEYGBulrAWGIyvfXUIh4jXos4icjsEgnXh68fQTR9jnhF6c3y3M8VMyRlwWvvycKNodWw2mnZ68UIgFlHYxC4wR7ADcvNLZr928NSfw7CKi2pnPstXJrti6QfTxtjo0aN7NPhGCokG3iU4HkSwh15UpD+MKaepCXXl0Z03isFXFCtQ6tiho6udh0o+IBOSXC+ND3rhsJlOmtX0SifxZcFHpUtXJeIHmiMEw2ixrJEW7uvWMWB8ghcJ2hXGrRVQ7XykYB164en7z3bfaplWVzz4+ZtgWZycI16q/oPRZuzBqks8mU6r+n4efrsqCIYiZEHkK7FZAibYJqcuCfBWiL2trjmqkrk2I+hnC5Dn3+ngd4pfPPsKZNA1UCOCnTOk0ThvX4CCDDEXOfgcZKfiPG8sGA3xs8Kq6ZWzYECmEfKphOUzQoXHyAW++ljdrZq+Hg6QApQam4nM5sqIwbihF26WQdR3T82DmwtUCeCr8rwSvjBOlgACEolrFh4AsLPOplQprvysUeAje53PZdO8eDQtmR0z3/0kr5224MSIdYXnXiGFttmw/x90Kwwh5qh6UFX/E1OOwdcTYcBxU1WTErVfzRL/dPuDIrG0hMI3AEzi4OxmKBIFYsINIIsdVQMFIcXVtTzJawnml7MEJ1CfOPZWRSvO90icV9Yh/HYV8R0BZDF5oJD2vUxuqfirJfzVOIMdB7HOriloGNw51S2jncPFG4t4MSXhQ39G21s/AaLglyBkA33STGUlvNO
 fJtCcFbi
 S39OZqEHS+5hltNM5lma9sQLeidd6fsW4M9MJJBrnspgf8HU7n8nnCSU6zuvNuaqbnVHHYBONIymUQaiJmrxnxPxlUaPkqHr6Ju26EJvCrwGfd6YpuIof0RjAyTthgOZ9uD7jveszSWWNGgZ0S5ypoF/ol8xDhTgMLAG09wZZxaR3c/C16Co4pkIJyQjyhZzzGwiKCo+BI1OTYIhCMZCsowWCbx/FcMGll1fohcOi2sh28FyMPUn9TOYFxOTuqG+rRHQmHESWexR1GQ3TbakIXu2ZJlUbo7FjUoiRkWey19tVD9r4K/kghq7tY9mB9eiIn5vp1SxOhpPK3Gq2Rvenclo1jJlEoHmLhDIThUWpq3+3jA0603uGNtQA6qgM4ihoyhdozF5amegxi7U=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 04, 2025 at 05:19:59PM +0200, Vlastimil Babka wrote:
> On 8/4/25 04:57, Li Qiong wrote:
> > object_err() reports details of an object for further debugging, such as
> > the freelist pointer, redzone, etc. However, if the pointer is invalid,
> > attempting to access object metadata can lead to a crash since it does
> > not point to a valid object.
> > 
> > In case the pointer is NULL or check_valid_pointer() returns false for
> > the pointer, only print the pointer value and skip accessing metadata.

You realy need to get the nfschina mail system fixed.  None of your
messages are making it through to linux-mm.  Either that or start
sending emails from a different provider.

> > Fixes: 81819f0fc828 ("SLUB core")
> > Cc: <stable@vger.kernel.org>
> > Signed-off-by: Li Qiong <liqiong@nfschina.com>

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

