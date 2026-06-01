Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2628FCD5BD1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Jun 2026 02:09:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6281F6B01B3; Sun, 31 May 2026 22:09:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D90B6B01F0; Sun, 31 May 2026 22:09:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4EE896B01F1; Sun, 31 May 2026 22:09:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3CA026B01B3
	for <linux-mm@kvack.org>; Sun, 31 May 2026 22:09:45 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CFC371C08B2
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:09:44 +0000 (UTC)
X-FDA: 84829712688.07.7B01422
Received: from out-179.mta0.migadu.com (out-179.mta0.migadu.com [91.218.175.179])
	by imf13.hostedemail.com (Postfix) with ESMTP id 09F1320002
	for <linux-mm@kvack.org>; Mon,  1 Jun 2026 02:09:42 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5vH0pPX;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780279783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iDDfOFWy/TEWE9TK1LtUw0BuKs5gwFlMEYe/+sdHufE=;
	b=CxgMRkd3o5dLhed1vzZSFjZXbV1WV+gLFyQlRF0wHLZDMcZx9qbzpWJWp+GzgVtYWOgNd2
	aAcrCXGQyGpcLMW/5w+AN1whyD3VqYYKUbdkbXiYzFcJOE+07NP74Nz2XWHYFQ//xorjaL
	RTVSnianhu8dUO+rocpdT8faDENVdOQ=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Z5vH0pPX;
	spf=pass (imf13.hostedemail.com: domain of kunwu.chan@linux.dev designates 91.218.175.179 as permitted sender) smtp.mailfrom=kunwu.chan@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1780279783; a=rsa-sha256;
	cv=none;
	b=D9im26ie0hxh5q8CzvPgekJvGJhGZpNK8fJ0vEfqf2BNXezVRA010u/AGytFlmZxF+CCsk
	ArDfow+NYXUlfC20OdJycsxezkrR7YxI9fCAZUWO7O8M1ewmAGF4odi/Zf7uOavrVBo43t
	u6v6HLVap8EXvRyLnbfwvNqOiQ3SBac=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1780279779;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iDDfOFWy/TEWE9TK1LtUw0BuKs5gwFlMEYe/+sdHufE=;
	b=Z5vH0pPXLNpa0KFp9XL3PskVWUujMvCVP+qR6Dg5C6yYUAlM7lZAlnt8kPUAS41+c8vxuZ
	uRTIXsBiHU9oCpqYcF9ADzh0GXsF5YFt6qG9f/ltRhuK+HifqeTGKWWtCeh4LNnJg6ozlE
	pvOnmYr/SnamjcAvKZ/4FzeeTVN1cYI=
Date: Mon, 01 Jun 2026 02:09:37 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Kunwu Chan" <kunwu.chan@linux.dev>
Message-ID: <1d19bb24fe6c1f6935ef078f7d7461e73590f21c@linux.dev>
TLS-Required: No
Subject: Re: [PATCH] mm/damon: fix stale TLB young-state handling on arm64
To: "SeongJae Park" <sj@kernel.org>
Cc: "SeongJae Park" <sj@kernel.org>, "Kunwu Chan" <chentao@kylinos.cn>, "Wang
 Lian" <lianux.mm@gmail.com>, akpm@linux-foundation.org,
 damon@lists.linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260531162457.98724-1-sj@kernel.org>
References: <20260531162457.98724-1-sj@kernel.org>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 09F1320002
X-Stat-Signature: hx4udj5o6qbwcga4b4g1rfbtznduks89
X-HE-Tag: 1780279782-519294
X-HE-Meta: U2FsdGVkX19w6RSXZCs0Yz1GNO8T+avRdjPvP+Vb3y/hQ0wWjjjavv4MCpcqqWiZED8Z8CpFBur4d7ZzhIdFlCRWwTPWfhlYlKNG5sMvVJEN1mXbflCVcz9LRDp7XSLlxNN467ayRq23a4rQqn5vj0UUBdHCQMWoe5M1rSqPJoqmEv1OWr+BjjuaJf+pFcsWPmjyg5KHCMoEqZ0j9jH8w35HychrWAC1B0v1VzXAy0r0eoNENx2iu33tbv4w7WRvxXZ17CFOmnD9nVVUzuhjaR9eVawJI5Ig+96isv86xb2+aHlFDgxSl2znQeadsMVVJW/pKmPjzynOAkFMsmoo1UgWFf26+vyKsAoAC8OEGQCe1HNiBr9Ib7li1+b6HlGjbHozzb1+RU7qxB4me7L3WTSXuY0vcahqSEHGk3fh9Zz5fya3HaGoM+1RIghy3/7BN8kzSR0WHN5KZu/HvU2hZkkvi/rZcqpLlxlPW8iQlY0tcwXaxX+DRhahc/64NWu8Wiyr8FWCoX0Vrrp5IWGiy5SfKwwAS2JSmV4PzN6W9Vm+YBhwtgUyAc40NC3qI2B0vaFtwkfOj7C1OL9h1z5aJ6ypNY4uWikvnTfHgn3N+/NcBeQlAeyk6BmeFUNONOVfDPyWn+Pp0A+fG7VE9pPYzy/ZMQpIXh21HeaZWP1wNGh/omjPOm6tXD5fyuwIyaWKnro72vaa+IhgH4YNIQ/2MzDO9Wrci5aF9EKcyOUoHU0MUcvTXdAvTv4vyUXkLZ4nFzK/2HqzRQigpuvZ0Pmo1W0NQLWv6dRq7njSnknhCzPQ7Q+yyovFXmf/kiHklGKXV2j35T41RGUtvKB47wxJIyEn//Plfp4n5NHchhqvqQWMjjtV+q1EkVP5wYH3FDIhpwa6J1RmlpscoKYK3Gx/imuya/D9doVfMcQ+jaGV00hxZaZzH05OK+g+w19NMXUdKmt70fzHUceV/PmJzx7
 Iq1H4YPH
 TIoBhqPecPWtPQNgHhlHe5tdBcSkvBsVJQnOKm9PfGr/R2iP+vg/qSPCKxaZFoGwlJZsEl2/2p2K8b+zE6nr78R6qnBGhYOHTVIwI3lCvaN8mEH147lt4LFo7G41ZuUJ2usKQluOex8P73IHv/UJR7l1PAnxdyHWXi+I5/6u4LMEfvx4dVnln6jtYq0jfTZ7vQzJVjSX8hItsax6CK4OAbu5k2L7r9b7RlJ4X/9Mlf5XKJ3z7ukMcYOFvKIfDKawxPmHYAur50AbQxlSbdPKAbbCfzvHIX7n3lni1oiP0QN/200Rn40yHUXwHYgHx1bmvLfLQaAdW+m4cmN48QoWq1pnTLQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

June 1, 2026 at 12:24 AM, "SeongJae Park" <sj@kernel.org mailto:sj@kernel=
.org?to=3D%22SeongJae%20Park%22%20%3Csj%40kernel.org%3E > wrote:


>=20
>=20On Sun, 31 May 2026 12:16:49 +0000 "Kunwu Chan" <kunwu.chan@linux.dev=
> wrote:
>=20
>=20[...]
>=20
>=20>=20
>=20> We think that makes sense. Explaining the rationale for not flushin=
g TLB,
> >  the limitations this can introduce for tests, and recommendations fo=
r
> >  choosing reliable test working set sizes would be helpful.
> >=20
>=20Thank you for kindly accepting my suggestion.
>=20
Thanks,=20SJ.

> >=20
>=20> If we later find cases where the documented recommendations are sti=
ll
> >  insufficient, we can revisit more intrusive approaches.
> >=20=20
>=20>  I'd be happy to help with the documentation work if needed. Please=
 let
> >  me know if you'd like me to prepare a draft patch.
> >=20
>=20Yes, please feel free to send a patch! :)
>=20
Will=20send it once I have something ready.

Thanks, Kunwu
> Thanks,
> SJ
>=20
>=20[...]
>

