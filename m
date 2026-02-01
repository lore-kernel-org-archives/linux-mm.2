Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C97BAE65298
	for <linux-mm@archiver.kernel.org>; Sun,  1 Feb 2026 18:16:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EA5106B0089; Sun,  1 Feb 2026 13:16:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E7D1F6B008A; Sun,  1 Feb 2026 13:16:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D7FFF6B008C; Sun,  1 Feb 2026 13:16:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id C4F696B0089
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 13:16:50 -0500 (EST)
Received: from smtpin02.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 324A4C2F75
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 18:16:50 +0000 (UTC)
X-FDA: 84396693780.02.8799830
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8945A40002
	for <linux-mm@kvack.org>; Sun,  1 Feb 2026 18:16:48 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TotbYCTm;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1769969808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J182AEuidiDTXZEDUsoEeGI/qL9bLjZBSAqah/+5tOw=;
	b=M+am2N+v8isESN/gjeA1LPgsznCXtnxOySYY902dOANOTqrml4kbCQjLMiJ3OmOhC6Kmiw
	MOUC1fYc5p9dObCJO3lEuCttdjjmMVv/55msFdqRrMv/3/3/utTZWbVI1eo+eTdYbFlpXr
	hIUjAuDEIszDXpTUsV8lKoSTxXNUoGQ=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=TotbYCTm;
	spf=pass (imf12.hostedemail.com: domain of chleroy@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=chleroy@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1769969808; a=rsa-sha256;
	cv=none;
	b=icDvIv5gh3Natw/Tc0Nxjf0B2wobbNqjfadtNM3jMhn2Kwfump47INqMXGROEEnM1h6eXY
	vKbdI7kDoUNXClVGnFwdSYxglZMquFL4HSMO+F2zyWKNbL1RxXDffkaMnqs3Rx+9VK7jZY
	NE3DAZgWfFUcXgoU6kZxmSiL5Tf4szg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id C499660008;
	Sun,  1 Feb 2026 18:16:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E156C4CEF7;
	Sun,  1 Feb 2026 18:16:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769969807;
	bh=jTxTykOO3gF/25vPb3RH+JojwLhNjA5nr8MIb7Drh9s=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=TotbYCTmAHhjil7P+tewRpSToMQjJo5gAeHnQY/Fvi2lQGxInIlJ1Gvlfn898pdJl
	 2541LzL77vFtOq140u61Yr8E183QmGMWMmijfrx5erFeq304C1u+yqo7SI66oMbdYV
	 UDrcmkOgZqo+8LZgNpWWg7sFIw2/JWuW9Q/jjV5Z0wJqvFphPOQpixeNhzkZcZ6ICx
	 z1rs9quDxCtooxs66HwUDOwS4siTfw4QmBisEdRrRvnMVV/G7QjW0TuZTpyu8xpwB3
	 YjXNNao+/heFiSjJ0fX4dmej7rtTtGrNN8pNqSaQRQAHbvY2FqWsswGeAJXwtmi//J
	 wpClfO2LzOSDQ==
Message-ID: <e3759678-0b2b-4236-abb8-a16ffc81d4d7@kernel.org>
Date: Sun, 1 Feb 2026 19:16:43 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Subject: Regression: CONFIG_ASYNC_KERNEL_PGTABLE_FREE causes
 memory exhaustion and stalls on busy Cascade Lake server (6.18.7 only)
To: Robert Dinse <nanook@eskimo.com>, akpm@linux-foundation.org
Cc: linux-mm@kvack.org
References: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com>
Content-Language: fr-FR
From: "Christophe Leroy (CS GROUP)" <chleroy@kernel.org>
In-Reply-To: <06843c7a-909b-41e5-9359-2be51cf9dffa@eskimo.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Stat-Signature: jf4ozp66acd8muk3qniuuxo7jfb6xbs6
X-Rspamd-Queue-Id: 8945A40002
X-Rspam-User: 
X-HE-Tag: 1769969808-147330
X-HE-Meta: U2FsdGVkX19uDGsb41ulnNQLKOMN7Xl7dPQ4J5ik71uxZBitl2sEa549Fx2mEAYiIjeMywS6ve0jCVRDcwZtJTcDLwsjAdwM4teheNQni8hquxH+GC4eXniap5RDiHkzT1cSjmXdO0AfGuQbGGOh8OzVekF5uBR4iAd8+hFimYdjm4+EwmmFXwXsOfl+bnl5YUevzmGjBcDksyHLvrigqya0t+YfPHUbePfKDlCwmJ+qIwA+4nJ83BTBMotwPQ92gsTu46O4AOyZkOU3vcPMQS9yjL037oJdomtYhcxh+uwA7Un50nfaWZFx07k9e2vOUGaxexyrRvb2YOKB4c8s1uJzvdIZy2NEWT7pThHN1vNKPeXHxzU28NaEiegeg/iyOppA0+kokSQkz0z9pjoJmjP/vvWNOdTt9jrNsHmB3g2KS1dhce3NR4vgQ4e2T8F503ubRa/gwCspW3suGyDxGOmyWmRbODqD1WAq40rUkKZ/ihXlWnwiCJhHWRQHTXeivixcmP+TWT1ul200Hv/5M48sCk+dLDeA1j9rTX1A+IhpHaxgXyBMyEX9RlAa/dpNlaK9EPaY/KY/YlYYYXM0gFY4P64hm7QuiySo7IRqYTWzojqYbvBtKOwlydOsGpuUS6z4eLXjXhhHLRmzgiB5qjsnLR0Jk0bOs4g6piyJ7zHJuY0dcEtZFDXEz/0n0VeqvGQqPaH68HmbkwwuMXVITWLBNofJ/qDoUMJ7e3txlmVSZE9G+AAsEwbg1D3zNjvpIXwao4KfKxOuuR/6Tylr6+nBASttyY4az07Al9VzrlqEFgv7SjmSynYODQ+CwO3ZOv8HuOK4QZvapTTjM/GH9r4/NFlsxW8ikVH025kvJ09Jl4m19Ttl2CZhwLCbZU2Ef8IQnPDtGIL/L/x1TLQbIgV/M6FJ8WnZXgD5tAlscOeLz18k16Ord+GFl0T0z+YrOY0VZMVog/EDb3rVajT
 ub1I5nmP
 fvgjWmf6cUtSsHrfuQE5UiavfkDXZ/Z2emsmkiKJyLuGukIxfvCTqwfeFH4V9peCBJqRCax5IqFa8QxdgNPPfjZsuZylGVs87Jv7Q602bXzP/EmQytoNWhcTVtfxtck/M9D0Fu+PUO+TmxihhwrMZ8WoI8zIzcbBFn+c7+OtTi60OYP7BfXFrcJsKA1cjXDrmFP17ghQSsHXuhH4oEBI3kw92cW+VT2wyuqTA91Kbmm9CF98mTGW8t1DfLPAuyf/xq8YX44CF3ZrKXscofFQU11Ouzo+lBE5hcibHWjRNiuRrfcIulJOq+9DMEjvcXfgEfWb/ZY8qbW1+8UU=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>



Le 29/01/2026 à 07:10, Robert Dinse a écrit :
> 
> 
> Reverting to 6.18.6 immediately restores the previous stable behavior.
> 
> Attempt to disable CONFIG_ASYNC_KERNEL_PGTABLE_FREE
> ---------------------------------------------------
> I attempted to disable the new async kernel page table freeing feature:
> 
> - The symbol `CONFIG_ASYNC_KERNEL_PGTABLE_FREE` appears in `.config`
> - However, it does not appear in xconfig or other configuration frontends
> - Manually editing `.config` to disable it works only until the next 
> `make`:
>    - As soon as I re-run the build, the option is silently re-enabled
> - I tried to chase the Kconfig dependencies, but the chain was too 
> convoluted; it appears to be effectively non-user-selectable and forced 
> on by default for my architecture.
> 
>  From an operator perspective, this feature as currently implemented is 
> not workable on a busy machine like this, and the inability to disable 
> it makes it difficult to bisect or run with a known-good configuration.
> 

Try reverting commit 9f0a7ab700f8 ("iommu/sva: invalidate stale IOTLB 
entries for kernel address space") ?

Christophe

