Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC726C43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 05:11:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 42BBB6B00C1; Fri,  3 Jul 2026 01:11:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3DD176B00C2; Fri,  3 Jul 2026 01:11:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CB696B00C7; Fri,  3 Jul 2026 01:11:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 002706B00C1
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 01:11:51 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5C404168699
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:11:51 +0000 (UTC)
X-FDA: 84946293222.12.E14CB74
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id C62D5C0002
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 05:11:48 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mt3Z6RcJ;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783055509;
	b=a+zwa9W7jHgBgRd1BkViopUhZb6BiEddLmnf13t0IoKWuXTdyfkXgkJVib2t0Glk2/Aw6N
	WXnVFpqDJ9YERDnQ6OULmnXWPoRrCv5c7d3SzeLccUmpK+Y381e2YmMG/8sbN/z/aZNRWR
	wicKFVkmszOxRdcRNba2N2PcrhUPqzE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783055509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TclDFaPZdaXfZinZztmQXDY2osmC9ohL82aKjMqnljA=;
	b=tf3OvgQDQazfLW1uvnlWF3iaJ5mG/8f5OedpK8zpmfp0xtuyhqA4nD5K+EAZ46pd1MaGok
	DZ+3V8F1Jyfu0/J3oN6Y6Qmce3gZuXSCwZO2rWFUDdiT6yjQbqGV8ROImGXx55TOM9jC7W
	ylyLno+PBkiFjND1hLwzUOSuhpWYSBc=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=mt3Z6RcJ;
	spf=pass (imf10.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783055506;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=TclDFaPZdaXfZinZztmQXDY2osmC9ohL82aKjMqnljA=;
	b=mt3Z6RcJAbFH5qjmNSVJr9og3cANnog5yCm8KOSikIlNWnWUdlzBYYJRAxJJYQPrB9K2v2
	t/yidQofXCp8zmiyWOyphesT3hGz9lnz5aI/EeO8GKygjhDt0FxJZTf68vKAwDGvFvHdqj
	xkCSEJlXdSaVC7mi91P395B1Vyr2Als=
From: Lance Yang <lance.yang@linux.dev>
To: pfalcato@suse.de
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	lance.yang@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	stable@vger.kernel.org,
	viro@zeniv.linux.org.uk,
	brauner@kernel.org,
	jack@suse.cz,
	willy@infradead.org,
	song@kernel.org,
	ehagberg@janestreet.com,
	ziy@nvidia.com,
	gleventhal@janestreet.com
Subject: Re: [PATCH stable] mm/khugepaged: write all dirty file folios when collapsing
Date: Fri,  3 Jul 2026 13:11:29 +0800
Message-Id: <20260703051129.88453-1-lance.yang@linux.dev>
In-Reply-To: <20260702165409.164568-1-pfalcato@suse.de>
References: <20260702165409.164568-1-pfalcato@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C62D5C0002
X-Stat-Signature: doie9oh1jc35764hcdzy6wdfto6tzx9s
X-Rspam-User: 
X-HE-Tag: 1783055508-401633
X-HE-Meta: U2FsdGVkX18ee6yhp+YMejLTDraFK8or19t0ccgFpiW3ahPBCbuAz2LZ014NdBVPz5Tkx11QpN7iAYWhMlrNf4yQYuRjyhIxRGcD2i+CGB8yxLTjqxJz+/ksSUC31s7GTwlbWX6HHd8rW/GNXK6oduTdRmXcB9COimsNcw1eLaP98qHV2rmQk/Ub7e0wsUwBPtiiGUGaxhHW39VJjk8dwDONvIIgzEt2LOPnnDRQ2CzlneY3EdEA1IOgN4AdV5+OpgH1qrrWJ27qUT6C8hE2BYAqePPmSa7lmlGrcZBw6vhyC7i2az6UG2WfxoVzsf4NuK9xPcrOZ6QOqQyd8M7tj0kflySvNTukYNwCuHzMtl1wgaVwUq4zjYYPAGMrtwWvlKt12kOmbfLJuZBfkuQOx6Z7CkcJc37ZLK29T5/EaaA+TC4UeZn7uqTATPSRj+1fDYEAaMhKPjVq5PbuW/8dLGWqw4annTCRFskoA99WR2j9ShN0eHXgm4V8x5DKEexpqHOma/Sjy9rMSeLrAr8PrcmG2RGN34KFxbBujm3RRkvaxDV0hA9gHCh6ToWHfdo3Pv59c5RqaW0ncEdYs8vmgkaD8XV40TMHDo0f/1RbzCnG5uJKx4RlNct/fLoY857f959LwZr34AvMTaWPwnmpUJ3wR5/HZaLMBQHtCz+ezxkaEZfCr5YidUz2/vMaF+azg3LOn8aTAnevJfAcFC/M9z7EzIzQOJreQD8yXG24xrOU29LwzKKFLYL6Anq9VWyOdQ7yyi226tWnPS0eHTB8+k2rDkZGWI63ErlZYaUNHLPuB3FOckuKDTl21S9FfNkTr+M5RVNLf+HK6lbVcu/PY4pAUsg2i6lE3+Wv27UfTrGjP3zhDHu5PU8JvSVo7LNNa5FjqD0NEhwicdsC/a3ZLLSUVVitrg9plFwThcZ+6ZllDFF8L6ohqKFR96cFW43hhGUn3tKAkDhGXoThlPu
 dxx1AnsG
 GULXefNxlWTlQi110eai4BJf0pDW00xLz3QSe3Z4Xpf4QJeteQajRyMaU7XN1blL1TsxD6hEA8WwWw5iLeiloOQqeRR9SUjiXbiAEmJFK2lNUmaKESoXMDdFSOxgTJ2LFJ5Erq0zxxsprKHQOu4tIWsPLi5saoqWsxjtxuQQ/4lwy05NSM0nSBFPLgw2yPQKEaUlINUyXGG6dPjlSDbSeXJl8sVcOUo4mSV30TMqB/NJxXYPllicAD15C8CA1XwXvPLl6v7mIVd/5+Y+7gYaIrrvOPegBkJ+4wgfwiSJ490JV4SX82KmSoSH1WvfaxL7AKkIH834AxbC3PClDxT4YCq1g7rfzt/synHZHfWu8zfVJIJXtgt25myaYpGIQBYZW9cERXm7NToqWDvxVC65EJWCv0lqzCyFzwVBcZ0g+gFpbUPsLMBfJY2v84R6Os2vV54j1lvWMLXq8Kcs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Thu, Jul 02, 2026 at 05:54:09PM +0100, Pedro Falcato wrote:
>As-is, khugepaged and writable-file opening exclude each other. A file
>cannot be open writeable and have THPs (because the filesystem is not aware
>of them). khugepaged will never collapse file pages for files that are
>opened writeable. On an open(O_RDWR/O_WRONLY), the page cache for that
>particular file is dropped. This is fine because nothing could've been
>dirtied.
>
>However, there is an edge-case: collapse_file() might not be able to
>coexist with concurrent writers, but it can coexist with dirty folios
>(from previous writers). Therefore, the following can happen:
>
>open(file, O_RDWR)
>write(file)
>close(file)
>madvise(file_mapping, MADV_COLLAPSE, some non-dirty range)
>open(file, O_RDWR)
> nr_thps > 0
>  truncate_inode_pages()
>    /* THPs are cleared out, but so are the dirty folios */
>
>When this edge-case happens, there is data loss, as the dirty folios are
>fully discarded.

Well spotted, thanks!

>
>Fix it by fully writing back the page cache (and waiting) when collapsing
>file THPs. Doing so provides the guarantee that no dirty folio will be
>observed while there are active THPs. To fully ensure this is safe, the
>invalidate_lock needs to be held while doing the writeout, so that
>do_dentry_open()'s page cache truncation excludes this write-and-wait.
>
>Cc: stable@vger.kernel.org
>Cc: Alexander Viro <viro@zeniv.linux.org.uk>
>Cc: Christian Brauner <brauner@kernel.org>
>Cc: Jan Kara <jack@suse.cz>
>Cc: Matthew Wilcox <willy@infradead.org>
>Cc: Song Liu <song@kernel.org>
>Cc: Eric Hagberg <ehagberg@janestreet.com>
>Cc: Zi Yan <ziy@nvidia.com>
>Fixes: 99cb0dbd47a1 ("mm,thp: add read-only THP support for (non-shmem) FS")
>Reported-by: Gregg Leventhal <gleventhal@janestreet.com>
>Closes: https://lore.kernel.org/linux-mm/CAFN_u7H_0ECF3jixP=T=U7AH5=Q3wQNvJMo8an3VqUDMerQfUw@mail.gmail.com/
>Tested-by: Zi Yan <ziy@nvidia.com>
>Signed-off-by: Pedro Falcato <pfalcato@suse.de>
>---

Tested on v7.1.2. I no longer see the data loss with this patch applied.

Tested-by: Lance Yang <lance.yang@linux.dev>

