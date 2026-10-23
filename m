Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E26A560A2633
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 23:21:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=O6W+KYNl
Received: by kanga.kvack.org (Postfix)
	id E3AE96B0BF2; Fri, 23 Oct 2026 19:21:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DEC376B0BF4; Fri, 23 Oct 2026 19:21:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D01856B0BF6; Fri, 23 Oct 2026 19:21:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B02D46B0BF2
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 19:21:05 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id AD7FDC0294
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:21:03 +0000 (UTC)
X-FDA: 85355463606.22.5349923
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf06.hostedemail.com (Postfix) with ESMTP id D62E4180005
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 23:21:01 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O6W+KYNl;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792797662;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=B2ArrvzltjwP38/8ht61a73Lmjbrh2f6HfaOLEeK7o4=;
	b=MtEMj7w8/RNMOs/1VYbBm4PTZKdiYqUFVfqFGXgDer0zgKTBJdaS1x6FOPfgf+UyHg5tFu
	tgARkn9tCqZ9BGfcYgibRaf97CQczdXfb5HS/ubT+cY3+bqu1rkOUfBD+a6yheiZdZl9gG
	tWUvCOSRo+B9ESkhal8+WovDNutDuuc=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=O6W+KYNl;
	dmarc=none;
	spf=pass (imf06.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792797662;
	b=IAhPJEE8JTYmZP3p7iSup6MeuHVlLr8ivU4mZjvlzN8iY2bAIZiZPxEbunTjTpT2jvuwVT
	duQEws5fcPeeUXKVjHWe9d3GU9dnzim2ESysTcRYHtk6TdJ+hHKayNEqVGjFccJpwEFaEa
	wOB7FpoxO0SRlRUezRy3xt0xFi0CppI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 132AF60A8D;
	Fri, 23 Oct 2026 23:21:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8ADF21F01825;
	Fri, 23 Oct 2026 23:21:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1792797660;
	bh=B2ArrvzltjwP38/8ht61a73Lmjbrh2f6HfaOLEeK7o4=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=O6W+KYNlnWbK8/PA1L/ILQbtBHsWsiLy+pduQw+HkWI/aD6RKzFwhp4yU9YbPQ+Z/
	 irV1cvUhE7/LH8LkI3cUK7DmbDx8nyeUE7MYlLpO6owMuvdeYAbMzlKzv7hLKrUMXX
	 RgPscQNRHFVX5F5n6GL3m/R2e4+/mPegf2jszDMI=
Date: Fri, 23 Oct 2026 16:21:00 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Suseendran Bhaskaran <suseendranb@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>,
 Nhat Pham <nphamcs@gmail.com>, Chengming Zhou <chengming.zhou@linux.dev>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mm/zswap: validate dlen and normalize comp_ret on
 compression success
Message-Id: <20261023162100.41145a57fb91ed1073c24c41@linux-foundation.org>
In-Reply-To: <20261023200426.3865221-1-suseendranb@google.com>
References: <20261022232734.496064-1-suseendranb@google.com>
	<20261023102607.7635885be12b0b6e7a5971aa@linux-foundation.org>
	<20261023200426.3865221-1-suseendranb@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Archived-By: <archiver.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: D62E4180005
X-Stat-Signature: w5i39h3so3nwf67wo4qf4j3i8qj5dxzw
X-Spam-Status: No, score=-7.5 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792797661-520312
X-HE-Meta: U2FsdGVkX19cpLz+K6uQB67WB97s84m51m1U7VsNQfkK6qrNX0v5wEDeTf5HmvW6JdPpVuOkTw/++BjGASomj6XdQpfH435ZhQ6M5CutOStpTMoWaEQ2Lr75lxB2StVfni466enghheNnUTqiTCpU1HpQT7ZsyC+Wdo9OCmLfE8hBEots+h5i5L1lUtP6Kzbw8WnY72NZcmLFiRKornUihZsvxIkSenMtGYNrqMbiUmdn6gWTr5/DQPPhd347dEI2YMQCbSGgYslzbHddAFzwfHhdmNaGxUqpFJ0YmyAPZM3/IP/YjSEmYb4d64qyCcP3tGqlKsPvvB8t1eEH/tAHtFPw2DWQyoc3GAp/7qAMyfGpRgsVTOfjB1+o7gDpx0n4GOa1BEOLkwUtgAd9L8QzMj06oLM4OhZ21TggSRosa3nDi/fsgB6bqaRtmnWl9n3Oz6R14FTEXJ/we9s94wB4yuo6g4aF7lALZgWQ7fcVYIej2W50yyIRLkO5Dab2DR89m3k7qTyWzIssfsxbuq6IKctYNRFpqlZqH5WeQdbXmz1K6NceSD2NbmbucgTXuBNvYusHEUAgOTicGJFpDHOrFYDnRIqYaKOruvZt4DdvPaCqf8JMuMSOLHNNMJ9pLaoDz1DKyxtmpMpLPsQ0TEg/UrtBjXutTWdJJj7i6tetSgrcfrAyfN4v0VtQo/tZ05SDqmDokAuKOVMMa83uU2sbC3WjHsxk3qeVqplyfjzHTH6c2CSqrt06sQ6kqnaIMKgfRBVyJtJV9JnTJZsp1aZeBXVPQeb5bya8ayppzmaAotvChKMjKZx/yDt7uRqhdVIpcSzvo2T/UgR9ptbQqYqc7lm2fwZNcTbDFbknOBGNqQzt0uYG/dzV13EzHbrCsKirRN1ljXGy3u/Z67vt85+ig/k54kSvPSVnSY9P3Ic6DrO/fkxKHwI/yiajRlJ3FEzys7cHBCPEpSBv6VxxDY
 +7yxzgAU
 fPO1IANHN6HIcz3JK7FbehqPWDb5ICvk4jHEzUoW0v1Hf1IQc3u42YZe0LWET4Z7c5DR1zUFN/mq13PzyvoYcQNw6OubrCUUy4aAoTftDK8QI7eE0HbGa8Yvbr1UXL4RoMwr34nNSR+I9VQtlB1Jpy8nA0SxcdKxZi2cuRINC9XTiqgizhOcjxRF/4axPmAvDnzqZ7sGdsbzfrpyrRDOM3LsvSwmuu9wb3HyrLAUlFPorEAJChzhiZa3VdrPyXv4aVDfzxbFk9GLW2iOjs2Ri4A1S6kMd2R6MkSozT5bj0TogwdQtzGwQ2DUHH56CPrm9pp8J
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 23 Oct 2026 20:04:26 +0000 Suseendran Bhaskaran <suseendranb@google.com> wrote:

> > Wht you forgot to tell us (please never forget this) is the
> > userspace-visible runtime effects of the bug.  Autobot says:
> >
> > : The userspace-visible effects are limited to corrected zswap
> > : statistics and a new warning for invalid compressor results.
> > :
> > : When compression succeeds but produces exactly PAGE_SIZE bytes, and
> > : zswap writeback is disabled, the page is rejected as before. However,
> > : reject_compress_poor now increments instead of reject_compress_fail.
> > : This makes the debugfs statistics distinguish incompressible pages
> > : from actual compressor failures more accurately.
> > :
> > : A compressor which reports success with a zero or oversized output
> > : length will now trigger WARN_ON_ONCE(). Previously, zswap handled
> > : these results without a warning. On systems with panic_on_warn
> > : enabled, this could cause a kernel panic.
> > :
> > : There is no intended change to which pages zswap accepts, rejects
> > : or stores uncompressed, nor to normal application behavior.
> > :
> > : I think these runtime effects should be described more prominently
> > : in the changelog, particularly the new warning.
> 
> Apologies for missing the userspace-visible runtime impact in the commit
> description. I will make sure to always include this going forward.
> Autobot is spot-on here. I would be happy to send a v2 with an updated
> commit message that clearly documents these runtime effects and
> behavioral changes.

I'm mainly interested in answering "should we backport this into
-stable kernels?".  A small debugfs accounting error is probably a
"no", but a WARN is "yes".  Is that real?  Can current kernels truly
emit WARNs due to this issue?

If so then yup, please send along a new changelog.  Or a v2 with a new
changelog.

