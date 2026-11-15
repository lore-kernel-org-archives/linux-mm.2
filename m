Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4AD98606A31D
	for <linux-mm@archiver.kernel.org>; Sun, 15 Nov 2026 13:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=Yx1X2X4o
Received: by kanga.kvack.org (Postfix)
	id 497706B00EF; Sun, 15 Nov 2026 08:38:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 448416B05B0; Sun, 15 Nov 2026 08:38:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 337756B05B1; Sun, 15 Nov 2026 08:38:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 0948C6B00EF
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 08:38:22 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 6F1701C3DD7
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:38:21 +0000 (UTC)
X-FDA: 85437457602.28.13A3301
Received: from mail-lf1-f54.google.com (mail-lf1-f54.google.com [209.85.167.54])
	by imf28.hostedemail.com (Postfix) with ESMTP id 8EEE8C0006
	for <linux-mm@kvack.org>; Sun, 15 Nov 2026 13:38:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Yx1X2X4o;
	spf=pass (imf28.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1794749899;
	b=Lek0pUn6Sa9VpSphv9EKcOyki1hxVFRvQp7mNSLRkd11MMEWEtlVQBNb8gbOgfY5Rf5gTS
	3Qgy6eA+CdBahlOSOpyOlaY1d0Vk/sdyCn//eCdiJAhPOpm9HL6W02ZjH5l5vUxBg60BZi
	UaatMzhek5uyLTIWRF6DMrGVHlrUUZs=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=Yx1X2X4o;
	spf=pass (imf28.hostedemail.com: domain of lin2530632123@gmail.com designates 209.85.167.54 as permitted sender) smtp.mailfrom=lin2530632123@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794749899;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
	b=OLNsA/Du1JS0sKvjKs7Zh/wfynL5egrO1i/0NClSKUKYtzvtB0ocywoRHoSXM5f8CLyvQ7
	FLIVaENy/FuhYgjisW3fTrEpmlLZ7PcmMhhqJSqyZQ6V2jNa7TwsudG3jKKw/neusd0Ozo
	Wcvmsyf0J2Wy/Xu/jFtLkjxMPpPnceM=
Received: by mail-lf1-f54.google.com with SMTP id 2adb3069b0e04-5c14a204305so2422206e87.3
        for <linux-mm@kvack.org>; Sun, 15 Nov 2026 05:38:19 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794749898; cv=none;
        d=google.com; s=arc-20260327;
        b=F0pKipQIsFSWQlHa8pU7GnCSSoNrAcHOo4c7kbWZWA1xsUwbeZN7/GcckGffih68nE
         Yi7S5Fc6Vt3ID6KicN3gcV6jtSjq6cffploZU/nurbS8HpUdDufbMFK60WjyObd1voZK
         Oi3CerNwAY2x/py4rCKdUVavDJzTmdaf4xJaMGBsFWjuUyUpB5ovkrFYiPVkCGtC+81I
         OEXVLbj2Cxbnrd6Oxye1H1FXmEBKRTpqv+C57LeBWYe8iT1dhgk9fIM2q7L2DtlCDgOy
         pBSt/x6vcpiNeq16tqoWXQoNVD674q/tFGL3tk+wKByWI5nK+KiEMug56Hh1EOm8CaSP
         d12g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
        fh=VR/8GcbOC7heISmgGzAlNrJOYEAL7H9h+gXe+dU5iVQ=;
        b=oRm1QcbxAHOumihis5nJEzbvUud5hDJEpRcayajc7LWVKZwkOZb2qLd76FZ+X7rO/T
         oeGL/VA5SLvVfqMafx40jJH8WPixUuwboaJC7ZRPnmF1M46K59Vw73bn3TyjMAxhRvHD
         ndvFg8qUBmjbdLVw3NFldAWh2dcuu9kAHdQrm4FkT0kgRdLZnbOFdheC27NozZZFjMXR
         DWs72NXNWYIv8smKa+UfcbCtuwE6T8Rj6bvMNql69ipOc4XTA9fgoPVKWOYEPeBx1sA6
         DkzoIvZkxLjKhQH8QTzQb13l9rwGrh//PoK6zocoRAwkwIB9l6nnNhIck6UuXIGN3U/Y
         UQow==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794749898; x=1795354698; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
        b=Yx1X2X4o5p/HywUXlb2idlaLzJG3yvwdp8YwxPysZ7txT2010X/zPBkUgC+QEmncCh
         tuIZu9o7uZ/PPfU3kO43rz5v9t41+G4r6dCajBpi+BlVvH7ACLyMICudKQAFIK6+zeVe
         G52V7dBe790UxcPnbh2ZDrY++IAOjdeUYAdstMzrSqRC9WVvKmqGeaZL00HGs/gSf3ED
         3Lw7QMcGCPt+ffA8zPmJ17ujYxwzRVK+5Imbn/6lUMwEyDZv2yqSDShx/ryGUpMqAZc9
         E+H7TXdvAB4Xzzc9nITjHXvHlVW21mA3ZD74m2O1KOOnJh7v9qjVsSUy4pW4qmGKrNBu
         PRLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794749898; x=1795354698;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=wc0p1pQYXQO+NKwG/7057xQ5jQrT9EGibnAMu4kS01M=;
        b=tdgF/suCHvvWxeaWX4IDRdrX0zcvu8bK9LDmf9qdMXRMLdZAPqTU6uFq4Gkfbg6mVV
         CuQFHNAqU30ESDjlsnIW603u0WlRFDV0FXVsI4Wo053K0aE82K2oNqeOVB8GJVY03gSp
         6dUAzvpJiadLwwG3LizuthGZWOyZzy8Fnlddtgly9XNEVnl4Ry6NF82mkY2jYVWJcFQG
         XqagzrLEUZMl0BrUHBJptgfA03qb5BgMoGtQYzmaj1cGPu2rEjOFPlPIzORQxpe90ZUJ
         NLttNRaVoT+ckoW2UiXmQHc1vXyDmwUQ1KzkQoRp3wKdffdrLEn3PlVWXox2MCjNWxoK
         1Z4g==
X-Forwarded-Encrypted: i=1; AL+hErGVcVKHjdRRp5NKovFhFHSL2njbT7rE5jq/akfdUjdrvQJ4wBhTp1WBWzvgs0zXHGY8m9hbO3r30w==@kvack.org
X-Gm-Message-State: APuU4Z/U9rzFf9YJbZ6Zvxaxppb8BXDhCakdPnRQRA/3PcRmWesAPLO3
	e4CHzzPl+tcUTZ0swdA86FGjKFtMDCfJJ0JNkhOt8RU/o3dUgCZdl+wT8lFDnxO87UFyMVlfoQH
	D/swj6hUQ3Jm56k7954Q6cNdbzYcsV5g=
X-Gm-Gg: AYBFou1WW3JTR85HS0yKYqL0oTWuupf/4ZZ4yELFtNlGz5KWtlLzU0aeKHwFyarxMJt
	0yJuIKIrjIWtQ6DNpeEAgwp8wsTVPXyaaECiGV/wONry/oIDEa6sUgJSY8C8yLKEMXFdQf/hdtS
	vlzaGZ1jkchzGDgGC1Uacl4Kwb+eCVJi4ieXKIyIRdEHWSlKGKXKoDrlnkPxV43KYY+PMe414ZH
	n97mEe3Lu4DZvDeWNAjWgNR5EihGTqKeT64AqnvMMoT1Pp1y7Miitsu3HRhod5KLzZqwvvslWdd
	aCpI94beY82XRwLitekq669ksbpyMp0pveshdx4C7b/aLQSo45A+lqRFY07S44x8diQ8lPT/VOw
	kA2Fj8nD9+fWDO1AXkmaHAlcXI1LbUo4ThsxN89L42VsX58vxLP3ckWDj/BHgKb/XC/fO0ltr1t
	eBPGum84C3tFZqs/wRBRRdV33fpDCO
X-Received: by 2002:a05:6512:3f27:b0:5c0:d9e2:f66 with SMTP id
 2adb3069b0e04-5c1709d6adfmr2815178e87.20.1794749897634; Sun, 15 Nov 2026
 05:38:17 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20260817131843.45121-1-husong@kylinos.cn> <CAO9r8zPqJncFKQbF3tGe1d4sg-4dLQ3dQRGze_vab26wWrXTqA@mail.gmail.com>
 <179438454803.6.16655549133383619919.zswap-rstat-counters@gmail.com> <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com>
In-Reply-To: <CAJnrk1YzYswBKv5F3=FF_o_4Pywgw0ifLq0tXYSWO7TARnFRJQ@mail.gmail.com>
From: Chengfeng Lin <lin2530632123@gmail.com>
Date: Sun, 15 Nov 2026 21:38:06 +0800
X-Gm-Features: AclHuK-5ywgI9_mymL8VnEcpC74I2pRU7d5bhSxPyILgrbhzzhuo7cVYo0AazQ4
Message-ID: <CANGjgdnTjbou-XFqip7B_cGjrfZzZpan3dFuAk1-rU3bJOu8NA@mail.gmail.com>
Subject: Re: [PATCH] mm: memcg: use ratelimited stats flush in obj_cgroup_may_zswap()
To: Joanne Koong <joannelkoong@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Shakeel Butt <shakeel.butt@linux.dev>, 
	Johannes Weiner <hannes@cmpxchg.org>, Song Hu <husong@kylinos.cn>, 
	Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, cgroups@vger.kernel.org, 
	linux-kernel@vger.kernel.org, Nhat Pham <nphamcs@gmail.com>, 
	Chengming Zhou <chengming.zhou@linux.dev>, yunzhao@cloudflare.com
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 6e6uxtyiqd6oni3h4ob7b63z79kjetqf
X-Rspamd-Queue-Id: 8EEE8C0006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1794749899-328128
X-HE-Meta: U2FsdGVkX1/hxL3I6m66oyiAR6Wr1uZCsUSUXCwvxzSieuoqy07UF9X06Q3NbV+c0tV3r6829IcaW/AuTZD0Kvf9xy94MXOl0Lqw/sbGQu1KXpwgaK/8FU43WPO/tDfhlDxUPucL13nkUVNUkvWCe3HOKFCKVDoCb3GP01C4k3aqJnpJfQeZlhI+Pl1cMDi3uRXaMfHx4TuHDkyv3QxQQMWYmVOa6cZkw8f6rg5xKaDmMRrz7wrQ16raQPPUAxSjJnJxmvcYKAdVsd1CXbZq98L2hhU14CKJ/CxGFwe6/LxpXrSKjQ+ztGBgEd3LFCfMIMnABLNMOJGKZ67FkLNIhzM/MykOIqWSWZkydrNKouxc1CsaASg7UYldjBw0EjZgy3gjDOooS0dEKnKFFVOR13AII9fnoPn29uh5uLe5BSFJE4L3lr8TWpxtGU/yynyI5MkLpHRUz7JKWSgTdNxS3NW+0oAjl/mtjnAdF548rAKhRGZePiasSLBBFaSGIV++TepQi7IbfIBOqkUm0K2MI0UKjCYcFq/eL3TGMuhh8BZTVmrbdY8Kb1LxPSBOXDl6aHnBLVWQLL9aLxGRUYHPcCteQvclhru5uDynnEo7nyLnxoAMxX+236XMCIMIe6sSzok3CIupN7vO3CsvXkAma0kIkDqLON9csw7YB77VfvpNpVjIwAOn5gDSuUep+CoB4m1ZGTDPiQBLmc+NEvaqa0WZiBHorNeVUXVOsNMYupP+ybGWMOjgFDLGgAveNqAUWdElsqkPl50HphJEVSpIhEP6KFEBmbdl4I3EpD3XoNYkPjkYlkCpGEbLs5AN77OiT9k6T/JI7p1LFp3FkbjSYlVd81LUEbFAThp4UqMw5jKwMVi2I09RMz3Ji1/KpWABSOyNVcNMmpZVzeJuu6SNlXF9ZggbnAjDqFOGNBDM+92KxU7cyDa7J3+z649fV4mIhgX8uwDin0bStSXr+l2
 9+V4Rf/C
 IUhkT/4b4TNmwg17VoqdIZmotIjCuWs36XwtQysHgfFvJvuTaWi5V+gnxleaJnOu9eXv2sCuwKhvQ2l/UfWNm6PjzcBrpTb7OOxcIJ+VFvteQtcoux+Fz0LlmOMSGgUSCWUgnEefuHWNaiPbxnAEc/QkrFXFIk0suiPdyieqYgHhMVleziFfPV//0BNEAYGIdeXJl+v4zzaZ3ix6Wb/EMdn1et5/1F8JfGILutcNtcilc8z+YWBDl99KqIyuCQ3dy6h/neZiANb9mW6GQVIVdFa8eIPFfpZaDLpVz79ymaX8JWzTTN69WcdLEPXfEeb5TkH7jVKCs3p5id5zaWhVMmW8ScYa504tV9Z/XTJhfxCRCku8xAkUgDgDPaP5G3ug/eHXDQFClIcQaAFB3mwOr9aASoaivxMCTdMtzoc8tS36EryuXjwjinuRDD2Q3P0X2qKmN
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi Joanne,

I tested the non-forced flush in our setup. It delivered PAGEOUT CPU
savings similar to those of the hierarchical per-CPU counter variant.

The only change in the non-forced variant was:

    __mem_cgroup_flush_stats(memcg, true);
    -> mem_cgroup_flush_stats(memcg);

Both variants used the same MM base, 2967f3ccdb5f, and the unchanged
reproducers attached to my previous mail: 32 MiB with one worker, and
256 MiB with eight workers. The finite memory.zswap.max remained 64 MiB;
compressed occupancy was about 18.75 MiB in the larger test, below the cap.
The hardware was the same i7-12700KF with microcode 0x3e.

I ran five separate boots: baseline, non-forced, baseline, counters,
baseline. Each boot had two warmups and nine measured program runs per
condition, including an unlimited control. Reductions below are relative
to the mean of each variant's two adjacent baselines:

Finite-limit PAGEOUT CPU   Non-forced             Counter variant
1 worker / 32 MiB          12.640 ms (-45.72%)     13.276 ms (-43.04%)
8 workers / 256 MiB       202.784 ms (-84.03%)    207.455 ms (-83.55%)

These are summed worker CPU times, not elapsed times. Whole-program CPU
reductions (non-forced / counters) were 22.57% / 20.97% with one worker
and 61.82% / 59.97% with eight.
The counter variant is the same hierarchical per-CPU adaptation tested in
my previous mail; it retains the existing rstat updates.

PAGEOUT CVs (non-forced / counters) were 4.65% / 4.33% with one worker
and 2.91% / 9.26% with eight. The maximum absolute PAGEOUT baseline drift
in these finite-limit comparisons was 1.69%. The small mean differences
do not establish that one variant is faster.

Separate instrumented admission runs also confirmed that non-forced does
not mean no flush: the limit check performed 53 / 818 actual rstat flushes
for one / eight workers, versus 8192 / 65536 with forced flushing and zero
with counters, while successful stores remained 8192 / 65536.

So the simpler change appears sufficient for the main benefit in this
below-cap workload.

Thanks,
Chengfeng

