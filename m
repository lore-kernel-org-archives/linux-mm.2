Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5665E63F08
	for <linux-mm@archiver.kernel.org>; Sun, 15 Feb 2026 23:21:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0F9426B0089; Sun, 15 Feb 2026 18:21:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0556B008C; Sun, 15 Feb 2026 18:21:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EE0B26B0092; Sun, 15 Feb 2026 18:21:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id C3A4A6B0089
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 18:21:01 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C59CD1A0B69
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:14:14 +0000 (UTC)
X-FDA: 84448246428.03.A2E4609
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 72BB620005
	for <linux-mm@kvack.org>; Sun, 15 Feb 2026 23:14:12 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tq38ZBkw;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771197253;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Orx67w0OdZsiD/sxqMgXoLutvDapJy44psufStBNd34=;
	b=3wKqiinVJm7fzLAE1QY4wX3+3HSu45Fo2mtBVREoGtFqI11r4pEUx8B1pYaoh/QRh2NcDV
	g5oxpahoIcnIQMSCBDUu8xMnGUEQcfRKf3Q4eZjgvdXcJaCdn/xQskeK89NmyGfInA+lh5
	IU4e2y95VG9iqUTM97nzL9PQDZYrbBw=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Tq38ZBkw;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771197253; a=rsa-sha256;
	cv=none;
	b=AQZRMpKzroG9eOvqnVsutZ7rYuL/BkrfSzjcBlBBp97PE3yAv3u5KVLLycaQc8rTX9yifn
	OevCUfExYS1jkEtD9HYWi5lC6+Y6/Fyx2STuf1tu7IL0Gp2TY11Olr3JriFpihBF8dw6ww
	ZcNYcRPWIC0v9vnSWVcwbba1XqvR4vA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Orx67w0OdZsiD/sxqMgXoLutvDapJy44psufStBNd34=; b=Tq38ZBkwHinLdgKHuJ2F6wb0Lw
	nuKJ0utimPTEs5necEg4OiOp93omwKGRX71185wTqzVACW8X/Btm5RQFtI2l9t/0LXp/dZlyaIOLM
	GehWSFz/SBsnkXJyZynrq8iJyDwnyPiZ75nYhPdeisBx/mBVpuALLKyyepWJzVzLGdsoKKXUpVTrP
	UiG1h5BkIqArcpktGdrJGEQfcuC7wHIfdw2rR8FSTBse3ekOr3x0SqqKT2TOwpGA16cFQh9WQ4mcJ
	1LELudn4ti3SdkfASP4GSMU16UMLBkxEsG2Ob5cpm0F+uWJ/zPQ4zd/VuW57a7wmiDUp7TXRaurH9
	jJ6U3oAw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vrlJH-00000001duk-2IlM;
	Sun, 15 Feb 2026 23:13:51 +0000
Date: Sun, 15 Feb 2026 23:13:51 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	David Hildenbrand <david@redhat.com>,
	Usama Arif <usamaarif642@gmail.com>,
	Frank van der Linden <fvdl@google.com>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	Vlastimil Babka <vbabka@suse.cz>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>, Baoquan He <bhe@redhat.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Paul Walmsley <paul.walmsley@sifive.com>,
	Albert Ou <aou@eecs.berkeley.edu>, Alexandre Ghiti <alex@ghiti.fr>,
	kernel-team@meta.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	loongarch@lists.linux.dev, linux-riscv@lists.infradead.org
Subject: Re: [PATCHv6 08/17] mm: Make page_zonenum() use head page
Message-ID: <aZJTLwV2SaaKu1k_@casper.infradead.org>
References: <20260202155634.650837-1-kas@kernel.org>
 <20260202155634.650837-9-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260202155634.650837-9-kas@kernel.org>
X-Stat-Signature: qkxs9m584hwp1qwoe1py13p5epuyozrt
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 72BB620005
X-HE-Tag: 1771197252-258153
X-HE-Meta: U2FsdGVkX19akJrtnumSWGTeQDHz+Tv8VsoEExKdzMGZK82kdPhlAjdm1HDLnleX2pUH3X/3DwdJ81rLAnTWGn4BQnWpWzLKiK6JMgdzLW2ssR6l2sRfQ0LDRX5pw9qb3QCu8gTGY9aeJjUKD+Y/BLYsdlMAHbTwvmp3fZgRFIuS+9Wv3fz2wpeaYmTeQEK0Cpd0W5noSzzj6OWWvwdzfb0wjhZFuUv4tftFL6gy064nfY9GHWXJ3E2a+LUdVVpUsku9Mq0ljhPEHyDJxUr2zaMRsA/Y/nR8mUKuW0Le0bS1QEMuTBrQYYKlkr8Xd7hrgvha6GzS0sGRA5+gvWaFf7tmXWJb/N3kM8jDKjwQQlIJGXGXzr+dIkBguX00R5Mc90gxo1JEvQUNgZgZ5r2WAvzwhmc+KbIkKpvzRW5bQx/fgCuH6vyd9lAuuWalweJ5Guj8WduIyaUVD2OV/mqFyFrTwYhioHjRyFCoozztqNPu7UQdBlDGR1szxZO/kDseu9JSf5d+Xr+hyMlRQD+//eM0dnqqVBVVvZNz0YFPHUJ+1UlKjO2grp2gy8Uv5uI3YA90fEh+FklLN2B8wDhCJ68iSV181+mDmYqJxRb7H5m2fsIc7fDBP9pQZMsJdp+wancto13+mYxBeDscOD3rgANg0cHXEVdp7vTV7SswPXO9ST4jkQ5uY/Zx/yvTz4k4MiqoVDHNIP/CHkdhRjjYkenHYxsbK44gtxpGnEbAoWgIYMnzu+fILjVckDVGJwwnQR6bKTcGbsHMUk43zw4sMWFdZZF9AjBdeP/Idw76cbTA+9u0ZLjkX8TKB8sp3I9Tvf+fBSLS6ZDL7z+PkcvFGV+O12zLcA6ihyk9P+3ZcvX85+uiPPO7bibwlOIUgG9eox4QSat2WAJKMBOUoPTa9L6nU+MWeC1OpKB5HMRnx0yBTmhChRkd0v3P98nhuB+g5wcJPe7nDBOqGmdQJOB
 wcFNBlaa
 CxTL+4XCVNWuhumN2kBEqh7h6myonepMaDAm1qxafmROSkxZhySqi2uhZERaRyJl2cM0zIRxuq7Dg7CL7WJ/bSy12TSlKZHl6PX9jriFp1TirE44y+W8UMu7Bz6E93GTGceLNlqaFHEQ8j+7+UkFwxdbAi32u7lePVIWt1GbQ6w5d+iWyxzB4pNMRpP8uwaMnaOsH3xOPkZxmQ4tkEh/ikwhY7aXNU23Ikdn/JOVjjtTHxJCNg86RmU+nqKfZZOU9dJLNDZqcj8Z4dtAn5TAWd7kGokAa9OUYbys0K7AeC72kqxw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Feb 02, 2026 at 03:56:24PM +0000, Kiryl Shutsemau wrote:
> With the upcoming changes to HVO, a single page of tail struct pages
> will be shared across all huge pages of the same order on a node. Since
> huge pages on the same node may belong to different zones, the zone
> information stored in shared tail page flags would be incorrect.
> 
> Always fetch zone information from the head page, which has unique and
> correct zone flags for each compound page.

You're right that different pages in the same folio can have different
zone number.  But does it matter ... or to put it another way, why is
returning the zone number of the head page the correct way to resolve
this?

Arguably, the caller is asking for the zone number of _this page_, and
does not care about the zone number of the head page.  It would be good
to have a short discussion of this in the commit message (but probably
not worth putting this in a comment).

