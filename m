Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4F3BACD98F0
	for <linux-mm@archiver.kernel.org>; Thu, 18 Jun 2026 08:25:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 409E96B0088; Thu, 18 Jun 2026 04:25:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BA396B0092; Thu, 18 Jun 2026 04:25:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2D1846B00AB; Thu, 18 Jun 2026 04:25:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 09FA86B0088
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 04:25:36 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id F0A261C4956
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:08:09 +0000 (UTC)
X-FDA: 84892305498.03.5C4203A
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf08.hostedemail.com (Postfix) with ESMTP id 15EEE160007
	for <linux-mm@kvack.org>; Thu, 18 Jun 2026 08:08:07 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SXq+fbg1;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781770088;
	b=Wxdh75gNkdmuHUxctbEsuG6mqpqUYDytCE+C3AL3BipW9/tGhqpQsXHUWPfSKxEX0AOuaQ
	b6YjVt4wVGEmKQA823JIeMQ4AzsUgI9R+UPgxGzegrO4ITZddUJq61OFoLKVVQ6zqtIdCM
	gxQNGI/XeIjNG3LYqtc1uPM1AUHqPNA=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=SXq+fbg1;
	spf=pass (imf08.hostedemail.com: domain of hao.li@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781770088;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jkAOAOVNxrErE4lST04O8nu7mROfXmewRbNfCGnfWZY=;
	b=i4Ahq3RktwwX49OODLf1EPQKL/5g4/5QCXGySP6rhleISVmSNWxPu2icJ7LEnhrDYuQ8go
	Q9J6NxtBx9BblVniMnnQldu0K5EPBfX/yie5clb/+WgbZSIcFl615LJRFYlu6Wa8lcte0f
	m7CCc4s+e4wkDzi79Sj/3sbKOH321o0=
Date: Thu, 18 Jun 2026 16:07:31 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781770085;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=jkAOAOVNxrErE4lST04O8nu7mROfXmewRbNfCGnfWZY=;
	b=SXq+fbg1e/awOwIfamMM8xAxZL4FJQG9plaLKuhBgI+yWitVniATtbZzuyg/T1iJ3yk+DR
	PNP66JRqv9chFFiWNT+q8H7AihMZ1MkYxcdCYjjd5vetTaM6A+7mJ+M7y5R1E+NOpd6D9Q
	mLmO259d2XIbkbqfb03u0Z0gyrcwjJc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
	David Rientjes <rientjes@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Suren Baghdasaryan <surenb@google.com>, Alexei Starovoitov <ast@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, kasan-dev@googlegroups.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Subject: Re: [PATCH v3 08/15] mm/slab: pass alloc_flags through
 slab_post_alloc_hook() chain
Message-ID: <ajOnBoyl0aabL854@fedora>
References: <20260615-slab_alloc_flags-v3-0-ce1146d140fb@kernel.org>
 <20260615-slab_alloc_flags-v3-8-ce1146d140fb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260615-slab_alloc_flags-v3-8-ce1146d140fb@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 15EEE160007
X-Rspam-User: 
X-Stat-Signature: o6cehsz4mc8gmnprhrkdt15ny85hiibg
X-HE-Tag: 1781770087-281528
X-HE-Meta: U2FsdGVkX1/9WJErOp4CiTIN2BKuruRiAXM/YtdQ/Y0GAzlhDVz8hFitrf6S7dn/IiNFWFSiKnk4FYCo3gTkSZ4QOHbKpWuhoPWYd7Tjgq1Z5W5PK1tJZy60qDHGgGOZr6u3JoihZxSA0HcUTQSrosHqZM586xDJOD0j16tZtf0zkK98Qia1lKvCoiBRGaIQRRjekyfMSyS7rD+T93mpPnKGxrb38QsGtcsY6KWjKetb4St1vx7ZO0vNqm9pYvVnhcZo66Qpc1DeMvzq6+jL84wi6kycmugdbzsmUh6fb1GvttxsHdfq/M1EXWoJyHJzZTzAppipvUReyLBXXKInzolOViAIuAhKHoP++45H11ounXXmjqiRm+ZTNpV5lH6CjT5BG9yxx4ZeNkarpP3swl1wt6b8HXvEfL2m+K4hCE/cDM+oa9e553IWbHU//26DTVA2lMSfNXGkTZhHglTD1CNimGdff80OxxxbLLxJ+K4T1EwbA2W1fWxlWuWAcackGhk0CGQi8cAKH0yf2ygKJiYS4PN4ri3O1lURvy25WpPjnKjzW6U1ugg2NnrPoGROanFOMH/r9riwy9rltlWxvR2fKoHYfw1OA+TrgwHiavkRWLzIPZ9A+cnHB6FZu6NrOfUyElk+m8T3Q8yeplp6erSL+RqKjWUAlMugz3NuOH1UTecSd2vYASry339/dzGyGWOaxKJ4prqkwLE8Ay6XILctdgys8wv0oKcoK6Q8HUbHm+/bPdWo8YAdZxIPDpltBgsQCq+fjcJYMqSz7ztOwC6h2PCDeNdo6GSLYjlhMFBf0YIEW9RXaG6m8fwo9TU9RVSF62xbJH6tipakjBKskUa9Bdk6wC9IynJbpls9ZQblloHd78CQBYApTPBGjgPsAysB94ynnkjoqWdsSmN2nRS6gk6XdSN9ZGQUVZaqg8E3LLKqm8QS9r8GNsEytTrLv3mi8URvjmMB7tpm7Cb
 KbF5+pwK
 wIr7XLG3Z915xI+X9dplZkF3n7h6TQHYZNeDo4b0S7dme+hZ5EML2JngAh2cINo7Hz9dhRM/E6d+n8gYg1+S2fgyoyMFBxrUxS8b/ktKKS8uFMbPKW4BV8zZRDT26MBF8LA0rg05Nc+ilUoN3gvyXeNlpqLCasXZVRgN0x/nBxVeg3f5zVPMoRQ/rd2y4Tiv/PJ3PA+6Js9phvTC/poeDG3P4Q7mwwv1Q7/G3FTSuBH3gSMo+Zwi/5GSgeQafZbZgbP3a4wXM4oBz8L8L+NdZAYB49dNVM2EwOtUlwXmRi1rZAb9YFZ68cHjfe0YkMQBDJPnSZBodNyJq+WF9N5v6ITUsLrDct1KWJL9pvYrq4oMEUbY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 15, 2026 at 01:54:41PM +0200, Vlastimil Babka (SUSE) wrote:
> Convert the whole following call stack to pass either slab_alloc_context
> (thus including alloc_flags) or just alloc_flags as necessary:
> 
> slab_post_alloc_hook()
>   alloc_tagging_slab_alloc_hook()
>     __alloc_tagging_slab_alloc_hook()
>       prepare_slab_obj_exts_hook()
>         alloc_slab_obj_exts()
>   memcg_slab_post_alloc_hook()
>     __memcg_slab_post_alloc_hook()
>       alloc_slab_obj_exts()
> 
> Converting all these at once avoids unnecessary churn and is mostly
> mechanical.
> 
> This ultimately allows to decide if spinning is allowed using
> alloc_flags in alloc_slab_obj_exts(), as well as slab_post_alloc_hook().
> Aside from alloc_from_pcs_bulk() (to be handled next) there is nothing
> else in slab itself relying on gfpflags_allow_spinning() which can
> be false even if not called from kmalloc_nolock().
> 
> A followup change will also use the alloc_flags availability in the call
> stack above to remove the __GFP_NO_OBJ_EXT flag.
> 
> For alloc_slab_obj_exts(), also replace the suboptimal "bool new_slab"
> parameter with a SLAB_ALLOC_NEW_SLAB flag with identical functionality.
> 
> To further reduce the number of parameters of slab_post_alloc_hook(),
> also make 'struct list_lru *lru' (which is NULL for most callers) a new
> field of slab_alloc_context.
> 
> Link: https://patch.msgid.link/20260610-slab_alloc_flags-v2-9-7190909db118@kernel.org
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
> ---

Looks good to me.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

