Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E1265606D80C
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 21:57:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=j6BKfUG3
Received: by kanga.kvack.org (Postfix)
	id D10E36B05B1; Fri,  6 Nov 2026 16:57:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CC8066B05B2; Fri,  6 Nov 2026 16:57:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C01CA6B05B3; Fri,  6 Nov 2026 16:57:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9D3C46B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 16:57:43 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 1AEA01C242C
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:57:43 +0000 (UTC)
X-FDA: 85406056806.13.A9192B1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf28.hostedemail.com (Postfix) with ESMTP id 50583C0005
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 21:57:41 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j6BKfUG3;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002261;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UjgBmaYbtk3hDeZHleWHp4qTH9qs/UcQC70Eqqw69Hg=;
	b=ho868KhuQLVkwrS24lSLEWqCPRHb+To8uia3BG1AQDQKbEhFY4G7I1iOugCz19gvShz75A
	QdJA9Wz8odB8v/w136cmInx3NFcus2EnKAWnWD/jzjpE676y0+ZYnv+jaglV8UNmj42p6o
	f4u82LjFeYSWMrBO6IDA4fO9+hr4B88=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002261;
	b=zOet+7nRFGo39Bp0JE7a4UMyraAYcPKPx3tyL4NPpDZZkR+QCzFuhpdZvwJceAUF7vRFEg
	IebXGFL5V+E2U8N2MNUsyWKjMhi3OMqc2agxMQdv5zMYEHetiufc1WY1FQ7GaCkrHhMK6h
	NFtX/wSyRiNPMyBbjYLIIMlTp1opufA=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=j6BKfUG3;
	spf=pass (imf28.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id C012860CFA;
	Fri,  6 Nov 2026 21:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF2B41F008BD;
	Fri,  6 Nov 2026 21:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794002260;
	bh=UjgBmaYbtk3hDeZHleWHp4qTH9qs/UcQC70Eqqw69Hg=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=j6BKfUG3GaS0Vs9N8H6+JvGjgpMhMCu0xfZTiqVksMX1t+mOYMs03CAKwArlJQ5td
	 PMItW+thtQGDZMLzoBYFZYTcbjuf+WF/jMDk77D4Xa6G2G3Za/lx9B8DEj63WQhy1k
	 Jdd6h2l84mJg0uSz3s0MdkU+dYAnLgwfL4sLuYw8=
Date: Fri, 6 Nov 2026 13:57:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Carlos =?ISO-8859-1?Q?L=F3pez?= <clopez@suse.de>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 dave.hansen@linux.intel.com, David Hildenbrand <david@kernel.org>, Lorenzo
 Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil
 Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, Suren
 Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Shuah
 Khan <shuah@kernel.org>, Thomas Gleixner <tglx@kernel.org>,
 linux-kselftest@vger.kernel.org, Muhammad Usama Anjum
 <usama.anjum@arm.com>, Joey Gouly <joey.gouly@arm.com>, Kevin Brodsky
 <kevin.brodsky@arm.com>, Hongfu Li <lihongfu@kylinos.cn>
Subject: Re: [PATCH] selftests/mm: pkeys: wait for the child in
 become_child()
Message-Id: <20261106135739.113e4b432ecb6e92f62e37d4@linux-foundation.org>
In-Reply-To: <20261106164639.2959195-1-clopez@suse.de>
References: <20261106164639.2959195-1-clopez@suse.de>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Stat-Signature: r7yohknsmk56d7k6598p8jxcd76wgqpi
X-Spam-Status: No, score=-12.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 50583C0005
X-Rspam-User: 
X-HE-Tag: 1794002261-555204
X-HE-Meta: U2FsdGVkX1/m70LlE8kUoMvLvzF8NUJ2em/OiveB4Sny5vtAkO5l8eWOoJ2Xj5Kw3hI4FLbvg01h55W8IXjWIP4X6c0KbCBBaq54Yak1dgWRMI0XHKU80gR2BGRn3Cy7Ypu01rZBNSX3aZf00tfMX/sgz5knlCdGM/vgKxsHq2tsXADxJHz+AUjNUkj/7uut5dEwZlJfyD5zJsVY3mulDQQs3WSS0npI1Jt5gymdEM2KoqAPhynjRG8Qh9db/7WYQn2zYCDXeNaETPp90c7Hf3dUiFVyd272i0AzF5bjK2MRas1ECoTb+sm6cJ2QeWGXXrdCQ2xy0xk1PdXMVEIWcNhv7BQA9ke4dThkGoqYNlBGZleaJ1tb77kgOMjKo0Xvhli9bKD/5di+cQaAiCP7F7CHNHcMYOV3FRu9gM9Jek0RJoohtOqLWA0oh5A8HGHZpp1ZqFo+Hp4ZOzQJ713FYhq/uH3cuyy5UfWYtMP7giZJQRzDhOmzMoRvjaZbwybYCw2SyGH849MvJ4OXWZr4mGMHV/rAgfhsnDRcy547YI9k+H3+ffL8BpW/BVCrZEnePbYSNq+zRMvrAKQTfhGea33Ru9nyHRdPGZEPJ0C2oH9Oia4BNHwT4eBKauMxqY+sLmYFo7t8+7TLKdyHMaTAnok7/8Ct1iqbRWEQcKjQkGm1TIw/6GUB024/ny/9iTBwk6ab8svB43eMVXOXaAB2+RNo0vpah9w9LNw5p1m+LfEIID0bom/2mKvusKgizxuzzGV+wsKVCHvrA1/iXt0hY0Aai9nQbqzDwzbrxusFjo+t2LoLCIwqHRWgWERwEf0VW7vBVYjiDm4RkmQ4Cawk1HgeYnj+4rw034ChRjdd8CALHiR7iKBAABUJNo2ALNUfDqwWMU/NwBYM1jHYmPVewV/njyeKlOkTxMbUpX2YOtBBfHs+qF9cde1arHll7v6WH2yY17iiHSM7uu6oICT
 Loi+Q1QU
 W8vH4pyR/YaKUREnddt2Rvy8v4aZQcN6pJs4wL9XUwoRvTxOhfU8MBDevKNC0gGiznyhzSUbcLI1v01dVIw3ZPusNOkMOcTdtRIRChlj9RrnUnzB7XLsGilO9/k5Lhidbcg9L9rfhuhs5AjznyAcbWCS6eHsLz4h+/rC4qyGpfockZz6ncBSPQfJrIJzLxXDTGmm8V5WvGtbrYPquJfrMxlu65PjIVyxhIPVvHVQVLM2wLdx+aFVQWt0cf6rpyI1axq+f6Qj/ruovW8EUJX4P5mIoYvKI3B9YqFYxYOCXfvkx2y8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri,  6 Nov 2026 17:46:39 +0100 Carlos L=F3pez <clopez@suse.de> wrote:

> become_child() forks during test_pkey_alloc_exhaust() and has the parent
> exit, so that the remaining tests run in the child. However, the test
> runner only waits for the original process, so it sees the test finish
> early with a success status while the remaining tests keep running in
> the background. Failures after the first fork are thus not reported in
> the exit status, and the remaining tests overlap with the next selftest.
>=20
> Fix this by waiting for the child in the parent and exiting with its
> status. A previous fix avoided waiting, arguing that the parents would
> keep holding their resources [1]. Particularly, the parent keeps the
> hugetlb reservation of its test memory, so the child runs out of hugetlb
> pages after a few iterations. Avoid this by freeing the test memory
> before waiting.

Thanks.

>  tools/testing/selftests/mm/protection_keys.c | 16 +++++++++++++---

get_maintainer coverage of selftests is poor, alas.  So it's a good
idea to poke around in the git-blame output to figure out who best to
cc.  I added four new lucky duckies to this thread.

> --- a/tools/testing/selftests/mm/protection_keys.c
> +++ b/tools/testing/selftests/mm/protection_keys.c
> @@ -1009,9 +1009,10 @@ static void test_pkey_syscalls_bad_args(int *ptr, =
u16 pkey)
>  	pkey_assert(err);
>  }
> =20
> -static void become_child(void)
> +static void become_child(int *ptr)
>  {
>  	pid_t forkret;
> +	int status;
> =20
>  	forkret =3D fork();
>  	pkey_assert(forkret >=3D 0);
> @@ -1021,7 +1022,16 @@ static void become_child(void)
>  		/* in the child */
>  		return;
>  	}
> -	_exit(0);
> +
> +	/*
> +	 * Wait for the child to finish the tests and pass on its result.
> +	 * Free the test memory first, as it may reserve pages from the
> +	 * small hugetlb pool that the child needs.
> +	 */
> +	free_pkey_malloc(ptr);
> +	if (waitpid(forkret, &status, 0) !=3D forkret || !WIFEXITED(status))
> +		_exit(KSFT_FAIL);
> +	_exit(WEXITSTATUS(status));
>  }
> =20
>  /* Assumes that all pkeys other than 'pkey' are unallocated */
> @@ -1060,7 +1070,7 @@ static void test_pkey_alloc_exhaust(int *ptr, u16 p=
key)
>  		 * preserved across fork().
>  		 */
>  		if (i =3D=3D NR_PKEYS*2)
> -			become_child();
> +			become_child(ptr);
>  	}
> =20
>  	dprintf3("%s()::%d\n", __func__, __LINE__);
>=20

Looks good, checks out, I'll queue it up.

