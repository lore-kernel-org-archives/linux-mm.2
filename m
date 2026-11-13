Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 281E9606A886
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=B1MqMjhd
Received: by kanga.kvack.org (Postfix)
	id 2D2B26B05BC; Fri, 13 Nov 2026 14:06:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A94C6B05C0; Fri, 13 Nov 2026 14:06:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 198E36B05C9; Fri, 13 Nov 2026 14:06:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DE5876B05BC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:06:27 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5A3E4C0203
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:06:27 +0000 (UTC)
X-FDA: 85431026814.20.25F6FB5
Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	by imf17.hostedemail.com (Postfix) with ESMTP id 65C434000A
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:06:25 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B1MqMjhd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794596785;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=P+hij2RJGRcms9m3f7cKiI6fQXltPcS0EJhEbBOodTE=;
	b=bLGNeTwUvRpximH33SOHWAzl+2Q64WV7Ku57e6Bb71eI2wr3lXwZi5crdcPNqpU5xJi2DV
	D2oWomDtIDiMch2gu/A04gVRrrkT9e4iRRBEbufDfmY4cPp1/lr2RsESOPCNEsPjIUFWP4
	e7t5RzjZ2lP1atQ0vpMmI0ttjci8L/o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=B1MqMjhd;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf17.hostedemail.com: domain of azpijr@gmail.com designates 209.85.128.54 as permitted sender) smtp.mailfrom=azpijr@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794596785;
	b=o2KOrLZxugkV+Xm7Nnc85qJO+QeUq+B2ygqk7PPZ294kWIWHGfto8Jp33+lgtD0nYryDEP
	ZBUTPmGph3PBm7VhAZS+6/laDCNrEG7oUFh2GFAbbFVt2JrV8MCt9O7wfT8qb/dcGO/OZI
	Z7W5f674sNcO4NsngP0zvnViv4FZvOU=
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4a9a8d6cea8so14353565e9.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 11:06:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794596784; x=1795201584; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P+hij2RJGRcms9m3f7cKiI6fQXltPcS0EJhEbBOodTE=;
        b=B1MqMjhdgsf96+EMZvonrw3If760zpxEJxdUypQJH6PzlO4hAraVvMJBbAli/5AEa2
         Xsdf9ncTmEKhAdZetOpSV1p8S4ab7ewjQhgAuhyn+DFhOyPEyu/nbZZnK/u9P5IkFcLx
         p1kt9MOZ4DSwjUfDvvBCb3v54wLEdvos5hF1D/BIXvUJVW6QeSmo3bNOrNCQb7uUC6wt
         IJ0+1q2fMhXVlCt5dfMxn+vRvbI6KRKJZqBrM9Gg2bknTTw4PwbSQ6dxHu9S4rxhjOxp
         DC/tMkGkPa2q+sNxJiV5wmYyxNzu9MXPy18w4Q6GV8qEBnqqack+qikDIgqFdsWYYv6J
         f5yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794596784; x=1795201584;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=P+hij2RJGRcms9m3f7cKiI6fQXltPcS0EJhEbBOodTE=;
        b=s7RHoIzSfV4oSeh0ubr4HqCs99NlP0CHmF+nbq1B+2Pq92vXwTbI5atzRZkN5HieqW
         ovDX37RWZ1GiUfR8IQvgKQdNbBwra6Qo340s+ZrC1lTGqak5tA+7iQraGFv8kxmXgVuY
         Yv+rF9nB/r4DcEVfamRsnAe8zQLZ6YY3M1WbCvIxvZeRksTjKXH+I3MHLMu16pZjgzMt
         /BZBnCGoszn/0MyTVi1X70gNTmmNOXBFg/k9l+9U99MUux9EYt3e6Zg8G4TLNfCO2nJ0
         RyAmvg0b09HZbAjs1Nx8zlB6u67epqPsFdBw2TF8wrj2K04Kmywn0iABSmE4HADCmiKX
         eJxA==
X-Forwarded-Encrypted: i=1; AL+hErEH663bi7KAtxFw6GyP0pnvdClrBQ+8DxhdbHjkh7kfrSMGo7+gllvuPWN2KHP/6v1KRmATdf4USA==@kvack.org
X-Gm-Message-State: APuU4Z8xgcmwZAbykYuX3oExWXbkRudXwBjpMPgRdx8aMVmKX+A3+Sil
	SPrphlSRkGQkz3w8+6qdLvUcvjF4TL74Tm6kQ4I2THtj0Sos9/ySNtKz
X-Gm-Gg: AYBFou1mI1+BDG81jyiIz71mbuso2V7Sk1Rm0N0RN5TQCPiy9JAOZWP3HlQe7SAADBs
	B/89Y4iWQTJPczoVRciOx3sM517x+DSNtxyBNtSYf/dgLB8DQMBhBF4NTcuDdVkyMSq0jOVgH0i
	xuwGsgr/6UgmT6Vqa4oFjc75i311wo9ZnydVmEtTs21t/P+qjTe3DSnaOew6ZZJRxnHu9G+FqFt
	2u/WRUY2+WnHEObLonXR16LPmKp8rvVMuJF2k1wqio+yRmQhjIjZSbEx9YmpgbeR9vbpK5WpO5z
	nBI0G1WBxRxMc9Bbl5bFSnjR6XRRrLrydhnMcqIuVn0S7dZijaQnVBnQtBKvLUQw3PNz27mw+TK
	J/8J+hVFS/1xAGPyEpAYbRQtfq02UK8Kbo/dLO/+pdSvEaf16EEqXSbVkveX34AXKdHUmCcLf/q
	i+15mt0nLri4tzHxq/xCyiT2J4sWEG2B3DjjCtO5zSkTqAiVLZtvVpLPXg3wjdcK6VkXcmc7YBh
	Gv7XvoUJUR3pY0iPjippAGKssLhCOw6lK4rLgFyhmJrmRSr7iIBWmhblteSLsbZje167rC6mEUx
	Od5MzMfHSum1X1bsb5/tDLae
X-Received: by 2002:a05:600c:4e44:b0:4a2:180a:3417 with SMTP id 5b1f17b1804b1-4bb55c5f5admr66669225e9.1.1794596783524;
        Fri, 13 Nov 2026 11:06:23 -0800 (PST)
Received: from [192.168.1.22] ([83.231.69.9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb566220edsm112996755e9.0.2026.11.13.11.06.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 11:06:23 -0800 (PST)
Message-ID: <8f4ab543-66ec-4aeb-8cc8-5279c317008a@gmail.com>
Date: Fri, 13 Nov 2026 20:06:21 +0100
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] Documentation/userfaultfd: document RWP behavior when the
 PTE is dropped
To: Kiryl Shutsemau <kas@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mike Rapoport
 <rppt@kernel.org>, David Hildenbrand <david@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>, Peter Xu <peterx@redhat.com>,
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>,
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
 Shuah Khan <skhan@linuxfoundation.org>, Randy Dunlap
 <rdunlap@infradead.org>, linux-mm@kvack.org, linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>,
 Linus Torvalds <torvalds@linux-foundation.org>
References: <20261113112806.109578-1-azpijr@gmail.com>
 <avcCRLX7unFGeaHf@thinkstation>
Content-Language: en-US
From: "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
In-Reply-To: <avcCRLX7unFGeaHf@thinkstation>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 65C434000A
X-Spam-Status: No, score=-14.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: s4aiedj5z5bkp3u3ch6urcquu63kghz5
X-HE-Tag: 1794596785-953238
X-HE-Meta: U2FsdGVkX1/l7JyPZbjObgM+T+TGkxXv8AJjUeuk83YHWoZedMmOOsuNmW2PPyJR9iq54swP3yMm60OO3ziO0oTNeh0+0qXZqH/JE4RoZ9dRQdLPkUjGHFr0h83UY6KNzMMCG2kH+uSzA3Ptd+td6ecAc8EFn+j7k+G4CKD+934cV1otexhWhLK45VjVFQw1pmzdwVRYAMIXXZq6eP/KGOwf8kSSvcTZbenpj05ylY8gK3VDZxtDCIyp/lDjHwY1zN8GvqEGkgK6uoa+61ttdA0EAN+cADW2+jJMzDOylfhj7ZzMHMgdsFI2pjnpTPqJYX3gt860gaBxonTENX6v/OLz5GmH/QtK3v4nHjnIlYKDQUeph4kHmoQsYyLsNIAVniI5W3dvW2Ipuris601A6D+jMwCR1IP0SNyjrmFy6669l/iBWZX/d59IPJqIDurmv33YrSbdV14LOb6StnAfNFBzLN5OtTJplaaGa7Q0uisq9JV+l8/3ilHcj0XuaSIr4XFRyxaOd6N1ZFcdl6tBs9ffGSNNHZFYsM0R5v0fhAsw7HcDdexfT+4nFRgYpI6NAcLlwEMFJoUNCqzs9QLUQclRb2O9Kse8wb3LyLuwbdl+mWrBVc1lnGJgmdlrGBQsUVaN6GdBq7I1owPoLm/82w3zCKWVgyw2NPrWGVoIcpvOR7f14BdCAi5WOVU4zvBcYTOt4cMG5RreJ95VFCiOWAFndcWPvDlByqG2o38NZO+hBj4z+X71ELOJ8Qh0UwHpu7FyxOIGT5hNOsKSfLKGH6Ixl3B7EKY666AgTrYsSOvgGSYPAqxJXoPbdblKUAL9VHa/BC6hlTUMIq8Pi4YmnpA2KWYraXqSIA5H2zAUO8V8GKxEnJj0tJnAKkO0yGft/WUwJpwQHfFZANJRS8/YvvEVZfDPizbI3VyciEMWAp4JZxrGyi3GlPLlzTTmUKkb21vkWsP64x6S6DypLuz
 XjA+yh82
 8sEq83DmmBT8hkDFC20tOMTB/u3fJQgR0clK08P5KuJJO32MpYTDjhZ6pEVeRQ1/NLsIL0mCxP5fLU+GbVf9y9c8EoE4wVJFPUyG93e10t4DntDbE9QTnZOoxa1MCJ56aOWIDTFkRjPxYgiGbvf23rTNgpjvAdnDcofNBKrb8XW3jbyozlG/VHuj4QCAiydOHNTEMqUPlFWpE8tHZhDbOsbZUhJ+7UkvU1YKUPB091+xxRh1equceeq6wSX3NA0Ufa0vZ45sn3KlynN0T5C9uuiTlup+6xhLc2nNHSxtwYPcZMFBEGLbkMLH8pnfkZ7+H+Ml3KEC5uJfvA1HWxJgcbBxTd+zpDI7p7PvVqIa3ZBaZrdoCzO05W4T0Z4Tra4f2Ocs/U1xgbaneJ6RdZgldaVvt9f25cETGVT3CIaOwmmnmM7lHwNbeHZnTfv0xVgoIK0TS7hsFFUwMxQohoZVjntseZvwY0rdMhb2wvW+N37tt5V00RFhtU7c8+padpVv4H3wN/GY9ZDF4EHI=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 11/13/26 1:44 PM, Kiryl Shutsemau wrote:
> On Fri, Nov 13, 2026 at 12:27:42PM +0100, Jose A. Perez de Azpillaga wrote:
>> "Scope of protection" lists only the PTE drops requested by the user and
>> says the range has to be re-armed afterwards. On shmem the kernel drops
>> the PTE as well (page reclaim, collapse), and RWP has no marker by design:
>> the next access is a minor or a missing fault, and the user is expected to
>> register for those. Document this, together with the modes that sync and
>> async tracking need.
>>
>> The VMM example registers guest_mem with RWP and MISSING only, so a vCPU
>> write to an offset that is not mapped there can be lost during eviction.
>> Add MINOR to the registration and describe how the handler treats minor
>> faults.
>>
>> Link: https://lore.kernel.org/linux-mm/856cdf21-7982-475a-b244-a7ceff4eb6aa@kernel.org/
>> Link: https://lore.kernel.org/linux-mm/avWnaR7VVEGa7yNp@thinkstation/
>> Suggested-by: Tal Zussman <tz2294@columbia.edu>
>> Signed-off-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
>> ---
>> this is the first time I'm writing documentation, so I accept any
>> suggestions to improve it :) and I tried to follow the documentation's
>> own style.
>>
>>  Documentation/admin-guide/mm/userfaultfd.rst | 65 ++++++++++++++++----
>>  1 file changed, 53 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/admin-guide/mm/userfaultfd.rst b/Documentation/admin-guide/mm/userfaultfd.rst
>> index 97daea83b7f1..19bdac668f93 100644
>> --- a/Documentation/admin-guide/mm/userfaultfd.rst
>> +++ b/Documentation/admin-guide/mm/userfaultfd.rst
>> @@ -384,17 +384,45 @@ normal missing path (``do_anonymous_page()``, ``do_swap_page()``,
>>  the population itself, co-register the range with
>>  ``UFFDIO_REGISTER_MODE_MISSING``.
>>  
>> -Protection is preserved across page reclaim: a page swapped out while
>> -RWP-protected carries the marker on its swap entry, and swap-in restores
>> -the PROT_NONE state so the first access after swap-in still faults. The
>> -same applies to pages temporarily replaced by migration entries.
>> -
>> -Operations that drop the PTE entirely — ``MADV_DONTNEED`` on anonymous
>> -memory, hole-punch on shmem, truncation of a file mapping — also drop the
>> -RWP marker: the next access re-populates the range without protection.
>> -Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``), there is no
>> -persistent RWP marker today. The user needs to re-arm the range with
>> -``UFFDIO_RWPROTECT`` after any operation that explicitly frees PTEs.
>> +Protection of anonymous memory is preserved across page reclaim: a page
>> +swapped out while RWP-protected carries the marker on its swap entry, and
>> +swap-in restores the PROT_NONE state so the first access after swap-in
>> +still faults. The same applies to pages temporarily replaced by migration
>> +entries. Shmem is different: reclaiming a shmem page leaves the PTE empty
>> +rather than installing a swap entry, so the protection is dropped along
>> +with the PTE.
> 
> Migration is not anon-only: migration entries carry the uffd bit for
> shmem and hugetlbfs too. Keep that sentence out of the anon part.
> 
> And please call it the uffd bit, not the marker. "Carries the marker"
> next to "there is no persistent RWP marker" reads as a contradiction.
> 
>> +Operations that drop the PTE entirely also drop the RWP protection. Some
>> +are requested by the user — ``MADV_DONTNEED``, hole-punch on shmem,
>> +truncation of a file mapping — and some are initiated by the kernel on
>> +shmem: page reclaim, and collapse into a huge page by khugepaged or
>> +``MADV_COLLAPSE``.
> 
> I would not list them. The list is not complete: splitting a PMD mapping
> of a shmem THP drops it too. The next tool will find the path that is
> missing and report it. State the rule instead: on shmem the kernel can
> drop the PTE at any time while the page stays in the page cache or swap.
> Reclaim and collapse are examples.
> 
>> Unlike WP (which persists via ``PTE_MARKER_UFFD_WP``),
>> +there is no persistent RWP marker, and this is intentional: once the PTE is
>> +gone, the next access takes a page fault that userfaultfd can deliver, and
>> +that fault is the notification. Which fault it is depends on what happened
>> +to the page:
>> +
>> +- The page is still in the page cache or in swap: the access is a minor
>> +  fault, delivered if the range is co-registered with
>> +  ``UFFDIO_REGISTER_MODE_MINOR``.
>> +
>> +- The page is gone: the access is a missing fault, delivered if the range
>> +  is co-registered with ``UFFDIO_REGISTER_MODE_MISSING``.
>> +
>> +WP cannot use the same scheme — a minor fault would trap reads as well as
>> +writes — which is why it needs a marker.
>> +
>> +Without the matching mode the page is mapped back silently and without
>> +protection, so what to co-register depends on the tracking mode:
>> +
>> +- Sync mode: the access would be lost. Co-register shmem and hugetlbfs
>> +  ranges with ``UFFDIO_REGISTER_MODE_MINOR`` (and
>> +  ``UFFDIO_REGISTER_MODE_MISSING`` if the file can have holes), and
>> +  anonymous ranges, where minor faults are not available, with
>> +  ``UFFDIO_REGISTER_MODE_MISSING``.
>> +
>> +- Async mode: neither is needed. A page faulted back in is mapped without
>> +  the uffd bit, so ``PAGEMAP_SCAN`` reports it as accessed.
> 
> The registration is fixed, the mode is not. A context that switches to
> sync with UFFDIO_SET_MODE, as the example does, needs the sync
> registration. That has a cost in async mode: minor faults are always
> synchronous, so "async -- no vCPU stalls" in step 1 is no longer true.
> 
> Getting it back would need MINOR to follow UFFDIO_SET_MODE: in async
> mode, map the page and let the next scan report it as accessed. That
> could be a future project if the stalls turn out to matter. For this
> patch, just fix the comment.
> 
>>  **Fault Handling:**
>>  
>> @@ -486,10 +514,16 @@ never traps on its own ::
>>      ioctl(uffd, UFFDIO_API, &api);
>>      if (!(api.features & UFFD_FEATURE_RWP))
>>          /* RWP unavailable on this kernel/arch -- fall back. */
>> +    /*
>> +     * MINOR: an offset in the page cache but not mapped in guest_mem
>> +     * would be mapped back without a fault, and a vCPU write between
>> +     * the pwrite() and the hole punch in step 4 would be lost.
>> +     */
> 
> Not yours, but the "if (!(api.features & UFFD_FEATURE_RWP))" has only a
> comment as its body, so UFFDIO_REGISTER becomes the body. A second
> comment between them makes that harder to see.
> 
> Adding {} around the body comment of the branch can help a bit.
> 
>>      ioctl(uffd, UFFDIO_REGISTER, &(struct uffdio_register){
>>          .range = { guest_mem, guest_size },
>>          .mode = UFFDIO_REGISTER_MODE_RWP |
>> -                UFFDIO_REGISTER_MODE_MISSING,
>> +                UFFDIO_REGISTER_MODE_MISSING |
>> +                UFFDIO_REGISTER_MODE_MINOR,
>>      });
>>  
>>      /* Tracking loop */
>> @@ -550,6 +584,13 @@ progress. After ``fallocate()`` punches the page out and ``UFFDIO_WAKE``
>>  fires, the vCPU retries the access, faults as ``MISSING``, and the
>>  handler resolves it with ``UFFDIO_COPY`` from storage.
>>  
>> +The same holds for an offset being evicted that is not mapped in
>> +``guest_mem``, except that the vCPU blocks with a
>> +``UFFD_PAGEFAULT_FLAG_MINOR`` fault, which the handler leaves pending until
>> +the page has been punched out. Minor faults on any other offset are
>> +resolved with ``UFFDIO_CONTINUE``: the page is mapped without RWP
>> +protection, so the next scan reports it as accessed.
> 
> "Any other offset" is too broad. A cold offset that step 4 has not
> reached yet will still be written out and punched. If the handler maps
> it with UFFDIO_CONTINUE, a vCPU write between the pwrite() and the punch
> is lost. That is the case MINOR was added for. A fault on any offset
> this pass will evict has to wait until that offset is punched. The same
> goes for RWP faults.

thanks for the review! I'll address all of it in v2 :)

-- 
cheers,
jose a. p-a

