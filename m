Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2DEF6CD484E
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:20:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 97C136B0093; Tue, 12 May 2026 02:20:43 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 953976B0095; Tue, 12 May 2026 02:20:43 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 869EE6B0096; Tue, 12 May 2026 02:20:43 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 764656B0093
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:43 -0400 (EDT)
Received: from smtpin27.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 46D701403F1
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:43 +0000 (UTC)
X-FDA: 84757769166.27.D6DC678
Received: from outbound.ci.icloud.com (ci-2006j-snip4-6.eps.apple.com [57.103.90.227])
	by imf23.hostedemail.com (Postfix) with ESMTP id 394B6140009
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:41 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=nqSKptPk;
	spf=pass (imf23.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.90.227 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566841;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=jBrMrf8hMktELWdbsosIy/gP1NfZvzoho6CS5ELcmAA=;
	b=qUJDfwZz9gfaBdcyUUkf/IDFirEuL9WbqXsNNsMA4XEdzEmlcAoCG1VDGtWsOKGR+cLczZ
	mkNV/uOqvb39o9zxWRs55Noxiv+ignIbGp07vb2dDYB/gGvdNKDpt1OwxFut/PFQeGWO1f
	BWaXe75nrYlwVChA5/qFTD5WxrRvQgE=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=nqSKptPk;
	spf=pass (imf23.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.90.227 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566841; a=rsa-sha256;
	cv=none;
	b=qnH+LKfX6r6Xzyr+UB/BdSdgcMISF0+Rzx9ydxpybg4cjQsvxYjbfMGWnjdtvqvYTQ9xqL
	zlKR1UAvryAafdn5LPaIh/LMz4rH05W1G840fTH6Amo7s2m01Lss8bYP/OAJ3z/o3r0wV/
	TQLJFgptAfMBeUzbNIpc2OUD86pZba4=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id C971E1800145;
	Tue, 12 May 2026 06:20:35 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFEseX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566840; x=1781158840; bh=jBrMrf8hMktELWdbsosIy/gP1NfZvzoho6CS5ELcmAA=; h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:To:x-icloud-hme; b=nqSKptPkZhXlFKhIXZUyEIegTK+C2OsHiT/+GTkHpNcv5W6BCkv+iQ/zGkQOWt4RCZVJk+Orx4uETUusdtVi7IPGfvVcB9hEgH/O4P5GeaqfavSAN7Ze5/FGJMccDYXDBHP1C5t5muzPLcu5UC93BhZRgTrbfHBLJ3gMN4rKIMZgvJM8aU6RvDeLqC8xs9zl0l+Kvyu6+SuXmkplw0Ys3BmXcDxshqffezgjiZteKVpilLJ+wmJqJwcFqwCChOcwoFLKJXmDdCM1HkKxV/aEPrf3TJSt6Ee1Xhn3knKZz4NQrtG3PXi7mhvnIHhlG3lDMfQlfCwKjO/2ywYIneOJRA==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id 823941800163;
	Tue, 12 May 2026 06:20:27 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Date: Tue, 12 May 2026 14:19:59 +0800
Subject: [PATCH 3/6] psi: use prefetch to preread the parent groupc
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260512-psi_impr-v1-3-2b7f10fdfad5@tencent.com>
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=1563;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=+JcKsdtCurE9VHRwxuJWG/dD3Hek1DjyyYdhbiDrT/g=;
 b=1kCJZGZ3wESDhZA3qYvhWlcaaEd8GY1Dqwzu5eDcX3sjMZmjp9vbuShOztlWnK6SiqPpyK+ox
 BE2osQ8fjgaAhGJcOhyngFdGGntxSRkArR1ugoO+3+/29y75WgKbhLy
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Proofpoint-ORIG-GUID: TAXgD_ERG73VAJ-rZk6gIBJZTM7Spttj
X-Authority-Info-Out: v=2.4 cv=U6mfzOru c=1 sm=1 tr=0 ts=6a02c6b6
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=Pzb0aO4xvM8uoPzCJ9cA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfXxa7iA0pwiHf6
 cecYf2NWLuZ4bTxf3ydbN4Nes77CXyip6yklmRkmDJhHA3x+Vmgkq/VJJ//pbUq8WPwfz3VFsxn
 grYkb+mM9ebDv7n/jMfYfrWD6+YCbBNJlvPUOOmqlC3gKnvA0cPJKYFnj5/4Uj8eitZhlCIlzrb
 YlNoksKPiVZJgT/hYCD0iKpcpoTvMj4yfUJjDYQx5fwD/W8OYm++M9FhaVcvPp1DYT600vsjCAB
 jqaZr2Wa+npjxAO4yI6NRFfO/WHehzNOe3wDC6JX2YVdYaUlV+aW6vlGNGKddZWnd8Ff2CCtxpJ
 q22Cn+obpwVbcGJNxnEnc0/BhaGz12efhrsuaa6ubyIyZS48riR49cPNE1OsCk=
X-Proofpoint-GUID: TAXgD_ERG73VAJ-rZk6gIBJZTM7Spttj
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 394B6140009
X-Stat-Signature: fhhke4jfzs9r4fh46x7875qkxt4d87g3
X-HE-Tag: 1778566841-501811
X-HE-Meta: U2FsdGVkX1+lEC5OtjsLzBio5p3ar1m1ZCao9+sg8ftTdHes7zplxVRKAmwl613rxuztrsR4LHG10LPUUZIXylDS4TYQ3aTT5cFlm6wkwCPYsWxfgCeoNsE46Zhk5adbnYxjtAN9iWJZTTMo0CvI5oxj+hOCzf9egutkhVF0jbpcid5P26AYfXIgthcTvkynLIv65ayFTpoBYbo1e+3cCqX2dO857qSFKbJ8M6tnQEZVjW9BQZl5bNV+gw5npwODG6QjNByffHuEcbhECtl5UrenfNfNmVaZXaSSU6hj4pxuJJ2hfaVHjZ2ZBUROYpMP6F5c0vYD5aqjVJqzv6F5ZA3yDhWJTbG1VWeYgSnP0BacKVk1fgN1f8GZ80D/04iu5Mx3xMDtg02e9fxQ1/LqV8xv6ypotuTKYnnpY8fyCQuD+Cb01FcjQWmFtM9g/f6AYQqYq61ObfBHXzRzbYedn5xzVyfenvOQp1+1s3Fwe/76cMYc0+qlwvw0zRPrZaAu5I0kv1PcPU7rsQBTvQGNJdJXv/gsOcn9aegDoJProCER/LuhVe4cxZl6KS8cGCx++McYdbustY50bPFIcHP2C1FN0EFkRYvGyv7M5gbn1oZPsgFSlL4t+1U6M3F4X4qxs5iONMRnt4s6rIWQivD5JVlhjhwEVCwGz89dwuvvAKfnYRe+qBnfsRYa0WudCwUueFlM0/u1f0BVBQ0DI7g+ORzsmLIYmpTBaTUG7IA141U5OOJ016bjSk3fsy5h8iHIhRl8eNEvxDYGYzxNixTN92PRtzr/fE3gJN/F/SjwAV2T+kRRmap/0xUMUA83s4Fp4K72WWrQBmUrlqS5bmUKrfEDS0mpwYcLsJjNt7ka77AaWw4UQb/U1JUtrOevFwc20pbP5A83Km2uaHT/0YzvJ689uDUoi1Id9A65giboEeSUBHgBlP9lsdYXmlv+hFjAin16keZwQS52S0nU18t
 rq1Ep3Ur
 eQGGTjYeVPuZjRHsN74bRqir6jZzab06UcANMXk1qeHYpVcACw8GFspdycRouah/M++k9LF+t40gVpyWu0FspOH2yX+ehTfnt5sih34pwWaxmhK1Oh9p6HwoHpx1IhYk2sFJLovOrXsoTDIPnY4+5oflHMyared9HbgrouQTHBMxUU8vQGTNSscO4IaOyFHjM06thEbFVxU0T1jNStIH8lBBwDF4+9qZqL2uoeabkqrvWUbAA4cq93SO4h77h6hZUvxMjOxCTe/iuL/cUx63x2p7HL/m/YuQTYL0oL5v6JGqU1wM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Luka Bai <lukabai@tencent.com>

When doing psi_group_change, we always iterate all the cgroups from
the child all the way up to the root cgroup. They are all double link
list connected so it's hard for the CPU to prefetch this parent. So
we tried to add a prefetch for the parent groupc, and it has quite some
benefits for the final result.

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
 kernel/sched/psi.c | 11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

diff --git a/kernel/sched/psi.c b/kernel/sched/psi.c
index 7374c05a5751..9b7a85d1bc28 100644
--- a/kernel/sched/psi.c
+++ b/kernel/sched/psi.c
@@ -793,6 +793,15 @@ static void record_times(struct psi_group_cpu *groupc, u64 now)
 #define for_each_group(iter, group) \
 	for (typeof(group) iter = group; iter; iter = iter->parent)
 
+static inline struct psi_group_cpu *prefetch_and_get_groupc(struct psi_group *group, int cpu)
+{
+	struct psi_group_cpu *groupc = per_cpu_ptr(group->pcpu, cpu);
+
+	if (group->parent)
+		prefetchw(per_cpu_ptr(group->parent->pcpu, cpu));
+	return groupc;
+}
+
 static void psi_group_change(struct psi_group *group, int cpu,
 			     unsigned int clear, unsigned int set,
 			     u64 now, bool wake_clock, bool curr_in_memstall)
@@ -802,7 +811,7 @@ static void psi_group_change(struct psi_group *group, int cpu,
 	u32 state_mask;
 
 	lockdep_assert_rq_held(cpu_rq(cpu));
-	groupc = per_cpu_ptr(group->pcpu, cpu);
+	groupc = prefetch_and_get_groupc(group, cpu);
 
 	/*
 	 * Start with TSK_ONCPU, which doesn't have a corresponding

-- 
2.52.0


