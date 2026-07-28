Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D30B7C531D0
	for <linux-mm@archiver.kernel.org>; Tue, 28 Jul 2026 01:14:01 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9A9526B007B; Mon, 27 Jul 2026 21:14:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 95A2C6B0088; Mon, 27 Jul 2026 21:14:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 872496B008A; Mon, 27 Jul 2026 21:14:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 530246B007B
	for <linux-mm@kvack.org>; Mon, 27 Jul 2026 21:14:00 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 667BB1A0278
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:13:59 +0000 (UTC)
X-FDA: 85036413798.09.70CA69D
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf20.hostedemail.com (Postfix) with ESMTP id C169A1C0007
	for <linux-mm@kvack.org>; Tue, 28 Jul 2026 01:13:57 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BGilTH8z;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785201237;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NIXmI5Wrz5QQpJEi32OhaAP/sLdLGCY4PKg0EE41yN8=;
	b=i5xyoI1TCsZLZx2X6i73eMQHUbaMIO1apDFQt09dDlcaIlFpfssvhnUpLA+fdxgx2iQ3RY
	P8v2agBVK86IQ32z1srg6j/EROcg8a48lmZx55xWQkWnYMVKHZeW0h7NdVQu7hyMkZmW32
	m9oXz7ksMRKszygODhHvoVtTq2Pa0mI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785201237;
	b=JgoYk/aCE09+AdhAsJWfZgkrQ1zzPmoMnQhZr6ozcdQHC5FUlGgW3HYx6he7ym9kWPvPXn
	K+igKyW6nDRJkazAaH0BC5No5MHS0KZY8cXgYZTRfNgznSQ6EtJALSov1YcCYzqnG3lgOC
	aodEeiE/U2otg8vjHBF7hbjtVBXh0bo=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=BGilTH8z;
	spf=pass (imf20.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 2F020600FC;
	Tue, 28 Jul 2026 01:13:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A54C1F000E9;
	Tue, 28 Jul 2026 01:13:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1785201236;
	bh=NIXmI5Wrz5QQpJEi32OhaAP/sLdLGCY4PKg0EE41yN8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=BGilTH8z74mcP66Zopm/CHbt5aJ75n75odHbFQLxDOFWNGetS4+SiUnn4vUx0L+76
	 JVjfXfLudFZ0BA2PEXQ/0dEPXvaxLAQSig19TXbSbMnbhFB+qjo1O4AJOIBEog4qqe
	 NhzwvhxaKABySW72eumF9j3++S7m2h5rcT4wlUnE=
Date: Mon, 27 Jul 2026 18:13:55 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: pratmal@google.com
Cc: vbabka@kernel.org, david@kernel.org, sj@kernel.org, corbet@lwn.net,
 skhan@linuxfoundation.org, anshuman.khandual@arm.com, gthelen@google.com,
 surenb@google.com, mhocko@suse.com, jackmanb@google.com,
 hannes@cmpxchg.org, ziy@nvidia.com, ljs@kernel.org, liam@infradead.org,
 rppt@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
 linux-doc@vger.kernel.org, Link Lin <linkl@google.com>
Subject: Re: [PATCH v3] mm/page_reporting: Add page_reporting_delay_ms
 module parameter
Message-Id: <20260727181355.481ebbe3b56425a760583f39@linux-foundation.org>
In-Reply-To: <20260727230545.262579-1-pratmal@google.com>
References: <20260727230545.262579-1-pratmal@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: C169A1C0007
X-Stat-Signature: 3hajaigf5azcwk7tfp6j9d769s4978z8
X-Rspam-User: 
X-HE-Tag: 1785201237-86694
X-HE-Meta: U2FsdGVkX1+d2IGiN5yy93ZhoBgzGoajVURR5wm+rzgykpq8VA1RtfYlG07yAiFr2i2VALtaW+Q48GbGW4tV/yWcoMPeLfumSEVIgJMGSDPn/Ibx2AhJdCrHcoHu9ycP/sWXV1quZDZ+WyqYCUjGIqMldwOBdr5OoWKph4DxfSIZAR1P1CriAtjH5vj0w6+N6uJgXSuW8liCEktC3kdz6+XdbYOZctCqibNRjczPiZpQJnpncNy0dNhSRiXWpNtIIKSFWaHCLt7tPsLtVCzrdgehKM07lL09Z2gwVKWcFPoXvJS6VQfkjaxIFP2mz7SYl4qc//d4BSgLJXhkn2eGXP4jLgx19z60xua6v0mDTDK9vBugpW9B1Vq/mQ1zfUkSE6l4PCLpKH6IoxpF+Q2SbtqLcw7+UiTLzjbp3GGllrWMGTrDpCpf1bfflPFEPPznryYLqWa2R3SSADlYA+lnHhPQMTkxnxb4TRCWj9JOQSOQXbCA+UDsjZuChj7v/ETu5D9caX2d6GuYn3frl3CGmRlXPx0rcegSPXBtqvh56CXtxfBQ36BTdqItLb+Npomcl/Z3w/L+5KmZO9LOeW1sJnKVBce3f+RLUclxbvBDJC4DcvBdZA6nLgsb+KrCwuY2YdQoojrbADVzhsBxkKIrG8Xaxg+RqdbSzTL2lI7A7wyyDY9ssfeRn2hY3hwNSa7A6Ns8S1EKpU/xZIrVlysAL8khsx349Z8JN8DliCJkas0eweYKNqYQPmJ4EI7Tgm9GB44DmUqpHfxmBqL3JzcUQz/fw628+WtSGmHby1DRCk8vO6OyqRONKtOHM+H/zZY8DKrCse2kxIrS4plilNoqTZ/djCaPpcuFGt7JY1mQccJP/TmhEvyK1neJs8uMzJWr1k9bh4D3QEVQBO+bVYTduMqX038Pstj5e8J111bW1kaxnnEhymdEqPJ2e5QAJF4ndv1k20WEHkC+0AWRijK
 8nrkr+hf
 C3DobXnr1UB9uYCXkN7hytpY5gtP7w3vlxtToM9NzIFHIy0eqW6cL6nnuIsivPy7kZGYw/Ml1iqXnQhXVihE9la+QkOGsmQ7qlPjTN1ZU3sPsGwS/HPO+dtMzRQSjshScCkj1DtG3cAcvFacFBUJ6YtdMSGSg3noHA+zRGM2zkC86A/Eo/H2bklP+mRIMtgq+mQH4Jaatp8nPTsmFvEGnDOdM3ziHhbr0E6xUwdr4iviyTuwtsFz7ty+vOHQYT4rmGQ18zR/0cAzUSqgcXsUhyl+/f9f6Ozex/qbmenwNrumaWVgWezV8+KEKNbk4Qbxb37Qv
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, 27 Jul 2026 23:05:45 +0000 pratmal@google.com wrote:

> From: Pratyush Mallick <pratmal@google.com>
> 
> Currently, the free page reporting uses a hardcoded delay of
> (2 HZ) between reporting intervals. While this is a reasonable
> default, it lacks the flexibility to adapt to varying guest workloads.
> 
> A low delay allows aggressive memory reclamation, returning unused
> pages to the host as quickly as possible. However, during spiky
> allocation/free churn, this immediate reporting can lead to a severe
> performance penalty (nested page faults) as the guest re-allocates memory
> that the host has just unmapped. In these scenarios, there is benefit
> from increasing the delay to batch free pages over a longer window,
> absorbing the churn without hypercall and re-fault overhead.
> 
> This patch exposes the delay as a module parameter:
> /sys/module/page_reporting/parameters/page_reporting_delay_ms, measured
> in milliseconds and defaults to 2000ms.

Of course we'd prefer some sort of self-tuning so the kernel
automatically avoids the situation.  But the user's expectation that
reporting occurs at a fixed frequency messes up that concept.


> diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt

lgtm.  It conflicts with Link Lin's "mm/page_reporting: use
system_freezable_wq to fix UAF during suspend".  Easy resolution:


 Documentation/admin-guide/kernel-parameters.txt |    6 ++++
 mm/page_reporting.c                             |   19 ++++++++------
 2 files changed, 17 insertions(+), 8 deletions(-)

--- a/Documentation/admin-guide/kernel-parameters.txt~mm-page_reporting-add-page_reporting_delay_ms-module-parameter
+++ a/Documentation/admin-guide/kernel-parameters.txt
@@ -4813,6 +4813,12 @@ Kernel parameters
 			Adjust the minimal page reporting order. The page
 			reporting is disabled when it exceeds MAX_PAGE_ORDER.
 
+	page_reporting.page_reporting_delay_ms=
+			[KNL] Free page reporting delay in milliseconds
+			Format: <unsigned integer>
+			Adjust the delay in milliseconds between free page
+			reporting intervals. Default is 2000 (2 seconds).
+
 	panic=		[KNL] Kernel behaviour on panic: delay <timeout>
 			timeout > 0: seconds before rebooting
 			timeout = 0: wait forever
--- a/mm/page_reporting.c~mm-page_reporting-add-page_reporting_delay_ms-module-parameter
+++ a/mm/page_reporting.c
@@ -48,7 +48,11 @@ MODULE_PARM_DESC(page_reporting_order, "
  */
 EXPORT_SYMBOL_GPL(page_reporting_order);
 
-#define PAGE_REPORTING_DELAY	(2 * HZ)
+static unsigned int page_reporting_delay_ms = 2 * MSEC_PER_SEC;
+module_param(page_reporting_delay_ms, uint, 0644);
+MODULE_PARM_DESC(page_reporting_delay_ms,
+		 "Set page reporting delay in milliseconds");
+
 static struct page_reporting_dev_info __rcu *pr_dev_info __read_mostly;
 
 enum {
@@ -77,12 +81,11 @@ __page_reporting_request(struct page_rep
 		return;
 
 	/*
-	 * Delay the start of work to allow a sizable queue to build. For
-	 * now we are limiting this to running no more than once every
-	 * couple of seconds.
+	 * Delay the start of work to allow a sizable queue to build.
+	 * We limit this based on page_reporting_delay_ms.
 	 */
 	queue_delayed_work(system_freezable_wq, &prdev->work,
-			   PAGE_REPORTING_DELAY);
+			   msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 /* notify prdev of free page reporting request */
@@ -337,13 +340,13 @@ static void page_reporting_process(struc
 err_out:
 	/*
 	 * If the state has reverted back to requested then there may be
-	 * additional pages to be processed. We will defer for 2s to allow
-	 * more pages to accumulate.
+	 * additional pages to be processed. We will defer by
+	 * page_reporting_delay_ms to allow more pages to accumulate.
 	 */
 	state = atomic_cmpxchg(&prdev->state, state, PAGE_REPORTING_IDLE);
 	if (state == PAGE_REPORTING_REQUESTED)
 		queue_delayed_work(system_freezable_wq, &prdev->work,
-				   PAGE_REPORTING_DELAY);
+				   msecs_to_jiffies(page_reporting_delay_ms));
 }
 
 static DEFINE_MUTEX(page_reporting_mutex);
_


