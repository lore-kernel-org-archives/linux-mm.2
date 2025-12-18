Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 751EBD68BDC
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 05:13:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8A3D16B0088; Thu, 18 Dec 2025 00:13:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 851986B0089; Thu, 18 Dec 2025 00:13:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 750316B008A; Thu, 18 Dec 2025 00:13:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 61F536B0088
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 00:13:30 -0500 (EST)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id BEDA9140CDE
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:13:29 +0000 (UTC)
X-FDA: 84231423738.03.F56DC39
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	by imf19.hostedemail.com (Postfix) with ESMTP id 7297C1A0015
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 05:13:27 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=abw4cd4g;
	spf=none (imf19.hostedemail.com: domain of BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766034808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tBPJ4Mb1hzl4Z7frr1TdBSLbB+BZzWahy5/9Vf/Pvhc=;
	b=DfBKGCpJHr8e6TL+4YHGs+Aw5T/TtjEsDYoCRMwimOWAInpAutzG97gUNQsFN/tA2zsQFq
	dY62ZZt82ehiQzP0AXsJEiN3KbVXuq3fZNpwBMCz9tfV85ahFwAW6XaycjwhCLamBNI7K/
	HNcYH62aL+11SpHOG/X2yEfzzzPZano=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=bombadil.20210309 header.b=abw4cd4g;
	spf=none (imf19.hostedemail.com: domain of BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org has no SPF policy when checking 198.137.202.133) smtp.mailfrom=BATV+3d4854a57dc9b1fc88a2+8152+infradead.org+hch@bombadil.srs.infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766034808; a=rsa-sha256;
	cv=none;
	b=at2pREK0Iv3C25khZtnrkbCp3kbLwtaFrU7F3butBbTFA/BDiDW2wExrBEnuqKaVQGfUil
	mWXes4G8b1uTz+eeSfbiACjlwp8oAmrUbREimXYbSGP/pRvSTOf9gx0nGr6pT4DXCjnw+k
	cbeKpVugTaRN3gN41qbeK394ZezqF2w=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
	:References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=tBPJ4Mb1hzl4Z7frr1TdBSLbB+BZzWahy5/9Vf/Pvhc=; b=abw4cd4gfRFytoBJvxcSsIJHiV
	fTP+kYXIZNvnUjWwqMbMHSsaFhKWbczbKe42esy72v/t3MXfSQ6xXsBjCymYvJp5ZqqPdslnSp3Bb
	3tu8c8YMRWcl2TdxNQvYGAEekcatcBCks3TCFP/neQwiZSJSwpTY79zXS9lT8ro2FbFjt3ac3V1EH
	T87lYoHGc0PNpCz3XXc7ARnHWc2in3/+wNZqrDoI/TnSXvt/SpC9VPlksyNdaiOXAZLsRua30r/aR
	HjowRulhJm54Py/OfUl5mk5QbtfaHdpaCy6vEwEqfqlpuJWY8ab23rYZnqHGWUIkHjKTCGAZonm0d
	N3moyq9A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vW6KF-00000007om1-3lcr;
	Thu, 18 Dec 2025 05:13:19 +0000
Date: Wed, 17 Dec 2025 21:13:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Shakeel Butt <shakeel.butt@linux.dev>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Shaurya Rane <ssrane_b23@ee.vjti.ac.in>,
	"Darrick J . Wong" <djwong@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Meta kernel team <kernel-team@meta.com>, bpf@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	syzbot+09b7d050e4806540153d@syzkaller.appspotmail.com
Subject: Re: [PATCH] lib/buildid: use __kernel_read() for sleepable context
Message-ID: <aUONb6wqk7Q-QxC9@infradead.org>
References: <20251218005818.614819-1-shakeel.butt@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251218005818.614819-1-shakeel.butt@linux.dev>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Rspamd-Server: rspam02
X-Stat-Signature: qckjuggzazqtm6juyoht8ga5q9rh4h31
X-Rspam-User: 
X-Rspamd-Queue-Id: 7297C1A0015
X-HE-Tag: 1766034807-454911
X-HE-Meta: U2FsdGVkX1+3rHyCduINafuRGTZFthn/OYT8BSjrX0QuzjRdC58Aw+D9tkJFTwquAQkjtKpxBBJFF1kIKnoSWjksyPGMqaWnJgc16bIx20ogUUfs0PY0geGHdh+o3dR3FyxtocgydEwbcaw5/daxxAOB7IlmjOyVxGY6uwcl2RmRhfADtvwz0sgw2VK2Mvuigknnnk2+RFIeCBmlzuAu2dgfN6IcCN4jWV5FBRd/enhVXFUbyx7RR9ow2W+Jg0+rLJAv0/4KIwHS7LwW1Fhn221yvPTjwiyh7I1qKgS3xT2hvDRXMak+AqDQCj6CPPdmoNuRseF4n1NJExLmwitnAQ2Gl7owtM/ZU1GHZFIPchRx9wkcPSdiddP20r8+3h9q8xWNDGy0WshwOd3Jo4bcuIaTg0+IMnaWr12n2oxyq21QAqhIPYC/t7r7PDX494e4zrycfFtJ05xOaObEuJA43tKtXsr2cXbpASon0TOqMjLJNf3k1lUmJwiAdekdwNUsXFwApQ91uBq96Oh48zNJJqOJK8EBIS+ZzjDMgK/DdZ16zKOJMct1/wqwCJXrhJhK7RsndI+fOYYATnbNQX9l+n3rvpvnreYn9ixHrGnQFDyzFP8SClzi6vmIJp8QHwKJPIBlLT6rwQ1pqT/zVogGsMkUGlrT4ovJ1y3EDv/6kHu/2WfS1juJ+DGgzAU0k0LBCpP7nEXE9BvjFK/g5x/qQZo75iGSADoHqhp3mFIgQZN0gFkOfVxgTsxiK3WVu/f2MgxSxEox1Is6/7ZwmoADc88Om95o8+00XXqeqahd5mCoR+ARj9QWUP6+1UglFOlKPbNgcCMWk1R8o3RxgN/7AJlvjGinp32LK5ortbDUNekyid/nEK05gzzxmSpUf/lgAuaAeTdVaB+xlI/wqK1r3IOrd1GHdIrTNL1aGnjaTDXoOBhi7YyYyQ95fyuPFsBJmfuzREZc1Dq8kdnWyYF
 1LfL2k0u
 vm69zTgXmnxCnCMcgGxYlV/Eynzhj5h3yTegPtU3i2Jh/xVuaaa2tTW9BeeII8aWkDDj6JYsuqCrhDksbXw8OQadkQYTLtdkgCNZIOBwSWiA2ZbjonqDPjzYG9eB+jVF15f3uiCGBPntq85aENDhWWHFfnVpwjWLGiD0xcOHe4jUP0C0CiIkZkjJl6K6lp+ativA3ing+DltONaNBciW71eZ2xaLOTJ1q0HD5M7CY/FtIqKjy4vM5vLnY3rvTuIoUhr6bAMc9Sm1Wc8eI4f9ybSJ7XV0NXD9ktDwkBS7AXuW3kzwiJJtVWzS79mnN28vYoSqLWIBRgIkO2f3hyqY3UmjOSxUNb1ccO239LPgSBUp3VrfXVH1j3A3MxDTpKRBghB0c16WO/4+Q8TMOZdghJFkBBpdpcty+TmMQLVqAmgvrojzmWUFtMe2ovyp21W1agDVJuYOSfEKtIiQmydoq9SVOraoZOIZw+PlXr9Wqb5Rx3NJVAz86lnGD3RQteGNrHzq8Fz3aUpbsAw1vmBlBMCumrETUBD9AHB/zIv9WGSa4EKml7FHarXYl5bLhyu2ckofmy976HchIPbUh2L/Q6+zCmbZcBoBM6CXm+iJdbr1JTg5mZJIn8GX+Mb53Ntog8rVlfX27MwrsgTo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Dec 17, 2025 at 04:58:18PM -0800, Shakeel Butt wrote:
> For the sleepable context, convert freader to use __kernel_read()
> instead of direct page cache access via read_cache_folio(). This
> simplifies the faultable code path by using the standard kernel file
> reading interface which handles all the complexity of reading file data.
> 
> At the moment we are not changing the code for non-sleepable context
> which uses filemap_get_folio() and only succeeds if the target folios
> are already in memory and up-to-date. The reason is to keep the patch
> simple and easier to backport to stable kernels.
> 
> Syzbot repro does not crash the kernel anymore and the selftests run
> successfully.
> 
> In the follow up we will make __kernel_read() with IOCB_NOWAIT work for
> non-sleepable contexts. In addition, I would like to replace the
> secretmem check with a more generic approach and will add fstest for the
> buildid code.

Getting the code further away from messing with internals is good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

I do not think making IOCB_NOWAIT never wait is feasily, though for the
next step.


