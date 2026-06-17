Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7764ACD98E4
	for <linux-mm@archiver.kernel.org>; Wed, 17 Jun 2026 12:27:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 708E66B009F; Wed, 17 Jun 2026 08:27:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E15A6B00A0; Wed, 17 Jun 2026 08:27:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F6676B00A1; Wed, 17 Jun 2026 08:27:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 23E936B009F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 08:27:12 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8F7158D89F
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:27:11 +0000 (UTC)
X-FDA: 84889329462.17.64923B3
Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	by imf17.hostedemail.com (Postfix) with ESMTP id 760B340012
	for <linux-mm@kvack.org>; Wed, 17 Jun 2026 12:27:09 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="L8/nEkLK";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781699229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fIkFLHlBYwD2iiV0FJSSocLP/zlZq6rIN3ROwVp13XE=;
	b=XiMy/fJfXlSDhGxng7cKPCZkhoz+IZ54u0mhbqKXJlBszNL6P0fe9aQpf6M8gA0GB4VD5f
	JZqMQxaVK4J/zI67QFcJnQwnzBiy6rlj1owh7YZ/jzjbniPBjLIugTqdkBBfqeTlXtluN0
	+8W9cdtYD/rVtEeSYkLl/dtxUcJW3b4=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b="L8/nEkLK";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (imf17.hostedemail.com: domain of mkoutny@suse.com designates 209.85.128.44 as permitted sender) smtp.mailfrom=mkoutny@suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781699229;
	b=H9v5D/4ROX9b9CPgN3lL6WYROcjbvt6mggmbkiXCEBu/1vvKvnaM8CWNDFyx5Yz2NPg8n+
	Nf1SY0+BNR3F0S7h/nqtWgBKnCjPzMv6SsRFmz1KXbyEPYLyESj32kZL1gHnkCmioh2G5l
	sXfI4m1u7tLHavI+2M4QjWLI7OmtXss=
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490bb83a3f6so44466055e9.0
        for <linux-mm@kvack.org>; Wed, 17 Jun 2026 05:27:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781699228; x=1782304028; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=fIkFLHlBYwD2iiV0FJSSocLP/zlZq6rIN3ROwVp13XE=;
        b=L8/nEkLKPvZxU/eNxTBg909SFMDaWJK8WPSzaPFR4Tzm2eJJVEyz40PmBaz6gdoPwm
         UoVndI6+s7lePdptIibNBZ9vRzcMqeUrJOaFblfVQkaDaCwJ1Dzg4ADAa29rdj0eOiZR
         XFJ5+7HQds3RWvQ7syHGIVuKgnBQhtwVyYn0d7j/GQUY+DusE/OsbBheGS19hoky+Aut
         J3HaVGImnj+OEOVJmUb1KhhPvFZ4M/kWICYJgEM+ysFpgmQBDc5aM+S4RfR0jboG7Bqj
         u6V0SSZ/bILXbBNTcoToN61ynvtaH4mHjywuOTogPiAtwxw3EhV+/WdA4LRpgQI4T5MY
         wUng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781699228; x=1782304028;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fIkFLHlBYwD2iiV0FJSSocLP/zlZq6rIN3ROwVp13XE=;
        b=Sld/c8SwntzYQcs47GpxJp4ap0O9oG2nhvPFTOLbTELQSvLDYytbBKms6fA6lLX5oN
         YK/YOLel5ZUbr6F3Fe6oKF9sLI+hh3Md971N6O6LIOrP7lhA2OheVVRChMk6J3m3z69B
         iXMPwVwzUvv1Hbw6tpZ+UXoMe6Ekja6jYM4bBN/L30wdQxLDfRUw+hGY44GORlVvxItC
         f1zzkGCxFVtAKtbqzk/o5rAuuV5wA5J0nue2NxYelITWXZjlWDga6mRsAFnBeWg7xAJD
         N/Dw1y5szRWtxBu98t5GLZAjy1TFcVJ6KU5cOnOjM4U5bSRiGjHmv8h6OC/bvq84YBTz
         EOqw==
X-Forwarded-Encrypted: i=1; AFNElJ9PfXKgVEiniLZg5k0QdM7gVy0gC41H166/kc841aoJ86K5MDmlwMPtMivtdjyYdwA8BFKrEtu8pQ==@kvack.org
X-Gm-Message-State: AOJu0Ywa0i4Kip+E8aJdxD87y923IWTLql6Nl1IqSb0XXrODd1bR7kIk
	HgSVKIA5IW3fi97Dgyb/xYftL4bZlz423iuu720q/8f6BZeFvwvwgAHPduVf0wujGwY=
X-Gm-Gg: Acq92OHP1NVIEnfgY7g8gpQEvxq/5riWl8FW8iYT9qDAx7WsuECYC8xA0lDEhLdg3bZ
	EluuMzzSwpKMIv2EcnYboX9JZS5Zf4er7/P2UEwFrfrNOoNaPFfhzOKG//lw7WeIxi52yBE7NhE
	8ZUnIN9vDNDUkZTvfXlx+6eZsMdtpqrCGESEw970suonImDCi6+NgTtSe2d+5bLq8wK+FmTbkCM
	jnoTTn5u1CNg/1ZgQoHIjF0HA/sxHKTEYX6EuV89FSSbREtMdkfzL4y0luEescVPbO/coO9Hr0N
	f2bJnlDCyzvygjfm9j2evUxd02UY57LoP/l6ZRhgnobJcv7YfC7EaGy5PtXunRN0sxfgj/SA6bl
	AHcO36rsNSefaonD+M8nJwfRiCkevNLgsjyhkG2+QSd3mn2l2afSCdFKHm2ZNWVurgEJVKSJchC
	RmNjrR6+IYNvtlgtfIOg==
X-Received: by 2002:a05:600c:a30c:b0:490:be1e:6ce6 with SMTP id 5b1f17b1804b1-492333aead6mr55511115e9.9.1781699227889;
        Wed, 17 Jun 2026 05:27:07 -0700 (PDT)
Received: from localhost.localdomain ([62.77.90.70])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49230a9b45bsm130662975e9.15.2026.06.17.05.27.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Jun 2026 05:27:07 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:27:05 +0200
From: Michal =?utf-8?Q?Koutn=C3=BD?= <mkoutny@suse.com>
To: Li Wang <li.wang@linux.dev>
Cc: akpm@linux-foundation.org, tj@kernel.org, longman@redhat.com, 
	roman.gushchin@linux.dev, hannes@cmpxchg.org, yosry@kernel.org, jiayuan.chen@linux.dev, 
	nphamcs@gmail.com, chengming.zhou@linux.dev, shuah@kernel.org, linux-mm@kvack.org, 
	cgroups@vger.kernel.org, linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Michal Hocko <mhocko@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosryahmed@google.com>
Subject: Re: [PATCH v7 6/8] selftest/cgroup: fix zswap
 test_no_invasive_cgroup_shrink on large pagesize system
Message-ID: <ajKFzxIlwUd79pJY@localhost.localdomain>
References: <20260424040059.12940-1-li.wang@linux.dev>
 <20260424040059.12940-7-li.wang@linux.dev>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
	protocol="application/pgp-signature"; boundary="npkgor3mtzc7eyn7"
Content-Disposition: inline
In-Reply-To: <20260424040059.12940-7-li.wang@linux.dev>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 760B340012
X-Stat-Signature: bnoym4d1t7nzspjo5ixia7tyfnedafw9
X-HE-Tag: 1781699229-134115
X-HE-Meta: U2FsdGVkX18Mhw2l+9cv8NZ+pSxdXiNO4wikNdCMuoMM9KiuWorqca4+g8peErfIpBXPrsw+TDpxtEWLpnBAbdzAupj2itZMfp0DQcpfRD9kLUBCtnkHy7StmFo72DiuWp9cu25C4VUXG8SUH4lm8vkVkXfCGxFNUW27hd+4n1T1w3F/SpE6OptXwYmhFsBlY7XN3sDKK2CItLQq1vKbueejenK+dwewWDLpHPFNFDvTLcQFk/ydMUbLf+H6TIchI0HYCX2lcSa7bmSxdfFVPiSl38QwnPpEE9U8c19RTe4nmS8gjvb8/r+MGQiQpWjIoy3UCbvOxsRvLrcm8/Wiu10cx2RMsuwOyV0hC7cb4/sJ3qSF/Zf2Wt5LHDCr7jGwoX2VVjQrleZt0SXVbDSn5rgMpH6miIIZST+GnwcNzwJ43Hhl0CN+uTuRicX/URNI7E35eCmI1w7y9ms8nDyUZOG2Zqu/qehwkRuq90RTd0gg1xeXdWcP4AxW299hfvFKmQ5pMZISiFvmyy4TtiNlR2mIrHrIbbolMK62twJTz7RwMqrZhjIk1KN9k9jFeSrLLtMhGqtWODUDVsBK20C9pTCq2vBCvoWuDVUvpcjXVMfGYfQzzbmr6o2wQXXnfFCNxif2UF4QRwCmYGM4O8LDK254FOr95nLtkjdlEtewWt13h31PAcmTzHhliol+ONbRO1Yt5nK1p+jZADnq9dF/1mC+td7ggNAI2DQ6dLMc7mXm26pT5rbEgKd8YgGCKOMzlylK2EeJKuL7in9WEB12IgcdNvPRTx8q0zzzQv7zNJV7h3U5xo4YtI9TjSGQ0oz2EaQ2uBr0W9HtPBW40f75ve6O3ySHGGx7m7BBvND0SgBhk+wte5OmySn64IXO8tAmyOOQlFkZ4jmA1v+AG0uqcxSSVkLBA17TNAZwMzrLZgMwu6xKRt8L2Hb+DTBIfOk7KKuJwj3o4h2ERlUAyqy
 VQcZGFwq
 +zwygVscjER9wc5yCaXN4NhHkFegMtRiVdKoXQ//XYKPyMHT6C3YppBVFG5uHUkUKP4q8c4iymRv574BbjDBTMh4gJy8oHSjlU66yHsglvgTXHUQxO5SbHCRf+BO7b84Mbu1oVmoc25jSv4nuT6dJo2rWnQ+TD/k8TZvbQTv+7DWckKjsWOOX1MnKbtUgwYIM0s44gy8ramzFN1hIsHpkVbDYNb+h8dofTSsenLIUBGziMRro4/T18WsTkM+fOJxKv5RfonL+I9o62fyq2/sRxo/yb8ABrP0XtEKEutD55LlZ3nB4p+h89SJy6mOIErTFytMxCe+CgaRbyPVfEgfNYKevRcX0cCKFA8bHiL7WZJS12OPqsJHjRK5UN9CLdDRkLrz7pmufYv+bah+2W83bBKyHaIjZJ+x5jSTSQfSwrSnFg32oPH+g/btdgWGQJ6GTeVL0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


--npkgor3mtzc7eyn7
Content-Type: text/plain; protected-headers=v1; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v7 6/8] selftest/cgroup: fix zswap
 test_no_invasive_cgroup_shrink on large pagesize system
MIME-Version: 1.0

On Fri, Apr 24, 2026 at 12:00:57PM +0800, Li Wang <li.wang@linux.dev> wrote:
> test_no_invasive_cgroup_shrink sets up two cgroups: wb_group, which is
> expected to trigger zswap writeback, and a control group (renamed to
> zw_group),

Aha, it should stand for zswap writeback? Then zwb_group to avoid (my)
confusion with zsw_group :-)

Although the original names were already well descriptive (both groups
are expected to have some zswap).

> which should only have pages sitting in zswap without any
> writeback.
>=20
> There are two problems with the current test:
>=20
> 1) The data patterns are reversed. wb_group uses allocate_bytes(), which
>    writes only a single byte per page =E2=80=94 trivially compressible,
>    especially by zstd =E2=80=94 so compressed pages fit within zswap.max =
and
>    writeback is never triggered. Meanwhile, the control group uses
>    getrandom() to produce hard-to-compress data, but it is the group
>    that does *not* need writeback.
>=20
> 2) The test uses fixed sizes (10K zswap.max, 10MB allocation) that are
>    too small on systems with large PAGE_SIZE (e.g. 64K), failing to
>    build enough memory pressure to trigger writeback reliably.
>=20
> Fix both issues by:
>   - Swapping the data patterns: fill wb_group pages with partially
>     random data (getrandom for page_size/4 bytes) to resist compression
>     and trigger writeback, and fill zw_group pages with simple repeated
>     data to stay compressed in zswap.

I'd have expected that having both equal (i.e. both random to fill up
more easily) is what tests the effect zswap.max upon writeback most
precisely.

>   - Making all size parameters PAGE_SIZE-aware: set allocation size to
>     PAGE_SIZE * 1024, memory.zswap.max to PAGE_SIZE, and memory.max to
>     allocation_size / 2 for both cgroups.

Makes sense.

>   - Allocating memory inline instead of via cg_run() so the pages
>     remain resident throughout the test.

What is the residency good for? (It doesn't matter AFAICS, so the change
seems gratuitous and code diverges from test_zswap_usage().)


--npkgor3mtzc7eyn7
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iJEEABYKADkWIQRCE24Fn/AcRjnLivR+PQLnlNv4CAUCajKSlRsUgAAAAAAEAA5t
YW51MiwyLjUrMS4xMiwyLDIACgkQfj0C55Tb+AjrLAD9GBYJlDuakfCppd9zM7AV
pVNB8ypWNBY5Zblvu5XqtjwBAP+ZAbviWaThkRKtDNFKUvOG/ItMxC0RjON1YZma
WNkB
=KrLy
-----END PGP SIGNATURE-----

--npkgor3mtzc7eyn7--

