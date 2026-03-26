Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 84C8B10AB832
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 23:36:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 703EF6B00B1; Thu, 26 Mar 2026 19:36:18 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B4E66B00B2; Thu, 26 Mar 2026 19:36:18 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CAA86B00B3; Thu, 26 Mar 2026 19:36:18 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 42EFD6B00B1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 19:36:18 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id DAF731B956C
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:36:17 +0000 (UTC)
X-FDA: 84589825194.03.83F6948
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf26.hostedemail.com (Postfix) with ESMTP id 4CCF9140002
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 23:36:16 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VEyVHYf/";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774568176;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oD88tQA75aSQdyhn7YDxb/7iWMOiVMP1LEXrQC6xNkU=;
	b=0ierz6EnPL0oLQx4mD7Wj+bL0Ae7BuAESju12yIbueYlbpqVX81/zCKuR2BD+6e1k8LNDB
	3SyZhX4sxckNrcRs3xCNS2toUMo/Z8GnQ6Ccnk2qeeliSWAs+tPUk/6zToI247ay7c6EvO
	AAI68yIUdufkiWEudULoj5vSEGs193E=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b="VEyVHYf/";
	spf=pass (imf26.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774568176; a=rsa-sha256;
	cv=none;
	b=f/9M16YmMnmPOVJfiloKXhlPdprVbVtLsY5ual6JOgnNk4UNQSR0SROgKPoP6gTB7Wf3fu
	bGHDzEyzePHMMuVLKGOZvjB4AqXuQVDjOvogglokppepeJafUcHGXx8YPulKaGLthU/hHO
	IkL7AlBAujC2IQ7W5Xm3mGaaq0PBHj4=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id A46BB60054;
	Thu, 26 Mar 2026 23:36:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5AABC116C6;
	Thu, 26 Mar 2026 23:36:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1774568175;
	bh=tjvJvzzYSuoLzuMiETcihqcIulqakEMU4f7rMggLbiY=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=VEyVHYf/05z4fci2WU8QAGNTm9bSJJ/g7Wxwi3iQjXSxMCcf2c8VHyT+qwFYsbCpF
	 Q3HyqqAAU3dwnTKQafc1fnpGCEO0IdYmXJIgG1RuvAa5JXXdTW9YZAZB19puAltlT+
	 cxddpgcY4YyY69SHbvMm3H0ZeTnZPqAxGxpXjdug=
Date: Thu, 26 Mar 2026 16:36:13 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Chenghao Duan <duanchenghao@kylinos.cn>
Cc: pasha.tatashin@soleen.com, rppt@kernel.org, pratyush@kernel.org,
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, jianghaoran@kylinos.cn
Subject: Re: [PATCH v3 0/7] Modify memfd_luo code
Message-Id: <20260326163613.4f63a9ae5af7f3d294f3aef9@linux-foundation.org>
In-Reply-To: <20260326084727.118437-1-duanchenghao@kylinos.cn>
References: <20260326084727.118437-1-duanchenghao@kylinos.cn>
X-Mailer: Sylpheed 3.7.0 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 4CCF9140002
X-Stat-Signature: u9z41u4kziacff4hy5z99wwpybpg59cr
X-Rspamd-Server: rspam06
X-HE-Tag: 1774568176-5534
X-HE-Meta: U2FsdGVkX1+TOODQHZIUlIF2doGqE57nhCn9kyZ8eBAeAachn0xPG9XbrEk9JuUmm/q3oXO01KDBt7h816LEvunof46R+HmjsNgchW5WrNu/VEYkCa2oj16d7jjehD5F1I2rHJPzkp4u5f8qO205M9XrPxMCQvkROkJRvRe2zOYH0nORhYkfb67YV8qz6Ai1qMRxVHULuREvgQhnPWxesW9wgM37kUseeo+ZjkEEpdoRl7lECrYiLjPfkd8Yv8XBVHxnvfh7mbXuvwIgje2i5RNmj8zm/8Tso+aUZB7rwc4BAYjS5Ovk2XKda509WyMNSxU81Uxmba+ZMIgG2uVUGNGuAv2noKYnOkx3psqMpJlIODW3kf+yFy4/W93adRAjs8VhEXfwLQTY8Ftx0OfasN94so1eakZIoDI1RG984lmLrGKY+AAcLJrjjNaMkxs53VEZX/y2Ze1EV1P6luR88RTllZySjPo/lJDrCq2AytTx5bQHOmYl8GGb2g/10svbXZqERVuHkSsKWuGBDwvL65vJ45XMa8cc5oL9fDA7TDEbhk4MJhNXdJVOn9XVpY79rT5c90D2ny9Dp/PBF+/j8KatY4fqLR8e4apV5/1gbJ2+kzfSk1Dkcbjx7QFlcJuHf2Z6ilhGTnRjWlMYHNJF6qGPuLF4f4vItne8rZ4eV975o3p2+Qu5a0I3VuWnA6pu16mxWaG4KKS+Nwunp0HgB+b9spvhNeBtyVgP6dhnS4jbEf+DfoSRez2Jj/MmazbsOk1Ee/eIuhAz71V2WjQ6g5Xk4K1xbaFjI8Fl0V1KaAc7V088/5pmlMf0AAvBI55sODz+JmoVpeWgNZMCB8cRYz7whxS+CFMZK/Q2d0cdfARG60StVlqgYHBtm16N/C6D7lzLYPkLmVlFKUnHr645uIIWzZvkilXK8pOV8fI1y/hciN+Oo+5RO4dfxC61x7LNm2dzX/XMK67apZ8nPmB
 +xH8Y0sK
 gAqUDhLXOYUwgs1jZa8fYslCzJQ19ngsN9PTbZPkNNOVXgE/M3HJjLYooCr94KrCP3Ix1saPFLH+BipgJ0bp7ZUgFpJBvEtZVOQww++7cjNZV3ohhc653Ga0wiVlL7o3vU/DwZ/MAPNq+G0waAGjKfkadasTDOdu2eT+xSV3QVsd7v+hBe5cCuuGv6zfB7g7TZBuxhdd3MzYnMHJdfvDv7u3u1IY4UC9jNx4uFjczh4jrG8BlRzpQrsyhyyaaqYvlB9Y7Qypyu6rv9BBy+mxwWZEWHh3dC2Rw6NwPelg0csSX4oc6SO9unShtCbykytK/5f1amE04cF4AhwAViyLlE51sRcQYycuB6KAF
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, 26 Mar 2026 16:47:20 +0800 Chenghao Duan <duanchenghao@kylinos.cn> wrote:

> Subject: [PATCH v3 0/7] Modify memfd_luo code

I'd like to see a more desriptive title than this.  Maybe "memfd_luo:
various fixes and cleanups".  This isn't a big deal and "Modify
memfd_luo code" is good enough ;)

> Date: Thu, 26 Mar 2026 16:47:20 +0800
> X-Mailer: git-send-email 2.25.1
> 
> I found several modifiable points while reading the code. Please review.
> 
> v3:
> v2 patches remain unchanged, and v3 adds 3 additional patches.
> <mm/memfd_luo: fix physical address conversion in put_folios cleanup>
> <mm/memfd_luo: remove folio from page cache when accounting fails>
> <mm/memfd_luo: fix integer overflow in memfd_luo_preserve_folios>
> 
> These three patches address issues identified by the AI review,
> with the review link as follows:
> https://sashiko.dev/#/patchset/20260323110747.193569-1-duanchenghao@kylinos.cn

OK, I'll add this.  I'm trying to seriously slow things down now but
this series does address a bunch of issues.

Maintainers, there are a few more patches here than were in v2, so
please take a look?

Thanks.

