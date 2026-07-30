Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0B1B3C55162
	for <linux-mm@archiver.kernel.org>; Thu, 30 Jul 2026 11:43:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 024696B008A; Thu, 30 Jul 2026 07:43:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F17B16B008C; Thu, 30 Jul 2026 07:43:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2E866B0099; Thu, 30 Jul 2026 07:43:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id BF13C6B008A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 07:43:12 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 554751C0029
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:43:12 +0000 (UTC)
X-FDA: 85045257024.14.A0C6CA0
Received: from out-183.mta1.migadu.com (out-183.mta1.migadu.com [95.215.58.183])
	by imf20.hostedemail.com (Postfix) with ESMTP id A03341C000A
	for <linux-mm@kvack.org>; Thu, 30 Jul 2026 11:43:10 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="C/siyrsm";
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785411790;
	b=77zJsaqFDZJJbifOILeJ7K7gCuN7Z2wEB4XLxWWgz+mzg5EndbeTit6haQS9XDbDD95I+T
	OcLuz3WMC6Ev4ZRn9ZIJeJ4jOGTFRJCqMR0MyMGfS7Kr6tF8G0PaMJ4+sdMQIBQPkJQkMS
	vVQg4O8xob9GZhE6+IBzIrNdaQB7KTo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="C/siyrsm";
	spf=pass (imf20.hostedemail.com: domain of hao.li@linux.dev designates 95.215.58.183 as permitted sender) smtp.mailfrom=hao.li@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785411790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lTqFA7K6MPk5apzin5nmxQMjq9hPrkBYRMuS0oyOFec=;
	b=yZGW2Mjgb3gYRslxoQv4o19MdH1b/9lcVf4Y0Youc12eHFx7+cgVG9sRZLiSzA8+jGJ6bl
	g2z0oQzaG0qRdlE4Z3KiAhlZ8VOLSTGAIwrt3ZormxcMFLAHl2m+QWzYTQ9Gecj1XKZbPD
	A8cuHmk9sL10Z6yn+3O4Npgjn9gRwTk=
Date: Thu, 30 Jul 2026 19:42:39 +0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1785411788;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lTqFA7K6MPk5apzin5nmxQMjq9hPrkBYRMuS0oyOFec=;
	b=C/siyrsma3utDpfgdIXQWOQSCVE5HOZxSBg7SL58NypteKUNQgGSivRAcdNxR+MAV9mb0i
	jA9bgnQhSoVJHMgVvznfvdgEr1KpaxmQQA/nazLq58jI6djhPEcGu0n5DQGR8DweYbvuCk
	EJRRztuscKB/3kVpvRbH0h/I1eQpqTo=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Hao Li <hao.li@linux.dev>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Harry Yoo <harry@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Alexander Potapenko <glider@google.com>, 
	Marco Elver <elver@google.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org
Subject: Re: [PATCH v3 09/13] mm/slab: introduce slab_obj_ext_has_codetag()
Message-ID: <ams4ndW0HZGjhODA@fedora>
References: <20260727-b4-objext_split-v3-0-c29ef0f1f257@kernel.org>
 <20260727-b4-objext_split-v3-9-c29ef0f1f257@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260727-b4-objext_split-v3-9-c29ef0f1f257@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: f7nu85jq5xg5sy4rqod6oqkk67ifcwf9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: A03341C000A
X-Rspam-User: 
X-HE-Tag: 1785411790-254195
X-HE-Meta: U2FsdGVkX1/qTS/X94UArSDrf2F+IAEYWdiZxXuRt46uc9X0T18lZ3URrZhTGSACoV6D/LMNlqzyMlI0D62HFJLW+tih2JRCZBpBjxcPJ/OvnmsEDgist/eofsYSo/51Bgxfho5xFKvBk2O1ZZyyeUg/DqhKpedDjXbzEjghAx3IPUp0eo2ee9c8emw2gndoiIuGcPHke95ZyRRhDXdkd7sx74ebYERjwT/rnEA6Gfqjy3lgstzXA9BkINxFAjEE0s7OPG1Cikt3lBJX/t98N5lMPk5AoVjbohfaMM2xnlHyXP+YexFbtuYXWf3EWmGoldBSPspByfnUQXDW9MTR6FS9tO/p1PHR2GHLBZDktyBJ9w8WUr5k3FwhfkiZG+dnh9+r3Qow48yz5vxVzOBn3/+RHwLXuOjMecm6C07qXjRlSsZCZl/vcNp48n8Z9xFSYJvGcyCrmptiekZLVM/HwMbTpCjPo2a67rqD4mEY39hMcyCQY9cg2tKjcLNmiHrdOBWTY8t1Uz4yEolTlejzwalPtyVo7wSCG/Dl+7pUnQI258xmnMyJn3pn/nX+BNriNAMceEX5yoE6il8CRJjOf8rWM/Uain/keLrYYA6/WRqbz4yZRhmmZEL+EB72tN83XnudqZA8p6sa8DfaeCT7KMo1vXPTTDiyaibFL3VDDNhWWNUzxUCKAzWaI97uD6GEqbWgzXmn/jTaIdsU0bgrmAwB9ADojzb73iEMlV7JrUo2bDhuTPVriYL2dUrvMIvjIK9M9trHp4oAYqt/R1ah6b85quiPmEFmdJhavRgz01SxKfKU0gP+KOb0YE9cKBoiJCx3qNK6yfWJg27c3aIsHSW9tPtJq9n1XpyosmJ0bcgpC5Eu5YjGgcJTQZAwvtqoi+cqSi4OUVbt7ytd9wiVjsJLvWJOsCkh5YEogpBlRrj7w1c9l1mJkiuLIROthgVT3kh8gpGQO6zIzS+ha0c
 1lImPFA9
 TFF1c4uFFycLQYwsj1dxh45JH5vkrp+wkqE88iJGhwQ28rzJMpr3EaRJUxncLDwaexcf94QRFcV4YjskEi/O8yh37pe1dyEuiMhc/b7s2FPQJkv/DUNgCh4xtkgLGZaiii+xaYFKys33FlAjK1reY+xpmQOBJVVElwdY5RP3AXx3yppN6Z8otKFPkw3ywydO1V3UPSPYdxoeHPOOZfuA+sXKV0FE62Bp9S7YjIbIZHsg0rum3lbfDRphL/NWyQmNjig985KwSkqP7GzMqQqz80M47wgsQ7TUXsm7p87O2jQXF7Uc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 27, 2026 at 02:54:03PM +0200, Vlastimil Babka (SUSE) wrote:
> mem_alloc_profiling_enabled() allows evaluating (with a static key) if
> memory profiling is currently enabled. mem_profiling_support is a
> variable where false means it's not possible to enable it anymore,
> because the system was booted with "never" or it was later shut down.
> This is possible to query by mem_alloc_profiling_permanently_disabled().
> 
> To make slabobj_ext array size handling dynamic, we need a snapshot of
> mem_alloc_profiling_permanently_disabled() early in boot, so that's not
> affected by a later shutdown. We also need it to be static key based for
> performance. Neither mem_alloc_profiling_enabled() nor
> mem_alloc_profiling_permanently_disabled() satisfy this.
> 
> Therefore introduce slab_obj_ext_has_codetag() with an underlying static
> key for that use case. Its state is made to reflect the result of
> mem_alloc_profiling_permanently_disabled() during kmem_cache_init(),
> which does happen after setup_early_mem_profiling().
> 
> Reviewed-by: Suren Baghdasaryan <surenb@google.com>
> Signed-off-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>

LGTM.
Reviewed-by: Hao Li <hao.li@linux.dev>

-- 
Thanks,
Hao

