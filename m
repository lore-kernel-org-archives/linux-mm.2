Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4BD62E7545D
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 13:49:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B5EBB6B00C1; Wed, 24 Dec 2025 08:49:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AFC306B00C2; Wed, 24 Dec 2025 08:49:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F3FE6B00C3; Wed, 24 Dec 2025 08:49:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 906486B00C1
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 08:49:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B508578EF
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:17 +0000 (UTC)
X-FDA: 84254496354.13.2EE7068
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id A19EA120015
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 13:49:15 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pgF3cVS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766584155; a=rsa-sha256;
	cv=none;
	b=VSrf9PsfHDB4Bo/DELG9Mn9g4Xj3925YfkHi9NwBPIv+xHMZpPRWmYb9cxVxi+huxbLAo8
	lhZMjURCAEMYxFbfJx2RcZZwcbTNJ2UqsfbvrWpHQZbcLZ+6IDyfDcP+v6DBg9W7Ng9ePu
	F/FoX+s10wQhAjdPSlMK+JJ999deuWo=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=pgF3cVS0;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of frederic@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=frederic@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766584155;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=PccGRd2au1n9nQvEk/PkCGv+alNBYU7VP4ze/r44x5Y=;
	b=oNxHKs5C96ahkPdUf0qjxtty+Yg/hzlOPFKz5Bk9wl2fWxoWoTZ9OnNspQyfjG5N8eziwS
	5TbEhSLNUnBBMZ9tJUiieenquYpbIN5H1r0fFyqZ4ayfMOHeChnz9OuotiDGf3Flwesc3R
	Ld05g1aM6dVqiVFrqTRjLI7NB4FFyN0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id D2DFE42AE4;
	Wed, 24 Dec 2025 13:49:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13500C116D0;
	Wed, 24 Dec 2025 13:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1766584154;
	bh=ET9jXr6f8rYkms9GJeHVMFbu3UaE384JPmUpmT08RPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pgF3cVS0eJtNZMorkjrgR3meGVoRMugAE/ejv7L856w2ip4rnxxFZ/DWN2tlLXOGT
	 v8Kei6N9Lo5DcXVWOoQ4ihl6Bu/gTc5tR6DZVcTW6J7jBGZeMlIrHxJM1rEGA7zy/E
	 rKAj1xBv+OQtbZA/FKdkPFzn1Ye7AZ3K621W6USFmD0VuczWW5sgVQVZo0jWZBDCHY
	 G5ZRFlrcgb2lJgHXDO/qJPXat+r5fs+ldhywnnN5lSwUNyYRbhinC60Jl4nHAK5Fdq
	 754ol3zLD6Wxw3ivQMgefbGMNMVawtO7f5SKRLSKPLdZ64PT+ph3MiInUpai34k4bk
	 PoF8H5N2VPtPg==
From: Frederic Weisbecker <frederic@kernel.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Bjorn Helgaas <bhelgaas@google.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Chen Ridong <chenridong@huawei.com>,
	Danilo Krummrich <dakr@kernel.org>,
	"David S . Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Gabriele Monaco <gmonaco@redhat.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Lai Jiangshan <jiangshanlai@gmail.com>,
	Marco Crivellari <marco.crivellari@suse.com>,
	Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Paolo Abeni <pabeni@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Phil Auld <pauld@redhat.com>,
	"Rafael J . Wysocki" <rafael@kernel.org>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Simon Horman <horms@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Waiman Long <longman@redhat.com>,
	Will Deacon <will@kernel.org>,
	cgroups@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-block@vger.kernel.org,
	linux-mm@kvack.org,
	linux-pci@vger.kernel.org,
	netdev@vger.kernel.org
Subject: [PATCH 26/33] kthread: Include kthreadd to the managed affinity list
Date: Wed, 24 Dec 2025 14:45:13 +0100
Message-ID: <20251224134520.33231-27-frederic@kernel.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251224134520.33231-1-frederic@kernel.org>
References: <20251224134520.33231-1-frederic@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A19EA120015
X-Rspamd-Server: rspam03
X-Stat-Signature: rpqxmc3sxn84h81jd44n6oj9eib9bjcd
X-Rspam-User: 
X-HE-Tag: 1766584155-354106
X-HE-Meta: U2FsdGVkX1+pqX2PLYn2xQgkjqkJR64rvA2IUupsQfbdWhT3TOwLF/BA4irqORQjLAh9dFGIAHL9VJ/AFZmOD5mtn5vB7v+YhfY4EqJFdCyiOiCjXIJ6qo8rVbKZ+p4abn2PSvM2V5T1P8JJlo/Y3/yMssGfZjq/I2yRMuqRLiKpX9U5TjvkVK2Ytayoe60do1Xf5gafqh9eop+Ap2ejrslsb1xP2HWYLowu7ke1FZiGGJyn77GRteE7kEEOiNVZVvihdQwy2Jld30IlNj6TGlotqwlRNf9g/WDaQJASMzxtYyImzmUstXp2RLE5MVyyedEWMxO2oweryggb1n4uxTHKl/9yABQeJyTHkjYmji/9Q7vUNDkefklqbs+V9WFfn+NKwsecVvmL1HEz8rzk0QCztirHLqbGefMrEXB+rUD8PjbyYb3lKBY+6FtOXUmXviyfXU2LQp4lysbrD9A/1fdLn5NSb+I6E4ixxCE1iMA5t1uJEgq7bnnMqTKhtQjjOWPyWZzlgvmxrIILCJHand6L44Ll7vYFBjrP1xdcwRv9Dur+za+/WU4E+3pvQUUAzYQ2reLhmAxsQzULLcxMROCuUHqTWZMtc+8vSmV5DEmSru6DFklspu5Q7CxQWH0BH64jivh2NcyuEZYvYj/Q/WGwcotdY6cLGM+0i87wnZLpJatkD50mQV53qwcT46iptTiegXY20iUPw/kdWokOEZDaGLuxqPkhYy2fS2m68jFQBhXV8oiFhxpFW5F2sacQ/HQBPxb1qi9JaIJYyoMOtPpio7dBN3Ae0L7cySMrlkrFkYvUL3NGI40TgFE8qAAp0ZdOJxUlv25fk0TeXOlqMsCWPFskDhuxntaXEmhxLz+xuzNxakJvxZzZT13E7X4t26wSY5pgRB9B1Gd2VW8hQqsPZNclj21gGVGWrwid3eAq0We1x+YCRDRk42ijtI3eZqrxWorFKh7UjVRVj6Y
 e3wZztkI
 sYADq2+djc8g7kKk7JDl3quQF4ng5CFsHfvRX34kI2hyxND3ZfImU2SdyKMlfOwPPDURXPWrqSBi1aX/sOVKxEW+hw/HNeGBeOn8LZUftt70vPF1Cko3EW2TMH0DYr+LP2oWzgkDrvbmLwEsOMq/JPfdUpv9dS+8tx3SWMbXaxd8z6nKU0RAk/zGtMxmL/BZLwQgPjh9S5d+Bh0xglg/L7gWLCfud0/etnmQlaROHKwq9ytFHaxgC5dF0pamqr9SVhonB7mZi7wEpMc4=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The unbound kthreads affinity management performed by cpuset is going to
be imported to the kthread core code for consolidation purposes.

Treat kthreadd just like any other kthread.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
---
 kernel/kthread.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/kthread.c b/kernel/kthread.c
index 51c0908d3d02..85ccf5bb17c9 100644
--- a/kernel/kthread.c
+++ b/kernel/kthread.c
@@ -818,12 +818,13 @@ int kthreadd(void *unused)
 	/* Setup a clean context for our children to inherit. */
 	set_task_comm(tsk, comm);
 	ignore_signals(tsk);
-	set_cpus_allowed_ptr(tsk, housekeeping_cpumask(HK_TYPE_KTHREAD));
 	set_mems_allowed(node_states[N_MEMORY]);
 
 	current->flags |= PF_NOFREEZE;
 	cgroup_init_kthreadd();
 
+	kthread_affine_node();
+
 	for (;;) {
 		set_current_state(TASK_INTERRUPTIBLE);
 		if (list_empty(&kthread_create_list))
-- 
2.51.1


