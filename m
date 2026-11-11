Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 87784606A31C
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 01:29:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=nsBkOnS+
Received: by kanga.kvack.org (Postfix)
	id 58B6A6B05B0; Tue, 10 Nov 2026 20:29:23 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 53C466B05B1; Tue, 10 Nov 2026 20:29:23 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 42B1E6B05B2; Tue, 10 Nov 2026 20:29:23 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 0ED736B05B0
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:29:23 -0500 (EST)
Received: from smtpin08.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84D2614017C
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:29:22 +0000 (UTC)
X-FDA: 85421105364.08.DAFA9A5
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id E0FA640004
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:29:20 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsBkOnS+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794360561;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kJDtYQ5RM/nMy9qPHT1eQaGhKo9m/wZ8gDKiqQSYfNo=;
	b=e2qJv+Yh2ygk22azNcQ06mDf87EvwsinpYhp7fv+Ej26Zrl6i+DcAkiNuYRQBSgrTTjC9H
	+bmc5CwpCbohkzFbQ7WCI89RKuK7m55dw//FjJytKKoANrCbemUCjwQ7ju7u3BkxZsbkNB
	VqSEE2zvreTqw8MDA/wRMe4eyCWCD4o=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=nsBkOnS+;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794360561;
	b=p5uranpjLU8CUHzujLnJVKeN2BHQpr/PZiwKP0XcsQdGaB3kqic5zrrGeLeSqAdtS4Jqiz
	AHYFtPV4n/rYHO5AdwSYUGg4dR7Wh/NAuUxRToxFRNHdyiCRup17pDFMmMVr3pVOY2liWa
	DilwZRALlehkahqh55hegMiOAjz6dV4=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id DCC56446D7;
	Wed, 11 Nov 2026 01:29:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 826431F0089F;
	Wed, 11 Nov 2026 01:29:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794360559;
	bh=kJDtYQ5RM/nMy9qPHT1eQaGhKo9m/wZ8gDKiqQSYfNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nsBkOnS+I3Q6gFW6yrtdxkTfq4jtBsCUe3//dHOR2dLA/3s5qKJDc5TyIDrbtwpCI
	 P0353Bwo4LZmGGMeb93HFXxbwlOSfnSRkY4wovT9NIDjmQzZyHYjFIA/paJVXajDMR
	 ihjFuLV9AYj18OZ+Uhg6OhyNipSwyZh2norzxpbWhNDvczeRfSI64Z2n5I1MJI3D6C
	 tuisH1NXT/GQFju70EAlv0tUcuhHPM1LeZVEjNlrgxxwttrzrn961pHV8w3TSqOxpy
	 22BYiyDRqdJcKA5Xq78h0EuN2yrZQmZ3ZEgvUbuM1Y+8G2S27MpLlUTNXNoM1FrM7R
	 Q1NtTqgVIC/uw==
From: SJ Park <sj@kernel.org>
To: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Cc: SJ Park <sj@kernel.org>,
	David Hildenbrand <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Alice Ryhl <aliceryhl@google.com>,
	Danilo Krummrich <dakr@kernel.org>,
	Boqun Feng <boqun@kernel.org>,
	Gary Guo <gary@garyguo.net>,
	=?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>,
	Benno Lossin <lossin@kernel.org>,
	Andreas Hindborg <a.hindborg@kernel.org>,
	Trevor Gross <tmgross@umich.edu>,
	Daniel Almeida <daniel.almeida@collabora.com>,
	Tamir Duberstein <tamird@kernel.org>,
	Alexandre Courbot <acourbot@nvidia.com>,
	=?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Michal Hocko <mhocko@suse.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Qi Zheng <qi.zheng@linux.dev>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Uladzislau Rezki <urezki@gmail.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Nico Pache <nico.pache@linux.dev>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Dev Jain <dev.jain@arm.com>,
	Barry Song <baohua@kernel.org>,
	Lance Yang <lance.yang@linux.dev>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	rust-for-linux@vger.kernel.org
Subject: Re: [PATCH 0/4] MAINTAINERS: remove my reviewerships, add CREDITS entry for THP
Date: Tue, 10 Nov 2026 17:29:10 -0800
Message-ID: <20261111012911.162135-1-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
References: 
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: E0FA640004
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: kms7e7g1f511gwmkk9u57b891jb4g5ad
X-HE-Tag: 1794360560-306366
X-HE-Meta: U2FsdGVkX18TM+sUoR7IniH8BCsa7PE0/8wFOy7Qe3xWrAq9BiR5EtYpw17tj8qsJovqRwhzdLOQ+Uf4uw1Tmf1aUpFeS7/u1LQ1lxX99SlAG/X35QFec3N0tPyQscGD5ZDGomaQEySI1NQ10sgQsG+s9qJSUo/J0oK5w2N7FOslbXiMTy3n3LpAF25Ggg3JKoMaDPu4bcT/J3rF0DSqKVWsiCVqLrW5qyNpPbWSu5Z0OFq1RTOHkPiTo5Z4NhjygqVA0v+j5taZrj/zy2Mbg3F7Wqc6ylgN6g9HkHaW8Jmt8/axbfHZTNkhHq0UMGx0q/ur/xaCDHpXoEUW+WBQLe+94eMPOH4BkAXfQm56jLLBGrXrKhey4PLSd3WHmGF++ZQqPNQpsQo0n2FFn4ylU6hp7wHRBEclsnjD5LyEx0/UvCuZH5YHD0qQ0OKTxDWbzhsUuzXakOzFdml/yl+aE/15U4Mmtd6ee7tKSv4ypAF+Ui9GH0paBu1pda5aRM0TIE42w1mnE1ix7d6UMalGJJ3eaMc3GIs4aIV47dw/IzHq+9cUEx5aJDhvSGLRnBfgxbHDopdoaB3MwKSH9IdOQxawmQ2vKv4dK+faGDxOhuKvlzPiF13+1K/M3vG60wKVx5nsycXD6AyAvbX3MWzaBzdewc2doMUjRSKm0be8BRo+sIQfY1Dh+kY7eRp35ZPEGTMOsW2kMv/1fPplontD5oa8AMZe5Q0F63vlSXwXBt4NTtdO5npmrvsHHEZLreDQ2QsWAUL0b256WDacCNbR8cyzY0+tqi7GSsuJia1aZpuOYayVMqSBqySHuGId4fs+OML4dxnFHSWcNtBdxaMViDYX5PSyuUigcGZS0+8mYbTg4aBuVU1IWMIuSU8kveIHCOsyW/cXhbA66g3Yi47sOqbkFvAEdjQ/+l+adQM53gj6J5KnLOLfoXB44F9o78wb+K21aMG1p5rUq54MLFO
 DCYHOzYN
 Icyx5A38snoAFhwf4vkQMO4PVW0twjc/yA5jZoBfQ0h2EV9teduGLWMMrH1cT1JNWYOqPNvm7V18anQGRvflK7wsvmx7YK7Ipqb5XvEXqrh0k0LfPqmfphOyGMvS7i9IpE4vgPSH7SmK5RanEGKn7fMifdBe/jmmz7KCa4acWivSOOXmapFT5hHr7Xw00ufZ1jto0HuR5NEwjj901naRGxPHv34/nMQnfnQ1vQCDgYyzCid8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On Tue, 10 Nov 2026 12:03:06 +0000 "Lorenzo Stoakes (ARM)" <ljs@kernel.org> wrote:

> Given the current throughput in the kernel resulting from AI-generated
> series, I unfortunately lack the bandwidth to generally be able to offer
> review except in those areas I maintain.
> 
> I have separated the patches into areas maintained by David, Andrew, and
> Alice + Danilo, so each can take the patches relevant to the subsystems,
> for convenience.
> 
> Apologies for doing this, but given the current trends I'd like to do
> something to make my inbox a little more manageable :)
> 
> Also add a CREDITS entry for THP, as, since Zi's rightful and well-earned
> appointment as co-maintainer there, I have no fear of needing to step in
> there, and so would like to record my time in that role.

Thank you for your huge contributions, Lorenzo.

> 
> Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>

For the series,

Acked-by: SJ Park <sj@kernel.org>


Thanks,
SJ

[...]

