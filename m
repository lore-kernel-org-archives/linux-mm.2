Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BB0DCCD192
	for <linux-mm@archiver.kernel.org>; Tue, 14 Oct 2025 14:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AA77B8E012D; Tue, 14 Oct 2025 10:27:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A7F3D8E010A; Tue, 14 Oct 2025 10:27:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9BCD38E012D; Tue, 14 Oct 2025 10:27:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8A4888E010A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 10:27:19 -0400 (EDT)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 3FBF7BC12A
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:27:19 +0000 (UTC)
X-FDA: 83996947398.13.C0B9131
Received: from out-188.mta0.migadu.com (out-188.mta0.migadu.com [91.218.175.188])
	by imf08.hostedemail.com (Postfix) with ESMTP id 7E456160010
	for <linux-mm@kvack.org>; Tue, 14 Oct 2025 14:27:17 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k3QLVk9X;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1760452037; a=rsa-sha256;
	cv=none;
	b=8SvUARxGtRIZCLs8PR2BS64nEuGmenZlyjz84bjkrQsuJQkf2YbeTdS3IS2Qx6i6aw1fEE
	M2Iyu7st5y16UqluSfkWVJDxF0bM4BhHihAZekJ1U7lZ4iia6JQbkwBqTde/pDi9yR+za6
	8BObAn0xoBVhFPRqwm0FXlbgHEmU3so=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=k3QLVk9X;
	spf=pass (imf08.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.188 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1760452037;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xmzBJXabx4eUefij6QpqRo9hlKdZJcNNossFkRf2xhs=;
	b=Bk5hUF3IDgy6dNyPC3kNtl88RaVYL4rTCpyYy72NH5wL8y7oAKeyLSFbElP7R8Irmk2ME2
	HH4/TOjDh7zW1NaHJcS+vw/LsaCtKf2pj9pficVXQlqrTXZkVKKkND/lMvCd02QUgd7Y9c
	AUR89VW6f2UTnD4YJrUheNQH8tyBhpk=
Date: Tue, 14 Oct 2025 07:27:06 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1760452035;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=xmzBJXabx4eUefij6QpqRo9hlKdZJcNNossFkRf2xhs=;
	b=k3QLVk9X68xj0fW6ouutSzsm3KP1k+huwBQS4la+ENxodaZmV1oopg1OpXPyzLIXwI72fH
	TrU/4mvpvnFPc9jGyZ8pDZjO7OKQLmcXgz95maiE/Cd/Vv6kBa7GFlp+ufqNaTfL0Gpng7
	aFqkMZaxH/Fh3qXtoaq4BaCYW68nmRc=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Michal Hocko <mhocko@suse.com>
Cc: Vlastimil Babka <vbabka@suse.cz>, Barry Song <21cnbao@gmail.com>, 
	netdev@vger.kernel.org, linux-mm@kvack.org, linux-doc@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Barry Song <v-songbaohua@oppo.com>, 
	Jonathan Corbet <corbet@lwn.net>, Eric Dumazet <edumazet@google.com>, 
	Kuniyuki Iwashima <kuniyu@google.com>, Paolo Abeni <pabeni@redhat.com>, 
	Willem de Bruijn <willemb@google.com>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>, Simon Horman <horms@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Brendan Jackman <jackmanb@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, Yunsheng Lin <linyunsheng@huawei.com>, 
	Huacai Zhou <zhouhuacai@oppo.com>, Alexei Starovoitov <alexei.starovoitov@gmail.com>, 
	Harry Yoo <harry.yoo@oracle.com>, David Hildenbrand <david@redhat.com>, 
	Matthew Wilcox <willy@infradead.org>, Roman Gushchin <roman.gushchin@linux.dev>
Subject: Re: [RFC PATCH] mm: net: disable kswapd for high-order network
 buffer allocation
Message-ID: <qztimgoebp5ecdmvvgro6sdsng6r7t3pnddg7ddlxagaom73ge@a5wta5ym7enu>
References: <20251013101636.69220-1-21cnbao@gmail.com>
 <927bcdf7-1283-4ddd-bd5e-d2e399b26f7d@suse.cz>
 <aO37Od0VxOGmWCjm@tiehlicka>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aO37Od0VxOGmWCjm@tiehlicka>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Stat-Signature: a9c4wnp6izyadabqp6whkt1j7e4iez4u
X-Rspamd-Queue-Id: 7E456160010
X-Rspamd-Server: rspam09
X-HE-Tag: 1760452037-156205
X-HE-Meta: U2FsdGVkX1+ge7axYZP8VtJUUiT/rbRgBuhoz89GyA9S/FNjGmcrwjgFLceesCWxSXwMoC1reYVFvVDDPjBJp7+a9ewE2Rk5sZF49k0spB52khcRw1YrDegToEkc+VyAH8vXPQ1bB9K4o6O65phAqhQYKtI/qY4NRCQzqsZ6Lk4Yn6CIWbKnlq/6VmZ64AhWhiRejLgcmU1wvSglrxrMMkwIAvJrWftbQ3D/0WkH12bcNQ0f2/kKbsmVe1tZPUNz+t3iRyiM6tBFly5hAxoV1md5zsbGU37xn1sURubc1Dn/Ujg6eJYVbcVojF7GYSPzQxxBQlS+YQX7cr1tMiNW5Y/YWVuVfMqeg3sqMYC7TxmGZ6pBl736qj+wRvJeKYoFJq8O0eZYA8McIA28/F1RNMF+EfCM+54x6xy3cEvycLfidVAamBEZWU9KwxeogjlIBF18xKOf9ekdtDjgGQBmwBo21bFzmiADkcQUbEA2OVs1XbcPLSs8ECVrK7Qv2cbvwdBPfsxn2oftuDgJXJ6sT6j+yspSLKaNR0ULtU7PMwy5gmsq/71N11Qk5YIi7ReW2u3cZ5dRZaJbGGyYdQBJEaOOEcidb/qmxnsTBKI1OatjdxnK8XOoT7KL0r9zcnbp7b0OqCRwhC/CqHz2Ke1OzT0JWE+JisC/+0qeDeozp9wRdcVgkboahVFJOuJ7nB/pEROhZICZbBZ1qnzbZCVhZTy/CvNRw7AYUv2jTOnTjTgzwINw0iI+p1sGnxfW4QNjeZp2WOWpVXSAVIEO/HCTwLl6lkL58kuZqzgypjT2bs+b+UZVIK4jWaslgvZecLMx2owmFBx0RXHPUVVXr4PCm59RqSrbiegXEU9loGuTClTuat5T1n43cPAvFb5+vskwC0WPbgoOk9Nkkk5v3prrvCaNEhmpYT0bgzmJhsfIiLd1bRx8nKb1Qm+zkbEktMNlS40z0nddDP2dryhUZJk
 uTxSHJPO
 HtxpZeMPbvFPdmfKp0HkXYLIMxC3MGh8/1qkl7uGvflOU6rS5Gj+v0pYboH0QOxiEedOB6HgzfrkLRUBDnE9v8F6Wx9cZtv2WuZiUp3VFkp2shHiYvZ1FM7t1SV/oBxCrXPPdACjsvMUthotwxRY1pjr11xhrunrHU7yxIollVuLgnnOTPjsvjwQvDisSs1JLEnbVMogl9n7qJVSYVXgjM+oTWsbbtRdwXumgmWGp9UJy6/XtjupUTKMGx9IQQEEJZ/ZAb+8whsTKuprp1A6x24OKDTIrnKCysMTm5xxnLTjGgio=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Oct 14, 2025 at 09:26:49AM +0200, Michal Hocko wrote:
> On Mon 13-10-25 20:30:13, Vlastimil Babka wrote:
> > On 10/13/25 12:16, Barry Song wrote:
> > > From: Barry Song <v-songbaohua@oppo.com>
> [...]
> > I wonder if we should either:
> > 
> > 1) sacrifice a new __GFP flag specifically for "!allow_spin" case to
> > determine it precisely.
> 
> As said in other reply I do not think this is a good fit for this
> specific case as it is all or nothing approach. Soon enough we discover
> that "no effort to reclaim/compact" hurts other usecases. So I do not
> think we need a dedicated flag for this specific case. We need a way to
> tell kswapd/kcompactd how much to try instead.

To me this new floag is to decouple two orthogonal requests i.e. no lock
semantic and don't wakeup kswapd. At the moment the lack of kswapd gfp
flag convey the semantics of no lock. This can lead to unintended usage
of no lock semantics by users which for whatever reason don't want to
wakeup kswapd.

