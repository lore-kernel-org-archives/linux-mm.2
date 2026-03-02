Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5115CD58E7F
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 09:06:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B68C16B0089; Mon,  2 Mar 2026 04:06:43 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B200B6B008A; Mon,  2 Mar 2026 04:06:43 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A228E6B008C; Mon,  2 Mar 2026 04:06:43 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 968E96B0089
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 04:06:43 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 63D081A0A7C
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:06:43 +0000 (UTC)
X-FDA: 84500542686.28.C196567
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf17.hostedemail.com (Postfix) with ESMTP id B44AF40008
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 09:06:41 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXZDi68O;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772442401;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fz9PU6yGrGAnFeykCmGYPANR64LRTPHWLKdEGK4i+cY=;
	b=7Y6qNTpfTf0aucoaRpFYCduJFw6nHeRk+6IVMSzH9hhFZbILDjnUGwkLj06rKJWLSDv5o9
	2fl4v/L+SIw2/o8j1un954wcyMr1TMyQJ+zpmr682NoXawWFy7mKeizUtjHRkjLKIu3zYz
	ZiKajHrEDUVwmmUPLnTKTE+S2uf+ujs=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772442401; a=rsa-sha256;
	cv=none;
	b=q1bakYj09B6YUEuLRTXvzSPz6+4ibY9pj8sMVPGjvr9rMDiGxj1s2uA8919Wk4YYDTcHBO
	VcaIDtus9Xo7yLzpPQNBXZ4WYmO1/o5x5BpXJfReihsQdhH4AP/+yN5F39AMgealh6bfwF
	Q90J/icGIvyElroGHf0ZbHDGOwQHufA=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=PXZDi68O;
	spf=pass (imf17.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 03A96600C4;
	Mon,  2 Mar 2026 09:06:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70FF8C2BC9E;
	Mon,  2 Mar 2026 09:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772442400;
	bh=pQFhLP4PM8OJ3gckm7uOewqs59ad2rc0IT7killTS50=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=PXZDi68OIkGQWMoUTGLt4XIaUHVd4G+sEoKT1/p9h0RyErEX6giNUZBCMcLYmcfqc
	 FGPxo52bZ7J4fZlefWlJ05v0utqdjcmiGCrmAsbDt0iKs1MaS1fnxXDuXkpI0nsi7g
	 Ub7JCcJRbujEcpMPDf0eoiC2htBvMF9w04RTC2Ay9i3jRe8o4o7CZHAF+zTmbQhI6T
	 xzoh1y6jSQOCHfXIaus+L9RODhOPffPVKfvO91IwrVet8x/tcn0MsRS8KKah0Q1O0O
	 FXQk112GMwOSB/YVnM3C2SFc+RiUxLn1GWzf5U0bTO1nRNx6Opt3QEzJSvgb1VHUIJ
	 fUGCMn/GbLCKg==
Message-ID: <177f3071-3303-4db1-aec2-469921d91b7c@kernel.org>
Date: Mon, 2 Mar 2026 10:06:32 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/6] mm: rename ptep/pmdp_clear_young_notify() to
 ptep/pmdp_test_and_clear_young_notify()
To: Baolin Wang <baolin.wang@linux.alibaba.com>, akpm@linux-foundation.org
Cc: catalin.marinas@arm.com, will@kernel.org, lorenzo.stoakes@oracle.com,
 ryan.roberts@arm.com, Liam.Howlett@oracle.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, mhocko@suse.com, riel@surriel.com,
 harry.yoo@oracle.com, jannh@google.com, willy@infradead.org,
 baohua@kernel.org, dev.jain@arm.com, axelrasmussen@google.com,
 yuanchu@google.com, weixugc@google.com, hannes@cmpxchg.org,
 zhengqi.arch@bytedance.com, shakeel.butt@linux.dev, linux-mm@kvack.org,
 linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <cover.1772185080.git.baolin.wang@linux.alibaba.com>
 <283d103c5131e32879bd847263c93b768df64d15.1772185080.git.baolin.wang@linux.alibaba.com>
From: "David Hildenbrand (Arm)" <david@kernel.org>
Content-Language: en-US
Autocrypt: addr=david@kernel.org; keydata=
 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
 qIws/H2t
In-Reply-To: <283d103c5131e32879bd847263c93b768df64d15.1772185080.git.baolin.wang@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: B44AF40008
X-Stat-Signature: 68741ifr7mqcrogp6ehtisn7en4pn3g5
X-HE-Tag: 1772442401-171140
X-HE-Meta: U2FsdGVkX18bjkxQjfE4kgTEKKpWV2Wvi5YPN5/4GGzLlY3nvKUkKJBNNKl8gUJaRi8+nkrEAi8DVHem7f8kuebglC/wAHodXoAIIjoYfjSlU1OEQ6Ug7Ou/hNcU3vpodkercQHd9gFObemQcL+AGGYMLaMBmVHs1qqUMQCx93vWoUKW+mQ2GW6JTcQ8CTMTIC8edARp4FC7EzjSsPt+nFrmNaJkgwpWLITnMa+fijo0Zu4ePsF5XIjptjK0483UtQpbYX/EqfDdziBI6XPKUz2gpDcTO/3STEzvhQst9CAcx6hzf5bfzzvE0dWZvXnc6t9DrSFUpf6SGbFHQqkiL/7NdMZ5YK3R/eWiYeN8wX9uXijVbAj348A/qVffVg8u4c78em14dD1PL1x7/ViWG1UFldY1BlPS7tc5jbRRBmoqB+6R5h9Y8eUjTiakeBWNgQ2RSnpqgrTlttwjyYI+130JhvWN6Rj62SYe8AvBOLMZ7bImlGvsyBrBDaIfvypbZmc9Sm0cJOcfPopTLoeCkZz2J73Vs5Cz6lo0dB39MUEZa6qv5g5CIHn3uAQpfSvA2p70x/q6cii33euobhul2WLSu0Xn0Jhp29WkQ/BquiJj6Cuc7LeA2pxuB2eVSSlw6sJpo5vfN0Pj4Uf9OMg7g9TvzO/eQDHST84eo3lsuRUPkk5FTI486kAXYJTcd8za/LtDRrHTptuzUyHOUSncpZOGZOUJmyABptYAvD1+UwWmATe0o45GEdDJEjbJbtyvKQZIK/C0692PHYkzPO1mM8h6Ty+rf+4Kk3MVG3Ry5E6BuM8KSQy0DkkGmpSqcarbuMhRJLeGOyLV8j84lspuT93/8Mn3PLz9vj1VDWCKmX6smeBAL9i9JImwShi8twr1Ml64ix2gw+xXU03yK2XsXv4mMQvIYnBxjrkayO+KJGEnlgJoFhsgoSK1rU1/DmQB6R3T0AmCGEen/QDyh8o
 G/G+xsrp
 eVCWunNffZAoVD3SAvPr4Ur1VNL1xjoZAoAkI+/xXvqFwaBb+GPDl+j1G7hOFPkIGjZVK5macZhinR+CpG/6WQedc7H1FdJU7VeeZ0kd7ty5Y2IqC2skOfJAvgYvfqr3Bg4qwO+MPHJZhRKiD3T2fQBQyK3QEtzioIZ5bu2vNIg+2Q1XenU1S2Cg+zjUL3egVC5wc1K1WsJbPS+zmW0ejtCOqGNlBQUQPSpGnaxUzj7xhhTcCVp3AVQs4XUK9AInYORKO3qKoWHrfEhwkBjOQxczEIWOcujoqqNEExUVYJMFOOKsVnyBi8uUd3RKjDTv0ea2OoBhHazkqp5nK0hBRWnTlCShi29QLBX6HCIYTzi561ENJG77iEpoKgaOo12fU4Ivw9gttC2mZUrY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 2/27/26 10:44, Baolin Wang wrote:
> Rename ptep/pmdp_clear_young_notify() to ptep/pmdp_test_and_clear_young_notify()
> to make the function names consistent.
> 
> Suggested-by: David Hildenbrand (Arm) <david@kernel.org>
> Signed-off-by: Baolin Wang <baolin.wang@linux.alibaba.com>

Acked-by: David Hildenbrand (Arm) <david@kernel.org>

-- 
Cheers,

David

