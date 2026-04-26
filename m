Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A0369FF885D
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 08:50:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B9C406B0005; Sun, 26 Apr 2026 04:50:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B4D386B008A; Sun, 26 Apr 2026 04:50:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3BD06B008C; Sun, 26 Apr 2026 04:50:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 935496B0005
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 04:50:33 -0400 (EDT)
Received: from smtpin12.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 2BCC41A04DD
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:50:33 +0000 (UTC)
X-FDA: 84700085946.12.48A92CA
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf10.hostedemail.com (Postfix) with ESMTP id 339C4C0002
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 08:50:30 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JdVDBDB2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777193431;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hLLuhKCVEEOrdD6a//CB/S5jW1JUUt0Uq70rgzaEoyg=;
	b=tYofZclIOtXDDEIwV3oEEavekJPvJPCO0YI0EvsqF8DdKxZV+TMizVB1xTNIpF+qH2MfFC
	pWaqrpCMP+sYx3UKW3S4ArkXLMhcOKTdpa8pMIsT9G6/Xi/+CgZePG3kFEdYABie0RCfPf
	fOGkqU7xIPfV3gUNPEry6/gkG5SLuSc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777193431; a=rsa-sha256;
	cv=none;
	b=Qwgvc1pXmOohpwQBZlXHUBFAspfeiLqbgqwZ6TcqgZK6ul92u3+Sjz+fUi/iuSpI4hj755
	69BcN2nR1cxz+kKNkFX0Z9jEIXT1HXxI18IPHQbC1h6LH7xQwRQuaqfYBXnkvYXuZnl2h3
	NIFiIfmgbBQm5JkyZ9fPLFa4klfr2wU=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=JdVDBDB2;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf10.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-364746755a8so20603a91.1
        for <linux-mm@kvack.org>; Sun, 26 Apr 2026 01:50:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777193430; x=1777798230; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hLLuhKCVEEOrdD6a//CB/S5jW1JUUt0Uq70rgzaEoyg=;
        b=JdVDBDB2aZnAUBGC44PQT1Yqc6/4QZsZNbXtbgMgyw6Jgxtaxt2oIxmcLKUq/OgWBG
         xa5NeJScosfefLPxBO4lnOLQoXfAB0vzvPdtjOz7MdJ84s9HSEERjS/O32hk2Wd/6NQo
         pHke4WnRLgHGBWYtjmjEYaumcrjuYZ5fEC7K2NtkGfRwXCuD/5iOIxziLmuttVthFrHb
         76TxDIAGGUYjRGFSgVVh5eEWlbvXNBwzmOAp7thPY35S7c9nMI8K+J1bjNVrFNuM8vdj
         KdeUqwrmwSXVasv+1Egsg/5kCWTpFkGeR6zKUN5aChpg/k0VYsnFHFTfLotsYwuFVLpr
         VoAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777193430; x=1777798230;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hLLuhKCVEEOrdD6a//CB/S5jW1JUUt0Uq70rgzaEoyg=;
        b=PMF2ErKjj8avjH4eQi1b8OL4XKf2BWtjtpx3zvubiRpyFsUFOJ7mETp7MjK1QAkYhk
         d5UA8ZtpAWGEt2zLnxw2nXhfq0xvcKUg1pZU1CfR0zZwiypqEee+YDOcfno8/JWDRPoE
         GrX+UVT/QOeu36s3VIJ2S/kW1FQmMiwNXISEM7pmsf6aMC79pWJhoNqMSeNYsEZnEG7e
         bu8/MKLVFcmrbmaSNCBjYIQyAlC68DKZ4jcG6tHbGnpLphFFWBpDQEMxLoQRTAaGv/1M
         N+hyNtENikp7522UFXTfgEE4yqUCvqy3G7E2QP2uETlWfOZhBqksDOfEntdJ9a0d97+j
         TrfQ==
X-Forwarded-Encrypted: i=1; AFNElJ9MaYlxxYiqtY+sl4R0YhEWbXOGlb677pCa1tvZB2k7k0YdqW9MoDV03k19m7zklOK8C9/GClViqA==@kvack.org
X-Gm-Message-State: AOJu0YzxqnvS2nxv6UCo1CKpy8oOj1/GZqArzGGoFhbavJRzePQNqArI
	AJ5Udi3Ibe+cmWep135Mr5ZLbRxjPmvw7VCBgESjegWp+Lhtl0FUpQWinA/JcVgsWksIvax1B4U
	=
X-Gm-Gg: AeBDieswpF/fMuUESh4qGZA4KlJEwC2RzASEFrtu9R6oPjeRIMXybWU3Hav/DZtkBuI
	VJrlL+0ma7KJnEKubUMeJSBO+8SpGl85G9RVVGRGFZdVVsz6l109x1ZMZ+0GCt9IapOYU4qnGWa
	ojFA0PLNXfKkroTjM3j8m8L/S8PxnioROX+YkmIkc+MT5FlIHhLBKgGxv1/VvxDG77nXoKK+BzJ
	70vy2IIIIW3FkbBzaIU1GKMamCc3bK8BXGCb0BrPsklsFlAMvv78mfzaexx87XxTLq2iuW5MxKz
	mAAhzGGhmAcK7MFw/uiRYzpq2N+9Bfa16lx/vLJ3qlWHaEpxaITP2iNu9RLPK7I+MpsytgULGi2
	gKQ41ojZv86NCPdfuIu+SdEeu9P5aXLrGIbDt4Apx6EJvM+ZUURV1TsrhAlzXE56NYEwGfXQouK
	0PEuzp5q34XhKZ7h22yqdn9QnKjIBNXPZFSYYwle4RgZnNPA05cnn/M9uBMlwiyc1c2vvuqIQqE
	qtdV6GIWhABhoHqmkl5VBg=
X-Received: by 2002:a17:902:d60d:b0:2b0:4d17:4d6e with SMTP id d9443c01a7336-2b5f9f2d4aemr208572205ad.3.1777193429349;
        Sun, 26 Apr 2026 01:50:29 -0700 (PDT)
Received: from fedora ([38.244.149.186])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2b5faa16e72sm272426235ad.19.2026.04.26.01.50.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Apr 2026 01:50:28 -0700 (PDT)
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: haowenchao22@gmail.com
Cc: akpm@linux-foundation.org,
	chengming.zhou@linux.dev,
	axboe@kernel.dk,
	hannes@cmpxchg.org,
	minchan@kernel.org,
	nphamcs@gmail.com,
	senozhatsky@chromium.org,
	yosry@kernel.org,
	linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	baohua@kernel.org,
	xueyuan.chen21@gmail.com,
	haowenchao@xiaomi.com
Subject: Re: [RFC PATCH v2 0/4] mm/zsmalloc: reduce zs_free() latency on swap release path
Date: Sun, 26 Apr 2026 16:50:17 +0800
Message-ID: <20260426085017.166935-1-xueyuan.chen21@gmail.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
References: <CAOptpSPs-1UrEa8AHg19e590=SiV6bpnex7gCbif8=aY7BtpuA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 339C4C0002
X-Stat-Signature: rhxdgzyo6xtio617b4ey6nwhbh9x3rdk
X-Rspam-User: 
X-HE-Tag: 1777193430-977834
X-HE-Meta: U2FsdGVkX1/qB9b4qhCs6aCw3ZMcSZLaTImItIaboR5qhvGdhiCU349h2Z5V3tt/IyeyQftUvk2L10+uau+AoD7lHFHweV57d/d6rhuHm6aQ3puEJ2u6U8RWH2YsK0MP8eGysgXDmnixTh/mUHrQ8hvRk9mlrUxXhf2I1pbyc1ZrbicGTCveE0EPmsnFDs1HwjIlxTPf7HpP4ifQu1Poc850FNbW1i9oWrZ/VIAlyo7EF9z42RvZS9hVozQYg6Huumb/hQJl5Int1plF3Ov1wEVc/iLzpwuOJYNF4ehGJFsltIJPhQR1P580YxwsnePyHwc10SaNUiTpj7nzOpAKsTvaaqAh5miG1CB6jaQu6cFZtYAq13tF0EeMX3P25c0VDa8dqsd6XT1MEUteNdPmp0jhxODH+l9+U9bL8RT7p6sfMDCdOjOMAdCDff790MizytF5vbZReFPlTSbzcW8ctPvBr6KHYN88TY9HwezlpdOMLDrNL980xjXY+5I9PgdUZRbeOXMzBE8t/yOhLmem9KvMmQSiJ/859FNBfQxtxboPSUWx7tkuVdakxkxG/NyDMIpf0ULe8NQzc4Fn08LaJtMq/XWMMh/EQ5oLnLIh6QwkFdE8NE4f2J62K+I4MlgGQStlj1A1PfYAJ/CaxVKllk3PAyPrifEIno/u1c4VjXtSEkOt4I/sCtn66zsifE5No9ifgoapiRRv4wptjsl61MxEuR8kPHtPezwjDkP/dAYju3pdFav1EA1Z8LAdYKZfVEXLvwXUydKB6CrtZ10QJgPMtd5hjh9XRB7qqXQV0khWIRJb+P+/J0wSAdC1QyuWg0PrEl5KlyGQ6M1gAF10oFl5JJsI1GgjqFVIOclY9yeKvfEI3H2fbRYtESlyXADGCp6mKjxceub+rs3Fi7cP0auicDulYuhzl3vcNb0gfNKmSWvPv0WOJMcqDc9tmS70vCdeXoGIIO6ZHsFYQl6
 rEfaeyMH
 cI9tTrgyuf6sYSxWaJqCR7pOec29AzKAeMBOVQTxbvXnRKn2s0qMv451oLOBNyMLhgmXbraShe8c3plLvY7R7JnwwAodXFbOzWDBEfSTejo/Z1FgUw/jZnKod5wxOU3KOrUNx97QZtNhXNnTunBpZqMyD9fwjc9Sxcpb175q+ndjoiCtsyOOz8HX1NBtzUoeQco0ixyUpz4kXqCDshsWCMAdQ4aVdsC3j1mx1VsAFF6qfSQqGGdZjnO07kl2cmCfy0AAiPhy+/Lf2wGKHdcfSnwEWVRJBpT+HLgIHM2VMtkg3ixFeMYAyst8gGjj5+ErEIFQ/2ELhzATVvwp0kS0KQPVJe8ID0Sxm5JfFlLrLwgxP1avNW/DwY0Mo80+AvJtOVCkj1BIf/7sUg4oN5YgOzc8a6RZcfQIptmLFZ0jP9gSS4zoLjin0LEwB60zIXcbEoeBBjLguUC+O2lhDkbvESI4yqHs8td8Mv10J1VZvDM60n2XBKC4wqjeP5D1GjnfiuZ0wTDDhQmtdkKp08QWdYBoDYyCZ8mYBHg+00MbBhzPnF8Vj+BWVYe0Fcmqsw3MTkQoG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Sun, Apr 26, 2026 at 12:13:02PM +0800, Wenchao Hao wrote:

[...]

>2. Per-cpu deferred free with lockless buffer swap
>
>Defer zs_free() to per-cpu dynamically-allocated buffers (~2048 entries).
>Enqueue: one array write + WRITE_ONCE under preempt_disable — no lock,
>no atomic. When buffers full, schedule a drain worker; overflow falls back
>to sync zs_free().
>
>Drain: allocate a fresh buffer, swap it in, reset count. Since
>the producer stops writing at count==SIZE, the handoff is
>race-free without any lock.
>
>Pseudo-code:
>
>    /* enqueue - hot path */
>    def = get_cpu_ptr(pool->deferred);
>    if (def->count < SIZE) {
>        def->handles[def->count] = handle;
>        WRITE_ONCE(def->count, def->count + 1);
>        if (def->count == SIZE)
>            schedule_work(&pool->drain_work);
>    } else {
>        zs_free(pool, handle);  /* fallback */
>    }
>    put_cpu_ptr(pool->deferred);
>
>    /* drain - worker */
>    for_each_possible_cpu(cpu) {
>        def = per_cpu_ptr(pool->deferred, cpu);
>        if (def->count < SIZE)
>            continue;
>        new_buf = kvmalloc_array(SIZE, sizeof(long));
>        old_buf = def->handles;
>        old_count = def->count;
>        def->handles = new_buf;
>        WRITE_ONCE(def->count, 0);
>        /* now drain old_buf[0..old_count-1] */
>        ...
>        kvfree(old_buf);
>    }
>

Hi Wenchao,

I suspect there is a memory ordering issue here:

def->handles = new_buf;
WRITE_ONCE(def->count, 0);

Since there are no explicit memory barriers, we cannot guarantee the 
order of these stores. If def->count is cleared to 0 first, an enqueue 
might end up operating on the old_buf.

This race condition is more likely to be triggered when the size is
smaller. Perhaps we should consider using smp_store_release() to enforce
the ordering?

Thanks
Xueyuan

