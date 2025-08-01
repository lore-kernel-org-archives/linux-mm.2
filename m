Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 81BB2C87FD2
	for <linux-mm@archiver.kernel.org>; Fri,  1 Aug 2025 19:31:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 25A956B0092; Fri,  1 Aug 2025 15:31:01 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2308F6B0093; Fri,  1 Aug 2025 15:31:01 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16E146B0095; Fri,  1 Aug 2025 15:31:01 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 082A76B0092
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 15:31:01 -0400 (EDT)
Received: from smtpin05.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C732EC021C
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:31:00 +0000 (UTC)
X-FDA: 83729181480.05.737CEE7
Received: from mail-qt1-f179.google.com (mail-qt1-f179.google.com [209.85.160.179])
	by imf02.hostedemail.com (Postfix) with ESMTP id EE69580004
	for <linux-mm@kvack.org>; Fri,  1 Aug 2025 19:30:58 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TDVS6FJI;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1754076659;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tn75XQYhjJo+TWDkRdCfnZdS3TGmeZchqZWPBeig22E=;
	b=GR3Y62fTbg9kT/K/Jg1kdmmhadY+eck2oj22V04XnrqeiyMlwBkOBO2/NhWLA99jTAcxiV
	TuguzLQZqXb4RKWgDy/93X6qrfx2i3I3h4CeELDoNcW8JAUjUlfRXVO+biqf2jtgkt9+wZ
	6JENfEHEQpLEv1lTYV+b+tYMJRKDnm8=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1754076659; a=rsa-sha256;
	cv=none;
	b=RjiRtsdraerDT47QgeIzRcZjFwwof+hoSBZbJ/T2/jHjueophWtdz9O00ProDN7XlWW0Zg
	9OQbqfShhKqWFbqtw+UJTguQQVRCxbaM1jy7ZYOdXpcTLbixwHx8Zn7wAIyopp1D9VYngV
	Xiaa70kKbYycuey+dVj0rhL4cCPe77A=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=TDVS6FJI;
	spf=pass (imf02.hostedemail.com: domain of surenb@google.com designates 209.85.160.179 as permitted sender) smtp.mailfrom=surenb@google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-qt1-f179.google.com with SMTP id d75a77b69052e-4aaf43cbbdcso481cf.1
        for <linux-mm@kvack.org>; Fri, 01 Aug 2025 12:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754076658; x=1754681458; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Tn75XQYhjJo+TWDkRdCfnZdS3TGmeZchqZWPBeig22E=;
        b=TDVS6FJIapq1Z4flQFSDK7K8IzbUUkK4zF1r6nUTZlgj08hqNoQDTBw+BJQPBpK4KD
         1EnnLU26pQpLYL2QSMq4Ypiv0kDizDM9ydrVBTEcZQQSPHWgRfRny03CAREwRQ47rnQW
         4bv6yxasE/JXIFr/L+u0boCqOxp+R/sKYY/azG3KD+f9u5NepPDvN/d+mSCgaQekvN6T
         lKD7E+vIebwnt9kOM2lMstAb3ZqgpSouUDWEvSSIbO7/3V1rB22lCfhvpPz43HIuWA+c
         K/uUXeZpCFnCGWxxuUXDqcup7AU/G5Wei6OKp2SQKF4MLQBQGLVLZm1am2srT4lzKqkD
         3kug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754076658; x=1754681458;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Tn75XQYhjJo+TWDkRdCfnZdS3TGmeZchqZWPBeig22E=;
        b=a6Ij/kDMFKyrag1dcus3ZAbtKCfW/HYExExrOu1bJvJob1W9teE9zMxGhUCs3PzmtB
         6MHxsGLY1m8wIdEz1pjQyCiz0RKtpd9Yja1DXlpjQXWVpMEqP5uQzMjMg99aAeHq0N+z
         ZFO48VWaNM/5WwARXYRcE82R4CEm9CSj/8Q0o3cdo8ZGKCUFZkNVcwSmJ9jvKprTquKb
         2qlgmmqNTF/r79pwGtLzFc5dxLWYU8ORo0N6mFJc3dNGfrsqCXQf5NksnPItH0AY7Kau
         dv0u8TkYsFhFMzW5ALCPWf5qVUAgd3Lig3OE8CSAEOh/R6i6Qftn/acFlpf0NUGHdPS/
         /qPg==
X-Forwarded-Encrypted: i=1; AJvYcCUUHesQYiA6UH8O8WDOcxk6bvkceplW3RfNEZOUUysf5z+uu5V2qvKcb9Ds774JWF/eLPsBfrJpxg==@kvack.org
X-Gm-Message-State: AOJu0YxP9iqtP6evmjLNi7cBw3LzVTwYDv66sc9vFSXoriRayp1Xw8VY
	j58DSdskIvMsIHPwM8MEz+kXMuzmgbhDfcMOhIeWDo1dov/r1rs1rkVb+XK+iE8T4zuNChGvfot
	ef5hRTGpLd5ZY7ldCJHpveBIoXocUaVvaH5d93tk8
X-Gm-Gg: ASbGncug9dAldHGm5jW8sNu+tr7dB4eVy9IutwYGYA7pBCoXINrtWvr74m4NJLeLBx1
	52OANCL/0nBBzuoSyEsliAibhrvyL+7GIcSjwMGaB9Hxu5aLSLIoQpv3g/j68+z48K3pG082rPU
	8EJeFwWu+L6WZDdWjl7gLbodNyxA1mPxVjcyZ+aS3bU19ektanbWtEYp/ue5qSzr159Rgv80tbt
	Ai49yBF8CsOkgVm0X8c9V+Ep4JZecQHuQs=
X-Google-Smtp-Source: AGHT+IH0mW5f/qmqu9jwFpseJ5sBEGT+3smSxDV4uopSaI0KwsbmE/+dq3CsqpUFK06gNcNwwYnxKt51RS3MEF3u6D0=
X-Received: by 2002:a05:622a:1984:b0:4a7:1743:106b with SMTP id
 d75a77b69052e-4af12de2691mr759991cf.6.1754076657499; Fri, 01 Aug 2025
 12:30:57 -0700 (PDT)
MIME-Version: 1.0
References: <20250731220024.702621-2-surenb@google.com> <20250801183833.30370-1-sj@kernel.org>
In-Reply-To: <20250801183833.30370-1-sj@kernel.org>
From: Suren Baghdasaryan <surenb@google.com>
Date: Fri, 1 Aug 2025 19:30:45 +0000
X-Gm-Features: Ac12FXxvF4QVnElqOuim-YcXYx27wMsfO8zYCFlPV8Iub6EM4IPZ7MZ5jF-KLug
Message-ID: <CAJuCfpH+bXgm0RK=CRxD_evnwkdeqg=-hrf5dtejCMXhxg5cpg@mail.gmail.com>
Subject: Re: [PATCH 1/3] selftests/proc: test PROCMAP_QUERY ioctl while vma is
 concurrently modified
To: SeongJae Park <sj@kernel.org>
Cc: akpm@linux-foundation.org, Liam.Howlett@oracle.com, 
	lorenzo.stoakes@oracle.com, david@redhat.com, vbabka@suse.cz, 
	peterx@redhat.com, jannh@google.com, hannes@cmpxchg.org, mhocko@kernel.org, 
	paulmck@kernel.org, shuah@kernel.org, adobriyan@gmail.com, brauner@kernel.org, 
	josef@toxicpanda.com, yebin10@huawei.com, linux@weissschuh.net, 
	willy@infradead.org, osalvador@suse.de, andrii@kernel.org, 
	ryan.roberts@arm.com, christophe.leroy@csgroup.eu, tjmercier@google.com, 
	kaleshsingh@google.com, aha310510@gmail.com, linux-kernel@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: EE69580004
X-Stat-Signature: xb7m1r7p7swggwkhd5efnpz9g5oyppp1
X-Rspam-User: 
X-HE-Tag: 1754076658-369837
X-HE-Meta: U2FsdGVkX1/lGVFq4fedo0Wusc1DWc9jYzCt4IJfoY+qscuVSf3JoqTxF2vdWOgGCCDUNmbmEgSfNsSKQ++RDNJgJ3ExM4bv3fNKtitSCWRVVu8YixHJw0s+Ml20InWsO/yjzXYANP5pyYpQyTJtvN5+zV3NSnFVT3enObwom6x5/JVkPHico/JWLoUCnAORwYlO33tMridXXTmcleBSimHk0+n8DF/P1Tsa/LDWLzR3eg7V4TG9X3REET87KroYXIlKFVd6fSr059vufFUjIt+LwZrDLtXwXO0hfw5rHAZiZPm6ZPH+bvdgYDHjyukjA/6ExjiIhdq5AkAJuI2oN66V8M+46kc1m0wv/OZHcHEDhhJcxzTqpRmEUSlh+i3pcM6g4C0PeC+wcWFu0sE05YJVlfiafegY/JG9brTVPmWUVRGIYixGPMZayZeGXm/yzapxqp59R6+zmJaJHp92pJrIqpQwsqL6C38Nmf102I0a/N0ytU9PS5PW1RqDGFFRGjfp/z+AH1Uw6qXPf4N8bdVFULIkjB7j2eileufqHt+yxIHgyqC+txzMu/fIsHMz0Bs2kNXncwOeXH5suVDPQjMsdQCwtG91IXoBPAFRtfwW+2I5nEHLNBy6aWIuMhh7KcMWQzY/xJ4iohYorQI4OaQwJROmZbxRvjHcjtdQeG+NffU/xd58SlJo5RFG/dQS2yV+U4KcWHGkdc1j3ZxZgUNIXRLt/N82qftp7KjOzu1l9rJ5Rhxqdw9aPV30N/n5v0+rghPq0KAAvU7ltMzFvZWWMvD+AMlpPmxmNrX/WoIw4jZ11/kn5fSP0s2Ood1sUZ5zQsjNVm7zzubh2pb6SL4s4NrzjJyXVlPv8Kzs8kgCu4WgAa39IXYduj33qpMFH6hh8/78ql4o1MIE9BkDO6QxHZZ6XoTG5XQhfyEJjuiQ1Cc0/ivE4P5GIuADLWvutXhItjgBJAZszJQI69/
 Vil+aOZ+
 bZLDk3Yx+uNiAKqPuGgyJnf7Tdf/rSvIwQsu3Y4FsmRaYW1XnMvwJNz5z0kkcGVMh5VeLC8W130idJT8FditsrFNOxF6m2d5mt9lMKKwWK9mSmpSTn5thnfcRv9Q0jbdxCzL5ZhN7OgTGobZ0ypLN4SupMaGsHbc4LhmA2BYn//N3AAjC3P+EWjhJ2Jc9FCM+mQC7hXY3Vvnb8LYAkthDPGBaZOZg41l3ZJp2qb/r60hgx8D2Y/KPqLipWyfYxFbSwoGiRTEhClwm3UwgjfhfAdIhgElBvlMZDuJSx4zcDcSbxPAdV7MTrqC8yA==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, Aug 1, 2025 at 6:38=E2=80=AFPM SeongJae Park <sj@kernel.org> wrote:
>
> On Thu, 31 Jul 2025 15:00:22 -0700 Suren Baghdasaryan <surenb@google.com>=
 wrote:
>
> > Extend /proc/pid/maps tearing tests to verify PROCMAP_QUERY ioctl opera=
tion
> > correctness while the vma is being concurrently modified.
> >
> > Signed-off-by: Suren Baghdasaryan <surenb@google.com>
>
> Acked-by: SeongJae Park <sj@kernel.org>
> Tested-by: SeongJae Park <sj@kernel.org>

Thanks SJ! I'll include this in my next respin.

>
>
> Thanks,
> SJ
>
> [...]

