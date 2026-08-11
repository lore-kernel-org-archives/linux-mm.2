Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AD3A0C5AC67
	for <linux-mm@archiver.kernel.org>; Tue, 11 Aug 2026 04:32:07 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 382706B0092; Tue, 11 Aug 2026 00:32:06 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 332A66B009D; Tue, 11 Aug 2026 00:32:06 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 248C06B00A3; Tue, 11 Aug 2026 00:32:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id F1A686B0092
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 00:32:05 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 8BD8F140316
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:32:05 +0000 (UTC)
X-FDA: 85087716210.30.392CE21
Received: from out-182.mta1.migadu.com (mta1.migadu.com [37.59.57.117])
	by imf17.hostedemail.com (Postfix) with ESMTP id D0FDF40004
	for <linux-mm@kvack.org>; Tue, 11 Aug 2026 04:32:03 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=okguh+11;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786422724;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GTngnHPe1Gqy+5LwJJcOK53VCVVuZACNEtnsThA2J0k=;
	b=P9NuZb0iXMvRKzMlqZDdiFfGLJQPuNf/UDAdsWWF0VzKnoDjbNEvxvP3ho7q9WbRDai/D0
	Y2jPBkwNycHUXDAzxsImvb+HH6T5Z7Up0YJBq3uaZuVCEat6holcU8D6lV/Q8gIvVm6XHi
	X3jda3GKAL7p8RhhrLXmSvDch8sHIkw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786422724;
	b=UAw/05ML2zy2f/v0RYA9lFRB5PuhL0J5xTkGh+Sg0KWmsRaD9LRD5DLtmlAJl0F7KcEm6l
	3CjsxCUBjnWdk2hHdvVe4D12q4LUz9VhxVUsXf/C/eLrZKY7/LAIldzQGrDbRUvuf0bJwB
	4QNgdfqHKD6zFe8HSQuFy9Tj84iORE0=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=okguh+11;
	spf=pass (imf17.hostedemail.com: domain of shakeel.butt@linux.dev designates 37.59.57.117 as permitted sender) smtp.mailfrom=shakeel.butt@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
Date: Mon, 10 Aug 2026 21:31:39 -0700
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1786422722;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=GTngnHPe1Gqy+5LwJJcOK53VCVVuZACNEtnsThA2J0k=;
	b=okguh+11lTwJyUXg1H+ENk09yn1C4YYv5gcEpnnolfNwEFUvN58y81/ZkqPfzgCGfrSsVP
	fLapUNRsoeWLcidPHwRgv3+/8wJ+BX1K5FATo71VLkXXpU33P4R2FXIvJs5xP1co+XPgF/
	3IQ/lenlFf7PZDCarqOjSbgleKCLuSQ=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Shakeel Butt <shakeel.butt@linux.dev>
To: Guopeng Zhang <guopeng.zhang@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, akpm@linux-foundation.org, 
	roman.gushchin@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
	Guopeng Zhang <zhangguopeng@kylinos.cn>, Michal Hocko <mhocko@suse.com>
Subject: Re: [PATCH v2] mm: memcg-v1: fix memsw and TCP failcnt accounting
Message-ID: <anqlhbQ8BSJ1AKQ4@linux.dev>
References: <20260811030843.109104-1-guopeng.zhang@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260811030843.109104-1-guopeng.zhang@linux.dev>
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam07
X-Rspam-User: 
X-Stat-Signature: 89rzz1zridxe4n5bafrbxajexksygjm5
X-Rspamd-Queue-Id: D0FDF40004
X-HE-Tag: 1786422723-649954
X-HE-Meta: U2FsdGVkX1/hkdMQZM+DYeXfKO55qDexTWwwCRyDB4zwmHnvHyTYXIrYXXzKBK8m++h3raRmxwELljRDbS+Fx7To8I8xmaZpZxClYPJuc4GbgeUzL5q0Sk/dV/uPmZ/Q2pFqBPOVjmhKKQZs4DLa+dCYrr4C412DKkPNARt44vmpja7I8r06rn+diUdAe6ESvp4yAiVslGpVbGLUAimgFlkHVIy3SQXOqYqtu5CW1vfbm+3EAzmJSmngTA4Urktm+FetA+teXlOK5+1mQv9KLjIEld6I1TYn+peKeq7YzO8Y9xxYqdAV5XZLxQWBgwxVtsGAUpf7n0jIRO95it3cL7zn4HeI58Kc0Qk+qPb5R1k+c9RKhth5mS9xaXBIFE+hyYXKgApbkHTMO+/xGwjw3HMA5c96tLlPy+txVBI41Abu0OD3FpLBzlg27aO4QTmUCt0/k4XBiMJvgd042bnxO8ezPG+jrpsAVcRLL+iZ+pdlZi/bMgm1KrggsnV9Da6xGTmcpEYdNokSJxy3w5Hpi2Ems7kp7PXNee7btYFjhZV/PP2RLgFp3/01qcFXNhr2doB/+CXsSiKrvzjIMFoIrT3UI3XAl6JtY6NxNagOTgI805x/ZPurs9nNxDAjjH875Ld26nRbACaUBS240hJwzT7nzBm8WYWSxChlSQbUNf52ZtF2wsT/5bC0ExcRZ4KdQNCTcZ+EXkmUFmTTuTP2htrUx3wUPVkvHBXFJsFDNvcUdwamBgtqzlK3Wv/vMajnu48fuV8X6h8kiWav8Jr0IXBqOLEoytgc6Lh6HuBCpYzRzIx2+EMEQ29xYzHYFWfGr3gbMkec6xvLDBnKxo5RLZUy/SB1pfVa/GnQk0cm51ZBnS6lrkeqQBEaIsg8xalxl3tqqTwOT/g6Z2JeSDI4jvy4VySEGIRYcvye+6IWI/nEwEsBl2yheUZfq1X9oHnVs4Z0/LVylLHllwz7tvr
 zKUFvfjt
 32/uxBpDTVr3/TSkje/Xd44l0Pkri594bLw0pPb+/sirLk2NSJ6v5725qR5zydv38j/tP4dhvBo2BsSt5i2n5CdDQ8faPeqxFSpQktCqw64kJY6Dmjd+W6yWRv/o8UxIGNsPd5tzzq0LUEcNOm99q+vbMK8UkafIgnb7RGb1+DV9jOEwVXTWHqN/xZkBUleM2wk6htouhnI4kUAD49cXwSk61L+tX/1t+dlrEo+a+e4P/JvGzvRuM9ydUY54dH71YaR8RCtNsgrF3NrS52NV65snbe3BK+dg7iAVwChed5clA1lNoZ/T5VQqBVGMQBDxtdWio9Q2ZfwLDc91SIUV73pA/Kphu33JIrMbdQVWyaWTwsyfxVxA9tKyxCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, Aug 11, 2026 at 11:08:43AM +0800, Guopeng Zhang wrote:
> From: Guopeng Zhang <zhangguopeng@kylinos.cn>
> 
> Commit 0e2759afcaf9 ("page_counter: track failcnt only for legacy
> cgroups") made failcnt accounting conditional on track_failcnt. It
> enabled the flag for memcg->memory, but not for memcg->memsw or
> memcg->tcpmem.
> 
> Consequently, memory.memsw.failcnt remains zero when the memory+swap
> limit is hit. memory.kmem.tcp.limit_in_bytes still sets
> memcg->tcpmem.max, but TCP charge failures are not reflected in
> memory.kmem.tcp.failcnt.
> 
> Enable failcnt accounting for both v1 counters.
> 
> To reproduce memory.memsw.failcnt:
> 
>     CG=/sys/fs/cgroup/memory/memsw-test
>     LIMIT=33554432
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.limit_in_bytes"
>     echo "$LIMIT" > "$CG/memory.memsw.limit_in_bytes"
> 
> Start a child process in the cgroup and make it allocate and touch 96 MiB
> of memory, causing a memcg OOM.
> 
>     cat "$CG/memory.memsw.failcnt"
> 
> Without the patch, memory.memsw.failcnt is 0. With the patch,
> memory.memsw.failcnt is greater than 0.
> 
> To reproduce memory.kmem.tcp.failcnt:
> 
>     CG=/sys/fs/cgroup/memory/tcpmem-test
>     LIMIT=65536
>     mkdir "$CG"
>     echo "$LIMIT" > "$CG/memory.kmem.tcp.limit_in_bytes"
> 
> Start a child process in the cgroup, create a TCP socket, and reserve
> 1 MiB of socket memory with SO_RESERVE_MEM. The reservation fails with
> ENOMEM.
> 
>     cat "$CG/memory.kmem.tcp.failcnt"
> 
> Without the patch, memory.kmem.tcp.failcnt is 0. With the patch,
> memory.kmem.tcp.failcnt is greater than 0.
> 
> Closes: https://sashiko.dev/#/patchset/20260810074247.52747-1-guopeng.zhang@linux.dev?part=1
> Fixes: 0e2759afcaf9 ("page_counter: track failcnt only for legacy cgroups")
> Cc: stable@vger.kernel.org
> Acked-by: Johannes Weiner <hannes@cmpxchg.org>
> Acked-by: Michal Hocko <mhocko@suse.com>
> Signed-off-by: Guopeng Zhang <zhangguopeng@kylinos.cn>

Acked-by: Shakeel Butt <shakeel.butt@linux.dev>


