Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id ED00EFCA191
	for <linux-mm@archiver.kernel.org>; Mon,  9 Mar 2026 23:10:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D6C7E6B0005; Mon,  9 Mar 2026 19:10:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D1A4F6B0089; Mon,  9 Mar 2026 19:10:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C263D6B008A; Mon,  9 Mar 2026 19:10:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id B19876B0005
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 19:10:09 -0400 (EDT)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 65D6C1A0393
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:10:09 +0000 (UTC)
X-FDA: 84528069738.08.F67673C
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf10.hostedemail.com (Postfix) with ESMTP id 341AAC0004
	for <linux-mm@kvack.org>; Mon,  9 Mar 2026 23:10:06 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ppc3tLui;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773097807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7pf/BuL+OuQCj3Lebv/TwYfAfcvP2u/9LGqWeh7qGx4=;
	b=4MtTF4N1eCyqZFt8/e6p9yy0cKKoQ0EE+kt3nhCNiIFStzJ9cHO1LQ3V0FwPA5oW5UrWls
	VGWW/JdWmWVtlgL1Ypsc3gfkLg/PJHMqfq60fz1igfuDuQxAJC0nxFfhPedSU5t4htoFav
	rS0bsh0yKmqtvAp+U0wDfr8yEdUxraY=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=ppc3tLui;
	spf=pass (imf10.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773097807; a=rsa-sha256;
	cv=none;
	b=ONEI5Egycfqh8ezbA+1P0u1xTOfjHZPchv1hAV+sJPt6FT/HR/eL0az/9U5T/KajlkPkuC
	hmJTyIFMyllvB2/8s5Y2Kdl937Y3grKY/v5h1idNQi8y0ATr9rqvKcJfSNOUhMR5FaFuQl
	UZDQ6MPTa11Hi35sr5k8zoZqfypvdyY=
Date: Mon, 9 Mar 2026 16:09:58 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1773097804;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=7pf/BuL+OuQCj3Lebv/TwYfAfcvP2u/9LGqWeh7qGx4=;
	b=ppc3tLuikjtXxy4J11OJ8dMyczJdQBJfufqnlr8I9Ar3PaiXdi5OyYO9RawkpH+xg8f2jn
	+gFF+nyi18gbqEfQ1LKl+LF/alRYARItsibw8lX4K5suMEck031JVQxcdHRKK4X2FMr/BF
	TdyV3fnvqRGusRJAQERAWFjfOJQ9ibk=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Roman Gushchin <roman.gushchin@linux.dev>
Cc: lsf-pc@lists.linux-foundation.org, 
	Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Michal Hocko <mhocko@suse.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Alexei Starovoitov <ast@kernel.org>, 
	Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>, Hui Zhu <hui.zhu@linux.dev>, JP Kobryn <inwardvessel@gmail.com>, 
	Muchun Song <muchun.song@linux.dev>, Geliang Tang <geliang@kernel.org>, 
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>, Emil Tsalapatis <emil@etsalapatis.com>, 
	David Rientjes <rientjes@google.com>, Martin KaFai Lau <martin.lau@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, bpf@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Vlastimil Babka <vbabka@kernel.org>, willy@infradead.org
Subject: Re: [LSF/MM/BPF TOPIC] Reimagining Memory Cgroup (memcg_ext)
Message-ID: <aa9SB6OzocfwL9kO@linux.dev>
References: <20260307182424.2889780-1-shakeel.butt@linux.dev>
 <87sea8zo0t.fsf@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87sea8zo0t.fsf@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 341AAC0004
X-Stat-Signature: jgu6skkkftng3cjo5bzbsz5c14xqsp93
X-Rspam-User: 
X-HE-Tag: 1773097806-366775
X-HE-Meta: U2FsdGVkX1+/SiV6F3Nf8Xd0JzC4mw8ou1MM6uPRxI+/RxPqsxnvvEpyP2fPzWF4f0ctaa1DROX51BkulmQW5IKts/5oNZTF2NnlgiEu83uYoRtLmLdFldpFV40uOyaTCGWHnVqeoMB7MkOPBZD9j/W7TwKAV3eEhK0w71rAdW1RcUseTpujzyRH2CjMe3zcf4mNXs1xh7qewE+NF63vGe3bXs9EVLSceTwLOnvaYF+H0o7d3wb/DxAeBVbApVkf4t5WF2xQgG9dYiGhxLiVXbvy0e91K+JtN01+qjBGbwszVAZghxiXpZjDSKUHcTZC0hnYtmvbBTQiFOmctFGIakE+pEIZFAVo0CJ5MGhImYq+3BglX5C2sDE6YSfXstKSvSa80YJYwYifAyh7VAAKO0N0vq9sUhbqfEwYI9lsfnviGOxY9OHoyjYU40O+4iYXToJNbwKqUngn2i5Lp8BCueQQTQlOxwwAWo4HVpwLww2E3bMhE/2tJY56A6HSLbsIz6Ku94TeSDsa2yWlFfAATUrsk4EZZroOdNvB57x2XeXgTnomv8j7z7viypjuT7TTMRafkCxPoagcwVOHfA6mc7ivOLZuN18xZj+90VqrAurh7abQ5pKSHBhAG1mkfac+r/XFkIToZzKH69cJ+ZywBs2ikPLbZg7S2w7Szxv4mxRD9CQPXHSSJFw9VYDzjmawnK80QQUQueM91JgW4n89itUUohAU8mCZeOy7FtTIquQyUFwSD/03s1y0z1j49Scs1ETPpjSFN1/oxksDg0cZ/r+QC7MmoZrsgCfjGE9EvJNR0RAMBzuqk5WpluQQ1vjHO4+dS2JOeYw8Z3tmcJVE8DRuiu+OCC7ozLMs7d+keUFdzCMScoo08iN1OsmxCJnjgA1/0yAcCyHXLCYmN3LAbtuTPpnrCX53ResSB7FOtovQ5Ld9vdzpNG+pHv+q+f1x5lTroysx9XinDrC4rZZ
 rJt7jFO5
 1t9iV2w/nOLQO+odXhOvIyjwV7S0TsZXRPMxpiGT8RsOSWvW43Q3m5eQ4XCxvfD2FXexUw78jkQo3+fWUdjf3t1sozW4L4kWnqUSfpT94C75htMHoKhT4fTYZN0hVtVRDCNbvLJxvO/gwzr/j/ZSGfywQP8bnT1YpfXZaJeBJNv6v+FSqngh82TL06pcE1aHMtBwoKNXfkHHRsJAA193dySXhF/TLvuIuAhLN5gV2MsM0jijt+KeEd61NiUAm2IHZuWXw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Mar 09, 2026 at 02:33:22PM -0700, Roman Gushchin wrote:
> Shakeel Butt <shakeel.butt@linux.dev> writes:
> 
[...]
> 
> This is fantastic, thanks Shakeel!
> 
> I'd be very interested to discuss it! I suggested a somewhat
> similar/related topic to the bpf track (bpf use cases in mm), we might
> think of joining them.
> 

Awesome, we can request to have a joint session between MM and BPF to discuss
these topics. I know Emil and Tal are also interested in upstreaming
cached_ext. So, we have multiple topics in the intersection of MM and BPF.


