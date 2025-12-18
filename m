Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD7FED68BEB
	for <linux-mm@archiver.kernel.org>; Thu, 18 Dec 2025 08:07:24 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 067E96B008C; Thu, 18 Dec 2025 03:07:24 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0159B6B0092; Thu, 18 Dec 2025 03:07:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E84296B0093; Thu, 18 Dec 2025 03:07:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id D9C6E6B008C
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 03:07:23 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 28E66160DFF
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:07:22 +0000 (UTC)
X-FDA: 84231861924.04.50B7969
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id 8D16B120006
	for <linux-mm@kvack.org>; Thu, 18 Dec 2025 08:07:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AoK3iru5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766045240; a=rsa-sha256;
	cv=none;
	b=NbHnFgByZo3Sq3Qf0SPLYCvu9mkulIq1y9WnvdQDAKMthueCkf7zIiYqTWb6MqexAtTnh9
	s8MLTqyTBOg/ftfViUU3rBpG0+cPDp8Tjq8cPCk5ly80wPetXh6Q8D2Qwrtw+w7KXZ2qc2
	hPb60tK9DqYhd+LWkTEasUGAdTYV95k=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=AoK3iru5;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766045240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Qk2v1JGoxORmqNs8YsD9kp6BKjUA4gUU6aTxfIWpYZo=;
	b=iCetZ7V90vdjEkLZyuwH+BBo3KR3viM5HZciDQdJrYwBvccA6no+1xx4HhHbepylJK0cSU
	RIl5JKsChuGVnaU2R9HbRNhHAXaJzTYumEMKLVXl7lZ8zXyla1Ai46PH40fWursux7qldy
	y4R2HavnEKeJ9qJmqVXrvuoa1A+GQ6w=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3DD164334D;
	Thu, 18 Dec 2025 08:07:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC6BC4CEFB;
	Thu, 18 Dec 2025 08:07:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766045239;
	bh=7dWSzjDl2OvquTZJCFjqZOIC5C2h/Vvu8Kmi5EBUTyE=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AoK3iru57iwXJUgXmzUrESwqpHMKFDM63dAp+QrzgS3KYicSmPljHFlfikA+sY5nZ
	 5ambzJOY0arKaW1/GXZiqr6AxFSBrYt4QkbZ1ZW622jFgzzWD/0OR8AtyFPJN3Hs6f
	 yq9JACWR866aJJKGmoS3/cYhQmKrjssqZBeMLwmvjHoz0g7+auocmIGbYv6kzukjsc
	 mzHClOoehR9zgBen2HPbx2uoV+I6ctpKTc+RNJC9Np7H5l6KnoOWp4HokkQNUlaai7
	 NU8l7kEViAS1LpkuYVd2gpmnQCRzvmTSZjpvqU9/OWcB2NH3zN6HQGobrxd/o1CQ6A
	 ycoRTqOsttC2A==
Message-ID: <7d59597c-5a32-4c97-93ef-feb8dc15b674@kernel.org>
Date: Thu, 18 Dec 2025 09:07:14 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] selftests/mm: fix exit code in pagemap_ioctl
To: Kevin Brodsky <kevin.brodsky@arm.com>, linux-mm@kvack.org,
 linux-kselftest@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, Mark Brown
 <broonie@kernel.org>, Ryan Roberts <ryan.roberts@arm.com>,
 Shuah Khan <shuah@kernel.org>, Usama Anjum <Usama.Anjum@arm.com>
References: <20251216142633.2401447-1-kevin.brodsky@arm.com>
 <20251216142633.2401447-5-kevin.brodsky@arm.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <20251216142633.2401447-5-kevin.brodsky@arm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 8D16B120006
X-Stat-Signature: w9whtmz5wrkjrqadi3exzp6hrjm9nsrn
X-HE-Tag: 1766045240-863092
X-HE-Meta: U2FsdGVkX18nM2Y4+1z3K9Mqa4RSMo9tDBNgJ0VGX04GL+fSViEmEndFtC9Ce1YiKg7+aiYIbUg4zslg8+4lyFcKMrvN/Mk1tKc/kv4TVV/1WQCHa8fg7SWqIj92MIN6Bvc+RKNLZZMlO6nt97DtH2hMkUUDhjVpSEJj0CE4dn7CDuuUxwZrcRQ/SFLjhMgiqb/F6qx1pN/eaQhbye91GjRziW1iB0jF7lR164RqMPNRfeTIn8Ga6CAkkc0sZP1oFz9jgR+RKMy8G2WriATTPW/t15ffC3QLpdKPuQZ4QixdcicoK43fc5Rq5oYtZTDUT++1RvZRRdoDYsVB8VofMftOWPueEjHKF7lVeRgV1t+JDByqKQc6mPLIALOumGXH/48FhTfQfgIr/XrtUQRGU0Y94VWONXbBmblCqHAWQBQXMGk4G9afKltxtIZgzgV3RxB6gXPCtqbb09xwgwg6KbO0h4n7dlt5p4Yx81l1rw+p8H5bLMT1ZmJOVx2zw/9DEvgTa6yKt1AiZDNiB+73BpYm/ldcAKuQNTnd/VnX/4a1fLbMzHPddlZwsoFIp9ErNPJKZbOOPnB/GE0/r86HMwmg37GkGDM6cDcbBC/hsfNdX186F1RFnEEV3q7iXTTf3xy6/1li23VwuVhuWpUZEISOFnz2FkN9uzYF/8ouCl9N4KjGvziMdjTBygkXD3Q6cW/QzSAP6hx7KXK6Ij4SxXfwEhiuYabPe/gBWHAHM+JfSbZi+OUtWnF2WqJO5jf2j9jImPiNFtlXKisaSeYVJF35ayPZKpXn6L0zUvS4R7/4DLCkS4bsjwK/nl1tfZ5LF2bGC1jyEOGXeO991H6CNjrUAPap5rhK3fc8Ln3lDTzLmdnvZyFEQZ22R3YULwIOpWy8N3q3iluHJ6kBn3d+wjSoPFyiMeAERZ55rtwE6AEm2S02ViI5GYveqYTZEAY3bSLkIQGpO9xiBRWi6rk
 RPVB35/2
 fkB688RtcVfjkvuU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 12/16/25 15:26, Kevin Brodsky wrote:
> pagemap_ioctl always reports success, whether the tests succeeded or
> not. Call ksft_finished() to report the right status.
> 
> While at it also fix the exit code in unexpected situations:
> 
> - Report SKIP if userfaultfd isn't available (in line with other
>    tests)
> 
> - Report FAIL if we failed to open /proc/self/pagemap (returning
>    -EINVAL from main() is meaningless)
> 
> Cc: Usama Anjum <Usama.Anjum@arm.com>
> Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
> ---

Fine for me to fix return handling for the overall test in a single patch

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

