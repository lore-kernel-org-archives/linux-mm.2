Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 711D6CAC599
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 14:41:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 894858E0010; Tue, 16 Sep 2025 10:41:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 86C7A8E0002; Tue, 16 Sep 2025 10:41:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7A93B8E0010; Tue, 16 Sep 2025 10:41:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 694088E0002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 10:41:27 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 141E01601E7
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:41:27 +0000 (UTC)
X-FDA: 83895376614.05.CC95CC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6237C40009
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 14:41:25 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YZu3ijss;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758033685;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Rl3PfUKjl2JoVNJ191B+kLBbdZ4ITYuMp+Nygsw33BQ=;
	b=S6cFmXIPKxqI8AUcLUWV3B5EbOEZIfvbrzRnU7VjrMm+tVjvkMlpjiVf8BbBJs64WqeBJF
	FRf2X2f4FvacZfEwwPwyexjhkIAY1Q5NCRGWmZPMroxrWAd5Xrv/n7osvk/e7AjMgvcmDz
	Vfw6tYM3O3SBQCo3XcAc7akDrnSQNVQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758033685; a=rsa-sha256;
	cv=none;
	b=fmYl9FXZL2urXSkGqQVE+squYYyDop5JV8PbfbiMcJsL42BpbbfVRtCntZN59YyeIp0rCR
	y8GstEnIHeQqtismfyTiKzdSucU3HL5nv6E8FiZm08SzNXHEDtLwHexOafqiypc+heo2zX
	KWvyEwQ6TK53mDN5o5k1C8RFa/4Yu3c=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=YZu3ijss;
	spf=pass (imf01.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 416234375D;
	Tue, 16 Sep 2025 14:41:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B066C4CEEB;
	Tue, 16 Sep 2025 14:41:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758033684;
	bh=pmJ6FNI376ycjtQaaN8sACRuV+7IyNdiBXbvSGwTn4I=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=YZu3ijssENglOnURSerpM3JLIbhS9/hpMCoVqQhWFCXpniBu2lgaawd2xNTfv4uK0
	 JnpYYuGXLpWk90+FMLagcSonqqfnaooTN9wEe9SRLGVNu26OLG9/JRjYxIHB70L4ab
	 YXcPZ5kYoapZGdwLZ4Trt5SFbW87F/uh+1nvgYFBk1X+pCOKe1FNROUDL0QkytGNTI
	 bidl46eVofmaBxLtcF0hKniskx0ZHbbsOSS/rk8TwLp3AvHc5bzZf50IGO5UI9iUFg
	 +P5V7b9EmaXQS7OfqIuJS3aQY0MnuaV+3wOzcKhCmp38KfTNapAH6JJpnioAoJuN/F
	 Sg7urIoXBE0Sw==
Date: Tue, 16 Sep 2025 17:41:15 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Pratyush Yadav <pratyush@kernel.org>
Cc: Pratyush Yadav <me@yadavpratyush.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Alexander Graf <graf@amazon.com>, Baoquan He <bhe@redhat.com>,
	Changyuan Lyu <changyuanl@google.com>, Chris Li <chrisl@kernel.org>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	kexec@lists.infradead.org, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 1/2] kho: add support for preserving vmalloc
 allocations
Message-ID: <aMl3C-jSa1_TBv0K@kernel.org>
References: <20250908103528.2179934-1-rppt@kernel.org>
 <20250908103528.2179934-2-rppt@kernel.org>
 <mafs0ldmon784.fsf@kernel.org>
 <mafs0ldmnlmq0.fsf@yadavpratyush.com>
 <aMgey9qEC_XUejXm@kernel.org>
 <mafs0bjnaimvc.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <mafs0bjnaimvc.fsf@kernel.org>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6237C40009
X-Stat-Signature: fnkcjyh7exx4h419dstyk1hjenkun9rz
X-Rspam-User: 
X-HE-Tag: 1758033685-141421
X-HE-Meta: U2FsdGVkX1/rUwBZ9JTAareN/l8oziGPPQ/3RaHXnST5SC6Mq/TeyCDWwLTdHnswpfRSj8I/SCFcObrXOFkacpVMRoHOiMAseIatH+7Jv/IjxPeAk6kEF10+R0SRwk2tknrfF310m6/YfCraha9f32QRqqltQbERt6QxrAaALoTPLbA72pzP8oFQ+QBK6a36PNw1wWHDI5YnLsFSKkxw7CuNwP1AvxVd1c0vqn6wkGfsn3oFYsks+3dcP959pGeXJ+tJ2Nlsof+O0838HTDQcaC9rHkaL3tpp1lZ+tgD+pBTNbwAewb19BTcSRM/7qZA/AJ/v/IgCfIENZg28RV4lafl3e/+1Z46WvSBfLtj+lr6GcZWrSALYgU1X9Ozfu9xaYicU+4a7hGvvyZLfgAZUWIsEPUPkwvT3hf05gI7SlIY3Vl6QxeW1BZfJbtc3MzDiMYHRenQn9hcvw63EaRSNbHaTZNaJUcyt3HGfniPxD8SoMqqdGI6Ks7A/5auCend+J+VmCMlUip1K6pJK+5LEnbGCkkN8azxInqlPbFUSvHV2NhAMxcBMpi+n/c0v6HhJGy0ZRM9ykalrKSEWmyadErLnyVAfFfpevHYuXVd5hNFMj1hpkcOY5V+cfOiILgAgqjsY0yN/GDjsLeNdPB9Qtwv6Y5uGEZxXNK4mgfQR1D0ZToB9HvuhUw6ERFxYWQzf3eSzm7dqpHzMF0KR+CYxh9p1i5vvajP988lO8rfbCseGTfi5fuHWaxByWg5zt3+RBh8Aub+1PrUYSaEU5rYQ/8lEpmHuhgAMsgoqE76X1f6KErWZzduaBDtkpQ8y+S8O35iHY6WyjDSR9r75XcKNHF/4CWU/e7+5jDpCHc3bJUefn0cgQMhY2pW5aDv1ggbp2+CORVshzm3SIlJo4VIsMJo6kISADAqfNQ7nUGb5Lvtfo2S77DurMsKTcYtJhyTqxjTJAWQFdaFfeS766W
 llM4nID+
 olMtvJ5mkX9RwEPwyClUVkUnfwTfwlBHveuAwp0eZv1vw2CsPsP3FoN8Tji7b6kXFfNwx3fFmrifwk9ujJ8CtcvHTQw/U27dCEgZZcxCUMiAXpjJN0QhLD9fKStcRJyR4I2IV3NES79hijorcwoMfOl84T5nrdWxof8FPciPkG8dgLJhvIiN6kL7SDK4CSk+f44h3Q5bLw3qHqCqneRgGDqVuVKpUnS7U/qB2RDFTEM7nGcHWoGPPnUHivzp4RwAS5OzwthuvjQcfdCi1nqszfgWfkg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 16, 2025 at 02:48:55PM +0200, Pratyush Yadav wrote:
> On Mon, Sep 15 2025, Mike Rapoport wrote:
> 
> > On Tue, Sep 09, 2025 at 04:33:27PM +0200, Pratyush Yadav wrote:
> >> Hi Mike,
> >> 
> >> Also, I am not a fan of using kho_restore_page() directly. I think the
> >> vmalloc preservation is a layer above core KHO, and it should use the
> >> public KHO APIs. It really doesn't need to poke into internal APIs. If
> >> any of the public APIs are insufficient, we should add new ones.
> >> 
> >> I don't suppose I'd insist on it, but something to consider since you
> >> are likely going to do another revision anyway.
> >
> > I think vmalloc is as basic as folio. At some point we probably converge to 
> > kho_preserve(void *) that will choose the right internal handler. like
> > folio, vmalloc, kmalloc etc.
> 
> Sure, but do you need to use the internal APIs? Because doing this way
> would miss some improvements for the public APIs. See my patch for
> adding more sanity checking to kho_restore_folio() for example:
> https://lore.kernel.org/linux-mm/20250910153443.95049-1-pratyush@kernel.org/
> 
> vmalloc preservation would miss this improvement since it uses the
> internal API, even though it will clearly benefit from it.

The core restore API is kho_restore_page() and the improvements should land
there, IMO.

Then whatever uses that core API will benefit from them.

-- 
Sincerely yours,
Mike.

