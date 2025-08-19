Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B8E6CA0EED
	for <linux-mm@archiver.kernel.org>; Tue, 19 Aug 2025 08:58:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DBA7A8E0022; Tue, 19 Aug 2025 04:58:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6ACE8E0002; Tue, 19 Aug 2025 04:58:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C81628E0022; Tue, 19 Aug 2025 04:58:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B00D18E0002
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 04:58:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5E863C06CD
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:58:09 +0000 (UTC)
X-FDA: 83792905098.18.F942DB8
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by imf28.hostedemail.com (Postfix) with ESMTP id 70152C000B
	for <linux-mm@kvack.org>; Tue, 19 Aug 2025 08:58:06 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755593887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=lI4U7DxrSZnVFh0827A0UBRYCW4TCF5FN0K+Rzz9OAk=;
	b=GXRCWlgTfsdN2KyRkDe3u729ZNeOT/hAStrZwm6RlhD45SBMY5U2O3bw7tAT0/lVnMP2LT
	4VuZvLIEYytDtQkIzwaW2GHMNDlD6rShXOipcebL2TRoecIxROBqqYd/EZHuL8/T6YmqbZ
	52hqYaUsipMgpIB5Fik30GNCLhnQgTA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=lst.de;
	spf=pass (imf28.hostedemail.com: domain of hch@lst.de designates 213.95.11.211 as permitted sender) smtp.mailfrom=hch@lst.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755593887; a=rsa-sha256;
	cv=none;
	b=Vlupt1x/9IkI6bB02HyweRU2jBwHqMwvMAy0/VMF+kYV5Y7I3co0KInen9T/HfiQHghnbQ
	44/mRpWp+Td458R/dFcyon08ymCctUBTBRN+RCNL7U4f2Du95c+v4ntrOgfYyGXZgsS6Mx
	27wtI0vO3Jz39XnN8yDXL7F0pgI8Xao=
Received: by verein.lst.de (Postfix, from userid 2407)
	id 12A5467373; Tue, 19 Aug 2025 10:57:52 +0200 (CEST)
Date: Tue, 19 Aug 2025 10:57:51 +0200
From: Christoph Hellwig <hch@lst.de>
To: Kent Overstreet <kent.overstreet@linux.dev>
Cc: Christoph Hellwig <hch@lst.de>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	linux-bcachefs@vger.kernel.org, ntfs3@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 2/3] bcachefs: stop using write_cache_pages
Message-ID: <20250819085751.GA4283@lst.de>
References: <20250818061017.1526853-1-hch@lst.de> <20250818061017.1526853-3-hch@lst.de> <3zji6rc56egwqvy2gy63aj2wjfo5pyeuq2iikhgudcttdcif2m@dphqqiozruka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3zji6rc56egwqvy2gy63aj2wjfo5pyeuq2iikhgudcttdcif2m@dphqqiozruka>
User-Agent: Mutt/1.5.17 (2007-11-01)
X-Stat-Signature: pchaxr7osqy7hb1pn5wsqut9k3zwoiyf
X-Rspam-User: 
X-Rspamd-Queue-Id: 70152C000B
X-Rspamd-Server: rspam05
X-HE-Tag: 1755593886-968698
X-HE-Meta: U2FsdGVkX19y95RrSmnsFYH7gdFlLLfe6S3cAhXIcbivVti/0N/3+Ntsh/Ps2k9nLd5OeK8EDyTBKassAIAvN7/yT/0WhFoLN9yTscTVBWZXTeXCFZW18wnpQ91Yx5A7uOXZubE4gamtThhonXDR4sxD0a67lPAuY01EOLIlANUcfSwnQ+CgWuCAyHN956eF7x4GTZ0xX5CUVsJvpMgtbe4r9aQuTrN2sGX2uC6Q+puY2SL2l4iPl6MrrSYQvo4hfIwnzr9mgkvUBuj2mVQgAuDB53/0uoIE4lIjYzMQWor/1+ViAsBdMkPxA2/w/4JnUfZu3vlB52p3FGvI/XM9twPJSNzJGAHTASgQ+i+fqNZy/Uandxmgg8YnlsK9lx1unKxQ1l/v/dY8U20od/IYI7+1LCvvTunlQi2BSwuWclnu89UFqwazvdqBzgRCA05xE489qQ9Y5OI4rwYPIT+ew8KjNb6YtAi/wkf6zgOBNbUD++lOB4jp8Cp5ofOYvZIi5WGDY73FwWSlsm1WVUkoyokLnlH5zyPOh7r144aHp9xHr9B+aRlHqxLWXqic7x1tT9+mw1Nq7mnhRZs/O//Z67lYBEkteAtEvKYSbZ4ttSK7oxnDHBdNcg+0uu1sp55mVIZF2AAGqtdDfWmOX+eRP1kQ3s+1b3uNRTfaSIIiZf5+RVMr9bJwPCpnHDeRWI5W+6TKrC5XJz1GudcVFLzS7OnFDtq+vXRZIZucCTyetqxWaG13jorYnXTCsQY15rJsMgv2fIc//UDpp3OdTCm3wjo73zFlJ//AoD9OtlFd7xNnTNHUxHHbgzfQRH5clnzoDGJ13P1ZqMHXLJyi+QnkPCcAAtvk0q1Idenf+igohYmx5MhuP6VyF4rmKiDY5YnVDL4kwl99JFlWk1l3Cyp9D3LdvgSUCyLuv4Pj8l/LEKaEinvVk9bxnm46XdX0tIGTXt5nDwLO6ykiMnAG2cp
 +QWhQ7s8
 0yhPhq31mdS6snpUNE1agU8RAOxomwLIMSKrB0fy6Hk6BUK1XxkD1heazgqGMcaPAGpZJ5e2aeqv61oEXJZ9EXXA/aiK6tH/XTTXHTvukR6ujf2o4IlQPGw6CiXZkG8GKyxn4Wz+4WXk0s8I=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 18, 2025 at 07:17:15AM -0400, Kent Overstreet wrote:
> On Mon, Aug 18, 2025 at 08:10:09AM +0200, Christoph Hellwig wrote:
> > Stop using the obsolete write_cache_pages and use writeback_iter
> > directly.  This basically just open codes write_cache_pages
> > without the indirect call, but there's probably ways to structure
> > the code even nicer as a follow on.
> 
> Wouldn't inlining write_cache_pages() achieve the same thing?

It might eliminate the indirect calls with the right compiler or
options, but not archieve any of the other goals, and leave us
with a helper implementing a pointless callback pattern for 1 user.

> > +
> > +	while ((folio = writeback_iter(mapping, wbc, folio, &error)))
> > +		error = __bch2_writepage(folio, wbc, data);
> > +	return error;
> > +}
> > +
> >  int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc)
> >  {
> >  	struct bch_fs *c = mapping->host->i_sb->s_fs_info;
> > @@ -663,7 +674,7 @@ int bch2_writepages(struct address_space *mapping, struct writeback_control *wbc
> >  	bch2_inode_opts_get(&w->opts, c, &to_bch_ei(mapping->host)->ei_inode);
> >  
> >  	blk_start_plug(&w->plug);
> > -	int ret = write_cache_pages(mapping, wbc, __bch2_writepage, w);
> > +	int ret = bch2_write_cache_pages(mapping, wbc, w);
> >  	if (w->io)
> >  		bch2_writepage_do_io(w);
> >  	blk_finish_plug(&w->plug);
> > -- 
> > 2.47.2
> > 
---end quoted text---

