Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B0752C61DB9
	for <linux-mm@archiver.kernel.org>; Fri, 28 Aug 2026 07:03:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 831B06B0088; Fri, 28 Aug 2026 03:03:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7BBA76B008A; Fri, 28 Aug 2026 03:03:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 683546B008C; Fri, 28 Aug 2026 03:03:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 421C56B0088
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 03:03:48 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id BE6DE1202AB
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:03:47 +0000 (UTC)
X-FDA: 85149788094.29.C5C37F2
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 00259140010
	for <linux-mm@kvack.org>; Fri, 28 Aug 2026 07:03:45 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ki8OfKvM;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787900626;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=p//1NQk8zitXXmAblFVKjcBJtvf/rTZ2sm2+PaGQkb0=;
	b=M+dYE1ef6euAXdn2/En62/irIl7fCCwXDBlA/bDpvTC+a1Bwp8ol3ZXtp3DFupAZODPu0c
	ePprz8DGaVjPR89pDEgku3KCRc8HzR1SbxcLnpJNkcee+lv2rmnBXkarY2GDdgryVSvWSS
	BvTqnusAeZPN6QeOirNVltax69gtEIs=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787900626;
	b=P8nT3kbGPwACUu8jNJKQsOw5QqWwBI38/IAcQt9JRknOTH+t5JwCzLMnSEVbDMLuwaH0m2
	CYmIxWAqkyxaHZXiJYkMg0ULup1fABPbDq3b2lVGKNfOy8h5gKeJ20N+78DGMQZSje0M60
	u+pa5gJ+AuZs9K6YP77eau/sEEiy/40=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ki8OfKvM;
	spf=pass (imf26.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D73760232;
	Fri, 28 Aug 2026 07:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12D921F000E9;
	Fri, 28 Aug 2026 07:03:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787900625;
	bh=p//1NQk8zitXXmAblFVKjcBJtvf/rTZ2sm2+PaGQkb0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=ki8OfKvM3u9p9ZN630u3+Dhrf8x/975NSVli+DdfUHiM9kKWSTkNfSvNRDEwby9g/
	 7DFg/MvZMoR7jtGIC4+Ky0GxCCQImi9csbVg31qHRNRdToXv/PxzJBxOEBZMY0T6WY
	 WJ2SmHWmojZEE/lJ2odmNAWum1A3Z0W8wd6uCG6BH+W/x4eo5EkGIhJR1uiwDQ6HO8
	 j0GnumKf69ozYWwDDLW6DI9hMl0Nr1GoVZ1YOKRzK8hMv03LUsNKm6aLjKT/sHCtcT
	 SGHbS7zgDNduqDtZFm7MNiDeVcwpHZUSXWC14dPY9rL0FwDNbyvm4a/ImGccDgBpLz
	 KDbvKMuhX6R8A==
Date: Fri, 28 Aug 2026 08:03:38 +0100
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
To: Zhen Ni <zhen.ni@easystack.cn>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	David Hildenbrand <david@kernel.org>, "Liam R . Howlett" <liam@infradead.org>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Jonathan Corbet <corbet@lwn.net>, 
	Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap <rdunlap@infradead.org>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>, 
	linux-mm@kvack.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/8] mm/page_owner: Add PID/TGID/COMM and cgroup filtering
Message-ID: <apEx0wT_hWs1Q5Wp@gremlin>
References: <20260828031339.1270699-1-zhen.ni@easystack.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20260828031339.1270699-1-zhen.ni@easystack.cn>
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 00259140010
X-Stat-Signature: 1g41gwfye8yq44kr7a9rwodpzub8fy59
X-HE-Tag: 1787900625-396909
X-HE-Meta: U2FsdGVkX1+7f0FcoaBRy0vgyBorlIO1JUEv+fRmg2SfmROwpT+FzoUptmxM0Pm5zTdt9PoJ4AAMIKiT9P6qjuBmM23yOXJvPUOzdcloLsPCP7zsITiLhMjUFDp5pzjVH4thhRpTI1MTo+6odbdyvQ2A/oBNwfDA2P2Ro9UnVS1PDXP/Szuv8aYHOanrjHoMhJoDJezVwbz4qRnKa+kIJVI25lE3oao2Z2Pr2gLDXzRip1Mp87Gwa4NWJ9EReoLXUJLHUGcdAE9+bgKGiHdyoWz5STTFAMDzk3zDicZUNA+Yw8vcwCqmmp9LW428tgnga/sF1VUwfcebxgYb33cq3ndvtxps/O6FlrKolOPrhmTNMZ4AVjp8r4PVQ8w/JGwHDNbcBlK0Dj6eX69H3RhabTqDRLvVNliPbYrGYi1MljF24w2SwWF4H3LScLD+q9fEwgYqUMCBPFM1U2mM5M25xp0/pqdvpQ+AcBKgIV5QZfA1/1dDM7nlNth3SKnObvSgsQI03PVdhYFVm1xL7iRUd4sva+yvsB25caouBew/AJrXU3HI2vuvQ23pYPsQGpVFcWL6X31WB/7oPEm3z3JfgdKYLVbLhUNo/NtLOdLqzIpeg/ONMwg/FFqxxDPpWrg4jToGUOqysQ+X+Imwap6kV++eygJoh9/lkjkX/Tl33vgtQGF50nuLjzZ/nZVgdMSgyO9TziEJXteReDS9+sb/kZZh5TGQ2k/KHb2qfoWPKhr3caA8I3IWvo/bFX9ugGRy7IuzHrEWUgnc6vfROL9PeRQIevhlH3H1tk9XqrH/Wp/7xllXZV9MSnf74p5LutDniGJR5zIVPQ/UJGy+jXbV1R500KsQdTXE7knIY3b1EyDH6lx/wGLBDf+l0ETqSt+VWM5PxmJ6DOLpNuDYFb4jUwI9ILSn2rB+lEy6+fMZ0hTRaFIbKIVj/Zs851BIuBXsAWkEkHAFXi4QlXJcYh1
 MnHQODN4
 w6nA3G+B3o4MIh41Py6Hj5YX3Y0gc9r5I5RCzsIN8yzAjKbIpWYjcKVSJXuKncMPAMnbuswB9LDtJX0OgSajW+dKKCgGA/g6p5TfgoamyETeYCBJdUWCYM67wmUqz44ZHyiYh9Qe1i8l4X5+xncj5zstWB/6H5GCDr6UHRYek7uBWGSCHwoj+mPYTNw0u/9LlVkj+c5wzkwZ4kaw4Qp4+qngP5Yb9RMlMhu3qjMwVOgvGPzwy6+KOH1YaP8h0NuGLnnj7nmREvks7tJCWgA9LsbzeV+f7a60PQPbXlIcN9fqEcWYXUVaJyWlp7/dAOd60ErAG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 11:13:31AM +0800, Zhen Ni wrote:
> This patch series adds process and memory cgroup filtering support to
> page_owner. Following the previous series that introduced print_mode and
> NUMA node filters:
>   https://lore.kernel.org/linux-mm/20260707115411.1714314-1-zhen.ni@easys=
tack.cn/
>
> This series adds filtering capabilities to page_owner, allowing users to
> filter output by specific processes and memory cgroups. Users can now
> filter page_owner output by PID, TGID, COMM (with wildcard support), and
> memory cgroup path. This makes page_owner debugging more focused and
> efficient for tracking memory allocations in specific contexts.

The majority of this cover letter feels like it should have been
documentation put somewhere :)

I mean I like to be verbose, but this is slightly excessive :P

Remember that mm places cover letters in the first commit in merged
series...

Andrew - could we not do that here, or at least heavily truncate it?

[...]

>    Test: Cgroup path exceeding PATH_MAX
>    Generated path length: 4101
>    ./page_owner_filter -g '<very long path>'
>    Error: Cgroup path '/aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa=
a': not found or no memory controller

Also let's maybe refrain from >4000 char 'aaa...[rgh]'s, I think people get
the picture without needing all the chars :)

--
Cheers, Lorenzo

