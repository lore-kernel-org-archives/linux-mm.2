Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BBD4C53219
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 15:16:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 43DFE6B008A; Tue, 28 Jul 2026 11:16:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3EE346B0093; Tue, 28 Jul 2026 11:16:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2B9436B0095; Tue, 28 Jul 2026 11:16:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id F229E6B008A
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 11:16:44 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 897B31C0198
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:16:44 +0000 (UTC)
X-FDA: 85038537528.11.3BECA50
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf02.hostedemail.com (Postfix) with ESMTP id BAD898000D
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 15:16:42 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d0Z57NRV;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785251803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=65vzM7nthly/ekwxzXMOlRAEVvzXqafNzBka2YxYPLQ=;
	b=LjKKpVdYRW5itj5AJPfdTl/o9UOMNDBAzJtzEXVTd8Ph8KGQnI7QY4K1pgFJiDjSBRF5nE
	V7X2WQKGA+BZmk2GjyENaSyvjIau3qJnR37ROCsT7EaNvfkHA2/iXO0uFywcGXng1QjBw4
	SQMJ44VMY5D6GdPxKnTJfIE3wsT5GlU=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785251803;
	b=BwKwCQuaH2soHFyYfXQF5F1EtmOnqvAKK2NeQ8NSe1etIfgHcqfhD+3/4K9zBiOAYhLZ+N
	5l9a4jxMaNAEjFcX1DMD945+cXgoghhOMxlk/GSPxm51+krn4VLkTs3SYJ+Ay97J184+Zs
	VqEEdyyvcp8h/P0WJySf75AZlWk2B2I=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=d0Z57NRV;
	spf=pass (imf02.hostedemail.com: domain of peterz@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=peterz@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=65vzM7nthly/ekwxzXMOlRAEVvzXqafNzBka2YxYPLQ=; b=d0Z57NRV/S+FMgNQth4ZfFg2xQ
	xG8atFc2UxHzyT06C6Dg6iHaU5Fx20Ob5hoBehVBdWDadmAErL3oGwcbCIeli8LSvT1Qf9ADj0Ue9
	VV0eMyluYyS1aiXMo8MpM3RICMIBLVZGyFAais6sGCML6LZ4chyFyJStnWGY5oShFDB85qNbHP/G7
	vGRqMtPeKGEYnVu6RWfUglNMh/cnkdD4/cZnfi0ze5miR7X1eKzYMipFnw/uAcdSZ1N9vDpvSlIb9
	+yIb4/TdyVncgIQUuUEgccxUCyZiuDmMbL1kWqeJSe+e+JjKRgVXbPJ0l/9tM6n3+9YeEmNafs3vh
	ymUsDl5w==;
Received: from 77-249-17-252.cable.dynamic.v4.ziggo.nl ([77.249.17.252] helo=noisy.programming.kicks-ass.net)
	by casper.infradead.org with esmtpsa (Exim 4.99.1 #2 (Red Hat Linux))
	id 1wojXm-0000000DY6Y-10zP;
	Tue, 28 Jul 2026 15:16:34 +0000
Received: by noisy.programming.kicks-ass.net (Postfix, from userid 1000)
	id 581C1300EA1; Tue, 28 Jul 2026 17:16:33 +0200 (CEST)
Date: Tue, 28 Jul 2026 17:16:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
Cc: Dave Hansen <dave.hansen@linux.intel.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>, Borislav Petkov <bp@alien8.de>,
	David CARLIER <devnexen@gmail.com>,
	David Hildenbrand <david@kernel.org>,
	Ingo Molnar <mingo@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>,
	Juergen Gross <jgross@suse.com>, Kevin Tian <kevin.tian@intel.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>, Toshi Kani <toshi.kani@hpe.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Vlastimil Babka <vbabka@kernel.org>, Will Deacon <will@kernel.org>,
	iommu@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, stable@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH 1/5] x86/mm/pat: introcude cpa_lock() and cpa_unlock()
Message-ID: <20260728151633.GX751831@noisy.programming.kicks-ass.net>
References: <20260728-cpa-fixes-v1-0-2ed2352300b3@kernel.org>
 <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260728-cpa-fixes-v1-1-2ed2352300b3@kernel.org>
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: BAD898000D
X-Stat-Signature: 4ifqmiieuyw3crw49mf36ykmwfhyf5gp
X-Rspam-User: 
X-HE-Tag: 1785251802-77054
X-HE-Meta: U2FsdGVkX19tdIseNG68DGyggCM2cpI2yGFBVL559OP5HwGwzOdjo5XJAaHk8a2/C/QQOjK+2nHQoVEynmTOyOcV97Pl3w+RxfvHKL1hTAWCPSnu2gqqF8TZEk9ETfa7uYYYZMkkro1Y+H7f6f9bUoboSCxKm/7VtXSLPZe/Pt2ibybNwoDapTzUPSbbJit4mD0pxGO+D0/CFUjB9S+AM8ogabaJSEQpVHd1LNRx6cgbY1bsIHkgA81Jpa986MGRjlUb9Ih7umtztrFEQBWHW04xqQIKN2ARFM3FZA8NrNNIz8VDUpLzRUATdnLuDnKTeyxiKstgQE0sGRm/2rQm4l/k9ykQ3JdlEB7jqpY+n7OCO3DZ0+YJK41Xy7nuWd7aYudyCcZrBizwIHegXbe/4mGGFw92ZR9KflUnUMHzHTLkDJDZYnBzhtz6heSBkvyVBNNqZDm2B8fUnDp2m5xT7zWPFIE83AMPCtBQ2/TR1gc+TEz+/CR6mFJUwEl2vry+dsO7vy6WfbsBFXsc1/mEOm9+WElOZc9P8/MwnFhjUp2q9+erquwW0v/zFrTlOVf/792WCYneaETsOISL5oXTn2KJK3kLmicVt2JzHzXjaUq6lgEN2KoV15sbpUENeb4iZE+JuiXRt2B2fwDnB6p9Myhx5MqMnq3CC+rDyCPiZ6+zN96rOZj4X8PDxK6M7WeBFEEGOHr95qPsQTTmq1F9CdJ08Y4jm8tnCQgy74zx/faovzex8JQUCM8Acjee813Mzwph3YPa3x+kzVjKtQZFRG++IyQntBM/EF9HKxqGi+fpa9bTODS6zWS2ITprgEgUj9t+v38ZSTauM3lAw4LwKS5LdlCuO57bvc9FEi8Zwrcs6xRbNeAQvf1vwRnQST6n2w3oQlpjF6eRiEpjmhdiPOSVOMJWCWZnTQ4hT4fx4+/og2Y7dluks+vcc5Kzw53j3xjuMdaW/BsDyTSADqR
 Vuk0WLPj
 X1jG3JjgL7NBKkA+YL5QFlY/5S8ArhIk1nofjrdB7/jOPbGnxqnF3nyLAVRjcZqtR2070lAE/aUSWBmrEan7NmHNA1NaaeEi9nv3npbMGp8OioFHRE+8b0KTL/0eL4ZkXRzI62avs9Y+qYcNMrie4qbfb5x8uHEHQ1y2VdCYpMW5k8HEjXk7MC3w5eR1x1UqVWPTZ4ljoAy6+y0ne3ALbNHelpDDlKocywYPEb+4H/+bDR2i18JxhbTMzR3JYr8d36WRX5G2abtXtjY7qdmzPgRn1Ozb4hyigulf2Jqc/Vv0UZ8HQA7mqcJwpuzXxFQpiJdIT2LlGuggYtcieADE/GUBnrIS4IhFcV1wXPUsqQGm9uPk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jul 28, 2026 at 04:07:44PM +0300, Mike Rapoport (Microsoft) wrote:

>  arch/x86/mm/pat/set_memory.c | 33 +++++++++++++++++++++++++--------
>  1 file changed, 25 insertions(+), 8 deletions(-)
> 
> diff --git a/arch/x86/mm/pat/set_memory.c b/arch/x86/mm/pat/set_memory.c
> index b1e780a465b5..4c8922695fd3 100644
> --- a/arch/x86/mm/pat/set_memory.c
> +++ b/arch/x86/mm/pat/set_memory.c
> @@ -65,8 +65,25 @@ static const int cpa_warn_level = CPA_PROTECT;
>   * Serialize cpa() using cpa_lock so that we don't allow any other cpu, with
>   * stale large tlb entries, to change the page attribute in parallel to some
>   * other cpu splitting a large page entry along with changing the attribute.
> + *
> + * When debug_pagealloc_enabled(), page attributes could be changed in atomic
> + * context that would warrant disabling IRQs. But since debug_pagealloc always
> + * uses 4k pages in the direct map there are no races for splits and collapses
> + * and locking can be just skipped altogether.
>   */
> -static DEFINE_SPINLOCK(cpa_lock);
> +static DEFINE_SPINLOCK(_cpa_lock);
> +
> +static inline void cpa_lock(void)
> +{
> +	if (!debug_pagealloc_enabled())
> +		spin_lock(&_cpa_lock);
> +}
> +
> +static inline void cpa_unlock(void)
> +{
> +	if (!debug_pagealloc_enabled())
> +		spin_unlock(&_cpa_lock);
> +}

If this lives, we should probably stick an assertion in both the split
and alloc cases for holding _cpa_lock. That debug thing seems to rely on
never hitting those, but having that be implicit is asking for pain.

