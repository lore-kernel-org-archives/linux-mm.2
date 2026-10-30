Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E33FC606A31A
	for <linux-mm@archiver.kernel.org>; Fri, 30 Oct 2026 10:20:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=e7wIe6pb
Received: by kanga.kvack.org (Postfix)
	id DB6736B05B7; Fri, 30 Oct 2026 06:20:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D67206B05B8; Fri, 30 Oct 2026 06:20:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7A9C6B05B9; Fri, 30 Oct 2026 06:20:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8A8046B05B7
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 06:20:28 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 88D4D140626
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:20:27 +0000 (UTC)
X-FDA: 85378898094.26.078447F
Received: from mail-dy1-f181.google.com (mail-dy1-f181.google.com [74.125.82.181])
	by imf16.hostedemail.com (Postfix) with ESMTP id DD4E9180005
	for <linux-mm@kvack.org>; Fri, 30 Oct 2026 10:20:25 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e7wIe6pb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793355625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:content-type:
	 content-transfer-encoding:in-reply-to:in-reply-to:
	 references:references:dkim-signature;
	bh=47HRSEMYaHZPzJWzqw3IojT1EDL4QQpT831/3j+yFnA=;
	b=S5GGEJMSXNzhw6X8cRZXnNDnBqL4Uk9uD1l2qV8JtsJv2OjnG2dJG5hobeDG4nDITCJoc+
	D75/AvynphMbme6a5LMyfcTEx689U8qXR8l6QmMrCbmzR82R8Nwgy/w1mZ0zv1b8ti+fbu
	/LddGIuwi+DzCCnyKB1yUdJ0X0vToL0=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=e7wIe6pb;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of ritesh.list@gmail.com designates 74.125.82.181 as permitted sender) smtp.mailfrom=ritesh.list@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793355625;
	b=SL9Iq+38NnUWUH8fWrqEpp7EPRU/fmEoPmaLOZVwKbnYRkjyd1C/8lrDQimprW7hGu8y2r
	Vn8kTvCha6nFc2cqTYMeVSUOyPTRr/O3Xmf5WbuhypAt4g+E1uwsNm2WrqpVxiYWDWZn/Q
	/1napEGPf3ogAOIMivVBsiAtgxfXnHk=
Received: by mail-dy1-f181.google.com with SMTP id 5a478bee46e88-36661f953e4so874342eec.1
        for <linux-mm@kvack.org>; Fri, 30 Oct 2026 03:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793355624; x=1793960424; darn=kvack.org;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=47HRSEMYaHZPzJWzqw3IojT1EDL4QQpT831/3j+yFnA=;
        b=e7wIe6pbw5HtqhcMOXNYHFUUvZEGt+lV67XCxiRDzCpJ6p+C2XUnQz4xGoZxBXmctB
         njodwgVdwCvSEKBa4F6RasG+oXSASKYvBcTF9pVq/EFZbco/5hkVnehDoQ8rP4a1kh4H
         R665fnm7RKkZBA8y08YUPjRkDoBLCsYP1B//Kj0Zis2OJYTP3WoapsPduduaejEjYPzj
         Y1IvCIssTpQhzlQtRmr9v5cNmKWm1lOqRZM6i8iM5hfDj1WSASjFvNQO3h0Oiy6HTfkO
         she9/BlGb37ftKhZD+vD4/Bz68ewXvqCk8ejQzkm17YMhoe07D/3bVD40AvyPOSErNQ9
         N3fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793355624; x=1793960424;
        h=references:message-id:date:in-reply-to:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=47HRSEMYaHZPzJWzqw3IojT1EDL4QQpT831/3j+yFnA=;
        b=r8iGyWFs/LFpbaU9ZmYSxXhVW/BbUM/Vofqos4GRipbdIbawAOoOE+22BqDmiCG2gf
         4WNsWiJziMEZni6Dz4ZaEWhtgE8hvoSDFOKDHaXfc/1CiFZpB1Hks/yGCOfHEljpHFr7
         wya5Rb4NunFMFegHRKLe45c6KBkMsRIZO95Xse1N3faoL0bZmI72RzxD3noYJMMKigCr
         P+p7s+vktZquHRpUZgx5yYVJ+0VuE9/gp31xuSMnO8MpRcs6QP/PFjijJSVKR95w3TL/
         sPejhACydZVhnItbOdLt+dEhKI7vWk/NkPXChCKIXlyZrO4jva9bekZ3OX0B+VYHl9gl
         uONQ==
X-Forwarded-Encrypted: i=1; AKwUvBwkP6/9KL/ocHVKIySupE0I3aKzt0UyftlXIsXGC073nEuhDe+3oW0+qhag7tTqjepnGzN6ad541g==@kvack.org
X-Gm-Message-State: AFq9FYJKdz+6iEtZ25OZRieP4ebux+KFfvMnlqv0BlgRWfqLuagR9Tlv
	wTfSPlr/oBzq8CCMfRPNeh9T84Q9T+Lddl6u1hPKtoNeb5Bl1BhR4FaL
X-Gm-Gg: AYBFou1lGQ7azlINCg9AZBoNUn46+KqZaXi6bhDAzAXWHsKLZWcXnreKtqYjqOYP2X8
	8HFGgqEpoN1ejaIuuW6LdjTolRezA45Ewgx5oiOT1lzDihq06HTWVxMh86Yfzs6KmnSKcVNljpf
	/IQnQeOojZvFjSVqlOwY4nq6TOdyKNSxYY6aFGoOxmpoJsSVR8feJUcYvhubLo1SUPhXYriioCy
	nI8o6reeDdTiSiE4ECku6BAvWgzPbyr2koqZgjFAwwcaGHvYJ6i2/xYIRszwM7TgQQrZbRIHuHp
	NsYPIOysnlsnfCst67H0LZAkTvgphl9dQfrUZXkJivHmqQjXwfaJFSCAo9Lk3l2II0J5q3p99u9
	H1kwEP6Gh4S6KGMcVlfc7aC5CeGWhzM8PRW2jFlWaGY8dCJQVC+xt3Gt1ZOW1AbBDnJYEq4HcXF
	UbnQE8ciw/QNxi9zAgddtDIwsdg6IwzWm7YDdcSPBM9jyEgZtXjO+wCGML6TcGleg5y8g3OTBri
	hZHMg+jXGf9/+s6dRyZfbERnct78dvld8xrzUowr579IEyGRabTxu4JaV3s3PWXW0O/KuQlGS1U
	vfiQXRrgFbtb7qjaJ/D3Lc9rZ60=
X-Received: by 2002:a05:7300:c00f:10b0:36a:1470:da0e with SMTP id 5a478bee46e88-36a423bececmr3563726eec.29.1793355624408;
        Fri, 30 Oct 2026 03:20:24 -0700 (PDT)
Received: from pve-server ([49.205.216.49])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a42662f23sm7607181eec.2.2026.10.30.03.20.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 03:20:23 -0700 (PDT)
From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
To: "David Hildenbrand (Arm)" <david@kernel.org>, linux-mm@kvack.org, Andrew Morton <akpm@linux-foundation.org>
Cc: Madhavan Srinivasan <maddy@linux.ibm.com>, Venkat Rao Bagalkote <venkat88@linux.ibm.com>, linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org, Muchun Song <muchun.song@linux.dev>, Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, Pavithra <pavrampu@linux.ibm.com>
Subject: Re: [PATCHv2] mm/huge_memory: set the mmu_gather page size in zap_huge_pud()
In-Reply-To: <19012a9f-7a8d-4eb2-a441-cdb04184890b@kernel.org>
Date: Fri, 30 Oct 2026 15:45:04 +0530
Message-ID: <cxsrwl3r.ritesh.list@gmail.com>
References: <8b853e5f9f16145859407b28af654b0f79e12642.1793318297.git.ritesh.list@gmail.com> <19012a9f-7a8d-4eb2-a441-cdb04184890b@kernel.org>
X-Rspamd-Queue-Id: DD4E9180005
X-Stat-Signature: dx8csoounarmd9mi56unr4ye93ginff1
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793355625-232297
X-HE-Meta: U2FsdGVkX18AtRDHZB4FJwUqGXnk5my/iGlwdqAbOFat7OU77w567+vPmYWhGsRXRwhIpSCKUdmNoDM8Udh3uur+3fOfokTwyT9CIfbSfHOh60EllxjrViddJkwPig8xMY4RkuSVRBi/xj2ee2YrToSO8A14XgOJaP3gcAxDB8V+WLo6Ry/fD/2RVytSHZLFjkK19P3IlV0KhL4zbenEURrtJtz0VlcloREcpWfzhE950py6H0KWJ4nvk+CbOql3ApObOivCK6ujbeTQrD2xFfdYW3OAdnfUyqttHA802FQO/UFX+B2mz7Z22mpsIoZQbqq3c7SscdNsc6tyOELXiCIOlBMrxWtB5UJsIGM4aGDv0gWEFr/mDmG27l3h0nOi09WlstVypay6Rjh/U9kj06dKfyukQf36M6soH7Wcv9gAG6VXeyQzLq2Y1Wr+SCKp7oMVLPVvNUGzf2w05s6kDE06j+le3VqjIohmKeFRzD30EyX3U6cMGa24FWRat7mQm+NYsuKvFJQ4r/JWzUViya6eNVqp+FksZ7ldWT/y+zRHg6WUuYBxEMNeFcn/07SyYohw8vxWxHNDiHU0Rs3+lg5E4G/QxAqEBxCoy7yQ8GBKFsQrDoBD4A3D4tdim/JJLVCygeeegHmunPZYPFHGmb0Xd474Hmlrb/6maMuKFnwTDYQRJhNuc68JyFwNz13nUi6w9l2rHlS/xFRbOTPagabUyTR/ioi2SbgNk7jTCE37lTUw4Ocztyanky2Zttg0dAyIX2Q/mYnVxSnZ9rwQ5KqJqxjg2AVdofH2S5oU4P7cDkOveoKXHbsP/Ktu25v0ydd7LcaGQdFFS3mr7NjL+5DCjYgKaKqAl5X4w0kL4igUPpFmusvcttGeZft8suzwbrl/MRTX/6mRJ87clH9tZJghmo275s114tM8RrOWcwNUqAfBZH6sZshLqPuD6S5Jb42kKNCPTU4FrhNeW0w
 vT2cBVbe
 3cszkUqJjGJ9zFIPrtPXDjSklGaCe1+mHCBsCUAU8vOG/ZU3MscGB57xyZGzuyPZ6N7fHwJzNjkt4ogDe71hNnT579l9VJisMZx6FxxVNBrOvnfhbKA2P9N3dwwX/wiFQJBMWJdNPU6pMnT0V/B0DvbRUoGHje7h0A+qPNkI+wfGNHrU9nHrT6U+JPVhenw09TnRP3AqoIMoFLI3UGNp88yUfdMMFg6mOmqb3mMb3qAc0CPzQHJc0nuW/Qcv58P+LdyIuq+1T8Q0TkekaNwIleme3h1NrcFPxrOLu3VdsN/IwgvE+WILaeR0yZeZmqlHS2LiKf9B8evaR0yK2NWUE4gLBsLhughH14cy2vLcJwgcQj+gsdOAhriUk72ZYMOmn3i6NjB/63Dw1xL0GI4ulNKU7OSEpJ6yL8ldP/6FNteC0JksrDkv0MCtOPCRYIbQWtqOBusYTgsMvYhB+PqJdPVJsKIIfXn0IyU68Pi/pt5exfGFIlJMIswtf7shGeywP2ycS3wBPWRRDAMAjnddzdnXhQycSU4lgfqxgkIHmZJ9AesIZcdR4WSNL3A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1
X-Archived-By: <archiver.kernel.org>

"David Hildenbrand (Arm)" <david@kernel.org> writes:

> On 10/30/26 01:07, Ritesh Harjani (IBM) wrote:
>> Unmapping a device-dax mapping with 1G alignment on powerpc radix kernel
>> built with CONFIG_DEBUG_VM triggers this warning on every munmap:
>> 
>>     WARNING: mm/mmu_gather.c:176 at __tlb_remove_folio_pages_size+0x38/0x230
>>     NIP [c00000000063d508] __tlb_remove_folio_pages_size+0x38/0x230
>>     LR [c0000000006fb688] zap_huge_pud+0x1b8/0x2d0
>>     Call Trace:
>>      zap_huge_pud+0x170/0x2d0 (unreliable)
>>      __zap_vma_range+0x1604/0x1e20
>>      unmap_vmas+0xa0/0x1f0
>>      unmap_region+0xb0/0x130
>>      vms_complete_munmap_vmas+0x120/0x310
>>      do_vmi_align_munmap+0x1ec/0x240
>>      __vm_munmap+0x148/0x220
>>      sys_munmap+0x28/0x40
>> 
>> To trigger this - it is enough to mmap() /dev/dax0.0, touch the first
>> byte so that the whole 1G is mapped by a single PUD and then munmap()
>> it.
>> 
>> PowerPC needs MMU_GATHER_PAGE_SIZE in which mmu_gather needs to record
>> the page size for which tlb flush is needed. zap_huge_pmd(),
>> zap_pte_range(), change_huge_pud() etc all do this already. However,
>> since commit:
>>   dbe54153296d ("mm/huge_memory: add vmf_insert_folio_pud()")
>> 
>> a device-dax PUD maps a real folio and zap_huge_pud() now hands it to
>> tlb_remove_page_size(tlb, page, HPAGE_PUD_SIZE). At that point
>> tlb->page_size is still whatever the previous user left behind, which is
>> 0 for the fresh gather set up by munmap() and so the check fires.
>> 
>> Fix this in the same way like how other similar paths do.
>> 
>> Fixes: dbe54153296d0 ("mm/huge_memory: add vmf_insert_folio_pud()")
>> Reported-by: Pavithra <pavrampu@linux.ibm.com>
>> Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
>> ---
>> [v1]->v2:
>> =========
>> - Split the 2 part patch series. Patch-1 is now superseded by a different patch
>>   from Muchun which he already posted [2].
>> - No difference in this patch from v1.
>> 
>> [v1]: https://lore.kernel.org/all/97f85592bb78a273be8519e6897e7f9b9bd31469.1793070429.git.ritesh.list@gmail.com/
>> [2]: https://lore.kernel.org/all/20261029063601.1961415-1-songmuchun@bytedance.com/
>> 
>>  mm/huge_memory.c | 2 ++
>>  1 file changed, 2 insertions(+)
>> 
>> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
>> index bd44d58e8684..7e589a2fb02d 100644
>> --- a/mm/huge_memory.c
>> +++ b/mm/huge_memory.c
>> @@ -3040,6 +3040,8 @@ int zap_huge_pud(struct mmu_gather *tlb, struct vm_area_struct *vma,
>>  	spinlock_t *ptl;
>>  	pud_t orig_pud;
>> 
>> +	tlb_change_page_size(tlb, HPAGE_PUD_SIZE);
>> +
>>  	ptl = __pud_trans_huge_lock(pud, vma);
>>  	if (!ptl)
>>  		return 0;
>> --
>> 2.39.5
>> 
>
>
> Matches zap_huge_pmd().
>
> I will wait a bit  and then queue this shortly.
>

Thanks David, however, looks like Andrew might have queued this up in
his mm tree [1], right?

[1]: https://lore.kernel.org/all/20261030021905.2DCA71F000C1@smtp.kernel.org/

> This sounds like stable material?
>

Sorry, my bad. Yes, we should have this Cc: stable@vger.kernel.org.

Kindly let me know if I should update the tag and send v3, or can it be
taken care? Thanks!

-ritesh

