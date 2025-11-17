Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D2827CE8D6B
	for <linux-mm@archiver.kernel.org>; Mon, 17 Nov 2025 04:37:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1F6DA8E0044; Sun, 16 Nov 2025 23:37:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1A6DD8E0002; Sun, 16 Nov 2025 23:37:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0BD198E0044; Sun, 16 Nov 2025 23:37:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E84FF8E0002
	for <linux-mm@kvack.org>; Sun, 16 Nov 2025 23:37:32 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 53723140760
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:37:32 +0000 (UTC)
X-FDA: 84118840344.28.B16A7BB
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E520120004
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 04:37:30 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763354250; a=rsa-sha256;
	cv=none;
	b=OHnTA3oeS5CsE2bAJXL1/PEasAi19hCCHu8Anv1/OAem/mp4Yo8AjLbwDNzjmXoYaIxDYy
	7cCQfhG5YYPTumrYOSLdVS4dwuUDEkX1CSoChfc2twMygaccmgoKM7ybV8qhjXelSl4FZx
	wSpiAGXf035ixWgjCW7QR7cG6uQ49ak=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=arm.com;
	spf=pass (imf29.hostedemail.com: domain of anshuman.khandual@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=anshuman.khandual@arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763354250;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=YEa3ok515B+qsUceDTHrN94skLf4cHmtq1pzYE+GnwA=;
	b=jsEroAGJvRtt9d762ZJywQsUsa8pnqfl1xkcd6tpPyEaMbzmN/+yD/aeFaP/aaSDkm6RcN
	MgltrWYSeAsxneBeYhg8Vm8jTW5NahG/nU3+nhpDfpTmkvBCsxDZri6ssTSSqHWpek2auC
	jhHdTpkqRy7c3X7iXUOpd5SmbvZnvuM=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 7382FFEC;
	Sun, 16 Nov 2025 20:37:21 -0800 (PST)
Received: from [10.164.18.52] (unknown [10.164.18.52])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 5314C3F63F;
	Sun, 16 Nov 2025 20:37:25 -0800 (PST)
Message-ID: <e89eba01-c76c-4ecd-8930-c188d89f4906@arm.com>
Date: Mon, 17 Nov 2025 10:07:22 +0530
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 0/2] make VM_SOFTDIRTY a sticky VMA flag
To: Andrei Vagin <avagin@gmail.com>,
 Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 David Hildenbrand <david@kernel.org>,
 "Liam R . Howlett" <Liam.Howlett@oracle.com>,
 Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, criu@lists.linux.dev
References: <cover.1763142412.git.lorenzo.stoakes@oracle.com>
 <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
Content-Language: en-US
From: Anshuman Khandual <anshuman.khandual@arm.com>
In-Reply-To: <CANaxB-yqsphFXvY0diEaHL+Bg4eJ+z_mqezxen9xVyoyL+4NMw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 3E520120004
X-Stat-Signature: 4qeiabhitgpniqisjk8dikuwgx4q9atm
X-HE-Tag: 1763354250-292995
X-HE-Meta: U2FsdGVkX1819cPxsLgzo3sM0AmhQYVJsTEMtQIuyQFGt5vEQ0r1yL3sbGAtyNgaGFNUHcHRi6sWuNjadlZLgUb6wU8W8XF2KjdgVsTUkvaJGYMuryrccApKth/o8SE6CF66XKmWNHnsUuTzwxfzFW5aoy3Ehbohbg9ZkJtVKJ2VyDMsxYpoC69TTiAPzX+gQu3ZRjoSPtBPUX+qAlA/QmuZJrkWHb6npdRj9mG8cZELF5IcgQQuOU74X+5brHsrUBxt/zrbZk/jjkjuCy0dxfkzik3rYMU0OXC2h9J1QmyK3PDnyrU1cZnhYzni2G9a23jMy/i9Dkn1ApMZuwVcG9JbZ6hJXvDRIIpPBolN8aRr8ctoOfq6EZ3AexdWbacZKEnL535nhCSAZYqe2WUwwexuYUYcuYIabo257U0qEZNENXeeyHg1OXYrKoBTrzkIJLDaN31epkMAfaUI/YXAObdthq/InGFvQCq50vmFMbJs3SxAoP69K53U3rTZsMKo+yqqq4FyCgEbriZ2FkX1fMYCcKPno57lcms6HeKcZZovYZaMnuJOE5uFcwzAeaZIcH9VOfM8g7ZohpgaRkUeateHLVSrAnwnZmjjGQK9KkNLUsJA+t7JINjgSjXu2kN7kjCB79/Dx4UGvS2tIMIQC39Jc9mucAayJPHNY6+Lh0N5wTtipzndrYpSjrbn8/wzxPXy3XHb2I3U2PT/Mh6Rd4Ve+6ntR+I6zaBXH/rYQDS6Lr3Yaf/j/wujH1ataj2fHdcKKaeMn8wDcpxw+C2j2o7DZxBRuorh4K1UiB6g4bP/9QVmcw0sgFWzAPXsfiMZBROtdrpcvO61i9Q9SDs1L/qW2h1kHd/l2aQ7FQQ5ORQR+J5hINRSfqslaGL/74bo33WckgCMBbgYLXZdCbFrmasB6r9lkhlg3oVf7x4zX47pJD5aEwDiEqi3X5gzQyesuWaVKFa+rH4K7HB9C+A
 aXRm/yuY
 SfV878qwffa9AqjAXIIHZixdhb6ZyzWZgNAX0IA9zmkt2+uNYWsHPLwL7gt5wPJ9uAfaVlXKs547BKOn6948MZ3W7gA9K26n5Zv96Wo+4pJvU+y8UgS3zc1Gs1ad4bQ3t/S8rVJuchj7oTTIA1KfIdXvVUx46GvEZqCB/tmK41abvPKZfSig2XT+Uo+ldFBXlQQSO7c2WvqcjlSKgZUFYsKqAhsZ8FGJZe2/slTSzyaOLpPk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 17/11/25 6:23 AM, Andrei Vagin wrote:
> On Fri, Nov 14, 2025 at 9:59 AM Lorenzo Stoakes
> <lorenzo.stoakes@oracle.com> wrote:
>>
>> Currently we set VM_SOFTDIRTY when a new mapping is set up (whether by
>> establishing a new VMA, or via merge) as implemented in __mmap_complete()
>> and do_brk_flags().
>>
>> However, when performing a merge of existing mappings such as when
>> performing mprotect(), we may lose the VM_SOFTDIRTY flag.
> 
> Losing VM_SOFTDIRTY is definitely a bug, thank you for fixing it.
> 
> A separate concern is whether merging two VMAs should be permitted when
> one has the VM_SOFTDIRTY flag set and another does not. I think the
> merging operation should be disallowed.The  issue is that

If merging VM_SOFTDIRTY and non-VM_SOFTDIRTY VMAs would not be allowed then
what is the point for moving VM_SOFTDIRTY as VM_STICKY ?
> PAGE_IS_SOFT_DIRTY will be reported for every page in the resulting VMA.
> Consider a scenario where a large VMA has only a small number of pages
> marked SOFT_DIRTY. If we merge it with a smaller VMA that does have
> VM_SOFTDIRTY, all pages in the originally large VMA will subsequently be
> reported as SOFT_DIRTY. As a result, CRIU will needlessly dump all of
> these pages again, even though the vast majority of them were unchanged
> since the prior checkpoint iteration.
> 
> Thanks,
> Andrei
> 
>>
>>
>> Lorenzo Stoakes (2):
>>   mm: propagate VM_SOFTDIRTY on merge
>>   testing/selftests/mm: add soft-dirty merge self-test
>>
>>  include/linux/mm.h                      | 23 ++++++-----
>>  tools/testing/selftests/mm/soft-dirty.c | 51 ++++++++++++++++++++++++-
>>  tools/testing/vma/vma_internal.h        | 23 ++++++-----
>>  3 files changed, 72 insertions(+), 25 deletions(-)
>>
>> --
>> 2.51.0
>>
> 


