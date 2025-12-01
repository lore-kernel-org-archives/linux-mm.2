Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 415E4D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 21:20:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8AC4C6B0011; Mon,  1 Dec 2025 16:20:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 85DB66B0093; Mon,  1 Dec 2025 16:20:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 799F86B00B6; Mon,  1 Dec 2025 16:20:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 659086B0011
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 16:20:10 -0500 (EST)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 700E41403D1
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:20:06 +0000 (UTC)
X-FDA: 84172170012.17.E96A287
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf23.hostedemail.com (Postfix) with ESMTP id C21AE14001C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 21:20:03 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="v/1wqjVQ";
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764624004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WiTdOzM04TmD+7whCaojUYm7mGYFeydQ5w051q8EpM8=;
	b=jYzH4eriyqbeY3cnJC1vJbd0JbCgL9cxlLMfqG3bStG7bVxHwzsrOwjKD4BZ6zD2IVMRdl
	Rh3RIq3yxrAqSAn+/lFWanjIqMJlb1033WcTmSaR0Kh/tAL//8fcQLLLoOP6CZ2Zuk09IT
	6EUmbpWF/xoIFYTIJJTdBJFjRqg3Rvg=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b="v/1wqjVQ";
	spf=none (imf23.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764624004; a=rsa-sha256;
	cv=none;
	b=ZG46Wif14wJv9f/APE/zzkf7qWZrzdxtYXfuN07vjw5fLM4tTYys264YvbbSYxwguDsYQ/
	Cg4UWA2QQuyvSpu+W4kS4rdlGcICzKv29BMro/TFM26Ty1lSTJ2o6F2IbYrCY+9nu7h9Gr
	uHx+E9nWJpVMwdpqr1yUA7D8QLHvf7k=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=WiTdOzM04TmD+7whCaojUYm7mGYFeydQ5w051q8EpM8=; b=v/1wqjVQuVqUG/+O5g8v+0grIj
	P1nnzXYsylJ3+vn50/5fcldCEWTjr1aELVUcxaJQtNsdoQBhsvwSpjTJo6XJdZTKhHeTHF2fKwvPL
	Fj8jVOeuyZt9q3M6YcJ4CVd4CWZHUZtkx65fKuQfkRCAEXo18n7VA/h+o2haxIwvapGJGUtayaSw4
	N/z3YzyeJBiFIDDR5zHljspUkRY9iOrT5N80nvesmtQA5c08KSEWOITB7oIqsblySL7IRXxyHa7iU
	yhEqJxI0XnsbO5RLFr2AQW2hqZVoKCrs/3AEe6E47E8e6QIq32Cq/s76VbiSVgeBqhxp+dQupk6FN
	a2C/6frA==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vQBJR-00000000FYG-1Pcz;
	Mon, 01 Dec 2025 21:20:01 +0000
Date: Mon, 1 Dec 2025 21:20:01 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	linux-mm@kvack.org
Subject: Re: [PATCH 3/4] mm/readahead: add a_ops->ra_folio_order to get a
 desired folio order
Message-ID: <aS4GgfzfuYRHJdg_@casper.infradead.org>
References: <20251201210152.909339-1-jaegeuk@kernel.org>
 <20251201210152.909339-4-jaegeuk@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251201210152.909339-4-jaegeuk@kernel.org>
X-Stat-Signature: msfo4xkij7n83fud8djz4tr84pw1ewa9
X-Rspam-User: 
X-Rspamd-Queue-Id: C21AE14001C
X-Rspamd-Server: rspam09
X-HE-Tag: 1764624003-685103
X-HE-Meta: U2FsdGVkX1+mec05Joqh+p4pgyItDbHwrQ/qxcpoaIvWiWoW0zU2l7HiwfOyGv7ljpGv4T/iUo5o8F9Lt9lH2aaydP5mRWaInlpIBsUKoJV83tIZUybQvVWk6Dy4j+nZqrUTZnonPD2gnXYLvXBFSBFCxeO23Sw+zuhxCbZ/WYQbqDGapSlUNi0HWVhKne6AsS6MqOT5dHWKLAr+J1+OFuh+LM3gfIqj/lTntVmQA56mFa3vwgUDon+TKqf/+zE7EiVWzemhdwbjAnnWP2GKmfqNLyt7Bijq7yf1PHZvii6UaoHfrLSAtxS+nNsgej6qPip1KB85DIFreET3sCmfQWgVOcA5uPfzwI7xZj5z5JzYsyGOJDBeGpT+bpPK2FoTuUV9+QLv/Sq3j/XjVRE1h4cl/xcgV3bkVCmvCHs2eyn0rOzsAZqbbOEK3YAPjiCuZjXBFAMRkoCS9TPzMgOhz2suz476PzHdjxURKTUx/TE9quA7WbFYNN2mIOnVa2sn52f/G4qXBIhUbSYLyj5kucb9dJGFihBx5XuQq2AT3qIpgvqMw1An1e9gcAiLTm704uAuYtk0HFKozy3MQyClbDeUp4tqGT9VUn7YozqQ1UajcRecb339l2+z2flOCasCWZpLcctH4hRihoofpNBbk98SneDv7zAgzapmqMxOmtyH2qbdVKHrEjtrJzpOu5OedZTEZHyoeswp3NV6A58Gxt4NIXwbs5g387J1BMcLeClqgjwlbXvnJbWhFer9DODqeOTXdKSABklxu2lZQVT2Ppz5XFXR8BuVdfo+zr4x/FHEtHTHTodIPurjW/gNU1HIoU4Rk0yDyV7CHkRC7GmSt+odrTHd+dogkDNvWiz13IdydTHfifAmQZrD8scay01f9ewa9QTi7/wlfwILY5wtPRgIfBbyEL/mDOJOvU/+IqIH1YBqP9Em30GWdcKTKEv+P/0AT4A2BCKqVeemkZe
 GxHvZggs
 NG9CETiJNTB+OwS5e+xO0U4JTbL9qPKn/z7m6KKBxly5IgIUuLeD/AlQgZn1cUhOxKz4OJAlcBMpsL8iKJEfJer9RAEfsfqsvoaAbIzz79jDYXJ32rdBgEkZkVQv9jYmWfp9oyqJHBe17SobwegP+x2OcHEWFtieQi4puF5vCf9oJH+tMLvjK0SRsFIpBGsHY2AR//qIC3pvQlvRNqFcA+LOQQSVkPxrPB9PWawRIPmnUCxUORhs9ttKyGZHKvTtDQtk0V53bGTfalBA0CDkvPcQtENOI+xdEgPJBmuzUqFY+RRY=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Dec 01, 2025 at 09:01:26PM +0000, Jaegeuk Kim wrote:
> This patch introduces a new address operation, a_ops->ra_folio_order(), which
> proposes a new folio order based on the adjusted order for page_cache_sync_ra.
> 
> Hence, each filesystem can set the desired minimum order of folio allocation
> when requesting fadvise(POSIX_FADV_WILLNEED).

Again, you've said what but not why.  Does the mm code not ramp up the
folio order sufficiently quickly?  What are you trying to accomplish?

