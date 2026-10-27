Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8A9D2606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 10:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=BpGgmKPY;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JWtkTaQe;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=BpGgmKPY;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=JWtkTaQe
Received: by kanga.kvack.org (Postfix)
	id 9978E6B068C; Tue, 27 Oct 2026 06:38:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 96F5C6B0696; Tue, 27 Oct 2026 06:38:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 884DB6B0697; Tue, 27 Oct 2026 06:38:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 5D6536B068C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 06:38:32 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 45AF21C3C1A
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:38:31 +0000 (UTC)
X-FDA: 85368057222.28.C3F3165
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf01.hostedemail.com (Postfix) with ESMTP id 2EFDE40005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 10:38:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BpGgmKPY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JWtkTaQe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BpGgmKPY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JWtkTaQe;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793097509;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=thOdz49DJmOvWZo66WX+p09a9NHT1DFOX3BcLmDx8JY=;
	b=rAP9Cb7YfHHSFxUv6VRxNURCabgs+dGRSBrTsN2kRoouPCm+aHEynTe/h+/v3bTw6UBAFL
	f9ISweP5xQUhB44He5EsWtm4xGBRuYapxO61AQB3rA0inQOtse6VL1Du137WM8eJgupRHy
	Eub8BuYe7TSmo8aLMHY6nHrcn7FTnYY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BpGgmKPY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JWtkTaQe;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=BpGgmKPY;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=JWtkTaQe;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf01.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793097509;
	b=YGLZJatOIJC5U/JkcZRTh/EyaChBP/1HyNcVY9SB0uJMSFidzSu8jENhjXWd2EgJbFfrqz
	PbWOfVB+2G/lIf2CsppQF2yfrLOjzcZhrdpV07Dg/mtwYKldaal9Ilqxr4RoeDXEGV7xI/
	jtH502MSpNGILncDJRrNmrCQf3GEDPg=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id CB00E21E9F;
	Tue, 27 Oct 2026 10:38:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793097507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thOdz49DJmOvWZo66WX+p09a9NHT1DFOX3BcLmDx8JY=;
	b=BpGgmKPYTeSncqrm7zxPBRHnG/u5ryzZ9r1jVo6ID6wD1bxwm2J4KpOavjan4G7kyDB/4e
	O1lrASYiwPI0/JJMTkmqjkkX6Er6miQd/Gew8mKhMIAa5YJNkLFiGwnnc4zAPLYnDbkQQg
	88Z4X0NIdKihF27ZPrcLU67e93uVpEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793097507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thOdz49DJmOvWZo66WX+p09a9NHT1DFOX3BcLmDx8JY=;
	b=JWtkTaQe8pEI5uGyjL0X8b2nwfsW21hp7IHkL0SvfCfpVJnRH0y9gc9gMfbD5rgrLKCnhs
	5PvGRnQ/ESJixYDw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793097507; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thOdz49DJmOvWZo66WX+p09a9NHT1DFOX3BcLmDx8JY=;
	b=BpGgmKPYTeSncqrm7zxPBRHnG/u5ryzZ9r1jVo6ID6wD1bxwm2J4KpOavjan4G7kyDB/4e
	O1lrASYiwPI0/JJMTkmqjkkX6Er6miQd/Gew8mKhMIAa5YJNkLFiGwnnc4zAPLYnDbkQQg
	88Z4X0NIdKihF27ZPrcLU67e93uVpEM=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793097507;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=thOdz49DJmOvWZo66WX+p09a9NHT1DFOX3BcLmDx8JY=;
	b=JWtkTaQe8pEI5uGyjL0X8b2nwfsW21hp7IHkL0SvfCfpVJnRH0y9gc9gMfbD5rgrLKCnhs
	5PvGRnQ/ESJixYDw==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AB7171321C;
	Tue, 27 Oct 2026 10:38:22 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id qws4HB5/4Gp7GQAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Tue, 27 Oct 2026 10:38:22 +0000
Date: Tue, 27 Oct 2026 10:38:20 +0000
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
Subject: Re: [PATCH 02/46] fork: take mmap_lock before copying mm_struct
Message-ID: <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2EFDE40005
X-Stat-Signature: zbd9njepxbwf5zk3fkns9ughwgffmp7k
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793097509-689996
X-HE-Meta: U2FsdGVkX1+McSWZuEII1VMIN8Wvw6UQpsx3jeHEKZVdm9fP4txWm/3OpyPBs4Qgnp99Xut91HtWrft/+7337l7282fCVKbqMUgFZnwwAwUXPaTFq7o2X9+YK1+mFbKZq44APDOKs1oz/wYP3k31soZtyjX5KLIiJ9g0dkiyb2hP4uC/md1WPHhv4w5bB9KAhwKygwDYQdPcYrUtxRgM7RSjbcsouZkMt4Qxi1ZwLfgrkSBc4LiBoVkKZEISfbe8XMPrJJ3Wi3BdKKHfmtDgVjVgMLpPnrANPLmUbJjNN2bKwB+88HdbNJ4pi0zkv1paK7srxzn3mKuovAC3165i3MNBlOwwcFoAjkeyuNcyxbQ0mlPsS/z2GduhmQKL3I2jOSHWvibtWVzhbaCoXNsfjLDIiGASAxJzzb6bT9t1XLb3BbB2IqFwSjZ5FSttQ90jkowpAz4UbtMndIbOaUumj6LmPbIAusgKU3BHX0ZtrIFH4b5HiD1Y6cK+rL8V+72rw2HcF96wgZbqma+o0RQIT/oSp1W/hu3oF+4WSZcbDNs7jX9sC6qMB0ysMVWsjfZXkn3/AVi9T6zB5a1gsXgf29xxIf3RmuCJSLniMxca/UCXWr/nZIHAWxLzrKdghwsMoN32foUeGYVtd04WDvX6uqFJJBtiFsye7uhvs6kJ/xq1nljwJ6/LX6/Pi+tTUlZ04VcYgTt7DuwGcFhHBnVm/dfzdRy3nWnaDUL718LlzF1eo+yubxgoKWynoL75FPwOks22YiC7kKcC/iLryLJx71nUiqq31Vn1/5lXjZbb0FrrxTGKyHsP8jIMjQh34BYIjR5Wd8bd45bhOrY4SLdawf+gz382tAyJ5hMCQZHkqXLrOy+mynMz2IJwEiY+gvvj2BwUq+eAXfTGTg2TtotPPCbkKw8mkhqJ93O/ctmi3Mtmyx1Qk6Gl5HtJSZ2xnB/Xm84y2p8UinR+aW8Afch
 b4bbIOhv
 cvkQpcPgWcMcnP1yQppJu5srPKrJ3J4lHTUCpTFI3nBMagIUGPoheNQbKaLXVItjZpU2LddwSBBwhsKA/Ile4wgTk2O7UerxpXcPwzcTTBGZlmuiuh56Mh6bainVe63Fg0ijoq9PyUsNZuqwH9HWByJvBjtZpHlqziUOQB4ANGNnSR2vfa+cDdT0efcNj4wBlp9BaLDFVl6Mu1KD3cZdjFHjEiWJtYz3bWM9V6DMYaSDOlBCfv3GnoCe1oUg/K5jUnfGaQhkvU8PI7jNTA1/gV1m5M1K2FAv/Kyh1dsmcbhkmJDtgcHp3IYqHLSdDc0o8v0cjiOxSZAhI+dvyKJtZqNoJ6vAJm23T2lo0l3QXnG6lSbzCdBE/NfIY3qV/3i2ERIiMBurCv6vfhhjpCAeFz5xErPHmbVFwHs3+NeW0kWNO3hPLkH9U2+Y5k184K9WILTLWu+6bxD80DmrYLDyeR5ZHNw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) wrote:
> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> and newer heap mappings, causing later brk() requests to fail.
> 
> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
> cause inconsistencies.
> 
> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> way we don't need to update individual mm fields in dup_mmap() and
> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
> exec_vm, stack_vm), as that is now no longer required.
> 
> Keep releasing the parent's mmap_lock in dup_mmap(), before
> userfaultfd completion, to avoid moving the userfaultfd handling into the
> caller. This should get cleaned up later.
> 
> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Cc: stable@vger.kernel.org
> Reported-by: Josef Bacik <josef@toxicpanda.com>
> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

FWIW, strictly speaking malloc() isn't usable in a forked
(multi-threaded) child, but glibc/musl provide this in a best-effort way.

-- 
Pedro

