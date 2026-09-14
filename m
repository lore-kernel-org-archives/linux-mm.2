Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D0522C88E72
	for <linux-mm@archiver.kernel.org>; Mon, 14 Sep 2026 17:38:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C91396B0088; Mon, 14 Sep 2026 13:38:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C574D6B008C; Mon, 14 Sep 2026 13:38:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B564C6B0092; Mon, 14 Sep 2026 13:38:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8CBBB6B0088
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 13:38:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D2B89A4202
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:38:27 +0000 (UTC)
X-FDA: 85213077054.26.1CB0375
Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	by imf25.hostedemail.com (Postfix) with ESMTP id D833EA0004
	for <linux-mm@kvack.org>; Mon, 14 Sep 2026 17:38:25 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=brwPMXWT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=brwPMXWT;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf25.hostedemail.com: domain of nphamcs@gmail.com designates 74.125.225.76 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1789407505;
	b=fdMBaEeALoDeHF566Njfh4mbRLazhdQhutg6m+W31DQKdJYXsHQklSjxwpAhWERBdYjWDR
	xX82p7QcHetdYGwXS6hCBi6AqlUzKmqoL4MiJYlYRBROJf4+iJpgFaiJ48SBE2BejskojL
	inXxSzgpzomC1DPWu5B/AkiumSb4Jec=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789407505;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sEeztLbuGFyF1dhhheCGiQ+SCiNVAWKx2wrJ88/WhXE=;
	b=NPVXSjdGZBi1fIIS1uQz3V587zdTxfVbtWqJgsSUYRugHzKWLS1h028zc4cI3lla918ctY
	SlDRrJH14vlDZEluSqWgTH20Ts2S/PSIZQkc8sRz/yQPGQafYM1Vlf8i/9PhcKjfru1n2b
	RwMPh9JW/Ubzf4QRjqzbUA/FODOoXVU=
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-4834977ae75so1299202f8f.3
        for <linux-mm@kvack.org>; Mon, 14 Sep 2026 10:38:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789407504; cv=none;
        d=google.com; s=arc-20260327;
        b=fcJ9eZGDJX4zARmz1I+ucLs2tC87WKkhtw14oKU0cZqkUIZePYjSO/qms3DwDrj7LY
         9MDruUFSu0ldPBa68WsqJwOBh7if+dSxhh93h+UNnD+/zaG71ot4v5TIQqftVuNk99Ux
         WeINo+f51ztW/EpkRYHi9D/4GjiMKDFXiVcnObd/B4pSWpKcVuELDUL07o2g+lqLfJHh
         blpUFx7Jhl542HTwjBGHSekyNwyhsVKVLR9RvMcXk+67r8n4h3k9+dZDS8Q8CP3Thu6v
         UgCcRSlL72kDjsDO/hhIqrRrXyLU6mxwrgVF8KtmlFhtBw5fs6iVCwkgKL8/JQQ+KqBe
         w0XQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sEeztLbuGFyF1dhhheCGiQ+SCiNVAWKx2wrJ88/WhXE=;
        fh=e8QckgEDOKMl8mOmQTxw+nz+q/sHdsdTajkB115/GRg=;
        b=TwcW37qcis952v5zbCldMWh3ttrz/Q3ALc8yVoim9A9N+OOrqc3QgZsXpy2dENs8Tm
         KZpWZvgLT14qx+gK2hbw9BT1V0bjNNRoLLlUAGr06f29R5D2DYmshBkeBMUbebh1L2JM
         Lm7LaHTWDRhuun7YHWehAayCJPmQusUMoz8aihTjwTb+2UzWON3GIMJHo6jyqz0e9JPO
         H49wRyN8l5emz7k9r2N62XwgoA/VEbCLUmyHOdaYUNdl4vpeWDkmrRsG3iXzi7FhpOPE
         /ubBQuTfLeNsbp24hI115dIxcMXxWJXq5XcjKN9Imowo7oG7mhr7xGw+zLyGBeNvv8H2
         10XA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789407504; x=1790012304; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sEeztLbuGFyF1dhhheCGiQ+SCiNVAWKx2wrJ88/WhXE=;
        b=brwPMXWTuKbfKtY/CyclijGq2SYn2gU0qfUEp4cxALKUHJXp3ci8XAa+Wtlq/ueLem
         IEeUBpEWbCLDl6Rav43C3oyZgXYpV91vVk6wSLzzngEAz4dDAeRL+PYxPtdlaU0AUWuI
         4gHodBA8HviktNSG2rHJQ+HRIiM5qDU3xu/SXxG175YweAJwrMfOF1j5lH3Hd8ihNwjw
         PIQkpa5M9zRLVMs107kL9PsPK65hciOT4Fg0MjLWWoWsly08ZtdLOMvtp22FlNnA1dYb
         UfbpznBHdIUZDW/3UEZwDuNJwNLfGQhvs88HSY5lCEs40z7hoW2bGJdG7ygMkCUAkrhC
         zPlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789407504; x=1790012304;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sEeztLbuGFyF1dhhheCGiQ+SCiNVAWKx2wrJ88/WhXE=;
        b=Sxofy3Ck1LvdXcK/n/NnqYRMA+fexnrDbfpPwXkfgAiZlX0s0F8mesQzm+hdy+eH+b
         hu5HuB1cqScD5FP8h/O6tPmGGxNhJXMCoecjinIyJgrd8DE7FW5zfQcfdN7Nkgi9WOlS
         MhoPrVu0HO9grNyMrvLelbtC7/SsL1Qj0YSV6NHBjO4FJNMKn9CFTSh3UAQvDzcq9JwN
         1wGM9gvnsC8jjT62YUKffTfliiXg/BvKd6I9uOj3Hyzw5NW6ymGbQs1f09TTD1v12To3
         TYC8h7U6rnFHS6kUYbV9lcoUNE2y76x+WZ0UAcePs6ASQKdsH7mGPfkkdjXPGt+9fvw/
         89OA==
X-Forwarded-Encrypted: i=1; AKwUvBzQzW5xyDGKK7sq/zl0Y1EUK7QdowM8Cdhy2xHbTJimR95a2JnIJYNclds0fEPICfvW74KOShk/qA==@kvack.org
X-Gm-Message-State: AFuF++mwcHG1+1Ix+IrSrxqODf4sXUz2hurO2US7moJY/ATnV+3TVzkq
	wD59DJrJVCX4Pjkw+9yypkZMuxrbYVUqdCYbKxKtVzRw8ECwMTDTTSwPg/Dl5ev0QLvqrKNcm81
	r48TOqlX49eIBDxEwRS6/s4nDPOiSiaI=
X-Gm-Gg: AYBFou0QArd7K3VKvQubfRC2Zyu5dgRCy/knZwceVc46nGCSPlH4sO2FRddAFsz1+oF
	c+nZ6QH4xmhgw+alGEh3SYiguBNBJari2pyhpq8JrLQHOrfna3AA4fzRrLuPoVsPP7EU802pV54
	klCfrmsqlvWZ6ysc6pubZxswTEBqu3glEqyFV13s15otU6U4YYEba4nAbe/r/wWfph3M/QvNuU7
	8cytYaXEMZcvZXk6HR3lqTn7vScqlIiO/eTvbsSxuERebpziWPSRTWHPgyLu3T2jjalQ5tQfinm
	cSo/1qiws2tpqpukDVz8/WEUJC5ahJ9Q8tHpcvTNJYXxy6jKkCREbmLz1KxoCm+WSpNreJuwsB8
	nM4KcK3FG+FU=
X-Received: by 2002:a05:6000:41c3:b0:484:3310:710c with SMTP id
 ffacd0b85a97d-48702b30ad7mr9667975f8f.24.1789407504318; Mon, 14 Sep 2026
 10:38:24 -0700 (PDT)
MIME-Version: 1.0
References: <20260911121341.178028-1-alex@ghiti.fr> <20260911121341.178028-4-alex@ghiti.fr>
In-Reply-To: <20260911121341.178028-4-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 14 Sep 2026 10:38:11 -0700
X-Gm-Features: AcwNN1VP2kc_faYmAYrbA6jzrQN4BV6EV-vGstKi49hd1f6QiPh8-BHVVwhcRhE
Message-ID: <CAKEwX=OpSG=fsw_7UsyA753cUTPTAjN3E8iRcfCzdO=Pw-xjAA@mail.gmail.com>
Subject: Re: [PATCH v5 3/3] mm: zswap: drop cold writeback folios via swap dropbehind
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kairui Song <ryncsn@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Michal Hocko <mhocko@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Wei Xu <weixugc@google.com>, 
	Yuanchu Xie <yuanchu@google.com>, Kunwu Chan <kunwu.chan@gmail.com>, 
	Tal Zussman <tz2294@columbia.edu>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: D833EA0004
X-Stat-Signature: d7o5aiyuxz9bdwjnrs4u4y6feaje1mog
X-Rspamd-Server: rspam01
X-HE-Tag: 1789407505-191575
X-HE-Meta: U2FsdGVkX1+nvvYt1Z3Z7G4RXdWTpC5dXr7oTAVFqi2zlnONA1wLdU3HOF+NyC/TPSt5x5TXwIvwnJ70dY0ZjYEh/YEWzPSDGbbdIdeQhf6plOfVq6j98/Qt6pi+qk5Id9GpewpPA9o6AcYhMNHFoByvqJ7AcyW0Nu6rDLDyS4RVrivj+ysFCQQCveDC6uZYmByAnhk1wUO9SbrV+El54ns9T+GrlyOLrTDox8CsBXAEB6N1+n6JgNMr7MKTTuCwi1XmE0l+uyvLlU++tCOFQg6dt8m5mWXYK0oZQnWbrnmBQ6JTggqiKHWAtFAshOKMAg67HmpmIzO4/IkAsf15i2fGHUzQ2AjRXAZiqhfsGIQAAL/htvXhxx6PZF7B8TtFDsYWGCfteO5mHqgZdNDqLIr58tg1zN5bTHUEISmrqsJ/0kMTrFuK3Q3/kXPGiPhqQC+kieDD3FRr4dS+pcvAhFNYRiA/oCEF+wdBdkVSwYxcSiJocgfUHiK60bZJADhkrsxIxr1uIcgs6filEF6im8v70Vj83/YFsLTpF++aJKBJeF5UdcvN5G0hHmrE4UPyHnV6RKKdoj8ZbnsjI54i67I5+yMtB530U+cHv9TmvKHfXescbnyYVLRoRMiZJS2UpCIHs0iLZxNsLdC+QxokfiHwYBE6CSUm7sJobcl1zI94MzjHOPKtMSH4YHW18jZJ/QFBLVU1uJbOKdI9gg2IU2LS+grSSl9yRe4yQFCmzoZEXHs1OFmdPQMaJBNLWcPS/D7H7dRfbPvm18O0aHXOaRj5663G7+VNYLnR894StIi9YZg1+OaUlRXyWwCyIK8JcwXjiVcWMyN23TQCgGa/TsN6PkD904uc/jL8Euo5qF5N8aC4s7+QB0HfWdU46j5KZGlcY4HOQ+hT4EHSL4lncKQEAqKPC2SCJ5QM/9f1bRGNR2aiFao+q/GsG+WnyaBxdm1q/48+6ARpbQ3OiUC
 nQlw+1yF
 DeRZA7J0BBzQ6SLRDYTsI5iZxfPRVFUMezi884ykMgiaTESNkwdSRuGs8LaoYj9SQ7j04EkwTAaouFmo/6wr64WupE1woVMyKAfsm88eeVtrYPTQG8cRg2MwCK5m3SBXmyfJuMVbovc8TP2HsczpvE17rk2Up3tqXDQLiwNombKfwMW8XFOMXKB/GPLQTTz4ufF6M5UwsOlMLltfVyPbFoMKC7NyZ5YZymLBTqpH1GnRPq8KmQPZL2AoOZrWbKOXs0cxU7rq7J1vTHhEYcNeyI0Nfrxm0S3t/vRNj7cDGLJIGkWzmEUUMmuolYAJPMRCSatxLjHWbqZI//TmCW5Xbjs76SdMbPxh3Tc8nHYJG5DtJjmXNmwipEL/VbX8ApzsYr/RVUYN9GQODe6o24scKlZsyQ2yz+h1rUK6sgIXvwa1GUueITpeeb3Ov613lzYXgWwZmEmdUeyEsfcR9yIZ3EkfimDxGOs4sz/iAhoF6mC8TrNXwummScqMDl/V4m5ZkF7G6zddDVJHd6qbC/vSUjxVvnRNDLtaksI/WCSCupp3F0x/dftaPYfeUqvcGWhEqXPKsKvL8fJdM7zs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 11, 2026 at 5:17=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wro=
te:
>
> zswap writeback decompresses an entry into a fresh swap cache folio and
> writes it back. The folio is cold by construction, yet it is left on the
> LRU for reclaim to find and free later, wasting a reclaim scan and keepin=
g
> cold memory resident longer than necessary.
>
> Allocate the folio off the LRU and mark it PG_dropbehind so the swap
> dropbehind path frees it from the swap cache once writeback completes.
>
> __swap_cache_alloc_folio() evaluates a refault on the new folio, and
> workingset_refault() sets PG_active when it looks recent. Until now
> folio_add_lru() consumed that flag and __page_cache_release() cleared it
> once the folio left the LRU. This folio never reaches the LRU, so nothing
> would clear PG_active and the folio would be freed with a
> PAGE_FLAGS_CHECK_AT_FREE flag set, tripping bad_page() under
> CONFIG_DEBUG_VM. Clear it after allocation.
>
> That is a workaround: the refault should not be evaluated on a writeback
> buffer at all. A fix for that is on the mailing list [1].
>
> Link: https://lore.kernel.org/linux-mm/20260911092012.92399-1-alex@ghiti.=
fr/ [1]
> Suggested-by: Johannes Weiner <hannes@cmpxchg.org>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Reviewed-by: Kunwu Chan <kunwu.chan@gmail.com>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>

LGTM!

Reviewed-by: Nhat Pham <nphamcs@gmail.com>

