Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9F74360A6F6F
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 15:51:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Nxt2g2oi
Received: by kanga.kvack.org (Postfix)
	id C10F26B02D8; Mon, 19 Oct 2026 11:51:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BE9166B02DA; Mon, 19 Oct 2026 11:51:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A8D846B02DB; Mon, 19 Oct 2026 11:51:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 71D656B02D8
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 11:51:08 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 06D831206EB
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:08 +0000 (UTC)
X-FDA: 85339814616.10.4B3AFB8
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf05.hostedemail.com (Postfix) with ESMTP id EE6D3100008
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 15:51:05 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nxt2g2oi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792425066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=U8qRbxVMl9WjIylP4uF+PXHiNMFQO2d35UvAtzhx6sE=;
	b=XlD83OeUurUhRT8LUF5bqZKzbFsse99JE3FzIRdEblE6zoZlbOUIKGxjd7njAyUElWPYhj
	ynpBSu3KuL158E0jmjTjPviMuN/yN1pEaLM45FxaJXLmMKNnvxVINjuyL6hsq8ycfS5C+Q
	jHmx6vRw2/l+cFc9gWmOQKaSIMM/gAI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Nxt2g2oi;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792425066;
	b=6KVvXrX6ga4DMmiv2VXt2BJdcbcPwFzjAcA0FlyWLeYVSrJCA6pEu+p2BsABxFHM5lSB2r
	AUjoVDs5yHokQFMPRnOYmpIa5hMgx8Y8qsAaMqckZNvdyKSquVafUzYk8om93L+Rezgbzl
	y35r0RIoWJzJmQNbFJa5UZdX28jYvK4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 33E914368E;
	Mon, 19 Oct 2026 15:51:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 719EE1F000C7;
	Mon, 19 Oct 2026 15:51:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792425065;
	bh=U8qRbxVMl9WjIylP4uF+PXHiNMFQO2d35UvAtzhx6sE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Nxt2g2oiPGhnjIWMFd6cbSzerN9RvuAWTochm/XIy+E3YgUf1ZKNc8ln+V1stW6pX
	 ZcRt0aztuO/x4TKZwVt8iBbJ6Kxejpr3xo3MDRJ0jKzal9WgbiB9Uc/un90xx3FDrT
	 pPcpiOK/8jZsztT3XHl9wl3XRRn1bEhRNSK9HC4iHctRg9PYH6/IUpXxQl5WfpeGZj
	 4YvYG/Ro99+XS/8h9VgRiIe7rpith9RJsbUBI/xyfAdcBbw61aav957VdLN35pfLkH
	 bvsk6kTZEBfE15MbvrhHYoAMi1cgOHa1QNnfeOHRCrJ1olgyKBF2Jqf7b5YssNzsN+
	 OVEYF68UZGAOg==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.ams.internal (Postfix) with ESMTP id 1D1F2198004A;
	Mon, 19 Oct 2026 11:50:56 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-01.internal (MEProxy); Mon, 19 Oct 2026 11:51:01 -0400
X-ME-Sender: <xms:YDzWavEfAzDHlbtkw43VHg8TgjhQJAnw1Jjqwece4I3M6InZ-xI0ug>
    <xme:YDzWajRvf9T-pZcLgW2VfcFdhAhsfvQAlVJ-ZmMYXZvghP4XJepVTjFWi3swHcItr
    0x-uN_A_buNRbTB-eqHjn77IPWSTwV0pC00iqlGLEpNCYH5_LZAQTqX>
X-ME-Received: <xmr:YDzWamQt4lUKxuM6mWiRPGQrl3ABRPx4XoY_U5iQ-jLjf99c2A4HLMs4orA>
X-ME-Proxy-Cause: dmFkZTEKM7cQ34PANJkOaDpnT+IXyH0pLg7IoM6i34Jbx05genX6Ndq2TdcGNb9654u2H8
    41WED7y/zjj5LaonH0VFTkPtnxIjhuRVEkvuk8kM9rm/ofB3Z9Tg4QxquxaJFHbDWQqeu/
    Vblnly/EuZwo3Wz9CpGJqqgTrStLmT9zjqH9hVTJAPs00+uZifgMXlnluxpV6wuH9uu7MT
    BObPpnz8l78pdcpT4Vufdwi//iHA9W9CmvvMWThM1WI/4eq4v7bHyLxAHLcqSlwPUMMG0k
    NFb5bNvmq2vpdgPX6RraAkdwYnZfp8UPDvRR9XmyDlbwFnPxU3uIs+BDzqJ7Yv2QnX71lk
    SqTihz8KrnAWYbCEV29gvySR44BJOhM620UDi7RgBFyzLt2FX77tl1bIEBd8zUsl2vqnNF
    nFaX7oJnw9jzl4Im4TmEN0FGPZ+hsD/Hpjbxq0aPtS9IEAD2eUm0nsjguUdSMoJhg0gvJg
    WclWlsxxO7a/TyCOSLZLOk2ezO+K1Pjj6gnvCHiC4xJ7A/NLQkpZIIyLZ6fIYskJfVezB1
    JTKjUjaYrzuI6H1hc1SKjxsKl3ECQXuoGoOaFfx3Txr+D8UvGA/dyqgPe86Zmx4yohNOZO
    g36OTZ7vqw89oUDxbVcG9dYAawcjetiW5em9S+Vas4yhNDrb4krv/lDYi4Bw
X-ME-Proxy: <xmx:YDzWahe6XQtR_czawTECLRbTlkQV8_F02JYYhKqCjvzBSiDbaJX0rQ>
    <xmx:YDzWalD4pdBDtl5ELDDJ1MH7xTird3kdsSn7mgvb21I_dMwrV2TdMQ>
    <xmx:YDzWav3TAoXK8KuPEM4LtTdnNSIUwL795qFfbdo06m35H3kNVyw5Aw>
    <xmx:YDzWalTWwMKpKrOa4fbMkkJAU3XstDwNk42O7fO9r5q-YYmBFZV0Sw>
    <xmx:YDzWakSweUIpfOdYnD9vJqMIMKktN7bTZdMldlEqsQh6COpyGDSZyMsZ>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 19 Oct 2026 11:50:55 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Hugh Dickins <hughd@google.com>,
	Christian Brauner <brauner@kernel.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	Miklos Szeredi <miklos@szeredi.hu>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Oscar Salvador <osalvador@suse.de>,
	"Liam R . Howlett" <liam@infradead.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kairui Song <kasong@tencent.com>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Yuanchu Xie <yuanchu@google.com>,
	Wei Xu <weixugc@google.com>,
	Baoquan He <baoquan.he@linux.dev>,
	"Paul E . McKenney" <paulmck@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Harry Yoo <harry@kernel.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Ilya Gladyshev <ilya.gladyshev@linux.dev>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	fuse-devel@lists.linux.dev,
	kernel-team@meta.com
Subject: [RFC PATCH 15/18] mm/filemap: read large folios without folio references
Date: Mon, 19 Oct 2026 16:49:08 +0100
Message-ID: <20261019154913.1765974-16-kas@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261019154913.1765974-1-kas@kernel.org>
References: <20261019154913.1765974-1-kas@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: EE6D3100008
X-Stat-Signature: 8u599jsdtsam8crg6ajobqkmypbyxpaj
X-Spam-Status: No, score=-19.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	RCVD_IN_DNSWL_BLOCKED,RCVD_IN_ZEN_BLOCKED_OPENDNS,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792425065-507105
X-HE-Meta: U2FsdGVkX18mtJYBTQvZzemAG0N6MzzrxJp9pG0AYWadJbkOsHMsbbkYAc31xKTAB9S5nUxfun3jBgx+kfevZKWrGQO7X5g8r9WAWpqad2VNwoFctIR+0F+dXJIA+Wix+Rm2xti5l47/24B6TvworvYUw2+41wbadME9YsrAeX8hhkTzXN7U0qgvM4tqteg5XadNqD2Wxy0qhf5vzRojRcCdQ6afcpSanXw2RFzk+Dyb3ALmHKFbG2rKQaS5qt4oDF5GLgpeuuTD1rfVHNoyfQaBgln0d2wvOP+b4tWcXAme/kbGzRXfR2QsJ3nVOCZBBnbELsIVVKpQImCSnVntZUx7jQ1bBzvp/3o1vJ8vz6loFP9122xPR0Cnp/WO6aamnj2++KQZHHFqPUzkhyzL/R0NIfW1RZADMe6Zzg+yrKP9WiH7Yf8tQ0IW9Z9Tt0zEz0o6WNtXg6d7YkQKqX63LPcajG33sCTd6X2WER1JAi4cpWuBVyeAYNldqpbgwmdmz8Da1iCGERRpf/L1KBJ7f6gZHLQWJ2dpuixCiMhnXL1r/la9Zg1PpoKlevLjRKlXGBc9PM5Km4szKeLGNTlZVUBGQTgvBTz0Hlezr6VFDH8dKm1U+gUalaEMu1C9UNjrbelbU2ImbYmjN+fhIMpujCrQNqWWnnVpVcFx0TFGIBTryE3M5eHL2vsUf2/nB2XYeBdWtspf7wFuM/AscfeJGtub1FxqPX02xj1fdtXPVWjVxJ6IfzticSevEREa8n4dPyBaIxCp5JilG7tG7MR8Gj7ZYnbYNOh3zBQ8d8tr5A0JaCJVFs9ldWG3N9MDqWhWO4z406l74M05cROtuwJ6So/jfwfk9DowAGcfcHvUo6SaF2SqS0BqeUne8kSOkCzIjiXmctpJzcvtiAYOQUmhJEXD5GsmX9Vbj9NIamQd11Mc7APbyMr6FnpKwerZsaEvOWJC3vnVaqfltUv3aIl
 e0wbw8tj
 kKSNLMKdpg+iUqFOKSaNeD2GyW026aPX6b1JDuomjpqEyj7svCqlGSCT2KdGj5/dEi3tlbVJeyu0eAw6Ksdpw63cgyA2rc6Bmy2Mshbz6hIEplT91ZYQu9oJTqkLpTLe9vEW/lFz831JQrmAoSLvUADfRH0iVdlBPjyYO6s39axchxwqzXt9x/VyU0rbGBCSLqPIIYf2rEJVkk/SDVEtEULW2uFirG2m4lMLZHSL5tGvedjECJRJu64YusFAufHgS+gvUAzmeMKnpeIGocBtVGJJMUlOkL5rFjHkoMdLKvN602VIb8YTGkIukcAiXUsEjm2lNNH438HYWxPF8zpTCGEDIqg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

A large folio is in all the slots of its range or in none.  Once the
slot of the last page to copy holds it too, the pages in between are
this folio's: copy them after one lookup.  The folio's size is read
without a reference and only picks the page to check; a split after the
check copies PG_rcu_free to the new folios.

Copy page by page with _copy_to_iter(): the hardened usercopy check of
copy_to_iter() reads the folio's order, which a split can change.

Assisted-by: LLM
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/filemap.c | 64 ++++++++++++++++++++++++++++++++++++++++++++++------
 1 file changed, 57 insertions(+), 7 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 55fc471c0489..ace6b1fd6b9e 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2843,9 +2843,6 @@ static bool filemap_read_rcu_can_copy(struct folio *folio, pgoff_t index,
 	/* memory_failure() waits only for readers that got past this */
 	if (folio_contain_hwpoisoned_page(folio))
 		return false;
-	/* One reference covers all of a large folio's pages */
-	if (folio_test_large(folio))
-		return false;
 
 	/*
 	 * The slow path does not call folio_mark_accessed() on the folio that
@@ -2899,6 +2896,60 @@ static struct folio *filemap_read_rcu_lookup(struct xa_state *xas,
 	return folio;
 }
 
+/*
+ * How much of @bytes, starting @offset into page @index, can be copied from
+ * @folio.  A folio is in all the slots of its range or in none: when the slot
+ * of the last page holds it too, so do the slots in between, and the pages
+ * are this folio's.
+ */
+static size_t filemap_read_rcu_size(struct xa_state *xas, struct folio *folio,
+		pgoff_t index, size_t offset, size_t bytes)
+{
+	pgoff_t end = index + DIV_ROUND_UP(offset + bytes, PAGE_SIZE);
+	pgoff_t next;
+
+	if (end - index > 1 && folio_test_large(folio)) {
+		/* Read without a reference: it only picks the page to check */
+		next = folio_next_index(folio);
+		if (next > index && next < end)
+			end = next;
+		xas_set(xas, end - 1);
+		/* A split after this copies PG_rcu_free to the new folios */
+		if (xas_load(xas) == folio)
+			return min(bytes, (end - index) * PAGE_SIZE - offset);
+	}
+	return min(bytes, PAGE_SIZE - offset);
+}
+
+/*
+ * Copy @bytes from @folio, starting @offset into its page at @index.  Page
+ * by page, as copy_page_to_iter() does, without its checks for each call.
+ * Not copy_to_iter(): its usercopy check reads the folio's order, which a
+ * split can change.
+ */
+static size_t filemap_read_rcu_copy(struct folio *folio, pgoff_t index,
+		size_t offset, size_t bytes, struct iov_iter *iter)
+{
+	struct page *page = folio_page(folio, index - folio->index);
+	size_t n = 0;
+
+	while (n < bytes) {
+		size_t len = min(bytes - n, PAGE_SIZE - offset);
+		size_t done;
+		void *kaddr;
+
+		kaddr = kmap_local_page(page);
+		done = _copy_to_iter(kaddr + offset, len, iter);
+		kunmap_local(kaddr);
+		n += done;
+		if (done < len)
+			break;
+		offset = 0;
+		page++;
+	}
+	return n;
+}
+
 /* Bytes one RCU read section copies at most: it holds up grace periods */
 #define FILEMAP_RCU_READ_MAX	SZ_512K
 
@@ -2944,10 +2995,9 @@ static bool filemap_read_rcu_batch(struct kiocb *iocb, struct iov_iter *iter,
 			break;
 
 		bytes = min_t(loff_t, isize - pos, iov_iter_count(iter));
-		bytes = min3(bytes, budget, PAGE_SIZE - offset);
-		/* Not _nofault(): its usercopy check reads the folio's order */
-		n = copy_page_to_iter(folio_page(folio, index - folio->index),
-				      offset, bytes, iter);
+		bytes = filemap_read_rcu_size(&xas, folio, index, offset,
+					      min(bytes, budget));
+		n = filemap_read_rcu_copy(folio, index, offset, bytes, iter);
 		*copied += n;
 		iocb->ki_pos += n;
 		budget -= n;
-- 
2.54.0


