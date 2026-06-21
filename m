Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60684CD98F0
	for <linux-mm@archiver.kernel.org>; Sun, 21 Jun 2026 04:21:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E618B6B0005; Sun, 21 Jun 2026 00:21:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E39486B008A; Sun, 21 Jun 2026 00:21:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D27756B008C; Sun, 21 Jun 2026 00:21:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 59A956B0005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 00:21:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id B4CE412030D
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 04:21:33 +0000 (UTC)
X-FDA: 84902620866.09.F6171A8
Received: from out-186.mta0.migadu.com (out-186.mta0.migadu.com [91.218.175.186])
	by imf11.hostedemail.com (Postfix) with ESMTP id 528F040005
	for <linux-mm@kvack.org>; Sun, 21 Jun 2026 04:21:31 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jhq+3MKD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782015692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=4dkuMvT1iZbZrtYLWgyC9GkvIWTgGmRGV8kOxOiB5+Q=;
	b=paimjoA7PoAQpIi+/iXUNAMqc8kwaVOuFcNJeu07VzXIO9cY0gKufVB30/XEzfHm1Gap5s
	16zdDL7Pl7bGqfQj51bMuHdQY0DfBnqzBDKTYzAK92CPEoqvfe2wFfcW78/TiAUedrzkMR
	AGeMCZ+PIGwKLrfj1JlFijgtih/qrqg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782015692;
	b=cvwcw5KlwfDGmFB3gTHN7m+zHFD9LgdhzVmc4bJVLW0zYAvfn0O2Vk7/gMJRX3qYhpqjD9
	kM591wBjQA4NUqreghQ745MJAKTxjmKF8bYh+GqQUW8dO3YqTd4NOx2fHpwl+Y6/Burr/W
	SCwCudjk+49ifbLTu+UOn+aVum2LHoo=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Jhq+3MKD;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf11.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.186 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
Content-Type: text/plain;
	charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1782015689;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=4dkuMvT1iZbZrtYLWgyC9GkvIWTgGmRGV8kOxOiB5+Q=;
	b=Jhq+3MKDM5IK7ruQ9JcD0RGhLAJ2fdo0kybKyrFOZpyIO3SWOFBhPAK9SUj4+Ks2Xi+dUD
	cMRlMGjvYM3iQZkVSkUkoLJrRKZe0BMIA3FbjmwyMQzEdPIZdKkIdPaIVmnB+zKdGUF4wr
	oAgSjlXfGH3ztENGpidwkxPzWsMxQtc=
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3864.600.51.1.1\))
Subject: Re: [PATCH v4 0/5] mm/zswap: Implement per-cgroup proactive writeback
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20260618044857.69439-1-jiahao.kernel@gmail.com>
Date: Sun, 21 Jun 2026 12:20:51 +0800
Cc: akpm@linux-foundation.org,
 tj@kernel.org,
 hannes@cmpxchg.org,
 shakeel.butt@linux.dev,
 mhocko@kernel.org,
 yosry@kernel.org,
 mkoutny@suse.com,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 roman.gushchin@linux.dev,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org,
 Hao Jia <jiahao1@lixiang.com>
Content-Transfer-Encoding: quoted-printable
Message-Id: <CAAAF57B-7DE9-45EA-8AB6-DE6CFAF60F47@linux.dev>
References: <20260618044857.69439-1-jiahao.kernel@gmail.com>
To: Hao Jia <jiahao.kernel@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 528F040005
X-Rspam-User: 
X-Stat-Signature: uth74tf7dw6gjbecf8x468gnambcuzkb
X-HE-Tag: 1782015691-127076
X-HE-Meta: U2FsdGVkX1/WIl+rItZTYDt3ptahaUPY8+3bOALbaVoIFT+Es1aGbJ8pqveBg6O7UZd/LEN5nsIEnkWcwIGSsQ9JlTgAFO3qsYPwjO+NB8HF1l99H76hudUX7wsfxQZiwtwSLXnB0zIStqLoavnztaEtvS/6aohXHyWoZ4cRF8JSUUvbrevOOMRrMyQG7lbJfhJC1DUCrn13bwV8S7jshkdmpCCSHzo8IKExhYaa4Clm5Af3VBiuye2ydBpJzOhKV61l/UXghWvyvJAZxGLtzXJwTNNNqg5Kfs8/LUMn+4QQ1egHGDiHmkuqcxKOZ/+6DrNtMLfG8ut8fb6159g89S9NyZHBWR3iqcUlmwabUoVWMrn1yqKwbRvrQT8moeQL75Od2RPdiw7uLwQLhAOdG1qyW4RYHChSv6EQxLXFHxG3CTBSku90m0Hev9hefIGh7UBjH7gfmhLdOg+HdzXY4Z6+HFPiimeARp298BRxi/33Zhpd0xCW4wzvUhHOVKrV/PCSR3zmsnhu7ZQvbBjYj8TILyk5YAUthgIN1cN702eEn1sf3um7s+INKGsPPOi4yVaDlh5DXdjIgrYnZSzTVwEZb/0+a9myJJjrVN7sJmyExHE8ZdlHZFrr5rxitho5ZbWNd1us92nGSGfw76wZ+nTrC+kmeUxLGMHEGF2lfTp/9I3IRwiwafsTSzKH2FG/woyBsUPjqbG9uBR5mIHW3Az6CyeGO1QQacCX0AnPiddH1Zi8bSA4J58GrPXba5d1ZYrhxNUjJyLmHVYfE3TFpUlTOAopUf2JjqxRFfrbgEvb4WQoOiw0RNru4s08J05eGNNQ/WBOYdWgrZIdax3MkCY61sJq+2JRIaNITSM+Nf/sXcEmCUJWnc4s8y+FFtFzuPeNCLNGXY/d2xaeb5eiwOXxMWqhgi9Bp89suGbbFoiE9pHnHz76dUhasK4HJQ+50dNoRe25oQ9jMWP98Ay
 Pdxgizxb
 FtHHGTp5isiVFHGVRJ4fKYKbNLVJMh1ikJnix/MkdX+DeYk3COL5zNZEi7N+oCOV+J1tao2LW8LBQce8ZWFcuF/onwhPUsJjl5GU0x/NnbtrUNSCunntCjsl7wvx6RiJuPSrnf6DM2u1g77uxuCvh6UqYSY+CBqTE4XSC30XQ6BzWxUMElK1TgVtCersUHFXIDBAxdk5nSQjB+SQAgsEGYiWs0+BSJ8JGT4BDQ+n1rY6MY3DWC9FhzMUHH05WX8yRc+pvvliUiDA0BZnswzjmdqj/4/XYgcl9nFEdwn0/sHH/GyJFOCTaLyyle3dX0l/O3APqLQfwCks/THQdOMHhgPMC2PfZnJe8ifS71wDEYERp76lGe31qUphDSKrlfSpgHdvIsrrkDsbJUb4tHHm/yg4xXU0bv0iw//Vy+VFcCBn/3aU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



> On Jun 18, 2026, at 12:48, Hao Jia <jiahao.kernel@gmail.com> wrote:
>=20
> From: Hao Jia <jiahao1@lixiang.com>
>=20
> Zswap currently writes back pages to backing swap reactively, =
triggered
> either by the shrinker or by the pool reaching its size limit. =
Although
> proactive memory reclaim can automatically write back a portion of =
zswap
> pages via the shrinker, it cannot explicitly control the amount of
> writeback for a specific memory cgroup. Moreover, proactive memory =
reclaim
> may not always be triggered during a steady state.
>=20
> In certain scenarios, it is desirable to trigger writeback in advance =
to
> free up memory. For example, users may want to prepare for an upcoming
> memory-intensive workload by flushing cold memory to the backing =
storage
> when the system is relatively idle.
>=20
> This patch series introduces a "zswap_writeback_only" key to =
memory.reclaim
> cgroup interface, allowing users to proactively write back cold =
compressed
> data from zswap to the backing swap device. When specified, this key
> bypasses standard memory reclaim and exclusively performs proactive =
zswap
> writeback up to the requested budget. If omitted, the default reclaim
> behavior remains unchanged.
>=20
> Example usage:
>  # Write back 10MB of compressed data from zswap to the backing swap
>  echo "10M zswap_writeback_only" > memory.reclaim

I=E2=80=99m not entirely sure if other candidate names were already =
brought up
in previous discussions, so my apologies if I'm repeating something =
here!
I do think expanding memory.reclaim is a great approach. That said, I
was wondering if we could make the interface a bit more concise while
keeping it flexible for future extensions.

Essentially, what we want is to control the specific targets of the =
reclaim
process=E2=80=94such as file, anon, or zswap. What do you think about =
using
something like "source=3Dzswap"? For instance, if we want to reclaim 10M =
from
zswap, the command would look like this:

	echo "10M source=3Dzswap" > memory.reclaim

If we only want to reclaim 10M from file pages, we could easily extend =
the
syntax:

	echo "10M source=3Dfile" > memory.reclaim

And of course, we could even combine them down the road:

	echo "10M source=3Danon,file" > memory.reclaim

to only reclaim anon and file but bypass zswap.

Just some thoughts of mine.

Muchun,
Thanks

>=20
> Patch 1: Extend shrink_memcg() to support batch writeback based on a
>  compressed-size budget and update its return value semantics, thereby
>  improving the writeback efficiency in the shrink_worker() path.
> Patch 2: Extract the memcg iteration and writeback loop into helper
>  functions to prepare for proactive writeback.
> Patch 3: Extend the memory.reclaim cgroup v2 interface with a new
>  "zswap_writeback_only" key, allowing users to trigger proactive zswap
>  writeback up to a requested budget.
> Patch 4: Add the zswpwb_proactive_b stat to track the compressed bytes
>  of proactive writeback for better monitoring and tuning.
> Patch 5:
>  Add tests for zswap proactive writeback.
>=20
> v3->v4:
>  - Drop the per-memcg cursor and keep the root cgroup cursor
>    (zswap_next_shrink) logic intact.
>  - Stick to using the zswap_writeback_only key, and change the =
proactive
>    writeback size to use the compressed size.
>  - Consolidate and reuse the logic between shrink_worker() and
>    shrink_memcg(). Enable batch writeback in the shrink_worker() path,
>    while maintaining a low writeback budget in the zswap_store() path.
>=20
> v2->v3:
>    - Align the return value of zswap_proactive_writeback() with
>      memory.reclaim and update the corresponding documentation =
accordingly.
>    - Resolve conflicts in test_zswap.c on the mm-unstable branch.
>    - Enhance the zswap proactive writeback selftests to guard against =
potential
>      future regressions.
>=20
> v1->v2:
>    - As suggested by Yosry and Nhat, extend the memory.reclaim cgroup =
v2
>      interface with a "zswap_writeback_only" key instead of adding a =
new
>      dedicated cgroup interface.
>    - Update the zswap documentation and add selftests for proactive =
writeback.
>=20
> [v3] =
https://lore.kernel.org/all/20260526114601.67041-1-jiahao.kernel@gmail.com=

> [v2] =
https://lore.kernel.org/all/20260525122242.36127-1-jiahao.kernel@gmail.com=

> [v1] =
https://lore.kernel.org/all/20260511105149.75584-1-jiahao.kernel@gmail.com=

>=20
> Hao Jia (5):
>  mm/zswap: Extend shrink_memcg() writeback capability
>  mm/zswap: Factor writeback loop out of shrink_worker()
>  mm/zswap: Implement proactive writeback
>  mm/zswap: Add per-memcg stat for proactive writeback
>  selftests/cgroup: Add tests for zswap proactive writeback
>=20
> Documentation/admin-guide/cgroup-v2.rst     |  22 +-
> Documentation/admin-guide/mm/zswap.rst      |  11 +-
> include/linux/memcontrol.h                  |   1 +
> include/linux/zswap.h                       |   7 +
> mm/memcontrol.c                             |   3 +
> mm/vmscan.c                                 |  14 +
> mm/zswap.c                                  | 322 +++++++++++++++-----
> tools/testing/selftests/cgroup/test_zswap.c | 153 +++++++++-
> 8 files changed, 456 insertions(+), 77 deletions(-)
>=20
> --=20
> 2.34.1
>=20


