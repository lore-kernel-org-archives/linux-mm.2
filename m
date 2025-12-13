Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 13202D59D87
	for <linux-mm@archiver.kernel.org>; Sat, 13 Dec 2025 00:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B4CE6B0005; Fri, 12 Dec 2025 19:56:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 48C5D6B0007; Fri, 12 Dec 2025 19:56:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3A2696B0008; Fri, 12 Dec 2025 19:56:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 248226B0005
	for <linux-mm@kvack.org>; Fri, 12 Dec 2025 19:56:46 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C125A13548B
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:56:45 +0000 (UTC)
X-FDA: 84212632770.03.4238131
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 0FA0740004
	for <linux-mm@kvack.org>; Sat, 13 Dec 2025 00:56:43 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzKI6gX3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765587404; a=rsa-sha256;
	cv=none;
	b=NPLChooHou5YtHH7pItUaCjB3BY7Ost8qPGjx/C8rJWMfirBXKfyj86DrUE72n4aeH4/8K
	ZR9zMOxhbf7SRnm8YfuFzA2aCMCv57z6nJ7ekmCrxCl3TqLMewxbvlLvJxQixexHuiqzEO
	76EuLFST3QFSx4IZShkWAD64oAIarBs=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bzKI6gX3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765587404;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hCDPE7quwrwKqxAtTL4tdWslOmYdW0ncN7s84nvcFkU=;
	b=8f0RfXydYo32FJPclVDfV+MNJkirrj++5nrFxoIkDNxo45rMkN7q84A8ehNQI+MaGrJArf
	wyQs3zh8ltrHfGvft0UIo/PCXHCMQ5qvAIxtvZExnFAcSPsF5ropahF7yJBV3tB5kVt29m
	wX1uFncfJofiAVkrcKFkBiH5BzNojiI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id DB023441FA;
	Sat, 13 Dec 2025 00:56:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3863C4CEF1;
	Sat, 13 Dec 2025 00:56:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765587402;
	bh=m+SdupAtr2vqe29kp74wQamP33BdMF7o5VgQEmyNoQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bzKI6gX3rirffakNPg3du7BE+ljNl4bhyweBMmbgqY2zexkqxLpGa06jC34QcKhSY
	 dfGY+Apq1w5/rFbId9pQY9l9W40Qnocj1/64UPGev7ymTauVz3rzyKAgZwyFNayZ4S
	 U8dXDBnlYGw805vjA9kiCI4faU5dpktZ2Ip50GPi73f0gzrOcHV16pdYbggKR559lD
	 sQQbH3f1szvBEZ62D614PkCnCj0jE5mx2gFa89HJchUDRUdy0wSytWi4ngtAY4GZZ7
	 e7YLjcQaA7z7mJmQWeew/6k0LE3z/im33QQq/iE5ebdWpEWkNE9jAgKEYXFB5APDMx
	 vDQdMIr2aBYNA==
From: SeongJae Park <sj@kernel.org>
To: JaeJoon Jung <rgbi3307@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 04/37] mm/damon/core: implement damon_report_page_fault()
Date: Fri, 12 Dec 2025 16:56:37 -0800
Message-ID: <20251213005639.50513-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <CAHOvCC4jUGpyezSNMChyOCio-vTA=kK3CYS3O1CzEXxEiMjPyg@mail.gmail.com>
References: 
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0FA0740004
X-Stat-Signature: s79mgrwzbdr9bxzy3c7y9ddexfuz8mzo
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765587403-992580
X-HE-Meta: U2FsdGVkX1+5cyavpYNYWBpZSTjdzFLFiYFA8QYtK2HbaxLKWRAN636VM6ZByy649OMulQmmO96di5AD/RmkxniOoN4+mR6AO6bwgCZnMB//txFFff4xohOu5GDG+U5Q6J6EVgZIw5nVQj1xrc1qUZTzYK8mbkNboCBSsuWi6szzJTDZczWHgsBGNKZhQykP7dKTisTi+kQd5o/qX6GGc5nM7t2NLOlQjDDJPa56oRwsm4bzMQnUStrBfZazQphxzpNfDooNrck07hfPKC9wXIydoCWVDxC9MvtOItSDkhVuoFY31W1kDe4UUWHGXmNVD/XbEmAW73SF00sJPlvzjvA5L0ug+diUe895zElaw+zmgnkqTBxiweupT3ck2cwuKbMFtMGQv5YGF4eL8dH7kN0/bpiOh4s2a9OhFel/J/iv1sICJYswWuHNtNFQh01Me+wZQKEMnwJjZQj3YSF16SBSk8mqidwa35uLxp0aKsxY44O6fTKXwYgRD63Lu9Mz4eemnXKKKQJYoXnOD9q5oQbdJxSvXVm4Qe7fmq4y4Xc/cg4/p+LW3JIUDPTx2gjTsiVZn6X+vytvWmkzvgK1l8ALjZmkxYqRdQJZ/0dMqmrh3ayt1TZdrruNqstbPMPzGAo2Qeuk58JZ1Eug0+6ztoeops9NlIDgx+P4y2RBmUA3PBdF0o/Yvwc6cLDJVn2vlHn2nZYVtzJmfEs62je6djzwhTCzp/Fw3gvQz39WkUDxX44ouuf6neJDJcrpjaE2ouCpN/F+490qJRV8GFlUh38cn8RpdWbnswk/PlnEggdrMDZNsT7N7xA3kJy/JDg3C9I4x+9kVF2coAhI+H5JbLU41ur7PWCdnzz+XwGl7tuJfL9hgGQEg2wuGiypR68Oy6VNVLAkTyj26qnT+GBcMlnyU3wtts+QttKNJUJRg5uX5iy2tfCJQcTflRRriL2TSBqQuG4BfgTK1SpRUZV
 Zi+Prdqw
 6R4clMLW2oyhPPbYmRvHldMXeWolI8Ee/iUT099kjruMM1fjOHhozwujI60mMvt/b3QIVTRcfeg07wgZihP6qJXxDh/F92TwTul7PRetBXZRd5QDfpwOBwej3kdhGByDMK4pmBJZNjSdnctpxPypjrQXNNmcJTf+qzSJ0jCyrj5H84dKWH03XIic545X3895KlLJ45T1X4vm+DnBEmt9sm2YN2hNMxHSq6+28W+p6PanzH/sK5ucYGMclpqyimSJjt5ahXlkGtqP99V7UBqbEmbX4N+0M7FEKhVce5o0d1YPkP1euwGzcr3pwh3TSNppgGfEwSJu9y5CwyeEvxP4+L18/yLgSLl7SNi7Q1Mv0MMtaun4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, 13 Dec 2025 09:31:22 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:

> On Sat, 13 Dec 2025 at 07:47, SeongJae Park <sj@kernel.org> wrote:
> >
> > On Fri, 12 Dec 2025 21:46:03 +0900 JaeJoon Jung <rgbi3307@gmail.com> wrote:
> >
> > > On Mon, 8 Dec 2025 at 15:33, SeongJae Park <sj@kernel.org> wrote:
> > > >
> > > > Implement a DAMON core API for reporting page fault events to DAMON.  It
> > > > is a wrapper of damon_report_access().
> > > >
> > > > This is a temporal hack.  In future versions that will have no RFC tag,
> > > > only damon_report_access() may be used.
> > >
> > > It's a minor, but git am throws an error when applying the [RFC PATCH v3 04/37]
> > > patch file.
> >
> > Interesting.  I can do 'git am' this patch without error on mm-new branch.  Are
> > you using something other than mm-new as your baseline?
> >
> > > I am testing it by modifying it as follows.
> > > damon_report_access() is
> > > called by damon_report_page_fault(), so they depend on each other.
> > >
> > > #ifdef CONFIG_MMU
> > > void damon_report_access(struct damon_access_report *report);
> > > void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd);
> > > #else
> > > static inline void damon_report_access(struct damon_access_report *report)
> > > {
> > > }
> > > static inline void damon_report_page_fault(struct vm_fault *vmf, bool huge_pmd)
> > > {
> > > }
> > > #endif
> >
> > Seems this is not for fixing a 'git am' error but build error...?  Can you
> > share what error exactly you are seeing?
> 
> You have been deploying RFC PATCH v1, v2, and v3 starting from 2025-06-29.
> I am currently working with the latest version v6.18.1 (as of 2025-12-13).
> 
> $ head Makefile
> # SPDX-License-Identifier: GPL-2.0
> VERSION = 6
> PATCHLEVEL = 18
> SUBLEVEL = 1
> EXTRAVERSION =
> NAME = Baby Opossum Posse
> 
> When applying RFC PATCH v1, v2, v3 with the above version, errors occur
> in several places in 'git am' as follows.
> 
> -------- [RFC PATCH v1] -------------------------------------------------
> 
> $ git am '[RFC PATCH 1/6]'
> Applying: mm/damon/core: introduce damon_report_access()
> 
> $ git am '[RFC PATCH 2/6]'
> Applying: mm/damon/core: add eliglble_report() ops callback
> 
> $ git am '[RFC PATCH 3/6]'
> Applying: mm/damon/core: check received access reports
> 
> $ git am '[RFC PATCH 4/6]'
> Applying: mm/damon/vaddr: impleement eligible_report() callback
> error: patch failed: mm/damon/vaddr.c:610
> error: mm/damon/vaddr.c: patch does not apply
> Patch failed at 0001 mm/damon/vaddr: impleement eligible_report() callback
> hint: Use 'git am --show-current-patch=diff' to see the failed patch
> When you have resolved this problem, run "git am --continue".
> If you prefer to skip this patch, run "git am --skip" instead.
> To restore the original branch and stop patching, run "git am --abort".
[...]

Thank you for sharing these!  We are working on moving baseline, specifically
mm-new in most cases.  And we keep under-development patches on damon/next
tree.  Please refer to the document [1] for more details.

And a later version of the patch series is for replacing the old version.  If
you have no special reason to apply the old versions of the patches, I'd
suggest to use only the latest version.  And if you have no special reasons to
use only 6.18.1, I'd recommend to just play with the commits on damon/next
tree that was used to generate the patch files.

Nonetheless, if you have a strong reason to do work on only 6.18.1, please feel
free to ask help if needed.

> If I build the kernel with the above status, I get compilation errors
> as follows.
> 
> /home/arm64/projects/kernel/linux-stable/mm/damon/sysfs.c:758:25:
> error: ‘DAMON_FILTER_TYPE_WRITE’ undeclared here (not in a function);
> did you mean ‘DAMOS_FILTER_TYPE_TARGET’?
>   758 |                 .type = DAMON_FILTER_TYPE_WRITE,
>       |                         ^~~~~~~~~~~~~~~~~~~~~~~
>       |                         DAMOS_FILTER_TYPE_TARGET
[...]

Makes sense.  Again, I'd recommend using mm-new as your baseline or play with
the commits on damon/next, but if you need help, please feel free to reach out
:)

[1] https://origin.kernel.org/doc/html/latest/mm/damon/maintainer-profile.html#scm-trees
[2] 

Thanks,
SJ

[...]

