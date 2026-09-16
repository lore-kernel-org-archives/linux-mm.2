Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E43B2C982C9
	for <linux-mm@archiver.kernel.org>; Wed, 16 Sep 2026 23:08:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D74EB6B008C; Wed, 16 Sep 2026 19:08:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D4DC16B0092; Wed, 16 Sep 2026 19:08:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C900B6B0093; Wed, 16 Sep 2026 19:08:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AB98B6B008C
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 19:08:25 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 19420A4307
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:08:23 +0000 (UTC)
X-FDA: 85221166086.22.6E84CD3
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf31.hostedemail.com (Postfix) with ESMTP id 5917520007
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:08:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eGNs2RSL;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789600101;
	b=6Vfip7VO7uJ0Nm5VfwQZe/GsumldlLJcpT0qd0PDiq31kH0NZ8AKGGYHUW3/QtX+8pZ6YB
	wfMt8M2gzyn6dlaMueQmmwpQF54WE3hKmJkChDsVr8uY0+o0bAxzbP4RnMs5D8FRM/zBPg
	28dKtp49ils/hdBGH/VLtr6MXjJNiTk=
ARC-Authentication-Results: i=1;
	imf31.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=eGNs2RSL;
	spf=pass (imf31.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789600101;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=EsS3V4h85OIwyWRlwYSEAgLWwmpwQNGI7X/TGNZ7g8U=;
	b=15IwHo7aJLycHMJ1s+U1OhD1XmeBvVrKG6tRGZPRI42FMyU48VBqP3ZOahe5JiggE/3UiL
	xJQWv2vrYuQVpaHno6NBEBbBkx04Lay2GsXvi7O4qSL0/lXKE2cLBh25V5HUa1/RLQl0mq
	GrGEwqAddHgoXkd94RopBJPUitg9Mvg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id AEC35601EF;
	Wed, 16 Sep 2026 23:08:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1151F000FF;
	Wed, 16 Sep 2026 23:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789600100;
	bh=EsS3V4h85OIwyWRlwYSEAgLWwmpwQNGI7X/TGNZ7g8U=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=eGNs2RSLhL2M9yMOdSs2XidbN91Dw5xcUl+25yjc7oNiTyl1FxuKKCr0l0KnLFyL8
	 eqvcJlGuLtAJ2RIqSbSJTk+f9VaY5nUZj6UVutP/hCQJceL4Z29aJIIoAqUoE3h7HC
	 E3UfrBJbrA0MK4b9A81cH+8VPc5auKzDxJEXGJ+0=
Date: Wed, 16 Sep 2026 16:08:19 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Arnd Bergmann <arnd@kernel.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Arnd Bergmann <arnd@arndb.de>,
 David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi
 Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo
 Stoakes <ljs@kernel.org>, Kairui Song <kasong@tencent.com>, Barry Song
 <baohua@kernel.org>, Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie
 <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Baoquan He
 <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, Ridong
 Chen <chenridong@xiaomi.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/vmscan: avoid false-positive -Wuninitialized
 warning, again
Message-Id: <20260916160819.a93fba485ffafe5b0e63b5f0@linux-foundation.org>
In-Reply-To: <20260916083456.4136132-1-arnd@kernel.org>
References: <20260916083456.4136132-1-arnd@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 5917520007
X-Stat-Signature: 9mgpda5uzuxx7s6ga9wf7kf6xxegddxw
X-Rspam-User: 
X-HE-Tag: 1789600101-320234
X-HE-Meta: U2FsdGVkX18mEa/XtYfCDK9AlgKder4LRdMCkFvYb9axvO6i0zwKXcfiT7fmV2nCzi/zaHSFB02Uw2DbB3TvjklSj8CEYcLQqenP4VuRrHmHBX2UhpY82iKJipwK9IMS+GLyAj/DKfWoHeeU3pB5roa2VvGTsYU+GF8k2LvlAO7xwSubG5tzPBmaECQ4DwjaUHRAmCIjToXsiRniOggY+KeR5aGTmQL6MIHZBqkEeIKGniENS79x6FJx0cqDaULWjILcekPMLalx1qwsATYRUpokc+exiiuSGmt2ME3JoTmVXe7+shBfE2QCPmbDRU+fmICTh+Bs/JQb21BKDkwvSn9jypSmu/e5RsGXu1GDf4X4Sf2gmppY6R3hMeCp8gHuxUHdIwltNQ40SVQmTbH1+QQila0j7jRhNSVEzkdq5yJKJ/TK7HaPtN+DUZ5xfvnCCw6RNPcKLR9ePqxZwJvvPXPf/jr8snyG5hAq2dyG66wgvC78EADxXSkX94FlscacvTUBBdXi7E6/AGuqOkf2s84znZ3NIi/M0v+9+X3FUIT0UHXao+8MakQ/FHwPBfLWmxrJ9Kh7iCNIenzOyrTuxoSZ18qtkJ31MxfBzboPFX9EH7JSZMZSFMdRwCbYOuLWBC73WO4lwbHMnFnrH8tyfQVwRBzINxuRZHe6tjLtfUddwilUyzL8BtC3mZzsTw+jXrzqh1VOXJ0/4+4sEl2iPu7dsvydQqW92MsEvXSeX1IV/hGR6OemBAgLhtyvq6JKGfDtzqLi+ISP2S050yh5e84XxtzzYrWnC8qEQXC5asQaH13G9sqMMlJWickCaJ6PAfWq+U3lLlYpX5oMDqLLsyDmbz+dD4twA46oi8/OHCy7bYVXJSWeYE2+Nb7+oQB/ZGeqHBuCCzl59Cqz+aJbTYlnz/AEG6rD52TsS/ThEGUP2TMnxPZSLmAPKfLjZUEip7guhyiTOEm9Wlyaez/
 GvcMSqf2
 /DFmdo10OAcCe9iqAJGXsJIVXVzMvLvoXkW+46Tcz+OLiWkrKlBcCER6te/GuCoTwVw6j+CGqwz8GCw5faPU21uWhUKz+GNPSCWdy3lu06+MJVb5Qr3sTBHWkB3L4k4dGcaHzZtRbn7a8piN6ZnPnarOHyPvrseij0HCYD18FS9DaPJEp1BWsYz7GiVHK1WdxZYGmM5LzAvKClLDE4klPT9OQRpcCKXAvrql9NIYlueav2r1l5IW4+iG98HHFa0dmVnYeozYyC4cXvrcdKaUxSxci1g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 10:34:46 +0200 Arnd Bergmann <arnd@kernel.org> wrote:

> From: Arnd Bergmann <arnd@arndb.de>
> 
> I previously worked around a false-postive gcc-16 warning in the
> get_tier_idx() function, by adding a fake initializer. This happens with
> the -fsanitize=bounds sanitizer when the compiler creates a specialized
> variant of isolate_folios():
> 
> In function 'get_tier_idx',
>     inlined from 'isolate_folios.constprop' at mm/vmscan.c:4982:9:
> mm/vmscan.c:4934:9: error: 'sp.refaulted' is used uninitialized [-Werror=uninitialized]
>  4934 |         read_ctrl_pos(lruvec, type, LRU_TIER_MIN, LRU_TIER_MIN, 2, &sp);
>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> mm/vmscan.c: In function 'isolate_folios.constprop':
> mm/vmscan.c:4946:25: note: 'sp.refaulted' was declared here
>  4946 |         struct ctrl_pos sp, pv = {};
>       |                         ^~
> 
> Adding another "= {}" would solve the problem as well, but to prevent
> this from happening again after the next code refactoring, try instead to
> prevent this by forbidding interprocedural optimizations on this function.
>
> Link: https://lore.kernel.org/all/20260213123902.3466040-1-arnd@kernel.org/
> Fixes: 3de705a43a46 ("mm/vmscan: avoid false-positive -Wuninitialized warning")

I believe we want older kernel to compile properly with gcc-16, so I'm
suggesting this be backported?

Perhaps we should have done that with 3de705a43a46 also.



