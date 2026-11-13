Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 82C14606A89D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 21:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=AX7USU0W
Received: by kanga.kvack.org (Postfix)
	id 9425B6B05BE; Fri, 13 Nov 2026 16:40:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9197E6B05C3; Fri, 13 Nov 2026 16:40:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7BE386B05C7; Fri, 13 Nov 2026 16:40:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 532CC6B05BE
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 16:40:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CD827401B0
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:40:44 +0000 (UTC)
X-FDA: 85431415608.17.99602B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0C5A51C000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 21:40:42 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AX7USU0W;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794606043;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P1llZ08OdgTejftE/Zr62LvYnJQ1b5X/QxBDEpfHpvw=;
	b=NfghBkHEjb7ZdblzVI7EwwWY6mqyBFPwMMZ4GL/jkr4vukf8gSJV48j8m68JXv72VpIs7S
	4MBfemyBaIyd7+5mlSAwJib/6+e+5NMsoFyIlEwmEZVsHpO+cbqFMRh7lsNSCiUlWiEUzg
	/f7pf01llQRkgIEXSVdMC5qlnNFzDuQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794606043;
	b=e3rf5GXjwpRoLYAahOhokNDiuFe2z2OHFT8gW0MwC4K3V7r/zntiaSrkuOiLEyurUZhv2y
	V+6AoK2DiYPjv60HM3SsXVJw1GmUImA5o+BbULlGoci+g9Nb819uK3r56JUUVD1Njc+2JS
	IYN53POwGpYptp+smK3TIr+KkwFlVjI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=AX7USU0W;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 904E361D0E;
	Fri, 13 Nov 2026 21:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9E3E1F000C4;
	Fri, 13 Nov 2026 21:40:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794606042;
	bh=P1llZ08OdgTejftE/Zr62LvYnJQ1b5X/QxBDEpfHpvw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=AX7USU0W6anKzcrRLBQdaC+yiY9KxCD7w7bGRNj34mps7b9sCJ+2njdozvZ13Sv1A
	 5DEDBAZhp3CXzv5xyTDwgeoZEdbYxI0DEqB8UPwXkShseY9DviUFLkgLvhKa5dzRNk
	 FBMClX5B3CafyBUJxjxN9G59blWZ65JOyNeG7C/FsdXwgJhvHHZoAyeubc9amyjPSa
	 vHyRl/Atlq99zIEelKyRYEZkEq5cvRQWjoQE04E0afBOxxVvDbjB/cAtwu2wojFuP+
	 dAaV8d04vYXJHYY+LGgbGGPOCbZs0Ig8eawUOGcsrznVXljCcs5/u+Tq5wbQMDikUO
	 IHoYdJ337SSWQ==
Message-ID: <0cff8050-24ef-47ff-b107-70a5acdea631@kernel.org>
Date: Fri, 13 Nov 2026 22:40:31 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC 0/8] mm/huge_memory: clean up and speed up large folio
 splitting
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>,
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Matthew Wilcox <willy@infradead.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>,
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>,
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>,
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>,
 Baoquan He <baoquan.he@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>, Zi Yan <ziy@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>,
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
References: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261114-swap-thp-split-v1-0-dfa8d4fa448d@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 5jiaij3jtgogbb9cjfj1c8ussp4wx86j
X-Rspamd-Queue-Id: 0C5A51C000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-7.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794606042-61231
X-HE-Meta: U2FsdGVkX19dVl2lY5uoGle2uIzmGBmwmWyfchia8EHaVJeXZ0Xc3jAs5XIKvxpXj4Zag+xuLmnb9UTQTOSqIzhFWOXakJCAktDuQEWsPdk/6rFeHcagMRavgbBO0Q8UsFgVOxMQPoySukZcce8GCEvREuKHv2c8rNz+Adr5R3nYB5O14I/6GRYrEhkd/eu0itJ9/z9MOTAMKRJkP+zNE0VpY3enrbmEUL95isgtRBGXPYkUx7PJ771YSdWGDFKiikUfveC/uuQx+o1P3G2GulNUUUkSejvIL+QtBA9j8C40D033bjxx4JLaKA0PUUgdvjcAu2wJ4LP5BNxNfBW5RNh7CZDbbMz/ov6/VzbluWDK48fuRpsLO+V5HW8d9sOE+6Tn4HxjpkJ94uXMWfVrHQgsvwsKumbvdKi0n4gzzZPEbUnNMctFA6vIxe38Mtt3UZ+Z4JY/urho80iiRaWZdRhnh4J7DTEXJ7qU3kT80o39Mf1Ynb1zWu7rthsf1mF9iZ9OYLh4jvH/CKljIamtPehKG4gCl1YrEnSXcTRKjZ+TSI4sTzN+zQu4Q8pJGFnqEBnaiu1IgXtWs82RBBy7pg393KdTa/vIF4ayDR/E6fgSr2JqFcYoobR8MfRlAJXwT9fj695NvnpeA4GZBRvpKi/CNdVLytVY9LOeW6xCgcKt2C3aOt4NfsJ5IRMnZHZtbN9YHWNs0N1iGPSdwm+5heUeYrwPMfdXKqeZ8Tsab3Y93RhunI1MJZrzJFi8o0iv8fuS2hQ5sCBBVwLzwv7Xl5OxAPgBr+cGgr11xljUfuNldv3ohwh/eEo02cDsU5/TVKT21QId3ysz8vhHmlwkII2lSpYNKxX/hSZt4A0jLXlcaDBxl/dbRYcpMpXK7VVHTU6NQ48Q5MBByKTaVCoNF429Q2VbNqTStOSfPyKw9M3SfKC8qPjbecOsBcKpeG2Daqs2yUiHj0chVnmUOnh
 DtSe6+B2
 YQt8Mqu5q31agdgz1GWdz9VfvyTJ60rvMGOLSW6y3WjD8+oV+PiPn0bjqrfKcAqmdVqGaRylbGpRD76v2JERtvph2ZriETdNm2P4vzftEhDJ/2f/FDW969gSY1mSwRmLrG1dYfKoUPDGbwkL9DmE7PnmCQo98MiMqsj1fSnFkBM9dguGTMJLcTVQgdS3jmp/c4HcnTypwTfMqePB082xk+3Iy/oh6dtr7yTJLqmzyivPNOrC+Qfp9LntNrVCLeQWlSj8HbSD1WLw/fgamjn34aUlrNrQ/Rn0OdaUetSiSgHXENurFrkK1e0BBMDyJcHyTrOBOHXPKUh7VpWs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 22:26, Kairui Song via B4 Relay wrote:
> Hi all,
> 
> This series slghtly cleans up the large folio split path and reduces
> its overhead: uniformly splitting PMD sized file folios to order 0
> is over 20% faster.

I expect (well, and I have) some fixes in that area, so we better hold this off
for the next week.

-- 
Cheers,

David

