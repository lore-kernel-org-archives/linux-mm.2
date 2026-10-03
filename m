Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4A4ECCA5FDD
	for <linux-mm@archiver.kernel.org>; Sat,  3 Oct 2026 14:15:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BFEC36B008A; Sat,  3 Oct 2026 10:15:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BAF056B008C; Sat,  3 Oct 2026 10:15:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A9E5D6B0092; Sat,  3 Oct 2026 10:15:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7F7F06B008A
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 10:15:04 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 007C3A096D
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:15:03 +0000 (UTC)
X-FDA: 85281511728.25.ABB0D3C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id 21B584000C
	for <linux-mm@kvack.org>; Sat,  3 Oct 2026 14:15:01 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNRktYnE;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791036902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L3O+SY14NmcYs4JOqo1ht8ryDCyOse2Feg9y7x3ofFA=;
	b=cayasfDLBWRE/h/g9bl5IaYZdtgfzjVA+mzZ3ALv9JWT3JDkqZXQadr0JpRnlFFkDzG8GC
	5Do7egkbdYRIOPIkDhIe8iOE5jg9CT96WS67xkeHmIuSrYKd8AaIq7pKPadMzGtzUEFRR3
	+Oqfg8GQkWfZgWTuUviZtKH204vw5k4=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791036902;
	b=iy6XmhroQpG8xOfwR3L4NcewlgUCYD+o8Zg5jK2RhT1JSumMb11h/CHMh7bxt/vGoPfvKQ
	zhym+I1TLxGaMMHCUgcHS15LHlBPt3uGvxs5qsEAvcY3bCXCAQPep+o5c1y1ni5ss1dzwS
	8he0MDMthOKkwMb+DyU0ffEMEi9miAI=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=SNRktYnE;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 05491438A2;
	Sat,  3 Oct 2026 14:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7BE61F0089B;
	Sat,  3 Oct 2026 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791036900;
	bh=L3O+SY14NmcYs4JOqo1ht8ryDCyOse2Feg9y7x3ofFA=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=SNRktYnEK7R9VzzxgyiWbfu//bLlEPx/3iTGJPYJdLhai16FG6aTFMGU7JaT84h4M
	 BZEiUB1axFm6wSUaqikzT6RE1ZoaRJeioaFzRzmxOJRsIJlbJw0kxd+cc4GgPEiLRQ
	 ow4txwe8rn5oRcUGBeG620aug3LlerZYFAaHdf8pbsuss0xkr6v2qqbCHbeIOslQpG
	 b2+sCRTcAHTYIaiKX1n/ZSzg0I3Is3olC9np5K1rB2CFpQPyrr7gJlAEG+6v2h+m83
	 6zId4Q7f2KOeGRM+tXszpsKBfd/MDgXM/XrYQCVCtnJEGCzXCNX09K1Cy1vIQh6UE8
	 mWCea77kqo/uw==
Message-ID: <3c5b9d1e-5ed4-4bd1-b532-39f2d4612965@kernel.org>
Date: Sat, 3 Oct 2026 16:14:49 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [REGRESSION] secretmem: SIGBUS on memfd_secret() pages while perf
 record runs
To: Ameer Hamza <ameer.hamza@truenas.com>, ljs@kernel.org, rppt@kernel.org,
 peterz@infradead.org
Cc: akpm@linux-foundation.org, mingo@redhat.com, acme@kernel.org,
 namhyung@kernel.org, linux-mm@kvack.org, linux-perf-users@vger.kernel.org,
 linux-kernel@vger.kernel.org, regressions@lists.linux.dev,
 stable@vger.kernel.org, 4ncienth@gmail.com, sashal@kernel.org,
 alexander.motin@truenas.com, caleb.stjohn@truenas.com
References: <20261002175651.811343-1-ameer.hamza@truenas.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20261002175651.811343-1-ameer.hamza@truenas.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 9hcp9jgncwhs8ai5ksisfkpemodk61z9
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 21B584000C
X-HE-Tag: 1791036901-860437
X-HE-Meta: U2FsdGVkX1/MGObhRePyVNANHV4tdXSsm/ODPXgVq/OTAReuC4E7zqsk5aSeb5WKDjyo9SdC09fSphIBXJbeWAgWrHFR4OCnl20ALS68x2c1dm/5u53mtTi3t5We4sVHGXl3Z7gbTqRISecUe1Bt1hh/3O0dxEQZfJ+674tdMUB2Mxqo4M8UiO72+DZGa9HMXs7n5Oyllw2gXswjjiUDvaNbU5ktt/MyqF1eXVm/N9JhjNkrrauQzIzen0xYjZiHB2ejr2LDOa35PjeBi4tB3h1ChCh9E3vdyKst7FQNNOfTxD1LhbAzDOFjept4F1FACuzg0vY3+VettA8fRE+wqmBmk+RG5v0m+iFbv4i7mj2XTBXgivxzzN9M9W3pdblZ2vVTT2+Hiqr8RJ/gA30I3MW6kX4WER8j1v5a9jWQOLFH/TNBsM3EWTKsrEicR0Vb5McYe2CBzszh0/hz2+woXUgh+mGt+4+QKeG0ui054rt/++JOeSMQt/nSGozTytCvuFM1NzX8yZumZIHAn3W8fImYhxSVaUBJ6KqJNilv6Edra9nrhtAnDS4fgUDrPf2H2b/Llsg7sIkv3yqnHNW86/cmHFUH5EVI33skSC4BcyT1hCAiejIhFR8etjDkGlqVx4rVA1rpLYCiBmloDJcvL41gDsY0GDTU1f7SHP0E/8mhQyAI8QGEyRwuagLg4gGsfMohXDmWYEddRCT2HAyvY21nCNm30jUNDdoNpLoN2jl48pwsvneerBoUHGR63AfK0NOZb3R74vZm4USihuTmywoQvS+xrYn05lGwFOHsiBJzojjxl05sO6siOMNM92N7hG+iIXrBBIAornK67YQkqx51UgPFm7+o45u3/oB77ENsuw5vRIlSxPes5H2EqZZXQYQNCuF0NBsc1pudncdGiBv5saYH26Rxrm0QjEIY7zKMdUz2RTa8fg6aM6qTl/pCPEOXlTXUuAl+aWI2Dpd
 QxmMqN8G
 jLcqVDJ0KGrGNaCQGdnKKaPZS1E+bA6Kwi3iMgieCj93akXSGt1oad0GGP8gjkzVPaSb7Px32v89T7jcKfF/EZEzoiThXrv1EPsCUpppx+Xx68a/WJXO/m+4+NxrDUtdhy/5ItQCzVEiRlWUHscpC+EYhadRlhQLxz9TghvN+BemPBmYBrUGb3hm2ucs7Zoihoq6yzyh4FLYLNb1r0kbB6JjEQ5RkLznP5TIvz+lnVuvQpVJ2Z/r1KCTMCzP5SXZ8JnPXOH/nlYtK0531uX8LazxDrAbEO3XQQfQUUKQib30HvTqm5nVc9O+xhZI5BQE685eav05qqUijKF8DTPNySXiE1VhW+ZHrda98FKL7lqqMMOQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 10/2/26 19:56, Ameer Hamza wrote:
> Hi,
> 

Hi!

> Since commit 97d34aa65c29 ("mm/secretmem: properly account locked
> pages"), in v7.3-rc2 and the 6.18.52 and 7.2.5 backports, touching a
> memfd_secret() page for the first time fails with SIGBUS while the
> same user is running perf record, and read() into such a page fails
> with EFAULT. This happens for root as well as for an unprivileged
> user running its own perf record. It reproduces on v7.3-rc4 and
> 6.18.52, and the same test passes without the recording or with the
> commit reverted.

Thanks for the report!

May I know whether this problem was found by

(a) A real workload

(b) A test case

(c) Complains by some tooling

I am asking, because so far I was under the assumption that secretmem isn't
heavily used in the wild.

-- 
Cheers,

David

