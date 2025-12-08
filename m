Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 50622CEBF88
	for <linux-mm@archiver.kernel.org>; Mon,  8 Dec 2025 03:50:13 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 52DF86B0005; Sun,  7 Dec 2025 22:50:12 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4DF4D6B0007; Sun,  7 Dec 2025 22:50:12 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3CD396B0008; Sun,  7 Dec 2025 22:50:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 29AA76B0005
	for <linux-mm@kvack.org>; Sun,  7 Dec 2025 22:50:12 -0500 (EST)
Received: from smtpin01.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id C454EC0985
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:11 +0000 (UTC)
X-FDA: 84194925822.01.46B8077
Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	by imf15.hostedemail.com (Postfix) with ESMTP id 16234A0006
	for <linux-mm@kvack.org>; Mon,  8 Dec 2025 03:50:08 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z1snep9X;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765165810;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=Mty2zn4dwIlfoS/rTSTz6mOhmsuS4SWDSU08vOSH3ts=;
	b=kiVpq/K4fmtA9KOhdZIoQeUS1hjjBeW8DW84BzgA2WTfgGftDqUhmuvg+RcvLj8LqpUBds
	mlcMhi2WEPL4TTuxaN6X7brBD+BgIIEvInFkIkP2/syzE4+8I6XiG14ro2VTKe9EWn+1Es
	psPJa6jJBdPcdkvI3LPFpTJropDNpeg=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Z1snep9X;
	dmarc=pass (policy=quarantine) header.from=bytedance.com;
	spf=pass (imf15.hostedemail.com: domain of cuiyunhui@bytedance.com designates 209.85.214.172 as permitted sender) smtp.mailfrom=cuiyunhui@bytedance.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765165810; a=rsa-sha256;
	cv=none;
	b=8koMSRXXuzob9TEoyE232ft/DQoCaTxpHev0L2g6jHAdJn/Ir/K6ZD8nx2v26aqocQdX4N
	vpx/q0UFAtDP/IJ+wHIj34zRhmj+gOJMwWSbiw/FYeakPgyU9SFuJzX96f6v9KH7ppCjBX
	E79t7GIyxqQCZ86y3PcyyrM+/8rckyY=
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-29812589890so56023715ad.3
        for <linux-mm@kvack.org>; Sun, 07 Dec 2025 19:50:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1765165807; x=1765770607; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=Mty2zn4dwIlfoS/rTSTz6mOhmsuS4SWDSU08vOSH3ts=;
        b=Z1snep9XVNKGXFLqKpEyMQvo/j7N68Fbq8zfFqFOIViSh0747aERGZxYbcvTTsli7K
         JUK2h8lh/mgMDDDGn5+iuvj/Gh9cgi3jBTGHyY7PC52vvI77cvqWbpwhTCO0PA1z1dv5
         6FLgrzbpNo/iWp5p5At64/g8gabK2GE1RnRTwc3lr+01evrNYbfTVMHF1ULQqJhtjSKb
         WE+Yk4a2Q8CZ0dpJb1gShqyNKUzCW3/PjX49c9wTURmuFTdNdJQgdoFML5E/1ArKqZgY
         06xA8WoUNL0076FwUSQznx/iX7SifH04gNqlG4cFKcBYn7eacF/OfAdX7GL501F+MZ4E
         WEgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765165807; x=1765770607;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Mty2zn4dwIlfoS/rTSTz6mOhmsuS4SWDSU08vOSH3ts=;
        b=VX4Xi7unz+SMQpGABYnv1U8rhZgI3IykCtyAkJCP5rWocqX33h1krPnbIguceRtqAW
         O3HZv9kJ+/ArgEmz6WVyeZfUEFoQwqyRMiufvC1P3lKEzruIW+sgaNBWRpSTDLYM9k1o
         undFkDe9ROAnojKNrjpbj9+MqISopBBb6lFtOvRRZxLEZEKK47AgaVhGAw61RdKAgQlb
         HBSnx5JS8SKyHFTg5muFU5ue9NHrakdOz7JgE+P1JwXlycdIBVhX119hE0oLLSb6GWPw
         80F08fswgrCYVFM5PdP3Hw/+vzMsdq/UCsuKpjzpjACmFiDOqqZdSwBNTR7T8UY32mRF
         d7Yw==
X-Forwarded-Encrypted: i=1; AJvYcCUWEOYt6oB4At08E0uL/y3gjLNfp6iuNuIDYZvZv0gMPDfYd3qULfA7CPPXCiQfK4z78LbEC+zLxw==@kvack.org
X-Gm-Message-State: AOJu0YwVWZV8fiXbO6XHfGJxJZrkf5iuU6Y2c2iNC66fypjJwOlFQJCF
	WBehWRzjYNwDvLYc0DJcxyJfvsRCtY0Tr3JycYliCNXxRGoIPKUyWXjSJoqKFI9fSJg=
X-Gm-Gg: ASbGncvcWt8HHB05TBhPftg6Lq01XK11TUobiV7NYY7KwqSa6TZmwnM0JEFml9eKDTc
	vqhzIVQ8B7cBVRo5L1tBQROSVqoht6dPRNVIx6bQpJuX6KOGHrIU1nn6uqKT1h7sNvg+29QH0Xr
	8ugwnHioL+lHwIso1/ESNSRlvexavSbEMIfYWF/wttNxNM7akHmGmp6RPN/E8oVsTfH/82w03Mk
	GMvcaPrDkar8uMKi36WxHjCCcfVt6BwE2XaL54S8eTFzoyUYdx9mFYltBQETeb+zGLtDo7tCy/T
	6q3tS9yFmZfIt2k96Nq0s5Xm4F1cvlxF6gl29mufoaZQyOzGFJvwSpno+7R6KOQO1MwEIxyzAm5
	3UzbH6P6505HWC07kcbAbJuvE2R+zjtAetZLDrG2OXZg+fZ2ChSr4Ia+dBzn52nsilw+4yO2X4p
	VoGr+tjmJscwilQst5nCWzZmje177sBXWh12WhtJs+vYEZ
X-Google-Smtp-Source: AGHT+IFUgzn7oN/GX+yC51QRUlb1+YHbrj6+uDfWoUdYP/BClYG3/VlS/j6Bvy5yLNw6/cq82JDAwg==
X-Received: by 2002:a17:903:1a30:b0:295:20b8:e104 with SMTP id d9443c01a7336-29df5ddd373mr63685045ad.58.1765165807515;
        Sun, 07 Dec 2025 19:50:07 -0800 (PST)
Received: from L6YN4KR4K9.bytedance.net ([139.177.225.240])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-29daeae6d96sm108871275ad.102.2025.12.07.19.49.53
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Sun, 07 Dec 2025 19:50:07 -0800 (PST)
From: Yunhui Cui <cuiyunhui@bytedance.com>
To: aou@eecs.berkeley.edu,
	alex@ghiti.fr,
	andii@kernel.org,
	andybnac@gmail.com,
	apatel@ventanamicro.com,
	ast@kernel.org,
	ben.dooks@codethink.co.uk,
	bjorn@kernel.org,
	bpf@vger.kernel.org,
	charlie@rivosinc.com,
	cl@gentwo.org,
	conor.dooley@microchip.com,
	cuiyunhui@bytedance.com,
	cyrilbur@tenstorrent.com,
	daniel@iogearbox.net,
	debug@rivosinc.com,
	dennis@kernel.org,
	eddyz87@gmail.com,
	haoluo@google.com,
	john.fastabend@gmail.com,
	jolsa@kernel.org,
	kpsingh@kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-riscv@lists.infradead.org,
	linux@rasmusvillemoes.dk,
	martin.lau@linux.dev,
	palmer@dabbelt.com,
	pjw@kernel.org,
	puranjay@kernel.org,
	pulehui@huawei.com,
	ruanjinjie@huawei.com,
	rkrcmar@ventanamicro.com,
	samuel.holland@sifive.com,
	sdf@fomichev.me,
	song@kernel.org,
	tglx@linutronix.de,
	tj@kernel.org,
	thuth@redhat.com,
	yonghong.song@linux.dev,
	yury.norov@gmail.com,
	zong.li@sifive.com
Subject: [PATCH v2 0/3] RISC-V: add percpu.h to include/asm
Date: Mon,  8 Dec 2025 11:49:41 +0800
Message-Id: <20251208034944.73113-1-cuiyunhui@bytedance.com>
X-Mailer: git-send-email 2.39.2 (Apple Git-143)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Stat-Signature: jzcji7s1qjjtex5wk5rkeduzq1mudneo
X-Rspamd-Queue-Id: 16234A0006
X-Rspamd-Server: rspam06
X-HE-Tag: 1765165808-231542
X-HE-Meta: U2FsdGVkX1/ZZGUPWI58M+wnnChlQk9kiUg9a4fxgh2HjEd525Ikl06iNvNosur2OXgbBhP3tGun0vYFhyUmgEnXb0XccaO5P9XF0FXNKBB6GPTaNpcKF8mpmRuYRpJuOhbW3gMXwq+EEuyW2DVQZXtV/j/hrXWO5dmYPQQ8HG/VRCdbmI/I8RUiMEYOKidwfx4AbFkXD4tIBZiUho8NL7XI7LBeR/2ArenNRZ9Kk5vt/4JVvSN22f7y6WwvdTkjbK+sa4sd/EvOCTba3Nl8eMLjBpyv/Sj1whlHlM3E+DGX9Ta7sX1PxqG8SeRpDdpKabxHHhJTnler4FivHtky+WL3560Mp4Ia1s746jcVs3lX3BG4qcFyhIA6+EiHxaFgfH/u6zdjerxzo6XGDnjvdUloA5//n5AL0xC/H6bNSuJedT8ESPhYNP4Z5infbrR986dU/2hsC4Fs0t+KfXGoUFTxLXtaXx9UuzYXNoo0CalbFmqgSVcoLrwj7oxrlF/i9MuCumizs9Lc/IDsd7/8xFAJCIKsYHkJ7Kbs54jgdOdUA69FR+0EJUjI2Gh/OjfMmbeFxP78oOhelf/UYgkD3rdY+50uBli98m51goH9q2R/Gcv0bpO9qxhkMABMlioL3sanFlwv6lJKopnqUiPNiZesoKsfHIuS8WLw/+pQnZLUM+0HzAFRQiXWtxt9munksqCyCLyqaP/xNAdsFH8BBVtw+cAPcAsIyAOw3pd/f+7USQHu92pZapj774/js30Hyw4vZT8HAm/5vLhsmMksKI7JXe5ufv86e7t23u3pAlSmqX8y+PgFdAS26G6Fbo64U5i+m8NMGa8VScBopJgaBZhGOrgsZ9cNCVlph8nOlJOLwZXsuxACQpM9VkyBHXfD/alLIJkEOezqnEfJmsU/lzKW12gBq/OisxvpUIg26d9Rrw+MW4YVhBST2eKag7KV7i1LUBr6ig3op8vGK/C
 g0HJ1iRS
 yiV3jfFvXotSimRx8/Wi3gs4d+yYZjSs3mZdDtQeFwMFkt5CLTFppnS4+W4dN0I+GBwVgj3dhMk7Pl5OlU86eVzU6EvLU8wsBc7sWOb2pAIZjDWTJdDh1aicQRACZmVoXqBmdVt5U1pP+G6Ghe/7+yW0OtDcLDxQsX6axKTbcI+XipOrufKY1pj9qE3orAZCPLD9dmyZl6zC7cSDzqFrJsJwVvfEOia4Ryi1BkECPxSRNxtZ5EdP6XMdN252Tp4ZpfINwpyp9D4iy+q0ReVZWw1I9b+45okZUuWe7vgOwfDRqUtQsQtifQUhSDicQRl+wD18b
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

v1->v2:
1. Support percpu add/and/or operations for non-ZABHA
2. Implement optimization: store percpu offset in thread_info

Yunhui Cui (3):
  riscv: remove irqflags.h inclusion in asm/bitops.h
  riscv: introduce percpu.h into include/asm
  riscv: store percpu offset into thread_info

 arch/riscv/include/asm/asm.h         |   6 +-
 arch/riscv/include/asm/bitops.h      |   1 -
 arch/riscv/include/asm/percpu.h      | 242 +++++++++++++++++++++++++++
 arch/riscv/include/asm/switch_to.h   |   8 +
 arch/riscv/include/asm/thread_info.h |   5 +-
 arch/riscv/kernel/asm-offsets.c      |   1 +
 arch/riscv/kernel/smpboot.c          |   7 +
 arch/riscv/net/bpf_jit_comp64.c      |   9 +-
 8 files changed, 263 insertions(+), 16 deletions(-)
 create mode 100644 arch/riscv/include/asm/percpu.h

-- 
2.39.5


