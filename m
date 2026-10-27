Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 84AA3606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 19:03:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=n+WA9GNg
Received: by kanga.kvack.org (Postfix)
	id 518EE6B08A3; Tue, 27 Oct 2026 15:03:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F0326B08A5; Tue, 27 Oct 2026 15:03:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 406826B08A6; Tue, 27 Oct 2026 15:03:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id E8BC76B08A3
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:03:11 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 66414A0B35
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:03:11 +0000 (UTC)
X-FDA: 85369328982.21.F89D5E1
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 8FE7D140007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 19:03:09 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+WA9GNg;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793127789;
	b=B5WFdEDa+lGOlMZoEtOZpK+ObrRLFBYP0LSbVvtjL/jQNVE78T5YT/0tPElTXfsY+WzrF7
	GFPN7zHEYOJJ6/RBHvkbndChbVrSrSIJPzLIsfkefxI9tCQ9bupxc7kAcysXUfjgTwtBXe
	X630OX1GArUft+WAxsZuV/TsoIV6Q24=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=n+WA9GNg;
	spf=pass (imf26.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793127789;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=z2aICW6ha5mvAYcJTiKr0lmuhUF+UbL5lXiLkXBjUAA=;
	b=ebH4daJi++XiKjU26XdNLe1+BQS7J43gdcUEBSYwNDQPS43fPE62GB5HhFtDYOzCLYqBj1
	SIyaHpW274h7PWc/8qFe5Ag47YiU5Ai0eLKPZWza0NgVvfF+zfa+1HNusQjwfBBXsXaMzO
	WsGETwmpS337BQaddAwxOIhX1BbmUP0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CFEBE43E79;
	Tue, 27 Oct 2026 19:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B14991F031E3;
	Tue, 27 Oct 2026 19:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793127788;
	bh=z2aICW6ha5mvAYcJTiKr0lmuhUF+UbL5lXiLkXBjUAA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=n+WA9GNgsZok/1bfEEz2jnBVNjFM9RCPATbiZ3nZjEc4IWyk8DMWmdqf4y0yDp3Nk
	 E7ZL/Uk8T+VM6ijsONiQbZMONfbqfABEznvjkqS6NgUU60Mz8R7vr7EWE6wSrS0cYu
	 OwDmo+nIMCV2nM9WmqsKwoTKI9VkjrpzGRkq2CmRQVTwXunYfm/9QaVTXJx7P7tClw
	 aQ3ETzz49IbbnD6kOa2Jki/Rp03R48LCJ8UDgkEJjnTqNzrU3WhDO3U8bTkL/ndP/V
	 3+OcMyuIwKPCmhg+/6GvyQ5ajb6AO5jG7HJepgBLRsF0SeSY/e0L7O0SIQavT4WGIk
	 5FZTSbuWwIhog==
Message-ID: <331082ad-d8ad-40ec-a281-b9aee72a3f75@kernel.org>
Date: Tue, 27 Oct 2026 20:03:00 +0100
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
X-Stat-Signature: bqi8nixzqux1oxbq68ttyaciumwa3nha
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 8FE7D140007
X-Rspam-User: 
X-HE-Tag: 1793127789-429773
X-HE-Meta: U2FsdGVkX18W8QYLLGittygOCQuLFqlGTOMknBzOY4aqnku0Ow9Jf/45Ig0/SuB6uV8woZ/XgIse46atJDRVwB621BTncF/F9iEWDKDdlZ4SipqHWicD5OSYD8yvqyXwfAPDbkvu/DkVLa64XRZvh997cu6aZN0E0IIr0X9MloYKAlWwmSmPsbBTRkCNbc1AXl41Cf6z+rVv2e44EmOk9X4dsNGJGt1/wgFB5oWeQmuq9VEAnIz0UyrRRDQfM4Omq6CyIygapmMoB8ixEMNtI48PNYRzid1ujk/x1MD4YewUD4nSkZ+bkCHn18XIZVQNRzIbkTnuaYuFmgsazvdeLbdE0yjQXRwYRYCMETioLzHalTsmbhCE1+oa2/9pkMH0nhcTADMksGzmg7K7wkC730M1U1KYd17e55CcTklmJGtuwXFAajhPuyFyXENhJ4e1Z6cHsdqjK+hCP1ZbrjLnSpaVgmB7VTHp/T5FDthIfjStVc+Pb9/nNqlno366Mk+lv57oDQaZMQT5oSpQUBUaH7DnGsaBaQG1i/GgI5aPKOcvy7A0AMyeUzXU5MQq36HicmixXPhFn3JHmripxEKIFP7cb/kmqMStaAzlIK/FRhyK+B9XMQAAT8Qw4zIyw5I9BnTE2FOk+sYjilHOcdl1cEx8KVvbgVVUxav7RUoRBXj6WM9vhkOBYWpOnwk3+tOk4VMVNbLTQkYJ03jNPHZ7eq2LXNbLAH8tCQ9InTg0fydfRYgXgjDMYNVNXZSpxURmbO8vRILtXJt+m9tVNBxAB7KSnqnPO6mHymSbu+IOqgFAYNerIEzZ/mFwOIxkXeTE7C8ZkYkJYjHhgC+4eXP8NxDPcjG3dmzI3+5Q6M5k7azLBcD6UxIyD+R5a0/z+WQE9d4PdSXIT3mpA4HpmXjEDbuQAgUclrvK9iqzBVFIvh3dx3L5PG5I42evVs3r7CLz7rvyWkOVZNmV1CsZsBc
 qAq+SQmb
 i7fYjcb7+3NmcxbX90aQUVEOb8A0K8VtJMDxOrJfd6GzmxL3Lu0Yee0jerro8CfOh0DXbyCxx3p9UOoeBbEYcSduXQ/A0RgVLgrpq9Rq4kprn6QbXsL+/BfaDRYlzkO8FhH4/Jxo1WlesPVFZLq12+mFTyx9c/+x/c7bjiahZJIwsq+DAQ4117bioNPtzJ7rZ+1/Lz3JHCSDvuorWNSwCKaacjCMOYaNjBMfiyVHkPGUonVhdBUtlK0s6qEGA8h6ccFrPHM5Q3X7kn71a7G8Sqd0Z6W1jbePBLwn8wihqmU9P1bH1FY95rvkCmRtTMlJ+1VGhupQcSmRfSM+WltoWIFPPPm/CY3r8892NjxeHmIu6Bl7vhhjW5mmj4sT9J0BYVxQC1dtiBMomjYj1oEfsW2HEgMOi7T2BogqhLzGSmBEsjYIDayTFxAz4MBw3CD1Lp0KYY3nGpz00JbP1Oe5AFi3z3419RHwfKaGHP5dnFax4IS7Uo94OVvbdTNYg3Uesm/FugBOKTauH54KMU+DR9UlgYNi4p3J/447BRatzJcd3CsFCjqkJFj+RVQEmTh6fNqces5S4ZxFROlA=
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
> 
> Keep page_cache_sync_readahead() and wait for read I/O with
> filemap_lock_folio(), releasing each folio before moving to the next. The
> existing uptodate check during collapse still handles read errors.
> 
> Shmem uses shmem_get_folio() for swapin and fallocated folios without
> taking mapping->invalidate_lock, so it is unaffected.
> 
> Reported-by: syzbot+16bf7cd0ebeb1de93aa5@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=16bf7cd0ebeb1de93aa5
> Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
> Cc: stable@vger.kernel.org
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

As discussed, this needs some rework afterwards. For now this should fix the problem

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

