Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB91606A329
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 08:01:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (4096-bit key, unprotected) header.d=canonical.com header.i=@canonical.com header.a=rsa-sha256 header.s=20251003 header.b=l+Xfiw/L
Received: by kanga.kvack.org (Postfix)
	id F01ED6B05CA; Tue,  3 Nov 2026 03:01:10 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id EB2AA6B05CB; Tue,  3 Nov 2026 03:01:10 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DC8926B05CC; Tue,  3 Nov 2026 03:01:10 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B7CBF6B05CA
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 03:01:10 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 4BD6C80336
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:10 +0000 (UTC)
X-FDA: 85393062300.01.72C45A6
Received: from smtp-relay-internal-1.canonical.com (smtp-relay-internal-1.canonical.com [185.125.188.123])
	by imf27.hostedemail.com (Postfix) with ESMTP id 1BC8240003
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:07 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b="l+Xfiw/L";
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf27.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793692868;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SqwVuuFMKCKR73bttjYygSAw+Vd4A3DCZlBKiSiMzKg=;
	b=NMY28Km2c8FTE1CZTDAzvNVciKQo9Sd7Q3SIZISLF4RXi3w87dVxYe8s6X6DhItwvfvf1o
	jgIRtPaFW4peHR6huzoRzsvnM1hrPSaGSXR9y8zdx/UfII2NPegKUYdEtEr8Jl0w9VQdWI
	HmKFTi4+sg73LTKbaybrQZNMAd7jd1U=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793692868;
	b=1j+D8PIqZRT8uXnx5wvBFiZosdCi87+2WeJO++uJFP7GBYdSaz3alo0R/fXfvb9Sn5yQK0
	yjsr9BDWfSsLiL9xGycUTLg2ZxKIlUAGtf1se9grJ5Z/qVjo0sSfm1Ev/24PlWuJBreqYR
	+ThPHyl1ZTirh1SQpEcwwm0KwvAGFGo=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=canonical.com header.s=20251003 header.b="l+Xfiw/L";
	dmarc=pass (policy=reject) header.from=canonical.com;
	spf=pass (imf27.hostedemail.com: domain of matthew.ruffell@canonical.com designates 185.125.188.123 as permitted sender) smtp.mailfrom=matthew.ruffell@canonical.com
Received: from mail-dy1-f200.google.com (mail-dy1-f200.google.com [74.125.82.200])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-relay-internal-1.canonical.com (Postfix) with ESMTPS id 02A243F606
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 08:01:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=canonical.com;
	s=20251003; t=1793692867;
	bh=SqwVuuFMKCKR73bttjYygSAw+Vd4A3DCZlBKiSiMzKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version;
	b=l+Xfiw/L24Srq5FjemCXGKVkefl3tHkQINqwr+aMB5OdqKqC/+EbPdlJ6SGCgm1HU
	 z8rT+9cpVlnSd4FTmNXnd1cAKH5Dst2kcoquY6EzBZXSX72KwwodLmQIqxvoF3K5tB
	 vdOspHXlaoUrTDH1A4gGWA03MdflOK1naLFkieu0hFbBIREEqz5O0628+mfmxKCtF/
	 w2xoOd+FRhiTTSJq7a1BCP9O4qMmq5+uyJA6dkLtk8q7vCiW+1BIMJ/CrNY/ooTq32
	 XNqZun6KE9tS6LNZPDloviVP7LotBGJfFSF7cmFepxBXYRzsNsJ/WBL4bvRI6qrAt0
	 ZFFssuVvgki+6jyQku3aInNmBqxDY9gs0uquQ+SDgTEgMqssdT0pjPCdCw2/NkXwF9
	 6VaMcakq1TDopqZyXWky73OAGEReAdd5aO82oGeBY1ExBEsZBbK7Nnqi3BccfgMaNv
	 F2sfXQbjOlTAH/6SfNyQO7t+kHnzivIk4DbP6WqzKC0PxFeoQ0iimNJCh+AsTgKhKr
	 q2TUvnkkxZp/SxnyblilbOItT9kwcYTarLJN1FmB/BXgm3ufRl1xbfoCxENogX6wNP
	 Zv/IPN2UBFk/vCk/i261gtLohhIDO3q3MEuNsJcdzai4CRrc/SxZD/LVRZ91ZPSShv
	 hOFwQAfdKEgVNXD7obLIu6KA=
Received: by mail-dy1-f200.google.com with SMTP id 5a478bee46e88-36a190c53a3so758567eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 00:01:06 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793692865; x=1794297665;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=SqwVuuFMKCKR73bttjYygSAw+Vd4A3DCZlBKiSiMzKg=;
        b=1L6JeuZJ6dKLExOWKyAsuy+zO9oqIC0hMcT9md6hAgDtLapyvBzF1EhqtIDTudA35c
         6qbwEmOaxVAOKI7eaUxAosXLLYCYm7eTLBFvs6Q11nnmyWUEi3WpIbDPLilw/ZPTSyAr
         pzV3VrzREwFoxMN7aUaxRWFfUZFRyRPPR3Phds5mjMaJTkRHVW2uSCX0+o+hEcfz+rNW
         H/qHfkBMPa5KECdNc5wZB7EoOhJ+Hm1TlaIYAY/I18Z1hHY1kbpBF0/kaYxfu8xq7qE/
         iiQuSzHLOqucO3ap+/D9fzV7AH/iUWo+/0KetF4c+PQOfsRme3hC8h7u3cWjnwmVhtBE
         G77g==
X-Forwarded-Encrypted: i=1; AKwUvBxoveZpgrdJFY6J9RhD1FNjJnE/k5rpQHYqwEfC/Jl4ukXfw3dS8gI+hPRA4LJDzrKkx5zmpC/Otg==@kvack.org
X-Gm-Message-State: APuU4Z9041neWwy0sMJh8n4ld/V1ZH9vghMFejiZoXhw6g+QR3v3Al7T
	T322fIoCbAWnGPRgXYhHgvVdp0bmeKP0F8L+cegA77TjasTLa0XBjCMpIOr4XP7sLI/gMWsnVGG
	xx7TUpauZfOYtsVL/pIAbVgRQLhFSZBEhIjyJ3PK39+kCPCu04+vdMlClILvGT2V4dIgC
X-Gm-Gg: AYBFou0+SRKtp41XGJQglOdxT1RsvE+pOY6c7krO5WUccnL3SV8TIFy1xODT27IZRtH
	lQpIXP/2z3aUqk2+V/Y6o0Yd6iEqNLfEMHpWw3Ms8FrxG6cJUkPNeyC26Wm+p2ttIVC2XY5dMCB
	JlHiCyDjiHtFadvUhKWRGa7taF6xcrb1MEdW5RlSuK0p7QEDGXerYUWy8R4Y5zKsL9Fb2JQxczK
	gLZBDZ2BP3SWiDh+FBW8D20lwIsxHoP2uAJj3VigDQLNmnsZAnBiLmhAd/QtwzdWa4W4cnXswIQ
	9qFEHaC2Wt0wqeKiaaPn4nfQYgUOfNX2ABRH1qRzvoNAhUCMkHLEMGfgo+0T+xzRefqoCgYXNrs
	EFykgPScIjpM0Dg9BDMJCxFK8Ax2sLNkud1VZo11SZeAzog0ZaP0knUM046dGdJZ3q2SiYHkCBK
	okBpnlqODbcnGtIJ7tfA==
X-Received: by 2002:a05:7300:f587:b0:35a:3b98:b428 with SMTP id 5a478bee46e88-36a424011f5mr16276695eec.12.1793692865041;
        Tue, 03 Nov 2026 00:01:05 -0800 (PST)
X-Received: by 2002:a05:7300:f587:b0:35a:3b98:b428 with SMTP id 5a478bee46e88-36a424011f5mr16276664eec.12.1793692864506;
        Tue, 03 Nov 2026 00:01:04 -0800 (PST)
Received: from Garunix (122-58-163-222-fibre.sparkbb.co.nz. [122.58.163.222])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a428af4e6sm37885274eec.4.2026.11.03.00.00.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 00:01:03 -0800 (PST)
From: Matthew Ruffell <matthew.ruffell@canonical.com>
To: Waiman Long <longman@redhat.com>,
	Frederic Weisbecker <frederic@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>
Cc: Caron Wills <caron.wills@pulsar.com>,
	Ridong Chen <ridong.chen@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Juri Lelli <juri.lelli@redhat.com>,
	Vincent Guittot <vincent.guittot@linaro.org>,
	Dietmar Eggemann <dietmar.eggemann@arm.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Ben Segall <bsegall@google.com>,
	Mel Gorman <mgorman@suse.de>,
	Valentin Schneider <vschneid@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	linux-mm@kvack.org,
	Jay Vosburgh <jay.vosburgh@canonical.com>
Subject: [PATCH 5/6] cgroup/cpuset: Don't wait for memory migration when cpuset.mems is written with O_NONBLOCK
Date: Tue,  3 Nov 2026 20:59:39 +1300
Message-ID: <20261103075940.110308-6-matthew.ruffell@canonical.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20261103075940.110308-1-matthew.ruffell@canonical.com>
References: <20261103075940.110308-1-matthew.ruffell@canonical.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: pta48jk7mjg165wzek9dg8ro14udjnhk
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 1BC8240003
X-HE-Tag: 1793692867-694752
X-HE-Meta: U2FsdGVkX18Yv3YelQl9VA8yCLg9MHt0i2rPVNHcprFjBXVlz7nPtPiNDFH/supS3aEpFu+z/PlyMy4vP/IWcv4lDahcC76SRvf/z8BnGv7ETfkRpER4u/uveVH9fY86HCVCmeh4xUmBfOivVOMhHInc0sqwO3zFsyyewVTP3LqMhewan0uEJBUjfv0tRLVjV4SubpF2UvpdNUcVy5Wiqh6TL6IlBlqQDLZ91RUeymqV8jkjRI0N1mS4r1+FlQExWoNow0wsanIhYSelj5IyV2C2kuy8H73Wq4mv9DGpj+RxOMldwwAuzR1IMMQa+oG/ZLUT37l2ntTek3V1Wf+gu9IbDR2/8P6jkC8CckGAnr7nkCX/flphJwcViME1u8gmRPQFuy956mZ0+Vd3VMEyw1janhNw/14rVRX8GXRTbHU7nA3YQlHR1yIYzu9zHF95rwcpsN7QhlB07T00eS9V5TjBAD9JXWzOKeKg3ModN5I56JH3wgb71gTHx9Y+pg4iOaiO1Bsf+0mICM7LkSF20fhe8gIJMmg/54In0YWl+Do1LlMNLImui9xg8blgf82P0LsCIErS7vv1yGVxZEsrJsxTxmvwoEfSu6RBv6l/eAqkrc0y8FYPXapwOsYy42nRdVpOzlUDXpPdYzxNBLPd/rAl61wvjQZVjhGI3FSTrQA92fXJeB7+6Cjf2+YK51We9wvlzxdjXurkvedxH+ch0Hf7H0jHVvvM0yDvV6cTuAKBk4AV43e9hnc91l8TxTO1sdvWAmU2IQ1Hx556jfJaKDp3Vy/TB7GWfJwvJMsIyagthQ0Xs4EU1XedC/UwW2VMw09dUOi798fhuIVX4Ttz79aJQD8OvYFNUUKC/BGSpti+2gCK87pteCfyQxnDxv0vVuI3oQndodgzsnVWN91JI7DmTINm6wI/pcXS6pIB9jDsWAYq5b5zm3hDqt3VG1g7bhbaY/tfevcKGDnE5/2
 ccX5/7zX
 OHMd7G8YyKZin3p9eHoYHmwO2PvaBz9TOQHNOO0iB0Hj43lko/MeMrPedmiJo/5B6S19BKeigAP1ixfWLdCKq7GMl75OGcjkWYn6c3Kxc9au1fzbP1hvk5b7d8qJEh6was37HKuK1IYmDanJ3jsbiZrKl4mrmARZI7XF2le+gwvpRL5wl6O25joUbWgI+2ebvTM6r+WekQq3D6svtUedEDyqM/P9WuXSNYv9PH4e+a4H4Nz8DaEXtxC61Vf3qT+7XgzSmbqQTQcVn2C43/d06AdiGNsusOc9bHRlqX++0yP5WNMKY8Sd8yn//e/KqgqouyL9Hs3+Q2zP1V9Kke0YMYi/4OoIES3LfedAFhyrcbRxYpL7TCZ4S7Rz8Mbyp2IMWRrs/SBOOQvrbq0gXHD41ScAyZIf8JK/Lyx7fi2wPVVE2MfYlHXZFOi14MJCmGuCVIGQwYOfatr6LelsBIgElOF40bOA1wOUNiWae
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Caron Wills <caron.wills@pulsar.com>

Writing cpuset.mems migrates the memory of every task in the cpuset on
the ordered cpuset_migrate_mm_wq, and since commit 3514309e0322
("cpuset: Defer flushing of the cpuset_migrate_mm_wq to task_work") the
writer flushes that workqueue from task_work before returning to
userspace, so that the write appears synchronous (the design of commit
e93ad19d0564 ("cpuset: make mm migration asynchronous")). The writer
therefore sleeps in TASK_UNINTERRUPTIBLE for as long as all queued
migrations take. On a system with isolated CPUs running SCHED_FIFO tasks
that was measured at 2 to 10 minutes (LP: #2165410), and it is unbounded
in principle: a migration blocked behind a starved kworker or a slow
expedited grace period holds up every migration queued after it.

The writer is usually systemd. It applies AllowedMemoryNodes= from PID 1
itself, and since v259 it opens every cgroup v2 attribute file with
O_NONBLOCK precisely to opt into asynchronous semantics wherever the
kernel offers them (src/basic/cgroup-util.c, cg_set_attribute(), citing
the memory.max/memory.high behaviour of commit c8e6002bd611 ("memcg:
introduce non-blocking limit setting option")). While PID 1 is stuck in
the flush, logind cannot create sessions and SSH logins fail.

Honour O_NONBLOCK the same way memcg does: skip the task_work flush when
the file was opened non-blocking and let the migration complete in the
background. Blocking writers keep the synchronous behaviour and the
cgroup.procs attach path is unchanged.

This does not make the migration any faster; it only stops the writer,
in practice init, from being held hostage by it.

Link: https://bugs.launchpad.net/bugs/2165410
Signed-off-by: Caron Wills <caron.wills@pulsar.com>
Signed-off-by: Matthew Ruffell <matthew.ruffell@canonical.com>
---
 kernel/cgroup/cpuset.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 3219f927c35e..439b55a310fe 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3482,7 +3482,16 @@ ssize_t cpuset_write_resmask(struct kernfs_open_file *of,
 	free_cpuset(trialcs);
 out_unlock:
 	cpuset_update_sd_hk_unlock();
-	if (of_cft(of)->private == FILE_MEMLIST)
+	/*
+	 * Memory migration runs on cpuset_migrate_mm_wq and the writer
+	 * normally waits for it before returning to userspace, so that the
+	 * write appears synchronous. A writer that opened the file with
+	 * O_NONBLOCK asks not to wait: let the migration finish in the
+	 * background, like memory.max and memory.high skip synchronous
+	 * reclaim for non-blocking writers.
+	 */
+	if (of_cft(of)->private == FILE_MEMLIST &&
+	    !(of->file->f_flags & O_NONBLOCK))
 		schedule_flush_migrate_mm();
 	return retval ?: nbytes;
 }
-- 
2.55.0


