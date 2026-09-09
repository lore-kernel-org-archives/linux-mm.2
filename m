Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E7F7C79FB6
	for <linux-mm@archiver.kernel.org>; Wed,  9 Sep 2026 14:56:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C0406B009B; Wed,  9 Sep 2026 10:56:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 997CC6B009E; Wed,  9 Sep 2026 10:56:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B0966B009F; Wed,  9 Sep 2026 10:56:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 575436B009B
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 10:56:27 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DCE0E160242
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:56:26 +0000 (UTC)
X-FDA: 85194524772.24.F5D16DE
Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	by imf02.hostedemail.com (Postfix) with ESMTP id 0393180007
	for <linux-mm@kvack.org>; Wed,  9 Sep 2026 14:56:24 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d+gRKHyr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788965785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=/EzsJ2XbIJCRg08piphlkM3GNGt42SpypDAM2KpYbBo=;
	b=hs7vDw5n52PvA5aAqBY6T6woOJnazU8pD0wEt131uM7eN57A8rtj07LrNI3X6e1pnmEqak
	BZedZrDGPmsBGIgBXSMx52hv5Yxb6fT2sKmYuUCrMtsbsclWI9lP21twMkCufwLtTnYz6T
	YER8rJ/XSxWKXDPk2qmduPbvnkFvylU=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=d+gRKHyr;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.140 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788965785;
	b=Tqa+EMo05a5BsdeFS3wbbDaqltK4Sv4HmBr1FyFMYGblKYgjfb+CDThUsD3GMB6spoCtDb
	CBERcHZffYjgMPajoJ3ZGkXm7MxPePS/xS18ydtRgfui9KfI5MxVutaUrGiQBqsS2hBPOr
	GnrRk/736YsbzKX4tHY7K0DRb/PexRI=
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49cd6185db7so13766975e9.1
        for <linux-mm@kvack.org>; Wed, 09 Sep 2026 07:56:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788965784; cv=none;
        d=google.com; s=arc-20260327;
        b=nua7SomrxPECE8qFItxhqH0y3arsc96aNf68BWe4spZVMu7SV6pQLmE0qfGwrRSTvS
         sYI4KizcftMWGcf41EwPVmsohfyzYtoCp4N353dk7Kv4qVVuChzRFTcju8gfdIXszDfu
         eTJZrVHsfmO5fBx5GmwCjE0Peadf6fdfgwrxX+NoyEmFvaGFW9b7IOyT1n7jXiCwPB0n
         Mdce+2x9OH8Pt2UfF4RGbY4OepbtShMFcic5ysp0HcHrrpMeNp/LueTRyWvjhA6g7rtS
         19SLEUhyBlFUkFmFvIXniketxRGAsW70QnHrCGV/LQFsgMcQ2D43pPd1ZWEdop3KVZ/2
         hifA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/EzsJ2XbIJCRg08piphlkM3GNGt42SpypDAM2KpYbBo=;
        fh=G91UfuH0EpQz8lXX6FUq9yiu5XbYGpM51h09zCcZzFE=;
        b=lynGMOu5aMkH2q1s/kCMCkagEfZn/tUZ0ZE6n34GEO1FSHj8VFO4+hj/mH+bbMOPID
         vON6s1NAfUF0NbA9nI5KZUtKVje6kgxOxMIT664nqjRLUTF5GbsrEPUrXrqFSEhrnrcm
         zBpvAwS4js/45dwM5zkIn9KQphGKXDy/FnF0U9cUK2FOPjQzuEGSncTHfp1pxp74WPPw
         fmsU+geq1ReDpS6VcdzytscPMsPnyB0mO3Wgr9FWCuHvdG52/G+q19O+DN1CjRJ2n1Hj
         MaBIKHyKWhLdcK2ejU+C/LBwNc0gD6eukgZOnZ4fl8eRKqcrG0MUZRW0R8zTKf0h1XdB
         OmEg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788965784; x=1789570584; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/EzsJ2XbIJCRg08piphlkM3GNGt42SpypDAM2KpYbBo=;
        b=d+gRKHyrKwIYdr7tClfh4i5jVUnnhqRlkK6mg4E3lCh4JcLApJM2LbIEpGM0dCEPbM
         syJPs7EA7d3mRsm6mdOHjG6YZzLHT20t0nBJVP7i+rbvM08hST+5V5pHgzsCgRcWo7am
         gO4+n0TZFk80qH3cyo80TPUOE6UYxVfoZhnzkZntptvKR0ZbVgMrugliyG5sGPZHN9wD
         Hbg7l8a4VLJwA0AnWtUuG0wXBi4TN4k1crJYE96Z3aKRswREMSwYs3Kk23WMZEIPiAQG
         SAhdh7Vf5EKw7DvcKhtSSaVv5CYtOUiEeUhJwmbCrtfEp03nHFAZBKs/I4mQPmgNVpEG
         r2DQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788965784; x=1789570584;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/EzsJ2XbIJCRg08piphlkM3GNGt42SpypDAM2KpYbBo=;
        b=dVmhOqvGqKo11mgxGeKve0UVGpz9qJXCN/e1hubN2Fn/2TknZfpIY0H4W+B8jrXlhX
         8ABwvg8PrpW8ONb6/n+o7ee+xIwOtM4UKhYqVFONyWWhvCZtOadMw9bNhCZSkxCVSNcU
         DA2zHDlH3iAPlJ9sh55Zb/jLb/ELXPBTlHEzvDOzE492e/CVBMIF6/XyTpbsUuql11eW
         S4RybXWCDGmmFSZmB7LDynTJ8BqG2z72tILo7LAPifI8ruOVqnlphh0rPmr2oK+WJavv
         DxNg0PLRM6BRa5iWTRoXjZoHF+exGUbrwo0jhajy8CfP+2aj9WoDVm/mRRRXHJzLNmVK
         7pgg==
X-Forwarded-Encrypted: i=1; AKwUvByz6rOK32nJWysjsTVRgyBpbuHoOKf9T/EsJc7pDpl9Eia3rOEl/rCG6cHxRo9DzI8O9/S+bDYm9A==@kvack.org
X-Gm-Message-State: AFuF++li2cl/Y4QunqTzEjcsw7S6qnCE4epCrTmPi2f7UihpIc71Sa5/
	zRAFZUsirAoZpFip6DQg6vYu8SFbrEVz2O4sBgHYyVcrot7X7QYhzf1qGboCI/rA2+TxXtD+A3m
	Hy/qN6W9zdmhobXWVPWDaESxSNyfq7gs=
X-Gm-Gg: AYBFou0OrR3aW0un0djGrXuQhBaM7g3GdJel5lDD1We4CzfIhuMo81E9FIJx5aISTXe
	YEBfKcvwgvj3SPg5GHb4vfE/Q62bwDlkT3Z+oXv2/HDE1or5NTmJkAOa6cC1DpTBfyp6fX5/yb1
	rm4Tncmoie+SX04ACBvJzWtPM4jiNuuR3A2Q2k2/8DrT7/lA1TODU7t9oKtrm+xmnnMFPFsYnHk
	4iYtuxkZvBDOGnDJQ907vUTNnIM9Wj2KkLK+IPvMc5aCcniQAzCC3MH76ON74QjsKD6hNL8GiEe
	LNgxo6wVmiY1o1yn1LY3vSaL5Sf/O2Ak37txkwLoBxNIjfxoTF54HyB2SDxD3z+FwI7cj5uWT3M
	Q+ee4n2S4M3MqXiTcKwQ2rg==
X-Received: by 2002:a05:600c:4752:b0:499:59fd:dbfc with SMTP id
 5b1f17b1804b1-49d175439dbmr143483155e9.1.1788965783309; Wed, 09 Sep 2026
 07:56:23 -0700 (PDT)
MIME-Version: 1.0
References: <20260904033503.4067283-1-qinyuntan@linux.alibaba.com> <20260904033503.4067283-3-qinyuntan@linux.alibaba.com>
In-Reply-To: <20260904033503.4067283-3-qinyuntan@linux.alibaba.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 9 Sep 2026 07:56:12 -0700
X-Gm-Features: AcwNN1XRJdmkw63mXOMob49BAlRwZ-fncp2bctcYyRkWfOoIpHMzKSC7_xtXJwE
Message-ID: <CAKEwX=Mim0apjf9qkFPABWz88juQ2Wc+6hY9RAXdBevq45FBmA@mail.gmail.com>
Subject: Re: [PATCH 2/2] mm: zswap: mark the zswap shrinker SHRINKER_NONSLAB
To: Qinyun Tan <qinyuntan@linux.alibaba.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R . Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry@kernel.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	Kairui Song <kasong@tencent.com>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Xunlei Pang <xlpang@linux.alibaba.com>, linux-mm@kvack.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: 5jj4rin4yx6wdm1i1xxn3suc1e5booe1
X-Rspamd-Queue-Id: 0393180007
X-Rspamd-Server: rspam07
X-HE-Tag: 1788965784-752961
X-HE-Meta: U2FsdGVkX18MMCzBK+N7sSKfmMU8HvUSHTg30dAgvyeCxnfCWCR9hMBO5APxfLAzF50Kkd34m8RBXoCv4HVoAidbu0GJ25s3iCwSv8BV0mZWthnb+V6RhzIQlYbeOaDICBGmVeuAYsSAGx5f8kNrT5Xh+IIbxzKH0rdeLYujPuBJbtijC4yy1ylVehGnHS9EaQFPt/+dBA/4c7sa5NaIeq8I3041iB15moPszOkPkRyk94CpIrMZXCjzQnnQHL9Vcb+4vw9ixksm3OdL54CGMlm+z78R2OvSht3S9QupPkAWHZm90TDgq/jF6BrJ+vkx0l6CRODTVy3Qq946pelArCAukbHjlz4heHjcHaLUPIomE5Uru9Q5VRVT/BRKk2FQY/TbywQyZkZYnUFcKTFt47Nyj0b/pI6IerxD8UVw3WseKZsQRHVVlhC5ecpnGBopS4DRRxWhrCRMrLgkohJcf82Hl7Thv1dvhiy3DbWVpjJj1S0vx9SsrLnH4P7x83JYX21gY+Z0WKZH8m+HNdNsDcO641TYqDwTDz204GAGlEZjO73ISjsAgXoLKj8ZpcZ6KgcAzgf92K2sOABXaQDYQvSOQGqe8wnAVgM+EULOv61Y/Rp+ZP6VoIafHxo+N9NL0dHq0815my+TkAe+VEL/PJqiTsZRfheImEjV8yPQZQYCg7rtNiy6xizZenRY2nxG4d1FpJiMdnPbRHG4S7SbgeM0bqmBc8G8qu0UOyd1qXyUnAbaSt96gSMZFgMedcDXSnY9hgQGN4c9ov34odC51XAKqKZhT4fz8HZprWAl7sF1nPvvRB+B6amciRYPQqN+tQEfkSqNW0TdKYIJYSmp772DF+ra3FRMkN55X5qW3FtBMXbln+pDF/UH2CQieqZId20YfpNEsQpYC+86xGWAyaC3NqSx4iVjTSA/z4vHT5lHcjQeIrM1NV7ff9GzsT5bDy5akx/xlfjT5hlRZhu
 nkUIyv1u
 gEhSuTask5PrIdPIUT8mWBfejfKdR0qTl1BYswd2kVRfNTCijMIzMRdaVIVq45wlO537wDj79Zl/OmZgQRzDocJMATxCQK6LClPnyDMpeAv1iHOpOBmbFKoyVIZySmP3qzkHOf+6tGQlvJWlPP8uTt6EgBcxgCSiqMUbretkwP0JtCyKzrzokNMgHjO3tqvGV85qnJYRH/ftlPkKQ6bh9sf8zkvOnKXEX6kA7arExYo/VUDz7cPpFTrE3ZFt1e5Qpr7JfRrDnzHvjx38Y2issqUvhK9nr3QovM5EiiWtbucN/w7TWJbXOqj+3m5jfbMK1GgCE4P4l8syDf1C0OsZQ8csWDGHaKvRgaWrgOSVdzETWaQwCWa/zw1LwipVOfefwdSRiX1gELp27ewOhzgbNW4jE5yiwAtNvyHCJBkCWFhlUNlTbLwK5IjQWiYAadC01G+kocKFax7dOWppUMX3j2NlVKh7f0ik8gK7HTq9vK+x01Y549uYhzwZNSb9M0+C4OaKiAFpAdy/IInuYcRbgk1FF1Cu3f3A3UTVygrwBy6tZ4JNiIegxOeHyEUfaHKweEU3W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 3, 2026 at 8:35=E2=80=AFPM Qinyun Tan <qinyuntan@linux.alibaba.=
com> wrote:
>
> With kmem accounting disabled (cgroup.memory=3Dnokmem), memcg reclaim
> never invokes the zswap shrinker: a cgroup under memory pressure does
> not write back its own zswapped pages to make room; they are only
> written back by global reclaim or once the global pool limit kicks in.
>
> The zswap shrinker is registered memcg-aware but without
> SHRINKER_NONSLAB, so under nokmem it is treated as a slab shrinker:
> before commit 03375203e1da ("mm: do not allocate shrinker info with
> cgroup.memory=3Dnokmem") it was skipped by the !memcg_kmem_online()
> check in shrink_slab_memcg(); since that commit it is demoted to
> non-memcg-aware at registration.  But the zswap shrinker is not a slab
> shrinker: it tracks zswap entries and resolves the owning memcg from
> the folio's objcg, independent of kmem accounting.
>
> This was noticed by Michal during review of the patch "mm/list_lru:
> don't copy stale shrinker id from non-memcg-aware shrinkers" [1].
>
> Mark it SHRINKER_NONSLAB so it keeps its memcg awareness and runs
> under memcg reclaim with nokmem.
>
> [1] https://lore.kernel.org/lkml/697713c4-0857-485b-aba7-c74f37a3c8b4@lin=
ux.alibaba.com/
>
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")
> Suggested-by: Michal Koutn=C3=BD <mkoutny@suse.com>
> Signed-off-by: Qinyun Tan <qinyuntan@linux.alibaba.com>

Acked-by: Nhat Pham <nphamcs@gmail.com>

