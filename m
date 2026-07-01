Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2AD53C43602
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 04:21:17 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B47FE6B00A6; Wed,  1 Jul 2026 00:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF8916B00A8; Wed,  1 Jul 2026 00:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9E8CB6B00A9; Wed,  1 Jul 2026 00:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 75BF66B00A6
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 00:21:15 -0400 (EDT)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E27671C0D54
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:21:14 +0000 (UTC)
X-FDA: 84938908068.13.F7DA631
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	by imf22.hostedemail.com (Postfix) with ESMTP id 9EB26C0004
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 04:21:10 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OJeMaUUX;
	spf=pass (imf22.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782879673;
	b=Mw67PgV/Fm7cvIqgeNDUJiErYIQlqLYH07Rwz4lVrUpoTqmzH56rDOrYDzHDz2GcOteO3q
	EvVbdtbR5S9mBXHWp4HUFYYU44QHNpHGriNBkCsjDWCOrTtPQ1Z4U2JE7rdji6VNa29tMc
	q1jwdy5UXKkwccI/n/SX0zp/TjEDi3o=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782879673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=wIXJacBAyEaKz61QqT13AHUcLwATDSXxJV4uZgWwmww=;
	b=Pe+1xUdX+bvGKzFWKauwbbjhLkPywyEdrpCLCG25ktzMfL/DgaBMe9nRERzuwFensWJ9ZW
	Xt4w+8fVSaOCdpMs9gQiVvfvKSs4gfGAx5gfXmYRbBMwPIfLrDL4AxxmE3CNIWf1SFdRYC
	EptHHvD/bBp4sycw/poS6QQE6JlG9Xw=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=OJeMaUUX;
	spf=pass (imf22.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.180 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2c82538b6b0so1281115ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 21:21:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1782879669; x=1783484469; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=wIXJacBAyEaKz61QqT13AHUcLwATDSXxJV4uZgWwmww=;
        b=OJeMaUUX7AVU/rnnyUC1KZD1l5PidUI6hBNRmmca7BMKCdvv0t+bbtu7Yx5I+eFRxo
         JPavPECiiUuRyiYOWp0IpD4vOTje6jJg4d0HvY5HZJmyZa+DTgcuz6BCCySia34wAekw
         VEvPb5IxsCE56+AlaOw4b+nJZyfIbm10RYNjgoRnHc8rcvZBWepfUAfPnRoFGvSZV0Rb
         C/gKhZkhma7kA68EEwVg2l/UWeBtUlcKfhxG+/UfxJtDwA5MFjuTMpBK+T427bykz2xO
         UrjWGL995NluTMtLMAqr12BoZq9SCuGdVxkKwzDt38o2iqQr2Yi7q3lZjqnQHai3dSja
         R1ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782879669; x=1783484469;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wIXJacBAyEaKz61QqT13AHUcLwATDSXxJV4uZgWwmww=;
        b=YuSYlSxQzJP5qXJC9dvswGLZ7OIh93LXlFGaGkqvp+T1oJDPcULVlwH8CIOivdAT24
         mj4CrTqb0zuhJAVsyaqs6GyHj6KsyTsyTukksWl1P+CyFQuQt0yBKl4vwY2xGxgUfJhZ
         KntnjOkAWHNq6wovgNEOWebMH3fWpbhzvxAC4wNNmIkOmGds4nfvd/lFz2xyHzz4Qj8w
         8O+MbRdNBkdIzwBH2vgpOxFzMt/HwTKMmn0opYj5oIUh2EE/5LpyJSZ6a/sFCRxdJCTJ
         JwYMbgArjW3S4lHZg+rRbdG5rlnoJa04mPSH5SRYYAHfopbnXERUuUfvD/ZWUif0GZAq
         qKRA==
X-Forwarded-Encrypted: i=1; AHgh+RpdcVyOHJuF/wVZcgwrzkSrQ9HfwggmrKcEoCr4NZRvkaY8azt109GR5B51qd9c9ag5v/icQRloag==@kvack.org
X-Gm-Message-State: AOJu0YxPCr1ECD6zAn0Mp8dcqELsmx9sohXphuRvgwtbN4fd2laYkEAB
	+tSYt3yKxkHhuRKQz/lIrEjPdRMmvEclXZ/z5uGbTvCMcHb5ZRXAxhI/WjrqA2G9A1s=
X-Gm-Gg: AfdE7cltdbueYmDJKo7hiiVoKEf/CKhiYjP0IPJm4O8wtR/XwskmLgUHg0IrkpHJFzS
	4o3XbdyWzu/GKhedNO09Jed/s1jhEdRNX7oMmDPZPwx5G3dZ8RIVM+bILax5D93r4VhWbraZku7
	zy0XiCFGyCqcPA4xcBhUQ/jxrl52S2zPrawhBu4eU6VVmi9Gpmc10rbmwx5n6fAGwFq6WI6SEzn
	WHBoUpv3Y+79NQrOUgViBQHpUgS9cftR9HOBtn5KD9bTSkOW7l4OsYI3udKFMhaAvLs/H2dZwCw
	f5qxO644o8mp+X42F6U/2PTJ6giKURy4L9hHUR7oYgwgnnbltXFEedicqo+5/VTkcIic1fwtzUw
	Oo0hldvYptA9pW177ONSUoukT9w/qPYZCAV66E+tc/0DXSVRG0OFjTdtrAwUE2icX2/iyGQoya+
	hpNiVL+lQ2OqwGQmk7mkd45KLzNe8xBvcuOy1VmDUji121lw==
X-Received: by 2002:a17:902:d54f:b0:2ca:e3f:6a4a with SMTP id d9443c01a7336-2ca7e73b1bfmr1201915ad.21.1782879669155;
        Tue, 30 Jun 2026 21:21:09 -0700 (PDT)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.232])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37c73a9csm24450865ad.21.2026.06.30.21.20.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Tue, 30 Jun 2026 21:21:08 -0700 (PDT)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: pjw@kernel.org,
	palmer@dabbelt.com,
	aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	dennis@kernel.org,
	tj@kernel.org,
	cl@gentwo.org,
	ast@kernel.org,
	daniel@iogearbox.net,
	andrii@kernel.org,
	martin.lau@linux.dev,
	eddyz87@gmail.com,
	memxor@gmail.com,
	song@kernel.org,
	yonghong.song@linux.dev,
	jolsa@kernel.org,
	bjorn@kernel.org,
	pulehui@huawei.com,
	puranjay@kernel.org,
	thuth@redhat.com,
	ajones@ventanamicro.com,
	ben.dooks@codethink.co.uk,
	rkrcmar@ventanamicro.com,
	cuiyunhui@bytedance.com,
	samuel.holland@sifive.com,
	zong.li@sifive.com,
	conor.dooley@microchip.com,
	tglx@kernel.org,
	debug@rivosinc.com,
	seanwascoding@gmail.com,
	andybnac@gmail.com,
	menglong8.dong@gmail.com,
	cyrilbur@tenstorrent.com,
	wangruikang@iscas.ac.cn,
	atishp@rivosinc.com,
	apatel@ventanamicro.com,
	linux-riscv@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	bpf@vger.kernel.org,
	arnd@arndb.de,
	nathan@kernel.org,
	nick.desaulniers+lkml@gmail.com,
	morbo@google.com,
	justinstitt@google.com,
	qingfang.deng@siflower.com.cn,
	linux-arch@vger.kernel.org,
	llvm@lists.linux.dev
Subject: [PATCH v5 0/3] riscv: improve percpu helpers and PIO mapping
Date: Wed,  1 Jul 2026 12:20:38 +0800
Message-Id: <cover.1782877663.git.cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: 9EB26C0004
X-Stat-Signature: y3kpb3fwubw7etjek13wpxtsseputn7c
X-HE-Tag: 1782879670-898888
X-HE-Meta: U2FsdGVkX1/FN6LSmVdPlmJc1dQxPHzHd6j+Pwabahz7COt9mPZuiB12lplc0dLCH32Voqjf3n4QDgsEcLbkTLzbPGS5kIdajl36aITAY7F9yEGpeG2gkPZDNTVh6+mwH7tgJEsfJGdo19XsF8Q50boIg7HzZ+k/t67sVbK4RLc9CPsXJBkNnFuSuyfzJjSsmOsDFmtMO3wBt5aN39wIIW+1Wlj0Uk5uDPXiPKW6Kd7jPiE3wEXJM1Bdotc6rXiK2LWdF3hZIWpTcZWcGPP1Q7mbEKd7FtFbQ7iPrHuHLUtDoaWuiz51xFTr3y0qPeTIzsbGT7yF7xZank1r/dnQ7NUcTFYcGK+sxQvy47UFEsiqEU/cG3j6/RVVZh0pWElKwCWKcvEwhNT4irInwZCycIfsC90Rbav8n95py2eCBA0VSxfKs9tzmphwx9J2SqRQj6RGy3Ha1jLTJF33Xh2jeR9E4LwfY8Dd7zQzQiAYsVlxVkEy6f/l4vDYjfYhJhumNoiP0XDTSciYqsSmX3jkgl0rCxARS/Si6wdsOlklk/CKFlMDrxZc+Nwi4kAXJavofOA7gY7BtR2u2quwUsX8xv+FGlGT/xON8XzfMhXe8Hqy9gqx6qDGklE1e08Tlsy9DxXD4T3ecPuV5lbAR0OPBRmRtH0IxxJrSo6Db5rGtrjCAYgckfsUoumcN2jBpd+pSf0tobsUZ+mxX4YTpKE/swO5AGnIvP7GbmmHB/FZGio1Jat9d89SWi9iVsrjd8d1DDL17T4rwSVABKl+1DfT1KjEvPzJto3yNRrwP17zLzU3eym5QtmHq12ULZoLHSInI7hlhIBA4J4ruXPyRLBecUu/7DauuLp3U5zEoEWUQxS+65cG35meK7sAovMJAm+TKVl6gumnkEwzE+SamOt9xeUcEvCib9eVZ9l8ZmYRr8dtEr2F3gQjxin94Ag6NW2QCTVv25qcRxHXaQOzzHT
 Bc4vo4Di
 D1VaSjCWrdmNTFG3y2PNcZDUHSMAfG9VSeCnh9J7YmqcdS3LSSPpPUk5iyRf4NAO/a6tGnaENOUxW19DtdwejcDUqIVk7LVbEZechWCclFBM+OjUmcRa73TfMa85vVv+b1YrkhtLK91WMi8mY2kTQZkOXdLT+0VN2aw0X12+DDHi1UQqYp9j0eRffgW1wfMDAaHz4/h9qac5Oq6VDiWzBEyrDu+rzKEzGvwgGnlSWxtgNB8qcxHF95xhQ4grce1k8UqGcOFtotf2vKLyPrfjHHfbWTYgxEYADn0gNOf22oA6EgMPvNwYEWAl7qPEpRJmKbUph6k+EiExQuPMCXYVJWewgiV/NiPLCqw7plJf7DUIAWxp7f+w4OaqYyM4b7eNNrfNDuDttCknbJ7ZgH/578T+ahQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Changes in v5:
- Keep the PIO helper fix local to RISC-V: drop the generic
  HAS_IOPORT_MAP dependency change and the generic ioport_map() change
  from v4.
- Add the missing linux/bits.h include for GENMASK and BITS_PER_BYTE.
- Fix the 8/16-bit LR/SC fallback to mask subword results before writing
  them back.
- Use early-clobber constraints in the 8/16-bit add_return LR/SC fallback.
- Fix this_cpu_and_4/8 to pass the intended operand to RISC-V amoand.
- Initialize the secondary idle task pcpu_offset before starting the CPU.

Yunhui Cui (3):
  riscv: io: avoid null-pointer arithmetic in PIO helpers
  riscv: introduce percpu.h into include/asm
  riscv: store percpu offset into thread_info

 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/io.h          |  26 ++-
 arch/riscv/include/asm/percpu.h      | 287 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   8 +
 arch/riscv/include/asm/thread_info.h |   3 +-
 arch/riscv/kernel/asm-offsets.c      |   1 +
 arch/riscv/kernel/smpboot.c          |   8 +
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 8 files changed, 326 insertions(+), 22 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

-- 
2.39.5


