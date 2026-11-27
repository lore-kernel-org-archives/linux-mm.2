Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 67406606A331
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:37:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vynBLAwI;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1UkdL3aO;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vynBLAwI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=1UkdL3aO
Received: by kanga.kvack.org (Postfix)
	id 8E22A6B05B4; Fri, 27 Nov 2026 08:37:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 892206B05B5; Fri, 27 Nov 2026 08:37:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 75AF86B05B6; Fri, 27 Nov 2026 08:37:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0DA846B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:37:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 9D263160362
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:37:22 +0000 (UTC)
X-FDA: 85481000724.06.EEFF9FD
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id A0B04100002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:37:20 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vynBLAwI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1UkdL3aO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vynBLAwI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1UkdL3aO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795786640;
	b=56MBEHVuEV/mLhxS1w9WALxSaq1ZzeN3DzMG/lxUucAU7NmMdGxHiVLbqaBUSnL1Gwbdfh
	RwCbuKDyx5hJoRB1xsdd+e5njTiJOsgT3xweyBVQ9aWFtdU7hB7ME1ApbEokhU9JxjjB4N
	0JIz7F7NcbDYyVWk/uXCUJIP5IYSsrc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795786640;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y08yZxh1ryLIY7mvmhCDj43e42/YR5o0fMDQtRHyXPs=;
	b=vvJugdqtO8VLkegYi9zVP6CHS3ocNJpBk5fmiG/b+1ssv3vLPH1Gx2iPl44ttG0Z1YF6op
	sTYRTbCAAjyKb+ZZ8SwQ1HZhgzGAAIlINYN0sLM54ke6AG5i1rTfJ5k5c+e6Pf8xt59MAt
	pWkHqSdycZI6GKuWAoM2pYAfBSVwIxA=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vynBLAwI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1UkdL3aO;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=vynBLAwI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=1UkdL3aO;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf14.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 30F031FE20;
	Fri, 27 Nov 2026 13:37:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795786639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y08yZxh1ryLIY7mvmhCDj43e42/YR5o0fMDQtRHyXPs=;
	b=vynBLAwIxfNSUoEpC0eTK1NpGV5HV4AvyVmLzwIJxcNZgLXLXVtcMQb0VXHj/6tMZxND7U
	tO5YbPp66IyElEUGkBD67YXwGx43SgUkD1u5sCPThJwyuU7zkmlX9HWNezXVUPCut+VPme
	GuXvrcQB9YNIUqxE/4d8tPh5VRCAy4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795786639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y08yZxh1ryLIY7mvmhCDj43e42/YR5o0fMDQtRHyXPs=;
	b=1UkdL3aOAmd6XgVNUirmpCHJqBdZNcsvfCN7pcZivSvN7oc/A9T4w2KXrG+uWGnJtib/dU
	kVtlEx8wnCtNA2Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1795786639; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y08yZxh1ryLIY7mvmhCDj43e42/YR5o0fMDQtRHyXPs=;
	b=vynBLAwIxfNSUoEpC0eTK1NpGV5HV4AvyVmLzwIJxcNZgLXLXVtcMQb0VXHj/6tMZxND7U
	tO5YbPp66IyElEUGkBD67YXwGx43SgUkD1u5sCPThJwyuU7zkmlX9HWNezXVUPCut+VPme
	GuXvrcQB9YNIUqxE/4d8tPh5VRCAy4k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1795786639;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=Y08yZxh1ryLIY7mvmhCDj43e42/YR5o0fMDQtRHyXPs=;
	b=1UkdL3aOAmd6XgVNUirmpCHJqBdZNcsvfCN7pcZivSvN7oc/A9T4w2KXrG+uWGnJtib/dU
	kVtlEx8wnCtNA2Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id ED1CE13432;
	Fri, 27 Nov 2026 13:37:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4IeHLoyHCWu4HgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Fri, 27 Nov 2026 13:37:16 +0000
Date: Fri, 27 Nov 2026 13:37:15 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: David Hildenbrand <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, 
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
Subject: Re: [PATCH RFC 4/5] mm/vmscan: be more careful when releasing FS
 metadata if buffer_heads_over_limit
Message-ID: <awmGDyR4WUJrwqn1@pedro-suse.tail5790ac.ts.net>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-4-236d69f25c24@suse.de>
 <wm57zjtvdpexvbfygmdggw2ytsazelyds4rt3mtx6oy6u72mke@rhviuzp26rt6>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <wm57zjtvdpexvbfygmdggw2ytsazelyds4rt3mtx6oy6u72mke@rhviuzp26rt6>
X-Spam-Level: 
X-Spam-Score: -13.30
X-Rspamd-Queue-Id: A0B04100002
X-Stat-Signature: 5oi7h4iwcn85npk3nccbnjro86rnnr5z
X-Rspam-User:
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam04
X-HE-Tag: 1795786640-94211
X-HE-Meta: U2FsdGVkX19tEjN7iBHJC5HR/4wNhHdynJfY21tZJ+EFyKgts3S1qZz8o4GlhHSrrAoK/waQufiClbd6zjJMp4GVxGTSthd6Cq4Y3teHxjg2GrNGJK7KrhJHHcLSHHalR4OmfVAzLthekRli+1LslpAT/8vTTZSBAd6CFDhgVsWlZ67+WYbTPKFQKCMA72n1PURRy4efo8OSi7Iw1p3i06DsAFNhXJRdXoDf0+vrGcycCDazy2bOL1qxWZa3TT/qeYlH/Z7HvzevbyWpviG036ZnU+FUZLZv8W3ASRw9K081y2P1asclrMyhGEQeyvIQ1ugLNaGXYnh35BY3ol/G2p/9AyitA3LKzPjx/qBetu0ExjyagE28irDaaKax/hhRAnWX9FHXYO6ougQEFtlu66kJyHmg2ABUMcN1U15BFhuPw3XqwaN+M1qigHRu3BOAIv75T+xKEvvQv4c2xMBBPpgcHYgvKeRhCUAva6tX67Xt0rYa8v7n0dRm3xoTF+Hs/amHtki5H3AQw0CdNekdfBl0vbW4un2U3H7swYhJLmXHG7b0QVcwxIPMX+WqrbyT/RKHBmgy2e1gCh9Gg6cEpOIMR9Er1DwVpUxmQ+KFTuAFqlAimRuNYdShwSetbGd17ylLGilMviw5/bCGRX6pNuLL1xHYFFspUjkWt9ZfEgejZSMHqe7OZ4JLJHjZFDlRpEVcJl7DVpGHkziVFLMStJAyce6Nw0ve7vDmDVFGIw6bslznX1mtjIJR+JVDayl9z03uOPX126YAmf+G6zKuPxaTF1JLUa7+6Z21ZzVlsqkcSdsQFJHPiYodVAUIEB7uTjBSUA07eQTE93JKgFgnGvbhPHdS99uWaknSbjOsSjw6P46RXwHkuP+p/1ZqKE9jeVQwnQltCm+x7PV00QQF5e7UL4m+AqWtrvemNSTpiamneByteT+7FG+bz5+grQEe1zn5QyZMyHDxNXeLvoY
 6yjQj3K9
 vlb3ijEpgROnU4es6ChpSjRTjbweJuKoC1qRa98tSqBkZ0uoBSF4hU6X/CNwyplML7b2y+DwKTAiinf+Il7Kzv+qSJahK8FGemZvC/XG1deOyYuZwQ1JE7L4cL7iSkG8gkvz24nD366GJKKahmhJefjURTmavWeBKa3/7PTj09CYPYHGvtuj/ewaoG9lBdQiHglrFyR9zAU4D4sctNWAPMl5TVleG8m/SEUa2k9YY9udlbU7cpuYeKHz2wYCrNish8lKkGY6ergl92tweKw7fvUns5QyVFYPBMRYggaO3P56KnVYQdio41R6GkJsr+S6ZQCKvwGkFTZP7UKfemDoXJIv39J5+XQPRpYz62ZDvP3+RpT1bm9brjoaok1+Yb0sWRg4iNRh0W+4EMQk2w6jl6gYC+pggIJ5pQyP7I40inf36Fxn0XpQl2E4epLodpZFLu9T6cTmzWyWfvjT2BLNJLh+DFrm2uOTXw4nxVXZzmCGAboBcPaQJaEyUtaQANhx+K5L8ziDrhRdIaiV5IedoDK/q77aMk0uU2TqSkZimt/Kd/E40JP0M7SaENQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 09:45:01AM +0100, Jan Kara wrote:
> On Thu 19-11-26 20:10:47, Pedro Falcato wrote:
> > Namely, don't call ->release_folio() for mapped or referenced folios.
> > Since this is the active list, there's no actual point in doing
> > unmapping. In fact, that would be counterproductive for active folios.
> > 
> > So, gate on !mapped && may_release_folio.
> > 
> > Reported-by: David Hildenbrand <david@kernel.org>
> > Cc: stable@vger.kernel.org
> > Fixes: d824ec2a1546 ("mm: do not reclaim private data from pinned page")
> > Signed-off-by: Pedro Falcato <pfalcato@suse.de>
> 
> This is OK with me but so feel free to add:
> 
> Reviewed-by: Jan Kara <jack@suse.cz>

Thanks!

> 
> Just given buffer_heads_over_limit is a HIGHMEM thing and given how much we
> care (not) about HIGHMEM, maybe just completely ripping out the whole
> buffer_heads_over_limit logic is a better "solution"? I mean it's a crude
> heuristic anyway and for struct buffer_head to occupy significant portion
> of ZONE_NORMAL, you'd have to have several GB of pagecache with buffers
> which means the machine has to have quite some highmem which makes the
> setup even more dubious...

Is it _just_ a HIGHMEM thing? I had the impression it had some effect as
a general buffer_head shrinker. Either way, I do think we can remove it,
but I chose not to do it for stable; also, I don't have technical arguments
as to why it's useless, I just assume it is.

Other filesystems (iomap, XFS, btrfs) don't participate in this scheme and
they turn out just fine. So, unless you find something I'm missing, I will
probably send a (separate) patch removing this whole mechanism for next.

-- 
Pedro

