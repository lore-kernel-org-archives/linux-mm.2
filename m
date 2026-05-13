Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F700CD37B6
	for <linux-mm@archiver.kernel.org>; Wed, 13 May 2026 05:36:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7BC776B0005; Wed, 13 May 2026 01:36:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 76DD96B008A; Wed, 13 May 2026 01:36:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 682DC6B008C; Wed, 13 May 2026 01:36:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 591DE6B0005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 01:36:20 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 083861C01F7
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:36:20 +0000 (UTC)
X-FDA: 84761286120.22.349825A
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf24.hostedemail.com (Postfix) with ESMTP id 66AB4180005
	for <linux-mm@kvack.org>; Wed, 13 May 2026 05:36:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=s64JdsS4;
	spf=none (imf24.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778650578;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bYKVLf/5Vi3tUNISsTYQhI4iQy2g6Zv2Gv0Zs6YsiZA=;
	b=IZaCS/uX5ziRw6hnekvdFbjhJPZFUSdVuu1ngBu//HI24QxfU+4TWhfsgVJ5HqNs0NDBXk
	21Zl8S2gVjExnlu4BNRmZc60yTXjWuGl5uGifEGXOR91lmDrEND0s6QeM9D9gnmD146m5W
	jtz9ix30R9kYYQ3KmDdo85iVQYLthg8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=s64JdsS4;
	spf=none (imf24.hostedemail.com: domain of BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+77458339fd797a8a368f+8298+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778650578; a=rsa-sha256;
	cv=none;
	b=ELlIAZkenFVYW2LP9QrwZVrsR2fxlxjFXmUgKoc7OyyK5N6rzhyRcnEQ6g+M7Pl2Kc75b5
	8dXVcP8U03shskRtmqX1K5XfCeqVoXsdZ8RbJh0hKsemO/KjdMfHkDCvUJ5mubDvnUx2I+
	lA/W7BYUkpLDzYJupCIAGJJnR1ICTWs=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=bYKVLf/5Vi3tUNISsTYQhI4iQy2g6Zv2Gv0Zs6YsiZA=; b=s64JdsS4gNwQfw4iw/Njbqur8p
	9S15kv257KlxUEwa9v37au05fjRNgQaM/8hiOyh2pF3XQep21Be3BHhg/f9y6KEa7MuS56lWLU1W+
	5F1XbIrS5yCr+Kc4z1Mm2gBb9UzCYVxgyHOTQC8vGVitDy3isKmsjri87xIp+X/NBU+E1JV4qo/o4
	rcjYPNX3sS3zRGGiiCkJDUoCv3ioEmWeCfdvqpawntOL0XkNbcv+k/thwmzhMDgSDZDdV8w4AnXhL
	95G84bsvYfA51aFmY1CXzRv5Ae+LPUXBQNBHaXLHt7suLQZwhVilYW8B2+LMT/mvr3jHlevjRXcog
	GgtgWp/Q==;
Received: from hch by bombadil.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wN2GU-00000001L8I-2TIV;
	Wed, 13 May 2026 05:36:14 +0000
Date: Tue, 12 May 2026 22:36:14 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Baoquan He <baoquan.he@linux.dev>
Cc: linux-mm@kvack.org, akpm@linux-foundation.org, chrisl@kernel.org,
	usama.arif@linux.dev, baohua@kernel.org, kasong@tencent.com,
	nphamcs@gmail.com, shikemeng@huaweicloud.com, youngjun.park@lge.com,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 3/3] mm/swap_io.c: rename swap_writepage_* to
 swap_write_folio_*
Message-ID: <agQNzhC_m9zvqBUa@infradead.org>
References: <20260512104201.716213-1-baoquan.he@linux.dev>
 <20260512104201.716213-4-baoquan.he@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260512104201.716213-4-baoquan.he@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspam-User: 
X-Rspamd-Queue-Id: 66AB4180005
X-Rspamd-Server: rspam06
X-Stat-Signature: c1ehg3e18i4cftfi9mm4oo3w9uizoprp
X-HE-Tag: 1778650578-308193
X-HE-Meta: U2FsdGVkX1/YZGvQfUCpC6T4fKwQ5OzCs9j+DI8NItBeWmn0Wt1bVrP4ThQc14poVAi8qZlaQBeqfP6BqqGud84jOyQl1BhAZQDEyTmXphiUYbNG36trwBs2MGpIhLO7fPReWt5AYzG6wL5XUnR/EXSOGBACD1HYezxPA80WBZ2YnKRJzGADC+3DGUR9eL/kcxSjSK4tAv3XFhHIsA5Cy9G0ngsRBwO355HyD7OBFzXAw5/rcAaY7jQ+6bu7v1kx6XQvH2Hq3R+z1Z77/yxYkVXBnIu009npV/MTajzTbaDsnWhwG6KYkYABfqa8iDdKVkLdz3nMNM3KKVPS4tZqb3ybb1slOdIi8Az01KGcgne0m0afO1MU2SL2Grk03cMS5Si62aiB5PaT77nBxjuGp7qDKs+a6AJ0DHQzVaJozmKOYe2Iwp9Zo8MF7XE8sqItcRGOyAfl4mFncaQS1jIkB3Z5P5NOxHcNzoMm+V5XSymVUkbNgi6ORPREZz+96+NX7cS9LzTxgMKFjxvWrcIJa7Z3vWP21pbaym655jiIT7rJ0XDc30AaTEy8sPYOwkOTVwIk/ZcwmqfIXZ7jH6ewzAMeMqje3nlMWlxZhkKMBZI6LutncdhRMw/DU/KBwBvJb7/aaBAyh58dwuNmqhMmZMhXuJ5iVB1uh/KkwpYjK6JLvHaJtcVBb3ciLOZCs6ICh9TC71KmkXzpcty599ZhsvsglcZ/mYH0WTCGHVO+xNf9Vw1MtjbAYOAwa9NWiWDvKCZcZ/iHk337umR9P7llkI6M9RquOeApK/jUGBULCJNPBwmrok5KodXmF82QPRhjBmrYbkBtvEPKvYHr4PLTCBTrstHN9TOST7M6ib5qRuHCF2UcVQ0Kk0Q3IkHru/vs3guNte5uV0naFyfY2Tx74SxW0Ho/Yktu2p3MciAfSqSYp1MdGVCLwUpDktxvO+cVyy429XJeRV/CIipkG3a
 3AhhLNdC
 6FcPDFywEb8+8gh02Q1CbKRhVDOCINHAVAZinEaHVQ2pNTxMjO0RTTd8CxQ74E9dDC6DW9urEKZqeUpzpYL9i8E9ObciHsZU4kZZDVBdAhGuBvwjYytcX7zcM5Aqt1gpAmJ/VabN2AdcjmKgOOGDl/1Am9sLMjwJzMcH2EXoLNLq/gkqd0PC4avTUTkchGLZJzPE0nGxD681gmCmgE/fM7ZInJmeq333jIKQ/eWTYQpCUh2G577YdQ+rtBssm9v+J9LVt015AeOk4B42b6jaoH+dHte/bY0iBtrkzCmq7BJZDWX49XRQRsrYW+lOQBWOdhppx+excjc1bqjzWsAcA0TErre/YF+z5RHE8U/stdoZAWcN03TknzbZ1NSJklFwyDUxSDh3mEQTOzphUwTVj3pGf7euSzBHHGeh/Vmf5CSYQGzAs71JXJXn16x5pYcv4MR6IVPVrVcSZ0klnq6HNGsHsrkMylm1gA7KQq8DZ3yj1wAhvvlyWixYQpzUAsFe3AI4+A1Kx60WFjcsxZZ6rxFA3Qvtrqejpc/qjZXwGXHY0rq4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>  
>  static const struct swap_ops bdev_fs_swap_ops = {
>  	.read_folio = swap_read_folio_fs,
> -	.write_folio = swap_writepage_fs,
> +	.write_folio = swap_write_folio_fs,
>  };

The convention for method naming is prefix##method_name, i.e.
swap_fs_read_folio, swap_fs_write_folio, swap_bdev_sync_read_folios,
etc.

