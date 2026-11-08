Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 45AD1606A31C
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 20:00:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=K54YUwye
Received: by kanga.kvack.org (Postfix)
	id D68046B05B4; Sun,  8 Nov 2026 15:00:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D18F36B05B8; Sun,  8 Nov 2026 15:00:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C08876B05BB; Sun,  8 Nov 2026 15:00:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 92E7B6B05B4
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 15:00:25 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 84AC4A0441
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:00:23 +0000 (UTC)
X-FDA: 85413018726.09.28231F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf24.hostedemail.com (Postfix) with ESMTP id E0B99180002
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 20:00:21 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K54YUwye;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794168022;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0t1IoikLmQeJOs13YrNXpWqFQtdpP6egbT1Ng/ntwIA=;
	b=FMBAd/P34Srr5VokO2or7G3+ZEqdxHxg8Ezmr0roZ1Cx/LJ4Hq8S/S0JtCQ8qlqVslXtPV
	vsyyUDxoSt3WRAAMiptkYEo61U0Es6xT50ALQdIgQ5iE/cCmXyAQuGA99Xw5IPGCSUIMfJ
	5UZaTuYzwnXg5WmGymKti7CfvicFJMg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794168022;
	b=m2taTFFBffbrps1cgkowTtaMrCKe2FfDewyZOeqv1q7VoaRL+awSTfIKLc8t/AI2RvCWV2
	7uNVIprf6wBC6dTMnGDd5kZNhq8WKeC/lNjuggOrHYcSvilPrlTJunK39KBsLZKtwxcoDQ
	kWjyeTz6efqpyBs6os1GYwTQ9Ifw6/k=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=K54YUwye;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4FDDB618F2;
	Sun,  8 Nov 2026 20:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEAE41F0089F;
	Sun,  8 Nov 2026 20:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794168021;
	bh=0t1IoikLmQeJOs13YrNXpWqFQtdpP6egbT1Ng/ntwIA=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=K54YUwyeUgUB0aOnJcNqp57726P1hkg51pByTxgZXqeo39/89w82Rg3A/ypQm5hN/
	 db/DOqQY+zLjSGmUn02Tu8YsLlae6+ReMNYsvDQ2H6kTUFBgTOZ+jMcVspJtVROhdn
	 qDKWycKOfBP28WS8DRQqrtmkNU/YHv3m4xsKmW1czIcBwmZOGjmibTCGh10rQfBssz
	 VfE0QpaEQxJXw3XmTZnhr8JWRxe9i4lF9Cg33Ps15+KSqZdScNDNXjrnIldFORJsu6
	 5XtFrTwAuefHPMDiwxdE6V4iHKDOb40h7n/HW2HSlhUrK9vLjZIpfoTYF7bqSMJUJw
	 tIYiPApzBZhsA==
Message-ID: <sashiko-outbox-204000@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 6.12.y 1/5] mm/damon/core: skip applying scheme if
 region split for quota fails
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "Usama Arif" <usamaarif642@gmail.com>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261108195145.115792-2-sj@kernel.org>
References: <20261108195145.115792-1-sj@kernel.org>
 <20261108195145.115792-2-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sun, 08 Nov 2026 20:00:20 +0000
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E0B99180002
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: fz1okfyqsxs6zyiw61inpdcdhusx6fto
X-Rspam-User: 
X-HE-Tag: 1794168021-984214
X-HE-Meta: U2FsdGVkX1/tWZFS0FyA0P3Ff4AadcHlp6BmjoiMpSO/7tjxq8KGgZkfQq7sVMRyGYdtYComepwWKhADZ+F4R8bjD6S//BrSK6dN9coOOpyWPpbr1ga/Sn2KMDZHohRxRtPfGBYwGXhAUCKf4aMT6u+CDSOmeeQLn0EdMue8NxVmXu8dwot3fP8FYPK79XsC1MjHsRH1Dw5SLx6w2BA381UGy3HdEI4c+hjXam1PJ715KdUh4bS16NummZM1MsAqP+iVh3lQIjCeCU9nMTYrIBZ7T5vNqMI1SClHUB1uQFagwRqNmW25EYWjST0Y6RaW5TYEfQrre4ihp1QmLjA98pAUKwp5elCEIk+OS6qxAuCE6rGfmOuAMtPfZ8fvnuJnOYeGb2v7mYYfGygRNVzuU1Mu9KSHjzN0crKn5UPDPB9q5hfIp1Ji0c++23jpzCJ8zDx71GxWc/4BUbSMChP1mIJKpGwRiLbeWmM/sKFqdbIjsV8gqHcaqIDcAzH0Oak1PdeCQ8/TMUoxoyafl9iL8nSK22kfrGXnEJ88f/YiXv0xpKB1gx2z2AOapNDKIgi7C3IuPXIiCw59SOzxENqVPtdI6aE6ASHJOHK1JNmldRXD+AHCwPh7IUbf88JMy7K4QGswyvKJGsgBLeA2W+BVXmmdEVJvUjQA6zgfr5GSf92pWeKhrs1GxiO1UH/TRu+7bxqpJ372Pwkwd1BJCzGaP7SBQxizYawh4+8LA2SqVUF0332Es4+0ji184OluGhLIepXNuZ19Jv1YZA/Ju1A7Emn3qRNjPhedrnw5g4AODNrwRISFIlti0dLnAFCVcFEo2cp3gvRGMTO9iOBOsrT6zKpTUWz7QQejmqSnu6tE+KeMLTdW1xclMWPr5PUD0YqrMPhtlAFmV3rKZ6jPjeM0vxqr15paDDaVqwkX/w3V6iyu+DuoOxm2DkHoGNe5Vfn1ofdEc9BelfrrHw0dmPu
 xcw/y2V8
 qvlozBwvhBrPVT+uEpE1R0eFm4hJaHOEEGkayx3W8QFK5OYrTrhs/mi2+ekG153IjRRFYlvegd65L5XLXYM1xPaflpkLg/GMjkCcaZZuKYdHTnSV+EW0cd7T4inCpqLf9rdYVfFZU8+x0fPVLFY2H+4cOLurCA8Hdtk8jZSdClGiUG+K6jNjedOlia/8od85g11yNUlAfRczIkd/DeWhTp2liN+zPelLwlweIb4lddtoSIRSqtQBpMLmcXUmXUhQVGGpGxUqPcLBCutd9xfzibm9mP2QN10LSiwe4O3djRDniq4AngVSdCSNMoc3M++HABXdQDKhWL6rs7rql0s7Ah+GZrOvEfopL2hs/qiakBXBrbbKVrRoX5Ww1Qs97NtCtUXmhcF/9v/7bcegsK7Q3Mxz805DRxXid+WN28cZKksnUQ5+cZrVqSL02VZyLwWRCeIgdd6luXZlOlyEW8woDB8p2uTsXCljR/WvDi1+zC/jXmvlywfd///nzuayDuJTXf8hnpgrsAV9r2/t91EjcdROl5D0tcg+sy8Mo/UamLejg5PRF71iVhtEkmY61VKDU3yRuDwhmHhq4fMElskBTdpTXWg==
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
- [Low] mm/damon/core: inaccurate tried stats on split failure in
  damos_apply_scheme()
--

commit 2d3797cf5f053ac8bc0b4587f17ff69eb9813ce6
Author: SJ Park <sj@kernel.org>

mm/damon/core: skip applying scheme if region split for quota fails

This commit updates damon_split_region_at() to return an error code on
allocation failure and skips applying the DAMOS scheme in
damos_apply_scheme() when splitting a region to fit within the remaining
size quota fails.

Link: https://lore.kernel.org/20260901131850.98037-1-sj@kernel.org
Link: https://lore.kernel.org/20260901131850.98037-2-sj@kernel.org
Link: https://lore.kernel.org/20260718171523.87547-1-sj@kernel.org [1]

> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 81d44e41de210..6ef77741b783b 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c

[ ... ]

> @@ -1470,7 +1470,8 @@ static void damos_apply_scheme(struct damon_ctx *c,=
 struct damon_target *t,
>  					DAMON_MIN_REGION);
>  			if (!sz)
>  				goto update_stat;
> -			damon_split_region_at(t, r, sz);
> +			if (damon_split_region_at(t, r, sz))
> +				goto update_stat;
>  		}
>  		if (damos_filter_out(c, t, r, s))
>  			return;

[Severity: Low]
Does jumping to update_stat when damon_split_region_at() fails
inaccurately inflate s->stat.nr_tried and s->stat.sz_tried?  At this
point sz holds the non-zero remaining quota, so damos_update_stat()
increments s->stat.nr_tried and adds sz to s->stat.sz_tried even though
scheme application and damos_filter_out() were skipped.  Because
quota->charged_sz is not updated on this failure path, any further
matching regions that also fail to split in the same walk will
repeatedly add the remaining quota to s->stat.sz_tried.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261108195145.1157=
92-1-sj@kernel.org?part=3D1

