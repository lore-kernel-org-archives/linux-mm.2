Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7D729CD3427
	for <linux-mm@archiver.kernel.org>; Mon,  4 May 2026 20:36:18 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id C283F6B0088; Mon,  4 May 2026 16:36:17 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BD99C6B008A; Mon,  4 May 2026 16:36:17 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id AEEC86B008C; Mon,  4 May 2026 16:36:17 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 9A0FB6B0088
	for <linux-mm@kvack.org>; Mon,  4 May 2026 16:36:17 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 5A2748B4DC
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:36:17 +0000 (UTC)
X-FDA: 84730894794.30.B9D769C
Received: from casper.infradead.org (casper.infradead.org [90.155.50.34])
	by imf06.hostedemail.com (Postfix) with ESMTP id B7130180002
	for <linux-mm@kvack.org>; Mon,  4 May 2026 20:36:15 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=X2D6qLdU;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777926975;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Of8w4s8L/jyna87mZklhNUp7KjKlNJWZIKBAu2u9pd4=;
	b=xdfx3xuOEren3oj8lwfdANGJ40ZjopyMZ3IToYQPCvITGtB+EiP6+Kl/WB0nZZ19jOXkGT
	Bc9mwVGARf9B3fuo0dbhU4CZ6WVjUkhsPbP41vKX6iTJ7UPJZNd6sbiXihaSbRncH1VngV
	uayufXqd1cUSumuhPuum5I0TxHgrdvA=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=infradead.org header.s=casper.20170209 header.b=X2D6qLdU;
	spf=none (imf06.hostedemail.com: domain of willy@infradead.org has no SPF policy when checking 90.155.50.34) smtp.mailfrom=willy@infradead.org;
	dmarc=pass (policy=none) header.from=infradead.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777926975; a=rsa-sha256;
	cv=none;
	b=SZjuYnwwhQSZUlY7paWrhTclEf+YarQVaLu8mu38uMQwLHyBPENKrlD1ksbUGz2Q1kOXLz
	cnEwPiB92sIQJjmpb/gOubcLhrDP3GCLvVsE1YLh7s4t78oIU6TDth+x8yFYR26FXNFFuG
	Ulyd22UEaxQReX7eRirFfLe9dwF+Jao=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=casper.20170209; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
	Content-Transfer-Encoding:Content-ID:Content-Description;
	bh=Of8w4s8L/jyna87mZklhNUp7KjKlNJWZIKBAu2u9pd4=; b=X2D6qLdUk4VGEG/rTV/mvN7mpp
	K9KwbcmU+pIfwIhI033QxM8YKBaw8ZIy4cojUMTQpH0M3ChNyiQpVRGoI0aD9oTTXAMe4b7KPmFJY
	2qGTK0fubuLoVYXuI8sobD9L0+oXzT8fJucVWa4Q0MdMyywX2cJoM+aECRhdoXtVxuhGhhxRDzHfg
	M2ImeMVKCspfW7ps1CywqDj2Pav6iMMUdJ5l5jqdU3hJhrl+z1uFBPCDw4sqrnRWYYt518Te8lnh7
	w28FoVX7vnsbYqtmv4iRHC8GnTy1G6Ntj6KQa+hBGvb3bUI7PBHNMJSnMoQMTpd5PUz9CnXLbqXTc
	guFWKrPQ==;
Received: from willy by casper.infradead.org with local (Exim 4.98.2 #2 (Red Hat Linux))
	id 1wK01O-00000001UBc-0JoP;
	Mon, 04 May 2026 20:36:06 +0000
Date: Mon, 4 May 2026 21:36:05 +0100
From: Matthew Wilcox <willy@infradead.org>
To: Bharata B Rao <bharata@amd.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	Jonathan.Cameron@huawei.com, dave.hansen@intel.com,
	gourry@gourry.net, mgorman@techsingularity.net, mingo@redhat.com,
	peterz@infradead.org, raghavendra.kt@amd.com, riel@surriel.com,
	rientjes@google.com, sj@kernel.org, weixugc@google.com,
	ying.huang@linux.alibaba.com, ziy@nvidia.com, dave@stgolabs.net,
	nifan.cxl@gmail.com, xuezhengchu@huawei.com, yiannis@zptcorp.com,
	akpm@linux-foundation.org, david@kernel.org, byungchul@sk.com,
	kinseyho@google.com, joshua.hahnjy@gmail.com, yuanchu@google.com,
	balbirs@nvidia.com, alok.rathore@samsung.com, shivankg@amd.com,
	donettom@linux.ibm.com
Subject: Re: [PATCH v7 0/7] mm: Hot page tracking and promotion infrastructure
Message-ID: <afkDNR9yVRjire4T@casper.infradead.org>
References: <20260504060924.344313-1-bharata@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260504060924.344313-1-bharata@amd.com>
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: B7130180002
X-Rspam-User: 
X-Stat-Signature: zsbznmuprp3q5r7j4bqisky8n4fkat9g
X-HE-Tag: 1777926975-474901
X-HE-Meta: U2FsdGVkX1/3i1aIanyYZuZMFx5zhBYfX/cRNhi39cbEsWSRMRB455dMf0Vl07pl/uSDMi8iP7T4YnlYoK2MmsrmQes3GtQfm2WW+ghsFeCCHaOWbVf0kGe+ajbrfW7OmNQoOww2kzx3fzKQyrCbdbF0NykiH8RhDZovPYtZcdobyvMb2Q8sCtp1clNw5uFGbqgwuSigUYHOSFVTYhwpCJTV1Pe4LZIoN+g6Dw40W7bJR3GlDd5BiM07UGnfwepO50X5xoV2JInanZozvzoQqPCDEuRKLuDajcsMKvUXNFl5dO79E2pmVVN9E8PYlfXA9l4weMRFcOf8Z3W7tErUuRmOancJqzXDYajD9c3zX3WM/zAdl3+K6xWH0n6I3BzWs2NrBr0gxvfsT3UH8nUePMARCwYsd+7jo5grRjl8mlS91pYeSeSBfk6HW6VBNFp4tolGjFiGKhPN64I14WVhgpPnIkPaB+EVjs/d7aecoKfuccYoeA92auIQR87gXX1OYOZZMZUlUmXJYQGGWoM0GNNPQLeD9xmxqRVZy/Binp+kSbiTK3Kv9kIVYO5AFXEr23BoRYVGcJd+8jjnOgzRov1obuIZc9f08ammVvflkPO38nISqCI8BNptZGodC0NbHYDiZXp5noRROn3Ge4CPzMfq3QmIVfHfhHrEI1P2GOvejcboJYWy58EPBVtcQgqEzOHELyuNe6WZEPgpbVSyJektlSDVRTzZiBycpXAfFVxL7oCaq+IkXCNkTqP1OB70QcP2DA7iiYGGXlfcPFI0voRWzWHC8zIP5lXyK9X4p3GdtK02IpxZNSsBFa//RULa+8972hzLbK9X2Ogg8X7BmochC8/uNxc86hxOo8wz8wZMX9HUKIHDX9iRt3/DXgBFTtcE0yiUhnv4vac3KMmzlSVXPXMQ7+ydF4eN29Jl/g1aupOUH4G7UyAIu1RaSHjcauhbh0DMRTAGW7zhjzn
 f0UtdFAA
 8kt0aiBwKUFz3X9CsfQ2eo0aLK41WYc3xAO7bt5J2ZjYHjdwRwneNz9TbVHGYCKd10BFjZFg8HsnWlS21LZ2Si5pcfK923EdiplvxeFjmEg6AyJ+ZjyKJRNbn/SuLuVifHFXZlORXh7VCl5BqGuEehfbRfxpfPcLryZEk820dCYSyjd5m7np5QfHo/xfmocJCBFog+mu1T1w32RY/C03DItjLytNVRakzK0UsYT083CDSeYzCN/SqRcC8MiWjT+tJbfgAB6+uqO0mZRWcuM0ZKE7EL2ecocO5K55NMugOKzyJjK4Ll3ORuz3aPCdSbxFaiejG
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Mon, May 04, 2026 at 11:39:17AM +0530, Bharata B Rao wrote:
> This is v7 of pghot, a hot-page tracking and promotion subsystem. The

I continue to think we should not do this.

