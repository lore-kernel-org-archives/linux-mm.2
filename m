Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D313606A31A
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 11:40:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=h33VLacb
Received: by kanga.kvack.org (Postfix)
	id 2F2B26B020B; Wed, 21 Oct 2026 07:40:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2CA8B6B020C; Wed, 21 Oct 2026 07:40:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1E7696B020D; Wed, 21 Oct 2026 07:40:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id EC8196B020B
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 07:40:33 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F1ACE120505
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:40:32 +0000 (UTC)
X-FDA: 85346440704.23.2ED19F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id 4E46480007
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 11:40:31 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h33VLacb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792582831;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hRvoRPccK0ObKuMf62aLb3R3R+A968xeDh5CRkvKhSM=;
	b=TNdpiefT0Hdm42q+DHLDJZqMgUmxvu6UNzHd1wBPvE9PjenStgPNAgU65BLgR1e6JJjecT
	xboe8nm9+B/bAbrfNjjyjUQMQG1AtORmbCL1G9NXsmQhFlA3fOODWFxWO0qP0+75tDD+8x
	3HKOGTbIhuofXI6rEasBKMNbgKWyifI=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=h33VLacb;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf30.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792582831;
	b=ByZXDBpj9iGZ3ZLMhQzHToBkrwsIktgBoOnEnlzopSEmRGmBhFLYX8duoXpe56367f0TTp
	8glzYcHA84mzjLguxWwsQrcFdEC8B4eFN0CKHKB0KTrGWmp/77mNffloGf/bWi9G1ybkt9
	n8j8wBGgYLHIp8aF+U9I6FslxPInH6U=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 673FA43AC0;
	Wed, 21 Oct 2026 11:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18D781F000C4;
	Wed, 21 Oct 2026 11:40:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792582830;
	bh=hRvoRPccK0ObKuMf62aLb3R3R+A968xeDh5CRkvKhSM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=h33VLacb4OUhHA+wtY+sI5cKdIF2czPPGRkYnihor+xX2FmPSsm/mqo/QiZqMFjow
	 AWYjJG36aosVWVeXvHZChQ5jWXg+Q+oR2yr5m/DQhWJEZIiWeIdlNTiAofFOB5pyNg
	 4W3Wdi2W3qApZEwrYm7vcqQ4veFz9Xnou+P1J97+XeyCUi2dle9mB+e4iR983+W2Yc
	 9FbNOcVqAvzhSOstPejbBtPTzeuxZvk5ysHsMmFyxOGwgx3f0frTjmVSMMS0M4XvN/
	 VsBg7vOfqimxPriV6iNz/idPoeoE5TeH0UpoQ7OqFzLNAV5J07eXOSiZYho022gVY8
	 dqGkF2mK39x3A==
Message-ID: <sashiko-outbox-180175@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 3/7] mm/page_owner: add bpf_iter target "page_owner"
Reply-To: sashiko-reviews@lists.linux.dev
To: "Zhen Ni" <zhen.ni@easystack.cn>, ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org, eddyz87@gmail.com, memxor@gmail.com, martin.lau@linux.dev, song@kernel.org, yonghong.song@linux.dev, jolsa@kernel.org, emil@etsalapatis.com, ihor.solodrai@linux.dev, akpm@linux-foundation.org, vbabka@kernel.org, surenb@google.com, mhocko@suse.com, brendan.jackman@linux.dev, hannes@cmpxchg.org, ziy@nvidia.com, shuah@kernel.org
Cc: bpf@vger.kernel.org, linux-mm@kvack.org
In-Reply-To: <20261021112437.1799213-4-zhen.ni@easystack.cn>
References: <20261021112437.1799213-1-zhen.ni@easystack.cn>
 <20261021112437.1799213-4-zhen.ni@easystack.cn>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 21 Oct 2026 11:40:28 +0000
X-Rspamd-Queue-Id: 4E46480007
X-Stat-Signature: 5daw9po8pzicwswaijhetc1aw77iw8yz
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-11.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792582831-474874
X-HE-Meta: U2FsdGVkX18qrnE5K90n7ptA6X2OpFEhP29T0sNQUWK87pwNcccv+f68UTcj/A1hFim16Uw9jptdGdOFYwlGKrvyRUtHsHqZt9Vuq+nS2dwOgNy9OUyy5E2mLnG0OWetNKANzv3YO3kLQnh6K7F1p+9UOAU1CAwAstg1tls5hHWHR4adpSlS12IuIAMkF+h/HH3dvaGqCvnHMESbJJqfBeQYquoY1007D1A/5mCsUYIQoQvcMBtdD8eFdFHI+OOaSfTkuQKr0ZmPWtPhml6mgtgmwEP/Vrx8AvKlnx3BcC17nOz/IRDSbqp1/7KO+wImfUpJINxaGLANNvsjCABch+IqT5ypqpWM6Vtvo3l2H7cvVuxUDQXc7Xu7NvHRbFMLqYG5NXsa+smcRv6RWT7M8U/X2TTGu3fkRXjxapAjcUk5NiEvi+SV7J7bOhhdL/7F7LEAqaPhBszQcLOgX5czVqUyi5ty03wQiUUY2nSYKfAWnFye+FgaUFyX2X6tGvDD+9tTMNMeRD8zevDP3raFXhAkI5YcKeqntLZ9PhQuJHPks9B3xMDIO4WmLOxWw1bVv78GyfnbXnfhdCuZAdNBHsFJeeOsO8RBg1Fj79/mzDbV0zCmQZxoA6jT1BjIrJAiLP0ZmVTocz+uzwsbyt4fJtJRVmFoEc6MvsqvGHzxiOebMKrF88UwHoRRNYVCTcqiz48U1MoQg9Ty7m9rWbqGmkBk9kB6ushlZEnSskkjGkMweFvXNiWF4Xr4QxIsYnVapSFOksPyky5Oep9xH19Wl8+XliHQ6uzqIzcRjRXK1+GI5yvmrxHcqxyl3+r8BS2Cl24C6yf0Xzmo18JH7gldgSHNZgMEu42OPV6BFTGZ2C8hvovIoTezmSeg76sdBdx0lZU9PGk60M0lASuc0MZKccE8q+v4767yOE3pdtiozIDG/f3KjP3OeLpGbJ2aghH3jb/eKiJHtkl1kUovm34
 90vN4qJb
 zlzMZgtIHeVnpH4gdWpHJw5BF5suWdZi3Xw4UAWS7JR/ijeqTsGkle4/1qxoK6C0vQWSEpH4bPd8L7raXTzcz/vNAbtHPz2ISYYp1qNPjBM2OWBti9WLzC9iS0m0l1dEC9ZGHvloPJI6g4Fi9BoB9Tcm7569dtyDRHsISr/vyD3w3Zml5yCxxd7cUQT4gv+tlzJ2uBCJvhyCSlTvcHh1BykMvN8lhaGDINpAyZBFZ9ZeSnzT3GXxTk+RgVFwGpF19vkLYLcPI4+ZuUoK8ksTXLwMOH0i9VvwOY4WIQ28HeVdm/zEhXjKJUIaBA9TYmYENcjPqFsjqdQrvs0IvNRij6/ZXINQewIlC6QiysHMYdQfuEK23on0KSDOXZ776MvAbAd4+d0FfPZ2pgsRUzQpdLR2DvvBZS55T/4lQ9fZtf8bHQITuzVXv8eMb1BiXHNITBrN2kAHoTBJxEFkVvsuZ79GnEf2a2vBLgxuww+1o5x2W+Upxwhc1UCH514PWLZo5HJzW27yAj1uYpHR3CkIoaLGW3vZVj3ZXZDfZqU4uA6TwXvPjsOC3Huv263ZrAhhzrIjcfsabiI33pyuU+NoDn7Z7/Eu8vq+fPIFrtf4qWsE5/MY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] mm/page_owner: rescan and post-stop show() in page_owner_seq_sta=
rt() at EOF
--

commit a6ba125169596a18417440d179f83a946227810e
Author: Zhen Ni <zhen.ni@easystack.cn>

mm/page_owner: add bpf_iter target "page_owner"

This commit adds a "page_owner" bpf_iter target that iterates over pages
eligible for page_owner output using page_owner_next_eligible() and passes
the PFN and a snapshot of struct page_owner to the attached BPF program.

> diff --git a/mm/page_owner_iter.c b/mm/page_owner_iter.c
> new file mode 100644
> index 0000000000000..529b2c4a589a9
> --- /dev/null
> +++ b/mm/page_owner_iter.c
> @@ -0,0 +1,118 @@

[ ... ]

> +static void *page_owner_seq_start(struct seq_file *seq, loff_t *posp)
> +{
> +	struct page_owner_scan *scan =3D seq->private;
> +
> +	if (*posp =3D=3D 0)
> +		scan->pfn =3D min_low_pfn;
> +
> +	if (!page_owner_next_eligible(scan))
> +		return NULL;
> +	return &scan->po_snap;
> +}
> +
> +static void *page_owner_seq_next(struct seq_file *seq, void *v, loff_t *=
posp)
> +{
> +	struct page_owner_scan *scan =3D seq->private;
> +
> +	++*posp;
> +	scan->pfn++;
> +	if (!page_owner_next_eligible(scan))
> +		return NULL;
> +
> +	return &scan->po_snap;
> +}

[Severity: Medium]
Can this rescan PFNs and invoke page_owner_seq_show() again after the final
page_owner_seq_stop() callback has already run?

In mm/page_owner.c:page_owner_next_eligible(), scan->pfn is copied into a
local variable and only written back inside the loop before checking
scan->po_snap.handle:

mm/page_owner.c:page_owner_next_eligible() {
	unsigned long pfn =3D scan->pfn;
	...
	for (; pfn < max_pfn; pfn++) {
		...
		scan->pfn =3D pfn;
		scan->po_snap =3D *page_owner;

		if (!scan->po_snap.handle)
			goto ext_put_continue;
		...
		return true;
		...
	}

	return false;
}

When page_owner_seq_next() advances scan->pfn past the last eligible page
and calls page_owner_next_eligible(scan), the loop reaches max_pfn and
returns false without updating scan->pfn to max_pfn. As a result, scan->pfn
is left at the PFN right after the last hit (or at an intermediate PFN where
po_snap.handle was zero).

In kernel/bpf/bpf_iter.c:bpf_seq_read(), when page_owner_seq_next() returns
NULL, bpf_seq_read() calls page_owner_seq_stop(seq, NULL) (running the BPF
program with ctx.po =3D=3D NULL), marks iter_priv->done_stop =3D true, and =
flushes
any buffered output in seq->buf to userspace with a positive return value.

When userspace issues the next read() call to observe EOF, bpf_seq_read()
calls page_owner_seq_start(), which calls page_owner_next_eligible(scan) and
rescans from the stale scan->pfn up to max_pfn. If any page in that range
was allocated between the two read() calls, page_owner_next_eligible(scan)
returns true and page_owner_seq_show() invokes the BPF program again with
ctx.po !=3D NULL after the terminal ctx.po =3D=3D NULL stop callback has al=
ready
run.

Similarly, if the initial scan finds no eligible pages (*posp remains 0) and
the BPF program writes output during page_owner_seq_stop(seq, NULL), the
follow-up read() enters page_owner_seq_start() with *posp =3D=3D 0, resets
scan->pfn =3D min_low_pfn, and rescans the entire PFN range.

Should page_owner_next_eligible() update scan->pfn =3D pfn when the loop
terminates at max_pfn (and only store scan->pfn =3D pfn on a hit after chec=
king
scan->po_snap.handle), and should page_owner_seq_start() also ensure *posp =
is
advanced so a follow-up read() after an empty scan does not reset scan->pfn
to min_low_pfn?

[ ... ]

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261021112437.1799=
213-1-zhen.ni@easystack.cn?part=3D3

