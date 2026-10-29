Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A6AD9606A31C
	for <linux-mm@archiver.kernel.org>; Thu, 29 Oct 2026 16:31:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=hlyTcWa9
Received: by kanga.kvack.org (Postfix)
	id 938EC6B05B6; Thu, 29 Oct 2026 12:31:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 910706B060C; Thu, 29 Oct 2026 12:31:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 800536B060D; Thu, 29 Oct 2026 12:31:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 515C96B05B6
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 12:31:56 -0400 (EDT)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8C4A68047C
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:31:55 +0000 (UTC)
X-FDA: 85376205390.20.CAC86BB
Received: from mail-qt1-f174.google.com (mail-qt1-f174.google.com [209.85.160.174])
	by imf21.hostedemail.com (Postfix) with ESMTP id AB6751C000B
	for <linux-mm@kvack.org>; Thu, 29 Oct 2026 16:31:53 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hlyTcWa9;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793291513;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=alj3tH3ZvQk6KSugbPj+OZJPkIUe62frupKKgUNXdQQ=;
	b=OYEJGJFw8QWEM/YJxRrFB+MhphWjzCEvsHaKxBJiMtjeEzIbqvbVlTXRUfS7zvzVm4j5PZ
	xGvUbOrC/DsFEmF/KUWY7XG6AFPQNr7R5LipdcH2SeY2hH4KNxjVgeYI3DOW5ksGzg+PK4
	6DPeElm3NlsWHR7OWuO50xMLUNDOy6k=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793291513;
	b=gMlP/XJEqtiVjMxer/9e980Fb8Z1a9uehxtMwRtsHMauoC1tBOskpi7OVwrK8rtSy803lb
	lwGUQR+MkWPHB37O8ZQgGe7VcEJbbD0EpDdcuRbx6tGGsVqwxXJ9hO8SbwAMj5RiXq8V7j
	ZjLjW7KiSIlQZW6dhQmSWZlOQCyfG0E=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=hlyTcWa9;
	spf=pass (imf21.hostedemail.com: domain of gourry@gourry.net designates 209.85.160.174 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qt1-f174.google.com with SMTP id d75a77b69052e-535179e995bso22464301cf.0
        for <linux-mm@kvack.org>; Thu, 29 Oct 2026 09:31:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1793291513; x=1793896313; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=alj3tH3ZvQk6KSugbPj+OZJPkIUe62frupKKgUNXdQQ=;
        b=hlyTcWa9rbE4DhcmdKTIpAlR+KXvUew8d0bYd3HL0WkcPJXo84fRv5FslsX9cFT302
         oODEnz5F1Cm5830K70ZdhN2uqLhS6P596yGrC7Kp49bREqY1MyGbZ9bQlXkPKQUof/yZ
         y21yTy27ZOCe4+6yNxZz8Yo0pLWWlwm6RIQ8aTQ/U3KkXEBaE38/LTp5j7javP9jTyKQ
         ibPL3pEcIBPjX6dUikFVi0ywyLRoeGcYhZZLd1WI//0g1FyEsRV5ogfm0xM0t65UJSRY
         qsaHES/yNvWAw/OtBsxy8mWLnWL8oNx95JGkp6M8WHX/IglksZPwfzmOQrrYJpji2Oe4
         AxsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793291513; x=1793896313;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=alj3tH3ZvQk6KSugbPj+OZJPkIUe62frupKKgUNXdQQ=;
        b=Uql+HhZpUWuYuoaJaGn3u9vzodYAtB9AYCXNs45f6VQqSsIA6OudS6ReFGylQiQmTP
         F6y9JWbSbNue2zO73MWvlcb/6BFF3e+8MZxrHZv7vE0NKL5xySU9GzgtJgvecVxwYAXk
         SO6NSvqXeIhpji+f5s7d9rq78t63hUTPArW1Mhtqzj4SEXvFiwfusD1vUFdzJXkzA64j
         PhwLnmuK1IlSB2cCj+q+dfw902+AGEmljs927EAAPHpVVaADEWYSkz41WcVHV2vW/Fth
         QKzrHYSI3wKzeUf3G9DmFoUjxgKE3cYjlG3frWhvCkhrEq3NFpIwasGTcxkpfq70W6kr
         H11g==
X-Forwarded-Encrypted: i=1; AKwUvBzuBoEWO8AActJ4AsNAOio6AVfcqvABIHGtfGKe9O1Bn8YJg2KZV9tsChV1Qoq+SLQ+mLZ+q0lvcQ==@kvack.org
X-Gm-Message-State: AFq9FYIY3jkPqVDY70kf15L9G1P+jy6FPubIZYYAUvPV+7p6eLZVRJFa
	+x28BhFSOTPVmO4dGw0xHCrEZg3Cy4DTA394LrihURLivORgWce5O58A1eWG9DFRS7Y=
X-Gm-Gg: AYBFou2JO3L+D8UKc73vpNkNJwO4MuO3SIqY010m81q2fU45Xif3GXiii/9/Uh5eGVy
	VsFJUwFwWCl+0/HFFjYYQSGSrny9VEV2I9xDFWmVQVMAqV4u5Ahiv77mkgPsOiQeoKZJ+/h+oC8
	h4RsmAepJSI3oH25IbgTl56PGG5wivFV3nsw5jy++ETpInMrWfTpEMc83Pw69ATHo2QCgWwIEfb
	G03stxiTSuTPFkMm0TuNRwFb4Uhjm4q15kqExfEMJDQK2ezQxWkyInNErk7aHCRfYKZ3yoF9n40
	kew7MYOkVder+/6UOLbEZKTxz3pS7e1yvC+B6C5F0P/bnPWopZ+QNYCij2PyMYv4gL5pWo8g/+8
	v01wl5ozvN0UC5sTonuNVneVdjzaBhHp6KTVrdcAbvCTBAaZbg2jCpW/yGZgqLBPz1mAmblHyo7
	+HxmKOrK8WiZn2DBp5F/+6iNaixwBTWIKnww4ZZejK2FajUdjrCF5fHSvq8KjhvcEhYluK3v+pY
	vRvnRadlBssvi92WZX52Y21sJwIWhyEM8NTgFK3+KIXJjFsTJzYhrPq0NqJmu05mag0BDCbWTe5
	lnw3TVHFhpBTHGomS9JIrSgVTafk5BXc+Cy56l2LzPWoX/LvrbK6LxAnhlIa3qIZvlmn0qECDy+
	l
X-Received: by 2002:a05:622a:888f:b0:535:a5fc:3b58 with SMTP id d75a77b69052e-53fcd191600mr104371091cf.68.1793291512757;
        Thu, 29 Oct 2026 09:31:52 -0700 (PDT)
Received: from [192.168.86.58] (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-5428cccee9asm45321cf.13.2026.10.29.09.31.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 09:31:52 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Subject: Re: [PATCH v4 1/8] mm/page_alloc: reset can_retry_reserves when
 the slowpath restarts
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: "Gregory Price (Meta)" <gourry@gourry.net>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, kernel-team@meta.com, muchun.song@linux.dev, 
 osalvador@suse.de, david@kernel.org, akpm@linux-foundation.org, 
 ziy@nvidia.com, joshua.hahnjy@gmail.com, rakie.kim@sk.com, 
 ying.huang@linux.alibaba.com, ljs@kernel.org, liam@infradead.org, 
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, 
 brendan.jackman@linux.dev, hannes@cmpxchg.org, mgorman@techsingularity.net, 
 anshuman.khandual@arm.com, stable@vger.kernel.org
In-Reply-To: <68fd8182-cdfb-4f11-95de-1472e6c92d33@kernel.org>
References: <20261028211930.3504634-1-gourry@gourry.net>
 <20261028211930.3504634-2-gourry@gourry.net>
 <68fd8182-cdfb-4f11-95de-1472e6c92d33@kernel.org>
Date: Thu, 29 Oct 2026 12:31:48 -0400
Message-Id: <179329150807.2127828.16376500334625424120.b4-reply@b4>
X-Mailer: b4 0.17-dev
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: AB6751C000B
X-Stat-Signature: rjiy3pqxiek7sn6fgpuwxokf4nqqujqq
X-Rspam-User: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793291513-278528
X-HE-Meta: U2FsdGVkX1/uiH0EHdwz6NabXBoEoUldod0DGboFn84WVsvhkqy6xsUZORVs03FMAMgP2pP/6GK59HfttSVYHTt50ZgNpzd2t0u68klIsuyKTyCEYlLywNPG9VKsWdQHzxDzt7UX9plUvQonMPJxFc7AYsKtopiZ7EmFJt4RKjeWWs7ccRJfUXBQ7tFWtn7x0BKG+rtwhDymcFgsGNwskCmJLbSh8ugcgHsrLfpnchw9t951rG3FUGZdBXh1fbs/Gitwry8amVdBaC5gHsOa3JGYgPDQ2MEolHb9g/k8odovAq9q+eC3hOgT03DWTEPHMzthxRqkld6864743QGE0zuliQD5kO5r0zKYnQXLJn8VqTBXwFiZLfSDRlk0sfuo2ZnFyYBjzMY51qBIRY0ErFsOg0v2p3Te+IRkr8vkT7QGdy1iCX2aTFKmxpVFRdyIBYshJt6TE0jhiYbTK1ThadC6BsZ4PmTzLrY19M73/ttL050WCf7Nzg3rK7B45cGWL87H6fqs85JHOG6/vac8SyE+y6RGKnlFpOD1e5iMDqazbFeZKz5digYEl7pE279k2LwzhWc0GAPU3YGjM1qHKmeBIsVZHdEEj5HHp/FeUhlzRqOyt1AP0MrpjJD7rg5Q8QvMRYbfWlJsvEgr5HnKsaXVvEoKlc6xDBmX6rSLDPgBin1RvVeGSmsSs8gJPxE4zSmmum9NMJ65dP/ywTxwPJJs1o5xxJCCRfKujCpTdWJmpqOSiNiNpf2ilf1bOZhnXYlYk5m7fhSYeuzTFKLvBU3FR+L6LZgjok2WnRp1xlRKYm5F9tj4Ow/WqZzWqkCOlsDY7GKae39mlK/z9dkcOWEhn/S8xyevo77DJeQY1GNNe9m1lVHnzYwKimXhvlRGuUZwEpJq8uj4IprYWEdoh+U9MzZ9P2VgmxlYo5PWCLElzPzAsVKIPDowRvpKAFErZKIcTBBr1+hxHfowCEv
 3972njFM
 EQYEMt6GCAv0S8AJTXdpAt1K2vdHdkuZSL3Jc+3sT1VOsdcKELpzHROUZxCA09g/OYB7MGOUcdH+yMjFIplDMx3gwlt3eIc1YAbT/qavQgLqtUvVCRqP6hY5JQY5EtefdOucL8QFWwSXde9xB244jSAy1yl7dILMlwP5ZX9b8UFhl7570Aj3YD7hmiOYiRySfX+wyHP5BLEFHRssSYb8xbj8UL4AfMtBW/smSz/IzTnLnbENaG/Y9kt26j/B6hEYT4u4FHW1wxsbq3c2WRrlHNWx11y58mpzEo1eCBmHD+JPwnaB2IANFmRKWgRrxK6tmhWkFQnHqU0iZw4guUPyrp4MOq8LlZ6QWVu9gWlJR8GOTx7bo0fwRpnPsNmGCfAIKUBf3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-10-29 14:37 +0100, Vlastimil Babka (SUSE) wrote:
> On 10/28/26 22:19, Gregory Price (Meta) wrote:
> > Commit 2c4c3e29897d ("mm/page_alloc: simplify __alloc_pages_slowpath()
> > flow") retries an allocation once with reserve_flags when the caller
> > becomes eligible for reserves, guarded by can_retry_reserves.  The flag
> > is set at its declaration and never reset.
> > 
> > A restart after a cpuset update or a zonelist rebuild drops
> > reserve_flags
> 
> I don't follow, nothing "drops reserve_flags"? after the restart,
> there will still be a get_page_from_freelist() without them followed by
> get_page_from_freelist() with them, right?
> 

"Drops" is the wrong word, sorry.

After a restart the reserve bits are recomputed, but can_retry_reserves
is already false.  As a result no-reclaim/PF_MEMALLOC callers don't
get a reserve-retry attempt (we just exit w/ nopage).

Reclaim callers are fine.

This problem exists regardless of the rest of the series.

But you're right, I will rework the commit message.


> > Reset can_retry_reserves at restart.  Only a cpuset or zonelist change
> > restarts the slowpath, so the retry still runs at most once per change.
> > 
> > With kprobes failing every attempt without reserves and the first with
> > them, and a memory block onlined during the walk, the allocation
> > returned NULL in 3 of 3 runs, and a page in 3 of 3 with this change.
> 
> So IIUC the allocation was racing with a memory online in a way that it
> would fail if the online happened fully after the allocation. So this just
> turns part of the race window into the allocation's favor?
>
> I mean it's not wrong and if patch 5 depends on it (unless it also only
> fixes a racy window in the same way I think is happening here) then so be
> it. But the commit log would need correcting.
>

Not quite - without the online it would have succeeded.  The zonelist
rebuild rewrites the lists in-place, so a concurrent walk can miss valid
zones or pick the wrong zone.  The rest of the series detects more of
these restart scenarios.

Those restarts then exacerbate the issue this patch resolves.  For
example, patch 5 would free a reserve allocation that succeeded - and
then fail because can_retry_reserves is already false.

-- 
~Gregory


