Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3E96F606A329
	for <linux-mm@archiver.kernel.org>; Thu, 22 Oct 2026 14:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=cloudflare.com header.i=@cloudflare.com header.a=rsa-sha256 header.s=google09082023 header.b=ZYi8atog
Received: by kanga.kvack.org (Postfix)
	id 5479A6B0958; Thu, 22 Oct 2026 10:29:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 51F336B095A; Thu, 22 Oct 2026 10:29:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 434C16B095B; Thu, 22 Oct 2026 10:29:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 1C8A16B0958
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 10:29:23 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id ABFD1A013E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:29:22 +0000 (UTC)
X-FDA: 85350494964.10.BD1BDC3
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	by imf12.hostedemail.com (Postfix) with ESMTP id C42D44000E
	for <linux-mm@kvack.org>; Thu, 22 Oct 2026 14:29:20 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=ZYi8atog;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf12.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792679360;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AepUBMEk9tXpEQAUUGXuQHkD4I3CSkHf6Wpw+Q/6E+o=;
	b=D+Qa6g5ZIKnXEk4yMjgIf6OOeQd5EFAUrkgrrJid8oz4t7R5WpNkwR33h+8RRfRAfo+Ecp
	EpxHKvqo2cffpAJqjJMhh+g1FkxxDb3WDLVApeNihSdso+j2qPKK7ib3agTarIeU4Otw21
	DlwqigSVw+g1DHAqfKGdNfPoaZWpUfY=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=cloudflare.com header.s=google09082023 header.b=ZYi8atog;
	dmarc=pass (policy=reject) header.from=cloudflare.com;
	spf=pass (imf12.hostedemail.com: domain of mfleming@cloudflare.com designates 209.85.128.50 as permitted sender) smtp.mailfrom=mfleming@cloudflare.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792679360;
	b=XO3lZXLFbbfz6Ckxu3AVlmA67BcjsTbHmIAULfoq8M1PUygvFu65WnTpT+4ej2WFfum2qb
	j1GQxNZ44q+G/WYTVoJ2NbOmujJyKchVrIcNK/a/svYWGbdQLGOJnw/yHO4owS0I0suolP
	iPoKtxfOO4W++fTF4HN27hVb/A2/pv0=
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a2000d5fb1so10183345e9.1
        for <linux-mm@kvack.org>; Thu, 22 Oct 2026 07:29:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google09082023; t=1792679359; x=1793284159; darn=kvack.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=AepUBMEk9tXpEQAUUGXuQHkD4I3CSkHf6Wpw+Q/6E+o=;
        b=ZYi8atogxnPY73Fel760QhWADUNv28Rsk1IzZu1STV+O+VC/DyKZWM4vgaCpJuLiI2
         Yl0ZXIlGmuPN79gN3x+18e6TfOFa63T6HFo8SIhNrDkwMwlsmU0IGKpdM3A1KTiroMo8
         UwbEDS1UGgLMvl2TFlOfXNaU2uNrsa3BTWZwFuntt/MS9jQ3uE4I6+y1zMYvspqDtFin
         9N7CdmJGXDJMi3c+zARBZucyI7AmcAI1ryZrxkN7QIW2/2E5pBliAymbCBqslqhD3XJ2
         0+opeekH80psqLbRPf61RG14RPgjGkfHNQDTqnPZ/7YSWLVZszfao+8AiKjIkN2E3SWi
         htfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792679359; x=1793284159;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AepUBMEk9tXpEQAUUGXuQHkD4I3CSkHf6Wpw+Q/6E+o=;
        b=L2IOW7CQ83rMVrgA5Tzw4+CkzAUo7D4Ps3MmMcMpa6RD+a33tmy3bIYYO9yvvhmm78
         t7qIQ3rrrb5Hj/fFMrefffj2pKsWXk7WNxw7lt0buMNXnppP/JxQHdlj7mkvnZLAFXBj
         3Jg42Xuk/VdGgahSBM2/GTatOk5Id0hpqU26HkHDFRfDPuiR+XXwhKiIf6GLWLsbsfA7
         cnOxeuyJgHXgoyEMB0qpKMCLoyT8Aw+N91b8vBG3zyL2xyaKP1WQQplpNgYos5HuVaoW
         lhBH+FK7r+9OsP/UMwJV0GlgNpT6GDL8oIzEIeFY8su/fW2/BgisxJpi+Fi1WGv7h1+B
         k6ew==
X-Forwarded-Encrypted: i=1; AKwUvBzAUpkdPMJIkDJ5Ezam4PNt2H9dhFmAQlqMTwsPyTpF3lqMaWEzGIVjCgIDw8eailwiFsWltQZcVg==@kvack.org
X-Gm-Message-State: AFq9FYJ0xLkTGlarKXZ4dtHK+zNKKxmMUPoUVcJVZyEU6WaLzDptFvgI
	TjaGH0aY/BncdKSINUhsreaEtoFNpUX2xkRNdYA7b1QfJe0WzBYN/In7Mu89CE2OzNM=
X-Gm-Gg: AYBFou1GKtHTGmjZt6A2UnbiHdUmWAHgXfMmHo0Y/5LWy4VYgsUhrgW5zeECVarENJf
	nM35GCftf2T22sNPHfkB6wpWiz1AyTFlhPYaCGTnZNUZtxtHxPOvviyzfZFqsELPiwiD3eAhiS4
	hJ+t8YoaV53Am0jJ3UXcmDLlFvsTJQ7cA3pjhLbvckcQ2xUwKbDA+IgbYxAQt3DGLGmqhgFKwAG
	6bMODDPo8H02LYekk2J+Z3HO7yuNNhof5PCKbS8T/a3CtBeCEzIFDYHdLRXLOllwI9zmH22aSUU
	OUjaMy09US/QairdyLU7TmB2r+3+Mkmy/pnTa7vuq1o0ADVcZM64LQYXbA/JkyQ/K/dFT2PMi52
	2FUsllgauSdwZrtmFkFRz4FIU+cth04gcsxg3/FbRe7nigIWMdnZeV3c+KQpLeFsBPbR1mr276i
	e2AK2m6ZMbhjSDCBKPgCh8xuNUju3JexS3CxAnUlaZBzWtldrz/N3ykWMYQ+6ZJIrMZKmShrUvf
	ULz4b6j+pB8iquYryfbbrk4jjm//ZN4I79rHDe+NpM=
X-Received: by 2002:a05:600c:6096:b0:4a2:fe1:26db with SMTP id 5b1f17b1804b1-4a20fe1270amr3372125e9.27.1792679359312;
        Thu, 22 Oct 2026 07:29:19 -0700 (PDT)
Received: from localhost ([2a09:bac6:37a8:294b::41d:9])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a2101cd7cesm791675e9.0.2026.10.22.07.29.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 22 Oct 2026 07:29:18 -0700 (PDT)
Date: Thu, 22 Oct 2026 15:29:18 +0100
From: Matt Fleming <mfleming@cloudflare.com>
To: Marco Elver <elver@google.com>
Cc: Caleb Kan <calebkan1106@gmail.com>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	kasan-dev@googlegroups.com, Vlastimil Babka <vbabka@kernel.org>, 
	Alexander Potapenko <glider@google.com>, Dmitry Vyukov <dvyukov@google.com>, 
	Andrey Konovalov <andreyknvl@gmail.com>, Oscar Salvador <osalvador@suse.de>, 
	Caleb Kan <ckan@cloudflare.com>, kernel-team@cloudflare.com
Subject: Re: [PATCH RFC v2 00/11] stackdepot: reduce memory use for
 persistent stack records with a trie
Message-ID: <atodIhryrdxsU5mB@matt-Precision-5490>
References: <20260908-stackdepot-trie-v2-0-1996d5cef732@cloudflare.com>
 <ateDvB145CN_R7CA@elver.google.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ateDvB145CN_R7CA@elver.google.com>
X-Rspamd-Queue-Id: C42D44000E
X-Rspam-User: 
X-Stat-Signature: 8recm5349zxfgb8ssqas3wknodb971hy
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam03
X-HE-Tag: 1792679360-741975
X-HE-Meta: U2FsdGVkX1/T2kaSUbtTehgdL4qUwuuRcw88lsofZNhVs7BpcrMX9r2fgWJpj6K85OkBH4krN5pZ8rmIrt+cBHMzLOVG/HLoUTi+4O3wFuKlYPCm6Tk2a46pj3U9OYkFErll+UDd4cTg2c/bJSDjKQyKKQTguojKDn+Tx7c48sUuD1kGIS18bP3I7pj+XTCawsO0hiNE2WAz5AAvYrtlEWrT4+tqZO8MBwKO6zAvsfDyCPZTMDa/atuoMsqlvtGrNkSK9zO9rJRBUrBdqx1yt4rXktrLnmaHQSY6qv5VlxdX2JBGzMGXoMV4m1v//ml3AKVpELanw6aPeU1NJwWI8IqIXo0Ykes6p8vsyLVI0Ng1WjrwtV9sCxYXZRVLOg0L4cgj5nbBGmzbOoECH33c8a9qvWruf4pE+WXefAY9EI5P0qRHKy1/uNvJEHn6lpLML0hUnrQbynHcOi5TCc693K5JasBJMmidTAAVD/2pdh+9xR8yXxuSL7B2Xu1oYQKb9EBhdzGLyFq6c3FjAMeIaxoJ2h84rCVXcI+7bPf5sYPcFbGmpJO8NYcHFWu7BOqkXsOYN/8AqjvBf4EVrXioIePztdhE2dQXl6wvFSAXjNEJPHppCmg3M1SHQZfNYkmcsiyYTyXAc8kxAGR2zQA63fs6riqADVC96iVh5J4iATS0ywHC9Kni35YkQeGdINHhFUwwNBS0+LueWRBvdLcJxoCQVeRHMJZ7n7HBBne7pE3l51cKVQs1Vmr6pNwnn6WYMuWy5XLRDDgRpgbiiLStDD0oCQvSENDUcLFXBeSY5cqYA1jro6fql0noTYw6NSayRqpyM6CeOf9NKr3Xp5JebRTVdzc60OpijPwtMTWcNN6hAEQ7iiqyxZLcUIU6guh/OmPzwpocbH9hnBWFgfkLEVyuYQgM0orl0A01IPzrfvF4HJb49UOxPyWo9L+9X5aKl7hPZACVaUW2LwPa2zm
 c2KMXEwV
 7F+q0+1QlfcIpamlzADhj2NNiiPm3MDT1DqQm46jEPnoMRe/EHm6lBjDb6fe+ldhRBSLITkV+Qk82FLkcZoMz0hKsyLe6k3aKnA1BxKuHgWGNwAyi5mhuzQm+q3xnBo2oPp1GzwcK7q0wgyR5Hp00t7onijbhAwmbE7BeHTaGCRQr5KFPNwBzNkietB7Q915DQOPi0fpUhmuZNUs4DU0zRKJWM3p6Q7SX3GEAm0zJdEUT2hQuTf3jPMMcCVGFTkDNsaaFBqCzIrm0yeDmVuGAaOdoKQvCVXue1ZDHmq9Z3edciqMthfOPfqaITPXYHRnmQkxRO81wlU4wG9DrS0vJhOKmhoA/O5y0+KW2ptHtmqvwYFSI82iHsw6hA9qArd58dlBOIZoJ59+zaGtjihn9FExIu1Jy0Ia815g0SqJDIz1hnGzdBI1lBsu3Zp6Q2av6bu3Eni0Xr5iLShmjfHARhhRkRg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, Oct 20, 2026 at 03:07:40PM +0000, 'Marco Elver' via kernel-team wrote:
> On Tue, Sep 08, 2026 at 02:13PM +0100, Caleb Kan wrote:
> > Hi,
> > 
> > This series reduces the memory used by persistent stack depot records by
> > sharing common frame prefixes in a path-compressed trie.
> > 
> > Cloudflare runs KASAN on pre-production servers so allocation and free
> > stack traces are available when diagnosing memory-safety bugs. On some of
> > these servers, stack depot exhausted its pool budget even after we raised
> > stack_depot_max_pools from 8,192 to 32,768. Once the depot is full, a new
> > persistent trace returns no handle and a later KASAN report can lose the
> > history needed to explain the bug.
> > 
> > With 4 KiB pages, 32,768 order-2 pools allow 512 MiB of stack storage.
> > Doubling the limit again would allow 1 GiB, but it would not change the
> > linear growth: the hash backend shares identical complete traces, while
> > two traces that differ by one frame are still stored independently.
> > 
> > The trie is opt-in and disabled by default.
> 
> Have you measured how much of the memory reduction comes simply from
> storing 32-bit compressed frames (patch 9) directly inside the existing
> hash-backed struct stack_record? That alone cuts frame storage by
> ~40-45% across *all* callers (including page_owner and KASAN aux stacks)
> with O(1) lookups and none of the trie/bitmap/RCU complexity. If prefix
> sharing is still needed on top of that, deduplicating fixed-size (e.g.
> 4- or 8-frame) immutable segments from caller to callee in the existing
> hash table (chained via parent_handle) would avoid mutable child arrays,
> RCU retirement, and the bitmap allocator entirely.

No, I don't think we've done that. But I will run the numbers and
report back.

Thanks,
Matt

