Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E16EC5B56A
	for <linux-mm@archiver.kernel.org>; Wed, 12 Aug 2026 09:39:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E1046B00BA; Wed, 12 Aug 2026 05:39:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1B92D6B00EF; Wed, 12 Aug 2026 05:39:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0A62D6B00F1; Wed, 12 Aug 2026 05:39:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DF54A6B00BA
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 05:39:06 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 629991C0942
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:39:06 +0000 (UTC)
X-FDA: 85092118692.28.F765BAB
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf27.hostedemail.com (Postfix) with ESMTP id 4F5D740003
	for <linux-mm@kvack.org>; Wed, 12 Aug 2026 09:39:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xiMd7nu9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cxJDaTPQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Hrix0hut;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oQZNh6q;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786527544;
	b=pBGFK0hMAL5xaTayZW170I3i79bRZWEKd+RL0p9lnIFK5y4FZR/PTFD4J/MovaqAyc/4RL
	YRbBBDSSmFdKmgcskVA2h7JOG7DgpX5pfj8tnr3ntRu5dGD47kCfFg9cep/j7/CAaBZtwM
	j3TEIIz0qM3SzKDmXzx+a9WXNjsseZY=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=xiMd7nu9;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cxJDaTPQ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Hrix0hut;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3oQZNh6q;
	spf=pass (imf27.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786527544;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YDyc87rtaYvBOaEu1VDS0tXBuH6KkTDubLpiL49NFJY=;
	b=zYavZA9lB9v5haxsClirD4bOLnpdUBfwIEoV+ARkqe+BY4ssikpEcRg2W1RVcIxRdFXw7w
	/NUfKr0Djm9Mo0Z6DJHtvh5AepppHdcZdPMT80VmYKnqr7hlT2BabFlYOMmnLddnWif2xa
	cFCCpMZVBKzBHwA2bXalawSESxJ09pM=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D21F821AD;
	Wed, 12 Aug 2026 09:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786527538; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YDyc87rtaYvBOaEu1VDS0tXBuH6KkTDubLpiL49NFJY=;
	b=xiMd7nu93CryAR2rFBoBVW+cmWLhGAcjylTTcp1HZHZdt7pJtdoKCVNHhf/hBExlYBjIHY
	xnsfYmJ7joAVKeARoJn3khw1yzgw8psa79skhSdQ8yFHItLO0x1LuyGsNBMy0edoBG8E+l
	H2Pf+MK4EmeU53eURjDTUllzlpNpOAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786527538;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YDyc87rtaYvBOaEu1VDS0tXBuH6KkTDubLpiL49NFJY=;
	b=cxJDaTPQ6hRNHa/34EViiEdgcS6MwLw5g9YugF2yYnhFCHq2ci5Kk7TUtGuhNoJyfUDx1z
	uZgiDYiK7sJnrUAw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1786527534; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YDyc87rtaYvBOaEu1VDS0tXBuH6KkTDubLpiL49NFJY=;
	b=Hrix0hutKT3vVvH62mE4PMdM32mB1PUYRldKmXEKyENCtTlrosGIKa62RZR1jyRSVOtSTG
	N/G7JmIwe3RVs0CXK4Mq8sMXziYgbf3a8zXskqyaR1qT1SFeiIuEh2F20VukrpwrImTfkU
	dbS4C1vJl2pdPbXopu24A8DO+UFtXh0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1786527534;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=YDyc87rtaYvBOaEu1VDS0tXBuH6KkTDubLpiL49NFJY=;
	b=3oQZNh6qCrTjPqwipueFCeCoYzB5Oce7/z3sSBJIEsinoPWyoRjHZWDEHI0G58roItWBoi
	iamTlsCp0OK5aGBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2ECA0779B1;
	Wed, 12 Aug 2026 09:38:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id gK7/By0/fGqrBQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 12 Aug 2026 09:38:53 +0000
Date: Wed, 12 Aug 2026 10:38:51 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: "Nico Pache (Red Hat)" <nico.pache@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v4 4/7] mm/khugepaged: fix outdated comments
Message-ID: <anw_Fh7bBTPmmNQ-@pedro-suse>
References: <20260811-khugepaged_pte_refactor-v4-0-ddac39d61c4a@linux.dev>
 <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-4-ddac39d61c4a@linux.dev>
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: 4F5D740003
X-Rspam-User: 
X-Stat-Signature: tguwj6rirwhp1aafpo5byg78ra5m41dk
X-Rspamd-Server: rspam06
X-HE-Tag: 1786527544-631350
X-HE-Meta: U2FsdGVkX18xGKGujleYUSaAOPX3k8KDpwiGy2zx1M5IYf9Q0NcKVyGt+dmDj7icEnu86gt+/O9rejSXn2RDX194zUXFUGP5QMZ+dcGpHQn7iJbbLwfEjOxm3pEn7ZWNRBGkZE4PowSqcPWcasHEd6P2Xxies7cpeK7eiT60rwr4U0XCXupXSxn5IyjBtroSeZvXSX+KbrlJNLazNMYb/MGPI7jfAR/SjMyorOY6Z2LlwQdUTWdXjzPH4Zi8dYF+h03kHDIymTste/wZCT1CbIKizYe9j26Ya8tWGI8UtTASWISMcdlmibPUapIEZB8OAawJfaPUBiWKRZc5GGL+HKwLO0EA/3Pp6XL72IuIDxGxVH4ZnPWf6OjKFTVGZaFngymCZLVxrTc3Ra/4G1mbsU3v20mNyp4R6Vq9HsxH2qlGXzEQyBQyGeqQhixSGolgzqK+DZSdTb2Q0NcVKOQJeJ1LuCvF62JcLfa0GITV877tNDupZvkY3CrWuZDfxrTaO8MhtQi7oVr1aWuaMjA4Jemtkegxn0IQlptWHSpHEK9tLLM8NrCeoswDIusBUaUDuFOI9gw+XE6KPZBki9tnJ6PgBZ7mHCzY53qSo63NhsFn4JSsiGhdCYMdSH/VKQr4+gaQxvrZkGXgwgNfTfyR85BBuyY14ioha8ZJydliL4G6ik9wo2rRp7jBBVHQ9F8ZMK0hqZJIa9YOKgGdbHCXGatOHEW1934bHiZbT2qrTdoH3MDJWPz/uY9hmER0FeoYBJIniSvzbLehP011OeYOhfnw2DA0oLe6VtT1aoXTguiZp2W2jhP/hK56cCwyx4e5bkcRt6KpJ+sIBToahfhVDm4BxyTpv4hp6Cuv5Zi9rWras0jRS4LJX1CR0umPc1CDiDXZu1O6N2g/rdTxk7U2VBXAbm4Y1rvnudPomabWL5kzCzS3vTFSTzwzgB0wp1RemKeT/4RpSsgUfzM6VmD
 N1vqx8zH
 Y6BaoCc0cJEtrAvQsP3Kze9t7YVyp/ZMvMqCrf1lM6lVggkGma8nFkGGe768M1YZ00VL+d85CprTMZQBtcDTALsRwSgioJPfiJwbqnlagkVpe8jjmy36DFnDd3dYELoLYtFIhIPqbjYHttS7Ty1kQ/ZKZyxcyAHNs3qHDY2O+A8bJZNjf5cer149v0MboIQmKw6TCjgxHbfAzvgu1S8OBwyb9h3x8Ya6VPZmHBeNnVE+ctgPnz2PAD6jOYnaIfGFtFkc+//8UShAfwIZKqUg6/89Li6rC9sGOC8Em8VKOtlKF+be/JBU+Acx2T9s1atGucEBPyjO7IJmmf2eJmeehwOZIirgzW6d4gYNrnhIqPh/XT3w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 06:48:36AM -0600, Nico Pache (Red Hat) wrote:
> Fix comment in collapse_scan_pmd() that still described the old
> folio_mapcount() > folio_ref_count() check and a "512" false-positive
> scenario. The code now uses folio_expected_ref_count() != folio_ref_count()
> which doesn't suffer from the same limitation.
> 
> Fix comment in collapse_huge_page() that referenced ptep_clear_flush,
> when the code actually uses pmdp_collapse_flush.
> 
> Fix comment in __collapse_huge_page_swapin() that referenced the old
> function name khugepaged_scan_pmd, now collapse_scan_pmd.
> 
> Also clean up some simple typos and stale terminology (mmap_sem ->
> mmap_lock, PG_lock -> folio lock, page -> folio, grammar).
> 
> We also clarify a comment regarding where the max_ptes_none check is
> deferred to in mthp_collapse() from the original collapse_scan_pmd check.
> 
> Update all comments that references a function to include parentheses.
> 
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Assisted-by: Cursor(claude-sonnet-4):4.6
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>

Acked-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

