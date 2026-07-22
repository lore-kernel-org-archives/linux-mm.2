Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 006C4C4452D
	for <linux-mm@archiver.kernel.org>; Wed, 22 Jul 2026 00:13:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C5D776B00A1; Tue, 21 Jul 2026 20:13:55 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C0ED46B00A2; Tue, 21 Jul 2026 20:13:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B24BF6B00A3; Tue, 21 Jul 2026 20:13:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 8C4016B00A1
	for <linux-mm@kvack.org>; Tue, 21 Jul 2026 20:13:55 -0400 (EDT)
Received: from smtpin05.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0B0941402EA
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:13:55 +0000 (UTC)
X-FDA: 85014489630.05.4904F17
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 565578000D
	for <linux-mm@kvack.org>; Wed, 22 Jul 2026 00:13:53 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nJPZ26zo;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784679233;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=V+aY/Lsw2VDgBYyUllYNgRGhKE2XyNDmp9Ld83OgmxE=;
	b=wI0TEPM0DHH8ti6potxYybpzP6Nt1Ou7uVkBUY8rbgcppbb5cveqlabzG5pXiTsag3fCoS
	ryIx03TRw0EhLRV08asH2ph1GB5Itf0Qtxu4YpkfuvNflk8OxiqTbPZB3TgCpKq37mRUAW
	6JiO09CbRM6F2Jr8hRpIkgJ4Y7k63iE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784679233;
	b=QonThQT4Pnz5Eo6ZP/9mbnLqm65QF0Hir4resSb8dK6+hetPI5jhb+uUDMre4qEJaDHFuK
	RnIVsLfzamSHXkLEAHRQ94cfKousg6sTNf0NAXMiaqrr8YMUrDdlMVVjHsnTFfvb7AxdD0
	c9IQxmUQbhXUvg4sq3AikzJvXQAFyuE=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=nJPZ26zo;
	spf=pass (imf02.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id A0B07600FC;
	Wed, 22 Jul 2026 00:13:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B9CB1F000E9;
	Wed, 22 Jul 2026 00:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1784679232;
	bh=V+aY/Lsw2VDgBYyUllYNgRGhKE2XyNDmp9Ld83OgmxE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=nJPZ26zoK7PeHw+emQhxgCgwLn8YyeMkqi0Fd4RjQd5+al8q4OAvP9ctMVjqJe71s
	 GXL9PO9z2mVWG0Uu2MmY07PnEZYg6BjBNgiLvcCure2j6YIlulDZFkgrI9SS+PwYlX
	 5QVyAYDb2uhDygxWGjir4LpcpLmowxGRf3bDpgms=
Date: Tue, 21 Jul 2026 17:13:51 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hongfu Li <hongfu.li@linux.dev>
Cc: hannes@cmpxchg.org, mhocko@kernel.org, roman.gushchin@linux.dev,
 shakeel.butt@linux.dev, muchun.song@linux.dev, cgroups@vger.kernel.org,
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, Hongfu Li
 <lihongfu@kylinos.cn>
Subject: Re: [PATCH] mm/memcg: check kzalloc_node() return in memcg1_init()
Message-Id: <20260721171351.ec213c13afab38b89c14f849@linux-foundation.org>
In-Reply-To: <20260721100916.76822-1-hongfu.li@linux.dev>
References: <20260721100916.76822-1-hongfu.li@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Queue-Id: 565578000D
X-Stat-Signature: mj6xjcfeza9esaqu1uoumbkjo8tcsprk
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784679233-935350
X-HE-Meta: U2FsdGVkX1/zHCchPfMr7nGdRVxonQMrRYBA/tiyUm7SAQz7IxxcZO+r075JJ932N7S6lHraiozADK69nLnxaQgcpMFLNkVr3uqsQeeZJMy1N6lR1IEsXLz/GPPlGgmg86Owv9wYTofWrOYTSeLM0lZZXNRABNijT5Xc12Ct6RMI9RDTlm8aQnY2i1JHDuSVgA6HQKHkLZCw9gRf5Yj6i+P2vEjQKvmzoHcbQnkOkBWRNw7amRJTKUzK8tt0gdFPitvig/ADszo3cp+u5Mx8AUcFKG+X6aOAnLpPqERqGiTcj2lWaqpoJNMR6Y7Qk+/hOeDkJkM+46EcCixjE8/+VrpWE/F+vOEd/RuU2fY8F8ZeckQMaIxe/e56y6DL4RAMp4qe8mFLE0JS0oS/4qNaxRlz/ZrCfUv5god//MDpbhPvXeughsAsKZpHu+Wl+mOYPsAWbMjdFB7/H0DPKiYSPutNAvpo8DvrlShTd//nxh4WhdKqMUTn8wwQKTgv2uYU2A6XSLmextQiy0F3AefW9S/bHAFlXQqTyJ8U5mOmpSMhNOWDGMRUEon3PkLaEnPmeO7aQidCh8rM2QqNU0N4q1CQFKxxY6J2JmVLAYB49yMCAvw3jCYOAohwYFVHgB7gyLwzA1OHREGy3Vg0qmrXFoIsAkbcq5eRGcfw4rHkUB0LdEcOK9WBn6AQrhetegdjsz87ZcoozWJibEPKBWontW8tXzosSCOKzCcG3jeh1/zjYXhtcyGCJvPSxAROq0I+Lx8la5yCcYmE2HZ4Lb2qiwWzol4OI3AS/1nAPTj2j7q6u30cwaeY3zhmMOWiY/q4zQ9EU6KThxduHp/UdCM+54gFxlRRX6OFja/Aa11cp/r6K/G+eex5VWrkz3kB22NrTc6UqxebqiyWC1jcFlqNwy5FIf+EZ3xCkQJW/aAQWD0P9Si6pODiAcrnvP+chkP/y1RklNndFgGCO6zS4Wb
 thqbPhRi
 86wBTEJtsI/aecESJ5oYWjulFmXqml6oIvgh6LQrrnE7pzL7ogr+ZbykCJNJVyJwbo31stG245CBHESfNJtLFeVojZAiN+jyzYPvMqO2sU1jkhQQrueY7mW+xgEDod3vfBfNmOOkePP62FZ659ISsi2Ym+19cJAep+G1IskV4VD16qInGUtjiE4vzFvjjgfA/17N4VS7vZ56zio65v2HoojJFyPHlutqb1XlRRg6tQlCBY16Q+vBmM6+VG++9TFcX0ZQGMwOOb14sZD/M33NZPhM2dtEBAb2/31K5sDmMU4NNr1g=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 21 Jul 2026 18:09:16 +0800 Hongfu Li <hongfu.li@linux.dev> wrote:

> From: Hongfu Li <lihongfu@kylinos.cn>
> 
> Add NULL check for per-node kzalloc_node() allocations in memcg1_init().
> 
> Skip the NUMA node when allocation fails. All users of
> soft_limit_tree.rb_tree_per_node[] safely handle NULL entries, only losing
> soft-limit tracking for that node.
> 
> ...
>
> --- a/mm/memcontrol-v1.c
> +++ b/mm/memcontrol-v1.c
> @@ -2566,6 +2566,8 @@ static int __init memcg1_init(void)
>  		struct mem_cgroup_tree_per_node *rtpn;
>  
>  		rtpn = kzalloc_node(sizeof(*rtpn), GFP_KERNEL, node);
> +		if (!rtpn)
> +			continue;
>  
>  		rtpn->rb_root = RB_ROOT;
>  		rtpn->rb_rightmost = NULL;

Thanks.  We assume that mamory allocations cannot fail within __init
code.  Because if they do, the kernel has some ghastly problem and it
cannot possibly run.


