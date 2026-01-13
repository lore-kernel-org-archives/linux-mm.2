Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DB50D30CDB
	for <linux-mm@archiver.kernel.org>; Tue, 13 Jan 2026 23:27:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 78AF56B0088; Tue, 13 Jan 2026 18:27:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 738AE6B0089; Tue, 13 Jan 2026 18:27:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6372D6B008A; Tue, 13 Jan 2026 18:27:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 516706B0088
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 18:27:08 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id CCF751ACF2B
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:27:07 +0000 (UTC)
X-FDA: 84328528494.08.3E0CBF6
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf25.hostedemail.com (Postfix) with ESMTP id E8A04A0003
	for <linux-mm@kvack.org>; Tue, 13 Jan 2026 23:27:05 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TUACZXJN;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768346826;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=XIxHGmAm1SZZrcYdW9mVCY8ENSWv9Idzn4C9R7aSfY4=;
	b=T0H4dMerVx4RkydqwAPNanFiEO6efv4ylw2ttFwzIxwPNKpk/57NqJ6r3HoXpRi6uqWx6F
	L7E6hBUod+QcQ5GzX+jhYI1BWVfqIykftD3y9iEBrbqF92LsDiF6oc6THGvVLGQE2j2uP7
	7z6qwMOw3arIBOBGcYEtPFYuFBXWJ8s=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768346826; a=rsa-sha256;
	cv=none;
	b=fDZUc4D+XlwpPUrw9DdEuUWnMQU626q7JR/WGgFzvqUK+mu8DTRZfWrjYH3xgdPs51ZXP4
	0ygAOdGoMl30VStb0kXsmsgCCgku6BD1THetcX7EPQeXDNyyzDDZR0rX+FjVYELdmN+I8x
	Dy5/lpF/J+47RbzEnd+LTcEgFzpGitg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=TUACZXJN;
	spf=pass (imf25.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-47edffe5540so7412605e9.0
        for <linux-mm@kvack.org>; Tue, 13 Jan 2026 15:27:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768346824; x=1768951624; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIxHGmAm1SZZrcYdW9mVCY8ENSWv9Idzn4C9R7aSfY4=;
        b=TUACZXJNKMDwGmLqve3XoQ02pvxoZjSHGwT1XFzYgpabsnycCgJ0tQcMcA5xGKYXkP
         PBKlvL6QxuQgeJl23/3WTUJ4oS8HTgZdEspk8xNOnc9978zxhvVA76HW3oiv0VuILZ+i
         hxPW4a7kSETkFnGd9N00eT2xPd06yRdb4HLAehueg5o40cCaeJAOO5Bansz0ou4yY8jx
         qunbxXzzTifMmUavS2kfgTBvLqAJFOy0+ZR1tH6ZCRB66k3uaGVdZkdDPvzzjytVFV0X
         LUlhKRf6AJ5UhyNfbitT50C12Kt85O/UabzinQz6IAxI68vDjhRYEOy8+t5Mi0+CeZjJ
         65ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768346824; x=1768951624;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XIxHGmAm1SZZrcYdW9mVCY8ENSWv9Idzn4C9R7aSfY4=;
        b=txrDKK8HbXcPUwDftGEeC/dLnjRs/QcRB1hCg/EZ4ajSAZI9LMYbKni1PCze28dNnc
         PfGRIgqzkDmQvtUUSr9rV7zL45uUQ5rGfj9UCDZ/PeHZ5T1gT0uYesBVwMpeEqfuDLTT
         I7fhBNiwsSrWYjAQjwF4tcwn9RFZWOjMdaJiTw/t/2ZM+uHTZXGXHM4jOQheHadZNA5C
         z6Ytjlf50QLb7g5NfomCJSKm+GYTi3qrvS6vQI42BOj1ds9k5h83RsUdZYnC9NSdOT/D
         krgPLgSdw73dgLz2IgAhj/uKQISF+JWQOnxgVF5vwWNx2/thOpbt4oK5KRq4JVJrgQWU
         lTeg==
X-Forwarded-Encrypted: i=1; AJvYcCXoMVtQP0JrPYe392kHWiU5m3yY83w67kDZooxiv1KVDRUNfmBU+puzH+8FWMkiT6QgCDczHOzytg==@kvack.org
X-Gm-Message-State: AOJu0Yz9Ik01QY2+EQJjo6uElfK6b1NwZDWCFXDbA5WUVeY1iT0kLJ4u
	ffBrjDnSzmP4Y1dwD5pPw+dAr+3jZErMU+0oHATmR+AxM2b3LxAi23kykt0UZKSXqjhXfC+a2ip
	0T7web0vlD7rw/ptq8mHHbqlfqvQXr80=
X-Gm-Gg: AY/fxX71CRseJLvHvxoKVZZpTiNEScFNRJyjYqtaMbZuTZsoGggeCFYqqAYnLEMJ6y/
	D5uAMr+4G5oE2RwbBD99zkB7UxQ7gMlP/OlrL29RPhpEKlzcTmEaO2GpXbKCFThNRbQglKFQ0l1
	N12G4VH8f2DbKZxqmK49NFnw80aj5rC2E2jjp0XV2Sod4UUcVwWCaukO6E74c7+fPvjyNFgZ2+T
	T8ANny+HaTNi0OnF/3WpQddkhCON139TITTYFdnF6YdmoK/T2vQP5Fe72A5lqi8qj2EliyWwS6G
	fsXPEo9XQVOt5fNYIBG/Qe4bB5om
X-Received: by 2002:a5d:64c5:0:b0:430:fd0f:2910 with SMTP id
 ffacd0b85a97d-4342c501a57mr685880f8f.26.1768346824132; Tue, 13 Jan 2026
 15:27:04 -0800 (PST)
MIME-Version: 1.0
References: <20260112-sheaves-for-all-v2-0-98225cfb50cf@suse.cz>
 <20260112-sheaves-for-all-v2-6-98225cfb50cf@suse.cz> <20260113183604.ykHFYvV2@linutronix.de>
In-Reply-To: <20260113183604.ykHFYvV2@linutronix.de>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Tue, 13 Jan 2026 15:26:53 -0800
X-Gm-Features: AZwV_Qg0xd2SuSeZtzkfObEmnG4DkzskoYODoJFcrxj4bx-h7Wvm-bafCffVqCQ
Message-ID: <CAADnVQK0Y2ha--EndLUfk_7n8na9CfnTpvqPMYbH07+MTJ9UpA@mail.gmail.com>
Subject: Re: [PATCH RFC v2 06/20] slab: make percpu sheaves compatible with kmalloc_nolock()/kfree_nolock()
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Vlastimil Babka <vbabka@suse.cz>, Harry Yoo <harry.yoo@oracle.com>, 
	Petr Tesarik <ptesarik@suse.com>, Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>, 
	Roman Gushchin <roman.gushchin@linux.dev>, Hao Li <hao.li@linux.dev>, 
	Andrew Morton <akpm@linux-foundation.org>, Uladzislau Rezki <urezki@gmail.com>, 
	"Liam R. Howlett" <Liam.Howlett@oracle.com>, Suren Baghdasaryan <surenb@google.com>, 
	Alexei Starovoitov <ast@kernel.org>, linux-mm <linux-mm@kvack.org>, LKML <linux-kernel@vger.kernel.org>, 
	linux-rt-devel@lists.linux.dev, bpf <bpf@vger.kernel.org>, 
	kasan-dev <kasan-dev@googlegroups.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: E8A04A0003
X-Rspam-User: 
X-Stat-Signature: n8ucatqnbqbcj7aym67ytm91cagc4be7
X-HE-Tag: 1768346825-242567
X-HE-Meta: U2FsdGVkX1886xgTbu7TzjAzJstknauqqoW+vF1Fo/wxgeyiH8nX/k45yC4Fj20Z0DwC7T3vJ4vw7HjbUE615F5nZcsYHwVEufInnsKCnPOyh0H2XpARA//LCUoCPJm/VPTnt7qd+a8fqrMoylVy60aBkreB9uYDR+JfgPR5O3/DS7+f3est3D9Old4xOCNL7ze8zeJuPq8aMOE7+UpkNScuKTCulKApD24+i4LYkuJ/8/KNJlvNpPq2Gy884bHmaKCanMTp5peT/yku/H/ktoXVrSq7bSoQCEAVKUUR92KNwp1i2mDKDy1Uh21pHkW3UB8pr0amti7c8DRttQR8785S5H7YDrdcL/02GqoE8O5leAJr3qto1z8Z0aurP185qIuyec0D3NlV+rn0iDyILVGYWYvQup5i8Gn6JzQQDUTCd5OBCnKFp5UUtZwkEMtLwz5oK8UOHjVSpTSbDQVATvlT2X2G5/mmG1QClfDTtsMISLsDFo9Zq4H5he/Dz0LFkGs8X2MF/O4KV0yJyQwDqx0vLwbtmz2IyavwWwHFyvQ7TxH4vXwYSJJACQts/RbxTkjvc5sv/c9dQUP8A9utcQhlt3guKSIuPnPJ2W04YRuJJLVWjKal8YHvCTvyfPFXepGuxbI1KPAwY35Fnkr7KoffZYZe++1AEOd8lZA+xj2et4Fl1mat9GY8/Oou63hHgm/Eq2drE4Zi7+HeVNZzQFwlplhqj8yMkdpVhUBFkf1bOzarYUljl2G9W9GCQ3UJlDmGlECq7gdxfUnkcaKKox+dqlIy7szeJPoRrrSKYxG1GzZzSSOsJ4H2uRyoysrrWofmC2VU6N7j2d2ihq5FlSkkBQGO13F8z5aBoRU/S8owcwbikuXYqRHHgyf7YPyXk/MhcQfKtzuhGU/Sjrxz1YXaAqkoNvmCsq2D1TdAzPHFwa5JsFfqLwESTKkW2IoDSClw1wbSwkQkecE+4WN
 SbXHTo12
 H4r6glMadFGN+6G8aGA68tU2+YFSCR4nVzehcMwuCWg3h6XkmNc52rZcoDlbgE41GS0j4qCGyWimCKvagLj15vQLWdsoKAJfKkm8Hb/Snzcll3SBR3FbZCIYCadRbxQlVwsD+IPMkS0FTqqa00VeQxvlLs/3gs/J0YIaHkfFtiFYlrUom8CAde3Di5J1VtV4qnndxnrQYRxpYlInz3vy7a6xBaFY1J7OT/pSst4p4GvSbmh/xdCkWOouwgvqvDxLKq6Yko64NI6rOAt2fPqy1Odsbuv3s9Kio702xqb6gkCAU8tYDyZ2bORJt2mjutmQZWrP5KSJpNxRBd7sGmyDBToYh6GnMhvVKw/F83XwHEzzCmEdoq00BxNqJFxA/mImbNf9HKMAtLyz4QRVslaA6ccIiy0IsvQ+r7Ikn38H6Fr+6mAF2NhtDkAiSKMfsdm12YBf9+RgSNXdAyPkuwbEdmd7vm5pepIk0Wihih3AmEtnhWts=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Jan 13, 2026 at 10:36=E2=80=AFAM Sebastian Andrzej Siewior
<bigeasy@linutronix.de> wrote:
>
> On 2026-01-12 16:17:00 [+0100], Vlastimil Babka wrote:
> > --- a/mm/slub.c
> > +++ b/mm/slub.c
> > @@ -5727,6 +5742,12 @@ void *kmalloc_nolock_noprof(size_t size, gfp_t g=
fp_flags, int node)
> >                */
> >               return NULL;
> >
> > +     ret =3D alloc_from_pcs(s, alloc_gfp, node);
> > +     if (ret)
> > +             goto success;
>
> I'm sorry if I am slow but this actually should actually allow
> kmalloc_nolock() allocations on PREEMPT_RT from atomic context. I am
> mentioning this because of the patch which removes the nmi+hardirq
> condtion (https://lore.kernel.org/all/20260113150639.48407-1-swarajgaikwa=
d1925@gmail.com)

Right. With sheaves kmalloc_nolock() on RT will be more reliable.

