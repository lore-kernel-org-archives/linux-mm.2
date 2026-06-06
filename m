Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE944CD8C8E
	for <linux-mm@archiver.kernel.org>; Sat,  6 Jun 2026 16:06:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C321B6B0088; Sat,  6 Jun 2026 12:06:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0A406B008A; Sat,  6 Jun 2026 12:06:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B46686B008C; Sat,  6 Jun 2026 12:06:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A65706B0088
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 12:06:20 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 28BF31C1B98
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 16:06:20 +0000 (UTC)
X-FDA: 84849964920.17.3A8A9BB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf05.hostedemail.com (Postfix) with ESMTP id 0A955100013
	for <linux-mm@kvack.org>; Sat,  6 Jun 2026 16:06:17 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Fioo/WXR";
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1780761978;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tNfkwEURV/025o1JMSHop7cofA++kyQHuGoph8UTpwE=;
	b=knl3Nnt9J4RZyvy3ysZwGfgfTZug3Py+0GMHKjz6pQnWOzOc0aTEHio1N1jRrOi5zi+Tj4
	d6EPWGKcXL373QCBOdmHRZkWfSk8mpiXVrN9Q5o9nLMWtXzZ9EkCjjPGQ2R6nxAFEsB78e
	pN4pJsb1l/5icl4Ny3rHivwWpVWZ/Vk=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1780761978;
	b=PAKriWt760RK/mVS+Ewjhwyw0hOoQs+jChia7q02sgSB0ARtQVWZ3JfcZJB0jAKramOAYc
	zCTfxRK0uzRBqR3eGVmbdDJ+ZSYj1P1SVcroVmKPZcxLjGx1EVYTDEmRwUUsqpqGO7kFmS
	FTmZUbifRDGkkdu742wbS/X6TpcLXrI=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b="Fioo/WXR";
	spf=pass (imf05.hostedemail.com: domain of catalin.marinas@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=catalin.marinas@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id CE08C4E42;
	Sat,  6 Jun 2026 09:06:11 -0700 (PDT)
Received: from arm.com (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1A11B3F632;
	Sat,  6 Jun 2026 09:06:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1780761976; bh=snvrP3iXAE7+rPVGPdv2I0d1O8un1BOK8oUMCKBNj7o=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Fioo/WXR+6E2VeHXtpMTCyYZU27JnoxYA6CB0uRghrHJ5aZZyaaIcZRxJ0aH7JFsW
	 xngkbzIzYdlUW15WY/Z2u7zCjIdmVIrsHgk/6sOUrC+EbqbHreg/CDeoNlbonXt/pY
	 t9S0fleMOnVpzuZZbKKbyRo+Fo9udRji81CSAdsM=
Date: Sat, 6 Jun 2026 17:06:11 +0100
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tejun Heo <tj@kernel.org>
Cc: bot+bpf-ci@kernel.org, void@manifault.com, arighi@nvidia.com,
	changwoo@igalia.com, ast@kernel.org, andrii@kernel.org,
	daniel@iogearbox.net, martin.lau@linux.dev, memxor@gmail.com,
	peterz@infradead.org, will@kernel.org, tglx@kernel.org,
	mingo@redhat.com, bp@alien8.de, dave.hansen@linux.intel.com,
	akpm@linux-foundation.org, david@kernel.org, rppt@kernel.org,
	emil@etsalapatis.com, sched-ext@lists.linux.dev,
	bpf@vger.kernel.org, x86@kernel.org,
	linux-arm-kernel@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, eddyz87@gmail.com,
	yonghong.song@linux.dev, clm@meta.com, ihor.solodrai@linux.dev
Subject: Re: [PATCH bpf-next] bpf: Replace scratch PTE atomically when
 allocating arena pages
Message-ID: <aiRFcz78QTZdIHHB@arm.com>
References: <20260601183728.1800490-1-tj@kernel.org>
 <f45f02410d23c99d14f3577da9b27a327816b5a0904bdeefc8e229eac760d1cf@mail.kernel.org>
 <8f133924fbf8d259340f3057e505f663@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8f133924fbf8d259340f3057e505f663@kernel.org>
X-Rspamd-Queue-Id: 0A955100013
X-Rspam-User: 
X-Stat-Signature: gixyese34cu5jess6f844baseu8ad3ks
X-Rspamd-Server: rspam08
X-HE-Tag: 1780761977-374408
X-HE-Meta: U2FsdGVkX19t3gKgIzMEI4UkM70/n1JgCLgUyio1gUd7XQyaFkg2PN0/RWN5+hwo2WJqejEuQ5L39FVpQ1HTzLglM8rKWkm3onQmfQRGlc3Sbi3Z6cd0FWkNVvTzfKjU0L1znH4gYStPO3bcnNsalKW+fpxCwsLTQSQnYUgvfZjc5UpidWSGF1F1yaqiyEToLDWRrdBOr0nAG0u29hWJDP17rXsJzgJdrrIZJZbei7RGJhKXRQ2TusYA8q5UMOIubOCdgBWvDrPs72WMOwU1Ynl5NTd+GRjbPv82n9HbW+RUEVx/4cTcgkuk9jGJtw7BqW7YiX6+o/afbAx9Qu78zfl+mAbqdlK+lozLni5qTy7C5ZO1yWEvXRJM8UzBQpjko9e7hVYb3Sdr9XtHJElBzQjWAZwfpebrCLwoE9eylx6OuGpx0E9EUiombtZR9piWnuN6r5iV/DM2jsYy3eCsAj7rQcZ08Y+6uraTKr026kq7xiGm01/IZPiF/RXF7AlO5fgPeuxGNSMBGOr9Zh+3CfYeG5vXU7tnakOPjZ5dywLv6BnAWi1O4n+sJXo6mDuX+G+4gH89kImDfanFtGhcPdJmUyWjJMnLXPJrRYbvWYSSzPWLUj54GGJP3Urfk+hnkFd3b3vavs63Tf5HcsJNSCckieCCvJppuHFjfq+AbsCFI8GqN5kt6NbBlEbdaulsA17aFhLkGolVSn7AVh/b00me4AWcSnrqiwxzeneFnLdiAOyh5jQz93egDf5SbciJL0n1IGjPuZ+y7+8FNUjtxQSzn+wQxzxqp7rOWQ/j04ijcUHh7XdidPLpYRuHFFf47J68yN5MtT/UUnOsdO0qsx4R8rc5jTRPgyI5jL0B5MD2+DfCyaNGePoH/hyp0+Hp3AvPsEJ20CiN/2TQ944TcKayKb6S7825DE27ABK3y8RlKwMsVZp5SyFTjsFabJGSeJGlYYuPiwwNtJGDPig
 hlcm/glS
 OxfbEzjIcdseluSJeuQlSBGfT5YzpUC30HSrOEd5QmSgqUgEZ564CBfPOhJM1ISWzf+dLHQgMn0HqAL9AQRbVLVRIneE7FXpACTVn4YaQl6NgTVfhmVQVtlnzFElRO89/PThVix/fsmANwUdyj57XxE0RcModJsQs+c3IPsHOkhr0oYDxYtUO5uLmaB+GWgr9ASgSSHu1SpY3EBU5zjuIKq1zfP52E09TVljOykt0Ht5tHQuOGAOOD/O+SwIGJCRe3qBLM2B36/ANRId9G7PNBITRvJiknurlCraAqwUJbsUoKOUblG7i/TfeSEMKAW5lnJZhIl8Ogw7/9rPZ5/zHhlCjgbF21ydKu/4XC5aZlAJCtO20UJ2d9MvqLg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jun 02, 2026 at 12:09:11PM -1000, Tejun Heo wrote:
> On Mon, Jun 01, 2026 at 08:15:34PM +0000, bot+bpf-ci@kernel.org wrote:
> > After the real page is installed without a flush, can that stale
> > kaddr -> scratch_page translation persist, so that later kernel-side
> > accesses at kaddr reach the shared per-arena scratch page instead of
> > the freshly allocated page?
> 
> It can on x86, but it's harmless: that CPU faulted on an unallocated
> address and got scratch-recovered, so reaching either the scratch or the
> real page is fine. No flush needed.

I think for arm64 it will be slightly different. After making the pte
invalid, we flush the TLBs and subsequent access will be fault. However,
ptep_try_set() is missing __set_pte_complete() with the necessary
barriers. A subsequent access may fault rather than hit the old or the
new page. Something like below, as a fixup for 258df8fce42f ("mm: Add
ptep_try_set() for lockless empty-slot installs"):

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index 3ce0f2a6cab6..dc8525431273 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1838,7 +1838,11 @@ static inline bool ptep_try_set(pte_t *ptep, pte_t new_pte)
 {
 	pteval_t old = 0;
 
-	return try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte));
+	if (!try_cmpxchg(&pte_val(*ptep), &old, pte_val(new_pte)))
+		return false;
+
+	__set_pte_complete(new_pte);
+	return true;
 }
 #define ptep_try_set ptep_try_set
 

-- 
Catalin

