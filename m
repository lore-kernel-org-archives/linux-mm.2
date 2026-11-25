Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D59A4606A329
	for <linux-mm@archiver.kernel.org>; Wed, 25 Nov 2026 21:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=FlU8mmj0
Received: by kanga.kvack.org (Postfix)
	id D95EC6B0AD5; Wed, 25 Nov 2026 16:38:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D6D386B0AD7; Wed, 25 Nov 2026 16:38:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C831A6B0AD8; Wed, 25 Nov 2026 16:38:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 974216B0AD5
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 16:38:54 -0500 (EST)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 214BEC0148
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:54 +0000 (UTC)
X-FDA: 85474956588.01.7192BF0
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 6C6FC14000F
	for <linux-mm@kvack.org>; Wed, 25 Nov 2026 21:38:52 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlU8mmj0;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795642732;
	b=1mizx5SdiFWJIBIPMPNHa+uZeC4+wZlVs1X0SPo1FxTKIdatIttJC6cr9UZvexCRv/ma5n
	UGi6KE7yj5HDoYLtzRD6y80xJ6v7q7xpWGiTqGTH0Vb8pJTXVhausnyUcKzHb83nCH/N+a
	ZLfyRs7bzMquQCprQeZdUQAmHWNBgoM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795642732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ByO1Pw16aQvedrcgFe2HrJirDf0exfH7Ey8rwMSwazA=;
	b=knzVo0NwlBlXMQKzGMRiwfU1fNqmAx2Towi+uC7npCky4KrT631i+jWokX7tmaOgfDdOWA
	KhSTYDN3FcX+JmrD1+zqyIu5HgMwdRVpu9VaAu/mYk7gKEn/VMIpVbKYsgAhQL8dO5aNx+
	zQh2d9mda2apBikDhpdpwMrx01/N7Tk=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=FlU8mmj0;
	spf=pass (imf26.hostedemail.com: domain of harry@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=harry@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id D556E60230;
	Wed, 25 Nov 2026 21:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D1B1F000CF;
	Wed, 25 Nov 2026 21:38:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795642731;
	bh=ByO1Pw16aQvedrcgFe2HrJirDf0exfH7Ey8rwMSwazA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=FlU8mmj063INtxbA61Kmn9BCIjFoO2qoXtDLU02uGNjLyL7N+54YBlL8RxKhJklsT
	 BaS06QObcBGTEGrKXHSLbHlxAwxRtqpgfCQ8ih92lrA3bC4Y3zryTSCJoyPP3/1LBf
	 fR4uoV8HaWN9R+DzUryOg0VSZpL5HeP/sQ9cfHHqxnRl/DRse1iSz1p5WNs3oIdpEG
	 g14ZTdv+6oB3XCmo45jN594zRelczIARhGk8sC1n9OtRH8UrfBRQpHOBsWHvBJoK4E
	 xdG4ua9i9jsaTVyQbyLRmyr9L9S4ZWlDlCsWopErNsBDYVQizk39Jc8fRKsh5IIvNI
	 c0EmSdoTtMFgw==
From: "Harry Yoo (Meta)" <harry@kernel.org>
Date: Wed, 25 Nov 2026 21:37:07 +0000
Subject: [PATCH slab/for-next v2 06/14] kernel/fork: specify
 SLAB_MAY_ACCOUNT for thread_stack cache
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-6-7c680f02a734@kernel.org>
References: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
In-Reply-To: <20261125-memalloc-prof-dont-waste-slabobj-ext-metadata-v2-0-7c680f02a734@kernel.org>
To: Vlastimil Babka <vbabka@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Shakeel Butt <shakeel.butt@linux.dev>, 
 Roman Gushchin <roman.gushchin@linux.dev>
Cc: Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>, 
 David Rientjes <rientjes@google.com>, Muchun Song <muchun.song@linux.dev>, 
 Hao Ge <hao.ge@linux.dev>, Pedro Falcato <pfalcato@suse.de>, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com, 
 "Harry Yoo (Meta)" <harry@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Alice Ryhl <aliceryhl@google.com>, 
 Andrew Ballance <andrewjballance@gmail.com>, 
 Matthew Wilcox <willy@infradead.org>, linux-fsdevel@vger.kernel.org, 
 Alexander Viro <viro@zeniv.linux.org.uk>, 
 Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>, 
 "David S. Miller" <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>, 
 Sebastian Andrzej Siewior <bigeasy@linutronix.de>, 
 Jiayuan Chen <jiayuan.chen@linux.dev>, netdev@vger.kernel.org, 
 Kees Cook <kees@kernel.org>, David Hildenbrand <david@kernel.org>, 
 Lorenzo Stoakes <ljs@kernel.org>, Catalin Marinas <catalin.marinas@arm.com>, 
 Will Deacon <will@kernel.org>, Mark Rutland <mark.rutland@arm.com>, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 Michael Ellerman <mpe@ellerman.id.au>, Nicholas Piggin <npiggin@gmail.com>, 
 Robin Murphy <robin.murphy@arm.com>, "Joerg Roedel (AMD)" <joro@8bytes.org>, 
 Amir Goldstein <amir73il@gmail.com>, 
 Casey Schaufler <casey@schaufler-ca.com>, Paul Moore <paul@paul-moore.com>, 
 James Morris <jmorris@namei.org>, "Serge E. Hallyn" <serge@hallyn.com>, 
 linux-security-module@vger.kernel.org, Richard Weinberger <richard@nod.at>, 
 Anton Ivanov <anton.ivanov@cambridgegreys.com>, 
 Johannes Berg <johannes@sipsolutions.net>, 
 Eric Dumazet <edumazet@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Michal Hocko <mhocko@suse.com>, Ingo Molnar <mingo@redhat.com>, 
 Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>
X-Mailer: b4 0.16.0
X-Rspam-User:
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 6C6FC14000F
X-Stat-Signature: adz86eya6n19f4b9nrqzks8g9r8ms6cy
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795642732-288215
X-HE-Meta: U2FsdGVkX18v0uPAp3il5gWZ2G+VoDUfcH5mMsSEGD7yFx89xLR695WHbHJ7JW0Fno1oWDelPW8pZOR6trK+WfzLwc19P1FTwpQwsK7cAsrT7wn9Gzituy4VUbXFrWx3dW+HeP9BJv/lHczqgiH0CkSSVJizSlVbovZqfhrAj68rTvV997igPnYpS+QkxDM3uLoHVD+q0OVqxlQlJDmMcHUDnKOLs5yrqVVfl2kKqCFrva3bW6Kff9UfLQg1yrnyCKf/mqdTzffzFTraSWVJ2BE8qrvLO4+hmHkEXQWNa06Y0/QEbcIcZ4aRPZEyhpNN3ok/oUX6HQZuSgcGOv/+qWfZ43hQmvYv4uvlje1irzQZqt9Zuic5tHIWxJ/Mc/Az0Zh9iaKeoT1EmXRxNI2P4jDKgOHoFUvXB6RNESExUeRfITFyuQ9KNYrlSShMDtPHdfNiZhIABBaIafu68AUZRrTtQM4xVzFJt72LsOWT3TMAGwk2n33dl0gc34xAsXAIN6D65Wh3Vifnohdw83CtKxR3rwMK2LMbXi8EWOZ0N//tq2jOYS3J1A3OrjhBaULg1xCL52vZFx3bvr8eQCvdLNVx1rGyYVWsHnDyTYBNZXFgUfoJ9nOWD3vZbDXuBM6j58PX1WPANrjgTn/MIVqH2Or8RYZScGY/GcA0KcNH0esw6gjXvnVmeJvhZr0M7chctnnH90sbd+p3hS1L4+Uwtf602eaK8xqneIKkEz3IhQCW6v7KLnZqeekAr7dQX+OKYkgDZ9eaJMNFkITdqiqxNlg3GpcCZZszY5/P2C9b4u+ufSp4QVOGSO4yO+l2/KqcXPRD4xOEPxV/25DfAzucYPK+D44DahBOkhR+et7/RhDfQJQ1KdPBAXki4wlEKh05KaJsAnDivWVVwf+FMMcQCeQO2nBRRErz7epNPjNr3BTVLkPrS5blqKGbwBPzQ4f4bO0EY1Lb1bsOEp0ehvY
 WH4xN/ht
 dPtlYcEld9EOsVsuuX7fR+SnAxnf/qITdvIS+tbMT1e1ZCawFa9sNQa9JOILo+trojCFtQpVFRxprHHcaW3pOvaNRPHpp/OEgtar6W/qFJrPAfCC+EurX+9ZrUuy8S/HXtaAJSToo6pBRHALNKLZJ3xwUbWfb44gJVS4Wp6u+Ez2lDPB/cbLPbMJMopkAHDMx6MBhxqqDPcDn96CrrsvuF0Q95oJmmixAhh1gyqKAwAIK/xaRCLishXZeKPYYPuQvkiML9efylBB2dzCqS4FWDFCfKJEssFRNzWJzoECx/+DxC53+phcNzHfrvXcWCSRxqQIeM5J6v5y2GpHR5c/h4KCLoW20Xc9K7I07LGPpSYxUTDSl7sFzWnpAJaxoRUpQC+CuYyg0ub/bvfyPtkwPGYw+GAVpAJoXfTbMnvkT0JRF77cbYw4MoXWODbsL5OXQ9kjocQm7kQ/YvQ49Wqd2dC3zqv+Pe+p8SG/m4fweQk+DatWJJZ68U1bu0dhxCPESivOzGTpfs70QfNEWoJoIJK6lGPMi7Bd9IOBgEzqIZNj3yNrOGMk8Fy7POlsvhVkSuG/nRz2bQD0QfeL/la6xHnNqAY7S9OyBJS+bNIV584fKcS+zELHSMD2/hsOFHEgIKMNyt/atoKesNHIu9rmWP4iWMb1BQhawfiN1YQcat1ekVPfjEAvpAMx26A/2SxoHKjlwHrXz6MNO/wRVJqaZwbqwZw+vBNGpMRFq90t+SoqtKryF5Rq3wKJX4sdQqq+6bjTXkyRKG5bIUChIyuHZ9g17aFtz9OqoSGK/UfYU8cXpQmelM5dj/Kk2CtJjYhbK6I2TUZhrMim1eo2h0kJToG4onaKc5wEMKAJgLk2Gp4vqIydsal07t3tz0Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

When THREAD_SIZE < PAGE_SIZE, thread stacks are allocated from a slab
cache with THREADINFO_GFP, which includes __GFP_ACCOUNT. Specify
SLAB_MAY_ACCOUNT when the object may be charged to a memcg.
__GFP_ACCOUNT without SLAB_MAY_ACCOUNT will not be allowed.

Path (e.g. ppc64le, 64K pages, !VMAP_STACK): copy_process()
  -> dup_task_struct() -> alloc_thread_stack_node()
  -> kmem_cache_alloc_node(thread_stack_cache, THREADINFO_GFP)

Cc: Kees Cook <kees@kernel.org>
Cc: David Hildenbrand <david@kernel.org>
Cc: Lorenzo Stoakes <ljs@kernel.org>
Cc: "Liam R. Howlett" <liam@infradead.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Juri Lelli <juri.lelli@redhat.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ben Segall <bsegall@google.com>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Valentin Schneider <vschneid@redhat.com>
Cc: K Prateek Nayak <kprateek.nayak@amd.com>
Signed-off-by: Harry Yoo (Meta) <harry@kernel.org>
---
 kernel/fork.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/fork.c b/kernel/fork.c
index 5efceb8d58a7..d0e49a81e7cf 100644
--- a/kernel/fork.c
+++ b/kernel/fork.c
@@ -459,7 +459,8 @@ static void free_thread_stack(struct task_struct *tsk)
 void thread_stack_cache_init(void)
 {
 	thread_stack_cache = kmem_cache_create_usercopy("thread_stack",
-					THREAD_SIZE, THREAD_SIZE, 0, 0,
+					THREAD_SIZE, THREAD_SIZE,
+					SLAB_MAY_ACCOUNT, 0,
 					THREAD_SIZE, NULL);
 	BUG_ON(thread_stack_cache == NULL);
 }

-- 
2.54.0


