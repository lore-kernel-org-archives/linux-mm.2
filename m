Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0A08EC1133
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 01:56:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 688486B0089; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 633246B008C; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AD1D6B0093; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2A96F6B0089
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 20:56:34 -0500 (EST)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A4DB758CA9
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:33 +0000 (UTC)
X-FDA: 84477685866.23.B5A1D7A
Received: from out30-131.freemail.mail.aliyun.com (out30-131.freemail.mail.aliyun.com [115.124.30.131])
	by imf14.hostedemail.com (Postfix) with ESMTP id 6E338100002
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 01:56:31 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nqMyR9g2;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771898192; a=rsa-sha256;
	cv=none;
	b=z9GtDYhS4AeQhbpx13uNiM+txeD0GBGSU+pLvGGsUecEwO9i02Ljm19KhiXRh0oCqcQaH7
	DYG5u+Oza7+E8gPwi0vLMmspGtbFJ79D61QQ+tZ5i02CqRRhZb+AayOvh9L1om/J03dKCk
	Jp0uzHB4Fdkw2ALxXMANzX7mZIMLC6U=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux.alibaba.com header.s=default header.b=nqMyR9g2;
	spf=pass (imf14.hostedemail.com: domain of baolin.wang@linux.alibaba.com designates 115.124.30.131 as permitted sender) smtp.mailfrom=baolin.wang@linux.alibaba.com;
	dmarc=pass (policy=none) header.from=linux.alibaba.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771898192;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5kr4nT2BT8PGK/D1Q43aMJ3TWsyAUzb25RqrNR5DsqQ=;
	b=ouMc7JgqJ9VaC+vGIBUh4AARSAfCCPMrGAt1sLU1eUKXMUKmRMHa+pj9JDjwtW5M+/NAs9
	rZZ7/6NSJIBiBcsdkKSeSYvGW7Od2PV7dpqmWfFeTpZ+W5fhNMf9D6Ch27zlbtRBQTDeXE
	Kifc53uu3OGGv3j/IcTekQGJZNIyzbE=
DKIM-Signature:v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux.alibaba.com; s=default;
	t=1771898186; h=From:To:Subject:Date:Message-ID:MIME-Version;
	bh=5kr4nT2BT8PGK/D1Q43aMJ3TWsyAUzb25RqrNR5DsqQ=;
	b=nqMyR9g2+ZxnqKu0j6vojLAf4GhDwioR29jfqRoafJgaicLTmTBSHHH363E7W8OjNqZVAsq7H0v4JY9jeLVyy8LPAk11JooeQb3EqXezM4IM4LZarN42mkfYxxEr9nztde1uN3HXZNTQMseKW1K3e0+7LjP0cHeujjfFHsjmKJ4=
Received: from localhost(mailfrom:baolin.wang@linux.alibaba.com fp:SMTPD_---0WzhpS27_1771898184 cluster:ay36)
          by smtp.aliyun-inc.com;
          Tue, 24 Feb 2026 09:56:25 +0800
From: Baolin Wang <baolin.wang@linux.alibaba.com>
To: akpm@linux-foundation.org,
	david@kernel.org
Cc: catalin.marinas@arm.com,
	will@kernel.org,
	lorenzo.stoakes@oracle.com,
	ryan.roberts@arm.com,
	Liam.Howlett@oracle.com,
	vbabka@suse.cz,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	riel@surriel.com,
	harry.yoo@oracle.com,
	jannh@google.com,
	willy@infradead.org,
	baohua@kernel.org,
	dev.jain@arm.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	hannes@cmpxchg.org,
	zhengqi.arch@bytedance.com,
	shakeel.butt@linux.dev,
	baolin.wang@linux.alibaba.com,
	linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH 2/5] mm: rmap: add a ZONE_DEVICE folio warning in folio_referenced()
Date: Tue, 24 Feb 2026 09:56:05 +0800
Message-ID: <e91eaa86a6fbb0682b4e308082048c688a57c035.1771897150.git.baolin.wang@linux.alibaba.com>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
References: <cover.1771897150.git.baolin.wang@linux.alibaba.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6E338100002
X-Stat-Signature: 56b555tsj6ncro6hp7opxn3edpuen7fr
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771898191-834108
X-HE-Meta: U2FsdGVkX1+v6JquaknxmxsTGcwnSf9gOcKN4LrtNGbdzvEJXelfet4o18CPdlbagEHP4jPN2ULDG04Dj5r2mMcDRWuUgXBvf8Tv68Y1wbK1B7GBmiDgiYjArJ+6+jEPT5luxUYXifQAvd9pI+M8rGAmfQWhGf3Rjn1+CwuH56e34YVEUqsCoz2ilWF5q+ljRrh4my7ciECY5xG+VGyZ4ZoyUE/hFd8ObtMJ/FPcarvCHswfq9reB5Wq9vgnjrJpVfGOZP7kHTsMB087x6XCxOh/zuZP6WF4go+T4IHOSWiKyQnaWAHzVU+SlIcDXf0+6Xsfdw6KuqNWDGDFD+HLEoJG2FIA66qqVjj1+xLYCCMh/iOT+bdpRkKHTdlPUbKquKf85ryiox5whl0hFjhvRAhHqUL5kWSi9hL3sKdsPGITNSVXH/rXBUVQQZ2nPxoHMmwipJ/kFu9PlkyYbM4ZBhfAOswySYP6fXem5xbhmxIiTDrbtzPcQE+kNvZogd9L2FgFusq20X/d2vM7vvsjju1YXDIVIcLCXGeYVhMCi/0Wa331Q4dxGsd6W+RIdh3YqlvhyA6Z+fF5fICulLCYMgYLKL7COycUumdhYtUcQ6hIkaKH6QRL0RPRfZ0M9o4n+KKuFJOWuaJg15j2E85Mo1QtiBlkdqViNwZFdscrk3zzCgnlXGG4e24sZCHni44iJxallTcpLbXi2r0UnmJ3YywajYOIQOtKM2Qghha0TPsUqZiZAIPDlgBK6+XVbeQ3UvC6EP+2fy3yMXSw222ZSZaFA66cwxUkbXzJ+97jazxZnEZi5kJKTSGwQCsR+fVxcRkcvBif3uHOQObBfHUC7Vtz66YJo62clbWviOE7WOEsI2gkOGVDu+UWJIh6GCUa5fH7X9Zy1srK0WjCl59MhyH6E5lk2br5V8W4G5kgBCXtJnRHEfc5uKX+ysca6w5uU7AILPCphX6uT7pPhbP
 ChN/Sxfu
 P1V6SkOjC/xrzpKXoj5QZA8b8tThVHP8hxvL0su4krbenFtvAVXWZ5MaVmK5RkKvUcUOm8pgGO9l9YH95vyh4gr8KhKmeTWAKeoW0tX0QTIL6fE3xwdwpdEnDj9ZxLvB0YyZ9m1D74idIfZ4FkDb2km/+OzqRhzZucnEMR5rrzLAbAscfF3OaHOrBPSxuUUyFhDULnXRUNO5R15hYx2Afq7g4xuViaCsYhIhSSE3HJv5Z4tdjrPqJ6NrL5f8Rqw/BGJJs/vFQu/FflRbuh/B25gT5Spax63qb2ipGW57ZDKTadjPwgD0NC53YXUTqkZHVPkOmsDKewgs+QPflSK+kXUlq+w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The folio_referenced() is used to test whether a folio was referenced during
reclaim. Moreover, ZONE_DEVICE folios are controlled by their device driver,
have a lifetime tied to that driver, and are never placed on the LRU list.
That means we should never try to reclaim ZONE_DEVICE folios, so add a warning
to catch this unexpected behavior in folio_referenced() to avoid confusion,
as discussed in the previous thread[1].

[1] https://lore.kernel.org/all/16fb7985-ec0f-4b56-91e7-404c5114f899@kernel.org/
Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>
---
 mm/rmap.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/mm/rmap.c b/mm/rmap.c
index bff8f222004e..be785dfc9336 100644
--- a/mm/rmap.c
+++ b/mm/rmap.c
@@ -1065,6 +1065,7 @@ int folio_referenced(struct folio *folio, int is_locked,
 		.invalid_vma = invalid_folio_referenced_vma,
 	};
 
+	VM_WARN_ON_FOLIO(folio_is_zone_device(folio), folio);
 	*vm_flags = 0;
 	if (!pra.mapcount)
 		return 0;
-- 
2.47.3


