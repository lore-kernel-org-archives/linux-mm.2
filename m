Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87D4606A31B
	for <linux-mm@archiver.kernel.org>; Fri, 23 Oct 2026 18:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=KaGdkJ2S
Received: by kanga.kvack.org (Postfix)
	id 06C056B0BCA; Fri, 23 Oct 2026 14:19:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 01D0F6B0BCC; Fri, 23 Oct 2026 14:19:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E4CC96B0BCD; Fri, 23 Oct 2026 14:19:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id BCDC16B0BCA
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 14:19:23 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 5C49AA67F3
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:19:23 +0000 (UTC)
X-FDA: 85354703406.02.467E70A
Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	by imf31.hostedemail.com (Postfix) with ESMTP id E2F0820006
	for <linux-mm@kvack.org>; Fri, 23 Oct 2026 18:19:21 +0000 (UTC)
Authentication-Results: imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KaGdkJ2S;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792779561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Sf63KFDDNNQERzVahv0eOgq9vdaVcq8l5ll+ubDdbTA=;
	b=cl029kTy5pyuoJ6MojOxzd91DBBcE2fVSZgHYNfmH+5kE2dVIO7U0+jSp0gkCzaJ/C2RbF
	StqS9T/qHF0Gcem8eQ50FocogtuXqdRlC76m+ClPw8DyTgEBIqYhdMc44cpfhxFpE3f/ek
	/i6OA6DX8JlYM4oCGTpmCViiib/rMss=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792779561;
	b=nuL52Pruw2atRUMeFKnaG+j0Ltzj7kf+XvOujakPeKLnY7J63KWhEq+r9/xGq7fAsxo5YJ
	wdufsbq7uPK82IZwdf5Gs7Xf9YkbxhW1zZ3gQeipq1VjVQBAiWxtFFL9758ls5mmbhrB5a
	NYNC6T7glLUwCUl8P1YXVdWh1z8Qq/Y=
ARC-Authentication-Results: i=2;
	imf31.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=KaGdkJ2S;
	spf=pass (imf31.hostedemail.com: domain of nphamcs@gmail.com designates 209.85.221.41 as permitted sender) smtp.mailfrom=nphamcs@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-48af4d4e61fso750772f8f.2
        for <linux-mm@kvack.org>; Fri, 23 Oct 2026 11:19:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792779560; cv=none;
        d=google.com; s=arc-20260327;
        b=JyosjWO+XYOuRYoeIIoRr4OipeK9ifOS0nLZqPh+QkxgUv4rfW1yMM/RX+DvCXxVMM
         Vu1adOee+K2f7LZjex54ye08CQOctBK7tfa5UTbDpvS4Q08aEtyeqEHvt4AkyG6zsgX/
         qTLCHbB5CyFTna2FHfVRR10GCNhO4uTRb2fF6hRfgLvUgUqZaYM7aXSmJc6QdHLUw1hh
         u8Jwn+JvkKZfxvZwzG/t2P/adu60UeqHOeZ7jNu1BHspGBkcR3QzYY2Sp3CrqXyW3ef5
         g7RtFARW55Qh857Vy3uZ7WZeTVQi/0gbqY7tfJTLzVprt5YRBCbMQlVDnnmiQKPgYwJV
         n7LQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Sf63KFDDNNQERzVahv0eOgq9vdaVcq8l5ll+ubDdbTA=;
        fh=qeqc7Q6crWjulrxRW0y2myZ/S3rsiDbcKKLDsbXyu18=;
        b=KMeOdRZXzD+oajMv/1AY6W3hrXdrCK47x3PIaL0QZ+TNpVD4N4Zr72HJrC3ka2Hyab
         gdrF6yDkwGJ73rZBiDyrijOW5q9KxfZijAbOIaDJ0hrUc6jMD7AJ/gNW4obpiqdfvH1R
         LVV4uob9peEB/3fB1kdjvHbZ+nlEpZNKaVWd4s59UYV2Qav8AmmKr8Uw6NdkEwMWwaBU
         cTF6VQNBY6BLvx0ODhWoDOqUfywsr0Gcei2VoP8IFeTvkcMgUmIrnHF+KepBQmenOD83
         ukFWR0IuBpDTG6pTf3WwrOMlq44Okj1QDubtYJuoy8khRzq8Wmu4yQjymYnszorVovj+
         kVxQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792779560; x=1793384360; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Sf63KFDDNNQERzVahv0eOgq9vdaVcq8l5ll+ubDdbTA=;
        b=KaGdkJ2SIQZW1m7Pw+mJRRvONXIfhEkTk6vNUG6+zE0oyJ41yB4ZYlrpq0TRty+BSJ
         HEHC8oSGrfUVvgShcpoG0vSuc6ZMM6lnxF+XO330Khfb8VUqE6SjX8mw0h+1xdL7FQGm
         pnslO9RbaHwcPOUqGjxhVSSLPiFcZ3T9t79R5FDoQzk7lBe46V5f4akj/cfIZwqKFcB4
         9w1yx8LdQX0SMP3COaF2ZdMUhXGqtVkuXD0jjrzV2pqYSLBwM7vhZNXDrtzpuFRf7cqT
         0Pq6KJ/PAwaMARfS0yToTYNQwbCi+NMzQPxUwka0Duv4J3dnC/aRVDtKROpv9d8d5Pis
         uNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792779560; x=1793384360;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Sf63KFDDNNQERzVahv0eOgq9vdaVcq8l5ll+ubDdbTA=;
        b=RUqrZp8k6wmssSl3nUgwuqV6iai+eZMioSREJayrvOnnGN/PdWysdxtP/G6BRrDbeE
         epxuKIfYITEbXXtfxqsc0vAAGGlQqOkDeLi3TQfgUbxswgBv5cpGt8GWp3AiBUGmqSVH
         C4oMDEMYG+mdWm0mg81wh9XpyZ2qf6ROuigxNirG1prQsd25uNT7GfyZoNRj/KPTP9UL
         ex5Qg2EwUlZCrtdKxL4hkTHS6ZgvYy+ybr7ZSQPjOA5LKzKXQUV7f/buDY7aUdb8p3sO
         tR7wX7ka2CQlYAry7e+BxEOovnyxOe65GRyRPxj1XTlTCiIyD07AoBa88uZ1lFNqELoP
         5czw==
X-Forwarded-Encrypted: i=1; AKwUvBy7f5hRyZUZk2MjVXabpyWfNce6//tUPjr+oo8lFvScKPJKveouqNvRcqucVn2mc63PtEp97U8cmA==@kvack.org
X-Gm-Message-State: AFq9FYKNaKg6KXhumlCASdRlkixuV6vijFfOciN1SusgETwfHN71FyVp
	usi53FcRMm3XN/7VSLa1J6qo6IKIShx1b4i1/cy8Ei3wG0njuRiTZW1V3V6YKgDzWbYOKJmOb2M
	TosHTRbEsnCesDCMr1oPEuspS0kHdwp0=
X-Gm-Gg: AYBFou3RM+zOzbXu4rjBVtfeNM/hFJBVVbE/TpUiOJBOl4RShWPDK6H/7CLjVeqwmOt
	VNDG9BEovDfbuMauHoiU+mxRt1J5CoUU/PCbHbk7IMFgb2LP5Vb43ddp7q9HkkFzSM5qVkGBSfT
	UjNpcePl1oD3wzxH57RgmG2os+xpClPtdylEcvV589Zz1Ggy7AdZyh8+qEe/9ejdCQoBRogWnXp
	iNtnNLPB+JOtlsSmg1XKN26XTUOmF0AjhMow2Tq+eSxP+pHQFOjTSvhvJlw5gfw3vtztcL56nr3
	t7mWv6dHhE6Cji4ST6V9Lk51m1ibGXDYiMaS2uY8diNIUPQTP4sWNqyb1dtLYAMEhFoRqSxBFR8
	z8khbarP0xKMp5wJx/VrGb8hi6dI3yKSWBH/V6sET/jm6JGIQ+Dnv9DcgZmTmtnioBc2ayw+9hZ
	2f77ZYA/rjzhtzwg6kSwhkiKKnnK7ejfqBotyGohuL0sIC6TKT3Lav
X-Received: by 2002:a05:6000:26d1:b0:48c:4444:f0a2 with SMTP id
 ffacd0b85a97d-48e38546c63mr4724859f8f.7.1792779559823; Fri, 23 Oct 2026
 11:19:19 -0700 (PDT)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <20261016120927.3191690-1-hongfengchen@xiaomi.com>
 <CAKEwX=ONniSwdiZAe_8NT5XwVj=Mmc-WJs_rWE4Y5snjFg2=Eg@mail.gmail.com> <20261023123736.1542117-1-chenhongfeng0212@163.com>
In-Reply-To: <20261023123736.1542117-1-chenhongfeng0212@163.com>
From: Nhat Pham <nphamcs@gmail.com>
Date: Fri, 23 Oct 2026 11:19:08 -0700
X-Gm-Features: AclHuK8IXUKXOT1G5BawvIMJ1TanzNZCOYP2ZLn7pIObqIp0SWbrNFngRQ39xBY
Message-ID: <CAKEwX=M4jTnxmq6cj115Gw4u5jdY7Ex65jPtVTEopW70jGzfuQ@mail.gmail.com>
Subject: Re: [RFC PATCH v4 0/2] mm/zsmalloc: defer object free to per-cpu batches
To: Hongfeng Chen <chenhongfeng0212@163.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Barry Song <baohua@kernel.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, Yosry Ahmed <yosry@kernel.org>, 
	Wenchao Hao <haowenchao@xiaomi.com>, Wenchao Hao <haowenchao22@gmail.com>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-block@vger.kernel.org, 
	Hongfeng Chen <hongfengchen@xiaomi.com>, Hongfeng Chen <chenhongfeng0212@gmail.com>, 
	Shakeel Butt <shakeel.butt@linux.dev>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E2F0820006
X-Stat-Signature: qowynrkbp993wtayc4ske7ezpszecbbk
X-Rspam-User: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS autolearn=no autolearn_force=no version=4.0.1
X-HE-Tag: 1792779561-15549
X-HE-Meta: U2FsdGVkX1+dE9yESqA0q439rjFBVL0nA0POGyR9vXysg3PQkB2xx2v5X3ZPBA2K3aBgve7Ja+W5Y6z5dutEYSVU9aFLzPQBwjk249EX9kbloZFoghTK1uxU1p2i5xfCaWi91YxlL6wG2yzuFgDGFMBiqgE6Dma63fr7K9MW0G6yR5sW7tSgkHAA+yK7gYo+k6D+F4aVhFuudBK1/dUti0raqR2HgkRyCMiP2eG54D7p95A4c1kLi2l6X3d6ZjtWue2bMi3p7854cg2qMf1UhEJozL6bMjhxnWqi37TF8Z98RKMcixvGe7F0Ks/CH1/mJ8VFxWSZpS5vfGbsvGxxnwaakLUjD1ZQ8leNgy/GYYrt1CDuilT0WZjlpKDgkls1K+7GVcjA9ZRzvpZLlBjs6iVF5moSKlxddJuiPmEMBMIGvW0EkEHcJ9Je4Cdf6srTk75nI65YVlhNvGtrSU/j1372ontLsEmsVlJ5ee3/LJjaSv24xIXg1D+BWsizraHmyKbdGyzzEuHBzgXcnN7xAq3xr7sSu/48QirfIPUeJNEf6XBcFklyGaZsm1py1Dgqo+Fj3AmyvznX44s0CmVsBL1Uv7pxZMOhwHMPetqQ7ovSRH9Hb/w1KFfT5eumC2HHuNted46p8yP44YAX0/18EZ64Zg07qL9SSk1Go/0qolYvolnHomeJAOh2qQmlRLihBgh7XU7xfWc0HoYRqkZ+qTsDOChi+MqGgQeAB9rpypq61iqJ5t2smO4JUi3/cLnt2EoXwXe9qkf3QQmzXmdFberHCl8xGalksYXTWI9GyOuptiq4REwdHj+lkxWkeH2+Bp3aOUl5ArZna/F4IR0BOaHex8pcSzt0RIiBA0YOijdyS/P5EWLbmMj2X+GmRzz6cWtv+lg1thOMU4/XnknSEASCjisg3S9suPxubL1CmN74cGrVYVtUw0xIAn03PifqCe6yG5fgn8vT3t2SPxB
 er71wwc3
 cBA0HH9yX2hzQm0iSSmoY7D9CKJv6XmIYP98DPivTq/RPsDDhXu5IEFPeZ1Q2ZXy/6l7E6fJx3YJOfHr64UQEDQ5gGomJkQheopZxxYi5oeuNELqAE+mJXmKFJi44y9deyEY1c9jYHu+7cUWOr5de9WWIWt2QZPZe12msYxofRkvtQsSlgg78obiJjX3VXmGL8HHH323a5VCuRg/5HytyKxUhmB1eVs2ZCFx55JXKeJny7V2GOesL8H3yBy9UrylQ3ZHKSK/Tc2gkN2a3fQmlrgPIUTTo0DZgwcZCEOrHepF7OodBE4u28E/nP9UfwG2FK9YmxF/L9rDeIwHUh4XZQ/nmQSROtg5iC4S36UZBuI5UX+g5GRnqX5ZpIlFrRAqCa0u4r5XESTekldTLsfIYCwU3qgeDduaxmksK784GZ8u5Dkzv1Cji9mGCalEfqpGENkaS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Oct 23, 2026 at 5:39=E2=80=AFAM Hongfeng Chen <chenhongfeng0212@163=
.com> wrote:
>
> Hi Nhat,
>
> On Fri, Oct 16, 2026 at 9:09 AM Nhat Pham <nphamcs@gmail.com> wrote:
> > 1. Would memory freeing be slowed down?
>
> I sampled pool->pages_allocated every 1 ms, and measured the time from
> the start of munmap() until the zspages are freed. Three cases are
> tested: 1 process x 256MB, 1 process x 1024MB, and 4 processes x
> 256MB. The results are as follows:
>
>   workload                  base      with-patch
>   1 process, 256 MB         14 ms     9 ms
>   1 process, 1024 MB        51 ms     31 ms
>   4 processes, 256 MB       45 ms     24 ms
>
> Memory freeing didn't get slower and it actually got faster.

Neat! Thanks for double checking! I assume this is because we're doing
memory reclamation in parallel with the extra kworker thread?

Which brings me to the next point:

>
> > 2. Would this introduce isolation issues, especially when this work is
> > not properly accounted?
>
> Yes. The drain runs in an unbound kworker in the root cgroup, so its
> cost is not charged to the killed tenant, and it may take CPU time
> from other tenants. I'd appreciate any suggestions on a clean way to
> handle this.

I don't have a good solution either... This has been a blocker for
other work offloading idea too.

+Shakeel, who might have some ideas on this.

But before we do this:

>
> > Another thing I wonder is, how much of this slowed down is because of
> > zsmalloc's own inefficiency, and how much is because we just have a
> > larger logical footprint
>
> Mostly zsmalloc. I kept the footprint the same (1 GB paged out to zram,
> then munmap()) and only made zs_free() do nothing:

Is there any more juice we can squeeze from zsmalloc in that case?

It would be nice if you can perf zsmalloc freeing. And yeah, maybe we
can't optimize any further, but let's eliminate that first before we
rely on offloading.

