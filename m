Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D1307CCA470
	for <linux-mm@archiver.kernel.org>; Wed,  1 Oct 2025 20:23:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 07CAE8E0006; Wed,  1 Oct 2025 16:23:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 054648E0003; Wed,  1 Oct 2025 16:23:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED2E48E0006; Wed,  1 Oct 2025 16:23:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id DBA188E0003
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 16:23:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84D241401D1
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:23:05 +0000 (UTC)
X-FDA: 83950669530.30.B2FA1F7
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf27.hostedemail.com (Postfix) with ESMTP id 6EC044000B
	for <linux-mm@kvack.org>; Wed,  1 Oct 2025 20:23:03 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J1FF9mYZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1759350183; a=rsa-sha256;
	cv=none;
	b=EBTisFXjJjWwUt9SAkFL4JfbF6BT7OxY1pkLxkKifhPEYYZsDbl1DpK77Xj7uqd3yUpvzI
	b3OkQ669rbnB+B138YrO4GqCSpOYljq55iCpHxKqKJKlfD8mJPZHo8b9d1gUEIGQlL30aO
	PgMlpK1AFskoXALk9AW75Sncv+Kkbhs=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=J1FF9mYZ;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of yosry.ahmed@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=yosry.ahmed@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1759350183;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n9m0fgp5imm9+MQnY/QzylO+ByiO9mSzTdbEPwZykP4=;
	b=S7Ycv2m04cERhkBOSkTfuofYzkr9RM68f55DMJe76pxf1jReTS4TXWBVHQz0LowIvWl5wS
	x5eBSxbrdZ82/Zj4/aQWN/1f31/Hy+fmy7+NEBmn0pxnrkHno3stffYNEi8wxtkNPW9vk/
	NaCp5ZZjh7MiTTqBROZMTYnQyRAzivw=
Date: Wed, 1 Oct 2025 20:22:41 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759350181;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=n9m0fgp5imm9+MQnY/QzylO+ByiO9mSzTdbEPwZykP4=;
	b=J1FF9mYZ9gvjxJFkcXYC7y0Dh2IROCnDorzVDw9UT7rk1MY+VnnaDWAvVc+P6ZKJt9k2z3
	9U6Xcbu2TgJd4zL9ZX3HyrdB1zcstXO2KHbD1Z1BTF7asqsmgisfdb5k/UA7f6SG8HEvxd
	VRFidcByI7Su6jhvxWjxw8wRVMtYn9I=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Yosry Ahmed <yosry.ahmed@linux.dev>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Brendan Jackman <jackmanb@google.com>, 
	Andy Lutomirski <luto@kernel.org>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, peterz@infradead.org, bp@alien8.de, dave.hansen@linux.intel.com, 
	mingo@redhat.com, tglx@linutronix.de, akpm@linux-foundation.org, david@redhat.com, 
	derkling@google.com, junaids@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, reijiw@google.com, rientjes@google.com, rppt@kernel.org, 
	vbabka@suse.cz, x86@kernel.org
Subject: Re: [PATCH 00/21] mm: ASI direct map management
Message-ID: <eajnyirurulezkgpqaonfqmh5ydi7ujzztgok2ab3fsumcmtwi@34ios2bpwxk5>
References: <20250924-b4-asi-page-alloc-v1-0-2d861768041f@google.com>
 <726d6a45-d732-4c23-a7b7-766d6a62122e@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <726d6a45-d732-4c23-a7b7-766d6a62122e@intel.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 6EC044000B
X-Stat-Signature: 949mfqdpxauosumn4qn3sehh6mzi9e8m
X-Rspam-User: 
X-HE-Tag: 1759350183-49116
X-HE-Meta: U2FsdGVkX18YHFTVLUTWIqhAMwFdHfdGJSXmguMREvL6L86w/fSu776/EtbQ5XFrN5deQaaV6NaJQNdrRBcRjsS4nSjsVBwwaJXvE3dpo2QOFcfVV8UfjTU5r7FFlHs/7+/n/0ZhqWamQIEJZ6EfDyBcZjhFJagJJ+F2AhrWJKZQ7V8rZtir4dniWv7j/n/CAR7B1uHIpNlT4AjxCdfi4EQRMB1tkeL1ctFnnCqZ0wj2dUeCLmWnlC/k4XSJSelTB2iR1RlsToZ9WAisHG5Ak5jlM6cRNs0hO1Vi3jpMzMyxfzgMbb+YM0daxr/BulIQX85f68r2bk3R3F+u7O4U51VXIToVkkD7CcFwVmEDrrGQiWV3O6xb74AnhUsB2sAnTzXk0kNZN4KBbW/P4hyWj/ANeTPWfACice7gnH1z7GjPWeypPWXb2mH4A4A45/CLso9XocVbzfE3O7cmsuakNOGouaG8wJooOeegQqSHZDUE/xYGLO+Z6y6cLq0tKJDvxj8oaM9gCSsd5NqS9Nhf+3Qe63n3r9+jl3PC030rPphsxrdfSDlaBJvWye8mfRVyJD+lFU4XDCIbngfwgZig3mNZ3WvhpE+8JQdcOW/9+kgnd+f45CXHFSDgZdJRraB6k703BgftfkguC1M6ZtxFwNZ4iVnq92xcgvdARjYYspAjtJpaPtXm3SAFTNk6UXdU0dcRlFTbhavVOpq0n1WmcCbwAuNXcpHJPnh8fBjAcVrcim0d4qI50enSN3JFVBivEw6XB4/jyiPu+JC/6sDaRGIcg/lp7klElU/3pRo1m7AvorsJL4dKcBxcvPR80NrcJLzjJaXv5hzFhLk8Ii+ds57BFaqjiiKmiDkvVvemZo5MvQ9ZtG5yvdhnZUlJC+4lq/cufJeb+pctKBJe6454Wf8KGhjO+x5B0R1Yvk0hNVb793fcfqpw9pieB+e9gaj7MLCKZ28TP/iWGOZwfrH
 aIBELG9D
 vJLC+6WbN4mJWPVh/bdvsKGhasoc7s4AIms855aTIMRCTbLCk8LKr4LD9UHCG9XNb2+HGcQDtejLhm3RYH1obZb0Qs9HE8p1q9Os0ti48pByWQ+7YPr3xWia4LX4GwZmamCxzZlqN56RNui3DuQwu0D9iB3VgVZx/RPRldLc+NlmkZxYTjvUqlmGKP9neS7K16JikDuKL1YqaS1xTzqIOczrwkShUH6DnzCheVaBviZhmRwQ=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Oct 01, 2025 at 12:54:42PM -0700, Dave Hansen wrote:
> On 9/24/25 07:59, Brendan Jackman wrote:
> > As per [0] I think ASI is ready to start merging. This is the first
> > step. The scope of this series is: everything needed to set up the
> > direct map in the restricted address spaces.
> 
> Brendan!
> 
> Generally, we ask that patches get review tags before we consider them
> for being merged. Is there a reason this series doesn't need reviews
> before it gets merged?

I think Brendan just meant that this is not an RFC aimed at prompting
discussion anymore, these are fully functional patches aimed at being
merged after they are reviewed and iterated on accordingly.

