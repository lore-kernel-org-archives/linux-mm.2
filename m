Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D518C531D0
	for <linux-mm@archiver.kernel.org>; Sat, 25 Jul 2026 16:01:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B13936B00A2; Sat, 25 Jul 2026 12:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AEB216B00A3; Sat, 25 Jul 2026 12:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A29076B00A4; Sat, 25 Jul 2026 12:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 6D1CE6B00A2
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 12:01:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CD050120398
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:59 +0000 (UTC)
X-FDA: 85027762638.02.9ECF8F7
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf16.hostedemail.com (Postfix) with ESMTP id E3FA9180009
	for <linux-mm@kvack.org>; Sat, 25 Jul 2026 16:00:57 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="u8/nxg/5";
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784995257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvwUAx6FxDsrZq8ixYPmqXc4qqzBUS0RK7TxCy7zUaA=;
	b=HbLS+cF3K2k9mlNURgVo9DDaM31/9vQwcSUUFrLncBZswQRraljRoZy618Q5ezwiUZjGA+
	lhVPWy/OgCdl4cWlS7MdigBM4GQl5rjjh/90JtBrEqKcjm8dYYYS7vnAJSeYjiZJ96dEb9
	odQXswqbNQAyo6XuiXCXTn9rwJ8RSGo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784995257;
	b=J+mArl/qt2ePQlFQLija/dR1/G179bHfOK+q+0rEM9rqc1aArolp2O0Io5uaRDYfTd55Zk
	YjHHf91Qkr2JXu4LjuHIJMsVjy/XXWCBoiaVgRphJtwWzaF9HefCCA9sWIFDzDCNJe5vAZ
	+tfejRwExAh5Np7C5t0DQMG/ICHZfuE=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="u8/nxg/5";
	spf=pass (imf16.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=WvwUAx6FxDsrZq8ixYPmqXc4qqzBUS0RK7TxCy7zUaA=; b=u8/nxg/5NouAYRHeZNdNRAgwzQ
	0FNf7C/7P6pBVkXj5v+47x0OjnKCop5JQjvGWzI27XmdCLhWrSJokm6AxzN9H1481KjQwzcX5bxJ4
	a46bYQ3836F5jvg7jXDYXjkmpN3BGk68sM9bzRkYbQyO+Adg8TWst0zxmnsAk+Gj/ybVrTDR1AhSB
	JO+V7P7ucqqTjvMeegeLwiJACNdRoSCN5BgLFdah8fHql9xJrS+o4XRo/BnmwjiaylYjlEaurTsVE
	DmZIAGgUMNHq7ju3BsP/6+DVugNPBW1UDpanxwMpgP2FBbSHBHySKs4MYhn/tPlDFuQFSW+khtUBV
	qvF3oEuA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wnenr-00000006X7W-3D4j;
	Sat, 25 Jul 2026 16:00:43 +0000
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
	Ackerley Tng <ackerleytng@google.com>
Subject: [PATCH v5 04/12] guest_memfd: Use folio_has_hwpoisoned_page()
Date: Sat, 25 Jul 2026 17:00:32 +0100
Message-ID: <20260725160042.1557264-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260725160042.1557264-1-willy@infradead.org>
References: <20260725160042.1557264-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: E3FA9180009
X-Stat-Signature: w9iffhycijxu5cmozadszmr4cjo7kghj
X-Rspam-User: 
X-HE-Tag: 1784995257-121797
X-HE-Meta: U2FsdGVkX1/zgDm4QhyfPdO0pnraZMILiS4gvMxWBTluufHJ/u3HTy8hjZxFXI3g07i7Qvhmz7OSiqWhp2Uy2dzo8Jr3EPd7HQp4S9+c2cGXxt/0pvsVwABNoGQsg1qBaPCPJpsOS/YFE8nmXixYJaFnLQMNZXKtJNlJuklMx9NqPk2Lw4bqREcMZm/jl2em3UQ3jGQ7LGPhhxlrlMIg+psuN/mEm4WXwIeBHz2RcBFv/bslD8utv+DjJkMi8VuPniktDvKBusbWgOYxFmXBXbarZ2Qs8BP86U+93ic5SkJjCKlD/Ha5uxfymOLOR81Xex7QA/f7L+Q28Z2UPJ6mCTvlBvQHBxoJP9ttx4rp/cWZs2hOb0jDg2YXfeH08Ca/lKOwhZr+XbB5kWGhIYxlM+XfO+1K89zF3DIspkQDxKupqoUry23bwDTHeSq8WfdsULmzqVRXu5MhJlgjVNNOnCgc7yJZAAoPlDCY8ltG0Fj8voaxUSHt/MDmC+mtdKPj+CMCV+QgLpHYhydvdNjlfRebrrNYHpiUTC8pENkp5OconZmvPzaSBdOWwqrICud+uSRLSU+KsIAUCE2YxzogFZXTLBT/luXv037wJndxZXIx+wzYcauCstq3LVBMBitozvuGL5eJ7ZqOGv55ri97IPUlItJtn9hGIgz7S1CoApY6LKE80t5AKb8SdgdTxNZb5I0WE+KjHsBfXJUvPwNmT1cl7WbOGewlETva96hqCPmppQMORNvCAaMsZjZqAYdMDTV0Spbazu9x+fJoy+7CW7/AujCqBdTsVLCF8oQmZoU2zH/CkqC4T5Bsz7SfP/mnXcvJDysar4SJgPZCN5lc0BoImIhRPG/zPIVjc6VNP6vU1nJi6N9f93S02py7w8rfCN6tJHjjWosKQcHT8fFKuJJoChv0XL+Hf68yCFZrk3AKwKZP1T683p6kAlshQQlrjPeelU4tebds1c6KpSh
 oh+E0FN8
 CkNBigft/4axttl8MtLs3uFO13m2wypyX8FLjX46EfcQ4E29pat/eofzSJFP+BN7ScN32gEnqemNQaGuBPqezRNCy4s045o7oZFz4WnvgLlu22bFUmDhQzo9ndZyQmTGGhI8tY9N8SDRb1PtvAh58qoKZhLMJ8ZUpSATxD4M9+doTlFtssX4Y0I10QJ7Va6ZssEJSTFOho0raZdG17i+cPt99LViZ6FMO46h4cs3Swa6osvLGBguIkXZI6RkDsj8owkilhzW9UXLDiCBVKMFnTtB+ja8RDrQlAWU5puj1L7jYRAnk2B7bEJ/Y9c6JwNVrbXO7bAHaBgkJTP1cNgr+VTBLXm80QYX8iOeeIs+iIcmbUmoQoK0Axj8Dd4xYx2BTo5Ejcul87LHuV/Q=
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


