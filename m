Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 94608C4451C
	for <linux-mm@archiver.kernel.org>; Tue, 21 Jul 2026 07:46:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 597A06B0092; Tue, 21 Jul 2026 03:46:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 520E16B0093; Tue, 21 Jul 2026 03:46:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E8976B0095; Tue, 21 Jul 2026 03:46:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 06DAD6B0092
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 03:46:07 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7745F1A041C
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:46:07 +0000 (UTC)
X-FDA: 85012000374.20.30808C5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf06.hostedemail.com (Postfix) with ESMTP id 85A9C180005
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:46:05 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJlTm6Jf;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784619965;
	b=PLcrHeg70j9c+DGAHXrOUeLBBpQNGeoj+B8RJ/Lu4Vh0ojvPPLxxtpW/mNMDE26uhGe0x7
	9OabvRwcelnLImsgE0bMxL0mk3fhKYrfiBOesXEpG5h5YX4yn7UphzYkXuN/nSTiVJy7FD
	ai6xxfQBhGhQPJ44nkMjxW65HJH49mk=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hJlTm6Jf;
	spf=pass (imf06.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784619965;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hC8gr9AKewKOGTzEFs4Ib71/EAJ2KEdDBV83fJHsKJM=;
	b=tb2hGSjDTMut8cwzXhyZA3v6/ES6XPBJMl1OO5s5DvvBwJbldiQZvkNr6VMQTSghiED6cC
	ZN/1PCA0UIgxXhLlAUtYbCbUTOOAzE1rba1sWIQ/A3UoVOXRexwu73MX6gTgarZCiytMv5
	BmRoz1sTHW2zPXmPNiVifV1T2tmVdgY=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A2BDF42A85
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:46:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83CB31F00ACA
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 07:46:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784619964;
	bh=hC8gr9AKewKOGTzEFs4Ib71/EAJ2KEdDBV83fJHsKJM=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=hJlTm6JfnXC7I9TueMVzyBTvkNCLeG6Jt7dk84g356h5agJ5B1EVFhiBsZG2tRWnz
	 E/p/LQNW9KRUcaE7K/MH/NqeTO/db/LugRrBqYjlMo+oEFFrqqOA9/vCQIFDF/Qxuo
	 Ut26hUu5YT8BxYXEhrbfHIy2qP7vbj6cG36hCXWWHCTXJvaM9ZAj4L5yAWgGAS/taj
	 GDv5cpfS26KwQ6Fb1Zie1xiC8IRala9zX8PZz3m8HW9CjKSuVWdRbo9B5yGLQYfPGS
	 Ft0VrphTpZkGRr3GzwdIfI3o/BRZt9lww1r6NH1ikcg2v68IwiN1IPlo3L0F2oJQum
	 943+nTztXx96A==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e7c6ec9dbso578453885a.0
        for <linux-mm@kvack.org>; Tue, 21 Jul 2026 00:46:04 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RooBrRSmtdzX8aPJyCtarNqwpx7WAo7uv2/Edkt7cfKRK9vAIYwNxa44UxTv3sXksXjeyWpHvCrmQ==@kvack.org
X-Gm-Message-State: AOJu0YygdrjhDr8IUuy77JJfyQuAeptOspK/q79oni4c0BS9yt50ZuYK
	cEscVLrbYsO3tranvp2KR48022r9Ted5kGboWDhGTkLWew3erwuRLJQEQg12xfUFpOnjAL5nTWt
	y1AN0Yogk8lN4MLlnso7RJGpoOTLWCWI=
X-Received: by 2002:a05:620a:19a2:b0:92e:cac7:96fc with SMTP id
 af79cd13be357-930b3ecbc06mr1683202585a.24.1784619963922; Tue, 21 Jul 2026
 00:46:03 -0700 (PDT)
MIME-Version: 1.0
References: <20260718095251.82937-1-ridong.chen@linux.dev> <20260718095251.82937-2-ridong.chen@linux.dev>
 <CAGsJ_4yYEaoiTY0vFtqJK5fsXZW2PTkMu-qZ=X7=cqmMVa3YCg@mail.gmail.com> <bcace78f-987f-4908-9e65-bf0b9a52855c@linux.dev>
In-Reply-To: <bcace78f-987f-4908-9e65-bf0b9a52855c@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Tue, 21 Jul 2026 15:45:52 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wbLAky6B9gPGmyLkZPaqrbC4eSMXXK1n4bLfnzs5+-sQ@mail.gmail.com>
X-Gm-Features: AUfX_myyqM8vasa6d2iDy7s-Py0IocpWGMwTvFjIRBaJZsauVjjDh2T3dOdN1BA
Message-ID: <CAGsJ_4wbLAky6B9gPGmyLkZPaqrbC4eSMXXK1n4bLfnzs5+-sQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/4] mm/vmscan: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong Chen <ridong.chen@linux.dev>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, david@kernel.org, 
	mhocko@kernel.org, qi.zheng@linux.dev, shakeel.butt@linux.dev, ljs@kernel.org, 
	kasong@tencent.com, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, hezhongkun.hzk@bytedance.com, muchun.song@linux.dev, 
	dave@stgolabs.net, roman.gushchin@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: z4dkz33w8mo8k4q84fchincabqgc911z
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 85A9C180005
X-Rspam-User: 
X-HE-Tag: 1784619965-241286
X-HE-Meta: U2FsdGVkX18qbBVxi9dpHI3PMwoqV/odIqSJYQUn1VvjSHSl7tNZjlts8Tdix/B5Nu1Lfag8lJlaDolfZRLG5ldRDIAFXiIUy/3/x9qlydlVVeeh8n1ADJUIKp/NLMcIa6mdRN2ZMGz1+U6ElyHu9W/HjoqDW0tkEdshCloe7yZar4HlSaDckbjH7NE/3QmRMAsYf3x8Cfux3BHQdlPRUB8j81u2e75hUHpVPobYLWI6nXz6UMaOOZTheEHeCSTY7rspuEHq/sU26cP4Z8HBaC+guaPBglEPsuPONk+vdizLHZyZSRA+jCBu3qnvif1aoth5FeBAIn+cbCJgyNoiHNEpDVh51KY72SeYbLZXNRP8pxA6KnPx35HmBMfO6QWqmCW4hkKcGGG8QsEMw4R9yAGKrf+GfI7+1sY+rrOuA2//qS9ufp+VvFx5Rzoxl1QQ0AbHmcfPYpL8TukJca0H5vFlDPhrOwUdQJFRuUO57koh2E91EUBuAHI/YftyL6Jgf5gSKZVZdrXgBLiJkLKjVNQDDPIYU8FVzmfXggUGkIPEAsk9aM0bpEhdNtxQ7S7xyKQyfGhFR1Ox1YDeCcE+bgNv3ZX7oRMqOQp9ks2Fkj6qr6VcRyvfhoxV4sWBf+CeRiE7EGIsdwMMUi/uYKiEcTdZeO1xKuG6fYG7jHppGCPrpdT3vUTkhLoLd/oAiNoA2rodgpGHDBet98ZZHY8EVo0qV/0UqSCK/REgAe4039SDYuCi/SQFLjN9oT34OffcXA6Y/K3dASg6JwaHo0R/CIGMoGfpyVjgP/Zy+eVbZDQ/rK4+J6kp44peEaD37JwXxrMFIojlp/ym2Org8gmeW9G0OZm+O/EO1FB5oCwJb5UEk5R4rc+RRlbSUWGditmGYBbEuG6CmdCt9U2JpBq7xdmmUV0TQ+2k4tRlS/ICyt1Up6T6PQs2/0otBeRsovRWU2KJtoZIM2nsoBV/Vhe
 iu7+XYee
 iBH5JtF5EZSy+aFy+HibTFEe3auTwao7xIQEdu0WgV1SXEmvEfZf6JQNgFnapKiv0+9ICRmax46QOO1LaIpbL+ifD8htNTxJ6+BEOIvL5s8VAxspwIoLgwBKOcB9IkvyNVj2omTePMJJp+G7ulSThLe1gh5H7y9s0vSgbCNQKR3DEzkU7hD081xgi/xfH16K5Z/rMkL3EW97/8ZdIgNM/D6ZjnArNHbhYhKdg7TlenS/ixbzIPU8N3+dYbHdOdqagkKjSYW8z/PmkO0P9NNxGAAuxwiRSooJxX+Bw
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jul 20, 2026 at 12:43=E2=80=AFPM Ridong Chen <ridong.chen@linux.dev=
> wrote:
[...]

> >> --- a/mm/vmscan.c
> >> +++ b/mm/vmscan.c
> >> @@ -2501,6 +2501,17 @@ static void get_scan_count(struct lruvec *lruve=
c, struct scan_control *sc,
> >>          enum scan_balance scan_balance;
> >>          enum lru_list lru;
> >>
> >> +       /* Proactive reclaim initiated by userspace for anonymous memo=
ry only */
> >> +       if (swappiness =3D=3D SWAPPINESS_ANON_ONLY) {
> >> +               WARN_ON_ONCE(!sc->proactive);
> >
> > I feel it's a bit odd that the WARN_ON_ONCE() is placed here. Maybe
> > adding a short comment would make the intent clearer. For example:
> > "SWAPPINESS_ANON_ONLY is only allowed for proactive reclaim."
>
> Hi Barry,
>
> I didn't change the original logic in this patch. I agree that adding a
> comment would help clarify the intent.
>
> I'll include that in the next version.
>
> > I'm not sure whether it would be better to issue this warning earlier,
> > for example in try_to_free_mem_cgroup_pages(). That said, I don't
> > feel strongly about this.
>
> Since patch 4 will address the MGLRU issue and could also include this
> warning, I think that triggering the warning earlier makes sense and
> would be more general. Would it be acceptable to add a separate patch
> (e.g., patch 5) for moving the warning? That way, each patch stays
> focused on a single logical change.

I'm not quite sure where the best place would be to move it earlier. We
already have two places that perform proactive reclaim:
try_to_free_mem_cgroup_pages() and __node_reclaim(). There are also
other reclaim paths that are not proactive. Since they all eventually call
shrink_node(), would it make more sense to handle it there?

If we can't find a suitable common path, I guess simply adding some comment=
s
to the current patches would be good enough.

Thanks
Barry

