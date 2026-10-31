Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9E5F3606A321
	for <linux-mm@archiver.kernel.org>; Sat, 31 Oct 2026 04:15:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RaOzfFfL
Received: by kanga.kvack.org (Postfix)
	id 903FD6B05B1; Sat, 31 Oct 2026 00:15:08 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8D9DF6B05B2; Sat, 31 Oct 2026 00:15:08 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8166D6B05B3; Sat, 31 Oct 2026 00:15:08 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 54E396B05B1
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 00:15:08 -0400 (EDT)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B86EE804E7
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:15:07 +0000 (UTC)
X-FDA: 85381606254.28.761CA6B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf07.hostedemail.com (Postfix) with ESMTP id 1D87440002
	for <linux-mm@kvack.org>; Sat, 31 Oct 2026 04:15:05 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaOzfFfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793420106;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=3cGD2nXI1KRMoDbeVY3qmkZWqNOQZJ5tcGl5adpBOtc=;
	b=6Tncacp1XpTAFNanjv9m+oaK372sLSgSZUhuGwNmkF9q2DQ/JcvKOGJL/hIT3Pq/h/TTyy
	5Qa7v75zd3f4u+1GpgF0wWg/ujdvM9Zz4rQUReWZT1thhS/1oJmf+Ss/tFp7ofxiN2i/Zo
	iwkxVs8kdYzvqkd/KfuitfP4kC8YLOI=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RaOzfFfL;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf07.hostedemail.com: domain of kees@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=kees@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793420106;
	b=cx1qL8lRHsy6lCnqDWKuFbQfml0JZ4kl8OsCKDgra/yArR32zWD58QuGJZxsHuMxZxgOr/
	RZ8zNZzJ7tSEj9BARrZKTYUs24iCp4xgwhsHahAbZeau2l2U+KabggibjbMGI3cTjEtiav
	2y6LeT9qPQXrH6pTH18JxqCsehavNYg=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 8EBC360236;
	Sat, 31 Oct 2026 04:15:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 428101F000C1;
	Sat, 31 Oct 2026 04:15:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793420105;
	bh=3cGD2nXI1KRMoDbeVY3qmkZWqNOQZJ5tcGl5adpBOtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RaOzfFfLGzssuh+JjOKHBZYCqFiRxq3QTgt44gt8UZ1liV6gQAY4MQTHAUCDxfOuT
	 w6qmiQALxjw7NlwWzhRXKRELShPBy7H4rwzwz8UyGf9oG7WVa3uadE1C0BN724JkzK
	 DZ+vJeVC/nNjYaPcC1iIVOYsfuyUj1344RQ8diH0NBhLVcRZKjDCjKHdASpQdly8bA
	 SJXMUTzUMaY7P47tf6W/NtJCOA1nXQrUu2/Bbu4rMDoyUNzo3ewESByCgCsfk1nwrV
	 WdwQSrSSOLn4hCph4pf9WP6uDyBMZ/AIPu5OHDZ1O+FhlsGGwircODTeQ0UblVTBwp
	 jl4BXVE4yxqVw==
Date: Fri, 30 Oct 2026 21:15:05 -0700
From: Kees Cook <kees@kernel.org>
To: Chris Down <chris@chrisdown.name>
Cc: Vlastimil Babka <vbabka@kernel.org>, Harry Yoo <harry@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Hao Li <hao.li@linux.dev>, Christoph Lameter <cl@gentwo.org>,
	David Rientjes <rientjes@google.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	Marco Elver <elver@google.com>,
	GONG Ruiqi <gongruiqi@huaweicloud.com>,
	Jonathan Corbet <corbet@lwn.net>, linux-mm@kvack.org,
	linux-hardening@vger.kernel.org, linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 2/6] mm/slab: Enable SLAB_FREELIST_RANDOM by default
Message-ID: <202610302113.FB347BE5@keescook>
References: <cover.1793253633.git.chris@chrisdown.name>
 <6bdc161bd869ead04b3b9a651ef6a83882ecbea3.1793253633.git.chris@chrisdown.name>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6bdc161bd869ead04b3b9a651ef6a83882ecbea3.1793253633.git.chris@chrisdown.name>
X-Rspamd-Queue-Id: 1D87440002
X-Stat-Signature: 8zi4prxcpddhid5xms3qqcfc9sg349hm
X-Rspamd-Server: rspam04
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793420105-117228
X-HE-Meta: U2FsdGVkX1/GrjuvIDrdWnfwRKkxB0TSaOBdU4CteYpaXFghEl1Y5gFiyXMcJ5cZFWTcq0RaTYh1lQfcZxzVHi6W+dx3+Qw450LTzQ4ZoxI07BIpuLMUiC06UogUBasQREb7UKQBpbMqMdXsDS8hq9uTMiRSfvajGhWUi4bMJ+U+4H86sxMn8SOGl3SKn2uvOX1gJ4lU5R26cjfImpEHPcDpNtstLF6JYBjaAiZyZoYRtbTRQ+vuzXPf9EfUMSOz22GmTww4Gg84lLgxSjD1ozZgKGqfMM1ZQGNHm2LB3C4NPOwZiOFGJyS3E9TGCCxlWcSrrecgpITck+hgYYcN2m06CA57YGipCCQRXguamBrS7beCBpf5UdaHbwJoX9k+hz8uwe+MqAwWyg4vyUafVwNnnMIadEvd+YdtUE7cPCtyL2k16YK46bZz9XLkMrsO6/JcDLb8KCLkY6+Q/RZMd3egj0CNzK6pyU/xgaJcb1o23rBMYptNzgaFv5lGT4Qk27CJweWkhwbaYdp7vvQUKBksGXc/rS6iZ47cuExTCY+egh5+S37DtIfvWcrtwar/4ALiTWtmzY2+hNRoCn3zPf9aHiwdMV/ScA46hvEBtxZ8DA6R0yAD9iMiLc2wrvtBBICKhMB9q0+jK7IrCb+V5GlXDvl/k3qpzS0nEXYXn3E6hKLBZkdLEisKGtfRXRgAcm0brXkLo/iF35yAs/sA72kfdgsxeQmsQQhiciHkfC37ESfVkh7qeR+tj6jtZk+IQfjvS3I9MMXJ2AwE4DN2kLKzyq8MNIp96GXr5IMGW3PhBjLA9Gi/aAecVf6IKmt+pKvBFNBdzJ7cGQaD7nKrPRwNh0+a/jV3gxOliY+0csb4iXzocwSKpT/BxK1E31NLvWTCMIHZep36EoDgdMLx2oKnGS+UZxhCU8/CfmDstdWFvMqV8B5yORepxG/5T6CvDDZtwRZtJDqSt/9914M
 VNGgMJNb
 EgvD6z9ncIStgygGB32XkC6ss18vMdYmX6nG3G+LoJIFR5AoQyiQBFOzgsrO4EFFkf4r9gT1PsDSfLLgRNScCuaVMePPxnl8bAnSX+GKWHVppsDkmmbm1oNZNMfYht+970m6ID10s09+OzGMSQy+dCeGWe8gvoNEAPN5Ep+X9ojL3JqyEp6pDsaqY0plPU6d4ANhsNYOTQ319N1iqBeLscBPx22sRQRTXeaOuFCMqgc/cJuLwE/Uh9caUhIYNkf4u5dEViUFFblvwHoMB5pJSxpUhpAIwi9+KVB3h3eUr9Ri8EqhysOz1Z9MO4oKo8VIcclKR
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Thu, Oct 29, 2026 at 02:07:55PM +0800, Chris Down wrote:
> SLAB_FREELIST_RANDOM randomises the order in which the objects in a new
> slab are handed out. Like SLAB_FREELIST_HARDENED, most distros already
> enable it, and its cost is only paid when a new slab is set up.
> 
> With it on, the same system level benchmarks didn't change measurably.
> Allocating from new slabs does get slower, by up to about 30% per object
> in a microbenchmark which does little else.
> 
> So let's enable it by default too. SHUFFLE_PAGE_ALLOCATOR defaults to
> SLAB_FREELIST_RANDOM && ACPI_NUMA, so it's now built in by default on
> those systems, but page shuffling itself stays off unless it's enabled
> with page_alloc.shuffle.
> 
> Suggested-by: Vlastimil Babka <vbabka@kernel.org>
> Signed-off-by: Chris Down <chris@chrisdown.name>

Again, just like it should be. I wonder, though, don't these 2 changes
undercut the goal of making these boot-time selectable?

Reviewed-by: Kees Cook <kees@kernel.org>

-- 
Kees Cook

