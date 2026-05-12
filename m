Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C4A7DCD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:20:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 388986B0095; Tue, 12 May 2026 02:20:53 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 35FFC6B0096; Tue, 12 May 2026 02:20:53 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 275FE6B0098; Tue, 12 May 2026 02:20:53 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 17C406B0095
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:53 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id D61041C09D6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:52 +0000 (UTC)
X-FDA: 84757769544.10.5279871
Received: from outbound.ci.icloud.com (ci-2001g-snip4-7.eps.apple.com [57.103.91.60])
	by imf13.hostedemail.com (Postfix) with ESMTP id D8F0C20007
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:50 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ow4GRMhB;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf13.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.60 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566850;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=HFQgmeVI0oO/YyDZZt3bpmB4cnLvJvO3q2IZPwc5y8Y=;
	b=pGeWRXBUPVnyneDXCS80DuW7mhZF/7Vo2GRMgCWw0FA6XbkuGR26Tg6ZEm0pDlIIb0Za7f
	XEClGBD8+HZidPDLxXy8EspKCqpPLwbgHSenxVy27p+/hiS1Qn0aMFts5cYwbIvXGT88Ll
	/4b8RoI6s5WPF71Eyig+/wqVHqg6AhA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566850; a=rsa-sha256;
	cv=none;
	b=ozTPgO1gwOAmJk4kRgVi6njGNq8XXiPLqd4sX3dJJrdKzBZb2Rn4BQhXjYPLNjifFROiAW
	4fFj/LVNYMqH9M2YxBuZ4jw4bGsu1aQNIHGMcRgA3rVQ6EB5vCgSzKQT82hYp3JqZkvXT2
	AHS2BHqTtTDzlI4bD3NaBBSoEh8xryg=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=ow4GRMhB;
	dmarc=pass (policy=quarantine) header.from=icloud.com;
	spf=pass (imf13.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.91.60 as permitted sender) smtp.mailfrom=lukafocus@icloud.com
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id 9779B1800103;
	Tue, 12 May 2026 06:20:44 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFEweX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566850; x=1781158850; bh=HFQgmeVI0oO/YyDZZt3bpmB4cnLvJvO3q2IZPwc5y8Y=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=ow4GRMhBy3HR3saemv/Dx4xL6GdvF/TMpMEdR5eY1ONuQO7wkW4Swd4qTFXa17Aias7GbIze2IUr/eRh4l32XyiUsJzHh9pLwaprqPU+8chKFycy6NCIkfpvLsWrbYMsUZdhsqiAYCGQLLqBRi1bo8Ym0+0txhw+joxzLTguTR59M6RZ+sHVPHl/Jurf1pDXaWxfhnAQO02gvLTdZrbj16BuscOwEcc4U8yTFeDIhE7W2IqtU2RSXHvvuF+L5j01s2CJHZvNwSu4gh8mqLeXWzuDy0uXxIgTC1oOh31f3tia8kCf+bTm8FMvEyMRcPE6+wO3QjerVehpAikR4AuO5g==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id 8424B180013B;
	Tue, 12 May 2026 06:20:35 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Tue, 12 May 2026 14:20:00 +0800
Subject: [PATCH 4/6] psi: do not call record_times when the state is not
 changed
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-psi_impr-v1-4-2b7f10fdfad5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=1376;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=K3W73Ej/H0RH/u7ug92VzPA/oQvz5jykvDzJfWcXDc8=;
 b=UOPUAuG2SMAddJiUXqFia9+qZ6pYXrAI5NMq3HPcY0QsvJzfIJo2mUffCromL/WOhhHUFI1ss
 lo2PUu8RNO3C9et3pjuE+4l0GXHz36Pxes0NjKltfze7gQcrJHXY0gR
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-GUID: g9I8dGtUZgJhv2L6LpR1sKeFx3DMaVBn
X-Proofpoint-ORIG-GUID: g9I8dGtUZgJhv2L6LpR1sKeFx3DMaVBn
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfX7NXkfgr0AzlI
 BXnEsThg68asqk8eaLufSGZHZ5yc5dwqWIlcVz4z10yrJRZ0FsAfTumvp50tBpxWYyJTF5erq8u
 yNUYifqjuq8QbLxjBK2DHJIvwXcPkca0bWhjmNWxrdLBmL3nyCnTfWJcZIvO296B61gajcwNmns
 QNNda9lnhk3nlq5c16dFjQzLdXRNiziCn0v63gTkl5gICYqz5GUAD5EDa7BTjgwYR38OFdN1NOW
 Tvfny2N7FTNLj4AQXz+UZepLPnyqIubWEmjUbwQAy2Ss+/KNYSA8ScW1PyKZR/EHRXc6qcCCGzp
 +x2lzIs9iyeaqXUDF8ZmCtH155clIcvl1GoS77f/4PRHaawJNao38qQ+HeFI2c=
X-Authority-Info-Out: v=2.4 cv=JfSxbEKV c=1 sm=1 tr=0 ts=6a02c6c0
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=jPpEGkWhOON_I5X-:21 a=IkcTkHD0fZMA:10
 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=GvQkQWPkAAAA:8 a=wbxJtr-Xvdy7Wj_ENd8A:9
 a=QEXdDO2ut3YA:10
X-Rspam-User: 
X-Rspamd-Queue-Id: D8F0C20007
X-Rspamd-Server: rspam04
X-Stat-Signature: 4efythzdj6554fjy44utfyy1bpzwdhj5
X-HE-Tag: 1778566850-127746
X-HE-Meta: U2FsdGVkX18jMqVZUCNFgqkQwrG4VGjKsfrKRcSem/DNlTTKiyGoBm6QR5inSeF5B5xkbkC6dZJ52yByPNic0BKPqnKjbGXQGSO1fKP4XKBTd3pgeYkSEzGRbHoLxTl2FnNIjQ+NQjbnukyKWPOH9eUij5ghomgogEZKCm1ECVzf0evPBQOXcm2S6IvjsPxUuXl/m6whdso3fKiJQ5eQpVj/M0IsVZUuP7wrZvIsPbOIRF7D4nvieA8NijZo5OVsG5VlyftkvVckeVNauw3N/r+tXZVKtOY6qTy14muVmBoMbRJBu64hOLrCR/jYUuwlfPRhAOE0Wj0Frg+kyJiY6TyGcCzOgGgmlN1yPXms/FCS2V0QNEe4dVHPhYEvoCR4+r41I4GvmJ6B1CtGGIJMfRKe2PGIg7+KWqIaW1aj2lxpfktGN0lkxvWFlKIk9Nvqga6ouJhyA7pMc/QX7yyfvbBVDrdZ/4WYon8kynHbacB3NLJUllDo7enV/78G8Ltp4E7/QyY7l8Tvm/QANqy0odd7WCe0CM0kaC0W3QOIsz6dijRco4OIgjWhob5AiCxlLyR/JEqQOke5v0opmEpgCY/JXhgPvFjBxF2jksHg0k1g7wVKOtuufbaimX8k5AneeQE6WaPSSN+JnmnjyoQTmpGXFZ5yDK+rzdt2TlUORVSWhaptHbA5yUrsACF4Rf/ssldt51ZWhwPYf1IOKjDigOKyNVUJKCNaneac6Mj6bBQPLfo1pEcnl+bxAeLVJqHumqDSFWv/o8m7hBvbr28h3Q2aigSCVhD0mWHNYKo4ONQiUzelznJebMCmAav66/Zd0n3QHWqgo/xxiEhFM8tbjaC9KDpYQj1+33/3xmCuWPO6gqeRS2Dh+FpO4QyeyLf0pKLNWbw/Opxtr8h4VY4hGgVmecgkAKfO2L1fDx/FePBKaMBqdLT5NyuOFA22Y1pOeVknbORzTMNdUy3JZ4q
 ZzmTIMkd
 2ipMuPaEdHCMQgw1HSOEiF9ecMKtAQW2FKYg+0iE3LdlLGEhADsAGrNwjAND8HYuz863+14NPtwH8da6cU6LJlRe+59ZmuN+4dN0y3Qxffr6b5OpXyCoC8vAGZbtutJGf/1I4xvG358nTGkj6EdWkV1VBL1f5vg2abkRJQ3CwX8Lnnp8y6wOwBpUZwcBJFu2rjJ6/S5f0CNnCP8XJo6BHWxy5WnZGSTH33u/LIOumC3omnVYCMIqJguGItmiKWMR8RQqVgIb+Ny2rNhUG/XKjHoaV0Ul0jUSSTeeFbsaNCHnK0rpousXus3mZpmd8RgI1Yno6RMosebys9udx6aMkiX8Ii+wHurBZtrmL26tr30iCSjocXpwt5F2qGg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

In psi_group_change, record_times is always called no matter whether
the state_mask changes. Since it can cost some performance, we
choose to not to do it unconditionally. If the state has not changed,
we can keep the psi time unchanged.

This will not make any difference to the final result since when
we need to acquire the psi time, get_recent_times() will always
calculate the remaining time into the final result.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 kernel/sched/psi.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 9b7a85d1bc28..4c4bd134c785 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -880,9 +880,15 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	if (unlikely((state_mask & PSI_ONCPU) && curr_in_memstall))
 		state_mask |= (1 << PSI_MEM_FULL);
 
-	record_times(groupc, now);
-
-	groupc->state_mask = state_mask;
+	/*
+	 * We only need to record times when the state changes. Or
+	 * we can keep it unchanged and wait for get_recent_times()
+	 * to handle the remaining time.
+	 */
+	if (state_mask != groupc->state_mask) {
+		record_times(groupc, now);
+		groupc->state_mask = state_mask;
+	}
 
 	if (state_mask & group->rtpoll_states)
 		psi_schedule_rtpoll_work(group, 1, false);

-- 
2.52.0


