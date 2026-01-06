Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0BC84CEFCE2
	for <linux-mm@archiver.kernel.org>; Tue,  6 Jan 2026 18:29:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 64F726B0005; Tue,  6 Jan 2026 13:29:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 626C26B0088; Tue,  6 Jan 2026 13:29:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5535F6B008A; Tue,  6 Jan 2026 13:29:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 41BD36B0005
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 13:29:35 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F00035B5CD
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:29:34 +0000 (UTC)
X-FDA: 84302377068.09.B762484
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EF16C0008
	for <linux-mm@kvack.org>; Tue,  6 Jan 2026 18:29:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v4jxEldV;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767724173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qkby3BqtHB1nqtMcYc5138J8APVhs2/Zsxa2Be5D7fI=;
	b=bzmSFTGZX7QR6dvbkHZFUVMi+sIJHUm8yfRKZO0/5EECP4P2p7BGZ/wgwyl3+MUQe1qSLf
	rI5LlIdFfTL3vu4hSEeROF4l03TYR6kgSWLKJw5Zf5+wtFrHGGb3bAUaVnwmacOfhYm+yu
	OTiFbCA9+eHC10pWWGohNnZ+RHPTb1I=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=v4jxEldV;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767724173; a=rsa-sha256;
	cv=none;
	b=HAGfCxREEVszrlKbYZzunuM+cPlgDKEEd0aLzx/WJebCo+25CnOxNXgYynjEvExpND3f3h
	4moKG0yx6TBxdrGpbk7iGItCbXjBC/ghit01158Hum2mywK9wEuLuL7kPl9QhDfgJZOrmr
	EMyk3Rg0FXAPpu8BOaVFGnzDXDybmMQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:To:From:Date:Sender:Reply-To:Cc:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=qkby3BqtHB1nqtMcYc5138J8APVhs2/Zsxa2Be5D7fI=; b=v4jxEldVZ5RQTFO6xLV6gj2t4L
	wQRjkMOo30t2FRobMuOqGBMFRXmaEdG6BFAQOGEYPCKBpDViIZu8bOhpcPdOne/VM3zrh6xAa3ndT
	7cYOpvjb3DeAYLidkfN/RUMmvH1mrDiSWrESYpQtqUID9sxtaggYi4iVTwputkLi3F0XEC2xEf+JB
	fP+x+1lyZfq2U0LxWjYrgOHCOjndDgEAOpVfQBAYubOPM5EI8p82GiLM5/MNnAyiGq2isndgAamik
	5rCQ21UahWKhKC2St05EwcLKh2afQQFT+jTOdNvQSMbrYlu8LAK1w3/UwNIqx8bsHsrkXR8wOdYyl
	mXSADaJw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdBo8-0000000CHj2-11QK;
	Tue, 06 Jan 2026 18:29:28 +0000
Date: Tue, 6 Jan 2026 18:29:28 +0000
From: Matthew Wilcox <willy@infradead.org>
To: "Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Boudewijn van der Heide <boudewijn@delta-utec.com>,
	akpm@linux-foundation.org, aliceryhl@google.com,
	andrewjballance@gmail.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, maple-tree@lists.infradead.org
Subject: Re: [PATCH] maple_tree: Add dead node check in mas_dup_alloc()
Message-ID: <aV1UiEdL-YUd_2OT@casper.infradead.org>
References: <aVx4PjdhG31LfjuA@casper.infradead.org>
 <20260106132418.57408-1-boudewijn@delta-utec.com>
 <vaz4cykqkaa6qksfp6nsnta4rkzqpvaorzdsgy5orapkwx6mil@knfau4tgxmup>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <vaz4cykqkaa6qksfp6nsnta4rkzqpvaorzdsgy5orapkwx6mil@knfau4tgxmup>
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9EF16C0008
X-Stat-Signature: adgwydeafa56pz3gbsew4wznzxzqgypb
X-HE-Tag: 1767724172-869101
X-HE-Meta: U2FsdGVkX1/x8TjR19gGK6Q4CKySg/GJFit6HVA0YpnowqLVMwguQBFiCAPOLyNHEQ5ubXD+Q4uq5ekAj8qw0c15krxyXgMe98pXgAiPZmhA8R4IggIcZiw6mPmFsiqCBKuwNJfrpM2qx8vDHeOu3XRw5t3BBK5nKCHfIfNhgHic7uB0ibWGifk/1epxswnNw1ZqThDgnAat2niuBdZE6YuQf6j1HymHUfpdslRgQ9G81l4dxatexwvSVqCFrE0CN/L/+qqlWLNm7DbZ4z9hw9orUZtjQ4Zv6lhRuzsIEVwjU4eei1ItE92mwd3xn8yP7XcWHSAcTJ+ra1GyJ6BQ1N8FPhyf/Hu06PL3QbUsmpOrbKQ5jTdww9JXbc7bHTWYILlE3r748Nne/KYm5cMNNNffxFaMiYEvmlVyKJG3lnqk7OXEk0vHj7KEchxH3FHwd2xM9KghE4jNp/7dsPAx8GYK79ir72yflSXJAl0z+auGTkHuWjIIJdsOozAwtAoTgAvUEJdLI6LYKPf0pEQX/d4uKMV9ft8R43a8u+fJvJQfK5N8dNQyzPd+RzPiPndNxShIZLM15TbMyKx2RsOrJGlsLy1XaY2vV8KhNtekId3kePUDz90deQ0edBnAuK7tBM30KjbqRdTFAHktRn5qaX2NynFesD3IhJw9RRv4CrZkbNw8LOkxRH8JOfQv/sgRe3mxakR3u2BU/aghO8l7qZnJ8Q9MaX7uQnfgL4hFGnOwglkFUrW7yyPsgddKoxXkPTbo5w1swt5ymVhbISMHdA42KTdk5tsdvtxVN60CaAS+uz7E8XOgH/2BI1Co69bjfiiaiJ+eZ17x47RO+lTAFTMcuwFJaiFTi5HglMyAB3eb1FqO76SOXJgSvckGXFWZnKBwoJvEzyH2wTZAlUWFjc5F3sP+WJSlwVF4hkZgh4Re9UeCKuFysr1LHapHOl3BqSEay0zEht4uD4mQLOw
 fwcVibf3
 AhZhvx5SbYK6AbuXHhZ8Z7WGaU1OyPhg2xcIdindFE8dcluHbwhj9k9wRIJJSdDRnty3LtvkwcvCjaiWMCV4iUxY8G8YgC9rlwHBUhoeNtais8WM+jrWzXeJVH5kmh+C36ticey2QDMh9npYaEbDqoHoi8FuWh41gw6zH2PVwv71SUrk1YQy9GxFS0TH5mbx6T78D/O0xfBY9ce/ql6pMVEc97wkujcJ7vnsdoWCtf9DfxvtiZT0oD7iTiPHEqm8GtORc+GyJM+zoDA23Bn2mGOhuyjSCCZWPxh//bny9CBRrTKw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 06, 2026 at 11:01:27AM -0500, Liam R. Howlett wrote:
> The fact that no one in the tree uses it incorrectly means that any
> backport would be for the benefit of out-of-tree drivers, which we do
> not support.

Should this interface be EXPORT_SYMBOL_GPL to make that clear?

