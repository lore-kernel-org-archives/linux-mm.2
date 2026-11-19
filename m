Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 64F16606B422
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 17:11:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ltpszXxF
Received: by kanga.kvack.org (Postfix)
	id 571A76B06BD; Thu, 19 Nov 2026 12:11:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 521956B06D1; Thu, 19 Nov 2026 12:11:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4112E6B06D2; Thu, 19 Nov 2026 12:11:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3406B06BD
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 12:11:15 -0500 (EST)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9D035140B71
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:11:14 +0000 (UTC)
X-FDA: 85452509268.30.AA6610C
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id 250E818000C
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 17:10:56 +0000 (UTC)
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795108257;
	b=mYVf6KGfix1C3KjAeAxuUxa0+P5HyQnQcqcQaaGYO60k7c0c//p0VllC+UINhyDWL70o2p
	w+o/Em5lm4VODJOvCImGC9l7PEikaElDs8kV1EWQbx9SdM2gpIBjkbyOGejqyKJJYQbWoF
	NhRB4ceHGShyK1Q5jYvGURChTKNPJx4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795108257;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NE1INRl0OWxnNGr8U70vlE+S1wMHUVyOCaS5QMEsf7M=;
	b=0bLZqnMPDMwObSCCVENQMXkOXJXE1T6KlaXAf7QihfWiEPwE+9tsRGTWfiSZ37xeqyxVJB
	V6ObJiPiFjPUvixJKQYSA5QA0VJl6jeelEVHgZVQy5pAz4Vp3yF9yTujlxAXv37jST1YFW
	nPHKUf/yuBMxTP5iCT78nwKU0B6n30Y=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ltpszXxF;
	spf=pass (imf06.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A5CF263984;
	Thu, 19 Nov 2026 17:10:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866931F000C5;
	Thu, 19 Nov 2026 17:10:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795108256;
	bh=NE1INRl0OWxnNGr8U70vlE+S1wMHUVyOCaS5QMEsf7M=;
	h=From:To:Cc:In-Reply-To:References:Subject:Date;
	b=ltpszXxFqV0AAQqTyrnIS0Id3IfThC9AIODIr8UqR376J1BiffWgOtqMu0oXLbqhu
	 /OjZ+P+fR8DCvcgViGavzX019M1Myv96jTmpVUOHNlTSdYZ2sPSoK7E46MZyY/vQ80
	 yHEI1wyXTkexOkE++mB7R2HOJNQbIdCF6xaIZfsxwkWDwdY8SxNKZZTx9wyZ6qpVrx
	 CDfEwcz3yrRVRF+QX5HjKleBXp6DZnOXPebaztPYhsf08IDYeH6hYMUu/rFlRPENiG
	 59CioBBEOPdfUCy9tGWOCjKdtq0s9Yr8U7fNgzPhoteVDfi7EO9sBg2V8qi8pBmuJn
	 SG7UNKN8fwkmw==
From: David Hildenbrand <david@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, David Rientjes <rientjes@google.com>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Andrew Morton <akpm@linux-foundation.org>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Zi Yan <ziy@nvidia.com>, Matthew Brost <matthew.brost@intel.com>, 
 Joshua Hahn <joshua.hahnjy@gmail.com>, Byungchul Park <byungchul@sk.com>, 
 Gregory Price <gourry@gourry.net>, 
 Ying Huang <ying.huang@linux.alibaba.com>, 
 Alistair Popple <apopple@nvidia.com>, Usama Arif <usama.arif@linux.dev>, 
 Kairui Song <kasong@tencent.com>, Balbir Singh <balbirs@nvidia.com>, 
 =?utf-8?q?J=C3=A9r=C3=B4me_Glisse?= <jglisse@redhat.com>, 
 Kiryl Shutsemau <kas@kernel.org>, Yu-cheng Yu <yu-cheng.yu@intel.com>, 
 Dave Hansen <dave.hansen@linux.intel.com>, Dennis Zhou <dennis@kernel.org>, 
 Tejun Heo <tj@kernel.org>, Christoph Lameter <cl@gentwo.org>, 
 Peng Fan <peng.fan@nxp.com>, Josef Bacik <jbacik@fb.com>, 
 Chris Mason <mason@kernel.org>, "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 linux-fsdevel@vger.kernel.org, "Borislav Petkov (AMD)" <bp@alien8.de>, 
 Mark Brown <broonie@kernel.org>, 
 "Dennis Zhou (Facebook)" <dennisszhou@gmail.com>, 
 Rick Edgecombe <rick.p.edgecombe@intel.com>, stable@vger.kernel.org, 
 Josef Bacik <josef@toxicpanda.com>
In-Reply-To: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
References: <20261113-mason-migrate-et-al-fixes-v2-0-50a2ed382b61@kernel.org>
Subject: Re: (subset) [PATCH v2 00/13] mm: batch of (urgentish?) fixes in
 oomk, cachestat, dev-migrate, percpu
Message-Id: <179510824418.6720.13392203778507016783.b4-ty@b4>
Date: Thu, 19 Nov 2026 18:10:44 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Mailer: b4 0.16.0
X-HE-Tag: 1795108256-779824
X-HE-Meta: U2FsdGVkX18f3tObySEqWyLo8ALyLJ3Hm2VcwMcY2IW1tC4sb08JYfA2TgHbetmTzxevvFGXyTwtH5B7d2ha2T1a8RFUqlrGm4FpMLRjGc81lf6MJ1GzsP72q1yS1O3rkB2Ee+kvSnBIlkVNi1kmutznlFuuu5tYTO67YaMjQG9iDCgdO9AwYEo0TAlLSLv0eNLf3zdv94t9LWmJA71elP1/ZuN595E7e6ZsbdK/9t9zoIKqCRFI3Oj6JAMSNbfFFCl69r+54pL4zigF+vEBCpye1UJO0vToYVugSyvZ3SNPTED9yadkSvGvZTi7CehzZoQw0+PZ/kj0Jszj03l/OaAoc37bDV6wrDGA9cZXqWiwZYGKcEBrmVFl3T4t62/4FD2UPANb+6M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 21:45:18 +0000, Lorenzo Stoakes (ARM) wrote:
> A bunch of fixes for oomk, cachestat, device migration and the per-CPU
> allocator.
> 
> These patches were originally AI-generated, tamed into upstreamable state.
> 
> Some are more reworked than others. Those which needed a significant
> rethink are submitted as mine and marked as Reported-by the relevant
> original author, others are smaller edits which are annotated as such in
> the usual fashion.
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

[04/13] mm/migrate_device: allocate THP deferred split heads
        https://git.kernel.org/mm/core/c/dd3f0a40
[05/13] mm/migrate_device: don't collect a range twice
        https://git.kernel.org/mm/core/c/bedd0a3a
[06/13] mm/migrate_device: don't let go of the fault page
        https://git.kernel.org/mm/core/c/34f3affb
[07/13] mm/migrate_device: look up fault folio after a split
        https://git.kernel.org/mm/core/c/00cd1f21
[08/13] mm/migrate_device: fix ksmd oops on a migrated KSM page
        https://git.kernel.org/mm/core/c/e0a839b2
[09/13] mm/migrate_device: fix use-after-free of the anon rmap
        https://git.kernel.org/mm/core/c/9663aa0d

-- 
Cheers,

David


