Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 96F2F109C058
	for <linux-mm@archiver.kernel.org>; Wed, 25 Mar 2026 18:44:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E3ECD6B0005; Wed, 25 Mar 2026 14:44:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E16836B0089; Wed, 25 Mar 2026 14:44:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D2C806B008A; Wed, 25 Mar 2026 14:44:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C593B6B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 14:44:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 6840714055F
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:44:28 +0000 (UTC)
X-FDA: 84585461016.06.1DA4577
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf18.hostedemail.com (Postfix) with ESMTP id A79C21C0006
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 18:44:26 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="b/v6i8fo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774464266;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Q4Vizb1B1cpQvvFYrjV9Str+6hi34rpWBD8aY9TqbfI=;
	b=VqC20TOAdwoNvB20CDbQOJtRI5xnFRu5nZxjhApCIgvKnbXXEGRAS+SrNeNba8wR2ZPgCm
	qBWX+cfCEhkiVaffcm4CNrc9ZJT62Y00biHJz6tsUiHCMHm60SIhvQxrln5j+ohUvrHyTW
	/ylC9/1BHqhXdjjZOwFkofAmKSsgYJ8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774464266; a=rsa-sha256;
	cv=none;
	b=7FI+NuXEXcf0U7nYyGRDfqbUiDgoqsPUZAfCdpmP7NGWi/uaXYkws+80v7nz7MXWB/PKpw
	drLe5dEfSqVNXwaMlwNJFjAbm98aE9+cW0StdwM7ObEp+vC1J65OjwJot0PARLPci4yp8l
	7jHDuVCPkXMnDFgOYOV0oVxgtNgfDrE=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="b/v6i8fo";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf18.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 969FE43678;
	Wed, 25 Mar 2026 18:44:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24946C4CEF7;
	Wed, 25 Mar 2026 18:44:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1774464265;
	bh=Q4Vizb1B1cpQvvFYrjV9Str+6hi34rpWBD8aY9TqbfI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=b/v6i8fo+vCDTuurUcBJ6vIdUXSzqxb7B/H+jyR7aziWaxChVparkP1xpzHA4L+Kh
	 0+1G6NUJO+VCs044hBHbYry3sea3INNqk7t0OXSop7kK5AFE6+TV1USZMWYfrTWg8j
	 jChBK3dgjXD7onzbUo4rew4EgiAnImaScdAATampyOermEf2S4+tueQT1DEeySLNN7
	 +C1nJXrvxSmvCUSUxc3imsiO1O/XlT+bAFM9byzYzFr3UcRgxYAzPP3U9yE3FGbBEn
	 f3QXzFPLvC1/nhdJGTidMO1E4V+YOCqWwK6fYm8qftH9YVIwmMVgXEjBHRRNEV3si6
	 nbeb1Qgql8q2w==
Date: Wed, 25 Mar 2026 18:44:13 +0000
From: "Lorenzo Stoakes (Oracle)" <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Pedro Falcato <pfalcato@suse.de>, Arnd Bergmann <arnd@arndb.de>, 
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Dan Williams <dan.j.williams@intel.com>, 
	Vishal Verma <vishal.l.verma@intel.com>, Dave Jiang <dave.jiang@intel.com>, Gao Xiang <xiang@kernel.org>, 
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>, 
	Jeffle Xu <jefflexu@linux.alibaba.com>, Sandeep Dhavale <dhavale@google.com>, 
	Hongbo Li <lihongbo22@huawei.com>, Chunhai Guo <guochunhai@vivo.com>, 
	Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>, 
	David Hildenbrand <david@kernel.org>, Konstantin Komarov <almaz.alexandrovich@paragon-software.com>, 
	Tony Luck <tony.luck@intel.com>, Reinette Chatre <reinette.chatre@intel.com>, 
	Dave Martin <Dave.Martin@arm.com>, James Morse <james.morse@arm.com>, 
	Babu Moger <babu.moger@amd.com>, Damien Le Moal <dlemoal@kernel.org>, 
	Naohiro Aota <naohiro.aota@wdc.com>, Johannes Thumshirn <jth@kernel.org>, 
	Matthew Wilcox <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
	Michal Hocko <mhocko@suse.com>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Jann Horn <jannh@google.com>, Jason Gunthorpe <jgg@ziepe.ca>, 
	linux-kernel@vger.kernel.org, nvdimm@lists.linux.dev, linux-cxl@vger.kernel.org, 
	linux-erofs@lists.ozlabs.org, linux-mm@kvack.org, ntfs3@lists.linux.dev, 
	linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH 3/6] mm: always inline __mk_vma_flags() and invoked
 functions
Message-ID: <1ae3915e-19ef-4be0-aa5f-fd66a2e18179@lucifer.local>
References: <cover.1772704455.git.ljs@kernel.org>
 <241f49c52074d436edbb9c6a6662a8dc142a8f43.1772704455.git.ljs@kernel.org>
 <ndtnvnobevdymu5a5tdxdbi4tcsqshs3d6x2vnfgnuclxvgwok@bhbqkzilsets>
 <d352055d-06fe-43b2-8ad3-b73ab99683d0@lucifer.local>
 <20260325090949.795e06f48ec455053db9ae89@linux-foundation.org>
 <959b34ea-69a7-4fda-a494-0b9a1773ec1d@lucifer.local>
 <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260325112755.e62cd89508224f703239f03a@linux-foundation.org>
X-Rspamd-Queue-Id: A79C21C0006
X-Stat-Signature: ubnai988tcydcjgnmomq3ur5omct5ndo
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1774464266-399060
X-HE-Meta: U2FsdGVkX18pzn53HleKju4d9MwOtr2uYyU+jKtwIk2dHEWu7pYYVekk3Y/AFqcVR9ebRwgoOInp3k4up/zjFAPMGyP/QZx3JodpWrvUyCb01dBWAgT/k3zoB9iM/uglXUOKuuWe9P1VP560tsuEKnEk12zJJOk1I8b6Wm8w5DMIRExlrr5KcaPNulj441Gax/uS2ekDObBFM7IqeqiUWjoGOyGDYZGCmQs2/v396uFEV9fkezG5jbAYEZ4n9GLNlyIlbpPGueUgPrOREalAWmkb8h8Owdt8Q/sSyBHFz+Wmef+DLKTb9gPxWa2PiSZ8dAJOjBlAfdgqToyUMGPEvW4Ir2MyoKrbJSFbs12PL17WbY3HZ+6Tj16p1lNPvaU7m5W4tEyY0uYeesrGJs61Fxv7mbt6EKihPkQAdYpnVe9t/hSjYzs+1gv7uAfBf947KeedBDacxbh8mRjUFUwfxr4dHyXffCBHYqOvNooeBf8wHUAswtuWGGZsy0M0K+ORAkLD0Tzy6a/4E5RidKpjphNzBn9u5HAGOacJCCE3nUDg3HSjJZOa2+gbk/pNtDof4aaVEZXEj61/tfQdoBB6fkAu4xhV2VIw89tg7r8WBHGXEKQWySbVZGC3FoIHtDVFBioWW6OEuv+1BkFZTQQ2WVZ2JCF58abVY/9AH43w7HffrL+cqM0m4wpb+NAadrJWzgvWXsqTTUyV5wRIKI9AaezL6VwTZuD/JSo7svM2Wjy27OqWT+jLD3yCFp2AV+LfNuAFcicUABCbViVSjHNB/FDr9wBo2WKb8bM0/WADkMkp4Xv7XNvLzds8TlBGDqQJPRmSfyp0OuOTAl5x3g+mzXQdwLpJXWFmBfi/N7mgIkJCTFTzlDRN8Cvay3o5SserKvSt2d/mzbZ/bNZ03G7txxEuEQRV1o6MO8ln/XfHDJAaGXsP+s/0TLiw+CNbz1ydx756ANJ2J1bZi1f+9XY
 QdGIi4Cq
 N08voxKCjxDgKcanX/FXCeWTAy1iEpHGaj29ikbKAoyJrCuOpIyhhyGpG34HBMoqIos8ZCvlAXg7iNlUcTwWZkpuJMmdzx8mq9NBkgLiNkEmFmvpTsIAd/fjSoM33au3dhX5wdSfDoVtfwNbWh8laFnIQ4uqg5uQrRUFR13d6tJgQR4ZuoWdBjVIIqBczkkm4lkhaADJYfSFehQS27EPFnPJNg7fMK5KlNZeEw6+0PkeEFrIrVQ1ofplBOnw2wlocC5jDXcObqokfqrTwfPyuxLxaZqEv2xQAwu4c
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 25, 2026 at 11:27:55AM -0700, Andrew Morton wrote:
> On Wed, 25 Mar 2026 16:23:53 +0000 "Lorenzo Stoakes (Oracle)" <ljs@kernel.org> wrote:
>
> > Maybe 'into an inline constant value' is better?
>
> <bikeshedbikeshed>
>
> How about
>
> : Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
> : macro) always being inline, as we rely on the compiler turning all
> : constants into compile-time ones.
>

Well I think that loses the meaning a bit.

Something like:

Be explicit about __mk_vma_flags() (which is used by the mk_vma_flags()
-macro) always being inline, as we rely on the compiler converting this
-function into meaningful.
+macro) always being inline, as we rely on the compiler to evaluate the
+loop in this function and determine that it can replace the code with the
+an equivalent constant value, e.g. that:
+
+__mk_vma_flags(2, (const vma_flag_t []){ VMA_WRITE_BIT, VMA_EXEC_BIT });
+
+Can be replaced with:
+
+(1UL << VMA_WRITE_BIT) | (1UL << VMA_EXEC_BIT)
+
+= (1UL << 1) | (1UL << 2) = 6
+
+Most likely an 'inline' will suffice for this, but be explicit as we can
+be.

Should verbosely cover that off.

Thanks, Lorenzo

