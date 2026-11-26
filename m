Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B7753606A31E
	for <linux-mm@archiver.kernel.org>; Thu, 26 Nov 2026 14:42:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ismlXzL2
Received: by kanga.kvack.org (Postfix)
	id 9823F6B05B0; Thu, 26 Nov 2026 09:42:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9325F6B05B1; Thu, 26 Nov 2026 09:42:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8219D6B05BB; Thu, 26 Nov 2026 09:42:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 544EA6B05B0
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 09:42:46 -0500 (EST)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id A60911C4B4E
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:42:45 +0000 (UTC)
X-FDA: 85477536690.07.6418A15
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf10.hostedemail.com (Postfix) with ESMTP id F1116C0007
	for <linux-mm@kvack.org>; Thu, 26 Nov 2026 14:42:43 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ismlXzL2;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795704164;
	b=loJQnXriN9Ug0XvfK4WwgUugvy7AniUZ+9J7CSnS5TbhL8G+1GCFP5DxKTZoRoZO7refj6
	EnhfhfGqHynLV+V536Vw3eDyfSywWB7qJBTW82qjYn7EkZ/7BvDbtKcMfRu4tmQ6MOy6eQ
	4+WyCnYN4gMsCDcfawJ9yyjeI1u48tk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795704164;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=s9SXJJ3n4l71fdNJUMFik/3jjqPXo5ZSg4MfSGRKAYU=;
	b=gBg3iMntSsMK1/SWVTDsydz3ATbMMSyKqrIBLnKA7kPJnLLbvde3enT6ZeGeaMVZKs7quv
	EnCBJPSJVf0yIHrgJGV2xJvauHZ/NctjI5Rw0g2VI6wwgcmWr/IboeKRSbwqFpmLzeCfMi
	23dsStnscJFM2pWkdcKyi29B4Tbkz1o=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ismlXzL2;
	spf=pass (imf10.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 047C1600D8;
	Thu, 26 Nov 2026 14:42:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B0FC1F000CF;
	Thu, 26 Nov 2026 14:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704162;
	bh=s9SXJJ3n4l71fdNJUMFik/3jjqPXo5ZSg4MfSGRKAYU=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ismlXzL2MQN40zx4eCBcrBBXt+d/BQHC+95H+VLAMxQ5pP+VeoftVgpV4UVKvsFrT
	 0Ut6jvmTISqzBtaWpHOddSFEXKhEtvDixoXMVrLc4nPn0w9eenG8DD5tfNwUiPz/aa
	 vquvt+2GGJ4o1Ht63bNze74e+sEB+zxkIfarGeeomocSg4+JJeXVSFfZ3zXr3KzTHH
	 eLNJUkJXDTRrkKhs1c2eT79PpVOj7o0p7So4rV47Q64nEaiH+Aa+dwWeXqQiyIOwO1
	 uN6RiSwnQ/cexnBHcXTuI4CdouWB6J7bhfE1bAvGkgtSW4KLfzb21hKSCCIbJay22f
	 NHSmjRBdr0KlQ==
From: David Hildenbrand <david@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Alex Williamson <alex@shazbot.org>, 
 Peter Xu <peterx@redhat.com>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, Wei Liu <wei.liu@kernel.org>, 
 Roman Kisel <romank@linux.microsoft.com>, 
 Saurabh Sengar <ssengar@linux.microsoft.com>, 
 Naman Jain <namjain@linux.microsoft.com>, 
 Michael Kelley <mhklinux@outlook.com>, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "Jose A. Perez de Azpillaga" <azpijr@gmail.com>, 
 "T.J. Mercier" <tjmercier@google.com>, Eliav Farber <farbere@amazon.com>, 
 "Gregory Price (Meta)" <gourry@gourry.net>
In-Reply-To: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
References: <20261126-huge-pfnmap-fault-races-v4-0-feecd58bb14f@kernel.org>
Subject: Re: [PATCH v4 0/4] mm: fix races between huge and non-huge faults
 in PFN mappings
Message-Id: <179570415481.24306.17551371198022216043.b4-ty@b4>
Date: Thu, 26 Nov 2026 15:42:34 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: F1116C0007
X-Stat-Signature: pwp49j1p9e6txmmaxco11bt8p3xnj6zs
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795704163-886920
X-HE-Meta: U2FsdGVkX19cn14XVX4Fl8Jp2muSHX6Jtw3kSu3pd94lOmaCphBjfxtfzreeFLPyNH0FyASe4B7KcNPuEBHCMs1hQWWVpOuoN79KR+ck6/PNNl3CNJZl4iovI8Ft/9TOPr8CKuWUK2q7i/2aUiZFRY5tXs1JjzUHNWvMBiPGLjokpfQFRL/3qXVKe7koPHicYzFCdHzo86oPpLwMu4gz3cJohvHoa3CSPMh3NwrEunEwSCQP0EP+gKfY/310n62UL9twaitMYdUyN4ayYzprbWxxgzRcpit2jYNxeX1/Ya80L8QAqMdkV+blI5EVAUmguU2qxr8x8K/LLp8m3WJof7zk4MvjnwGGRMBZX70Kbqwkg13vJRgBiapbwpMv3Bzb5+gKoaI6xSXheWbRVChAR1j2UlkwgmEu6+aO9kwKDbuWp6AKCdq3uYeWeZBsQyGkslrpdqLo/5QgO3VoOuoD6boha4LeZNtbbsU8vMYYTv4ch1iO+Wk3pZjH64WaDyx8iHDpOgWahk3X1sNnrKqdWhvMmZWGMTVHUjgc8oo5n1vrG1RGPDV//fdACwUVOxrbJ2mYqvL0ptu108TSNkXBLAA8EI+lV7LOVdUzzon07TdjrxzlEcpJz2mbzOKwfz4Rti/rtKJsSirNTBwWMD/Xtgg+nuLC0vmPpzrmTyaNk3WM4ApvI7HPR6T1oQXGnps3uHbSWoo81QUTzWZoTm53G8tnsYAZoYuWLKcyVez5hp4HxoEdhxflGOSusdSV1Vktbqtzu/XbtvS2ndwC4RmZHTFnNVdP+sAr8SGVt5qnQxHqiV9NTN7jYQhcZoU3QCFWWPGI+4eLaiEBGfQFpyR4p2tsvOpgUwAzMIKl1lA5iwkgsPMy65BaL2BYEfHn1qCbQ2DZJpP5/vBi5XUYh4gPk0ku2AN77P/0Tnr7+46i0WULtNBaGR5D3V/XDuobI/L++cdMdv5dSPO5TQReMG4
 ESo/xMTa
 YoBEzEvVtNn26c5i61BwWYXdYmKYetmCB950JhfDq+KKFFt+4DV0JU7Du8pjbaO7G2zgSLsZeETLej5Njg34GTjqkgBI8DntZQ3oQ2OmwQXaQbIo37zgMHLVowiUGF/9J52uig2I+ZL+4lnTs3XRid9+RjqU8zA7v1GxILe0kuq74Vxp0vofRQsJ/gpiiNVu9wgY4NrUanmveubkQCpcfnPmUjKcS0nxeFKvXgIdBK8aMYxJg+dAsC4lQr4GUMAzsGBMjqpSOcCCMP1ZPWfJO+4K6JmE9CycxGK54MtPprr+0eCBTT6xVzwQJg2gfleAIGl9JI4Hiyl0cX/JdNFSOSBzi5KKHioBpXzJ6zSEvGWiP9U2Pz5e/EqpNuo8kxgHWXuab0GxitiBS1AIrBsC6yHKSvdBTQj4zGZs+q7Ph40C0+YPJ1EV6pvI1mco3CLbsuO8mqz3Nx96dSEIcCIh+iyM+Jg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, 26 Nov 2026 14:36:18 +0000, Lorenzo Stoakes (ARM) wrote:
> A driver that implements both ->fault and ->huge_fault must anticipate
> concurrent use of both.
> 
> This can happen, for example, if a user calls prctl(PR_SET_THP_DISABLE)
> concurrent with faulting, as that only holds the mmap write lock and thus
> does not exclude faulting threads stabilised by VMA lock.
> 
> [...]

Applied, thanks!

tree: mm/core.git
branch: core-7.5.misc

Applied patches will appear soon in mm-next, followed by linux-next.

Please report any outstanding bugs that were missed during review, so we
can either drop the patch series or decide how to fix it up.

It is encouraged to provide Acked-bys, Reviewed-bys, and Tested-bys even
though the patches have already been applied. If possible, patch trailers
will be updated.

Note that commit hashes shown below are subject to change due to rebase,
trailer updates or similar. Further, this is not a guarantee that the
patches will go upstream. If in doubt, please check the listed branch.

[1/4] mm: update walk_to_pmd() to explicitly return an error
      https://git.kernel.org/mm/core/c/0ad3f82c
[2/4] mm/memory: remove racy huge PMD assertion from walk_to_pmd()
      https://git.kernel.org/mm/core/c/71a45211
[3/4] mm/memory: do not report OOM if insert_pfn() races a huge fault
      https://git.kernel.org/mm/core/c/125a4415
[4/4] mm/huge_memory: only compare PFNs of huge entries on huge fault insert
      https://git.kernel.org/mm/core/c/36363864

-- 
Cheers,

David


