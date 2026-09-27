Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9D9E2C9832A
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 01:18:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635B16B0088; Sat, 26 Sep 2026 21:18:52 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60D1E6B008A; Sat, 26 Sep 2026 21:18:52 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 54BD16B008C; Sat, 26 Sep 2026 21:18:52 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 307E56B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 21:18:52 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 87B6340948
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:18:51 +0000 (UTC)
X-FDA: 85257782862.25.4CED964
Received: from mta1.migadu.com (out-53.mta1.migadu.com [95.215.58.53])
	by imf15.hostedemail.com (Postfix) with ESMTP id 5E648A0005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 01:18:49 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ruA78NxH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790471929;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3daKNzbFfU99oulv3P4W3Zmgy6p1JMx7jYCPai58f8k=;
	b=jaerBbeJheOPWMCKlmKZz4p3E/CYQ//olCLE91xno0Zf7JorzdrwKKv4k7dzxnnO8PLl04
	JY+iKs4gWh1Nb2nY6BfTNGnN132wodLd4dOILgDUQShX3wt5QBSX7ZSQkb/eph03jDO3Ld
	A6G7gcpzUouAVIM8GTi9Or+ygva9eZQ=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ruA78NxH;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf15.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.53 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790471929;
	b=qsjnRmenFJh2oRmr77F2XBFjN3xIgCYXJXrvhzf4vxphKgiOtmQAZqtbx3B5H6uqirhLcz
	hg4s/mdmLRYM8kf3ax3gD2gMDRt8fQbTMki5rrNrPFZDkG2GVjbTQdBH4tb1txfnR/6xJB
	u7yKV0YXw4HdB2thoeVB0KMQpXlMwFY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=BxUPSzZDS3MMZBdygGN7lGzobedNX+2vAOdH6yZV9HQ=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790471927; v=1; x=1791076727;
 b=ruA78NxHZghH/CS8b4IZTk3u92vY78GLlbeP2q+V+oY2f0rLYCMkzg+mw/U14VljTaa4PUjQ
 JZkBvhM5D1jCH0jZF9kLvoHZHBlLM5u8lrLPTzZxe/15Hv71cR9iG7tzX1zk7g6E2C0Po3sEgas
 pqEYe5W/QQQfBXlBk4Eddigw=
X-Envelope-To: linux-mm@kvack.org
Received: by mta11.migadu.com with ESMTPS id 685dda7770d68273;
	Sun, 27 Sep 2026 01:18:47 +0000
X-Mizu-Trace-ID: 685dda7770d68273
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.700.51.1.1\))
Subject: Re: [PATCH] mm/hugetlb: fix subpool minimum reservation rollback
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
Date: Sun, 27 Sep 2026 09:18:29 +0800
Cc: Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Wupeng Ma <mawupeng1@huawei.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 Jinmeng Zhou <zhoujinmeng@bytedance.com>,
 stable@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <EA8A5B8F-CF1B-45B2-9E2D-CF59A67050DE@linux.dev>
References: <20260907132055.26696-1-zhoujinmeng@bytedance.com>
To: Jinmeng Zhou <jinmengzhou22@gmail.com>
X-Mailer: Apple Mail (2.3864.700.51.1.1)
X-Rspamd-Queue-Id: 5E648A0005
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: nbb7tzajtpucrfbr6ich3whihtychruu
X-HE-Tag: 1790471929-710608
X-HE-Meta: U2FsdGVkX1/rCPiwZzoxK/KX3fyEAlANt/he77sTNphrxLzqsl1vUUfqisZVB0nAMrwRR+/ZQVk36ulofN5dDFvOEIn8kI9TNAJek2C06rSAFSrH5bJ9iIsgti3WU/0usH6ldYwsYs3vHvk4zKsLrI4bA5nlAEejmpuzL4MRwSquz55Xtm1aFcctmGGHiDu5rK90x+UebCUNbI6xlxuPGp1fBaompviXFhkxLU7EGy72VpnIjmjWGvzMHMghDlh1FRi2aKbU7s74lQ6BQDhizGAtc8kBoBPjz2HEcw7sJcsV1GYBXZh0yMFAyRY3Qmk9u77Q+jifC3QqCEemM/S8UA9AaSrK4ZxxEsZO/i59vMkSUl9Ds/ucfjoLxM2t108gMHwE7KyXa5yui/DHaqLcXJwawVfks9AE7LPmv0mp3PJ9T+q/F5v2z7STMgxcf5yo3XFIjNKEdEhModP93aniBpNluOwwvgKfAzSUDL1wgAovgMLJSR/yx+ZON6JYmZDbW/GPMeYnOLRdhLy7Wo0Z/9drNxkMWffDmgAg+dMQSb2VxPpQrQKoJwcsgB26qUKpXG1UVDSSpfNdaRRzxPq6EIoFbRXlXGdgJ0pqoqEmW10J69wyv6EkWNl50ZNYld0/mZ3dW/Jk4x/i5yGAu1QB4zWzQxjDANeY+5KIPHMEGxnu1RgnpIDZa4zX/7GFyYKaRjnnElw4AUmoQCYOORlDnP5iaATz5pKSxkODbaN8tIpwytQrOUpqpo6ABA5DsAQupGmbh/9+VQ1SpJwMlwnVcOHAWBrsWvyncD6XkY3wm/COoM6Cp4wAt8Os0h4iReWWMAa+fvDhU5tNix84nzOJ0DlWG1lJvDaVqzAeZs00eCaPFOz9GxFb5iwNilGpLan3p2tr2/RCbgt5y4To65ZevDGWMKSqysohl9p3ecVay0aZzvL2BmN/wi/nHBd3wRRyuNrFf8kZX2lvshctLyj
 1Tx+yvGC
 lhPW7uhfQXBL0tjQHDWnCSY1PLC1y3n4ljy6TiKMlm+38WmqstDdLn/5N+kv1NXh/Z4/faca6ju0DFXH0YUPJrZVMJbWbuGhmE7zHUN1mwwJ9i311RUup1HX4WNiE8CK2Q99Ob1Yz4/W4OcNAUdwea/vxPjeChk4JkPbPnqdSTB4QCWJ9ZC4u2pKBzTIcN0NKU5y4Aqzpfl1NWKnJcHGfDfNY0RO4sVTqz4xdyvkS7whxExjXFDDv6FFMrCEKXGhCSe+3XfxQOvgaIJh0hsegzd9XNRUxpwiSyxtXb9lpOuy64iERCxfzQ7a/pu8+yQt6Lr/UiAM9ahxdkFk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Sep 7, 2026, at 21:20, Jinmeng Zhou <jinmengzhou22@gmail.com> wrote:
> 
> When a reservation request is partially covered by a subpool minimum and
> the remaining global reservation fails, the error path first calls
> hugepage_subpool_put_pages() for the subpool-backed portion. It removes the
> failed global portion from used_hpages only afterwards.
> 
> hugepage_subpool_put_pages() uses used_hpages to decide whether rsv_hpages
> should be restored. Since used_hpages still includes the global portion, it
> can remain at or above min_hpages and prevent that restoration. It then
> reports the subpool reservation as releasable, causing
> hugetlb_acct_memory() to incorrectly decrement h->resv_huge_pages.
> 
> This was reproduced with four 2 MB huge pages and a hugetlbfs mount with
> size=10M,min_size=8M. After a successful three-page reservation, a two-page
> reservation which needed one subpool page and one global page failed with
> -ENOMEM. HugePages_Rsvd incorrectly dropped from four to three even though
> the subpool minimum was still four pages.
> 
> Roll back the failed global portion from used_hpages first, so that
> hugepage_subpool_put_pages() evaluates the minimum reservation against the
> current usage and returns the correct global adjustment.
> 
> Fixes: a833a693a490 ("mm: hugetlb: fix incorrect fallback for subpool")
> Cc: stable@vger.kernel.org
> Signed-off-by: Jinmeng Zhou <zhoujinmeng@bytedance.com>

Acked-by: Muchun Song <muchun.song@linux.dev>

Thanks.


