Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89C34606A321
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 08:52:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B20EB6B0945; Wed, 25 Nov 2026 03:52:32 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF75C6B0947; Wed, 25 Nov 2026 03:52:32 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E6906B0948; Wed, 25 Nov 2026 03:52:32 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FA9B6B0945
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 03:52:32 -0500 (EST)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 0BF06A8C36
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:52:32 +0000 (UTC)
X-FDA: 85473025344.11.AE8162C
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf16.hostedemail.com (Postfix) with ESMTP id E4AA7180003
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 08:52:29 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795596750;
	b=wviU6A9EEodSNLafl7/hPj6jKZdG9yrZ5qqYE3mHGq4vhuR90Vhr6ENlvlZupE3EOjxYUg
	QwCMA82+ETnAC+7To/EJggQegOF0faPfY7j+So8A2IM2142Qu9zNfJANzdxjIv2KnYnZak
	Ds89Na0ATahxQm1EiHin9ekZeGVqVhA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795596750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p9vbL0ysv91ckHuds7ouuXNkYWInSQU+tytOp4PqZGg=;
	b=ZVmHNf+SBGQz5b5cMITrzgzFipVtvvPL67H4oerZYjY5YsUpY8ct8uHdaHRDkMRyo8dVfS
	nlFDRYI8lVYPz+b1E7qeRspzmvdwOeiCkwXHw/BBwLecbSL02dQs6CemJZT4BqI8r3j4Di
	Hdr2bRWi2lrBCRhTlpo4jraaChC21JI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf16.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D09491F456;
	Wed, 25 Nov 2026 08:52:28 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A6C51134CA;
	Wed, 25 Nov 2026 08:52:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 88BVIMyhBmubAwAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 25 Nov 2026 08:52:28 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 36C7D27BC4; Wed, 25 Nov 2026 09:52:24 +0100 (CET)
Date: Wed, 25 Nov 2026 09:52:24 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Lorenzo Stoakes <ljs@kernel.org>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, linux-ext4@vger.kernel.org, linux-nfs@vger.kernel.org, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Michal Hocko <mhocko@kernel.org>, linux-fsdevel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH RFC 5/5] mm/filemap: refuse releasing maybe_dma_pinned
 folios
Message-ID: <ioqon6b2fg3ycdxztdfgxc6x2dkc4f6ysep6bpornycbkrj7ax@5rlqupekoyl2>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-5-236d69f25c24@suse.de>
 <fsmnfotflgrddrlak24cve7vkcjkellsgb3xbei5ysxvmqnul6@byvxblm4dtqm>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fsmnfotflgrddrlak24cve7vkcjkellsgb3xbei5ysxvmqnul6@byvxblm4dtqm>
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Rspamd-Queue-Id: E4AA7180003
X-Stat-Signature: cw53k9pof9tips54t5o5mignomqz39x6
X-Rspam-User:
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam06
X-HE-Tag: 1795596749-331667
X-HE-Meta: U2FsdGVkX18+F2aA2XX8mgSzQhUcaFyOy3FYknduurgXKxNbABHCu7OQIPWvtgDwE/s/2x9q77VieXMe83f7wZCxQ721888iKOxGdOMB8HqDVTb/dZJA1VmoqzcX8ynr2pavHk4U+sMzHW9rqc4STegtnl1dQBCwYrfhUfbSAWMGtfFghekQgVKz324X1MmVwQl0UBY0q7VjKKYAJWmhCyBj6fbb+ZkTQb9/4yXn/gU8+DG6YppBR9gmQW80rAPczsm+CTGhxufFpAUjjBQeHN/39Yj6DPb1grrIsqAAmY8+yUocokcelzVR6PSRGfj+Vc98+xZdVAf2wl2xxqdOhphM1WoNU0MKRuvkOORUmBZYAFT2SPJKitzi+QVAVn64X4hFqoJFI/X4L6e8E8fqKNl4bsSrwzuc4fFlJ64D794TOyyYeo8EYFpLi4A0teeiJziQmyC00ELdJvxQW6kkj1gG58ds/HtFtsNdjRppGoLrMzujZyrTD0pRsfzQx0PsuO4JbX2dzAQ6Z049LM2HcHSp9jTOSY1Es1oLSTsecmSe2wiLyt4t+Un6HIOzFlB1GGO3X+VQuhuaLnsrzl6yj73fEEns8GEgt8XgI7hNNPNGYQim+AqWJetWZP9Ln95n/xNL9Hp9XVprtlXpooi/eC9rh14+KSZl/5DGHe0K8QcNGteyCJZ4wAiI4gB1sN1KsHq7Z5Vw/smQ5mIrZugObP97WN9Z32g8fRprV4G2xWdVxD98erWVlRIabmkmWcFUpZmq6GlAzt54jWbhGlVFun0ZSLykBhTk0m99/TyWJ9TuPOlWFWp6WO3cNeFNms1M7RXQyipeqD9JfA30B7nWGZG8fhRzQUayJ8RlfHP23FFEg3sFj0QBJ8mE9cqPQ94Yg+Nu7IWmQtlpGownPw+W97C2LQj6lz7QrI9Es5XMb2RhkkokOx7r8xEwqux5RKsKtg4N0eyTD77+LV/bjDL
 7yhELQg1
 5z/60PknqJIpkFICB7CnxhTYLq9k4V7iWppMXzZh3I7Gyg9PpPzELc3rSHOlgdj5/FwqOOQ2SiMD7AYLIvb5HTRNx8cYhzLzGkdTgFclbHUMCST3Ld0BAR10b42IJkai4SG0tdNEzhXoPZh7dYi85dnLJRMzN3ZQm5FZTNyYgKTCg5pEAkSwde5blCbhEYx4bYrKyLaUVEaFwjSJ600Mw4PvuaGagvNrT1EYDumVUI2PwehFn1qdT12XlJg0wsze6D+bpn0kJMjqPUb/YUD/2uOxUmONZhdH8HtH104SVK2qvoGJPJXUVPb4rg3/E84/tkixAvfGw3cDAeLOvUzKWzdrzZVsimY/vnWZ1IaPYlbw4ZN5dL/qYolRDiNmY3m/Vr1DJ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed 25-11-26 09:47:39, Jan Kara wrote:
> On Thu 19-11-26 20:10:48, Pedro Falcato wrote:
> > Some callers, like folio_unmap_invalidate(), call filemap_release_folio()
> > without any care for folio refcounts. This is on purpose. As
> > folio_unmap_invalidate() states, invalidate_inode_pages2() needs stronger
> > guarantees, and "can't afford to leave folios behind because
> > shrink_folio_list() has a temp ref on them". Ok.
> > 
> > Use folio_maybe_dma_pinned() universally, in filemap_release_folio(). This
> > has a much lower false positive rate, and should be ok enough for most
> > serious cases.
> > 
> > While here, properly assert that no folio passed to release_folio is
> > mapped.
> > 
> > Cc: stable@vger.kernel.org
> > Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> Looks good to me. Feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> 
> and we'll see whether there's some path which actually required private
> data on pinned page to be freed in some cornercase :)

Oh, now I can see Sashiko already found some :).

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

