Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 60A13D11183
	for <linux-mm@archiver.kernel.org>; Thu, 27 Nov 2025 08:07:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ABAC56B0011; Thu, 27 Nov 2025 03:07:31 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A6AB46B0012; Thu, 27 Nov 2025 03:07:31 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 959EB6B0022; Thu, 27 Nov 2025 03:07:31 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 8264D6B0011
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 03:07:31 -0500 (EST)
Received: from smtpin26.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 3801D5B990
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:07:31 +0000 (UTC)
X-FDA: 84155657502.26.96BF631
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf14.hostedemail.com (Postfix) with ESMTP id 94DFA10000B
	for <linux-mm@kvack.org>; Thu, 27 Nov 2025 08:07:29 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osCoPrny;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764230849;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GaO7d8j0vmuP9xujYbbqAqh0DaLaOxY9tMZAB+8L1pM=;
	b=T8QQNW3wuZCcuQpC4H8vEoAp13dMAC4bzoyFocOY8YCucJUyz9q1sDzjVQ5BIbY+5I1vIe
	1/qGI234/31x6wSvNi07A3kneq/ZS3bEeDsCzd/eNG68dkxJymFwo0jNKLqLv2g6VQV5hY
	CCqtudqZVu/ZgK3cCBVmWWBnmoMnOV4=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=osCoPrny;
	spf=pass (imf14.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764230849; a=rsa-sha256;
	cv=none;
	b=28KrjUP+5LkXaYuPCozKnWwee/QSt0KOzUuRdmgvLOryBaaHIi7GIeZtp4Vx0x75iJTFaG
	GxIXkq0MT4HilVnoWzDFG8JHAgKy4TWHjxTDL574gKuUEz4bLpuUD4BwwNILtNvCfXSLCx
	fQoaVG+9PX6hj4q0pUaPSIiXPG25Mz0=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id B2D896020A;
	Thu, 27 Nov 2025 08:07:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53818C4CEF8;
	Thu, 27 Nov 2025 08:07:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764230848;
	bh=K3CMvjTy183HD6eHK7Cf0Gr+E74sFFmvcW2Q7P3faZ8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=osCoPrnyQ42kGmcShs64jWSy6GI3eifpU7WkYymsP0f7TVFkmjdywr2KYwadI5HOo
	 gwUubu5XLKv/w9q2668uPsf3vrfaSChAMnhL4S4GPxRZwYnNdgxLhPz++73o19kOvX
	 kKpoMGKCnOCc1wn0Lp2y97Pl5esUrYX1zRDkFRXDwEfafT4UZQNCqyOoyy8XpeslFJ
	 d5KvaLRRH+CKiTAfdBz5sUpSc5JbMmKUwlo00E6F3Qc6sBss9rgW5xapWhjjbc+1ok
	 MC4kKLWB9rZ4SpASMnVx2cVZR5R9kUmLI/YAp4x3MMZG0HZVlAxG2saxBia2aolxyE
	 inmRbc6anVeSw==
Message-ID: <fab2431f-a715-4ccf-88cf-9432212d804a@kernel.org>
Date: Thu, 27 Nov 2025 09:07:21 +0100
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/3] mm: pagewalk: simplify hugepage boundary
 calculation using min()
To: Sahil Chandna <chandna.sahil@gmail.com>, akpm@linux-foundation.org,
 lorenzo.stoakes@oracle.com, mhocko@suse.com, vbabka@suse.cz,
 rppt@kernel.org, surenb@google.com, hannes@cmpxchg.org,
 shakeel.butt@linux.dev, zhengqi.arch@bytedance.com, Liam.Howlett@oracle.com,
 weixugc@google.com, axelrasmussen@google.com, yuanchu@google.com,
 yosry.ahmed@linux.dev, nphamcs@gmail.com, chengming.zhou@linux.dev,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org
Cc: Matthew Wilcox <willy@infradead.org>,
 David Laight <david.laight.linux@gmail.com>
References: <cover.1764177933.git.chandna.sahil@gmail.com>
 <1e01c12f7666ade41f5f34ada24ad3de1087454f.1764177933.git.chandna.sahil@gmail.com>
From: "David Hildenbrand (Red Hat)" <david@kernel.org>
Content-Language: en-US
In-Reply-To: <1e01c12f7666ade41f5f34ada24ad3de1087454f.1764177933.git.chandna.sahil@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 94DFA10000B
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Stat-Signature: t356zahhnqeft78eb1wobjwyhdz33zk3
X-HE-Tag: 1764230849-848178
X-HE-Meta: U2FsdGVkX186+FAvoyg1dGjz7tLiqdUkz5dNYrCsAoewreP7CbiKAgU/qJY9LqlW9++rvLxHgItHOHzBVR4EeqNZch3aGKdorCpNR2OC0oZJLCTVqNezNyrxqofoDAeNuQ5QUIVUBVMojoWe0Hkb/GFb/BcduZSahqLTE0EJ5vtFAdDBOadcBNDFRefC4IDJ1OjqUvg/QV5NWpiHmbQ031nLz2S1aM/wh1P9nA2Pax02EDHinLkgGFgYfWteXaY5S8YIxolcI+m84/NOWaoch0fJCB4+4cAn2YVQIsKULQznU/ZUvBFh45uzyNG3yfMGyrOieVUGTi6nEdn7V9jzYpUdZxJ6v3wCsRYgfX0DsUvfkY9ugEA+iGZF5fGO4tPbGxPW2coPbVY3Mul/34o/W092s3xnxhw21jF3LKB0dzfLoKLsGULfPwIJCTLwoBjD7hO6N5pueIxI3SAF+O3GhOBUZBNWGaApRSIk63Zd+k6URd0Oy4WwV94CBgoS9NVTEC699AWtcylQAlRWhMOHkQF6pFtfjU15eE5zA8IOlcU3a6oykAptU+xyHtJwgS6Sa4D40fjmsNey9zlenMGEOPPDU1HweE3ouHG1MzADCM6mXu2XI9wioVen3gA5bi+jLpdIGn4qZr3zYc/ugBpbjhrGxufA+s7j4I8LLiZtWtVMOnUINLcYMhFPTUTnT5Djw3E+iJHn9N569Y+0hSrHRCAoPJTmJ59UXE4tjMLcMc4i65hrMMIntkbpyKGV8iq26SmjRB3/rI37McK/Y0cFexlrnjOnCiSBBJRPec5ZokL9FuCv0EVg7d20HlHuPbamTXZYbg0/D6fB/YAxJnzS/WuXiJZcPRjlq9WHaJuFnrJLWj6Ir/7oXtrQGbEZ9VXtPmHqzwEgbEynvfTrwyMDi3RZtv/mbkBPsrKJtWUGFft5nn/TXiQcoF5cYKn00gLZKBBMzbDL0zNqs9pm+kw
 Tb1Zq2YL
 Psbm6kl2SU1nRu+w1oleJZtBAaOdV34o7H965cHiHWH10kfA+b6A9OSxVhtJ18Y0M7i6zwQSfkHQvPiDP/KH31wWdmMkF0SYErqr+pLZiE68HXM2ZYaHDtn4CmN01UVRPZCYkgsRGEZN62bVgK7BOK/ZbtnL6XWnNn7vcGp56vtBaR5lPyplRpfAyK2BxrohGjTxTtr3xflpsYYhJ8fumIvHDP/+wj4RGmK0uVVKq1FCtgJ6UF8RAuYxCryFuU+g1oZmibjGPKvFDoQEykxC+stZ/FJsFWzDmwINUrI2RP9U4xGd5RtaneEasG029kGjpbFi/HyTxC25C7yofnUiSqSTwhJVW/MYZa38PCviDNUeSTzOGBkTVVQgZVJSahDBF11IZ2TOirro3ET0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On 11/27/25 06:11, Sahil Chandna wrote:
> Use the min() macro to compute the minimum value instead of an explicit
> ternary expression. This improves readability and matches common kernel
> style. Also change the return hugepage boundary expression for better
> clarity.
> 
> This was flagged by Coccinelle
> (misc/minmax.cocci) as an opportunity to use min().
> 
> Found by: make coccicheck MODE=report M=mm/
> No functional change intended.
> 
> Suggested-by: David Hildenbrand (Red Hat) <david@kernel.org>
> Suggested-by: Matthew Wilcox <willy@infradead.org>
> Suggested-by: David Laight <david.laight.linux@gmail.com>
> Signed-off-by: Sahil Chandna <chandna.sahil@gmail.com>
> ---

Acked-by: David Hildenbrand (Red Hat) <david@kernel.org>

-- 
Cheers

David

