Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BB8DD606A335
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 05:37:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.a=rsa-sha256 header.s=bombadil.20210309 header.b=hj+Mnvzl
Received: by kanga.kvack.org (Postfix)
	id B76D06B08F0; Wed, 25 Nov 2026 00:37:01 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B00B26B08F1; Wed, 25 Nov 2026 00:37:01 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C82F6B08F2; Wed, 25 Nov 2026 00:37:01 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7378A6B08F0
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 00:37:01 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 6CE341A0D59
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:36:59 +0000 (UTC)
X-FDA: 85472532558.28.B8F5C02
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf15.hostedemail.com (Postfix) with ESMTP id 32CDFA0002
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:36:57 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hj+Mnvzl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795585017;
	b=c9cdSrv/jQEguufknHF+2an67mhaUxheDbFKvXpFkmx0V6tghX/8m89/xEDr/GhZCuNgmC
	7sVTcV8nfzPbLDb0y/gfidgXVItVuCgrxTOhstV9fB4+fnMF/kHdw+LQGdTGxHjPzvKBTI
	wCbrO8dDFDBRsL/L2X9dVXs5+adICLw=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795585017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=6tY7qXPR+c8tZisw2M9xzYszGIvCapp/QNzy3udpL9k=;
	b=NWWUvEXkJ4RQHLshcxbnxqgF+E1lFEwD/aSCiZhhQF2ZuhLnk+jv01mMa70culLPQxasPi
	k5lVNaELs1lkyPsd7qnPyx78ckqnFIRFVtn9OFviebSiiYAtsQbEe2NRrzxCyszm3RJPVm
	syZKaE0YHJjgrVmb4NTvreRAXPowcxc=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=hj+Mnvzl;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf15.hostedemail.com: domain of BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+4447d50bfa760894bb46+8494+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=6tY7qXPR+c8tZisw2M9xzYszGIvCapp/QNzy3udpL9k=; b=hj+Mnvzlg2D6efDaM7VGu2tcWZ
	Wt3E5/jwvZcLhiACnZqF6kDijNXXjHGGUL21yLs44x16ORA0BlXLnmydEzfg3EkMqUob+ijhFbXem
	FLsdSScnK67WKo0xPL82Ya36hOwF5RcKMCrrq+RPms0w/DyT6bKVB1ipAToYSYV7aosO5RBbou9/0
	wIaQT5ACkeEKOY9XI682VV5JiedWNwyq/d26EIG2bi9sfXMsSFDvJr2ptqTVvXtqvAsReugOqcwv/
	VZfkJCbkzlRtt+cstChUoowdChjU0T6Pl/CpUku3eHCgfq98v9J9mMa/GW/7sUbQ/k+bM0TAE23KP
	CP1ux0mw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.100.1 #2 (Red Hat Linux))
	id 1xW5gQ-00000008TSS-3Fz1;
	Wed, 25 Nov 2026 05:36:42 +0000
Date: Tue, 24 Nov 2026 21:36:42 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andi Shyti <andi.shyti@kernel.org>,
	Jani Nikula <jani.nikula@linux.intel.com>,
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Tvrtko Ursulin <tursulin@ursulin.net>,
	David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
	Andi Shyti <andi.shyti@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	kernel-team@meta.com
Subject: Re: [PATCH] drm/i915/gem: Skip writeback of shmem folios with extra
 references
Message-ID: <awZz6sq_4cjIgUcq@infradead.org>
References: <20261119134243.3745282-1-kas@kernel.org>
 <av8n42vx3Q7zvQK8@zenone.zhora.eu>
 <awBIB3vjr_o-gfCn@shutemov.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awBIB3vjr_o-gfCn@shutemov.name>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam04
X-Rspam-User:
X-Rspamd-Queue-Id: 32CDFA0002
X-Stat-Signature: rago41xrdhk5kfzooa1ipkyex345z58p
X-Spam-Status: No, score=-3.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795585017-770448
X-HE-Meta: U2FsdGVkX199aAs4ESG2oKJ8kTfP3nCVlBnqPkc4d1UCV8HtEcTGpiHVkJZjggsnvANXmNOKA+/w1Ofj9Vk5/iSeMDe/+7ziHYUh3ncDr0KrX+VHl8yfVBYjj+47/n3b1gN+vvksbaUa+3ZFVfr+FhGJ2x/gk2IFmelJuC0QmAM6JTIFADGa/Sz2OGM4zfcWVdM6wmV7D4uYXBh9ptMN1lW3ArKPdPjwdrzfqKOs4OssXRgFnWUVN8pWmkNS+xFGMXksib3teBLpx1Ql6h3zyQFGFA0n3noSUFOmbFAUGZ8SIOb+WYXFeQoOL5D96JqyMt0myGLXlPL2wII0i5sZAh53NDY9Kj9369tmtQIPigRNBg96WwoF+rI+1qTrPbmB84i7LYx5JRN6xJAdLpNt01qjNrnpT/n5B5E/W5VNYLEYcT1Vkh5eKZ+uwLsRkMzpCQcqWoi5a1Y2ugu4ydNUp+zepfj7+MwZq6QAxa/qt15zZQac5CrnLh/St2to4ltcHhJw1H7lBg8CBBQ/lZgkqS4gEJ27pHLD6f9Cc+bemVbg50zMUZIKhRqi/P57qx80IY2pcB+7pFHhIF+eymMmDxopLdn3UoBV9MKe8FKXK8U10Qf2C7YP2tX5E3wIqivugE0XNp0bju8920mm4ug5l0cwnCJkByz88tsBn3X8Jo0awq320Nd50rmwx+vKZVMpuWmtZBGJyLyhwaVgoD7f9x/de/+n3vQx3VT/peHh6kyYELelUa1KPa8Q0HqNaeR/nJdgvQxMUHGaI6cBiULHgr8uPkwU3vaOXJFD0BgYD4vKsx+xK5Cs/pPiRY81s22emCdSWQOY96r0xgJBXYJIuBhGkL7oO9kVSKmt/ArsM+t0JCoMaUqrmPlyseeQUGQz4ym5waLpPiYgzpq4FRR+ir48TVP6iLMfOM+oy+H9m6eoGS3tLF5BQGUManax4TpY3Svp1hPXMVKVhRhgQIk
 My7jYzLw
 8Idkx8qw3T3MAMjqPCMt3XbineN/ICTg2TkWA1JpRlUcBzDe50QHSFV/zJK70v23n0FD1aRFhU7UI9djPfHuTMT/2EWR2eAeQXYS8WFoRtPp5XVU3GiI4LOZVZDEFAn2KLUJ0Irju12XV23FqkVTHbP24IAXpCS6dA6R4Vg2SHXAxvhyEwd/Yos2oDrQDRzW0fB4OsyvHnmJFmQvYaQiONFy0DjxIJLs1flt/LOW4YjqG4XwFRjQntjBpmP/dbA8I4G/RntRjGbZXBTYYALDSDzmVuJc6ox9SwwmPbXFU2SYs2tlcqtvPv6tvQe5gyBB5JCvrM8IfQGAy18OHXvJS/WlIjSzsD/vBHffGv3VZW95G+GOfs+WpJx0UQ2vTOeOWN2VzdpuSMPrzQjraWAUYay1I6SY73Qfe3DQICRAQ3CqMT4X8kbcFvH/1l0yNG7wRTtKysiz6YM8XI2aTab8eXRD4GpDc4geTd8imqDzx3ASO9HD05eeA8EseYurF6muZc52eGFz+y1Up7Ch9yceOVD7WJVLGtMcdA6aFpgNzc/Muiwaz8RPaagaw1eSTg0fYbyRaczWIYIBeRr2SwTyWpfPEycXkiP0rlyVtt6OWW2FT7AtmN9xKXoy3hLkEjNUxuYrm16gq9NjhtvVgyTUoYgZpNba9q/6bVtqkVHOYBVfhn4IbrC0RjgW79fh03kW9YrDoOGHDaHiyP7qTF5m+mFlB48hVGL3mKFDbEzi1E+7nNVpybDTlscGZrJI0ZXjY66hcm8q/tJOFwq2NDlmeCoFEKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 01:17:31PM +0000, Kiryl Shutsemau (Meta) wrote:
> > >  	while ((folio = writeback_iter(mapping, &wbc, folio, &error))) {
> > > -		if (folio_mapped(folio))
> > > +		if (folio_mapped(folio) ||
> > > +		    folio_ref_count(folio) != 1 + folio_nr_pages(folio))
> > 
> > I don't think we need this fix in the current tree. The i915
> > writeback iterator already skips the shmem folio in the case you
> > describe, so the new refcount check doesn't change the outcome.
> 
> Oh. It took me a while to see why.
> 
> __shmem_writeback() asks writeback_iter() for PAGECACHE_TAG_DIRTY
> folios, and shmem never sets that tag, its ->dirty_folio is
> noop_dirty_folio(). So the loop body never runs for any folio, and
> hasn't since 776a853a43c9 ("i915: Use writeback_iter()").

Heh.  I'm surprised no one noticed..

> That makes me question the whole writeback thing. What's going on
> there, and what's the plan?

I (and others) have been asking forever to get drm out of micro-managing
tmpfs.  I guess given that this code path hasn't worked for a year and
a half is a pretty good indicator that this instance should simply
go away.


