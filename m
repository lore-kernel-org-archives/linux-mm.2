Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3BF7DCAC592
	for <linux-mm@archiver.kernel.org>; Tue, 16 Sep 2025 03:52:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 98F088E0005; Mon, 15 Sep 2025 23:52:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 93C278E0003; Mon, 15 Sep 2025 23:52:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 851828E0005; Mon, 15 Sep 2025 23:52:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 6B73F8E0003
	for <linux-mm@kvack.org>; Mon, 15 Sep 2025 23:52:28 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 1BE051A07D8
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:52:28 +0000 (UTC)
X-FDA: 83893741176.18.F869238
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf26.hostedemail.com (Postfix) with ESMTP id 67B54140002
	for <linux-mm@kvack.org>; Tue, 16 Sep 2025 03:52:26 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OsQN2Jzt;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757994746;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=TQUMt/ieU0Tbp1m5VKz3kdeCSSzpRQ/Rq9O0zG8lLug=;
	b=VYDmYjU8lZ9bS/wnjuBCj0vV2TbQ9ri66XCMfBIQJ8ForJRMDUOfP3iGSMT16/zVf1I4Pl
	9g8CjVUY8qPb1bt4BZ5KF+ELUx9hJ1F9CwTCVy7UGBUZHRVfmD9GB7PN807mhrNZeQBdTs
	tsfOHDep7okc2a7jxTfZ6SIcidJkUd4=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757994746; a=rsa-sha256;
	cv=none;
	b=sgsfGOyaU1468kaCvT8oalj6Voqhz+iIrGqBstBl3eFH6Y6obxBammHmBPqf3PT0UG35tN
	cu9Sd4GlM4TJDFKWtgRnRafIumgaV2uUV30KPh4656uQgAcNs9YvQeyr3Dc3LKBftgjGFA
	dMws9Xb358booMxa8kC2rlHvQ8wEi54=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=OsQN2Jzt;
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 5500740C39;
	Tue, 16 Sep 2025 03:52:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0802AC4CEEB;
	Tue, 16 Sep 2025 03:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1757994745;
	bh=U6JxDMkVHB3XlX/9cQ/I2sPNKBRRoZiFmbtNoTrXKa4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=OsQN2JztTjwkSYM58ujeukp87a4ECEkelesp8ge0DINPmvZSy5h/p1xe4h9mURfSv
	 FQiqDNxLHR4XatBx12+aIJ0QPxbZlpILve6PDnMXpemSMLwq91AIpoPya0owAU45WA
	 b9ZaFNFNdB7wMxMhO0pbZYH7WY269Sbd9PMrOpEA=
Date: Mon, 15 Sep 2025 20:52:24 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: SeongJae Park <sj@kernel.org>
Cc: Joshua Hahn <joshua.hahnjy@gmail.com>, damon@lists.linux.dev,
 kernel-team@meta.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 1/6] mm/damon/core: reset age if nr_accesses changes
 between non-zero and zero
Message-Id: <20250915205224.aa2de8de6dad1bb4c048cec8@linux-foundation.org>
In-Reply-To: <20250915182652.110173-1-sj@kernel.org>
References: <20250915145158.1425390-1-joshua.hahnjy@gmail.com>
	<20250915182652.110173-1-sj@kernel.org>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 67B54140002
X-Stat-Signature: j75hnzhkg9o443kgwwad35m7hyxd5tjn
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757994746-551468
X-HE-Meta: U2FsdGVkX1+f/KgOOJVLBCQP/4wTo0t8EBVhnKcPWl2IlnHlVGEsHa2UcaBSW9SELJTtzRAsfEntRG0e8GPrI/3nCGCt9YlieIPO9NA5v2hcIYilloTX04z6bwbP+2Hf923EXnvdUbokDp4mv+VUMGdvAQe/fcvwNlbpXV0gZdzDOjntAJ/O7xh0JmVhv1rTY8SE+xxVjSZ2nDGBQLH7WzSocZdAjdsqSe1gCkmuIzDfO8j7P76FRuUA14nM+MB2h+4PV4UWF91fgNOxQZ5YnkIrEAtoSzvlsjMMYsJU41KxZ1tequbRxYdEWK6ywfzd2LSLrdE1vtvOFwK9r9XQINX7KrkoQ6tNqZCoSL9K512yHs+qx+/yUlo/yWltkJrNcOP4+YGVDOn+R4QfbogypRCFpCY8yg/ZvDdoqShjkJdv77ihZeMBz1Kbm93qjkB8KhVX9JZpUPLHm3IxLuh+bvaFwcFIjp4e4TiiRqDxUr4CEeKXgmApPbBGRqhAvjqVlMvihXz2ohvcyrn5fp0nErDxeB8n7aaYQVpg/dedliBDwO6HTRUc+Lh3AFAzlHkGL514pk1cQuQ43EotfYFO/2yL5LzOBvuv1wXCKX/ZN8uyZ4z7CauRmevC0XWwhLFWe/BBXC9w1tamulK2KjmZwr0IFS8YvRvkcTROd101Jmoshl0OH7xGHSpFMhkFO6eX5i85Q4PhlqpwA7VWAF1UG4/oFNrPO5fUzXo1RJ3lhqLvPtU5wMGo1yaXYFYf8l6gTy/K3419tlzDm/u+rII+NX18SdgqgRxcaqxRAWg1aoPo1GNENH9S4fqzi0cbeIe72HGLopvINdrU643luGk4z+pS8hm6KxLAf+ra4zC66OWUsoSnnvzhPaJshhIQdABjRIIjSKFQMjHYKd0FA2LrFfFcBEEparjVmJXTD9cKuMOP+quWStItrWWo1BTidsBxlL5vIhYbIgxXDKe3VdQ
 j3H5I+Jw
 6s0/hDMsBOAkeiOTSL7eaD+NYzdl6whSwmlrEIUUuQJR+oVyI9AiBMwrFGJBPoXKNY/AEopLfJS310ILHCMRznc8GzuE/HIl0IuNO9wJfOFY1mLLVOC+xL9JQzFJbJNtMxbo9KHQOgN4xegto9CZsnz6IRM2OrPxtzG4ELvjlTg6JBSl61inB4jW+nML9ndccIKpTlpycMHjKX/1y6u2BAIMgecVIVfYZXVa/YdqFdoPbXBT4YGp87HfJgUMz2kyEmt5+QpOeCm7S1sOWyKH78SeJeVdiN38S+LvyGJG+dA52B+HV9E1xsn1zIjbblaH7RwTOe3VP+NgK4Eqlz9f8stPMe/OPzybjzAR4e5lXpf/ADd6p9XGaIURyMqbEWTsSlrZdT58s3s4oz9s=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 15 Sep 2025 11:26:51 -0700 SeongJae Park <sj@kernel.org> wrote:

> > Thank you for the patch, I think the goal of the patch makes sesne to me.
> > I have a small nit / idea which I think makes the code a bit clearer, at least
> > for me. It seems that we basically want to XOR the two values's zero-ness, so
> > maybe something like 
> > 
> > (!!r->nr_accesses) ^ (!!r->last_nr_access) or
> > (r->nr_accesses == 0) ^ (r->last_nr_access == 0)
> > 
> > Can achieve the goal?
> 
> Thank you for the idea, this makes sense!
> 
> > I know bitwise operations are sometimes harder to
> > understand, so I am just throwing the idea out there : -) 
> 
> To be honest I'm one of people who are not familiar with XOR.  I had to spend a
> minute to understand the above.  Maybe we can replace '^' with '!=', and it is
> easier to read for me.  If you don't mind, I will use below in the next
> version:
> 
>    else if ((r->nr_accesses == 0) != (r->last_nr_accesses == 0))
> 
> Please let me know if I'm missing something or you have other opinions.

I have to say, using xor as a shorthand for what-was-really-intended
always bursts my brain.  I have to stop, think about it and mentally
turn the implementation back into what-was-really-intended.  Maybe
that's just me.

Ditto less-than-utterly-trivial :?  expressions.  Perhaps it's because
if-then-else best suits how our minds work.


