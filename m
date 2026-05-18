Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BA3CCD4F4A
	for <linux-mm@archiver.kernel.org>; Mon, 18 May 2026 20:48:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A84F6B0005; Mon, 18 May 2026 16:48:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 559F36B0088; Mon, 18 May 2026 16:48:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 447E56B008C; Mon, 18 May 2026 16:48:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3108E6B0005
	for <linux-mm@kvack.org>; Mon, 18 May 2026 16:48:16 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BDAA81C1DEA
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:48:15 +0000 (UTC)
X-FDA: 84781728150.20.F94E267
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 044BC100013
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:48:13 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MJ0cLJF5;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779137294;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=70JQunruUP5e/B0lx6JS7vQ+cSo7OY5copkWModJtoE=;
	b=QnmxGSq/yO4oo9a/eUjT/9Q/rLj0yDauoMyICSwd8dteHc26wU71onmZLPZfHd/SdRcRon
	3YAIjpg1uIBttWMUqAW8j5UY1Kxh2dQ3CVTiO0pexitTZ8HXCZm0f7c467jf6mfRhZpxnO
	W4fqrijkVAQq4kG5m3Fi4ZPDTPQduLM=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=MJ0cLJF5;
	spf=pass (imf14.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779137294; a=rsa-sha256;
	cv=none;
	b=8TKMUYjk/QMDYM+irCiIbY2HvQQwywl29p3IMk/aRMXznGTvEVEPezb1CfKMGPRGTuCWcG
	ZzoM8zwrUiBAOYdaEwrATeR3tVhGtJepzJu0XCtOUhK5u5h1dV8CCMAzXrDBC2GQMbNpyP
	1iMWYz9fXwjI8x9srvVJMbQbPI0S5LQ=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id ED93E43219;
	Mon, 18 May 2026 20:48:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28FEEC2BCB7;
	Mon, 18 May 2026 20:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1779137292;
	bh=joOMMQqoY4Hed3o1XhdUg7enY/Eja9HeFgHFbnxcITM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=MJ0cLJF5aYkDaqqzxdWy6a1/DIGaVrLWBa8/saU8TVHuH9TdrDfQ59X7DjpKIxocu
	 /gQPf2Edx3J8qC5b6Ywu0O5JMERUiALwA3u/sngIXYvfkNWHjuq8QwM0Hqhbb6orMN
	 1aFnwN9w+pLS5AIRoKNiJMGcVQCupJ39i7dVlSlk=
Date: Mon, 18 May 2026 13:48:11 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Brendan Jackman <jackmanb@google.com>
Cc: Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, Shakeel
 Butt <shakeel.butt@linux.dev>, Barry Song <baohua@kernel.org>, Axel
 Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei
 Xu <weixugc@google.com>, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>, Pavel Machek <pavel@kernel.org>,
 Len Brown <lenb@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan
 <ziy@nvidia.com>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>,
 <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 0/4] mm: misc cleanups from __GFP_UNMAPPED series
Message-Id: <20260518134811.b2b78352779d7519e8123597@linux-foundation.org>
In-Reply-To: <DIM2YAI5ORUU.2YLTV7PWKE516@google.com>
References: <20260513-page_alloc-unmapped-prep-v1-0-dacdf5402be8@google.com>
	<20260518111546.3baebae99dc3f2a4fd65e605@linux-foundation.org>
	<DIM2YAI5ORUU.2YLTV7PWKE516@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 044BC100013
X-Rspamd-Server: rspam06
X-Stat-Signature: s41p4wz1xquwgdjnawzbph1tmcyw8xnw
X-HE-Tag: 1779137293-267614
X-HE-Meta: U2FsdGVkX1+Qd5gOv/DpSRnDzKCpTQG9/lZGsIXNIIK1s5RRWTVRWmPkUc1O4moI6E5BB7RCd4Gco3jBLsiQQEIeToNRMcyBd4gKoKw0TdpK25VvIgp+huo7N8YEv+XHQw0zb689DHYBp8RpxDSjasdKkT421s1E5Vkso/gj3dInpqcCEYyuHzviojJgM5I52LtuPiv6f0GsWkTkfPpTmpF+VejTipBuo0HmSO8Uwv3ujyCTsXPerE6OQ11hliNOJpSL5ssnUqgDRYE1RSP1ygvvGKhZcStG1mlBiz9ViF2E5Kr99Ydic6WPdD8uFQaRR7EJuunuzlOsSD26ygtvAHG77T/nBTNLZmDzGnwgG90PJrLlpWDVNRORvlDZ4U8Z+KuRZxCiIdn26bsGYwWRfje8fqeVXtPCz1uUWZhphpBt4W8io8hijBZYc4Tp7HES4qVAJxzXI/Pfxky/xkxB7YwFIvKNldQNwTj4x4Hw6iEVVVvOLyJmFsNAm7AxuIuWksh4b2LKN7nX4bTpJ66Fc/zB4l820arRoLNbXF+a1hM9FgSt1GCaSIYbL1KDoC/FHq0vEzGByfqifh3tsQIfafnvuypOWCMF8NUsJMbOBcDvX/OwJKSipSHDXCI63XcldJ3l9HfRgT7z1Gq+qao0lWaViNG3COnk9zDihWmc3ksMtgYaSFW4sE7Ve82HtTdCzZHiz09+uaIUNzGvO5FOVi8dTmV7PrdOg3h7ZrPVk56PNXRUiUp7K9aNntMMYJEnXJuKflfbrsg+CmhsEhoS2FPSfjIGG/Yt/gdGkNlt+9cdY3kwrIdi11CBKX5JgLUbJy/pvyYbyGS2cNBJflDXva2Abww00D+PLjWlYM28FiRP1vI+qJ8DGmt4gCWCJ8tz+r7nJgUKiuZescM0B7D14xgyaKpNYtQ4HLL798km/AEiQyJD0/JoLlu6KBhMCJAzGWq0w9Oao0x0glpf6w6
 L7gfBrgC
 HqxDY/H7QG/iXot9w6Ubs/rx9CPbe8+llt0fDFwXw0Yz+bfej2o8lw+jHGPv+U2/CmPrEt4J0WVW7SVqODLPKR4ZXePBr+udD4tNdI01SPkHhhaK20mjPU6wFs8OZO9l5m4m+JBg5+xsFla7x3+igIqUX9mLD1BEsey6gJJrkklnKW9khD/AjfylUN/EvIVc5bh2Xj9cWaw7ClFNUQ+jbLzxsh19G4CnsGYnNkr8tWrpCnuuilZsNlbXgBEIx4qGMeWto7OJThn4IPMEZ7yPH5lUN49+GVR76NZLLE8VFDK8l0jje/J8N0ll+gLw1thCk9Ibi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 20:20:50 +0000 Brendan Jackman <jackmanb@google.com> wrote:

> On Mon May 18, 2026 at 6:15 PM UTC, Andrew Morton wrote:
> > On Wed, 13 May 2026 12:35:12 +0000 Brendan Jackman <jackmanb@google.com> wrote:
> >
> >> In v2 of the __GFP_UNMAPPED series [0], we realised that some of the patches
> >> could potentially be merged as independent cleanups.
> >> 
> >> These are all independent of one another, if you think some are useful
> >> cleanups and others are pointless churn, it should be fine to just pick
> >> whatever subset you prefer.
> >> 
> >> No functional change intended.
> >
> > Thanks, Brendan.  I added this to mm.git's mm-new branch for testing,
> > along with a note that [4/4] may be getting an update arising from
> > Vlastimil's feedback.
> 
> Cool thanks, (also I got the "added to mm-new branch notification" and
> realised why I missed it last time, broken mail filter).
> 
> The 4/4 update is already up, in reply to the thread.

Is that "mm/page_alloc: tidy up pindex helpers"?

For some reason I didn't receive that email, directly or via any
mailing list.  I do have the similar "mm/page_alloc: remove ifdefs from
pindex helpers" from May 13.

Oh well, please check tomorrow's mm.git and send along whatever is
needed?

