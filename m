Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CF54ECCD183
	for <linux-mm@archiver.kernel.org>; Thu, 16 Oct 2025 06:58:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2AA758E0003; Thu, 16 Oct 2025 02:58:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25AEA8E0002; Thu, 16 Oct 2025 02:58:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 170B48E0003; Thu, 16 Oct 2025 02:58:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 05C6C8E0002
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 02:58:04 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id C6BFF160213
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:58:03 +0000 (UTC)
X-FDA: 84003072846.04.8E8AF25
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2967440009
	for <linux-mm@kvack.org>; Thu, 16 Oct 2025 06:57:59 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mwyNz677
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760597882; a=rsa-sha256;
	cv=none;
	b=Ng/HdDYQAcO6alfv1UbP58Sz/qXz7CTQF1JNW8Ceyf5eGYR1Hr5Wdk2hoKOEgEJpu+VNNC
	UQYhu6K3/eV6KcdKVwRPUWQtgbA1wBpnva5tq9Iuu7I9E3oRh/4RNe1M++CXZZKvaLh7hD
	AL3Eaoi6ijzB6axb5t2luKq0SwHGDW0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=mwyNz677;
	spf=none (imf27.hostedemail.com: domain of BATV+f6a10b29b1596ee164fc+8089+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+f6a10b29b1596ee164fc+8089+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760597882;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XulptzeQVjTI81nNpea+p6XosaJr23PZsPFoPrIZ4hg=;
	b=jmxfSlOhrXq/E8n5Ffa4Knm6IRB/szPLz7+8ibYxa8YXHbEusOjye23ngwpd6NL6+cTZ5O
	sgkI6FMkk/JVzJVKNtLR4xZvyc5feRpLGqoDPd23FgyVsaIwXmw4tdmnwrkVeBWdmA0IGM
	aMoaabxAj1uW40eg3WUXtyr/pRMb1ds=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=XulptzeQVjTI81nNpea+p6XosaJr23PZsPFoPrIZ4hg=; b=mwyNz6772Xgh7BHYCFzvQ8vofC
	NsU/Rl6gg7qRPAZ6e+l6eUSz34kLtphlFUNzqTj1f1G01M8rhzmsJv0HGTyRKLHkgvzUYFWZbadCb
	DTfD+6n67nczeFjaH1syiGV33BN+OVfkQWkiPECnrpp/vnDW/tDpFbk3NKisCF6XvUUVQl9Hs7Mnv
	MsifGu9JU+Hxv/KM+MqWuXyugbykFgbFlWPBMvxhAb1vHgWi6ZkXGW4vfgK7+sQcXQW2asSn+Kycr
	vQUzGPsyEihrPwShYdq/hYe0HH3jR91OwHSiKVwLT1JuCWfnmrPoR7IkDhJxathjRm7AeMFLHMegG
	EpGWCt3w==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1v9Hvw-00000003hfD-3e4n;
	Thu, 16 Oct 2025 06:57:56 +0000
Date: Wed, 15 Oct 2025 23:57:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Uladzislau Rezki <urezki@gmail.com>
Cc: Matthew Wilcox <willy@infradead.org>,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [RFC PATCH] mm/vmalloc: request large order pages from buddy
 allocator
Message-ID: <aPCXdDPlBMdfFQgK@infradead.org>
References: <20251014182754.4329-1-vishal.moola@gmail.com>
 <aO9Z90vphRcyFv2n@milan>
 <aO97BjvNZNh0UV3u@fedora>
 <aO-Wxj7al7I-IadV@casper.infradead.org>
 <aO-k2hBimow9oYuR@milan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO-k2hBimow9oYuR@milan>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Stat-Signature: 6dhjfp8tw8nk6u6npfp7zf1o9dubqm6h
X-Rspamd-Queue-Id: 2967440009
X-Rspamd-Server: rspam09
X-HE-Tag: 1760597879-517670
X-HE-Meta: U2FsdGVkX18jPJ9VDEMsWakPNUtZIcLWvv9NcWIvLl5JuwklFDLv9BW7emlzAKk1aeOMb2TNIP/LabMtlmbDf2SyCxdjFnkcnOTjM0YA5M7c/Yxl2zqgeajl8GpAmmJiNGWMjxce2m3jjzApgdBJAWxnLlHXYlSaEhKZmAi05TlW18vLA8UgPGDXpJUhTGNS0B+ehnhqoY0mt253Ax4j2syxGO/17bBLLMNGwId0v5tYqrJObtbiLBU9P3ufhBzYCx4UJZbtkGc1SHBnWeMTDokwZoQf6oe+yQUfPWAwJWmBuCqA37fMOaFDOC6+WpB7ErNFkyaVnES0hFsAOsMx28PO9ikisdxxpnGqfw06a61w4sutyenvU16K6CuJfIln1lurpzAyAfQCuU7jUqWktdDNjkAT0iBRxvC7psnNpDC2AVaPxKa7GY5J1XQJ5Kfg9zH7tm5HxNy1b8ud/pxEY66GMiTvwJcE5NmY6Qo3MiqUPyfGcUhQx2/JbizqZWs9iHUC4o+VgwVYBNe3Ii47AUnASnFgbzxcnfqul4j0B8/w/vQbs9d+NfmqI7WWBuQAl0CKMZ9b1NnkFu1FuHIjsdQYwZpL6R+33hjVnTDzssBADpm883Thp73hU5qMTeDuyU9El5hTQZ2EM8NJmFiJSKDaolwG+NWHbOlX3EPzsyg+kwf9uazzTmOU7EGLvGJUzwOEgE6ZNFlO66Yuz+eG80RwoLp+Gp29XCCgHY4ng44GJjHGyrERcym53tnMUwjhRdkvnbTr9g85kAaut3vg9E10zdxVy0Bmrt8LZV6FG18WTyL2lfAW2FYkFnJ2WLuXa/oVPxe0V75DfFrub2on/waQVrC/ZEsCeyDWTTouObauId2stqkRPNS9CsHuGWKJcEZuxLlyZoPgkzQQ59r6gCai1Icd7xyrh4EsrHMjGuRUbYeywZjnkPM97OdX/SUfxN0hoRm5w0ZOYFI+rQE
 +OBFosyD
 NSiIkoGF/9JtC2fE9KGMqV+RisAqPh3bdUJ6N1RZt6ZhoKJgaVMwHkfsgZQEqFY/vHNo+FSQG5Uf2BK5IuFzbKgXS9BOGRYb/CnI6ZbtIvWswD8YLI/CqySU8GkkuEx8t8Ew7K83LJiLWhtuQkYjp+2S5BxMsrBpiPpeQL63MydBPuagP2fzOxExXj7RBWYLrWgQFlq5i7T48PqQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 15, 2025 at 03:42:50PM +0200, Uladzislau Rezki wrote:
> Agree. We do not want BUG_ON() in split_page(). I think it is better to
> control this even though nobody invokes vmalloc() with __GFP_COMP.

Please explicitly warn and reject vmalloc calls with unsupported
flag.  The fact that many flags get silently ignored or dropped or
could lead to behavior in gfp_t based interfaces is a constant source
of problems.


