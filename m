Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B6F0C44503
	for <linux-mm@archiver.kernel.org>; Thu,  9 Jul 2026 07:17:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 535636B008C; Thu,  9 Jul 2026 03:17:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4E5DE6B0092; Thu,  9 Jul 2026 03:17:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3FC506B0093; Thu,  9 Jul 2026 03:17:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1C48F6B008C
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 03:17:57 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 827EB12041F
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:17:56 +0000 (UTC)
X-FDA: 84968383752.02.174A87E
Received: from outbound.baidu.com (mx15.baidu.com [111.202.115.100])
	by imf16.hostedemail.com (Postfix) with SMTP id 2AED6180003
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 07:17:50 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=ZKH0Jvsj;
	spf=pass (imf16.hostedemail.com: domain of "prvs=md16448C18A3=lirongqing@baidu.com" designates 111.202.115.100 as permitted sender) smtp.mailfrom="prvs=md16448C18A3=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783581474;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=OkEwYNn3Kzj/19nEDUJIcFeVvbVD2LipZW/+SjC+YEc=;
	b=hEc7CIE8u6jU/wIOUb90+4AybS9Nk7JCvjFTVuvwJp0KUS+kCRPn8l6sPSWW9Jx74Vqw2/
	VwXsNfPcGBG2lsRFQUBnVUp/S9hpk3Vh3e9HfOIVuCeK34Akn8tYs/R/zvv3F/Kq/UKYjO
	n9UgcGWAvMub9r8/IW1D2rORUEwELVw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783581474;
	b=WRG+PBXw12QkwiS1BvmLI3CPxQnV76bquwL54d+7WpbR/0+nZ1xZ/kWvGefd3MKevUI6I0
	hxS/Je6xNdJjEhzPRTl4cbTwmeyOm5lLtZx82S3Kz3Q5zN62fFFx/pehURbUrnFXVOZVd/
	lbOGC25ZnFw7AQIOo1lbUouLz6SYuy8=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=baidu.com header.s=selector1 header.b=ZKH0Jvsj;
	spf=pass (imf16.hostedemail.com: domain of "prvs=md16448C18A3=lirongqing@baidu.com" designates 111.202.115.100 as permitted sender) smtp.mailfrom="prvs=md16448C18A3=lirongqing@baidu.com";
	dmarc=pass (policy=quarantine) header.from=baidu.com
X-MD-Sfrom: lirongqing@baidu.com
X-MD-SrcIP: 172.31.50.47
From: lirongqing <lirongqing@baidu.com>
To: Yury Norov <yury.norov@gmail.com>, Rasmus Villemoes
	<linux@rasmusvillemoes.dk>, <linux-kernel@vger.kernel.org>
CC: Li RongQing <lirongqing@baidu.com>, Andrew Morton
	<akpm@linux-foundation.org>, <linux-mm@kvack.org>
Subject: [PATCH] nodemask: use nr_node_ids instead of MAX_NUMNODES in __nodemask_pr_numnodes()
Date: Thu, 9 Jul 2026 15:17:39 +0800
Message-ID: <20260709071739.2408-1-lirongqing@baidu.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.31.63.8]
X-ClientProxiedBy: bjhj-exc11.internal.baidu.com (172.31.3.21) To
 bjkjy-exc3.internal.baidu.com (172.31.50.47)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=baidu.com;
	s=selector1; t=1783581468;
	bh=OkEwYNn3Kzj/19nEDUJIcFeVvbVD2LipZW/+SjC+YEc=;
	h=From:To:CC:Subject:Date:Message-ID:Content-Type;
	b=ZKH0JvsjmwG4lw8VtoMemnvQGhsZ9Wc1f86/T1rMScMl9HdBxveQUleexwu8k81hs
	 PNVbAShndVoQtpOrfpl7Kxy6ySMcW+eFdVTjK6gzNh9j81gJpKb9oafVg8zsWO1tC8
	 P0RvtdueVq8+05j7weH4D/MsuwTGOVh5E4hiFaXtT5oMKmwPuxQcKWk7Pb9MBsLJSf
	 gU0lkX0uNCBvWO2gHq1OfWZvL7PJQxeZVVqRrwrZOfPO7NnsLMczYDAWMkPpojmJEr
	 Gb73OHR9vdJdbCAfAuTwpu07uBJmcE5kurtAkROpOgh/enzhNjCiwXhGzAJtVLfe55
	 bmurdZPIVR8Yg==
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 2AED6180003
X-Stat-Signature: dmfrwp8km3etpjxzw8c1hrgb15kuqtjo
X-HE-Tag: 1783581470-907816
X-HE-Meta: U2FsdGVkX19V33QEsiOTytMrGcB1SYR1AZQKE5/sXs/ILuwQWOQcKh22NX6bLRVMG7vq0HSUHxaXrHX3Kqy7wsPAEC8cpsaPiI4Vh52YANALdkSaxIWbBpxo+QQ4p8V/wO9ZiTG1p95NT1nWGYks7ElWEtjy+79ohV1ZOA9u8v8s7nFxx4KGQnc8BjYXKuvzQQDLExrePsMgMADL6ddirjSHYCmTLTdGlxZjD+OjhqiU0yNn64UwVPah04sd2CfZD6Qz8uOTKe9mDXida+x54KlevySe9/vA6FqfaqvKi05WqltOlxjpFmCrgTHpCm/TNti5rtD9z7NXhATO9eW7RJ5JV0/DP6cLtnSi94tfGHTzD/UlcQyMh+VhtPtJfN5EnR0EyGct1ZI6dekJlBYcK4Bu1z4/0aFR1UtwpdfPCsxth2spsqpi2CVg/XnzGKpjI8PEzuwVNr/sJ/WzS4vAs5XZlPnwrNBl5tN/W66KowAhKg4nySiDFf0zEVQM+Ne1SoQFCZ2dPAgWuVQw8kKaVuj/dFV+uMs0WTGG2b3r0Nrft+EzoDkOIg1K7KCP6Yo257OHMqqwMfTd92neaWObOuRFs8YRVNK0q3TjO8krL/+cqKRpM80oSsRCM3Wn7nFuSKhC9EhQCG+DbQz62lOJIn7o04dCPgK5/3L/XRaMensSG2moWyupx9vJi4tjenaKs1PGtNwaoEN6ttG/OOxxIE3uBgS6FJuSUwQvjW2N1rq/lQghZOJ6jSKnC7I6Ewo2p2k2wIC0r+YnMTVmHz28fOl0M/hZCwZyJOIMcLk1PviMZLCBh71Dl4RZs+896aXp39DL/yx5BWb+VHCmeusKxNVhEOMBwLmpaHMxqT+Q/17LWi1ZcIz3003uww8wq3+YmBjupQ/W0P6IHAA4qHwDrYPbIHsEVH/T7WLgv8D6MJiH9xGvVdw4EX0/5p3WyxyuK7x7RG9/kHsOKnGa/dA
 UlSoY1rN
 fhS6JxT+VdlwmcFlwrLmAs2tu21JRvrl6OzHgM4nn3XlKO4Vj1UwtOqYBaXrD1Eqh1ljLKpuQjqOp3/X2GLd1RCbD3L3BRJ15YMoBcAUOf+gzmzuz3+oC4Cb/kO+MotxHOwKyeQiC4FNQvXgOobpNYLrHbl3RaLGtpr8+gkreM5jNQxc1l9FcdhRpjVi1tqdezdnYzPP+OPGzWVZoeniyRc4Fg2WIcL6XLd2fg61vqWI1uSzof7cofaUSvyJHiIqc9vtgap0thytSCOXaoIe/eV8pOr0hZnpR0taUqkU4KXwhu9Ef81VSnX5NWLpTWM/ntL6aT7TGWg1Ul6d0WJRDN3J9C0MiCUT9533IT9NRsP9rSMrNM9W/GF5vYv/G6mKDxkFATqKBiPBzZnkXLa73NVDC7Y2gQFRryGzz/oRFm9xQ92/RFJOPltgj8LAXJEF3GwyUpr5QEfIuUeQa6kPA4r0XXZP2cYTFaE9g3HIi++FudOq4wWrwUxmHihtXFjTprxoEP1v3ICHzIybgOz+2aDQeSKdcqvhc7rQbs/5U4fZH1ZM3ac6wssIDjE+8b1qU75Qk3wDRoezDc+g2FZ07J/B02V1RpnzQvc9iTIFsy7FmE15IdfKTJ6DvEUKE+2dG6OrtvQ75nKWOuuY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Li RongQing <lirongqing@baidu.com>

__nodemask_pr_numnodes() returns MAX_NUMNODES, a compile-time constant,
as the width for '%*pb[l]' nodemask printing. On systems with few NUMA
nodes this produces excessive zero-padding, e.g. with MAX_NUMNODES=1024
but only 2 nodes:

  Mems_allowed: 00000000,00000000,...,00000003  (32 groups)

Use nr_node_ids (the runtime highest-node-id + 1) instead, matching the
behavior of cpumask_pr_args() which uses nr_cpu_ids:

  Mems_allowed: 00000003

Move the nr_node_ids declaration earlier in the file (guarded by
__nodemask_pr_numnodes(), and remove the now-duplicate declarations.

Signed-off-by: Li RongQing <lirongqing@baidu.com>
Cc: Yury Norov <yury.norov@gmail.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
---
 include/linux/nodemask.h | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/include/linux/nodemask.h b/include/linux/nodemask.h
index b842aa5..35269ea 100644
--- a/include/linux/nodemask.h
+++ b/include/linux/nodemask.h
@@ -95,6 +95,12 @@
 
 extern nodemask_t _unused_nodemask_arg_;
 
+#if MAX_NUMNODES > 1
+extern unsigned int nr_node_ids;
+#else
+#define nr_node_ids		1U
+#endif
+
 /**
  * nodemask_pr_args - printf args to output a nodemask
  * @maskp: nodemask to be printed
@@ -105,7 +111,7 @@ extern nodemask_t _unused_nodemask_arg_;
 				__nodemask_pr_bits(maskp)
 static __always_inline unsigned int __nodemask_pr_numnodes(const nodemask_t *m)
 {
-	return m ? MAX_NUMNODES : 0;
+	return m ? nr_node_ids : 0;
 }
 static __always_inline const unsigned long *__nodemask_pr_bits(const nodemask_t *m)
 {
@@ -438,7 +444,6 @@ static __always_inline unsigned int next_memory_node(int nid)
 	return next_node(nid, node_states[N_MEMORY]);
 }
 
-extern unsigned int nr_node_ids;
 extern unsigned int nr_online_nodes;
 
 static __always_inline void node_set_online(int nid)
@@ -480,7 +485,6 @@ static __always_inline int num_node_state(enum node_states state)
 #define first_memory_node	0
 #define next_online_node(nid)	(MAX_NUMNODES)
 #define next_memory_node(nid)	(MAX_NUMNODES)
-#define nr_node_ids		1U
 #define nr_online_nodes		1U
 
 #define node_set_online(node)	   node_set_state((node), N_ONLINE)
-- 
2.9.4


