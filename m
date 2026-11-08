Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD019606A31A
	for <linux-mm@archiver.kernel.org>; Sun,  8 Nov 2026 02:54:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=dxI0VzCP
Received: by kanga.kvack.org (Postfix)
	id E7A2C6B05B2; Sat,  7 Nov 2026 21:54:07 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E2B8A6B05B5; Sat,  7 Nov 2026 21:54:07 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D19986B05B6; Sat,  7 Nov 2026 21:54:07 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id ABEC26B05B2
	for <linux-mm@kvack.org>; Sat,  7 Nov 2026 21:54:07 -0500 (EST)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 4B08A1601DF
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:54:07 +0000 (UTC)
X-FDA: 85410432534.27.942C01C
Received: from mail-dy1-f175.google.com (mail-dy1-f175.google.com [74.125.82.175])
	by imf15.hostedemail.com (Postfix) with ESMTP id 79DACA0004
	for <linux-mm@kvack.org>; Sun,  8 Nov 2026 02:54:05 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dxI0VzCP;
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794106445;
	b=lFJ6XwuN2bILZeYDommVrKNgH1KZKFtzT5bFXi6NpfDtdhERCJ+DDB+FKsiXvZStUbrb5X
	LWc2W+skFYpAMvKxzR9jAoJAM/32pqPiMZNJs+K/FNHJFPs9/qiAl1FxmKLGM0jmAbu2uS
	eWYtqHfRHiIpOgesa1cmvhHQjsJdfbs=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=dxI0VzCP;
	spf=pass (imf15.hostedemail.com: domain of xueyuan.chen21@gmail.com designates 74.125.82.175 as permitted sender) smtp.mailfrom=xueyuan.chen21@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794106445;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rKErtvNWkBsK/2nMmPPXo8mzP9NrOokMadJ8yLKh6Gc=;
	b=ExKodEPewJuJWafhh9VBZCKbzvuzBLe8IjXb3ZQ452ruv/OGbn+4bHnt2gdic+RPX2xB7b
	F4vymV0Z1GlRr+5Pvf1yimZIEV0r+jZWbNTTYyBkyy1aRjoUhtYmZswpotFBnSYZFfdP9U
	wrmH4amuJKY061J2rcWNEIDvsqeCyGw=
Received: by mail-dy1-f175.google.com with SMTP id 5a478bee46e88-33c10faf6easo14930eec.0
        for <linux-mm@kvack.org>; Sat, 07 Nov 2026 18:54:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794106444; x=1794711244; darn=kvack.org;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=rKErtvNWkBsK/2nMmPPXo8mzP9NrOokMadJ8yLKh6Gc=;
        b=dxI0VzCPRs+2ScO8NsQVWjLU3721Z1wycXGNOkQ5bBSdCHp9HL41cG1cOvHuWBveHW
         qHLw6QhXMBKVTpQcgwXLt9IR+RK4sFSaUr5vFIuZ+3EEk5wreTgtNlMYCBghZj69ToaI
         yF2LoL3FIKLXcbJauDg/ecjotI3LI6g6/7e0gbrVl2AQBBPuHLCsvc7ouuMXqU5gVeXk
         Wmby0fBnMTV74YUzqdwBBv4aczBp+DMXEJJNKJsctzwQyz+bB6YOUcwI5CoXA/bOuBTp
         9ufGmeLJilMOgSUR6m/8yrRFt8uBEeLkq4b+I/kZCj2GMXNhuRVuHk16hPWOPIG86DFe
         qIRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794106444; x=1794711244;
        h=message-id:date:references:in-reply-to:cc:to:from:subject
         :content-transfer-encoding:content-type:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rKErtvNWkBsK/2nMmPPXo8mzP9NrOokMadJ8yLKh6Gc=;
        b=1MwTtkIoOeJjBggMIen4j4u9o5jSbqMdLbRPjsdJHGy7gBvnzRGC7hIPu3wmn1N8+w
         soXaIw0UKc5mS6yTMTaBsEg78rBKrROrXTnCj/a3iP6GeyRx+xh1BwfQcaREbn7LNK+m
         jlFAyJiHqbM8AJ06TgA9SRoSvQb3v1eIdOf/Zwmg0iDHDqEQg8QwWZPR3cjC5o9SX34n
         U2nz8N1UmNp8QInkYOcOjkId0CrfuzhNJGDTf8+BcGFu1n0gE9bK0RekWnfOIh0zmOS1
         Ttgy/aORNlqwuQGl294IpQIKISM+m2yRJqpcIHcD+bCpz/Z3egJ/bQEEaXXNUJRwQ1d0
         MIag==
X-Forwarded-Encrypted: i=1; AL+hErFUNMslnTQR+FJjpEHBzJ4Y9FLE3RjOvMLBO+Hyi+CkXweYnOnTLcU/iVWX+f4i3NbSMSJGsRis3Q==@kvack.org
X-Gm-Message-State: APuU4Z9GYl7cZ7Moe1++1/WL204jTSROngWqgRuJDAVHvt6qGUHt1kPj
	HElXkgBixfyz41lVX82/5vrNWkLlzery+sJ+NW+WpD4nkdKAfSUHVG2/
X-Gm-Gg: AYBFou0Ecjp7dzQfTyHW9JvdK7DdJ5XnXXmzWij2HTdGJ6D9YrIzX/28WCsRw993im7
	ItQqeb263MyAegnvncKJMVe+SrrbTbzlf+PxdtkzkOxcPfcUKMZXqNh2IRL4LVy4gpimmI6DGRJ
	tz8BWWwlSKZh2BXvnYaB1AYcT2wJhQ83PQcL34i7eEtpp/j0ni4wuMU4izjmGFL7CGY48YZVF9+
	F78JDvrPiZxvat+rKMq9Y0AibV1JsDuDRz1ZnlvOEdqYbjj2tuDZKXP/kvrfGNk0LgNQ7da68rI
	p5gRYaQf1hQQKoel1gs50hDPuA4XQpnvFmKtFQmCtJFEuHHpsJHB+OhPSzysv8fQWLAq3WQyl8S
	8amUjIy7/Jl6Y9MGtgiNRQDlWH2nMkSYLLFZ6lE/7+jkNUZxCh6YtQ2heul10LVI+2dJIq0cYsr
	bjog+0+TMFJyt0PF29oopBIcP3OYwxnrWfzoHx0imh38HvZlPlZseD/9EN/4qjVKSOMluz2Q8eP
	+jQqlcudhvUCbM4D0TVgP7yYdyWzJqE1mBd18aojJZpxECSLmmzNLmcG6M29ENcVnCV66FuTn68
	o1ywXyRESKU3/e2aWa2tg06iiBzam3qsd+IFIIr37HJxkFvlOcm54OKCprSuV6ld0388KNjbK+v
	IerBrg7tbCXZN
X-Received: by 2002:a05:693c:87c9:10b0:36d:5fbc:8c8d with SMTP id 5a478bee46e88-37255475244mr1965227eec.2.1794106443908;
        Sat, 07 Nov 2026 18:54:03 -0800 (PST)
Received: from o6.lan ([2602:fce1:44f:115e::])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-37265efd2dcsm1849390eec.17.2026.11.07.18.54.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 07 Nov 2026 18:54:03 -0800 (PST)
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] mm/zsmalloc: keep fullness stats consistent with
 CONFIG_ZSMALLOC_STAT
From: Xueyuan Chen <xueyuan.chen21@gmail.com>
To: Nhat Pham <nphamcs@gmail.com>
Cc: Xueyuan Chen <xueyuan.chen21@gmail.com>, 
 Minchan Kim <minchan@kernel.org>, 
 Sergey Senozhatsky <senozhatsky@chromium.org>, 
 Andrew Morton <akpm@linux-foundation.org>, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org
In-Reply-To: <CAKEwX=P+8AhOV-HQGHmtWftMs=if7LTk6K16Q39bJyF3DFFtdA@mail.gmail.com>
References: <20261106-zsmalloc_stat-v1-1-b574f4714adf@gmail.com>
 <CAKEwX=P+8AhOV-HQGHmtWftMs=if7LTk6K16Q39bJyF3DFFtdA@mail.gmail.com>
Date: Sun, 08 Nov 2026 10:53:59 +0800
Message-Id: <179410643928.425802.15371130916450367499.b4-reply@b4>
X-Mailer: b4 0.16.0
X-Spam-Status: No, score=-4.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,HK_RANDOM_FROM,MAILING_LIST_MULTI,
	SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 79DACA0004
X-Stat-Signature: ehk1sob3hu9jafzyot5gifgc9quqjtd8
X-Rspam-User: 
X-HE-Tag: 1794106445-707958
X-HE-Meta: U2FsdGVkX1/RggrpvMFkfZUlLh3GRpH1qeG96D3qFPJNgQrcVhHt5M52Y9Co71d22MUDFucN17UmaII52kqR/6Es9zRVkesiLg+PL4E1moKwX5fcFQLTcEwwBzuj2UxfWR22efyyrfjpPN2c/yWVLXr1nRh9aVVy+C4H1byhrNgWuS9gpBmhEXPwFIeEHRAHjdQbxHDHHr2xE3sFmHJ736zZ0elH4UCY+NX7jFdJhCG9J4lcuTmqumkoA0mjYQTQAwSnbbmWY7P1DsAsVT3OLG8jjzk3PDJRxilfYn4V3FdPzVkgFrd0blBZA97rjgrCvrKUXatKelfDLnQqb2tSRvgDmUNlHRSqQQA3n8BYjSsO6KxUl3j2mv2RJ+2RWFTlVfvO/ekn236Q06ye6OeKUafmAx5VEcgtL5YhMLh65MQo7zupAad4RpY9181WwzBvZ2Ukk1jSzY0xY0CCQUtYxXdscoBVvYmqoVWtJews/S26xu1AJ0nc91cBqbVUCFG2RdWoavLHPEPl5mYz0MoWGOaNbtplC+rJ5ztDNOGf7f6rGGe2msJlUk/t0tvYHROUKyZVhhMABW9SwiWVKddGaYXDEMe+a1UcF/nSX9zEIfR+ZhyYMu+bv9H7MLVwYRqIwCya0/J3Gk8JAifsFJuuVVdlF5iKf1xYDJ4Vn8f/qceBM7Ehc2UX8VMb+gdaqZQA5WFeiacBXXk/diX+lcae+VPku5fbMx8Ngbq1dXIXfcE61FSvhxTjmPckQ9Vnj0dt0Q/5OMYsNFGjCy/Ot/XNokBl2H20Xc7MIoW8Aq1ITTJeixM1RNDxNAq1BX22NPUKAA1WZmGQcGoLY0VLwEKl1lXBJQ8DtSe/kVcUHTa4W9Vl5u+9+LPV7UIBgGQjhTO1VpjFwgVnRixVg7IVPWAlZjjw3nv+PPriAn3HoPl7dZpxYf9fXGhDbx4f3u/xJZEKjRNbhl5FI0UIH6b4x0C
 Py4Fe/zP
 Gl0je7Jhfe4kfiStKbqd5kBEa0ErQoFfUolgfdkfX348lDOXDivDxQGtAB8GrBSPl/bpXH6vKZnWZKVZfSPNW/UcTSu8uFp74CnUvu5Dry9/PwCRVeuGJbWni/UpayECpqOkHSTTbrFJMKP8uLjU5XToTN2Q56n1tafdq46yZhubgp8f6Arfi5eAWDgKyA327MLfvtHBDSGOcNRel8hzeMj6K12FnncComGMfchnBEXdG4ZqWadjYB8PohNQ32xv3aaliFQYKJoff0P70ho4Pv68MyCol5ipy7NlN0EJ9wgT8BfcGO3KHPE1FAmdRSCpMr64chRye1AiTbl5MvJiK8g/Io8D7AzLAQ+hEjLIOOCULEKog8QXez2tvomVBo8VR2bizZpzaBlWlD1hwhiBybLQsfwGzDEE/Qw8CrNf3BIWgVjcXAZxXZnnisunFBqOiJOlKfrzouRqv0QLimZAiEYEgbWOSOG7rLcPUw1AZeofnxBt7Ezx3mrQtTXdkI1cznfs7uJsSfGNTAyTXKtDHILiPmDsm8p++HPKha7Ivuw3sX5Vehk2CsyDP0XV6VoQhMwY9
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On 2026-11-06 09:34 -0700, Nhat Pham wrote:
> On Fri, Nov 6, 2026 at 2:56 AM Xueyuan Chen <xueyuan.chen21@gmail.com> wrote:
> >
> > The fullness-group counters are only used by the debugfs classes report,
> > which is enabled by CONFIG_ZSMALLOC_STAT. However, these counters are
> > stored and updated even when the option is disabled.
> >
> > Make the counter storage and updates conditional on CONFIG_ZSMALLOC_STAT.
> > Keep ZS_OBJS_ALLOCATED and ZS_OBJS_INUSE, since zs_can_compact()
> > still needs these counters.
> >
> > The behavior with CONFIG_ZSMALLOC_STAT=y remains unchanged.
> 

Hi Nhat,

> Do we need CONFIG_ZSMALLOC_STAT in the first place? Is the overhead that high?

Good idea, thanks. CONFIG_ZSMALLOC_STAT only controls the debugfs
interface; the counters are updated either way.

In my zram tests without readers, fullness counter updates changed CPU
time by less than 0.1%. Reading the stats adds overhead that depends on
the polling frequency.

Dropping CONFIG_ZSMALLOC_STAT seems simpler.

> 
> Also we already have a #ifdef CONFIG_ZSMALLOC_STAT section. Can we
> just move these helpers inside it, and provide no-op skeletons in
> !CONFIG_ZSMALLOC_STAT case?
> 
> And if we're going to have CONFIG_ZSMALLOC_STAT,  anything else can we
> wrap in CONFIG_ZSMALLOC_STAT? stat field of struct size_class? struct
> zs_size_stat's definition?
> 
> 



