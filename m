Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9765DC4451C
	for <linux-mm@archiver.kernel.org>; Sat, 18 Jul 2026 05:17:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44BD86B013C; Sat, 18 Jul 2026 01:17:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F6466B013D; Sat, 18 Jul 2026 01:17:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30C1C6B0140; Sat, 18 Jul 2026 01:17:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 034E86B013C
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 01:17:48 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 70B8E1C0405
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:17:48 +0000 (UTC)
X-FDA: 85000740216.14.EB7A9A0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id DA1AD20004
	for <linux-mm@kvack.org>; Sat, 18 Jul 2026 05:17:45 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SftWW0xr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784351866;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+2By7Wa5qi3iopcH+ybIUXR/T+pRugUF9End73+3WiE=;
	b=vClu3i3N+zv8G1zZGiaPUBvNZOI62zYWebHRFWO1+VFz7NbpR8onw+gvABStXGxpZQzJ/w
	4KfJdhn5QoSHySbyTddAryJcUYcoJmyWxktn5QtSLqEm/RFF2CwU5kDxX1nXOSl2CeF2E0
	GpCa9TLSMbZ2M2hQgX4q7+ZVKesGZH4=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=SftWW0xr;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf03.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784351866;
	b=0Ni5Dq9b/UodTrpSBZXlVB+gl2bUTiVJGQtt+Mq4A7Mpw+jwz/cmhFAeeW0JqF57uzGiLM
	j4snCVxhfYFkGiD/8k44mKK35SnoSnvmBKXcaKpVTjdaq1gi1UiaNBxFYXvHDOYJ82UAyi
	MBK8y2es0u7+oefPc7wRFjN8xrRByEk=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=+2By7Wa5qi3iopcH+ybIUXR/T+pRugUF9End73+3WiE=; b=SftWW0xrLl25lB7Ga2LcEq+hMZ
	zASO5adYOgD0Kkdc8kkhbNboCZA3wEyI02nrgFHPfwroqlmsSZiN68u3MHQQSzs4zIFZuZZET4yaX
	A8o0+holVkq6RwJrbSW0B+RRjCZ8oebzUp/uPifIzNSgcXIo4p+pMLHV+bA/fXZk5PXhgt5BaRjPB
	KToJZDlSPlZi/XQ674DlPENX8BcYH50o7ckIfZIqZtbFU/ZQvxkwkUj1LxJVRS4jT0DEK3LQ6Dfx8
	EeQ/ozmV+cgxuJbxDpxVJiT7UlgDWjypCZW1zJ8YnHhMNumih8k8oGT1Vn4LaMTPNEXtkqBZ91BKH
	31lYNsHA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkxQl-00000006NT8-1Ozx;
	Sat, 18 Jul 2026 05:17:43 +0000
Date: Sat, 18 Jul 2026 06:17:43 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Ren Wei <enjou1224z@gmail.com>
Cc: linux-mm@kvack.org, pasha.tatashin@soleen.com,
	akpm@linux-foundation.org, vega@nebusec.ai, roxy520tt@gmail.com
Subject: Re: [PATCH 1/1] mm/page_table_check: widen map counters
Message-ID: <alsMd4aZKfhBE48Z@casper.infradead.org>
References: <cover.1784337674.git.roxy520tt@gmail.com>
 <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4414b588418c52a99d959d35a40e064ae8b6e72.1784337674.git.roxy520tt@gmail.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: DA1AD20004
X-Stat-Signature: tsqq7636chxrnumau336bh8cekww6yu4
X-HE-Tag: 1784351865-703633
X-HE-Meta: U2FsdGVkX1/YTPp9AfT11giX0O/tqNxs+DBMV9oa+AL5K+qD97LKNvPomNS1NSa/qfkLIgILPd6trktdaLhR9RDTjp4YyCKf0XyRMJxSCK8nGLq5eMjLe7Z0AdKhmct58Czo92SHIQHuZBRsWt1kRnPmarwS+TogaESqyHJYBjZJtEvXCKpqX1HIyWqZdFsEZ1ndm+IHsS2TH1trg45Cj7471nDKWz7v8yK1RQd+N+VzJelDOUD/IlYPloVTR3xJot7Jt6Gh7mUaHf0LXB5UPCyDhIp0TxPfHzhNUnrpq25vxnuvSBXEBlV/K7Sss+onMeE2E+BWfLwpL1fsY9tLvOp/NmA2oLoa6C6nVsjI1hdE3A14Lc7lkHNlJpL+kF4YlhuLZiJ9eVzou/B3pmM9AUWVjTAQGtwulhR/DYBEAGh8QUVx4/n4IxCdE5EQI8Gcp+E6ebbreWT9Jf/YqJHYKgR6sudd/tI0+avDuu74NwH6GQ0ifkTVj5gkxbqtAjXaK65UsOpPW+WUjFTXYXB3aiuFfXB+ZYGju2XLnZu5cNvNCPAXV+A+juxRTWoo/g3OJiaZlSWNDVIah77A91X84GLLLDMaf9zy/QBeyotmFFfQMDrLqEmydz07qsEmBfIWoJiN5DJLyKHt9ONwx3uyEe67YfIGM8CHsAUUOJGH+tP5Gr+B+J9Mi0siRvwtCOsme41iKSiRz8RLenN5Y1iPIVwZGId9ylSYkbxsJ7tzenbQ9MywHzDtnutshlWKMFbbbaUjLhZyKDTI+SVQ+dyGbEnShZdhlvP9yxoqVa6ioSyvrWkoSvBp0vlarX9c6FFrxHW/kgOjNGtHpu8t2pj4izdJheKF3d/xPZnqdOkCAeee9HRGLXhmFZt58lUMBbjvpNBMcbHTgWAxCww1t57JmnAfwZJ1tRvpKaBk8IB3whx6kdy8vC8Tl0I4niK19dbKQMgj43f6NF02ix/4JWY
 GiEJUGYe
 THKjoB/o5Z7qJ3RPBPHiywqFM5oUORC11HghQApCxkguYfvzQCy1Dw8ZLz6LfRUaoQFxDMciWv/eJyGIHseX1STpyED9vtm8G/30vLBrTxFt4PbIJXutpuA8xsuhJRh03khX01eEm+dWC461jcLqXe9QmujCpheH27sE3dMAI331N/zQj5Pw/BCR/XNcKuJ0N9GeMa0oeVH6hO0lOrrFcDVnIPDbArG8kZrcU94lvK3YGBVeoEX3uOhlGRXd3l/jCfhEYLqWKCpgCgjOf9g+VifIxns9XFaGDXv+R
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Jul 18, 2026 at 12:27:20PM +0800, Ren Wei wrote:
> page_table_check_set() and page_table_check_clear() store per-page
> anonymous and file map counts in signed atomic_t counters. A page can
> have more than INT_MAX read-only mappings while still being mapped
> legally.

No it can't.  mapcount is 32-bit.

> The global zero page is one example: repeated read faults on private

You mean "is a special case".  page_table_check should handle this
case specially.


