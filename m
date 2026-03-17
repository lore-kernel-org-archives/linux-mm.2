Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1F213FED9F6
	for <linux-mm@archiver.kernel.org>; Tue, 17 Mar 2026 17:46:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3C9CE6B0088; Tue, 17 Mar 2026 13:46:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3A17E6B0095; Tue, 17 Mar 2026 13:46:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 305CA6B0099; Tue, 17 Mar 2026 13:46:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 220D86B0088
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 13:46:29 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id D15098AF46
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:46:28 +0000 (UTC)
X-FDA: 84556284456.27.8349D23
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf22.hostedemail.com (Postfix) with ESMTP id 1FDD2C000D
	for <linux-mm@kvack.org>; Tue, 17 Mar 2026 17:46:26 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kr5RM9wU;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773769587;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=RFQ4/Uk0OnU8Uzn96aCwudKt9KCdVYsJEmnR9W6qol8=;
	b=ix+LGtxPB2OQlAPt1dtQ40tyc1nXi4CwppGcRMNaveJQujcnZSHDRRQ8X/eukiKpr3A/wu
	0/TK+LBnjQOZhMy8E7pfqOxCTzixLG1s52YP647yqs5u/zL/siN4F57jUYgDgu2akPJXnz
	z0xrDFNsKoFykEZL0dnzW3rY/w6M5BM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773769587; a=rsa-sha256;
	cv=none;
	b=nXQxFehC8FIscLQHPZ5hAdkJ18wMKwHfYxqlVb8fI/fgruodlOVXSDTDYSaTtwBeP6N4+7
	xuOgti/n2njYsS1COKbfZMgEm6sL3qSjrI556X0IX35ksMSlYYGoKz8UT7HqiDwgp8fXAi
	8YazNLsYmYfgYbx/cA5SiCBecz8JVA4=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=kr5RM9wU;
	spf=pass (imf22.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6B42460126;
	Tue, 17 Mar 2026 17:46:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0109C19424;
	Tue, 17 Mar 2026 17:46:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1773769586;
	bh=Neeh7yEwpO7wPq33nH/ZwuuqV0Bm2MY9dbkvHmC0dwY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=kr5RM9wUs9ATcTy0zc7o/9tj1vXw0pknsUZz1SYg0K99Vlr9lS/Ia+Owmfhrgjqwu
	 dyYMJekdmpSa/pcHBmElTxRq1UbiMiFNtJyc8BjkVOFFbjLF5xUMX/LYtLBfyYVa/z
	 FEF+TzW61e9+urqFy74VxpjQI0qWtx5Kmgr7eo3Q=
Date: Tue, 17 Mar 2026 10:46:25 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Clapinski <mclapinski@google.com>
Cc: Evangelos Petrongonas <epetron@amazon.de>, Pasha Tatashin
 <pasha.tatashin@soleen.com>, Mike Rapoport <rppt@kernel.org>, Pratyush
 Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>, Samiullah
 Khawaja <skhawaja@google.com>, kexec@lists.infradead.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7 0/3] kho: add support for deferred struct page init
Message-Id: <20260317104625.fd6a006871dcceaceafe990b@linux-foundation.org>
In-Reply-To: <20260317141534.815634-1-mclapinski@google.com>
References: <20260317141534.815634-1-mclapinski@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1FDD2C000D
X-Stat-Signature: w5ijcdkt83mx8xjpdn6rogozzmpzk1r4
X-HE-Tag: 1773769586-651010
X-HE-Meta: U2FsdGVkX1+y39sVxHbjYzxtFnD2HCINEF7dERXGTN4WlBXOiDd9xn99bYUneh7tz2qYQA1MELFnlbobL2um2RoTBdXfEcrIC/cwSugSY1RODIiPFy9SPS9AqQbCk3Y+qFiY1Hay2dm2h2+IF6ddVKHI+SX0/mP7SOnchEfFvuk0zq/9qv6cCnw8VW+KLyE1fjZn1vnroKfZAwgvqMlSi5AXpbJiEkN3uZZMCn2Xm7an3tpX5dvDTHR/EZp3Y2ZpztUlneyWZfe7RFAB74WLPUw8ioCCykZGlduqB9wawgmctc1RH1OHQIwbhgI8Kd8++Kikgg91Fl5szEER1NO+a4IAPprsFh2eUcv/3HU9pU9BVyEcjCrpwp858TsvRYC7iER8f0p5WbEgG2NG2QKIO/jqNAdyDK6SRY4UCIWz2brupDKFuNOIJomZMz8TQLVJY3Zuxh4v1H5RQEklBmN07Nt+Lom5v5YaDPJmoGVUBzj+zdeIG9lxDu/UFR3bmvik4guQ7Cxk9vwLpKyd4CcXh8VuC3EmdbYqG4BStmdXX4FDiRyTSEMkl3J/dhCYfpON/omIdSw0J7pkoTve1RZbWg4XDsNSHUIls/PTJsVMv6VQJeKlVg8f1DkiBBNW7h5h6Uapi2hUc8SPlYTZR5BO4tZHMmb4tEkkLZNAWoCBQzpSF6RoHkNNZVX+7fgu/3p/MWkMGHtstaGsQj6tAcgokgH1KkRuNOGHjOH3XHeEd+FrLGL6YVZKfATSaFG+EYqXZS8DJPB9QyqNA5VhhzLjm9OwWMp6JMhh/8qzzCqK5xAZcr8VYW0t6fbKyg/1pb115OdHHf/LtV4SkPwVxWJS2cmAQh8K0RgYR8BOTuhrIr2nlY0YNcZS6VgI/eRgI28QaU3mdmGthRLsKT0Ty0xZwskT7yhrp9pGmO98L9KN0SNvWjEzb0CgGFo/oxKfYD9xokOkvQxAeoUY4cRKdyz
 qI6nkj0m
 qxTHZR2f9o+Ru2KefMR7tGOP3upilGLnhHXgtO73065MbJWEer9CdIpdiAQHcxgmhkbDpXABezfgS9yqMdsce1lIjEP8Afmgk27imMHbp05FTqUe0VuNTfCKzEg6aqpdGucaZ7dfToOjbleBSQzDzZLdX6qcaadgucQmEztnEUkNf7ak1VjfBWDO7gRDNdiBgz0BJAqHAELNOfu6V6GC2MQ+avz593yUvnBZGHD67osjswbkDwKNK3o9CI3g1Pg2Ye9os0aV/PuQnwjw+47KP/5D3yg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 17 Mar 2026 15:15:31 +0100 Michal Clapinski <mclapinski@google.com> wrote:

> When CONFIG_DEFERRED_STRUCT_PAGE_INIT (hereinafter DEFERRED) is
> enabled, struct page initialization is deferred to parallel kthreads
> that run later in the boot process.
> 
> Currently, KHO is incompatible with DEFERRED.
> This series fixes that incompatibility.

Thanks, I've added this series to mm.git's mm-new branch for testing. 
All being well I'll move it into the mm-unstable branch (and hence
linux-next) in a few days.  All being well I'll move it into the
non-rebasing mm-stable branch a few weeks hence.  Then into mainline
during the merge window!

[1/3] and [2/3] aren't showing any review at this time, but the
well-reviewed [3/3] is the meat of this series.


