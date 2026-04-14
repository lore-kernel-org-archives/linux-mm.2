Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D44F6F9D0D4
	for <linux-mm@archiver.kernel.org>; Tue, 14 Apr 2026 14:24:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 36A6E6B009B; Tue, 14 Apr 2026 10:24:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 31B296B009D; Tue, 14 Apr 2026 10:24:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 207916B009E; Tue, 14 Apr 2026 10:24:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E5BF96B009B
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 10:24:13 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9762E14022E
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:13 +0000 (UTC)
X-FDA: 84657381186.16.9B08C12
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id 6F401160009
	for <linux-mm@kvack.org>; Tue, 14 Apr 2026 14:24:11 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B3N3FcF8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776176651; a=rsa-sha256;
	cv=none;
	b=YTEpckpo0rIamt32WRaSi4tLsMLJvZexz7yxf89RE4xt4IUVaSYuhADHK+vty/NRelGVsv
	VZM8PVBAYLS+q3MvmL8pj4lWe0sZvpNgvw9RiPa1CVBKotAVcnICMOnu8Yb+Dp//j4jZlR
	fLvm7MgyEVXwxBOv0Z+Fojxodjvv3Yo=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=B3N3FcF8;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf08.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776176651;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ihczfsUwf+R0hJaK4HqFgtfsj5cwfC6/zVz8WG8Wbe4=;
	b=mYpwI79parEaacLkAz1rAUhzHLqC4wiZb35ACa/Ch0kvRGHHpwCtRVEfIRQw6bIg1baX/d
	xSVqxe3VRyELrV1UjOCgrz1Eb68Mr3cXOLxgfKSlWk93HKtkeOPLuxeT3LOCJjLjv+Exgf
	z9ZT9eYEQ7VALN8hR4kH5xc7bOIldCE=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id A882E44590;
	Tue, 14 Apr 2026 14:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDC4DC2BCB0;
	Tue, 14 Apr 2026 14:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776176650;
	bh=m+QZFSoN1KHyBpdT/lFOUcMBNfMoQG8FWyZoa+3hWE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=B3N3FcF8j1cl9QhM0roD5U+FQK/bk8whCC91NDffJsKAn3I3Dw1WAuV8QnPA4vvzh
	 w/bpTNK1D8emkJd9Bi57CcDL5Dc0nOQAbp+YRFl7H9td2UAyNFQr33yAmzaEZaISQh
	 hKPvJgpgmEotVPP2ntvhnnOc9M4iI9s+NJ9X8UqgH8agfD9REyRoiyUJi2yZ8UlFPr
	 C5TokRgk3GrjlbbAj0KNvs3sMevo6jWrIPm7wcBdsUImKv9yl5q8zmJtjZTyvCTNEn
	 gByarjgJ8H6Hf84kivOVCxAd4ch3Vx0kdt6ka8iOcIR+lvPdaTS9TT7WBZh5bqmwbu
	 lG3/9vOAT1i3A==
Received: from phl-compute-01.internal (phl-compute-01.internal [10.202.2.41])
	by mailfauth.phl.internal (Postfix) with ESMTP id 2D52AF40068;
	Tue, 14 Apr 2026 10:24:09 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-01.internal (MEProxy); Tue, 14 Apr 2026 10:24:09 -0400
X-ME-Sender: <xms:CU7eabIpxTPG45onsRcikDQxMRXerezZzHYli_8nk_CTT1BhP-t9Uw>
    <xme:CU7eaWEKZA9px65WkVS8_nbZSiQhowTvJ2erLXFIEJMFZhZnTl6yrvME6v8qeN7b9
    soP1tMegTqA-Yy6BGrgcvniiS8fmqQR2UlrP4a-98LtpPM6hH_hLtU>
X-ME-Received: <xmr:CU7eaYzjRtC2l3_b1TUA5PmMEWbkR1ZOSVZ7gPb2KfkrpnlxpwcBN5wPp0XS-w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeefhedrtddtgdegudefkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpuffrtefokffrpgfnqfghnecuuegr
    ihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenucfjug
    hrpefhvfevufffkffojghfgggtgfesthekredtredtjeenucfhrhhomhepfdfmihhrhihl
    ucfuhhhuthhsvghmrghuucdlofgvthgrmddfuceokhgrsheskhgvrhhnvghlrdhorhhgqe
    enucggtffrrghtthgvrhhnpefhvdefvdevjeevhefhhfevudefudejfeduvdekheeludfh
    iefhhedujeffffeigfenucevlhhushhtvghrufhiiigvpedunecurfgrrhgrmhepmhgrih
    hlfhhrohhmpehkihhrihhllhdomhgvshhmthhprghuthhhphgvrhhsohhnrghlihhthidq
    udeiudduiedvieehhedqvdekgeeggeejvdekqdhkrghspeepkhgvrhhnvghlrdhorhhgse
    hshhhuthgvmhhovhdrnhgrmhgvpdhnsggprhgtphhtthhopeduledpmhhouggvpehsmhht
    phhouhhtpdhrtghpthhtoheprghkphhmsehlihhnuhigqdhfohhunhgurghtihhonhdroh
    hrghdprhgtphhtthhopehpvghtvghrgiesrhgvughhrghtrdgtohhmpdhrtghpthhtohep
    uggrvhhiugeskhgvrhhnvghlrdhorhhgpdhrtghpthhtoheplhhjsheskhgvrhhnvghlrd
    horhhgpdhrtghpthhtoheprhhpphhtsehkvghrnhgvlhdrohhrghdprhgtphhtthhopehs
    uhhrvghnsgesghhoohhglhgvrdgtohhmpdhrtghpthhtohepvhgsrggskhgrsehkvghrnh
    gvlhdrohhrghdprhgtphhtthhopehlihgrmhdrhhhofihlvghtthesohhrrggtlhgvrdgt
    ohhmpdhrtghpthhtohepiihihiesnhhvihguihgrrdgtohhm
X-ME-Proxy: <xmx:CU7eabjiZLALMUNh56rbUI0YOZY01Gh7ZIfSB8kVV0GuL2UFl7PB0Q>
    <xmx:CU7eadLMpGoLRW0PkjUsjA-ww25wco0zTFQ7E0mKOZ6gY9t0TO0eHg>
    <xmx:CU7eaeC4meJ0gyd_L6D8X5Fc71Mb8yuIMJ0p8iNmxm07QLi_J2ZrWQ>
    <xmx:CU7eaeQ_WXkewkruAKXcO7rZSYkx3YczRIJ6JOc54XpCC0XBsx23gg>
    <xmx:CU7eafpamlT3pfumAqUGcRCV3xHiBgfzrn2luZ8stq86Z4dwMnYNs7lw>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Apr 2026 10:24:08 -0400 (EDT)
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Peter Xu <peterx@redhat.com>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	"Liam R . Howlett" <Liam.Howlett@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	Jonathan Corbet <corbet@lwn.net>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	linux-kselftest@vger.kernel.org,
	kvm@vger.kernel.org,
	"Kiryl Shutsemau (Meta)" <kas@kernel.org>
Subject: [RFC, PATCH 07/12] sched/numa: skip scanning anonymous VM_UFFD_MINOR VMAs
Date: Tue, 14 Apr 2026 15:23:41 +0100
Message-ID: <20260414142354.1465950-8-kas@kernel.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260414142354.1465950-1-kas@kernel.org>
References: <20260414142354.1465950-1-kas@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 6F401160009
X-Stat-Signature: 5bgeiiiztiyrfpstwu4qyhkbueyqrn5g
X-Rspam-User: 
X-Rspamd-Server: rspam04
X-HE-Tag: 1776176651-624728
X-HE-Meta: U2FsdGVkX1/OJCG0cXINEcjoPwwjcvqv3IFpOI4i64NaA335d9kCcPXjUaw6PD652Y9VKav8ZsDMLxjTzIjoX2O6+UiR02qHaKvaqLCAtaJP8oiDYX5n2Hb+XoxQIWFcCRzG+vb3bHlOCk8HJqUWgy90Jij9pafB3cZof2kJJjdUxQQ8atPO4Y381oyKzOY9DJuSK+J8x86hzL5MxGY1/mY0M+j7AMQWRy48JMU8bE/wqHQezvu35Ks8rxMdBu93qBHKV+I1utKCM15VSNbcwPsJMeN4tZvFnlUFUFVoTJWT5eR289J/Jhdo8FrGk46XuHvbq3Ho7OCLsffl7ZtqINIjr8Rw6qDS2NhRK89Aj+0B1PGEB+R8yQh4iBxbRb3IyWzdbgN5g+x9ZNLcf6KdRJg863MYaNEAmBv5vXzS+x4MCvY01STaTp56jUeL3fB7j2O51yRtxPwT8d2N4RgA0Acb1+OYLmHtnE8R0AfKmHQDSt3tatP37S5oIIuO1w5AR0Ab7TEBiQEzRAKIMiZueu4QK5MqOaCV0YcKnKwghn9t4UE2oeZw9u4WjJVl6e2od+8YY793f4LdW79N5LinREKEfqnSL96ijlQQjQLbeFHNoQ+RTsfKUwFeg8+lCI211ZUdDyZk7UKe+yWt+pI1BjVABu888999UVw4zerUPWxM0PTnmj8T8qllpDZ72dyUQ9L62EZB6AoJUNYyurl8A3lDbArkg8GrGh6/Q3yp+LfZ1KcT0zfl2NV4QSxNUEbWcYsoXAGvEgZMiPOgHthOagt8hlDdT8L1d38ltMYfNZsqMkehfwuoJBn3kztSnKM3fsU6a29wIvHtqYCKzvDYCRVG70U4lnkDwUCvAloMiEv4GK41fVZmzEWJD6oJKRGPIEZqFDxcJWC0Ue0b503OUqIOh/dItTmLSl0v4spyX7C99UT1Kbles1mfydK7leuEloDbKHTPwU8gF/N7xvw
 FQxbcMtP
 xMs85Ahz51tqrp5e8AdpiZe/u1ULHqJNaUJAGKaQuPMhr4MnRpq5osQ2ewpXbTrJqtVPcXYag93vDFTdM0ZubQ4KDBjUQ88HIEYvdwoYP8wo10q8bUpFUW9IeuF0TbPAnh0wDgFfjTT0Bn5fnoukSqK2do8jnX2DfheudYdLVtVl70xQ+zZ+zXD0R8WoiceibC+ObykxbjO06B9lak9hs/bomTtGaNnI2q4vrfg2gyHbnMUWVPW6FcQzOhi5AShuNgY0ekzSXL0b5iZlFLufR81J6NSOH7qfVlGkgUNTs8HYJtaRYCzfZZHj59UfrbPNybU/Q+Nrah4VcRoTQ/Ma9IRIF4siAUGKGHVB+XzykyhFO0+dDK0aWOmhIavfOOO4bkzHmWA2AnIH4j+I7CSKCcKKZpfjuKiVr82Gt
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Avoid protnone conflict on anonymous VMAs. Shmem unaffected.
NUMA stats fed from uffd fault path instead.
Add NUMAB_SKIP_UFFD_MINOR trace reason.

Signed-off-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Assisted-by: Claude:claude-opus-4-6
---
 include/linux/sched/numa_balancing.h |  1 +
 include/trace/events/sched.h         |  3 ++-
 kernel/sched/fair.c                  | 13 +++++++++++++
 3 files changed, 16 insertions(+), 1 deletion(-)

diff --git a/include/linux/sched/numa_balancing.h b/include/linux/sched/numa_balancing.h
index 52b22c5c396d..5668074a4271 100644
--- a/include/linux/sched/numa_balancing.h
+++ b/include/linux/sched/numa_balancing.h
@@ -23,6 +23,7 @@ enum numa_vmaskip_reason {
 	NUMAB_SKIP_PID_INACTIVE,
 	NUMAB_SKIP_IGNORE_PID,
 	NUMAB_SKIP_SEQ_COMPLETED,
+	NUMAB_SKIP_UFFD_MINOR,
 };
 
 #ifdef CONFIG_NUMA_BALANCING
diff --git a/include/trace/events/sched.h b/include/trace/events/sched.h
index 7b2645b50e78..02e79b56db28 100644
--- a/include/trace/events/sched.h
+++ b/include/trace/events/sched.h
@@ -728,7 +728,8 @@ DEFINE_EVENT(sched_numa_pair_template, sched_swap_numa,
 	EM( NUMAB_SKIP_SCAN_DELAY,		"scan_delay" )	\
 	EM( NUMAB_SKIP_PID_INACTIVE,		"pid_inactive" )	\
 	EM( NUMAB_SKIP_IGNORE_PID,		"ignore_pid_inactive" )		\
-	EMe(NUMAB_SKIP_SEQ_COMPLETED,		"seq_completed" )
+	EM( NUMAB_SKIP_SEQ_COMPLETED,		"seq_completed" )	\
+	EMe(NUMAB_SKIP_UFFD_MINOR,		"uffd_minor" )
 
 /* Redefine for export. */
 #undef EM
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index ab4114712be7..57beb04562cf 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -25,6 +25,7 @@
 #include <linux/hugetlb_inline.h>
 #include <linux/jiffies.h>
 #include <linux/mm_api.h>
+#include <linux/userfaultfd_k.h>
 #include <linux/highmem.h>
 #include <linux/spinlock_api.h>
 #include <linux/cpumask_api.h>
@@ -3459,6 +3460,18 @@ static void task_numa_work(struct callback_head *work)
 			continue;
 		}
 
+		/*
+		 * Skip anonymous VMAs registered for userfaultfd minor faults.
+		 * Both NUMA balancing and uffd use protnone PTEs on anonymous
+		 * memory — let uffd own the hinting. For shmem, UFFDIO_DEACTIVATE
+		 * zaps PTEs entirely (no protnone conflict), so NUMA scanning
+		 * can proceed normally.
+		 */
+		if (vma_is_anonymous(vma) && userfaultfd_minor(vma)) {
+			trace_sched_skip_vma_numa(mm, vma, NUMAB_SKIP_UFFD_MINOR);
+			continue;
+		}
+
 		/*
 		 * Shared library pages mapped by multiple processes are not
 		 * migrated as it is expected they are cache replicated. Avoid
-- 
2.51.2


