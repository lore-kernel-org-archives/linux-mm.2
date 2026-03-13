Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 37158106FD6B
	for <linux-mm@archiver.kernel.org>; Fri, 13 Mar 2026 02:58:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4FDA76B0005; Thu, 12 Mar 2026 22:58:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4ABAD6B0088; Thu, 12 Mar 2026 22:58:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B78B6B0089; Thu, 12 Mar 2026 22:58:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 266276B0005
	for <linux-mm@kvack.org>; Thu, 12 Mar 2026 22:58:45 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A016559E61
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:58:44 +0000 (UTC)
X-FDA: 84539532168.30.7AB7DC5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id C86F04000D
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:58:41 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPu7I3L+;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773370721;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URXo6n7IN0qOlb7s8gZxbbOeAKyp6RsBYZjzWDBDbcg=;
	b=mEM1NohA6BlMYqlo0vJs6f15doc3jF4SAl2D8djbNpBaJIY4W6ZwGx9Z+LaEk2uKj35aA5
	9+9ToO62qBgnaKZvQfY1W2xZ4mqVXh96XQYfTxdzqBU29ySip9Zr7tkMh/d5nj0G9DBqXA
	YPS9PqA5ZFepT4abmS2BjKQ3iVVXkU0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=lPu7I3L+;
	spf=pass (imf01.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773370721; a=rsa-sha256;
	cv=none;
	b=MoDqaVXKahDtvY6NPr2tsRpi7Y1uF2V9ZKPi8rHY8cVuCTWfm8agk4epIi9/TbNAnKnBxF
	N4zOCfa70elaXX8vts742Hqye8y9QYPbBNOqUdcnZhuSF8gtyFmdo3AMBzS+/HLDSqnfYv
	DuRNwai4qhh3u0FeCbjtaOvB8MpAyws=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 0165661335
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:58:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAF5BC2BC87
	for <linux-mm@kvack.org>; Fri, 13 Mar 2026 02:58:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773370720;
	bh=K0jrg19P8Iu/nlZftvIqA5/cPhbQEq9I6Sfq37Rwmr4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=lPu7I3L+J0vBdgyRNoBXeM9JsG0i1lt+tN4h7FbQpwGyhIoUMXPJHwylekpLyBGjf
	 iiSUou0xehz3peAanV0tAyWRMC2pUbu36IrGnHbzXHAdgLTYiPLg+Qw6bwrpkTIEZ0
	 mx+E1HoByMnxOpBc1nYrFR0cDMV5TFq3kKu3BKdSq5IMGv8bi9R+9vV3DfOllTSKmr
	 iCWZxEXq3ZrwpIq6j7Arz6lofEwlnDhOi+C7dtD5BjlW9y5qylE36+kq9Mj9+t1i5t
	 iXYwT+IPUedhgEiGswa020j9uY9XzJpM9q5oQw0JQ08XUZP9riyNeNs8k6V0/ni2Aj
	 s9tvENMLAchLw==
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-b9382e59c0eso273643866b.0
        for <linux-mm@kvack.org>; Thu, 12 Mar 2026 19:58:40 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXTdWF/6AjV5TyA/MD3+tk5Hr4i7dI5ooMpcnY0f/l8EbmWDHcz6Nz/Zq/Xe4kgTZTQa3Hd7rNjOA==@kvack.org
X-Gm-Message-State: AOJu0Yy96bn/4dO/P8Y+wGEfKEoai/HqXabrMT4ilQe+XGBPyr0EbB7u
	1IXwFSlZzMrHFKGLEhB8uu3G9jJktaQiUmA1HgAo+bEXjHEN7hRasNs7ukHc73l4ZrZTdmLiPJV
	E5iakKDJHpkTvrUtVEDOVyMrAs0omFag=
X-Received: by 2002:a17:906:f8cd:b0:b8f:87a9:27b5 with SMTP id
 a640c23a62f3a-b976515b976mr77959466b.41.1773370719442; Thu, 12 Mar 2026
 19:58:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260312040627.55257-1-liwang@redhat.com> <CAKEwX=MqyGQSMuVCSWmhKfHju5uHBe3ySQEgK9XuKwCvpL4x8w@mail.gmail.com>
 <CAO9r8zPmV8v0tiQvn2xFqX8F2oU23mfbVK67nxMO3QKt49kJeg@mail.gmail.com> <abNtUReAUHT6j9Rn@redhat.com>
In-Reply-To: <abNtUReAUHT6j9Rn@redhat.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Thu, 12 Mar 2026 19:58:28 -0700
X-Gmail-Original-Message-ID: <CAO9r8zMh=tAV6UJcH3hhZWrZJO_emVe4raiq4wiBEgC-GAD2=Q@mail.gmail.com>
X-Gm-Features: AaiRm52el4UNPSjT5Jsb7Qove8ZY9-j0c5T-w67OOyJVuzPzLKcC_Enx9cGG_FY
Message-ID: <CAO9r8zMh=tAV6UJcH3hhZWrZJO_emVe4raiq4wiBEgC-GAD2=Q@mail.gmail.com>
Subject: Re: [PATCH v2 1/7] selftests/cgroup: skip test_zswap if zswap is
 globally disabled
To: Li Wang <liwang@redhat.com>
Cc: Nhat Pham <nphamcs@gmail.com>, mkoutny@suse.com, yosryahmed@google.com, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Muchun Song <muchun.song@linux.dev>, Tejun Heo <tj@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 855eibs9we8hj7cztj1auti4fr73wkiu
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: C86F04000D
X-HE-Tag: 1773370721-910834
X-HE-Meta: U2FsdGVkX1/N+M5somjN+FqAbk9JDigIU6ctVc+3//mw9w4avX82JPZ5Pnu81PEE29yWEq0UWl07my6hAxrUzkDD3pD8ucvWJcjbi41/uKrT5QNuv37FsosOoq7E3ePXYctr9hzsirgZc78FaG4dug+c34XC2slpV3Woy7cGZqBXvStwvBn3GBZ0mLSzq+kuLo+nDm5rUAtFK0rdXiB06BOHENDtvnS+touWRSMC0nbssQ0cMIJRz60TcNhh3ScjPbjikMhGq6kEmv4cESB3KtG8DFmPdNJ3KqaiPaHYeVOzeGnuBesY6rDlWDXQgjxjV/DBbHMoek2diQpWf+rOuJBX9MzoiUITXdMHXqs2toI9M2YlVEz7XkV8BoxwNZXq7W3KhZPa/78X042y/hsIxP0qCbSKUbDRvOsPxJrBC2DgxuLJqeHGYXN6uAJhbyPvyloshh/umJ2Ngu2qrW3eQNjdrrL1Z0HfZMKQQdIeiOQ5/amxnRH5ThSwVdPWKGOd+neuYksawkkLCxW9neD3zK+SlwdFefXXKt5MoOip9vbSdue5R5cgcWqmCVJaZZHDeVxF049lBA5oigs8k2s9mV8YDK3ejFtemQ1cELR5a7EQ1bth/8mGp53JhTAoFVbHoZ/1ThEq9C4/0Eo+7FX53Fcu3Rtg71tObFjGPFTjwTMsDoXvID85ZzVixy34kFaKd/Nt05X1RLWOQBs4nFYUhKIruggbpfgQlfILir3f3SaCMFnr6+8yDRKipcpcbOoPTbev5gPCzmiqJRJ55ertFRtnUM2P6fOE9ZU8yQRq9mZUp5kawPcc0yy0ow9XaIXP9mR87rdOxEZWNA6XQI8gMnlBUnV956gVtABbZHv3TXJ4e4kOn1b3Ucy1ysziDJVc3+tihx3ffkZK9sJYeU/NXJF0sNbohYAO19umiOevY1tNWKhRZCR/4N+1v6DR5fDN8wlb2gGuFc7TiWqwb/7
 Jz2mk64D
 ubseWMu3/NhYY03wH9t4E0T3/X+j/Sa0+N4F13usMlxF6r0A8NYvAMAYwc1rTa1awyYgF3k1SjpSJ6QZTq/Zo6RO9HqF7f3Z+jy/NUZ74PAo5ReX1Fq66bt5RltluLS8exlCnrD+VmzpssOi5ocSuyKEqQNjAGuWXceHdLthxL+E8jYhND8aY+N/unObhBR0S1r0a2WVnMshlJS6lAML2cgBnIR9c0ihyyTwfHawecE9wBTZohKE9SZjNjoMb9S/WS6Ac5RWYecBZ8ImEbBklSmEo25eUjQOvlkNaw8jfK+Il54tBZbpyHk9UnY3uH5jP5u5yGtJX84eszMUFZg6haXu7Nd9Os7oufqFA
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Yes, this looks more tidy than open it. I'll go this helper in v3.
>
> >
> > static void check_zswap_enabled(void)
> > {
> >        char value;
>
> read_text() requires string but not char.

I was just illustrating. This should be passed in as &value. That should work?

>
> >
> >        if (access("/sys/module/zswap", F_OK))
> >                ksft_exit_skip("zswap isn't configured\n");
> >
> >        if (read_text("/sys/module/zswap/parameters/enabled", value,
> > sizeof(value)) <= 0)
> >                ksft_exit_fail_msg("Failed to read
> > /sys/module/zswap/parameters/enabled\n");
> >
> >        if (value == 'N')
> >                ksft_exit_skip("zswap is disabled (hint: echo 1 >
> > /sys/module/zswap/parameters/enabled)\n");
> > }
> >
>
> --
> Regards,
> Li Wang
>

