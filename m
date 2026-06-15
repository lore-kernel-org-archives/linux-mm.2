Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EB2F0CD98C7
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 11:00:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 109186B008C; Mon, 15 Jun 2026 07:00:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0BA296B0092; Mon, 15 Jun 2026 07:00:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F117A6B0093; Mon, 15 Jun 2026 07:00:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id E42C76B008C
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 07:00:07 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 95FEB1C314F
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:00:07 +0000 (UTC)
X-FDA: 84881852454.14.6085A10
Received: from out-185.mta0.migadu.com (out-185.mta0.migadu.com [91.218.175.185])
	by imf30.hostedemail.com (Postfix) with ESMTP id EA55180016
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 11:00:03 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AxAAqXCI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781521205;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=tn3RA/SQuUnimr/jzhxnRjfs2GVY4pXk/qtDAlwJZBI=;
	b=IMWxWYHQJGmePrV1LMDakio8awecc54tyVI8TiuaKgpnnNXFZBMMgO3OaCUUBONqLps2Xp
	+cVA1LgGSnJ2bTw21tvJyx8maToHYiRhJa6CybGs/IW/j4KRQSWMfrOM08XVBlDVeyfwfc
	5MYQy2fvGhG82aHbgYKKxteajmAqFks=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AxAAqXCI;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of brendan.jackman@linux.dev designates 91.218.175.185 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781521205;
	b=brK1fH2711UK3F1Psbx/tDGPsim+PEWLJk6fKIru3vMjB0LFsEQjF3+TZk/PWvV4FqOB+o
	FaRPWvcuAt1Dudvc7F2PsbwE9UBx57c71jXkeJR74GPpe0GqfPSMR8asPhl8u07aN/kTaF
	WOW9l270tSt4h1u/1ouajkVdKihl/CE=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781521200;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=tn3RA/SQuUnimr/jzhxnRjfs2GVY4pXk/qtDAlwJZBI=;
	b=AxAAqXCIIrQaUSoBVMgle+1y/h77Nmqu6XTlZC0EBCoVEEfc8fu19xiJKaIVa4fkGwttdP
	8p/Ifa+7hD3ZpOE3zSGP8xtuc2ShwqvDrusbwcmOQsjkSH9e5J4XUemuqs8An8M3YlMSy4
	CzOdJbykTjo8IB/zNcgS5bZ1as2VBZM=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Mon, 15 Jun 2026 10:59:58 +0000
Message-Id: <DJ9KK3Z7BPYU.2HDB5IVO6Q40@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] mm/page_alloc: drop flag-conversion "optimisation"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>
References: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
In-Reply-To: <20260615-gfp-pessimisation-v2-1-65f1319e6818@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: EA55180016
X-Stat-Signature: cf6nfb4ia6f45p49yusdsmcu1s11p4p5
X-HE-Tag: 1781521203-711998
X-HE-Meta: U2FsdGVkX1+6g/ZKPIWnfyCr+U2p4oVe2v5BGtRs/nHC4kPvC7SNNWo62fQFWEzlsBaAHwmsCsIg72Ua09GydpXbUnf+nGJM9uCOv4VsT8gt/DXGsqiUIQgHkcP3FAAaAEwpfagoY0RkULuqsl++3RQw4q366iDq7EWU1S8zAM/fCnPJtF71930YvlHilvmlR9XR8xLLbABqkF7UNBuirKk4F1sPWFO+Ikr3qI3U2fvv3U3tF/Y/tmb1aXlmIIFflFHcC13gwQIP+Nhs10zUbApqfwVzRAPiKBCFebuzuh9HFsEbbSdVHZR3Q9KwoQ5XCECXQJWiGErv3hI1HyS1V87/vOY3Mw4Z9VM3Q3fe04wgqfaqHfwfSxUo8Aj+4CEoyXKWRWcfhWyFYHS7I7vVsjqGygn7KiBAt5Zjny3En/EOFveZQvlhY0zW4xW3+uAfUJSYjRztbCYIOebFEACTuOy+tM6pV862yXGLkj1aaCE9mgjst5oZFM+h4OI4uXyOEW8ZiTb906OMkHhplgSt8/Ig1CWWr1cY/m+sDEqaFUJkYVDpNit5FiJQXYN29KJKXlsOkOsL4RIIvTh65hEJFpH82Nun0bmVEfYwHUyelHESzuNAKK/B3OAZW2N8mMwYy9yVASjt7grjO1nxJ8GZK882js9K9YbMJbZMdh/6UIGWE7W4yAVWN0rjnZwiEy6+lUn7qvYi9css30GZZGAqAydqg2Vr2FHAusx4IixHlzuNnjUHrF/mngJX9hVQQsyaaPRFG7ieEZBRzdhdEXaRmKpFVGERDKmAnXdOdXm8cLcC1QC1+FaRBwJwp0iWINJj/6E8bQCpZdLxyVhRVKe5WWoLjWj+IlekFYbyHYff1Pe/NN+vHZrspa1vguREHwuzsXCCJ5cfz/mFyg29EjQWK9Tz5JblkB+3uvDf0d9khuqxwUaSG//VxOKorDgcYFPsrq+7T8eRT5Xf0nz0KNt
 NzbqM0VZ
 jyS64yFii1CtyqMd0LZgMBVXNm6Xs+Q8wegHEqKcYdIcPGvRAkR1bGv3leOShRK5mllFNbhlpJRq1SLbW2rSxXBh7P3h8eGRXO9Nn6SSSo5ok2Fj2oTIEa+KkJSvyIiX3jdnvdeP/tJXZV9IZ7JcfNnzoSQ+fa94T4DF7WRPe5qIQGS8O2X1ubxvCrbJJkj43pqu8YE63R5zc1lu5d/UjkJxQjLK4R2YRVP8uHYtFdj7O6S3I3qS7g5dWGu2o30J+8QGPgtQdmzsPGiSJEymzWHlFe5w9EqyaDFfmzYaItJw3fwg7T8yPoexbjbY1XxaiwfuW7elxS0oMYUd0E10hcF/9NOR6goNANi7p8XDT4TKx9O89KyWevldstNmNI6Zfada+8B4AP+Oj3RCA3UV3P7ZPKJP3MV8n0o2qS51jriax3V1tCKEqokrbhpE4PM9aVSx/lgxuG5awnXVVI67oZwGHmaTbPFgC1z2H
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Jun 15, 2026 at 10:54 AM UTC, Brendan Jackman wrote:

>
> Signed-off-by: Brendan Jackman <jackmanb@google.com>
> ---
> Changes in v2:
> - Updated alloc_flags_nofragment() too.
> - Link to v1: https://lore.kernel.org/r/20260612-gfp-pessimisation-v1-1-9=
36eb04202e7@google.com

Sigh, maybe one day I'll send a patch without immediately following up
with a "oops, I forgot to ...". But today is not that day.

Forgot to add these tags from the v1:

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Gregory Price <gourry@gourry.net>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Acked-by: Harry Yoo (Oracle) <harry@kernel.org>

Thanks everyone for the prompt reviews.

