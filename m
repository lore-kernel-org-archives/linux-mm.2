Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 02FFDFF60ED
	for <linux-mm@archiver.kernel.org>; Tue, 31 Mar 2026 08:42:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 33B616B008C; Tue, 31 Mar 2026 04:42:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2EB9E6B0095; Tue, 31 Mar 2026 04:42:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 201906B0096; Tue, 31 Mar 2026 04:42:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 091BD6B008C
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 04:42:34 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 968505C6B7
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:42:33 +0000 (UTC)
X-FDA: 84605716986.25.B79E10E
Received: from out-173.mta0.migadu.com (out-173.mta0.migadu.com [91.218.175.173])
	by imf25.hostedemail.com (Postfix) with ESMTP id 928BFA000E
	for <linux-mm@kvack.org>; Tue, 31 Mar 2026 08:42:31 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GSqaylH2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774946552;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/AlGD7u4tl49XCgs6NmgwiGAUkvbnIHV7Y7bhbNiB1A=;
	b=nXUz49yAtBKo+US6mpd04DtWDh8S41UAUWZZ/6Q6PEZvnZvWtqQ9/7juhkNIceIwd9YMeK
	oNE/xELAPUPEcknZQOWbkSsRQE3Fwt5VukBsrGGqYL8/3qYUMFC58/8gAnnbAaHL0Cwa9x
	TCYLLIKa7bHeNuZ4MyL5mjOkZZ34aYQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774946552; a=rsa-sha256;
	cv=none;
	b=r9EkVFGNWXuu/ioQ82kpseZuF4fznLgzG/65Qu3gqO1W2R5DeoYx0Hpfnrg+u/3HzjLPx4
	hYkiDRP2hJOW8Nk5BawlxxzQNaMyOxaE49NEYuRgx5uKVc9pwa6aRmZjDWRunKp2UQILAd
	cx0gNV74bZQTMA9ouGdc0d0cNyWLYJk=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=GSqaylH2;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf25.hostedemail.com: domain of hui.zhu@linux.dev designates 91.218.175.173 as permitted sender) smtp.mailfrom=hui.zhu@linux.dev
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1774946549;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=/AlGD7u4tl49XCgs6NmgwiGAUkvbnIHV7Y7bhbNiB1A=;
	b=GSqaylH2c7Q8tuy66qhpuXzOfPxj6bt0rDqgVSDRk2sc1JHLvey+8enRJ/spvq4w0IXqEq
	w3SiquejJLiPKkar8ZjfkDsBIpDJAcMVLzlmmI6oL/zvxeV2JScYR1GagCek2TBIGbIhnr
	NSsmi+c5ZI4YebrcSbAzSFMmi+nZgcY=
Date: Tue, 31 Mar 2026 08:42:26 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "teawater" <hui.zhu@linux.dev>
Message-ID: <03690880802c3b7bd03ab93ef463f0bc739e6652@linux.dev>
TLS-Required: No
Subject: Re: [PATCH mm-unstable v2] mm/memcontrol: batch memcg charging in
 __memcg_slab_post_alloc_hook
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Michal Hocko"
 <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>,
 "Shakeel Butt" <shakeel.butt@linux.dev>, "Muchun Song"
 <muchun.song@linux.dev>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, "teawater" <zhuhui@kylinos.cn>
In-Reply-To: <20260331011647.79bdd9b9b6efb99bcbac8d77@linux-foundation.org>
References: <20260320020745.833792-1-hui.zhu@linux.dev>
 <20260331011647.79bdd9b9b6efb99bcbac8d77@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Queue-Id: 928BFA000E
X-Stat-Signature: cejsu7d11msqp3bpgq63axq4ria36gqu
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774946551-375446
X-HE-Meta: U2FsdGVkX18bKKHLgX9eVHJ/NpUwNYi5wNqfI88s8fo117NOqOYjFV/fW9Dl2K+xPpp+gDF2j9XIeT2WpWRUVSrfJCwF0go3hxpOUgSqRiEaMgwLluW+loP64Eob7SEVjUs1DHDW121m9DqqYRIMFuNx9WC4cM2s9B2ZZU6/HxciID362R1UbZItscYpywk795c/rnWhoL45vscuytgQnY/WElaOdgl+/E4j2/xQi1Vc5w9zTj86v0KUHuRbhxIHi9SGQRB1+1g5B4MSbppaUQpeVsVqefDXdK7/4h4ZcpnEWJE007VSI2/d2QI3/Bo582PPMXHD5dSik3nH38mbS9K78575YIUUAsavic5YNDFZeNmAqxkhmZxJveO6IWHK9KxjkiDXB8yQhEyAuhUMKxu3X64jZva6YNHTwfMdgdxGaygS+yEQs3ER5vtGg/0btxELtzG3HmMBXTxABH30o1BV0hnHrzQKrvIiVmL8SPyon88rPqO+YnrTlKdOsU4eWqyTihrcbMk4Bwd1vkQIJiwqfiI/nSu8cwRNzy09w89ifAVdEq1KGk1J+hLVCvKiU1CQwI9/TY5rTmqepyR2mTgY0n1enIq1N4AogcZNI8k2kgiL531FC9QMSAW+NjmJdNWPejuIZ/dw0Jda9RrQvTxwS7YWXsfJWmvPj9sUKPUWd3CyA6ohD7XsKUYQYlcpdq505O16iMFFigl+j0VG6ZPfPFCz/QBzrjXmNivueFKdWJ0zHhJzXEwDNRNP5nPv7S/O9Sldf/TLQD47uBc+vKgV1bSxRallAVl5/laFFl5Ng0K+O3Ltg4DKiXcAYETT/n7CTgp+sTG1pebtXoYZ+fKcyMwQ/BO60ClEHYLismAOQBbChQHeAWMp+xXQjXQ5YF6+4oTBBVwrsqo3Csur4m5bK5792JPCkg2PM1LEB3XXhO+Bl011aqZVgfmF1lQZkFBkX4SdxohdbBZHAg4
 8fYtIjVe
 vU8HeT3Jqmv184FMmuXJtQAATsY6zOjMUARP2p/WP4xLJvpOilBHmBXrpUPiV5mIZoKJpCYRXQ6y1mJ7MQaDY4uzN8z6NuLKc1bOl3AFb/WCmgmOnvEqNPkNCC1Wx9H92kos7LhCUoZsarbb/TCpFW6T/4pOe13tXfTROg0iIxeaH9Kkh2B3fspl9/MEoOhb7Im8Nb3BAsZm3wDUVPtsqLyTIRbu+npSMeHbb0CGDAgrZDHKhNCvRKUlrzgDnCZgOKPos5vTPFb4j1mRok9Z06g501wH5EuozFqkP8JAc1iOOS8+GTtIS9p+tPklicVTZLQHG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

>=20
>=20On Fri, 20 Mar 2026 10:07:45 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>=20
>=20>=20
>=20> When kmem_cache_alloc_bulk() allocates multiple objects, the post-a=
lloc
> >  hook __memcg_slab_post_alloc_hook() previously charged memcg one obj=
ect
> >  at a time, even though consecutive objects may reside on slabs backe=
d by
> >  the same pgdat node.
> >=20=20
>=20>  Batch the memcg charging by scanning ahead from the current positi=
on to
> >  find a contiguous run of objects whose slabs share the same pgdat, t=
hen
> >  issue a single __obj_cgroup_charge() / __consume_obj_stock() call fo=
r
> >  the entire run. The per-object obj_ext assignment loop is preserved =
as-is
> >  since it cannot be further collapsed.
> >=20=20
>=20>  This implements the TODO comment left in commit bc730030f956 ("mem=
cg:
> >  combine slab obj stock charging and accounting").
> >=20=20
>=20>  The existing error-recovery contract is unchanged: if size =3D=3D =
1 then
> >  memcg_alloc_abort_single() will free the sole object, and for larger
> >  bulk allocations kmem_cache_free_bulk() will uncharge any objects th=
at
> >  were already charged before the failure.
> >=20=20
>=20>  Benchmark using kmem_cache_alloc_bulk() with SLAB_ACCOUNT
> >  (iters=3D100000):
> >=20=20
>=20>  bulk=3D32 before: 215 ns/object after: 174 ns/object (-19%)
> >  bulk=3D1 before: 344 ns/object after: 335 ns/object ( ~)
> >=20=20
>=20>  No measurable regression for bulk=3D1, as expected.
> >=20

Hi=20Andrew,

> I noticed that the AI review of your v1 patch reported a few potential
> issues:
>  https://sashiko.dev/#/patchset/20260316084839.1342163-1-hui.zhu@linux.=
dev
>=20
>=20Can you please take a look, see if any of this is valid for v2?
>=20
>=20Unfortunately the bot wasn't able to check v2 because it couldn't get
> the patch to apply. I've checked that this patch does apply cleanly to
> current mm-stable, which is on the bot's try-to-apply list. So if you
> wish to get checking of the latest patch, please send us a v3 and that
> will trigger a retry.

I will send a v3 to make sure the patch is OK.

Best,
Hui

>

