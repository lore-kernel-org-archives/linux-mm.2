Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CA483606A31E
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 12:19:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=TrTLpHDI
Received: by kanga.kvack.org (Postfix)
	id F3C806B05B6; Mon, 23 Nov 2026 07:19:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED516B05B7; Mon, 23 Nov 2026 07:19:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DDBFC6B05B9; Mon, 23 Nov 2026 07:19:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF59E6B05B6
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 07:19:37 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5943880855
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:19:37 +0000 (UTC)
X-FDA: 85466289594.21.47C661C
Received: from mta0.migadu.com (out-128.mta0.migadu.com [91.218.175.128])
	by imf21.hostedemail.com (Postfix) with ESMTP id 5DC741C000B
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 12:19:35 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TrTLpHDI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795436375;
	b=f3HqBn6CA6J5DChgKxwu93YugQC8Z0U+2YV88VenPhdA9qAjA2rEbhokj0i4zjEYpUebm3
	Yv3HKJttuOGCrIx1j91a28tCjwxPlKS5mm9xXTJHTfFcm4kLG6kTVvcP6WXgAmqtZOFJik
	7RmJFqzd2RivYrJwaijteLukppHe6T8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795436375;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=qFwzl/gqyXB9gwRR8c2MAVb3Uw3fjAbSkoGnMFYVdKI=;
	b=8KVWu/xpd71mK2GUzUfW/kcQNbH+4Qsy0PFiGlXiqFTlY4imT0ByflBeQCXx0x5A4XUEO1
	i+NmqLBAbnr7Ty+LmwOIYB6y35g0y70BSIvfPDIA9/cTKkedCGU/h5jb1xqTN1rw6QuUEu
	3VbuoQp/BWRDpgJCbjKoi3joLNUyBAc=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=TrTLpHDI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf21.hostedemail.com: domain of muchun.song@linux.dev designates 91.218.175.128 as permitted sender) smtp.mailfrom=muchun.song@linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=coZuep8pYTbxWk92faixoYVxpekvKhj4jeYY1NcGyIw=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1795436374; v=1; x=1796041174;
 b=TrTLpHDIS+60LkaiczefgRMgnky1vnxSFkb+C3x3RU+1Xq54nvmvlS5tejNuJVHj1SAUNZQR
 ziibhVNBTI3adYJwXeFCQqBRrWKep92qm7qm//X4sxxfYjgv4hdyh++l9VPoRQNsgmPmk9MKBOe
 fBuV8oEqLeCAkvPSrj15YEbM=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 565cf6ba031b59a2;
	Mon, 23 Nov 2026 12:19:33 +0000
X-Mizu-Trace-ID: 565cf6ba031b59a2
X-Migadu-Flow: FLOW_OUT
Content-Type: text/plain;
	charset=utf-8
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0 (Mac OS X Mail 16.0 \(3901.200.71.1.16\))
Subject: Re: [PATCH v5 3/4] mm: thp: restore SHRINKER_NONSLAB on the deferred
 split shrinker
From: Muchun Song <muchun.song@linux.dev>
In-Reply-To: <20261123105334.2524066-4-qinyuntan@linux.alibaba.com>
Date: Mon, 23 Nov 2026 20:19:18 +0800
Cc: Muchun Song <muchun.song@linux.dev>,
 akpm@linux-foundation.org,
 Johannes Weiner <hannes@cmpxchg.org>,
 mhocko@kernel.org,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>,
 mkoutny@suse.com,
 David Hildenbrand <david@kernel.org>,
 ziy@nvidia.com,
 baolin.wang@linux.alibaba.com,
 usama.arif@linux.dev,
 david@fromorbit.com,
 Qi Zheng <qi.zheng@linux.dev>,
 yosry@kernel.org,
 nphamcs@gmail.com,
 chengming.zhou@linux.dev,
 xlpang@linux.alibaba.com,
 Kairui Song <ryncsn@gmail.com>,
 gourry@gourry.net,
 cgroups@vger.kernel.org,
 linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
Content-Transfer-Encoding: quoted-printable
Message-Id: <9BC09CFF-FEB1-44FB-B46E-FBE8B28E8CEC@linux.dev>
References: <20261123105334.2524066-1-qinyuntan@linux.alibaba.com>
 <20261123105334.2524066-4-qinyuntan@linux.alibaba.com>
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
X-Mailer: Apple Mail (2.3901.200.71.1.16)
X-Rspam-User:
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 5DC741C000B
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 1zou6aa1m5juadrhdogdojeeo3s5ge78
X-HE-Tag: 1795436375-396048
X-HE-Meta: U2FsdGVkX1/H6lHRa/SUj1TYJZMq8JdFaww4fvwZ8R2+7BVDgK8MEKgN2WvvtRMz3Iy0pqhbiLQt2BAQil352XfSs7gIi2NDzsrJhQaHLof67r8X5wvwjES1zIInpsbPZuinCf4C/IllklcwiYkTX5FHXkLf8p/GLm3qzV4VCdS9J1Q5trhfFUiTTnFvyXJ4MPY1B1pvvVpigTNRm8TnrA9Q+IzuQ8pKghNdoSiyULcv/O8JJDTMX3YnZQhW4RLhkcs9hc2wpG1Tx9eQd6QFO8Qfehptj9db5/mwGTQaFZD3DrAWI93qRWQMzg8GUYZP1EIzHblsq3pwgy59kOO0CALedGLv0K12bZCU39y2mUndFeE4nQUzERXQdr8uc5YQI/N/2lUV8oxYiPBexNqhTdjlC07af0S33fPBxPyFuJAyrCMEJr2P+UWW3bzJbOylXr5Bg0RuzvbR51ugxYZGAeDIUbJDIb26fTzvZr9vdUpQQRSe6ew85/2FsF+pv5BEC77gwOdupvxAf5mCmjqsqzzmQT6uCzmY9Mnhw8qXvwtqTHC20cbu8/8A7nxqW3Oq+9AHMDsevx6sKRvj9xge/6mFlv7Lazk3K5axU1uAwgPQ4cl/XmRVznCxMAbSuX778KHFBIa9Xo3ZKzbHQ0PSwIPVDoUKWKSPq00pSkeWWeFdGCQI/RVGlWoMCKwU/gcV1O4+FLyV35xS0+fC6LzQMyo8zQjTPflB1bpzOa8k21rqmPV+5sROykX1njk5y8PBnkEVy0vUMo5V8lpXyfeAtE8gdcVOz5faBiv9gv1DTYeHy9tWgZAFufPLFkXPhlwmZy7trII5ma1sTIyxzDEZj/DMZVul+k7tK8ByhWeJc0doSd6gkGJrthLbBbGzyS3aI4siZ/RtDp4ypkAUzEBipY2n1cJ0vbjHhYyFjwBcDFfmzeoXelexmLwAcwQqGxfrLaUJcy9YisOgkVCJC5n
 1lOY/yCA
 cjgPwo0kAau6wjsK2+fm7cuNrwo2jVm81zyrniAKl/nuuGLJgusiRS+0VGas4hpFeDV8RS0yNqs2dtduaFaLEHjXZwQY3/shjkwXPasoOWlY8lj+H0q0ZPdiLDK6VEFpN+J/0ZTtiMQb+gVflMddhCfbzHJSas/q17Jl3iud/HjZ+YY35Lp+aEi3HbU4L2yjPrRME/qGExnHKIlAWcBSZ9BcEQKIzK8ULcnisUAgaLASzwaDPuhcx9VDBnLXKjgliAtI4WeWa5ZORdCLZNhMwkI9GuY4HcGAPz/+C7Gtn8I6EqvkKxomzIL6zBryY0c5Ki0hpJALp+7QijZ1oAH5GgRx6DgSqYi2CmaPkI4pFvxpJiK7OMWabhod9vcUzMh2Pvnzvb5K/vGaDa+qb9SN+VJF4z3hHLUvWShVLHVlIqSUMnpSxeyGn9dPZRuwq4LA1PgJVdaCxlj6JRlKsKrDEZwgGMAnaNbOAqy6odwq/6hqYRCrrHJkxQj5Ra0hsdsZQ8KB7e8u2DhrHTC1EKbOT0KBJnk6/5hZqnuWW7sNNcLLdjeMS9kgW2vHkYCu3FhvA13KdPcUZljJ36wb2jy3LuP8ZqEuGukkEpn+USLafcMXkdLjunX0VWuHIlrktEl7n8CMX1J71QzOfeZtUuX2hkNwRDpH/v7vzLRbkwnT5uYl3udJNGfGXWZg7cUJ/od3lbu3CrrzF1+dXZdHqnSrvMZnbeQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



> On Nov 23, 2026, at 18:53, Qinyun Tan <qinyuntan@linux.alibaba.com> =
wrote:
>=20
> On a system booted with cgroup.memory=3Dnokmem, the deferred split
> shrinker is demoted to a non-memcg-aware one.  As a result, partially
> unmapped THPs are only split under global reclaim; memcg
> (limit-induced) reclaim never splits them, so a cgroup under memory
> pressure keeps its underused THPs intact.
>=20
> The shrinker has carried SHRINKER_NONSLAB since commit 0a432dcbeb32
> ("mm: shrinker: make shrinker not depend on memcg kmem") precisely
> so it would keep working with kmem accounting disabled.  Commit
> fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> dropped it knowingly: under nokmem the list_lru collapses into a
> shared per-node list while __list_lru_add() still sets the shrinker
> bit on whichever memcg happens to add the first item, and with the
> flag set the shrinker would run twice per reclaim cycle.
>=20
> NONSLAB-backed lrus keep their per-memcg lists under nokmem now, so
> the shrinker bit identifies the owning memcg again.  Restore the
> flag.
>=20
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers".
>=20
> Link: https://lore.kernel.org/all/ah9PGv12mqai84ES@cmpxchg.org/
> Link: =
https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@linux.al=
ibaba.com/
> Fixes: fafaeceb89a5 ("mm: switch deferred split shrinker to list_lru")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>
> Acked-by: Zi Yan <ziy@nvidia.com>
> Acked-by: David Hildenbrand (Arm) <david@kernel.org>
> Acked-by: Usama Arif <usama.arif@linux.dev>
> Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
> Reviewed-by: Johannes Weiner <hannes@cmpxchg.org>

Acked-by: Muchun Song (ByteDance) <muchun.song@linux.dev>



