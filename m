Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BD308D5CCB6
	for <linux-mm@archiver.kernel.org>; Tue, 16 Dec 2025 10:10:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E2A026B0005; Tue, 16 Dec 2025 05:10:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7CF6B0089; Tue, 16 Dec 2025 05:10:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CAC8E6B008A; Tue, 16 Dec 2025 05:10:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id B427C6B0005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 05:10:50 -0500 (EST)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8D57A14047A
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:10:50 +0000 (UTC)
X-FDA: 84224915460.30.91D35FC
Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	by imf23.hostedemail.com (Postfix) with ESMTP id B48A9140005
	for <linux-mm@kvack.org>; Tue, 16 Dec 2025 10:10:48 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V625+1Ty;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3JjBBaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3JjBBaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765879848; a=rsa-sha256;
	cv=none;
	b=8EKEbGlLABA4FJm2LCbiaw9glqYsDiJp7hI6ZCqDEVAZjxoXCD5cA5aM8aYWpH6nRuAL0v
	VP7dtI5ba2EWUjL2SuNNJMCOlWIZoreEMJZr1LLoP5T8yrt6FbnkosA8AG+FinJzppIkyF
	j//V/bPFbdssBRydVS1pUT0jEYnKUzA=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=V625+1Ty;
	dmarc=pass (policy=reject) header.from=google.com;
	spf=pass (imf23.hostedemail.com: domain of 3JjBBaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com designates 209.85.128.74 as permitted sender) smtp.mailfrom=3JjBBaQgKCNsG79HJ7K8DLLDIB.9LJIFKRU-JJHS79H.LOD@flex--jackmanb.bounces.google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765879848;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t5rEzB0XfV2HhggtoY+1nXODslnee9LcIT7edg43TyE=;
	b=wjNc98jPmxZ88MHl9prJdYG6knYgEEndAtqtDEnczaTkI4Qha2/PbBDBnYT2mPnNV7bc0G
	IHhjc/lBRpwy1wdiBocPGD8wXAKs5egW8TevRdVyj35Niv+TG6RehG5cEhVrJxA/Xdh/tx
	JnWq+WIytvyXkSFtu3avcb8ejMromsI=
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-47777158a85so51098315e9.3
        for <linux-mm@kvack.org>; Tue, 16 Dec 2025 02:10:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765879847; x=1766484647; darn=kvack.org;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:from:to:cc:subject:date:message-id
         :reply-to;
        bh=t5rEzB0XfV2HhggtoY+1nXODslnee9LcIT7edg43TyE=;
        b=V625+1Tyra7uV+kZrZYVJmp0hGOvV77Gi+2pfNT9Yp5+lraaaKd3yZM1OO3QuboDUY
         TI3t/B+iegFHQVjIC9v3DR5PaMInxUe/RJPzAN+Ur3DlLCYB6MyMTXy1gfp3XKO2MUfw
         dO6hriNflo30tEfcM2IxkVTlyKbJ12ff7EdPvzku0z1MhaV7XtMbPZn+12Q/R5pVTdhv
         7Dl1x2Qii8btjTJdA/i/E/1fkC+P5g8I/7j970v9nWlBsrs50iV+RLIiCKS8EiEdFLSf
         NI3+hMOqPMTCTUtfhTbim4+Yxlx7/8iLFil0lxwx33SA8pSLvDIDCQFzq2CQi7vDuNbd
         qrlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765879847; x=1766484647;
        h=content-transfer-encoding:cc:to:from:subject:message-id:references
         :mime-version:in-reply-to:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=t5rEzB0XfV2HhggtoY+1nXODslnee9LcIT7edg43TyE=;
        b=ZBFggLT41TFV2BR06jpP2XFUgIA1/IebeZyn5hG85x/wh+a65RYKHE8PrZ3xjrROvf
         5YIy6Kz9f/LUqmmFlpG6iXaxCn3cr5cPGRxj/x/kvGCvNQkQq79O72mcz0j9cIP1o3uI
         4y/25OtXXMHK+iE7iLqHlsaXFWShk1BePUhim20h7owPmFiFJj1SnjJN4QKa6qAQEfiq
         EXvR3TxbhsHFZZwfbwHQ5II/SjqdAKy8S2vcDWX0O9EkBM2o7f8CgGr4wvl7hioogLRV
         SBh5Z8hCtkLe/4vMLhNB/MHROVX+hGODc3bRlmL/MuXUVsC3GhpQ3M4Y/LhXpoHnUC5l
         9qWA==
X-Forwarded-Encrypted: i=1; AJvYcCW+JSWcHj3ztGUHZ4G2WfR77lFcDKLnaWaKJig8LRbZ/C4+NACiCV9aK5sXPPClffKWYqmMWMqTSw==@kvack.org
X-Gm-Message-State: AOJu0YwrSe34fB7HhnxIsxcQX/63jaADWH6Q+7fkoBdyIUz7E5SCDZzd
	LbESjHfX0VDdO9u3Te0UHT0V+B9NQDl3CU+aen/ZXR6Rv+Pv98aJ1FGhUpXEtXylTBte5tYuWla
	jo7jg5+xmAHf6rw==
X-Google-Smtp-Source: AGHT+IEd1DtqS9iGujKBf5Wl3HxnREueKAOxGRaJlybjiAz1XyBUCEjyQ5pN21ilTcLVd3HJFgAC3/iwKoa2lQ==
X-Received: from wmbd22.prod.google.com ([2002:a05:600c:58d6:b0:477:632b:1238])
 (user=jackmanb job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:600c:3104:b0:479:3a86:dc1a with SMTP id 5b1f17b1804b1-47a8f9155fcmr137796355e9.36.1765879846765;
 Tue, 16 Dec 2025 02:10:46 -0800 (PST)
Date: Tue, 16 Dec 2025 10:10:46 +0000
In-Reply-To: <aT/drjN1BkvyAGoi@e129823.arm.com>
Mime-Version: 1.0
References: <20251212161832.2067134-1-yeoreum.yun@arm.com> <20251212161832.2067134-3-yeoreum.yun@arm.com>
 <CA+i-1C2e7QNTy5u=HF7tLsLXLq4xYbMTCbNjWGAxHz4uwgR05g@mail.gmail.com>
 <aT5/y3cSGIzi2K+m@e129823.arm.com> <DEYOI8H2OESD.1H56D3H8HKILB@google.com>
 <aT/WOAr4osoJWaMS@e129823.arm.com> <DEYP7JSVTB9D.3EFN2KEHH3O79@google.com> <aT/drjN1BkvyAGoi@e129823.arm.com>
X-Mailer: aerc 0.21.0
Message-ID: <DEZK5U2YP6I0.27VJHSVK14646@google.com>
Subject: Re: [PATCH 2/2] arm64: mmu: use pagetable_alloc_nolock() while stop_machine()
From: Brendan Jackman <jackmanb@google.com>
To: Yeoreum Yun <yeoreum.yun@arm.com>, Brendan Jackman <jackmanb@google.com>
Cc: <akpm@linux-foundation.org>, <david@kernel.org>, 
	<lorenzo.stoakes@oracle.com>, <Liam.Howlett@oracle.com>, <vbabka@suse.cz>, 
	<rppt@kernel.org>, <surenb@google.com>, <mhocko@suse.com>, <ast@kernel.org>, 
	<daniel@iogearbox.net>, <andrii@kernel.org>, <martin.lau@linux.dev>, 
	<eddyz87@gmail.com>, <song@kernel.org>, <yonghong.song@linux.dev>, 
	<john.fastabend@gmail.com>, <kpsingh@kernel.org>, <sdf@fomichev.me>, 
	<haoluo@google.com>, <jolsa@kernel.org>, <hannes@cmpxchg.org>, 
	<ziy@nvidia.com>, <bigeasy@linutronix.de>, <clrkwllms@kernel.org>, 
	<rostedt@goodmis.org>, <catalin.marinas@arm.com>, <will@kernel.org>, 
	<ryan.roberts@arm.com>, <kevin.brodsky@arm.com>, <dev.jain@arm.com>, 
	<yang@os.amperecomputing.com>, <linux-mm@kvack.org>, 
	<linux-kernel@vger.kernel.org>, <bpf@vger.kernel.org>, 
	<linux-rt-devel@lists.linux.dev>, <linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: B48A9140005
X-Stat-Signature: pokpeqsn8kxto6nmemq7fu654o5tcxct
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1765879848-216237
X-HE-Meta: U2FsdGVkX1/cuX1aO5K52wginszsHhG50aUeiGgOJw8o5TfgZbWP3Da/JuUhJsShC2CvYXsoI1Pe2prXqBavxxD+MQKKSyt4Xxt/G9TUtl6LPMbGfzwfQD4EhM0xqViGBbelIeVqJyUJ6gjj3MeCl5+hyJZAC20hML/qsjd7lG3Y/l2EnadsIJw+22hCUbCAZx6xGLPVSRyNtqRimJFcqRHvhEo9LIdiLp7QO6fVpGtUESWtrJyEBJofnyYJt34gIdrbpOu/S7ueitcwLtCR4mbgj92esANUE8I5Y7qnMBJLOb4z5xI29oIrbSJQtAt5QFEYHcafr/u2v1KCyxNKhnUJgXPvs49CZlA4dTUPKlciuYnPutUDnYqLXYNsEkEGd7j/gdJyN3ad8EjoMTlUpciUVlI/G1+/y2M8C+udSeXhnrB7yPWlFuWvNrlR6lozI0pGraHQqdhMIBzFht5vnh0yS2hek7E2PiaNRYdU4ghDKMYK/TVPSdJDa9NIsHwyR80KW8jyNy6d32jzK3l8UoeZHpqv1ryAKZkfLG6uH4FMi6Oxk1HgxBSY8SIpoN/Gr9JGvvZEtrpKc8R0gtQrGv8P71A30crGF1F6YPIvfGZ2lSUvH/hX0eabzKReugIxeygZIRjl3U5mVMjHoLGxQwrxNRtFRo/cnaLfY7uOVR3xFXKeQOTk+pNt4w3Lfng2luAKUqJ0xz30OTwvyKtMox24cZXTI5imnoM8wC4fJUlBiZrAbBob8EtbkatW9ouwLcmTtJg49CvtAvswvlnpelLTLS3Z/jbkIhsKwlCVMWyUPOmHGd8VDc3+T8ldLdPRTj57EpajLfYQRVhKXsM3DnkJbyy9AO9z0mGnrEJ4h9+xssicyVIxXXFZT+vMNqmqhlWCHg4yV3U5SFrNLlK8aIZpUVwvCzoBv92ScbzJ3SKKnF6Gs1rJmt/j0lltdf4RdbEe1MqF8nxoCPU8B7m
 Dje81Vtm
 i13nV6qv28cBWZxvD7cs5JWj9L1ntp9bxxopn3KsOu7Et/RQ7hBZBtS5cQKUoEdLx7x0L2vLnUE1J0rKpi7HJhoLXoUE0WP5SB73qQ9n6i388SjTZxKdk8/ocqEHSEVoLO01wRro/MtoyyPIWEqU5NRKcrc77mS8+VC1apP8hT06P5oAoq1IRkgELLwLj15vsEupewPcQbvSb7bOatufwgN2/vkBb1X66T5CixgJG2nDbsrtPoICQBDaTa4uF0RdZk3K5nIR+Gr5BPK5D3TM6DcKIZKA3NRqz9U8hawYBuAmxkUlP0MDblhiaa5NFKEBPokxJbBXjzSp4HbxUeMZ7oSwiM9LIaifnNA5NVR0YTsW0AN9/FJ41HJ4mWukz424DG3jNpgxP1MgtylQr5T/A7Te05ziWTAY+y6I55FPZKz/CWYMHgtEExIUB8FPkZQSwdREM1NenP/vscS31LELBuwo/T+cjsKB97Pd5GBypAUojvXJ3tvidDQ/B6KXCI59vYyZ9d/DqMLz8kPxvSt71fHfqghyGwobBOHmJseSLY8amV9u/g0OmQOoH9LDxCqIGEYR4TzCCZbKVbRu4Rh6qrySKE1kmG4B8YsuoARPHpKFmGckPUr/Nekyh2ptnxvxmRpMIR1aI62N4NDwA9a0s+SrWYqHdBVCkRT+mIKyPBFp5i433jdyckjR8VQ==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon Dec 15, 2025 at 10:06 AM UTC, Yeoreum Yun wrote:
[snip]
>> Overall I am feeling a bit uncomfortable about this use of _nolock, but
>> I am also feeling pretty ignorant about PREEMPT_RT and also about this
>> arm64 code, so I am hesitant to suggest alternatives, I hope someone
>> else can offer some input here...
>
> I understand. However, as I mentioned earlier,
> my main intention was to hear opinions specifically about memory contenti=
on.
>
> That said, if there is no memory contention,
> I don=E2=80=99t think using the _nolock API is necessarily a bad approach=
.


> In fact, I believe a bigger issue is that, under PREEMPT_RT,
> code that uses the regular memory allocation APIs may give users the fals=
e impression
> that those APIs are =E2=80=9Csafe to use,=E2=80=9D even though they are n=
ot.

Yeah, I share this concern. I would bet I have written code that's
broken under PREEMPT_RT (luckily only in Google's kernel fork). The
comment for GFP_ATOMIC says:

 * %GFP_ATOMIC users can not sleep and need the allocation to succeed. A lo=
wer
 * watermark is applied to allow access to "atomic reserves".
 * The current implementation doesn't support NMI and few other strict
 * non-preemptive contexts (e.g. raw_spin_lock). The same applies to %GFP_N=
OWAIT.

It kinda sounds like it's supposed to be OK to use GFP_ATOMIC in a
normal preempt_disable() context. So do you know exactly why it's
invalid to use it in this stop_machine() context here? Maybe we need to
update this comment. Or, maybe actually we need to fix the allocator so
that GFP_ATOMIC allocs are safe in this context?

