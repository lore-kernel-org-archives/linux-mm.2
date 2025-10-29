Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D399CCF9EB
	for <linux-mm@archiver.kernel.org>; Wed, 29 Oct 2025 22:38:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 38C7D8E0110; Wed, 29 Oct 2025 18:35:58 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 364528E0106; Wed, 29 Oct 2025 18:35:58 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2A0F88E0110; Wed, 29 Oct 2025 18:35:58 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1D3E88E0106
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 18:35:58 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A0BF5B9FE6
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:35:57 +0000 (UTC)
X-FDA: 84052610754.12.9EDB5F1
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf11.hostedemail.com (Postfix) with ESMTP id F3EAE40016
	for <linux-mm@kvack.org>; Wed, 29 Oct 2025 22:35:55 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bgVgzpoy;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761777356;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ZvXMB30alJl3ii98PlrhgmTtFXGKeoilwR2jrvIbwRY=;
	b=dFdCpFvHV9jms7QnFa5y5GgtlUQ0cBm/2e+pWaUVYAifEgDE2bsQ2EGd7uMJ5mYDfZKGys
	7YGPE0Z546SbPdZzGG+Xz/McA+iabigqOaaH4SnmhXWFOQ+vh7AEbBQSO0iv3wa3LcasJa
	6fErzeAP7mo52e7ji4jzrRLtl26+DKc=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=bgVgzpoy;
	spf=pass (imf11.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761777356; a=rsa-sha256;
	cv=none;
	b=JcZARZIcX8g6Wg8KWK/RTJlPcLhEv8pGlnLczoQDuWJXNQcBS2iCTLelEyDgfgg0xPqAQY
	K3aUFkbf7LVkhZVa6o4ymY5GOSnhoAr1stkZGQ2MDbtpMazMEc68RpsUokzrBUZWEb95fB
	yo5KNO3S63OZbTFVV5ZQopImmVR6dZA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 16245602C2;
	Wed, 29 Oct 2025 22:35:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359ADC4CEF7;
	Wed, 29 Oct 2025 22:35:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761777354;
	bh=Y9blq5orJXjynoubp7D5BUJg9g8QxM+N+9L0FMEHyD0=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=bgVgzpoyTWjuDmESCgVQqQBtXrg66SeiPzv7ZZajw3t2cQwp3ybru35JJZIgqwsa2
	 Rwbx3Kw75StJarelI/EnDJJ7of6QbmSkHAWpw2iaUscWJrUy74dlmlyCxYSOKYt3uk
	 gpyCMqyBpWthfpK4WNEPbbhRuQnif3j9Kan+QDO8=
Date: Wed, 29 Oct 2025 15:35:53 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Pasha Tatashin <pasha.tatashin@soleen.com>
Cc: Mike Rapoport <rppt@kernel.org>, brauner@kernel.org, corbet@lwn.net,
 graf@amazon.com, jgg@ziepe.ca, linux-kernel@vger.kernel.org,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org, masahiroy@kernel.org,
 ojeda@kernel.org, pratyush@kernel.org, rdunlap@infradead.org,
 tj@kernel.org, jasonmiu@google.com, dmatlack@google.com,
 skhawaja@google.com
Subject: Re: [PATCH v3 1/3] liveupdate: kho: warn and fail on metadata or
 preserved memory in scratch area
Message-Id: <20251029153553.68f0a82182991ed8c5d985d2@linux-foundation.org>
In-Reply-To: <CA+CK2bB=k6ZxeEuLC9Xwtzmgm5MZdpH2sRgk84WQVm4uoeHsVw@mail.gmail.com>
References: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
	<20251021000852.2924827-2-pasha.tatashin@soleen.com>
	<aQHUyyFtiNZhx8jo@kernel.org>
	<CA+CK2bB=k6ZxeEuLC9Xwtzmgm5MZdpH2sRgk84WQVm4uoeHsVw@mail.gmail.com>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: F3EAE40016
X-Stat-Signature: teyqch1cywjaawof39pe19555mg47sr5
X-Rspam-User: 
X-HE-Tag: 1761777355-30897
X-HE-Meta: U2FsdGVkX1962eiJSk4cVO+5wPzAub6hH5db3pO9MDs08ghHDwmUuOExofRTv4ulFMHE3tY0VgQl06t8tzbOIeZL5dJbWHLAwb1HBDfAjQKk1XWjF5SSpu5FulHULkBvTWHbOcl+MEZfQu4F+FjgrLLPXA8gasMw5m9v0rcpJ6GWBtRTfNtrIfYYrds3JwYoggFcWibbceRgNMe4B6rzvh1BvzUmsQuur4525x+dqcZtQMZP1DhL0Tqzl1VqTr6FpXmn5YOVyEjv4wm62kwyP10oBw2NeT/MdjTcNYggiz1wugJOO70Fzt9SS1sP6LrAtaqazjFlM3dcQWudb4oF5GkIekmCq2wAJ2oDnC0wpNfzb8KIWA7BtqD/KYxqg4uvk+NXk40KlFF/zVvhZIaqp7wu6TruO7GdiGHqVFxs7hxsMaO7JVbvTVHmiSzF5/PZgOgfPEKRvSnhx8inrhy9fMrKdu9r4j0E/4wVCtUTAZSe5eZO9JoMuT45uXAowXzu9i69JtFgatSMT+MzTqoEgTYmMTBlqMfCQffgNH28TnJd/GW8IlT5SZ5bDnoN43fPy9ZydcKkQ8vw26YXsZtvBhkHBE0gZpUdmKFE5PMJ4d20pbPTiidYL16GLuYr1lmtKfX1MlLL/ZWQETPT6b1NEZB78bRMHIjJtPd5WSkDHPp7EFfVyhEwMuPXCjXrTep55sAlT2zquhMRBRiLUz5n8dvSy+1/lpQ3iBc0kze2e4VhjHuM5oQNPfHj0J0ySdiUBUQ7I0J5iASUQfiBLXgWvrEYo5zvgSreyMkCICBbfRWX6vkvkLolm3OReG958GxltKyN+XonR3Jv2E8rS6dQ0Sbcc39e7m6DuKURyslUFy0UtkWMLAC8K4e1z+HAPtKx9aVFjXAMbGxUzA04akbBcc8daCGi1G5p6sw84WHWXELeWWhSP4+b1YwlK22i9b69Z+WS7yPv0vbSSEqEVfi
 ouN5TG7J
 g2ZzRJgdNFeKH6NP9Pa8XDoJOQ6yYbdmD3Bf0z9wGZGWdMr8npjNfKLuTz4ltc7mQkXLMHfAspZqsT+dui36YAkCzfXL/Gzkq8CD+HigqtKMvdt6hy21Y3sQgynJ+KASWrIvAOzZ/SweuA37mKLl4olsIZpRWPLnzOJ2jn6sTpd+cOcfJ+/ku0z2Bu7ZKr+BLwZDurDC0pzgkOcjN+NAV56yrT0mSE+NkmljYlgGqLU7dpz3pwkfWUYTz1fgmHqlLL/MSRH5qyebDD9PKxD1Pc2ViPhPyGzBo6LDXeB0yjbvnxIX7fXH/MBj48w==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 29 Oct 2025 18:22:46 -0400 Pasha Tatashin <pasha.tatashin@soleen.com> wrote:

> Would you like me to resend the series with the "+       depends on
> KEXEC_HANDOVER" fix from Mike, or would you apply it into your tree
> directly?

Let's not be resending a patch series for a one-line fix!  I'll add
Mike's fix as a -fix patch.

