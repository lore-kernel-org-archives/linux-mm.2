Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D3DA660AC6D1
	for <linux-mm@archiver.kernel.org>; Mon,  2 Nov 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=spzEwKjZ
Received: by kanga.kvack.org (Postfix)
	id E04F76B0610; Mon,  2 Nov 2026 10:55:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB5716B0611; Mon,  2 Nov 2026 10:55:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C7CDD6B0612; Mon,  2 Nov 2026 10:55:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 9A1756B0610
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 10:55:00 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3A89B160174
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:55:00 +0000 (UTC)
X-FDA: 85390627560.06.D8A0B4C
Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	by imf29.hostedemail.com (Postfix) with ESMTP id 4573912000A
	for <linux-mm@kvack.org>; Mon,  2 Nov 2026 15:54:58 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=spzEwKjZ;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793634898;
	b=fNfl2050/nPA83OJhLVpAXQjIx2ru9mr0Ym8+AiKtQ138tqrbb3TuzDa7+XdmQ9Kw7NffT
	YRPwNrljdYcAuNsc9EiKuXTZ9yvhGGJmLfRenjLS/tzYyRSEtjUkMdXYKT2+jMrxwL9GRe
	DpCFs8bfgDWSaajrF4/OUj+dlEHtbvo=
ARC-Authentication-Results: i=2;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=spzEwKjZ;
	spf=pass (imf29.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.128.49 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793634898;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=28knMo2Wj7+Tn329XmbrSNL2GjeVASRAZu/1W0UCdF0=;
	b=W7I4VMatmRghD9ZKkmFkmA7t+O9jIZTBvgNkdq11uMll+BJThuzLJ90banmIB+yH1/yN1+
	CQWZHRRBACFz0UVuWqoSO8MZNr69F9mOkpi7KRtQ3FWVivUHDOEsh1pcL2vEdz9ubXzbCm
	ilg2ltKJkxwFz8fieH0RMPOkY4R+yoo=
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4a214af2076so24394715e9.0
        for <linux-mm@kvack.org>; Mon, 02 Nov 2026 07:54:58 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1793634897; cv=none;
        d=google.com; s=arc-20260327;
        b=shRHpvqzzIWP3hDkCHb9mZEwWW9SujTYWDeVYl09OQiPonU00bZyUZ1PrOTFeCBcF3
         xxR+1qx+kEiwYBZN8lYNcLey/g6/6VdLscQLPEhYahdkU3XImitKa18EzZR4sVjU6GKC
         SVCeVJcnJ5CE14swK7FApPxrkbxD70wJ1KbU/5IN1gSdMheM1CoHLVV2boFvnF6tJRnN
         shI+mWO0h5vu6CY2KWvFMsIyMW2WpXFv8YA4FBVAOF2oXbxl6Z8M1CZwOT2cWdUrTCAr
         IrJ23r5cccz2oWpWKtxem85zuBW5+aag0+D04xIVUC7Sn16g6RPDxZpLLOV6ZihOOS4K
         D2Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=28knMo2Wj7+Tn329XmbrSNL2GjeVASRAZu/1W0UCdF0=;
        fh=losp2V8wNF/zTt2R+GeTv2Y5Gkz9YPsXslexnqy3F90=;
        b=K6rqm8JOtJt3ceLXCMJWXGR9lGYrCEmND7zGBvGoIkU/1jWnHgNiH4IJz969d+tYZe
         AxX1JSjgha3ZxS9WzmNbbSL6XaWoqsk6TpeSWBoHFk1YgzIaDy9fd+4FxFhjFLmGIoTu
         hQ1lfmtNdhv+j/MV2Ha4bCcwxscF/a2IbBDC48NIbfXTd9PM0HXExpRbkEbsqiZm8+QE
         m1JmFnLwPvtuTNw4qoeQ1EUeTBlhfqWs4A9jiCzCSgOn9IXFDv5TMY06upBanmqNKhpq
         LZQ2c1QAqU09eXFggOpgZP10NLmlEDtdh0ZXqSKzKOHDjTFlOs62HKGG6tW/dGpA38Wa
         M2OQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793634897; x=1794239697; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=28knMo2Wj7+Tn329XmbrSNL2GjeVASRAZu/1W0UCdF0=;
        b=spzEwKjZTirHgPfItxYln917dSTHs74djlOnKEbIOsllQz7iPIy0U/Q6uCkCJ5j30H
         omHA/KYyauzkR6J/OIR2RJV9Tsn9CkbOULYBTtonwv8e1JRPzKFQcO+PRZHaAF6Dj570
         L3a5qSdtEg1UwTIoC5nOiOKoz6R1ffNFO6JqrEvu9wAH85+EOFdsh5hHMrcAoZBVJq4a
         0DcCrsgdFdLAvkWpA7FlP4p5aIThlq5RdlNDaOCRIR9/ZJlsZohop/3EUBww0fonD1qD
         wVoJ69IBniWXFTlXmoAabgCSq+ZS+MxuDzB0Se1kOGqhU7HZQ3Wz+GH7Xw+Vy+dF18nK
         LQ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793634897; x=1794239697;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=28knMo2Wj7+Tn329XmbrSNL2GjeVASRAZu/1W0UCdF0=;
        b=o35x71dfeKzsgjdj59istjSifn7BvcrOeLWPrgj1mz+qbjGmRTV5HLJpoBEKcnep2x
         IiZcHDe/m2epTEm+2YwSwsgdEz74/jaKbY/znagpuAgFiXWylzU+j0qo6SFhrvZQshIz
         DySffM/jerjcSmYbfoxKMx6VSef5jux063ojEzIl1gHpdc3aYCAH/x8pOc3W/G5qZXB1
         eXe7xsdqS0hNDkvxxaUvek3pUaLrh89mo2AOor0SbjwJfP6dOf1gH0rikmAlqi4GdzkL
         /UtMtOGXR940dJqvwEvzjzFpbx9rED2oHokHSUjU/yeYglEFRgjpCqv1dvu1vyVYLZ4R
         3e4Q==
X-Forwarded-Encrypted: i=1; AKwUvByFhuGNuA+j2jeuL3qSf1ni/oYtNRUzyUKVmq68MJTpkOftu19VxM9+kyAnCHMKaFnlmWXpIdYlIg==@kvack.org
X-Gm-Message-State: AFq9FYLqW8ZL9u4lX01Ovqd0bWzaS0x1c7eiDNempuWYb6OL3LrsDiK+
	CQZLNcpbyoV/Bm/BNayzWnZhT8qbY43x261XqB/mBJBrDciz+gbZaqIXd7qC5sNRPbbFuQ0vCK7
	d+ggaa9MJ5rLp7IAqTvfj95BkRQY2zpE=
X-Gm-Gg: AYBFou1/2l/5jb+k3duDwnaZIkQ7MoBcuZWAuQauzbmvvPtrShykxUnTRLg4qFwX6f3
	vTRpsNWeRdnPGwWMJjEZ8RZl1cX2kLQQ+DmbWVSQbkE/4GcGupbmYg3x8Sr9NHGwvTH985mJvzq
	Zu1KNDN+QbP5WXXjDMloyJzjI8NwOrRsNhET3LJ7qkNamm25OU0xUnwajk0u3QFlXarkgzk5jtQ
	UI1O7pT6JDthbUL0LsbVCGGE8W3TE+n7b0QzVbRZWWtKJ31LmF1WvoNDbKhixHo76StRFcxTJd5
	iOtyrXXwT1p5uazCuLbaMVd/NM6c4PL1S6c7nmrrppEzMhxSGzSD6FIOmfgZ6mcz2s9O+2jgHOp
	FYM5mufPTJ42/QU6hSmA7WMJVH2CUBwer9Zhm3JQlT+44Nu71/TblyUSTurOopnlzh6meaKPtnY
	W26NTLwyqm+KrenCckH7mGflQeeI8yeb42QuJRUMcFo9A9aK76cc+5
X-Received: by 2002:a05:600c:628d:b0:4a2:1a:a128 with SMTP id
 5b1f17b1804b1-4ac17d19b68mr233026445e9.19.1793634896692; Mon, 02 Nov 2026
 07:54:56 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261102144835.304017-1-alex@ghiti.fr>
In-Reply-To: <20261102144835.304017-1-alex@ghiti.fr>
From: Nhat Pham <nphamcs@gmail.com>
Date: Mon, 2 Nov 2026 08:54:44 -0700
X-Gm-Features: AclHuK9VGAGEYt8i3X82mNf0XeGwG-aeAsfLvH9z2F83pQYMolBUNoambfzcprU
Message-ID: <CAKEwX=PQ4_AuOJR3gVMLkUBC4qe+sc5dUEkhXCA4QFn-BSZS7w@mail.gmail.com>
Subject: Re: [PATCH v4] mm: bypass swap readahead for zswap
To: Alexandre Ghiti <alex@ghiti.fr>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, yosry@kernel.org, 
	shikemeng@huaweicloud.com, baoquan.he@linux.dev, youngjun.park@lge.com, 
	chengming.zhou@linux.dev, david@kernel.org, ljs@kernel.org, 
	liam@infradead.org, vbabka@kernel.org, rppt@kernel.org, surenb@google.com, 
	mhocko@suse.com, kasong@tencent.com, ryncsn@gmail.com, chrisl@kernel.org, 
	baohua@kernel.org, usama.arif@linux.dev, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: 4573912000A
X-Stat-Signature: zm54b51x7mk8kucsk5cs9r9mkmud5ter
X-Rspamd-Server: rspam01
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1793634898-264877
X-HE-Meta: U2FsdGVkX1/lPS4WB81QqcxjBYS9istJBJpNdsmEVwFjsJqiCpx4ag46xNvz/7TilvFYnaURLNNrrsP0TaR+EagdC/4ocbb6jXANgfn5OosRe2/pp/1j3TsrtH02vkqsp/YIGskzM+qsHryCn+7JycYI6vYDEDLrspK6gxrdELg8VTkHeK0+naRhYOL6RBV5SQaV5kaHr1ncVVn6h+hk5U0Ef8cr5sL5N4xHOugKCpDXC0vWY/SL074M5QC0Efz/B2UWUUfKUyZ9rl23xBOc0bkIk2wzkGD1EigQ9O2vUV4k2h33l3D3hLQIP/cpWfTmF7wgzqyzjJajxsRHaLEwG1W0Pp/cnFFu7QzGfbIyDxbKt1WP02lvtstmC5W6aGg02Nuwle1DMnKDCDjjwnxflKndsASOimQTtdrg4E+bZ9xK978mBvRifmUiv8WSxE0ZqeWWU5WMI1pL3ChmIE1+fFvfNLh6SGxYnsafI+qgDe3Lu3Z6JFuAW6ybahaMp9g1p0p+iR80+t8WQ3IPlhJIWtX13mMiEdzE4A8hGvIqYWjQW02Pzh9vkudcfLunQHxmn4U+7itzHGPcLKejeNZJ7dV+Vc+xXEACdN1DoEwfYyYFB0VINIzkYwwSwWsJA2KFrmPZUgJut2fiBPTbdAeTE0T8ZemrCHpycNhYruC3QJ8EO8VDExHpgG+CNp/LdwK3ZOXOKgreUDOXRGZXFhZpJ7ZEO39tiRx8KS6tFvCCUwvn5YuzM/PIgTEXY8KMl4UGRDLZ394oK76rgo+rW32LYlF02VxbBEKZQqX5m2Mxpeg9e8UI26GCIUNib3LAaz4LZFEDe3OzD41RGSNlgP9ev5nIVvCCpMUXxUMB0pWoHN/s+24bG5DAMzlCKB6x/pWG1rQqDvZsUUv0uyeI3IosaFWkDaXCXkze6HQo+w0pKPz9KZFkrjGr0vZsYlN4MA0e50lrXXT9xxUTBI6WvSq
 5ZqEX0GG
 wyQKHYRBdZKeHuMrt1HfBe7zBAELYMUR3x7RcpMf1/RxKxouZfKP2VagQ2HgXg3m6ge4joyr4W83PsTscsEw4S4yvDsi31UmYQpf2zs5OkmNi3+GGJdLcOqCYC+TNeLPZGCMIAYOwIX09tqPjB5SsXYrYtHY2ThvqEcEs8mZxtdIdZi3lRA6uZ2u6t0u/WZGmBA6/WQ3oK7M67jFb/945ErVRdj/kgqtqTaL6sJ06tPLg03bGicWs/C0l+Q8cgtamrYXdIbBsUb43EuoNKu3X+uXFHkfnk/FwlHKJ9/9tCGbmUk0QWF3esjzYGNd2jAErZsBmn2A6NeKJN5Fs7n84I4tRx9jeVMGapXZ2S9JvuuNqa6XefuqQxw9hiHJqrCHo/wNHJ4KMLxYSYW0B14LQ47CBlFfHLDEFlLnfww1VNQONTRV7sK2/W6OZfROZ/HI+CKOR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Mon, Nov 2, 2026 at 7:48=E2=80=AFAM Alexandre Ghiti <alex@ghiti.fr> wrot=
e:
>
> Commit 0bcac06f27d7 ("mm, swap: skip swapcache for swapin of synchronous
> device") made SWP_SYNCHRONOUS_IO devices (e.g. zram) skip swap readahead.
>
> zswap is the same kind of in-memory, synchronous backend as zram, not a
> swap device flagged SWP_SYNCHRONOUS_IO so it still goes through
> swapin_readahead().
>
> Here are the results from bypassing readahead for zswap too: it was
> measured with a kernel build (make -j16) in a memcg, zswap=3Dzstd, shrink=
er
> off, on Sapphire Rapids and 3 iterations.
>
>   768M memcg (sustained swap thrash):
>     metric                 mm-new    + bypass    delta
>     build time (s)          405.0       341.7    -15.6%
>     zswap-in (GB)            79.5        53.0     -33%
>     zswap-out (GB)          144.8       115.6     -20%
>     swap readahead (pages)  6.79M       0.45M     -93%
>     swap_ra hit (%)          72.1        89.9     +18pp
>
>   1G memcg (light pressure, build not memory-bound):
>     metric                 mm-new    + bypass    delta
>     build time (s)          177.7       176.0    ~same (no regression)
>     zswap-in (GB)            10.2         7.5     -26%
>     zswap-out (GB)           27.7        25.1      -9%
>     swap readahead (pages)  1.07M       0.08M     -93%
>     swap_ra hit (%)          68.6        87.2     +19pp
>
> Similar gains were observed on an AMD EPYC 7D13 host.
>
> All the results above use the default page-cluster=3D3 and
> vma_ra_enabled=3Dtrue. Setting page-cluster to 0 gives the same gain on a
> zswap-only system, but page-cluster is global: it also disables readahead
> for the asynchronous swap backends that other tenants of the same host
> may use.
>
> The gain is from no longer prefetching pages that are pointless for an
> in-memory backend: readahead inflates anon residency and thrashes the
> page cache (file pages get evicted and re-read), lengthens each fault by
> synchronously (de)compressing a cluster of neighbours, and adds
> compression traffic when those extra pages are reclaimed.
>
> Bypassing swap readahead for zswap therefore makes sense.
>
> Suggested-by: Usama Arif <usama.arif@linux.dev>
> Signed-off-by: Alexandre Ghiti <alex@ghiti.fr>
> Reviewed-by: Barry Song <baohua@kernel.org>
> Acked-by: Yosry Ahmed <yosry@kernel.org>

Acked-by: Nhat Pham <nphamcs@gmail.com>

