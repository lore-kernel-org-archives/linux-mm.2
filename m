Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AF4A7C55174
	for <linux-mm@archiver.kernel.org>; Sat,  8 Aug 2026 13:26:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 890AA6B00BC; Sat,  8 Aug 2026 09:26:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8684B6B00BD; Sat,  8 Aug 2026 09:26:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 787B26B00BE; Sat,  8 Aug 2026 09:26:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4F3DC6B00BC
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 09:26:45 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 39B6A80369
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:26:43 +0000 (UTC)
X-FDA: 85078177086.06.5B987A4
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
	by imf05.hostedemail.com (Postfix) with ESMTP id 6B6F1100009
	for <linux-mm@kvack.org>; Sat,  8 Aug 2026 13:26:41 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ax3PVdfH;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786195601;
	b=dZQ/ToRZIUh38b/UichcbmqQAx2a5vPZO4bnx/TlkaHGA5k6WM3opLKbjF6WIL/8qUOyxw
	mWWwi6TKmdK71ljfgsxAJkDjnc5+YxEN8XqC6+jnG2gUrLJpsaQ3il0qHM0eytWhHk7uTw
	WSDAdypRAw3NzzL1LttsIkl/DCZNKRU=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=ax3PVdfH;
	spf=pass (imf05.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.53 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786195601;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t9E1a2kLGvFYXzBwJKT2QHl92Z0jFI3rJy3UAWTsihA=;
	b=T1KqQGCjIYHhYeoAjISJZMtEGB49AeRkqJwteXF+HAsj5Q/GI+BfEfE1xMiKPSKbSEevLE
	3kTGyQvgQ6Hy0vMRFa9HB8UENTfxpQj148YXogSzCvt7ugC84DS4yzkqB7r1MN0DhWP1x8
	tVU3LHB6jmYT6inRjYfPSt078fHU140=
Received: by mail-pj1-f53.google.com with SMTP id 98e67ed59e1d1-382ef647e20so452059a91.1
        for <linux-mm@kvack.org>; Sat, 08 Aug 2026 06:26:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786195600; x=1786800400; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=t9E1a2kLGvFYXzBwJKT2QHl92Z0jFI3rJy3UAWTsihA=;
        b=ax3PVdfHnr+90IQkfeTl/uXt7vqS4PciTW7DBmfHHWNsC1NrVKXHUMGAqJEc3NbU+0
         voxxVR/KjBNSEfVYUoMwIwtF/R5B8Y2j3dtFRlOwQLB14gU8F+kUSVNbbhgslv3jj7wx
         K1WOZ2BHVfLPDWcvVLRBoUdXQVS4LYVnly3+IG5p2T+kcQlXJPK4MTyYaffScw4CPhr7
         7mOCa7MJeCHCV7Tf5EuIOyHlFsFZnCDxPUKIFPWeyym6G5x9KSx3ACj4578nyjf7GuC2
         MEoT/Enq8bbPWfXLcEqxGO9v/WmmU0uTgoywl4kVwf4WDYNgZT1jxH5S7Qn8sP8JieB5
         flKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786195600; x=1786800400;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=t9E1a2kLGvFYXzBwJKT2QHl92Z0jFI3rJy3UAWTsihA=;
        b=azUZD2i6ltPRJIYhUpG9xtcwo0rGMURet0cEyi0vUVl0x8rFDIxqyyTbVDVghB9THw
         ccM5IHOFDGg3p3Ob4pBY1eq7GAPzgzegW1u+RxAqut3YS+vnnIN3WDr4oInsBp1fbqxp
         ldATL4Zs2DVg4rRksLy3UpK7EMkUBs3kIG+UxaMatmEi3n0OT+PJnpfWwRToeewt9CoP
         LVEhXdREOpO3tZnepYpk4JHA04gTzMkbOkHEnjY16cXdQ+2QJ575yyJ8hVG+yfk/XuUu
         wGhMpqZxvXqzWhBpjaFUpqSO+AgA9agsOcMsC/ZNyYWNun8vZnUoHRaEt6R/kHUimmFB
         7NYQ==
X-Forwarded-Encrypted: i=1; AHgh+Rpp6/Yo1hoGwg7MN+ef/o1hm5Ahde+lDDe90sZk/5fcRMc17Scpft6BMamafZcTOE2n1Ja75uj6GQ==@kvack.org
X-Gm-Message-State: AOJu0YxcYba9B7UzDYhgDq6u+e30OypRNsLz+Ydcby0FTERsZlP16bRu
	an4LOfmz2A8xJTpez4iJR7rwqhdL6jksrQi7yh1IGZ3N7ofje2caliTc
X-Gm-Gg: AR+sD13m9l0IHU0kv08x+IDOGq/JQpPfco1bAJdXfbJoRDOEqRhSuTXK0mRNepYqWYj
	mNaqHLHomz3o0Z0QMAkQ7y3OS64j3m8KEO+IA1QtGk67nwhUtnhxhj2JPp6TwerNivLE/FkOlfn
	bBsxKZujl5uwVQ6ymSsYlYSz7KaTRUOIIq3farH8cdRcGrk9iStYO+AayaFWhBzavq/8O5DIc+3
	YEYoktmvnQqeV+0/9mlQ6lcFHHs4D98pqi+PG0ahSonHJ6ej2vJd1d2rIh9siFzaDfF4GiD41ni
	+N7nZtPcAgcYmZUxetYLs0WkdV04ozdDNH7BEN+3mLXPdQen65H/9dBUbE9JzPasCFxwBdHsTX+
	w/FpwTzGbZ7IeTPv7RpesD3M9g5PNBgKz10TrRNYTXLNrjZWyqIwV5a9tN3Xct6IN0qTcrUohiH
	++2lbGPlUODpPaQelauRLhoNk0Rs8LgHYfePuNwifPmupjZg+6kBDgPgZh2/eHhmB3CHvVMheca
	6K0TDsdfnaD+O9HvzZxFc3HEM95JWdigl0f
X-Received: by 2002:a17:90b:4d84:b0:381:5bd6:eb19 with SMTP id 98e67ed59e1d1-3903c5dfd9amr28471631a91.18.1786195600291;
        Sat, 08 Aug 2026 06:26:40 -0700 (PDT)
Received: from KASONG-MC4 ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-390b370b145sm2711263a91.2.2026.08.08.06.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Aug 2026 06:26:39 -0700 (PDT)
Date: Sat, 8 Aug 2026 21:26:34 +0800
From: Kairui Song <ryncsn@gmail.com>
To: Youngjun Park <youngjun.park@lge.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>, 
	Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
	Barry Song <baohua@kernel.org>, Jianyue Wu <wujianyue000@gmail.com>, her0gyugyu@gmail.com, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/4] mm, swap: don't free a hibernation slot that is in
 the swap cache
Message-ID: <ancub7whkE-OlU-0@KASONG-MC4>
References: <20260806190636.446205-1-youngjun.park@lge.com>
 <20260806190636.446205-2-youngjun.park@lge.com>
 <ancWz-4R93dnNOXn@KASONG-MC4>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ancWz-4R93dnNOXn@KASONG-MC4>
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 6B6F1100009
X-Stat-Signature: acfau913mtcb8apu1iw5f1hobxzxadhj
X-Rspam-User: 
X-HE-Tag: 1786195601-388241
X-HE-Meta: U2FsdGVkX1+5ha1R1GlLypxELD8s5g923jP3YbV1YgxerBsD9Wt2TTzEvsYmNN6rF8Hf+43qdvljiw6y50fYag/WNR0v9qxOXW4oUBIDgGCDyRhsVBfplwIPBiO0dF+FVqBzX21aTtJYF20O8Jf4b5QDBvk7xmuEOpprNXqiFKZUe0DamsgM70ghLzalQvmiEvdGt74bXQhkNCFT5CAZgOA2PysTNiJcS21owK177RiLopqr6h3X4SUP4SbQAvK0C02nJXxDsn7ZBWxwLn6IdzBZOcHQ8dcuvjOIgz6o1LlNe+en84MicAngXGd/txGRY16q/EHlSmW1FGp93wxH5eHwVnyh/B3pRIcC100DgL+nTdQm3fN0T5qzYdqixL01mUA3EDBdppFzecUIvuQuvilQRiKOqzR2671WLRIrTzJ8wtKp6P9PAbqVbL3tNVOLNU6uejGFAoa15ZnsRXZ+RHnR+HPU1cUVq9o0JZw5/9qn0NSna5xU2U//Ko4l68Uac2Vpk6obYkFUX5pozxxxxFuGVnXiJTkJb80bBX5WifxNGEzRtQxlcAuujvgICmeaLG8tCzOTat7R2Mx+gjhIuTVKDZLzRJf6k23hTsSGQTITOQdGUaR2Qt6yC2M6S5iwNnxQPo9i0JXBUds0n0zfhRRVWJYT/kuGCq5OP4dquCXO6ZYvocI93kORFMeZKfEmaQWGFYLe1luVDCXCWbDIU08Hgqq5Z4Gqhal4D5ixkThZAGSiqIUuXuN2r/wjr2Te70Lu/mk6Qu3ZtY5/p5VMxHQuYP50PM6mGzqDTS44cmqQ5Mk/0+G6ar31b9jrOn1P/cZTc5QM7rSDK/5lfh+xi73yfXG9k4+YjLXV0szOv9BxSPcaTjYgTQyGLivXaYH0IxCN/Z4UBpC2WhF78DlmBsTcWghOIlnTOEkSN8Gdw8gzoIVy27vKG+IN6k6R7cDVQbOKaS0735Qgyx8g0Qa
 7na8CZr1
 ySofKgJ8YOrYxOoMDfVoo6i0tfEgj3RJiMMxP6gQmYl7kdiaQwnJsxOjbLRpq1Est2PnB2cUeZwKXR9H+fUa5ntCNiCYtwunIuwVkgVDVQsR1wi4aFtFNto1qWOLhxXetNgWNZ3m6PAcnaG8+1PqG3GcPQU0LH6K5g4fhbag9lvoEATfz9xTkMc7iRxobOreykGiF0sFbVO44/tbkpAK47PSvgRnDwcjLowU0MiCHBa+QyYQcngeFuwAxjxYV4uCc2e6/mK4+8p0ZRaL4HoWTVL65EqcDy83bRzDhiNA0XB4LuL34jIJAfrJ9F+iCjB0HkdZ3ihOGjwPYO13qP/Fw67ea52SK59QNPyOFKMQBKMILeirYVVcooFWbqmUoGnJmlxZTVZUIrjgjVlz595Ro4n4FyL9F3mjHVb5gr19oKHccW/uQiNXN6I/JDV4+71h0tklEeyKjKWYpTHcI9YOJB6z29vDctqcAbg81
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sat, Aug 08, 2026 at 08:09:44PM +0800, Kairui Song wrote:
> On Fri, Aug 07, 2026 at 04:06:33AM +0800, Youngjun Park wrote:
> > A slot with a folio in the swap cache is freed when the folio leaves the
> > cache, not when its count drops.  swap_put_entries_cluster() follows that
> > rule.  swap_free_hibernation_slot() does not, it calls
> > __swap_cluster_free_entries() whether or not a folio sits on the slot.
> > 
> > Cluster readahead can put one there.  It walks a raw page_cluster sized
> > window of offsets around the faulting entry, and a hibernation slot passes
> > __swap_cache_add_check() because it is not a folio and its count is not
> > zero.  Freeing the slot then clears the entry under that folio.
> > 
> > The folio is now unreachable from the swap table, and the offset goes back
> > to the allocator.  The folio is still on the LRU though, so reclaim can
> > pick it up later.  It then takes the old offset out of folio->swap and
> > overwrites the table entry there, which by then may belong to someone else.
> > 
> > Check for a cached folio before freeing.  The slot is then left in the
> > ordinary state where only the swap cache holds it, and it is freed when the
> > folio leaves the cache, either through the reclaim below or through normal
> > reclaim later.
> > 
> > Fixes: 0d6af9bcf383 ("mm, swap: use the swap table to track the swap count")
> > Signed-off-by: Youngjun Park <youngjun.park@lge.com>
> > ---
> >  mm/swapfile.c | 9 ++++++++-
> >  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> Hi Youngjun,
> 
> Thanks a lot for looking into the hibernation issue, I've been thinking
> about using a exclusive type for it, glad to see actual code for it :)
> 
> And this patch looks good to me, nice catch!
> 
> Acked-by: Kairui Song <kasong@tencent.com>

Oh and I think we need to Cc stable?

