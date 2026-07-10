Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC570C43458
	for <linux-mm@archiver.kernel.org>; Fri, 10 Jul 2026 08:59:21 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C7F286B0093; Fri, 10 Jul 2026 04:59:20 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C2F9A6B0095; Fri, 10 Jul 2026 04:59:20 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B21606B0096; Fri, 10 Jul 2026 04:59:20 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 924256B0093
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 04:59:20 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 121D01403AF
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:59:20 +0000 (UTC)
X-FDA: 84972268080.27.1D2834A
Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	by imf16.hostedemail.com (Postfix) with ESMTP id 2DBC0180005
	for <linux-mm@kvack.org>; Fri, 10 Jul 2026 08:59:18 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PLMu1a+8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1783673958;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=QFJFUa9U+Wd4dV3ECgKJBk7rTN00h+APx5LP51q3LSk=;
	b=YgQ27u+rvtXdvOe9kAGH88YTgvAz//XgNPl5dfjijZ8jp5ZbE3Y+wbmHkaZtk5jBYSdulo
	K9PzvOB5uctIDNLF9jUWK3FQFKeQM8V2T5aczfAl5xw0Lsx5QrNEm2do24BZMth+lLXIrc
	gyHnKwA9zotRGqIkwejVOD3k6vRKDU0=
ARC-Authentication-Results: i=2;
	imf16.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=PLMu1a+8;
	dmarc=pass (policy=none) header.from=gmail.com;
	arc=pass ("google.com:s=arc-20260327:i=1");
	spf=pass (imf16.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 209.85.221.46 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1783673958;
	b=LPuyS8f8C53TZJLF4BhyeEsdAXUNS1//FQoV0Akjcpbg8cUjwl37vEx7fBgMzyOb4u2OiW
	NuMwSZW9rOZeh8P5nw0iq3ML5ScPVU6XsfbVNq6xZ8tmpp+knbrsa+Jg2I8hbWRJqik2pg
	5Ph+dk8UETKeVQEHSOXRqBmoWPfcoeY=
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4629051c9d1so407489f8f.2
        for <linux-mm@kvack.org>; Fri, 10 Jul 2026 01:59:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783673957; cv=none;
        d=google.com; s=arc-20260327;
        b=lxX8Q/WRAXLMYzSo21qv+tjG0Wk0kKzL5rE/7qPfgaRsjCaHJ32VdCiyNbh/P3fd30
         hU6i+LtHhGeFLvJKk9pX13uAy05g+wCrUGaSiRkbi9owrxZuJd9eqb1kSQecWqF+ov13
         FGtEJ2Jn5zLkhpBRzO3Q1WZjbgaLq4NLQCgbOql7C5JYWtcTvvdPr/OEU4yY+0DCrYiP
         tOYSknqwfBZlbdotji+oehjPUnw99I1xA/yqitkT5ZAUua1QGg6+EIwIrWIF20PXSNse
         X/7oXDjvjUufkR6V2xgTpIgaO72MoYIreFBjlVCZf1HiPFMJ2feItj2occb/o1A9RLto
         IATA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=QFJFUa9U+Wd4dV3ECgKJBk7rTN00h+APx5LP51q3LSk=;
        fh=YtECev1mW0ey85Nl/lVJ2i4KiFOIEVYNCt9cecN7B78=;
        b=Q9ObBAuEv+hiJllQO+8cRx3EFPTnFaNHRft6yJ1NJZRwsA52tgIdhXo93dKt1tXg0/
         SVQzYcYTxCg7KXO6vxSFfcjnashij3/CUSNPzXeSOPZ0u8u8QyaDpgkmMuy2h/lru/jj
         T809HKuI8zR5YOjqjuerqG/c7oE/JIHCKmejkpaI/XEz0A6Tz5Jhh6rVSbbYP64afy+9
         Sux2IhF96eijd/sQcAlEqZr0qaqRhpxwi8Np4R0zeTdhlCb2saO5SgmqTQ7r9R70A7ss
         AAyKhdICox0HLXV9dtz8odsL+ldV3JNV6sPmb4NnDb7L4s7aXgKA/dr7xR4oxoEblkSX
         NMjA==;
        darn=kvack.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1783673957; x=1784278757; darn=kvack.org;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QFJFUa9U+Wd4dV3ECgKJBk7rTN00h+APx5LP51q3LSk=;
        b=PLMu1a+8WtF2O6uO6DVeOylvEm50A4udVioi9svDQ40fFZ2SXRZbup9HaOcwdBVgqd
         G9m8pG7VchdFk5Mlb9d5ShiwMQKN5rBIVD6Tct0OdaXwtyn5HLaR7Z0PtvuLXOeyhYl+
         jYbJ+OIz/0b/dxoVUT4TaIuvM48uYZCfeJMXUyBvC/EFfP25qrLyekH1aP4x4GIqvT92
         /VYdMAe+WCbEO+Z/cum5WZtgjwflNLM8kyPnYSjqqO0b77JTzqF4BdJkg7hLGKlKDTd9
         F9T7b53ucI6Fh3JGt62Lc3REtUIpiDMKgTWal9HaP+EhKpO0/xNcZMxp0Cq42cZQYJ7s
         2pjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783673957; x=1784278757;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=QFJFUa9U+Wd4dV3ECgKJBk7rTN00h+APx5LP51q3LSk=;
        b=QrhsiIjnGnS6f/3H4IWJxdu4YurSYje/e+4oVI5tIubcPuoNWXF3scT7tB5Vj6MxWy
         qlO6sJgUs1Ddl5q0G5glEzRDFn+9QDrhKyYzFNFd887dnUQ4rkZbUaKH0Y18wytfHKJC
         4WvakYtek4UfJjpDOHtZviPtVyrLWGcJTJ0rrcBsThBfivLFA558gW/qIMssSIAalzb0
         +jp1bqqaWNxo+t4mCjYtDFjyk2LD+nZ3yss2Y+JGTcgnovkWQm4mebsIctL7dk/yRMoa
         bUZ0F3i4jkilEPMrvg+5u67pPIZyrGXtkrDd2/kIqQhfFbVKbeH9g/jazYtho1kVqXIG
         sDLQ==
X-Forwarded-Encrypted: i=1; AHgh+RrmeAL63pETlJilvNAkZycaCWOffiP+twnMhjOfy3+oJzNL7lHaBJ7hPu2x7hswpTtbVCO5cUr0+Q==@kvack.org
X-Gm-Message-State: AOJu0YxdZZXiZjKFLURv7d/BeTOrPkRg/Or7vqTXLqwuwHj04Pt0NfKc
	QKxDWEP1DXYlAEsm2e8UU5b7istNCNGwHweE/YMOSxMM469ePwCr6v/hb06xHoOe0xiijhjXRIW
	mJIQw/S08CNduJJWTNJRNyTp+WeI5E44=
X-Gm-Gg: AfdE7ckNwEBjB10YnQxowfhzo83yJNJTmAhEE5U/mJRxtkGCROc/eVz07JPEOjWiXKf
	HwJeGqx/Wn9omICPlhzFHCaPR4UjkEyLuqpHs7CMvLapw7u5GaPOpSpfqCy/jTIrWw9zeRf0ANE
	RQLnsrSQCel55wgnDKY+9dRL0MLYlfovpQ/hpuKCbhbB5pSWt/XWmrLOLr6uBIYO0jB0VKI2jNn
	+bmafj8yPvVyU856P/BJdeS2L31XZ9c6yAchf88iYPm31E3PPhHbbf2xxAgc1ZKiSXJfi74WQ==
X-Received: by 2002:a05:6000:2f81:b0:475:f0f0:9ed0 with SMTP id
 ffacd0b85a97d-47df081bb63mr11414238f8f.59.1783673956505; Fri, 10 Jul 2026
 01:59:16 -0700 (PDT)
MIME-Version: 1.0
References: <20260709073823.6643-1-jiangwen6@xiaomi.com> <20260709160805.26e63bae89dd03cf2951104e@linux-foundation.org>
 <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
In-Reply-To: <CAHKocdH5kp5kTtZht+v5j-4-Thh40TGvif3=kRMgErRXr+Q+RQ@mail.gmail.com>
From: Wen Jiang <jiangwenxiaomi@gmail.com>
Date: Fri, 10 Jul 2026 16:59:05 +0800
X-Gm-Features: AUfX_mzXEAbv_zvZQyMV8FF6rcSN6wSGVwLZkYaAWCZNboEUdl5KwDesvzC9cg8
Message-ID: <CAHKocdFs0XAqWbjz2phTZDwHkx3Tt4QgbkjXA95GK_o3-RQwog@mail.gmail.com>
Subject: Re: [PATCH v6 0/6] mm/vmalloc: Speed up ioremap, vmalloc and vmap
 with contiguous memory
To: Andrew Morton <akpm@linux-foundation.org>
Cc: catalin.marinas@arm.com, linux-mm@kvack.org, urezki@gmail.com, 
	will@kernel.org, Xueyuan.chen21@gmail.com, ajd@linux.ibm.com, 
	anshuman.khandual@arm.com, david@kernel.org, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	rppt@kernel.org, ryan.roberts@arm.com, dev.jain@arm.com, 
	Wen Jiang <jiangwen6@xiaomi.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Queue-Id: 2DBC0180005
X-Stat-Signature: dxdqs5yd9yxqs6uf6pfqmajtdbn41e7i
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-HE-Tag: 1783673958-687791
X-HE-Meta: U2FsdGVkX1+935F0rvrzFnv0MXQZSb7nE8bp3lNyK6jSqnZUcd6N8hd6InyIPgDLX2bED8VPRwzKNdC8zvz6zMiV2v9QsAc9kamDNljvTT9/QP03xqXL+5fO9CZ49TZ4dXToeRBYWKCdYRv+WX5qNMOF8lpUavPxdxrG6KEt9cLnx2wd38yjjxwLwUPEKXxC7VsB4eIG0+cb6GGZNPLYXcf9JQDcO1S5/G5XsFlaKDR7tIhHZoG+Mnkjo5jqJZY+Pz6RT3/p2EyR3GqMvLQmxelccLNkFdC2k3HT/AIQS8al0B+Hn8B3b+1hNiH452a6VqNuGf4hUJOlDvfZXC1/jKMcJ1y82TOER/N6X/C0e6QDIW56C3QyLvR4TGpoT0pDjFwdyEJr62VmSyHPUOtyCnVp5i8su9kHYvdYpTFvdl3C9M2a7TB5egcHC/LbrWdsZcjuw5ASwWf99QRcHtoUJBmFU7Q6Hn3enQw2iQHb0JvV+8Fb4qkKCsKtvnZLPfvB32Nikn6g34pNAgZPxlpaFmdqt8giUgirUIDcZ9gkGO0MoZ4cPWTKR+3ktvtp9kBwMdin0f5jdnyZVxcM1HQ3tpI0rhm+PxD4DBTuurhTblE9CJFls5FKU49pYR2SzykPMjuXLBliEUAm2+JHfdbokmtI10R5VzmfU2wxHw1ijOeVheyA3TrA667oek4al23BHgqMB+gICOMzDBHR+87X0eqt/R3rdi2CCXe59B78Hd17f+uKaAsy7QmCoQXPvaiik9VtM1qkm5/x9JWiifixmYap2BEfsdCLjBRdnuOMII90nzOY/A8rPYYQHzyFkIEpfeCQb7w8G+XP3O68dcYZwAp0FbFJ56AcNMYXRsgla7sPx1gMwB3sGs4WYRxb6fwmgRsfm92En0RFwGAAbf6uaJ1yytDgAFVGOWir3VYCG1Oz5CbhPUOSyVFa5ht1X9VWtxdOFcNiOvAiwtuGHhw
 x5QqsqwW
 kB1QGGYgG9h7VIjmen8ny6gcRohqQlEpYaKdfBH5HrybNBh22vNAEgNhyii0ab4QFswAy3e2+oicKUMFVrbXRRKv+K1GC2QfSh1wtWkcirHWdsJLNfvu7rbs/HrGOhkGPb2O5LrLdxI4KpX8jkmUNMhuj4nUMW9llct0+J/GbT7/McXWmGBb1HCNz5yc19FDh5Ete80rtFVOLfY3wz0AYedllwU9QLi3ncYSAtTRb9bJdzuY/Xs6wnHLJ8MWl5vDtYVFSXAOBEom1sZMkMvmmkd+OltqSZixh5g4eTixmQbTc7Io/iMkoT/nDEZZkAHqN/qnXfV+ZEMLJYqYtIcVD6ISSvs9nA/0X4+DeZfj3WXMe9wQMIaQx3yzc/xkjW4EAkM3jPdU14FnRdONdX1qI6dAuq/PmiDqg3uw6awMsHrfDR7ivniOCZAVsMMpB4PFdEgJM0O0Kv2cE/d8HVlKEr8K9SLOORXBFx2v6aXe+YbaCvR5ZBjsru15NAQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri, 10 Jul 2026 at 16:54, Wen Jiang <jiangwenxiaomi@gmail.com> wrote:
>
> - Patch 6 (32-bit count << PAGE_SHIFT overflow): Pre-existing. This was
>     already discussed in the V3 thread, and a separate fix was proposed
>     there.
>

Small correction: I meant that I plan to send a separate fix after this
  series is merged.

> Thanks,
> Wen

