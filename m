Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DA0DC87FCF
	for <linux-mm@archiver.kernel.org>; Wed, 13 Aug 2025 18:33:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B836C9000C4; Wed, 13 Aug 2025 14:33:13 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B5AF1900088; Wed, 13 Aug 2025 14:33:13 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A70329000C4; Wed, 13 Aug 2025 14:33:13 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8F0D5900088
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 14:33:13 -0400 (EDT)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 58A0BC0440
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:33:13 +0000 (UTC)
X-FDA: 83772581466.02.D4C4A43
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	by imf21.hostedemail.com (Postfix) with ESMTP id 74D991C0005
	for <linux-mm@kvack.org>; Wed, 13 Aug 2025 18:33:11 +0000 (UTC)
Authentication-Results: imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RvCCNd/x";
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1755109991;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ONwL100N6xPJzY3LKqxJvxeIT24I19t6heDt6lpQxPA=;
	b=mOqdrsCiDmpRgAJLX2sAlO33kJSBbkbn5VjO79xsV5gE01IqpTUHu7vjBz1w3fmqy0rbGF
	0+EojmRRZug2x+C18ad98aOVgRuM3mrxoBJV6z4Hr40VxiWgpg7Uy+YLccOQ0sJJNplR7K
	7IsdIcGehbnffSEm1rZ+0P+yU+r5NoA=
ARC-Authentication-Results: i=1;
	imf21.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="RvCCNd/x";
	spf=pass (imf21.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.161.53 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1755109991; a=rsa-sha256;
	cv=none;
	b=5sbobwN5Bgq290j4vvtK/tPuEsrD+u5iK3yaHPOxQfn7paijFOyr1tIb/ME53wZhd5thCC
	8zphzvD/bPduCHOCBFqlpZLv2skWgeVhxxrdKNy7TPOOieTsqvD8/4iuAmIdkiVx/5Ysk5
	9cGUbKOGQE7aLJuM5UDfS5lWsAt2mn8=
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-61bd4dd1ccaso66461eaf.2
        for <linux-mm@kvack.org>; Wed, 13 Aug 2025 11:33:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1755109990; x=1755714790; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ONwL100N6xPJzY3LKqxJvxeIT24I19t6heDt6lpQxPA=;
        b=RvCCNd/x9EX9ipMM/kSYrAw7KSoOwxt9lRSW1G8KqAEiHP9RT1Z3fWGJ8LUotpgSoF
         AqKNS3QGvKr7ywtmcoMkXTeL+97vjzl/a+NP+LEUiAoppx63Z+DinVLLUg1suJhR/exa
         TYue8csLleUPFHlI3enrjrMpUIRydGuwSnecxywpbvFjpbChHikxf2Ze2Wnh0S/TGa+6
         srNBosb0/87NuUDapiO/SYEXXS6/NgU2equTlc4lqXyHCrbKz72Ijpf859QpRSUnRbVa
         afAzt/lbkmDaqfznTiRJaZm5VEnPB7cafKWeqD0FvFm/aeUztrPpLgT65kdzZNrJcdfB
         iyKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755109990; x=1755714790;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ONwL100N6xPJzY3LKqxJvxeIT24I19t6heDt6lpQxPA=;
        b=Pcx7EspE2sFtd0kL9FHa2ikvQAz1cYprRxoyuZrQLzWv+hwkE29Pb5546pwsuBVqKg
         mM2039w8lxMWhJjeVDXkunxUxqSuwauXdFZIwyEykY7dzSJUn3rgQd/Nq25SYTXyUkjE
         S2hjf/12uAJUmaPhszeG9jSLoOYupBh3oSiASn9QtaFQPeU4GyIQSVEqsLmA2fgBGxMX
         RCHTqCT25RQl88v7agGoBP6HiIoVQkE3BtVJSLp/kjcTpsjmIc1NrbVKlNgz1PMHBMwq
         sNHCPaE/XcztdiQwUUpzvx/OTf9AOxlXLCNtuoR3UYzOfImZts7aaB7gB0m1j4DM4OEL
         bYPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXDmCoFLrTsJAUDNYXc1ZyJcK5jC4E2fXidYZcX2K6Hq+U6HDw50Tw7QWVs+J57mk05K1bh5wf99Q==@kvack.org
X-Gm-Message-State: AOJu0YxOAWHpGzZS8q96DGCxfub4sVGpqbXxacyphwtEyIs2jrvT8nKc
	wX1tkuc6MBvqTrNFu8NczC/eVJwyb/HFbWaQJolfpQV9GUMAwKwbFjaHH2GcJ0F03ERRz3A0CH3
	krQQl/2GEYidabFYfOuheUAK96rS2bPc=
X-Gm-Gg: ASbGncvTB5hdT4eKH+QWWRXeJhbWkX4h58sQ152osNS951AOTdflgh5XK0kSuR93ZN3
	wV6AxrBdZUCxjaJ+fZMN4E/gqVY7rRTSYjLmXAhQc0m4DTmQ4BN1JVPKJdHYwsEjTc1KxAr7gkw
	sonkJfrFwITKKOtQGPsMh6ICFQDzSPbMU/mMQu3Mw9os2gYvFvmwCYM2/akSHT2xjZ8NUvWOvRE
	fXM
X-Google-Smtp-Source: AGHT+IH1bWUY8FkF2HhurIrAUzTTRQ4VGJ5bod6IIBHHxyPqEJfKC6m1+htyXiiZejpOwxTJ3slYWVHOqVdCS+fuTwU=
X-Received: by 2002:a05:6808:d4c:b0:41e:9fd0:bd2c with SMTP id
 5614622812f47-435df7c1c40mr163198b6e.18.1755109990047; Wed, 13 Aug 2025
 11:33:10 -0700 (PDT)
MIME-Version: 1.0
References: <20250812170046.56468-1-sj@kernel.org> <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
In-Reply-To: <CAF8kJuN1BH0rqC6czj9govNOugd_5K9ijYcxbWYpEpUdQKn0-A@mail.gmail.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Wed, 13 Aug 2025 11:32:59 -0700
X-Gm-Features: Ac12FXzPXLQ7gqnSjSM7ZZyDFngw6vQJDXLffW208GO3eaHtGTf8ysAiSLoJZDk
Message-ID: <CAKEwX=MzHu+kXygCx=AC7MptExsy8CS9c6-fBbFK=shYDD4S7w@mail.gmail.com>
Subject: Re: [PATCH v2] mm/zswap: store <PAGE_SIZE compression failed page as-is
To: Chris Li <chrisl@kernel.org>
Cc: SeongJae Park <sj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, David Hildenbrand <david@redhat.com>, 
	Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry.ahmed@linux.dev>, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, Takero Funaki <flintglass@gmail.com>, Hugh Dickins <hughd@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 74D991C0005
X-Rspam-User: 
X-Stat-Signature: p3rhhbmbw3sjjm4mqbpekqaij8m1ga8m
X-Rspamd-Server: rspam09
X-HE-Tag: 1755109991-350627
X-HE-Meta: U2FsdGVkX1/GgOPSIlGpR17WMtT5OA8l1ULcCCzwzOsVonV+ut1IV2JtllJ2U9Cx0q8ikFpcyOvq+zEvu2nyone0azqw3w63yVwNR3m6zGd7U7gMb8X3rJZR8Dh3uTOd7ZVhNwGXkBkXiqd7agPhvJG/9H5YBlUqtuHK36rz8btMHqn91kSjOEUBBblC9IkG6ptx70QsdvDG1jkLlhkaNzRRppO4gNUCnqM5E+ms5MJ5z6QpFH+KuZtzr+playdZ38DabYsXzyGm3XyWr7C3ssCFbSlgk56vLpPbsqBf35FLXfnN/8ZENeczDn4tafz8JxHCV1nPjiSAVXqn0jYrdSqwegG+r9er3aJbOkEasLwnnvz4n5SvL4fm7/aviJNPJXM33SaN0BW22ZWFKtbwciswA+OvVvWwUcmRejNo0xvBDMtE5IYkQGUB8kXlMhazowhzl53kHdbGcApsrM6YaSlpemIeELCgDWCsZ73KHTSasTWrtEF5WquRSKWk1MmSQVcDIRRQoPbV/sGfaKEgM70WTBYke3vNis7FA8elpEcgTG+q39t91Fx4/RP93lPtFNfSqxRQG9+hqtb0wiFfSy4y1dTunUsjQjyMeoyBh7ivA8Rz9sVTZ9/5D+H6HoFRZJf3st2vdt4Pp9lXK94OQrUZLczLD2GgdEgaN5gPH6AGuH/J3mlzRxkbSPB1UKCFdIs5Z05WAI2g89Eaia+gyPUzKE8HViXzsGT5oIsO3jNdWeVbRzUsN/UYJh1e6PwIuvCPd0bBIJeE/b8fmqK8omlfRERvmb15RoQJflZoVDVPyZzrHrPc8zvcqSx0vlmxsMOUn9vhRFnd5eg2/XdzdYWsKsgnKw0W/Z7rJIpLzc6CCzSvMeHHUQCo0o/oQ7MokCzKE3jnifasQM5N+JNVDIm6ZNek4AmngUgntueidvTV7szv0qf9p+X4cM+8f8fNfHUyDo/oEQfVNOTnToJ
 e9vH9Yvs
 4htlZBSaou+HvlPZx7uFXJyMfbOxk3G+23qD2aafB+S6vtQspBGnK78mnSj6RUsv7RV5ESOsjESQcrkgIggGjXpwHto8UauW44PIhCIxy+AevGbG73pYCX+NOYqcafGgBxqw7+wHDa0cxBtr4scX5RcYdIpgthCujkpWHf3rf0ar62VYUASQU1sbfOXJmTznspJJam7KLyMs2QQIPx1VDRA7zthbYvQebu+7TdSERDRDSYPbx0HqaaItG80CYmS/1Ej8iewIyCC7ivLYjUH9+QSDOilKA5i4WSSlb1VFFdI/DUmNp7PUiumRh+GncTuplTd+Y27VjGXohBr4N723yE+aFx+bI+r2z65UoerLFqEcQoK0BmQC7rn53OsWBMtPRZkWmMKdpfHg1UWbo+MmC0/Ir4vyaMma8U/WmUXYiriGByDbpmnAf2KdZvQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 13, 2025 at 10:07=E2=80=AFAM Chris Li <chrisl@kernel.org> wrote=
:
>
> Hi SeongJae,
>
> Thanks for doing that. I am working on something related to this as
> well. Please consider CC me on your next version.
>
> On Tue, Aug 12, 2025 at 10:00=E2=80=AFAM SeongJae Park <sj@kernel.org> wr=
ote:
> >
> > When zswap writeback is enabled and it fails compressing a given page,
> > the page is swapped out to the backing swap device.  This behavior
> > breaks the zswap's writeback LRU order, and hence users can experience
> > unexpected latency spikes.  If the page is compressed without failure,
> > but results in a size of PAGE_SIZE, the LRU order is kept, but the
> > decompression overhead for loading the page back on the later access is
> > unnecessary.
> >
> > Keep the LRU order and optimize unnecessary decompression overheads in
> > those cases, by storing the original content as-is in zpool.  The lengt=
h
> > field of zswap_entry will be set appropriately, as PAGE_SIZE,  Hence
> > whether it is saved as-is or not (whether decompression is unnecessary)
> > is identified by 'zswap_entry->length =3D=3D PAGE_SIZE'.
> >
> > Because the uncompressed data is saved in zpool, same to the compressed
> > ones, this introduces no change in terms of memory management including
> > movability and migratability of involved pages.
>
> If you store uncompressed data in the zpool, zpool has metadata
> overhead, e.g. allocating the entry->handle for uncompressed pages.
> If the page is not compressed, another idea is just skip the zpool,
> store it as a page in the zswap entry as page. We can make a union of
> entry->handle and entry->incompressble_page. If entry->length =3D=3D
> PAGE_SIZE, use entry->incompressable_page as a page.
>
> The pros is that, on the page fault, there is no need to allocate a
> new page. You can just move the uncompressed_page into the swap_cache.
> You save one memcpy on the page fault as well. That will make the
> incompressible page fault behave very similar to the minor page fault.
>
> The cons is that, now zpool does not account for uncompressed pages,
> on the second thought, that can be a con as well, the page is not
> compressed, why should it account as compressed pages?
>
> I know Hugh has some idea to store incompressible pages in the swap
> cache as well. Hugh?

I've also proposed that approach internally - keeping the page in
swapcache, while adding them to the zswap LRU for writeback to disk
(and so that we do not consider them for zswap again in the future).

But after a while, we decided against it, mostly due to the complexity
of the solution. On the zswap side, we need to distinguish between the
ordinary struct zswap_entry and the struct page on zswap's LRU list.
Externally, we need to handle moving a page currently in the zswap LRU
to the main memory anon LRUs too.

Migration is another concern. Zswap needs to be notified that the
"backend" of a zswap entry has changed underneath it. Not impossible,
but again that's just more surgery.

So we decided to start with a simple solution (this one), and iterate
as issues cropped up. At least then, we have production justifications
for any future improvements.

>
> > This change is also not increasing per zswap entry metadata overhead.
> > But as the number of incompressible pages increases, total zswap
> > metadata overhead is proportionally increased.  The overhead should not
> > be problematic in usual cases, since the zswap metadata for single zswa=
p
> > entry is much smaller than PAGE_SIZE, and in common zswap use cases
> > there should be a sufficient amount of compressible pages.  Also it can
> > be mitigated by the zswap writeback.
> >
> > When the writeback is disabled, the additional overhead could be
> > problematic.  For the case, keep the current behavior that just returns
> > the failure and let swap_writeout() put the page back to the active LRU
> > list in the case.
> >
> > Knowing how many compression failures happened will be useful for futur=
e
> > investigations.  investigations.  Add a new debugfs file, compress_fail=
,
> > for the purpose.
>
> Again, I think we should distinguish the crypto engine fail vs ration fai=
lure.
>
> >
> > Tests
> > -----
> >
> > I tested this patch using a simple self-written microbenchmark that is
> > available at GitHub[1].  You can reproduce the test I did by executing
> > run_tests.sh of the repo on your system.  Note that the repo's
> > documentation is not good as of this writing, so you may need to read
> > and use the code.
> >
> > The basic test scenario is simple.  Run a test program making artificia=
l
> > accesses to memory having artificial content under memory.high-set
> > memory limit and measure how many accesses were made in given time.
> >
> > The test program repeatedly and randomly access three anonymous memory
> > regions.  The regions are all 500 MiB size, and accessed in the same
> > probability.  Two of those are filled up with a simple content that can
> > easily be compressed, while the remaining one is filled up with a
> > content that read from /dev/urandom, which is easy to fail at
> > compressing to <PAGE_SIZE size.  The program runs for two minutes and
> > prints out the number of accesses made every five seconds.
> >
> > The test script runs the program under below seven configurations.
> >
> > - 0: memory.high is set to 2 GiB, zswap is disabled.
> > - 1-1: memory.high is set to 1350 MiB, zswap is disabled.
> > - 1-2: On 1-1, zswap is enabled without this patch.
> > - 1-3: On 1-2, this patch is applied.
> >
> > For all zswap enabled cases, zswap shrinker is enabled.
> >
> > Configuration '0' is for showing the original memory performance.
> > Configurations 1-1, 1-2 and 1-3 are for showing the performance of swap=
,
> > zswap, and this patch under a level of memory pressure (~10% of working
> > set).
> >
> > Because the per-5 seconds performance is not very reliable, I measured
> > the average of that for the last one minute period of the test program
> > run.  I also measured a few vmstat counters including zswpin, zswpout,
> > zswpwb, pswpin and pswpout during the test runs.
> >
> > The measurement results are as below.  To save space, I show performanc=
e
> > numbers that are normalized to that of the configuration '0' (no memory
> > pressure), only.  The averaged accesses per 5 seconds of configuration
> > '0' was 36493417.75.
> >
> >     config            0       1-1     1-2      1-3
> >     perf_normalized   1.0000  0.0057  0.0235   0.0367
> >     perf_stdev_ratio  0.0582  0.0652  0.0167   0.0346
> >     zswpin            0       0       3548424  1999335
> >     zswpout           0       0       3588817  2361689
> >     zswpwb            0       0       10214    340270
> >     pswpin            0       485806  772038   340967
> >     pswpout           0       649543  144773   340270
> >
> > 'perf_normalized' is the performance metric, normalized to that of
> > configuration '0' (no pressure).  'perf_stdev_ratio' is the standard
> > deviation of the averaged data points, as a ratio to the averaged metri=
c
> > value.  For example, configuration '0' performance was showing 5.8%
> > stdev.  Configurations 1-1 and 1-3 were having about 6.5% and 6.1%
> > stdev.  Also the results were highly variable between multiple runs.  S=
o
> > this result is not very stable but just showing ball park figures.
> > Please keep this in your mind when reading these results.
> >
> > Under about 10% of working set memory pressure, the performance was
> > dropped to about 0.57% of no-pressure one, when the normal swap is used
> > (1-1).  Note that ~10% working set pressure is already extreme, at leas=
t
> > on this test setup.  No one would desire system setups that can degrade
> > performance to 0.57% of the best case.
> >
> > By turning zswap on (1-2), the performance was improved about 4x,
> > resulting in about 2.35% of no-pressure one.  Because of the
> > incompressible pages in the third memory region, a significant amount o=
f
> > (non-zswap) swap I/O operations were made, though.
> >
> > By applying this patch (1-3), about 56% performance improvement was
> > made, resulting in about 3.67% of no-pressure one.  Reduced pswpin of
> > 1-3 compared to 1-2 let us see where this improvement came from.
> >
> > Related Works
> > -------------
> >
> > This is not an entirely new attempt.  Nhat Pham and Takero Funaki tried
> > very similar approaches in October 2023[2] and April 2024[3],
> > respectively.  The two approaches didn't get merged mainly due to the
> > metadata overhead concern.  I described why I think that shouldn't be a
> > problem for this change, which is automatically disabled when writeback
> > is disabled, at the beginning of this changelog.
> >
> > This patch is not particularly different from those, and actually built
> > upon those.  I wrote this from scratch again, though.  Hence adding
> > Suggested-by tags for them.  Actually Nhat first suggested this to me
> > offlist.
> >
> > Historically, writeback disabling was introduced partially as a way to
> > solve the LRU order issue.  Yosry pointed out[4] this is still
> > suboptimal when the incompressible pages are cold, since the
> > incompressible pages will continuously be tried to be zswapped out, and
> > burn CPU cycles for compression attempts that will anyway fail.  One
> > imaginable solution for the problem is reusing the swapped-out page and
> > its struct page to store in the zswap pool.  But that's out of the scop=
e
> > of this patch.
> >
> > [1] https://github.com/sjp38/eval_zswap/blob/master/run.sh
> > [2] https://lore.kernel.org/20231017003519.1426574-3-nphamcs@gmail.com
> > [3] https://lore.kernel.org/20240706022523.1104080-6-flintglass@gmail.c=
om
> > [4] https://lore.kernel.org/CAJD7tkZXS-UJVAFfvxJ0nNgTzWBiqepPYA4hEozi01=
_qktkitg@mail.gmail.com
> >
> > Suggested-by: Nhat Pham <nphamcs@gmail.com>
> > Suggested-by: Takero Funaki <flintglass@gmail.com>
> > Signed-off-by: SeongJae Park <sj@kernel.org>
> > ---
> > Changes from v1
> > (https://lore.kernel.org/20250807181616.1895-1-sj@kernel.org)
> > - Optimize out memcpy() per incompressible page saving, using
> >   k[un]map_local().
> > - Add a debugfs file for counting compression failures.
> > - Use a clear form of a ternary operation.
> > - Add the history of writeback disabling with a link.
> > - Wordsmith comments.
> >
> > Changes from RFC v2
> > (https://lore.kernel.org/20250805002954.1496-1-sj@kernel.org)
> > - Fix race conditions at decompressed pages identification.
> > - Remove the parameter and make saving as-is the default behavior.
> > - Open-code main changes.
> > - Clarify there is no memory management changes on the cover letter.
> > - Remove 20% pressure case from test results, since it is arguably too
> >   extreme and only adds confusion.
> > - Drop RFC tag.
> >
> > Changes from RFC v1
> > (https://lore.kernel.org/20250730234059.4603-1-sj@kernel.org)
> > - Consider PAGE_SIZE compression successes as failures.
> > - Use zpool for storing incompressible pages.
> > - Test with zswap shrinker enabled.
> > - Wordsmith changelog and comments.
> > - Add documentation of save_incompressible_pages parameter.
> >
> >  mm/zswap.c | 36 ++++++++++++++++++++++++++++++++++--
> >  1 file changed, 34 insertions(+), 2 deletions(-)
> >
> > diff --git a/mm/zswap.c b/mm/zswap.c
> > index 3c0fd8a13718..0fb940d03268 100644
> > --- a/mm/zswap.c
> > +++ b/mm/zswap.c
> > @@ -60,6 +60,8 @@ static u64 zswap_written_back_pages;
> >  static u64 zswap_reject_reclaim_fail;
> >  /* Store failed due to compression algorithm failure */
> >  static u64 zswap_reject_compress_fail;
> > +/* Compression into a size of <PAGE_SIZE failed */
> > +static u64 zswap_compress_fail;
> >  /* Compressed page was too big for the allocator to (optimally) store =
*/
> >  static u64 zswap_reject_compress_poor;
> >  /* Load or writeback failed due to decompression failure */
> > @@ -976,8 +978,26 @@ static bool zswap_compress(struct page *page, stru=
ct zswap_entry *entry,
> >          */
> >         comp_ret =3D crypto_wait_req(crypto_acomp_compress(acomp_ctx->r=
eq), &acomp_ctx->wait);
> >         dlen =3D acomp_ctx->req->dlen;
> > -       if (comp_ret)
> > -               goto unlock;
> > +
> > +       /*
> > +        * If a page cannot be compressed into a size smaller than PAGE=
_SIZE,
> > +        * save the content as is without a compression, to keep the LR=
U order
> > +        * of writebacks.  If writeback is disabled, reject the page si=
nce it
> > +        * only adds metadata overhead.  swap_writeout() will put the p=
age back
> > +        * to the active LRU list in the case.
> > +        */
> > +       if (comp_ret || dlen >=3D PAGE_SIZE) {
> > +               zswap_compress_fail++;
>
> I feel that mixing comp_ret and dlen size if tested here complicates
> the nested if statement and the behavior as well.
> One behavior change is that, if the comp_ret !=3D 0, it means the
> compression crypt engine has some error. e.g. have some bad chip
> always fail the compression. That is a different error case than the
> compression was successful and the compression rate is not good. In
> this case the patch makes the page store in zpool for cryto engine
> failure, which does not help.
>
> Is there any reason you want to store the page in zpool when the
> compression engine (not the ratio) fails?

It helps if you want to write them back to disk later, in the LRU
order. SJ pointed that out in the patch changelog, I believe.

