Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8751C624DA
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 14:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 072E06B0088; Thu,  3 Sep 2026 10:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F3EFB6B008C; Thu,  3 Sep 2026 10:56:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E066E6B0092; Thu,  3 Sep 2026 10:56:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BAD496B0088
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 10:56:49 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 525A94055C
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:56:49 +0000 (UTC)
X-FDA: 85172752938.04.166DE9A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id A775340008
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 14:56:47 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8uYt53u;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788447407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sewVvVo8Dy/uyKZY77qoojOHF5+/0ZDpHv96nZFd0J4=;
	b=iERa7kvxoIa+zizX9fBBC0ZMEtTQDRWnONWkDpbaEgoKmaXZhC0iLRe57VqV17prbRe/dD
	w/WZPlSjhsswlcJ4BneGYiHXi7uoDXP3JJFRFoKZReIclIbtlv+D8bhPZbFGHh/ASENt7O
	E/Qq22hb3Twsw0/ScTvR+NhGIx3H4yg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788447407;
	b=GQlF+8rONb8oI0bpNZGo/wva2/ZnisFkWvgAplnNJRgtOiBCA3PMQxjdcK6iBwGQz8mzGz
	f2u/Ze+GPmdM23Vm81I/lYsNT6ra/JjnVqofJt2WmD95w2pkf3xt11Rnzxri5TwvwQVe58
	hFB4JnNj9bikYbWx8a6ZdAYsQ2QFC4M=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=L8uYt53u;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 65F406057A;
	Thu,  3 Sep 2026 14:56:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E9631F000E9;
	Thu,  3 Sep 2026 14:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788447406;
	bh=sewVvVo8Dy/uyKZY77qoojOHF5+/0ZDpHv96nZFd0J4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L8uYt53unxDNYKZf7Y4vZciAiITXax9htmtSv1B4ko/+NkYHyUbMm0k5xmYw1ZYdH
	 YqkRH5UIFvAgYNQoEP4uPERhPI/U51PDU9guJRPq6Kca952s44iw+urk585F4CRKBo
	 aZ7nZStIdXiRi5G9bl6AwbzLR22FTBeEjeBZJM6YNgQLammNOWmM//TBTENdgWHJDC
	 81Lei3albKFQ0oz7bl33i9TnaalK+oIcrFpkNzY1k32Tr3D7NZDzOLIIbhyHB56StK
	 BI+s8Eoew/r1tq2WdAiNb1ViXqj+17CuoPbXi+h/w4a2jm9NqX/h8M2AeheHRwwkU9
	 pAUbkqAm/AY4g==
Date: Thu, 3 Sep 2026 17:56:38 +0300
From: Mike Rapoport <rppt@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Eli Billauer <eli.billauer@gmail.com>,
	David Laight <david.laight.linux@gmail.com>,
	Arnd Bergmann <arnd@arndb.de>, Brad Warrum <bwarrum@linux.ibm.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Michal Simek <michal.simek@amd.com>,
	Ritu Agarwal <rituagar@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 2/4] char: xillybus: replace __get_free_pages() with
 kmalloc()
Message-ID: <apmKpl60eHuVFRjt@kernel.org>
References: <20260830-char-misc-v1-2-05e2ce44f291@kernel.org>
 <f6001085-9234-4025-ff34-6cc4a66c293a@outbound.gmail.com>
 <20260831123937.32255a49@pumpkin>
 <apaF1HUtJnstuUN4@kernel.org>
 <1729fb06-6beb-f8ef-3e71-47fc3f00345d@outbound.gmail.com>
 <apcPg_y-HsMki7we@kernel.org>
 <9a3d6a08-339c-3315-cc81-46907d0836ad@outbound.gmail.com>
 <apgSCyj-h2xVc2ss@kernel.org>
 <1d7f8806-f4a0-fda0-a361-a011460ef308@outbound.gmail.com>
 <3c19c24f-5036-4bbe-b3af-e5eae102f34a@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3c19c24f-5036-4bbe-b3af-e5eae102f34a@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: A775340008
X-Stat-Signature: ustynqms4k5apdxyy9npss3zsdwr9uzm
X-HE-Tag: 1788447407-374881
X-HE-Meta: U2FsdGVkX19v/ZDwOd7chXjZWESW8qolb5TPsUZGxp65Dwbd4eCWyWsM61UjuouD+QuZHzJdMXRk9VNzVytztISJ1Olprb4CG9nKFDzKkSGyAeJZ4zlYwWdO8iRGVnBkJ16MsKufk72ed0jHNFPdDBNWhrBZjJQbdGb7PX9Hsbcb3Hvidy4YDKxPdu7XflTxh5ZvpgMvSmwd/mZ7VHDxF9RbRs3vcUbSFseX+rJH4y2vn+HkxZS5O35PQkUgkBWDBvp3lWvLDkl5aOEt0rdCIeC5T255FpSFf1JcoQcMbIHIzMga3YhyeC6+gPOhJh84Q16Kx/yeHqhtc1f+vDkQtmcHixeWVP7TfYpI8ePJvosyDH5sqbpZG7bT2BexCF1+Ng197OF1TqQ80LWV/UVl/5wUgl4BGrshhauf1bKUUWbYnYaHnG0aCF+avuCut+Op4mhZsqymSRuHeKSsTX13J2tEsIuqcZl8xhfYy79wFUSZIPGMl4hQwB1pl23TBPxTJtVRr/H414DLLc7/rAQ7UrHVgGVLe1gdNNpnUgpoPzj93Rq18sIFxUfZvyNnBJTS1YCynIdykB4QgwqTV+zZ/bU95KyzjFINw7BiSqTrjNV5Vhj4+TvwVt4OwCzsG5W8unZHnjWb+kIehn3E8ty3rgdgHjvcH8A7r77+NdPODHWXgEOzgr+Bz0xX1d1eYEJYHjXBYkqX+s//qN2vpc/RR5bV1vtH/7ELIMmjxlSToNfuzcnSu8U4iBaFMzb0IYmb5BaLMNlnm3i1eyIvPDh3vho7mdhiR8xNn0TI4VJSoe2pIlUQv7Nal3RD7g8echTK49cCTv2wEEqEkTeFNSFNVdkW0OFPKBU1xN3s/kJt5NkFr9kpyCuAXY3PGg5AL3Oy0isx9CqHRs3/1zXM7uAN7bw+NTmvJ4h3jeBKA9t5ysig1jDIM1CcMJcdDB2jnK2lG1Q4d0WL3GpH/KZmunz
 6QvxQTQd
 skBm+Z2cXdMi8znlehig0dseVXlLxYU+coDhvenxo/00JJfbTSZp+ItFlQPYKl3xME3LO1jPBGZ9jrl9nRWVgup1/oZw7h2C75tdbuZWTHVW27Z7RHcviyKsDULJp+Cg+phX9RAjYWOq5jEffja+lW4Iu/3GlmYPlZN+830uEqBcgTArYynQuIOsPPht8MksLhtmwWdw2zbEcSeZ3mZvg8dH5JMnfSKzwyLD8EW9yS5ac9Qb4T2loM1syOQlN5CVnV2Uiy7sfmvlYfhQU9Ys9itZfj4+pW1qxcfZWoeSG/S/IfjA6N12mG9kwKddjLpdgjco4/lkL/y1A451+r/yXG/+7T9mnmyH8hvjkHhSYZXFAJdc4Xn094dwUfUSMRsaHiWUk
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 04:28:48PM +0200, Vlastimil Babka (SUSE) wrote:
> On 9/3/26 14:30, Eli Billauer wrote:
> > On 02/09/2026 14:09, Mike Rapoport wrote:
> 
> > in this case. So we actually want __get_free_pages(), but call kmalloc() 

Just to add to what Vlastimil said, if you want a buffer you want kmalloc().

-- 
Sincerely yours,
Mike.

