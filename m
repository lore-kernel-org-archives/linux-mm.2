Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D25CC61DD6
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 17:11:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3AC716B008A; Sat, 29 Aug 2026 13:11:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 384746B008C; Sat, 29 Aug 2026 13:11:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 24C906B0092; Sat, 29 Aug 2026 13:11:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id E0CB96B008A
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 13:11:31 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4A8B58013D
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:11:31 +0000 (UTC)
X-FDA: 85154948382.08.83890E2
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7B0621A0005
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 17:11:29 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YIoP7l91;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788023489;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=K5m/rmCWnwafcoVS/zA/mPp2kr4G2N0WDNX9qd9eijg=;
	b=z5SxU10ymQR0GjjPwoHkDfwna9P9iRnI2lcU+dOj/J0UOy9kLqklbCKHQudlkSG2EFOZmY
	IfgZ8mpfNrEno4H5nuHyXmTK7CcQoTeVCSSulM7VLLW3gHjm+0KNaGhAC9hJFqbNthfqxb
	sFkmNZveOJCIprYwEnODOWDh81h1B+g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=YIoP7l91;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf19.hostedemail.com: domain of thnkslprpt@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=thnkslprpt@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788023489;
	b=0ANW10IqBtb5AcZltSoIml3jpkLyLQFkr0KOnLBl/oY3W/kZbygl02CoWr9EhdByGKvF7p
	caIRheQG9dgj5W9KLPRbio0dCWmIQ8u56TeEKdub6UQFtK1zfL4jNn3XD2LM19ddGQBtC3
	UnNVVMpJOvzF4uEHI6sS3uBDNhGNXXk=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4954a9e8490so17459025e9.1
        for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788023488; x=1788628288; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=K5m/rmCWnwafcoVS/zA/mPp2kr4G2N0WDNX9qd9eijg=;
        b=YIoP7l91DFLZD6xzDffbkZvRna9m+7A2pgWUTdcUcjweCWBiRAVfoMeMEk2wXFPKpy
         pNUdIG4ir3GPL+XJz035CuX4Z8E6F5hNQE9cNcFB/8/N4klk79U/WHPZCPCq2oT3qPH5
         NWegO5NkRMfBg24TnD2e13/7HwccyGoFcujrNO1bxTAqgvr/alQpPY7D+PiqijcuG2Ee
         Eh50tjHmLRYowKr0pW+Gb8zbo7ePAO5WUXGCtv7r7VDJ1FVpYC6xr1O7FSdfAKWChO/y
         IXSlxGZYVJNr0jkFjvB2l83DSF6qfHIZg9R4btNODZE+PJPXS9fk3Bwt13OgfY444Dg6
         /TTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788023488; x=1788628288;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=K5m/rmCWnwafcoVS/zA/mPp2kr4G2N0WDNX9qd9eijg=;
        b=mr8eoh5lm/KWVgqAf9h6pquC35djU99WIPQr5C9uD7RYMX0a+kuBncFXCjTP99y6IA
         IrwbwW3On24xDMMywHXGgNQSks/eLrJpAFOxdvyOnxKOY9IC/MiX0RUBCeSNetjSyeYj
         C6LQLIDlR87NE4Y8kkkLDAxxMjTnhIZvkOK4ncJIPCJdSqXjRwLYZFEbbfHQi+F7/0Fg
         QyiVjHzrllXJFP9uDNxux1eZLvA7YwtQKuRvuMuNdNolNGUa0z9wu7Y3+hAKaJRqVur0
         KOZtD+3GvQgRT6SNRfCScgigmCvss1Oan/r9YJ4MpB2+aoullZhAoua2oZvPDMAaGuLr
         RrMw==
X-Forwarded-Encrypted: i=1; AHgh+Rq9kH9/kLet6Ddtkl/YLMDXDlaldE4BxaNQQxO0a18mfNIIy0vrZpZBJ21KEWglwNLq4d7/obJYkQ==@kvack.org
X-Gm-Message-State: AFuF++kjmDZCR/PEeycSVl5fbNjcgHjKdRsFu0FPmNMbiQ/uQG/OTat5
	tTPBbvtENvOKMsSHC8GP+HAXwM7vR3eS+oPK/wYr7nLkrnYmyXgtGEe8kgrTdnB5v3k=
X-Gm-Gg: AR+sD10Q1v6b/Tv+vdnE/9rY6d1G99BKjf/PJh5LDzaQH4XPC5CbK3RwoLWUWPkPt2m
	50t9/OeT8YhPQ75gQzZSdTltRvCkOcJ3I6HDHji5W5DWCTEgDS/1pQ/WKuG23LDBFDWwaLwrhvS
	xF0T+lnZwz8NB8CXncN2jYwkzTBApfQ4K6vAwshuGuvBtGFlivTWlgvYIWy2rUznmemtjQDlBKa
	5HcTTWNyf3iIjLdO8dW6E4UfJdY0ntF3+9DfLK+DCWBEx5lfbopt4I187oW29jSFbknl7+/Dv4J
	EbxmS3KCCfYnCnmvuEPttmdyMILcyhqeWA70zL/tCHmhpyfnrHaG1W93zMBGMh3+vvO9Io0mPg/
	HcOuUHLocm6dVeAiQxNXhQ9IEZF9vArcXmqcW6ue/5ETejp6WbaboAkqIU9fWXSx0PEET2E+5zs
	H8eLwwVmAWj8nBVYoKgLPYA0m2Z1OsyMNcXbZyf6S81/Wob0T6pwx9hFuLPQAAFIAPT632M0UNo
	w4pv/Z/dw==
X-Received: by 2002:a05:600c:c4a7:b0:495:5d6d:9cc1 with SMTP id 5b1f17b1804b1-49cca26ceeemr113194285e9.0.1788023487985;
        Sat, 29 Aug 2026 10:11:27 -0700 (PDT)
Received: from LAPTOP-AVI.taile24b5.ts.net ([2a06:c701:4cef:8600:c993:2682:3ff:b27])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49b9500c7cfsm154861105e9.11.2026.08.29.10.11.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 29 Aug 2026 10:11:27 -0700 (PDT)
From: Avi Weiss <thnkslprpt@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Avi Weiss <thnkslprpt@gmail.com>
Subject: [PATCH v3 1/2] mm/memory: simplify error handling in insert_pages()
Date: Sat, 29 Aug 2026 20:11:12 +0300
Message-ID: <dd3a672c858b38c7525541b19a919e120c4e5a0e.1788022178.git.thnkslprpt@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <cover.1788022178.git.thnkslprpt@gmail.com>
References: <cover.1788022178.git.thnkslprpt@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 7B0621A0005
X-Stat-Signature: 4psj45oecgctxnfwkzm67mpugnez9jb9
X-Rspam-User: 
X-HE-Tag: 1788023489-785817
X-HE-Meta: U2FsdGVkX192BFj6XlQUz/tuO8LpZDa73KPzzBzKwyizFvHDdRUiRKq1JTzXDJ2fcOPdTeWt6ch3HKxMmXz2e7PBlknUe5ybhbl0wALK9Yc5VySAjj74KaEPbPHZKxsVRzEw8yA5lzedvuS6GjM4ZTQJygatB88VUIaCWwbDXcjZbk6npVtoTQdwTiMXxP4mIjB0P1B8GePrzjgljpaX0OeakdPfu/YqhO4g33ZNow9zfAtc+QB6j+AAsMXYuk3shNZ/ABjC6L9uklmUXplO2SKgxv1l/lJlW0Q+sOxeC23bvUozL1VDFf02LcwKXWyGV/OIw5TWhYaSSrXnC/RueU/sJiPRR41hi005eMdwWlruKsamBhSxVkkXOOcN77SNy0uUmD4LErpPBJg+JgzodVQopN8pKNoNQwaH8Q1RfKQ5sMFcr/9HPcPhXmW/+tazdCcc4UVCU0QINglVizmtBxl1vP+5Dhe4Dy++pNzql++Ub4T09sPW41pI8mHd84jLG/eDniqZoA9KuFr7NAmnAPraVga84xRzAKSlUtjaTli11wSKsyWAvVLaF0t++hwhfCsnCEK5EutABEkV3hldl6g8NPX3Y5QauLTzU9W1n5B4KmJmfG99cPmA23FehJ6khtWZcDyuyrNkMeJfDQOmUGIe6Pcl54qdaFhkJa/Se13frkUWdaL5vUvjL7h75qJLijIKqFb4Dlj/1KRaF1zUY8V6TKe6wfn57mSgIl9T/CMCkQUSnR30taYdcQtQiXI5vSrHyJ9JsPec0fy8gbHbHUDrz1mi/aBhyiJ46RO4QYpVo2cFR0BHyq03Fq4dYKGI4c+99Gg6V/7DXEe8jjWBApJB4F+/zOuB57wrbSGaK+gWAFx9c93Xxy0X1w3xvsTSKwYJ2/lLmn4cVLzqMVpXI+78v2JTZ/YP+Jvj8pmil8pz+BY5IDmUoXI5yuIDJKjcucBYIWaaYQ0mKGo8rFO
 pHFkTRTr
 fRbfJbRtw0pNP4xk2/XGCBbkTMYfpKSvd8NRZqVjfW5A9nbyI6aBWP7A2U43zFZAbwsOVOEkpgvMSf7XfhANnaWbnLVSn9wxxW6RJmQMRZkjk6UrW8PF2/RYMXajLiDi/EBRNuu400ITld+deNFJNy++8A9Xq0/R57bVTlZdDhwk2tFv8cEgd/6aGWadK/rjcSPCqm1EPkUP2shTxwCbpD3YE1wz8WZXrXD3Ue0psMiVTi0XxgrAxLnkgRBuko1wB2U78z6MDQZ7LvuEL0SmW0p8yBsqaci00J5iK+G3IplXrTl2sx6pxgnzZT+glY3Gt717GgPM2gb5O2hFqys0DTVmuksvTy5QbVfyY0Hg7tF7K4ZbuPxGuIFVRZyjT/SwhRKuTtls1g5QmpaPOMJqIx5PSNVu6PdF9HzWTWS6u2nEC0CG9kvqlL8k3ptLPkQMrE8kJ66KDKugN1+jGandZ4U1XBs908V3vYxEjihxpE312uh/L+OZEwfULTmLDDL2/DdL2ih7NTPQspBs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Initialize error return status to zero and then set it as needed at each
point of failure.

Assign -ENOMEM explicitly when pte_alloc() fails as the pte_alloc()
macro returns a boolean.

Signed-off-by: Avi Weiss <thnkslprpt@gmail.com>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
---
 mm/memory.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 9cbce5c90bff..2561dc6bdde6 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2565,20 +2565,22 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	unsigned long curr_page_idx = 0;
 	unsigned long remaining_pages_total = *num;
 	unsigned long pages_to_write_in_pmd;
-	int ret;
+	int err = 0;
 more:
-	ret = -EFAULT;
 	pmd = walk_to_pmd(mm, addr);
-	if (!pmd)
+	if (!pmd) {
+		err = -EFAULT;
 		goto out;
+	}
 
 	pages_to_write_in_pmd = min_t(unsigned long,
 		remaining_pages_total, PTRS_PER_PTE - pte_index(addr));
 
 	/* Allocate the PTE if necessary; takes PMD lock once only. */
-	ret = -ENOMEM;
-	if (pte_alloc(mm, pmd))
+	if (pte_alloc(mm, pmd)) {
+		err = -ENOMEM;
 		goto out;
+	}
 
 	while (pages_to_write_in_pmd) {
 		int pte_idx = 0;
@@ -2586,15 +2588,14 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 
 		start_pte = pte_offset_map_lock(mm, pmd, addr, &pte_lock);
 		if (!start_pte) {
-			ret = -EFAULT;
+			err = -EFAULT;
 			goto out;
 		}
 		for (pte = start_pte; pte_idx < batch_size; ++pte, ++pte_idx) {
-			int err = insert_page_in_batch_locked(vma, pte,
-				addr, pages[curr_page_idx], prot);
+			err = insert_page_in_batch_locked(vma, pte, addr,
+							  pages[curr_page_idx], prot);
 			if (unlikely(err)) {
 				pte_unmap_unlock(start_pte, pte_lock);
-				ret = err;
 				remaining_pages_total -= pte_idx;
 				goto out;
 			}
@@ -2607,10 +2608,9 @@ static int insert_pages(struct vm_area_struct *vma, unsigned long addr,
 	}
 	if (remaining_pages_total)
 		goto more;
-	ret = 0;
 out:
 	*num = remaining_pages_total;
-	return ret;
+	return err;
 }
 
 /**
-- 
2.43.0


