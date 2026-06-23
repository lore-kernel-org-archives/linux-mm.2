Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8A5D8CDB470
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 08:44:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7620A6B0098; Tue, 23 Jun 2026 04:44:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 713276B0099; Tue, 23 Jun 2026 04:44:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 629516B009B; Tue, 23 Jun 2026 04:44:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 38BF56B0098
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 04:44:51 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id AA8B71C5804
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:44:50 +0000 (UTC)
X-FDA: 84910541940.28.AEE8801
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf01.hostedemail.com (Postfix) with ESMTP id EC25E40009
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 08:44:48 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ss6+ispI;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782204289;
	b=bhoTdM9zZGtj5ZlMDM0zCiL3TTOjJACa5hs/uU+VRxYcqcMgwjm+AqP/5//8VWDOrVvtoH
	ECYK+ATP0YsQIBBJ0bZ+FtunUMvEfaOUYpHRybuCMRM887F1+LnI2B6zY21XAXE2pttaIh
	jv27HfYNImvSf28C8PK3OgdpTJFzcG8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782204289;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=j4RRLMzp7jvw4FEfdbqtvjVAOns1TW89DIh3rnn3vtw=;
	b=Di6aIXSVhRMX/gqKDTia+bi62Epnc8ra+WRjIiotbz7/vjQkyQRKCRx5PRiHBs0YVVmec0
	NsMb3+qIdwFieSFmW+59kwtdeRsFPfusxp5FXuGmx3UBwCAWFbhyDCCMuYKJfVHYocb/Uq
	EvlZbAaUu8uzHKRsEN/ERlX1Cy7dez8=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ss6+ispI;
	spf=pass (imf01.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782204286;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=j4RRLMzp7jvw4FEfdbqtvjVAOns1TW89DIh3rnn3vtw=;
	b=ss6+ispI3wUwQkyJs4NRV/XgD18FDFpn1thnXNNnhvdzZM2KeakKmeZKrL9Fzywgy5SNZF
	RqNbD++6cT9jQSweeTdmeGr2PMFyMT6gp9z0drr5ZaOe37rGT+HNZMb5gURSvz/uxywSTy
	GFCx3IllenquVlf8i/ca6iuCGgrNMjc=
From: Hui Zhu <hui.zhu@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Cc: Hui Zhu <zhuhui@kylinos.cn>
Subject: [PATCH v2] mm: avoid KCSAN false positive in memdesc_nid()
Date: Tue, 23 Jun 2026 16:44:32 +0800
Message-ID: <20260623084432.701120-1-hui.zhu@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: ti4n8pi6ge8n5mxcxcs9975z47kyis43
X-Rspamd-Queue-Id: EC25E40009
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782204288-500637
X-HE-Meta: U2FsdGVkX18VhRqiVcBWp+FWntrTUMJoiIzedErRHylvz+s/ujJZRO/fiKNeLHODyprCZfufMI8fHwCKhw4RgG9dcsAIT8ZC5HraC8gF2L5R4LjDjPT9cD6rUDlM4maIF/yqeFNrpr6LNYUlsKRhoLPsKznMqPp4Lh5mdm1f0FHs/bqGyfjjzSoEaFjiDqB7ImjlkqydZTtkTIk/XObYH3ktATAuuiapUO7Ona+sqBSBAJPABvpjAY+DE6qaEn2L8+7epj1ymZnYnA6v7K6nLn/qsBMNeAC7NK7DRGHFPaja0S+b0WPZ+e+KRXDZTTdJMO94KTWdSIm5DtKCmEYge3pDHbaeo5FAwBbFva843mTx+rpwj8jU2PuEdEnIjU+SX+6fAnEK+Vv9OvUf6MILafkkTvYqZ0hUp1hxq2ajFjIsTiqLWTEU5oI0Rgvmbw1CDjSbhVGrGCU//rTRqJfzAJ7a6jKJgPaDt8zt+58o5V1p9HZOWyyKMbgLtSiJUvpwqaMZYGQQPakJBF9dlFOOKtP4AfcTAFKsyXdrEnZkkkvj+Cf8E8Z1fqYHE8cOaQxmRZcaJQfauiPBW2BsUVHSJrv2WoaMYqjTD4/K2xhHPKHLRM6MKwKlba/I6gLDy90EMMpbtVgeFJCA2YLCDZGICGWM/Qp/Q8qHXuncoOgMCYM7hG6UAUHS/dPNgL3kwRRXJbJEG2bhC9G1HacGiQMTUwcwDXFl6pBv5W90MhqVEQLcBe9+4q+sncCZCQPl//CDz0/mGRAdzvzZcFaWlpXOpWYinO3dK7vM+HXmpqM1LnyPnadfsoYc/GYlJPitb2QIFbS1Ii5r9bBEDwDRCUPfI4gZXwRHtPG+EAhBpUKtj4hxE5QOi6KGkapsfCuGgLfz2EHQpE58Q+/UXvMuExqxXYzmYqPc3OyPT0bjiVYuQli44ZnR0ZBNb8nfn7nJgIP+Ha4fMgDY5C26XERaUwW
 9Ih3w2IH
 YeGG+nAC0y/WSET7Uhh0+4dDNFfoLKK4ghJGv/Q1sCdIQBk6D11gZIGWJBrTcAtRNgOdTf/fOmYrDbaI51j+n34gaqt8xneCgpSx7rO/xqWSEeNlAszm/2/mHgqGHTXRJADqqnsWJIFLBLfKk4eW0FrHqAi6RBlZz4iMrkwpJiQAxE9P3TurSvj4ju2TiFKotXtAw6Q3seksSGqn7L0f5rabBDB3j5Lk+N22Zb8sDX81qXZJ4cPMm50Q9b7uTEfAHbtaUq51R/4o86EOUFCh+oi8EZ9B5PSM1jfegWNpfzLFQAew=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Hui Zhu <zhuhui@kylinos.cn>

KCSAN reports a data race between page_to_nid()/folio_nid() reading
page->flags and folio_trylock()/folio_lock() concurrently doing
test_and_set_bit_lock(PG_locked, ...) on the same word, e.g.:

  BUG: KCSAN: data-race in __lruvec_stat_mod_folio / shmem_get_folio_gfp

The node id occupies a fixed bit-range of page->flags that is set
once at page init and never modified afterwards, so it can never
overlap with the low PG_locked/PG_waiters bits touched by the folio
lock path.

Use ASSERT_EXCLUSIVE_BITS() in memdesc_nid() to scope the exemption
to just the node-id bits, consistent with how memdesc_zonenum()
already handles the same class of race for the zone-id bits.

Signed-off-by: Hui Zhu <zhuhui@kylinos.cn>
---
Changelog:
v2:
According to the comments of David, remove useless comments and use
ASSERT_EXCLUSIVE_BITS() in memdesc_nid() instead of data_race() in
page_to_nid().

 include/linux/mm.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/mm.h b/include/linux/mm.h
index 485df9c2dbdd..7518d6364a00 100644
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2290,6 +2290,7 @@ int memdesc_nid(memdesc_flags_t mdf);
 #else
 static inline int memdesc_nid(memdesc_flags_t mdf)
 {
+	ASSERT_EXCLUSIVE_BITS(mdf.f, NODES_MASK << NODES_PGSHIFT);
 	return (mdf.f >> NODES_PGSHIFT) & NODES_MASK;
 }
 #endif
-- 
2.43.0


