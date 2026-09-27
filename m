Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B77F7C9833E
	for <linux-mm@archiver.kernel.org>; Sun, 27 Sep 2026 00:03:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 66BC46B0088; Sat, 26 Sep 2026 20:03:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61C1E6B008A; Sat, 26 Sep 2026 20:03:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 532366B008C; Sat, 26 Sep 2026 20:03:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 379B36B0088
	for <linux-mm@kvack.org>; Sat, 26 Sep 2026 20:03:30 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id BA3B9A09BC
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 00:03:29 +0000 (UTC)
X-FDA: 85257592938.18.8609955
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id DB028180005
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 00:03:27 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTFQ0HTs;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790467407;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dM60/lQJZNJbWoteFqu6uPH785ljbJ4v68GljKAZeM0=;
	b=rzvl0H/Tum917I3ixnWSXZxpg0gn7hQCYKt00y7Ih0OF+8wyWualJmqFWh9fwKFPV9A6rf
	L/4Ji6kewCENtHThtdq9NacFZkQvw2I/vAkssLY296JvV35tzW0FhIFkqm6JIrv0CrFb/Q
	ZFnAY9glUxPLUB7gHiXh7OsW4+itxZY=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nTFQ0HTs;
	spf=pass (imf06.hostedemail.com: domain of chrisl@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790467407;
	b=nx6LDRYD5Qs1tRI+0Fna4CDnX2a6MQ/H+fEGy4agnIOvfFXBXdEl6jdjTiRF+zT+vh5ZFy
	gquq4JaBk7fy/JE9T1FN9sulCrcjYMPT7Yh9FiTt/s7NCIrIa0ixjHaVTk1l8DwrgH+/an
	07xirWUR0sSF2SJs4to9YySE2dp11X0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 0708360A52
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 00:03:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A72AF1F0089F
	for <linux-mm@kvack.org>; Sun, 27 Sep 2026 00:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790467406;
	bh=dM60/lQJZNJbWoteFqu6uPH785ljbJ4v68GljKAZeM0=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=nTFQ0HTsWHZty59ZyFiVysLBkud65FLU8ajcvlt2l/ntZ4XwcBewkYCS2p+zTOoW5
	 8rETMYUwmr/ix/2vFZUjg8RFzTZhQWhjI8hGWVohh9bmLCDXCTEZyt5z4bvwOXZV4B
	 C+6KKoNo4tigua3eso72cH50Hu0E4DIvWZS6Y8sy+rHttzs9u8llwJDX5qKxBJwBUq
	 eseWVMz5P2JQSe0q1M82mECCmcS4JfmGjGmz6Sremt4AUX9DbWMu8bVuNB0dC4V2gj
	 /7AOsFLCH7waci4722LmEbHyGuhtnmEPOLMc9Qj63DsxQx3mtCgtSwRMKExZj2XENF
	 m5gRi+xlZa0CQ==
Received: by mail-ed2-f33.google.com with SMTP id 4fb4d7f45d1cf-6ab4b93bbe9so1194202a12.2
        for <linux-mm@kvack.org>; Sat, 26 Sep 2026 17:03:26 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvBw+j9dEkFSIiXTaeIOKTC9T4pZ5lca12/StGJF48viYlC6arHDPqGBkcWmCaSs+hM+ExafsGpRsmg==@kvack.org
X-Gm-Message-State: AFuF++mjX4w0t1DSax350NC2xYNSj1XC9u1Xs5UtjjrUqV27tNTL0Mno
	7VRUHOTU/3iWeCl8xTj+EJ44J0yg8+POPl2aZ2IQ+1pR6Ze92bB9fzEiVMzE0MAG6CyXNIkAe1g
	gYyzBrQBOLw4gbix1b1svQvGotuNiiFKwpUiLE41lzA==
X-Received: by 2002:a17:907:970f:b0:c28:e01d:1d08 with SMTP id
 a640c23a62f3a-c2ac268a3b6mr767904866b.49.1790467402757; Sat, 26 Sep 2026
 17:03:22 -0700 (PDT)
MIME-Version: 1.0
References: <20260926045517.3458413-1-matthias.goergens@gmail.com> <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
In-Reply-To: <CACePvbWPLegjMtF4jYN4+_1ZeoEuBHwZuwNyMpYwPZaA0edO5A@mail.gmail.com>
From: Chris Li <chrisl@kernel.org>
Date: Sat, 26 Sep 2026 14:03:11 -1000
X-Gmail-Original-Message-ID: <CACePvbU_6o_9fEFU6TJ9VaZ=4yBsDG5qXcxFkrGHBSD69m5ZXQ@mail.gmail.com>
X-Gm-Features: AclHuK-ZyMX3KOF420HwXlAK4cpZeFQwMK0gQ_EG8K18s67LKRQ8CucrkEWbQU8
Message-ID: <CACePvbU_6o_9fEFU6TJ9VaZ=4yBsDG5qXcxFkrGHBSD69m5ZXQ@mail.gmail.com>
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
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: DB028180005
X-Stat-Signature: dwbh89tcx8to6ceogj65tmnjrt15wbro
X-Rspam-User: 
X-HE-Tag: 1790467407-335378
X-HE-Meta: U2FsdGVkX18YlYBg+PSh2u092EiOMELFpMchAwdlT2kk0gdJd/Zu0m6oYTOhQ45wEUXTkwvuM7u8vnAiuWla5gHCUgL3SBEphTi0QY7l6pZzLQWRzXQ7oSQCCNzykvWYaW6FoigrNV5v2wWHPoiPHGPcpgRL191zu2o61pOgSOawRwHTPG5+kku9rXmEiJApwRWSup23qHU2XwTI+OA/rtvRv6JOVofbBzT5+uhMNS3Gvr/qJtBaJWBSUKdWuT36l/3/iWO/ShZjG0Axv1/UJTPM7wIy/M1GKYh9gxtQ27+B1nESln0d8zj/s+FD+7BTBnwrMSUVp1Iss6S948DjfB5TuhyVJg7ZnUZmmDYt7iNXr2iRi22EMa4mBC05PU0vbe09lrmpRgTCiivUZP331iwd5yF4WHRMCXC2myWrSZXu/5hJZRlMr9lCJ0UfSb7CVFOmeEf3dAOuY+7Gf7x2AytetWj/nuEz9jPuV6qlAqElKY8AyG1j7SIrtuRmKJZdxiRH8Veq9POBlT/HhzwDNvNG9at2iaaJjzk/x9WtxmGzxxx3FhieFOeF6b6lfDaou4IDvBEpUuz8M3jgLtOJKnco+ysIrn2h5KvE5xwyYECfDPO1bSpCKzXVPajlyblEFc2tncmLxa/2cwsa4eXkpAYxTdl4FUJAvHaHBihT7DERDwlm9bmDqqkx5SCI13Z/r7XUU5TJQIFmZEyj0NDiZnt3wNZEwz/X8EhXDGsaw40CxGn8s1et3TCvV+x9EU8Lcc7gE1APsWSQGwJkLQL4S5PLsafMfWJm5J7KYNFVRcA1XoE91Uhtix3kjfqljWyuJeX3Z5usypN7WirmTfB21y4xtAZu/+mvaucku1CqakL2MLI8mv5IpXQTQbGJQLxPW51FwmkXW2ZF4L8eA57RiFGvOEyQdh4YA5lVLZNxxKXKba7H7EhrS+E8Mnn6nrZmh6hlODXS855HmnSaLiI
 MKH1EXQ/
 j7uWpsOs6Z43NsAs40zIkF/2SNUUaMTY7tDdaRtE18qZ3pYnkBgtVqFXUyo/Z5NhyKqpZPWTK/KTzyB6fLyCFdShzXFQWT9SHdqSMd6jgL/BtFbdXGasDNWIslc0uwkc6zKy7gnlGU7DOxZYe7PELYQgbRdfdRtaScxY3ZTJvRlVUQoZjd7N5J5cM/yM0Cxw3ao4nuFTua8Nevw/+oPwysDaqAg1tgULOfhiVu4Uw4RYSgbZtjXlrxbv/Q/Fhmu+ksm2gGwhQ8rNl+M9w8gcnkZejp2+jlbf0hxD2qsuVepA1rRoIbvLJxTaSD42f9OHjDq2NRGVyz1cJYfKdr2F/ipcZQkDdeBlppCOZXxWzqNpL+5jNO4rgvFCaHD7jBTjD/WKxw1MUmw7zxzQXTrKkPerobQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Sep 26, 2026 at 1:32=E2=80=AFPM Chris Li <chrisl@kernel.org> wrote:
>
> On Fri, Sep 25, 2026 at 6:55=E2=80=AFPM Matthias Goergens
> <matthias.goergens@gmail.com> wrote:
> > The series fixes zram selftest device tracking and error reporting, add=
s
> > the swap policy with DRM eligibility checks, and tests routing, working=
set
> > activation and retained-entry write refusal. It is based on mm-new at
> > 995829088503.
>
> Hi Matthias,
>
> I can't find mm-new 995829088503 anymore.
>
> Your patch does not apply cleanly to the current tip of mm-new
> mm-unstable, or mm-stable branches.
> Do you have a git repo with your patch applied?

Never mind, I have the conflict resolved on mm-unstable.

Sorry I usually need to have the patch appliable to use my own review scrip=
ts.

Chris

