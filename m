Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BE878C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 08:29:48 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8DB316B008C; Fri, 24 Jul 2026 04:29:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 88C156B0092; Fri, 24 Jul 2026 04:29:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 77C4F6B0095; Fri, 24 Jul 2026 04:29:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 59BB06B008C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 04:29:47 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D2DF0A02F6
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:29:46 +0000 (UTC)
X-FDA: 85022996772.11.442BC7B
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf04.hostedemail.com (Postfix) with ESMTP id D869440009
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:29:44 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GYAw9Mmt;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784881785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ErEZwXhE1T+cZKwmA2MG4EYvttNqoH8rOstv+1j1lps=;
	b=z7Df3NhH4lBznXJ2PKuVaXvXHiSIrrwLMq2HugOIvS/4ncdosdQt3aKam7rNsC47lHpFM8
	UZRFA+Em4EYhYCF1KIGWJVpmwSC+QogfPJWtsgrtxuqX/PZUZZIR4CGbSaFyUe+He3PIi9
	Pd/YDWEyX1ZBmgs6r6ZHnY9dN0GpDMs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784881785;
	b=NAT1plSLyXoVFeNN/rKjWkZlzMKe8ZsQ6Tk1o+tfFzgr8Zqo+ljCEROh+iGiHadIey4jqJ
	sFuea+UrGUVPl6WR/qNG5g5lFLgYkl5PIcOYsUdrWIncENoXunr/N0BUDk1yrH6C2ZckoW
	7bDqt2nHrX4SoA3+4EIJjsddJuJi8Fs=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=GYAw9Mmt;
	spf=pass (imf04.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id EFF764361E
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:29:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4C461F00A3A
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 08:29:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784881783;
	bh=ErEZwXhE1T+cZKwmA2MG4EYvttNqoH8rOstv+1j1lps=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=GYAw9Mmt5QXq8ZGfnR1HNG3yWOyIcH0lDQKzqs30lhixh653FuxRrWuWWIGlTsQyO
	 hWLgwJko11MdDwZB4ozgcWPx/qHW7rV7QbyS+yHpB/A6muDmosIRL1w90uaj2G0sRC
	 8aGs9bAWzid4qf7Og3F+lhD1pZgrhc7q5R5Ezm2mgGCkBYWLkFJn1zG+NN7/8vHSSa
	 t34zHJmDG0sqJc4RqQzam7f50WyqnJRs/7/yzFBaSQj80ynNqCSEf2f4BvfVL+jz++
	 UqQF2dSF4HGUaZWDordiBZSuVyf/0By10+9Ajdq1dKgjPEA7v3lT68VeSqB4aGyv6u
	 Ha0gtMjAd5q4A==
Received: by mail-qt1-f173.google.com with SMTP id d75a77b69052e-51c04bf4711so1861851cf.2
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 01:29:43 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqGmLPDz6qh5F5ry9ZfjAJiyjQzDjWYeKcEapKid+39Z7jLsviS2XsYk5sbE5LR+qpPOLIPTKZBdA==@kvack.org
X-Gm-Message-State: AOJu0YyzpfPoRxWCeYB8TKD48yng9X0iKs/uSjaQtGbpk5NMO8BFNHiS
	NdYiq72Ohtdo9OEFF1Uo08jq9AaDhBU1hjrw2xGQNYcdHnfkuqZ2GXnMr5oVQsOYUptr1PGi5cY
	lIXwol0qpg+bfAfmmffU0NOBNXVQU7i4=
X-Received: by 2002:a05:622a:30a:b0:51c:d1c:474d with SMTP id
 d75a77b69052e-5283de1aa43mr56748471cf.19.1784881783309; Fri, 24 Jul 2026
 01:29:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260724033435.2573323-1-ridong.chen@linux.dev> <20260724033435.2573323-5-ridong.chen@linux.dev>
In-Reply-To: <20260724033435.2573323-5-ridong.chen@linux.dev>
From: Barry Song <baohua@kernel.org>
Date: Fri, 24 Jul 2026 16:29:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4xEoLxoNYQRk7KAc5yw0BTE5c2j=Du23EA8FaGM0ZO94A@mail.gmail.com>
X-Gm-Features: AUfX_mygGBUWgM0xKbPBtDr4hMRbV6y4ZGhJ-OW5Dna5gHMaUF5YGWwMvGsDdNA
Message-ID: <CAGsJ_4xEoLxoNYQRk7KAc5yw0BTE5c2j=Du23EA8FaGM0ZO94A@mail.gmail.com>
Subject: Re: [PATCH -v4 4/4] mm/mglru: fix anon-only reclaim evicting file
 pages when swappiness=max
To: Ridong <ridong.chen@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	David Hildenbrand <david@kernel.org>, Michal Hocko <mhocko@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Lorenzo Stoakes <ljs@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Axel Rasmussen <axelrasmussen@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Zhongkun He <hezhongkun.hzk@bytedance.com>, Muchun Song <muchun.song@linux.dev>, 
	Davidlohr Bueso <dave@stgolabs.net>, Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Ridong Chen <chenridong@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: D869440009
X-Stat-Signature: 6143ecnn5ismtuu7bg16aro8qhqn3a8o
X-Rspam-User: 
X-HE-Tag: 1784881784-666697
X-HE-Meta: U2FsdGVkX1/2FOsTvYYEmZ59w+8EvKUgRkVMR/0cDckF9ib3FJQj430K7/6gqcI+9A6VN/H6dMLUCG/GVsvxINKSuMbcC85tw8LZXeFsFD4GYsFWO4KmlULX6VoCqhqT/JS9kzwNoA52dqAxyzOXPfv59/C+n9wzIpuzgCkQ83Fw9vd5HZ/PCPZ/5NmZNPyJKEBeNhawKbHgV/iXob/XtcqxfMEeR2LcYNOhinl+ZxYEIPdw83Qt8gHXiSeyXXzD8JwF6OD+ETNlrEfuTD9hBKoo9DL5juEOidPBCVKMej37K5oDv3CcmIa5cfajdoD7hfrKYyMoFpGYDlYJ01P5s/fT6L1A3f/+a73PksDLDLaPP6PQe175sLgeus+43cJ1F6+tR/KHHn4jp06ikgXk0UMz0xpJqls0LCh32XaVOGJl0xPPTrQ9CpUnGYij/RJuUsACONjyRHwCrjeCNLycy4rzmlQzJAMJXz23QnOcZmbYk6SuSDELBKFIR0SPH7vMsiwpVz/O76FgtI5PA+bhPphVj1vCwbSlrYisUY73H3QXl45tYwz82WMmdxk/suXGABtTbejVLMvDWT4aJmFpukRYCdBBMacxIa2QHd4icMV1lgZh0hB6UZ+TMyAESv0Ab9JRcLPzvPU0kxw/vJVkYawxclc7povXYPFQRrZl9449UcllTFN7S2DD3ZMwl0TH8mnHcL3e1k8RG5zINZv6MGKvUrjD3i5PHpBUW8I0MXg2IIxovTpXiEWedma+/EX7V/mrhedzcZl0MPhW/1XEWs1pNfxfcZ4LwJhFoDAZVqGnzl7PJSF6/4MCAg6Fz4CjgKzyfzQI06APXgOAwv808IZ4yDHSzHvjhdoCmyeSNrYTsgbJw+2z6h9zF0FB5ZQxgpau5oUNPCMfZfqF/8GUz/vUQwdlmY3jpkk5OQa9KaoU5ITqVbApMrknrhmiXY47/+HvWU1wiHbNu6tDgD2
 olmVbGNd
 LoKDInVd37X2fn5BSWMgVpeVfvD3rrrcugX5VuAFHZYZPY8t/y2Lixv7DMq7ar2TclgKjUngJ9PdsQmZKt5uW6qxRQEHCRiVan0HU+XSw879fqJbFz9/kd9rO1iEnZzVo2tK+ulnXlrCmFCwFGmJRsxnA6XpV7qFDrP4zPD7wq8BvYg8IcBPoWHi4BJnQm5sgP+WI+en8yGFXYXc08x+v80b6Ekj3PsgWibDAw7OZKb5a4ZzvpfDJkEzaPk6AWGrwfIGIE+BoqAmLKFkCsX1lCJz91PIist37lxQd3h7D8tZ621WGOOiOqzrMmMz9sYeb0cjyzxhP/VeRnJydF0LjqoHJZ6iNa7sT94V/VWS/2WZRw786lWl/SNdqGGkFKQtx7oz9iQSwmKbel+E=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 11:35=E2=80=AFAM Ridong <ridong.chen@linux.dev> wro=
te:
>
> From: Ridong Chen <chenridong@xiaomi.com>
>
> The previous patch fixed this issue for the traditional LRU. The same
> problem exists in MGLRU [1]: when swappiness=3Dmax (SWAPPINESS_ANON_ONLY)
> is set, reclaim is expected to evict anonymous pages exclusively, but
> file pages can still be reclaimed when anonymous pages cannot be
> reclaimed (e.g. no swap and no demotion target).
>
> Fix it the same way as the traditional LRU: keep returning
> SWAPPINESS_ANON_ONLY in get_swappiness(), and return 0 from
> get_nr_to_scan() when SWAPPINESS_ANON_ONLY is set but anon pages cannot
> be reclaimed. Since get_nr_to_scan() decides how much MGLRU scans,
> returning 0 skips the scan entirely and avoids the useless scan work
> when there is nothing eligible to reclaim.
>
> The test result:
> Before fix:
>
>   # cat /sys/kernel/mm/lru_gen/enabled
>   0x0007
>   # cat memory.stat
>   anon 204800
>   file 67108864
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
>   # echo "64M swappiness=3Dmax" > memory.reclaim
>   # cat memory.stat
>   anon 208896
>   file 0
>   ...
>   pgsteal_proactive 16384
>   pgscan_proactive 16384
>
> After fix:
>
>   # cat memory.stat
>   anon 188416
>   file 67215360
>   kernel 1970176
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
>   # echo "64M swappiness=3Dmax" > memory.reclaim
>   -bash: echo: write error: Resource temporarily unavailable
>   # cat memory.stat
>   anon 204800
>   file 67215360
>   ...
>   pgsteal_proactive 0
>   pgscan_proactive 0
>
> [1] https://sashiko.dev/#/patchset/20260717113300.214717-1-ridong.chen@li=
nux.dev
>
> Fixes: 68a1436bde00 ("mm: add swappiness=3Dmax arg to memory.reclaim for =
only anon reclaim")
> Signed-off-by: Ridong Chen <chenridong@xiaomi.com>


Reviewed-by: Barry Song <baohua@kernel.org>

