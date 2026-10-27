Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A73BC606A31A
	for <linux-mm@archiver.kernel.org>; Tue, 27 Oct 2026 22:58:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=aKj1KIBK
Received: by kanga.kvack.org (Postfix)
	id 9118E6B0913; Tue, 27 Oct 2026 18:58:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8C1D36B0915; Tue, 27 Oct 2026 18:58:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 78F2D6B0916; Tue, 27 Oct 2026 18:58:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 4DFC46B0913
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 18:58:00 -0400 (EDT)
Received: from smtpin07.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A147080B3B
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:57:59 +0000 (UTC)
X-FDA: 85369920678.07.2B56814
Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	by imf30.hostedemail.com (Postfix) with ESMTP id B41E88000C
	for <linux-mm@kvack.org>; Tue, 27 Oct 2026 22:57:57 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aKj1KIBK;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793141877;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
	b=gS+AMbVC1cTMQlhBRV4NazLzIsVz7rpU2UdiMZ5empl/a4TtpwolgWE5ZilcPzmOHXNXtQ
	amgH6QmGIb87we27nnPzkQIiLbyy6eAwLI10qewEzXg9jL/XmnVFpdyPWjmej2iD+O1OBD
	rw5fFC7yjNbXZhnODVliuPsT+wC9G+E=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=aKj1KIBK;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf30.hostedemail.com: domain of joannelkoong@gmail.com designates 209.85.221.49 as permitted sender) smtp.mailfrom=joannelkoong@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793141877;
	b=ISuqJN4rJ+eo0s5+DIi/ph4esTS2/VEtyBq19tUsRqUjw6na7BcNNqGTm+XQIfEnlhEefF
	LuliPx0toeub5UkpgiWxSatgOLOoWRxfmpMz2E75myUBJ+CjF4l1y5u3A4LO0p7lOFiLzZ
	sZDibKIKQ2ZfZkqWAbuYjlOlPrnIjEY=
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-48dfdd0678dso242656f8f.0
        for <linux-mm@kvack.org>; Tue, 27 Oct 2026 15:57:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793141876; cv=none;
        d=google.com; s=arc-20260327;
        b=mLTpCJRTlob223qX4sJcnylBkQF3Ozce8BtFp4GQUBSA6AdYCHa2NiO0H2CUDa7zTU
         pqTqbXh9M+G96BDrWSecJsJZITfHAPQpVuzdVLVQMJBL7SvbeK1n3uT0k82c96eRZ690
         tELPnJYWTbTqomwyGCGrW71yv/TGmoHt3xOmiiMj+9NEGRxNgunxED6pQxL29tUS1fT8
         JAZ3eNduPSIvm4DWSUWeeS9/SS2ZlR3U9makkCEG7N9Xm1JHczaewBmRHWBPNXNqLXeA
         L7sNOdKJtT7T46CzZfy2p5DZ+qaoczWCrcHy3Ez9NZIYhinW6uymdEpFYx7emaKh80sS
         zbrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
        fh=OCzXJUWurm15rwhFV/vOI3OH0r0bbl10CBwyU+2Jjg0=;
        b=kML3uG4BinYX2Ael8jiihtwEwGwj0VVctpPTxtyj8hVSdoaOytFnpC7UJYVkxtiOqg
         6kRkiHSvuf8lQWwhfMu+dEsvOfaD5atMD6X2JxX3nH+QX4ze5X6TlNF7ujLOMlzPwKIX
         UDZ3OCLdE7pN6q/+Y43BGk4vuav38ve/kJnpkS1wUfvA2IXUz1J+9K/Rf4+2mk1gN+C2
         GrIHfA6bgObYct23XfFzsjswV04fBpC2ym/Cvz+lhghC14bKEhZS0gbdj5t2Ufhmr8s1
         JyGV9eqW6UT+r9VEdYvyGSbn6ySSPmkqaIbyi8qoxs/Lt43qLbET+i1ZwAHXuNvr76nP
         IgFg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793141876; x=1793746676; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
        b=aKj1KIBKPBPKHpejdk2xnf37gbf5Qrpvu0G5X06PbWdyLrclpxFyp6xqxm9IkeJuDe
         kQJAwJNh8au+10AuAbJXdgtEqTDX+OQKnYy0XZDnU3iLyFyNrL//Jtt+8LvZhA6eeYMc
         rE/qA4AQufdXooLp5E/aE38PNNyUAmigg+6NCCE/8L8DW+JGW9npjW5BOLYsnQSQiw8C
         8WKpGyzG0ED0kubbf260s/KoFOdP1olAkt/iFk3LhTkU3uZaKafZtK6CyP1Eyc1Bjdnq
         VE0pmMgYvNtHZGNjLsXBA7+V8MvT9vzFdq57MDVRq+9SKxpPnNW1vDl+6Su80LXg+hLZ
         /XiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793141876; x=1793746676;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=72+WHJwwpogSBR2Mae06gxZf+v4TqJlIK48WM/9xNMc=;
        b=K341vzlGhyxy0aFkPV0VnshFhnOpAV9KSHlpYz1GFtaxxh1LIwKoP2dX62vRGFPLNJ
         fJGpJdKgEqOePKHkTVkCJIEeebVEScN8Q7p8FMFyHEykhjnUI0lQzFl7DG2PBO1PI5cE
         j/sJzz+RLACG0PlY/szcy8nZJcK4EtAeLlNIQUVaJll19WOzhBBueIcXeGc4jTQMIWvX
         uxe0Meu1bZPU3cTONRWXImckcJqIczPaOuRmSK0iT0me2yh2Sw4U+LKXJCOsQW3VImdS
         OE6PIdb5stmTzWPs5gTEzeXuVM3KkFv2PpAxmNzfOw9F8zcjO3dehJTDc6Nyxd/vGTXc
         eAGg==
X-Forwarded-Encrypted: i=1; AKwUvBwjievnovk2VkwHavQGE9xoXGwF5TW/g+Y1rgXm5Wp2JdchcoiOQ5Ts6UQ/OWW4wqqyAxKY3zd4Fg==@kvack.org
X-Gm-Message-State: AFq9FYKDwYoZc8IJy9Fo770aFK9WBZMtIUH30x5oGgg+Vi4sIC4j7aLE
	wj+7IMunwBtCqaX/reLPyHvqFZ7gcu2nOGttU4txiZWwNLGS4/Lmyj6oY6qA9Sdu9skfJwMjPL5
	QEz4uMK9yyXvx2LXy3JbrTPA+7Xcg0Ew=
X-Gm-Gg: AYBFou3qlbb+H1C3Xy7CPbu148wLRWX2LNXJQ7O+kWgVJJ+FZmywte5u6jcNaaMc9e7
	JjSWQPDm9sYVZhKuXarddkqHLnDeuSNwRDJ1/osVuB89RnFn9ywKbdn13hvgx3mM+yHGMDWiC+v
	QqWSvI1KBR6XKefQ39zgOI1+JJvY5mCazNrKm8anL7P0X7SBUSyFUIGzVrnq5GtY5ATlZl5mJri
	zICkTBra9VL6Bqq+JK8eqHV8M9osM5fAKRG9/y2zcf2lbH0961m4D2TL7ZZJP7+U/L+0ztZYIry
	KdvUPEmkOjfmbNQ0piVQy2GVRtNX82w5WbG0AUaVVOSkGywASdIfesFSyBfU34L/7gpLoGbho58
	ZwuwnXNG4RRozvF4tvadn++rX0yqUk85s1JFBUUPOilWpUQDRzzJBcQA+FY2Ayll1pfL/WtPLdU
	5WN09+RMSOcN64dTvNoe3k6b5ni3zs4bRLPPbflPk=
X-Received: by 2002:a05:6000:15d0:b0:48e:1d87:f179 with SMTP id
 ffacd0b85a97d-48e5d2ee6c4mr1432863f8f.25.1793141876177; Tue, 27 Oct 2026
 15:57:56 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261023195417.1391216-1-joannelkoong@gmail.com> <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
In-Reply-To: <20261023155407.0b519a3da7313137a0276119@linux-foundation.org>
From: Joanne Koong <joannelkoong@gmail.com>
Date: Tue, 27 Oct 2026 15:57:43 -0700
X-Gm-Features: AclHuK_5vNE3lHaWIxr_pi4E7Lc0-zQAS_H7nZdBiLEpaJxcfp23GnfYndfnZ-E
Message-ID: <CAJnrk1Z-zzKL9Jebk4XMpfOBtyArppGPTv3__GTbCZXGiEJjOQ@mail.gmail.com>
Subject: Re: [PATCH v3 0/2] memcg: reduce cacheline contention from lruvec stat
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Shakeel Butt <shakeel.butt@linux.dev>, Yosry Ahmed <yosry@kernel.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
	cgroups@vger.kernel.org, linux-mm@kvack.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B41E88000C
X-Stat-Signature: dqjgwbrfguqx96qncdyfjqdm7crmnt5f
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1793141877-710394
X-HE-Meta: U2FsdGVkX1+xWl4WXZtX4UNYz63MOwGMzkuZ/jRggjbEIIMqDtO01YptThFQP3AUveOlIp4rZ/ngpuE/DoiRfn5uu0W6rQI1S82jlT+MHMApqSQjT0zO0IzUG/tCA91kV6TNWpKEdwO+u2hnYPbwrXJlYA+1W2cFEPxa5aoZklpfMcbU5cxMiHnK+XbFe7K2z2l/5Pn1mZHxv4goexaCiG1xKbK4Irt3BA5o9146t/suZGQcqYyOujX6wHhi22DLHIJLXNCUv6vrmsT6lDBepeFgbLVBVrud//0S1N4404gewbzcAM30DsMmsi9ntcEbDDMyExVK27KWPUcifvXGclCKXAYWT6QCFajBQm+6GbcxxdNtA3KhdFvAWvAA41uJiZ/8DXLZpDFd8vJK8oIZszkBq0tsuJPdEI1K/50ZslBNNwo7X1rwoGDZiGAmz4TOFCHUFgIhqlMm5fKpKh8cMP5S4mr/MCUVG5jUR6AX4cH6yGijR8pmUeTVs8rSkOoJbc3teQYR9PmbgjDyESymdTCMReqwNj8vqL0fRjp5YS/TjhI76K1JAvcWQPyhYCSSVv++mKZImkCIwwjrB4oZ4bSr2pezb6fG5CYJc1ExAcYSu6DYQpkJYlsZZOPjdgNwoFdKu77o3c4hqOlx4iGGg7tCVV1HV0uRZ33mFpjUuitn8t75l3lfwtczsk1xdjOw1eahRmcw2Bk7QYAqjjpwJ0InXqsuPgrqq3y7X/uKgddAAJ4N7DJIn3qgNRYNTI+5eMSgs4aYVq17lvwgpBLM8nXZd0u56u94p0oyg0IJo/W/DzfuUnfQZdSkim/FSgJXFx/5JwIvgX2VTtpZe+xws7O6+tl7m/WpVeXt+6nveppj91iGU0UxhlcTjbivX8iQfozzmLz2kX4mTOV45fNPodzsm2X+yl9OfwFpmTmEML+HBzj1G3MtNAYkR/o/ybWuNHuBbPCSyxziqHYXIWh
 y2p3uftm
 CZL/Mix3fZRv2RnCdVp9j1fOD/hl8ssrnUK1lGdO/6fKokNPm04f/WBiWWuc+gdyx/N3efMtpwnYSoDTLuQI6blS/zTNrfjqShhW3vJCU8oqTK7BxlfhN9X4wzWJ67AGqOIvuF2l0b5qrjRAdfgBcK+mVBVFFROWXaSEwiPWMmzX71JGrDhs3BfY0825kwbzSDgZgVkAQUX4Kquf6LovlFD9Xbljj23m/2gP9xHSQeHHxOSwvNxhj0RXT4qoXurmDVlGvExTX0dTmkKXmqQJqS+hh2wWPPNhn82tH62lDEVhXPHg3Pq1ufl8kOcn7okiYz0y5nsiKaBr2E+TY3+S7GCJjAcvm9PXWW4tUSDY26MBMXrykVXSYrHlvAIP1KNYQRmAt+GzRALuJARSG9rrBoYBY6E/FGI4tevEwb5rQIL2hF2UFTNblSquIut9K2R88oW1vp1Sbdy9h6qO32UZRKg00U8JZswRF/r9Y2YOARcj7zYE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 3:54=E2=80=AFPM Andrew Morton <akpm@linux-foundatio=
n.org> wrote:
>
> On Fri, 23 Oct 2026 12:54:15 -0700 Joanne Koong <joannelkoong@gmail.com> =
wrote:
>
> > Memcg lruvec stat updates read fields of struct mem_cgroup_per_node and=
 struct
> > lruvec that can share a 128-byte cacheline pair with lines the lru_lock=
 holder
> > writes constantly (the LRU list heads, lru_lock or lru_zone_size[]), de=
pending
> > on where struct mem_cgroup_per_node lands in its slab. On CPUs that do =
spatial
> > prefetching (eg Intel CPUs), this makes the stat updates contend with t=
he
> > lru_lock holder.
> >
> > Patch 1 rearranges struct mem_cgroup_per_node so that its read-mostly l=
ine is
> > paired with a cold line, and patch 2 makes the folio and kmem stat upda=
tes use
> > the memcg and node they already know instead of going through the lruve=
c,
> > whose pgdat field shares a cacheline pair with lru_lock or lru_zone_siz=
e[].
> >
> > Results on a 2-socket Skylake (80 CPUs), average pages per second for
> > threads faulting in and freeing memory in a single memcg:
> >
> >          base     patch 1   patch 1+2
> > shmem, 20 threads  4.74M    5.59M     5.77M
> > shmem, 80 threads  7.94M    8.66M     8.82M
> > anon,  20 threads  3.04M    3.08M     3.10M
>
> Thanks.  A local AI review pointed out a thing:
>
>   One limitation worth mentioning in the [1/2] changelog: the slab
>   uses SLAB_HWCACHE_ALIGN, which need not align each object to a
>   128-byte boundary.  If an object starts 64 bytes into such a pair,
>   its first line can still be paired with the end of the preceding
>   object rather than its own cold line.  This isn't a correctness
>   issue, and the measured Skylake improvement may well be real, but the
>   layout doesn't guarantee that every read-mostly line pairs with a
>   cold line.

Hi Andrew,

Thanks for taking a look at this series!

The AI review's commentary is correct but it doesn't seem to matter in
practice. In the cases where the read-mostly line isn't paired with
the cold line, it's paired with the line that holds the end of
lru_zone_size[] and the reclaim iterator, which are also rarely
written outside of reclaim so it doesn't see much contention. In my
benchmarking runs, the memcgs are freshly created and contain a mix of
both alignments. Before the changes in this series, the per-memcg
throughput was bimodal depending on the alignment, but afterwards, the
throughput is uniform across memcgs.

Here's an updated version of the "Fix this by moving the memcg_pn_cold
group..." paragraph in patch 1 that mentions this:

Fix this by moving the memcg_pn_cold group, which is only touched when
the memcg is reparented or freed, right after memcg_pn_read_mostly.
SLAB_HWCACHE_ALIGN only aligns objects to a cacheline, and the struct
is 576 bytes, so depending on where an object lands, its read-mostly
cacheline is now paired either with its cold cacheline or with the last
cacheline of the preceding object, which holds the end of
lru_zone_size[] and the reclaim iterator. Both are rarely written
outside of reclaim, so either way the read-mostly cacheline is no
longer paired with the LRU list heads.

Would you be able to swap it in or would you prefer that I send a v4?

Thanks,
Joanne

