Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4D503E909BA
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 14:41:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 81C536B0005; Tue, 17 Feb 2026 09:41:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7CA596B0089; Tue, 17 Feb 2026 09:41:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6F6756B008A; Tue, 17 Feb 2026 09:41:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 5C10D6B0005
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 09:41:51 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E12E189844
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:41:50 +0000 (UTC)
X-FDA: 84454212780.06.7B5E86A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id DFDD340003
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 14:41:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CVYys1My;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771339309;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rCDQgTS3bQg1kvut4evCQ0Ojg1EZ8B9mZPRbt8Rf7do=;
	b=ujuBrS2w6wZc/c1hnvyX3puYI3OP3FouYiV8poqp6miw/YmCeFF838FIDvQnHGvgEV5ZIN
	A6tUVsDOiNxKH8UM+Pq9tK352O8himoFqqpLy9Kkzv28pAC4y2siohj3llrUVvbhcjD0Qf
	Xo95I96vuuju4M7e5m1/VlP1R6h/K3c=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771339309; a=rsa-sha256;
	cv=none;
	b=fxNA/gebrEDuNOkO2c83FqTmsr6XrdszdkBElcn1dMqXfmWgavpp4XU15FZlEV/cUYG3Tx
	lFAU/gc99hBYK0K6baD5jnpqpm6r5F3RAGZ2kXh9LbyUGAZToOInlIfgrj5f+/3UfxsGEg
	3SQY3NkLtU69SnQf1EHxiXFSYui/0TA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=CVYys1My;
	spf=none (imf17.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=rCDQgTS3bQg1kvut4evCQ0Ojg1EZ8B9mZPRbt8Rf7do=; b=CVYys1MyUHCgWmagz0VGTBbEE5
	zddeJIRSlwEh1X6yHWhtKOPLlp51C4b2eQ7aZajGalS7jUOwlkj67srK5it6YkiAcVhUAVJD+b9hh
	nZ/VlDf7/8MBxQ7SGloC80/cPWQFdlkZUw3VCcCOdSoafVU/jrngb4kldFIqi/zhWhX9m4au78AlA
	6RTyeStEX/RkN0Ed4nRr9a1P30kf5e9ibjnsZskn6yTfG6QH0cqI4Ugc4hCF+wUi0B0sioEwXyQkE
	mzy8p9pv3cURrDVapC/v9qJW2TYeOgVxYpmPC+TJLRm5h3cdnIfk2HjzFpG9GJlGFhSx58VXNUgq/
	rsaUQmbA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsMGh-00000004YE6-0iOi;
	Tue, 17 Feb 2026 14:41:39 +0000
Date: Tue, 17 Feb 2026 14:41:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Daniel Gomez <da.gomez@kernel.org>
Cc: linux-mm@kvack.org, lsf-pc@lists.linux-foundation.org,
	Alice Ryhl <aliceryhl@google.com>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Daniel Gomez <da.gomez@samsung.com>, gost.dev@samsung.com,
	Greg KH <gregkh@linuxfoundation.org>,
	Julia Lawall <julia.lawall@inria.fr>,
	Kairui Song <kasong@tencent.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>, rust-for-linux@vger.kernel.org,
	Tamir Duberstein <tamird@gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] Evaluating Rust for XArray
Message-ID: <aZR-ItMBkiqyBdKd@casper.infradead.org>
References: <aZRncP-sKLLS2K1U@macos>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aZRncP-sKLLS2K1U@macos>
X-Rspamd-Server: rspam09
X-Stat-Signature: ph63eaei9mr1mj8a49dh3j7k6r59aq9f
X-Rspamd-Queue-Id: DFDD340003
X-Rspam-User: 
X-HE-Tag: 1771339308-804544
X-HE-Meta: U2FsdGVkX18YevwTPcmOTaX3/Z/drNnsA05qFk2V8J6mZEAKUzZ7at+Sqv3O6BKciyN3clQDy8nsqycqV01GpyF11f7IJZlo3X6Xs+XMVJu2lK+mI3V7LqqqcQd9NlupUaAV1pvbvyIE5UVZ5ZjddMmZE7OQlhSQ6am/2SGo35JgMNsxzVou7eafhIpQ149EwI2JW08+2JLh5qRfmE8D4HAuXZOdl/XN+sAbYN2FrlhgUa7XUseRd68kkkegswkqaco4+qA2N8HiSgPsBb6VlkXOV3vmPzTxmynFgAz3unV1To22NoKovAU7acF+/jF0xRDtxffQpgtDXcI7bE9UAvAbAmceQOSG/qYzpXgM83VtrGMjLCpkqeLT1QTaFUhjek9/AOXixIhB1OjvBs0mtz3Yb/8MPGfhKTMBKT1WcB++DQqwNjLOwxghN8WRaTsWYykGNMdTDsJdLYJKN0vp+y0GhiqgUFA5/DFd57VRB9DbHGjkkrgDSU5YumDSNqEtcBOABksclUB24ULz9HjEBoWd6T/+RF8iFEqMqtucXmbrVl14a1fNuI6p5zSaqfutvlebCUc5z0Aqc8074mP8xyNcLjMpZk5d4jusD308xBTe05wfmAhGjusTdVKAmT+i2HeBxVqcVpaGFb9L1KS+N1crausz3dP59f5TgB875dzRQEQdkp7H+e78g4C8LL/THTBm4UdwbVuBGZNSvt4LhvdOdr5Q7WZ/TP73VLHc4NVQEQmWYbWATKDoidVXIhWY3je+Q98P2oFypVphpE8wKdxDTubAXlqy1/6TQH4+JY6K8DVntep+0FxGtYMimPE/0FD+2XLosL4aR39HpzX3hZLJxTHxhcd+/s9bB8/Q/FJ3FzZz9HI2VmtSWAkHtF9QFo5VFqgXEj7s8vX/idlzy5EsgQ2sEhaoQ6VoWHOnhN1enJRqrBy5Kx/SzSjDrwEtbgDuYQWm50WT9rjl+rk
 dNz+A0Dh
 EuUJvlEqYX7CxsGEdnFrCv6+fxvWbacVy/Ls7M7e8wA0r97qADcraI95NO3gIkBygwxzcQgYPkKRJDcPOmkuFovyvLLaLBkZVVHvtQXIgWOYD1esch7xXpcLfFIcz+pVyAyU+h2OK0iJYt58do1WDK0LfoAGQBcd14pB6Qpdo0UqZY9iYN/r9OXneuunA4v6IVoYnEhd9rGyuLPTpfsO730fcSUyQtMWWE6oJNokT2hCa2Tp+QUPJ/0zffe+tnHApmWW7
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 03:28:45PM +0100, Daniel Gomez wrote:
> We propose a topic to discuss the potential use of Rust in core Linux
> kernel data structures.

This is premature?  We can't move the pagecache or swap over to use Rust
until we can compile Rust for m68k/parisc/alpha/... or we drop those
architectures from the tree.


