Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5A443C982CC
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 03:13:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6FAE96B0092; Wed, 16 Sep 2026 23:13:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6ACBF6B0093; Wed, 16 Sep 2026 23:13:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5753C6B0095; Wed, 16 Sep 2026 23:13:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 395FA6B0092
	for <linux-mm@kvack.org>; Wed, 16 Sep 2026 23:13:13 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 2FBA51601FC
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:13:12 +0000 (UTC)
X-FDA: 85221783024.27.2C9537D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 727FB140005
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 03:13:10 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hBiJNpgS;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789614790;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4+BlsAYVIvUfCkO04DyxIYq5YEbiYoDvPQdBOWVcg8o=;
	b=bcdP2rGX9gGOIJzbtXOrV3IIVSqlpCJSr9r6FwYhKQoJBOO4Q2BzREm3jI8cf+6Hxf7G8x
	BNkyZhmm66wEQTwrff7dprLANlu8ltGBFCFaaiTVbHVX6ysYkEkI1h+aQFzKDWdX7HRldt
	iS17/KVRjVkvWOFY0IeJexxKBRLvfAQ=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=hBiJNpgS;
	spf=pass (imf09.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789614790;
	b=BHJIPrTtc7ko180oMYpQjfU5sbh6kuDY47THY/msSbFeI6bhfNF0rbt0v1UHqGgbmJ8iPR
	MopaKoy7Nn7cLGc2sfoiillVvYABlyir6C8W26B0BYl1l3faDwbB3sDvaXbIjSJz6GfIxh
	aqlJpzMgWnn1tmK8/cimdEgHKPRMrIE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BD4FF601EF;
	Thu, 17 Sep 2026 03:13:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 585591F000FF;
	Thu, 17 Sep 2026 03:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1789614789;
	bh=4+BlsAYVIvUfCkO04DyxIYq5YEbiYoDvPQdBOWVcg8o=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=hBiJNpgSIbLu448u25HbOQo5bMiPEncJqYfjeZJAyyhF3R2RWKukQ0My/1W9qgG3R
	 q3ZcrXWQhRwuXALKX0cvM2ivn55BXK0d66EDShx8vS4aXs2nPxIzsrdzkPWUeXzqDh
	 N54rEOf2/SDOY4l38oMMQhB+BQjSTR5m7Mz1loYY=
Date: Wed, 16 Sep 2026 20:13:07 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: ackerleytng@google.com
Cc: Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org>,
 Alex Shi <alexs@kernel.org>, David Hildenbrand <david@kernel.org>,
 Dongliang Mu <dzm91@hust.edu.cn>, Hongxiang Lou <louhongxiang@huawei.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>,
 Joshua Hahn <joshua.hahnjy@gmail.com>, "Liam R. Howlett"
 <liam@infradead.org>, Lorenzo Stoakes <ljs@kernel.org>, Miaohe Lin
 <linmiaohe@huawei.com>, Michal Hocko <mhocko@kernel.org>, Mike Rapoport
 <rppt@kernel.org>, Muchun Song <muchun.song@linux.dev>, Nhat Pham
 <nphamcs@gmail.com>, Oscar Salvador <osalvador@suse.de>, Peter Xu
 <peterx@redhat.com>, Randy Dunlap <rdunlap@infradead.org>, Roman Gushchin
 <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, Shuah
 Khan <skhan@linuxfoundation.org>, Suren Baghdasaryan <surenb@google.com>,
 Usama Arif <usama.arif@linux.dev>, Vlastimil Babka <vbabka@kernel.org>,
 Wupeng Ma <mawupeng1@huawei.com>, Yanteng Si <si.yanteng@linux.dev>, Naoya
 Horiguchi <nao.horiguchi@gmail.com>, fvdl@google.com,
 jthoughton@google.com, rientjes@google.com, vannapurve@google.com,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mm@kvack.org, stable@vger.kernel.org
Subject: Re: [PATCH v3 0/4] Fix HugeTLB subpool used_hpages tracking
Message-Id: <20260916201307.5618114cbac4af52d98aecfa@linux-foundation.org>
In-Reply-To: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
References: <20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 727FB140005
X-Stat-Signature: w7qcejz74s319c5s7jgnndebhimy3uau
X-Rspam-User: 
X-HE-Tag: 1789614790-660421
X-HE-Meta: U2FsdGVkX19iLOLBslN1eP+U9jqYJbsriULULxmG7e7io6ywdqwwvWXGQdt6fXUEjUflcH4L9h9+ZuFgmCd0+Ce4O4iCY8SPw6DQ+D9qoVbAvduoD8wI2XoIoHMy1JRDQYLMjGx2xN9GhW8HnwaMCZRUlRe3NKwcQWeJN8Qn2Ukj/R6gs1qjePppaAavNZWSjXdl1ybe9Y+PlstT+NF6Er61oSPaOZ+atZnWUiI0oB8clhXc5eL1XqAlKsGZsJoPJw5rWLAxz6J8gMg5EeDU2c5B391WFvZIxg3p7Scqgled6trr2d5V9KBzzTJOSwxFVpKoDXzIUg9bZwjzWkH7a6jyGskpVkAFuKPhNLG17cNTI6nbZr/69PBczk/6VRJ6Yk0rDHcqFjbZJv6oKCcCKpSySpi/FrtNSNlMgHLrsTSGJHCn1EbBGHCHgu5oSYeD5uHSxsJYZkp+MrKm9IzCTH4JpsssLHmMdNdaLHgZf2zU/PJajVDn6++ZrbBo6u0cKUGlE9VKRarpF7osMGyyDC4pqYlaG2k9q23+jfLpHQtjgJNtTLvjTza4sXeanMQD3TdwmIevYR4XyIveUTNgAEeClCHRAEAQhuq4kxAw9qVUxunwL1uRFr3bPa0TM6ChAnHlP0hoHuK7Z9ykcJmQB4aqfy1NtX+IkkUo28ynlhK2T0HxhfD8SVLvPRskGxAtosdA4kpD4QKs0mXkpXiPowibhiTCOobpDxHUmda7QDUCpkhO6or743cjJ1K76Y/yaUd4A/h/5okOVxO69dyktZDcI+CtM7O08lZC7JW4yUzenn872cRfLq+DGeeQxjS7lE4Z994JA0qqr/Ap12y9oKfHiRzGprvqoNlNy5bGuQW/oPSxeiqLD1lIZ2+eRE/bxb2h2NEJ6Ry8GKTAwJnAsUx0AA38w7hOB5B4kg1dP3Pu6TVseesl4z9oYd+BNQjVyBQRDZt+rRrVZhPQjdI
 mgwEt9gk
 2PsNLjnhxKVcGjwRkAdtQ/AFqTEFvRp3N6HjNhkY3JMpTaowlqSiv6lR/H4/ib4a6VPpIY7ORjum2zvAgJ45NEXZFINAd75ZlXyPIbhjm2S1LVQ8iDg/jcExGq8OH8zZvCG9mIvi5dX2InPQJo2yqaVcA36Vyt6MqjVww30a6yJ6of1zz7/cIozxMBv4yuXeTf2TQ5jbrxoCnRi40c+u6S6NDCwKgQPE/wWDsNZuWzviFGJcuAlkPA+v4db6qepKaLloTwfsyp6UsY0KqcP05GU7WMQmQfmgRSGWOnLuvwVnRhyQWTWVcJDs4ega5Y7nZV2rN8Ey1mZjOjXjrcNknRUbCur+i9UEk2CfiGlAPD+KwkMK4wEnMFTNgJsaXDWGHvmy/ACB/xkvODqmVhVXTk6Ks27KGaSPX4sWGpvrB7VUnUJUo3FYUwVLdpve5kgMy7nhjIO+55vNvFd4lquWvymYNAwjrXTjK8nzOLTpKPYFDTcdAupGKZFqxFNiANZAwcvJELlL6GoZfDoKGR9byIL8q5heKPokF28w0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 16 Sep 2026 16:39:00 -0700 Ackerley Tng via B4 Relay <devnull+ackerleytng.google.com@kernel.org> wrote:

> HugeTLB subpools currently only track used pages (used_hpages) when a
> maximum size limit (max_hpages) is configured on the mount.
> 
> ...
> 
> This series addresses three problem areas resulting from untracked usage
> and asymmetric error handling:

These are rather serious-sounding problems.

I'm seeing Fixes: for 10-year-old patches, for one last year and one
this year.  The fourth patch doesn't identify what to fix.

So if downstream people (-stable maintainers, others) follow our
recommendations, some kernels will get two of these patches, other
kernel versions will get three and some lucky kernels might get all
four.  Are you confident that the patches can be split apart in this
fashion and still produce a good result?  After all, we're sending
downstream some patch combinations which we didn't test.

Also, can you speculate about why these things took so long to
discover?

Ho hum, complicated.  Let's at least slap a Fixes: on [4/4].  My
trillion-dollar sidekick suggests a9e443086489 ("hugetlb: disable
region_add file_region coalescing").

Our other little friend is talking to us:
	https://sashiko.dev/#/patchset/20260916-hugetlb-subpool-always-track-used-v3-0-38aae9b5ccdd@google.com

I'd like to queue this up promptly because it fixes things.  But let's
seek additional review input and argue with Sashiko before taking that
step.


