Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7D60606A31A
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 02:57:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.alibaba.com header.i=@linux.alibaba.com header.a=rsa-sha256 header.s=default header.b=A4TATAUp
Received: by kanga.kvack.org (Postfix)
	id D64326B05B6; Sun, 25 Oct 2026 22:57:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D3BA06B05B7; Sun, 25 Oct 2026 22:57:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C78836B05B8; Sun, 25 Oct 2026 22:57:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1D1F6B05B6
	for <linux-mm@kvack.org>; Sun, 25 Oct 2026 22:57:40 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4A5FCA06A7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:57:38 +0000 (UTC)
X-FDA: 85363266996.25.EFFABE0
Received: from out30-113.freemail.mail.aliyun.com (out30-113.freemail.mail.aliyun.com [115.124.30.113])
	by imf15.hostedemail.com (Postfix) with ESMTP id A0797A0007
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 02:57:35 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A4TATAUp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792983456;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=NzJdTpJrDb5R72neOAFckZsEzGBQ8VMj8qau5faLwV4=;
	b=kmbxKQ7rlEd3SVsoT3T9R/PAl0DA61t2TPjZYpxnteEDaEKIJX/4XqQ+gjs9dnNCmBqixL
	ZI3vag8FtTyPVxVeSkZ9UOwsh7+0u6Zs8s6uObfB3tnrUtYui2DlttvOzPhapTf3tzW+32
	OM5aDn9gmzEcwaAxim6dF19GmPMNUKM=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=A4TATAUp;
	dmarc=pass (policy=none) header.from=linux.alibaba.com;
	spf=pass (imf15.hostedemail.com: domain of xiangzao@linux.alibaba.com designates 115.124.30.113 as permitted sender) smtp.mailfrom=xiangzao@linux.alibaba.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792983456;
	b=PttBKuxnk0GL4Rox/gFa80tUBd/dIFEXqZzXTF2bQnO+sjnAyGZBHGaRefXUeLGvYlJyGP
	LFKBX08JCt4UAYtt25LQuYbVPC93jSfuX2nX7moEsFrO5o7wtnJIeiWx29FRfsg9XCeWqo
	l/XF6eFQlUDQxSNu0k3RvFhzVGWsXxk=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1792983453; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=NzJdTpJrDb5R72neOAFckZsEzGBQ8VMj8qau5faLwV4=;
	b=A4TATAUpLx7wM35b9j7A15JDDeAOfpxrdKCNUtgnyJ+onSKyhoGmvlWiD4bWBDJEPuEENXl3lT3VDGAq0mkmClOZbzUdsTJO//B8pvzu+YGzVXqWFAfZiK0Q6q++IryiN6pnxpB7cEu9ZJ3alvDNWPR2j1pVW/fhwQOADXzH2h0=
X-Alimail-AntiSpam:AC=PASS;BC=-1|-1;BR=01201311R541e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=maildocker-contentspam033045098064;MF=xiangzao@linux.alibaba.com;NM=1;PH=DS;RN=21;SR=0;TI=SMTPD_---0XDRaNAX_1792983444;
Received: from banye.tbsite.net(mailfrom:xiangzao@linux.alibaba.com fp:SMTPD_---0XDRaNAX_1792983444 cluster:ay36)
          by smtp.aliyun-inc.com;
          Mon, 26 Oct 2026 10:57:32 +0800
From: Yuanhe Shu <xiangzao@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: "Huang, Ying" <ying.huang@linux.alibaba.com>,
	Kaitao Cheng <kaitao.cheng@linux.dev>,
	vbabka@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	nao.horiguchi@gmail.com,
	ziy@nvidia.com,
	wangkefeng.wang@huawei.com,
	tujinjiang@huawei.com,
	mgorman@techsingularity.net,
	chengkaitao@kylinos.cn,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xiangzao@linux.alibaba.com
Subject: [PATCH] mm/highmem: refuse to copy hwpoisoned folios in the !copy_mc fallbacks
Date: Mon, 26 Oct 2026 10:57:24 +0800
Message-ID: <20261026025724.1430747-1-xiangzao@linux.alibaba.com>
X-Mailer: git-send-email 2.43.7
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A0797A0007
X-Stat-Signature: k63mmy9ra56gahhyhrkf18xg1nxi5j93
X-Spam-Status: No, score=-26.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,UNPARSEABLE_RELAY,USER_AGENT_GIT,USER_IN_DEF_DKIM_WL
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1792983455-453016
X-HE-Meta: U2FsdGVkX1+sDbWZ9YiPLZM+AXs/v/Tp7btMwnZWLH7efY4dNSDok3579O3tcJXw1IhtqshXNEOrfTPfJ+BaQ0h96OABz6+9+lvBFwxMN/l1kb2I0S35UyK+2Ce5GESyCMJ1J9d7QwM4821/TleGdb2UcLFGfWiumz9UKk2yQLMIxtBVhtHqJii0vmsG0aNuAlloWwTwYX+7YTz5xPiom41VFV6EB8VT4MZPzfYmT4xS2XLYgmj7Po9k0EilLaY3nUafDYgd8DD5WxgOqtGcL5L1ZOiMokr7xNHpvSm7wzedThkpx07YSkCnMAvoWql7hsmlQtJvqZKcGDc91M0Ht6OhQ7RqGqgazFNCUIuzLbHa4F2EbjT9wQXZXFySp6V9BgxQxhu2eeqvQ661Vwm7vsDRv/GTzBVn5KVKCb2Xpsd1+F7wkjM1XuEFn+r7HmLN0wSacMslyRNOWduKAFm9msV8xc2OG1iYVKkF0IoQL2o1a40bAgkOzrlejWeUTi/2Ae28D5gv6mDQPwq1ush92lRW9HS87vwCxr3xZwJ82EiG9Yj3G2KtGomUEQ8VwaC9ZDcW/a/2VFzMrVu+db794Ln3Ko67IEHtY/fD1TAG4OoHtMHhglRIOnSeVcueEusaSOjJPHAid/1qOxzXvD7Q75pT7O4xGvw6VV9PhhmBZTRHCuQezGe4RDMwPs/ieAZRyJSuBJycCGrZVTV0y/A1ql0cdOR6pQYhfkUKOa7KpNnxUhm1Z+cRNTVSu632azN8hMJxeVFx+0bT3GfskTpoDI2Y8Uy0Viuypj7BzGTCrxYMH89Nq6S5xSHtFQMXh+eq15LkstpiaOL7/qLrZ6F1gl/ldt5aIDWPHgnd0wDeq+BKfSyV8lRx4GrTR7XzmySw5M0VlrK3hwqMJk1mjhM1b/Mq9ymucVtmxfB7vKK1CusslYQxeM8g8P1Jnj8UbwlQP6XGL63ZzT/bT8FW6Dv
 JEaI84Ca
 tLQMs8j8vaFp66jTlh18ynxUVr9Swx+RZCyBf/5kdBtP1DafeKZsHB1GsGddmRjnipXhuuFifJmiS9Mze3Olx5fcMNJJ3v1HeSc7lJ/bQ6oOWeJeZMo5G+OYLyVSEkE7YjHHkn3xQ5V0BZJcUX/8ukmM10UjaPjqLMo/pSFeB7goGQzlHxs/vkLkvWf1q28mPOZezWZMiHWxXfdDUsfZATJhLlap/UP4+GZTzHNsiUONTwGjitdDwAnPlriV+SRnCHmexNcYhJCMMWMpYoK/jeIvPaRrfA7gMSaQGD2phJ4mCADW8GDucFz+KJo6chNR4fVn6PmYn0DgBylk1EpiMJf9YAQk3ReSvR0GM3WCY6nkmKF0y5JnDLCCFcMBMIp1XRzC7UuXPMr72v7AoFUvLNj5BFO/qFxPXgGci0zLctfA02RLKmUo9lfM7Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Where copy_mc_to_kernel is defined, copy_mc_user_highpage() and
copy_mc_highpage() stop at a hardware error during the copy, report
the not-copied bytes and queue the source page for memory_failure().
The !copy_mc fallbacks return 0 after a plain copy instead.  With
PG_hwpoison set while the data stays readable - software-injected
poison (MADV_HWPOISON, the debugfs corrupt-pfn injector) or a
transient hardware error - there is no fault to recover from: the
copy completes, the destination folio carries no poison marker, and
the poison is consumed silently, the same poison consumption
commit 841a8bfcbad9 ("mm: prevent poison consumption when splitting
THP") refused to risk on the split path.

Check the source folio with folio_contain_hwpoisoned_page() in both
fallbacks and return PAGE_SIZE, the not-copied-bytes convention of
the real copy_mc paths, so the callers take their existing error
paths: the COW and fork paths fail with -EHWPOISON, KSM and
khugepaged abort, and folio_mc_copy() propagates to the migration
core, where this composes with the separate migration-side checks.
On archs with copy_mc this code does not compile.

The check runs after the copy: a check before it would leave open
the window between itself and the copy.  A flag set before or during
the copy is caught, whatever state the data is in.  A late software
injection cannot have corrupted the completed copy, and a synchronous
hardware error takes an arch without copy_mc down at the access; the
residue no flag check, before or after, can catch is corruption whose
hardware report lands after the last check.  Closing that would need
architecture support, as discussed.

The fallbacks do not queue memory_failure() on refusal: the flag is
already set, and memory failure either knows about the page or has
abandoned it.

Suggested-by: "Huang, Ying" <ying.huang@linux.alibaba.com>
Suggested-by: Kaitao Cheng <kaitao.cheng@linux.dev>
Assisted-by: LLM
Signed-off-by: Yuanhe Shu <xiangzao@linux.alibaba.com>
Link: https://lore.kernel.org/r/877bjowf9i.fsf@DESKTOP-5N7EMDA/
---
 include/linux/highmem.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/highmem.h b/include/linux/highmem.h
index d7aac9de1c8a..f90f0c6204a4 100644
--- a/include/linux/highmem.h
+++ b/include/linux/highmem.h
@@ -474,12 +474,21 @@ static inline int copy_mc_user_highpage(struct page *to, struct page *from,
 					unsigned long vaddr, struct vm_area_struct *vma)
 {
 	copy_user_highpage(to, from, vaddr, vma);
+	/*
+	 * The flag can be set while the copy runs, so check after it;
+	 * a flag landing later can no longer have corrupted this copy.
+	 */
+	if (folio_contain_hwpoisoned_page(page_folio(from)))
+		return PAGE_SIZE;
 	return 0;
 }
 
 static inline int copy_mc_highpage(struct page *to, struct page *from)
 {
 	copy_highpage(to, from);
+	/* Same reasoning as in copy_mc_user_highpage(). */
+	if (folio_contain_hwpoisoned_page(page_folio(from)))
+		return PAGE_SIZE;
 	return 0;
 }
 #endif
-- 
2.43.7


