Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 850EDCA0EFF
	for <linux-mm@archiver.kernel.org>; Wed, 27 Aug 2025 21:25:28 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BB5AF6B0026; Wed, 27 Aug 2025 17:25:27 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B387D6B0027; Wed, 27 Aug 2025 17:25:27 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A277A6B002A; Wed, 27 Aug 2025 17:25:27 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 8EB5D6B0026
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 17:25:27 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1485F119516
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:25:27 +0000 (UTC)
X-FDA: 83823818694.06.CE367F7
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf19.hostedemail.com (Postfix) with ESMTP id 54AF31A0002
	for <linux-mm@kvack.org>; Wed, 27 Aug 2025 21:25:25 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0fgOo7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756329925;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=o3fUgG5f2vu/0OwLbBVeLQMcS0OCbWT14OuHdyKjGik=;
	b=6X4MSWKbxSEBR52grGC1M8oVXa52mRO5ZqNwOAxzZXdG7b88asFI3zppmIH1uDjlydC0yj
	oUgQrO20nuTUlDDSLJxahzlimSQ2EjGPrd79O9xsfFp/H5L1xvpjyFeBV2L5wWYkmpesIz
	xdE+ZxjG0ap2E1IfsbnstK69NguFZ8g=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=a0fgOo7+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf19.hostedemail.com: domain of tj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=tj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756329925; a=rsa-sha256;
	cv=none;
	b=cpFmm654uLyCnzT6EylVLjnJ39CL1J3v/1yL6VXWwg71yq06Wkasq1IrSTLtqeGz3AHQR7
	3uWUaqe7/vd/IMcf5TjZdX54E+O6maiDl73q7dT1hUXomXOPnK2+1lRg/ehp/cR/Laotez
	HBUG2w1Mn98r0TtxE8VZtFWqrGfdiAg=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id EDBE7446F6;
	Wed, 27 Aug 2025 21:25:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD487C4CEEB;
	Wed, 27 Aug 2025 21:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1756329923;
	bh=5OMYFTfAZenqHJvI/KeLzgzyAGUa92DP82jO8Lk7lCE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=a0fgOo7+ta+dTLjSrZ6sX7jIbKdge8pTD8E5C6sujcDi9UNHrAMZXYlHTHMgcxDJt
	 uk5LDr/L4xQgimz1UQvN36+mu0aA1jKLmDPY7HRlNAADZ95Hj1FBUgwpjXGamQPfDo
	 KhhtXXBazYj7DR9iqTbL3y5Wo1KA+P6Wnz+vetjAsYFozXKdooipRpTngEh//hoCmX
	 wt/unKt9FqgqWteDJ/2t2dnfUBGbrPhBN+/YLtYJegqTUS1tk5vLmnRuYznZ+4GWQg
	 8jPyK9CFoiZ0dKQC4Hd+ay9+JLHzby8mw0bxPelLr4NQ59ybjtagIC/3LZfSkbaydl
	 R2lx5+wx1RudQ==
Date: Wed, 27 Aug 2025 11:25:22 -1000
From: Tejun Heo <tj@kernel.org>
To: Julian Sun <sunjunchao@bytedance.com>
Cc: cgroups@vger.kernel.org, linux-mm@kvack.org, jack@suse.cz,
	muchun.song@linux.dev
Subject: Re: [PATCH v4] memcg: Don't wait writeback completion when release
 memcg.
Message-ID: <aK93wg5kdgVuL6rc@slm.duckdns.org>
References: <20250827204557.90112-1-sunjunchao@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250827204557.90112-1-sunjunchao@bytedance.com>
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: 54AF31A0002
X-Stat-Signature: 8en96s13hs67m5rzh44i37rjijrwc4h9
X-Rspam-User: 
X-HE-Tag: 1756329925-593015
X-HE-Meta: U2FsdGVkX19tBBt8xxZPaBZqBaVK03zL+rNBRijjlJQk479Wem5O7mgoEe9ag9Emmn3lsxd2gNs6Q1i0cPAQGAW4IDNIKodTisUeXv7j61spTASgNtlCAuRebpKNgEGr0nVZnuxYyg7QWPEVD2I4am0W82I3RarUjSe0I0eAl8eV3P7lUoOqm1gX1k2HyfurLcSDFNr6+DjwQ/ZDz7dS3m4EVyEvN1SjoVs2gkRqI6Zl7J86PR1lcyLPP7RAMjZaerTp7oCpyMO5niWa6zyoUqr42UxanJyAPwP4Zu7mwNerD2GRg10BGVTKBOOIEyQt2b3z2/WWaUJzOnroNm3TkUNMzScvD8JNsAetrG3BUvnaIDdcbSoevKsMDKPscueK6xGmm2UDbBK7s25YqKsXSQz4rsfRsi8x5NKk4mNryEHG8kTxVVX3GOcljo0gaI3sbKuqupz7uUfRYL3z7Cjh/u4jHkVlcaAquGYnnmSX7KFzpX7X77nbdIRsDmB3UpEshTAt5F57KnJitMyEQPOdRBdELpp6yveiLtG9LrYEByuLtvO0XyxTy0jCjDDNx1rUA/AheZOVdYwrhCE+MVmpWFuW2YRkQKkszuaCOBEacoxNpHLqUONHWlD/+brwucUMpKfdaDaPA3mFHP3PWnMAbMZ8bbSAtH7TxiG0UF7Eg3zuCGDOroVGipXsDAaoc230ui+ux4xo4IlYscsk7ucq0svI7Vds69BrJWKAYrydTtI/8PM4aA5c0qOnwoCXO7MhXibRuNnWvz5SAE05OXMbaFNJbjtYJyMzrHGW4INKNVZW03Nwd1YwSrIiyAHaWiTt9NQ6yNVGTi1zQj9k3K9TQXHchRL4EJfsv4YfF/Wkbxj9u6i6752+yUYGMYNAePvU8NucepJhmAbNNU8cYYTvCITsKDvQrUwJ0naypovxNTNj7NeG7e4ZuFQdPMzaWKJCIzrV+Zysdtb4leg5FzD
 SPDrCYwh
 tg3OVTsTZd+p71zB+ZrH5hjM4MRedGE0eEOknDMyfASYfa9jNRPx23YrE3H7sU12hK154O7ih/GRT7BCbglSX3jac2wZJ08VLEbrOSBFxzIW48IRTsnKAYZTfCEJhJUyGrZAYtQ+mNC0Minkq7jy3XIYcwEK0LyCsIKQmN2UnQsJTc8Zj/QFA+yoznm+p7nsXk0c3Y+kxUTOEunsa5L23CEnCb6c0EloK672NEm98WvcybeD+VW+y8gAlbGN5kV0UNdg0
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Aug 28, 2025 at 04:45:57AM +0800, Julian Sun wrote:
> Recently, we encountered the following hung task:
> 
> INFO: task kworker/4:1:1334558 blocked for more than 1720 seconds.
> [Wed Jul 30 17:47:45 2025] Workqueue: cgroup_destroy css_free_rwork_fn
> [Wed Jul 30 17:47:45 2025] Call Trace:
> [Wed Jul 30 17:47:45 2025]  __schedule+0x934/0xe10
> [Wed Jul 30 17:47:45 2025]  ? complete+0x3b/0x50
> [Wed Jul 30 17:47:45 2025]  ? _cond_resched+0x15/0x30
> [Wed Jul 30 17:47:45 2025]  schedule+0x40/0xb0
> [Wed Jul 30 17:47:45 2025]  wb_wait_for_completion+0x52/0x80
> [Wed Jul 30 17:47:45 2025]  ? finish_wait+0x80/0x80
> [Wed Jul 30 17:47:45 2025]  mem_cgroup_css_free+0x22/0x1b0
> [Wed Jul 30 17:47:45 2025]  css_free_rwork_fn+0x42/0x380
> [Wed Jul 30 17:47:45 2025]  process_one_work+0x1a2/0x360
> [Wed Jul 30 17:47:45 2025]  worker_thread+0x30/0x390
> [Wed Jul 30 17:47:45 2025]  ? create_worker+0x1a0/0x1a0
> [Wed Jul 30 17:47:45 2025]  kthread+0x110/0x130
> [Wed Jul 30 17:47:45 2025]  ? __kthread_cancel_work+0x40/0x40
> [Wed Jul 30 17:47:45 2025]  ret_from_fork+0x1f/0x30
> 
> The direct cause is that memcg spends a long time waiting for dirty page
> writeback of foreign memcgs during release.
> 
> The root causes are:
>     a. The wb may have multiple writeback tasks, containing millions
>        of dirty pages, as shown below:
> 
> >>> for work in list_for_each_entry("struct wb_writeback_work", \
> 				    wb.work_list.address_of_(), "list"):
> ...     print(work.nr_pages, work.reason, hex(work))
> ...
> 900628  WB_REASON_FOREIGN_FLUSH 0xffff969e8d956b40
> 1116521 WB_REASON_FOREIGN_FLUSH 0xffff9698332a9540
> 1275228 WB_REASON_FOREIGN_FLUSH 0xffff969d9b444bc0
> 1099673 WB_REASON_FOREIGN_FLUSH 0xffff969f0954d6c0
> 1351522 WB_REASON_FOREIGN_FLUSH 0xffff969e76713340
> 2567437 WB_REASON_FOREIGN_FLUSH 0xffff9694ae208400
> 2954033 WB_REASON_FOREIGN_FLUSH 0xffff96a22d62cbc0
> 3008860 WB_REASON_FOREIGN_FLUSH 0xffff969eee8ce3c0
> 3337932 WB_REASON_FOREIGN_FLUSH 0xffff9695b45156c0
> 3348916 WB_REASON_FOREIGN_FLUSH 0xffff96a22c7a4f40
> 3345363 WB_REASON_FOREIGN_FLUSH 0xffff969e5d872800
> 3333581 WB_REASON_FOREIGN_FLUSH 0xffff969efd0f4600
> 3382225 WB_REASON_FOREIGN_FLUSH 0xffff969e770edcc0
> 3418770 WB_REASON_FOREIGN_FLUSH 0xffff96a252ceea40
> 3387648 WB_REASON_FOREIGN_FLUSH 0xffff96a3bda86340
> 3385420 WB_REASON_FOREIGN_FLUSH 0xffff969efc6eb280
> 3418730 WB_REASON_FOREIGN_FLUSH 0xffff96a348ab1040
> 3426155 WB_REASON_FOREIGN_FLUSH 0xffff969d90beac00
> 3397995 WB_REASON_FOREIGN_FLUSH 0xffff96a2d7288800
> 3293095 WB_REASON_FOREIGN_FLUSH 0xffff969dab423240
> 3293595 WB_REASON_FOREIGN_FLUSH 0xffff969c765ff400
> 3199511 WB_REASON_FOREIGN_FLUSH 0xffff969a72d5e680
> 3085016 WB_REASON_FOREIGN_FLUSH 0xffff969f0455e000
> 3035712 WB_REASON_FOREIGN_FLUSH 0xffff969d9bbf4b00
> 
>     b. The writeback might severely throttled by wbt, with a speed
>        possibly less than 100kb/s, leading to a very long writeback time.
> 
> >>> wb.write_bandwidth
> (unsigned long)24
> >>> wb.write_bandwidth
> (unsigned long)13
> 
> The wb_wait_for_completion() here is probably only used to prevent
> use-after-free. Therefore, we manage 'done' separately and automatically
> free it.
> 
> This allows us to remove wb_wait_for_completion() while preventing
> the use-after-free issue.
> 
> Fixes: 97b27821b485 ("writeback, memcg: Implement foreign dirty flushing")
> Signed-off-by: Julian Sun <sunjunchao@bytedance.com>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun

