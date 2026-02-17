Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22AE1E909AE
	for <linux-mm@archiver.kernel.org>; Tue, 17 Feb 2026 15:22:52 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 852096B0089; Tue, 17 Feb 2026 10:22:51 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7FC866B008A; Tue, 17 Feb 2026 10:22:51 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EC1C6B008C; Tue, 17 Feb 2026 10:22:51 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 5DC856B0089
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 10:22:51 -0500 (EST)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 26CEF1401EC
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:22:51 +0000 (UTC)
X-FDA: 84454316142.05.B99FB05
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 491DF140009
	for <linux-mm@kvack.org>; Tue, 17 Feb 2026 15:22:49 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cJhz2one;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771341769; a=rsa-sha256;
	cv=none;
	b=ABqeQxrRM+Z+D1AppMvdI6y4MKmB+WaNF0ZxA5Y383fBH5VmjHHMCQsmD4kYl0P0VfXtGv
	YLiW7lHsGNlLzRursP3EU/Zsz/DaGJZcMrWLJNTlLuUx2pfpBRhj0kjTXh67xeZJZT7wrj
	KH4EvLtvM0S69S0jUpExyG/Mk96/k1o=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=cJhz2one;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771341769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3v3iihKPRUq2lJ7DpDwis3kzOh/HRjfIlqh2T2bN4Go=;
	b=BOi9aihMGkapjIatTg19ohhFD+TaUobypVD9YBASHNyh1eu7OlKZOJ+oJG6nHMArSMblD9
	w/Q1Rp2ktwVaT+ahfNRgbdhp+3wflZmSvvEVjl85OZiZ0uzJ37f04Cch62ehxWY54r5Hav
	nXG1+crOeaNe0gh+DS9j6sSTsdH8mWo=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=3v3iihKPRUq2lJ7DpDwis3kzOh/HRjfIlqh2T2bN4Go=; b=cJhz2onesJWPuSPL6UovTP28i0
	YWnL2OjoVBVS3poln5ga6VoZExz7eNAGEfM4FuokslPZdMLlJFPjHjaEo6wAe+9oyBjseHroeEcMq
	D99BawkmyMO07Tjk+u4sm0GGA7M7WQ/MGKb4QKcuUmtMWuEQVWosFadafbHFUUO5iyVC6pHcVxQwU
	bSTrXdA5pYkE9riOouKrtZev5ZjrnzEYwbs0yDS4wYpTWUA5wkbjo2YFNuq9i4xaccVb0wLMzCuZ1
	po8qhRcjhPoOB8ryWMxC60GtPzIRAGxFemilPIBdgp6KKDlTbhRm/I3gBmVEZOJUj9QsjWWAz9gjJ
	vybrXPjw==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vsMuM-00000004am9-3gxc;
	Tue, 17 Feb 2026 15:22:38 +0000
Date: Tue, 17 Feb 2026 15:22:38 +0000
From: Matthew Wilcox <willy@infradead.org>
To: Dev Jain <dev.jain@arm.com>
Cc: lsf-pc@lists.linux-foundation.org, ryan.roberts@arm.com,
	catalin.marinas@arm.com, will@kernel.org, ardb@kernel.org,
	hughd@google.com, baolin.wang@linux.alibaba.com,
	akpm@linux-foundation.org, david@kernel.org,
	lorenzo.stoakes@oracle.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
	rppt@kernel.org, surenb@google.com, mhocko@suse.com,
	linux-mm@kvack.org, linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: Re: [LSF/MM/BPF TOPIC] Per-process page size
Message-ID: <aZSHvt9Trlq7k7aH@casper.infradead.org>
References: <20260217145026.3880286-1-dev.jain@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260217145026.3880286-1-dev.jain@arm.com>
X-Rspamd-Queue-Id: 491DF140009
X-Stat-Signature: 5ecsbuueppfah68rhpn7hrfseh3p6w1y
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1771341769-89927
X-HE-Meta: U2FsdGVkX1+HGY4Puq/iJIqhaNnwZWdzjY5F2/+KMtjrnc57YV2bgd7SDjnaQvNoOcNlJihRI3VXIr0JlqMFMRTca7ZYogptnd/+v8kCK1w3kBgHYp0dPnjRcfqf8SMlayGPJYcYjzKSXAX7J2QIWTYx4zLsjPD22UxAUAc/t2C/kTGT4l7PNLw4KMLhVAGXbyiU01JaOXKhcGND1gcWLdQifGunWV3bICGfdT2heq2xfTgEvop8EWzIprWaCfwJjZT639GluTaARNolj04ebhbRUFKl0tsKpJRMuycuxjq9Yop44qiE9dqpBK7bcxA+OMiC807WorK3boKC6+MNSUP+WkW8GzmgRh79Mm/rU4Aw1avUxsNmF/6p3FtY8D2/wXxAt/jydvT4p+OeZAZ3TC5VTZj/OqdHrq+mIyXNpFPLheCVZwebpoOGpdMfaLme0u+xxKzcRWoSqaqP2tkT+wmN4/senrO1Q3kmKmppriEZZ8Lwac/1DRzEp/o/NhunCOzfz5JoFslWpb2JdQYpcoltsfUrYd9OY1x3a9nT/VxxWiw0pkOwbshKGIILIrb/+OkRwo9GCo/WPZ/1dcRg/ILEc5I5hOHS/J59obolrM2TnYg+c7ms8P+1qWZGiMUgnswhGbo8c8r2RTit/2TE1FhGPtpWXyaxnafY2g49X3UMdF9tB5I5xMO8WDuuD3jKScuyWd64gpUWSRDpis1j22Sy3lKK7poCvh+HsBDH7rK2zeXxWkQzGxnBXJUWozHWTtCzA39I2e067l+yi6q/quUZ1S1w0h4a5xC6HaDGBgGIDfQAYKeL4Q5tOVXA7GmqV5HGTsXDw8pO91D7vMvjr7NcOHLQcFOm0Nw/ou0c2M+wesf0JQBqhZZiuUIK/1ZtFR/F98gIQHuBsdp960aopE1pGl9MiCv66R5UXgjcyWpLdKrjgUyBkiChc1JT9WHNuAOzK12ZICh/kbcVXnA
 ikPlLzH9
 +PLm1uOWODWbTlYG4mXvsHSOQURpMaisyVNJ9XEOMVMAAliT0ADCQTA5KN0sKXm8XYVZk1f5POBJgMp9vKjCkEYN3OTE8v1iAtdrugXNM33b634H5ibKtetTvALQ+M+JHcSR6IYbuY2Am5KMpv40zfeIR739/RECgOWawYjID4dBk9zuBQEIk/Gw/IXSLhDYxrQBXChEsogPWIOKmFh+rbIRgoEZvnudc3uBS1KIEsE/x5teCEtJMML2/R/qmgMrcn8l3
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Feb 17, 2026 at 08:20:26PM +0530, Dev Jain wrote:
> 2. Generic Linux MM enlightenment
> ---------------------------------
> We enlighten the Linux MM code to always hand out memory in the granularity

Please don't use the term "enlighten".  Tht's used to describe something
something or other with hypervisors.  Come up with a new term or use one
that already exists.

> File memory
> -----------
> For a growing list of compliant file systems, large folios can already be
> stored in the page cache. There is even a mechanism, introduced to support
> filesystems with block sizes larger than the system page size, to set a
> hard-minimum size for folios on a per-address-space basis. This mechanism
> will be reused and extended to service the per-process page size requirements.
> 
> One key reason that the 64K kernel currently consumes considerably more memory
> than the 4K kernel is that Linux systems often have lots of small
> configuration files which each require a page in the page cache. But these
> small files are (likely) only used by certain processes. So, we prefer to
> continue to cache those using a 4K page.
> Therefore, if a process with a larger page size maps a file whose pagecache
> contains smaller folios, we drop them and re-read the range with a folio
> order at least that of the process order.

That's going to be messy.  I don't have a good idea for solving this
problem, but the page cache really isn't set up to change minimum folio
order while the inode is in use.

>  - Are there other arches which could benefit from this?

Some architectures walk the page tables entirely in software, but on the
other hand, those tend to be, er, "legacy" architectures these days and
it's doubtful that anybody would invest in adding support.

Sounds like a good question for Arnd ;-)

>  - What level of compatibility we can achieve - is it even possible to
>    contain userspace within the emulated ABI?
>  - Rough edges of compatibility layer - pfnmaps, ksm, procfs, etc. For
>    example, what happens when a 64K process opens a procfs file of
>    a 4K process?
>  - native pgtable implementation - perhaps inspiration can be taken
>    from other arches with an involved pgtable logic (ppc, s390)?

I question who decides what page size a particular process will use.
The programmer?  The sysadmin?  It seems too disruptive for the kernel
to monitor and decide for the app what page size it will use.

