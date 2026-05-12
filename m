Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2E271CD4851
	for <linux-mm@archiver.kernel.org>; Tue, 12 May 2026 06:20:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4E7EA6B0088; Tue, 12 May 2026 02:20:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 497CD6B008A; Tue, 12 May 2026 02:20:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3869F6B008C; Tue, 12 May 2026 02:20:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 24F3D6B0088
	for <linux-mm@kvack.org>; Tue, 12 May 2026 02:20:17 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id C9A921C02A6
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:16 +0000 (UTC)
X-FDA: 84757768032.16.5384C8B
Received: from outbound.ci.icloud.com (ci-2005d-snip4-11.eps.apple.com [57.103.89.171])
	by imf28.hostedemail.com (Postfix) with ESMTP id D0922C000B
	for <linux-mm@kvack.org>; Tue, 12 May 2026 06:20:14 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=KABNQ6Np;
	spf=pass (imf28.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.89.171 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778566814;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=5IsHEhVfaI6bVZ7tmEfuZb+RHPYOBLYDdITx1t1qzII=;
	b=JNOAEE+gIKDeK7uTYe/F3lJLNP7TuZyfV4r/HKUIwVbqoBBkytVgaB9fFPeIGHQ4lFlBK1
	z913raPVOhmme8QxHTCstyPZqbozym4kGbRf/fDmS6Dek9JMmBbNGmHaDw7+0HmvnjEX44
	wjUSIiRK75TfuUAbV3G7cqBNQvP7b7Y=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=icloud.com header.s=1a1hai header.b=KABNQ6Np;
	spf=pass (imf28.hostedemail.com: domain of lukafocus@icloud.com designates 57.103.89.171 as permitted sender) smtp.mailfrom=lukafocus@icloud.com;
	dmarc=pass (policy=quarantine) header.from=icloud.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778566814; a=rsa-sha256;
	cv=none;
	b=ORu34Dd4MnENe8HL+JLgd2UueWseBJrXbK6rGXm4q3GNZ7nx+xi8zt7oSs0pZImZ4PZc21
	iHWCQeBmQJAd2GFpo63wjwW22rJj0nGpbpaPbQz6VSRn62QimPh/J1ZDm/RCHo5ASmJknP
	Q/EcNVJacTQ0bTcQtN+Buceo9UveMag=
Received: from outbound.ci.icloud.com (unknown [127.0.0.2])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPS id 166D71800100;
	Tue, 12 May 2026 06:20:10 +0000 (UTC)
X-ICL-Out-Info: HUtFAUMEWwJACUgBTUQeDx5WFlZNRAJCTQhJB0MFXwReC0sKQw5eEhVdRV8YXApUH1oNQC1eCF4fTBwdDlgGEhZdRV8YXApUH1oNQC1eCF4fTBwdDlgGEgJaRQFbFwNXHFZFXBhDCV0FVxwdDl5FWxNVF0YJGQhdHRkIRx8KMANCDlYDQwdFAC0ZHFdQXgheH0wcHQ5YBhIdUBwOUQVbAEYJTQJfGhtBGWYRXh1FRkRBFEgeX1VcVEEJHlcLVg8HME0dXQ5SBUZeWhdeUxcfSwBcRVoOWwRHFA==
Dkim-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=icloud.com; s=1a1hai; t=1778566814; x=1781158814; bh=5IsHEhVfaI6bVZ7tmEfuZb+RHPYOBLYDdITx1t1qzII=; h=From:Subject:Date:Message-Id:MIME-Version:Content-Type:To:x-icloud-hme; b=KABNQ6NpOhMCpupldAmoU110TcV3li+jHP2lIwPbGjiIPnoQV00fEse37jYGRF+aW2bCcjQAjH0sJHgOmpZK2R3sgKX/mE5LL8ep3HnYXBJb5wxZcunfPC+nvZwCFMcHuRxglZgM41/JVk7eTolP0qh1wFLRD/SQLkSmoA9sJ5vXuQcVMV/qfMgVM0dDHMhPJhXzYVRBznpvqb9BNnua2XFhfZNFPOyhIEtdon2ltwwYxuilqoSm2rBYi7Yq0N/keQg65+Svxv31e4zR+dr+PNmX3yAS6VR/qLm1GtIs+37vi2zhk0okey8KxS/Kk8W2rRMyZh3kFhi30JXvOop/tA==
Received: from [127.0.0.1] (unknown [17.57.156.36])
	by p00-icloudmta-asmtp-us-central-1k-100-percent-4 (Postfix) with ESMTPSA id B82D61800103;
	Tue, 12 May 2026 06:20:02 +0000 (UTC)
From: Luka Bai <lukafocus@icloud.com>
Subject: [PATCH 0/6] psi: slightly improve performance of psi
Date: Tue, 12 May 2026 14:19:56 +0800
Message-Id: <20260512-psi_impr-v1-0-2b7f10fdfad5@tencent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/22NwQ6CMBAFf4Xs2ZqWClJO/ochBssia0Jp2ko0p
 P9ui1ePk8ybt4FHR+ihLTZwuJKnxSQQhwL01JsHMhoSQ8nLmleiZNbTjWbr2FidZC+UGqUaIOn
 W4UjvPXXtfuxf9yfqkPfZmMiHxX32r1Vk7092FYwzcVY11lJVTdNfAhqNJhz1MkMXY/wCJUdiw
 LQAAAA=
X-Change-ID: 20260512-psi_impr-f543a199f39d
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
X-Developer-Signature: v=1; a=ed25519-sha256; t=1778566802; l=3066;
 i=lukabai@tencent.com; s=20260501; h=from:subject:message-id;
 bh=ci4WjXNg/xa1ziA/Xx2xCDkI467Kw3pR1atl99yWTyk=;
 b=4mOUTIgTAH/zXfT/d+n0G3x2kWmcSCfHUmXs/JwXmnUvayovFnyDuk393TPIzJTzzLG1qOAmT
 iWNgeKkd7CDCUKnYdahnZJq1fW4EyYLEkrLQArH9XBLyQV0dAe+brl7
X-Developer-Key: i=lukabai@tencent.com; a=ed25519;
 pk=KeaVteSWd00GIAjFyWZnuFsKAKixjga1ZkLMcI66nPM=
X-Authority-Info-Out: v=2.4 cv=RM6+3oi+ c=1 sm=1 tr=0 ts=6a02c69c
 cx=c_apl:c_pps:t_out a=2G65uMN5HjSv0sBfM2Yj2w==:117
 a=2G65uMN5HjSv0sBfM2Yj2w==:17 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10
 a=x7bEGLp0ZPQA:10 a=UaoJkeuwEpQA:10 a=VkNPw1HP01LnGYTKEx00:22
 a=GvQkQWPkAAAA:8 a=LkPULGn0saSIAVzmwMwA:9 a=QEXdDO2ut3YA:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTEyMDA2MCBTYWx0ZWRfX2OG75N2wOc4y
 mc7l5eN1znKUyodZ6gefFtOIGmR/xasVao9Dm6cA+1XFc2WXRqnaHtMSoTvfTEolU3f+LYILzcL
 gHYlxtU7swPdIIZtlUhOSzn0ar59VnrPg8pjaISkZ/LgG1y0gA+ajDvjVjV4lcNM63X/dT9x8yB
 7rvN/Y/XeWxYCtUkaPXgmQehWHUMevkkgR2AuuF+zd3kQM7wD+zyZP6/Vfk/6o27pD0xyzeS47Y
 StokzTkWrOvXRxzR4gto9IVvzxJ47e0wk5U+1gzAWT2b8PIRAad4iKRQiVhYTQPW109K96CgNqi
 mCxsrqmU0Qnpby798R9y+iyAuyZLHPDO2E8EZGlMdidqAkbchIjCW7rEyy8mXA=
X-Proofpoint-ORIG-GUID: TMG7ZIqH4sJCib-B3Djn0w9JZzBlrPNS
X-Proofpoint-GUID: TMG7ZIqH4sJCib-B3Djn0w9JZzBlrPNS
X-Stat-Signature: fd1n3yihjxpdwdghr74en41rxppbi9ue
X-Rspamd-Queue-Id: D0922C000B
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-HE-Tag: 1778566814-191240
X-HE-Meta: U2FsdGVkX1+IDWMm3Lk1IzQjMzr56Mwmu6+4lA2Q4HBh93PeIbxYysMB3xlxeEzIz2hqE+0e2bzCkRFcij+GRYngAEJBhsqHUV40edMMIN5UVo6h3UKCu/2HTqmWoaRdTwh9SpQiKzpL4BB6eqaj/AaOWSJE6ZfyUIlRPhOZq5oILJ1PxCec4J+uj1EC0ZgO2WFAKC2yn+5VzYd9ekXEHRWx7ddAdZAgNLjFvrVQn+zW+5/QPuYxFSgTu0igdoWgA/RdIsBp5GchjfU2u4jydv/OGBGPk+/SnySqodO9KbgfNBF2lgZEOk9EnSoA43VL2p19k048+mHHwi6GwL0Bjy6D2LytpggRfQTMLRU/0GgvEIs+rn7f1sRgoVk/dr+JSCBSFaqKGc67OeEY/tW/brPtTuqC8VHvqK5D6NemOniDPlX2TG1zCdLwr+9nfOx1Q4wgelSc198B6VX2OANpRvvdl81B1Ifu88hAAbPjwmmH1oRnFPAnfrcbwx36A19EYLSZ2CFqQye6vjcbwD+0lXXxt3i99Qg7YL8/lLOUnDw7Hmudd5X+rPIC9CjLheerMPqCsxPB4xOjf7cGdv1a7S/ZH6yFFqin3zpE2YVVB/HCKnKMo5z9rvapTcqPbNuzp9PoWsjuDnqd7Qj3X9HFVxgodRf9OkvwDAvMIrL6V/BdRxFlb6Ek9ncnswqX9RkuKXbwkjZfsoIDJ0owwxKOaS6rXdH/oUwqHQUGnraFWC2WwC1i+R0zF6dW8xuRVXTz9qY8ANLUy7W6dwFHQB7pnIAp1SVL0QmTs5zpfWXQC98iHm+DRln6BeK7Z89u+79ISnVLi5tFAFfcoM17UXoe187Cin2h5szss9HxXD6geDnXZDah+YLGjb0iT54yj7TgMqCgIAmJTz57NcfxfAnb2VN7WDVwuGpZkMsE+gRrNHIdzjYs9sIy76RGwmVr6GBHrgA1UgTYhNlTCTnqfAg
 MXCJDPyy
 WgaZP+i5+WVzJAUYKdRhOkU6q5EsqQD/4pOVmh8gqaDF7bhQvZ00fEtmabJlRQ+oNH2AP0FZAExanN3obq9DlLMlEX7+JsA7y7GBiA6eGUATRSgcXN+0OYR+w3FXKIGiNXGsiCtSqoHEhLNFHWByU+uNCjI/ZhGqRPPCJ4LsFLUvQnq9yQclSURJ/vB0UWc+uVN+lekkl+9Z0qJSfgAn3dtKFkTxER74gvvSc62ft3VCygQP2YxATYBh/2Cibarpvu4MTRdMXTKijeNbHTxIPOillh6qrRAcDWEuVjCojWooAtn8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

PSI is useful for resource pressure monitoring. But the callbacks are
distributed among all the common calling paths, some of which are quite
performance critical. The hottest callback like psi_group_change is
called by both psi_task_switch and psi_task_change, which are parts of
task_switch, enqueue, dequeue. So the cpu usage of psi is quite
important.

We initialized a common hackbench test using the following command:

perf record --kernel-callchains -a -g hackbench -s 512 -P -g 10 -f 30 \
        -l 1000 --pipe

In a machine setup with 8 cores, 16GB with two numa node(each node 8GB),
we saw a cpu usage of 4.3% for psi using the flame graph of the perf
data, which can make some observable influence to the actual workloads.

In this patchset, we did some improvement for the performance of hot
path, which slightly improves the performance for the psi. With a same
setup of 8 cores + 16GB, the cpu usage of psi becomes 3.4%, which has
a 20% improvement. In the future patches we may try to do more
adjustment to go further (Like add switches for different types of PSI
resources maybe).

Patch Details:
========
* Patch 1 moves the judgement of cpu_curr(cpu)->in_memstall from
  psi_group_change outside to eliminate some repeated memory access.
* Patch 2 adds a bit variable need_psi to help judge whether we need
  to do psi accouting for the cgroup. we move it and psi_flags, which
  currently only has 5 bits, close to the bitfield variable in_memstall
  together. This way they will be cacheline aligned together.
* Patch 3 adds a prefetch logic before actually accessing the parent
  cgroups, since the parent cgroups will always be accessed in the
  following step.
* Patch 4 only calls record_times when the state actually changes to
  save some uncessary accesses.
* Patch 5 adds psi_group for the root cgroup to remove the uncessary
  if condition.
* Patch 6 uses printk_deferred_once to replace the psi_bug variable
  and moves tasks[NR_RUNNING] which is most likely to happen ahead
  in the if condition.

Thanks for reading. Comments and suggestions are very welcome!

Signed-off-by: Luka Bai <lukabai@tencent.com>
---
Luka Bai (6):
      psi: move curr_in_memstall out of psi_group_change
      psi: reorganize the psi members for cacheline benifits
      psi: use prefetch to preread the parent groupc
      psi: do not call record_times when the state is not changed
      psi: add psi group for the root cgroup
      psi: remove psi_bug and moves checking of NR_RUNNING ahead.

 include/linux/psi.h       |  2 +-
 include/linux/psi_types.h | 20 +------------
 include/linux/sched.h     | 29 ++++++++++++++++---
 kernel/cgroup/cgroup.c    |  3 ++
 kernel/fork.c             | 10 +++++++
 kernel/sched/psi.c        | 71 ++++++++++++++++++++++++++++++-----------------
 6 files changed, 85 insertions(+), 50 deletions(-)
---
base-commit: 972c53e0ec3abfc6f5fe2cb503640710fb23cf95
change-id: 20260512-psi_impr-f543a199f39d

Best regards,
--  
Luka Bai <lukabai@tencent.com>


