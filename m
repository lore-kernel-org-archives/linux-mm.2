Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 910BDCA5FA5
	for <linux-mm@archiver.kernel.org>; Tue, 29 Sep 2026 08:40:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B00606B0088; Tue, 29 Sep 2026 04:40:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB1286B0092; Tue, 29 Sep 2026 04:40:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 99F6E6B0096; Tue, 29 Sep 2026 04:40:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 72D826B0088
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 04:40:21 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 0F5631A0445
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:40:21 +0000 (UTC)
X-FDA: 85266153042.10.9FFB2AE
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 367024000B
	for <linux-mm@kvack.org>; Tue, 29 Sep 2026 08:40:19 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8RCx2A6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790671219;
	b=BNvZzwYYSfeu8Az021Gru8KX07MIFYw74I8XrG1Ldu0oCPKUSMkhPlGfLJvqsZUjHe3cag
	o6swXhbRAc2xXa4k6uzCvacyhlF64ZvNvXNP6KATVdPdxtWpvP1BnPDjFe1TKQZZGsmUor
	yKEdxi8yJwFyMpfm8rz/4B9QhFRTNDY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=J8RCx2A6;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790671219;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRmGo/s3yk59uOXehGVPyIu3WF3s3uiccw2ABWNFy+Y=;
	b=vbjP/oDq/ERef2iIRySpFMRcTCJ4ZCDNokh/plMMmSO6yNNyoPS4eGCDag5DXiFDsrtkT9
	OjJ4S0GmZ3odtiEkMl76RaSVYUdcFqRxaMXThRiGztdHRpSviaYQHf30ZUqt8O70vAKvIv
	q/+U2mV1wbzW99S+Ad6V+DbTAQQJHHw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B714160210;
	Tue, 29 Sep 2026 08:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27A841F000FF;
	Tue, 29 Sep 2026 08:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790671218;
	bh=NRmGo/s3yk59uOXehGVPyIu3WF3s3uiccw2ABWNFy+Y=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=J8RCx2A62TDnaTbtiOzwUGzOs/DtFljh4PB4C9JQMt9SQup+lbXC+eZs7X2HWUBnt
	 H8e0kNbLpjrZRKnY8dR1k3GZit7rPtW01boZqWO4PBI4tWYL1ScQzzrBFwDmZyKec3
	 XPqRat24jksIghm4MurKmraBFbcVxOkrpo/Ql2yin0sHvXmZrOSayPvZisZ70YVZZw
	 DJihOGOJfhQS6LkyITjQU/YIUwy+RWGxskKfhA7IcgrOhwWLGfwSMKj4uNyMOs7iFU
	 qRekMgmB3L3BPaXavkjvXbp72MmRlsoE/U54Kx4lrCWsUT3fU+1WzXrI8y0zmo5wgd
	 THQnu6YKhBWHA==
Message-ID: <3a95d0e5-7969-4b0d-988a-ead62b06b6f5@kernel.org>
Date: Tue, 29 Sep 2026 10:40:13 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] mm/mlock: fix zero-length request normalization and
 integer overflows
To: Park Tae-sun <ts930@dgu.ac.kr>, Andrew Morton
 <akpm@linux-foundation.org>, "Liam R. Howlett" <liam@infradead.org>,
 Lorenzo Stoakes <ljs@kernel.org>
Cc: Vlastimil Babka <vbabka@kernel.org>, Jann Horn <jannh@google.com>,
 Pedro Falcato <pfalcato@suse.de>, Michal Hocko <mhocko@suse.com>,
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <179066531783.50175.13377521828379196177@dgu.ac.kr>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <179066531783.50175.13377521828379196177@dgu.ac.kr>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Stat-Signature: sfxtrtqpmxepnwenbp7ucatiizngthkx
X-Rspam-User: 
X-Rspamd-Queue-Id: 367024000B
X-HE-Tag: 1790671219-855291
X-HE-Meta: U2FsdGVkX19Q/PMvFy9+ZEK4ygBFBZLxceXXZ0s2zclXlmDKHVk1z+/IVnjrg5dLST4e0DZqo56S5073yryhdvAweKZfXeB3zPgU5Z9dbImI4Fl1UvX03OJ/yAB3qdccE7JFHSzwMVlqJfbdGvs2Mf184PYMXCSOBHNIej8ho2J4BdgPa5ijj6GYeSE2+JoJ+VnlVkiB2DvPPYCJxIpPa7IJ39uEtNrE7Y5adn324/lAbH5gUDbIous3tfQCNtHvYaRNWVk+Odrady0mP314bvjswzl24Nozd0D1MvsvLdpekw3/zBVX6M5rXlfQZqTbCqj/d7iWI5+ZSFN+6d9C/3A2+BOfXbShjylQLeiu0lelzbdnX8/WRb4vKGbWqzChg8aPYZHtLvlhN+cgT+Fzr9LhIlf3sSSDUiO8Mmd+g7GaEBmm9VAABMo8X9PCDihwIeoAjUVb3hx192mQIhiS54zAf/J7QtWnxcYV9w7IL7/3jqUW828lZv0s4mpc00tAfILw3ZBILvS/cB/j02o5vBc3SV1vLJSMyBORiUhWLzf4AYBmntC4/IS5p8vpVjFKeEDV+S4DLUVIS2txZusNvTueA3p67+NZioAlP6Oavv6nV00OhKvp5zMAbH77tVYmxJmHWdc8jU3z03/POJZNcH5Fz3BxjuOu5423+yuLjpfc196PaWbYVnNHRyvzx66sUGFQYSrMNuqJ+E1z2ztcQmsof5vGcY1s43LReOQzxvxG0PYLAJPoCczofuTDtfxNhhGPU8Y/C2RCsa1IGt1FJ5qb6uaW3AfA/cs8zhfigopEydoEb6GhhVhlygZVRrgMljYRd/KMBAA9wVhL5YHXMl5T4EH2rqR0QLotITMldUEPUEQ07zQBHw7FL1GzNyBggDD2tPy7T9szq0V02abPN24bgCC53VN+1PkTymLNPW8BjbAqh0tzacvHyd2jVkHuJJVafd9W2UqjD541gWw
 d6a9Kt1C
 oPO1pYariybQK8wppr3Bl+r7mf5nM8xr5PEyUZYoemm+blRbYfF/9Fu3CNBEStB5QRshI7BKFCVKkeRhTKDPYsznA9e+oMPevsy69YXJ1rGmfqjGa3Kf72nxRjr2wUgQoqV/ZGkZZMSQJLMUVcQlji0YWXv966XDe7DT1fFoGcJL85p9xelWtn7jVWetf0NgHkIE/SZTkG3VVDdSEzTiJSijv10urs2Fcta6jgGkpQCHUsFFWsDbHNQb4K5mezXi/CNKt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/29/26 07:56, Park Tae-sun wrote:
> mlock() and munlock() currently normalize the requested address range
> using:
> 
>     len = PAGE_ALIGN(len + offset_in_page(start));
>     start &= PAGE_MASK;
> 
> This performs multiple arithmetic operations on user-provided values
> without validating intermediate overflows.
> 
> First, a zero-length request with an unaligned address is incorrectly
> converted into a non-zero page range. Because
> PAGE_ALIGN(offset_in_page(start)) rounds any non-zero offset up to a
> full page, a request such as mlock(0x1005, 0) falsely locks an entire
> 4KB page (or fails with ENOMEM if unmapped), and munlock(0x1005, 0)
> silently unlocks memory that should remain locked. Conversely, an
> aligned mlock(0x1000, 0) is a no-op. Zero-length behavior should be a
> consistent no-op regardless of address alignment.
> 
> Second, a sufficiently large length wraps around to zero during page
> alignment (e.g., len = ULONG_MAX). Because PAGE_ALIGN(x) is defined as:
> 
>     (((x) + PAGE_SIZE - 1) & PAGE_MASK)
> 
> when len is close to ULONG_MAX, adding (PAGE_SIZE - 1) wraps around:
> on a 64-bit system with 4KB pages, ULONG_MAX + 4095 wraps to 4094, and
> masking with PAGE_MASK clears the lower 12 bits, producing 0.
> When len becomes 0, the subsequent check in apply_vma_lock_flags():
> 
>     end = start + len;
>     if (end == start)
>         return 0;
> 
> evaluates to true and immediately returns 0 (success) without locking or
> unlocking the requested memory range. Similar wrap-around issues have
> previously been addressed in mincore() and madvise() by checking for
> zero length after PAGE_ALIGN().
> 
> Finally, address addition overflow (start + len < start) is currently
> detected only inside apply_vma_lock_flags(), after mmap_write_lock has
> already been acquired and memlock rlimits checked, improperly returning
> -ENOMEM instead of -EINVAL. Per POSIX.1-2024 and man 2 mlock, arithmetic
> overflow of the requested range represents an invalid argument and must
> fail with -EINVAL before modifying VMAs or acquiring locks. Note that
> apply_vma_lock_flags() already contains:
> 
>     if (end < start)
>         return -EINVAL;
> 
> but this was obscured because rlimit accounting preceded it.
> 
> Introduce a common check_mlock_range() helper to:
> 1. Return 0 immediately for zero-length requests without taking mmap_lock.
> 2. Validate intermediate and final arithmetic additions using
>    check_add_overflow().
> 3. Reject lengths that wrap to zero under PAGE_ALIGN() with -EINVAL.
> 4. Detect start + len address overflow before taking mmap_write_lock.
> 
> Signed-off-by: Park Tae-sun <ts930@dgu.ac.kr>
> ---
>  mm/mlock.c | 55 ++++++++++++++++++++++++++++++++++++++++++++++--------
>  1 file changed, 47 insertions(+), 8 deletions(-)

You call it "fix" but then I see no Fixes: tag.

Which of the problems described above have reproducers (IOW can be triggered)
and what is the user-visible problem?

-- 
Cheers,

David

