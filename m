Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8C721CC6B2F
	for <linux-mm@archiver.kernel.org>; Thu, 15 Oct 2026 06:45:45 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F4DC6B0092; Thu, 15 Oct 2026 02:45:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A5366B0095; Thu, 15 Oct 2026 02:45:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5BC396B0096; Thu, 15 Oct 2026 02:45:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3CEFD6B0092
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 02:45:44 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9C603A0964
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:45:43 +0000 (UTC)
X-FDA: 85323924966.06.B943A96
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id AAF88A0009
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:45:41 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcA1zmyf;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792046741;
	b=TwlSL7yKNZelyscAHSSJEtUzqNoTFQITs58lea6s+rtTJIZvNHgzQZB7oTFLna7oE+MEfB
	unKLcOo2mEtO15tJAV3em0Q2C6KhFGqFLUxZvFrnRBe9EES5loGck1i6/Yezsc1HFBBISn
	7bZPoJ7mWR0yajFNcJQbhgUEjXo7byg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=XcA1zmyf;
	spf=pass (imf15.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792046741;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yUUb4aUA8pdKeJRIw+VsCp+sINCbCIsBC+z37Mf9fQY=;
	b=NPwedrBO/OcLHJ8C63ftnDzzqP2l7IV6d5TJQkIawa+wZ3WYWB5fv4vcFOEy27DFwXcX+5
	DrAdiDL3iNVqiRW7KQ/aeiU23IRlwTbKiVBdOjK5XlzaO5nFm5mWjSIajLZd11RfGQdGCn
	krWYiSPdw8mt7rFyrYHFDEgATi2SJOQ=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id D7E2244015
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:45:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FB61F000D3
	for <linux-mm@kvack.org>; Thu, 15 Oct 2026 06:45:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792046740;
	bh=yUUb4aUA8pdKeJRIw+VsCp+sINCbCIsBC+z37Mf9fQY=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=XcA1zmyfS9BftenEXmDqZGSMBPZ1gCM6B9qxBVH++lmXx893J1krgl1rnhryVyUm+
	 6eMLrGOGOdRx5WZVgj07DCDy3N7ZfqjO7Ca+vQEMXqlLM/RRRYZhKjpsehdNitTD9P
	 MWHtlbwAifZ01lKx9DpvoghRTpEfSFZimvccOuQYB86UGeOl7h4/+8SUXcSAmUMRTS
	 KbVzFY1kSuJW4FV+P33Jc5xttGPz0fqApOazmvvIudtG8cEuq9d555Ctz51q7sMiN7
	 4BtntSkbehq6MTDgEc59wYTnuTQK23rgmku56j5bO9purOoQsLMnk36iCFcNavsiY3
	 W2pnvx3KRCaHw==
Received: by mail-qk1-f172.google.com with SMTP id af79cd13be357-93e515769d3so418019585a.3
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 23:45:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBzGn++qlXRYwD5xH4be7HCq+d3+rykYloibHWNnqF+yUfCEefyQ5pUCP5u9ofvQtctRq0sUiIPlLQ==@kvack.org
X-Gm-Message-State: AFq9FYLcZg3q2vbEF8/oXc+EP14caEjV983bKUkVUM0wRaIZ+XySI7IO
	df0B50OSHtkmf8rxVbGYl0VshKHFzaC41loVHbyG5vp7k+zCEKpaYZNxwLcEeOngqh+LE8pdOWc
	BRCilObtZARvZvpF/wlTbcwAJjFVObwQ=
X-Received: by 2002:a05:620a:261a:b0:93e:3824:4123 with SMTP id
 af79cd13be357-93ebd279c8dmr2991150685a.65.1792046739772; Wed, 14 Oct 2026
 23:45:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1791968227.git.zhuhui@kylinos.cn> <20261014160910.eeaa24697b614d1b94806d0d@linux-foundation.org>
In-Reply-To: <20261014160910.eeaa24697b614d1b94806d0d@linux-foundation.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 15 Oct 2026 14:45:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zHz+o1MOvPjGsRJ2FnunJVRZb0=-p7Wr6Ow7Zrob5tyA@mail.gmail.com>
X-Gm-Features: AclHuK-Fc_kAdjk8wA-fg2GpyoQ84w7GpgMGZ8lA6hoeDLQdLpN79cquhXGAthE
Message-ID: <CAGsJ_4zHz+o1MOvPjGsRJ2FnunJVRZb0=-p7Wr6Ow7Zrob5tyA@mail.gmail.com>
Subject: Re: [PATCH v6 0/2] mm/vmscan: fix NR_ISOLATED accounting and throttle
 MGLRU eviction
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Hui Zhu <hui.zhu@linux.dev>, Kairui Song <kasong@tencent.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Baolin Wang <baolin.wang@linux.alibaba.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Hui Zhu <zhuhui@kylinos.cn>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: nsidgpcemtek7yqjrdx3ng6da9sjj8bs
X-Rspamd-Queue-Id: AAF88A0009
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1792046741-380373
X-HE-Meta: U2FsdGVkX19Zf9OuuLauEB9gPhHbPjxRT7k3v3Vi2hRewBLehtnHaUcYXzsp8FkROENBqpYjN3E/SaiIMdqwhfIDp6IEYYDHYrh+X35xhoMgfddFh0FVSkxOpcVkK27DY17a9mHh77gbWOqAguRjhwmHVdTe8E9ufuWv+h++Zp5wYXBzARvAtJmGkrejda6dP5Z2EPTE5TDqbuO138fFGy7cgzgzvdSHoQtzT7cv6cUEhhkvVOcMYjIO/iPwIUm5gEBjhnYNBd+ZwqYpSnvi8JTlPv97G69hZ5HXNDZCNeohIl2qWU/WNjUwi3BrMww9BPGVTsj9C723d03Xnzg1PTJTWaW8yLtAcuRKEUkaYlg3lGvn9G+zFqWCItNA6r0EWcO6fLfouiY+E+gBn7ZOVRj2ueHO8T842iyuc1g5zsN6mIYq0gD59yvKS2JX2vchRSsyA1YBrevD0m1AwDatg79wsMTyedpYgMu2wFIMBApFwwJpOqPXEaW69tTJ2JuO++J2iVxLnhC4H5MnTn98/47NdVznlgscdaUEK4EjAfSIQhNwlMjbMNBAadstx7yGhhpZ/xhAUYzvbPs8zsRnj7DEg996j4ru4AeObSo+Ln9gbdvKJ04bebf2M/D5CiNDMOwsBwbfpzm6hRrr2RSPa2Gi/Mi1F+ZT60+jU1hPDulD54Js1dxYLqRu5TkvOIvv6V8ifFS4CpqQ5lWIvn67pakFvh7dza7Zeqae4Wzxo/3mTrkl2mu5brNtRvgRrrQt9Wyo4jXr9WrqXb0tfQ/awNd2fSvHUwqB3vsBR4Cqa6tNIoD2E1NX2WzQiTqiR/cr2Tq13kDED9dQSCYwq/ixMEdn4xgtp1e7iNNuWB9WFPCiSAz/5fXNOp5YzDPzbogtnwfxhpt9XCWSAFk6CPJ9pWuHA9A4nN84vSegCcQdaAMyvljU5L0h0J+wVHB1gXLh9Vwf2w7Mndb3Q+Tz37Y
 mXZy+lGq
 tBDVoyu5RcKfr+fKAr4+Y7U2ptnH++FvPTKKV8ydvebAfbNFul+bPIdSiYrCUCBCgIIeuU5if+RJsFQ+MfAl+SPc9mWlN0bNmg3xovvxTZ313OSiBQO9QHjRHJHquO2wTVzKsyOxMzYYQ933AbuyXNhMRhRN9FxK9Tx0KGyxL0kNXSiwnwzITyJpIlEZfjmAK2nzhIeaWdTOz1ZuR7n3OAGb1kQdQjrOdLBArTQsH9Bw8y9EsKmtuT4YJ40VNmQdlb4Zi1VVihGId+Nwl5DvrbY8FM94CeQrDKQ6G+koU3wE5mfFUqLS4sVvS7YxmE+EXGncPfVBBonKT68lj5n9nY+4DSd8Et7K4UNC9j2Rr2bQnHV3cMg5+mmNhwuQoXd0kUmvrUKBwA7K0347ZNZimWj4dgH2+GPwUYKT9KMvHMWO+/ghaTos5AaSUkh2cHcXZiKxK
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Oct 15, 2026 at 7:09=E2=80=AFAM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Wed, 14 Oct 2026 17:00:22 +0800 Hui Zhu <hui.zhu@linux.dev> wrote:
>
> > The legacy reclaim path has two mechanisms around isolated folios that
> > MGLRU lacks:
> >
> > 1. NR_ISOLATED_ANON/FILE counters are updated when folios are isolated
> >    from the inactive lists. Compaction's too_many_isolated() relies on
> >    them to decide when to back off. The MGLRU reclaim path never
> >    updates them, so compaction cannot see MGLRU's in-flight isolation.
> >
> > 2. shrink_inactive_list() throttles direct reclaim via
> >    too_many_isolated() when isolated folios pile up. MGLRU's
> >    evict_folios() isolates folios without any such check, so many
> >    concurrent reclaimers can over-isolate the same (oldest) generation,
> >    leading to unnecessary swapping, thrashing and premature memcg OOM.
> >
> > Patch 1 fixes the counter accounting in the MGLRU isolation path.
> > Patch 2 adds a per-lruvec throttle, mirroring the legacy behavior but
> > adapted to MGLRU's per-lruvec contention and its dynamic type
> > selection/fallback.
>
> Thanks.  Questions for yourself and maintainers:
>
> [1/2] is nice and simple and reviewed.  How about I queue this for
> second week of the upcoming merge window?
>

+1 for this.

> [2/2] is much more code, isn't reviewed and has a Sashiko whine[*].  So
> I'm thinking this is 7.4-rcX material.
>
>
> [*] https://sashiko.dev/#/patchset/cover.1791968227.git.zhuhui@kylinos.cn

Best Regards
Barry

