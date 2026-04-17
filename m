Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 912F1F4368D
	for <linux-mm@archiver.kernel.org>; Fri, 17 Apr 2026 10:35:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA8706B00D6; Fri, 17 Apr 2026 06:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B59316B00D7; Fri, 17 Apr 2026 06:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A48286B00D8; Fri, 17 Apr 2026 06:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 90C836B00D6
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 06:35:16 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3221B5C453
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:35:16 +0000 (UTC)
X-FDA: 84667690632.14.72BF0BA
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf02.hostedemail.com (Postfix) with ESMTP id F39B880002
	for <linux-mm@kvack.org>; Fri, 17 Apr 2026 10:35:13 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRkPVVbH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="6FewmC/L";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRkPVVbH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="6FewmC/L";
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776422114;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1BVLztzaiZBegB6RTn6uHUG6HBgF5BPrmgwbt/Gvns8=;
	b=bQIhwsduJ2aGOsUgLsOWXQC6lR/ZKOZs/0nkMXokJgR+mTikAPBf+MY88gGtcH3F74DwoT
	iEH3tD/IL65O+ljlnyqKhHGAtdyUOXF3rFCnBsWRbe8lzoIwNb6obqdqDQCeCrjmVfXhp0
	WLUdF/kKvVgb5tWxk9LaDLDsXXjmvAQ=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRkPVVbH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="6FewmC/L";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=qRkPVVbH;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="6FewmC/L";
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776422114; a=rsa-sha256;
	cv=none;
	b=RnYYLuQ4utbNgfsdE3Ekx18ZV0qrHnosfBwJflotDJLrgonrxGkKq1EBUJywzvT8H/1qYQ
	GSKYW9If3qLgVseqA7lnhxyP0SWRvQnln/ZoirlJ6b1jWWIp8WLonVAUHXZUYFnQ5W/CGA
	NOPdNzSet4hnJihp+iIXxAm00N0eQ8A=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 34E806A9A3;
	Fri, 17 Apr 2026 10:35:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776422108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BVLztzaiZBegB6RTn6uHUG6HBgF5BPrmgwbt/Gvns8=;
	b=qRkPVVbHmJcyYbGvn/YIMHzglQ0S66X8qc9Vfo1o7IRw7KRHKE+EdUGPvYjr2HXK2epYM6
	fHYBCc6Ysb4njzNEmFuFqs9Rsju8fh1ZYDugmNlyf2kNvr2csL0LypG6xN+mREmOR1dbrL
	DCOpIZNr6jxGVPX9KAqShpBbYuKs+7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776422108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BVLztzaiZBegB6RTn6uHUG6HBgF5BPrmgwbt/Gvns8=;
	b=6FewmC/LEsTjzMCFzG+c2SZJkLp37oYCRFyyf37fturdkkQAnufGuvirJNlBQQ98huo5B2
	21mASpx/5fQG5TCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1776422108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BVLztzaiZBegB6RTn6uHUG6HBgF5BPrmgwbt/Gvns8=;
	b=qRkPVVbHmJcyYbGvn/YIMHzglQ0S66X8qc9Vfo1o7IRw7KRHKE+EdUGPvYjr2HXK2epYM6
	fHYBCc6Ysb4njzNEmFuFqs9Rsju8fh1ZYDugmNlyf2kNvr2csL0LypG6xN+mREmOR1dbrL
	DCOpIZNr6jxGVPX9KAqShpBbYuKs+7s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1776422108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=1BVLztzaiZBegB6RTn6uHUG6HBgF5BPrmgwbt/Gvns8=;
	b=6FewmC/LEsTjzMCFzG+c2SZJkLp37oYCRFyyf37fturdkkQAnufGuvirJNlBQQ98huo5B2
	21mASpx/5fQG5TCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 618AA593AE;
	Fri, 17 Apr 2026 10:35:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 2V2EFNoM4mlTPQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 17 Apr 2026 10:35:06 +0000
Date: Fri, 17 Apr 2026 11:35:04 +0100
From: Pedro Falcato <pfalcato@suse.de>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Matt Fleming <matt@readmodwrite.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Christoph Hellwig <hch@infradead.org>, 
	Jens Axboe <axboe@kernel.dk>, Sergey Senozhatsky <senozhatsky@chromium.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Minchan Kim <minchan@kernel.org>, kernel-team@cloudflare.com, 
	Matt Fleming <mfleming@cloudflare.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <bhe@redhat.com>, 
	Barry Song <baohua@kernel.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	David Hildenbrand <david@kernel.org>, Qi Zheng <zhengqi.arch@bytedance.com>, 
	Lorenzo Stoakes <ljs@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm: Require LRU reclaim progress before retrying direct
 reclaim
Message-ID: <sfyuribxce5qf7dvteztzfmlr5jvsjosg2rggjkjthcnlxeksv@jvadwjrg2nuo>
References: <20260410101550.2930139-1-matt@readmodwrite.com>
 <v3j7f476gbj7b5rxigpcorxhaimg5dyhgtovsl5quo7gc33swc@7i4ypekahw5h>
 <aeDuVmN8Q6cpNTuT@matt-Precision-5490>
 <aeFYrV78Q19c-RnB@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aeFYrV78Q19c-RnB@linux.dev>
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: F39B880002
X-Stat-Signature: bsgp949ae8s914n6tk46s6eat6a3na5z
X-Rspam-User: 
X-HE-Tag: 1776422113-979768
X-HE-Meta: U2FsdGVkX19IDfyIfzVMUEE7Cu0nKnmGXfo3hJd3iPds4IrbztRkngVPPjD/d307k3KSi6O3Nms+EcI+j8m2k3b7ztS+gMAWwkgCBgPlHGCDr8+YSu3co7t5JHLGZx3MRkFIMjQWMW3p7gqt6XWTdZ8J2P2PRFMcBp1n1xHXNYCirYwOuYvWujnGSl4bm2u7ddf4DpkBq9C/VGeibxYP1OiHzmbrqhDwt8ic7QL1SrhH0nj6YtkjlQFBkHlkWWjvGQ3x/OfVafG39GikbqGjTNB5WqAYP6Nv2PJVFKmmlfvwAIL+HUsfHxg/QtLJybtliIL06BkJEP8BU7NOcofrHZ+csCB9Lr0VUAvw7hzCP3mXR2FsnN8svh6UNawQzjdJaJf5QrdFb7xVx0ZGndYKEou+pCgbRKjRl9JyIlPrjz+nAr9SA9VkXM3NzL2RiUm5sZLJE+RWLgITXDLdE06f/70/xxfRxxzt14ZG7HGGYFZqf9XqUaOeZWyWXx/h5zjlUVN7vhdH9Elo+7yiIySZ3mHwRQVDNHFrcj0/4swqgRzarKI8asVXVWu+skboRKzlNDI6Jt+3ri0pG1M6G4soHLtZMGSX7UYBUcwRIRWRFjRYmxnR5EHmMDPIz1TadxG4fPqaGd08UXGmi9wdJWDUcRcXpOfoiRxGm0CGAwmiF5Ri2Jax1bHeadiHs/TYJ603+sZ+bcDyvmCQ4merdOUiJ6Gao858uA5fiHyYB3USKoTBfMHqQZWkgV1g8jTM7XWPDSCh4mE/N8lKI6IJWq+khLGDTRMoreYTkps7OnCUVWfNnyfUPLE1CL8l9/EvsFJoOs8XLy6JLoAJ8NO5UnR+aGsJ1COXX6bGfLTqOHioz/7MnspRq4GTJ10nLxEN1DKFU1eifn7gUQ8LBngx+nym9UWoif+3v3SPMS8Yx/fHBVUkzA9N5cXEHeglskSOBStr3Q/zSRPsdXRE/uUyQJl
 R6txwWMq
 vVTdDMtMxVg+bPu7LxlO/GRePIRbPVbHyv9szticFBhHoMkbd4aUUXKtIwmITiaP1n1l400UWASRW3YXiySyfaP2orYLy/+r0Rc3r86Mb2G0OTBly9SvEd/ZSic5xB+ittGVtiEzxkZQf/+Seoc7YMNTYGunm4uuGcVPDS3B0LC6DBr6Wl5+SpT8nlH19dOvdxJPfJZgbqZsCalR+oAEejCiecRg8DviKuJ6hfDo/tS2E49aizWdFuOqzcRU6L5objwuLOUVwjIau8vImI1ENNJjUAe8jk6aawHQo4TNS+idM/fk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 16, 2026 at 02:49:28PM -0700, Shakeel Butt wrote:
> On Thu, Apr 16, 2026 at 03:51:04PM +0100, Matt Fleming wrote:
> > On Wed, Apr 15, 2026 at 03:57:25PM +0100, Pedro Falcato wrote:
> [...]
> > 
> > > My theory (from merely reading the patch, maybe I missed something) is that
> > > a pathological case for this is a lot of folios added to the LRU in a row,
> > > that are set referenced (or dirty). Say SWAP_CLUSTER_MAX * MAX_RECLAIM_RETRIES
> > > - it will simply OOM too early.
> >  
> > OK yeah I think I see the problem now: this heuristic applies the
> > threshold against all reclaimable pages but that falls apart when doing
> > SWAP_CLUSTER_MAX chunks of reclaim.
> 
> I am not sure I understand the pathological case. Yes SWAP_CLUSTER_MAX is
> requested amount of pages to reclaim but the kernel can potentially scan full
> memory twice to reclaim that much amount. Though those reclaimed pages can get
> stolen but that can still happen today before this patch.

I see, yes, you are totally correct. Had a look at the vmscan code again and just
realized I had missed some details.

Matt, please disregard :)

-- 
Pedro

