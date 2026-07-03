Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9B99BC43458
	for <linux-mm@archiver.kernel.org>; Fri,  3 Jul 2026 14:34:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6E9176B00CA; Fri,  3 Jul 2026 10:34:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6C0A16B00CD; Fri,  3 Jul 2026 10:34:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 589166B00CF; Fri,  3 Jul 2026 10:34:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2EB026B00CA
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 10:34:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4A201C0280
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:34:20 +0000 (UTC)
X-FDA: 84947710680.24.AD9349B
Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	by imf24.hostedemail.com (Postfix) with ESMTP id A8B70180010
	for <linux-mm@kvack.org>; Fri,  3 Jul 2026 14:34:18 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ReX8NujP;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1783089258;
	b=2zcKMAGf+juvLlivGuYLsA3HkvMPNL4BYAvHL2X405e1JnGE/Pq2m3tHnIm61Qptx5xLqq
	I1clM+fFIGGbqv+/FJtfV4IFzMuoUAnJureS5OPCeETrx4+llvpxgBxFsVtdcP3AbnE0Nv
	34PO/D2eKGlBdq4Xdc4UlngjI62LP6k=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783089258;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ljMNR3U34F8WApvO4H/nMU/5WQkOXf/5EBBbyLdengA=;
	b=SfAndIqGrjCzVdO77QRn/A43BrsmVxOvErKzve4YGrwealqsNPV2oOhqX76a19vVtLkwJD
	liSqwib4E/fI8cJ7HD7f5QF0xfqLO7nbJ6SsvDVzTmxdW0Jjsz8Xa1uQFDLRWDraP/hO8G
	l5Ufg7ZmxdYsviagW65r/jFFZu3x1M0=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=suse.com header.s=google header.b=ReX8NujP;
	spf=pass (imf24.hostedemail.com: domain of vbabka@suse.com designates 209.85.221.54 as permitted sender) smtp.mailfrom=vbabka@suse.com;
	dmarc=pass (policy=quarantine) header.from=suse.com
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-46f88060e8dso123222f8f.2
        for <linux-mm@kvack.org>; Fri, 03 Jul 2026 07:34:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1783089257; x=1783694057; darn=kvack.org;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ljMNR3U34F8WApvO4H/nMU/5WQkOXf/5EBBbyLdengA=;
        b=ReX8NujPR75KaLVINSyF8Q+wAg0FBAGYUwazDYM/dITfHp/zosmJUtQDy8WcVRgwaj
         iRTFOTbzgvuRlvGjLkaqU0MYbO+qm/7uOn7HyCqANODkHAn1bHnqTCskf3pM53iuzoql
         fZ80eNOjgyL7CtpVVjv39WWQrE8HfcsuSvmyCbT2L+ZrhOrdax8VHxM1snQgFwT+idYN
         lBiPYyRch3CwJXcNFGY1CNLQQZVMYyvco3D+iROwHKJ5J8voNyTbScINZEmUnaHqQ+OY
         LsSGgRGlDi8Rl3CYAqiRArxXP7Hewb/rigxZXzpAdj6UpubCF3w/EDyBZDpzPZGK3qTs
         XbWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783089257; x=1783694057;
        h=content-transfer-encoding:content-type:in-reply-to:autocrypt:from
         :references:cc:to:content-language:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ljMNR3U34F8WApvO4H/nMU/5WQkOXf/5EBBbyLdengA=;
        b=BTIicwG/TkPLkzKC4mrr/VnAo/CQ+8SudRh11hEj7RXK7xZsz56G8BA2khrZc8zaT7
         OKW5ekU5NqYp7zZ/iAG80k9bfd/iKIIYrrtmfNEUlVKsQwbpWWljKv1s01VRrbJKNfQr
         bUKY7mTjjXlra7KOq9hczL8vMvN7Q7ksmGlQGx0Ud4/lnU6QbDGkrTLmVxZNKBgXI+nJ
         Pg/W8g1HUukOQnmxiMx5/piYQOiXsJIDmZhX5QrV2Q5OUzeIHATdIZVwCIPfxfUIERIf
         0hNLh/v8SIuQYDVv35b1aPzFeM/p8pJeTl3GDY4YpC0UUGS6+5FGLz7ndVnx5Ad6GuaD
         URzA==
X-Forwarded-Encrypted: i=1; AFNElJ8M1UI1FMz07MmPzCSSeM4izsrzKgsFL7lATeBeOAM5yQy5Qiicj0C1z8lQBhsVH9dtyubnDdpHDw==@kvack.org
X-Gm-Message-State: AOJu0Yyk6TyZ/TcTxdH4uraE4/PeJkZCsLW4s5Jpzehg7PvjOYkliC6o
	Kxy+6DATzpiUf1EckKcGpPoW/8Q1cW2nZtDDlyPoblpbZ2WC73a+9no8vpFP+9dJmSo=
X-Gm-Gg: AfdE7cmV1q+eR3HpcuznVdNU/S0dIfY4zddHcGN4uOgLqAWYQPxmaqU6359zYfjdVp8
	IMDb7EDij4dNvqGdNgSr6/rUi9pXA9id9/IQrRwmquVSm2HZPg9wAo2CtV33U3jMblRT5iBAeoW
	t1HsrHriTEWuqQJvYf23t8D73oWI3YPLPzZ9F8w+D5pKRjK0/gzUC+pNabsT6Pu88g9CnULuhMo
	uhSDN8oGXHx0yG+U7e/kVp+IO+csq6UX6v5g3T4ZBMRo4HpcMQ4JY8OfzyZOOoZUfhIZQItM8dF
	jV8i9jZ0mK+Jl7QN0PLrAUsPd1rjZwwgcKUipRdT5jIzljm6QwNhHVhirUQy1eHnKiCmdzG5N2X
	m15ybpD3hiD+wT7ou7Nym9CoSGGXK4umLxqrvA2BVBtv6FurM65g9HTufCQrPonb8HGwDO/gcIO
	OIxRNy4Fg=
X-Received: by 2002:a05:600c:8217:b0:493:bab5:86ee with SMTP id 5b1f17b1804b1-493d0f343fdmr674415e9.4.1783089257091;
        Fri, 03 Jul 2026 07:34:17 -0700 (PDT)
Received: from ?IPV6:2001:1a48:8:903::e14? ([2001:1a48:8:903::e14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c636e9e9sm131864315e9.2.2026.07.03.07.34.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 03 Jul 2026 07:34:16 -0700 (PDT)
Message-ID: <3c945aa4-5429-4bf4-9c0b-c4745cf6024b@suse.com>
Date: Fri, 3 Jul 2026 16:34:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 03/30] tools/testing/vma: use vma_start_pgoff() in merge
 tests
Content-Language: en-US
To: Lorenzo Stoakes <ljs@kernel.org>,
 Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>, Dinh Nguyen <dinguyen@kernel.org>,
 Simon Schuster <schuster.simon@siemens-energy.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Helge Deller <deller@gmx.de>, Jarkko Sakkinen <jarkko@kernel.org>,
 Thomas Gleixner <tglx@kernel.org>, Ingo Molnar <mingo@redhat.com>,
 Borislav Petkov <bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>,
 x86@kernel.org, Ian Abbott <abbotti@mev.co.uk>,
 H Hartley Sweeten <hsweeten@visionengravers.com>,
 Lucas Stach <l.stach@pengutronix.de>, David Airlie <airlied@gmail.com>,
 Simona Vetter <simona@ffwll.ch>,
 Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
 Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
 Maxime Ripard <mripard@kernel.org>, Thomas Zimmermann <tzimmermann@suse.de>,
 Rob Clark <robin.clark@oss.qualcomm.com>, Dmitry Baryshkov
 <lumag@kernel.org>, Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
 Thierry Reding <thierry.reding@kernel.org>,
 Mikko Perttunen <mperttunen@nvidia.com>,
 Jonathan Hunter <jonathanh@nvidia.com>,
 Christian Koenig <christian.koenig@amd.com>, Huang Rui <ray.huang@amd.com>,
 Ankit Agrawal <ankita@nvidia.com>, Alex Williamson <alex@shazbot.org>,
 Alexander Viro <viro@zeniv.linux.org.uk>,
 Christian Brauner <brauner@kernel.org>, Dan Williams <djbw@kernel.org>,
 Muchun Song <muchun.song@linux.dev>, Oscar Salvador <osalvador@suse.de>,
 David Hildenbrand <david@kernel.org>, Suren Baghdasaryan
 <surenb@google.com>, "Liam R . Howlett" <liam@infradead.org>,
 Matthew Wilcox <willy@infradead.org>,
 Marek Szyprowski <m.szyprowski@samsung.com>,
 Peter Zijlstra <peterz@infradead.org>,
 Arnaldo Carvalho de Melo <acme@kernel.org>,
 Namhyung Kim <namhyung@kernel.org>, Masami Hiramatsu <mhiramat@kernel.org>,
 Oleg Nesterov <oleg@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
 SeongJae Park <sj@kernel.org>, Miaohe Lin <linmiaohe@huawei.com>,
 Hugh Dickins <hughd@google.com>, Mike Rapoport <rppt@kernel.org>,
 Kees Cook <kees@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>,
 linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
 linux-parisc@vger.kernel.org, linux-sgx@vger.kernel.org,
 etnaviv@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
 linux-arm-msm@vger.kernel.org, freedreno@lists.freedesktop.org,
 linux-tegra@vger.kernel.org, kvm@vger.kernel.org,
 linux-fsdevel@vger.kernel.org, nvdimm@lists.linux.dev, linux-mm@kvack.org,
 iommu@lists.linux.dev, linux-perf-users@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, kasan-dev@googlegroups.com,
 damon@lists.linux.dev, Pedro Falcato <pfalcato@suse.de>,
 Rik van Riel <riel@surriel.com>, Harry Yoo <harry@kernel.org>,
 Jann Horn <jannh@google.com>
References: <cover.1782735110.git.ljs@kernel.org>
 <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
From: Vlastimil Babka <vbabka@suse.com>
Autocrypt: addr=vbabka@suse.com; keydata=
 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
 pYekxJujNeEDkUlky0Y=
In-Reply-To: <b501eca378b9d9734e83838102aadc9276590fba.1782735110.git.ljs@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: A8B70180010
X-Stat-Signature: b198i1pnfogjsxz4fr1xkeks1mnkwind
X-HE-Tag: 1783089258-399644
X-HE-Meta: U2FsdGVkX19vC9phRgSRD//n1C2x83jUWzayedN5vYnnq6lys+k8yfKAa7TDG1J0ZAS0imwuQnxOiUC3aYZ9iLYcId4eM9l8/lSdVUpsvnBtYacbirqnfZqeU7J/qDI/2DR50eHJp25GJyTFASoGq7tppW4NXtgBu8Vjs5IKWMHmI62TQy9IRK+Tw0cQvvSyvnKHhc3sBQS2fXhdzBoeJqjM8p9hjzn+mcLQwzoOWstGIKhW7NkMbQmRYqoKmmT8MBnDkbd+RqL6O6M0c2ZDniQmso3rOLjs5IHbev5RwuShzyEH4olHREkGtkzvp05G+tumUoQmUw0gUKmnlvRzz+ZlFFG0Omy3fdtezO+KkzYK/mk+4ez7mvpc6IwE6wL/TMm0E64bD8C34gSSk8IQ8CftPGIl6NIDEz3U/WE2QGmSki7MXYQlmo+jmAhRFZfCSA5VuXGffAIRY5sKVTlAqBOvMKUnGLlfdGnGfdTO+rSiaf42UTbiIu7RRYL4ujgYIwBen0nmDftBKO27Umd7vi2aMthcGeEA6CSB4OJqNDqLbSi+ilcJy5GHWhBLDnRR2+fHQ9IU2q+cO5ZaIrPVw/U1JNhfDTKQak/nyzh2ee1MpRtt+BUXZQJ3Jm2TWtELN46Oog/+fNEt1C93/vckxjnhkALqlyB61pzRxWFZk+HAH1enDOPz3vcj1dteJnM50Ql6OTYu/mAP3bH3HZ+VBzfwDg8mjkJTi/MnRch90sBrQMgmkjEVGk6mwtIcMO0UVPZj8mUYo3PiG+Lc7pG1TDZeQXZwHOLWSrb/+upz8O7TvDXf+8jQoAKyRHCcp0msD0PvkuBYk8yAGDPpdvkaYezSwzglVvULM7mY50obs4zWV5VYBV9cRR6Clll13zKeEmRhC21MOAvNnhY+Jqd7WhNNFRQRpf3IpKldSMaB9q3/EKdAwjoBCMw6on+VRPUgw6Vh0GS3gS9K1ws9rpX
 9/m4cb4q
 iBM8wproJuZ1Z2/qNruQ0eAYJwtX1DNJg5dLsC00skWI1e1Crp+jFrAaPwlPQRdii8G0UZpGU9C9Wr1VrVBrglOz/J4sPJOw5EeoRHL8uVuNn4ZGOWvu2fYSx/PlvTJgewT46ddfnyKOPR3AvrAzRqGdryrCMmmzosy3cGu9RdZQNBnSEsrvZYm4UrUW0bUQ6wLDzO0Jo48srSHABb7nHto4GP0YdVy6Pyny2w3PMo6qqRwKOXWOYabLVfiKlLGjUGTZeUxbb8Mn0kXmRM1V11GvD9twV5GYu5Nc9dzrYy+DSwvd8hN1GO4kx9NYWOye9Llsb63k+tq2xtDPrJxOJPYJ+P0XV4NxG+ArbnewvaoOQ/bfYulRxbSqIT5fyr/A0asIfWwZuBSdlujkF/bNB2UPjy1TnknfMnjJ7yusCQ7BjHgCiLQg6I6Cqzi/EQwHDS9sv5XIXfuWM6Z7BRryJtmNNdWQkh9Wg7KPRy8S1Qthc4qrjSD+asqh22pqUjWULMkROdpzG3FjyyvwBMNxESal1Ok5qCyokjuL1v0C0OBIqONrhNecS1kLXJHqh4tLwU1fRs/RVAr/mRKfBJoHQE9O5xXMNlJa8reULuZAoCKxEtukKad7Rc9jZJ9H1shzrE7qnHTDGFtlXTWE=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 6/29/26 14:23, Lorenzo Stoakes wrote:
> Now we have the vma_start_pgoff() helper, update the merge tests to make
> use of it for consistency.
> 
> No functional change intended.
> 
> Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>

Reviewed-by: Vlastimil Babka (SUSE) <vbabka@kernel.org>


