Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C6BE8C54F54
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 19:01:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 32B256B007B; Tue, 28 Jul 2026 15:01:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2DE846B0096; Tue, 28 Jul 2026 15:01:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CCCE6B0098; Tue, 28 Jul 2026 15:01:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id D83706B007B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:01:24 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 41EDFC045B
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:01:24 +0000 (UTC)
X-FDA: 85039103688.15.BD21EE6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 703D1A000F
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 19:01:22 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oepwlxHn;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785265282;
	b=6PXi0/nLDcxWmx1DxRBR7aGOlh4jmNQOVaULgmr9miX+wZNDPXQWW3z2IHBBNoQGcU+3u3
	VDWUwlTKL/jqZ0UVnre5bKbksdq6wejY2vy6WRDrqGhgAsjrQSotjwKzHyRAr22YUwdXG2
	eJUo8nCMwLCer6VBUWm2F/8888ui640=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=oepwlxHn;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785265282;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AV1Nv4qp1K5kHtg080G8H45YsblDUrxFOLCmgn7R6zw=;
	b=woJcG1jodqLh7aKi5H0e3UN4XttMV83zyDdxoYHBOSBYrAr6W2MAi35E/p9mkfEKI8fEMQ
	G1ee0uxs3s+Pdr8scuruhPAGY/Xkla9zVUp6Hzd24Xda+8n1Km3CXEvpGCE+5d/h7gZEgn
	fSlIIDrhUKtlDmrddahX83oI8XARbgA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7014440B08;
	Tue, 28 Jul 2026 19:01:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CF691F000E9;
	Tue, 28 Jul 2026 19:01:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785265281;
	bh=AV1Nv4qp1K5kHtg080G8H45YsblDUrxFOLCmgn7R6zw=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=oepwlxHnOmRfh3pX0SUHSbK77m5qX2t05E5d6/5NRfOZFwI7PjGCnbFH30HSefbvi
	 NBkI+RAd46u7ZHVfo1oQDIh2dYXAtKVINfjbv8DxiYmEShio/oe2JVwWaSAFlC99Wc
	 C2b9iS9EOAqzRoI8Tkb4Ty6Nj2yg4F43TqO0IyMd6eS8ZKuhbrwqtqvT0UtG06qEqb
	 lgmjvBkcVSbfV/8Jjk7+RZ558nwRPNpDlgwsq/glTqM56awXHyLd1hS8ZlKAJMrCHc
	 VxUJHW7ENXx9fNFAYGmRYYwbrm8HHS0YXgFW+w9ORsjx4ScL5526eEvm+6tbatAQCl
	 dkfYhki3qLnmg==
Message-ID: <b8490d40-fa93-447f-aa3d-d4a5a6f4d43f@kernel.org>
Date: Tue, 28 Jul 2026 21:01:10 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/3] mm/huge_memory: add folio_split_driver_managed()
To: Zi Yan <ziy@nvidia.com>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
 Matthew Brost <matthew.brost@intel.com>
Cc: intel-xe@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 David Airlie <airlied@gmail.com>, Simona Vetter <simona@ffwll.ch>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Matthew Auld <matthew.auld@intel.com>,
 Andrew Morton <akpm@linux-foundation.org>,
 Baolin Wang <baolin.wang@linux.alibaba.com>,
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <npache@redhat.com>,
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
 Tvrtko Ursulin <tvrtko.ursulin@igalia.com>, Dave Airlie
 <airlied@redhat.com>, Matthew Wilcox <willy@infradead.org>
References: <20260722044220.1110278-1-matthew.brost@intel.com>
 <DK564OOZ3JUK.292JORO9KGKEV@nvidia.com>
 <DK57FVTRTLR2.1A906PYJ2TCE4@nvidia.com>
 <a0c06d8c-fc3a-4ede-8aba-8c7430027a35@kernel.org>
 <2FD2B991-09B3-40EE-8230-49BE3A239EEC@nvidia.com>
 <603ef1ec-bccc-4fe4-9523-e8b8a731be63@kernel.org> <ami_wF2QhQ1ZM6-f@lucifer>
 <00499B8B-F546-4A4E-84A6-126BAE5BC239@nvidia.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <00499B8B-F546-4A4E-84A6-126BAE5BC239@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6uca9ikfr5yiq4s5jgmp9gcnwsw3u6a9
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 703D1A000F
X-Rspam-User: 
X-HE-Tag: 1785265282-268884
X-HE-Meta: U2FsdGVkX18EMNVShJkPSQKWeDAkaoN5fozNH26JZTatVff7ZKTZkSfQI9ROiSYYXJFAk8os866FRnVFblMEJNRmbRr9KVu162rhW2m62tMrGyat5T6aA9Hx0bF7H0ZrDwWzTJlfKbL48MCAmEeHTr9m3HkYDUosh37yCVdi7hSbmbPQzMjytuKA68RO23772657Zg5JyN2MAJnHWicPCCBOwldhzY3zTvqP18o5PogXerT8dHVTMpG0Rr4vhtFNjguYmtozAfPJLSVL+8yC+XQ109HHp3RIwtztUDDSZeLfpYxB/akdMRyHUkMXJbE9sgW9f1NsHDFY9T+bYbimwulE1HbN68sjcWLRMvcTLAIy+kEjO36Jclmn3DaPVthm5NEuM2UC4LMXppo4HOJHxywHh24KS67vOqEJcZgDya5TbuZVLEvxEJ0ji1G4ubwCgq2E+SbO9pv7kWkybFSHQv7m8nMn52vWD2FJudJS1vXC4pz6Dn5gHurKbJmHDzRMFD4bFpoBMevCt5hfh4uogOCFdd5HVknOxDoThkDyRWc5GSTY3gaVeNyxSpcsGPYU1IGORvgyv3V62QMxFTuS5pjZlbcaDuC4LgV7C0/aMcYp3vf8FaZ8nIud0iv8BB5bwcxnr/JAe/A1uLbqoTeTsOlUVDrrGqlE0dxZQr6gEPs2nUiB0vksGJXpptfbQ+bkipUCh4juGJ2d3SmO5rIGqEGuq53t7L6FRCl1Qa52puIAlN9Xy219wRd8Q3deQtVej0szuA1yh6362y7LzI3WT//9qthEIQ6POpn+l0/MRgMHjszGcSQJqkKbeE0dfStGHNbnRnoH1EC1on0biN3MmAYLmyxDTtZhwGNGsVEBn4aEyQueUht/zIulHM5jov3bAyuAfV1xzETgMeZBb6ZrTwJU/1RR6cH7Zc+H9T1QhQARlt9bOHk9RxwZelrpxchVLK12Fe67Ab4wsIUF2S2
 I/eIGD5d
 IPd/KDKu9X4eoqP1OzcHRVSYWfI8l8/J5qfOAO+iVqXda6KlklTMrpqa78VzO8ecohGZhbO/3AW6JjUD3VYE45NoJb2jXza7xrmnvgQod9n+gHwivOwFatiJKu8ujVQstuAEvUnBgFB/cZWW7k9H6ub7xR8rytZug57qk+llr6RyuvJQ4xXJ//dZ3lkoQ5tof+24rh8cKbnP2Rrpi/lHjCVYU+FfLdrP9OvwoJZS2QVGoX3vme9Wc+QmKjp5G75RqBG2EYtKu5GOP4PyZik0dfCyEOc5Oh2Uwot/NOlDGjhZLuCiATkfMAdUWneUE4P0DHR4+oujZ7Jb6mDU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


>>> Because splitting a folio is really something different than splitting just some
>>> compound page (no mapping/pagecache/whatever involved).
>>
>> Yup.
> 
> It sounds like split_compound_page() gets some love (David, Lorenzo, and Matthew
> all want it). I can add one to mm/page_alloc.c, so that Matthew can build
> his patchset on top of it.

In there we should verify that it is neither slab nor a folio. For now, we can
only test for folios indirectly by considering the large_rmappable flag and
hugetlb page type.

Likely we should simply disallow any page type for now (and large_rmappable).

-- 
Cheers,

David

