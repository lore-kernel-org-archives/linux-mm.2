Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0ACA2D2ED08
	for <linux-mm@archiver.kernel.org>; Wed,  1 Apr 2026 13:38:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2DF3A6B0089; Wed,  1 Apr 2026 09:38:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 290606B008C; Wed,  1 Apr 2026 09:38:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6896B0092; Wed,  1 Apr 2026 09:38:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 0BBF96B0089
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 09:38:09 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id AAAF01408BD
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:38:08 +0000 (UTC)
X-FDA: 84610090656.18.6731D59
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1C8E51C000E
	for <linux-mm@kvack.org>; Wed,  1 Apr 2026 13:38:06 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mWkVf7ka;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775050687; a=rsa-sha256;
	cv=none;
	b=BypTEbjzOEwiB0kXzH3MWRiPTBwKX0P2SdPr6l5UxWAvL129eWcxMOPyWLxD4ifDd322IY
	qTqo0BleTOylUlBMl7lWOy+F5bh53oBoQGvM3xPaMtmrPq/LzqojYnTZpH2Z0e+Ii9DEGv
	Ge2Yk0a/ojVAxXueBEMcRCoOhw1+/4Y=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775050687;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LXl5Oa0cejHlirGJN6Tddcm1Ykiz3RJ0jARS/clyiBw=;
	b=OWJdWQHK7ZLBUrNkAQaNei+wRvcCyQ/JJUYOn+84dmmmDS4mvjTHIR5fPDYxEGl7+bjIvb
	mcUGWR9hxwXWtW49kDXcr+ojkMDdgcxrzysPfzJpeBVoGQewslYbGVYafEhOW4eMFj7cTe
	2naSzjbpR4DGrbdaVvfbDceqZwMZV1A=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=mWkVf7ka;
	spf=pass (imf20.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 4736D60121;
	Wed,  1 Apr 2026 13:38:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79C33C4CEF7;
	Wed,  1 Apr 2026 13:38:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775050686;
	bh=kHNWjAj93z7Z6Od8xkd0JOrKty2SNO5bqPckeuv4KoU=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=mWkVf7ka6OrTk/RspZojEw6FOoenIoW/UDOpx6v2RHFEIKucTcggFO3wV6mslQUoe
	 /1uEycr/SXtB5Tck/GHckKQR/owyvF4NE7uUFdRMY7fH+DVGrUoiUxIzkqy5dIWTtd
	 MQ1hPSxqP8RiS+1C6ewrz7wh9jiC909RKpjugpsGdFpX0Lzc5LvUMF9oAMEVJta74m
	 TwDUZwP+R/DCBrTVraV8ZsTAX5aaNm9SJEBHoPTB37fv0SFiCpf1/XBUlvGahE87aD
	 KTXWbFTvlwIA7e2jowzc18x9VIFK/tMfHw7h5GN22dgrHQ+3kLFu6DkWQacybwGCe4
	 e0qc+I40Y502w==
Message-ID: <40ca760d-c200-4ec2-bbf2-66811fa8ae45@kernel.org>
Date: Wed, 1 Apr 2026 15:38:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/thp: dead code cleanup in Kconfig
To: Julian Braha <julianbraha@gmail.com>, akpm@linux-foundation.org,
 vbabka@kernel.org, hannes@cmpxchg.org
Cc: mhocko@suse.com, surenb@google.com, rppt@kernel.org,
 Liam.Howlett@oracle.com, ljs@kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260331070730.33915-1-julianbraha@gmail.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260331070730.33915-1-julianbraha@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1C8E51C000E
X-Stat-Signature: w5r3dotinfzm98dno9rkxkyfdgo44sqh
X-HE-Tag: 1775050686-748813
X-HE-Meta: U2FsdGVkX186y8x8h/6M7uQ0M+JUzV2BgyBhTT7LEI3QcltMHBMqe+q04elbTnYW7qe1sCTTOrLjAwmRN+cgD0nIK+B1akIR7r8omF/J/fGFsriJLTcCLSErR6qafjp03lniq6t8AhunNhNc47SvDLSr439guPLwEjcyNHssxDupfuSE5apbQhSY4Es7lTQ/yzv3gTwNa+pU3+aqt9W8QTFAFsPN3nYAe2IhEMaQVT1cmCuymd1WGaP0RnFPlsWVLAwnfuuhNsHBadwKbbYM8tUfof7HyKpEdw5RclrL1iNKxnHhcH5tJH8ehifWI326rQUHgmFonEk0NTzq6gT06GoGAB0l17IrjHCnQ4vkyyj3+R6Wc1NuiqTbQTgxI5hIws4ZngV5S90g2QLspD+UdfbgOnwkBuxLyxzM9b+wPY/6d/gNdmbPlXv162ZRSjpUjHnzrEJ/AK3r9006XOOXDRmgIoudvVKFTQJD0sZmxMx/Zg7xTzvB7tjMVA5QYam5gEOKIbcrQ3AbsSRsE4U7gOikx8H25hhqLBAgwWnMLdSnEC+aI47gevlnWsbPsWuOsULnhbLBnRXHlOwkhvnUOYrYvpR6gQvTppiLHOdPBrt1AYoClj+pGx0s69l5Ng3aUoAxEyenIL4wsNXnq1QPIEvfbtLmOfFPOcAxGgafwunBpOPqD9eO5lrs2sw38R2gd7KfflkvoRXU8yLrb9BCBkLoMbUKQFMthiKj03kcyiT7rxRg6eWDD+qBZGJ3avNDAiRGl8GvgXxvcM7lpiw+XsEgGhjFqKVt/fGxWstcWpwIVF0ky8D22Khkvi08odEji+dTkBNKbHM+9yzzDsUCjy6Wc8CvSdSiNm0UDGudDQH6rrngOy1kVpp1o8idimqJQLWd+fHrtXfhU2z3mkcqCW4f3KvNlYjRHV32wyeKdVjxhyds2Lk7ZQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/31/26 09:07, Julian Braha wrote:
> There is already an 'if TRANSPARENT_HUGEPAGE' condition wrapping several
> config options e.g. 'READ_ONLY_THP_FOR_FS', making
> the 'depends on' statement for each of these a duplicate dependency
> (dead code).
> 
> I propose leaving the outer 'if TRANSPARENT_HUGEPAGE...endif' and removing
> the individual 'depends on TRANSPARENT_HUGEPAGE' statement from each
> option.
> 
> This dead code was found by kconfirm, a static analysis tool for Kconfig.
> 
> Signed-off-by: Julian Braha <julianbraha@gmail.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

