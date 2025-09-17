Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 30F0ECAC599
	for <linux-mm@archiver.kernel.org>; Wed, 17 Sep 2025 13:26:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 659368E0006; Wed, 17 Sep 2025 09:26:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 60A0F8E0003; Wed, 17 Sep 2025 09:26:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F8EC8E0006; Wed, 17 Sep 2025 09:26:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 37CEF8E0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 09:26:31 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id D3C6113B484
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:26:30 +0000 (UTC)
X-FDA: 83898816540.23.2C17DA6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 13610A0003
	for <linux-mm@kvack.org>; Wed, 17 Sep 2025 13:26:28 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fyzzqaq1;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758115589;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lYejnLQQW4dtz6sD1C8ErIRCT8kfcNV3rxw8LWS/PSo=;
	b=OxJcZ/so4M3ksLjISR6AtX65/tNwAlvGZqo6VDvEpNnvEemXe4v0dlObXOAoLF7yb8uyFR
	owgAZDONeh1WXRbG2RW3ezKgsdl2gAwVmBKyNdfC3diRJ5PgnGWuDCVZ/Qrb/euuWw2SS1
	CU1lPhYLiOGpevCQs13ggI0NWFtrTZA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758115589; a=rsa-sha256;
	cv=none;
	b=bRFAxvuplfBTvdzobTb9kDxChifvFolHKMwUsrndrr+9OWkjUpwSCebGChX5b+FNOkrXMi
	exYOn+fXwyqM/hrrnCyMRqiFdrf0gwPgV9ip9X7BNgldiUVpnFXXksYKVvOURY44Y3cUOU
	HML4A/iy1oN675yG4rFVeBtulDuHtjw=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fyzzqaq1;
	spf=pass (imf25.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A210243C0C;
	Wed, 17 Sep 2025 13:26:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B5EBC4CEF0;
	Wed, 17 Sep 2025 13:26:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1758115587;
	bh=V7HgAwR8e8tHaVcJaPJfV58nE9V/qJQQN1kUxjKXpss=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fyzzqaq1wSWdrMvUjJY6Q8mC1TXbi8ZuTpl3Lz3wZq3GVXDFvew6jCkP8AXYWXvgB
	 v3f6qKVhT1BE1orrKlvZlrYFo3gehLDsv8q8s79Bg6852M9OSEVlSW87AROb1ApL0J
	 uil+MxoysSLaD1bs2lntCi/dzIhktmXgWQu0Q6V0loAgomgt07L2zjkmiQqP2q5AbR
	 rF9W6qdmUXXuBcQ/VKyeYFBnXwDStG9KONCUVf+F3lFragWgSGkWouCgFLIFAiH45C
	 ez/sh5E6l479QZ5yWfcqrNaCVn0BGq9ZWLdrK0bedHmT8UQ02l2pDwuN0bUl4AoYu6
	 LSiTwVKrAqqhQ==
From: SeongJae Park <sj@kernel.org>
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: SeongJae Park <sj@kernel.org>,
	ethangraham@google.com,
	glider@google.com,
	andreyknvl@gmail.com,
	andy@kernel.org,
	brauner@kernel.org,
	brendan.higgins@linux.dev,
	davem@davemloft.net,
	davidgow@google.com,
	dhowells@redhat.com,
	dvyukov@google.com,
	elver@google.com,
	herbert@gondor.apana.org.au,
	ignat@cloudflare.com,
	jack@suse.cz,
	jannh@google.com,
	johannes@sipsolutions.net,
	kasan-dev@googlegroups.com,
	kees@kernel.org,
	kunit-dev@googlegroups.com,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	lukas@wunner.de,
	rmoar@google.com,
	shuah@kernel.org,
	tarasmadan@google.com
Subject: Re: [PATCH v1 04/10] tools: add kfuzztest-bridge utility
Date: Wed, 17 Sep 2025 06:26:25 -0700
Message-Id: <20250917132625.61081-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250916090109.91132-5-ethan.w.s.graham@gmail.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: amow17sr85dk9ikuutgw4xfnpjsqcqyx
X-Rspam-User: 
X-Rspamd-Queue-Id: 13610A0003
X-Rspamd-Server: rspam10
X-HE-Tag: 1758115588-856776
X-HE-Meta: U2FsdGVkX19BtT0PnAWVl5iv3WVbU/OgWXbneT/fbxWetZm32pjf9LgaX3VM6sZi4vPBf22vqGEtBDpsQY4z7S5WyryEfZ7dhMKJiriFvtKnyhLb82qguvekrLyw+TB5BRMk0lEdG8chZeUSd9ju1HZtmFZCBdCNjxO5/VmZYe34Fo0g8aIW1vMtRFrC3RFyYoChmo7VQSiya679BMzG2LiVmRPtRpREuqWIxJph0/BW3iUrxDC5wU+K8fvag1i16EF8D7EUk7MG0zXvzposREEExw/PomX/UtrGnB7w1Z3X5+YeIZSJFdui4Wx/fkt1u4AikCg7yLVqwvUMeetnDGhqiZu/JyqmaNx+OJ+19kPE/SXIQ0GLcrYifYzm6+DEB8KaIhmO+t9xdaZpWjXmYVORIFqnpSP+7oIYb4am6pjbd9zuOy2b+a4oR7+2vdZVF1GpNAHSDZUkdZJM2vdm5syIsYpojGfBhC+heE2u3w4e6AALoDLG6VAZo6oUWEmxc1JKFfYkWHBcV1brsi7XJGD5/D1/869mSdAVRqtrxsxBTPb1jcmz6SgCo2tdId8549NGwsLZvWQWdorwFZTizi03E8htrUcj+sZRbMzQGoxr1LZsPdT1gINgzwFjJ01dWOMi8xAAviNUtr+wUXJQz3FZAhYLdSRTnQfssOL4XpCXkvY6iRnu7NKYU8gWafhI/Fi3vni9qiwJcS/ShPME1eFcR6xlcyvqkMah2DCrhT6iD4xic2BX0F3VqQZFEkZk9PBTlH2ptse5gvqxVt6pgzF7kJAr/w8Gh/kd+dGkgTnP+Dasx8IsSp2la3xBFIbu6izGQzBKMzWrqHJyUjP0JgN5JfbGDVs4mDBo2GHw+UIKbzTpmM5FmS4z14ws/sKK8yaGivodX6QcnHId/0iFIIVwuMBvJY1akqMuNty3ZsOL+buoBXYxW3xPKmHyHr0jIguFv9tDo03vu9z36uG
 TNb3xarB
 ZIre0B4VhLWnl2KjHfXUwyaX3zel+FADqGkogtKbTTrctdIT5PT+m90IJkBPSIB0q+CcbLlvuascunwgGznZEZTLd3XBWzR1LILq1FUph3VKs4p65OMIiP0zoUew7VWMPk/Hek8OOAmT823pZ5a79GaWObYXamIEUbfLWc+bCOdDzpEOeCuo3EG8lRIFYJdmLlBou97cl6iObW43eHt8985Dks7itBYEVKVPCqsWcCETJJiOdB58rV14ckIXWHJEiTNL8h0ZrPLHkVD/hE8tFxuogWzkSWM7fj/0af9oPscTDIgvR6fJhWZi7Ih/WNDNWxR17hDr30R/rLsw=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 16 Sep 2025 09:01:03 +0000 Ethan Graham <ethan.w.s.graham@gmail.com> wrote:

> From: Ethan Graham <ethangraham@google.com>
> 
> Introduce the kfuzztest-bridge tool, a userspace utility for sending
> structured inputs to KFuzzTest harnesses via debugfs.
> 
> The bridge takes a textual description of the expected input format, a
> file containing random bytes, and the name of the target fuzz test. It
> parses the description, encodes the random data into the binary format
> expected by the kernel, and writes the result to the corresponding
> debugfs entry.
> 
> This allows for both simple manual testing and integration with
> userspace fuzzing engines. For example, it can be used for smoke testing
> by providing data from /dev/urandom, or act as a bridge for blob-based
> fuzzers (e.g., AFL) to target KFuzzTest harnesses.

Thank you for doing this great work, Ethan!  I think this will be very helpful
for finding bugs of DAMON.

> 
> Signed-off-by: Ethan Graham <ethangraham@google.com>
> 
> ---
> v3:
> - Add additional context in header comment of kfuzztest-bridge/parser.c.
> - Add some missing NULL checks.
> - Refactor skip_whitespace() function in input_lexer.c.
> - Use ctx->minalign to compute correct region alignment, which is read
>   from /sys/kernel/debug/kfuzztest/_config/minalign.
> ---
> ---
>  tools/Makefile                        |  15 +-
>  tools/kfuzztest-bridge/.gitignore     |   2 +
>  tools/kfuzztest-bridge/Build          |   6 +
>  tools/kfuzztest-bridge/Makefile       |  48 ++++
>  tools/kfuzztest-bridge/bridge.c       | 103 +++++++
>  tools/kfuzztest-bridge/byte_buffer.c  |  87 ++++++
>  tools/kfuzztest-bridge/byte_buffer.h  |  31 ++
>  tools/kfuzztest-bridge/encoder.c      | 391 +++++++++++++++++++++++++
>  tools/kfuzztest-bridge/encoder.h      |  16 ++
>  tools/kfuzztest-bridge/input_lexer.c  | 242 ++++++++++++++++
>  tools/kfuzztest-bridge/input_lexer.h  |  57 ++++
>  tools/kfuzztest-bridge/input_parser.c | 395 ++++++++++++++++++++++++++
>  tools/kfuzztest-bridge/input_parser.h |  81 ++++++
>  tools/kfuzztest-bridge/rand_stream.c  |  77 +++++
>  tools/kfuzztest-bridge/rand_stream.h  |  57 ++++
>  15 files changed, 1602 insertions(+), 6 deletions(-)
>  create mode 100644 tools/kfuzztest-bridge/.gitignore
>  create mode 100644 tools/kfuzztest-bridge/Build
>  create mode 100644 tools/kfuzztest-bridge/Makefile
>  create mode 100644 tools/kfuzztest-bridge/bridge.c
>  create mode 100644 tools/kfuzztest-bridge/byte_buffer.c
>  create mode 100644 tools/kfuzztest-bridge/byte_buffer.h
>  create mode 100644 tools/kfuzztest-bridge/encoder.c
>  create mode 100644 tools/kfuzztest-bridge/encoder.h
>  create mode 100644 tools/kfuzztest-bridge/input_lexer.c
>  create mode 100644 tools/kfuzztest-bridge/input_lexer.h
>  create mode 100644 tools/kfuzztest-bridge/input_parser.c
>  create mode 100644 tools/kfuzztest-bridge/input_parser.h
>  create mode 100644 tools/kfuzztest-bridge/rand_stream.c
>  create mode 100644 tools/kfuzztest-bridge/rand_stream.h

I'm wondering if it makes sense to put the files under tools/testing/ like
kselftest and kunit.


Thanks,
SJ

[...]

