Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B38FC6082BD5
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 09:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RV6f4qcJ
Received: by kanga.kvack.org (Postfix)
	id B2E4D6B05B3; Mon,  9 Nov 2026 04:24:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ADF026B05B4; Mon,  9 Nov 2026 04:24:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9F48D6B05B5; Mon,  9 Nov 2026 04:24:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 81E5D6B05B3
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 04:24:30 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id F29B11205E7
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:24:29 +0000 (UTC)
X-FDA: 85415045058.26.DC7A62C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf13.hostedemail.com (Postfix) with ESMTP id 6472B20009
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 09:24:28 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RV6f4qcJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794216268;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=cNFD8zbRoLqcBaLpUrUz65qzQQyXXiRBbh/ZFm+g/0E=;
	b=Gfd7L/lgeiW8st3EFQ+oWartc615ymj/BHmQ5UfEImdpas1sjx80OAa+OGCjkoJKzHTObQ
	15xQucFH2yNqcFaWuEBDQ8uVocXVBXcWwxlgCKUzOeJ/O567Q/oiVUhxV+vVw3Mz/aOZOU
	LzLt1BUbVDq51iCmoHCkKyqDt+9ZEc4=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=RV6f4qcJ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf13.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794216268;
	b=aHiqcEPVlj5q1Va8b0qMnat6b0fxal1zZAFaIXG2zTafxwMmMzuaA5LQB+7bPY4VED5p8Z
	NWaaUaNk80D583KHinA9FJz54W1V3kT/dv8LP2LjHsceyExFS4Q4awxlKMz5VqxpSOtayK
	gvoDaH3X1vFrbKz9ThF6tO/NpsShZjA=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8F02F40710;
	Mon,  9 Nov 2026 09:24:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17E841F00921;
	Mon,  9 Nov 2026 09:24:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794216267;
	bh=cNFD8zbRoLqcBaLpUrUz65qzQQyXXiRBbh/ZFm+g/0E=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=RV6f4qcJIjlbsx8FxA1gxmtGOYGrqDAqHaEFkjDmVEvh9lKtryFCfIVBh2Syv+Nm5
	 3pWfPBY0jOJrkRMONpLfK9G4EHDraDOfXd+MhXzuTpE2P9tsEthfMKFGmOQLCDYlzs
	 SrJGyjebs3ZRk2dtFEh1jcZAgMmA+UzzkSel7YKXk43VbE4n0QFjoaKPOUMpS0lDnO
	 15H2VQcUneTXTIQ+aMXnT45PaTd+sHwAGhegff5F4dk8O3hpM+u4GKIrR7OGwG4/2J
	 uogUUW4aLsfTJs2ixdi0HB3c3kaLECdnu2Awi3Rgj9GQOwpEjUI4amOtG6CTKVQEMx
	 rIaJ9//B6Yzjg==
Date: Mon, 9 Nov 2026 10:24:19 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: David Hildenbrand <david@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Mike Rapoport <rppt@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Lance Yang <lance.yang@linux.dev>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	Christophe Leroy <chleroy@kernel.org>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Oscar Salvador <osalvador@suse.de>, Qi Zheng <qi.zheng@linux.dev>,
	Muchun Song <muchun.song@linux.dev>,
	Huacai Chen <chenhuacai@kernel.org>,
	WANG Xuerui <kernel@xen0n.name>, linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-riscv@lists.infradead.org, x86@kernel.org,
	loongarch@lists.linux.dev, linux-s390@vger.kernel.org
Subject: Re: [PATCH v3 5/5] mm/sparse-vmemmap: drop @pgmap from vmemmap
 population APIs
Message-ID: <avGRQxsRFT6Ax_zy@localhost.localdomain>
References: <20261107043122.25650-1-songmuchun@bytedance.com>
 <20261107043122.25650-6-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261107043122.25650-6-songmuchun@bytedance.com>
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 6472B20009
X-Stat-Signature: zfswr8qgx8yt5mf9pc5cwzby1wc1egt1
X-Rspam-User: 
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794216268-129002
X-HE-Meta: U2FsdGVkX18Jt0dt+HDwbvbLDTDqQoSPeaTTKX22c2pErOFyP4stnj2AWJxFtv2n4h2/kTad7al1XCnTFeTz5v7mZp4KUk3yLD3gvGmjkrOzk16m80GjCdb+XZ6skL9PJzuAUTpL57SsdMsd8n5lTPhDxjtS06+YE/iU876HoYf8FZwUgNwqqZtWtRHB+pc/wEUi1xvPviGBamQzRETr+cWTdEMy8bnAcBoB4ZSj4QaMCgf3+HmzD9olFFiWW9mfJFAQRnpHvL1OnQWb6z3rvhnwfP5rnqC8vcWz54vAQ5NzmjXdk10ZYJTkRiwxbjcrDGctZ6Y8WmhELXUdlrUNwa4dz9VKJJmuEjd53E5nUDwMxrG1vVjfvdyTqbRS7dKxPF493EW3wEscMHtrSHFYuLD8ttfDg2g+gQtZzTWVcabmJepaVmlXdgwj3rDW/Mjkk1Z9XcvxmImuD9YDUxLxhtFA7sbN4/+0+GvS0jPt7J6pSTJSJtMLFpXzhFvWGYFpGTnLiC95axX6KuyC15nZYaGLNF44uLKadYUGrxHC7LQCf51gH46ponQE/aUAkS2rT3870BxNmTsrCHbLimPLR8q+Un5QLMSHOp6aUiA52aDPqcWBJPpkKqnS4ANxwikylNqUrkV5lZP0DW9Hdnr6/5uKpM5/1hSK9566Jn3suCOmXFqb/V//I6+S6L6TPmWtmD4Bn/x4gakwMnHOVcvhjjXBajncBV2GYv+Txc64pT1o/dOovUI46W0gSYKbECzXfyyw8wUC+HXheMu4ZYCx/9Ejv3zOyVV3aYrMJrYAhbtAP4YEqUFwXNz/GKFBoKYN06dB41f+QQFe5piJANvKk/xkMPS7X1ejXvul+84ibAv6rqbMIV6T2TaRL8kx+oRXwwZdBBQ/SVBpPpJR4ECACGb/AQTtN7NWcH+ODLY7K+RnK8tO+/qEOWOAxk4eL00wbKp8LAec0kEqSAeEIpI
 OneJNJX1
 NmEsLZXZCFUz4tpvFQbf06V00G9IMeyfSYR+dy2qeijBuRt4WT4Tf9MvVcPCP/4ThvIleNHZcPSmf0mGDxCUlrXF63BvgjusomAF0zefFZ3qb4yqSqQEaXDQX4f43AFQlPlW5Dnx4ZEo9wmajJfcK3vsnts1wX8OvEdlgC3Xm2JeSaa+JZY3RydpRCsjeOAo/J5LF/cbXDnI82mVS077j8E50Dc70ln/PcqjnHrt5o5DsrysJizz14P2PuOgjcIFJbD6PI6aG41WkGVEGJXLAfmtpy8gDJ6CSPmn38hx3FFylf0UZQOgEakqZkM/wkWQSgHzrLbKeXxxZTml7IRK8O7qd9Q==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Sat, Nov 07, 2026 at 12:31:22PM +0800, Muchun Song wrote:
> The vmemmap population and memory hotplug paths no longer need @pgmap
> to decide whether a mapping can be optimized. That state is now carried
> in mem_section, and the architecture-specific population code can make
> the remaining decisions internally.
> 
> Drop the @pgmap parameter from the vmemmap population helpers and the
> related memory hotplug interfaces, and remove the remaining
> dev_pagemap-specific coupling from those call chains.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

