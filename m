Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C7FE760A2629
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 08:42:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=cmss.chinamobile.com header.i=@cmss.chinamobile.com header.a=rsa-sha256 header.s=default header.b=kkO3X8dE
Received: by kanga.kvack.org (Postfix)
	id E39E96B05B3; Wed, 11 Nov 2026 03:42:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEA8C6B05B4; Wed, 11 Nov 2026 03:42:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D008C6B05C7; Wed, 11 Nov 2026 03:42:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B2E156B05B3
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 03:42:06 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 5085A120234
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:06 +0000 (UTC)
X-FDA: 85422195852.19.6CEEB79
Received: from cmccmta8.chinamobile.com (cmccmta8.chinamobile.com [111.22.67.151])
	by imf11.hostedemail.com (Postfix) with ESMTP id CF00F40006
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 08:42:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=kkO3X8dE;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf11.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794386524;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=leBldGOQmZt7O/6SkYIQPS1xwEKAHAsT12p86kInRCs=;
	b=oUjMFKDHptNDK+TM17f86TbiVu1aM9HCEEu0yUzDfXJBTI5XRmRS30EDcWny6+HaWSXuiv
	glHvQlrXuzLNI9MgMRynawAE11Pkd79m4OSvIx4ogkI9GIaZyKErBw8Rpvco79TWBXHOog
	3Fhusbbmqbs+zC4p62jBq/9khkYhW6Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794386524;
	b=VtCuGbz1yYht6Zq4ZzrtN4VXFvD8utNU9eM0VLGu0pA1qkx89xvO17v0TYJDUy3vFFfh15
	ybDXBKC6W2GdJjdZpXkT15X9q7BwMN298FUZTd5I4U5sACAzmkzoajxeK6JauVSI7ugscc
	J6MMLwjBxu3ivM7Sz0Dm8YAFuZ6Zzs0=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=fail ("body hash did not verify") header.d=cmss.chinamobile.com header.s=default header.b=kkO3X8dE;
	dmarc=pass (policy=none) header.from=cmss.chinamobile.com;
	spf=pass (imf11.hostedemail.com: domain of zhujun2@cmss.chinamobile.com designates 111.22.67.151 as permitted sender) smtp.mailfrom=zhujun2@cmss.chinamobile.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=cmss.chinamobile.com; s=default; l=0;
	h=from:subject:message-id:to:cc:mime-version;
	bh=47DEQpj8HBSa+/TImW+5JCeuQeRkm5NMpJWZG3hSuFU=;
	b=kkO3X8dEtIq/pfB8hF/EctDfKJniYF45iQwy4EaBeddH62GADKqreCKqF7+hq1gxfVsXc02WbitE5
	 nWJlvyhwTyO2mDYtZzlBNvBn8lEflapm8sTkwI8HXlHhB7T93jdKVbm1OxWIfWFcnkEpGH5+iWuOeL
	 ab3Kbg7eI6iO+S5I=
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from spf.mail.chinamobile.com (unknown[10.188.0.87])
	by rmmx-syy-dmz-app02-12002 (RichMail) with SMTP id 2ee26af42a53ebc-12d41;
	Wed, 11 Nov 2026 16:41:57 +0800 (CST)
X-RM-TRANSID:2ee26af42a53ebc-12d41
X-RM-TagInfo: emlType=0                                       
X-RM-SPAM-FLAG:00000000
Received:from devin-VMware-Virtual-Platform.localdomain (unknown[10.55.1.72])
	by rmsmtp-syy-appsvr09-12009 (RichMail) with SMTP id 2ee96af42a52be3-d5e6f;
	Wed, 11 Nov 2026 16:41:56 +0800 (CST)
X-RM-TRANSID:2ee96af42a52be3-d5e6f
From: Zhu Jun <zhujun2@cmss.chinamobile.com>
To: akpm@linux-foundation.org
Cc: hughd@google.com,
	david@kernel.org,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+aae8bd56cc1c38d50ec4@syzkaller.appspotmail.com,
	Zhu Jun <zhujun2@cmss.chinamobile.com>
Subject: [PATCH] shmem: Serialize fallocate progress with writeout
Date: Wed, 11 Nov 2026 16:41:55 +0800
Message-ID: <20261111084155.80971-1-zhujun2@cmss.chinamobile.com>
X-Mailer: git-send-email 2.51.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: b6wkudrfprdpsk94yak3eeqktwhnk681
X-Rspam-User: 
X-Spam-Status: No, score=-16.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: CF00F40006
X-HE-Tag: 1794386522-725564
X-HE-Meta: U2FsdGVkX1+D7M6Y1RzH4EwUHehAt5+TshIGHGOPVnTYfIEuKmA1xgoQ2YETjxqlW6/44qiVOVhx51kX0pi21lMCCAyhSyY+KLzh7alo2ovNxboPhgUmaqCJCV6QPgztLdWlGZ2nNdH5soBop/Sdar7kVpw4ddve6vTjN+aMpjfJDShMndQrAq6uiQNVPEPg8o0xMDsmrYcme24ykryVwvmA9acM9mF/7UQ3bbZbsxZgVhwPCSGV8yKcU8dLMndxqYn9kVOfMjOlnK0SgdqARKdUmVJNPOZK4iokD3ZzJnygYvi7r/vjS5BkyTchUSnnhPrmaL4p3GzmB8R3Paj2dkGSyZZBSto3gP4GdrHPlM8QlvZwu+4/F6q7zJbB2wqCII9JxB8Ur6X1c+geZXXfRU9UYjW9QaeDrptyzko5+mLzwQQETTcohpKJjoUidGMyehLjftpWXkrcVkT8P0LUbcciWSu3xioZG2PRzO08uMoxknJn0SsiUeMxGhnjWMcHcWEynhhTN3y954t/E6BYOycWjRMaygHtcWKQZdNOOH9+taq601aq+tCZqUgiiOSaH6Ji07XzHK2UpQgKAQJpRW4RwRGCQewAcdefLhzCPvkZeP47xNBbW20NEuU7fsYbP7qzUPk3twBiidKq2VCPDzroy7xtChUmkwWBp9lH5tTNBPI7aK9uwpNXsFaPogU2TgLTlAHhW7pmb/UVr++PDupg2X4009HfBFq/1gRzdcpPyUC+90cG1lBcKpcSHwxldFlFH/boxU2VN+wewac4a+Tmi2avzYvpevqPHtKXtFqNlbyOmpy/iiOKTmKQhcPNFbrKzz/DRthX0nOjm6GHbvBUzDwmoOQC7bU7nTXxPUUfUhJZz2Ob/4/hGeAFXQB/XcBDqgXlZng2KvbCT4GOZ6LqVO6wDaj3DDShkY44vsIzgTuYYfLjDAtsUA7+aGYxmmYe5FxwK+TXS+iigxY
 Olyyx2AW
 0tEP9TBP6SJZyPG/9x5UyKz+PULTiZGsFvGIARhPWF2frqranQMmKGiFFGNdwooGvmyGpN10cS+CW/oWWBKceTJs0SZOs2w06ceO+KBRMQd8up1etS8c1E/SkMAleAArNk9kBE0q9pp1BaXxP9Sb06MRlvHKP5cbG6WrPplk6ExSFHfT7Bt0vojjIF6aqH5inRcv2nTBYXSL+g1xtQmceIfv7IujUWQbrL65tLTY65+0TYRW5wL4J2Fckw8W1i5rjQndrEc0gJcn8vjzeQgtwZkRGLDTC/DHAekSm1sdyYP+RUMsYYfwYK/w87IJRqVzUoGIBf4+H0dN95g1Ngdk+TWJOR+GtHQBCeUgPbuxhYVHQ8r5S6gTZNoEfBovNTPMhe8nLHJSGSPjeINg3z72qSSDxvz+6M3FxAh2Gwre6dxax2JVgdT2iGa3Oby2kuUwtNxKm
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

shmem_writeout() uses inode->i_lock when reading fallocate progress and
updating nr_unswapped, but shmem_fallocate() accesses the shared progress
without that lock. Holding the current folio lock does not exclude
writeout of a different folio, as the KCSAN report demonstrates.

Use inode->i_lock to sample the unswapped count and publish fallocate
progress. This matches the writeout side and keeps the existing folio
to inode lock ordering.

Fixes: 1aac1400319d ("tmpfs: quit when fallocate fills memory")
Signed-off-by: Zhu Jun <zhujun2@cmss.chinamobile.com>
---
 mm/shmem.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index 990f1b083779..5769cfab1d71 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -3969,6 +3969,11 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
 	for (index = start; index < end; ) {
 		struct folio *folio;
+		bool unswapped;
+
+		spin_lock(&inode->i_lock);
+		unswapped = shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * Check for fatal signal so that we abort early in OOM
@@ -3979,7 +3984,7 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 		 */
 		if (fatal_signal_pending(current))
 			error = -EINTR;
-		else if (shmem_falloc.nr_unswapped > shmem_falloc.nr_falloced)
+		else if (unswapped)
 			error = -ENOMEM;
 		else
 			error = shmem_get_folio(inode, index, offset + len,
@@ -4007,11 +4012,13 @@ static long shmem_fallocate(struct file *file, int mode, loff_t offset,
 
 		/*
 		 * Inform shmem_writeout() how far we have reached.
-		 * No need for lock or barrier: we have the page lock.
+		 * Other folios can be written out while this folio is locked.
 		 */
+		spin_lock(&inode->i_lock);
 		if (!folio_test_uptodate(folio))
 			shmem_falloc.nr_falloced += index - shmem_falloc.next;
 		shmem_falloc.next = index;
+		spin_unlock(&inode->i_lock);
 
 		/*
 		 * If !uptodate, leave it that way so that freeable folios
-- 
2.51.0




