Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 051F2CA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 13:30:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC2EF6B0088; Tue, 29 Sep 2026 09:30:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74456B008A; Tue, 29 Sep 2026 09:30:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D8ABC6B008C; Tue, 29 Sep 2026 09:30:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B60616B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 09:30:41 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20325A04D1
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:30:41 +0000 (UTC)
X-FDA: 85266884682.29.E76EB72
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67FD4140004
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 13:30:39 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwQw2msT;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790688639;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CktuKaVpQF4v7fUWgp1B/FLtTW+0VHvulKFUhKzny6M=;
	b=IIZKC1sMvU6phNbIaqXM708L8YsRBn3zZRElq94YMrJ6O8RIIJ9Ka9XX3UIdzsk9ENwXzK
	d7IdEn+xqkOqkC6OBrNLhGHZgrGcuPA+dfm8a9r4o55vawBpTBkCdujxPAH9lp3TIwOG6K
	VkhA37leSmlQXdBx75C+wcA0Yu0gZ0E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OwQw2msT;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790688639;
	b=6D2AyULENO8QK1tWYR0SS7vTH2MVaPX6nUzMlfvdDkTwZ3ablpj4NmTQn1/G0fycKXJP5T
	KXXHiB+HwPH9b4n+FJEPc7V5MOiGWf7jr+j/Sr+uN1fEYtE/e/2BTSCo+qPzlR/c5oAE6y
	GoMeUG8hCQ+nR4aIpHGdELtcDECJz9I=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id CA52343C7F;
	Tue, 29 Sep 2026 13:30:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA871F00893;
	Tue, 29 Sep 2026 13:30:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790688637;
	bh=CktuKaVpQF4v7fUWgp1B/FLtTW+0VHvulKFUhKzny6M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=OwQw2msTwGYBWjPIoGKWVaY9WOrD1EfK00LheuYYhSxVBHTi2aKUA3nRNzWydFewU
	 WgoXCi06D905T8lhQFKvNWjqkRDrHGUNbaaLm/N0HEKKq0Bs6jb0MR3YwfUqs18DLQ
	 4eHYqxCVQZmmQvSDMZVWPugfwOuA70ZEOktwOaEICARldtAvNcN6MuQeA++r4KqfXR
	 IS1k+/0fdIHSaG+OXsD/WvDZo6VQWrFxON6f4A60vmBvvJWBP7yeOfEhHm6+enA7zR
	 5+8oou/1UJFxgoVbvH6Gm+5GZw0Crq5dBu/hEmLy1BLSsR6wM9kUBlWoLjUXidPRan
	 sgp66J7A8QPaw==
Date: Tue, 29 Sep 2026 14:30:35 +0100
From: Harry Yoo <harry@kernel.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R . Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Maarten Lankhorst <dev@lankhorst.se>, Maxime Ripard <mripard@kernel.org>, 
	Natalie Vock <nat@pixelcluster.dev>, Tejun Heo <tj@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Oscar Salvador <osalvador@suse.de>, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v6 RESEND 1/5] mm/memcontrol: flatten try_charge_memcg
 control flow
Message-ID: <aru8sLRda2q3DMoF@thinkstation>
References: <20260928192349.3432886-1-joshua.hahnjy@gmail.com>
 <20260928192349.3432886-2-joshua.hahnjy@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260928192349.3432886-2-joshua.hahnjy@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 67FD4140004
X-Stat-Signature: jccqy9iba89iosbigu1865ucm6pe8wnd
X-Rspam-User: 
X-HE-Tag: 1790688639-369788
X-HE-Meta: U2FsdGVkX18Izcz9y51Gwilu5ztI0nbMcXPgJRlXX7knXjgJuYVdp+1jfiL4L/wO/3mfRKd20CVJgV3VD7qXSFRRA0aGKZLtncNB8jFJnw7MpU32gGzxACwQyFznRDxoMBQDCc0tpiI9HUQLnb+VpIDbGzvCG25VAx5NIR9BGQkCRK2WRUqB2jjU7TU+dlmeUEnzoDIbxCcgrZjzfabLgMLFhZDM7YjTmSFDVus8DHQQgkC2gdr6M91PpN/Sjma2exEzgRlzvRD2wn0RM1KF7YiuZ0muLrn/Jp1jVcxSV6DRZ+15SWkCZBJfb+hUd6cW/GNiOiIS8YRgGbeFktl10zvZNh39WHPhKYE3LGOT58tApQiNBUcj2t7vEq7Ah9zCPbNx+7W9Dv22KbwT1+gs+QNf40VxcXpl0FPSyVkHhRdzU0ndXvv1cdpwTNL0+wkEJvir4ZFtaTXLBQwvpksAmSaoOZAXENqLcgVa7xzTDkeSHhz0SlIa9Ou73K08rqZDECqBgVRDS56RTzo9s/KRGTy3D3cxlDQGp5vPro4GO0tPd5mkquiolBm9FLbxJsQtJcKRJ3KlnS8hxSOGWTcGXA9OYJxN+wjIyGW2gd/vJLTmdwLYHucMbnPK/jN2PgmjQ7GIxLGHpxBJ3kEAHmpSELxoQeOlAJln8T3gozGAQK9nfEb5KcAqNsgiHVVN66uEpyLCk6oDLhtCDYT5ikM/4LWh7AImtCFTc2GQmBJbG15R7wiM+Oy0QidPoRgpt1fEnnm/xLLYQ2ER2sHAQSL5q4yTZ6w1UfD/9ajV/UhanlucBlNsSUzzRsDV6k6tLFCbMZlAV9VQMjFTA5m048H7RJzBSDrlnnyQN/TAuyGPV3/8IROhX3NwzmpjMvb4gDLBuGzfynA7mg5IOZDpRtqEhGAA97EcWuzegsDDt/WO3wypE2jj45QpthsjYawC0jXFomt1ZAnK5+FfYAP311T
 +3Ss9DzX
 jMvQYtL6xRXkZePjfwcPDLIGrt6K1/aHo1NxtjM6mDG1CsVzl1aZRA9O0jeTOrHeXD9N9b7O0Fe1Hcirq4S+PacAdNRarcRi36BrUxtNjTwX6UqHub8iNbREnqItcdvZ8n15UrbAfw+T119cLxpqY32rF/OUgfH6dVGzMh0BvP1jXPxRjalgGDEzPTKcvXg9fQrrXoPh7dXLpXcEV5zDoVWu8lz+l08T9MFfWXHKb423e2vqa+A19cehIj0eoNPUQ0WkpqC1HmZK2zcFxUxns3S+6M+d9xI/z+FyP8UQzbHmUFrMcdHyGyOQ6v40t6sbTy80f4cCJAXdwn9vlnhsyYvd3fxoyMZW0/gs/RVQQ37wj3XXNVtDHJ+cgaCje+aEr1RIvDeNK2hcjKRd/Y+kiUj0dVSe9lzKeOYFrKRts7nPCm/Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 12:23:44PM -0700, Joshua Hahn wrote:
> Refactor try_charge_memcg by flattening the nested memsw/memory
> page_counter operations to separate the logic between the two.
> 
> When page_counter_try_charge is made stock-aware, this flattening makes
> the control flow easier to follow since each page counter now has its
> own success/failure paths.
> 
> No functional changes intended.
> 
> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Signed-off-by: Joshua Hahn <joshua.hahnjy@gmail.com>
> ---

Looks good to me,
Reviewed-by: Harry Yoo (Meta) <harry@kernel.org>

-- 
Cheers,
Harry / Hyeonggon

