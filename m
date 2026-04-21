Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A798F94CAB
	for <linux-mm@archiver.kernel.org>; Tue, 21 Apr 2026 20:17:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7A2886B0088; Tue, 21 Apr 2026 16:17:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 753946B0089; Tue, 21 Apr 2026 16:17:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6685B6B008A; Tue, 21 Apr 2026 16:17:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 535386B0088
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 16:17:55 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F36571B9581
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:17:54 +0000 (UTC)
X-FDA: 84683674068.08.5FB5C21
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf06.hostedemail.com (Postfix) with ESMTP id 003C4180002
	for <linux-mm@kvack.org>; Tue, 21 Apr 2026 20:17:52 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=c3pjcWJQ;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776802673;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Zmk5kCu+N+tLkVd3CGGCvLP7PJjgMTpvngzmVMjrx2c=;
	b=m2bLg+yOVegGLAGajPVukBW9p5Lxct30lSOQ1SDfT749iunJQ+BxJVLM4EeMmf/sabzbFI
	SMqsDIUNMv6eV54okicER81o5LodqpcYn86wnDqWXIV9sY7sgKkykEWYyECOwq74qpx7wZ
	LVSLq3c79OY+zEGorY87jVpa7cHv0RY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=c3pjcWJQ;
	spf=none (imf06.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776802673; a=rsa-sha256;
	cv=none;
	b=BMUwotYxB11lUHp0nesaDQA2gn1g9xejTpYfKx7AKLen8y/hwuN+eE+/CrO8lO5rxA8d42
	VnlhQJXl2oZCw2CaIsOBOVEkl4SEyet/Ms+TUlyumPFQTee87kisi78wWwbGZvSA9BBkkv
	iUKT7A7Xw8RcGfsDX1HOnA42avYoIvE=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Zmk5kCu+N+tLkVd3CGGCvLP7PJjgMTpvngzmVMjrx2c=; b=c3pjcWJQrzP/CnBpWyzEsOODaL
	IpEOkNzpKCQufKIBgcCtLaLUdZUbppx0takTo14jvYiuZqp8xdzYI2/2/zE6ytz6edrnoZVaXBINn
	JPEmEmWR5KBoLMUkb7GJpXXr2WpJ/yBbdmNVC89RRsjlV6OIKHaqQOQO8DOagfVA/ID96S42yJQEK
	COv/MUwpKx8WGbf98tfFzidVpMtpo8cZT5cjO3vZzZ215aM5cIi7+rZNbDFNSJkkI0AE9SmWzBAAF
	oO8B8dXd/IW7Vb1XqDIZX4sGQfU5XL2ad/lxjpDoMsHMCHcfaQJg1abFy6LMI9SMHcBV3/K3aKIVf
	elDkpJIg==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wFHbT-00000004sv7-1ZFx;
	Tue, 21 Apr 2026 20:21:51 +0000
Date: Tue, 21 Apr 2026 21:21:51 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: "Harry Yoo (Oracle)" <harry@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Hao Li <hao.li@linux.dev>, Alexei Starovoitov <ast@kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	Neeraj Upadhyay <neeraj.upadhyay@kernel.org>,
	Joel Fernandes <joelagnelf@nvidia.com>,
	Josh Triplett <josh@joshtriplett.org>,
	Boqun Feng <boqun@kernel.org>, Zqiang <qiang.zhang@linux.dev>,
	Steven Rostedt <rostedt@goodmis.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Lai Jiangshan <jiangshanlai@gmail.com>, rcu@vger.kernel.org,
	linux-mm@kvack.org, Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>
Subject: Re: [PATCH 2/8] fs/dcache: use rcu_ptr instead of rcu_head for
 external names
Message-ID: <20260421202151.GF3518998@ZenIV>
References: <20260416091022.36823-1-harry@kernel.org>
 <20260416091022.36823-3-harry@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260416091022.36823-3-harry@kernel.org>
X-Stat-Signature: 19nuyyq47egmbs3cuh7gox7xkuab9a56
X-Rspamd-Queue-Id: 003C4180002
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1776802672-791265
X-HE-Meta: U2FsdGVkX19D/mQy8vry/DTa7mMyHq98MI1LuIQm7nyKM6IjduSX7BepZ2sR5J4CX8qbodWvMO/kfMKWCsUVhPwZkhrjoTpWNTjaFrLKsBT9Aw9XLp7gUYGFHUwVZ+G6ePQsgf5rxhiRjbL2bQ1fqRm8Us1nvRBdWx+0A5+23eVc0qgk8Pv4zhci+QZ8QbEC2jlBNm9lzqxJvdrTop6WT42n7r3UkcOH4DGhr49n7R3heTSsMmUyuCaf+MZ86lFaifv5BIh6YfBprR4qmQGqhKT7SD7ShgkbbySiqdZTTYrMxTYaiv+UdN6XCG3Y3MskfPoDdyBXbB2Le+RbmtFNNeXtvXDclSExHwTqEZeLnFMbypnjqZkGMiur+HfhZqARucXb2MF9Suox/iHWOSQLQomqbai6Pn4ip6biFwT8NDH4GtCkCJLlU3XnK3XiO4pC4rzMECyCFay4JXshEf8+OQWF1gQHmmlc6iUTY8BkMl+4MlyH7dUID5mgIIPTmYWMVYcu7KmmG6gSbniAdVmAvr6xP+AWdArHhE7v7vvay2r03ujzrBM8Mux5o9pyMY8+L6a+RU3OZc0su05Qe6kjvMoo316nxQCUyFmJ3oGfFZNoewC/35Kj2wfPTd8MNVuDDOC8rY68hX48jiKcdaIFFFgKMARV/iTJ/S7lpjKzvLCjFLKPePnGvo4yJs7t1KjkcsZ9m4B0pd4VD2wl8lmVG+z5tpo6JTz2goiVEkLDHEVhBkbZdaKNFwVtUE00rg+WWk008w7g5pN2ATDv8g4jGs3jGdVSj6nU9D4L5+agElmCwiVEXRiqWT9KfmCyQeoNhHeBcliNDXQkwNd0m9zZpKLUsZiN9LGnlB5nCXJFDNFd3s2CMNYzqB/tX0cQHGqckboOYg01+ycmhCWOcqIy1k9LvE6aRu+UnEETJGPBFHCxGQDE/ZPzA8V2eqvWjTIqude+jtMP+uHQ90gMAGq
 ccRWMS06
 n+PboFtc60ispaWZvwgdLl15Q0D29z3AUXAK1wXGAeT8yQxSlEyByRUIO9fh+UB5M+3lELjZYwe69MTiT6Rf+8xESREQIBTADg2JpU3q7oh53GiGv/iguFnccIrXNn0R8fBwXH+2HQ29N3NHQoJSNsDIZ/t9tKSMk0hKCKdanmyh6Cbwi2dbktaEmwo1KmkCRZOFgqOFwq2dHHRCmAtBaH3TNu048zg9kcATAn7YB7SKKeKSJbUrvEkCwLO1lORQxn/GCN3IhA1AC8yxeaKLI7+THLdpjb812gBS1U7q8ugIZ51MqHLTPCT+AdxMexmW1iwY++uAmbfM8fV/lIqWyjNXnhYYeKjkjLRQSNdKalzIXmpyfGau2AEktTbSBGQkn5I3CSUY2hEmnnrI0NPQI/RmB+Ae5Mod3YmhdVOIuF3oXX1zGj8OKHEcmtuzeRK2VBVdP5eJDOOR00w36Ba6m0yki8QrUKqsA96ODOg9iYnQdCNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 06:10:16PM +0900, Harry Yoo (Oracle) wrote:
> When a file name length exceeds 31 (DCACHE_INLINE_LEN-1),

#ifdef CONFIG_64BIT
# define DNAME_INLINE_WORDS 5 /* 192 bytes */
#else
# ifdef CONFIG_SMP
#  define DNAME_INLINE_WORDS 9 /* 128 bytes */
# else
#  define DNAME_INLINE_WORDS 11 /* 128 bytes */
# endif
#endif

Where do you get that 31 from?

