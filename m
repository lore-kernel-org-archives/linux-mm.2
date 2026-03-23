Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C65B7EC01D4
	for <linux-mm@archiver.kernel.org>; Mon, 23 Mar 2026 12:02:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 280C86B0089; Mon, 23 Mar 2026 08:02:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 258A66B008A; Mon, 23 Mar 2026 08:02:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 195D36B008C; Mon, 23 Mar 2026 08:02:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 09CBA6B0089
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 08:02:17 -0400 (EDT)
Received: from smtpin14.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 8223713C065
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:02:16 +0000 (UTC)
X-FDA: 84577189872.14.0419F91
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 904A740014
	for <linux-mm@kvack.org>; Mon, 23 Mar 2026 12:02:14 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QuhRDuSc;
	spf=pass (imf04.hostedemail.com: domain of 3xSvBaQsKCHYdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3xSvBaQsKCHYdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774267334;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=11OQ308MFdLAcgnywhabzk972DmGk7CFqQqmesqWA8U=;
	b=yUT2lnvgbQbPUuweMknqFUPAXupKYBqNm/31ymm+m/I4eRTfz5+cAUx0AAKo5t3IX2ZnL4
	ax3ode9oW0xcGv4CvSnnkyprXqcPuxxgcCCQOkhoNiihl5VrCo+IEJ3GKEY9eQ/z8S0H0p
	v0ZWfUVn4H9vdvKsgu3MzIsC6S7yK+Q=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=QuhRDuSc;
	spf=pass (imf04.hostedemail.com: domain of 3xSvBaQsKCHYdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=3xSvBaQsKCHYdiihqiheUhaaiiafY.Wigfchor-ggepUWe.ila@flex--joonwonkang.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774267334; a=rsa-sha256;
	cv=none;
	b=FMgwEAc9gHAm+yOmG+Ylpb8w3NtdYAZtT4f3s2r9cqXYy6BWQymN1FIg7rjuQxRWZPngUP
	yoEypuP5vOL2kCWQlVUujS8fZFssR9bZYcHdSdDK2H2WLAIfDpYi65LL3qF083r6nvEg8g
	02fQmWxcGy/vZ1o87ic3kbbC4CNRSb0=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2b06c242a34so288460445ad.0
        for <linux-mm@kvack.org>; Mon, 23 Mar 2026 05:02:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774267333; x=1774872133; darn=kvack.org;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=11OQ308MFdLAcgnywhabzk972DmGk7CFqQqmesqWA8U=;
        b=QuhRDuScVuewk7mtGdiaehkGxK4fxyGHdnUanA+EkssA0Oe/Qn65w0d1zZl8l9xLqs
         Hn7C2w2A9j/i+bl0FoZAARTXg9q0L355OXL2HKGRAynusq5l7M/lwv9kmUSwrVSlZGOg
         Zr5CIP/x87lIGBPsSn4sb1P/0T6ZE6eQvD/Vw2iXQmTQfM27EmaY6lPMBuK4eXrxtDIC
         Y0+R6bBhzuoMkDfNUlrvGF6FtoXfRu98PT1B1/IhdwZlEy+pbigv1TNOtaTB5gcpjerd
         hL1W54hhS5cVRsMD729pZB7diZflwVNrWEzz+uF9JtDPL5he5/Qtqznk38WQwgY0DRmm
         s82A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774267333; x=1774872133;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=11OQ308MFdLAcgnywhabzk972DmGk7CFqQqmesqWA8U=;
        b=pRCFMDfaJ6//mTBZbKF2iXznIInp7HkrIwI2PYaxDbh8jEOTjxtNR8n+6AHjWuqsQK
         SSXzRoi5Xhv0GAoMQtS2oKw0AAG1riEEshLoqD+TzdE/C/q9TWsVmuLM/kpbykKjSzgC
         ZsmEV1IqxUFWegL/vdS9WcEDMlpjAOCzEVz7xspkBGem4G9ngadPJz6VTpbMwnD8msFZ
         b+DVHpSJaTatLJNsWWICUdIcwTR+MwvmJSAset8leTOzZUBzUGVfDvsYv7j6sIXJ2He6
         GnrvF1e2Uy4fPEYhPYG3BWcinbccCnezhD+gZXM6rCIdqmbxR5sCaSCLAoNYKu5PxZ7y
         xozQ==
X-Forwarded-Encrypted: i=1; AJvYcCWMScGHgxI08VBfF00CzB3jGsy/hE3OELfp9ftKLAg18zVweiT1ol6DC12m+B+cE0cuWyYT3u8CZg==@kvack.org
X-Gm-Message-State: AOJu0Yz5Poq0rspNedJ6886yMKhHuEFKo5RJHP606Q4Z9lS+FG/mJh/n
	wD0LnX6J7RV7CKcjwMHlaXebQQCz44ZGk/ITXWfoCQjaChkWbhTnD8n31z0rMb3cCHcdhOWIlK6
	jAOS/enUM6XCr3GWAI87yUSpz3w==
X-Received: from plba21.prod.google.com ([2002:a17:903:1015:b0:2ae:4efe:f1e9])
 (user=joonwonkang job=prod-delivery.src-stubby-dispatcher) by
 2002:a17:902:e74b:b0:2b0:5b4e:370c with SMTP id d9443c01a7336-2b082793bb0mr118653695ad.32.1774267333193;
 Mon, 23 Mar 2026 05:02:13 -0700 (PDT)
Date: Mon, 23 Mar 2026 12:02:11 +0000
In-Reply-To: <20260320120848.ba7ddc21aaa4edab8c2b5b58@linux-foundation.org>
Mime-Version: 1.0
References: <20260320120848.ba7ddc21aaa4edab8c2b5b58@linux-foundation.org>
X-Mailer: git-send-email 2.53.0.959.g497ff81fa9-goog
Message-ID: <20260323120211.3433694-1-joonwonkang@google.com>
Subject: Re: [PATCH] percpu: Fix hint invariant breakage
From: Joonwon Kang <joonwonkang@google.com>
To: akpm@linux-foundation.org
Cc: cl@gentwo.org, dennis@kernel.org, joonwonkang@google.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, tj@kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 904A740014
X-Rspamd-Server: rspam07
X-Stat-Signature: bzw4maizrw5oqr577gsfgwrhq5s47f1y
X-Rspam-User: 
X-HE-Tag: 1774267334-56094
X-HE-Meta: U2FsdGVkX1/i9bsw7BjZdWO6IVjjVm4Vg9N+br8dyzcRqWDV8gSmrvPRF+yw5MN3kKYWZVyggfnoXHY+snSk+8GU9flLjNt7bISzt6S54r5l8XhFhYANGVPtGgpMSQg5CVJDUBmRMker/JXEPn6NZDK48dMLoiFohru+Gx2hRnpPM2/vGL2xcgN42O0xx+KWkLtpmERQhECzB8s4DQGZH0LDuz1qrykqo8mfLK213W9x1AlKpNxzNa7LZlceP4Bj46YV9qrHH/fDCYi56KI+f5J2lFSbYKcS6eKX6OyVHnlz7y6ru9RjIyO7fOkxpUb19G+BOltNp2ahHMksdLyoqHqrvRuxt6cCodkLUhw3XOnAxCPArVyUQs9OpV382OK1x5d+7+jZ4/EOE3Z3ZSHxRiOiSGuR1rQ1UCfEwrhfb2kL0OnXAZytsw3sbXhVC3ycpSEjtotiXJtn5ClQS/lVTDmkoSXx96W2wdOXTgRQom1bt6R+6nRc7mZ6KHDzvp9Pai+2b9Wb6NXycH47oaCNy/i+++/oHVLWnMhxmy2ORYgqKxNevgpetilZ7flSIxB7eq4TnMR1OoN9KkK1+JbpGBeS1AruzGZTqao2nRzruPbhUtXD6mL+GmctspYO6yFrHy47q87BTJTi5HiOcGR6RIzn4N/ACX5bw/hPM4gkcRuF8hAjaWCTb6DPu3rmBj3HnGl13elqMSQDmT/dRNSeMqA4HB4vZg82k9G82+gl+BCZJAIyeDC/UnmY4Ol5WGENZEfDEuEzoVnMnCe86aqsH0Tu4yB442+ezY8JU1gFwWeIku8rlMFg7eGAAS37IdeW0x8jn3i7cEAHFDGjS6rWR94Kxqkgqhb64VrbB1seMqvRUCIfELxumOZe7OivpkttFsyVe8t+KP/mxkVbHHthfJLEjpueY4QPODEgAB/Gc6qfGp3JmkDdykKqHqWEJj76Derup05Rhi3w0ZiZoSl
 V7DrJdt4
 rLGMyYR0QiCxnKkWtOQf4g8xbtKal8ViBnFxwhqMzIKLTHmYnkw+TkEZiLyMVm0neKYnh0XTSKH400+whcDJWS7t17/4XIGRjqHTT2h0FrxNhFeSK0qQJXvMpuEulZbNyHxysjsHwTPZXVGEptf1Mk7A7IC2pOyVasreey2Kmh5YhMllRGXDmw7V5vzwKbI/ZF7P1Dudu+zuJgGLm9Ao6AqZ8oikE1cdv64MacuV7LCgD9/uX/z62UnqcVHpyJ6PaZTLnG4wfVfYjI94JI9Mo0lIMdghfJNgw/2GI8CO0JvBeyqPrGn7Z/clMpUFDo/xkopcGeWANlrxg41Lvk1Wv4C+ZZTdKTmZIpP8KthxPskmxnL+u71IvyPi9a3ouJEA2Ef2aausTDHckTPHjGOnAqjIFWBlW/iFhFxjLl1Xv1GXEQdgehtBQkU+EJ1WOLTk6p6B7SYY3tjtwo010jYME6772Ck7CGZDYxD/Pe7tYiMZr42GpeK4pIonXrLfEi9ovZGSjMfZpNcMtDZfPJ2Ury9dU7C7Nc+qDfTJ+xDDDPuDDU/6Q1eDpy4E8ZbZb5yF1ItZilDjhPxJV3JoyDOqR5LJfjYkReAaqK5TkTRA/y/Dy//Y=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> On Fri, 20 Mar 2026 11:52:14 +0000 Joonwon Kang <joonwonkang@google.com> wrote:
> 
> > The invariant "scan_hint_start > contig_hint_start if and only if
> > scan_hint == contig_hint" should be kept for hint management. However,
> > it could be broken in some cases:
> > 
> >   - if (new contig == contig_hint == scan_hint) && (contig_hint_start <
> >     scan_hint_start < new contig start) && the new contig is to become a
> >     new contig_hint due to its better alignment, then scan_hint should
> >     be invalidated instead of keeping it.
> > 
> >   - if (new contig == contig_hint > scan_hint) && (start <
> >     contig_hint_start) && the new contig is not to become a new
> >     contig_hint, then scan_hint should be invalidated instead of being
> >     updated to the new contig.
> > 
> > This commit fixes this invariant breakage and also optimizes scan_hint
> > by keeping it or updating it when acceptable:
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
> 
> Thanks.  Does the change have any observable runtime effects?
> 
> Was this patch inspired by code inspection?

Yes, this change basically comes from manual code review. While there is
no benchmark result or others backing up the effects of this change,
Dennis may help on that later as he suggested in another review. The main
point of this patch should rather be fixing the "theoretical" invariant
breakage cases.

Thanks.

