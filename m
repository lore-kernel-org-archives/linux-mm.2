Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6194FC43458
	for <linux-mm@archiver.kernel.org>; Tue,  7 Jul 2026 18:17:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A9FF46B009D; Tue,  7 Jul 2026 14:17:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A4EDD6B009E; Tue,  7 Jul 2026 14:17:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 93EA96B009F; Tue,  7 Jul 2026 14:17:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 43E6C6B009D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 14:17:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A97561C12B5
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:24 +0000 (UTC)
X-FDA: 84962788008.12.D505D64
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf14.hostedemail.com (Postfix) with ESMTP id 2659A10000D
	for <linux-mm@kvack.org>; Tue,  7 Jul 2026 18:17:22 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q+cqsIUU;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783448243;
	b=HIggG3zYgi9QOnIp9PYnIYns1g9ZiHmMUmkAAIl5JB5CgHB6++kTp7U+TNFy3H2RnmtFyR
	fL0GkpHT2KWWdWWqf50YIGBvza5B2l0RnQVKE/xovojMyqEPhhOyYFs9vrYiOd2w9FS7LL
	6bQ2QSaVFdCCfb59BC8zdnpf8hamuic=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=Q+cqsIUU;
	spf=pass (imf14.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783448243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=GRNrlEqQjP7EfQ77yuDcipVPzSRr2VJHlT4bUEEnLsY=;
	b=VEEK+syB1JUIWY2VzExUZuf+4cUd6pGn0RT21SjFTwEvjf4tPH/bBo3+YSYhznIRR/xQYY
	/RIBl8cIaeLZlBa3OMLv0Fd9A9gblxz/m/oQUIO3avXrVmtBTdB743l6gXI9ujrNNEE2NQ
	6k4JfTOC36XHkSqJAMg2+5zUATq3bQ8=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=GRNrlEqQjP7EfQ77yuDcipVPzSRr2VJHlT4bUEEnLsY=; b=Q+cqsIUUvGRn+M7PPtJHNhHiDc
	rH693PKQl/VT1f0J86KbfBX73ezICoDKoDnYSuiqt0FUXgeoRtmbZZRLMuI5T2I3DQnFYT5GhtslR
	qDhINpMYZucMvwMw+RX8twnY8YJ/9W6CjZRQ7ODA5EE8w5zrI411SAg1c5ke1HSL4b5aHuHbW0lBU
	RSFEvSQ5qxgxWguBUe/UgTWdH1WY6OTJwwkI4WAP/2cLIU5oJ2eIg4pQHVJvzQFjr1Lhkv7Aue166
	olVfaY6ffYcmauFJp4++rQvR+Qv5fDHZk4ld555ogJljFD76qxIkYtREu5uiZXg7znvIuJhqRSvJk
	w4enktNQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1whAM7-00000000sBc-1Bji;
	Tue, 07 Jul 2026 18:17:15 +0000
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
	Jan Kara <jack@suse.cz>
Subject: [PATCH 0/4] Use generic_file_read_iter() in hugetlbfs
Date: Tue,  7 Jul 2026 19:17:07 +0100
Message-ID: <20260707181713.208282-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 2659A10000D
X-Stat-Signature: nnqfdmnpdhcqmrdr7hbfd5ro6p4374kr
X-HE-Tag: 1783448242-834439
X-HE-Meta: U2FsdGVkX18jeHnvXRMRE6DTkSqSgENYSf1ZAiOrimzAK/efKyPmFqxx9xlNr73CYnnXAKkQbPeu7CyemI1l8wBkiZM8MDTmjr9YthlZ4gbUiJb0ZHimH43xBwtIKv+SnyArJrSsl0Sq3MLy0KF70oPQgGFusDJWANgGxDkEFsCfAEXDMMAKT69qCh0XXZsaSKmiGlEAphImsgUEbhzxRfe8/W/U7cvNaRX/81KCHfF5hP0TdKGgQ9y4hDz2AgFkaNa22hSD723NsPvWrNhywa157s2aIPKj/A0AY2F3YiMGsBzP0gl2er9WvDwh0r+wxRjLCDUy/XYT/ievx0UueZp3rTdtmNaM4M1fwDuEYU33hKwFvR00/lFJjjPhciCbqsB1e2v+Wk8/dcclNfFmj9NRycpZW3zJLrNEf11E0udA+atwwIxQ4JtJXxfK83WKrlQ9P0Ey6Pv/aj7HwZHbZel83G7HgmJCA9f1MgsuP5VfE+c52gG4wt3xrCB7jwzzkeWx4rVu9LqfnHFMLe84gzTW5yJtPQsQdDKg/x1R0ClWikT2jijsoZKaaMuvkKK4Wnm7Bec1Wn+H3lckhY47c4dGmG/LaeWCvBjQbF5uexiIx+GFIRTiFZiFFQgsUZnJojlRyWBiTjNLsVfDcBaGAqh7Nv4z6ke1qgzcX2lridS0+O0MD1rQgF0B7KL1fD182fG44ILt4Bal2Mz10aHh/qJE2BKNwMNnc/CNu14W43nkwL2Vv7mclKUuy+sCyCx6E7JwawUNsA3pIK9QKR7fKKLVBMBSyacpnDXTp/VqGLZEzrrld/uflb7co02jAhUogIvqyO/p7HzOQkwVObV8JizuqXr8RfH0S5HakzGC58XTVOp8wGpJt1YZUMjz7GqZ1H5yoLhZfPklHlRmZu6CbAJxEOrW9pfaGlUWO1ajH377s2XoESYZpJwoe9eNAWul2v2YIcHCWE5QOLx7K8c
 6YnX+7Rx
 kc7p2TcexO/nl/XUzM7HJvj4lee9UHflVK9Af7CFsIb1L4fFjeWNsrrjXVflPq+zJ0YcIO9vnD7kIyRrFHmClaUzx7wlPxT73UpEr9iNGCjSJ43NJalobe4DbmBvTxAhTdtpjEqhCXgWIlu3iJA9xQjLefJus7WcAGj5owa9eZKGv9dfgrmjUHQTiZjW9XGRa7bdXMRPUpT8nlCVgWil5u4XP6v2CuoJkLipFw8pIGPvkJ7383nnpz4ccC/xEggK9q3oeIzrjpKLFGyaIbvdv5WWrTDmLY6HglkMl2CkgOdKZG8V1iew3DvLqfp+btK6OVWdWKgIFXiaQLrkk2IhfK0IO8gfe07TX4PaeYE3zteV7qii0sNJmGxRKrobDD5W38OYLjdSlFW0UaCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This set of patches are separated out from Jane's earlier series.
https://lore.kernel.org/linux-mm/20260617172534.1740152-1-jane.chu@oracle.com/
I feel that they represent a reasonable amount of change to send
separately, although I'm going to keep looking at the rest of the sseries
because I actually need it to do a further improvement that I'm working on.

I'm not 100% confident in all of this, so I'd appreciate feedback.
I've run the libhugetlbfs test suite against it and observe no new
failures, but I'm not sure it's thoroughly exercising the read() path,
and I'm absolutely certain it's not exercising the memory-failure paths.

Jane Chu (2):
  filemap: add hwpoison handling to filemap_read()
  hugetlbfs: replace hugetlbfs_read_iter() with generic_file_read_iter()

Matthew Wilcox (Oracle) (2):
  hugetlbfs: Set mapping folio order
  mm: Handle hugetlb correctly in is_page_hwpoison()

 fs/hugetlbfs/inode.c       | 122 ++++---------------------------------
 include/linux/hugetlb.h    |   5 --
 include/linux/page-flags.h |  24 ++++++--
 mm/filemap.c               |  31 ++++++++++
 mm/memory-failure.c        |   9 ++-
 5 files changed, 66 insertions(+), 125 deletions(-)

-- 
2.47.3


