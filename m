Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0E2C0C5DF81
	for <linux-mm@archiver.kernel.org>; Thu, 20 Aug 2026 10:14:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED16D6B009B; Thu, 20 Aug 2026 06:14:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E823B6B009D; Thu, 20 Aug 2026 06:14:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D70626B00A0; Thu, 20 Aug 2026 06:14:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A59B76B009B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 06:14:48 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 366CFA34E4
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:14:48 +0000 (UTC)
X-FDA: 85121239056.08.54E7DC2
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf25.hostedemail.com (Postfix) with ESMTP id 3253AA0002
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:14:46 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bEorTEzJ;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787220886;
	b=0C6sC0xEo1P3iDbWtlzlaYA2bOIujFOzlyTzVvV8j9JZV4dnhVP4mXE3MzGByJiFZIR09w
	D6XLjEyXmudSELsI3XXp2o7+iF4OnznU782wY0BefiQZ0e6OvUmXkDWfBqEm+AC7Q6/Bdy
	Qdb8HOCSEp0aNAuh9SgVdEoUjHKxW3I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bEorTEzJ;
	spf=pass (imf25.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787220886;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sp8CWPCpMXaEav5HFcZtsyU8LSqEkLH+Vk6+V7JX05Q=;
	b=cpJ8kTIVuxWzRrQIGLg5eXqpG1fR3pS3qCtqUO7F7zLkIivEXcvGA7oFecj6mBOt75AUWq
	sK57aHQ88mn0DDls/oCgQlXr4aWt+CXRv+0oxREtigKQy4s6xWhC/5QKOJhw268EqJ2DCS
	tCnPRbdj0y1xNp4Cu4Ng4dJ32g3M4TE=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 7EC3C43E6B
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:14:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 670451F00ADB
	for <linux-mm@kvack.org>; Thu, 20 Aug 2026 10:14:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787220884;
	bh=sp8CWPCpMXaEav5HFcZtsyU8LSqEkLH+Vk6+V7JX05Q=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=bEorTEzJNErX161CYkKO1FC97byQ0NiO+WoR3WNoBa7Ij1MPTt2XQ10RNrq1YBGuH
	 wBEQP4++o0D/9pCTbLnIB7v/5wiwh5EDMumCLUkkATcj8GOF/vtTvxxKImPuWefe9q
	 jaRsLXXzXw4PRTSK5yILoQirLFZkp+9zmFXQ4SauMrt/KaK9LfnYjsblvs+HoWr/ZF
	 8H7hdgv+9M+PCfsb8Q18VPBZfyxxbOHTZQ43BE2XVdZbkGpC82LEjpyzOHGD6FObl3
	 rS71Zk1fjJD6GOcLV98tRfyE0Acvt33lqks9g2t4i+6KOH/CMmWLP6dkuoo5VsZpx/
	 ETwL36f/gFDow==
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-936cda0e3fbso167531985a.3
        for <linux-mm@kvack.org>; Thu, 20 Aug 2026 03:14:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+Rq+rkHItKjLLSe2HyxPGsRKu6t8K7YtNTkzDlExzhoG49rgLvlPEuCZ5sqXMu+WN0EFV3RmYXIL/w==@kvack.org
X-Gm-Message-State: AOJu0Yy54P0moNwyDNOtESCAmNyMe4lcChOpJxyn2wvzc1oFZRPPmPDB
	u8tz5L8MeF/gdA764aWT7VvVPuGTNwd6WdNZQI4MheU6GuC8qOwjj3XELEPSSZcHZxSY72tBq+7
	Vp9/QykAQ7gTW3HE7dPwkK5VQ1JVL6Do=
X-Received: by 2002:a05:620a:4620:b0:936:dfbf:85b0 with SMTP id
 af79cd13be357-9371e3314dcmr1071595585a.35.1787220883715; Thu, 20 Aug 2026
 03:14:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260818225904.55236-1-baohua@kernel.org> <20260818225904.55236-4-baohua@kernel.org>
In-Reply-To: <20260818225904.55236-4-baohua@kernel.org>
From: Barry Song <baohua@kernel.org>
Date: Thu, 20 Aug 2026 18:14:32 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4z-PnFyBFm5BLVFtzxAbToReQVSgxPDYf_6RSkVHc9_jw@mail.gmail.com>
X-Gm-Features: AcwNN1W0eGO2UaUH4mqRKyOBOJid5KfOKDLl-oTF1bfBeM7DwzG5O57TRCnn_a0
Message-ID: <CAGsJ_4z-PnFyBFm5BLVFtzxAbToReQVSgxPDYf_6RSkVHc9_jw@mail.gmail.com>
Subject: Re: [RFC PATCH v3 3/4] mm: drain LRU cache if necessary for splitting
 large folios
To: akpm@linux-foundation.org, linux-mm@kvack.org
Cc: baolin.wang@linux.alibaba.com, david@kernel.org, dev.jain@arm.com, 
	lance.yang@linux.dev, liam@infradead.org, linux-kernel@vger.kernel.org, 
	ljs@kernel.org, mhocko@suse.com, npache@redhat.com, rppt@kernel.org, 
	ryan.roberts@arm.com, surenb@google.com, vbabka@kernel.org, ziy@nvidia.com, 
	hughd@google.com, ackerleytng@google.com, usama.arif@linux.dev, 
	joannelkoong@gmail.com, hannes@cmpxchg.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 3253AA0002
X-Stat-Signature: 9n7iyrinkearfm6xuxdwzokpdwyo1ezx
X-HE-Tag: 1787220886-146447
X-HE-Meta: U2FsdGVkX190dX6EIGjMqIW1X//UNaAgMQD7yiPwopEsRVwi5N0Z+3tQEhbXQpGLFSNe5qYn51irPkyU6KVZuwar42XRLi70cF61UBmIIGtIjPaWF4KAzZC8G0gE0ZGUrL105XmfEMXROxK2gLS4SKTehcYASRNkb6fhUXgdtzBmj5/lbtYlZahR2GFxCTZo+3iFQm7U+iTpAlwLGhf87k2jhW5pXHwZZ3r339h6VI4SNnQLlx4XqUxdB7syxlzzCVwQv3dFY/yRzGQgzhg7KDbCPubK0jNVssNw+uUr8fRzlAC9mgPAUu5dwHpWEBT/EJQ8uJ7z3NkfJhfalFGau1YSsyuygQ/BJMutDDuFZxSR8HzGOzmIdl9s3B9icHRjeGE6xEg4mFtMYp2wUwEBUiFGNzwqP9aVy+AfMHI3bVTc7dWG7GRbCMzt+Em5DFfQXeZm7Y+HHQB6okLVmsLbKuR8QMoaqr+RJ2iHoyQ8r4aWEjp9QJPrcR/Icey/adFIBbmo38Yaj6MIuxiiudfxOlg0GyYYqcNO+hXRBNoYzWtoti8/wcVyD15moEJcVc8J7AABqfrRVhWDQqz1IY3Tr/q8FphO9gQSB9aDW597b98WXj7pewWiZDFxY7JE+s8D7+kUwbMmN1MDK2RwEA8LadpVPxFl2hQRX9d3jNsoUwdhR9CCUi/6szacnHsr0OSQBDrhAs3lgoulUKpiJRN6M6nHrXTtPQSRDfzzHQeGnSbm8Wr/fLB7l7zUtfr8sQIf5D6VsOssyDlc3oT/JIJPClv6NDK1aUkrCMUYBZpJTyVeBTYpDoxFAMZUUGXnCzyQYWLQgmc0T612HmBvtyRFu0C6u37s/eIuV+/gPNsAmHmpM2EJPvBGTBvAbrbSwhdZ/BHEuDxAAJRkRU88u1SnbKJqOhrtLbByT9HKg2LVqFr4UhITPNPM59rC/jF1U05bIs3RgE9kdpWzb/9M41C
 feXWiz6y
 Yh5XKbKB1uMYQV5dOPYKpbLpcB8as93Fm6k3ONk+2e0VacAacCfHXuWsUwN/9a05lgpci157yOcaj+vpsc6VwBy+2B1iuIFoMVuEpeFvxQu5XSGp0xGUtsDSPt+hZ9yiPDzXRP8+rf8YNx/lCyL8Xq6AUyDjr6qXL5BAVbON79yejFsuVQgXE8VfxJtrZxtzkuXRROz1YluCo0IeNC0Cuw96wetu0kPj0XAsJ+Lh7u7Eb7P9qlHR3Q4jmbP/Ihy9Z4VvNGuuLYcAffCi9un4vYHaSbKGIH50YOW74s9UQQWhTaCtx/zcV8vONSw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 19, 2026 at 6:59=E2=80=AFAM Barry Song (Xiaomi) <baohua@kernel.=
org> wrote:
>
> Smaller large folios might now be present in the LRU cache. Use David's
> new lru_cache_drain_for_folio() helper to drain the LRU cache before
> splitting a folio, ensuring that the folio can be split successfully.
>
> Also, we only perform the drain when it may actually help, assuming
> that the lru_cache holds an extra reference.
>
> Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
> ---
>  mm/huge_memory.c | 10 ++++++++++
>  1 file changed, 10 insertions(+)
>
> diff --git a/mm/huge_memory.c b/mm/huge_memory.c
> index ced400f72d43..263ef9b6949d 100644
> --- a/mm/huge_memory.c
> +++ b/mm/huge_memory.c
> @@ -4201,6 +4201,9 @@ static int __folio_split(struct folio *folio, unsig=
ned int new_order,
>                 if (shmem_mapping(mapping))
>                         end =3D shmem_fallocend(mapping->host, end);
>         }
> +       if (folio_ref_count(folio) =3D=3D folio_expected_ref_count(folio)=
 + 1 +
> +           folio_may_be_lru_cached(folio))
> +               lru_cache_drain_for_folio(folio, 1, NULL);
>
>         /*
>          * Racy check if we can split the page, before unmap_folio() will
> @@ -4325,6 +4328,9 @@ int folio_split_unmapped(struct folio *folio, unsig=
ned int new_order)
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_large(folio), folio);
>         VM_WARN_ON_ONCE_FOLIO(!folio_test_anon(folio), folio);
>
> +       if (folio_ref_count(folio) =3D=3D folio_expected_ref_count(folio)=
 + 1 +
> +           folio_may_be_lru_cached(folio))
> +               lru_cache_drain_for_folio(folio, 1, NULL);
>         if (folio_expected_ref_count(folio) !=3D folio_ref_count(folio) -=
 1)
>                 return -EAGAIN;
>
> @@ -4805,6 +4811,10 @@ static int split_huge_pages_pid(int pid, unsigned =
long vaddr_start,
>                         goto next;
>
>                 total++;
> +
> +               if (folio_ref_count(folio) =3D=3D folio_expected_ref_coun=
t(folio) +
> +                   folio_may_be_lru_cached(folio))
> +                       lru_cache_drain_for_folio(folio, 0, NULL);

sashiko says:

"Does calling lru_cache_drain_for_folio() here sleep inside an atomic conte=
xt?
In split_huge_pages_pid(), this code executes between folio_walk_start() an=
d
folio_walk_end() where the page table spinlock is held and preemption is
disabled.
If the condition is met, lru_cache_drain_for_folio() can call
lru_add_drain_all(), which acquires a mutex and flushes work, both of which
are blocking operations.
Can this result in a "scheduling while atomic" panic when writing to
/sys/kernel/debug/split_huge_pages?"


I guess I can either drop it since this is a debug interface, and
failing to split folios in lru_cache shouldn't cause any serious
issues, or move it before folio_walk_start().

>                 /*
>                  * For folios with private, split_huge_page_to_list_to_or=
der()
>                  * will try to drop it before split and then check if the=
 folio
> --
> 2.34.1
>

Best Regards
Barry

