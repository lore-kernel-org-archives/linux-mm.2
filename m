Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 514E2606A324
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 11:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dFDlsVIv
Received: by kanga.kvack.org (Postfix)
	id 2805D6B061E; Thu, 19 Nov 2026 06:39:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 232376B061F; Thu, 19 Nov 2026 06:39:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E946B0620; Thu, 19 Nov 2026 06:39:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id E9BD46B061E
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 06:39:30 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8481D1209EB
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:39:30 +0000 (UTC)
X-FDA: 85451673300.04.7724B2E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id E0A9CA0002
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 11:39:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFDlsVIv;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795088369;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cQD8U7kLvADZ0yYkLsPv4bSnvaN23quZm/iwStveKV8=;
	b=RU2LGA+pOjbVamKg1XzzTZQ/kf0bnnYglmaBEmRqRmlD7lQo43kZoV530snU3ERGHm3m7R
	rKxPrh/UTsRYoOneQReo7Jy8cH1CfMLW+hw33dU8NS7z1Bo7HMvhy991OecDfC2fDDdFVn
	hHzgaV1dx8zgNtTof/lThjAF0mrxgjg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795088369;
	b=WkT9pxSp8Imd5/Ctrg7uof3C/rMBdoTUFxQ20bhmjI7l33jDdO+c/Ill8IP4VD2Ti+Y4Hz
	P2+lk2+2K+ApZK4EW/w6TSqWrIIqduOIaK5SPjax0DWh92wBmA8C9ewJmNHFBwtu546eeL
	Jcj1NfL3CfJcAbHDRlx1eNBjGGm6umw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFDlsVIv;
	spf=pass (imf25.hostedemail.com: domain of rppt@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 14FE662172;
	Thu, 19 Nov 2026 11:39:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CD821F000C4;
	Thu, 19 Nov 2026 11:39:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795088367;
	bh=cQD8U7kLvADZ0yYkLsPv4bSnvaN23quZm/iwStveKV8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dFDlsVIvTFH12CswKDuycZpa+XlcUuvcfZebYeTqea/BjWW4xKWUZ+KHKpsoqA2gP
	 i+Hq0F7eBpDJNO2xLCmNdATdp05y3spfSziYaKyJjzZvHLvaSQwxBFlwwu1J6EC0CF
	 Msn+1rFCBUGv/08SqCdHYgovmO9wBdCf2zXuGuNPHB447Hghn0SiF/exzY0msS/8vu
	 MrcYXohRbDQR1DNLDDO17V34TuOVbscVARVlZQP9L2JTJH20SmQHtp3e1mPUEerWaE
	 MS5gVpcZuB7SaLtEQP6WAYCPeOKfk6+jyDQvaliZKuO+0Lo+EjsMB8BjKsSurYnKDk
	 F/q/85DAZOulA==
Date: Thu, 19 Nov 2026 13:39:21 +0200
From: Mike Rapoport <rppt@kernel.org>
To: "David Hildenbrand (Arm)" <david@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Oscar Salvador <osalvador@suse.de>,
	Muchun Song <muchun.song@linux.dev>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Chris Mason <mason@kernel.org>
Subject: Re: [PATCH] mm/mm_init: don't subtract managed CMA pages twice
Message-ID: <av7f6WK8zipAigbg@kernel.org>
References: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261119-cma_managed-v1-1-385751505e24@kernel.org>
X-Stat-Signature: r6u1c9fx19dhqhfrgmxkgd4697pemdx3
X-Rspam-User: 
X-Rspamd-Queue-Id: E0A9CA0002
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1795088368-449991
X-HE-Meta: U2FsdGVkX1+xT5mrpeJbUIFg+h/b9rUSiydBT6x8wv8p+sRfc5ZZtiiTj1mibcjU0Tk2IycDlQC6g9XrlWj5jsisbFEgM5Dg6g8HkHbHPNGeXiNRZ87SxBnVul3lmzbN2oaaBBr8Quj4xy7mQCREOnHa6PRCyFUm3WnsXnh1LW96xJFB7EUpIlBCCqL0xLPE+mFp/KRRBx3ECTEVZmstbtrjdP+So464YM8pXqkNRNbqL0BcDbcaJDtn4UF82d9z1Ioogk8zwDzR8egq9IEfWLFDjU5eWVjVOhrQ1f0xThGKqNX2XGM6zTgkKs7hYxyelQ3jEXprMi1XMGfhpJdPiBqBTWg5HAxjngc4EEKxtnbLfCDhbWct22Ay0AVQUiBRqDHmCOk54C/BB1jGqb24FvkJWZ3CJBD5L/reVwPcjx7XgHJeQqNQEOLp/5z9fTrL+Qsb9Rs31ngb7UNSSWHF3LXrw0ZEXS/USTMQVWzztJtUmwDo5uc3XAmS8QHDbfyRw/v2/4l7e2dyTBlIYFWmGeAXXiX9km+KyGE0xqHmkXsFb/U3VHnxmwC2haC150Y1NULmeLG7ZVywu+XmdmVANqQFC0AZWhimkcEUfnGBQmYvmVhK3z6BRjQwg4Oe48gEW/Qm+Z9IbBx7uuZ0+ndRxwdExT+YFB4VudhcQeOge0oPXEPnHbtQYpYFm1Iq+cFzJIS6yuWt2cs1sw0ePzy5i4OaorXZn48jlaVFPHmlcRJ+n2g2MkOUpj588Nq8n9lPoXGQmWpVDikW4cD9vm++J7BSQtXHeUdAcY2dZFMpVh1v2D1KQHxghMl2q0Y49/N+CiI0cuUc79NyMxLZ6NNM4OY/HWnQyR+40J5d6dGvx2hkeSWLEjPAXjSmx60wm3yB78YeDaeGDdCydayDLsU48p00XZ2F+8D18YZB7oJKXQ2oFTvtBSxAJucvtpRchq+9qkE1jqXn5J9OijRsqPP
 BFKMnEzo
 +nEN3n4Gta9Osh0wFFXcDMfsc/kdJSa0uBLPr5fmBJ/vS+bzfWveBc2j4N2CP2xQtk+hJUScy0To9KLY3DZE4se1zBmplU0ExOwziJ8OwWAAYAroElniZ6ZKyl8eaGkHw5WEOqoFZtltWCyDcnuWJYicvB4EE6WTv944QjEWXUr7FmNIOKqc7LgIcsG617pZ6MbEaQX8szhvwMo/DT+uJxlfBG3wdzm0GYizkjWeC1Gu9SXV1c5mbXTFok4nYIXZlK3zh+bw6sG48yg/I2AGkSnphqiw+gyQav27wyDYhaCYKZ0lnzSEfqJbEXirPFOFRyXt7
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Nov 19, 2026 at 12:19:06PM +0100, David Hildenbrand (Arm) wrote:
> From: Chris Mason <mason@kernel.org>
> 
> With hugetlb_cma_only, the "reserved" value in the "Memory:" boot message
> can be wrong (small or underflowed).
> 
> When mem_init_print_info() calculates the reserved memory, it assumes that
> no CMA pages are managed yet. However, some CMA pages from hugetlb might
> already be managed at that point, 

How about I change it to 

  However, hugetlb may have already initialized its bootmem CMA areas,

when applying?

> so we end up subtracting them twice.
> 
> Fix it by only subtracting CMA pages that are not managed yet.
> 
> This has very low urgency, as it only affects a boot message.

Agree :)
 
> Fixes: b1b7c045e808 ("mm/hugetlb: initialize gigantic bootmem hugepage struct pages earlier")
> Signed-off-by: Chris Mason <mason@kernel.org>
> [ david: improve description and comment ]
> Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
> ---
> This should go through the memblock tree.
> ---
>  mm/mm_init.c | 8 +++++++-
>  1 file changed, 7 insertions(+), 1 deletion(-)

-- 
Sincerely yours,
Mike.

