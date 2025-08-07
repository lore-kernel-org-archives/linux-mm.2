Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18CB7C87FCA
	for <linux-mm@archiver.kernel.org>; Thu,  7 Aug 2025 23:04:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8C83F6B009A; Thu,  7 Aug 2025 19:04:09 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 871F66B009B; Thu,  7 Aug 2025 19:04:09 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7603A6B009D; Thu,  7 Aug 2025 19:04:09 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5FB126B009A
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 19:04:09 -0400 (EDT)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 0FE9D584EF
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:04:09 +0000 (UTC)
X-FDA: 83751491418.28.B453593
Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	by imf30.hostedemail.com (Postfix) with ESMTP id 1446D8000D
	for <linux-mm@kvack.org>; Thu,  7 Aug 2025 23:04:06 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+Cqcfdh;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754607847; a=rsa-sha256;
	cv=none;
	b=PiOvTYwv8Jti7SaIgr8dIXPVHc3u2mKnSqgdKfWYnqvsa2ig2EOQhhYHwpHC01NFNjIl4b
	CxcvLuuRFPcTPu1weBg70MNbixr3IZ5q1RO1hzfUCGDM8gihXr6FEG4pwvLgGJdhKihZLV
	6povOTPSuz/DHnM4iuWP3Oz8bcGe7CY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=O+Cqcfdh;
	spf=pass (imf30.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.177 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754607847;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MrNipFeLpq6UgP5HYhuOb8lY4sW9AdQWYKf2OVt0juY=;
	b=JjIMAqgPIyMdsID5o5ZJf5fJn9eENhPuKGDuDwCZLw+h9E96ltyZBGfysCPK0XkUcSpW6p
	gwEU6UOtpcouCe7AdnwIaWMUF7FpBtK973jEKEqNLF/ZMYK3ccLjmT2Q8MQyUN7kzlHATF
	/BG7/l4IqfhoCO3y3S09+eIjXSMGs8Y=
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e51dc20af6so15023755ab.0
        for <linux-mm@kvack.org>; Thu, 07 Aug 2025 16:04:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1754607846; x=1755212646; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MrNipFeLpq6UgP5HYhuOb8lY4sW9AdQWYKf2OVt0juY=;
        b=O+CqcfdhsJygscs195uSu92kLK5JwQnCkXFU7b2KTPRGOMQaXss8BOeHbwMQTuAp7x
         mUO7CyMIh5dE1X5ctYjDEWMAuvTN1mEK643l34RcE+mwVbDnPhpfJKcR3VNRLiP3bvZt
         pM8moc2rtEq08PH33hEuYbBTjbgXiJd8acYR6ziawvOdAkmogGTrYj4JCgz3U/WfPQU+
         K9vtHnvyqOiCRWgmKWrwBNNt3Y1u46k80F7+UDlLhtH0KIIAJaAdoWJKbZpKExlbPkDn
         u9ktJhTeA0yMUKvN7dWG068Jr8lXJgItZzitUNMyf/jNRc1bYmScZxo/GsmAE7fVmHt9
         aZkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754607846; x=1755212646;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MrNipFeLpq6UgP5HYhuOb8lY4sW9AdQWYKf2OVt0juY=;
        b=IizTsteM6r8x2Yuh/kt/NAtGB1RiQ+7D5K6yv0vrWKSuU9Fw4ugIIljyYzE79Xtv9H
         N5+N8VCultCuH+X/TChTsRs2fWnf2IzV06bZ7Dip6N/v9YzV01+20fVEKERnLXUSx1+x
         WXQ44mN7Mc4ErDaZYwJYP9DiHQGteW2IRtFlo2KB2XyQbrlVKA8dhmI9CQgfs/EMJXvA
         HjulHt017jWJQkVCekWrCwYoR3u9HVDo34kpvELwGJgxB8du+N8K1qip+e3FeuRixUQh
         K+rQRUdKKzjTmESsy6cO6NHhP1X5MNeWnCsioqw5JzJZ1LjKdwO36vMtiat7FeF6DfDW
         6+9Q==
X-Forwarded-Encrypted: i=1; AJvYcCVT9GPNATrflZbpQZNqG3HMOBf2nejCI2xuZRP5ODjJetJr5xNj+xBla8MjYL3QmnEN81dFl/BRRQ==@kvack.org
X-Gm-Message-State: AOJu0YxaVS66KMPJqKe922Vw2t/5+tzc5N0RptMEZ5sCs9E839usFsNA
	leveuG7ZE+UPS5nVQi7uwev0BNucCHvemz4lKgEX9tSNM4F/VAND3oQnKJ++SotWP9b0zOtneaV
	2OuGnTMlgM7KT0WC1dBQ3YOJ62l4r2RE=
X-Gm-Gg: ASbGncvpD97MuIXGiQmmZGaTjkp1eegDyGRSk/KEeNUhn088LEUAT5sHGql0BWeY98n
	OUs95p1Uvph/o4moF8N41HkrbZhCidG2xhWocHYbrlXl3e71r0P+TZ8rsMDW6HwQJc0bxWZQ6ak
	Mc73VgLlchMqPPxkn14AtrmNDMiLQ8IkrLGdTtHKN4JZoRa4u0kCaUj+xq4jGsIQuIrh2tQo+AN
	lgxpfk=
X-Google-Smtp-Source: AGHT+IHzCce16jMONBYZgK4Xchaa92Tf2pNW7UGvTsjjnXWLsSszeIN1SNg2ryPEbiZZkMOvJs7XZq+TehJ7wEjx9XY=
X-Received: by 2002:a05:6e02:250c:b0:3e5:1a42:8cf3 with SMTP id
 e9e14a558f8ab-3e5331676damr20504855ab.21.1754607845931; Thu, 07 Aug 2025
 16:04:05 -0700 (PDT)
MIME-Version: 1.0
References: <20250807181616.1895-1-sj@kernel.org>
In-Reply-To: <20250807181616.1895-1-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Thu, 7 Aug 2025 16:03:54 -0700
X-Gm-Features: Ac12FXzGdfX3pnCo_8_UE28mRL8KvhR1z0p1nq4sERc8-YyjVEwnxubQXWWkYe0
Message-ID: <CAKEwX=Nm08xZVR0Zk2fOvXBmeWe5wggvTXN6+hD84S7T9L=eBQ@mail.gmail.com>
Subject: Re: [PATCH] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, kernel-team@meta.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 1446D8000D
X-Stat-Signature: uibmce6kuubnxgofaeoysin7xhri3kbh
X-HE-Tag: 1754607846-373925
X-HE-Meta: U2FsdGVkX1/6iYt9ozUG4bkf7rwYRkNITOswc/vyv4yYiHb94ZqYt6hngkk07JQdNDTH0I54mhpAxkiRp7KfisJL78+HgL/K0xD2gPAguvKgDD6pI0lVFGUsI45CjaVLCZyUsiPC78Sd0N2Bw1j8tUcpNJx/EOqAG3ZtthR5GJ5rqBaAClYWMiyAWoRBm2Qa9Plr0URi0PF0ip0yMeUbJFIRku+eQlsJNbPN/nLO9EFV9kfgrG5nLTWvZtgtXvgt58UhZr1pZe9aD2ZwCICOOEPzcMgpENS1tTml7SI8FWcd2T5rDHPRiFCFDCmjTw08/4okikUeqbAsKUjBsUyLiVfBoGZrQ74iuJ1IaAjmMKICDmjrPLDwaJ/49VYs+cN9mKzTN8/qTRdEk1L9nMWIEm1sNAeM6zz2OAtlp1YKQFtnPbsaqkq7RjVyrS5Vy/Z1hpacFfdt846Do3DOTok0MHhlNN9Uy9KF9cz8lCU1g6MJvZ82WnboM0ttFJpsE5Hr8AFksyTxMloAOU1nY7k87czwUYrELV/C/SitrTPa6JT+BgITdAvv8e+oP5UJyL6zpNj/sbMrXDF1h8hyOHBDzvJYlGr1BehQM6ioDxhKcEiIylFS4yw1LxgYQY8n/2Hp13HR4E057AUUO5lAKizeqqNWars4n4PzHwyVXxdzBmWI5a2+iORy4M3+Q122nzQHBfyq0QrvEYRSOoIFwHevvHZ7spBEpj4n/mMEsKb36cMOUVlxWRbzaF6zkErpEl/dSIRQh7fUllHHwrZoEibGIjUJe8phlewONm3ss27Kvu/tpkB0r9hz9oUzIs0Q/MDLrjoBza5rqQ2qLxb6nRU2bAUEl7B2T+CqQExg0/spetkIYDagPLcAPEL4RCIkC8RN+aThc4QzmYhX/F1YEq125xAFqfED91CL273Z9iyJZU29D1j0wa0Z5L8zPMJ+Yn/RQz8HwOrVhXY07j7+XnZ
 ZFszKz62
 HQMh9FFjDXbnFU4p5lqkeu7ZEuTCtPLjVC7R4kSqpEcjFfz6XmVVmZD9nUvjM+hUeYGiiTTNOhxpYgS9Xcu4ADZuVpWw0K2y/4xUR/Iu7D4OuxS4+h8FYCM81byz4Q5K5l7rKO4/tlVmnZSjTKAc62NpxxEJxQP7WajKdaNW5S+CFTen2ub6tLlVRAlsKE85hBLaJodYV0kwbwMtPUbVtZJL8RTY55sLnv88uoDzpFZNjP9pBfF2U3P6wmtFVx2Gm4HhyhElMVvzx9dw8UkANIrNuDdc4+/e2UsOxIcapnUqaKC2HRnoK2Jwd83oFRn7eBk9PeoKHAiPE77SZnyYgYBGE1lj+Qh20FhFbe9zw5J/8I6Poci5jmrmp6ODffvOVPzFRGHsTo3hUCaRBLH7Qv+wCehjcJx+Y3OxBp2yoCO3iH2wWGrZfVBStog==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 7, 2025 at 11:16=E2=80=AFAM SeongJae Park <sj@kernel.org> wrote=
:
>
> When zswap writeback is enabled and it fails compressing a given page,
> the page is swapped out to the backing swap device.  This behavior
> breaks the zswap's writeback LRU order, and hence users can experience
> unexpected latency spikes.  If the page is compressed without failure,
> but results in a size of PAGE_SIZE, the LRU order is kept, but the
> decompression overhead for loading the page back on the later access is
> unnecessary.

Maybe add the writeback disabled story - we added to get around this
latency issue, but that solution was not satisfactory either: wasting
cpu cycles retrying incompressible pages, especially when we're under
reclaim/memory pressure, and we've reclaimed most if not all other
sources.

This problem was pointed out by Yosry:

https://lore.kernel.org/all/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01_qkt=
kitg@mail.gmail.com/

>
> Keep the LRU order and optimize unnecessary decompression overheads in
> those cases, by storing the original content as-is in zpool.  The length
> field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> whether it is saved as-is or not (whether decompression is unnecessary)
> is identified by 'zswap_entry->length =3D=3D PAGE_SIZE'.
>
> Because the uncompressed data is saved in zpool, same to the compressed
> ones, this introduces no change in terms of memory management including
> movability and migratability of involved pages.
>
> This change is also not increasing per zswap entry metadata overhead.
> But as the number of incompressible pages increases, total zswap
> metadata overhead is proportionally increased.  The overhead should not
> be problematic in usual cases, since the zswap metadata for single zswap
> entry is much smaller than PAGE_SIZE, and in common zswap use cases
> there should be a sufficient amount of compressible pages.  Also it can
> be mitigated by the zswap writeback.
>
> When the writeback is disabled, the additional overhead could be
> problematic.  For the case, keep the current behavior that just returns
> the failure and let swap_writeout() put the page back to the active LRU
> list in the case.  It is known to be suboptimal when the incompressible
> pages are cold, since the incompressible pages will continuously be
> tried to be zswapped out, and burn CPU cycles for compression attempts
> that will anyway fails.  One imaginable solution for the problem is
> reusing the swapped-out page and its struct page to store in the zswap
> pool.  But that's out of the scope of this patch.
>
> Tests
> -----
>
> I tested this patch using a simple self-written microbenchmark that is
> available at GitHub[1].  You can reproduce the test I did by executing
> run_tests.sh of the repo on your system.  Note that the repo's
> documentation is not good as of this writing, so you may need to read
> and use the code.
>
> The basic test scenario is simple.  Run a test program making artificial
> accesses to memory having artificial content under memory.high-set
> memory limit and measure how many accesses were made in given time.
>
> The test program repeatedly and randomly access three anonymous memory
> regions.  The regions are all 500 MiB size, and accessed in the same
> probability.  Two of those are filled up with a simple content that can
> easily be compressed, while the remaining one is filled up with a
> content that read from /dev/urandom, which is easy to fail at
> compressing to <PAGE_SIZE size.  The program runs for two minutes and
> prints out the number of accesses made every five seconds.
>
> The test script runs the program under below seven configurations.
>
> - 0: memory.high is set to 2 GiB, zswap is disabled.
> - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> - 1-2: On 1-1, zswap is enabled without this patch.
> - 1-3: On 1-2, this patch is applied.
>
> For all zswap enabled case, zswap shrinker is enabled.
>
> Configuration '0' is for showing the original memory performance.
> Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap,
> zswap, and this patch under a level of memory pressure (~10% of working
> set).
>
> Because the per-5 seconds performance is not very reliable, I measured
> the average of that for the last one minute period of the test program
> run.  I also measured a few vmstat counters including zswpin, zswpout,
> zswpwb, pswpin and pswpout during the test runs.
>
> The measurement results are as below.  To save space, I show performance
> numbers that are normalized to that of the configuration '0' (no memory
> pressure), only.  The averaged accesses per 5 seconds of configuration
> '0' was 36493417.75.
>
>     config            0       1-1     1-2      1-3
>     perf_normalized   1.0000  0.0057  0.0235   0.0367
>     perf_stdev_ratio  0.0582  0.0652  0.0167   0.0346
>     zswpin            0       0       3548424  1999335
>     zswpout           0       0       3588817  2361689
>     zswpwb            0       0       10214    340270
>     pswpin            0       485806  772038   340967
>     pswpout           0       649543  144773   340270
>
> 'perf_normalized' is the performance metric, normalized to that of
> configuration '0' (no pressure).  'perf_stdev_ratio' is the standard
> deviation of the averaged data points, as a ratio to the averaged metric
> value.  For example, configuration '0' performance was showing 5.8%
> stdev.  Configurations 1-1 and 1-3 were having about 6.5% and 6.1%
> stdev.  Also the results were highly variable between multiple runs.  So
> this result is not very stable but just showing ball park figures.
> Please keep this in your mind when reading these results.
>
> Under about 10% of working set memory pressure, the performance was
> dropped to about 0.57% of no-pressure one, when the normal swap is used
> (1-1).  Note that ~10% working set pressure is already extreme, at least
> on this test setup.  No one would desire system setups that can degrade
> performance to 0.57% of the best case.
>
> By turning zswap on (1-2), the performance was improved about 4x,
> resulting in about 2.35% of no-pressure one.  Because of the
> incompressible pages in the third memory region, a significant amount of
> (non-zswap) swap I/O operations were made, though.
>
> By applying this patch (1-3), about 56% performance improvement was
> made, resulting in about 3.67% of no-pressure one.  Reduced pswpin of
> 1-3 compared to 1-2 let us see where this improvement came from.

Nice.

>
> Related Works
> -------------
>
> This is not an entirely new attempt.  Nhat Pham and Takero Funaki tried
> very similar approaches in October 2023[2] and April 2024[3],
> respectively.  The two approaches didn't get merged mainly due to the
> metadata overhead concern.  I described why I think that shouldn't be a
> problem for this change, which is automatically disabled when writeback
> is disabled, at the beginning of this changelog.
>
> This patch is not particularly different from those, and actually built
> upon those.  I wrote this from scratch again, though.  Hence adding
> Suggested-by tags for them.  Actually Nhat first suggested this to me
> offlist.
>
> [1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
> [2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
> [3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Takero Funaki <flintglass@gmail.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> Changes from RFC v2
> (https://lore.kernel.org/20250805002954.1496-1-sj@kernel.org)
> - Fix race conditions at decompressed pages identification.
> - Remove the parameter and make saving as-is the default behavior.
> - Open-code main changes.
> - Clarify there is no memory management changes on the cover letter.
> - Remove 20% pressure case from test results, since it is arguably too
>   extreme and only adds confusion.
> - Drop RFC tag.
>
> Changes from RFC v1
> (https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org)
> - Consider PAGE_SIZE compression successes as failures.
> - Use zpool for storing incompressible pages.
> - Test with zswap shrinker enabled.
> - Wordsmith changelog and comments.
> - Add documentation of save_incompressible_pages parameter.
>
>  mm/zswap.c | 29 +++++++++++++++++++++++++++--
>  1 file changed, 27 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3c0fd8a13718..2db2da130ec4 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -976,8 +976,25 @@ static bool zswap_compress(struct page *page, struct=
 zswap_entry *entry,
>          */
>         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->req=
), &acomp_ctx->wait);
>         dlen =3D acomp_ctx->req->dlen;
> -       if (comp_ret)
> -               goto unlock;
> +
> +       /*
> +        * If a page cannot be compressed into a size smaller than PAGE_S=
IZE,
> +        * save the content as is without a compression, to keep the LRU =
order
> +        * of writebacks.  If writeback is disabled, reject the page sinc=
e it
> +        * only adds metadata overhead.  swap_writeout() will put the pag=
e back
> +        * to the active LRU list in the case.
> +        */
> +       if (comp_ret || dlen >=3D PAGE_SIZE) {
> +               if (mem_cgroup_zswap_writeback_enabled(
> +                                       folio_memcg(page_folio(page)))) {
> +                       comp_ret =3D 0;
> +                       dlen =3D PAGE_SIZE;
> +                       memcpy_from_page(dst, page, 0, dlen);

I wonder if we can save one memcpy here. Would it be safe to map the page:

dst =3D kmap_local_page(page);

then, after we're done with storing (i.e after zpool_obj_write()), do:

if (dlen =3D=3D PAGE_SIZE)
    kunmap(dst);

(don't forget to unmap the page in the failure paths too!)

> +               } else {
> +                       comp_ret =3D comp_ret ? : -EINVAL;

Does this keep the value of comp_ret if comp_ret !=3D 0 lol. Syntax
looks weird to me.

> +                       goto unlock;
> +               }
> +       }

Also, can we fix the counter value?

I assume we want:

else if (comp_ret || dlen =3D=3D PAGE_SIZE)
     zswap_reject_compress_fail++;

or something like that.

And what happened to the incompressible page stored counter? :)


>
>         zpool =3D pool->zpool;
>         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> @@ -1012,6 +1029,14 @@ static bool zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
>         acomp_ctx =3D acomp_ctx_get_cpu_lock(entry->pool);
>         obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fer);
>
> +       /* zswap entries of PAGE_SIZE are not compressed. */
of length?


> +       if (entry->length =3D=3D PAGE_SIZE) {
> +               memcpy_to_folio(folio, 0, obj, entry->length);
> +               zpool_obj_read_end(zpool, entry->handle, obj);
> +               acomp_ctx_put_unlock(acomp_ctx);
> +               return true;
> +       }
> +
>         /*
>          * zpool_obj_read_begin() might return a kmap address of highmem =
when
>          * acomp_ctx->buffer is not used.  However, sg_init_one() does no=
t
>
> base-commit: 2ec534125ae474292175ae198483c545eac2161d
> --
> 2.39.5

