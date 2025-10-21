Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 18A66CCD19F
	for <linux-mm@archiver.kernel.org>; Tue, 21 Oct 2025 00:09:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id DDFB98E0006; Mon, 20 Oct 2025 20:08:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DB7A08E0002; Mon, 20 Oct 2025 20:08:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CCCFB8E0006; Mon, 20 Oct 2025 20:08:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id BBEEB8E0002
	for <linux-mm@kvack.org>; Mon, 20 Oct 2025 20:08:59 -0400 (EDT)
Received: from smtpin25.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7A1C2119A6D
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:08:59 +0000 (UTC)
X-FDA: 84020185998.25.3761009
Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	by imf22.hostedemail.com (Postfix) with ESMTP id AD103C0006
	for <linux-mm@kvack.org>; Tue, 21 Oct 2025 00:08:57 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HP8nUGAr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761005337;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:mime-version:mime-version:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=fMeUvazcqYNdgA2hGT8nnzdOzY6TaJPwIdfsW5qe5JI=;
	b=zJZ2iIOxvrNJbYVDbG1Q4DlFmzTndALbkFDO0lrM3g4ELiXfUqK7wtfAssqWguC3BXcGyE
	eXJ7zJiWK3ro7kS9yQ+O/MkptC9SHF/fh/6sCKv8Ui5utVHE2dkClUi7GT3wiFCXRgODqr
	SEVF+m4iA2ukHGacJ5f7jpm5IQLaRjc=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761005337; a=rsa-sha256;
	cv=none;
	b=Bl+hC7HB1aCLbKP5Yokir9XJtcaCeEB4Ee5mgUyNnlOexZuQlK3/X4Ld5MpIXppk9wjD2U
	iqiMOEZsyVqmwqU7XaePze6R39xIR5XA1Mk01Hz4mkGwV1ZLpaZESiFyvD+ctV6iqeIeK0
	lsb9ymiME5K9MYpl85oeSxnhQymVsuc=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=soleen.com header.s=google header.b=HP8nUGAr;
	dmarc=pass (policy=reject) header.from=soleen.com;
	spf=pass (imf22.hostedemail.com: domain of pasha.tatashin@soleen.com designates 209.85.222.42 as permitted sender) smtp.mailfrom=pasha.tatashin@soleen.com
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-932bced8519so2465569241.1
        for <linux-mm@kvack.org>; Mon, 20 Oct 2025 17:08:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google; t=1761005336; x=1761610136; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:from:to:cc:subject:date:message-id:reply-to;
        bh=fMeUvazcqYNdgA2hGT8nnzdOzY6TaJPwIdfsW5qe5JI=;
        b=HP8nUGArSBnN4b3yH0d2JKxhjcOulLaaVWxu+lozk2KLC1KHbEUHdvIYAcjUsGNYVz
         mcYSaR96iYd0pHKiYbOsojDp54tMZ3aT1rCeiXd9S9yokDzlg/3ycnfyY53s0QieSd5/
         0gH7nfPsz55TlNRfOuHGepI5QeZVw7iW9Bbpp+5IvpkPcN2U76peYn84dqgu9s1n72O7
         TgKwgduVhQBuRvwwrfz/rEdDJoD1JD9l2aOs9XcluNVNidENpN2vDnHdTl7jisI5hUR4
         /HuDrSyVZUAoO4/Oc9szyXO5lvQpplv5tCfRP+IykmyD6mMQySL4J4uMSS7ogvzKQL16
         vWzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761005336; x=1761610136;
        h=content-transfer-encoding:mime-version:message-id:date:subject:to
         :from:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=fMeUvazcqYNdgA2hGT8nnzdOzY6TaJPwIdfsW5qe5JI=;
        b=VZodrylDK9PfcJYi5NOi3mEtBLfLmsIcm+2wjRMkre2TjpS9ZKgEABLkGBDxEYUnZM
         u7e+dCv3HUshBdRUUBBx/stIdPXkzAj0xmWqXaZQsgW5P2Iguy84p5A7ppt1sQXxWKHi
         4NV5MxWPsYcvywH28E77ofWPlEck080meAM6XZQeR9hlL2gbhTl673A0X+YlwbwDQaXA
         JDWOHau25BWoloubF4CwDeL3aXKIBBEr5MDKlWbQKQBV5otgvoJ80SQeDQnKxeI3pbjf
         Y0BL3SpMbHstKLwY90WI7eRXnJbYPF2osMnTIjl2UYknCuE4Z+GysUwoTU4GGzDlqQMe
         HzZg==
X-Forwarded-Encrypted: i=1; AJvYcCX3Y5+v3mhK+Vm/QZmyTtobT+6q6LEO4nEKK4M9TncXsfLeXrc47/oEhWEBXT4oLDVfcWI7/WMZ2A==@kvack.org
X-Gm-Message-State: AOJu0Yy/eA6a32GzSFEF9247yLwW1Wc8JhXb9VZeaMIMgJKy3ZBMsQBl
	/mFxtQG4cw6psRAjktDVu6tHcbONpP25Ihj/7r3ExFfgqD9a03IxbZyotU+Ru0IRYdg=
X-Gm-Gg: ASbGncvPv0iOHXHo1r4SSiqi0jIG/i9mZw/cwnrhyQgjB1LOHNW9uK6lUTe6l5kKF3j
	KuxIyIEE+3jjBBsiOEcmxYCmX5GgycBtxQRJL1ZHZPQ2+OJefmLSIs9L9QxQedx/yNs6aZSHdGx
	EmlNTQjHRN7efx++PFY96IxxVMVdA8rlCjS2stgISr9sl644QYXpIKEFQA14sc9ThzGXoz9s7jd
	B4G9+WgsVlPdFXkm09LjVxDxTwtIH3RT1cmV0Al2KDAQuqqlB4ds5vRdcqMIu8GRsKYqsCvyEZw
	v0+PRF5AqkwXqHDgI2XpOFBTECkk22hXBup7NTrMGXRrn3ry7FvwRquFe8WE5uwsnMPfyX4terp
	7AEWqXN3iG93Mn7RHNAUids4+7OoYbDf3Hesjs5onfeSqnyibAJ4x9fVqthllEbxYdtdPvIJrlm
	PeAYOHxxUhFumKn2CuhOSyoXdnJPUfpo9EJPirEPzxn76NcE+4JhYe48nzK0apSPOA2Vc4WIbeF
	t0HelUrx13+kFCCdSdfgevctm36oSXg
X-Google-Smtp-Source: AGHT+IHQnFwZNsQY3u2ASdTone7Vpn+Mv12WF26BhqGJWj8KVskl7uPN3iDlEwuykCnl85OEi5PdLw==
X-Received: by 2002:a05:6102:94f:b0:5a4:69bc:a9e with SMTP id ada2fe7eead31-5d7dd5b8b89mr5352453137.22.1761005336583;
        Mon, 20 Oct 2025 17:08:56 -0700 (PDT)
Received: from soleen.us-east4-b.c.cloudtop-prod-us-east.internal (53.47.86.34.bc.googleusercontent.com. [34.86.47.53])
        by smtp.gmail.com with ESMTPSA id 71dfb90a1353d-55661f6e351sm2822882e0c.4.2025.10.20.17.08.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Oct 2025 17:08:55 -0700 (PDT)
From: Pasha Tatashin <pasha.tatashin@soleen.com>
To: akpm@linux-foundation.org,
	brauner@kernel.org,
	corbet@lwn.net,
	graf@amazon.com,
	jgg@ziepe.ca,
	linux-kernel@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	linux-mm@kvack.org,
	masahiroy@kernel.org,
	ojeda@kernel.org,
	pasha.tatashin@soleen.com,
	pratyush@kernel.org,
	rdunlap@infradead.org,
	rppt@kernel.org,
	tj@kernel.org,
	jasonmiu@google.com,
	dmatlack@google.com,
	skhawaja@google.com
Subject: [PATCH v3 0/3] KHO: kfence + KHO memory corruption fix
Date: Mon, 20 Oct 2025 20:08:49 -0400
Message-ID: <20251021000852.2924827-1-pasha.tatashin@soleen.com>
X-Mailer: git-send-email 2.51.0.869.ge66316f041-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: AD103C0006
X-Rspamd-Server: rspam02
X-Stat-Signature: bctk8pydr39kpqgt3ns1xiwsfk3i9ucj
X-HE-Tag: 1761005337-648718
X-HE-Meta: U2FsdGVkX1+ro1q4j5xbgeRUWzJ/ZOWUNilT6qLefPr4oLdYGiAxjHjucKuc8xJUsmRrzSCFyBJuj2YogUL4vDbRlPL6OORx1hoUosIDB/OlQR6D9dkqyMqAtRbHpvyrfiGQvwXokpW9Nxa1SIdOjnigqcTZyx/Knxct/HVPJgbthHZWEIjYjLcmRCAswuUU4VvZ4t8HIC+ppYuPclmR2xkoBEPAZihm5GUliWzoqdcM8U28NDc8xtLdgYi09nfLj+sFTViQOR37+iBil6OAxfqcgoxgRqLN6ONzgCH0Ty2JZXx1RTJWqhOrMFzLdIkRqBOyXpSjkjOxc9jsvmBUjBBRAVL7duLn7B927DN2ykMiFIST4d33rSN5oFsSJbGXM7+d5oyLxEmwlGFWHpIi9GQbEVdiZsoO6eQRz+E2D90r5/7/AVqrf5CxVQS1WXvJGpNZ2MPXoBJXCNmozamW+6zbfFCFrmXo+Fo5xkC/KHFwPrdkL+Izio9VTJLXUMus/FEN3uBOtig8ijtalCud7zZiGazA1gH1iKM/M62LNyHmI5AFDPhv5tHvszwSYNJZ4Nl/ayKjmr5YeSaxAk4uxskIxkf+uvvaRqruXmbIELsxqWUCqZFQHzfCKszbrrbcWt8+XNVZQX1ZSjHVRwCo9NN5rK+ocIMde3PkN5o6PJXHDuPWDR+sTeJtCTlepbxAzb0iKluhWzCatUkq+zAM8bukx6pj+Aa7eHHdITaMHOeomKOScKy5dKTkHp1uYTZQ4NQ1jVKXIw4e44ymhCm+rORPTvKSmVEc/2/qQsnbJi0oZFrWKEU+9ZcV7Tt9JWvVoH8Tk90GTqzIhm2Er1S+OHfQZXFNqKgX2FrAmGRATrhtSfqlUncxu9p4NTHGRGD9lkKzIXDx2XcFaZkqvUrVevrITi6Ag5d5sUsg6mrDpQDt38m7LQX32e2ZpD2OuuBmMt6VQBU+OU8Wqpkh274
 cY3mZ5hd
 Si2ItB8CWkAC1NmsSbRpOVMv1Yoc5/OG/zTRCrOQxUbOB5DOf59b+4GFY/X7WC7x2Zj2ObgJvwIq+qdjD9Z/hs/7e2ADZ9HQbjjPsDlydhRK3nZ1BfqGGgI5cfUCs/vcFtKqZ2ALYW8kQs0CfuB3NMXFWr6Au1xn9n0T73mtUqe8ziSsHOu4VnG6xusPm0QwttpfTtT9Z4tTK/aa1gTLcLB8Qm4SNQZ4/lgVzOjUC5XAmEPBiD//q1OF7QuKLx3NnCL2mJN/It3X1X3A=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

This series fixes a memory corruption bug in KHO that occurs when KFENCE
is enabled.

The root cause is that KHO metadata, allocated via kzalloc(), can be
randomly serviced by kfence_alloc(). When a kernel boots via KHO, the
early memblock allocator is restricted to a "scratch area". This forces
the KFENCE pool to be allocated within this scratch area, creating a
conflict. If KHO metadata is subsequently placed in this pool, it gets
corrupted during the next kexec operation.

Patch 1/3 introduces a debug-only feature (CONFIG_KEXEC_HANDOVER_DEBUG)
that adds checks to detect and fail any operation that attempts to place
KHO metadata or preserved memory within the scratch area. This serves as
a validation and diagnostic tool to confirm the problem without
affecting production builds.

Patch 2/3 Increases bitmap to PAGE_SIZE, so buddy allocator can be used.

Patch 3/3 Provides the fix by modifying KHO to allocate its metadata
directly from the buddy allocator instead of slab. This bypasses the
KFENCE interception entirely.

Pasha Tatashin (3):
  liveupdate: kho: warn and fail on metadata or preserved memory in
    scratch area
  liveupdate: kho: Increase metadata bitmap size to PAGE_SIZE
  liveupdate: kho: allocate metadata directly from the buddy allocator

 include/linux/gfp.h              |  3 ++
 kernel/Kconfig.kexec             |  9 ++++
 kernel/Makefile                  |  1 +
 kernel/kexec_handover.c          | 72 ++++++++++++++++++++------------
 kernel/kexec_handover_debug.c    | 25 +++++++++++
 kernel/kexec_handover_internal.h | 16 +++++++
 6 files changed, 100 insertions(+), 26 deletions(-)
 create mode 100644 kernel/kexec_handover_debug.c
 create mode 100644 kernel/kexec_handover_internal.h


base-commit: 6548d364a3e850326831799d7e3ea2d7bb97ba08
-- 
2.51.0.869.ge66316f041-goog


