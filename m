Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 51FBEC55ABA
	for <linux-mm@archiver.kernel.org>; Wed,  5 Aug 2026 10:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4F2796B0098; Wed,  5 Aug 2026 06:34:48 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CA956B009B; Wed,  5 Aug 2026 06:34:48 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3E0C16B009D; Wed,  5 Aug 2026 06:34:48 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1B4C86B0098
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 06:34:48 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A6D9A140433
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:34:47 +0000 (UTC)
X-FDA: 85066857414.27.4EDCF7F
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf16.hostedemail.com (Postfix) with ESMTP id D33ED180006
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:34:45 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KkvoVxO+;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785926085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JdwtyyDmK6ecFHn7P0325qRJJexfFR1DVQ5TjauAmzw=;
	b=deKYevzTlUdn7cJqJYsghX2ajRtNN9I+ww334SP4dt5eDfbD4/m9bqQSP8aiIlDk9+YwLJ
	cNyy3jznN28gVHi4Z06Sp0paHfzzCGOt/U0WK4E4zgcZhqdRoWpAVhwE3LJ8lrnpTWwCI0
	PM8Vhpa9W75qYBlbdMUA8X+7Pxk2j2Q=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785926085;
	b=l6jSdvwCLmfHlnPCiu92VcEFokTBX2mmMtUxINcV/fzuMRNFR17O4KJuUwjDeUc6ZfFpBe
	92Lop/X/3wkZwuLJmQHTIcGcMFpShJRnKi4lr8np/sNj+fe7rfDSHbtOGfixpiTVS99pMq
	XqbcyLP6PqSSuEil/h38UyWW5xlbXNk=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=KkvoVxO+;
	spf=pass (imf16.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B89596011F
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:34:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 31DE71F00AC4
	for <linux-mm@kvack.org>; Wed,  5 Aug 2026 10:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785926084;
	bh=JdwtyyDmK6ecFHn7P0325qRJJexfFR1DVQ5TjauAmzw=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc;
	b=KkvoVxO+Tt0xXpyTn+jVuzg26ZL+Zk4RcQfREpQ2+qETB+9Ugny6TfzjS6Jceyb2x
	 r9eemzG9XSCBJ6gG5D6bUut+X/yZozvf/OpyPa/1Q3CPlSBBRRKtYf8VetTBdHmhTg
	 rCdAzDpJIMwSTN9rwAFvTcext3oxv1xyN3Kb4jNc3a7kMOaK7bb/9PhHvIBYa2YQOC
	 qPKBdWEZikZ5C9NHPCBwLko5yTeKr0S8sT+/QIGKN5NRGwfnhrX6+8C8Xd0U3EG4Vy
	 KrJUFedLIzjpguc0AJ6cOEH+Lc9iaiterQ3uFeJkhglvklHwu2FDgNqa7W1r4HnKZ5
	 X2+MnrY6dScmw==
Received: by mail-qk1-f176.google.com with SMTP id af79cd13be357-92e53581361so48576785a.1
        for <linux-mm@kvack.org>; Wed, 05 Aug 2026 03:34:44 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AHgh+RqUtQTOOzytLNAnONeokwGaxMEHFLVwXqQQjNan8ZVmEKVc4MQbhyK3JFok2T1DatAOJru59UTS9A==@kvack.org
X-Gm-Message-State: AOJu0YxBBYJb+W9YWx1HzrDcOXQyuTN1PQNtHhX531dg+J2+jPWDuFcc
	5VVldIdPYWurw/I46IgyxxL2lEbZHS3tYW+aJe9vT708eKgfzJB4/yRmUMXlekXnTdxn2TrTv44
	0r+nGrbbI+CWknK44oHz36hhhXMnYQPw=
X-Received: by 2002:a05:620a:6608:b0:92e:5d19:bf82 with SMTP id
 af79cd13be357-9364900b599mr471441185a.17.1785926083544; Wed, 05 Aug 2026
 03:34:43 -0700 (PDT)
MIME-Version: 1.0
References: <20260805005545.66112-1-baohua@kernel.org> <anKQ_qZ1-Q6FchZ9@google.com>
 <CAGsJ_4wD+KNL0yMkuS4GijbHaiyPxgTmqKzkr0DErC0XH30w4A@mail.gmail.com>
 <anKaU6VStrW8zaQo@google.com> <CAGsJ_4wQ=mDXuxxTdAZkicN5pJK3SsNTOxHt5oNYrq7CgCVObw@mail.gmail.com>
 <anLGxk3iShEfCB30@google.com> <CAGsJ_4xU5VN3abCPzACZoS92MqaUrMHn9EQ1FCJD+wy=upbbMA@mail.gmail.com>
 <anMPLgbrf7XMC7Qw@google.com>
In-Reply-To: <anMPLgbrf7XMC7Qw@google.com>
From: Barry Song <baohua@kernel.org>
Date: Wed, 5 Aug 2026 18:34:31 +0800
X-Gmail-Original-Message-ID: <CAGsJ_4wd60ok7BF9XGRiO6dvddkaYTziPV-Bxq+3mA+-c7MvQA@mail.gmail.com>
X-Gm-Features: AUfX_myvPbKxw9SNyI9PZoKpSCqecCNkqet4amPWAZnb34bmes9lAJKs3Myx5cA
Message-ID: <CAGsJ_4wd60ok7BF9XGRiO6dvddkaYTziPV-Bxq+3mA+-c7MvQA@mail.gmail.com>
Subject: Re: [RFC PATCH] zram: avoid preemption with CPU-based compression backends
To: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: akpm@linux-foundation.org, bigeasy@linutronix.de, hdanton@sina.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, minchan@kernel.org, 
	ryncsn@gmail.com, yosry.ahmed@linux.dev, surenb@google.com, 
	Dongdong Zhang <zhangdongdong5@xiaomi.com>, Suleiman Souhlal <suleiman@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: D33ED180006
X-Rspam-User: 
X-Stat-Signature: me9wxgnwzio71bw3q7ptudmyz94a8hqf
X-HE-Tag: 1785926085-406921
X-HE-Meta: U2FsdGVkX1+oXAU9sakUQxPnjDJcJ6un0amXx6JP8k/5fB8s2b15VxfCclYCxwchmyiqJeVBVDE6EhpMQcR7jZ1fzPYyXqObkJR0wH6E9ITnNeBh3kCxdVS72imBF7UnTjtg8mkmj4PAY8d1jrZktjlZjbCfAJthlRPfr8jCZIef3y4X/1Xx48Zw3iipt1wjBNKxpKHYDpCQffh9MpvVL+/7uhW683aMp6BOoiQdGKmRXvuKSv2/Gu0U+YdBQ1LFpk2+PqgxXIWZs3CJFxXsSVr1Tq07Vm7ppFoRNFVKbngHp3hbd9NiK7KIm1/z4N9BUGBnjRVMioCOkYmx23+BdoU8tVWUCBeAcKteDC3zsgbwzBbI4GqYdAwwbVbnzyhKdzY2rOTRuOzWDtKAQQba4fHOyBoPYyLrxtZi5bQRxYpSAwMaA525GCcZ6hlHwxvDESi8gYme4cFfbstIAkobHvO73cl32TtcLg3plwu9nyhoK1HvBlQCkCPp0O0MNOZ9TV9rCjGtuTebw2IvpzxxSPLWCRP99YTigfEmVNxessV1N08tOZpRZi388CUUzO38I1H2Rbf0wVtjHriwMCtXTraUfRDvASDwNpvrN3A9N/Oz04IeI8HkBAVp9sIOxxkLTKTsHQfjiUOuNVFVicfypp0l9eqHENCWytmHSg3sIYznCs3K3Gc6GyOBOOPVS6iUSdIJuxYrq1TWY6Zvx0Ub5H3I8YxccnJKXBDXHknS47MILxfztMMMAoiXZ6dLKPj2EuB+2RigAonVfa3VWrQA2Os34iNkmt2EDjIGRRgxqIwxj+Y3yXHIaJbYB/urXZX45r6yHhlEA6YmJlxURYs9VVRd0Elg2qXVt6m3Eks17TecViV2O4wKK92Bq4yV18EECEYWRH3Fqsn3ct4FMQgOVc+9jVWRuVWQIIQdgiJrqCaTDZqIxwGcFNOZfKDMPAzYRRYqEdl2N/B1jikWNMy
 am7sn7+U
 ANza6r0YndMV+NRu15UKxF6flA4wRS8513IgZMEigdpRWtPakGULkLiJjRP5LairNaMLFvAHxbJHrimv1LCPNSW9RfP1TV4MPLak5YoupHAs9nO9tGC+tbA0geVJyzV0nJCRtk0p9oYkjgm4aQIAf+uLRSeqF+3350C3bS4JJWSesfuNEF5Xx+Ct9iIoCqpbU4R3PJWLbthLwPZwEv3chjxoEUsu4pQzwIYIqEM+9WjBrYSNvMFQOEljYW0rgjFACpXN51osjCjd7IO3Bl0tpUkxuZwvB3igXm7Pa3+GYb7NLhFBEnJYPvuNDM2gUCtcnjwUwwDnFwUcFHgk=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Aug 5, 2026 at 6:25=E2=80=AFPM Sergey Senozhatsky
<senozhatsky@chromium.org> wrote:
>
> Hi Barry,
>
> On (26/08/05 15:50), Barry Song wrote:
> > BTW, I wonder if compression and decompression could use separate
> > mutexes. That way, a sleepable zs_malloc() in the compression path
> > would not block decompression, which is the more latency-sensitive
> > operation.
>
> quick and dirty patch.  Just curious if this improves anything on your
> side.
>

Thanks very much for your quick patch, Sergey.

We are going to run three experiments:

1. Use the approach I just sent, which avoids calling zs_malloc()
   with direct reclaim while holding the mutex, and extend it to
   the other zs_malloc() call sites:

https://lore.kernel.org/all/20260805100740.71994-1-baohua@kernel.org/

2. Experiment 1 plus preemption disabled.

3. Your patch, which separates the compression and decompression
   mutexes.

I'd like to understand which change has the biggest impact on
performance.

Let me gather some data, and I'll get back to you.

> We also maybe can have more that num_online_cpus() stream, if we
> switch to idle streams list instead [1]
>
> [1] https://lore.kernel.org/lkml/20250130111105.2861324-3-senozhatsky@chr=
omium.org/
>
> ----
>
> diff --git a/drivers/block/zram/zcomp.c b/drivers/block/zram/zcomp.c
> index 974c4691887e..3c523ea0dc27 100644
> --- a/drivers/block/zram/zcomp.c
> +++ b/drivers/block/zram/zcomp.c
> @@ -112,21 +112,28 @@ ssize_t zcomp_available_show(const char *comp, char=
 *buf, ssize_t at)
>         return at;
>  }
>
> -struct zcomp_strm *zcomp_stream_get(struct zcomp *comp)
> +struct zcomp_strm *zcomp_stream_get_write(struct zcomp *comp)
>  {
>         for (;;) {
> -               struct zcomp_strm *zstrm =3D raw_cpu_ptr(comp->stream);
> -
> -               /*
> -                * Inspired by zswap
> -                *
> -                * stream is returned with ->mutex locked which prevents
> -                * cpu_dead() from releasing this stream under us, howeve=
r
> -                * there is still a race window between raw_cpu_ptr() and
> -                * mutex_lock(), during which we could have been migrated
> -                * from a CPU that has already destroyed its stream.  If
> -                * so then unlock and re-try on the current CPU.
> -                */
> +               struct zcomp_strm *zstrm =3D raw_cpu_ptr(comp->stream_wri=
te);
> +
> +               mutex_lock(&zstrm->lock);
> +               if (likely(zstrm->buffer))
> +                       return zstrm;
> +               mutex_unlock(&zstrm->lock);
> +       }
> +}
> +
> +void zcomp_stream_put_write(struct zcomp_strm *zstrm)
> +{
> +       mutex_unlock(&zstrm->lock);
> +}
> +
> +struct zcomp_strm *zcomp_stream_get_read(struct zcomp *comp)
> +{
> +       for (;;) {
> +               struct zcomp_strm *zstrm =3D raw_cpu_ptr(comp->stream_rea=
d);
> +
>                 mutex_lock(&zstrm->lock);
>                 if (likely(zstrm->buffer))
>                         return zstrm;
> @@ -134,7 +141,7 @@ struct zcomp_strm *zcomp_stream_get(struct zcomp *com=
p)
>         }
>  }
>
[...]

Best Regards
Barry

