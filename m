Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84948CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:21:00 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED3196B0099; Tue, 12 May 2026 02:20:59 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E83C56B009B; Tue, 12 May 2026 02:20:59 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D9A136B009D; Tue, 12 May 2026 02:20:59 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id C67806B0099
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:59 -0400 (EDT)
Received: from smtpin29.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 7A8C9140370
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:59 +0000 (UTC)
X-FDA: 84757769838.29.A899643
Received: from outbound.ci.icloud.com (ci-2001j-snip4-1.eps.apple.com [57.103.91.94])
	by imf27.hostedemail.com (Postfix) with ESMTP id 920D240002
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:57 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=WfXdgDmA;
	spf=pass (imf27.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.94 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566857;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mKgIAnZB5fUXzrw1IdBcNeVNTkRS5dYeFy3GvsnLKiY=;
	b=5IbBvAxZjq8V4V3FTB0N38cNgubO2EgFrrp/EagpqViw9HqUbv/Yj/wvjiCTA+X+tvRc6E
	POnY7I8nwwzjdoOuwbOTGyb6Raox/4wACcxRpQAHf2RM1q3w3uVqFd3VbXifvI1/RJMOYQ
	+rQ8JDKJ84N1uMDwMbac7Y+VCCDp7Qc=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=WfXdgDmA;
	spf=pass (imf27.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.94 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566857; a=rsa-sha256;
	cv=none;
	b=iQVMPBCed5zYtNsIPYuGKoMFdOKwcsPq+EnTMcDUeO1yhbiC/koLXs4NUUsFxZfh9HUCcE
	KR7ClnFgI+4GZQOnthdOBD5w74syiQPzWA/5th3+gKnI0frEJDQmbHPvCu8nkJeOPj95O8
	GMdHDKBi+4ALGm6TL74eKNKNaJ5tcwA=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id C11F2180011C;
	Tue, 12 May 2026 06:20:52 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFE0eX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566856; x=1781158856; bh=mKgIAnZB5fUXzrw1IdBcNeVNTkRS5dYeFy3GvsnLKiY=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=WfXdgDmAI2tBeLM82M0xxxdMvosHkKR1IXKAu/jjSOrU8tQl/ZxyO3RH/ha7K4L+3NlLDISMcPN0ZrGkBDF8WI30KLA9MLcBFBHGNQ4cVOim34Ff5eJ4TX5DdPwpNpwjXprDJ4PQQg+6WG5wq7ByFoDCk+J0CHB2hV6WWpxIa1I3v8FY7lyYBaIQSc6NEz3T8+Zk1NdwdYvvpAAv3Zp0J4Hg923FmcjQ38IwOgk6RGi6iwCeiqyxvsuxYgmg7E+CQLTr0tYRxTfYQN/+rf5N7v2QSN3rcxkNF+sD/HTl/mG2NhRRgPTPJnSGAwUmpovYqVgjulEgfPivLYsRlYTnNw==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id 5BCAF18000B9;
	Tue, 12 May 2026 06:20:44 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Tue, 12 May 2026 14:20:01 +0800
Subject: [PATCH 5/6] psi: add psi group for the root cgroup
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-psi_impr-v1-5-2b7f10fdfad5@tencent.com>
References: <20260512-psi_impr-v1-0-2b7f10fdfad5@tencent.com>
In-Reply-To: <20260512-psi_impr-v1-0-2b7f10fdfad5@tencent.com>
To: linux-mm@kvack.org
Cc: Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Peter Ziljstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Kees Cook <kees@kernel.org>, Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, 
 Luka Bai <lukabai@tencent.com>
X-Mailer: b4 0.15.2
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=1490;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=hegqJxsefRUo0IZb6av0loX0beqXtKAilCIuw9AGMOg=;
 b=PpQmxUSe15FVJGWEVgQ54mSJ/1lP1TFKzTir1B2BYtnj3SMHDa69594F8Hmf2TlrNR0dmx2qS
 Q4m22WKPwWwD4F4CLCngciseUZUM95VA5i6FGqMEAV4qErxozcS0EKq
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfX0EYYtqAKu+rD
 yhcbvq0Iuaphbygoj5MTpyMOFj/S9zSD7ipPt2xh10r7q6GLMgeWnDOIcMhwQwafZcILtGCijJe
 SbmPA0Gnc+rUuIib7XjHzO1JEq98Obm3T6djFk6ub0sPso4NIRLwYp5OFingNelgizgGP+jvgXl
 NQvcUDByWZO1dEFVDB1k38KRMLLNd1u/0vYTQilKG9sz45w0VRy1Ut869gv1hWFslAeF9AyAYSK
 e69KW+mGRkPOAtA641O+e4T52Zl2XC+afS/pYAmNvMitoPMaa704jw6L7J8HjhHQ9caTLdEgtNp
 Ds/YlM6zgzuj6xvEB1Ig8gEm52uHMjGdswtA6sHjNq7abTSQiYRzmJOAaVtIn4=
X-Authority-Info-Out: v=2.4 cv=BryQAIX5 c=1 sm=1 tr=0 ts=6a02c6c7
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=PktQUFpngk8bp4KwMBsA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-GUID: B6dnkmnWxy2EQg2uAF8glNidlGTVlMce
X-Proofpoint-ORIG-GUID: B6dnkmnWxy2EQg2uAF8glNidlGTVlMce
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 920D240002
X-Stat-Signature: s5xuzocfgsfo7y6h8ya7gaucpfwgmbyf
X-HE-Tag: 1778566857-340721
X-HE-Meta: U2FsdGVkX1862tTuSz2RhYQQlfxyNm/IQR26gd38VkSeQnQPX28xRq8XQRgoxTWl/2a3ZqLydVCY2Qkga0qWHEQLSkgqlmusX2Jouo+52MG6JYyMfu8lJsaO1tmKzheR2qP6W8VwvDytu3K2U6K9Ge2qn/hBcNyrui8DzR0pr1o2Q71n8uCZK1bIAyHfNkXHdLAkKSi/iml6geiJZlLVqyq3YdP3JjJAKQZYhrgukXbj6dENhqnWBNATeXOJVzjpnxTPBw+aeysJXPR/Isi0Qv7hpZvCz5VC59rs/hP5a4H1PGaaUnsc3YumhA+dLrdY6cPgneQOspiqPO1hekA1jx6UujOERliNq4qH+GZ4IgR4lcHl/DzF9kp4BKT29Y0zP88DCPLHqjvpmC0/vk/QGOTeE1F9QX6+O6eXPoUOq3amncLHKE4BL/zIY0trYi4NenGIVfA0c2s/fmMe/Rjh2eY+MXFvPszixNW8tZiO5b/yTUtfb2FlWrVUo7SCbeklMRNZcTZo4oEBSIsolN3jdbBEc5qpx3ZTTtRIhHvt4Yv6yDU9+mdD1kGXseIMKIBKyikv5LcZ/LZFY8mm5p6pB3P2K3GqYbviLkwD4HTYtjiGrqFcx6LQT2wAGkMMjsfgetoCPc8NDADx88eYX7HojSH+edTHy+3uhdAegY7OYU+cMtFuQeNMx2mFAIhNZ63Aya++5AxqfB6DKgnzIwi3mE4Z+n7ch9VyF83q0U39DTi9WoRQu2PliwThwenkEn+MJgV0yzFt84amZaItbrdZW1ns6cMbPMymqMxqnm9CZTxaR3WEuNQeof78cGE56L2jF6DMpG2I2OoHAFHle0osP+P6twzO4mOhHzKra5bowet0C/8lnAHtYUiGnn3q0iuMm3ogWf50XSuSTuZivonLxL1LFStumd3/OhD0NnkwvbUVYHC9eHo7wmXwTrPON5l0s43eBqpxWEIg5TYPMKM
 0dVL588y
 nz1V071F5DOZWW+Nt8mYeNTvqfM8SrKLjT8DLnImGPbVnw98F6j8yh8safyAa0AusqHRaLZmUva35KofWHO9F93s4TQkb0nTiqSJvPaXxccja84iIG3Cu41WZBjr5F4fuNQTdo+lP2HUHOTr4wEZABEu3fgNivoRLgytujFogORgzqPybv26ppNiTj9RKKrVzWP+IdPJXUQ97YkZ9VnHwOXN5eYmDHhmgDj133ViwjDq+kRt8PlOPs+xgiOrEqsILeRQCn2FwwKVtamvTr6c0AOS9qNf7bIyj+LLCjkXXZwIj3cM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

Cgroup_psi() now includes a condition, and checks against whether
the cgroup is the root cgroup to decide whether to use psi_system
instead of cgrp->psi. This is mostly because the default hierarchy
does not have any psi group attached. So we make psi_system as
its psi group, and remove the if condition in cgroup_psi().

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 include/linux/psi.h    | 2 +-
 kernel/cgroup/cgroup.c | 3 +++
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/include/linux/psi.h b/include/linux/psi.h
index e0745873e3f2..8f2db511d051 100644
--- a/include/linux/psi.h
+++ b/include/linux/psi.h
@@ -34,7 +34,7 @@ __poll_t psi_trigger_poll(void **trigger_ptr, struct file *file,
 #ifdef CONFIG_CGROUPS
 static inline struct psi_group *cgroup_psi(struct cgroup *cgrp)
 {
-	return cgroup_ino(cgrp) == 1 ? &psi_system : cgrp->psi;
+	return cgrp->psi;
 }
 
 int psi_cgroup_alloc(struct cgroup *cgrp);
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 43adc96c7f1a..357c68662d18 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -178,6 +178,9 @@ static DEFINE_PER_CPU(struct cgroup_rstat_base_cpu, root_rstat_base_cpu);
 /* the default hierarchy */
 struct cgroup_root cgrp_dfl_root = {
 	.cgrp.self.rstat_cpu = &root_rstat_cpu,
+#ifdef CONFIG_PSI
+	.cgrp.psi = &psi_system,
+#endif
 	.cgrp.rstat_base_cpu = &root_rstat_base_cpu,
 };
 EXPORT_SYMBOL_GPL(cgrp_dfl_root);

-- 
2.52.0


