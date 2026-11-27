Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7EDD7606A334
	for <linux-mm@archiver.kernel.org>; Fri, 27 Nov 2026 19:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HTgAYAyW
Received: by kanga.kvack.org (Postfix)
	id A9E876B05B4; Fri, 27 Nov 2026 14:46:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A75F56B05B5; Fri, 27 Nov 2026 14:46:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B2FE6B05B6; Fri, 27 Nov 2026 14:46:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 762B76B05B4
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 14:46:07 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4D1DD404AA
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:03 +0000 (UTC)
X-FDA: 85481929806.06.5635DA1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id 735A44000C
	for <linux-mm@kvack.org>; Fri, 27 Nov 2026 19:46:01 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HTgAYAyW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795808761;
	b=aShF4Of5lyioMTrqkX265xqpXLu7tlHQlmUYSqvU+BtYpY+tPORffcEbHB6TwFve342Za3
	9AtBWV/XKv4756EEhqaoLnvxpOq1Ubsz5fkz0Q/0ufg33EjEhfzy83eo0rER90VNrUbSKY
	aNlXs+6Fce902eKJCkhArvS7uZCjD2Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795808761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kcerf0Wz9rGhyM09///5+pAbtctI2kJUca9cu+C4P4w=;
	b=xS2E+B59zZSK2AHqp6pwAGRGoMnv1S5UKqj2FzQ9i+f8azko2ajHA6oJ4uckgmW1zmYBFx
	C94xn3gkiC8Kc/5XhoV/5hAkoKMB6kBu1H/r6CA0VK1AyV5nUCT8oxmt2W24vdpnZyb14M
	IJLh7Dhy/yvTql0LuiT6H1d0d3/MmmE=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=HTgAYAyW;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 07A9661F53;
	Fri, 27 Nov 2026 19:46:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBE111F00929;
	Fri, 27 Nov 2026 19:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795808760;
	bh=kcerf0Wz9rGhyM09///5+pAbtctI2kJUca9cu+C4P4w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=HTgAYAyW3IajlcDL8qw1eFE1wl5vm/PzjZDHxWlJjufp1QLj16mSEPhQK9WYrz9MF
	 rT0VJiqS0FOdTVTaVa88eay+IjxG08jhYC6tqhhDfB7DvaPrbXdavJRFsuvMvxNtFg
	 Yn1O2tBwXIMVeQeliX/2ygQAQIr50/F5La5TLMd9PPDN2GjEPsYKs/v7Pu/9hLnxhP
	 ntTZOU+KwsNEyO5EuOmYORVTXaDRsOI2LEqGH2JKd21PmoW/wD9zUo3/1PSVTepzEg
	 iNae8zT+l4JvwzYkjMfKp2GaalCHALsAcDUVuvD0vgTX/xZDMAyJ2Z1LbNCh4I+46A
	 cheTThDHMrtlg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Fri, 27 Nov 2026 19:45:40 +0000
Subject: [PATCH 1/4] coda: never point a file's f_mapping at a container's
 mapping
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261127-mlock-madvise-mprotect-ai-fixes-v1-1-e46b2b1eb435@kernel.org>
References: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
In-Reply-To: <20261127-mlock-madvise-mprotect-ai-fixes-v1-0-e46b2b1eb435@kernel.org>
To: Jan Harkes <jaharkes@cs.cmu.edu>, coda@cs.cmu.edu, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Rheinsberg <david@readahead.eu>, Hugh Dickins <hughd@google.com>, 
 Vlastimil Babka <vbabka@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
 David Hildenbrand <david@kernel.org>, Jann Horn <jannh@google.com>, 
 Alex Shi <alexs@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, 
 Pedro Falcato <pfalcato@suse.de>, David Rientjes <rientjes@google.com>, 
 Rik van Riel <riel@redhat.com>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 =?utf-8?q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>, 
 Arnd Bergmann <arnd@arndb.de>, Stephen Rothwell <sfr@canb.auug.org.au>, 
 Muhammad Usama Anjum <usama.anjum@arm.com>
Cc: codalist@coda.cs.cmu.edu, linux-mm@kvack.org, 
 Andrei Vagin <avagin@gmail.com>, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=4327; i=ljs@kernel.org;
 h=from:subject:message-id; bh=QVu7fb0kBPNVCyTuJn+VTrXPJuL+aUkLVFY1Ydjy6Xw=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI577707/3+rru83v/RwiMc3hITPB3nRWid2nnsXnH9w
 0W1Lc+mdJSyMIhxMciKKbI8/yK+P0gkbF7nBX83mDmsTCBDGLg4BWAiAr2MDO8r79aIsLUfPfH/
 eR1X/12eXR8kzL3Dayum+m5Xv/k6w4/hf5765ufqr64apv4sEH5wwutwRqu24qJWGZs3TAdqv+/
 8zQUA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 735A44000C
X-Stat-Signature: sd6fznrhr3zbgxw7jsrnf7siffiup36u
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User:
X-HE-Tag: 1795808761-665326
X-HE-Meta: U2FsdGVkX1/R/9yOE7DWRsY8mkA+yTaS7D92YmXg8Em5ThDwpP4Wzek7b5EJ+qQAXqzO40IL00nM5+SYxAOsrw4qH0U47E/X18SUl0MtMctgW2UtS5YKEhHqJPNjPK9DDIdMiHUmlIGGkWY+iNz/bpJCeKI4KwoTZktXzBUal4THkm5yBOKDV7z/XrcIbCW/ARWpxkr6dAwQ04UGGLzZiXjtyOIkp7jNAUErdypen+BCb5jQcxGUWIj8DYofbXuGVD16hg3Vq2VONcKNT1s14ovEC+EXlx7hizXpddprDpCyCqMlwazj9p6ZAhp8CHR715xZxSXVL8kYkwE2sGGahxDjvSa8kB7SSyQR3JL5dxXSuLy5hPJlpSw1oiXH06XH2C3RzX92gF6pPCf0m4cbXRTePnKIsrhEMn5yhdU1Bqo4MMFpdegBJ+BOET5WlC+nWrhXdmctEfAewXHT5rKa/MeNMfGYnY8U2iO9CSDzzHT9odY9sAYSFlPPrByJEc6CF0jEvp5CaudQhEjQd7rFlnUwEB3r/lwJbfbXcB6khn9pfUZOZqJ+VvRAhQAwxvSlyERfp7LvmORvApACW+n/Yo0W0yT2AMy85WuGwDgqeov6G9Drv/Pyo0/PnHXcRlxqzbLuT/0YSZevgiHTk0DLZEt/zMiRkHV3bkmzJ8xZBKjAey/uWCd8zdggwurDE2znwqzuj0ZtF8j9jV3Orjf663mSyaA8M9VPdNEOSQi0qFUqX3M4QEZOTRuJSdVgCwDWDW5kPmc2W5YgZbSkAN95xiYSuwJ/9mnP2DGDhYv0ExAKT0FLZfUVCwteYhmchPx6NlSGL9QjCJ+qeJ30zda48pRphz2ZeGWQplh68gxd4Lz1DPDdMFTWR/c4X/Aq+CkAHoFNkWi7EaXerVcXmHMRhaUTlrdXzr/XmTedqLARjw3r6MMyvRC5+kK4BaV0wmOux9K7RQh6621Hmi1OkZ1
 eCTaIYN/
 sBL1NzCZlZObk/L2xJg59EOJTLEz6uL379Deffw0WzPwpxlaJtMBtqZ1qZJ3//dkbbBmkt1r7W2pSeZWKo0lHrNU2s88lrZfCKQBJZUVEei7AUHWnwql6HJOzS5dQ80c4IGD2weOnDkOdABsKLgax7VCbCR0cg/MFHnE9tICFMXfdx2RsCqhiSn7/Nfi0cqDJ6y/IfX2rWn0onaUDyeN1nAOxi4gRLZu3ISZSctVDGhFw3Ib52HcrIX+k3KCJiyUEr6XkfMRaa8bbNjTtFCyAaItYEY6U4kG12b69fJEN5tNIB6ZT6WigaQ7i5zBsnd8VWuLE81zI84PUX5YbmGesCFkxvr+YLZQRNq14/fPnwHTnnshoNq4uThn70GdTq/BTSjM2K+jNnCCwQG/ZCHNpsu91UjsRWdJ5qheJbS19aOSY6VrmYtjHlBQNYoeJ5kwEocK9AKLPGJz8s0RZUnRTL8TcMsWDUyWUU2BDoorAsnhNX/Pai+TZ+gfPNSCgOe13DAM5Lor0SrK6U4w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Coda file systems stack differently from other stacked file systems.

On mmap(), coda_file_mmap() switches both the Coda inode's i_mapping and
the Coda file's f_mapping for the mapping of the container file. This
causes two problems.

Firstly, the container file may not remain pinned, at which point this may
result in a dangling reference in coda_file->f_mapping, and so a
use-after-free in mmap() or lseek().

This can happen when you open the same inode across two files, mmap()'ing
in one, which assigns the i_mapping, and open()'ing another, which assigns
that i_mapping to the file's f_mapping, if the cache manager gave the two
files different containers. Each file pins only its own container.

Consider (A, B = separate open files of the same inode):

    A, with container C1            B, with container C2
    ====================            ====================
    mmap()
      coda_file_mmap()
        i_mapping = C1's mapping
                                    open()
                                      do_dentry_open()
                                        f_mapping = i_mapping
                                        coda_open()
                                          cfi_container = C2
    munmap()
    close()
      coda_release()
        i_mapping = &i_data
        fput(C1), the last one
                                    mmap()
                                      mmap_region()
                                        mapping_map_writable(f_mapping)

Secondly, mmap_region() takes a temporary i_mmap_writable count on
file->f_mapping ahead of the mmap hook, and drops it on file->f_mapping
afterwards. As the hook changes f_mapping in between, the count is dropped
on the container's mapping rather than on the mapping it was taken on:

    i_mmap_writable of                          Coda  container
    mmap_region()
      mapping_map_writable(file->f_mapping)       1       0
      __mmap_region()
        coda_file_mmap()
          coda_file->f_mapping = host_file->f_mapping
          vma->vm_file = get_file(host_file)
        vma_link_file()
          mapping_allow_writable()                1       1
      mapping_unmap_writable(file->f_mapping)     1       0
    munmap()
      mapping_unmap_writable()                    1      -1

The container's count is negative after munmap(), so the next shared
mapping of that Coda file, if it is open for writing, fails with -EPERM.

Fix both issues by no longer updating coda_file->f_mapping in
coda_file_mmap(), and by having coda_open() always assign the canonical
mapping of the inode, as do_dentry_open() may have propagated an i_mapping
which coda_file_mmap() redirected.

Reported-by: Chris Mason <mason@kernel.org>
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Fixes: 4bb5f5d9395b ("mm: allow drivers to prevent new writable mappings")
Fixes: 5de195060b2e ("mm: resolve faulty mmap_region() error path behaviour")
Cc: <stable@vger.kernel.org> # 5.3.x
Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 fs/coda/file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/coda/file.c b/fs/coda/file.c
index c9fba41f7cea..64f05f2fc4b3 100644
--- a/fs/coda/file.c
+++ b/fs/coda/file.c
@@ -182,7 +182,6 @@ coda_file_mmap(struct file *coda_file, struct vm_area_struct *vma)
 
 	cii = ITOC(coda_inode);
 	spin_lock(&cii->c_lock);
-	coda_file->f_mapping = host_file->f_mapping;
 	if (coda_inode->i_mapping == &coda_inode->i_data)
 		coda_inode->i_mapping = host_inode->i_mapping;
 
@@ -248,6 +247,19 @@ int coda_open(struct inode *coda_inode, struct file *coda_file)
 
 	host_file->f_flags |= coda_file->f_flags & (O_APPEND | O_SYNC);
 
+	/*
+	 * On mmap coda_inode->i_mapping is updated to point at the mapping of
+	 * the mmap()'d file's container, and do_dentry_open() propagates that
+	 * to coda_file->f_mapping.
+	 *
+	 * However coda_file's container may differ, in which case the lifetime
+	 * of that mapping may not match that of coda_file.
+	 *
+	 * To avoid a dangling pointer, reassign the mapping to the canonical
+	 * one.
+	 */
+	coda_file->f_mapping = &coda_inode->i_data;
+
 	cfi->cfi_magic = CODA_MAGIC;
 	cfi->cfi_mapcount = 0;
 	cfi->cfi_container = host_file;

-- 
2.56.1


