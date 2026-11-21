Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 55874606A320
	for <linux-mm@archiver.kernel.org>; Sat, 21 Nov 2026 19:42:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=bedBI7aV
Received: by kanga.kvack.org (Postfix)
	id 4776E6B05B6; Sat, 21 Nov 2026 14:42:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 427546B05B7; Sat, 21 Nov 2026 14:42:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 315E76B05B8; Sat, 21 Nov 2026 14:42:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 0F2886B05B6
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 14:42:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 56006C05CF
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:42:12 +0000 (UTC)
X-FDA: 85460147304.20.44A1CD7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id AC562180007
	for <linux-mm@kvack.org>; Sat, 21 Nov 2026 19:42:10 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bedBI7aV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795290130;
	b=lzPMiPniVAWzDnF4rdSBlwGBvClOCenjh65a3BI8E/0wfc87wDkvqGnYaqZMC1w7JbAOI/
	uX9mdBtDcpaohPVIXb963vcLiam+IZDnvyrLyBZtlWs8LFt2/SemUzV8/UaXw3Bu9MiGGp
	ac3+ZH5ImN/iVwWvLKB4mRgZSYIQGxA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795290130;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:  content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sULQB/3Q3yNuI6DbYkIoJUffkHiAfgS8UC+0bPKsFgU=;
	b=WjrherSK5Uu9sYvEZ7ZWfLUqoO3cJlPasLik3Dmg3S9D+B3+hkPuEOb5slrWG+6ldz3KSg
	0yRedJoPrA/1Fdmi1QKeRTtI81tLHl/fBmCkcOoabx0rkjEoq8wHX4fcX56O8kAzKI0kwa
	llijk9ftyNShECEjeF2BsfCFSNi/Ra8=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bedBI7aV;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf24.hostedemail.com: domain of sashiko-bot@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashiko-bot@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C45A743A25;
	Sat, 21 Nov 2026 19:42:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5290F1F000C4;
	Sat, 21 Nov 2026 19:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795290129;
	bh=sULQB/3Q3yNuI6DbYkIoJUffkHiAfgS8UC+0bPKsFgU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=bedBI7aVCspHsh4ZdaN1XF+8PoUrhYhmAa8fONB2RqeBqNI8NUgkMAfWJK4+tFIsB
	 aZz/U7Eibxdoarb+NrxYtaCm5xilWsYkvCHW1SEjSLhzc2t/66QMhRtlIblAXB/hqU
	 rQqZcxL+IbXOAt5xB+s7C5dMQuK04ST3PoChVFNHzCL8JevR83Of2cPPa94MyTOQQO
	 m+JIDzi2piV7ZCclyV86C09qdgxviyciM+7M5t6P6kF1kCENTuKvUSjqWH/JzeWen7
	 c5VO76dJgNfNi3dXLgpbKdyu5esf7LfcUXGE5H/hNgIbRXhq7EBy8Wyo+cfOsNtClf
	 yk3Sw/p8qFpwQ==
Message-ID: <sashiko-outbox-227319@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [RFC PATCH 2/4] Docs/mm/damon/maintainer-profile: use damon.git
 for patch baselines
Reply-To: sashiko-reviews@lists.linux.dev
To: "SJ Park" <sj@kernel.org>
Cc: "Andrew Morton" <akpm@linux-foundation.org>, "David Hildenbrand" <david@kernel.org>, "Jonathan
 Corbet" <corbet@lwn.net>, "Randy Dunlap" <rdunlap@infradead.org>, "Shuah
 Khan" <skhan@linuxfoundation.org>, damon@lists.linux.dev, linux-mm@kvack.org
In-Reply-To: <20261121193331.108587-3-sj@kernel.org>
References: <20261121193331.108587-1-sj@kernel.org>
 <20261121193331.108587-3-sj@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Sat, 21 Nov 2026 19:42:08 +0000
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: AC562180007
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Stat-Signature: 9sybqme1o89ekkyz9xps66in6e5khif3
X-Rspam-User:
X-HE-Tag: 1795290130-594133
X-HE-Meta: U2FsdGVkX1+Khek3kzk6M4X+WH7HcWRd4hc/2RDPynPxwbt/VHmWYzbFzLZe0wFbKpu8NAf2ul0BXprcwi3LcaJWqwI5CkQHOW+qh1YKoMbHGfkhVDR3AxHNjUIlveTEGCTz8g+g59dxQ4WIhTLxoDJox/x8oxh0LXFaouYYxnxSPzK9qXSN1XCtmuuVoJcDE3u+IVpMJSOM5Fh7jtjGeTj1LD4k5pob0OOtPufQt1v3JJ2dxaLxJgDn2rBah1nOx/UcQwoSuXoq6oZgQFSmf6sS7u+9yYublcMZMOPeQ3WPWerIHdE9QRulIcTJ5OFm4VXzStBUvoMLVpPcOI8HdHqkgWvxB+otEnrJ2UGAYY9AL12OCZCu2p6qxKN3YDl11zvBhqJ9H+5MYNlms5eN7NLnu0x6Wdh95tncIgftYnZKFvXvoeutMEhuYToG+f0irro6Z6UO+EgJ1cfFftMcPHnzFUAB8U7t9C+vC7axpv4PbfDynzaITCziXH96jw5wX0ILoVcCKoNEArPkzGvkYF+DpEKRJvVsiMa48mpQvmwy4vvrgch1WX1koGdn29zlm6m1BqPfQc4oVdAnihmTgIQc38PBx58Lx8fh4+8CaQb/lEJAYonNcXjU0hMEOc3AiZII5sCsdlealuCvwHY8sjvllmMBC58ZMxAoO75afAQNb3bpaLh4sVTeUnoDqY+t/CXI85nZIs8eRRuin/EfoDGrslB0lCzzgar6rLyCozWI4lftCR0FHsxhxnI83/9CSARjcGdGHByNNU5GgPEWAdHXvh91C8h533+RK24wltakujeBBUtsRb5rqj7tLICPDQ5+4oiBCGpl0u2CkakrIQSR0FuUnoR+YmMDrIzmBNqsZ8qqVsyAysouibR3qunTb3m3PRZtIBAiKRb46WrgE2XcOL5IfAR/ViB5CBUxgUjFATAzB2b9PYQZClcDL06/MrojSAggbYEHkdBsLnh
 upqbvRwz
 2+yxS2jbpj8BZxliW+0l6JqJvIc270ruHJdXWeX0D1s0rMoyvtH9jtTVFa+0nY3yiUotiUsBSsIVkz202xNtFrkJuj6XmIXSbTa9df3OpvlMnRxu5QB4aTiiZ95BQcAqc0ZBUIWilob8ouhouPyGmbWI9icHteh+0MxiIEEjNzRkYuwJxTN9G3hqhnZK2cdi0C6pDzrAUYSs5xtPcdNhG6rfLYaTxodwZifOYj08LB6D4GR/Q+sdryTAtSn4bC+QpeOPvY4zZL97y8YTEcwSiI2RTsey5ntm95hBrlBJ4/eP4YkD2ARhy29tHoaQwKfxAYMzBa2pAL7Cd2qH/ZA+B+/2UGVAcuBs4iPaAhapzH4AIm8W7nkBhNeTQmRCC961DezPkUMY7jJoIPSG0DMqTt5lhr5nnGlqhtpFm2mF/BGJrwINfusr73g8ejyv2tSIKsIUJF7Po9IE80upqbXxyf1fCZBdllBJCvk4m+9CPTbOgX5w+r47s0x5q8Ujhci1ib04/aO6zMvotXjtNqiD8cLJeqhE4bOnj16S5o5tNjMAYGCH075QH7xLWO3sAXHSNH5dAmSsgH7amW8VUHHLANUZ0L3dEZd5gfI2Vfi91CwFJO92JXv3R5i+7vmf3WxlNsRjiAgF5Z6bLXCOxnk7LsyAEnqQ0wPQgv2yFML5X/kaWjjCEeCXozNbLGQXNpurn640/kzasw0K5QzcKLudVX5VPYpIpQz+i4x30aSA5qlERXGDrup1T/39a72KWLnisEwB5slPo6lkU9VMsN+CygzpcZQYcU+ZL9Gg85fPnmmOnKFlBivo0ATX80g==
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
- [Low] Docs/mm/damon: commit message omits MAINTAINERS section name
  update
--

commit 6bab7534a11559ea9b976bf2b9816f3e4a1d90b2
Author: SJ Park <sj@kernel.org>

Docs/mm/damon/maintainer-profile: use damon.git for patch baselines

This commit updates the DAMON maintainer profile documentation to direct
patches against the damon.git for-next and for-next-fixes trees and updates
the referenced MAINTAINERS section name.

> diff --git a/Documentation/mm/damon/maintainer-profile.rst b/Documentatio=
n/mm/damon/maintainer-profile.rst
> index c482690320249..cc6b79c066a64 100644
> --- a/Documentation/mm/damon/maintainer-profile.rst
> +++ b/Documentation/mm/damon/maintainer-profile.rst
> @@ -3,13 +3,20 @@
>  DAMON Maintainer Entry Profile
>  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
> =20
> -The DAMON subsystem covers the files that are listed in 'DAMON' section =
of
> -'MAINTAINERS' file.
> +The DAMON subsystem covers the files that are listed in 'MEMORY MANAGEME=
NT -
> +DAMON' section of 'MAINTAINERS' file.

[Severity: Low]
This isn't a bug, but the commit message only describes updating the patch
baseline branches to damon.git and doesn't mention updating the MAINTAINERS
section name reference to 'MEMORY MANAGEMENT - DAMON'.

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261121193331.1085=
87-1-sj@kernel.org?part=3D2

