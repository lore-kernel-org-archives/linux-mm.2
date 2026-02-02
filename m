Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CA28DE7FDE0
	for <linux-mm@archiver.kernel.org>; Mon,  2 Feb 2026 23:36:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B52046B0005; Mon,  2 Feb 2026 18:36:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFFF26B0088; Mon,  2 Feb 2026 18:36:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A01DC6B0089; Mon,  2 Feb 2026 18:36:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 8D1F36B0005
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 18:36:23 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 47E321A031F
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 23:36:23 +0000 (UTC)
X-FDA: 84401127846.06.00131CD
Received: from mail-pj1-f74.google.com (mail-pj1-f74.google.com [209.85.216.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id 9DBFF140003
	for <linux-mm@kvack.org>; Mon,  2 Feb 2026 23:36:21 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q4qEy5IN;
	spf=pass (imf23.hostedemail.com: domain of 39DSBaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=39DSBaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770075381;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=HFS1GQqvu21jTqcZP0JP9sNvGByp+MCybzRBJ5Rkxhw=;
	b=nszChCvf93x8EHHaFGvYE3Cx3QypakxD9oHN8PpZSHFfGQ7VrJjfNIZba4nK9Seorja/GF
	j6Dx1L/f8ZPdxbVQQZB3IXjsDH5KmfE8O9dXwzQACi1VS6FjZhZQdYC6LctQZ0lSDze1bU
	ts88vhy4wiSQ0RhO3z1SW9wXmAJwyP0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770075381; a=rsa-sha256;
	cv=none;
	b=WbwC1Dr0DL7NIIM3qvfRuyDPn8QTUatYRbl6MwopBPRdWopaHqFVXJ1pEAxsCcbqomt4zn
	7RFgcwK1oHGgq6fIJngcqwTeyT8x38JOVOJWJ85cZ9pnPkBRyDreWR5hRwCT1rWSRcRhp6
	wszT8LndEWedI+//sEkBxbs1YwpatOE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=Q4qEy5IN;
	spf=pass (imf23.hostedemail.com: domain of 39DSBaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com designates 209.85.216.74 as permitted sender) smtp.mailfrom=39DSBaQgKCLUedVldtVibjjbgZ.Xjhgdips-hhfqVXf.jmb@flex--jiaqiyan.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-pj1-f74.google.com with SMTP id 98e67ed59e1d1-34c93f0849dso242632a91.1
        for <linux-mm@kvack.org>; Mon, 02 Feb 2026 15:36:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770075380; x=1770680180; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HFS1GQqvu21jTqcZP0JP9sNvGByp+MCybzRBJ5Rkxhw=;
        b=Q4qEy5INgdghJCsbI4xIhv3561J1L9T9JZ15IsvP7071z2EM3jtWeS2D1uIEy47PMw
         /GKDzD850GYRE9Slc467EwRqI9e3JjPY+anUniw0CYRncd9xBF5AqqhB+v3FPcIZOmdv
         M/9xrY5RJR4uc7NJvDBVzWyIDKxYqkx7oJ/97+OskrX8JpPslkTZuKCrL/vfqPN81V2D
         Eg9Dc1okJKqfO2CaAeLbJC9JcbfgRg2nrvqwL0gnmeyPa2v1Gk1DHZmWMWZd/ggtl/uM
         IoFQtgMhm5OWrvcTpHb2WGFoV5rd18yPq+zMXbFAZF7daHfzKs2g80p/2qlgG6Diye2e
         pfGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770075380; x=1770680180;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HFS1GQqvu21jTqcZP0JP9sNvGByp+MCybzRBJ5Rkxhw=;
        b=d1/Msa91D2NbnrwaP+2lLksk/3ebHSBe+iBQ/WBj4uwWMSEPTPtCPO2CwESrAFDxsh
         ArpYhK0TSDkalkKKkGrf1ly9gbUQCx+kCXjKLrcrIFhuEsWhppM3EgUJNDcY5ENOsHtp
         AQc1gtEY01oCCXN27QFYzsA8v9CQ8rTPTbOfb9XMTpDBV8UJpwDaB9dyR+YfgANyaPmt
         Brpu2xnVA260Eiy2U+6aVcSuLqtRIHGt2jzB2HOJ0QlKt2kBbQh5EJAexp+Rc7bHKhPz
         MgrbcgkXG94MTp6QWqBW1NE0wCuonCUcZS65lXSPY1WMur5qUaUTFdwT/dduDN3yLj23
         EamA==
X-Forwarded-Encrypted: i=1; AJvYcCVDud/nvPJMAj2OVrKyHrqBHy3NeP02FUcWWq/ex4FSHz+MIh2EDhJiBf/Ksf9Q73oKCeSJELVdXg==@kvack.org
X-Gm-Message-State: AOJu0YxfXHplCIQX280DK1KvVlqm2+yrNdWjBvnzGL2KVpP/oivrK5P8
	THSuo39qMDM7f3nQRuzEPGg/lGmHz0RItiZpobTjbsRuNqaP7maA2KJZCFU47i1H7g4Re5Pwkox
	Gk+4gfOJgu0VeMw==
X-Received: from pjbih15.prod.google.com ([2002:a17:90b:430f:b0:34f:8ef8:5834])
 (user=jiaqiyan job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:90a:d64d:b0:32e:4716:d551 with SMTP id 98e67ed59e1d1-354776d7905mr832636a91.6.1770075380357;
 Mon, 02 Feb 2026 15:36:20 -0800 (PST)
Date: Mon,  2 Feb 2026 23:36:16 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.53.0.rc1.225.gd81095ad13-goog
Message-ID: <20260202233617.2350734-1-jiaqiyan@google.com>
Subject: [PATCH v1] fs: hugetlb: simplify remove_inode_hugepages() return type
From: Jiaqi Yan <jiaqiyan@google.com>
To: jane.chu@oracle.com, muchun.song@linux.dev
Cc: osalvador@suse.de, david@kernel.org, william.roche@oracle.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Jiaqi Yan <jiaqiyan@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 9DBFF140003
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: 48iarnkcky1yibz8tf9u784gez91amj5
X-HE-Tag: 1770075381-576671
X-HE-Meta: U2FsdGVkX1/JdHkF3DfW8NqjFwz5fvobaPJgaNVkad1y0j/D1RXRhAbQIOJibrgDVyEdUX59WbITQH933u3On8NvMOEU4a48vLdgh2ipgiw8OGOQmuPGnH+00RUplKPS5aVV+cz5iI/QdZ8XsV2PihYV5SY8vv/tholpqXH3eFvGvtnsMuxQhIMAhGKS7kziQR3+rx8V8A3VXeyETdxg8bgBIQXBk87NPkfUyigBPsZxkd0LBnh3JralgV8mhnewIzIlBGqfXxUX5HXwlzDz8Fj6YGXERweQOhNFKvRURfm49iXm5S8cwjILRmBRfK1ksFyzHC684oGnOeC4TF0nraNXUKOKmN6vYGG6muurKJe4VN1T+G4tpvsCCbayBjjUuZURjfP6tPqsrpckah3f0prw6Wcj/fG1X4Au97mizenJQlOou3ryozjLWpqb3ixFLle0B/aINPANHf9eRjA0s8BhFY3snGK+s1vS6SGVR1Co4ofQgL0uB949fbNlcUob5DpX/IXQkvkITrm3FZshZ7GJfdL/dqGLmx6ZIDkOM1ai1pL64fqLNHTAhgrxpBXKCpcJHFGM31otHKi3pxSB6SPiecNJNpT+0DuWbCndlWXflGmvgcd942Gdf71qhO51oO/ub1+qKTbCptnzbKGFN2uGITZHSYrbRI5g3NOrLEbhD2JZ8VEuog86Qx/wiMDjmoZybC6FhhmvLwsQqkgvYoNeCOYyFu4MNSGI4g/DiaH5paMVzGnnhmvsZoGLYNPiKvT3drbizWI0ohBMcketrcztPvY/MQ4jfqEQr7XhM80FS5Ys+4dU5Yp2xcBMzYXW+ebjpB7yYrb4iYzcfIpq+71BKkmQM5y/rsTEQ60ajrlwmIBTjY98rl0YG3G9M2ur7JeHn+k8jG/SwnosniicaVezrpvNItEnDBfn/7AdeWsjQ3FufmwfkavGUM4U1cr4ZFq6IBc9W0wcsIzNyv3
 ujKzCKgj
 kp5bedF6gqjH85pwSRjAAgyRyziBsWx2hGVqsSUwhcaXT4+sV03xoqp4rSGI++5zW5LwBfsIW2gWXMqr3DsyNt0L+8IFliGTTkmJYnb+NBp31Dcjg4agYSf6Zfz/tF1T532XU7X6Ien7a75fPTBGn5RPah1OiMQ8cogIktkTWHL5tBZxOLGLBflCz4TSp+w219ttcs+lKY3a0BfJwO7C0vlUeUl6C2LFNn88ZRCv1A6UZWs6GZRx99+y6imlMCG+QZMJI4lp41FrrToXZfNEqVWd4dU6mQ3SZzPTlNIfXQvzpv17AeinttyE5PcbXW0n6wSYB//xjN7og9ITBmMIcXe8qF00TN1tgpwvWoOH3W/DNowOgnr7jhoahFHIqdfW5953IA6Bk+hwbPspdwGj3aBSOIO9hV+dIL/p88fd+T4jyCSlZu4MwYG/4gtPp0OXskq1FDYd4gomuQ0C4RZyEUDP6PD0OxQFM6S56tLmq3MQz962V6UwQXUCTTnHO58MFmH89VocAYV3yXbpzS6oaXtX1szHQ5zifTC4WD9svJUCFZfW6Y9Q9yrnsKiv/6N0n/Sfytj/MVX8y6JFmzhVNwhSSIp3Ey1y2ZYyBGuSThUcRGUDv3H5vxxpm1UuQXDvuwlQpdVWiyuTfiBk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When remove_inode_hugepages is introduced in
commit c86272287bc6 ("hugetlb: create remove_inode_single_folio to remove single file folio")
it used to return a boolean to indicate if it bailed out due to race with
page faults. However, since the race is already solved by [1],
remove_inode_hugepages() doesn't have any path to return false anymore.

Simplify remove_inode_hugepages() return type to void, remove the
unnecessary ret variable, and adjust the call site in
remove_inode_hugepages(). No functional change in this commit.

[1] https://lore.kernel.org/all/20220914221810.95771-10-mike.kravetz@oracle.com

Suggested-by: Jane Chu <jane.chu@oracle.com>
Signed-off-by: Jiaqi Yan <jiaqiyan@google.com>
---
 fs/hugetlbfs/inode.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/fs/hugetlbfs/inode.c b/fs/hugetlbfs/inode.c
index 3b4c152c5c73a..83d71cea7e384 100644
--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -515,13 +515,11 @@ hugetlb_vmdelete_list(struct rb_root_cached *root, pgoff_t start, pgoff_t end,
  * Called with hugetlb fault mutex held.
  * Returns true if page was actually removed, false otherwise.
  */
-static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
-					struct address_space *mapping,
-					struct folio *folio, pgoff_t index,
-					bool truncate_op)
+static void remove_inode_single_folio(struct hstate *h, struct inode *inode,
+				      struct address_space *mapping,
+				      struct folio *folio, pgoff_t index,
+				      bool truncate_op)
 {
-	bool ret = false;
-
 	/*
 	 * If folio is mapped, it was faulted in after being
 	 * unmapped in caller or hugetlb_vmdelete_list() skips
@@ -543,7 +541,6 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	 */
 	VM_BUG_ON_FOLIO(folio_test_hugetlb_restore_reserve(folio), folio);
 	hugetlb_delete_from_page_cache(folio);
-	ret = true;
 	if (!truncate_op) {
 		if (unlikely(hugetlb_unreserve_pages(inode, index,
 							index + 1, 1)))
@@ -551,7 +548,6 @@ static bool remove_inode_single_folio(struct hstate *h, struct inode *inode,
 	}
 
 	folio_unlock(folio);
-	return ret;
 }
 
 /*
@@ -599,9 +595,9 @@ static void remove_inode_hugepages(struct inode *inode, loff_t lstart,
 			/*
 			 * Remove folio that was part of folio_batch.
 			 */
-			if (remove_inode_single_folio(h, inode, mapping, folio,
-							index, truncate_op))
-				freed++;
+			remove_inode_single_folio(h, inode, mapping, folio,
+						  index, truncate_op);
+			freed++;
 
 			mutex_unlock(&hugetlb_fault_mutex_table[hash]);
 		}
-- 
2.53.0.rc1.225.gd81095ad13-goog


