Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 663C5606A322
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:06:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HYHAo/Ox
Received: by kanga.kvack.org (Postfix)
	id 66FC26B06AF; Tue, 27 Oct 2026 07:06:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 620E16B06B1; Tue, 27 Oct 2026 07:06:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4E8DD6B06B2; Tue, 27 Oct 2026 07:06:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 2237E6B06AF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:06:16 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 9A0871209FB
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:06:15 +0000 (UTC)
X-FDA: 85368127110.29.53E82C3
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id CC79B40007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:06:13 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HYHAo/Ox";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793099173;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bD2dDAY20BKTrGXuNns0RrUfHKPHaCZasCXEiPto34g=;
	b=To+VvCbh5rfyPoZzV87l6ZAkHT29e0UNymICFoDpJUxdFuClJ1UkDUGqMsaQ2t9mgp0xIM
	Yrhe7UxYhTpOFM9UAXb/tOt8ysFzKttFUpk6wFm/noX+jHpH8MorO5yFQ3W5T6d0dQBU1H
	ryM74KcutcVAmmyaOgLclHEK2GN2e30=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="HYHAo/Ox";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793099173;
	b=sycE7aCNT/WGrSvWIumgSe8TjpgjKXjy7z5x+NKHyRCkhYDN8chn/ppGaUEdEykP++XwVm
	ocp4lDFRaIkH3k7M8Y4vfzITd4Z6Cktqdj2+HzOAFKqcTeJfY5C67a9Dvf6NP61lWY5Sm2
	UsJGGfs6/JelQa0yctu4iaPw9QGJqeo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 0DEDC433BB;
	Tue, 27 Oct 2026 11:06:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 316F31F01825;
	Tue, 27 Oct 2026 11:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793099172;
	bh=bD2dDAY20BKTrGXuNns0RrUfHKPHaCZasCXEiPto34g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=HYHAo/Ox8MT7UXy2pq6W/phAJ2m1YIXIQBAFUZEX4uxXpNYFdXSnoSs1Q/b/g2AtH
	 p3xkQ4a+4FH/jD2ZitM43gA20N3VlLtCejbxPvBm0pi5oWcnRM011ai7c6jDwdbVh/
	 GRzNPuWRA8hnOC1urxirDV01RQ6RF+GQ/B5OtYBpQYoYRiTQgTPcd3AJ27o+n89yip
	 /z1GKaYCjadKjpubV8HMWLtzzSHg8uNQFroASMnpXLulLZbW4kWmEU0MD1ixxml377
	 SnfP+/l79Noo6REZlR+0vXakYK6vEpDc2OpC+QRwjA1gYWLcFzu9hNxeJyebzcpfuU
	 mrxNKVhwbk0YQ==
Message-ID: <321017a4-58cb-4178-8ff2-055a9bbb28b6@kernel.org>
Date: Tue, 27 Oct 2026 12:06:05 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4] khugepaged: fix readahead lock inversion in
 collapse_file()
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org,
 nico.pache@linux.dev, ryan.roberts@arm.com, dev.jain@arm.com,
 baohua@kernel.org, usama.arif@linux.dev, kas@kernel.org, jack@suse.cz,
 djwong@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 hch@lst.de, pfalcato@suse.de, ngocthang2710.1999@gmail.com,
 syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com, stable@vger.kernel.org
References: <20261026152013.10511-1-lance.yang@linux.dev>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261026152013.10511-1-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CC79B40007
X-Stat-Signature: 9sqs7eijy13b9u6hpfpjaeigkuc1prg5
X-Spam-Status: No, score=-7.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793099173-977563
X-HE-Meta: U2FsdGVkX1/wVikQRYEkLUw2RJwLOH9x12eBX9HnkzcyXqHKore6ck7H/oPvMnvBCepo0KMQ5RqOzBkh+6ZAJDDrXyQAP2QFc1EpAKhnkpteG0NhUJbSNJvY4P8AS8mNsos4PnmQwSyWpai9yp/gQVODz1TF+v01oJg3sSUeMEHkKYMLnFh0RB/a0y395l8FcE/tUCjGGaLZC9Mkm+yBVAgGiHROAl7q2ReMHardTlgxY4fWMwnH0GMuKeUefNwv2p4oc87oJAgXVManQppk/m520gBWs7MuM7gYnKXWzp5o6fSlN1FcMBfhgwCXo9YtJXLWyaKT2ZStwmO1XPcW8pAX3NmiYipCxqKM1eyjO4UcSP3Nwk0g0H9o/BqX5Ne5FKgWzdaOClNoisCLJS4nRzxK6PIpg8m5h2pSTIgE0rxbcz5MCEtSqH3KcxOSavch338EigmgzsYGhkTHuk/jk1EVSUfwSUeF7tfqqLuMBAJAGLpdPxxlNmtF+DJg7FiiuhWr8B5ZkZbnvBJShvYA7c0ZnxbOrt2hC3ExuPO1iqu1b4fBi6f0YKXbjIrvuxPmBbzXam3S9Nhf0XN83nDe9JWyaNmq38fMnv5SJjWYoivKF6uTJftA1XQZJBV+qn+lyVmcGLZuNyvWxWswO9K4ffGej9sXBEzcaMJeXMs+hshEXEqeN3MWwsEHFERodJdCtX1PJ/9gmQI2VSfC+BzefGQeEpzQHUyEwAtVKjpOv+O27X81FGjRKEzqc73MZyv9lidbnHd4e3Z0SberEOddhniiS49ZXQRRqVGEV7bpXZaVOz45DFVgyw3Yfw3pM1hkd/7qYY8a5ScvUxpfYym5AxkuTtYk99fO1bklr25+jx4GesX1DPX0fNGGAuTJcLdYmgeRxY4Lsev/SwLT8Jb48DtYinXItqzgjTs/O+RSJ/VYPoW2eR6vNmsPOhnR+R9j4mZfQzxtmcNvuOa17qc
 PWjLHIKQ
 urEtmc7l1tLRerXpHn2Yfk2d8Aq9cL+0/ukMAZoCvBXohJ+lwCTvjNtjiWTRMm0M6Fx97wBBNuy6LqkxGHOYSqdm81q7loknauePnb2d795wDoxLctOI+V55wgmArSYZf6KYcZVMoPlwbouvQjeTGve6LJDDUSHkSrSDaUKW+b1gPHiVk55IBVAHC75ufyHSlC0ZglTuvqviKDdCqCh/S7gIkwY+ZmF0kSiT77N8SzWXnbXseJElm3G66USBWi6stp0XBluhA1iXnCBl+aab6mtg10wVAKTVsQEKtO09DoQH6krnojyIy9pg09kGEC3HxTwNsGX0EDlOYeXYyOYjgfSLXFJWlp86PNdlwUg4+mrM7jwIn4kjcvZgIOy9Sz1rIBlWHU97uIXFqIrPomw0HRsGZ/gIt5Sna5ScXMVRc9o+xdFgX+pRdHailpr71NgPRNX180VccWZqYJSm+cK+XrIsQEg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 10/26/26 16:20, Lance Yang wrote:
> collapse_file() can call page_cache_sync_readahead() while still holding
> source folios locked. If truncate holds mapping->invalidate_lock
> exclusively and waits for one of those folios, readahead waits for
> invalidate_lock and neither side can make progress.
> 
> We need to release those folio locks before starting readahead. On a page
> cache miss, roll back first, populate the collapse range, and retry once.
> Doing readahead after rollback avoids an extra pass when all folios are
> already present. If another miss occurs on retry, give up rather than keep
> retrying while truncate or reclaim removes folios.

Makes sense. So we simply try readahead on all folios.

Any reason we don't simply add a second loop after the first loop where we don't
take the folio locks and do the swapin/readahead dance, then a second loop where
we do all the other stuff?

Then we don't need this fallback logic.

-- 
Cheers,

David

