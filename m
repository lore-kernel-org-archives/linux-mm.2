Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E890CD6E79
	for <linux-mm@archiver.kernel.org>; Mon,  8 Jun 2026 21:24:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0443A6B0005; Mon,  8 Jun 2026 17:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01B4F6B0088; Mon,  8 Jun 2026 17:24:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E9A9A6B008A; Mon,  8 Jun 2026 17:24:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id DDAE66B0005
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 17:24:13 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 8D20B1A02B8
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:24:13 +0000 (UTC)
X-FDA: 84858023586.21.B3C4D35
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id 123F01A0009
	for <linux-mm@kvack.org>; Mon,  8 Jun 2026 21:24:11 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R3UKD6mx;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780953852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5s4XjAOLGYLp6LndP+lIAzECrIjlhFFVdD772BNrAS8=;
	b=0+bkV/o2nnKkd5WglQqkIRrMdenjELIO5dhWpYF6eZUNDf2wUbu1P8Cxi6QgVbS85OUpO5
	V6PnEOFK/tyIBpQc5Mu3yVMHg46906pVcfLOBFR4DpcAlwEGiUUVKXVxesvgi34hoOBKua
	TdxccFQPP2dzdkWx3rrfU2UweSdNeO0=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=R3UKD6mx;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780953852;
	b=UUfDPxJzkbWd1uNwUQlHLXS38KX2CU74UGS0w1a8M+FxlIPeQ3shK1JfhOwZ14tPEs2R2W
	6vxOiON9wAYh2p2F3kEYKEk+XiHEbQlQQOeSWzvKMmQhj9wLRq6z/sk2g9StU0rxNJ1pAs
	j8+qf1dlL90o29YgcuOpmdN4uOqFHyw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=5s4XjAOLGYLp6LndP+lIAzECrIjlhFFVdD772BNrAS8=; b=R3UKD6mxV+D5lq/MadFzucIUA3
	Cbv3naiUJCSfOffqPrg131P12hFQ3fIMkgcjM1gIKTHNmQ/IQ/gc0RlgO4E9GUNI3WWWjdKx4X/Eb
	77VYkQUBX/34XYtPGMn7OYJ+zx8cq4Cs1YNPbla07sbp11mzzZ5XMm7xF2e8KmBF5fQCsm1AjNkfm
	KuYiHw1+o3mI8sYh61oyPHMwDj1KGXlIrsRvjs+Vv6lS1mAP8xn6XrTkRrO7qousVn8UR0sslxSPC
	PQo+IFUq/xtuXweOcAh2m1GmPNoYdZO2I8FaahyLa3vHoWnSy4yFpYnKrnEg6apQ2b5NGZ+qFRDl5
	3YIqk3vA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wWhAq-0000000EQBa-3xbF;
	Mon, 08 Jun 2026 21:06:20 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org,
	Ye Liu <liuye@kylinos.cn>
Subject: [PATCH v2 5/6] show_page_info: Remove printing of page index
Date: Mon,  8 Jun 2026 22:06:15 +0100
Message-ID: <20260608210618.3437216-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260608210618.3437216-1-willy@infradead.org>
References: <20260608210618.3437216-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 123F01A0009
X-Stat-Signature: wk93h1z43rx7bch14jhgidmfbefeafwb
X-Rspam-User: 
X-HE-Tag: 1780953851-287639
X-HE-Meta: U2FsdGVkX1+FpWWWV38WgFPtBlPKMOpliFpD35Sir3vNakKJ9+Jncage44vuL1ny6DYfRrpEKsrind0bZ6EaWHQk+4E129KQZrzfbqNUXkN0s1viHeBhgpu0UBH3fo0hqeeXj9vH6Gxblhlkk1WMCi9t4Mwb+RwniydV1t9flHA7rmFBgABhO31R+TvYI5a5qmFsqujDZN76jxtlQO65p04uqZSkLNL1g41+qdp8SmwRgmSgGA+8mB3dDTUNCaYhuvVy8WOL/bS6BArTLbTjNNjlAuB91cLJ2MFZrdgFYVb2rdpBudXipuD6PJj2/bRlQ0tTV7yK0LC0cZIRvXvOzPIa6Uf2ydf4LdUCB+TkjGWZVIEzWupXBpmMvWeDufmSBWLQwIdjSCPTmgx2McruFBiAh7TT9towI3Hd4DGO3K0dPOfZEKOTxb0q54HXi/icl4sL+exkm8DmZGp2ItK+PvzXZenT0RAqeHOAdj/QejFoqvpToP59GxpbH8vutHlafGAjBGhsk6wsFvkCA/u9SOnYbkaCnif7XlcHFHAMAhVGFvzHwVleJEHA6ct1PspTooTV7957r2bzLpBfeO3UiyL3UNpMhmVmdpC0jyguJSXMQBOQ3wyPFXmbrN6vdlnPBgEG6HJt9cgtyH6r2hr2q0GkcdPsq52KLjhiNPpZuIaE3XBHhi+F9E+vXhIuo7/33t9OaYNJzcLRyUGwZaO1gzI1kbQpir+5VcbJLCvGxeZ9xc2RieXBUtJzDMWVKa7azOFImE6uAfmywUtXT4qm8r21irCp6eWmxpiTcfkW+xb2TVPapIrChwN0a5zJVvJwv25lrJFv+hElT4JDESBq79fpnSIKDwi2eu86Jy86brrLx1P+FUurlRyDIFWElwMA+2AB2GvBfBNA49hJYB+10uDrzpoF+LtlYjS+61prbILErufRoi28MrRI0+RkcJlR+Ct3+CKvE1bCNHsnaDd
 X/9I0kWW
 Kbt6IXnrPIK/xSJdgfK/3VIOaioV+2Ng3G+6opHOoCozZibisRa11G7U7Gqx+wjsMmIJGLKun+J7087zZYsdAwpppPFhm0iyXK6DwQ1Iu4f/S6lyawebOtuZz47mPeJQt50jp4huwehItxvmCOn6YwZYlPqSSOM7wNO8QcTsufw/+gZDXzGH7O095v4Wbz34licxFm28jca8ixVpVjjdhxZ3n8SBKUVV1SduROmWRFPopqT8+tcowAxSfnducpblhtmWzixWgYh/NttmM4Fac3OwRPuTr8hPl+HuwwqEIWzcogyrQMK9V+YHdA0c+zVuTqhRuD7daCZWz4LY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Pages don't have indexes, folios have indexes.  Just delete it.  This
script is going to become increasingly barren unless somebody steps up
to maintain it.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Ye Liu <liuye@kylinos.cn>
---
 tools/mm/show_page_info.py | 1 -
 1 file changed, 1 deletion(-)

diff --git a/tools/mm/show_page_info.py b/tools/mm/show_page_info.py
index c46d8ea283d7..69094ef50719 100644
--- a/tools/mm/show_page_info.py
+++ b/tools/mm/show_page_info.py
@@ -91,7 +91,6 @@ def show_page_state(page, addr, mm, pid, task):
             "Page Virtual": hex(page_to_virt(page).value_()),
             "Page Refcount": page._refcount.counter.value_(),
             "Page Mapcount": page._mapcount.counter.value_(),
-            "Page Index": hex(page.__folio_index.value_()),
             "Page Memcg Data": hex(page.memcg_data.value_()),
         }
 
-- 
2.47.3


