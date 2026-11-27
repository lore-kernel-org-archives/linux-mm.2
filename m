Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB0A606A321
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 13:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=n8Sp1N6y;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=pODgPDhA;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=ptBQgtrQ;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=m5UC2tpx
Received: by kanga.kvack.org (Postfix)
	id A25326B05B1; Fri, 27 Nov 2026 08:59:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9D66A6B05B2; Fri, 27 Nov 2026 08:59:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C4546B05B3; Fri, 27 Nov 2026 08:59:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 247426B05B1
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 08:59:36 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id B381AA7D39
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:59:35 +0000 (UTC)
X-FDA: 85481056710.24.7D680F4
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 79F50100002
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 13:59:33 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n8Sp1N6y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pODgPDhA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ptBQgtrQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m5UC2tpx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795787973;
	b=RmHv6dtZ3NW4CkwD/9usRlSunVXCLajQlb3J2edfCgk6SdArExywTR2LcvHUeOVeC02QQB
	oj0s1kXDWTJo31r7hEb5ZtyXXA5+hqyt+AaiFdj/6dIGSfSlJpq96fZ9IeuRLPSuqUWo50
	EGfNTXjutwMn+FQxQOAtnIsHAmhasQo=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795787973;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hSAGX0PlcKV7hxoSKihFcCP5vot5vWKykmT5/I1Rotw=;
	b=UgZj9nivnBxvBkA4KdsaBVm6OZX9KJPMQQjcx3n8ERmrkE/9iOVSrzay6kPRttPf9/YoiY
	vgznc0m3G5FVdVcNaeVVVctVYHgRjq5KDMZqdSK+RyCHLiqFFqHuhS24AKXB5Lbga/aB4i
	sRgPLDFCoP5Pv87eRIliyl+qKAWz/+8=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=n8Sp1N6y;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=pODgPDhA;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=ptBQgtrQ;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=m5UC2tpx;
	dmarc=none;
	spf=pass (imf14.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id D311D1FBB0;
	Fri, 27 Nov 2026 13:59:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795787972; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hSAGX0PlcKV7hxoSKihFcCP5vot5vWKykmT5/I1Rotw=;
	b=n8Sp1N6y9Vm45Mgr7D/4hXr+E6kdClBXxiVKkx/q5AGVMNOvdcYnHgM8wgmleWTbydX/QG
	uuMm1BMVGIR3YVzyXvB4zzhU52UBrN334F0BC6VptBLw3q8doluBTW8UzBHcb/ROoal/RZ
	hB5Wy4ULuPz9NrLd64ks0FgbhAS6apQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795787972;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hSAGX0PlcKV7hxoSKihFcCP5vot5vWKykmT5/I1Rotw=;
	b=pODgPDhAIxp656pvlxUrpRSk4HSBAnk2OPd6F0EmkVWwkXolg1gbpxsCUHwBLlENz3fTy+
	vyjKYebOVwYrdiBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795787971; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hSAGX0PlcKV7hxoSKihFcCP5vot5vWKykmT5/I1Rotw=;
	b=ptBQgtrQ1GwX/wj0pA4/omtbuqgeHt/5dbnW0NE7ZSZb/rshDm92HW7IAbncmzCNomGHrq
	llRGEkndrmeio+ki1sR4C5SAO30en9k2MiDmH37kCNezcAXR3p3iE8ShjAucopDXxQKZ0z
	B+O3si4tKsoKxWqd++oRS8jajx2WrV8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795787971;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=hSAGX0PlcKV7hxoSKihFcCP5vot5vWKykmT5/I1Rotw=;
	b=m5UC2tpxZO9Yf2DSATt0pN8be86yEfoSuqxihq+0TXlJbrK4CsSDNWDf2F2CDIHK7o9gTL
	+NVHKwwbqHEZ7dCQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A703013432;
	Fri, 27 Nov 2026 13:59:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QDmCIMOMCWsgNQAAD6G6ig
	(envelope-from <jack@suse.cz>); Fri, 27 Nov 2026 13:59:31 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 2B5DF5103B; Fri, 27 Nov 2026 14:59:31 +0100 (CET)
Date: Fri, 27 Nov 2026 14:59:31 +0100
From: Jan Kara <jack@suse.cz>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Jan Kara <jack@suse.cz>, David Hildenbrand <david@kernel.org>, 
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
Message-ID: <mlu22apiuzcim6icjolifdr6wgsk5u6dpo4kwn4ppkcdgfudn7@t6sp7ck7qafd>
References: <20261119-gup-dirty-what-v1-0-236d69f25c24@suse.de>
 <20261119-gup-dirty-what-v1-4-236d69f25c24@suse.de>
 <wm57zjtvdpexvbfygmdggw2ytsazelyds4rt3mtx6oy6u72mke@rhviuzp26rt6>
 <awmGDyR4WUJrwqn1@pedro-suse.tail5790ac.ts.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <awmGDyR4WUJrwqn1@pedro-suse.tail5790ac.ts.net>
X-Spam-Level: 
X-Spam-Score: -16.80
X-Stat-Signature: rg7iwy51amzk8te8ztjtokmngyfga3dq
X-Rspamd-Queue-Id: 79F50100002
X-Rspamd-Server: rspam06
X-Rspam-User:
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795787973-5597
X-HE-Meta: U2FsdGVkX1/3ysj7N/a3eadax5IfFxXDqnLsFqZOaEYHWEkJh3mSnN6+ebVGpXRGOvqvf86lSik9PZf+fq8wYAZmK9DKKDGytsko5lMIlrMsYqf00qxKJ40Uc6o18nAKHtzWrKdaX+0JFi7y4OYSY/aVJAU3B3/LVY9g12DsfXqMgtLOWBphziw4gBl9KEMYJEqMChbTjL/uB2IIuuLrIvPhFUrW2TpMdGN/57A00jrv3XlxDFKYmY+rx3HXNVGbaxEc3EhvZ3m5RN63jeV+qqWRZsqoeoJD8HQKzhuLGiay8BZZ6TRqvWWjq9OLLqJ0KgwlmDHj4qYWpHqxu9JJoHmGsRuOBlvK9dSMRx0LarlyEuPDRMjhwNRqDHla0tFcAPLVzC1aGvZA4Y7DZHlVyjv/JMpt1NDrUIrATToPQw/UDyVgfzWaUYe1agGGG0aU5b9gytq/PsTdYi5fifWp8cLBrv1i9fKqhy1zL2HIf55QQn2oKCZnNguIi+R4xPKgt1yzCBg2zOXN9mvpgbXOa9Dh0sIjUXj0PRgVtl6v31HiEnX5PGS2sTQTYVUh+OjKjef5w9ih3+7DjLKJrySx+rw5INYgZshj8fKldh+iD2Nfp7hbcqR1D8RzR4YKa3dHGpa1tpB5TFbHhpXnELRJNL6WzfzlXBjJErUGfMp9o4dJMxjvbOkbpdO9wD6UFN+AbvAVZeZSi5AW8C3IfAItTXhZkA9HHtG6bDZTadTFlEq3C8y1QI8iL3f6kZC+cF49cHHNs5VSXkFW8UbVVZotRHES8llsXSU8XmMZAikPUoa1OnPAV5JS3znIJHVwhvQ9CYWb0OLVBnPamRwgK5l63L/pqKJQM7Xk12WUe3FUwBLvfz8H3l1AzLzr07fRJGYbHnzBztCU2hXEbjLMNumyDau/3Ss8/zXcVbjaaCvsCi4nenTAzy3PeUtPhFhT8rZyMdFMRjOMiOERpVyaLGu
 DrBl34yO
 5CBKPyGfYQmxMqH6CwoKLhT8xPm5epql02zyrXGTg7uLw4inXZzpIbGIzTko6PqEnfev+RoIWB+EVpv4o5UL4cWiYUJ0D3Ee5FYR8cp66iB2rOzzkH6lO0mOUY05ryIEq5R9EIsYKExz+/u9ANMVfhVOiAbzkSSihq4I+kl4oCEz0CBXXwVVqZA0o5osNRPuQ12T/ZdQMxRQHAngr/RwH+bPSVq7Vjm0iSgCu7XD8SCUtQS1rbFSDQ7pyHUtoxPA4iR0tFZMQ/dfyxdYxYiqIPwiifTUlFY1WDkEgoCECqJPxLunumnT7K8esCcDmPJZWlxAAHkkr75CZa0nMRcGjs4xwccwBKNwnQ3CrF+PiH0ogbdF+05SyadvuEB/7S1X0Jlb2/jw8jdpj15mDQc0O8b6pxbdw90M8fpx+hWIAXG637uzL0oCzEF/VwJN1UzquvBE+FKQ0l9LsQtz+VbbYEywOkNjqo37hXWeuldrIX08ivByoK0EWzXw9ny4yWqop+J3i9YXOHc/JwDPnTFYugSJ/C5tf5tCF452KnIbWIRR1Sb4bezQCFehA9gfQUdTpv0Hm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri 27-11-26 13:37:15, Pedro Falcato wrote:
> On Wed, Nov 25, 2026 at 09:45:01AM +0100, Jan Kara wrote:
> > Just given buffer_heads_over_limit is a HIGHMEM thing and given how much we
> > care (not) about HIGHMEM, maybe just completely ripping out the whole
> > buffer_heads_over_limit logic is a better "solution"? I mean it's a crude
> > heuristic anyway and for struct buffer_head to occupy significant portion
> > of ZONE_NORMAL, you'd have to have several GB of pagecache with buffers
> > which means the machine has to have quite some highmem which makes the
> > setup even more dubious...
> 
> Is it _just_ a HIGHMEM thing? I had the impression it had some effect as
> a general buffer_head shrinker. Either way, I do think we can remove it,
> but I chose not to do it for stable; also, I don't have technical arguments
> as to why it's useless, I just assume it is.

I don't believe it can ever activate without HIGHMEM - each bh points to
actual data in the folio it is attached to which, usless you have 512-byte
blocks, is more than 10x larger than struct buffer_head. So buffer heads
can never occupy more than 10% of total memory unless you are really trying
to screw up your system... And AFAIK this mechanism was introduced as
a HIGHMEM thing many years ago.

> Other filesystems (iomap, XFS, btrfs) don't participate in this scheme and
> they turn out just fine. So, unless you find something I'm missing, I will
> probably send a (separate) patch removing this whole mechanism for next.

Yes, that would be great.

								Honza
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

