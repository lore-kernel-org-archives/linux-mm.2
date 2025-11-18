Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4ED8ECEBF61
	for <linux-mm@archiver.kernel.org>; Tue, 18 Nov 2025 02:00:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6B0768E0005; Mon, 17 Nov 2025 21:00:41 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 688348E0002; Mon, 17 Nov 2025 21:00:41 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 59E288E0005; Mon, 17 Nov 2025 21:00:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 478DA8E0002
	for <linux-mm@kvack.org>; Mon, 17 Nov 2025 21:00:41 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id E8D5B13A986
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:00:40 +0000 (UTC)
X-FDA: 84122073840.20.2EB083C
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	by imf21.hostedemail.com (Postfix) with ESMTP id 009BD1C000A
	for <linux-mm@kvack.org>; Tue, 18 Nov 2025 02:00:38 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IWZ6V6fZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763431239; a=rsa-sha256;
	cv=none;
	b=jcmWBdVd3+k+5R3fVVyhImcyMAf3DyLAaNG6K7TruP/HkPEj/AN24XJgZZSC7jV7h1A05Y
	/W2st2CCLcTKStSIIfAa5k5NwPHSN15X2dN8ORl5CZgrH1uqF1Y1PgWdP4DJ8u8mw33beh
	mbCnH6supsbIZ9lf7gAtlhw+OZO6xDE=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=IWZ6V6fZ;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf21.hostedemail.com: domain of richard.weiyang@gmail.com designates 209.85.218.41 as permitted sender) smtp.mailfrom=richard.weiyang@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763431239;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PjtZZ70/Qu6YbmmA5LKoN6Z9gQ7S03ZL5L4ASTauTjE=;
	b=q0IlOFA3INfbwZUfeBV44bvINb5vX3n+62Qkef9jNWqbteDm1+3iaQtjaq9Q2MGX5DPtjF
	rxc8HNyh0pDHaSUN1gDrO82ewhTuOaL9P+Ke/9xRXenC9rcdlMN3dDs1yKm0DEn59EQTLC
	b/DBPSpZ36qcIPcxcHfZqh9cMjzwCzU=
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-b73545723ebso889576266b.1
        for <linux-mm@kvack.org>; Mon, 17 Nov 2025 18:00:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763431237; x=1764036037; darn=kvack.org;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=PjtZZ70/Qu6YbmmA5LKoN6Z9gQ7S03ZL5L4ASTauTjE=;
        b=IWZ6V6fZHk3n8gNXhc9mvj8+wm9OBa8+ARg2PuOiWvdO3gif0b6gNamz7NWfzB9N5Y
         6tJe+fTZSX+UZNoqbVPgxGRyw3VoVsSqwxCAyR3tsXr3UWRmqFTF99MZmiqwOmACo6kM
         31jM2VTS6m6dfsrlDKwea18l4LzMOlATxxS0/Q2sMgPesqcZXYj/EBdTMtF6zn3Pvd5L
         LfcWUseRPU2FsXmkk9z0/aPDEegpcRdko1VluK5H1+vQqemoDs0wp78F4husIYkHQxid
         +5SIEGaI6ek8IaUS9WMW2hpUiHp1VP5DtFPPULQjnN6rQSWlxhCKlGE1kpqIUMpa17JS
         lgLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763431237; x=1764036037;
        h=user-agent:in-reply-to:content-transfer-encoding
         :content-disposition:mime-version:references:reply-to:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PjtZZ70/Qu6YbmmA5LKoN6Z9gQ7S03ZL5L4ASTauTjE=;
        b=up+IY21IwfD/aFDvyedweipKK7mttqvxFJiBGpG6UFfayg5fU0dG6QLAY0KkTonFA6
         jrhe85yOwWbRU/KAgnnJUg+kvpgeYo2DkgO8p94D93DpszLnbG4tJUhhwREKwQs2erZo
         khmaJoCON0z+v0qFC9QUBx8z7izAyxYwR6lx2JFXCD8eZqiB8caX9/QUP9LZoWv7Inj+
         PNVQ2+WTcugNjW0/u9tyZkJKpC+QOMsUw3cBIvgZwCWXIgeh5hvRdrmSr+aB3Jx04bQ9
         1AecJZPcxqABL3itU9HfHpKbYbZ/uRyDpLDzBaOzKUjTyBuuYbWQ00pax9onJerrMgjF
         TS3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWfv0eYZdUNlVqlAKq8PraqyPD9VzoJF2COg+BtDihnnpylaYQA1zI8iAyPEkBrwLMyAXVRNvQQMw==@kvack.org
X-Gm-Message-State: AOJu0YznxQQ1f/qKT/L5gexKysudEcMy/oomvDzDoU0hDWX2PHlsoeNe
	j3dRD2gANYMSBVWxLizTFPSAIbpqmd89IxiutzQKHpoQ90Q5RsXu3Xrb
X-Gm-Gg: ASbGncsSWz2tgQXaD1nTOTE5RqyjzNnnc049dmLpMs4IetNDJguwc/wFQeQ/MJG6EJx
	SoDKTgQfAvJylz/GslLE8JlKjGR6RslR2FFQJGSBrbCtxj1gNVoivVo/TAT6y1euFX1mqgKJ1/2
	RgeuIDFhsH/meHbfu3UQmVFLJ3ZLdxyll1Aj9zoE0aUfHUYhelAiSMunjann0wEQeBGhSyfGeXs
	YO0LY5L+cMiYX+NVg5r7v26Ki7WkGR1lcY2OC6Ym2donTfYJJlvqy7sXwjsfrJwhTXRTbf8Au+o
	7rr9nabsldx7PdnyOs+vvr1CDZRJjnmz6LvUZRK4F1XrFbiL6CkeYhxvAH/Bf4bOgCiMFVAXi4U
	5MdK/Pq8v3DoJ4xWXxEXajR9w8cIPK7yIBhs0VfqKVm16Dugxui6CtrH3A3GG3TiAwZpGgdyY8E
	0T+OzTmsOETtmsUw==
X-Google-Smtp-Source: AGHT+IEIbHsmAR4qI1U7kAkJFbuJ0gMBeLqnpNcnfrzyBKIrXirysQ6AKJVPv8sKWVks0bFN76WI/A==
X-Received: by 2002:a17:907:d18:b0:b73:9b4a:5c02 with SMTP id a640c23a62f3a-b739b4a5cb6mr723067766b.49.1763431237209;
        Mon, 17 Nov 2025 18:00:37 -0800 (PST)
Received: from localhost ([185.92.221.13])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b734fd7f37bsm1199178666b.35.2025.11.17.18.00.35
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 17 Nov 2025 18:00:35 -0800 (PST)
Date: Tue, 18 Nov 2025 02:00:34 +0000
From: Wei Yang <richard.weiyang@gmail.com>
To: Nico Pache <npache@redhat.com>
Cc: Wei Yang <richard.weiyang@gmail.com>, linux-kernel@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org, linux-mm@kvack.org,
	linux-doc@vger.kernel.org, david@redhat.com, ziy@nvidia.com,
	baolin.wang@linux.alibaba.com, lorenzo.stoakes@oracle.com,
	Liam.Howlett@oracle.com, ryan.roberts@arm.com, dev.jain@arm.com,
	corbet@lwn.net, rostedt@goodmis.org, mhiramat@kernel.org,
	mathieu.desnoyers@efficios.com, akpm@linux-foundation.org,
	baohua@kernel.org, willy@infradead.org, peterx@redhat.com,
	wangkefeng.wang@huawei.com, usamaarif642@gmail.com,
	sunnanyong@huawei.com, vishal.moola@gmail.com,
	thomas.hellstrom@linux.intel.com, yang@os.amperecomputing.com,
	kas@kernel.org, aarcange@redhat.com, raquini@redhat.com,
	anshuman.khandual@arm.com, catalin.marinas@arm.com, tiwai@suse.de,
	will@kernel.org, dave.hansen@linux.intel.com, jack@suse.cz,
	cl@gentwo.org, jglisse@google.com, surenb@google.com,
	zokeefe@google.com, hannes@cmpxchg.org, rientjes@google.com,
	mhocko@suse.com, rdunlap@infradead.org, hughd@google.com,
	lance.yang@linux.dev, vbabka@suse.cz, rppt@kernel.org,
	jannh@google.com, pfalcato@suse.de
Subject: Re: [PATCH v12 mm-new 13/15] khugepaged: avoid unnecessary mTHP
 collapse attempts
Message-ID: <20251118020034.rdgisvkqs53lwabz@master>
Reply-To: Wei Yang <richard.weiyang@gmail.com>
References: <20251022183717.70829-1-npache@redhat.com>
 <20251022183717.70829-14-npache@redhat.com>
 <20251109024013.fzt7xxpmxwi75xgr@master>
 <CAA1CXcA9zaGqLPHnJWH=fKPUjb02dV+rKgfmsRZOGdeukiC8eg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAA1CXcA9zaGqLPHnJWH=fKPUjb02dV+rKgfmsRZOGdeukiC8eg@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 009BD1C000A
X-Stat-Signature: scwqg44grgr5u4ey8ko9h3hswustjqd1
X-HE-Tag: 1763431238-410197
X-HE-Meta: U2FsdGVkX1+dAFbHTPhPYitVYK3MJss4pxmc/Mj5rrjrEa4+edzglttd47PSD3uM1+Hdil0UEHq8M46zAPiE2SsVbnnlbA4vcZjCB+VKEDG6cvVLQO7e8Is31VMToP88fWCG35f/0g3uGS6K0viXO6hU9h+BPpptovWxdZsC+eydNDPuBGv1kQaVcqjCgWk5wToRmtd6c2/WHbvAoOj9LZ7ObUnkc9fgZblr2Vu7s7WhY1B1UEw6ugJ2tTvFH0GUzuzSWLTjBR8mWCH/cEVwzppK3wJTH88uX/28B87qBPbttupBDr35dlR1NNegbn4yb4MkuKjkG/j+LrOxXb1PH8NwjCshrRWh7NoIhGTiH2bnRWBdZ/iks/RwLUuehOpjXC0K71LUZ2VxnEZKZun432gvHSDbdQz5KjT8oJUTJusUvGsSM3scK90JaH/ovQP7vjOIcYJbXQqu83lZ4N/y/q0ysLnmICxGYrqnikCZROP5rzOWOe2pKyxSRKuEVnHgDBloAJ7xCfk7MxTSRn/e6N3hj4DsYTyjGHzcpqk6eNRt2a5S5UhfJGV2yac07sDGWxh2pwshqmt0vutwDg7ZVvNcbivF2gqygDm+CGHlG9TkxwE0ZzWb8qH1kbt5vj1JfbBKDv8j+wWDPFWyPCmBCYT6m9q6qGnE1+1lKIf4JKx95ol1pyhLFkGxQgvVZ7rMJV8NrofOs2n1iabrhpeypJ9tl7RQYe/W+hHsAfrp5k/+yP8+ARJJ6WMJGffmbDK+wRdpY8mSKBG9aaNv7ATte9ortFMCNfM6Rizkw3F2NRzsjWFx5+HL82ts3kJHPz1vA7M1lVkbx2CudyrcwDrguvxleEnZes9rk/CtBHrmKBKqeL6inDIuYYysk07g4C8eymfYuKXFGIvPDh+aSzOMHq3i4KQuPO8VlCbItZB4ufTVCuAdJnr7ehWSIjBxskXQfaS3N6dNlnI/4TuftEW
 s9qWTYfe
 +iu4rJq77s11NJ8EBSzUq7wHzpfIzvCI/UA5XHE5/U3n7oJsBCtJAl0fUjgVuXOiiGWkkTRlF222kKpvxABVunjvgPPLemBmkaLEtlq2DRo/JO5/QNHfny/TASNH2p6JYuCrgRIWdKUun1U0DnKyR07SYCnOrBA10I7vnPMsr7uSyqDq+W0U7nhyglcOPJ9fhC7VUkCg4JORv/txsfmyBQqQXiaNEiq0pvhfHHwNhFqpGQOpGSjATPOGlceoSxFM55rR71aQYzpfTQM4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, Nov 17, 2025 at 11:16:53AM -0700, Nico Pache wrote:
>On Sat, Nov 8, 2025 at 7:40 PM Wei Yang <richard.weiyang@gmail.com> wrote:
>>
>> On Wed, Oct 22, 2025 at 12:37:15PM -0600, Nico Pache wrote:
>> >There are cases where, if an attempted collapse fails, all subsequent
>> >orders are guaranteed to also fail. Avoid these collapse attempts by
>> >bailing out early.
>> >
>> >Signed-off-by: Nico Pache <npache@redhat.com>
>> >---
>> > mm/khugepaged.c | 31 ++++++++++++++++++++++++++++++-
>> > 1 file changed, 30 insertions(+), 1 deletion(-)
>> >
>> >diff --git a/mm/khugepaged.c b/mm/khugepaged.c
>> >index e2319bfd0065..54f5c7888e46 100644
>> >--- a/mm/khugepaged.c
>> >+++ b/mm/khugepaged.c
>> >@@ -1431,10 +1431,39 @@ static int collapse_scan_bitmap(struct mm_struct *mm, unsigned long address,
>> >                       ret = collapse_huge_page(mm, address, referenced,
>> >                                                unmapped, cc, mmap_locked,
>> >                                                order, offset);
>> >-                      if (ret == SCAN_SUCCEED) {
>> >+
>> >+                      /*
>> >+                       * Analyze failure reason to determine next action:
>> >+                       * - goto next_order: try smaller orders in same region
>> >+                       * - continue: try other regions at same order
>> >+                       * - break: stop all attempts (system-wide failure)
>> >+                       */
>> >+                      switch (ret) {
>> >+                      /* Cases were we should continue to the next region */
>> >+                      case SCAN_SUCCEED:
>> >                               collapsed += 1UL << order;
>> >+                              fallthrough;
>> >+                      case SCAN_PTE_MAPPED_HUGEPAGE:
>> >                               continue;
>> >+                      /* Cases were lower orders might still succeed */
>> >+                      case SCAN_LACK_REFERENCED_PAGE:
>> >+                      case SCAN_EXCEED_NONE_PTE:
>> >+                      case SCAN_EXCEED_SWAP_PTE:
>> >+                      case SCAN_EXCEED_SHARED_PTE:
>> >+                      case SCAN_PAGE_LOCK:
>> >+                      case SCAN_PAGE_COUNT:
>> >+                      case SCAN_PAGE_LRU:
>> >+                      case SCAN_PAGE_NULL:
>> >+                      case SCAN_DEL_PAGE_LRU:
>> >+                      case SCAN_PTE_NON_PRESENT:
>> >+                      case SCAN_PTE_UFFD_WP:
>> >+                      case SCAN_ALLOC_HUGE_PAGE_FAIL:
>> >+                              goto next_order;
>> >+                      /* All other cases should stop collapse attempts */
>> >+                      default:
>> >+                              break;
>> >                       }
>> >+                      break;
>>
>> One question here:
>
>Hi Wei Yang,
>
>Sorry I forgot to get back to this email.
>

No problem, thanks for taking a look.

>>
>> Suppose we have iterated several orders and not collapse successfully yet. So
>> the mthp_bitmap_stack[] would look like this:
>>
>> [8 7 6 6]
>>        ^
>>        |
>
>so we always pop before pushing. So it would go
>
>[9]
>pop
>if (collapse fails)
>[8 8]
>lets say we pop and successfully collapse a order 8
>[8]
>Then we fail the other order 8
>[7 7]
>now if we succeed the first order 7
>[7 6 6]
>I believe we are now in the state you wanted to describe.
>
>>
>> Now we found this one pass the threshold check, but it fails with other
>> result.
>
>ok lets say we pass the threshold checks, but the collapse fails for
>any reason that is described in the
>/* Cases were lower orders might still succeed */
>In this case we would continue to order 5 (or lower). Once we are done
>with this branch of the tree we go back to the other order 6 collapse.
>and eventually the order 7.
>
>>
>> Current code looks it would give up at all, but we may still have a chance to
>> collapse the above 3 range?
>
>for cases under /* All other cases should stop collapse attempts */
>Yes we would bail out and skip some collapses. I tried to think about
>all the cases were we would still want to continue trying, vs cases
>where the system is probably out of resources or hitting some major
>failure, and we should just break out (as others will probably fail
>too).
>

Thanks, your explanation is very clear.

>But this is also why I separated this patch out on its own. I was
>hoping to have some more focus on the different cases, and make sure I
>handled them in the best possible way. So I really appreciate the
>question :)
>
>* I did some digging through old message to find this *
>
>I believe these are the remaining cases. If these are hit I figured
>it's better to abort.
>

I agree we need to take care of those cases.

>/* cases where we must stop collapse attempts */
>case SCAN_CGROUP_CHARGE_FAIL:
>case SCAN_COPY_MC:
>case SCAN_ADDRESS_RANGE:
>case SCAN_PMD_NULL:
>case SCAN_ANY_PROCESS:
>case SCAN_VMA_NULL:
>case SCAN_VMA_CHECK:
>case SCAN_SCAN_ABORT:
>case SCAN_PMD_NONE:
>case SCAN_PAGE_ANON:
>case SCAN_PMD_MAPPED:
>case SCAN_FAIL:
>
>Please let me know if you think we should move these to either the
>`continue` or `next order` cases.

Take a look into these cases, it looks good to me now.

Also one of my concern is this coding style is a little hard to maintain. In
case we introduce a new result, we should remember to add it here. Otherwise
we may stop the collapse too early.

While it maybe a separate work after this patch set merged.

>
>Cheers,
>-- Nico
>
>>
>> >               }
>> >
>> > next_order:
>> >--
>> >2.51.0
>>
>> --
>> Wei Yang
>> Help you, Help me
>>

-- 
Wei Yang
Help you, Help me

