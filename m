Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3B47CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 01:46:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 244CB8E0005; Tue,  9 Sep 2025 21:46:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 21CB08E0002; Tue,  9 Sep 2025 21:46:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 159898E0005; Tue,  9 Sep 2025 21:46:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 013BA8E0002
	for <linux-mm@kvack.org>; Tue,  9 Sep 2025 21:46:42 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6FB841DF382
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:46:42 +0000 (UTC)
X-FDA: 83871651444.27.AD771CC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3C0D64000F
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 01:46:40 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f0FcUSZZ
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757468800;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iVZDanYB1GEfuIgx7b8oUnFAcvHUmEEb2jsYYOOe4vA=;
	b=8kcuqu77CEneZ7S37J25VpGf3J8osj5kUtkU4nP7Ih01LDO8SJg3caM0YBT/Pa+3YvJ4Yd
	cnj+R2g18x7sRY8b6WkTvw9FXv8nmd8YW/b4MlOjky0jNDQuUwp2euXdZFNoT02atVh+19
	iPrynGAxBWgQTriPfvaV8nMQ7bD+XQk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=f0FcUSZZ;
	spf=none (imf12.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757468800; a=rsa-sha256;
	cv=none;
	b=nlG/yUH9N7tVZXAMk8nEmn4Yum/esdZEvl5e/wsYa0J6Rvq2f150l7UCei3AW/FWFiR6By
	lGQQkftxZUZkbQob9/rB9WMwdcquE6ClGZyoJxXnxtnyGzKmeS+mQT0NGfV+i5753N9FtR
	KclbhDhhZuJPD+UPoTjkUqw99PqC6hQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=iVZDanYB1GEfuIgx7b8oUnFAcvHUmEEb2jsYYOOe4vA=; b=f0FcUSZZjVJBUU1eRiHtLrYC8B
	fX8ygyKP47lN6S0QCXn5v2gT9H3CAbs8IRUKYD4o4ahPPQW9SC1LbIjyzIFy5IpYnJc/Zi35KMKl6
	GdUlF1LCy0kzBtNQT9ZzXDOjZmQlcu+Xai7VaAjWD7/8ywjnmbm5Ol0aHh6nNDZ+nK+u02Mi2LTbP
	KkIhdzSbwdYhFuN6+BCgg6md5Cbqr9Wtb/OQnYkHd+LUsIIIrFqJgd3p4eVkD/vtGMjJRJWTj736c
	yd2K/AZ2RcClBL8DLGKuOfEPa42TkTPx7o/71xbtDzWPW6D8jMVCQK4Hk2xdsrLnqU6R/xPghQ5S7
	5PHe08Rw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1uw9uo-00000000UeR-417j;
	Wed, 10 Sep 2025 01:46:31 +0000
Date: Wed, 10 Sep 2025 02:46:30 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: ksummit@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
	linux-mips@vger.kernel.org, linux-mm@kvack.org, imx@lists.linux.dev,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	Richard Weinberger <richard@nod.at>,
	Lucas Stach <l.stach@pengutronix.de>,
	Linus Walleij <linus.walleij@linaro.org>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Ankur Arora <ankur.a.arora@oracle.com>,
	David Hildenbrand <david@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Suren Baghdasaryan <surenb@google.com>,
	Ira Weiny <ira.weiny@intel.com>, Nishanth Menon <nm@ti.com>,
	Heiko =?iso-8859-1?Q?St=FCbner?= <heiko@sntech.de>,
	Alexander Sverdlin <alexander.sverdlin@gmail.com>,
	"Chester A. Unal" <chester.a.unal@arinc9.com>,
	Sergio Paracuellos <sergio.paracuellos@gmail.com>,
	Andreas Larsson <andreas@gaisler.com>
Subject: Re: [TECH TOPIC] Reaching consensus on CONFIG_HIGHMEM phaseout
Message-ID: <aMDYdp3H-yOHU1Pm@casper.infradead.org>
References: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ff89b72-03ff-4447-9d21-dd6a5fe1550f@app.fastmail.com>
X-Rspamd-Queue-Id: 3C0D64000F
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: sxyr5mi73k7zf4i3r36nfma7uc98bs7d
X-HE-Tag: 1757468800-946498
X-HE-Meta: U2FsdGVkX19hvFMjz3xgA3igtPEQVgNCcb1ssU6wvzUaFkHzH1WnXDV29JgXFGEhltuprM0A9qFE9zzH40J7fwEz4X6yOwntYaVGQaVqg39G6UDiiUAfGGJF7jA9VIls6r6rIN8AsVwB4Yl3/ZBdiM+YJco5toVoZNtbEYcDR5yQO2IhPcMrSQX7BzBu8foWOQMatPOA7YsuufQIg62LE2V1yd1eVmLm1Sc80UYJAzrW8ju9M2OM9Ga9h+ryaZaaXXzmPtDF1H1bzUzmuCx7yIakq9z785Soc+ToUGMTNaWl0h70DnE47FdnX/kmA982BM2TIz6mQjlpYVgoYk5u+T5PcMks8hZW2/L1uC3XNWY5eSBtK+mv0T8ixFjOaRzPCYrarUHHZJAiY7Lf+GzuNrjqGdwmJm7IoOLEBsOm+odVZv2ZJHql08bV7N4TIjWU5/itwQ1ViC3eRERXluAUcRN+fJ+T+c0bXcLlTV5dXZb/8Hq7//7MO7Op5H6z6fJ8fGwnr4cnT+h8F7cNQKhhxmeiAbpMZFDYThjdr8ktsRkD57LUY8OenhgBFGsPTRaJwqNaZuaAOIZ+YSWrl4HQMcpPAKiZQ3CeerzyNcep8VKUsleMP/A7CdGjFvwHTpzGQ3ci71qCiXnWAGqYc4OJPLFp+q2P7BJujQTg8PoGokaMW+vdX+CsIPhox4u7uWzSMZrb5oofqe//P5XN/gNW1qR6QZIOKBs/OlHPlIzWceDH6VPeaOYs+4l+ea1W40i2h7v2XpURKANzK02uePDxY4PiuEjbZWdEcYPXaJgHS/NZ9vmnSTTya1kaW/qjKgd4NhxN13qw9k0Z0x4karquSXJ0j6yrc5tgPEKa6k38/SJV+S7hOMOhMRzzKM5Nuo+yr8VTnULuK7qDus8bOPMZsdFL2savAq1VYR6ppV88sgOWKyCXDTURUDMI3arTBtaeixDJ/f2sULvzsvPcem3
 GTDdiBy8
 +YNFs1Llc76TtKsUF4VMi3jO1GWYvGjgG9om2EszGbzLlpuuVanpiJErTU1Rt6KnKKBELs9aVDZavzVKcpxZ+pPEZp6TxfRegoD+wsYJxstP/9tUJkroDT4MLKxvRCiT/ZqrHwCsyFqU1pCxZTyJ6YDCkGNDuPVUOeNxYpdugX0grz0WRMq49RiIksvoSQywy8BiReJNQAqACRL0duJEr0G3g4aHYQKTx2GyCL4YeNXPO5cfrKbSDhllvO7o9eTVdcLEaU0gliyvI1uwURqv95ULCpGY+z3VO8miWgO+gZ7PT5NNIPN1YDZxXSQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 09, 2025 at 11:23:37PM +0200, Arnd Bergmann wrote:
> While removing a feature that is actively used is clearly a regression
> and not normally done, I expect removing highmem is going to happen
> at some point anyway when there are few enough users, but the question
> is when that time will be.

I don't mind that the feature remains ... unless it causes us trouble.
Which it currently does.  Perhaps we could start by removing HIGHPTE?
There was a certain amount of complexity introduced into the page fault
path when support for that was introduced.  x86 removed support for it,
so it's just ARM left before we can remove the complexity again.

Most of the other pain points are around storing metadata (directories,
superblocks, etc) in page cache highmem.  I think we can get rid of that
now too.

I don't see any particular need to gt rid of file data stored in highmem,
nor anonymous memory stored in highmem.  And if we're only talking
about hundreds of megabytes of memory, I think anon+ file pagecache is
probably most of the memory in the system already unless you have some
very weird workloads.

Where we may want to be a bit careful is some people have Plans to
reuse the kmap infrastructure to support things like unmapping the
pagecacheto protect against spectre-eqsue attacks.  I know Intel was
working on this when 3dxp was going to be a Thing, but it's recently
been brought back:

https://lore.kernel.org/linux-mm/20250812173109.295750-1-jackmanb@google.com/


