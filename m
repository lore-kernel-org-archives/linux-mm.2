Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 90F15C5B572
	for <linux-mm@archiver.kernel.org>; Mon, 17 Aug 2026 04:41:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B84526B0909; Mon, 17 Aug 2026 00:41:30 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B34D16B090B; Mon, 17 Aug 2026 00:41:30 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A74A96B090C; Mon, 17 Aug 2026 00:41:30 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 868236B0909
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 00:41:30 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 0A2C814069F
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:41:30 +0000 (UTC)
X-FDA: 85109512740.10.6AA2792
Received: from mta0.migadu.com (out-83.mta0.migadu.com [91.218.175.83])
	by imf02.hostedemail.com (Postfix) with ESMTP id 1410D80003
	for <linux-mm@kvack.org>; Mon, 17 Aug 2026 04:41:27 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AnoyqEqH;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786941688;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pGSo1Cfu6sLAcXoqpPoreSz60pwDzvhB8EVdtBx16UE=;
	b=CgZpgLlw5+6cp0CE2b/AksStIUyrUvQXRd2xg7TaH80ZtrMq74JH1oLrt8116RlzF8XDXU
	AHgaPuPZQM2kesJz4TzcoQSCIs4/dJUKv7NHM0ToKUyISkRr42QllqxMHtAFV9+Nl2//y7
	nqXIoGpT9EEuxOSm5eDRioIPmHwXg/0=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=AnoyqEqH;
	spf=pass (imf02.hostedemail.com: domain of lance.yang@linux.dev designates 91.218.175.83 as permitted sender) smtp.mailfrom=lance.yang@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786941688;
	b=uOuGN3Ie8O0+BhnxP6vkT2+ghVyq1gOWESgT+DWDFbRPXqpkYLTlLxuDL6CTE09JYtmEwd
	NtoCDJM1ABull24dLI6rUKf6ZjCypEJ6a+L+ysA5RhyWOUO2UfEq+VO96rGYFNcM7IsYrw
	hk3+TrHeoNir/yvK77PuVoYyA2k43AM=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pGSo1Cfu6sLAcXoqpPoreSz60pwDzvhB8EVdtBx16UE=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1786941686; v=1; x=1787546486;
 b=AnoyqEqHofWVEm2rFglZDqDkqc+0a+UFU6FSJW3k94xbfoK9HbFjis8PFbiBRwSHeH1D4e7J
 IywKwp+mBHZcQ5U3+QHKVJYvsiSKAs3j5HDxc8NEqUUSqrdtMWMz54cpq4Wh878oLAjPfl+rPha
 WuwN5sCaweeSPjmw9DQnnEHA=
X-Envelope-To: linux-mm@kvack.org
Received: from localhost (2602:fce1:44f:115e::)
	by smtp.migadu.com with ESMTPS id 2dcc283464ad7e50;
	Mon, 17 Aug 2026 04:41:26 +0000
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: nico.pache@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	ziy@nvidia.com,
	baolin.wang@linux.alibaba.com,
	liam@infradead.org,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	baohua@kernel.org,
	usama.arif@linux.dev,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	Lance Yang <lance.yang@linux.dev>
Subject: Re: [PATCH v4 7/7] mm: Documentation: clarify where the mTHP stats live
Date: Mon, 17 Aug 2026 12:41:18 +0800
Message-Id: <20260817044118.86344-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
References: <20260811-khugepaged_pte_refactor-v4-7-ddac39d61c4a@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 1410D80003
X-Stat-Signature: xpnzr6z95apmfxgccbeyrm9c1xc3fx98
X-Rspam-User: 
X-HE-Tag: 1786941687-180132
X-HE-Meta: U2FsdGVkX188o0hPNBCdNtyViZsVLzV3FroMOXQg8sqaMoU7tAG5Cg9T/kFbGDSTmHKeFKjUD0QcT6Hw4L9A9jByVeOaYZpHPI67FUU5SImgbDoXeJZ4i+8jRyoNrhUYo8a5L+E9M6+5ir+zDmRxLzUlnkut4sAlZoYorgM2RuphOqRkPUtTdJFVJTvnjistl8Q0nHsRPTCWrCyanDm6Zms4kq/ipRcy99semfR0T9ImF8GDfo2wIMvgjYfZLCwiWPAlmggzj06cp93gujHyAv4lJuZakYA8UscAN8DAhcFSXNeY8IyhHyZ77xc3Qeli9JOuc/1BR4hh/ioIvweMXJzBmnAp7LOvwN+8FNlXxt0zVcEEnmmXZZT27HyzKpkSKUlv7RecNCxiVHsxDq05CwBk9suc3A9jPl2ajWkZovyHMyQVFqxTSLyI0h56iDco2ltPXNpg0xMOk9Lia0ZwNZ5BNnmcl/wkAYpeQxi3mU/THkyalxR2uC6ATHGgP8JjrSv07spNMQfwMUHp9dYAP3nEn60NmKMlqtzuGIdLxHXM6MOXVcNdE0Hlply28EAZhjm6UItfTNvg5cxes0v5T3CGbSVMzf/A/up3vp7UU5VVrjYgVNa41HCNgVLBhT7kF3mG+txxp8ubevfGzBlSEVPBT7Wvzv3fkRy4+d5WMHDsYkmxhwGS2b+CMSuSD5850VmPoR0N9QhwJTBMixaZjg8WwOo13OgBABT0Q7ymxKFWzLnYOwr41hsKdKfs2/nr656Tnr2fZa0VU2SCYSm0JKFyhjVFxSKrAjZ6Z7nl1Su1vHH8UGLoPIin1qLIrFOrZasYT3qlx16nobN2hg/HfCoqkVDn81EMCnM3OgqyE2mQ5ikaiVTFei6axC1vK1zfiAz8/nZ3oOas9Ft5vdAQJcjZt7mACYQUDz3SknOYfwm7D8l7VApK1Pst0ZbOOEA4QUpk55FgFw2CtYD6YfQ
 PgfRQ5qo
 9vBiWnENt0VCd6avXbsfaTpZ8+9D8XQJ10Jix/XeaLSaFqRMfkujFaz5GaqMEOhFfI1iudWtITYaexyEtqgkNHDB+MxlHorPkV1bxv4WmriDpaUlIlBgGSypnqzSz0OTMjuzmfSALsLENfC3ovfxOlY7aAT5NMLVCtTAsCdyQuIakPC96cR2VIgMlGwafZ5v7+4sWC8QocymXU+7Aff8hCc26q+1H86rUeoclGacbB+GJNE4M8Xn0s61UZDAwuZ73mTQlgZvDJi1k+NmLHubVa1SHL6Own7VHwOUaHYF/9YOFXRyqGaIT8pXvCray2cPqCw544xJPBMGYqp4=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>


On Tue, Aug 11, 2026 at 06:48:39AM -0600, Nico Pache (Red Hat) wrote:
>The note about khugepaged counters references /proc/vmstat for the PMD
>case, but never mentions where the mTHPs stats can be found
>(i.e.: /sys/kernel/mm/transparent_hugepage/hugepages-<size>kB/stats/)
>Add a small addition to this section for clarity.
>
>Also fix a missing period while we are at it.
>
>Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
>Suggested-by: Lorenzo Stoakes <ljs@kernel.org>
>Acked-by: David Hildenbrand (Arm) <david@kernel.org>
>Signed-off-by: Nico Pache (Red Hat) <nico.pache@linux.dev>
>---

Reviewed-by: Lance Yang <lance.yang@linux.dev>

