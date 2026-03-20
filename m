Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 730A11099B43
	for <linux-mm@archiver.kernel.org>; Fri, 20 Mar 2026 22:14:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E06D16B00F3; Fri, 20 Mar 2026 18:14:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7CC6B00F4; Fri, 20 Mar 2026 18:14:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA6C26B00F5; Fri, 20 Mar 2026 18:14:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B9FC36B00F3
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 18:14:36 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 94EF713AA02
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:36 +0000 (UTC)
X-FDA: 84567846552.20.5B6CE44
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id E00D5140014
	for <linux-mm@kvack.org>; Fri, 20 Mar 2026 22:14:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=he83wHJ6;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774044874;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GjZkwcZnHcoysgZGRhm9lBLN0WuFvf5aQ/6CJIR1XZo=;
	b=Lr0Xmm6zKjZWjPgPR7Iu7wWC/agfmJg9n1gdPQnXEwD+TmL+aKpcqlV750XTD3WMspg0fh
	4iZUiZn1uoQLPP21L6QoJNaml7BkeUH4hHqd5h9VUmifoxD/5JRzrquEgS/ugA1dBb+Vj1
	qBm4d1Em7p/rpmTUMVyFZ2YHIkOLo3U=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=he83wHJ6;
	spf=pass (imf09.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774044874; a=rsa-sha256;
	cv=none;
	b=R1qwCSckNNawUflvrJW7czI6+0B9wxHRD9iE3hkvN+4TSaXsgaSPSA0EeRb4HWxpJLZHAM
	Nk/BpT9535O/AK7Cy3iIQR2+vaLYJWrZStzljQ4DsCLjyx5bmR4JsIzXORumYSEAlc2uct
	C+tHtWCQX+sPyC/5m1mscMkTSuB4ZFQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 733B260142;
	Fri, 20 Mar 2026 22:14:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80082C2BC87;
	Fri, 20 Mar 2026 22:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774044874;
	bh=XAHrKqjSHvtKR09gmzZ7AHRzSFFlyVf9ZATZwJh+JJg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=he83wHJ6PtaTiQddZeECQUCHe56n6mKcu8hA4rCvY8qPeiTp9pvI0nuQaIgKVVheS
	 fwqIjKoF6a2O37LFplX2/a8iqRJ2y5b88VJmAJjAexMzHSr/d+OXTwuH0/n/aw/2kG
	 pe8AoJbYZCphhAsSJt9zKgebzodTB5GHH/Koby6PCMOF8Iu1iXweiApBOX/ngZQOY8
	 Ut4FR3P0CEhcyvu0plHJrghUEKD+R8c6gIhegpQU8Pn0h1NNnXjHlTCsHWDRdaxfCX
	 tzIzJ9xom8PLs1C920nHcEa68Y4UbWrSPDJXagKphEeyEcTAcA/nAsU3gkKICSeI50
	 plec3jOq8bwZQ==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Date: Fri, 20 Mar 2026 23:13:44 +0100
Subject: [PATCH v2 12/15] mm/sparse: drop set_section_nid() from
 sparse_add_section()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260320-sparsemem_cleanups-v2-12-096addc8800d@kernel.org>
References: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
In-Reply-To: <20260320-sparsemem_cleanups-v2-0-096addc8800d@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Sidhartha Kumar <sidhartha.kumar@oracle.com>, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-riscv@lists.infradead.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.13.0
X-Stat-Signature: 3dwrie7uycbmnkghfgudixdej8qcbxyh
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: E00D5140014
X-HE-Tag: 1774044874-26994
X-HE-Meta: U2FsdGVkX1//3uoRpYZP0gelVgos9sb51RMgz8CqfRC0K8SXuNzED40SNZJSWQsy9f6pHOBzNOHoWyzPvY6T3BNiVC0qqGfN6hjIcXvor7sf1HSFoo+CEQXlE/igJ0vk+Kyd4cnJ7xJwdpFQe1Qg9t5nF7SpZff8nSLNKOs53uFAiFdzEMlADbPi1nnqgaUHHogEBXpBQF8iDAuDMN5TNrx3X043ocrlqBe9H9elMtPCy/Be+U10HVTnyWkSL5rrDGaCEP9nub7kz7oCq8WI6p+GFkJE7wTAXlqK5YvAitwOwpfO1KJAlD4UCJyXMzM0xGSWqxrvBO5ms98fDjZicNInEe7qPLniy8taEHG2weOyindPz2a0YuMVctnGgi9WwDu/HLIjvLjJhTAdep0lJBkXl9EK2ydyNodo47Z8SWv0uZ4paK3kCHi6T77AaYvp++Dd9xL2fP7fNw6EkJKzvo6q23Clf26Rh3za4ZGnFgGwqIWpGAF1PUatC+drsgg1Zj92V74+xacengo0CFcg62/2lyY7AdUDxyK7WJssaakFMe5zy2yot+gb7xSwxK7tCLpA0gXh9/IY8Zq7KoOSXfKogKsXWOYfEgyQuSBE7pI3KdMSkQHCT0XBwdYmNsb1yb7WF+LzfRa4s/GsZZlF+t/HSIRoUlqh7PGY3brw6YuJnePEoXPoFCDcDmT6t7j7YYxdpCnG6eymQmXZM8EGHK43ZGqItuDgCMaV6tR1QV3hgl3/yr4TXmvvr2VhF1QwMb19y3rIt58z0ZBUdni7luzaHJ/MwylT+xkK8CHXEEqk5n+Qt8SOXRNdDZEq3TiUQDxazZWb2uK2jdXBW9mmyvnFMrGPlyK8pVe6iLkZour7oSWZwlOYyzUpD8jX0ahAMtUo5ZS73ClSjrjp9JPc5xyHUDognK2NdPwgzhw40Lg3FUKDXWozH5jPSDGmLKQZgEfW2sjDB4ApLRklLqH
 PaESx9mu
 2D7AbscCwDVpAsjapw05Ot87TFkPcPI95pGLVlVL7biPJf6s/JuG4eNrkzjTBclELVJhPfs+4WfMUMYFcln3UjZHwRkQ/kht5Ig0fMLszpMzFz3atuX7kxtsDhnOcHcg5ZwQfTw+v+tYF4ja74QLVMb4W+19qGTHuAViCfw6IL9HhNnh6uT/K6bl7vSJWSlhRlAc0sHSmgubDcLi3JOwAPFzhVfqFMZTUcTcn8IaedbrXJ3yE+7ppRdhqJMIXg9PbV0X6dKFAMbcF2JAEaK+Sdt5nJEb6HnrTa4R9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_MEMORY_HOTPLUG is CONFIG_SPARSEMEM_VMEMMAP-only. And
CONFIG_SPARSEMEM_VMEMMAP implies that NODE_NOT_IN_PAGE_FLAGS cannot be set:
see include/linux/page-flags-layout.h

	...
	#elif defined(CONFIG_SPARSEMEM_VMEMMAP)
	#error "Vmemmap: No space for nodes field in page flags"
	...

Which implies that the node is always stored in page flags and
NODE_NOT_IN_PAGE_FLAGS cannot be set. Therefore,
set_section_nid() is a NOP on CONFIG_SPARSEMEM_VMEMMAP.

So let's remove the set_section_nid() call to prepare for moving
CONFIG_MEMORY_HOTPLUG to mm/sparse-vmemmap.c

Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/sparse.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/mm/sparse.c b/mm/sparse.c
index c96ac5e70c22..5c9cad390282 100644
--- a/mm/sparse.c
+++ b/mm/sparse.c
@@ -765,7 +765,6 @@ int __meminit sparse_add_section(int nid, unsigned long start_pfn,
 	page_init_poison(memmap, sizeof(struct page) * nr_pages);
 
 	ms = __nr_to_section(section_nr);
-	set_section_nid(section_nr, nid);
 	__section_mark_present(ms, section_nr);
 
 	/* Align memmap to section boundary in the subsection case */

-- 
2.43.0


