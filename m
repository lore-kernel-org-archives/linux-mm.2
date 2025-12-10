Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9E50ED3B9A9
	for <linux-mm@archiver.kernel.org>; Wed, 10 Dec 2025 09:14:16 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AC6546B0006; Wed, 10 Dec 2025 04:14:15 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A78156B0007; Wed, 10 Dec 2025 04:14:15 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 98D046B0008; Wed, 10 Dec 2025 04:14:15 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 846136B0006
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 04:14:15 -0500 (EST)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 2AFF3B967D
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 09:14:15 +0000 (UTC)
X-FDA: 84203000070.09.B298570
Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	by imf04.hostedemail.com (Postfix) with ESMTP id 70DBA40009
	for <linux-mm@kvack.org>; Wed, 10 Dec 2025 09:14:13 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nJFkEQYJ;
	spf=pass (imf04.hostedemail.com: domain of 35Dk5aQUKCI0Dr1v2x55x2v.t532z4BE-331Crt1.58x@flex--wakel.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=35Dk5aQUKCI0Dr1v2x55x2v.t532z4BE-331Crt1.58x@flex--wakel.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765358053;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=gJ+diNdvdoAjNwW4/UoG9jb3p4kgQF7Wid7xBQKDtGQ=;
	b=53saGUr7WGyo7rVmpAV+Gttl98zOFO4yrsJ8tNXw+gy5aeWfmtSonipMX/vG9doqYR3CbF
	/RvpngO3ehHcrDV6cJXq3gd7owGnXA+2WgMzkkW9aHbQUVXyYQ2V7sPMQWUx3hC1dpb3PC
	R3glv2cur7Xaq9QcZP3xW3TrGRkoRp4=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=google.com header.s=20230601 header.b=nJFkEQYJ;
	spf=pass (imf04.hostedemail.com: domain of 35Dk5aQUKCI0Dr1v2x55x2v.t532z4BE-331Crt1.58x@flex--wakel.bounces.google.com designates 209.85.214.202 as permitted sender) smtp.mailfrom=35Dk5aQUKCI0Dr1v2x55x2v.t532z4BE-331Crt1.58x@flex--wakel.bounces.google.com;
	dmarc=pass (policy=reject) header.from=google.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765358053; a=rsa-sha256;
	cv=none;
	b=Ru+iIPsn7+/wHnm2rGDB44OKhfJEzUghMPBwFFcjYtXkouEoiCaWl4CFH1xu1JDPZWv7uh
	Wh4wF4ZoUcBAIbr2V7mj+tpDmOoEcMXK4cT3IXK8EzXy0Rp5N3/okQEOwD8Chch9HGRaKr
	AEbAdiDtrAFDWymspMeHhEuRSQ4K9YI=
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-29e6b269686so49670035ad.1
        for <linux-mm@kvack.org>; Wed, 10 Dec 2025 01:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765358052; x=1765962852; darn=kvack.org;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gJ+diNdvdoAjNwW4/UoG9jb3p4kgQF7Wid7xBQKDtGQ=;
        b=nJFkEQYJxi2U8y0qSkT2iphzwhNPrnJk2qdbC2eIoxiXi01vBAlphgZ13GGQcwPaYx
         h4LB8vuRxkX9r/QRZ02EDQ1Bql8/QRhZTJ/Q9c6ZUayfa6MzhhKvQzotTASbl+KJJGEr
         86JQ6fCetu5uRJnUJ36HX/ckdSPrD2f/nj0BXZks512dBNPsewVziLuDFGQdJC1gY1Wy
         eDTjqNDAkxfFSQfCK65Q9EY9+FmSvlRjDLM77qQWMq+hixNKWT06AYpGmFuvlIb+yjh2
         Ox6chCljZZpMQVvQmhRjFHyTwhXhzbp3/N0Zz4akCnGfIz/1ZLkaShBf8pPCUd+sVSny
         XTwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765358052; x=1765962852;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gJ+diNdvdoAjNwW4/UoG9jb3p4kgQF7Wid7xBQKDtGQ=;
        b=khstletXjCbcOCkP/IV3xrxbCPv1O5WlhuPxUygnIjFt57GClc9r9KcMvU1RsWBHbI
         PWLtr+DPoFp5yWyhX7irawN9M4FwEJ7bqEv+nQe0V80x4XO+QvPKHCi6+2W/8y1a7N5P
         q0pBmIanENm0TmQVKY1lZZnEo42FdZL0hU163ZkgSMw0osTEB7fjNnS/cIj80cgfbu/7
         u1it/jVfLok5u04HmxDEjmXfG9kJskw39HXTSSPBo7y2lzZl85w0IZexmZMam/qNL9ut
         91PP4YuZXDwEUjSFspaPPKDnwdW6zB0kCN90QAtVGVYHDQS8MbC2nFuDVXxqR9EZz8MW
         y86w==
X-Forwarded-Encrypted: i=1; AJvYcCV57x9VyQgK1lCzDAP/MLNgucMOsdJx7rR6h6LZkP+n+piB1pShThNRVyd/BQMqV/+1kc6Klgm5Sw==@kvack.org
X-Gm-Message-State: AOJu0YyQ692AAchgElBt0UTFmh2bW7ySkPjC2kafC6IsaPVi1GZpZul4
	vem537YP6GyTMZz54yv28pP3GzVKMyIAsfVqtJdHy4T3KzAuxj0HIxOYyUcLh+VjSNxNfN8MTw6
	T4g==
X-Google-Smtp-Source: AGHT+IEu6z3l2QX6KuLU3Q6OFfDJ0FX6A27zVmwG9FygHINtFnYd4ff1NV1/k8xr34jkmCShD9fTkvGN/A==
X-Received: from plij11.prod.google.com ([2002:a17:903:380b:b0:290:28e2:ce65])
 (user=wakel job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:d482:b0:295:4d97:84fc
 with SMTP id d9443c01a7336-29ec2484bcemr16730975ad.32.1765358052034; Wed, 10
 Dec 2025 01:14:12 -0800 (PST)
Date: Wed, 10 Dec 2025 17:14:08 +0800
Mime-Version: 1.0
X-Mailer: git-send-email 2.52.0.223.gf5cc29aaa4-goog
Message-ID: <20251210091408.3781445-1-wakel@google.com>
Subject: [PATCH] selftests/mm: Fix thread state check in uffd-unit-tests
From: Wake Liu <wakel@google.com>
To: Andrew Morton <akpm@linux-foundation.org>, David Hildenbrand <david@kernel.org>, 
	Shuah Khan <shuah@kernel.org>, Nathan Chancellor <nathan@kernel.org>
Cc: Peter Xu <peterx@redhat.com>, Lorenzo Stoakes <lorenzo.stoakes@oracle.com>, 
	"Liam R . Howlett" <Liam.Howlett@oracle.com>, Vlastimil Babka <vbabka@suse.cz>, 
	Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Bill Wendling <morbo@google.com>, 
	Justin Stitt <justinstitt@google.com>, linux-mm@kvack.org, 
	linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org, 
	llvm@lists.linux.dev, Wake Liu <wakel@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Stat-Signature: 5ogrybe4k7q7q9wdnqqz38ebsofenc9u
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 70DBA40009
X-HE-Tag: 1765358053-479806
X-HE-Meta: U2FsdGVkX1/kEEkPvRlZ3CQdkKHD3lMyoCrTGOSqnWkIeQLfEQhVB73r+Q8MQKUjS5qZCg2+9MdkFbflB0obmCUaYiU4WrpsirUmRIYxuIc6hAFFX0mZmrz0YCHKrtM2PBBXYmmwelscgChrXxCXbX6SsqS3rpXPqgA/cAy060yjH4VPTR7L8ZAmH9EawnMU4K1YYHeMEvDKBEchmEolKAqOd5WqvHAtEZ30QrIadENSxfpRZlOMUgz8tGW8Z21B6XTL48S6LU5tswnYLWuwFkla9P2q9HuTDfLuXv5vt0liTg+U9AJP8VnN0Uld5JfaT0ctadyo/X3Py1CtrJ+aF9ia1CY6HbMWOXKzxhvISzb5EvH6dUPTBC78OySCQpUqTOL1dcI3MDuPxuFmd9TA/kn3lX3BfuTx3i/TtKHttGBMh1E6pGpvT2ExcWS6GLvlQOcgp95REPpDbQT5Ao+jgyrJrmkezVsC2ko75x+evOWWZzcjA0CFlbPvMq+zZ8YnTKYiJGklzfe5DdukbqUhyF5JfL+OtjG0gNRcytECNXC7x9LPt/LrnjoIVkRv/a3oiki2FdoDgDrbc8602v2cw6//wgBgOlt0cxxrzseukqiziloynw0QvYliczG9p/5wRiOzPspogQSAOrAt1WZmBrDgA6D9rK9n6uiLp3Iq4zz/qbVnWsq93MHS2qBanfCozsNJjIOFJtj4t4CmbafDPXHaV1dEmcnyJwkVc/EFynhRHmA9pPQvwqnBMLiyzLhRmzNlVli8Ma/xKdNiPfIbYhkUHNMMC9Ct7ChYed7eot/4aqK+h3w5VtqHIyQwpIKZDvAz9/zGACsDYlMOc9gtexDxjx6QZwUYYnClPMCYlzC+bWrVySI9VMebs+sIBCBKmFLzzHEFc9ZEVYKAigHm0Bw1bYlqLyxDMzgSzkzHsyE0unRBPVhFsHtmVv0+U4/cYvF4Zw3oI7KfE8Pj+yX
 nT6Y+KtE
 qUamtA3OC4WnZXC/do62i2vSxVyKS96G9XXV5wJE49U8bRimAjl5HpEl6imEZK+NlY4wor6/9Ma+b+vtC7hUQKeIJ6lYD2znzemUlpYFDXZmopb989190qxxXnaqSCzqrkYEdywVt6rOxk5oiaUDvKfyYNgefT0EYSKP132YqOBL2ftX+WU2O/v5PlzTXbz5nSiHuhbXHnsHslK4TdCT/x9sl+LZQLEsOuml+7Q7vbnS8vbZzp2uOvC5Cz+O4Jw5zen4ly6r+afYAohMvMGNplZB9G/N3juMoVJXcTJkgx32a7UdPfSJ3mo54Uc8FX0HZM5CXyIkN9MlAk5PRG/rCsZMi2Q2neuvizchLfcWAKBeltKmhk30Rm4Gr5j/no2s3RxlCoAKPn8fvKzSnLW/DOzb+7gS+cr4bFJa+Coyw/TpiaX8pJPBVAn8ABG4b6bkM6DztZOlVQnN/BHV9mQy6U3Wp58pEUAy+pihgLH6egHrmmTjH52yufxmQdC5yaQeTwu+hEBKYuINJqe+pt91JBuyevZbf7ComVU/lBk1UsU3nvAjpiTBxZ3hV5UfTRZ5MtdkUpFhDGVPcBzT82pMCFJ4inl5L5XTtkNv194QudDrqqjA=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In the thread_state_get() function, the logic to find the thread's state
character was using `sizeof(header) - 1` to calculate the offset from
the "State:\t" string.

The `header` variable is a `const char *` pointer. `sizeof()` on a
pointer returns the size of the pointer itself, not the length of the
string literal it points to. This makes the code's behavior dependent
on the architecture's pointer size.

This bug was identified on a 32-bit ARM build (`gsi_tv_arm`) for
Android, running on an ARMv8-based device, compiled with Clang 19.0.1.

On this 32-bit architecture, `sizeof(char *)` is 4. The expression
`sizeof(header) - 1` resulted in an incorrect offset of 3, causing the
test to read the wrong character from `/proc/[tid]/status` and fail.

On 64-bit architectures, `sizeof(char *)` is 8, so the expression
coincidentally evaluates to 7, which matches the length of "State:\t".
This is why the bug likely remained hidden on 64-bit builds.

To fix this and make the code portable and correct across all
architectures, this patch replaces `sizeof(header) - 1` with
`strlen(header)`. The `strlen()` function correctly calculates the
string's length, ensuring the correct offset is always used.

Signed-off-by: Wake Liu <wakel@google.com>
---
 tools/testing/selftests/mm/uffd-unit-tests.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/mm/uffd-unit-tests.c b/tools/testing/selftests/mm/uffd-unit-tests.c
index f4807242c5b2..6f5e404a446c 100644
--- a/tools/testing/selftests/mm/uffd-unit-tests.c
+++ b/tools/testing/selftests/mm/uffd-unit-tests.c
@@ -1317,7 +1317,7 @@ static thread_state thread_state_get(pid_t tid)
 		p = strstr(tmp, header);
 		if (p) {
 			/* For example, "State:\tD (disk sleep)" */
-			c = *(p + sizeof(header) - 1);
+			c = *(p + strlen(header));
 			return c == 'D' ?
 			    THR_STATE_UNINTERRUPTIBLE : THR_STATE_UNKNOWN;
 		}
-- 
2.52.0.223.gf5cc29aaa4-goog


