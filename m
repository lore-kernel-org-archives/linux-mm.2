Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0121ECDB471
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 18:45:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AF8AC6B0088; Tue, 23 Jun 2026 14:45:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AD1456B008A; Tue, 23 Jun 2026 14:45:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9C11B6B008C; Tue, 23 Jun 2026 14:45:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6BF126B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 14:45:43 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id D402EA05A8
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:45:42 +0000 (UTC)
X-FDA: 84912056124.06.56CF88A
Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	by imf20.hostedemail.com (Postfix) with ESMTP id C5A651C000C
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 18:45:40 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="c/zi0t84";
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1782240340;
	b=oa3qmnYCDrCZDM5K6nQNRUWVLyD7O8SDrIS3N5KDVNtQ5vflPX+LEmGbhXKSWjI0ljvR1n
	cCH8/VPZvNp2VO1Y48BTpmae+XMFewBHu2eP6nK+VC5YGeSrRGSI//q+yS4uFRSG3T2iKo
	kng70WKD+cfEzQdwz4DTMKtVMERwCgs=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782240340;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LVwncB4caCHuMDpKbFeo4MHlTUSmtwWDgRh+YGNPGK0=;
	b=mNf5kKp3w5FvXS9+OiVKtZqCB/HX8dw1+/smk2W52HNLJHIupnzbezQ4zoNbUniwvdFIl7
	9SlQv0FM+t4/H+aJjsurR+5EoFGog9ugaafpc/XNtW4fKZB75Xnv8NqArR6pPsOei8ZO8n
	khSTU7+NKNZP/7veg0Gq8tZm/FanIuo=
ARC-Authentication-Results: i=2;
	imf20.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="c/zi0t84";
	spf=pass (imf20.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.43 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-460166910e6so140586f8f.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 11:45:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782240339; cv=none;
        d=google.com; s=arc-20240605;
        b=JJdPCH5VRvQF3RBmEmDXG7zSZYm7Wrwp2jba/gLZ97qsnJFBHyYP0y5Xmm9tVE9V0T
         g6CH2u6fnSBBSrJ6IVafbvKHogaNAfCK0/hcb7uXnqFqs0B4dgWeujxYKA2SWq7YMgzG
         G+s2y+14MurKzwLPSvvLdXiNExk+YDvYnLp42jZtGu6QsH74R8+ftCemaxgMvIVq75Ay
         F+wVaodJozb7I+ynw1KnZeTG4lEIkI1hovCb2nju+5dpWwFuW9Z4aGIHdhKJJMMcuAan
         rhoy0tkl8SjwrFU9QNhGkRzklcLZp5gsVyG0XceO1o/Z0qs21X5lIfi6e76gMg6RzxNX
         vtLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=LVwncB4caCHuMDpKbFeo4MHlTUSmtwWDgRh+YGNPGK0=;
        fh=J6RLzMZgVwOAYF91i4m5/K13ZsMJ+li7NWv+tw3Ub0U=;
        b=jMvEoJn5x3CiWxsv/a8PdAkzYly0KkKQGnewrBVANKtZud+gBwu5mBLEnVtC28azo7
         SDNnj35z9Aa3zR1TNS2uTveTXorGKrTnckokwhOH7GhlMxXr8PhPfg0OAYxmCC9LiIa9
         s7TgPu6zEdrTKclvCRvh1lAOXRnhTYdYJJRrmQ8xA5CY6o24QNar77h8om7Q3N6tPqPU
         Zv0PIW6qmQoB0jFhL1mfYrUYMsARF2bp5duf7H0fvjDbgGwg68FQLJlDLtweJ6OB2jYm
         LGlePGRt0DCShTFtoASPmdEPrn1zy++F/hn7JEelzzP5nCeWWZtnmlksDQQereezwZ1G
         uwkQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782240339; x=1782845139; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LVwncB4caCHuMDpKbFeo4MHlTUSmtwWDgRh+YGNPGK0=;
        b=c/zi0t84D3VZFM0dsDY9bNGPVz7Tli4fqT1Pk9j4XJBbEwrEkEl/QfQ8p/ZGj9VCHY
         bH49C5AAKpxFzPBLmiGboN7tsbAdCxNxRT4GtAy5QAhxepRVf/DG0vdGPRFd+DH6hqwt
         1vMwT16XDpUm/GD59T5TtQhCt306xzEEYncOncOqXhD/n3gg6nYuBRm7o5AJ8hyt/zCV
         DVuD8yUIDMM9r9apszcUNt9RzgTP5jFZlMCuep2DUKVBYzg7tQotzOytjiwmBN/rwCkY
         WcIXbgARFOAmw+2ur8w3sEcUa1S6i2BD2z3ymz84sI3XBj6JZkBMr7J186fvUrVLxrGT
         LiPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782240339; x=1782845139;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=LVwncB4caCHuMDpKbFeo4MHlTUSmtwWDgRh+YGNPGK0=;
        b=WJ8RgBaq7dDC1B878v3pjrtppgrmttJUWDuFaAel8NvnOnVNGJMPaVLn+mf5J4CAWM
         GMhhndLrFGkX2jCKOXtwJ0miW1EqUPxgzZlnZL4IYAaf/dE12hl3tJZ6xmz4k8roZ2m3
         zYCdHDwiF4prEY2qKUoPhIwJjJ6GUAkVM9eblfABiStnccPq30jO4BT0G/i/3/cdCL+B
         Cc1Sf/l8Dg1USEu96N9IyrDc3W9xZyVL+4LKvJI2cKrIH8XCZ2nUR2qKBGCtXXMKZTsD
         FN9Ud4KyJ3AMtjAHx98MuqEb7bOfd0hZn1XgvN/2Ovi15shxfgm6TJyt/SBQFNmEO+K1
         zEjw==
X-Forwarded-Encrypted: i=1; AHgh+RqSAQZVCM/iw98/ykZtZ3OoS2E+AubPsRkJB9SnvD0Pal61ZVHicul5vD2hrxfsPUdaEr1OEyeV9w==@kvack.org
X-Gm-Message-State: AOJu0YwCJONu3fpxPP7ZbQI3iqQ3FeTyD0WZYs8aat44aunYjMo+fZNT
	pUdqe9JQ6IvhNd/CApWkBS+t6sxTd0eLkRCAsUXNf1+5vwtn34PZuLEiCVDxfmvwYAEj81/Bd4E
	pD+gs3ya8MfNGYs/Cwajf8+W/2+1gZvM=
X-Gm-Gg: AfdE7cngJCfKZneosu5LM+QSnv9DAuZToCsh+q3vbFa8CYlPUsWbbJ8j3QgYeUgA+g8
	FdsitEc+QXkz1HSiBSAzbTlRPE6nEwyUQjCOh4jAL6knSeCCn+6i9FiuefOpXKvQQYuwQt4yEi7
	Z1t8/7PMB0NQDDGR0IlIzx5cNtGuBWSwkF7PwHlYbKBJew2QqQciQN3RKcisoi4SmJAoeU+EEae
	Xa63M+IfRUzBP0wWdk1yzCbuWJCXjA+gsfCHtt0zWGlDeRhANH3fZTDaYAcd50s8mV8VAut9Se2
	WIvL8PKGnyxT4Wa8jsv2rYwwg2XA
X-Received: by 2002:a05:6000:22c4:b0:45e:fa38:c899 with SMTP id
 ffacd0b85a97d-46c084c816bmr138476f8f.4.1782240338997; Tue, 23 Jun 2026
 11:45:38 -0700 (PDT)
MIME-Version: 1.0
References: <20260612193738.2183968-1-nphamcs@gmail.com> <20260612193738.2183968-4-nphamcs@gmail.com>
 <ajnRulrxAKnZavOl@google.com>
In-Reply-To: <ajnRulrxAKnZavOl@google.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 23 Jun 2026 11:45:27 -0700
X-Gm-Features: AVVi8CcGflRtAnYhAwHoECRZzxc8TT27o9VDjZ7vOQkQ1fmoj7wrI9DQrKaVgpE
Message-ID: <CAKEwX=PsyKgD5UufUsX138wFnmz9hKfi8zvrbs6gsh4Kj+F+yw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 3/7] mm, swap: support physical swap as a vswap backend
To: Yosry Ahmed <yosry@kernel.org>
Cc: akpm@linux-foundation.org, chrisl@kernel.org, kasong@tencent.com, 
	hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev, 
	shakeel.butt@linux.dev, david@kernel.org, muchun.song@linux.dev, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, baohua@kernel.org, 
	youngjun.park@lge.com, chengming.zhou@linux.dev, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	qi.zheng@linux.dev, axelrasmussen@google.com, yuanchu@google.com, 
	weixugc@google.com, riel@surriel.com, gourry@gourry.net, 
	haowenchao22@gmail.com, kernel-team@meta.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: ew39f93rd9gqkgrn9itd1yfb3o6w36ud
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C5A651C000C
X-HE-Tag: 1782240340-231670
X-HE-Meta: U2FsdGVkX18ZrX92DgWpf4Fib5DkLEP2QOX8S+0TRn40SDZYDy9lj5DU9f04YSKz6kKvNeDGwNO0kwEOfuIC0EKRualbP3OTBhPdg9RPNzKHzsiWOAYzn9Lajid0T2MMV6E/VUqG5RSHyueUpCU9WGYzR+i7HzWCa6c39ikLa/kQu6kqoCvNtdcwcwwuq8GL5cvNvFDgj49NQ49towTShtEQ/SQ9gRRKWJN1sjivvRwyprc3/lyCNddSPmjAyfbIROALJrff7dth25Q8jFJT3BTlRXtdcDbi8QfpH7ZeoD1Q4JDODyg5Y8T8HSX59InVOtzZ4g25NDRR/uYRB7JXi7KYfaCAv9bGRjur2QO0cq3DTC5YUe9byStW+Tf37XkTQLWAKT5swxOMC4ws3davtbbcfLRKQdbhE73rivC+pwTrM3oxiLwGMDn7A4+EvOggG0+VOV2qDpQblEij5EK3vrvXfH1uDAAfSAU0JACAuwo0jas5O5V+wbiobvij2fm2iSIYr6a961EDwi0EHAE/RVnI+zGt/4AOdF/KP82Uka8RYOXNLscuHi7m1begk2ZhJ7ibYIvyMG9PGNLSGb/Fp6X6IC9OKNb+VQTM4UC6NGcXiwyQ8IblYzJ9wFy5EJ7wKJ8/426FRy6gYUB1QNn5iKWL8jo7kSz49OV0zr4MfB5sidZsX4KsDgTUVZOC3iskYsfqFd/KUO/u6qOpZ6MplgLN7ewLXtG8CAUWDlJTMIgID5I3OitmWGeRLB0Y3heKw8eBazAa487TzP0x3BI3/8p9LJodBMW9ERWajnEpT95Fvxa+6uMJsKrFRvkMQu7o4iF0kXriUeVHzdVK/VT6QXUKk5HX2AYnQGmzGV8Ryykz4d0qZcowMII/8YzLhBwo5Uwge4hj5V/72SPnGh8ozFe3dUkxZ84GldcJOYEfxpuBUQkXnSLbE/mTH4Tx+PcWf/Ea4jrvUyUgHfzNSX9
 2WGLkOa2
 x9GjUJkd3bNfCWtuAsGUGD0/kZoPDQJhprsCyr/XuOR/qgCs+PTNUhnHH8LRA6UpGb+QDC1EWzqQIpnRPRqhxzGJBwNZihOCPwbxZdiE/Capom5YRn0yMoY8izFrUxdennWsg9gfGiNMNIIWriW9HNsSV794wAvTzQv22iQdnvJq5d/oN0bo11EjPl0D9tOOIRKU1ugWQs7iiEANZy2v0TKx1tUtZNRL/m+W4kngODFQlag1PywfWaeu7+q1BIAeIrK0Qdf2kUCch7J7er/nJVpAKyUVrUgn/edhLa3/w/dF5tWH0x9iAqlm95GV+oAy+kgbPXXRiBo5pH7hOJj64SsCFz+XRgVnOHn8g8qUwkxKkkYm+/sbi3+suOu4enfWvNCB7Hqqbyazb31TyfmdSSg2+4o/0ggTXUw1YPXQGapr/PEw33N27T8eq7rRfbn+acVE4mHlY182eF3bv1BrQwRlO0j4DmvUtBkBz
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 22, 2026 at 5:23=E2=80=AFPM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Fri, Jun 12, 2026 at 12:37:34PM -0700, Nhat Pham wrote:
> > Add physical swap as a backend for the virtual swap layer.
> >
> > With physical swap backing, vswap can allocate a physical slot on
> > demand when needed: as a fallback for zswap_store failures, or as
> > the destination for zswap writeback.
> >
> > Each vswap entry's physical slot is tracked via a Pointer-tagged
> > swap_table entry on the physical cluster (rmap back to the vswap
> > entry).
> >
> > Suggested-by: Kairui Song <kasong@tencent.com>
> > Signed-off-by: Nhat Pham <nphamcs@gmail.com>
>
> I didn't look through the rest of the series, but are there use cases
> for calling folio_realloc_swap() without calling vswap_zswap_load()
> first? I wonder if the realloc_swap API should take the swpentry
> directly and do the load within? Something like
> vswap_alloc_phys(swpentry, folio)?

It's also use on the swapout fallback path! If zswap rejects the page
or is disabled, and memory.zswap.writeback=3D1, then we allocate phys
swap space. We probably don't wanna do zswap_load() there again :)

