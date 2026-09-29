Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 00954CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 21:53:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D8AD6B0096; Tue, 29 Sep 2026 17:53:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1ABE56B0098; Tue, 29 Sep 2026 17:53:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0E9556B0099; Tue, 29 Sep 2026 17:53:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9E5A6B0096
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 17:53:24 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 52B714063F
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:24 +0000 (UTC)
X-FDA: 85268151528.29.93A0F0C
Received: from mail-dy1-f198.google.com (mail-dy1-f198.google.com [74.125.82.198])
	by imf21.hostedemail.com (Postfix) with ESMTP id A3ECF1C0004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 21:53:22 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iSVdoI8x;
	spf=pass (imf21.hostedemail.com: domain of 3UDO8agoKCAUsnqf30fnxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3UDO8agoKCAUsnqf30fnxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790718802;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=e6MALMUB95W7jnY9HmZglriqu96XwkYJATP3d1B7IV8=;
	b=zMAPDYuHLXj55r7ZeGe/CaW9wOjb1Z3zv7puLDqErXBVeDFCadV2sQdk+5yRd2OckKe631
	3T0nq3NLAjTQqTeGnIZgHFJ1Q/R1XiFuEGWOqgp+HZJJsrG55gTxDQMZhez/Au3H+WQpXr
	V32PEZzz0bzBMdFwoo1hDem7izBi2Mw=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=iSVdoI8x;
	spf=pass (imf21.hostedemail.com: domain of 3UDO8agoKCAUsnqf30fnxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--nilayvaish.bounces.google.com designates 74.125.82.198 as permitted sender) smtp.mailfrom=3UDO8agoKCAUsnqf30fnxmlttlqj.htrqnsz2-rrp0fhp.twl@flex--nilayvaish.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790718802;
	b=ihgl9H2oAaXR46E7zUodBBtF0NfqU7rN0uZilSArNkYOT4WtMUqWSZltAKj/SnrT0bY8DM
	t0nTB+nau7V2Tl50wVseGJujHhEFK+Z7keKC/E8aN/HfzO5/wbG1ygjV4e1XDkO8rR1Cq0
	DHyAwRgU5awnKUdFbu1wSxOR0dKu3Cc=
Received: by mail-dy1-f198.google.com with SMTP id 5a478bee46e88-34344599f01so3532798eec.0
        for <linux-mm@kvack.org>; Tue, 29 Sep 2026 14:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790718801; x=1791323601; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=e6MALMUB95W7jnY9HmZglriqu96XwkYJATP3d1B7IV8=;
        b=iSVdoI8xFzwOJcltEqQhvOUmr4zSh19kho20zttImM3x4Z026Kqyp1JTTDzbmjJhEM
         AWY5XOnsLuncVlSe+UyGSlW0FhloQRuYtNveSKMCWbLI/HlCEA6tVLCbj3sNoWVAaJdC
         6oV2PDkUTMS7IK+GOrPUYz5K++F3/JBmIau5EmHprvjZvu4WuClrtbNAwDAlL0iwUgSp
         H44C3kddbbfOTLm3AMQ3aLH7PsiAm4zV5KtmUihALp+kDIvp+nQ2Pm9T6+tCQYjPBjkY
         NAlT2syuqptpOfXkC2soNOJu9ZUxQTbIWXs4GUs3klo31jbCTXSCkKt1hsFEKwNNCLT+
         CRAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790718801; x=1791323601;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=e6MALMUB95W7jnY9HmZglriqu96XwkYJATP3d1B7IV8=;
        b=s/v+dy+JNFdo5q18dxK/N4cGpwKYSPVbTKkjQG79q+7brdTuFl3GZci+CpP7ncntf7
         omtyza71RdQxc2sKntCVx9ckPDb/Z6r6alqL9iEGNhQN96XTDnRxk2ZTzYzUQiyDLhSr
         z6x734q9ao+z5ESf3HX0hBJErcixalfHEp0KJGZ0SNjJYLyv/O6d7l5SNQYGkLppb4RZ
         Abbe2vBlG7qr69VmaeflxWCWwJxaCDScVu07U5PaQG9ltvYFjFNumm1v6oUWJ/bcDkrI
         iAJGrqKn9S6f4/CB5VlE+zLTMYBI1t+JnuX7Q89vANagvLpfeQR981vM5DqGR9t8Tvuq
         FobQ==
X-Forwarded-Encrypted: i=1; AKwUvBz2Y9+1Q+aN3aVqxZmLrEneWhILfEE3pV3Pv4uiPjuxj8o18YR3kMV9ZCb6OEea4sp+VFfF7wBnZA==@kvack.org
X-Gm-Message-State: AFuF++kDFbEvHHySDZhGga+pXeB99j5KONrdOglK/1qzBgRbMuqLYXBe
	ezxrWGA5tHu+3WIWdt7j731BHaEaEda65lOktZq1FRH5fYXgukWFsAGVsOuZQZ60e4/uscPuk4u
	lYqs9uznMxix383q/87Am/Q==
X-Received: from dlbox7.prod.google.com ([2002:a05:7022:1207:b0:149:432f:988])
 (user=nilayvaish job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:701b:4314:b0:143:271a:8b82 with SMTP id a92af1059eb24-14c9e8643a8mr511036c88.44.1790718800896;
 Tue, 29 Sep 2026 14:53:20 -0700 (PDT)
Date: Tue, 29 Sep 2026 14:51:56 -0700
In-Reply-To: <20260929215206.516490-1-nilayvaish@google.com>
Mime-Version: 1.0
References: <20260929215206.516490-1-nilayvaish@google.com>
X-Mailer: git-send-email 2.56.0.rc1.315.gc6ed9934b7-goog
Message-ID: <20260929215206.516490-6-nilayvaish@google.com>
Subject: [PATCH 05/15] mm/hugetlb_cma: use folio_page() in hugetlb_cma_free_frozen_folio()
From: Nilay Vaish <nilayvaish@google.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Matthew Wilcox <willy@infradead.org>, David Hildenbrand <david@kernel.org>, 
	Greg Thelen <gthelen@google.com>, Roman Gushchin <kfree@google.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Nilay Vaish <nilayvaish@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: A3ECF1C0004
X-Stat-Signature: ioe4wb9bidnd8qx96aau5o7rhnxgcsnm
X-HE-Tag: 1790718802-284242
X-HE-Meta: U2FsdGVkX1/A5mywPQc2D7uO1MiJRjSD/vE8/hvmCy1ts9WCpzA0bGnesQmEV14t9JBm2FbdHP3VXv4Peb7aXVayJjjpe5bIm4tBSB3hal2c6PSSbYbF4XOHloGfBJU3RMiKULNyH7YZWYczYcaOpdlhrH/veVmm+d3Bgmq+JJxbL1YbBk98bQYuqVn05VwwhSHKKXUR1e9vsjVXKeN9wSBOFBzJh6RDzGPoV334SXWoKEVhTpqZqcaa20XUxeoBFV7gHnw3yYgVz59A8Dbr0NFQ1fs9F5Gf08vUxjyBulGo/KBrG2lmCATETZv7uWtxQz3FjcdfUdazF4gP//forw1p9z2njDQqDZ29qLHLrl+BkA1xrolXzd+urG1BL7DdOPoLCv0JN86RFmr3ZkWYSkp8DI3njRkXaIxaY2pUTsGJGZiDIKYWiGbRzNpc9qVEWQX5+Yk8RFDfGAa9/x0LprcBxVbBuDZfYBw6V5wCYnulawsJL3avkMSXW0no9VD2DGb2rKMb+xn1dbw3fOzLVKB9byStfj0wddnJeTNbq8Co3UQ/Mk7ytSsGT+STCNmzB7AJWhEMVDdze+ZIEPUp/QZZt565ueI8dn9CBXUosclwZDrNJzZVjUgWR563TjAfdcqhqzYF6YoUJr1ayYAZR+2KmWcX+gmRVzhLRycJXmsuvK32k5Mpeq7Ak/x3eTic4E8FniOQZUM4xwU2zqgODC6s8wDE3NBA8IBgQ2+BEJ/Wl3PjpGIrVjq2I/SWRLxed9cHrc3hfvq+iwj3n4KF1EF2eJCAX0BTH3nhxLIDFM9ZoXQm9uLkdkQZh8RMsERmlR7vofVHUwt5Te7mjnI9oR5jXt7zeGBdzUiNgvfy4hQ6Srr73kGSgZsQciJsIi1y2aOfwrr9Muu0NarZgJBRfYxv9jdy/Hv+CoXQRFG02rjHLa4k95lT08LwvUJ7CXpA5CCPpSOiqgJsoxXJl+A
 3VJzYtmK
 vVV3qrTpIPazK84PPeDd9bzDZ/G43d6X+sNOLgZjs1Mj3O7FDAEvl6wSKRrtj/k3N3ZIZreq1yob3kzroDqdCAQ/XxmZ2viqBv0hO0xSiRy8L4ni3tTBO5JgX1EOhf7vMuwi3b++QLX0htcJ11MaQwYIHerHP735dlzn+EK2XTiBHL6mDuciuUzY8o+VbwupHoDSQEYIxP22Mx5QUUKhlQbZZIkX3oQnc5uh0gTzE+61JtawnLsZIsKEy5rG52zuNe5jzHlOXeLwjIvKKSjkbto9me0rUPhJw7P2pXXerL+bGYeU3UlgeA943KmFVJQnFqPv+ZSOGB3+D/OKe1iBNaJO93XI/LuLuUGSq3AwytCIMd+tOtZ/5cy5qtsRMgH7jPV1gLcgNPjrRGvLbpwFhfkZyJHZS56esTfAWq6o/eK2vXty63vrH+p7m7hl1OmKmJ/U+8a23EBbyuIKW3LOUnNsuRtR5xBfZRDB71C8EOIOsMv+mmT0SZTaeH0HUG6hQPE3vbk/k5DQk10wT05hEqUhzGy79YQwc8EROidBvz/ICK/5W2VSG7iDwxaeF3K6ELv5Vm1jYrp6+HWIr2gqdynEEPN+W73oe2NWC10GY6reS17S02cu/vkQHleIZK8rwBeDliAXmFvcsF5nnDFtr3HHnHg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

As part of the memdescs effort, struct folio will be allocated
separately from struct page and will no longer overlay the head page.

Pass folio_page(folio, 0) instead of &folio->page to
cma_release_frozen() in hugetlb_cma_free_frozen_folio().

No functional change intended.

Assisted-by: LLM
Signed-off-by: Nilay Vaish <nilayvaish@google.com>
---
 mm/hugetlb_cma.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/mm/hugetlb_cma.c b/mm/hugetlb_cma.c
index 95fd2d190f0d..e0fdd07cc6a9 100644
--- a/mm/hugetlb_cma.c
+++ b/mm/hugetlb_cma.c
@@ -47,7 +47,8 @@ static phys_addr_t __init memblock_node_memory_size(int nid)
 void hugetlb_cma_free_frozen_folio(struct folio *folio)
 {
 	WARN_ON_ONCE(!cma_release_frozen(hugetlb_cma[folio_nid(folio)],
-					 &folio->page, folio_nr_pages(folio)));
+					 folio_page(folio, 0),
+					 folio_nr_pages(folio)));
 }
 
 struct folio *hugetlb_cma_alloc_frozen_folio(int order, gfp_t gfp_mask,
-- 
2.56.0.rc1.315.gc6ed9934b7-goog


