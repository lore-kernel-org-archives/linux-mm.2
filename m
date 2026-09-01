Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1776BC61DD3
	for <linux-mm@archiver.kernel.org>; Tue,  1 Sep 2026 07:08:38 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 03F446B008A; Tue,  1 Sep 2026 03:08:38 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F321A6B00A1; Tue,  1 Sep 2026 03:08:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E480F6B00A2; Tue,  1 Sep 2026 03:08:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id BB74B6B008A
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 03:08:37 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 4E0EBA036F
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:08:37 +0000 (UTC)
X-FDA: 85164315474.08.522CDBC
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com [209.85.218.43])
	by imf27.hostedemail.com (Postfix) with ESMTP id 60FC440006
	for <linux-mm@kvack.org>; Tue,  1 Sep 2026 07:08:35 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WVUcOzv6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1788246515;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MENEyb6n8ZqZ9853k/Vkeokm/Vdk4mPlZon6Y0g8sH8=;
	b=e3PSZaKYGhB4kNTDowXez/MZUY+o+e4IyMSgMc5qlMiIXMURm6G7DwVWrleLHoo4whEBfo
	nrQhk7FoLTuNeTP/7WTxZ3iFS3X+0o5jjijeN1rl+7UqHqbo/NwDNz7X54v2MKrc8yCtaX
	c6p/tlweuKaGfOWfxZMOFrSp8eduyg4=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1788246515;
	b=ihmHYFuiDUXSxVEZ2cxF9xNXn+lXjoq4bOCt78fL0fjmEEPsrVblRi/lGASCT32H3BI/DU
	eKtpX3R4sGJDI+2S6QlGSGyLnabMEriNwmdDXEk6fTYmrwb6TZ6VgHsr1fdkEqPkZcuZ1F
	D2W95t4TF+kP0rpia89A0ThjVBTntCA=
ARC-Authentication-Results: i=2;
	imf27.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=WVUcOzv6;
	arc=pass ("google.com:s=arc-20260327:i=1");
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf27.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.218.43 as permitted sender) smtp.mailfrom=ryncsn@gmail.com
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c252c7270faso737823866b.3
        for <linux-mm@kvack.org>; Tue, 01 Sep 2026 00:08:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788246514; cv=none;
        d=google.com; s=arc-20260327;
        b=XCEhA3PWzzePN6PtsIwk2YNx3ZJlXtY1lwObs0PDMJwtYlfQIs7XXGAk1d7OoPGRBV
         hl3u0sETa+d7lbab5L9/5M1n/K3OcVVpIkHv3KHxRbD+dV95XdfizGis+ffvOdiX+gqo
         c9rLfR5q+NMZKvzP/bL052z9Ezu5z2Nnp8eSsM0Rl7bB9Visy0aUZM4rLuwUlmmYbe4s
         tEujWbkIdyDtfKNbwp2neelTuZUpPf3Fr3aAiTM+LROGt/90k4hFuhkgu+BUpUN/G2UX
         9vHVYr5J2rgYPUV5Q+6FFEDYPW9aggDjV8wjgatPVmUftDXw2Bh05rBXDO9OdNAO8PFp
         SS8A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=MENEyb6n8ZqZ9853k/Vkeokm/Vdk4mPlZon6Y0g8sH8=;
        fh=0L8lR7QFrH5Jnhmg2rGxiaMoUE8Gu+dNItHhEMH4puk=;
        b=TEl2YKETJgV5u0pA1m286WixVFMbzMYg1RnLThKe2vchPEYIeFbY8Jv1cdc6Ijtzxh
         pi7wSOMnhFUXP7Ys8oRpXbTrLatSn8p0twZLWdmnxsb2Yjv5MOBr4VrStAWO2ehVK0Mk
         FrWLsZ5HPYbagsbnUL2BYHKvQRJ16DAuK/TJ2F0DUK1sFGXhDxBukam6CV3Cun4/mii5
         WItSt9P84MUbHPAr6ZPgKuXMV2PXy1KBNufpJ+YlETvm1O81bbzPcMoQbcF7ty1uXofJ
         AWQxzCZ+e55tjMI/Yit/fI59CZEOy8TioEzecZXQup3FAWDdnKTESwpTfIaAbskjZW7O
         XVqQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1788246514; x=1788851314; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=MENEyb6n8ZqZ9853k/Vkeokm/Vdk4mPlZon6Y0g8sH8=;
        b=WVUcOzv6QsPTSTVIpueevd5VNKcv/h7T6/GCUlzDbqtwbkGgc7CHgZxbSOBVgdrUH1
         Kxlg/7rQmgc3M48UPrpVmhGX2cEAWHmIQ2/54qwxx5swhade+mVEXJ6PAm9/OtQbRxY7
         KLKRz47+vS3uEIBIamCiib55CvrlJvOc2tU2pmM1NGIF+vMlyyb3kP1fa/cIQglAxLVE
         5lDXaR4UFvajVG/sZHz17QqlkxCYhqb7ECsjiJ+EWRx1C3xxK+5uO5us1vkU8M+s0WEj
         JDedrcgLqqUDNvh0d30AowwnARbr3m/tPxxZOyV5rDMJC9PPcKDekwXYyGk62XbhrIEV
         4k3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788246514; x=1788851314;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=MENEyb6n8ZqZ9853k/Vkeokm/Vdk4mPlZon6Y0g8sH8=;
        b=qWMEfB1RWnicbvDGC3DZiZkqNK9acsXtmgzJHZXlDKy/+z3/ozAHDirybgYVQ24Cs3
         dO1gTq4Fy/ZuZpdeMyplukuNOOv04U+oeXW3kqWToVsl/oGQP73bND7F65eikBh9kibL
         rCNK5CdeZ3Xcp2vkksSs6CdENa3AxwqoAz3vlJ5eCvooZ1m9R3dUprZ/VXrvsiKyrdy5
         ulkb8GUWO2/fNgnx66gsZyCNuebjoSQH1NcIHt+mVbDCBlGWDJR5o1jk+a/1V5BsEPkW
         +nov+Qn/9a0BCF90FgDKSg6qNI+scjUicRF7AQ6g8JyyA+cFerqHiu455GnrHZkCODe9
         3cig==
X-Gm-Message-State: AFuF++lRpBbvzn0ztHeL1KTWXnYKyeI8tS+fKGHb5vyPo6kznYg7932D
	Hf8UhnWGjIdrxcTznAzYMOZSf2cCiuGQYVb+e+FAzCUa/bFIBnfLnjeA9G9j7pFG1JnjvSkDjNz
	Fw7tlj0W9MzmXwoOSWO5p3UMfblyktV8=
X-Gm-Gg: AR+sD10MUAR5GFBpmOj/Q5/lkaFlIc+SoGcYVbGpSs7wfItbGuRsno9g6KpPkOsoYQ9
	k5veh8ywCzd4a90N4/DDGVkB/xL3UWQT4K8jQ8HHGBKyYxE3j/NzZ9q7gx3OwaIHs8jkaoqgmqv
	+ayZoSdXls7NHsXJ3eQTqVBg9gWrQLFh3X8ASJ4mPS0brCS1R+61/DuUXBss6qk7tnZWwHh8LLp
	m7+oX8s31EDfXeKG+/SPV75kNvFM56vI4BunPvCPEw33tXFz18s5uAkPq1ejGY/uvdbdrDActwt
	u9gSSRO613ux3zoM9BzO6fBtHAS7lRQvMKqGMt7dNxjVtPHieX5gSH/lkaW+0DUF9lgqbrouFM6
	T
X-Received: by 2002:a17:907:7248:b0:c25:8e53:45ca with SMTP id
 a640c23a62f3a-c25b3db6e81mr396140166b.21.1788246513480; Tue, 01 Sep 2026
 00:08:33 -0700 (PDT)
MIME-Version: 1.0
References: <20260804-mglru-fg-v1-0-4d8dad39dad6@tencent.com> <92DCEFFD13221261+20260828102344.1537874-1-zhaozhengzhuo@uniontech.com>
In-Reply-To: <92DCEFFD13221261+20260828102344.1537874-1-zhaozhengzhuo@uniontech.com>
From: Kairui Song <ryncsn@gmail.com>
Date: Tue, 1 Sep 2026 15:07:55 +0800
X-Gm-Features: AcwNN1UupyN0AD-fXq1_KY0r6IzjdHMuvQYcOkrxn4W7Ns9-T-rwHKEWwBepA6U
Message-ID: <CAMgjq7C68N-0iiMze4Lw4C44iiHBhbskXN_P1Qu-KhvpaoCwLg@mail.gmail.com>
Subject: Re: [PATCH RFC 00/15] mm/mglru: frequency guided promotion (MGLRU-FG)
 and flag cleanup
To: zhaozhengzhuo <zhaozhengzhuo@uniontech.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Andrew Morton <akpm@linux-foundation.org>, Johannes Weiner <hannes@cmpxchg.org>, 
	Muchun Song <muchun.song@linux.dev>, Qi Zheng <qi.zheng@linux.dev>, 
	Ying Huang <ying.huang@linux.alibaba.com>, Chris Li <chrisl@kernel.org>, 
	Baoquan He <baoquan.he@linux.dev>, Nico Pache <nico.pache@linux.dev>, 
	Usama Arif <usama.arif@linux.dev>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
	David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
	Wei Xu <weixugc@google.com>, Vlastimil Babka <vbabka@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
	Nhat Pham <nphamcs@gmail.com>, Youngjun Park <youngjun.park@lge.com>, Zi Yan <ziy@nvidia.com>, 
	Gregory Price <gourry@gourry.net>, "Matthew Wilcox (Oracle)" <willy@infradead.org>, 
	Baolin Wang <baolin.wang@linux.alibaba.com>, Ryan Roberts <ryan.roberts@arm.com>, 
	Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, Hugh Dickins <hughd@google.com>, 
	SeongJae Park <sj@kernel.org>, David Rientjes <rientjes@google.com>, Yu Zhao <yuzhao@google.com>, 
	Vernon Yang <vernon2gm@gmail.com>, Zicheng Wang <wangzicheng@honor.com>, 
	Chen Ridong <chenridong@xiaomi.com>, Tal Zussman <tz2294@columbia.edu>, cgroups@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 60FC440006
X-Stat-Signature: ec4g1jeoynpah4tfsk6thfmchfts983d
X-Rspam-User: 
X-HE-Tag: 1788246515-498033
X-HE-Meta: U2FsdGVkX1+Vd3lm5mZAeyaPsw+TEGpY7N7m9FONfsbXSYmwQK1WvndYdatUvoz2GbN4q8oEspumAdZxjS1HnBd8hhzXw/OdSck0MAYsWBX8MfIcJMKSt+/2MMifpOwM9uMWS2GxluSTRxqCfP2gJl618b/cntpge602gPBE3wHNM8HOrW14rotQGh0Kkc84zYvw32w/CDi1vylUv4a2zoRyoGR17rlgVeNkdZgN9Zyj0WvZXMlBiQcGbsWbPpSNj4mHW1HnWn/rHLKsRDjr3J7lKLZxOBdJaR8/RMaLh78g9sTTn06Fjbum3Eua39sniXgn8eMA6p6+/Ia7UQF4Uev0qx8Gvpxxx7EdVrZ5Xe55vcREHwoZe3fzBAf/OL28LXphDk4vG3jlGFlTQwFZ+6PweyNnI3wN7FPIsumPAPLmarnhmFTZyqjjIsniAhnpVhm6HuWJSZyEQk0WICnFj+BPQVsOvGjLgIeqQuC7NXCQqdyxLZ4+eV7bHnz4WTbCL6qcPmifndnBBOR9AvJVQn98ydXfO7c5RwUQ0tp2It3cjBb2ummD0PTSs3BVRfZUFr/IAM058mpkutUweFqRhdJmhd5dIV9sLewYKMuwPpNoiK00C+6MK/bZpDN2PGBB/6U1mWvsXoZ5I4BVE+kTa2tGKelmjnVl4WrfmLa8g9bU05MRU5cW2NbBhuEptBVd5sXFGeA9RorBPz3nHHhU9rAm+8gyf7E5E8S1CGZfZUy0aKfj8i1sQyXq0U+Abl9Ck8Q6cnN6Wsy3i9gzukY2QEItbkgOtP7Uin4vwTeBOquE72N0PSnAtgCAV0G7ItD1mFQ52EWZ+IF3rGrFsFnsArN4og6RE0XJ9gJzs3U1ZgRmGn68yU71BgQsNM8fagIHI1W3Q0uxzw/lCn8TFiui3JDUElMm3O0exioviWPEiWe6IF6pZTk/NsF4ZJQ9fyxcC7E4vRtD6dBzbpFl++F
 8UtCXmSz
 fVqVsImmo8rmjd0wHULKt3ouc2Tp5j/98O67DYONM/tQp+G1aM5opByiE5rA/RzIuruNPMX0e71VapWamEPU4+fMftMnKYytG/5b8zCtACFMSgJNGtDkJhzPk5XBb3DEJ58uvpRXAD7dXXRWcD+W2R2usIJ7CPV4mbhRSgoxEOGme9VYPAidPcxN+cinnGDk2Gjqf8lX5u0pE3O19iNfrmuf8SeN9eNTLGgr8dUD0YP51/v7yJQ77QDQnf7mFTlWbK2/KTTBB48hnkv00yMMVeF2JNkPxsXshELW5Hd0vqE+lzIFbE34sRORCDDPnkcNhHjUFYqd6YIq2kTRs1AoW2jACoi0UinX6rHAEfhd2NkyxvSalCGT020e1Z2Q60DtHym7Pr+/JJhi7zKkZoANia+RLrLtbwmAfl2yAJ6paQN8jbpqxginugV/bt34jS5y88B2fa32A7Yr45S68haOFjsOX6g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 28, 2026 at 6:26=E2=80=AFPM zhaozhengzhuo
<zhaozhengzhuo@uniontech.com> wrote:
>
> Hi Kairui,

Hi!

>
> Thanks for the MGLRU-FG series - it is a very interesting and
> well-written piece of work. I ported it locally and ran a subset of the
> benchmarks from your cover letter on our test VM. The results are
> positive and consistent with yours, so I wanted to share them as early
> feedback. I would be happy to test the next posted revision directly
> and provide a formal Tested-by tag then.

Thanks for the testing! Nice to see people testing and help verify the
performance, really good data. MGLRU-FG is supposed to be a generic
improvement based on better modeling and tracking of the access info
of folios, glad to see this can also be verified on your side. I'll
also try attach more test data in V2.

>
> Test environment
> ----------------
> - Host:    96 physical cores / 192 threads
> - Storage: VM images on a 4 TB Netac SATA SSD (no NVMe); VM disks
>            are virtio-backed image files on that SSD
> - VM:      96 vCPUs, 128 GiB RAM (KVM)
> - Baseline: mm-new @ a032d41a86cb
> - MGLRU-FG squashed into local commit 9fc6ff682d08
> - NOTE: the port additionally contains a local guard in
>   folio_inc_lru_refs() for non-LRU folios, so this is not an exact
>   bit-for-bit test of the posted series.
>
> 1. fio, Zipf 0.9 buffered 4 KiB random reads (all IO through the
>    page cache), 40 GiB total files, 16 jobs, 16 GiB memcg,
>    45 s ramp + 600 s run:
>
>                         run 1       run 2       run 3       median
>    CLRU                 797.64      796.74      800.21      797.64 MB/s
>    MGLRU before         766.88      273.75(*)   769.81      766.88 MB/s
>    MGLRU-FG             838.16      840.26      367.92(*)   838.16 MB/s
>
>    Median improvement over MGLRU before: +9.30% (cover letter: 11.1%).
>    The two marked runs entered an unexplained low-throughput state;
>    CLRU stayed at 797-800 MB/s, and a reboot restored MGLRU-before to
>    769.81 MB/s, so I kept the outliers visible rather than dropping
>    them. I am investigating whether this is related to MGLRU
>    history/state across hot switches.

Oh, usually I reboot the system rather than use runtime switch,
runtime switch is known to skew all the shadow and many other metrics
for MGLRU. But there is also another possibility: latency spikes in
MGLRU, e.g. aging, which we will fix later.

> 2. MongoDB 4.0.23 / YCSB 0.17.0 workload B
>    20 M records, 6 M operations, 48 threads, 16 GiB memcg, 8 GiB
>    WiredTiger cache:
>
>                         run 1       run 2       run 3       median
>    CLRU                 18695.72    18673.44    18438.05    18673.44 ops/=
s
>    MGLRU before         17517.69    16196.08    18180.28    17517.69 ops/=
s
>    MGLRU-FG             19871.70    19721.86    19321.00    19721.86 ops/=
s
>
>    MGLRU-FG improved median throughput by +12.58% (cover letter:
>    10.3%). Median read latency / p95 / p99 improved by 11.35% /
>    12.30% / 26.06%, respectively.
>    Caveat: the master DB was loaded with w=3D0 and stopped too soon, so
>    each run had about 22.7k READ NOT_FOUND results (~0.4% of reads).
>    Every variant was cloned from the same XFS reflink master, so I
>    think the relative result is still valid, but I will redo it with a
>    fully settled master.
>
> 3. SQLite hot lookup + cold grep stream (sqlite-grep test, 90,000 cold
>    files, 300 MiB memcg); median of run-medians for the hot lookup:
>
>    MGLRU before:         277.18 ms
>    MGLRU-FG:              13.74 ms   (-95.0%)
>
>    Eight of ten MGLRU-FG samples were about 13-14 ms, whereas most
>    MGLRU-before samples were 249-322 ms. Grep time itself changed by
>    only about +1%. Compared with MGLRU before, MGLRU-FG also reduced
>    file refaults by about 21%, direct scans by about 17.5%, and pgpgin
>    by about 15.1%. This was the clearest reproduction of the intended
>    protection against a one-shot cold stream evicting hot data.

Nice data from DB tests. I believe these gain are from the actual
imrpovement of LRU's ability to keeping the workingset and evict
less-frequently used folios.

> General observations
> --------------------
> - No memcg OOM kills, and no kernel BUG / Oops / Call Trace / panic in
>   dmesg across all completed runs.
> - Confirmed that folio_inc_lru_refs() is exercised at high frequency
>   under the fio workload.
> - make -j48 / 3 GiB memcg / disk-swap (CLRU side only) completed in
>   2h18m59.9s with 20.9M file refaults and 48.1M anon refaults, no OOM
>   kill. This VM builds about 13.4k objects and many modules, so its
>   absolute time is not comparable with the machine in the cover letter.
>   The before/after MGLRU sides are still running; I can send the
>   same-machine comparison separately.
>
> One thing I want to flag: my local port adds a guard in
> folio_inc_lru_refs() for non-LRU folios. I noticed that syzbot
> reported a WARNING in folio_inc_lru_refs() on this series
> ("!memcg && !mem_cgroup_disabled()" in the exit_mmap path). I am not
> sure whether the two are related, but if it helps, I can check whether
> my guard's trigger path matches that report.

It can encounter non-LRU folios, and raise an false warning. I'll
handle this better in V2. Non-LRU folios are totally fine and often
seen there, it just need to skip the gen part to avoid the WARN.

> Because this was a local port plus an additional guard, I am reporting
> these results without a Tested-by tag for now. I would be happy to test
> the next posted revision directly and provide a formal Tested-by then.
>
> Thanks and best regards,
> zhaozhengzhuo
> zhaozhengzhuo@uniontech.com

Thanks again! There are some work going on upstream, so I spent some
time on other items; I will post V2 Ccing you.

