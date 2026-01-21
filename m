Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E5D0CC44501
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 09:18:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D396B0088; Wed, 21 Jan 2026 04:18:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4248D6B0089; Wed, 21 Jan 2026 04:18:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 326756B008A; Wed, 21 Jan 2026 04:18:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 2413C6B0088
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 04:18:00 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A73381AF9D9
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:17:59 +0000 (UTC)
X-FDA: 84355419078.02.C6159C1
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf26.hostedemail.com (Postfix) with ESMTP id 0D4E4140007
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 09:17:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=24wzxAEw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768987078;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pO5cDfr4usmkTORPaRFpCQPiJkEaTR8DriiJ39ztdjg=;
	b=2rvnx7EwazgoD0HjvwncAEH8S3eSsuxw2gHWXEneOYw2/KY7dNJFSWXjgTQrFKsUxG0MlN
	J+0VwPoDm0enxKzKYTsJ7ibBjl1fBZef8P6oUJHElNieeDvs62dn2BuvqDXm76YmKvWrxt
	o3MhMuqFfOV7GUE7gA8/n5nBntlVul4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768987078; a=rsa-sha256;
	cv=none;
	b=B+cc2lvIp0+xJJELXVbkTgFiOH7wavTTJUFB3+FRjhdt+pSoXtdTG2O1wlMdKiTKplkADW
	iWPZToHgaIA4CAFSuH/iv07ZUZ8CVjl7Zk7rjcV1Nx+HIs7HlUdpr65JC9Yokb4BSlJIuF
	0WAC681vUavpCfj3oYt6f6t3pEnznAU=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=24wzxAEw;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+bcc91a9d4ebb8e7eb2a7+8186+infradead.org+hch@bombadil.srs.infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=pO5cDfr4usmkTORPaRFpCQPiJkEaTR8DriiJ39ztdjg=; b=24wzxAEwPXJTolgvO6OimnOF/e
	PCCP7ApFllcFgYK9BV6IZuc8L0kvbBATJY98kG3HNuTveRZoEzUleITitYeQ1sEnQgip/caZsU5xv
	dJdwK+gChgUqQEbAxiKEXxp911m3G5JIHc4fo/9rWfbz2jLa0Cow1fhStf81u9dw3U+A3E/fWl28t
	IuElfVoUimZYZqST6urDi+5jYot79IklyhhyH0P0aFel75wmUkQR3e1/AQ/ca6YocY6w0qefM0tUe
	5G43HMgvqejRLyJPnuAu6NAaUiRuEcAm8fydlJcGpgj1S49T83E8l9dWUEwKUQtDLp4AvWyrlvm1Z
	9pGZFeLQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1viULN-00000005Aph-3NRp;
	Wed, 21 Jan 2026 09:17:41 +0000
Date: Wed, 21 Jan 2026 01:17:41 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jeff Layton <jlayton@kernel.org>
Cc: Christoph Hellwig <hch@infradead.org>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Chuck Lever <chuck.lever@oracle.com>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Amir Goldstein <amir73il@gmail.com>,
	Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>, Jan Kara <jack@suse.com>,
	Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>,
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <lihongbo22@huawei.com>,
	Chunhai Guo <guochunhai@vivo.com>, Carlos Maiolino <cem@kernel.org>,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>, Chris Mason <clm@fb.com>,
	David Sterba <dsterba@suse.com>,
	Luis de Bethencourt <luisbg@kernel.org>,
	Salah Triki <salah.triki@gmail.com>,
	Phillip Lougher <phillip@squashfs.org.uk>,
	Steve French <sfrench@samba.org>,
	Paulo Alcantara <pc@manguebit.org>,
	Ronnie Sahlberg <ronniesahlberg@gmail.com>,
	Shyam Prasad N <sprasad@microsoft.com>,
	Bharath SM <bharathsm@microsoft.com>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Mike Marshall <hubcap@omnibond.com>,
	Martin Brandenburg <martin@omnibond.com>,
	Mark Fasheh <mark@fasheh.com>, Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>, Dave Kleikamp <shaggy@kernel.org>,
	David Woodhouse <dwmw2@infradead.org>,
	Richard Weinberger <richard@nod.at>, Jan Kara <jack@suse.cz>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>,
	Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Corbet <corbet@lwn.net>,
	David Laight <david.laight.linux@gmail.com>,
	Dave Chinner <david@fromorbit.com>, linux-nfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-ext4@vger.kernel.org,
	linux-erofs@lists.ozlabs.org, linux-xfs@vger.kernel.org,
	ceph-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-cifs@vger.kernel.org, samba-technical@lists.samba.org,
	linux-unionfs@vger.kernel.org, devel@lists.orangefs.org,
	ocfs2-devel@lists.linux.dev, ntfs3@lists.linux.dev,
	linux-nilfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-mtd@lists.infradead.org, gfs2@lists.linux.dev,
	linux-f2fs-devel@lists.sourceforge.net, linux-doc@vger.kernel.org
Subject: Re: [PATCH v2 01/31] Documentation: document EXPORT_OP_NOLOCKS
Message-ID: <aXCZtS2_A_GCvcQ6@infradead.org>
References: <20260119-exportfs-nfsd-v2-0-d93368f903bd@kernel.org>
 <20260119-exportfs-nfsd-v2-1-d93368f903bd@kernel.org>
 <aW8yV6v8ZDiynOUm@infradead.org>
 <9b64bed72e43d0bf24e9b1e3bc770c4a87082762.camel@kernel.org>
 <707f08e114bf603caf7de020bb630d5477e86bca.camel@kernel.org>
 <2ed97731c54ef130ea58861a91c80dacd785de9a.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2ed97731c54ef130ea58861a91c80dacd785de9a.camel@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Stat-Signature: hwesb4d5aej9cad4eg364s4c873nyj6t
X-Rspamd-Queue-Id: 0D4E4140007
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1768987077-280756
X-HE-Meta: U2FsdGVkX1/t0IeP0Wp+oT+M/Xcy3/wurOzUKnAu2qYrbkW2M9QpJLdzSDrSgVWl69zMY5jRo0VvAwbekfTx24hvMyUvSgqbhPqQPGSOquUvEZ4NRvpRdxmDDVI/IGMLzZVPjykbQ93GC4LbpRSZw9fRFXuysXggg6ldNVtWfApZ9BwbPfJSsZ+gLn4e8Rm8+wrjCcTyDMF1Dz97nbkdjkyikQuEONpi5y4ik7BipIFtcJX94qYCxMxRBvGIxO7qdAETZ5gHR+s7rTITZtZPE/YEA2QqBnk85FcgxNXVf6bzanHQn7oyoYIbe8KU9mcmm78Eo5kmKdON1CF9jYp8c8DE7ZxV4mkB7MLf4/HSWIR7JrPYy6MxyIRQraHcXG2hBvEfTl4swt20X2C+8xlcRs2JzJVJLzj3BzYaJxwp0qK3knxbrCME+cx18/A+9wkrZPq0FaZ/LDwBB0EUMWlV6MYG3nFP24amiWOOpZTugZuqa4BbC/1Jkhy+f2Olma9MToSg8KAxb/eMuWKTiGCGCOyy2CZH+Lru7ObHB3Fuj4aBg6iPb4off7x0bcpLYYFf5VOcFIC7IO+HK8o2+M0e5quC0fuywRYhiBVpM8RehLg1rju741GDfuwzn4GOE43mLzIcoaIt2u2RtDf1hDWICHQomFG1hHOW1VuWwrx0hyR/iqQiT4YsPFnQKVvpWoGmt/+eF6ggKVtqxtXGGSbBArltQHEWnT7lLXXmE/+WWvU+CTtEldJMA8WNiFrHOVvEdjodprftV5O6OfpY+TRiggKUu0pID/xHh2GBEcYfeQgvMahdhyWh8eaAk7lRfZR+VDSpXKfMKTJL9vEEEtTAbRLnz3pPVyNqj1W4ncIHZrFUVYrzz6DkNyvbW4i+dkbgDovbgw3dgPlOR0oGdAu6fm7esjMsUyKc3DVXGgX+tm4BmC/aH70zBIrqSYJ0dJFzOcOoGHcsIn+amyH1DRX
 99x9LyBc
 CDm7Vs8/1VUI6RnrHQUWV4InM4wNJyElgChiqObemmNGu6B+Oq0dqRsnZLecXyHyfPtR6Xd+FUF4plazKefmJvLTuimCUt03UvtkRV1XsZcC7N0fv4Rf90Gl80sprwos/Sm54eaXbUAf9nC89DoZ2+biIZ/66lKIg5/5npu9QEEpGbZzNwne6qBjjPJCzNahwh6aUpoWw0EaDCIrvpYdIz7jkDo+D+k55SU1vwlbrhttvhdqz6G+WE255ahJRkDmsP60KWaEmcDasKIwAGWJgSVwanbLY6CE+VaGt+0dBgSwTp+daReWl5+8qsDYqy7DgTtWWspkgRy9uSSDtXOZXKZFCIeZUKYot3XyDbfa4Jrv/EvZiCJ0LVdlTz60SqJmFQoTtJtdsfLfYXQ1DHrSPtt2GbAZ9T6A+JvA+xkmWb4W4w04TlWR25+6pvtgjjMEUHbLMJn8KV1EXaRlZoOsUvNE6yRYqQfj0khMpT+DZE/rPLn4jS/CmNHE0XxRsTfDYR0nhpXm2Ikx0BM1tAxXEMCcKTBXiPwmOHtbCtUpHSvppQj6MddYOh7qttkIwXNAne2G0CWoSnMj9YGXbKzFUm2XTKWYPIfXrnxcp5pN+IY98d2n0YusfQL31dA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 20, 2026 at 09:35:48AM -0500, Jeff Layton wrote:
> Even better, I think?

This sounds great, thanks!


