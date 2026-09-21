Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id CC42FC982ED
	for <linux-mm@archiver.kernel.org>; Mon, 21 Sep 2026 12:53:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CB4746B00D7; Mon, 21 Sep 2026 08:53:29 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C64726B00D9; Mon, 21 Sep 2026 08:53:29 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id BA1F96B00DB; Mon, 21 Sep 2026 08:53:29 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9C6736B00D7
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 08:53:29 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 241B914016F
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:53:29 +0000 (UTC)
X-FDA: 85237760538.21.041AF02
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf24.hostedemail.com (Postfix) with ESMTP id 733A3180008
	for <linux-mm@kvack.org>; Mon, 21 Sep 2026 12:53:27 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFrt7yys;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789995207;
	b=iBuQjX5MURHf2CM2Ui2cMU7SxX/Ma7LRQ3gfaDr7fCtliEwywaTTBw02CDwLf//W5cvVf1
	Ei+HCSQ5q935ng+QJohadYazA7Y3Px/mDK0j6xsuj9vpF2jHDikhqwD3Nm6Cq4H7F3s58i
	sQ9VyqyJEXw/M0/pCfuchLdsVmo7HuM=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dFrt7yys;
	spf=pass (imf24.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789995207;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=2DiedpCEs1UwpptAonzE7XEdXRU4rM/b7fTnTmQH/H8=;
	b=CHfChJQSaZn6cq4aVuzUaDY+cgrXIMuhtr7PLhMCx4OjwtTgRDmfR9W+eDbwY4cvaAjugg
	1J8MGL4R+XQ3MH3qkFeLKT++MzEv8arfXReWSJAeZ6ZI/JlQwoT/pwMvZO8A2ktVFFiMVM
	6nDa+NoyWO+6gDwL6D87s1EfHhrfUsw=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A0A6D43239;
	Mon, 21 Sep 2026 12:53:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1A7F1F000FF;
	Mon, 21 Sep 2026 12:53:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789995206;
	bh=2DiedpCEs1UwpptAonzE7XEdXRU4rM/b7fTnTmQH/H8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=dFrt7yysP9TttxshusGVo+wqV0Pa58hUk2WG6svLyuxuUeTN6Yk5xP10tOPEsLtEC
	 EnWcSnS+rffkxsidpoYgAsl6IafaBtTVk4Lfi2EZvWpntEjoIZwt+BpcRs866RQvGM
	 /XQuKCjWS1arBOebH7Vat0gne4zFqjsHpp2cCCLZg1d1jfgydoBJgOS4gLJJcttl7a
	 DIMXqEEPogHji5Y9xurwB/+uI5r25AlYut4l3h6Jte/XS+yun1Ul5VICrwIOzJE3wR
	 mqkamTH6tFQM4ZS4Q4nI2U/a7WSgZPXBc64svBSZgtQ1OgMskfW19zi+HobOPEYDVm
	 Hvc/dKRCsJ7FA==
Date: Mon, 21 Sep 2026 14:53:18 +0200
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Dan Williams <djbw@kernel.org>,
	David Hildenbrand <david@kernel.org>, linux-mm@kvack.org,
	nvdimm@lists.linux.dev, linux-kernel@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-cxl@vger.kernel.org,
	Vishal Verma <vishal.l.verma@intel.com>,
	Dave Jiang <dave.jiang@intel.com>,
	Alison Schofield <alison.schofield@intel.com>,
	Mike Rapoport <rppt@kernel.org>, Oscar Salvador <osalvador@suse.de>,
	Ira Weiny <iweiny@kernel.org>, Jan Kara <jack@suse.cz>,
	Matthew Wilcox <willy@infradead.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Qi Zheng <qi.zheng@linux.dev>, muchun.song@linux.dev
Subject: Re: [PATCH 2/4] nvdimm/pmem: avoid HWPoison flag updates for clean
 pages
Message-ID: <arEovvqEpquODZ6X@localhost.localdomain>
References: <20260903122128.12264-1-songmuchun@bytedance.com>
 <20260903122128.12264-3-songmuchun@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260903122128.12264-3-songmuchun@bytedance.com>
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Rspamd-Queue-Id: 733A3180008
X-Stat-Signature: nagjkf5b5qkqp41jsym5wrpostg4i8hh
X-HE-Tag: 1789995207-915990
X-HE-Meta: U2FsdGVkX1/l1mOfC+GLXta3AeIH7ktgCWIVIkFpncZqIGR6jU2r9s2qPlUqGMewRtlQfKGD0lyc4gWAkANN1BIXhOLmVNROMLZkc2YlyxcJk3P4Cmt/ph80JsPbJS2ZoCr/3106YG1gSq3fk1aJDuRy6gOoXxJESrnUA3tomf/qQywcdmQhxietB9ImjCHgmUiaQHR5mAkKxAMO3Cf8yqFMWdR+RQG9surj0pJaCG2MmnjuULbirWSXSjQWV2lBN0yFwwRxBVX8quAeCCyVmBrGR56iq+PdvzpTyBgjLI/JCDmNaAR1a88kFqDyuHYOMQZj2RziRo/CVO2c4sgn/gLKxgrbxad+B3Rsq+9Ek53HDAU91flzYpXTmTKZ9I9m/RTPBKN39GE7wkLDDTL5r8tQ2CMliLVQ5sJi7sUG/Uo24iFlV/NlQ4TkzCiKvbuzc67gKuDs9sia7WcWpKgZr9420/H7+5pBGyV29CU/50eweOAxttrXv91a2tV5lu0ig+im1GLMi75Zehtt+5FF9jX9MNJktmCqgwCcd71xvwDU0ktrGrei+cafTS4iQK8sLSM3cY+ucsuHuERjXAvUTrhCim24YD/GB6rA3/XWGsJf5aMNMGEZ+r69t5qRuJebHT7CcAtDHQiRuusPJ41/7U5q/6VblZc3KsDscrkN+VEFuh73UoDXi0tik757g1CHx/P6RDxWZy5vMwkz0/QLj8vFOn4EKFyf39fdoZbrQxpQB4FZVP+AY4EOmYtPQBKswt+qvWpifNvU/TPekUp6bSaLz5JEuUOx0qcyA4f74vJ3rMjYHSdffmUaxivDEOhLxpF7t8kDwUZAnG8daKuKOYSEEwzUgeWvSMwopTbPHolUpYvZaeI3C5FJhHB/Gc9dWERi9rXL0V9HDOjnUTSg+XdpFaLhcu33gXD95B/5vIvsBloN/S2DQHwzt8hLv7zELIHOLpFZWe6J/frHn/t
 D36CC/PN
 SyEDRp970+Hetp4SsyFm9HV3QsqgNNFKb0WXRal9zeg/136fBXxIFTBtEks5wGs5t4q4lcJBXtnuLlXSvjw/wZROESCtrVfEhyWoJTljPH9zny2T7C9/HzjxWRq91814dthfqOS8TUnaL05vWHEDLanhoxX1c3/WvZMp46b7idQHs34y9uV9c/kooAVm3X2BYnlw8FjoeS3f62l9wDQr37pvLM9dfDiZnwJ5ihBtOJ++zzyo=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Thu, Sep 03, 2026 at 08:21:25PM +0800, Muchun Song wrote:
> pmem_mkpage_present() is called after persistent-memory poison has been
> cleared. It only needs to clear PG_hwpoison and undo the MCE nospec state
> for PFNs that are still marked poisoned.
> 
> For clean PFNs, test_and_clear_pmem_poison() has no semantic effect, but it
> still performs an atomic clear operation against struct page flags. That is
> unnecessary today and conflicts with the FS-DAX vmemmap optimization added
> later in the series, where clean PFNs may be backed by shared read-only
> metadata.
> 
> Check PageHWPoison() first so only poisoned PFNs update the page state.
> Poison recovery keeps the same behavior, while clean PFNs no longer require
> writable per-PFN metadata.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Then change itself looks good to me, so

Reviewed-by: Oscar Salvador <osalvador@suse.de>

but any reason not to hide the PageHWPoison check within test_and_clear_pmem_poison()?

 

-- 
Oscar Salvador
SUSE Labs

