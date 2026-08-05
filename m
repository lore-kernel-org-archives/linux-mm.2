Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3036FC56201
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 11:03:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 37FE16B0092; Wed,  5 Aug 2026 07:03:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357FC6B0093; Wed,  5 Aug 2026 07:03:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 249F36B0095; Wed,  5 Aug 2026 07:03:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 033FF6B0092
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 07:03:39 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 7C1CAA0463
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:03:39 +0000 (UTC)
X-FDA: 85066930158.21.35A6E36
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf10.hostedemail.com (Postfix) with ESMTP id 67D5AC0013
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 11:03:37 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kL+KaXLl;
	spf=pass (imf10.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785927817;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=R4TrMHTQkzwP2lLEW0oUQVcx04oxAW8/FB2AgqPWE68=;
	b=shkkSv3ZtujZdjFcgUHQaY7FZaaigqRQ2NC8/6SjkmEw93aNDEA/++gmdcT2I0H3XdoNnF
	VSorEHFw6owG3F0TX9rOsY0CMOIlm/hAT2Qy6AdjsqkG+9LKRLzREi7Udh25Mvf2hpvs6z
	Ut0om2W5SbwxhanH4LNtPPHlnoCz+C8=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=kL+KaXLl;
	spf=pass (imf10.hostedemail.com: domain of hongfu.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hongfu.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785927817;
	b=oq3wYqhXxHc60D6fQoyCQp1Aoz/7fuPoCADfck+VWmIWYSToKT1gA6z0X+cgh2s7Wi+/OX
	fp5x4mkKZJcjSGUUMsnPmpsNJ1eJKo2W/5IjZBYVD5XhpCZJ7T4mZHCkMH3G82Hg5LOC21
	oMWEeM1zEwZ13qMrFakdeJ4Pl/8MbkU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785927815;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding;
	bh=R4TrMHTQkzwP2lLEW0oUQVcx04oxAW8/FB2AgqPWE68=;
	b=kL+KaXLlSRmxOZd41Q1d8l4/jqKr/ZYm47f8yzGu5BEqF2e7C/vKuZMbvHXlQuuRSPGY2M
	J1zxCBSaVEnGrZC13ujg9FxHZbJq54bTXDPFHy9chloV7JQhfuX3/rvWWiKpxzJr7tXl1y
	JzAC1N9VfGWtT+BtcVWNy9B6T7mYDaM=
From: Hongfu Li <hongfu.li@linux.dev>
To: akpm@linux-foundation.org,
	david@kernel.org,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	alexs@kernel.org,
	si.yanteng@linux.dev,
	dzm91@hust.edu.cn
Cc: linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	hongfu.li@linux.dev,
	Hongfu Li <lihongfu@kylinos.cn>
Subject: [PATCH] ksm: update comments and docs to reference folio->mapping
Date: Wed,  5 Aug 2026 18:59:07 +0800
Message-ID: <20260805105927.41987-1-hongfu.li@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: c8gyjegqbn16fw7zoqnkqu45mneqdweb
X-Rspamd-Queue-Id: 67D5AC0013
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1785927817-446293
X-HE-Meta: U2FsdGVkX1+uo2nFuJsbADtqAy6z9bk8nDdZeXPO92M8xRgMREFkDPrZJ/Q7rc+bnfBYHY1ZrdM1Ni0IxtXBuzYJtkti1mDobkZ0aa/F2hiuBLLZc7vuLZEjRNlZfWDhiaESV2mn9dpOJBvWosA28IrA2VnmpYjOUyPrVw4dtTxqQz+7slkFv8unOl9IlOwKS/1ugXBwdpzYntVf5oo+nND6VDfBwn4vLqpgoGenSBEjrU+vBfr0WznX2MkBaJTqmSCSu3szF0TvQDDxXHJDEUQJUjR1YIaX8LMP4KVsZKe6F0WwYwiNti3QpnVe8KycNsRQrHvvfY0ZVsB/HsRj9YXd9vzRSQdkhGEcz96CXsSGuh9hP1xQUkiv4lvvUY7sIxxyE5XXDQ4+YkleUIPIbWBdKlDHZ5Zf9LRrlb+ahNhSC8kHs0823U7xCIaKMA6FwMn5/8sgg2rvNqo1ioBceAHLNVqEyE1rX1r+J//WxkKk4LncFOk9sIPfC1deDPthF0r16jbh0r01V5XX7Tmt69qjfZHpB/jlwNQoiyQ/MosUSPs0APnnGxN5odAZMV5KqxBPa+veWE4kbzF6T12q7EhRfdaR3xLhfuTUnJkThJQ92liEkZXkUkcZHuB799WIENe7kCub3f9dmFLptJz6/0eH3QJBRtWaXy7NRuFD06LHH8S7/F6wWhqHEsnThaXaqpTkl9HUiMpkElIv+wYy8E5uimPhzvY++tsuun4Vdsl+yGLYj6su2BvG3sWGWjHwLb54t276eH5WMOrSRwvkxqxWgD0YCeslntu6F49sZaf07Z6B4HGbJCECIIZXnXELC0zpqFZ68AyeBQ1fAY83Vq+lZPQhM1KI9cU4qmnVpRAFGdBiAhcPzAFsX1UeqbenqcNrbylJlL4Ojmc+6IASMUCsu/ExmmrepSKFUrMfZyJcqlvUkFK55GUsMZcsEIhuHy1NNeIwv16Rj7hsX0y
 wZfeeUru
 9LS8uZ48IKbJNj3lj62k8uPlqUeTLQzolF1V5lwlHunYtUqDSA8vLBLgQg+24tmqwYKG/vyyOFaKoyUYj/bHbqqHVj6wQF7tJVtQZEk1FT0ix1ydGoIyROQW7T118B/BfxONcUg2ZuWIQ6QlTUs8LZ+gRcKTBgocnn9Qx1dTMzOgRQVLXupWVWsQ/wX2DFvmIq0UESoycz/i8+2YHF0M9MhY7xMMb5LF/s/kxEPikO5aL4eM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hongfu Li <lihongfu@kylinos.cn>

The KSM code already stores and checks the stable node key via
folio->mapping, but the comment in ksm_get_folio() and the reverse
mapping documentation in ksm.rst still refer to page->mapping.

This is a pure wording update to match the folio-based implementation.
No functional change is intended.

Signed-off-by: Hongfu Li <lihongfu@kylinos.cn>
---
 Documentation/mm/ksm.rst                    | 4 ++--
 Documentation/translations/zh_CN/mm/ksm.rst | 4 ++--
 mm/ksm.c                                    | 7 +++----
 3 files changed, 7 insertions(+), 8 deletions(-)

diff --git a/Documentation/mm/ksm.rst b/Documentation/mm/ksm.rst
index 2806e3e4a10e..2b4f72f1f953 100644
--- a/Documentation/mm/ksm.rst
+++ b/Documentation/mm/ksm.rst
@@ -24,13 +24,13 @@ tree.
 
 If a KSM page is shared between less than ``max_page_sharing`` VMAs,
 the node of the stable tree that represents such KSM page points to a
-list of struct ksm_rmap_item and the ``page->mapping`` of the
+list of struct ksm_rmap_item and the ``folio->mapping`` of the
 KSM page points to the stable tree node.
 
 When the sharing passes this threshold, KSM adds a second dimension to
 the stable tree. The tree node becomes a "chain" that links one or
 more "dups". Each "dup" keeps reverse mapping information for a KSM
-page with ``page->mapping`` pointing to that "dup".
+page with ``folio->mapping`` pointing to that "dup".
 
 Every "chain" and all "dups" linked into a "chain" enforce the
 invariant that they represent the same write protected memory content,
diff --git a/Documentation/translations/zh_CN/mm/ksm.rst b/Documentation/translations/zh_CN/mm/ksm.rst
index f0f458753d0c..822c7a289671 100644
--- a/Documentation/translations/zh_CN/mm/ksm.rst
+++ b/Documentation/translations/zh_CN/mm/ksm.rst
@@ -31,10 +31,10 @@ KSM维护着稳定树中的KSM页的逆映射信息。
 
 当KSM页面的共享数小于 ``max_page_sharing`` 的虚拟内存区域(VMAs)时，则代表了
 KSM页的稳定树其中的节点指向了一个ksm_rmap_item结构体类型的列表。同时，这个KSM页
-的 ``page->mapping`` 指向了该稳定树节点。
+的 ``folio->mapping`` 指向了该稳定树节点。
 
 如果共享数超过了阈值，KSM将给稳定树添加第二个维度。稳定树就变成链接一个或多
-个稳定树"副本"的"链"。每个副本都保留KSM页的逆映射信息，其中 ``page->mapping``
+个稳定树"副本"的"链"。每个副本都保留KSM页的逆映射信息，其中 ``folio->mapping``
 指向该"副本"。
 
 每个链以及链接到该链中的所有"副本"强制不变的是，它们代表了相同的写保护内存
diff --git a/mm/ksm.c b/mm/ksm.c
index ab1fc59424e8..4bde9fd8d44e 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -959,10 +959,9 @@ enum ksm_get_folio_flags {
  * seconds or even minutes: much too unresponsive.  So instead we use a
  * "keyhole reference": access to the ksm page from the stable node peeps
  * out through its keyhole to see if that page still holds the right key,
- * pointing back to this stable node.  This relies on freeing a PageAnon
- * page to reset its page->mapping to NULL, and relies on no other use of
- * a page to put something that might look like our key in page->mapping.
- * is on its way to being freed; but it is an anomaly to bear in mind.
+ * pointing back to this stable node.  This relies on freeing an anon
+ * folio to reset its mapping to NULL, and relies on no other use of a
+ * folio to put something that might look like our key in its mapping.
  */
 static struct folio *ksm_get_folio(struct ksm_stable_node *stable_node,
 				 enum ksm_get_folio_flags flags)
-- 
2.54.0


