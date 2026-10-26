Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F3ADE606A320
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 23:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=gW6pTedF
Received: by kanga.kvack.org (Postfix)
	id 0F10C6B05BB; Mon, 26 Oct 2026 19:19:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A2626B05BC; Mon, 26 Oct 2026 19:19:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2CE6B05BD; Mon, 26 Oct 2026 19:19:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C179E6B05BB
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 19:19:12 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4B0AA1408A6
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:19:12 +0000 (UTC)
X-FDA: 85366345344.23.4D88047
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf11.hostedemail.com (Postfix) with ESMTP id 70D4540004
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 23:19:10 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gW6pTedF;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793056750;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=DWZmK6+Hk4tl7852WKNp5JuN3J4xZu+CGZlmoPNLfsM=;
	b=dbC4mG4PEjc+rE1gFIpQCnd0+l/Gd10BYzEUU3sspgd03ZT0adMbYYrjemen3gGnvtTsym
	zU9QTIB91m7XQJg4OlgtS9WeozPUvFnMB/JlB4rdFzv//Vv14RwdcpXPLRZFoq2nbnsiTc
	Rv7LfXx2eUoIKlEJWbuJtYQkmpWW8v0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=gW6pTedF;
	spf=pass (imf11.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793056750;
	b=EVWVOjDrvSbZTng2hOANCcN9CI5AdMbwBNqmZwMUL78+bSpM3IFp+bCeXTu7XFZU3cRvG0
	UWwcmqk6K1wssYIOkJtTfb76BuZ0bbTk5YwtlzOC2Kl11l7fbEjbrroZ74AK989eUawc8H
	uEqe+vAzVMQstnAp1OPouUHzGysPEFo=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BCC3540338;
	Mon, 26 Oct 2026 23:19:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D00311F01825;
	Mon, 26 Oct 2026 23:18:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793056749;
	bh=DWZmK6+Hk4tl7852WKNp5JuN3J4xZu+CGZlmoPNLfsM=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=gW6pTedF1Y7FmSKqp6sywEFrR/GjpR7B5QIg6CrYe1nEA3VmOP0NtVG8z9JRGHzse
	 wyIuNXfKfNWFMZzzDKdZrGRpWxLMWQ3Mk5wl/UwvUtuL6tZR3haafCOYhfTAXUOBa+
	 ykPd8a/9Rt7kNXN1je3zkKwW2OAtPi0XosqEZAanIOKsd9uaafcic+W6y9YbiJCR2n
	 51e1aLAJPNZLMU9AiT8S3Hxy/ekTnAU3DkUr6fRsaQKewqAhqqkmPoLRuFAG1QsL7N
	 VoFnPtRTe1FmbBVii22XYC+xC11jd1g13RX61M35thSsmZ03giXHXe8kbmcMCRNyNi
	 ewBR1byALxIOw==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Tue, 27 Oct 2026 00:17:24 +0100
Subject: [PATCH 04/46] mm/memfd: make f_pos accesses atomic
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261027-fixes_core-v1-4-6f74bec9a5bb@kernel.org>
References: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
In-Reply-To: <20261027-fixes_core-v1-0-6f74bec9a5bb@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=2295; i=david@kernel.org;
 h=from:subject:message-id; bh=TCrZs4qHRVL9zqVdabp5tYlE4exCzu0PLt/vPmw9c2I=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLLu359s9Y75wVP1yesrJE4rS6+5pRS8vjb4u9PBBj+tY
 +vmxa/M7yhlYRDjYJAVU2QJCr5v8PLlutpqNz5mmDmsTCBDGLg4BWAigmsY/od/lHvkEXT9sr25
 V3GMO08dU8PRpU/aWTXFfNlORC7YocjI8FUyfLqt1oU7Jb3OuiW+56LKtxznl5I2Kfu34rwPy9E
 8JgA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 70D4540004
X-Stat-Signature: 4ikk3kd7dao1yhkmgk41pz87dihk469x
X-Rspam-User: 
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=unavailable autolearn_force=no
	version=4.0.1
X-HE-Tag: 1793056750-943782
X-HE-Meta: U2FsdGVkX19eXUl5vNn1Rr6JeShhs9XQhyjvWF2IsIYsXdnO0k2ie8UALsNChTOXxvwhKt63xohmkOoN/EUg1Qn9BRecW/O8MpnZirbf2TaV5hibjY+6TZI8yfxDcAo8FwJhp+GQuLhsaGgyriyJ4/fuSJsg04sodXv6P4lukA1RXfER4zKP3RzJXv5vHjWTYgFzLtu46498/A9KmIj80dbi4pCbTFfxptbKnhVLWGlEiXip1MZZJc2K4FsElHNP9IW+FQbCZnhimYp3NfyccOTDfBe35aKZan+R0bNwAjUErIFUir+kGfr18gwcrAd0KFGyb5yzJ0weu8YB1QZHVTO6/qvYvcRMlMrA8fFMLZ0JTyZNvSeAh6azpqGqLE+LceJe5p7pbMjezaAwsgywlrT+Txts5llAjkF7dKNUkU1qQVkR6TuY4JfVB6NEuL33fQ5JF3LjhwyzIQKPNuoF8GLwZJpswqK7180hCUUrzGjhtJNdPBH7WZ2uwesYcRrl3ZAMUKgTccxy/w29nj7/o8fjoP+2gZvQQak9x8VWUtqVUAlMkq91ROxjDpHU2bFLyO2ONk4APBO9u7BF8I2fUBUK5l3AO/NEAmcpHPpoLlCv0DwNXG//W9B3pxBYAZ+mHj8pSx1GIS0MYhF01I1hEZveJPQY7teioVu0UAHuqjGDBdyIGuIy1sJDZtLjrxQy335YlnJDEPt3QUHuPw2prLVoX0+VFhp4yoj/rRrf2iJrBUTRd4UeOOpEewNKWuP19CSXwGl/QX+4h179PaeWeHZgoiByIHf/zLDKynsG15WguWfX+HH/Nki9L5CKvXsdkvoMVoBWmJvAkftFplJ2zoPlJfYMnkaN7USpKThD1y9E+nOXPglvOMy4I298n5ZA+5jZa57QVp9C7T8K5JAOb5kYS2N5Tq8k60uhVaP8CZ3L5FJDcHFVIyg1cUxi22/zPL6tYNGIPVg8jC5+Ac1
 6V0v4MGq
 uHq8lZmVRdk7lthj9J8/xi5HOIjLkATvqu4aJ9aNlB+XlVy4jyUq3P3ZylvGFGZm062z93cYaCSwAZIYbb7n58fW9r2+NlhYvXtb3PkXkPcRvurkkITLg69YqAvOwrWp2iz8UIb3HOF1jpsy9LiVUMrmHWgFFsaUE78DP8xkidRKENZZerHgowB2vME+OZlVfZAR+gkyqBpPlxP2TaRiHWTF9NeHIc2r8Swx94xGdAa9ZDJ47YWz2IhDdmaQipuNWLHtZZZwfxzWQowZOz3+HJ4me1GGIlQLUic+fG6TUL8OS0YPWigqjmO0lSS3xDWyvJJHXQfIUzKhWIfYDaodEyDA/8FX/HkzYbB6IjF2ddxooenhi/zAY72QfG9ECb/36D1aRbjTSVe2WfU8iMkyM6SeopgyIaebXQG+f97FKozH+uP0=
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
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memfd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/memfd.c b/mm/memfd.c
index 7d2da23157003..6f5fbce74f21e 100644
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


