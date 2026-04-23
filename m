Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E0BAAFC0342
	for <linux-mm@archiver.kernel.org>; Thu, 23 Apr 2026 14:56:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 13E616B0005; Thu, 23 Apr 2026 10:56:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0C84C6B008A; Thu, 23 Apr 2026 10:56:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF9046B008C; Thu, 23 Apr 2026 10:56:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id DA9016B0005
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 10:56:06 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 85AFE88F9C
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:56:06 +0000 (UTC)
X-FDA: 84690120732.12.C3A8CF9
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 22C9FC000F
	for <linux-mm@kvack.org>; Thu, 23 Apr 2026 14:56:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dlt8wuZH;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776956165;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=md3vwdpmlssvZFcgZRzQuot8Bl5GX3XA4NSgv9I5fQM=;
	b=iauw7LqJ1OR3key55WVvfZEQXyglc0yCQiy5icqj12DHLsfymu7dE6RXiNN0Hm+/phHFqo
	cF7ldaBLK/+wFFyGM3CzeA0g2DI6k+xMPcl9/aSqKJ7/eXqT6afI7VI2o6TpOa9qFhY9tM
	BoRoSHhmL8NHHJV/DNS+7MPLnk4KEU4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776956165; a=rsa-sha256;
	cv=none;
	b=G4hZrM8jhgY82DAfeAuC3UwmW2Maa9QP/afMaHEwoJqNiZXkywfLb1ejzkcOSK4aQu4dA6
	0ADhJXoqjEhKh5QXshtFlFRmvVXPrVezuKrWRSNTw2prtyVCVB2wdVZ7J1u6YYxnI8kDPB
	4puNgORhtDLBHW1h1qNG2dlIkxI0IuA=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=dlt8wuZH;
	spf=none (imf22.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=md3vwdpmlssvZFcgZRzQuot8Bl5GX3XA4NSgv9I5fQM=; b=dlt8wuZH9TZw+MoGGFG/U/kEZy
	ykrl89jcpQsUxGtWM3vJvmGimgdWpf9K37J81FP11c41XcmUpSQZvkh+aql6VzJ/qxRImxWWDao3D
	+DOAwuiMjpNcd08wLm/Pwkl3D51BdvClgjynFDizo299cMJ6BKTexPwF0oi2TSj5RqPovD3M3Oeey
	/q/G6tr7PtRwwtu3vG6qSK0P7Yz59Z5I5aexPWHOt6zSJ7A6Vxs+fsYY/i/zrLh9WJ60QE46PrqBa
	/sMJ6ryxq0DAuVwV+lF9qivR9QF1tsuHN/o+iMo4m6QegJHxByH58U++oCg+wljhTJGi9aq6MrHwq
	2aXW/0Zg==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wFvT1-0000000Dcwn-175y;
	Thu, 23 Apr 2026 14:55:47 +0000
Date: Thu, 23 Apr 2026 15:55:47 +0100
From: Matthew Wilcox <willy@infradead.org>
To: jane.chu@oracle.com
Cc: akpm@linux-foundation.org, david@kernel.org, muchun.song@linux.dev,
	osalvador@suse.de, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, vbabka@kernel.org, rppt@kernel.org,
	surenb@google.com, mhocko@suse.com, corbet@lwn.net,
	skhan@linuxfoundation.org, hughd@google.com,
	baolin.wang@linux.alibaba.com, peterx@redhat.com,
	linux-mm@kvack.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/6] hugetlb: open-code hugetlb folio lookup index
 conversion
Message-ID: <aeoy86Klh-07s7lu@casper.infradead.org>
References: <20260409234158.837786-1-jane.chu@oracle.com>
 <20260409234158.837786-2-jane.chu@oracle.com>
 <aeZwAz6PcdlqSnJ2@casper.infradead.org>
 <a36c592b-0456-4551-9a53-f513233cc129@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a36c592b-0456-4551-9a53-f513233cc129@oracle.com>
X-Stat-Signature: n9yxfj5au8qrd87jy58bz1yhgnufne7k
X-Rspam-User: 
X-Rspamd-Queue-Id: 22C9FC000F
X-Rspamd-Server: rspam05
X-HE-Tag: 1776956163-715655
X-HE-Meta: U2FsdGVkX18PgSqKI79uZC6/NvLp+trOhdCRc67ji9vzq/vyH5r2hese5/34qxJLKiTRWjKBiByeU/Qm8Ljvir5JhDMiLAsQh+R8sBzfe6WW8s00uA1cizoC+VSpmLgLhvYUO6w0ILt5PaPO/AKI0nlFXVQFSuGBQdyI8ItRQOPJWpXkwqf+FhGrfHhSPmnR79RCheeLnz0KMh7NUqqE3zF/FDeuSy4kUT90BJKSKHk/i5Ce77MjPUYCw2yAz05FsfySGpipGS0545HcpBte91h+QXtp70ObMhysdaPmFgp3+aP6T1qraZieo07x1LYBws6qIxaj0WCjGMjp6T7r6N8P/9r+Gahz2Bq4hmsmz7fIRRAqkkxn7TuJxWznuyW8nl/bZOeOMeNC6jeXRZoDv3aOR8gTlXRbtj5SFep3GzcQNNQtV3nsZpe99KwCBGgCj816MUR929zdRzv8yyGl7DH4xRdiRx5EGJUjwLrLvlUhZHoKpyUkliWVNoPhOeF4zFv5AU+DRD2QUE82/DMqVtW++W1wo/XHA2uES7LUgvRhrExVQrjNstNOvHPGLqMJKbWM+5Y23OEPsEdq9znnjOGSJ+bnJqEKGXxU7LgKc9JFolSSW9pu7UwAflr658sBYCA9pm13OJBCQvK7r5AumH2KhzFZ44ScCGmzESsAfsfie35UaJy/frpla4ctKDR53AWg1TU1Z3UGCcUQbCwSBQlyejPPBdIJ6t+nmuT9Skrx9llFqE60qUaPFZk75qgqp4WhDhOq6lXuIVrkCEZ0i6v6MOqXdH3LLg3+haHPWWzMEQQwqYZZ6tvwE/5hDp21g1abMKaZ48OhmT4kRLHaLoOFvfHZoOkH+aPlV4y9GY1QP8h5cqu5Wsvtyn09oKuz+mr/h1bCShreMYiu9SnF8Rbm4UlX3lpY0/SQVon2W4nns8sE1z4CJgFfdU3BMv8jSnNevpI5Ep27vVtuHfb
 QDxEYb79
 9Gde9IteeG5sKb4eB8Ebd3L/HHn3z3ixvaRQsqwEp9xm9+ch92shlZ/86QxYuxbeiEPp+NdmDaX1aaKjWxWusWPtGIlikX6dzxEX2Q5y1Kf0GArZaIkKLhu9DjxOGTczUFuVAp+69DFwrekt7OM8q0VSgm7opaG1f3K2Umkt3vSc6t0yzR9SZqNCbjeoRsYA/stsFaZ30MzPg3Cr498cNxlvesUKpsPVw/sfn0eZe1sM12S7ttLuCTp/1oTbnRB67qKWiqiduSKsk7QT4kuVvbBr/kQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Apr 22, 2026 at 09:44:40AM -0700, jane.chu@oracle.com wrote:
> Thanks Matthew, these are great suggestions and I am looking into them.
> Main concern is potential performance impact, will find out.

I doubt we'll see any performance impact to be honest.  We're doing a
small amount of extra work, but these are not commonly used code paths
and I can't imagine we'll notice it on any benchmark.  This is about
cleanup; a pgoff_t is supposed to be a file position divided by PAGE_SIZE.
Hugetlb mostly doesn't do that, it indexes in hpage_size() which it
doesn't need to do any more.  It's confusing for people coming to hugetlb
from other parts of the kernel, so it really needs to be cleaned up.

