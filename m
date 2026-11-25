Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F0CF3606A339
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 22:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=kxEWVfGf
Received: by kanga.kvack.org (Postfix)
	id D31346B0B29; Wed, 25 Nov 2026 17:57:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE2846B0B2B; Wed, 25 Nov 2026 17:57:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BD0226B0B2C; Wed, 25 Nov 2026 17:57:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8DA296B0B29
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 17:57:25 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id DF9B21C4916
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:57:24 +0000 (UTC)
X-FDA: 85475154408.08.42AF628
Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	by imf02.hostedemail.com (Postfix) with ESMTP id 022DA8000B
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 22:57:22 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kxEWVfGf;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of elkin@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=elkin@google.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795647443;
	b=p24MJ7G1LEvhKm7szbGdFy2SfMmnkxQocHag4bzdCnQimm+XP3W4SgfScKvX3g3pdWAGbp
	XEXGn9+Olx1FnuH7+X0QksMK3P2AtCw4oqOvCGEoey+qsMjp6UiYzaAE6fgpDWA0ZrOgMp
	DaXjk5c9ufd3GTJclz0S0XFFLxTH4Z8=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795647443;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=0OVfCBvpQu7+LPEH8zPzzFoXUbPUS8d7sUdmZNjwHnQ=;
	b=Av1b6xxc+t9YaR+czMNshiyJqO5kd37VBfZOC3oeh70Nwr+QUeIkc0gQYAmiIdjnvLRjLj
	1EoRNQPFgVmn65JA7fZUlFTZYP9cEcKWvyoaiuMnEZiCFB9gfpIkxonJVd1gFfDwyVUn2g
	Nm0wpcwH/yn5yE+ves9zyfVl5AJcviY=
ARC-Authentication-Results: i=2;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20260707 header.b=kxEWVfGf;
	dmarc=pass (policy=reject) header.from=google.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf02.hostedemail.com: domain of elkin@google.com designates 209.85.217.51 as permitted sender) smtp.mailfrom=elkin@google.com
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-7d2db1b9bf2so2183544137.2
        for <linux-mm@kvack.org>; Wed, 25 Nov 2026 14:57:22 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795647442; cv=none;
        d=google.com; s=arc-20260327;
        b=gxRHwq5Et1oGoSfG0Xf1oYzg0gl/Pj/Lmh7Wxw7jWWe5Iahfwfjn0JrBR3njd7y455
         i4SgZbS3GebPVvjBIRTfAd23XeMcFv+QCm6FfHruYZ6Uo6wfqlQD7FBk1yRprV+aBxap
         K8UsbOXh5tJN7toaRjzkR2kiZwR2y3SYKUYqMAL8dlF3V+OrnEJ9PVr26+Tx9vO+7IN8
         17c2wSGCXkZwEUQLvAnvp+SAEfQBJPey3b+IAauyjHPwXfaCJ8XzbigNr8kO0duLBrfS
         NUDz1KUKwqYGpcfyfFg3qqSj6AXGvcUhVLZIgSuuE11VHx/dryZ7nfw2AuLsz8J2E1Hl
         m2NQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=0OVfCBvpQu7+LPEH8zPzzFoXUbPUS8d7sUdmZNjwHnQ=;
        fh=ga6zqXgVue3O2gQWAkVJR8yOvb9zvGnKCvrnLX6+qbg=;
        b=Qhkm7rmR/jXnqVBHsxWTr4kMu6Kc+TMWdcK82RzEgcQ47WY0cQm6JhtLAeK2jNC3zW
         +3ecJhCJPSgYDX+oBYcG3UqnVZS4Af7nRpvhOVQVp57UvX4YLYskImEfLGHUQGWQpbtX
         bmyO99C+MurIiHNVaBHV2MSkTijMb287W9XKjP0MygdWfMHcuhrVtGwplY5MVWw/o8AF
         JsWBtC/sNf1r/vRtdKJ+rJx7ccEjUgRYsfwlBMRfINbt0HiwDGjghXzkT5dCSj6azyPl
         lVKWlfzPjv9xgyzyZrGiXF+YNtw3kZnpBDyFnUHU3z98DDtJ+RxbUafCmo/dyW3iKaOg
         G1pA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795647442; x=1796252242; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0OVfCBvpQu7+LPEH8zPzzFoXUbPUS8d7sUdmZNjwHnQ=;
        b=kxEWVfGfsFCNvtc+0VVLhz3OEQXQuYOqzRSRgvFzr+jtfuyyOXv0Nj7S/rbAD0G7rO
         2jNuug84yk0yA5WeyJi6XeyhX7TJaCWUgLWEcyEJTkY05JBlUoS8e6Q9lnZOyju+9Lqk
         PXXIVDqHSOkXUonZcMQFCIi1qESRwpVQXqK0g8CX2qJwn0wd5LzJ1WlXUXZneX7anbCH
         CTUMincScyjDpKyoOWO8UEuL3fom8AIXCdcZp2hsVIMe0d5k5DG+s4YFk77ZjjaBcsoX
         +gq5vNovs8AKuiAMxfNV1vJeu1RC4/pYaoq/I5OhtEhPhlc41zwHoBy7Fd4Nru7eYIWc
         /h2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795647442; x=1796252242;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0OVfCBvpQu7+LPEH8zPzzFoXUbPUS8d7sUdmZNjwHnQ=;
        b=JkcViJmF8+F7DzCafemJ2v7JfbSmGXynugEmxLCFurd2LR02ZPIZLGrXOBfVcGDFum
         3GFML0m3XEL3FCU8h+EtxxZ/27Ljtx55aU7X7DURtdo5FsCjlmsoqfo0bsRBHl/30diQ
         6UVDJVWEtQYkT/BfE/NLHz1ZgNUG55O3nqXuOnU0IMHnkyOOXwK+xU2sDZevK1CtTkPK
         2rp6Jl8PH1lUfc+N+L0ySKUxDuZjdFUtGCs1GbjUr5JbHKvdZ1QKSBEzjQduqHCARlZg
         0ozXUMyCqDjKgMY+MEYZF6vgzhBvWBc7mmp3YTM8fmsBNcbM/71ITQnqP3MigVk+JOQ0
         61uQ==
X-Forwarded-Encrypted: i=1; AL+hErEisY/CcvllN37Dt/202zDh9IPCiFe1A1EUjHXQV7owgnXFx84ZiLIWxsXX9+WFOgo/0YMbMh/iCQ==@kvack.org
X-Gm-Message-State: APuU4Z8olSdnz58XKYRB3UZAs4FAjvDAKtUKOoEtJBt/LjkwG6qWPO7s
	W9UyNwMpOa8KluYoTpHoLPSbilT3YtR2rVfhp67MqXNSf4N7ReqadwqLvfh95QCX2eRvxnp0eLI
	yxqtBcJmClzejNB+qGeaTQmw92eOLEqVr8L9XYNZt
X-Gm-Gg: AZFdTZfrV522kFBU2SqUORlo8KnsAGREnE+ntTB+IPbB7K6HEUvb12wyIrewnqpDQVq
	cpr1tINEOc6P9XQ9nHUOQv0CJjPjH/Y/NzLuMoA0aN1L9nfXINaVCzYbldB1Avk843GTZBL39JF
	y0tFf2KwO3+9612uGxN3DroxaN6VoHywTeSo1eyHt8K6gSbOk43ZMPR1Ag6f7rSBzQfnn8JXBOb
	vIlzt13fHnGTCei9AsNml4x/PMc7BoilsF2z1LI2AxdGm1MskNsNeqnrIe0lTJ18pUQHCcu6ZsX
	4ef5lY7f/Tn01G93w/lrOre1Xei39rxNIBYbj03d/AOKMNauD2OxTfg+dEhgv5OSfupEgbUEsFB
	F9wKqdccGGCewOJoFcqt7NpmQmFrhud954/UVf54ev8uYUrA61dc6AQWmQ9JV4goJi3Ne
X-Received: by 2002:a05:6102:3713:b0:7ce:645a:13a4 with SMTP id
 ada2fe7eead31-7d7395a933amr10370821137.20.1795647441313; Wed, 25 Nov 2026
 14:57:21 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261125221911.1425213-1-elkin@google.com> <6afabd96-1888-43d2-9ccb-73ca6702a004@kernel.org>
In-Reply-To: <6afabd96-1888-43d2-9ccb-73ca6702a004@kernel.org>
From: Elkin Cruz <elkin@google.com>
Date: Wed, 25 Nov 2026 14:57:09 -0800
X-Gm-Features: Aa3M54po9M19B4zck65Q5x7Gi_mcnDA_E4XC-TXXXd7r8mQrZUfrKezEY8XNZ0k
Message-ID: <CAC_6YktVNFdtDLsNHgPEy-8_2YfZ42mUsuXJ6OKkm=T7zFnxHg@mail.gmail.com>
Subject: Re: [PATCH] mm/huge_memory: check VMA end bounds in insert_pmd() and insert_pud()
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Andrew Morton <akpm@linux-foundation.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, llvm@lists.linux.dev, irogers@google.com, 
	stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User:
X-Stat-Signature: 7g6w6snhmusec4u4jxknrss817k8zizx
X-Rspamd-Queue-Id: 022DA8000B
X-Rspamd-Server: rspam10
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL
	autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1795647442-118484
X-HE-Meta: U2FsdGVkX1++uh29Sdl0Dr6XGTLLBGtRoTlJHn1ssqc84kcwfhaSL/SsyxBRUe8R62yLILs6P0pNrZDUXDyFFo573SnUYpNNH1YEq7XCOIo0pS/D9v6ZF/fIRlTzsxoY0OV6salQjS/0RDHMDHo42/4jgxEuCgh5+NXmpsdiemI5ncb/LNUOrA/PxZk1yhXW08uCBxLzyvK7RkwRwssAS1c6XxzeN2fjDEgj9BOIOYprr238vNwkEyNrD1amMfs7g5epLzAtBRgstbVrcgDFHBQkqsvUYAWMl70FsgEsbHgsrnTOen1s6MPt5eTnCLFK5KSYikMZOYhYVoomTCurj3/1OmucY+76aY0rpLYxn1B5pAHEl5QytzaT7rcpXUgrjvzesofSLuBDMdWNbRLDeKeKronWr0JBE4I2soKB5x6dzfEY1j2uV75CSQXLZpCf+D3YAW7DmsXQWwstrIDEhJOsRmdVIhB+U1cS/vQJz+GHedop8QvX5yaz1is06OkT2pGrXRQILPxpukCiHD/ZIfzXSyyyqboQeHQkOEj4dkRgLBeEitthLifJxVUqH1NEr4LXIm3m3b1lsr7xtwPM9OPnANXR9tkcgx37rITFbh+LOmgbqqH1H5s8c9QLhfrYlg6ee32cAUs7sPEVnMivF4POC8kxcE+z0lzyvoQx+T7TdGkrYDyt1k4pdv23Rymx0BuT6q4RUgL+6oIpF89lwKwMeNBARMMOGn0n0kVzjlky5dwkhtLGaB41OTdxYqjx+thoxwlC+E2Lowl2maNPljCtKUbi5JUndiCq5lc4yahNPLo08YYbcnkzCKWixz7HLOJqV7705Xv9h/f/HXhiwcJkhrRMT4eseTt6EHkqC1tVnFcoAVwxcSP2QUQRVZ2FPgVJQP/byzb7GosINtO7rook/Iw6hHkVZcH1BOsecNQGOB/Rc8wyxVPCDvXU0RaJVpsMiQl3daNHxf4ftb1
 /n2x/psG
 mZFYhvTkw0tWRvNr7wYQDP+eL5dFev7GL1ROGlHjo1aqiGAKjhRuiNDYSBoYVqU35xY9P88qbqp25nDe5ossEzlIXMvPlow1a12GsMpvIzjFFvAupvBTKOyPs/oUlKyQXSKrxIlx4zuWGVsLDtFH1dAqR0HBE77um4rApBJr1ZKy5z0PdXWhWn87ZK8gI9f51G9jJXuyeBaPdSs+/TM4+oSItukwxl2bUynOX6J9M25CvfBzS7+Nitc2v/9FWpBcG/WgBa9pYJWSBDl5apr8r/LV30VVEyIRWHxR3IRfQpUGQmJVp/5SIW3q4hsFHWUgi8qV9Ca/Ex8OVBeFP2q9i76OxNZfwBqtVBZWRqdF7kGe+Zol2rlyrs2uJVKxauDkMQT6iK9AQxMUHNUnDvyKSfirwRtzt8Rmjzmw4zJjFbM376hBrGol5jkm3zBIzAU7U4cZvrH8FMaO3VXV7aBTflIwqmmzbzsFqEtsWEx2kQ37Kpr6EJxtaI/OaHYCkOLBHpl0YPUBvnmEtM/EfHcZE/fD+yhenA9L2LoMcWbkiFZDggDDJw4Q0yOf5MQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Wed, Nov 25, 2026 at 2:40=E2=80=AFPM David Hildenbrand (Arm)
<david@kernel.org> wrote:

> Which users in the tree trigger this?

Very fair point. After a quick check, there are indeed no users in the
tree that can trigger this.
Back to the whiteboard. The linter is still too noisy. I will hold off
sending any more patches :).

Please ignore/drop this patch.

Thank you so much for your very quick reply!
Elkin

