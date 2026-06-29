Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68918C43327
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 15:04:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62A616B0131; Mon, 29 Jun 2026 11:04:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 601E86B0132; Mon, 29 Jun 2026 11:04:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5188B6B0133; Mon, 29 Jun 2026 11:04:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A4566B0131
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 11:04:32 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 6AA7AA0198
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:32 +0000 (UTC)
X-FDA: 84933271584.07.1D1CDF8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id C0F7180009
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 15:04:30 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDdHoGFh;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782745470;
	b=LOiTfsfjj0KwlC+CdkhzNwe6csIVdfh10Ih/dEHku8n9Dgc+MJy6EAOJ2fqIzIcFgfC9q8
	EnEELtPdZEvEwNc56Aj0rWS6G1pMDTlHzuBAGoi9JaIi0hT9tztt0mBeUYETNNq60zMWmh
	GLVKDnnyulqykSsmowo6T5GI7Jn0MKc=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782745470;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nA2C3XBTN1q0WcJk6ELo4naB4k1FNURRRYd8Aaer7J4=;
	b=SmepU80ofIONMsOfUj+2s5VhwD6g+JGgUYCehOWbhqVDYowjN1kbIXuUs6mUtJcaag+AcX
	Ug6NhzqoSyuXt92RQFIqFpH15cm79NkixFBCHNmMUVJSyKPhFkYHuijBKeMUWzM6Wl+4hU
	96xGVCav/oMR/JHVPWrhoSgqWy2ORvg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=aDdHoGFh;
	spf=pass (imf02.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 5D779601C3;
	Mon, 29 Jun 2026 15:04:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 447B01F00A3D;
	Mon, 29 Jun 2026 15:04:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782745470;
	bh=nA2C3XBTN1q0WcJk6ELo4naB4k1FNURRRYd8Aaer7J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aDdHoGFhbHBHr9Wo2nZbV+UXVCXPYo+/kr/CvVZZvKtagVRqkoFHd0CJmm1V4rkVj
	 ABBHKI3OCUZWK8YPsNmTFfaxkGTbnrpQO4HPI5WM9D02JzkwwYwms1yiRb5bW8wTC3
	 brFIAueYWhP0KB56B7ETbMcWd8XVHuhjcOc/PbV7ol1U8ogSL78VtSlVAAf7arIxux
	 9wB1+OTFwTiAB0Mri28H7PA2z76FQYL8d4zmGSBrMLF1uYAILp/uvBJWaCtgtkzj3R
	 aqcA8RiQ4+xzFKXeaHcxvcqPXjc/eW0CvFAyKxsw4SeXf57PlE9v3XbHQHmSWkCDDM
	 8WfSrSn2Usi3A==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Matthew Wilcox <willy@infradead.org>,
	Jan Kara <jack@suse.cz>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Xu Xin <xu.xin16@zte.com.cn>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Matthew Brost <matthew.brost@intel.com>,
	Joshua Hahn <joshua.hahnjy@gmail.com>,
	Rakie Kim <rakie.kim@sk.com>,
	Byungchul Park <byungchul@sk.com>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Kees Cook <kees@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org
Subject: [RFC PATCH 10/10] tools/testing/vma: expand VMA merge tests to assert virt pgoff
Date: Mon, 29 Jun 2026 16:03:50 +0100
Message-ID: <4a9091aed50a851deac9947523ee8a08f4183113.1782745153.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782745153.git.ljs@kernel.org>
References: <cover.1782745153.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: C0F7180009
X-Stat-Signature: xyyxbn8kd167g9ghw3j7u5cm7qafrkib
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-HE-Tag: 1782745470-584825
X-HE-Meta: U2FsdGVkX1+f7BCl1OJDlPRezxjbkbSXtrb9gwdQSDRi8LQMWw5MwFXT/a6UBKrIv+WxnOSRTAUqxqZRRQJjkAxnB0vZoqzGyZXJosISkbhrT/0EoR6HjTmY+Lm+3sWvuOxOxFPJZb6xztbZ4lkj8XJ1GwNSKGM38U2pWvN4Z3JpNzBfBccuTKgEIlm8IWQV0d7UK9bdRZkSzmfk1snh6roY6mMcCuV1gv3OWsm4q5Bf2QXxuEJtGoVOhigwEpScGuL7V066jvGyZBR0+E8GB5WZxXIqvVoXUoil+ibfzlz1nbYu+tRXj+HMM/qJ5CPMElrIzHBJSnovewDYorkiQmEX/TDYjiZ/9bU8bqIV0IeBAmUcJbzkLSRae6NWv4P/59EQ9okZys2ONq2lhgouf9NPMC/rzGL75cR0HuiOseWUQW1/+Drb9jg5PIVoemYS1ayTzGz8vJRJBn2g+Y2frNCClv/MxWm5lQRgprQzAVUIdoqzA30GmdiNBDVX2lxJbaKcQkj2IHpNMO4BlQ3TePIWBl12A6+0ag0Rq/eI+NM25a+qSrFKLcc3lK0hGRMtmb2oSQTbFfIuNqdoMd5Db2IGKSjFsHRJ+XXX+Wi6uY0o+7ELbChNVKgTtMV3KwYr597MRyICYaePv25uHgvDNwxefefeJSo8N/tqRqxrTfdVnCsnzIQpX62iE2HOMH79D49ykAhcUQrh9QqPtdXXnS0PumLtmEnL5x9S9TDh1VcqcS45Pp1wi5Zhw46+3GxpDHD3cE6bZOm84zC9rrlQ1fpDy8zUpa6YSP90lE4fYsPzmO0l8hD+xoxO6Ms1WB/f84tH/rmZN6DQFaOsDOILFv0adR3N8s7OXk5pRezpHlYze2NJDHXB6N9VHcuurQaGmwI8Rqzp0V+98Zs7yXUtHKwMpgUkFVIAC0NqjM+hiY3w94apnPJWhwOGjbDSoUUYAwiuHe4aTGzpuSrPH/+
 ZwLeGCCY
 VzRd6YYwHN7A4putijtC7bhWVSuPxkGGBnl0WisKomF6aFshQ2SEd/oWcNY6wkwZMj+iNpmm8sa0pPm+utgMUmwI9Zt1HkW3L4S0R2lxtealY84exEcMpxx3v8zP4OIB1wxPuaZAvQLFCzi5U2lOOJwoBkTw0k+cU7kbmrwq0HKXbNadu1/CkSqfelySW+Cq2N42QC+EP0cXCu3/CsfgI5OPyhJNtW/C/rWyuknGWo0FjuCxqSxYca4DYKgI5wpkq4r47HXx4U3fUjf1/RhfkqPDav64Zdf+Ukl6ZjPNUqaQM8oir0S6qxdk4wg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Now we have introduced the VMA virtual page offset attribute and update it
when VMAs are manipulated, update VMA merge tests to assert that the
virtual page offset is as expected.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 tools/testing/vma/tests/merge.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/tools/testing/vma/tests/merge.c b/tools/testing/vma/tests/merge.c
index ed8fa0d7da97..ca415052fd8c 100644
--- a/tools/testing/vma/tests/merge.c
+++ b/tools/testing/vma/tests/merge.c
@@ -121,6 +121,7 @@ static bool test_simple_merge(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_FLAGS_SAME_MASK(&vma->flags, vma_flags);
 
 	detach_free_vma(vma);
@@ -153,6 +154,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 1);
 
 	/*
 	 * Now walk through the three split VMAs and make sure they are as
@@ -165,6 +167,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -174,6 +177,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x1000);
 	ASSERT_EQ(vma->vm_end, 0x2000);
 	ASSERT_EQ(vma_start_pgoff(vma), 1);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 1);
 
 	detach_free_vma(vma);
 	vma_iter_clear(&vmi);
@@ -183,6 +187,7 @@ static bool test_simple_modify(void)
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -212,6 +217,7 @@ static bool test_simple_expand(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -234,6 +240,7 @@ static bool test_simple_shrink(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x1000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 
 	detach_free_vma(vma);
 	mtree_destroy(&mm.mm_mt);
@@ -346,6 +353,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -367,6 +375,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 3);
@@ -387,6 +396,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -407,6 +417,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0xa000);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0xa);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0xa);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -426,6 +437,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0xc000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
@@ -446,6 +458,7 @@ static bool __test_merge_new(bool is_sticky, bool a_is_sticky, bool b_is_sticky,
 		ASSERT_EQ(vma->vm_start, 0);
 		ASSERT_EQ(vma->vm_end, 0xc000);
 		ASSERT_EQ(vma_start_pgoff(vma), 0);
+		ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 		ASSERT_EQ(vma->anon_vma, &dummy_anon_vma);
 
 		detach_free_vma(vma);
@@ -808,6 +821,7 @@ static bool test_vma_merge_new_with_close(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x5000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_EQ(vma->vm_ops, &vm_ops);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -868,6 +882,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma->vm_start, 0x2000);
 	ASSERT_EQ(vma->vm_end, 0x3000);
 	ASSERT_EQ(vma_start_pgoff(vma), 2);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 2);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_TRUE(vma_write_started(vma_next));
 	ASSERT_EQ(mm.map_count, 2);
@@ -934,6 +949,7 @@ static bool __test_merge_existing(bool prev_is_sticky, bool middle_is_sticky, bo
 	ASSERT_EQ(vma->vm_start, 0x6000);
 	ASSERT_EQ(vma->vm_end, 0x7000);
 	ASSERT_EQ(vma_start_pgoff(vma), 6);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 6);
 	ASSERT_TRUE(vma_write_started(vma_prev));
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 2);
@@ -1419,6 +1435,7 @@ static bool test_merge_extend(void)
 	ASSERT_EQ(vma->vm_start, 0);
 	ASSERT_EQ(vma->vm_end, 0x4000);
 	ASSERT_EQ(vma_start_pgoff(vma), 0);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 0);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(mm.map_count, 1);
 
@@ -1459,6 +1476,7 @@ static bool test_expand_only_mode(void)
 	ASSERT_EQ(vma->vm_start, 0x3000);
 	ASSERT_EQ(vma->vm_end, 0x9000);
 	ASSERT_EQ(vma_start_pgoff(vma), 3);
+	ASSERT_EQ(vma_start_virt_pgoff(vma), 3);
 	ASSERT_TRUE(vma_write_started(vma));
 	ASSERT_EQ(vma_iter_addr(&vmi), 0x3000);
 	vma_assert_attached(vma);
-- 
2.54.0


