Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5631DCD98C7
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 17:13:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 446796B0005; Thu, 11 Jun 2026 13:13:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F75A6B0088; Thu, 11 Jun 2026 13:13:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30D916B008C; Thu, 11 Jun 2026 13:13:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 240406B0005
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 13:13:15 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CABA0C2431
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:13:14 +0000 (UTC)
X-FDA: 84868277508.29.D52DB1E
Received: from zeniv.linux.org.uk (zeniv.linux.org.uk [62.89.141.173])
	by imf24.hostedemail.com (Postfix) with ESMTP id ECD3418000E
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 17:13:12 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=MyHry6lx;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781197993;
	h=from:from:sender:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cWSowutYt9+is3M9Tr+5oqXpU+VO3hI3Z2ImX78drkk=;
	b=MdxA59hKFOA9oii6alTSRsvIEd+E4lhHIAGr64ztFxm6YVxW3U0MnT886OKLsaAmsqouCY
	eYtuQOs7TXaSjB0KYa/h0qaBaJ6M9NErqVluI/vvql3lfsCex0cxrurPGVBZd0Y1UkVGx7
	SWHXgFGEaZOxY1fw6/etlhmsxGAehco=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=linux.org.uk header.s=zeniv-20220401 header.b=MyHry6lx;
	dmarc=pass (policy=none) header.from=zeniv.linux.org.uk;
	spf=none (imf24.hostedemail.com: domain of viro@ftp.linux.org.uk has no SPF policy when checking 62.89.141.173) smtp.mailfrom=viro@ftp.linux.org.uk
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781197993;
	b=ppDrq8U64BCS7mMiup3JZkU3T0KPYk91n9KxC6u7nIq70ijRCgnVAhfrMBSdLpXgIouHIQ
	F2d0b62CZt7tLEcQRazTsb9u571lYqTKqyDt1303CKlHkSc99M018qeJO3Q8/gB1Z1OGzY
	U9hUd+/xGrQIg2zX4KptCGxRb4C/o48=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=linux.org.uk; s=zeniv-20220401; h=Sender:In-Reply-To:Content-Type:
	MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=cWSowutYt9+is3M9Tr+5oqXpU+VO3hI3Z2ImX78drkk=; b=MyHry6lxoD7fg0AtHNu0ezgNo0
	yk416pq35EwsSBOOhSnDCZQhMZXAY19O5ZBFRmDZ6CDGxCuOrewsnRmAXCY6bFaQ3qi2jv5c0Fuk2
	3WYN9sLTNEZJNskROmjC3JqqNa74dySqkJJH+No/Rlj20F78xzntq7sUX2b02MYlkh61YCoX+2TzK
	HbvcHIH1bw+cPYMhKhJ2keIXu0wY4FKgg91g3aazlqnNPFmrmBF/SANr3RTHxSO/eMPJjMo9zOCx4
	90f7dsM3C7JiLP5JsTSEA6eOVVc+TVn1vLcRu+x4nIG2cjTbzLVt3FhWY3Z5h1B9nLvbSQB745zHq
	6rFQs4jQ==;
Received: from viro by zeniv.linux.org.uk with local (Exim 4.99.2 #2 (Red Hat Linux))
	id 1wXixp-000000070H2-1eiu;
	Thu, 11 Jun 2026 17:13:10 +0000
Date: Thu, 11 Jun 2026 18:13:09 +0100
From: Al Viro <viro@zeniv.linux.org.uk>
To: Vlastimil Babka <vbabka@suse.cz>
Cc: Harry Yoo <harry.yoo@oracle.com>, Mateusz Guzik <mjguzik@gmail.com>,
	linux-mm@kvack.org, linux-fsdevel@vger.kernel.org,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org,
	"Christoph Lameter (Ampere)" <cl@gentwo.org>
Subject: Re: [RFC PATCH 01/15] static kmem_cache instances for core caches
Message-ID: <20260611171309.GN2636677@ZenIV>
References: <20260110040217.1927971-1-viro@zeniv.linux.org.uk>
 <20260110040217.1927971-2-viro@zeniv.linux.org.uk>
 <aWdGEI6iQBl3Xibi@hyeyoo>
 <19e0c58f-114c-4bbd-9bc0-25382d7d5cbb@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <19e0c58f-114c-4bbd-9bc0-25382d7d5cbb@suse.cz>
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 9b1qj8fs86t7pbxsudq3iayjgyt7mpo8
X-Rspamd-Queue-Id: ECD3418000E
X-HE-Tag: 1781197992-695695
X-HE-Meta: U2FsdGVkX1/8eE73+cANcrOlXnbfPJS+uCyl7af2cYyqJbhNAj6CpfdVUx8Tz0qmYA4f/XNBPUNB4BXRF5B6jQJ/iEWQIEt1DeYRaBotr8b5jDYfGZbZKqHFGvOagQLdUoLU7g6dnSElY4lzWyOjDYUf34F4ahVK4IM2Hn4tY+5iN0vc/68I4AIa22wlEaSeo7F0pA7+lDl5uicAZjP+FtrHwaXAtQ0MCVg/woBlkwuFJZD4QfArkxl6jEriEy1D3V63sPUbuEVOcgrHyXQWe2NtsJ8lIMOvKPMGmnL/P7q2JhzOgLeptkVF806vWRFne8K99pbedFUODI9VQc57ABCGoHl9/IVMWFALj/xzrkCjCJ04VwramAnXbtLQrtyRPL5qqH8zjnOsh2tnrrOzgd3XKyK79fRMhDF+lNFTNTDQF8s0ubF4qAoFo+coNA4GqhnOyKvEkv9SEE8E+RMBlXrwT5B8zu58crUhH7UNjDA6Mz2kAUT5IqY/Jhe05CpVlbQwDqH7ZgagJdIlXQWXQpHjH5UDJKOpv4V56SuKuRYt31BgpzNtdL/FOaCySuU683J9M1adNeLHwi8rlEvZGXu/gch/KlVuOFsFE86OM9wvQVMBEJ5lDI/5b98bSePm/mkOUHIwxb7MCQAutHN0vwxDzl9R/6j3iEbvvHORzLTtd25zDgSTmNdkciHxE3nUCNaCmpw9oPspa/akcFbItw/6zRla/cjDlvLVz1m2oyN7r34PeyoPtiuqdKpdHElJEXdI+zukiy7lPXalqbacF0mmTNTSgvszizFAJpXwHPLsId5wYZI6qxvcA4SNy9ADUhDYoaQwGHD636LkgWSyWKjhX756VOc5174C020awoDaoKoH2hqpWIr7VYLKJqQFmTCXCEIkSyiQEhw1sIMI8VhMt3G259ha7TbamndUmlIan1Rw/9n9jPJJV4Y3jTVjDoTshwhH+SQLtUSH7vq
 2BZopEav
 7UsorzPQ2J0SYTVPxhfK8pNMGoieioqQbXJstroE1tWP3CEaeL6htaoc1Zqqk+9hY0hLBqVZnz5xNXgySNYEgyPU7vqgYhbx4PFpg1jmoUUdI23CC9gcDEOPO6MOPoHDw7vFqrrBrlggQ1t8TCNYfYrBCH2ejZIfypr5Yo3W1mqqbB2zsK626QDdzaDASog+HTYcU4wci3LOJ3GN1fzKDJ1J6tmVfq500o9SkSpjysx1U3GNdQCj7Gr02oNbA18+AcWmHu4z5vQo9KgV/3Cq1UTkgc2tgdvBG2nVhDh/uAafUaqU1BptXCnNp4GuYpXNm696wrcqIebX/kFjkenhyNq38xbGW8RS44SFSi98rFnV7O7TEUmw3Elt7Jzy4TvpVfTSrScVbKJC5r5NY++d1H24oWiaE6OXEa1XXpX+IQ6ota1IWBWcTJ/AyFa7qC+Gm1yYQgkP3UssgTX1VB361VM6FS/wJIWEdYgikQ+GlrAWtAhc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Jan 15, 2026 at 05:59:12PM +0100, Vlastimil Babka wrote:

[resurrecting an old thread]

> The merging prevention is my biggest concern with the approach.

How about allowing subsequent cache creation to pick an existing
static one as long as it's non-modular?  That's easy enough to
do and it's minimally invasive.

