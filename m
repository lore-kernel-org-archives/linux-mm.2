Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22D74C9830D
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 22:56:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E3F36B0096; Wed, 23 Sep 2026 18:55:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 195526B009F; Wed, 23 Sep 2026 18:55:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0AB1D6B00A0; Wed, 23 Sep 2026 18:55:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAE106B0096
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 18:55:53 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 6CA2BC018A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:55:53 +0000 (UTC)
X-FDA: 85246536186.11.C3C13B4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id BBD0C1C0003
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 22:55:51 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsCpPBhU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790204151;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y/8cCai3+gMWO6LIo701U/Zh4RgUpa9pwpp5h99P4sw=;
	b=5W2OQdeXe3JoBQXAAfdrbovDl0ZdyHXld9uHjjDkS56sZdD4WFyUPGiPd02KaCOTRFPA/i
	23lD7GKZl7TNbqB/kg1CukRQpUggWgQfbm+dXy0XKK1aJzsoQayGWN9eJqr8fNWrqLPBtX
	71cvsueMl4j/oN68MvZVnSet74IbAk0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=CsCpPBhU;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790204151;
	b=C0Xe/n/RCjNfvK9hsZcMCCz5jLHETrDHbZHYT7W7+7yzu+2/v68La2ZiL1Pv7GRJbGU3dz
	+M4ybZJNST1BjhIUB4Q29p3vx+TtFt2K4mMMUQgBL/0n1QNnrMgwPeasMlCdfO7PeZ3mT/
	Na3l9aVhMv87s6i2OXBe7ncJc7b0qn0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05FF341A08;
	Wed, 23 Sep 2026 22:55:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32AC21F00898;
	Wed, 23 Sep 2026 22:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790204150;
	bh=Y/8cCai3+gMWO6LIo701U/Zh4RgUpa9pwpp5h99P4sw=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CsCpPBhUck5u9x5fqVL0K/bW6iAUQ97QJJMFy1hh6nDVhkPc77hjwuwNSu3o3/98A
	 fgk6cddigQYs+obUykSIkWJeH3tjG6j7cJmd6aLY3VpU9bH/XAQVff/t/3Pk8gwxAL
	 KD1ck/Yubn1NJCbxKm6s8RcwpyW8yn8/21uwh0wXi38NgncvXpKgOB6U2Ng1lGbnSE
	 Mye7fHN/UA/h1vLqlt0v3wJr+17DZC8pRp3WSsIPERTefWpHHIf0EqvAQugfGEbRgH
	 3MxDk4HzIMoRUK3eRXuLqtbIIRVHpFEqYbxoK2kQWMoqvW6M6r+gZfmmPzG+DyBSmz
	 WEAzPHfNEjGZw==
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 1/6] liveupdate: luo_file: look up outgoing tokens
 by id
Reply-To: sashiko-reviews@lists.linux.dev
To: "Pasha Tatashin" <pasha.tatashin@soleen.com>, "Andrew Morton" <akpm@linux-foundation.org>, "Samiullah
 Khawaja" <skhawaja@google.com>, "Pratyush Yadav" <pratyush@kernel.org>, "David
 Hildenbrand" <david@kernel.org>, "Alexander Graf" <graf@amazon.com>, "Baolin
 Wang" <baolin.wang@linux.alibaba.com>, "Mike Rapoport" <rppt@kernel.org>, "David
 Matlack" <dmatlack@google.com>, "Hugh Dickins" <hughd@google.com>, "Lorenzo
 Stoakes" <ljs@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, linux-mm@kvack.org
In-Reply-To: <20260923224408.3745689-2-pratyush@kernel.org>
References: <20260923224408.3745689-1-pratyush@kernel.org>
 <20260923224408.3745689-2-pratyush@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Wed, 23 Sep 2026 22:55:49 +0000
Message-Id: <20260923225550.32AC21F00898@smtp.kernel.org>
X-Rspamd-Queue-Id: BBD0C1C0003
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: ks1s3uwjkqx45trm1khxqdmwwsh7rb98
X-HE-Tag: 1790204151-376428
X-HE-Meta: U2FsdGVkX19AyyOjYu1ncgSP/g00MCUlF6Hn42zmUGdEo3owI89QD0uEaSiR0Cwnty/SFVRxF4Ee69Saw9nPl+3coKtRUHv5XhCoHfXKzUkeDseGxrEB6hrlJH0ziPVGojOn1o+CRgsr/k7eSC7IRB1n45JI7/Bh3m8qJjOl9TyQQ9r/VTe4dFnP4yR2MswlIwH5ac/c0JdAzCcBZPM77eoFAgwubvle6HNRGdZPBk2KWsYyg/4psQhyJ5UoZNsjQhmIBNqQp21dt/BGhEUJ5XfyiHCBt6uDDdZxFi3mwUud/dpfvgS3YRU7c7rAnigwyR0WRELZ2FEpsY+fwBFWvbqzLLYnbf3jiPlIp7cs2EwY3wMCQjjx/ldHptFsgm1Gfb6EvH6jXZbB5MfITgVNbEbSUqbvkgAcsUD0QAVMnhaNQifakyGNOhLoJXswFncwXzC372YnOEmytFWBOkafyZ3ZmAlLvJ1JfLGT58i6VGg7Ot17sdSGQgJuek2niJKSCM4JaWEBduwylRcKdDOnyZ6bSwj3H/rDISSGRsQ8JDnNb9OOFC6VaHGw9sDB2xDRCZkpUd1sCy+xmjotIoMBanBS/8CUiJCfkRXE2R4lR0iUhxqymYMsMdSIadkRPR5DfG6CaQt5sdFvbjSHBj/WJT3Aug7Irh7tShtH7eWzp3tyVu0dIzx9ZaSeYl4NRwoDIkxAhPfy7+BQ/YIq0Ds1LK3LUgHe9efWoVTTyVfm304M+dLorfwukIUyYc8839ugpY7Z5c+mxb+C74fEE3VP5ElhG9ESGSWuTf7+VPct1wBOEiu+YMWCa9lMyO+WofQbQsvt3lTQFf9rUt2PcaVJXXVN3Q4pVPwOhupR5VdxGAAODu3IknSGOA3ZVWkrl8p5W+XdskhQcuWSsXOk7u7yjHEIFhk9B45G84KT+c25GpXVSttJmAYH5/N1O0CAvjsBGvCn0Kz7NWUFxQG7+ZM
 9c+rQjdN
 f0jqn2eCVuMCn7Uf9rAnNItp2+2PrsvA33YCXqppBopF4jTWhCaxOKd0KwyjmLJceNB5xBFxQPAEX4t+2aqGhktZLDvd3n04G+9HGXwbW7b14XgjcEZhqJUO1blFMcaspnCfTmf6rJg2uvqG1TgkQLZBJXzppBheNNuTwP0Y8qxpP512uHmAnW2udO+bd5vJ9X0FsoSZ8YOet/LkjUVwb7HDHUHU6MZqOKDGP7B3x9pqKl1eg/Y0W0Qllse9vD4fBGrqIXxPK4NwPYZ0nVQwN9dg3IRxBv3px3UhI5srGqp394wYvzZare1Ix8CcfwhlBLp3EzLXp5z0zO8USp62jN2fmORLOGq1cxd9qpxFEYrebuJgsfxvRE7fWWGaoI2Rpi3ptnxCY3BXGrSiiIU9J61JGZi3DfMK95gnZeYeEurD+6TbDDmImnfGyosB/9DnBztI6SvR4G4nJFFe9NiG9CZ4/Fc2/xHB1navbEPVM2Ijsv8g1+OVQinXmHgXfCHK84sZsO72EdCUgCvv/d9+KqbQAadhRsz4UAfEKNRYaFVVPb4k8gckMJnzwzGLJT3VMGoP6VEd7umuXgYNzhmAtf5kmziHh+FK8yjN6terngODzNZvtWu9atklrod4I3mK0xrh6dY43IB330/Q=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Thank you for your contribution! Sashiko AI review found 3 potential issue(=
s) to consider:
- [High] liveupdate: NULL pointer dereference in liveupdate_get_token_outgo=
ing() on incoming sessions
- [Medium] liveupdate: flat ID namespace in liveupdate_get_token_outgoing()=
 risks cross-handler collisions
- [Low] liveupdate: O(N) indirect function calls in liveupdate_get_token_ou=
tgoing() list traversal
--

commit 17b042e4901cfc25a86dec1038092fbe1eb5d060
Author: Pratyush Yadav (Google) <pratyush@kernel.org>

liveupdate: luo_file: look up outgoing tokens by id

liveupdate_get_token_outgoing() is used to look up tokens of dependencies.
It does the search based on struct file. LUO provides file handlers a
get_id callback that can return the unique identifier of a resource. This
patch uses ID to look up dependencies in liveupdate_get_token_outgoing()
instead of struct file.

> diff --git a/kernel/liveupdate/luo_file.c b/kernel/liveupdate/luo_file.c
> index a39992da504fb..51817d202ce26 100644
> --- a/kernel/liveupdate/luo_file.c
> +++ b/kernel/liveupdate/luo_file.c
[ ... ]
>  int liveupdate_get_token_outgoing(struct liveupdate_session *s,
> -				  struct file *file, u64 *tokenp)
> +				  unsigned long id, u64 *tokenp)

[Severity: Medium]
Will this flat ID namespace risk cross-handler collisions?

Because liveupdate_get_token_outgoing() searches across all preserved files
using just an unsigned long id, it loses the context of which file handler
the ID belongs to.

If different handlers use overlapping namespaces, such as IDR indices or
pointers that might alias depending on object lifetime, a lookup intended
for one handler's object could incorrectly match an object from a different
handler that happens to appear earlier in the list.

Could the API require the expected file handler context to scope the search
safely?

>  {
>  	struct luo_file_set *file_set =3D luo_file_set_from_session_locked(s);
>  	struct luo_file *luo_file;
>  	int err =3D -ENOENT;
> =20
>  	list_for_each_entry(luo_file, &file_set->files_list, list) {
> -		if (luo_file->file =3D=3D file) {
> +		if (luo_get_id(luo_file->fh, luo_file->file) =3D=3D id) {

[Severity: High]
Can this cause a NULL pointer dereference on incoming sessions?

In an incoming session after deserialization, luo_file->file is initialized
to NULL and remains NULL until the file is explicitly retrieved.

Because liveupdate_get_token_outgoing() is an exported API that accepts a
generic struct liveupdate_session, an in-kernel caller could mistakenly pass
an incoming session.

Prior to this patch, doing so would safely return -ENOENT because NULL =3D=
=3D file
is false. With this patch, luo_get_id() will blindly pass the NULL file
pointer to the handler's get_id callback.

Handlers like memfd_luo call file_inode(file), which would cause an
immediate NULL pointer dereference and kernel crash.

[Severity: Low]
Are these indirect function calls necessary during the list traversal?

Replacing the direct pointer comparison with luo_get_id() performs an indir=
ect
function call (fh->ops->get_id) if defined, on every iteration of the
files_list traversal.

Because this function is used to look up tokens for dependencies, it can be
called for every dependency of every preserved object, resulting in O(N * M)
indirect calls.

Since the ID is a constant property of the preserved file, could it be
evaluated exactly once during luo_preserve_file() and cached directly in
struct luo_file?

>  			if (tokenp)
>  				*tokenp =3D luo_file->token;
>  			err =3D 0;

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260923224408.3745=
689-1-pratyush@kernel.org?part=3D1

