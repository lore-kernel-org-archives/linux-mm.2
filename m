Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F0D72CA0EEB
	for <linux-mm@archiver.kernel.org>; Thu, 21 Aug 2025 16:43:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 34CC48E000E; Thu, 21 Aug 2025 12:43:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 324358E0001; Thu, 21 Aug 2025 12:43:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 239AD8E000E; Thu, 21 Aug 2025 12:43:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0FEEF8E0001
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 12:43:00 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8A179835E7
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:42:59 +0000 (UTC)
X-FDA: 83801334078.02.45EE68B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id E78941C000E
	for <linux-mm@kvack.org>; Thu, 21 Aug 2025 16:42:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PtigyZr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755794577; a=rsa-sha256;
	cv=none;
	b=kf3u4ILcTIq9rm++XAxtEwZqJNg8/eOkC5v1t4P4qXjxNjYoMSn6PwMpKZxUTyi7wF7AaH
	qhhlz/aQn+ToKlM74Y1SxI0VcsQJ3uczWF0yHvrvbZ/r5gar4zMp1TOFKii5gAhw885ElU
	rZo5JqafEBosX+Ne35941Fny+tBsP6Y=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PtigyZr5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf20.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755794577;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=u490Qn26wNxCSlEwqO6KX0EhYwMktuOl6PpgP4Pohdw=;
	b=yKQb27GD42Z/Wh9yBRFiCTYz64i4jBv/wFsL4f6MlMqh9TtvHzyYMASLugh8OgT3SnU6rP
	YAkM4B9cAR78nrOGKIS57J2WVKXuSAWLgo1uh7F1WPYTmSDAkWb8Gn3L2tbAxFGWAD8OTF
	T56wi+kivVcBzyqWvKrhRwuqtPyB+7Q=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 36EB1601F8;
	Thu, 21 Aug 2025 16:42:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0797C4CEEB;
	Thu, 21 Aug 2025 16:42:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755794576;
	bh=+7mhn9TtTfm/kyXTVM/gPpkPWNTyUYagzUfpYWDVCno=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PtigyZr5UtnLZHybJXh+Bmm2p4gSlJQ0+l5TzEB8yopkOAr5ZxK3Hzbywf9nU41LS
	 H4JuCSgzb/6x+rV7uuuDiU0d+Azyp7qMHIr2NyCpoRanWpXM3qNxmuX3UR0gSYSCQ8
	 EgO9BPEGAjAPzl5oAF87lTunOEosNg7DI9JjVwGZOwf1P/K3YOkcQYriJPzwUz9iZw
	 5kEjo68MIHENuqtemNC9786yK0I75BN5i3jCjQUdJBvlnbrJuKI5nHFdReLvgjJn2D
	 YZcym0uBv6nrkjkfjFnLkscUgzqoI4xA1gQWBtILJ/SB+BDygvf1Vsr2crkSHL/y9m
	 gh03F2HfSasFA==
From: SeongJae Park <sj@kernel.org>
To: Barry Song <21cnbao@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Nhat Pham <nphamcs@gmail.com>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	Andrew Morton <akpm@linux-foundation.org>,
	Chengming Zhou <chengming.zhou@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	kernel-team@meta.com,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Takero Funaki <flintglass@gmail.com>,
	David Hildenbrand <david@redhat.com>,
	Baoquan He <bhe@redhat.com>,
	Chris Li <chrisl@kernel.org>,
	Kairui Song <kasong@tencent.com>
Subject: Re: [PATCH v4] mm/zswap: store <PAGE_SIZE compression failed page as-is
Date: Thu, 21 Aug 2025 09:42:55 -0700
Message-Id: <20250821164255.78596-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <CAGsJ_4yLDLvOZ2=3iVcQhu2jnbWQ+iTQsqVefJsx4_YT4bnEZg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: E78941C000E
X-Stat-Signature: 8q6u9hym5xhho1buuparrudyprj6j9dk
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1755794577-825352
X-HE-Meta: U2FsdGVkX1+4HK8x3eXX9lG0Ue3kTigPMX4bqRidI8wevbpXoWePRJ6aY3+cO0/jNoZJF/kpDxg6m8eWiOz47MIY+eRnBmNpnhHAztdVT5CFay3dQIXTORB8Cvqvzfxzivv5Mwr/14Ax4Az2e7DtyhRFtcfJZlS6CTsQ4instzjq+ie5f1q3q3kixe0doxwHipvF3nS3Evbv/fydrzQqlW17Bvt7CBexgTB8ENKWKvkXaGVAD2mux7IgiMMraGDIxFmS6ZI/+wDMJrL1zSyowCaFBZGv8zswPXj1aOeC0Nw1jYnNqx1UrkKA+/+bO4vF8b21/cvLaaERiWjrnxp0WN7rAEHfABrysczbxczHnSQYLGSgr+6giQTTolim/Po/T+hnHMhKyRGc0ajouMt0j2/D7jbUf6qq+VBfnAhtSPFypdH+2OZEzLxsSzGwSGB8dwLI51agOpG1DkjRiioVHnMuxv6IcpwPmzZqLKmbAtxorjDqZde+99rW4F7mXBx+gnGfMpZquEtsN4vELtfXWPchXrrGHFkEdZTxY41yR9cqgVLq/YdkC8D8lBRVwW/amZC0TSKlujqpfUshoKogW5bYXzhkzuGnbJcVtJFYmi7xEqgHO5r6NjU+erhPL6frFxbiQ9djZBpQClIDrD/y2T749l18qWsEZ9nj8FD6MsYSr2QYHkIVCcjK8jqLQGgS+n0DM3n7tkZxTIYCueruq7xAaM3/eHjiyRD3RzsMiwGXqS8WAzLOV+6maSrLnUGW+VlnOAZ5LNp1aDYnRsqOzLfpAPvkxEx3fJ6zDWqpmjbpz0eZz6iZvyC0wLIqkEnrWSiopUJO2JEksAASvXKzPEWCSa03zRPotG44/GfFx4qx+FP6MY0ZwLVi8RRnJ3/kgoPw279M5bgVqVwfgvrhufB6XCOjuiMaSKzlTik1SRpd5D7R3qXNFvthAwP92ulHyX4lKKr+hbdTF15lgU0
 yCPP13M3
 keEVRpcl+0isj4PWMXKO/peeyPaJ5O4mOpZVHMo/iK/Nc6ejJxz8G+KfRCMmpyE1pFK3Kheyw6Kt+XyfV7Y7UcHbpbDfXG9f5uT+ZoJT3eeG0ndngh5vq10BJ6y+hktrRwsiZwwaKVCZoQywCAqN14pHiVZAakwIqiaK3U33pE+nxF5OV9ZTf+a6ghutyBUKjP4XK42/O+YGaMWT9wueRJOW2XQyWPtEC+Nj4aoUwLsxXp2yKFdwEP3jeiLX6+PPhCsKv1q7TsyI32Z6e0H2JzU2+99NFr+uSZ+G3ZfTdfh7UjrX17s5vStNpRjloX+Idmiu2xje8nuYEBvP/r+jS05cbSLGHk7iYt+5URkgxK/XhZsTlRdxqww5f/cqAqYHdlNphYfELJccZhnc=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 21 Aug 2025 18:27:52 +0800 Barry Song <21cnbao@gmail.com> wrote:

> On Thu, Aug 21, 2025 at 1:33 AM Nhat Pham <nphamcs@gmail.com> wrote:
> >
> > On Tue, Aug 19, 2025 at 6:37 PM Herbert Xu <herbert@gondor.apana.org.au> wrote:
> > >
> > > On Wed, Aug 20, 2025 at 01:34:01PM +1200, Barry Song wrote:
> > > >
> > > > We might want to revisit the old thread to check whether it is now safe for us
> > > > to move to PAGE_SIZE in zswap now.
> > >
> > > It's perfectly safe as LZO was fixed months ago.
> >
> > Perfect. Then I'll revive Chengming's patch (see [1]) to reduce the
> > compression buffer :)
> 
> Nice!
> 
> But perhaps we should wait until SeongJae sends a new version that
> addresses the counter issue?

Is there a reason to wait?  I was thinking those are orthogonal problems?

Anyway, for the counter (crypto_compress_fail), I don't have a strong opinion.
To my understanding, the options for path forward are...

1. remove it,
2. keep it as is, or
3. keep it, but account only -EINPROGRESS[1]

If I'm not missing other options, I'm tempted to the first option (remove it)
since it doesn't change any existing things, and we can revisit later.

Please let me know if I'm missing another options or you have other preferrence
on what option to take.

> Also, I noticed the following code may
> have problems with the patch:
> 
>         if (comp_ret == -ENOSPC || alloc_ret == -ENOSPC)
>                 zswap_reject_compress_poor++;
> 
> Can we still reach the code comp_ret == -ENOSPC since we already
> handled comp_ret by ...
> 
> +       if (comp_ret || !dlen) {
> +               zswap_crypto_compress_fail++;
> +               dlen = PAGE_SIZE;
> +       }
> +       if (dlen >= PAGE_SIZE) {
> +               if (!mem_cgroup_zswap_writeback_enabled(
> +                                       folio_memcg(page_folio(page)))) {
> +                       comp_ret = -EINVAL;
> +                       goto unlock;
> +               }
> +               comp_ret = 0;
> +               dlen = PAGE_SIZE;
> +               dst = kmap_local_page(page);
> +       }

Nice catch, thank you Berry.  Actually there was a check for keeping the code
reachable, but I forgot keeping it while updating the version from v3[2] to
this one.  I will make below change on the next version to restore it.

    @@ -992,7 +992,7 @@ static bool zswap_compress(struct page *page, struct zswap_entry *entry,
            if (dlen >= PAGE_SIZE) {
                    if (!mem_cgroup_zswap_writeback_enabled(
                                            folio_memcg(page_folio(page)))) {
    -                       comp_ret = -EINVAL;
    +                       comp_ret = comp_ret ? comp_ret : -EINVAL;
                            goto unlock;
                    }
                    comp_ret = 0;

[1] https://lore.kernel.org/CAF8kJuPPsLzWu8+xm2A_UPHMBhb7OTjJNErM1Kp3hPmvHXNDUQ@mail.gmail.com
[2] https://lore.kernel.org/20250815213020.89327-1-sj@kernel.org


Thanks,
SJ

