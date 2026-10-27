Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0A010606A320
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 16:13:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Pf9TMmXl;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CvY1UKHl;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=Pf9TMmXl;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=CvY1UKHl
Received: by kanga.kvack.org (Postfix)
	id D787D6B0825; Tue, 27 Oct 2026 12:13:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4FA06B0827; Tue, 27 Oct 2026 12:13:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3ECD6B0828; Tue, 27 Oct 2026 12:13:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 9D6986B0825
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 12:13:57 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 20E20C0A5C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:13:57 +0000 (UTC)
X-FDA: 85368902514.22.773A5C0
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf11.hostedemail.com (Postfix) with ESMTP id E2DF340007
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 16:13:54 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pf9TMmXl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CvY1UKHl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pf9TMmXl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CvY1UKHl;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793117635;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MBEQAycQgkIcEKsq6ztpW2tH5GM0tXm64sgJ8VgKzao=;
	b=yRt/ylmQpNeJpJ8JjqgsSwZrIoiCooZxb6GCC3ZoI0ESGh8v5LwRubddfVjfvquS1fkfmf
	sco3tqwXCJV6VyQ9JRwAl5ncnG+K3xe5te5N6GVIPbvuw3bYMFCpLS0b9SYVJ+3I0TkjHC
	PioIy+RZoBoERM6ML2cvMoW/1Zd7d94=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pf9TMmXl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CvY1UKHl;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=Pf9TMmXl;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=CvY1UKHl;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf11.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793117635;
	b=Ai/UJkn8VPsgSC6vmcz63IhkzUuaoxUlsFehcKFtp/dAggcVUmbSxji/FAGfL1pj4frrWl
	755SKjpIF+OjA9G7AG9icEEan93hvYKcLEXHtejSqLDd/5jAi5jP6QIZCDBIh0NmWI2WvI
	RyNKJlSe7413MY6rIXssKJalKFfJopo=
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A72371F7A0;
	Tue, 27 Oct 2026 16:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793117633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBEQAycQgkIcEKsq6ztpW2tH5GM0tXm64sgJ8VgKzao=;
	b=Pf9TMmXlDhCO4ynIeOuzNkis0rtWRzFwFx2jgiRQmuRDnln2k7nvVvhmkcP0jEP7dIidfr
	Bk9Z91c21pllbjuaaPr2fgK73IzUBOFhJWiWnPXD6TINWJnxzMN0TQKPGVdS/+GbDA8Z3m
	W8oQyc3pYUvTbT9+XEhV6lxyovFdl3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793117633;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBEQAycQgkIcEKsq6ztpW2tH5GM0tXm64sgJ8VgKzao=;
	b=CvY1UKHlmsc3sDkKp60Jh/ntQBcPqvbbbFSuHsUIh7jEbt5Go2TV2gTcqvAb3Q7XhLiFBT
	DMyyXxV3RhKSHVDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793117633; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBEQAycQgkIcEKsq6ztpW2tH5GM0tXm64sgJ8VgKzao=;
	b=Pf9TMmXlDhCO4ynIeOuzNkis0rtWRzFwFx2jgiRQmuRDnln2k7nvVvhmkcP0jEP7dIidfr
	Bk9Z91c21pllbjuaaPr2fgK73IzUBOFhJWiWnPXD6TINWJnxzMN0TQKPGVdS/+GbDA8Z3m
	W8oQyc3pYUvTbT9+XEhV6lxyovFdl3I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793117633;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=MBEQAycQgkIcEKsq6ztpW2tH5GM0tXm64sgJ8VgKzao=;
	b=CvY1UKHlmsc3sDkKp60Jh/ntQBcPqvbbbFSuHsUIh7jEbt5Go2TV2gTcqvAb3Q7XhLiFBT
	DMyyXxV3RhKSHVDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8A7221321C;
	Tue, 27 Oct 2026 16:13:49 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id dzfmFb3N4GrrdwAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 16:13:49 +0000
Date: Tue, 27 Oct 2026 16:13:47 +0000
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
	linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>
Subject: Re: [PATCH 46/46] fs/proc/task_mmu: refuse addresses beyond 32 bits
 on 32bit
Message-ID: <auDNot5mks8D_TJq@pedro-suse.lan>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-46-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-46-6f74bec9a5bb@kernel.org>
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spam-Score: -12.01
X-Rspamd-Queue-Id: E2DF340007
X-Rspam-User: 
X-Stat-Signature: ukegcn9dma1nggjq8hxo1xnooph37hy6
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793117634-545964
X-HE-Meta: U2FsdGVkX1//8XKBm0bW61Alt8LzGz/A4IbCdBMSg9keo+LyIZq2tGOlWJkqDMWRjLbapko/KofQ6jFqF8/LmLYh0MhXuayckskTR6345Z3vBHUQcx0A95ZH+Jdf8Beq2b3WfM4NSOsqUm0na/PBbL7vUWgF1JGCLM0PMDTq9tfeUWSf/bX8tDvho1LXIH5167+OXN6NMNjpZfVg7GOOdTz2W2bc8abqXsrOPf9HzakuHUveyZoQzqZtq8b8vfSNfXeDdhdKmy5YWGQeV1KiFonMecWFbrbeDrKPtUHeQVzjeyOmSkWgOmzOJOYJVJ2FnPe+JC9/zOdhv32cCCXm7hULa9bmWdMD11lNx2ikZF2SXRMwtiYYScTbrZg1i93Ur/rGOYeqFS4XbAzQgGlb4PJ4mX2/coxxys2ryrd9p4LGTMxSH/uPWCID/BXJ/eNHFC7V/0yXfbxqdyyYGMAv9+DSUyyzivAJLWv93MlM4AJuKlsiLeKhxZ4jaFA3tk9uG4xWDSDFre49CKcEaNrBXBNou2qmKfX00Xc98XSo8+zmPwR1Tj8N9CdyqtkdeOYakClJl3S56n2+zQhweiRkHqHZhKmoJwDerq53BVofD06pv39Z1qgpWpm96/qkmbra9fdksLExdxd6/hGiSyDV6xBdDYACr+3tlUp4yL0lKh1RUFd22E4+A0FMnCYIUDpPa4s9qJLMt8pmZ5Wm4Vfu7xp9tPSTo367QSbU8VRk6OMLCSMtryJWQjYeygylNSiRpyu1GghKudK8w1+oK3PIPPIFJCbv/QDaIGhXzLgzsBE1Dvi+S4Gs0v73M2mIDEY+FV1m/ia1NXXr32sr5/OgtXVTkStuJ5cOZr3xfftOEBe9Wg4jHxtIh4XPmBB/AdSNZMLSTh4uHJDHTQoKmWpx3Bxrfc2kUSSuEa8by5783rTAmYrEUGOrrtrdOdj4C0mmlQH/Fu1+deBM94xOd2I
 FBaIU45K
 c7XMyh56R+RyyLA8R6OQ+g1cwc0WZsYadKMChd3NQSxoJfdRGQoadWtHNnuHLK1nF6H6eEBpV9IikP4Aun5csfPaDwlHiqmmKrKpfIzfvng8nXs7v+HSLfda2GXvup3Vy8tve9MNKfii8LTmYGE8WrX/GH1Ds3io5x+L8p9VsXe0aWcbnRsA2U/7+XhaC/masPROq2W/bIldi0kSAgmINS+NmJTyhDj6Bnx9h/RlGOY66Z2xI24YsqKJ1F5a3VoX0j2ozpuJZQ/h2Ab0Io3Q6Kj95SRjfBj3BaNyQxqM5K3fB6010UDraUVvR2LiM4b0VVny7KdH1/p9t3KwNyDaEnZHipCFMRLqjiBqDCOOfaidu0X6nTb2TJFCz5q8Jbkl7Gn2ZGXE87eObkjjrOFraD2/PzAFINd26fzKIeSk+55YX6JeFr9ccJB97rhFqK6J+2aNUnreTfZ+zntDWOG50OncWnA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:18:06AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> The addresses in struct pm_scan_arg are 64 bits wide.  The first thing
> pagemap_scan_get_args() does with them is to cast them to unsigned
> long.  On a 32-bit kernel the upper half is dropped without a word:
> PAGEMAP_SCAN of 0x100001000-0x100002000 scans, and with
> PM_SCAN_WP_MATCHING write-protects, 0x1000-0x2000, stores the result
> at the lower half of vec, and reports success.
> 
> Return -EFAULT, as for other addresses outside of the address space.
> 
> This is probably not worth CCing stable.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: 52526ca7fdb9 ("fs/proc/task_mmu: implement IOCTL to get and optionally clear info about PTEs")
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de> 

-- 
Pedro

