Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2958606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:24:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=VyU931Xt
Received: by kanga.kvack.org (Postfix)
	id D46C26B05BA; Fri, 30 Oct 2026 06:24:50 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CF7E46B05BB; Fri, 30 Oct 2026 06:24:50 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C35216B05BC; Fri, 30 Oct 2026 06:24:50 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id A36D66B05BA
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:24:50 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id A69F3160624
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:24:49 +0000 (UTC)
X-FDA: 85378909098.28.742515E
Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	by imf13.hostedemail.com (Postfix) with ESMTP id 0548E2000C
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:24:47 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VyU931Xt;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793355888;
	b=w5aSlo76hSFWLUDPt4RXsh5xyu0yPh+6GF5pxUCAZICl47DlvKdUbSpc+jzDSlG/CeAaEA
	EqfDRBclCrdzPn7CaCzi3R4euScfHcwJbexYelxLHkFbfFy5PikqXnlUCeszddhtrWF+CJ
	nb+jdgiYSkbCCt7eVHQ6JDfE4vVd7TA=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=VyU931Xt;
	spf=pass (imf13.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.49 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793355888;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=CwWE7UOGE7vvkgiGMpiO2wb6+EIxQ8HXhg/iR90K5xU=;
	b=smVwtP0n7PAeiofEvz95d2wbtDzZPuLlbODAM4+/jYiZEqHjewFSXSdx91yCuRgpTfXamw
	E8fk9Pxz0WFdC4ThOUTe2gHoXQJdXl0hn0iIqC6Y8K1cqp3nAwwozdW41l5uzhYLHpCfVU
	mZYi9tpxNpcHKhB0QFF92lO4URADero=
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-1931ff67a29so1501549c88.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:24:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793355887; x=1793960687; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=CwWE7UOGE7vvkgiGMpiO2wb6+EIxQ8HXhg/iR90K5xU=;
        b=VyU931XtGxNd/XOf0U1kS6KLFwWIc4CWd7ngxyfqwqcRiBJJxQRl8IdRrSzEQ4H394
         y5B6RH4IOlTKqI6JyNpRDbJyOzpJo2e97s+igNClXAR+D1FQpICHKDhJWUe55WI2WS6i
         lPJGucs9HPJdL1gJ5h567JRb9fKJkTd9zWJtpWN+/OPNLsEvRe0q4EZt6kjA/A8yf3n5
         r70S+Fz/FESyGvdBJNY34zaILEglrUSoI9fR4KX6/Nqr8VRSzf+4yHWAQiJ8ooFAsDnz
         HB8eL0e/+7xFmpj9LyZU3czmJRUjoP+n7b8bf+XJI4h7mWdy1lILtWBDvPOUp+ixk5yZ
         mrXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793355887; x=1793960687;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CwWE7UOGE7vvkgiGMpiO2wb6+EIxQ8HXhg/iR90K5xU=;
        b=g9GL5OQiG4IPo4jL2Aw+eN06+ZXl1RFKnSq4PSJBhwjqF8mh4kaN18V/3jIDDwKVyz
         LCoz8cJFUZuEXqs1dETIJ8brthQRVhf0fAGSOGGT6ipfNy7ih/K65a3/8CRwz/zxdwFI
         opzUdW+9RUpFRv2aHKPQtevB00SJYZLSPgQ7BOzVATPFYdk08w/fyZ5U7tlW+eQFsAad
         myfXSRy2XDvaKGk4+KOMiQ9cNUDf7giOSM3Zj+1LOrBsBXTSL51TSutcNx9d3rIIzynS
         448q6AnPCSGXdKfxl7ZgL3VR3Cf19V1BLsxUF1IT8fVR27wRkGgdrzzAWJ9znItbyJGc
         A42A==
X-Forwarded-Encrypted: i=1; AKwUvBxviWNCnGEgU7bTyp/hVqVpQueoFU6IjE6Fmgon8meomUgX0mrz+MXsWwgDJxw4MgvRkNpEpkKhiA==@kvack.org
X-Gm-Message-State: AFq9FYL5QowuigSgdJAtUHKLNMdVo9CnJhB8r6tE/uJ4TDXjN0+6cI/Y
	gs0k1/RSPBnxRqZ6eL1uZ2svKWtLcLaZzeWKDBCy0iksPlQfdAzCwtwb
X-Gm-Gg: AYBFou1AQM/C7EzbeVBdmMPIJmE6tsqLzBAevdwW4Y8na+VOaBDbX/cT7T3bqDXF6cp
	2ZB3YS+MJPlOu1C/jKuvadSQO2+AEaCy2PGzM074UI4Q8VR2xBorXh/mJ6iHN6JzIJasIcnUHUu
	CPUl4wqbxRd1b/cUgMBqltLqO/Xv0aslWhdB8ruQs80EZp63dipfxiojmxb/RGEUqdLCZo9w79j
	/Cy9EM5AQCOe91XCCDCc/gRBR7G3LMjVr1vtI81qb2jWQ3RCDyoyHHu5HqYgUHDx0eQX7bO0uCP
	E/QswcKtuxT9DBv2jqTnXRj3WZ6nIl7dTqpWp92gNL2sSJq7gG8Zh2K5ygx8IssaqPcGsFRld4j
	JqBp1YnltM46TROEeCmphvuRAuUGuHphkZdkdDrcvAuPZIKx8qL4UiTSTcg60S7rxbBK7EogqQI
	cwCNNxTiJUvFLIRRsOgQFQ+LnvOMJxry8TEQo167cP8/tahEm2yI+YAIhi5M0onuFethtU/fqdq
	AnN9KvIVLW4uRL7lyOs86I6Uy6sAmC2Yps0+P1TqUXpOF4Qh5QQUI9eAcmN4N4wBWNNIina8n7A
	A0vvuIrjA38lWFwpgJaSNeJ8lk4=
X-Received: by 2002:a05:7022:3b87:b0:196:d6e1:108b with SMTP id a92af1059eb24-1ac59fbfd13mr2589413c88.10.1793355886505;
        Fri, 30 Oct 2026 03:24:46 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1ac1b0a628bsm5805067c88.22.2026.10.30.03.24.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 03:24:45 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: Muchun Song <muchun.song@linux.dev>
Cc: Muchun Song <songmuchun@bytedance.com>, Madhavan Srinivasan <maddy@linux.ibm.com>, Mike Rapoport <rppt@kernel.org>, David Hildenbrand <david@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, Christophe Leroy <chleroy@kernel.org>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, Shrikanth Hegde <sshegde@linux.ibm.com>, Pavithra <pavrampu@linux.ibm.com>, "Aneesh Kumar K . V" <aneesh.kumar@linux.ibm.com>, linux-mm@kvack.org, linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] powerpc/mm: fix uninitialized ZONE_DEVICE struct pages with PMDs
In-Reply-To: <20FE1232-A48B-4F72-8F18-89EFF70EE0FE@linux.dev>
Date: Fri, 30 Oct 2026 15:50:40 +0530
Message-ID: <bj8bwkuf.ritesh.list@gmail.com>
References: <20261029063601.1961415-1-songmuchun@bytedance.com> <h5i4wlx5.ritesh.list@gmail.com> <20FE1232-A48B-4F72-8F18-89EFF70EE0FE@linux.dev>
X-Stat-Signature: opxp79qdgh1pco1kkdswkdtzaqf3i9kh
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 0548E2000C
X-Rspam-User: 
X-HE-Tag: 1793355887-312607
X-HE-Meta: U2FsdGVkX1+SFt1m1I37VUdQyqMinvBa0DRENJVNsX/Rq3sVMzThtH1QBpykwN4N/4+xMY5uofUnPYhae8t2hXq90kEtvfwSHsshX6cb4gyA0b7NReuHT4vZKFkAd1NVrS+B0cKGvaU4Qbny79LPexuQq5eqqjqa9SZlRLpd9FkxrAfnTPIsdQ19649cPQHhkyalpJ5t4nukKKM3VbwUNeS1bFCu8oZu4fp7+4mk2K59oVrMAwWATWpFAD1Wu0O21l+kNVINeMRwzfm0pCqZ7qR3Wa5qHPXWocjo3S5j0HQaSXk88+4LnOgLmQLs/cRmx6r3kBdJclibZz+uIiVPtl9Hwn0cw6IdCHNzhVU7eS0uZEEyYr6oqqUf+8cMfoInHIsH56rWjQCX2MxmYn6JMF1q8a0ddku8dukFWvonQKURDw1DUbi7ZTauOP4WyOhaDB3s5eEtQKBcSf7ZTIGf94XYR+ZxclEhhUd0EshPU9kH5BsUnWrYlAP7870NfBiHyd5rPgwihwwTaUjCX2fyQKTt/vI0r/3yk4IEZF2v19BUy6IexlMxC8lJOjq9ssLQ7WKzU0mHpPvcde2jmG5cCDMJLh83S38Va93ohSslea/Wys4TItggLcyujXYobEB0Fy11bLU1NILgiNtCvvE/fFvCgyNYcgVOrOBv+UMCI6XQObbkCBHLFSlHrKKMNouwkK79RWYR1pvYmqn3vhWR1i5l59hLgt7ayw82i4JQzYoI2iodYlZvDafILGeMK5SoHViUHxcOAqisDahYlLGVQsDaGAb1XMjUJUWRkYbmPyCeRPSF3F7paT8yKyJLDAuEbBR1pspC+lNCBzaLOhHe+Omy+om4rf2MGgCpYTwEHNwD6f4fGZlXPNDITeEFBdEK8vqmz2FDdYqa4DH+9n+sicINBSjos6XZ13kRVJN8mp5YA1wWsKVM3ZMw25CE42tyiB4Gh2XJGgWAnhq2MjM
 K1Wzlhzx
 PY5jlEmb1Fi+rvO+1+nVIKMwg1c/I+w+lB5BXDBlCOPjjIlhl6r8xn2CH2ebHO3C4VzlAvxRLXz0lD/ueaeLm86KNPknrDfyf9gjFSFDzuCltyA9hfEHzHY+ks/uQs0nyncbEPloTN0iR0jGZ+s9/1C83nwDQ55jqCv6rvorzmk3EfqP/Q1NN1DVWj4U3y9kC0YMNCNNg6dRd0W8DBhImH6BNmlQtJQZf3zOwoz/Vvrpslk9Ed91/w/OZK59NgeQ8EaZjnsg/D+JOPc1sdgLkKz8y294l+VB6oA/nkUbvbzESFrUCR8URKyEwJP6wOjXL0VSxYCxmyo2ZZHvkV96tRRs+LiCdshU7/lSv/4DaZ8lw9+BsGWn7NiWMXfbR0ZZ4It5XY2LDXfuq2MtA0uTbzVJxPmyccZO9/a8GgWfA9GD8ADWf8NQGgEYfh5gTrGreyOj8MhXGLZcBvROIazj/+Bmnf9bG8U0iT3CpOaExDbI97L24Rn64misSlvY2g6NyXbPdLZrgHwYQ/FpbXIyNtQscvoOjyf1c3ESqJ+4FsR5eunVGpm/zlySF/PujvlmdLWNsQZmGd3dEzvwtjlaOLlXbNQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

Muchun Song <muchun.song@linux.dev> writes:

>> On Oct 29, 2026, at 23:45, Ritesh Harjani (IBM) <ritesh.list@gmail.com> wrote:
>> 
>> Muchun Song <songmuchun@bytedance.com> writes:
>> 
>> Thanks Muchun,
>> 
>>> PowerPC radix vmemmap population can reuse an existing PMD mapping while
>>> populating a device DAX range whose section is marked as HVO-enabled. The
>>> reused mapping is an ordinary vmemmap mapping: the redundant tail struct
>>> pages are not remapped to the shared tail page.
>>> 
>>> Leaving the section marked as HVO-enabled makes later ZONE_DEVICE
>>> initialization treat the range as optimized and initialize only the struct
>>> pages that would be backed by a real HVO mapping. The remaining tail struct
>>> pages can then be left uninitialized even though they are still used as
>>> metadata for the device DAX compound page.
>>> 
>>> This first triggers a zone mismatch warning in __init_single_page(), then
>>> faults while initializing the pageblock flags:
>>> 
>>>  WARNING: mm/mm_init.c:600 at __init_single_page+0xd0/0xf4
>>>  Call Trace:
>>>    memmap_init_zone_device+0x164/0x430
>>>    memremap_pages+0x43c/0x93c
>>>    devm_memremap_pages+0x3c/0xa4
>>>    dev_dax_probe+0x264/0x3d0
>>>    dax_bus_probe+0x140/0x1c8
>>> 
>>>  BUG: Kernel NULL pointer dereference on read at 0x00001400
>>>    __set_pfnblock_flags_mask.constprop.0+0x34/0x160
>>>    memmap_init_zone_device+0x358/0x430
>>> 
>>> On kernels without these initialization-time diagnostics, the
>>> uninitialized metadata remains latent. When userspace later maps and
>>> accesses the affected device DAX range, the kernel operates on those struct
>>> pages and panics at that point instead of during device initialization.
>>> 
>>> The Fixes target predates the section-based vmemmap optimization
>>> infrastructure, so older kernels do not have section state that can be
>>> marked non-HVO. Backports to such kernels need to handle the PMD-reuse case
>>> in powerpc radix code directly, for example by initializing the tail struct
>>> pages that core ZONE_DEVICE initialization would otherwise skip.
>>> 
>> 
>> Actually that would be totally new code right? It won't be a straight
>> forward backport, correct? ... 
>
> Right. Because it's impossible to backport the whole section-based vmemmap
> optimization infrastructure (48 commits).
>
>> 
>>> Mark the section as non-HVO when reusing an existing PMD mapping, so the
>>> section's HVO state matches the actual vmemmap layout and all required
>>> struct pages are initialized.
>>> 
>>> Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
>>> Cc: stable@vger.kernel.org
>> 
>> ... then should we mark Cc: stable here with the above mentioned fixes
>> tag? Because this patch cannot be backported as is to older kernels -
>> for the reasons you mentioned above.
>
> The comment following the trailer is used to guide stable maintainers to
> backport proper prerequisite commits. It's hard to do that. So I choose to
> mention the alternative in the commit message. But with the help of LLM,
> I found the alternative is also not the right solution. The reason is as below.
>
> That pmd_leaf() path only creates or reuses the vmemmap mapping. After it
> returns, sparse_add_section() calls page_init_poison() on the whole memmap,
> which overwrites any page state initialized there.
>
> Therefore, older kernels must pass the PMD-leaf information to
> memmap_init_zone_device() and let it initialize all real tail struct
> page entries. Initializing them immediately in the PowerPC pmd_leaf()
> branch would be too early.
>
> Another solution is making vmemmap_can_optimize() range-aware by passing
> the vmemmap start and end addresses.
>
> On PowerPC, reject the optimization when any part of the range is already
> covered by a PMD leaf. This ensures that an existing PMD mapping is reused
> normally and that all real tail struct page entries are initialized later
> by the core code.
>
> Maybe it should be a separate patch for old kernels? Thoughts?
>

yes, I think we can do a separate patch later for older kernels. I
will look at your suggestions to see what can be done in that case.


>> 
>>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>>> Closes: https://lore.kernel.org/r/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com
>>> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>>> Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>>> ---
>>> arch/powerpc/mm/book3s64/radix_pgtable.c | 11 ++++++++++-
>>> 1 file changed, 10 insertions(+), 1 deletion(-)
>>> 
>> 
>> I think, this patch should go via mm tree, due to all the dependencies
>> coming from there, right?
>
> Better. I hope Andrew will pick it up once I send a v2 version with more
> proper commit message changed.
>

I think we can add an explicit comment like this then?

Fixes: f2b79c0d7968 ("powerpc/book3s64/radix: add support for vmemmap optimization for radix")
Cc: <stable@vger.kernel.org> # see patch description, needs a different fix for <= 7.3

-ritesh


