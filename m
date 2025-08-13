Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3CF77C87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 17:07:35 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CE6159000B3; Wed, 13 Aug 2025 13:07:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C96D4900088; Wed, 13 Aug 2025 13:07:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B85FD9000B3; Wed, 13 Aug 2025 13:07:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 9B285900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 13:07:34 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 3F38C1A03D8
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:07:34 +0000 (UTC)
X-FDA: 83772365628.22.174C8EF
Received: from nyc.source.kernel.org (nyc.source.kernel.org [147.75.193.91])
	by imf04.hostedemail.com (Postfix) with ESMTP id 493DD4000B
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:07:32 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNaBzI1b;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755104852; a=rsa-sha256;
	cv=none;
	b=AYXpzCeubcnTllEcj//gOAfws6wJK7sDGWmy4wNQ5wYZ7+kzIkl5k+q6s6QOABxhJBNhrB
	xyd8/qXFhILElZ8YRalNvr6ZFtzaUqWCko2J799OtuEbNUqftKRZZ68lJuE5sAjBTL5gI6
	51O9BDqEwNR580T7TEswseMUQsRFdnI=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=FNaBzI1b;
	spf=pass (imf04.hostedemail.com: domain of chrisl@kernel.org designates 147.75.193.91 as permitted sender) smtp.mailfrom=chrisl@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755104852;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=00E8GJDsfV6FsA5M+/GAaULPh36Y8NkDwty1a/rguxU=;
	b=Bfhhb8B2470q35RQ+lECSTW83Ut6MojnOA+eP/hr9M27pFt2MEz2exk93wW3Gmt5UdxHim
	aNdmsGMqUFHlHZjhM8Vl80uOM3oRmNYjuC9VpBw6ay8jo3YhQNHZVCWDhnRcyuV+9w24jw
	p4Psa6/eSzeaJwNqUszqamVuWmafkz8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by nyc.source.kernel.org (Postfix) with ESMTP id 6F1F9A57EEE
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:07:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08C49C4CEF9
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 17:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755104851;
	bh=D4z+BY8SALKLOAp5MUMisM5naTANI90COHnA8iypBf4=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=FNaBzI1bTuiKR4ip7QvdOQ3pm7z/zHanj/bTK3AK/FC7asFvDGpBYzSkSsiwhxzQY
	 J+mN/4viVXPmZb8olVzzoMIoWohzJVxa8CdzwZFLpoS50BdCxKDq52oLPMHb0LQ6T8
	 QWZF2j27jG9kBuho8CW62vuwpVC4w1HoU7hrmesPMdsIzx0+cc4ops4l0x0dBo+gS+
	 K66Ag4nZq5gAkxtJvTQn7/i9CsTOLJi+n3j+s5Fj/xi+NdqRkmJW5U/BE5MziEoqrr
	 yjHD1yPyYMKVdTOc/q4iEWffOeyLMkpi84Csfw0nBGtub3rr/BZtVH6DciWiPCCAuJ
	 k3Q9C0x80jelg==
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-459fbc92e69so3525e9.0
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 10:07:30 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCWPJpLcpsnVz1JS84t3mQ9Ch6eQ1C3MXPmICLIHUvS4TuSPOcSchJi8l0Q7PQ/fdveHCJFhZ5AJBQ==@kvack.org
X-Gm-Message-State: AOJu0YwZ/ek+7JAs1Bvw7oyVXW/OQC6izNrTw9U7j2bpz1Ta/BMTIJub
	Mir8SlBcCZRtN9+L8G4TzQG+VN8xDuPlhHVMX5zK0jj8XjhAyRnFP+aP+2DzDjgYcoXwA8RKTCA
	I/fFHhjhl0K/9O9/1jD8tVeK8ZSfcRFysABf5IZww
X-Google-Smtp-Source: AGHT+IHQ/ijSvk0sqaJbI9meNOVzpUjtszqh/sAqqDaTBEZOyC5JufLUl11xyHwZ+TonC5s3oUEMhB6drLtA972VT/8=
X-Received: by 2002:a05:600c:4f41:b0:459:efb0:6687 with SMTP id
 5b1f17b1804b1-45a16611be7mr2100425e9.6.1755104849475; Wed, 13 Aug 2025
 10:07:29 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org>
In-Reply-To: <20250812170046.56468-1-sj@kernel.org>
From: Chris Li <chrisl@kernel.org>
Date: Wed, 13 Aug 2025 10:07:18 -0700
X-Gmail-Original-Message-ID: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
X-Gm-Features: Ac12FXwb97AwQtmlxbE5-rWX9SsHqSbj9068Y0aoKs4uP9teiA4L9NEmWRihVfQ
Message-ID: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, Nhat Pham <nphamcs@gmail.com>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 493DD4000B
X-Stat-Signature: 3zqcpxgk4kif17kpy6zrwjkzfww3c9pr
X-Rspam-User: 
X-HE-Tag: 1755104852-793960
X-HE-Meta: U2FsdGVkX1/V8awv4wwGMXUuR2OVDv0/Wko+ysAXApzxmCQIF9liWnt94il0yHKSwoItPYKLEAcQCMdrjJCm/PGfW4mzltO2qmWNxD/MbZCedVtS1XQyjIlRElfV7pDBaHhvLJn81aMiSgwNYYSu6ptcOFoQn/VEvLveg473aHU0nLYGJgsOMFJIhhi85qG6n95ORmqMbCw5feY49+1BgSTfOEAq8l+qqP7oAYvwoNnR2+dM1OuGIRJq1cDyD4pezCQasjycai0a/MVrs2u1wuAxsQ/HqVsMjEcA7ohgnXApbJr7tVUcLUFno3S8hv5lhXeuySIY2oFR/x73fmq0EW4jF0ImoO+HkkhEg7b4hdRBf8p5DnyzWDlGeSzd84ORfIK/W3ihFDR6q112Ou0H1lsbm7yhG9bCEhExSOMaJrXJQpGD3TZfvbMRKzaA+dxXhMRbqNvuF4c+pcm4vyMgy9Ya3qqwhPUw4tXzVMdS84ZqVXpFRlNlfIBAiIOwobOzWBCYVDQTMe3C6ZpcUV9EkARVzt0bBCTOblLIVJ3M5hAlSRjC0wqvPfOjhz0d1gJmpMmi/aY0vUfVQpzm8WprOJlrcoyYw9kTgzXgu3J71k0qur9iUhjE2ER9jFdBj67zvlZysOJB2TBAVe8O5g7oLvaJ12Oez9iaaPrH5SLO2wDk66qWhMGr3X4NUtgqv04RaEgXurZhIdO2ON8ZfHqzpx9GTtJj1G1lHbMIQ4qVc1YUB5FMw5WyhFi5L665vBV2w0awejwgkCHzao2k0bjAc+v133L3rFV0iSbHRQcxlvkGAFQ+i68IQc/d9IuTrUs2DoiJH0wTn4WdDfjCbj0xRsI+AkPmL6m78SVrEDYs3dd7u7RG7PDAnYcLtQtNU5sGG7dr6XRQSMREu4zQ7qf0i9Cjit901b47UUSnqKu17gisVDAfC/r+pihL2Ncrkd9U6kKpoqg9cEEdEFfFb3l
 8P5fVKxz
 4x9SzEp6gc4S08GE1Vd1TaNJFxdcAyNNznATKQQ8NDTAQN07jNYHMAN31Hz8RnVCmSa54SLtyHbc5E5OSVWuwn/2s3zFmTgmexncOuOLY7k0DIe5LHqmi7UEyu3clr1H49ef+WOaFMTj0FMr3CWmiXxOdcVmAgKboEZlvglR2f4TbXvS1uqc8wAkKQHY1cNYNEefOjVwf4YsUJVeSfsF01DXdcNpEDJMcKvZgqz61DXlvFP+yRc7bWM0XfRT2bi7jhGpi6zotxollP6Q4rCo0flPqq80LBBrQpJO1N6qE65/D4rh13xWcvsGb/dCrhYYtrGIZ+0knwKQQOEEdNwR5mS71GhFwr661OANR79uPngzvgkIUmT+uYwdR89FPldbC54J1d9/LqfnDZqacsIk/Tz24cg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi SeongJae,

Thanks for doing that. I am working on something related to this as
well. Please consider CC me on your next version.

On Tue, Aug 12, 2025 at 10:00=E2=80=AFAM SeongJae Park <sj@kernel.org> wrot=
e:
>
> When zswap writeback is enabled and it fails compressing a given page,
> the page is swapped out to the backing swap device.  This behavior
> breaks the zswap's writeback LRU order, and hence users can experience
> unexpected latency spikes.  If the page is compressed without failure,
> but results in a size of PAGE_SIZE, the LRU order is kept, but the
> decompression overhead for loading the page back on the later access is
> unnecessary.
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

If you store uncompressed data in the zpool, zpool has metadata
overhead, e.g. allocating the entry->handle for uncompressed pages.
If the page is not compressed, another idea is just skip the zpool,
store it as a page in the zswap entry as page. We can make a union of
entry->handle and entry->incompressble_page. If entry->length =3D=3D
PAGE_SIZE, use entry->incompressable_page as a page.

The pros is that, on the page fault, there is no need to allocate a
new page. You can just move the uncompressed_page into the swap_cache.
You save one memcpy on the page fault as well. That will make the
incompressible page fault behave very similar to the minor page fault.

The cons is that, now zpool does not account for uncompressed pages,
on the second thought, that can be a con as well, the page is not
compressed, why should it account as compressed pages?

I know Hugh has some idea to store incompressible pages in the swap
cache as well. Hugh?

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
> list in the case.
>
> Knowing how many compression failures happened will be useful for future
> investigations.  investigations.  Add a new debugfs file, compress_fail,
> for the purpose.

Again, I think we should distinguish the crypto engine fail vs ration failu=
re.

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
> For all zswap enabled cases, zswap shrinker is enabled.
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
> Historically, writeback disabling was introduced partially as a way to
> solve the LRU order issue.  Yosry pointed out[4] this is still
> suboptimal when the incompressible pages are cold, since the
> incompressible pages will continuously be tried to be zswapped out, and
> burn CPU cycles for compression attempts that will anyway fail.  One
> imaginable solution for the problem is reusing the swapped-out page and
> its struct page to store in the zswap pool.  But that's out of the scope
> of this patch.
>
> [1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
> [2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
> [3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.com
> [4] https://lore.kernel.org/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01_q=
ktkitg@mail.gmail.com
>
> Suggested-by: Nhat Pham <nphamcs@gmail.com>
> Suggested-by: Takero Funaki <flintglass@gmail.com>
> Signed-off-by: SeongJae Park <sj@kernel.org>
> ---
> Changes from v1
> (https://lore.kernel.org/20250807181616.1895-1-sj@kernel.org)
> - Optimize out memcpy() per incompressible page saving, using
>   k[un]map_local().
> - Add a debugfs file for counting compression failures.
> - Use a clear form of a ternary operation.
> - Add the history of writeback disabling with a link.
> - Wordsmith comments.
>
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
>  mm/zswap.c | 36 ++++++++++++++++++++++++++++++++++--
>  1 file changed, 34 insertions(+), 2 deletions(-)
>
> diff --git a/mm/zswap.c b/mm/zswap.c
> index 3c0fd8a13718..0fb940d03268 100644
> --- a/mm/zswap.c
> +++ b/mm/zswap.c
> @@ -60,6 +60,8 @@ static u64 zswap_written_back_pages;
>  static u64 zswap_reject_reclaim_fail;
>  /* Store failed due to compression algorithm failure */
>  static u64 zswap_reject_compress_fail;
> +/* Compression into a size of <PAGE_SIZE failed */
> +static u64 zswap_compress_fail;
>  /* Compressed page was too big for the allocator to (optimally) store */
>  static u64 zswap_reject_compress_poor;
>  /* Load or writeback failed due to decompression failure */
> @@ -976,8 +978,26 @@ static bool zswap_compress(struct page *page, struct=
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
> +               zswap_compress_fail++;

I feel that mixing comp_ret and dlen size if tested here complicates
the nested if statement and the behavior as well.
One behavior change is that, if the comp_ret !=3D 0, it means the
compression crypt engine has some error. e.g. have some bad chip
always fail the compression. That is a different error case than the
compression was successful and the compression rate is not good. In
this case the patch makes the page store in zpool for cryto engine
failure, which does not help.

Is there any reason you want to store the page in zpool when the
compression engine (not the ratio) fails?

What do you say about the following alternative, this keeps the
original behavior if compression engines fail.

     if (comp_ret) {
          zswap_compress_egine_fail++;
          goto unlock;
     }

     if (dlen >=3D PAGE_SIZE) {
        zswap_compress_fail++;
        if (!mem_cgroup_zswap_writeback_enabled(
                                      folio_memcg(page_folio(page)))) {
              comp_ret =3D -EINVAL;
              goto unlock;
        }
       dlen =3D PAGE_SIZE;
       dst =3D kmap_local_page(page);
    }

Overall I feel this alternative is simpler and easier to read. I can
be biased towards my own code :-).
I think we should treat the compression engine failure separately from
the compression rate failure. The engine failure is rare and we should
know about it as a real error. The compression rate failure is normal.

Chris

> +                       comp_ret =3D 0;
> +                       dlen =3D PAGE_SIZE;
> +                       dst =3D kmap_local_page(page);
> +               } else {
> +                       comp_ret =3D comp_ret ? comp_ret : -EINVAL;
> +                       goto unlock;
> +               }
> +       }
>
>         zpool =3D pool->zpool;
>         gfp =3D GFP_NOWAIT | __GFP_NORETRY | __GFP_HIGHMEM | __GFP_MOVABL=
E;
> @@ -990,6 +1010,8 @@ static bool zswap_compress(struct page *page, struct=
 zswap_entry *entry,
>         entry->length =3D dlen;
>
>  unlock:
> +       if (dst !=3D acomp_ctx->buffer)
> +               kunmap_local(dst);
>         if (comp_ret =3D=3D -ENOSPC || alloc_ret =3D=3D -ENOSPC)
>                 zswap_reject_compress_poor++;
>         else if (comp_ret)
> @@ -1012,6 +1034,14 @@ static bool zswap_decompress(struct zswap_entry *e=
ntry, struct folio *folio)
>         acomp_ctx =3D acomp_ctx_get_cpu_lock(entry->pool);
>         obj =3D zpool_obj_read_begin(zpool, entry->handle, acomp_ctx->buf=
fer);
>
> +       /* zswap entries of length PAGE_SIZE are not compressed. */
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
> @@ -1809,6 +1839,8 @@ static int zswap_debugfs_init(void)
>                            zswap_debugfs_root, &zswap_reject_kmemcache_fa=
il);
>         debugfs_create_u64("reject_compress_fail", 0444,
>                            zswap_debugfs_root, &zswap_reject_compress_fai=
l);
> +       debugfs_create_u64("compress_fail", 0444,
> +                          zswap_debugfs_root, &zswap_compress_fail);
>         debugfs_create_u64("reject_compress_poor", 0444,
>                            zswap_debugfs_root, &zswap_reject_compress_poo=
r);
>         debugfs_create_u64("decompress_fail", 0444,
>
> base-commit: 44fa6646d975349f6499d1aeb0ed826680d0bb5c
> --
> 2.39.5
>

