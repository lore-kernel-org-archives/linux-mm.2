Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BC31FD4F03
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 16:32:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D3E46B0099; Tue, 10 Mar 2026 12:32:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AAC16B00A5; Tue, 10 Mar 2026 12:32:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 702176B00A6; Tue, 10 Mar 2026 12:32:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 604BD6B0099
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 12:32:18 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DD374160298
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:32:17 +0000 (UTC)
X-FDA: 84530695914.16.C65CE94
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf02.hostedemail.com (Postfix) with ESMTP id 4C8D88001A
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 16:32:16 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VKyNj+IB
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773160336;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GCRfJr6MPjn4DphBdnrts5oH/u8hqxi4oo9mnLAJdfI=;
	b=RVfhh3S86dOAUeq+FiOwlMpeXf2Gz+wdYnf3KYm8S9R+ZnF13w8pOO5SLAi0BrATcKidXn
	qaeosYF/QafMB7HOsmR4JAvbaLi5c4OWsGcsd9LbVaHpr2Cod8HaYbNOtIaWwC+YuCONv7
	avIW14h5rFFnNnrlXGXjON0X/TcpAZg=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=VKyNj+IB;
	spf=none (imf02.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773160336; a=rsa-sha256;
	cv=none;
	b=5yLOYofJ/NX0n0DMxmIwy5EghtEjg+v+/Yw0bSvWp1cQ5OBL33nfxqp9pusCv4zXl4k3m5
	6n5bfwqpfEaErjqvLd7KLqY33CY5fXLP+NucYrYfkFCTdgy2U7pCHR7QFdxH4b3UAYTLiP
	5zIdFVIYmOsvWVgCIA9V9SgQEXCcuFw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=GCRfJr6MPjn4DphBdnrts5oH/u8hqxi4oo9mnLAJdfI=; b=VKyNj+IBMRhuSfakqpigRiDlpa
	ao2dQIquGGT/aOBg4BhZDShCvzICeQ/qVAc3nRpnopfYYwf7fhcN9EbzFgQXR9LfTPCQ7kYyJrqSe
	31GsGjiuTk/fxcg7MUxbbMe0UgIr7cpTmTgDdWHMh6Qs73MDFnMmI3kkHiZwjQLd5NSyOsx6wuvW7
	HSifkXxybWNO3lGqFnI1daWa0pmY05yusUwqbrz7V/sAPhk7KDr2eOh26JYX2hvJbCGI3q/xrgilE
	QMh7zBgdK1VBebfSFaZ9CtEPcYRPtXA3UNwmgpq9ZtSo/adwin+h6SdsjiIErRSRfYJOcMe8BNUDj
	GCdA4ctw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vzzzt-0037gW-BA; Tue, 10 Mar 2026 16:31:53 +0000
Date: Tue, 10 Mar 2026 09:31:46 -0700
From: Breno Leitao <leitao@debian.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <Liam.Howlett@oracle.com>, 
	Nico Pache <npache@redhat.com>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, usamaarif642@gmail.com, kas@kernel.org, kernel-team@meta.com, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
Subject: Re: [PATCH v4 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
Message-ID: <abBGMmE6EidqvWAc@gmail.com>
References: <20260309-thp_logs-v4-0-926b9840083e@debian.org>
 <20260309-thp_logs-v4-2-926b9840083e@debian.org>
 <4f2abf42-983f-4cc2-92f5-c81827e7b7e2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f2abf42-983f-4cc2-92f5-c81827e7b7e2@kernel.org>
X-Debian-User: leitao
X-Rspamd-Queue-Id: 4C8D88001A
X-Rspamd-Server: rspam07
X-Stat-Signature: jiuh8grab8q7rhgj4krhi4a3bmqpct1g
X-Rspam-User: 
X-HE-Tag: 1773160336-274277
X-HE-Meta: U2FsdGVkX18mJOytMQpGqFyxq/TDNmg0lxV5TJ+uKVfHnyQFWQkINd1+EGlSGTxusBSFjafpb5/RoubJCf/50drHv2idUe8MQohnbUQp5cp/gy0AK6nPlRxnWhsMaRuht4uvNwBJDd6xM9445ZPHGLkEuKajobo4FBv1N+pkgAP4jzksN0xcaFXltZumJ1izWuZ1vDtk1QpiXoy2GPJZL6OW/RiD24XGA0hxrR2YrVK302Qjeums26GfCJgrjINZWB/qhW7icnXebXLfZAtsjYpJdbdX0EGwnGQBrb8BsiwmsZgaqZ3A2YylTjDzg3RJtlcy4h1mppFA5Sr+jFsEYAW5hiCi7K0DLCIA4jSpF3uB+5/fU/VkO9mE/wbOHau1V448FVvzCCsLG2Jr/XayKbciAR6NtuuXQx/fx63Vo/jS0K1y7iAty4j28riREx9W9tqwuzco29Q09aGt6PXTOCD538iJjMRS/t0naFOxF+gej7zONH5Nq3gvBf0rqwUyeMvefd2Ms3MvmObm0H5Bh2JYAjCfz0O3bScaqEWAjnQHuDMGMXwVXDVG1sJoB2WLA/g2o8lt8Wrv7quzxMvb5qaVW9weTQ/t208youKtCLv9XTiWNUvSRhgqlh1sIwK/lAEIGZWOiYBvrWyj9Wib04luo9YDe+nMjzJCjD7iK9ry51a8Q0PIqMUOaxMx8vpUgXsdu9DJMVPqzfM2LECQ3+P4WTpOSKfQz0SXXRMgj4Hp9lD03T+2InMQpJemB78pgx8q+cCL/bFOVbZZDfOGE0q9qBPr2bMRRmTIHIi0PAl3X6+97PAgvaiofncVAfQU5D2KLCikNq+eUsJXrRwrPZ+mSZG9R65x
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 02:43:11PM +0100, David Hildenbrand (Arm) wrote:
> On 3/9/26 12:07, Breno Leitao wrote:
> > +static bool change_anon_orders(int order, enum anon_enabled_mode mode)
> 
> I would suggest something a bit longer but clearer
> 
> "set_anon_enabled_mode_for_order()"
> 
> Or shorter
> 
> "set_anon_enabled_mode"
set_anon_enabled_mode() seems to be better. Then I have:

set_global_enabled_mode() and set_anon_enabled_mode().

> 1) set vs. change. the function returns whether actually something
>    changed.
> 
> 2) We're not really changing "anon_orders". Yeah, we're updating
>    variables that are named "huge_anon_orders_XXX", but that's more an
>    implementation detail when setting the anon_enabled mode for a
>    specific order.
> 
> > +{
> > +	static unsigned long *orders[] = {
> > +		&huge_anon_orders_always,
> > +		&huge_anon_orders_madvise,
> > +		&huge_anon_orders_inherit,
> > +	};
> 
> Having a "order" and "orders" variable that have different semantics is
> a bit confusing. Don't really have a better suggestion. "enabled_orders"
> ? hm.

Ack. renaming to enabled_orders.

> > +	enum anon_enabled_mode m;
> > +	bool changed = false;
> > +
> > +	spin_lock(&huge_anon_orders_lock);
> > +	for (m = 0; m < ARRAY_SIZE(orders); m++) {
> > +		if (m == mode)
> > +			changed |= !test_and_set_bit(order, orders[m]);
> > +		else
> > +			changed |= test_and_clear_bit(order, orders[m]);
> > +	}
> 
> Can we use the non-atomic variant here? __test_and_set_bit(). Just
> wondering as the lock protects concurrent modifications.

Ack!

I will respin a new version,
--breno

