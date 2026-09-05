Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2122FC624D3
	for <linux-mm@archiver.kernel.org>; Sat,  5 Sep 2026 10:52:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 068E26B0095; Sat,  5 Sep 2026 06:52:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0416F6B0096; Sat,  5 Sep 2026 06:52:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EBFFC6B0098; Sat,  5 Sep 2026 06:52:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C9E166B0095
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 06:52:20 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 49863802F5
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:52:20 +0000 (UTC)
X-FDA: 85179394440.12.EDCE894
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf10.hostedemail.com (Postfix) with ESMTP id 5CDEAC0002
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:52:17 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQqBzJ9S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788605537;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NtchyYKwRIGUXVrtQ0jO9YBLefxN8FB3ugsFlO16HMA=;
	b=BsXYSqfsoNkD0H7YoWwCGnOCC95116NO3ahbU+Q5hsOn6/CZZXMH+mkcSiPvPWGGa+oo/9
	Chgo4OMVh3aGS9SPWuFHQGHZxbIzQZ9NCYHB2XCTU9F4OSqLysp1ioc6oS+JJQw6msPfkw
	J11GF9bNJbGFwEkLt5nwS95wc5y8hV4=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IQqBzJ9S;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf10.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788605537;
	b=KjgFtgJPn43M90BJRYeebpn53jiItWg9K1rjj7iF/Mim4MsNFseTP5sIDgf4D2aYq0IJsP
	zjGrIs2k01NjKYqgTL2o0a0wSf15Ef6jVpuqA9H5U0x4ABC6zkKgzhJdv2hlrI7UiPcnwm
	VOuL+XA9WWzfEJb8W1ArqL63T0nMH6k=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DF9E440A5
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:52:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BCAC1F01559
	for <linux-mm@kvack.org>; Sat,  5 Sep 2026 10:52:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788605536;
	bh=NtchyYKwRIGUXVrtQ0jO9YBLefxN8FB3ugsFlO16HMA=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=IQqBzJ9S7MhInSmQHhC+/89oCvr32JPoZr+9dQW/UnrRnR2oTG7xNeZ//8VgQAuoZ
	 bel7HWxqYuux6YK+Ua18fxGY9h2IxGqIjhCzwll8RyDeA6W5EQX95XBislwdJFkDlT
	 Bq+BewNXMCQaVQk0Yc51QufIb3lJ5T4UJ3MUeZfwZxecyqfRlOTJpgVc+3/0Z3UOov
	 5lS2I4L8c/jaZXk1YNdJ7gywevQOF+2E7GcRm4NdpHU/34Jy0gDwQWdRIO7erXWD/P
	 xYwyU+6q3SeQfDrLmAb4d7fYqgMoxA1G8O1aFGaIrBJtk0EqqerT299+4MlM5pRm5H
	 aluI6YGYPv+lg==
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-9399c77e2ebso2169885a.1
        for <linux-mm@kvack.org>; Sat, 05 Sep 2026 03:52:15 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AKwUvByByYBLGlwayFgL8T3a7zoUXaAzzYpaI/VAW2efX74xnS14tSMgpIMdOeXgbAkRFc2Zn0Z9JaOWjg==@kvack.org
X-Gm-Message-State: AFuF++lKgq1J2mwFGcYZOgqfJTIyfqzxQQoNuW17fifxLkl68442pP0i
	x+TyRw7MWg5WeXa8fyz46+pcM2mLXb48oSAQv10A9hp7e9DmfWOZk19sKuq1UUW0vPLn/zZS6WC
	t9jyewoF+j7AWN2ny3HfehjfUF+bZm84=
X-Received: by 2002:a05:620a:2905:b0:939:934b:dd61 with SMTP id
 af79cd13be357-939934be353mr216074385a.22.1788605535375; Sat, 05 Sep 2026
 03:52:15 -0700 (PDT)
MIME-Version: 1.0
References: <20260901054358.4049095-1-dev.jain@arm.com> <20260901054358.4049095-7-dev.jain@arm.com>
In-Reply-To: <20260901054358.4049095-7-dev.jain@arm.com>
From: Barry Song <baohua@kernel.org>
Date: Sat, 5 Sep 2026 18:52:03 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4zByTsOgMRZHPsqiFw9HhWCJhtfkC5aYSnmyTYCqr19Lg@mail.gmail.com>
X-Gm-Features: AcwNN1WqV8gqvn0kri-vxqJflABlnJROJZJbXDW0Uofbb8st9bHSXv2-ep7QvYY
Message-ID: <CAGsJ_4zByTsOgMRZHPsqiFw9HhWCJhtfkC5aYSnmyTYCqr19Lg@mail.gmail.com>
Subject: Re: [PATCH v2 6/8] mm/internal: add set_softleaf_ptes
To: Dev Jain <dev.jain@arm.com>
Cc: akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org, 
	hughd@google.com, chrisl@kernel.org, kasong@tencent.com, riel@surriel.com, 
	liam@infradead.org, vbabka@kernel.org, harry@kernel.org, jannh@google.com, 
	lance.yang@linux.dev, baolin.wang@linux.alibaba.com, 
	shikemeng@huaweicloud.com, nphamcs@gmail.com, baoquan.he@linux.dev, 
	youngjun.park@lge.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, surenb@google.com, mhocko@suse.com, pfalcato@suse.de, 
	ryan.roberts@arm.com, anshuman.khandual@arm.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspam-User: 
X-Stat-Signature: wbek3j54gm7eoo74kpzn11rihsxhni41
X-Rspamd-Queue-Id: 5CDEAC0002
X-HE-Tag: 1788605537-650563
X-HE-Meta: U2FsdGVkX1/CLFtLLyb5WzRZX4n1PVPVopkf3VRnporqiY7+owd8wwrUEy1Kp9FhQbGN/XmAyIZ/60k1k6qq94Z3acfzo/REhY3cVn6gPVYrGJBkxRsJW2Ia+SCLR6surIU4RLsE6GiiTZTXWxXnOiNZ8czlzBFGwzzKGHgnV3lKSBSwWDVL6hKoYlpA5hTh+uHkI31gbbrilK3e5iLvoNcu4Eb+0jrRkVuz63/us8axaHAaFGc3QTchzx3eQnPpI3xreTvdmI9X8MzftxhK1KfzVEuFI1O7POIPX70NwkPF4dzt4Dy4PvDaDjd6pODDKBd+AehvmpfI5XTJD+Z4ENmN5K360+zTeNSEviUb7Eabh7vEyAYOAmgZfS8MQ/1vVj9ckzBgwzvLsvVmszmPqnKJuvgOpLpDhSELrnC90MyJ1PXvP4AyayNyReM2e2kxHwmiWP50nz3P+YJg9/4VgqYbEuE6SLeH1k6wBi/DOkIFuucWRw4sX+9VAXdCmBdxn8KtvqavPFl98XNhgxXNyeVi0Ff8BsZFrteLbfgyVZAgo6IIa2GaeWfQosdWQiLOOw90yqNB6x5zleYlynLhc//R+24w+p7UX/p8gQu5Js/JCb+H/uln1cO8SbmAkSfSmBbsw2GI+OO5TpkOEKY0YPXBi74NHBSwQOy49jAHX4cHgATJ3u0n5tcdpsVdDd6CxUBFoK+0mVFjYos2N8AhSFA6TYawStIaZqhLXGl6lyata2+lJe0bsiHMciyLNJXGYKr5tUEgOafMcQc6DMoUFQQiCn3Vgnw+nxA4M10dnO+7eBUIy1njjkbRFSGjx1YQs4+Emtnv7fPc4HcK6d8tecVyRgcbHzbEQVLo02VB1nxCF3TVIS4rllTwBbWN5unppOeB686H+08VqGT9BgpbGgATH7kZbsWjUuv9hnOXimhaJFqqS4Ys2mlK50Uy4ScQB2lbjls0pB2wNNMJlF0
 lKE+N6N7
 x+8dmL9a/WyJ8DMA2+FSIPr3563xHljIPyhx7u5qjgnIQYDzagLDVcHez/kEPV8AEqpJ1HgmaDNvAlTZJXSXjiTHDqQAq9wIexzbI/33k2TK/5cJan091gfEmKd1j+ifgINPJCKwaJLyhawhRaIgrsBZKD+pa6oWQpu6HUpm3LcPySSnzYHMZnCOeKexMRib6EO0g+hSKgTMfux6rp142vP+Xe+nkzcnhLia4jKgdM2nvh200GXXhQQ0r4IK8mHpUdM3a6I55HFLmvdYYz7KurlBm6FfgdhT8YRUe3mAAmb2kbtOeKWK572DUaVTtL9UGgGyOlbUEvUESO5RuUYtVGls1wCebcaq1yLHYbpuXxDnPS/oIj2q9nGcyqQgnmJTlKy3q1LwUwSDZKoEN1wHmLo05U+KbUIwV11A0
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 1, 2026 at 1:44=E2=80=AFPM Dev Jain <dev.jain@arm.com> wrote:
>
> Currently we have a helper called set_ptes() which is used to set
> consecutive present ptes in the pgtables. To do the same operation but
> to set "consecutive" nonpresent (softleaf) ptes, add set_softleaf_ptes().
>
> The softleaves which have a notion of consecutivity is swap softleaf,
> and those grouped by softeaf_has_pfn(). The latter is trivial; future
> code can convert present ptes pointing to the same large folio to
> swap softleaves with consecutive offsets using this helper.
>
> The other case is softleaf markers. They do not have a notion of a swap
> offset or PFN, so future code can use set_softleaf_ptes() to store
> multiple (same) markers on the ptes.
>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

Reviewed-by: Barry Song <baohua@kernel.org>

