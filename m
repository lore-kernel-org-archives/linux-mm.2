Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 95088CA1002
	for <linux-mm@archiver.kernel.org>; Thu,  4 Sep 2025 23:54:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F39A86B0006; Thu,  4 Sep 2025 19:54:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EE3956B0007; Thu,  4 Sep 2025 19:54:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DF97A6B000C; Thu,  4 Sep 2025 19:54:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id CB45A6B0006
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 19:54:14 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 7C795861EA
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:54:14 +0000 (UTC)
X-FDA: 83853224028.03.17AF88D
Received: from out-174.mta1.migadu.com (out-174.mta1.migadu.com [95.215.58.174])
	by imf19.hostedemail.com (Postfix) with ESMTP id C39F31A0009
	for <linux-mm@kvack.org>; Thu,  4 Sep 2025 23:54:12 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nOft/nxG";
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757030052;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=I2nHB0+fgG2h/YQBsdZgUFZD9bhaDf/fBMnAYUZmncQ=;
	b=Zsj3tpgcXMGrYxAmTCiHwfwry7xytJMGgZ6ccL0wPJA01ikDkE0CPXP9+jz+JfaYcIrLE+
	YSKLhguRbjjRwfy28YifGVPL3/C7WcPHYhmAXyrWGGG50N2lsCGtiluoY6OAZXztLoEZEp
	0skF1zsQM8x/8NKoEKjYd7hY2X3M4ps=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="nOft/nxG";
	spf=pass (imf19.hostedemail.com: domain of shakeel.butt@linux.dev designates 95.215.58.174 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757030053; a=rsa-sha256;
	cv=none;
	b=oH0132jDynCdsTRE5m7+wPishWgKqgD3ta/b6zpKgYTGmX6/LdZYKzEneio8HDMPmJ5dlb
	bBAuF4Hl3BvvOI1UQjSHtMkm3JqdXEULU6+2rlVXePA7IcnSWnQxw2icB+Qe2T+ulaxazf
	OY424JhmcFlBJyRLrjBm+ofEg7vQA4Q=
Date: Thu, 4 Sep 2025 16:53:55 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1757030051;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=I2nHB0+fgG2h/YQBsdZgUFZD9bhaDf/fBMnAYUZmncQ=;
	b=nOft/nxG9IV86fBSha/GcaPySgvaLaSunrmXTot9uMw0gpH9yf23OW+acHtm7Jdl4Y7P2u
	LkNznH4dPpljYeGzYUBS3OFjT2YEKIOG8lSXqrs1Rn9JXfHUg+mtRdWk7lYXbnWvRAeNgr
	mmqQfMglq1NCvSXu2X2jVVvccqdMI/Q=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Yueyang Pan <pyyjason@gmail.com>
Cc: Suren Baghdasaryan <surenb@google.com>, 
	Andrew Morton <akpm@linux-foundation.org>, Vlastimil Babka <vbabka@suse.cz>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <jackmanb@google.com>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	Vishal Moola <vishal.moola@gmail.com>, Usama Arif <usamaarif642@gmail.com>, linux-mm@kvack.org, 
	kernel-team@meta.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 2/2] mm/show_mem: Add trylock while printing alloc info
Message-ID: <4lnhlnaobt6cmhjsnhh5ul635bylwd55ha77ej3fgfhdy4k5cf@grchtd457dzc>
References: <cover.1756897825.git.pyyjason@gmail.com>
 <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4ed91296e0c595d945a38458f7a8d9611b0c1e52.1756897825.git.pyyjason@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: C39F31A0009
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qg57m1oh1ejcags4c6gnewm4awfk5czb
X-HE-Tag: 1757030052-300145
X-HE-Meta: U2FsdGVkX199DUvU1olbQ4hkZf1iczyOav2nTg39IyRLJBxff8di3SYI4n51tER0iNaZvj6bmkpfnSKP18Rm+0TE8zMwBFupCw26PJBf6cV3JI3mWwjMWO7/KyDZbfGpFfwSIzOO/r8Tm1F9lkLzKWdrZ7ZrtRejs8mPgVU+xNxzjXEE9SqQtr3Lgu+yV3lJwtFML0IGIsGJUKYbsCssrHqKsuBTqd+kaGvS1F2NzznxGUOpDAUPmohAfTk9PYc005RchzhVxjjgS9ffpNtE1bHnTjwox7HEHH5iWq2bUBju/nV9TKeo38yq1RgFY8/d4DkWSMZOzn9e00KMdLAxE/qv1sqHfDiJO2kdSwaCFijmZI8oAZ20ojBAJlbctrgTpg5eC5sY3hT91SGzDRqlYS72pMqIFIXSaAzIGbsGTkH2nFTcPcOWA9zII8EGUmJFPqNfLmQ/taR7f9VshWhalmevR095bBUudvesuTPV/5+L7UJ70Rfg43oyTGWNMfzH1MO8H+dfp9H98yHLinrXHcKPOFoAdQrzExj5XPT4u/JWxAZeN7QGjhiJZ61LnEX/sG2tYcRy3xLcDDSiNU6oT9zOlU5h46XcExvigrKjDnqyddE4XFJXFFw7nmiiOjgNQInElI3oGmNthC4jTxrEEi9B3XD98QTIRvjoTxheUDmIk83lRYFAUlCpxtgT5YOf1Pb5iIAeTObLe64dIXuAvvOhYyKJmoI/CbwkShWfjMD/XRebvX+apcQAFlVbHzMf7ghgdJUBQb9Y9R+q6DQdfdvzpr8HbqrxzVblRnk6CmVW1EzhiUTL0sEqm37hmNY2EDG62OQAsIUYQo78aHe4rdkCPqy37PkF0l1XTZ4ejntc1Wcc2204qgbbpRcctbbapUzaO6vMOqlxyquIapyIkh7XfxUgYaGSr2Jwp7ukCHjnkxVPl3KGEZ+F0N8ahOtxg/LcfJ2zcVhIq6oIRfO
 By7lyGkI
 kLn0d1DSQZ9/MHb+1R15xZNlwLQynwaqv1f0wpdagpaMFgVpO9rHGdwJ4GOYPLiCwbz7JNLfnd8ORGEEldvbkUHNVpL81+sYbUrAKeMWvC75ndKyayaxsG1qaTPXmx7L0pZ2ZJHaLucCE3ktOJMH3c0jvzvnHbTGW96FeJQzd6lZfV762XcogJAAv5AXeP65XXD20EsJbM/ti44Ot1zYSTjyA8VtseDd9PDId3F7vB3ogEvq4le6iA0WlXDfy+vpYR9zS0vQDlNSJ+CrANex4KItnnpKrl8UJ5fuXfHyQeQuX/HHdsvY9ZXoK+StD9W86p7JN6Qp8JFOzeFalOYHfq0nzNJMnykEcgImH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Sep 03, 2025 at 04:16:14AM -0700, Yueyang Pan wrote:
> In production, show_mem() can be called concurrently from two
> different entities, for example one from oom_kill_process()
> another from __alloc_pages_slowpath from another kthread. This
> patch adds a spinlock and invokes trylock before printing out the
> kernel alloc info in show_mem(). This way two alloc info won't
> interleave with each other, which then makes parsing easier.
> 
> Signed-off-by: Yueyang Pan <pyyjason@gmail.com>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>

