Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 816D7F55437
	for <linux-mm@archiver.kernel.org>; Wed, 25 Feb 2026 02:18:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BBC4C6B0088; Tue, 24 Feb 2026 21:18:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B3FA66B0089; Tue, 24 Feb 2026 21:18:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A41DC6B008A; Tue, 24 Feb 2026 21:18:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 92A376B0088
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 21:18:50 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 498711B6CF0
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:18:50 +0000 (UTC)
X-FDA: 84481370820.16.E7D3A6C
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf17.hostedemail.com (Postfix) with ESMTP id 9C9A14000E
	for <linux-mm@kvack.org>; Wed, 25 Feb 2026 02:18:48 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPgY+6D3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771985928; a=rsa-sha256;
	cv=none;
	b=CTq3RmrH8wohRDQpap+Z41CyVPzxzfgTHQs/ZRMlaZs2X58xutyHnLPxdDGnDUgT1C93EO
	82n4LcVXUVDWL7IfDCjSHR6fy5IpV95z1IPO7XsKl3umfpwavNV5npB5DlK/r3YA/YO3YD
	GgvhmWgTy/FsMfFDAYgCa1kPPJdDKcY=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=bPgY+6D3;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf17.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771985928;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsFRNs/sq5OtZgaWQbMI6I3rKJr0eiZ5Jg8p3ZyE250=;
	b=OTD3PbeiyNuqsG2txksCW+Zk8HOhPGXjfjsIonJl5KhB6PtpSsuqpejknqmJs4+m2Ndx4z
	xW/gddCcF2NqQR3Br7euPtHmYp62abw+wb80FEjffXQOnHreW5GivDsSQUTfFnOoqXLImK
	VsGFzd5yivSBsz8AlVRi3HldC9XlpD8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 9CCFC402AE;
	Wed, 25 Feb 2026 02:18:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F069EC116D0;
	Wed, 25 Feb 2026 02:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771985927;
	bh=pgGwTfKR7p0Pg1mQDrXTYVdAt7ugAKMcZvy4poegARo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bPgY+6D3XEsxQVtjGvB7wDbUfhWwzui3Y/JlgKxZ36khQyGXBGBWlLr4gvdj0BXR8
	 I2PbLV/nDqh92Ovimbj7vNIoyvolHPoWhp/f3jVjG7QQZAK6KPeIt8i0tucEjxzGcy
	 ElmUouSH6xdjK8PYgPMVOgls22QPpAayKAK44pYbk8FqUMOKG1BGR2zr+zlsuOurqw
	 liXbPkA14ZHulFzMF9m0LmpGN3WQU3xkBao2tah4Tc1AWYXO/IsUsCeNlWzpk24QPR
	 epL9xBjfnOoaGFMQdevnKAu1vkFqlNNO/zqx6OTv4JYDiZHea+rtHuHyWF/NV8O4uM
	 VKD7+zTziKsKA==
From: SeongJae Park <sj@kernel.org>
To: Zi Yan <ziy@nvidia.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Ron Economos <re@w6rz.net>
Subject: Re: [PATCH] mm/cma: move put_page_testzero() out of VM_WARN_ON in cma_release()
Date: Tue, 24 Feb 2026 18:18:44 -0800
Message-ID: <20260225021845.62875-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260224213946.2328419-1-ziy@nvidia.com>
References: 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-Rspamd-Queue-Id: 9C9A14000E
X-Stat-Signature: 1k6msxmbfchk8k3ofegtxqys7t7hsfaq
X-HE-Tag: 1771985928-40518
X-HE-Meta: U2FsdGVkX1/JPeNPd62LXdWHnvpM9qmPd/wA6oVPWhNPC08j5x6r8iLIZrf4jhONBhzlaV8QSTxctxaJIec6GVvwPN8bYZ8PiCTFe8m8Fss0Kda5TL8oH8OUFsdUJJQuDuGxMkA5/gVA8QCU1Xz/FVgfLfr1J8/01S81wewLhcQHJYm9D38K61/SrIyYMVpO4LCPYI6+l7R6gfO8fU4sMtzza1yOkVFWxBuJwjMszRKhCKpgu4p03N8Qkw+wrNJk+MsXKwzZE3jWEYQ6BL7yYQZq9TtA5EHPLRP7V1x50lo2jE+3Irjymtx+SSZAbRT69Q8ulebc6mYe9375T8SSQ977d/uM+7x3vhZynImPuHhpUAddAf1VWy02lhaquoOUo8wdEzMs10mPk2t5raRzof8vbjQ7D0enY06NUpmqpkX4zhJ5rb9N4d48ESpcTWeNRva/zbf1FDeWW8Zo1lwjHYhXfguKBcoovLvePjLtD/LX3EzMIE6RiYSw0+F//dnVtbIHBih1rAukpF5FJtxB2YKIrypugJAuTrTdBOQ3H7oO3TO/YTxMeHROrkjV3OuYQBM8yugGql/bD6EZsmJ9HyVp+N0FTlCVVtjjb7HCJNh6w+FyAvutG0rCIAR3E7yASktw2QTb7Bm72FRhd88ua6YNLGQZpPIKpIN3j8aGvNI9SOZRx9nJ3tK1Vcoo/lcF3xrH1O4d4IAiYaLfzQq7SpxsBcItkulQ3Z0VhPyqoe4iPRHMKFFZEffHz3UsolNT/45rhDQG5TQZGGiIG6FnSIdeJtCiOCUaPlJJIPqBGrKHXu2SvrjEk4/dd/j8tb+ITcBljFnW/42ruL1JZh3DNsEC5U1CMEfbKhXzi0bIFdRsqbdsFk6LtgQyN15gNodi0nlNHm9MZMNfuWJoX09zswt1JHycBkub/pEXUztBIGnjo7bz2I9DRBh8m5oCokfcTLfknMA3Ljo7P4c3Gvx
 3ue2F/W1
 gNAd0Th5CQ/mBda8diioyi3Aq8E4+qkW5BLXP72lg0mSNYsyKR6osGD6t4eLuw/DAY7xyhmiXoy/Vkpxu5aphoSOJh8ftwKpcQXTxWo0mifY8mM0yQNtdB8rjo6Uf2VuufL9+ediE/Nk4+ObaJ9zA6UhGcw3ac4pXdfO6fs+Wc8Ivy11V2Vj3SjPbNGhnwF8Er/N2FoGhMJwQhEOLFUp3MdeUZRL/qqga5zQRLeG40O+G24QEiwU5R0ZSlPzFRf0QcE8dwE86MksXdgXE6eMEddmOgD2SQ8UuDUvnC0klMER0iBTAtkCgPySPHtJ9ZO7EM9zkLd+VmLMv4VvA9LUJFuD+xlIIm5RTMt/IL7c2BtJbZCY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Tue, 24 Feb 2026 16:39:46 -0500 Zi Yan <ziy@nvidia.com> wrote:

> When CONFIG_DEBUG_VM is not set, VM_WARN_ON is a NOP. Putting any statement
> with side effect inside it is incorrect. Move put_page_testzero() out and
> check its return value in VM_WARN_ON. Add __maybe_unused to the return
> value for when CONFIG_DEBUG_VM is not set.
> 
> Fixes: 9bda131c6093 ("mm: cma: add cma_alloc_frozen{_compound}()")
> Reported-by: Ron Economos <re@w6rz.net>
> Closes: https://lore.kernel.org/all/1b17c38f-30d3-4bb4-a7e1-e74b19ada885@w6rz.net/
> Signed-off-by: Zi Yan <ziy@nvidia.com>

Reviewed-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

