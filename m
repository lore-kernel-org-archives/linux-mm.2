Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 585FACFC518
	for <linux-mm@archiver.kernel.org>; Sun, 23 Nov 2025 06:31:10 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 583CE6B00A1; Sun, 23 Nov 2025 01:31:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 533BE6B00A2; Sun, 23 Nov 2025 01:31:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 422266B00A3; Sun, 23 Nov 2025 01:31:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 2B8BF6B00A1
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 01:31:09 -0500 (EST)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A21745C25D
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:08 +0000 (UTC)
X-FDA: 84140899416.04.8EC66B4
Received: from mail-ej1-f50.google.com (mail-ej1-f50.google.com [209.85.218.50])
	by imf04.hostedemail.com (Postfix) with ESMTP id CAE9140012
	for <linux-mm@kvack.org>; Sun, 23 Nov 2025 06:31:06 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PmFnq3nE;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1763879467;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=zlnQWv1xCLYBTLtdCEO30f5cxKERrZdCiEwscZcR3Kw=;
	b=VXOUpP6A+U4eVsXL9/+EU2911BNY2Q0zXtSwZIoYdOWCnjoS3cg7RwMw0nV+oQVyJHsdjL
	8YbE3dJtYmzyEWK7CrmVuVGhousutXB8nToTUjT33U5B5HZka/KVAGIWZLqvrsJOJPNCMx
	Bk6KYwDJi8C3M5rxuFFQLTH8vE3SQgo=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=PmFnq3nE;
	spf=pass (imf04.hostedemail.com: domain of mjguzik@gmail.com designates 209.85.218.50 as permitted sender) smtp.mailfrom=mjguzik@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1763879467; a=rsa-sha256;
	cv=none;
	b=AWDBSb2MLvf0JtOJrUnE8u1NLoFNvbS9zKpAJZ4Lg2xo9vJkl+aihLfw9WKw4v5hedES5y
	HNcPvDAo2PD/XaZSarKb4oTOrR6QV4LBOHh/Ll+ql7q55VnfEYmPAAkUr/4kbpLdBlICrf
	G1GwHPHIr6vR15Rh3BP0ytOUJVYTjx0=
Received: by mail-ej1-f50.google.com with SMTP id a640c23a62f3a-b73161849e1so485471066b.2
        for <linux-mm@kvack.org>; Sat, 22 Nov 2025 22:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1763879465; x=1764484265; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=zlnQWv1xCLYBTLtdCEO30f5cxKERrZdCiEwscZcR3Kw=;
        b=PmFnq3nEUMMaaW4pxEUm4lhKktFbDIOqf9aSPjP7NgZ/vbkCIbvbCxWOinQrDQFrCM
         3bFx6W7KIgMMku5zbQw7zRYOuoIZvyjrG+TAH98Ue6GCD7Oeb4q+g3SePR7v+Az32lMc
         CVTA7WfhxoffPsUMYcql0kcV7H/+XXDyB1iZVHaz2sDe0a3YhTqJFS6Qrhk4vnTIdSbv
         bLvHaIbIvPtQzvkS3XVg7KXGIkI6obOM+o3b11CkAVYpQWUpwsa2szbSkAymoInWIV2g
         IBeZXCEQVshBID9vjAYwqcKlTQ+une0gUaMJ2ZrgYw3fv+csVHeEtd5eQOBrdoqc3BeZ
         Jikw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763879465; x=1764484265;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zlnQWv1xCLYBTLtdCEO30f5cxKERrZdCiEwscZcR3Kw=;
        b=nRXtp6LvMMHR5wW4Fq5sPYcSiscjzGHja+e6ZIb07UDcoqK1ufXQ+BKI58XObngWKw
         jNRPkD3dBORWhVKjHTl7dBGIhOQ1JdAJA6AcgKW5CfdaOA3zJWlunNbDvk4fjA7Ybyvd
         LwrJtWNvkzkVYYhAxaX2gnE8HxZZW8Tt2/AW2J7MuIQNJAsPf2mE7VDc1/RyBo18Bl4X
         rnD5Ej1odpwQyVNyHkbMiSx/JC4+38aEHyuXniQRhVEEuAA1Ndb0G+tR43UC0dhMLI/r
         dA+ZMFwtEcZ381hCLBdoMb+JLRn/kB1FkDICuit9duzzrh4HwygNZc8r7kCzUMCFzr2v
         a51w==
X-Forwarded-Encrypted: i=1; AJvYcCXIbfhQKgj/t5eishshWZJrBFpmMdLyel9mJYmZ4bSTnCnMue/hvKgteRs2MQWWWTswucNEESm/DQ==@kvack.org
X-Gm-Message-State: AOJu0YxzTkW2yNTFwusBMBBbHmp9kAeZdhad9xXcobiIvtXDyRHqcAca
	o4j1IcyUtp+6YUrdy2VPVZ/U6E8MUowTUQaghNCu34XydRvhiZZ0FeTZ
X-Gm-Gg: ASbGnctJ/n5aa/XuuNK/fYOJgyViiHC7qAfhodIo0JkYoS57+WmJwSpTBQNqHRFVadK
	PlobWpDg7igICnQS4LVzTIv/On8g3VfwSvDqDYLo+qTWAd/Lw4sUrTUnU6mWlg40rsnkdmXCiP3
	FOHdZ4vjrJCgcv7huar5AzH+ZtC/EltAduqymWprPSulR4sIqDn1BZseScgW4ZXMoLcaBVsVYSP
	eIJKOWgmcjMAXX69W5GNc4QInZ/elc0K8pwyQzXUDhsojZh6EFkkvQf6yXfJPTnmg1TxXO/vMI+
	mNLlhwd31qLp/kcl6E7FBGR+7x1HUC6M+3/8CxgXqq5h0oqYhcwKUvy39pjcxpuCrRgkn2pAzaH
	eCl6NEjwFqAo0vuTS4jnD1dss054FAD8qQOOR9QXmBThYkhT/1Pntkni+ZgYHWpkEiCxg9hF1bk
	Rd5x2v9tmRGcoTxDH6Yb8Lki3STntcicUJgbWjG52P13S9U3SNQ6HL/+0lxEI=
X-Google-Smtp-Source: AGHT+IEk2qV1I9dbcykpasrU40jJ8DeXhyPRy9Tsf7CPWcP8hKXihzFc7lGHCIdXQ34J061Aq57Mig==
X-Received: by 2002:a17:907:97d0:b0:b73:6b85:1a8f with SMTP id a640c23a62f3a-b767170ae15mr867540666b.49.1763879464915;
        Sat, 22 Nov 2025 22:31:04 -0800 (PST)
Received: from f.. (cst-prg-14-82.cust.vodafone.cz. [46.135.14.82])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-b7654cf0435sm929432866b.4.2025.11.22.22.31.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Nov 2025 22:31:04 -0800 (PST)
From: Mateusz Guzik <mjguzik@gmail.com>
To: oleg@redhat.com
Cc: brauner@kernel.org,
	linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	Mateusz Guzik <mjguzik@gmail.com>
Subject: [PATCH 0/3] further damage-control lack of clone scalability
Date: Sun, 23 Nov 2025 07:30:51 +0100
Message-ID: <20251123063054.3502938-1-mjguzik@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: CAE9140012
X-Stat-Signature: wx9g7ryoyjjdx8hi6dgf463hfi6zhhfp
X-Rspam-User: 
X-HE-Tag: 1763879466-954753
X-HE-Meta: U2FsdGVkX18EeO2SnRn+mI2R7onJCsMFHsWd1mr37pA6qRRQ1j3FqNQYUujdpvldSKVmre2EZwBM1vCUUkvmWxYVLfh+QOjwd4KSzJh+uImsiKukgKzUg01Fi3/ZRj1aUU1aMsgC2TvcUFWi2ROu/6RWp3yj1R8EeLitgEqlTCxDRYvrYmxY6CtNFBZ6j6qUryY69Si8FyBGVgUmvCxVks5dxlC/ww6iERqWudPx1ziVnQPoV5fzfAEdHUNg8RhoVlWC6zJvp3z0crdHEOQiKP0hnjYT/KlzXs8vCR5IyOb9teANAEQeQiEO1SdcnpV+5hkkAPGog9wDwCfIy4cFXXCryx+ZITJipdoOFPIAL8B91tmnA5ejzr3JF/AbPSXzBYjq5LzzfpdUAq5Di1ISKDPg4FwGInj8ugstPU3YQWHdmAz+J8Xw9iel/f4PwWhW+8Bf9AG/uPHU9lfpiZZQXcYpqMrUqLlhjoLbkLShMiIpUEWmeZbMdZpjVo8Vw50jz43IKwZUBS/ZlnZ54ubSHc2qBa137flga/xXPqO1XXIEEYEusSlJNNkoLhlW3FboWxcwZFs6kzw8M1sLAKhZovTtdKkjzAcezq6++EBnmDhmqlADCOPf1CtwwdAPBz/MARzrktS3T/HpQI8cCtHOoiJdTlzklP6t3LwBQ1QdeIfNa4eIzwjOPcHt3yoVaXcT7bYMuBlng5obyCrOr68IrL1J8LZwYNXZKI7TLRtnVsy3wxcokZL+gDLAdQZJGXqgchB1t2TPS9r871jR76f+uYnG41P9KnTcQYxZu+aqwCwUW0pitzfphpT9IS0GW9f4Iybg3Vd1cOE7HUnt3LERaYieN5kli8Uo5qOvGO9OXPNYj5OKIC6oPwIwxn67NEL/T6pmm5satpfDxl33dBgTfoiBJcRUpwuDaPJbI2O3/xjMUxSiOIL7hkzLpTrxx+U+NGDQBD9H7XxTbVl2HSm
 XAXGiX34
 7uH8NuufpSWjBtI/eu0pzraetgCiW2Q4pfm/aYRloPjasUcExw7LgTdh4/QKF5YbO68ZgZXUesxUM84vIvBsHTOTxFBI3h9SnhNeZ7ITjQRplsXPmChI/1o4de0CEuoOWanP8nDwmNeDlWZQIYsNY4IBdiQYJ2OVm3z2PfDRlUisG4BkpZnYFNKGKeB4UUlLk7g7wEaBKwmD0MW5JJKioGIyedmzNten48cdvLcQZmEFdp7PyEmYfvLuD2wcCbz3r5XgVWkAAHBmfo4XQWJMgxHKKJ6PSsDYrXyu5l38GUR7s4OMByB7Fq9EbiH5O/QPxDFI0JF3xhzupNqYwTcI3bVDWZVd+p2lKKYgJU1yjur5LCv3NdUDaspKJFtqZcVKg9SKn
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000001, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When spawning and killing threads in separate processes in parallel the
primary bottleneck on the stock kernel is pidmap_lock, largely because
of a back-to-back acquire in the common case.

Benchmark code at the end.

With this patchset alloc_pid() only takes the lock once and consequently
alleviates the problem. While scalability improves, the lock remains the
primary bottleneck by a large margin.

I believe idr is a poor choice for the task at hand to begin with, but
sorting out that out beyond the scope of this patchset. At the same time
any replacement would be best evaluated against a state where the
above relock problem is fixed.

Performance improvement varies between reboots. When benchmarking with
20 processes creating and killing threads in a loop, the unpatched
baseline hovers around 465k ops/s, while patched is anything between
~510k ops/s and ~560k depending on false-sharing (which I only minimally
sanitized). So this is at least 10% if you are unlucky.

bench from will-it-scale:

#include <assert.h>
#include <pthread.h>

char *testcase_description = "Thread creation and teardown";

static void *worker(void *arg)
{
        return (NULL);
}

void testcase(unsigned long long *iterations, unsigned long nr)
{
        pthread_t thread[1];
        int error;

        while (1) {
                for (int i = 0; i < 1; i++) {
                        error = pthread_create(&thread[i], NULL, worker, NULL);
                        assert(error == 0);
                }
                for (int i = 0; i < 1; i++) {
                        error = pthread_join(thread[i], NULL);
                        assert(error == 0);
                }
                (*iterations)++;
        }
}


Mateusz Guzik (3):
  idr: add idr_prealloc_many
  ns: pad refcount
  pid: only take pidmap_lock once on alloc

 include/linux/idr.h                |  1 +
 include/linux/ns/ns_common_types.h |  4 +-
 kernel/pid.c                       | 99 +++++++++++++++++-------------
 lib/radix-tree.c                   | 19 +++++-
 4 files changed, 76 insertions(+), 47 deletions(-)

-- 
2.48.1


