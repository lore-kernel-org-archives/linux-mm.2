Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 243AA606A31C
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:03:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=JCZx8O4M
Received: by kanga.kvack.org (Postfix)
	id 330886B05CA; Tue, 10 Nov 2026 07:03:46 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2E0FF6B05CB; Tue, 10 Nov 2026 07:03:46 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1D0306B05CC; Tue, 10 Nov 2026 07:03:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id E18F56B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:03:45 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id D8130C05BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:44 +0000 (UTC)
X-FDA: 85419075168.17.3B4A714
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf03.hostedemail.com (Postfix) with ESMTP id 25EC32000A
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:42 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCZx8O4M;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312223;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JqBx0yzByauj+DMV1nyno17Po8meeyCDbZXiNPgYBhk=;
	b=iTH2wStpA/rStjyqQTJdD+DGprBjPgOLrhkPgSPIZfB/geO+uTO7xsxkxPoibpQzIKblPm
	lJ+W0c0OusidRV7rXLG+lGBsroaCXW9znF8fGFp8DzpTc6skfT3he8IPcAdNYSilDHA9F4
	YWEMm1xKFNguct1zE/TQhH/sf85hVR8=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=JCZx8O4M;
	spf=pass (imf03.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312223;
	b=UCIZiJHdP/9nu0f2qSAzICYfCYM5FKnL/ZPN/5K7Y/IqCFnynNRCmNdq6fdcdW8aliYFKE
	Ps4rpWWH31FIb2ewaYMYC7g6XuvdyjRQF74EyfR2CWXdfBBB+y2MUdFXDZOpl0W3dKnYA/
	p0BmCnN2LOjSVBXmCk+nt5TGaGTABoU=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 2F6A8429FE;
	Tue, 10 Nov 2026 12:03:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD4671F008A2;
	Tue, 10 Nov 2026 12:03:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312222;
	bh=JqBx0yzByauj+DMV1nyno17Po8meeyCDbZXiNPgYBhk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=JCZx8O4M4hGc/8Bn7L3F9RADLN5n41NYkCJfUUO/4rhPpwAJzQTHSmU6bnD9GZ/hI
	 2evHiCX3cUjXiwsXUB/m0GiauxaQSWbJ2ssp+bCCKTirVgKSpJ746kJTEYAEeptLyY
	 l9xD32bY7sy2enVtJOdq1kZGceBgSELpIL/Riod2QdyPaHMkWbO5LCDmU24qInzg3Q
	 EFAdtlF8XgRZjlVeSDcUx1cLNaeX2Dytc9cbqQUzsYW2+hB6y9HDoSqni46UGC/uev
	 dgfxWC7crqTjYAk6lz9ccOfur9hTEkuhg2LQqZU9AXYAOGpVIRN3Ur+uqVKRUs5YD0
	 FNDctkE4t7Cxg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 12:03:07 +0000
Subject: [PATCH 1/4] MAINTAINERS: Remove myself from MM core reviewership
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-drop-reviewerships-v1-1-07c2f06e8dfa@kernel.org>
References: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
In-Reply-To: <20261110-drop-reviewerships-v1-0-07c2f06e8dfa@kernel.org>
To: David Hildenbrand <david@kernel.org>, 
 Andrew Morton <akpm@linux-foundation.org>, Miguel Ojeda <ojeda@kernel.org>, 
 Alice Ryhl <aliceryhl@google.com>, Danilo Krummrich <dakr@kernel.org>, 
 Boqun Feng <boqun@kernel.org>, Gary Guo <gary@garyguo.net>, 
 =?utf-8?q?Bj=C3=B6rn_Roy_Baron?= <bjorn3_gh@protonmail.com>, 
 Benno Lossin <lossin@kernel.org>, Andreas Hindborg <a.hindborg@kernel.org>, 
 Trevor Gross <tmgross@umich.edu>, 
 Daniel Almeida <daniel.almeida@collabora.com>, 
 Tamir Duberstein <tamird@kernel.org>, 
 Alexandre Courbot <acourbot@nvidia.com>, 
 =?utf-8?q?Onur_=C3=96zkan?= <work@onurozkan.dev>
Cc: "Liam R. Howlett" <liam@infradead.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>, 
 Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Qi Zheng <qi.zheng@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Uladzislau Rezki <urezki@gmail.com>, 
 Zi Yan <ziy@nvidia.com>, Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Barry Song <baohua@kernel.org>, 
 Lance Yang <lance.yang@linux.dev>, Usama Arif <usama.arif@linux.dev>, 
 Kiryl Shutsemau <kas@kernel.org>, linux-kernel@vger.kernel.org, 
 linux-mm@kvack.org, rust-for-linux@vger.kernel.org, 
 "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=openpgp-sha256; l=752; i=ljs@kernel.org;
 h=from:subject:message-id; bh=OH5BliIH94nkWp/ohQ8/EQpKL0UvlMGgtBbAdMYML5E=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+c3AnCZdKP99y2aHkfh9Dotz+NPGfjbFWIleZWxQYZ
 +3Zv/ZmRykLgxgXg6yYIsvzL+L7g0TC5nVe8HeDmcPKBDKEgYtTACbyqZiRYQ+n27HlXRsr/ie6
 ZuXU7BL/mxJy3Nxk54HyCI3nx5unBjP8Ztmcyveh4XPSETWB3WqL3jzKr38Txr9uRrf87pe3mno
 dWAA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: xjz99ffpobatw5pr6p83qeq387hswkuk
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 25EC32000A
X-HE-Tag: 1794312222-680594
X-HE-Meta: U2FsdGVkX18Xf6QWQZtQ4l7l/f8vaHLpQCAx5xZ41v/xQT8oXq0e0w6CIRnHoKb4Txy2wMWudGAT2E9hSJ3fLMaT0tY87X7SJXRJEAXEj2kpPuCV9FzcLqL/nz45uKQq3IOwzSOzi/dPK+JegPyakZb32JF0qINkY2ypyNgT5OFwtxA0nknIDrPwBYfP5/COuWjDrY1nhq2Hkkv9zCqFYFU0gj5301x8HfU/+2kMqZBvGrzhAfBNBWw8UxstxyKJ/HwrS7ZCNMZQyKE9bSchWc1cVnL/Fd+NccVH/WB0YQMjlEU7Ag6j5ekzUXWythb/Yy/6rub+AlOpBo3450wFTNGT0JxX+ot3p/iCLSLT/nR6bbL0M5uNSuNRtGfAd24cDZI2Vj/1bhhVL+8CQ1Rrq/+97ymkdiycnQdQk+aJhR8uke2qGxKyeo/NGG/a0N1mtRdqum3vnCKRmKPcm3xRALwERCdgM8V8dkkSKg/OnX3N/ztmmN3o26Ak2gPZeI/vcVU5kwMfdVJHPZJR54+P1+dGvCUlJ8KHPwkjVk47ZaXHG4IMlGA6Tlgkf0/Zrk4sZDTXvOtrDTjuc8HLYygstq2gka39uEISGejWtZpY69qZV6r0oyVxg55liWpmx72jq75sWoMzr2bEKhM6524l2fsMtithnjRIZwG1h+2NOKLG5TW77tTctqcUlIXhlEQ3OSW3MCqtv5hIcfMkuFbFsleu1AA8z4qxqvgWoRJnmNCcXdOuaaeVUl8P1phCPzpVt9LGDxU7keCC8fkeoIZvtQA+ebSKP2Tzbb8pyOaaQW4IsbN1qECb1/csj5pV+i63JhRxiV5IcjRbbf5ES9Nyjdor9lBXoNSxca4j/4j5upyp+KVxDVSzpWySdUtrJjxid9NO0GrKLO8x7bq1jscwKkmA0e1JnGERgJTTQTQ+upNFHIRKrKi7qjriGhvFgoj3p5MQ5tf0RPOT3HLlZPh
 K7ClEd2V
 LkNlEhSPADB3CA+3iA8HyvCJErzU0JKbGB3eD3F2ypJOCpcoM1ibYOoLG3T3IDX1nvrACSGZRiamFMJMKgTx4hZa8dgGd/04UssLk43MyIR1TcFr2wmfDNxJO5Hy1pY8SSuMDCdoOP0jZsc5fFuK9YTBe+GViQ2SDqR4lwXGY0O5fVRx4n344PdDBIx0S43OpBPMdAuAiFQ5SgAZo9YJ6UJOAP7KOG4x3BaO8+CGrjAKm65aD8MfCfbOngT9YrnILkVICCV3vw168+qVaIf9QtxHXfEhSSRDHWEKsgacDSjN1Y2LuH2bNLQQVsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Given the current throughput in the kernel resulting from AI-generated
series, I unfortunately lack the bandwidth to generally be able to offer
review except in those areas I maintain.

Therefore, remove myself as a reviewer.

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 MAINTAINERS | 1 -
 1 file changed, 1 deletion(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 222b7fc2c3aa..c2f7fed0d850 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17505,7 +17505,6 @@ F:	mm/balloon.c
 
 MEMORY MANAGEMENT - CORE
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>

-- 
2.56.0


