Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5F6E9D232C5
	for <linux-mm@archiver.kernel.org>; Fri,  9 Jan 2026 04:13:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 795646B0089; Thu,  8 Jan 2026 23:13:56 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6EEE06B008A; Thu,  8 Jan 2026 23:13:56 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FAA46B008C; Thu,  8 Jan 2026 23:13:56 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 4E8A36B0089
	for <linux-mm@kvack.org>; Thu,  8 Jan 2026 23:13:56 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id E1C3216038B
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:13:55 +0000 (UTC)
X-FDA: 84311107230.26.FCE4A1B
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6729E1C0003
	for <linux-mm@kvack.org>; Fri,  9 Jan 2026 04:13:54 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u9lhiR27;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767932034;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=fv+Ux6Cidqzjz6wI6qwt9IaqzQJmd9GBZlm+T6haeZc=;
	b=uWluHxm6TmKbh6eV9ilf0sfuP4FMoz3YWBBxzzto6TQ4v6OAAgC26UdHPDRXvAl+KO5OtF
	/CCycxkeK8uHhXhwl3gcJJFmd33xF5/L2fFu9ieyHxNesEWvKkmuG4vmbIDFpuDF7oDEgF
	38tbZNrEILcuYh7eL+/DXVSgHgrYTrI=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=u9lhiR27;
	spf=none (imf20.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767932034; a=rsa-sha256;
	cv=none;
	b=Gb5uhriIFnwaosmX0trV38ECMLzT9sfH5PfUQsXhNyEaYp3dt2wk4s3bmbjU6q9z8y+CpB
	AF2CxYlzm3Af70KdVbWFlj9/LugRK3TV9zf1JZgdrECZ2MJEgWJrSrL56dlDpU3EhH14w+
	5t+y2PaJla5nvp5o6CT6erzJUujwgBQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:MIME-Version:
	Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
	Content-Description:In-Reply-To:References;
	bh=fv+Ux6Cidqzjz6wI6qwt9IaqzQJmd9GBZlm+T6haeZc=; b=u9lhiR27rCuqVYIr8KU7n7P8jv
	9lKfavlPdXTLj9UGHbBkARCyaLbSBEwI6bvIGSdUvkqDbfdxGXM42IYcU/p8EKeqTMCNcrB1MSbM1
	wHhPos7ztmzYZd+WLr18mRwFlzGas8Df2/Zbgcb9lNiregjFevMdvC51nouxalar64ngRM8+0k5zd
	MZocVrBCQuxU6GD41yYNql5KKFIXq/Nw/VC7ld5iZPyOsI2fqnELMNCS5E3H7+wtdm0dWW6lKvY9Q
	mTMeo/tnsCDB2Muu2gu8oEc1IOAPaNpUabSHdDyXeSXrwPedchqRaj+iVQS2KuvAr/qYXe2Q8ag85
	PTpQl5qg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1ve3sh-0000000GCy6-1sb6;
	Fri, 09 Jan 2026 04:13:47 +0000
From: "Matthew Wilcox (Oracle)" <willy@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Rik van Riel <riel@surriel.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Harry Yoo <harry.yoo@oracle.com>,
	Jann Horn <jannh@google.com>,
	linux-mm@kvack.org
Subject: [PATCH 0/2] migrate: Fix up hugetlb file folio handling
Date: Fri,  9 Jan 2026 04:13:41 +0000
Message-ID: <20260109041345.3863089-1-willy@infradead.org>
X-Mailer: git-send-email 2.51.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 3rqis6tdg8f3she7yi6cny6dtou6rksa
X-Rspamd-Queue-Id: 6729E1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1767932034-745538
X-HE-Meta: U2FsdGVkX19ijRLP4+HYJPZRsjDCjTmUHyLbmwKC7M2nVsM1MhvEcVfxl0YKGnx0OoCyZ6fFpCql+oXe62Lj1SDK4lb1EUxx6XAlMN1JQVJFrC90IGvXc5Xsv5zoRSvX4uHibY8zyx0PM1LphtBtFEyPu7OUgaMMORln2genfp4Cx8oKjTF4LCHxr8CzUdjNLzLfg9Aqi1sZRsfxtMobQr4DDsO3oy4dp2AOkU2pFin2QoajJ9yxpDU1365BgaHmgr8oLpQH+QINQ/8nMc0DRgDtS1XhwHAd6OHhSesdoQiIcJOSG6Ud0dMifZ/KxKOtl+J0gDA+AozV1YbZTwUltoDg00xsd4HtfM1bSYb594xbDWdxSEdnb9/Go41tqXhtGTreLkUatDQlyZHpVsOKaEyJzLFZRA5ASUIL0SeHy2NY6WsfrJFUH5wx6K4WH9Uw4IiSt2oocvzPJSRChmYgM6AKvc747zEK7nIVIBLt8BMLTC9brGb2OC2I3IIVDiWvD2XhUtt2L/XwkYc8FyL380Zp+3b+PqqVgKVhPZXr59uWNMGZI9cQ+dvasBFKkvbddKWhTJJ0w5PrbvYu1++GYG6goCcgNQpQkfaH+eqTTOEhQbScbiyJNBkotJ8xY1y6HXQ8R6qw91lMLQeDPnHITnboaGYxYLBPGpP9u46qyq0QyL9S9fEnPRWzoVgiXEk7jiIVkvRzcaMBbro1lHd/EqieTVmLW7lpPi0f/bEKskoPxcejx65KUKZPJSzZPuyD13EsD+StzXdrfLvJVukNVX19beIyyYjZdX06RydOnruwxRcwppiT96E6+fJdd4UQykoeijBQfAndlH3CP50i03JIujJXlyt7Z3xSZqZm++npORmI26dNVJ9I/f+2O5KzgQsYdd8h5hDCZNrMSqdOKR7X4uHB1/6HRqHRnL9I7Efu8sxnsR2yWQEMO1blf9kgdgsUgit5BQd0KsWL81j
 9UVhdWCZ
 avjFUquygXh4x3mvolpHz13dwDEXfgyPa2YM0doKVczV9C63Ytbir/x9mhcb2ofBWj2YsL6PMEhLE3NTV13iC2MRjLucFADE72F99X9Jif2nX8A6/a9qHFjDHNaROyYRMjjjdF+epbbWyUJ/JX0LAdoi2pRTNIDTZwXsy+b/zuDboBbM6x8pDCzFpZs1pgF/xGkkSzEwirTf3Gog=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The first patch is a fix for a syzbot-induced bug, but it can really
happen and is worth being backported.

The second patch I'm less sure about.  I don't like the current RMP
flags, but I'm not sure that reusing TTU flags for this is the right
approach.  So I'm fine with this patch being dropped and just applying
the first one.

Matthew Wilcox (Oracle) (2):
  migrate: Correct lock ordering for hugetlb file folios
  migrate: Replace RMP_ flags with TTU_ flags

 include/linux/rmap.h |  9 +++------
 mm/huge_memory.c     |  8 ++++----
 mm/migrate.c         | 20 ++++++++++----------
 3 files changed, 17 insertions(+), 20 deletions(-)

-- 
2.47.3


