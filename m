Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3CACCCF2C3
	for <linux-mm@archiver.kernel.org>; Fri, 16 Oct 2026 20:52:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB13E6B0088; Fri, 16 Oct 2026 16:52:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65506B008A; Fri, 16 Oct 2026 16:52:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9791D6B008C; Fri, 16 Oct 2026 16:52:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 78B616B0088
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 16:52:43 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F1681160111
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:52:42 +0000 (UTC)
X-FDA: 85329688164.03.FF54ECF
Received: from mail-dy1-f178.google.com (mail-dy1-f178.google.com [74.125.82.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 4472D40003
	for <linux-mm@kvack.org>; Fri, 16 Oct 2026 20:52:41 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LwceT9XL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of kanishkasolanki456s@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=kanishkasolanki456s@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792183961;
	b=jZrB2fYuWpUd9MRXb03ANTc0hywe04gsKrHJ5/8tE00g9D6E+Yj+46T8nn776Y9b6NuKgq
	+zWVoCcgoby19Huq5/3q5C99IhstC2PcbL3HaRcMvomxrKr5z80c9y+eRgWqZ0kqBDr1kh
	aVqW9Qp734tqDTZ0lQLUd3ckDU1yV5k=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=LwceT9XL;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf11.hostedemail.com: domain of kanishkasolanki456s@gmail.com designates 74.125.82.178 as permitted sender) smtp.mailfrom=kanishkasolanki456s@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792183961;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=pL4I5GTbfGzy7AcdZoTCof/41Zcw3NVIXltEeJBzdLc=;
	b=8RUjGgrENBNMdwEvAKTm2ny1jhI16JdMKVteTsopIEuDjtc5U60xJb61t15TJ75GLgsPQT
	SwPmaHByCkC3yobeM/62f0+68pwaAmnkpDcz8QzRTU0PqQVu2i9nUklJsfS/91jhJWDrxb
	c3qq7ro8h+xYgtITYgZ8EuvPnfETBwM=
Received: by mail-dy1-f178.google.com with SMTP id 5a478bee46e88-35f1f76ea84so499166eec.1
        for <linux-mm@kvack.org>; Fri, 16 Oct 2026 13:52:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792183960; x=1792788760; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=pL4I5GTbfGzy7AcdZoTCof/41Zcw3NVIXltEeJBzdLc=;
        b=LwceT9XLWJY/J4AwKngi/KcSj3wC+bGHxRWDD5sWVhUKEd07T9FnCL/okQMzhkQRdi
         3uVrP1GI1AGH0V1ywAhM4/3FV1S5jwfhZxC2C3UHSub5whCJEIn0Qw4IxZ60yZeIUkuE
         YpOI4W9ZK/s1TTMFDsGyauoJSDU/DEsXA5mHOl3/blAMibFL0tQigSZ8wv5dY60fcH+1
         oI8Iu5aOYj6qv4eaLq5gwuTWvjTPRx4LVyD0JlTOTKNpqUp86mxnRLLhSrdQgBr4v/zw
         ZoYaTDJeCAXYCewY90rsjrxYJTNdduNZQy2aRZ+mw3Nzn0J/75DOYdbHZlrISfHdV92+
         qQ9Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792183960; x=1792788760;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pL4I5GTbfGzy7AcdZoTCof/41Zcw3NVIXltEeJBzdLc=;
        b=HmIz6l8vPk0vsNaE/itUYdNGoGGzB30q2yi/Au4qlIXbORMXu03qiJcN8bF/wVuuJx
         pYwKEDD8YwlLPjMczb904dXrCTgbcz0p1mm0+owsqigsGaWMwd/liGRiMViiPEcNxCHr
         0MhNZsZJiLG0lvrryW9EcJDM3nhg1LvpHUtuUT9a7TeDCxtRIDDWu5iRvS1Cdw7Hl8+g
         DyiF8r02s3dPWy0SwQjmPnv9U6mPLHerPTMI925FFfipQxJSnUDPqxB/wBN0n1CpMIDT
         HtbNYHRY2kTYdGxuGkArKIpA1GllMksotjFTOZxc5YK18Ieo+V27Lo9U9DfnvtyUyfvE
         1gEw==
X-Forwarded-Encrypted: i=1; AKwUvBx3+UZxfMob/AvhGzk7np2jp2odYvblON0xgYk+BqzhFeieg3/syTj+3ruA+eLNJwNI1A+AHuu1eA==@kvack.org
X-Gm-Message-State: AFq9FYIhEUXVOUzNQv+TOYu92j4cuscMjRPzOLHHCGeGNycfiPZVIrr6
	tsWSheT6dqjGDNqdVfFt7VkpWx79q2023aCNLV5JKPmPHXGKaM7Uvt3pB6VlFGLCsns=
X-Gm-Gg: AYBFou0zTzTzkdMH96VujDDYumpXaZ0yEja0LyGSQ2Pmt0Iu748MtBkit95emjx37E+
	LDGABkh5ebzkuODmkwP50r9nzTuqnb7JK+CF4BL1kfe3IhmUN56nJljhwWNjP8kt/bgYt2f21v7
	J593/2q4v6Up6Cir3osVGP6ROwhBHMTJaPg65Fk+5k8hwr2dVl3c+RRrLp5EzKiI2gee+nNmn31
	oJrSA8/dc/sO1nspo+gK2DYes3lFAfNp5t1b0bAWKwCKYRHBOypXBpMluOhpuXAd0bE1fuJ6uv8
	8G7yTZDe1t1Xfz/ec3LEBFaefC0zFriGnfpGY/8Vak/de5gooC+fuCv2CSVPdSn30I/alX1ukeA
	zvvldEnkWjaBk/WMKo8HDBAJyeBz/4ilWb8l5fumB9Ik+ch3Stvu4+jK0xEOU9W0gEbhzrK2mo4
	as1uWZ8Bpp7u6QgmVQyb40nW7jsQFyzybHp5YvUGy+8dQO5atvvwE58EqwQU+ZhhBgQwtHTnChy
	AAkKoVn9Xth5pyUKN62Ta/+kN1KdvtWlf2Qif0q4Clm6rzfNz/++dsbq1Hm1gQzvjLA8BVnkQ==
X-Received: by 2002:a05:701b:4546:20b0:16a:8ffd:4977 with SMTP id a92af1059eb24-185136cd2e2mr1206833c88.17.1792183959586;
        Fri, 16 Oct 2026 13:52:39 -0700 (PDT)
Received: from kanishka-Inspiron-15-3530.kiet.edu ([59.145.191.142])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1831b75ac0fsm8054828c88.15.2026.10.16.13.52.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 16 Oct 2026 13:52:39 -0700 (PDT)
From: Kanishka Solanki <kanishkasolanki456s@gmail.com>
To: akpm@linux-foundation.org,
	vbabka@kernel.org
Cc: Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Zi Yan <ziy@nvidia.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [RFC] mm/page_owner: Use per-CPU temporal storage for saving stack trace
Date: Sat, 17 Oct 2026 02:21:33 +0530
Message-ID: <20261016205134.54436-1-kanishkasolanki456s@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Rspamd-Queue-Id: 4472D40003
X-Stat-Signature: qww988t7jj83cw7ky7dd5iup39jh7aua
X-HE-Tag: 1792183961-81591
X-HE-Meta: U2FsdGVkX18JE7IyKO1eBaCOXqmo81C2xQtHKufJPIPHLD1CcTqjrP7ZteUxe8bzl4Uujtn1vbCQrxosyd5Cw9MJs1BrhyrihoTSJIyL5xJU6E9sRM1t2SdrzncNoicsRohGi9180SmSKbIzV1fXggNTbYEh5gmqwCqc8fYsq3jySejHQrHww8GP3GTGmSx5LDLhp6K88mUYxL1vtnI5fwRSoiICbjEweiB+eHYBax1DD2e2AGkUCOVCWJLQYMxShj60Kv0HoHzRtszoxTs5jyD/+YhtMu/SeMxFnMmy8f8aD9aoJWqUm2qXsOlgF5+ZpmvGr1ycLbdFd1pyof/aoMnfSYH9Wll7rmViXv5HcIaGrcVbArt/NE7TP0fqnP4DBF2pcJbXbbUc4uxGQqEU7kLKd6dxxoUNSacJHiuoton0IQwBMclpeaBsrUSibwnU4A3pULM7nm7YI9OF1ZHsm5vnafpOxkwp/WvGIkOhQ0qAARTa3QphLJElkSbQQpLJz8fuigs230/mBZyKoRy+glyBazXbViws16SuZ+f/EV9PC6kd20hppsU2AldbesM+NMJ1YLt8OpYSUmEfRTGwFfpS8xsw61/+kNN1eYutlTCLnuoxxcvmWIFYp0badUSQ6vCqn4hA4ioRBg+W7ms4bj2L4Y6823g5ymsgrAmK12gAqyDJVt8KTC5oTAkVuFn37ulFJ+lxFd3eYl6rZwnVNraXOvlS9/BXGrjVsmdZbp2HkJ6t62LeLH20SHTh+PfmlGmQ5kw9qnaN26R5NBJTB3XNo7hBt/rE8oTSgbWCObLDlgZp/aln38v5M+y4AJzVU8uOHwG05Xxr7bAEOdDIwbEYG3EVk8zR/J5elF3NKmM4bCBxW6NOQjaogHd8v8k0EM2K6ZstN4LSjpGHYfdO7uICdkKLeAyNWVUe5/CSBJZBQkdOhGxrN0EHnJjOSa/NsSVf27/US6v3WMdFe+Q
 pkxNwqw3
 umsIISk3g1GuKQUG40F4cro+j4+9eV8yROoI2mVmRhE7SJBhWiEIMtlvNgRryDPzLOH/alpK/4GjIXwVcfRK1pqPnTpKoaS5HTfcFTjNflhIr5uDz/TmBdU7oDrgDiNM6j50p909k1N3Wit4j0tPeCPeDjiyJ6bag+ZS2uZBq+/x899ULFHHyXJvWUsXdkB+qoj/lOwJpw/eSl34z85nR/1BcRbsXzmwC6+D6kApwXmqUrZ3oOhQ0qCFSawFbSO31rbIQfF1HUwYmhxIenAyrmOx2LTdqp21yb4SUdkxn9+onX6wHMbjpa++cErOzdfrysYzebtZRFTh3cGl9NCkKRnnFQ0y9fEbbEBxttWlhFPReE1jm8gKovdgI8o+tui7xS6y/y/uWm12LYzbOl2y/IEaI3AgUX6KXq4nvtCGr2BPakb3DDvYgFMt8haTFOgpQff4F8dp4fmSVcK2wX5PT7DN/SYJ3Yj6T0etFmLXVQfpQ5u5wbDshI+vA/ApYDeF+L4c85nqn3rPyxrL1aDWDvbbyJ3cqjpazHdOqq+xlmOdCDHQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

I am looking into resolving the following TODO comment in mm/page_owner.c:

/*
 * TODO: teach PAGE_OWNER_STACK_DEPTH (__dump_page_owner and save_stack)
 * to use off stack temporal storage
 */

Currently, save_stack() allocates a local array on the thread stack to temporarily hold instruction pointers before passing them to Stack Depot:

unsigned long entries[PAGE_OWNER_STACK_DEPTH];

Keeping this array on the kernel thread stack risks stack exhaustion.

To move this scratchpad off the thread stack, I am considering using a per-CPU buffer, similar to how kernel/trace/trace.c manages ftrace_stacks:

struct page_owner_stack {
	unsigned long entries[PAGE_OWNER_STACK_DEPTH];
};
static DEFINE_PER_CPU(struct page_owner_stack, page_owner_stacks);

Is a per-CPU scratchpad the preferred design for this off stack storage in page_owner?

Thanks,
Kanishka

