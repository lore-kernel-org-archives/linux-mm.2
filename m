Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 61C56D29FF8
	for <linux-mm@archiver.kernel.org>; Wed, 14 Jan 2026 12:12:14 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A369F6B00B1; Wed, 14 Jan 2026 07:12:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9E4326B00B2; Wed, 14 Jan 2026 07:12:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8E6A46B00B4; Wed, 14 Jan 2026 07:12:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 7C4266B00B1
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 07:12:13 -0500 (EST)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 189FF8BB44
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:12:13 +0000 (UTC)
X-FDA: 84330456546.20.F5EE388
Received: from mail-ej1-f52.google.com (mail-ej1-f52.google.com [209.85.218.52])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3E342120004
	for <linux-mm@kvack.org>; Wed, 14 Jan 2026 12:12:11 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z6ij4VKA;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1768392731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=1rGqz/gMgDRPKjhaZqP775Rq/dAcbVIsG0QbsrtBS4E=;
	b=2Ezxz0Xtjr325fLrRX7qOmOcRGMM0Mln0jBV/0ZbvLdVBvGtr2SLOInJOvv610kk6SJjN4
	K1ByIIdsKDKkP89Kt39kfTdMuyMrvRueOLhwCZmkzrWpRfcidTUn/qi1vV1EMhxP2VF3iH
	up7ekWly8tqXItVE6ab7FCrIFr2bCU4=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z6ij4VKA;
	spf=pass (imf29.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.52 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1768392731; a=rsa-sha256;
	cv=none;
	b=iCZf92R3EXVfEU79aiGesXnyvgLP60wg2RNreSxkrhIL9yajEkC5cQLo1Tap/a/Dq+dPoS
	+AElKQZEXnkc6T98BH3duCl1zpEkAKed7OSz0QZUKGAumkOk8iQozIni8EnZzM+NSn09oX
	PPOw8ZFHs6kV7DhzzZxS9Y3l9sVvqg0=
Received: by mail-ej1-f52.google.com with SMTP id a640c23a62f3a-b8712507269so467654366b.3
        for <linux-mm@kvack.org>; Wed, 14 Jan 2026 04:12:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1768392730; x=1768997530; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1rGqz/gMgDRPKjhaZqP775Rq/dAcbVIsG0QbsrtBS4E=;
        b=Z6ij4VKA26kvCUbFxba7mr9jk5EZsiFiWv3e9sjZIQ4o6n44F86aBciilZXT+BqiKF
         74CtahDtaYTtsruPpoIv7llCmgpKPWxY52NZPtCzks7wt/RCidLxwMTCdJUW1P8kqzSS
         bg7LX/2XfSz6WOIN7XEsgw+nsqkTEX3oCucX37QmdZGm1Ou1Gg/oWva3JHa2Hbp/qk0B
         s5evgWtRzMcfIJpwhBcHnOA2FcgIuDcHUtHURhGiMjdTXrvFPdGlnk82vwZ8Xdzp7yeI
         4HW8/8JdeqKakQ8PQND2ly9TDY9jQ2ZtF/0yRtjhvgq/0M9LFgCvA74EkrYt1KyDq6g2
         gtVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768392730; x=1768997530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1rGqz/gMgDRPKjhaZqP775Rq/dAcbVIsG0QbsrtBS4E=;
        b=VJff0K2XzRAYgTLLhOjooYFKktvhbQV/8i6Nr3beawUm8ROppHic79DIB4kIAB9fc2
         fzlJFw8pe658XQAeLCvDfk0iRgjMb4rB/+L5RfMHkq7gMepehQVTSvpoOBHV6qLJWPMV
         uTghkcS3WyXSC1WaiICsC2y6ZktXxLN0lyycHYx3OZ3DWFZFEwC7w4HUPDEVGyFBUOud
         5pFK6lnvMnxuYE1ciuiG5/+9vM9kTKnDlzyjFtT2aVcBmxqqC4f7RZLYDzkF4ympmzLC
         c1kQs5/uREOtVqHn/+c50rpDpfGFXrcHJMy7CHMtjYuqpssTfgMsEoifZB5dr3/oCefY
         RnFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWQuQu+wYPJThREuuLt0gcRxezVD0LXXTVLS+5u1wtyuAXE9UZtIxOe5Znx1CYrC1HCit3kWYlRQg==@kvack.org
X-Gm-Message-State: AOJu0Yy28CLhthZXzqXKlUTzlYumnMAaJgPpQofSQ+iL28+w+VthviLX
	5EjOrJ1QplW5HiWwG6tSk90qO8CgdnZG2wpZGNCHb/XyZRAoEOWzXnnHTYiz6cIkBDx/tZcaxKl
	wt9XsrTKJ/Ak3Id2PkxgRZwf9cKLQIJE=
X-Gm-Gg: AY/fxX5sWaEwEIOZoNt7NAMHyjGoA/shW4H1rDbqHpaR5xY4UBpjrkgTHTlo0yM7y82
	pH7kpPgyF6lFcSiaczf7Gv9tfxZipfznOtl0QRW+/s2dY7quCy48I1vJLIwS6d2d/Ca5ut1CUFp
	8i9QB/BcKoaiQ7lTs4JPAMdz56pDgEtW/bRcLlIET9M6+wyGi9L+GFytJId5jpo6S1ONcE5SAeQ
	NL2T4v82HyHhAXGO3SI7BCq7EXO9kShpP2a99YcMKzQhvks7ex6JriMgkV1sDaxpWHMzNM6otdn
	HGgwCjPKggs9pt41eL7qGw8UJQ==
X-Received: by 2002:a17:907:9303:b0:b80:3fff:3369 with SMTP id
 a640c23a62f3a-b87613f478amr224281166b.48.1768392729408; Wed, 14 Jan 2026
 04:12:09 -0800 (PST)
MIME-Version: 1.0
References: <3d8398f1-0130-4d3b-ac54-d23877811747@kernel.org>
 <20260114113635.97621-1-lizhe.67@bytedance.com> <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
In-Reply-To: <97413239-2bdc-456f-8511-65fb9f1e301c@kernel.org>
From: Mateusz Guzik <mjguzik@gmail.com>
Date: Wed, 14 Jan 2026 13:11:57 +0100
X-Gm-Features: AZwV_Qhyda5VT99rWo8U4cVfhODtVTVmRJzF6cL6ZtMnMgSKrpNB8Y3wfLPK_qo
Message-ID: <CAGudoHGb1w92gn89BBuMQOmvcVZkwvt8CK8hFtGg3xmHphmiEw@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] Introduce a huge-page pre-zeroing mechanism
To: "David Hildenbrand (Red Hat)" <david@kernel.org>
Cc: Li Zhe <lizhe.67@bytedance.com>, akpm@linux-foundation.org, 
	ankur.a.arora@oracle.com, fvdl@google.com, joao.m.martins@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, mhocko@suse.com, 
	muchun.song@linux.dev, osalvador@suse.de, raghavendra.kt@amd.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 3E342120004
X-Stat-Signature: 59hs4m3cwx6inzuzb1rqi3e6p8iytjpx
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-HE-Tag: 1768392731-323814
X-HE-Meta: U2FsdGVkX18ZiGgTQKAR5oVdMRF+BODntIzBl6jUtShb08FAZ6RffYjYYA24GwYhJB7b2qGJh9NtrI0VsCoMJTm3ktgypryMtU7MDeKFRrFhz0fQYaK+TxfU7I2a20h1gpHVl9OIfl60mbOAFdq5XBcLupVlbLQCDxi2eOOfU5qErPghXvpdHQFkR7d8OUMOedNP+tCDa3S1tmuubQf1chGryF1yLMG7Gr95130cJYWUhPUxr72VY1KWjqRFYr8u2SnvUBuSSr27EIbwyV3G/HkP2lYS35blQPNr0zrHTfBhFy2qfRvdNnvgNZdqFLU9rWYyisokSVrm/bpR+MBI0IOKxWQTLLOpLnG/7ufaw9VECd3tK6a8ARsINvETzd1I2RWRBBnbV3c2pEbgMRg4zTaco8fOP/BY8mRUvfA9Y1a0bfelt7o0d4wqOny9w5pmMS0BETyNKLSt2Pjuig3gEzqvzT2LvzH3wLI8OZI2lWhSA6hinL5wZcR6DtrJpNsBo4Ewz/mgFeVeGHJZ8ZKEB7G8TSoOdrys/M5K6l3/P8AMyUVLJAdo4DVZCzEka4uLZzqMW7K5hWyuzl90Cgr9A8XuDPoOFK3U0jUcmPzrpjIKjCdNpSLHaUm+y3Vg4rrtz8mXmCqFyRBXFVzqHajQmsHfmMDE+7DNBLL7FjoD+TnZcpZxqrf89rmUk9xBVJvWcJAH02Hl6t7o2q3ROenvsq3SgqFGd+p3PLvlTuAAtjNLYZ2Gcl+SpB7/oIRHqFuMWl5M4salQlnJ4i0vvqmdSyN2q/spb/HiIj9FHCpf+sidPAekcXb9mOhwNl0NU0oHWPJ+TZ1gQHA6UCF3h+uR8FyBreqw4fwF2I1nRkMxHIsjiOTEAzVqvoVYDhbusAWyRuXGFC2a3dlfgpFOm6Q7rC6zzLxDE1b6h9/AiWo8+RqD6oyTlNQenCN4qHl/FgolHH/oZOF1ycLeBg5Cf2n
 UF1zq+Un
 /VcNNrH209MjysEddk2uVkpNuGT5TopuQ0pFIRQZKHMzP6qM0HPEjH1pVvRcDuKEflSrNB9NhJ2DMazeih0LBRDRuhYD64qcZJlh3bP+5WIybV/Z3OQhcJEj5KGfbWz1smjngy8R32BuiRoJAnMIpkE6X6UjVdX9fR/xAYUs2zG8c2h4WvPb/ONrLukov/jUqtkN5loDPTJ+BHQao/BZpuV6H7ziNJ4UIJH6qTV1PrJtsk0VtGFxEDdm9L/VMKK3MmBRIdIujC6qe/1po7YK+tl8ivXf8RAl1mhia7A6NCGcEBQgKSYRkmxZyw1Sj8iINdFaYV7lZHCUC7Nx8rraSYKDYr61xuIhrOP0yghhdbyFkZBrendea9oNnNrV6gVXPDWF+qM+YzbHPXYS0BzwD8sSZksKxUAwUwvYtxKcTWbcHORz2UL2XuCo5pTcX+5+KjDgrkHtPBP7kkm4vfkmAwMz8Kg==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, Jan 14, 2026 at 12:55=E2=80=AFPM David Hildenbrand (Red Hat)
<david@kernel.org> wrote:
> You said "I wonder if implementing hugepage pre-zeroing directly within
> the kernel would be a simpler and more direct way to accelerate VM
> creation".
>
> And I agree. But to make that fly (no user space polling interface), I
> was wondering whether we could do it like "init_on_free" and let whoever
> frees a hugetlb folio just reinitialize it with 0.
>
> No kernel thread, no user space thread involved.
>

i don't see how this is supposed to address the stated problem of
zeroing being incredibly expensive.

With machinery to pre-zero and depending on availability of CPU time +
pages eligible for allocation but not yet zeroed vs vm
startups/teardowns frequency, there is some amount of real time which
wont be spent waiting on said zeroing because it was already done.

Any approach which keeps the overhead with the program allocating the
page can't take advantage of it, even if said overhead is paid at the
end of its life.

