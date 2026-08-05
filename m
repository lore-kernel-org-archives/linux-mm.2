Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E257BC55ABF
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 21:06:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DCD46B00A0; Wed,  5 Aug 2026 17:06:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B4096B00A1; Wed,  5 Aug 2026 17:06:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F1156B00A2; Wed,  5 Aug 2026 17:06:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id D14416B00A0
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 17:06:25 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 5530AA062E
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:25 +0000 (UTC)
X-FDA: 85068449130.27.4FF5AB2
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf30.hostedemail.com (Postfix) with ESMTP id A74288000C
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 21:06:23 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wG2wDIMz;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785963983;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p/Fw7yB96qNg9eVkHMHEZx2IMjLwk7mFT+59ia7+Vjc=;
	b=fmQzijh78BzeVWrKH9MN2zSZknzkATuZqKTKZkXppeDdZFSffOgE2HvlmxuD9CiSC1g+Yq
	b6V8udt30n5O4oXeEfFJX0qvyPXn50CMoGPqCA3W2pG030IW0EfjdRQwm8a+L+8+9N3nDi
	GK7PY+D+os70pXhgDIVubyPBraW55is=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=wG2wDIMz;
	spf=pass (imf30.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785963983;
	b=zR+OhJQ/h5IyMmtbZT00aMsvuUFbHeOQ27MbP9uq0BG9UsylNXk47YFdMTYkAxbiHfSYTw
	TcqLbqNN+cf8Dm5QTzKYipGn1+o7L4DDphwWjeQVxjxtOaJVl/lFELSQnyrazB1lL1kUdL
	zCX8KymUuzS/5b+/Zu/ii3BlJJ4EHwQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=p/Fw7yB96qNg9eVkHMHEZx2IMjLwk7mFT+59ia7+Vjc=; b=wG2wDIMznIUjd/ztCA/5FaXYZX
	je9nyTHMWtGKfKgMqd+7/qCB+8m/2z33qc6aHk+lxlJLg/LEJzQCLYFNGPlB8+Gmq60bzADA6dmKO
	QwR9buG9mO8Eu/zqq+nhI9XnKlz0Ax92LsisqwFK0WACk6TnVwcEbKa2j2zEfXBi8c1sLleD9mXPB
	oydbf1C+sIEzZpMaZOFJTjRgJTzlBj1ivYNi7HnWenjocuuGSOS/LnZw5RUUBsDEx3JwAWAujjJpT
	N71/0nIjzE/hBL6kvLQdcydocmLECFJdkX0xFuf5r0bDUwqJ2KLP56xSBlNA4UvsfjzZOoqB/Ybx4
	jKnY+0bg==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wrioJ-00000004h6D-3C01;
	Wed, 05 Aug 2026 21:05:59 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>,
	linux-mm@kvack.org
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Jiaqi Yan <jiaqiyan@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Gregory Price <gourry@gourry.net>
Subject: [PATCH v9 05/15] guest_memfd: Use folio_has_hwpoisoned_page()
Date: Wed,  5 Aug 2026 22:05:45 +0100
Message-ID: <20260805210557.1118966-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260805210557.1118966-1-willy@infradead.org>
References: <20260805210557.1118966-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A74288000C
X-Stat-Signature: wm46bi6edcjuptdgd5wfxt3fsfed6qja
X-HE-Tag: 1785963983-569666
X-HE-Meta: U2FsdGVkX19s/i4nGVNoqUQGiDzVgdE4EEABOJjo1WGYlX8wGRqxQlcFvIAnHIP4Ni2TgWS+BXAooiuzdNnne1UJo2rggT3zNfABTpE6XpWShrgM6CjC8xBYjyita3hvzQq38WnrmVtUdztoyq5U5K7u8Bgg3tI61Tmb3kbxdMlLMMPcspriNUje27ytZWfXBxf1VjSkfpfw9Tdqdlmar6FEGSI/vSpRxc5kjYN0MFrVSOg2oJJQE0dS4XIB1DE3Yxf8K8Ek1ivpTKCGMjA9vMbOyGSlPcPX2mfj51jBgt7nB5VYeU+tSEfwb1NYUSNdjAwbrZ7laGBbzsKQpvs29bDoQr/TIucwOBuoeVU7O4EQnhfTt1KExJ4UZFJsfpRCZpBBEWeNJE1Wrh3m1BBfWnLu24tldRnOtgycoxiu+c0HDyxa/NhUDaTxdi25MJICY8g4CH5RZVZyBu2QMzCgqncrA68rYD59Po3pJ3SjGadMxZpwBIaZKPxjGBfjhAuP5yoAx1/f4Jq425dh0GpwV1hbAirGaaWK3cufI6HXr/j9b76XeVJmb88FvyzZxNqePMxAm1jMKxHgrTqjBZthbUKBGl0g1BquMNLvyhCHA2XA+ZXlvkQV5Gx38dE26uhiolL6S/qG6WyXHV0GDfs7UyK3RgUkRfsPiEJvVFOWIBlqvpKlEPfLDRNNmMpUgJyKV9vQnIx5ud/w5Q4xdbZF+DpRCQn6p5SQ/QUugumlon8OruaJr4OXWy8py8C0U5EsdXvBsO/ekdy/MCTQuGJISMqXHqVfp4XxUyu0SJvAHDH8QdLMItOXueFY39HKNfpfNOLzADGojyYqzmk/oyib0i6pCPE2V2EcCU0oCkUHLHx8oj6kcLSVJHiW6P6tnRfgqbWI5yYnarNhWn6tiL7kXYe4OEV6wOjIxZw7zGJ84TITg9B9d0xH5961nHnFxMAT710524DNZL65L5Dgvej
 FLLNBKZx
 mqsFhdd2KbHwMtCiHYVwDNjvjj7eXPf6YPbS9s85mn77zgJdFuPoRtCPp9hzt624k8oyfqSyRzuuT3sCMgCnD62OY8l+8iTCz+h+soPo2Hm6000Nigem7zw+mp7IZjZu/wLsyTsJ9LDPXh5qmqXO4dx1CwDv6On+jNHoG9RWOOZZ2PoaAicGNmEgzq2ORgqwy714bpTGxBI+TY8CNYjKCidLtNzxyiyn8JUwQEArh0uQBT/U/gdWAni/49vTNA09DEhyTFtmesVpoShrBp0k0vcPnTaGKcTvpLA+e3sjmtm6U8ki7elnaEy0WjdpfhbXrJtTBHV1STwMCZQDX5/4IY2SHWdvJ2UL1SKEBPr8xFdtNZJCcf/ziTe6U4a8hZzk1VBXLCVqexa6NG3leLG8G26Tk/vCAnkTWhnolsfU1ZEpQhWwMvxtg6ePg19IPRT4aU+YFhTyOpwumVsapTE7lM29pv4mvt8+pg2wc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_test_hwpoison() only works on hugetlb folios today and will give
the wrong answer for other large folios.  folio_has_hwpoisoned_page()
works on both.

Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Reviewed-by: Jane Chu <jane.chu@oracle.com>
---
 virt/kvm/guest_memfd.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/virt/kvm/guest_memfd.c b/virt/kvm/guest_memfd.c
index db57c5766ab6..94eedcc7f1a9 100644
--- a/virt/kvm/guest_memfd.c
+++ b/virt/kvm/guest_memfd.c
@@ -774,7 +774,7 @@ static struct folio *__kvm_gmem_get_pfn(struct file *file,
 	if (IS_ERR(folio))
 		return folio;
 
-	if (folio_test_hwpoison(folio)) {
+	if (folio_has_hwpoisoned_page(folio)) {
 		folio_unlock(folio);
 		folio_put(folio);
 		return ERR_PTR(-EHWPOISON);
-- 
2.47.3


