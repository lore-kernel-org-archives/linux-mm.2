Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20E87CD8CAD
	for <linux-mm@archiver.kernel.org>; Tue,  9 Jun 2026 07:48:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8318F6B0088; Tue,  9 Jun 2026 03:48:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 808E26B008A; Tue,  9 Jun 2026 03:48:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 746056B0095; Tue,  9 Jun 2026 03:48:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 62EF46B0088
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 03:48:33 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F1DA41C1CA2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:48:32 +0000 (UTC)
X-FDA: 84859596864.05.BD38F34
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 23AA41A000C
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:48:30 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lh3KQeKK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780991311;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P3+mzxVILVCJrFtycDB+LRStStiIqPuiAbLfUSeAzUo=;
	b=QM6OPnK3m43n88HX6FNMiNj83ws6zZJJRWHQz+GVj3aSNojZvasMjHkBqDmg40C9h2pH6C
	Dwp8yUvwxx7HUB1J3FWJoSDAG1DR6pRE7VLW1EPSL2ucckEGRtdbdIqZGBWxdh/itVSezk
	1EI2GXDifOpkqYBft3SJVsSgAxRiD0o=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Lh3KQeKK;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780991311;
	b=hmUeJqkttW4TrisolOx/1tJUKkmkYGulPxZtcaOb5ehao3o1M69EdiMSLDjH0ERuznc6NY
	uPI334gMXsOOdh3imWWD9C3uPds73nTSlw6gPPMcnuTfjNEDmR5TkzCHuLhmZSHy7pEL8s
	IBcAitFjgD0FKLJUEe3CS602PiRP824=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5FA23443E2
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:48:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41F411F008A5
	for <linux-mm@kvack.org>; Tue,  9 Jun 2026 07:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780991310;
	bh=P3+mzxVILVCJrFtycDB+LRStStiIqPuiAbLfUSeAzUo=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=Lh3KQeKKmievG3xTheEKaVvOT1dmL4oXP4rsslq+cR5khxSjroDT8s+CQnjNG70jb
	 uuMDUyMS6mUFlPLvvToDEw4DAwXpRfZDgJG5eCtvj7gtsFDnHFXxKMKqF0/QuoqZKZ
	 ARi2861UtMbt03vvuhOwDfN4D1SnTBWj7Ssg3Tu4I5kugJJOksutbVhg0d1vz64LHL
	 /C4p5MKkNrFNd74QDOqAvCc+oY60p9/uj5QE0KFcTfH4O5S3LtzGtbiWyH5D9Dsi3i
	 cvQ4AzzEA1tadAKd0Cwj2c/ZgeQcHLzRO+QMcmDNpBk5LKJoUGFSHGRjnBZq6d2dgf
	 X/fAfNoieHZ9w==
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-9158c621ebbso626425085a.2
        for <linux-mm@kvack.org>; Tue, 09 Jun 2026 00:48:30 -0700 (PDT)
X-Gm-Message-State: AOJu0YyTJP6uwCqrGw60dyAiyns/1poVmi4lYP8yK91OC+aAjJLhEgMT
	FNmiXEwOhpI6sgqCdrj9A4wwQjldlekp96rBlH4WLyThJjL2e5HaphmFAjXukyZwtF4v2Cw2A3p
	mlBLWoJa529dw3u0cbE9svMjE3Wc36oc=
X-Received: by 2002:a05:620a:c4b:b0:915:c271:f91c with SMTP id
 af79cd13be357-915c271fca1mr1851463685a.5.1780991309343; Tue, 09 Jun 2026
 00:48:29 -0700 (PDT)
MIME-Version: 1.0
References: <20260609002919.3967782-1-gourry@gourry.net>
In-Reply-To: <20260609002919.3967782-1-gourry@gourry.net>
From: Barry Song <baohua@kernel.org>
Date: Tue, 9 Jun 2026 15:48:16 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-Cd9aNirdvRSKCz07qNqH4EEeF37rGUpGOJnSgSL-Kg@mail.gmail.com>
X-Gm-Features: AVVi8Cfqzi3SIKls0BC4hWZyF4MXPP-oDhMfanMs2lMZ83TPVeLkEv4_siixdsY
Message-ID: <CAGsJ_4z-Cd9aNirdvRSKCz07qNqH4EEeF37rGUpGOJnSgSL-Kg@mail.gmail.com>
Subject: Re: [PATCH] mm: constify oom_control, scan_control, and alloc_context nodemask
To: Gregory Price <gourry@gourry.net>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
	kernel-team@meta.com, longman@redhat.com, chenridong@huaweicloud.com, 
	akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, qi.zheng@linux.dev, 
	shakeel.butt@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, rientjes@google.com, chrisl@kernel.org, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, 
	jackmanb@google.com, ziy@nvidia.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 23AA41A000C
X-Rspam-User: 
X-Stat-Signature: uyr1kdukecaqjionin69ezocboo4mrg7
X-Rspamd-Server: rspam09
X-HE-Tag: 1780991310-18325
X-HE-Meta: U2FsdGVkX1+0C48VfO6WzaPBLX20jDnwdfy78ew257WjSH7O2bE3K4LnLbS1CBrh38L0o2fSetNdm+Ar6k8Utbx72bl1sLtNbZHgdebr1qPsQu/ZTn4X5aYjlWMpBo+ciVCNmn407Wrt3uLvaimtS/8aOqbAWiEmljeg8pawnccaL9VZmB5pMReiTezenIjhV1nYL+PDOBgErVj9RGp3rlVuBuFAVwqrbdheHxMtJlOiqEwUlA21dWzElSbyI22U3RWzn9nwDgX1VUEljWdEZEPFOgTa5DxloCxXPxCArRc1/IPMVcxTYU9zHk2CYyPRQN5FpNmpr6t8EM/OFcXfooNuvhP6Wdd+W17xQPTtCCHVWC151POoGEA4Dh7rtezaLU1+xVx3g16kBFMtXlOScmXfpjA3BXAAzvAfzUgcS/BlSMb52xSq1J8i6SYFneRGGrMbvNRwZHXSzVQH6zQLFxZ7kkOR2P8Ll7ac/LqE80RCDUrS0yFxcjWPN5MHahGTY+QbwOg6clzepANAHZvQhwvORlDuQMmsGbl7LPon0Aat4uHWudC6fGCOFZB7ENuYUfkLLQgpVZjy6ZusKxTcdF7HJOm/pYfHxb3pDY8M36if37kEUlZkCGw+1rHq0YcjmyGkLrCixWk2LSiM8Ht+LedClpMksacZoULmkjRWVksME8/gGeYkSx2VTTPhrQsxvp8a/N87j06M5uWPBVbscRsD+L9SxbAQtv9oxLD9EGMR73FCPWPjDFBjLsVQxcoeBrXmwyPrWPH1LkwRN9rIvkwZsM6/dazWSqpy0W6ZKpEC4DuqFKS7AV5XyoQuElcXg5LFM8Sc8vkreY/lAzEHqT87BuXxY+h4jeRacGuVae8Gqd3iT6tkf4uVy8pNpx6kEKlKUa4n8YW4qLLFP+CUy2/1uAdp9ThFZ2SJd5O4WkcmHEhkYqYY8cXuuGBOI+JUs0A6H62Yom9HXeqC0+i
 K+Td2EuJ
 ozgYWiQTcmQOlk4HQVp4IXIy3OHziMMgR/enGyZgOOFr0pbxspPKfRRKw/Dlo3AOfWm6rxHcYHwIrUoAgyz/Nyx5tUBpWsu+WgE+q+GyqeELNMYkuHBtN+Ed1VeXEpiMk6JyNpwsMevcQtFa7CAA9Lezb08WbZMK6o9AAUItzfP+hE0Zh+JisNdo9qw6Q0ihnTFGr2R8CLvBvI02IfQqeicAlrrfyrl0DwLDTBJ8j1U9lS/vesK+Lw+heVv0ZARvxsegNnI0SJapNJqOVJlOjrR6J4y/c/1VHYPtFxGis4KzxvNatjATBKNRJQJWkHbmP6vRhuoEAs7XUWdJ5Bxj2q1TqaZgixjegn/8MzOE5FwAFdMhzVqr3LhnEppgUnymFW0pW9lMsJZ6L+WRlz3gSRih9rq2xhuNSZp9a
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 9, 2026 at 8:29=E2=80=AFAM Gregory Price <gourry@gourry.net> wr=
ote:
>
> The nodemasks in these structures may come from a variety of sources,
> including tasks and cpusets - and should never be modified by any code
> when being passed around inside another context.
>
> Signed-off-by: Gregory Price <gourry@gourry.net>
> ---

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

