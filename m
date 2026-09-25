Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6FA4DC9830D
	for <linux-mm@archiver.kernel.org>; Fri, 25 Sep 2026 05:30:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2ABC96B0088; Fri, 25 Sep 2026 01:30:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 25C096B008A; Fri, 25 Sep 2026 01:30:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 171F46B008C; Fri, 25 Sep 2026 01:30:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E484E6B0088
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 01:30:43 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 70AD3140561
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:30:43 +0000 (UTC)
X-FDA: 85251159966.01.EF53D7B
Received: from mail-pj2-f12.google.com (mail-pj2-f12.google.com [74.125.227.140])
	by imf11.hostedemail.com (Postfix) with ESMTP id 8A1C340007
	for <linux-mm@kvack.org>; Fri, 25 Sep 2026 05:30:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b="Iu/aJC8C";
	spf=pass (imf11.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790314241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UlKVWQYb3wLiMbBgvNkQrBNBTWmCb5vBsI31GY2cd78=;
	b=CDvH6v6akuV4tsdC26uY8nEpx550jolI9GYRymmjn7AR0k1pIdhCqEbFcrv1PauoUf8KFR
	5y5vrIUzjrTv4vE6YTMFqdq/iShhyPJGo/2xEwVN6INERl6aAmWtXsKphaaqOZWMro/8M/
	j1vyL0b8AchJY5F9Pd+AkkjvBW6QWBc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=modal.com header.s=google header.b="Iu/aJC8C";
	spf=pass (imf11.hostedemail.com: domain of ayushr@modal.com designates 74.125.227.140 as permitted sender) smtp.mailfrom=ayushr@modal.com;
	dmarc=pass (policy=reject) header.from=modal.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790314241;
	b=MzDn7yS3RSYfR2RhaFId5w7e5ABslGLdZP4OmUDPTRWxNXpIwtYercd5rrkfW5gn5MXnKu
	KRN2GiZBcIHUjkPq2g+jnhwbmvR475f7qiRTw7fRQxhcg7B4wt7PkHc+LPcQ1eWW8ESo8w
	pwAxDBEjgHtjpZ/taTxuNkOlRcpaNeE=
Received: by mail-pj2-f12.google.com with SMTP id 98e67ed59e1d1-398b3b189e0so327161a91.2
        for <linux-mm@kvack.org>; Thu, 24 Sep 2026 22:30:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=modal.com; s=google; t=1790314240; x=1790919040; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UlKVWQYb3wLiMbBgvNkQrBNBTWmCb5vBsI31GY2cd78=;
        b=Iu/aJC8CIR8gmbiBj1o6U9n8lBScF9xq7Hy95bDlL7nDgrqBPb0BD8PdW0iWJMvTLp
         TPB9FilVSt/DcoIA1uXNtkVzprwsPtKfMz04hfay+s/yMPbBqaVzPINxFM+RW4S87HTe
         rhvk+ngb97sLnBCC7jguf98eihXtw9aB2+ZjWhHPVopQL/ANCl5+QYLN7yFOZBxpWEfv
         BweOwfFiX9vroEwQvEgaPOF988TrmZQSoM74niDjCmPjV7wHZ3iSQkZggQ9QaP5RbvK4
         yX2LmpPuo4dQKGI/AmF+55gmph9XfuSFsozq162xma/77EV6A4UZAHU0fGdiaCn4ch5x
         Xjog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790314240; x=1790919040;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=UlKVWQYb3wLiMbBgvNkQrBNBTWmCb5vBsI31GY2cd78=;
        b=Mc9GUwHrMRsnJepc7GyLXiNy2agsNQXfhfWif8JfwLZfHmVH5vXmawG8Gh60KDEJ1o
         FK08HarihY601b1dttP65GPQv2T1S0SHwFJbFhhC4EXEZ47p9zQ4T/e06lnnerJw9+B1
         1eTwrRGvkXkfrezDtXP4+m7LcGY9x7HLjsnUO/6jlv4DYTSU2U5DHQKVILoLq4jqjnAP
         kXV+9lYTqwWWhil877B3pwa/Uv4VptZwzot0XwNJeoNp8rH9oOmKdHcrGcBhiaC/Abg/
         EOQfifg/cGweoV8gNsbBCp2GobOfxgdveg2Bqd2aAzBG0sVnTqzKYN6XYwt0NfQ5/aCo
         C+0A==
X-Forwarded-Encrypted: i=1; AKwUvBwOP/NrFZekIxKLJ/d1aDP7apE1u1kjSBI4BlFPaKfKEEfOvLfEvgm/qNROu5kMpjk+LdYBblW/Mg==@kvack.org
X-Gm-Message-State: AFuF++mmuJlbmFZs9I+BkYdYPYt+/dQcgI6Q2kQ5rqZDqZ515Xctu/K0
	Luj38MCq1t23cbBQFMjsxfQ/MWrLHgn9fxJA7bWEqH5nQbQak4Hrc8mHxonMXhqYXcU=
X-Gm-Gg: AYBFou1s9k1++hFczSqe4toQ4NJvh85vLNJV/z9tDLHwYStpt2zyn8iq/eJHWdYqizt
	HfWD1o2FUuZf8hQvlaSIabRfBeyqR9Oeg8AnXlPwV5e+qFVDWc1I3eZmxBBWtf0mX9soCmO/OD+
	bpxO3+rcE6yrPGKBMg0DhnNQ4LXAKObzEIb1JifF8JTdTxrWtT9xNC3D1IMs0zDooBhH0BE7ewn
	Os7U2oSrxs/8HbVjjQ180ZBr+ViFBqZlxgzwyVj6QQuduWrbvdV3cMVs8T5TbCapflaPLdSoryo
	qHgO2fbLguaAVdJCdUyfhjbDgegVjogepMK91/CTFpOr3so9YMA6KqE+kEAgrXu0gaVoNExF3Ft
	h+DMLN2oyoY6GDBPki86ieubeCkpspUmJNwHk78ezTi2PKTf6LOLfETXc9eyeIvAMgBBTr/qH9L
	/1kGe3svCXV0n7Br8L/olWPtp99tN2C94ESrRqbRXRzRzE5bwSaTbGc7QccaIj4r4RAJx5vWWIh
	AUIdrjkpa8TAGG4qAQ3qs5OHjOatyXKz7LMrSx6PceHiRl8FjQv6RowJn3v9IkP2BJE5+sgRUd8
	BHTGxXa+HETSeKW1KVIdC0Cu4ZTW+wdEcGrOVmcynojt05uX
X-Received: by 2002:a17:90b:1652:b0:3a0:9640:8043 with SMTP id 98e67ed59e1d1-3a098ccdd41mr4157923a91.15.1790314240096;
        Thu, 24 Sep 2026 22:30:40 -0700 (PDT)
Received: from devbox-ayushr-01ed.tail5292b.ts.net (ec2-44-242-192-44.us-west-2.compute.amazonaws.com. [44.242.192.44])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a0b998dbf2sm2199443a91.12.2026.09.24.22.30.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Sep 2026 22:30:39 -0700 (PDT)
From: Ayush Ranjan <ayushr@modal.com>
To: Pedro Falcato <pfalcato@suse.de>
Cc: Ayush Ranjan <ayushr@modal.com>,
	Hugh Dickins <hughd@google.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kara <jack@suse.cz>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	David Hildenbrand <david@kernel.org>,
	Gregory Price <gourry@gourry.net>,
	linux-mm@kvack.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [BUG] shmem: FALLOC_FL_PUNCH_HOLE vs fault-around race corrupts page cache / rss counters
Date: Fri, 25 Sep 2026 05:30:19 +0000
Message-ID: <20260925053027.1998394-1-ayushr@modal.com>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
References: <20260924061708.1645968-1-ayushr@modal.com> <arTdLsBENhrpOyk-@pedro-suse.tail5790ac.ts.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 8A1C340007
X-Rspam-User: 
X-Stat-Signature: xddtcay8jfby7wp1ewzsugtynnjwaxx3
X-HE-Tag: 1790314241-923464
X-HE-Meta: U2FsdGVkX1+HJjRCjp4H7CAhYCI0grnQF8FrAovXvlO3XYZpGwtcHH09/YFb+8X/+hgiSvNyeG6pA3BWHbSznWadYG9iJCiXFib/8h/z1OA36Ujhlffk28giqRs1AaadMXUkoJHmB6JHcpTcuLwp8kuwTyTW4G9QXAOpy32u2Xuv6y494DdRenmDP3o+bGx6xYvl5/kxPz3eYN8q/uuMawwB/OIk5jmjl9huaDvJXKUDi7DVl1i9F0agodNS/3jKe7JelyZn0r17v7g0JjRa/4TIjG292kHDA5ddQzxElB73ZByg734tepRseO+fuYBU+M8a1FoBx7czkTI9aNGTEavJL9R0mdlk0nzlPtapMN8TPYwQWdTMm42uTKEVJoyfeFNm8YEkTMQnnYjk5USQQVCk7joXe7t+uSLj1UcpSpmy/0zyXzRLVDbVSq8GomcsitAXUm/6z+dQwkjuxpMDOJu7Pw3c2ZE6wjzdVPs2HIum3yuNm6nhBxWZAtnNHSFbtU2VDHr0bdlXXETvpqJFI5prpuODayQeVCS6NlEECi5Jsc6AWGLHolGGnAoqPSXtXP6zn+M9nTolANCEdjf7U408ROedjTKyHdVJEWmntVObZPHotISYfcPWhfbyJX2k35KjDp9vNU9uPKSc3RDXnwnn3Phb7hi6jSrA662YJaJ3i1xuB+gbQhhk4ySFA1sPRHkk3Zlam10+rFtfCiIP0ptoa/FLVCKRkbzofn2o8wSphZeoearu3TNZC6Zw4eW9tzjlTJNhNy/SOzSAonBbbKZfRtZRoTPiM/QB+kL+zM7azXbrZ5LU3hinFvC6BNpb84cSMkpemQB+QKYmjepmrSloT1rrKveUtqd/WgYd143z7AE2sijv4/TdJ8blQ0+9q8DPqiOl+IR34FkAsOv6dodRsu1yhAQxJUS2pwbUPkkcViDU9JYGHNSBYelz7FJLiDkKwXDxa0LEcJLI2gy
 ql3567qY
 1U4Co+iXCWI5AYrSswEjiSVswhwE6cqcoT569fyb6bVxT5er2zdQvqByF9qvCgMEGKxTmqjgqVGIwJRmWuOkq5Y6HwrJSDXrdoagTdIj5GjJ1nswaB7P+e0pytVh0znEfjR4lrGkkdyEM8CnvFZ5VeeFF8ukTYFoM0mJuCzWO8ks5p6A/PDXc2vMLqJEyP6CbL+W631kH3T7lXLJcywe60CcEBup6z0nRWor8mORkbUVoOWUKojgKzW5DNor10v+e9kXS97Vh0oFQYmKf17dBmho7f1pMaFHUbxlkbiaAusHBMLpVbb2gj6Nu7QY8uGcDKQNgw3Il5rB+MQuPz/CZozm7FhWHOMk23BN7aOFbdm2qeCbzeGczwTk8qbjCUvGDqg6pUgVwrZyOemPo5OGJhIduiw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 24, 2026 at 08:34 +0000, Pedro Falcato wrote:
> (please use the email I actually use for work, thanks; not sure how
> you got to that one)

Sorry about that. I put the Cc list together with the help of an AI
assistant, and it filled in the gmail address from your older list
postings; I should have checked it against MAINTAINERS. Using this
one from now on.

> >   - filemap_map_pages() samples mm_counter_file(folio) once per batch
> >     and applies it with add_mm_counter() after mapping; if the
> >     folio's swapbacked state changes while it is concurrently torn
>
> But that cannot happen? We hold the folio lock in filemap_map_pages().
> The folio (naturally) cannot be torn down while we have the folio lock.
[...]
> No, I don't think this paragraph is true. Page cache truncation (via
> truncate, or fallocate PUNCH_HOLE) takes the folio lock for each folio
> that is about to be truncated out. Mapping folios takes the folio lock
> as well, except in the fork() case where a myriad of weird interval tree
> + PTE lock interactions make it safe (AIUI).

You're right... Thanks for the correction.

One empirical hint that may help: the reproducer strictly requires
khugepaged to be re-collapsing the punched ranges (it never trips with
the default 10s scan interval), so the large-folio / partial-truncation
angle Jan raised elsewhere in the thread may be the more promising one.

> Awesome that you have a reproducer! Have you reproduced this on a
> mainline kernel? Enterprise kernels are not supported upstream.

Partially. The production workload trips both BUGs on:

  - 6.12.96 (Ubuntu 24.04, mainline stable build)
  - 6.18.46 + two writeback backports (31c1d19ead2c "writeback: use a
    per-sb counter to drain inode wb switches at umount" and
    f6988c90671e "writeback: bound cleanup_offline_cgwb() rescans by
    rotating scanned inodes") (Ubuntu 24.04)
  - 6.12.0-204.92.4.4.3.el9uek (Oracle Linux 9, UEK8)

The standalone reproducer, however, has so far only triggered the
rss-counter one, and only on the UEK8 kernel. Not on our 6.18.46
hosts, and it has never triggered the "Bad page cache" one for me.
So it clearly does not capture everything the production workload
does. The production workload which triggers this is gVisor, which
heavily utilizes memfd to implement application memory for the
sandboxed application and punches holes into it to decommit/release
memory on the host.

For completeness, here is a production capture of the "still mapped
when deleted" bug on the 6.18.46 kernel (the gVisor workload
mentioned in the report; the taint is from our out-of-tree module which
was not being used here):

  BUG: Bad page cache in process exe  pfn:1be0e380
  page: refcount:17 mapcount:1 mapping:00000000ceb7a77f index:0x153980 pfn:0x1be0e380
  head: order:3 mapcount:8 entire_mapcount:0 nr_pages_mapped:8 pincount:0
  memcg:ff25c58e86be5480
  aops:shmem_aops ino:3180f dentry name(?):"memfd:runsc-memory"
  flags: 0x57ffffd802006d(locked|referenced|uptodate|lru|head|swapbacked|node=1|zone=2|lastcpupid=0x1fffff)
  raw: 0057ffffd802006d ff8c38e33838e208 ff8c38e33838a008 ff25c5f1950be208
  raw: 0000000000153980 0000000000000000 0000001100000000 ff25c58e86be5480
  head: 0057ffffd802006d ff8c38e33838e208 ff8c38e33838a008 ff25c5f1950be208
  head: 0000000000153980 0000000000000000 0000001100000000 ff25c58e86be5480
  head: 0057ffffc0000203 ff8c38e33838e001 0000000800000007 00000000ffffffff
  head: ffffffff00000007 00000000000000d4 0000000000000000 0000000000000008
  page dumped because: still mapped when deleted
  CPU: 170 UID: 0 PID: 947113 Comm: exe Kdump: loaded Tainted: G           OE       6.18.46-modal2 #2 PREEMPT(voluntary)
  Tainted: [O]=OOT_MODULE, [E]=UNSIGNED_MODULE
  Hardware name: Oracle Corporation ORACLE SERVER E6-2c/Asm,MB+Tray,E6-2c, BIOS 89070200 04/03/2026
  Call Trace:
   <TASK>
   dump_stack_lvl+0x76/0xa0
   dump_stack+0x10/0x20
   filemap_unaccount_folio+0xf7/0x240
   __filemap_remove_folio+0x3c/0x1e0
   ? vma_interval_tree_iter_next+0xaa/0xc0
   ? unmap_mapping_folio+0x70/0x130
   ? __folio_cancel_dirty+0x29/0x110
   filemap_remove_folio+0x47/0xf0
   truncate_inode_partial_folio+0x15e/0x2d0
   shmem_undo_range+0x6bb/0x930
   shmem_fallocate+0x1ab/0x530
   vfs_fallocate+0x17b/0x3b0
   __x64_sys_fallocate+0x4a/0xc0
   x64_sys_call+0x1fe1/0x26a0
   do_syscall_64+0x82/0xf80
   ? seccomp_notify_ioctl+0x3dd/0x7a0
   ? __seccomp_filter+0x10b/0x610
   ? __x64_sys_ioctl+0xbf/0x100
   entry_SYSCALL_64_after_hwframe+0x76/0x7e
  RIP: 0033:0x40d00e
   </TASK>

followed later, when that process exited, by:

  BUG: Bad rss-counter state mm:00000000283589c7 type:MM_SHMEMPAGES val:40 Comm:exe Pid:939691

Thanks for taking a look.

Thanks,
Ayush

