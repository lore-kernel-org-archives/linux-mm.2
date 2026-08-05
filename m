Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C222C55174
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 09:26:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A5C2B6B008A; Wed,  5 Aug 2026 05:25:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A33876B0092; Wed,  5 Aug 2026 05:25:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 949B76B0093; Wed,  5 Aug 2026 05:25:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6DD926B008A
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 05:25:59 -0400 (EDT)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id EE6CC403B0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:25:58 +0000 (UTC)
X-FDA: 85066683996.04.8E7F9FD
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf06.hostedemail.com (Postfix) with ESMTP id 4449C180004
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 09:25:56 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BeLeBx+R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+b/K4Sqr";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dE7KOysv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4GdgJQCy;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785921957;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=35uDq8t96j7doty6Fe3ci5gHsyRqLWT2OJuYsnRTaBGoVj0wqItN/blyiKU7aZEK4qrP/J
	8/rbJW4nURmJyLsoQRe437fPFGfT/uuFjbgKEUzY55NUZQvlxFm8dlGpwKPVOV0K3e3YxX
	LSQmROBOn23k8txBCwSq0R0wGul9STY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785921957;
	b=FwhhsAMizYwG5KFzN853GlyQOnwn1LnvIswTRWFssiHHGjD4opM3iJKYcFHJHvjsxK0XLp
	NVRbd6KADyi4UdPqUGFjwL5VU7xA1ySnPQLHiI6C9406gEoaGQdF9hCX0+/YZbdnYsWKU2
	uxBzrNgJ7dEyJ7VyPnW8Dq2b/N/YVBc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=BeLeBx+R;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b="+b/K4Sqr";
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=dE7KOysv;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=4GdgJQCy;
	spf=pass (imf06.hostedemail.com: domain of jack@suse.cz designates 195.135.223.130 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 294947FC27;
	Wed,  5 Aug 2026 09:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785921950; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=BeLeBx+RbR7lIXCZOhMwI7UuGd9+/JKpVR3qQU+wSjCQ/3kDvtgTVqP+FYu7l5oPoKc+IJ
	05bf6y7mbobzoujJwJ++BNE5FWF5+ZzbwSKnLfNWcuV0R3NXT2YrwYwwS/Dar13yO+CV/z
	vUgeIoq9zT7HSDUixmRFbELP2ELZZ1w=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785921950;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=+b/K4SqrGg5pjq2JjXGlzgM4Gl5Bnu0gGtSAKIU/D8U2QuSRLoATAoSf8PZava2ksrsV33
	SGsov77Dzp9AStBg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1785921946; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=dE7KOysv06PWLA2nYIGNx9NLCv/3Sp7N/KXMQlGQjRN+8TiOj2KrsJCUlHSE3eStEpgVe7
	PLZKBi4ZJhD3lpf3PfSNqV9vn1xjZe07BtpEvfL0RsJgU9kNLvf6d1nJFXV0RU6flCxsXX
	ZuY5lHfzmqJvq9zmKgmEIyDbBNtAVAA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1785921946;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Unq3L3W/LMOsRcSXFhJi3b4iG89arfC8wlxjitqO8bM=;
	b=4GdgJQCyh1+GIPV9s9EVlMFMBEn4BAEEp6LYnz7ZsFI7wGwDEUDivwefCweLJPjNSvDGQm
	0rhpnVdK2JTGO0Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 11B80779B6;
	Wed,  5 Aug 2026 09:25:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id IhhUBJoBc2oBMgAAD6G6ig
	(envelope-from <jack@suse.cz>); Wed, 05 Aug 2026 09:25:46 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id AC37FA13A7; Wed, 05 Aug 2026 11:25:41 +0200 (CEST)
Date: Wed, 5 Aug 2026 11:25:41 +0200
From: Jan Kara <jack@suse.cz>
To: Zi Yan <ziy@nvidia.com>
Cc: Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Muchun Song <muchun.song@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Gregory Price <gourry@gourry.net>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Alistair Popple <apopple@nvidia.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>, Chao Yu <chao@kernel.org>, 
	Yue Hu <zbestahu@gmail.com>, Jeffle Xu <jefflexu@linux.alibaba.com>, 
	Sandeep Dhavale <dhavale@google.com>, Hongbo Li <hongbohbli@tencent.com>, 
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH RFC 07/14] fs/erofs: mm/pagemap: add
 readahead_folio_reverse() to avoid folio->private
Message-ID: <ivg5x7hjo4tmpd34i6wrd5cp2v56c3vorwru7h6kqxnqlcpte7@lvd7xa4ncwxu>
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-7-142c97ba3562@nvidia.com>
 <332rknj4vo3cfhvfhhlf6pvg37s3lbrnzbbnv4swa6gctsiu6a@ndotgokvnglc>
 <DKFGTVA0XD01.OZYNYUOU9FTX@nvidia.com>
 <huzyeqj6a57nbcqc23v6f6rdhkob5552fcwy4mlrsagycqi4rz@ggsapkumc2gq>
 <DKGA508ERSYM.26RBD4HYM1SL8@nvidia.com>
 <2evaxdu6cobpnzzer3y7fsrqvmtmhj7gm3e5buebdaw564igx6@7bs5enipxnpx>
 <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DKGBQHP25RE0.3NKUQSDULAQSX@nvidia.com>
X-Rspamd-Action: no action
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 4449C180004
X-Stat-Signature: 1fi3xu96ztn4t3mdnox1j7x7esciwz5t
X-HE-Tag: 1785921956-439697
X-HE-Meta: U2FsdGVkX1/jmGD9uP8uKed7bRLjzC0ibUVWxwfSCJcDMXdSY8lfT55uPpYPXBYg6K1OygYjyPEdOqoTV87KjaTMPY9IQGpaMKTo+qiX3x6DliU5P9vZywiZ+MT/lBjZK2nv7h44+QTcxrfE775NzFumezTN6dzpIf2jJFibYHCs1nh9kFpZWnrDoXHbiYEu89srqWsykV1v7hWvPqkKjdC0/1hk1ZJb9wvBY80R1Py2e/Wu2p9WvTFsdaMKIe22JWAqj5/H51w1RMPCy85I96g3owejUBtJmzjtSkUQq9QmvY+8LTZVtMZV8kQq2oZASA+IYC9T3ruabCQ7q/lY4u3ZLrgdGDv4jwVb4f73Et2bKl/F+qa95wMK0dtDPmoeLhgfuDQcR/YZTJM6R9uRT3G3MimbxkgXy7F+taQ4ViNearA8h5PmYgHOB0F+e0DGY6fCT8N35qy6KdTgXc9NVsXc64m7Xqy6S9u5bDbixOyIHFseuOEI4+Wej4D42RqUaYXHlIafoLX+YMIc7EaDrWz6wFfoTzXcRi4K6JsPw7791JtF78zpAqA4sQCPXftGV7UmHGVPp041E78bEjt/vi6AmrnU6+NHhYijv8t2cObkAkAhgVhhJnT+3mQZItboNm/WJs8mPodzzhI/uVv4mX08zcEMTu/AAwO1D6Cguir0QeUHH9Jc/8s839L6T9RMVTDfKduihGgcxagwnwAhRplqBsp7jJuwry/E5mx5qheeGNbhlPkq8AltABMK6cMcLJ8ilXNP1cTJlP6v2fDYHmdUrDP4DaOmy0QWOrGPXur/XrgeyPAXjMooqMA7tKyO3SggbaDKrelApytG/KtEzdI5f+5Whno/sORVTtwshBOZqUCsE2OegKwTiE+ZWf+y81SPwIPRd63wi5/tk4jCd1QVSYYOq8ufsijbbW99/ww0otQfJet4N3Gv8SGNlOS7dYtTBef2zzE+qh91IYN
 NfmAMpIb
 /atNng5re4pGU6Tpgdt1TtcCas+EH/U97jepxSq5o+ERzmu36I5Cup5ngtOmiQ73AN6LmYbLgrAvzHsUqB5Cwao1X1O/x8ig7YPpcJuBGLwvCyDw+2SimC9KxnpAEIbN3EIaALjab0ccES+tlGT11a+ZDL/fzXI7Ig9q/ZUm9ljad4qXO7YuHn8YKXdou0gZM5S5eJyrmVaurpGyuAUd4RS15F1kZmtcPJnTfA95S1g+ZS+KSKAcg0FJlqOaBW/WQ3vQUmCZEGUoGrJheF45yb92evTBfIijPGK6PWxedo5vJCEnrFH5qvST1MNlvf7Ln7Qu3J/x08d/oRGUwywGS6beZjZ085WdpftuLFpKUsz+C/fieJ4SgQ/sJ/Mf5Wozi9MTWQgAd0gK4q7s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue 04-08-26 13:09:46, Zi Yan wrote:
> On Tue Aug 4, 2026 at 1:04 PM EDT, Jan Kara wrote:
> > On Tue 04-08-26 11:54:41, Zi Yan wrote:
> >> On Tue Aug 4, 2026 at 5:32 AM EDT, Jan Kara wrote:
> >> > On Mon 03-08-26 12:56:36, Zi Yan wrote:
> >> >> On Mon Aug 3, 2026 at 5:54 AM EDT, Jan Kara wrote:
> >> >> > On Fri 31-07-26 22:13:30, Zi Yan wrote:
> >> >> >> erofs needs to traverse readahead folios in reverse order to achieve
> >> >> >> maximum performance by
> >> >> >> 1. reading all folios from readahead_folio();
> >> >> >> 2. storing the prior folio pointer in folio->private;
> >> >> >> 3. traverse from the last folio to the first one.
> >> >> >> 
> >> >> >> Add readahead_folio_reverse() to achieve the same function without using
> >> >> >> folio->private.
> >> >> >> 
> >> >> >> It prepares for a future commit that replaces PG_private checks with
> >> >> >> !folio->private checks. After switching the checks, erofs's use of
> >> >> >> folio->private without bumping folio refcount can cause unexpected
> >> >> >> outcomes, e.g., in filemap_release_folio(), try_to_free_buffers() becomes
> >> >> >> reachable.
> >> 
> >> <snip>
> >> 
> >> >> 
> >> >> The below is what I come up with. I did not add a bool to
> >> >> readahead_control, since I think that is the decision of caller of
> >> >> __readahead_advance(). But let me know if you disagree.
> >> >
> >> > The reason why I wanted bool in readahead_control is that if some code
> >> > ends up mixing readahead_folio() with readahead_folio_last() things will
> >> > get confused (because __readahead_advance() really wants to skip the batch
> >> > returned from the *previous* call to readahead_folio[_last]()). With the
> >> > bool in rac, even mixed use will properly advance the state of the
> >> > readahead_control. I don't think mixed use is very realistic (at this
> >> > point at least) so I'm ok with leaving that for later if you don't like it.
> >> 
> >> Got it. I am trying to figure out your mental model of how the mix of
> >> readahead_folio() and readahead_folio_last() works with the bool inside
> >> ractl. By looking at readahead_folio_last() code, it is almost the same
> >> as readahead_folio() with __readahead_folio() inlined
> >> (__readahead_folio() is only used by readahead_folio(), so the inline
> >> can happen without any issue). As a result, we can get rid of
> >> readahead_folio_last(), add set_readahead_direction() to set the
> >> embedded bool read_from_head, and use readahead_folio() only. This
> >> removes redundant code in readahead_folio_last(). One thing I am not
> >> certain is whether we want to
> >> 
> >> 1. use set_readahead_direction() explicit and warn readahead_folio() if
> >> read_from_head is not initialized, or
> >> 
> >> 2. set read_from_head to true by default, so that only erofs needs to
> >> call set_readahead_direction() to change read_from_head.
> >> 
> >> The former is less confusing but changes how readahead_folio() works;
> >> the latter is simpler but implicit read_from_head state might confuse
> >> people at some point.
> >
> > My idea was: readahead_folio() will call __readahead_advance() and then set
> > rac->forward = true. readahead_folio_last() will call __readahead_advance()
> > and set rac->forward = false. __readahead_advance() advances from beginning
> > / end based on rac->_forward value.
> 
> Got it. I can do that. Just to be clear, it should be that
> readahead_folio() first sets rac->forward = true, then calls
> __readahead_advance(), since __readahead_advance() advances based on
> rac->forward, right? readahead_folio_last() as well.

No. I wrote "and then set" which means after and that is what I really
wanted to say. You still don't seem to be understanding the logic of handling
the _batch_count. _batch_count is the length of the returned batch.
__readahead_advance() updates _index and _nr_pages to remove the folios
returned in the last batch from the range. So _forward needs to contain
whether the last returned batch was taken from the beginning or the end of
the range and __readahead_advance() uses it to update current range
accordingly (before we go and return the next batch). We cannot clobber
_forward before calling __readahead_advance(). I hope things are clearer
now.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

