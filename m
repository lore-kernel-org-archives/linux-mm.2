Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC360C79FB9
	for <linux-mm@archiver.kernel.org>; Thu, 10 Sep 2026 12:03:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DAD446B00A5; Thu, 10 Sep 2026 08:03:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D84C46B00A6; Thu, 10 Sep 2026 08:03:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C73706B00A7; Thu, 10 Sep 2026 08:03:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 912CB6B00A5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 08:03:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 145701604E5
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:07 +0000 (UTC)
X-FDA: 85197716814.21.699CE09
Received: from fhigh-b4-smtp.messagingengine.com (fhigh-b4-smtp.messagingengine.com [202.12.124.155])
	by imf27.hostedemail.com (Postfix) with ESMTP id A32894000D
	for <linux-mm@kvack.org>; Thu, 10 Sep 2026 12:03:04 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E E4ZmaY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FimdyeX+;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789041784;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3P2qVnrMLPFA6A73AmtwzSkxgpkuNKe+y7ebrjYnAuo=;
	b=cInFljlQmuQ74ID3S8ldPujFfSDz7rk1iVlQjJCpQ0wNLCqTm0JuuBOqWz4YyMEC1FPG04
	FEhYGtSWSAYdHw7rZ6J5JWaWgwuPiqIwSViollhc4MQgPwjFC23qJMrHU4KZZ4bcdt6RhW
	AjJLdd1k0NnFcEnYK2S9/57f1giWldU=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm2 header.b="E E4ZmaY";
	dkim=pass header.d=messagingengine.com header.s=fm1 header.b=FimdyeX+;
	spf=pass (imf27.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.155 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789041784;
	b=Z+SfGVjaWYGCCYK0KGe/Z8ND/6MDF/0WwGOCCYqmZrd4O7T6N6+z2NBI/M1npJLbDNSzlE
	IOUHEpWivileGCg0ND73CQwX6arBgejsRwZ3TG5y3hJAIKBLrvNKbQJb5aQzifTeqlDCmg
	e3z573dhpO6OyGbSHcDH0nXOiGyrShw=
Received: from phl-compute-12.internal (phl-compute-12.internal [10.202.2.52])
	by mailfhigh.stl.internal (Postfix) with ESMTP id 9F3887A007F;
	Thu, 10 Sep 2026 08:03:03 -0400 (EDT)
Received: from phl-frontend-04 ([10.202.2.163])
  by phl-compute-12.internal (MEProxy); Thu, 10 Sep 2026 08:03:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm2; t=1789041783; x=
	1789128183; bh=3P2qVnrMLPFA6A73AmtwzSkxgpkuNKe+y7ebrjYnAuo=; b=E
	E4ZmaYn+xzGWUrFAGxtuMzW2lgwc+5yQHzoW3tUnRfFCReRK2pZcN92qd/KdVxme
	dP3feioWtbpSG2j/mUuul/CIX6lTRTy1jqjZqiIHXMjItrCTLoRk3r3xbAFlNCBf
	Wc+dyyesEZJtvOPrrDRIcLfl7pLJ3dk5Nby609dVpb+nySy3xIktrteojQ5z8skB
	XE7+hKRX4ykHnWVBPgd7f4Sw1hOU6A3MHLWjb1BSDKcIeGczic5AQaRJOT5MW1QH
	2sBVYhCKvaQobKwXWJrZvXm4vdxzIuIp78jJNZfcYIovJ12S2yVXwNxUK7lqvllA
	+raLeuq6eBdSAu88GXTig==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm1; t=1789041783; x=1789128183; bh=3
	P2qVnrMLPFA6A73AmtwzSkxgpkuNKe+y7ebrjYnAuo=; b=FimdyeX+I8ss92KOM
	8oprLKsYgVjsO24m/kSxVTReJ3pLyOhpsEoBfBke0mHEo89/2GPjIh21X3eUfh1W
	CMhmU4BnBNMpCGXdGnneUhzs3HeauGmd4aWY3jv6cjp6HVfAduY3RYEMpHvs0hc2
	3TtHp8GTUxM/DHseXCgI5EfgnQ78WfaaqODpG4wGbA5ucgXC+DHlnoX58ugjPlsA
	Zpaf3TuB+vGS9a10O4ujldrhv0tPtdG9XXY2gYxFjWzBOJedsX/b7HPdT/xFKPvT
	QgJaJpIMU5eisXKkJSCojKr3LqdER3TwMQMgbiR1BA/7yy/U1UymWurbc1Q6CXXa
	twGTw==
X-ME-Sender: <xms:d5yiasfYXNRd6LCkwBvWRJdbswcLfI-Cx5cttFtQaeuBKssiiVtvqQ>
    <xme:d5yiaqLVA4knxqFHNs6xJiDepBRPlyquDEqA2ik6B91pTn8q4wg3QI1E8lU56wD98
    oqHeOPpIrhU-8vx5fazoJ79GC-ssgnRBMOPSky0TCMoP7h5m6Y3CIR7>
X-ME-Received: <xmr:d5yiajoey_hPVT18zmHfaIZUqkKEOCrlSYK32uZN3oUIt2L_BR2QSic06ko>
X-ME-Proxy-Cause: dmFkZTEVCHaom43ud29NDpH2Ao3u7HJ/1ECQvA0KKWbvYxhttLa4TfzKR6zF5UuYx3UdSX
    No90AnuR4y57x1CX4a9AAsMV1JR4eQYCvRkfoTmW6C9Lc6lI8AZbTNwmqz4UTzT3vnk7qg
    ph+TCI1xI7srBtDO6Tg5MLzI4vqgzAzQGVqRHCjhPRmxizMOs2MvZfOp4fytB88FrNmNEM
    gORbCSjN6PT3vgIUt7WNrJZsAWFpVymtt3pMoPYb3jF9rU+m42uK7S67tVqaIc+biyrQXs
    /trDbiCnZfBDKlB4R/Y3z4EcguiWXCyuMp2o4aP4AZn5jbn1xeIsCoHcLAwPh3Pk2Cuodv
    jdvPCsgoell1QwQOyq0lvh52cXi36YL8xROZPqyLVvgeWiebTZZvmdLF57eQz75ZMRoVgY
    ljlYRhwz6gxNZoz8VK/FA0zpwTwkN521ywySnZx/Vyub2vFHRCS3SsNc4fNTJQkus5W4dZ
    T6RMH4i7St575scy7WNwXS5FlI7RziOulg6yL8fAjn9BarOT/I7NsStoDPdP8Akd7ladfM
    lVox66/G2cLMhZYiWREwxfvNJVxLr6APh9MeluH/Fa47cZA0HeyBDs5+Iop73ziWvaYaiw
    9CgEi9ST5w0GkoTFe5UjIrTl235lyRYdb63sqaOkJwGIBVe3qTOpwpS2xTpQ
X-ME-Proxy: <xmx:d5yiaoXTwbdKJs3hScmRlbF_u_9FYjiorjmZq3L3OwxyBELPXYUhBg>
    <xmx:d5yiam1A7MJhoYX9S7DhKVohRNc_sBjWY-OV7Wa0lDvmtGTW2x5BWA>
    <xmx:d5yiah34Hci4Wk73ePkTNRPvIz8lA_Ks30cGCl_X5K1hu4yoUgcDzw>
    <xmx:d5yiatnRB03BHf4OuS1_g2-Uhpq3uQMJdpvxNGQOy2cCryu48eh0oQ>
    <xmx:d5yiaj1k5J64ERDqzZ4R0kWh__GC7j8tjW8KIg5wxrQKNBYxrBMwSxZa>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 10 Sep 2026 08:03:02 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>
Cc: "Kiryl Shutsemau (Meta)" <kas@kernel.org>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH v2 07/12] mm/collapse: name the per-table scan reset for what it resets
Date: Thu, 10 Sep 2026 13:02:27 +0100
Message-ID: <20260910120238.2529819-8-kirill@shutemov.name>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260910120238.2529819-1-kirill@shutemov.name>
References: <20260910120238.2529819-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A32894000D
X-Stat-Signature: z6jpfeu8m4kfm9xrtuauu7wjxfqk38mu
X-Rspam-User: 
X-HE-Tag: 1789041784-498431
X-HE-Meta: U2FsdGVkX1+SCWCkrfGbIDpRmw/NnEqshGQCy8RmK/QAu0veTO9nFomFptC5BhRr1WE3k3RQxLdQx9rAqwPRMTk1a6mgt1gFkmJzpER0zYddMMoDi2qA/T8HacWmpbYISTucut6KBaXUcOkmC6dI2nzjwGtvMwSY66JBTKgUi8WQQHZXHcpNVf5rsatU53adgcdLiooMrXfGcS6Bt8DVZu/nl6N9bfhZb5cbM4zGgpZ99XqSgQtqL6xz1VVClh39qjGiy170qndfPeqk3h5vN0fFTDfzDsnsGDzbjJ/uyr1zI3hZolTlqetvhi725BT6M0OlDVoz53hpurKChpWR6dtyjuO7iUI7adKF4m8VJhSUE9G0XQ3iuKUgaCtl3X3yLQ59vDWCjlmpfucAQhcRw9/o+xVWNZFVbaKMUa98xHfy1MG2KcWB+RY6oltBnR7Oi0sjBGOPLzpEBgjJRWKnDU6nn7Af0+Ech06zmKq/X/YB2eqzlsmvY4g29DpgMW0AcLA32fw/lkLHQMxYYVJYngr1ybnAHmgmU1uNPguAr9JpwXM+V7zeHqFlKTfJ/fZ2UPEpQZ4LjWm9L23gdHZ06KY1KqWYxVa1cihnZjyjO1QmQwLkUxOKyqlsiCpGT0o0doMBND/+gwqWyTEohrlT6NngaOqHNUZV9luxsERabmSYeWVVrvXSkCmmCXMalxvr47cqsKduAjroavHkAwYCtNKhejaF/URtuhjtX3X/xXsZ/EBT+JgMA4Ej8ErmjBiYE0zKm11os8/GzAoB/QovRDtISrYFtqh0qnwBWkmyBPGLCGQ1MScauv8ceWg/1f4wczlm4/Y4aaRkEodHpAQ9I/y/+4z+y9s6CV32Q1J8y38rYsRK46tNVmkK5y9+8v2m79e+5y7t6ncr6/4uaCYF5p44tTvoHv1JOcZMRMzwrKN2EKNdPvC4JGRB96f3OMRAuKqRikDz9+INqB3vC0X
 /4qdBVlF
 fh178hGXW8/dhqirSfTqDCAfkSvm/Cvwg4LIZ64EscgwYLvby+OwJNM5d3DpqbHnoyv9GzGsbCjZt7u4MGaXpyXcbKpBm0R9m3fFqDjysApP1omgdQu/wHPSxzYobI8eZw96aXx8eJ27exRjo9HZ+10yhB5IHW5sOq1eJ2Hzm/4Y/NZ6tcL23EuVPp8Fx8kvGn6/15WR3sNo1959gDbqHAMbvhGqMnoRFJ7ZMpNKXpiVf9hck06R9UoiGorafwA0V3aAopMdDIn8+L/c5jdVDLlrzJEPQOHWRCTU+o8Lv9gNO4Qhh0A4dKJ0yvgnOE4w7ME/X3pkvCf7tkSRABl8jvBVvI83hKNYeHRP6LJmyT4wc7i/gaOHy+RBSoQy0Ez/Mz66Xgy7Nh68HnTxv4cMFf2yjUd6byRHo/8ZIAssmxDsv315w8gOXCWW0+LY7D8gw2g1LVIGKwXpaaloeRLQuAf8Bjz1qK77JLTKk5Ou3sZ2H8Z/rq+fJ5eQaXw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

collapse_control_init_scan() resets what one scan accumulates: the node
load, the allocation nodemask and the eligible-PTE bitmap.  It runs before
every PTE table a scan is given, not once per control, so its name points
at the wrong thing.

Call it collapse_scan_reset().

Preparation for giving a control a real init and release, run once each
for a whole series of scans.  Two names a word apart would then stand for
two different jobs.

No functional change.

Assisted-by: LLM
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 2a9f6d8d6695..d38ba030107b 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -550,7 +550,7 @@ void __khugepaged_exit(struct mm_struct *mm)
 	}
 }
 
-static void collapse_control_init_scan(struct collapse_control *cc)
+static void collapse_scan_reset(struct collapse_control *cc)
 {
 	memset(cc->node_load, 0, sizeof(cc->node_load));
 	nodes_clear(cc->alloc_nmask);
@@ -1579,7 +1579,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		goto out;
 	}
 
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 
 	enabled_orders = collapse_possible_orders(vma, vma->vm_flags, tva_flags);
 
@@ -2657,7 +2657,7 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 
 	present = 0;
 	swap = 0;
-	collapse_control_init_scan(cc);
+	collapse_scan_reset(cc);
 	rcu_read_lock();
 	xas_for_each(&xas, folio, start + HPAGE_PMD_NR - 1) {
 		if (xas_retry(&xas, folio))
-- 
2.54.0


