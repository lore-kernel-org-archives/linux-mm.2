Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F2E9C53209
	for <linux-mm@archiver.kernel.org>; Mon, 27 Jul 2026 18:13:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 364CC6B00A0; Mon, 27 Jul 2026 14:13:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EDBC6B00A1; Mon, 27 Jul 2026 14:13:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1B6B56B00A2; Mon, 27 Jul 2026 14:13:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E45BF6B00A0
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 14:13:28 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 6EB24120168
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:28 +0000 (UTC)
X-FDA: 85035354096.11.5CD8689
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf15.hostedemail.com (Postfix) with ESMTP id E9FAAA0009
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 18:13:26 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l+6i6MH2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785176006;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WvwUAx6FxDsrZq8ixYPmqXc4qqzBUS0RK7TxCy7zUaA=;
	b=I8q7YrO5+Z4ntGrhIspQXo78D2ps//KkEkw46MfxUtUxnPIvwUDUO5ajQBCHBtKro5mvuk
	hiJnsR+i80uk4XRVUmvn/tGgPg9QSh/MtC67o2TDMQC3jrpGbob+sU21fTBt/1/7H1S2+w
	V0iftVvA2JEOEgcjkd+wvwqys9L65B8=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=l+6i6MH2;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf15.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785176006;
	b=f5sZGM6Jh+kDAB2EQDtzGRYJD8b7jK8WGgmK0bnRo9XE+cZVyr/lE5Iml/S+hQcYAqbsQI
	SXLyXJT7ExY1mHxCnjPEvmOz0tvIHgcc6JtfIsQpl3JYaiZ4yXlFrCbRBfiVR5eJgtHogL
	eXaRxx7s1sNZj7sFpk0qaaAvmFT2YZA=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	References:In-Reply-To:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:
	Content-Type:Content-ID:Content-Description;
	bh=WvwUAx6FxDsrZq8ixYPmqXc4qqzBUS0RK7TxCy7zUaA=; b=l+6i6MH2DbA+vKjsUFQ2UyCKGB
	BAzcZTd554OkBnhRbbW7XA505wKQjkkkKiaSXU26Po13RUMIphsrd0acJKL77YuG0jg81fg7wt1Kz
	EEX37GJKgeu+ah4z2WOEb5o835Xy3lBOedKn7hhNQL+vaA2LeG6Vg4P9ihliC9vBAH3duiv0WG6dt
	1LBrpNH1Bc55T6w6KKREa9iLA68xFv1cOLdikxMP2qeb1T1ZR1B0IxovvJh7ssOCUOxYAsznqyOz3
	uRhLOC5KZx578/t1KLWGPzcJtO2GEIg80K7DjNc53S6nwH4m4E2PwqAW6Szr2Huizj+ZioqyD6BU7
	0jXGcdAQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1woPpA-0000000BD7U-0hk6;
	Mon, 27 Jul 2026 18:13:12 +0000
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
	Jiaqi Yan <jiaqiyan@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Ackerley Tng <ackerleytng@google.com>
Subject: [PATCH v6 04/12] guest_memfd: Use folio_has_hwpoisoned_page()
Date: Mon, 27 Jul 2026 19:13:00 +0100
Message-ID: <20260727181310.2671972-5-willy@infradead.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260727181310.2671972-1-willy@infradead.org>
References: <20260727181310.2671972-1-willy@infradead.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E9FAAA0009
X-Rspam-User: 
X-Stat-Signature: 3j4qpwxnbjpmk91n3hdh6bk7ndfxj85o
X-HE-Tag: 1785176006-903189
X-HE-Meta: U2FsdGVkX1/9QztK1pTXy1c5w4aTeUukmSoF5s+pyVq+avb3lSt+FaReJNAIIfB/Hqhaal4cW03wz/Guloj69pGDbAfmx2zPW1/pNhx42aAhL2NKC5HXTuh//MZzFpx9fBrX/2Q3uAp8POEZeqHb3Ba61Zla+3MSYMC5EpiKPa8+b7huRvBdtC5ghsKaKyWGr5s13AmtuC2dIvDoE5JhFDr6BBAFVDX1zD1vUZJWMbHEK+sbACvpzSaRaijrco0rwxOsh2GhLo9NHzm09otXS+1YWn3elzy8pNxnJclSPXTlWbcnMkP4onsz/PhmYvdNL0hoJA+mk46dmIChiLogz4XjDnXTTtbKoq3gfskVUNAeNU56wBctEJr2qFgW0H3Td/4QiOJ3QpApqBy5HESzPeftqntZevMV5UrDzEdAvj7bhBpemaBk+74hKJxPZzrDHW9cU28Ogp0yZO2HFg9SYxr2xDm4NZnrytBH1J8FV1Ryk3jkV0Y8mke+57mjqs1xCYt7cJCI8a1QifTmjyjNfEWJwnblrJkiQZ40PAImDhfEOc0e40dUlS7lshBXJc/2z83bQMOy+M/8dI90mb7ciMZS8FSWF0mBbKJ46b9Kj0o/vRclpGSyGfTlohJGwybZ1bcA9njZfVc50QbD8VY9QyI59UME5mrxniEEq4wCJVZY6FTEtBi1lWVR3Oq46+gDvaNmPRH4kONB5Y+s5aril0GG1pywK1Ajw9VipDxIstAJeiMVfogkYgoIor8rs2RhtCt0mtgYGxYDmDVDw6TF9rTJv9JppYVzC+sn6VeZQ1kgs+sKhdqug6p/Yy9/ZOKhHuSIgDmgrETtHjdGtbDi9RzGemtK/mtGAUpUJar7Aoagq/P3VrBigjk8DLKZSlCNQWx2CZHyzivt76gNAozmogU80oAaiEQREhbb8OHLJ8UOtwl9TucgcsC34N5cI6tz3T/XyV/ZnoMJYIpywSH
 RZsct+Di
 tYs9UAChVF25gDER+RSc++frfSycQ4aTdWcZ0a5vf6/L8/IIawYyCAb4b/tuzsCIN9/es85Ar726vQWtiKkbLdLSHId/VUoH7n32pDv4T2EVLHq1edY0n7LvRnRm2WoUtS7jalzRXI9EyXnlSF0mSo2J77C244hM6vbDdI/oqIAg7+xmCg26zkZAJp9ixoNwAZMaCasuoSQXdgzFcaWYp0t9NSkOH4Qt/9bQ7bo0muHisspzCnQYJVKK00o4azTUcd9CmtEpwpovFHsNCrhaibjwdaNLTm57z9ZXmNvOomlbLn7Yp3q6xj4J/GoAsBNW9XZLsJtKqYvFQ12dYWPCLudRmfP9vXVDedOw1PILT4Vv+SXP6WRdqb95rOsU+1v+qayd8FI1368CtCgQ=
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
Acked-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ackerley Tng <ackerleytng@google.com>
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


