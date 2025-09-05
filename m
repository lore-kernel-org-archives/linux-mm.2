Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 86119CA0FED
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 09:33:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E30C68E000D; Fri,  5 Sep 2025 05:33:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DBAA18E0001; Fri,  5 Sep 2025 05:33:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA94B8E000D; Fri,  5 Sep 2025 05:33:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B14748E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 05:33:25 -0400 (EDT)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 5D975C056A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:33:25 +0000 (UTC)
X-FDA: 83854683570.01.83DB4A3
Received: from mail-qv1-f48.google.com (mail-qv1-f48.google.com [209.85.219.48])
	by imf22.hostedemail.com (Postfix) with ESMTP id 815EAC0006
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 09:33:23 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=minxI2uA;
	spf=pass (imf22.hostedemail.com: domain of glider@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757064803;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=8dxTlO6r9HaqREYsy2WnogBnYUWROJNvm/8zDKLkYW4=;
	b=XIMgt3BSpU23+96ldWnA+2bacSjXvU0HDTIYNshyM5DQTURJjq1/YrGEOfEEpFHEdZBzJi
	hat2Sm0MUhmxZNksmVO8Pu9bxEkHqPNWLjBribcGB7IZrkYaouWhtn7qL1k3RsmOJf4AtN
	tlmcMXFt3JAFNzgg9ss1TCkdl6o1ahw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=minxI2uA;
	spf=pass (imf22.hostedemail.com: domain of glider@google.com designates 209.85.219.48 as permitted sender) smtp.mailfrom=glider@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757064803; a=rsa-sha256;
	cv=none;
	b=zjALXlRWk8fwIdCTnwU/eqDmyvO0/qq7/fYasMiDe5vLFKhMJcbH/EfAZVkWJIzrF/oyIo
	k6dHqCWXGb0WOYv5Xl5n1YTmZHn//wnHmhSKQp/vMiR++PTrcnhs5ETluz6bBFJ66D2V+A
	1MtDVoaMINnuBiLAlyW42YV7izYnBYA=
Received: by mail-qv1-f48.google.com with SMTP id 6a1803df08f44-72374d6a6caso20501506d6.0
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 02:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757064802; x=1757669602; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8dxTlO6r9HaqREYsy2WnogBnYUWROJNvm/8zDKLkYW4=;
        b=minxI2uAnscKecn+LJPLxb9VJtA2qUO0tQAKu/PjrTyu2ugj3PLJ6YV/eWmZbuJdJp
         0tWqB0D58sqFc8VBRWd06MxBMggarp01bTECydkkZ0pk0bJZdiEKw+PFBcIIeMzN3Q8l
         igE10SAlFC3R2w8bFgFNpnlxqyhAv0pqtWt5sLMvw1kkZQ35G1oI10WMkzwnilum1SV5
         C62hhYVyuTVmCa1FtsnfeVemBui9T6jBBXwx2PzLsMBbOHbbWEp+++ckUWmxhB/BBSAx
         aKQEZXLhvaLaqti+Dx+HG9B7nd331S0G3ddzT6ktu9bsPLf+7yst8SQjhUSvcdVwhNY8
         GuFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757064802; x=1757669602;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8dxTlO6r9HaqREYsy2WnogBnYUWROJNvm/8zDKLkYW4=;
        b=b2pkcieZpaYcZBq1qXs+9dujPe31BR0GhFh3MMUhH9LEmlnwfNkF6SehanOBX578k1
         ylwQvCMCRhpqZ7az6vZBWd2uordxvu6HYbnhTyVMNb0rVHAow2vM0vYdoWtUio3HOvTx
         95dxJJFjSrYDcegyNsHwCDUBOiMrC7S0CgL3LEfQUo2OXGU2ECbOgLK52oUMGx3dKdHM
         78EcqMyhWd2nSN1Cpg/3cBgP6RejASHgystq47qi16UxZ2SMwO4Z74TEGH/9jsVhDgp7
         PpJ17dQ1j2cmnh13fYt5jVjh4vh+qwpqlamHmYa6sD+yoguNtDL7H1Zvp9RFA5Yw4QE0
         uWiQ==
X-Forwarded-Encrypted: i=1; AJvYcCU3VAGwIbaRBXmkeWFPrOseq8oqP6iYfBm3AdSwlMJetbOabS6NXyvN2wSmAJA3DUw8ynzMn+whgw==@kvack.org
X-Gm-Message-State: AOJu0YxdFuzQXWoW6z+FwPawfw9WgK5dVSrbmOpwJaLQuVY/o9+Vmchp
	URUy5R8b7LFJkOXwgWogRQkjwOYGv0O6ifY0Ln9f8PGOtkW1s7Qa8c27968oi/gvBhQrLQEzKoj
	imadksGk+x5m63Q+L0WBpeT9bRulfYamlxfrsCXU2
X-Gm-Gg: ASbGnctslf2O7e1/YOzANacsDKQatnttHxaBtUSh0svLy4oxuivziT5JPCQjO3y9a4t
	AWsoFqETEWjmjQxRKYhQfJraWTuXKlyWNKyo/2WlWSn03E6gdATt+OIbr8bj+ZZwd5CCsiBMF30
	xNZMqCy+6GRE50x98gcwTKDkGwDxKXZIFjyTTDfcvq+2oWEggRWSwSzQwTqOZxpI3BKOXbi4k1r
	zYweEuuFnA/7ek0aXYqvBTuJPRlEC5+uw/bPcqibrl+SgqbTBATHEI=
X-Google-Smtp-Source: AGHT+IGQkQamDqV7XCEOyIUgjXvJXRgsMMyMEK/W8ipJeEavgvLDykrYzw3fu54iUR6ZTuvy7C3FIAyRxwYRKqoZ2rM=
X-Received: by 2002:ad4:5ae7:0:b0:71d:9d4c:1907 with SMTP id
 6a1803df08f44-71d9d4c3002mr190638486d6.11.1757064802234; Fri, 05 Sep 2025
 02:33:22 -0700 (PDT)
MIME-Version: 1.0
References: <20250901164212.460229-1-ethan.w.s.graham@gmail.com>
 <20250901164212.460229-2-ethan.w.s.graham@gmail.com> <CAG_fn=UfKBSxgcNp5dB3DDoNAnCpDbYoV8HC4BhS7LbgQSpwQw@mail.gmail.com>
 <CANgxf6wziVLi5F5ZoF2nwGhoCyLhk5YJ_MBtHaCaGtuzFky_Vw@mail.gmail.com>
In-Reply-To: <CANgxf6wziVLi5F5ZoF2nwGhoCyLhk5YJ_MBtHaCaGtuzFky_Vw@mail.gmail.com>
From: Alexander Potapenko <glider@google.com>
Date: Fri, 5 Sep 2025 11:32:45 +0200
X-Gm-Features: Ac12FXwv0qVlytn5UPR2kOevtwfln-V7rGK7j7x55WfwpJGZ-qo_gaxhqOnmQY8
Message-ID: <CAG_fn=VL1j42TxEoWD8Z3jO0uvU0j1JNzPS3BfUXd5AGE-nDkw@mail.gmail.com>
Subject: Re: [PATCH v2 RFC 1/7] mm/kasan: implement kasan_poison_range
To: Ethan Graham <ethan.w.s.graham@gmail.com>
Cc: ethangraham@google.com, andreyknvl@gmail.com, brendan.higgins@linux.dev, 
	davidgow@google.com, dvyukov@google.com, jannh@google.com, elver@google.com, 
	rmoar@google.com, shuah@kernel.org, tarasmadan@google.com, 
	kasan-dev@googlegroups.com, kunit-dev@googlegroups.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, dhowells@redhat.com, 
	lukas@wunner.de, ignat@cloudflare.com, herbert@gondor.apana.org.au, 
	davem@davemloft.net, linux-crypto@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 815EAC0006
X-Stat-Signature: nqhd4y49cgsjrjzbnekrnogec6san7jz
X-Rspam-User: 
X-HE-Tag: 1757064803-100587
X-HE-Meta: U2FsdGVkX1+8MhX5p11fOm7TJIj1KkzQKVRli2k7gMYlQrrkHG9UxaRfx83Ru2Ba4u4K+1z9nZJaiCEeZQot73IJGe+zkdEZb/RHV1dh+emsyegc9jUYQekEk+BYnH9Gs0RxgUPwrkDRS3uc191XLVT06DzANWXnQDmvDuSOb2p34C/ZFbptns+9XEX0F1OSsKc/MHDYeG3VdpPmuhXlQpMzq+K1QwZTCVQw7lZk9FcCk4oHI6jZwZdzvZ8zBIQ361V77dcHIpcddMEiziDjdjbKfeUgCXw9G/5aDlK8zbyTMnciI8AJhv4bsuhCWTYmpLf82itAdnKLyC5OOfNgixBK74Cs8JomvGZ1QrSdgvbWgIMl5LeZ7BKejfxG4h/NPoF/gX7cbaQfrYx5+frF6fhcEmW5kbc+2U1cl/1NqN20LrdFlvUjdJzfuicJ+qF6LtjPZMchLBv8aWMFG9IC+ewmwcHcksnVYGMsgRhrRlT0EV5DYEiBykfyMwc+o/lCAmrR0YQsHQHyv5dP9bOIYxTLGjewHL+xmbSZdg0ikknjWfTUx0VTZ8tCgkFMDhL4JSKE39Mnj/ORYuOWjCfWeMKMo9HpiSrZTftuB2rHzbryRPS318C1hKQoO0kGtDeXwq1NTtTeO/E6ubxbDHDn1A+oh9L7HCY891+Nng4BG0Ac7Oy20nUdYksWr80g3mZ0O0QTPe6I0p3rXssCk4pHP1zK3ID6a2tJW9WicRNmekSFiOBsa6AMzWz3Ij8FQlbPFa2nhu/agH9UWIagRv9TgrI5/W8wfkRiH7dxT6nsPgRfaI2ofwgNWQOOIp9kHaSGGjqPjmUFXA2Q2cI8Bbrpuleiue/PK1duGqYk/E2SXEpJLsf7HuLEZ/iZUPVg3gqGTMMY3tRxAEMk5AFgZlypi0DZjvP4gjeP+Zjb5Uae7lURgmM4vfm1d8wEx74PLcY++cOkTXW745z1SI2v6IU
 80MQg2Z5
 HXKpKcUM0YoNfTvuQqyP1YNc3/kRUw/3MlmcmmcK/Jqu8/xqQccWK090MXJbWvh8onxz7Vi5uzM6x7tzlBf4f/RtLbvni64Y39FtyJE6yJU+eiLhMygzAyewgRSk6PS18bGWETpmL8gCcrVjsRcsdaqFu8d4jPnVuGUeEJLZVQZdUobrT/2wDqovU4wkOM3tQYiSiszq4aVKyL946OtEMz0mR31q4+qeHHEkGzbjlB8IR/jaCfcOo7QsDwAmR2ipe3wJwfS+Ki22xP+hY8Ww25bAeI4QfyhaZHsUhkiBaQHEQd4fui454ZUyiQQuwJX8A+7CSLgBkVtwPxcbacBpM6u+OXBbC+NJZPlAV26NKrAz+Z70=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Sep 5, 2025 at 10:46=E2=80=AFAM Ethan Graham <ethan.w.s.graham@gmai=
l.com> wrote:
>
> On Fri, Sep 5, 2025 at 10:33=E2=80=AFAM Alexander Potapenko <glider@googl=
e.com> wrote:
> > > + * - The poisoning of the range only extends up to the last full gra=
nule before
> > > + *     the end of the range. Any remaining bytes in a final partial =
granule are
> > > + *     ignored.
> >
> > Maybe we should require that the end of the range is aligned, as we do
> > for e.g. kasan_unpoison()?
> > Are there cases in which we want to call it for non-aligned addresses?
>
> It's possible in the current KFuzzTest input format. For example you have
> an 8 byte struct with a pointer to a 35-byte string. This results in a pa=
yload:
> struct [0: 8), padding [8: 16), string: [16: 51), padding: [51: 59). The
> framework will poison the unaligned region [51, 59).
>
> We could enforce that the size of the payload (including all padding) is
> a multiple of KASAN_GRANULE_SIZE, thus resulting in padding [51, 64)
> at the end of the payload. It makes encoding a bit more complex, but it
> may be a good idea to push that complexity up to the user space encoder.

As discussed offline, it might be good to always require the userspace
to align every region on KASAN_GRANULE_SIZE or ARCH_KMALLOC_MINALIGN
(whichever is greater).
In that case, we won't break any implicit assumptions that the code
under test has about the memory buffers passed to it, and we also
won't need to care about poisoning a range which has both its ends
unaligned.
Because that required alignment will likely depend on the arch/kernel
config, we can expose it via debugfs to make the userspace tools' life
easier.

