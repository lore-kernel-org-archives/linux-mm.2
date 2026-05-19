Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 39939CD4F4A
	for <linux-mm@archiver.kernel.org>; Tue, 19 May 2026 00:10:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 308B56B00C4; Mon, 18 May 2026 20:10:22 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2B9E66B00C5; Mon, 18 May 2026 20:10:22 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1CF9E6B00C6; Mon, 18 May 2026 20:10:22 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0B1666B00C4
	for <linux-mm@kvack.org>; Mon, 18 May 2026 20:10:22 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id ACF421C2181
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:10:21 +0000 (UTC)
X-FDA: 84782237442.19.20E9D1A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf15.hostedemail.com (Postfix) with ESMTP id 06126A0002
	for <linux-mm@kvack.org>; Tue, 19 May 2026 00:10:19 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S2JU/INb";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779149420;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=j/OYu2KikNZqMAEjuQ8qTAZKdlunDTOJkQKYD5OIvFM=;
	b=YjEPSptD5QU0LGjoHtCIaN+amlF4ykgRE7A9Es0PEmAjP8QEvYySOSibh3XSAdR56qL36P
	l8SJFx/PK3zWGrrnry4HsrApQ9A1tu4JUnMD6291dk8pzvWc3DG63myM6JGIxHkeP7e7FH
	PeVYpc/R4rMsw+6Zru75X2U0JluQOjU=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="S2JU/INb";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779149420; a=rsa-sha256;
	cv=none;
	b=pQx/DzwTG1QwWGWvbIfk6u9I6+AwjyqOXEJp3XfFm2maUcRU6OtHfKhIK5pdIU/av1g1xC
	qaO20z8wQTBWgv+dcTS6nxislwyDZ5WIOnkA1ZHpbRiIPFtWtLW6AXHk8+ffi3D/Q971gl
	I2Mt5R9UOL66R5rXWlVS9MH2uMAmYRk=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 6D2A960120;
	Tue, 19 May 2026 00:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 785E3C2BCB7;
	Tue, 19 May 2026 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779149419;
	bh=6EEyyCmXZe4QyrN36kjm7G4P+AdpHLcR6vaJ02zX3Ss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S2JU/INb9KQ7ApYSFYLmMTtTSU9WcpYCIko/CuisG3/KwjhkDzxcNg+nlowMkCeAd
	 t2xq+OyVOhs+C1a2iEXSrJBCW6a6JKEvUpOE30E/i5XEqIvxCFRubKgOlnVsrvQPj4
	 HXyS5rhfwnEL49De8MmkiJQzuAnDXpVsi2UGI5B/5uamxSJfxt3mRidOcLmPsKLN1Z
	 xrZS1D1dLG6vhhT523L/tHCGnHOop6JtL97WE1yh5hVfQbRCDAyPc3u6Uu2O6ekBb/
	 sj6vuN0CP3q4AVppPq4nXwOc2zSznVOSAG/UnD1hf0UoQJZV/bv24Z2aOS7nMQOkWY
	 5vUyyawamAReQ==
From: SeongJae Park <sj@kernel.org>
To: Maksym Shcherba <mshcherba2000@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	Maksym Shcherba <maksym.shcherba@lnu.edu.ua>
Subject: Re: [PATCH 1/6] mm/damon: fix missing parens in macro arguments
Date: Mon, 18 May 2026 17:10:13 -0700
Message-ID: <20260519001014.99041-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260518190932.42270-1-maksym.shcherba@lnu.edu.ua>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 06126A0002
X-Rspamd-Server: rspam06
X-Stat-Signature: u6wyzfibqsejtb6th3b6kd44t37kzfqt
X-HE-Tag: 1779149419-855655
X-HE-Meta: U2FsdGVkX188t1GA7HeSd9PmthLdst/RJMMV2deZoSIX9pUV5eGfrs8lplsqex8nTAnM6Lgw/TEFKb7n2BDfi9nuJUh/mxfs3s26t047XXBHFlIL9xZ8eMdG9TsJOBprlPoP1F1KONlddp2N74pkB8caKQUbLupj0939k57s7f3QaRLOh3CoqsdUUwBRAwwJRY0wGWNpfTIKEnR5wBEAU2E+Q02tMP72rc4O01J6rWm/yDWtwDyIK9D3oLMqSuZjBLtdEDXc+lRIUDJAwQfE334F0CtAt25FmVDyPbka0aplUHfQq54MBbAXFmGAmk2jhglidBqZronnqzaF0KsiD+j5IOYDoqw1tRUMNyrzRcEiGo9ZQP/Zl4vSXHyxWUgIujm6KYk6Yv3z4Box9nfWmWsx8pklc+2Jlqvx4WEjCtcg6dxHClMNgLkQUzNBz3iDPGAla1EHT8ARH5nsqaB0YqmIQfFJu9Z9XMdTWkFLGYvWvkKiGkUFP9BMOyLOoC9aZx4jJt2bHUwIIDjEwzEQAcu2jeVyIrZtp7vcD+STtr5hAj4uB33jjoJ0LW1bQzJOqlJQMiru7vKOvYsZcvUTkJieF6NEAhOxAOuLC8pMyCWXIPTkAlIzATy1M5F7H1h7XSFlSCdbQ238lVEIxG7I75ZEAtfgWrXtvJQrctk7cWvg+Wk9Q6L2fxydRc345Urc0GU0z3nKeO7R1VnKWbfDJ2zWIsKIyWh3LQSyki3M7Qk7bDF84L1g1mdvIYstEtff3ly4rTfoWk9IeHqKSgc+qTgQfHsh8Pu7CoS9yk7k2aVbrhprMpzFzxfpctqL2lC7eina6NTi3Mp8uJ9yNod804qPSu556qr6jFmSqv+PQvj/mld+b0ZnTjLQh5sJJSIWHy/uJX1ntZ+AHP6XDB+L3F+IPrdQlicodGGNzWmn5B3lmFyOzfHUPb7Gey8x77AhTjgvjMUI2o9+XyXGYol
 NI8eol41
 ouTH1H/Fegy4yGZqIBabHTANY/W9O77LogSrreSdqYv0VJJDPhzGNlfz4OpXoZ0h9O15iMLXCnX3ArBAx19bK3yK8oKjLPENhlaLbJQIjuNtsc5jP0bE9a3fNyQZGw+T74mPXehWgJlOyZnxGl0NiWRE/AEdtoNfKmYiTvXsW0hNiybxdL0mFlgIYVidYKvfErQsyf4GMYjOwkvBl5NWqodFyN6i8Z2EiguKszdBOVNQJFpVucMpStN4Il1yssaSnwZChm4jGe89TgNGML9ePrw6yug==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 18 May 2026 22:09:27 +0300 Maksym Shcherba <mshcherba2000@gmail.com> wrote:

> The DAMON iterator macros do not wrap their pointer arguments with
> parentheses. This can cause build failures when the argument is a
> complex expression due to operator precedence issues.
> 
> Add missing parentheses around the arguments in the following macros
> to prevent potential build failures:
> - damon_for_each_region()
> - damon_for_each_region_from()
> - damon_for_each_region_safe()
> - damos_for_each_quota_goal()

Nice catch, thank you!

> 
> Assisted-by: Antigravity:Gemini-3.1-Pro
> Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>

checkpatch.pl warns as below:

WARNING: From:/Signed-off-by: email address mismatch: 'From: Maksym Shcherba <mshcherba2000@gmail.com>' != 'Signed-off-by: Maksym Shcherba <maksym.shcherba@lnu.edu.ua>'

Assuming that will be fixed,

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

