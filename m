Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3529CA0EC4
	for <linux-mm@archiver.kernel.org>; Tue, 12 Aug 2025 18:53:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 60B1F8E018C; Tue, 12 Aug 2025 14:53:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBDB8E0151; Tue, 12 Aug 2025 14:53:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4AA698E018C; Tue, 12 Aug 2025 14:53:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 37C2C8E0151
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 14:53:05 -0400 (EDT)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 07ACA1154CD
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:53:05 +0000 (UTC)
X-FDA: 83769002730.19.D439F87
Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	by imf16.hostedemail.com (Postfix) with ESMTP id 1BDBD18000B
	for <linux-mm@kvack.org>; Tue, 12 Aug 2025 18:53:02 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DLAu6zU3;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755024783;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=84nI/MGeGp9rr+2mbYdPCJy5541yv4hPY1ah4+PSWJc=;
	b=j0sEudHEv+YG/pH9M6Hw7DnbiclPqHIJr24qTXKHgyAFw/JP933cIecBKp5YHxoLJ5VL/A
	z2SOrB6u8rc+DmqcxztpcQ1ZlBMmym4lW4KgyHLSrfDRzir6vlEDWe+ACqsT2QR0OV0hq5
	ZbN3W3Y9YoOijTbjnl8cqMIEXcrIBYQ=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=DLAu6zU3;
	spf=pass (imf16.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.166.176 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755024783; a=rsa-sha256;
	cv=none;
	b=vNkQnVpfpCHz+5hBLyan51Wpk5pee3OReJkQBd5C3yhXIOUdgPfju/OSUVjjizS9HneMna
	9C9C5I+fgCcX2Talk4Z0DrQZ+y8JNbH/xPJ8Jn9Tgn8l6Pzvk3jiC1pCClY/xWyzbIiYUA
	Fh8MeheTybYQBqTkdp/a7Bvj4lPo5Es=
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3e5328231e6so17077065ab.0
        for <linux-mm@kvack.org>; Tue, 12 Aug 2025 11:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755024782; x=1755629582; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=84nI/MGeGp9rr+2mbYdPCJy5541yv4hPY1ah4+PSWJc=;
        b=DLAu6zU3bulxW5DMHa6JdZ0Dd4me5mHk35SsuCBOzZ14pxeRGRB+j/xFUdOmNzAqhu
         xaNnuPoBwfxM028EtYg2qHtn2qo54mYAw23tv3JM1POgGm73hoA9W3g+qFLVwf4ZWD3h
         H6kucc3STj6v5jLAroc2eFYgiFdPUtVTZ8ut/V2EbpjHWaM203T2EFoZ1CKhp/QhyTyY
         pkJU9fDVHBcRddApYbhAi8bjQd+Dlz/iuEcms0nle/Dc6ctzdsKUAPgCUROOjauY4dCM
         ZFIiru68QQZb3/L8HFgCU9lKo536u8F8GGEq5iLrKbGsnLiOD1RlU3UZ6kAxHSn5vGck
         CXdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755024782; x=1755629582;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=84nI/MGeGp9rr+2mbYdPCJy5541yv4hPY1ah4+PSWJc=;
        b=IPlvRtRFPX8R53LcsfhgOP5SiZJaaM1r6EX38mrnMYxbc4Ec1nyNYF/OGs6uTqhr5H
         hNBs8lexOTqQdJvInf9tHCr9sJJpxcrUV22bIYVMOmT9JeLx3/kEYjozAqAjUORpSwQp
         bX4FUMpqa3T0kzsj735tUuSQ1XKRl3J3nVA2QkTIfOkJOrJHUZOaa3SiQTFj2hUozj55
         RpxfIBgAW0LUiDuk/H7dnSrR+T3I06LOob/SjTf2qxvaoa2BAKUqZR3rY0u9DUPPeClV
         RhLIU2yPKw84jUbAr49Kk5DI5MTgns3bYa1shmJbE62V9K68IIE+jAfjpkKFL2VxOTP7
         cNnQ==
X-Forwarded-Encrypted: i=1; AJvYcCXtTOo7uH7jVB7oxOFXqAb+ZhygHiI83VsYThyCJGFY8F+RR0kXeuc7W/H8mx+leldNghuqWwMh9A==@kvack.org
X-Gm-Message-State: AOJu0YyKCuH7CDDkHDTgWEmpuYaSzj6QAcDpcPoiutXeMjQ2tiA9GVDo
	I6wGonGMkYRN6bSwM/R02tcwt/Ru3PqQtMUMQT0BPMzAZOprjVDiFR0IK5KJKDt9WdJghDqVu1+
	+P8Z+Pi902lmP7RQob7iZxM9Zk9QUuGY=
X-Gm-Gg: ASbGncvO34TgPo0QhcEUiHjMsi5WmarMqDmt5sxLTY3Phf9rEbBXQ8yvKPmfW4i/drm
	JaUgNp5zTdS1AOCxSE0JnjTd14D+Ggn2ipRLG++WIS7CIR5XaM1sJ6OhklDDACqBd5bg2qdU6hT
	j1GG5whO4eVehCU26gZxhJ+EBsNvU1ZYabzlTWTu0Ab5ugreAWRUPV7c+RTUfcjvZgADTkZQPcW
	Kfh
X-Google-Smtp-Source: AGHT+IFZq2uXSn511PC7hnm8fMyDqEVmE5Td+oKPsz7r9QNsLauOAV/Zk5wOUF7yJGrCUsoR4hWfj6h4w+Tfk868jgc=
X-Received: by 2002:a05:6e02:19cb:b0:3e5:4b2e:3b02 with SMTP id
 e9e14a558f8ab-3e567260ed3mr3484605ab.0.1755024781709; Tue, 12 Aug 2025
 11:53:01 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org>
In-Reply-To: <20250812170046.56468-1-sj@kernel.org>
From: Nhat Pham <nphamcs@gmail.com>
Date: Tue, 12 Aug 2025 11:52:50 -0700
X-Gm-Features: Ac12FXwIsLOyoa1vNGfMPpXo700C4eZd_F_UHAymOv6ARngqzldGZx6Jx_qfgUQ
Message-ID: <CAKEwX=O2ZgRycpOiLAWNdyaEY_UE=8X-unJCaMmMvL-4DGZreQ@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Chengming Zhou <chengming.zhou@linux.dev>, 
	David Hildenbrand <david@redhat.com>, Johannes Weiner <hannes@cmpxchg.org>, 
	Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Takero Funaki <flintglass@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Stat-Signature: 9pqqsktk5jmoboywd1a6k99adkqpaoog
X-Rspam-User: 
X-Rspamd-Queue-Id: 1BDBD18000B
X-Rspamd-Server: rspam01
X-HE-Tag: 1755024782-289023
X-HE-Meta: U2FsdGVkX1+EFUAbOyaDmfcXr3ulS0OTQiPe9y/C6Qx7CBXUyV97CQHFigi2aeldD9c5wuF8nDXzczJKxHH4g81HUHNEkq3cqRmU/n4mL9TmNpByCSl3VtQAkkBjll68V89/CiHS7IperYppMYISbwHSY0BpvBdNIPsNbSjyzPP4RKLt8SHxxcMWUMtzFhjkzEdmiQElbudCKsezwURKh8KG/CuomDmR+mlRhsBUccGuqTsjfYDm5UzF9BFaMWwaIIjGMylfPu+vRpHctE+3AGBnD+nxbNYzABTCE4QdDIzoFdeKbYCICNtEYpexeN7w30Ffncf0RfFxssbEkKyxmhzGr2nc9g9RjVk1JBuHDvgzX6FvJdIPtUNTAc5pqkFhDqamci0KumFv5Hvi2DdxrjPbXjYpKXjAlvdejYmjiq8ztfFEe8d4HdPoih+u28YECShC34duKxx30ZtfI5LQuDl37b6tcYn+8tWeJVKCEwPXwzfFXPGssMm3nUY8/t+OiIUX4qoAVJnG0ICzTfl6hYD5BZHTYmY2XRqwgmiUqavZIvet722cQSP04EImoikODHTbdBK/OU0kT9wT9v9fxwpcuhco+KDdpAzW1NBqgH3v81HAlOWI+ixbQ0WXCWJioaIhZjJmem3fmnn94lLKedijVYku5h1HzwZZPEt7fOT5I8areW11DLWPyt9aI68qvMLGS08FISfbuIO1YtCHnK7htpiTO426/d72gMAcYNX1cl7maptgBNAVGbx1Ev1gZ3QyYc1D+z9usHoqqGhMS7uhfVtAHYZrmWogP9iH00hzH4S9f/OqmhfR97JJvBK9QTHCarc8T2amHzWiUHbE82oexNmWJJ7KrIPXwcNy8dY+PGVp5dDTkmzv2ijivYx5tI02szafsTSazWJ9TC7EOmlcUAZ/VUn2K7XfCj7teSyEtUAI3OGJ5B3PuiOl6pctkfLro/+GAcNi2X8dxzd
 xZ3RxssV
 gp+qXYzTg03cWYwKqvkV49zFba5q4a1SHfEiudek5dQigi2af0r4kwJhklensqKPfPdBIakXNWqRxoO+TCG1JzBTbsmDN9JZhPW2bhXn+iAzf/asPSBRmsEc7QVA8vHjsZUiXw4MLt3gmYvwSIEF7I4++1uHNK8bFFEUU7KyiYxG0ibMLNW5cM1pjYQgC9RSL8GzEWmU8rp4e5luSGUqXFHQn5/20L4Y/DJhSa/1D6Nei89Xdr9Gsu5ZQsAP75SCfoFBo9hEUC1++M5OuZuzhdN1kp/tO0g9VK7wswSxnaN6tvkFt32xUvY3F0PnI1lOkqC6eD04zWxg6atz3O4NjseFBIQ6hA8MVFvX79wq66x4NxDyRdnlsHzVWLBSZhFZjxSUVwPAxZiDHgtT2KBIn7wtaba7vvfFHVgXPkFU25mx5Qa/yGPWQLHzR7JCNvb1x6R0L
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

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
> list in the case.
>
> Knowing how many compression failures happened will be useful for future
> investigations.  investigations.  Add a new debugfs file, compress_fail,
> for the purpose.
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

I'll let Johannes chime in as well, but LGTM.

Acked-by: Nhat Pham <nphamcs@gmail.com>

Thanks!

