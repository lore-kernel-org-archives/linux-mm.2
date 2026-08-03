Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 63CB3C5518F
	for <linux-mm@archiver.kernel.org>; Mon,  3 Aug 2026 23:41:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 160DA6B007B; Mon,  3 Aug 2026 19:41:07 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 112486B0088; Mon,  3 Aug 2026 19:41:07 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 003686B008A; Mon,  3 Aug 2026 19:41:06 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id CBDC56B007B
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 19:41:06 -0400 (EDT)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 487BE40870
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:41:06 +0000 (UTC)
X-FDA: 85061581332.17.47B3782
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id 8F56F140009
	for <linux-mm@kvack.org>; Mon,  3 Aug 2026 23:41:04 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0BJuQs9;
	spf=pass (imf09.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785800464;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=q4ebMADhzsqGZo4g2q++EvXNBy8Vyr9f7ox5xCdjmho=;
	b=uu2NbeHF2yF4t7ZC0Hr/ZsSZ1+fhHRoSWB5Z8vGXHbu7k6kNJkooCKfMrZ5VbVQGIUdpZb
	hkut7lAp6BTNY7ztw9aVMypOsVSk2s/FMNpFHjI0NcCD0pxQawG7w+4ljGwKQvF5r1R1xL
	oKatxNTMiZF42Z22WR+/zlLxyX/n5tY=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=M0BJuQs9;
	spf=pass (imf09.hostedemail.com: domain of xiang@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=xiang@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785800464;
	b=mUUmVhXF1FnK8HQ9a1lG7cSvXBJ9d3UmWPICV1BaTe8ls/ZyHXK8jNnErtmMu9AH4iJTCF
	L05jseoEIuF0dxizzosvH4mpCcx4nCB6HOU9KpkPyJ2gI4LZbmCRAQJBhGXWhaZKPuWYtm
	5G2uSRQSX7XErpeHcihBzxdWtdC7+f8=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 6707741278;
	Mon,  3 Aug 2026 23:41:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 536C21F000E9;
	Mon,  3 Aug 2026 23:40:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785800463;
	bh=q4ebMADhzsqGZo4g2q++EvXNBy8Vyr9f7ox5xCdjmho=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=M0BJuQs9xua3UyQqpC0j/HzH7OM14N+1DH/hAcRO2svjCN/3bZujd0RW2lU8qu0gF
	 ms2psthVQ+Nn0B1T4dQrABCA+ZDBBasfUnRp/v5Ge2rO3aOrRBt44JK6kxceO1smfC
	 +NENk9pw7T8+tnz/l1hYduFQgbEGkdavPuUyokC1mw/5s2qQGMvHBI8BNY7u9dCnCn
	 FTya97HCJcY9vSR2Ruzi/PBnCmFr+tfKc7uGUpg+GF6CztprtvmAxO/pgbOWouZ9tp
	 9pZWn6ovDywvRZ3mb2zgd2ZZKbujQRR6deEJmd8zMmKZZPLSZSnghcWfhIKIn9CHEC
	 LmUilB2cQBumQ==
Date: Tue, 4 Aug 2026 07:40:53 +0800
From: Gao Xiang <xiang@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
Subject: Re: [PATCH RFC 08/14] fs/erofs: use folio_attach/detach_private()
 instead of direct assignment
Message-ID: <anEnBSAOQE8LyKdI@XiangdeMacBook-Pro.local>
Mail-Followup-To: Zi Yan <ziy@nvidia.com>,
	David Hildenbrand <david@kernel.org>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lorenzo Stoakes <ljs@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Gregory Price <gourry@gourry.net>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Alistair Popple <apopple@nvidia.com>,
	Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Kairui Song <kasong@tencent.com>, linux-mm@kvack.org,
	linux-kernel@vger.kernel.org, Gao Xiang <xiang@kernel.org>,
	Chao Yu <chao@kernel.org>, Yue Hu <zbestahu@gmail.com>,
	Jeffle Xu <jefflexu@linux.alibaba.com>,
	Sandeep Dhavale <dhavale@google.com>,
	Hongbo Li <hongbohbli@tencent.com>,
	Chunhai Guo <guochunhai@vivo.com>, linux-erofs@lists.ozlabs.org
References: <20260731-remove-pg_private-v1-0-142c97ba3562@nvidia.com>
 <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20260731-remove-pg_private-v1-8-142c97ba3562@nvidia.com>
X-Rspamd-Queue-Id: 8F56F140009
X-Stat-Signature: upwnjxheyhxxpnhj4j6m7ygjqq8xom37
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-HE-Tag: 1785800464-419206
X-HE-Meta: U2FsdGVkX19THzE0bspDdOX6zyN8WZ+6l75U3zjXwg0rVdIDpIWmLWaD2qRtq9an+vg44fCEme0+HWKo7hPCdwZ5/PmwRm4xZHPCgHsGxYqjpybmEC0L/LosXUGX82iYYVROlEew7G6e4Hva1rVg7gX3sXdIeUSz2ad9vmg+SL0FrJ+LY7R98bcgqFftJidY5v/P9UNiB7ARHc8vhQFAIs94AJU13B8UQOveDt/DOlRdYH8mD5k0LpW4GyEXMklyi8SeJkpNOOiIOViWdqtweROxC9kfdoQ2HrhVtWIL7oyDdZVyud7GuA/QOKs6+52O+denjPt3fCCxdpRFQxbj+jihMUqhHoGt119p/hZIUbd24ihmPf7tAgdqYz8wl5EUO74fQLaKPEmxlmibSX6JMsEvLPMtq3m7J84Fdy7hjx/36mEmooKksAwgxDCcir7KgGd0sm945BrYnBe558qdR6y+tkQpW+pOg4CMBO/dpiDSSSWjo3WrgoV8l/H1gtlsgzT6jvUjpkJ7tfuGMmVvy/xL5cVPGPOU6+UcAxVW2N7tyShY3i/7bOWgwHkctRVtG3n0sfKpin2HfkfGbvDGA4tdV4fObIItXJhcX9wNuHNu9ZMdCDZlwlULjV6rbiXcPtggOFj3f3ATbv0KwqrYSvt/W25AYMyGEDRoPO9R7bD3f2PZCIpG0X16s6hHoKyHxgNGPSiE2wyk3KhGm+dfEE0WAbpld+y7C7mE+KdqqGublvffyejHwWmWPMM7x0vXnesTXmb1RPTgUCrWn9vzbLu0ejFQ+yC8vjVc40I+q7HTlc3WeSyoASwDl35w8QkSPZuMwKTcsHthplEJonxvVotcO8l7uvAjCniPpCVDI9cWXW5zfy+qcm1QE7ukejB/dR1FCNruvH2bX8x7rQDh38BMgqHcvy3m2aKPJaiQTxVuHdLmVWo51e7N7kw02jITPzxy8ALHGbjmBIZr8bA
 czLaXYki
 8xe/iq5p19ve+pX0MIOTmby9sUh/QcC4mBzO+4RQe4t5y51ImDAtWLDkGLYZylYszYpRQaGpGBBlNiYQ7giG6yZFf1oTrwDTwZB8opFB/YVqLRKByO28kQQbLTa2Wo6ItPbH587EZteYmfwxh1O5uBB/sEHQop7dSaomaJ1BjxRBx9QMAMLwRaoVrsi5yx3PK++vqz/TaQwTacj1pRL6cEzXs08PhkGJQsT3E078ZKsvEV9YLj5XtwnbrTnubi4Ee/jzNnSOKqsYL2PFsMAPbVs+RnAWqKaFTaakt4cumNJNN8vQc9ETb4YQhb5dOK7grEnYIISd4Pg4yBcC3nPXgLbqw1/MOyyrjbtJXAmCHfnk3ECPpRdh1ivXUbTzJasOy1FTroKU/XudD82k2Hf+97vfxr89YO9QRHqsmu0nzzdF6ZBubvgia8/OQjsjenO8sA7WHKlJDo9RIWg6NvaUUjocvuRaZNQ7Brqvau82fZa6F7+jRrAlLsydcJphm1K2NI43TmVdXAk2UXiPqJqLz07wpyA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Zi,

On Fri, Jul 31, 2026 at 10:13:31PM -0400, Zi Yan wrote:
> erofs_onelinefolio_init/split/end() use folio->private without setting
> PG_private or increase folio refcount and it works. But after PG_private is
> replaced by checking folio->private in a future commit, it can break
> folio_expected_ref_count(), since the folio has private data without
> elevated refcount. Change it now.
> 
> It prepares for a future commit that removes PG_private.
> 
> No funtional change intended.
> 
> Assisted-by: Claude:claude-opus-4-8
> Assisted-by: Codex:gpt-5
> Signed-off-by: Zi Yan <ziy@nvidia.com>
> To: Gao Xiang <xiang@kernel.org>
> To: Chao Yu <chao@kernel.org>
> Cc: Yue Hu <zbestahu@gmail.com>
> Cc: Jeffle Xu <jefflexu@linux.alibaba.com>
> Cc: Sandeep Dhavale <dhavale@google.com>
> Cc: Hongbo Li <hongbohbli@tencent.com>
> Cc: Chunhai Guo <guochunhai@vivo.com>
> Cc: linux-erofs@lists.ozlabs.org
> Cc: linux-kernel@vger.kernel.org

It looks fine as long as PG_private flag will be removed in the
follow-up patches:

Reviewed-by: Gao Xiang <xiang@kernel.org>

Thanks,
Gao Xiang

