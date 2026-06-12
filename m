Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 041A1CD8CA8
	for <linux-mm@archiver.kernel.org>; Fri, 12 Jun 2026 14:23:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 689776B0093; Fri, 12 Jun 2026 10:23:51 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 660E86B0095; Fri, 12 Jun 2026 10:23:51 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59DE06B0096; Fri, 12 Jun 2026 10:23:51 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 49C4F6B0093
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 10:23:51 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 175ED1622C5
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:23:51 +0000 (UTC)
X-FDA: 84871479462.21.15324B5
Received: from out-181.mta1.migadu.com (out-181.mta1.migadu.com [95.215.58.181])
	by imf07.hostedemail.com (Postfix) with ESMTP id 007814000B
	for <linux-mm@kvack.org>; Fri, 12 Jun 2026 14:23:48 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sx2uHkL1;
	spf=pass (imf07.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781274229;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BqAB/Wqowi4r5cPszs7vTL12lGW6sUQzUkSUFxNjBxE=;
	b=PfK+fLzWVZK9eUbVboBkzLzIU19ey6ZalfMZ1u2D6YvdV1ioVPeidZU6J7v5668/cQahZ9
	dMYIKW5+R+r5PkfRpniCJJc1m7j/QymUT/SVbCoIbpRSvKabHzrmZaaCaznoVhaBYfYP99
	4b1NtAiBH2DVQKpT3oFxARPaI63MqXo=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=Sx2uHkL1;
	spf=pass (imf07.hostedemail.com: domain of brendan.jackman@linux.dev designates 95.215.58.181 as permitted sender) smtp.mailfrom=brendan.jackman@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781274229;
	b=iFkTebbkLMu9qi+ayfIT4t+IW9udeGbkarO3IYDW0ILPHpqdk0M1nIbJWacXtxWF+JWBF9
	1aE0Cl3W5prVcmcmNobDCM80nroQ4N/Klp1em0W7Kz93vO2tkgnrYZYmpWBPqruQFYg2/d
	nZyruesPuOHZ7PMZ5yCgF3+CuH6OtVQ=
Mime-Version: 1.0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1781274227;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=BqAB/Wqowi4r5cPszs7vTL12lGW6sUQzUkSUFxNjBxE=;
	b=Sx2uHkL17Oiy/RtBYLoFo/NiICBdEUf6cyBW5V4jyO2POegHKhzcMqu6N29s/JD5m4l+sc
	RtlHmnFKvEjHmvoxgSHAoPhfIcolM5l0U7Zp9Zou+5ZUk9oxlcHRxeLkT/0hYCX/4noDvz
	m9kEe16stb5vDzED2XcQ16t15OZ2lAY=
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; charset=UTF-8
Date: Fri, 12 Jun 2026 14:23:42 +0000
Message-Id: <DJ750GWV31AU.1ATFZRCR8PQ04@linux.dev>
Cc: "Harry Yoo (Oracle)" <harry@kernel.org>, "Gregory Price"
 <gourry@gourry.net>, <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm/page_alloc: drop flag-conversion "optimisation"
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: "Brendan Jackman" <brendan.jackman@linux.dev>
To: "Brendan Jackman" <jackmanb@google.com>, "Andrew Morton"
 <akpm@linux-foundation.org>, "Vlastimil Babka" <vbabka@kernel.org>, "Suren
 Baghdasaryan" <surenb@google.com>, "Michal Hocko" <mhocko@suse.com>,
 "Johannes Weiner" <hannes@cmpxchg.org>, "Zi Yan" <ziy@nvidia.com>
References: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
In-Reply-To: <20260612-gfp-pessimisation-v1-1-936eb04202e7@google.com>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 007814000B
X-Stat-Signature: kt96w3s3f7m9hc5xai3nqm5uhmh6frqt
X-Rspam-User: 
X-HE-Tag: 1781274228-977166
X-HE-Meta: U2FsdGVkX1/geNVH2n57hRnZ4B/LDI7ucKFbyNGQnpdrlX56d8DQMoH/OLmjj/m/h1kMmHOJkrh2OFdYErpv5Djc0VS2aRoMJ2mOTcFpM1qT8SK41H1k6u93+VmanGcd8shkG3bI0sznltPOTykezDTEaXavdZB37oEZ+86+xgKbizc5ac7TRshsa1mBPdBd/AhZYvXsO4o+Q/XQqvu5zLMHVOBJhBL976yIRGmNk41GUBO2XtmoB6yWVPvUBA4TAooenAZheympr+eHNjYaDa6T2BchM0bfpxCK2fEJ6ztNghXogpycActsuDyUq6/x3x2A2SNBI4gBCKygDQUny4aCOBmQWBv+kiwUzZMpjiUDCiQnkfkR7BFN2ngTafx0+3tE3rDfg+bovcyRFr4C706Q+fduYLopK3VyCnVUnic/aDh5SjjVA8jk00HmdDjJ8HqW4gGQdBBC/65rPaEzdsJE0pBccso9ONQPi6ouBHFcZybxvR4x6Bjt+UktSZhH7DNrvRMnl6pCw5Kfo0yZpgtCHznD1GWq0lYpzGS7qJwYl22fNbWXoJvIhE0ONTlJigPp+ypx7pXswZMc9RYmyH6of5QkbuvCQZdPBe5vvCaVpXpu4NN32vhM1/3dWtJIfWNYKZ4YTgtEKTJTnC/GThKH6wandcY5cmlP7HNYU7D3ts33+nPWaXCmTFHb1BQhg3b/n2J8KwC4DkRRbxerohlieUYoAYFTwCUKtSZOOIKv8EAvnk+0cVKFQpNZ/L8xh6bUux8U6Ge9+qiCX0e4ti9ejP43pSkqzMgCUhwiEkaZchpD9Dt/8RqpWbIP/6BdViesB4R1cznRSWp39jWlXfP68Yt1Kf1LM0pi9XGJkscjAEBjkFFpZPBPZEGM0IgZ9sl+Nb3mZgseRuKyGBLPzanvngupPX+s+fKTxRf7ekp9upcDzQTLXkiE8r1JlZHq0iZdgvQYHEaSxho5b8X
 HVyKxqU8
 SWEKplIb8w0jw7THfi3QTQoXeEuQlPNT0TA/mW3ka71tsiZJD+26PMKyCcbhkFKlms3IVpBNTsGCSBRhfTIEADFpb7v8xZ2TrtfnSNscYSP6z6lA1vp6VHT+XCDz/m5yuOi7a2BeyuDuDdSvcVRJkXOt3ZrtPUCpc0vVmIo8qFbJ0D/y48Gn+maDsxqpVYctTkHvJW3H52ymVmjHU9MaQNWxWuD5rVihowGbV4eKs+BYNIiIwCa52hhvA4ZQrpUkmTTWBetZTESHbDilXIu7i5WZ0Fsz1pG2lHNLkitECqWitkMF2V8J4XgEyRVgiWSZXUpTYb9RnZnyL5ouVIu8JaESaT1Fh157ldJnyXqlgBWK4RSxlLszr/8K7kvjZqxipkcoudVcZH62ao+s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri Jun 12, 2026 at 2:15 PM UTC, Brendan Jackman wrote:
> [0] https://github.com/bjackman/aethelred/blob/2ccdc84ef087c2a631914f58e1=
06e99e19bd3b98/page-alloc-test/page-alloc-test.c
[...]
> (Used AI for the disasm but the rest is all manual).

Oh sorry, for full transparency: AI also set up the "benchmark" module
above based on mm/test_free_pages.c.

