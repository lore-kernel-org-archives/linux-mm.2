Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 131F8E7C6F2
	for <linux-mm@archiver.kernel.org>; Sat, 31 Jan 2026 22:01:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 480686B0005; Sat, 31 Jan 2026 17:01:53 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 42D976B0088; Sat, 31 Jan 2026 17:01:53 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 339466B008A; Sat, 31 Jan 2026 17:01:53 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 1F9816B0005
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 17:01:53 -0500 (EST)
Received: from smtpin11.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 87327C2A22
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 22:01:52 +0000 (UTC)
X-FDA: 84393632064.11.8485DE5
Received: from out-181.mta0.migadu.com (out-181.mta0.migadu.com [91.218.175.181])
	by imf15.hostedemail.com (Postfix) with ESMTP id 9D578A0003
	for <linux-mm@kvack.org>; Sat, 31 Jan 2026 22:01:50 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R4KcuKBf;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769896910;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IoNp8lAUZggjMNRuBTjqXS6Ph/tNW9JXJ8GGl+eg/vA=;
	b=Emie90C5NsdEiqr6xj/dQNS3cz9YNejPGfyky8Rfish1EsI6/FfMYPm6mDeY+9LIVO6WYo
	5FhO42LGLLFzP5z107lZuNPtFhqsbpbYrBiLn59qxyCGgEKjEPt8XD6hXfXfPChiJ60tSE
	1x7BkFDJ/XR4eDCDotdnPMSRlwj9zRg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=R4KcuKBf;
	spf=pass (imf15.hostedemail.com: domain of shakeel.butt@linux.dev designates 91.218.175.181 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769896910; a=rsa-sha256;
	cv=none;
	b=FG14EO5u0heNlMHs+qaEZiFNSAgeLE2mJ9g72KZAmmjUwS9PuGUhi1EN4Q5hk9q8KuLajI
	n/UFchTqF/8I97mud/KK6+S6UYWPjT6Ey3FS89PgHakngbko0YmLrZ5P6xryGHbO5bkS3U
	dea2dPLSoihosLz8p5Vbnd3xn4oth6w=
MIME-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769896908;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=IoNp8lAUZggjMNRuBTjqXS6Ph/tNW9JXJ8GGl+eg/vA=;
	b=R4KcuKBfhFTwYO7Y7Lv6/a8/QUrEjmRP6nSIE/P1vSGlydH2+kjcSnNwU/sQnDClTROohU
	uVU/e1oMBOAoJYTGkd9TBcNy2gkaEYc/PZUe7j0sAMR4xRjEXcUqOynIOwlS7aAiiTU7i6
	1KNlhbg23gME0V+AXLMccKscuWXxBCU=
Date: Sat, 31 Jan 2026 22:01:45 +0000
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Shakeel Butt" <shakeel.butt@linux.dev>
Message-ID: <d88b91766dc017e0705b7400b5b2aae313cc64e5@linux.dev>
TLS-Required: No
Subject: Re: [PATCH v2] mm: khugepaged: fix NR_FILE_PAGES and NR_SHMEM in
 collapse_file()
To: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Johannes Weiner" <hannes@cmpxchg.org>, "Rik van Riel"
 <riel@surriel.com>, "Song Liu" <songliubraving@fb.com>, "Kiryl Shutsemau"
 <kas@kernel.org>, "Usama  Arif" <usamaarif642@gmail.com>, "David
 Hildenbrand" <david@kernel.org>, "Lorenzo Stoakes"
 <lorenzo.stoakes@oracle.com>, "Zi Yan" <ziy@nvidia.com>, "Baolin Wang"
 <baolin.wang@linux.alibaba.com>, "Liam R . Howlett"
 <Liam.Howlett@oracle.com>, "Nico Pache" <npache@redhat.com>, "Ryan
 Roberts" <ryan.roberts@arm.com>, "Dev Jain" <dev.jain@arm.com>, "Barry
 Song" <baohua@kernel.org>, "Lance Yang" <lance.yang@linux.dev>, "Matthew
 Wilcox" <willy@infradead.org>, "Meta kernel team" <kernel-team@meta.com>,
 linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
In-Reply-To: <20260131131511.e5f1ec520fec066b22ca04c1@linux-foundation.org>
References: <20260130042925.2797946-1-shakeel.butt@linux.dev>
 <20260131131511.e5f1ec520fec066b22ca04c1@linux-foundation.org>
X-Migadu-Flow: FLOW_OUT
X-Stat-Signature: qh99836jh7iz37unqk9bwahhtgnwpcru
X-Rspamd-Queue-Id: 9D578A0003
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1769896910-386045
X-HE-Meta: U2FsdGVkX1/tB53DPSv24qt4UxlWQP+9PYbHG91vu7qpugOgEPawxAdYbvdO8PBc92HLqS3DdoAgLrNzxnP18/s4a5ciJBXvwXOuahLgtKDGnicgVXRc2W1k37Z8X+Xefc/cb5p3zf5ZUcWzJpa566imBemsKu+3eonsa12cSAwGyttzuDVXggiKum/tpDCEc3pDf91tD8AWU//IVdD0MpgCqFkIkzQnUO9w13hsBaQYaEkOA3iQhvBnao6xl9dZLdCTFDPNG/xVf9xeRQ0l2kLSkPVy/ADtNbP8tfzhs/hg/RQxe/rsWFkFdSPoHn6dLqGL29+Js7awvf4EVFa4243q6T24x3/uWuErjQG4Xn7hgBoJE89LeHh4TB/qt9KaU5fe6xTvkkkCWRD61siOm79CqQuRKJKIWWrbvXL3pTAmCvqtp4vooGN2W79LRrc3Ls2n8YsK59pNdmKS+bWwhZcy+8iXR3GmFh90vQSOJm6BybZ3UDKOy+/SjEqPi/unMqXjPCIjSlN12CFfaxa9ERTXiGgMvdwN5clKWhnQgagfdX2iWOL138JMwE+BwLS9yKyZ2mc9ULWtARWAqmf8HoZLwGjuTonN/f9L+hIe9lh4vpbvmJW204xW5s2ssvFu1dgQOvibv0Td2no1yc1iQFWyCBR8ngMmAui+eM10nQ8thcZb+14GVvZHcuSHppNenkpZIlDvUVlZebl9l+NBJ98HWD1mPW3ksnO8JEUkq6l1Ja8c62xU2VET/XxEYmH1zUCGHpOQtZuZCuZ1SOrzXbH1s2fMVOr3ATEyLkh+w6m++A3C79/Up87mB40M82JMRNgHlOxNQcmaBae7gilkL/r/6GRchA0PJZLzmtTBs8m8h4/4mqoZCJHH9cs2NItsNB0ASSUBuErqHSAcvkg860Y9frOp7PEeb7rmjziIIybMeUxFp1DN5L/bAqSHrBT2FExiKwe1h1doEiRdxCq
 ktdqT7/j
 iUM0F9jiLOMBAjQitCV1qi0BPGyxFTVYwSBzvIhOCRc/XWkKU6jlrYZW2QgG5LEvXqUbDMczLKcCG9l1eQxkp9D412N6e8yrDRa0tH24MvBc3GCSyF6UrQU5iyeHkbV3ynwstyrB8t0tKz5ZyRQIE1MuOCuxBNQh8fA2fwQu097vgJXVwDKCUGjNOcGNIlib0tIbshxETgvsdycxkrfjntXc+sWkBP7PLgvrrxIxUZS+36EYVhlv4JKgfmdupud9djktKLr9ZhWfBk9sR5CD2W9MX69xdeIzabOceHQ/RSpLzZwYh9Sl69dwMBz8PHBkB+Cmbgo+sGBY6hzZgXIt769ql7gAlw5p5Fi8j
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

January 31, 2026 at 1:15 PM, "Andrew Morton" <akpm@linux-foundation.org m=
ailto:akpm@linux-foundation.org?to=3D%22Andrew%20Morton%22%20%3Cakpm%40li=
nux-foundation.org%3E > wrote:

> As the bug is 10 years old I think I'll queue this for 6.20(?)-rc1 with
> cc:stable. Just to get it a bit more time-under-test before -stable
> kernels pick it up. Sound OK?
>

Yup, sounds reasonable.

