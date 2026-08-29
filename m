Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DEAB6C61DD9
	for <linux-mm@archiver.kernel.org>; Sat, 29 Aug 2026 14:47:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5B23E6B0088; Sat, 29 Aug 2026 10:47:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 562626B008A; Sat, 29 Aug 2026 10:47:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47B496B008C; Sat, 29 Aug 2026 10:47:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 284F26B0088
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 10:47:47 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id AC8FE120165
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:47:41 +0000 (UTC)
X-FDA: 85154585922.17.A4C5329
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf25.hostedemail.com (Postfix) with ESMTP id 31F7EA0004
	for <linux-mm@kvack.org>; Sat, 29 Aug 2026 14:47:39 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c11WGKUc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788014860;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=451qKNGAxHR8XMQ8rJK+DM1y3GkdvqoIqzCuFMlj2JY=;
	b=7nx6APJdMNAJ0w2mmuKsWzD0wCdQVpeQPOPtZuW70pI+nR3hBPEOTe2QYYt8eQCsEsWO4h
	C3X8EJhpMMVjeLq6zVxCwVNA+j2qSz9tzp1lVButpFV5uFmo5jJLYn9l/W2JzjCs1zvsHO
	OjRaociAWRiGdCKpU9L45ExDq64Tyjw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788014860;
	b=pgPUICP+rnEDfdKgFQtNMtWcuL1CZDKV/Be9Mdm1DueBHkUKLn70DRjqH39B68gibJDg7E
	EneZztKhaHCksGBMZLbUq9y/Grm+CnqsV6bDbi2pflRaDkWihJZU1JqBXlRbjR4agQbY4r
	Wzcl4R6+1m9Bs+DImHEGyxlqQOjA+8k=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=c11WGKUc;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf25.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=451qKNGAxHR8XMQ8rJK+DM1y3GkdvqoIqzCuFMlj2JY=; b=c11WGKUc0QL+aSOLuWat6Mnz54
	vyrOGredngk9WE4fBm5aLGD4kX7pz0aYwyq0oalgHkgJBFFUWJJ0EohzJjFanrGdKw7agomkxuk3R
	NugGYXt4VvtntimIGrpChZWS068W/yZlcr3a/zfPTYQ0DA425LuE+LPl9b16ZtSNLx8EqIgZNHx6e
	dOpHizf0Wyn2UR7uq04FGbT5sYcPFo6QOj2cXBbBMVHCZ0+tS9lB9fGUtPgTM6UU16S4TkHSXyZY6
	YQU9f9GmRZnNfzw9kRUNueg0JsW5yLJBcbO/CgL2AQ+8xsBJXYPe0HX0J1pDvBxpi7dy7qr3nYse0
	ep1DJ5TA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1x0KLH-0000000Gbt5-16nI;
	Sat, 29 Aug 2026 14:47:35 +0000
Date: Sat, 29 Aug 2026 15:47:35 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Wenjie Qi <qwjhust@gmail.com>
Cc: jack@suse.cz, akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, baohua@kernel.org,
	axboe@kernel.dk, trond.myklebust@hammerspace.com,
	qiwenjie@xiaomi.com
Subject: Re: [PATCH v2] mm: filemap: retain mapped dropbehind folios
Message-ID: <apLxB3TIwFExyWOC@casper.infradead.org>
References: <20260820142956.1414337-1-qiwenjie@xiaomi.com>
 <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3fa43eaca792bc0bbde4b82a6c1fcdd3f528b398.1787999152.git.qiwenjie@xiaomi.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 31F7EA0004
X-Stat-Signature: gnufupg91cqyu8fxp6p9dift6yowjg9i
X-Rspam-User: 
X-HE-Tag: 1788014859-479232
X-HE-Meta: U2FsdGVkX1/KI+TizHC+mxwMOU2gM2Dvdt67h/bvuvLm5L8/E4VTiJyBQPipqHjbe1B/j+hRwhQExt22cUJB0kWySlSqsnM+9F5//l+5YgldKDpXrjChgsfaww48kzpt7xMMLXwXZrKKSVb+HcLVeZxOtSVCuYIm5INZAs6RFsbT1ou9v27QBQQtNXQzG4mh+m1dbpdPKfVzYXw3/EAUtBOkeV9C6GAM3KFsu0g4sH1AOnHgU/lW/Ul9Zk45RynXtlhLh8lf8tDaFLfIoxL3eWvtQnFM9QdVCWVuwcgojo6XBPee6PThPme4MQDDSpIOVQnxBT3G/rxnCfR8IR+iJE8TKV2h8P6TAQ1h35VS5G1yI3xgBdZIxvcgLI3Jn9tx4NKeNVin7hf/D/rl97Q6HQDf4kZu2L208KFso5QaxpihN/Msm8o1zcLXwQxV1C9RZwhdu+aVlLjBIiulgNkb2Ahgh6zhXDRfHzJPpepQARNzFQ/epa6MLCACqpoZ8g3MStTfXUb6i9DCHaVt40AYmZk36R4wKJhyBcikTjgVdFjYGEp10ismV3werZtmwLiexxcwec+Cyd0o+yoezm/9rdbmr58puxPmhCCXa2sCQn9NBdTu/YxHWBe4UpR56if+sRkGSV6oaMnkP30NdbnIU/7WEjBkuvHxgX9X3mdaZs+QaXtli4RXX6gtEq/Awnv4xuu3BWO29DEfKOlgC+Z9z2g8NaBfHsO4i16SLJk8Hty0dtRuGJMViQ/XfiDYaTVEFDRTH8xjukzFgW1Q4j8Nbq1pCItjtbnNu/Pj+m3VECBi06R/h/g0wjHHlHA6QKMSZfVgLul9H9RS4MEoG2iGs/7U6a+I5LDaX47JCYuQSdp7nraug7RARmXqK5WqS8h/18HEsd+w343Zf3OCFdRtewTzC5eFbKzaBt+VWIouD82UTcVPQnntSi6qUm7aVwy2oqSZrtW8Q6c5HRL1gw8
 K9X8GuRf
 NssUJuFBLTvFRwUVhbu4Ae2DvoFiXILxQs9IEcnSpeeW7fncxUjkeLzsU8ggshuwXtPxsOqhpaNPQMFm5PNotRfnYad70Uut7axqjGH7oozoujrP0VxOzZVsHviDV0ZnZKum44wPOgHDxuzrdFmygNXx1rD0fHv+HfJMGNzfThnWgtCuY48z57lWEnzaG44Y2qzHFbF7yeeXk8L3VkXA+vV9ev/b3ttDD2p31HPfH8xNYuFvTOdGjIcaVfg+1V8paO1zSEK1YdWhiQQpgKoGZ10cpnDpzVGq3MNIDzzEEE7ax0PFGPKRR68DuISh26FV3QB4//S4VUWOTxIQDO54X63XmxgKulZi9mWgc
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 29, 2026 at 08:30:47PM +0800, Wenjie Qi wrote:
> From: Wenjie Qi <qiwenjie@xiaomi.com>
> 
> Fault-around can map ready dropbehind folios without going through the
> normal page-cache lookup that clears dropbehind. A mapping represents a
> competing cached user, so retain the folio instead of forcibly unmapping it
> when writeback completes.
> 
> Unmapped dropbehind folios continue through the existing invalidation path.

Yes, I think this is the right approach.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>

