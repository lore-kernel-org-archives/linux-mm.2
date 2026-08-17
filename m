Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8E7A9C5DF70
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 10:29:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A730E6B00C7; Mon, 17 Aug 2026 06:29:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A24D06B00C8; Mon, 17 Aug 2026 06:29:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 914BA6B060A; Mon, 17 Aug 2026 06:29:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 6E81B6B00C7
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 06:29:43 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id F2C70140730
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:29:42 +0000 (UTC)
X-FDA: 85110390204.13.9030073
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 1CA28100004
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:29:40 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwTRS3Ov;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786962581;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=f9IqgawvQwO75ZpLAFclZ9VquszwcPa30IcL+3Cr2F8=;
	b=B3cPBI5w32Z9zpBI+/9XLP8bYxld4GpZeW6Qd738Oj8qVaEOPNn5MVcrmg8/0E4I6K0kcx
	tB8oPV8BdjT4IkG6YtoZsDtU4N8M1nAD+AgZ9KSghHC3zSo7TFxkoqkCA/8GhJSXpd6Oed
	9g5FVBO22n6G1fAyoxYqux98QVjX6AI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786962581;
	b=7J/Qvkw3FyiOVcKbTowrG9vvbydtWBqSb8DW9IazNqlCJ0zgyp/5QlVlAN7SJJv4EOT1Zz
	gMiQxRy3ExtwdgSR5rlAZrrI5jEaebCLlmMOHvGEmzMrz7SYIKxA/Dd+w8U7Ff49k1M3Yn
	po1I54eqB98ldEh0muXiMkygEcEtqBI=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=kwTRS3Ov;
	spf=pass (imf14.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 4A5DB60254
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:29:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00C311F00ACF
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 10:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786962580;
	bh=f9IqgawvQwO75ZpLAFclZ9VquszwcPa30IcL+3Cr2F8=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=kwTRS3OvwzdHQGp2wRlbtIHrDhhHlA8Qk9LRgGQOjlaIRXPwXAJLE2lBIr4swu4sr
	 FJSieiBlHXjYyjNJG2jYZtLz+1ptOfzdpWqFIO3LkUT8aV6eJKKAAben9EZaq8GFnF
	 AGjYbnpUNClt3CXEwnhlz3cF8ED3jZzWkBD4IabalVDKBfVUv/lUBdlawrB3XzsJqv
	 TSMT0nflRahoYDOpTL5uGnnQ8KStbchDYbWL+tGQEyvBgj1sGAR5cmc11B+z1/BLgJ
	 STJg5g1mdcyWeKVdYjic9w245zOrpOotTen3UmBzytUxkaZfcIr6aSFsbRsFaCy2Fg
	 T+otNaGBBsR7A==
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e53581361so154393585a.1
        for <linux-mm@kvack.org>; Mon, 17 Aug 2026 03:29:39 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RowC7vCap6KSyP9ngtQWoU+A6uKVBYixZb4o/tR7ZITpJ19j2KxTvZmPSvojKd2Rmwfz1m6dBeTRw==@kvack.org
X-Gm-Message-State: AOJu0Yx668B5Kcre/XAC03CSOTGMEr/magc9rWx8LlEyt+VdKXlDuOhh
	GNSHT/8Sc4K29ulVxNYuhFC6iJaAdcgX7XrHZxXPnfFeeg3NckR4BlBQdDHVXhcjWauSydcfgoq
	wZo7KOQtD0S+y2yq3a78AX9iNE2+D2dg=
X-Received: by 2002:a05:620a:7081:b0:92e:5f90:c0de with SMTP id
 af79cd13be357-936d22cf949mr2574001985a.22.1786962579269; Mon, 17 Aug 2026
 03:29:39 -0700 (PDT)
MIME-Version: 1.0
References: <20260813-swap-v2-0-4a625ccabdae@debian.org> <20260813-swap-v2-3-4a625ccabdae@debian.org>
In-Reply-To: <20260813-swap-v2-3-4a625ccabdae@debian.org>
From: Barry Song <baohua@kernel.org>
Date: Mon, 17 Aug 2026 18:29:28 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4yEgik2_LjbPJmri7DiJJHRM7c8A0CsT-fWB1SYPVHWRQ@mail.gmail.com>
X-Gm-Features: AcwNN1W8pe0tUarwH-qciWy-Xt1ZYMMJP0Bl2ePBSg2WDkLghtftVawHB3tAxZU
Message-ID: <CAGsJ_4yEgik2_LjbPJmri7DiJJHRM7c8A0CsT-fWB1SYPVHWRQ@mail.gmail.com>
Subject: Re: [PATCH v2 3/3] mm: fail the fault on a malformed swap entry
 instead of retrying it
To: Breno Leitao <leitao@debian.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
	Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Youngjun Park <youngjun.park@lge.com>, David Hildenbrand <david@kernel.org>, 
	Lorenzo Stoakes <ljs@kernel.org>, "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Jann Horn <jannh@google.com>, Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kernel-team@meta.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Stat-Signature: dzme3fyrphcjjjof5w3q7f4ygme668bt
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1CA28100004
X-HE-Tag: 1786962580-109269
X-HE-Meta: U2FsdGVkX18CQ+eJckmfaKt0lTNAG3CaS0YNuXoPhKdrdKXWOZsGo4UaPqB3qHhi1pMfWy+NRv6gFALaUQNHAlqfs1FvPunUY814RZzShgSqZKiy5qtrnQpEq4lTzcD2iM7ypQZNrPsV6uKjrvX5mJoqcbI986x/YQa1xf0EuN6zfLOnRnd8i3dv3wBkntQzgj9JyGW3wjpMw8LbJcYEdolTr6w46FVW7dw2bnFdzuQbfm01AopUMOizrTgpBDf7FoRbyqrMIBCnX8Ln9xkoNS6fLTiruVpSzkIvltsBj+lDDWK57hAJ9u3wp6XNajyRmCfub0bee1WRBBSEY1lOA8l8qWVVCYYrUVHbaWNRvzM2PI7KAtshUdzRXNG8S4wNEmfnrF1GIT+JqvxCOclYSkjSs4eKuMSZ5u1HnGj/WyjAQVzKgWrH4JIyeAyHzIZD+HEhFAoGq34DZkYsiwXhefvjP7yWUvUGf1wU3hSKLCs7xUenp5MHto5l1o9vvCIBnQU0RX5OjDs4rTOVjE8Ei4PbYsvjspLYebB8qpVtTaLzs/sW0GMNisJgCnuQNhSvVLToVwCD5VjnIuQLdysG19vpdMsKsuBcTavi9941sJ4mryOR76UY6vM5A6uxv3ew2+58YzRSN1wXfsxPuTD4Pt8MyvdfYmWc/W1u1+g8AgGZ76ivKgoW/xtjY3hYgjGHCVXdIpam4RSZMnq6HLCyOcLrHntG5VZpQvnnr3Ajja2V5qC/9H89r1F068cOhMItupVnWdJ2JOgDzOZwdqhfiAEMdcyf/M9ixnMnzI1Q2WQ1dFJEUyCQe8Hms9lRjwcWjEeJabnOdanoHDdTKmMLdkCwsD4IbXrCJddeWT7KkvfBbhC/knbND/NykTDfSvt0dJB2Isd1NN//eyFDIZanBA+j8XJvzqT4Dvxo7ahFUeSV/LPNcdxvP0Dk0COVnokwlGtGZLYG9xjnumpsoZf
 BDRV+9vG
 VHbyYEws2zOp6clQPR1bol7r52SmK21KrMhqUVBQDc4PNIVJGRFaIQ5f1Qd4Px2Fl6R9PYIdVk3BDvOjajIyPqJND9gaxWQSVufGNnfctKwp01xcqf/yvSCGMARPMTtz0q4ejwwwVnVT8jLDWNvdnOTFPNQyVozvTQBT3/dgGoY0ZwxEvDDG+ovhZ9KB7ux1UDS/rbo7TrSjbjAvtHEITS2ghWBprW2k9J1dEGxeepjYKbOIMwg2VkTEW4z+GAELl/d/trbQquIlsDjJQUEmSzAZ1whKcnzXcRX26YZJcWisCuGcOzIORG4t3XvVDkYxgjTcw6I+cGTZ2Ptw=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 13, 2026 at 6:02=E2=80=AFPM Breno Leitao <leitao@debian.org> wr=
ote:
>
> do_swap_page() returns 0 when get_swap_device() fails, which the fault
> handler reads as "handled". For an entry that can never become valid
> the retry takes the same fault again, so the thread spins forever,
> retrying on the same fault.
>
> Return VM_FAULT_SIGBUS (Bad access) for a malformed entry (pr_err() was
> called at get_swap_device()).
>
> Signed-off-by: Breno Leitao <leitao@debian.org>

With a few minor nits below,

Reviewed-by: Barry Song <baohua@kernel.org>

> ---
>  mm/memory.c | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/mm/memory.c b/mm/memory.c
> index 7201e848129a7..fa2b3d2ad3202 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -4957,6 +4957,9 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
>         /* Prevent swapoff from happening to us, and reject a bad entry. =
*/
>         si =3D get_swap_device(entry);
>         if (IS_ERR_OR_NULL(si)) {
> +               /* A malformed entry never becomes valid, so don't retry =
it. */
> +               if (IS_ERR(si))
> +                       ret =3D VM_FAULT_SIGBUS;
>                 si =3D NULL;

Rather than resetting si to NULL, a more natural approach might be:

index efdf82b3c418..0286b7635bcd 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -5272,7 +5272,7 @@ vm_fault_t do_swap_page(struct vm_fault *vmf)
        if (vmf->pte)
                pte_unmap_unlock(vmf->pte, vmf->ptl);
 out:
-       if (si)
+       if (!IS_ERR_OR_NULL(si))
                put_swap_device(si);
        return ret;
 out_nomap:


Thanks
Barry

