Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66DE8C5DF97
	for <linux-mm@archiver.kernel.org>; Sun, 23 Aug 2026 14:21:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 036056B0095; Sun, 23 Aug 2026 10:21:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2A426B009B; Sun, 23 Aug 2026 10:21:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E40CB6B009D; Sun, 23 Aug 2026 10:21:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BF0F26B0095
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 10:21:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3CF31A031D
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:21:45 +0000 (UTC)
X-FDA: 85132747770.14.941783F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 95CDFC0004
	for <linux-mm@kvack.org>; Sun, 23 Aug 2026 14:21:43 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEGyj4si;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787494903;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+DR1gR/h3GXOvf3/aESZalcdiFLt2eG+Sol2lIfXQoc=;
	b=N2ursCvQweesuBpoTnJR29HcJjAQ/WZ1Bf8dITxgzM60H1sLwdrZACQokDCZCOp1HQuD/C
	FOpZEds0EeeOSWYIfSgqg1ALCsRcBoj6uKfHwJ7RGHNACFjpmlxK5CAgL9BsKYBBKF+MXW
	39kGEu0NTtdDsXu3ZtHOtB10wEu8yHw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787494903;
	b=qfoZDV1OElRCRBi/puhib7zUOlSRz+9ZcpEHPl5EQKKRPOspD+LetBF6KU65xmb9VZSovR
	PGg11NwGijoqkRYp7/rcTm5/R/74tZ1t280zx/eZ/8vb74Jt+GGCwT+rwAy/617nw3G2JS
	tDr0snczgoixkcZ55v1Qzmdcqc6ZIXY=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LEGyj4si;
	spf=pass (imf22.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id BACF440A9F;
	Sun, 23 Aug 2026 14:21:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B571F000E9;
	Sun, 23 Aug 2026 14:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787494902;
	bh=+DR1gR/h3GXOvf3/aESZalcdiFLt2eG+Sol2lIfXQoc=;
	h=Subject:From:To:Cc:In-Reply-To:References:Date;
	b=LEGyj4sikQQv75jwhsGXzcPNv/XYbUYE2wbwFy5Klwrt54ZLMYgplOskJM7YqtyNS
	 Vqf/OmyEUFyN9RD83bmT/1VJBHB59YnVnK2LZ2eaiuLK2g+JajzB2SoPicIz6LCiKz
	 B1ac4Lws2ujlI13mhyf4HAtewW0UCsGqMSo9kTsmkn9BAxld4HKLOtUSBxiTJA8oPM
	 nocyRXq91aai27Z1amG+an0GDTW6PdiEQXtTPLrYcg2LMX70VKRGJ3eeRb1PzPn1Sr
	 YBGU0Mn5GZPnuWx90DcGtPPBLSbmVN++wfxjlq/Wg04HXTXv/+DD099mJx6VgYkTwX
	 QYD69tBAf0s7A==
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v3 0/2] mm/mm_init: simplify
 zone_spanned_pages_in_node()
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
 Mike Rapoport <rppt@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org
In-Reply-To: <20260814133744.2746782-1-ekffu200098@gmail.com>
References: <20260814133744.2746782-1-ekffu200098@gmail.com>
Date: Sun, 23 Aug 2026 17:21:37 +0300
Message-Id: <178749489754.3572398.2045978564409288262.b4-review@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Stat-Signature: hss9kj5s7xgrxepwngprgswgx6fqsfm3
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 95CDFC0004
X-HE-Tag: 1787494903-521226
X-HE-Meta: U2FsdGVkX18kSr3RKcbMBV69scVWg/Lwdlu6E58kN2ZM0FPdFSQaWjDxtm1t1ren1Jc1rJJs7TF9dxq/bsRlm4cGUrVTDTh91JdVt/DXdxnBDgYoh795bFQ0cIH2qtv6dfQLY84CAGIaZZbK0gV/bVduBCL3vh45SwNCA4wLv1h0jEAewlfPpBxY//pSrX05MSil1cWLhHuT29/Wtph9g5lKAlS4DZAq7uj+iBC8v+2kWFefB/fmVkD/RZDs2tM+a9HD1Z8fQmr9gxZrqU70/C75SZN9r7hd+UR3/wQW5wMZ1xsHR8IyBLZldZutdJEqk34PyjQdqHAWBTBw/IXp7Ed4C8TLNLvOTk3ewqzmMp3jjYaHgMrHH7F4TraKDqcsGSazjRzAZWYI9dLIzfFV6vNqnIQuGCTcwcOMw4IlM71UDrGgjPdh2+vvNYObbp1HqtvKJJniAObegvHwDdmpOPvHNf2M2CCxFxSBvbbYzfGlU2akLhnWJv9pJclY3s2G6m2Ee09rvGf2cHNi2+7kjqICTFFa+jK0nOa21f+1tVeIzdvi+lQBJRWd7DGBvErDD8Z2g+oEc6+VQV7KZtMpD3k+Mp5UhhiAXHuCIacaboNP4kzfYhgTV1LCEgTVF16gcsGF2tucdlHAWTJGqGl6arKBmpldBlBVdJmcqhElN3AVFCAyGbIpL1G9o9kd74ig6VStOfw5hStYVlTKUyWuiTw8CslC9zizT+owwJUiYQrp3Iwth7eeygsE+/ITMEKYd4tEF0Ya0mc4sFvpEx8vZSxIHw+QnfpeZYqrmxaY/dYHYAqKNQB6Z6KMizi5+aYG4VbwSKHmwqH7PIcJTeFV8xWvs/Rjd6VbELv/FJJ+hzhBSG1ExiaYqiXHntiRKIDBOYm7pEH5YMYItzik6ms0lcpw0Hcm81P1svT+SAcQaGg9YSt8hr/JIbuiQgmw69x0WwgTf6wP/7gXRKkTAsD
 U6LUw+WN
 H1KSTrAjYCtA/ICBTqI018zgesfGs/vITAPXPZw0/FIMk7VsGmPO96fs++0FlEZ2+LefChXUrTSrnw9/DCauUvw7PLcP97YW6yzEa50mdz8Vy806TndAZ+QvwppjjgT0XSeobNjc+ggZy/pIFIYeOLPj8XwEcqRTxA7Dk3eeXMC4jvcMwD1rJ/oYrcYyJ1c0W+wnLUpjIqwRbiJecszAG3smKvuidkzpVHKL1bfJKbvevFVk1wpg7tl04RK6/+gS2MW62ZfvN7hCvp9w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

> Hello,
> 
> This series simplifies zone_spanned_pages_in_node(), which adjusts
> *zone_start_pfn and *zone_end_pfn before and after calling
> adjust_zone_range_for_zone_movable(). The helper adjusts the same two
> values, which makes the code harder to follow.

I'm not convinced that the result is easier to follow.

Indeed the same start and end variables are updated before and after
adjust_zone_range_for_zone_movable(), but it's clear that movable zone
adjustments require this.

Having the same adjustments inline forces the reader to track the exact
range comparison with and without zone movable and I don't see it as a
win.

-- 
Sincerely yours,
Mike.


