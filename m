Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0DA2EC5AD55
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 12:52:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15C4F6B008C; Mon, 10 Aug 2026 08:52:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10D2D6B0092; Mon, 10 Aug 2026 08:52:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023D86B0093; Mon, 10 Aug 2026 08:52:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id CB93C6B008C
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 08:52:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5D8C3A0160
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:52:21 +0000 (UTC)
X-FDA: 85085348082.21.701056B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id C50E94000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:52:19 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZG9u+U7;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786366339;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jbD/rTHo7/v1amDtY7hLsVEcn/yHEghOpUSa0XJOkxw=;
	b=guAgr0npnPXLr+p/eWNsKI8DymT/dIV/kyZrs+3aF9B3Jl3rvRjDwt+efaZJJ4QWqWqNqs
	QhrqruzednISPcrZaV0SHUU4OdudWC4XCt/tNCF95TV/3wlEtqtdl5eNpgykEHnzgEozRW
	P+/anWJLHdBkkmTve/JHJtceWE9FPAE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786366339;
	b=KkGqvnRA2FpxVWbWO9IbuwKtsNSAs0s6ACASEZKluV1c+ID2nQtuRjwgmSOuoIAXFclWHy
	dC8SmA5ml/mzoNbIB1Em/qX0cHU5T8p/i0S3vF0Y/YXuquhvQbDIGfGIVH0luvX6UrKEQn
	T6KtkaETKq1pTYFdokTpua1zmLbZzI4=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nZG9u+U7;
	spf=pass (imf11.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id DD1DF60120;
	Mon, 10 Aug 2026 12:52:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9A771F000E9;
	Mon, 10 Aug 2026 12:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786366338;
	bh=jbD/rTHo7/v1amDtY7hLsVEcn/yHEghOpUSa0XJOkxw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=nZG9u+U7KkQ4c8ScD9xDDMw8j/kCNz46rhPFgbXjFYThsL/p51E19Amxl72vNHrrt
	 rhStaQJ4k1eolxGnmNAnsYhJ4nM9pF1BINoowmoyS46b1rNZcz79x3U1Q+5Y9nRs3h
	 5JzE8BtBcDOKXzMpBru7H/iicDGOFCeaYoYeKgLCgCtOU3ge84pS8yw1oGD5iT9p3k
	 wORwD/+q0NMY1LzWV9K3CwlMdI5zC7Ms16trHFmIfRW6YtNSz+zmQ2PHaRXvwRzT/X
	 NWVnhwzTFGfUrAuMDaO4o0abYOhx58XAS4ZGmfhTi5vpBSDZOlaGblU4/sAWg5gE8h
	 ngTpBX+0WyMIw==
Date: Mon, 10 Aug 2026 13:51:58 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Tal Zussman <tz2294@columbia.edu>, 
	Matthew Wilcox <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Christoph Hellwig <hch@lst.de>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] mm: remove PageReclaim
Message-ID: <annJYO2wOkbKZ6jh@lucifer>
References: <20260806-b4-page_io-folios-v1-0-0899bac3b826@columbia.edu>
 <20260806-b4-page_io-folios-v1-2-0899bac3b826@columbia.edu>
 <anYocInoXy7KRcZ8@casper.infradead.org>
 <1b688500-230a-4733-99da-bdd8adc9f67b@columbia.edu>
 <1439da90-292c-4075-82ce-32cb89505db3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1439da90-292c-4075-82ce-32cb89505db3@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: C50E94000B
X-Stat-Signature: tz1kdw9ttnw3biynqusgfo5u9rmzak95
X-HE-Tag: 1786366339-886683
X-HE-Meta: U2FsdGVkX1+Ata2CrFLeOaxw80sPd7H4+B8kHXMsIKut+Z+aY6Sv9FlWO2VFGcsxwY0K+xxavu4jkfMYXn+KMGtn9ELLHWcVLL5oldoMI+1GYfelli5rwqlqE+AQK7l4lvyui62ZVjnzaJxYOBdSymNqhyk5DJeEV2Pap6/+EGKd2sTOYO1igYHNpOpcT66iTy7tR9EORY4QGd9e8fb4Rey5V4cFsgFzi94ubSJORsuT5YT6tLLYEolqE2Tj/K1ijg/kLYcJCgQlrHLaU0IsUwOCROqxqVmy0cfc2vnc02X3R9kHYJ4dZJtaEBhFLiA1pFJZKrLuzOjJHSAxiTF/nuSUS66BHudEChgZ/q6Gdz1DcoTHZLVLynMsqQ4QetMdK/IGkUAHkszJani0DCaLA7oKCFB0EttUtlyu87aIRYsLBngUIfIMdVDx7x98VjPAcH1qA9Hn7A50MQpFhA2Szh0pw7oUEPsxl2l3Db3dsne9QWjXa5w1bMfuCI6w/qitgvNxdGL67FTJ5YJJLcymXbBuiz3iArXonzYhsFDyYaZ5uQNxREmS3SeKg4D+W7nV4kt5r0a2Fsn2W5273ST2td8SPrdh9aYqHyVFXMRMqpnFqNao0w/Gqgc9jhCE3VlcNI7WCjprCLgOic+BWbUTtQzfk0nWgHdYW6kpA6YDzaRN4l69bgDrm42jq9XJ8vSSJLPigesNitMRSeFRPsTw3nGEqXPJxL6/co9OX2qS50MDneNPycEwslQDfDQUGFJc8Qni9ARScltHzwhxrgdBKcEX89/lL4/dn2i5vFXP5+VFK0zKO4ehsl7hkJ33HLj6thfDxKx8JcT+VqCb30GW7Xx4vdF1tW27btddy++uAqqzKvW/TmgaHnMygZzOsY2xNEeD5W1ojlvQQYvmg0kNTmxWTYliuw/jo3IjZIFTzEQNGNKLaLPOhrnxcDdnTJnGwG4PRqIPKX7O3ZiCjrw
 9k/W6r27
 ktrXUQOdM+LGDWBD+mU+2dmTtfCtKGuvr/he12c5SYAaHCaHuAfk0OdojIX5OvV2lF0n39pLjpNTotFo8Nm5Vl1JRGhTe2dmYj6B5ONKOvM06i7HXoy6vr3JlLVeQNL+7ow2Cp0z4Mv2/c+7gDr+oln1+9XcvOALiLX1GnSpxBN5fbnvJxpKS93muxAuwPPaYBjTeGGDj8u/qwb9ZH8LFicWS/eNnM/VicS2RvIkzNq/EMIK0y/XeRBdNLTouGRMWW/27809PP+s4MYzardSdSgrII4y2A4f62709fw3JW//6zrvUIKNyEpcDbAev/Yx3E68BI6T/1H5Mmp67i8QeHqSSFA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Aug 10, 2026 at 01:38:21PM +0200, David Hildenbrand (Arm) wrote:
> On 8/7/26 21:27, Tal Zussman wrote:
> > On 8/7/26 2:48 PM, Matthew Wilcox wrote:
> >> On Thu, Aug 06, 2026 at 06:55:34PM -0400, Tal Zussman wrote:
> >>> This flag is now only used on folios, so we can remove all the page
> >>> accessors.
> >>
> >> And we don't use folio_test_clear_reclaim() at all (it's mentioned in
> >> a comment, but that's it), so we can drop that line entirely.
> >>
> >
> > Aha, I missed that - even better.
> >
> >>> -PAGEFLAG(Reclaim, reclaim, PF_NO_TAIL)
> >>> -	TESTCLEARFLAG(Reclaim, reclaim, PF_NO_TAIL)
> >>> +FOLIO_FLAG(reclaim, FOLIO_HEAD_PAGE)
> >>> +	FOLIO_TEST_CLEAR_FLAG(reclaim, FOLIO_HEAD_PAGE)
> >>
> >> With that last line removed,
> >>
> >> Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>
> Thanks
>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>

Nice! With Matthew's suggestion applied LGTM so:

Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

>
> --
> Cheers,
>
> David

--
Cheers, Lorenzo

