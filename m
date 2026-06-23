Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E646DCDB46F
	for <linux-mm@archiver.kernel.org>; Tue, 23 Jun 2026 10:52:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9C50E6B0088; Tue, 23 Jun 2026 06:52:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 99D3B6B008A; Tue, 23 Jun 2026 06:52:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8B4C46B008C; Tue, 23 Jun 2026 06:52:07 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 6103C6B0088
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 06:52:07 -0400 (EDT)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D631740452
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:06 +0000 (UTC)
X-FDA: 84910862652.06.934E3C9
Received: from mail-ed1-f73.google.com (mail-ed1-f73.google.com [209.85.208.73])
	by imf17.hostedemail.com (Postfix) with ESMTP id 0FF7040004
	for <linux-mm@kvack.org>; Tue, 23 Jun 2026 10:52:04 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dqyQfZSH;
	spf=pass (imf17.hostedemail.com: domain of 3U2U6agkKCGAR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3U2U6agkKCGAR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782211925;
	b=xVPKj/ar246QBZe8Kk/Ux8iGXEQyb/Cy66V6Hl2XVEtvDHShkOobBoTQL2BnWt17HCHtZ1
	uGPGc52E/HzqQjXjoRKl8z/NEj3hykwfrRItiQYL+j9evIP9226N5FbiGpI0XRUdGiuwEZ
	OpzwsIaZSAx7DfdrknqJlVFWxcoKET0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782211925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=CTCz4sMSsafNhU5kYM2pwCVlzIjBwvspLMJZApXNuTI=;
	b=GwtvmVl2EjMPS8L+6rgQjHm8MmqoC/1beQEeq5mc6NVDxyWpuCatdG6+eXg5G7YXuq7T7R
	P3hwb70HniHs6TvlMYBsg2S/koUsgH4gSI2JSl7P2N5B6idD/+07JkOSr5qYLpfIruIhi6
	oEhRSEgghNsIfsprh9tma0AmV9HzzRA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=dqyQfZSH;
	spf=pass (imf17.hostedemail.com: domain of 3U2U6agkKCGAR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com designates 209.85.208.73 as permitted sender) smtp.mailfrom=3U2U6agkKCGAR8PSLQ8FSEMMEJC.AMKJGLSV-KKIT8AI.MPE@flex--tarunsahu.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-ed1-f73.google.com with SMTP id 4fb4d7f45d1cf-696bf062625so4393944a12.2
        for <linux-mm@kvack.org>; Tue, 23 Jun 2026 03:52:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782211923; x=1782816723; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=CTCz4sMSsafNhU5kYM2pwCVlzIjBwvspLMJZApXNuTI=;
        b=dqyQfZSHuckfE8iqyYA3txpclE/XLNUDdKvvDVT3yn3va59j913MhGuospRTTHG7go
         cd/pJrl/hd6ev3OBbj165IExLSx9aS1BRSi6TrIb7UI9cAcCBNY+yj1e/CHaDOQgUKJk
         qhm41/XDJ25bUzvlncVEwwFR+vv4UiAdCRERJvrGAcoNtt0gpvpMrvMu8TVtkRSsYzau
         RCciGTxNy7zA4IYOFqSAPpQ68PmOYh7fsKBMCVZHqZLX2e3d4AdX6WmL4L4AwcVXsRwa
         xLGuyxe+seZlKFxFozLBT3lqCaDwobCvHvTotLPIXNc6SPcoxoc/OjGN4LtGD0+6irpr
         owLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782211923; x=1782816723;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CTCz4sMSsafNhU5kYM2pwCVlzIjBwvspLMJZApXNuTI=;
        b=BAyN/lDZY8wn5HlXXD7HzH4HfNXCqbJEGvbcdnkpW0KIh9QVszRBmjFypQ6+skThUG
         8MxypjkP3t6kIuY+t7tv9vrTXHzQVVAKGQnqEdA7nh69s6z1Aygk9AXMpBTsr2VEs/iM
         wWB/C5hfk+pp7a7pQ5ijHqBCtOq0iKvB86BnFgT40jVLswvyufdqhGmmEOI/8y4Jdgc5
         DxWLNeMr4Fk+h4KmgVKQw6enDtJJtFh+HxFd2W+Ae440pfcIi/lrSio/VKf5k3Y8UjFv
         e+vn/Ig/1QHT5imrYBri7QzidSK59AF7ixO4ZjRTsnRm7FNdGD2uc09YSkTqdmrL2oiW
         WcZQ==
X-Forwarded-Encrypted: i=1; AFNElJ/gh3zSsoJsYg9gmzvQt8Fq4s4qwYJsQ0T0x9Kb6qEUnPOTMfSTWiT2zE6tZaAjym1OM179ZIzxBQ==@kvack.org
X-Gm-Message-State: AOJu0YwgnECCY1giioMjcqEjHmYk4jGrdgRE2VzRrfNrQCspxls07bxR
	bT9kddQLWs/bJ4XwNPoKDNF9C+1VFNiIhWxatfSMVTFR+MJaPajmx+Gu2bZWV34YzC+uZp2Gi1x
	j1AHu+4aFkVQnk9QmIg==
X-Received: from edvl5.prod.google.com ([2002:a05:6402:285:b0:697:de18:6de9])
 (user=tarunsahu job=prod-delivery.src-stubby-dispatcher) by
 2002:a05:6402:2803:b0:691:a8bd:981d with SMTP id 4fb4d7f45d1cf-697dbad110dmr1143090a12.4.1782211923249;
 Tue, 23 Jun 2026 03:52:03 -0700 (PDT)
Date: Tue, 23 Jun 2026 10:51:58 +0000
Mime-Version: 1.0
X-Mailer: git-send-email 2.55.0.rc0.786.g65d90a0328-goog
Message-ID: <20260623105201.3724592-1-tarunsahu@google.com>
Subject: [PATCH v5 0/2] luo: convert serialized ptr to KHOSER_PTR
From: Tarun Sahu <tarunsahu@google.com>
To: Mike Rapoport <rppt@kernel.org>, Pasha Tatashin <pasha.tatashin@soleen.com>, 
	Pratyush Yadav <pratyush@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, 
	Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, Tarun Sahu <tarunsahu@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Rspam-User: 
X-Stat-Signature: 9c38f8871mnzdgicka544s7qtp91ppb4
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0FF7040004
X-HE-Tag: 1782211924-60312
X-HE-Meta: U2FsdGVkX1/zI783fE+8/v93snORWdB3tNJpgc5NxbXYDG5dhyqMf0uRakPRGhXrqzRnek8MwxZSlc9Clxbj5x29QZaw7PqxlJIrh1vA90PkvsavUIi7VZnvT0fULlZIj/4uDnyKupv3BP6ZNKRYT5GGnai+RrWzFRWxy+nYIbD3DprSWQhMSIB+zhU3hzQ4r/2GPOfD0a+uH69Sw9r3QZJOJwQgJYY/chOmVxVWLfwTORijFZrQH82JQ8rRp8FNkkfTQJUnulHy4vvPxtcPswPVAvxMWj/RzsQi4BYO3zET3pGAeZW58ZL4drD2QrZ6L3iNIZBgj+1UjTEeW8kk9rUlTp+2rqF0haaoT2NbVgg2NoluBSOr0RTqLNOz1K9i3lXXXiAQmQ9AC4cLI8Ob4/IEs17vZkPDIC1e88anUOpSZY8LqiJAZWywsb4rnzQ19QYbYtMCtqG6L6pDMbff4pi3iqhQ3AQd69XctqSESWBuXx2d5WXs0XKu08XBvJFtTd3HPUZraq2jkW/EiIIPawgwg8eb/CNZYCJ30F5rKO5dfdfpCToXDT9YH18PCp8DX1LvHCXJZ20Cexu7RG1YD61o5HDjJ1aercQy7cO1ELxpTdG3NlJAybhwi9tl34DgU8R3ur/s3jdJID6sxZyJnwuUyvplYrevay8bQWzWTsp3PxgksRQ4Akoxgi7f35ckNwUlKoIfhCYjUFH7QrfpfuRcH5KPmIT/m3eiz2ZNZBHFnrocic+Opq9oIRzMAHzGcS9O1xCk1e+VEM4ScgU44c56rH3IAXWoHvlHpAiRA1S0a+Wo+YpFsXM/XEozNCV/dMN0IrQrxXL5ZNpsHvLMizdbFMJ0UhKT/iEYHIvyVUd7dtR5GmR+/ClW0jVp736RpWoSyi0mst/jImeJBLvtewL++2ydvWQKNO4cMRkuzXP4PPbQBwFOCl8l0g23FHMjf/K4NOhzVBdoL7i+U2n
 JbNAiwp+
 jnt+v6HURRuhpM/b2fDt4HH8z3g9ykusGvtw0DJyRMXB2s0z9Werk7Sr5z5LoYyl0vWumWqNcGD/b7WcfuYn+COQ1HoAYOZYQlA8TWzyWmmCa8/oC7zllTa6RxvaF9U4dYYXaUqiHq87K4+0T/CkCE6UFHfvzNquHhsIR2Yr1RzG9fQvPgbTX0rNyw9/URmXTfgXUrD7V7zNZexqQqF2c9Lw2iRS4h8RZyprvtvu+pe9nwLOepofJ4AzAHum53NE+y/QJz3Axan7+CRpNEefg90cvVHw76nV/TU0H1SO9K7NQcMdUAkrK15dnzLrPuEG+OP2562qB2uU6Qccef0bRWfXhNVrKik2TgdDUz2mDm1ZcNNkMtd1X3MEGyd7BCbdr+MCAw7L+6LhpahcMemnEI/FdNpHFdC+4sCfg56Visxf6k6H5kGHqdXXpu5Txx7h6Q1kUEUNG6kq2aZqgcE5tE7tKZLVsUCMYRae/Amb/G2TpANRt6cJvrt0+Y+Ht2liMPTDg0BjvLtPn1NSpeRCcUm2NNGdwPGaVSdUJAXjB6ZDYnr38myLhpnavzo3JvhtlEym4Wpwzau4pLuyIV43gS48eG/DaUE0gdQ4kSY/3sHZHZXeHek8fEFSlAA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Convert raw serialized_data to KHO serializeable pointer (KHOSER_PTR).
This series also takes care of resolving the bug with memfd of using
phys_to_virt before checking the args->serialized_data value.

v5 <- v4
	separate the memfd_luo fix in a new commit to allow backport if
	needed.

v4 <- RESEND V3
	use only KHOSER_COPY_PTR and have compiler time check for type
	excluding void * types. Remove TYPE(UN)SAFE variants.
RESEND V3:
	Sent incorrect thread format earlier, this one is with correct
	one.
v3 <- v2
	Rebased on top of liveupdate/next
v2 <- v1
	Use KHOSER_PTR across liveupdate files instead of only memfd_luo

Tarun Sahu (3):
  mm/memfd_luo: validate serialized_data before conversion
  kho: add KHOSER_COPY_PTR to allow phys copy of serialized ptr
  luo: Update serialized data to use KHOSER_PTR

 include/linux/kho/abi/kexec_handover.h | 11 +++++++++++
 include/linux/kho/abi/luo.h            |  5 +++--
 include/linux/liveupdate.h             |  4 ++--
 kernel/liveupdate/luo_file.c           | 24 ++++++++++++------------
 mm/memfd_luo.c                         | 22 +++++++++++++---------
 5 files changed, 41 insertions(+), 25 deletions(-)


base-commit: e98a9c61721c14bcd29f11f4802e52e908701f7a
-- 
2.55.0.rc0.786.g65d90a0328-goog


