Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C5FD606A31D
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eFFZQxZD;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5x/Mf13W;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=eFFZQxZD;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=5x/Mf13W
Received: by kanga.kvack.org (Postfix)
	id 7E9FF6B0708; Tue, 27 Oct 2026 12:25:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7C0D96B070A; Tue, 27 Oct 2026 12:25:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6894B6B0713; Tue, 27 Oct 2026 12:25:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3380A6B0708
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:25:44 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A3E4740A89
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:25:43 +0000 (UTC)
X-FDA: 85368932166.03.D700C02
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id 773B680004
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:25:41 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eFFZQxZD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5x/Mf13W";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eFFZQxZD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5x/Mf13W";
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793118341;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zM4ewrWqw2f6SmBtbr/tDGa+C9RG4lXc1mOVbn72TpU=;
	b=Il0CzrxtiZ8h278sE9OdLrh9hWubTmIpFRYcSA8qrcBGXRgMW8U3iA1rHcwUUHN8mFar9l
	ys5JIc6cEboiuX8JFf3qW8uA0JvyBr8/ur8P3Y+xcvuxJpd/GP18/Tdp5yeJcLH4jQWId3
	BdQwqy+RMlRVP873+6SyflHoiNLoDzs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eFFZQxZD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5x/Mf13W";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=eFFZQxZD;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="5x/Mf13W";
	spf=pass (imf02.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de;
	dmarc=pass (policy=none) header.from=suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793118341;
	b=zhltsGKTq5sZdzvGK7DkGJA/CjsdDBt547IAFcrs3o5LIXQFFjv8s5F/691CU1ZSdvn2tT
	6z/aVJMNyQkNP8mb+QibCb2CRXeUmCKHJmzBOcQnQfuSvSWmM1g6wjbTPD3SdfiYqekwdg
	bsKqhiijvioo8X7uODZghoo7LOczrBk=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1DCE41F7E7;
	Tue, 27 Oct 2026 16:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793118340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zM4ewrWqw2f6SmBtbr/tDGa+C9RG4lXc1mOVbn72TpU=;
	b=eFFZQxZDIQ0XrUtbljDTopdSUHtnS0Rchu0y4oeuC91OH0xbso4nUCMJPC34AbN4hBfBGy
	gVVXJW0TvNuBuFLHR2SWccB3J6TtMhQRIb+Uq8YEVeMpXiOk9utAv8dF2HpuAi/kQnNgw/
	sZqIEBwxsvNrsaS39QkIwr7J+s3KLFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793118340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zM4ewrWqw2f6SmBtbr/tDGa+C9RG4lXc1mOVbn72TpU=;
	b=5x/Mf13W5kSNx1/2U3SlnBvv3FbGAYSwz6f//rUBqN3oio1LhRuqqfX6BL9HxJvUrQvD/Y
	7UbLtiL/2VeEfpCA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793118340; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zM4ewrWqw2f6SmBtbr/tDGa+C9RG4lXc1mOVbn72TpU=;
	b=eFFZQxZDIQ0XrUtbljDTopdSUHtnS0Rchu0y4oeuC91OH0xbso4nUCMJPC34AbN4hBfBGy
	gVVXJW0TvNuBuFLHR2SWccB3J6TtMhQRIb+Uq8YEVeMpXiOk9utAv8dF2HpuAi/kQnNgw/
	sZqIEBwxsvNrsaS39QkIwr7J+s3KLFg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793118340;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=zM4ewrWqw2f6SmBtbr/tDGa+C9RG4lXc1mOVbn72TpU=;
	b=5x/Mf13W5kSNx1/2U3SlnBvv3FbGAYSwz6f//rUBqN3oio1LhRuqqfX6BL9HxJvUrQvD/Y
	7UbLtiL/2VeEfpCA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EB2FF1321C;
	Tue, 27 Oct 2026 16:25:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id uT6LLX/Q4GoWBQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 16:25:35 +0000
Date: Tue, 27 Oct 2026 16:25:34 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, Hugh Dickins <hughd@google.com>, 
	Pasha Tatashin <pasha.tatashin@soleen.com>, Pratyush Yadav <pratyush@kernel.org>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Zi Yan <ziy@nvidia.com>, 
	Lance Yang <lance.yang@linux.dev>, Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
	Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Matthew Brost <matthew.brost@intel.com>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
	"Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, Nick Piggin <npiggin@gmail.com>, 
	Oscar Salvador <osalvador@suse.de>, Minchan Kim <minchan@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Youngjun Park <youngjun.park@lge.com>, Gregory Price <gourry@gourry.net>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Jason Gunthorpe <jgg@ziepe.ca>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, stable@vger.kernel.org, 
	Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 43/46] mm/vma: don't leak the charge for stack growth
Message-ID: <auDQb49VabNhUPqm@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-43-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-43-6f74bec9a5bb@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 773B680004
X-Stat-Signature: jwi48cqimg8my3p56my3n8cq7gjmny63
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793118341-151168
X-HE-Meta: U2FsdGVkX1/frORbx/NWfarIumUzExvuBonAUW2WhvnK2RUWTEWeVwj1uS1NOnwbILHhHaaqAGOI4apKWIJ4bP1kpFT2RRTpGy7251bk9f+WL892QQ6ssf0Ug3uJ2z3lCkAadqXh4+Xnuywo1Gi306FkO4XkNitTMC08cqhNJTPfb+im1NqhHzXU73HPsX+wsEYKxMSlRLnvS4HSZ0mAhs2e+oO4Ozkrmo60u3vcuDf27cdwLAxbI7NZaFBrQkg0FU3YM1IGj87tqfI4wlzzmqaqVLCypBphyf3KdxRrEldvQZFf+u/eA+hVAJVUzmChY8KdcbocEg/jm3NxjCv715L+bnle1YXRJaU9y0m7TAh3xX9uHzeK9SnzUb3a0fpreTozzrOQl+K6B3Xro88BWe/LxoJQcrkqNYdSXyeZ7VkojXo0wPHMrL3CL7Tr+tmFz2n9AkUOpw4woSPgQ0gun7+D6HsjC/99DiL+8mgqnYnuaEi7pgYy86YF1+dAbA9Bz3J5c0i/b7/zh9y0k+f8CqEg/SxH7VlzoXh9BYiuchphgwKGYia/xUBMzI+coyYp+zhxJoTZAFX7leFfk/mnWqVhrWuubsyEnUnqRysEn/Jw0DAvVGRndssma6S1+L5bZqv8r7xDekYSeEIBAFiZjKbqnpWhZPT2U3n+X1m6dd10VqaF/FBlrzFclni3Q+5mJM8Nk3xAGud6v9joIwMH+u+RXoY3pG8QZkHgbpp7n7Xl6ob5SFLg3LCImPM+SeWklxUrzK5JobYSIecHD2/PioWHJethn3RDBeHHgMcW+jzb7RD3LHndmeL6Q6yUqnFw+vtSlWD7NuuCvRdGJJG8K6AOvwOKwRfZqwAQq4SHqiJlCWDzfV43rVBZt2gd7LGRcSmuIclhJ5SlBHOoE0OO3aWsR5P4QLW48ZcF/Hkl5WoWgCZ6yRBQEcqcL8ki30VImR490nfjUeLW8PdAbHi
 mE0RvRc9
 thjOajocJ6rxlNoHsZLQ5CPLAMAUvpGYtcAR8jVD2jNeBYDsLrsvREsMY6eWhdVVGm4lb3UakwQ/rbIQufmEeVDrr1OOZ8WEauoAFOEDt7iUYIZdiXWqUUlOpKPxK0GK4ZQSLlW0LihrNsjWuiMFVT9+9GvzUSOj9XcOh8Xnf4+ah0NH4gfEFxEwA9XwViyLwBbz9J5KhVLfJzZMx1JE6SX24s9vR6O8U+1TrhoU6op4WA0Fen7Xdc647FH8782fK1F5dEXIXTqVYqZIRsPRg1B5IMr2vqQaQ7s9YSQauY0ZNJf5G735A9tbCMWNg8p+roF5lZFsjI7JCpw3AoEaNYgaG5d9t+cb2jxjvun2c37wshgpiaJSALNoS83jPC1air7AH4iCZEzKK/kUruR/ZdTakXf9CXylpJ3rSDTe832uACnw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:18:03AM +0100, David Hildenbrand (Arm) wrote:
> acct_stack_growth() charges stack expansion even without VM_ACCOUNT.
> This can happen for read-only or MAP_NORESERVE mappings created with
> MAP_GROWSDOWN. Unmapping these VMAs does not release the charge, leaking
> Committed_AS.
> 
> Only check and charge growth for VM_ACCOUNT VMAs, matching mremap().
> Unaccounted growth skips the overcommit check while remaining subject
> to the other stack-growth limits.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

