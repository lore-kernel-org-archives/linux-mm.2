Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59952F9D0D5
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:36:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 996896B00A3; Tue, 14 Apr 2026 10:36:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 947AB6B00A4; Tue, 14 Apr 2026 10:36:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 836886B00A6; Tue, 14 Apr 2026 10:36:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 6CA326B00A3
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:36:21 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B36F159476
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:36:20 +0000 (UTC)
X-FDA: 84657411720.21.8D37ECC
Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	by imf30.hostedemail.com (Postfix) with ESMTP id 8B51A80007
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:36:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AB81ZXV8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776177378;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=AnsEV6VHaHqEew+Xa56Ltrfs2MD3YtoIUeXjaty5EkY=;
	b=O/vI5FPZ/khjToSlEt4DltsJnYblJA7ntEoIYPxHQ3hwdgbUXqzVAWBoob+czVjlR/OMNp
	gedKAAKhMb59sG9k+1yRanW8psC4o0bno+vkArZJOrp/32wxsqKZWa1kAroS+G9ua9JAOS
	Ja1MmfEwyQZ/+cNpPfbCGTMDachRSDg=
ARC-Seal: i=2; s=arc-20220608; d=hostedemail.com; t=1776177378; a=rsa-sha256;
	cv=pass;
	b=rB34qjbnNMG4oxet+2Ypi3HN0QmKcg9vbagQ5NliuFOfBV55WvA4AF0op1Gq2HI4ON6mFd
	bZ/E6ZNDt3Z8OT3Mn/ILaEpPBdC6WHfpT+dSSK8g9FNpBYEEHzADb78QIcwv1+dG/EA/9o
	n1yARaLTl6J5m7oo4YZSrIwZnpUgmGw=
ARC-Authentication-Results: i=2;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AB81ZXV8;
	arc=pass ("google.com:s=arc-20240605:i=1");
	spf=pass (imf30.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.48 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-43d04fc3bf2so3445940f8f.3
        for <linux-mm@kvack.org>; Tue, 14 Apr 2026 07:36:18 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776177377; cv=none;
        d=google.com; s=arc-20240605;
        b=DTtL2zdPPgCvwe1UqWO45nuK6IIJYyphbhIALGMn63QRkvC4m3I2OP+5F60+YD9X1J
         Vc27nEoIJnSf8lrbjCQBUJBXnvArmxnAc2BUdY1lbeHoKExXWyzCqk3kdFshYBBPChEh
         l8HR6OxxvDDAYw5HI2DBTE5qgl53R4DCuD32hg7KPJmtWfe4ccPNG+lEc69qk9MaDOjf
         4ahKQZgHDhxfxvJwR7Bw2Zc2oMa2Q606HTrM6xH+/eJsID8OXLwrHePOl48V5/lYevRm
         juCPtl5q7Ngn6uZWCcGuS/kUIAwfA/79SwH1YQGq1OHBQNotQ/d8ChQZGS1+4TM4MJxH
         2vOg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=AnsEV6VHaHqEew+Xa56Ltrfs2MD3YtoIUeXjaty5EkY=;
        fh=sufu7sDy40D3YOfDLiVltMj9gPQLpX2oH01vYhLAmcA=;
        b=EbgjBffhVHtG2yefkdl34nDTfTHct6BQs594YQw0GmTZbQ6dRW9S8IduF+y8o7b2KM
         HAa/tcrz6rGvh9dkkPjmPg2uakA9Kz5QrswOrYF7kWq1Cn7Py5pFYeNJ2bAIU0OKLaNS
         XamzM9Fsh51XHGSy9yCcgpBBTTfe0kS5A36ar7Ot5RBURh/K0OV1leW/6SsKoPK6rmKG
         kbXs8w/mYTNQJpHeye9rkdOmrS8gAWLKkTwPshObzI52e4/8MRxRZG1FFBo1ikJ4S4oW
         vWt1ldPg2gQVdO7+in6fbwIzGo6osQiOAR+Wy6SmON6s8MjUXYx2sOY6m0OquB3iMvVE
         j5dA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1776177377; x=1776782177; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=AnsEV6VHaHqEew+Xa56Ltrfs2MD3YtoIUeXjaty5EkY=;
        b=AB81ZXV8e5zfMP6ltfIYgZqXz1RMrDUF6XlTJ/3LpMbxzwy2uN+533NJ+WkG0vGvnk
         /948hDPWj5zN2W//49ZxTcYI9v9WFOaq9i7qjYV8go22S4QsZPiCCQq0YClLT+YfkmxT
         RMMPg+ofjkZjJI31UZaMJLj6e8i5sopYakyF5l6HwIpJd2QfAmTjwIv60O8r3gd8T6m6
         CzUV+/TshZPNijp76M6zkkrOMZnRHNua3lFJLoWc3elHl6HGU4zl54Q/dDv4fTcoLj1H
         WU9v60xT82lOZyeXkFePq4g+rj8+J7W+34tQ3ylqIQ8DpuyG7tMTHqnbTJ+CfKunChvH
         SuXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776177377; x=1776782177;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=AnsEV6VHaHqEew+Xa56Ltrfs2MD3YtoIUeXjaty5EkY=;
        b=RzkWFMZ1aB/turIsLRAfopJ+F2qhrAsPgpNJOsxT7Gf47tHelUbBiFjl8rvUhreAH8
         evdfhn7Mt8a0c712fvQdBEl5wMywjhdXJinAlvN4DJdi+Smdl6bGdK/RHVnNU9EroQKN
         Q7G9GP1kw04uCYRePOJ6h9IL198KtVAcygHNRRKghZVFwFpkSBgRggIZyz7YG0stQV8y
         fjbIqVGJwXQ13CklnOm7IUdDK2zURpDQXaErWAfbGotXJHQSYbe2eE6SB710OvvqjwTi
         kINmEceLgnCUJNQgOzfbvXBFTm8PUURg1gyvIHqlQUa9qxa2CIbQC8X8uk8JFOCBXcKo
         +PtQ==
X-Forwarded-Encrypted: i=1; AFNElJ9DUG+CW1G0lOMlzBPEJCXyzurpomdcGT5+b6oMVpZglyHp4g2AeJCtykFCSCcehmLeVoJTKEQzdA==@kvack.org
X-Gm-Message-State: AOJu0Yy30p83fl703VCR4YFLQxspvm63ykbYjFOk+7h7UP+pyaYOR+qD
	XsTURbDuzYvrfdS5G4O6/YuS3cOhhYUOPrzrCaC+5kIvWTYhrjSvvPmIlXxW4iXBbTIPl8ArT+Z
	5xDnkgvWBBNcM+uOyGhzKM1GHVibmIao=
X-Gm-Gg: AeBDiesjFxC+ENF4D37UBMhkR4AcRv0Qt9sRbQlgk0SB9R3jr5c//Kw0kKQ2WX1EQty
	WO3NsMMQyT8ckyeMKlNg3Pjdxk5Zrc/lmxX2GP8PLcqt59uziK2SgsVaXllhARDd2imhWPD8tSZ
	S3+7tO2iMOHFsIRuf9Ue1h9KruTY8KgQhsG0FfA9uXPecUrE0DDfCvjQm3cp0eokHkc52sc+UoE
	XQE5i8wQy0BLXDEZ4SNbkMyxI3nja4+M4ARdhgdUpPDrVPWpaFxUmNsU/0AfTHo/FepyFPDx7Ab
	fZ3aW24E8Pt09jdztwFHPtiW+hoYz/NN33YwPeHQ7nmJ9VyfoBuoudUN1nypDCNY6Rabb1hC7mX
	GcUn4RlNsvUrTu1+StahSKwzYJA==
X-Received: by 2002:a05:6000:1a86:b0:43d:6e0:9458 with SMTP id
 ffacd0b85a97d-43d642c08b5mr27685966f8f.39.1776177376758; Tue, 14 Apr 2026
 07:36:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260413-kasan-v1-0-1a5831230821@bootlin.com> <20260413-kasan-v1-1-1a5831230821@bootlin.com>
 <CA+fCnZfubV6LgRjO3NQvhrG2Q5o0ftkFFupLWVYS50XDnmCaog@mail.gmail.com> <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
In-Reply-To: <DHSWK17EZUDP.GIJ6BX2NFR6U@bootlin.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 14 Apr 2026 07:36:05 -0700
X-Gm-Features: AQROBzD11iC8gAKSEnmD0t_Id88yG4ZENQr7azgzst5W9dho6pOaDHcgJ_Mytlo
Message-ID: <CAADnVQLJ=fJ7t1i2+_RYqU1gqYqiLP9Zrwo4vdZsgzjK_yzJTQ@mail.gmail.com>
Subject: Re: [PATCH RFC bpf-next 1/8] kasan: expose generic kasan helpers
To: =?UTF-8?Q?Alexis_Lothor=C3=A9?= <alexis.lothore@bootlin.com>
Cc: Andrey Konovalov <andreyknvl@gmail.com>, Alexei Starovoitov <ast@kernel.org>, 
	Daniel Borkmann <daniel@iogearbox.net>, Andrii Nakryiko <andrii@kernel.org>, 
	Martin KaFai Lau <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>, 
	Kumar Kartikeya Dwivedi <memxor@gmail.com>, Song Liu <song@kernel.org>, 
	Yonghong Song <yonghong.song@linux.dev>, Jiri Olsa <jolsa@kernel.org>, 
	John Fastabend <john.fastabend@gmail.com>, "David S. Miller" <davem@davemloft.net>, 
	David Ahern <dsahern@kernel.org>, Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, X86 ML <x86@kernel.org>, 
	"H. Peter Anvin" <hpa@zytor.com>, Shuah Khan <shuah@kernel.org>, 
	Maxime Coquelin <mcoquelin.stm32@gmail.com>, Alexandre Torgue <alexandre.torgue@foss.st.com>, 
	Andrey Ryabinin <ryabinin.a.a@gmail.com>, Alexander Potapenko <glider@google.com>, 
	Dmitry Vyukov <dvyukov@google.com>, Vincenzo Frascino <vincenzo.frascino@arm.com>, 
	Andrew Morton <akpm@linux-foundation.org>, ebpf@linuxfoundation.org, 
	Bastien Curutchet <bastien.curutchet@bootlin.com>, 
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>, Xu Kuohai <xukuohai@huawei.com>, 
	bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, 
	Network Development <netdev@vger.kernel.org>, 
	"open list:KERNEL SELFTEST FRAMEWORK" <linux-kselftest@vger.kernel.org>, linux-stm32@st-md-mailman.stormreply.com, 
	linux-arm-kernel <linux-arm-kernel@lists.infradead.org>, 
	kasan-dev <kasan-dev@googlegroups.com>, linux-mm <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam12
X-Stat-Signature: 98tjoqb74uc63pps63qoh31q3417pntc
X-Rspamd-Queue-Id: 8B51A80007
X-Rspam-User: 
X-HE-Tag: 1776177378-691795
X-HE-Meta: U2FsdGVkX19dPx+QFwZL+OpCS8hBHbMc3KaxV1VKyoBbuQABoNgiKQ7peWvZUSMeVCR6PpyRNZOg0Wy+lLSsjG3O7RmnyKG1kK0GbeXSdn0+FF0/jI03yOrVRmZdHeQVMUh6A0vngAF/TI2B+sb8q2pEvcXZN4meTtyRXQsonf6TRpCEeOadPmuFheyDfDGmmjARIlgN8pbr9R6R9DMOGCYdrZNnzP7iZDcInB9udw3EDz0fTOUN9jM5yzf7hQoCkmsL8wxhSnxi8EWuCL/HBNhZfqhdzLNU9EWt+er1BPcEw+W6jzA1kx7d5gAluzGoX3k+xuQ7GJKb8VSdTEdDk5h17/tP0YpDpblM9ZAdwr9JmA1vlQb8kT9yevcZzJj1Q/OUZdLevMrQJpafDivRmcRmKara96/WHVNxWX1bQILIjDGol0FGS6rZ9hBnielLRpxtx4PmqAhn82CjHz3hayRlNpTyI22O3+bgdbifhPrAMpi931XTtckO5NVgTrOP2ex2qSTNJ7P+iS6to7/EW6CAPpd1z0OKAysOhYm1DjG3ywiXOtHGst1b1l53lDEEewckBcG0QSDB6g1RtjEbWk3pNNjHNtggsCftiFF1QfXTkjGJ1H6zInqROzcHJrMoLeGFIAz9bJooPANkV3n0/+CNGoFCVQUSrEN2yzNqu72WXQrHJhsPWqHR8UoioRcuN5RRvZyGxHXd41Jh9s3Tvn90wk7Oh0C6lUdQF1iycpfOpnpWVQ5JNwq7aq/4114CDDqsFFL/qK2vlDO4QpAD3wZWBDZx6HC424AUb3xnS3fQ5l0+8gzs8RsVDEwzMXBnXjEmP4phojPgdRTBNGfaWtVaRUMNOBj5iwmMnY6JOUXMZKl3fO9rK+wSt6bVuN3kE6bEn2SeD7/OYWw2LO4uzoWPZxXMw/WQyapqWwEordSgyaG1Ipp1JiwMUx6u6TO7C4DBc2E4XCvOmgjMDrN
 xFoTIIhC
 FMZRgVR6N4r0krl0kwv2gdB8EReUHr9IUh9RztmXrfQjkFuH7PoJ4KuK/SsCkLiy3+bqHHqsM5kbKvQM9gK0ATjYbafIKqeWWAzhMQ/ec4iFDMOIxKAIDRWKAqWLidvKNBRFstodWYCJh+Z5WxUW5WT5Immz7AKkM4KDL4GpzaUZ0Xh/gTdMDHEWxkMcbdAs8wgLpr/v0wCgkHK+UldcjiS9Pvo7Fo/KELW6xARSdZnquI9kYn4/AQoaxJ3rQ2w11czuFT9xCxe/qNEwxiuhN3lR6c81UW8C5ZePnr7yayjsqlafldVgZBQgTjySYUqnhzcgUx1p9/SIy8mJFKlZsnAROrnFJLnDmeV3KlQE6sNLl1IdgWIdG1HM0oguXpMkFxVUZFRYiPiXFn/YYTzGpKA8CuFWJznIumIB5iRhpRFLBWUMCBHfd7mnPJwrlqyyZIfvdJVEOJkFnCoe6Q01hx09zne5Dm7IT8e+EJCI8qV7jDS81D6CnNkUO8aeop5cP17IpZ6VITbEcbchfoKZ4IIp17djMtRiXCSi65avWZPZtACc5ik+U89uT2g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Apr 14, 2026 at 6:13=E2=80=AFAM Alexis Lothor=C3=A9
<alexis.lothore@bootlin.com> wrote:
>
> Hi Andrey, thanks for the prompt review !
>
> On Tue Apr 14, 2026 at 12:19 AM CEST, Andrey Konovalov wrote:
> > On Mon, Apr 13, 2026 at 8:29=E2=80=AFPM Alexis Lothor=C3=A9 (eBPF Found=
ation)
> > <alexis.lothore@bootlin.com> wrote:
> >>
>
> [...]
>
> >> +#ifdef CONFIG_KASAN_GENERIC
> >> +void __asan_load1(void *p);
> >> +void __asan_store1(void *p);
> >> +void __asan_load2(void *p);
> >> +void __asan_store2(void *p);
> >> +void __asan_load4(void *p);
> >> +void __asan_store4(void *p);
> >> +void __asan_load8(void *p);
> >> +void __asan_store8(void *p);
> >> +void __asan_load16(void *p);
> >> +void __asan_store16(void *p);
> >> +#endif /* CONFIG_KASAN_GENERIC */
> >
> > This looks ugly, let's not do this unless it's really required.
> >
> > You can just use kasan_check_read/write() instead - these are public
> > wrappers around the same shadow memory checking functions. And they
> > also work with the SW_TAGS mode, in case the BPF would want to use
> > that mode at some point. (For HW_TAGS, we only have kasan_check_byte()
> > that checks a single byte, but it can be extended in the future if
> > required to be used by BPF.)
>
> ACK, I'll try to use those kasan_check_read and kasan_check_write rather
> than __asan_{load,store}X.

No. The performance penalty will be too high.
hw_tags won't work without corresponding JIT work.
I see no point sacrificing performance for aesthetics.
__asan_load/storeX is what compilers emit.
In that sense JIT is a compiler it should emit exactly the same.

