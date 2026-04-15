Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 22DC0FA0C42
	for <linux-mm@archiver.kernel.org>; Wed, 15 Apr 2026 07:48:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 655D06B0092; Wed, 15 Apr 2026 03:48:26 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6067A6B0093; Wed, 15 Apr 2026 03:48:26 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F5496B0095; Wed, 15 Apr 2026 03:48:26 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 3BDB46B0092
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 03:48:26 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id CC905139983
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:48:25 +0000 (UTC)
X-FDA: 84660012570.28.375FF08
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id D50BE14000B
	for <linux-mm@kvack.org>; Wed, 15 Apr 2026 07:48:23 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OylqW79Y;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776239304;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hBOhrfHynSMIHdoG3xOQkKKYXeWcjumvpojR1GQgnGM=;
	b=LLemYnLIugha03ERKUugH4KzXNycbAYr3kKXIsz/uvJojBqoptAbpj2WolbNg1wqEnIL8Q
	HL6AZcyqpde7PmGaTX/MlLvO1mRU9cFQPKBKHn4yHdWSDQkb7M1MiEzKkFR5v/Jn/IUJc1
	CiAJZlGO5NE//cCmP1vaBHqUA3s0abU=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=OylqW79Y;
	spf=pass (imf23.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776239304; a=rsa-sha256;
	cv=none;
	b=kAE5+xpB6oTIhisbSs2rYBg89DvktKjTf4IgGOBakq5QDOy8wm4YaXL0hOfW8Wp6eT9Wlu
	zO/2jUKn0v+GR6ztRpAUJWXyjyZ9LhYaAn69hF0D4t361L2IAoY+JeJHl8xTUqLl4PHYmj
	62Eopig5Jd/d5itnOBjhyAsMjfmARVA=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A78054053C;
	Wed, 15 Apr 2026 07:48:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 485B9C19424;
	Wed, 15 Apr 2026 07:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776239302;
	bh=X9PVmsw3QwHMMy9ke6y1CiWGOMcox/1z4vp1JCsFSA0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=OylqW79YDrFJPsaXItlffPt6VPHv8BKPYZd34C/sXb9uJu8eh7qEa1AeVaqoNhORF
	 IW2BymuCz9YvLNSt+X5C5fDP/pP0xSiLYJijgEY4Bue8yE8RWo5uu+a0D+5hHIHEl/
	 yr+N/6Slc/KbYvvgtFS/hW8E9bzEk5joQIRN5e0wEMFQCRFm+R8zaPkiLUBL5pSXe6
	 9kNyY3DfRaDFxnAkgH7iGtrP8+ejS37vRN3MljtCf86ZJPHC3CoOlw2AwVAJ+OHkL2
	 8Vs9itBU+Xxy6f10eVxkR+wDrYsd5GDtJmsmmehQ4Cb6s3jvcS6VJGlAwDrNYSHkql
	 vr+UarYIp1dKQ==
Message-ID: <2e34b619-085f-4a9c-bb41-bc024fd40dd7@kernel.org>
Date: Wed, 15 Apr 2026 09:48:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] selftests/mm: Simplify byte pattern checking in
 mremap_test
To: Dev Jain <dev.jain@arm.com>, akpm@linux-foundation.org, shuah@kernel.org
Cc: ljs@kernel.org, Liam.Howlett@oracle.com, vbabka@kernel.org,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
 ryan.roberts@arm.com, anshuman.khandual@arm.com,
 Sarthak Sharma <sarthak.sharma@arm.com>
References: <20260415044509.579428-1-dev.jain@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260415044509.579428-1-dev.jain@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: D50BE14000B
X-Stat-Signature: qyu6tnp7zef18g3a7y34pw8ig6x1gew4
X-HE-Tag: 1776239303-696463
X-HE-Meta: U2FsdGVkX1+FLx33gkgnu/3zOvzRNN765/2+G/FWtGLYMeyblTHTS2SE6TQErGCyKR8uimFcwiC4PDIgOCHCl0n/AjywF2GE5EhPwiV8TIVNM0ok8lsTIISXZ2IxcxVNvUvSP+Tfv/zfHgRUXaDgoSrDZbmowZScu/dkfjclQnn4W4pP8SuRQRGt5Iekw/7HIHTU7hD6AjJs/Imi1V9XEbx5geyemPNWQ2DMFDY3ypqvoKhRlsVYWWxGUBHsbhFLT3q++BFnxVT9z/rl0bH5FMiCt7KwoZb/j26sMh7Yr0GbVHfqP6ZCZV7nOgcp5FDPh/pDauAvr4BWzEpcrolbj6OBdPo6JB46i5nVlNb4DnwHbCET1WiqVz/wAGzxRrRZOdrm1hTj0qivd3LVzMh8YQzdLJFZMcCIOCsKrPX0bAsH/itBV6GLs+Mq3X2xW3D/SpqgYhCXeRC1s7Q+cW0xE7Iff0ponpR0eYhpmPJ9hxhMp+lj7axxtJDNhxBBEzFjTggySJRwcV9Ho4nXEvLHpj+vHG+TRlaC7eJupZi5P6SRuHNnRzn1eEBIMEC9u3Dh7OWnjF5qMY1nctmzW8n7JIPdG8FU8mFsBOE1wR4aN2XdgxxaByX/lMK1mZ3lueoFtGab8Z7cXsbzLfDuXCWX3h+Bctj95SSK5N5AJZOrFyJKxAEryOcud4e1DWB5wijlZ8X0cBFWX2Zhp0SFLqlSd7GRFSlzcXYOZC6z6HbrEGdS2NOjJwSq2hoZXdpIjnTIRivbkHn0jC37isHB0TCq3v8VjWvkvozBboxWhEg4ZajI6VlPV80OhrRURTp7X9m4EbDg+3EHg/HrIyQn8RfEWO4bZXYEO4u+wH120VaoqoMzie8ItlJVt7INT0BTdw/mmJu3wLyFwFZj72/uZVGiR91Umfo7MVAQjtOShyDVB+Yr/4fG5BbEuXqOTJUKv7mjPS6t/A31L6vi3pvAd65
 Q8gzBtL2
 zTQGS4UoBPTar0124QyGYzM4vbDBRjyBKAkHkjOlrdLtPmrhi9+8Eft136d5cMFgE0lssp6gYICdY81AclxYkzzJ+tYaCJVfv4HMCVnwwVXZ44EIlPEM27JKQpozQtW05yRIJBbHtsNQLcaNcOXYDaCF3z0MQFvTHf2tHKXQIYZL4LJY2JMdZGhMvfbQ17e8wSmSiKqf+LBS1gas6CVMYJuIBYXQIj/x5Uax+b0h7FPyU0gtoY5Yqr87HTD/qB78gthfotAnjaIpRYhAcO1PirRqdg5JqZrUZiNCW2r2HkZ78ZVk01lJ9I0P9YnlQPbFZK4I6TxvfJIt7tdBAsGr9qziP9JkDt1qlJer0N1kLVxMPpG6SCoqUVsXyKEfoPgsmP8gMl2d/Bn7Kb9PWcSvn/aO7ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 4/15/26 06:45, Dev Jain wrote:
> The original version of mremap_test (7df666253f26: "kselftests: vm: add
> mremap tests") validated remapped contents byte-by-byte and printed a
> mismatch index in case the bytes streams didn't match. That was rather
> inefficient, especially also if the test passed.
> 
> Later, commit 7033c6cc9620 ("selftests/mm: mremap_test: optimize
> execution time from minutes to seconds using chunkwise memcmp") used
> memcmp() on bigger chunks, to fallback to byte-wise scanning to detect
> the problematic index only if it discovered a problem.
> 
> However, the implementation is overly complicated (e.g., get_sqrt() is
> currently not optimal) and we don't really have to report the exact
> index: whoever debugs the failing test can figure that out.
> 
> Let's simplify by just comparing both byte streams with memcmp() and not
> detecting the exact failed index.
> 
> Reported-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Tested-by: Sarthak Sharma <sarthak.sharma@arm.com>
> Signed-off-by: Dev Jain <dev.jain@arm.com>
> ---

I'll note something interesting: before 7033c6cc9620, we would check
random bytes in the stream. With 7033c6cc9620 we only check the first
threshold bytes IIUC.

That means, that we are not actually verifying most of the area at all
anymore?


The whole test options are extremely questionable:

$ ./mremap_test --help
./mremap_test: invalid option -- '-'
Usage: ./mremap_test [[-t <threshold_mb>] [-p <pattern_seed>]]
-t       only validate threshold_mb of the remapped region
         if 0 is supplied no threshold is used; all tests
         are run and remapped regions validated fully.
         The default threshold used is 4MB.
-p       provide a seed to generate the random pattern for
         validating the remapped region.

Nobody will ever set these parameters, really. And tests that test
different things each time they are run are not particularly helpful.

We should just remove all that and do something reasonable internally.

That is

a) Remove all the perf crap (ehm sorry, "advanced tests that don't
   belong here and that nobody ever runs") from this functional test

b) Remove all options from the test. Nobody ever uses them. They are
   stupid.

c) Remove any randomization from the test. There is no need for random
   patterns, just fill pages with increasing numbers.

d) Just always verify the whole regions. Without the rand() magic this
   will probably be just ... fairly fast?

-- 
Cheers,

David

