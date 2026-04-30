Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DE2F8FF8873
	for <linux-mm@archiver.kernel.org>; Thu, 30 Apr 2026 15:27:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 51D906B0088; Thu, 30 Apr 2026 11:27:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4CE256B008A; Thu, 30 Apr 2026 11:27:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BDB46B008C; Thu, 30 Apr 2026 11:27:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 2B1826B0088
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 11:27:20 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 289E149BBB
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:15:21 +0000 (UTC)
X-FDA: 84715570926.13.C671A9C
Received: from mail-yw1-f173.google.com (mail-yw1-f173.google.com [209.85.128.173])
	by imf28.hostedemail.com (Postfix) with ESMTP id 68122C0027
	for <linux-mm@kvack.org>; Thu, 30 Apr 2026 15:15:19 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z+wshLs2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777562119;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=KDRJaFjlBSoeRpqfVDKyshLRremrnk0uCfcTz7eq314=;
	b=jBQShyC5SFYV4QyFOMA4pAj+q427pUa+pIa2i43+II1u7zJNUkmut84Qb142pKTSfWtfPv
	gZaKanMEm57jdr7hAQKS6oTa3ESFcDMCRa0UxtORq1KNQ5OInqbxkvtyCCnnFmvyCEPhrA
	79b84QVXjCDt0MjtV3J5NOk1YEIyPi8=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1777562119; a=rsa-sha256;
	cv=pass;
	b=zPGgQ7K0pXXpgmV2XJQkIN7k3qRaPaT1h3OrwLXqDcANakQvDVsTm33meicugPNL/JivUW
	rAO1bEUoWAhNgtKixNgYJE+fH1qCDSd4UPfi5LF0p9T8DWLGFV6F96mFmKFAP8Fe/D9LFU
	7Yccgsek/p9qdHvn/cAK9yTXbVukAQ0=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Z+wshLs2;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf28.hostedemail.com: domain of haowenchao22@gmail.com designates 209.85.128.173 as permitted sender) smtp.mailfrom=haowenchao22@gmail.com
Received: by mail-yw1-f173.google.com with SMTP id 00721157ae682-799001d73bdso9911257b3.0
        for <linux-mm@kvack.org>; Thu, 30 Apr 2026 08:15:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777562118; cv=none;
        d=google.com; s=arc-20240605;
        b=R6SQoz4pAUp8jQqXf8xmZnkbmVFSg5vJHyP6ffdnHgITeLSB7w50XFT5V+EgJYtIGD
         k52wTEh7AaFBdNNhUF4j90Ddxjq0nwOQSrb4620FBXjDifdzCXHulF9351aHSy3LaCYl
         JJxjzjRcsrYxNAsLHKzWxsEB7e1naCK+cnaYQdvYacBAdVa5GWRHCdKTvsOo+bBIUJMX
         LkcIDCzONxAoc/5Le7tpvl149KZ+LNwHUJfzRBhKsBO/D3KAKH+wWcsBFI07BXfLsrrM
         70t65MAtyF+jRS3fjl2CQHExoZsVwVV6tEo9YZjkszHOI/nRDzBUAjXZIsq9UW+QossK
         fAMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=KDRJaFjlBSoeRpqfVDKyshLRremrnk0uCfcTz7eq314=;
        fh=gNjr880Ii4Nr1UKByCA4ubDdyBpVJca+zccLnPm2GyU=;
        b=N2u34wdj1Il6fGoiCcpKgIVi4sncSgOabI7j2tLhf/Afe0bYeJXP7EdxlmQUAVUGqK
         +BTflpNukhE3JnF+aLyCR28u3rFfQTg/m1e+JFc5B1lT8Sl25v12HAe6Qz1utPg290qM
         eZ96HrHjkdsVBEXaaP23Lpu25mro7MiRWiSn0PaHXA2wKi/UyrkJwhNu6FymQuIZzkFU
         5RwzvsH13LN1rmfSqZEdtcNQrakSQexwrZkUuu7slCSI8ODPV8ilJpbWo/adNzTVuJ1X
         nDxGcxRHFC/A2txfIbCQfUhC9uW1Lf98TRUcHcMXihXjOI09bq5uT64c9Iw2PJT0RvaX
         lyUg==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777562118; x=1778166918; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KDRJaFjlBSoeRpqfVDKyshLRremrnk0uCfcTz7eq314=;
        b=Z+wshLs21G6DjqZpMe9YqzGkgVBRS3RG9vm5MBJNNerZjUPVReFg1Krfijm7pxMhoQ
         quOE+e8cX43Q/13CYRqJCKTgNiRbDgcKMIbKraN//4FuciWyC3Vz2hXyi4PnlK49hOPq
         dj9V5Z5BNDzBugo6d9ZFIVEe4jaqaKpsNF4oZKvzwfMEx+L6cCZ1hIoPDirKmisPhG9u
         MfQPqEdBwZvg0G6mi17TQqEb2ojTvuj8uXmjFPGjOBlIB3ESEp3liSNz04AHF+ll6Jmy
         DHxXuoJlg3ZPRc9X7ukUY/gzsguMAiluRrO+KHVI4tBHYVwL77I3RR1g4dc4p/fcN+Bp
         wrLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777562118; x=1778166918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=KDRJaFjlBSoeRpqfVDKyshLRremrnk0uCfcTz7eq314=;
        b=JAXQFUu/NuWVmP4eqhOnjK0kOzUM8GOQsWoGB+MtxUVsalixJCr0yc8J59545VJolm
         DtAumdUIIG3UDZXCaHeLuTRLgz77+gvPVPNzIxy/gAi/8j1I16QTrTT9JxVP8OfUL1Ix
         jqs3qW3nolltEby2RSkZg4flvOMwZKF3TUcImaAooDZBqfx/X+vuqDWHb5YfweGVKB9U
         4nj4Ibt8tK/5b6lT18IqWukMyJmtWqkkalaEDQUGBvnEtEXGL+1Mj8AhoCdLpmrivWon
         7bHKELP9kHVlQPSKNxqLdAhK/pkphi2B15wV9IUzzR0pZuIFAtD+F/JHyiIVaN/+t5LF
         8Hig==
X-Forwarded-Encrypted: i=1; AFNElJ9PeO60tN7f8igdbJIyJcy+MXSdZOex+Kx46wlPU1z/2kKmJZw8857I9ozEmJTuHFQa8fec4dLeAw==@kvack.org
X-Gm-Message-State: AOJu0YzVbQwl5/jgzQAMbNoacPAd92Muu9de+vUnB52KOSXXKj4NHP7v
	mMmLF0c3QXpuL4N7TRFA8J7ZZNgrOfWBWvF7lhYEwNOoRkf+0yIswvh/Rd8XRsB3PfYaId/hjFb
	mrGa2CFYDXZ7KPMzVJdROmcc7gSlEoxQ=
X-Gm-Gg: AeBDieuda8LitSiW2PeRxB+U8Nay/d9seDP+cNF/bgC480voyh0dkkjFL79lsWhhhTP
	MlvWpH5LTzwXYT3pKMjkvCte+HwlUqUsV8oc2xDZuLViIlCm+UZI2/GJ8xLk5TzEF5m2mTHpYZT
	SIlx8ez8sLvAu9GNNA/p2Km6EkyZVaqjQrsMqD4VgXSp+wWvocJhrXDpu8oCM9GDXGE3Sv/K09Q
	roofkP+xYKVgl2u4nM5UfIuPbwJV8HpEWxsIaZI/+5L1CXEzBrQvlOjFkfilqg2gx0KRKSnGQCh
	qBAgXnceLlTXBE43yt8=
X-Received: by 2002:a05:690c:a01c:b0:7b7:5f48:d9aa with SMTP id
 00721157ae682-7bd52cf9397mr26452807b3.50.1777562117901; Thu, 30 Apr 2026
 08:15:17 -0700 (PDT)
MIME-Version: 1.0
References: <20260421121616.3298845-1-haowenchao@xiaomi.com>
 <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
 <CAO9r8zOjugCwWqHP3zxXPmjp8TwpoROCjCqTZ_uxOBQwVqCWqA@mail.gmail.com>
 <CAOptpSMQyyb+q-VJdJ0RzNkjaer1CTePM5WkwEj_7cAO4aUToQ@mail.gmail.com>
 <CAO9r8zPV=c9v4Ar7t+xPxyptSUPrs-shrumsz=hCaNa3anGgAA@mail.gmail.com>
 <CAOptpSMLLz0yzg99nkAp7rxO5RphTDU3Cdqd8020mysijN_Bvg@mail.gmail.com> <CAMgjq7BTM1HKWwSTxkm7br+L2MDy7=OxEvF+yDRJfFfr24TiVA@mail.gmail.com>
In-Reply-To: <CAMgjq7BTM1HKWwSTxkm7br+L2MDy7=OxEvF+yDRJfFfr24TiVA@mail.gmail.com>
From: Wenchao Hao <haowenchao22@gmail.com>
Date: Thu, 30 Apr 2026 23:15:06 +0800
X-Gm-Features: AVHnY4JPRw9tshrsKiYQWjGPgU4Ll8OBvmSdcCSxAhvDHzHqd3kQJaCzs5QgF20
Message-ID: <CAOptpSNQNxPCesMYdT5856f_nL+pUtL9a2-Wz7SpxEZTGZA1xw@mail.gmail.com>
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap
 release path
To: Kairui Song <ryncsn@gmail.com>
Cc: Yosry Ahmed <yosry@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Chengming Zhou <chengming.zhou@linux.dev>, Jens Axboe <axboe@kernel.dk>, 
	Johannes Weiner <hannes@cmpxchg.org>, Minchan Kim <minchan@kernel.org>, Nhat Pham <nphamcs@gmail.com>, 
	Sergey Senozhatsky <senozhatsky@chromium.org>, linux-block@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	Barry Song <baohua@kernel.org>, Xueyuan Chen <xueyuan.chen21@gmail.com>, 
	Wenchao Hao <haowenchao@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 68122C0027
X-Stat-Signature: pjqhb3on6jd1zm16gqighmcxosnhueyj
X-Rspam-User: 
X-HE-Tag: 1777562119-461673
X-HE-Meta: U2FsdGVkX18mV4f8fwEQVjiFpsTOX/6GlQsHSO3OgR8JAAVI6NKpRaBU9LtlkKYGpf/iTVrz0e1SlMXpa5rImx6FzRohlqGFXpDd8aO9/5kMLt718x3IlOCtyTLGUMXQ7rBRt29GwOMgzAe6kmjRdttkuiZDdy6OXD1i5qMsrK/ONDQv2uS8pLwxbpGbE7PS1lmap9QkCVa5Ra4e2eX50XmthCZ5KbDmtdIm3+m2mq7j74+1pO9Qj1n3R93kRnPGjRqiW+QQ24ZJCcYHEM2OLA12jqdYrL5243tH9yYqbyypen3ZqZPkiPrjsfT3fpCBYJSRMRUcPo69yUBT/Q7gw+lz8PgrZe4/bQkc7ACDrDYLw6GDnnwPIriyVPQYmFMZRnM5uU2ftIda5+KQwu0NKfOTZHimH5VRw71SzjrTZztH0QzW3qPV3EpeevcQm4CCusndNSZSKMfwU7ChaQvPljGOOqDVOzextbCnx69S9CJ65YD5ODGz3/D3hv/S14YOCf4mRL73kXvOISHfrRbykneV2/IQoLBjy4L4tNuZloilzn2qUQH2RSGqX1boVDLrFqlnifwLc1lLYcBD4R7wXe3xABPeT1/CnTVTAd6Q97aiBBWPX4gYDLr61nEtpB6kNagxQOBwFSnjLizEIDq+TeIlsm+2gzo3Efr4MTcYRwMsnBw3Cx+YzqQ58cSO/rvcYEqnQkjlpCCmwvH/W+XSzBNl+5lNERMqHDIEFcVOS8j8t7ko2kqtKaZVx2oF7fo4jybR3CfjyfaY6bFYxTzkEcghtIYRPRicEF/0BWAJ3PyhHbyZaXwGfm6SPwpeRkCs4r/aQrYZhorj4zfJeh+gsMFgs81g3uJqRGZCuZQIZSFe+jbIZt6XdacV8+kvv01Rox7JZoyfOAlnFGxO6Rjs4iUGHO7RXacE1xNp4jYIcJNABi/dS/tSTHegg7VAmV7citwiIpEQov8Q+Ytdfl2
 nQ0nXxSD
 OOlQfIwkA0Cod7wsISwykNi+cTf107fxrH/+mSJ3pss4o52o8imGcnb+NUOcuFjAtcj8kUfgeDvqysb3AI+yiLaubMQrEwz0Up/ayHIMBjNlQfKo1u6V3tcOyOh+cG4H43R6P/Tz7v/+ukEaLIthM3vPCCg93OvXQskaQLvk+A/JuCZL8bfCgrKhnnk2TFc2FVUNQtKW1/JZTyXG0TQSSwA47YyeFesfg2tVv+MIGgyDBAW/WCSK68V7uf8/R5+1Zig9PFlO2nuclGJuJ6ThmK4eVL8PJHZUCWndryjpsenoT4TtCoEVnc7vKubrYpGay0TGvRqvm8bdzZCRE94+4WDzU8LufeYoblOc4iMnRPY9k//4gNoOsgLnsHrAOle3CUlopx94NqEpxROHUdQxBpWJgIJeUtGf5CpILfJHbrriXScycL9zXKAF/FL4k3v9Bx1pc01Lfp9NZERovIf5etUflzVqpLLU970/RsTQFNsIOAwk6zbLDj9VKz3NUp+jIUzab15vDIeuDyyZ+UDUL5kKQfeXKDFRAJ9Mx
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Apr 30, 2026 at 4:00=E2=80=AFPM Kairui Song <ryncsn@gmail.com> wrot=
e:
>
> On Thu, Apr 30, 2026 at 3:43=E2=80=AFPM Wenchao Hao <haowenchao22@gmail.c=
om> wrote:
> > The data I shared earlier was class_idx-in-obj only =E2=80=94 no
> > deferred freeing at all.
> >
> > > I couldn't immediately tell by looking at this vs. the cover letter. =
 I wonder
> > > what portion of the improvement comes from the deferred freeing?
> >
> > On top of that, we added deferred freeing in the zsmalloc
> > layer (per-cpu page-pool based buffer swap + WQ_UNBOUND
> > drain worker). With both class_idx + deferred:
> >
> > Test 1: concurrent munmap (256MB/process, RPi 4B):
> >
> >   mode      Base       Deferred    Speedup
> >   single    56.2ms     17.2ms      3.27x
> >   multi 3p  153.2ms    51.5ms      2.97x
> >
> > Test 2: single process munmap (various sizes):
> >
> >   size      Base       Deferred    Speedup
> >   64MB      15.0ms     4.3ms       3.47x
> >   128MB     28.7ms     8.5ms       3.37x
> >   192MB     43.2ms     13.0ms      3.32x
> >   256MB     57.0ms     17.3ms      3.30x
> >   512MB     114.4ms    38.5ms      2.97x
>

Hi Kairui,

> One concern here is that the total amount of work is
> unchanged. But when under pressure these workers could
> be a larger burden.

The total CPU work is actually slightly reduced =E2=80=94 the
batch drain eliminates pool->lock entirely, and holds
class->lock across consecutive same-class handles rather
than acquiring/releasing per handle. So the deferred
path does less lock work than synchronous per-handle
zs_free. I'm also exploring further reductions, such as
merging zram flags operations in the notify path (as you
suggested earlier) and reducing lock overhead. Suggestions
are welcome.

The key win is not reducing work but unblocking anon
folio freeing. Each folio free returns a full page
immediately, whereas zs_free may need many handle frees
before a zspage becomes empty (multiple compressed
objects share the same zspage). By not blocking folio
freeing with expensive zs_free, we improve the rate at
which usable memory returns to the system.

With parallelism (munmap + worker on different CPUs),
the process exits faster and memory is returned sooner.
For example, what used to take ~1s on one CPU can now
complete in ~400ms across two CPUs. Under memory
pressure, spending a bit more CPU to release memory
faster is a reasonable tradeoff.

> Is it possible for you to measure that part too?

Sure. Could you describe the specific scenario you're
concerned about =E2=80=94 CPU contention, memory pressure, or
scheduling latency? I'm happy to design and run a test
around it.

Thanks,
Wenchao

