Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D0B0EEA853
	for <linux-mm@archiver.kernel.org>; Fri, 13 Feb 2026 00:14:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 85F236B0005; Thu, 12 Feb 2026 19:14:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 80CDE6B0089; Thu, 12 Feb 2026 19:14:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6EE896B008A; Thu, 12 Feb 2026 19:14:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5B9736B0005
	for <linux-mm@kvack.org>; Thu, 12 Feb 2026 19:14:54 -0500 (EST)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 0214113A9F8
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:14:53 +0000 (UTC)
X-FDA: 84437512908.07.BE3A024
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf11.hostedemail.com (Postfix) with ESMTP id F37FA40006
	for <linux-mm@kvack.org>; Fri, 13 Feb 2026 00:14:51 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NULLTRhf;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1770941692;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=IZOOjMHRTBJzKVIedfGL7gf236fJildms0DgDpjegcI=;
	b=zlcFdc5ypyYSj61EZ7VUvPGTQrECFN8M6UIpIpvdn47v5kRL4h2GrWL247U/eNHz+al3oc
	j1rDRwDxUBEaiRKIrNiGsFMX+xmEio90kDi0gVPOFc4zMa9iL86SOIFphJ8eij4idG5t3B
	45zZCPybgiNKLxz9QxOIsjWuSPeBz3w=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=NULLTRhf;
	spf=pass (imf11.hostedemail.com: domain of inwardvessel@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=inwardvessel@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1770941692; a=rsa-sha256;
	cv=none;
	b=l6v8r0huH/u/z7mQpY/NzT/XztqOoqMeC6vhjvglABP56oDIxwo9D+wIU2T2yHGR4ssTfU
	JqQHwzpCXiQKBEZ7h/9KBsMweguEagoLSC0np9NJBuWv6QUeA3VA/WW4c6GehMqyKof40e
	moDGufok8laAb2ECoR0oREOdkkcJahY=
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-124a95e592fso1319987c88.0
        for <linux-mm@kvack.org>; Thu, 12 Feb 2026 16:14:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770941691; x=1771546491; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id:from
         :to:cc:subject:date:message-id:reply-to;
        bh=IZOOjMHRTBJzKVIedfGL7gf236fJildms0DgDpjegcI=;
        b=NULLTRhfy9+15MK7zI7UgH0z1iXUrQxgttW8GQfVvU8yTqWjU/yMsfJtEcdqtvO4D/
         VqqITe/ReuujxCKJf0BR/QQY01EMfnuT0bFDG0rtLwmdE5Lk1+UsN+K6UjwFPi0Oltex
         +W32xmU1FyUpNSn/QQUFmm6XOSGm21NldJcTGSR+gmYwuMUq0/TODzhDqhzAoWI4Obxg
         S977TbFA8KSKeKpSaCxkhoZWyRuTIljjGnmKOXtWKWylZEjkOg/BZ/m0ECMA0/8M0gn9
         mC9DXaE1nw44euGxOgEPSzAMuetsRy3ecOWzFffPLN5wKo/r+A1sC4gEBMbAAbb08jRJ
         D9RQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770941691; x=1771546491;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=IZOOjMHRTBJzKVIedfGL7gf236fJildms0DgDpjegcI=;
        b=WW66ThhJ4HrRb7foj1BK2hR4Od6SZAMN9NTn3/ib/LZh7Mh2gXu3iD7JbUbcALmXge
         1iWL7FZpsPdhb7Erqmsi2wSxehIpBKxaEGlN7V7n7R6P/mpNtYVTBM+8IdLcIsRheEie
         DVkmzNs/RxuauZ8KQ6sVPByyPVz4QXvBmYMai6zNSpzT4NUswMk1PgDF90dqsxAq3x0u
         qaRBBIzGx9rJzjpdaPKflvdwLAAIINA8wKfzCQ1WpkoV1IE5Cpfn2wWbdX3inP18tBVy
         2B7DBLkBkZ1ql3pWt4PBCEN7WzbKsNUgbpyK6U7yP5zuMNhYRoYu6CkPW+xDFoV9IRAe
         1Xow==
X-Forwarded-Encrypted: i=1; AJvYcCUxb6XiOcihAxTUEV5pBgBRyFVhNE0ITiZ78Z6IbM6xcQhiQKsSBMWVZWrlBIhvMJRssp9Fqsiv6w==@kvack.org
X-Gm-Message-State: AOJu0YwZWPrdI+/6Cz7uqxf9P3RR/G/m+pEOS4QpHSIpRSBWSxXR6ACz
	QqOlAjc1BJnWHjNRbpsTFknL3gVx3P1/drWIfVn6jSdM3mlxqCb78W+4
X-Gm-Gg: AZuq6aILkP7/+C3udyNAUsLS29Q+n4ZF781nyVsLTOZA3rRuv1isT+CNz65YxyHEeqS
	yqRqwixYP/KLxRY8JgJ20GdIo2W2En5gVoHCNILRT5hRzq9lcy4zpumbnPaV1xGX7ReQCccxtEr
	jKG/k892V+pvDXUhjvX/v88Z8VqjFW14x0B8NeZGlefyqxFk9+n0WAcSawkoAeSZ4QX7vyLqcg7
	9z4mq3LTLODemA7Xo0DJAOEjvDV8M5MUOaAQN9p0zGH6tVupCjPmGGJrQQtZovIabmHMl6uJEaX
	z32s2IBPy6VscY3gWJ2Qj5UsoeTW+hdUuKdo5JKSieavsjNY+SL3NvH/dP5KZmwQWArYf9XCLzb
	ymUk/bfAwqMfb1KTajxL5D8b23TsIFTNvTFem1Dqee8JK4NSbLbftELvwmqpxd5cTbfHq/qbSap
	dDNct2eBDpMkjBKoTpnMOJeAwmVm6aD9Hb
X-Received: by 2002:a05:7022:690:b0:11b:7824:5c97 with SMTP id a92af1059eb24-12739846637mr323128c88.40.1770941690599;
        Thu, 12 Feb 2026 16:14:50 -0800 (PST)
Received: from [192.168.4.196] ([73.222.117.172])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1272a636095sm6909624c88.0.2026.02.12.16.14.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Feb 2026 16:14:50 -0800 (PST)
Message-ID: <e49fc187-0ef8-4557-abac-0082653fa645@gmail.com>
Date: Thu, 12 Feb 2026 16:14:48 -0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH bpf-next 1/3] selftests/bpf: Check
 bpf_mem_cgroup_page_state return value
To: Hui Zhu <hui.zhu@linux.dev>, Johannes Weiner <hannes@cmpxchg.org>,
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>,
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>,
 Andrew Morton <akpm@linux-foundation.org>,
 Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann <daniel@iogearbox.net>,
 Andrii Nakryiko <andrii@kernel.org>, Martin KaFai Lau
 <martin.lau@linux.dev>, Eduard Zingerman <eddyz87@gmail.com>,
 Song Liu <song@kernel.org>, Yonghong Song <yonghong.song@linux.dev>,
 John Fastabend <john.fastabend@gmail.com>, KP Singh <kpsingh@kernel.org>,
 Stanislav Fomichev <sdf@fomichev.me>, Hao Luo <haoluo@google.com>,
 Jiri Olsa <jolsa@kernel.org>, Shuah Khan <shuah@kernel.org>,
 Hui Zhu <zhuhui@kylinos.cn>, cgroups@vger.kernel.org, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
 linux-kselftest@vger.kernel.org
References: <cover.1770883926.git.zhuhui@kylinos.cn>
 <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
Content-Language: en-US
From: JP Kobryn <inwardvessel@gmail.com>
In-Reply-To: <042df9438d9e78bcd66f1fa0e7043b9ea8cda96c.1770883926.git.zhuhui@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: F37FA40006
X-Rspamd-Server: rspam07
X-Stat-Signature: t3ujh9rwexao6otazeqpwgnabtuswy1t
X-HE-Tag: 1770941691-342214
X-HE-Meta: U2FsdGVkX1/Ld+T0Mk7m6kcqLzOJ+IIUS+TpPWrDAndgq9Ap8veVZedqGAqvFwilc/xOkEWMEZB9P9bVxEdTxFxuVilob16TULMtqFXOy1RGdBZweQtvrLSVKBX/gth+RnzeJnznuwZjWznHhmBaERg4ya6lRSPC4mjlYoynnXjvp865G6CF+3Nm07INfLIZqyekCMRubYLJkbjdL1bdyWkaoKmak+un4RW+S4Y2P2vrISmhOd63IkAUGTbElpn9inVxVieCipdgEFAVkjL3JoatkxwnJASRt7jDPzIV08tMZPKqJIWyqM7KY9w6EcNME8vFDJt7jxQ1gKiSwXKyl1QeR7wjc45jPWv+HSsFPBiOlFiF26gDbi/40I2iDD4i50Ftt2VQUoacAUx2Wxg0S88EVzjQ5Sloi7HzGJiy56gq2+gL926vRi6EzEdnSNDRGUwSO5NJeu1IcZ/cNGeb0o/FepmWrs27BRuSR2BIfK1onvcSSVNzToIwoK0nX3D8FAFQhsjXFA0WNkcPNTKoLe6lgI2JRKKr+F+TyC6YiAhbHaUgReGRMISJ24iXb7E44Rylahyc9AdWn0H/iQG1ts2VqODZ+MIMJySbj1en2g1QGsNUgnCFAp3lJUf3Ej9llSHutOWMMETAzdCvaH2U4MpVRYNr9ny/Ezyj/Q3M2aw4IgJQvsWWArMvqxG8ADOKeAXWFzTwq90WEQ+H65p7lbpe6oLX4lwYRDznTLxjskMqN1an1WdZ4+QzrT4q+x3+/uEVOQjG4vU9r0+rRGAVhII2l7ZyONff7FQzZirS9Hm8IkjdACAxjs0QlX1I2bnE9rJQwts6XJqXouydqqL/cepWC/5Be+O7zHHA+tEgJfUneIASKwqUOh+KJUScseXzb1X4Su/9rVkXAIVepouQFNNpGbc/yVuNo/6b33lSV8tmSSc1eZKi9A1KqjX+Onu9HYplTM1vYAeyUm8rfbb
 PWX1wS6o
 am1vcCbMWTzTeJURHfG+AKg9KEJrXiJOOGgs9D20jvlYpiIDsamtr44djh4aHPL6I9iY+WdShwEssGx6niUoiO/WXQHVy12D+VRxf8ld04jIyQHwv042SVTAnn1JlxQxT3O6xwXMFXbVDzc08iFN0DO0GadXrBZroKHvQDEK9K2N4CJWVU0YG8FZEolHc1UNmRyfh8nrvU7DajUu5Be43SMPNGHiAjKXAaPlQmz4deTkBr5LQTrgi0O3mKJx1T75ljtWXDS7rZugadI+/Yc81oIRZV1t0Pwi2zTF+iMKH3znQVUqMegy3pKcGR0UeJ0zx/pJ7T8l7h30+PYIL2+i9vDkoXdCGQPF5BegkZzWBcqUY8uKJt0WSz2L9JgEHp6Pj64S69KSLkVEPqFUG/jQ6aNoF0ah2fkaKf4ErNfzS4Y0jMN+LWn6ILOVsR4CduoO/pS7n4hHO6Xn/+kHjplTnIYkmdNzG1HPel8XQJtc7jCmSlvGCn22gPNVLNvtA4z5qTFo/Bw9RUjci5n7Gak6Q9cdYDio7h56spvJrEMH4PxerggyKQJ/hgEtQel73X7RGv4UR1iCVFXSdc76X69fufss2b/H37sgqVBQS
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/12/26 12:23 AM, Hui Zhu wrote:
> From: Hui Zhu <zhuhui@kylinos.cn>
> 
> When back-porting test_progs to different kernel versions, I encountered
> an issue where the test_cgroup_iter_memcg test would falsely pass even
> when bpf_mem_cgroup_page_state() failed.
> 
> The problem occurs when test_progs compiled on one kernel version is
> executed on another kernel with different enum values for memory
> statistics (e.g., NR_ANON_MAPPED, NR_FILE_PAGES). [...]

This patch looks good but I think to fully solve this cross-kernel issue
we should use co-re in the bpf program. In your second revision, can you
add an additional patch to make use of bpf_core_enum_value()? This way
instead of relying on enum values in vmlinux.h at compile-time, we use
the btf info at load-time instead to get the proper value for the given
kernel.

