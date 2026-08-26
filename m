Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BA7CAC61DBE
	for <linux-mm@archiver.kernel.org>; Wed, 26 Aug 2026 10:24:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 780486B008A; Wed, 26 Aug 2026 06:24:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6BB366B008C; Wed, 26 Aug 2026 06:24:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 534C46B0092; Wed, 26 Aug 2026 06:24:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1E17C6B008A
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 06:24:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id E8C64A0306
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:24:07 +0000 (UTC)
X-FDA: 85143035334.28.33CD866
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	by imf16.hostedemail.com (Postfix) with ESMTP id 172A8180003
	for <linux-mm@kvack.org>; Wed, 26 Aug 2026 10:24:05 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gQQ152eH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1787739846;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pw/vnND8u4fIjmZBCSgSJHXI2o3qxjuK90n28G0R7dE=;
	b=RHJTe0UtaUdbB+lFcsziw2e88gdv7XUQbOrP2pSnmBXHYI7I3QybzDEyVb+oeAukspxhyD
	I62exvozuldazYwAwsenFV7BhvMYuwkxu/4pObVOHGGxV/IDm0t3pJ2kpUbY1qyO80kXDU
	SGEawJAAZsdW6ylxLLPnLlDYKt26rOY=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=gQQ152eH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.41 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1787739846;
	b=crx6VVzVow5OgdofU4FssvIsKmSJ2ui6doZgpIgath1zCieaI/kqzP0cdnqkJo2KOLlAd0
	s0xSA9tEoLomVMzfRFeZahdgbDVNpx9w2OEzzI0xWEF/92ni/lN/BOjCB1DV5a9NbhIWaP
	Kr+uWQhoNC1p4xGtAH+8BcAtqUAHa0I=
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-396750cfee6so628314a91.2
        for <linux-mm@kvack.org>; Wed, 26 Aug 2026 03:24:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787739845; x=1788344645; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pw/vnND8u4fIjmZBCSgSJHXI2o3qxjuK90n28G0R7dE=;
        b=gQQ152eHzFTwExFfQC7bGPRY7j/jninwKvX9s9fs2vW5RDGYxUTHylaiYdH0zKFnis
         qCa44JneOX1QogOTN+OCQaCEwioSs3pi6Z9/MZZbEI8BDhX8AOVE7oFQ1vXZq544vbac
         9cQXAxLvcJLhmhjYRfrcKJLP+jhSnVB6ywpxfduHKU4oSeW6zvVIgi2LHytZ1cYMqSvw
         iJXFwDiLW4ivxWUZStw7mrz5MwlhFwirVLi8hPQHziJ0mhKQmxFA4OJ0lLGUsGmdxgFM
         u4hrvFfabNGfjqPFI0DAtQw6h66JbP33+L0TmARzA4aKo7gSk69AadO6P4dxAqCrjiud
         LNeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787739845; x=1788344645;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pw/vnND8u4fIjmZBCSgSJHXI2o3qxjuK90n28G0R7dE=;
        b=To4RfHs4FEAKHOt+fIjrc672MFbsrIDO7HL2TO1W9wn+PLM7w5A/dBmmoRD1ogtN18
         wHAUzNHNLLuJbadAtRaNdrS9OQW5nKIMRsie4jLqN1oJ7v3pLMjL2MpsaiRUObBOuSRc
         EdmEwNk+ZfTozlOB6csZ2ciabFt8uU5zTI9SJkbcHqKl2lcPfGD/VTt8OAGiqVGbFqm6
         GC9FrW0S162HrCsogO38cLPyWX07Ge9VCkVbLocqCL3oVkOiNrQmhHKozuPVhUCIZUUb
         l6+6WQMEBq0SYkwcynrwIlazW883XS0+pavZwYM45lo/ii7yVjbKNcMHqO8bdMZlHZ31
         uB2w==
X-Forwarded-Encrypted: i=1; AHgh+Rr09jrL7RI9fP8v/3RV4D3ij+p66mRU/Tn2LcgqMJkjpLZT9pTSUeAemSS6Vgn11G3wMb18c2QVNw==@kvack.org
X-Gm-Message-State: AFuF++mIET3fse/f20yDwzFXVKJB7MAkaVSU2LWuFkwwnKvQoqMMQqF+
	BABUCtsYAgcbz6gexxX/cAiH3JcaT+nRVf5NEtbpgcdogdWJ8/oDlggl
X-Gm-Gg: AR+sD11RoHeWgI/HEwAJDqrTP603cURQQDOZd4gD+X16lJuibS47etHsN1Rmm63qL0a
	MLujoq2nDgWzN5hmQef/iYvNsoFtsbpD3cNNGN76u79S9dQa6CB4iVtgTuvXgCyhnwSlLpPG6N2
	F/6vAHAILhSZeKFGfMBy/zgSKzob/04xrccXmPH50fVFyTRSghl+3k23/6R9gXC2aZegGiTGGh1
	T9AhqxPuIukZ8Ev+XyoizNmkKHyBDkUtZxfLqmxE9bnljpOBj+YnGlg+IyvsNNt63YkwnYUhSdt
	5yQGNxEORo0/WPVlfFAXF5ZhadOSzenVfTZs4wR83J/tjG8v2kifKbLUGIQV7PjNlH+BlelQDJu
	6Yf2MHLqqRIhoeB+EqAY1Ku+rNB5g9uFK2Og9/EpwBKXvtgJRPmTMNXmCWJ9xKhqg4/bS2s1YMe
	DWi+582EPyxxB7sggDxM8o+G6aa403R5iktVB2s+zfl0Ky8Q2MFeV55U4TkzVWjy6A
X-Received: by 2002:a17:90a:c107:b0:381:a766:efc9 with SMTP id 98e67ed59e1d1-3966d412aa5mr12550916a91.7.1787739844634;
        Wed, 26 Aug 2026 03:24:04 -0700 (PDT)
Received: from celestia ([2402:1980:c23:7fa2:94a9:2164:3642:a5a8])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-141a905c18bsm7535836c88.14.2026.08.26.03.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 03:24:04 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: sj@kernel.org
Cc: aethernet65535@gmail.com,
	akpm@linux-foundation.org,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH] mm/damon: fix damos quota walk-position tracking
Date: Wed, 26 Aug 2026 18:24:13 +0800
Message-ID: <20260826102413.8466-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825135458.64555-1-sj@kernel.org>
References: <20260825135458.64555-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 172A8180003
X-Stat-Signature: 6rhudxyzbeteb84i1k7xngrozkcdbx98
X-Rspam-User: 
X-HE-Tag: 1787739845-213661
X-HE-Meta: U2FsdGVkX1/9MAi0KBhCmgFZIznd1MffVtheyXw0vxq+HY+xpY2Itr67Hn4AQnyGl6K1utCItopN6hUJVdIcGpj48njmfkXhy+CKJaZB2BJSov8Rj25wgSZIPQB+cIHRvo1QtQS5buJR1FJqKobaAH9FX1mbTzSCUtb7at/4GeyrGJZ+1H/NuuYjUGpsug7eycLs3XS6yVQyCZXM9/nz9hhAvv/LI2AXZkwK6L5AXdyHQYxzA9pvzf9zxp/WNqOJQVyvu5dLAgCpTvtj/XlillbL8CP8nkAKYoSK3mEY2TBG6gKOaNrpte3RF37celbENoLEXnS1s+QKRl2pW4Bzk5GjOSiQ/McX1urjHiGQMlExTBGqkFSC/HVa7Q7Tlh5sgVPFIGBRFDQWgxkjycbDpjGis0u7H74ZM57ANrG7DpupaPDE/tKXq31xkiIGHFbiKKMoTmXpolhGT5Nx1GcOfMIMFZ79YKTZ/j8Wz2DWCkfR1zEgkJmQPZooe26uRQyjLnZ7/PTBAI/hDoig9RPPkfHEoGeHlfcQMOaPIQN77q1b+h27PYTbI5zoS19fLwoBssAdDJq9+vc6AtBrSkZ9KkVZ8iPDVueVbO5DuScJRVbi6r4SgPCjw5Q6gVUkBLhACd6/gD01jfZMqjSZPjouiRI7UU5L6mDqUozUiXKqo4TukizQOeoKt8t7BTcRLQKMEn0u+mAgmnBVwhqAyDSdt2udJGdrviQjjo9NclloYqZxtuqA2EvrQK8ZAXKQ5vpB39cwCfS18AxEXkxgZBMWj/Mh9Gq/rO8gKuC8U6KVGIlYY/Stmgi9q8TKV0EaS5HPGamby0gAZEu0iJCCSxHIxisXAKmmNaBrw4lwBmeetj9bEBHl/RkuAPKlb421fFxRlLqc1OsaGUOjjEul4h6Btm6Kv3o2oHABn5+B0cfnWKsRmefQ5MDzbILi7pAlyAkoracwazc0fq2oxVP29VY
 joBxZJhU
 UPju/722/7q69SvpJjE4Oo5dJptljZhh6HKV46EXexVlPXkpnwZvFn9+YxoMVsKzAoEniq6eK36VVyJs0cIGgdXPwe38PwcTDQ3/3E4uUkI7erfv3RcXVUITL2EcGxDATjWMmu536w/TeXHsgFNzA0Rhn1XcIyjZy9P4AUQaWEyxChE3v3CVh55UvAPxNeBQKwLYBFCh9Yo/8DpxmGQJVz1S6vsQQjJ5IJr3PKXyKHpU4PZ9bwoU6tH5LRBLZ/dQHTG1Jo4+F7OZAOdBUpDhsOIzGAwXFXflns1OO/iopStVn3f4tASB7TOeFO4z705SFvU/5NixdO0Bfke6QgBMsFV9X/0fseNE6dXM386DRjv7dDN7XjDvd5rlDua7/XcNC+vKyTTfm5hdhPXswWyPhQhyl9Bqc6qNPs9RVxPBwRLLoRzTi0UjxBDrTf5R1A4zAhwL+
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 25 Aug 2026 06:54:57 -0700 SJ Park <sj@kernel.org> wrote:

> On Tue, 25 Aug 2026 20:46:16 +0800 Liew Rui Yan <aethernet65535@gmail.com> wrote:
> 
> > DAMOS uses charge_target_from/charge_addr_from to remember how far a
> > quota-limited walk has progressed.  The current implementation has two
> > problems:
> > 
> > 1. Once set, the cursor unconditionally skips and resets at the last
> >    region of the tracked target, so the last region can be skipped even
> >    when it has not been processed.
> 
> I don't fully understand this.  Could you please clarify more?  Maybe adding a
> realistic example scenario would be helpful.
> 

Problem: Unconditional skip of the last region

In the current damos_skip_charged_region(), there is this logic:

    if (r == damon_last_region(t)) {
        quota->charge_target_from = NULL;
        quota->charge_addr_from = 0;
        return true; /* Skip */
    }

Scenario:
1. Target has 2 regions: R1 (0-100 bytes) and R2 (100-200 bytes).

2. Quota is configured to process only 50 bytes per window.

3. Window 1: Processes R1 (0-50).  Quota is full.  Cursor is saved at
   (Target, 50).

4. Window 2: Skips R1 (0-50).  Processes R1 (50-100).  Quota is full.
   Cursor is saved at (Target, 100), which is exactly the start of R2.

5. Window 3: The loop reaches R2.  Because R2 is damon_last_region(t),
   the old code unconditionally returns true, skipping R2 entirely and
   resetting the cursor.

Result: R2 is permanently skipped even though it has never been
processed.

To fix this, the patch advances the cursor every time a region is
walked, regardless of whether it is applied or filtered out.  This
allows DAMON to accurately track whether the last region has already
been visited, eliminating the need for the unconditional reset.

> > 
> > 2. The cursor only advances when the quota becomes full.  Regions that
> >    are filtered out do not move the cursor, and the scheme can remain
> >    stuck on the same regions.
> 
> I don't fully understand this, either.  Could you pleae clarify more?
> 

Problem 2 is a false positive.  As long as the quota is not full, DAMON
will continue iterating to find applicable regions.  I mistakenly
assumed in the commit message that encountering filtered-out or invalid
regions would cause the cursor to stall.

This patch ensures that every target is traversed sequentially and
deterministically, even when the quota is set very low.  I omitted this
benefit in the initial problem description.  If you think it is okay, I
will add it in the next revision.

Best regards,
Rui Yan

