Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05C0960A2636
	for <linux-mm@archiver.kernel.org>; Fri, 13 Nov 2026 19:10:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=KCX1va/U
Received: by kanga.kvack.org (Postfix)
	id D86FD6B05C5; Fri, 13 Nov 2026 14:10:17 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D37316B05C7; Fri, 13 Nov 2026 14:10:17 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C26856B05C8; Fri, 13 Nov 2026 14:10:17 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 8FB2C6B05C5
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 14:10:17 -0500 (EST)
Received: from smtpin13.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 124531C1F13
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:17 +0000 (UTC)
X-FDA: 85431036474.13.101270D
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf20.hostedemail.com (Postfix) with ESMTP id 7BCBE1C000F
	for <linux-mm@kvack.org>; Fri, 13 Nov 2026 19:10:15 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KCX1va/U";
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794597015;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zabQJqh6t7uxEuYlIQWDR7cku3smA7px6dIU8SpBgYA=;
	b=gE2jEpLr/7Sje29D1ig3T9dUERFMyVUPq14oGgMR07oQbXVlUeavTF1hQKnhLnyjQZMeW5
	zUFIvwMrYTx4TQ9lBV7G1BPtDm1LA2bavIujt7BCdG0JK0DG18rZM1iWftINSRWkzSzXLI
	Kht2wgZerBS8vQlGd6gZBe/d6p+wu28=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794597015;
	b=vHcR8iotG7sjDmp/b0kldWWcK1GEjObm1ccQiegvwsdyIUiNb599pd2xHI3rf18YD15W1/
	ECQvjCjc52u3R0fCnspS0O4O3p7uAZHhvDs3C1h3Ierg9PdxCACybOOY/08GAkf9+TdnjL
	XYiDxMq3Id1fF0fK7AgAh57QEJSo2is=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="KCX1va/U";
	spf=pass (imf20.hostedemail.com: domain of sashal@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id C5F1446C9C;
	Fri, 13 Nov 2026 19:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C94C01F000D0;
	Fri, 13 Nov 2026 19:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794597014;
	bh=zabQJqh6t7uxEuYlIQWDR7cku3smA7px6dIU8SpBgYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KCX1va/URfwUs92ucMZeW+ZxpuGSLntx5JR7cSSzNgN7pZFK/p4mUcpxeb4ZIFbL2
	 5/r9NLLjtrUyhmNRtchf6LK0ZANGxvWLoUfJvgTDxvvLMLb5VcsQJq/kVavVoVUFS/
	 9stWE15Ffk6SUoRNX1sb+U5GTmcGOzm85LRYnG/pt/i7G1FOas0+R9qXHLADijOHmT
	 xOXlm1/sQuibQ7LjqtXwvnYPCLaq1q4HI8RkckqbuhIrJK/sXJsI0EwQqRYCSKAxs/
	 xAWjyqiE6bSy+wh7ZEQ778IzdleKaREycr95c6bwBxUPkb/L8i7vDOVXn7i6slu3qR
	 kaZ/Ed+R7xi0Q==
From: Sasha Levin <sashal@kernel.org>
To: stable@vger.kernel.org
Cc: Sasha Levin <sashal@kernel.org>,
	dipietro.salvatore@gmail.com,
	Andrew Morton <akpm@linux-foundation.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Johannes Weiner <hannes@cmpxchg.org>,
	linux-mm@kvack.org,
	Salvatore Dipietro <dipiets@amazon.it>
Subject: Re: [PATCH 6.12.y 0/3] mm/page_alloc: fix iomap buffered write regression from 5d8edfb900d5
Date: Fri, 13 Nov 2026 14:09:58 -0500
Message-ID: <draft-0008-redipietropagealloc6@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20261113110611.2915381-1-dipiets@amazon.it>
References: <20261113110611.2915381-1-dipiets@amazon.it>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam06
X-Stat-Signature: cyt91b71pdkhygqouq46bobxxfe66qwu
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 7BCBE1C000F
X-Rspam-User: 
X-HE-Tag: 1794597015-918077
X-HE-Meta: U2FsdGVkX1/CsI4shyUSj8Hk/BiRhvRCnzf6rqybgrz/4PikNVTjdDDqN5ir5t/rAwSDV23Schlxx4a8Hlx1ijBaqVviEdXhj/kyv7bWZVac0wXXzXYt9+oLldn+5ZWMI15bfdugMEgbz5qPPFJMicUCmfNPQx5J0QiIzxmOnzhp8GKrwxURsecugJPqMkc7smFik8SuHUjjFY99A+f7QDomIYHbGYe06C6/fHBZxg6l5mLjd/nra4M/OkzJygMre6IBpnCPEdx99u7aD3bo8JIA2JaR0n3BidgJ/F1E6NzqI797WYnfjkOJYzOWkQz5Oyh1UVJQoDdJqjyec/t3CDt6rFsbkgdIHW0RfB4tVnc06KDCy9/ovEJNGcMdXgn3czO9ZBBsxRMA0zy9YGhjSb9xXDjYdD4M4tuZIrV4Q6ZEBw7kCkNGjcVL+YqrCcoXAALwfWvZzcS4ypnL5xgWbtsze20wYK0wNzHH8RGipKt/zlEBcbS6NkbeH+hpoQdA5VaorAfIlpX2pYCV6vDoEFWE7mGH+dcecnd/A00Y3djGpAV1awcFc76Nusu6xsy3d2cqVerVhqTa2nfnaWfsvQgSstpzPVYnrUaGGCP4wKwebDowQ2ckG6cnuzO2tkmn1VECe1/yckQPSaNUejj/UlfWspUFZBhzK+CmONkiSSKOQPMbYcx7Az8D/IQJrt4C70ed/S7bPhgF2yL9SxT4PAmA5gv2pu5JJJj3XvTkUeDtER7NS1RBlwlKFKi6icbShw95wnMVLYVA2PxfmfI1R17P2ffQdIcKGGUCfeNbXghSvaEi3hOAXNJcMkk1Xr3QHsu95r7D1TG+75LkD4/O2BppFNGO2PyvKMOP7oo/sUbVDA+ezpQYwnPEi+RjYhFDQhnX+1zA1KBETN9HLRF+Ew+dl71wwxFE8reRFtQy/I1lHStaH1Tz311KIYT8MAMjW7jka2M489erZdnW8qx
 WZMzQnWL
 cPqIL/XizYjQHKrGHnSYuBE6u2T1KcEHx69779M7A9ipPcR8Hq0JI1mTo2gfWAzgDozEQE7VfyuF6zohSWCN5ERfa/CAfOzWIvW5nLWGuL17NYA83PbBBo9+2pofWnPbsd/8Lynh9JnQO3daCJeit813OONWdvt/uJQ2qIUPzwTWxWnWnqmecnp7B5ctRPM67XYolwUxRxrwLvfh7YBrcZ9ZOAuUyp/2f+b4/Z7jMFsbFIuMGqW8MkngFSPxrJOG3cGtuHohpW/1J944tuFC2utfOM5wBf3zLVEHobnZFDAGrEzXsLEh1kl2LWGQtk5XHlmHSPwa1Fu7BxAfpXUlPGWMLNCvtsKYuqfGGNn64W9/v9Co=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026, Salvatore Dipietro wrote:
> Patches 1-2 are its prerequisites from the same mainline merge (Cc:
> stable), only moved from mm/page_alloc.h to mm/internal.h. Patch 3 is
> adjusted for this tree, see its changelog.

Patches 1/3 (6ee3d87b9408 ("mm: page_alloc: do not give all non-blocking
requests reserve access")) and 2/3 (fe21f930d1e6 ("mm: page_alloc: remove
ALLOC_NON_BLOCK from ALLOC_RESERVES")) only carry Johannes' and Andrew's
Signed-off-by. Since you are the one sending them, they need your Signed-off-by
as well; only 3/3 has it.

Could you resend the series with your Signed-off-by added to patches 1/3 and
2/3?

-- 
Thanks,
Sasha

