Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37805606A323
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 12:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=tEm5XV3K;
	dkim=pass header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=3L4wVEOZ;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.a=rsa-sha256 header.s=susede2_rsa header.b=NuxsBLoI;
	dkim=neutral header.d=suse.de header.i=@suse.de header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=d7ad5oBI
Received: by kanga.kvack.org (Postfix)
	id 5A5FC6B05B0; Wed, 28 Oct 2026 08:55:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 556DC6B05B1; Wed, 28 Oct 2026 08:55:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 41EBA6B05B4; Wed, 28 Oct 2026 08:55:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0CD1B6B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 08:55:14 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 82523C0C49
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:55:13 +0000 (UTC)
X-FDA: 85372030506.30.30260F2
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	by imf03.hostedemail.com (Postfix) with ESMTP id 5757B20002
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 12:55:11 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tEm5XV3K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3L4wVEOZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NuxsBLoI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d7ad5oBI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793192111;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Ar7R9QMU32qAcY23nIeGRlAcN3VSNOddD17DmoDp+Wk=;
	b=OKOudkZK+eAk+vCR2EDqHqVk2Va9pu84IfMFyLy7kq3yGP85W+qo7X8/cw3zhLkimoeDh/
	NviG98yuA81OxUJArauYQ5YZhZ6mYUmnSYiCrXlWh1SMVQ9qnuxEgibzTEJ1vuvokFP+Rn
	89X2ukxlPjO6xYVGwDBT4Fzlzva0Ahs=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=tEm5XV3K;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=3L4wVEOZ;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=NuxsBLoI;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=d7ad5oBI;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf03.hostedemail.com: domain of pfalcato@suse.de designates 195.135.223.130 as permitted sender) smtp.mailfrom=pfalcato@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793192111;
	b=SRIL/gh2xt372GosNLv6JXk5oxf3VjYxaYbvO5RZzkW8tnpm9pqpbIi3Pd73pehanVjBq3
	F5sS4zeB6sXMpXwXDQRuqYp2uzkvjoSCtZcfvWbWS/iQcoyLhA9iSMzGqQSAJCvUCjarZk
	sFWHBhs0oaR1DGZpeLHh8kP+kYor+wQ=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D40FD2213F;
	Wed, 28 Oct 2026 12:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793192110; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ar7R9QMU32qAcY23nIeGRlAcN3VSNOddD17DmoDp+Wk=;
	b=tEm5XV3KjbEjA41ZoYQtFK15SnyJr/jro2kAD7VcJ5Nd+xXCeh4MOSDOSl4gs16gOuMj1n
	2xE3J3A8sl5Ltrq85nxbmFf18x515DUo74zEDgzkeO03pvq4GMkN0dvsQ2UQX/6VJbcXMi
	2SihNsvbiknM4tPeVmrkd8edOj2h7vk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793192110;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ar7R9QMU32qAcY23nIeGRlAcN3VSNOddD17DmoDp+Wk=;
	b=3L4wVEOZnbwLwpiT/6p/yUN1CGm8BCBGENEqGDXYvBfXN4ALX7tkweq+NQgRINIks9l6SY
	Oj9hq1SccSlw7FDg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1793192108; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ar7R9QMU32qAcY23nIeGRlAcN3VSNOddD17DmoDp+Wk=;
	b=NuxsBLoIZe0RCX6eCWMO4BBI2zD4MDPTwQN+oGb/8EVr6QFJtbQrfT5EbmRflQ0wO1Fq9+
	IiN60C3UHKnxFucRljWSZMNVNDbWigF0ESpMoTysxKkpo6/YVc07F+3JRBXFFVsBG8uZ8G
	IeyoyClDdnZWvRm7F4ix8zVnXzU760c=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1793192108;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ar7R9QMU32qAcY23nIeGRlAcN3VSNOddD17DmoDp+Wk=;
	b=d7ad5oBIDy9uyvYJSfVkcYBqi8kIr0BJCTIvUM3nFJwDeXTA5GEVesAI5PARxFiR78fYFd
	Yu8Y7PsZt+zW+8Ag==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C6B0113419;
	Wed, 28 Oct 2026 12:55:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id UmP0JKjw4WpyFgAAD6G6ig
	(envelope-from <pfalcato@suse.de>); Wed, 28 Oct 2026 12:55:04 +0000
Date: Wed, 28 Oct 2026 12:55:03 +0000
From: Pedro Falcato <pfalcato@suse.de>
To: Barry Song <baohua@kernel.org>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
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
Message-ID: <auHve-G8bboW77IZ@pedro-suse.tail5790ac.ts.net>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
 <20261027-fixes_core-v1-2-6f74bec9a5bb@kernel.org>
 <auB-3BQn_rR6IfY8@pedro-suse.tail5790ac.ts.net>
 <22b819a2-631d-468e-b724-770caf9f94e4@kernel.org>
 <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAGsJ_4z3qgCPBpCDitVTq+xiGsS=-yEhKSbEO4Lbdn9MVAHK0g@mail.gmail.com>
X-Spam-Level: 
X-Spam-Score: -11.80
X-Rspamd-Queue-Id: 5757B20002
X-Rspam-User: 
X-Stat-Signature: 8zh3ye8jhte6xwt8w5bkg5uqbsuq9un8
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1793192111-198798
X-HE-Meta: U2FsdGVkX1/iJ925HZ1X1nq+I4naDtg71T+NncKYanubwtPnNbUB76J17uB04dTj22km+8FetJ/gsBZv3edAPvMdy5MHnvrH0Pa2dUDFxWJa10YpG5wX6AE3ak3vza+LyNWjLN/fchUC/yBMR98ISdNdK2EbGRCr77uaiBGnhqV/pGeRH8uypHojdjpyi9uewchxIboGxA5xlhZd0w3hQIePPfff093KvEcNkBTBLZejJIBwmh80Ehy7r4veNcSFE2RNmss7WmEIpQT7YUpwfQS3q31/FNRHu0vxobW+VjH6QGItmJVS/Ghxphc8PNUpKi6Dw2OyjE8TBNELP+/FThZE+38kquXtM5904+l4ybX3zO2i1MaaHOBlDegdXRffs7g3PEJ647pAfcP8MD506chb5nbg5zaiTurCpqIAq4TOkeTU1dGl9JQ+8NV1XRtjZJe1cFb7NbTq0jnsVlR2VntGUv4ZLw9mIIZaCN7JSQ12P/d8tcvmpzcwSPd/ut3y/lJImA29OOW+m8Xnttwb20tetIQupMnmE3G5UAg9VIy2wWjPHCdEGKf33vOEDeTM8qmVEkHwridSWBFIXaNP599wR7VV6xS+sn3Ukyn1QKsYHhvUbjAGE5F6/PYMsXrDN1S6YoSZ6IcPRm5V+DEzdBMpf0L5WDt2at58UKU3SiMFt/cL7trvzNMysT4lPusDBllDfJSrNUnEhXw4SFKMSsnhm6qTxNpf/5NXaSNxbCUSRQOhA+mq/b+aKYeaP9HwFqMBux8Y6rhZCfiwgRKfmRs8aX/cQ3rHqexan6NMhHY9hK04hUPV6yRC1GW64WhJOQkd2O1kpUo4JKOHQKNnKw36ae6Mi0C7TZL5OmIQL8jlnSDiLARVFFZOLRWAzjwAjbo0ghznubi9G0vaGxIUWZvxnKFz8wYKItmEbLXKgAhDrHUoEIzLsep8d/z5919/mEjQ5g/LeHrrgotZKn5
 JRzaK/4D
 y//DGMv23B26tMSERQcCkwViHeQ3w2V0FZAlPxpZ5enAhp+gj3DWZ81qsifga9RyA5wt7vV3DcZnQ9sN8xiZAZIYE1KTUg+lDdOyIbiVi6KxCLQUtu9oeBH7PzmFRlBou4FrqB3gg1YdCIp3GHuJgSdmLDTicbqJT7RavJ+aoHltJ1f2BE6JZ7NybGQ2r8B55NxZdUumu4wKdONb8Uq3CuT1TVdstDADdYmjlR8GWRC/MDPm7zl51z6LmrvS2gXZKgvUWC4apBbJN12Mwfd5vVOhkNSp/QWw30AjYIQLEtfrkRnWYpZOpiGBHUB1+Kp5lAxcML//2aCC0mBdtXsEYTI8pqlzIw4zGCuqrFGvX5sKQA3+RYU1LyR56uSiUYURGM5U5oImIfA8N9XHA56n9MzidfVqv7qUGZwEvv+7/StsN86qaq6V4C/nNpT5pEoye+c7N0zUp/R5oU1a4X8dLYRGqLSAqqS9CEhSiomGcpJmTtts=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Oct 28, 2026 at 03:48:09AM +0800, Barry Song wrote:
> On Wed, Oct 28, 2026 at 3:07 AM David Hildenbrand (Arm)
> <david@kernel.org> wrote:
> >
> > On 10/27/26 11:38, Pedro Falcato wrote:
> > > On Tue, Oct 27, 2026 at 12:17:22AM +0100, David Hildenbrand (Arm) wrote:
> > >> dup_mm() copies the parent's mm_struct before dup_mmap() takes the
> > >> mmap_lock. A concurrent brk() can leave the child with a stale mm->brk
> > >> and newer heap mappings, causing later brk() requests to fail.
> > >>
> > >> Other operations (e.g., PR_SET_MM) on the parent's mm_struct can similarly
> > >> cause inconsistencies.
> > >>
> > >> As a simple and robust fix, grab the parent's mmap_lock earlier. This
> > >> way we don't need to update individual mm fields in dup_mmap() and
> > >> keep missing ones. Stop updating the 4 existing members (total_vm, data_vm,
> > >> exec_vm, stack_vm), as that is now no longer required.
> > >>
> > >> Keep releasing the parent's mmap_lock in dup_mmap(), before
> > >> userfaultfd completion, to avoid moving the userfaultfd handling into the
> > >> caller. This should get cleaned up later.
> > >>
> > >> Move uprobe_start_dup_mmap() to preserve the lock ordering.
> > >>
> > >> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> > >> Cc: stable@vger.kernel.org
> > >> Reported-by: Josef Bacik <josef@toxicpanda.com>
> > >> Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
> > >> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> > >
> > > Reviewed-by: Pedro Falcato <pfalcato@suse.de>
> > >
> > > FWIW, strictly speaking malloc() isn't usable in a forked
> > > (multi-threaded) child, but glibc/musl provide this in a best-effort way.
> >
> > Yeah, I'm more concerned about other things that can race ... :)
> 
> Regarding the race with memcpy(mm, oldmm, sizeof(*mm)), we
> still have one [1] even after this patch.
> 
> That is, copying mm_struct can happen concurrently with
> lru_gen_del_mm(). However, this race doesn't seem harmful.
> I might be missing something here though.

I don't think it's harmful as well. mm_init() reinitializes those fields.

Though I hate that memcpy. I think that ideally we copy by member and
data_race() benign races, like what is done in vm_area_init_from().

Anyway, KCSAN reports aren't the most serious thing in the world, so this can
(should?) be cleaned up later.

-- 
Pedro

