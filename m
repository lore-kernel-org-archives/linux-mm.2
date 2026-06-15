Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DF07CD98DE
	for <linux-mm@archiver.kernel.org>; Mon, 15 Jun 2026 08:28:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5A0DD6B0005; Mon, 15 Jun 2026 04:28:21 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 578436B008A; Mon, 15 Jun 2026 04:28:21 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 467726B008C; Mon, 15 Jun 2026 04:28:21 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 35E906B0005
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 04:28:21 -0400 (EDT)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id BAB6EC317D
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:28:20 +0000 (UTC)
X-FDA: 84881469960.24.4C29175
Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	by imf30.hostedemail.com (Postfix) with ESMTP id CC94980006
	for <linux-mm@kvack.org>; Mon, 15 Jun 2026 08:28:18 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnyeY37q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781512098;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=OIK6+R0N6S5FbjNUFVY3i/UoNEgCH6Sdv2/saOFAeXs=;
	b=8iH6V+9LGRImG0ZmTOn65aHcBOVTrr/6ykpK2VKvlX6Hk3ldoT4cGk7PL0szopfcEQ8kC9
	QbLOJllVPAYgC4ghp3qX01iLEgnAqzgw7+9WUY5ghpbT4b9RL13pGbfbDjY4+adyeEMi27
	CuiQ+NYEC8N+/GhaEFZijfmdQUKy1tM=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=AnyeY37q;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf30.hostedemail.com: domain of chenwandun1@gmail.com designates 209.85.214.194 as permitted sender) smtp.mailfrom=chenwandun1@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781512098;
	b=leWO5cjstEDA3YCEJNlWC/ecuqG99v7kzPw0kJNb9sTemddBotHQDG+3cpPOgHpnJH0vcp
	p/cmUZ9+Bb+eBGxWu3inDTqpo8y80fnyrrjcFCJwTtiNBvRfhKN7S9aRsR4R4UAy7ONosZ
	sm/tjwuSlaiyWKqd8P5FCazaFtJtesw=
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2c0b9328c4aso22224775ad.0
        for <linux-mm@kvack.org>; Mon, 15 Jun 2026 01:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781512098; x=1782116898; darn=kvack.org;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=OIK6+R0N6S5FbjNUFVY3i/UoNEgCH6Sdv2/saOFAeXs=;
        b=AnyeY37qU3v8azGphMUqmB6knXQqFndg/KiZP3rho4+v89jwd+on/k/UTi+yd8U1pF
         +MQ4YskClQfkhGDo9BQ7XHJk9c4KL8KDfBAy+hxNI8oV5eKOHo04dczjXkhcHAS8kCAW
         9iDUTpi78CGfiCbLmQfwmIsZghokYWYEo+jS4n9IZA3KHIXXdRR2sUsMI8dgFyRQEejc
         u0qH9wi4ZPeIDLgGeBh/dbBY/wZdeO2uYh7nQdyjv5SeXfJQ8Sakkv+JvVxHJFqULVqG
         N+nOhMAyxINst3/YPE6q34JtgQnEYFEz+j6Uz73G0bIa+jO3ZR2vbAywD26ZvkyR2Sw6
         V7QA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781512098; x=1782116898;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:from:subject:user-agent:mime-version:date:message-id:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OIK6+R0N6S5FbjNUFVY3i/UoNEgCH6Sdv2/saOFAeXs=;
        b=Y6tLemZRugQzvQJGYtRoS1BsakOD68Ol713WnqRSFP5UcewIKUEJKFccG11FnTxpwJ
         9f+fS4Wkqd2O7LkwySCdUHWAO86gydNWRY3X24usBZlvZ/aPP22aYj+PCIaqn0jipsRb
         7h7u8gXqNibpl3IIFIYbOP6KWr3s0LnsRSrHI0JqKu5poGDP1u1n6uZ1YuNs0X+81mP4
         REEVr+frwnaFr+V1SKj9PC0mhBtpJydkCW5Gmr2ZRPzZT2aKBjqRzvxGxN+iCxUAjuD3
         u9DQ4pQ3FZy1iSjjawXQbQ+WEghv/Z18Vh4Q/ZmKYuFPwPi4ZNBPALqwLxg8f4oM7sZf
         QzGA==
X-Gm-Message-State: AOJu0Yxuxw811JFu8ssYR0Jrz1rK/Mw4VUcJSt53NzrIhT9AgkiI3rCW
	GwgC6zulhs+OukFgplspBdTjho5qc4OQFYaGq48tV3tqnvyeIbNGrrlbN6x//MwOduYjTg==
X-Gm-Gg: Acq92OELRPhjaBFqfAwT2RE4mfLDw+cVhZhlUHW/Y7473b2s6MuYvbPDxDd4vQuYUSB
	nukSYR+43LqqkscfJ94hyBVNcV30+ro3QxJ65W9CD72mxj5IyIhZ5EV2196MMAdWfhlKnbeh8/9
	8NK584e7xh5wbleARLK9HdFSHGWOGqB1cQbPAuGl+3DnomT01dPIJTG8GWykKnAMTy0ToWTjX2W
	ssqK2PU/Cwc9dHobkZdiq/tW/Tz4i80t/vgN68AQlt5tTyPPd6vM3zMSaWHQFBPGLkgYLQnOiaE
	DgZPUdGWSkkachviR/mVIomTojsN+Wkp49MGKYVD+EQ/vP0wm95an57J6zIp0aEvOPJDWMDoa/0
	o65YOE9+fySm7q0jSaIFlG2ogw6bw7AWT7Bv4VvFUlhGcYs2e4lWtwlTWe/FQO19Xa/dWyhjpGM
	tScp2127Zx+rDM+FnXFh0ylW79SYcMUz8=
X-Received: by 2002:a17:903:2408:b0:2bf:1cda:29ce with SMTP id d9443c01a7336-2c4104117eamr138814175ad.6.1781512097656;
        Mon, 15 Jun 2026 01:28:17 -0700 (PDT)
Received: from [10.125.112.20] ([210.184.73.204])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2c42f2e52b5sm94136475ad.7.2026.06.15.01.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Jun 2026 01:28:16 -0700 (PDT)
Message-ID: <5d3d16f6-0654-483b-9625-94ab93d3d836@gmail.com>
Date: Mon, 15 Jun 2026 16:28:07 +0800
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH 0/3] mm/compaction: honour compact_unevictable_allowed
 in mlock race and alloc_contig path
From: Wandun <chenwandun1@gmail.com>
To: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-trace-kernel@vger.kernel.org, linux-rt-devel@lists.linux.dev,
 vbabka@kernel.org, bigeasy@linutronix.de, rostedt@goodmis.org,
 hughd@google.com
Cc: akpm@linux-foundation.org, surenb@google.com, mhocko@suse.com,
 jackmanb@google.com, hannes@cmpxchg.org, ziy@nvidia.com,
 mhiramat@kernel.org, mathieu.desnoyers@efficios.com, david@kernel.org,
 ljs@kernel.org, liam@infradead.org, rppt@kernel.org, clrkwllms@kernel.org,
 Alexander.Krabler@kuka.com
References: <20260604023812.3700316-1-chenwandun1@gmail.com>
Content-Language: en-US
In-Reply-To: <20260604023812.3700316-1-chenwandun1@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: CC94980006
X-Stat-Signature: ibnopeqx9rduxiufo9b69hkg1ch5h7my
X-Rspam-User: 
X-HE-Tag: 1781512098-301621
X-HE-Meta: U2FsdGVkX18+MPzd9nwaC2fH4H4WGt7dW8r9Xh2+IXcU5r0o59gxxisIkztrIjqh7s6JbxB0SDDV/2e2U6HsKJNiQBPh+TtICEer+i5JZoPGWU0S/vF1ebj1uzaej233EclnegaJGNR4W32FDOPQuqQbhi1Hz/istdh1gUKTok7BGFK9Nnep/DM8R2ZZKAGTaHPn3RwBly86NM4rF8nd53tMctox4nDX/EgYXoAzAH8tzb16IIk9RL+Sl6sMfQCwu17aDa8mRZpGVPSWiovTuqcnmwbry7schH2TUq1pT7zk0nXRsB9tC3HZ3ehcUx5EMDQvaU9cYXYx4ZLwrynffZ966Pi+R1dhTAiYV6PrUBbWgOUkziBE3dlS+d9VnSOPyIM4356nVUjxrtvv1tvQtW2OKvDJOmvGl+nv0QGeCrmMIN3Tz3QbRD8b6wW1fXwu/rDnMPCJFD2ftVTvQzhw7n61/7Rz3zWgA3sgNAEa65FR0+UzLBaVLsmza1TVoXVQJKGKxWKl14U0cZ5o6pk061J6RDrU4PG92vKTJo93DHyOngeB9LYSKMI/BaFptpllwgvXTWCpNVIctlU5Scr/JkJpPclI5VQF5mjiZDoTUzSr7jPVWMlYZtrWrPkGPCy0i8c/n/X15gOViVXhjRSQOOVfh8mgYWkIHrktn0VQfoVu5DgkS+jNPhgrlCq79clXTm9SonHi+Wtak/tqXBd0ARLBr+6gTholpcSxdHdu60rBXvWon99VcFwWNEikxH1xOqmpSmxKHzcvdjYs/48p0XNjJG+tCPuINcQpd567KTdY1zFchT2GLk3OaRoyQjCsrkweXwGsU5K7gz0h1pMy4ggABX93QSKJ2jIx6BpXvdguMguMSQhNYvsrwQ9jjvXMXHgWOUTKLRPbLhGqb38kyrt1E5crhu60t3euaIy2+PxOWQP2FIuAYtausRk96MVOf4cLI3RcMdIywOERiIq
 lMfEcJ2D
 EblpJROKHERLJMGCuNZwW1HuLSTlzj7FY8weMXcQBusVn6eZzK3uHiLq/EakQX+IFlQvU16d2VMap/bMY1hKdBKOytM4biQQdnw7ekVIWeYvs5BjER1F8JHvP4eD2fVL9VZT2ScSmD6bqZa7nyk0JfhZRD1iqPKgE5ttKIf+veTpAphPtSEQC5R7FjJ8fu/mu4hWfzhArbMgWtHs4806komqZkuGsXo3FtFxPbZ3SkGrtJCoHVXnUH+npSp8wwpyEf7OvHm7j/whCvDFwRdkD9Jfkan/Kq1LrCaJeatHbgwRvorX71kpJOPhTqbcNxvz54bMSw3beAdn89woZMV3gbtr1ArmCLIaAc3cwUv4L3I8pz7d4tn1n+hy6QvB3wBrDppTCNUhpsqJHTfQVSTFMnxOIpEB5UEA7KnZpy7uqjU+ew4PNtEQExcxF9K77lXK+AqSnX6YgU8/0Ckfwl+Vs2l0jgYEctgCJrxLz21c+IFGx48T10r7145qfMig7KbdRZFp3IZVwbChjXVISRuQvmkt0DJodW6xv/siiPIsuNjpGK5M=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



On 6/4/26 10:38, Wandun Chen wrote:
> From: Wandun Chen <chenwandun@lixiang.com>
> 
> vm.compact_unevictable_allowed=0 is meant to keep compaction from
> touching unevictable folios. In practice there are still two paths
> where it does not take effect. This series fixes them and adds a
> tracepoint to make such issues easier to diagnose in the future.

Gentle ping, any feedback on this series?

Sashiko found a potential compilation error in patch2, I'll address
that along with any review comments in v2.

Best regards,
Wandun

> 
> Wandun Chen (3):
>   mm/compaction: skip isolate mlocked folios when
>     compact_unevictable_allowed=0
>   mm/compaction: add per-folio isolation tracepoint
>   mm/compaction: respect compact_unevictable_allowed in alloc_contig
>     path
> 
>  include/linux/compaction.h        |  6 ++++++
>  include/trace/events/compaction.h | 26 ++++++++++++++++++++++++++
>  mm/compaction.c                   | 14 +++++++++++---
>  mm/internal.h                     |  1 +
>  mm/page_alloc.c                   |  2 ++
>  5 files changed, 46 insertions(+), 3 deletions(-)
> 


