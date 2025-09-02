Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC547CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 21:48:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1E70E8E000E; Tue,  2 Sep 2025 17:48:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1BF3D8E0001; Tue,  2 Sep 2025 17:48:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0D51C8E000E; Tue,  2 Sep 2025 17:48:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id F02718E0001
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:48:39 -0400 (EDT)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C77358E04
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:48:39 +0000 (UTC)
X-FDA: 83845649958.24.D2B8F01
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf03.hostedemail.com (Postfix) with ESMTP id F1AD220005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 21:48:37 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=qtswnzyL;
	spf=pass (imf03.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756849718;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=7J0atfMnGda7vBRBugMSL/i969TN7DxIMDMOT/ScxLk=;
	b=wYBELDRkd9WI9tf6zzeo2/HtMdvSyFfuhOvRAf2pU6QfalYjF3wGt2z8Z7ork6/ptWXVXH
	6SuolN+ykHi2o0rKcRfzIgLfZGcp6WH/mO6rjCEAyyW2rETRatvzr/6+7iwgSSpF30Hwb0
	7heY7lI+UOeGQ4vscTDWOHqgr0cPryE=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=qtswnzyL;
	spf=pass (imf03.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756849718; a=rsa-sha256;
	cv=none;
	b=S8lWvOUno70GO1r5HM6nvS4oY4YnmViM0LwI1VAWzlcD5e72xpTYCrIxf/gW0Y3ipHFQ28
	cfh2M8qv1De39vrLc6pOhGG6PHBFws+CPKo1L70F3Fg5sl9VPA6gXAwbBTomYil5/clcPb
	2o6AGvv06SpSznNSW23zH6+AtxYntpo=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1756849272;
	bh=wS50MOhHWsnMiqonPW7eIOg6r3BfOfNZgJl6TjCqs5Q=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=qtswnzyLDTa4gDkPdnZ2SlsbCITviKO02+Ope2Po0zVZEP2SNdsf6LULlMADetO9M
	 iSSIlodlZZT4FUxpv2WsgO/l1IxSS+U5aldV32yyepCgAkQykh0U0IeZhu4y3v/Nvd
	 Dv2RiCr7nWASh1D7XaJ5rZHml1HTUnoeJ44MgJmc=
Received: by gentwo.org (Postfix, from userid 1003)
	id 3FDAA40398; Tue,  2 Sep 2025 14:41:12 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 3D8EF401EF;
	Tue,  2 Sep 2025 14:41:12 -0700 (PDT)
Date: Tue, 2 Sep 2025 14:41:12 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Vlad Dumitrescu <vdumitrescu@nvidia.com>
cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
    Baoquan He <bhe@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix race on alloc failed warning limit
In-Reply-To: <84bbc996-27c7-4f83-a8c2-4f88b439bd23@nvidia.com>
Message-ID: <070d9527-0852-e71b-78db-bd9768ba7525@gentwo.org>
References: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com> <061405e5-8670-2873-9b6f-0f152863adfc@gentwo.org> <84bbc996-27c7-4f83-a8c2-4f88b439bd23@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F1AD220005
X-Stat-Signature: qe3tx5ap38k37sahwtsohkipz85tsthx
X-Rspam-User: 
X-HE-Tag: 1756849717-632956
X-HE-Meta: U2FsdGVkX1/dwuwqbo6GFDkANYjucVJWlswHPQPwDZxfoTQSLmc2qlWQBL/e4P63XsbA8ewMEfGDbSnQWodhT3y4iYn8mSYKWeUTdJAOsUsmG71aTUCS/mn3BqcQYSP+MYPcPfeNsL1OXemnRSfpr1mjB4EQHlP8ERQVhmZfo/wxKWk+Ixr0k+LGNTFolbB8r36+0fsYMhEah0VKs8BydEmTdD3FpRQ/WMcbKKBXD5Rcfa4Ywv926bInlDrOE7x6a2unryOJuVslzarTWKPwNRXuojGwSRdYXq/Io6dvQwPwXYCQKqnNz8DAuO7Sl8NUgMO5qmsHiZckoSQEpEiMqbP/k/B/+lWA/ks5w4Vr43UBLXPfUWkXruiPUY9Jz1hbyCWijCRvuJnLdDiwY64F1pByZRh5HyJdKaxz0ch5Y53gnyEY1VOgbV6OBOUXMyzyAYKVo/edrwEIY/cXH1a/WpF3EiHaev8rK23hwuzaJ2s6uUqDp8D/D0w6757fBoaQiksFcMRbPMpVwuhCBM1VxwStNnsOojw1iL7+2HZiWkXFtWym4EaQGGiOtvSKRocJno4Y2UNWyrt/GZM4hWxKWGnrFmLbQeYa2/GUD0UHQZ5vC0l5NA81wbADemuXrnPdKCMJRb1TEo1oBMJ9LdgKKJeH0xqIDiKEERScnjhoqTJuCdtszq/aS+kHGBCojgXCkbgaO7MNVeGF1IfkBHfTFMEiGR1SMFVNeWHYevAPr5MWhthfz3/qqgfx68PQYxjDDwxALcL8uL8h1gPjrNLhIUNbT9f9X7xyjKJzHAB52uxOfib+TevgNfEdrdwsMx5lngCshl9eT/UaSpgaV1w9w0YlXrxcWKVXgms+Hze2r+dgQZjf7ub6eHBflU9oY74F4X+TKYHwS8CgdS5ei5LOeEU3o5grQhqK5TwIOxGBWJNXzlPzTZfPefTjhvBP7UzndsoMGGJn1WjT21EvAmv
 1H3WePJv
 JS1zTfRrz10LXSGP4noCSsF8qsKEo5ktttIT70vEtQwbrNNACwcoohe38pWl95dqMMQU/mCBW1EpdWPrPCtlPN7ZEmXhuk9BGGJbxuBxy9rjnF5PbnoyXeG9okbVKKxP6pavj1MBRN5pyIGCSAeK66SipMcI87P6JAdRXLy4fgnXvFZcHUzDFBzZwMAqciUy3x1Fat6OMlBTHOyY+vMnlPVzoMcFVttOsX8TFjgFlgdHR9ULUyslLfngK1Q==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 2 Sep 2025, Vlad Dumitrescu wrote:

> On 9/2/25 10:39, Christoph Lameter (Ampere) wrote:
> > On Fri, 22 Aug 2025, Vlad Dumitrescu wrote:
> >
> >> +	if (do_warn && atomic_read(&warn_limit) > 0) {
> >> +		int remaining = atomic_dec_return(&warn_limit);
> >
> >
> > The code creates a race condition since another atomic_dec_return() can
> > happen on another cpu between these two lines. warn_limit can go negative.
>
> Yes, which is why I mentioned it in the description. But compared to before,
> it should be benign.
>
> > Use a single atomic operation instead?
>
> Did you have something like this in mind?
>
> -	if (do_warn && atomic_read(&warn_limit) > 0) {
> -		int remaining = atomic_dec_return(&warn_limit);
> +	if (do_warn) {
> +		int remaining = atomic_dec_if_positive(&warn_limit);

Something like it... Maybe

if (do_warn && (atomic_dec_if_positive(&warn_limit)) ) {
  pr_warn  ...
}


