Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CD911606A31E
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 11:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=Y77TTjcf
Received: by kanga.kvack.org (Postfix)
	id C52396B06C0; Tue, 27 Oct 2026 07:37:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C299F6B06C1; Tue, 27 Oct 2026 07:37:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B1A3F6B06C2; Tue, 27 Oct 2026 07:37:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 8703F6B06C0
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 07:37:30 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id B75F21A0834
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:37:29 +0000 (UTC)
X-FDA: 85368205818.07.D960F0F
Received: from mail-qt1-f177.google.com (mail-qt1-f177.google.com [209.85.160.177])
	by imf13.hostedemail.com (Postfix) with ESMTP id D979320005
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 11:37:27 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y77TTjcf;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793101047;
	b=13MA174iWx1SRnr2thkcTODpLEipUuViImKiQdQSAhqPwFnFkW2BNbhIVuzmJOUUyHJybz
	zIJKXxB3NSPb8Yzkhbs8pi9gIz5WRVKYep/KSskiIGeqTqmW5oXujRYUDDcv7HFjfIS2S0
	sWBMoMiiOf1A/BUMchnpA8eFOX2uYOI=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=Y77TTjcf;
	spf=pass (imf13.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793101047;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B0AENkjEZYL4fzS8mYn3YPtPPkm4rS6Tf5gq0kxi7XY=;
	b=eZs5w/d2cM+sxtiDwtIR4jVxIzGnvXw5lTEmlmzfDujrsncTwt06K40+jzmKsEM9uK97zw
	rtcQltNrCaYiqZTSz8T60Qx8XKBw7OfjzyaWR2enDh5xbpeJ7QeZfkqvOUdr8eA72ezJRX
	EqlMxxpz8EEAgNB8rzN9CeHjzLq6eCs=
Received: by mail-qt1-f177.google.com with SMTP id d75a77b69052e-53512cd2f85so44460151cf.1
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 04:37:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793101047; x=1793705847; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=B0AENkjEZYL4fzS8mYn3YPtPPkm4rS6Tf5gq0kxi7XY=;
        b=Y77TTjcft76RITlTHky2V99tEAhkMAhqkx5tUYn4ovNY7e0yDl567Y63QkIMP3pvcZ
         86erqW+XWQl/WSKbjNfF4273bMVkx8nyNExyIq5SmtdaqLsghRx/fcg7PiuQCqf6QaBe
         ixPn2bxG3xAIaN0gyvs1eZHA1rCeT2PBD/w3jv/AGK4jWK84U4UZDJRbfZ34V5xWEmRk
         cumE1pZ3lBmTwX7jWnf/cTr5+JwNFHFpTWCnT/FmXZbec9l4rxUmnOObQA2YckxycU97
         6a4LcSC9TNRFo6jODY51mlI+qtgyTw+Oc0rBikujxGXoJ14ZAg9SGeYGTdIHpX0e/FZC
         gZRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793101047; x=1793705847;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B0AENkjEZYL4fzS8mYn3YPtPPkm4rS6Tf5gq0kxi7XY=;
        b=C9PgD9xWEj50EiaI73I4JDaN7SyaVD/RYsuTW/xcT9bIgOuB9NSGW55NhdkybVhY1E
         7VM3PktyAGsCMKD7X4x++M0Zh1lk6dLIbDgy2sSL+0LRRVnNmcUjisplXXBblHIPQIL5
         XtJEwX6gzDDUHvMIshRRksJK4VVa0+GGqYHjcQqrjW7L36xK13Bk0QtG0YqSrcniKXAw
         uw3ko6jkV6Gpyz/Onvs3l3hQHMvwCL86AH73ATInKxblltwUvla52zSVsXT5/TvdhU4i
         unwVANgqDX0/UCeiUWoZFjHxcDWU5px7d+blN/5illva4JSSRMFXuPhWbJqcOtdJ5BuQ
         RbOg==
X-Forwarded-Encrypted: i=1; AKwUvByeeJ5sV7hMwDt9q49TTotxguY2KxJB3Ov1htuR1CmaiWMq0KMCkemYq2t+S/eOlaPl9Ppi/bkkbw==@kvack.org
X-Gm-Message-State: AFq9FYJy7x422gzPQCaawIG2v+SePBZ6UvJy2YSDMUzJqMUId2Cd4NBA
	rHaJ+szVhW0gqgL5ezBKfr4syTWqyncBvJ8c2XTFzlas2LPMgq/BRKPXrdDgHfc2q8kqa1m632Z
	y4fB6P8E=
X-Gm-Gg: AYBFou3t2aREnxgHtArMQ6VhXXVc/V1Ff0SVyPn8NTFQfVQ4Cy5VtXoVvuK02Ym/IPW
	1p2+Dq5GVf/ZoWGlxHne8U7fZhzZ6utUJ8+/RYv9nHHPSXzdOcBbeZHjjoQnRRzoNSTQiUA8cg/
	9JKrofveY0ANB8eDgq5VoFhtDYv6HFs/L67R4nHQ6PxwLD7R9MJGBBZUoiM4PzDh1dkLSBaOM0v
	ludBZfDFgCVdlyqkR9u/x22x9+PjZT3NwzpFm5ggeAZVMgBgx55qSJ/0W5Otj2do4e0ALMw3iGs
	xfdHY0b7xBXK3r20s1Merw5KgMGN/wAlU2ll4a+Ur/PwBts81hXR/1lcqGtfCu/3ncGhdNbjbuQ
	yx4Two9jj9FJ8SEMy2AeqNsGMmfEZRJrfoa4CP1kBvfbZsIa1RNP1qw5bIois17GGge8WXZrvHH
	lzrOBembhzjgOnr8B5hIfsTKRWnoO0fylHlASR4eZ+gMlLxjwwxOU85mgi+JqbZUSywRNmgQ8d3
	/TWEZFPBQWHQXC/Y3zF8UQbJnNsVi1/k16Rgpu/5003gJu6dB68JnRvdVDk/VmHjJx5Ze2u5EEq
	5T+nSznwahUW9hdyv+cl1cOO9gjD
X-Received: by 2002:a05:622a:5e8c:b0:533:920d:7bf8 with SMTP id d75a77b69052e-5383b4ae34fmr146287491cf.24.1793101046776;
        Tue, 27 Oct 2026 04:37:26 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-53838cf2e96sm77329351cf.1.2026.10.27.04.37.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 27 Oct 2026 04:37:26 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH 00/16] mm/shmem: various (urgent?) fixes
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, 
 Andrew Morton <akpm@linux-foundation.org>, Zi Yan <ziy@nvidia.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Rakie Kim <rakie.kim@sk.com>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, 
 Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@suse.com>, 
 Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Lukas Czerner <lczerner@redhat.com>, Carlos Maiolino <cmaiolino@redhat.com>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 Daniel Verkamp <dverkamp@chromium.org>, Jeff Xu <jeffxu@google.com>, 
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
 David Stevens <stevensd@chromium.org>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
 William Kucharski <william.kucharski@oracle.com>, 
 Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
 Nhat Pham <nphamcs@gmail.com>, Miaohe Lin <linmiaohe@huawei.com>, 
 Naoya Horiguchi <nao.horiguchi@gmail.com>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>, 
 stable@vger.kernel.org, Josef Bacik <josef@toxicpanda.com>, 
 Eva Kurchatova <eva.kurchatova@virtuozzo.com>
In-Reply-To: <3022ba03-54c6-499d-b07a-2ca8d033a56d@kernel.org>
References: <20261026-fixes_shmem-v1-0-703206d5fa0c@kernel.org>
 <at-yaxmjeOXtA15M@gourry-fedora-PF4VCD3F>
 <5d10eba8-11cb-4031-84e1-a394ca5b4cba@kernel.org>
 <179304984259.319828.7383468637599462048.b4-reply@b4>
 <3022ba03-54c6-499d-b07a-2ca8d033a56d@kernel.org>
Date: Tue, 27 Oct 2026 07:37:25 -0400
Message-Id: <179310104515.664110.14057520583832900506.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspam-User: 
X-Rspamd-Queue-Id: D979320005
X-Stat-Signature: yf14c1zqy8me5dyikctbbraj3bx3shnc
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793101047-387139
X-HE-Meta: U2FsdGVkX1/tiq29Rx/WKdoTgM/6Mlv2KkC4MddSq0xNd+Z7NHrf4Ig1Hpi/5GgWrLH5znG7EqFEDaWdhKaQCP81Mb0724BnDcMac7GIPkhBN/VihIC6Qtr9h2Zkdw+mgkTerHxHM6EKYpqipgFTXxjtDNIEdE4lsH21jgTIlfiium2UDuA0n6JzZHJyKMOMOaQXz1UKW1HBU+e2h+DY6oiOdS70IwkoXqIr+gXiZ2AIBRKijNafAuyGodBFv32c/4deKxt+9BK4JFMBQggVovS6thUArMHTHmYLIK02SAzHJ0AyZWUXCMwRuQyE59hwJC529tl250l3Po+H3iFN6wX797YO86eYIqFi5zCCUubte5puHeCJMnK59roTmEb+FnQQ7Sm3ju0gitdM04Eq/r4s7WAZrgTgxh1qodut2zQ09Hp06SDDcV1FtGrbKHH2Mgs8IPLHxXitVnMiQ3SXam8lN+GzW2XInAZnbTlLoSSGONkVL8GK1gDPi8qRfB4ndenURtye32PpbUvr4YQLSygJn8PD5aL9X47WMrV4fhRT6Tdf4ZYY+dW8sx84upasxY1qfP9rU7kaD8Hh7WCAeq3rLMCdlfqTOJvzQkspbuRLTHjyFBA+IZsy/Xzw8SoPbo0hCyv23kFMn71tiS1yyJ1L2U0QOXdjYfYJM5SbaFiJNGT+Oni4qOllOmn+H8ag75UlssVKGFbqtowe0bKtQ7QFCuo3rlgw/lf/bcxV3HOJ5u2VwdlBuY9GjtL/HQyWITTfbFSFYmde1MT3dcV7kVvmTEC9lpdmfA58M3Psh/ivRYMmys7QMOxa6ug6jOVfktwC77uYNK/rAKGk5tQY/uqlhnpzqY0uLnpeMpI9KQ44NiZCgJiA10tSs2qC1fUyfBqFCO5+TYYxRGcixl4JgK5vDaWYw0JMLo9PuI8mth6T0IwL3Wz5np/1U9D0HF2dN5ZrM0Ws1fQk/W1hz5t
 CoeAZE/K
 P9ocwKEbv62m1u0yhqozlA69EYDslckOHH1fni4as2iPTMAsHUwjG11z8XQXKp2CtFY8M2HWLNUUV5Dd4QHrrD/1AI2yZULs1z9qD41ra2Nx7Fj9960Mtx5bZdzVR4AvijveIbiqD4sJfDlte7e8y9IElzaQqp1iuV5kcUiGbwKFIST6UcO2xtZfawac9zYUVzlRjJjAbYxgM1EvBY1sA3G0P8I0kQv8muCzdXvhLL/dEdD8RgULJeRCVzA3MgmXbuq8Jd9QsGG1LIOesKYU8IOG7sFlnAXM78XlsY3TqZTf5wPJcfpyC/NOd+m/bqwkdk5vl+HgUHWVwPjzYMu7wO3yxtPkgkQKIVfCYLMIaDzY1eMUkR5NiC00qHJWQsQIfm0LzPihvtXJxGeY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-27 10:34 +0100, David Hildenbrand (Arm) wrote:
> On 10/26/26 22:24, Gregory Price (Meta) wrote:
> > On 2026-10-26 22:09 +0100, David Hildenbrand (Arm) wrote:
> >> On 10/26/26 21:08, Gregory Price wrote:
> >>>
> >>> feel free to take or leave the selftests.
> >>
> >> Thanks, no time to polish selftest ;)
> >>
> > 
> > It's there to show the work more than to merge, but the long-term goal
> > here is to feed these tests into a larger session that does the polish.
> 
> Agreed. But a note that if these essentially contain reproducers that can cause
> harm on real systems, posting them upstream might not be a very good idea until
> fixed.
> 
> Well, unless people can trivially generate them already.
> 

Nothing here has been generated by anything the public does not have
access to with a $20 subscription or enough RAM to a run a decent
model locally. Otherwise I wouldn't have posted it.

Posting the patch is the full disclosure at this point.

-- 
~Gregory


