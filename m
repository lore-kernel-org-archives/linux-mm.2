Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CFD31E99050
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 07:48:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 028266B0005; Fri, 10 Apr 2026 03:48:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F1AE46B0089; Fri, 10 Apr 2026 03:48:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E30E66B008A; Fri, 10 Apr 2026 03:48:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id D41D86B0005
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 03:48:09 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 63001140395
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:48:09 +0000 (UTC)
X-FDA: 84641867898.23.080EAE5
Received: from out-177.mta1.migadu.com (out-177.mta1.migadu.com [95.215.58.177])
	by imf06.hostedemail.com (Postfix) with ESMTP id 9E5D618000B
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 07:48:07 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C2ZunkQo;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775807287; a=rsa-sha256;
	cv=none;
	b=4XLIMpctOVYhT1HyPcDMPnUFSxbM8wlHVtSlhsFI0mXI+MNawRhxDtd5iRxlT0DugPUgJ4
	e4PqZrrCT/wvmikDVW3BKenrps2J8/PZ7LFncKQkTpYtKMTmPUEX46vHaeVQZnTZ62ardT
	lrFTlYJbB+/xuDNmAsS1G+fxaRuO0Ac=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775807287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=WC8eCV2YU0a/Btl0h9VwHxSJjNwhOj9OGiJNlsIPKRE=;
	b=eT7iRAQolIiZ97tMM0LJP31L9kTT/4WlqhAjggxWQny5hDXr+dTYOzqIeWyyKp8NtKYo8r
	RWcF3+Gmo88ARoZceso1deRLXzp0/6opt49smqNZ1l+5xvs8sqqSPtwXhQiWkDESZYE8Hx
	bXw/Kv6V00xwUNTUQIw/xL2xWiNdT6Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=C2ZunkQo;
	spf=pass (imf06.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.177 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1775807285;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=WC8eCV2YU0a/Btl0h9VwHxSJjNwhOj9OGiJNlsIPKRE=;
	b=C2ZunkQonuomU55CCVjVDMdPzVj/2Fb13IcWF86sfoKr9ghOJxDDMUQj+3yk4KRIUbIQ8J
	0we1pp0OGQ3RtgjpYGAdTfFlaMkR1aRSa3GG5lATZtu3yHQSU8lhvG+P/iN+vOJSaD99vc
	NAEK+cPVRZdsnE1bsCM9bLPg3a4QD2g=
From: Ye Liu <ye.liu@linux.dev>
To: Miaohe Lin <linmiaohe@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Ye Liu <liuye@kylinos.cn>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2] mm/memory-failure: use bool for forcekill state
Date: Fri, 10 Apr 2026 15:47:39 +0800
Message-ID: <20260410074740.2524718-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 9E5D618000B
X-Stat-Signature: khu6h4m3qu8ygd3w1mi1cys9eb95oak7
X-HE-Tag: 1775807287-305498
X-HE-Meta: U2FsdGVkX18mfSvZ2a9aW1VdK5rINxe4Y3frb/cjLT3wRwx82KHM3sy9eMEAb9E6EOHvTWvIJ4E9qiZfu8p+t9/wv8ypcYNW2g7XHQbujjjCga0hvLCHsnZqCll5UJNmwNBi7PRtb8uonG/vU8/GESz5xc0eqalDnWdAnSlINoxb29uQgKk56fg/9LYcRJytriSRJBtwWq/uSIMBwuTnd3BhEhZNEq9r01o5/ymKhzQHJaoT3CyveEKlUQShH8KIpdZQTCu66usTbRcGaBOfxmxIonJEtwMTfHORvceKVPV8KGZnCbRIwJjHRUT5FSTOiTXwUAEh5ZaFC+mXRI5B5VH0coYeKgENuqGGJ5X5+hN8IVntYNrSKdOlQl+3afupSoIi+ks/Ak/ZJtRlnbVHoj/S13kGpu7RRre8+V/x8+Rdx83Ikpx+24jOfOkpb3gT8xI1vAfYi1SFu9lYxH3m4m1/4Qp9q9Kdh2u/b6ZuZVoUkOJrms4pWTlb31cWbVKMNSCs/5vIUvyWkDj2odCB1PwoRxtV6/OVVom2UYeINMS+NldNtz8EUuIwkt8tXWNtvngQZu8RSz4ZB2qGbvORqPAXc3Bhe+S16C2HIbn6OYNNoqdKr/pAjn1KTDvLOLq8Zf5xaQsiGeECT3tiISBuEaADZGsn5Rgop7GGYYYNfH4SbBe/qgJcj75gELaRGmhF5+Twq+TcE9U7Ati9nRuMsIEpHAY1NPj3HwPp7Y31vtLKP7aauegDp8sNLvQlQJZGf7hdFjtGRdcc4F29j/T2eszwM1DkxJ/ST95MCoPL5JxrvEt/OwDDNXKY35JEHC0jaCraK29271bwyGifDZ0Uw4dV8rkNIttyC5p2HlfHYK8sIb9+gjlugbgqmF+0omNi6AT/vSDvlHMDIDBxLtXC7A0sTPVgMIoCSkOek7N808xkmQfJLi85cH/9rTQA++6J372XsV0kKMu5p7HXtub
 7PIZroFS
 ZV7kgvQty2EcANRjgA9VQfxfa5Yu6Ex5hnOVk/8O4DIk7PMKRplxIrFACTw6a/k1c3WYd5ahj0CupKUcIE5j4tn1NwW0xHc6bmGhpJv1AJpLyjhQUMWK+WxFVgn48e2kynOXyERPLibJv6O1z8A0rnc6HhlOJ/uh9zMCrnURqhGLXrzy6GfPtIn+0e0cUxVuqBvgVljh9jZA3DfWRbCvpqR4Pc6IlUDj8AdkqJHd4xxDonbxp5sLozWN8tcdW/HudS9zy6GaTgDnQqbkJGWEOjUo4SHN3qql1faeK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Ye Liu <liuye@kylinos.cn>

'forcekill' is used as a boolean flag to control whether
processes should be forcibly killed. It is only assigned
from boolean expressions and never used in arithmetic or
bitmask operations.

Convert it from int to bool.

No functional change intended.

Signed-off-by: Ye Liu <liuye@kylinos.cn>
---
Changes in v2:
- Explicitly boolify the MF_MUST_KILL flag test at the kill_procs()
  call site
- Link to v1:https://lore.kernel.org/all/20260407020715.2269255-3-ye.liu@linux.dev/
 mm/memory-failure.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/memory-failure.c b/mm/memory-failure.c
index d25adb390c3e..3babddadff04 100644
--- a/mm/memory-failure.c
+++ b/mm/memory-failure.c
@@ -459,7 +459,7 @@ void add_to_kill_ksm(struct task_struct *tsk, const struct page *p,
  * Only do anything when FORCEKILL is set, otherwise just free the
  * list (this is used for clean pages which do not need killing)
  */
-static void kill_procs(struct list_head *to_kill, int forcekill,
+static void kill_procs(struct list_head *to_kill, bool forcekill,
 		unsigned long pfn, int flags)
 {
 	struct to_kill *tk, *next;
@@ -1582,7 +1582,7 @@ static bool hwpoison_user_mappings(struct folio *folio, struct page *p,
 {
 	LIST_HEAD(tokill);
 	bool unmap_success;
-	int forcekill;
+	bool forcekill;
 	bool mlocked = folio_test_mlocked(folio);
 
 	/*
@@ -1703,7 +1703,7 @@ static void unmap_and_kill(struct list_head *to_kill, unsigned long pfn,
 		unmap_mapping_range(mapping, start, size, 0);
 	}
 
-	kill_procs(to_kill, flags & MF_MUST_KILL, pfn, flags);
+	kill_procs(to_kill, !!(flags & MF_MUST_KILL), pfn, flags);
 }
 
 /*
-- 
2.43.0


