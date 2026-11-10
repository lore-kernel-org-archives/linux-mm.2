Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 598FF606A33A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:03:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=dhq7JGJZ
Received: by kanga.kvack.org (Postfix)
	id 755A86B05CF; Tue, 10 Nov 2026 07:03:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6FF976B05D2; Tue, 10 Nov 2026 07:03:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5EF2E6B05DA; Tue, 10 Nov 2026 07:03:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 39E5F6B05CF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:03:54 -0500 (EST)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 9D8C5A85BB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:53 +0000 (UTC)
X-FDA: 85419075546.21.0BF1D91
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf29.hostedemail.com (Postfix) with ESMTP id BE46612000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:03:51 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhq7JGJZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312232;
	b=dPwguSJmHMWbc2IZlU8Od2VJAb7o+Jmf09C4pCiM+cQSjWndn+ycroe9Uy1aUV9eiA1iaa
	xM2MnMDyvM8YlxjNsE3EzNQd6GM96z+KnWZBxJ2KMLHgegIBT9mxO15gfV3Ddewwd+e26p
	LHhtekVYpddOTPKTrs5rbrCnKTJRXf8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312232;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=L2M4EXk08YUv56ylnMGx7FsGu77v6rwhJJTJynAxVPI=;
	b=V9JJHbbBWHbFlcYBHy5XuQ4CE9WBmSRPFsTVs4TDGFVuqAilOCk+5LYh34xgmyvo4A0abY
	es0kTPu42e9nPnQoUVwBlfpe9XG93yPlUwGZWY3wxB2zq1e/eyVYjOWAmAQYDIOmbK9/vu
	98gvcBr7VmuyhDA7dddJIiUdyKfPHHE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=dhq7JGJZ;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf29.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 13F27408C5;
	Tue, 10 Nov 2026 12:03:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9492D1F008A3;
	Tue, 10 Nov 2026 12:03:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312231;
	bh=L2M4EXk08YUv56ylnMGx7FsGu77v6rwhJJTJynAxVPI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=dhq7JGJZXHoS9o+c1poKZEOjkBCjeuLZ7zX0hWccAVH9FM/vbRYmoGxUbJc0+Ffr0
	 hmQgfHpG3UpvN/hh2P97fLWG662h+/x0JYn7dfCMMne8jz1B6S0CJe1DJm2SEtJh3A
	 0NYzpZ7h/c+8fKelWNpvFEuprtJX+udzRRnAI9c79CnbWM6SbpLrsMe1qlMK1BmqRA
	 q55c91k2o8T94srkDOFb5sWfABmWlZg+/N7zyGIianev7d+Abz2RvZlMVj0xgXwXu/
	 BE4CbgGhYb/8Y1WpdQ8rdU6TqHCNY0Iz10PTfem2DOuPVPpCgP7CxDdsyzd+XpFVqa
	 fBhcRPq7UqNXw==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 12:03:08 +0000
Subject: [PATCH 2/4] MAINTAINERS: Remove myself from MM misc, reclaim
 reviewership
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-drop-reviewerships-v1-2-07c2f06e8dfa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1099; i=ljs@kernel.org;
 h=from:subject:message-id; bh=roYoGbyVnDWW90pYgEiUQSVn7qwiybj3V0PXh4TisIM=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+c3Cri32+NDurrEV3baKCf3ejhl9bKKfnN8e+Pcp6T
 f/VDe90lLIwiHExyIopsjz/Ir4/SCRsXucFfzeYOaxMIEMYuDgFYCLbjBn+Gf7TqtqXrMz5Uu9M
 yHI7eybTlMnyX6xnhVyP6qrdt8Z4GcP/Sv/Ioknl8rPCkr/cW33YUnnRxYY5T8NyFvez1N068/c
 1OwA=
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Rspamd-Queue-Id: BE46612000F
X-Rspamd-Server: rspam12
X-Stat-Signature: tbsfhyxnsqjjfrdnqowpaexah4qj9jzm
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794312231-645262
X-HE-Meta: U2FsdGVkX1/axkxjep2MF+ZVA+pHeJblqOrYY+82tWYRkRtTjyoorXIdZX6BT5rk4ZqYiIujckvN2NWrQ1QygBacE6d3/wVRcdLkebQBn1IWUvmVzjrFbs/9/LxBcaMzxsbwV2jY+yizufBbHYV4LWHG+N3EEddB4WZP/9dgh+5aj+779VVAZSWeTZZIZCOqm1++/XD/VsJfbJPqhGcoH42WgZo41LOJeZWRzA26MmGnZpiKtUmJDZpnsq1Iz1+JFC97raZ+RMw+5jHf17cXyqym0bKfdmCCZgmMqm8khB5WV/ileB9NceVDZQcEYynoOsQBV7K9PfmZ67pws05tdEyyAL3ArhLm8nWFPfdoJrlI4CbdpzIE0w4PLFg0GeRuUKAzw5uTxNYpBXNR3FPXFiooHI4Dsjp1JgmM13RE16E//GMKbhPWCQJ9tm6Pk6VOi3CuQplSXpCicRVExtBuSWDYKSGS4aNLPBEg+8Ou7Ug5DH49bK8yamo29mEcndnmKRYf/OCgWBYYoFXtIk5nLrOidxa+A0mJ0TDcotIwg4fp7DYVK3whJVE1JQRSLVGt3Lvt3qAC0U9NtFBK1QtpjZmvC63+4sc6JasM+HssmcON5Kl/+EmN1AjyuSAX/JEhp0JRJiz3bFjOlZwbQD06aUlwe77/C65+tMGf52Qk/fJ3VyrMeZF7OJ4vumgQ4tSo+qjYUjBANUNm1tlXA3603aTX5hVFv+9rdwWxKfe5XCL2/ty5C+vg2vjmr7zc0hG69f7TLVSzELfl37/3DSiI0mfcPSWRsPnpJygEjt3Ddvu6vPBW/0sNQTyOL2rCd3ikz7DGFA568zASiflgeJ0c4sO1KF6rRphk4UqdWCCcn8GRj3+qAcH9AJmfuEKAkdpmJ/CawQB/fMfjiRUwCDzHfuMrHGeKFHHBkZMDjMKjLx/eD02nmVqhubkueD6dH9csfCY16xFWuNdojaer7vA
 0Ae+aOyt
 Z6kF611/n+/0m7skV7zHS7CshsQVawkbYJnt7xQjeNJLsRgNLUnYia1grfKjjke1RUbghWLS5L/0D221SiNnSOGl4tzbN2E7lGF6lrhnDmgk88BuYLd9BK8pd4gpUMC2WizkXB1s/Xo0FmcSTHeeQdNPPBZdaf4UdFsbSnW+cAIx8t4shyIc0t0r3ti+Lm87D/Jzy0vPuvmVCv0dqsrcdrY5rzRvVc/k4zrvL+QRWrD3KgQ8VvAlV+0/0VZIgAHykmKpatAGynBtC4LM/A+28j506qGz6LtdwsUy6mM0Tu291TqMhT2AnTzDkSz7rZqMvaI3CumhM2kd+pdJaNhW36/ivaWYMgUjvmuV0NSeXWYQSpd8KW/JHcVyP+XDeAK5CaKmXEX/PVGBWwfkHjut3QDYp/bbCwTk5GxhBg3xI+TmV1IPcMAK2aNFptHm9n/BIvmcL4eeNBCvqYz7XiGZVfP9Hy3mjDFpSLrkoWAFYh2DFEDx4+hpycTrx3UBo1600aBFtTZsj/2GGNeuEK3yRKlMZh9HptxvalWDsMMh8jkeLFJL47aqKlN30xw1P9bHRdJ6p
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
 MAINTAINERS | 2 --
 1 file changed, 2 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index c2f7fed0d850..bb4f973b195f 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17675,7 +17675,6 @@ F:	mm/migrate_device.c
 MEMORY MANAGEMENT - MISC
 M:	Andrew Morton <akpm@linux-foundation.org>
 M:	David Hildenbrand <david@kernel.org>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Mike Rapoport <rppt@kernel.org>
@@ -17811,7 +17810,6 @@ R:	David Hildenbrand <david@kernel.org>
 R:	Michal Hocko <mhocko@kernel.org>
 R:	Qi Zheng <qi.zheng@linux.dev>
 R:	Shakeel Butt <shakeel.butt@linux.dev>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
 F:	include/trace/events/vmscan.h

-- 
2.56.0


