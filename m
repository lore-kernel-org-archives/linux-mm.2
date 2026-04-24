Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5C07CFED3FA
	for <linux-mm@archiver.kernel.org>; Fri, 24 Apr 2026 20:16:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9B91D6B009F; Fri, 24 Apr 2026 16:16:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 969A46B00A0; Fri, 24 Apr 2026 16:16:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 87E7A6B00A1; Fri, 24 Apr 2026 16:16:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 774006B009F
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 16:16:19 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 22FCF1205D9
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:15:06 +0000 (UTC)
X-FDA: 84694553412.03.F0F4CA4
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 57CA11C000C
	for <linux-mm@kvack.org>; Fri, 24 Apr 2026 20:15:04 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OJNnK0HS;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777061704;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VjpQjniH49eE5KKtWaVK3+VyB6/4UUWM/j0z3Vccz2o=;
	b=wUQwejwszpAVMSFNLURDqQXNWQ3/OVtbO7Pt1EGhKqpOne3UbUafrpOkZvKofhKYrzxF09
	q2KFTWJI4QgHFP2cPRsu1428N9laLO3W1P1iLlf5EwX7lV/DLXVJtNUlhbIpSCrRKBI566
	nwy3ASIFOAcFj8TKWfAB4rOOlOXy3tc=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OJNnK0HS;
	spf=pass (imf18.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777061704; a=rsa-sha256;
	cv=none;
	b=DgcJGBLO6GRSeEzS+S2UHtctaAWWBsnd8WbTx5xdNdrEnHVfQhzVxbMP25Sa/Tyz/LvJRa
	T1eVo/Es8murnPt2hLirBGxee4b8U+AVc9nh0RQvwciBgLntUqg0t6do9+OP+GEEfHPWcl
	3Tq3msJN34oklN+7PmgMrUMq+ZarXL4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 581AC600CB;
	Fri, 24 Apr 2026 20:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7E3CC19425;
	Fri, 24 Apr 2026 20:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1777061703;
	bh=KzUsrlEb2R7AENvAL26H/Py4Pqyr7OWqzEYkyunJd3A=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OJNnK0HSXi9E+Fb3ZfHo/+IPhlqS+r81QfXB6vlpyEwCzfIxIbR2dmxdenoSyovNz
	 Tl/j5YX8+8Y9NDwMmJpOA8zOxCCprEAye3stUkRl6sq8HBv5oBhtmHCz6Vfq5fZTuv
	 HUtUPFNA+h+wyC35y2gNUbROtTAJ9nYHInjoHqMc=
Date: Fri, 24 Apr 2026 13:15:02 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: vbabka@kernel.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 3/3] mm/page_owner: add NUMA node filter with
 nodelist support
Message-Id: <20260424131502.3143b9cb291a4e6817aa9ed7@linux-foundation.org>
In-Reply-To: <20260419155540.376847-4-zhen.ni@easystack.cn>
References: <20260419155540.376847-1-zhen.ni@easystack.cn>
	<20260419155540.376847-4-zhen.ni@easystack.cn>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 57CA11C000C
X-Stat-Signature: bju7kubnty5ijxork46fymmsczdefawr
X-HE-Tag: 1777061704-998092
X-HE-Meta: U2FsdGVkX1/85J+SNbq1djYGPFiqm5h0EOJDW5iLsSbnCCU85pozJQPw+y8DiO4guHMrclivj8/x3e3UgiZocg+HSsDNFinEUJvDsDMds8fAmy6VpK0+0ZHSKznaZL2E9Wt6/hsxkoI66g6SFv8pKdW00TPBL6PPxfINgcMD6VO2e++vRSx4eAS2moIdb1a5IlLLS3N3jj5vcPxfb8uvyJfPJd0BrhtW/BOIk2XAhw3sVCNo8rXcyLGOC24Q5E59FvTOmTtI95cz7GuAYCOiA3Yp62Kt8poFncVjk+G6h25uVAG1QGQ0Dl1/19RDsvXhhtuG1OwDWyMwd/qQ3ScWZk04kEuEygAVJMH3uPN6xIL6IoWzY8bkX1ffz21igfWnDzW0epLCTXu8lVa7dRD8cmYf40ZOBJwzVq++rHYzRrAzvqwGsZVPsETN+9X2vbZVY5G9KsTknXmyxBLIJK7armcw/iafvonKNsHwlZUjNXF2Nbp2uN1W7b4Lk+jgTemzzRynZFoVy8Tg1gh+a8/jjtDH5w465s67kwG+PH0qgoYBKboM32Q3QRupEzCPwLMUuxMWQWetvFIwQ5XeW+Gan5SYGq5r8bI1vVgaGVEKVLYRRTLJ/PYp9VdPrEBhfd329yu2zYWUtXWy/W3s4DVcVXiok86PSYWGyt9l1OlKk0wzOSr0FnpJxL56lRRsuJjd0vvROJmeEC3DM1LGMh1n9MAPnNtkWzapGxE8TtKZrlcNOmYul1kzGnfPgk7kuL8syh2R9BDGz93HTmILxBkaQjZH/Qg5+5U8Inj/2kOR43wSqfcOVrgZlwEkM2ZzyAKa7jSqkjIgXwB2kZxJy0H1o8i2c3n10DI4IE1bmhwB/0mGEn7IYA0/b4rN4o3keE3ezIqlAWmiOQC3tvQH4ii8w4EgDeYRtyI22Zp33+L79S3tCT7dzayeWN8MxcANjsXwejX/DWbuJz39nnhYHp7
 sfcqiqfP
 0GpR8j7TzcEfvXUFYIBEk1v03kkBdlxKg1diZQvxQ/u8kIBdq3tObFWaoG/2wedwuWJN23KmGkiBNIbvqeqAEQ9oI3sqt632QXMaHBj1McCAtDo2WGrnxL0+9xAz43HysOVdPwBA2RUSj0s/HPBn3Cq1gC9H09T7v5FWrZNeCkrsfOdVWt/f6seCf/G1PVMUE/k99eNIr0vsYVvhknKZ+23YVmQSNLSM0hXcQ5fNwQ6P4+xBGmQHSBpXJO/42F5zTmlVLf4IJkmHuPOUih30eEkvwlACf47RM6qk+7uV8DgF5/1uwdiKzVvxbguxgAfuxRDafOlAJioVyyktVi9iqHQ5MA/NaZ0ygKqnw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 19 Apr 2026 23:55:40 +0800 Zhen Ni <zhen.ni@easystack.cn> wrote:

> Add NUMA node filtering functionality to page_owner to allow
> filtering pages by specific NUMA node(s) using nodelist format.
> 
> The filter allows users to focus on pages from specific NUMA nodes,
> which is useful for NUMA-aware memory allocation analysis and debugging.

AI review
(https://sashiko.dev/#/patchset/20260419155540.376847-1-zhen.ni@easystack.cn)
wonders if it's legitimate to use READ_ONCE/WRITE_ONCE against a
nodemask_t.  And indeed, my x86_64 allmodconfig hit compile time
asserts over this.

So I took them out:

--- a/mm/page_owner.c~mm-page_owner-add-numa-node-filter-with-nodelist-support-fix
+++ a/mm/page_owner.c
@@ -732,7 +732,7 @@ read_page_owner(struct file *file, char
 			continue;
 
 		/* NUMA node filter using bitmask */
-		mask = READ_ONCE(owner_filter.nid_mask);
+		mask = owner_filter.nid_mask;
 		if (!nodes_empty(mask)) {
 			int nid = page_to_nid(page);
 
@@ -1049,7 +1049,7 @@ static ssize_t nid_filter_write(struct f
 		goto out_free;
 	}
 
-	WRITE_ONCE(owner_filter.nid_mask, mask);
+	owner_filter.nid_mask = mask;
 	ret = count;
 
 out_free:
@@ -1059,7 +1059,7 @@ out_free:
 
 static int nid_filter_show(struct seq_file *m, void *v)
 {
-	nodemask_t mask = READ_ONCE(owner_filter.nid_mask);
+	nodemask_t mask = owner_filter.nid_mask;
 
 	if (nodes_empty(mask))
 		seq_puts(m, "-1\n");
_


