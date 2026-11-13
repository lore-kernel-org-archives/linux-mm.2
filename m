Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C083A606A31C
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 04:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=IhcoXW4S
Received: by kanga.kvack.org (Postfix)
	id B89AE6B0636; Thu, 12 Nov 2026 23:14:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B61696B0684; Thu, 12 Nov 2026 23:14:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9F5B6B0685; Thu, 12 Nov 2026 23:14:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7FE286B0636
	for <linux-mm@kvack.org>; Thu, 12 Nov 2026 23:14:41 -0500 (EST)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 12AF9A8ED5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:14:41 +0000 (UTC)
X-FDA: 85428779562.22.42E12EF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 6930240002
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 04:14:39 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhcoXW4S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794543279;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pogTDpj4TgkSz+uAsaVTWqPp4yODvgEwDapffqCXwZQ=;
	b=0kSxbss0/oZS0RkHolYL+q41QD9sQs0lv0cG3IpqyQ2wzIkU/xVkzD0ZyEl8AEBLlvrRcg
	6jisYZ6WnMVneyPV1OqM1flCdeD/qKKyMapnekbb6qWQyRzipleArx0Z5ERyKRYjdpqVCW
	e/gg/GPUUeO8lcAt+k47i2TJR1SC0Q0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IhcoXW4S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794543279;
	b=d5W3eGmy5ETyLvxr2bBlXsP0HvaTzdcdQvOp/gxAhUkK02y3CYh6kuSeTNBtJa2l6refFk
	puwO/EOKjdCZ27d7jKNA1CUbrWLrHXhUKvL4oSZVsUIqRYqjqLd3LNh29ltlITb0ShC0Nm
	h0cRQrFfOJaLnUpPYF06/bh3IJ/IxuI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id ACBF1407EB;
	Fri, 13 Nov 2026 04:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 216921F000C4;
	Fri, 13 Nov 2026 04:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794543278;
	bh=pogTDpj4TgkSz+uAsaVTWqPp4yODvgEwDapffqCXwZQ=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=IhcoXW4SYIgKmHsagXcLLTzVJrlRQRcJKnsE8kXX4mLHgfF1d4XagIn0YngejJhKL
	 4h1PFrA5gIe2SyiVtidI9+FsnhcGETMJpg8z4IjaAkuOK2kRTvZR93GUmBq4m+TvdB
	 xHz/wOEqFmiGsNSh9Ye6GH3o+0tBlAmm5f2CubT8eDQn+HjzO2Oj5yXFjL7/AYsYYJ
	 XGeJLAKGBpDjI2s9ICD/3Wp+A3eVFARtIKqgqHw2+Y9AUz0/05Q34WysjLyCG1i3tZ
	 qX3cNuAHsppM6nzSGWS1ein1JKnoUD6HWRFyghhTzgKdjyAs7RUcBQpFrdF98NpSrt
	 GmgOIOH5WN/Gw==
Message-ID: <sashiko-outbox-212161@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] mm/bpf: Always flush memcg stats when explicitly
 requested
Reply-To: sashiko-reviews@lists.linux.dev
To: Runli <mingyu.he@shopee.com>, "Johannes Weiner" <hannes@cmpxchg.org>, "Michal
 Hocko" <mhocko@kernel.org>, "Roman Gushchin" <roman.gushchin@linux.dev>, "Shakeel
 Butt" <shakeel.butt@linux.dev>, linux-mm@kvack.org
Cc: "Muchun Song" <muchun.song@linux.dev>, "Andrew Morton" <akpm@linux-foundation.org>, "Yosry
 Ahmed" <yosry@kernel.org>, littleswimmingwhale@gmail.com, tj@kernel.org, mkoutny@suse.com
In-Reply-To: <20261112041348.66915-1-mingyu.he@shopee.com>
References: <20261112041348.66915-1-mingyu.he@shopee.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 13 Nov 2026 04:14:37 +0000
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6930240002
X-Stat-Signature: 61gz43ggw31pzogrnp3dcff46s7w8b91
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794543279-79376
X-HE-Meta: U2FsdGVkX1/atNeRLBx15NFii0GlTPivYAG00hkZD/BmtP4qmj0kVSSGAFfW1IH36YSlimYuK9WTd/GC+zTa0nuW7BsimCw8/wnPdPc/HVhGOfTbeyng0WvsF4WuN53ZeveiDIgJ3KxDf1gOAwiR4hK30Qpin2pcVuHTkf4hIBdPjb6qsFyFPhvkRNE4+6b+NR7hsGFuPEvdBJADA0h3lposn0D1fFsBdnNwcGhmid7hLHSZyKxutyHUo4UNU6ifSNFbnz5lOTrUKGfiDVI9kkVm9zci4gT3UZS5DAtE71PaxVQoeZa8lHyjwk1kATr8AsK9jXVjPc+Vns8Cdd5rwTHgiq2kUrALquNXpRZ4YpSZC4Mh8AHS5QWsLeLaTxb6wgMbS040x03vstGWz1/zM4I09tPBzNuAXtDfgZUmFnP+NKAjO4bShULveKlAltZwC0PnAaOzUitUnOecpTJ6U7sUNP9k0vLyn9FfSG0B/QWYld3FnqPT10Sx1XDrcucdnxf+IIR3dq6y6yhharvWZvFkY7vl2Ja5BWzv86wbyCe56o/I+utFrA/W0+gIbxxjE2Eomn6wrmnkTb6Jt8pBl7GQ3as/Y8GveY36bdhu+dtaok9YwUkfnh6GGZ42P82n3u9LEkPPI8kQCVORid1Li7jBInEuWdG2R5GON6P7LGsj57RDI+2zEYWMIwXnI8HHl1uVj55gGXP27dmcGkTvDggZY4cYkldkH9Qj24zaaCM6kOgTMEZsi1rlGsZ/auQXh7tnaWCxpuV/uUau8Iei3ZlNi1/+qTpUFi4kcWodNYCCi84mWoGLokRABMbiOIszTm4l7UhB9GLMAemH6vHPBtesf78h3QTJXXeKrItw7j2DX8EeVq8DMAqQgMmazLdbcMyOAIvpXLAKZDWwiJNmQjZVyNuFEnxKrUdARnmjFcOOYKHhDrnDpP8/8/heriSG+CYEdoZ/D9CR5d4sXjC
 OeA29DfU
 blD7U251coju0Todl14ln/14nVtR7U3FaIz8X8zqc6wGubRZkNpdhVFVWsrqVv+xfZhzBGmF8aGKVcIHCKullpchyUB/kznuaDDLYPWQLLLfnzB/Dgh/lVbqvTo7QfJxrgiWJAEEUkG7wWdm4HXiYzYsQ5yYWmUzJHZ9opJIbR6bfvvZfhPiebdWNSGLAHADdNyojCqA6LvwgtH9j/Abu2JwOsrmSdA8mmc1nDF4k0HaIpOUR/6AiH6nWIiDYIm8AkM09zhtn5yv30Gx3JwkQpOogUF7r38hw8P7+9hQmBz8wfTixawOfDR8fjTevtdFobxLesuhZCY2mLZzfTB5xacs/O5kQ4MPvF5PEHXUHiX4HgOihSMV18lxsR7ZobgGeqMcy101X7PMnNMxIdZ8jTg8suTbGm4lPxFR7xH8HS4YqdDaCfnjJeOCo2VVAAgmkQu1k71TVj9VMAvrlUomYn13XrpM0Djg8HBB9S331C2N6t8lU/3KbzWzPxqvgqOxpVJ+jG/AFiSWiDowPP8T7xjfIOhhsJMXzweOLdhcbqYvJPMO/f42eAyxrY/mYcQeK0icsVr20DCPW3BSyv/zd5TtaKlKQ+DPIENgXxKnKKZK7dgq6TJzNGmKKLUrhqZfj1aLhRsCePcwqvj8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential
issue to consider:
- [High] mm/bpf: single-word nickname in Author and Signed-off-by
  trailer
--

commit 4c2af3a1c095e013e48cf708056b8f9ea3fe242a
Author: Runli <mingyu.he@shopee.com>

> mm/bpf: Always flush memcg stats when explicitly requested
>
> memcg_rstat_updated() stops walking the ancestors when a memcg exceeds
> the flush threshold. A concurrent flush can leave an ancestor below the
> threshold, so the early exit prevents it from receiving further updates.
>
> Consider root and leaf on a 4-CPU system, with a threshold of 256.
> CPU 0 is flushing another CPU's stats after CPU 1's stats have already
> been flushed. The counts below are shared stats_updates counters:
>
>   CPU 0 (root flush)                CPU 1 (leaf updates)
>   ------------------               --------------------
>   clear leaf->stats_updates
>                                    add 64 to leaf and root
>   clear root->stats_updates
>   finish flush
>                                    leaf =3D 64, root =3D 0
>                                    4 more batches of 64:
>                                      leaf =3D 320, root =3D 256
>                                    next update:
>                                      leaf > threshold
>                                      break; root is not updated
>
> Root remains at the threshold, which is insufficient to trigger a flush,
> while further leaf updates keep taking the early exit. The periodic
> forced flush restores progress, but until then the root's aggregated
> statistics can fall far behind. For example, page cache grows at rate of
> 1 GiB/s, a two-second wait can leave the reported usage about 2 GiB below
> the actual usage.
>
> Make bpf_mem_cgroup_flush_stats() force a flush without waiting for the
> periodic flusher, while preserving the memcg flush bookkeeping.
>
> Suggested-by: Shakeel Butt <shakeel.butt@linux.dev>
> Link: https://lore.kernel.org/all/avKy9oMwDRjKjfzm@linux.dev/
> Signed-off-by: Runli <mingyu.he@shopee.com>

[Severity: High]
Documentation/process/submitting-patches.rst requires a full real name
rather than a single-word nickname or handle in the Author header and
Signed-off-by trailer (for example, Mingyu He <mingyu.he@shopee.com>).

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261112041348.6691=
5-1-mingyu.he@shopee.com?part=3D1

