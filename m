Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B9222EF3706
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 08:06:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2CAB66B0093; Mon,  9 Mar 2026 04:06:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 24DF76B0095; Mon,  9 Mar 2026 04:06:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 119966B0096; Mon,  9 Mar 2026 04:06:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EBF066B0093
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 04:06:35 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AE8A1C29F8
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:06:35 +0000 (UTC)
X-FDA: 84525792750.15.2E97473
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf10.hostedemail.com (Postfix) with ESMTP id EAA91C0012
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 08:06:33 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZqEWk6yS;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773043594;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tpBsCDLcm2n1XrByJy4y0AKMK904EnYCVpywQiSZvCo=;
	b=o2VIVgd/w7BYrsSwDTMKI/MSeY6bymqF4OmHkxhD9S0Zh+GWcQGM9LLGnHdMvoc0B4OAFf
	isI4LpFnPT7fsxU0qTXBybc6pSb5ifQhyLR4qiTcrZmxix6/JsreKl+MP14HUp6lOmvZPc
	VSHQDe0TRjyf/ETNItkUGK2RDzYlnEs=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ZqEWk6yS;
	spf=pass (imf10.hostedemail.com: domain of hui.zhu@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773043594; a=rsa-sha256;
	cv=none;
	b=oT08h1Bkh4efWEKAAnIfBaCLnQXDc7OB3m5srcpIge4GzOcCy0yhWks+vr0fNDmoe77WbY
	3S3OxvxVvkM0tOGKWKc6PIjxpPpXE0GrgqnRJSYatjvGwfCxbfaYGDp/Q9Rc6AaIl1Qzk1
	t6BeOXaZEQSLG2jk6WdSfmRT9WlpaDw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773043591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tpBsCDLcm2n1XrByJy4y0AKMK904EnYCVpywQiSZvCo=;
	b=ZqEWk6ySKPHVezXprH4LiiDhG4zpepfYXmtDqReWcGDqrt/yqnpRmsKUMckTzgguxd1FHp
	H70+NcvkMtCEmdgekuLrxqjTixhm6i/vpy+vXGuhLdu+crmhkyjWJKc1KAIDWbWEEikTCu
	0I8JU1K4ChTGCMiAp3kN8SCRavBr1sw=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	Barry Song <baohua@kernel.org>,
	YoungJun Park <youngjun.park@lge.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2 2/2] mm/swap: Add lockdep for si->global_cluster_lock in swap_cluster_alloc_table()
Date: Mon,  9 Mar 2026 16:05:42 +0800
Message-ID: <879eff096e46c02f994de62dc210a95cc58e3f19.1773040982.git.zhuhui@kylinos.cn>
In-Reply-To: <cover.1773040982.git.zhuhui@kylinos.cn>
References: <cover.1773040982.git.zhuhui@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: EAA91C0012
X-Rspamd-Server: rspam08
X-Stat-Signature: nuhatpx6mj88ztoj143jmj3c34pkhpqi
X-HE-Tag: 1773043593-639724
X-HE-Meta: U2FsdGVkX19/kjcVUBVAo85yrdA0MAX1NlI7WYj71/68UmIeiphx4DoBZ85jUowybOJ9UPvjaZfT5vzAKpDj/HIB/QHhJz8kVQmJObzA2QppZTAQoUib5zO5PNPzLo+g0z4YB2zZG7BCw7VK1TaEKRIOU4tVWq5q3jWlePzFXkDvwDFSpBOuIQMXlLdUurbqgcgx4seea+1F/JmFIhpfcBZX5qyI8Zx8Dx+DZplfxgswJHUl9kwb0XrT16wjTNTWzoCpMeAi+IHnvxJBw8Q9tpQ78Whszx+PTAIirJhO8SuwWjUzG8mWDdwsD8QjF1J7wthZmYndHeW1ZY64iWvCH7Iih6oNWE/oWBTugRjwj6DVQKswhzohOEAMsfrGQTkfg8k4l5JtCaKku8j1SsFoZ4hdHbjgf/R6fXK/dCvbubhqCwsvCNdrPxOdoqa+4fbova/ukyuPosFrFFJ6pVY0RUCjIdhEkqxXovlff7E2u1bIBSgoLy2GBR1kfXS5FRdosGc0zvvH2iaOeIfsRmEMblWykkJxc6Rdoc53iyNtKxJfxh3VOhcPVNQyZ9BnBQzaMfzqlrEQTIxn0Gw5LuHN51a3qe6kOuiyt+UNDfaQ0ZaFQEr0ePi3fiOhGEE477An3quueenSPAMfOQmG8RQnix9/7591mqs7ZKs9ZT9KVJEg2MtKyoK1Xz6m1nNAq0RhqT2GDLQ6FeGWEdP61FNaflmou7mfb55Src6RTYKQNySKVLiEolXiFu25Ob8WAC/uB9xVRcchUup5OwNWXF3NY3IoEuSWmWSTbc24ZxH9oiIwzH0bdu/pRTe461D8Ln63nw8U73O9ryxjfMYj7cslWJ++Lvd38+w0PpodK8/bEQKseZXyBRJPe2NjYiXk1QxFhRFIkZu6gVAv6HuK81GPeSmpU2pSVErCUtuMAjkLdLD+4w5yw5tvADNh7MJD4nWH12mb+HhquC1EGqQwI5/
 rsog0zkB
 8FkGZi010MuFpFkcXHYCbmUi0wIgMwvxExpHebSbWfbkyL3J2pp4nR8nz9q/vnsA4u3W3KfaM3E7oN2l6BuAAw4nfBjp6Lg+ikaOwUPH22+o4s7QupEXFGZ4Cpl1In/LgWu5LtKMXFqdOlmMAzLeVVUrFwAklXLdi8d/RFvwiYN+nmjs7ME0iuOUDlaq2POzc2Ke0JOgeBovxMzs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

Add a lockdep_assert_held(&si->global_cluster_lock) in
swap_cluster_alloc_table() for non-SWP_SOLIDSTATE devices.

The function already requires the caller to hold both ci->lock
and percpu_swap_cluster.lock.
And it also necessitates si->global_cluster_lock when the device is not
SWP_SOLIDSTATE.

Adding this assertion ensures locking consistency and helps catch
potential synchronization issues during development.
Change the order of lockdep_assert_held() to match the actual lock
acquisition order.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
 mm/swapfile.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 3fc2eb30c187..b31b86263b89 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -476,8 +476,10 @@ swap_cluster_alloc_table(struct swap_info_struct *si,
 	 * Only cluster isolation from the allocator does table allocation.
 	 * Swap allocator uses percpu clusters and holds the local lock.
 	 */
-	lockdep_assert_held(&ci->lock);
 	lockdep_assert_held(&this_cpu_ptr(&percpu_swap_cluster)->lock);
+	if (!(si->flags & SWP_SOLIDSTATE))
+		lockdep_assert_held(&si->global_cluster_lock);
+	lockdep_assert_held(&ci->lock);
 
 	/* The cluster must be free and was just isolated from the free list. */
 	VM_WARN_ON_ONCE(ci->flags || !cluster_is_empty(ci));
-- 
2.43.0


