Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EE3ADCD342F
	for <linux-mm@archiver.kernel.org>; Fri,  8 May 2026 18:31:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 4B5A56B0255; Fri,  8 May 2026 14:31:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 466B96B0257; Fri,  8 May 2026 14:31:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37D7D6B0258; Fri,  8 May 2026 14:31:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 27EB26B0255
	for <linux-mm@kvack.org>; Fri,  8 May 2026 14:31:27 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id CBA06A0291
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:31:26 +0000 (UTC)
X-FDA: 84745095372.22.6295F2A
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 1499510000E
	for <linux-mm@kvack.org>; Fri,  8 May 2026 18:31:24 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xghED1y5;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1778265085;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zDLJT6CxafEQbg14X661fllXLvDPnqZiW/FlqYV37yc=;
	b=EZJJc5ZF6dBapkM56xN2mQzxjW9DgipPf7iBcwuOLIhRb5MRC/Pvinzp+6EKyTHaO0EGFx
	JWm5Yqie+tT7DcaA3wxfGpAroTzZLPLVMs2ZOSks3NEeR0hT3UdXJgsmvzi6tOVYYeWDEJ
	Ix5SW9HEWQ1yfNNddnAFwEwgigSt11o=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=xghED1y5;
	spf=pass (imf05.hostedemail.com: domain of akpm@linux-foundation.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1778265085; a=rsa-sha256;
	cv=none;
	b=oyP24iZkWN8SEa+cLPf6xiuyQmJCeVJx2g3Dr0BYqEiuLQONZ02dYei7q00yHRH9gnghAu
	7+WC+mVmCXZVM9mzl3N9S7/REFx2Hr/VfZr2xHJ6+Q5QpmeNjdj4M0VvWh3EI4muwEkvQH
	vScWxTz5vhdBxt3r3DEC8Ehiv4c32BM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by tor.source.kernel.org (Postfix) with ESMTP id 80BAA60181;
	Fri,  8 May 2026 18:31:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03BE4C2BCB0;
	Fri,  8 May 2026 18:31:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1778265084;
	bh=1THTx1MNdQbS8SAzVpR4M/ng9K2023DslkdCdS096cE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=xghED1y5ak99PyTic9otbxraN/bOP99QbR1j9ocdEokqGW8e1yzqLofSWT9n1luPZ
	 ADFRaxjVnYoJcSeDECqjxYVhzSCsul5vgR+r31JIpVmxptrnkXCiSh9vBa9QDporFk
	 YcYmFhNn6Ejs1+IQZGK3SEkSzjSVaB4bMAkVbKoM=
Date: Fri, 8 May 2026 11:31:23 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Hao Ge <hao.ge@linux.dev>
Cc: David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
 virtualization@lists.linux.dev, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] mm/balloon: expose per-node balloon pages in node
 meminfo
Message-Id: <20260508113123.c8e653484d39e76cdd6e142e@linux-foundation.org>
In-Reply-To: <20260508094736.142467-1-hao.ge@linux.dev>
References: <20260508094736.142467-1-hao.ge@linux.dev>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1499510000E
X-Rspam-User: 
X-Stat-Signature: uu3zz1y7s4jk6b5a5oa65kdwsw1azsux
X-HE-Tag: 1778265084-835630
X-HE-Meta: U2FsdGVkX187G1bXGhzRSYjTPfTS/CMPiY9aPGdS4xqc/7KGbKpAjT2X8DIHZRDoQCO6UuRQnhqfm8Ppadk4Wjb8xrH5IS3EAXA7SuRvvIbU3AqwnC6d7x373ODAo/XaWqv4Qlm643KGsbjezLLef78b2zAJA+Rb2e14bJq/PrW2JGiEbe6ssf/JrZiEwfJfbA3c4Fq4H33bAGmX496UsNfAYc6SHBbJJeaYofks7/4HUdAtQYdMKPsUEivHINpeJfHWZMEXBaQdGedtI8XVyNi6+eVEhY8o2rewlnM56O6kS6UODZSAnwIwvgt4fzbzXMp8BkwSsltUvxpjGfEgFh58AUrH/wIxQxbG+8RQuCRrn63aciC9N46ylQWmJl7Qn/lOk7A300gcQbVxWNmwohCVCTqh7x6+MSBehaigzhdUiV3SSX0p30p5/n85rRGtKOdm0atJc4k8FeJiZkr/SFH7W/SEjy0ysg5ItaWInTitDqimIQr9JS/aN5DXpfL0e+cbepeFQ+sBAMT2fDPjb+J3KEgY7RQ5+dT85bdCCUD48Hn2DZC7s96L3/MTIw95YDHUO4HiIQA7VasGtXsQGW2AUCBqrwJp1de8ywCcHLt3jgOdNa7fwkNqtY+N5kLJ7y/L5kahl5mebmD37ct5CX4HnCB5LBI8DxuBDSm5YmY/FfisWT0hcsPRkUVAnm19NbsbgPXTp3O1BvuAATYsGP5hUoKVf6C9b4ZFx7DFQ0A/DsbOsZh9BgsoyOKhnpK1HkeWMAOjBsoO2770EopmuDYfN7MjPDi3LudliIXI7edGHZfDOwr29+aKTdZoZKhIwkU8OE+OlKAqWdk8T+CSOhF1pEQ0tfYgSBMHRLJQLvo9heH/+Nuigmu+YkXU23tKQTl5brcaHoc9CbxfzFqqkagGgrMkuI+Cw4LOr/Zk4XQtRF9VKHpjj4JjQr4WTZNAqtxFELDfdS6f59dU9YR
 SG0E7Wst
 P1HxiEk7hrqYPrHF5S64KqVJfAo7KuM7Nx/lOapa8Ex77glxRGXTmUqv190ggSsG2XGEwPREvBgzIaXRVKfriyekt325Q/7d4b0F8AFQcudza7tFlOYK/6KeiThLUpf2lIXVeZFvnwgkaEO5NU4Wyw5PQU0UUbC9ouIzf67rhC3Hwe0xpSM1lodEY36rfWZBJejTn3nA5e0FmKRW9jr2zPj/ozmG5M4oQ+J1A3fEzQct880azyVSB1OhJPg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Fri,  8 May 2026 17:47:36 +0800 Hao Ge <hao.ge@linux.dev> wrote:

> Commit 835de37603ef ("meminfo: add a per node counter for balloon
> drivers") added NR_BALLOON_PAGES and exposed it in /proc/meminfo.
> However, the per-node view at /sys/devices/system/node/nodeX/meminfo
> was not updated, even though the counter is already tracked per-node.
> 
> Add it to node_read_meminfo() so users can see balloon usage per
> NUMA node without having to parse the raw vmstat file.
> 
> ...
>
> --- a/drivers/base/node.c
> +++ b/drivers/base/node.c
> @@ -523,6 +523,7 @@ static ssize_t node_read_meminfo(struct device *dev,
>  #ifdef CONFIG_UNACCEPTED_MEMORY
>  			     "Node %d Unaccepted:     %8lu kB\n"
>  #endif
> +			     "Node %d Balloon:        %8lu kB\n"
>  			     ,
>  			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
>  			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
> @@ -556,6 +557,8 @@ static ssize_t node_read_meminfo(struct device *dev,
>  			     ,
>  			     nid, K(sum_zone_node_page_state(nid, NR_UNACCEPTED))
>  #endif
> +			     ,
> +			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
>  			    );
>  	len += hugetlb_report_node_meminfo(buf, len, nid);
>  	return len;

This was prepared against a kernel whcih didn't have 2232ba9c7931 ("mm:
add gpu active/reclaim per-node stat counters (v2)").  Which was added
in February, btw.

Please check my fixings:

--- a/drivers/base/node.c~mm-balloon-expose-per-node-balloon-pages-in-node-meminfo
+++ a/drivers/base/node.c
@@ -525,6 +525,7 @@ static ssize_t node_read_meminfo(struct
 #endif
 			     "Node %d GPUActive:      %8lu kB\n"
 			     "Node %d GPUReclaim:     %8lu kB\n"
+			     "Node %d Balloon:        %8lu kB\n"
 			     ,
 			     nid, K(node_page_state(pgdat, NR_FILE_DIRTY)),
 			     nid, K(node_page_state(pgdat, NR_WRITEBACK)),
@@ -560,7 +561,8 @@ static ssize_t node_read_meminfo(struct
 #endif
 			     ,
 			     nid, K(node_page_state(pgdat, NR_GPU_ACTIVE)),
-			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM))
+			     nid, K(node_page_state(pgdat, NR_GPU_RECLAIM)),
+			     nid, K(node_page_state(pgdat, NR_BALLOON_PAGES))
 			    );
 	len += hugetlb_report_node_meminfo(buf, len, nid);
 	return len;
_


