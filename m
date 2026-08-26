Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E8DBAC61DBD
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 11:31:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 69C676B0088; Wed, 26 Aug 2026 07:31:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 64CF26B008A; Wed, 26 Aug 2026 07:31:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 588F56B008C; Wed, 26 Aug 2026 07:31:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 336FD6B0088
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 07:31:20 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 923EC4036A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:31:19 +0000 (UTC)
X-FDA: 85143204678.16.F89E091
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id EEB67C0014
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 11:31:17 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TIbpn6RK;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787743878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/Bd2roISMg/MEEHMt1PrIQbAqlMT3O5loRi1WuUYSWo=;
	b=gbv8LnHJLgv/6Lj2+N+tQbEaZR5VgW5ve9RBQfTcG39ShhMjKLDylGDwKYBnFWUGQr6JRe
	KhbwcGtG6vQIwRECe81eWiKiH5rguWi0VaS6viVblajtD9i68tvkYsAzQ0hvUOL/TE52qL
	AFYDiYf5a7i0GzkmMEGuZi8caennBMo=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787743878;
	b=56K2iTx3tqryUOTLv8o7oT3oRDIlaEzcjmYCzBRQ0WlDj0F7bh6JfO9jW95O7Jm5assek1
	LJbL+wCHGonHVvXtZAbtpJhx6LvVXTlwjbEq79THa7OKxKi1e1msZaymQQUuVxJesDYfGV
	eBIZkFRYB+bvBzuaN+8MPzn7cU5AGrQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=TIbpn6RK;
	spf=pass (imf22.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 19397600C4;
	Wed, 26 Aug 2026 11:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E1811F000E9;
	Wed, 26 Aug 2026 11:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787743875;
	bh=/Bd2roISMg/MEEHMt1PrIQbAqlMT3O5loRi1WuUYSWo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=TIbpn6RKj5Jg7PWffs8l9yuqXdFBY2Y/dHc8eHBedV1zBP+UpJsC3CakCTxRQ6J/N
	 WW7zuiHQJ06zB75p3npsyMm92D6BsW047WhhsopZCt/Ud2YhIDyRR0sCbo58f1Ycnb
	 0mslxCfOLJclfW/eBh43B/I86rYYQARbNv4eVOQ50nLK2AJxk0B0zaL6527yLAkON+
	 AmfdzmqLS63ivRxzZsmn955lj9muWNjCNjYf+VXy4dAApDkxJUymdbwEXn8PUGAYDM
	 l4kcCZiHpz9YTrwEAopE2WwnuhpduwKmXueQ1IdIzvrpWzKgynEWN1ZBrw2j/opMm0
	 JAI8zmSyaeb3w==
Date: Wed, 26 Aug 2026 12:31:09 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH] MAINTAINERS: remove myself as THP co-maintainer
Message-ID: <ao7Nr_FALfP7cTY5@gremlin>
References: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20260826-drop-thp-maintainership-v1-1-3d102748fa17@kernel.org>
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EEB67C0014
X-Stat-Signature: fu78twmknq936pe9hgrgxacshtoyop59
X-HE-Tag: 1787743877-278775
X-HE-Meta: U2FsdGVkX1/njh+yVB7X+Qsyt/qSKEHsZX5nJVWhMz/T27pgAImB1BO2PRLIiMvfjrExzF2C1WxwCpag+YsTPD/F38aH8w5w20jy+mmhtbiD+rSHAtUpeP5kMG4esPyZoE5nXdTNQhSSS7PhQL2hf3CNlGVyNBfjTnZYd1vfrgSxxJZ7oB7l1PQCsIDjDhUEOknV2gAzljLyyjtJGhKORUEwwoEiRmDUoUqVBBMWd6xTs78c++JD3O6S6RXE3AXKhw5GyT9IhlEQdeNRQ3k/kaCQSAJjYBaiQvgwekllmS8SwfMyp4p1aTih4gqt1Lucxy1Zd0O2pivSt1hPXuFGeOcITIL9yyYfCTciXGy5CyaI3k8c3mgEAGqQ/k5Qz4f/bB6Ec/e+fHNPheAWIFBopmUt7zpMKgunhJCxUxDRKePtKOLoCDWhMIC+JUE9gOu32PFICbRq8zy4/Baqm9Fo9kBnKfmyAl86kaXX5bxo2rzKQquM5PACSoxO3nbv0oo9t+siy2sLmJcRovG/038Dc99uh/rMBSsXYEXlLvByZwL8qqkcgzHU7v/qn53uWg9LzrQ5I6KOrr8X8zeVfypUgfeyzoa3lHliD3LIhEtIyF6y3ZOlcJFB7gIOuLKFtmq4ufZcatE+Cj7FJPglkJZmB0u74rO8kQnDO7O9vnjK2lNouhp8MPFbVY74Jpu0G7rbAli7j16+W/Fj6KTzKLuiVGQDK4qAbAYA2KaxOSpVEmMQUhWIiHQczWije0VnyxSI8JyG1gYJlGcOIiqKF2usEaboXH4wFyFB6IVQNMCs0giMB7oj73lsTZVe8Erv7IzFfO+qP/D8F7AXr1auk5j5J4W6ljh2DWGJLxce12aL4TeYQ2uIijeEX/DTMK7Q3+1eSmktF8mCgVb2ExPZ+XqWs3Vjcdcw+MFAAauuB7MlCX/GMRnZ28yW4k9+JIZ4woeYGxDXYOpS/yMZzLVaGSJ
 Ur/7JZ4c
 RPQLZZU2iOdCRPqJxWZzDJncnvCXKnoZTbHP1SZ5XMt4INASLZBEFdjS6j/zByuF3VIj9UuSCn/f1jVPartlTjG3j8BGQR9RQngA8vF2a/77amQm3cLiZ9KykRz/Vo/bAPGKkhR6veWIcRgXFNo7FHKBQyR+tPlvVBUgHaTOeKPpZY9/6C+zw+McIovc8uCkbeCQB1PDSzBDBxtiD1kiDmviTWdEuf9jXVDHWS3SpAkVjrDXf9y6WTHZQHgtTLrOmTeqlxu1VkTmZnGe5eRm8jLEJsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Since it's 2026 :) I asked Claude to look at my time as THP co-maintainer:

	~107,000 words of review across 948 emails (in 279 distinct
	threads), counting only prose you actually wrote — quoted text,
	signatures and attribution lines stripped. That's a full novel's
	worth of review commentary.

	Along the way you handed out 194 Reviewed-by and 15 Acked-by tags,
	and your longest single review was 2,404 words (mTHP collapse
	support, v12 — the khugepaged/mTHP collapse saga accounts for most
	of your top-10 longest reviews).

	Estimated review time: roughly 300–500 hours, centred around ~400
	(i.e. ~7 hours/week for 14 months).

	1,615 THP-related emails in the window: 948 reviews of others'
	work, 278 replies on your own THP-touching series threads (~31k
	more words responding to review), 382 patch emails, and a handful
	of MAINTAINERS bits. Busiest months: March 2026 (131 review
	emails), June 2026 (113), August 2026 (111); quietest was December
	2025 (5).

Think I can be happy with that!

--
Cheers, Lorenzo

