Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3F75FC79FA1
	for <linux-mm@archiver.kernel.org>; Tue,  8 Sep 2026 11:55:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3E0466B0092; Tue,  8 Sep 2026 07:55:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3B78E6B0096; Tue,  8 Sep 2026 07:55:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2CDDA6B0098; Tue,  8 Sep 2026 07:55:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id EDC886B0092
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 07:55:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 8A97E405F0
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:55:05 +0000 (UTC)
X-FDA: 85190438970.01.1C956B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id C011014000B
	for <linux-mm@kvack.org>; Tue,  8 Sep 2026 11:55:03 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3u+q7i6;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788868503;
	b=Mc69RblWeqS+XsTgYpTUmHuU8dr0zums+XAWBUt8eocPV/iurMM0HbJJoDXMVeRmcg8EAa
	uoPXuE7F6e2eZypVr4j/Vi+4wqqYv1yi56K3/AK9dBYssRYG1ZWrMVlEEXUNm5HSNtPVbX
	kSAKFO2h7XN3jGY5DQlIEDCGKOPDDMo=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=O3u+q7i6;
	spf=pass (imf09.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788868503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=A8fGRJH1FYroE0NYq5pSQ/cdoutdIPA6KQGFv2lno1c=;
	b=QoM4PuPMFz3vKiDxTWrp3smp/1us1vHpmZV3DUs9XenCwnBEwXMFvyvYMRit6cmVm0jNBJ
	9HECD4gtNsZCYmej49mRaBLlmIFqXSoC+FudEJx2M+MZttxs7PtiyJoAZJT4fS1XJs1IVx
	dxZt5tovT+SIBNVr8rtpQeXMRYKbKPs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3F1AC601DB;
	Tue,  8 Sep 2026 11:55:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A4B91F00A3A;
	Tue,  8 Sep 2026 11:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868503;
	bh=A8fGRJH1FYroE0NYq5pSQ/cdoutdIPA6KQGFv2lno1c=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=O3u+q7i6QeyYtTqdVxTUmL8k11LRAGHiZTHWhr6k+T3QWv6q7uS4HDzW9FXq1Vocr
	 SfFiOd7fqggCnDd2KFkF97idrc43LCaE5VM4g73AC4KFodCx9IS8NVTRZ1KwUon5dx
	 sOPyvNX1DYrdEcKIRct65bFM1sBOPHn1EK5RaRsYsZLLxKPMV52QrFC2VPhVP+HAGW
	 wtRPwv0O3QLICXC6EzOUSW6JiBETKuWAGceK1oJLhtLPEK0ku3vozxteWTTI3oeqid
	 wTKMiFWoWF95fUnjr0pHc3MnXao3Wsq4WWSN979SZ3M7GC0Ay8nzXRdbC638/yfE27
	 7hZMc/MF618PQ==
Message-ID: <d202dcc3-d7d7-4e98-a9a5-3137cfbfd041@kernel.org>
Date: Tue, 8 Sep 2026 13:54:56 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3] mm: remove min_free_kbytes adjustment for THP
Content-Language: en-US
To: Nimrod Oren <noren@nvidia.com>, Andrew Morton
 <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <brendan.jackman@linux.dev>,
 Johannes Weiner <hannes@cmpxchg.org>, Hugh Dickins <hughd@google.com>,
 Nirmoy Das <nirmoyd@nvidia.com>, Dragos Tatulea <dtatulea@nvidia.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260901190123.3511535-1-noren@nvidia.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Autocrypt: addr=vbabka@kernel.org; keydata=
 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
In-Reply-To: <20260901190123.3511535-1-noren@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: C011014000B
X-Stat-Signature: x8qcs6ino4iwqnfwr83zg3xpnqg9zphs
X-HE-Tag: 1788868503-315673
X-HE-Meta: U2FsdGVkX1+ZWGkzRxXxGEs9KonWpeYF9QVZBm7lflTk5NhAofQeFbUv1VNe5IbQtsuAL8Pq3N/HFXFnxjx75xht3jPZqTz2ASIPqV1z2pQho33PW85JA2nmNx8lhxq9XyBp2EGfl7XIeCAu9D9OR3spaF9SD45Tjuim6HuSLRqGJLpYGeVEvYeo1JTvZXVc2c0wxTU0nqZrvoxuqZC8QR10LWuGScC9l6lFK/6eoXg7VOtvYfQdLcIqerT9YT8PclSTT6Q/dxuAL5uFA1t8hkyx1FYcDgDkY2cnRzxJXOKiiDxDwTJmp5AfSVVLSlAGopAvYMAe0mo6lGMEBwiFn5Y801xoljjsc72B3dRTSDRftuEbxqG05pB26d+rT2FzL+k6Xh8Sbz4eu++K0VwQxDxxZp8tzkCdXOa87rE9ZJGapTH7HRL+hdGpiJeuJlylBFJZdBs5e2CQfdIYsh8aib6w+bn4R01nQDKnTlBfv6j7cicJhVwlyxqL/44V5DutwTurcaT7vTVDJnxrNiO0NfNbnSmygWRBithK+GIyECkMUrdWN84rfzhN33H1rcseNs5UFLS79qIZnNyIu00NYSTNlRSRbYUChgdZcxTNWquPnH2B0Q6UfH93aZXO0nRrn3yyvAcnx7oVgNc3gL3y/24ysGV/Qp6ww8TxJuGc/Ws/c6mZaPGsWa7z+x5zCA/t8kkzpus6unVCsTKMoQDT5KJ0y4CQ/cYjYPVsKLtM3CHs4NN3wWk48E9CAeWRmupYi5gW4RXk45giZTQa8VhMZRlYgHAudGcz4JYMghO/HUxnpAFVCjK6S1ps9jajLFSb3+lBl55aUW6qkKCH8mup8S0fWWW7wfkxOn2zynzJHdOSt4QBAyCyGm3lGl4EBc7a9RHZOMf5fdhqEXOAezsATO037kKPkCEpE+RdeZusV7vyHQQn13Z0ZD9vkNgG+OxIDXDOMKCme0vIM5YHy9r
 7RPvCpqI
 AYGcTkceO7Bo2uz4xLHtKTJiVs8mnF2fYhdE74KS4upFCvKJkbmXPKB2rSBmAIX4TGCW6oD7qM73tOqFf7fJlMC2UUuUKxUA52r2wcqANxO1+TaTejg2O9TVNk5mpKXx1hDzEFT69BN5yz6zqqCWkOQB5QUrWFwxcJdeSfU0SdOoOoRGomoo/cC/EzFSgNGWkOV0ap/qKS1jK0gae1U1ykksySEJznsc5b8tskFPMTGv/hx7bG6Adkf/FCeUIvMhKZK01+ZPGgl+7sbwNzptYgU1jkLhCRMESVMIF6lnjJz+ou/b7sqOp0z99zfq5XpXg0hquWO9j/0CtKEnmC9C/zig7at0VM+k+L45sImZAjxZUKmeU0N88puyc+dfDvZXXnWUqIvFkXWowWVNINKdFWBZRFg4tjgiu5rFo
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/1/26 21:01, Nimrod Oren wrote:
> When THP is enabled, set_recommended_min_free_kbytes() may raise
> min_free_kbytes using a heuristic that scales with pageblock_nr_pages.
> Commit f000565adb77 ("thp: set recommended min free kbytes") added this
> heuristic to help keep pageblocks free and reduce fragmentation for THP
> allocations.
> 
> The recommendation scales poorly with larger base page sizes. With the
> default arm64 pageblock sizes, the contribution per eligible zone
> before applying the existing cap of 5% of low memory is:
> 
>   4 KiB pages:   2 MiB pageblock,   22 MiB per zone
>  16 KiB pages:  32 MiB pageblock,  352 MiB per zone
>  64 KiB pages: 512 MiB pageblock,  5.5 GiB per zone
> 
> Even with that cap, min_free_kbytes can reach excessive levels.
> 
> The automatic min_free_kbytes increase predates proactive compaction
> and many subsequent changes to compaction. Given those changes,
> increasing min_free_kbytes for THP by default is no longer clearly
> justified.
> 
> Remove set_recommended_min_free_kbytes() and all associated
> recalculation paths. With this policy gone, min_free_kbytes is
> controlled only by the page allocator's default calculation and the
> vm.min_free_kbytes sysctl. Users who want additional headroom may set a
> higher value via that sysctl.
> 
> Link: https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> Suggested-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Nimrod Oren <noren@nvidia.com>
> ---
> v3:
> * Replace the 1 GiB cap with removal of the THP-driven min_free_kbytes
>   increase as suggested by Michal.
> * Remove all associated recalculation paths.
> * Make min_free_kbytes, user_min_free_kbytes,
>   calculate_min_free_kbytes(), and setup_per_zone_wmarks() static.
> * Drop the now-unused declarations and khugepaged's page_alloc.h include.
> * Drop the obsolete v2 documentation addition.
> 
> v2:
> * Use a named constant for the cap.
> * Drop explicit linux/sizes.h include.
> * Update min_free_kbytes documentation.
> https://lore.kernel.org/r/20260831075635.2244437-1-noren@nvidia.com/
> 
> v1:
> * Cap the final recommendation at 1 GiB as suggested by Lorenzo.
> https://lore.kernel.org/r/20260728202014.2517142-1-noren@nvidia.com/
> 
> RFC v1:
> https://lore.kernel.org/r/20260716173504.760369-1-noren@nvidia.com/
> ---
>  include/linux/khugepaged.h |  5 ----
>  mm/huge_memory.c           | 14 ---------
>  mm/internal.h              |  8 -----
>  mm/khugepaged.c            | 60 --------------------------------------
>  mm/page_alloc.c            | 11 +++----
>  mm/page_alloc.h            |  2 --
>  mm/shmem.c                 |  7 -----
>  7 files changed, 4 insertions(+), 103 deletions(-)

Given neither of the patchset versions achieved universal acceptance, could
we try just disabling all the automatic (re)calculations of min_free_kbytes
the first moment the sysctl gets adjusted from userspace?


