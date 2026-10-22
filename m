Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E835606A32E
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 07:23:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=T/lTafwa
Received: by kanga.kvack.org (Postfix)
	id 1B61B6B02A9; Thu, 22 Oct 2026 03:23:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1418A6B08BB; Thu, 22 Oct 2026 03:23:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F24036B08BC; Thu, 22 Oct 2026 03:23:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D16546B02A9
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 03:23:44 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 65D1580741
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:23:44 +0000 (UTC)
X-FDA: 85349422368.24.E7E5802
Received: from mta1.migadu.com (out-14.mta1.migadu.com [95.215.58.14])
	by imf04.hostedemail.com (Postfix) with ESMTP id 5C2FB40004
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:23:42 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/lTafwa";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792653822;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nxhw37Ts8JjVkeWnUUXvGcPNaHqWJWHYSG2L4Bkd61Q=;
	b=b1qvqQX28wzr3C1iBL5FNwY+CBqyqvwiBMqOBZ+MFZokVWFPzmn3ZNArNRa1a84LEfVwC5
	jzhQ6YxDkOf2XDiAK7kHkGhIFXgbxtzAav+/FUXYZkI8XhZ4nTqenIMxYmfbr7/RMCv1gM
	JngwNJGP5ibDOaHsuXeu58x4bzT8SCc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="T/lTafwa";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf04.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.14 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792653822;
	b=zkf03qu5SwLM4CaYEfmNWbNc4olR52p5ZwmReIEOP2QQybTzGBOsLZGQv9UinD07F1Dgw8
	Dmv8XxVvf7Pg533IPjgg0Zkn8ixPSWwkqQMHPnCPCRtkl+rgGnKmZXq/cw34z1SnAQfQ44
	vorkcUveCVcUjT3dF1ZOA8BgZNRdKbQ=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=iMb60vufG01+4AZR+z8pGmBhQmm04VfW1fUB7oSscv8=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792653820; v=1; x=1793258620;
 b=T/lTafwa65EQjI/GtYIBCe7AQBRuvqgyRLahgfzDvuKGIaOaB3DFUhz5dSLW7IXuO2QqUQ8j
 S/qh/jKzHOmbM0GHuIwfOhGFPo0hb2NzRYMvUEADqKdMrWktbH0gGgxy5rTpe/8EnGUFfgxFFTq
 +kwRSZLqQpq/Fpxk37KiTDtE=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id ab87abfd04d8baec;
	Thu, 22 Oct 2026 07:23:40 +0000
X-Mizu-Trace-ID: ab87abfd04d8baec
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: osalvador@suse.de,
	akpm@linux-foundation.org,
	rppt@kernel.org,
	qi.zheng@linux.dev,
	lance.yang@linux.dev,
	jthoughton@google.com,
	david@kernel.org,
	muchun.song@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] mm: hugetlb_vmemmap: simplify vmemmap head page handling
Date: Thu, 22 Oct 2026 15:23:29 +0800
Message-ID: <20261022072329.67561-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261020115824.823278-2-songmuchun@bytedance.com>
References: <20261020115824.823278-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 5C2FB40004
X-Stat-Signature: mpp8fd6bgwjzsuyizwums6yd7tepfj9x
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792653822-369680
X-HE-Meta: U2FsdGVkX19xrcKkZfvN1lb1P8p9aAlM457qP73GKNdDwceba3PRtUhLjjXx58Wec3nZuDYaelfs1AZ95IctmDMTxEnZL3TKNYAAoGygFQn5+RCj2rNDsXDtU+QSGHp8MqmMWqjMF7bzvQ5aQXOzRSfhqBvdYHQbKpIIf5eeyY/uRAftCeM8eh7Azu2qh0yrkC0ySm8H38m2N1m+p4h5E5AjPwNXFA7IZUtxh4yb6540KTCzNfpugGOoTB/2wf/iDzn1vCrDgTp4aaaoYxdNIW/5g3XYY7ALEIjvriMu3NqAs+Hv6PZRyd5dRnQ040v7vbtKZ6SEkwBn5jpdwnLjMK7jkappl15IHJr4gznquuuZ40IQkuU0rRWQm4wM+Y5XjLYoeAO+4GgSQpL/AQxBtWenKJ/eUKiihbdPIu+oITPFlBDri7ch7Xqym0rX6e/M7Jt1QfkUxwxRCpG+4PZhZMaxMdpaY71Hor7+pPgld736IuhY7aaLJjM4Gr1cqZhDErgwmeZkRUelxH27sG6glcoy6BvJpCYmhVal9JD5/X1spDYLRCOY2v6A2PU0i9+0UGKc6irwummPLFbc+YrXQJndiNSLKQ9ywaEgYfIc7GgmBZty4KnKZPjo/4NzMbtZ4HVCnL7UujE2pTmOtoQ1o5ndSBou3ajHX/9TomjsSOucyVcs/B91Wk2m+Ypde8rcj72wbdV8I3SCfFcoVDOqrNd4kvX2AHTCCbA4faHXa7OxP7LLDIHGp2H2B6b1B00WI/O7Ev52p1d/qLZkr3MEBm9KRpsgPmadKFfawwRnV+6RpjU79VLzXh7SE9qrBScPdrFbTMPM4WDrdR0oATdYqrBqkdMMZjUJlfKsXoo7GKNYqUV5ozqJMlQn4eAYlgqp3LdelH5bapdOyzRJAUklxHqQg0H7fYaQt/edy1DUaZhfnuYJTCRjcoVmWSNGVSA/+8KUCnj9Qea7S8nnSFj
 xotiULZQ
 1E0yB4gU4IGfywfIeb54CoWjcxJh+RnMyjQCEDG9Y9SJKenWltXnGgUMjvf2qUAJK/hvaxdjpOatTQ7NuEGesjj8qIHwZqfwbB2xaq3CRcJMRfjK9+ATxLdSqiFHL4Kvz9/8E9cjSNhTCfByldw7G7XScI4zxiVmrLoHdVIKhwCqEpT3XTVMI0iy/kEFn+op84AulhCK/ARWBKeHTcsnonSw5NiYu2mHivo+p9pvefmlNxgcz+P+la/1b9pKTyREkZ+EtElor5jPR0k9vIHvV3vWLVQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Tue, Oct 20, 2026 at 07:58:15PM +0800, Muchun Song wrote:
[...]
>@@ -289,7 +290,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>  *		to remap.
>  * @end:	end address of the vmemmap virtual address range that we want to
>  *		remap.
>- * @vmemmap_head: the page to be installed as first in the vmemmap range
>  * @vmemmap_tail: the page to be installed as non-first in the vmemmap range
>  * @vmemmap_pages: list to deposit vmemmap pages to be freed.  It is callers
>  *		responsibility to free pages.
>@@ -298,7 +298,6 @@ static int vmemmap_remap_split(unsigned long start, unsigned long end)
>  * Return: %0 on success, negative error code otherwise.
>  */


/**
 * vmemmap_remap_free - remap the vmemmap virtual address range [@start, @end)
 *			to use @vmemmap_head/tail, then free vmemmap which
 *			the range are mapped to.

Nit: could you update the @vmemmap_head/tail comment too, now that the
head argument is gone?

Nothing jumped out at me, so

Reviewed-by: Lance Yang <lance.yang@linux.dev>

