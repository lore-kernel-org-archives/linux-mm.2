Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0C7C8606A32E
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 09:41:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dXjd47I5
Received: by kanga.kvack.org (Postfix)
	id 378896B05B9; Sat, 31 Oct 2026 05:41:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 34FDB6B05BA; Sat, 31 Oct 2026 05:41:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 266556B05BB; Sat, 31 Oct 2026 05:41:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 082DF6B05B9
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 05:41:20 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 759C41608F1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:19 +0000 (UTC)
X-FDA: 85382428278.29.A26EFEA
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf27.hostedemail.com (Postfix) with ESMTP id AC3DA4000A
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 09:41:17 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXjd47I5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793439677;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UtgaK5EERO1GGEhTGodSTh9d2aQEbh7tZUgBnXPi378=;
	b=gl59heMvemGBPcrUCcM3rDQNACJu15Yu3/C6GapulkaffyBhLzShrY3Ij6YWQ0EjPNLN8n
	L/h6LupQSvdWNgasWrxaUlGHkHzEfpeNBE5EgkWeZSn7fPK2cd0cM1DhdxHcpmp4qPryAK
	9KZvBGnmEWFMauiByDM+sKmzkHyTOBI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793439677;
	b=BTapAVmODQMVUgAtNVpzSiWPRWbOsyvPrvykw0R7/N1zYhDA95Dvh8rISQXg/seItwAbk0
	lgiNh4XhJfaFdArvuGbubqnyd59/PqsBHXTpQzRaVBzEdRD1SlS/ePnz6a860ABtmxcOg9
	MLEDTh7FiGOXQzoAC4NIMeaLDchdp5A=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dXjd47I5;
	spf=pass (imf27.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EB913423CA;
	Sat, 31 Oct 2026 09:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 693D41F000C1;
	Sat, 31 Oct 2026 09:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793439676;
	bh=UtgaK5EERO1GGEhTGodSTh9d2aQEbh7tZUgBnXPi378=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dXjd47I5b873C5hOOHYSu8ebp4K8YqRwxt2AMgh9TU5wXBGFQ8VpBmBBwidpEUoeQ
	 fMjYRdJEfRkx7utnc60zGHK13AzfUUZwhDc9DZs5e7wWKETurtgsi5sMSzACyoX6aE
	 AdbvsYFlemwmljukT15fZvMAhETH+Codrn0QLiBEZa3zJXHUZsllTe4czIrikkHb1R
	 b3VE7Q5FZbpio92/nqmGC8DShC2+0SuXxJxHq9ddq3lH5HfnL2uCJ0tiAdyN8PcHNU
	 dgjoxM+XN+cSNi5hGtlML69Zj+EnJkAo+eyQIAJxO42w2Q18ggyai31M0QFzHnJiDj
	 xev2E75em2PFw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Sat, 31 Oct 2026 10:39:33 +0100
Subject: [PATCH v3 04/47] mm/memfd: make f_pos accesses atomic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261031-fixes_core-v3-4-d6437171ecc3@kernel.org>
References: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
In-Reply-To: <20261031-fixes_core-v3-0-d6437171ecc3@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Barry Song <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, 
 Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
 Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Kees Cook <kees@kernel.org>, 
 Peter Zijlstra <peterz@infradead.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Zi Yan <ziy@nvidia.com>, Lance Yang <lance.yang@linux.dev>, 
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>, 
 Alistair Popple <apopple@nvidia.com>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Matthew Brost <matthew.brost@intel.com>, John Hubbard <jhubbard@nvidia.com>, 
 Peter Xu <peterx@redhat.com>, Will Deacon <will@kernel.org>, 
 "Aneesh Kumar K.V" <aneesh.kumar@kernel.org>, 
 Nick Piggin <npiggin@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
 Minchan Kim <minchan@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Chris Li <chrisl@kernel.org>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, 
 Gregory Price <gourry@gourry.net>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 kexec@lists.infradead.org, linux-fsdevel@vger.kernel.org, 
 linux-arch@vger.kernel.org, linux-cxl@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>, stable@vger.kernel.org, 
 Muhammad Usama Anjum <usama.anjum@arm.com>, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2827; i=david@kernel.org;
 h=from:subject:message-id; bh=SDZRDly1DR5dPZ6jcWm3nd9SG3ocTLJmjE4kP1Q8ggo=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLKebk/V4mLn+Bp8xq9obaZAt8WnGB4VpRPBMkWyzUVOG
 il+7QwdpSwMYhwMsmKKLEHB9w1evlxXW+3Gxwwzh5UJZAgDF6cATGTdDYa/8r0/2YsmGsemzpsb
 m/fZ0FNN4mm7L6fZ88lv8i9/Yak8yMjwYVNNYKZSRXHESfXwqEm1ec0PZQRkwqvvn98jVOIXbc4
 KAA==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: AC3DA4000A
X-Stat-Signature: fdbx1q75f1ysuz1wtys46cj3hmswai3y
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793439677-634396
X-HE-Meta: U2FsdGVkX18sVQUR3Qh2g/rHZWZEb/AaDrC9qgxFgmd74Hj5K9JrEzOLg918FOXo739KkFpYZ9bcCIkklulCBS8DwySm81J/yQdybAYj9ti3xQEAWDqM28R/Epmd0OuKdDw6/viwk7QqOxpdJ/POay5fMwvxl1rhMKnEOVjV5a222989b+Prl0HrFs6hbXrfXIO+XUvBAnvKhOBL73YCSI8hdiNh7LmjyJxZKupROH0MvfrBvukX/nX+d1TRDSH00CdQNR4A5ojFQCWWgWwOI3tQNC7mipuCRHw+L9zcT2KwUZuGHx8ctp+XzUkOzhIXVg1NC6eyC1WdYQnY86zhZphJ6/Eeh9chHD6N3pKIf/+fYq+ulnhWfXC901LbHgIpX/GBqDddqXm2Y7Q0WU/fS7vE2DZHd65nQ+YfKxx+66vBt3VX/R1UDJbCcdHCTaIFb/Epyq8heeiW6KAs55tp/J2R6IFPkBCQI13PVxo48c1ieqlgr4HxJ5El7YP/Qs2tHlOsagEvcM1EshDiJ9AawfGIWvz0klyzwLUTaqZsjBJRN5FyxoEFtpefMVFyDKCKCmw5cE9LGZ0KW/BJoNkT8R2bbskHtXYqZsuwitMocso1QPDN3HVd9ACQ4HDIC+nUnov9OhubeHF6x+iKgtL7l7fM6X1c6/dKIAKP8OwKFVA5p95IgDjSSTq5GyOCI4YtHre0VwMuXxndzO+HCN0xMP1NQXVh+WQPldr92unVSn5K0eKSP0KWqks1DoUZSBCMiMMyyJACspuhzClGmDRIWzBVOhbS1WigVbgmwU9SZUZlFtEJKHKPJ7gxmMiL8vo/eAdG82Mt3m75ogPcz92CFjCLiZeVpNKeuXRXJ+Z7a2CrETV4a9xgxKEuQY6sSyZvxOFypUlFB/fwkLcpoyjQIvI2IRfAtGE+EHtNkBTV6x/igzeDPsv+XRc3L75x0Qpe2Eq+qmCL/9URfhHg9z3
 xnrdGG7E
 xe7DS6gsFA0qzrHGa8Xxwjv1NzXfbASB/MTeXJ6eK/DU7BGcbcF3H9/VAPPwF5H7zNI7bU++5hoX3lw8WywQ3mkaTxh99ibYtr8duZwIPwlAfeUYggZDdkcXPjAl9Tjwpks83TeLiuM14X4wSsat2tBK+WS/EyWy8fTeArRL8cHA2EP2mEaY6O3Xvh2SLNQif3z8I/QHWpiaz4BH4NyljxZiE+ZMy5Hnb92sQPviztEYwp3Mun09SvJwt4iUlyhO2JLqkhqiurIj1Wy/yct0IAkd8XSgIozm5+sfN+pPZKEhMJOThXBkIy0ATvKxq6f+jycebggi/DgCTWNxjhUfaGDivGJztGmczc28kFQXE2TgdWMavceIuqy5QpeivV22UPEsfBtYjIL5f3dnMcqqGo6ngEFGB/DBtFdQOMwde099NSGCEf2ZOHdwCcpz22s2lhrb0/3TnzOA+Quz9F8QdTJ3v3g7iH/YuA2x9op4a1ZIIoqF9ISjOq25wh1KqtLGvIoOF9omQdfQgtoAxK4B4Mmt/sVBpw7yybnkkp/1/sZv0AJR8j131N93rq+gcgVVZvqrNCk/+jG+SiZCjclhcXtXdbtOug9ob5Qio5nwYOUNxVhOMGTpwOz86DgK7Vg2ApJtBzt4zRsx5vPmTa+hm+aozaNUow6iE1dSw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Josef Bacik <josef@toxicpanda.com>

Commit 9c225f2655e3 ("vfs: atomic f_pos accesses as per POSIX") made
read(), write() and lseek() on a shared open file description of a regular
file serialize on ->f_pos_lock.  The flag that asks for it,
FMODE_ATOMIC_POS, is set in do_dentry_open().  A memfd is a regular file
too, but its struct file comes from alloc_file_pseudo() and never passes
through do_dentry_open(), so it does not get the flag:

  CPU0                                CPU1
  write(memfd, "a", 1)                write(memfd, "b", 1)
    pos = file->f_pos  (= 0)
                                        pos = file->f_pos  (= 0)
    vfs_write(..., &pos)
                                        vfs_write(..., &pos)
    file->f_pos = pos  (= 1)
                                        file->f_pos = pos  (= 1)

One of the two bytes is overwritten.  Two threads writing 100000 bytes
each, one at a time, to a memfd end up with a file that is far shorter than
200000 bytes, while the same program on a tmpfs file never loses a byte.

Set the flag when the memfd is created.  As for any other regular file the
lock is only taken if the file is reachable in more than one way, and
nothing a memfd does in read or write waits for another operation on the
same file.  This cannot be done for all alloc_file_pseudo() files: anon
inode files such as eventfd are S_IFREG as well, and a blocked read holding
->f_pos_lock would lock out the write that is supposed to wake it.

Fix generated by an LLM and sent by Josef Bacik in private.

Fixes: 9183df25fe7b ("shm: add memfd_create() syscall")
Cc: stable@vger.kernel.org
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
[ david: minor description tweaks ]
Reviewed-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Gregory Price (Meta) <gourry@gourry.net>
Tested-by: Gregory Price (Meta) <gourry@gourry.net>
Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Acked-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Pedro Falcato <pfalcato@suse.de>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Reviewed-by: Pasha Tatashin <pasha.tatashin@soleen.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 0f6fff004f5e4..0e3ff3eebfa82 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -482,6 +482,8 @@ struct file *memfd_alloc_file(const char *name, unsigned int flags)
 	}
 
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	file->f_mode |= FMODE_ATOMIC_POS;
 	file->f_flags |= O_LARGEFILE;
 
 	if (flags & MFD_NOEXEC_SEAL) {

-- 
2.43.0


