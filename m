Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EAF0BC624A4
	for <linux-mm@archiver.kernel.org>; Mon, 31 Aug 2026 15:29:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E201D6B008C; Mon, 31 Aug 2026 11:29:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD1766B0092; Mon, 31 Aug 2026 11:29:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D0D8C6B0095; Mon, 31 Aug 2026 11:29:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AE89D6B008C
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 11:29:04 -0400 (EDT)
Received: from smtpin18.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 3C81814017E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:29:04 +0000 (UTC)
X-FDA: 85161947808.18.6DB37B8
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id 62D0840002
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:29:02 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZr5obj7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788190142;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AOPkpmlru9z/R5HME2uR2o9uvHSAkwTBymd5hIWm4vw=;
	b=l7TSNnGGLaXCTu+VwpT4NCfa5NOH+ykJrqj2A84SxZR+DRTRFvEH7CfEiM8Lj3BaoxwN6Q
	Jd50KPvvNF3eiebUssDQlo2r6lrBEcepsB3Dbnu938e1Ve8hDOJDI0SaYR9TGfia8MM/NF
	BSVOAFo9SbMotokXM/QExPURxgfSRP0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788190142;
	b=kpRjBG5yuOBH368ArgS4CG6XQkWXT/ViUheqxi+kDEcbm7MLCbPPVWnPfIAebq0UbFsMgs
	Y1MI7r/1FQ+B+CCOx04DtFIb9CJSv0Ce6hQMVWh6be64aYR+l+nlLjDaiOK2tbmpa1wisy
	roARSF5LRt3ahmTKyY80WEB8agt5y5I=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=PZr5obj7;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf11.hostedemail.com: domain of yosry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=yosry@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D748560210
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:29:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 901211F00A3E
	for <linux-mm@kvack.org>; Mon, 31 Aug 2026 15:29:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788190141;
	bh=AOPkpmlru9z/R5HME2uR2o9uvHSAkwTBymd5hIWm4vw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=PZr5obj74iI2yRG1erlOg0ixBUSXQ5+W/goLH+PNWarpYQYt/4eKssQjEW5cnCSnR
	 uDT76lIzIDeHYJzM4qV+gkZ1nvMayWm53Z9X9Vmu+I4eqJmq/rUr4t8IQgeLdO+m28
	 0LvFCFmB3m6j2s+k08hdLDkXe7G0PBTnvUQDa3jb10P7lM/myGRKo+t3lQoWUCd620
	 0XaSsV+YxMVMvZeETfUZHcwEeT9IKFExi0P/u70Jdwp964XT5Rdt26YLWF7GHq4Qx5
	 P1lW99I8rByAEqlu5u5um4rVZw8vhCEZZnCDgecEdgtzIDRBTwP2xqiqR/VTpjDBhz
	 1q9h3CK8GQB1g==
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c2533d83e3bso600644666b.2
        for <linux-mm@kvack.org>; Mon, 31 Aug 2026 08:29:01 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqqIv1zXmU9FrC92qiQ+V1GHu276LSLkzaEGQM45LhwwWGmZS20ofBvpm3AHh8uohI+BQxAQDPeMw==@kvack.org
X-Gm-Message-State: AFuF++kMB+nFRHRZX2U3I5ma/BWD1lBoRzCcSlPY8BEM5dLWaov8oRga
	zpzLwj9Iti/2orLsHBKHh7OPAMf6In9K9xwLzMtluMfe3l2NYwfwfnJg2rZRgYhcrNMbE3PFC3E
	6nlo6CaeMwLHaEtlJJlzxwK0mLsiPM9k=
X-Received: by 2002:a17:907:3c93:b0:c25:30ec:bec3 with SMTP id
 a640c23a62f3a-c25b3be4d0emr99362366b.8.1788190140473; Mon, 31 Aug 2026
 08:29:00 -0700 (PDT)
MIME-Version: 1.0
References: <20260830114731.8322-1-wujianyue000@gmail.com> <20260830114731.8322-3-wujianyue000@gmail.com>
In-Reply-To: <20260830114731.8322-3-wujianyue000@gmail.com>
From: Yosry Ahmed <yosry@kernel.org>
Date: Mon, 31 Aug 2026 08:28:48 -0700
X-Gmail-Original-Message-ID: <CAO9r8zO2=jFCWi1sOnG6-7BHpipaOk39BvidOhgc9teU4=An4g@mail.gmail.com>
X-Gm-Features: AcwNN1WiqXZX0xUWfhOyFt6aWO50yX4NiX5jnep3OaZPKrV3GzShT5JH5NZ16os
Message-ID: <CAO9r8zO2=jFCWi1sOnG6-7BHpipaOk39BvidOhgc9teU4=An4g@mail.gmail.com>
Subject: Re: [RFC PATCH v4 2/3] mm/zswap: replace the zswap_pools list with a
 fixed pools array
To: Jianyue Wu <wujianyue000@gmail.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 62D0840002
X-Stat-Signature: mswhfoezskp7rnpc1skppt6cq1n5w764
X-Rspam-User: 
X-HE-Tag: 1788190142-376102
X-HE-Meta: U2FsdGVkX19kZO6c2Pj+T0RpG07eKkY1K8NCnnkLQdVGj/wXhQKbwHtOrYtIefZgM/XUpTNWzOaaSw2nSILWY+WP+Qrn0RT+RP/jv3RcSrVPT6BxWUJdXpt/wefDTzor61MTw9f1L2ZZjEwFSf5meXYk8/5EC8ZPNuA5o9UFsb4AS4jiWouQZKDItHBjh/D8vjGDBswTM3aZEF/UYLOby2MIP1yY+arycsEqBNXU7jYosbKGqwCbeLiQ3s8zAbAjvkOuZTZym2LsCJQOoxaYH3ueuhjZBCDCpJWRJtUb3ND7tjWQXStCj20dCOhqe7SAXJT+0wjCTaNZX7joaCRj176HWu1YlvIxinBlsLtDp8DfDnx4CldcpyfIw2nw9Zz5ul+hsv8LEhANAgFRofE0z8MA1UL9xZCdGkjImcAdAT4zm0cROUPYPZwX/0WU7KaaMS3H6vmDTXpzJlpfgvFSgkXvl9XpMex3GgwoZSWfxb61Yix3msWVPkKQMqKISvGbp9bdzdYvPMRjnwBdtcKdRnyOyIA64oWML100jjMOgs23+auQqoaJPewIILoCMSydR5zY/qO57tiw4yk71ufPf02Pbv4OdRZNyqiK++JhSpmVBAfVI2Mz5Gx7MLVWJc0Mz8PfdvgDeVpkmcC73w2JKE8X1NYQPKNMTVHOXL0FqpgL3D79zfkmE+BX1e2SCLldpkMVAKRiR66bm3Qats6DPkK3rsOS5q/WrPIpr1kQK6GoKEWZ+z0Iwer4zhGqUg8v43muvvdZbPJp/jA5GEh2CedqNl5Rsj7ya6HH69fJanvoPcEaYtb4RUisGwRYTZrGAcm/lV2LVnZnQ++Qm7Gn+dapVxOvzTbZyrmu6/nS5nWk+sRbdxZcONG7BTP4dAyPuOzni/adUtm5eOXsHuDUyYaDzhqcSIL+bi6FUDTcgSRnXL3klyU4LEu++ooBoBREJwTp/nxuQyj4KGQuOI9
 jJjYgsWp
 XambdX5eRv3aY8PJk/aG7somj4c54S9on2lykPaVe1r/tuupKfKNAjSFpXEiggCS4ROuRtTQBJuIUdqgKR4P/BXxyaU1B/iD57Iduh7sYZKPCvrw2T0H2uQal8HM/kITNkpwBziMNLi4Teks7dGtAg8ZHE1R8IT8zD0mTEjCXMSQ4gvDz5Udw/Rk2BOA3Bwpo8brdUu7i6Hq7yJfi6QuDEbTQLxPXEKlY0bC69Cd6fkTWdIA66RnKrZlV8L4WlpsUDNzmPC90WG23mfV5fWT5Lw8tGYwm3D4G8VaYTwJJSxPQdTtmsWIPQ47aXV/hKKi6zAJx8FmSI9aZxlBvi3zLkECJbGST5p+5ne+N7SIIY8tMFort4bPFCWGM4g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Aug 30, 2026 at 4:47=E2=80=AFAM Jianyue Wu <wujianyue000@gmail.com>=
 wrote:
>
> Originally zswap holds its pools on an RCU list whose head also serves
> as the "current pool". Only a handful of pools are ever live at once,
> since a new pool is only created when the compressor is (re)set and
> pools are reused across compressor switches.
>
> Hold the pools in a fixed ZSWAP_MAX_POOLS-element array so each pool
> has a stable slot number, and track the current pool with a separate
> rcu-protected pointer.
>
> Slot 0 is intentionally left unused (always NULL): a zeroed or
> incorrectly initialized pool index then resolves to NULL and trips a
> WARN rather than silently aliasing a live pool in another slot.
>
> The array keeps the same RCU publish/retire discipline the list had,
> so lookup and teardown stay equivalent. A fully-constructed pool is
> stored into its slot as the last step of zswap_pool_create(), so array
> walkers only ever observe a NULL slot or a ready pool. Pool creation
> is serialized by the module-wide kernel param mutex (all built-in
> params share one lock) and otherwise only happens during
> single-threaded init, so no two creators race for a slot.
> zswap_pools_lock still serializes the store against a retiring pool
> clearing its slot in __zswap_pool_empty().
>
> Behavior change: the fixed array bounds the number of simultaneously
> live pools at ZSWAP_MAX_POOLS - 1 (15, since slot 0 is reserved),
> whereas the old list was unbounded. A pool is only live while it is
> the current pool or still has stored pages referencing it, and pools
> are reused across compressor switches, so 15 is far more than any real
> configuration needs. Once all slots are occupied, creating a pool for
> a 16th distinct compressor fails: zswap_pool_create() errors and
> returns NULL, and the compressor switch is rejected with -EINVAL
> rather than silently succeeding. The cap can be raised by increasing
> ZSWAP_MAX_POOLS (bounded by the u8 slot index, so up to 256).
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Yosry Ahmed <yosry@kernel.org>
> Signed-off-by: Jianyue Wu <wujianyue000@gmail.com>

Acked-by: Yosry Ahmed <yosry@kernel.org>

