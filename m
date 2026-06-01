Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20A4BCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 19:26:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8B9876B04A9; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 843316B04AB; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 759716B04AC; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 628FE6B04A9
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 15:26:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 24901162720
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:33 +0000 (UTC)
X-FDA: 84832325466.07.AF2AF9A
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf10.hostedemail.com (Postfix) with ESMTP id 4C016C0002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 19:26:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W5+367Ih;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780341991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=3PRjEsmgqn76Hd2Wr35ebCoWayo4PkHbW1sfCmMDIy8=;
	b=UNNb1ypX4CG4z1c201pfu3ktDruSxahQH0C5l5rstS2GnlKZi6bxSC4uiAP1hZx8Di57xY
	cnT3DojrGYPr9MvNCZZJUNUaUL/CoOjggUd5B7GsyiSN2MP0l9h1jkezVm0CmyCgSQwP+O
	1j7LLwyPjN/6RFvkpXTnkJMqzGK23ic=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=W5+367Ih;
	spf=pass (imf10.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780341991;
	b=yE3CeG/VOsMXjQ6I2yrXuMhipnOu7zb/K2rPNHkdqhKC1xb4OV5NmC//v/vxZkSRqExMn0
	/oLdK6nVL5XX9TRiQYnXvxw7RDJBCdrFh5wE8WSWJMKRJEQws9jVe6TKV9Uq6HFRhZJ3sr
	7mw/Pb37CkKcOhHoxOMs2gJ7/JtVZ8A=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=3PRjEsmgqn76Hd2Wr35ebCoWayo4PkHbW1sfCmMDIy8=; b=W5+367IhtKRMk7vu0I4HVYNrL4
	h0RK0yNF5w7DQIxzCKJ4gTHZD5sC2tmCEfTCxYIikZGm9+jjZ/BI3T9qoTRLUDnuSSn2xx28uzoUk
	nOS7wb10dm43jRP07T7UsfOMmOVF6fYLlIdXp44TYXe/7qLOWHG8ohAR9LHQTEWPNBMY79DyW4VXE
	26toNjsg/wTctKnds1uCTX9vHlufAsNGaLEcQ21OEsxiNYWdbnRv1mWG7z8qYmdXDiAKOyBiuPwQn
	qPpRPcEcJEOLscP+UAtnPkW+GmxbUyt6DWVQiDIIuVrHUdIpzbbzaAuUM3XydHaPdsYIh/8G1hjNc
	52CpbIeA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wU8HL-00000000dEU-3LO9;
	Mon, 01 Jun 2026 19:26:27 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Ye Liu <liuye@kylinos.cn>,
	linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/3] Remove __folio_index again
Date: Mon,  1 Jun 2026 20:26:19 +0100
Message-ID: <20260601192626.150804-1-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4C016C0002
X-Stat-Signature: gm11y1dpirzqksgiit5wtok4axebppu8
X-Rspam-User: 
X-HE-Tag: 1780341990-888005
X-HE-Meta: U2FsdGVkX1/9qjDb2hKpVO5GkWmOks9m2q2BeoGvYEsLsAHw53jtETpo954DGC+3XtId4EG2DGL1C3GpSqViRduCx5R92LisxdaoTtykxzX1GZQEdH6ShIpLP7MiA5DSHM2tqyPhJZRvT3m6Y11tfiWDOMatyurjRQKgzgJWeaC4gDzKgGQJd6E1sZidj/upI2CrE2NmcG67Xmhvy4ZXZ6g9XNWhmZHEnrPNoFtRXggj8EcrNjWnC6RdqJ1ZRmAFDYEL1/D/153Zr0ekmwQTkuatLSY2O4lRA5hk1Pnf6Nh3lbKITpbtYuSxRIC4sMb/27BxWlJ05vXM3jwS5c2a8ZBfYHABY3iUJOhBwYjeyT68oWQ2avJzSe4iwerNPyTyEOoB4qIfQ6juk4CiAzE4biyQDFZte2hH8iGRuc2tNY4YPwOp6tke8yehgk1lFm2638xR9xY99aGmYCY2Ifq2oQlguxZc2HgsIdcDrnCb6EbmgpwmE6gQT9CxjKb9hOhQrc22Qcid4AODwklfLAj0NudLWBHZ4LW639ocXlkY3jzX4SXIi3s4ZobNLWEbykFQmiSjw3g1qw2zAMFY8doh5PjXNfE5rFvhUTsYoToC+0UU4kpMBNx4Ut7qzyiY62+4WT4o7EUB2maWUpH0J0H74zr4TnclwtYvp2X/Opg5Bmd9ZW38sslh5XpIeYv39FI2eGIK3WDcL9LBROX+zHDm3zWao/3aq9/ApeeGxts+JFGyZRCJPQnyuygzSpiFvcVxgR41PPe4Pn6FIcwFIFZIKKAgLOxFgoOj63k/lrwcIVknZY42JUgmwl4KNXHZPC30fRDN+HWNXpbG7tE0gJhbMocqJACc+tbmW8dMVUqWdLW0COw0sguEgxi8S6a15E/legS9CjmOu9I9jvBXM+yzDTHuwlWAXaTHkvg7O03JRID8ByQb4utN1wd5l19D94wqsmA80mkJnGC5ygC60ND
 frXTK+xg
 MLo7MyUM9S8EM+dFgqkPvt69ktRx77o6BQ7/DcHxdPfYAsypDZqi2B0lOIEem2NAyzwvdHG7xnhhXPXwsftW9UquLHxpNxJaSDab047dqfqwnOouoBJ9J1yiYPxkBeplznx0AnWYtgoK8TjltjZjx1TSDSzbp6IqNJxM4rIwPyOLMi85aaxV6gQkxm/SETleuczjK6Xam674d72kUiOuVR3O7vpqfkJTqSOvE
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

I renamed page->index to page->__folio_index a year ago.  That proved to
be insufficient to prevent people from using it, so take more extreme
measures.  This breaks tools/mm/show_page_info.py (I expect) but since I
don't know python and have no interest in running this script myself,
I invite the author to fix it.

Matthew Wilcox (Oracle) (3):
  ntfs: Correct use of folios in handle_bounds_compressed_page()
  ntfs: Remove references to page->__folio_index
  mm: Remove __folio_index

 fs/ntfs/compress.c       | 54 +++++++++++++++++-----------------------
 include/linux/mm_types.h |  9 +++----
 mm/zpdesc.h              |  2 --
 3 files changed, 26 insertions(+), 39 deletions(-)

-- 
2.47.3


