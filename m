Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9BEF6CD5BC9
	for <linux-mm@archiver.kernel.org>; Mon, 25 May 2026 17:55:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 76BCA6B0005; Mon, 25 May 2026 13:55:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 71C9E6B0088; Mon, 25 May 2026 13:55:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 632B16B008A; Mon, 25 May 2026 13:55:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 53C256B0005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 13:55:55 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D8DAE12018C
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:55:54 +0000 (UTC)
X-FDA: 84806695428.19.7DC25AC
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf27.hostedemail.com (Postfix) with ESMTP id A9E2040005
	for <linux-mm@kvack.org>; Mon, 25 May 2026 17:55:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b0R5jvc3;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779731753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5YL6HSkMXE8sg9IfrQO9LGoZdlBO3EtC4IxekeYbMaA=;
	b=pQTflIXEP7ONtEeXFRBKXo3EhNqtwCDbxBhuNRoFh3Ot/m4PqWXoljjWvX+rqQbaGRpxPm
	qkvkVrFGc/O1VAe3ow7n0jFJA0KCfxBrDP78gJ1ebt2HjjmUjs/r4uwBWlNCTuIJq44dah
	1Shu0laBTvQ+frpKM/IMVlmAJ0Xt7as=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=b0R5jvc3;
	spf=none (imf27.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779731753; a=rsa-sha256;
	cv=none;
	b=Ih3ZIIGeCbbTpDBwzXjTr6jYz/3jtkr3J2bLOHHMtgFTCYR/FoIrX2sgmOTa654/EOLopz
	dGq9PPcZvIMzcZVuDkv4pKhe4j9WZaW6/5bVYk7mjkQ5L2KhgPIT3fO0J3UZ+bLNTQOIGE
	J2foBJni3EWDfv18p9DXZ/8MbRvSZvE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=5YL6HSkMXE8sg9IfrQO9LGoZdlBO3EtC4IxekeYbMaA=; b=b0R5jvc3CRgQVq11325LstRMSF
	oKrblBL52SG7Mz6mDBUW/VCNZ8uBa48sWIpmj+aRuCqaV96ZG/Ic5uQrXVPhUdvtGe7ow122bVaIA
	g64TjlVIqJhmFIPhQ9wCX+ubNuU00b1Fk/phktSUzfKmvgsd/u/it9xu6ryC8NFJ8P8L+jQzq7Il9
	5Fcvr4m7lX8njEgphrHxwGeZ8FFYx/Xu4BrbZv62N2oeayt3Hw7hBPI37P8QlLz3vlr2IuyQc45/N
	JHeYVvUx9P7eOgJIhlxz42kjYZ7QlYPwj3MS8hyE/Lij4+DuMW47u5AhZAN8hmywk06dPCe0yGVYs
	7c6BglcA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wRZWY-0000000HaDk-1h3I;
	Mon, 25 May 2026 17:55:34 +0000
Date: Mon, 25 May 2026 18:55:34 +0100
From: Matthew Wilcox <willy@infradead.org>
To: David Laight <david.laight.linux@gmail.com>
Cc: Jan Kara <jack@suse.cz>, "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jan Kara <jack@suse.com>, Mark Fasheh <mark@fasheh.com>,
	Joel Becker <jlbec@evilplan.org>,
	Joseph Qi <joseph.qi@linux.alibaba.com>,
	Ryusuke Konishi <konishi.ryusuke@gmail.com>,
	Viacheslav Dubeyko <slava@dubeyko.com>,
	Trond Myklebust <trondmy@kernel.org>,
	Anna Schumaker <anna@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Jeff Layton <jlayton@kernel.org>, NeilBrown <neil@brown.name>,
	Olga Kornievskaia <okorniev@redhat.com>,
	Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dave Kleikamp <shaggy@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Breno Leitao <leitao@debian.org>, Kees Cook <kees@kernel.org>,
	"Tigran A. Aivazian" <aivazian.tigran@gmail.com>,
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	ocfs2-devel@lists.linux.dev, linux-nilfs@vger.kernel.org,
	linux-nfs@vger.kernel.org, jfs-discussion@lists.sourceforge.net,
	linux-ext4@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 10/17] jbd2: replace __get_free_pages() with kmalloc()
Message-ID: <ahSNFmwAA17pMy6o@casper.infradead.org>
References: <20260523-b4-fs-v1-0-275e36a83f0e@kernel.org>
 <20260523-b4-fs-v1-10-275e36a83f0e@kernel.org>
 <2omm5gmnv2khshoxkrag5rusd3qzrsqyjgsef2syxgryrtg6vq@ao7oabqwebgo>
 <20260525182134.04045610@pumpkin>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260525182134.04045610@pumpkin>
X-Rspamd-Queue-Id: A9E2040005
X-Stat-Signature: r9zydc36ymwfikuzabj7xubsrf9xwude
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1779731752-849178
X-HE-Meta: U2FsdGVkX1+KO3iIvuUkI4rA33zRFU+lVYiEexTqRB6GJX46qA6SRdaWqq24eqhj4GV+V3XDYSU4QhWFfEB4d5dlMG9xwgBJOIiy/bZYfii9USRvSuM7/iyS0zVFsDZi/ptNtAAT/wgoaYf2QvTx4OKxMfP94fEjcyXQz13dYpUnXAcd6TiBLlGR11+4xesjDTOI6XgvWBujG3cpSL1hBAgTXOfkwGrvmARkNBSJPndPrV6Jfxj2jhUwBI8asPeeW6UZSOktdOpy9pxRDLK4suK+OQPU4q2A5EsBSWMYXJruULoF8d8N+FM7QlqnyF+Fa4uRgiCWRgFEKO7Ok9SRIg6l1T1mriaNKQKSiUblLgDGbxzPYncQirkSjrQRBuBJMKkH1IMT18phi3ccAR0WdgY5hBiKkgblSm1Plz7vkL90DuF6lWR/n5xILXRgsY+LRLjZxOEShDAC8iFTs9gkp17ykwQMMpXv631zEk8z3x5STcA5nfqDwPv6NAFlXDvihbVazfGs7mq4mOvb1GAMY3AwI3PPGUGxNjSrp4avS7lFVNjSrs+Zf1GdSYV/J89E4hSEvpIHktb220dSff3vzHmT6J1VcjpWgGl+oEWtHz8zRdOKC+GDr2FgikJCMSfpHevaBadeFYZZksTjebnbm8hDTqZy8NyAZ96SO411jl/kLroETIzvjp9N1O3Psroa5Gc4SMuH75AkZy/VQJTzwFy7cQpUxr4vRzbTc0k5w1Si00BteF7iswhI+AUvkh9OxwsBNm03jmV/umIlsOwNU0trsg62XKahawqXc/eshXTee0YRrtim+Lz+X3QPANa8u0bp0D2/o006A/TKnLPu1VJ3KGLy/eIsUGtpIlh8i1ENrni6l7yH13TbArt7bWnOxxjcqDPRdkN6PPVdaPxEXw0un7x6cebf4MbOl4lF+/CdxdpjgCSo3kV/7LuBDln1gOj8CaHywT/wjy6DVZm
 DQxfkiu9
 OtGCNHfTjHtqQCXzKjllmIJ/Vs9/pQ9IkUkf5Ha+8XhvpsItoTO3rknSUSBJfXlacffD6a9Qw8tuBCLPU8XClyBuFRcMpjkibPVgS/FaWm+xBBoQBl0EK/YLRxm8LLxKjtcsY+IWCXb0JuV9+ug2GknNJOZIYZl6+Cpsx7se1yni2d+BuTHVuvb9fNZ4gTu/jroESb+dRx88wrVlD1AjFRdOUUxtA249fm6yUKz1vetjBg1LN2XJWmd4XwKhxZRiEuWL8iEdi4Ma7DSNlmJ78PB9jdLDvCp0CFuWV9rf4XhpBcq+Y0xmAp7VnlSzz9g2Pu0twkt1gwEPfVpYvMsPe1g92w92+NDKGVB7of9ktMQSqEmuHh+vo/XmZDw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 25, 2026 at 06:21:34PM +0100, David Laight wrote:
> Would kvalloc() be more appropriate here?

no

> Does __get_free_pages() return physically contiguous memory?

yes

