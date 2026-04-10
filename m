Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 25784F459FC
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 17:49:57 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 563256B0088; Fri, 10 Apr 2026 13:49:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 512EA6B0089; Fri, 10 Apr 2026 13:49:56 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 402086B008A; Fri, 10 Apr 2026 13:49:56 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 2C2DE6B0088
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 13:49:56 -0400 (EDT)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E4C7BBA310
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:49:55 +0000 (UTC)
X-FDA: 84643384350.29.87A97A9
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf13.hostedemail.com (Postfix) with ESMTP id C325720003
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 17:49:53 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SBXKMglk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3QDjZaQsKCGsSXXWfXWTJWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3QDjZaQsKCGsSXXWfXWTJWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--joonwonkang.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775843394;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=n63njisaqyt6Z3ldieTKgF4Vzk2yvDqsctxyE+mfFKk=;
	b=fK53ME2333w+ArKawBJ9kH5U1PJyQmI4bUXpxiuxz3PmK9xOjjjTrchDj5Nsgq3g3cKnGq
	O+QwyPi2fuCaoys0BkPwj0ZYIl0at6tswloeDzKCiVKqI9oCLLxSq2p+CrUYjT1t47Vyxq
	CxcazPLQ8xN7lq3fvmsXvxqt1ZWx3zg=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775843394; a=rsa-sha256;
	cv=none;
	b=HcFTCp7rSSqVItCw9rbpeyiPJ1A/PPUJZTuZYQnogKHUhwCVnCKcZDuRYhSaPYhnwKsfBV
	BHt/pDG+MB55BjH91uS77/OgBDd3XnpFWRypIih7q+ayfY69/Fkx97J+ytx8l4c3ds8mH6
	ud/0NIKJ7enaRZai7f1qMCERh9+OVF8=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=SBXKMglk;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf13.hostedemail.com: domain of 3QDjZaQsKCGsSXXWfXWTJWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3QDjZaQsKCGsSXXWfXWTJWPPXXPUN.LXVURWdg-VVTeJLT.XaP@flex--joonwonkang.bounces.google.com
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b0f4e632caso33816205ad.3
        for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:49:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775843392; x=1776448192; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=n63njisaqyt6Z3ldieTKgF4Vzk2yvDqsctxyE+mfFKk=;
        b=SBXKMglkRdlI1rtHmF5TeLwF/z7OFEfjM3zop4YTAVrGLSLb7kUB05SzfKrDzjPTDN
         tXLsWLQiote98klq238knaSy19ZE1Vo7DVQb97l+xFF1iW3Tf55biYX0S1eLlP0QflfB
         Ru1K1g/bnU4TK+wolf6AnLV0h1oKLFWu6aWw0dCraCfRINk7iJR0k1NEujcxVa6rVqaW
         RNtYRhLa/OiQVu0HRlfZRGoodPtq05T1mB7b3qjt3DrnqJQVRnEx8fqA/L9a+VpuDQYb
         IVLuTOqYYKIjN7u9QfqOGyBJ4Csg+m0TiYc1W35mB7P5XukHo0UxG3wQUE1wRyT0PXKu
         IlQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775843392; x=1776448192;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=n63njisaqyt6Z3ldieTKgF4Vzk2yvDqsctxyE+mfFKk=;
        b=oNtJ9FGv8PlcBA/aiwPMdPsAQd+r61ypXcCkkqtuCxVsvuwbmrQ67l7C04yEkRkv6n
         N1+l9vJmG6bSV19vlFhCrJbzcr7yUnSefMN2pIHqcml3pxnyX5VWQadE3upyOYc1fuSE
         AESJX7LsWp3lti0zyg4TyWCjYaKbGD54a2dHYkU1CRpOSg/K610hRR0TOPkqZmtG8A1Y
         Wu7RiwbQlKOXvZKvGi77qNIrhczOy0j78SV4tRgZ274QHzKtMXj3ukMr8S19oRtILkFs
         nkuR7UEXgrv/Dvh6mlC+fxKgbLfV7minVEfxHVryJuHXairsMahmxMR0ABECH3x5MZn5
         JKKQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNZNlrxHo5JbGMMmGh5r8wNEfMPWd2kQu61VjPZdLfosyxluGP8swgLnJ3f2g0wzkKvvKv2h6GYQ==@kvack.org
X-Gm-Message-State: AOJu0YytEYBWcLj3yIGS+bhyDkwGfeLb7CpkVEouH1BCCrHcqmAmAik9
	xXzDhiTuVnTB2oMXoWCKEIF4W3fyiVPmPoB1xJeNBdEvijaDmgBtjna0NTqyrtqiesInUvfm60w
	4rVs34ZYKf0a1XwqqNzDHv4hZIQ==
X-Received: from pllk22.prod.google.com ([2002:a17:902:7616:b0:2b2:4f11:11b1])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:7886:b0:2b2:5042:dd18 with SMTP id d9443c01a7336-2b2d594152bmr32774695ad.3.1775843392243;
 Fri, 10 Apr 2026 10:49:52 -0700 (PDT)
Date: Fri, 10 Apr 2026 17:49:50 +0000
In-Reply-To: <adfb1wrzJjuqHEuA@google.com>
Mime-Version: 1.0
References: <adfb1wrzJjuqHEuA@google.com>
X-Mailer: git-send-email 2.53.0.1213.gd9a14994de-goog
Message-ID: <20260410174950.1454063-1-joonwonkang@google.com>
Subject: Re: [PATCH v2] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: visitorckw@gmail.com
Cc: akpm@linux-foundation.org, cl@gentwo.org, dennis@kernel.org, 
	dodam@google.com, joonwonkang@google.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: C325720003
X-Stat-Signature: dwz7mfzwrwkjxdkoeaw1n1wmgtdunkyg
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1775843393-33585
X-HE-Meta: U2FsdGVkX1/BfDM+Tygks9+QqI0AcCRra+iG8jxYgaai/zQoO/Ui/6aC9MdZFNIc2Sb2aeOh3VoUWRCX+e/Dxtss9kiSDPGMXOKo67q3vSpvrsuVpMkmfZj0KdaUUXRh2YNcnTsfU8XigNaoyzPFwfW0zoj1HQGY+t0wTgY1uOL44a52zC4vkk4v8zX/JI/fAMPSclJ2SYAm1kPx9zFFUjs6dudPRXm7odjv+4tlDz5Pz5IOiBWzQPwZJurpCclJQJWkWeVPqjTD/kyXBR9X8GSIf3JVX5FB+978/w/P3XjTt2BQZ0Ii+khFFYMsJdk/nipdgV7avIdGQ1mtidB8hrFwRbFyWJVX3sxRLzW51K6nUc4/GBogjfNmFfyA20iPQyOYIPX7RtvEeiBQdARp3O0/rl4BtEPn1ZXtil/EqzlSQPBt+Wdzia5baYliOQiBWtG5Ljtwaxc2UBONepRt/yZG6VMy5C+pH2UTKg+dZSxSi/v1Dm1ptkXN3VgBbsSmhYUC2o0HsY433rqe1eZgQGoS5IhWV4/seNecBSMTG+0hAtrlq3vrxM7ROXkuMXuD5rM4ZFpWkLvZdtjOd1hXnSOudfpRxodgmFHEAqlKM5TrglbtSdTLSpVtcKvTU1cb1wO3bAfAkIBWbGRrNn9yJxLQUJcMh7UmYJX7KvnbYkG4dp6nNLd6iXgUdoBiZoUv0ybTf4k70AHPeSdHGPUzxyGB3GzCEh28aN31PolhrrS82wgXRnbp+zSkyRy/YEySQ+WOyZiRf/UCaLb5u+H8JdGo8YQAyEQFiO8e5/0TP+FrDxBpnssKfF/N90cQ5XbsoJkF80ytpIhFOpAMTSCJePWXi3w/gs19g+aPc4fE5p1+9MFtLttNR3VbzvU/RupYxwNZKPZoylLWldEWIcWRFfXY5vrGYFF1NKd7udt7/GGQH4V+XB5lOpu8Onr8Mw41s9O+ze2KaprwxCWngwq
 yrFNcQK9
 dRtJ/QFjBiD2zl7B7q9fjdu/aryF1ZLxVHTBIkmHXKKxY4cBeRdUtjdoQQ/zgCWzhDmT84DdurIZt9fEoQwHrLMNFLhRnvuAZ8fwdYfHEdZRbsHY1GZjCpRD99r3vSL2uTF1RvqyUvC3CUV90pJ7bBKCWcVCdB5nx4VqauOnj5hiobqwr/8AyfOfLiAYPQGnRcajXQc3CjqcjINzPy8wscd5ArHNPHmNeT2mTGVsDqoVQCIxG0wH95xQxZHfrQdLZyzzCKXa7KXrRWMrqful77UhHQZM/VuxeexI8n7M7KCABzS0+dM6aSTv5vlPWnnoV4g/WFdaPmBzpzMQ583Q0NvD1r4YhcNqfKIKXRgZycoU5eYnS2bYr/GVlmaVmENwymTxJtvbfddNOaZ9lNAcCNUYx2l8dc6yovXmqOuFyi8AjCut0V6QLckA36gXYI1VbNWyBoMJle7ykSvTd53mXdeHlAwwLE8vNnV31kJWJ04lvumcznbi985m+tuCb/pP8OG154S3h5+EHnnxZ7sepkvBkdr9k6DqGG5QDW1aUvZDqPHSjkzUTnIOf/2O8rGAcFGpENeA1cuSEhH/LRHVPNVyv0WZjnDTsfNEY8NyoZZTtjtIVNbwUJVcxi6Ncf0ozimdt2gaByoxRA92PiQH6037dE78xK0cfyybFhn00/cu/xVPLTEGIQ2GtFku9Ay3AJzDFyT5pbW4K72w=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Hi Joonwon,
> 
> On Wed, Apr 08, 2026 at 10:06:42AM +0000, Joonwon Kang wrote:
> > The invariant "scan_hint_start > contig_hint_start if and only if
> > scan_hint == contig_hint" should be kept for hint management. However,
> > it could be broken in some cases:
> > 
> >   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
> >     scan_hint_start < new contig start) && the new contig is to become a
> >     new contig_hint due to its better alignment, then scan_hint should
> >     be invalidated instead of keeping the old value.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (new contig start <
> >     contig_hint_start) && the new contig is not to become a new
> >     contig_hint, then scan_hint should be not updated to the new contig.
> > 
> > This commit refactors the percpu block update code to make it more
> > visible on what to consider, e.g. when the new contig overlaps with the
> > old contig_hint or scan_hint, fixes the invariant breakage and also
> > optimizes scan_hint further. Some of the optimization cases when no
> > overlap occurs are:
> > 
> >   - if (new contig > contig_hint > scan_hint) && (scan_hint_start < new
> >     contig start < contig_hint_start), then keep scan_hint instead of
> >     invalidating it.
> > 
> >   - if (new contig > contig_hint == scan_hint) && (contig_hint_start <
> >     new contig start < scan_hint_start), then update scan_hint to the
> >     old contig_hint instead of invalidating it.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (new contig start <
> >     contig_hint_start) && the new contig is to become a new contig_hint
> >     due to its better alignment, then update scan_hint to the old
> >     contig_hint instead of invalidating or keeping it.
> > 
> > Signed-off-by: Joonwon Kang <joonwonkang@google.com>
> > ---
> > v1 -> v2: Consider cases where the new contig overlaps with the existing
> >   contig_hint or scan_hint.
> > 
> >  mm/percpu.c | 124 +++++++++++++++++++++++++++++++++++-----------------
> >  1 file changed, 85 insertions(+), 39 deletions(-)
> > 
> 
> Just a few minor style nits; checkpatch.pl reported the following:
> 
> CHECK: Lines should not end with a '('
> #173: FILE: mm/percpu.c:653:
> +       overlap_with_contig_hint = pcpu_region_overlap(
> 
> CHECK: Unnecessary parentheses around 'scan_hint_cand_2 > scan_hint_cand_1'
> #258: FILE: mm/percpu.c:699:
> +       if ((scan_hint_cand_2 > scan_hint_cand_1) ||
> +           (scan_hint_cand_2 == scan_hint_cand_1 &&
> +            scan_hint_cand_2_start > scan_hint_cand_1_start)) {
> 
> Since this patch will need a respin anyway, I think it would be better
> to address these together in the next version.
> 
> Regards,
> Kuan-Wei

Hey, thanks for running style checker for me. As it looked fine when I ran it,
I guess you may have run it with `--strict` option. I am not sure if the strict
option is required. I will keep it as-is since it does not seem very important
unless it hurts readability. Please let me know if you think it is.

Thanks,
Joonwon Kang

