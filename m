Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4CE53CCF9E3
	for <linux-mm@archiver.kernel.org>; Fri, 31 Oct 2025 03:43:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2668B8E006A; Thu, 30 Oct 2025 23:43:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 23ED38E0045; Thu, 30 Oct 2025 23:43:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 180E98E006A; Thu, 30 Oct 2025 23:43:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 06A8A8E0045
	for <linux-mm@kvack.org>; Thu, 30 Oct 2025 23:43:02 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8F8A3B86B5
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:43:01 +0000 (UTC)
X-FDA: 84057013362.02.C9AD2F6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf21.hostedemail.com (Postfix) with ESMTP id CCFAD1C000C
	for <linux-mm@kvack.org>; Fri, 31 Oct 2025 03:42:59 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XNYpNu1N;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761882180;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Firop3XKVZuqdL7GzDqqIlTFlc3giuSlIK9Ga70us3w=;
	b=sb/1/oP5bXnMQz9u8keoTJKcsidJevcvkjAEF5UdLX0QJVoPUKroal7qdyrGlUqAWh000e
	njoOvsHRKys+5s9JUP4XHJE69mEK+9U7ALwMHWj6b3wIDuTNE3+3SqVZk5bDI+G5Y9QDe2
	T+O5ti2OoVmkbMpWYLfUFm4rmJuCt3Q=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=XNYpNu1N;
	spf=pass (imf21.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761882180; a=rsa-sha256;
	cv=none;
	b=ulj0LJbsIhQazsEzGYv3ZOr/QVaGACrTZens2rV4jpUYfk55cV1IfDUbHKzmx5Wpm2k4bQ
	WXnmfKnQMjqrdtOS4wXTT+FPFYt04CCyN2JnzXQxjrMnOFVOjJ+Z5QnojY7bmjx4GZYqpb
	YpCe2mIccPOZ+1T0jjp6Hy4T+XIRDZE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id BBB804199D;
	Fri, 31 Oct 2025 03:42:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BBEC4CEE7;
	Fri, 31 Oct 2025 03:42:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761882178;
	bh=Y+7+7cmXmpwcMKwAwk6LejI5cq/8Ck1dQ3CuyXnaiaA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XNYpNu1N9e9lUBpNuqq6HIe00uIhOWv8PJP2J3Cu/q5ZZHnD2Wg0z4BGhT9w25MEr
	 VTlMQRpVtXE7bbKOHBHqJz2pXBFNVW2N/hbjlMs1nioljoEGdn0K1Nip08Me+/Fuw/
	 JTMmir3FCXyeiat8GcOLOaogucmgsPaN27tGE1V8=
Date: Thu, 30 Oct 2025 20:42:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Zi Yan <ziy@nvidia.com>
Cc: linmiaohe@huawei.com, david@redhat.com, jane.chu@oracle.com,
 kernel@pankajraghav.com, mcgrof@kernel.org, nao.horiguchi@gmail.com,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Baolin Wang
 <baolin.wang@linux.alibaba.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>, Ryan Roberts
 <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, Barry Song
 <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Wei Yang
 <richard.weiyang@gmail.com>, Yang Shi <shy828301@gmail.com>,
 linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org
Subject: Re: [PATCH v4 0/3] Optimize folio split in memory failure
Message-Id: <20251030204257.13590714dfb2deae8c2f193c@linux-foundation.org>
In-Reply-To: <20251030014020.475659-1-ziy@nvidia.com>
References: <20251030014020.475659-1-ziy@nvidia.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: CCFAD1C000C
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: 6mdrwdyihgcunhdw3giir5tmppzt5jqe
X-HE-Tag: 1761882179-981679
X-HE-Meta: U2FsdGVkX19tRkyPH8WFMg4Mmgh33/5fEEUtChNcMktyO29gE4V+onr0ZOYbsG6GhrSuQlSikDPGqiO0b8Xvom8YjhLGWV+LbOBR9sV7a3bU49C05hoaLIvSK/jWr7gIouCwI6SqILpPSXtxH332V9dzZBrmhHhf83cqnjbacQixCKF46CiyBsFXSYMH8RZKAlJ1iZ/y300PRwus4OQj3kaLrMxXSf/QxcZ1iWryXKNuAIeEJtoChiKh1Jv3yoJ1Vio7vnruHUkqXLivPD+/RXCvl3Tp+dD3S0xe6RkMmeermHIKKhOhPgZEfSEipowd1U34PgTkCYC6jLg2TSUlBioaFhLeamXKAEYUYgO5TX0ecmxt4GJZTl6Bc3U34/PQEMN7ppd7p3lwpW7RsxSonljLnEyTurUY1wOpGpP+ChLre4xq6atDdANH4ei+NSU0tNw3dNxHLB4j5ehUy9n75V3w6RNJgbpG1sKA5GqUtFj0UaDhdXZTottiwe4bKUzgn6ALw6HyMSU4GQSm/LaJOU7xvtQRZOVKlFMjmCl+GxRU1PkmlTRmSVVOLlqnVP/vIi3xw9/XWm+34J6Qa9gBL1mSzYFryBhA4fagq5h/4KPjWIEaTlKml5yASWJ647/GE8H80WzeEMNlRBbuTP5elvykYWhiWgKO99eiFqcyb1UAtarwVNzhbqXnoU6/HxhukfEVTX1Nnuf6Uty5O7IRf8EN0DDJozn3CvxocHtoyMlQZx0C+QTg5iV94O8QmbGHrHfVI6djL6JCYRakeNl5Ed/2a22LqGHOV//5nSrSyeHjriDwtxATYcxbAPu9u5DdANMwUcswAM+ye65m1IjYJJMQvRY6QJ5RuCb8ZnscBAZDq9wQD2pPpbcYgZy9dmfhFqFn3ewty5aMw3qBhrhqalmjLRlAUJy0t7/IpUxc3gk3GbZWxcfdD0k/bpeFiZZiEzgYkvSn1mnBEee1Ojt
 ++A2d693
 uJ+IJWDJdQfkdw+MojQbbUR76ym1jvzZZ7KM2IUsCylCqAGpS4MwGQxdjiNDvWcl8wtv5svJyTHiCaw3yc/qspKTdhtWdLd4TEmWmV5HzaPKxOZFYUmoZBcr78vBz9mbVHtoDSSTaPnoAq8D2KkOqDP8iBZ+VwLuW4xVZQwATP5QE8Age6oy1v0vpcWWS/QzMpFQoCaHkw8Btwv2yVpjC8tvrdVwwJJhXIkeo0LT9Fu6BwsKgxphsQ/Jw2fDK/MHxxoJIwqgTnMX1VF6RsgSm6ntRHSqD3uk3HsvduweLfCsi7Emc+ZF8rtQE81gurC5DuvYGHHxZoR2WG8jGp6FeAF1IKg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 21:40:17 -0400 Zi Yan <ziy@nvidia.com> wrote:

> This patchset is a follow-up of "[PATCH v3] mm/huge_memory: do not change
> split_huge_page*() target order silently."[1] and
> [PATCH v4] mm/huge_memory: preserve PG_has_hwpoisoned if a folio is split
> to >0 order[2], since both are separated out as hotfixes. It improves how
> memory failure code handles large block size(LBS) folios with
> min_order_for_split() > 0. By splitting a large folio containing HW
> poisoned pages to min_order_for_split(), the after-split folios without
> HW poisoned pages could be freed for reuse. To achieve this, folio split
> code needs to set has_hwpoisoned on after-split folios containing HW
> poisoned pages and it is done in the hotfix in [2].
> 
> This patchset includes:
> 1. A patch adds split_huge_page_to_order(),
> 2. Patch 2 and Patch 3 of "[PATCH v2 0/3] Do not change split folio target
>    order"[3],

Sorry, but best I can tell, none of this tells anyone anything about
this patchset!

Could we please have a [0/N] which provides the usual overview of these
three patches?

Please put yourself in the position of someone reading Linus's tree in
2028 wondering "hm, what does this series do".  All this short-term
transient patch-timing development-time stuff is of no interest to
them and is best placed below the ^---$ separator.

Thanks.

