Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C1D4160A3829
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 12:04:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=UazZJbNr
Received: by kanga.kvack.org (Postfix)
	id EAA306B05DB; Tue, 10 Nov 2026 07:04:02 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E53416B05DE; Tue, 10 Nov 2026 07:04:02 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D42DC6B05DF; Tue, 10 Nov 2026 07:04:02 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id A80C26B05DB
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 07:04:02 -0500 (EST)
Received: from smtpin28.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 40B241406B2
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:02 +0000 (UTC)
X-FDA: 85419075924.28.5E2B96B
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf01.hostedemail.com (Postfix) with ESMTP id 6F57B4000F
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 12:04:00 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UazZJbNr;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794312240;
	b=BEqBwqHWdLTi+amdPiNpjc37rAUC44tvWKW66TZuI/26YNvFdQ5/dTAp3TIZIm0rB2mWWE
	o4ApndWvJGUgdNdxU/xN2fyRf15zC6Mg5sVPdfSrFH4OgAce917tE1CKwNS5lvrlUVJp1c
	K/xx0yYBQ1b0bjBO3hwxety35lX2OZM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=UazZJbNr;
	spf=pass (imf01.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794312240;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zsf6gGfdxiLjXd17MrZhzZWiPYtcEveS8tZd3C8SJcA=;
	b=2p9tjfZqqGORPLs5gkfvAjvhOeC3CX/iC7Z+pA9LKQwXSWVX6qvNZnb3aDii/KpqxjfpRG
	cRDNONmcImySyLMRhY2gSldbgLYD/8qLrGCuTu/QmVS2BV0NBrkINewPvqftZqeknisU0g
	0mKLEpjZyYYmm7XqXJnwgjcrU8hi8i0=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 1367B638CF;
	Tue, 10 Nov 2026 12:04:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797F51F0089F;
	Tue, 10 Nov 2026 12:03:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794312239;
	bh=zsf6gGfdxiLjXd17MrZhzZWiPYtcEveS8tZd3C8SJcA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc;
	b=UazZJbNrY1JnrRiMYG+J0CIP3aLqOo+qTwuIM/q4+cinWIPihQs0HVHhnZppz+9Zq
	 2HmOkA2WZ8/4p1a0izUyBmorR0W3FdKa9tcCYEy21LSjDnI9aC4z+ZP6pTkqaX0DZP
	 O76bOwgjQQUPXQFqr9yFdcCcM3//NNJRR5+zL0GTxfwreoJyLdgaYirFCtfmU6BcfG
	 o3BwtOCHGh1Lw9FiGx+6l8NsAi1UzbnjMaHJSfepOnR1TgGwzWuKe7PnILEVVU+luz
	 WYbqNPN8joKKJiK8chAgQIrqHpcpXextzsf1hsNDrX5z77U3+TSrzImPIX6pyx3sMe
	 AayZgScOpn3jQ==
From: "Lorenzo Stoakes (ARM)" <ljs@kernel.org>
Date: Tue, 10 Nov 2026 12:03:09 +0000
Subject: [PATCH 3/4] MAINTAINERS: Remove myself from MM rust reviewerships
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261110-drop-reviewerships-v1-3-07c2f06e8dfa@kernel.org>
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
X-Developer-Signature: v=1; a=openpgp-sha256; l=1057; i=ljs@kernel.org;
 h=from:subject:message-id; bh=F5gq5QS7pGTPR4Dfl1UG5qSMcHZqfSOEnv60atDlEJI=;
 b=owGbwMvMwCV2fu7ZrsZH9SKMp9WSGLI+c/A0VdyY/TdQNrjigvJsTm3f7F/fSwLXPSxs3rpeo
 tVtw7ULHaUsDGJcDLJiiizPv4jvDxIJm9d5wd8NZg4rE8gQBi5OAZiIQzDDX/EtxwqlzXXjErXM
 b7/oNhQqEBRffP500OMWr5B5x6Ysj2RkmLgwXlD5tNPZ1TtrbaoffH59fEmA5yOX2e7LtvkIPXM
 0ZQQA
X-Developer-Key: i=ljs@kernel.org; a=openpgp;
 fpr=E7F417BF5214569E89D04F46CF9DCD8A81E27F14
X-Stat-Signature: iyirwaogf1qcfdpw9ihdoqdwazo4y4y4
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 6F57B4000F
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794312240-231108
X-HE-Meta: U2FsdGVkX1+dX0QvqtnIrpuoWgLZa4zwYtgF+CwRXKHnzsjB1jG0p5hFlU7149BDP7u8Pjy9xsm5E55X4/rGgbgv6fRe2xeJJKKLL1mkcO4Dk5KDugaki2tvVzgQ4pqZZi3HkvgYv2q8u1iu506+xugRMGqlchk0i0aT5zH8SwCG+Hk+7cnNfqaJI+cDRVztMB4KGsAM2tWjorvKXAD9+Vnd12UXM0+oi6PJtLZDJSmkiiuZnPdY4B+4zilHQprapaGKyYg8E3e8kcxRWDqPgydCGawsVuL5kBwkuPtFiQC5vFRTRJ0DmqpQfPlQrQ9s+SfC3M6nN5Z4Gz7pSarFb4i77pXwG3K646Ge5M/gG41cby69edsBvb37H9q8Z5WdRHgCYgbRnNz4ofENEMlfIpIsZpqSkhSPB8FaMU7fFeAoITUyX81bAsx/+ZKTFooRBkezQbDuAu/Y7XB8/+/hw0FqKGHQTv9SBk1/71hcq1DIhBflB2UR8L8g4ke770eTt4e0y8ac+yoc/skE38dtULgAVPu+/oxw3CmFcFGSezF6KUQ2hMmPE3CIguJD0NpU/Qm3kos6Ul5OD2IyQjfalTf2BOMZAYZlKRRzZ2+reYslRVftGx0yE/gohqGuwJtFo7+5zzBL+oCseTetA143WlOPFy9C1bnoe0j0m1+Fox9LADzzp1bPfA9KDpOp+ERKg2fRUNw/OZ+8zdA2zTeZXcKZJnRCl8W5bQdDBMNbrflK7TBpuDq6qFEita8ONFJX/axKpl6NpKihSffzx+vfjh5ZESLTd1lpl7eWd0nqBeUL833gqJ6xmSykQSxZoef+BhsYtJOgkf29v6YNq6jBn+/Oms2Uk4kusKtACgP9mJWJ15srYKe5aa8knjtzI+Fqb3ZvkWqUyigJy3kEXe4oKW0PI2DXjwqqqGd33k0Rbyp5js7nDk5DABJ127qaLsvhSKl9DUdYK4D5oU/nUXf
 XQFv5MgB
 WMLKRLDr0WxwJ9/OjPTtOhH7GvY92xQvA4ygHS85f39lBi8+ih6JexgIZSKXBac8boqKIjz6Y//MJpgmQOFchsz0hMFoBqW7OrxCALvqRfIVLFlAykZszvT/OR5BG6ZUyXVEaG3EtLiOwffr//VAXRJazVEbcoFm97g8Ed5hDvicyEce75DNcsGJJKJRmlEGe2jkN9zQ6wv3c604bsgR379J4L8fbhal5HP/3tvKmkhHNvXNmVLQ874InM9qrs7/PpYeGBNPiT6A+P38lNHXfqK9s49qAHLC9bH6ZAU3+E/DPF0GqiW4NhrgToTduPM1XpbtkE4EID+hftPPFy939pYO2qpiiOufCRcMGZrNzFSDnVnWvoNGwX4+tUUNyKmCq/rxU/dghkn4nymj22x4W9mH1iCqPh8UFdSJX
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
index bb4f973b195f..83fc5cee8680 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -17958,7 +17958,6 @@ F:	tools/testing/selftests/mm/uffd-*.[ch]
 
 MEMORY MANAGEMENT - RUST
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 L:	linux-mm@kvack.org
 L:	rust-for-linux@vger.kernel.org
@@ -24655,7 +24654,6 @@ K:	\b(?i:rust)\b
 RUST [ALLOC]
 M:	Danilo Krummrich <dakr@kernel.org>
 M:	Alice Ryhl <aliceryhl@google.com>
-R:	Lorenzo Stoakes <ljs@kernel.org>
 R:	Vlastimil Babka <vbabka@kernel.org>
 R:	Liam R. Howlett <liam@infradead.org>
 R:	Uladzislau Rezki <urezki@gmail.com>

-- 
2.56.0


