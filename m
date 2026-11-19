Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F051660A2622
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 20:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wZQwmvk1;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wnMVpHge;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=wZQwmvk1;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=wnMVpHge
Received: by kanga.kvack.org (Postfix)
	id 09E8C6B065E; Thu, 19 Nov 2026 15:11:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 04FF26B06EA; Thu, 19 Nov 2026 15:11:24 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E7D596B06EB; Thu, 19 Nov 2026 15:11:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id B4AE66B06E8
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 15:11:23 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 34AFE40A4F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:23 +0000 (UTC)
X-FDA: 85452963246.10.52992A5
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf31.hostedemail.com (Postfix) with ESMTP id F3E3D2000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 20:11:20 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZQwmvk1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wnMVpHge;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZQwmvk1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wnMVpHge;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795119081;
	b=is41amitTLn6KMSPepWbXfIs4yAFD86HAm/oXDbnkXV3f2lRu+FUg9jTzhi8lWZzAdEF42
	WAW63JSGwiR5B5Nj4Q1eqwQHITOtiOPFf2sVrYwsaavxf95CzX3upfktG5VhURBcCTiT1q
	AytvI0zD81i2j6YPcd9pfeeUsCmHb+s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795119081;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uO/73pEQQIy9LNgk43pvXgxG7QnNaIlPQRRcRPUpu9Y=;
	b=NKpaLXs8KYQXDmepjWTZ9O36UZxQYMlzPsaIuJI9HMCUsMBAmeJ5JmeoM9PnFUAEuTznNl
	tQpRhlwtiLhJLfs8DDmvSOXiixSnHAosnOxHiOW+LrTi+0a/ob0ECED1gVoqMUbD1l5uvn
	W+PXeGXVHxGOz94tj8wunFV5fyDbA0s=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZQwmvk1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wnMVpHge;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=wZQwmvk1;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=wnMVpHge;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf31.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id DBBA121DE6;
	Thu, 19 Nov 2026 20:11:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uO/73pEQQIy9LNgk43pvXgxG7QnNaIlPQRRcRPUpu9Y=;
	b=wZQwmvk1rBkHTOGo0aaJmNHq3PmqE9nd/LDfPHCgQW+ssoFkA7fEGg8LOAZfzZzaDwd6iw
	zxTIboIlb4U8dQIxDYNADVhgO+Of6UaAXJH+3rQ6iLiUXeIDpCVG6VzQWcTpV4vPkw9SCi
	/av7zxFVW2ds8MrBpwky9ITiRW8MB2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uO/73pEQQIy9LNgk43pvXgxG7QnNaIlPQRRcRPUpu9Y=;
	b=wnMVpHgek02PbsETbBVemF6lgfm1Fsk4bBIq9tRzTup6j8Y0Me5JaFXw+2l4lKIx40xr7j
	x//LK/PqLjgitlAQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795119078; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uO/73pEQQIy9LNgk43pvXgxG7QnNaIlPQRRcRPUpu9Y=;
	b=wZQwmvk1rBkHTOGo0aaJmNHq3PmqE9nd/LDfPHCgQW+ssoFkA7fEGg8LOAZfzZzaDwd6iw
	zxTIboIlb4U8dQIxDYNADVhgO+Of6UaAXJH+3rQ6iLiUXeIDpCVG6VzQWcTpV4vPkw9SCi
	/av7zxFVW2ds8MrBpwky9ITiRW8MB2Q=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795119078;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=uO/73pEQQIy9LNgk43pvXgxG7QnNaIlPQRRcRPUpu9Y=;
	b=wnMVpHgek02PbsETbBVemF6lgfm1Fsk4bBIq9tRzTup6j8Y0Me5JaFXw+2l4lKIx40xr7j
	x//LK/PqLjgitlAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3C581334C;
	Thu, 19 Nov 2026 20:11:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OqV1JuRX/2pPYQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Thu, 19 Nov 2026 20:11:16 +0000
From: Pedro Falcato <pfalcato@suse.de>
Subject: [PATCH RFC 0/5] mm: GUP dirty + ->release_folio() fixes
Date: Thu, 19 Nov 2026 20:10:43 +0000
Message-Id: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/6tWKk4tykwtVrJSqFYqSi3LLM7MzwNyDHUUlJIzE
 vPSU3UzU4B8JSMDIzNDQ0Mz3fTSAt2UzKKSSt3yjMQS3SRz45REcxOLNNMUQyWgpoKi1LTMCrC
 B0UpBbs5KsRDB4tKkrNTkEpBRSrW1APU/QoF3AAAA
X-Change-ID: 20261116-gup-dirty-what-b73da748f5d1
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Lorenzo Stoakes <ljs@kernel.org>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>
Cc: linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, 
 Pedro Falcato <pfalcato@suse.de>, stable@vger.kernel.org
X-Mailer: b4 0.15.2
X-Spam-Level: 
X-Spam-Score: -13.30
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 7ucpygpzywdk47wpwkzx3py3a3w4gu5j
X-Rspam-User:
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F3E3D2000C
X-HE-Tag: 1795119080-997510
X-HE-Meta: U2FsdGVkX1//NnoUWp6RBzvvNMUAr6REx9h2UTlsSl4DnuI4hC3ovKhLM8JoASEnSuEdtIGkRvQq8hLWzSYG95u+xXpFQbwS812YQzuvR/m2pJ3/r5jYBqWI1KsaLYq1jBHCKz5Bj3+2K1YW0pmlMjGFh7faQpB0oUQkocY5ivxWbelR9bbMbdF2TxuB9a1Anz6HMp7t+FiCxwOGgGcMGX5SjPOuxsH3YrQ1gJ2wDMsFDwDoYYdJn2EZUmPOFIP+A/HF9TmjLgSe6GqJigshMdYznLBUGtH/rpvmkshyv4o7ngHywmWj1lvj7v6MYRSmUfVV3+sEmpkCteZqF3LrKRRcdaSWxxNxkJaBu7gOG9YyfXAaMULwa+Ua/jgfrWjeLkN8jFYj6gg0ZkndjpW5ZwVhvC7xlfnlcoPfnfHPe2br9XHjhX+GaEIxc4QFa363J0KVkOE+fyaj9nU8cPV8gLEQ3G5ylHzcNykR/BqBMJSYWR+LnlW7cXwyU0g7qDmUDIAJxfBf+0dL7Ub76hFT3UV6+/OIrrSwrjOON/kkI6vb4F6GGNW0jhT2v0UCjudpy41HqLabug1XP1kyNjWs3lrhcIUZonVEvE9VaM4Sf6lcb3e5qTxkbmIgj6OM6VApSdvEC8RgPYUV9tvLraoFVdSNwCdhP5a34jDmk5YKQDN5Bfh4x1Kr+JYWoNdsyibZQ6xFSHXvJOzV+Gua74BCATcfv/+VkgVRoafZdZ7YYjSBKLWRKrwHgVSXIVKfTvGsR2SSYyhyRHZhLB3W1XHoXq6PxdjtMk9KuUX5YL3ZhqbeUWNknRwV1jtk5BLfeVrj6e80eDlC3sINjuUijjHwwdNMkBdkx9HRG3MZNUR2sainmRP9xh12Q7PxBAxCbbyUkh6/aw5ueSmR3bZOnxkaftiCmkAz7ajDGdKqsGQy0o2+jSQsGiX97mFrml2GWrVg3FaArLPhVtG7iFKowrW
 +BdseHW+
 I8NmItxvWFSAQb8VcgG7OcYYpYxpCw7AE7M01JxW4+zMXw2RkvLa5NUsXO7uAHGdoDUScarnAKCsp9yJuDV2UjKn6VoMWJVBkHabqX9YzHdGST/z5mjKM9mxlePsSQxXZNseG6hfwdsDYoqsvZZhRU1JAxcAvJdo3h8avt9DqsVhMHCGGaHE+Ry02msQgc7JtVRLSV+e+qGwljqo+LPBZ8BP2zz3oz7E0sIbF/YcydkSREUszwuZB2tefwZXl+S8inXrXhcPk/U+GaU+HIX9oM4bBqTAdkkAvy5peajZApweFxg1Xqx7l/Tc+15oEXEwq50YlphdmNplqpxDPGiNS539WuJ+qy5sNJViguDWM5jafOz77h7j5dSICAscdPDCi8+ZUyw6FsXTorTBYbcZCvV7/lhI0Ieu4Vuj4YvJxb07isXW9zX8hYbgkxodf7VaGZXnpIUP5DXrr6dbZVLEpr8dFwg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Sooo.... It turns out GUP dirty and ->release_folio() interact really
weirdly. This was initially reported by some AI agent, and David let me
know.

The basic issue is:
 - ->dirty_folio() relies on buffers/IFS/etc being attached to the
   folios. It _cannot_ attach them itself, as dirty_folio() cannot
   block.
 - certain MM paths (reclaim, khugepaged, folio split, etc) are very
   trigger-happy when it comes to asking filesystems to release them. In
   most cases, barring any dirty folios, buffers, it will just drop
   them.
 - there is no problem in usual IO submission, but issues start to pop
   up with GUP, where the code flow (roughly) becomes:
        [get_user_pages(), etc]
           ->page_mkwrite() called here, or before
             ->private correctly populated with whatever the filesystem
               expects.
             folio is marked as dirty, initially.
       *write finishes*
       folio_lock();
       folio_mark_dirty();
         ->dirty_folio()
              dirty_folio expects ->private to be populated by
              ->page_mkwrite(), ->write_begin().
       folio_unlock();

What happens if any filemap_release_folio() runs (and succeeds) between
the initial dirtying (plus eventually writeback) and the write to the
folio completes? Welp, it's unpredictable. ext4 for example will
WARN_ONCE, and likely drop data (see ext4_dirty_folio()).

So, what can we do about it? It's complicated, hence why this is an RFC.
For the possible solutions:
 - ->dirty_folio() attaching this FS information itself is not really
   possible in many cases. ->dirty_folio() can't block, nor is it even
   guaranteed to hold the folio lock while being called.
 - Can pincount help? Kind of. Things like folio_maybe_dma_pinned() are
   rough, and don't deal with the usage of get_user_pages(FOLL_WRITE).
   pincount itself isn't available in the common order-0 case, and not
   available on order-1 as well on 32-bit, but who cares about that^W^W^W^W^W
 - Could get_user_pages() ban FOLL_WRITE? Mayhaps. I would not be
   opposed to that, but that's probably a larger change than ideal for stable,
   and I'm not familiar enough with GUP requirements to decide to go that way.
   This would require migrating all FOLL_WRITE users to
   pin_user_pages().
 - Can the whole system be reworked? Probably, but not for stable.

This patch series is really rough but kind-of works. Instead of using
folio_maybe_dma_pinned(), which only interacts with pin_user_pages(), I
introduce a new helper that helps places deal with the folio refcount
directly. In that case, we can also deal with GUP. On the other end,
moar problems:
 - NFS private data itself takes refs on folios. Now private data (that
   we could perhaps release if only we tried) is keeping us from
   releasing that same data. What?
 - ext4 data=journal has some funky usage of buffer_heads. Data journalled
   filesystems will not, in any way, dirty BHs. Instead it will,
   *only if it was DMA pinned*, set the checked flag. ext4 skips
   dropping those buffers if the checked flag is set.
 - ext4 move_extents seems to have suspicious usage of
   filemap_release_folio() as well.

Many of these have suspicious Fixes: (which are definitely wrong). I
targeted these patches to complement Jan's original fix. Anything before
that (or which is missing that patch) is hopelessly broken anyway.
Proper Fixes: can be added, but many of them go back quite far.

Signed-off-by: Pedro Falcato <pfalcato@suse.de>
---
Pedro Falcato (5):
      mm/khugepaged: fix filemap_release_folio() interaction with GUP dirty
      mm/huge_memory: fix filemap_release_folio() interaction with GUP dirty
      mm/vmscan: avoid releasing FS metadata for !FOLL_PIN gup folios
      mm/vmscan: be more careful when releasing FS metadata if buffer_heads_over_limit
      mm/filemap: refuse releasing maybe_dma_pinned folios

 mm/filemap.c     |  3 +++
 mm/huge_memory.c | 22 +++++++++++-----------
 mm/internal.h    | 48 ++++++++++++++++++++++++++++++++++++++++++++++++
 mm/khugepaged.c  | 19 +++++++++++++------
 mm/vmscan.c      | 18 ++++++------------
 5 files changed, 81 insertions(+), 29 deletions(-)
---
base-commit: 9663aa0da7070d958e333477ce0720512e9fa016
change-id: 20261116-gup-dirty-what-b73da748f5d1

-- 


