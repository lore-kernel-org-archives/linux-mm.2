Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7FFC610ED647
	for <linux-mm@archiver.kernel.org>; Fri, 27 Mar 2026 09:48:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB6A06B009B; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B36EE6B009F; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 877726B009B; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6A0E26B0098
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 05:48:43 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3036C140CE9
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:43 +0000 (UTC)
X-FDA: 84591368526.07.326431E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4C56DA0002
	for <linux-mm@kvack.org>; Fri, 27 Mar 2026 09:48:41 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3KcyTb4;
	spf=pass (imf25.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774604921;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y2wxZaeOArFNepfalmYe5W33Ju5J4nZ+HJMiHJ1bOY4=;
	b=QkG2d3De1DZQQkYBI9YVskvwx1erlNMiUT5X6YpYRnDaGElB13+LKCPZS3FyWxgGR3RaWi
	PUMEduTnpBjP6rPGZappIfxTC58znSKUSnZJd/hic7R6d1c81x/Zfcc3TH94M/Ax1g9P4N
	QV7wic8m8cmyNqqUu+e89pTvh2qaltM=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=M3KcyTb4;
	spf=pass (imf25.hostedemail.com: domain of devnull+shivamkalra98.zohomail.in@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=devnull+shivamkalra98.zohomail.in@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774604921; a=rsa-sha256;
	cv=none;
	b=we9f/NIKHUxKi74jjSaGIvGRI0xRo/yP8PkXRsLxPzTGzbxouMCk+XEP2sLT/6zFMweJWk
	r0K2FnPNqct7Bdm4pZ//OlRqH6O6AaA5LJE1TBhD/gunTvRuoBUnVkqErHjAsQpVysx1di
	pYIrTG9uj49eNNMliflLdht7MS/v1E0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id BCD516133B;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66A9BC2BCB2;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774604920;
	bh=lvRKpv9TIZt0GjqdnA46kctN4zrgkYUFc8NhDjAPR0g=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To:From;
	b=M3KcyTb47w0vFP6hbGYmnuAm0Wtz87yqb7HojB2qNLft7UErvvx7wgkC6P4B8LuSj
	 b//75QRXdqXDAt3zlwmUpRZM2OXSKlEAu69j1Dz9JqHHyAXcujV0Pwz/m7ZnSc40Li
	 6/Q7QGaRjnZ+ujy8hxaYr1gQLx3UZE4z9LOsulj7q2y95sjrhdZF9QFBEpoGrcDkxR
	 Sek03pTvc+vdsEvplCO44tG8Id6KdMI1aLmyaK+FStzGck6ymAw5duZ4C07tOY5CrR
	 u2U8PaO9pi728wBnFw2JtOTz5JH8KOFvn4Ad6VxCUnOfFflGvNQ5I3oyzoFoQQMeL5
	 2glAc05fPmeQg==
Received: from aws-us-west-2-korg-lkml-1.web.codeaurora.org (localhost.localdomain [127.0.0.1])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CE8E10ED645;
	Fri, 27 Mar 2026 09:48:40 +0000 (UTC)
From: Shivam Kalra via B4 Relay <devnull+shivamkalra98.zohomail.in@kernel.org>
Date: Fri, 27 Mar 2026 15:18:40 +0530
Subject: [PATCH v8 4/6] mm/vmalloc: use READ_ONCE() for vmalloc nr_pages
 status readers
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260327-vmalloc-shrink-v8-4-cc6b57059ed7@zohomail.in>
References: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
In-Reply-To: <20260327-vmalloc-shrink-v8-0-cc6b57059ed7@zohomail.in>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Uladzislau Rezki <urezki@gmail.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Shivam Kalra <shivamkalra98@zohomail.in>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1774604917; l=2959;
 i=shivamkalra98@zohomail.in; s=20260212; h=from:subject:message-id;
 bh=q4Ito1vUmJmb3A3de47pGFK3WSX+j54Hs6oFM89TDPE=;
 b=WAfAOXMaxhCxjvt2ewSFJ24eqk8Y14S2Fzvr0Bi6nQKMPvQrC4YQDdEU9hGatJ8o3viLlAzov
 V4kYd9euOsHDeADLt//193DDbkOHhKjTrrbTTQyhPFP8B9THCu6sr/a
X-Developer-Key: i=shivamkalra98@zohomail.in; a=ed25519;
 pk=9Q+S1LD/xjbjL7bEaLIlwRADBwU/6LJq7lYm8LFrkQE=
X-Endpoint-Received: by B4 Relay for shivamkalra98@zohomail.in/20260212
 with auth_id=633
X-Original-From: Shivam Kalra <shivamkalra98@zohomail.in>
Reply-To: shivamkalra98@zohomail.in
X-Rspamd-Queue-Id: 4C56DA0002
X-Stat-Signature: sufp451m3triq15jwqcmu3uknegpd5tk
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1774604921-856198
X-HE-Meta: U2FsdGVkX1/ADBZwPmYtAgxss0YsqJAPnBKbARusrjt9Bwb+zDo3O90xyAi/+hoEfKvCAh7h4YDnth767I4CyJwOSwNs02USx+e7x251KVdSBACan27tt6MDN5ROJ7M6jXiMPtIhnKCo5+3azW8CDrd27r7/TRhoHKx6seSzHl+kvM+h6QUK0mZMUgkSXxH07Ks8ttoLiypDujFUaVtdM5hHM/HCu3QHaEenP5ywMqUYV28fLaEYeHWSnHxAQ1j38ATgIwgt+ibPmA9n23N6uk3eQ8CG6kNiQM1p6kaU7sn3QquqJ12IEX5WFPp+aVsVRPZmx0dY8m6v4SPFd9+NVqQsJ2pHEdjIWfb4ZusgWqJCkyqUJxq4iSUl4qInro6ziw8ZWmR/KbaRPr51P7gaNX6pWKFJEYqjOzIhJVXXGXn7+WoKctULYjF17Ny3zpp1OdjUAYiraW629gWqXlO9UOFDkV1UMpfpJDBtB79uzucow0omb3Dcr6PaD8rTeHJTGXcMWDOtIRIgsZyLbM+VllAbcAbXhpJT3z6/QEYVG4Aq9BIy2bDw2m91Z9Z1Wm/XriHZCwPRB+RoCuYMSpsE4nlKnVtOMCbfYDgxQYwqiZIw1WFTS79m2/LZm2sU3UZOVZ/lKZUANPuCM+H0BLYBK1Me9DuzdLRLn6V76QouFR9vmpZrdEhzL6zp1SvcO3/Mj8MjxymP6Me3sx671sUSuTKzweL4cB1iwps2XuMMucXxVKxxVCzszgJjlxP01CENreIoeCs40KtXisdGbNnlsFCir8M2GARCxJ1v2JE/7+heZKL8jTanzG8bbxKKu03ebD14nucAc5UC2Z3eDzwNolD/egWDNTAGe8u0EcCpTnsKb/s3Gc9KHuFkT+RqvRQLlGR678a+G/OFW8rUxfxyqN9LQ6LnxjTwcrs8eW0aUT1qyZDJCIUURsDLf9ws5cHvwqG3xW1goPyS1IDg+WG
 hae5nO5l
 Hhn2jMbRJMiHsFnrltDVbc+pM4jVIAR5luhemsm8yCD8AgudJR+oi8tSbAInbeG9u/by6Qy5w0RDGC4Fo2P6T8iIVp9lsfapebdOs/7F17969ZnNutepI7TJWTBBacdxvdrRX7wakNhCBxQNZSb1MBu+f61QLwpJbsqoLSxdAMGK5ODKCsHUM4Ojz6DsRHwdItotuYxm0O7p3L9cxvmZcJ6lL0bcS4TxkaKkSmusKlKeNvLxDIuQpPSjBNi7P8B5OJDkL5u9tUuB2zDmeOXYYRLLmPX+oaykw12JqkU4jsNRRd1Erk8V5M3ob4A+EiB73bqG/n34eABOVFZw3+K70fp5gRvwdsb+J/d/ZVL7x+15d3mwlvv49wV8owt4JVgRzbeVN1hEfbwVdBh4pvn9fkYmJUW3IqLaescsf
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Shivam Kalra <shivamkalra98@zohomail.in>

The vmalloc status readers (vmalloc_info_show(), show_numa_info(), and
vmalloc_dump_obj()) currently read v->nr_pages and the v->pages array
without any concurrent protection.

In preparation for vrealloc() shrink support, where v->nr_pages can
be decreased and entries in the v->pages array can be nulled out
concurrently, these readers must be protected to prevent use-after-free
or NULL pointer dereferences.

Update these functions to use READ_ONCE() when accessing v->nr_pages
and v->pages[nr]. This ensures the compiler does not re-fetch these
values and provides a consistent view of the vmap area's state.
Additionally, in show_numa_info(), explicitly check for a NULL page
pointer before dereferencing it to avoid potential crashes if a page
was concurrently removed during a shrink operation.

Signed-off-by: Shivam Kalra <shivamkalra98@zohomail.in>
---
 mm/vmalloc.c | 19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index ddb689bf9ba5..c6bdddee6266 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -5189,7 +5189,7 @@ bool vmalloc_dump_obj(void *object)
 	vm = va->vm;
 	addr = (unsigned long) vm->addr;
 	caller = vm->caller;
-	nr_pages = vm->nr_pages;
+	nr_pages = READ_ONCE(vm->nr_pages);
 	spin_unlock(&vn->busy.lock);
 
 	pr_cont(" %u-page vmalloc region starting at %#lx allocated at %pS\n",
@@ -5210,7 +5210,7 @@ bool vmalloc_dump_obj(void *object)
 static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 				 unsigned int *counters)
 {
-	unsigned int nr;
+	unsigned int nr, nr_pages;
 	unsigned int step = 1U << vm_area_page_order(v);
 
 	if (!counters)
@@ -5218,8 +5218,13 @@ static void show_numa_info(struct seq_file *m, struct vm_struct *v,
 
 	memset(counters, 0, nr_node_ids * sizeof(unsigned int));
 
-	for (nr = 0; nr < v->nr_pages; nr += step)
-		counters[page_to_nid(v->pages[nr])] += step;
+	nr_pages = READ_ONCE(v->nr_pages);
+	for (nr = 0; nr < nr_pages; nr += step) {
+		struct page *page = READ_ONCE(v->pages[nr]);
+
+		if (page)
+			counters[page_to_nid(page)] += step;
+	}
 	for_each_node_state(nr, N_HIGH_MEMORY)
 		if (counters[nr])
 			seq_printf(m, " N%u=%u", nr, counters[nr]);
@@ -5247,6 +5252,7 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 	struct vmap_area *va;
 	struct vm_struct *v;
 	unsigned int *counters;
+	unsigned int nr_pages;
 
 	if (IS_ENABLED(CONFIG_NUMA))
 		counters = kmalloc_array(nr_node_ids, sizeof(unsigned int), GFP_KERNEL);
@@ -5276,8 +5282,9 @@ static int vmalloc_info_show(struct seq_file *m, void *p)
 			if (v->caller)
 				seq_printf(m, " %pS", v->caller);
 
-			if (v->nr_pages)
-				seq_printf(m, " pages=%d", v->nr_pages);
+			nr_pages = READ_ONCE(v->nr_pages);
+			if (nr_pages)
+				seq_printf(m, " pages=%d", nr_pages);
 
 			if (v->phys_addr)
 				seq_printf(m, " phys=%pa", &v->phys_addr);

-- 
2.43.0



