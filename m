Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A71FDCAC5B8
	for <linux-mm@archiver.kernel.org>; Fri,  3 Oct 2025 02:08:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E52228E0002; Thu,  2 Oct 2025 22:08:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2A2E8E0001; Thu,  2 Oct 2025 22:08:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3F798E0002; Thu,  2 Oct 2025 22:08:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id BDF848E0001
	for <linux-mm@kvack.org>; Thu,  2 Oct 2025 22:08:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5B71CBAC41
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:08:12 +0000 (UTC)
X-FDA: 83955168024.08.211A50B
Received: from invmail4.hynix.com (exvmail4.skhynix.com [166.125.252.92])
	by imf24.hostedemail.com (Postfix) with ESMTP id A6206180006
	for <linux-mm@kvack.org>; Fri,  3 Oct 2025 02:08:09 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	spf=pass (imf24.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759457290;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Oe8RHWVHHO4cxX1PPZ91AkP2NxImL5Jxo4efstn3LuQ=;
	b=tG3ZjOW0JJj0UFm5Ajht3DN9C3t+Q/sLfuzUEy9aJy5HKMAW+3l2fRbkXqGI+ZuuR19ygD
	KypaopoN6DbgYRkKp1E43QJ3JpNmkhaq6T8w7o89WirEmQ/1mM87MUwwuoF+AzFnGfcz/8
	gR+keR/AKUSSkWLsyEyyp81D2G0TUl4=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=none;
	spf=pass (imf24.hostedemail.com: domain of byungchul@sk.com designates 166.125.252.92 as permitted sender) smtp.mailfrom=byungchul@sk.com;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759457290; a=rsa-sha256;
	cv=none;
	b=RahsVHPcdbKZ1lFNxzoZo/dVCjvOww15T+dVUC3FfecmEXYMXMrs+yX5tMoSbx7XxlmjJI
	MsG03Xv4WT20sRQmS/NxubvgHffDv8eS2YDoYEepMsPOGacjrnNJB4M0fGsOShSgnkOmga
	m58f8yLYnlxSuLL4H7IHf7aDERIglbU=
X-AuditID: a67dfc5b-c45ff70000001609-fc-68df3005d372
Date: Fri, 3 Oct 2025 11:08:00 +0900
From: Byungchul Park <byungchul@sk.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>
Cc: akpm@linux-foundation.org, david@redhat.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	gourry@gourry.net, ying.huang@linux.alibaba.com, apopple@nvidia.com,
	clameter@sgi.com, kravetz@us.ibm.com, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, max.byungchul.park@gmail.com,
	kernel_team@skhynix.com, harry.yoo@oracle.com,
	gwan-gyeong.mun@intel.com, syzkaller@googlegroups.com,
	ysk@kzalloc.com
Subject: Re: [RFC] mm/migrate: make sure folio_unlock() before
 folio_wait_writeback()
Message-ID: <20251003020800.GA29748@system.software.com>
References: <20251002081612.53281-1-byungchul@sk.com>
 <aN5lOFVFfewXUijF@e129823.arm.com>
 <aN5mwwFE2aEJwlT1@e129823.arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aN5mwwFE2aEJwlT1@e129823.arm.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrIIsWRmVeSWpSXmKPExsXC9ZZnkS6rwf0Mg70T9CzmrF/DZrHrRojF
	+sZ17BZf1/9itvh59zi7xcXXf5gs7i97xmJxfOs8dovra48yWVzeNYfN4t6a/6wW3/qkLS5M
	7GW1OPKmm9li7hdDi9VrMiy+rF7FZjH76D12ByGPNfPWMHrsnHWX3WPPxJNsHt1tl9k9Fu95
	yeSx6dMkdo+Fv18we5yY8ZvFY+dDS4/e5ndsHh+f3mLxeL/vKpvH3etAZeeu9TF7fN4kF8Af
	xWWTkpqTWZZapG+XwJWxdsYe9oKO/Ip3/S3sDYzHvbsYOTkkBEwkzi+9xQpjr7y8mw3EZhFQ
	kbi0chELiM0moC5x48ZPZhBbREBVYnH7GaA4FwezwGFmicavn8ASwgLhEtPbz4E18ApYSGx5
	vgvI5uAQEqiX2P/YHyIsKHFy5hOwEmagmX/mXWIGKWEWkJZY/o8DIiwv0bx1NthETgF9iYWL
	54OdJiqgLHFg23EmiDOvsUu87JOBsCUlDq64wTKBUXAWkg2zkGyYhbBhFpINCxhZVjEKZeaV
	5SZm5pjoZVTmZVboJefnbmIERvSy2j/ROxg/XQg+xCjAwajEw+tRcC9DiDWxrLgy9xCjBAez
	kghvwoo7GUK8KYmVValF+fFFpTmpxYcYpTlYlMR5jb6VpwgJpCeWpGanphakFsFkmTg4pRoY
	jXq5zkRIxV780L+1/HxxXoBk5O3gSutTadv/HzdPFvBNbs5QmCGj/cZ1uVLur/TtKdslbffO
	YPMQ26Z/2dBxdrbTteKFLe89HHbxTdTtWhVRZMjx5/vy5SLlmk7d9y38b+6fFMqpqTRtzr8P
	32avkZ3rwbSwJuTwJMW6WUfvfFZ/OmN1Rxy/EktxRqKhFnNRcSIAxvp0UOQCAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrHIsWRmVeSWpSXmKPExsXC5WfdrMtqcD/DYNYWRYs569ewWey6EWKx
	vnEdu8XX9b+YLX7ePc5ucfH1HyaL+8uesVgc3zqP3eLw3JOsFtfXHmWyuLxrDpvFvTX/WS2+
	9UlbXJjYy2px6NpzVosjb7qZLeZ+MbRYvSbD4svqVWwWs4/eY3cQ8Vgzbw2jx85Zd9k99kw8
	yebR3XaZ3WPxnpdMHps+TWL3WPj7BbPHiRm/WTx2PrT06G1+x+bx8ektFo/3+66yedy9DlT2
	7baHx+IXH5g8zl3rYw4QjOKySUnNySxLLdK3S+DKWDtjD3tBR37Fu/4W9gbG495djJwcEgIm
	Eisv72YDsVkEVCQurVzEAmKzCahL3LjxkxnEFhFQlVjcfgYozsXBLHCYWaLx6yewhLBAuMT0
	9nNgDbwCFhJbnu8Csjk4hATqJfY/9ocIC0qcnPkErIQZaOafeZeYQUqYBaQllv/jgAjLSzRv
	nQ02kVNAX2Lh4vmsILaogLLEgW3HmSYw8s1CMmkWkkmzECbNQjJpASPLKkaRzLyy3MTMHFO9
	4uyMyrzMCr3k/NxNjMBYXVb7Z+IOxi+X3Q8xCnAwKvHwehTcyxBiTSwrrsw9xCjBwawkwpuw
	4k6GEG9KYmVValF+fFFpTmrxIUZpDhYlcV6v8NQEIYH0xJLU7NTUgtQimCwTB6dUAyP7DLEp
	de+fWXUoNh29836ysr/Xbo58g4teU5YvOuM3MfFt1k2mXJ2IT169C5fVzXgZK7l7WuWZeUkG
	1plHbkb4lndd5k3Y4b3aLpzdl+ef5IELV7mWvTz8bN33hTt+r3kczWEyZ4dYko5uR/3P5zO4
	yz/vYDPyOqB6Rjxq/i7zozunqewo1xZRYinOSDTUYi4qTgQAu5HYnNECAAA=
X-CFilter-Loop: Reflected
X-Rspamd-Queue-Id: A6206180006
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 94hf4pre7nzh6uaryghk3ht9xhiz5zm8
X-HE-Tag: 1759457289-411056
X-HE-Meta: U2FsdGVkX1+GCk39vlLp3cQUqM2YJjW61tOteAsEhdJdrHVcksIKyOa+5YEvLmXW3jfxOBQaFCKlBP76CUFd5Uw+evwU4P+unETQdk9u/UAIwtuVET0OhjnBkl9YCv2CyjqCDeeWRlGot3qjNaOUMHdrbVzGAXvih70Vwb2yy4GTCS2+BSn36Ed2VkndJoTssn47UOqy08wFiAYnb7hMs1SjcY/AfBjgvlLczkd+NFgWCkWv9x7I/XrvBybwLgyWEiLdLZb17T840teIUEOsuz996IScWxhYjetsGEL66i2+8nX6C198jqjoeiwizpQLGbBaKeYNZyYng+4YLufR/OWByIqufg3J8440cd9bM9c2+HfMkIyuk/dm3K8AgxkRWnhuQe0HZhFhbAopBruqKy6xLpvEVMKCMf8+rlS/Iw8GAFRHh9n//JlLzboLrjPOeiBxL4Mye35k+Z0C0OjReotaH3SBZ7CKCADl/Oo1+QdXW1e2uOOWApp6f5DFbRXFzkFl8oNCE+NCG2CDVH4gbsTuimJdcGwuUBMT6pKlO99Uh6jtcJjProWWL2IrkVl1mbVfqoOSRd1G1LnPknYUI+jIO7EiJEGkBlesoL9NHuZ69St1Bcl4bxrsgoBcXO2+0ObZqQcErgmiE3bj+YdFBy1XvLEv44bL+mQEKaNSnj0siDnQ1OdE9hX9PE5KpJMGkpSw03Kxzgyd+jl7AA1VZS8GCT16cAqaqfjVa+s8CzUqunUtFXFGUgMpEDLdKoo1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 02, 2025 at 12:49:23PM +0100, Yeoreum Yun wrote:
> Sorry code was wrong.
> > Hi Byoungchul,
> >
> > > DEPT(Dependency Tracker) reported a deadlock:
> > >
> > >    ===================================================
> > >    DEPT: Circular dependency has been detected.
> > >    6.15.11-00046-g2c223fa7bd9a-dirty #13 Not tainted
> > >    ---------------------------------------------------
> > >    summary
> > >    ---------------------------------------------------
> > >    *** DEADLOCK ***
> > >
> > >    context A
> > >       [S] (unknown)(pg_locked_map:0)
> > >       [W] dept_page_wait_on_bit(pg_writeback_map:0)
> > >       [E] dept_page_clear_bit(pg_locked_map:0)
> > >
> > >    context B
> > >       [S] (unknown)(pg_writeback_map:0)
> > >       [W] dept_page_wait_on_bit(pg_locked_map:0)
> > >       [E] dept_page_clear_bit(pg_writeback_map:0)
> > >
> > >    [S]: start of the event context
> > >    [W]: the wait blocked
> > >    [E]: the event not reachable
> > >    ---------------------------------------------------
> > >    context A's detail
> > >    ---------------------------------------------------
> > >    context A
> > >       [S] (unknown)(pg_locked_map:0)
> > >       [W] dept_page_wait_on_bit(pg_writeback_map:0)
> > >       [E] dept_page_clear_bit(pg_locked_map:0)
> > >
> > >    [S] (unknown)(pg_locked_map:0):
> > >    (N/A)
> > >
> > >    [W] dept_page_wait_on_bit(pg_writeback_map:0):
> > >    [<ffff800080589c94>] folio_wait_bit+0x2c/0x38
> > >    stacktrace:
> > >          folio_wait_bit_common+0x824/0x8b8
> > >          folio_wait_bit+0x2c/0x38
> > >          folio_wait_writeback+0x5c/0xa4
> > >          migrate_pages_batch+0x5e4/0x1788
> > >          migrate_pages+0x15c4/0x1840
> > >          compact_zone+0x9c8/0x1d20
> > >          compact_node+0xd4/0x27c
> > >          sysctl_compaction_handler+0x104/0x194
> > >          proc_sys_call_handler+0x25c/0x3f8
> > >          proc_sys_write+0x20/0x2c
> > >          do_iter_readv_writev+0x350/0x448
> > >          vfs_writev+0x1ac/0x44c
> > >          do_pwritev+0x100/0x15c
> > >          __arm64_sys_pwritev2+0x6c/0xcc
> > >          invoke_syscall.constprop.0+0x64/0x18c
> > >          el0_svc_common.constprop.0+0x80/0x198
> > >
> > >    [E] dept_page_clear_bit(pg_locked_map:0):
> > >    [<ffff800080700914>] migrate_folio_undo_src+0x1b4/0x200
> > >    stacktrace:
> > >          migrate_folio_undo_src+0x1b4/0x200
> > >          migrate_pages_batch+0x1578/0x1788
> > >          migrate_pages+0x15c4/0x1840
> > >          compact_zone+0x9c8/0x1d20
> > >          compact_node+0xd4/0x27c
> > >          sysctl_compaction_handler+0x104/0x194
> > >          proc_sys_call_handler+0x25c/0x3f8
> > >          proc_sys_write+0x20/0x2c
> > >          do_iter_readv_writev+0x350/0x448
> > >          vfs_writev+0x1ac/0x44c
> > >          do_pwritev+0x100/0x15c
> > >          __arm64_sys_pwritev2+0x6c/0xcc
> > >          invoke_syscall.constprop.0+0x64/0x18c
> > >          el0_svc_common.constprop.0+0x80/0x198
> > >          do_el0_svc+0x28/0x3c
> > >          el0_svc+0x50/0x220
> > >    ---------------------------------------------------
> > >    context B's detail
> > >    ---------------------------------------------------
> > >    context B
> > >       [S] (unknown)(pg_writeback_map:0)
> > >       [W] dept_page_wait_on_bit(pg_locked_map:0)
> > >       [E] dept_page_clear_bit(pg_writeback_map:0)
> > >
> > >    [S] (unknown)(pg_writeback_map:0):
> > >    (N/A)
> > >
> > >    [W] dept_page_wait_on_bit(pg_locked_map:0):
> > >    [<ffff80008081e478>] bdev_getblk+0x58/0x120
> > >    stacktrace:
> > >          find_get_block_common+0x224/0xbc4
> > >          bdev_getblk+0x58/0x120
> > >          __ext4_get_inode_loc+0x194/0x98c
> > >          ext4_get_inode_loc+0x4c/0xcc
> > >          ext4_reserve_inode_write+0x74/0x158
> > >          __ext4_mark_inode_dirty+0xd4/0x4e0
> > >          __ext4_ext_dirty+0x118/0x164
> > >          ext4_ext_map_blocks+0x1578/0x2ca8
> > >          ext4_map_blocks+0x2a4/0xa60
> > >          ext4_convert_unwritten_extents+0x1b0/0x3c0
> > >          ext4_convert_unwritten_io_end_vec+0x90/0x1a0
> > >          ext4_end_io_end+0x58/0x194
> > >          ext4_end_io_rsv_work+0xc4/0x150
> > >          process_one_work+0x3b4/0xac0
> > >          worker_thread+0x2b0/0x53c
> > >          kthread+0x1a0/0x33c
> > >
> > >    [E] dept_page_clear_bit(pg_writeback_map:0):
> > >    [<ffff8000809dfc5c>] ext4_finish_bio+0x638/0x820
> > >    stacktrace:
> > >          folio_end_writeback+0x140/0x488
> > >          ext4_finish_bio+0x638/0x820
> > >          ext4_release_io_end+0x74/0x188
> > >          ext4_end_io_end+0xa0/0x194
> > >          ext4_end_io_rsv_work+0xc4/0x150
> > >          process_one_work+0x3b4/0xac0
> > >          worker_thread+0x2b0/0x53c
> > >          kthread+0x1a0/0x33c
> > >          ret_from_fork+0x10/0x20
> > >
> > > To simplify the scenario:
> > >
> > >    context X (wq worker)    context Y (process context)
> > >
> > >                             migrate_pages_batch()
> > >    ext4_end_io_end()                  ...
> > >      ...                      migrate_folio_unmap()
> > >      ext4_get_inode_loc()       ...
> > >        ...                      folio_lock() // hold the folio lock
> > >        bdev_getblk()                    ...
> > >          ...                            folio_wait_writeback() // wait forever
> > >          __find_get_block_slow()
> > >            ...                          ...
> > >            folio_lock() // wait forever
> > >            folio_unlock()     migrate_folio_undo_src()
> > >                                 ...
> > >      ...                        folio_unlock() // never reachable
> > >      ext4_finish_bio()
> > >     ...
> > >     folio_end_writeback() // never reachable
> > >
> > > context X is waiting for the folio lock to be released by context Y,
> > > while context Y is waiting for the writeback to end in context X.
> > > Ultimately, two contexts are waiting for the event that will never
> > > happen, say, deadlock.
> > >
> > > *Only one* of the following two conditions should be allowed, or we
> > > cannot avoid this kind of deadlock:
> > >
> > >    1. while holding a folio lock (and heading for folio_unlock()),
> > >       waiting for a writeback to end,
> > >    2. while heading for the writeback end, waiting for the folio lock to
> > >       be released,
> > >
> > > Since allowing 2 and avoiding 1 sound more sensible than the other,
> > > remove the first condition by making sure folio_unlock() before
> > > folio_wait_writeback() in migrate_folio_unmap().
> > >
> > > Fixes: 49d2e9cc45443 ("[PATCH] Swap Migration V5: migrate_pages() function")
> > > Reported-by: Yunseong Kim <ysk@kzalloc.com>
> > > Signed-off-by: Byungchul Park <byungchul@sk.com>
> > > Tested-by: Yunseong Kim <ysk@kzalloc.com>
> > > ---
> > >
> > > Hi,
> > >
> > > Thanks to Yunseong for reporting the issue, testing, and confirming if
> > > this patch can resolve the issue.  We used the latest version of DEPT
> > > to detect the issue:
> > >
> > >    https://lore.kernel.org/all/20251002081247.51255-1-byungchul@sk.com/
> > >
> > > I mentioned in the commit message above like:
> > >
> > >    *Only one* of the following two conditions should be allowed, or we
> > >    cannot avoid this kind of deadlock:
> > >
> > >       1. while holding a folio lock (and heading for folio_unlock()),
> > >          waiting for a writeback to end,
> > >       2. while heading for the writeback end, waiting for the folio lock
> > >          to be released,
> > >
> > > Honestly, I'm not convinced which one we should choose between two, I
> > > chose 'allowing 2 and avoiding 1' to resolve this issue though.
> > >
> > > However, please let me know if I was wrong and we should go for
> > > 'allowing 1 and avoiding 2'.  If so, I should try a different approach,
> > > for example, to fix by preventing folio_lock() or using folio_try_lock()
> > > while heading for writeback end in ext4_end_io_end() or something.
> > >
> > > To Yunseong,
> > >
> > > The link you shared for a system hang is:
> > >
> > >    https://gist.github.com/kzall0c/a6091bb2fd536865ca9aabfd017a1fc5
> > >
> > > I think an important stacktrace for this issue, this is, waiting for
> > > PG_writeback, was missed in the log.
> > >
> > >     Byungchul
> > >
> > > ---
> > >  mm/migrate.c | 57 +++++++++++++++++++++++++++++++++++++---------------
> > >  1 file changed, 41 insertions(+), 16 deletions(-)
> > >
> > > diff --git a/mm/migrate.c b/mm/migrate.c
> > > index 9e5ef39ce73a..60b0b054f27a 100644
> > > --- a/mm/migrate.c
> > > +++ b/mm/migrate.c
> > > @@ -1215,6 +1215,17 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
> > >
> > >     dst->private = NULL;
> > >
> > > +retry_wait_writeback:
> > > +   /*
> > > +    * Only in the case of a full synchronous migration is it
> > > +    * necessary to wait for PageWriteback.  In the async case, the
> > > +    * retry loop is too short and in the sync-light case, the
> > > +    * overhead of stalling is too much.  Plus, do not write-back if
> > > +    * it's in the middle of direct compaction
> > > +    */
> > > +   if (folio_test_writeback(src) && mode == MIGRATE_SYNC)
> > > +           folio_wait_writeback(src);
> > > +
> > >     if (!folio_trylock(src)) {
> > >             if (mode == MIGRATE_ASYNC)
> > >                     goto out;
> > > @@ -1245,27 +1256,41 @@ static int migrate_folio_unmap(new_folio_t get_new_folio,
> > >
> > >             folio_lock(src);
> > >     }
> > > -   locked = true;
> > > -   if (folio_test_mlocked(src))
> > > -           old_page_state |= PAGE_WAS_MLOCKED;
> > >
> > >     if (folio_test_writeback(src)) {
> > > -           /*
> > > -            * Only in the case of a full synchronous migration is it
> > > -            * necessary to wait for PageWriteback. In the async case,
> > > -            * the retry loop is too short and in the sync-light case,
> > > -            * the overhead of stalling is too much
> > > -            */
> > > -           switch (mode) {
> > > -           case MIGRATE_SYNC:
> > > -                   break;
> > > -           default:
> > > -                   rc = -EBUSY;
> > > -                   goto out;
> > > +           if (mode == MIGRATE_SYNC) {
> > > +                   /*
> > > +                    * folio_unlock() is required before trying
> > > +                    * folio_wait_writeback().  Or it leads a
> > > +                    * deadlock like:
> > > +                    *
> > > +                    *   context x          context y
> > > +                    *   in XXX_io_end()    in migrate_folio_unmap()
> > > +                    *
> > > +                    *   ...                ...
> > > +                    *   bdev_getblk();     folio_lock();
> > > +                    *
> > > +                    *     // wait forever  // wait forever
> > > +                    *     folio_lock();    folio_wait_writeback();
> > > +                    *
> > > +                    *     ...              ...
> > > +                    *     folio_unlock();
> > > +                    *   ...                // never reachable
> > > +                    *                      folio_unlock();
> > > +                    *   // never reachable
> > > +                    *   folio_end_writeback();
> > > +                    */
> > > +                   folio_unlock(src);
> > > +                   goto retry_wait_writeback;
> > >             }
> > > -           folio_wait_writeback(src);
> > > +           rc = -EBUSY;
> > > +           goto out;
> > >     }
> > >
> > > +   locked = true;
> > > +   if (folio_test_mlocked(src))
> > > +           old_page_state |= PAGE_WAS_MLOCKED;
> > > +
> > >     /*
> > >      * By try_to_migrate(), src->mapcount goes down to 0 here. In this case,
> > >      * we cannot notice that anon_vma is freed while we migrate a page.
> >
> > Hmm, I still have concerns about this change.
> > (1) seems to imply that the use of WB_SYNC_ALL by
> > mpage_writebacks() is also incorrect. In addition,
> > this change could introduce another theoretical livelock
> > when the folio enters writeback frequently.
> >
> > AFAIK, while a folio is under writeback,
> > its related buffers won’t be freed by migration, and
> > since try_free_buffer() checks the writeback state first,
> > taking folio_lock() shouldn’t be necessary while bdev_getblk().
> >
> > Therefore, it seems sufficient to check whether
> > the folio is under writeback in __find_get_block_slow(), e.g.:
> >
> > diff --git a/fs/buffer.c b/fs/buffer.c
> > index 6a8752f7bbed..804d33df6b0f 100644
> > --- a/fs/buffer.c
> > +++ b/fs/buffer.c
> > @@ -194,6 +194,9 @@ __find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
> >         if (IS_ERR(folio))
> >                 goto out;
> >
> > +       if (folio_test_writeback(folio))
> > +               return true;
> > +
> >         /*
> >          * Folio lock protects the buffers. Callers that cannot block
> >          * will fallback to serializing vs try_to_free_buffers() via
> >
> > Am I missing something?
> 
> Sorry, the code was wrong. the suggestion is:
> 
> diff --git a/fs/buffer.c b/fs/buffer.c
> index 6a8752f7bbed..804d33df6b0f 100644
>  --- a/fs/buffer.c
>  +++ b/fs/buffer.c
>  @@ -194,6 +194,9 @@ __find_get_block_slow(struct block_device *bdev, sector_t block, bool atomic)
>          if (IS_ERR(folio))
>                  goto out;
> 
>  +       if (folio_test_writeback(folio))
>  +               atomic = true;
>  +

Looks much better to me.

Or make sure to atomic(= true) is passed if folio_test_writeback(folio).

	Byungchul

>          /*
>           * Folio lock protects the buffers. Callers that cannot block
>           * will fallback to serializing vs try_to_free_buffers() via
> 
> --
> Sincerely,
> Yeoreum Yun

