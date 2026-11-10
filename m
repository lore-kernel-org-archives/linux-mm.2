Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6E7C4606A32E
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:04:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Boff+uIt
Received: by kanga.kvack.org (Postfix)
	id 9C7386B05DF; Tue, 10 Nov 2026 07:04:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94A7B6B05E2; Tue, 10 Nov 2026 07:04:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7EBE66B05E1; Tue, 10 Nov 2026 07:04:13 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 5D78C6B05DF
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:13 -0500 (EST)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 7E6071A0715
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:11 +0000 (UTC)
X-FDA: 85419076302.19.F9A82BF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf09.hostedemail.com (Postfix) with ESMTP id B52C514000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:09 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Boff+uIt;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312249;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JzZk1RLuM8spDo9JKHdWOYveSLRK6lJWUSM1rGChjXw=;
	b=sRH65yIaU/37O9G8CImV1zVPI2q+Y37Msb90S6X+u8glhJNBrkSLFoEGjbyX2AkiC1LKyF
	Y0eTmgnvC74DlGqIiht46ronOd81CxMUIxvlWdZ48XO0HwoWwuBsMg9pA34DB/YMqx3VB5
	uNdBYzChMA8yiKDIXjOm+iugd5gJdPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312249;
	b=Mz0bWsir3TLAytuuKV3VddZoEq4WxwtTWCfA22e9LD4uQ8SfSzGxsv0dp4qkwjvQVeVWj6
	6YYp2EZeotxJi+Mn/e2UuGbp0bbsVQjNdO1sCq3Cvs36lZ65Cce8e+vRYcZI8bVU3dcH4c
	SaLrqzU7hiJ1f6MXqHsn/fctKNjRFEU=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Boff+uIt;
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id F3CD040620;
	Tue, 10 Nov 2026 12:04:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674FB1F0089F;
	Tue, 10 Nov 2026 12:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312248;
	bh=JzZk1RLuM8spDo9JKHdWOYveSLRK6lJWUSM1rGChjXw=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=Boff+uIt4fpQBBVexb0HKl7uHzWduiQHV5j/QhpigCwkTTzCn8CHJUM8gE5r67mxm
	 0yDoKKLtbzCXTUsNCKEW1YHWAt7GZsJkzXi98WX8NKCXNeS52hE4R4ddyCmYCMNkb1
	 lv+kSHWYcDoS81Fqya38IMEoVZRHbn2wkLe0sk+FArsO1oofAc1b3IC2yK5sFiQWhh
	 JQBUfcmJtpbwIDLQdrruaKNscGQHe3mN2dIIff16DvI1luvrK7F98qdeAK1Bk1Okom
	 TGk9MetqRdIVkj/UkUUdgb0ZRtFTrAUjNHS+SAsngeJi8m+LQ8iNWh6UTkE6WMCfbY
	 N0mn9TUVVGfLg==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 12:03:10 +0000
Subject: [PATCH 4/4] CREDITS: add entry for THP maintenance
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-drop-reviewerships-v1-4-07c2f06e8dfa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=904; i=ljs@kernel.org;
 h=from:subject:message-id; bh=takUyaLXbztd4jtf7ScJW0qPqBvaRlKq7K6u3UStV5g=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+c/C82LFW1a0juPf/vOPpOd4/Pefz3888sXjy6VMFc
 UbbsgNyOkpZGMS4GGTFFFmefxHfHyQSNq/zgr8bzBxWJpAhDFycAjCRvHJGhjMKf93myt9s0aiS
 mHONizlf85P4tf1RTlYzV7qv62C8v4+R4Wrerhx19xVrmie7N5xZseudVifb4o3b/XZx3F6QdXR
 2CScA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: 716ou3wakxsgepe4tdei1ze9infkw14x
X-Rspamd-Queue-Id: B52C514000F
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794312249-450361
X-HE-Meta: U2FsdGVkX19wt3q2J962Cr8pMBjGknj/fU3p6v1U9GxdORssQysjN6a6FxTlNrkAp0vZw2RZqmkgimqqAJzOmIppDBJd/0YRobnu5qW5Jt0nPwb6nZ0fikqWVov2ta2x0TIg40XACiD7kkkskhFtHHg8nJY/F0S9fKdYdOUtLpgGRFBJtw5Q8aK1jOI2+AXNXhMcI5RL7UCubqRYZXCvcNsGUxsq7F2aGXaeis5Novv2zTENnGqK94i0aQ95ggnkjdZ9fLvyXKUfDncQwYwwzm7Mu1aBIhfh9pFLvhxgoo3jtjZxBlorGSj5fwe2udE6OFjV/k5+ZPw3RPhraeOARmnQUv5QVZITHu0Ln16mwlY1PIV1GHy0MN25yZLcpLEY4v+zUpWXOmiuPsLI/NsMcju/d6ERhkYZtmNws8DyAbbserKuQqBnOSt24SgvzCW9dJGhTpDXGVPwlrQrWt3RO6GgYIL0+Lc+bEdprGCj/Y2Xi37Aie/USHVbltZaEvp16tU0kqLpLz7dptUh8q8wWV7YL3X8bC3AL/l8sh/7/YQyyZfc1d8QgHknEI2LZKw/y6Qw6wMSoarx0hNK33VZqgMDNS/J/xJJvGbs9knTXk+HZAvjuhHDeXlT9gf1w67lcnzbKL/bSFRvKzSp67cnfsQ4oCknNpGxS1BEW+5AEHfJraKP0KBpXF7HYyS4C9Jt6jyGBby9N4gn4I12nrPswSnjmnFLCj2WjvfmxYiAM9OLytLsHuMNW1LW4a13ZO5ZYfLEcXQ6Xz63CsKAiJBqwRmxF4QY2GyS+GYOlQHaGkKPQCyqYad/znG9II4K1rvp94N94HCkXCNwDFCQrSuWVcca8KUNi9o70il4nL/HvKB7dy6T9wXIvCmQkeR0XrX1rndYjoD6qTIzD8622rnnJ5FYo+h5ic/zJFiJmWgtrPjDAxzF9zhjYCuyrdbzUNP61FOLCvOzXRzf1IwfGlN
 HKZifpmI
 sdB1bQi2g5WHNOqCCpHaxgUFOnyhLpJ5i7BbzV63tAZne05+zWjGAgDVV2Yk0vHurVSCSEvuNyAaPZPybRIQywD7ezZ4f1t6o1sqq5/5xcN7Ay5yO6FertQx6clDGy4hkx+v5E8PP6od51RI9v4HKRZNO+Ed2etc9cLXk6AyGmS+mkAwu9WQnHajA1TE3ahkm+TU1C+k4AC599gxYAEYh3lubefdzgQBotymB8RacQMbFnFjG94AoqffONhP2DinNNfbZWBR+6NCJfsbbjFoSXIj+sMHmb3aitbw36W9mNHEWscixTFLiXggWLt8oZau7J8SGLVNyGpHd5WbVQCnaSqcIsqYPM+aX0X/5iP5m2mLz690=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Given my workload and current areas of focus, I think it's unlikely I will
return to THP, so add a CREDITS entry to reflect my time as co-maintainer
there.

With Zi being appointed as an absolutely worthy successor as THP
co-maintainer I am confident in its success, and this additionally makes me
feel that it is unnecessary for me to return (for the best possible
reasons!)

Signed-off-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
---
 CREDITS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/CREDITS b/CREDITS
index c6c7b173b064..226a71e45edc 100644
--- a/CREDITS
+++ b/CREDITS
@@ -3939,6 +3939,12 @@ D: mandocs and mandocs_install build targets
 S: (Email me and ask)
 S: Australia
 
+N: Lorenzo Stoakes
+E: ljs@kernel.org
+W: https://ljs.io
+D: THP co-maintainer
+S: UK
+
 N: Henrik Storner
 E: storner@image.dk
 W: http://www.image.dk/~storner/

-- 
2.56.0


