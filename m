Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 03681606A326
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 23:25:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=OBqmeNNG
Received: by kanga.kvack.org (Postfix)
	id 0FA856B00EF; Mon,  2 Nov 2026 18:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AB696B05B4; Mon,  2 Nov 2026 18:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F02C66B05B6; Mon,  2 Nov 2026 18:25:20 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CE2C16B00EF
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 18:25:20 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 525201A02F2
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:25:20 +0000 (UTC)
X-FDA: 85391762400.04.32D33EC
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf30.hostedemail.com (Postfix) with ESMTP id 74B3C80003
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:25:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBqmeNNG;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793661918;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Vb7HtkX73433xtUzqqWbVnSmEduHdD/Vc57qkP1iLvg=;
	b=jGtN9PgFl3PfQMRrOmHj6foyX9ynRqO2lu+gF4JNLcuB0T9gjlQu8nG3BmQXrJq1yNh0T5
	83zlq4gizz84USJMFNBdeuhxGyeGb2a529P0dAE3Fb41VsaFdD2nixemJWasSQtuGCNtKM
	cqnvnYiBbEBTQfELdBl2l0KFoUk6ya4=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=OBqmeNNG;
	spf=pass (imf30.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793661918;
	b=EkGsFlvwn2xu7zVzh4Y7QsElO/WPDUVj4ofvIMSLDPddpkEAStuA7MW/fgUwm3ABuTVBIy
	BSgv0SlnW/aNlSgxmcg1aK31Fv9TfzC4cP0CAygWAMjmHeG0J28fYS1phFUlRJZ2R+rIFi
	PAXzXoMxwKAkjshBTfKKIwVXm+OYjy8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id F0B7C6021D
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00F91F00A1E
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 23:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793661917;
	bh=Vb7HtkX73433xtUzqqWbVnSmEduHdD/Vc57qkP1iLvg=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=OBqmeNNGZHL9b/mqGT1ya+9SGOyrRQ09iqF5W2E1MpvLqbSpIQR8EhDzW5Ds0pK1Q
	 vuAxA0bBJNQGh2L2D6+8j+wof5F99cRXEqAdgdIf8jyUKWf2WaazyXEjw1+GeUc9pM
	 nHaVAA+pD/4iKZGDL0AUumdU+14WgSAhBzKXq35iFOJE3ZsfsD/APTIJIcc6Km0ryq
	 sR3tiFP7u0HAfb87ycF2cPsiFGQJUq6PLsN9Ec88PUqRSVlgNPEDLYjQsuyt7o1YnO
	 I+6ABrf4/xwSI8OtidDsBoSkm0MUZs7CU0a5NqBHkOfBXlSVISIQnWlwahkQ1emod4
	 un8Hizug9xLEA==
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c4697404c2bso471856566b.2
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 15:25:17 -0800 (PST)
X-Forwarded-Encrypted: i=1; AKwUvBwDR0HGVfp7Sl+slLdLq7xSAsEpE7K2LjTd3YEz1uY+BRnyBZ3/MXwSE/trwLCNFnyJYHUWFbWARA==@kvack.org
X-Gm-Message-State: APuU4Z/9mzuoEFCQFp32jfnsD6eOFGlbJNZiL3Vdo0Xlx3NnqfPMUMII
	9nacGHnLCbhWyUvv0ZAHakMqisJWhny4mhwJeEycd+GjD6yMhq+/xFNxuS/FksASyurO5GJHaGF
	IK3c7/E7T244tVtS1T0L0uchFnoOqG5Q=
X-Received: by 2002:a17:907:5c5:b0:c3f:8c92:3b5a with SMTP id
 a640c23a62f3a-c4ca7a41ac2mr936046766b.12.1793661916543; Mon, 02 Nov 2026
 15:25:16 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102225030.2743129-1-joannelkoong@gmail.com> <20261102225030.2743129-2-joannelkoong@gmail.com>
In-Reply-To: <20261102225030.2743129-2-joannelkoong@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 2 Nov 2026 15:25:05 -0800
X-Gmail-Original-Message-ID: <CAO9r8zMWOda=j=Y0hdg32myOxQvE9MKLqFq_zNg3RMn=XJwALQ@mail.gmail.com>
X-Gm-Features: AclHuK-Ty7Urj65mhCgz7LxhIJtH9a0TCSeDIGE09_PbY5bWsOV6yqbGX4M-Ndk
Message-ID: <CAO9r8zMWOda=j=Y0hdg32myOxQvE9MKLqFq_zNg3RMn=XJwALQ@mail.gmail.com>
Subject: Re: [PATCH v1 1/3] mm: zswap: fix shrinker count for the root memcg
To: Joanne Koong <joannelkoong@gmail.com>
Cc: akpm@linux-foundation.org, shakeel.butt@linux.dev, hannes@cmpxchg.org, 
	mhocko@kernel.org, roman.gushchin@linux.dev, muchun.song@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, sj@kernel.org, david@kernel.org, 
	ljs@kernel.org, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	damon@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: shk7cya13bpah7u1584xjtd1jtfwa51h
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 74B3C80003
X-HE-Tag: 1793661918-105399
X-HE-Meta: U2FsdGVkX1/46EM16H+fLeRWtXRQL3cl3gx/hnYPhptKcyrk9cApwE3czt04ADtySD0GC48y/8IMwWr2QBhq6whUvvYS0pNe48ANXNjtC52SJC4QVdN+vk0IIQ1Zj+K8FGR3f5yvHwH5GBVe86TQXs8h3L5J4vc7pQnHguGHZOYv9Ezov2mgpZGO1ePbgu7UIVy7gIwVtc55x/HipSWJagjkKbaH+isgQDhFCSt6B+LnFkdoShrKbAPD1OEIALZmbqDsSPQZm7SND30CSvCfjKKNYfWGPiytqUIuNP+M9dwjBIBZ1dTYHLkMdCEr26XEfpZERlwMgd9zTh0VBjqz7dHlC54QoaT6zPj2zRXSPDmo21l6zmk9tZ0cySTPfU1QNzg1SJvbRWqdKScOf7MDTRIrmXjbF1Ix3620qLfQWAWA7BqA0NhLHJprDlPrx2qWN/2zk/rkhj3rUvMTUUqXiiOeiq90iNG7bw937K1xcHoq+5Om9gpSCAwAO2f+HSdt0Qoqc3TmnVlK2onvl0bcmOdrOA+qtWJUCTVO27wrrGOb3rd0YAsiM2BEpoHvvM1YrT5JI4waL3RyJYgHF5r3DG6zX6WeR5Mc2ydHzJFaspE/xSo5Y2q1U2TawodMirOb+/6oUdi2RKdeCaEtOYW5R8XwhkixhDLTofWFM52ib6/9z38X8bAt6HyJYQ6o88UQ1QPResfUiAA9pg8iu0wHGukNWChYUL31NfNsBBiNmUECf7gNEvsmK45Bfgr7kqaZhyNU+5g9hBxVx+ey6YUvaH07yVN4IaD3K1PFxi+b8832o4OcPfvScrIvzFNcnubos9tLaXS+KuFzItXNS2nXJIq0dj64NwkjMysA0j6LHX2Fa2az5fD3BJCA9txal63/n75nvdpaweXMo+boWzNQi4u3yc27LcW1TR13oLTjG6BjhAIxHaYwAC6eE5lvnjAfDP2011qbYorcyx4v1CJ
 vw17bBbq
 1CnE9SiDzdRXbCfenbQX4KJpJ0N+As0Hu5j+u/xKomSBcBx/SFe5Oe63AITr03MEAsTHLmVdJvog4+tjtWcjU8Q7hUqeQpz6q/zlu2li2ZQLmhWVJT0DlT+fy8HJXRRkEOO69foafqAeHBoUEvAhrKBWwi19JqR8RmhkpirV6bclw1Xfetj43xwL+bBvLkbpPi8KL4L+NDBDnUlw5s+Q2+z18QiO0Kpw8OZw7E7fcYc3JRb4wM/k6zajehiipbRWdaO512Q8nR1YS34eqZ3yc334lowS5/3nmfsYvHMNqmsJBEMTjOqoYX4gqyfNi7sx45Xgm+1sVmpL9zWU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 2:51=E2=80=AFPM Joanne Koong <joannelkoong@gmail.com=
> wrote:
>
> zswap_shrinker_count() scales the number of freeable entries on a
> memcg's zswap LRU by the memcg's compression ratio. That compression
> ratio is computed from the memcg's MEMCG_ZSWAP_B and MEMCG_ZSWAPPED
> stats.
>
> However, for the root memcg, the zswap entries owned by the root memcg
> itself are never accounted for in the stats (obj_cgroup_charge_zswap()
> skips the root objcg, and before the root memcg had an objcg, its
> entries weren't charged at all). The stats only reflect the entries
> owned by the root memcg's descendants. When the root memcg's descendants
> have no zswap entries (eg when the whole workload runs in the root
> cgroup), the shrinker reports nothing to reclaim for the root memcg, and
> its zswap entries are never written back by the shrinker. When its
> descendants do have entries, the root memcg's entries are scaled by the
> descendants' compression ratio instead of a ratio that includes them.
>
> Fix this by using the zswap pool-wide counters for the root memcg
> instead. The zswap pool-wide counters cover every zswap entry, including
> those owned by the root memcg.
>
> This also gets rid of having to flush the root memcg's stats, which
> flushes every cgroup in the system.

I would have taken the patch just for the dropped flush ;)

>
> In a VM running a reclaim-heavy workload in the root cgroup with the
> zswap shrinker enabled, the shrinker wrote back no pages before this
> change (zswpwb stayed at 0) and 1016 pages with it.
>
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Signed-off-by: Joanne Koong <joannelkoong@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

Thanks!

