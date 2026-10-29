Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8686860A2607
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 20:34:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=SjSyyyt2
Received: by kanga.kvack.org (Postfix)
	id 747E66B05B8; Thu, 29 Oct 2026 16:34:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6F8536B05B9; Thu, 29 Oct 2026 16:34:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5E7506B05BA; Thu, 29 Oct 2026 16:34:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 33FF66B05B8
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:34:32 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B3D9A16042F
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:31 +0000 (UTC)
X-FDA: 85376816742.05.CC3EA37
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id D7F4540006
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 20:34:29 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjSyyyt2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793306070;
	b=oG864Zf6lQ2/p2VsTQO+kcqadDTgNs9o2GjcY+BqVxQScP/kRtvtiAVhxQCAeE7Y+aB96W
	5/85nQk28FuinGkOBIWfAkbbI6Ba5mX3OD44VI3EwJ/tz5iZywpZI+IGnXbTdavJnQtO/f
	SUag0DDS6Q/UEgCv2odWYp9bbucYXjY=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SjSyyyt2;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793306070;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oT+YqEtlQbND2mfRTH9TILHjv0P3Fo80cSp1PCr5wUg=;
	b=cKCrhbImljw5M7m89bn14vie4oF37qy7c7US9m/oFo1+WJvs6on5jDfm5pVDRgxccLiZPj
	G9rPyZpX8UZmVwqyEToDxiNF8Czl739j2BOBpb+3Zb8qZ8X8UYEuSZUIPwKjGaTrva9rZo
	OJs/QD0Pt4IqtjKDVWA3tX7yKwvx5tw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 22F8542B79;
	Thu, 29 Oct 2026 20:34:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 341E61F01816;
	Thu, 29 Oct 2026 20:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793306069;
	bh=oT+YqEtlQbND2mfRTH9TILHjv0P3Fo80cSp1PCr5wUg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=SjSyyyt23NhzYdLUJQzjyOqLwA8+XnmlLC5njjzlYt6G5ocTnXx44lnZTPI/B7exG
	 Tpqip0IMnoVAS6p/71GtzFblSHA6svKrTkHsAq9WcnMlGJUdiQBwr4XlMyXh12ZqvM
	 PMICUX0jeBtzxG34zNZAKpfGD12ftE+vqPHD+fywpcJnjaLgQt+vpN4uGZcLThOK8u
	 D1jTUIEWcxMJjlyTBTqH9cb9voaIk3GpZ5mh8GmYLQdLgkQJ6rmEWMxh6gdHx15QIA
	 Ie2Q4Jtu03dezRZ2IiU2gLRK/y+6l0H5VxNnAzVZG2SouSugNYWL5yMEENxKvREYzJ
	 LvERDYWVFwK4Q==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Thu, 29 Oct 2026 21:32:59 +0100
Subject: [PATCH v2 04/47] mm/memfd: make f_pos accesses atomic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261029-fixes_core-v2-4-a64ce7f83abb@kernel.org>
References: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
In-Reply-To: <20261029-fixes_core-v2-0-a64ce7f83abb@kernel.org>
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
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2770; i=david@kernel.org;
 h=from:subject:message-id; bh=nYtl8pReTocJvpHuEkN/fjyaxBPiNA2Y0oMG8lh8AYY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLIer22xkX+5Wkk7rWjRXY2Wt0+XTo3qWFSprqoufvySW
 8BivVlHOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiI701GhvMcKwXqeEUK1hzV
 juE376/hNWV5cNDRsyVF2ofV0GlGGCPDGvUzvfqV+ta/o6LsdG0TzrptVd5fecV8r1nh2W27GjU
 ZAQ==
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Stat-Signature: oiuprqzq5a1f5qz35z6sshsi3zzmhwb5
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: D7F4540006
X-Rspam-User: 
X-HE-Tag: 1793306069-470884
X-HE-Meta: U2FsdGVkX1+/RFhMBjkh/0WCsjPPy3XkNlPv+FRnw2ja3m8C4BK0YaFD6VFvr6CwBHkPdzFormiNbeJMFGuC5HBaDMNyGOFdIypGC5/OQ+vg0soX55qoFQCd/uFgFMsWuTfSkR3qiNTzT2ek9kIA4i/nfL26QOcrYEQxk6dR5dQiGHocY3xABDTbq6ltHkRwnZ+1H0beFE9q7WeEwlGqSy+1jzXvcjfzJ1+kUNadI5+S77oXhp5pl3mRYldeIg8SGJ0InGYuR2RZHgMMSl7PtGjgqHYhOtY8ycFCrxANHUehPtn59RbDR06MOhC9Xv1gcbysI+IysjvJsik3ybwM1lrhakpKiU5kUTIGtVyZD5Ygr/QKRSQL4/4ED9Z0NP50ktxOVL5giV621jAma3SKMXGpejuJbDUWAwEyvjV0Xd4phdYIwICR8sCaaHVY16O9+vLFHPk3RHtyI6WXeeDi6RDLaJdN4wOEVMVISk+49TQlyKuGVW9wNL9SUIlpddGTdEI91HmxlXYtrND7Mg3mvxMFHCqLTYQApvCk+eicd4ZwYdhjBQUOrg/lGQIdVUTnS9rsgTQopFlG3r/k3mwwas6rBQzygZxHMAWymIgK8Fw34jZWEb3G6YWBo7RF/xCnc7furLcxQYsyvt00B9B8Tre47qgEZnpSHGI9cmdBB0emiSOHDPTWzNYjB9i7OIqYtAB5mwbNIEVK5mXPqT6VMI5RVR91JA6TuJ+EbuLQeC+QNx/8g3G40ASQOAgwyAZMs3qs17OEzI5UK4XgkpTJ0cpWdQ1Ke88fyfkGeaR/oGhP+7E5iO7vUcqt/aKkw+CbK7tnA4My2Uyskx2fNt/+BZNaSBp50ojDK786ZJ6ydJpn8R4QqsvmDYj8hAmiYD56Xv+LMzmJ95tRVgvbDT0dAZQ1pCxZVIW1kX3Usp1ZcvUw0PyFzyQ/ql3acSo7mSroCQvf9AySAVyLvtjy3PK
 +UlaXP2Q
 KAtJ0dmyGYJvUoMZvJjF2CMnygHL8jyUa/yM9WLvpm5oCyhvWpf+hC8bTGO9/ysJAxlUsktjmgvRMIVA8iqa+w2DArmI5zXJt8uo/WkncvvLMe10J5m1ac5GQXBUMu7lofHWtLduA2S+AM/Q10AAZiXFJ6ts59h5b2yjbYsO394x6/oHCcmul2TBJ4ERTJeypsQfX7rI/qREnlpk7F/28iR9KUk6dLXGPU+L2NtoAjfb8hHw63BfQIUXzqLsor93zt+i9JG+4v5TNvQZTXNXvJKaJRmlAmnZBmqUS9ry2XIz1ubwOF+NZO9Fg2YNQst71ETaETZSaTlIFQ4GtZw9iU+WGLkxANhIJbqmgZuPK0qPBcYM9DPO18He3rjOA94ZcA1oyEDhMis+23jPKTT3HaSjOW0ApsqJFy0YplsAWC2peACaJ8BvemOfLMx61dxwSL6AiHJO1Xl3NaO79h6wsn4osbqL6w4FVv2DQSKaQfvq4tO54fLYrOtwqh56M1dXkeWy8G5VjSotFCYzJvqLm58MZQWKSAhYxRK/1RohmV1JkHbexrTjptBrqLSXuXdcAeFlW1yMeLTS0nkxoF7UvHEXpRV7RoG+eFZu+
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 507c00ce0fda..131fb772ad65 100644
--- a/mm/memfd.c
+++ b/mm/memfd.c
@@ -484,6 +484,8 @@ struct file *memfd_alloc_file(const char *name, unsigned int flags)
 	}
 
 	file->f_mode |= FMODE_LSEEK | FMODE_PREAD | FMODE_PWRITE;
+	/* a regular file like any other: POSIX.1-2008/SUSv4 Section XSI 2.9.7 */
+	file->f_mode |= FMODE_ATOMIC_POS;
 	file->f_flags |= O_LARGEFILE;
 
 	if (flags & MFD_NOEXEC_SEAL) {

-- 
2.43.0


