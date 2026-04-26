Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8CAA8FF8850
	for <linux-mm@archiver.kernel.org>; Sun, 26 Apr 2026 06:27:26 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B7FD16B0088; Sun, 26 Apr 2026 02:27:25 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B30746B008A; Sun, 26 Apr 2026 02:27:25 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A1F086B008C; Sun, 26 Apr 2026 02:27:25 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 8E8CF6B0088
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 02:27:25 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01b-stub [10.200.18.250])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 3B5441B7849
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:25 +0000 (UTC)
X-FDA: 84699725250.16.A14F160
Received: from mail-dl1-f73.google.com (mail-dl1-f73.google.com [74.125.82.73])
	by imf02.hostedemail.com (Postfix) with ESMTP id 794B580004
	for <linux-mm@kvack.org>; Sun, 26 Apr 2026 06:27:23 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ci2Yqcgm;
	spf=pass (imf02.hostedemail.com: domain of 3SbDtaQYKCLYoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3SbDtaQYKCLYoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777184843;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=x3geMF9pl2AS94E2sOaM47L9pSj3O9H8NiYQAnGXwdc=;
	b=nlJ/SSdfNh+IOQgAERDDDpugPOAZZkPj3AYJUYjOjbEWBFShzHbsAtfVCm2qJjfCsOvkY3
	HiojmE3B4C40rnUrUNJ0BFnBeh+8bAT/iUY8Qy3v8o7q1CdHqyQlbkna954YnUJzbMRs1x
	3Cm0lYuZT0SL0T8tF6DsGMkpWaAgbOs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777184843; a=rsa-sha256;
	cv=none;
	b=nyNoeg+U1aVrE6w2o5l8jeBjP4cenh7zP9DjnpC8rqgMKOcvJDJW+jkVIu+YvBzVkcf1OA
	kTJSnO4sTvVuitIS4OMuclDFQjGsh33QKFS5L1MDsoFRScwDmG9PEIm3OLqhOWLBx1IAB1
	7mGWvMlO8HNfUr/F5os1yY0oFyYSsnU=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=google.com header.s=20251104 header.b=ci2Yqcgm;
	spf=pass (imf02.hostedemail.com: domain of 3SbDtaQYKCLYoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com designates 74.125.82.73 as permitted sender) smtp.mailfrom=3SbDtaQYKCLYoqnajXckkcha.Ykihejqt-iigrWYg.knc@flex--surenb.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
Received: by mail-dl1-f73.google.com with SMTP id a92af1059eb24-12c87ba0890so31290613c88.0
        for <linux-mm@kvack.org>; Sat, 25 Apr 2026 23:27:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777184842; x=1777789642; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=x3geMF9pl2AS94E2sOaM47L9pSj3O9H8NiYQAnGXwdc=;
        b=ci2YqcgmS7g/5iMLM19Z0a24VEUHJ3tbGj1/KHpOwVpM3aCzuahsMpCXN9DyIOJvN7
         NgRfymENIQ8UbzSwNnVuG8iVm688usJu2fn/a5pV/dEParuk9t43specbAAC9KPMHfsW
         2nY2Y4mFKRM0VBvR1LUomATzg7Mx9APyO+todUkrFkQ8JWacDTyCcQBm4s5n2O0yfQw9
         m0XKM4XMm1TS89kqrMUZ34q4tHZizb4Y0aRJ4PihciOf0adZRc/msu5/XTcHUAmyNdqB
         yv/ho8Y/y/ROqafoJU3WSYnbDbcV+Ki6J3vfjUiVyseBfXahHE1y3XpQ5gyq5A7d8AMy
         h7Jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777184842; x=1777789642;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=x3geMF9pl2AS94E2sOaM47L9pSj3O9H8NiYQAnGXwdc=;
        b=e3FWpZpf7NsH3J0XUndlOBZWMrD6Qu7UOikW9s21cSEiph6EkSu1yw/+V9JlhSNy1I
         D9JAoG2EkCJDdmksH5u8TNe8Qp4d/lbYUTljffWmJV7LoMcdjSbJ+j8/gGY5zEW230bj
         zlgdgvfieabv8iioRl+ruQTPW3n1CZEXe/OjxVRAuhC3X7G/3vf6xddpBnylO9afr16I
         Dw9AYvhdM29mKFow5pPnrtFXrQtV5GvraGEz9Kb8Nafa6ijfNjxjrnyStG/o2G7Hr/zH
         Dh23kjQo6wjgZHLREMuvBZ1FFKceT4uWAD+XAsyq5mclPAYqhYle6uBwhuAzqxc6vLiK
         vJKg==
X-Forwarded-Encrypted: i=1; AFNElJ/kNWzBDgxT1svQJht7ZhUmtaET5hYOrgZVxwJheJWGAuG+TtN8bHFxtJ2Bqg4/e9TdnozuitTcwg==@kvack.org
X-Gm-Message-State: AOJu0YzNvdZmusePDggE3F29NCj4K9Zz3tO2uTGQHVhN6BSBECHRw7WI
	OLt85IhmNaVw4NYkM3rp9b6WF6MrjIf9ATaRaGmOWxcXY8UrrQW7yz1LJZHSgsg6Y2FTOpdV9T/
	//IGK6A==
X-Received: from dlbur21-n2.prod.google.com ([2002:a05:7022:ea55:20b0:12d:c516:f51])
 (user=surenb job=prod-delivery.src-stubby-dispatcher) by 2002:a05:7022:11c:b0:12b:ec67:3523
 with SMTP id a92af1059eb24-12c73f726eamr19447643c88.9.1777184841793; Sat, 25
 Apr 2026 23:27:21 -0700 (PDT)
Date: Sat, 25 Apr 2026 23:27:15 -0700
Mime-Version: 1.0
X-Mailer: git-send-email 2.54.0.545.g6539524ca2-goog
Message-ID: <20260426062718.1238437-1-surenb@google.com>
Subject: [PATCH v2 0/3] use vma locks for proc/pid/{smaps|numa_maps} reads
From: Suren Baghdasaryan <surenb@google.com>
To: akpm@linux-foundation.org
Cc: liam@infradead.org, ljs@kernel.org, vbabka@kernel.org, david@redhat.com, 
	willy@infradead.org, jannh@google.com, paulmck@kernel.org, pfalcato@suse.de, 
	shuah@kernel.org, hsukrut3@gmail.com, richard.weiyang@gmail.com, 
	reddybalavignesh9979@gmail.com, linux-mm@kvack.org, 
	linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kselftest@vger.kernel.org, surenb@google.com
Content-Type: text/plain; charset="UTF-8"
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 794B580004
X-Rspam-User: 
X-Stat-Signature: pgtifibr7k8segfiqj3g9yisxi77gpoq
X-HE-Tag: 1777184843-120043
X-HE-Meta: U2FsdGVkX1/qdRpzKmwM1T2ugbTlGh3naOMhPPVUuar7oQ/1+rlqdwPve+YqWlW1hJARqh99OOUTvtv2DUqgILrG+mXJMrvGmCD7UV5zV5h+4O7FPKpl3dB/sg+3JAzwOyssgDu1c7dmRikaESIKs2pJIyF3Vvr0OUIo5GSlNlJU80vSBojGLtrVLY+H1aqueMxnkIhml0tH0WREZvWZ7+Izo4eXyVbMh5yRCy1X5Mkj0nQq/eJjvimnhikZEUs5W9P6lczaWNDYaAPabeBuQvUHqMmeCT6HEqeGRv9S43pNBxxlX3Gbbvt82vbtFrOA5Pec6IuRMb3k/cLVQO34AZSd/Q4CB8JVahSoQ4/9v4339K7YDQc/gMYJ3uQ98qeoCmQNN2woPjYbOCoKxXhs3RyWjNTlpXC83ACrLJgRuWzcuXfzAXJTSPT/uOL6Qrx+dtUdcYsXNDbC5zbpumLijJPrqvdVBA4ErEShby0ZJr2DFm0DR8fUiYO8+/qdhhhOwdJatDsq9eBD1+npnvu8YtAGXrnSJFCUqP5kH4Mdga+U357KI73eOq2TlKo1eGW3VeuGoToa5DAhMK6ukUtmLUoOfzqocxtUyzjjmQXO95McbcgZ8yVDKgs+dXqtpw/fHOqay5sBN5eh6TqerjHbDeyf9WWtJIV9uMiQ8TEdW4NKpRip3pFVuR0O3FP6NmKPpRQgM78dlnC0SnPWRUxndeoyg7Jq1V37ZwVZ1Qz//5KeTEeOmwvECaPh3mxoKwmNxlhpPxng3v5hBst82H7c36qUGdsx3k8LZD8zxpKPqmj1vwiAyckBNjWQ2PwIm2Rzi4MFAcuo4D4S/ebviVWDs3RYMn9QJPcuqdz0LNercgQHXBK/b8dkkw/s5GIJSUhzM6eFuJRGNJFEYQ9wY15xTRcVkWd1Eaxd1W+/aMxUaQC4a7tdhR7s8C6JuVPvp8W+wXqkUn3iJwqHwB4nyKW
 fFvZQtpf
 AxyVdJ1l6S5Ql2bsJE23oSdrfhzK970lu6GyNs9FbnN8iX5I+s+W41nkJsKR809WTH/DtEuVVJ/ABS26A8GKQvGXWz8se75MkQRL99KXBASbXsPQcoTl9bDEJgii3NBH6VHmkhXLtSkkcaAGn+u+Amek8vWQv2Ku4JeqqIUW9u8e+n6EFaLJmu4Q+rCYAAazhgmQfrMxLGX4xaZOy/PpCFAgly5U4hvJUYQqndybtMGSeiPO2YYdmo7rqYYaiwlxoFsA5lTBLj+U/wK/FAyh1u3sgwCX1TN9YKua4SMsvTVjbUhgsDc3wlgVYWicB/MFDTpDiF8RxCy8gVgYqW0ph8VQ0Z/HBlLYKgO/UOYEs0ImA8cHLnR+NlpHL69ypmAwfG1jdjMe0Si5RDWzeKTsERie7jKKP1N5nrLPHLnQ18wUx7CoAvot0ZdI0RDLvTiH16kEXd86090Oe6knOTM2vryWGN7+zKpLurVcZTfaF3/wgIe9UdiD9k2GdSPZ8l3RM5t1YdeOHEPDqM2iGFxmuq2S/oh8AAifaqOJe+/2iDMcNm86EYpcObZACajzOp5cp4QDPzcSV32/0mBGsdp4KI7VC9vyhbKo/Kh7bn26VycarriB0LKsKNzL4aimzjO6XindCZ92Q35YsAfoUySEmcoAgvJrIWTATwLXlOYbEquZ7ly2YTRWVgbSrPiX8pl0D3YsGyUOMl5kFl+VC67CR18Xj9sn0Epy/ai61jLxKb6xdlkDofEof5NohuxGGQGacDTPKl+oZ5y1o3xU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use per-vma locks when reading /proc/pid/smaps and /proc/pid/numa_maps
similar to /proc/pid/maps to reduce contention on central mmap_lock. One
major difference between maps and smaps/numa_maps reading is that the
latter executes page table walk which can't be done under RCU due to a
possibility of sleeping. Therefore we drop RCU read lock before this walk
while keeping the VMA locked. After the walk we retake RCU read lock,
reset VMA iterator and proceed with the next VMA.

The last two patches extend /proc/pid/maps test to cover /proc/pid/smaps
reading during concurrent address space modification.

Changes since v1[1]
- moved drop_rcu earlied in smap_gather_stats to avoid sleeping under
RCU lock in shmem_swap_usage(), per Sashiko
- skip page walks for gate VMA in show_numa_map(), per Sashiko
- introduced parse_vma_line() and copy_line() helper functions to ensure
input string passed to sscanf() is always NUL-terminated, per Sashiko
- used FIXTURE_VARIANT to run both maps and smaps tests in a single
test run, per Liam R. Howlett

Applies over mm-unstable.

[1] https://lore.kernel.org/all/20260424070234.190145-1-surenb@google.com/

Suren Baghdasaryan (3):
  fs/proc/task_mmu: read proc/pid/{smaps|numa_maps} under per-vma lock
  selftests/proc: ensure the test is performed at the right page
    boundary
  selftests/proc: add /proc/pid/smaps tearing tests

 fs/proc/task_mmu.c                            | 195 +++++++++---
 tools/testing/selftests/proc/proc-maps-race.c | 293 ++++++++++++++----
 2 files changed, 387 insertions(+), 101 deletions(-)


base-commit: 761e9fad336afb6fe2cd488c7bd522e2783064fc
-- 
2.54.0.545.g6539524ca2-goog


