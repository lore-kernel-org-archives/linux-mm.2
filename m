Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FA78C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 03:32:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8D7766B0088; Thu,  9 Jul 2026 23:32:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8612B6B008A; Thu,  9 Jul 2026 23:32:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 776DB6B008C; Thu,  9 Jul 2026 23:32:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 46F986B0088
	for <linux-mm@kvack.org>; Thu,  9 Jul 2026 23:32:25 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id BCBAE1693B0
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:32:24 +0000 (UTC)
X-FDA: 84971444208.12.696E7BA
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 2A77F40005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 03:32:23 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SQmEZ512;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783654343;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mQ6hMMNdMWZsQvQubRaY7o6TY5m2sf5lSbS/0dE799E=;
	b=Y0HXV48bzg7Ji6+7aSfI1sthmgG80i9bBBeHHsYQRPBDal7MD3YuJkkVQuQRMgM9+XisvO
	MbfHKYQYcgU3uu22hCVtCmEDo6ykoVJZcCRxZjoGN8E5nHMaaSrtn86QdqCHL9Pvoxihdr
	FNRh7VPyzMnYZYS054a6jioLQ3G2+s0=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=SQmEZ512;
	spf=pass (imf27.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783654343;
	b=4mvYFqqjYjaNAVc/Kw3VI9/SRFtZSZxq9RFKapVtO+tKDBfqsczBPE9d1JgkoNiIshEhqr
	DGU/uV+F/cHTlDYw3xJyB7rKRltfAWQji//wNGSmZkURUxgLnofECTwMh6iq1keDQpKO37
	ZY1oRns8UZcX//KxZqJ4sH/3bCMmjC4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8784E6001A;
	Fri, 10 Jul 2026 03:32:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6B521F000E9;
	Fri, 10 Jul 2026 03:32:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1783654342;
	bh=mQ6hMMNdMWZsQvQubRaY7o6TY5m2sf5lSbS/0dE799E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=SQmEZ512lakzjBI+To/Kg9qX2xfzBFENrhLV10TA7stQYPVYi1BqPJNKj+5ABvuXR
	 ZnSMhfQyh/4UZXdCFenl5JupgriV/BjmLPbYn0+mnDmpCEvLLE2DD+ui/FXzTUo3K/
	 g5C9Zg88TZo7/4Tpq9YjtpZ6WSiamd9TLjTYgGWY=
Date: Thu, 9 Jul 2026 20:32:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Anshuman Khandual <anshuman.khandual@arm.com>
Cc: linux-mm@kvack.org, andriy.shevchenko@linux.intel.com,
 usama.arif@linux.dev, hughd@google.com, willy@infradead.org,
 ryan.roberts@arm.com, "David Hildenbrand (Arm)" <david@kernel.org>,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH V3] mm: Standardize printing for pgtable entries
Message-Id: <20260709203221.573de46038f027c2ccad641e@linux-foundation.org>
In-Reply-To: <25857f58-9ef1-49e0-99f7-366d91028c02@arm.com>
References: <20260709044334.1741263-1-anshuman.khandual@arm.com>
	<20260709170816.4e876a16eef9a93f41bb1940@linux-foundation.org>
	<25857f58-9ef1-49e0-99f7-366d91028c02@arm.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 2A77F40005
X-Stat-Signature: 7e8414sqapbjrw8cd3n3djd1ssjud675
X-HE-Tag: 1783654343-554366
X-HE-Meta: U2FsdGVkX1+6wzcxRpf60i7JIjsnPvyHf3d0ZIvyJvKem3sH5kid7fHUb8lnLdeyyi414C9WfDkKfg++HX+De60qbHrILu0xRRbrXjAjvHIafWvRMwZjznR86I2hp0d7TFwHjgLvOwsnJ2ouDyah7qo38TcpyqO0swCSbLuFfNZLp76M90u8odlx9dUA6M6wXDSVIuZxPfDBD/S7ipWI0AWnwyKVR0FUJ6F2M6pIvBNRhMmXZOt2PoARngsDlqxx70fUxfUex/i75cvgmgm5y7iIQ1hLfB9rFFK9E7lPqHYcW/hHrBZIOxUZRm+oMReTl8o+NHAK4TwAALaG5/XFE8BYSLMv8vnZofrW+dLwXU4Ghp41jOA+DF2UvEsMkp9Fwq57Vg1VEcjJTjmLwKqHht/4ISomhH40JVAQZMKM0JsIfOgiZt6ZikkuT29y9zGbYcnsa1dgtb6xQB4qLouAfQ4/ldTxVXCVlOc5/75kfCBun2tNNoKALc0/AqhhwrtdEx+gx58gqgwwCTT8iqukTu6qPw+YTgqhglHEEMbqVvFPEHgyitutyKlh5h5pPyW4agxnDbHUu71DooyCqxTzshuNlowP0mzzjuZWPwdXM5tBtNVl6gOE6Sg5KmJp4g0iS7ewzMiWwEd3wEjfuOc9JcWSKUxLvRm7OYb8dP7wklF5CUYKbTmfLfxfkuIkk5i8uA72JvvRe+psC/FlmoQDUJMPi3yT46V5CtMbWPULZejgDpiCJn9N2WKy6MLlmkPlMMPO5ymsb90qRbO2ebJYaDFNHZy1+HVfkJ667ubSDNyYF0IwNsOropL82Ly548BK0wg/0FtnhIVBmZEPUPZ6bwsDoLM6W7uTWcp2T3TBfQJ5pFn1xpHVCkPpH/R6hz39yGX1sbnofNFM2vt6GTxBeHUlKRpQeNNemHZVD4XW4i56/5EQPWYfQAYhtHH3nH6nj7+Vu07iFvLPru5Vkta
 QuM3/RU3
 B9fQUTjyWlvSTr8gau/xNcRGyzxO8pKuMlnZVfa+mbOcnnEHjWVsJb0MuYIcD9iBJTN6qAEeJnz6tXD/jITpr9BCxa0xlwD9lSGbjFj9DFBCR50xxpOogyLAnNsA3n+JtCNLudJkNX4TFZoiP78fR9hmP1ASKBPtaWYVac1WY37jt78L/p6VZ72s2xaN6ZYgOZsQBMuLeIJnK5yHfSU78vauVESU9Tont9by4Q4nUQ8GBy6+7LUUOZrPDFdplJJ0lUOFa0qbkvK7PCB1LtHeZqKzXSzQ7q7/15AbvfcQHS4/oQBXztbUdltH+c46IBab9EZtrhe3lc5t3FPY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 08:40:25 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:

> 
> 
> On 10/07/26 5:38 AM, Andrew Morton wrote:
> > On Thu,  9 Jul 2026 10:13:34 +0530 Anshuman Khandual <anshuman.khandual@arm.com> wrote:
> > 
> >> From: "David Hildenbrand (Arm)" <david@kernel.org>
> >>
> >> Bad page map reporting currently stores page table entry values in an
> >> unsigned long long and prints them with fixed 64-bit-oriented format
> >> strings. This is inconsistent across call sites and does not work well for
> >> architectures where page table entry values are not naturally represented
> >> as 64-bit values, such as 32-bit or 128-bit entries.
> > 
> > Well grumble.  It's a lot of fuss for something which nobody is hurting
> > from.  Or are they?  What's the actual utility here?
> 
> Current page table entries print does not work here for
> 128 bits format (arm64 D128) because neither 'unsigned
> long long' can hold 128 bits nor printing extracts u64
> from the 128 bit entries while printing with "%llx".
> 
> Proposed a separate printk format %pp[te|md|ud|p4d|gd]
> 
> https://lore.kernel.org/all/20260610043545.3725735-1-anshuman.khandual@arm.com/  
>  
> But there after it was decided to rather have a local
> solution in mm/memory.c instead of adding a new print
> format.

OK, thanks.  Let's please spell such things out in the changelogging. 
Explaining how a change helps our users (ie, improves Linux) is super
important!

> >>  	if (!pgd_present(*pgdp) || pgd_leaf(*pgdp)) {
> >> -		pr_alert("pgd:%08llx\n", pgdv);
> >> +		pr_alert("pgd:%s\n", pgd_str);
> > 
> > can this do
> > 		pr_alert("pgd:%s\n", ptval_to_str(pgd_str, pgd_val(*pgdp)));
> > 
> > and eliminate a few locals?
> 
> But that would not eliminate any local variable.
> 
> The helper ptval_to_str() does not return but instead
> fills up the provided buffer which later gets printed.

Well yes.  Changing it to return `buf' was kinda implicit!

