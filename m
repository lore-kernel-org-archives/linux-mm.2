Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2ED50CFD647
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 14:53:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 93EAC6B0096; Wed,  7 Jan 2026 09:53:45 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8EC376B0098; Wed,  7 Jan 2026 09:53:45 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7F8006B0099; Wed,  7 Jan 2026 09:53:45 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B8E56B0096
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 09:53:45 -0500 (EST)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id C35C5B837C
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:53:44 +0000 (UTC)
X-FDA: 84305461968.10.EF4EE73
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf26.hostedemail.com (Postfix) with ESMTP id 26B6114000E
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 14:53:42 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QXotIqNN;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767797623; a=rsa-sha256;
	cv=none;
	b=PB7pnWWuOqs5EZj1OqFXGWnFtRfr64YQMEEkLXMfwZtxk0L6sWJZkTsKeUi8j2ge3FtXzh
	uKsXaQaETo0Afy1evw9ef86kLPD81ITDyozEMnxeVXT2j/uw6Uhj01ALkR6oKsqt+e/L4S
	0pk0y5mMG3wH42uS/+kaXtaYqe9y37w=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=QXotIqNN;
	dmarc=pass (policy=none) header.from=infradead.org;
	spf=none (imf26.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767797623;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=N/MSGdm4Pn94QVvbBIPMYP8yHiQacuBfDGzmKsc3hKc=;
	b=0+LkbpnelxKvAD5Y7tICNj1ufeaBr87gJVQZrfIFq7HHggvKT8HggS7OTXMkfDubOsphUT
	N+W9IlbCfBilW7CLJ1f3vPtxoj0GiapdXSNPKu9tkip8VpT9/W3ORYxExLvBPFVWHNSbUN
	wZZno9bgePbLhhjufOjhiKCJcY9WH00=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=N/MSGdm4Pn94QVvbBIPMYP8yHiQacuBfDGzmKsc3hKc=; b=QXotIqNNT/HVDRTm2V+NGY3EYa
	51N5hZPgpuLxtJc/LHnPBxl/SAfQlnN9EiZqwW91lt6SG4oT0y1pbCIloNr9Y/hWsMw7STAAe4npK
	nC2LvHqAbtg6hDCrxDaTYAHkDZLK4GRO/50zGXLPnE+9BbsyXvCqCgEYZTPV3Lm/nmGyQWmgbyn/+
	wvCItMwzoyGbzR3iNGVMOH1bpZ5blzltQHraCRhCaixsvCCqKNYRseljywpUuM+wzffDsMFlc4sX3
	ZPovcnR+N2BzFJ8DaYtE3m6Kck9KyJGh+CK/S0YAP674BfGA919TGhR4KqA1DOo4vUXGW5s1fhG3i
	Wg8XVBtQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1vdUur-0000000DVzV-1s2j;
	Wed, 07 Jan 2026 14:53:41 +0000
Date: Wed, 7 Jan 2026 14:53:41 +0000
From: Matthew Wilcox <willy@infradead.org>
To: alexs@kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>,
	"open list:GENERIC INCLUDE/ASM HEADER FILES" <linux-arch@vger.kernel.org>,
	open list <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH] mm/pgtable: remove unddefined
 __HAVE_ARCH_P4D_ALLOC_ONE/__HAVE_ARCH_P4D_FREE
Message-ID: <aV5zdQ2pX9vKM1aj@casper.infradead.org>
References: <20260107063911.15299-1-alexs@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260107063911.15299-1-alexs@kernel.org>
X-Rspamd-Queue-Id: 26B6114000E
X-Rspamd-Server: rspam03
X-Stat-Signature: knoguaues87m1x1arcpjx7cjj8gqgurz
X-Rspam-User: 
X-HE-Tag: 1767797622-682229
X-HE-Meta: U2FsdGVkX19HN8q1h3WPrsobmtVB8tQkuSnRu0HeeLQFEAGE8Ls1+CQ+Q5pqACQ8Rzh2sgOn4yBWfqkVzr6CEXCeaZ0WleAfG7LaLCdq7djSkg4dhNvv+ZkPYPQBqWrYd8MHugB78dfSpN1kWShWRL9Rr1rG7GPI5KkguI02ZTbYzNdm6T8oi6L+6ag0vjWVgMPIOffDNSuiy7Bn8IN+lcyk+ZASfxApE7NhNOta09ndkje3x8Okq5cWe9jbrYMSalJnrpYhoRS4K5ZcX9F20XYV4IA+/hw9aXo9dNYfoQkEGvKLxfOTxNkGp5nglr4wnEn3LaksyzfpjFejvw97JQlDwTArRRy1A6nr4oicevZk7bQ9y4m5ybcxf5+kb7EVhD3p3Otf7YkGGbCQzx/aXyn7GriY0cNBy2ym1R8rH1btsc0ww9tvWDqTjTgajuSGAtGww+0si4FCmrYlz0SLX0jNn8hgQQcF63x4Lsk82WC3Lkkm4ynlEMM1cYwiELNLv38lQXPOspn+jc2XxUZ9XQ0qAb7Q6GD1iY9+6DucstLQbkBbTq+nYamtlp8D9fpMwg4sE63ucss48DpIfP0Q5N9vs2+HKDg4U6jjjP1VBlMnhOxCSVRrt6wfsGBNhp5NhTf/n9EyyZEB++e5u16ZQ5CMtPYWF+rt+ARcDlc2cTIq2cXa5bemGx/8FUljIl4mZF7f01KU3J0d+qPoVQ2O/y4Rd93qj+NBF/OHhJFl1o/hR0FtT3fH3KAytmfrK604ug/QbpzuXzlkE8DaioCTMqgOpLJKu7N/gFhPf+vmaYROuZS1LgvCVjqdUV26QJP9FwXVjoo/zJtxsej8mqZGWBV/EeQgxZpWbHpKa2nNIX+/PJGOjw/CuhS+al3f3lMq2MuuyW/EnNnRrHJ2dSY4lGUd96EJ1BAjrP1xwuR/eyiNT1FuU5LpxPzHkjKAN8KcdhsW5KB0KPTLW57OZSH
 WjOYFxBd
 8CUzYwyj+cn5xDb/KTU/Ch7iunEQsi1UcnLZEPB/ctnaP0/nwlYQueTZ7Ij82zkATg2Hox34VCEdOFkjjDoYKKS6aWXDjXjCuAJwamX1XjA1SSwhqkuxo66g+IG689SQ/y1lwXlKmDaanQ+0IIQJFoicMCpTkY5+Z8lNtHzBaaFgV5ue8cJKdwbFnignGWDqtZvxU/EFj4QEt7BomF9BO3k5Z7HEth26uHiEoKXHxLR9lKBpj4LIgVR0pvKB4YKIPEfhWG2gVc3wRrfcVDPElNcMgA+cmHC600drzAtUX4Ymxo3vjkMz5V6JRw97Yvan4ArU/W0uSuWPZv6OC/sloYm875Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 07, 2026 at 02:39:10PM +0800, alexs@kernel.org wrote:
> From: Alex Shi <alexs@kernel.org>
> 
> No any archs has ever define __HAVE_ARCH_P4D_ALLOC_ONE/__HAVE_ARCH_P4D_FREE
> So let's remove them.

No, let's not.

