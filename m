Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81096CCF2D3
	for <linux-mm@archiver.kernel.org>; Mon, 19 Oct 2026 04:59:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6DCEB6B011E; Mon, 19 Oct 2026 00:59:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4666B0120; Mon, 19 Oct 2026 00:59:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5C94B6B0121; Mon, 19 Oct 2026 00:59:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 3E7D56B011E
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 00:59:30 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4646916068B
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:59:28 +0000 (UTC)
X-FDA: 85338172416.25.4EBC7C3
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf20.hostedemail.com (Postfix) with ESMTP id 6DDF01C0009
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 04:59:26 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OoKVnnAW;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792385966;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=WAr8yxCgbI96KITmlLhJVRMX6I8A79vMCHMCwNS6Oe8=;
	b=KYjLWWYRv7RtmIJ8kG91qBxnjd+hTQ643ALg/wKIhueMuwJaT3W/xOC/HQykf07XZNyQZp
	NVa9QKd2PG40kOWnsMnwzdS4CBD810pdsu/y6e9dEz2SnyG5Bdmmn7Xlm+hFIOiijV1eqt
	yWod9NqmniXgQx5TXxHCIFjn+QSz700=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792385966;
	b=6ab8CBVgSl8wWnDqu5NZ7L312zfdbSSkHtWT1Lllltz58EiyZBxCkq44c1I+nVNM2CGjdx
	Rcs1XOSqcVRuYraAUqdRPwyTjwReJqldjUjfSey7gRzAtLazu1SX3LOTLFOY43w9SF4Axw
	V6fVV7jeb+avs5UFcO3OxnN0PSw4jVE=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=OoKVnnAW;
	spf=pass (imf20.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 5860A1476;
	Sun, 18 Oct 2026 21:59:22 -0700 (PDT)
Received: from [10.164.19.84] (a081061.arm.com [10.164.19.84])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 957D23F673;
	Sun, 18 Oct 2026 21:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1792385965; bh=wSKR26ILxURLnFx2+QlKpgJeVV02uGi/OJ246XfSBBk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OoKVnnAW5h6G8pIZOaIkk+8Ax2CDh6YIjtCquL38N20RtIps5AAUG0wRkrAL0y2Ou
	 jIOksQFm78zNWVnU9EZILHAlzRG9ZcXG32/md25shOTNxjWF8OPEXrmyFn8rLW1en7
	 CwIROAczVQTA1z3R0zAmIOSecWfJq5EwNW1lCT+U=
Message-ID: <ad987ce7-1aa1-405e-a647-456c0c2283f6@arm.com>
Date: Mon, 19 Oct 2026 10:29:18 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/8] selftests/mm: add MADV_COLD and MADV_PAGEOUT contract
 tests
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org, linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261014175756.2035176-1-gourry@gourry.net>
 <20261014175756.2035176-2-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261014175756.2035176-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 6DDF01C0009
X-Rspamd-Server: rspam08
X-Stat-Signature: pehxf9xh8y8rj3cfbcjdz4cp77gepkhw
X-HE-Tag: 1792385966-76220
X-HE-Meta: U2FsdGVkX196bD6/9l+CFKOApQJqBDzZmSGByW1GSLhKmoD8/XQyKeYxQdNKkY9sqdgr8W+qWS4f1mkCpvljgWdNdVZMhUBWvSJc94ULqAsTjzUO6u3FQI3IfQU4aEQd0QecErvvLLVICsEIZfTGVCfZM3gYOX1rkBjGnZThTUHwL4vXNmM6clNZ712bdOrKgNvr9oniHfnPU7/zNtntyX07QDwWO/EIDsvMrGY9Xai9+uVirpSDCIbBvuS+myeqOMVeLrVWuvZO0rcFqxVlO6OA7zZjeEgXqnt+ocNGYFX1JCtTOg5ll6XLcUgHW9FLujg/EAmWDfUrhNVM5fwOcmCvJr4J3HNa5WmUg4CyCmgzUOBMb+qxVEATPg9XGTEIDz3iBzIE6ZOsrywgEN8yTbYNktgIaMNgmloi9OjgoA45/Pw3UV7kTz98vJ0aMFt+ov+FnJrjaRAIuors2S9GVHQYmoNVXRwPKT0v9ak3wr22zJwul8JYjhpwV9u7Rgv5OzrDxra7ffbEWJqk/Rk8+Stw4cUbLRF71Z6r7ZlILOdWZF4yioNFMOq2MRlgYWddRNr0HbQPRj1peGg1y2GG44fcllCzsgjchYHJqsvuxgh3ltBgL7ccOHGj3f3neQEHCliETVSfYtSEZHvpbZ8/NeYR1oVlzWcmzMOlHqAYbrJNCK+uL45sZ6hcnFXTXUxAQWFs6052LfuIOCb/1gX5/RP1TLOgi9NNY1949vQVditTWln7soeGVIRTyqfzTxPyJnJbR4cR9NpXc2CjL+3EsCk+8EDYarh+NW11JASbS1uRPVLJteD2bwX7jFkpYpxT4NKXKJfP9M7+8A95cfYuU/6eFWC2LuJSwuDbTFgKGf1RtctEupCWAF9RkbpNzQ926i8cDNpf4l1d38CS6bB1KGZqOiphFTcBjpiGxY9j35HliC6zcfbtgJ/f8T/C2TelcJ8M5LLkitUE+OFeFbq
 FZWb+Wcy
 SKOZkjBdQ+fErFm72mXqkPQfqBKqjVVvRaohelWYS3PdjFIp3qBS1u0F7HtAzCwGD93y/RugnZSYHlug5JOwUobbkPJ0pfEDHy+xfV0RwkOtz+s80A7nB/AByaZ/mu2hx0aeTGegXDXpDyi55KSQFEoMQzGXN9jgHzWt8sur+emWqFy7MOM+0asAm9bQbzV61wRFp5HPOc1FAAjfmEISnghZoAsHZ34bSiV57FZS/j9buR6yLO8VO7wqTl6/nm412P1p+tpgH0Hvq2dr3tiButQBN+8ELeu3JB2eVh733fheQ+FNcBCEY7RLIQkSmv/3QIRz2B0WCtt/sVLNY84mD87/KfHPNRVDiqKOWMF19hrz9vXbW/vlUsOYkV3OJzKOvMxoNOvfYk6qrkMACA8HzhVCc9w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 10/14/26 11:27 PM, Gregory Price (Meta) wrote:
> MADV_COLD and MADV_PAGEOUT share a page-table walker covering ordinary
> PTEs, PTE-mapped large folios and huge PMDs. Existing selftests provide
> little coverage of its range, folio-state and permission decisions.
> 
> Add a kselftest harness test for both hints, starting with the most basic
> behavior userspace relies on: MADV_COLD neither populates a PTE hole nor
> faults a swapped page back in, and neither hint may be applied to a locked
> VMA.
> 
> The swapped-page test skips when swap is unavailable.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
>  tools/testing/selftests/mm/Makefile        |   2 +
>  tools/testing/selftests/mm/ksft_madvise.sh |   4 +
>  tools/testing/selftests/mm/madvise.c       | 134 +++++++++++++++++++++
>  tools/testing/selftests/mm/run_vmtests.sh  |   5 +
>  4 files changed, 145 insertions(+)
>  create mode 100755 tools/testing/selftests/mm/ksft_madvise.sh
>  create mode 100644 tools/testing/selftests/mm/madvise.c

I am not sure if this test needs to be called madvise. I think this
might be a too broad name for a test for MADV_COLD and MADV_PAGEOUT. Can
we maybe call it something like madv_cold_pageout (similar to
madv_populate already present)?

Apart from that, it LGTM.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>


