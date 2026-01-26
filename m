Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D90F4E63CB7
	for <linux-mm@archiver.kernel.org>; Mon, 26 Jan 2026 00:46:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id AB7B36B0005; Sun, 25 Jan 2026 19:46:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A65DA6B0088; Sun, 25 Jan 2026 19:46:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9715F6B0089; Sun, 25 Jan 2026 19:46:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 823A26B0005
	for <linux-mm@kvack.org>; Sun, 25 Jan 2026 19:46:10 -0500 (EST)
Received: from smtpin08.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id C152D1A019D
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:46:09 +0000 (UTC)
X-FDA: 84372273258.08.A998329
Received: from out-171.mta0.migadu.com (out-171.mta0.migadu.com [91.218.175.171])
	by imf16.hostedemail.com (Postfix) with ESMTP id 05F2B180008
	for <linux-mm@kvack.org>; Mon, 26 Jan 2026 00:46:07 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c5y6Z29q;
	spf=pass (imf16.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769388368;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=7feh2aXWBxrideFwkWvNMaR1KAOwbyjbP/tYcnRktzM=;
	b=ne5mzWHuhnENTd3MBvsTDpkCnrlP+gOYqtVIjafINc1QTvrR3hYzqT4aGb5pHhnUUvVwjI
	DpxLSyytih/Mt7m28d7/UqOHuNW0J3h5ftVlm/mS/rG39ems1YafC0heTog5WwtmcH0H3B
	r+9e5oAnsAFqJ07jxbmBT14W81T2y5k=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=c5y6Z29q;
	spf=pass (imf16.hostedemail.com: domain of thorsten.blum@linux.dev designates 91.218.175.171 as permitted sender) smtp.mailfrom=thorsten.blum@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769388368; a=rsa-sha256;
	cv=none;
	b=O0UiKhOtbOenjtZD0r42NsODjrpD5jz7KtHlhYB+9V5fqkDQy7XwKN4+vzNXcOMcO38Jkx
	4VhEUDd26ThZu3GWMNyaaPjlxvYTQzUKCpCfTd+Ps/TzjIK+OmPwAyHXv4IWS/+jg5R9Ou
	bVOYmBauT4rYL0K56J6uE+L7Ogk3Raw=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1769388365;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=7feh2aXWBxrideFwkWvNMaR1KAOwbyjbP/tYcnRktzM=;
	b=c5y6Z29qa3CAHrEpo/GhBtIE5XvRNsLTcDbFECieKrsbNLtlDneWlL9RMa1Aph7v/vS9AK
	xQbhoAmVzWbLTPHn6vXOBgL+8qyRqfONX+fNx9bEGIGhxvaJ4nsaVTTPbs6B+NTHELmHGY
	3V7D+tm8hTcQG9PBbJDOPSO0eP7Qeyc=
From: Thorsten Blum <thorsten.blum@linux.dev>
To: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Ingo Molnar <mingo@redhat.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	Kees Cook <kees@kernel.org>
Cc: Thorsten Blum <thorsten.blum@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH RESEND] fork: Replace simple_strtoul with kstrtoul in coredump_filter_setup
Date: Mon, 26 Jan 2026 01:45:58 +0100
Message-ID: <20260126004558.210609-1-thorsten.blum@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspam-User: 
X-Rspamd-Queue-Id: 05F2B180008
X-Rspamd-Server: rspam07
X-Stat-Signature: 8gi45obdxddubbrfbpt5qoa37si171pr
X-HE-Tag: 1769388367-724146
X-HE-Meta: U2FsdGVkX1/SwxZWuDxiyA8oFssH/bPHtQ5xx1ZqQPa+9S/SAKteN4cyn9yAjJulBpYh9b5okPW/cZ/8dzkrqdN9UbrF/tJOD+q3QSy2uKVBwNTo+MIYEC57PbVZBJfLTRMh2cgF0FX85sOeehmlswgd2ZWy4sbsEVctIq836muIxCnXjoEQjg/qkf0OVPMZEwmlQFTn4NMqIo++E9HggMEmWAhpXOIrYt5hrNMvQDRfLa2TWe/ba1NP0oP+tPrdghbJ6TDGKdWzQ7ieBAOv9jx3Sw7zwysTWDE/Nvy/akHDofEkUC1MWvI7aQK4K+TRCL4Pl9N2wJS1cQ7UM0xr/nbaCJl6IWOpKe7eCFBUG8P9yM73EQvK29TJEKQsikKuQNwdlZrEtk/BG+CbT5o1JeaR8uqXVP9PjlpVfnSR62GRI3Ivh1OKIpnHd7Zx7Xhkju4i7CSuwaoNj6YNC5o7d4yBqrJpLhe6FY0tIy7P7FqBipbALSQFGQlHF2W2ps8XYEOkLkxNtP9DSpDod41fiWl2F81kLt0NwtWX5jLkiGaxDrc3AGgVqv8SAUUqwWDUaIty7PnrHlsoh4hexEeCDim+3IiBiz60MgpYBX3zaQ8BX4n+BXfrPKORNLn2v9+LHRPldK5K7x0xztbAOlujwDowpO6NAFciLRROl/6hyRjPSiLK25GdKwUnvRfoAHJMuHmSWlm0HwOz14l5xxODiFv4bSq60Nv9OzkoKnadn1ttGF7EQnesnrxwilMwqe8U9ergOWTQzDH0acRIcP5zup7zM99x0ww0WDI7lbKD3aVM/7VuZSmtdpbOa3zcIATdQYF47U/lXLViXY/4EuSnkzem9aIU33wj83gkWavdpS595gmvVPqWBM2inJf2sfeUvrIwH03IMd73fnUPZiqy+IlFvLgEep45rrm4Py047KRiEnqfpdaQMUa1tUln+j5ehq8w8SJb42bHTMnLiMd
 hIjdeToO
 PjTljWR2WGgvA2pUD3wAgFrcuLCGC7hFI+05gJV9RkeQQHCiy5khMXa8FYU//Sj8gNCx+izS5kiLaiBPbN1AFjTCm3cJUJ1sBpnoH+sdwdYnNXzRIICdx8/8KrJ6Pb33ye4l/KtCScE0S8Twj1cU6rP/prrdKJcXK4wjSeQohyfbHrVidJonUPyT8qSKWubyNMTjL5uvebM23RnVHY8M0barCnI8tRuq4vn8ueA9zT5hgRhfrdHMv/90usVjL5e0cea0feRSZRU2y8Hnh4BU0aTS4MWWNtnPssFYLtO7YCzjhUyH6djcK3XSixQ==
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

Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
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


