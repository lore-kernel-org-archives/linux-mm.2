Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CE5FDC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 16:10:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9E2E56B00BD; Tue, 30 Jun 2026 12:10:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BA916B00BE; Tue, 30 Jun 2026 12:10:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8D1CD6B00BF; Tue, 30 Jun 2026 12:10:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9C76B00BD
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 12:10:21 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D06C98F56E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:10:20 +0000 (UTC)
X-FDA: 84937066200.13.66F5EF7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id E6C91100014
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:10:18 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaP2Jv7c;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782835819;
	b=sk7ryEh5E8aF5wvsTBzIq75m9P44jOwKNjpdsU2vPKwIry3NjOnwI4bYEVbF2eD7QrRv+e
	l+UZmxZEW2fRn2VzSpKR9MhVKjY82EonCHVMyTMqfnFRjtAm19r3SSMr1q6RpW+JrmcOLW
	oK+qhNrPxR4n14KpgsyFAbWChPPEvGE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782835819;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=k7zChJl8MwHEyfkHkyO60Kplml0v/iOPphL5IgITDh8=;
	b=g582gI1VqoTsOA/QkhNUtEJXhFyRjTipn8FbmT9+TgvXxm5R+jim9BXHj46xXv52T1Ivmb
	eL7boWyQ6A4i1Uh47ZuItC4iK67htwM0b/gTxZNQVwIek268Dj6/Gs5kkvlFdsqoPTujnP
	onVUiik2061aXL57gfld7/uT7PyoN5o=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaP2Jv7c;
	spf=pass (imf14.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1C63E43B15
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 014DE1F00A3E
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 16:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782835818;
	bh=k7zChJl8MwHEyfkHkyO60Kplml0v/iOPphL5IgITDh8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=RaP2Jv7cYX1bNGREFeq7tshSNm/SWgYSS88YwrjEXc8F4U0mUzFD4557v+Z/5LeND
	 V1nuZejIU+u+MIRn7O9cB3RnHz2Edc23OMyorbL67IChaAH3TZs+pnpyGoyO63SwlW
	 QtoGzj6Im4O8FAakxrB8rSSzAGHYZ81UfVHDTHxvHLbKk+SKS5gDGEtRMXkjnDM+aL
	 TEoXzHIgiIgTYGjDe6Loz97mgHvn5aOeagJKjTJHsgFuwsoFsY1MnC5Ot5jHdGJftk
	 GSS6BaVRIFj5pjezXTnYaI9suwSIUgs/Xn463XnjJVOa9gSs9LxwGllHAKhp/1xpuR
	 rgoPWLbK+E+Qg==
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c1269e4721aso324686366b.0
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 09:10:17 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RrQg6hwzB3pL28DT08c7l4xh0oYyK8ywIQag15LwJwW5+lMDl2gEj+BvOzVWeV5L4Hrr5KehF2waQ==@kvack.org
X-Gm-Message-State: AOJu0YwJTbOOvYysJLWYwkxGKehpBKY0Awzdu20VGkVOQdhizdUuc7vo
	sKpTiS42TS5ymLmc5SHo+IBd4jvrqWfzX0RSKPLbjAUpx5kFCBZ7xbd4+aaoE9jlPrLf0XYbzSM
	+eIce1RqKOmgP/tExHWdDyenl5IU0tXQ=
X-Received: by 2002:a17:907:e155:b0:c11:f6cd:e120 with SMTP id
 a640c23a62f3a-c1297c09d89mr49816466b.25.1782835816933; Tue, 30 Jun 2026
 09:10:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260629112032.20423-1-jiahao.kernel@gmail.com>
 <20260629112032.20423-5-jiahao.kernel@gmail.com> <akMJ8UfeZXrVe5LN@google.com>
 <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
In-Reply-To: <cbbdf506-b67d-193c-2c94-bacf828d559f@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Tue, 30 Jun 2026 09:10:04 -0700
X-Gmail-Original-Message-ID: <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
X-Gm-Features: AVVi8Cdt9VAUjUs2EYnk1zT9l08rcztQNfD1M7IbhQzMhnu027BpAaMiWC_e3cE
Message-ID: <CAO9r8zNCEis2QHROEsM5QZsb_H4ofNjA_sE-pM7SVxtgHg_rqg@mail.gmail.com>
Subject: Re: [PATCH v5 4/6] mm/zswap: Implement proactive writeback
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: akpm@linux-foundation.org, tj@kernel.org, hannes@cmpxchg.org, 
	shakeel.butt@linux.dev, mhocko@kernel.org, mkoutny@suse.com, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, muchun.song@linux.dev, 
	roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-doc@vger.kernel.org, Hao Jia <jiahao1@lixiang.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: pgswcttok17g99keeqrittggfh3pf6bm
X-Rspamd-Queue-Id: E6C91100014
X-Rspamd-Server: rspam06
X-HE-Tag: 1782835818-513623
X-HE-Meta: U2FsdGVkX1/+uyEvaHYNs+BTYeA9OaTOUVlN6cBbMvvUjKzCn89IQr31JTqGig5Pz+HBSWIZRBdbbqMdvaRBuJQVuuZ7IUMjUc1kBS0OvurgCpxdeQslr32aWy6s3O+icO6H9t9QEPF38mCaG/xAZvUf3XFmLZaGIy3ttNncBhXINvRkQMmnSwOQ0BeruaXNrSwn14vR8ZhFfz5fJnwT1I9SV278T7YK+hczutd53Aqghc/5Q9vLq7dZVSa2qsbfgN+9C8u1m1+7zCGPW48U5PPOfOWRNai9ja7yJ6IyfSkZRB4AIovAwGbI9QeqK0HIEY9HCjsZlsU+O1E9Ug4XudC+/NxlrM53KmtnFVbv1ACmivOe/ZcS/DFoDMydYpGPVkz0NMK7vyw2T5Gn0GUgQ28vH1F7xdJhE5YhxWu+65XTVixyJSKp53ZyWSaz89TryIW/azZ/MCe+yWqUj7ePtS6UnZ3rpdKkN2EhvI2fjiqZBRkV8nR++wobdNyLGPbw5f60bywuuIoly00JvBQ3hOeKGzUbMQxL+Z4yhRDmjz75untAFrhylmPneo+VOENFGbKy4SQ7OuP1IU3aYKf5Oe+E+s/qa5Za/h5/KpnEszVRJjrDGmbaF7tSvM/i1u8ZAICGh/1qqtNlZH/tPS3U67NFvH0Zl9LSnGLt4PEld6aKDk1ARXiLF2EV74hREFP3wqXlPexKwZZkuO7TYUkPrJ+s7XcJJJbVgvUiVxrVBeAp7FGvgzxAxu0gb8OBK9o7irXb1+LPyozUczKGa97DD4+xIN6yMMW8Pe1eEzfpxMqti5VFpaH43OiaOBQ3VMzpLHdC1H0feDjvPh8dj7HPdVeOnMeutFW1fVGfAoEheWIVJbcTuFzhSgdJxcnropKiNy24AicbAHZgLynfslUOPHseWfYjeBWWi32UWjAztXWkF+3pxLwRnAk5ISuLRPmMOkvrixpVMZ89L6Pr/xh
 8rKVDiVx
 Mm+3iLhQkSpSZwjlITrjNEXHse1dqmJmgVF9wPXE9QjUhfQJb3JZ70G5q66D7LU9gMwVYc4Rq/e6W2rawqLh4EL7xGmpGdL4szUF69IdrWgAc5vulx7ymH1N2ub2PfpeL3kni7ILXRZy1Wkt4gwCnVJU+Wx2uyBKEdZUJeVsYek4UK6ExSKi2DokpaHJoPpn8fJTEXnaVBf6EH4eo4T6h1OkkeNn3uhE42rtzoGFpP209Ddyip7UnTAjK4VGZefDzA0vgiXxTkdIOvnMOmMgttaQfwBDiBv8j/REU5QztY8ECcl31g2VrVNgvfw87TzWEO5DqO+BmCrlwYtLjbefY9Gd0mBqDtsK3IYqUdhftr16Cxbc=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > Before going through more versions we need to figure out if this will
> > pivot to be a proactive demotion interfcae for swap tiering.
> >
>
> Yes. Should I drop patches 4-6 in the next version and wait for swap
> tiering to be finalized?
> We can try to get the non-memcg parts (patches 1-3) merged upstream
> first. This would also give them plenty of time to bake and catch any
> potential regressions. Thoughts?

Patches 1-2 can be sent and merged separately, yes. For patch 2,
please include some numbers for the writeback performance before and
after batching.

Patch 3 does refactoring in preparation for patch 4, so I don't think
it makes sense on its own.

> >> +int zswap_proactive_writeback(struct mem_cgroup *memcg, u64 bytes_to_=
writeback)
> >> +{
> >> +    struct zswap_shrink_state s =3D {};
> >> +    struct mem_cgroup *iter =3D NULL;
> >> +    u64 bytes_written =3D 0;
> >> +    int ret =3D 0;
> >> +
> >> +    if (!memcg)
> >> +            return -EINVAL;
> >
> > Can this ever happen? It would be a bug in the caller.
>
> IIRC=EF=BC=8CWriting the following to the NUMA node sysfs entry triggers =
this
> check:
> echo "10M source=3Dzswap" > /sys/devices/system/node/nodeN/reclaim

Oh yeah, I forgot about that one :)

If we keep this, probably combine the !memcg and writeback check below.

>
> >
> >> +    if (!mem_cgroup_zswap_writeback_enabled(memcg))
> >> +            return -EINVAL;
> >> +    if (!bytes_to_writeback)
> >> +            return 0;
> >
> > Do we need this? I think the loop will just never enter and
> > mem_cgroup_iter_break() will do nothing.
>
> Will do.
> >
> >> +
> >> +    while (bytes_written < bytes_to_writeback) {
> >> +            long shrunk;
> >> +
> >> +            cond_resched();
> >> +
> >> +            if (signal_pending(current)) {
> >> +                    ret =3D -EINTR;
> >> +                    break;
> >> +            }
> >> +
> >> +            /*
> >> +             * Use a local iterator to walk the memcg and its online =
descendants
> >> +             * in a round-robin manner. Upon exiting the loop, mem_cg=
roup_iter_break()
> >> +             * must be called to drop the iterator reference.
> >> +             */
> >> +            do {
> >> +                    iter =3D mem_cgroup_iter(memcg, iter, NULL);
> >> +            } while (iter && !mem_cgroup_tryget_online(iter));
> >> +
> >> +            shrunk =3D zswap_shrink_one_memcg(iter, &s);
> >> +            if (shrunk > 0)
> >> +                    bytes_written +=3D shrunk;
> >> +
> >> +            /* drop the extra reference taken by mem_cgroup_tryget_on=
line() */
> >> +            mem_cgroup_put(iter);
> >
> >
> > Can we just use mem_cgroup_online() instead since mem_cgroup_iter()
> > already graps a ref?
> >
> Will do.

If you're looking for another cleanup to do, shrink_worker() should
probably also use mem_cgroup_online() and avoid taking/dropping an
extra ref :)

