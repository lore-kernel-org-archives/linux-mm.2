Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0E48C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 12:24:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6FDD6B00A1; Tue, 14 Jul 2026 08:23:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D49016B00A2; Tue, 14 Jul 2026 08:23:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10086B00A3; Tue, 14 Jul 2026 08:23:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 962346B00A1
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 08:23:59 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id EBEEAC022D
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:58 +0000 (UTC)
X-FDA: 84987298956.05.2FF2F07
Received: from fout-b1-smtp.messagingengine.com (fout-b1-smtp.messagingengine.com [202.12.124.144])
	by imf08.hostedemail.com (Postfix) with ESMTP id 1054A160003
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 12:23:56 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="P 8FbB0s";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=KBK7oTEe;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784031837;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZGgqHfnxnxp8vcpU2HELeh1jY2/4EmvBfBpJVtKKVY=;
	b=Ec6WR/okAdnCwByFU6G+W4KKJp1goTNzdpbYaFo6Vcu/w57gWeZUjtWwvdJZms+bWMVdHf
	tsycd6v0a7e0iyVQNjrQzlVSD+t89jt7TvmkaDZ6ZdlaWeaG/eaAoKDqkLADLRd4ns8T7C
	kSmbNvXvUrL2L7gItZOIxUEfDtmbCNE=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=shutemov.name header.s=fm3 header.b="P 8FbB0s";
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b=KBK7oTEe;
	spf=pass (imf08.hostedemail.com: domain of kirill@shutemov.name designates 202.12.124.144 as permitted sender) smtp.mailfrom=kirill@shutemov.name;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784031837;
	b=ZtkGXdrGY7fTeJrXeX6pANhUtPLiTsbR79/lXwh9+TQKYX7Sf60rxasFavVVRo8xOJCbBz
	ks8j/FES3jwvVd8w2fk3Eowj6y3gyXKtxqd/BQBYv/myz/MpmgRUTQ2eLH4GhiDFH8IF4L
	wHbuEjp1Y1BVnCE9WmVKzjkFmSY/UGE=
Received: from phl-compute-05.internal (phl-compute-05.internal [10.202.2.45])
	by mailfout.stl.internal (Postfix) with ESMTP id 091C61D000B2;
	Tue, 14 Jul 2026 08:23:56 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-05.internal (MEProxy); Tue, 14 Jul 2026 08:23:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=shutemov.name;
	 h=cc:cc:content-transfer-encoding:content-type:date:date:from
	:from:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to; s=fm3; t=1784031835; x=
	1784118235; bh=lZGgqHfnxnxp8vcpU2HELeh1jY2/4EmvBfBpJVtKKVY=; b=P
	8FbB0scPV8Z/Xe2YgMOs1y85yLrjyeZj6HswC+a1GIiPAhC42XZki2gZUxGR8DKX
	XFYdYu8QVgQuQJU1UiltchmkJxrNxruDmUpJUKNFZIQ9uG1kd/KzNhpkVqjgmoMW
	hGemhn62+b7gOXfm7FFzAP4vGMweZasUIQGg+63/RQvbgKzUd7hf6T9xWe5vf7vh
	s/ossOmoP2rwkO+/gjUBolqAYNC1goj8vFrThteT0qlS/jRGw3qlAUT66+uwIP9N
	t/2XEUtUwmyfLqX1NxuIba63MbW+zkHsAnow/nj+ukSF3D+9qN06x2I8vcrqJD7/
	a27qOawyOn0RULKB3jBXw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:date:date:feedback-id:feedback-id:from:from
	:in-reply-to:in-reply-to:message-id:mime-version:references
	:reply-to:subject:subject:to:to:x-me-proxy:x-me-sender
	:x-me-sender:x-sasl-enc; s=fm2; t=1784031835; x=1784118235; bh=l
	ZGgqHfnxnxp8vcpU2HELeh1jY2/4EmvBfBpJVtKKVY=; b=KBK7oTEe8WUxc7JSJ
	c7KydpEoPUdbYu5ZTohjcku7gG8XaUGIOjMyROLogltpRrqVBSV1HztDYRpRtefq
	olCIs0sJ1RB/CN06kPSlFRXz7sWRmj73PaNFKUEcyLDi4tdA7LtKEiP+P0ClVFAr
	mbph0sImpZ87j40Ffy4vUXGBwNws0SKbHfMQ6qisGpQHklBnHG64HsJC/587XjLs
	5ENHjuHgLAI8JVKcUOyo0OECxwQdsZ9c5Kybq880jj9adj+qcf/rXjk3j189dKvc
	UlyXhZBy11vohZP7fhmuxAColoDlrIT1MRXtX51HHSZWOoqDfDJo6lGs6t1M3MDt
	wFjJA==
X-ME-Sender: <xms:WypWavcJK69QEhjn8rI8wGlKqgVqLF0A5IwO0t7oGe2gytQfO4nHng>
    <xme:WypWamm_FQSsbjy8coB8At2WwV0ou6GtijO0S_X-eRcslE9dXxWsBV5CN1_YwkNYL
    CTi0OjQ5HiEwnH2-ByRW-erorCYZEnpzptEtKPig0ygEpCwyMc8ug>
X-ME-Received: <xmr:WypWahyVvWVzBBWPROlQibDni8BHTornSPtOXyiYknGtLjn_c--Xgnyx9e52Zg>
X-ME-Proxy-Cause: dmFkZTFMICEClsb7Ov+fedgnp0pMqXO1FfBD0xvZZ/V6P433GtqExWJyu3GARbG0/r6UJr
    Vf8nlq0lv2eCRUGCgAvBzEv5gE9KqzX1y7uFCtcvkB+wk1F+H1pzvrmeq3ImlGsBni87oI
    /YJqxi0JFt3vGMbm+u361lX7c8CBMgJ1ybWe2KN/ei2Wm5Kh7AGZP5ET8MkAeVDldf1ZFf
    llAd1ziCU3FyBV8QCjXQzkJyi8QMxgwqv8RzxuHH/6PIE1w8t3MzGVjuBE4OT1E4WpjGBL
    sxvt+r+K97QKtnJqN3sNNbSNEnM+m+h8tV+Tsxrhb/vhMT9muSuzm8yJyy59nX9YgO4xkL
    KklZs9i6gz8ILQFsijAUucD6l0KWgGv0Jo81muEkLxb5A//0xw/2MLGWYzDR1xs/2sB7j8
    P8Wd0R6Dh33OXZ8Nc2kJx338Hub42OlRI/eNLqs2qQdVy36KRExL280V6laleHROH28RWm
    OlbWaFo+x0KgdOu5oga78Z1qOoXDatcJiGit8re6dqijGepNN4a3TiTP0EY8P2VX+9PNyo
    ZsLoBEp+Awo/VAejd1pZOskPCzSZfoZTvo6idWQLuKtxeNjn6mQQw9DKNXejNzNZ3+VQ+H
    HFtRvURgQf1XmKM2MDklGpZPDuTtb9MdZULKMifM2c3nYam/Bx8Bvm0gbngA
X-ME-Proxy: <xmx:WypWapNbdmeYylryEBJBhDnfcOkRZmdn-jFWC5mg82y4PwQODTkuWw>
    <xmx:WypWaigZ1V4oSag0A8izMJCZVoeM39oflZC08xLwpaqWcX8ew-6_2A>
    <xmx:WypWap8DGctfUhzdQnMLxYAvMn2QojB_vQYd7h7nLu9S-FBPxH2nFw>
    <xmx:WypWavK2at1hnghD6t3KFnwhVJym3nKPamQPOQv6OZnOOfwBjbr09w>
    <xmx:WypWaj2RG_ye57RKDfJDg1kYHs2lhy9qd9iiwwgdP7qAOMxlG1Sc57Vh>
Feedback-ID: ie3994620:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Jul 2026 08:23:55 -0400 (EDT)
From: Kiryl Shutsemau <kirill@shutemov.name>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Hao Zhang <zhanghao1@kylinos.cn>,
	Hao Zhang <hao_zhang_kdev@163.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [PATCH v2 3/5] mm/huge_memory: remove unused split_huge_page_to_order()
Date: Tue, 14 Jul 2026 13:23:42 +0100
Message-ID: <20260714122344.351895-4-kirill@shutemov.name>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260714122344.351895-1-kirill@shutemov.name>
References: <20260714122344.351895-1-kirill@shutemov.name>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 5brtfz6u6eumzdezh397j5fau8owxrf7
X-Rspamd-Queue-Id: 1054A160003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1784031836-800316
X-HE-Meta: U2FsdGVkX1/T6u5E5x/jGcuKF+Zp2z6JDDraYYI9Vr2en7jTpA/qOBDWj3EirKHluDqqBWODRPrxxThJ19w4BrDTk69NV3RiD5YVRAcrbDWVXs4WjTC6o0YOO3WULd2zUbx2P1v2gAFSwL4NkYVzRaajLNStvxnFo821at61Mi/e9kHOcbXZsqHfaWBSK6pWk9ah6G4zL06PdEdtlHSnynQF4xQhQ29lzkCk4sk8rbXb6YyxayduH4IQSrOVs459lhyBY0LYe+JQ/gkjthT+mwif72lSfp3zqamT5cNCzyVWm1p0a5qv4coJNyL0I88nZ0T1aJD1/XF3IsNvH2IS6G8zbrbIUkBqBulqpdfTjZ1WyaEji98uNW9qGrjYmhWXZnq2aV/0+I0ZJHK9pu4P6cQD1FLKMIhT5Xk5owmek4oIIos8ZIypLQhFLYjjVa3oxZ7mksvLQq6/L7xXr+I4r7ZVa0JBrrZLh9zmLrrewds/kZvJUoGHZUd0nTOuKlcGI0ljGamhLWzIRAJPq1eSANopR82/1aFLJicmyMEEXdTpdb3dhmqFjNyhbmVc0LFUmzXGoa4hmxhI3+97VzUWhail2PzQXRyDSu92IcTfy5X9QTESMr+ekUz+d0GxWwRcAajbhz4b+FcNL6DfJElUb4gpufSsoqLvy3jNlXuyYWFSe7Hcg6fFvvdluRFS/P+Y3Bd53+o1WFdpYKTbCqsqOEkIeyOgDzOu1+jUUEKrHSMPcnhHRgYkahzdt1lsVNMAoWOQ0s+4heL3JowYO70C0SU80vQu13L4Q9530Z0NHcKfbbvtkAYkP1lCgk0SoCxHEbeIVJGZGaAYJs3bdWqd8oKmvmhPM5McqrSbsTehz01qdqP68QcOMq8p0JILT53S2oUDgKPMwDgQz2DF9ISjvMRLwngyLGa5fZvwN2idJu8MtoEhkMZSWoMWCT2E9+RL+pbFauQ4DGqfck9gMnO
 RQY3jcF5
 WdGaNLB4lO2QKjSzDMPkEVA5rBybSxVyXsFPdetDLW/STsEhs7hr6pDPWY4EWN/OOliCA9mSW01VarwnJtsYIx1Clw5q4yUZ60RhTB3YsB3HZbNPij9JlC5x7x1rxNPG1iBhWuMQTmUawLwhpsOoxIJAlQrS11X8IWg29peqjE3k2B2UBlq1d3b7S5oVeKO45mZr2B/dE6S8sEQ8rEP2rKnc3hulPSED4lFhtlWngZEDfn+dfmV+Nc3sKlTe5euCZNEy0SSq2aQcqIi+jyc7ZHzDH+ds7bScqb81KppENAI6xtiJ8E//K47oAzkyceX+NW1qRyusiUP2HKV6hIrH/WLN7gZuj31z/bLZ6UyS8P1byllFKKjuf/0SsgNM7L1wyzZ93Cqgc1llQ5a/cOj3VI1oBAdq/jXhxsC+fqzvqoCdHcJaCrKxIzMmT6gOke17bQ1aYLqg+MKhMMQnC60a/QM23aAl0oqkg1pY2Ecl3EmGsE1SiwyFM+RcGtTXhtTffZF6XF1o1QHdF/8mruRUNOu6WJcfz5w1s1bUyWHyAq9ExFKIphCDMnsCNcuWlqpHqpwrs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>

The last caller, memory_failure()'s try_to_split_thp_page(), was
converted to the folio-native split_folio_to_order() in the previous
change.  split_huge_page_to_order() now has no users; the folio helpers
(split_folio_to_order(), split_folio_to_list_to_order()) cover uniform
splits and split_huge_page() covers the order-0 case.  Remove it.

No functional change.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
---
 include/linux/huge_mm.h | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/include/linux/huge_mm.h b/include/linux/huge_mm.h
index ad20f7f8c179..77483c613f84 100644
--- a/include/linux/huge_mm.h
+++ b/include/linux/huge_mm.h
@@ -414,10 +414,6 @@ static inline int split_huge_page_to_list_to_order(struct page *page, struct lis
 {
 	return __split_huge_page_to_list_to_order(page, list, new_order);
 }
-static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
-{
-	return split_huge_page_to_list_to_order(page, NULL, new_order);
-}
 
 static inline int split_huge_page(struct page *page)
 {
@@ -633,11 +629,6 @@ split_huge_page_to_list_to_order(struct page *page, struct list_head *list,
 	VM_WARN_ON_ONCE_PAGE(1, page);
 	return -EINVAL;
 }
-static inline int split_huge_page_to_order(struct page *page, unsigned int new_order)
-{
-	VM_WARN_ON_ONCE_PAGE(1, page);
-	return -EINVAL;
-}
 static inline int split_huge_page(struct page *page)
 {
 	VM_WARN_ON_ONCE_PAGE(1, page);
-- 
2.54.0


