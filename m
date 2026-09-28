Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AE944C9832F
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 09:01:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BE5416B0096; Mon, 28 Sep 2026 05:01:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BBD126B009F; Mon, 28 Sep 2026 05:01:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AD26C6B00A5; Mon, 28 Sep 2026 05:01:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 836166B0096
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 05:01:00 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id F2D3D400FE
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:00:59 +0000 (UTC)
X-FDA: 85262576238.25.50FD50E
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf25.hostedemail.com (Postfix) with ESMTP id 4785EA000D
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 09:00:58 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vc9FA6OO;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790586058;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=x450XlcjIL1p7LFEC3Tf+NE6Fbnndr/8bL+TDaQA93g=;
	b=FWw1U/mYULsfdhAaW9/R7HtHj4NF9TklHSyzhtLffmR7zpq8jPHLrIkwrioNJYoUdXnuz0
	qCVtyrBPvnkFOvAd5gSTMfognw/c/rLlJCTRZ5FreRY5I5wbWHVMlrcRaIaZMeJJ4RUeDq
	QIZfR0xTCfDJmsPwpVf6Z+agP5qXhbQ=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790586058;
	b=HeCLBYAhKHVR91rzn6hp2gGNms3JT4W65BJBz9u/2NVbW9ZA4PRWnSSB9o4ONSCZtwmyEL
	S98IytcpD1cKBx1BdFsGptlwfHnwkKEvqp4olAWF4b9gIpQYyIGAboWUUrttrCvrSjINOS
	I4zzUJXHfoCnIC5dQJDqqZjrMYVYctc=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Vc9FA6OO;
	spf=pass (imf25.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B637B60052;
	Mon, 28 Sep 2026 09:00:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9331F000FF;
	Mon, 28 Sep 2026 09:00:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790586057;
	bh=x450XlcjIL1p7LFEC3Tf+NE6Fbnndr/8bL+TDaQA93g=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To;
	b=Vc9FA6OOXax+HTWehEVc8scEkVzDkEYpkCJmMjtZEGm0pEDwZhGMoPX/JRahcuGTj
	 jZ28zJgxBMiNHCGquf5E5k834oO7gJLejtP3dPTnrZbD2aV599wsb9RlapsLJgdRIH
	 yHzPx+bIOedPC0PnqTwdFz2dBUrtnYFr9qvpXPfVZHeKQ40Qp8OQTF4rMSlDWE7/z2
	 F6DqvhUmpz/92a8VzqCsmYgCm5HnaylhVjBvGpoMvTetJ7MnVaW5EtOrDOPAzpiZTi
	 2sDoOC/SktSOpNE/B47Y/m1xi/Sks5aP4xeD8ZJhydj0qgdTUmiTDdXnsB1aD4nv1j
	 NAAnAToQDRnEA==
Message-ID: <f2e718cd-92eb-4127-84fc-23f29396ccb6@kernel.org>
Date: Mon, 28 Sep 2026 11:00:51 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 4/5] hibernation, KFENCE: explicitly map/unmap KFENCE
 pages
To: "Mike Rapoport (Microsoft)" <rppt@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexander Potapenko <glider@google.com>, Marco Elver <elver@google.com>,
 "Rafael J. Wysocki" <rafael@kernel.org>
Cc: Dmitry Vyukov <dvyukov@google.com>, Len Brown <lenb@kernel.org>,
 Pavel Machek <pavel@kernel.org>, kasan-dev@googlegroups.com,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, linux-pm@vger.kernel.org
References: <20260926-hibernation-v2-0-235f69f3ab2a@kernel.org>
 <20260926-hibernation-v2-4-235f69f3ab2a@kernel.org>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <20260926-hibernation-v2-4-235f69f3ab2a@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: fdupju3sfy4mf94cj875kpqntkm7owgu
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 4785EA000D
X-HE-Tag: 1790586058-176072
X-HE-Meta: U2FsdGVkX18tDTZHJkErHONX5HG4/QQeMApY2j87E0+CWimjSJ5OzJaqRbT52IHCZ3kMb8/XWZxlHvyDeyLNDai4Lwu578JYPyo1Y0UNAPy1fPVwCu5TRxHTCCxxgvjHEZZu74+14lxyYoi/epIPi/9i7tHBy2w8t7pePu3iwHRqdXIvSkmyHixLhWa4I5rkiozQ29mLFsVOS4F1My1EJvo0CraBpvTdYsgwqBZkRe8T9zCHvAMPbUQqL2+GesfcBTla7LuYiWAU1xyVQSPhjdmTU5CsRt8Z14CMjxRTGwOEf9DZtKIO/JdZSdOg/h/HNQaWwzcD+s6DP7/TdkZFVLqQwc3TXf+jng7ub5wntGVHEvWlRJxhAz3nPlAkezllRxFkP90p0y7TeTsnfV8WHYCepgVj5BZXREJu56IQpYASZ1WLetoO2Z8ToY5tbdAph2zJAzl819xN+AY2KDMPOyBn5Wq1yk42HYWl5MbSzeWJcIsRX4QXTfMb8wPZZGDx5QfFqGFqSYTwdMAUBLXGSDSnS3wzTOVcbLF4TXOnwzyOe+NaKBvPnxKe14TPi5QCET3iA1OwUrzW9KwU9Dx0qPldiY8lvhUxAi6LquBr+16hciUflQQrvMutFjH2oI/azhCej9QtYrRQ85PFNCUDxaEEkQZdH4MnN7LJEnV1eArcrqFw5m0P14n9Ybi8r7PU3Ro52h0uOtJnGM5SrDxFYQy11quaF4AaODfo+GY0d97B6MQhjTHNCQMMwsxwwXqYox/PFPOMiyj9Pu69i1kQG4qj6y+WWdnL8TP6ZT8RJ8I4zb5svnkTJ51SQDF3kcFjz1NDoUZ6RJCr1ocgsjrLMAeJNWvNFU8i0K9F31w0osC7174ON2qbPdKMFF6eJAbqPBX9GCEasS8wPsrOSDZMLh6C++ICyzpTfnscH2n9quL274gNGpmmTE1fsY5+i1exgAqxMwOmc84Svdt1HmV
 ZCEX0woG
 m1zMd1BJbZwedKMgL0HEKNjE6X2Df51s9RMEvqfExY1U0HgKq0pb3clVOU5KgqJ/mJj+qRYdljjAZ3pZex2pheoT2dO3IgJEYUdyymb1BNOwmOCqx5jGA/RDh+N+p0XvYh/Ot7Yj9rh3FP+HdQ8Eq89csn1Ty/eV90CALYUpb7yKGmmJkgfzGNi7e6xk44XarGbZnt/SOUcMisgATqvDNhYRnOtTw+n+CXwlbVgw/y18XpCRGrzNOv3x+iSotmjxuCeifIRtRT4XbSqhwRlHrV0009g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 9/26/26 11:26, Mike Rapoport (Microsoft) wrote:
> The pages protected by KFENCE are removed from the direct map.
> 
> safe_copy_page() temporarily maps and unmaps them using set_direct_map
> APIs, or, when the stars align, even using debug_pagealloc_map_pages().
> 
> Neither of these APIs cares whether it is a KFENCE page and both blindly
> perform the update of the kernel page table for any non-present page.
> 
> Ability to use debug_pagealloc_map_pages() to remap KFENCE pages when both
> KFENCE and debug_pagealloc are enabled is an amusing coincidence.
> 
> But with increasing appetite for using set_direct_map for hardening
> purposes, it becomes too big of a hammer to enable saving any non-present
> page in the hibernation image.
> 
> Another gotcha is that loongarch that does not have a direct map at all
> advertises ARCH_HAS_SET_DIRECT_MAP to allow coexistence of KFENCE and
> hibernation.
> 
> Extend KFENCE with a bitmap that tracks which pages are protected and
> provide kfence_force_mapping() and kfence_reset_mapping() APIs that allow
> forced mapping and unmapping of KFENCE pages.
> 
> Use these APIs in hibernate_{map,unmap}_pages() for KFENCE pages.
> 
> Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> ---

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>




-- 
Cheers,

David

