Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 44A02FC591C
	for <linux-mm@archiver.kernel.org>; Thu, 26 Feb 2026 09:40:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 635596B0088; Thu, 26 Feb 2026 04:40:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B84C6B0089; Thu, 26 Feb 2026 04:40:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C4D76B008A; Thu, 26 Feb 2026 04:40:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 368A56B0088
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 04:40:33 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B69588CADD
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:40:32 +0000 (UTC)
X-FDA: 84486112704.08.E03E5FD
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 09BDB20007
	for <linux-mm@kvack.org>; Thu, 26 Feb 2026 09:40:30 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHmLYZ4I;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772098831;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KgPNIXRk3KQe8hmIFVKZiPi+RRl4AiDU46vzqqF6zXs=;
	b=Tp+x6DmttcZ/RaZ1+u6FeOk8qPqJa6vkvo/tvwTDi1TUd15Aruwv2gZINCvskl7vA0R1H/
	F5TY+p48/us0hEdvOx3kfhwgjh4X3x/COqwXnyMzUEZBX0Rfo3RiQOynMN4iw9wEc9WwU8
	lB5UGgM0gg1+H5V4LTLpNgw99KNGK68=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=fHmLYZ4I;
	spf=pass (imf13.hostedemail.com: domain of vbabka@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772098831; a=rsa-sha256;
	cv=none;
	b=51JfG+4OuVqOCFYMW7vyaWAbVaOvVwO2uA/TlLp1WEBImf77nOxix3+HcsOiUU3AX0YXs5
	OlEuM2BP0z2JKLkvKyryITZeR7hrsIElLfOVWt+aoESqmGG4wsC4t1Gr12+95gGIov7Rao
	HnHiy5SB6N6aRz3B9SnqNb8bY6gkBkI=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 05E8D40C23;
	Thu, 26 Feb 2026 09:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3178C19422;
	Thu, 26 Feb 2026 09:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772098829;
	bh=3uH3FBgkdH0OdfPwZ/VnlXYx1H8nmjI8dbYBnurNgWI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=fHmLYZ4IkIVi9cVgJPYjmSmXlaJdVTh+vDU5ehkyNQaeserWhVW5uur6nImiVrcZi
	 esARdS7umLqdvmgPyoIYbBKrHNXAi5ymbLNreLyPxbpDhSGN3ii+FEYrZrRoHvAqvz
	 OWFmqHSkrO/1u1fEpN+cFgGOBmkO67O0D2jOguMp1E2q4K8ouwdPyZIkYoiewY+d0c
	 MnQKIVs2FWJHfG/NFAY7MehYh47XNi4HqvR1dGPRgfDkFq4kjhfNkHD7ALo94tjz2y
	 YdGgvZ7vrb/5lrhBfpEomBfjgoVqpbQmK2MHnR5ZJ9UwJY7BKiwOTcH6NP+SZt0JVY
	 oMaZalVXC9pGQ==
Message-ID: <042fceca-f2ba-4656-87d0-89676cdd435c@kernel.org>
Date: Thu, 26 Feb 2026 10:40:25 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] mm/slab: mark alloc tags empty for sheaves
 allocated with __GFP_NO_OBJ_EXT
Content-Language: en-US
To: Suren Baghdasaryan <surenb@google.com>
Cc: akpm@linux-foundation.org, vbabka@suse.cz, harry.yoo@oracle.com,
 00107082@163.com, cl@gentwo.org, rientjes@google.com,
 roman.gushchin@linux.dev, linux-mm@kvack.org, linux-kernel@vger.kernel.org
References: <20260225163407.2218712-1-surenb@google.com>
 <CAJuCfpH-+trdZ=68v0FTj_yKn6+gmE10gKjmjrTyPvO2EaXdRQ@mail.gmail.com>
 <3ab53191-5aac-4b9f-a019-303d837ec517@suse.com>
 <CAJuCfpEgB8bLMSXPG_K0uaOvALoC1OamKuRosv3Bb=ngiYJz6A@mail.gmail.com>
From: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
In-Reply-To: <CAJuCfpEgB8bLMSXPG_K0uaOvALoC1OamKuRosv3Bb=ngiYJz6A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam05
X-Rspam-User: 
X-Rspamd-Queue-Id: 09BDB20007
X-Stat-Signature: efcpjtt96iwogza6juex35x8qg53j5yp
X-HE-Tag: 1772098830-536332
X-HE-Meta: U2FsdGVkX1/HQfiwML37vDaT3DYv7PPP/o6Milrwmx0CxwGg5b2nQ5PbTQ+mVKXc7O3+m+nEL3KMp7qmfW+QeStxZBSsfMUPSZ9g4k4G8DClETm3eez1v+T74GaSIRg5CkCBjiY0jgP4I4iRHX5kkcsQzgT+OuSfBJZQLqTJzz7WVAHU8d+ffVSMD6h+cWw7ithfy6OzOvIp1SH8gDfEqP0kwCI9ZNxVsG2YVblmcmFm+bA7kf0BPAvjziB4xGMWg7810x7Su0hrhykY9rVYWVOvyN+l6CvT9uwY5nm8Jx3WG4GCVisndUb8aTMJn4lV3+iZ9zi/zzqwDyt7U5osA0IZnWcal3GC02LX6pizPMZV/DTm5Kg/HKP62gglSIWn/HOQjZtqDQU0+g6aS/TIVZ5Bhu+yG2Fdh/DP/LdGBh0nuPEw7iQMt9oh/uHMFnz+1Pt446SJ5TJ2RGLpcaOuG8uVZgUrGV65Sk69FuAOi9+lB3BLt1dOgcI7iAEaasUdj7D7GI8WavwRWxtqktXb7JHdUaCc+sndEwE4cexIIrtVh0fufEBNvT7vVnSnmapEKICE1D+SiC/H5OMPAJejDlzTKjrkM79mYoaWHTRYpEJqhCgk3BHjnjy8YMOcxxb88nga1RmnMVxAxxJ9EbZAV4+7VQdUZVmOgiC4xx3HnF0Hu9eIaVdleEXxRdwGr8Y8zmMZQ2lAggD/HB/xLgw8OH8z3FyNO/aPun4J39M3qXA5OiaH/pbQnc9v+ettz91+nHP20mStPTVY917m2PnlP1ILOFKgWN8bgHt8FhNPpahZMFXRfgAAjktBeM4f6gRbKiDgM+evRY1gkFvJeNQqrs0n+mkqOO9U+GmcxpPUBCEiywRt5EAx39rNo+N87VVpOKco52FOcPLukAAR/iBdhStcugfRWQgJkZFhGYkkRkNe3gt9hKFa4SiDYWEC+MbcY6OpRwbZtxNTcTau8xu
 1ZbQIL+Z
 yYegMsPmsQm9a3Rgnfr2nJoxh6cPDljjSqmh0KISyrLNW3sgNHduCyzn3t82+GlRqDpL8BeZU8OYH708Rnv61jhW1rFumf0CtlgCWeJs+dKFAsVeoVPNL8uwIy1VI5MwtKNTsMLopxs97y268Ps/D6xGAQimrtmMguaKKkZcxGfRUlRap7PNX01emNmUlfJZ9TaIV8kj9Yue+L8RGToE3WGIVg5ZX6rWWFrf5AE6LYUZgRBKqxXhedRDeoJTDi1WWXZuGaekj1AIPqZ5ikGRnsEwNIip0i9vNikmyyyWBwwhJlTP8TZJPvHS+7vbdE61fyVknoEEsSV180VBMDCGVR0hsqDNK+4AnpvjLwJ5DhW3shagwR+ctLl/Zn+rJbczbAc+skS5JuUjh/2IsoJbow6kqNZdX+VfzpauLJcCwMwqw12Eld/Ttob2qEXkPXV/yXq9qEKGHSKD48335z43c8sl0LI8Ve878DSzBb9WcqTB02Hg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/25/26 22:28, Suren Baghdasaryan wrote:
> On Wed, Feb 25, 2026 at 9:23 PM Vlastimil Babka <vbabka@suse.com> wrote:
>>
>> On 2/25/26 8:08 PM, Suren Baghdasaryan wrote:
>> > On Wed, Feb 25, 2026 at 4:34 PM Suren Baghdasaryan <surenb@google.com> wrote:
>> >>
>> >> alloc_empty_sheaf() allocates sheaves from SLAB_KMALLOC caches using
>> >> __GFP_NO_OBJ_EXT to avoid recursion, however it does not mark their
>> >> allocation tags empty before freeing, which results in a warning when
>> >> CONFIG_MEM_ALLOC_PROFILING_DEBUG is set. Fix this by marking allocation
>> >> tags for such sheaves as empty.
>> >>
>> >
>> > I think this should also have:
>> >
>> > Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_empty_sheaf()")
>> >
>> > and CC to stable for inclusion into 6.19.
>> > Andrew, Vlastimil, should I post another version CC'ing stable or you
>> > can add that line and forward to stable?
>>
>> I will add it. Note, they don't care about getting an actual email, but
>> seeing the Cc: line in the mainline commit.
> 
> Perfect! Thank you. Let me know if anything else is needed on my end.

I tried to cherry-pick it to 6.19 stable and there were conflicts so I
think it's easier to just remove the Cc stable. Instead I updated the
changelog/trailer to contain:

    The problem was technically introduced in commit 4c0a17e28340 but only
    becomes possible to hit with commit 913ffd3a1bf5.
    
    Fixes: 4c0a17e28340 ("slab: prevent recursive kmalloc() in alloc_empty_sheaf()")
    Fixes: 913ffd3a1bf5 ("slab: handle kmalloc sheaves bootstrap")
    Reported-by: David Wang <00107082@163.com>
    ...

Added to slab/for-next-fixes, thanks!

>>
>> >> Reported-by: David Wang <00107082@163.com>
>> >> Closes: https://lore.kernel.org/all/20260223155128.3849-1-00107082@163.com/
>> >> Analyzed-by: Harry Yoo <harry.yoo@oracle.com>
>> >> Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>> >> Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
>> >> Tested-by: Harry Yoo <harry.yoo@oracle.com>
>> >> Tested-by: David Wang <00107082@163.com>

