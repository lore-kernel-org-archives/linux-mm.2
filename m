Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 821D0606A32C
	for <linux-mm@archiver.kernel.org>; Tue, 17 Nov 2026 01:50:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=HKFqPnH3
Received: by kanga.kvack.org (Postfix)
	id A60D86B00EF; Mon, 16 Nov 2026 20:50:38 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A11E36B05B0; Mon, 16 Nov 2026 20:50:38 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 900656B05B1; Mon, 16 Nov 2026 20:50:38 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7148A6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 20:50:38 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E4FC21C34A4
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:50:37 +0000 (UTC)
X-FDA: 85442931714.02.1D60677
Received: from mta0.migadu.com (out-101.mta0.migadu.com [91.218.175.101])
	by imf18.hostedemail.com (Postfix) with ESMTP id CFBF31C0002
	for <linux-mm@kvack.org>; Tue, 17 Nov 2026 01:50:35 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HKFqPnH3;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794880236;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=lmqG4T85wzH+EvkxPYNS8DJ2icFTQEKM/mrAvrY7aA8=;
	b=J19ZsCEP7RTAeFBqieqQ7vw5e+vJBGAu0i2r+oMvkXsfAAbe+v7CRU/GtUIk4ww6b10dSV
	F4ho21jpYgv5l62zDyvRuuA3PAv3mb4cCKaECWVQ59D2VAI1m1+Y4ofpe+LJ8aJGkTVYsL
	6ezHEk5A6BUiziEpg4JVFEVJ1wLj730=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794880236;
	b=S+2SaE307M9ctEwDDtk/mnAgvR2vWYGRw1do2cf5llHI9vh6c7cfna6H1WhESebbGthkyR
	4pCMk7HirBArs+Tm3ZFhyB4I0YfPYixFvfdCrwI1KhaRh+e8sZPdsupMZLLvC3+jUzzjyC
	cmDX0y0FqewhC9ocFKJDfRntvd59Ono=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=HKFqPnH3;
	spf=pass (imf18.hostedemail.com: domain of xu.xin@linux.dev designates 91.218.175.101 as permitted sender) smtp.mailfrom=xu.xin@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/IMAEuYJ6PcwjzqBNjJhlIuqxkqlOoUlO6uHl/vn3GI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794880234; v=1; x=1795485034;
 b=HKFqPnH3Qt/0v320IBWwEgPKA9soAOJhsAVhoLMQmtkvk17FUTPtOkR5lYEBLNN7p2H2SpCE
 9YsRqrzSULHZNuwLQv/zXcTMurvkULB4p17VsuZzF0b+uw3XnMIGeZ6V90N5BkwPXeM0OTQB2kG
 HHrNozmojexSFDW7sjJ0XLYo=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 472675b50f597a85;
	Tue, 17 Nov 2026 01:50:31 +0000
X-Mizu-Trace-ID: 472675b50f597a85
X-Migadu-Flow: FLOW_OUT
From: "Xu Xin (vivo)" <xu.xin@linux.dev>
To: David Hildenbrand <david@kernel.org>
Cc: chengming.zhou@linux.dev,
	ljs@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	xu.xin@linux.dev
Subject: [PATCH v4 0/2] mm/ksm: clean up scan_get_next_rmap_item() initialization
Date: Tue, 17 Nov 2026 09:50:09 +0800
Message-Id: <20261117015009.611551-1-xu.xin@linux.dev>
X-Mailer: git-send-email 2.34.1
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 59me9ja3n6qz9y8jtbrmhgen3bsxqexe
X-Rspam-User: 
X-Rspamd-Queue-Id: CFBF31C0002
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1794880235-45282
X-HE-Meta: U2FsdGVkX1+ddWvlgQ8GyRYAG8WOkr2l6jzXxo9AnauY7SVay0EeFZ/nL8g975sdIMlb7tQ0QE7aMSmYyGTPu0GnfgwOpxehY9L0QSMA1kKIv6Wqmzg1Lvn9UMISEOswsePKMVtJKHMEuyS6fqUtTm7bT5qbdTdxrQEWrqEmGzYRMsO9A9THk7BbrcQ27AXe4CtMVZOZrBX1WRDvbeqjLooCodTdVgmwOGETtuaQIq7+7/w2buWe8VF4ygBWyPDeTSItSmO6yxHmFwpwOSkPt8yiSXbCJCdsnttS6lj2y7kQWs2rDglkiFj/iTlzYUYu2vCxee+j2yrzJ+GRFaWhANuxiIh2FpXv/n4ri8O+zpnMl3BRrFT9fu1RsA44W3owEL+90g1rQXODSM2BuGQh2kwGcnJrsudS+Vc8tRkMNGeY3HfZg5m4IE0BNhEm4H2klN3lEazBYk7DjtkgHw25DlEUBRe2XIqQvaCWqU+DKZhvdomuW3AeR8R1+bCQHzdlMKjQ3u/u7z6AOzyBXf9f7yOuEEvWR6CoKPWYWtiw0DZvSTP5eHtZZWAsmu6iQuAna/5zNgvmBQgMGTXYjgZsGVRWLEBMZkcqLiAVm2ggRGFp0O5bYgpGXQQOXEsTlgRz33euPryPauj3t8ZhnRcG4z8c/57B9wfvOtLsZFUe0NATNL6dyU4J7sSxwE7wVapjybuVabzgtAbTBIqjP4KrdkmcPihcILTtS+m1L0Q7Ll/BV1aSpAozx7le75JIT84p1I8h5vWWuD9wLWn3G3u9ihpijlITcGc9GXMwpdeYoB73Pj2LgCwXMknXWfdqARLA70AlOfTsLp6VpJMG9SNxYJZdqM2r4q9uemS1In7Sw5sBnV53Agor2fCGW77uFVXLDVwO+7Sp96rDsEKpTZHUNNIuldcTe7IprcdI7VA7BkgnHO49P6oIQo/OYYJif0ThFUMyDLhINF8poP1TfdD
 8GtIWIEn
 fR+sVxqIYcXV71a74dZkqcT155mTIkUHdlEwas88hpntbGxfQc3KXryTZ8JozT/qW1QSe8lRwS22eYThgeV3D6WVPF8BWOH1rzpDDsZRAgiK4X/oANU53IslH55LmIW/eY3qAznUkUiKTHP/zPojiw4qg3ho6lGZoecrh7X0XlreqG8zlJbkNvl4amqtCbcn+FcyM0TE0wDE0JVeHMwfQMliMFeBssYaafccGARWopP5c2BHlLuQyE3rsQfG++79lHJd/SD9td3c07T8wyzH5oFkKWg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Currently, scan_get_next_rmap_item() has grown quite large and complex.
When introducing new features, such as the only-merge-zero-page mode we
are currently working on, we don't want to add more complexity to it
and don't want to touch rmap_item structures to avoid unnecessary overhead,
so we need to extract some common logic.

With these changes, the entry of scan_get_next_rmap_item() becomes much
cleaner and easier to follow, instead of being cluttered with unrelated
boilerplate such as stale stable_node pruning and cycle initialization.

Let's start by cleaning up these two parts at the beginning (where I think
abstraction is necessary), and we can continue cleaning up further if
needed later.

Changes in v4:
- [PATCH 2/2] Drop redundant comment in scan_should_start_new_cycle() and
  update the comment in scan_get_first_mm() to refer to
  scan_get_next_rmap_item()'s list_empty() check (Lorenzo).
- [PATCH 2/2] Add Reviewed-by tags.

Changes in v3:
- [PATCH 2/2] Initialize mm_slot = ksm_scan.mm_slot in the else branch when
              continuing the current scan cycle, fixing an uninitialized
              variable warning/bug (kernel test robot).
- [PATCH 2/2] Drop Lorenzo's Reviewed-by tag due to the v2 bug fix.

Changes in v2:
- [PATCH 2/2] Rename scan_begin_new_cycle() to scan_should_start_new_cycle
              and keep it simple (David).
- [PATCH 2/2] Keep lru_add_drain_all() in scan_get_next_rmap_item (David).
- [PATCH 2/2] Use scoped_guard(spinlock, &ksm_mmlist_lock) in
              scan_get_first_mm() (Lorenzo).

Xu Xin (vivo) (2):
  mm/ksm: extract helper functions for scan cycle cleanup
  mm/ksm: add initialization helpers for scan_get_next_rmap_item()

 mm/ksm.c | 101 +++++++++++++++++++++++++++++++++++--------------------
 1 file changed, 65 insertions(+), 36 deletions(-)

-- 
2.34.1


