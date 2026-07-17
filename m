Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0A942C44512
	for <linux-mm@archiver.kernel.org>; Fri, 17 Jul 2026 02:21:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A621A6B00A2; Thu, 16 Jul 2026 22:21:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A135D6B00A3; Thu, 16 Jul 2026 22:21:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 951E46B00A4; Thu, 16 Jul 2026 22:21:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 676BE6B00A2
	for <linux-mm@kvack.org>; Thu, 16 Jul 2026 22:21:53 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DC7521603A5
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:21:52 +0000 (UTC)
X-FDA: 84996668064.30.91E59F7
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf27.hostedemail.com (Postfix) with ESMTP id 448E040002
	for <linux-mm@kvack.org>; Fri, 17 Jul 2026 02:21:50 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jHfE2nrM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784254911;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CnFD2a75XZkuCjfZvvbN7bbGMHnNlnV2/TiIBDiQeIk=;
	b=zTlI0od8WZPvQZcTdsFBBIOHHJxD0aYrM2UMeBhIhubl+hk1M40ZQOgJiW7SbX3e0mCFK+
	6xj1F5n5gz2ICAF+y+hi3V3wFZrfasp5USf/hFEYdaVB4GiCbUH5WEVT5fhp/91//CX3WL
	C2Ud+wR+19FLGoi8wo+nPQPMD2Fm/+Q=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=jHfE2nrM;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf27.hostedemail.com: domain of rdunlap@infradead.org designates 198.137.202.133 as permitted sender) smtp.mailfrom=rdunlap@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784254911;
	b=6f6LucNl/1QzybVVWCGNSmdNTzeyeFx9ObRIvLUBdY2hsajrCUVz3snxk6VZpsymx2+Vv6
	q/y4TG8z5q4/e3nuQ1s3BeKN2im7gMeUr3DT/haQu6fCkqD2GFvkH/7DXvVvftj7H4QYZp
	xcTgAS/312jb1YM17NwYm4vBTwKB9Jg=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	MIME-Version:Message-ID:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
	Content-ID:Content-Description:In-Reply-To:References;
	bh=CnFD2a75XZkuCjfZvvbN7bbGMHnNlnV2/TiIBDiQeIk=; b=jHfE2nrMNchtMyFZvQt0b9m5it
	XWfi9dP4XApYFj9vf3VveYzYbinakv4guA1cuSUMzwxjv6hXdAF5spXiym9XoVHb166aLO6DnaP29
	BbjgfkRkVw/HobjyxzBoR/Deal6UzrkfKJFvH243s/HE9ZGRTSDmqOWLQ6HUfG+joQwpYMzU4kPKb
	R6gzqaUjTlBvFbEKldbuGVYV30o+smZYtySgP26GY262VdGs9XiYHztcnqYfzrJzP0bkg6iSRZnsm
	mE42JyAYETU6rqpCX822X3Ua/ytVAQ26qrnxlBcnjzWar3FrP/WjXXgak6GuD1MqCLi4w3jIjReaT
	BaBH3u7w==;
Received: from [50.53.43.113] (helo=bombadil.infradead.org)
	by bombadil.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wkYCy-00000000xhm-2d0L;
	Fri, 17 Jul 2026 02:21:48 +0000
From: Randy Dunlap <rdunlap@infradead.org>
To: linux-mm@kvack.org
Cc: Randy Dunlap <rdunlap@infradead.org>,
	Shivank Garg <shivankg@amd.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH] mm/migrate: add missing kernel-doc for @migrate_info
Date: Thu, 16 Jul 2026 19:21:46 -0700
Message-ID: <20260717022146.1290242-1-rdunlap@infradead.org>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 448E040002
X-Stat-Signature: 8caqqa3q9ghypta17kygos8hxmfeaj5t
X-Rspam-User: 
X-HE-Tag: 1784254910-338198
X-HE-Meta: U2FsdGVkX19pJHY9GnOwS2Wknli/kZ9cq/COR+Gk8OZjGdHGKoOQsGGTG3mUQ7HJjHh2hvZOnJKpstyI9QiJ6Gre4uMvEU9aea/ka9NtN4m5RJPzrF+t5D9+G8ivrYTHOZK5hY6qy6UUG2IlayAEjUY4B/XqNb8NKVL5OaVmcp45dcl2QGJs1CLuGeZuzzt5cgFmF8JovoTojDvViCx2rUuQufwADqtTiczkzhBjQVaHlJvYoFVW6Dbxv90hTX5AOSXRUFZOk7deqe5LOgKG2e55j5SSQ2JIDbq+getHtkD7tIloO/rlkONkp9DTb1HroWfbuB0Hg3RsEGhrfO/B9QbcepJKf5eqiY6+pVQsvSYG8+K9vgqA6zEP3CZH+huhbBq//5TeOmk5SCA8xsXZeOJUsv9VUTmH3ONlAjYweFPfMvj7JvoldVoBe5ofhFt5D9zuKbv22WbT+2JXsNKQ1ei/HyoxruO5j+LbVgv2afhzWpuG1UoXDdXZt4n7jBJBih7xOHdtyYJIKlkkduTZkLfiF8q260kSgRPoU6JQFwO4MrVDLpEbncd3joNT0eeOyse1HgL7D1VkvChMnAdIRawpmhwe1HdeZbHkzvh66ytL1PQM1aLYgdUStObwW5i3VZhialUXt/PmuUsHE4XMVvHq+G7/GDnjIb5E+lqH1oJTo5a9wxZeO2XCLBasxCfLWlUbLJfY4G1QJrPFxE+gTIbpiIMbtT7kNm12hmlrnrwkwePCHNXhC19Z4HZJ0tfeVJPT+q9wsMYgnQqkrNZLH7IYCvBcxKnOMvZmC9mTeI9S30bNDnYmdCrQJuQ/U9xvrnk0pVtxPC+/JBxrnh/yJ5Pu0BPPvyafS2S18G8Pcm6laacSIr+2LQOsVQoJM/oMxe4aoGg7funzcZkGepS0zzHlXob3yeRj1sNTL5wMC6j7rgNA3x9gfRmBJhh/mzPz1jZ8gpC6Z17RwVOisqd
 wClK8nwu
 PhVojlt0Es/kmYIycVDOZmoh7sE5APHN9SgyfzdFFISnGqXS4klbhfYO07BKJI2QKY+oRom/qHCOr4v26UNWfUUAg1g0PZlbvCQC3xBn+bSAWQM0aZhHPKp/CTHi4R/2c9T81L6kPKZg9nAh0nIGjb4mPcZl900s9s3EwUbWSz8U4aoYfSRWhQdcmoXgsAHwyts1mAk1+LJrUgHe7u7u1j1mEWhyJ8aP6tHojtvOhMIfQj1m02aeEyoGR30+e66k7It2UOgNm/TjbnSXxhrZ+6H1PVjjYVpWPJN+pulh+OWpaYpAuP5S4XmGpD7l7C3FSFaU0NSZl2d7te/cBX4UEsGZKWbQyP7tKf4lpdH1iCfBfY26NjSEfJF/kVA4wFPx2SVmOTUsgYI27CBBsde4wC23F7IuwbflmIWKR+HumqtZOYXk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a kernel-doc comment for @migrate_info so that kernel-doc won't
produce a warning about it:

WARNING: include/linux/mm_types.h:507 struct member 'migrate_info' not described in 'folio'

Fixes: f3768940afdc ("mm/migrate: use migrate_info field instead of private")
Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
---
Cc: Shivank Garg <shivankg@amd.com>
Cc: Andrew Morton <akpm@linux-foundation.org>

 include/linux/mm_types.h |    2 ++
 1 file changed, 2 insertions(+)

--- linux-next-20260715.orig/include/linux/mm_types.h
+++ linux-next-20260715/include/linux/mm_types.h
@@ -368,6 +368,8 @@ typedef unsigned short mm_id_t;
  *    dax_associate_entry.
  * @private: Filesystem per-folio data (see folio_attach_private()).
  * @swap: Used for swp_entry_t if folio_test_swapcache().
+ * @migrate_info: Stores migration state (anon_vma pointer and
+ *    FOLIO_WAS_* markers).
  * @_mapcount: Do not access this member directly.  Use folio_mapcount() to
  *    find out how many times this folio is mapped by userspace.
  * @_refcount: Do not access this member directly.  Use folio_ref_count()

