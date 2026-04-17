Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AA42F8E49B
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 01:18:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C33266B0088; Thu, 16 Apr 2026 21:18:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBCD06B008A; Thu, 16 Apr 2026 21:18:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A84CC6B008C; Thu, 16 Apr 2026 21:18:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9379F6B0088
	for <linux-mm@kvack.org>; Thu, 16 Apr 2026 21:18:19 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 641625BCFD
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:18:19 +0000 (UTC)
X-FDA: 84666287118.28.8F1610F
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 23718100012
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 01:18:16 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YdZitlzn;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776388697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1/hLCjf1LkKv++/y1U+kPpQt2rmVF3YwKhObRQeHZ30=;
	b=1T0awWhSDi51QtaTPZS23Ja4ZDEtk/hAl1bdbksmJMNmxU1zoIz2qjEsBTUysaXvkr6uG6
	4T+rQyC9lIxp+Lvw1hLKEpmq/QCt6+Ko9G7QFBrwZsPXRhJ2vuOiJavkFauEjYkmwtKSma
	0Noiu8W5a4Qqq5zLtPqoVn7yr5JAsUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776388697; a=rsa-sha256;
	cv=none;
	b=ZOLShs2CNzrKhioyAK9rGdMR/kR5ts5/H8jsaWrZcrHUy+Vy8TcyAbEWnufT9b/955isMG
	R4Vqe8wqPDnG09odWOY0IlG/1Kv2dhNZUhozmwSBMXLGSftW/rrNVJUTzME+4Y1rMDB+s5
	zNdC5VL00tbfuGwzppJTb07YwaHhGQs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=YdZitlzn;
	spf=none (imf14.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=1/hLCjf1LkKv++/y1U+kPpQt2rmVF3YwKhObRQeHZ30=; b=YdZitlznHrZ4XLOakiMIyiGJZB
	1rxb7QbiSt+iDULpwGYbbQMMWCSZoZvPmRgvK8H4Xz/2THb6hE2kP4xSiq1myR8Pe0rA5ckCb0Xuh
	1/7SKbETw/mk49NvoOIZG8X/ur2Q+52qLT7hWtHLZHOvwxDj3lz4UwtUfeOzNGHn8h25Epg7mA6Wb
	/cyPgt7ZYr29F6EfiG0B4pcgwCx4QpxysWM3piU+DRUvLDCjwtZi0aggWSc/NrSLl1LBwMgSvoRau
	1cDI/r+hVB9wwa5m713KVwg6G6O1FuGURVSxkX03n3bSXruMQ/LmzgoqO1InyVOAthcM/jkb/JYVS
	ooxU1hQA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wDXqO-00000002Ves-2FTv;
	Fri, 17 Apr 2026 01:18:04 +0000
Date: Fri, 17 Apr 2026 02:18:04 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Alvin Sun <alvin.sun@linux.dev>
Cc: Miguel Ojeda <ojeda@kernel.org>, Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?iso-8859-1?Q?Bj=F6rn?= Roy Baron <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>, Trevor Gross <tmgross@umich.edu>,
	Danilo Krummrich <dakr@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Tamir Duberstein <tamird@kernel.org>,
	rust-for-linux@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Onur =?iso-8859-1?Q?=D6zkan?= <work@onurozkan.dev>
Subject: Re: [PATCH 4/4] rust: xarray: Add Guard::find() helper
Message-ID: <aeGKTIRFgBqHNI9S@casper.infradead.org>
References: <20260417-tyr-ioctls-deps-v1-0-41c6e9bb061c@linux.dev>
 <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417-tyr-ioctls-deps-v1-4-41c6e9bb061c@linux.dev>
X-Stat-Signature: i3wswq83y5n6xmsynkde95w4ste5zgaa
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 23718100012
X-Rspam-User: 
X-HE-Tag: 1776388696-776733
X-HE-Meta: U2FsdGVkX1/wC3C0rc+BWPzJtW2nip1XG7apfLqD58ojeL2RwBKZ5A3dNIaFwUbiktx6ZJfPv5y3rjK+JaZM3zXqY/vYPq6sB0MpdluzCSNdwzAf4NFr8+5n5vkPTE/g6vUBTU8MqLoZleHqQdH85K2pNWT+ad5aFu+CGwpsVHCNRucaSc9X7fMcBQUUlp/T9fkgeJeG1V0inxMkviAbDX0Qcd2K0CVB4vv8cPTKLzX7gkmL1bYZMKN1P3MtorteXGPtK3FCDs8qUq2kVrZEjbJcIA42p9l/agRzY7hL3d2Un2PvEBY34akX8xwu4YYf+TBmkjsKQZXG7DOzzYf2KVYgwaGXKwLNfZXE1a6W2Mpu2Vg/G9B61w9gqFtDuR7Wt2vOM3bt1Wz1sO5I957jGMfUULt5f21csYHHcOVvkL1TJKdgDfYoEWNDW/U9HlhjEUy/UBu/YTjxQslbjcpoh6kAiC+szQdlqbBNgU0aZbOlDAvQH0Ii8UyheDKbAQTr47Eh34BcugyVzhwopYxudADkThOreqOcYee6NppMrdnaDp5bHcSBU6ElJ12YYmK4LVfx38cYsyflXNEMGybeAf6GNh1lvwp3pqoX0+vEkgPPz8n7xKZHc+US92+yUshfzq1/m1rS9FDYzC2pTMpedQE/GgXFCOR3UyYRqKcqahncb6+mu6U/NKI55DzJDnHuWMQMunpgJ7/Nu7rtB2PCnGdXZKU6S+qeGbYdZnz2+NPMkWOavFwzlCgpPg08LSzbbHkPXoFyJ7/yJ54Dn5+OrGEMlDBheP27vfNWeyAFxIntAAGrkw1xOs4PLohHnFhqVGzXw5VgEAp8vwavsWmrdPiLSYxH+qRGcIiDetAVNbkor4RZ9IPfkwxtJuIuDFDpFgq4/544nlE2uTpyqOPv7eYpL1urGSNXR1DVrmugj7B9yst5pdUZlZbcmsQssD9UeQdXvj12hMnPDl7Fk6v
 zVSM+o5/
 yu4/QBAy+l3X/tkbn0Z9EGnCOjRLHSsnBJ658XIqorti5nUPRyHB7tsJAyRko4W0qoYN4VNKfg97LriwjPjd9IyXYZ9eCz5ROsCXPFuvUZ6dkLJ5WxM8aHYS12tMueYPhNQ+Wb7Qk2yMC/okaZ9JCuqaMMAb+0p4Dj3bL6rHmgZq7zWTGOV/GxTz/gO6uCf8mmyX+WBsFYfFVa0pYtMVhMF6iEL/knASyX0fvyCXzQK7MpRYKSlgx8B1HTBnv36Cgjkxn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Apr 17, 2026 at 09:05:54AM +0800, Alvin Sun wrote:
> Add a helper to find the first present entry in the XArray.

Why would you expose a function which does striclty less than the
underlying C implementation, rather than exposing all the functionality
that xa_find does?

> Returns the index of the first present entry, or None if the array
> is empty.

Why not return the value found, like xa_find() does?

This is all very troubling.  I don't think Rust should depart from
what C has without good reason.


