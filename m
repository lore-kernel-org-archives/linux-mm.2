Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 57D10C43458
	for <linux-mm@archiver.kernel.org>; Tue, 14 Jul 2026 01:48:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 14AE26B008A; Mon, 13 Jul 2026 21:48:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0FB926B0096; Mon, 13 Jul 2026 21:48:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F2CB26B0098; Mon, 13 Jul 2026 21:48:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BAB896B008A
	for <linux-mm@kvack.org>; Mon, 13 Jul 2026 21:48:47 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 1EFE7C01FE
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:48:47 +0000 (UTC)
X-FDA: 84985698294.24.3AB955B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 49AC2140007
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:48:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gVVH5P/f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783993725;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MbOjIsi8JJFa+ekLd2ueCKtLKuoFN78zQ1K70+DeCBo=;
	b=A32wvLIW30vGLbdZ06SFtS9xo0jaEK8FFp8O0M4d7CCObihU++SbkX8aw68h610kuivey0
	lR9wIlLGA3EYNP5Jf25kJmxWCzdD3g+6XIe5aRZbveW0lltibfAQx0EZFIKUSnzk/pSHXH
	vNWu1dmLrmx0l3H8c/Smjt6SLKcwAjs=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="gVVH5P/f";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf26.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783993725;
	b=MkaplbCkSt8OhIJjmB97CrIYoZbRxX0BhNXYI4BafBoAqGFd7nrNgkAmLkR773NIgJpEPb
	pRGgHCWSdYdY22O8hpLv1sFd1lTOcEGVN+D9WLEWkWF6ZwqX719zz3dbaPh1F8PotzT8n7
	QPkR4BQfcviFDVrEpg2NGK51QZJUODI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B1BD460120
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:48:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 589F81F00A3E
	for <linux-mm@kvack.org>; Tue, 14 Jul 2026 01:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783993724;
	bh=MbOjIsi8JJFa+ekLd2ueCKtLKuoFN78zQ1K70+DeCBo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=gVVH5P/fjgbM1OPgTRHKxV+piUyPGvXao2h4/3Xn3V9C3SE+vBBrKLHrbQk76/oqa
	 CEZ6zmfHLS/fR9EzD30TrlQiVGraU2NJGOsKUeTSuPWNUjWh66Iuobtrw8VVHpXJaK
	 42P8QqfwChVaT7lugOEXjGvabUnqFp7nexKwqi4to6yk/AoPY268iMBbqctte0DRcI
	 gQgpKdOgUEIvZtoHfjWWprGctNoRi/3wwFYl8qz89HLGOWHbPWjlTBjV32aI1GJEeZ
	 l8Tfb0tcoBVEahfLUkorsDRqLJh03mG+LzMh+qocqmtDONl0wCu72fKLL5rUHre4me
	 cduYEQ6HjJP0w==
Received: by mail-qv1-f45.google.com with SMTP id 6a1803df08f44-8f23e851626so38495416d6.3
        for <linux-mm@kvack.org>; Mon, 13 Jul 2026 18:48:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RpCOCEFMOM65KQNeds1JsUXOJZRbkkKet3Aeks6g8R+7q4Y5Tx5Q7WtyDPMC/15nAKzIb3cbqKdgw==@kvack.org
X-Gm-Message-State: AOJu0Yy3/ezsoDzz2FJtvApKtr3jIkCnzN4sZQSO8gIzTE8tEQ311UK3
	hRo9dAJjaHy9DKnpGahR9veqS7ZYgemsn1+v79d69jBeVkdondsKT3t7gAIQT8gtUEEb3IPrp39
	EQWU9XslUV37NaW5LpBllz8nU6sMdkRw=
X-Received: by 2002:a05:620a:40c9:b0:92e:72a4:f291 with SMTP id
 af79cd13be357-93083c771aamr143577285a.35.1783993723543; Mon, 13 Jul 2026
 18:48:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260711091157.306070-1-ridong.chen@linux.dev>
 <20260711091157.306070-2-ridong.chen@linux.dev> <CAGsJ_4y39eSYqYwSPzqcZPk1wcJEYN3HZr83MPv8pMgN8Nct5A@mail.gmail.com>
 <87dc4105-b98b-4541-bafe-c0adfbf58836@linux.dev> <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
In-Reply-To: <CAGsJ_4wDMrdvGksTJ1SMGE=aHY3CMY529ceKDD68cXLsHQCjtQ@mail.gmail.com>
From: Barry Song <baohua@kernel.org>
Date: Tue, 14 Jul 2026 09:48:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
X-Gm-Features: AVVi8CfG3B9nlEacyjsxWYdmVKS691GC19CUAX3lW2WBM6ngcXxIYeumTVwHA-k
Message-ID: <CAGsJ_4zcgURKZKBAc6i0Y5g7u2OXjENDE7A=nqYcQ9TTVuR=Hg@mail.gmail.com>
Subject: Re: [PATCH 1/2] memcg: move mem_cgroup_swappiness to memcontrol.h
To: Ridong Chen <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	David Hildenbrand <david@kernel.org>, Yuanchu Xie <yuanchu@google.com>, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 49AC2140007
X-Stat-Signature: mrtnws3xguh5igrg83wuxd3bxjoxccw5
X-Rspam-User: 
X-HE-Tag: 1783993725-480944
X-HE-Meta: U2FsdGVkX19WoiwAHyfDvKimaTlIa/wPGpYsDk+7r74JxQwU5Y99T2fZnUf+30+kPBO3xy7hsLpLDUGtuGQ7x0hopWiMYMk29i6IpoWsSzT3gjrK8s3/RMKHAdgD/RPRI+dHTlHE+rewF8PN1XJYjm0zJ+e1A894TfCSPbGr4ZU7kGRANjFVGKnNsqCDIqrZlciGviPjHjqmblVVMCbfMkr5CAjIp8/QTHnotpvGvk7dbNFWm19SKJtNh3+rUqx6XccS8nsvYxjorZCgR6EYFp0yDkq79vwXHp8coLAQ/oiUYyUQp4aFPBnOAeu+66BuOWi30+T57nUwNNY23enqmnv6YJd68R/RgQogg0UKXXBzMVf8HHtiX2Ncoh6uMWzFYO70kyi4B8crAjvkgdyeFWKrQWpOAGntIAMhw34tc6fWJ0aNePKW8FjvxlAXtEO8sOY2YgPDmfLo64zFY8bp/vWeUr6OHjt0Sgt4viNIRZrCCLQc4wwsfY3dbrbVWLvhXn+CQj+HFpgTI0L5HEvfdeBMbQ0IbJOlFwt5x4NS3AJWff8mdsK41Txz3wM++lN1ttu2k10QTorelwLiuQCkZuQ/7CwGCu501uUZUGjib4VOiQcUX7bbjKtiTTo3yViz92opTqZKy0w/V+O4NdXmP8Hj8x7M/XL0HgvmaK5ULEIj7JKqPyQ/LKKvI4OALcADJ+mfbqZv1MR2UyiN6TMTIZTqHggyLmZnbsFXK2vlrvBZrHA6g052VCrokU7a6+cbpRPRFV08wUR2y1qe2jxDTtkPEUVYml3uKcY1o7HDu6TtHJIMMK9Tcf5wNCsaaexpThWbR85tsiGCuP8qktWn28f5AVzPEAD10Yef8wPxBzhKG/licrAisYkjCQw69DspDu8WZeiiA9TZnBaDnHQWEKIw4VkHyNiFSDXZ7V1XzKw2XwyRw4R7kqbsaDCdLEyI/3h2bgRyOlxZuAIhiPd
 Kyatgprc
 yEU2CpSKyczWxyBcuO+CcZPa+HCkXzlzFRINL6kEoO9+Xztc3PBYMpwH3UxfZosizc5vHq7oO2nQFBeR96MJ+hRUv2Xe7d8d6/8zPLwnOC70GEe2L6txcEmhpq/ohKAbSjqLV4teNFbSX7gF5iv5GCFtc5TSri1BMDl0hfldDbjzPtJ6aB9toG2aDNvtEhdhDmKhOHXkWCSKovy75CK8JyQIs7xN0A/xm5pYRk84tyUTqLFSuqvwdLuhOUZ8fEQKc3r3OEohYOwUCzLiFGeff8AVyOHUtoCXXtPNe3ersQ6s1SSHF2vFC2J++US0CqzASjTS0jbOXynEWpgI/CfaFP9m1Prsi0WFZ25GGhUcBsuioZOdgX3HhTObAcwQYIFypPD5NUOctZOdn41S4IyRptkW9/Wr72jTz489J+XJ+ra3kqnBquQakRUtlyl49RdAXzTNZT1mQM4EXNQ4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 14, 2026 at 9:43=E2=80=AFAM Barry Song <baohua@kernel.org> wrot=
e:
>
> On Tue, Jul 14, 2026 at 9:20=E2=80=AFAM Ridong Chen <ridong.chen@linux.de=
v> wrote:
> >
> >
> >
> > On 7/13/2026 11:08 PM, Barry Song wrote:
> > > On Sat, Jul 11, 2026 at 5:12=E2=80=AFPM Ridong Chen <ridong.chen@linu=
x.dev> wrote:
> > >>
> > >> From: Ridong Chen <chenridong@xiaomi.com>
> > >>
> > >> The per-memcg swappiness knob is v1-only; v2 always uses global
> > >> vm_swappiness and ignores the per-cgroup field.
> > >>
> > >> Guard memcg->swappiness with CONFIG_MEMCG_V1, and move the helper
> > >> to memcontrol.h where it belongs.
> > >>
> > >> No functional change for v1; v2-only kernels drop the unused field.
> > >>
> > >> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>
> > >> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> > >
> > > Reviewed-by: Barry Song <baohua@kernel.org>
> > >
> > > With some nits.
> > >
> > >> ---
> > > [...]
> > >>          struct mem_cgroup_per_node *nodeinfo[];
> > >> @@ -365,6 +366,9 @@ enum objext_flags {
> > >>
> > >>   #define OBJEXTS_FLAGS_MASK (__NR_OBJEXTS_FLAGS - 1)
> > >>
> > >> +/* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
> > >> +extern int vm_swappiness;
> > >
> > > This is a bit unusual. I'm not sure whether mm/swap.h would be
> > > a more appropriate place for this.
> > >
> > Thank you for your reply.
> >
> > The vm_swappiness variable is not utilized within mm/swap.c.
> > Furthermore, since memcontrol.h does not include swap.h, retaining the
> > extern int vm_swappiness declaration in mm/swap.h will result in a
> > compilation failure.
>
> If this is the case, it still seems better to keep
> extern int vm_swappiness in include/linux/swap.h.
>
> Then we don't need the comment:
> /* Defined in mm/vmscan.c; used by mem_cgroup_swappiness(). */
>
> It also makes it clearer that vm_swappiness is an extern variable
> belonging to the swap module, rather than the memcontrol module.

BTW, if mem_c_group_swappiness() and vm_swappiness are only used
within mm/, could all of these be moved to mm/swap.h and
mm/internal.h instead?

We are making a big effort to move many unrelated things out of
include/linux/swap.h recently. Could you check?

https://lore.kernel.org/linux-mm/20260708-ch-swap-series-plus-folio-lru-cle=
anup-v9-0-2bc72b4f8730@gmail.com/

