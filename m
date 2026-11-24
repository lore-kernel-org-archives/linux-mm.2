Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id AD7C9606A331
	for <linux-mm@archiver.kernel.org>; Tue, 24 Nov 2026 17:20:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=icpbhZHb;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lVvQ+wMH;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=icpbhZHb;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=lVvQ+wMH
Received: by kanga.kvack.org (Postfix)
	id ADD0C6B07F0; Tue, 24 Nov 2026 12:20:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A660A6B07F1; Tue, 24 Nov 2026 12:20:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 906F46B07F2; Tue, 24 Nov 2026 12:20:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 676A66B07F0
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 12:20:36 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2B43140C71
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:20:35 +0000 (UTC)
X-FDA: 85470676830.07.84BA487
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf05.hostedemail.com (Postfix) with ESMTP id B695C100009
	for <linux-mm@kvack.org>; Tue, 24 Nov 2026 17:20:33 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=icpbhZHb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lVvQ+wMH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=icpbhZHb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lVvQ+wMH;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795540834;
	b=pFGeXOEcQDLj8q3P0Hp9mFFDNye9W/L+ag1+JbfJ6sw9wf8CqFnE/oq0gNyZkIcKiv8d1D
	iMOCHmRmJaaxjH3bhqn2cBnJyilc8EJwD/9ONyZLNfEon3zhK9k2qa4VN8L+bCedloni3+
	tpoZNNBgLr+23eeIpYWw81lYYVm1YOQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795540834;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tN3vYaMnV9NupJt9uj0DyVm98fT46NJCnU18bNrr4wY=;
	b=Aa7Jn3LW/mFxhkUtcn6YncHzfPoWdS0h0vPJii2D6XCpeZwHRCniPfW7/VL0N4svdR+wQz
	/UGCZiTB9GxaFocPU1eIi6xfcXatVnCAH9p3HuhjUZ8jDDutvDgj/nLOW6Vq5NU/I0GKBu
	qBO8duo7g91HAoB5sDwnwBBzIM8sBOM=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=icpbhZHb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lVvQ+wMH;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=icpbhZHb;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=lVvQ+wMH;
	spf=pass (imf05.hostedemail.com: domain of jack@suse.cz designates 195.135.223.131 as permitted sender) smtp.mailfrom=jack@suse.cz;
	dmarc=none
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 2862B1FCBE;
	Tue, 24 Nov 2026 17:20:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795540832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tN3vYaMnV9NupJt9uj0DyVm98fT46NJCnU18bNrr4wY=;
	b=icpbhZHbueFRAPYDZt+Q/evQ4tuuoi4w57XzhnK/NytlNQ2MHfpKxEDK7WpMjGpOp4BK37
	nVqhdhblSE4ztaaMD6fIuZoFaoxqk1o/paUr2O+/AkiiSActBLumd2fOdMx5QMABuPFWUe
	ZSU6FvWbS6M2opLwxF/2fpfxN+GYH7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795540832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tN3vYaMnV9NupJt9uj0DyVm98fT46NJCnU18bNrr4wY=;
	b=lVvQ+wMHtVJ08B6+CsIe0qG2lVsd3epqQRwVhNWoxRlwPkzsE2YdosLdljWTIjE6B0MNs3
	Ef00k5xo5Kn50tBA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1795540832; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tN3vYaMnV9NupJt9uj0DyVm98fT46NJCnU18bNrr4wY=;
	b=icpbhZHbueFRAPYDZt+Q/evQ4tuuoi4w57XzhnK/NytlNQ2MHfpKxEDK7WpMjGpOp4BK37
	nVqhdhblSE4ztaaMD6fIuZoFaoxqk1o/paUr2O+/AkiiSActBLumd2fOdMx5QMABuPFWUe
	ZSU6FvWbS6M2opLwxF/2fpfxN+GYH7Y=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1795540832;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=tN3vYaMnV9NupJt9uj0DyVm98fT46NJCnU18bNrr4wY=;
	b=lVvQ+wMHtVJ08B6+CsIe0qG2lVsd3epqQRwVhNWoxRlwPkzsE2YdosLdljWTIjE6B0MNs3
	Ef00k5xo5Kn50tBA==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id EC18B1339F;
	Tue, 24 Nov 2026 17:20:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dgb6MF/HBWsmYAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Nov 2026 17:20:31 +0000
Received: by quack.suse.cz (Postfix, from userid 1000)
	id 7719D27A3D; Tue, 24 Nov 2026 18:20:31 +0100 (CET)
Date: Tue, 24 Nov 2026 18:20:31 +0100
From: Jan Kara <jack@suse.cz>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Jason Gunthorpe <jgg@ziepe.ca>, 
	John Hubbard <jhubbard@nvidia.com>, Peter Xu <peterx@redhat.com>, 
	"Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, Rik van Riel <riel@surriel.com>, 
	"Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Harry Yoo <harry@kernel.org>, Jann Horn <jannh@google.com>, Lance Yang <lance.yang@linux.dev>, 
	Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
	Gregory Price <gourry@gourry.net>, Ying Huang <ying.huang@linux.alibaba.com>, 
	Alistair Popple <apopple@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	Kiryl Shutsemau <kas@kernel.org>, Xu Xin <xu.xin@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Madhavan Srinivasan <maddy@linux.ibm.com>, 
	Nicholas Piggin <npiggin@gmail.com>, Michael Ellerman <mpe@ellerman.id.au>, 
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>, "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
	Shrikanth Hegde <sshegde@linux.ibm.com>, Pedro Falcato <pfalcato@suse.de>, 
	Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Leon Romanovsky <leon@kernel.org>, SJ Park <sj@kernel.org>, 
	Rakie Kim <rakie.kim@sk.com>, David Rientjes <rientjes@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
	Arnaldo Carvalho de Melo <acme@kernel.org>, Namhyung Kim <namhyung@kernel.org>, 
	Mark Rutland <mark.rutland@arm.com>, Alexander Shishkin <alexander.shishkin@linux.intel.com>, 
	Jiri Olsa <jolsa@kernel.org>, Ian Rogers <irogers@google.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, James Clark <james.clark@linaro.org>, 
	Masami Hiramatsu <mhiramat@kernel.org>, Oleg Nesterov <oleg@redhat.com>, 
	John Johansen <john.johansen@canonical.com>, Georgia Garcia <georgia.garcia@canonical.com>, 
	Paul Moore <paul@paul-moore.com>, James Morris <jmorris@namei.org>, 
	"Serge E. Hallyn" <serge@hallyn.com>, Mimi Zohar <zohar@linux.ibm.com>, 
	Roberto Sassu <roberto.sassu@huawei.com>, Dmitry Kasatkin <dmitry.kasatkin@gmail.com>, 
	Eric Snowberg <eric.snowberg@oracle.com>, Fan Wu <wufan@kernel.org>, 
	Stephen Smalley <stephen.smalley.work@gmail.com>, Ondrej =?utf-8?B?TW9zbsOhxI1law==?= <omosnacek@gmail.com>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linuxppc-dev@lists.ozlabs.org, kvm@vger.kernel.org, damon@lists.linux.dev, 
	linux-trace-kernel@vger.kernel.org, linux-perf-users@vger.kernel.org, apparmor@lists.ubuntu.com, 
	linux-security-module@vger.kernel.org, linux-integrity@vger.kernel.org, selinux@vger.kernel.org
Subject: Re: [PATCH v2 01/11] mm/filemap: convert fault and readahead logic
 to use vma_flags_t
Message-ID: <zgg3ktbk2spkmpa6u2nwqktnee26yvf3gglg33sgxq2ctkvh6o@7sj5tf2eutf4>
References: <20261124-late-2026-vma-flags-v2-0-bf3fade93064@kernel.org>
 <20261124-late-2026-vma-flags-v2-1-bf3fade93064@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261124-late-2026-vma-flags-v2-1-bf3fade93064@kernel.org>
X-Spam-Score: -11.30
X-Spam-Level: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: B695C100009
X-Stat-Signature: j4chnfmwduenjyw1y7xzcijuhmiuu8b4
X-Rspam-User:
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795540833-872039
X-HE-Meta: U2FsdGVkX19ur/1yNZDce3hyIw/BbFP4XICXS9FkktWaLFzsmkLTKI8ztzHEL4IpTb3egUZurFHvEbadPsaR12UDfWcF++/7qTxCyHq7Zhba9F+x6VhZGVZ0qP3aSXZrTPwv2a2ntC+O6pdXuBWbzpip5GU5VDkp8jgyi4YAji9XyApsFGz5Va5XXMbs8hqKREoRNU6QxSI7LlFGwCccACqTiyVrDy4FYMShDFgG7oitAt18kibLuIP4JbIBMAb6AlVT56op/rugkbFHJsg0TO72fxkM2tjb+EVCf/h2F9SXIiSYqTLmzsiMW5IVSyLVi5UtdgQ/3+63KH+XbYnhljuToG7EaRRbvAGY+DwiB85Rl/7NIm5lcERWnGirJaCLXJqML02R/GsobZJdvTvGFOu7ggfSByghsh/CNGL+eMEcJa7lx/8kH//Q0+kNIlNoNBCqN49o34lh0eP/mbMeCpu8bDNAf5t2LhxqPYr+JgPsSvrS/8B52qT/neNTwJvN0uYOFVehAGs25Gm8pyPbNymX5uE+/CFz+/yOvaEaJnh1uS9sz0FdhSC1CKw2s4r445qhkeWhFsZT9aKo8ZpfT0+BA8SeCjxoS7J2RYKfb+cKDSXDIhcFynNRtvHcycV0sqnbPwJEa3WZvo3UuIeKkhF2zBRT2Y55SzWYhAsB6BhqLyEzNPqa0sBm2/Pp0MKOUh6M8kyh0gAkOXSgczbZF/kTBVN4y+mHNlK63h6hDIvT0QOUNfP4gUB90Jmb5xCZ63Hg3z/6sPdiAcm5Xj0KyaP4D9R7rpay0B8GZ6DvDDAGscWf3paewSDUbT8/M6ytb0v4zEks8ocnDkpdO3m4OknuaN8sW8y9uS4Rj/ridmGthGv+KgZJxJENvI6Fo2la4s0FEKSzbgMBgXY6nnWFuscuro+1F7fm6Jif2mLs2RWnt6SMZeZqs5bZOVZ5JpHnDv9v+zLzGNfhfVUTmvl
 SXKNhYES
 B1BRDIZbYxGn8Drw7hmCWfnhNAMJMjgFsM4v25mdv2mllx8rsp77wHsswEsqoyPScwIIjlotu6jGO794LGmfBK3w4MbwnRtqZr0cKjnlzZa+F8ELjECFlPfYOz/nEnbemJYDvkvxSgyk9VWGr2AVy88Wn1NuUiAwjQ9PI7mteraoN8TwaPDtSZv16DRAmsFDKdF0JTvn7TpykXhGwZrl7QU30Om3XfAxaLT+h6yxAAroydNrU7faVxcebTiQ13LDTsZygTsem9RlHfB9BLR0HP/1RHCjxGFcXXSqRBzjRntnPPERaGoFH4Sn5k+AX2uNeUJ1ugXSVRjRocxGn7GHmmVv5uF6/O4ISiOsPLkJXPTp/0PRyLVGojZJvUjirDFKNUvX/RLLGDrARB05uGfMIWrtYZEUnsPCVDroMVSYBqP+7k+tGQHM52IdUGxo+qbhaF4Qusd+cKrfHgLMECO57kWWpyB+7Fays0p18Ux9bpsnpkcjh4tub34Dw620aZbRU62Qa215erVrmE3HevLmPVgcu2HGo1ESPTXxDhLq7AhnKlY8sB9gJtL4XPGkG806k27PN2qIFOCxfUnTO+Zz7eE1y/A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue 24-11-26 17:07:53, Lorenzo Stoakes (ARM) wrote:
> Replace use of the legacy vm_flags_t flags with vma_flags_t values in the
> file fault and mmap readahead logic.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Reviewed-by: Barry Song <baohua@kernel.org>

Looks good. Feel free to add:

Reviewed-by: Jan Kara <jack@suse.cz>

								Honza

> ---
>  mm/filemap.c | 26 ++++++++++++++------------
>  1 file changed, 14 insertions(+), 12 deletions(-)
> 
> diff --git a/mm/filemap.c b/mm/filemap.c
> index acf5e562b732..ce720c4c55f0 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -3359,13 +3359,14 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  	struct address_space *mapping = file->f_mapping;
>  	DEFINE_READAHEAD(ractl, file, ra, mapping, vmf->pgoff);
>  	struct file *fpin = NULL;
> -	vm_flags_t vm_flags = vmf->vma->vm_flags;
> +	struct vm_area_struct *vma = vmf->vma;
>  	bool force_thp_readahead = false;
>  	unsigned int thp_order = 0;
>  	unsigned short mmap_miss;
>  
>  	/* Use the readahead code, even if readahead is disabled */
> -	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) && (vm_flags & VM_HUGEPAGE)) {
> +	if (IS_ENABLED(CONFIG_TRANSPARENT_HUGEPAGE) &&
> +	    vma_test(vma, VMA_HUGEPAGE_BIT)) {
>  		/*
>  		 * Cap max THP order at 2MB: this is the common PMD-sized
>  		 * hugepage size, and it avoids memory pressure from very
> @@ -3385,20 +3386,21 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * If we don't want any read-ahead, don't bother.
>  		 * VM_EXEC case below is already intended for random access.
>  		 */
> -		if ((vm_flags & (VM_RAND_READ | VM_EXEC)) == VM_RAND_READ)
> +		if (vma_test(vma, VMA_RAND_READ_BIT) &&
> +		    !vma_test(vma, VMA_EXEC_BIT))
>  			return fpin;
>  
>  		if (!ra->ra_pages)
>  			return fpin;
>  
> -		if (vm_flags & VM_SEQ_READ) {
> +		if (vma_test(vma, VMA_SEQ_READ_BIT)) {
>  			fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  			page_cache_sync_ra(&ractl, ra->ra_pages);
>  			return fpin;
>  		}
>  	}
>  
> -	if (!(vm_flags & (VM_SEQ_READ | VM_EXEC))) {
> +	if (!vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
>  		/* Avoid banging the cache line if not needed */
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
>  		if (mmap_miss < MMAP_LOTSAMISS * 10)
> @@ -3414,6 +3416,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  
>  	if (force_thp_readahead) {
>  		unsigned long folio_nr_pages = 1UL << thp_order;
> +		const bool random_read = vma_test(vma, VMA_RAND_READ_BIT);
>  
>  		fpin = maybe_unlock_mmap_for_io(vmf, fpin);
>  		ractl._index &= ~(folio_nr_pages - 1);
> @@ -3422,7 +3425,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * Fetch two folios so we get the chance to actually
>  		 * readahead, unless we've been told not to.
>  		 */
> -		if (!(vm_flags & VM_RAND_READ))
> +		if (!random_read)
>  			ra->size *= 2;
>  		ra->async_size = folio_nr_pages;
>  		ra->order = thp_order;
> @@ -3430,7 +3433,7 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		return fpin;
>  	}
>  
> -	if (vm_flags & VM_EXEC) {
> +	if (vma_test(vma, VMA_EXEC_BIT)) {
>  		/*
>  		 * Allow arch to request a preferred minimum folio order for
>  		 * executable memory. This can often be beneficial to
> @@ -3442,7 +3445,6 @@ static struct file *do_sync_mmap_readahead(struct vm_fault *vmf)
>  		 * pad that might exist between sections, which would be a waste
>  		 * of memory.
>  		 */
> -		struct vm_area_struct *vma = vmf->vma;
>  		const unsigned long start = vma_start_pgoff(vma);
>  		const unsigned long end = vma_end_pgoff(vma);
>  		unsigned long ra_end;
> @@ -3485,7 +3487,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	unsigned short mmap_miss;
>  
>  	/* If we don't want any read-ahead, don't bother */
> -	if (vmf->vma->vm_flags & VM_RAND_READ || !ra->ra_pages)
> +	if (vma_test(vmf->vma, VMA_RAND_READ_BIT) || !ra->ra_pages)
>  		return fpin;
>  
>  	/*
> @@ -3499,7 +3501,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
>  	 * keep the counter symmetric.
>  	 */
>  	if (likely(!folio_test_locked(folio)) &&
> -	    !(vmf->vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
> +	    !vma_test_any(vmf->vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
>  		mmap_miss = READ_ONCE(ra->mmap_miss);
>  		if (mmap_miss)
>  			WRITE_ONCE(ra->mmap_miss, --mmap_miss);
> @@ -3532,7 +3534,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
>  	 * scenarios. Recheck the PTE without PT lock firstly, thereby reducing
>  	 * the number of times we hold PT lock.
>  	 */
> -	if (!(vma->vm_flags & VM_LOCKED))
> +	if (!vma_test(vma, VMA_LOCKED_BIT))
>  		return 0;
>  
>  	if (!(vmf->flags & FAULT_FLAG_ORIG_PTE_VALID))
> @@ -4018,7 +4020,7 @@ vm_fault_t filemap_map_pages(struct vm_fault *vmf,
>  		if ((map_ret & VM_FAULT_NOPAGE) &&
>  		    !(vmf->flags & FAULT_FLAG_TRIED) &&
>  		    !folio_test_workingset(folio) &&
> -		    !(vma->vm_flags & (VM_SEQ_READ | VM_EXEC))) {
> +		    !vma_test_any(vma, VMA_SEQ_READ_BIT, VMA_EXEC_BIT)) {
>  			unsigned short mmap_miss;
>  
>  			mmap_miss = READ_ONCE(file->f_ra.mmap_miss);
> 
> -- 
> 2.56.1
> 
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR

