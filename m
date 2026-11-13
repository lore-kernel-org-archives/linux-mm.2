Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E746F606A32D
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=google header.b=Jw5EYvc1
Received: by kanga.kvack.org (Postfix)
	id EF9946B05B1; Fri, 13 Nov 2026 12:54:37 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EA69B6B05B2; Fri, 13 Nov 2026 12:54:37 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DBCEB6B05B3; Fri, 13 Nov 2026 12:54:37 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id AF90A6B05B1
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 12:54:37 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 3A4A0801AC
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:54:37 +0000 (UTC)
X-FDA: 85430845794.01.6735C84
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	by imf01.hostedemail.com (Postfix) with ESMTP id 0E27D40006
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 17:54:34 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Jw5EYvc1;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794592475;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=9tvCvtyBDwclMOHXQzuvgqL/VLhDVcOm2ZijhPSIJ6U=;
	b=MEI/gGRqbfTLfidoJhDCgDX9ltpLoGDRBvAedcM3OfpcE9UTTpZEpRyeYu5Ua4+m7vbPP1
	rC6+zeesVEv987x1v5q10/0RviDcsZVwvNnMPNtsc+630VTo6FzFIEiN0IXZCZwkIdHij0
	bHqC12ClQ5ZXAW2zMuAapf4iFfHEU5k=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=google header.b=Jw5EYvc1;
	dmarc=none;
	spf=pass (imf01.hostedemail.com: domain of torvalds@linuxfoundation.org designates 209.85.208.43 as permitted sender) smtp.mailfrom=torvalds@linuxfoundation.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794592475;
	b=g3LekGgDkRS4neXe/3Nv9WEiZmVGRk/yTFyja1NChWegQU+NV3Xmdy0Opfs0li6ZcmI893
	fzeCsDW1cKpwcHhfgRdbmkAxwo8S/W4L6/6pT3Jl5mDzyUmeUfj4+0IA1+tKpGDsCp70LB
	D+RCnpq7Ls/W4mALkKs22rw6Agu+AEw=
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b596afb4c5so1831746a12.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google; t=1794592473; x=1795197273; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9tvCvtyBDwclMOHXQzuvgqL/VLhDVcOm2ZijhPSIJ6U=;
        b=Jw5EYvc1q3Pn9pzaQsLDdhLYUFC9SwV6tNisDp+GBB9LRtOSOnXam0g3CW0rVyNUu0
         xvOoPv2P8z9C6DSYkADbmDhtWe+7Cxy+Jo43zb9eqg8tFwp0O94fqdrk5J1CVERGIyrB
         EilyM+28gY6Recne8uw/MD+0dmUGRhvEihaas=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794592473; x=1795197273;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=9tvCvtyBDwclMOHXQzuvgqL/VLhDVcOm2ZijhPSIJ6U=;
        b=ckvA7njVptIvy/X5w7dP2VLqtDoMyf4fiNQ3QPQ2+2OPp5ilalZu00zjkSUM+0sD0Z
         Oq83hyCms3+59YWaaZQkI6XAoYe6DfzG9KQOEwujoQh+UhPMivabJ3Dz4yQ4a0Ekc7YN
         l30THBHyS25zcHsT5YU8a5rBI/gHQcI0U9ZNworVmBpLXr+O61nLJoA+Qqk9rDCljwl8
         yOniz9TKATenWy8CY18r1C+ZE6loaJv4u2WxiYQR1Vif1N0130vj6kNxfEDudO7znESA
         /cW8h8hnYXofjdMsYv44QbxWXY20R+Tsylg3P0Oyrl/0yBr1vD73nPzzR5k1OjmRa8oN
         jIKQ==
X-Forwarded-Encrypted: i=1; AL+hErH7w/Ozq9lTbkMpzjRqJFwaa06Q6+TEa8jTGUv0X/LPkomXxwc1zEXjsJbgzXS4u/vSIug2DXvSGQ==@kvack.org
X-Gm-Message-State: APuU4Z9bwr3EWKx9V5Zc1pQC54xhntnZmObk4t3CDfagkPPsM4LL3V5m
	20QksZZ4KpyNgy6OnNZq0GOYs6ccj+AI89MRrpniW4XocBvW5y3TcVL1I94Y/QMXyuL7Quz1lCE
	SuG4A0pgktg==
X-Gm-Gg: AYBFou2IRp+mkkrH2on5CsGr378hi9H/hXm43Jg4YQeVZeCdRHrN7mzLd/uPP9uiNaP
	J82gD0fO52GwUuAqQ9lvY7cns5u9tKeeKjBHq7Ni1GZDqykw8cPaXHHf+LUQO9xtzLyuQ5pt4vk
	RbSPgZf0a+6ZbmsaLSKUqn33NiEIaETQjLL9rPJ39qfUAkAH8o6HVbFs8rv9W9J3SAdrux46yXN
	Qs7wW468oiSfVq+ObiejXhtSUqNF8PHoZoCoM9cKGbU6iTFp0jswrzqz19yFZZzE1IwjkCmcO45
	CjmciV2B9XMC5bJkfZokWOFviXNHHJh/BF/lvbM1g8wDwtnm18OEQqn2gxiEXNKabC2Rzadm+K7
	J1qsJFnXWe/6rDP+KqfyVIpZ704ZS1nlKdJubVJKX7fayLVjGuKKjRdZIY+uF3uHaFwJA05r/YS
	Jgt4Zia2K6A+zzt4+purMfLZdBg9Q1LzI8gQK4QvSvf3UPycGqTNUtK/d2YwS7WR+S2p0dCNqmA
	9zUP+COsXPBPxcW6g/sq30B25plskmd5Qtq+D0zfdl+TQPI3E2Gucd4VOgEIyuLeZlfINXG+tWX
	G7y6m3bmDZkG8jqAhbacB6PxS2qchmIX/EYYpkprw33gGNAcB/ByZ0R2ho2nhvOquWaGP0rqkwA
	NAg4=
X-Received: by 2002:a05:6402:42c8:b0:6b5:8695:f838 with SMTP id 4fb4d7f45d1cf-6b7c0d1d417mr2634314a12.39.1794592473070;
        Fri, 13 Nov 2026 09:54:33 -0800 (PST)
Received: from mail-ej1-f43.google.com (mail-ej1-f43.google.com. [209.85.218.43])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b7c236110bsm1324041a12.7.2026.11.13.09.54.32
        for <linux-mm@kvack.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 09:54:32 -0800 (PST)
Received: by mail-ej1-f43.google.com with SMTP id a640c23a62f3a-c4d28f75d62so315971266b.0
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 09:54:32 -0800 (PST)
X-Forwarded-Encrypted: i=1; AL+hErFspnSDk3LbUqZ0F+jZQ5xxk2/fck16KqqAhVYIsZXDPLDKUgR2GI0ybknKBgnYh2Ah3j7ayiebNA==@kvack.org
X-Received: by 2002:a17:907:9811:b0:c41:9228:baef with SMTP id
 a640c23a62f3a-c5096328cfamr296705566b.8.1794592050271; Fri, 13 Nov 2026
 09:47:30 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
References: <xdzcyoou73blpfdlgy47i2ktrcsffnclerzojpgrxphid54gjc@nicdcvzqx447>
 <auqtTjXhD8is-y9f@gondor.apana.org.au> <CAHk-=wiE0KG+jkhmJWifXuAVivtB63WCWtdEpGAex7-T0SHd2g@mail.gmail.com>
 <aurAxRpCwzeyXeVj@gondor.apana.org.au> <CAHk-=wgPvbYRcKpQ8WTH-EYZRgMG0KSH+cZxY5-Hyf+X7JjWsw@mail.gmail.com>
 <aurJZ81qnbiHH_P1@gondor.apana.org.au> <ausS3LQNkdc6lBy3@milan>
 <auxDm_YO4oACA_d2@gondor.apana.org.au> <CAHk-=whXvVO6a5AreZu3LPBj_wjpzUanwhvu8WqWP2q7g5S7Vw@mail.gmail.com>
 <auy-7TvVzJ-VCrG4@milan> <avcKfEvln8_2a7fJ@gondor.apana.org.au>
In-Reply-To: <avcKfEvln8_2a7fJ@gondor.apana.org.au>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 13 Nov 2026 09:47:13 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com>
X-Gm-Features: AclHuK_LoISNmN1EyeTV2FunZOXs5TWqNCSWTUd1ttcLDz0e07xK1bcusX84qg0
Message-ID: <CAHk-=wg9baZ9EDhZr7ONxjuO65+vvWFo5E2hgxt+3rYo1vnhyA@mail.gmail.com>
Subject: Re: [PATCH] mm: kvmalloc: Bail if called with soft or hard IRQs disabled
To: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Uladzislau Rezki <urezki@gmail.com>, "Liam R. Howlett (Google)" <liam@infradead.org>, 
	Davidlohr Bueso <dave@stgolabs.net>, Michal Hocko <mhocko@suse.com>, Baoquan He <baoquan.he@linux.dev>, 
	Alexander Potapenko <glider@google.com>, Andrey Ryabinin <ryabinin.a.a@gmail.com>, 
	Marco Elver <elver@google.com>, Michal Hocko <mhocko@kernel.org>, 
	Andrew Morton <akpm@linux-foundation.org>, Thomas Graf <tgraf@suug.ch>, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, maple-tree@lists.infradead.org, 
	Lorenzo Stoakes <ljs@kernel.org>, Chris Mason <mason@kernel.org>, Alice Ryhl <aliceryhl@google.com>, 
	Andrew Ballance <andrewjballance@gmail.com>, stable@vger.kernel.org, 
	"David Hildenbrand (Arm)" <david@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 0E27D40006
X-Stat-Signature: jsg3xh1xhsbndt3syf4aagjue65ieaca
X-Rspam-User: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-HE-Tag: 1794592474-518273
X-HE-Meta: U2FsdGVkX19TMCGnzxtZ7ROeBLgkGDAL6BeMOLnOs0Yot4X3ra45ohjDH1qAoc8nwhSgP5VAA+3Kpga5mzyEZSCoht3Ceo367vz8agqcstMMocbQKJm5a0M8nl09TJYATc6cAXWiuY1DtucagtNTqEMJ2lyPzjCNyXntQa50Jb4dP4h1A7kh8AiQ2JOqhhg4XEVYos50hPhn5V/PzDyobM6MZxeaPZyTNXxoLc68MAx+eEWmykLBPXn6z6D9zbrxNAHva7LWkQ1rluq/9iy/ZFxIISMnej7mCxriClhY6TAreVGpW1cf6QDyZVaomEe02hy9+Jcl5YgN1fol1FXFRQ9w+clHhttSwaG+P5I2/VGDJUwBngCImYfR65cXJZytwmmyKHs/k04e0bGxeQsCC5FoqeUcvIZd7/2v4CoBPm3LlMFXG8oE1BsEF/DWa7tBDFcab4mwXSOHYJDAvjQxcJgD2tserq8+Ge0sZQBddBZ5B+VpM3vGG9zvRiUcK2iwlD/eIuj5slNlZI0Hy6RIco+KNTlrAqpQrRgPmn730RaF//5fDAPO+5/1ZVQIn8ZYoM4B6ukgoY0Wf1d35yTDXXi3DguOY/POJiKTNzc+8z4vzwqs+ZdfBZm75mNMB1w3DS8ErJkTdRxPhWK3S9DvkPmHH2+SuEgR3As/guoBtpVfbPOYkNhAQ1cWtRmVYQdA4zdga8tHCAG4p0ZDxW+weDVkd+5Jf1EOaKIQeVw0Y886ggJxr4XDorD3KIZOXMU2fbaSvDC3QlRTB2y61RQDnd5FKsnMQUbiLEWDd8ApW4ZXcHFtFeejC+/2UdV/fyA4CR5RimjlMxVYXkNQCVI7P2bBrtIqKR/3w2QYT69hRYdz5Gut/5/j/V1Of7CUXAxPq13knqupegoxDPiiienGxZ4Gql3l9INi2101wnvA7Ic/Mnkwzz/EtK3M8VQsT7TViB0Jx6tmXIdZwD2FpHZ
 BKnMNDWj
 h8mJslxZ3+hv54a/WqoqPHB49WLVGMn2cp7ONcpiim4TWV2mTv+3J5/B5SQ9kezqI61aOTLPQxmx9HYQ827dwNWkOK+slPbRys67sisE7RLqWPDSsWO1seh76db03VNUW3CDR1PsKOYcK40JrDu39dv9snCgoH7LeA8mVr5ZfmlGyDaWnGXlZCZkCLE/th2AAp4tGpmiuXYZytc60sLgdvjYkitLNSJ/3D9tnHFIq98CAoy++6/61Dtwl+BgSxB3+Glkd+6uTLziv6obtZPLokn8Huw7PQ92a9BV+BhHSf+g1x02u/mXpkIpudn1Rw8fwuV9IffR+sXeZL4q630YEwV+7dloh5v21ocjEPQCVJJo/eZnDtrG9n0p3QkqBsGSLWgNVCclFFZecqBxOp+LBrW3aASdCHvTuYKYKKicqQviFwUPNkmjPj8rgZGWquCKucarwFFmfMW7n0T/w5/vMFA/hHG3HOhiL/OqF6iO6kg/nIQYvW5B0fRlGj5g3QnUNeniB+XXVTwWTspMjEe2LU1OGtrbdW2jcU/d21QwaCRsEglaCWORNb4eJZrgSRcKpqfL+AY/f4kLBGgQ9j0GK08F99+JlVyuHyVNmoL/ENhbY+degwf55L2nGKzmBgG5lpjOebVsXnynYMwM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, 13 Nov 2026 at 05:03, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> OK let's try this patch:

I don't think this is wrong, but I do wonder if we should at least
have *some* way to detect these cases and report them.

Also, it turns out that in __get_vm_area_node(), we have

        BUG_ON(in_nmi() || in_hardirq());

so this call sequence already has a *limited* test for this all. It's
just that it explicitly allows softirqs, probably because it used that
bogus BUG_ON() pattern, so it wasn't a debug aid, it was a "the
machine is dead"

I wish people would stop using BUG_ON() and friends. They are *only*
valid for things where "something bad happened, I can't recover".

That __get_vm_area_node() is not such a case. That function has a
perfectly well-defined "what to do in case of errors". It already does
it for lots of other cases: just return NULL.

So using BUG_ON() is wrong, wrong, WRONG. Commit 04aa71da5f35
("mm/vmalloc: do not trigger BUG() on BH disabled context") was simply
not the correct thing to do.

The correct thing to do was to replace the buggy sh*t-for-brains
BUG_ON() with the right sequence:

-       BUG_ON(in_interrupt());
+       if (WARN_ON_ONCE(in_interrupt())
+               return NULL;

and yes, that would give a warning, but it would actually fix *two*
bugs at once: it would fix the bogus BUG_ON(), and it would deal
correctly with broken code that thought it was ok to do vmalloc in
softirq context.

                 Linus

