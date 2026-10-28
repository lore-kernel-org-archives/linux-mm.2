Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 321DB606A31D
	for <linux-mm@archiver.kernel.org>; Wed, 28 Oct 2026 11:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=arm.com header.i=@arm.com header.a=rsa-sha256 header.s=foss header.b=CCm9AuOB
Received: by kanga.kvack.org (Postfix)
	id F07AB6B05B0; Wed, 28 Oct 2026 07:22:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB8576B05B1; Wed, 28 Oct 2026 07:22:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA6C16B05B2; Wed, 28 Oct 2026 07:22:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B63E66B05B0
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 07:22:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 34A15A0CA1
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:22:56 +0000 (UTC)
X-FDA: 85371797952.29.57CB623
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf21.hostedemail.com (Postfix) with ESMTP id 4FAF91C000D
	for <linux-mm@kvack.org>; Wed, 28 Oct 2026 11:22:54 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CCm9AuOB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793186574;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n5pury5YV9GvH2clnXbdOyRZC5fJ6UftyKNGGJhyG/M=;
	b=rC1DOCXRzUeZXULQjMQkjh/uO/0ictp/0CsyMXF2FcIRnemnqoV2+WP1hr4IYRQehGb1v0
	QCv4srGnsxhmkC+TYUs9wWYT8nEB18xyQmBZ3LMHYd2vVCAIAG9wwaw1X+39XJrqeNjkFx
	D1wR2qXFuOlEDPQEKIaplp6iqExc2xU=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=arm.com header.s=foss header.b=CCm9AuOB;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf21.hostedemail.com: domain of sarthak.sharma@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=sarthak.sharma@arm.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793186574;
	b=MVWNyHZwYoTVK9nFrMIWLm6AssTOyMBHVrzq42q2OAvW7CeqBh//OWC/buxxlWSslm6SoS
	XAg+eq1nA1mJc1OnLExjGEndGhL1viefEE4l+TeZjoABX6uSS4sRkxm9iSgmsl17Ls6xmK
	3huKjDmGe8/BThon1EmPzKrCZ5HtQ+c=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 16D2416A3;
	Wed, 28 Oct 2026 04:22:50 -0700 (PDT)
Received: from [192.168.29.156] (usa-sjc-mx-foss1.foss.arm.com [172.31.20.19])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id A0AA63F673;
	Wed, 28 Oct 2026 04:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=arm.com; s=foss;
	t=1793186573; bh=43ADtVMuUF6FIB096peM5yM5+HordZTKhuRDK9S1TAs=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=CCm9AuOBTD2xEHiF6xW5BCJJq46KaABx0gQ/th+q+4PJG5mBgBzJnVLRoB6jueIfJ
	 AAUFydZevToDAZdtOtsMo44LWIYuSAXr82n92foLrER00R5EZlJ12NZo1QsvzOHJWT
	 hpO3X5IKKOFnwXn0BNOZY47Y8nSttk9lCEFNLXwk=
Message-ID: <726ac203-7ee1-41d1-a9f3-7322c7528971@arm.com>
Date: Wed, 28 Oct 2026 16:52:44 +0530
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/7] selftests/mm: add MADV_COLD and MADV_PAGEOUT
 contract tests
To: "Gregory Price (Meta)" <gourry@gourry.net>,
 linux-kselftest@vger.kernel.org
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com,
 akpm@linux-foundation.org, david@kernel.org, ljs@kernel.org,
 liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com,
 mhocko@suse.com, shuah@kernel.org
References: <20261019171206.3331374-1-gourry@gourry.net>
 <20261019171206.3331374-2-gourry@gourry.net>
From: Sarthak Sharma <sarthak.sharma@arm.com>
Content-Language: en-US
In-Reply-To: <20261019171206.3331374-2-gourry@gourry.net>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 4FAF91C000D
X-Stat-Signature: ewwtnj5kc8hw8njwesr57pdmq988rcz1
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793186574-998145
X-HE-Meta: U2FsdGVkX1814eM2/dgR4PwWYCbGMwF50UTaJbeZ9u5zYiTJE1/rATcE3dc5YXOVqNFr9Pu+Ro+t+OdVh60XjTYbDzlk7tCDxh8nWXBYPRzvDHsy1dwqdnuvjIZVivqsswpqCfCmz1GepNyEVMPWNxgi3sNKkDpYS++aq1oO36Xb+++YxI2i///JnG1f1GbqXghM9ZjuNSNpRMkc9MVmX+H3LsqoKSChyrVZrp//dPsiFw1IhzSpYmDW8Ssk9vXRbqIBz5+4pFlazl7omVs6rwb62Aw8brD37M+R22BO2kkS7psEhrEbNb/nhcV6IOsCzEkdfD8tT09FSDn6w+m0kQ3lviYhK4smOh6bMAXasVuVgRyF3qmMH8CM0OBQNc+XkKg2826nQUB2MowLCQqY05Fpj4a0mL0OMZ4FHX7Zv2RtDf6QZMhcUY0mrDwf9vjiIzmqKBcykul3hV0sZskKA/6tlbvSxE+HQDq4CVhdOCAqQmXle/X+sfnIgAGvAhkIedZmwQasH4Na0IdZjbKnHxtBW/Zw4p1K4s8GGhsnwTHBHz7YeSNKWAi36gH/M+edq1Jx+2LY5EGq1Ei6FfuZE6+ifkL/EtEUk+SWZZZMNJQmB3x7oNZzNeYdU0NQjN1eNdA0Irp8csee6DqoIqqJbFzjP/MRCvNZVLvAJ2XHE2qGEsPK1+n0+WRh/5tq5RUfLVIydlTcABpQhIhG13LOcxvdYwDB9+ReaSNdaICEbpwAcR7cdMK0CujWgi46Iz3KOm//xSuF71SaetU/rfP2XkhKB9HGSLEcV15b0g+zT3py5j9JwCEtyjRWxEhcyn1fBbEM3Mlq7zjx8yuRImBKZjbECKK1Xx0JTC5/sGfk8lQkxJoX78bdR5KPnFZTtPUTSmu0rXXerSArcjNI92qlcdosIPbNLMi47PJt1ZWWpn0i74B6PP5SKN+scKqnNkRaKEWHgJg0kb8X7akciPa
 xhyhjcpn
 oUbmgFx/6cFR42EYlYswde9NF7X++p4sCNF1GcVPmdqnR6EUOv/SIh3XaTjJRzOZQZgYoTA8UwZ6hpi9FiNaQmHeL9gmEtHZAry+EqZX+rPanrXNqg/vgBqoMH8N2TPI6m0ABiBWN7BCHCqrtEkE5woWkV9rOuNQP9oivlv0QtGld6ALyyDZe9pbvF0ttGN1h4JfX6925GUsiKcGOMeobgH8Y29txfLBL+GjPGaiALTZiOcIwxwj5wLvXiIWAHIjpV+lk3dfT+IH4g5PNyPVaOJKdaY9kdcS1BXnrraFyn1kZpSeFlf1aE6VyvqqVWd0e3LrxHnOYWZMymwIVNFhjj94KSvpRh57yr4FQBaI64IvMduIRhuKpqTAdWM0AK+CC/+yiLOFUUbJoBhjM0MdrVDvXkg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1



On 10/19/26 10:42 PM, Gregory Price (Meta) wrote:
> MADV_COLD and MADV_PAGEOUT share a page-table walker covering ordinary
> PTEs, PTE-mapped large folios and huge PMDs. Existing selftests use
> MADV_PAGEOUT mostly to swap memory out for other tests, and check only
> special mappings (PFNMAP, guard regions, droppable memory), not the
> walker's range, folio and permission handling.
> 
> Add a kselftest harness test for both hints, starting with the most basic
> behavior userspace relies on: neither hint populates a PTE hole or faults
> a swapped page back in, and neither may be applied to a locked VMA.
> 
> Before running the tests, pin the process to the CPU it starts on,
> so that the LRU batch MADV_COLD and MADV_PAGEOUT drain holds the
> folios a test faulted in.
> 
> Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
> ---
> v3: Dropped Sarthak's Reviewed-by from v2 1/8 and 2/8, which are folded
> here, since this patch now adds main() with the CPU pinning and the
> one-time reclaim check, and the swapped-page tests fail rather than skip.
Thanks for changing the name of the selftest. Adding the swap check once
in main() also looks good.

Reviewed-by: Sarthak Sharma <sarthak.sharma@arm.com>

