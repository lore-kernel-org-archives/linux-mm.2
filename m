Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 796F6606A69C
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 07:36:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=v8EOTEaR
Received: by kanga.kvack.org (Postfix)
	id 875B46B0922; Wed, 25 Nov 2026 02:36:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 826C06B0923; Wed, 25 Nov 2026 02:36:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 73D496B0924; Wed, 25 Nov 2026 02:36:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 4BAC96B0922
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 02:36:32 -0500 (EST)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C3C0A1C4607
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:36:30 +0000 (UTC)
X-FDA: 85472833740.05.76490EF
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf09.hostedemail.com (Postfix) with ESMTP id 890D7140003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 07:36:28 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=v8EOTEaR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795592189;
	b=toBedIe4cQf/z0Iz9o+oHVKoJnYmVqk3vfR1BiM6uiQjjVmqgRdJoFC460dXjjb5V2HTh8
	A6yLxjPHBbSuHKWPjwK5kvX0ORYQEXE1S7GHlV/UV1K+3KWf5nojZqP07pn1cbP5PhEKff
	hfxS9bnlDwPc1bnyM7c0+4TQaX8Gaw4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795592189;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NqNmpPsXgETS8dZeuiCyJlLE3rCmwYk+XFbPXhBfg4U=;
	b=c3IhYrehxIantLm7MK0e+nANl79Jq15IaaezHZ7l7HBUf0NJAV4YtdtfOPf36a8iZ+ECUx
	j3VnHOqQsbBPwmkVSqp6z556JL9+NIya4/UJnxo2zQaSvRp2W37e9/RQZNVDxCrbDi92yQ
	/yQerMR9nT/XHwmp2l8vHhdHvuDxkzI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=v8EOTEaR;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf09.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=NqNmpPsXgETS8dZeuiCyJlLE3rCmwYk+XFbPXhBfg4U=; b=v8EOTEaRlkbw5Q1MD4ATdrS8Du
	2wLhbbgEsGmVs2gzSbe0zfglIVkfdWxz0ovS9CWjZwEl1CGJ2/C7bDC7X3WguhCzxTmDvhE7lnkdB
	2PdOthUl8XjMxaiLMQS4DnMzgiwDG9gkZMZ/MgOxviFcgX11LYqlvEvZ9qIHOuMPnlfD6S7+/WcLZ
	x78t4cRSYCT/NuBnjkRcOSbjdyN8MJavl4xXiAweXPTJalZVcgJgOIkJh5lrxmc7BwYeSj0BK7DW3
	D5sQTHw1xvNoOL5nVGPUXJgyiWNirG1cAYedkL4VUTnWGojZcvbrSgdl0Tsg5R6yhsibfI/6ruAfJ
	7f0262bg==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW7Y9-00000008uf8-3ovC;
	Wed, 25 Nov 2026 07:36:17 +0000
Date: Tue, 24 Nov 2026 23:36:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Pedro Falcato <pfalcato@suse.de>
Cc: John Hubbard <jhubbard@nvidia.com>,
	Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>, Peter Xu <peterx@redhat.com>,
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org,
	linux-nfs@vger.kernel.org, "Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>, Michal Hocko <mhocko@kernel.org>,
	linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Message-ID: <awaP8a3GaI3LCcuw@infradead.org>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <4f096d70-6f94-4148-8f47-242b8551e5f9@nvidia.com>
 <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awWNyDZT2SVu2Zp9@pedro-suse.tail5790ac.ts.net>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: zt5yeb4ffre83ued1pxe8bipy44w4dwj
X-Rspam-User:
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 890D7140003
X-Rspamd-Server: rspam03
X-HE-Tag: 1795592188-6579
X-HE-Meta: U2FsdGVkX1/atfbL1t3TFf5dLAq3b+VzidnoCvBF9l79GlgUjqIg+uK45I5SUFUxi9qRg7QY2Jrz1A19VZEj54TckdEX8vptBaaTxlv2TJ/z8P8IhOrCcmeRF60yGvlx3UYS0vHGc1K5oi93MBeGas2Vqm0pD0iPjJZo65gg1AEgtQRg2LO6NHtyfz6DFU2z0V+E9rrO/IxbpvN0+LTA79vkNjc+TozIQUMH5OKhisXyDNMcDaH6aXcwkdF0kB4RffHpKYrmTYXplswxUrnv9yHT4zZwGkzt/PrCQ2EI1zvAFJWkEU5ndXSjJsOOeBI918Mgw1gtoF9Rks0skpyhkal1PVsagpY4MZaIrWI5RBGMBB/pCQb8SlcdCtZm4CRa7SiMzDZLoaebBmNZdBJCoR7KyrT6o/h9Ogd9u635NF4RwL0Reou80FXFfGINlgJihNkgfn+qAaebpnX93fJSq8x1/jz4n4isq1hI6rVr+cbRubfRDFFS1Cze3KwggLcDELOe42GSm+flmk3fTVrItQ6GU3Xr2zUZHC/YvtWIeLe4/tPrzdjdgo43ckeNWwVqo1pjVIqMxpfGJw3dFreCLlLY4WcHyzTs+WDiTt8cdqdXEsCfji/ZnNetiIHeoPXd+z9ZZ2Gedl/Tj5v+Iavcqfx0S9M3adyOunsw9f/g3TY3/E9O4sYel/CMINBEs7TopvVLkC4g3ytmIdrVviyGdrgANtzuDLcMDXnPWEkWIok67UZBD4xL/WXH4q74Q0r6Y8NuKol96RrgeddgYgIdM4Szglke+/rfVc/VOetVnLgCJ7wWw9gY/GJ4OUFzseHmyojbwrmMSBmwxMNbETOIzLIggA4lo5dsC5hlBp5r7lrlne26TzmD1Tq/W+NegOQlpzNjhtGWMKauENBttkpuczjvkdFE80pMA/4uu9oh7lqp/hoEWkYBRCFfLfKrNqJsSwIgXmvbHEa1EOLig3s
 lHnoAjKQ
 M0dTdvGWP73fi00uj0roNg5zb7xgKQFpTia8imeYoVY8xlmNxufkOlWSD3oOzs3r9iqon51bfbxwyxXMIF9vREglKAKALHhL7YIuZ8FoYETKtYt2RxXWa3EkxlQx3jTxMyH58nrtgs9RnWywLP8pF28gnIZWlPUc/7blG65otcQ/MFbnnA75x2UsARoBorVmMyvvfpo73VKw+nehEyho2c7PEV88f5WW7rqmcXEJpnRhBvsMFmgIsjESPNKiA9w7K2QCTdbVdYiDCQcvffJVDNoi3M+kHL4cA0yLSkb3CqVLv9J66VGy2oPeXb0Hl/Co1t5XJSQeEuUASTGU+6rvBqEe1ZUcWA7FZOV8klUD+RiS1dTG96hnNGrqXTgCSBTAc1nlzgOouIeLRCJtgcnpP7x1cgGhRiTFan48S7FfczEwd+hXwQKKi+O3hYNSqdD5cibKP6RJQy3/wGjtGvdei87FzxUagU34JzfUyvnPVp8JQ/IEEvQGbB4Nko2O/LvrWWGoaDjp8YFf0NhLEJS25p2kjlEfByVGTsHKFvd+KrFm5+evjw/1UPIDh6aZ8AeghFSHS5kkJz5CCDLZZenPCtgyHIaqYu66ETmL3aiMWx5hZhsz27V8EIapHNCBv9mWPq0nSsPuPCi1X+wYgHsl9RQqZlmCbQ+ToAOGZNrlFjhP7RnxBCBV8kbAdbUYhYyAGRushNhXikAj+k4pTtbRGwkNhQ1Md9HL40F8AdxIEwLZGD0yLGLAAEbBRe3JcWBlgsrxLxzdNZCKX6MMsoDj11tJpGz/UkwpZ0FTfQJRc42bHQ65HTn+7tZfvwltLxLzsmPbRaNchWZLTnrqjTOTiYzml7zdAR/qutyAitGH8PQ+ArIOz6zzXLxO1iQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Nov 24, 2026 at 01:37:43PM +0000, Pedro Falcato wrote:
> > pin_user_pages() was specifically introduced for this exact class of
> > problem. get_user_pages() is now meant for other, much more limited cases.
> > I've attempted to document that, here:
> > 
> >     https://docs.kernel.org/core-api/pin_user_pages.html
> 
> Ok, so I guess you want me to drop the hacks to make GUP FOLL_WRITE not
> screw itself over? To be clear, the rest is still broken, even with pin_user_pages().
> It just means we get nicer looking fixes, and I can drop patch 3.

Yes.  And maybe start looking into fixing GUP FOLL_WRITE users if there
are any that you ran into or which are relevant to your workload.

> It's unclear (to me) whether we care about any straggling get_user_pages
> FOLL_WRITE users. A quick look around doesn't find me many; most seem to have
> been converted to pin_user_pages() (though, admittedly, I don't know how many
> of these are converted in stable; do we care?). Perhaps piling on a patch
> to simply disallow get_user_pages(FOLL_WRITE) is ok? Giving Lorenzo's idea
> a go again :)

I fear this is going to to break quite a lot of things.  Although given
how long we've asked about this maybe we should at least send a patch
to it with all relevant maintainers Cced and queue it up in -next for
a while.


