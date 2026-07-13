Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30EAC43458
	for <linux-mm@archiver.kernel.org>; Mon, 13 Jul 2026 12:34:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D22A26B0088; Mon, 13 Jul 2026 08:34:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF9C36B008A; Mon, 13 Jul 2026 08:34:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C10846B0096; Mon, 13 Jul 2026 08:34:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A56E26B0088
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 08:34:23 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4705E14014E
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:23 +0000 (UTC)
X-FDA: 84983696406.28.CEE66A0
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf19.hostedemail.com (Postfix) with ESMTP id B2A221A0002
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 12:34:20 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=awvi+ZGh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783946061;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hyeehTF0UJl7bQ1OjiCIBw6fAcVQ/Pe9VzkILgvs3II=;
	b=Eu7ERfd1CGEFK2MiQJ9Ga2Mt9m4XsquSaTPq64kq2qK17lkE0hNRjTIrOPBXpKjFTlMhD6
	V+LQuVaci19+CI74Xk8KymoJbBC6iQuDKFcdlyvjj8t5vmiYt6hEAaFFJ/Nj5HqIS0bCYy
	EjTnJ3iLj+Q88i1I9pGVZA2O+mA+/SE=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=awvi+ZGh;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf19.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783946061;
	b=iaDmUDMe155xVD/pyi41K18jfmM2TMsCVFPB3RYv82FaHu07dOByictMbfejISKOq3jsH+
	OcZs9Y5/5aaxrxcUKjNC85t5Q35zWDMpIM7qMbKx0CFPUxOaxqWiTL58sSRIexdlqSh4nJ
	f6M8Ge3XYuhzJHDgEaL8pI2N4GYvnGQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=hyeehTF0UJl7bQ1OjiCIBw6fAcVQ/Pe9VzkILgvs3II=; b=awvi+ZGhCzl2xVBnHsfOMLrLTK
	LlhfdhQ0zV5PA+JeV+Gmgo0e/DAsaxnjuKHlUzuIU6gYdZiGBgQ8Q+2BBq0EtXIO3O5nzZ8fDCdug
	nDDtUqaTpo6LIqd7yFYxzl4a2IpE9H8EZF7Gf1tY5PqAFEi0cugD5EipJFmFOyQPy9OG4J2nGuzNh
	2BRzbhJi9Uc/XKephjchH7SUE90eBzVCrG6PCBG9tt6gc7w3R+2c/9K9dYa63ymOQ5iJfzqK/ix/L
	P7MAgjmNruCtouBARcnMu+G7KfePIgNiSUxXEH3413EmHAEMQSPTG+sqH9LhXgamSzZuAvm9bBFWG
	aklSpTsQ==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wjFrV-0000000Cuds-3WAL;
	Mon, 13 Jul 2026 12:34:17 +0000
Date: Mon, 13 Jul 2026 13:34:17 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: "David Hildenbrand (Arm)" <david@kernel.org>,
	Anshuman Khandual <anshuman.khandual@arm.com>, linux-mm@kvack.org,
	usama.arif@linux.dev, hughd@google.com, ryan.roberts@arm.com,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-ID: <alTbSRXXqNFPl59U@casper.infradead.org>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
 <alHNjbiWFYXSPZtY@casper.infradead.org>
 <5ee8783e-4deb-48fc-a4c4-96b02d79a6cb@arm.com>
 <e0421ba6-82a5-4c88-b5db-23231c265142@kernel.org>
 <alTN0i6XgnI_eDoh@ashevche-desk.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alTN0i6XgnI_eDoh@ashevche-desk.local>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: B2A221A0002
X-Stat-Signature: 3qeq4reg3yb4jiqe6dxk6oq315ggtktf
X-HE-Tag: 1783946060-704990
X-HE-Meta: U2FsdGVkX1+tgfX8Ztx8Ub4lyzJNRknm6OMWcTy+fLTSiQ+yEVImXhDOHSRhlF3A32C0z3MXL8Pn6haA//HyoHezXBIF8lfA6C23YygWFx/hsCvzq1hiufUxdnzcAPRVaGY59Tlwt2l+g0kHA8nBIk5oCnWovglOB341FA2j1oUlpUFq01BylD3ItcMBwvdKNog5oyk9Zeuy/XXHc7Oel7j1NzV2x16bYoac9CyYA2SVqTRs2ick51F6HDhJq3IuOtJUt2hllYHTKShjidL54Q7LuKMtBWFWYpVoaXpi5NY1vjjKv5imUG0Q/51f3Ux3oslxXrXndITc44U89cM1+Irjk/X5s4+koDxMIUVBmbwIn/RHl99FHkSSeOAABpwNVOyXlDVJBPS+QXfxgNfJ2IxlfpPWkuRwnrtjF+vPiuRtze8tu7TYZkpB2F45xBZGMeNptFQRxBn/9ySso8aR2Gy3E4JEzcXWTDGufmTeTyhMqbNo2B38PwmeNVG4jWdb5jc6xjIzuBkzi3ljsd+Xo5oWrOxup9qA7qM+4DjtiPR/dbWUUn9tQBZlk00h+r6IqXzsjC8u/CNssf8tZha37YMXSQ26idnhRpk67LLOK4Mqi6rnx2kHvCRNloftqKd8uTqC/MEnPLILObV7i5rxSyrKCMH9p1gyTw5ErLBVg5BJNy5pitTQpWXingEoeW04kY8xE7YLgIy4SDErroX5KNAouTkEjnyjz2B9eRxtfJXPxjI16dRRRXzq+eWBZBqYoeWXUFn+Mi5xch0bev0WFlwZsemYrs4Am8kpaXGDiyYSvS4JYBhWm77d2yn7P3VssbMvmy32SAOolCtZrKZRKcpbi9L1JQMe33PqSLj1GqoHIAC1Dya+cr8guHhW9R7j/O4nXkFzbPR75hIIateL7zV9Qd+vrz0YeQXJ+H/waJkFmxZIsfdiIDDaIQs51FQA+WQ9oHh9n5cb8Vbo/TX
 eH2jVDVO
 M3g2cudxMijZfD0xHXxxCrZDzVWphQAZ0Ziu9581ZHfkgs5l5gpW171oqOuWRVWIQJOR4t5UbE9asMgAzNakVjrElcXILOLKSoOKe4alsEzsv6nAEOGx7T0fXBxDmBR/bQbdexKd1m+36aNepj9PAFqnqU0vjZpETZuK5jsbLWcqy/ZJug9eschXGW4N0uaQWJcCEEq5fPA8uv6hOsXPxTZVrSUYfzs0kMJUEYAS2Nhf1gZZQe4VrrmXUkw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 13, 2026 at 02:36:50PM +0300, Andy Shevchenko wrote:
> FWIW, we have hex_dump_to_buffer() for that already.

... which doesn't eliminate the problem of allocating buffers in the
caller.

