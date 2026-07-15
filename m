Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B7CF0C44507
	for <linux-mm@archiver.kernel.org>; Wed, 15 Jul 2026 21:19:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6A9406B008C; Wed, 15 Jul 2026 17:19:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6598D6B0092; Wed, 15 Jul 2026 17:19:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5498A6B0093; Wed, 15 Jul 2026 17:19:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 299D16B008C
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 17:19:49 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A9C49A0366
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:19:48 +0000 (UTC)
X-FDA: 84992278056.03.2D1D8A3
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id 5DCF5C0002
	for <linux-mm@kvack.org>; Wed, 15 Jul 2026 21:19:46 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ndcNodN9;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784150387;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=F4Wch7h5bGb2mJ7phUTBuKN4sBgWUpS//Phrn4g4iYY=;
	b=jKe1pKh2SeI7YuGZdMk+JCAwcnwfZXddnE/moVkj4oYYa76oY89eUd0QXjpEtSlAbbliUL
	c1D+4DXaG8qb5ovDPegBDt7lQWrQrqRGcSr4mycIW1j9/7c+Q8M+AMoG8A9dtg5Jmkfwub
	c9oVXH5EkulRDphrrGaPLkP7Wv51xNo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=ndcNodN9;
	spf=pass (imf22.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784150387;
	b=qRNR0Bzq3o0PO826zLD/UjFwRnwDWVhV0J1HdLFK72NwsZps62COZiwgwBi9BauyE0xfwg
	oR+WWV+ddqn0lSpvrTlWnjZpcQto7D3dcKy8rjXt6+c2GaMr2FXjD8INi5cneiI7NWz+5B
	QBV+oPF1ma0PlYccWVL6tbUiPj1ckks=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=F4Wch7h5bGb2mJ7phUTBuKN4sBgWUpS//Phrn4g4iYY=; b=ndcNodN9bX18zzzSX7ez/6W5VV
	1L7shNryZ52R9d/L70Yw6Ch+Tw8EN5wFoANpRVRsx05HEhBRTfxfB5q4nWa1z5vacmyLf+ALLcqGV
	RIIHKiztXxUuABPuQrpmEIZgkLn3xs5LQVHBnAQ47Ma+Ywfu2ZMeqDVq0RGHbdP3oG/mI8h3QJRYI
	oMb2R9+V91DE4JHARBpdZAmIkDdzNSPsS11wLK+GoGBroEV3jiFvOEpVRYRon+Mp836bRtCW5cr8A
	KEPylQj2k6ojeeYXQw1geIqsUJZ/FqkDIMDXKtCpbdsveosFLJ8WafOoPX4vH/bFq0vfX3f6d/rPg
	sy5Yxy9Q==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wk711-00000000yiu-2mZq;
	Wed, 15 Jul 2026 21:19:39 +0000
Date: Wed, 15 Jul 2026 22:19:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Miaohe Lin <linmiaohe@huawei.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Jane Chu <jane.chu@oracle.com>, linux-mm@kvack.org,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>, Jan Kara <jack@suse.cz>,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <christian@brauner.io>,
	Usama Arif <usama.arif@linux.dev>, Jiaqi Yan <jiaqiyan@google.com>,
	Naoya Horiguchi <naoya.horiguchi@nec.com>
Subject: Re: [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
Message-ID: <alf5a0HI-vkEGUEz@casper.infradead.org>
References: <20260709184740.1286561-7-willy@infradead.org>
 <20260710150204.1887475-1-usama.arif@linux.dev>
 <alEpBqExnyvBnnxi@casper.infradead.org>
 <alZw5EdYVYCRNyj4@casper.infradead.org>
 <3251bb16-be46-f752-a6ff-a6c3181f49b2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3251bb16-be46-f752-a6ff-a6c3181f49b2@huawei.com>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DCF5C0002
X-Stat-Signature: 51wjsdy7nxp9daupmc3fsrie1suwmoee
X-HE-Tag: 1784150386-884991
X-HE-Meta: U2FsdGVkX1+QI+PTovSxJGYy5N+EV3Qt4s6TKk6bj5DYxvLSlB8A3J38gFqJ2cRNk6XS91khXLBxaaDAwVnFh4QBFO+Kez9Mq0uQde6v1nIZElYaPm+Y6LvoApUlKB/b94jaI98IMTxtAo7ty+hC1i1SKbl0ATG7JVzcAkV3Sk2/7hBc7vzfZnQUGniOc/VipDqR5zi6oUtX69T0PIGWWQ5T3C3HO6SqXUZ2HswRRX6swPRZvPEfauZkZ4bnAlX71qfxR/W2OV7WenFuanxj9O5IMAJ/Hz4Cg0n2pagqK1T7drr6DSQZax7aTeQE+NXgxJLwH9blmkFRoGTZwIanR/Td9YVG5K9IyS5viyCBSqppeN6TrUIBXm1HvNfdHgqb3iuYCn1lhU0F8FAqm+0JesrtkWVfiziNtHW/k1hHLtyQ2cImlNBDuWPXBvBldGF9bLfW0RgzdYWj559tqO15YxvryNbMvztFvRJHRZahM0r0CRQ1Qy9/iahOC2fu5jx77rwNTEz/Dhydnk4tIAL5h2yv3VRlbo8qP1LC3Mt2SJum+/AyyG5V3DDzczWqqWQ/Tp2bOHJ6ZY4Gex0Iznuo9r3d2ZOeAnq9LlVc7zQK05mOPn8BCSYR0D4OUCMH+kCIjfn6jYxhLcEafWm5FKzpxfE2fZ2R1rDyOXCRUjiavTnm4G+Quw59PlMp2uAHDhMxLD4MVU4IHJmd5k8dEaTb3B3/4gzl+OyaevoRg4ng9lkFPlE1byxrFJanITsV9yYTkSE9ob/xLZVV2CkSMtB5Vy6wSeGY1hxhTW5vqQV0zYRKki9z8zMkrRSwQWZUc9vcWhCk6RmmlqHCZzRCKD0v9GS8Ffkb7/Y4PBYZU+wc/NTpazpmUKEIvEvzRh5l808EFQVFAjLIarofpksVee7UQNfmF+daUdZJaEDwpFdc8jZ+BbvwZHUKEZZRf7uP3BoCawJPLq99hO7GfSJgYfH
 KIXwd1bM
 QT6qQgu5C3nmn9Ll5DTQYHB8Q3/DWdnMty1URbbDQfJB939Nxsc1sp3PEyUfviiECPhs8XMbHJy7QJpkKcd3IMSFeZsaVZLiLXumrLuJQT5p5Y8WRa0eSes8PUkQjp37h4GzGyMLM/vCL3c+uY/OD/I59wy2WkuHB6l7JtfIKAMYivYwW8SSwP70A5gsLvWE2vpWnMBqypNbDIVE8uXKXatmhP9smucjLiKNbfVB6jvQemXXWMnfvownYEd9SQHoa9GtAnbbT3OnbzXRab2DAzVTyrAcc81yAFZPs/+KlouGqxkydo3wCbzKmJKFyH4VIOKO74a67cCxjXIr2//CGo/s8PFMJFUnkcd8x07TK5T81NLloqdjorUeiuB2As/XWTQo2eVIqejK9XrM/yDOUZjcqEqVIvOqUlTUHukzKHnso4kg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 15, 2026 at 11:19:59AM +0800, Miaohe Lin wrote:
> > Since we don't have a refcount on the folio, it can be freed at any
> > time, and the hwpoison list head can be reused for literally anything.
> 
> Sorry for late but could we hold hugetlb_lock here so hugetlb folio won't be freed
> after we fetch the lock? We can recheck that the folio is still hugetlb and hwpoisoned
> once we've got the hugetlb_lock.

Hm, but we still take the mf_mutex in is_raw_hwpoison_page_in_hugepage(),
and we don't usually like to sleep in predicates like this.

We could introduce a spinlock to protect the raw_hwp_page list.  Any
objection to that?

