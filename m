Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3503FC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 06:11:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F5806B00AE; Wed,  1 Jul 2026 02:11:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A60A6B00AF; Wed,  1 Jul 2026 02:11:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 06E826B00B0; Wed,  1 Jul 2026 02:11:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D7F116B00AE
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 02:11:46 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 66879C15EF
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:46 +0000 (UTC)
X-FDA: 84939186612.30.F650752
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf12.hostedemail.com (Postfix) with ESMTP id BC64640008
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 06:11:44 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AoKgCaeT;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782886304;
	b=a6q13XRzCGvWfH0H0fL9G0cahYgEF/6kCsSKYDZlqr1V4tEhqff2yb0qklFpvIlvPTxuZl
	c7xVlMR4P1yeAwD0ZsaKYFQ12x2QlMEUHMa6NRENR70VZi732o+nwbOya0RjqFIYn8OzQc
	B5Lvxd+elSyD6awMw/c8TZJJclWN/oY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782886304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=sac7dxtfmfof1avAgAmsbOLKfM/Ht5OVHe83PivdxXYIdkirq6Z8oQe6J+v8Jsq7C9C6I1
	iR7we3Urj9R9Y+5OcmT1fUt7uiu9lC15P3BCG8SW3vofb6/tJtpCRWDVDyQw6evg0ioxY/
	40teVHbKfOBh4Fgz8xm2tKtXoDmqHpU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AoKgCaeT;
	spf=pass (imf12.hostedemail.com: domain of ye.liu@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=ye.liu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782886303;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=x7l7Cu37ztLHTqXl9+24GTeEvM65Yy8Y6kuKnfhmUgo=;
	b=AoKgCaeTBnkHBefGppDnHIlcV/22osy9mYp7YkGWbWiaNQyS0/lLfLBJVwD6eOx2zVrgAi
	z0b4n8wAj2MdONXp62SRX6pvMJIbtYsDZeciw9i8u9+56n+dwo5rQm0nyND5j0AqZ6U0AM
	DmXbAIXLPrvYty5DMI4iJcmJtgN92oo=
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
Subject: [PATCH v5 4/9] mm/page_owner: hoist CONFIG_MEMCG to function level for print_page_owner_memcg()
Date: Wed,  1 Jul 2026 14:10:47 +0800
Message-ID: <20260701061101.344679-5-ye.liu@linux.dev>
In-Reply-To: <20260701061101.344679-1-ye.liu@linux.dev>
References: <20260701061101.344679-1-ye.liu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: j9nehgj36yfqcrfnuhbce78b8jo3knzc
X-Rspamd-Queue-Id: BC64640008
X-Rspamd-Server: rspam06
X-HE-Tag: 1782886304-351579
X-HE-Meta: U2FsdGVkX18a8A7wvPjR2yOHh2oBLQQPvF7l4fq1ia4kfymBtfVYI8fIpIYaHSfx9yOkPCT3YWitdXs+V9+dCRg4vQFwkeW2IhhJxmKYX5sAC4whgw77kmEttr/26QwgWhuZmeTr17ne2bXOn0gK86OxcrhIDLuirDAoJ3Po7TqlpogNjLwifg6k12nN/vaLiOougRa5BG/SQUZtpqvd6j/Dpa7jkhelBd5P2Dm15JleNB90cvlTuQzuvzgbmyF+nuKQ/orcxbnJGffMMNNJsAIeEmUDb5tHRaKh2jQyJuvch906Un64Gwp2l3IgFw3z4eu1T7BUnabq1DOMMLyuuPV6zbhQ1S+o4wLL7eLbDg4xciFVO0dUjH3x98KgGeOHfXzrdKxCkzoLwz89Klp6BbN0unga8vfEzs7HNnhEl5fpRi9TDZa/8TdXama3y+czzy6FSbiEo8QuJRfl8Jac5gWdQGFZ/UPJMxk37TUZDFNHy3QkUcQEVI2ij07RbHaBwLf9ktxd6mNyfoz9F4ixenIoogXCJ00fcq9XWX2h0A/DkQEtgMjTCoDOIZ7QlF3rfjoU0EXrP6zBb2M/eYQPFLnLbLyyGjg2KEkP5BPHM3joTsyOygHt3shjXcpWKFSOhJObhfLMzANhIHLTw6kk5nWV5Y3IgfEOOtp66LUZNO15xKVgdbfSEfnoTphNpmSqerfzZmwOLbubvTW9EBe55IYUs5LV58tqDDnR9ts5TmYcmd/vJC2hkhaR0mYO/SmFkUlWCH3g1sVTA0H55eg2xlUBdzt1C0b2CWdlI0tEUhPXfdlnPuuknENnFdseLcgWXISq42/yEHukvLTKNT+k7zdt0KJ7ETRVJB9ertghENEZ9AN9IzgcINp6rX9/qbc9yinW91jpqYqF4Anf+I77OXvVb5+VQdkGdFqPofK6NRSm1SQUrDl9gk2awXutMDzagIKzeYGVSeyWyy73BnB
 Mw4AvtaS
 BicitLyq2BHARmc0UOQzBTYJVWDT2BBOIJeD+mcqTg7Acyh4I/3MzBUO+ejr3zfxC+0jp1fjKv8dTa20Gn7SHXJNyXTVJ39RuG9DpbyxUxfKtO2BEfv3ACkgH7jAZyODUwMpbCxKXalPozfzoV7mfqfQ8NQcQsTCv+Awh57QmVRAjp1+xjBBnGyTHhYKE0owtRL68BFxZJAobBHO3e36efuUtX0ECNCq5AKK/fiuVscSxcETEjvtVuRwpM6o3wFbsmm80MLOAGbdgbYH/gzgwgnZaokddPu3NdKNDsBA/VAsiHac=
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


