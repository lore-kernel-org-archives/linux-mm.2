Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3292C606A32F
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 08:41:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=CzAvgxDR
Received: by kanga.kvack.org (Postfix)
	id 48BF16B00EF; Mon, 16 Nov 2026 03:41:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 416246B05B4; Mon, 16 Nov 2026 03:41:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2DDAE6B05B5; Mon, 16 Nov 2026 03:41:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0A58E6B00EF
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 03:41:15 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 81814A05A9
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:41:14 +0000 (UTC)
X-FDA: 85440337668.22.5328CE7
Received: from mta0.migadu.com (out-122.mta0.migadu.com [91.218.175.122])
	by imf05.hostedemail.com (Postfix) with ESMTP id 67CE5100008
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 08:41:12 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CzAvgxDR;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794818472;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KL7fn0SdUfh0PwymNywyh+Qt4C7W+qSR1vaw9n0yfcI=;
	b=qFLWMLSRLfwdtMm8LqzCgQJldS8EFp4hDOmN0qppfJl5WpJ87tkbwE2tqOPvuLUqshzV3Z
	wStgZhKlOSyxAPfSZhsglvldLKc5HcsF2sLV9EdTz6SMhQ0TE7dP23fB1wKuAgasFAjOJA
	IFaBsbKIrqUzbLyaVLG0TU3FheqdVp8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794818472;
	b=Cz8AUdjEI812h9CYzf5he2ix1xllaWNFevaGcg1uRACPj66k1pWrvG7O4MxQANtKnXtuUg
	YqHqr+rDzP5v2pKGgDem4LoaSsgWlWuaGQ7bE6hEURKmvCBURl8m8LIs0cj1K7I00AMGUp
	C4+Xfcgy0JJUrKiVb+PnCFJpZHPob1M=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=CzAvgxDR;
	spf=pass (imf05.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.122 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=KL7fn0SdUfh0PwymNywyh+Qt4C7W+qSR1vaw9n0yfcI=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794818470; v=1; x=1795423270;
 b=CzAvgxDRLdpr5bqzJ957Qy9BPZfLtXeVM+exj5wU8LWrLIFPl7DJ4aLl41ieKbhA68oET4UP
 9CTuvGW2WJszG/rIZb+iVxAsbrUYfMHjJZKXjbWkrqoIXmnhpARca2mSgk3UskbIq6c7PlxwFU3
 1umvd/QJr5dn8IKpTJ4p61aU=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id c9d6598dc497ba3c;
	Mon, 16 Nov 2026 08:41:10 +0000
X-Mizu-Trace-ID: c9d6598dc497ba3c
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	rppt@kernel.org,
	lizhe.67@bytedance.com,
	apopple@nvidia.com,
	balbirs@nvidia.com,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	muchun.song@linux.dev,
	jthoughton@google.com,
	lance.yang@linux.dev,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 03/14] mm/mm_init: verify zones for template-initialized pages
Date: Mon, 16 Nov 2026 16:41:02 +0800
Message-ID: <20261116084102.57957-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261113033442.62970-4-songmuchun@bytedance.com>
References: <20261113033442.62970-4-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 67CE5100008
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: zw558sqyspxn5b8meyqfno4459md5dkc
X-Rspam-User: 
X-HE-Tag: 1794818472-663653
X-HE-Meta: U2FsdGVkX19J3B/pIeiF4H78FfmgLvRTVhrTVUnIN3sbIxlMO6+ysCxYNoxKKdtDCWK6pdnmuabcLfQF8/xu7EoSA4v95+Cf91tQ98XOykJ1oj8aaXAmtQOH7MDcbO9/LXP0aVKBScdpg/+8MPdrXFgOeNQKJb2t7MdjZMIOlHh760w7F6yT72vXpXVp8L8NNL9zAScO0PHis0z8guJMdX5S5MnIEzXisdI70D2SP17f3XpAP+Iw/lmmTBGgnqwBmzuSf9kXP11i8G38hjnQcRbYUtopIt6UV+/c/z23j1sDduojO+NYKlcR+1pJKp/iBMi/74ZXRNJpWzTBbaPdEdgtLeQvg5BgGhjss12+n5DE1b+6Q2CAu7aKYdhIXTuV0kMJu4WzXOC/HbRhVsXAb5bbx23EdgCk2+xHm4KqarKmVKEjniZZ4mzbA20cTQRdjXGU/srfLYkTF+Up4JACfrnaqIlubFYi1OwXiuS3YyhZEsoegcJnE7pwkR2oeJjLqUgL/jNI3K7c6pIMHT/GVCWkCCy2JM0ZoLd0WmwDvKLmK87y06U01t7+4Dx+Tbzpg1x1qOUOMFaZ6XNIdUvQIalIWlUy7O4P3zeFRnfS5UvMZUEgxzHM/uhFlbs/CoyR1P376xXxF/elokmnjAlA1PB721hOvOEdWKVt761PIvYkBn6nj8kgdv6zKsm7eW/TcDgBS9uc+Dut3ybpMGWl/swE12VUEuwfFNBqn/cP4/p5G+WkWOAtFxBeVqyC2pSpl50a6cI3c3LS+guogcpr3molGDcomrqBWfOSuVifAMe4Neam1yKMBaLz78bV0wOj5TNlKBdl3kHp5TVf0ex/rEUDc9hvHTGIv6EgiFo44etYuJdkWsqD9OkdfkA8ghY8huyjBfoDmVm8n2L2ZTLKSANlYJrUmWy5jbmGPT6GKXOk3kNwos+z2m5PRCXzSzQ6pVmO8jBk7oXyulUjQtM
 8s4LcKhy
 eP6c+BPZV9C0tojaoGbC7QS2Ga2At/sTDS/yYTtpThH/4rql37Hwh9ZnhPCSXaT3OOfzURPWCESwwdZfZXcU3yvdBpa9pRHUmSgQzAxVdkSqehunxA79AF9KF2oOoDNKN9gQ8EsMeo6upKItw1IyGjpElqrKV8sQNhBjVG7GsXrWMX2UNqoiRnAEsHbB6cCTDxWhdr8Co2jInzMN8dA2wS4fyzh5KNxrIjUQUOdzrjHFp2q722RJ6MfUE1uyxPdkNKaM9PeHj/v0adMr5KkKRyh75Kke5z9rIBDGaStv2R3E/F9ENSlayz7ojYTVlMgS0y5kZ0vQPs7bnmCzOytJNOfquLQMuH3qnyU+RKhV1IBnkhmE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Fri, Nov 13, 2026 at 11:34:31AM +0800, Muchun Song wrote:
>Template-based ZONE_DEVICE initialization bypasses
>__init_single_page(), which means copied struct pages do not run the
>vmemmap zone consistency check.
>
>Verify each destination after copying the template so the fast path gets
>the same validation as regular page initialization.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

