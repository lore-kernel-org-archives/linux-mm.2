Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6EDBCC44520
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 11:05:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 694CE6B00B1; Mon, 20 Jul 2026 07:05:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 644F36B00B3; Mon, 20 Jul 2026 07:05:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 55D7E6B00B4; Mon, 20 Jul 2026 07:05:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 311206B00B1
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 07:05:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 9A29D80112
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:05:54 +0000 (UTC)
X-FDA: 85008875028.05.2DE7313
Received: from out-180.mta1.migadu.com (out-180.mta1.migadu.com [95.215.58.180])
	by imf27.hostedemail.com (Postfix) with ESMTP id BE5AE4000B
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 11:05:52 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e6xgDC0b;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784545553;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7Rwb7HcnGB5WNSmzxd6c+y3DcrzD5W7xrtCT8bRFoPg=;
	b=qPdECx5qfMLHog9q96xvuJSMP0+sSlmXclpHlaVdsHAg8+qv38+GnCNzjfeW0kQSTzPsBv
	yi0QLnzi3xRB92/3kx8bydSIXJEbSqNDOAEKpHXH7R7TV6VmnHLyKmAbyxjlnwWXOPS/2j
	Y4wvmHU39SrXsVkZe0ZFW7IzRNALXpw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784545553;
	b=ZrkQ9Uf6Q1zslhOJC7aZdw8m8E/Y7dKRyMNCbOsWnqYldyvO7qhiADmvb+zdY9z7Pl8dWp
	EZPD1LZ/2EUiR82JyQt84urJVaM2EiTvRWsc3Tumx13ntSInoCpJTHk68KXWyXgI/PRDJ8
	yvKz8fewHgvw3O5CbjLShFicR4Uf/ls=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=e6xgDC0b;
	spf=pass (imf27.hostedemail.com: domain of muchun.song@linux.dev designates 95.215.58.180 as permitted sender) smtp.mailfrom=muchun.song@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Content-Type: text/plain;
	charset=us-ascii
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1784545551;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=7Rwb7HcnGB5WNSmzxd6c+y3DcrzD5W7xrtCT8bRFoPg=;
	b=e6xgDC0bwPSfZwUxWdBpoK9NDV1GuB4FQICPCZuU66T0ZQ5mCC3vWHv7lrGcyhZLhQfNuM
	D+TcvKkx0O0dfQ6SFJKnbxDAD/Puud6ORuiUd6Y8eI3Xar68e8yb9X9fsnQCjDUfXWpAli
	EHOReSugzodK7HhScOqtOCP2IDifXCo=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v2 06/17] mm/mm_init: factor out pfn_to_zone()
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260720093127.540540-7-songmuchun@bytedance.com>
Date: Mon, 20 Jul 2026 19:05:36 +0800
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>,
 Mike Rapoport <rppt@kernel.org>,
 Vlastimil Babka <vbabka@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>,
 Michal Hocko <mhocko@suse.com>,
 David Laight <david.laight.linux@gmail.com>,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <E9EBAC23-2052-41ED-A2BA-E5AA3A1E0D6D@linux.dev>
References: <20260720093127.540540-1-songmuchun@bytedance.com>
 <20260720093127.540540-7-songmuchun@bytedance.com>
To: Muchun Song <songmuchun@bytedance.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BE5AE4000B
X-Stat-Signature: hue537jgietj7zx55h7pussqb1aowg99
X-Rspam-User: 
X-HE-Tag: 1784545552-385858
X-HE-Meta: U2FsdGVkX1+c4w2jWRGECMfGWfH4ancBtvQEZuKsboBgnAQSjDMPAYC874Ir6MbvdDqfHjBq4PhRUCw305UNSYsCeiDaMz94U06E8uZ6tzEzYoPdj3GH7D33snwWg/N/IyFwhZ065iU+QIbra0MSwtGIW5bNwTjDQ1C5+0VVTssc+nN+iqQ8srZ0IHeVoNGiC1u4CfaCElZfg9Fh/Q/gZs061EdQR8EdnXlez/ZIREsDhhiYt51usqthHTJBfHyXNL7hb+gJJM+lD4dHkti/RJH7A3TxzBrCU7EVqnxJylrp7YPFrTTr5SHYGdA3kltzYPtpUobOb0D2xOUzn1ueJmph3CNVbqYAyDVSsMPhbQe5tZ6rYz960Cfm/CGuyDvAIYoWdruCxG+GklWIjjShzZ5xJ6HrfkHXMB2J2CH7ADh8VztOUjzb7eYKA3XN2yeUi23KH1YVtCJ6ESjGATLvHLeSfZALEG0mp12YCLgXPwqUWhnXiGcFvu+ODzmswFI+ngS7j38I8MMb2uGJ2mI9iwaTQWJ6sXpUPvbNODS6H8JcUWmQP08hm9NTINsRmJ8UmCV6uwSu+QXq17xo4wfarWxC3LFWCJxSyT80jsLuv5YL8LyuHae4uroWg7Pe3+jqtMAVENSXits+fRvQKzIHXZfiZQ8Vcb3iYs+fCnVCbuwrUA+fEscrq2PTnVLw2HP7t4sK1UVGgyD/9ZsevFVdyon7T01CVvVmRRs5hU5MGHPUeiL4negl6BNtbakvThIViYXL7293TjXsb2xofrZ3MnITZQl1WPdg4TiCuJLG8gjkgm8VDqg7pqBnldc0z22NpwHda8mKAiTeNd2hEJ5DSdOuFu81VR/GT15Q4YwWQPVYb2CnetQhbn42hMq8qptJj8f+jq51TomPtoLy+Qer3LVXY/9aGJiJXv+upDCxFa0y+i0JSQLfvWHEK6GzxK/VhTT2mwhILjf8BtDep02
 b++t1G04
 +AMvBxw9ugjNLoFGyHLRmovQPD/+UNukAN/2Ch+A4XksVt45CkL4ZezV77DQCrUpC4QPQWynQebrUBc8qTWhWB1WwccGJ3/GB4Zdjxn4+GmNYnSyPT4DnNNEZT8e0CcfG2fnXVvZbWgLFJPsIcXgIFqlTl2JEq/yJ9/DvTK2tmBnKAoev0z8Ey6Kq0bVHpRFSJKP2oZU0S0UbqVa6asn6scqsdOTmD/5lmK0Ty/rFKjqxVrcLrPpc+kcHCikeb/StDtIWE6n3eENR8Bwcvae0iWC0UgGzc8Vrvp3/F37Boqy8KRFQt9VJWb+5HmEj0PGzOtzqe1TZV8hGz/Q+wqeWWlLQZW0/2ugSKFMQIkIvVav7hJnTc0m+YlRR+hxNLp3gAZeu
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jul 20, 2026, at 17:31, Muchun Song <songmuchun@bytedance.com> wrote:
> 
> pfn_to_zone() in hugetlb_vmemmap.c duplicates the zone lookup logic in
> __init_deferred_page().
> 
> Move it to mm_init.c, declare it in mm/internal.h, and reuse it from
> __init_deferred_page() and HugeTLB early vmemmap initialization instead
> of open-coding the zone walk there.

Sashiko said "The commit message states that pfn_to_zone() is declared
in mm/internal.h, but the patch actually adds the declaration to mm/mm_init.h
instead". That is indeed an issue. When I was handling the rebase, I forgot
to update the commit message here due to code conflicts. I will fix this in
the next version.

Thanks.

