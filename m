Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9FC05606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 10:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vAXE/qwo;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cF3JBpXF;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=vAXE/qwo;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=cF3JBpXF
Received: by kanga.kvack.org (Postfix)
	id C59A26B05B4; Wed, 28 Oct 2026 06:29:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C304D6B05B5; Wed, 28 Oct 2026 06:29:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AFA736B05B6; Wed, 28 Oct 2026 06:29:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 887376B05B4
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 06:29:39 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2936640C31
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:29:39 +0000 (UTC)
X-FDA: 85371663678.10.81630E7
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf07.hostedemail.com (Postfix) with ESMTP id 260F540002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 10:29:37 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vAXE/qwo";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cF3JBpXF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vAXE/qwo";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cF3JBpXF;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793183377;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EEL5oDWhHEdjo8Sxn2zwfAAZ42ECkaHCg/0wpruTF+0=;
	b=p/jESty47CKZOO199rJW9T+b34Jxt2XmOOv+MDdfAf10yQ4K/Y9LjqOUjDVJM9VB3Q3pl7
	Fvb1qCO7FOn2X/QrwurimAom7Uwhe3MWjsPSGQFQHNxTSuF6jGT98I9yVGshVGQDiyedpe
	BdnvbOdzeXSYonUUVN7aZaYo9JdZ4qQ=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vAXE/qwo";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cF3JBpXF;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b="vAXE/qwo";
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=cF3JBpXF;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf07.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793183377;
	b=yfn3VwM0L120ZV1cVLneCDhsSTowE6q4cb9gc4RhXOCxCECIc2f9LsVwFNbm1YBYIckjBA
	J9gW5iz5dHaI7Zfdn3gJs2QFOGngp3PLZMECbddugEKe+2msE8kl/2pjTOWseEK59pdNhM
	0j4yk02zHE1Qypkgzc52WxxJk9F8T0I=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 8D72322131;
	Wed, 28 Oct 2026 10:29:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793183375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEL5oDWhHEdjo8Sxn2zwfAAZ42ECkaHCg/0wpruTF+0=;
	b=vAXE/qwoncXkM8TjOqZD2PIHsIovoiM/SvbdhsXt0+wjo2xHO7fkVXopC/X0M7wR3APhgO
	lT679EqGmlYnedSYKV5P+MfhfKjwupcDvlsD8UcgfqcK1e+Bn1s7axpBpdMnGcZLUWN6/Y
	OK0ITJIYX3Q/Zt01cm8+foVENpnPz3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793183375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEL5oDWhHEdjo8Sxn2zwfAAZ42ECkaHCg/0wpruTF+0=;
	b=cF3JBpXFOM8H++ei+gdBD6WtRJzOmbHmWfsG16glxpCb5uw7cI1wy/fckjlev/r063Zcn7
	3hUkITI3RqQxxMDQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793183375; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEL5oDWhHEdjo8Sxn2zwfAAZ42ECkaHCg/0wpruTF+0=;
	b=vAXE/qwoncXkM8TjOqZD2PIHsIovoiM/SvbdhsXt0+wjo2xHO7fkVXopC/X0M7wR3APhgO
	lT679EqGmlYnedSYKV5P+MfhfKjwupcDvlsD8UcgfqcK1e+Bn1s7axpBpdMnGcZLUWN6/Y
	OK0ITJIYX3Q/Zt01cm8+foVENpnPz3k=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793183375;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=EEL5oDWhHEdjo8Sxn2zwfAAZ42ECkaHCg/0wpruTF+0=;
	b=cF3JBpXFOM8H++ei+gdBD6WtRJzOmbHmWfsG16glxpCb5uw7cI1wy/fckjlev/r063Zcn7
	3hUkITI3RqQxxMDQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 81CFD1321C;
	Wed, 28 Oct 2026 10:29:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id XiQoFIvO4WqxewAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 10:29:31 +0000
Date: Wed, 28 Oct 2026 10:29:29 +0000
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
Subject: Re: [PATCH 01/46] mm/mglru: don't use stack pointers when walking
 PUD and PMD tables
Message-ID: <auHOYcRfFFs3xhXa@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261027-fixes_core-v1-1-6f74bec9a5bb@kernel.org>
X-Spam-Score: -11.80
X-Spam-Level: 
X-Rspamd-Queue-Id: 260F540002
X-Stat-Signature: w4f5fc36i13f9qd68uqymaqj1i5xk1ic
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793183377-731837
X-HE-Meta: U2FsdGVkX199075VOHKoSzaV/4TPCwyas6Xce7RHJ0Vjtixkj7V+9mAsXL0sOgxjtRr9jJ2v/UfJekOIvwpreFLJjhbGlXPto3IW+py7WIB38Yt8swxgI1VFjIe7beAXerszBIw0kIs61jGDd4M5cnNcKs+XFndu7I8fIQiWb/PAZdgik13HgsNjwnyZJFZcbokCPDiJl/KKJqo3xy1fA975xnPxi9UOKrRmkypJU+5jAKM0V2YiYSuuTbwegAoSjYsjTsRir1iSrtLeBFCnxkpSx72YY7ZPlZgIEQh/UTipD1mgrta5kGxUhrD3JsrQ9dWmxDN5yCF2XDxQKT6Yzig7wyc9kBGCZ+LAdNu6FJL1k6kA1L02lcVhzsPbKseILHK1rjdMj2+CPdyg/eMz8DJx+o6FpoIB9ngSQfV+TJyKZKj+GVnAhg2YdJJOT9UAC5nmJQBUo1JFm+YVp9QTKPpClZYLCWxXQnXN3A4Y6/0RIZ09Q0cj14onyja2FxHXkiRazh67F2CwbE2iWpbDO3GjBSQqWnR5NV0AzgA8mA8LmXYf9Ev1L8F8ehKV10ldukn8KuhlBq6lF/L+KIBkg40gsnJpQ4s3/BOquvKVSwz8IrbLSDpX1NDYuzO3zl8oTrCEGaetZXnauILiG017VDAi6HS0kSvXx6FMnIgFXDnfbOBYXu6Ck/60KNEmCxkFtTHHnB+X4K8e8REybibJaA63aYfJb5BGgj8VXRs5W8Yw0TZXEXIzBqTz3ZDRXOGxDl4zRSymWPASrqaV1ZSGk8cVDBfhAtkTYjW4aajjIY0MJBFviOutp7rtRFLxrnA3eMwoT/fWYOAhdc5BMKjKYcQQRXC2bOtiolHJ0qzOhoPbXVyuYYR1Ius2HuAkyP01FCmT7fuqMOG86+RKpoO/M8eSsvTQCN44nG+kvUbJRevhGTNExUWwm++ypkkd/aOkzKeOA6NjYE8TBR5p9P7
 aZ/ywoHa
 dSnfKILgBHsVLZm4xv02VvuAISjusq5FPdopU6wmI/aV/Z5zuGTJzDqsjLhtzRr7RwNjSxgai0o/tlBqpspYuf8XyuzFmGtv9qGr4/0mwrZ59vrL/cqBisYMrdj9ealCdNTJBn/AmReD8p9Haec7I9OANm4kEAEEN7MBaEgZehOsv+ThIivG/vt7ckV72RIomBIrCkBi4BgMHaVaNr+t3wX7y0HCV9nx+RCnjd4bGHy1qE3STJmom0ZcUGo0Oe0xhzpF3Y/9dzFYVTlS60sbE5CrcsF6o80CK02UHI3k0B+7J2lAimE+xW89Wp6ZrJOPLlDjTFl7wbrUEo4Wq9RoyXClbKvE45kPZyv6/DKiP6GO/aYUu0kRnd0FbrqdX96T9SOxWgRx2SGh4kheVhDtsd3TUgW4wa9b5iNFrsWiShBDgMo0=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 27, 2026 at 12:17:21AM +0100, David Hildenbrand (Arm) wrote:
> From: Josef Bacik <josef@toxicpanda.com>
> 
> MGLRU passes stack copies of page-table entries in walk_pud_range() and
> walk_pmd_range() when walking to the next level. These copies can become
> stale when khugepaged or MADV_DONTNEED (CONFIG_PT_RECLAIM) removes a PTE
> table concurrently.
> 
> This pattern dates back to commit bd74fdaea146 ("mm: multi-gen LRU:
> support page table walks"). Likely, earlier locking masked the latent
> bug. Later changes exposed it: commit 1d65b771bc08 ("mm/khugepaged:
> retract_page_tables() without mmap or vma lock") allowed concurrent
> retraction, and commit cf4a65539c13 ("memcg-v1: no need for memcg locking
> for MGLRU") dropped the walker's outer RCU protection.
> 
> The fix is simple, so just fix the original commit so we don't have to
> speculate. To fix it, pass the actual PMD/PUD pointers. This restores the
> RCU-protected lookup and validation against the live PMD. Note that the PUD
> handling is required as well to handle folded page tables correctly in all
> cases.
> 
> Fix generated by an LLM and sent by Josef Bacik in private.
> 
> Fixes: bd74fdaea146 ("mm: multi-gen LRU: support page table walks")
> Cc: stable@vger.kernel.org
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> [ david: handle walk_pud_range() as well, clarify+simplify description,
>          adjust Fixes: ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>

I see we're already trying to beat the R-b record set by Gregory's patch.

Reviewed-by: Pedro Falcato <pfalcato@suse.de>

-- 
Pedro

