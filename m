Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CD26AC61DC2
	for <linux-mm@archiver.kernel.org>; Thu, 27 Aug 2026 08:46:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DCB156B008C; Thu, 27 Aug 2026 04:46:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D8B446B0092; Thu, 27 Aug 2026 04:46:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC8646B0095; Thu, 27 Aug 2026 04:46:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id ACFC66B008C
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 04:46:36 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 26088C0349
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:46:36 +0000 (UTC)
X-FDA: 85146418392.28.5CBF96D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 37E47140004
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:46:34 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXuyidQw;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787820394;
	b=gPhlaYj0Pv08LeVD3S2NzB0xJW3yz1RXyJf/J4ESpqAfy6aWcDDTX/EE8kVoKUTyL7kRFB
	2g7cQ604sy7Qm/ZLkXcN8MLQA9kNOE8roHhcMPkakMDxXgcsYZQipqAFDNJW4+Mwir7/ZC
	4ROJ1EWGW8FEgSih2jEcCdkn++iIyZ8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787820394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=784uPUxnXmdjZQ1kRjJ32yFBkoMi7jJfSK/kdFBuyNU=;
	b=IjuCUTsiube/RTjKX1x+D3bGEnlKRZV/eDJw9lOaxLOFPatQSumKZnSAmk9Tuc9+uMQ5/h
	vLm0A+4nfiV+msxCEyKw9jHO6Gb/3TRvNgOy1SqTmBsl1xMSGRzegphnBYxpVXoHeKv5bg
	AfqX3lyqIyKTQJr1KOrEhLbL6IWoN3I=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=MXuyidQw;
	spf=pass (imf09.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5F74543D7D
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:46:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 473841F01558
	for <linux-mm@kvack.org>; Thu, 27 Aug 2026 08:46:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787820393;
	bh=784uPUxnXmdjZQ1kRjJ32yFBkoMi7jJfSK/kdFBuyNU=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=MXuyidQwk/Zgk8w3+NI/w6MPMB0OZaxTRIF+B5IMhGA6+unsx5mB9a2TjK+3k2tU+
	 iQpk+r2+hbejWmApYL6ddCwUCw3jZLkPfN2mikXQNfErSGTOxRaY6RSzvqtMKiCmSE
	 CNkjDou/Y1OH2P27FGjWSbYOYIPVnztjqsjJuAlCLGiZCLNt20C0kVYuPPBC7F3ruV
	 qzsXV7pvIWlyJ0TMwkZkaYJpaVTiUMcNtJaYaVog2x8AxIq+E84hasVdXqkIAcbkvn
	 13O2+SOJoCMnniOXCabhv37O3k8EtvChRejhnQoWJQdmzF7kEoDcyhHNJ5lpqnQ+7/
	 v/Y+fTiAXAJ4g==
Received: by mail-qk1-f169.google.com with SMTP id af79cd13be357-92edb12cdf2so124489585a.3
        for <linux-mm@kvack.org>; Thu, 27 Aug 2026 01:46:33 -0700 (PDT)
X-Gm-Message-State: AFuF++m695HH+2Ez2nbjWjbu9fYQC3HwxROR18o3tfTW7caencX92inb
	kCbWVfRmDOqGs8qyHnOKJCOepvniQbZRoQthZVoQbrHs+eKsNmR8GNtEcgCS9gRPxSwytizSBXr
	dKr3JgRLgpMfQaztfvz6EOgRvmx/NAv8=
X-Received: by 2002:a05:620a:4056:b0:938:7751:c0fc with SMTP id
 af79cd13be357-9387751c37amr858807685a.39.1787820392579; Thu, 27 Aug 2026
 01:46:32 -0700 (PDT)
MIME-Version: 1.0
References: <20260821-swap-thp-cleanup-v3-0-9b43f5163238@tencent.com> <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
In-Reply-To: <20260821-swap-thp-cleanup-v3-2-9b43f5163238@tencent.com>
From: Barry Song <baohua@kernel.org>
Date: Thu, 27 Aug 2026 16:46:21 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4x7ukyX1nUikuZd6fWtCdAJyfH8zJt+yRPByU7pZ8PPag@mail.gmail.com>
X-Gm-Features: AcwNN1WxikwbEEtqYbvwE85-9z0wXWh1NODJWyhBapFeBjNBDCZFC5Ry8jne0oc
Message-ID: <CAGsJ_4x7ukyX1nUikuZd6fWtCdAJyfH8zJt+yRPByU7pZ8PPag@mail.gmail.com>
Subject: Re: [PATCH v3 02/18] mm/huge_memory: fix rejection of swap cache
 folios with a mapping
To: kasong@tencent.com
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, Zi Yan <ziy@nvidia.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, "Liam R. Howlett" <liam@infradead.org>, 
	Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
	Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
	Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, Chris Li <chrisl@kernel.org>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
	Baoquan He <baoquan.he@linux.dev>, Youngjun Park <youngjun.park@lge.com>, 
	Shivam Kalra <shivamkalra98@zohomail.in>, Kairui Song <ryncsn@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 37E47140004
X-Stat-Signature: 1owf3w63xgyo3ot8fxq6uf4k7mz14ig6
X-HE-Tag: 1787820394-586582
X-HE-Meta: U2FsdGVkX19SiRpe7H47pIvNf+/c20axPiMpbfXRVmwpDjCTJ7XgJIAwqnetOswwjMI23y+6lJZGhvIY2yt80ZWyYwoa+QS10TXGe44+V+Iw79F1mCzRxam6ql7T2XB+I8HgppAdqpOAy/zcwY3JHo06kumxpe5MRHApNoNBABRcqaQM00BOE0X+Fo/eHKcGAeL2BplKOZt042WqOD2kxHe26ego9AdhG3R2lDrSXCjb0nGg5kzoJqbuc8cV6nd1p85j7eJz4fQilM9GZ9Bi9tPnfaCsGIKv4s7NdHtOjOgOT+lSRVmRkt5VsFA5p0+7dGCp2b5apuIzFvkQmBy8xGlZIaJAORl415RcHhsVIzlnD4Auo8v0CzaaQcq5GEDsA9PJL5BTRGLMJDaAjUISf3XuI+FzrugmuigK851XYi235nxA01a2E1xdbbinPW0nxMRuLU5i3/NGKU4tXfOMPo+2EQk5KmzpwSborC2dIF3tCL/FAlpQceZ9KMEEJTUwE/me0mo0m8HEAeZR9TJw6jzJbK70WSR1uvq1WZI5i2LgOIb6o3h0pLoL8QZqr6BCbI1gTW78sYfL5YE74KOYRMQ9C6PQxXXLQdzqBRdVAWcxg5ZLHa8G6VDzg3dwy80DSzf+Iw1XmlJV/zEJINN2bE/8u90rUgUDEphbGcqT7MJ7egRjDprXB/KQrbzEJ0V8sfGdZxWf7SRUOjXBo4cjoGAE+gvuU1gRbXcuGkZDJuVzG8KvocSmSUT0wDY52QIi7FDYkFJS/YC437itcaiUvzsaMZFBXWZAChhQBAEI7SZmNKIThZROb9tFY4olptyQSOBGeT28xP6G5mkFDWD27TKuyJW+1MzelCjYitl/WxXMs/idMDPVFACdOMvsYRGqN5I+hNScvHV1VImxeE4SIsrrQenZOsS6158wb+/qpLw+OG2rzlW3kaasDj+tHFzHBQcem6vYtXvrKfcZgz3
 D6smY8Uc
 2AeiO/wAzesndQMbi/i4zoTpIb0WJSrOYpLWzvW7DXPBRHde+KvWc7ONdsb5geDZaDm1tg1u9hn0YP7CNA9fSbeFr4yOlYtKa5uTCTu2HJPpCZDXMRV4PIA7AU7gpAJKDhu51vHkTMdBlx4rM9rviKhk2K07RuO1R7ZUCD6CxeV7XrspxBfDXVhmWW4Jo3LGJcJCReHdOTnEeTd39tbY76HdUJlwIFIJ9nnGRT5taZpFdXQn3lichEPS19LL+KDTAlVCO3dSdx3remFTXT1aOX4TiF/hM54nZ+0IKSoUalKkV4Is11FU+Z8UV7u/lPevVEs9Fagx0dK80TKelHh+alICJhJDF0QNCx5No2Ga8XjSlcPLPpgV6fm0u5qRnjafxrx9H0WStLJVW9G3EvYdQKP5oNg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 21, 2026 at 2:55=E2=80=AFAM Kairui Song via B4 Relay
<devnull+kasong.tencent.com@kernel.org> wrote:
>
> From: Kairui Song <kasong@tencent.com>
>
> A folio in the swap cache cannot be split if it has a mapping (shmem).
> The split code does a defensive check for this in
> __folio_freeze_and_split_unmapped, after the folio ref has been frozen
> and the NR_SHMEM_THPS/NR_FILE_THPS counters have been decremented. It
> rejects the split and returns -EINVAL without unfreezing the folio or
> restoring the counters. That error path is buggy: if it is ever taken,
> it leaves the folio frozen and stuck, skews the counters, and fires
> the VM_WARN_ON_ONCE_FOLIO for a state that is actually legitimate.
>
> Check for this case up front in folio_check_splittable and return
> -EBUSY before any state is modified, so the split routine always backs
> out cleanly.
>
> Also fix a bracket style issue that checkpatch.pl keeps complaining
> about.
>
> Fixes: 00527733d0dc ("mm/huge_memory: add two new (not yet used) function=
s for folio_split()")
> Fixes: 714b056c8321 ("mm/huge_memory: convert VM_BUG* to VM_WARN* in __fo=
lio_split")
> Reviewed-by: Zi Yan <ziy@nvidia.com>
> Signed-off-by: Kairui Song <kasong@tencent.com>

LGTM,
Reviewed-by: Barry Song <baohua@kernel.org>

[...]
>
> -               if (folio_test_swapcache(folio)) {
> -                       if (mapping) {
> -                               VM_WARN_ON_ONCE_FOLIO(mapping, folio);
> -                               return -EINVAL;

BTW, I=E2=80=99m really curious whether you=E2=80=99ve ever encountered thi=
s warning?

Best Regards
Barry

