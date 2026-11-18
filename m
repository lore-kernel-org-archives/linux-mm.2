Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C2F1606A32C
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 21:17:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=CZ0UWB1C
Received: by kanga.kvack.org (Postfix)
	id 839676B05DC; Wed, 18 Nov 2026 16:16:59 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 810B66B05DD; Wed, 18 Nov 2026 16:16:59 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 74F5A6B05DE; Wed, 18 Nov 2026 16:16:59 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 37D0D6B05DC
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 16:16:59 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 97A0B808D2
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:16:58 +0000 (UTC)
X-FDA: 85449499716.21.3F6B9B2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id DC8D0180004
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 21:16:56 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZ0UWB1C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795036617;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=elMilh5Urc3nCFS+RUfhOpJV/+vnxXF+1upUxylJAYE=;
	b=pnHeDKZ2Sb64hkd/sNcblmath6AUo28NG5GlTRFpmPqdFV6ZabBW0D4cIBpKzyAK+TPPTS
	tCL7ULUYKdnhNz/qEtuMoup7c3qsp6i/0bbgofCjHHkQ6zJ6SLW0xingO3aFhUyua0ED51
	TZka1XQvKRoxHZZqpbMo2ORX9QCKtBQ=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CZ0UWB1C;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795036617;
	b=RK0atC4OPp3h7OeoWSaVZ+gQWwUW5jgSZkkOaw1neUJcxduiantza3vXbCji258vJWwx9U
	ZRBZVIAolNELBrf833tRk5KrxecxnWdcNe+Q99lVqylg4l3wrXjxMdWb0fEmlytpeF9Udp
	ktCaDsstij9aWppKF+l/GJWzeUUNuAg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13BD247623;
	Wed, 18 Nov 2026 21:16:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 301681F000C4;
	Wed, 18 Nov 2026 21:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795036616;
	bh=elMilh5Urc3nCFS+RUfhOpJV/+vnxXF+1upUxylJAYE=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CZ0UWB1CzSleot3QwOeZbp8PwcbgDa0aIrUtgiuDt8tWJgqJJ2w73ok30uCdrEwde
	 SdPhHz89PPPrHfxRPVi/w0wRl4e8LZwO/5olFpCnindtEBJbk+BPhMMxtKq0VuoB47
	 CcUy6LePNui1m1kVwou1KQOeSekrh27gpn8aDVvdZb+GqGNm/QQExwnXiRWZFwmD0R
	 Bb/F2EqgDGggNE9boesnEvGYe1bMkWrtSGRn+0nw9ENm5t2fuMyoeW5i36/N3GuouN
	 1y9ccok8ux4d6oqb3aIHtkooC+Ot3AwuM1UI6e6WymQ+MFJ557zJlUsLclSh6D01Vl
	 PCLGdoFQhcu3Q==
Message-ID: <sashiko-outbox-221983@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 1/2] [v2] mm/mempolicy: fix copy_nodes_to_user() for odd
 inputs
Reply-To: sashiko-reviews@lists.linux.dev
To: "Arnd Bergmann" <arnd@kernel.org>, "David Hildenbrand" <david@kernel.org>, "Gregory
 Price" <gourry@gourry.net>, "Andrew Morton" <akpm@linux-foundation.org>, "Arnd
 Bergmann" <arnd@arndb.de>
Cc: larips <larips950@gmail.com>, "Zi Yan" <ziy@nvidia.com>, "Joshua Hahn" <joshua.hahnjy@gmail.com>, "Rakie
 Kim" <rakie.kim@sk.com>, "Ying Huang" <ying.huang@linux.alibaba.com>,
 =?utf-8?b?TG9yZW56byBTdG9ha2VzIChBUk0p?= <ljs@kernel.org>, "Brendan Jackman" <brendan.jackman@linux.dev>, "Johannes
 Weiner" <hannes@cmpxchg.org>, "Jackie Liu" <liuyun01@kylinos.cn>, linux-mm@kvack.org
In-Reply-To: <20261117211635.2472067-1-arnd@kernel.org>
References: <20261117211635.2472067-1-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 18 Nov 2026 21:16:54 +0000
X-Stat-Signature: uasia1wy1j6nru3y1k4ah8uhgdiq8q5g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: DC8D0180004
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1795036616-747046
X-HE-Meta: U2FsdGVkX1+lle7bcWfU1X6xpon3lwz5fQDEqBV/r719F6uLMkjiiQmNAQu9SIQuCRpemOy3nKCPL5NTo8BKOFYZd7G2T0l/np8XTO1DPiiMXnWcvjkEcXv8vvJVQa2lZ6oLR5B3QZRm5+skizzaXj2LCYckg6O3+9GjLs36sNdbdA6BwjZIyi7fDDyA6K82u9E4zypJCfvp1trCDYk2w7C5MEdVF7n7g2N2yCPfh7nxd96MIHAoTyBos4SMmaZxq8BiBvIf9GlYIJjjRJsTKdMJwLDwkJ3slFjpuYtkUxDzB/kSPUoTy2ctORgnGNKvGiq93ie+03hww/RdRDcZFHJyixYtAAzqppeAkDQ0+GYrCh5x9/WLOFVVumDq1qJ6BtULGCjKdFODvFg1FwvfCMULp/NP7BpapJZHAQ7k7CFLtIIG6PcC8mnRCtt4tRMpb2zZ5at6ZF+ewHumk9lj1DPyElme0o+co1UjujotOqH8kRjP376lRQwHA/W1L2VyxzsVtRDDMz30kJTJJt1ZHa5xKcgIIMCkh/HLY2dkAIfrOYGq+7KLuQQu6dljjfiKmrJhtOuabqQJxbUiegKZ9QrETlPBoiXSODUww6OXczKOtpP5ooRaX7OzngbZEQbvbrYcMn87/QCkHru/KF7jPouBJVlzjCHGKtG35UdCNUtoGZnVF4dNYVWjyJqCmTQTSODuRZETehUshgJCiutAwfr+ZiKZYAK+UcUXYTJK5ah8232N8NuHHIxSJEBmFKRp2rnoupTfzad5iFWe+fZv+c5PGBSbruRWc3pqfciRD7lak7k9IoYS7EfRdW7jmnHmiRYY5L8DUgcI9I3JFjeEBt1zZwegOsy5ElVDWnED2ZuJfT28oB5vYdOsgOumORpH5HkVENiBDe0QqV4Pez3SYK0hPwUS3N4/N+sr3QHPofLac3rELiueEpZPissw5n6vJcMqdZ2t5p62SyUvQHq
 UcnTHF0f
 RsN8h904Ax55rmXK9wFGJwKY2XKJ5SJ1gMPTOIaAzGuoYJF4Qxjp2xaosmxghU0K9T2r34nRxHANpM1z8QJ+TuIcATdylnoAvy3tGRDLSxVBjgxyTqSHv/vYFqrMutU/D2cdg/zqiHaGRpQXOuiTllg6zQMIC4xPKemLDfLTA/IzrjKHQYOBTOXk1n1TkCj+oWFU17Ud0GRr5vMBC3ByYbW5DM3F6zJC5BW3XJR3MFDyoh60ivqbe9gg+EPsNw/Y8YJu/GQezjsAEtBE33hJn3JV+U3e29Hzf0l4FfUoezJwxEcDveblISo68EpLtni9hGqffeKggils2iLLJIu9dq9ZIIn1YE8cJ2hlEaH+qMgXEvqY4ZJF1m1oqGa5M76PYg6QY54tommN6Saw6Vn2/1zhcQzzgRGQiiX3sS8Kux9LEBVG731ekNlwlSFkwAFOOgjrBp4fsdoNMb2MGlT8ivd51Lj7F9tcI98FYwR7vRcYLThAA5uxgzRZLQotNXMp3C+DGyP/CXG9wfNiJCkjRGLJu/ZsNX9RjkINolwtU0iQNDcw5IhClGpimTCsj9813nkIf7oSJEpB47Gh+b0PoT/0xfU0GcYae9fnfSc/ULHqfBUwn27nyfm0kazjyRFK+KQw9iOiLv1ljHDqRDy1zkW5nTKqXt3ZStlq1CSGAWauH5V3xvNJN/q47zv+SL5z8e9aw0HcpUZHxnI6XWYNWlb1P8cw3gu2a+iCvabMvFABT6CiANoo0CFR0NbOzI+31Zsmu93wzAZveb0xBzKlEMq0pZVuMwGPngzT2faSzxxGVZ0sp+b1bWGNMKw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/mempolicy: missing compat nbytes update in
  copy_nodes_to_user()
--

commit 8559c85c3c122388b2f3048335523c715d5cc2db
Author: Arnd Bergmann <arnd@arndb.de>

mm/mempolicy: fix copy_nodes_to_user() for odd inputs

This commit fixes the copy size alignment and the maxnode off-by-one
calculation in copy_nodes_to_user() for native and compat callers.

Link: https://lore.kernel.org/all/20261117101910.1820066-1-gourry@gourry.ne=
t/

> diff --git a/mm/mempolicy.c b/mm/mempolicy.c
> index fb627b37afcbb..c10f9d4ba38f8 100644
> --- a/mm/mempolicy.c
> +++ b/mm/mempolicy.c
> @@ -1720,12 +1720,12 @@ static int get_nodes(nodemask_t *nodes, const uns=
igned long __user *nmask,
>  static int copy_nodes_to_user(unsigned long __user *mask, unsigned long =
maxnode,
>  			      nodemask_t *nodes)
>  {
> -	unsigned long copy =3D ALIGN(maxnode-1, 64) / 8;
> +	unsigned long copy =3D ALIGN(maxnode-1, BITS_PER_LONG) / 8;
>  	unsigned int nbytes =3D BITS_TO_LONGS(nr_node_ids) * sizeof(long);
>  	bool compat =3D in_compat_syscall();
> =20
>  	if (compat)
> -		nbytes =3D BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t);
> +		copy =3D ALIGN(maxnode-1, BITS_PER_COMPAT_LONG) / 8;
> =20
>  	if (copy > nbytes) {
>  		if (copy > PAGE_SIZE)
> @@ -1733,12 +1733,12 @@ static int copy_nodes_to_user(unsigned long __use=
r *mask, unsigned long maxnode,
>  		if (clear_user((char __user *)mask + nbytes, copy - nbytes))
>  			return -EFAULT;
>  		copy =3D nbytes;
> -		maxnode =3D nr_node_ids;
> +		maxnode =3D nr_node_ids+1;
>  	}
> =20
>  	if (compat)
>  		return compat_put_bitmap((compat_ulong_t __user *)mask,
> -					 nodes_addr(*nodes), maxnode);
> +					 nodes_addr(*nodes), maxnode-1);
> =20
>  	return copy_to_user(mask, nodes_addr(*nodes), copy) ? -EFAULT : 0;
>  }

[Severity: High]
Does replacing the compat nbytes assignment with the compat copy
assignment leave a 4-byte gap in the userspace nodemask when
BITS_TO_COMPAT_LONGS(nr_node_ids) is odd?

Without the compat nbytes update, nbytes stays a multiple of sizeof(long)
(e.g., 8 bytes when nr_node_ids <=3D 32).  When a compat caller passes a
buffer with copy > nbytes, clear_user() zeroes starting at mask + nbytes
and maxnode is clamped to nr_node_ids + 1, but compat_put_bitmap() aligns
maxnode - 1 to BITS_PER_COMPAT_LONG and only writes
BITS_TO_COMPAT_LONGS(nr_node_ids) * sizeof(compat_long_t) bytes (4 bytes),
leaving the word at nbytes - sizeof(compat_long_t) untouched.  When
copy =3D=3D nbytes (e.g., 34 <=3D maxnode <=3D 65 with nr_node_ids <=3D 32),
copy > nbytes is false, so maxnode is not clamped and compat_put_bitmap()
copies the upper 32 bits of the kernel unsigned long instead of zeroing
that word.

It looks like the if (compat) block needs to set both nbytes and copy (the
follow-up commit "mm/mempolicy: use put_bitmap() instead of
copy_to_user()" has the same issue in put_nodes()).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261117211635.2472=
067-1-arnd@kernel.org?part=3D1

