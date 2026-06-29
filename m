Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0D6C7C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 20:18:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BD1426B010E; Mon, 29 Jun 2026 16:18:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA8B76B0116; Mon, 29 Jun 2026 16:18:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AC17C6B0119; Mon, 29 Jun 2026 16:18:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 7CA256B010E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 16:18:10 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id E2F4C4028E
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:18:09 +0000 (UTC)
X-FDA: 84934061898.29.5216A3C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf17.hostedemail.com (Postfix) with ESMTP id 86D4E40003
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 20:18:07 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QDqBxaV+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782764288;
	b=C9+ygWT8lSQuVc9wF0HRfLST+IIZqVoa2dS5YwXfJkCPeV/coaAbmyhKILP3foTihTeemO
	54CRUlRgnVadiif/39RBpCi2FJOql7frrg42acLkvXhzRInzRYg3loc9OMeOhn3sn1SpDS
	ulqvVijzCYX4cqAQXO3BE4FLUT+JxdY=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782764288;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HNZ0qyY1NIkUeBVNfz2O0XGsUQ0RfZrNUaEdXxQ0jaE=;
	b=dNspU1n6OL077OpJXncV3KnaPEiFmgn7CWKJjPQI0eJhgf7nyK0ENlrwD2kBw5lJwGZHcu
	bBgQEfayejDs3gZ4kXU1WrYtiiphs8rfC8cXE7HpAshPDFDiYiHf3P/z7yYENSQ9s2Tqgo
	FAWbqtrfUwbSCwR6PphuNOigN9hPmnY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QDqBxaV+;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=pass (imf17.hostedemail.com: domain of willy@infradead.org designates 90.155.50.34 as permitted sender) smtp.mailfrom=willy@infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=HNZ0qyY1NIkUeBVNfz2O0XGsUQ0RfZrNUaEdXxQ0jaE=; b=QDqBxaV+VaAcyGm2fZtZ/xYYNX
	eykSlBQjALG9c3qtEyuf6iXzzrvy5CW/I8X7sANPtN7z5foPE79fnluQp0OeH9YjJ0fD4UfBgkjS9
	Uydkq/zlxgR/a51ixPPNdwhJlZa6OO/k8iYEFJfSau6Gfl+aWDQLFq8I0LYAFSQhUZDtk1AfNuHuy
	fwutNJLFA4BbVJPC7Bn63V1b8iJ3WNkWGg5A3g2nrEfqXgfstr6oq78AOXqfzwvIzXxt3GQDSwy3A
	1Gm16NEOVIdfYefEPEcEz47oN2JKaxLyiCHlMyO/euuqqwNox+U5SEpk8v/qJaAOrqhxcnUBPRh1j
	voAdQNCA==;
Received: from willy by casper.infradead.org with local (Exim 4.99.1 #2 (Red Hat Linux))
	id 1weIQF-00000003mn1-16Yc;
	Mon, 29 Jun 2026 20:17:39 +0000
Date: Mon, 29 Jun 2026 21:17:39 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Dave Hansen <dave.hansen@intel.com>
Cc: Thomas Gleixner <tglx@kernel.org>, Zach O'Keefe <zokeefe@google.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	David Stevens <stevensd@google.com>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Will Deacon <willdeacon@google.com>,
	Quentin Perret <qperret@google.com>, Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
	Andy Lutomirski <luto@kernel.org>, Xin Li <xin@zytor.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>, Uladzislau Rezki <urezki@gmail.com>,
	Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [PATCH v2 00/13] Dynamic Kernel Stacks
Message-ID: <akLS44JGF59hh6aN@casper.infradead.org>
References: <CAAa6QmRw6QLnVJ8+uvMV8ASreLXzSab5Jii3Ju11qCZYio6Few@mail.gmail.com>
 <c070c4d6-a570-4eea-aca0-72eed319a198@intel.com>
 <87pl1md7h0.ffs@fw13>
 <CAAa6QmSHBDeY0G=_N1P4dAAH917J7jerfZrWDfDd8w=8jH8nVw@mail.gmail.com>
 <87qzm2b39k.ffs@fw13>
 <CAAa6QmTO=hhdJQa-ofSZ6wW0geLaEfWZumF6KmksxZqM3i33OA@mail.gmail.com>
 <87mrwon5uw.ffs@fw13>
 <CAAa6QmSeq8bbckyJk_5HFagsHfS5SXbG4y6Y-Py66eYLgvjcUg@mail.gmail.com>
 <87cxxgly12.ffs@fw13>
 <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5604a47b-9457-4162-bd23-720e29cf1983@intel.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 86D4E40003
X-Rspam-User: 
X-Stat-Signature: dg5xbr3j49st31fhiekbsizfr3fjncd1
X-HE-Tag: 1782764287-79283
X-HE-Meta: U2FsdGVkX1/ZtvlcNu9nDcOnJQbyoioZNvTvntxd6OE99ZTDcHfcEizuqELFv3nLMZdpu5msdQcxXDwibhqOUcL0TKSQCqI4m+05NC5qcmZKh0EbsN6TsnxBF9PRv+d37fth/RcS9C26NtywDh+h0mZZxg9x+EvDhjymgycOMTpvQ91eMibrqYRukp7yzYFkxNTLDC1SPW4eKWt2qe4ZezLevK6xdHxL7Cuiw2ZCr5g02EQAYe4pz6mqb+eRrvKcK2ilf+XE3BgdMVufiSUUE/Vv7QnrDsOJOLP7d589/q1uvtZ/7uj5V3I+8D/DTqR4U3Dv6Do9ZayNj2RZm5dbKvjj7sukucPagqefAd4vviA1MtlJR8UXkbEMNo2UNyEJ2tlvJuq/93VQLtZqkWXpbXFNADRHVcv5kIIboRxeRetyzleXgydJKvhotTM7tAwg8caFLLT4vfOFJNJW9vHQ3qs1lr2Bhszan9926u9hJvYMrLgtaO3s5t/2OZ23mclgvfFRMeFootCVXK5yrAseP+boe7g0w10qCztXoPHkxTWb9h/MBpVzwg71yrClb8ubv0uUercEj5eg9m8UA9IPBZpuAZ3QrHZ6YLbTLlhXY0tJibELYaw6Ba0yBRSAQTToVR78I/oeIQS4cZOOz31QfZL1AXhGUeo5KP57W9Cn4LQklfoecfqs66rIeUJO/qcMpLIiMf/dxX3wbCnVadduR2aBvEE1CdxEN7U8kTdNMQnxzkpLnDDQsyy9DHd2kxaQ16BkVmIkZs8ZSd/0QMaUqTG23Je9IZ7pmxp6uMUQtsgAoqCK4q8yr3LuWz4wASRIpWJ8shnmH7A6m1cBcTR6OE3AqQ66JRAh8GAtkSKRl7UCJNTg1Vrr28DomKcfgfvKnqz1cADksdIRFlQHF8mAlUW0VqIWitvSVJfsXoB1Wq8q3KL+OPV3RyXl5ALFCqwleYX3JPtKODEKxZL64oS
 aWa0g3k/
 w7+pQWfk0BAo9GeVlrs7eiX8mFytntX3yrpQo+OpelfgBwt+DWQJGBJRKdPH5qK5WPUuHuk2GFi6RRfStPTrx9TIjLreVyxZ+pbpMX1dqYOU1XZ2OdLwZHPdWtBp8DbU0ih1yhmxlCvcYUS2zMWp2ClEO+k2rspz6xbj3YUQGphnY+jzItJpQiD8ER0fisqMiJWMFtlXcP8l6372fAb4Cd+0nI5KeJAsgf+Thh5aEAVHJL9WMUPJCf60lTJ3rYwQlwYXkjw0ITtwUzH2HRRDkbl+6sw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Jun 29, 2026 at 09:02:08AM -0700, Dave Hansen wrote:
> It could be done with really little overhead if the vmalloc()'d stacks
> set Accessed=0 on their PTEs and then checked them near vfree(). The
> PTEs are already getting touched there, so the cachelines should be hot
> anyway.
> 
> The granularity would only be 4k, but it would be so cheap that we could
> turn it on universally. It would also be 100% deterministic.
> 
> There are, of course, more games that could be played with stack depth
> checks on normal interrupts or NMIs. But those would be less deterministic.

I mean, if we just memset64() the whole stack to 0x535441434b544f50 and
then searched the stack for the lowest word that wasn't that value at
process exit, we'd get a much more granular idea with vanishingly few
false positives.

