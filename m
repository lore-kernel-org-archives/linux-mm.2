Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7B534D5B16E
	for <linux-mm@archiver.kernel.org>; Mon, 15 Dec 2025 14:22:37 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D422A6B000E; Mon, 15 Dec 2025 09:22:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D19EE6B0010; Mon, 15 Dec 2025 09:22:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C567E6B0011; Mon, 15 Dec 2025 09:22:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id B07926B000E
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 09:22:36 -0500 (EST)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 7C7B013543C
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:22:36 +0000 (UTC)
X-FDA: 84221921112.15.60B72CE
Received: from out-170.mta0.migadu.com (out-170.mta0.migadu.com [91.218.175.170])
	by imf07.hostedemail.com (Postfix) with ESMTP id 6991B40013
	for <linux-mm@kvack.org>; Mon, 15 Dec 2025 14:22:34 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4MVnBCq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765808554; a=rsa-sha256;
	cv=none;
	b=yrSDcw6dL66vTC75i/0sWvNuXbLWW/6pcoMmikK1ocLTjeYN2gXnNQaNFZFKA5CzegEZii
	4xzb5M1y1XfSRnyeE+vAwT96bL+8+x2TZelg9MEhUXjMJa3cN/jDHMcgExwJl5cszR47Bg
	sBsZdKzp0dwAKdiU7LrFdexcmNM/Rdk=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=X4MVnBCq;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf07.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.170 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765808554;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=CvrumJAslAc1VCvcVwMaYcAZmX60tTP0CKkJ3CwjBvA=;
	b=PkFmb6xfsEXnfa0fqgkzjqr0vXFebxeraUpeGTy51/W2eXnwHO302RsomWDpsJHNFoWekY
	qykXHa/crMKz1mkzZnZNHPBpsdaqvRCahapOPz9Y5Rc8AL547MlPgM9K2WGsPu/272UZ6f
	BXCoPYpgFGPRRSq2lO9OkfLBSSa7wdI=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765808547;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=CvrumJAslAc1VCvcVwMaYcAZmX60tTP0CKkJ3CwjBvA=;
	b=X4MVnBCq3TuzMMFEHdiDHgjOKrU5telV2QGDdWrd0jZWwybBSbH3Wd5IbvSMxu/9ClYcYH
	j1SOnveZPw6UehtJaEFsmevAYtk5dP5zmUsZoo3uXUTU2oLI8b5Z6HNmSDDnCM1ZgJeonC
	qs2aBd7aaVnaP3pse6EsDMdbXD+dPsQ=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] fork: Replace simple_strtoul with kstrtoul in coredump_filter_setup
Date: Mon, 15 Dec 2025 15:21:52 +0100
Message-ID: <20251215142152.4082-2-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6991B40013
X-Stat-Signature: 5ox7jrietjzu9kkj93y91osj5ywfcz8w
X-Rspam-User: 
X-HE-Tag: 1765808554-19431
X-HE-Meta: U2FsdGVkX181UPu42ikZJZMzpR3wNdr2uwDeWXDFyzgTTFP9bCOVCCy4sqjrxtK2e7ukE1A5EYXLSJcHRWfBnRDopsb9rvkWvskquDOgmxT5mdcWgysnSPlk2sn5Wjze4UPrMoGnAuxQQ3ICZYSdaPsxIb90V5awGF6Uh8awEOTY80C+fC5RH1ccOnXMu4gzGwGfiZYtj8Y+3Ta0Lxs0PxsyiqUfReypM+YNwVX9V8zBd6AGj1jP7Oq8oIDD+ioxbDIELeViyWDENQsHxPAZ/BIvpmZ40JKtc9/TZjcYsxLT+7rhFqv7FiMjPysXdPtQFCP1PpW2fBEi/HPQ9BTGA9LDuGxBBwDQbaQFkUk0P+ykI6p6QZcUlhL9fqcK2SLfMH/KJF/17h4wZINYRJchbGrBbAK7V8z2MHJa3q4qvGTHd9XLLjw7ud3eVADXiR6VycwyBEd0PkReHewj1yE6Gb4IZxS7AvPuYY6m9F+xBqUHGOUvPA/0c08mHDHATy/KajlC3xc9Gs6t77mUGnf5SwSRMLOYdpnxVAYEa5MRW9UlsxdUJTd8+Lz9EU+1CClDW8YJZjIV9hTcp9+TXegqvZ41D4p7R7SZif1/N4qdP90i3BTRZP9uv4ojIFGZy+m4bduAvUVXHKqy2pIu9351CQH5Z64V+kal3cJOMBePpjOJczvXxVl1IrDHd7MwIhKlMbDfXwc5t9XVin2VyG0EuXC1UQ3qCiM/07OiDtM4uzNc2ZfBPjPNGfjq9dmNy51sfNgAE6ggWCb9YWO7kJf40finIG/OfAWHAfD9zIQY1/M4P4qioe4p7hlyeTExzG2ydYBb7IOVVRWBAaRMJCp7qI7Y7Vm2u/nqcL+PdUqUtdmDykwmgjatjoTGCTSZ7LG0zUcijF+jNMX1zxe+BqprqjHhnGmWJ2hLvs7lG7lC+4IT2XOkF0K50dyl4M+QRHi+PkrCob4Yk9i+7xFm9sM
 s8cFqYM1
 1N/IaLr7JNsRsdB7JcuyiZuNOMIVWGQWn+WKS2uYSES+tyqtZ/KsCXprJZfXl0bVh7r8jJb10nvzXAsvf8GB5cbvwzVyO736MAB5SdvgmROFYQAJz39AYoTa1nU1AZId124XX1BRoXf2co/paPdmGv9587I8WLjsFP3fa8pg28hDY2cPhPvDPCZRMdoAnmnNPYgO4W6MY27IAw7SRkkU1uB8yVd8nhY3EgakmYG4BElxO7+Eg0clwm6Vuah9enHgJ8syBl/KfobRNqPf8DkbLpzTeOw==
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Replace simple_strtoul() with the recommended kstrtoul() for parsing the
'coredump_filter=' boot parameter.

Check the return value of kstrtoul() and reject invalid values. This
adds error handling while preserving behavior for existing values, and
removes use of the deprecated simple_strtoul() helper. The current code
silently sets 'default_dump_filter = 0' if parsing fails, instead of
leaving the default value (MMF_DUMP_FILTER_DEFAULT) unchanged.

Rename the static variable 'default_dump_filter' to 'coredump_filter'
since it does not necessarily contain the default value and the current
name can be misleading.

Signed-off-by: Thorsten Blum <thorsten.blum@linux.dev>
---
 kernel/fork.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index b1f3915d5f8e..f33ee7fe53ad 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -1012,13 +1012,14 @@ static struct task_struct *dup_task_struct(struct task_struct *orig, int node)
 
 __cacheline_aligned_in_smp DEFINE_SPINLOCK(mmlist_lock);
 
-static unsigned long default_dump_filter = MMF_DUMP_FILTER_DEFAULT;
+static unsigned long coredump_filter = MMF_DUMP_FILTER_DEFAULT;
 
 static int __init coredump_filter_setup(char *s)
 {
-	default_dump_filter =
-		(simple_strtoul(s, NULL, 0) << MMF_DUMP_FILTER_SHIFT) &
-		MMF_DUMP_FILTER_MASK;
+	if (kstrtoul(s, 0, &coredump_filter))
+		return 0;
+	coredump_filter <<= MMF_DUMP_FILTER_SHIFT;
+	coredump_filter &= MMF_DUMP_FILTER_MASK;
 	return 1;
 }
 
@@ -1104,7 +1105,7 @@ static struct mm_struct *mm_init(struct mm_struct *mm, struct task_struct *p,
 		__mm_flags_overwrite_word(mm, mmf_init_legacy_flags(flags));
 		mm->def_flags = current->mm->def_flags & VM_INIT_DEF_MASK;
 	} else {
-		__mm_flags_overwrite_word(mm, default_dump_filter);
+		__mm_flags_overwrite_word(mm, coredump_filter);
 		mm->def_flags = 0;
 	}
 
-- 
Thorsten Blum <thorsten.blum@linux.dev>
GPG: 1D60 735E 8AEF 3BE4 73B6  9D84 7336 78FD 8DFE EAD4


