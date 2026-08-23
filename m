Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D799C5DF8C
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 04:41:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C4BEA6B0095; Sun, 23 Aug 2026 00:41:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BFC9E6B009B; Sun, 23 Aug 2026 00:41:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AECA06B009D; Sun, 23 Aug 2026 00:41:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8A2AA6B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 00:41:50 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 032EEC025B
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:41:49 +0000 (UTC)
X-FDA: 85131286380.16.2795EC0
Received: from m16.mail.163.com (m16.mail.163.com [220.197.31.2])
	by imf28.hostedemail.com (Postfix) with ESMTP id 208B9C0008
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 04:41:46 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WC2C+Uc6;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787460108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PSoMKkEw18jI78qsF/na21m8RpLE64CUxHlryaUYZCA=;
	b=pEn36ZMppqqqAAR4zrBNMNomfWvZgUPbGusxosKqpr6FCqFsHH0C3ow1dKLk9CMo8SgvXN
	1i9mLusEEnfJg+/QyMmeFbETYxZF03uwK5+e+HAevAzHqXKUtyAiXLc1kdL98ULOdeTLKc
	QCMWiYG7SpFmVDhHfhkjGHKUxLrmDJc=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=163.com header.s=s110527 header.b=WC2C+Uc6;
	spf=pass (imf28.hostedemail.com: domain of xialonglong2025@163.com designates 220.197.31.2 as permitted sender) smtp.mailfrom=xialonglong2025@163.com;
	dmarc=pass (policy=none) header.from=163.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787460108;
	b=dbxQCXOy3GpweISeFAxzEhco95AMA6HWy8ERcb4izm4RtJfoxt3ms/ePijmdcFVs0WfbFa
	SNkEeq1DqqSNVbkCEz2TVMs0T7yUL5dPd+2W5Jgjp5hYyTDKjI+Jz3p6HFPVxir8AfRUPy
	ZaSkjpSf4RjJLUpeqtGX4qpw5NIRHxA=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=163.com;
	s=s110527; h=From:To:Subject:Date:Message-ID:MIME-Version; bh=PS
	oMKkEw18jI78qsF/na21m8RpLE64CUxHlryaUYZCA=; b=WC2C+Uc6A7qIqNvt2s
	iuI447NK8mJqPJ0QjVFi9AY/TxjHEeCMr9qwsEKhe8N7TQTbXcd/2zOdzFziY10k
	HotBFesl1rsw8/KW7EwHOa7vYxo+JAs8znGeNE5m2vjuO0jtciMcS1UVoN+lSbQT
	1tMc+dS9kJZ/av2cc7rUrsjb0=
Received: from XLL-9950X.localdomain (unknown [])
	by gzga-smtp-mtada-g0-2 (Coremail) with SMTP id _____wAXH8z4eYpqyqI1Qw--.15058S4;
	Sun, 23 Aug 2026 12:41:34 +0800 (CST)
From: Longlong Xia <xialonglong2025@163.com>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	akpm@linux-foundation.org,
	david@kernel.org
Cc: mike.kravetz@oracle.com,
	mhocko@suse.com,
	linmiaohe@huawei.com,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	xialonglong@kylinos.cn
Subject: [PATCH v2 2/2] mm/hugetlb: warn instead of silently bailing gigantic pages without runtime support
Date: Sun, 23 Aug 2026 12:40:52 +0800
Message-ID: <20260823044118.1097121-3-xialonglong2025@163.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260823044118.1097121-1-xialonglong2025@163.com>
References: <20260823044118.1097121-1-xialonglong2025@163.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:_____wAXH8z4eYpqyqI1Qw--.15058S4
X-Coremail-Antispam: 1Uf129KBjvJXoW7uFW3Zw1ftr4DKrWfuF1xKrg_yoW8XF1kpF
	WkW395Gw48XasrZF1kJF1DXrn8C39aqrWjvrWSkF43AFZxJw1DKFyDGr10qayFkrZ3Ga1r
	Cr48XFsrXa1F9aDanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDUYxBIdaVFxhVjvjDU0xZFpf9x07j2ksDUUUUU=
X-Originating-IP: [2409:8d1e:e12:7fe:fc27:3a72:bb72:5709]
X-CM-SenderInfo: x0ldz0pqjo00rjsqjki6rwjhhfrp/xtbC+B7a02qKef6dwgAA3X
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 208B9C0008
X-Stat-Signature: 6wq8zgjt5bony1yi9k38qft6bdxiza4m
X-Rspam-User: 
X-HE-Tag: 1787460106-519391
X-HE-Meta: U2FsdGVkX1+Lfmm5jOC69Zl0Ww3yxb+w+FL0dVRquoRcS9fsrgNRNDG3n69FS12GZk+Dw8J/KXIfYUDMA4ks2XuJFde6akMVv1Xv9CnkYPLYz6aK1GMb1YYFGS7rd6BiCGq7DlujY/JYKQFHhMxEDT5qKs7JTZ1htFXsRYyZnFEys4EFMTM6MFn/w3A6XKEhu712+MyiDElMa4uugaDrVhBSza/h+g4nndeGqm6wYPQ5Bqm5TxA5DiR5nywRgmMNE4/JhUF4ilkB+7FSyfL/CjHxkmm6u+MZ/6aItp+YxeGu+jsmkSkEyaBb7CtaDku1+6AaWCEijZDUs/XxOf+7vY3ezd05yvyNCI8FVFaMfHcGQQHUfHg8brAAXUYO9fD9AOuWeKGXD6mCM4sNQpd+w0V/COBitDqAteqo0jN0sKg2Dxfl6PkIaTnBIBgRIIFaUySXkTt9fJ6H0JFOkuGybxjFNeoqx9louMoNXGMKAXF8hVU6MI94PbnW8dl7MoCPO9K0vva8jvDXX9Y9z4JauxPgcfE4i8QW+elKuNUBmSmYrTtbMNRQcdD7k6Cx6WjgS0mIdgSu96m2pEIXfo7s8NetgHH/7YFpodDOY+iLRyPiFcRTemnWDvhQ2F3mcAd8t7Er3EGy5R+K3Kz5HjVtP3ZfIE7hcT7ynJO1uRh6L7cCMq3n/fx3E+HT6kbXlx5Jkn7yz/XzarhMiJE4u0beenSQLajupC6+xB9Nll4nXrsPdgKElyaJQ5mzDxOLKzvwbrlMJZj6rJ0HO5soi+fGqFvX8n3R77utQPIzRC8z+jWCkLrgIjGVOecrEpPCdIBn5kGZujkw0PSoyJbWfcCKdXdI3fM1gKvDd1IJ2TrqPfKqhRBBqd19LEuo+HqTVul1IUdcKRbHJenq/y8Cn90uE1fjbrQEyl7z/5etGDhbGKVjZYUrk+WDJI/3yVwcoEgXwcaS223GmcVAv+ga7/P
 m32fVqct
 wqPtp/Tw+HYWf2IZNEUY1kpsSATLUKKnpc6WDEij1c4KqY6QhrFB2nWvLIoAvsXHG+ARi3dLMBrYLtrbY/edKvGy4IkeLT2lKFD6ElET6pr0lJkSlYigAoUGl7kzmzCPmQz4PLtENl/lqXDCGeX4SCssdP0NQGjKEJAMjXPN6mpbj+xYZ+DDoqUM1I37DijRl+TFgA3M66raUZaP3DOtkjL2x+2yfiNZrkOFQYhATRxQusc5DYDq1edJONrvFaMFH83Ec3BIq8q91N/YowgaJ6b8qcAvQolSVJAUUqoupWds7YQ7pDo1stTb2vI0qqhFuxq7jWXrmyhv0JKHdSFXKnbcLh/jdq7fodw0gByf/cjCSDz0obAQOOMu1oWq18atp3H4u76ZKQ/pLQEwgSmme7LlNtw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Longlong Xia <xialonglong@kylinos.cn>

remove_hugetlb_folio() and __update_and_free_hugetlb_folio() silently
return for gigantic hstates that lack runtime freeing support. All
callers should already filter such hstates upstream, so turn the
silent bail into a VM_WARN_ON_ONCE to catch caller regressions
instead of masking them.

Assisted-by: Codex:gpt-5.6-sol
Signed-off-by: Longlong Xia <xialonglong@kylinos.cn>
---
 mm/hugetlb.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index 8b9cb476a41b..67a502293698 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -1398,8 +1398,11 @@ void remove_hugetlb_folio(struct hstate *h, struct folio *folio,
 	VM_BUG_ON_FOLIO(hugetlb_cgroup_from_folio_rsvd(folio), folio);
 
 	lockdep_assert_held(&hugetlb_lock);
-	if (hstate_is_gigantic_no_runtime(h))
+	if (hstate_is_gigantic_no_runtime(h)) {
+		/* Callers must filter gigantic_no_runtime upstream. */
+		VM_WARN_ON_ONCE(1);
 		return;
+	}
 
 	list_del(&folio->lru);
 
@@ -1460,8 +1463,11 @@ static void __update_and_free_hugetlb_folio(struct hstate *h,
 {
 	bool clear_flag = folio_test_hugetlb_vmemmap_optimized(folio);
 
-	if (hstate_is_gigantic_no_runtime(h))
+	if (hstate_is_gigantic_no_runtime(h)) {
+		/* Callers must filter gigantic_no_runtime upstream. */
+		VM_WARN_ON_ONCE(1);
 		return;
+	}
 
 	/*
 	 * If we don't know which subpages are hwpoisoned, we can't free
-- 
2.43.0


