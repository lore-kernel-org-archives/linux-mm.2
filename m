Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D27CCC531D4
	for <linux-mm@archiver.kernel.org>; Thu, 23 Jul 2026 14:30:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 253016B0096; Thu, 23 Jul 2026 10:30:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 22A506B0098; Thu, 23 Jul 2026 10:30:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 168376B0099; Thu, 23 Jul 2026 10:30:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D9C496B0096
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 10:30:52 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 696AE1A0504
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:52 +0000 (UTC)
X-FDA: 85020277944.27.A6F80A9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf13.hostedemail.com (Postfix) with ESMTP id BD3AF20011
	for <linux-mm@kvack.org>; Thu, 23 Jul 2026 14:30:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t84RMmlD;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784817050;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I46grrWDH2O/dEj+ZMjbkD8D4mKznm+9gntugHYsM+g=;
	b=1YYOp5tBsesgwMNXDo2rLV5sD8h6xZaWAC3/35eDulkUZqOUQGboepf05Gdh1aD2YZjZt9
	EeZcoSpYLpE9dhQTsjU8kY0UlH5CSNuzBbgUr4PZOQ2odTz1EEBh14PFTboT5tXbMKuD+K
	zEl1FMqUw+jrV5lKNSaJFqr/jnetF18=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784817050;
	b=pZDGrRn/3Fh7TcudFXLw9ud57Efi8jBLbAv9pA4JHyj+bp5JXfceUFAgjlaf+qsS60jrNS
	A6xha+b7slKEHTfgA1Dv5wBMlWRK9INab220AKoY6rSqKce/ZXcmJIEIh6o+QhotqvZNEH
	kzKF5PsXCOgzWMHZBLBtPjt+ug7PKuc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=t84RMmlD;
	spf=pass (imf13.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=I46grrWDH2O/dEj+ZMjbkD8D4mKznm+9gntugHYsM+g=; b=t84RMmlD0ISPnEJ9fDYzFYnGkC
	zDifmWaoBy14ux46UL1JmOHBicFN0exn+7bG8SLlIpUfCyMapxx7q/GkGkoU0JZPgUCZjwllUYm7h
	Be/aTtQYs6DuEV1T6vpLkIjdokW1+NGnfmUUtTViie+8lw6hgMalvv39WZnyZ4crGFO/IkiUlvqt3
	YligY2LoPqdwEEQiJrynXcoVtY1R/l89iXQuO4wpmI6Ui2osDUmNSCWWwBOj68e5IP9KTBVEkff/Q
	SjXBs6FiW4ETgI3UWKgxZgGUMm+RLmSL6qVoglBNPN+kolM8uI5AXWveSPUrWpDZ2S09i3Wewsutz
	YF1080jA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wmuRY-00000000jhx-3lsm;
	Thu, 23 Jul 2026 14:30:36 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>
Subject: [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
Date: Thu, 23 Jul 2026 15:30:22 +0100
Message-ID: <20260723143034.175661-6-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260723143034.175661-1-willy@infradead.org>
References: <20260723143034.175661-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BD3AF20011
X-Stat-Signature: wpmcxhwytfiwn9or1jefia4ab7c6qfgm
X-Rspam-User: 
X-HE-Tag: 1784817050-361351
X-HE-Meta: U2FsdGVkX18Bd/5HdYxkBFLKG6/Nqw0/vK9fRobHqZXGay2ZofofEJ90hE6r6WPMefO4APmFfN8z9OO5T6SsoTU7fSFyTedqTKj9CJ2xnMku21qdqb6nUY5s7UhYZOYWVWuxESjpDSNuBKAu1y5eMcemRKoh6J53k5wyfjA8N8lxs8rPr++wD8KduzPrIOYGiaxyVCKIiMy2oC16KWLv4wcCgA4/bV0Qtm6iWTIXsv0ITCLN9xm5GyOIjuQN/BJC3oQpjuAnISS+P8ralYptY13RNiqQih5vzzb5gSQnorO/eraQwWq4/vOGKslBXGpaNw5bcH/250FCzogFGY2ieoDHm/5K2N6jus1S58IHPp83HYCSjyZEj0Mb4WoHOlMr4iJx8qZyuYKJWRcnlU//MGFG/qEri4k6HFTLUqd14Jc9PuMEGbD7EwYc0aRXS3ao9xiGS4MLPT6w2X3Vx0gC1WjcuR0OOCcd5Tapd+GDLAMXO2iZCY6Is4JKg1U/doZVDR7YqpdufjnqlDmviOlCepvObmfm6APeJ7f6EoM6jBa+yMmWLw4OFLAWrlWNZCyBcX8HMdFDgntsMgAFo00NfSxwmme0MVHTP0UzWYsw4vFl3BmRx7RsLO/i/lB8tB4sh2wy+jQRyQRGpzqwKUIJRXSyYBRXanisq9sr/H2zGc/W+qVslU1fR77R/b9lS8yaWP72nJhcW/fr3wxrehidNwJousEvq4EbTiNxxifdyztKUn6JoCxLCebCBD0mudlxo4L5SJuq80x2p+aUpzYF6QsblYMrPKhms02nJwUm0ykxh/W07BGkZRCrNdao1h3DtFqLXPiOkoRUSvVqpATrHHhEvz7auAaZz1FgQeE5sLs2/+WvImvtNiid+ZZ/xABNn15oFzjC0rK7X8LJAEq9oXwTjNn+LQRU3gX9GjLiSSwcux5s7maQbeSbjM0BNfgaXdLLB8WIn+UzIZospkk
 ATCUp/qe
 RFZ21SkRiSZwpfdM9wiXIXaTMN0eOsybhXprlm3x5tqAdsSgJ2cq472HI4/OQdN0baYprgr0p8aK+FJSeIBX3GLG5rMnCzUQbG/BaMRNg/Ox+PZUzhOEQCmCTUQGJCoNVg8CWP7793UGOpYyq5iKs1V4ZussJjR9jYMGD61CfDo15kbcN/SkJEEHVL/mzNP3IDhSMRM3rI2w0oFmxlla70Ae8C0I3QnkUx8vErtxLjGvBdrduiZwlBP/Pv872BZi/6uoXiH0VC5Nei9OY1y6blK7KiQOvw6BHJtHXzhiI345f9WbFWrlUhY9fje6Y1/odoS9Hgntzsj/palDj2wbqb1G8+JlGhSBc/hTWGM9hFDNGBRYgYM7QGHmPvg==
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


