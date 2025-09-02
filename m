Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 702D3CA1007
	for <linux-mm@archiver.kernel.org>; Tue,  2 Sep 2025 17:39:58 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB72C8E000A; Tue,  2 Sep 2025 13:39:57 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A8F328E0003; Tue,  2 Sep 2025 13:39:57 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9A5018E000A; Tue,  2 Sep 2025 13:39:57 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 85C448E0003
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 13:39:57 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 32CBD140300
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:39:57 +0000 (UTC)
X-FDA: 83845023234.06.1526345
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf26.hostedemail.com (Postfix) with ESMTP id 83A4A140005
	for <linux-mm@kvack.org>; Tue,  2 Sep 2025 17:39:55 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=b4+xqIHW;
	spf=pass (imf26.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756834795;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=D2UT3Dy1NLSIZizArCStYJK14ElIrCtLqJjAetOgmXs=;
	b=B+GXM4r/rp5FaPfo6sRAniOnJyubfu1vDj5v52zT1Yzc/eISaEl3U4JM8YnBgNkikpp8pf
	sw03nBo3KpxQ5c68xIvPoKPJgPg1hzCBAFHgEz14tz4FhrcHwPfqLILW449B31+xc3jdee
	KmiZNY4ESSkRVGmxe5t86UvDp3uQj8g=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=b4+xqIHW;
	spf=pass (imf26.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756834795; a=rsa-sha256;
	cv=none;
	b=XKN30V4PyqoogqU1mXTCW02P4LyHmm/FyuNmIOodKa2gGohmeiOQBoDx67PnKQnz+8XECK
	ZGuyxwFEz7XaI+3DjhxLu6soDYe41277OvLOQl2nPE9Uk24PGuUSwkJHmR3pvap3kC4gp0
	frF+2YWutlMFVFt9RPQkrLBDzoGgJIY=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1756834794;
	bh=tdm8cJuBjFeRqOfTlDgRh0c55lXPWPzhbvCHUdH/3gU=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=b4+xqIHWQXgQEEQBHtoDlOk+MJl0kThgV0LG4fMjlgSCiwBB4kAcz4fy8/u/5Uyrg
	 ACoZqE9SjObqBm1fvZyVTPWkvyHanIIh3/0H7wXQe1xiiIkYBkhLqwSEyWCn3+M57J
	 GxyzNXcVo8Y7Km9vOZkQeJW4FCPa4XGCamITFgeA=
Received: by gentwo.org (Postfix, from userid 1003)
	id 3A9C040398; Tue,  2 Sep 2025 10:39:54 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 398BD4038E;
	Tue,  2 Sep 2025 10:39:54 -0700 (PDT)
Date: Tue, 2 Sep 2025 10:39:54 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: Vlad Dumitrescu <vdumitrescu@nvidia.com>
cc: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
    Baoquan He <bhe@redhat.com>, Andrew Morton <akpm@linux-foundation.org>, 
    linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] percpu: fix race on alloc failed warning limit
In-Reply-To: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com>
Message-ID: <061405e5-8670-2873-9b6f-0f152863adfc@gentwo.org>
References: <ab22061a-a62f-4429-945b-744e5cc4ba35@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspamd-Queue-Id: 83A4A140005
X-Rspam-User: 
X-Stat-Signature: sgxtd6hwa1r1huic1u85q18ci1dyauu4
X-Rspamd-Server: rspam09
X-HE-Tag: 1756834795-442271
X-HE-Meta: U2FsdGVkX19SVYEpaVQOL2UVF9J18Frl7u0UpWUx7P5HekwCDjWo+j70aGSyNoCq98N9mOz0YSz2C24W/PiVKfPktIAQ39eD0YLA4r4Y2FWL33Gz2H4q0DVY6yOlAVZL6APpbSwZczn20ZzY57vF1WxRAIvhnOGxJC64hlA5HU7xxJUfLslUMpF468HGFofcXKSfE3Is3eO2uOPiNmLwM+Z9dsBL41J0fvf7ERxBbzqAHOwMCkw7NekEKIEQH+wI+LkbceLrGVPEgaoaGThzGPmiF4MR60Y0U7e7omzyF8L/p5NPoJUygN96b5N4xg/Ui6SqtfEoMXuzVQSrhqOsoyyHe7xucJnN6Hy6Z9SrRF5BkZ9J62BgUGjDUux5WGGacVdmbGZO0zUpkGQTt78WwXDxIJlL/BqaI9NIShSFhHOiyEvf5jgokpROxzI5+yJmQqfZ/FfehW2y5wa4PhRDPxxE6BdnEuNf2robfPz27oZAgYSKj9Nyyxccniza1hbN3yFJTUcu9pqQgB/w06H0/K1g9NZAIiSHpNgZTEpAAmAbgSJfvIOpUTrwq87h2bk+puqfTI4rRNt/wF5De/uKJfwFx6O9kcV8SHGqXcLCymf3dEURhjkkgaUecvEswXkX548vS8+gaB9ov4AnKqse+YWIOGtjgX9RyACSMKHdjN3/eA4JdRcNcTtfr1c7recnuFTRHIn7dSuDmFD/VLb7xtl0ph0EAdWLU7n+bp6RBlczFV/igTredSd8aUBVXJk4VoBx/VeLQdjAQ4HJcbkiL4pClqqrQxRqDPVBiHcPaYGKGQQ6gF9XXHjU06ZNDiAvl32XQpT9uzGQGLy8Mn65RSaz224elPEdT3jZdropvjXIR8cTiNrWTbPfMnl8CsNHZP5YSu9DxL6EPiRTd7eWY3u3JEnvM8gZMFCIQBIMBWLblpzMxExChX2hCrgjCW/PvzbyDv1XfhCHNR21X8F
 BtdCc0br
 J8cYWi3hv0tT5ydLBeyFMWQ9uGk6PVCek9wmdh/Z4oUmd4em2okgWd2Dku8+pe0lEa1UCO7ZnDkj1hNWJlsHKvICLoHHAIfPHfmY4spSkNk3pQSrlz3stByOQifJ0Tr3ILolAAxzWDr+jmIiTiJjdR6Jv/rAy2dN60S/n8yxtap7vdUaDdgUg7TU9sHoeflr9ck52m4XvJoZ2A7ytBFrF86XqyXVKo4GJKzA9KfTe3y2ji+LYFrIurn+mGA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 22 Aug 2025, Vlad Dumitrescu wrote:

> +	if (do_warn && atomic_read(&warn_limit) > 0) {
> +		int remaining = atomic_dec_return(&warn_limit);


The code creates a race condition since another atomic_dec_return() can
happen on another cpu between these two lines. warn_limit can go negative.

Use a single atomic operation instead?


