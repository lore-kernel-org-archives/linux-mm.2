Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97E1EFCE21
	for <linux-mm@archiver.kernel.org>; Wed,  4 Mar 2026 17:25:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EED896B0005; Wed,  4 Mar 2026 12:25:21 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E9BBF6B0088; Wed,  4 Mar 2026 12:25:21 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA7326B0089; Wed,  4 Mar 2026 12:25:21 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C7D186B0005
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 12:25:21 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 5FB081C7A6
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:25:21 +0000 (UTC)
X-FDA: 84509056842.08.CC3788B
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf16.hostedemail.com (Postfix) with ESMTP id 7460C180011
	for <linux-mm@kvack.org>; Wed,  4 Mar 2026 17:25:19 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772645119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=6kx8vnEm28aGLiRE9vB2nHEueIYFDqBkfc/uJtYW6dw=;
	b=Tz04Ej5yK3iNnQahtpgjlugeIRrrAxVxOZQJc21Gs9c1FxApHEY7UfGQG3VOHJWkVMlzAg
	kBSG+zp4mnlgPsb0Qz5J2hirzNPEEhuiEPs+lGrszjd6gETDd02g2JBHjtl8qfAXr+z08P
	qIKaZjL3+EQB18caMXx9Zl/mxteiBCM=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf16.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772645119; a=rsa-sha256;
	cv=none;
	b=gDD08YbLpleNEVZmZInGPRRoOLandK99TW5+W8XP4I0u/WISuD1naHjzs+Je4R+T1096kg
	8Beug2FK+ykeK9B5rU34/Ut6W6N8ehgufjORERnkmNU/HRTkV6mzqtPJH69FHulR7n7tto
	aa2sFdBmjhuALxaXPDJbjhhsdWO2zI0=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 1AFBF339;
	Wed,  4 Mar 2026 09:25:12 -0800 (PST)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A59AB3F73B;
	Wed,  4 Mar 2026 09:25:16 -0800 (PST)
Date: Wed, 4 Mar 2026 17:25:10 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Jason Gunthorpe <jgg@nvidia.com>
Cc: Piotr Jaroszynski <pjaroszynski@nvidia.com>,
	Ryan Roberts <ryan.roberts@arm.com>, Will Deacon <will@kernel.org>,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	Alistair Popple <apopple@nvidia.com>,
	John Hubbard <jhubbard@nvidia.com>, Zi Yan <ziy@nvidia.com>,
	Breno Leitao <leitao@debian.org>, stable@vger.kernel.org
Subject: Re: [PATCH] arm64: contpte: fix set_access_flags() no-op check for
 SMMU/ATS faults
Message-ID: <aahq9i7XNYOBG49y@arm.com>
References: <20260303063751.2531716-1-pjaroszynski@nvidia.com>
 <aagUtDTca5d0le2Y@arm.com>
 <20260304134313.GM972761@nvidia.com>
 <aahJX0NwtYHy1ILe@arm.com>
 <20260304153949.GP972761@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260304153949.GP972761@nvidia.com>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 7460C180011
X-Stat-Signature: t8wq55ee8mrbgfabiajzujxx3d537afs
X-Rspam-User: 
X-HE-Tag: 1772645119-969454
X-HE-Meta: U2FsdGVkX19NWcod4p2tdJszu7DiL6ICIjkeAnIsh2X+PLGpD0LEjWFpcgWbeueIIwVNTENBei/k9XYEr2/IeGhib0WFyJwr/044iHqL0yvWCxvCBLYKRiV0wp1Fyft8PYrF3ZzbUXetS9fEpX8uLWYoncQrMhV9eobFXjEbV28u2WNe++CAA5zVIYDVDE8aMgwOlwM7cLT5r4hkqs1zSw5BOCZecZztXIM7EKnc2IW7Zu/5cLPl2eaV35L0T1pNBfTf3JPWcFFhVbN0td3xAWIBz0NTLQ4oDWIktbotQtpUCXYHo9Ws1xh21DXw8VLxM+p4REN1xwrILiDYK8nldMctS4Ef6RmzNo47pbyOugZon4Qnbs7fMR+GfwDK8n8BP2Gfl0TSbFoRLf6A98ufCcCtjuWmbvslsAcmFdD7xMTcy6JXJCPb+pWYykF7F2oPjai3WreRhEY/qKZlWb8FYXPJVX/j1tX6aGkRWHOed+fNV9bFoyS/aWzA6JKyyRw/z/x/mwt9fDXk70URhWSm+lh/eXm7klHgp4jHr1KU9+GE2QGPhuGhuQER//Z2Ck+STzGjKo+sZu6/QFp4VL6W0R0grkPhzjw5HOMTS9NISMtP7mORPaOEUsM7qmk01YnAiEaivE+r9UtaCkpYJRnbRI0Pr6vIcvaesc85A4KLJ71+RBlQcZKX5pofiE6iYMyrOMookwCSXPc5iixOycT2mBoc/jp0RC3mmjyOwFaoBU7j7YZvtkDQMkvJuxq9LfC+p6aXy1RvrUNT0pp7yPpnG0h+tQST8ibvS0CKbMAOA2p8T3b0D7nfuMX7iXGbdNPSUzrFnL6d7ZIIwvFYY9RXWk8WYwoKo8s2XRioBqqoATgwgIePJ0na3JACOxI+WwTaKHHy4NL26WIi8XVv3fSTL1zzYpm0qqkfJj82aDX3jDlRl8jglewksMn7asI/qQgap9mZhACO1G/NeuL07Jg
 Wz2r0h5q
 GfKGIx/+RY7QL4ZbHi5ttU+n1gEgWqzmTYuyZqAVSVdT4Ly4gugKP0hAd4nofS834b+2Nh/UJfAAe3fZaju66hpyDcgX4gBeCHem3cSZJQbB23kCID4pY/uBjkS1C3832kj9LAcYrkV28/Au5eOZmntvy9uQdbe49vXVKMHuFKY4PSC77KpzTolUXBA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Mar 04, 2026 at 11:39:49AM -0400, Jason Gunthorpe wrote:
> On Wed, Mar 04, 2026 at 03:01:51PM +0000, Catalin Marinas wrote:
> > Good point. For the AF bit, the hardware is not allowed to cache it in
> > the TLB, so we can't get an AF fault for an unrelated VA nearby.
> 
> The way we have read the spec is there is no restriction on what PTE
> the HW accesses when it encounters a CONT group.

Trying to find some rule in the Arm ARM, it only says that hardware
AF/DBM only happens to a single entry but it is not specific about which
in a contiguous range.

So yeah, it's better not to assume anything. If it helps software, we
could tighten the architecture but I think the benefit is marginal.

-- 
Catalin

