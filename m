Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5717860703CC
	for <linux-mm@archiver.kernel.org>; Mon, 16 Nov 2026 11:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=YFu4j6UT
Received: by kanga.kvack.org (Postfix)
	id 70F5E6B0604; Mon, 16 Nov 2026 06:18:25 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E6886B061D; Mon, 16 Nov 2026 06:18:25 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5FCBB6B061E; Mon, 16 Nov 2026 06:18:25 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 3B3356B0604
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 06:18:25 -0500 (EST)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id CA3FA80930
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:24 +0000 (UTC)
X-FDA: 85440733728.10.D4F9004
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf30.hostedemail.com (Postfix) with ESMTP id BC9528000C
	for <linux-mm@kvack.org>; Mon, 16 Nov 2026 11:18:22 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YFu4j6UT;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794827902;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pInkU1Kj6zfIjFRdKgRmxjnKdwV+M8/pK6hiBzR2ods=;
	b=wGtsZH6bvc0rt3U5omIZoEhlgL40cTxa9Wl/Jb1lefr7Z1NcgiC4+r3dsuyH/yxCOdMRin
	qdfSmSFIJx1qh391aBWUxiNsVFkPESwFVvMrkeb8tu9pejCOpArQr1CtkvwLv7uC3Jlv4Q
	OjCOZM/LtP/JXE3FNyZJSPFzxMKkOGY=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794827902;
	b=pEGFSfseMEHvytTM8LjhffP+ZIWMO9Vdf8mXCJD6mXowNIvpTZ2XFNSBSuG8JbbxXZwPPC
	JIMivu/ly5qYtfnlIPfRie81WBK4Ntv3udoLkJObD68eA4rV9Qg5MtT4JuVA+xb08E0V1a
	S2i725UlH6v/WATlUcM/XAIl6IXkqrY=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=YFu4j6UT;
	spf=pass (imf30.hostedemail.com: domain of kas@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=kas@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 1198C41A41;
	Mon, 16 Nov 2026 11:18:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E7D91F000C7;
	Mon, 16 Nov 2026 11:18:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794827902;
	bh=pInkU1Kj6zfIjFRdKgRmxjnKdwV+M8/pK6hiBzR2ods=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=YFu4j6UT5ULC/Wpu4+KyWDjm6pFeSFT78Jr5Y2tEVG2ZjhqbqIJj54d2Xf5k/FRk0
	 GvA5lLs2yMEbPT9qabJsgfvWpPUl60Q3tlEiel60ZqYYdFvPKnmK1Oo60pi+elAxRh
	 hO+U+xKxpxG4TzyRi+SSsLXIkvmXeUq3ZYpUJKUxJHYKcRmmQptwgjEBfTmxj2F/Ra
	 H+8dbl7siG03M+0qRpWBvATvQ9LpnBXSfJAhTjJ5ZMCcGQK54sLQwaXgDVmILXtC7+
	 ZpFu8l4nMega2NWEyqAhC1SNw2+FsGWbxqe7dn+/tSWNNNx2lV6+SlDYgqfpewxH1f
	 3tebTBTVM+Umg==
Received: from phl-compute-09.internal (phl-compute-09.internal [10.202.2.49])
	by mailfauth.ams.internal (Postfix) with ESMTP id 26FCB198003A;
	Mon, 16 Nov 2026 06:18:14 -0500 (EST)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-09.internal (MEProxy); Mon, 16 Nov 2026 06:18:19 -0500
X-ME-Sender: <xms:deb6av-zhn4UO6SdC9g8DgVodC_r7Qj_roodrs9WoCaIMWyAftrBtg>
    <xme:deb6aqLOlkggipP037eX6K_dJ5eEG6hNXo5LDFfjrp3nZTdqqBkZ1Nb7VoBE0TkZ_
    JrHh6ocp8yikgswn2tTy7Wa26qUaIYlpIbcgX7U8IfBMq-YX6lJkS4y>
X-ME-Received: <xmr:deb6akIOoF67Ycx3cI2pe4jE0Gh4n8Dw8dWrDpif4BkQSiyVUL7FBuYHrqo>
X-ME-Proxy-Cause: dmFkZTF0r54BgXdUKVHIIJLSxT1HUE8NMy+LX6nTbiUSt5B8TJTcqLVbZZh8ZRYGxOuiID
    I+9mEJoA3l4liwzf6OgguPCU94Yg13dir1yyQwjAQWjSXsuRKra8Aa8G7BK3FTh9HRP9Jv
    rj2cvt/z3cYpCGQ652b1ZBsuDX3ET4qjRSaLgC7WVmy5QVQTXY6sbLmFql+2DIr0rx7NhT
    M3uyi2NgsMt+zsW7zVSvCNgsfMIubG8+6aGmigIVwvy8okaCH1oKXVa1qr/yXDaXXUQhYL
    wQtnRcPUFJ8BoWqQLjWwv3vO8EB3TloW6I0sEs51CXCiQbhRAr0U58mh5FGUEhmjvEHWSn
    +VPClTVclES+wly6obFvXaBTbp0sdFCQVGmujFiHNt38j1bkOpFJP/hVszvj+kUEv35otN
    bmfgbpEzJae+7EBTBr16f3Ud+kCvxV2IXr1ntzK4o3iezmgClOlPvFseV0vflmxxYZ9iou
    kESLDD3GWrIuV/2TnimqZVAVpo3pb7YwUYkv3YHS/oFWN23u0wO22+mVta4CsJV6Q+JVjr
    42Xv3GRmkfN+/Is/JtGxh2xOrS8zHYVLimTuxF/xmbjO7EaTmdSUBpKlHLc63VrfFOnGq8
    ih6fQpFWjhuAt1G6ahVMklcAm01IQCnni76TUU1iXCK63PA9DCxg8g0NFnmQ
X-ME-Proxy: <xmx:deb6avASCCqAgKooRs_OHb_k04EofBRFHYPkDKSovsjMCsMNfnK8hw>
    <xmx:deb6annMl92x_IHuqdgUCC202iUwUi6CRl5td3U-fDcohK7NmEPJ4A>
    <xmx:deb6arF6hPMnQg6iDjfI3g3yPFaHoEonqnf6uFZGYGEZxs4uD06pxA>
    <xmx:deb6amj2_cj6M_CrprWZdkWb2H47YJLmvK3KRAG1FsN3TDgc_8GFXg>
    <xmx:deb6ajc_0UmiW9_O2vhBOFp-bxsnlE61bfeHCCShXbhxaxQPAoaNB5Oh>
Feedback-ID: i10464835:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Nov 2026 06:18:12 -0500 (EST)
Date: Mon, 16 Nov 2026 11:18:11 +0000
From: "Kiryl Shutsemau (Meta)" <kas@kernel.org>
To: "Vlastimil Babka (SUSE)" <vbabka@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, 
	Johannes Weiner <hannes@cmpxchg.org>, David Hildenbrand <david@kernel.org>, 
	Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
	Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, Lorenzo Stoakes <ljs@kernel.org>, 
	"Liam R. Howlett" <liam@infradead.org>, Mike Rapoport <rppt@kernel.org>, Qi Zheng <qi.zheng@linux.dev>, 
	Shakeel Butt <shakeel.butt@linux.dev>, Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
	Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, Wei Xu <weixugc@google.com>, 
	Baoquan He <baoquan.he@linux.dev>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
	Dev Jain <dev.jain@arm.com>, Harry Yoo <harry@kernel.org>, Usama Arif <usama.arif@linux.dev>, 
	linux-mm@kvack.org, linux-kernel@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 3/3] mm: vmscan: tell direct reclaim the allocation is
 ALLOC_NOFRAGMENT
Message-ID: <avrk2Vn3q8FUI1oZ@shutemov.name>
References: <20261102093939.3340540-1-kas@kernel.org>
 <20261102093939.3340540-4-kas@kernel.org>
 <e16c46e8-d69d-450f-bf98-6f14755cdae5@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e16c46e8-d69d-450f-bf98-6f14755cdae5@kernel.org>
X-Rspamd-Server: rspam06
X-Stat-Signature: up4pbtm73thxbpj85gsnbewfasihx7t5
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=no
	autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: BC9528000C
X-Rspam-User: 
X-HE-Tag: 1794827902-979838
X-HE-Meta: U2FsdGVkX19Lu4QZc9LL0PFeqqo2ldaKo+Z6N6/DTe2CkBZ7+TJB695YF50hkyWbTBbRJFuIPZEyAnYtinVt9+bwzgwuhqdKrELt5aOfXAFwrS2Z3XBOC21yY1hLy2xM2Dt7QLt+YZDbhHR/XaKzxe2SnbrODuUmNlPe6MCAkNWSzmiSt/bM+yY/MEZbY7VN9L13oNPr8s/cshODw+gllP9pypZgpOEECDBIvIOq8PuJRV3Et+r4Tc2lRz0aIR2nKvwEf21RpkmD74pIACRCkUlzAL/CQkH//aNTMcAHU6YVBi0xIp7VQmT19h31/NTL2Nb7NHDoB5ntt0G9vz4sYVq+eZz7HxEN9PF4K76VMYmlG3tE7qk3oEwsJ0guipIFjoxu6gg+0yDaVqo513D2zJxmPCZQzPZdAbhDZHmLQF+V9vSLpbSPRF7u833z01GIgzY80jRDVTlKWNnDUnZX5g4TSc3hPgOhrxMQV1jiOq0kNKDsHZQrCgOoKAjm4Mv/F8IAxfnfNVxF3q2nsDZLQEwBuY+bNKw55UY/sOt1+rXwSEw1vWzxIzvfISLnqTv9tuC6ll1LaLLDzINgBCiN4jq1qmCRaRz699w1WF+mFWfEoD8iFE5bfKYPikForUkLjWSNsf1Mjg6B+1DZlZgWn4EZg+y9JzmyJKqmavXOcdh7OkiaI7JdROOVxwQyVZ7aHIVsNMJ1DT6yz0NYMgmVLLgmbjISiVqCseRYyoNRmCcK/KhFdktlqFAMZjXMmGeny8jnvmJX+U5XHJBPGfKUysxc1154Y9xVHYYWEzn0jzyT39otW7YGCv4gsT25PZ5+keAfBfZkWbckRSvTQhQOAiITdMmwceVECnahNWNgZi66v6DPrj04ZIRUr+EXPPShoT33IgVPpxKA4ffZ1wahmLDmGnZhIHbG65ft1yFlW27Bi+Vej3U5XAhp6jhHJMN95mN3pm7h//FW1Vb74bp
 /8VSNhhJ
 +SplVjdzLP6SahJybK+Se86Xab2a/r44ySM62oSc1XUsnXTPy7egre33euSn+DX6U32hqJG9gnT4vUGZWDchkN6pQgNoxAp1VdIbAbSudLdXpS3U9A8GmbgX9xexRfnC6i42jW3xRvejJLdcH2HodlsFZZZVZTsqTjPOwKPi9jeENtL6oZa7HGLHBJKGLwM9KGsS65PTWlRIwHZx0vbx+hC8V5a3GxFMtgjmh/4AqOrIupozldu52BRe9g2/u6yPr1g3zXBAb43wbQhL4vKwstdF9/Nwzn4iIWNrM9qxMaxiZj/g/3EwvgVPUAg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Fri, Nov 13, 2026 at 06:58:05PM +0100, Vlastimil Babka (SUSE) wrote:
> I'd perhaps pass whole alloc_flags to try_to_free_pages(), but other than
> that LGTM.

Passing alloc_flags down is easy. The question is what reclaim does with
them.

I can keep using only ALLOC_NOFRAGMENT from them, as the nofragment bit
in struct scan_control.

Do you want anything beyond this?

-- 
  Kiryl Shutsemau / Kirill A. Shutemov

