Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD53C79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:24:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4BA266B0092; Tue,  8 Sep 2026 07:24:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 46B6C6B0093; Tue,  8 Sep 2026 07:24:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 35B216B0095; Tue,  8 Sep 2026 07:24:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F33816B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:24:41 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 882EE1404EB
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:41 +0000 (UTC)
X-FDA: 85190362362.17.282E5E2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id AC48210000D
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:24:39 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=URN9YlhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=URN9YlhJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788866679;
	b=AbXO8sMIBRCZecpaWWl4cQoptqlFLJQ7pJa9nssB7cnE65J0Pm3i+H07rRvQqKxbKxHxTj
	FExdK8H+5gbLEi/4zAQ4lDtAG7sHmsN46Sxk0yBmqJK3ChLzot4qlTjMJfwGJvuS3+G21g
	pAr1JnzjRJSOocEY4fiH+oyIi5CFCSQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788866679;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=mfTEZnUAqIu9snNugWvKz9NgMLsK8FTL3j9DOamLiBo=;
	b=WRFDgSNwB5Vn8b3bcMW8KUvLQEPbY6yZHgZq6afFqamQ9kveU4riVF0HavNRC1Xpg7z4tZ
	ANw0E9IKFrkIetDluznS2sp2J3ApkkFDdh7duCpUz1wUFo0oICLvYnmlLBroS3PXDqN3sG
	hS6hEbiVCuPX+oDANiohts98ynty/UQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DB743438C6;
	Tue,  8 Sep 2026 11:24:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 520251F00A3A;
	Tue,  8 Sep 2026 11:24:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788866678;
	bh=mfTEZnUAqIu9snNugWvKz9NgMLsK8FTL3j9DOamLiBo=;
	h=From:Subject:Date:To:Cc;
	b=URN9YlhJSN5Go9+FGDnDonQuzMD3QjcnwdGAyMqEVUEuGrKKUAmNP+q5CuHjZQlhv
	 ClYVpndKK8xa9gqd6ICtUjHEKPCKLHvW9r7Q+P4WIMXlpW8IL7k1nv94wvxhY6AuEP
	 ukXMuQPId/Ph4WCO8dCGMkLGNy7UjYnvjQqW9wOhgTvG03UU8cy870Bbr/pJVU6Ugb
	 czHNQFEamstUcQLxJ45kh9iBiGnT7dqM2pYQxYxNWNSj4d7GtVeuq87TP/s083vsxW
	 wo5+jRt6XykBmUJbIfzE29PaWRRRSlCpKz2zi0p03fCCsGHsC9o89ebsiDx7YKOwjy
	 N7gXijLrRfYqA==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Subject: [PATCH v2 0/6] mm: make MAP_PRIVATE-/dev/zero mappings truly
 anonymous
Date: Tue, 08 Sep 2026 12:23:37 +0100
Message-Id: <20260908-map-private-dev-zero-v2-0-acc7b5625305@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/4WNQQ6CMBBFr0Jm7ZhSIkVX3MOwqGWAiUqbKWlUw
 t2tXMDle8l/f4VIwhThUqwglDiynzPoQwFusvNIyH1m0ErX6qw0Pm3AIJzsQthTwg+Jx5ut6t7
 UVg+ugTwNQgO/9uy1yzxxXLy895dU/uyfYCpRoT2ZxplKOXKmvZPM9Dh6GaHbtu0LSYzZrbkAA
 AA=
X-Change-ID: 20260902-map-private-dev-zero-ba36d76a2fc8
To: Arnd Bergmann <arnd@arndb.de>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, 
 David Hildenbrand <david@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-fsdevel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=3588; i=ljs@kernel.org;
 h=from:subject:message-id; bh=zyHpGOvJgvpz0CkPBa/akIw5hynneWmyWjMSuuPUPHQ=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLLmfygo+B1t2+j0RnhubYNyxk894yWXTk+wjLpmZJv+b
 dZ8+XmZHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIRggjw7l1t97/8Au7PT/9
 3i6li4KPmN+1PO1LVtjZpyG2rSJD+wXD/9imdwurPFYLx7Wv+dd8wuDq4X//qnfGBH2pUb5sYf/
 0KgcA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspam-User: 
X-Rspamd-Queue-Id: AC48210000D
X-Stat-Signature: b6ttcprnbtwsj4iwc89nwk1fipsbdk1b
X-Rspamd-Server: rspam01
X-HE-Tag: 1788866679-640781
X-HE-Meta: U2FsdGVkX1+gGpPpIfhJEEzNlyedtT64Uj9tODbxX75DbAzWaPsrABsfM/9IgxXuIKaw4sV9dLs5KeOgB9qb5NvWLP5qow1ZqyWJxMTI4c+Svh9u0swJMGIB1koF48Da0NvDHmRp0oZKhxTW4+xFWiX3qK6D6E4Qwork5AJGR0zfNKjDJY0iLnN0CJop/8BwamvTcNxNSoKTlxIFhFZGYE3Rh8UDO6QmJEECb7mUBlfVW+98DBEj9PAa0hnUIB8TsAP4TvGNWCtGuOHHuphN/0cITynphXvDPD163HWcTWNra1Xgu9NaXLdcAcScxJeuG9zcfTi1pKY6DqbZhOdtEciyNH1VI0I+UHxkpQzzz0H+NK/TjJT4QClwX+T31Mm2yTkOaUhUlc5gGedfnMaH000vqeLPFG8EdARdf1E60HUTztaV+FxuaFj990rDfaw4yyWKI2IZLJ/R2UY6QVWnzUphG3W4Y1cSQfJTSrdsPKLCWxClKy+zEhZBiuex/oVYTVObAHvnNFm56XRSyvMu91Nq8i54xJoJM5TfEHS0MRa0aFZyqOqgOu+NOUGGDpLQbb5M0SP1/naVxTA0FBRKvL08hYDCwGCUdIwIroPFnZRe96i0ih7OV6jJzVXMjuymvC6GVf1YXB6FnuWewTU3w4PcI9YjdB2o279K/+9ob6eNPAKNYH0QHJOS6H4n2KPs0OHvDaM0aN+pbCJm9UUKnALJBLM3jzDO09MiKV+cthNHMdO9KYsrqGy4LGugSqtOwH6P2OhTI5w3zZhsiwubRlhLYmLgOo1uBA4jUfLbxt9lUr60gjBalJmx3SjCOeIx3zwET8KpZM97ogaqw7wm0VhnXipuR4gOb06PBBpE7yZqXB4j254sxiNLZnIVnfIfn88B3Zzt4pPfEqKGQIRkQarnJIccnQZPg8fwI4F71yPtSqgaEf8SNBoB++YtJaeEYvJdKmay3KRflcqrZ3S
 tRblnj4c
 BHjHvD0kBnfkSahLWIutmP30zrwrM3JviaEoCWoDwKc0QY46emVboluN/69qXH+lidGw2a9x3aTBX8cJoNlAzhcvudFELy71jPMT7eGT8+gW964SiulHKnBIaq3FsyWD1B/u57DRtdj1pM7YOF/IUqc2rMLEoGQcfii8atxxYUJ/0lnDoouHZVY384bVOdiTTlx+DCrMsO6eNVd83D9eDSFYY1v0hBP1VHlZ5mYcmUobq31fOhwLQ0lJmcTnfoP1LKsZB7X98sXBibjYkqGVN+tLlj/g6ppz26SmjFZAh/xc4Bew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Historically anonymous memory was obtained in linux by MAP_PRIVATE-mapping
/dev/zero.

The canonical way of doing these now is mmap() specifying MAP_PRIVATE |
MAP_ANON, but we must continue to support the legacy means of obtaining these
mappings.

As-is these mappings are an unusual edge-case - they satisfy
vma_is_anonymous() but have non-NULL vma->vm_file, and their page offset is
the offset into the /dev/zero file.

Commit 93c0c8dc87f6 ("mm/rmap: use anon pgoff to track MAP_PRIVATE
file-backed anon folios") causes all other anonymous folios to be tracked
by their anon index (vma->vm_start >> PAGE_SHIFT at the point of first
fault), leaving MAP_PRIVATE-/dev/zero as the outlier.

This series remedies the situation by making MAP_PRIVATE-/dev/zero mappings
truly anonymous with !vma->vm_file and correct anonymous page offset.

It starts by bringing the memory character driver into mm/ - this file
implements /dev/zero, /dev/mem among other things and is already (as
clearly indicated by its name) within the remit of memory management.

By doing this, the file_is_dev_zero() function can be provided, internal to
mm, which allows for positive identification of these mappings.

Using this, first prevent any other mappings from mapping memory
anonymously, then make these mappings truly anonymous and eliminate all
code in the kernel that previously had to account for these strange beasts.

Finally, it adds userland VMA tests to assert the behaviour and selftests
to assert expected merge behaviour.

v2:
* Added tags (thanks everybody!)
* Reworked comment about mappings not setting themselves anon as per David.
* Fixed up test typo as per David.
* Fixed up test close() as per David.

v1:
https://lore.kernel.org/r/20260902-map-private-dev-zero-v1-0-a578c730cec7@kernel.org

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
Lorenzo Stoakes (ARM) (6):
      mm: move drivers/char/mem.c to mm/char-mem.c
      mm: implement file_is_dev_zero() to uniquely identify /dev/zero
      mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anonymous
      mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly anonymous
      tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero is anon
      tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge tests

 MAINTAINERS                                        |  4 +-
 drivers/char/Makefile                              |  2 +-
 include/linux/mm.h                                 | 10 +--
 include/linux/pagemap.h                            |  3 +-
 mm/Makefile                                        |  3 +-
 drivers/char/mem.c => mm/char-mem.c                | 21 +++--
 mm/internal.h                                      | 20 +++--
 mm/shmem.c                                         |  2 +-
 mm/vma.c                                           | 39 +++++++--
 mm/vma.h                                           |  3 -
 tools/testing/selftests/mm/merge.c                 | 95 ++++++++++++++++++++++
 .../selftests/proc/proc-self-map-files-001.c       |  2 +-
 .../selftests/proc/proc-self-map-files-002.c       |  2 +-
 tools/testing/vma/include/dup.h                    | 10 ++-
 tools/testing/vma/shared.c                         |  9 ++
 tools/testing/vma/tests/mmap.c                     | 37 +++++++++
 16 files changed, 220 insertions(+), 42 deletions(-)
---
base-commit: e3b5239afe1b8f0194db7436b17c33e94c1988c4
change-id: 20260902-map-private-dev-zero-ba36d76a2fc8

Best regards,
-- 
Lorenzo Stoakes (ARM) <ljs@kernel.org>


