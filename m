Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 267C0606A8A4
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 10:15:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=mugwqvhM
Received: by kanga.kvack.org (Postfix)
	id 15DA16B067E; Fri, 13 Nov 2026 05:15:16 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 10F726B0695; Fri, 13 Nov 2026 05:15:16 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 025306B0697; Fri, 13 Nov 2026 05:15:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D4CC06B067E
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 05:15:15 -0500 (EST)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6BC40A833D
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:15:15 +0000 (UTC)
X-FDA: 85429688190.03.F7BFD3B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf18.hostedemail.com (Postfix) with ESMTP id BD4B11C0008
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 10:15:13 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mugwqvhM;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794564913;
	b=KkBa6iDmKYVNcmZdVQzPVdQ7gopMVbvEriIduQLS3dRKsUxk6UUTpsZUmcpW3AgVrRbzWG
	ToOnqeiunbvfqqp62X73M9IvhOYhG0eDr/lwwMYa3gEDo5Km+3voeabu1mLGITlHhPwthH
	7TLu53f8Z8Q+y6pkPaZhB7zO2bjGVVE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=mugwqvhM;
	spf=pass (imf18.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794564913;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rMuyr457fqCWZXx15HHMmpYyTiHvK3jp03BAUYi6K/g=;
	b=LwifpKpSB9dR25SDLqephxK7j3/Q7FMCmiqk03acdjrX3+6RAnGJiHDJLHv3H6+Gtz9Mcy
	DmzD4g29HQ1g8ulHTtqx5XEKNbcDoyyr/8bQyQaRxHx30wqHfSeJJDx7lwsXnKPEnnf2x6
	CNd6nIV3X6ohmQI+LRAJhBogDi7zDPE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 36DDB62325;
	Fri, 13 Nov 2026 10:15:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3A811F000C4;
	Fri, 13 Nov 2026 10:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794564912;
	bh=rMuyr457fqCWZXx15HHMmpYyTiHvK3jp03BAUYi6K/g=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=mugwqvhM1NYSHmQVe1isbb+Lt7fz8+iLoYW5R22sMCGb3YuPbqdLN+KDfQCT8NvxU
	 ms7URPHAVatE2sRnmNhqBJ8cJgyO3ACmQrMGrk5JAEDYq6p+Ep18MvT9fHEuMGZ/p0
	 DTSm/kK1aZMBl0Bp2I2ZOLM7kRDi+pl2SyW7u4p6dG0ASRhvGyngVmkAwzdjR6dEtP
	 Dclc8J2YE4U60LiGVPkGX6UKSyY2EcSphkWyfETBtsYYOeDp/X4SPrFn4VyR0E/oRn
	 JFHNvcqIK3jLyDTAYxEEMAAZcwM62FV36r1CsTIlXyLB2bvy+QPTS6tjfjnrmoAsH9
	 dCNgaq9OvQBiQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, 
 Brendan Jackman <brendan.jackman@linux.dev>, 
 Johannes Weiner <hannes@cmpxchg.org>, Ye Liu <ye.liu@linux.dev>, 
 Zi Yan <ziy@nvidia.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org
In-Reply-To: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
References: <20261110-fix-split_folio_to_order-race-v4-1-cc5042f33408@nvidia.com>
Subject: Re: [PATCH v4] mm/huge_memory: prevent losing PG_waiters in
 __split_folio_to_order()
Message-Id: <179456490744.5856.15187695775214289167.b4-ty@b4>
Date: Fri, 13 Nov 2026 11:15:07 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: BD4B11C0008
X-Stat-Signature: eon8en9h7wmy3iqh75ddpa6h9aiyc4mm
X-Rspam-User: 
X-HE-Tag: 1794564913-819834
X-HE-Meta: U2FsdGVkX1/33OpAbOqO3Oq9mnr863F0OMC95KufE7P1EDe45lorJ/6NEhHYDGg/5RkJAsRO9NVJFVBlGF66VhSAZpyRL4xYr0/R0iCaH2lYZ4g3ckeRPSahC4hsd6t45niIg2Byu1UtENnQy2ktxzS3c2VbpoTeWz95nadihZPFMXgL6ukUTSZxdhfz8Jpd72SmIoIU6w6G2LsWh8j0v8476SQF/VBeKp9TPpHTEpVu6HOc2kRx7qjpUNMPEm0B9uSBz8sxn2eZxcDiW48ajzjjmEUbg5ldgGzmX83yi/KrFThqlJvoI8vPbyDuwmBmyttmLEGGnYtVRLBvZdTBaEU0/6tQSwCQWXRDwBueNaDLtAP6oU6n2Hz8bpppvsp7ApcU92XrSdSE7Dn0f4EwHzZDTM28iVg461NIq/CypXKSJA8Pb/4zNr7urFp0lHuhWw6u4Mt2TlLoXhX1AkhwDUjgmi2DbY6VihRMUhzaPdtUmLgAby2D8VXSR7E7ZkpV7BpF9n4jHANJe9Xcv6XX2mT5SleVwRYD+8RDr3c3FLccYm/lrG7O5hsElYoVqzX5SnVSWce6pizn0ituqiJc4tbtJZ5J04GkfRzpuy5uBCBMnTvFUQVVX2/IiH1c+bBaOCNzLFhNGCIo+FyTaWt5Y3HWts9Yp3V+hYYogBDBcO/zMO3A9zoi9S1e2izlSTBkVzprvqiGQn+GdbBaiQ1pF4uvtzMFLTio0QCs8Vz/gkAUSMWxjfBL5Hcj0BjzhVseidBlXYVPN/CQ/nogu/paewzAoKABVKtutaphdYj9SWtdK/HOcHqb7TnRAZ7lKJC1+IQ0ZmoEsCH0lQDvrwFV9RBWgY0xQGvjc6pHDXKIcNP3L3rx6WVt9FWj3C7cFDmtw+8+HXrD6v2zjek0LBie5wIkm7VZop4x/URhrxOsY4mwd6O2tmgPUo1Ep+7vnCOHYvNoayiNErDMgtGKxmV
 omqaHZw/
 hAwgN2HTuc87soWSc+pyCPeJ08ieSmGA4Ku2Y1eV57rZl/rpUv1UhlEMRH/LjrR5XC0oIMUBJgxZSe2TwRywWEoV/AU0/N4Okpxk8uLrpk6XLoy7eZ9fTcUVIXo2HuMVj/HyJgiDi01MUY06gtnpQDfktjFPpc3doOvpEkKgEvXDK4M/mxjp1zC3IfRrGNC+YTEFq0E0VeNBn7l0xRo5Gz2w/N/b+q8NkX9whDEQRQN3BEbY9OgBDQJke3ofoIijNHXYp18eXLtYe5tyaKqMclvBpcw91LGmoQM1W
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 22:19:25 -0500, Zi Yan wrote:
> __split_folio_to_order() calls prep_compound_page() on each new head page
> to create a compound page after clear_compound_head(). prep_compound_page()
> uses non atomic __SetPageHead(). It is mostly OK, since the folio is locked
> and frozen and no one else is supposed to modify the folio's flags.
> 
> However, code calling migration_entry_wait() can reach the folio by PFN,
> then access its flags. It is because softleaf_entry_wait_on_locked() used
> by migration_entry_wait() sets PG_waiters concurrently without taking a
> reference and the frozen refcount during split cannot block it. Meanwhile,
> __SetPageHead() does a plain read and write, so PG_waiters atomically set
> by softleaf_entry_wait_on_locked() will be lost if the set happens after
> __SetPageHead()'s read and before its write.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: for-next-fixes

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/1] mm/huge_memory: prevent losing PG_waiters in __split_folio_to_order()
      https://git.kernel.org/mm/core/c/7183af7f

-- 
Cheers,

David


