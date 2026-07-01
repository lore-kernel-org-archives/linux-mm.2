Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5028CC43458
	for <linux-mm@archiver.kernel.org>; Wed,  1 Jul 2026 14:19:11 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 499C76B00AB; Wed,  1 Jul 2026 10:19:10 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 471E36B00AC; Wed,  1 Jul 2026 10:19:10 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3B0DF6B00AD; Wed,  1 Jul 2026 10:19:10 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 17AD36B00AB
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 10:19:10 -0400 (EDT)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 9DC29140338
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:19:09 +0000 (UTC)
X-FDA: 84940414818.08.AE37D6F
Received: from mxhk.zte.com.cn (mxhk.zte.com.cn [160.30.148.34])
	by imf22.hostedemail.com (Postfix) with ESMTP id B3593C0011
	for <linux-mm@kvack.org>; Wed,  1 Jul 2026 14:19:06 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782915547;
	b=W3GPetYJeejVdHs03ovWsvVuXK68SJajm1BDECt/p4Gy5iunT7mmIEne40UJ46nOR5h2RV
	3XROQfkMCmdKj0+7LlUkJ2pOUVzsndMQgYdL9ioSMI//5x0IQiAPI60IAhQIJJAM7g4Cmo
	tnyHnrXqYhJgxyM3KJJqteBUIGrDO6s=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782915547;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ok3BQvRWxOUL1FLnhilhovGc9h1YTEdbHMcVxNrv2eI=;
	b=5+58UlmaI4wz83EHTOWn63wUyQ8CRkCwamKGhkkrQ6TqDyiKZ2iZGSCYPH1/O+qcMh0JVV
	3FopK2qBU14/f6Axl6dzl3bciccx3xDGZHILGavRe0L1eI0rnnXKxYfzk5OyUcuZ3TvkrZ
	XCa7UMtEn6g7pLhGbs1k/Z0S484b/E0=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=none;
	dmarc=pass (policy=none) header.from=zte.com.cn;
	spf=pass (imf22.hostedemail.com: domain of xu.xin16@zte.com.cn designates 160.30.148.34 as permitted sender) smtp.mailfrom=xu.xin16@zte.com.cn
Received: from mse-fl2.zte.com.cn (unknown [10.5.228.133])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange x25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mxhk.zte.com.cn (FangMail) with ESMTPS id 4gr2FK5Pftz5B109;
	Wed, 01 Jul 2026 22:19:01 +0800 (CST)
Received: from xaxapp05.zte.com.cn ([10.99.98.109])
	by mse-fl2.zte.com.cn with SMTP id 661EIs1q000143;
	Wed, 1 Jul 2026 22:18:54 +0800 (+08)
	(envelope-from xu.xin16@zte.com.cn)
Received: from mapi (xaxapp01[null])
	by mapi (Zmail) with MAPI id mid32;
	Wed, 1 Jul 2026 22:18:57 +0800 (CST)
X-Zmail-TransId: 2af96a4521d1cb0-8f438
X-Mailer: Zmail v1.0
Message-ID: <202607012218574761db7fGjm1svTfeCoKtrIX@zte.com.cn>
In-Reply-To: <20260701123430.20699-1-lukas.gerlach@cispa.de>
References: f75d286c-4d9e-4b64-8a9e-03e1afcb509f@kernel.org,20260701123430.20699-1-lukas.gerlach@cispa.de
Date: Wed, 1 Jul 2026 22:18:57 +0800 (CST)
Mime-Version: 1.0
From: <xu.xin16@zte.com.cn>
To: <lukas.gerlach@cispa.de>, <akpm@linux-foundation.org>, <david@kernel.org>
Cc: <akpm@linux-foundation.org>, <corbet@lwn.net>, <linux-mm@kvack.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <chengming.zhou@linux.dev>, <skhan@linuxfoundation.org>,
        <lukas.gerlach@cispa.de>, <jo.vanbulck@cs.kuleuven.be>,
        <tristan.hornetz@cispa.de>, <michael.schwarz@cispa.de>,
        <shukai.ni@kuleuven.be>
Subject: =?UTF-8?B?UmU6IFtQQVRDSF0gbW0va3NtOiBkb2N1bWVudCBzaWRlLWNoYW5uZWwgc2VjdXJpdHkgY29uc2lkZXJhdGlvbnM=?=
Content-Type: text/plain;
	charset="UTF-8"
X-MAIL:mse-fl2.zte.com.cn 661EIs1q000143
X-TLS: YES
X-ENVELOPE-SENDER: xu.xin16@zte.com.cn
X-SOURCE-IP: 10.5.228.133 unknown Wed, 01 Jul 2026 22:19:01 +0800
X-CLEAN: YES
X-Fangmail-Anti-Spam-Filtered: true
X-Fangmail-MID-QID: 6A4521D5.000/4gr2FK5Pftz5B109
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: B3593C0011
X-Stat-Signature: 7hkbt7d6h5gjxkso96th7xx5kp53t311
X-HE-Tag: 1782915546-117877
X-HE-Meta: U2FsdGVkX1/HGghJyZWsD3mnGypLfrNMNNPTZyTNVWytlx/604PB4O43BCynAnOi45zFAh4KhioG8eEujQX4490IMkIU5QgbSNhDA430Mf+G7OeSQOHgmjX0BQuEqMBRL+KiIBIP7YU7+T2ORpxVplOAldNCf5vKvn1T6GM603g5XTmDn2c2lNoSKseKEmukJHevdHUaroc1cI6AHZcBonWiKeQu6afcazojqV6Bfk5X5gedw3C0TCIJ9S3gh5+2L10m1ZT6Hl/wfs8Q4QU7pi+0D59iHaPdZLl0h1/AXrw5cF+vT9TABmXzIoi16ESUscA5d3LPQV3uLN/X/p6Qde71hK2rzN02o6WHjXqX2Q/XkoQ+kEwzwujj5y16PlJa6b7U/qa4ug43XESQQN9rH0QRxx0ihRwUg0myH/ZCIaCuBzcOlJdfAmn0Ty3n/S6D06QHzLZ1QLRCp68P8I+tTWfqjo7w9/DnNmd1/6PDYotwnWicywi9E31Uv4oRtXndXTjRyWScG2WYHyPbxo7lemIcd91enxZnJZi8D/PHIQu6m0PJessmWZYQpqsr2pro65sBriqgsz2SLUC7T6wQyGimGB75GThzFulQ1hKQ2pHkcHF9ReUvhJfoOC31tZVHxWUjjUw2mGrdKK5vCeYutSVVaZX3KWfZFf1RkgWeyElGyMiIk798j9OeLMnPQMjiZBw4JrPX5VvJWms8nPbAlq1WkuJu0NgT4MTvO5ORbVE6EGI6IDAjfwxzqBZ8GDJX/svZ1U57dK1nkRi5neo4l92FM0VGJK8nguh0oBiVinbhk/DmkacyM0NVRYKehRvH6671EHVq82S/GirXH3Geng/7Cd9BkcaFMXfPaqatLHd0btwuulAsLmLIuSwDCPGU30RUUyeVhAFLOb/xuyAx5T7pIrBN8t529j8HjIricQQcTDfUdbXwsV3vsfVOFoSIfCqSShvm4de4CX2jeul
 xau8iv1m
 1hU2ddYgB/6SafxzVMd4cdADixvW7pLI/WIBrzGXBSw2VPDcaGKwfPEttlS96BCbip3YLNrG50XTMa7hTyqNsCz7brABdS3Ol7uxABXMRt4/TcWTsoyZcbq1yxpVhCY2Afn6ypNiQAXu36MmxdxHty20EncMzQetEHM0o2dH5TVzeeLlSDK82igK3dWaSXXcvLhxP4Tn9gyotv7YjSkcdGDHOqzhpsHTzw+/1ROcTmy2LkAl0mG2/JYxd8QBIgCRdI0Rq+F9pI7cl0RSOER3xrGLzWn8eozZob2m3
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

> Subject: [PATCH] mm/ksm: document side-channel security considerations
> Date: Wed, 1 Jul 2026 14:34:30 +0200	[thread overview]
> Message-ID: <20260701123430.20699-1-lukas.gerlach@cispa.de> (raw)
> In-Reply-To: <f75d286c-4d9e-4b64-8a9e-03e1afcb509f@kernel.org>
> 
> KSM is known to enable side channels, but the admin guide does not
> currently spell out the security implications of enabling page merging.
> Because KSM merges pages by content across all processes with mergeable
> memory, it forms a side channel that can be used to infer the contents
> of that memory across security domains, regardless of the user,
> container, or virtual machine the pages belong to.
> 
> Add a "Security considerations" section making this explicit, so that
> operators can make an informed decision: KSM should only be enabled for
> mutually trusting workloads, and any memory marked mergeable should be
> assumed readable by every other process using KSM.
> 
> Co-developed-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Jo Van Bulck <jo.vanbulck@cs.kuleuven.be>
> Signed-off-by: Lukas Gerlach <lukas.gerlach@cispa.de>
> Cc: Tristan Hornetz <tristan.hornetz@cispa.de>
> Cc: Michael Schwarz <michael.schwarz@cispa.de>
> Cc: Shukai Ni <shukai.ni@kuleuven.be>
> ---
> Hi David,
> 
> Thanks for the quick response.
> 
> I generally agree. The issue I see is that the current documentation
> understates the risk. The RHEL documentation ("could be potentially
> used to leak information across guests") does not read like enabling
> KSM is an arbitrary read across VMs, which the side channel we
> disclosed (in contrast to previous works) is. So the documentation
> should really state that KSM is only an option for mutually trusted
> workloads. A clean model for this would be to assume that memory
> marked as mergeable is readable by everyone else using KSM.
> 
> Patch below to clarify this in the admin guide. We would, in the
> future, publish a paper on this to further raise awareness of the
> risks involved with KSM.

It seems you have discovered a new information leakage attack method,
and we look forward to reading your paper. Meanwhile, we are currently
researching a domain-isolated KSM-merge and mechanism to defend against
similar attacks.

The following statement is essentially factual and deserve being documented.

Reviewed-by: Xu Xin <xu.xin16@zte.com.cn>

> 
> Greetings,
> Lukas
> 
>  Documentation/admin-guide/mm/ksm.rst | 17 +++++++++++++++++
>  1 file changed, 17 insertions(+)
> 
> diff --git a/Documentation/admin-guide/mm/ksm.rst b/Documentation/admin-guide/mm/ksm.rst
> index ad8e7a41f3b5..cbd5f2fdcfcb 100644
> --- a/Documentation/admin-guide/mm/ksm.rst
> +++ b/Documentation/admin-guide/mm/ksm.rst
> @@ -27,6 +27,23 @@ KSM's merged pages were originally locked into kernel memory, but can now
>  be swapped out just like other user pages (but sharing is broken when they
>  are swapped back in: ksmd must rediscover their identity and merge again).
> 
> +Security considerations
> +=======================
> +
> +Because KSM merges pages based on their content, across all processes
> +with mergeable memory regardless of which user, container, or virtual
> +machine they belong to, it exposes a side channel that can be used to
> +infer the contents of mergeable memory across security domains.  Users
> +should assume that any memory marked mergeable is readable by every
> +other process using KSM.
> +
> +KSM should therefore only be enabled for mutually trusted workloads, or
> +where the merged data is not sensitive; in particular, merging pages
> +across mutually untrusted virtual machines or tenants is not secure.
> +KSM is disabled by default (``run`` is 0).  Applications and VMMs that
> +use ``MADV_MERGEABLE`` should limit it to regions that do not hold
> +secrets.
> +
>  Controlling KSM with madvise
>  ============================

The above statement is essentially factual and deserve being documented.

