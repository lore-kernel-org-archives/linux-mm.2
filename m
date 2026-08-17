Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 209BCC5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 13:57:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 284056B0810; Mon, 17 Aug 2026 09:57:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 235106B0812; Mon, 17 Aug 2026 09:57:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 123CF6B0813; Mon, 17 Aug 2026 09:57:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E4EE86B0810
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 09:57:48 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 750AC1C1928
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:57:48 +0000 (UTC)
X-FDA: 85110914616.10.73CCC10
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id CD39D40006
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 13:57:46 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0P36rRi;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786975066;
	b=c1VlRXfljGutZaLdChJIN38EdqwxtklXuqKu5a6eqP7lKSi9pSJhVm2HmqP1BYzONrWHob
	MC17IXC3ppFMDCxI7yqswgFE9Kn0uE04GmE+CEzyTldR+u2GRaR5S/wXPCkbZ+icTrpzcO
	4OZK8QjG7NZLCGQ9lNrDCJRCJjB38ko=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=A0P36rRi;
	spf=pass (imf07.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786975066;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ES9BarLU03IYodauY97E/GeGK8xroS0Axugnu0hpN0w=;
	b=sBcZb4vSlfo4OgfLGpefBDFfhulSJhGg1UqMDfIb0xrcjD3YQe8Yad54Ysr7ioZyQCIQZn
	/uW5th0xw5o0y26z4AJ+Ujf2Q6xLS8HAbS+b9h8BxxpQPJpqv4AuNlDyTaFTihgrNtWcOP
	m7x+yZX1unzNjkfOI0nOrjh/V7jfdpE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 147F7424AC;
	Mon, 17 Aug 2026 13:57:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CD61F00A3A;
	Mon, 17 Aug 2026 13:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786975066;
	bh=ES9BarLU03IYodauY97E/GeGK8xroS0Axugnu0hpN0w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A0P36rRiTo17s7bFS6DJ/dxmdeATDcB3rLU/n4ea6QiaEWa1r6C+mr+b1n/Fi3Myw
	 ++FAiSBK8NIlsMHRx+S0P5/97vyjHiVobruJlMwwop2sSBupPSg6/8653P8gWlB5S+
	 idyM/X2cxOkHZh62TtRivFWtg1EKuokd0IElyoxJi6Eh8JwGWvbMVfqUa3Jg5IZwZr
	 SzDTmVKSEY5kTjMmmrUS7AvoSqBu2oOYACLjZaABcerACHxzxhNHwLoSnAibAC3I9B
	 WfmFyHtEkwyWBaRRnAP9+sKPyCn3ucm1IMYsYczVa/oMMp69QfU/DbDm49hJ3hhmb1
	 z4wIBz6lhNbMQ==
From: SJ Park <sj@kernel.org>
To: Liew Rui Yan <aethernet65535@gmail.com>
Cc: SJ Park <sj@kernel.org>,
	damon@lists.linux.dev,
	gutierrez.asier@huawei-partners.com,
	linux-mm@kvack.org
Subject: Re: [RFC/Discussion] mm/damon: Helping with alternative for watermarks
Date: Mon, 17 Aug 2026 06:57:42 -0700
Message-ID: <20260817135742.75706-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260817083923.4374-1-aethernet65535@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: CD39D40006
X-Stat-Signature: ygwshhyq8xozam6j3dsdg9bc47p5d3ef
X-HE-Tag: 1786975066-477499
X-HE-Meta: U2FsdGVkX1/Oi8PZ5HiJ7prprKaWMH/UUeFEoF2MKcPoakBdSkUTfQuT/JdAxqcCzIe6DNieTYESknaXh4odJts+Q1USWOL92GA2dLb5FlmlkymfVrYabJYDeN8C0Q+BesrcgmLig88nUJZxRxlr3p/b0bAcyC87ENLukl3ecVcshqKZlqW9VKQ8KOVdmT/dCyOYwpQD8mV2xUjhIDv50v9pPmeGPXp9u5ZRVU1/j/sdQouvDWyFUO7zD58k9yIPtobPVXu5F301PgYvRzF96DTZC7xh3647lToaLav5vGaG8Jz9XiLdyh43whSaKY1RbQH/Adz2Z2gUpw+XrugVJn97Nrp7w/oXXK+JliXTExaveZcJ/f6Ln+RLlnXc5pEtRLEUrzbvetUPEex3enAwst/lKWebLFGLjaEn1L0MnthK0rMOYnfvGkX+aRjbYGo1CuZ3c/gMM2hKQUKPnj4g6Kh3isR4LP1xYinPeamTelpc2c3E7h3qA0RhPV5GL3jpHfcRttw6vWAIGG2Gr3Bfep+WClR/7SC83UxwSOHGSwo7qtt5Bt8ppSDwf9NAvHBTqRSApt1nSQhZ4FsG/bLQhALS2doOpUORd1kHeqCcOnx0hgDwapv1x+T50saFUo9G2LOBICiKaNX0OQYH/q+b9AntVj5WXqB0A8y8P29K5OK8+R9BcHkwzKNcjgM7m0JtlTpHIHDJdjp0C17McLet6RmlI4wgrGKHmwXCriV/WpTA4XwQUHiWIUY0Rhs0fUBtLzmrJGL4Bpd4fGH3vTfCeposMV7KyRG4AzsUnFrlI+fj0fLwqysCrJsC6nIjla69+UkYusZwBOjzeeoL0scWvrmA/8LhLZixf/m7V611ZOlVVCaggN2NF+IbDuGvsTRgBie3tYegx/iktI0uRJmu3RqycW+92wkZKM6zCUzzVFvhKQBwOcWb8K1/IIJzpgPpQYa8lDXCUlU+oydbDGX
 54cQDwE5
 QPmGihSJMgLlvHEqJvMWup29hQqNODAdNz/EKrB+PDRz6oNG4ZpENBZHFpYwEcmpO1CPOMS2Rv7yuqdIEqVnT9GLfOczsAqV9Ny27V7W+ZTHt+0RM74gtlTqB+aRtuIfavArc8ijdL9xbntZr4RXMBdgLhXmUloeLpnZW/yp6Idoigg46k1y95uFSp95hsIkEc8pVZ6EQhzHCy5RxuymTSLQuuPM9X1eJC3CZ/taA0dvVTYHwxGKP+F5GxTbDr7PiT+60
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 17 Aug 2026 16:39:23 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:

> On Fri, 14 Aug 2026 07:54:13 -0700 SJ Park <sj@kernel.org> wrote:
> 
> > I think watermarks is bettert to be deprecated due to following reasons.  First
> > of all, it stops monitoring.  It means the converged region age and addresses
> > information is lost.  This is the biggest problem.  Secondly, we already have
> > similar and better features including DAMOS quotas.  For your DAMON_RECLAIM use
> > case, I'd suggest using it without watermarks but quota_mem_pressure_us.
> 
> While quota_mem_pressure_us may not be suitable for my use case, I
> realize that DAMOS Quota does meet my needs - only proactively reclaims
> memory when 'MemAvaialble <= 30%'.  I used it on my machine by
> implementing DAMOS_QUOTA_AVAILABLE_MEM_BP, which can also be achieved
> through the user_input of DAMOS Quota.
> 
> I think DAMOS Quota is indeed similar to and better than Watermarks.
> The main drawback of DAMOS Quota at present is probably the lack of
> wmarks.low like Watermarks, but this can be solved by adding a parameter,
> which might be called fallback_value or some other better name.
> 
> Therefore, I agree that we should improve DAMOS Quota instead of
> Watermarks, as it is indeed much better than Watermarks.
> 
> > 
> > Hence I want to deprecate watermarks rather than improving it.  If we need a
> > better watermarks, I think we should improve/extend alternatives like DAMOS
> > quotas, or implement a new one.  But, we should first understand why we need a
> > better watermarks.  You mentioned you want to use DAMOS watermarks with
> > DAMON_RECLAIM on your laptop.  Could you further share why you want to use
> > watermarks, and what was the problem?  You mentioned it was problematic due to
> > page cache, and you implemented memAvailable based watermarks.  Why you use
> > wateramrks?  How exactly the page cache usage becomes a problem for you?  Has
> > the memAvaialble based one solved your problem? 
> 
> 1. Why use Watermarks? And what was the problem?
> 
> I now understand why we do not need better Watermarks, so my answer is
> based on my previous thought.
> 
> I used Watermarks primarily because it is the only mechanism I know for
> stopping/running a Scheme.  The problem is it can only monitor MemFree.

Thank you for clarifying.  I'd like to go one step further.  What is the
initial problem?  Why you need the automatic proactive reclamation?  Do you
have some data showing the problem?

> 
> 2. How exactly the page cache becomes a problem for you?
> 
> After prolonged computer use, the page cache can become full.
> DAMON_RECLAIM might then mistakenly assume there is slight memory
> pressure and reclaim those cached pages.  Unnecessary page cache
> reclamation can incur unnecessary overhead.

Thank you for sharing this.  I can theoretically understand the issue.  Maybe
you are concerned if page cache is too aggressively reclaimed and therefore if
file io becomes slow.  But I'm not really sure if it is only theoretical or
real.  Since the proactive reclamation reclaims coldest page first, and because
it works for not only page cache, the performance impact might not that big in
real.  Do you have some data showing the problem?

> 
> 3. Has the MemAvailable based one solved your problem?
> 
> Yes, using MemAvailable as a watermarks/DAMOS Quota metric can avoid a
> lot of unnecessary memory reclamation.

Great to hear that.  I'm curious if you have some data showing the improvement.


Thanks,
SJ

[...]

