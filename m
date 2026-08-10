Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 0FCE4C5AD7B
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 16:27:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B742E6B0095; Mon, 10 Aug 2026 12:27:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B24FE6B0096; Mon, 10 Aug 2026 12:27:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A3B066B0098; Mon, 10 Aug 2026 12:27:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 83A106B0095
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 12:27:45 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 15CB5A021B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:27:45 +0000 (UTC)
X-FDA: 85085890890.19.52C55B6
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf29.hostedemail.com (Postfix) with ESMTP id 3D900120007
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 16:27:43 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tL1zRUNp;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786379263;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=X260Hjv1Vm1+CEj2cIe0a1PWTJRFadqLD8eHwG/NZfU=;
	b=c6facxcjbxkKDUL4K8LvcV684z6Y804BrXAx9VNzLdk1lSKdzx7+cAQCuyBpIzOV/erTS1
	8hrzvUUhJ6BsV/VVHLKZmQATYbOrRpoV/aI3cmXVymD9mQH1M9PxrWH3apjUwhkQjx51YL
	zwK7zG7VGKmVV01VJU48YHXv7iBeXsk=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=tL1zRUNp;
	spf=pass (imf29.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786379263;
	b=Vvs+tT8hRjEF69cseXW/D7Q2YFEoltSyksxKFrKwNsiC3KIhzoWtVKclUTlABgwollaUJ6
	Ft0W757Vy4U1LPiO7u43LEfpTxnpoXo80NS0JxdziFrUetadr2v5BqWBn24hH2DncSVFee
	B4QtkEM5iixcRhMmx5dC0dUxuE1jIGw=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=X260Hjv1Vm1+CEj2cIe0a1PWTJRFadqLD8eHwG/NZfU=; b=tL1zRUNpp3afizNL+2uKCvqgav
	br5f6vl8elgVUmpe6csLrT3hZ6en1h2jFwx9kl2TnVmGsDlWqcHLo9thWg5oR1WHeXZadQgQtAi7O
	1uC5a+GzzutAlpQi1IErIbficuV9v4nKDuDV6kG1vunLmUQ+ID4zxfCsvfLg+jkua5feS4plS/F31
	q6bEthbhCK99TuKavmLGjTwMhc6BRvLgh/if25ocv0wsluJpKSCz+EKvQkRk+LN80O+DWqEqCJaQU
	gE22eN7KsD5pnOAlOlEYBlMaMcpIog0eP0+RlH0OE41G7B2TII9Stmw4iNpaX+EG4yRF2l48RwjRm
	EyYxAGKA==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1wtSqg-002ufA-1m;
	Mon, 10 Aug 2026 16:27:39 +0000
From: Breno Leitao <leitao@debian.org>
Date: Mon, 10 Aug 2026 09:26:49 -0700
Subject: [PATCH 1/3] mm, swap: ratelimit bad swap entry reports in
 get_swap_device()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-swap-v1-1-375ef0767206@debian.org>
References: <20260810-swap-v1-0-375ef0767206@debian.org>
In-Reply-To: <20260810-swap-v1-0-375ef0767206@debian.org>
To: Andrew Morton <akpm@linux-foundation.org>, Chris Li <chrisl@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Kemeng Shi <shikemeng@huaweicloud.com>, 
 Nhat Pham <nphamcs@gmail.com>, Baoquan He <baoquan.he@linux.dev>, 
 Barry Song <baohua@kernel.org>, Youngjun Park <youngjun.park@lge.com>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Michal Hocko <mhocko@suse.com>, Jann Horn <jannh@google.com>, 
 Pedro Falcato <pfalcato@suse.de>, Hugh Dickins <hughd@google.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, Peter Xu <peterx@redhat.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Yosry Ahmed <yosry@kernel.org>, 
 Chengming Zhou <chengming.zhou@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 Breno Leitao <leitao@debian.org>
X-Mailer: b4 0.16-dev-f8e9d
X-Developer-Signature: v=1; a=openpgp-sha256; l=976; i=leitao@debian.org;
 h=from:subject:message-id; bh=xkXi9fgJ7KrcCeZFprZs/+gSFahKcbk7Esh+oPKGx4o=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqefvpln63mQ6+J5NEbzNRv+b2ue7YHSg/NdBrc
 ElVPwjOUWqJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCann76QAKCRA1o5Of/Hh3
 bYaTEACOQAJ6NERN3M8O1i9zp/4Q3IVATkjnbEjHEtTQBrzn7eMbezJsCH+ViJmjDytGWrbddMU
 jsB4bupJbIV2TeXU3k1cKkVFXVdlwVc8Htn4WVKMI++tbPtif390U6S9bJTkO3b6yYGkixpxHkK
 AqYG5nTKaZnXj6yg5iKow670eLywodVVwWr1TRz6Z/WP7ph/yE0wzuu+POvx4eHkngNy2M8EZBP
 aNDjQg3S+JY5BaY8VMfO9t5yHfleT2+ElNHx+4U0Pn872VxZCCZIwd2ygZXQYzVVJ6xSNvTxGU5
 O5eWjBE6SUmpVFxJtV4y02vbVAWPQfj0C5pboZcb4/nOhUrT9Q08czl8mVypCJto7Mqv0Bw6bb6
 /5FBDlXf3C5fy2DEfzBBfTZ8q7Jsv4Jy/yQXKdqzoE30ox6Na674oKSsG43HiG/j/qOJJ4UatVn
 VY9aXRdDcXkkzeFxBunYw+XiBZzKsKx2zIKzSNMnvKGjauWwAWig4MUID3zjNrTXNaiFe3LogMB
 c8XR7gfoC5cb+yl2k7aUmW0WV3bzGWrgwsNKyYYgf0CwSQ8UVRXc0U4H1oc4/SuroYqf0OP4kQO
 mK+9LVPkubcYQHhXWvUXs7Uh6TtQwLSM2RD3e4JqKfA/CWc2bH5+AuZ+tWnBHhRXDOlIrHFqFJP
 2IDb/9QEHNO80eg==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Stat-Signature: xjjmhmui6s8k9bunqf9pjwcx7ypdwy89
X-Rspamd-Queue-Id: 3D900120007
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1786379263-593730
X-HE-Meta: U2FsdGVkX1+FuSCr8DHzRfTVtPGFPTCW2HruPWzwmswfiqH3L1iNxjvLkU5QGbZ8FyQrB9TqRQ6EbDig6l29rwdl3eg39ZgUCr8qHVdEpeOwU8ncSMGrZs011apqU+Ue3KEriNrq5JTdpGepsBAD9iELaZnyU9yRodvh5oH4/RsgagJwmyhqDXVyJ9WQY7R5zemnXZeLda3naio4e/fBA6YgYVZBy/q8cZhffvskeWiGVD7TLY9egyLW+B+cws9GA2WnV2dyrP+s6THCEfkhQtAMC2fgdPOX66dDZilOXLtc1f4dom0MZpz7/tKOCZRN28gzX8KdgVW9l6yrmE4rZ6Vsc3LwY2m2Wcs+x8+B/wRSIoTkjI6fAjCi7UCdWv9Gdfe+UlzL7CRxwIrQZzaK159ZHlfsrYQASc+q/38QTDOoWb/sv+ex63UZ8bJ9M7Of0B9O0EKIidi1ltMi8klzDb8afJ0DHYh0CscP17nz0WEheghKgNjizotZYYyOUEVFfb7tPDfV+Q60P1j087uNeqnXQVfhc7lyUrO6afJi93dzuMdUmysOiirQzNe8xDkHzasXLKGnduskbxgPBr69h5paMBGUTxpjiNOvzJnOyk0zjyGUrzaZQ2tLf7lnTQoO7ztj6U5VCz9eHcaXm+XPKQk3xDCADmzbhvnwYliU2rejg5wCe6mqmQ/qjnD5CX8GTe0xE46It9R4yh2b+kljnMC8Z6MxafVGxk5WqvmqDJ9Pnc7p5QBu8h3l3g+z4Jis2fqguBlIm74wDzESDnDcfD4IR6Nw+1PEVMgtmejQFn9MlkVYJsZKGa1ZPsVR1TMZwB+iVmrT/iv2+9uZ5zISQR7qfla7vLQpTou8tQzjN40pN2Pt8uFMbtA7+eUbpZFI8zQlSGNiokkAv8uvMlHLXqyhbKJFlLt75C0DnkIIX2H/fmkCil7uMtxKJrtDZCjkILLkw6l1OT7k8Ixgzaa
 /YYhDMvm
 uaJgdZNBgkEdeE8igIzARVyvzt2t1XeeVyQ6+pNGLXmca5aP3ZM/z8Y9dBc61M0Adk5Yuwghmr/Cm7ZInV3u4LS4MKLKKaphs0pmokUlQ+9KLF6OxKZuw0oEE19egzu8/25ResMp8WIVEz9zUoAiO3V9gs4OpKmyh9uA/PpS4KBswUHv3bxMix/nyr96qQrEmvawcuOuqdbCTR54ewwEg8iVhhqpYb1OVL2wRw8SQZRqB2bzPJsNljBjYbzUdQtMpPh1uA7bH+snCojpm6Kzng+jC6o5jaEyfhmZzT4QS62J2vAG2YiUXrtuOKjvlD7oU0RTVy0wCDMH4hNEXCKY4eJL50paOAx11mcwKdeWtKQIPpTCyEWpqIrnVrudyB6NN2h/G
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A corrupt page table hands the same bogus entry to get_swap_device() on
every access to the mapping, and every rejection is logged. One machine
logged 6185620 copies of the same line in a few hours.

Rate limit both prints.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 mm/swapfile.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 4d4e3e3059f6b..9ab11dc24e4f1 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -1899,11 +1899,11 @@ struct swap_info_struct *get_swap_device(swp_entry_t entry)
 
 	return si;
 bad_nofile:
-	pr_err("%s: %s%08lx\n", __func__, Bad_file, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_file, entry.val);
 out:
 	return NULL;
 put_out:
-	pr_err("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
+	pr_err_ratelimited("%s: %s%08lx\n", __func__, Bad_offset, entry.val);
 	percpu_ref_put(&si->users);
 	return NULL;
 }

-- 
2.53.0-Meta


