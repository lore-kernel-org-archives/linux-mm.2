Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7A4F7CC6B38
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 19:05:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E0DF26B0092; Fri, 16 Oct 2026 15:05:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DC1C16B0095; Fri, 16 Oct 2026 15:05:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CB2556B0096; Fri, 16 Oct 2026 15:05:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A0A6B6B0092
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 15:05:07 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A860B8058F
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:05:05 +0000 (UTC)
X-FDA: 85329416970.21.A2EFBD2
Received: from mail-lf1-f53.google.com (mail-lf1-f53.google.com [209.85.167.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id B71CCA000C
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 19:05:03 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GU1m5xrc;
	spf=pass (imf25.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792177503;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
	b=NGqrLrJD4/l9b+9DAXg4iAr+WnFSNZZgDfZIu+7CTifSZOT0jiVNNpOYRLSkx7MZdQ9m+D
	rcIwAKYJ2MgPyRJa9X/9NjNh30FTY7pSaJsluqk7JLfiiVaQrD5h56ACAmIMWOnj1b4BBT
	CLoGcWRX6toAmlVIaV8FrI51DHskv/M=
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1792177503;
	b=YiJ3kF1GMMbCz83Nm4XCQ360wp0E67IL0A6qAsm0scN4nRoGSnDwbW0H+NhZUuc/s8GlPq
	2CLNHYa/48KnrclnXkrW05+KSZFtN5+uKkNrIQ+bVcaWDDQp5yG+x0HXKN2hk9Usv8q0or
	iQaPFzdydsdoRaaa+t9AY6mzuDsb0Z8=
ARC-Authentication-Results: i=2;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=GU1m5xrc;
	spf=pass (imf25.hostedemail.com: domain of kanchanapsridhar2026@gmail.com designates 209.85.167.53 as permitted sender) smtp.mailfrom=kanchanapsridhar2026@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1")
Received: by mail-lf1-f53.google.com with SMTP id 2adb3069b0e04-5bb7c6980f1so229479e87.2
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 12:05:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792177502; cv=none;
        d=google.com; s=arc-20260327;
        b=K9CJe4dsLFkHRyPBnbKSqmrQ94Ypuez3i84mfcToWRhU4/9+GWwXbxA0R7+X67m4Kw
         yuHwOzCq27DYhnCXKAQjIwj3LdUv0pLy8krhI4tXGFjRZAX8Q22QUU51e93MQtsA0shP
         KgX2NfB3M/5FnOKGBoBaBoHEceGvXrzwRuvChLQ6ayg/egNRq5VEKtON/219ZuP2mUt0
         Ve9zTPqdY8tHZY10vYMFJlXIvXt7OXiEzteSlMp6NirCft84h7Oale9iVORSqkKKl+9O
         zy43yS/Entv0XpEHJDBlYxrmXhWU4IlCDlG9DIXK3PT/0gFSJYAyHqabNsrTzsoHTdI0
         3Kug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
        fh=HRT5Yxnf5V8mKR8HkaSXvIGu9hsNVDdH7Uz2huWVAFM=;
        b=ngdVbtMmh5jFHOkdpKwhMJGIEPpD+C7l8dTq9daJhiQua1twECwdojKmJVDoitoSoe
         URuB4NoRm/HpbVRc8l4vEr21oPuJXJLuIpF6w/DGOY1J4Xfl/sHFu+Al/dXxUIJ/piwE
         gPJZxOo3rztBi+kjTBdDi/cc2HfWcMQ8CZFMR2tCr9OtgsrwksHDoBtcblLIFfEoNhyt
         bnuSJGCUzSBzxM5hfO8ZECnCdSDTusUGkKoaPL+GNAbqO3Alk3rV6x3whAF9x8pOMX+n
         qgR8GD3sxQjnFmuAPAcx0umhdPE/X9qFF1i/7MPIC7Mij+7W4k+ysKxIWO38QMRS6Hza
         u1VQ==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792177502; x=1792782302; darn=kvack.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
        b=GU1m5xrcTUE3FzRW4eIqWaM5tQH6plORWeTf3KBLKvTgjrUqi/PCvzmMbjWwcJ//ha
         pPwKyb6PbCO5RmF3AtpH1CYbLNOcyZmzvi703lezGpyKVJzy7L1g2E5FMvowH4IF8/Cx
         J+X0KxxPJQJ2L5FGSyznyis5CPA1eaMKja1Vlh/aoKZBeTuIuaTlQH90xOcAOKqxH3Jp
         fpQQ0oFZXvAsxemgH2wtgF5zZdVbRZ6FALSj227LCcMNclyfXEGtfeF7SBggmjJBUq/D
         JeiSmcPOW0rYp5NnQ03RHzozthE5660SJ69PrsRi+dxmd+zbnNEaPv/WrQG3bV1HZklC
         agbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792177502; x=1792782302;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eFr5a0FeYIfPj3OlM5ijOjEBoPrB3ZZlxk7SDs3PmPw=;
        b=HgPNCEFbpn3Pqm0fMpMpRbvuw2yrVRM5sxGNrUbMU3VykpwGAxn9kqLya8iUwTJ+Mo
         p9rPuIPSnHWjmzH8iUJJ1YaWgwvKSH1O+eQy9gAKeGgcWTh8X3IezSGJGTFMZWmfp/MZ
         VF/0IhPJO4i0qiSce2TGd3brFTTVTOJiwiv/HCgSESz39A/sxPdHr0GL2rlA9C9zT4hd
         g0yvNBQHf8d4tgUP+RxSY8yVqSbY99cSx1Kkq8mpqpBhdzm5TmjbdBCJHCfDVqLzOvbb
         7G3IUJR7mR/YyULOZCdyo5vs8SOCKgs5YkgkGwmUcWbQHRZYByrHp+IuJd7u0EOKMdCr
         pJXQ==
X-Forwarded-Encrypted: i=1; AKwUvBzANZp1kSOCVk2LBQXaVFew3HjWcdTZ0YXaJSaJbi4jOtytwnWGKJ+dFPPN7HWG2uKH9M3AW7RCvQ==@kvack.org
X-Gm-Message-State: AFq9FYINpvITT7jjmQB3Vog8/q2UWyO9Nay+K6GmmrYkMn9ZQe/RjSRD
	eA8ThshbYH3Q+j8MWk/Ae8eaMChkUgzHWoF2nBbXTElw6AE8aGmO0gJgG2nRjehLQbF5p9V8RKY
	BIMZnnv9M4TBFpSxBeW1827HugG55UWk=
X-Gm-Gg: AYBFou0aCceTpv2xb5rgV+9ABeOGmm0qvjxgrQIGmjlGD+PYuJLbntDeZp74215fQw+
	/6EeIweXeNCfmFrp0TRU1a3KcMmmIOpShZoquTRSrvdYQNhZ5+g8ycWtHkuPtI5avKodX4aQ4Pu
	wZwONj8K56hRcF7pdA9D3K64gEzVhR6Ei5lgQouOGIiHuFYKs9usheuEGigTm8C30f3+eHRcOme
	PGzNzIbaKHyLnFy3BTrTcOmRx4o+o6ZRc3Yu9W4nU4/Q5Pwe/DjFnXN+m0FontzuiZqg9dEE2tE
	wR8BfK5X6d/exNvJ8QovRlYnqSnoS1ohFaX4eCgIJgQWQRNKVYqd0Bg=
X-Received: by 2002:a05:6512:3d1e:b0:5be:4d3f:bcb with SMTP id
 2adb3069b0e04-5be509f6406mr140553e87.6.1792177501725; Fri, 16 Oct 2026
 12:05:01 -0700 (PDT)
MIME-Version: 1.0
References: <20261008182814.27450-1-kanchanapsridhar2026@gmail.com> <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
In-Reply-To: <CAO9r8zOHtaeo5jhHkHB8Vtb9+KZXO+DH74v+7Y84W0v=tatRqg@mail.gmail.com>
From: "Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Date: Fri, 16 Oct 2026 12:04:49 -0700
X-Gm-Features: AclHuK9MIvQEnJq535pIpXHoDNUv0NJGjcL6pnvPWj57xwMyrngG-QJeAgr-Nsw
Message-ID: <CACpmpofN-JfCgJtW9D0wNu0_pL1pRWGfNphUQnE9Bse-P5tHpQ@mail.gmail.com>
Subject: Re: [PATCH v1 0/8] Batched zswap_store() with compression batching
To: Yosry Ahmed <yosry@kernel.org>
Cc: hannes@cmpxchg.org, nphamcs@gmail.com, chengming.zhou@linux.dev, 
	akpm@linux-foundation.org, linux-mm@kvack.org, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org, 
	linux-kernel@vger.kernel.org, rientjes@google.com, willy@infradead.org, 
	senozhatsky@chromium.org, 
	"Kanchana P. Sridhar" <kanchanapsridhar2026@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspam-User: 
X-Rspamd-Queue-Id: B71CCA000C
X-Rspamd-Server: rspam08
X-Stat-Signature: 614744phmmbcfx3ij9yccozx4oxfxnds
X-HE-Tag: 1792177503-460521
X-HE-Meta: U2FsdGVkX182951CDGjNJOwx/Cjp4a2inv9VIQ30NUs59xA3/ljpTur462pS5NhrH4yEFFEgM9HORxGYADBuyOv328D8sukh+PgMyytzVozLYeeBT5PpNYdNNCpe6d19GNbFcoxplfr2vG+Do6n8YcIMonXtO0mKxEBHdNHGaj4QJAPv1/R8YYriJ5e9vWrUO4dAMTcDPSd7cDrpZs3TlIp1xJ6omHRJ2dzObri9rCbLbIbOK5+DCgYh7VmCxj/rMgRhZFIqo1e4rhOErtWwaLkppVlf9jqNdtfCiogPDKfLq8BFBosRmB4z5Rui7ngj5xSdYMjHGfVTVF+rJ0JIqOimo0kmOO91yg+4pxm/9Nt70ET6R6tByd8SRfBlTMIzgrE2Dpc34/UAsjI1vub6B/rmdxSZSao+T+nvtOvQiKrBMSBhBO5fWgZDrbNgIdS1UTJqoFI1yy+zD/z+5sTyZyq5ORZ/Z0YNOi5waE8lW7/u5kgvCTYnk3quTkIcyKXHGLfoFXtMjZ4ONta9IzReYTz320x1SsVE2dxx46AWRCmiBeIYsXkL8M/WeSRur+MJA5mIVoeDzyoq/csIf4NHTM0BX/qqGSDeQgR8AQI7XoehetvmGOcAbmmJCf4audIqeFCkut2DopFXVU1Hn/MIEjDPKzCB5DQj9/dlCZsZt0P5txzo7lzVMxtoeutHbsEUIwwqKaswNtyxjr6SIfjAMWxf4bxlzd3fCCCzM5BAaTOt0sy83ZqUD7PgY6FNAX4ngyMABxJrBAKP7aUtHXY2HPWeLITg4/YvexigtzGx0tCDEHgvtmbZJIXzKN7DXmmc1z8vuRRjk71KjV/qjC+OoQKTgl9CsNZLvCVyX8inXt6PfJTM7YxIwKhxdyVuiPW2rdUHvm10wGEtsJ1vyk4lD/2P8yvC4rXvCIqdo/cG1j6wKJoGnlronMhRJgYkrQdMVcDozNMeFl3RHk4PgHi
 PykuiS5c
 lgj/FtGx91ryjoaApmcYR2Q78D6HkP7n6fkPAbRSPrmPrfITCAg/uvrCbfZWpqjLbnX5NbnR7EWUTmXvI09D4OAh1WJTa4XGPSuqk+vKM561cchYrUDiS4qghbpgfS8h08wqXx7y/ERTv9pnv8r4HiloDXs7EzXPZlXG0lsKtS77ZwJtijvLcH6wtzvRyyYUUKbO3JkGOcA/iHLC48biHqEqS6u3C9dnh7uv4iQQdz1gRSqOF2ThiUZ308wEgsoOFmLU+W+ilFajvLJqVFKON3HCfdKGp9zmcjqjlUXGphiaZKihd7wpEtQIs3HOn32Lk+b15vLYrX1zX4sX+TgL32oYdYQbJBPSGjoE+kN14B1J70bkjrAorS8gicExRQMSQnuTaJty5Y3kcLzP/zMSVQolg6ksFG4HLP6uV7rX5MJu2nLuNYnG1HBuAC3tMciyex1+km6mW1/bBceAT4h7lfmJVWpR8SI8pcNI8h7JOSbD5hOuTcxfAj7/hi5MnxMWscvqS/DvhFZTC2BN/5TezoIG035DSese3TQuEOnNZAugSsxG+dsMrCLP9TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Oct 16, 2026 at 9:14=E2=80=AFAM Yosry Ahmed <yosry@kernel.org> wrot=
e:
>
> On Thu, Oct 8, 2026 at 11:28=E2=80=AFAM Kanchana P. Sridhar
> <kanchanapsridhar2026@gmail.com> wrote:
> >
> > v1: Batched zswap_store() with compression batching
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D
> >
> > This series is a spin-off of "v14: zswap compression batching with opti=
mized
> > iaa_crypto driver" [1], and focuses on the generic crypto_acomp and zsw=
ap
> > compression batching enablers. Resuming work on this series following a=
 gap
> > since v14 (January 2026). Please note that my email address and affilia=
tion have
> > changed from kanchana.p.sridhar@intel.com to kanchanapsridhar2026@gmail=
.com. I
> > have retained the original Intel sign-offs on prior patches for histori=
cal
> > attribution while signing off v1 of this series with my current address=
.
> >
> > To summarize the main contribution of this patch series: Batching is in=
troduced
> > in zswap_store() of large folios: we carve out a large folio into batch=
es of
> > ZSWAP_MAX_BATCH_SIZE (8 pages) for software compressors, and store each
> > batch. Moving the fundamental operations that need to be happen to stor=
e a page
> > to now work at the granularity of a batch offers opportunities to optim=
ize them
> > from these perspectives:
> >
> > 1) Utilize existing kernel API that minimize obtaining locks for bulk
> >    operations, e.g. kmem_cache_alloc_bulk()/kmem_cache_free_bulk().
> >
> > 2) We keep the working set for each of the core store functionalities (=
alloc
> >    entries, compress pages, store pages in zsmalloc) to be focused on a
> >    batch, thereby minimizing cache evictions and benefiting from cache
> >    locality.
> >
> > 3) Along the lines of (1), the main zswap_compress() batching routine o=
btains
> >    the acomp_ctx mutex lock once per batch, and releases it after it ha=
s
> >    processed all pages in that batch.
> >
> > 4) Any zswap store functionality that works on a batch can potentially =
be
> >    parallelized as a next step, to further improve performance.
> >
> > Performance data: usemem with 60% over-commit:
> > =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> > Validation was done with mm-unstable as of 10-3-2026 (Baseline) and wit=
h this
> > patch series.
> >
> > Testing was done on a Chromebook with a QEMU "vng" VM running in Crosti=
ni.
> >
> > Chromebook Diagnostics reports:
> >   Intel(R) Core(TM) Ultra 5 115U (10 CPUs, 4.200GHz)
> >   RAM: 16GB
> >
> > vng setup:
> >          Memory: 7G
> >            Swap: 3G
> >     Pinned CPUs: 4 (E-Cores: 4,5,6,7)
> >
> > zswap compressor:
> >   ZSTD
> >
> > mTHP enabled:
> >   64kB
> >
> > vm-scalability/usemem setup:
> >
> >   cgroup memory.high: 3G
> >   4 usemem processes, each allocates 1200M anonymous memory, reads the
> >   Silesia dataset [2] from a pre-fork-allocated buffer into the 1200M,
> >   writes to each unsigned long in the 1200M, sleeps for 10 sec, then
> >   frees the memory and exits.
> >
> >     usemem --read-silesia -w -O -b 1 -s 10 -n 4 1200M
>
> What is --read-silesia? Is this a local change you made to usemem?

Yes, this is a local change I made because I wanted to get compressed
lengths besides 565, which is the only compressed length of data
swapped out from the original usemem.

To replicate my setup:

1) Setup Silesia dataset to be read by usemem:

wget https://wanos.co/assets/silesia.tar
tar -xvf silesia.tar
# concatenate the 12 binary files into one
cat * >> /tmp/silesia.bin

2) Modifications to usemem:

usemem_orig.c is
https://git.kernel.org/pub/scm/linux/kernel/git/wfg/vm-scalability.git/tree=
/usemem.c.

diff usemem.c usemem_orig.c:

75,76d74
< unsigned long silesia_bytes =3D 211938580UL;
< char *silesia_dataset;
103d100
< int opt_read_silesia =3D 0;
166d162
<       "    --read-silesia      write memory with data from
Silesia.tar to allocate the pages from Linux kernel after
malloc/mmap\n"
209d204
<       { "read-silesia", 0, NULL,   0 },
352,373d346
< static void fill_buffer_from_silesia(char *buf, size_t length, const
char *silesia_path)
< {
<     size_t bytes_read =3D 0;
<
<     int fd =3D open(silesia_path, O_RDONLY);
<     if (fd < 0) {
<         perror("Failed to open Silesia dataset");
<         return;
<     }
<
<     while (bytes_read < length) {
<         ssize_t res =3D read(fd, buf + bytes_read, length - bytes_read);
<         if (res <=3D 0) {
<             /* Loop back to beginning of silesia.bin if allocation
exceeds ~210MB */
<             lseek(fd, 0, SEEK_SET);
<             continue;
<         }
<         bytes_read +=3D res;
<     }
<     close(fd);
< }
<
613,623d585
< static inline void copy_silesia_to_buffer(char *from, char *to, size_t le=
ngth)
< {
<       size_t nr_bytes_copied =3D 0, remaining_bytes;
<
<       while (nr_bytes_copied < length) {
<               remaining_bytes =3D min(silesia_bytes, length - nr_bytes_co=
pied);
<               memcpy(to + nr_bytes_copied, from, remaining_bytes);
<               nr_bytes_copied +=3D remaining_bytes;
<       }
< }
<
638,642d599
<
<               if (opt_read_silesia) {
<                       copy_silesia_to_buffer(silesia_dataset, (char
*)p, (size_t)bytes);
<               }
<
1053,1054d1009
<                       } else if (strcmp(opts[opt_index].name,
"read-silesia") =3D=3D 0) {
<                               opt_read_silesia =3D 1;
1263,1268d1217
<       }
<
<
<       if (opt_read_silesia) {
<               silesia_dataset =3D (char *)allocate(silesia_bytes);
<               fill_buffer_from_silesia(silesia_dataset,
(size_t)silesia_bytes, "/tmp/silesia.bin");

