Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 46447CAC5A5
	for <linux-mm@archiver.kernel.org>; Tue, 23 Sep 2025 21:59:39 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8ACE08E0002; Tue, 23 Sep 2025 17:59:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 884088E0001; Tue, 23 Sep 2025 17:59:38 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7C0CC8E0002; Tue, 23 Sep 2025 17:59:38 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6B6178E0001
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 17:59:38 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id EF7B5BA56D
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:59:37 +0000 (UTC)
X-FDA: 83921882394.02.B7FBCF9
Received: from mail-qt1-f180.google.com (mail-qt1-f180.google.com [209.85.160.180])
	by imf17.hostedemail.com (Postfix) with ESMTP id B8DAA40009
	for <linux-mm@kvack.org>; Tue, 23 Sep 2025 21:59:35 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=SJ8ESjSq;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1758664776; a=rsa-sha256;
	cv=none;
	b=XqH6MFshLaHN/6OC5uj7eiBSVBsDddoxGUS3RwnovsH4s9IFNbHTfNEBpC+zC+ZuM/6+Bk
	XwPKFmn34JcO6a00SknwIN2699pkqG6BDaraqpU9DUTKllUuLakA6fwZX8/kJblJLOqnRZ
	b2h9KMfi3kH52RAz4D0mjABeVnPs7Vc=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=cmpxchg-org.20230601.gappssmtp.com header.s=20230601 header.b=SJ8ESjSq;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf17.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.180 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1758664776;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=BX3qHs7drl3tKastKD1b5d2t8SLGFfBbCJAz2/e6rWo=;
	b=7yyQjuEoDdBXqP15aO/B56bG1MYkjzG/p/Y+Kp5dhjtogWJ//aXK63VGHvwynDHWKJ9eH+
	Q6FD+EgoOK78s2cWZepxxHw5LWJ+4bLi0uMYJwbXhbvd1UODvqZ486FxHp5qRQICAqOKhC
	TZ2QpBJ57p9ULb3XD/fqVqTMjCHOUmU=
Received: by mail-qt1-f180.google.com with SMTP id d75a77b69052e-4b61161dd37so39875321cf.3
        for <linux-mm@kvack.org>; Tue, 23 Sep 2025 14:59:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20230601.gappssmtp.com; s=20230601; t=1758664774; x=1759269574; darn=kvack.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=BX3qHs7drl3tKastKD1b5d2t8SLGFfBbCJAz2/e6rWo=;
        b=SJ8ESjSqHpA7vtu8bmqUrc0iDw+va4+XPddHPasPZZF+QnAydPae9uw7xz+flFcuDV
         L9sKRp1udnaOGPUOV1qpRJjwHSICfS3SwgwhRz70aeFGMLVgWSM6V5aFs1TLoaaBDmF+
         fBXhAEOtoBDfMY8hrHXWJ3OsQzLtHsNzED6v9eEiO1rxSbvr27tDfCwAgHmBNYCMNjp7
         FYEPuHKuDhVyKV3T5UIw9Jekk5Up9gktXxaW43O57LHUzLBgtCPvcWRBDwY/1ILBLJzH
         ORQgXF9rTE0n4emgL9JtMk0D6D0tGHNAheSh3ZjCRfe4ODJ57TYgVQ3Paxj0LzdzRlub
         FeiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758664774; x=1759269574;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BX3qHs7drl3tKastKD1b5d2t8SLGFfBbCJAz2/e6rWo=;
        b=F5drExxsnlWphocsxr6rZor8lw+K52mOc7UJkf+Cd73ZcfS3+b2Z5RUI2KkQhhSV6t
         EnmUkYsamzIK0RYaYDmISTTqCccJqDhvIsBQ9uX+ZsySEm44JMaicns3dvK0wPkssSoo
         4dE3cxCLsnyeNBmM1EgbaeqWoxQhiABzK4W2QZjpQVF5I4an4W+Qv71Q3cAQ5zZko8YT
         jeawz5Rn/68rBR0M5Nffo5cddmC7JlCzDHA8PglVJJOJIutb74RVhgtaaY1jXreaipK6
         VIV1KngZmCGe+WGAe0THz8z68yxlNFNzBgqFJQ4zOYZ3UxoeYO1gHxAAkyiV+0G2wd7+
         UjaQ==
X-Forwarded-Encrypted: i=1; AJvYcCX/I0Uo6eFlugd9fJdJr1MKH0kaaJ3XDoKIL/R3ZlWqfnj0kDm5ejqGk0yo8k0VP/KQupnqYUZg6g==@kvack.org
X-Gm-Message-State: AOJu0YwVVdjwIFozgTA6KFXLX7B4IFB0y9PqUsY3r2hETSGV5fRFpP0N
	xeNKJr/WycCK3AM6rB46weDv3/LskwAJt8gsqs1sLsxQ4u20atPhaWccrhPxLaU3Ytc=
X-Gm-Gg: ASbGncvSLxkHbeeft5bgX6j4/p97mT4G1ADPc+e7tWmxcNo30bYR0TVkHs3AWjriubW
	tlw026S8pbexYeNH+818e9FBA0RqWjAV2IRwDCiQY/RoIOM6cEfYmy8dqPWOvp6RTfY6wx/26xe
	QfDuevk17OTThqXDZXLFppkB/DXQe6FyPPfhBAe3Ng+XcL6poNcfV51kXqOdsERW1hmyThdPmYk
	1el8DZ1sgPmhRG36BfYJATj4/KLfKiVQeii2SN8bkORjQzOnG2ou1e0JF1Cfcdf56hu/OmJ3k1T
	NGYjCxO+hj6aFaOgbV5mrPt690rjK477VcPZbwPj4KA2qlS38M/J3o7CA5egERteNfEdThfPOy8
	lFwOl/BAGtl2wYgdAgoLA1GFrIYRCfVNE
X-Google-Smtp-Source: AGHT+IGJK4Ixs84ITmfl21mhtnUIvulA36FWyfmqNajQjBuONg+Bop3F7SJyTIF2oLRK+xYnNqb3Tw==
X-Received: by 2002:a05:622a:a15:b0:4ca:e5df:f266 with SMTP id d75a77b69052e-4d369510c3fmr47797661cf.37.1758664774448;
        Tue, 23 Sep 2025 14:59:34 -0700 (PDT)
Received: from localhost ([2603:7000:c01:2716:929a:4aff:fe16:c778])
        by smtp.gmail.com with UTF8SMTPSA id d75a77b69052e-4bda2c6d0c5sm93805981cf.21.2025.09.23.14.59.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Sep 2025 14:59:33 -0700 (PDT)
Date: Tue, 23 Sep 2025 17:59:29 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: syzbot ci <syzbot+cica6a1c285444b25f@syzkaller.appspotmail.com>
Cc: a.hindborg@kernel.org, akpm@linux-foundation.org, alex.gaynor@gmail.com,
	aliceryhl@google.com, bjorn3_gh@protonmail.com,
	boqun.feng@gmail.com, chengming.zhou@linux.dev, dakr@kernel.org,
	david@redhat.com, gary@garyguo.net, gregkh@linuxfoundation.org,
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, lossin@kernel.org,
	mhocko@suse.com, minchan@kernel.org, nphamcs@gmail.com,
	ojeda@kernel.org, rppt@kernel.org, rust-for-linux@vger.kernel.org,
	senozhatsky@chromium.org, surenb@google.com, tmgross@umich.edu,
	vbabka@suse.cz, vitaly.wool@konsulko.se, yosry.ahmed@linux.dev,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: rust: zpool: add API for C and Rust
Message-ID: <20250923215929.GA1122379@cmpxchg.org>
References: <20250923102547.2545992-1-vitaly.wool@konsulko.se>
 <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <68d2cfc2.a70a0220.4f78.000a.GAE@google.com>
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B8DAA40009
X-Stat-Signature: 7sfcwpry655myuimse5toedpqi6mqyyu
X-Rspam-User: 
X-HE-Tag: 1758664775-362458
X-HE-Meta: U2FsdGVkX18TRh02GhbKOssKe910JU/H6wBoEpLLC0JSDUtryzl38tpNMGmr6ssDq7rVNzYFI6P/gm6EzwNIWrmVb2a2tKot3CdiCILVo6qD9mEgBAYVupyXYdKU1DPzhCsNaQqXRs1oe7W9q9mgjSzV998I/dR+a3wTG33nSZoAvFtfFLJSS1XUoD6bufUEoKYADx/dppbl2fDzeuyhw2bMa3c8+DmWwn8alHRN4Xz1h7nz635uJwsU2V+O4vTW2CCU4TZkK00PDXCerGqegWpyUpAZukR29hvD1k+zqHJnfoJ0b2vjO5BaC6pypcIn5k0U/30i+KFYhsOJYazVVVXz3LnNcEDcAyxdqIokVeCJHwC8n6VBdX+13w0Cv75epa89e4eqtqRo/T/2zvDXjn74gWdLWjky0hvyGXtruz0mCsj2Sa9FRXPtYYDgRsVUHm8N1b549SXR21YIaeClq0vRf+yHfj+pX+4HAOHC3Y9t2FUXb+pxPf26JGP6L00rY9TTXA1EktnoinAP/VRhEaacMFMVTxkTbTxmQMiObgTbLGLFIVTnElPmOSRNsbNngo44L/NTslBYGjveZk4YF4gRT5ZugYDxOAayVhQL/7cLUpqZQcjf8hzXwCYa1fb7C3ROOa8p/M7Wyf5uzU/BHhFC6VefUbyDUKHTbj4G/CBOWC3b+yH4oPAvKa7e+vJVO57/koE8/hVT58zc3JbgbwW3ffvH4vXX8NHwvOIAfkTbbSRsMKvTxRPsUE30xXoaQiGaTG/A4ZVPJmxGeMOir9Zd2U3fqoapI6zeqJR8oH9Gz7VrlPXG2Z2QvoSAgQoFRW+3qCtbn+mwKDLqZg9iNo+uc0k/e0HQrFUVSeYphHwDhPjh9Sim6vLKkjAsb310OEIJhkZzyrQvcIsMAhgyHG7zCfPn9LU9Byr/1zrLcXK6mJ4qAcTE4KOVroV3NAGbhLo18Y33NQXRXZEjzNH
 01ayxFu8
 fBgyYuX9lWHjLFdyI8H60t69FatIBZjqOJuOw2IHYZlEwAb3UjX/myxdC1vx6fekL4jElUb5JbBOGuA43Ri8yhJ6Niwot6+k0EOnNBuuj3RGrhzyYRZnL/nXFcs96gfhNjlWQa6e23S0pTgtwgC8MZOPYgmQY1MvPp9+SkKELJOsBnMaxJOOCcoIHzPDi5XGiehIRc+a0x5m3/EuXTlYkOH3J7RNaEL9Jzu2ap0Vv0n5c9T/VAdNC/EIDXJEcPEHnyYjysMX2a4veKHXwBjZ4MIwByQt4RNqAxFydGg1P/HL16hjhEDv/R/l1bIPMYdjQTtKTaCrc7MtXC6fGcvvtxX2O3NCczZHS0DKsU38ZW1Jsu51+74duyBPLMvuUZL5nie4aTzU2KHGOelLsQ/7DzUhhBI2Bz0ssLQ+9oMtkU1o69vIz7xmU1Piwq3zj5TO7gr9vCnGknq4Nkm4TrsPiPimzJQ5u5vI8KlClg/+oTGbmw8fshrEBYc6Lg8gsmrPOTjPfpYVnU30fRrAXajLA4Fliz+BmF1ZlXaIFFqmS94VRMPmmPJytjAglIsCNJvIrVsGEso1GbgrluT+10e5GxuQKBarr3GHSczrI50tpOP2ZKaBgaxAf/pIll5S4J/tQx3+kxcPg1sN9aSwQXzT8M67qpUsnZs/T7HwydBL6kKPwvf4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 23, 2025 at 09:50:10AM -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v6] rust: zpool: add API for C and Rust
> https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsulko.se
> * [PATCH v6 1/2] mm: reinstate zpool as a thin API
> * [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers
> 
> and found the following issues:
> * BUG: unable to handle kernel NULL pointer dereference in zswap_store
> * KASAN: slab-out-of-bounds Read in zpool_get_total_pages
> * KASAN: slab-out-of-bounds Read in zswap_store
> * KASAN: slab-use-after-free Read in zpool_get_total_pages
> * KASAN: use-after-free Read in zpool_get_total_pages
> 
> Full report is available here:
> https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64
> 
> ***
> 
> BUG: unable to handle kernel NULL pointer dereference in zswap_store

struct zpool {
	void *pool;
};

struct zpool *zpool_create_pool(const char *name) \
{ \
	return (struct zpool *) prefix ## _create_pool(name); \
} \

u64 zpool_get_total_pages(struct zpool *zpool) \
{ \
	return prefix ## _get_total_pages(zpool->pool); \
}

You create the zpool by simply casting the backend pool, but then you
deref it twice as if it were an actual container for the backend pool.

I'm guessing you didn't test this even superficially?

This also still proposes an API with no in-kernel user.

NAK

