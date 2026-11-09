Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8801E606A326
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 14:13:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ctW9LfKu;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sgnxScPO;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=ctW9LfKu;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=sgnxScPO
Received: by kanga.kvack.org (Postfix)
	id 973BD6B05BE; Mon,  9 Nov 2026 09:13:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8FD1F6B05BF; Mon,  9 Nov 2026 09:13:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A0576B05C0; Mon,  9 Nov 2026 09:13:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 4638A6B05BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:13:43 -0500 (EST)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C2F011A06C0
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:13:42 +0000 (UTC)
X-FDA: 85415773884.18.C2A054C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6552F20003
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 14:13:40 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ctW9LfKu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sgnxScPO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ctW9LfKu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sgnxScPO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794233620;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9e78KPc8jahAevPotNvn6m1tw9CTzVGALrHqcnEIRm8=;
	b=RPA/n/9yitF/2bUKOlmL6WVmswXHgxfSkgUlmFx6SGQK4IvJFDH7dqH1RzTnAAquT9VbRV
	1Kt1uSHlrupCYUqUDRiMJEKtZvIBRpKSTlgD7CgirC6+TKWTZLDk3PI1N/DHgEIr9hY6Hj
	Atltw3OyqDnvYvcW/HBXsSP20EQiE74=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794233620;
	b=reqGgYiOtYw52ltSDH+7N8KFe2T9MDJkFbDlFYIZfensw5FXwYWNtRRVpIzvBkQGL3rEyz
	8trm3bLHflPvHyeU3Pz0l7CATtlJjkkqCmsrXSpKBF5hOKilC8RXOBwgvCIlOKuJ5EoVI0
	zRVBAXaaa9bfaGDLRh0P6muhgp9kWzw=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ctW9LfKu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sgnxScPO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=ctW9LfKu;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=sgnxScPO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf13.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 777461F7BE;
	Mon,  9 Nov 2026 14:13:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794233619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9e78KPc8jahAevPotNvn6m1tw9CTzVGALrHqcnEIRm8=;
	b=ctW9LfKuSTMcAiN0bPE02eqSR2r4e+pePA2C1iCM/MZTACcal+F6SuXjhJNKthku7GM2Oa
	27y6SERccF5Nt4crrWi/yk+DEzmUAiRfp5EvetlPEZO/SYoNq+zTz8qXDgaH842ga9hAnV
	e+q8MWGq5RlVFsWki2yBf0FBGzpJO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794233619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9e78KPc8jahAevPotNvn6m1tw9CTzVGALrHqcnEIRm8=;
	b=sgnxScPOMPTqiKplWt1uH0MVtAlyjDY3axAhU5ZrcPD9hlDe/0FiPDIa5SCnJD0aAcFdhu
	aDNjHEvLskTxU4Bg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1794233619; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9e78KPc8jahAevPotNvn6m1tw9CTzVGALrHqcnEIRm8=;
	b=ctW9LfKuSTMcAiN0bPE02eqSR2r4e+pePA2C1iCM/MZTACcal+F6SuXjhJNKthku7GM2Oa
	27y6SERccF5Nt4crrWi/yk+DEzmUAiRfp5EvetlPEZO/SYoNq+zTz8qXDgaH842ga9hAnV
	e+q8MWGq5RlVFsWki2yBf0FBGzpJO6s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1794233619;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=9e78KPc8jahAevPotNvn6m1tw9CTzVGALrHqcnEIRm8=;
	b=sgnxScPOMPTqiKplWt1uH0MVtAlyjDY3axAhU5ZrcPD9hlDe/0FiPDIa5SCnJD0aAcFdhu
	aDNjHEvLskTxU4Bg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2C43F13319;
	Mon,  9 Nov 2026 14:13:34 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +AxLOw3V8WqDWQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Mon, 09 Nov 2026 14:13:34 +0000
Date: Mon, 9 Nov 2026 14:13:32 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	"David Hildenbrand (Arm)" <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Hugh Dickins <hughd@google.com>, Chris Mason <mason@kernel.org>, linux-mm@kvack.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/2] mm/memory: refuse to map page cache folios that
 are not uptodate
Message-ID: <avHUz0yxoQ2Ny4oH@pedro-suse.tail5790ac.ts.net>
References: <20261109120403.82361-1-kas@kernel.org>
 <20261109120403.82361-3-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261109120403.82361-3-kas@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -13.51
X-Stat-Signature: sa84p8cbbw9to7e44d4px551uugamucb
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 6552F20003
X-HE-Tag: 1794233620-69493
X-HE-Meta: U2FsdGVkX1+Hjo/bADjbzClRZ6BH7TmRkLCctBhE9tpXCpXAo1qdCYSV0IVkFkSvKGJrkigQEoW7KV533U6RvdePHSkYJ398wGi3Tg4c5xsGCWrT2aWZ8DHksyTTQwt3++ClWcnZ1zW7N4ZZkgSrPR9oZrXc+//VXKOJ9FIpFZIDnePLkHxnPkYjoPKubBKGHyGntSlrIj3VSsAwBQOaolvFclc77esIwIYokkFq/YNtzJTfArf4J9Dw+cZXPmrIVstP0s9l4AHemhrBBbpeunU2x0ZFfzEV/obPvn8PxO5qFZOdP5cTG9HEfj5jkir3tzPL/DlBkqQldDyaQv5eZvJ4jlCq2sE6C/7og0qb9l8beepyK3RKksnXfQJCbqTKv/ZCRAdEuKnBRuNw+rTn5KqH22V1MTHvWaBdL5BGIZxkwvLEFFPT/tJLNDdNzanbgv4FAc0ykn0P1D4KppUyu/CYnutMEaxplWsq8tErCz3wbdl9PfyCMxOBEzklwzuGo2lTRmYTejenyr41uQ16hUkM2NR+YbR2S2TlZPQlgEDMjwPmidVbE8OrmfSUafryxRwkIf5cDZ/W2iNdKmKxaEJZWpMRU6YajZ8wJIq2y0u8smOt+LJNd7AY6YD7kUuMVgyY6gjbGbIH8h+Ot8Qx67NWl18ONi8FjcOjVaQhsLi3ygVXd9cTrxv6jXYp0g8g6DphhgLTDw0w5PCaj6B59dRTm5IRkpM3+w65As8ktzH0+qcx/aQsLJBmYOPprBh9VvMHLtgesox14ZfUFgseCih9HzLnFPQqYFIt+SeCKTAjPqoaOpdm/HHzJTQweyrvoebWxv16A+VtQ9G3BpoTr4PwTlgxAFRO7E1uMliCdKvyK26xHDld+l63zzX45T9LXkD+LQfz5+MIHNdnteZHv5/uPBhJDPRbL/zToMcSANud94UwzMCSXX8i8pXdLytqsPmp8GNIITV+NziNrpK
 EbQSXg3k
 JDEd1GYir65cBA/IpYBZ/TFWmYuWkA4Lsz8aQlF5mtjvRh4ah54yp0xCkeLyGxizwuMSWLneDOStJZFaJSGBK/+aig4ZT1cYOJqEqao7zA1zjVOLJ1IXw8oCWuDDopH701NaGujgnuKarBwIDZZAuVyTi3Z6fEF8159zpwnDeV//IIDSlRt4Aqh78PHsVLukybUHwrAaJY8Gis8ARJ/ykdz6T8yaWTDneGewIBRxmUhbYnXIbLmpTMUyvbLXiKov7XMacOeGHGoGxPqf4e7fIasD9K15t2lF+Qkxa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 09, 2026 at 12:04:02PM +0000, Kiryl Shutsemau (Meta) wrote:
> A page cache folio that is not uptodate holds data that was never read
> in or cleared. shmem fallocate(2), for one, adds such folios and clears
> them only on first use. Mapping one hands userspace whatever the memory
> held before.
> 
> Each path that maps page cache checks for this itself: fault-around in
> next_uptodate_folio(), a fault in filemap_fault() or shmem_get_folio().
> Nothing in the mapping code does, so a caller that misses the check
> leaks stale memory silently. MADV_COLLAPSE did exactly that with
> fallocated shmem THPs until recently.
> 
> Warn and refuse the mapping in __do_fault() and do_set_pmd().
> 
> __do_fault() checks the folio ->fault() returned while it is still
> locked. do_shared_fault() unlocks it for ->page_mkwrite(), and a
> writeback error can clear PG_uptodate after that; that case retries the
> fault instead. For CoW, __do_fault() sees the page cache folio that
> do_cow_fault() copies from. do_set_pmd() covers MADV_COLLAPSE, which
> maps without a fault.
> 
> The fault gets SIGBUS, as for a folio that fails to read in.
> MADV_COLLAPSE fails and leaves the range to be faulted in.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>

Awesome!

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

