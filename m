Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3DC7CA5FA1
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 00:27:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E39986B0093; Mon, 28 Sep 2026 20:27:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E114C6B0095; Mon, 28 Sep 2026 20:27:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D02E16B0096; Mon, 28 Sep 2026 20:27:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A3FE96B0093
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 20:27:49 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 37BC116037A
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:27:49 +0000 (UTC)
X-FDA: 85264911858.10.261985A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 44B9BA0009
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:27:47 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESq97FFa;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790641667;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=APJhL/UXcBCjjwICTLFT+qLin1KDXiRR0y2N5bPp8T8=;
	b=rhEvCOGBS9ZrUfytA0BJcQjeRmu6QNhyCUko/t3L+y53E0ApXTtt757eKJQwxuw4Icp2Dp
	h6DMAgkbO3dMfy0TLBslrYqGglzcv9xQL2IL7P1orr0nXk9oi/KsysuVqSaDQGq7D5LsyT
	M9CxMXfr2ykR/0TJhuOc5R7jmxyaj2g=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790641667;
	b=Z81rq7fTTddy/ZDVQ0kTk2SbaEnNsPEsWigKKUx+EZRhZBSqkHO5PcqVm/EFkCeSSIv9gp
	VYRwXJYxbqBNsYPsi+j9I0KD+8gcdkg70FPDB7JdXrOtdEgJ+goZWfWWbKbYQPv2BHQJfu
	AUyioeosvo9H1fcP5RUlIFZLby8q5uQ=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ESq97FFa;
	spf=pass (imf25.hostedemail.com: domain of chrisl@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 77C0D42DF6
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:27:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CEC21F00899
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 00:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790641666;
	bh=APJhL/UXcBCjjwICTLFT+qLin1KDXiRR0y2N5bPp8T8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=ESq97FFaS8q6O+WGq8mTMUSToYKUb+XzvsNnBGTw4Yfq//3liXu2B3bAv7bcygdli
	 EcHwpI4uM9pG+PUVngoWR6FzLO0tgC/0cKz935SPY0E8pLtZbxVA2GkK9LZprUpqw2
	 kp586WFL9UgLZZQwTNyhbLUWzYUgkY8T2hW91Gxa2Jj7QLSxcnI/egjRJOFsyE6zTH
	 MQitmOsQu/01PuHkjjIBs3OQA+lJn8aPHg151owirTWk+5lo2DtlA/4bwfsWrrPey4
	 MOb1YDPRUwN4TweCY78GvrHPfK0ZNR7urK4fizgTgf4M+q8ttD/pIntwgzWSW9hTmc
	 eAfxlQdMmxqdg==
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af9270c53so346517366b.1
        for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:27:46 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBy1YH3nYQL9zSoyuBhUhvL914IW91RB8bEwUNtmKx0UfuEZZcfdyspVE3limFyOKUiQxG3eUBP2Iw==@kvack.org
X-Gm-Message-State: AFuF++kkkS67/MBhE+oi/PmUQQ+V8SP58L7K6aJ/dEfvV11tIv9NoDxT
	LVoOCfKO2nkNiT3GXlXsQBMwN/YmOeJ7csv+fKKM/sMvVWCCR2TqSN15kNEfSv4XBDR49J1WezN
	GM1Hf8dPedtWEMphgdZONW/mkWJgXpNt4Sgha3IH5nQ==
X-Received: by 2002:a17:907:a909:b0:c26:1649:47b4 with SMTP id
 a640c23a62f3a-c2ac53fbdb4mr1170576266b.42.1790641665270; Mon, 28 Sep 2026
 17:27:45 -0700 (PDT)
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com>
 <CACePvbWM8kMjtJbH4vc6Qt=TBZQ-0d-Yj9NOtkepZmtNN3wd9w@mail.gmail.com> <20260928151924.2686290-1-matthias.goergens@gmail.com>
In-Reply-To: <20260928151924.2686290-1-matthias.goergens@gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Mon, 28 Sep 2026 14:27:33 -1000
X-Gmail-Original-Message-ID: <CACePvbW=fZ3G1JwnbiRo+_qsteN2smbbf3jX0UPFmhVyWA5_6A@mail.gmail.com>
X-Gm-Features: AclHuK_oifA42INPrgsCc_iqlMTCQtFcDVPMyqJSWfGYorE6tGAaJtv8iXHRTRc
Message-ID: <CACePvbW=fZ3G1JwnbiRo+_qsteN2smbbf3jX0UPFmhVyWA5_6A@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/swap: reserve swap areas for deliberate offload
To: Matthias Goergens <matthias.goergens@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Kairui Song <kasong@tencent.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Yosry Ahmed <yosry@kernel.org>, 
	Youngjun Park <youngjun.park@lge.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	cgroups@vger.kernel.org, linux-api@vger.kernel.org, 
	Alejandro Colomar <alx@kernel.org>, linux-man@vger.kernel.org, Karel Zak <kzak@redhat.com>, 
	util-linux@vger.kernel.org, Jani Nikula <jani.nikula@linux.intel.com>, 
	Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Rodrigo Vivi <rodrigo.vivi@intel.com>, 
	Tvrtko Ursulin <tursulin@ursulin.net>, David Airlie <airlied@gmail.com>, 
	Simona Vetter <simona@ffwll.ch>, intel-gfx@lists.freedesktop.org, 
	dri-devel@lists.freedesktop.org, "Rafael J . Wysocki" <rafael@kernel.org>, 
	Pavel Machek <pavel@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
	Will Deacon <will@kernel.org>, linux-pm@vger.kernel.org, 
	linux-arm-kernel@lists.infradead.org, Shuah Khan <shuah@kernel.org>, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 44B9BA0009
X-Stat-Signature: r8t4b9bgp9oekuk39ukfps6akr6ysmpt
X-HE-Tag: 1790641667-805832
X-HE-Meta: U2FsdGVkX1/1xv2uO1egF4KKjeOTm7/C6YX+e952WgXVU4G1/UApWthFzJ7O+Oh9QeSyKvIqJYAtueU61ITn7gzUxhuAvmcDziiIglfNV9AVlSSc3ILPq/qDm6yUDI/tEWo9/rnnA/85HiVSwKSiI+D5GV+mzZjEWUxDsCazBmWpu0ewaIgWgVSIZDfQTiAHQ3vYPvpyii158Y9akoGayIgrE0Gumt4q/IpF2Py6KBQm/kjeAOxd3mgaUdstFYnzRlLOo6mBB/UNkgXm8QXeGV584vsyPE9KkHx94s1tMPRBkhYqdrtW3ritq6aULar5OIJ0wGUYoCzqO0eyDfgO0biK9M1i6oiWMKyRbRf6Mupm6n9osMuw2dWRmv5bTQWy/Ze58dTrL7FkZbRGBrV85VOcvOQgL/UUthOInQJ6UWXIqymGMeR8gVC6SXQgsSoB41+4JQ8hC7b3ceVlBhR5LzIkFuVRSxXxD6stSRtmMkxcphDq8U6uUg67Ni3J4pdZFD1WDKdau++rzwoEBJoaMbAbu+QSMrwqlCO2YV2V5J1MChbbUr7EQ0Te5lUeaR/XzVN+m8l9CZ7AYKWrCAI5Kzff3p4Vv39wf9jpNlHNzfzpZfiW7ZjkIZjxAfS3n4eruZXQJWKjtRSjV7jjugAOhOhIfiyp1qP5rW8Bxcmzk5+RVUMbi9CLadza+t0QDMqjzHg4jdpH6PS6Blnf80eRqLr+BnmqlVqt750GxwKW9FchzBM646oUSlyY5nfav3crfr+zQQcNRZ79ykMgBHSuei/9/qxiex/0pbLQIc1Ds0JL2qzZGBI+JhWKyqI0YdStyEuCXduaVzSz/Tk7L5ZhI8yOMI6xpfb79zcBiflk0hU9ZUXpNdFNedhrUWbvGzTppJMBcWgC064hq3dbiWlRdyGtbEiI72A/w13WetFZEDayjP5MKZcbvYVgIRH+QJCodsWw+C41Vrj0tKPyR9i
 Cn0nVSwF
 DqZV07WKhD5cvIvqxU0XMOp9LN99QDK6MwLsXUWk32x8dttOFedTXsUWgB+y9dOd5h8VWORB0C+96I93qtRNXy8ePkKaVT8kS8cALDkh5f/nehuGB3Yhwp33LkmhNgRbqS+wqPyI/X2L9NngPBSYtSsgvoXZddCpvajZL19CV7I5GXLusPaZvb9igSyrlk2y9VNzbq4f78ZfpUEOWH6eg5rTw3Y66EuBup2hwtWZXWvUeEqB71uRiHcDW9IePTeU6dCnff1ZnSNdXalEHrc7g1JuHWdNUeyn/G3Asv3UFPy30HxE1XFcRKFbmf2GKRnF1J9jCB0jVx4mNHExrfRvcwMz4Bgs11rXQaIMwT1WDNPwuDEGSD2M9PcSGNtv7HEJ5tyyL
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Sep 28, 2026 at 5:19=E2=80=AFAM Matthias Goergens
<matthias.goergens@gmail.com> wrote:
>
> Hi Chris,
>
> Thanks for resolving the conflicts yourself and reviewing it.
>
> > What is the high-level user-visible impact of this series?
>
> Being able to use more interesting swap backends and logic when the
> machine is not under memory pressure.  It is much easier to write a
> swap backend that may occasionally allocate memory than one that is
> guaranteed never to, so today such backends are either unsafe as swap

I actually don't know of a swap backend that absolutely will not
allocate memory on swap out yet. Some backends allocate more than
others. Because the proactive reclaim can write to the non-offloaded
swap backend. That brings me back to my original question, in what way
this series helps.

So the answer seems to be that previously, some backends were unusable
by swap, due to possible memory allocation. With this series, those
back ends are usable for the proactive reclaim now. It is a 0 to 0.5
improvement because direct reclaim can't use it yet.


> or ruled out (btrfs, for example, refuses swapfiles that are
> copy-on-write, checksummed or compressed).
>
> > I am curious: if we never run out of swap file space on the
> > non-offload swap area, does that mean we don't need this patch series?
>
> No: running out of conventional swap isn't the point.  Without the
> series, any active swap area may be written under pressure, so a
> backend that may allocate can't be used as swap at all, however much
> conventional swap there is next to it.

But proactive reclaim can also use the non-offload swap area. So if we
have plenty of non-offload swap area, both proactive reclaim and
direct reclaim can use that non-offload area. The value of this series
isn't apparent. If you don't have a traditional swap-capable backend,
then your non-offload area is zero.  That is considered a special case
of running out of non-offload swap area: never having a traditional
swap area in the first place.

>
> > However, direct reclaim can use both types of swap areas.
>
> In v2 it can't: only memory.reclaim, per-node reclaim and MGLRU's

Sorry I meant proactive reclaim can use both types, nothing constrains
proactive reclaim.

> debugfs eviction may write new data to an offload-only area; direct
> reclaim, kswapd, MADV_PAGEOUT and DAMON reclaim may not.  But I think
> your suggestion to flip it round is closer to what I want: mark the

Flipping it around might provide additional benefit. I know some users
maintain off tree patches to turn off zswap on the direct reclaim path
exactly because zswap might allocate more memory before it can free
some. If the kernel can be smart about it. It provides additional
value to the status quo.

> areas whose writes may allocate, and keep pressure reclaim away from
> those, rather than tying it to what started the reclaim.  I'll work
> that into v3, together with Kairui's suggestion to build on the swap
> tiers work.

Yes, I feel that cluster-level marking might not be needed, you can
remember which si has the offload flag. However the per cpu cache
needs to know which context might require using a different cached
cluster. That is the trickiest part. The rest of the patch is just
enough plumbing to preserve whether the swap-out context is proactive
or not.

Chris

