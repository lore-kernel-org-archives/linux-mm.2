Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 89A951125855
	for <linux-mm@archiver.kernel.org>; Wed, 11 Mar 2026 16:54:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EBDAC6B0005; Wed, 11 Mar 2026 12:54:47 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E75106B0089; Wed, 11 Mar 2026 12:54:47 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id DA8CE6B008A; Wed, 11 Mar 2026 12:54:47 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B99376B0005
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 12:54:47 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 4E6C15259C
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:54:47 +0000 (UTC)
X-FDA: 84534381414.03.6FBC1E5
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf27.hostedemail.com (Postfix) with ESMTP id 9F04E40006
	for <linux-mm@kvack.org>; Wed, 11 Mar 2026 16:54:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BaiyyMN3;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773248085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=5rXplPTSsUfDX+N6u2AZ8zaR2MAtbfPX1G+RveTOfqI=;
	b=KLCidcXdNnmvM7ihAPWVtRtV1263tEI7P1DYFZiDRCEtWvRky1UNJ8ctR2Cvcu+Nb+n6qP
	TEk6tu+6LBpS8oT5PJ6Wr+oIxMINk1mCBo8KPIG71A7PAKKkowo2tRTNrNBeEjZ2m4X9Ib
	Y9s0qfmgYy7VnKLOunWMxapsDlBCwb4=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BaiyyMN3;
	spf=pass (imf27.hostedemail.com: domain of vbabka@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=vbabka@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773248085; a=rsa-sha256;
	cv=none;
	b=GoNY84kTcX845sgGdcIF9BcuzBxYPRuA7FzqDUSzrZmbD/bQjH/KJL7vp7J1NCXqiL1aGq
	Bk10wpvIAQR412IkTPyE+3ekpeUnctntOGmGqCH3nnvro5+bwslcDuy++f3/m7HRk0tTrx
	cfkqupbCPJBZLvR1dooVIuJIVC904YY=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id E734660142;
	Wed, 11 Mar 2026 16:54:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9A9CC19425;
	Wed, 11 Mar 2026 16:54:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773248084;
	bh=91qlieLRgYOSO9XaMOoUeKdKgp5MSyhzDjaJY4o2/5s=;
	h=Date:From:Subject:To:Cc:References:In-Reply-To:From;
	b=BaiyyMN38qaU8eVJpkSJb+UwLI0Hhj1dt3L+OUCHNHOI2B/jmnlEbqApjU1uA900O
	 SUzuUoh7VLARxP3yJgifBHMAStBHPRIuzxHlW+MJwYRc7lkQu+doCU/T9lbLvd2Ckq
	 BdZ9CLenSLwr7DqwIzuwVIi1wOt28LooVRxbprzYhmBfCe+eFoiSjGGqpmXElrloGO
	 LhBEn5UMLjyrQC0bBtV/BpRmdZhVk2xzH2uekf75l821lJVNIhQ7B526tN/TpoMREJ
	 iX8J7YXM162DAc4Z04Uae5SLguC6hYe2uxDhKZ3h9T0D0GsdoLgJZhinhp9kJkwywf
	 6r2oDDLPUFWNw==
Message-ID: <272f1848-e2c8-471c-9b0d-e6706b464d11@kernel.org>
Date: Wed, 11 Mar 2026 17:54:40 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Vlastimil Babka <vbabka@kernel.org>
Subject: Re: [PATCH] slab: fix memory leak when refill_sheaf() fails
Content-Language: en-US
To: Hao Li <hao.li@linux.dev>, Qing Wang <wangqing7171@gmail.com>,
 Harry Yoo <harry.yoo@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
 Christoph Lameter <cl@gentwo.org>, David Rientjes <rientjes@google.com>,
 Roman Gushchin <roman.gushchin@linux.dev>,
 Suren Baghdasaryan <surenb@google.com>, linux-mm@kvack.org,
 linux-kernel@vger.kernel.org
References: <20260311093617.4155965-1-wangqing7171@gmail.com>
 <thhmlnu6phtuucz7jo3xoqeiv64rs4ynkt63qoxvtwgfh3aofw@lo75dus27vyk>
 <tak4kjtw65fk5r4inuvddqt2pooqbfu76i3smzxsfjoiz2p6oz@qwpmlhmpqlwz>
In-Reply-To: <tak4kjtw65fk5r4inuvddqt2pooqbfu76i3smzxsfjoiz2p6oz@qwpmlhmpqlwz>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Stat-Signature: 6izc1zx8w9yjktn5ujb9k38bd58gb7bw
X-Rspamd-Server: rspam09
X-Rspam-User: 
X-Rspamd-Queue-Id: 9F04E40006
X-HE-Tag: 1773248085-423493
X-HE-Meta: U2FsdGVkX18LmhcwCBJsr2MJQBmqFZvcOHJpWD/6xqTOkxWdKsArYPkJ5t3oPms0mhCU/lEH7E54QROqRakyaIq2Gd0+m+9vLROdUV9kwvQfx6HRpnOn3Rk/eucJYhUOpcP5UW1QUcYClXJ5jp0Z+cR3IbmQ1Dt++luRoofd7+4sti68DEHYm0RPTeATxnmjx5EOjRapG83QhOwKmz7x9qLAY/72KxTh4OXIwArFl67ORynMca2o5o2lmtP2ixaA4EDUVxZxG4p8leCrYkz9QaeDtUPedxPWY8ZFQKUu4sRII/hbg0E4KyVFybMlJ6sWp4cuFkYWKkiHP/MQqk9yVJiHqlKT3eadwsoT2nutLgnvYh9G07VzjalM/xqI5azHWkhNixCkOlE0dO27/SYlOUFWaXf3K7QgaH/j5gApD7WrGCBk9SOcQ4gn7/HQ7GTJMsT0ojoG4fsSYn46KjQsfxABAGAi1MGDz2bxTOuUgIqfz8+YYOAs6vdULamjX51RGltKHFzP+PwEOPKgrQs1vw7laBN9e/wIapo0M3poqxRcaGUqenKUxsJIPLTcCnZSK6cb/vo10RuMTpNMPTD+3TkxtoK/gODPKD0gvYc6RT/fN5w0DmnwuecrXWh1Ac2L+llClKws+iCH2SSOpT2ToGn2u49b05qEs7DYzEwafipTYzo4u2+C/BFXcH92zXIuTUnDGQdbBcLPwIK3nlKVMFyxmdx6cjlF/yGIPXkcqYi2A1QNfMoGD+cNBMK6WMn7QKNAbb+vHCJSGqSJdcCJ4DhMQ4MiTBp2tLqe+wKbWOoDOoARe+NkjqVkuRbif5S2d2q/UIpbuZV2Krex4qSyV02j+/3S7SY7BavxAo1ZVNALtRQUxKfNuFuZmNI/K4NmGGWANfLjMiva0dFiBqUVvTvPCMpsDypYDXUIcJfMU0Bq0VL+64Ktnc15l2C5t82KBjCK0FzKb6hWIxLuU2V
 VFhyvCsB
 gLu230E8VwPcq5qP3oEfkrMINT53q0Z6cqEEDVsdIaQuIbC38Q1A9T3fe1osJ/SgIG+pI/xOxxkBKpg2D7XBXuDMAAGNIJckrWcCIWRzXZZiFMkI7JZkxlyanEjYFuRyAaFon/k24BFYD3VSMaRyM7QPBRpe6cnRHmIAEdDo2tzR28E5FIJuHrL6NXj65xmqDeHI5KTdbOw3Wewbq3HxDiyXMbJnHCbYo9H9CNfc8+dSG2SKLtDKREPNAaX+V//CENLyeIzM0fyZ8QlbFVHYnD1DI95wbyKPCuXh0IIL6pg7wMGxaBHXxiLO1TQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 3/11/26 17:30, Hao Li wrote:
>> 
>> I also want to bring up another point here, although it may be outside the
>> scope of the current fix.
>> 
>> When I looked into the refill_sheaf() path, I found a refill failure does not
>> guarantee that the sheaf remains intact: refill_sheaf() can partially fill the
>> sheaf before failing. This non-intact behavior propagates to its caller,
>> __prefill_sheaf_pfmemalloc(), which therefore also cannot assume that the sheaf
>> is still intact after a refill failure.
>> 
>> However, the comment for kmem_cache_refill_sheaf() says that "if the refill
>> fails (returning -ENOMEM), the existing sheaf is left intact." That means the
>> behavior of __prefill_sheaf_pfmemalloc() - where the sheaf may be left
>> partially filled on refill failure - contradicts the API contract of
>> kmem_cache_refill_sheaf().
>> 
>> Maybe we can add rollback logic to __prefill_sheaf_pfmemalloc() so that it
>> provides intact semantics, preventing the non-intact behavior of refill_sheaf()
>> from propagating up to kmem_cache_refill_sheaf().
> 
> Looking at this a bit more, after checking the current callers, it seems that
> the existing callers of kmem_cache_refill_sheaf() are not relying on the sheaf
> remaining intact on refill failure.
> 
> If so, then another possible option might be to update the comment for
> kmem_cache_refill_sheaf() to match the current behavior, rather than adding
> rollback logic.

I agree with this option. Having possibly more objects than before the call
shouldn't be an issue for the callers.

> So it may just come down to whether we want to preserve the documented
> semantics in the implementation, or adjust the comment to reflect what the code
> already does.
> 
> I may be missing some intended dependency here, though.
> 


