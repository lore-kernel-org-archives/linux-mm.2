Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 20399FF8850
	for <linux-mm@archiver.kernel.org>; Mon, 27 Apr 2026 03:10:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6233A6B0005; Sun, 26 Apr 2026 23:10:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5D3386B0088; Sun, 26 Apr 2026 23:10:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4C2446B008A; Sun, 26 Apr 2026 23:10:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 3418A6B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 23:10:43 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B5AC21406D5
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:10:42 +0000 (UTC)
X-FDA: 84702858324.17.077A72A
Received: from mail-yx1-f43.google.com (mail-yx1-f43.google.com [74.125.224.43])
	by imf23.hostedemail.com (Postfix) with ESMTP id C7982140003
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 03:10:40 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bQk+Cqcr;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777259440;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KM+OtwEwd97Lcv7g7hL+Q7aqQp8IkPF4SNqpVzFRcpI=;
	b=zC9pLRyNVhaHfi8aMyOKoXLsqlLs7mS5pZWySgiCZm9jIJg8Nsa32bo1MlkyM1/askCwqx
	5D+DiABUfQAFCy+koECg2W6JT+JSvpp7mQrtfK9U0yQ2IEP1SZdthlyi+UNgYQumqZonXn
	MJw8ydEPw7IFGQePLjw+KIKn0Fj5IgU=
ARC-Authentication-Results: i=2;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=bQk+Cqcr;
	spf=pass (imf23.hostedemail.com: domain of haowenchao22@gmail.com designates 74.125.224.43 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1")
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777259440; a=rsa-sha256;
	cv=pass;
	b=ypHzVjVznt5W5JW+PWbCjwu4f+IDIwuYYfeQYEnPo0CsIK+/LvBOvkoIQwVCAyAAZWwVCk
	oZ+e2MvM5E3531DQmtAyG8a2TrTKW8wMuhfcz1v/+KoIrpXUFGaNzQ0oO5/9xHpsYZoRg6
	THpby0yLr7l6Z3C8s4BevjT2zaPSGxs=
Received: by mail-yx1-f43.google.com with SMTP id 956f58d0204a3-651b4d09141so12796646d50.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 20:10:40 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777259440; cv=none;
        d=google.com; s=arc-20240605;
        b=DCCmFid7rU8B9IhR272Thp4gaiiDTXDmlm1sY5RZsIWKso0yCjOVRVis00818MnWiu
         9ptip9Fur/MWOezSOGytykemWs5XGjmW3HBYHsgIlIlN4v8rjyULRmB3N7iH5+M6Wmub
         WkiTHJH82TapTT76ESr3/DWkQcu/TKBDHTKyvTXfsTr5pXD8TKyp1i3aWff+r8S3CFp5
         KeDXGtC1j1OIh7T9ZQ3DoUMRXpc6HlqrUnEOLVAWbQc5ep2iMwnd0Dehs8TlAhxwmy58
         u8aR+eP6yrYGVFX7mjcsIQze6nWDvku+MRqVyvypRSjZAKR3qYAmTQM2VuwLhn+Lf87T
         3yBg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KM+OtwEwd97Lcv7g7hL+Q7aqQp8IkPF4SNqpVzFRcpI=;
        fh=dn/gYQJkggnvx2r7qK1TdfPIJStT2w3ROPUbDEc91Jw=;
        b=Tce6ZFpuMw9hna0A0yWMFLjESDE1geepix1F5EZxLLFH3ie8lLrZNSnYMbTQXPltYw
         Qvu+zoHC8FHt2G9r3S2XuNbBv2/qPNkcCczU65/txCk779oX7xUt2UeosU3bGIciO6qX
         6XLS9tdeTMyyZ94f3p/4b0YID7tSC3BL/0OcBR1o+YeMywbrb9SPtrnCcGxKF9hRiP3X
         lD6qy4POcwF66bOfCSsNcSvUXf7Kq5hTVBp8oY1mSYmOt+9F5Me5f2bjsjnK5OGbqj1l
         EmPhE8Ct1WZegvFs1akfTc02V6KvY+rYkAHjKN2tJRAdNzJwIvqtDzE5ZaqmfYj6dzGj
         gtyA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777259440; x=1777864240; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KM+OtwEwd97Lcv7g7hL+Q7aqQp8IkPF4SNqpVzFRcpI=;
        b=bQk+CqcrvQNGH5JzGgh+YkbViI7SbU0aqhuWU5xRhPkAytzhfqBwyuQ6t0OigXkbJr
         JCqxBc3hwSI14M3MOe+EUbwQOD6UB71oL2YVUT8tuJ59HIEQqcsq2kjKpNoT6NNl1AiF
         bnjrhGvCbsVtXQ1I6Pio7cmLPDZxX/jFwBvLv/pXIryIXqVM8l0KuPySofKmBleNgMay
         5lOhD2O04iUmMlvF2Mr922gFhjOjJsmOOsrgDLXiWxKpgW1N3Qe7EeWo4E76rtXIXW2O
         dyoXDJr8qbh6cbTuvMscjZRwHli/OsYfXJS37bFqyrPVRgs3eBLgbY4qmY90xB2ygp0F
         M8hg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777259440; x=1777864240;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KM+OtwEwd97Lcv7g7hL+Q7aqQp8IkPF4SNqpVzFRcpI=;
        b=fuAnxgDzhRWbPTHtDz8S/yZP+RkUMoXXqYBMWOGh/vMqm4LhAaWPIa2zs8o8A9QA62
         SmMEkdI1F9CR3fj00u8l/UtsOcHi+sYUFwbmx4B8btDmcepS8UNga4BOkVK8Xo9KlPrq
         eZbTd3CjpMyE4terW4+fpmuNdkBs35RKwTuRbKX4YKBOZgIL25uKgQsmohAoTzI/lZKa
         KCspSpcWcexWa3ezryW9vFQ+WpMz3zY0lGbEKtQHzNbwLTtTe+XIj2alF46mj8874mUd
         XQmVgk5ciZnwbuVUXmkPLS2LkK2XPuovZzmjfInhqt7x+Fi3HZqnEsYouBzzIG2KX7hI
         4Pjw==
X-Forwarded-Encrypted: i=1; AFNElJ/THs7KucZ4viLbFqBh/DrLCBQYWgqNiBj/19/hCzVhBI3zz2hUfH8JnjJm/mHB+yawTtFN4Vcm9w==@kvack.org
X-Gm-Message-State: AOJu0Yy6xlSX5hphQognHCjj3Kb83R0Hrru7nSEnZWh6amt/u3Wf8yq4
	ceIX7P6wIyj+P9QxBM/voJ3FNWDDto0vcbxfo0FDHR7QDMhE37wOhYfPNa20ZcyRsN9m9INWt/b
	tK0W5YKKmHABUhv9BQUKr5dn41OpfKbk=
X-Gm-Gg: AeBDieuCEZy+M/Uo3fLQ4TcGSoNxgRv4qE2EJJ4SuLd0/X9v+wG/Aqhdj6oQ+6lq5vJ
	CxJxp2VErTxyfiatVs48iOrnEXi7O5nxDk210JVo8oIqkvW9uOh6XAVLD3nqBuXMRDWceib0YSV
	pP6FzKY/aWxQE1swqqIJbxlrmnkwsEwSoqyTm2Op9s9OKZBb2+SNnub7z51yTqdATW3btNNxp6f
	NgM8qk+G3GYHVxGNWRHuwBiTS5iRa7m2hm61dTkRh3G9mcDuRO/WhE0wiZsj/WTO1asGSjf+5gR
	45sxvl4xDX4lYNVDmXg=
X-Received: by 2002:a05:690e:b81:b0:651:c221:9649 with SMTP id
 956f58d0204a3-65311aa1c92mr26554121d50.19.1777259439835; Sun, 26 Apr 2026
 20:10:39 -0700 (PDT)
MIME-Version: 1.0
References: <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <20260426085017.166935-1-xueyuan.chen21@gmail.com>
In-Reply-To: <20260426085017.166935-1-xueyuan.chen21@gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Mon, 27 Apr 2026 11:10:28 +0800
X-Gm-Features: AQROBzB9YuhfVPY5XmYPGQmtYvK6q1PqYnlzHDncpFTPb3tZG54wX9J7FqwHpiI
Message-ID: <CAOptpSNgA74W4SL-AEJNk4UVrabvaP58cs25qwYa+N-6C9OVEg@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Xueyuan Chen <xueyuan.chen21@gmail.com>
Cc: akpm@linux-foundation.org, chengming.zhou@linux.dev, axboe@kernel.dk, 
	hannes@cmpxchg.org, minchan@kernel.org, nphamcs@gmail.com, 
	senozhatsky@chromium.org, yosry@kernel.org, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, baohua@kernel.org, 
	haowenchao@xiaomi.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: C7982140003
X-Stat-Signature: djnxqfhzr48xm5sdp9f7afrc7tx4az65
X-HE-Tag: 1777259440-833788
X-HE-Meta: U2FsdGVkX1/01XRnB3WZH7nqtSwCxC8qOKSRgpeLvX4BsQ0ai2/Cn8WfGDxoPSoN/rZsyQq3liC6KBkc4t5xIK7mWAAreDr/rsOw6MjUf8atYNjPQdhgRXqcXFafnQebBwe/HeDxYMoUE/y8A8o1fwlvlulNMBwmZFcZ+MtL/TN9ickrEKt/mKu7D1ajaiCzxc3Ni+LTaprTTn49gUQOiVADvxiBrs/Wj0wy0DZVjoDScVnsRL2k0YEy/6eeokXjAv01tJ5UOQSfmnZ8H/Y4VCGXZrpP0K1B3rhqHwcp/+YzHyO+PBT3Mxna5jJ/yeSiZ7nutt9sqCU9I71EGM7ShWmRpdmo/TADEct7Z0B6lUR60/PuDpkXdJnYsg2qZ8AjbEFA1pLNcKw40EQxnr+7oNMrs3OauVjJLvjY5kujSZ3z3ntjo4e/6pX/YQkLxoA2Tq1pdhe9hJP+9oS2haskmEr+inIkCI5hSVQo/aaD7fhJhFA2OC5fFGNKGDZzr7C9NiSlYip4qiPKuLomxViUnEV+scQWTAFq1cwz0NY5WV7YC5BKwxn2smIilUFsT05aIglwR3dEA46nYvWB1DIfn3Dmmwj2wpeo2eRyBsPFFlORsDtbd9ahgXY7poHwlLZlnFWHdBg6W+vMq6NtfZyG1WTcaJ84l59COpg0ZZLz2C0qPgObLDc3RqVSkGXRfHXwVg9kKgMN3hjhq0xwu7Gm8g30WyNnkzQXI8207C5zjv45/RJKOQLgejHzI1NJzpLO4hj09hdfSw+dJ4rSLJ2Urx5ZJmeWxxUYdLmH+g5yPPJ4bHBcwWXYPvTCpsQh28Lvd42sxihS8+wTNvtVN5wefVrCZHgB+URg1KEqgCEsSV/JhPp0jpF/zKVyyLeLk8wNI9ZgmpVR5GDakESOkk6+NNMlgghpAQArWjENUniuvKm3pRRNiSPPMcJKjOBgXIQRGZRQNBiWORfgIgvZI+n
 b2Bo1f7M
 TcQ1lDzDeZV7rcJqbeGdk2/4T8853tRi4qlGKxrc4QoJ+z5n0/AoIdjD3XS1dELqRdukaTaSpSpBu0C8yj3wcNxB+UyB5Sxp/EU+ySH9xPm9JmmnP3Cvr6kluBTd9hqlCOZ8NwuTxC+Zwe17bk9CbvLeW+4xSSZVoymB6xbcEuxxWRZXlEQN1tzmxaCgB10/HOGLv2wfFWofaGAuNvxmj1ZrpbDDbHyvU3A4ktgC7Ue/DAT7534aP2fkTeTVL7KrNEWpEp4Hj4uK7S06m5OXTroWUycg95bS+A9NnLJEZAiJi2GBavOguA8e5Jz3db80NqmLm3wEgvT3Q7h0qx0GxVG6BvHvpI4rpPWda2WN12kLKh/i6oSp9kTCHd/dXe2r7pibMPgqZedJ7gRJOBX4PmjBr8b/kGSSQiQMtcy6StFhvB5YqUQi7Wku9io8rWQ7EbfvBDRk8eZUZRq+Zm69I1BnWBHqWel1nwNw6A4Ui0lEq+X4GILyPR9b6Iizac1plbCzDd5aPUviW8ppca7gXosnNOoHJG0MmKhgH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, Apr 26, 2026 at 4:50=E2=80=AFPM Xueyuan Chen <xueyuan.chen21@gmail.=
com> wrote:
>
>
> On Sun, Apr 26, 2026 at 12:13:02PM +0800, Wenchao Hao wrote:
>
> [...]
>
> >2. Per-cpu deferred free with lockless buffer swap
> >
> >Defer zs_free() to per-cpu dynamically-allocated buffers (~2048 entries)=
.
> >Enqueue: one array write + WRITE_ONCE under preempt_disable =E2=80=94 no=
 lock,
> >no atomic. When buffers full, schedule a drain worker; overflow falls ba=
ck
> >to sync zs_free().
> >
> >Drain: allocate a fresh buffer, swap it in, reset count. Since
> >the producer stops writing at count=3D=3DSIZE, the handoff is
> >race-free without any lock.
> >
> >Pseudo-code:
> >
> >    /* enqueue - hot path */
> >    def =3D get_cpu_ptr(pool->deferred);
> >    if (def->count < SIZE) {
> >        def->handles[def->count] =3D handle;
> >        WRITE_ONCE(def->count, def->count + 1);
> >        if (def->count =3D=3D SIZE)
> >            schedule_work(&pool->drain_work);
> >    } else {
> >        zs_free(pool, handle);  /* fallback */
> >    }
> >    put_cpu_ptr(pool->deferred);
> >
> >    /* drain - worker */
> >    for_each_possible_cpu(cpu) {
> >        def =3D per_cpu_ptr(pool->deferred, cpu);
> >        if (def->count < SIZE)
> >            continue;
> >        new_buf =3D kvmalloc_array(SIZE, sizeof(long));
> >        old_buf =3D def->handles;
> >        old_count =3D def->count;
> >        def->handles =3D new_buf;
> >        WRITE_ONCE(def->count, 0);
> >        /* now drain old_buf[0..old_count-1] */
> >        ...
> >        kvfree(old_buf);
> >    }
> >
>
> Hi Wenchao,
>
> I suspect there is a memory ordering issue here:
>
> def->handles =3D new_buf;
> WRITE_ONCE(def->count, 0);
>
> Since there are no explicit memory barriers, we cannot guarantee the
> order of these stores. If def->count is cleared to 0 first, an enqueue
> might end up operating on the old_buf.
>
> This race condition is more likely to be triggered when the size is
> smaller. Perhaps we should consider using smp_store_release() to enforce
> the ordering?
>

Hi Xueyuan,

Good catch! You are right =E2=80=94 there is a memory ordering issue betwee=
n
the handles pointer swap and the count reset.

I'll fix this in the next version by using smp_store_release() /
smp_load_acquire() pairs:

    /* drain - worker */
    def->handles =3D new_buf;
    smp_store_release(&def->count, 0);

    /* enqueue - producer */
    count =3D smp_load_acquire(&def->count);
    if (count < SIZE) {
        def->handles[count] =3D handle;
        smp_store_release(&def->count, count + 1);
    }

This ensures the producer always observes the new handles pointer
before it sees count reset to 0. Will include this fix when posting
the formal patch series.

Thanks,
Wenchao

> Thanks
> Xueyuan

