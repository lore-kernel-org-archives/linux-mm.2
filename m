Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2BCFBC4450D
	for <linux-mm@archiver.kernel.org>; Wed, 21 Jan 2026 12:08:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8EF366B0005; Wed, 21 Jan 2026 07:08:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C6746B0088; Wed, 21 Jan 2026 07:08:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7D29B6B008A; Wed, 21 Jan 2026 07:08:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6A9AD6B0005
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 07:08:09 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 14BB01A0D36
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:08:09 +0000 (UTC)
X-FDA: 84355847898.01.34DCF3E
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 2B10340006
	for <linux-mm@kvack.org>; Wed, 21 Jan 2026 12:08:06 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dhakkB3L;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768997287;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dYQuoHxFtcE3s2fOb8hPMYy2cGQnR2DrgkUSJb6gtN8=;
	b=qK2yCnxmo8fG9D8inRMnyJ74mgL5rAgKkD0FDoPUAfq1EOWgx+Er1vGCxM2KTFbdb0hGKo
	v7VYbKPU/wbpl9R7XAbF9Yz/OAtwwBZC3S9RuUpu9D6Cv7l2r6IMBfDxfP5IdiIKS5zclK
	/bzvAgiAnmZzruIlkEDehY/qYvLJsr8=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=dhakkB3L;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768997287; a=rsa-sha256;
	cv=none;
	b=q0XPUA32ycBv8IihjdaFZgaedz1sZNBznAhPwKWMfYKECZzjxopuV58pq0mLvWWEG06/KK
	UnfAmMcl/G8wDLXIqOwWmCH0ZjeCd+mOSjcGnJhDOZYbF/4VMkwBpflpjs/f49mrAUGeIY
	cwVJYKMuWrAmCeIrThxTFfV+anAwbAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id C9E7040542;
	Wed, 21 Jan 2026 12:08:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0AD6C19425;
	Wed, 21 Jan 2026 12:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1768997285;
	bh=gk0BsMovNsGS2Kpyp/yON4csHC0IuD0vi07fmsUfXqo=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=dhakkB3LbtxvZcMkv4y89+GP5JGm3DMVD50uq8fotcFVaBNls6RmNTZpjyWqtYqk+
	 D06JPppgYcJNrhvg58Yw5RKX7+3+Gh8aWBlQVzT7Y/DnghlU8UnQ08P+50KxhT3Sm9
	 zDafBn7ITHI0M53wc6zW4yJz0VQ4H7FqKpg9sgJ35MnH0koUxmvCPBicxM0Vjkgo1c
	 eqJNe1D5BxKkG72OEEarDLbz62Ce0vDize0fB4x5dxEMzRAeasfpIoCrkon1aXFjGw
	 gJha7c9bPu2aTul021JRTe+0ZSeC38/aZ2qyO1+iV1YkyHe27tVv90JLFwQ9+vXumy
	 cED+GniKYREYg==
Message-ID: <fccb971f-3c7f-4bad-8c2d-6399985eefea@kernel.org>
Date: Wed, 21 Jan 2026 13:08:00 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 1/2] mm: move pte table reclaim code to memory.c
To: Kiryl Shutsemau <kirill@shutemov.name>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
 Andrew Morton <akpm@linux-foundation.org>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
 "Liam R. Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka
 <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Qi Zheng <qi.zheng@linux.dev>
References: <20260119220708.3438514-1-david@kernel.org>
 <20260119220708.3438514-2-david@kernel.org> <aW9i3Er3HXzg9V7C@thinkstation>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
In-Reply-To: <aW9i3Er3HXzg9V7C@thinkstation>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Stat-Signature: 44z95kejt9adegsno81zo7juqkss3rbz
X-Rspamd-Queue-Id: 2B10340006
X-Rspamd-Server: rspam05
X-HE-Tag: 1768997286-685041
X-HE-Meta: U2FsdGVkX18Gu/xma9c2qPSmDcOiyEtRRxeRh1IQC99Y62BEViU9g/C4+B4LfI+k43CzMZz0OcoQrLH26BQGV2KiyCS7GgKv8eZKWj25ZqlvVeW3Oz+XvY8dST/AFEAw5fN4W0lZf+7LTES34wvJYWLkEHzmnF72Ol3BAQyi5EbKPNmUGVVm0oLrgKGw1AjcVsS9WlqJ2cfbr3HMzfS/H/G+q26ERp2IWYkg7sMuug3j8l3OrOcP8UTsRGdhlT18VqozKkmjJ8UIVUE7c2nvC8pnv0IZo9DT0x+MDFsVfJQy8oLjO5GQ9Xdxi52vSnpvsLHvqpDMxkRBDiygF+G7qSPm1SbTEDt3ijybn+zdRY55lGtGq4vmMSI8Im1fI6VcULEoDmH1wvVakjJWO3FNhwFqrui+0sO0f/vZyeRdCMMTvk3RqI6YaXlGKCRm+vKlxWcJ9XGLvdya32ZDZQ40KjTqxmB1UxLjqy1P6b4UyTwkOffl26x2x846BKWGPLKjzYdmsJ/Phs/bty2D/J53Pa5xtZj31/0sTOEXoayHLCz8JcyCoR/bejG2CXr4HgRrN4UsWyhs+78LCfFmO/yu4uqTdEThJx/YLLxNz7AZKAkjuODEam/4Njl8agxHDBb97yEUTjKxsILNqHqhZav2viVitVxI5dXLTtSekwTgqLtz3BQYaHOExwnDtetBBvXQX+lMFG0KBn/+/Pf0yn0Uh5xp8dd59jQUcNzVLJH+BlXry/DiEyqWAO8e9KB7oflBKV53WtEF2/H4+g+Gk8cZCm4buWV8MOO1Op24F7tGrcZGrHow4wUtBU1rIrWGKdTpkg6pvFdtBy2Z2hE+dhL29T0yWDrJPGQElo3JDnz7BiB/Lg+EMjE2x9DmIYE5O7udurWk53peA6uWzaJYivsW6rwx6atPG/WvAjJCnFK51iKpRaqxrpH+L7RADzxThStu7wmnGwHKlkis2SAculf
 MH8IvNV7
 g8bTNuWeJlD6k3CXUGLe6v1irotpITtHjk//VoXlXDFnlFd97Rh0h/BPRtLR1zPhMM8QFpYgU312LcjRoM+QVk3AuOc+Bpm26YXJN7llI3bz5v3Id5LgwioaSsTHZgSB3GFfkoIzaUdxb9k9uVpw8XkgBPlwnttSdKRcDl9SgbIjPqFI5duFBT4ZYEBig7+lewOxdQ6O3OGuXByIwXfZk3khe4qopluX4dr3cwBgn6vz48fUHU9+b3kn8QMK8FqA8efwv
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 1/20/26 12:19, Kiryl Shutsemau wrote:
> On Mon, Jan 19, 2026 at 11:07:07PM +0100, David Hildenbrand (Red Hat) wrote:
>> The pte-table reclaim code is only called from memory.c, while zapping
>> pages, and it better also stays that way in the long run. If we ever
>> have to call it from other files, we should expose proper high-level
>> helpers for zapping if the existing helpers are not good enough.
>>
>> So, let's move the code over (it's not a lot) and slightly clean it up a
>> bit by:
>> - Renaming the functions.
>> - Dropping the "Check if it is empty PTE page" comment, which is now
>>    self-explaining given the function name.
>> - Making zap_pte_table_if_empty() return whether zapping worked so the
>>    caller can free it.
>> - Adding a comment in pte_table_reclaim_possible().
>> - Inlining free_pte() in the last remaining user.
>> - In zap_empty_pte_table(), switch from pmdp_get_lcokless() to
>>    pmd_clear(), we are holding the PMD PT lock.
>>
>> By moving the code over, compilers can also easily figure out when
>> zap_empty_pte_table() does not initialize the pmdval variable, avoiding
>> false-positive warnings about the variable possibly not being
>> initialized.
> 
> mm/memory.c is a kitchen sink as it is.
> 
> I think you miss opportunity to introduce mm/zap.c and move all zap
> code.
> 
> It can be done for code from both mm/memory.c and mm/huge_memory.c.
> Line between THP and non-THP code gets more and more blurry over time.
> 
> The same can be done for copy and fault code. I think it is going to be
> more maintainable this way.

While agree that memory.c contains too much stuff, I don't think zap.c 
is the right abstraction either. And actually, I think basic page table 
handling is well kept in memory.c, or moved along with other stuff 
(fork()) handling somewhere else.

So I won't do any of that as part of this patch.

-- 
Cheers

David

