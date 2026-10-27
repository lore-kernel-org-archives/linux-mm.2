Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 85B42606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 04:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=AxUhhqb6
Received: by kanga.kvack.org (Postfix)
	id 7E6066B05C4; Tue, 27 Oct 2026 00:40:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 796AF6B05C5; Tue, 27 Oct 2026 00:40:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6ABFE6B05C6; Tue, 27 Oct 2026 00:40:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 45FEC6B05C4
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 00:40:20 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07C1FA85BF
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:40:19 +0000 (UTC)
X-FDA: 85367154558.14.BEE8EAB
Received: from mta1.migadu.com (out-47.mta1.migadu.com [95.215.58.47])
	by imf31.hostedemail.com (Postfix) with ESMTP id 6A50E20008
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:40:17 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AxUhhqb6;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793076017;
	b=ttkyX7Q8mQmp9EZyCRaOxrdUu9hDJbXvRbhwDAFukIfx9fDJO9AdthJ0pDsBCnVY0wCCAl
	yf25HP7CC6TJeUB2fSWdvLfbOUGOfxybmFHU+8pDlzTEOOCTXyLXeDFcOdN44KNfhO5F8J
	7yAb8L3x/BI4Ssd2OIxkESLPeOQDeP4=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AxUhhqb6;
	spf=pass (imf31.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.47 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793076017;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wVhySGQl9o0rB8pMhdyfDXMh7D/DmTgjZ/fmBI7bd2o=;
	b=EnhN/jmHxoxfJB/iX+gGUM2/FzcON8hcthMX5mEbxr4CJeYzQ3I/1vvkpC35UZ4dbV9LsK
	eMV8zAvNUswn2iBvufPSGCy4+N0h5SxCD/0tANBL+5qLHPCLO1P9wDnUw1oP8Esr1dOOXa
	pfDMKk+fwAsGq5yVx7sWGCA4wFJqOks=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=qE2tL1Fo3Dp82uNSJ3pSzSpKtJMDbDdNOIJXBRddZ58=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793076015; v=1; x=1793680815;
 b=AxUhhqb6k13lvUXylzJtO4aZeAPIZpxzUiUwZdxdsyBxg1NJLnFABudNqVxRHr3L/y5tLuDV
 DMf2BxAMO+xJgdznM8yo73zSH1mx2DkEHmBWzk42z5S4FOxuNU3y2KF36jnTi0+3cSaRxuZgBsf
 22R69Dj1EDZFpnNACcJxAoeU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id f24c8c8b657afccd;
	Tue, 27 Oct 2026 04:40:14 +0000
X-Mizu-Trace-ID: f24c8c8b657afccd
X-Migadu-Flow: FLOW_OUT
Message-ID: <e4ea12a5-ca26-4c1e-99e6-899eaea449c0@linux.dev>
Date: Tue, 27 Oct 2026 12:40:04 +0800
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/huge_memory: fix deferred split list corruption on
 partial unmap
To: mt4022@columbia.edu
Cc: Kiryl Shutsemau <kas@kernel.org>, Kairui Song <kasong@tencent.com>,
 Dev Jain <dev.jain@arm.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, Zi Yan <ziy@nvidia.com>,
 Nico Pache <nico.pache@linux.dev>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Ryan Roberts <ryan.roberts@arm.com>, Barry Song <baohua@kernel.org>,
 tz2294@columbia.edu, stable@vger.kernel.org,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>,
 Shakeel Butt <shakeel.butt@linux.dev>, Usama Arif <usama.arif@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, "Liam R. Howlett" <liam@infradead.org>
References: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu>
Content-Language: en-US
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <20261026-thpsplit-careful-v1-1-d357d70fd6f4@columbia.edu>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: rfmpkzwi135jity5m3kb5qgd4uonkpmj
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 6A50E20008
X-Rspam-User: 
X-HE-Tag: 1793076017-239181
X-HE-Meta: U2FsdGVkX1/bXSYHqZMzGVHChnB5y4xm/GaFtUQlteAXXjhypwAKa83SkwZ5HpRMop/++iflZddJcyDST0xh+Xsy65mISJddQ1zCoL4O+faQMplnzMmDcgcyP8tueV23NzyImSmI/yGXbB6pDa7lL4wIdmuGTSqqPdKrncVvu3b53UXmpJSAeDcOJYrxD9WpO1m5bLs6uaxMvRXUe46HjHyA+dSLvbiSKiTYne9jbB1+dRSIAC9xGSPV3yeaDbLnwDKCeYSdYau7gh2xNr7pOxaZVJpDU+w9S8ptyHwrh2SoNxPlpATL8/h3ltv0Yye9amPpSGnf+1rNUR2ik8DyUaIlkpvdo+kCF7IeeOmICp89lYI8CeLhu2XX/aB32NSg+ycim1z9o7+LcwVNIO6WVagNLjijABKXa7w7weN/sJumslsRDFa4oXYFi2PstMr9lHNAH2YrMT5TJVZmGV4JnNpyaP4Ydv8QBHOIu/0hHPswZMYGv4lP/RCwW2bllhIUo1KlMXIKXBmpHriCmhg3hzGjDo5aMnPObAbicDFtsx3aWXf7vd7fUSRvqewT2zSetC0mM8bQuRKwdOZqd1NTG1EnKLkNU8dKNim6ppS5QAzgFcUvYlyjrSrw2sjmXst+eG/IheSGOfgdZeXDXmnnrvUQ2M/5ZrtNJsI94mVopdU/SNMqYiWlIeRY9j6Lls+9dDPbJyGVzuS1l3JBmTzOD19zlim1BtvezZH8x0qDYViffc6XJ85eq6MxPOLNyXBGRLEY4eRBH9qnEk+tyNjdMNmIryYWiC0OaGhXtFxMg/FnpR/viX674WF3k7+XTUROCp3HtObQYt5PoquaOvBuq8e9GveiW8M2KjpLlsZZNp7tLwDiYvWcOuUoyZ4MoSx348rpjWlmOBdRPrHkFzTfIYqjXJl6Ac/vmPvO10fnt6oJx2UGC5jheDXjX4Twg9TrcNZ9+jsgslK0AOrFRCB
 RUMB8qJx
 FOyobwKwTU3IR3r4AKDSXMRTbvC5OfJbLANzBhigP9ZHfzYRhnfceCP4UVKDi2II+dHMPMnDC+gb28YlRJ/sGKtO9tt4Bg2saPmrsBbUz4wHwg8mnu3Ik9WCE64HZ/kuGsMNS6FF1OpFaXI5A5VNZ+CLPdPl17lsW12Ido43lMzhwBPfbZpf99ak8m6J0vsSPAQh9ptwA9H1qvjF/rHMXRKzUTgkRdw9a+tA9xVP8y5IOU4uLjsNcv2jTF7A2mMHutx9j30dMTGXYyP1Bbog8D4UDyCy4jGjAi3Dj6Migjz1Q015TlHJ8sA0kj+WCwis7A/GbneNftdcTJ31fIC/7mBqN8bTViyDdi1cuB3uOe/PemtTexfVDWgxdgcVxligfKLThBpFA4j2A0Sh78PU13AqBXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 2026/10/27 08:22, Mani Tofigh via B4 Relay wrote:
> From: Mani Tofigh <mt4022@columbia.edu>
> 
> When a THP is partially unmapped while the deferred split shrinker is
> scanning it, the deferred split list can end up corrupted.  With
> CONFIG_DEBUG_LIST, freeing the folio later reports:
> 
>    [  523.871401] list_del corruption. prev->next should be ffd40000005e0090, but was ffd4000000500090. (prev=ffd40000005e0090)
>    [  523.871412] WARNING: lib/list_debug.c:62 at __list_del_entry_valid_or_report+0x177/0x220, CPU#0: thpsplit/63
>    ...
>    [  523.900715] Call Trace:
>    [  523.901753]  __list_lru_del+0x5f/0x220
>    [  523.902588]  __folio_unqueue_deferred_split+0x238/0x520
>    ...
> 
> Without CONFIG_DEBUG_LIST, the list is left pointing at the folio
> after it has been freed.
> 
> Since commit fafaeceb89a5 ("mm: switch deferred split shrinker to
> list_lru"), deferred_split_scan() moves the folios it scans onto a
> private list under the list_lru lock, drops the lock, and then removes
> each folio from that list with list_del_init(), which sets
> entry->next = entry and then entry->prev = entry.  Another task may
> in the meantime partially unmap the same folio and call
> deferred_split_folio(), which queues it only if list_empty() reports
> it as not queued, and list_empty() reads only entry->next.  If that
> happens between the two stores, the folio is queued again, and the
> store to entry->prev that follows breaks the new link:
> 
>    Task A (shrinker)                     Task B (partial unmap)
>    -----------------                     ----------------------
>    list_del_init(entry)
>      entry->next = entry
>                                          deferred_split_folio()
>                                            list_empty(entry) is true
>                                            list_add_tail(entry)
>      entry->prev = entry
>      /* overwrites the prev link that
>         list_add_tail() just set */
> 
> Use list_del_init_careful() instead.  It sets entry->prev first and
> then entry->next with smp_store_release(), so once list_empty() sees
> the entry as empty, the shrinker has finished writing to it.
> 
> The reproducer repeatedly faults in THPs and partially unmaps them
> while the deferred split shrinker, run through
> /proc/sys/vm/drop_caches on the same CPU, is scanning them.  This bug
> was found and replayed using a deterministic hypervisor currently
> under development, but the non-deterministic C reproducer can
> typically trigger it in the 10-500s time range.  With the fix, nothing
> is triggered after 1800 seconds.

Well spotted!

The race window is rather short, I guess, but partial unmap can still
sneak in after next is reset and before prev is updated. We need
next == entry to mean we're done touching the links before allowing
the folio back onto the queue.

> 
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Cc: stable@vger.kernel.org
> Signed-off-by: Mani Tofigh <mt4022@columbia.edu>
> ---
> Reproducer: https://github.com/manitofigh/thpsplit-repro/blob/main/thpsplit.c

Cool. Your reproducer came in handy :) Hit the corruption without the fix.

Tested-by: Lance Yang <lance.yang@linux.dev>

