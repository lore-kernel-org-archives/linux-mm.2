Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AE50C531C7
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 07:51:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A0F466B011C; Thu, 23 Jul 2026 03:50:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 998D56B011E; Thu, 23 Jul 2026 03:50:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 887DB6B0121; Thu, 23 Jul 2026 03:50:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 570ED6B011C
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 03:50:59 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id D25E61603DA
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:58 +0000 (UTC)
X-FDA: 85019270196.07.11B2C6D
Received: from mail-pj1-f69.google.com (mail-pj1-f69.google.com [209.85.216.69])
	by imf21.hostedemail.com (Postfix) with ESMTP id 1CE801C0003
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 07:50:56 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V5aS0fBH;
	spf=pass (imf21.hostedemail.com: domain of 338dhagcKCFA1GwAusAy66y3w.u64305CF-442Dsu2.69y@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=338dhagcKCFA1GwAusAy66y3w.u64305CF-442Dsu2.69y@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784793057;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FxjTJiqjVFLTCaDJDgC11KYRNKaCxojd2JWjTxQwclM=;
	b=2Ryh+DJ95EHf2ZYf2KY4Fjgw6nZcZulGspWutt2NGf3slhAJI3RRiuJvC252d8uJgPVZYc
	4XihmTU1HEfqMh9m4IXc/2dwMWR1KG/6kZFxTVn9uKWzk5YTezpOZ/TysOwoO/k6vlgDGW
	zc0ZCdlTnR89IM1y3bt0rNyfwt/Pk0Y=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=V5aS0fBH;
	spf=pass (imf21.hostedemail.com: domain of 338dhagcKCFA1GwAusAy66y3w.u64305CF-442Dsu2.69y@flex--jyescas.bounces.google.com designates 209.85.216.69 as permitted sender) smtp.mailfrom=338dhagcKCFA1GwAusAy66y3w.u64305CF-442Dsu2.69y@flex--jyescas.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784793057;
	b=t2YuY3eLe2DHIevFIynWXkCuSt2aSl0/u0g9gfGzZBpPbIfo4It5x2r0uvDlS1CIeuCvOX
	pySp0omF+83S211KqgcEXOawGfS9MCk8g4OUTnLlrmYlJZe7BwApggr28B1PIB3ABbk0C+
	G2ARRVTVeMSgyAmbuC14T0sDZPDk0rA=
Received: by mail-pj1-f69.google.com with SMTP id 98e67ed59e1d1-38e2237bc43so961320a91.1
        for <linux-mm@kvack.org>; Thu, 23 Jul 2026 00:50:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784793056; x=1785397856; darn=kvack.org;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FxjTJiqjVFLTCaDJDgC11KYRNKaCxojd2JWjTxQwclM=;
        b=V5aS0fBHcsa3vwBtmhXZGlxICCNeQ5arKM503t4hBr6G3TKQTLKIPNAOde0NfVG7Km
         o9wG6vyERZDZjS9TdZhmmU1UN1FHKJpfMrHLWrSS9EQ8DC7M2KuQ+bVRvNc3gGmevIJR
         impkAsxgyIXxiq616V5Par5LmcQOYVRqUrNs8Q97FZKZVeFDRZZmfuCvf1wJktz+R7KN
         dCq4eo17HnvGEJjCzUZ0bXCO0zQHULOPmj6u3w1RMq/3FakJS/ZcgXSlog7i1DmxQFEQ
         M1bR7MkGUEBhxmc2xjFZabxpPtH20CGMoKARerDD2bVYVHTtTq9hDLZklfxjuydKY27W
         Qp1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784793056; x=1785397856;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FxjTJiqjVFLTCaDJDgC11KYRNKaCxojd2JWjTxQwclM=;
        b=GzWAnFwnXQn0Yq3Yn4NVvkJxOwRbKDcauW6m7iVBpgumNIh86UhsWLulO3qyhEm67A
         bas3SqUK0GRmSUsRKbjMSNTUNO5adMl8cF5XQyqSmBcFjRQ33PcTMQ51avrOrzvmEBu2
         /tW8GW6q3rjHP36BeZatbXpr4uqCRGXRyPUaO7JwD1v+r1oGsZeAXxd2myJOX6hOMzb7
         G6cTLUNZtzqSmcf8inXYGKtQvlj19JWjXBlh8urdsebV44E5x9oZ+Ie94So/yi7HvSnG
         xON0IU5nAZs0m67Gq2AvnO4u8q/yl8kP5JTqy/bKrKA3eqnKfzRdADZQGdKmcjzFNZ8+
         iKxQ==
X-Forwarded-Encrypted: i=1; AHgh+RrgsVvIZ+hDEb+l8Gh1JyYlq8JbtrA5/VWILO3ZPYYwEX8AtSA6E9b04F099qNtbTM18n2cI2kv5g==@kvack.org
X-Gm-Message-State: AOJu0YyavRWbu7pn04zbw/Jmoyn98B+rRbVv34yDFh7Y5RosT0re2zEO
	q0mVERSt9vgFhvf13GvNTt3wkQ+EGX/9SkekxUswZCcHM3bslNkSa1DnBp98H8ntHMgtQ5hE8a8
	dga4q6OtcwA==
X-Received: from dlep8-n2.prod.google.com ([2002:a05:701b:4588:20b0:13b:a040:bbf1])
 (user=jyescas job=prod-delivery.src-stubby-dispatcher) by 2002:a17:90b:4a83:b0:38d:ec31:4840
 with SMTP id 98e67ed59e1d1-38ec651c5bcmr2107431a91.13.1784793055781; Thu, 23
 Jul 2026 00:50:55 -0700 (PDT)
Date: Thu, 23 Jul 2026 00:47:17 -0700
In-Reply-To: <20260723074854.1013941-1-jyescas@google.com>
Mime-Version: 1.0
References: <20260723074854.1013941-1-jyescas@google.com>
X-Mailer: git-send-email 2.55.0.229.g6434b31f56-goog
Message-ID: <20260723074854.1013941-14-jyescas@google.com>
Subject: [RFC PATCH 13/16] mm: Create the file asociated with an allocation
From: Juan Yescas <jyescas@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Cc: jyescas@google.com, android-mm@google.com, fvdl@google.com, 
	tkjos@google.com, minchan@google.com, dskiba@google.com, 
	open list <linux-kernel@vger.kernel.org>, 
	"open list:MEMORY MANAGEMENT - CORE" <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 1CE801C0003
X-Stat-Signature: 3p9tzzqhx57rwwwx99f9fk1o4tddpfon
X-HE-Tag: 1784793056-458809
X-HE-Meta: U2FsdGVkX1/cqCFxGmv5JHJpkUAQj3Fgm7auBvOH5GrmSEcUzELUmIbKJNUkS0PnvdOvX9sbNLinN3Tjnmddk2qnXt8TaNSpU4X6EQrDGwy+CIsXTMFw6+6bTghbMz6MPANx4gaz5ZZcuV1nZmUFfD5QlN47giABYG7RbuL3l6xBOx387sYBuspR4Tu6oeQ9BBP8utqXaIwMOXccUA8Ey6E3fTAq+1ahxZe9jCFVknqb34Yw8ZFC7FPSlhj20e5c2ch3qhaAUyXfIHk7Ba7xuKRkRAyc586KrciFxL4uDRtftuDkh2sDU4WV5A5hg4WMXj2Wxxy/yDFlV2yMIiswJRtMucrVo7Eh8NwOf4VnqK45fNwTWYngLl7CoWb7sKXsajHe/bh4QDFC3MzdVOF8ZC1jROaEqDl96mlDc15JLrNFQScC3lJ96JCMb7gVZJG+g6EKKnUNFQ9DmGsBtpbyPA1OaUN2bNAH81HNtkp896jlJnoAE3nyHnhHA669+ylJQsFITpv7qAwktawESbC7Xuz1AAliPdr+Y6s8ZbQ/x5kscMRfVe2F7IUYdY+NGlx9J5AZkD1slDQ+mQKQymkzQhcoCyMQr5UD2zPSRIu+qCBmKUh78jmC1P6w7TRRTZbopwj1AtodMsfL1ZozrDCw3qO/71bmElCDgaAS2q38JpSU4+sTrI82Nx+aRhxR572e4w/qlu0uhCclOOCYW6uBCvP7dR7t4U/ckSEXkk93skGyZMpumPTrbvblbHF3NfGOHWPpKNmKudPkdJp06bGB6RubSsneovToBioBa7GYYUdVUx6j7GyQ/uO3RnN77tiFzGTMOXSZbexoZgsYJgNIRSxTMj8rqbCk/ItE7Oxmv9NWBqv+lfZVtC4QFFoOfxFbYomposM0PuNRWaxVtG5ijzBsQgmfvrisbnYL+BkkGRD1cSIEWq6vCggKciAdqrfPsBKRVXDC+seRJGYutc0
 Yp81ARc2
 dwpxBonEycuiKDAsDkUQ4LfZTJf8TPMRJhj0Ruzjxkw+c7ffFl0tNPCUpqxVSbklUHM/lZVYeLdjJ5D8AOlJgPGyNB4YaL0ghuwz0yDAB7cRggETKxbR3spDnAXVBXfQTsCZVkzBn3OJucBprudTelGKAl6tIFcDAiWbYKgH1lbbqxPzQOddwIp/BmE50YIFkW5ABwVVqXB01QUnyusLAU/R+tOmlMqRe8veztN7QAw5lO0OOmM8RPj5E2AwlrD3YJiTaRgo3PKPpBloTWK5P15CWMvp7J5fOfRlCmxpeeTmwzQi4N6XBLtExGCdqa1xXEFIBSpuhp3+RZ58KPKZaZi6WWirhGFtNMI80ncEmjVSzgSvoWDfE2A+WCPQec0uNI01+l8cfX1QTsskKMgQxqXJFpAJHy1I4/I3GA9BWmsdHSHGZZrVa5Vf+KoNi3nG1R+tJ4Pz9jGA8VD4mYuiTBDwky7cnP1KJ/KCik7Bp3EdAddKisA564jZ4dQWq2GkOKCrueUtJf2qybesiJis2O/uxNKmO9C56lPnukwSHg7eRGZswsRec4MCcupzFXDHLCNCgjySu/f2fMCy9zxYgDVdnKty5QrRxLrrWVfdqM8/ajKae9wPl20ijf3edebXyj44s
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This change creates the file asociated with an allocation. The
name of the file will be given by incrementing the atomic
long "allocs_file_seq".

This file will be used to free the alocation when the user
requests it.

Signed-off-by: Juan Yescas <jyescas@google.com>
---
 mm/page_alloc_hogger.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/mm/page_alloc_hogger.c b/mm/page_alloc_hogger.c
index 7f6eebdd5197..203b71a25e64 100644
--- a/mm/page_alloc_hogger.c
+++ b/mm/page_alloc_hogger.c
@@ -186,12 +186,26 @@ inline void set_migrate_type_to_alloc_from(int migrate_type, gfp_t *flags_ptr)
 	}
 }
 
+static ssize_t page_alloc_read(struct file *file, char __user *ubuf,
+				    size_t cnt, loff_t *ppos)
+{
+	/*  Which information should be print about the page or allocation? */
+	return 0;
+}
+
+static const struct file_operations page_alloc_fops = {
+	.owner = THIS_MODULE,
+	.open = simple_open,
+	.read = page_alloc_read,
+};
+
 static int make_alloc(struct req_alloc *req,
 			    gfp_t flags, unsigned long *alloc_id)
 {
 	struct page_alloc *pa;
 	struct page *page;
 	char new_alloc_name[12];
+	struct dentry *new_alloc_dentry;
 	int ret;
 
 	page = alloc_pages_node_noprof(req->node_idx, flags, req->order);
@@ -210,14 +224,26 @@ static int make_alloc(struct req_alloc *req,
 		snprintf(new_alloc_name, sizeof(new_alloc_name), "%lu",
 			 *alloc_id);
 
+		new_alloc_dentry = debugfs_create_file(
+			new_alloc_name, 0644, req->parentdir,
+			pa, &page_alloc_fops);
+		if (IS_ERR(new_alloc_dentry)) {
+			ret = PTR_ERR(new_alloc_dentry);
+			goto erase_xa_entry;
+		}
+
 		pa->req_alloc = req;
 		pa->page = page;
+		pa->alloc_dentry = new_alloc_dentry;
 	} else {
 		return -ENOMEM;
 	}
 
 	return 0;
 
+erase_xa_entry:
+	xa_erase(&allocs_xa, *alloc_id);
+
 free_page_alloc:
 	kmem_cache_free(page_alloc_cache, pa);
 
-- 
2.55.0.229.g6434b31f56-goog


