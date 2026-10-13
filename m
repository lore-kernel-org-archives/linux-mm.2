Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 48648CC6B1A
	for <linux-mm@archiver.kernel.org>; Tue, 13 Oct 2026 19:35:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C2F236B0088; Tue, 13 Oct 2026 15:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BDF7A6B008A; Tue, 13 Oct 2026 15:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AF6676B008C; Tue, 13 Oct 2026 15:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 89B3C6B0088
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 15:35:05 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 72EFEA0208
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:35:04 +0000 (UTC)
X-FDA: 85318606128.15.253494A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf19.hostedemail.com (Postfix) with ESMTP id BD6871A0009
	for <linux-mm@kvack.org>; Tue, 13 Oct 2026 19:35:02 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/HY68Sc";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1791920102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=6e7sCTs9s2Q0EweL+aD9Wlvk19OnMX+Ssr0sngoSMhI=;
	b=vMBBf4COUImipR+dU9psp67iJQgMfKW0Xq2GoDno/KouxALKEGgUokK3eNxGmaeObtX/Ae
	5U4Lhth4Ke2pBEzI7Jn9NuMIPDs31hmsVTrvtTbAPb4GfLnV0vcIOuNire70k3d0Fp/qDn
	E48WyGsqZhQoY+rUeOqYk2vmVE3U3wk=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="T/HY68Sc";
	spf=pass (imf19.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1791920102;
	b=4UV1XQGPJYCv31K1kqRfXCpZj3KgjuNwqQ3S0LOivpnJAUx/J5qoujkZZTgiGns7uWq33i
	hH3cVYD27/SaXQRV6JPmKh/YwOXcfdtzm18l5t4EOAKFrXQSu3wc1cMgc7i8MBUGyRhtN/
	nsnJINpwFz7GZmJT5C8+9GO32Tz2FUg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id CAFE7601FF;
	Tue, 13 Oct 2026 19:35:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59A701F000FF;
	Tue, 13 Oct 2026 19:34:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791920101;
	bh=6e7sCTs9s2Q0EweL+aD9Wlvk19OnMX+Ssr0sngoSMhI=;
	h=From:Date:Subject:To:Cc;
	b=T/HY68Sc3QjRCNkCifO5o9mK2HsfUUeyjqxEFjjGOPL45cILAPxsmu+/5apeQDJ42
	 9VKSkKYJVksoR7WCpG2IbG92C45ERFGoL5MJSJvyj64QiYTWDWPIof9ApirDYt+nhY
	 iN0kHFgqDXqtF/Xjg+hurJq1Ei35YbBkdOWsi56Sz1GtDNmOfJ2aUUMs3A+KkshaPw
	 Zay5U2NKLJH/dLkYJ9w0iGUkh6u7/Y9cqsEbVjrdfq2Z9Om9gaYkfzgO5Omdp2nKn7
	 0GjZ9KIclZsmEKWaQSs5ui+sQ4ikal6AGdwte2I0u+Te2Nymx8Dvb6+OZxAFsI2Uyo
	 QkjSxBIjdFjVg==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Tue, 13 Oct 2026 20:34:39 +0100
Subject: [PATCH] mm/percpu: account full object size for percpu memory
 allocations
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261013-fix-alloc-percpu-accounting-v1-1-03e788a1e41f@kernel.org>
X-B4-Tracking: v=1; b=H4sIAM6HzmoC/yXMQQqDMBBA0avIrDtgUinqVaSLOJ3oiCQhMSKId
 29slw8+/4TEUThBX50QeZck3hWoRwU0GzcxyqcYdK1fqlZPtHKgWVdPGDhSyGiIfHabuAmbdrS
 66VRHxkI5hMgl/92H998pjwvTdi/hur6pRrqsfwAAAA==
X-Change-ID: 20261013-fix-alloc-percpu-accounting-48bf24919caf
To: Dennis Zhou <dennis@kernel.org>, Tejun Heo <tj@kernel.org>, 
 Christoph Lameter <cl@gentwo.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, Hao Ge <hao.ge@linux.dev>
Cc: kernel-team@meta.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, "Harry Yoo (Meta)" <harry@kernel.org>
X-Mailer: b4 0.16.0
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: BD6871A0009
X-Rspam-User: 
X-Stat-Signature: fdr1qa4nwnr4y1geoaice88nwghwarwp
X-HE-Tag: 1791920102-705110
X-HE-Meta: U2FsdGVkX19e/xbgX2lFbaAgHjLo8MlIr1pCNEKEoac9MtVI+SMk0FCg+j+c3yK7Z9rMXeBM0xHw9bkpGTzchRr+K9I06eq7RYEJvExL7wmWC9LsiHZ/DRRuvxP1jkwikgmeS+oj4qmZJupzioLWCCvx76ENDZzLi11o1u0n3afmD3vp6lqTYDEvkgbssjZkhakHIDeKHnS66IulMbiNI9+ZtSXPz26qVFg3cG8jEDlXAbdx90ApoO/OQL5k1O8abTplNO84UknVA+Zq2uMExHZtDjMqKOY/635QloCQ6SIwBftGf9qbIyF7yT5PiDAmaWBXvvVGPEr/2YNLcF0CJKrywveiXY35R6fZ7Ip8s5O6ob/4j+hdYz1Atxl6hxtmZPagSCTtYaFI6YhvXNIgKNPpIdWD8NSj0FFvCxauv7JnfNUOaky55Z6OgHqwMEhUZRVLphX9oHhdpYGDcaeTrWwMgEJio01p1cBvA6DPq0asZEArENu/2Lg62E4fP2ln8HCA3M9iNDHsUaJPNHjAzpUu4Jp7aAlB0SIyiWuHGvKrvJIZJ5ynu7eS9JX+HM5xvciOjxxZZ3g4pIQHZNe93ubvNldvIPHkFzOMZ2M1WmReYWO2NuGa4rfYirzqFmVo2ApqM2cC6522ULj4uSnRh6io7LBCbmqeUHy4DJbQOP7NOVWdb97uFnOSS3TPbQZu6o2dHLPgLsxlfCxi15ycCGzDVaLXPaEg+BJsY2znyb3+RSeVQmk59yhyHeRgkwm/4N6cjHaDLdBkr/etYOWt5MQA0IakPkpK3+RUkpJ1HItPCqoQHIi/D8v/3sO98+AY5Xtpb+WpynB2jAUXRRJsR9R4Yj1ruyKQkL/5yMEU+0utCAqWP7nQMhaazgEUHW09ZdbQiZ+r5PrlJdUQIxscWVmjaLVpRnDwVfPvRAU7pPqjfON7JHJGb0cKTJ5zhh7tkIeg+AOuq0K/VJZ5t2r
 BF3BL4mf
 rHVHqZy2i5afw5WMAusZ7g+Rz0wvUG92eABoS26csapa46aQqEqEIjHMlQXmUBUBi5OzvHqyHk6JL8ZLKz+gP66E2laN7Yl7L7DDE7N9LiwBa/oZuSs/MNqGLQywtlWkwT4pGaRluFMqjasDGhFUCGO+HTbSzfYu7QeFDpS5ktp0mRaKnsWxmdrZyawkkn2kwjxh/s3KB8aJ1LQEmBMSajrlsojOuY4TRSj1gxUNtvOdsB2vIKGo4Tc/xbQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When memory allocation profiling is enabled, the pages backing percpu
memory chunks are attributed to func:pcpu_alloc_pages. However, the
accounting of individual percpu memory allocations via alloc_percpu()
and friends record only the size of a single object rather than its
full size across all CPUs.

As a result, it is often not straightforward to identify which kernel
code is actually responsible for percpu memory, because the size is
under-accounted by a factor of num_possible_cpus().

Account full object size with pcpu_obj_full_size(size) instead, which
multiplies the object size by num_possible_cpus() and adds the objcg
pointer overhead. This is consistent with what memcg already does for
charging percpu allocations.

Verified with 64-CPU VM by spawning 400 processes in a memory cgroup and
measuring mm_init()'s rss_stat counters.

Delta of kernel/fork.c:1142 func:mm_init in /proc/allocinfo:

                  bytes   calls   per allocation
    unpatched      6320     395         16
    patched      418176     396       1056

'percpu' field in memory.stat: 422400 (1056 bytes per process)

Memory allocation profiling now accounts the same amount of memory as
what memcg charges.

Cc: stable@vger.kernel.org
Fixes: 60fa4a9e2323 ("mm: percpu: add codetag reference into pcpuobj_ext")
Assisted-by: LLM # Verification
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 mm/percpu.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/mm/percpu.c b/mm/percpu.c
index 3eff382e565a..d7883507dc15 100644
--- a/mm/percpu.c
+++ b/mm/percpu.c
@@ -1696,14 +1696,15 @@ static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts)) {
 		alloc_tag_add(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
-			      current->alloc_tag, size);
+			      current->alloc_tag, pcpu_obj_full_size(size));
 	}
 }
 
 static void pcpu_alloc_tag_free_hook(struct pcpu_chunk *chunk, int off, size_t size)
 {
 	if (mem_alloc_profiling_enabled() && likely(chunk->obj_exts))
-		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag, size);
+		alloc_tag_sub(&chunk->obj_exts[off >> PCPU_MIN_ALLOC_SHIFT].tag,
+			      pcpu_obj_full_size(size));
 }
 #else
 static void pcpu_alloc_tag_alloc_hook(struct pcpu_chunk *chunk, int off,

---
base-commit: 0e199ae6e803e76ebf128e009d336e5917221e63
change-id: 20261013-fix-alloc-percpu-accounting-48bf24919caf

Best regards,
--  
Cheers,
Harry / Hyeonggon


