Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 65BEAC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 09:18:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 402096B00B5; Fri,  3 Jul 2026 05:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3D9F36B00B6; Fri,  3 Jul 2026 05:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2EF626B00B7; Fri,  3 Jul 2026 05:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0BF116B00B5
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:18:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 830D61C379F
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:18:48 +0000 (UTC)
X-FDA: 84946915536.21.E72A7F5
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7B35C40009
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 09:18:46 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qb76ikLE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hGa0EAed;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QWGAH9lR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QqUHHJtx;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783070326;
	b=QhPY8wpVMbP+cMPFPgGN91Ss34zbdFFqK5MHxaI4QBEh6QhqUhoZsxopX5kqT8fpHo/Jsl
	9O2EiRXmcGdL/BdDzokD6RAhaG2iQxVd5Ei7dMdnkaQ2oJMRCrpmeQvJbW0H2IwkEuJoC1
	8XWbPVxoTkldMIToJ4x1OZ3LmtKojXY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783070326;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LzPJrNMcqTLpcp6mF9jhE1bhSF4vVcM/ftLefCKQ9eo=;
	b=4OhAZVrXGAserj+jyzK5703HCcpaO28+rzIPpiJqQxxW38LzCvJbKdXT6WtKIW8oxKFPdp
	+tOPjPfO+LDgX4GnjZcnmTxA7aWB0LYZfs3m6+VXjVQ1dPkBRT0ioM0+0RZ0FLY7cgXqEr
	SbigzxUWMMVuKNNbERDhGxsaf31WwiI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qb76ikLE;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=hGa0EAed;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=QWGAH9lR;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=QqUHHJtx;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A5DCB7625A;
	Fri,  3 Jul 2026 09:18:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070324; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LzPJrNMcqTLpcp6mF9jhE1bhSF4vVcM/ftLefCKQ9eo=;
	b=qb76ikLEvqc3965sTpHJZO3sdpd4AyY57BYuqKXKXurFsKZPZK4Dg0j3BuASvlXlwJZLzn
	N9pLXv9zs0n5vXEriq+UaAidCqAOzf2ehEXy+n+a9Am3nVf+7Az5z3yCSqQvqdk8AkjF8T
	jgc3npNOGTNtUQI+lHy3fYFBb1y0FZE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070324;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LzPJrNMcqTLpcp6mF9jhE1bhSF4vVcM/ftLefCKQ9eo=;
	b=hGa0EAedPGAIzohKnJucRQILO3/u4YVpAowe0eHC9aoiir72jLtahShO6kwVk6rNFEE4qb
	f6FbUW4dolJISTAA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1783070323; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LzPJrNMcqTLpcp6mF9jhE1bhSF4vVcM/ftLefCKQ9eo=;
	b=QWGAH9lRHpPzkfOVW9AHuIhlVfRMqmNZReZBplENOQbkpzCJGlH35wi8Vsn0+LS3PG6Hpv
	Dq5/xhonRm40UXLpLnHo+XKUALa6VijGinSGk33f+E6dRV4ohuVnd4oWhZ5HDQP0W6Gx9L
	OzxVcyTflrDA/htL38dlqKUsea+8PZk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1783070323;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=LzPJrNMcqTLpcp6mF9jhE1bhSF4vVcM/ftLefCKQ9eo=;
	b=QqUHHJtxaTqZTU0NxrvSRd6PeYBkXjJaeg68tt3kVvBxOAtBydcb25TZc7jC8MA659FXKi
	AtZ6w5hF4IUKjVAg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 45171779AA;
	Fri,  3 Jul 2026 09:18:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id p0aMDXJ+R2pBZwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 03 Jul 2026 09:18:42 +0000
Date: Fri, 3 Jul 2026 10:18:40 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Lance Yang <lance.yang@linux.dev>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	baolin.wang@linux.alibaba.com, liam@infradead.org, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, baohua@kernel.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org, 
	viro@zeniv.linux.org.uk, brauner@kernel.org, jack@suse.cz, willy@infradead.org, 
	song@kernel.org, ehagberg@janestreet.com, ziy@nvidia.com, 
	gleventhal@janestreet.com
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when
 collapsing
Message-ID: <akd-WGXQbSQtgGCo@pedro-suse.lan>
References: <20260702165409.164568-1-pfalcato@suse.de>
 <20260703051129.88453-1-lance.yang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260703051129.88453-1-lance.yang@linux.dev>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7B35C40009
X-Rspam-User: 
X-Stat-Signature: ocjhar3hsoxeki9w1ju1pne6cotx1miw
X-HE-Tag: 1783070326-371214
X-HE-Meta: U2FsdGVkX1+lOiXOE+W8hu0VUGodswYGV4AlziwDbCk0xh9m3cbUEtSyqMxIEdmeMQMPI52o5/SVcelXq9549kFnqJufTYhVVm1COKn0xXMcI5nAuIALET1YIuppNj3OuHru1ajt0k7LDCU+IyLgBNy6JrUVyGBB/dm6HuSgTLFC/2Su0QL7+dz53xEvvVdUxRPi5tAADFDFO0fuSONCJ4y/XWpJWkfY40AGGA1XsAoOJTMsNp+/GyaHy6/Gq/bSOzjnLnJ35qmHxa56Qq+HMcPtBHohFUdquUvRm1LOpJevBdLk7xFr6ACrpKU0CjavxNSXTv8aAanDPparDJXVaeYTIn+zOC0QVO/V1t4woXPymtVXbukTj7/qSX+16e1njk7btq7e3Rxzppndc4z91LLlI5feaO8s1FEYxEshZ7qHJEKbnuFz6rb8FhmDqu5E61TQ6jxZlWmeUIDK28CZFrk6sSlyvHldn0AGWEaUlyrmg4CT6HpynoRkEi3N4M5fgdtuk5vb+CWZUNM64vZ4XGYI4skrJch3RUAf/EmiWheH3NNlAheNFTuq+q2sr0OGyOvQwW2Tii5LOh4eCB5XAFAb9/uOfd05b7H2EoKrqoebss0+qYikf1D5czOVT/zSUWZS7MhKt3/h2OgzmXr23CHpEimUM663QGPi4C85c8iRN0WuWjYumBTmCMLlDrB1mnVQ7as6RZ5ri9FzvGuXk0dQwGEGSLQN0b9AqkRzY40E4y+4GD5HJtZC+Wt1Oc6JQm4sZ2h4C59qBDaUWkpftMydaCP3gYy69DK/zxRo+kLO9z+yGWxoBmkXJKQwHvWUg431pSz947Y21Zgcn81rXOG0+IGOreMfWOb/F95yZwp5/4gN7erVNH6yh2CV3V7yWfMRVKCJkAMEd/9+4zeyZnGVQTdoCBweLFWEEm2RPC/2gWnElGKXfy/e/ZmDE2gvlU1j+yU2m732VPrGZrP
 t2R/bSWr
 xz6tYlmffjSvneJtN+80ZsWhTA61zbvLTATPPb2urJVHtAbkZjwaZrdrwxVJsCQlXW6jw0lTW4tWnvam/w6PPQFkuFdID82ZLg1PcxiZghjZ3+WNKH/ugdDTK+lmjmXz7lXiFCzuQkGwq6ah7Prz8ubbrZumQgu5BHolEXCGn/z8JFGOIlhX6AYxzfw65w6npjlQffb2zhj9asQf9Yhu4ieIzBUAlBBHU8fEPVexAHfnAy4VJNLgL+KvI5J0ZUENHWm4YxpnASwwogiE8mFJWpCMEBKQ58appUv6+aPH2LJGTfd8EwCkTuKaQf0eqLNbB+MRjC9dcz/lSbEJfKbvuoWk9EdO1x7TJq0dKh/ikkigr/mDz/8xH2lOnu6hUzjwupLATo3I5wT2J6sxilasTZKLdOQXMWmuq1DzKLrqN35VYsji6Z/qXqBzQUrJqKnXjSKtZ7sGxd0t87T7Tng6BkuLkwcp+sYCRf+/sY4YDki0d/sw1G3jl9gBn8dvwKt4DvnEpnol0WGGhnog=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 03, 2026 at 01:11:29PM +0800, Lance Yang wrote:
> 
> On Thu, Jul 02, 2026 at 05:54:09PM +0100, Pedro Falcato wrote:
> >As-is, khugepaged and writable-file opening exclude each other. A file
> >cannot be open writeable and have THPs (because the filesystem is not aware
> >of them). khugepaged will never collapse file pages for files that are
> >opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
> >particular file is dropped. This is fine because nothing could've been
> >dirtied.
> >
> >However, there is an edge-case: collapse_file() might not be able to
> >coexist with concurrent writers, but it can coexist with dirty folios
> >(from previous writers). Therefore, the following can happen:
> >
> >open(file, O_RDWR)
> >write(file)
> >close(file)
> >madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
> >open(file, O_RDWR)
> > nr_thps > 0
> >  truncate_inode_pages()
> >    /* THPs are cleared out, but so are the dirty folios */
> >
> >When this edge-case happens, there is data loss, as the dirty folios are
> >fully discarded.
> 
> Well spotted, thanks!

Well, Gregg deserves a lot of the credit :)

> 
> >
> >Fix it by fully writing back the page cache (and waiting) when collapsing
> >file THPs. Doing so provides the guarantee that no dirty folio will be
> >observed while there are active THPs. To fully ensure this is safe, the
> >invalidate_lock needs to be held while doing the writeout, so that
> >do_dentry_open()'s page cache truncation excludes this write-and-wait.
> >
> >Cc: stable@vger.kernel.org
> >Cc: Alexander Viro <viro@zeniv.linux.org.uk>
> >Cc: Christian Brauner <brauner@kernel.org>
> >Cc: Jan Kara <jack@suse.cz>
> >Cc: Matthew Wilcox <willy@infradead.org>
> >Cc: Song Liu <song@kernel.org>
> >Cc: Eric Hagberg <ehagberg@janestreet.com>
> >Cc: Zi Yan <ziy@nvidia.com>
> >Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
> >Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
> >Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
> >Tested-by: Zi Yan <ziy@nvidia.com>
> >Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> >---
> 
> Tested on v7.1.2. I no longer see the data loss with this patch applied.
> 
> Tested-by: Lance Yang <lance.yang@linux.dev>

Thanks!

-- 
Pedro

