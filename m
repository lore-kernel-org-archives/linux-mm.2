Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC75ED77899
	for <linux-mm@archiver.kernel.org>; Fri, 23 Jan 2026 17:45:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D2F156B0520; Fri, 23 Jan 2026 12:45:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D06CB6B0522; Fri, 23 Jan 2026 12:45:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C32E26B0523; Fri, 23 Jan 2026 12:45:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B30DE6B0520
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 12:45:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5C607D3446
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:45:09 +0000 (UTC)
X-FDA: 84363954738.01.F2F4928
Received: from relay.hostedemail.com (unirelay02 [10.200.18.65])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9086040009
	for <linux-mm@kvack.org>; Fri, 23 Jan 2026 17:45:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769190307;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AZP786ZgVnhamB4OdzcrZmWyH7YCAT76LUfmJKvUIa0=;
	b=sciXddXimZO9E4MWizB6BavbvRzesGauCLdHiKhSRuugMJZbBADVIspJ2xiImUWDCZvYRW
	IW45FL+xk2e6i47jTuOTZ9MxTs5LXWSNLj8IjGo15u/j5xvLMl0UbNqU9FJTrEf9ypH5B6
	vZo8M4SjPXG+X6qhlywBmVbhaa9rS7Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769190307; a=rsa-sha256;
	cv=none;
	b=QOMp9wHpQ7ASAodzNqAvCc+OCIqGmTdHQf7xBLfCeysFPOl6D39ln2uvMQofeITXOZTIny
	i0DKLzvoLld5+pT7gQc1ILH5zEGMnRSE1cH9kShIS79n7qA6tRotD/wE4geRR/6A3Ukkn+
	gA6za9hKjnsOBc3JjGp08C6CwRtPlls=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	none
Received: from omf10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 7453E13B16D;
	Fri, 23 Jan 2026 17:45:04 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: rostedt@goodmis.org) by omf10.hostedemail.com (Postfix) with ESMTPA id E42D330;
	Fri, 23 Jan 2026 17:44:59 +0000 (UTC)
Date: Fri, 23 Jan 2026 12:45:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jiayuan Chen <jiayuan.chen@linux.dev>
Cc: linux-mm@kvack.org, Jiayuan Chen <jiayuan.chen@shopee.com>, Shakeel Butt
 <shakeel.butt@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Andrew
 Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R. Howlett"
 <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport
 <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko
 <mhocko@suse.com>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Masami Hiramatsu
 <mhiramat@kernel.org>, Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
 Brendan Jackman <jackmanb@google.com>, Zi Yan <ziy@nvidia.com>, Qi Zheng
 <zhengqi.arch@bytedance.com>, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org
Subject: Re: [PATCH v4 2/2] mm/vmscan: add tracepoint and reason for
 kswapd_failures reset
Message-ID: <20260123124528.3d118cca@gandalf.local.home>
In-Reply-To: <20260120024402.387576-3-jiayuan.chen@linux.dev>
References: <20260120024402.387576-1-jiayuan.chen@linux.dev>
	<20260120024402.387576-3-jiayuan.chen@linux.dev>
X-Mailer: Claws Mail 3.20.0git84 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable
X-Session-Marker: 726F737465647440676F6F646D69732E6F7267
X-Session-ID: U2FsdGVkX18JXD2BXE3/gdW7HdTzbiyh3DXw65GaDyQ=
X-HE-Meta: U2FsdGVkX1/k0WOEjxuFlRjyrwM6ArGM7a37Fl64pCJk2GzPiMBmWsuXF8UK0DlA5h/C4mbQxdjBen0JUgQuQao39sP24WpFDoBSjXmo/ltdziwlBwEPBoXNkNV6agREqWfVHY4r2XGIzJMvf1rFArbAoTfyZbxs0LSj8jqtS2NKl1ew4vMM1Se1Ms5XvCZfSSisMN45JE9yGe0aBvnrMpOd0h6JAvSpmNKxOojpvrRHYWSvO4GQIPdin/aNhQ6WYvW0juG7STJpsJpOsK01MgaRr5by5kQ+a5mJaCpEitupsDHW+FJoJg4T2q1JpebOUfzJHoLi2lE7o561rmCIt2Ciko0EviKmKneUaumyl1OiQkvtF7WfCNC+Sn7sERm/+Ijcdoxbsf3QNEdovYnnO4MNaS2hHI13YUGg0GTQ0Ac9aAbHgv7BtvpSr25U367DPLTn9zGREABwH9XsaFB4T4cUgPJKkm6IjHyPH1c4BnCoMcYoMx5Vuw==
X-Rspamd-Queue-Id: 9086040009
X-HE-Tag-Orig: 1769190299-137174
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: q4zhqppw5gjibr9p9yjxnf81j4335nkf
X-HE-Tag: 1769190307-867375
X-HE-Meta: U2FsdGVkX1/bDC0pQ7xpdnGasmFGSiuLEEVl3NJ5Z+Ar/4WrsN3wBtUbmQBCSdNZ/4+CuvQ6WhmW1L4m3l1TBHQxCnkM5p2fppnTENoh1GuUKirn+zUfkklNsfIZEO6+LQpvF4nobacJdRdc3ZZyIGJl2pe8VhuM5m5ULu4YCD04F5hJ+vZawZK9TOKWgjTOBWrOc4YunaXbrxlN9LCS9UNoDIrp9mm5QUAMZ1g7qEJr3cdU/rlcv0eRSHPRxOfLhYe8xqz1t9s0OSZWSxm0Y/Fx8tRqq78e+CFUMblUpqnVFAM6yzLqK3dvRG29rhJmVx+pU7i0I9vf29CojeF1fhlXxWqdw5yNdqIxzTeAEDD1r7LF8rF7aaG/fg1YyX4qm/wBfCS3plb2et4dyHJuVytJAZ4x2V8IsnONOxOySANagrM6Udi1hhM5qG/v4M0xpf3gwl+Lb87Dl1uFU2NUteSTr6zRl7vzWjQWy8gzXpGPkiuQrXlnupvj7woC1j77QWPHP4mw6+cF8+/fvLEMAPkQzWZdx9/8apNvaXQm/K6DCnUwtX6KITgOfuVOBWLdkJ/OOjaRtQ+dx2h7+mMC8ZB//2GPQgntMmJt1gNZMfN9BFBpJ3cNnk945jnF3Fo1nKXHFukHMXOXTLnpHPdGcH3FLbgtKitqQ42EeE8HjrniU4305th9KpYDnPro49uYB+Zc3Vqs1E90p4lc0BzWqEyDWHnGFbfmq+cqyskuKvLW/zZsL/kg8N75A9q3PmYTFlp0oWotkoT6fQKoWGls984F8Zf4FlyVpCKmksIp89ccaOfdQb8XE5fwhQjakLlghropSyJ1fB/3lsogAwi6trGW5yOpTae2u2v4Vuahq94nVJYDJ8C/twNOGc7uo9Gj1ZNz37goH8tnYMfozVupEjaYqSbiZUPAvHj0V+ZTsdqsjRCOYkBI4zHcKZ70u1D+ZvElWitdhH/zh4B32wW
 41Gf2e0z
 J0WuFnj+r59Nc2IoRBIP5ZNMTT3hx7CLNFbH+miXy23NJfNM0sYu3gHryUY8sjwmLTMnX/DEGmcyIV9BCnmGBaNp4fLA5iklVGalGFA3eOdYSW5vg83l6FOPEpFZhoBohb0CiDWxqutEbdseZgz9ch/iqLVDLLM3bzkoU
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 20 Jan 2026 10:43:49 +0800
Jiayuan Chen <jiayuan.chen@linux.dev> wrote:

> Acked-by: Shakeel Butt <shakeel.butt@linux.dev>
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
> Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
> ---
>  include/linux/mmzone.h        | 19 ++++++++++---
>  include/trace/events/vmscan.h | 51 +++++++++++++++++++++++++++++++++++
>  mm/memory-tiers.c             |  2 +-
>  mm/page_alloc.c               |  4 +--
>  mm/show_mem.c                 |  3 +--
>  mm/vmscan.c                   | 29 +++++++++++++-------
>  mm/vmstat.c                   |  2 +-
>  7 files changed, 91 insertions(+), 19 deletions(-)

=46rom a tracing POV:

Reviewed-by: Steven Rostedt (Google) <rostedt@goodmis.org>

-- Steve

