Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0107606A319
	for <linux-mm@archiver.kernel.org>; Tue, 20 Oct 2026 02:41:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Cu6UwvDm
Received: by kanga.kvack.org (Postfix)
	id C1A4B6B03F3; Mon, 19 Oct 2026 22:41:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BA3616B03F4; Mon, 19 Oct 2026 22:41:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A93A36B03F5; Mon, 19 Oct 2026 22:41:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 746C16B03F3
	for <linux-mm@kvack.org>; Mon, 19 Oct 2026 22:41:35 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 01826A858F
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:41:34 +0000 (UTC)
X-FDA: 85341453750.17.79BD47A
Received: from mail-dy1-f182.google.com (mail-dy1-f182.google.com [74.125.82.182])
	by imf09.hostedemail.com (Postfix) with ESMTP id 1182D140002
	for <linux-mm@kvack.org>; Tue, 20 Oct 2026 02:41:32 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cu6UwvDm;
	spf=pass (imf09.hostedemail.com: domain of hanzhijian1991@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792464093;
	b=i+P+PkyQqGs0jfsU2d3Sgq9dBsfxNiA1/mwhGUmhQ3GwG8V3uCMf3kve4TNaZ7emWpviwf
	Dhy0ZSrnUJA9a6uLjttltFATSino+6XmYaX+u7w/0qcbSGt1glHbL9GkAg3eAFJDvZonxA
	8rLtSIyN+3DGk8UrNXV69Ol97RCPUDs=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=Cu6UwvDm;
	spf=pass (imf09.hostedemail.com: domain of hanzhijian1991@gmail.com designates 74.125.82.182 as permitted sender) smtp.mailfrom=hanzhijian1991@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792464093;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=ROppqsELXHGeGLcCYxsSX2/ig91E8qLeW9utj4B4bq4=;
	b=ET5ec1wk3IgXCRAtDByDDkiN97i5FBeOSu15V/bb659fZLlMO7PY0QLRzy9tiqipJy7BJb
	+IMwR29YozaPndfe2Vk3mDjCsptUOpxmUPkfaUfDC/VJVmhTutLuvnEz1y3UG8YR6CnVd4
	O74LjyAm5fllF1JgkcosQ+qAokl+NUQ=
Received: by mail-dy1-f182.google.com with SMTP id 5a478bee46e88-35f036b17easo1758385eec.1
        for <linux-mm@kvack.org>; Mon, 19 Oct 2026 19:41:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792464092; x=1793068892; darn=kvack.org;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ROppqsELXHGeGLcCYxsSX2/ig91E8qLeW9utj4B4bq4=;
        b=Cu6UwvDmHixPhsIQnFCtWFNssCQucG+J+ZlPPaJlri/Z+uXavoxze8RRhd+/+T6uIC
         f5EHlduveFgYWD1w+kJwpnwVF9qHY6/RuxsXXmCsecvhibGmT6yX5VyQeTFYzWWOjHgc
         7XPPN35GchHcue9wE7C9nIwpLHeHRJdd4fL+h0vNHlKHk/07NAIMQrqdAsmVQxaCMnxz
         vWme8wdflIMM3cFyRAywVburjzvjpG6BDiVSl5E/tvY1jhZCyI5b0al1aB0LIHg6cxGA
         5RRJhK5463UnYLhsf6S3qDFmNAi6koe/kXtIeeioWkjlaJwx2+NwuvlAL0Zp6sTYxY94
         pkgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792464092; x=1793068892;
        h=content-transfer-encoding:content-type:mime-version:message-id:date
         :subject:cc:to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ROppqsELXHGeGLcCYxsSX2/ig91E8qLeW9utj4B4bq4=;
        b=JXHb/8OK6C1iPCPoYK5UTLw6KeWurnvcRYIWhgSJUkK1YZSl9fivccFz3j+qVoCGSq
         4v4S0Ey0u4PW/kuYLhdaol4W4Pm6MJ0GSFENX6BYqS/lDoILTZi0mf7DTMrcOdALKDMD
         WpK58ctk0F22XXJcwPDaDH7UUyGXRWqrbxI0jHn0pckdznsuijpXgZa3nepTgHb9ULLk
         zJjoEjwOwdSuwknEID5FaBzlmt9jBwuLKkyfjLF/E408i7c3Bf2XFGhgNl66jHaIy3YP
         CSsKQ5c1pX5bjH8cpAesIKfmND4eFScLeM7xUUeczmhWJx87tXGTCMMkgI4GEsCHNMQR
         6t0g==
X-Forwarded-Encrypted: i=1; AKwUvBxNP3MblJl9h21JNgRuEasKorVttRFTQnr19O3dWwEBhgAPgMXEf2a38JVxkTMDe2ARAsaiayy5VQ==@kvack.org
X-Gm-Message-State: AFq9FYLISZYOUx4JRphdN0y2UccWg8Mtj7m7C+6qrmLSeNcjBpXnpEDx
	A+nqVU0CT4fWUnfnRKPyuIhGwOZlAxrWneKIXEi3HoYswnhJMH4cUA8O
X-Gm-Gg: AYBFou2ud4oJxDpSOLsoYfyRCvwiWy27KKpM0Il75GCSu/71eawQ8ZMPpYEC+uRUxFI
	SolwgXEC5uF32wrDvZ0JBHI7ZOB021NivsyldNUT78US4CXyGcqIdVrHZeJBsFHax9ix+eunIO4
	KgqLA3XzBJwY61CjEeIFss+KCvDbZ7jcFTbAFvQsAwlq4pZf+zi7C5k29qHwsc9bQAVLmAqZz4Z
	issCyse+h3hMReCmEfU/b7k8f69DpgshtfESW/8ewXbbPefBL1vj4Ji8qm3VXYLL3cPC9kpnh2G
	8wXFPfiyJvFicQZt47PxkTQ+tlVssrt58rAPRpTBjFcXNmajQGW+pHPOYoi1QNqSEiPNWtBmhme
	5D1IMx0DAHZK77dzhzS+TwJLWR7UpOvmCGyjS/a1CHHAeofsHEhaFAMpY7HlZVzGDzaF3RcAdgf
	EZY8HYXBqHaZeaBDUlfDXYUC9rTCw2vN4nLb38fXkT3vslRGGsqz122wwTNeO0NiYnw3v47bCYI
	v9tfSIN3ZEi9aVqrHo/BD4/LbBX/PxFNGOYULM8Cky+5X7nAjvi/GwvUHt3IxB0
X-Received: by 2002:a05:693c:62dc:b0:366:6644:2839 with SMTP id 5a478bee46e88-3666644361bmr61423eec.3.1792464091268;
        Mon, 19 Oct 2026 19:41:31 -0700 (PDT)
Received: from hanzj-mi.. (ec2-99-79-140-187.ca-central-1.compute.amazonaws.com. [99.79.140.187])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36632d8b273sm1116057eec.15.2026.10.19.19.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2026 19:41:30 -0700 (PDT)
From: Zhijian Han <hanzhijian1991@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Nico Pache <nico.pache@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: khugepaged selftest: intermittent collapse_full(madvise:anon) failure and low-memory false failures on arm64 64K
Date: Tue, 20 Oct 2026 10:41:16 +0800
Message-ID: <20261020024116.2949892-1-hanzhijian1991@gmail.com>
X-Mailer: git-send-email 2.43.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Stat-Signature: si5m5biuqpashtrc4jnar948339wdsj7
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 1182D140002
X-Rspam-User: 
X-HE-Tag: 1792464092-733719
X-HE-Meta: U2FsdGVkX18iq9uxAS7mGdZHqor76MoeHZb+hkdNAWz4HWyTGsnTS8amy0qhiO7vP2RcaE5pjwzIMR0f95jDZnWTotPjR+dXYG3YA17627GQPX2vPjn/MJDYuN4BHkl2xCburaX1XPuvLYI0voTCvknYZZevdj8c13+IzlP9r3a3kshr/gz54GiGAKzY/GPxHtF+o0bnn3NP96gmHV18LOWxMLwQxqrcE9N9RXA6CDDDhNu+tGFcr0OBDGyIKkguzkMzWJy7K8Fhekhv/ci4i1jUtNqfVatECQMj60CUXPu02VaG7Dyha4kORSMXQ3hoRaVA1wcqLJT9Mdo/yqRGc/9CilXxgAAdh1dGBXBJyikkS1IrG3sGbfkFFr1RDecQfPR05/t78ZCYPFVPlvEU/0vgLWP1M3Xl8unoher7Mw6zz25jQb9aXUw/noSbydjSsQBaaOr42dzQ0FjUUdg5vwOmTpt+nWEEGddgtwHN9JBALcF22T9ZstR4BPih5PUeypStcsdSwknCPZXjevu5jM4eeD5rAhnE2RLaZ/RtOkeZWDoQew5JTUpfKCc7FLPSIr6z9n516henM1MrwTbfBwZENlVPQW6etWRNJpmtgyJgk9g9JsArJF7x8y/5rhHnmsTBCxuwDuEWAVzA+2vE8MZBBKXPHQbHug0Qz5YlWwMzjyd7VRjZenBrxiUh7SJVCi3W5bhaa9QcDAM7kNBvHMKD5O0TY4NwpOne67z6aJGMPB2qR2hn+N11ZTGyZYjXXNAW5bQDkSBbvSz9RSq0PrPnLTgadAssiE9OVPA4cEMHLxolpIG6jlIWiVbV/JsBXxkyZ2DbYNsIZMaC92BmARMhcVhbx9o4qnuD45C7P3BJnV/WeNt52fYAUbMvGd9FU2GOjn1M2+jRAU1142dSsuk9/TXowTS2rlptAp4BFCVf+taUHJgxwgMuDu28WAtH8wi+R1B94hKRbDny8Cq
 yJ1AbcSy
 BNjJLJpj5qDkMI5eaZo6GfqGOdXGuE3GqigFwl08Dcd1gzmJ0hU5R5Ah/zh2ztZLD5l4Msa/6/XbyOruvs3Z5+NHGbNSCQZcQOih2Xxy6sR6sNmE15Q7aSRdM/2z7/PinbnDwBfEX6rEEW/OI9G2yrGJQC+TglaVEo8pNms97o+AAc8h2yyWHd0myCjjelZFwfdl/g+t0h0ChJ3pDXHEAoGABh7DRE5R7U4lyrPRq3HwkXy60dJPQSmhlopE7lNMt0PlcbyC2qiLW1wRljADJ1G7TZ05IwdcgsJEnuYCOauiucGCqMDulJkfwSwp20ZAqSm0f/f9oHvvaHx9LaC3wjtZDIrp0tqXKBpKp9i9PeOeA2hIGmSJubTUxnCErGamZD5P5dWcLg5tCNl63QW3bv2y6q3cKBcTaro2/GRqk1aJVLtkXYV2N5GGfqZUXsy8HEa+5LLsdIMJIafEJCKLsyalA8wJtwK/Eety54Q6lxp1MHBoZGvC1H4t31A2HGZU3D3bTJHporcMrGkcexWO04HWJ8t/xDXH1DpyzbzQij7oSpk+pQOykkkBXmVkPz+JcDnpvm/78KIK2o7U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

I ran the khugepaged selftest (as of linux-next 20261019, tip 3d229ce89862,
which includes Kiryl's "run every supported collapse order by default"
series) across several QEMU configurations while setting up a test
environment for mTHP collapse work. Two observations that may be worth
acting on; full logs available on request.

Environment: QEMU virt, cortex-a76, 2 CPUs, khugepaged test run from a
statically linked binary inside a busybox initramfs (no distro userspace).

1. Intermittent collapse_full(madvise:anon) failure on arm64 64K pages
---------------------------------------------------------------------
With 6G of guest memory (so order-13 PMD folios are allocatable), over 7
complete runs I saw one failure:

  # Run test: collapse_full (madvise:anon)
  # Collapse multiple fully populated PTE table... Fail: Bad return value
  not ok 80 collapse_full

The other 6 runs were fully green (102 pass / 0 fail / 3 skip each). The
failing run did not report an allocation failure or OOM in the kernel log.
A minimal probe (mmap 512M, memset, single MADV_COLLAPSE) succeeds
deterministically on the same setup, so the failure seems specific to the
test's sequence rather than a plain allocation shortfall.

This is the same symptom family as bddffa2f9cbf ("kselftest: mm: fix
intermittent failure khugepaged test") — there may be a residual flaky
spot on 64K-page configurations. I was not able to reproduce it
deterministically; happy to run more instrumented iterations if that
would help.

2. Low-memory runs fail without a skip guard
--------------------------------------------
With 2G of guest memory, six cases fail outright (starting with
"Allocate huge page on fault... Fail") because an order-13 (512M) folio
cannot be allocated. collapse_compound_extreme() already skips itself
with "PMD too large for fault-time THP construction" on this
configuration; the PMD-order cases have no equivalent protection, so a
low-memory or fragmentation-heavy environment reports what looks like
kernel bugs rather than resource limitations.

A skip guard along the lines of "cannot allocate a PMD-order folio even
before the test proper — skipping" (or a documented minimum memory
requirement) would make the suite's results readable on such setups.

3. Confirmed skips on 64K (for the coverage ledger)
---------------------------------------------------
  ok 9   # SKIP collapse_order_mixed_sources: no supported source order below target
  ok 91/92 # SKIP collapse_compound_extreme: PMD too large for fault-time THP construction

These match the gaps noted in the v6 cover letter.

Baseline for comparison: x86-64 4K with a swap device attached is fully
green (76 pass / 0 fail / 1 skip — the mixed_sources skip).

Assisted-by: LLM (QEMU test harness)

-- 
Zhijian Han <hanzhijian1991@gmail.com>


