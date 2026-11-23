Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3680606A685
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 09:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=BSsAkja9
Received: by kanga.kvack.org (Postfix)
	id C3E676B05B0; Mon, 23 Nov 2026 04:17:36 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id BEF286B05B1; Mon, 23 Nov 2026 04:17:36 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B050F6B05B2; Mon, 23 Nov 2026 04:17:36 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 948076B05B0
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 04:17:36 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 4E02E1407C3
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:17:35 +0000 (UTC)
X-FDA: 85465830870.13.4FAEBB4
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id AD17340004
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 09:17:33 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BSsAkja9;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795425453;
	b=wImIA+Yq4Y+5CUkUCmsa8fbDY4PicGLmik45eEhTkGWpAViDmUoliUmsC5QZtRzQBYhwzy
	ewFraLcOE/n7O+YvWevy+nJhcDNx1cF5+Zyc3ufPc9lybIDPWmHrSvT4NHeEHHPbkDyP3A
	auT6YO8P+itAUuFWZMOsYtI6/VEzVyA=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795425453;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pAeqH2lbSZ4Ao4jPN8l2z+KhJzrF0U/3yuXon/LVDYA=;
	b=hcZjIF43NhfajrBe8dhPK/duXZYuceoeB50Zq4dZIYIJZfW0se0HltTyu3CuRDZUkgmcEj
	xmSPA6FxXCy50PONaeRML6GNZDnicov4BimliWLhk9Fx3jAtqnK75cvwh35ipzdAeXOMNw
	sTGHbAKmAE8k1LpR5OOkPCrCKrD0NWI=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=BSsAkja9;
	spf=pass (imf12.hostedemail.com: domain of osalvador@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=osalvador@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 8C5B145675;
	Mon, 23 Nov 2026 09:17:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8AC21F000CF;
	Mon, 23 Nov 2026 09:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795425452;
	bh=pAeqH2lbSZ4Ao4jPN8l2z+KhJzrF0U/3yuXon/LVDYA=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=BSsAkja97HyWf7GGseray2KaN536PM/WTiRetMCPtOR0y/38zEIi+oQ+85HbfxqeN
	 +AUUiMd5Mx+aucnHHVTBsqKuJShD+o0Tvv79KhwxRYASxacA4zhoUPfrAfdQk2BFrT
	 K8IWOa584LLX3/C6rNmDZFv7tUKHgKLFlH1NjMvFS8BzZGFwvIPdqc58TbR9H4lSjk
	 5/x1d4lyRfdF0ZWoFwwXk4l3KNGycZEL1zMr3LvjYiFRTujlDOxWr6zjWbtKtU0p9g
	 w0QauuNJvtK9xMHNyrTygWlzlr+20N6uOD1GTYF7lqQEMhiEUepZUCA9qmKCb7aqlD
	 3zaDvivrn97vw==
Date: Mon, 23 Nov 2026 10:17:24 +0100
From: "Oscar Salvador (SUSE)" <osalvador@kernel.org>
To: Muchun Song <songmuchun@bytedance.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Oscar Salvador <osalvador@suse.de>, Mike Rapoport <rppt@kernel.org>,
	"Liam R . Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>, Michal Hocko <mhocko@suse.com>,
	Muchun Song <muchun.song@linux.dev>,
	Li Zhe <lizhe.67@bytedance.com>, Andrew Popple <apopple@nvidia.com>,
	Balbir Singh <balbirs@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	James Houghton <jthoughton@google.com>,
	Lance Yang <lance.yang@linux.dev>, Qi Zheng <qi.zheng@linux.dev>,
	linux-mm@kvack.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 01/11] mm/mm_init: verify zones for
 template-initialized pages
Message-ID: <awQEpDupp7uEiRTu@localhost.localdomain>
References: <20261120100856.16929-1-songmuchun@bytedance.com>
 <20261120100856.16929-2-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20261120100856.16929-2-songmuchun@bytedance.com>
X-Rspam-User:
X-Rspamd-Queue-Id: AD17340004
X-Stat-Signature: yx8b9mybcxd8bccy6nnoan46yo3ywqyt
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-10.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS
	autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795425453-186577
X-HE-Meta: U2FsdGVkX1/NaCuoKU6hgy0p6Mi0Iw+hogO7knfr6ygOVCAptqkAs2V4nw6xJfzhSOI1n1MVwix9P3WeacL7m4lO3dy7NyedL1W+awhXw7bBPBGNTdpnoiM4y3pM+8Ag568SZsNQ3PNgB+HO0xzJ3plWDZST+16SG1EflTLcGFiNZ5lS8f2qoG1EHAlIKrDLebOcRsSLGd/nCOSMIzeaHahVZuBNmwy17+FNAEBcg7TvLK7bIsALb+QLT0U+kLErC925c4AlVRFdqC+mnn1kpM3y7tf5sPW+b22rf4DhgHfq1DEMwvcvrgZoi47gHCn92+sMKeIqNFRjnPyDwwIIhMStmLTyqrHKWG3YtDMJdkJ2y2ittZ3jOnGhX1UfkBHaAhkMPbeTirRsYSZpsThunprA0mSNTvjn6X+0NY+gW+ovKMinPs2xw8VhsIXko1rh2/hU+xMjc+hCfCy/7aOIyu9xAzmg8wE88hirK3ieDgbsTAapfDgE5UDSM9Ljv/dK3QQeGDyrZgrPDXBolLwyRo820IYstPEhWb2ICJ3iwlFxQccV2rfgy286w2eS3PzlwypvFP4CGcMGKt7SEwC1mudxiSKBhTZHAAd6DP504yyI/ST7OPy25q87mtXoV5PDZXvjvGma40vHX+FrzT2CCAGoFdHZHrFLY9obsyAH5NBOesBbIRVEDfDnCoERsCJFghe/jmNSUQweXR6KOuroUAP6ke2TFxfbXJSngmGX8+JdNhsQ4P9l1BP5vJN2uCptGV8xkMg5/P612loI1ELQKbmYcpP7pA+OaqlE5GspElVwAEa6nvql5f1Jqe6JaWfFhdzWJOhpSP/sEbmAw/bsL917SsBb+Y+WFa1CrajLnyYuXBsRKQiLfAy0oORSFx8s0s0v0tPWEK5GTpxmKUZL5axavMxXdlKOxYgS1xIQS6GNx6oD/BbqIMDeyfxkpEPkMEeezZ9B6KeoXQuoEm9
 QYaI6o63
 K7M+xSQbuRxxnET00LvDMjjxxKfT+CvWV6ikgAdPtATkLCcS/kbwYN97G10uUGlql8N/2gvL4tLqfDE998jdR3ymju7JrT6phxmtztUqizsiETMFKoXIUuqA3SmSwJq8nSHvdXICWc5y/3XfdNW0XFHyo9GXie6+J2fC745hWASlfNZtJQm8Dc3dzL/wEN9F9V8JC+iKK/4fXc1OBzUXKkRR8vbmA6n9Jc2c2oWwjECFUvgWryEKY/I5zc5szzeUDg+T1gPPzU06el2x+cmhLOGR0tKNDwDapoFs+9NdZBtcgc/oy6yj7bcJf2X2k7J6pWeVLPOXSpnItJGVtVN/1sNZMKXlwM6b0Ybmp0IwWWhK51XOCQpbvHRRaj0nepwvqc7BfCIZxYawi3C4z23T6EUjWc4koXm/5gqdvCcYhnYTsUXiti0o96a2s9cm56rqCeJ0yaVBpGtozg47apx5/qeW95jMcVz5K1BMbkCNjlyapXvd9apyXpIbMCZ81EEJk0RtOfFT8amFTDOLrKh/x0aNO1uiUd1gYz629iB6oS7vvj2TFWMZ3vl0vCQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 20, 2026 at 06:08:46PM +0800, Muchun Song wrote:
> Template-based ZONE_DEVICE initialization bypasses
> __init_single_page(), which means copied struct pages do not run the
> vmemmap zone consistency check.
> 
> Verify each destination after copying the template so the fast path gets
> the same validation as regular page initialization.
> 
> Signed-off-by: Muchun Song <songmuchun@bytedance.com>
> Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
> Reviewed-by: Lance Yang <lance.yang@linux.dev>

Reviewed-by: Oscar Salvador (SUSE) <osalvador@kernel.org>

 

-- 
Oscar Salvador
SUSE Labs

