Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 93989F4613D
	for <linux-mm@archiver.kernel.org>; Tue, 24 Mar 2026 12:51:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E4ACD6B008C; Tue, 24 Mar 2026 08:51:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD2ED6B0098; Tue, 24 Mar 2026 08:51:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C9AE06B0096; Tue, 24 Mar 2026 08:51:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B1C246B0095
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 08:51:22 -0400 (EDT)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7ACC2140A5A
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:51:22 +0000 (UTC)
X-FDA: 84580942404.26.7E69942
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf17.hostedemail.com (Postfix) with ESMTP id 09CC940006
	for <linux-mm@kvack.org>; Tue, 24 Mar 2026 12:51:19 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CkXM2qqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lS/AAT+a";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CkXM2qqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lS/AAT+a";
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774356680;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=jHi0RMNvMqKGUu/MNnRna/MemtoEC6Xns7mFbNAVZ7la8AIrtrke6fJdXpNQbm5pyuPRQV
	/t0mc6h/PY5nJ8gk0/HKgaTdmfw1aaCHczE3jA71RkxUaEfjH5Teru7OiMreLgrbAuJLM2
	gvht1ql/rsFB6b9/dxkFxWugyAXxEHE=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774356680; a=rsa-sha256;
	cv=none;
	b=1J6IF1DhxEgnuQfn5ery/A8LiNZdFnFWjkv14Udik7FcxiA4f0cRJlEACGDM/kC+ENjseK
	aiu3HR5d8rfsIUpL5i0gnxZPOOzsdncoIqhizX5nVNEDL/FQUzf100Eqrhd3J6nWQy7Muw
	QsgyvF1JggasP8qTy4w5N0KbLcKVaIo=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CkXM2qqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lS/AAT+a";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=CkXM2qqf;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="lS/AAT+a";
	spf=pass (imf17.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 75CA74D4E6;
	Tue, 24 Mar 2026 12:51:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774356678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=CkXM2qqfqoQoJPfy5qQoPuU0n2jdb6wAEMMNP74JiXs3pb0gw+ZWdZLUv7fOIMKwbm8wbI
	4tMsvX1TIn9EO1e7hHwjbv99Zrc4viJXRMMEkfh0fXD+m1rkUyBSVNWI1E49Ypalm2v2pv
	VmnlXOZJV24RIXdcyXCAksUa5wTEynU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774356678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=lS/AAT+ag7CxAS5QsLazid/zTAJYBU8bEnu0S3GpJCClX7OfBrY45XPrARrzgHDVGJOX8S
	EA7+x2UkU1LNo5AQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774356678; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=CkXM2qqfqoQoJPfy5qQoPuU0n2jdb6wAEMMNP74JiXs3pb0gw+ZWdZLUv7fOIMKwbm8wbI
	4tMsvX1TIn9EO1e7hHwjbv99Zrc4viJXRMMEkfh0fXD+m1rkUyBSVNWI1E49Ypalm2v2pv
	VmnlXOZJV24RIXdcyXCAksUa5wTEynU=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774356678;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=HRpxd9RTXL576aPfqqDyMly65x4HwOi/VWSI2D8gaYg=;
	b=lS/AAT+ag7CxAS5QsLazid/zTAJYBU8bEnu0S3GpJCClX7OfBrY45XPrARrzgHDVGJOX8S
	EA7+x2UkU1LNo5AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 648DF43E48;
	Tue, 24 Mar 2026 12:51:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 60WAGMaIwmkoAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 12:51:18 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 26FB3A0B32; Tue, 24 Mar 2026 13:51:18 +0100 (CET)
Date: Tue, 24 Mar 2026 13:51:18 +0100
From: Jan Kara <jack@suse.cz>
To: Christoph Hellwig <hch@infradead.org>
Cc: Jan Kara <jack@suse.cz>, linux-fsdevel@vger.kernel.org, 
	linux-block@vger.kernel.org, Christian Brauner <brauner@kernel.org>, 
	Al Viro <viro@zeniv.linux.org.uk>, linux-ext4@vger.kernel.org, Ted Tso <tytso@mit.edu>, 
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>, David Sterba <dsterba@suse.com>, 
	OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>, Muchun Song <muchun.song@linux.dev>, 
	Oscar Salvador <osalvador@suse.de>, David Hildenbrand <david@kernel.org>, linux-mm@kvack.org, 
	linux-aio@kvack.org, Benjamin LaHaise <bcrl@kvack.org>
Subject: Re: [PATCH 20/41] fs: Ignore inode metadata buffers in
 inode_lru_isolate()
Message-ID: <flb3si2jxjg4gy7beqxr3zt3tvq74msftee5ewmwgpd77vqj5r@h5rqgjuws3zr>
References: <20260320131728.6449-1-jack@suse.cz>
 <20260320134100.20731-61-jack@suse.cz>
 <acIkOmat4Y_M2SUC@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <acIkOmat4Y_M2SUC@infradead.org>
X-Rspamd-Server: rspam12
X-Stat-Signature: qezu659q6k68c7sqixi7h5unady3jqbo
X-Rspamd-Queue-Id: 09CC940006
X-Rspam-User: 
X-HE-Tag: 1774356679-697948
X-HE-Meta: U2FsdGVkX19Ij7epo1ntMDQvKE3nnq1qML9um85nhANgknCkDKLjyXSNFRps7RDWdbIXUA7mAujya0vEcNGdDKPOXdszN2MD7f5Qdi4VoGtoB2mAWYxYB8dMZ6LuU2OuENZVwrLJgaxfq5/FjBnciGsj7jYPg41FlT1JYt1HpppoZ44tLyCJSUiPthaAGUYRxRIUEFWRwXXPQXn5ASIULo/wW/QxknePdbrBhfE3k9b67eIX03dsjlusEFXnwza4qVQJGoudWVZ1jioaJhYHdSsE0ygz/tDqTBO0TbjtI+YSgLrDiVC58efszXNIgKBpOmV98LR4tamfEWgou6vhP4ztLK5iX+5KNkiWt6HPqqXjgXg86OFihcB1R9UYjfztPZ/icczHGdjqW6QL2bunR/IEqwDJruVJ4LcjQR9s98GrKiq38TyNcFKB1x7uhE1K8ESOeQQ5tmWcIJDkJw8g+dqzh+I1b+6Nhvt4bBFuw0Kmn4dwPHnOealEJlQMvE0OeFuL+/XlUHzxdj9xYK1JyswwdcP7TYgnK9SQ0AclAoFkBhDpbTZDfzecihceriJ0MfhbhTMp05yeqBbHiW6dVctkM86kkfDoN2cwJOiKHRa2r4ytkY27+M+PfyyR4eNqOgknhnkdolfP0R8ZkdaB+mQrzIrOjimI4Ad/7uce3svU5e3ratmQfVFQX3zDYL+sYSQhvlDb93+lGUPxuieD6drbavqe7CfbYbjMDDwyyoFVSDj/9L6E05fahTxmVV3e0x3pT92k1kIQ6QH3VoCyMVkZ7VN71esliwNmUUeyVO9L2JZ6EaBh9Rupnvyx5do9DdYdJgOid7W6pJxs/frNQ0pPbByAEl6WYeTsxlPYLAigtOP9i4z070aKmR4kUb8zi4DMg7asNU88adZv+2qeJBTyBqntYm+b/0OEIhGVa+EMQHP0/cMqaZLcvLcTSsdZUHTh1ySsZOxrMsSPLLi
 HlhFGtVK
 E+SaAwzr6+yycsBXvyL80s9kmbM+xR+iB9sFNHS+aiUqpzsBZAP0jk4dCN1EptgJoKGq1rLLcExrq/zZxrWbv5VH3x23zw2tEnFg04JraVzbvsiLiHn8vchyPGih4usvBXTitujHUnJ/uYF7oyJK3sQ5Qzo2dzFj4gye6qV1vqzEsq+R0JCgseiPi4Ou1rrwItRMDlqkmfx7pdtEnFc8LFJQEQhUSuyi+Oz4bpnAIV0ivuqgJMPktdiqp5zjATOynFi42O3CEIUY6puGvGYeee3DDourcU+iB84Xj5yXqtQDcpkXv/ibwUcZ5HTLUw3pXyELjpdlzDQoOGkwlS3ug307g6QcVa9JsnzuJOCjq2s0mg5vUgUksqqYlg2bMTI5BOswpDz38bI4DINzfbJzKTzGfD3egqGmUazWy0vO5l1XGzq1xQAaBfUjaiMKc/YSi4PenOzu1XFKP+Ss=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon 23-03-26 22:42:18, Christoph Hellwig wrote:
> On Fri, Mar 20, 2026 at 02:41:15PM +0100, Jan Kara wrote:
> > There are only a few filesystems that use generic tracking of inode
> > metadata buffer heads. As such it is mostly pointless to verify such
> > attached buffer heads during inode reclaim. Drop the handling from
> > inode_lru_isolate().
> 
> But the code isn't just verifying (which to me implies debug code),
> but doing actual work to remove the buffers.  This does look like a
> behavior change to me, buf it is not due to previous patches or
> because it was dead code, it would help greatly to explain that here.

Right, I've rewritten the changelog to explain things better:

There are only a few filesystems that use generic tracking of inode
metadata buffer heads. As such the logic to reclaim tracked metadata 
buffer heads in inode_lru_isolate() doesn't bring a benefit big enough 
to justify intertwining of inode reclaim and metadata buffer head
tracking. Just treat tracked metadata buffer heads as any other metadata
filesystem has to properly clean up on inode eviction and stop handling
it in inode_lru_isolate(). As a result filesystems using generic
tracking of metadata buffer heads may now see dirty metadata buffers in
their .evict methods more often which can slow down inode reclaim but
given these filesystems aren't used in performance demanding setups we
should be fine.

							Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

