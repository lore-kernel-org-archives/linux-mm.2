Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 33B6BCD98C6
	for <linux-mm@archiver.kernel.org>; Thu, 11 Jun 2026 06:39:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EC3466B0099; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E4B186B0096; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D3B256B0099; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BA806B0092
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 02:39:41 -0400 (EDT)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 32BCEC1CCA
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:41 +0000 (UTC)
X-FDA: 84866680962.15.6D25BA3
Received: from cstnet.cn (smtp21.cstnet.cn [159.226.251.21])
	by imf18.hostedemail.com (Postfix) with ESMTP id D26D21C000D
	for <linux-mm@kvack.org>; Thu, 11 Jun 2026 06:39:37 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	spf=pass (imf18.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1781159979;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=n22iy8awGTVFhn1UXQ5tpUWRLxU5GhyR+kS6DNw8kS8=;
	b=2Th8drHPbCXuRreaCJIfvT1EzHRI6Z3O1S5GYa0RgI0DV3Iw2Rbn8trG2urmiR3hTUweFa
	5Rf9Y60FRgbuciOvNTyocnGZod7yy9nuaKcT54NHa5FC6N8S39dMdNNjBdSDifcXiB/plm
	iZ3vYJ8ZDVM0Kwcbg55EycoRBbMnEbg=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=none;
	dmarc=none;
	spf=pass (imf18.hostedemail.com: domain of pengpeng@iscas.ac.cn designates 159.226.251.21 as permitted sender) smtp.mailfrom=pengpeng@iscas.ac.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1781159979;
	b=F5RnnJs0KYH6iiIsqXbH6xRqUG8cTtX6bvQG9gZ49zz4ufpsfGFpQRuI3iEIwaJGZnNu6L
	1Jtfwbmubu5Oh7K96VV3jXVmTgyYN5xrGmtpQUlwxcPLpusL6JksJI2+hViTFrTMhy3Hh0
	HsxFwvDA4c5qkzydtYNhsfviSSN8s38=
Received: from localhost.localdomain (unknown [111.196.245.140])
	by APP-01 (Coremail) with SMTP id qwCowADHbdYgWCpqYOJFAQ--.1790S6;
	Thu, 11 Jun 2026 14:39:29 +0800 (CST)
From: Pengpeng Hou <pengpeng@iscas.ac.cn>
To: Vlastimil Babka <vbabka@kernel.org>,
	Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	linux-mm@kvack.org
Cc: Hao Li <hao.li@linux.dev>,
	Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	liam@infradead.org,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Pengpeng Hou <pengpeng@iscas.ac.cn>
Subject: [RFC PATCH 4/5] Documentation/mm: document SLUB previous lifetime tracking
Date: Thu, 11 Jun 2026 14:39:25 +0800
Message-ID: <20260611063926.38111-5-pengpeng@iscas.ac.cn>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
References: <20260611063926.38111-1-pengpeng@iscas.ac.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:qwCowADHbdYgWCpqYOJFAQ--.1790S6
X-Coremail-Antispam: 1UD129KBjvJXoWxGFyUZw43Cw18WFWxArW8Zwb_yoW5Aw4kpa
	n3Kw1xt348Xrn3Cr93Aws7G3Z3W395uFW7GasFgw48uwn8Jw1q9rn3Krs8Z3W8ZFy8CFZF
	vFWqy3Wa9r1qy3DanT9S1TB71UUUUU7qnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUmS14x267AKxVWrJVCq3wAFc2x0x2IEx4CE42xK8VAvwI8IcIk0
	rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2048vs2IY020E87I2jVAFwI0_JF0E3s1l82xGYI
	kIc2x26xkF7I0E14v26ryj6s0DM28lY4IEw2IIxxk0rwA2F7IY1VAKz4vEj48ve4kI8wA2
	z4x0Y4vE2Ix0cI8IcVAFwI0_Xr0_Ar1l84ACjcxK6xIIjxv20xvEc7CjxVAFwI0_Gr1j6F
	4UJwA2z4x0Y4vEx4A2jsIE14v26F4UJVW0owA2z4x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE
	3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8CrVC2j2WlYx0E2I
	x0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8
	JwACjcxG0xvY0x0EwIxGrwACjI8F5VA0II8E6IAqYI8I648v4I1lFIxGxcIEc7CjxVA2Y2
	ka0xkIwI1lc7CjxVAaw2AFwI0_GFv_Wryl42xK82IYc2Ij64vIr41l4I8I3I0E4IkC6x0Y
	z7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x8GjcxK67AKxVWUGVWUWwC2zV
	AF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE2Ix0cI8IcVAFwI0_Jr0_JF4l
	IxAIcVC0I7IYx2IY6xkF7I0E14v26F4j6r4UJwCI42IY6xAIw20EY4v20xvaj40_Jr0_JF
	4lIxAIcVC2z280aVAFwI0_Gr0_Cr1lIxAIcVC2z280aVCY1x0267AKxVW8Jr0_Cr1UYxBI
	daVFxhVjvjDU0xZFpf9x0pRQJ5wUUUUU=
X-Originating-IP: [111.196.245.140]
X-CM-SenderInfo: pshqw1xhqjqxpvfd2hldfou0/
X-Rspamd-Queue-Id: D26D21C000D
X-Rspam-User: 
X-Stat-Signature: jfrtpsqdosqfg31gyee65dcooiptym1k
X-Rspamd-Server: rspam09
X-HE-Tag: 1781159977-24668
X-HE-Meta: U2FsdGVkX1/MH43DlQMOTsPdgrcorgf/sDFh9wvgPhFv4aYnzd77YT7/gtEu6ENWwn+WUh86/Kpncero+WTTX1sx/9yViL7ORv+gpg1eSJWersszr5mg79qIusrPCrnFuTok2FtHghcOt+ath/c1CTBLX1OY4kvMkgWbOlXnp14H1QT8K3wXnJN/HDhvMwo3NE6LLcBqPXY2lpca+hleTui80P2gLZGgCoKMsXWMNWZichMszfbm8bW7JL0kWd4n/SCnUKSpVTZqVXTk3+DOB0sQ1+RwXXhCQweLxiMSWV5jMW0Ziqd4mXkjhk4LZPRmfza5gsvFctSYAI73nU4UhMFa1E+vtohmxzUqEJxR2ehuHJEtPCKg+XiPFKDe796hUr8qpjyd8M8I7kv8PWJK0WU2/dobEcn2sqKF+NoEGFwx7WUuUhcHfqA7dswUgTJIOlY0toz4BGi2gqJqOPC/zrJHgjLTWrsdKcLqjh61o388yAW5fdGuC2/M74YAaKMyPwlvgnFNBQ7uIcW0A0G/7pwT3U1Mga06NGX5O4KZCe36pXAqG1GT0fGQa1VTiSoqYGJrGReW9u+zGALPWn+4aFxFRLwYh8TOYHsuVxs45C0ZuyesEI0epbQ1xHfZkvf0aqDAXdjrpgsOJWAOe8TpmJ0S6CYbEX8kLDtz73U0m/7M0istYI2NZNq6jMQ4vi1rgsKOAV9LpryMik5V53fSgUC3+JvMLSwIHGGnJQZWLUMKU54XQoI8+Ji6RdYWyjCZK4ATW50Ptgv/P8C/YRcHOj2kM0BmKlopbYsAQhP6PVTBdsJvs4/ALqbsPhqW+YVqeFwovEeyyK6JwIlBhXVr3YfilzFW/UjbQzNHJbnmX0CpfX8/647tZUQczRGAJvr0oHfZuss9E8UsCMs7o8xXQ4TyGmDUtcMjIctcCXCdgp14KI02B1o5YfWK17rv5V+1wirqbZztqkzoC6REKu+
 tissn4En
 va5yCWfPLeby6oq4wvKSRpqsrh7nLTj76MlpG3EwRRCHH9P8Ucna2TyugiEKyror5/A3ew/gVRGrx51YoJ1cZMaAfovdelVWswqUgI7xg0CyAS1w6NcTCS+Zqe7nSiiKDrlwj8rgxXbKKgt36ZxCGJdiAtrn+/Eo+cOpS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Document the new slab_debug=H option, its store_history sysfs state file,
and the additional previous-lifetime lines in SLUB reports.

Spell out that the previous lifetime is diagnostic information only. It
can help with stale-pointer reports after object reuse, but it does not
identify semantic ownership or the root cause of a use-after-free.

Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
---
 Documentation/admin-guide/mm/slab.rst | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/mm/slab.rst b/Documentation/admin-guide/mm/slab.rst
index 14429ab90611..4f644c4e1baa 100644
--- a/Documentation/admin-guide/mm/slab.rst
+++ b/Documentation/admin-guide/mm/slab.rst
@@ -50,6 +50,8 @@ Possible debug options are::
 	Z		Red zoning
 	P		Poisoning (object and padding)
 	U		User tracking (free and alloc)
+	H		Previous lifetime tracking. Requires U and preserves one
+			previous completed alloc/free lifetime for each object.
 	T		Trace (please only use on single slabs)
 	A		Enable failslab filter mark for the cache
 	O		Switch debugging off for caches that would have
@@ -91,6 +93,17 @@ kmalloc. All other slabs will not get any debugging enabled::
 
 	slab_debug=Z,dentry;U,kmalloc-*
 
+Previous lifetime tracking can be enabled together with user tracking for
+selected caches. This keeps one previous completed alloc/free lifetime in
+addition to the normal user tracking records::
+
+	slab_debug=UH,kmalloc-128
+
+This can help debug reports where an object was freed, reallocated, and later
+accessed or freed again through a stale pointer. The previous lifetime is
+diagnostic information only; it does not identify semantic ownership or the
+root cause of a use-after-free.
+
 You can also enable options (e.g. sanity checks and poisoning) for all caches
 except some that are deemed too performance critical and don't need to be
 debugged by specifying global debug options followed by a list of slab names
@@ -110,6 +123,7 @@ options from the ``slab_debug`` parameter translate to the following files::
 	Z	red_zone
 	P	poison
 	U	store_user
+	H	store_history
 	T	trace
 	A	failslab
 
@@ -245,9 +259,15 @@ into the syslog:
 	cpu> pid=<pid of the process>
      INFO: Freed in <kernel function> age=<jiffies since free> cpu=<freed by cpu>
 	pid=<pid of the process>
+     INFO: Previous object lifetime:
+     INFO: Previous allocated in <kernel function> age=<jiffies since alloc> cpu=<allocated by
+	cpu> pid=<pid of the process>
+     INFO: Previous freed in <kernel function> age=<jiffies since free> cpu=<freed by cpu>
+	pid=<pid of the process>
 
    (Object allocation / free information is only available if SLAB_STORE_USER is
-   set for the slab. slab_debug sets that option)
+   set for the slab. slab_debug sets that option. Previous lifetime information
+   is only available if both SLAB_STORE_USER and SLAB_STORE_HISTORY are set.)
 
 2. The object contents if an object was involved.
 
-- 
2.50.1 (Apple Git-155)


