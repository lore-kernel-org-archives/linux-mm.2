Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D8D48CD4F54
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 10:19:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4AD876B0088; Wed, 20 May 2026 06:19:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 459B36B008A; Wed, 20 May 2026 06:19:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 36F3D6B008C; Wed, 20 May 2026 06:19:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 257C06B0088
	for <linux-mm@kvack.org>; Wed, 20 May 2026 06:19:08 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B4C8D1604F2
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:07 +0000 (UTC)
X-FDA: 84787400334.15.9BD6194
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.5])
	by imf26.hostedemail.com (Postfix) with ESMTP id EBE6D140009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 10:19:04 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OBC51bwB;
	spf=pass (imf26.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779272346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9BVjTk8nQGGmUxI8PCEpxJWmL7Kaf4Qp03cf8IYb8qA=;
	b=IWbukSKyCIrWL2EgSVO7m2liwamA/EH+cPEa1BuAuTBYukc8AghH2pIQWmxdt1DfyXLEHK
	SWJpp2962Zp2YS61ciddGpjF91OK9PTWcpSpIlrMh/MmTX0hFZuVHwAcHj9nGMGN2vcqhB
	rNN6f4J7MgWGhR1XRtjbcTYt1RZHXsI=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=OBC51bwB;
	spf=pass (imf26.hostedemail.com: domain of chizhiling@163.com designates 220.197.31.5 as permitted sender) smtp.mailfrom=chizhiling@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779272346; a=rsa-sha256;
	cv=none;
	b=ebW8gBHot43jO7pgWPWIx86Z3k5CVDLfys6SeN6O4VpxEIOf3XEUHYQ2FEq4XmCnvCyMPu
	gRs/CTR5NqyawtheZ6coAROgrjysqeRIgA7JLI9g/5KYw++sUBvtxbXI+Kpuzh4v3FbyqG
	t0jRGfe7J/lsbJIDAtPPYrB9vcTv2Fg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=9B
	VjTk8nQGGmUxI8PCEpxJWmL7Kaf4Qp03cf8IYb8qA=; b=OBC51bwB+qfYf08FyI
	e7P8qz+PHuCddXwTbn7uKjr4zqkZU0fNQ3zSbi6dn1aUAPqtA7YCBEow+TVMt7p9
	lgTaW14EdA7BkCwq3S7lUnZykKo4W1Um4BYx0mKHKXPTXseMEG9nn+PZrYEez25h
	qfZ4rCsR5z/5lXO9nRS5Toi2w=
Received: from czl-ubuntu-pc.. (unknown [])
	by gzsmtp5 (Coremail) with SMTP id QCgvCgDXbbprig1qQK31EQ--.641S3;
	Wed, 20 May 2026 18:18:25 +0800 (CST)
From: Chi Zhiling <chizhiling@163.com>
To: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Cc: Hugh Dickins <hughd@google.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Chi Zhiling <chizhiling@kylinos.cn>
Subject: [PATCH v1 1/5] mm/filemap: reduce unnecessary xarray lookups when read cached pages
Date: Wed, 20 May 2026 18:15:34 +0800
Message-ID: <20260520101538.58745-2-chizhiling@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260520101538.58745-1-chizhiling@163.com>
References: <20260520101538.58745-1-chizhiling@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:QCgvCgDXbbprig1qQK31EQ--.641S3
X-Coremail-Antispam: 1Uf129KBjvJXoWxCw4Dtw48ZFyDCF4fur4kJFb_yoW5CFW3pr
	1rG3WkGrsrJw1YkrnxJay2ga4rW3s7XF45JFySg3WSvFn8Arn0kayxKF15KFyDZFy3ZF1f
	XF18Ja4vgF1Yq3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07jso7tUUUUU=
X-Originating-IP: [116.128.244.169]
X-CM-SenderInfo: hfkl6xxlol0wi6rwjhhfrp/xtbC3BGcOmoNinFzrgAA3q
X-Rspam-User: 
X-Rspamd-Queue-Id: EBE6D140009
X-Rspamd-Server: rspam06
X-Stat-Signature: zx3xq36f3xbomezu5i4fuso138h98m6s
X-HE-Tag: 1779272344-81697
X-HE-Meta: U2FsdGVkX19Nb2VKrZnI/xc0CGF/otVc+jIo1jh75xdgCA4OM+Ec+viAiHmcQm895skTtZ5JAWHCBSi4EeKYpHmVsa0/ILAujw6zAgAUvl+bHbsOTUSp23A4/YSYYUZqy9y50NpF1nw1FNIEml+8Hfx/Y4ZbI3PgrzoZA37QfZtn9DOWHE9smGBhtHRWxMhEB0k8f6GqYoH7OhUBe4EBknsgp5+4JWcX9jp40VtuN08fTSjic7HRXWBUGl+C6dGGs/QvBJnXmzv/YNttCnkSOQlX2stPw3L0NfTtVWoxlfWEN8IBgKgVW1jqVbln9dLg7tbFUbul216tyRLu7RGIE1ytompU35XFxQX/W5ea/3hOcIi1+iDBxS2kspt6QMhg2QjB2EIB4I5p+rXdCcjmia9wNVhxdgPC9B9sGPmp/zCZOvGnhebzrJUyNQILyQMUIa8T87Fn+lPGk/TAaYHEah6I9g3bAm9ceM66+7VCEUlxFOLdJ69uDnWdAP162uKwPq+iPDrR+vtd8CN4LquvLv1s8OhX+qXcWxTDnmfYFgOpxuaLi5l6DLTx2OzbZ86prulC+2j4v679WsPSQ3Rm+Oz0nxURe2gL6YOD1+2FZkA/TEg2QMLLZhvuEhlDFRTI2DTecz9fJWAhvBkeyApbjfRf896omrv3JTgZksSzmY5LrWNGg4hDA/TS6mHQga9AEBftfTykZb/8nwMs/eSoS5qMmmH+2nJ26zAL3z4bUVhqEDPPzmxcpzIbFWYwxmLyovDmGAWBL2hTs9a9Yi98ZpykF5kYkFOXVIcbXkJoxeWgD2wus37CO9NXOgYPfiVniubj7Psy+bmOUYsxiYaoq8ivIPzahOiqKPYSTHFvQVNTqVAyrPguemudnkE4333mFNho7vc0KmWYz+WzWjEw4nthe9m39n5fobUCIZG3DPtEAVjZOacakhZAHYnK659E9RkIhKcRs46iCVEdUH8
 t/mGGQdM
 Ll5bcTKt7q//vQDyU9saZxqoB5916JHfAKbBadIxoYwBbi2gnb35PaA30AFzLhIWrM66gZN7yrddDO55AcUEs6cpDXZ/uFlGcvQjxh9KpvO7NZABWtqT53oSXFV4cnM4k3y8WqDLzxdLT82AI+/TdF7qEiHfp1weLpRhCNu7Ft2vFlBI8rgSNbCO8TU0CqkE2ULCdtP7ZtfNyRKXt+fLNPSoZkEvrY8ymgz78ZCCFgLW/HfWZIJPSvt3iajsCi0hePtGhYl/YcVf16wttu9wL3hK/VGUtKZMd0uMudQYZRDCso3UJo5NC390YH7Nl4AzJZhj3xtXVCuGBc9RKj5iP0XheXA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Chi Zhiling <chizhiling@kylinos.cn>

When reading small amounts of data from the page cache, only a single
folio is typically returned from filemap_read_get_batch(). In this case,
calling xas_advance() or xas_next() after adding the folio to the batch
is unnecessary and only introduces extra branches.

The same issue exists for large reads, where one additional xarray walk
is always performed before termination.

Move the boundary check to after the folio is added to the batch so the
final redundant xarray advancement can be avoided. This significantly
reduces the branch count in the read path.

xas_next() does not update xa_index when xas->xa_node is set to
XAS_RESTART, so checking the boundary before updating xa_index is
sufficient to keep the folio within range. The warning should therefore
never trigger.

The branch count:
654.198 M/sec -> 646.444 M/sec

Performance counter stats for 'fio --ioengine=sync --rw=read --bs=4k --size=1G
--runtime=300 --time_based --group_reporting --name=seq_read_test --filename=file':

before:
READ: bw=2697MiB/s (2828MB/s), 2697MiB/s-2697MiB/s (2828MB/s-2828MB/s), io=790GiB (848GB), run=300001-300001msec
      245602051556      task-clock                       #    0.821 CPUs utilized
             78467      context-switches                 #  319.488 /sec
                40      cpu-migrations                   #    0.163 /sec
              3388      page-faults                      #   13.795 /sec
      758312319204      instructions                     #    0.74  insn per cycle
     1025881497502      cycles                           #    4.177 GHz
      160672383734      branches                         #  654.198 M/sec
         361904512      branch-misses                    #    0.23% of all branches

after:
READ: bw=2709MiB/s (2841MB/s), 2709MiB/s-2709MiB/s (2841MB/s-2841MB/s), io=794GiB (852GB), run=300000-300000msec
      243985503670      task-clock                       #    0.812 CPUs utilized
             79004      context-switches                 #  323.806 /sec
                30      cpu-migrations                   #    0.123 /sec
              3355      page-faults                      #   13.751 /sec
      747830935069      instructions                     #    0.73  insn per cycle
     1019609333322      cycles                           #    4.179 GHz
      157722976668      branches                         #  646.444 M/sec
         348984893      branch-misses                    #    0.22% of all branches

Signed-off-by: Chi Zhiling <chizhiling@kylinos.cn>
---
 mm/filemap.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 4e636647100c..d54450e529bd 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2458,12 +2458,16 @@ static void filemap_get_read_batch(struct address_space *mapping,
 {
 	XA_STATE(xas, &mapping->i_pages, index);
 	struct folio *folio;
+	pgoff_t next;
+
+	if (unlikely(index > max))
+		return;
 
 	rcu_read_lock();
 	for (folio = xas_load(&xas); folio; folio = xas_next(&xas)) {
 		if (xas_retry(&xas, folio))
 			continue;
-		if (xas.xa_index > max || xa_is_value(folio))
+		if (xa_is_value(folio) || WARN_ON(xas.xa_index > max))
 			break;
 		if (xa_is_sibling(folio))
 			break;
@@ -2479,7 +2483,11 @@ static void filemap_get_read_batch(struct address_space *mapping,
 			break;
 		if (folio_test_readahead(folio))
 			break;
-		xas_advance(&xas, folio_next_index(folio) - 1);
+
+		next = folio_next_index(folio);
+		if (next > max)
+			break;
+		xas_advance(&xas, next - 1);
 		continue;
 put_folio:
 		folio_put(folio);
-- 
2.43.0


