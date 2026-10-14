Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2CF18CC6B2C
	for <linux-mm@archiver.kernel.org>; Wed, 14 Oct 2026 21:45:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0D0CF6B0088; Wed, 14 Oct 2026 17:45:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0818D6B008A; Wed, 14 Oct 2026 17:45:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED9156B008C; Wed, 14 Oct 2026 17:45:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CA22A6B0088
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 17:45:48 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 59AA9407A5
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:45:48 +0000 (UTC)
X-FDA: 85322564376.06.F07C27D
Received: from mail-pf1-f172.google.com (mail-pf1-f172.google.com [209.85.210.172])
	by imf04.hostedemail.com (Postfix) with ESMTP id 77CAA4000A
	for <linux-mm@kvack.org>; Wed, 14 Oct 2026 21:45:46 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bH4+8MRN;
	spf=pass (imf04.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792014346;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=l18nddR02Ly5yUEL8+YeO6wSXsyRxbRSYGcpS6xzygo=;
	b=x7HqvgiugO5Q7Od6fsXoklnFS3vnQ6NyPj4wBmNI4XJuEHbTxxvKMMEKBXPlU2RT91zq/N
	ANGLNi9FiypPIjDHBFHf29MEg2PskvNdsvsM1s7EIZcjvlpBM96dVICjW/aoRCZYttl2k6
	jJfzUbaiqpzx292cD2hwLd0M9mrBJSc=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bH4+8MRN;
	spf=pass (imf04.hostedemail.com: domain of aa9736195201@gmail.com designates 209.85.210.172 as permitted sender) smtp.mailfrom=aa9736195201@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792014346;
	b=Wt0Cf2wRESEM3mSC/FiZU/sbvEeb2fWcYnm/GkUpbmwFkChKZTOAWAFdccf8Zqefm3Zpzg
	yICe2/8uM7LwS9CDjzlnQpRR5mp51fOyAuFpA7/8Ie9ma3+WbFADblH29I20fl+yMO/3ZM
	evHAs7GPJjnQ3mlpOa0Oskj4zQRADAs=
Received: by mail-pf1-f172.google.com with SMTP id d2e1a72fcca58-89e31e96173so300810b3a.0
        for <linux-mm@kvack.org>; Wed, 14 Oct 2026 14:45:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792014345; x=1792619145; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=l18nddR02Ly5yUEL8+YeO6wSXsyRxbRSYGcpS6xzygo=;
        b=bH4+8MRNyjxwyHgkhL6e1MtzHuCh37IR5ihPDE873eHxEzfOKEHlc6Lk+mVBAPDbhZ
         H7UOl5oOfEGv2vp9DXFa6zCQea1O3YbIjbGnbYd3vMcin4xnUlZUm75Y1q5HPLxLJdke
         0GSWdcwxE8S1+8LM7HaOvI6Cw/Tqarz8QYqOmIvx21oEJT+AHb+Y/6zTi/3gLzsXQGrW
         EESlihrSk169EJlU1VUjC8+thHk4gzRrx7IfkJ5McAFC1VbxHcxigNm1yplXDeb/eEME
         4PQee6EUzwOpkJ0yhFG7MsNtilr7TNpqIm1BDWi5oZcgYak+H3p0DymQxMBX2Is69Zxf
         0N7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792014345; x=1792619145;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=l18nddR02Ly5yUEL8+YeO6wSXsyRxbRSYGcpS6xzygo=;
        b=l4sEMh/+wTBrjYNaOcFWn/OkOYsVgCvhmr0c0R3sEfjzKjWpXLqE6AWWCyjmcf5vvZ
         2t+SnnmrYheVJI/sixVcxfMO7bYeOAZx+va73KnVVNyjzHI5KkZ6cQUvfHEGCLweS6+H
         p99QxeG8cqx9zRltdyORQBbTshsd/VPcIVxzxbE/sXh0IwpYQfB0B6ZaApvfLI3dRULA
         R/344AdyOQ3J5585Ohgp6KzUcY4nWRFFEpA77j/gT+yYnV3M7yTWHfT11PF64mgz01N3
         ERRZj3ox9FYJfn8hR8sossp9KV/XY2hZXGJiKCAy8SEMRuO08KwJNq5gXcWrIxzYjLI4
         mhgg==
X-Forwarded-Encrypted: i=1; AKwUvBysBS6B93dJglp6SYKnQxQYs9HOKeHKNrBRSL9ZfB5BqV4pm8uKD+xWtAtOptIX5pCtuFD8XICSLw==@kvack.org
X-Gm-Message-State: AFq9FYILtoZOG4uAOe4cUO16gtC5v/jbjiOt6mWxlM0DZjlm7AMH7ivH
	rCsTRtqAMSwctZ5gFc2zannxRgtfZBP2OVqysnq9LuY4Kkg2PxGT5nmq
X-Gm-Gg: AYBFou33We9l9KFVTG0AZ8iDEnD/0eEd0DHyeLIdpV8bJDnpQOxLu3XAoTCugGt6Bxr
	7W59JGJNh3phJDdAoJtfIgDlFjjNjZU/vz/DSILETYonpvd4jHp+sIizneWxrCDZER2vNi3xwsw
	/8oGBot5UhCBEs0r7UG1CHZigdlDQo9EOfuHCFeuS4pRxJAuUNAYQTRS1IImYqOfhNHvesvH32W
	46FliIKBhs5tu6wthSlhRmoBmVNafQxy6a9e30CGpQq81h7GTzbtp0vM130BarAr98Yqv76xw1e
	HN6Z0GvF3oV83b1NvOfh0Vubi/oaNii5RaQHiZ+qBpv1TdbnyEeAUiAbTOydzndZG1zDD4jWDRL
	9TfS51RrSF6sDZo0fMz80kjMhn0mz/MmbbeR98Putj7UKc+bYkP1+mlEq1k1l7o8dx80DO45CtQ
	2BR5vfXT+0b9MFlC864jW+coP1S4zcAQAk4k+M4hQNwlQtc8eSzzknVWTaAHAkUNgibbhm5ouot
	G2iHBzMXaAakzve1qW+yoRF+sQg25zX1RfoGKE/BGBoJYHEsvTnSw8wzCbV89V0Z+JvSAjZP1or
	WgfGs1/nGLNsKi655TtTUmJIzHh/xTgguw==
X-Received: by 2002:a05:6a00:1818:b0:886:4070:ceb8 with SMTP id d2e1a72fcca58-897c7ec59femr15310243b3a.56.1792014345179;
        Wed, 14 Oct 2026 14:45:45 -0700 (PDT)
Received: from DESKTOP-TJS95SS.tail460ce2.ts.net (36-232-253-46.dynamic-ip.hinet.net. [36.232.253.46])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-89d802c33fdsm1539946b3a.22.2026.10.14.14.45.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 14 Oct 2026 14:45:44 -0700 (PDT)
From: Yuan-Hao Hsu <aa9736195201@gmail.com>
To: Rik van Riel <riel@surriel.com>
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	linux-mm@kvack.org
Subject: Re: [RFC PATCH v3 0/8] batch lookups in follow_page_mask()
Date: Thu, 15 Oct 2026 05:45:39 +0800
Message-ID: <20261014214540.574-1-aa9736195201@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260811025157.1632867-1-riel@surriel.com>
References: <20260811025157.1632867-1-riel@surriel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 77CAA4000A
X-Rspam-User: 
X-Stat-Signature: ym7kutdo333jjqijzp8poaqibf8kjqrr
X-HE-Tag: 1792014346-83064
X-HE-Meta: U2FsdGVkX1/Jl9Q/h7cpWaau/9c2TMzMgkpDAOxyqrRFv7L1K2eBo8XFYyBuABteSB9FqqW5oTTRwTw6Ksie2lhpKq+4x3Le5Wx3ND9/VBuVKuwk82UV9jgtCnjQwYXn7Wm/dqaeEcizeIS/LaWjtpBftMzHgRW+ZYf7FmbVEEz4iW8FtCmCq+0oP1ZNOpgt/SdN03E6G7YNoerRdckB7djhViDmjD6KcufzoBb0vztoIYEXqIIqq/YXz2tRVcfekcT5VdYCVY0a8Gxh5vWSx91yafokbd2XLwlFYPGlyMpcWbw+O1Bl+RcBrzQSMbeDkHAFa0c8kUE7Nhp5itfNbjMs8jur0WmkQIyP9KakakjX8ALOZhO6yUdXgCxEwN8qIzO1ufNNLOcQzyO1pIVxDqYcHjpU98lkPtTC1xpfJ/nhXsQPa/RcJCV54BUwcP6ArEiMp64uX8G9W+NAiGtND4DwRzGW0YtTr+j3inlNU8lkclnfN449Z8GK8psWMiAZiPJh5OFFkm9Im1PMjXbAy1st6fvDTj3yGrV93a21/4O7Kqjji8jEkZxNuoOcl6NlaCwwTJxJwKzggJcJcvhYEf5R/TV8WojHzjW/n1qVF5Ru1AreoiktQ9BmeKgGAimQbMZ+9BV0PjvlRJr4EZGtqgAfAv8X8Tu4S/fSCKpJpvqJZ08zcmLOBvzJBIcGeXNAyNV/3EzijbJqU/pv1vffYjGmBxLfNwfAozUtfwmXC+HGELjW+i8IrbKCroeRDuAAKVzBOLslWDEUcX+mFR67VtyR918ZeFrQg/R0zU+OpxYakt+ajPyrV+RE5RxEqtum0cS5ESadVdLQmv4zJ+r7OU941oP4Kw04nKGDr8e/Yo8Uw6QE9A8g2tgr38hfqDYXVw/orvMEg71SYDg5fdk2nyhFMjySd2zxILA/qw/aazgXC7xs34EMdc2QPy3dvNG6QhMvBDp4JEAGYBL1RvI
 EElz6Od5
 bsqmrBiCGIECKsvPrLCbzIwQuEM/aA+CgCgZUtg+2tnG3Lx/Y7MAgqG1PgRIXyKs+wpfLqU5dUxqf3zX+LGxlLKFg+DnqtkPyrwGOrn9JOAo2TclZz2r4AjnjOYkVhZkgmzVZQzZBO4fq7bJYgGgk3if+7O+5BDWwqxCnHp+gl5uj5huxPMatZ53U+4554iR4dSj4wEoF2vC/jjQ48NyDyVvX59KaxD2pGjKCPWtqE6olLiPMDktmkQopPYj3dWp3bSw9D8fVkOE9igPeIWndtczUy+B6YMrRJDX3ixuaHjj3N/QXgK9TqK5k2/Jrm0fUWr0ez8DX2R0ep8wklThtoc/CyDdhgbiq95MEOkl+MdPrDUIcQMmdJKzYtdY9aobju81+NrP2onqe0Uw+Xm8jkScSZ0FYVoeC+RGCfZ2TtV5nfzNoq/oROcF/EA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 10 Aug 2026 22:51:49 -0400, Rik van Riel wrote:
> This series changes follow_page_mask() to return a page count and a fill an
> array of pages, instead of a single struct page, so a walker can hand back
> more than one page per call.

Applied the series on current mainline (3857c2fe5449) and ran it
through the mm selftests with DEBUG_VM and PROVE_LOCKING, a race test
that drives get_user_pages() and pin_user_pages(FOLL_LONGTERM)
against mprotect/MADV_DONTNEED/MADV_COLLAPSE/fork on 64 kB and 2 MB
folios, and a core dump of mixed 4 kB/64 kB/PMD mappings with holes
and a PROT_NONE page.  All of it passes with no unexpected warnings,
and the fast path numbers did not move.  W=1, sparse and the cross
builds for arm64 (4K/16K/64K), i386 (with and without PAE) and ARM
nommu are clean.

pin_user_pages(FOLL_LONGTERM) over 64 kB mTHP, the whole region in
one call, median of 15, base -> series:

    16 MB      138 ->   15 us
    64 MB      566 ->   60 us
    256 MB    2318 ->  249 us

(4 kB pages at 256 MB: 2361 -> 1065 us; 2 MB THP unchanged.)

One thing worth knowing from the 256 MB run: the unpin side goes from
94 to 180 us.  The unpin time is the same on both kernels at 16 MB
and 64 MB, which points to a cache effect rather than extra work: the
batched walk no longer touches the tail pages' struct page, so
gup_folio_next() in unpin_user_pages() takes those misses instead.
Net 2412 -> 429 us.

The one change I would make is on 7/8: the pages[] fill and the cache
flushes now run under the PTE lock, up to a whole page table per
hold, while 5/8 moves that same work out of the pmd/pud lock.
Details there.

Yuan-Hao Hsu

