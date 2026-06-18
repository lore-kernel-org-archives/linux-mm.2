Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 074F9CD98F3
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 13:11:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CA8BC6B0093; Thu, 18 Jun 2026 09:11:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C5A396B0095; Thu, 18 Jun 2026 09:11:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B704C6B0096; Thu, 18 Jun 2026 09:11:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8F40C6B0093
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 09:11:09 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E21801A078A
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:17 +0000 (UTC)
X-FDA: 84893054274.17.3D7E8C3
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2152720019
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 13:05:15 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wk5cJwep;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781787916;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZVVVTITUcrw54iAGavqU8F/yKQPskyiHrFhdNlaRoRA=;
	b=uVYxU9QUEFrOFnnM5tZwqTiIcqLdYKlrgkCLR6q5VzgW0nKoYQ7n+kZXi3OjqeQ3S1BA+0
	+n/f3pjM3sfN02GVYbn2FF8GrNFvGQtGVl7Jikf8lloBVo+wyTPjrBfakHiuRWNFoCAeFo
	8WtnQKabzm4ei7Y1j+ymI6dH8+2mb10=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Wk5cJwep;
	spf=pass (imf13.hostedemail.com: domain of kaitao.cheng@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=kaitao.cheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781787916;
	b=EsqkZAkLcBiGjGouPlKK2H+xlGOeZmslQCm/p3pDr4rlPY3Ghqh8t87Wbi+ClEGFrWType
	wqH2NSvfyt3jYSF9ywLZK252fdX6brob4RmHDauI0K1TaYR+sGMWyeDrbKYY3LHMBpNMEF
	89oL1AXMS2SBpH59KYVLXh4Wp+98xTs=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781787914;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ZVVVTITUcrw54iAGavqU8F/yKQPskyiHrFhdNlaRoRA=;
	b=Wk5cJwepVaWclDc134tmdLNIIt95s41cWvJrYH6zIy4ys2oeHlyZ7+w0NB9b0cAJ8AcELU
	eUnaOoxjpQTxU1qv/GWWlREw+idktXOppM9MTvbCEogXjBhuP2S80k+/hF2h+PTpaQjRjg
	gaB7eoLWfGLzW9e19m5+4svhARRIjms=
From: Kaitao Cheng <kaitao.cheng@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Pedro Falcato <pfalcato@suse.de>,
	Michal Hocko <mhocko@suse.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Kaitao Cheng <chengkaitao@kylinos.cn>
Subject: [PATCH v4 3/4] mm/percpu: Make cached pages lookup explicit
Date: Thu, 18 Jun 2026 21:04:13 +0800
Message-ID: <20260618130414.96383-4-kaitao.cheng@linux.dev>
In-Reply-To: <20260618130414.96383-1-kaitao.cheng@linux.dev>
References: <20260618130414.96383-1-kaitao.cheng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 2152720019
X-Stat-Signature: 3psmka3h8frim7ddmjwygurnyhsmge36
X-Rspam-User: 
X-HE-Tag: 1781787915-875964
X-HE-Meta: U2FsdGVkX18NIAdU7WbBoY1cOX8UC3OY07/7DflprGvwOkuu3U175pj0rD0KlvJKNhN/dmDkTdfQvh2YVCHBQQhO3DqBimlAaCdWLMAmavRVHwaK91QjBCRV0X733Op0B0vmznwJaHYqXtzyizmT39qFCWNNuLQqF/HIAQ1fgJ1eMDAoxhbPmoqt0TLzyGVuWcdDm5F/0jF+7Xf84O5j/epCUym+7lWBaJY1J0Urr5n7j9jiJLwI+N2l9cM1deeTuqX9yrKPVUdOROkliBWTFchZtAvVMrv7dJBz1ZwJEdHPLx2ieT/29jsniVgoqpTyjUvF7cBbtA3asgZvyJNNmBhamymY6IYzP06MkCijzZF1O9+Iw8fc84HTpUvcwtC1MFLg/7d8sXdU6Rle7S7pIEHCerXL5ekNLwCEmqXTlL63BTRAV9jys0inOPBHjsthY5p/0f5rr0XRICYPyAvxKG+Jxjy1aKe6gQEfF9yhs6aa0jFSyQQm1nApGsgyBb51Wt5yMhAAZcmxrYadr0it4AlXJOhnrQpoM2nRRR6Mii4ZI8W+6EDEC9s3G0CwX8Lq1cEYMiTs8GR9qkstCvRUswnXSxhhTNjGYkiWqOwq/jfvXC1kqhlDFJ8/hF98Fvbq3qjO1NJdyugdDLdNRoMEoCCIOa6hzGzBvxV565tO8+c3jTbds0XmmSua/qxEsCi+R7tAF9oG5mSG7cY0iN0tgrYssHR5B9vyBgOjIAhpACKtYXy6lyHA91tF390RRkmJa/Z79/U1/KqpX6o/5cf1EfqQ7W0uyDQ/KkKKxlBr5IzDf+mBhruYU9lI/iMpkkeQM2nbTnrHgMHICJLQF12/ufAaKJhSjkNMehlmbS+ZnnfuQXX7ryXr0V7kVE8vOTef6QU2R0151oIspyj7I/l9Ow62BNU3hlL8QgzV8NcFkw7EZuxjLiLJ1vCbv9gbsrG90hagLqwzeuaPrA2Z9sd
 51H3ceyO
 ymGo3kK4E+b7cJyAVkKg97kM4nU3wXgzV/J/XwqMF2O/kTAO4nWazMgSG+VVqk21Tyyf7WTFXKf7OHw0OpBaqcVxeCBTw8HQhRIuS4p57nk/j2YuulMkh8MZs05GPThIUZzq2PVSvDDTJNa68dX10R654y110cRs4cHYhBPD4xp48kl3fnf5JI0dY3L5UD91izDvN02GHWobKGMsXPCm+6CRg8aOEzTEefN1h
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kaitao Cheng <chengkaitao@kylinos.cn>

pcpu_depopulate_chunk() only needs the temporary pages array that was
already allocated by an earlier successful population attempt. Passing
GFP_KERNEL to pcpu_get_pages() in this path is misleading because the
depopulation path is not expected to allocate the array.

Teach pcpu_get_pages() to treat a zero gfp mask as a cached-only lookup
and add pcpu_get_pages_cached() for that use case. This keeps allocation
on the populate path tied to the caller supplied GFP mask while making
the depopulate path's dependency on the cached array explicit.

Suggested-by: Dennis Zhou <dennis@kernel.org>
Signed-off-by: Kaitao Cheng <chengkaitao@kylinos.cn>
---
 mm/percpu-vm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/mm/percpu-vm.c b/mm/percpu-vm.c
index ccd03cc152d4..7ed216192fc0 100644
--- a/mm/percpu-vm.c
+++ b/mm/percpu-vm.c
@@ -21,7 +21,8 @@ static struct page *pcpu_chunk_page(struct pcpu_chunk *chunk,
 
 /**
  * pcpu_get_pages - get temp pages array
- * @gfp: allocation flags passed to the underlying allocator
+ * @gfp: allocation flags passed to the underlying allocator, 0 to only
+ *	 return the cached array
  *
  * Returns pointer to array of pointers to struct page which can be indexed
  * with pcpu_page_idx().  Note that there is only one array and accesses
@@ -37,11 +38,16 @@ static struct page **pcpu_get_pages(gfp_t gfp)
 
 	lockdep_assert_held(&pcpu_alloc_mutex);
 
-	if (!pages)
+	if (!pages && gfp)
 		pages = pcpu_mem_zalloc(pages_size, gfp);
 	return pages;
 }
 
+static struct page **pcpu_get_pages_cached(void)
+{
+	return pcpu_get_pages(0);
+}
+
 /**
  * pcpu_free_pages - free pages which were allocated for @chunk
  * @chunk: chunk pages were allocated for
@@ -333,7 +339,7 @@ static void pcpu_depopulate_chunk(struct pcpu_chunk *chunk,
 	 * successful population attempt so the temp pages array must
 	 * be available now.
 	 */
-	pages = pcpu_get_pages(GFP_KERNEL);
+	pages = pcpu_get_pages_cached();
 	BUG_ON(!pages);
 
 	/* unmap and free */
-- 
2.50.1 (Apple Git-155)


