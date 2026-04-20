Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id E9DDDF36C26
	for <linux-mm@archiver.kernel.org>; Mon, 20 Apr 2026 06:31:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 298BB6B0005; Mon, 20 Apr 2026 02:31:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 222386B00FC; Mon, 20 Apr 2026 02:31:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1113F6B0100; Mon, 20 Apr 2026 02:31:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 0041E6B0005
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 02:31:14 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id B1C728C4ED
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:31:14 +0000 (UTC)
X-FDA: 84677962068.06.991FD89
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id E5334A000C
	for <linux-mm@kvack.org>; Mon, 20 Apr 2026 06:31:12 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ax4LTAZj;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1776666673;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MSg9+8S1yJ4bLaIOmE0kGdRdSf8yDkD81BgdT6/gufg=;
	b=8NvuT3A2UuOvs4XLRhe4YJBO3iPjQJRD96BsCZsDyhl0CNnzHdbU6jsBGO0kbCEv5ZqjKO
	rYIOBi9vLHLYXHccxF4KKY2kw7Fpw9mlSJU/+/9806hIGjZ6+RD1pIHsmh/6ZNLIqdHWWe
	YR1cS7/w5Jaj58om2I0SBEwm3VYNcWw=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=Ax4LTAZj;
	spf=pass (imf15.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1776666673; a=rsa-sha256;
	cv=none;
	b=CaUTDn3C10nAt5/z/tIKLKAtozikJ/G3GWla1T6+0ShUMZeIgV0Jx8xMeQwYhFq8Wgm52P
	OocbUnLtCWZt5QxWZLOHh3KFFIXek1Zv1mfAidMWaS5b+BbiFcW71fhj5uVmfR98ijL+tx
	h+x9hnEEHOTE7I4BGHtNjYUP37Jkw1E=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 7003A44043;
	Mon, 20 Apr 2026 06:31:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E9FC2BCB3;
	Mon, 20 Apr 2026 06:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776666671;
	bh=T+14dheFRfDl50ykt/dhQ26t315HouYWfzp4yKCMiPw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ax4LTAZjr/J8+SBKsk3xMlCT5U8G3otZrL1re/iJRlTumLuGRDlQ0Er3AzJ8D5fC8
	 reLbkTiEEEyxxnvHHJUwbd1d7I9zx0iE7d0upxkymA4QMktwOUVr/xVVhK+lQ9XYMH
	 wpkYJPKN8J+auJplRx658py1M/LN6lOMk7lwOpMUvBmGeEur1CUqRxn2h5PhItVZgP
	 w0hdL9t3+rPrMtnPPMVNmD1y5PJz8HFDaPdfZIC77M3ZzX9tn7z4sCfzBPZRu0aYOI
	 cBA/7dZIyYB6W7NGSk5b1Po+uyonVZj4rKrpDCASdwcfCDapV/NQJFXD6AbmwhOqT1
	 tRDe0DwwHyETw==
Date: Mon, 20 Apr 2026 09:31:04 +0300
From: Mike Rapoport <rppt@kernel.org>
To: Sang-Heon Jeon <ekffu200098@gmail.com>
Cc: akpm@linux-foundation.org, djbw@kernel.org, mingo@kernel.org,
	linux-mm@kvack.org, Donghyeon Lee <asd142513@gmail.com>,
	Munhui Chae <mochae@student.42seoul.kr>
Subject: Re: [PATCH v2] mm/fake-numa: fix under-allocation detection in
 uniform split
Message-ID: <aeXIKM9BeRmaCZ_d@kernel.org>
References: <20260417135805.1758378-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260417135805.1758378-1-ekffu200098@gmail.com>
X-Stat-Signature: io4qz8p5bq75yt48imjyspdm4ssfbppa
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E5334A000C
X-HE-Tag: 1776666672-524465
X-HE-Meta: U2FsdGVkX1+FEk/MhGpJaWhsAvzq1MBpywOlLWtIOnIeHxuK7GAfxZT5BlAsbe4/HxDLPiXERVGZl4q3b6WfQZbhcasKbskFQJhqeJkNEFjNq1pOHbKvpT75gpDA5jKVwPlnoyn+1BJNgLpkmYigLRoGhW1gW/iHnLYtXaPjcqDaswNAFYOM1qDnfzQig8YixakBX/04YXJwf32WmU+IwmDicq7apkuwmuWvofWjulY2eYF4umyvkwlep3QLS3zLBA5DBDWmnNoqn2VXE3oL1NoaDoWEVXgvInpvlWNUlrNqRqpP+V8NbBJ3mf3Di8R0etkH6gupTFPI80FB+PS8xcqW53WvRfI+/LDPf6j2N70X0RTkqH2A4IRpX6i0kbgFnjaLify2d9G9N4wOZA/+8+Igb30ibCNVBRuvibXzWl3/YZqzJTDwalMlmu2V3++hjEc4D/BZnYiDcmLZccZXwOGv1KwUizzrsCVpAJcf6RZnn0/f7lQ8dqrw5tLP6xfTFpkPBE27x9dyccosuDd49D2J0vY468syR3LjXWdz+LvMt1jC2N5DBl97V1y7tr5kuPzHu0OnwH5QLkGN6Fh4wEY4+lPLOEr8IVdN0+4dTSYxwTofjt7WdTIFeT8hlAN6fcOL0gTn5phb1kfdGwtMLN5aca1qADsxRMX5FLXylaMaZzXjq2jqVFxPfx/paxd788IrncVrSA14lilKbOKqESCXMdzzQ3Dqb4N/2vjkcL99uZS9SHt74m6/VcRIDGsnTrl13pZMAJWlZFocq5aJwAp6tnTJmG6F8ZhcorNS9LRJRw5Igbnrql1TwZJtKKc4vnMuUk7wvQHOVCGjtnAx/DeiL4lhQ//LKuUH9Jfu2VrakhtPRkBVtxySsNE6RcKmMCh7UjQRFlPtIpj5zjB5EWk2QxLZRI+3Dfcox5Ne/E/4zYqfOePC5EftGWndICOcutfyiiE+33hzNpVWO+m
 u5dsXajQ
 TJuQCMSQNLKWzxRlLaMRG5Y8VNru90I/lU/fmd66rBAEtVUY34F7LlrNoynb8kHw9fAwY7Zys37RrLExhP/d8sp7Z3kxKynTusYXfMY2bysv2H076e4p81dRWJaKwI1Ya2wZmgiX+0FFs/4r2kNl7jyOq8z40V2Hbkoe2sZidbuKPPCYO0hwgnxVETiQ1bW570f7uJENaNHELgdUbsi4Oa69MHpu/VBw/MBWNzIhn4xu9Ii6szSSJtYT8chAZ4XGdosATybG+zp5F7Y3127JJh3DU8w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi,

On Fri, Apr 17, 2026 at 10:58:05PM +0900, Sang-Heon Jeon wrote:
> When split NUMA node uniformly, split_nodes_size_interleave_uniform()
> returns the next absolute node ID, not the number of nodes created.
> 
> The existing under-allocation detection logic compares next absolute node
> ID (ret) and request count (n), which only works when nid starts at 0.
> 
> For example, on a system with 2 physical NUMA nodes (node 0: 2GB, node
> 1: 128MB) and numa=fake=8U, 8 fake nodes are successfully created from
> node 0 and split_nodes_size_interleave_uniform() returns 8. For node 1,
> fake node nid starts at 8, but only 4 fake nodes are created due to
> current FAKE_NODE_MIN_SIZE being 32MB, and
> split_nodes_size_interleave_uniform() returns 12. By existing
> under-allocation detection logic, "ret < n" (12 < 8) is false, so the

In this example it would be 11, won't it?
I'll update when applying.

> under-allocation will not be detected.
> 
> Fix under-allocation detection logic to compare the number of actually
> created nodes (ret - nid) against the request count (n). Also skip
> under-allocation detection logic for memoryless physical nodes where no
> fake nodes are created.
> 
> Also, fix the outdated comment to match the actual return value.
> 
> Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
> Reported-by: Donghyeon Lee <asd142513@gmail.com>
> Reported-by: Munhui Chae <mochae@student.42seoul.kr>
> Fixes: cc9aec03e58f ("x86/numa_emulation: Introduce uniform split capability") # 4.19

...

> @@ -416,9 +416,18 @@ void __init numa_emulation(struct numa_meminfo *numa_meminfo, int numa_dist_cnt)
>  					n, &pi.blk[0], nid);
>  			if (ret < 0)
>  				break;
> -			if (ret < n) {
> +
> +			/*
> +			 * If no memory was found for this physical node,
> +			 * skip the under-allocation check. 

checkpatch complains about trailing white space here.
I'll fix it up when applying.

> +			 */
> +			if (ret == nid)
> +				continue;
> +
> +			nr_created = ret - nid;
> +			if (nr_created < n) {
>  				pr_info("%s: phys: %d only got %d of %ld nodes, failing\n",
> -						__func__, i, ret, n);
> +						__func__, i, nr_created, n);
>  				ret = -1;
>  				break;
>  			}
> -- 
> 2.43.0
> 

-- 
Sincerely yours,
Mike.

