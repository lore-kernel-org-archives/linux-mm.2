Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6D3B9C531F9
	for <linux-mm@archiver.kernel.org>; Fri, 24 Jul 2026 18:41:05 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F6226B0092; Fri, 24 Jul 2026 14:41:04 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CDB56B0095; Fri, 24 Jul 2026 14:41:04 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E4546B0096; Fri, 24 Jul 2026 14:41:04 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 09A126B0092
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 14:41:04 -0400 (EDT)
Received: from smtpin11.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 856ACA0114
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:41:03 +0000 (UTC)
X-FDA: 85024537206.11.F26A09F
Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	by imf09.hostedemail.com (Postfix) with ESMTP id 64A3114000C
	for <linux-mm@kvack.org>; Fri, 24 Jul 2026 18:41:01 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VexYpNmY;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784918461;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t1qXGBunFwcH0vasyDsq+hrXxoqTsrx29FgrXHzj3JQ=;
	b=n+j5WG8pe3Nbmj6EtTRv/vyFWLe4b2uo46NJgzGmlG/po5x0gvcgHaqG5qALxGVyU86rKv
	p3hxyulTGOsUZ1ltsDfJ1n4zrf59jBFeJMvw79NGoLN9oLZJOVwkILHY2XdQYazomh6ScB
	ePlOeG9bPy6kpM7vLIwbSGRu3Ch5S/o=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=VexYpNmY;
	dmarc=pass (policy=none) header.from=cmpxchg.org;
	spf=pass (imf09.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.175 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784918461;
	b=ub0q4TLSBNjj1ylHUmzSJ2ywkiwf9vWNx5aQ7oYYFYlCFmgZuwRreRlQoTuB0u+Ldo9zBV
	H46kf+XyJmClNlyRtUpdYsh5pqzW5mxJQKs+Z5D6L4+j1eJ7RVJhL8yzMdj/+fgB086QKt
	HtKptf7xbfeKifZhPwpPVEKqaK69S+k=
Received: by mail-qt1-f175.google.com with SMTP id d75a77b69052e-52192509869so5578791cf.1
        for <linux-mm@kvack.org>; Fri, 24 Jul 2026 11:41:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1784918460; x=1785523260; darn=kvack.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=t1qXGBunFwcH0vasyDsq+hrXxoqTsrx29FgrXHzj3JQ=;
        b=VexYpNmYM24ORJ8iJVrLnvP7+PPrJPL02ORL+QLG+j50I/0tqNI6aOJeMBd1uM4/Yb
         OBTAfrXFIoBoXbH+wYD6oAd2eJOqrUXJvCuI/sbIdt/fPkLCX/te5hsuQXVYYFkx7V7r
         pOi+9673u11fAbr42L+iRfLj9kYxFZyxFx8LFXWWLZIoMyZesxQ4HoKBnpf3qoYv46D0
         0T03sGozAaQpMMe9/yVwUKTwRnwzozhe1ENJWSUp37HWyyr+Yz17kFyUHTQD3cbYK51o
         QW7LXQ5fQBq3pEXc9U5RUMAgxfTg7wUwP/t0Q169u2kDixyYcecoKq+pCHRzkL1Orztb
         BOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784918460; x=1785523260;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=t1qXGBunFwcH0vasyDsq+hrXxoqTsrx29FgrXHzj3JQ=;
        b=mxx3YAIyJMDLL4FHATmfge/LrpNjxBaWhZjCVNm92GaH/1DarjVGUJMcG1WjY4Hpqi
         QDji0quopvVcRGUfnISqiWrNFwfl+8wr1QrJ1Y14mBpvj6Jm688RwJ3OyqFK4vnlbBcx
         u5BLeJcfXJG8b3GKG0SZY3ogdYNlQTfmxtLUYiVXN2Bk3reCjhHYyFtNTyB0rqyHj4A1
         EqYih5j2Aiw2mEYyjSr2Vv+xxk5Bo42gNwrOWzJoyG1XQXkICEsSfNdrh5w4iyZWGR6i
         e3bvPujoYjubdMXaCTAfUMVVbyC+QZnqlco1RaTZ70cJz2jKHGLvm8o1SoW/guNKqEfx
         5uiA==
X-Forwarded-Encrypted: i=1; AHgh+Rqd9C5ezN351hQYlscdR4kYilvILP9iKLRCNrt1dFcDfydMNI1GtOp1Prw8VHpiqGWaLChazHUW1w==@kvack.org
X-Gm-Message-State: AOJu0YyCg3LZG5IrFM7grlOTjNGK+koIQoX1NU+HAYpwNiCA1/J/Bbed
	7fHhhxTCWziYp4/c/IT4mtBL+0JHm18S5DadNK7JWKsoRy09B09CYV0XGExSruUstB0=
X-Gm-Gg: AR+sD10sWTJGIq8mNEeRY1aqSZUvmtNKeoCx7MbS34cOoZMfI0QLnPJEcTr7+4tcKfj
	Hr3RhrNX7j+hO3x38D1JP0Lj3y7Dz4l6JEbXxa5n8ZxxHIU+JXqqvuXyvn2Y5k3sJBAmmyb2oww
	opOPG9fAhU7eb45+bdQJzGl9PrdfWugKoQ3lP4vVFUjjPDQkGWHlKMas9aLx3PCDIIePWbxo7wi
	O5DlDVOYuTWVurYV4NmL7757QlmDbwYMUUwZdl0rjheMFRGI3O8UKNFNKLeA3GncOyzZKqDNtSb
	kSkDDtDmCUV8AZcwco7t5qzmk8tRIYuOT2hrX+Hdi7i449QRvJvGYmgn4fjaOXk18jqyMac480o
	DxXqKxq2bTN86dw4VkGwPVOKYshiEBoSXOlqXRehiMltkvjoqyysJKHOK4EH+lFVi7IUH0AQ/BO
	90
X-Received: by 2002:a05:622a:c08:b0:51b:f40b:2fac with SMTP id d75a77b69052e-5283df4fea9mr83122981cf.50.1784918460467;
        Fri, 24 Jul 2026 11:41:00 -0700 (PDT)
Received: from localhost ([2603:7001:f100:500:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-907e854e497sm4176346d6.11.2026.07.24.11.40.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 11:40:59 -0700 (PDT)
Date: Fri, 24 Jul 2026 14:40:59 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Hao Jia <jiahao.kernel@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, akpm@linux-foundation.org,
	tj@kernel.org, shakeel.butt@linux.dev, mhocko@kernel.org,
	mkoutny@suse.com, nphamcs@gmail.com, chengming.zhou@linux.dev,
	muchun.song@linux.dev, roman.gushchin@linux.dev, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, linux-doc@vger.kernel.org,
	Hao Jia <jiahao1@lixiang.com>
Subject: Re: [PATCH v2 2/2] mm/zswap: Support batch writeback in
 shrink_memcg()
Message-ID: <amOxu56ibbhKP8qJ@cmpxchg.org>
References: <20260717085151.22822-1-jiahao.kernel@gmail.com>
 <20260717085151.22822-3-jiahao.kernel@gmail.com>
 <amF7_GB5Rl6OJmt4@cmpxchg.org>
 <CAO9r8zPaUPddYoLz8o+g+xkb-zdkfyB+LqaDOrkzqFSePEV-xA@mail.gmail.com>
 <amIdU1lFxqxTI3Gc@cmpxchg.org>
 <CAO9r8zPepaekOgaDaVBWyB_F05Ezvz+AJZ8M5+NGQ4BmiJNBkQ@mail.gmail.com>
 <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <d8de419d-0077-c47c-a5f1-37c229a853ed@gmail.com>
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 64A3114000C
X-Rspam-User: 
X-Stat-Signature: 471d51i1f4x48uuoib1kxajwtp1quk41
X-HE-Tag: 1784918461-306189
X-HE-Meta: U2FsdGVkX1+UMt1wAUOVItqHNMrgtGFveOv+WTj3Q4l5K9l8Kc6+tHNC9TsstoL1p/DJ4uqQOd/4jziR3mLJK+/zNev9wU1FSvPHaOLQIEg/QKzatMTwIQYrb7L7V8RgeizWbIb9gy54JHOELlqy5AlGuySG+cvV3zkrcAtWSInjZCoTy6muwTGOAQgK2SL5zKd0EdD/D5LgGN6WftPjWGeU26OhTAx0EOJzX4kDQqX7nVD9QwdcvolRGFtyR7H6BDXIDib+Hm0Amxnwvr5/46zauv6FLW8AKAneMAKYAWxSXu6W1ya6zfkpM7gn3ghiKfLncXPeatqQ9xJ19YEfPSBnXj/8vuCtJVsbFME4mVUesvNl6txjSyJEzghbbJmgkSxg4GS/yufaLWqRe56kyQijWBu3+3chOvs/CQbgezcvYgn658m+rIgFPh7reeAdsZXdyigwS8BnXyEZ7iqKypvaRyTm4TfSprAsyGKdV1Y26EnznjopTP0g1eiD2dBP0FCRtTIXepDf5Otz5sJLMsduc3g8f7F2S9QEmCtIkoLt2+m7jQv0LP8iaep7VqE9F7SmQCtQIlV+ugt0rw6cd4mjfoze/9jKSdxd2Scaqh8oDkhBRSHGNH3gT2KHgsRE2WdnNG6YA6WCfm+gASzBIM3Ij6YB9/f9dXE0BqFWF198/ySa0POdJ75ExEqHsCZRsm32KLOndVU974eR49BI9D4ouRsda7O1MaK/4lS59iOkf2qJDwWbuUalgoWixKeQEkLzJNWv/WyqeMRTXGWI5DBaN1G43sH5+gPx7iEt78P5lgxswIPyzwwrrjV42BxCcoj9qQnSCWShgRChkfaAExBfVYzobRJeLKAhR5I2dc7qDtL2Af9x+Zndc/wsJOqMFYYjaoAgyLwET1fereO2rWnP5yNKcYl/4AOCYzQG+I2TYb4Ige2N4M2m41QrOb07sVFQyv1CmJOa3t40rZx
 AKX8c+47
 tok1P1QV95BMgtWsN1ik3zIn7hmrD6ceCUjnv8ofm3e3+C4OdKtKZDakAAMa4fDAzdHRrmxx/rPbTgNQheA1Abk5pDMyCI9dK4SJzl6HwIAm+6pjCZk69EWwKq0TYBkC5tLTWcGX3GqzNdu7e41Z07kqX+d7mZSR7Tz4rx+7aBDowSREQgYd0BFiJ96gxl0xhuyMyN9aQTZqxjbN3odi/pvcS6g5rz8wTCvOkK/DCtOzY9i0swjJD9UkUuBkY40yb21i+h+Kbd9mmp6VIwF02UZAeO9Xj6DdeWP1prON7LaDOgEPE/lLIrX49IzaVdc1I/wdiI96oXNmEfQ8s8+Rtitz1vmQcrblFiXhLw24rYBNhVKImh4eq0FoveQLgbPVuWIhI+P41lYIvGf0SbffmBTyYlgdIcYOg3A0KueKWNa7yT9n4p8kdxth2qHneB7vHfBUFDWncHUpliXl+20+zUC33Q37SHiN7L/B0Sr7QCPqzAuZtUvz2c+RAM8gm2sukX60SPznZ+YYho9p1Wy5+aAa4uR9wq/TcItFzPF8hN9/kKtu0IanuuCQJ8QrcFS0v5O2xx6P1XrFzXOM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Jul 24, 2026 at 06:20:50PM +0800, Hao Jia wrote:
> 
> 
> On 2026/7/24 00:39, Yosry Ahmed wrote:
> > On Thu, Jul 23, 2026 at 6:55 AM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >>
> >> On Wed, Jul 22, 2026 at 09:52:18PM -0700, Yosry Ahmed wrote:
> >>> On Wed, Jul 22, 2026 at 7:27 PM Johannes Weiner <hannes@cmpxchg.org> wrote:
> >>>>
> >>>> On Fri, Jul 17, 2026 at 04:51:51PM +0800, Hao Jia wrote:
> >>>>> @@ -1369,7 +1402,7 @@ static void shrink_worker(struct work_struct *w)
> >>>>>                        goto resched;
> >>>>>                }
> >>>>>
> >>>>> -             ret = shrink_memcg(memcg);
> >>>>> +             ret = shrink_memcg(memcg, NR_ZSWAP_WB_BATCH);
> >>>>>                /* drop the extra reference */
> >>>>>                mem_cgroup_put(memcg);
> >>>>>
> >>>>> @@ -1493,7 +1526,7 @@ bool zswap_store(struct folio *folio)
> >>>>>        objcg = get_obj_cgroup_from_folio(folio);
> >>>>>        if (objcg && !obj_cgroup_may_zswap(objcg)) {
> >>>>>                memcg = get_mem_cgroup_from_objcg(objcg);
> >>>>> -             if (shrink_memcg(memcg)) {
> >>>>> +             if (shrink_memcg(memcg, 1)) {
> >>>>
> >>>> Why 64 for the global limit but only 1 for the cgroup limit? That
> >>>> seems arbitrary in multiple ways.
> >>>
> >>> I suggested that we keep the writeback here without batching and do
> >>> that change separately, mainly out of abundance of caution as
> >>> writeback is done synchronously here so the extra latency could be
> >>> problematic. I think we probably want to measure the performance
> >>> impact of that separately.
> >>>
> >>> That being said, this path is potentially too expensive anyway due to
> >>> the flush, but I would rather we do some basic measurements before
> >>> batching here.
> >>>
> >>> What do you think?
> >>
> >> It's not an unknown, right? We know this works for direct reclaimers,
> >> cgroup limit reclaim e.g., and what the latency implications are.
> >>
> >> Because of how reclaim works, we also know it'll call zswap_store() in
> >> batches of SWAP_CLUSTER_MAX. If we don't batch here, they're likely to
> >> each call shrink_memcg() once we're at the limit - while still risking
> >> rejections due to compressibility differences.
> >>
> >> My worry is that if we start with an inconsistency, we'll be stuck
> >> with it for a long time.
> >>
> >> I'd rather start with the clean, consistent version. Dial it back only
> >> if we have data to justfiy the complication that we can put into a
> >> comment and the changelog that outlines why exactly it's different.
> > 
> > I am fine with doing that and basically always using NR_ZSWAP_WB_BATCH
> > as the batch size in shrink_memcg(), but I would be more comfortable
> > if we did some sanity testing.
> > 
> > Hao, would you be able to do some smoke testing with NR_ZSWAP_WB_BATCH
> > used for all paths, and memory.zswap.max set in a way that induces
> > writeback? You can probably set memory.zswap.max to 1% of total memory
> > instead of the global pool limit and rerun the same test.
> 
> Building on Test Case 2, I set zswap.max=320M (~1% of total system 
> memory) and updated both invocation paths of shrink_memcg() to process 
> batches of 32 or 64. The resulting benchmark data is shown below.
> (Note: Test Case 2 also sets max_pool_percent=1.)
> 
>                        baseline-cgroup   batch-all-32-cgroup 
> batch-all-64-cgroup
> shrink_worker wakeups        7,238             766               367
> shrink_memcg calls      12,059,142       1,961,194           983,878
> written_back                28,277         301,157           327,997
> zswap_store calls         1,349,572       1,168,190         1,114,549
>    store succeeded            492,861         521,315           459,246
>    store rejected             856,712         646,875           655,303
>    store reject rate            ~63%           ~55%              ~58%
> pool_limit_hit              510,130          50,096            57,715
> pswpout                     884,989         948,032           983,300
> pswpin                    1,251,268       1,638,668         1,878,453

Thanks for testing both!

Looks like 32 shows the better matching with the reclaim batches than
64: it writes back less and swaps in less, while still having the
improved rejection rate. It even rejects slightly less than 64, but
that might be noise? Absolute stores win handily in any case - not
sure if that's meaningful in your test design.

