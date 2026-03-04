Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0679CEF9002
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 16:46:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 46F776B0089; Wed,  4 Mar 2026 11:46:06 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3F87E6B008C; Wed,  4 Mar 2026 11:46:06 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2FE7D6B0092; Wed,  4 Mar 2026 11:46:06 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1CC236B0089
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 11:46:06 -0500 (EST)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C9289BA595
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:46:05 +0000 (UTC)
X-FDA: 84508957890.18.C8F7EE7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id CF3D2C000D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:46:03 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dScc6NZ2;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772642764;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AhTOnMFysHR+r+BB39zBGqkEpVC36GukS5qbEHX2CcE=;
	b=ptnc9S5eecfgm6bx0IC8ySKdoQKOlmDv/L7WjM2csUMo67HBfe5cFp6Weq0hBx3YrFcKqT
	gk+kpJsyHW02Iaq/hTqoVamBRk9UfFW9yThQbZYo1xS27L7VaJ7iKD37xXZIQFO/p0cRMn
	unD54zwX017UvfFkfCWAMqVH2E45Mzw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dScc6NZ2;
	spf=pass (imf22.hostedemail.com: domain of yosry@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772642764; a=rsa-sha256;
	cv=none;
	b=ViZnf2Lg5ja8QJ7Em8YSCoB3WLGBXchWw5Idxzs0q5+oDbaH2+Q7NHBe+0Tww41MoISvx/
	5ZKZnUTZILQ10TsM8NJtGZzrEyXwSdIg6m09AbkgzaBRnfsTQ1jsqJ6IkzY6TbEPRZz81Q
	nhosO2YP3cGdpNkZnYI4v3bHf8q4nFI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C5B54444ED
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:46:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C89C4AF0D
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 16:46:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772642762;
	bh=AhTOnMFysHR+r+BB39zBGqkEpVC36GukS5qbEHX2CcE=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=dScc6NZ23rpQgRG0mnUtaHbs+phKE4alwTdDATYmyx+k/qMCkMvxIU/TMHgU2A1zX
	 NkA9mPrBPMiwMCzgcE5lcbGagTvz5564+PIn/fkl+qtUk3KL1mboy/EUS2pBSH+oCe
	 OUfV0W73ir4/QMlknh+JKUQR6qLEj/qpPYlH2oEfdC2WLXUHyN9qNJ20cyIsBx+u1/
	 verpiBBOZhORPo+bsYW/EVV1hvRcuP1Futk0QIF8X2cMqC0nAYsxpI8Y/dxnmLvJzL
	 PCdb8mvoc6wpYqgf4dstFwPu0Ar0ApmHF5GC6vpoOFda6iXp7dx6pSNABFEm6j1Akm
	 yY/qaQFl3ZcDQ==
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-660f1a1e977so933720a12.3
        for <linux-mm@kvack.org>; Wed, 04 Mar 2026 08:46:02 -0800 (PST)
X-Forwarded-Encrypted: i=1; AJvYcCVGm3aGCsKmg5KGQGfHcDqM12Iu2XoTm1QGpmTR8A7+EX9i/bpfCk8rO7YIJasaLR7duNGS7RDfrw==@kvack.org
X-Gm-Message-State: AOJu0Yw1d7oWEFgDyqvBldcrNPkkax3Wz5oj3V/YzqFG1nYvZyvi0Wsv
	pTj7RQl0GB40zR/yaq5zk2GCo9Jlz8qt6Yh68PCL8hD9WW2GF8TZLlQ+4zAZQWD+5LwznN5655U
	J3sB9ZWo1+kvHcwRPKwvCnL0xpEhgWIk=
X-Received: by 2002:a17:907:6e87:b0:b87:1d30:7e6 with SMTP id
 a640c23a62f3a-b93f1171ad5mr143317366b.11.1772642761216; Wed, 04 Mar 2026
 08:46:01 -0800 (PST)
MIME-Version: 1.0
References: <CAO9r8zOFS7zU-eGkErcjud=DW0t00_WqNqCzq_QDf061dOsYSQ@mail.gmail.com>
 <20260304151120.3512645-1-joshua.hahnjy@gmail.com> <CAO9r8zOJ5bkJzptM7+8V2G00dHuycAEAF4CDcaR1YMk0kWyktA@mail.gmail.com>
 <CAKEwX=ObFWm6cKbi4hL8JLDKui3MsRu-JpEFohBdkqHFY9tVfA@mail.gmail.com>
In-Reply-To: <CAKEwX=ObFWm6cKbi4hL8JLDKui3MsRu-JpEFohBdkqHFY9tVfA@mail.gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Wed, 4 Mar 2026 08:45:47 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMbU8ikA4jAUyOvvorsm3L4UD2X-KVcGyQaKwTZ0nV1Qw@mail.gmail.com>
X-Gm-Features: AaiRm51RdP-6QF1MGy0rT8q9i5bzC5Umqr3wPeGTQwIJROXe85VGcaFk_DtQxSE
Message-ID: <CAO9r8zMbU8ikA4jAUyOvvorsm3L4UD2X-KVcGyQaKwTZ0nV1Qw@mail.gmail.com>
Subject: Re: [PATCH 6/8] mm/zsmalloc, zswap: Handle objcg charging and
 lifetime in zsmalloc
To: Nhat Pham <nphamcs@gmail.com>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, Nhat Pham <hoangnhat.pham@linux.dev>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: zihp1idbxjn3hsc454nd3z9zj9j1jipw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: CF3D2C000D
X-HE-Tag: 1772642763-260756
X-HE-Meta: U2FsdGVkX1+AxzTddWPifqQM6CUJn0SJDS8IT+80NRF4z5rdUOwxP3Nhp5Szq/uSlHyMS60MNJKQjJuxxcz/MlYOx9UrtSsl+kAJr7ulYauBBzCY23QT/Jn7PdtQ+lqHV01zYM+HZcj0vfrNOB5LDqhBszDcZlIwixElsKXs2u6HtmqtFFEZKaRi6UR81Fa2RjFLAM/g9uaJlV6Gx4GTH0kCGGNHK9uKucMJCeTgTd4nDUpX9w3LanQUxbqKjuHHTPkeWDBM2k7ZVa0n+3U4P072F6nMHGBNwaYSjLggHfqcXYRXE9zJKnn5fyT/SIRg/B5IEH6r3zGI71RCJxIWIe8v2A+6ZEW3RpIMCRmOwczCV5oe25msgbpLTrq6gosV7Sfyw242pvyjRH7kZlvknTOruWEry74lfIytAyFILaMV/AeqV8F9wHObQ63SKBbOroyqtcYwo9WbswO940+O7p+fsYurnY+6EaWrJBvn68kiSFSbJH48G7d8HPhr760OVUnIZBLbPuTb7qVPbzCDhX/n+DPyMB5XSKftHykHMGN+1+uMsEEYBWK9hCdQ2hE1GiogLZGR/Vppe1YebnHxtZl4RYcalR7x7zMnhog/A1tWOmwToQafy6bf/gcwju39WZQKN5qjHnhZM5Hj9xI+qnzcXsiv5oFJ434k0pc3u3hjp9il3OA29U5VXcoEbVVZ8unTgEcSzK4hjU/+JTVrj6N1p2XvzorEQ7EnvHJzmx6bES3th3PriWZ8NWpRKQgkRNgwqoXcgmDuLD4N0MeJVhjPgFD0/0XEFRIfdExwUrA3WWvmb5+5XskIBxQdFb3rAKKSm57DwraST4p1cQ+2FdjkTq3AjRFDDAPSOjSuHgsBrnNjRGKFEcRrOq8yV66Yhnn15y6SRty+7NaKBNjjVrcNlIu8QMU9KQ+smny81n/3YWBsu4PeGjV5AZjLNPwl3paqvO3doUg4ApiNcsg
 vkOMDoe5
 Dvssn5TB3jqG0bUa5FG7GrAHm/AK2udQi194s5tlqG/7KOgmoejuBN5PazgdqEk5DeI4tlNVufAFQ0cwU9ZHLAI26mk5iwatk41UE7tpX6BsCsrN1LI38XRXRcP6HxTJw0ruqufqFCMDi+uaBban5voQM3VKLIgcAoh5Ik9rQ9bLzPPSoqRTeb/vYlDpqPawu9ieYNpCVfzlGBNakmI9KqTyJWtljm/3RpOYD4wGmEc2gaojcdcs+NI5SdQVJ5uGdhpiuD6MkeRyWOL9nNjKiLKIV+IM/GmiqSubYKlZgWlydqeFF5/95sGNhGITkqo9L0NXKda5i/EQW6mz2OZ8s0LAhL8b11YyrMl+Z
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> > AFAICT the only zswap-specific part is the actual stat indexes, what
> > if these are parameterized at the zsmalloc pool level? AFAICT zswap
> > and zram will never share a pool.
>
> TBH, if we were to start from scratch, these should be zsmalloc
> counters not zswap counters. Only zsmalloc knows about the memory
> placement and real memory consumption (i.e taking into account
> intra-slot wasted space) - this information is abstracted away from
> all of the callers.

I agree, but we cannot change the zswap stats now that we added them.
Keep in mind that when they were added zsmalloc was not the only
backend.

> And if/when zram supports cgroup tracking, memory
> used by zswap and memory used by zram is indistinguishable, no?

It is distinguishable as long as they use different zsmalloc pools, I
don't see why we'd need to share a pool.

> Anyway, Joshua, do you think this is doable? Seems promising to me,
> but idk if it will be clean to implement or not.

Not sure what you mean here? Changing the stats to be zsmalloc-based?
IIUC we can't do this without breaking userspace.

