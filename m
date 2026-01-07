Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB18DD0D171
	for <linux-mm@archiver.kernel.org>; Wed,  7 Jan 2026 21:52:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1D3FB6B0088; Wed,  7 Jan 2026 16:52:40 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1583A6B0093; Wed,  7 Jan 2026 16:52:40 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 039486B0095; Wed,  7 Jan 2026 16:52:39 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E6A2C6B0088
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 16:52:39 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id B47EFC0594
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:52:39 +0000 (UTC)
X-FDA: 84306517638.20.8C1C4B0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id F2EFB1A0004
	for <linux-mm@kvack.org>; Wed,  7 Jan 2026 21:52:37 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kzuQX9u/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1767822758; a=rsa-sha256;
	cv=none;
	b=HdB+eOEfAve7s4G/Foat1eVoITzNoxrLU8SWGN5lTQzTAl9E0OzvYiQ8du3bWGoaoFNAmQ
	wx5eNn3NLJ1c1ozaW+VPh1uYSKwRFQzVyUtcITf8bIZj/yHZJfRjPxkV0vB6VN2Z7/46Om
	Qk9YfFlxD4+SXm1xr1KBKCZmb+omu1s=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="kzuQX9u/";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1767822758;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hnvGIdzGyG3Yy1ao5VcTTPnTvVjJvcXej9UWaTrDP6c=;
	b=SV8KbODUG2bIPdWQMqgYwCb0fJux9gtQGMNSZty3/gkzjJnOg/CkUKdMJQHeGuOmr2w3im
	qTOxgEbP3vKkJ5wENc6FZDrqKgHDKc/+E7LfZa0zfuQNaXEBZ7NWygynE3x6mMMtOYyg47
	5SoKfOCYLMc1clhLyShbMeA3FjYByJ0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 510BD6000A;
	Wed,  7 Jan 2026 21:52:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67FEFC4CEF1;
	Wed,  7 Jan 2026 21:52:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1767822757;
	bh=RFll13xZ/a5vC1iqrVrPAUqu5AGsBMq8qegGaJ9IV3o=;
	h=Date:Subject:To:References:From:Cc:In-Reply-To:From;
	b=kzuQX9u/cZr0QC7rtGsqNU2g8oz3UN556bmK7px+7qe0KfaGafNnQSF2uKAobn4gn
	 c5wZGdvUbvGUo9i0PJ3pb1Bj4HrPQQ4PEwKvP9Qggas/f/nKSy4vViL0IyEafDPObU
	 rnf1Pb4C7Esc2PZ8u0sPSQ55JMiuG17wzQELDBoPvUpPIwzVBGM79vvR6r4bnefHE6
	 OWCYAEgt2UBlH3gS3ZEI0/gUWw6yBU54EbRSfqP0iAGFDfj+SH+t4h9yJf817nmLer
	 RgOaozskdLOCIerGzgT9YGtBPGAk12Q9ngyJlLnGMo2Oh+kvrY1G55YhWpgdRuFFzN
	 Cdk8bCTPZqElA==
Message-ID: <7737563a-c2b8-4e9e-ac18-3551ed9d1a33@kernel.org>
Date: Wed, 7 Jan 2026 22:52:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [Invitation] bi-weekly guest_memfd upstream call on 2025-12-04
To: dan.j.williams@intel.com,
 "linux-coco@lists.linux.dev" <linux-coco@lists.linux.dev>,
 "linux-mm@kvack.org" <linux-mm@kvack.org>, KVM <kvm@vger.kernel.org>
References: <66c32ad4-a59a-425e-8a00-bcfb918e7559@kernel.org>
 <695ec54cf5c3_875d1009d@dwillia2-mobl4.notmuch>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Cc: Ackerley Tng <ackerleytng@google.com>
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <695ec54cf5c3_875d1009d@dwillia2-mobl4.notmuch>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F2EFB1A0004
X-Stat-Signature: mmneyjkibr9nsp7k43y1jxzi1wey4tdt
X-HE-Tag: 1767822757-772540
X-HE-Meta: U2FsdGVkX1/8oyfc2zeZ9zcKZt5q5Vzh81jUtXM90GsJauue7SVQy1E19YCvw8XkCV5NtPuMnEkuuYvTPGz3YVitzSZJpFBufB8JsoE3zZWwMIGtGmr4SLszVqycWVOgacxZ79V5ZxQl/mjhVu/IKwMG1txCIpUEjWxjZGFBggjOd+WByXLVy6SFzw98Kr+wNV7Jq3gdPpn/l5cgqtfnMIOMOr4O8N4Y3fcpXj4fdtku9PHHwCOZm3vvrYE3gsqU7zK0M51dyPSajU/J2IJTMeajuIT9wAfDwKq8N3cb9/IoTm93XOKPNwyVC6lozgFWEz92M1QdQMagJtrlfRctIPSHVRczWxjeADIoIWH0WitRNJaDCTDq9cVIEFsksFIDKDknmiEYn/yKziFv1HollH+DDwM5A6zanf315M3YdadnVXS1HWKvCFfgoy1C/YW2qyzqHOhGfmbwHGNl3bfhwZCdYJ2/vfl+En2Q1QG5w5wN/f1wWGzWkfAdwc5TZMRQL/KVNjChm7u1fumn5kdg+hAoBHleDqagDNCplhM7t25Eg+ORRl85qfMUjwtNtCjUTSH7SCrotFDvpGhkcU3v1mnt7C8uQt2sf+qUYGfpeH0R9rUq4WK+7j4aW4HhRXGAt7s9JgOQfrxpxgE7ZqXSR7BxlwoHDlFDGUFy3KAUovy6NBUsT7uXYDQqRm14on8+nTdAOx4MTrKBuAfzekg8IQ2TASXIf+fLO2ddJDXjz/mROLj0Bdb+fdYJ6yM7IPeysl/4QK5gr3/ipMMAFhs0U0E6aNQstaPfWjudCric8Uylx4AgpJmAe7CwlRQPQThgkg4ZuFa4+sf0MB2Cpe5v6c0MKsPzOiAY9zei+wUYzuYBvz+WbijeoLVgX5sZrkZaogh5CLob4T0ufHwD5qW09DhhObObQH0PGD9kjpFPaNn5bqu6M38fiDQKw7snt6ZVoT2eI7N6VF8Dfke3Mlm
 V5yh5n/W
 4sgX6uIoDCgxt4lsjH9vUYP6vkuQWidxRQ4g5ZHPj5J6seBBiuewNoIT2WSAiGLTJJzT6JoEkMKX1K51dBVi/SXYW5F9uDIkfBN3AknDvx0cfM9TYFSyA/L4neWfEJoV3q35J7ABKyd7Ow0WaWm9oBGq2zXLDspvBUNqdx0vHigdI1cLbhYFkmETdJSBRlfprJfktWWyfIjSEnUAzlpi6YOaWzRHWPsv/b2wuwgFlgUUUJRUkJjlRos3Lxayo5QSPTyoS4R6+g4dt5d/pRlQ4x34UClxFif4iawxqt96MYy4YZMJleSs9SW5BhRPm4Bkm0g2EnQm1WyrF0IGb5JUyKdZkbectqjhPEF3IaianxRQVcuo=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/7/26 21:42, dan.j.williams@intel.com wrote:
> David Hildenbrand (Red Hat) wrote:
> [..]
>> This might be the last meeting this year: I will be traveling for LPC on
>> December 11 and December 18. Then, Christmas is already around the
>> corner and we'll skip the one on December 25. So we'll probably have our
>> next meeting then on January 8.
> 
> Hi David,

Hi Dan!

> 
> Great seeing you at LPC! 

Absolutely :)

> Can I grab some time on the agenda to
> brainstorm the next level of detail on the topic I briefly ran by you in
> the hallway track? I.e. is there a path to decouple dependencies and
> land some of the low level huge page support upstream while the
> guest_memfd reworks for in place conversion and hugetlbfs backing
> continue to mature?

Yes, Ackerley already added that to the meeting agenda :)

> 
> As you said this at a minimum needs to be crippled / not production
> worthy to maintain focus and momentum on the guest_memfd rework
> completion. The observation that shifted my thinking is that, given the
> timelines and remaining work, there are solid steps that the low level
> implementations can be landing and maturing in advance of that
> integration. All net progress for upstream.

Right, I think we're good as long as we don't start splitting folios on 
partial truncation. That is: only allow truncation in THP granularity.

I might not be around tomorrow and Ackerley will likely lead the 
meeting. I'll send out a reminder mail now that I realize I haven't ...

-- 
Cheers

David

