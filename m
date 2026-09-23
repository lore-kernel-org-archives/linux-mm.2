Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9AC80C982FE
	for <linux-mm@archiver.kernel.org>; Wed, 23 Sep 2026 00:51:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8CD5C6B008A; Tue, 22 Sep 2026 20:51:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 857636B008C; Tue, 22 Sep 2026 20:51:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 71F686B0092; Tue, 22 Sep 2026 20:51:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 405CC6B008A
	for <linux-mm@kvack.org>; Tue, 22 Sep 2026 20:51:55 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id B4D78A069B
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:51:54 +0000 (UTC)
X-FDA: 85243199748.21.F911833
Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	by imf17.hostedemail.com (Postfix) with ESMTP id D415C4000A
	for <linux-mm@kvack.org>; Wed, 23 Sep 2026 00:51:52 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMKGtbiD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790124712;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=nMGrqV/7N41n4AEPr/TzHOV8vImF769CiZQNhOyZCgU=;
	b=EWdu6Dy08Ms+K5YYeaKxHIo6yzCOQ2HMIlbszNzhI/ajFxY10o3ooGwR6BF7FLYXCJl23g
	+SJ2l4Phk3zOVcKfnXeaAd0C4Q3TBQuOEM2sO1ceJePMECmExLdwK5nbBHsJfwEPZ3FYmJ
	zVKj3KWA9z168Gpa+MPuX02BgEZIJUo=
ARC-Authentication-Results: i=2;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=CMKGtbiD;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf17.hostedemail.com: domain of joannelkoong@gmail.com designates 74.125.229.205 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1790124712;
	b=QbOeewKO3QwclYH96BQA4tNUR4KPI79tYOS+MwLNu15cmo7wztt7hXjHiu1tlFfo8kDYlg
	DDt1/yfy8BmBvsROgLANT3caILvNkOD8E7UPRumMNEikdiRDFvWfx9H5oYK6r1/rE5mj5U
	b8wcoXGce1cz/Lo2zit3mDKU0jbsVn4=
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8c3de61a3so320774e87.3
        for <linux-mm@kvack.org>; Tue, 22 Sep 2026 17:51:52 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790124711; cv=none;
        d=google.com; s=arc-20260327;
        b=U/dvm8+Wme5bgf6Tpfi1p4+EHjRHWDk7WeW7NFBtm/7k2s9LU8c9SE7sIaxjMC8hXx
         gpJFen6IFqO5ODWmr52cq6lq1MwTKb6EHivBpVIXmxXeV3d+NTk/PizikXYujfRPYcOh
         7OERlQpiZvmsLsooTLpE1wvsO6FKE47c4ZOqaDKZ7LD2HEOwbGgY9Xib46YmSimKwM/Z
         PBAD6fT9cdGAMVnyxlB+xPdwxhR11+8mwdJ2ztto8dD03dZeq2pfiXcO15UdJ3/I1o8e
         z1RoKHB+w8DOCs0xN+mxwwFTwyeKX1pQI1GZRBF4rb/JA6DTfyTUqWjRaqF8hRp14wgd
         dMFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nMGrqV/7N41n4AEPr/TzHOV8vImF769CiZQNhOyZCgU=;
        fh=N4BB+m64pDPauG2F9p00lZFlWbcBK32YVGweQXAJLKE=;
        b=TN+wQjdtIl9KrFYXm9N9XgMj5L1z/zvkXJYJr+Pqb6WjB9Wbm44JdiFNd9iipYOI3F
         2XHgsOKi6oO/xUDbbo4CF0QLEq6Z+pDn2okj8o95l1R2i5oIVnQeyVR9vN7OOtCxCJML
         oTQdsYctDaKBeGDfumTPqGIfaut3+cOzhKqj5b+NdKIRVKcWOPN2O8sPPkysquZALDwO
         l7lGZecXf2MO5EZTrJglQ4SpJeDFI6drZuOzlqC7I0Py3OP4n2h9nuMyA3Qj0hQPwEgK
         VEP5y6dF9ZDSS1rtbnj2BRNEbILvAFpaO/9hWGga3vtH5yIZ2bt9p8ZTzQwfXNxXUeim
         QE5Q==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790124711; x=1790729511; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=nMGrqV/7N41n4AEPr/TzHOV8vImF769CiZQNhOyZCgU=;
        b=CMKGtbiDMqtdUTvaEFIhPxCfJcEIUXkjemAHorCrLaSed9OZVxybpPjXG0AkNmWTNX
         FOWlYxOB8f1dhLT6DvHrdsWd4yxFKWiZT+KOkh6Iscn3nWMXLr8uBhgX+NlXJn83R8c8
         9BLKo+Omh/DRi2QlSVpIlazmooOGKz8qRHYyajzaJvr54rQggFZCE89RdgLi/A4n/suX
         NZBrFFJ0HoR8CXH3f4ZRwclcQ7pXQQXcJ/v1pmcEb9s6srZrexWTzdY0ta2jGsL7Xh0J
         mWpoxiZK+jBcAC716CQoydu394tLV1RBTvACub482xt0GwsLRSiq0BMsjm1WmPzqUbpi
         JmcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790124711; x=1790729511;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nMGrqV/7N41n4AEPr/TzHOV8vImF769CiZQNhOyZCgU=;
        b=bW0qpRTNzTCBZuc40pjvU8vAUvrNg7LOKrrJ393m+RJk6QGvrmSRMyKvVN3mJ9DrXr
         dtexA9RJ2A5cx3U0eIMbrN6kqEtHp2zB3n74ebvDiQ40pPHquLFXEM6bjAUR8wo0z5eJ
         +suU9niHGH9D34R35b7FCWfTon6M/XMFndipyx+xQtYrZ8hVahA6vt6z8P1y9ozgTaqd
         LXiTNIvRH4iHZ1FOQKWbsXViPP01a6O2uW8gXZRtwskGYj6DdG94wbCjMRAHhlOG6aa3
         2Hh9SKULi5XCZPDO5UER2oNEbLALDCqwWCL9m7F8nxWUJ4Mmj11Z04rutzfnaofnvwio
         EJSA==
X-Forwarded-Encrypted: i=1; AKwUvBz8eDcuilXc4w8rV6luE5fthdoJ9kyrr6/T7+8J8WmkKc1LMKcDassTVQipxRvuyD2ABayutXQMhw==@kvack.org
X-Gm-Message-State: AFuF++lyOGbfxFx7L9EbtJbvaQ7c1Yv+SEXiuMfLXqQPyPWRI7EVNcxW
	oa6z5kejPWIod24bIJan6pwosfByD8lEc25So5dRKiINWcdZEUtsI0/+p6K+jebPq9YKRxqWalV
	jbBUkkdW592LtvMtD8XPmc4aDVcKMuV8=
X-Gm-Gg: AYBFou2faockLVyaRhshjyP8YEHVzsgL4U72x3irdyd/5JuTXqglSK9yRnQxs/Xmdmh
	6lZLe5wlB3gNaeMp+aNK99/Ff/NOROJc0y591+gIqMBiMhcW7TCzqs9t/IEqoBVq9V/q4CuVhQo
	jI10O5olIwEZ/OQn51kOB5bJycEUeVCPjG3O1yq1OsqOSCy0HYjTftGUumFs2Kq0x+o13FCQQTm
	8OuqkqVA+oiFY/lud60ujLkmkVinPjJV9TpKTZihrJrs7u/Cm4E7fEbloS3NcvEvJeqoC9rNi1g
	N4KQ6hiOjOyKleQXDoBorPkeQEAaLvy+no1A5UuBfqP+b5jU8/Bey9hyQ07J04BVL6vO0yfBFQG
	yfNUYfP6jt4taf1hERiM3r8RNnADdBGeBViRzM+X67Gp7dfsR
X-Received: by 2002:a05:600c:35ce:b0:49e:84bf:6121 with SMTP id
 5b1f17b1804b1-49fdf0fe66amr11436975e9.13.1790124288548; Tue, 22 Sep 2026
 17:44:48 -0700 (PDT)
MIME-Version: 1.0
References: <20260916224437.1164512-1-joannelkoong@gmail.com>
 <20260920162014.4479-1-lance.yang@linux.dev> <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
In-Reply-To: <e22eb6f7-7eb4-4f50-af2b-13a2e3952cac@kernel.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 22 Sep 2026 17:44:35 -0700
X-Gm-Features: AclHuK92eoE3kA8fqBzCz3ZPF-2Gs_LzR2zaDfRSQ5ug_TNhip1GN1_qxJhEn-Q
Message-ID: <CAJnrk1Zk_4awd5OfbvsCLts1YPsB6JjjOF2hiSmg-wAp+_KUDw@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] mm: split underused anonymous mTHP folios
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org, ljs@kernel.org, 
	usama.arif@linux.dev, hannes@cmpxchg.org, baohua@kernel.org, alex@ghiti.fr, 
	ziy@nvidia.com, baolin.wang@linux.alibaba.com, liam@infradead.org, 
	npache@redhat.com, ryan.roberts@arm.com, dev.jain@arm.com, vbabka@kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, willy@infradead.org, 
	linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D415C4000A
X-Stat-Signature: ub6rsjx4s19jsiwa4smpksnseqqywb87
X-HE-Tag: 1790124712-730695
X-HE-Meta: U2FsdGVkX19k3beUSmaT8vdVpjY9T67+iCaTVUbjwQlMe2D/jfmh8n79wSI4ShejCSfkS6ttHqif5dF+iPs0RAs9soUmplDjpD2csGXP+8kZpNryhM5TbfWT0jaY7Bi7xpuyAofK4mCSAcHjZ1j39YA69Xx2A/kDK4sZr4GkhW4OjCB124BLVvDDdvOH8FKm2rMKnXub48dQQD9SrDhNr6uv1v0WZILTnh8K0Mbymghd7e7zqqYgZbcmZ5jGa6PE1GVvkeVsa5uqYI7C7B/2wS3vBnVrPCOD2DUpDkN3+mim6LldGqlTpaf/PURYZKe2iuk/S+JZ6erdoSLnc+mf1egQke4P9wgmcHGN+mjO21km4SfFrcuMl0mmY6eCGYc2l+72Qi0hOQ3LK8bNsmn4aXMjDVGqnzWsln1OLHYkfkNLcnm7rOrbzz637EnjAnJ8fZsQsACGqZjMSU8U65SeJkG8X3Zt06v6zlfhuWSmOExgBcG/Hy+kHMyrOxpajYhgAGzv4/juo1XhPUZNv03xkXoWRms8yOgB7FUj59LtMHF/BJI3jVmfxjmOt6829fEoEu2SmfyfGn01uh1ifcnkAwpZ/9uK1j7RiBR/5iblOUNLM+1LV63FfErprqGlkNLlkUT1LkgSHRDfiOw6DhmKL7zWNdrnxdaCe0ILH8xVNBewBVbig5oYVR5k2p2gcSRCwZLpBaZ7q5Fek2dtw+arQLJVLdnau2qCuVbiKT8xyNi94EbZmN4Z89JhMbtP4jc3UC3As1nHeulQwM3NV2q+Xi6TcjuqKfMlKKd3Bj1uhORdm8snFPPfe7qmaEzMKL3IrtY23QtaqESn4KQ79lGumDPvUnCjmWbaUxXf2MMboqoJzG5/+xOJ3elV4LSmookXfErNEKx6+JHRD6d3li5cAV6X+zXIbmbu6ZiDwwTwdvdeN0NSMDmW3xruHYE51/ALFoiV9BpCeIh8CSUfYFH
 tGl7CUav
 4b0H0R07eKsUUltILHwt3n5vJ/OU12nnZXRDGrprT1qZzwZVwl5bJkXGlt4p2WpH+3/d53lDRj/BQGc2k9bSAWreUzZmk9XBORtEPEbPjHICNPLXOHolVVdHSjiEWSIojhbSPiqggN/fjTGedMw4zYQ+aoMjC9yoBqy3gycT454q3wXQRIEoMSRr0nDAKbhNUMFI7tmhpnBu3xsjtiELKqWnLOiMR2bZ9j9EqWYO6U8UGns5JmrohdfkpJzLmlpnaXxdWx+S9kBE6FTRgsbYieM1TVAuf4/dL61oNwRTuICakCUMIzws8epRI1mT7V0b9s95maqiaknv8pt8dNQ07ZTSTzPT/ZhXAYmR92Fi5mIYwCFs9Z4fyB4JP7VaYlMRnzWTutPPdilox235GIc7sSNOuhpkXmNEb/Y+fMKSJimawVIU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 21, 2026 at 3:12=E2=80=AFAM David Hildenbrand (Arm)
<david@kernel.org> wrote:
>
> On 9/20/26 18:20, Lance Yang wrote:
> >
> > On Wed, Sep 16, 2026 at 03:44:34PM -0700, Joanne Koong wrote:
> >> PMD-sized THPs that are mostly zero-filled are reclaimed under memory
> >> pressure by the deferred split shrinker, but this is not done for mTHP
> >> folios. At Meta we would like to deploy 2M THP=3Dalways on arm64 with =
64k
> >> base pages, as 2M provides the contpte benefits while the PMD size the=
re
> >> (512M) is too big to use. However, 2M THP=3Dalways causes memory regre=
ssions
> >> unless the unused portions of those folios can be broken down and
> >> reclaimed.
> >>
> >> v1 did two things. It scaled khugepaged_max_ptes_none down per folio o=
rder and
> >> it queued every anonymous mTHP folio. David objected to the scaling si=
nce
>
> "David objected to the scaling", not quite. The tricky bit is the scaling=
 when
> collapsing (creep).
>
> When freeing, I'd assume scaling should be alright.

Ah, apologies for misinterpreting your comment.

>
> >> collapse had already rejected proportional scaling as either letting t=
he memory
> >> footprint creep or being confusing to reason about. David and Barry se=
parately
> >> objected to the queuing, which adds list_lru lock contention on every =
anonymous
> >> fault, and hurts lower-order use cases such as Android's order-2-only
> >> configuration. Johannes suggested keeping khugepaged_max_ptes_none abs=
olute and
> >> simply not queuing folios that could never exceed it, which addresses =
both.
> >>
> >> Read as an absolute count, khugepaged_max_ptes_none also implies the
> >> smallest folio that takes part in underused splitting. A 2M folio on 6=
4k
> >> base pages is 32 pages, so the knob has to be set below 32 for those t=
o
> >> be queued at all, and any folio with no more pages than the value stay=
s off
> >> the queue entirely.
> >
> > Em ... I'm not sure max_ptes_none should also become the mTHP underused
> > threshold ...
> >
> > Say we're on arm64 with 64K pages and set it to 16. Khugepaged PMD
> > collapse uses 16, while mTHP collapse turns the same value into 0. With
> > this series, an order-5 (2 MiB) mTHP enters the deferred split queue
> > because it has 32 pages, and is considered underused once more than 16
> > pages are zero-filled. So the same knob means 16, 0, and 16 depending o=
n
> > where it is used ... That's a bit odd ... no?
>
> I very much prefer scaling over using absolute numbers as proposed here.
>

With scaling, I don't see a way of avoiding having to queue every
anonymous folio of order >=3D2 to the deferred split list at fault time
in the non-default max_ptes_none case, since any folio can now
potentially qualify as underused. This drew some objections in v1,
particularly for the Android small folios case. I read that as ruling
out scaling. The objections were a) the list_lru lock contention and
b) the limited upside vs cost of splitting small folios.

For a), I don't think there were any hard numbers showing this is a
problem. If it would be helpful to have some benchmark numbers, I'm
happy to run a synthetic one (patch 3 applied (which adds anon mTHP
folios to the deferred split list), only order-2 enabled,
max_ptes_none set low enough, all threads in one cgroup on one node so
they contend on the same lock, each thread faulting in a large private
anonymous mapping). I'm happy to run something else if anyone has a
workload they would trust more. Johannes also mentioned batching as a
mitigation. If the contention does turn out to be an issue, I'm happy
to prototype that and measure it too.

For b), v1 unconditionally queued every folio of order >=3D 2. v2 added
an optimization patch for skipping queueing entirely if max_ptes_none
is at its default value, which would also carry over if we went with
scaling. So I think with that patch added, for the objection to b), it
depends on what max_ptes_none Android actually runs. At the default
max_ptes_none, nothing would be queued at all, so a config that sees
no benefit from splitting small folios would pay nothing for it.

Does that make scaling acceptable to you and Barry? If so, I'd prefer
that as well because if/when intermediary values are supported for
mTHP collapse, that support would have to be proportional, and it'd be
easier to reconcile the two with split also scaled. If not, then what
would be the suggestion for where to take v3?

Happy to also discuss some of this at LPC in person, if that would be
more helpful.

> >
> > Would a per-order value make more sense here?
> >
> > An unset value could preserve the current behavior, while an explicit
> > value could control both mTHP collapse and underused splitting. That
> > would also give us a way to leave max_ptes_none as the legacy fallback
> > instead of adding more meaning to it :)
>
> The problem is that: we don't want any new toggles unless unavoidable.

Thanks for your feedback, Lance - fwiw, it was my preference too as it
seemed least confusing :)
But I get the hesitation about adding something that can't be deleted.

Thanks,
Joanne

