Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8D520CA6007
	for <linux-mm@archiver.kernel.org>; Thu,  8 Oct 2026 10:41:03 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 704ED6B0092; Thu,  8 Oct 2026 06:41:02 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6DC9E6B0093; Thu,  8 Oct 2026 06:41:02 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5F2106B0095; Thu,  8 Oct 2026 06:41:02 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 379646B0092
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 06:41:02 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 1FFAEA0216
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:41:01 +0000 (UTC)
X-FDA: 85299116322.22.DF0D165
Received: from mail-pj1-f43.google.com (mail-pj1-f43.google.com [209.85.216.43])
	by imf16.hostedemail.com (Postfix) with ESMTP id 4DAF1180009
	for <linux-mm@kvack.org>; Thu,  8 Oct 2026 10:40:59 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VU6/Wg9i";
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791456059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=iOVAVdLWRpL18PaqCaCiNVQOBrQ2EgqTC57TyqXjPGs=;
	b=0DmgOY/ukFCUG5NuiBvXCtHrKdllPyaym9QCHATWaT1XJMbdTyXQlM49/72YLGIt18t6Fe
	UMMIxJ8fWOZC7kNZiidCRqfX9huuTemtVYPxkrvfxpSvcsQcOyL/HCt8ftpdas6xcJ+yPm
	bsSbawGrpvixBECvIT5YBBBpXPFDWic=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791456059;
	b=c+5QI1YPtwqEXa3Im8LKzexaF0ikxNQ0MLf0FezhP+8Dtn48WBa0gdr3RaOsKqIyLjqWR+
	Aa90Q0ynbKL8j3L0C9l9aGBzkA+shPDgw6u2rblkBGcK5A+IoCPaMzS3eBQsKnXuTXqjIF
	f+6IbhRi4uY3MQAyXatrBcXLJEydkjA=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b="VU6/Wg9i";
	spf=pass (imf16.hostedemail.com: domain of aethernet65535@gmail.com designates 209.85.216.43 as permitted sender) smtp.mailfrom=aethernet65535@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pj1-f43.google.com with SMTP id 98e67ed59e1d1-38d489b6b71so1368949a91.0
        for <linux-mm@kvack.org>; Thu, 08 Oct 2026 03:40:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791456058; x=1792060858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=iOVAVdLWRpL18PaqCaCiNVQOBrQ2EgqTC57TyqXjPGs=;
        b=VU6/Wg9i0YGmF6CiUrc4jMdzQU/MFgS+Qm/2wKNQgC53fWxv7Df5ZDERydVllvZrK0
         bzyznzwpeqhZQcMe23kV2q+CQ7r3c8xDVV+F6thTdDNDcrLXCLTLXx1HVJ8O7jfOYXhr
         4A8+dveSTTO3KhBwd+mA0kvULjpT9azhA/GUyjjJ3zFpdAbqP420/zoETDsYnBWb7lsc
         sZPttQbZlrcHKyNmoOToKsi9u8Xvl1O7R6m0jhyWrSskBWcDNeEE5aSKBnRz5it0UeGc
         IWFjxSxwgHQilIB/E8v9tzEwyTCqQgQfgzwix8UhC4X5pRef5y22/wnYQ2hhepwhhYMG
         zrjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791456058; x=1792060858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=iOVAVdLWRpL18PaqCaCiNVQOBrQ2EgqTC57TyqXjPGs=;
        b=KxVSF7mPQWXPk/o6pS3ojv+R3GeHJ2qQFsynHZisxIyywLYXtejyxQXdyk55ygGPED
         +qsO1pEGbKmc6JBowL56wBky2SMnQIDC9FjwuthRh5936d/20A+p+pvca9/0q9/H999J
         jpi8OUyp2uUNv5WZnphc4g6I/7duh7t4XFbUwUG8ZDB4APcQv631XKfps86Bdf+XakZP
         gmy/OJa+RO/CRjc1kE9/kGUeaLTpL15ZrmcgpwJDf6eZ1a7e5XaIiGI68ljrtm+Or/RO
         qZP/+UUo4YT6nhhnHN8RckeA6DasVuQPdwe/XoikjRqFAiQ24Zp8sYVfRVDzyjUY1tgh
         kKyw==
X-Forwarded-Encrypted: i=1; AKwUvByrDNL8rTlx7HgLOlm3L10eb3J2VvdB6bGYnnVBJuPgWKwECkLf9tJ3Q/FSozOCJBFaVtQ6TXwCYg==@kvack.org
X-Gm-Message-State: AFq9FYIQmpwjQIh9ghVg2ztJpfe0thuwjUeu5rHqcEOk0/TeIfO+JC6i
	nyZiP7Mo1zvil+1pUu+xvR/dV1eoS7h9r29XzPccmG6jQ1xo1/rTqgzH
X-Gm-Gg: AYBFou1oe+6Fy7S5wdUx6VPrt42YdEuq1OTERLbip1lduKTT8y0GUiyVmPuip1TvzKW
	xFIQgH906l4qtkmchC7E/cj9XERcBTMuuIBdxLWMhwOch+h54EtzlTSoyzMC7U1DwItF0/YiomR
	kQ2brwN7LaUmsY+ZL5QWvM55tGNBlvWDqQBxRRnj04dm1UpkR0akFopH2a6sheB42brDmkpwjAB
	i0esayuo8DGWp7kJ/PWOJf8RTJbGk2hNBMyYSFtjZhlMS0vQ1OxuME0r6TCMdbdTkqlyLK28opj
	/P98PXMiPi86DW0m4hzRbesZWXWHU3GmZ1jXa7VdlSB9rToB5ULPsrTQvrUqh727XhCC/GbWuA9
	qhDAIC/PG5c3rtKIhVTwAz9XJCWQeXPz/QTkplOBwDaLUz6KrXwTJu4AqQ/op8jY0PPR728o//u
	6WsVHuj+qJcSez2rnSowR28n2AYpwafkh6lto76OT1tKhj/tqIM7Bu5mnUo+eZ/41O1+LvbEMll
	Lo1A7abBbx/A72XIW9gSWGfog==
X-Received: by 2002:a17:90b:5887:b0:3a4:fe48:d418 with SMTP id 98e67ed59e1d1-3a8a0851582mr4004998a91.19.1791456057998;
        Thu, 08 Oct 2026 03:40:57 -0700 (PDT)
Received: from celestia.taila51cc2.ts.net ([2001:d08:1334:29ed:db11:2c4c:ee4f:606])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3a9f1a51bf3sm3831271a91.1.2026.10.08.03.40.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2026 03:40:57 -0700 (PDT)
From: Liew Rui Yan <aethernet65535@gmail.com>
To: suhaas@s-joshi.in
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	SJ Park <sj@kernel.org>,
	Liew Rui Yan <aethernet65535@gmail.com>
Subject: [PATCH 1/2] mm/damon/core: Use only installed probe in damon_merge_two_regions()
Date: Thu,  8 Oct 2026 18:40:29 +0800
Message-ID: <20261008104112.4763-1-aethernet65535@gmail.com>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261007154851.45368-2-suhaas@s-joshi.in>
References: <20261007154851.45368-2-suhaas@s-joshi.in>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 4DAF1180009
X-Rspam-User: 
X-Stat-Signature: 9arr5u7cfuaconnwpys4k7aeq5neh44f
X-HE-Tag: 1791456059-351680
X-HE-Meta: U2FsdGVkX1+4bfp80i4feMLhp50tq9C05Hkmphj6e/Swt0LYjB6NuXcpRywr8k74drWMFcNub6+xY6FjVI/uSZEr3lfTfdZP7fyxoG22XJjm3+nq6OwLg4DkKlM7EnaVhX1GT/RgsbkottNUGXiApQbJnncssrOa+2a3Ya8en4vr24T/IIxy9WMSNU1KIH4AqSbVrKKpAcZz95VeJIG/sj0pK6TF2U/HLoNNdxiRfDm+Mb10HSFsRi2anOlxWzttL3CXt4LJEzAb7EgHvfYrx0cbSaZ1eG2ziiwtqxG3ZM+5PdhKT2ARYlzYsdPG58FTF+pFONG7llKaj7uMdXLVQjv6mZEvJ+2c5abAJ3tFw6jCGg27AWbOyQjhZzZKMquuIFgCwMAuxHN+ubujcnMR777Td5g9s0Jcjgv7iYaJWFHkfV1t4exfa5htwBVgzmlxsaXK1XDmzjkW8nwd2HjdezpDVznkZhsbYPfKioklwbeclIqDGqSDtvogb7+j4ip9YUtnvbN4J6Omru0KqVa0JBxNeLfKyWtu4WU5zFLoD49IhWRPkaKPGovILjqVf60sZOCYwhpEelDelGaInlYBb7E3L5HW8wvyi9Jhz1/KM4w0IIDuIhdqrpN2awrMCKZ0yO8oKtsEKN7CZ8X88OwX9HIgQqVmYUaSTktltcHzzs5waZ4I+C9a9L1IBuGmUp+RW9SmoAobvxl8PcudRu6RpJIr9Pn8V42ixCwDuzdwFa2cZPrIafyR2JoIpCwTtO4Wujqwt2QhYI2kttQooVjYls95s/MFoH960+jWlLtpgmI0Uol1PA6/D3ayCjisuUyTgu0/dfsOOhWnrgKMFqP/oawEbMQGrUQUKP/LPjXsvkh6QIsMvHdy48FlqJ6+k4Fd4yP7NcCkWpnoBCeFG4tcJaUT8f9HWn62NgMPncmQqNTMA1e7ET4U1RHM9eXq5qGkN+Dj8U+5VhGYHdKfW+/
 pfOO1ctO
 7qD4EPd4Zz0Jnuhy79GZTFgN3imC6cz0oV4K32ytIbh5DGdcnEuybyIavU6yB0pRGq2+7vG/MUNIQ9eFzMo4vlCEQda4fec2t0t/rMMNCjNUVVu7lLRY6FpUHwNfpd9DSCe0OI+Te0Y93crudiwJisc2IOQsqnXBXmuH9h/pVAY0zbXiZDTkSwwfxbqd1nu3mwDSC25Pl0BJDq0ZpB4YMPkYaNxkzMe7DqsnaNISTNpT1LBpzhOReXethbMqQqlq1Pz60anbMRTkifOEC3m1tlExeYhkUqA4XGcCU+xI6MCOL2oyQJtVA8O2ZI/MOrU5PlTXpw17t9k/nV4mpOkounwX/vzCK1SPpX37QKwqvrX6xPesW9s/+24KvCmxCdmc8rExlZP4ZGYsiYXaIVTs211RJUGHfX2UieNOBbIQtyAQ+ldM9gTIB7WhhzdAxXhQEPTHtLPYpEcTVAXRk9Syxu9GOhY5ry/1o9GuvQ44mpmcMsmkBO16nWp+jXl8vc9ZWGB4NCLN551PcM8axsaIkBBeXX63U+Hn1gamV
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Suhaas,

Thank you for your patches series!

On Wed, 07 Oct 2026 21:18:45 +0530 Suhaas Joshi <suhaas@s-joshi.in> wrote:

> While merging 2 regions, we iterate over the entire probe_hits[] array,
> whose size is determined by the DAMON_MAX_PROBES macro. It is possible,
> however, that we have fewer probes installed than DAMON_MAX_PROBES. In such

I find this a bit hard to read.  Could we change it to this?

    "However, it is possible that we have fewer probes installed than
    DAMON_MAX_PROBES."

> cases, we end up making redundant iterations. Therefore, to remedy this,
> iterate over the list of installed probes instead of iterating over the
> entire array. For doing this, start accepting a struct damon_ctx in
> damon_merge_two_regions(), and update calling functions to pass this
> argument.
> 
> Update the damon_test_merge_two() test to use this new signature for
> damon_merge_two_regions() as well.
> 
> Signed-off-by: Suhaas Joshi <suhaas@s-joshi.in>
> ---
>  mm/damon/core.c             | 14 +++++++++-----
>  mm/damon/tests/core-kunit.h | 19 +++++++++++++++++--
>  2 files changed, 26 insertions(+), 7 deletions(-)
> 
> diff --git a/mm/damon/core.c b/mm/damon/core.c
> index 733025b36745..a3af5ee685e1 100644
> --- a/mm/damon/core.c
> +++ b/mm/damon/core.c
> @@ -3499,20 +3499,24 @@ static void damon_verify_merge_two_regions(
>  /*
>   * Merge two adjacent regions into one region
>   */
> -static void damon_merge_two_regions(struct damon_target *t,
> -		struct damon_region *l, struct damon_region *r)
> +static void damon_merge_two_regions(struct damon_ctx *ctx, struct damon_target *t,
> +				    struct damon_region *l, struct damon_region *r)
>  {
>  	unsigned long sz_l = damon_sz_region(l), sz_r = damon_sz_region(r);
>  	int i;
> +	struct damon_probe *p;
>  
>  	l->nr_accesses = (l->nr_accesses * sz_l + r->nr_accesses * sz_r) /
>  			(sz_l + sz_r);
>  	l->age = (l->age * sz_l + r->age * sz_r) / (sz_l + sz_r);
>  	l->ar.end = r->ar.end;
> -	/* todo: do this for only installed probes */
> -	for (i = 0; i < DAMON_MAX_PROBES; i++)
> +
> +	i = 0;
> +	damon_for_each_probe(p, ctx) {
>  		l->probe_hits[i] = (l->probe_hits[i] * sz_l + r->probe_hits[i]
>  				* sz_r) / (sz_l + sz_r);
> +		++i;
> +	}
>  	damon_verify_merge_two_regions(l, r);
>  	damon_destroy_region(r, t);
>  }
> @@ -3565,7 +3569,7 @@ static void damon_merge_regions_of(struct damon_target *t, unsigned int thres,
>  			goto set_prev_continue;
>  		if (damon_sz_region(prev) + damon_sz_region(r) > sz_limit)
>  			goto set_prev_continue;
> -		damon_merge_two_regions(t, prev, r);
> +		damon_merge_two_regions(ctx, t, prev, r);
>  		continue;
>  set_prev_continue:
>  		prev = r;
> diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
> index df84d9cc7d20..5ad89c1d9fc2 100644
> --- a/mm/damon/tests/core-kunit.h
> +++ b/mm/damon/tests/core-kunit.h
> @@ -182,13 +182,27 @@ static void damon_test_merge_two(struct kunit *test)
>  {
>  	struct damon_target *t;
>  	struct damon_region *r, *r2, *r3;
> +	struct damon_probe *p;
> +	struct damon_ctx *ctx;
>  	int i;
>  
> +	p = damon_new_probe();
> +	if (!p)
> +		kunit_skip(test, "probe alloc fail");
> +	ctx = damon_new_ctx();
> +	if (!ctx) {
> +		damon_destroy_probe(p);
> +		kunit_skip(test, "context alloc fail");
> +	}
> +	damon_add_probe(ctx, p);
>  	t = damon_new_target();
> -	if (!t)
> +	if (!t) {
> +		damon_destroy_ctx(ctx);
>  		kunit_skip(test, "target alloc fail");
> +	}
>  	r = damon_new_region(0, 100);
>  	if (!r) {
> +		damon_destroy_ctx(ctx);
>  		damon_free_target(t);
>  		kunit_skip(test, "region alloc fail");
>  	}
> @@ -206,7 +220,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	r2->age = 21;
>  	damon_add_region(r2, t);
>  
> -	damon_merge_two_regions(t, r, r2);
> +	damon_merge_two_regions(ctx, t, r, r2);
>  	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
>  	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
>  	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
> @@ -220,6 +234,7 @@ static void damon_test_merge_two(struct kunit *test)
>  	}
>  	KUNIT_EXPECT_EQ(test, i, 1);
>  
> +	damon_destroy_ctx(ctx);
>  	damon_free_target(t);
>  }
>  
> -- 
> 2.55.0

Other than the commit message I just mentioned, and the issue reported
[1] by Sashiko, LGTM.

Reviewed-by: Liew Rui Yan <aethernet65535@gmail.com>

[1] https://lore.kernel.org/damon/sashiko-outbox-163177@kernel.org

Best regards,
Rui Yan

