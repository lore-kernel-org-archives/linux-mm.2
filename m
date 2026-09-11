Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C89B5C88E53
	for <linux-mm@archiver.kernel.org>; Fri, 11 Sep 2026 19:04:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D97736B0093; Fri, 11 Sep 2026 15:04:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6F0D6B0095; Fri, 11 Sep 2026 15:04:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C87076B0096; Fri, 11 Sep 2026 15:04:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 9F7746B0093
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 15:04:15 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 884A8120327
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:04:14 +0000 (UTC)
X-FDA: 85202406828.28.E81C732
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	by imf01.hostedemail.com (Postfix) with ESMTP id 9494A4000C
	for <linux-mm@kvack.org>; Fri, 11 Sep 2026 19:04:12 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T6LWawlN;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789153452;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
	b=Xz46hXi3G4L/h+/OrTFI7eHu2aUH/tPUe0eiqV8tyrouv3hm4gCHEgM6tN8mNWnuQwxexW
	ayUo7l2pwSTcdWZ4MLndSYviuohvOSnLRvX+hTG1D2jU9bK14iSxWKfohuqbsbOFgvGM29
	3zLtWOY2gthivSuIr4TLNwgyDie2Fic=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789153452;
	b=y7MYOtJ6TocaSbG+qrTt7XPx1t/kYCe0yNl212b4t8/mtnLU4u+nIdyjQg8ky/SXyS92jj
	0UjHESWULVTKsqHV722Wd2P3MEABlrRVUZowrJim8gpVp4KQCVcf+5+ut94w5SKvqMpNYr
	amIA2jV13bQbVmmMTrpFZN2PnZDS4Q8=
ARC-Authentication-Results: i=2;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=T6LWawlN;
	spf=pass (imf01.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.48 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-495437bb891so6337905e9.1
        for <linux-mm@kvack.org>; Fri, 11 Sep 2026 12:04:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789153451; cv=none;
        d=google.com; s=arc-20260327;
        b=MRU/OqZbSigybRw/7L/d7ZALTzssyoi600OrNAjYRvSTVngKlPt7+ZpXc0XnHsO92F
         bGrcOr+WEQTLADJiCqfJLoND/984PrIJbdDOUkJwWUnFMfzf+luCcEbFPRE+KH3/f9Jd
         DD79s48PbRcPgrEA92lxrXgSrJmcH12m5adNk+9d4PlU2NOkh/luAhK3veQxG3YzYmIT
         JEdOv1qh4tuBTh9pHKag2FY5t/HJ0wuWSgOYee+sQd3xgQxb43+TGRGHFna7KMnu4Bps
         GUBGDvMz+ctVWzqaKwEb1PVBidzcM7ogW8fysAobY4YwyKOjxQmLN4vasGHHBevRActs
         fqVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
        fh=Q4V/Xulcy5PBj1/eFzf5mQFFhqYZyrqwK7BeK+ikjHg=;
        b=Uh9HieUJ8KnAxTQOuMV4PmCGbHFw0BBa4mPKxzpidFJLe2PK6MlH7fHe/Oa4MfWA9F
         7+B/VRKnbXeiCR10cAKe2G2ECpx+8kjCxz6Pg9+xkrm6CE5cre0MhziMBUbXNnzHXu46
         rnZLVH/FOw4SZDL/L2zdi7UHaQ+MdQbF9hbGNoXAAgX5Tq5ozNTNGCHhLqdPsvGcJy6Z
         dKanx775nzUxwucRITCPIsdzLhOQTibPNWxBLVHrExamgjI/Ov4whLPytlUh/8l8Gq+M
         owEJ/BWdl0zXtO1RljUDC2csyulScQxk4oHCs7kJts2vXYuJ0lO/J7SUSHgbz7hQwgO4
         RXqg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789153451; x=1789758251; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
        b=T6LWawlNgJm1nyJLT9pGFYcO+flIBa+8xSdc+KVHyJxaMUODjr/FlRnnpV9PtKIuV6
         /p9JpIw66O4e/uIBniO1lSqaSHX1Zvxs81uQ2ynUK34qY4udQdg9OfGIfCdTf2js5jo6
         +XnUln0h4O+Zdqa0IH5ZCk5dGJAudOugpkSHN+Z4AKZ0Ig6zY/pDSXOSNlybkiRn/YDT
         WDZQfH+K5rVpPJDS1GNl8LQ1fim4M/sHezOxfOD//+JdyxARoNQgLnZ7abb1jp+Mgjiq
         9gjjLpIZiNRwwUpkXKJioOc3TXnK3bcG52zXUY3/EjywdIA5vguTVpOnLLvu8zgCywVX
         PoHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789153451; x=1789758251;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=trX+U7XJlu2wfrqosEL7RKHWRz95q3a0XycwYv9NMmY=;
        b=OP2Zn9QUqC4Fi6bMwKYwoNpqle2UJNRTAkF6Stg7VOwWQT2K3U8B3jgWbJGSSvi9fa
         JVGgEUmL8b3n2xw0YE1Pv107/c1Q23HpTh9wsZB6bg/0HA0T9RDoHT8kqYGy+WY5yAvr
         +YNXJnCK+WnXNJDEscCWiq/5iqn9ka+cn1s4loWHWA5ylc2O51tcvvmdSldhBFehCdDq
         5QfKJS37hzyAdY7nlI0hqkRONaZk3iqPvXbhOWOkztHl+Mm/TmXCG3kt0YSA5KbcD4sW
         K43vkgHh7K8hKHN3cWJPG8s2Wk3dipRxpA6PLqSLP9bXI3zjgwv3Qqd0wP5qi2/oGpKx
         I/5g==
X-Forwarded-Encrypted: i=1; AKwUvBw0t7J5JNa8dnzBBI9q31XddIE8RF0sMzzAruJDPTd7K+O54FOkIbb5Z+c8oTQgWcwTTZIU+hnTug==@kvack.org
X-Gm-Message-State: AFuF++nZxG8udUyEufUifN+WToZ/FXvGFX6mUE+z+9z5G9iYCaHuC++W
	naFUrv2CF3GpqSPl0iL5fr8wDftcKcmHJ5K+3sovtTvwBsvTE/pJy4gtTA1zSFnyV0iauq67Tb3
	xU47QAfdVTPPHFKJzdWJVjt36Mi0v71E=
X-Gm-Gg: AYBFou2UZsQD3GmVG+iTxRdEQhG+WtxwZlJyu/WNqcXfR1BjAY6QBG9l+frLX40Nvig
	sRp9kz1Np3mKv62vyu6D6MlEHWgPRNBLjfNMH33Myq2B0dikZymUVKOc4aSD+eIJbOq1Cx2nRbO
	YD7r2c/RApoOJElBgDyC37/hLT/GcDBJwjZoTnn1++3AboYvsBgBaAPE8EOfsmEx74ei60DcOZI
	s1tj8EPDQGpfSYFvU4H8J6/fdSLhi40BxLoopoZl5SxghR3yKxy3GaIgxim3gEMIW0lKVupxT+P
	/gxYqRIzjChujwN3isa+S4HRuRii7TtqQdR+NYSBPa/UVmyuX4vyo4W+c47YzB3Kw+vrgBro0Nh
	M1Y7UxisdJB4=
X-Received: by 2002:a05:600c:3584:b0:49c:ff66:7d88 with SMTP id
 5b1f17b1804b1-49d26d7f8a2mr170508775e9.7.1789153450782; Fri, 11 Sep 2026
 12:04:10 -0700 (PDT)
MIME-Version: 1.0
References: <CAKEwX=MP=zuTnLT=coS_EpXe2KwXq=79yBnsEGXwcZZsW3S=Yw@mail.gmail.com>
 <CAMgjq7AHRzBsbmGOx0s=TQFBwcn=DEU1naR443sO6x+pJd6hAg@mail.gmail.com>
 <CAKEwX=O8i+OsP6BJXNZNk07hveN9HDT+PoyMTAU6gOc-xp0Ppg@mail.gmail.com>
 <CAMgjq7BQeQQOZMDPFJ+8LS2N4t3x53r6Nm+9o0_pi92oVUgjgQ@mail.gmail.com>
 <CAKEwX=MS-7C96i4tzBijHN=-xuZgny_wQEa_0YjfHzhoNysdYQ@mail.gmail.com> <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
In-Reply-To: <CAMgjq7B7Mc7vpQN0gBknsSrfZWXdif5L7nU29YskG9mzS-_jsA@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 11 Sep 2026 12:03:59 -0700
X-Gm-Features: AcwNN1WTqoBlEbiKI6CdE02QFoxhwTxTh-PKBQg_YuUX7rc2TMIFeAiuSkD6Ytk
Message-ID: <CAKEwX=PxZ68_4240DC8HjcqPRE0bQWGmouoqapqqTQ2b0xqpvg@mail.gmail.com>
Subject: Re: Path forward for Virtualized Swap?
To: Kairui Song <ryncsn@gmail.com>
Cc: YoungJun Park <youngjun.park@lge.com>, Chris Li <chrisl@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Yosry Ahmed <yosry@kernel.org>, David Hildenbrand <david@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	"Lorenzo Stoakes (Oracle)" <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, 
	"Vlastimil Babka (SUSE)" <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	=?UTF-8?Q?Suren_Baghdasaryan=EF=BF=BC?= <surenb@google.com>, 
	Qi Zheng <qi.zheng@linux.dev>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, Rik van Riel <riel@surriel.com>, 
	Gregory Price <gourry@gourry.net>, Wenchao Hao <haowenchao22@gmail.com>, 
	Jonathan Corbet <corbet@lwn.net>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Tejun Heo <tj@kernel.org>, 
	=?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	Shuah Khan <skhan@linuxfoundation.org>, Kunwu Chan <kunwu.chan@linux.dev>, 
	Meta kernel team <kernel-team@meta.com>, Linux Memory Management List <linux-mm@kvack.org>, 
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-doc@vger.kernel.org, 
	"open list:CONTROL GROUP - MEMORY RESOURCE CONTROLLER (MEMCG)" <cgroups@vger.kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Joshua Hahn <joshua.hahnjy@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 9494A4000C
X-Stat-Signature: ps61gxdocdkzuqfay4rxhsj9pwnz9gi6
X-Rspam-User: 
X-HE-Tag: 1789153452-26744
X-HE-Meta: U2FsdGVkX181OEVSWd50KzSj1/E/r6Ei41x2Y6Qk5tfnMMpQowwkN9lm0MHYlkPP/9+XMvMoRVf58XeOv3kLKeeP4RWfRLeRgAMDAZ8OcgKgz1kD+nRpJs0/51SJelKhGyBrSbAZr4kVRE2i/gqYtUkaCRwq7kA3dU5VoUa+sSDk1SWm68iilIYvBWM3/hRiwJDMFHC+yPgX69IlDx1tneuCoaZlXKY2EuEN0IRa5h3TZ8oxqLc5277OJCI7f8e83rfUWcYXG5dXh4W8Uj5UV0VKV9NFF5wswk55VcTrBbINBrsAEieVBE9K+sI7+rAE3hnTQp49GIdQ6rWks/+xOc/s5SdWfulv0KCyYQqOTya+ApA2EYk8PGl5/33E5nvztIm1l3o5uZKjQ1o0p/G3VnOWwdDTujBxsafmEFoRt1dhcksVpOKTVXADum0GhHWDQlQLa13w00I0WwUE2SqXX5f91lIeu/WqIKFbemSANunOmV9YmC6dajnhA5fdIvAFkxuiP6m9cQ6bBuFwU+8jvJE4WYj7UHNl2Ed6K0YMEleEd4VZatOnpQHbDUzN9ywyvw7jqdcsDxZlcAd9+bnyxxjDEEDm6KNQgTRvduVwTj2B2/BGa9bSpg3ijl4jK8YBajPWw5++40X4MjDF6xRw+exlApW40UHzKXteI9SiB4fxtX+pt2C1xya4gYdhwMPK9Eof0L8qnESMKl8RrIjVrWwwyySo0ukxFFHhmhEIgkfcpzuMrwWtO4LOwfyX5VoEry0saXkOhY9P2HGP8BBu9EVtQJO0tJczWqeXmfNHloCqq+n6erp5jKIs8Zbany5w5a6TqAuDhsd7UQUnOPdPJjbKf3M8GXaoqENkRGM9hbGrYOcvdS8+jjmzzGhKNCjGHgImKQRPi78sY1XCjsQaRX3rhPLYm7cQbGCgOlEPh8IAXnsmeDDBd8j5Zx7OQqOQPFlCBaf/NC2nRaMfvzq
 md7TpwZb
 dHAEIg4p5YfGmS4ZoN1rSfHU3O9QHSUyzyjhTlcEwzOKMb1VUDtTVkruUIO9nv8SQ0fcB4WDrDkOwOrEQdRWg0wrmX7+6IlQ3t15u3xxaHdyPrdvO84rqFnBasPkHzhGleicTZpqKoS9J1Mr8zO0us7unfHoJF7vLpgW5eVs9zjT+4amALPPc3pGiLPn3iHY2FUnc6DuU2G/6kDNQllMYb4yK82xo6oz3Qr7CfhvY70bXpbyIwvQWjOrWjzzRfBq9SW2+kibHdAGKivtFvnO+VozilxLy6k6AR3vXs28T/4tih6fl84Y8V3THxj44SKWJAMqaHwMeeD/Ys14khsbqWJ4KGXxb6wmgjV98VJ3kj0LpInSDpP+TzxMbhaL/gJ24syVlpywmeWIuGrWZ60mdJSy6if6LMvf0Br13L0AqhhmyCHmdIm2IL1qpoboSLAVox9BtrXnV4QjVVMiR+EWNqvg7VFQzKP5TT35VTXXtpZa4Ag7wnxMy9qhvQDz/n4jGLMXfZDDWCXmkev7flKje017OfbZ0JBRMVEUF9Z1YiLgGL310jr0zzVBaoDTVZQUqMvhY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 11:14=E2=80=AFAM Kairui Song <ryncsn@gmail.com> wro=
te:
>
> > Would something like this fix it for you? ZRAM users will not get
> > vswap indirection overhead at all, because it would bypass vswap :)
> > Down the line we can revisit this decision - for e.g, if there is a
> > use case for vswap-on-top-of-swapfile. There might be other interface
> > that makes more sense.
>
> Hmm, this interface looks confusing though. you mean tangles vswap
> with zswap through the cgroup's zswap limit? I originally expected
> this to be a problem solved by tiering, skipping certain tiers seems
> much more intuitive. Maybe Youngjun have some idea here?

It wouldn't be confusing if this is something users don't have to
think about at all :) My point is that we don't have a use case where
we need userspace input on vswap-enablement on a per-cgroup basis yet,
so let's just keep it all transparent. From user perspective, they
enable zswap, and it just works - vswap is just an internal
implementation details.

I have discussed with Youngjun regarding vswap participation in swap
tiering interface in the first version of this new design. It's
technically achievable, but we decided to post-pone that for now until
a true use case comes about - trying to cut down as much code as
possible...

>
> >
> > Potentially, but we have many users at Meta. There's a huge diversity
> > of machine types, workingset size, access patterns (both frequency and
> > file:anon split), compressibility, etc.
>
> You can just set the number as 8PB? :)

Sure, but with the vmalloc-array approach, there is more metadata
overhead even if we have not allocated the backing page of the
clusters yet. This will be annoying on the smaller size machines
(O(dozen of GB)) to also pay the overhead of 8PB-swap space metadata
reservation.

With xarray yeah it's truly just a number limit. Put it as big as it is all=
owed.

The "allowed" part brings me to the next point - not sure if you have
seen my other thread, but I think we need to be even more careful with
this limit - I have found another weird interaction between memcg and
swap subsytem, specifically with the refcount of private id. I think
this is another argument for transparency - this limit is now also
capped on architectural (page size?) and implementational (refcount
type) details of the host and the kernel.

https://lore.kernel.org/all/CAKEwX=3DNYoMH8pTKeCvA=3DXHFmmNVMeDz3mxbhp5q6-P=
xSTJ5wOg@mail.gmail.com/

Seems a bit much to ask the userspace to know all of this. Better to just l=
et:

a. the space grow on demand, automatically.

b. the space be limited by an implementation-induced cap.

all transparent to user (until we have a true use case for a userspace
sizing knob).

