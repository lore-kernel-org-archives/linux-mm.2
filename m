Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE37210F284B
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 16:15:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 984FE6B00A1; Fri, 27 Mar 2026 12:15:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 823776B00A2; Fri, 27 Mar 2026 12:15:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 675EE6B00A3; Fri, 27 Mar 2026 12:15:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54E086B00A1
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 12:15:13 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 0BE2EC403A
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:13 +0000 (UTC)
X-FDA: 84592342506.07.5229567
Received: from mail.ilvokhin.com (mail.ilvokhin.com [178.62.254.231])
	by imf18.hostedemail.com (Postfix) with ESMTP id 3207D1C000F
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 16:15:09 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=JQ+Y2zVT;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774628110;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Z9Gu9mdbn4w3OqiiQpAxHR+GJdxY31abyFRKRvHJHmo=;
	b=TUXxg+FEEa+OBjeGx1h8+lAUDSGdnGlcMq0unj21Nr6Tzy400GhJ0OpwjqtbBpXUdzf+1F
	8AoW0DIGDDM8KIgwJONExfzGk2H/qZeH4FZWcMwH5rQTxj8IB2ZtglVZ5eY85luxLYdbaO
	YGbMvUlNhxnPe9dkgH+cFndt/Rydtvg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=ilvokhin.com header.s=mail header.b=JQ+Y2zVT;
	spf=pass (imf18.hostedemail.com: domain of d@ilvokhin.com designates 178.62.254.231 as permitted sender) smtp.mailfrom=d@ilvokhin.com;
	dmarc=pass (policy=reject) header.from=ilvokhin.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774628110; a=rsa-sha256;
	cv=none;
	b=z7+IsuKaVxrfqtaULniYjjaC8LDJE1ANN8tdzVIAixwax0yHqzP+/EZmAlX8TLxcpPG3/b
	afYascTUaBt0sxrynedxmEd204cQrnZRIfuBsRWj3xTsGOta9np6UOVcKqkbCLK8djBKJ0
	scMM9sE9MB1Qk69/r2+8an4EppJVwTA=
Received: from localhost.localdomain (shell.ilvokhin.com [138.68.190.75])
	(Authenticated sender: d@ilvokhin.com)
	by mail.ilvokhin.com (Postfix) with ESMTPSA id 35EE5BE002;
	Fri, 27 Mar 2026 16:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ilvokhin.com;
	s=mail; t=1774628107;
	bh=Z9Gu9mdbn4w3OqiiQpAxHR+GJdxY31abyFRKRvHJHmo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JQ+Y2zVT21zzVsEdJDO6n9/TzQL8kdbVKmhbkqMNdtsDuCfRIsmAclilW8PALhluk
	 o21YSxJFVe8VoUBxrxbgKOqVsbjvkBmvo1oenJJ3l3N7oRaMagkmPzJW4cPURQHKV1
	 lh98lNTv9xmPXEsr6HbHW5ho8Va4S1fnvVJNhv6w=
From: Dmitry Ilvokhin <d@ilvokhin.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <jackmanb@google.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH v2 6/8] mm: use zone lock guard in put_page_back_buddy()
Date: Fri, 27 Mar 2026 16:14:46 +0000
Message-ID: <1a4085f7ed0adee75bd09b683cf50e612222c8a4.1774627568.git.d@ilvokhin.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <cover.1774627568.git.d@ilvokhin.com>
References: <cover.1774627568.git.d@ilvokhin.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: owzota7nkdtnp9916oe961gb7xr65xd7
X-Rspamd-Queue-Id: 3207D1C000F
X-Rspamd-Server: rspam09
X-HE-Tag: 1774628109-205675
X-HE-Meta: U2FsdGVkX1/M+GNezFpGstAopPJw5xkElYKnRqcu/GAZO6HB8o1k+LhXSY+4HLsp+sWOicnBcSU508S8/a2YIr+ZjCT/8uhwDhRD7oEqwht5OtZsdDzYq3MM0mkgDHCidrWGUdEh/w8SRB0IiHZb3+yBMF/fYLr8E+lC+H6Ncqd0Bbvkcuxro5T7m1H8QY091f782kyiIM1xnfON558pQO5CyYFeT4eUdFLasqQgicIeuK6/J01xTvQX3xFNHbXX9XV9qJqcwPU9kOam+iCrDaEPoZ6ADN7C4TXQGSgeuuCGMVBcRxJFv4/DLy83nKZM8Zlj1aWSndWdKwO9re0m/XtpGB00eg636Ea8/PBZ0aA/FtypM0B8Eorno3cngfJeg3OZ2nNO6Ymj2El7eYF/Dz7jwu2DTSa4pJ7Pqbk2zjHr0kvJPc+gp0zcM6MeiDa9iaXFywEAXiT7CIJs4v+8ub2B0EsYz/yLM3j4T83fqYSXvgTVEQD24gCpOwXPcVre6UZKwk+bNh9GMB01wMEKL1XHBXq6ase7qcPm15XfSqzjhCiHTod4dEBkuWC22TKPbiDps+aY7W0WHNRqA94ooSJ75RTrpKF4rHiUihkn7idZtlbJT1HNdeTMAP9Mrc/uDBpWPseIsauPZJSmhh7Sgbxid7irpbZM51XQfB2YXYigRcvkZnFNYx50x/LDBDz6dmVpGE/UHWOhpj+csIHYzUW3Uf9qxW8i0zHZsf2BuhiAy2nZUpIWtg3FAzORcNKb899hc+PGkfOtSKSRD8oJiUihSPSZoFf/0g+2y435BzfbrHPjZR1ObBvM/lxuSDZa12hDH+edU5drQ8oL3WQujD0aPuTThEpUdg/b/NgWMyzysPK7gmJ0DjzcFuvrriq/nfl5vqRZHabCrGHW6r5312fQESrqz4sMV4uKoTrgnWQCn7Qwa86j7dtjIzjIEuEqg5+pNq+EhY1/iKU2XdB
 LPMr/hZ+
 Y/eBX/0Ao7Hv/Grbe7elvXYLodX+NOOabOE1hqjFoPwmH728mATSHjV6dytlj3uJQEq/2AqG7k0CjE38o37ShvDuARo0T7EuXkJ4tsGEuxFydJ66rdw5fL+4XqB7lDi1H0W7dpYn+anaqnPvjZyYwzj3vYdaNl7qnlyddXhZ+Zjo4pySnaEXJdBR9SwwNDZ3aOGkbbVtGEiBHOPv9MiA6r8P8KeSFLxN7uczYotq2UXzhqUVXqehsF7rENYWqoJcY/2AzpAPlgEy25+jwjSe1pu2tt/RNpPBTlWIc1gpkiKQz1nkzFu8nAhPxLT5Etrb9YMY2i8uJQH1mMG+bh0PXaQHQximxn140WX8O
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use spinlock_irqsave zone lock guard in put_page_back_buddy() to replace
the explicit lock/unlock pattern with automatic scope-based cleanup.

Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Dmitry Ilvokhin <d@ilvokhin.com>
---
 mm/page_alloc.c | 12 ++++--------
 1 file changed, 4 insertions(+), 8 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index a124e4eebda4..dd13aa197456 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7519,23 +7519,19 @@ bool take_page_off_buddy(struct page *page)
 bool put_page_back_buddy(struct page *page)
 {
 	struct zone *zone = page_zone(page);
-	unsigned long flags;
-	bool ret = false;
 
-	spin_lock_irqsave(&zone->lock, flags);
+	guard(spinlock_irqsave)(&zone->lock);
 	if (put_page_testzero(page)) {
 		unsigned long pfn = page_to_pfn(page);
 		int migratetype = get_pfnblock_migratetype(page, pfn);
 
 		ClearPageHWPoisonTakenOff(page);
 		__free_one_page(page, pfn, zone, 0, migratetype, FPI_NONE);
-		if (TestClearPageHWPoison(page)) {
-			ret = true;
-		}
+		if (TestClearPageHWPoison(page))
+			return true;
 	}
-	spin_unlock_irqrestore(&zone->lock, flags);
 
-	return ret;
+	return false;
 }
 #endif
 
-- 
2.52.0


