Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E0A8E6B257
	for <linux-mm@archiver.kernel.org>; Mon, 22 Dec 2025 22:12:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 73EFE6B0005; Mon, 22 Dec 2025 17:12:48 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EC966B0089; Mon, 22 Dec 2025 17:12:48 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F8B86B008A; Mon, 22 Dec 2025 17:12:48 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 50C726B0005
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 17:12:48 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E98D2B8B78
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:12:47 +0000 (UTC)
X-FDA: 84248507574.28.61F77F0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf03.hostedemail.com (Postfix) with ESMTP id 20BEE20010
	for <linux-mm@kvack.org>; Mon, 22 Dec 2025 22:12:44 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mR5RyS9C;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766441566;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xHAzWrLppnd1qY7HWbrjONaXT11vwpbQpr85CaG0W+c=;
	b=LeyLoSXw141KihoKuvyRI94/Nu80kLi6sQlQv4bwTJPrXhnVHdOxVGIuQv4DP1H9Xm2ibm
	f+sPoXbef/zpXwgHAxqdY+6CDYhS4fMvHZ5eOKqtuK1GaMAKrAQ4XweTRMQwrBcfsFDzFz
	vPfT8ExD+Wz8E8jlOKNTKnVIALGETPc=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=mR5RyS9C;
	spf=none (imf03.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766441566; a=rsa-sha256;
	cv=none;
	b=2iu0tj0IY/Z/qjes0vffeq795pagcS+ZxKgtoxc55GQONwJY246YzToZbLKLiZX4IAHOZw
	+i0siFAUzuz+pBiPU5s9dj8NxI43GKRa70InGe69i6gjlFHZWui4jNcoHAKi8byIABp/Jw
	a2V54nh86yyS3mwgCv/5CzVWWuWsDRQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=xHAzWrLppnd1qY7HWbrjONaXT11vwpbQpr85CaG0W+c=; b=mR5RyS9CCuNYAjuw7S/j2YJ+ob
	UQQQ6Ff6Px910GxRsdifWZqCxJo/Cb1ngYGnxJLGnIoTf/G3s9Sqiqlr9cDCCPLoyoVcq+2Ccojh/
	Zw/Mu53dp7bpw1Rj6Bn2q9eiyNNjEBqieE8Z8Z/yeLFIenlsaecMAmZt3g2UkC2LVQ+3ib087V50u
	pyy8ICCrhp5T42J2InjhaCKBKnzRbKnN2L0+gx2/xEcVUncdygPWpJ0ER5bMkfWb22i44dQkOsIBD
	BPnetJx32TNIIV3EE/yqejjcdjWnwbTo2dAVibctdGwNFuNg21fnpIkKltY+MFm94DD+mb5F7qd6N
	pf+WCslw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vXo8n-0000000CFGM-0cch;
	Mon, 22 Dec 2025 22:12:33 +0000
Date: Mon, 22 Dec 2025 22:12:32 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Jiaqi Yan <jiaqiyan@google.com>
Cc: jackmanb@google.com, hannes@cmpxchg.org, linmiaohe@huawei.com,
	ziy@nvidia.com, harry.yoo@oracle.com, nao.horiguchi@gmail.com,
	david@redhat.com, lorenzo.stoakes@oracle.com,
	william.roche@oracle.com, tony.luck@intel.com,
	wangkefeng.wang@huawei.com, jane.chu@oracle.com,
	akpm@linux-foundation.org, osalvador@suse.de, muchun.song@linux.dev,
	rientjes@google.com, duenwen@google.com, jthoughton@google.com,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	Liam.Howlett@oracle.com, vbabka@suse.cz, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com
Subject: Re: [PATCH v2 3/3] mm/memory-failure: simplify __page_handle_poison
Message-ID: <aUnCUNjiBOp05kVD@casper.infradead.org>
References: <20251219183346.3627510-1-jiaqiyan@google.com>
 <20251219183346.3627510-4-jiaqiyan@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251219183346.3627510-4-jiaqiyan@google.com>
X-Rspamd-Server: rspam02
X-Stat-Signature: 55zc1ishak8so3oirzwmxm3exedywhbf
X-Rspam-User: 
X-Rspamd-Queue-Id: 20BEE20010
X-HE-Tag: 1766441564-121320
X-HE-Meta: U2FsdGVkX18rRYoQbgJFDSPEVAstmZcnM8y0r2Yfx0t/SHkjwx4cn3ZXUDugni2y97V7STSwnSj4S9+cEX7tah0yVG64QilgVNVO4WhvC7jkHM1Y06TPioM5/4Y1fNgajRb4gS1bNlVOLQIETB7Vk2aJewrkv2NfQnXmGf8Lcg+mJ8+cI+pz2NOEZI5dkggOWTxL8pQcwiphWOBzGpkTfdCA4s9ZHRFvb5nsAMsXAa9WNJQnqg8lFWxKauhdHoQLWCwE2BO2dnRvKys5D4bCQr9E1nYTaS9GRB/aJCogty3/cikOvWyocoa1yMJyO3TzcEcKvVdQknJSPoBmvkZ/mUYxnXgj/2kRNOSjIk/CDdSjvUcae1uDXDuu0NkQdnbc9CRvtKrffD3qeEkNp6YuW7vypdxhlZbBzZGLLpSQiJi4pCDkZwTsPCmaOHWFuO7MVbD49fSkXiPuTT56IjSVwhyNsuGZXi/83/p2MydYWQpp0n6Pc2vATq2ZTJxQCW5ko2QguZPp0c0COahfyixmf7iq5CkxRvdVmWWJ930SW/PnWh19oF4fk9ajKILP5UeeWiocCn/qqh0ZiK7o/k1xKrkJE4/pBbMZdVm8sZ8YuWGeDR7p9uLnjJxu64ybtEF3MhBn0OZX5wmbKYm1eXqNE0dm8Zibhg9IFkR5q+rMFqvct1VdjiZV93xuagSelYjslCiU+8sPJTOMCwCemS0xFI1ItGU9eJ+ONjmQ760LSSZyvRCh02HXVCKXhz3WULk2xKAYxPd4K9ZLbDio8TSVvR73dB/sDhc4sW46LZKrQnFMWhJojZ3L0x/9XjNSH4qa/u+SZ5guCxxExbRV0kGzHJfKz/P+OGgGJj9VOFIJv5QyD6j6mxnL5vYoT7vZiGOgZc73cbZbHbbE1UmI1doFVzwXBi/ZEpeHj2GelloDqcoqAlCxtjxVM0RAU7m9Ww/tR5zS6mEsf5TqrTNbcMD
 P8DtiQfc
 V+GaFGY1yC5VY3QJhjcXPpj6m37Trr2icGoD27nR/lHf2O+YFkGuREnyMgynML1HBuLlTTomESdsrO1rebhdSXyBDlHTc7D8/4+DBbiP91Mpo+U+lA2vYD/gXa3QDZBd6DzdrJjmeDgR/bvyo9ponBmae1m/9wDCznmbzkhUC3Lot54hKRiF56B4kaIcZ1wnxxcSKlsVM6TFzEsIe4OaWu0RIvaEI2Sb0oG7TUZQd7eIbMh4FDSOzQUu3ua6Y7bAZWpCeMEmEqkXqa/5XBA01zla4ZyPXvzpENDhXyFI/9L+lyNHdEGuH3X7CPUjVLNLaD2pYuRGpNIeDckmTjNcfWDwAx0z9ouhQi1LilDeZ+MYcgb+ij+BtL53B6A==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Dec 19, 2025 at 06:33:46PM +0000, Jiaqi Yan wrote:
> Now that no HWPoison page will be given away to buddy allocator
> at the end of dissolve_free_hugetlb_folio, there is no need to
> drain_all_pages and take_page_off_buddy anymore, so remove them.

What if we discover a hardware error in a page which is currently
in the buddy system?  Why don't we need to remove that page from the
buddy system?

