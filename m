Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 07FD0EC01A4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 09:00:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6F1756B008A; Mon, 23 Mar 2026 05:00:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6A1B86B008C; Mon, 23 Mar 2026 05:00:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5906A6B0092; Mon, 23 Mar 2026 05:00:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 47F036B008A
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:00:48 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id CA3595BDD0
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:00:47 +0000 (UTC)
X-FDA: 84576732534.01.AEDE112
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id E6F6A120016
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 09:00:45 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JvFDw6oG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774256446;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Y7DDDRb/BVWuufu3jEy9sPjkdCSkvFmi8NPMUDyNP78=;
	b=15M8g926ae8bxr3T2gtUbPpu/R/3p+e6i+BIUDa0SzqT9vEZ8g3Q85QDLGTTUpfVs/H2Jp
	HRThkSHuqLBx0Tl8iBwbhbbxST0ZQiShhoDUNDbOL45TG/cTm23IbjaJrhzfYpK12GheRl
	hIcTqGjnxvwtZOVeS/xtHbC1FTBAJl0=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=JvFDw6oG;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774256446; a=rsa-sha256;
	cv=none;
	b=1GModaJPlJz0pko2ADDZfW9gozEPUI6fd5uhn+BlZ2QGB8RQ8oHMdBRxvgNs1mCIb8VR3k
	Uc+r4rKxOccNknhqIAYycHnFC9rAWBqwqPmR08vhjKKZypBUSG4kgLynaQG7o/RuXnB7tP
	O1zmktiHhcanLncKRoIefvbx0zc5jS4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E16F442D8E;
	Mon, 23 Mar 2026 09:00:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB6B7C2BC9E;
	Mon, 23 Mar 2026 09:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774256444;
	bh=MRMti5DI6Sp3ui/HK9pksJ+EstcUlnUv0hNW3NmKJ0Q=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=JvFDw6oGVlXe5qLbf9DXIMFlzI+yrWsvt4Kf9leIejV+EllhW5ASfBhyWcaGFs/yg
	 /rS+2rYvRWR7Dl0zTbsCXjGRGAmFz06UEbubXVKh5RJM/w/CCCy7yZpQEt+W7LY89+
	 Y0RdyjgsUvytEqXBBdsshthR0vvlEsA7q4N4c9sED5AvXBGHs5v2KZej72h5ITi8+c
	 Py/aDKg2/mQO13j1rp/aUSqaHAC0FjftSku5j1fPVVodvu4M68s/VhAeoCmxFPQMbf
	 6p+B+sMWZtt5b6DqGgYU62vTD1Zz+1FGZat+UsXcbrHaqYlKNmfB0mNas6P/XUH3Hc
	 SvG8VsTFnd3Qw==
Message-ID: <533976f1-b295-4d66-889f-bd10142a1f89@kernel.org>
Date: Mon, 23 Mar 2026 10:00:36 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v6 2/4] mm: huge_memory: refactor anon_enabled_store()
 with change_anon_orders()
To: Breno Leitao <leitao@debian.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Zi Yan <ziy@nvidia.com>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Brendan Jackman <jackmanb@google.com>,
 Johannes Weiner <hannes@cmpxchg.org>, Mike Rapoport <rppt@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, usamaarif642@gmail.com,
 kas@kernel.org, kernel-team@meta.com,
 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
References: <20260311-thp_logs-v6-0-421e30d881e0@debian.org>
 <20260311-thp_logs-v6-2-421e30d881e0@debian.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260311-thp_logs-v6-2-421e30d881e0@debian.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: E6F6A120016
X-Stat-Signature: fi6t33uudabys1kmxftpy3pi9zc3uzfi
X-Rspam-User: 
X-HE-Tag: 1774256445-260440
X-HE-Meta: U2FsdGVkX18PBW9Ozp1B3KYPGac2nzRr/+IHKLKSyTpxhZWIvEb4YxrdgPpHgip7Vc5JRLQliPV61wxP9ffURq18Oa0bTrQzNYawiPgNiyWFntInsNAaIjT3HrvXlETEv4j/zmm2Hnvdan6fXR753dDGgK4PhXGsUgSSNDCEtK/ARUrda+CDahdqnBG/MsTeHVLUDINZ887lnVWW5uccxQe8FAXJqQVd7zafZrzFkPPOwTuc60QIhWguph0OYd6n+2owyFxmCd56oBe+sA5mqf9pl8/YwBkchVcXusSXg2uv7cQWY8TbVU3jXPiw1rM80SiiuTPESXKHkS0O2ILb3q6yeMyxnn04clc7AEGnDcOuVITpmUW5s4NUlElKqC1VIOdRmYpjX+0kEcTO4kVEf+LkrxeKfqk6IheGIi4dN1j3t8VwZyWsdqJ924xC7ctDiI0g8OM6CSG9xWIdN9Q3w/HCkq9DQa60e8ETeSMQo0ylOwbjBhFHR5wDI/YRAUVnmmkljIR1TvIcVa7e5zWft3Fev44D073piIxehBcBO/Add4rXEi0TSN2yzpBPFHUwWYDSxz81z5jmmyRjsxb9/SdvFAOcdchTfU+VUg4U8MCekbosD0QlNIipcnON3DcJHiFoRhCqXQPRQwMyoVTrsqabStXCvqsc9lpA05WR4d/RIKjr5HWxF/46iSErIpMYQcn5MWvdpG0ur/nh1rV5Kl1k5RIkr6d5bW1K8G4PvUB1dD0L2CN/yxLSVZCO4Lfz85D5hi8LHTjAOgNWyPZ+IOynml+FiTcwVnUTxR9ShAplyHcIlY8+ieJjd0WdgZw9a1It4/bw3bSWGzbLhQhPDjppP6iL5lofdgn0msNOU/Cay5RDID/5Oi7lG/CscDEW/kE51QBs7Zv8kJAv9kGxiC0dlriq6m0mpl18Acd4JeiqMRZdeK4q/OdYbghRtUQq7NfmeCUa8PbVKLwmHRl
 uvARrzGH
 c3kj1iZYcNFDsiYlQpJiBed7R64n3SldMyTJf/0m3ovYpJMH7BkQopaEP8XWRLk1afIkgM/+v7c+Nw/JSdNITyefua6Tcj+gvgp37eKR6QuMVqTkWQvHeUaMOIWVbmn/SKTPk9Pd6ixLFHM4xKwvzQpcTlNHOwT29VThHQ2jKK3W0BkUyP+qsWpSgepbGR88lfdHSg7Xw73RvXBQabBwAN6+b5MbbEyrl064gmOMuE6RbyJAyezgO7EAvcURdJTQcOEjAFUe6CYxkCPdypYoCq+JfK54j9uTiTJ7c2isHbIFRtHtmZJxVY+Wh5WpA3r1YRA6AEAfsnojGP56QL2aEn/fW8SGpCVqsl3eY
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 11:17, Breno Leitao wrote:
> Consolidate the repeated spin_lock/set_bit/clear_bit pattern in
> anon_enabled_store() into a new change_anon_orders() helper that
> loops over an orders[] array, setting the bit for the selected mode
> and clearing the others.
> 
> Introduce enum anon_enabled_mode and anon_enabled_mode_strings[]
> for the per-order anon THP setting.
> 
> Use sysfs_match_string() with the anon_enabled_mode_strings[] table
> to replace the if/else chain of sysfs_streq() calls.
> 
> The helper uses test_and_set_bit()/test_and_clear_bit() to track
> whether the state actually changed, so start_stop_khugepaged() is
> only called when needed. When the mode is unchanged,
> set_recommended_min_free_kbytes() is called directly to preserve
> the watermark recalculation behavior of the original code.
> 
> Signed-off-by: Breno Leitao <leitao@debian.org>
> Reviewed-by: Lorenzo Stoakes (Oracle) <ljs@kernel.org>
> ---

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

