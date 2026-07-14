Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 357DCC44507
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:52:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B64136B009B; Mon, 13 Jul 2026 21:51:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AC5D96B009E; Mon, 13 Jul 2026 21:51:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A00A06B009B; Mon, 13 Jul 2026 21:51:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E16B6B009B
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:51:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E2F1CA005B
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:58 +0000 (UTC)
X-FDA: 84985706316.29.1861BAC
Received: from out-189.mta0.migadu.com (out-189.mta0.migadu.com [91.218.175.189])
	by imf26.hostedemail.com (Postfix) with ESMTP id 47F0D140003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:51:57 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VDaeVNHK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993917;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=5j14aHZQa96M/291Dph/bthkmxnpzUGfSLvuk7AYCQXo4h3dv2SHGIQ67JTeHEIPay+rax
	kl+1zUFrVqzdiaZ1+Bfw5QefrI91Ht5ESSqc5HJinOlx6oCsD+Nh16ZKROLZwbMb98qPtR
	DWVZ3tDKm5REYC0VvXS/vJOw3GjmT5c=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=VDaeVNHK;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf26.hostedemail.com: domain of ye.liu@linux.dev designates 91.218.175.189 as permitted sender) smtp.mailfrom=ye.liu@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993917;
	b=5XxgOgKrgtRyVK2Lf98OpK18EiRJ16N3wx7TbdqxqQ7yYl1YcREhkN7YvezCS9dWRJ3nU+
	unXJ9ea2rir6eFqw76onamOttVugSUdGif2PeKtqr1B54Dut6xVcsDqpV2DY47Wrq0fdHd
	IOob6CXYECWJxg01+oVBhoTUwpiq0bc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1783993915;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=VDaeVNHK+rzrDKN2cUcePBSwvPQv4gQChSDROMeh/IDfcf0524K+aEn9CaldetVKqLuiTo
	cJ2JddY6eVAvm3KEOVJtRG5oeFLglna/ghidCotyBiWlCDy6KWJvGl59Z+UNWX9ocr3Afx
	H52xXEXZ779qjMM0gTO/7kFVsPFQAvU=
From: Ye Liu <ye.liu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>
Cc: Ye Liu <ye.liu@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 4/9] mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Tue, 14 Jul 2026 09:51:03 +0800
Message-ID: <20260714015117.78351-5-ye.liu@linux.dev>
In-Reply-To: <20260714015117.78351-1-ye.liu@linux.dev>
References: <20260714015117.78351-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: po7jk7iwkeaysuz9pkzd6mb83pzfd63y
X-Rspamd-Queue-Id: 47F0D140003
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-HE-Tag: 1783993917-393969
X-HE-Meta: U2FsdGVkX1/RX9rxVqDpHaD+HO4jvvayftnaTpb8+sU/LA+lDBLz1CvWv6vhd070+/1shQewhyQCBuiS2i/LMkDA8c22Gle95u6FtHT1jNBLcGAVijK3mSCeVXiY7UYSsQ37Zl2Lix1oKkoLEgpokB5sjR5XukC2rswYmc1ITDyjxR3Nvb7pa7X/h9wdUYkfIhGGYsQnCnec8wpKVBNNw7xX1vcQg8HArwC3CPjWb71t+0vDs6OuKf5M33I0syVYbgsayTBHP3l0/K/QJf2rFTfZCM7wXQ3YuRwY/oEDzAB/AYZHSXHTPXpg+F/eooUyZaB1OGhq3KIFa0vk8YwebADIPmkxBQUF2Z2faaOFyPqIbzBaBNXdAeRzxTKF5UoZ4LiWXNu+cMZZ3NzozfnMktrZIvVt0GgLxQMz/kZSDYpWGVfEFKfH4vb+4F8g4v2RVdn6TZS/QPlwnO7TkklF0s64eibhCnq8b6ts27FEsYthISavy0eyX/A3GL6RnLaHau9C1XK7VOWtx+pX4pxaiZbViY/7no6Q25alRf2xglaHcIRJwqxd7k/WegYBQyUufJVCb3v0rs9/o6T7KiuX9qtGjQZ7aEb6N+BjMTDvmVpKE0c3qqPo353hmyqINAKTfk3UMteKIGXRpMupGCMYcAWh0bj9mwy6g9HIFhoxWJLCuro5AndLO9OXgsbP/LEWAm/QcB8i5rk6CNgvZ6qy8Xbk1rh9nRwyDepAvewyo4cTtX09HKsInnNVDiC9As0i9KP9IzEQjxeJKjTrz7NIxWicsTiHPx2q32Cv/MYr5rJULdpPtjJnnhEq0fWVShbsVwYbRLFQrow2cq8cxLylczNUcNOAsYYnqAVGlbazkVhuNYNjkpzycrTZZwpVJ2iBWpcqaeR5YwJweaFC6V6pgZfbgEBilqAYwn7txXDp/CjnwRktV2oJfKtMBHW9T+WpY7x/UBggsMYqL2hjvLe
 3Mg5wmx4
 TlSAYrU5YdMkIKtBqWMztgcR1ZNynfpIX5wD75Va7NQCDZ3g9Tf4hh39ynngCnKKnFAAQD26Ixh0svREip8JBYQuxltSBCf1fODDlt+6+z0vJDTEfjh9NR0OXsYM1ImKTN7JgyzsFoZwogl0oWj2KY7gFZ5LQwJ0asmuPfUTIjq9RlUH8YBdhAAvT09ybo1XFApAtC8kHP1kBcjoZ7rrxQDxj0/XWvWtUZkCr08IRllNBPe0FAJ0pgwnEjS20BRF8QF2n41VZ1SmxoKyi35gv5qmKyF9s5Sp6xGIw/I3oxgJyuuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The print_page_owner_memcg() function has CONFIG_MEMCG guarding its
entire body via #ifdef inside the function, which leaves a no-op
{ return ret; } when the config is disabled.  Hoist the #ifdef to the
top level so the real implementation and the empty stub are two clearly
separated definitions.

No functional change.

Signed-off-by: Ye Liu <ye.liu@linux.dev>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
---
 mm/page_owner.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/page_owner.c b/mm/page_owner.c
index 4e352941a6e2..fe2bf2274d8a 100644
--- a/mm/page_owner.c
+++ b/mm/page_owner.c
@@ -522,13 +522,13 @@ void pagetypeinfo_showmixedcount_print(struct seq_file *m,
 	seq_putc(m, '\n');
 }
 
+#ifdef CONFIG_MEMCG
 /*
  * Looking for memcg information and print it out
  */
 static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 					 struct page *page)
 {
-#ifdef CONFIG_MEMCG
 	unsigned long memcg_data;
 	struct mem_cgroup *memcg;
 	bool online;
@@ -556,10 +556,16 @@ static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
 			name);
 out_unlock:
 	rcu_read_unlock();
-#endif /* CONFIG_MEMCG */
 
 	return ret;
 }
+#else
+static inline int print_page_owner_memcg(char *kbuf, size_t count, int ret,
+					 struct page *page)
+{
+	return ret;
+}
+#endif
 
 static ssize_t
 print_page_owner(char __user *buf, size_t count, unsigned long pfn,
-- 
2.43.0


