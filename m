Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BC067606A327
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 10:15:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=D3YOFm/y
Received: by kanga.kvack.org (Postfix)
	id CEBCA6B0991; Wed, 25 Nov 2026 05:15:55 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9BD66B0993; Wed, 25 Nov 2026 05:15:55 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BB20D6B0994; Wed, 25 Nov 2026 05:15:55 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7EA0E6B0991
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 05:15:55 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 9EC8E1C3A9C
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:15:54 +0000 (UTC)
X-FDA: 85473235428.25.B71FD05
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id D7EC4A0003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 10:15:52 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D3YOFm/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795601753;
	b=kyg1SL7NCf5F6vPzAWZopWnr7OSERrWHwaYO5mQ7mJNQO+3FWIxvQboSz0gJDpgCWRCNhG
	KftUh7auUerfXp0c4BVsNAtHVN/v2Gkjwum6ZmpSXQ8bw4mOesy2On+4drzUM/trkYvcGw
	ckNZ3O1UIeOiBEENgA2AH9Yk1Wss6WI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795601753;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l39RWAIoM0Feov+aApkur4PMWRZaz1boBdpLerg+atQ=;
	b=WEu6L270o7vMFyGbfMpD0QnsCotHBmsFg+9IwXGoyiedCtrRhCQh2YSh5B+n3Y4InXUtWa
	NWTVgeJ/QhDU6g6Aemj3RxnzxFpLQMtzCLxYVRNK7aVYD7ps9uF5C1EaSzaoTXCqiqQcNe
	IUDCw/5NvGUGHSgcC6rJ+DCTLXP9AIQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="D3YOFm/y";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 574AC62730;
	Wed, 25 Nov 2026 10:15:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BEA71F000C4;
	Wed, 25 Nov 2026 10:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795601751;
	bh=l39RWAIoM0Feov+aApkur4PMWRZaz1boBdpLerg+atQ=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=D3YOFm/ySUL4vtdQ93vXOYE4eaJx7lXYk7wbNG02vLTCaSmnKkEJb73/R9UesQF0N
	 MXWPx9EqWhxYAtjw9V2YaW2IY6bjW+n5Lgh6LCX4p5OwgG6Cgn9nzmmy3+Zt3Kw2jw
	 vGBJkbKom8dDSMX5DIgrMyYW0hBe3H1iy3nRDuel7EJQ3uX/aF5Ke/epiCj70gdNGy
	 JGs1h0TBDg/N/Hn4HJ58msXffhmzZoIbXDNipV9FEDk/Jtuk6L2MAusPGJ85VyfqGF
	 9Mlf7Sl0S07yyXcd8TY6Yl/qy5l7kwOXKhH64/hXTmHQFNRe+Cnv7DJm2N5UHRYUw8
	 a6gDniprtSkAA==
Message-ID: <e85a2666-9722-420b-9a60-9d4251fc3d4c@kernel.org>
Date: Wed, 25 Nov 2026 11:15:33 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 08/18] mm/mglru: make folio lru referenced times count
 a generic API
To: kasong@tencent.com, linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Johannes Weiner <hannes@cmpxchg.org>, Muchun Song <muchun.song@linux.dev>,
 Qi Zheng <qi.zheng@linux.dev>, Ying Huang <ying.huang@linux.alibaba.com>,
 Chris Li <chrisl@kernel.org>, Baoquan He <baoquan.he@linux.dev>,
 Nico Pache <nico.pache@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>,
 "Liam R. Howlett" <liam@infradead.org>, Barry Song <baohua@kernel.org>,
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>,
 Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Nhat Pham <nphamcs@gmail.com>,
 Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>,
 Gregory Price <gourry@gourry.net>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>,
 SJ Park <sj@kernel.org>, David Rientjes <rientjes@google.com>,
 Yu Zhao <yuzhao@google.com>, Vernon Yang <vernon2gm@gmail.com>,
 Zicheng Wang <wangzicheng@honor.com>, Tal Zussman <tz2294@columbia.edu>,
 Kairui Song <ryncsn@gmail.com>, Xiang Liu <liuxiang.277@bytedance.com>,
 Ehab Ababneh <ehab.ababneh@intel.com>,
 Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>, Lian Wang
 <lianux.mm@gmail.com>, Joanne Koong <joannelkoong@gmail.com>,
 Kunwu Chan <kunwu.chan@gmail.com>, Hui Zhu <hui.zhu@linux.dev>,
 Maxim Muzafarov <maxmuzaf@gmail.com>, linux-kernel@vger.kernel.org,
 cgroups@vger.kernel.org, damon@lists.linux.dev, linux-doc@vger.kernel.org,
 Tianyi Chen <hi@tychen.cc>, Ridong Chen <ridong.chen@linux.dev>
References: <20261124-mglru-fg-v6-0-8ffea39934a6@tencent.com>
 <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261124-mglru-fg-v6-8-8ffea39934a6@tencent.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: wedxp6n4u74jdaifniokabzdy81pib3u
X-Rspam-User:
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspamd-Queue-Id: D7EC4A0003
X-Rspamd-Server: rspam03
X-HE-Tag: 1795601752-544142
X-HE-Meta: U2FsdGVkX18oN78DIqihJkPqTmOA5pRAvAv5Qo3aJ8Nm5JZ6WC3gqkLFYP5KhcVqC4KzNr4eBdyb5P0KcOcy0R7a9NASoLUDUdsd4ntRIYkmwWymrVnAnM5QxFbcqTlz7zzejhaTRFEeGaQ905mFd2AknlqH/rIIc6Xs9Unxm4JGtvlbzD9WnhO8VFsBVclRu0PKQONmHjXf0nINUPodu1SiE8a61eoGmkiQoxCZkSuSNALiaJ5HUzhYPKqf6CF+2HEyuHcIlY3D3xQ5xn2zrVjwNe5o9LZjQ8opqLi7s8W6s1pyVG1czVTHXPmukYFzdqP3taaktyptMy+dtD92uLolYnu+8CAW5k/GmFEoWIb3MZQq0tVf71mwY8Ba3Ynk/Jvx0uHFp+zFxC54uLO7OxCaeTXBPOXKuC4DNfYSMCMAbWU58nojhrw7sIn5rEOLorcwPxRABYV3O0z4JH8bOtHhoVh2/uHer9SxstpZmMbtGVwNRfHs7Udcc3hqeaVFhIvCsUYqSeJUm1/eC1XSFjJggrs8OAK3nb7HILPn4aIg0hVJ+j22MNlHC/Cy+VnqT2O60N5qOuZE7Hqun6LcbgS1ucPXTkDSKsZMFzd/nXVQhFvmqu20wFTmwOH2cvfGlIB/zOBs0wlgt0p9kzDrKnt2gNErfiJ8mtXSNOLRDsO1RhhxWW3K4owLZ/wiNLX4dF4flqvttkJ+FgVvf6/H4pwFBve2PzVv0kz6ZkuoAqCewzhyDrw3roFFHlKpQwTejTZyZ6LsEPVf5tt7q7hCE7a0slZQ4Rb0qs/1UcJFLjkiJsqtSFm11Vv3gZ44bOM38xDv+Y9LT3xdlkudiNrO/6r6X24Ek9LduQv0MmfYnBxNI6GYZF++AtFv0se+c+ogh6Zd26kw3fuQyEg4/AD20wlI+42AW4+FXxOIUAyhxTMVRkUXePH3AZA5vkGGYRWL8aU6lFj9pq2sPqBIqdd
 izcjOuvH
 fiijl5DXi71LH9h2wqdn4udV30ygH73032HiohmlDYTAc0VYYevRRuXt55S0Q54iT1Upfkge4pASgIOZ9vqiGGuv7YkCmAjaHpLr0XhG5dwENa9Y+y6OA3XOfd2mJrhEk6zbA7LVi2OeL7jHWN7zLxSjtpSV3v5gByWshuftmdXgllN4E+eHZ72R4UqxeYUNIMw9bnjC89F+6ogAGaYY/wn/uBhH6a6qsM6Rw5C/I3znlo8xbr8XEgnyuQZA6F5F7jkLzNiYWce17HWlWIE4gYLDbtZO7uuU8biLh15SwUnuMMb+ytmFmXPuo/3/D20BvvmzK9+Z2xlGkUvvuhJtvcz64Mk7+AanKiVta+RZqbQhyrJOjsG+Z6qwJd5rCMBOL9yIeSh2Fj0gi1LwrNM2eRjEBph0Cj4uaDgYJ5SIKOGo/iJbDrE8MsUGli6MAuDRFCueNo0YcwaXr2GQfqlYGBZtwef8smBXSwH3PSs1aFjYXBnPR+sLz4/DyLexbpySJK0mSBi1eywiUmTuaH2XJZMnLSClQ+v6gygSCWg/3wfFRxs7lf05HZxsokEskk2nHgRdhkkYbhEeLnHjRMC4v8yOk6NnAncbRek8t+0lBId73bvfKla1lH/DKHYTspo7qUOd3nutU9Yz/p5whbjazwdIalfgvh7py/gXeLt3wApvtQZpceabrcvkJk9VWHV6ykM39mS4syJdytgv150Gl4Lw/LA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/23/26 19:53, Kairui Song via B4 Relay wrote:
> From: Kairui Song <kasong@tencent.com>
> 
> Pure code shuffle, no behavior change.
> 
> Make the folio LRU refs helpers available regardless of CONFIG_LRU_GEN.
> Without MGLRU the extra bits are never set, so they are inert. Move the
> lru_gen_* helpers into the CONFIG_LRU_GEN section.  This prepares for
> unifying the API for checking folio referenced and workingset status.
> 
> folio_migrate_lru_refs() now migrates the complete refs count,
> including PG_workingset (bit 1 of the encoding), bitwise identical to
> the direct copy dropped from folio_migrate_flags().
> 
> lru_set_refs_flags() skips the nonexistent mask bits when
> LRU_REFS_WIDTH collapses to 0, preserving the two independent flags for
> !CONFIG_LRU_GEN builds.
> 
> Tested-by: Zhao Zhenzhuo <zhaozhengzhuo@uniontech.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Tested-by: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Kairui Song <kasong@tencent.com>
> ---
>  include/linux/mm_inline.h | 55 ++++++++++++++++++++++++-----------------------

I'm starting to feel like all of these mglru/reclaim thingies should go into a
dedicated helper.

Can you do that as a prio cleanup in this series, so we don't have to mess with
mm_inline.h in later patches anymore?

On related notes, can we move mglru stuff into a mglru.c ?

-- 
Cheers,

David

