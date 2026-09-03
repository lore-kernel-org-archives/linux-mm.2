Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B399C624D6
	for <linux-mm@archiver.kernel.org>; Thu,  3 Sep 2026 01:04:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C40E76B00A2; Wed,  2 Sep 2026 21:04:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C19206B00A3; Wed,  2 Sep 2026 21:04:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B56016B00A4; Wed,  2 Sep 2026 21:04:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 97C456B00A2
	for <linux-mm@kvack.org>; Wed,  2 Sep 2026 21:04:12 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 2F9E6803C4
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:04:12 +0000 (UTC)
X-FDA: 85170654744.08.D826243
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 776A98000A
	for <linux-mm@kvack.org>; Thu,  3 Sep 2026 01:04:10 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Lv6frWmI;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1788397450;
	b=g5KtS+urTFpoj7o9qrybtnlc74Ti9cyIyyYWxtaMPpuRpSKewIwvzpfVwYZi7fGIe/6J9H
	joxOR0j4fk5wQPuYHlKMyxBcmGeajguaEIUTKXU9O0lG81HzHg6g/rN/kTmVHr/VSfOyGv
	/EHt1/c7tIYyIwXyWKRMYPSqpzczLgs=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=Lv6frWmI;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788397450;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kNT7Z2FMxt/nfOQZlUflR3zMw2XOgkeNZiCD6ouunac=;
	b=NT4BEcPHGkgPb4wLI+mwkkeDvEJYXj5WBwVnQRyPmDyxb8MvmqG1MjBpUJk1VhOdG+18oK
	+6lTqkLaObhDtJ4+h33Eerr8fsCt/jbUnMGIw2Y2xOj1k04smVC3LsNP6MPmDt41BAQLiT
	T/ccrQ/I4sJYz5PQGKwSYn+BhV50aF8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 15FDD600C8;
	Thu,  3 Sep 2026 01:04:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61D661F000E9;
	Thu,  3 Sep 2026 01:04:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1788397449;
	bh=kNT7Z2FMxt/nfOQZlUflR3zMw2XOgkeNZiCD6ouunac=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=Lv6frWmIMBhsZT2PbPJmz9srQDtxWdSn9v59muHBsrLCyGSrOM4BF+Dwp/XHqJ9Hr
	 ZIhqg1lFK5NXXOOVJHWCGB3GvpzX42wDAjbROLuEi8b3RvB1druPR2CWA+ZgLTPwzl
	 XHf38yM4beeoq2eVsBsaiwhmWV0YcnfpmxdTt6Q4=
Date: Wed, 2 Sep 2026 18:04:08 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joshua Hahn <joshua.hahnjy@gmail.com>
Cc: Nhat Pham <nphamcs@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>,
 Yosry Ahmed <yosry@kernel.org>, Krush Chavan <krushchavan@outlook.com>,
 "Chengming Zhou" <chengming.zhou@linux.dev>, "Tejun Heo" <tj@kernel.org>,
 Michal =?ISO-8859-1?Q?Koutn=FD?= <mkoutny@suse.com>, "Shuah Khan"
 <shuah@kernel.org>, linux-mm@kvack.org, cgroups@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 kernel-team@meta.com
Subject: Re: [PATCH v2] selftests/cgroup: account for zswap shrinker
 writeback
Message-Id: <20260902180408.05b925ce05359cd4d7f96894@linux-foundation.org>
In-Reply-To: <20260902194521.3652178-1-joshua.hahnjy@gmail.com>
References: <20260902194521.3652178-1-joshua.hahnjy@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 776A98000A
X-Stat-Signature: dii3q8874bdpsnrcng4gkg8h7m1hu6ts
X-Rspam-User: 
X-HE-Tag: 1788397450-460503
X-HE-Meta: U2FsdGVkX1/twh5HHwpqG9ekw0afYsPrYbZAF2uTAkKa3WR5QCna6KFfAGX41vP1jJ+MSX8+jCYWjzy1bZs/CXfEhEMc4o9xdlQ5+Kc8rTHV7Ee4J2ACWv1YA7ZIP2oV2jjW6vbwGLV3lUbfj8FdxwL7IjucjmjQv7XK6ihRUATQ6FQnetouQ2oKXL+ftg20xJnRstjOU9e2egNfae++zA8eslcs1q26XjWbh4DoC53U67/hBrTTmQDuzJqNlzAKlTd4tnbZIpv+g+U68KDj2MiOn+nV/a+ZV1RynZ+RIgfrEdPrWgcJu5nTW4Gszgs5vLiRl1hnRvQxTF1rfPdYaiHZOFXvWtFOevsTxhTnRVpzr2TZywyHnrw7LGM9a8WOyFQ8RSLsEMEFcfJOzxqad3306TU36QHYAfeiCpvvHg/2WXlhYnjHPdLMf6meTtJx9WLl7TM8CbKQkgqCDmar7YLcEIl3uclQwutTfKVMDtOpFXEBIBGYARoppaKhuHxFkdYM4PjpDvDjuUecb0YvMqQZhGd9PaERsIPC9z5TIF285pL9MnyyKPlTf5c0Rr0OF2c84YcVOaWyUkyXdZsdhBBeOf/w8FruyJvVO4xIgSxeSH83tY6Ii5rPOhhzdlBf7FESh8lGwm9C2ibx9t0lyqx9vxembc92y7NctkxwwRB1xMU9Gf6U6yTvGpn5Skx1tluWza24sSpN3l76fRVh7YwSWiEzsPoGiN9KweAbi8AHd6XTKzoZRsQ7lXpzPVoQMiBrIZuthtNFZ+gZORoiat2JzrOIIRXJwbDwRRj7YakpHYDTyW4uTsv60qFTU52mosApP43uYHc7cIU9i9GBqeaHonXvaatlsAhdWlkvh9bt8Rw3Wezac750HwqmP6vJdYp9mBDEThJnlOozv0HGP3PPmYfdQigmxrSAwZjgB/0IyIqcXxaIdhO6pFiBrGifPKADPUrqmGcKB3xUHbk
 xlGKsSZT
 PDJRjSnrqd/36Xu2FWQausxQ1Lyn8qY+FiHu4gMACXDFFHNZ4hWlgoj9gyd/fp4RUjD9+3btLISVuKzT/dMxM+gNvzMNJaFRAE9hBd9qhD7i8oOKDCg09TgVWZYd6kDCE6OF3I6Ccclj9QjQcUt00DAuXUHwvIkqSpOmpmBGiFCiuYFt3BTvGYbzm9GiUNLaDuyYAjsyB7Y/t5MIN9XdSrUH2cTy0wx+J/MjehsflsdYdV4kp8X2cMZusqTMjwhzF3y3Pwg6XxoRD9CjNZ6q46QHUoxKi84lHEbVID60EWmCuXSqWWUk1g7V6sI7KuPVvoZWoBXHZ3m+96wk3+JZQigtPx7ZcrEXW6rz57w0CqADMwyUo0/3tz0O2Ng==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed,  2 Sep 2026 12:45:20 -0700 Joshua Hahn <joshua.hahnjy@gmail.com> wrote:

> The test_no_invasive_cgroup_shrink selftest checks that when a cgroup
> has zswapped out more memory than memory.zswap.max, it does not
> trigger writeback for other cgroups. To do this, it compares the
> writeback count in a control cgroup and makes sure that it is 0,
> and then checks the writeback count in an aggressor cgroup who does
> expect to see writeback.
> 
> However, when the zswap shrinker is enabled, the victim cgroup can see
> legitimate writebacks not triggered by the aggressor. In some Meta CI
> tests, we have seen this failure mode happen.
> 
> Instead of checking that the victim cgroup has 0 writeback, compare the
> writeback values before and after the aggressor runs and check that
> the victim cgroup did not perform any additional writeback. Note that
> this can still lead to probabilistic failures if writebacks take longer
> than 5 seconds, but this should fix the systematic failure case.
> 
> Fixes: b5ba474f3f51 ("zswap: shrink zswap pool based on memory pressure")

Thanks.

I do support backporting selftests fixes.  We want selftests to work
well in the kernel with which they are shipped.  But, as ever, we
should include a clear explanation of the userspace-visible runtime
effects of the bug.

Seems the short answer is "false-positive test failures" but we can
perhaps do a little better than that.  Quoting the failure messages
would be a good way - very recognizable.

> Reported-by: Krush Chavan <krushchavan@outlook.com>

Relatedly, is there a Link:/Closes:?

