Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 00A11606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=jMAe2coB;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ThWU3S/l;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=jMAe2coB;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=ThWU3S/l
Received: by kanga.kvack.org (Postfix)
	id 0BFF96B0698; Tue, 27 Oct 2026 06:39:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 098376B0699; Tue, 27 Oct 2026 06:39:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EEFE36B069A; Tue, 27 Oct 2026 06:39:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BBDC76B0698
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:39:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 5880A409B7
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:39:36 +0000 (UTC)
X-FDA: 85368059952.28.2C35064
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf10.hostedemail.com (Postfix) with ESMTP id 45DB1C000B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:39:34 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jMAe2coB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ThWU3S/l";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jMAe2coB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ThWU3S/l";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GHXfa6R9kyvi48QCk+MS91fHFKbn6ETqPD7CVuiGV4E=;
	b=UjtxVVvBWtQbYEFR/ZuJM2HMFK9WUXezE0N3+/BSvIHHcUIm/pifQ1YUuDO6AIMKgUN4+K
	GZJmCnsrbig9auIV3o0jORYZ1vYZTu54L/z0XHnWkdkLYLooMl+qE17Fjv+5Mc0DsuW2qK
	Hf+wTDIQU3int2WwK3/WjLGvHGV8ai8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jMAe2coB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ThWU3S/l";
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=jMAe2coB;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b="ThWU3S/l";
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf10.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097574;
	b=afO5nBMKZp17LYNpSIqZCNLNc0tboj3x5MjwTuC2Ya2hbvDsszD0BVw3kL3G+6uaImBg1J
	wG6Df5jPPMDvmMZR3W+ycx7YmGGUNSV4+8FIQJgYsla83Kt6JTUgaxFAYZIgD/JPvD3Qrk
	qWIGW65P21KYOz4KAdXDkKRUAI8vUYg=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 0C4381F7D5;
	Tue, 27 Oct 2026 10:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793097573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GHXfa6R9kyvi48QCk+MS91fHFKbn6ETqPD7CVuiGV4E=;
	b=jMAe2coBUlccty3WHc8e5eFbxGa/FQ2n05z85wuM0uaTiaKhJdl7ZM93Izvk+dMu+SIVP7
	SuAVTUjb87RyCHK0ewstc6yfcUCkiry0A71eE1ZaAONOd+4FRscZSDEBSmxEttk4iK9uBP
	BFGgiIC9hZRc75BpwrdNUNGp5cR5iSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793097573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GHXfa6R9kyvi48QCk+MS91fHFKbn6ETqPD7CVuiGV4E=;
	b=ThWU3S/ly60GNL1To5OVEGzTl7xGFF0ft9/lW1WdUqqvby+qiJh4XfliFTrN0TZPcLVbcA
	00sIFGt5kj9La7Cw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793097573; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GHXfa6R9kyvi48QCk+MS91fHFKbn6ETqPD7CVuiGV4E=;
	b=jMAe2coBUlccty3WHc8e5eFbxGa/FQ2n05z85wuM0uaTiaKhJdl7ZM93Izvk+dMu+SIVP7
	SuAVTUjb87RyCHK0ewstc6yfcUCkiry0A71eE1ZaAONOd+4FRscZSDEBSmxEttk4iK9uBP
	BFGgiIC9hZRc75BpwrdNUNGp5cR5iSE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793097573;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GHXfa6R9kyvi48QCk+MS91fHFKbn6ETqPD7CVuiGV4E=;
	b=ThWU3S/ly60GNL1To5OVEGzTl7xGFF0ft9/lW1WdUqqvby+qiJh4XfliFTrN0TZPcLVbcA
	00sIFGt5kj9La7Cw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 588A81321C;
	Tue, 27 Oct 2026 10:39:27 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id wIn6B19/4GprGgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 10:39:27 +0000
Date: Tue, 27 Oct 2026 10:39:25 +0000
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
	stable@vger.kernel.org
Subject: Re: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
Message-ID: <auB_QkUwsP6sRfYS@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Spam-Level: 
X-Rspamd-Queue-Id: 45DB1C000B
X-Rspam-User: 
X-Stat-Signature: 1eyhesm1dc3i6uumctnxpqpyhenb6ksx
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793097574-439437
X-HE-Meta: U2FsdGVkX1/0C9iZ/zjUw8d+kwWj2ztY6ARutSm5o/Kq0kGl3+G+3VD4Bvy3y7cIuscTEaMFwIgV56kykYssrrnOvoiEdLFWq+d3LuuAPGU88UydtphMYRtogK+hSusxdHPHHXJd5n5JnRaU4SBwMz12ErAH3mR3Fo4CSn1sBRaW4dJYQQmjnZhTfl3TKY0JRhol800TjkLswsoDjBSi133bue28R+GOdCIDNirGTWupnYuWnoGYQuZoRgaFUmvRKL5c8ZtOi/BCGbL9FmYRUYzX8MsjjvSe6MwdywPy/P0K9lQHlFLWO9pTcXzu1OMVodtp/bm397WnQpZqbRY28g3ni6rD49QexKs8auCSJOwgkCfw2+98jJVfYBUKt24KAq435rUlnWCpxOOMHZcPgRIigEDOSyEXmSJl+2tnmY07IWjuq5oeGzy1A6aPqG8m3gQFPOglKC59rFu77hjraa69BeMekEBPIgiqK3JfK5cRakS/WmW+5Y3a1m6wrvuiL8eucaukStdb0y60fKWdX+60r4mzUco6+xJ96f0iU9BEW5MSvF+p8UmYpcv35+6Pm2J+13gRXhH+Ay952vTbYYYFAHQarPc18ijMPDD8nUFpEyy+5Y3+b83sVnsHc+IJ230yxpBwgLJ1rs0w4tW4efCxrS++OQSMk1sHeB0LUwGnE6/Kjwqh+MOy5+o9EWdYJ/ap+6byCIeAYSpY9btGtj3kGDFNw3QoSPyPqpNEYdQk2tkKSLGxKZ+jWzPNNAZFkGtyEu1LaqaTwweRuyxw4mPWStQVcoejTZGuFESgyIoNCiCJUzfPHqWdsgG4ndDxEUuM8NZMaNKs/iPKUF9VFh/7Q0ilscdwwIiiTh+kpUmuYrp1/B4d08q4S98JCF2mSyf8kNl1R5ieQEQeZZShStLq1f3eIxnUSQey0TySErBFssYoES6xVq7Xf7DEsKbGbPIAlPsx8sdJLx9BvXj
 Bpt/PO5D
 VLOa+pxE28O3eHWFN33NbGKlbBL68mzAL2tHSYg+91Z+coRFHpSkYxanLTL8q1yUbuqWD/G9ChoJomSETUWt2qOJwk3fMmBQON86fmmvtneIFLEeOpRAh6BjsCe5gl599lVNK7X5meaA6/rUcu0oYR7f7liESp6U9g3CjyW7Y1qL1OkVL/yqJTlRH7KGTbHUDtnF4vs6zHnUoYslIt7dusSXEhZih8q6opeU8ukFe9bHD4g/ujvno+zIwKFHsQdaV7Xoxp0UjZtNZgWv5rmi8s7uG/q35QaQ8yU4fs6yRXWk64cRokgFK6E99i1rAopBfZDGBJQtvCkmw6BkSBVAeA5HaHtk80ohuj9YgSd61C8UJxx1kmz4ofIa4v+TXaWYUPYu3GvuJic9vZEEuW2XffBVcrhbfYvWrROUq1DSUTPIzVHvxje9GvUw+Vfgb/CPqMf6PuhdX7X7R2n9Kqi1wmi8wIg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:24AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
> read(), write() and lseek() on a shared open file description of a regular
> file serialize on ->f_pos_lock.  The flag that asks for it,
> FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
> too, but its struct file comes from alloc_file_pseudo() and never passes
> through do_dentry_open(), so it does not get the flag:
> 
>   CPU0                                CPU1
>   write(memfd, "a", 1)                write(memfd, "b", 1)
>     pos = file->f_pos  (= 0)
>                                         pos = file->f_pos  (= 0)
>     vfs_write(..., &pos)
>                                         vfs_write(..., &pos)
>     file->f_pos = pos  (= 1)
>                                         file->f_pos = pos  (= 1)
> 
> One of the two bytes is overwritten.  Two threads writing 100000 bytes
> each, one at a time, to a memfd end up with a file that is far shorter than
> 200000 bytes, while the same program on a tmpfs file never loses a byte.
> 
> Set the flag when the memfd is created.  As for any other regular file the
> lock is only taken if the file is reachable in more than one way, and
> nothing a memfd does in read or write waits for another operation on the
> same file.  This cannot be done for all alloc_file_pseudo() files: anon
> inode files such as eventfd are S_IFREG as well, and a blocked read holding
> ->f_pos_lock would lock out the write that is supposed to wake it.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: minor description tweaks ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

