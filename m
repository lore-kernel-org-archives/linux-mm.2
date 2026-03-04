Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B5B99EF8FE7
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 13:43:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E90286B00A8; Wed,  4 Mar 2026 08:43:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5A9C6B009E; Wed,  4 Mar 2026 08:43:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D4FE16B00AA; Wed,  4 Mar 2026 08:43:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BB17C6B009F
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 08:43:18 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 7B7091C7E1
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 13:43:18 +0000 (UTC)
X-FDA: 84508497276.27.B43E326
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf03.hostedemail.com (Postfix) with ESMTP id 6D34620013;
	Wed,  4 Mar 2026 13:43:16 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="jqgMF/Fx";
	spf=none (imf03.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772631796;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CAfZkHMN+opoY06dpw99BgOAeytYWPwk19vIdsy8brk=;
	b=mXr/yv8BELyKc6LWfCdil2ULIo2BsfSLCh2sJ/lAiuI3xyne8kEN2Gy6z/MyrSCuPykakg
	mFGuQ/59iGzUKvi42DIwWq7d0LJi4DYRWbo1fwiKhigsyOTsSPFgvlJBLBr0UxySOhkTlf
	BhnKh/8m77ORGjb886TWJkFxFobyKjk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b="jqgMF/Fx";
	spf=none (imf03.hostedemail.com: domain of BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+31edd8e8777d9099d78b+8228+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772631796; a=rsa-sha256;
	cv=none;
	b=X8C7hRGe2gcoRjdUDxaUsXK705+hK2ltKGrqtmfDT5R3/wf7TN/N5Jkn/Opl6WE/RX9Irf
	4N9ZXi76o5HbJsdasmq92MKwWy6AYpAkGP+hzSGqJ2HZvLeijndp9jve/++jqVrhMZ9A0D
	xi+VNRzVLblVmhGV7WBxWK+tUd+NOPc=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=CAfZkHMN+opoY06dpw99BgOAeytYWPwk19vIdsy8brk=; b=jqgMF/FxZOpA38UVzfY0NWo4Zg
	sORLBq4hswh8Bi/sbPv8wVl1TF/C5CWVQq0d/GclUXtWJ8SxusjddFSJqZOBugK0v1eLrlyTb6apM
	FrUYwc9ixO6EOXF9Tnkxflv1JLt1LlnXe7kUDq5EXEbNLYIC5JsAoL/6WpqMeH0DR8UtdY1QjvfSP
	cez/cwtSqhV/tMuSQLuzyPpXBWGyb5f39mlZDCwuCajwE1v3tNf/wvQkrOmZOfdKRHZCIxQmas09H
	//LiCBKeNrdKGv6Seo8c8QG2ovuVZHaAqDfZRbE8yBgrG0wYbtI/3TE3EOwLo0V/cB7AZosyRCKhk
	d+bk953Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vxmVL-0000000HGjC-2Abl;
	Wed, 04 Mar 2026 13:43:11 +0000
Date: Wed, 4 Mar 2026 05:43:11 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jan Kara <jack@suse.cz>
Cc: linux-fsdevel@vger.kernel.org, Christian Brauner <brauner@kernel.org>,
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org,
	Ted Tso <tytso@mit.edu>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	David Sterba <dsterba@suse.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 32/32] fs: Drop i_private_list from address_space
Message-ID: <aag2777h5ai2WQKf@infradead.org>
References: <20260303101717.27224-1-jack@suse.cz>
 <20260303103406.4355-64-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260303103406.4355-64-jack@suse.cz>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: pxa9dgrktnjkjy5pjdwce5ru6hroo679
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 6D34620013
X-HE-Tag: 1772631796-159914
X-HE-Meta: U2FsdGVkX18NjR3Gh9Df9XL/xaIABxm3KaCDBkit6b6L5T7tR+83D4XaN/kCswgBiZF92xyyr0qeB5Gi/3awij1RnImT3kIYsZSKFSocU6EFAb2ZmXJD4bXwBeIyxI7FtJGKdHP+LjBZnnmedQMvl+ZKj9DxOhoqdldziO4RsR4SSCXaWr0LUNJWE6r0/ksuL8ASV5/xquNT8m8hJLgfE38JGmXMHt/mhZ6V3Rx0kRGi0/nLRoeOKktgUlFB75orJN8d7Dp5F/lZiSwrXia3JIPt20DVmRg8KvGhUTz8+MSC1jlv+0FVdkDz8Xf1moiJ/qeV2tyVxkYi+DZvnCAgH2RCK8heTH9m2IMav2KRU7aGnkzUY+CfsO3dcRGl1FJ/EeCTOy0aa8euYzTMLhtbG1WbT3HSVgyBr6+GrcNkaPTgPQP0ctwuS5FmfUXOPQqpo8nBh83D1LGohBKNFh8LNDLNM46qW+Tvv3qaZDi7j34McQnxqpVBV0cLPuPWOMeEtytjQ9FSGcXOjeX0SPd4lo83h+f4bakCc62pbXxSZvg9h5yi4EDv9oRC9WKM3QWSBjux8SYnl1UQ/3F0jQ+po/JtyPEBL8A//mIrJmpCELwSsx9F18Sc6Cd7FO/4Zo5DMqsepfkWue6vKcIyyMADX2ExvQpZJF5sKhGLavdvUtkb8a3vw5r/koV6EAZjlZsdMn10ireqykTWRBES8lBkFMP92n23W7xATE4XjfyE1TOimSU8yM4DnZz2phphSTohvFckFOLGXNQs0LoRnVebz5cKsClYXn02dPNdPuTSPU+u3MB66Tvh0oFaa0viLn2bzFcLbUsAgOMZ4xqfZBtFdH0986TIF9T9/kUgB0Hu/+0+Pksm+rIHjYXRZGq/dBjpFr1z7Tq2/4AG8QA9jyzKaNrd3nSnAU0jnW1PRKYvNT9D8PtpHk2eqTPerdg+6OTuYe5f0hKI7WXXFn9Oa6v
 LNC4tA3F
 EyTF9KBiAGRJM6Zb8/62rE2lsDNEGa9tLaTMXqoummXImRo3CbOBdzsQOSGnWtDa1O82CQ31iHPBZSn06rvCoJ8/HTsdxOGfyRcqLYynjiHYLLy588nU0bqehW4pobA4zNa5RkTARb6kSA7/WXrh3hVPR6onAukiRUk09T6RJFsoiQw73yK9n6mFdPtlUhsCEBpBVlBjj3+/C5GO3HvNZdpuMu+nzoAkRbU3p0U1H6tbXx8dLP+HXf5RDrn3z06/OT36JCDLq2nUy/HS8ichIl74nq+wZ21XbssDcGW0wtmIYTnFNRpHrhMk5Sp0DpGXGzH4R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Mar 03, 2026 at 11:34:21AM +0100, Jan Kara wrote:
> Nobody is using i_private_list anymore. Remove it.

Thanks.  If my math isn't off, this should allow us to fit an extra inode
per slab for xfs for typical configurations.


