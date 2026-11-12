Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05F78606A326
	for <linux-mm@archiver.kernel.org>; Thu, 12 Nov 2026 00:31:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DEOCs/+z
Received: by kanga.kvack.org (Postfix)
	id 08C5A6B05B2; Wed, 11 Nov 2026 19:31:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 03C376B05B7; Wed, 11 Nov 2026 19:31:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E94DF6B05B8; Wed, 11 Nov 2026 19:31:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C37D36B05B2
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 19:31:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1265B804CE
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:10 +0000 (UTC)
X-FDA: 85424587500.01.A820146
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id 70BB61C000A
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 00:31:08 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DEOCs/+z";
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794443468;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xlKJOxJwDcDpLQLhphR53KExe+VBxV3WdYySoxbnvIQ=;
	b=ZcupY5X3J6P45wV2GEz0WFdD7ghU7eiMjOtbfO6Us1OhEx0JLugQXq6cEnWyOt0L6DSBV/
	uFqw15DRAVXYXDl/QhVXof5nv9BOoh1T2D5D6zI/Qif3CG5FpMKt3vIZuqqcielRfxyAJD
	F4+BTUVur0bU43h6mkCfYmth4fVbltA=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794443468;
	b=BRkc9QxMbtSsugT8gFA5d753qTwyKUr61j+tpcMaeUUjobC7QwD/9DFJCMPQ7VstA4KQ8c
	8Ba+njIfLHDVWJGABru2dH5erQqyYIDzgagRU4EFBr1sRoYeo06bWThpq984TxdDn4U2jz
	Hj1cSmerd3BcCpUUZDBPCvKwG+lKjQk=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="DEOCs/+z";
	spf=pass (imf18.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 271F060052;
	Thu, 12 Nov 2026 00:31:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC02F1F00A05;
	Thu, 12 Nov 2026 00:31:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794443466;
	bh=xlKJOxJwDcDpLQLhphR53KExe+VBxV3WdYySoxbnvIQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=DEOCs/+zFVM192K2WMD+q0DOyl/z//SCCLcXpZHm/s42i42mIs4YP1ZYIaZC4/m6U
	 DfO3fvbGCcuOehyg3lfbYjJ6pBeywejxOjQkjW1n1bSJnxeJSY2zOdx8sqODlembuG
	 wsnDSBUd2oWvLC7DIC5uFfDoDk1bs1gDjtm/o0v/SEfeOflti6+a8mDf6lnz/3KEP8
	 9PZMunPdzUuQW0uSJcbMD6Zxp1367PclMF37eEZ/l1W7rKEEXCWmgbAgsY/kL/4nC+
	 anBO2xOl3mcdvnQ8hByZ+Um972jprtoABszUYDazNHMOcU0I4tgBlG6MszAbLk+mIf
	 +MPO6LnJtzILg==
Message-ID: <sashiko-outbox-209934@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v4 02/19] liveupdate: Pass user argument to file
 preserve and retrieve
Reply-To: sashiko-reviews@lists.linux.dev
To: "David Matlack" <dmatlack@google.com>, kexec@lists.infradead.org, linux-mm@kvack.org
Cc: "Alexander Graf" <graf@amazon.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Christian Brauner" <brauner@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Hugh Dickins" <hughd@google.com>, "Jonathan
 Corbet" <corbet@lwn.net>, "Liam R. Howlett" <liam@infradead.org>, "Lorenzo
 Stoakes" <ljs@kernel.org>, "Michal Hocko" <mhocko@suse.com>, "Mike Rapoport" <rppt@kernel.org>, "Pasha
 Tatashin" <pasha.tatashin@soleen.com>, "Pratyush Yadav" <pratyush@kernel.org>, "Randy
 Dunlap" <rdunlap@infradead.org>, "Samiullah Khawaja" <skhawaja@google.com>, "Shuah
 Khan" <skhan@linuxfoundation.org>, "Suren Baghdasaryan" <surenb@google.com>, "Vlastimil
 Babka" <vbabka@kernel.org>
In-Reply-To: <20261111002358.1842967-3-dmatlack@google.com>
References: <20261111002358.1842967-1-dmatlack@google.com>
 <20261111002358.1842967-3-dmatlack@google.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 12 Nov 2026 00:31:05 +0000
X-Stat-Signature: 5qf9b1gjp9kupnkz5esz9k9p7ba5y1eg
X-Rspamd-Queue-Id: 70BB61C000A
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=unavailable autolearn_force=no version=4.0.1
X-HE-Tag: 1794443468-896531
X-HE-Meta: U2FsdGVkX1+4aDjjSu5vnsMdi15omyyopeUIjmmnPsvajgKEDGjPgkuQk+HZsYElVxsl2Mv0SxofNt6K3sSXSwQY2ff3I98bh/8Yi0FRKTsLOy/Iwk/0QrZaUuvSLZv7/n0fhD8NxgtkXh6Q0aXwVNjrBinbouAebqJn/Y4OWh+8cFw5ALCsDboG3jq2X6z3wvg7eUtpocOf/t1Wgb5Fu9ScFCPecZlDjWziK+IZf+EF3lEsyDYCQeGFS38oxnYcJmlGyVKJAAGZ/WsKc+afgS5e8hv8e08hH71bmlaU+oPt7gaMTcD7YjW34s38+mcSwaZXr6kehhxfuKhQzfg6WWk6KpPbNYX1cFncRARlf9qyFekAalo+UHArSNXeTdBRxVVY7hnqP7S753SqvZCxPtld9zH5PSIz5u8rz/fdeatjxC25gQkEeR7AiTHICVHJnNl9EfNLvPxgim2OLfVjJMb8e06z1ua0N+vOE+SMIS2nlcQVjXRau0RcExehlrug59+7xU7RHsYaD/qekj7w0fUU70ktzhzRkz5Mp8uWl8B/Wf0IgfFLNKKneQPmjq/aFLXW4VGJ+T4OKc9Wt/7a/RWnliWTaupIAFM1CAUdE1X0Gx32D5aLbsgb0UvA1nvBcX2tepOPhef5UCzYkiIzyppGQA5N9U4CZQCciilCvCrk+ptUubJK52IEs90zdZ/flZ4d8yiJEZc/HLHma+buTXHE9kID1j6G7s1oXwluIptK8gLkGG4sJSAib6oKdbypjdTzHLt1xGBQP9iWt2buA8q2SZORr2MFIyZtu4PV/QR4yYXUkmixu03yep3lsTuIigZc+Mt5a5pUkDf81XNc/ECgJp2ESjhuVrXZzgQyEfzOQ0vPbKMHsX4o5epbEn6lHLQWMqzN4rWtr0NR6uUcyHFfnRHsSpajXDgYc/UWsI7E2qvRZDcm5nW4KUeqQXzZQn5GaedrplFLGPTSCFb
 RxqEgs9K
 EJGRMtIgty8z6UVjU6OAsy3aYBt98c/KuBHtQ/qDbP3o4jm6nB2jb0Jg3o2U0frQfGVml0mB6Co2O5GG+sLM+YCl6xXoiz+mYfou68DutoyahPuAXh36AMzXupGnpHWmYKvWkIFEdaDvHJ54ya1zseAyjj2Xi4WuDdMfCvw7X0uCE+UrzAhV+yihCHUEb4hbXOHAMEACPg7oTkPNlRDN3MB005PvKs1s4+m1Xbactj22O50RznixPfldCknADSjX2upqN21t1P0R3B+lHFCQw+AoGC37Mt7T/FwIJE7Wh+uLGDHQEWN2dKdrmmsVIoBhzQXlMh2nM1oCIkPJOrTN78QMnWW0gGFx3QZyDYKUZ1yQwzJOCFdWwK8bl9b/DDFQu9ckED2LCo3ZAy1i4MX4aRohv6YCJgtnbDbcVVqHRUlnuuOaP5i10Aq+0w/8xKvLYz4W5PE2T/KVREIXDy+xli6M7yWGz6beCvTDkQV6iXQtA1uaxnXoHY8TZaRhNo/NULN6byb0723j54PPRRYLr5VZOj6hOiAwHHqmpKfsTKGIrToVe7LF9gXkScyaJJjGE5nyV2mpDG+PXL72Bs6/xAOBxGwpiI9Nqx+o+7/e8bo/iODYxkX+SRF6FD7CRNikskouqcJzLikAgp1s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 2 potential
issues to consider:
- [Low] liveupdate: pass NULL instead of 0 for arg in
  liveupdate_get_file_incoming()
- [Low] liveupdate: initialize __free(kfree) karg at kmalloc() in
  luo_copy_user_arg()
--

commit ce30d6f92617722b3b0681f0c0fa88542091865b
Author: Pasha Tatashin <pasha.tatashin@soleen.com>

liveupdate: Pass user argument to file preserve and retrieve

This commit extends liveupdate file preservation and retrieval ioctls to
accept a handler-specific user argument structure, validating and copying it
into struct liveupdate_file_op_args for the handler callbacks.

> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a42b60356d523..1437630d435e6 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
[ ... ]
> @@ -202,11 +203,43 @@ static bool luo_token_is_used(struct luo_file_set *=
file_set, u64 token)
>  	return false;
>  }
> =20
> +static int luo_copy_user_arg(const void __user *uptr, const void **argp,
> +			     const struct liveupdate_arg_spec *spec)
> +{
> +	void *karg __free(kfree) =3D NULL;
> +	u32 user_size;
> +	int err;
> +
> +	if (!uptr)
> +		return 0;
> +	if (!spec->size)
> +		return -EOPNOTSUPP;
> +
> +	if (get_user(user_size, (const u32 __user *)uptr))
> +		return -EFAULT;
> +	if (user_size < spec->min_size)
> +		return -EINVAL;
> +	if (user_size > PAGE_SIZE)
> +		return -E2BIG;
> +
> +	karg =3D kmalloc(spec->size, GFP_KERNEL);
> +	if (!karg)
> +		return -ENOMEM;

[Severity: Low]
Could karg be defined and initialized at the kmalloc() call instead of
being initialized to NULL at the top of luo_copy_user_arg(), following the
Cleanup API convention for __free() variables?

[ ... ]

> @@ -995,6 +1052,6 @@ int liveupdate_get_file_incoming(struct liveupdate_s=
ession *s, u64 token,
>  				 struct file **filep)
>  {
>  	return luo_retrieve_file(luo_file_set_from_session_locked(s),
> -				 token, filep);
> +				 token, 0, filep);
>  }
>  EXPORT_SYMBOL_GPL(liveupdate_get_file_incoming);

[Severity: Low]
Should this pass NULL instead of 0 for the const void __user *arg
parameter to avoid a Sparse -Wnon-pointer-null warning?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261111002358.1842=
967-1-dmatlack@google.com?part=3D2

