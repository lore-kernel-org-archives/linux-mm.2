Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 70ED8CD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 17:33:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 973C46B0486; Mon,  1 Jun 2026 13:33:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD666B0487; Mon,  1 Jun 2026 13:33:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C5976B0488; Mon,  1 Jun 2026 13:33:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 68D756B0486
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 13:33:32 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 0BD80A017C
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:33:32 +0000 (UTC)
X-FDA: 84832040664.12.B7FC2BD
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf30.hostedemail.com (Postfix) with ESMTP id 28B3F80004
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 17:33:29 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=C4F2CJUG;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780335210;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UIq0QwS9m8Vn34cqT2JX2YbbXgMu17lIdfl6g487i/A=;
	b=0LSCWy89jxyFFHDYmXP7FNuCnrgP0y6qFMmAIZmcAIJ0rcjk5Xns024BllolZevBgV56sh
	JmX8Z38EToUoan7mSmvr097I/kYegYwv86YNkjlc7JIn7VC8bL5EOFkuRax8Vn2BqSHoO0
	tY6y4D3xqcmZT1VG4X5kLd4PoPOhpQo=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=C4F2CJUG;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf30.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780335210;
	b=FdTpiiaIHcjtYZlgGuhcoR74vE2N9MgtbuZ/3rWMmzhbnWxJfsAI/6wxMlZqDEwhoNxObs
	UczglD3t9Rnv/hwzIUNxJ6dJUA8EBFB451TDwmyHDtt0gg6rT7IcUmDHj8Zos1AdKY+MKy
	N/UQQ7r5wUlKKAW04Rqk42NXFmu4zOM=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=UIq0QwS9m8Vn34cqT2JX2YbbXgMu17lIdfl6g487i/A=; b=C4F2CJUGwfl5xKazpWoseKj1wE
	WRgOlgnpACsA11o9vsmsB1IEgIxOgcMlpETmH2q+Pkmy5QKe6KOUTqNF+mzjFAZmW6fSabyetV2cW
	sg4PJwBvnYadtSQUsssgLJfv23FCBmBzKfIJqAjEkjJ8j6aMfSc6ff579wCMlKgyGVa+578BhJf+3
	aqYDiA+xagJzyAsdmYZ+Gofucv2YCBS1b4uUF8Ws6ne0a/OJF3nk0dr/nzPgMKLe6ZYQlNMD2P5vh
	7swJk2/OoPqvxRHMKexP/fcSrQDpePjfupzXW1wLMs+uMptCrx8erMt988UpqDtoAY4rWS8q83sDm
	jWgor8qg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wU6Vx-00000003Mll-0wOR;
	Mon, 01 Jun 2026 17:33:25 +0000
Date: Mon, 1 Jun 2026 18:33:25 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Christian Brauner <brauner@kernel.org>,
	Askar Safin <safinaskar@gmail.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, linux-api@vger.kernel.org,
	netdev@vger.kernel.org, Matthew Wilcox <willy@infradead.org>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@infradead.org>,
	David Howells <dhowells@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Miklos Szeredi <miklos@szeredi.hu>, patches@lists.linux.dev,
	linux-fsdevel@vger.kernel.org, Jan Kara <jack@suse.cz>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH 0/3] vmsplice: make vmsplice a trivial wrapper for
 preadv2/pwritev2
Message-ID: <20260601173325.GH2636677@ZenIV>
References: <20260531010107.1953702-1-safinaskar@gmail.com>
 <20260601-enthusiasmus-canceln-anlehnen-0e62317a9784@brauner>
 <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wifX_rrDjRGnDnOqE-usptAukuXKrmuPuVDP5bOCBWzGQ@mail.gmail.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 28B3F80004
X-Stat-Signature: ehs4y4ob5aukdtms6tf4h5pca3qdmhsw
X-Rspam-User: 
X-HE-Tag: 1780335209-590131
X-HE-Meta: U2FsdGVkX18I3c9XJjdnIsAEBx4Kmkri85aQ5mNqCpkSzFU0v14AX/Jb313YJQQTvfLezxvMk7cnV/c5gJdxEbBjsHjjwckSlcWRYY2Q7QHdBbNdzjCTdxKBj1iqNnMKyENnzoiJ7HGV5+tyGiawas3sJAjsX/BPTevIq/aaMbhg6DEmwBRR4OvFuxjx0ftG9YhWS2A6KUbcHfbIBx45m1dHp4oq5L7r7/wAwIKWLs8uypCROjR/vRRBJozY6JRBp06hwgkFA0pATWCjFKnVhvuXUQrwfKEffShp7NZ8zbRmJU+0uhSrqxPFo1vrem7Ev72DQxH1PIAI4LIWhxIP9N4Nkzwhoowur/JADO5G8Zbti6W/X3j6SLLSMAPwMXHqGgdWBL+Y9B6y5FZKx7rL7lk9PBjHV6Pq+QubfL0NmvWmQyjMKml8YuK/6MQnUPdQZpkyOqlryeEWWGg5m/7v9vxSzreDvnCTlE5+rVdkSuDoR7RGzVNUWePXJ3VKeCMLp4e6ZzQOyEZNmmlnmlwFvow3ltK5FmRTqqd/LMhBjCJC3Qpx8b8nI5NMGKkgpmMgghonH019p9ggpIQ1+IA2yLdh1iKKxGppD5WHLu88tfmQFoKLYsohRekSA75cJZ6wggoJdZKDtv38pfB14MB5elwTvyIaU5XXHmtuTeoKfI6kgwOnZsbzaWyvR7cIcDR3Cm5fiqF1DAbRvs3hhPhg9BRJvruuG8GdIfBfAv/+FZzfbaIFsfPv509Hz8s6mnz6b82hJYRN3HG/Cl6Qcj28ZL7+oMMv/0hxlAU+AA0sKS7/UlVKW9aY7ELmXssZntHGxBYh4+yl7dD/zaN5Tfpmd4QURklz/hvUiVarYhk/RBC2twp3bKQeIhWvNj8aILSmUG20wci8aane2c8iltEvX3cvd7Qfs7pnQdhuIuH+4gzW/BsmXmIu8p+OrgNgxbqLc7JQJoKZoFV94oJ6icv
 Es9OGRt1
 zQCiGe3jpw3lfZALgZGW4FDScDyrMo0Nzr5FTIBZw4zw5XReonXG4Bkxt81gC0rLdv5p/KwHmDnUI7A+GnfPimmLxSwhXgk/XvO+SQ8k0G1dXyoNZvtV6GebREEmbAckyrRxS37PbN8Wc80PCdsWI3Z+jILhZnt00Tj65fzbcnauP6Oprx553SdDa20hbDFLYV2lCQ4kCghBJFCiUJaPmmsU3cJaHT/TF3Qo8WoIYW+Wpwgh/mjkfb1ohDnDoPf7cFrbkPtSwRj3o3zqh0cRyXxAOra9LEDeZwyeIi7CUn8GQbR7OcG2LqgIwAApNGsh9jGZLk6pQKZ8hO5EkEJzXxB34/alrIKaVWC2jt2JwQwYnIcwusxqaS2fHQctUXf2bWsmdygl076uS18gAXMdq3sUsqxKd87/7oWNFCDurSG8eV+HmOpLMrudXkuABJODJNj1g
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 10:17:23AM -0700, Linus Torvalds wrote:

> TLDR: maybe we could ghet rid of "f_op->splice_read". *That* would be
> a big simplification.

FUSE might be interesting - fuse_dev_splice_read() and its ilk.
Communications between the kernel and fuse server at least used to
seriously want that, so that would be one place to look for unhappy
userland...

splice-related logics in fs/fuse/dev.c is interesting; another place
like this is kernel/trace/, but I'm less familiar with that one.

rostedt Cc'd (miklos already had been)

