Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 31D0ACA5FCB
	for <linux-mm@archiver.kernel.org>; Thu,  1 Oct 2026 11:56:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3781B6B0093; Thu,  1 Oct 2026 07:56:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 3299B6B0095; Thu,  1 Oct 2026 07:56:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 218E76B0096; Thu,  1 Oct 2026 07:56:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id F040D6B0093
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 07:56:49 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 8B6D0A03B6
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:56:49 +0000 (UTC)
X-FDA: 85273905738.01.345DE6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf21.hostedemail.com (Postfix) with ESMTP id E06F11C0006
	for <linux-mm@kvack.org>; Thu,  1 Oct 2026 11:56:47 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQAftGTL;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790855807;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jwXy9Brx1hUXrdP0tPQxlxrwWDU3cUickTJZN9A11GI=;
	b=qPgjO/BgPzvpMJw9n/B/CFHl6wFNSniONq3t/Wa8OQYCWIRkMyNVHdxTzKDOC2Q8PesKln
	uXVPSV/StkzIzad9daMbnvepx6DyP0SYTfJPg3oHZXRAQiOfjZAkjWmhE0dSJWT0KHp7CN
	FrTeZIdpJEAxZCBxKYc5uAsK58y/WL0=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hQAftGTL;
	spf=pass (imf21.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790855807;
	b=5C7uifMzJhZU9R3cjOVhlv28CoRmYHjYtxpwOgy8tjP9DN3FDIJeuIlf2JVSqPw1xnSOko
	IADdNPZ7c7+mBLNnfKcSY4YzhICyHM2bZ/b+yt2lzC6zCTh82TSUIwD0S/nUAZxCtq3gsa
	4Fi4SI7nH9rsLwiMBKgeTQza3vRYJp8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 61A3C60A5E;
	Thu,  1 Oct 2026 11:56:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 809761F000FF;
	Thu,  1 Oct 2026 11:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790855807;
	bh=jwXy9Brx1hUXrdP0tPQxlxrwWDU3cUickTJZN9A11GI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=hQAftGTLbbZEnlvN6gOGfsufrGBy/6rO7VByoEAaOs1HKczt8hsuH8jRk2kU5SHrE
	 DzvsL1qqOl76GHK1bTG1v4A9JfoZhpWcAA2ZfdfWZOmLGUeD8wcRdC2Y8QK/RV/mcW
	 BNAkXcmRWw1+Tfi/V1QQ4G/xB+PDZ9OrfUuMwVRM2WoTMbrUfYr+brkveboCmYUiBt
	 g7bp4KdvSZxFyToaAEBTCE7hYR6S9s8Ec+ekHwL7X/eBPql9rogb1x4OpT13otBFc6
	 Yi6JvwKVWHqqjTJZXI8FvSVzVdmp4UTUAwadkuq8AfmJiOqy22WNBff8HUgbU/gSqI
	 3T2m/UNctXmTA==
Message-ID: <7ee37eb7-49d0-4c29-93c5-552c908e2077@kernel.org>
Date: Thu, 1 Oct 2026 13:56:39 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RESEND 7/9] selftests/mm: mremap_test: remove perf tests
 and timing
To: Sarthak Sharma <sarthak.sharma@arm.com>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>, "Liam R . Howlett"
 <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 Michal Hocko <mhocko@suse.com>, Shuah Khan <shuah@kernel.org>,
 John Hubbard <jhubbard@nvidia.com>, Kalesh Singh <kaleshsingh@google.com>,
 Anshuman Khandual <anshuman.khandual@arm.com>, Park Tae-sun
 <ts930@dgu.ac.kr>, linux-mm@kvack.org, linux-kselftest@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260924050009.19974-1-sarthak.sharma@arm.com>
 <20260924050009.19974-8-sarthak.sharma@arm.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260924050009.19974-8-sarthak.sharma@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: E06F11C0006
X-Stat-Signature: 3rjenzp94stx9oxb71iwj7gpomzykijp
X-Rspam-User: 
X-HE-Tag: 1790855807-319733
X-HE-Meta: U2FsdGVkX19Bn5JoJlTAYj93Fs9ls6zsHAG2o2TW72LwjFH54n0jiYS2w/EHD021rPun0GMu2ebyeBlh5OWc7AONRtyPjJl2v85TLp44AQd00lA2Q4p/52o0wNFjwn+PWcD3Y/YWYgz3B3Mg/f22+rKshG5ZWBwHo99zcUYOt26oS018xrIWa33mj9Y8BzLSWhIkwN7XUzxvItZdiYXi/YQW2HBEw+LMyOZVmCKQM6bVu+XatEZFdSL0XUBJ393Bub2PKlfoxUBv2XgXc+gKsjKXbbKEP2+ZNvtwWpUnSpj7vhCE0v4avWgeMbQt8BG7cXg0B1duxJCDL36jCyB/cZzvnT3eIZiaPNXS3giP7fuZyn41nK3y04cweCtlcyQKbzRPj/BEI7AXWw9WakgO87FKYepsliqneC1abpr1WD8gPAHeQR/UaZQC2Sj7/tw3DZczhn0XB0xjXkTbxVwK0MCOP5+/eMBS17xEbMkk+wVA0oaPq7TZ67oA1m3C7lm7zBn/knH5NQS6wfb7GpFwFKC07EztFsfH7C8psMc6tlmlyrrwXe03hJmYHdxV1vB0Qu27RgBJFwvvaSAYr1VQYOroJHtUNuL3nwEKAf33QTxROVKIs5nQf/9EaT8oN+C2keX6DB7h9FxDoJaorkI5RQ6DXfybSmtAH2qOIBj0Cuebvq6AlX8a2SO9JDZE+nQAdKnWnEKjCIFMJgGvkyXkyQh1FnhRU5lSh6ap4xPRdgpXSta+1eaNXE6oF4o2LZHQlRBzZr/05y816Tdi2z25NLJ8HyIJiLJ/Xb92HRCXqcFpsV54D6/PcVXa6DT7qt+8qb7zGmxTyYKVp/sZfVr0FMv7WKA52sXgxPVQ/BEPKu2AYyNqrlHnszFM6JSd8DQExQdcslt+D9tvDPjgqUlhMmxUkfVSVs2WjDR0nIAGRC0dCFU2K4/u1OF16IeEFShZ/0U3gugRsyNeWdPCHZt
 5PJ5cECx
 aRN6c3IXHt9aqqHXlbPGlYHCiM1n6jiiI9act++XiQ1RmKBYNZroE2ZO8XVb4Pi9BRIdQvE69WUClo+R7iN6slFn4J7QqsHXKzcQapoKZcUZvWgDv5U3nm1rASlIJBai3GoF3GC5C+Z01Un78kfnr+G9d9ufDOVgcIR+K5z1eqbYu9EJFiZOF+oRcYgvsZJfpNhQZEDbMwVM12TCOqGLM6GL61+z81nvhFWSVPdoYBAPZA68x3gpsG3f2DDDq2BVjsqEmB+7T7BL0QApPRHNKjnf5nGVOo7zBYlqcwSPDYnI57t2gtjOZxXZld+Z3zMnrFdd2FiR4YMTE3aOrhlLb18wpqm4u+o00nA6xDHr9KIzo2ptdiKelXVTsGx7+4G/flW6mkoqwpZVYjFY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/24/26 07:00, Sarthak Sharma wrote:
> mremap_test contains three perf tests that report the time
> taken to move 1GB mappings with different page table level
> alignments. Although they validate the remapped data,
> their main purpose it to report timing information. The
> recorded time also does not affect the test result. Also,
> they are skipped with the default validation threshold.
> 
> Remove these tests and the timing infrastructure from
> mremap_test.c. The regular tests continue to cover PUD
> and PMD aligned remaps.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Sarthak Sharma <sarthak.sharma@arm.com>
> ---

Thanks!

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

