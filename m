Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EC450CF45CF
	for <linux-mm@archiver.kernel.org>; Mon, 12 Jan 2026 21:22:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 410656B0092; Mon, 12 Jan 2026 16:22:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3BE226B0093; Mon, 12 Jan 2026 16:22:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2BD606B0095; Mon, 12 Jan 2026 16:22:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 17F726B0092
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 16:22:21 -0500 (EST)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id C151AD2393
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:22:20 +0000 (UTC)
X-FDA: 84324585240.27.742ABD9
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4E539A0011
	for <linux-mm@kvack.org>; Mon, 12 Jan 2026 21:22:19 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VkBPeIk5;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768252939;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J3VMesCThZ1UWC5jU0M9fsUjdYd6KTqtAF/dzXL2hyY=;
	b=plxicWKf4gD0FTrezKNdugajjgamMhJDS7VhHNn8h6tOr1Q9VDFJd9/t3C8cBzpR2aIpLA
	yINz+xYTWNtlsRs7NLrkuThs4UwZjI+OWEnBvBq7Rrq5je9xpjmxPspwf0igCcuFA3aCGS
	zyBQWRMNCCSWMP4XgeSI8FM4lqfrcW4=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=VkBPeIk5;
	spf=pass (imf25.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768252939; a=rsa-sha256;
	cv=none;
	b=YpYGaEDK3D5gTfaXBqLkkCf8yKhk76YUTzE+bgidZkie9oML8UWp122UKItwCPbaZh5nLL
	k3IdTN+FYVbJmCy9y6Y47HKqcjA1YpYa5yfubu1b0eLYvTqk06dODow9Jr+Wuzub/tVMvS
	sB9rhTeEcbcYP+E2hfQHRmtCofUO4zU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 9D8BC60017;
	Mon, 12 Jan 2026 21:22:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4105EC116D0;
	Mon, 12 Jan 2026 21:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1768252938;
	bh=J3VMesCThZ1UWC5jU0M9fsUjdYd6KTqtAF/dzXL2hyY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VkBPeIk5hnPI1Byvct97SYuIWm1QwmI6SaiV8Vx+6cunuESwapg0u70Kja7HHSdoV
	 hoo3ndhtalp7KValVIHZ9iCFzOIir7VpqtW5W/h5Ulf6DyVfK8fz5KQzVtUkPuXaEj
	 TJlNZtRMJJkAOjQz3jyvMdLqD+y59sTiLRwUsaA0=
Date: Mon, 12 Jan 2026 13:22:16 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: linux-kernel@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
 Steven Rostedt <rostedt@goodmis.org>, Masami Hiramatsu
 <mhiramat@kernel.org>, Dennis Zhou <dennis@kernel.org>, Tejun Heo
 <tj@kernel.org>, Christoph Lameter <cl@linux.com>, Martin Liu
 <liumartin@google.com>, David Rientjes <rientjes@google.com>,
 christian.koenig@amd.com, Shakeel Butt <shakeel.butt@linux.dev>, SeongJae
 Park <sj@kernel.org>, Michal Hocko <mhocko@suse.com>, Johannes Weiner
 <hannes@cmpxchg.org>, Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, "Liam R . Howlett"
 <liam.howlett@oracle.com>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Vlastimil Babka <vbabka@suse.cz>,
 Christian Brauner <brauner@kernel.org>, Wei Yang
 <richard.weiyang@gmail.com>, David Hildenbrand <david@redhat.com>, Miaohe
 Lin <linmiaohe@huawei.com>, Al Viro <viro@zeniv.linux.org.uk>,
 linux-mm@kvack.org, linux-trace-kernel@vger.kernel.org, Yu Zhao
 <yuzhao@google.com>, Roman Gushchin <roman.gushchin@linux.dev>, Mateusz
 Guzik <mjguzik@gmail.com>, Matthew Wilcox <willy@infradead.org>, Baolin
 Wang <baolin.wang@linux.alibaba.com>, Aboorva Devarajan
 <aboorvad@linux.ibm.com>
Subject: Re: [PATCH v14 0/3] mm: Fix OOM killer inaccuracy on large
 many-core systems
Message-Id: <20260112132216.1e347117f15fbf44c752bed1@linux-foundation.org>
In-Reply-To: <20260112200056.1250404-1-mathieu.desnoyers@efficios.com>
References: <20260112200056.1250404-1-mathieu.desnoyers@efficios.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 4ywkycodp97bxwfigxgb4qyoc3wx69p1
X-Rspamd-Queue-Id: 4E539A0011
X-Rspamd-Server: rspam04
X-HE-Tag: 1768252939-238098
X-HE-Meta: U2FsdGVkX1+qaB/B9N+9WF+Zi+O9z2BduCXJQ1Q0vpfgiUP374fZqmpWb9ET+xPQhGWcBUnICNpe8eX4aI6fKmMQIsNVpL0UlHg9C9753SR8cFEBZYqojl/BeCIDG1tYemXUpPphcCQIDVvsrXeng2u2t2li4mTBROIo6/JrWZ2zhYEf2n3N9ctqZnjJ/OE/FYZUjH/OGyYQBA/Xzf0K1WH+3huvsS3+atdjl7i94PhbjZHWUiZeV6UclPcHt5lPLXgB3pheLr+k4fY14Syl/VJoI0Yz5gpLI3cK2Nuo/JgjYU0YJzAHbsl+eqCnLif0tuv3N2IZXSPiOsg3eTBAICtDDlfTupoL0GYvwazo1jy0ZMpV0vtHXIc2ccHidHjiz6/nlQ1RjVWGO7guPbLlab9iljWYDEE5cFwsUrlf1EkQzqcFfZo/WbXam0URg8qLS2ZeQ6VBCAVlggJaKhwK8N2FkAe7S+jr7dWEIXLY5Oa6DVjallUlxJfXgrkm2Ee6fh+Nu6p6uQfeED05T16pvg6R2IF6tH72oFn7usSECVV/Dp++ZCOczPCvXoF2jzG7JGaClg8uTdMCo9RwLDJaM/43/WyBglf8e5xhZ7NCdTMxflzmA3qF3N0oPrvAIbKo3lLZfFpFJ/ClhFsVuPPd6K6MFOYoWGE8nEa3P2jXlV1+xRG4P1bZCOSZDTywNpcjdq8Ejiof+9/SIl2KgvzTXRnRF99iznaJh/VBu4VN6GpzuquDISLfKawZ7qk/YH44ge5GcFI47RrLyaeIzhVGRpueM2Wzu2YPm15+SAUmod5TspOZa1PQODLM4uYtQmEfto5GWPylvtxGlxGuB6OOUdLCh0z1AU3l8lIZ1k27W3KxNESvnLilHvtwLpWn6bBf/nFWEPLnWny3zyZHLE7YzRWDkYqAT7mCc144WSdj1NFEJmdo1H2LSsNcnihRMi92IUKphu650lbw1ai3qw+
 k0NigYXB
 Z6i1yHEQ/LeiE+URXHz/DpNRfCQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 12 Jan 2026 15:00:53 -0500 Mathieu Desnoyers <mathieu.desnoyers@efficios.com> wrote:

> Introduce hierarchical per-cpu counters and use them for RSS tracking to
> fix the per-mm RSS tracking which has become too inaccurate for OOM
> killer purposes on large many-core systems.

Thanks, I'll throw this back into the testing pot while monitoring the
discussion with Michal.


