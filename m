Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 954ADCAC59A
	for <linux-mm@archiver.kernel.org>; Thu, 18 Sep 2025 11:12:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id F15158E00F0; Thu, 18 Sep 2025 07:12:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EED128E0093; Thu, 18 Sep 2025 07:12:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E2A438E00F0; Thu, 18 Sep 2025 07:12:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id D10C88E0093
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 07:12:06 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 703DF1D9B2B
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:12:06 +0000 (UTC)
X-FDA: 83902106652.06.E98BE48
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf03.hostedemail.com (Postfix) with ESMTP id AF13A20009
	for <linux-mm@kvack.org>; Thu, 18 Sep 2025 11:12:04 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758193924;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=fm8+ADZg+3z2cR2hxKjUtDg+S+ty8ZPrboX3NBiZovs=;
	b=kQ5dl5LIXVL6tZlQUSC8h+VzjnxZ7oC4t2F8ZQGVIkQkyc+hzdxIltcwf2FAB8jfLmTM6l
	mYG9PgRwXukuD88ZAo1bK32X3jrQt0p5bemNluEyAR4qlHcZoX1iIFMx8EYxB6zHcEkhc4
	NCqhMdoJZf/sHT2Sniysh6k2kD1EdWk=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758193924; a=rsa-sha256;
	cv=none;
	b=k2v8lHfmHJgTMQs+J9JTf7i4rHlAxZYRWeFcEvVEOf+qqecOSKQkaWump8/hjeOff0UB/g
	yZYaIoeWqC5LjXaXexem40VYntLipyFAr5wyUocjS//FkgJ1GPkcNK3Go4h4kyVlALQLeA
	Q28DetdVUfyrGhStczggyt+eya8SNfk=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf03.hostedemail.com: domain of dev.jain@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=dev.jain@arm.com
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 77B711762;
	Thu, 18 Sep 2025 04:11:55 -0700 (PDT)
Received: from [10.164.18.52] (MacBook-Pro.blr.arm.com [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 1AA663F66E;
	Thu, 18 Sep 2025 04:11:58 -0700 (PDT)
Message-ID: <8f49bd75-5314-43e4-aecc-e0ef3616f7fd@arm.com>
Date: Thu, 18 Sep 2025 16:41:56 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH mm-new v2 2/2] mm/khugepaged: abort collapse scan on guard
 PTEs
To: Lance Yang <lance.yang@linux.dev>, akpm@linux-foundation.org,
 david@redhat.com, lorenzo.stoakes@oracle.com
Cc: ziy@nvidia.com, baolin.wang@linux.alibaba.com, Liam.Howlett@oracle.com,
 npache@redhat.com, ryan.roberts@arm.com, baohua@kernel.org,
 ioworker0@gmail.com, kirill@shutemov.name, hughd@google.com,
 mpenttil@redhat.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org
References: <20250918050431.36855-1-lance.yang@linux.dev>
 <20250918050431.36855-3-lance.yang@linux.dev>
Content-Language: en-US
From: Dev Jain <dev.jain@arm.com>
In-Reply-To: <20250918050431.36855-3-lance.yang@linux.dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Stat-Signature: fm9p4y4hmnjixgc9om5bf593ho66hmzo
X-Rspam-User: 
X-Rspamd-Queue-Id: AF13A20009
X-Rspamd-Server: rspam10
X-HE-Tag: 1758193924-74392
X-HE-Meta: U2FsdGVkX18USbrWJM6ylmtwA5AiE2vSwVOKntkDn7VJMZSRqh4pBMMLNuWM1fxTMJCOwRDTFSPsA43q1juIFSwk3SvGNx86KJTJiqAa6mTWOS6+OWdMf6SJ9ATZYJunA+m4XBhU6d7OuFiDzCfcayNhTMFfeFJQHZnLwzALjxtQ0hphZVh2q6KC07cflKq+gnxLByTtnfaEV0p1r+qwTiJtn3e3WxR4zbaagRojsCeIsDC4FdP6tNOLhyaLySlFfhqluwc3MCu78wDXLbxeIlkx3GatWctQFm6K/OMx3t8a+XlN+XcOIaB4vy1H0jTy5zp7D2hhzedhM3KVidWpekDvWONdV/4DLK/LxzhZOIU4XKyvs/riNrfl9eTWVw/3sLvSN02XQF+uUoaqoX4fjhcE/hWwiNRZXS6xyZvhLE9lcePReALaQ339PAvfb4LwlbmmqC6s1V0NTytN3nR48uVTE9c1YvLZf3Anu4CG/QF1ETGxa6VcnjpqvFm9yIztqEir8SLDW0ALpzAA4BxFsLFUYMtBMvCgZBwA94b2weBDEfVGhwxhgGIMVtF0xtWSaKvcVXZgPvSKt+jtjFaB0dx+mdwUO01VxE2m1yEBY2VcKj+Cli0Ds8dCZP6AbcPF23XFalwmNJAfNbb5HR8Rbt63U7YQWRsCb4iY94rpvM6mD6bFZSAul2ACcufX6QtfSGWyPzGf+haIyGcllfln2Tx4PE3HFU3MUvWr7WPCrIKaiICDo9jNT9Th0g00+zliCWVoz4zmAY8MHxMUebarKn3NrffrGWSsMfakABZjfiqaNRPUC2EOFlH8gj64/KwdDgvwFUU9W+k0m3BILZkqfQcmINyVwj/N8Zn8hoo2zsZSQmQAVLRfSDKnt4v3TDUl0CiQP5ClbTjOx3XaPbOrFLAcrf9M1cA8QXU1ZoqYk/AL2eZsZvtSDL7tYFTV6xhylO1lgyM9tYp/miE8cNJ
 hRw4f2/P
 IfbYJVrvK7QUjjvYAfvnsG3po1LnoBTpdZW1N86xe1BqjkxdK9j9f9xzvGxKibZTQXUFm1JRXiR7qmplhi46H9xPQHMXQcyN/qqs/IO8Fb9/2d/w77Mi7cvgvKZgRyREhy5OZrGF7GDqH3n08vckCZa+eVnUuhtD7FzMHMyl1iZyNdjwW3AEarnL9lPsvaNBLU0YA4mZVZZCrESRCRcTRQC82ok6x28uJgUrH
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On 18/09/25 10:34 am, Lance Yang wrote:
> From: Lance Yang <lance.yang@linux.dev>
>
> Guard PTE markers are installed via MADV_GUARD_INSTALL to create
> lightweight guard regions.
>
> Currently, any collapse path (khugepaged or MADV_COLLAPSE) will fail when
> encountering such a range.
>
> MADV_COLLAPSE fails deep inside the collapse logic when trying to swap-in
> the special marker in __collapse_huge_page_swapin().
>
> hpage_collapse_scan_pmd()
>   `- collapse_huge_page()
>       `- __collapse_huge_page_swapin() -> fails!
>
> khugepaged's behavior is slightly different due to its max_ptes_swap limit
> (default 64). It won't fail as deep, but it will still needlessly scan up
> to 64 swap entries before bailing out.
>
> IMHO, we can and should detect this much earlier.
>
> This patch adds a check directly inside the PTE scan loop. If a guard
> marker is found, the scan is aborted immediately with SCAN_PTE_NON_PRESENT,
> avoiding wasted work.
>
> Suggested-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
> Signed-off-by: Lance Yang <lance.yang@linux.dev>
> ---

Reviewed-by: Dev Jain <dev.jain@arm.com>


