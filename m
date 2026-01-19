Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A5015CCF2E4
	for <linux-mm@archiver.kernel.org>; Mon, 19 Jan 2026 10:50:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EF0BA6B0173; Mon, 19 Jan 2026 05:50:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E74AC6B0174; Mon, 19 Jan 2026 05:50:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D56D36B0175; Mon, 19 Jan 2026 05:50:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BF23E6B0173
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 05:50:23 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 48C1B13B97F
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:50:23 +0000 (UTC)
X-FDA: 84348394326.07.CE69D2D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 65CA0160004
	for <linux-mm@kvack.org>; Mon, 19 Jan 2026 10:50:21 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mb3l4B93;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768819821; a=rsa-sha256;
	cv=none;
	b=kMB7Fs3+kYaqK0Y7y+2OAuJglWVrowKluSD7UMQaUzJk3RYHpDYhXZMIasq70zRZmdGtLU
	xd80qoAOkoLEmGjQSXDDXpo6yrkB6+oWvLJmY7QkjaRvZsduKNt8I095a9dyNEiRj3zY3V
	aQo0yqlseFbYeJBjX71a2L7l/JVvljw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Mb3l4B93;
	spf=pass (imf08.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768819821;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aby0MtNCaV1hH//B931TX6QnYXPXepNQv05Rr7TXu/8=;
	b=bs2/Z9Rh/PUHrm10KoOnuZqbvjk2puFSv7eeV88EAZWSPzZaTUuoZ5gZXLg2tsAKZh1hD3
	Ck4erX6cx0SF9JqKgyzaHJVJGynXbeP67uyeZYuPETl69sEwwdw/L4D6Z6PupyXhy21UGe
	dVCel2Y5JTQHPTGNipdrPDWe63vg9xI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 478A24384D;
	Mon, 19 Jan 2026 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFE8BC116C6;
	Mon, 19 Jan 2026 10:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768819820;
	bh=ZxzOJ4oQEra0siX2nuGmp1Odh2MhJ5xZ8jMUn/Ah4gk=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Mb3l4B93W7KHvJqwCHsHAebr5jOOyiZlGqBl9zbbC4g/ii3pn0ZDDm7Ohwcy8iKkR
	 gTGS3vWHE2icNR7vhXXMBH55mWFZVY2oYmaHSuBpUMugiX3mSQSOYZ3UDMyUfhDXi2
	 SFAbC6/OrsSAglWp32PITL/43LEBiO/H+MFhd2je0bCAYTtb9J3mCcHsaCFFp+bWH1
	 0KTTuF873zuO5A/mK7hDCJz5KtfnB5x9JPeePjkce7Yi8WkMCJx3vea8n9udJ4+3V1
	 SpsMmoCCpJmsyYXoy0+F4Mnjj2vXMgbo6rSvG1RVCt3cHsMsPUi48hhxYMlqX0Sps/
	 dywkRtRlSS3Bg==
Message-ID: <e2d76567-44f3-4372-9490-5cae91619125@kernel.org>
Date: Mon, 19 Jan 2026 11:50:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/8] selftests/mm: fix usage of FORCE_READ() in cow
 tests
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>
References: <20260107164842.3289559-1-kevin.brodsky@arm.com>
 <20260107164842.3289559-5-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <20260107164842.3289559-5-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 65CA0160004
X-Stat-Signature: keaf5fbio4nyszxj8gxcga7qwknmc6xe
X-Rspam-User: 
X-HE-Tag: 1768819821-114148
X-HE-Meta: U2FsdGVkX19L23mlKjyj6Sj0dubIRGyHclIYM/1oZbuyV5h/WDvPJ3oZJRTwFNyXI4YdxafiZi1OY6B8XR8qECCJ8aRygckdgGbM6DDk0HSQrnDxVd2mELQO/oN5GXv0sfHz0DITxZpHVKDdm80qdhH3buONa/CTdldK4dpty7PPRvolKZ9vleJPQCVy2tvRCU31TYCBeM/YhVd/0wC7bNXGQMRGoREr0qjnivsJVuaxASfxW0/0pXEf3hcf7PpmmCKBQdA5ZDi/dx9w1L74cv9oFbt36FZwNOfujeGCQsxMlryP0COEdZCqNfZvy00rflyx0Fk0XgDDJ/Twdln0RmQRWCUgAxOc7AXKTegF9yiFiATNLkz/+NuV16FCWjbBHvrkQhRGKTfjufZehknUKvFQBfZdpO4SHJzGZ2zUkZmV5WpLRp8LT3ZVX1ilzDaOnWVdk4ypoLsjAvYYtGCPjyaN/MFLI19plshv+sbe14qaPjydPcLZeGOEWtJHLzmUxq1XtMNiSXril4a9rdUJuDWmgT7Z/sLNHb0d7MSgCVtLi+gjYY+LZQHOvZ5Ao3atssaqn1mRMicsnrPV/LLickSlaNjLygsUX3tnfQcCj95Xs1RJCmL7gkQe95/RpTwJaH4Jz/jDDfzJ9PXKD2gr/BzIl/yvewNATIAXMxz/uPz+jtspm0Yswhm8isop8crDDoHpc6yN9MygSZJKbkjAwGgCEBtwgVIrw4puYsnfntZz5+/rBxDk8+7ds4nkxGRj4/yDSgkr9alicgCjgj9nFfh0h+1YNElKkUMvCK2iHTVV1KjKiMFFMcFb9kKtJ7aTdTcYpML0P065MOv2h0HUhoKwwL2ZVCkzW52FPgsNNgQDwR8ID4vlzEOu9GYuNFA2TmTWPRwMkLD5+aObzgpjS5cm7zREbqyz+/B3BKQPedaegIXdKEF8goHB1q7clacEp4VesJFrETZeakKE8Ng
 slLUbhbH
 3H7x6gnyqKyRl4NN06yOCiDKQN63+eku0OC11tA4DQOROPfzU5Wrqzt7x5x+0xYzzEfmXxHOLWSTMd90ujziD+kJtUkdPTosxf0qoMfNS7WKPpsEmE3wJEm+hXPKzUM0Zt2V4HX+EBH9jwOkf7yW6vTKjT9wjj2OwNYpYwCp3Y/TPz8UrXik5JOIkvtPADP+BmDroGDv8NGTyLfhfV82rL0BIXePiQUftrTNOWYCe6oxDTIge8vioBvmWXEjrLn0X6DQOhVAs1n0v+XQt0Y3ZO6ypVsANgkAOOvICDAUkuB152mF5g4CMHGxbcFmYfRkiq1flGnhHjzN/T+0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 17:48, Kevin Brodsky wrote:
> Commit 5bbc2b785e63 ("selftests/mm: fix FORCE_READ to read input
> value correctly") modified FORCE_READ() to take a value instead of a
> pointer. It also changed most of the call sites accordingly, but
> missed many of them in cow.c. In those cases, we ended up with the
> pointer itself being read, not the memory it points to.
> 
> No failure occurred as a result, so it looks like the tests work
> just fine without faulting in. However, the huge_zeropage tests
> explicitly check that pages are populated, so those became skipped.

Right, that's nasty! Thanks!

For all cases, we could probably just fail if the memory is not 
populated after FORCE_READ().

Would you have time to prepare a patch for that?

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

