Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F33FCCD6E5D
	for <linux-mm@archiver.kernel.org>; Tue,  2 Jun 2026 22:09:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 56C116B0096; Tue,  2 Jun 2026 18:09:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51CE76B0098; Tue,  2 Jun 2026 18:09:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4328A6B009B; Tue,  2 Jun 2026 18:09:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 303AC6B0096
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 18:09:16 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id D53001C024A
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:09:15 +0000 (UTC)
X-FDA: 84836364270.16.8CB5E7F
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 3E65420006
	for <linux-mm@kvack.org>; Tue,  2 Jun 2026 22:09:14 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LezzoyJO;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780438154;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=GC8FjW8eAZZqSEHEtIR7QWUFGmOxnTJ1Nu6ikhwgeQA=;
	b=XlyfGyWAssrVyKJVSO5gL7+sw5EWeLRfEeFVOLoMHxoVQP+tHsA15DswiGK9USKWPfOOUS
	bKCk26NO5Fi9A90BySo9ZHcKy7Le/YjXsexEeZ4vwIXRuJknr22UMUyYFHRBc5VcfZMHZq
	zkhiyWc1pY3l51RydBCfmzH/LVdLArI=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=LezzoyJO;
	spf=pass (imf03.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780438154;
	b=zyXXjivJAJ3MQJhj0pQYGHPdXolQTAdyPLxwY9N0B6JyvZ4IpSaiZVnuLup3qhmfim1KaW
	KsA1qWSGmOh+KqzExZggXrje/ZctJJDOAq8kO6hXjRMkohn4WCjOCEFSCVUAZRj7OV8c8u
	9YAZh2ZJh7O0NSBTm6bgljTyP1zgXQ0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 255BA4454F;
	Tue,  2 Jun 2026 22:09:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D634F1F00893;
	Tue,  2 Jun 2026 22:09:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1780438153;
	bh=GC8FjW8eAZZqSEHEtIR7QWUFGmOxnTJ1Nu6ikhwgeQA=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=LezzoyJOYE8E5dHI2kTrX2OlVW8csGBo71kbltsEIXgUg7b3ekMDmNG6Bb/sOKisP
	 mBAFZPTtkKRnHQD4pmKo5hbhuMNRyNUbc3HkAm4ILzgTZJrmEO2mPVL83QV0lxShjh
	 p6zpwO8u9X+6fFWJDWQSKUAh5SKN43wkDR4DLRaQ00acWtw+On1hfmIWtMot7YOGsO
	 xUGHWBXkhk/Ujm73YVH8nRDI4SCq8HH8XZzGujRj1bbkqOfqznKCS52wriKePD8x2X
	 bcEt7+QCl4d/m8RdICey8u64NsLkzsUmcx99k6ZMKkmFyW+YpDiE98wvCCVl1FJfyo
	 gAdpWQlO7N+AQ==
Date: Tue, 02 Jun 2026 12:09:11 -1000
Message-ID: <8f133924fbf8d259340f3057e505f663@kernel.org>
From: Tejun Heo <tj@kernel.org>
To: bot+bpf-ci@kernel.org,
	void@manifault.com,
	arighi@nvidia.com,
	changwoo@igalia.com,
	ast@kernel.org,
	andrii@kernel.org,
	daniel@iogearbox.net,
	martin.lau@linux.dev,
	memxor@gmail.com
Cc: peterz@infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	tglx@kernel.org,
	mingo@redhat.com,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	rppt@kernel.org,
	emil@etsalapatis.com,
	sched-ext@lists.linux.dev,
	bpf@vger.kernel.org,
	x86@kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	eddyz87@gmail.com,
	yonghong.song@linux.dev,
	clm@meta.com,
	ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next] bpf: Replace scratch PTE atomically when allocating arena pages
In-Reply-To: <f45f02410d23c99d14f3577da9b27a327816b5a0904bdeefc8e229eac760d1cf@mail.kernel.org>
References: <20260601183728.1800490-1-tj@kernel.org>
	<f45f02410d23c99d14f3577da9b27a327816b5a0904bdeefc8e229eac760d1cf@mail.kernel.org>
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3E65420006
X-Stat-Signature: ggjbskt5998z1xs46dez8jgyii5seed8
X-Rspam-User: 
X-HE-Tag: 1780438154-313290
X-HE-Meta: U2FsdGVkX18fnTYG9t6Gzvb4PUGnic6NfYgfugdh72jzQ/I1MCeosEJ1XvWbJWpXf2rjaM3lsvFYNYhtlBGMaRYwau9lP1W7JHNHWH3ZgYjHNxoBHDvI7BQunf5ODJjUsEWltH39da2z8YKdsf2IoghxD3HsNfuITJ5Ub5AZpV8optJ1AZWVfTx2eFmCJNFX5mduvFGFw2Za+ayoAPC0EW6ye6bX+kCtoM8ZOKh7opVS5BAfHC1E1oCKYRknnqxNW3FPa81Xqb7M5yXIsUntp1b2mSJpqi4xlWrKyj/JZ1IV+XWR4IHFlaxFK0PTzCy+H00qvMC6VAdkssXKDYP6qwYGtLaZJL7EJtTeuzpWv1JHBT1Ywb5wxvXjB9kc2wADgTUDYRbbCt63hDNL7hl3m+rRElCxPqnLMDwOChb7SdgEKMG5AfL6W0YFcOWLqaGll+i4x2HHnWVJUFTMnUba7obYRlQ5oyFm+l5o0SdfFNKaZzokptK28G9iHZfBiS9BA32z4AW6k7n88HWUvPzUggZrRxW/SUKan2jA7aUqEn5Y8Mbl7KCZ29CqYXarHT/MYDY4x8ZCxyg+DRqLlyvDqvnardzJKN9mEqIoI9wBgIey1FMs9CuSzmie+wcwU0W54aNORQDD/yg1ZHe4cAjtQjCHqI0tPPQ/U6CILMYg6EnKZGaZ5U2qIelCmT5T+M29TGfh9QjLpf3t/JovkNoA46bStD/+hEwxhzUtlYlpOhL3L0MKdVRXFfQkYUbyXWdVEsKExbR0I6khqO6NxHK2ChtL44RAYDQQimRjMwjfcLHkejne9RqWzGGBUAhK7QgpGT1dQ+Ff8qnwo8SRSKToD1yMd/nOUjXPctmYJv/omHgw0L7IqUsl3snmfisSXQRyW/tf3+3ydRypiOPwTNThp7IKdNP0LxCas3PFjD2wywwLnhZxsThyyxTz/Aq1dvHKOT1Xl9POyiE3KNZTUmu
 qSnzjDQJ
 y1QQiZtFo7cf04AdeOr+eRFWrIsNcKHITS5nIpiNSN/yYsbg/Lp9r2I8vE6sDqsK+bpQCEndf4Sd5ouDq6Jrlh9HhdDp9jN5ZPjpGNiIqqboETJPRGJgW56KHoWx2tiboTXbs/z/iayg6iC1ZRnWKoyQC4i9PjIzfcUuqW50X2swueBGYd3MXp/FujABzFbZ6H9LeAdb+04SbVqTbrXwJq0RDsJv0j0l6vPaRLorYdaNgtlBawABZwE3Y/zJHloUQ2RwB/Ji0XXcd/g55vfDFGwFKyvmYBCVnMPT5wuwVEbCYNt2n4Db19SozP+QQ7HhZoC6uQLMZX9X/7IcARv118fV0A+ZO9ymZUXe5sJNECSbHpyTKMOdBvWhb+++LBnJwHfky
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 01, 2026 at 08:15:34PM +0000, bot+bpf-ci@kernel.org wrote:
> After the real page is installed without a flush, can that stale
> kaddr -> scratch_page translation persist, so that later kernel-side
> accesses at kaddr reach the shared per-arena scratch page instead of
> the freshly allocated page?

It can on x86, but it's harmless: that CPU faulted on an unallocated
address and got scratch-recovered, so reaching either the scratch or the
real page is fine. No flush needed.

Thanks.

--
tejun

