Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CAE81CA0FED
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 20:44:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0FF2A8E0003; Wed, 10 Sep 2025 16:44:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0AD8D6B0023; Wed, 10 Sep 2025 16:44:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id F05758E0003; Wed, 10 Sep 2025 16:44:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id DF0786B0012
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:44:54 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8CFD5856AC
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:44:54 +0000 (UTC)
X-FDA: 83874519708.20.138FF05
Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	by imf28.hostedemail.com (Postfix) with ESMTP id 9D62CC0004
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 20:44:52 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z2gqBD7U;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757537092;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hURlif60FPSjNG3pKdufMNt+U9y26SiGUSn1HYK+xuk=;
	b=0dWBwEksZ34dVq4525IPrMh2MhNjPxoEjKoFPIKC/M4ZVI175EtIwIBW2wa9MdjwM9C+xv
	MAmAbvZYE5/HoEraX0nJBhURIfkl3IWIpk6OQRFIckHblJZAMGVZs2ZCz2mxYX/uNGpV3u
	sBGZXvfluXQUQeMcW6Z0Hbsux7ubHYA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757537092; a=rsa-sha256;
	cv=none;
	b=c2JS0DAU4M8jQD0jtNsqQ7/1o+E3U7Brt/RYSFIxB0ZjsWD/JqShYJpl+UNh+OEsHn8Lbo
	5DBW84EEiat7fY4heKg+k7KLd8t5nPiu+PjEII3Gpc+bI4Zan6NBxwV+uzp+m6bdzr3dy8
	BB1e75NrrtWcn6eoOT4qhYqksy5/xP4=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Z2gqBD7U;
	spf=pass (imf28.hostedemail.com: domain of alexei.starovoitov@gmail.com designates 209.85.221.44 as permitted sender) smtp.mailfrom=alexei.starovoitov@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-3e2055ce7b3so46447f8f.0
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 13:44:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757537091; x=1758141891; darn=kvack.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hURlif60FPSjNG3pKdufMNt+U9y26SiGUSn1HYK+xuk=;
        b=Z2gqBD7URYoN1No5rwnv7D0VAHrllXSU8Du+qz4np691omcmKhuKHbLUK6zIl1xH02
         5+uL3K3tKbgPpwAq5OsJefOrob+TY5zZEaiN9mkyVRncvjVgdeC12JXdFgeTNDuqctg+
         AlRKIjJobwtCiO1u4ZY6GGiOnOQTLVoebNc5Dv9fo5I4Ap++EnWXQHdIujTHEAcycxqM
         hUqYPDOxczYQ2NGHIXKcXgHdXZwyA+VzPqF3u+MR4EBu5WD0ISolWvv70juBq/FB5zN5
         3z8ZaRO/IZzUdF8vDTQhWF6707vSkdTRs650BxYZTbWuBGoc1OSa5WGA7zybk2yoHFZf
         e02A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757537091; x=1758141891;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hURlif60FPSjNG3pKdufMNt+U9y26SiGUSn1HYK+xuk=;
        b=Xa+sBEMpSx3iDSQzM6aRyUHtQOgfZgQSjNDxlUsK3PMgu32+k7vurh5fXmSapUNs0b
         kI2whNHqSN0hVlviUEulBJTG4W5j4KYo3PdKOoJBYNICUGwujikprU/U56UiIco9AhTm
         pLEQBsmELEl1WWKzW413ASKo588BxXc6oNqQLOSSA4U9DSnN7m67j6ripfoxGaMU6quL
         +HlLVwPZ05sDKG+h/gyCh5J475+ZI7LmRUk0S9BGJTytC5y09SYqHVSt2+WozjKeQgtu
         ZDn5uMkFdIGLREoAzB/InoGxAEt77rSVGrJehvMK/KPIpYLgW0WPjJQYNalhBhfeEhKL
         cd9A==
X-Forwarded-Encrypted: i=1; AJvYcCWOy/MZQZnVpvyN7/upre8woD11esJRN1O0O8wKZoNS/8pfFr9HzhGklL5EoCW0J1ej3o/LXf6BUw==@kvack.org
X-Gm-Message-State: AOJu0YwkrDlHieZK68kM3xIKMwzoOpSj/yT20mY0LyAI/TGTDkXcLL6n
	nlWyVVZ/TgA9SMP7LwdcdcsemMdZs9SZTsMRgeXn+Js16lQEcaY5tOkHbYRJi8vFhN5woh9cfBN
	YlAq+jkkswXmgCzTFO0rGqU95iVMXpl8=
X-Gm-Gg: ASbGncsfI12JRA18CWr0ciHlFXmbc88HC98HzBpCopq6acOKxYd7AGNX0vfRcPV9fqh
	91wG8/RazDpRDRCWZQSx3Y0hGyIAjHVcvSUVkJEyEFU0emJk+wkzX/s0BMqRm4681XBpbBlGb3b
	PdK13fnl2Ylz8TijxStKdKsZOdGR5AfAij88NkKK+uvqUX8WeSCWBGt3+DnOK63BFqbIVtzOwhp
	J9AkJsLrCethzoFJlqcEXARrsAjxm5K9qRi5RITOE+9HbE=
X-Google-Smtp-Source: AGHT+IEgKZrxpEMcuKUrNZZ/VjmpOkAy5xtzbBJMsk33KsFm2AIoLuo+xsbMm68dkSaOFsa/gF4LW0lXPvvk+72L35I=
X-Received: by 2002:adf:9c87:0:b0:3e7:17d4:389b with SMTP id
 ffacd0b85a97d-3e717d43b81mr9837201f8f.52.1757537090882; Wed, 10 Sep 2025
 13:44:50 -0700 (PDT)
MIME-Version: 1.0
References: <20250910024447.64788-1-laoar.shao@gmail.com> <20250910024447.64788-8-laoar.shao@gmail.com>
In-Reply-To: <20250910024447.64788-8-laoar.shao@gmail.com>
From: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date: Wed, 10 Sep 2025 13:44:39 -0700
X-Gm-Features: AS18NWC0PddnEh_K4ml7j_4k0fHCbV_INsBk7po365NYjaa9qQUoIAl6ZZzp51o
Message-ID: <CAADnVQJF6YtzOojGV16hmUpFCiZGxuJAi6=Q4TK=VPH=_93eJA@mail.gmail.com>
Subject: Re: [PATCH v7 mm-new 07/10] selftests/bpf: add a simple BPF based THP policy
To: Yafang Shao <laoar.shao@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@redhat.com>, ziy@nvidia.com, 
	baolin.wang@linux.alibaba.com, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	Liam Howlett <Liam.Howlett@oracle.com>, npache@redhat.com, ryan.roberts@arm.com, 
	dev.jain@arm.com, Johannes Weiner <hannes@cmpxchg.org>, usamaarif642@gmail.com, 
	gutierrez.asier@huawei-partners.com, Matthew Wilcox <willy@infradead.org>, 
	Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>, 
	Andrii Nakryiko <andrii@kernel.org>, Amery Hung <ameryhung@gmail.com>, 
	David Rientjes <rientjes@google.com>, Jonathan Corbet <corbet@lwn.net>, 21cnbao@gmail.com, 
	Shakeel Butt <shakeel.butt@linux.dev>, bpf <bpf@vger.kernel.org>, 
	linux-mm <linux-mm@kvack.org>, "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Rspamd-Queue-Id: 9D62CC0004
X-Stat-Signature: 3x3dbks95u6oidzwwitt1fm39dk46w7b
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-HE-Tag: 1757537092-831715
X-HE-Meta: U2FsdGVkX19LwzHNH4pvRACZy8ZGiNlIxwr5N0V6Hi5qlYIw3rxSUwC9zKBE4BtE1Kr129wEDkYN4MGHuNr5kRg1ZbgAghvONLETpN9IKgN+mkUYTd9nv8fZ3NJ00y4f7xURjViTPaallxm3WErTadAcFZ9Z/CP+DnUrKgIsUlp83+J+wabimGthMqDBBQRCehUV1DsMdXu4XwtiXsSsMTN291TLZf97UXFypdljpDxxOeNClxvpq+891U09+PCuf82kK34jEKs3d8xObDMiq+6e5YNIc5mlANYIRQq8ob2XylFnoTa0s2TGgEqVI3X/UqcVCvfIvHRYYg2ccT7DgzBOfQ21eo2ACrhZ+I/r3qE3e76p/RBl0akusjlMYE81w+gDo1GANEtrT8kU7aoAU1bTXJbl3YhTibvZY70qDMywo1mhMlf7xjijkSCl5Bhgj0g8QPEGBhvgtaAGkDpWp4Q94K7uJtgQQoubQMRgslfJkoFkOx4+TSokVHghmLVq+rPPGIdEy7+t1yaU0YGzgSJuvmTutoIDgVh7VDlXphCLzMUvYOq3Vc++s5gQkmjFMA8QMQ5TMnkQNMozOkNGN7RlB8mnuoujuyYdRcA/UBZdpW5uj3K28caD5X+pvnEziqVBRulNhUkwV/1G6J7kXZwPdB5vMwWgZbxHtsgJC1RSr3je2WIXYCitsIVZqdjo+Xa4BoJZBMjYjVrvmH7FOeuxjTsDA1QDVB/ExAw6zsSvjhmH2gCX0As8dCmt0NudwQcnmu+sjrQ+vUW5kCWajOPE8119O1x/oRjCTRYpOf+U4SsW7V6YMlRn/QubbNdh60zK8r2LKFmSIMnsAbkg8ErnFBDWs9FsBJl3DIwiT+tjUPekWhlK6+zonCNQIoThuq31caEqvywWLC618qQl1j2trA026dp84zfU3NZ1pHHPYEba9mFsaR6ecPtunTmPRSumsB9rogu/Ak3urvB
 Mgb6XXSU
 mEUWN6JoKVkQVZkU3Lgejbzb01NwbjENAJFSb6CvMht6l0kTYvcXjkKJcQbSuWhGxmWnmqGbqYaX55kgqBN2Pk69TrH7QCOQSQB5rheYU6go2NYTjyvJp0JHv/KgFPyEK4Jwz4w4e+7z9YI2ZTWawntZBfSJ4OhWKSONfTP2Z4xVEoeMQ2yCL3HrMhLxLQZshWihDWfQlxi74RfxzMWWaM99x7BipzyhzXXaVJsAhZrSDXs6A524bFVCEW7+k9LW0X/0T7uxdcDYnVfONlxGNk7Yk8jQtRD1seVJwy9y/drlb3jzYu/UjLan1cAaqYphJ+G9TuvBmAUMCuDza5k3csXiyfuOmlgp9WWvLuCNusl/MEeb7cfVBVzttIkSk4ln4O+aZ1j8spKFnLi0SCMZm2zsPL1JqxFiXOfEQuHsyxjL0grQ7kNQuW1hAgmXl0oaBp6ttMyyUBoZQw3idfO5Tf2EcGICHD0sW8IIe
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Sep 9, 2025 at 7:46=E2=80=AFPM Yafang Shao <laoar.shao@gmail.com> w=
rote:
>
> +/* Detecting whether a task can successfully allocate THP is unreliable =
because
> + * it may be influenced by system memory pressure. Instead of making the=
 result
> + * dependent on unpredictable factors, we should simply check
> + * bpf_hook_thp_get_orders()'s return value, which is deterministic.
> + */
> +SEC("fexit/bpf_hook_thp_get_orders")
> +int BPF_PROG(thp_run, struct vm_area_struct *vma, u64 vma_flags, enum tv=
a_type tva_type,
> +            unsigned long orders, int retval)
> +{

...

> +SEC("struct_ops/thp_get_order")
> +int BPF_PROG(alloc_in_khugepaged, struct vm_area_struct *vma, enum bpf_t=
hp_vma_type vma_type,
> +            enum tva_type tva_type, unsigned long orders)
> +{

This is a bad idea to mix struct_ops logic with fentry/fexit style.
struct_ops hook will not be affected by compiler optimizations,
while fentry depends on a whim of compilers.
struct_ops can be scoped, while fentry is always global.
sched-ext already struggles with the later, since some scheds
need tracing data from other parts of the kernel and they cannot
be grouped together. All sorts of workarounds were proposed, but
no good solution in sight. So don't go this route for THP.
Make everything you need to be struct_ops based and/or pass
whatever extra data into these ops.

Also think of scoping for bpf-thp from the start.
Currently st_ops/thp_get_order is only one and it's global.
It's ok for prototypes and experiments, but not ok for landing upstream.
I think cgroup would a natural scope and different cgroups might
want their own bpf based THP hints. Once you do that, think through
how delegation of suggested order will propagate through hierarchy.

bpf-oom seems to be aligning toward the same design principles,
so don't reinvent the wheel.

