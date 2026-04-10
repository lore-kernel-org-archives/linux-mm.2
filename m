Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3282EE99079
	for <linux-mm@archiver.kernel.org>; Fri, 10 Apr 2026 10:24:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 706636B008A; Fri, 10 Apr 2026 06:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6B6AE6B008C; Fri, 10 Apr 2026 06:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5CCD26B0092; Fri, 10 Apr 2026 06:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 4D0756B008A
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 06:24:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id D0C481A0451
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:24:39 +0000 (UTC)
X-FDA: 84642262278.22.2564421
Received: from gentwo.org (gentwo.org [62.72.0.81])
	by imf28.hostedemail.com (Postfix) with ESMTP id 241FAC0006
	for <linux-mm@kvack.org>; Fri, 10 Apr 2026 10:24:37 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=W9A0yhlH;
	spf=pass (imf28.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775816678;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=03t8udNgjEw5kKsyxwAt5MOGVETnhJlUQnBuEMAtark=;
	b=oAcKwTp4x6kjjX7diQEAAABpfTG2YxcUheCZd21nZjx49uA9+j9OcJDHlZfm+tagg1FHVO
	DF/t6G/d01L3ukUpDM4RrEeNY89Nwn8bIp7pIGe09/5D0q0TIBYRm2pPFmOri8e6myXGmM
	YeRsq1DQSqfx6ARuAOmFH8r1KUiCaDU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=gentwo.org header.s=default header.b=W9A0yhlH;
	spf=pass (imf28.hostedemail.com: domain of cl@gentwo.org designates 62.72.0.81 as permitted sender) smtp.mailfrom=cl@gentwo.org;
	dmarc=pass (policy=reject) header.from=gentwo.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775816678; a=rsa-sha256;
	cv=none;
	b=klXzx2UKr9GQceol/Ilnujuuw1MwvBpdhIvnzjVzBy5vQz257O7fMByPV4UbiH+xRL4Yn4
	ze8/Qs0Z+aNuTYox/hBlNZO/NSpBvLZgdHvRv3URPfqZJa733mvYB1w4tzzQb3SnQESRWT
	RNjBYEL4Kqj669a8XyJp0ekx2DCJiU4=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gentwo.org;
	s=default; t=1775815962;
	bh=03t8udNgjEw5kKsyxwAt5MOGVETnhJlUQnBuEMAtark=;
	h=Date:From:To:cc:Subject:In-Reply-To:References:From;
	b=W9A0yhlHTl6OYgNFVQXoCfP3RbDl0x1upKfUokGDbzRhMk8OVwCPCzY4Jd7Jfzecb
	 xN3ycty7b11QQsrK4EtrC3QW+g0+AWTK7Paln7dkk8QPhsKaz7jmjUaTl/mOIsUTje
	 Wncwxuh429Xe5ivXfXop99S3OAmblbrx3WZ7hly8=
Received: by gentwo.org (Postfix, from userid 1003)
	id 359A0401EB; Fri, 10 Apr 2026 03:12:42 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
	by gentwo.org (Postfix) with ESMTP id 33F4E401AF;
	Fri, 10 Apr 2026 03:12:42 -0700 (PDT)
Date: Fri, 10 Apr 2026 03:12:42 -0700 (PDT)
From: "Christoph Lameter (Ampere)" <cl@gentwo.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
cc: Ming Lei <ming.lei@redhat.com>, Harry Yoo <harry.yoo@oracle.com>, 
    Hao Li <hao.li@linux.dev>, Andrew Morton <akpm@linux-foundation.org>, 
    David Rientjes <rientjes@google.com>, 
    Roman Gushchin <roman.gushchin@linux.dev>, linux-mm@kvack.org, 
    linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] slab: decouple pointer to barn from
 kmem_cache_node
In-Reply-To: <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
Message-ID: <f29c0348-0250-b34b-59df-9dd59e4985ee@gentwo.org>
References: <20260311-b4-slab-memoryless-barns-v1-0-70ab850be4ce@kernel.org> <20260311-b4-slab-memoryless-barns-v1-1-70ab850be4ce@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Rspam-User: 
X-Rspamd-Queue-Id: 241FAC0006
X-Stat-Signature: ab9ins5hzhi4ysytfgehf4kxjz6swniu
X-Rspamd-Server: rspam06
X-HE-Tag: 1775816677-395172
X-HE-Meta: U2FsdGVkX1+q1nMqqDniEs8lhPDzXxfh9QPdrOrEeZrj+zbj9ptbQcpQVe57NLqMGWFIanBaaOdJfn5lZ3S/QkAunRSq43Sms+AOgdxYOQ/afuU0vC+x3itOJLDfhIYi2r7E+/LuYfxvWAjKv8d8IawSjo+N9fPbqXfiMTCz8OYZp0XYfXlS5N8gPju0y2OMBVRGW3o7Oq32hRpXKPRCenTvNDDQ/dcxJv+WPC1WnVdagK5ss1i3Fi+N6cHs9E3uUWY2m3p+EGLHyNTKjVI9jxWhqXsSGO/73dV+tv/YsLOUqR1xzAQVSboysc5P8HcOBrkyRk0RDt9yNTbvMBQKuv4yuN/oNAv1X07roRoQt7rTrto/7zpnmSLKfFNo5CtuZdNUvrxhYtx2f8zli14zGeDM5aZ7VZ61bneYzjzji9i3Bjkthj8oYG4CpuzdAMiY/2dZ2C0TJ/VPQ4hgIeNTS7BQq/Yz6M8ZepNRu4vN3nWO80H47FoINTklzxsaNtLBjSXLvhEmB4eOjJC+W3Q/t5DsUXIuf6CUasKWM0vbghviJPPX5gQxOa3jG2Zr3B7xO1R5oRbCJwpM7VglZAYIIrBAmZPvK9oMygOCGhEg16jStDqfqVWHOO95YodoHyG+zksxkmnPot+9c75Rb45XEgT4WuXdEqoEAHS44bNDkxFpv3GonNimTeZpShvjFQRJXQ1nigzkdTknUCuTd+1SULGtolE6ZsJbix6pjNUBaCFm3MZF52EioSYkVq7sjbsIP86dUxyivx0dTiGCIBNGdC67vPn7zoPZf7pDxwdQjZ8lIZDX2vpK3vlrkdlgrG72C0kWxwO8t7pjEno+l49ViGxNrh/v5iXwHi+xK+hYleFxioTXH7pKdjiYDrPfzCn3X0zk9x1SuB2dNxKxPzDaCMY+mm55xthu/1kpUOti4WYx9ZSBFHVo4hAEkU9wcMrVyCBe/bWWZ2cERNb31dJ
 4B/RpHML
 /D/PU8UGbEwzzW4Ns30uFlPP+dxSuM+5UwuvcS3dOvGxt9FQgqyDKsZ/wmuwPpRvSB07bEiVoPLaPPhn67iJbyjHfy3hrU7sxXK/qq0rxtfB6X6cNnyMALCVWBV06VjBx/OZqLuHSJYGIoX9+Q/x3XT718D9IxGKKHNKvPU8HG4BRSeJaFaPkFg3g/YLGFppjTGs0Sfy+8EP4oWD+N0oDVNgCJCyeoO2t0xjlDnERYseo1iekkJGdSmGkzx6FYAzMEbEPa450J+1uyjj2/E5mxD3M7/eg+vpSSPfMigcqIcc+IYEs3+nqD7N6Yw0oBpAadL8B
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Wed, 11 Mar 2026, Vlastimil Babka (SUSE) wrote:

> The pointer to barn currently exists in struct kmem_cache_node. That
> struct is instantiated for every NUMA node with memory, but we want to
> have a barn for every online node (including memoryless).

Is this breaking the 1-1 association of kmem_cache to numa
nodes? I would think you needd local per cpu queues on a memoryless node
for performance but not fake node structures. Per node access is already
serialized via locks and therefore slow.

If you break the association of per cpu queues to cpu and kmem_cache_node
to numa_nodes then the code may get complicated.

