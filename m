Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 893AE606A332
	for <linux-mm@archiver.kernel.org>; Wed, 21 Oct 2026 06:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=QqSaK/eK
Received: by kanga.kvack.org (Postfix)
	id A0D2C6B01A9; Wed, 21 Oct 2026 02:18:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9BE036B01AB; Wed, 21 Oct 2026 02:18:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8FB466B01AE; Wed, 21 Oct 2026 02:18:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 6E5EB6B01A9
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 02:18:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 694B916046A
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:18:48 +0000 (UTC)
X-FDA: 85345629936.21.C35A3C1
Received: from mta1.migadu.com (out-2.mta1.migadu.com [95.215.58.2])
	by imf27.hostedemail.com (Postfix) with ESMTP id 708CB40004
	for <linux-mm@kvack.org>; Wed, 21 Oct 2026 06:18:45 +0000 (UTC)
Authentication-Results: imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QqSaK/eK";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.2 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1792563525;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pj0w5I+TLXbeTsxEvtV/dSAOrVQeyg/NjtI1DIx1aAo=;
	b=kryld1R9x1mJ+XlRNffIbec9/BJk4Ft/UvdQEx/IXpOBGx8q1yRpDmz2bQd0GMSPH0ugq0
	yDm2CXsAxNDH15N2bPgGrb5U7Hun3+4AwKT/W1l3oucNIZfs6jCrJGuS8nWetwHGV27364
	tZarlhbviN8h4zOMXuJGFuwLByiD85g=
ARC-Authentication-Results: i=1;
	imf27.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="QqSaK/eK";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf27.hostedemail.com: domain of lance.yang@linux.dev designates 95.215.58.2 as permitted sender) smtp.mailfrom=lance.yang@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1792563525;
	b=i+uU/rOkRq9qfPvjI55QwnSvnmQNsGueIFKLPomUp+raiYUK4oI83VdTxEPWJ/qZ5hVm+M
	q7kKpwiQ1+ImslyPNtkTOOWMzEUGcghZ14bMxbiNWLHj5zkBjhq0StO0SsiLMTjyrwBAR1
	N/csni0bG8buvtXWfqTSzjrzhu6efSY=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=pj0w5I+TLXbeTsxEvtV/dSAOrVQeyg/NjtI1DIx1aAo=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1792563522; v=1; x=1793168322;
 b=QqSaK/eKxDPUM3bH4vyLayiguqJ6warLZ28ldQpe0q72pf7Uvj9vGsJW5Ve2sY281s6w6HS9
 Ep6qXpkemssHk94iGyYGv2fnotQlsFTSycw+VaMxHHDljpESjSUuMBPzLGiPbT1UnsPIjqbHS7E
 B1JrO5VnYezitc/LRuLdq5Sc=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 2bd75f41de4092a6;
	Wed, 21 Oct 2026 06:18:42 +0000
X-Mizu-Trace-ID: 2bd75f41de4092a6
X-Migadu-Flow: FLOW_OUT
From: Lance Yang <lance.yang@linux.dev>
To: songmuchun@bytedance.com
Cc: akpm@linux-foundation.org,
	david@kernel.org,
	osalvador@suse.de,
	maddy@linux.ibm.com,
	corbet@lwn.net,
	muchun.song@linux.dev,
	lance.yang@linux.dev,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	chleroy@kernel.org,
	ritesh.list@gmail.com,
	sshegde@linux.ibm.com,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	qi.zheng@linux.dev,
	linux-mm@kvack.org,
	linuxppc-dev@lists.ozlabs.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: Re: [PATCH 4/4] mm/hugetlb_vmemmap: remove hugetlb_vmemmap_optimize_bootmem_folios()
Date: Wed, 21 Oct 2026 14:18:34 +0800
Message-ID: <20261021061834.6834-1-lance.yang@linux.dev>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20261019090830.1917657-5-songmuchun@bytedance.com>
References: <20261019090830.1917657-5-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 708CB40004
X-Stat-Signature: 3uu441qmxzogbwaybusarz4sur4mhybh
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1792563525-199973
X-HE-Meta: U2FsdGVkX18TX3T/lq2+X/w40Z7W9c7wTGRPUkstHjiggQtm5+Y6uykU/LjLuzC5/FEFrVkZRyE732nvxhAOfBahEcrpshABEt+DLTPZSxm6eZr+CBU/+0owLO6GOLh8GSdcq2I1Fjb5v6xAHqct3o3td405/f31637MAch5vO7WYKZX/xplsCERnJkEItfvZ6rJw0Fl52KfPzH5xVvEMKbhNsjn2Ks4h8WG+kVL+BiHA7gOK+Xem9vtoGiRBsh1DHxs7pszszTYL4MqScK1cX8eS5yKoWLdJXlaGVAc0w0sQBlBMGdRB3+oqcjmeXfzl72oellfrIlieohGaH1kXG11+XSkmiSesc5Yrg8CVp1JNdLMhEjATJV60q6fgxU7dozg3+gFxokig2RXeJ5xoG9CBIv7s8Nc6TAnnvjRFbLWE8NdpWR/FeDPUJYRpoWgx0B74KckFeAOQU+UxSuJYMmv3TaUH04b454TP19e/GNQEN/5wFnx1npiSYDT92RSztrtvYIUsk0C3JxIA0UkiQzFefPzPVb6di5E82W6tdjwkOvUb9DqbFtIkVa3UkPqpr7eNGz3FkYyXVWvV59y3HxK7zo25kZY4gee+GJ1Xq8MraqtFtnjy1zHFUmB4U3lYFwQM6uZJD8H20g7e4SjxZnB0NErGfDqUTqQ0ymCYobu6nTSe1+vlCPF+LUaNlxVc80L32QnSGfo7pxDrK0C4+O79NBu7XPfBPQ1gqpAq0+zoeuQjoEKyswjJhie/qXRca2xpAnaxypT8Wph76n6fLp1W+sP9AGEN3tWAkU8NdeN/9TaIF0uGzss8lq2xIGQslTxtPAHibz75Oyvoh/1am3O4lpOZ4wmgp5j0836MK15GGcl63GQtA/5aFS/KcI68tzB8KUkfhURNs7Ors0Bp91CUGMr04SK+SXX4LeLM/NyVuWSsnX6IitAGRROwvsLS52p1sVBWwoMOp0Unrz
 FvLlMVSt
 ihgKndK/Xq2TZ2ZGWtwlzX7h16s1DG4/VlbA5mxziUNqpY/8O+72L0dq7FI4kvsSwf5PO65EIPrH5yK/LE6QSaDvXBWXWyx+00J/d61G1MiZv115FBrzhFk8g8X8+o1mBXAfJe7pDadRaSTcXmtOxv3hIbnELdBwhgnKbzNYGwt807kYyCaD/F6q0GStEqZL/LWrjYelJSjPKRrUATtP04AkpvhDgVL6C0SNzwFix93xyLZHX5oqkw1+Od/pR0q7Y1o0KV2hMbhJNUrlo+AFRBH2rHyU36dtSO0FLcxLIUb+vXqFZzHhxiPNBPDUvQ5ux9Rr7gNWL8tX06uSqCCtdl8LjIg8MJ28CDYbRv2UuICiEr5U/HTigt2GxdvwSH5JxhPff
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1


On Mon, Oct 19, 2026 at 05:08:30PM +0800, Muchun Song wrote:
>With vmemmap_wrprotect_hvo() removed, the bootmem wrapper no longer
>performs any bootmem-specific work.
>
>Call hugetlb_vmemmap_optimize_folios() directly for bootmem folios and
>remove the redundant wrapper.
>
>Signed-off-by: Muchun Song <songmuchun@bytedance.com>
>---

No boot-specific work left, LGTM!

Reviewed-by: Lance Yang <lance.yang@linux.dev>

