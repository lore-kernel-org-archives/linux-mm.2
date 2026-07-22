Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D9842C44539
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 11:52:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 935F36B007B; Wed, 22 Jul 2026 07:52:42 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8E3FA6B0088; Wed, 22 Jul 2026 07:52:42 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D5FE6B008A; Wed, 22 Jul 2026 07:52:42 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 4865D6B007B
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 07:52:42 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 66C9F120161
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:52:41 +0000 (UTC)
X-FDA: 85016250522.03.500E012
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id D8EB71C0007
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 11:52:39 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsbXT4SE;
	spf=pass (imf20.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784721159;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2u+YmL3O7mDZg1oLXMa5OhmXTCMV452YGb8AVhTqv5A=;
	b=cO8x/nVHmbApR5l6z12OGmzw5kp/Sq8eMKSDzLMrCTjBfcCrbr006ah2nVNK1lL7ckMn7S
	8IJJ5HKCxgfbgTfEux5jNdK3/n50CWeQptoYAPgZmFPM6BSriIiO24gT+NE5C7xnCoPM0d
	Gj6IJPbwFE5a+N0nsBkQO05a49D21p0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784721159;
	b=xKIOXJmtY9BCdFbWDqHz1HkIGgP6bcbymW48w/2Sf0WGAeuEbfSf/cNKeYUON/6/euWSKR
	GO5Svu7bZ0G9eNe98peyfk8ySf+1hzAZssuaCzG+L/42O5hjm49wNhsRonH7K0Fk6k0vLV
	QUsFR4DjrGgzrmbgdxglv0aLE5duvUM=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=IsbXT4SE;
	spf=pass (imf20.hostedemail.com: domain of will@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=will@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 3984E60A64;
	Wed, 22 Jul 2026 11:52:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 779D91F000E9;
	Wed, 22 Jul 2026 11:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784721158;
	bh=2u+YmL3O7mDZg1oLXMa5OhmXTCMV452YGb8AVhTqv5A=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=IsbXT4SEjVnkwnCXzJY0T8cBl50BCSrCVGmwo9Gs3OAFL2HC7CMfLRTz+kXbHM+7u
	 +TRC1/3Wj1Vtu8B027gT6rpfd6xraxlmp6/frHM92cIjrOqKI/W8uhmkW0CA1+BuGc
	 LH/JD5egHL5o5LeOzFq0FxEMgPAaBVOIgqYsGSldxCIw6WZCTxTn/IEIVm7xi+aV3Y
	 bkZULNGGTO1WdMjMmYK2M4kUik3xFZb0Vhyp/ovpdVvWTE3hjV2AY2pKylyN8I0bD1
	 ahInEjp8GrtjzJqlw8gqwZAFNB8cAPZ6Lf63qQZmM130cQK/Y5UdMF70oeXuFfTkcN
	 iW7ODO9zjcEXw==
Date: Wed, 22 Jul 2026 12:52:29 +0100
From: Will Deacon <will@kernel.org>
To: Dev Jain <dev.jain@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, muchun.song@linux.dev,
	osalvador@suse.de, ljs@kernel.org, david@kernel.org,
	liam@infradead.org, catalin.marinas@arm.com,
	kernel-team@android.com, riel@surriel.com, vbabka@kernel.org,
	harry@kernel.org, jannh@google.com, lance.yang@linux.dev,
	kas@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
	apopple@nvidia.com, rcampbell@nvidia.com, ziy@nvidia.com,
	matthew.brost@intel.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com,
	byungchul@sk.com, gourry@gourry.net, ying.huang@linux.alibaba.com,
	ak@linux.intel.com, nao.horiguchi@gmail.com, mel@csn.ul.ie,
	j-nomura@ce.jp.nec.com, pfalcato@suse.de, tglx@kernel.org,
	dave.hansen@intel.com, jpoimboe@kernel.org,
	linux-arm-kernel@lists.infradead.org, ryan.roberts@arm.com,
	anshuman.khandual@arm.com
Subject: Re: [PATCH v3 0/6] Fix incorrect access of hugetlb pte entries
Message-ID: <amCu_ei3B3-2OPTB@willie-the-truck>
References: <20260703114202.365553-1-dev.jain@arm.com>
 <178464737122.1305746.12295190523058911270.b4-ty@kernel.org>
 <20260721133636.df1a012df895054d3fd34a2e@linux-foundation.org>
 <4bb234f7-5f3a-452d-92dd-a1e62b6f39aa@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4bb234f7-5f3a-452d-92dd-a1e62b6f39aa@arm.com>
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: D8EB71C0007
X-Stat-Signature: z6oj1hgntu6r3cnj5roqfgxs59unaw1s
X-HE-Tag: 1784721159-472351
X-HE-Meta: U2FsdGVkX1/Hx8Jgd3EZHQhpkoCHvihBrKM6VLRvMRBJhKl5HIYnqXxZWLquEkUrQjul8y86DktSQYBqVYkzct5oYkMybVrn/ZKCLYpk0SCoZI5dXu4D6Kk3ymGTQocFgeczLjvLc6S4jObQbLlyxTC2Z08MmTGYgJDSMX0Cs8aqgeQ4pDgvvGj9PW1RFopNsYZJdtf47frhakpj9g4Q2zspF9jjppMH7g5Q2o3Ok37Vrn+2zysyZj8ngVUog2BvWY6tWjVBa1K1mfq9WniBBkjmWMyrjaE2o0YdebbetXMNyrWwguuP9EHJgbG8QXux8DICsjvf63V9KXqQMATVocpyDdD9aVueCcdbYUsX68Hvaer05SAF2C99IcfPosIP/R66+2bNfh9NIlVaEGRIHgplmeZjayM5mbDoGxZ+bpJlmxFGGT5tLys2sJc9Nt5qg4jfdQM0kT9GupD79MjuHIeMIGY8Ak7CxmTqynRLz3QSC2bxnAhCcIWZav8hRJroQ0/vNaYcZMFniDYjxDtjzKqlEHlSlL/PrrvIVzZ6aBEHI3dzqECPJtk+Ds24OT09Djgx1SlV4UZi5RPSRfl7gEVt6N/lsCkXFJNXjyKRR5Ur2dkJFOnT9GXTe/ejmKFXgVb7/IHM4hqbnwYclsZ9yw95oftE9d5XHLNAiSA9JphctNN8KNiicfV9hNRqRgUyg5alQYHBy9kp/TZ2AmwuxY+as3QWPy35bPFU2eY4XdUApwRp2ZQPAdUzwr1MJpfKmDeYo12QgSm7fgix+OeS9ubTDDltFzRYn5AHe2/27k5G0i6kglFky5WYBOhEpDgtzs5ZQVG4zdK0tEU96wjfG/ezpU0JUPnl22g1t975je7kwuW5Djbpru95aA+56yqTQxcOoN5pNz5PPzp9rp40XO6O0WFRz8m1ugKwFeAlF7gguE2BChWO8ho/O9warlmwh3eeeq2aLivK5QyPjA7
 kCdMd905
 DO3A1aTwgVfxQ3xk7XBoS5xDbEPqtyFHJtw5aeq+Zy381VwXmOLr1n8n4TPMPVBK4Bbs6AbKCSqDVmxKfTT/mRY2I+9c5R4BJ/+U6syxPYVwfk6Y+LCXhG7oduU+wSPa2XRWioN3ekVLP+UySPTQrq3WFvbMz2j4ATcsmrjPb21LFwgRZB78LOyVgr+wBGtWh7UpH86NLrJaFeqiE/14n1AwQGMK3sGQiqbzamm22juYMHFfJo/RuGPlMDC5LQJ4hVEwOaoSwunTSk1QdE9bK09FP2S1+b3xOvbRtRkLsQ6HTjYy9W34Fq81TMqY52HsKFT57CvLbxjtt3C0ev2Xjfjm60XFj9L8YoDQa
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jul 22, 2026 at 10:03:04AM +0530, Dev Jain wrote:
> @Will if you could edit the commit message with the following userspace visible
> effect:
> 
> "On systems where CONT_PTES != CONT_PMDS (meaning page size is 16K), we could collect
> excess a/d bit state, meaning extra work for the kernel. Even worse, we may iterate
> beyond the PTE table and dereference a garbage ptep pointer to access physical
> memory we don't own. Since the ptep pointer is a linear map address, we may run off
> the end of the linear map, dereference a VA not mapped into the kernel pgtables and
> cause kernel panic."

It's sitting on top of for-next/fixes so I can fold that in, thanks.

Will

