Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6CE5C606AFDD
	for <linux-mm@archiver.kernel.org>; Mon,  9 Nov 2026 18:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=m+iQ6baS
Received: by kanga.kvack.org (Postfix)
	id 8E46D6B05E5; Mon,  9 Nov 2026 13:32:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 895716B05E6; Mon,  9 Nov 2026 13:32:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AABF6B05E7; Mon,  9 Nov 2026 13:32:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5396E6B05E5
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 13:32:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id E3EB9807BE
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:32:02 +0000 (UTC)
X-FDA: 85416424884.17.9182978
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf05.hostedemail.com (Postfix) with ESMTP id 386CB100008
	for <linux-mm@kvack.org>; Mon,  9 Nov 2026 18:32:01 +0000 (UTC)
Authentication-Results: imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+iQ6baS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794249121;
	b=NqPpN83YxqIZPnSlVDEMmlBNXE2OePICnADiePzAvqTBWr27+tpkuDzqSQim2byXP2jo4k
	Ql81v7Qz8V7IIgsk2w035oTZ6Evhir/Ntj+KqJt6PWXzXVeJp+FUuTWqCNr3IUBq2kRo/9
	5lc/Sco8rbz5pIuuSBeCImoc2OaxqBQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794249121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=NKgS5iWK781d2x9G+ZsCNT2Jy4yL/3koV2y9hvD9NWg=;
	b=ap0ZlHyvDDgJU6ERybnHKYUqAbTcrj6qdT7vDY9Aznepsa2+K1QXYPt98jf80SWFkD+mte
	ktqdCXB2O/bSlaAIERfTooF8Tcd638l+gjr5bx4EJUx60EQS0RthkKQXoXnZHHOp/sqJ0m
	Lo0kTVZM3dmNZNw4zSoAMf89ThOu6m8=
ARC-Authentication-Results: i=1;
	imf05.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=m+iQ6baS;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf05.hostedemail.com: domain of david@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=david@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 87EB6634C5;
	Mon,  9 Nov 2026 18:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89E3E1F00AD6;
	Mon,  9 Nov 2026 18:31:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794249120;
	bh=NKgS5iWK781d2x9G+ZsCNT2Jy4yL/3koV2y9hvD9NWg=;
	h=From:Subject:Date:To:Cc;
	b=m+iQ6baS4CBAxViP/BrHNtR2dFhzNE0HIbhvI7/gSUly9zOHwt9iVwEJs6O4h7nvx
	 C2GerR6x//d30wyd648/gYw9HP/TPpYoCmB/T2GOsiwffGHlqft7Yx4BL5znBokLA5
	 ntyYnKbeR+8lOqgGc2IBBCRzdioQyNRybSfZuJjgyleQajFc7P39sir5v77GQB4SrY
	 lkWtlj6KkfsSCSrO0dN6ThSx4Dff4QiHI0wPiRtySlzKyFLIqyLOhBPM0ewQlORKd3
	 oa8hTWbAEY1uPxmNBBk/19G9lY6DFclaLMJWAFaCHsu7Bh75DGmz6+qqgIO3TlwH77
	 mDbhmmy8/j+MA==
From: "David Hildenbrand (Arm)" <david@kernel.org>
Subject: [PATCH 0/2] MAINTAINERS: MM updates (2)
Date: Mon, 09 Nov 2026 19:31:52 +0100
Message-Id: <20261109-maintainers_mglru-v1-0-c25e6de60bcc@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAJgR8moC/yXMQQqDMBCF4avIrA1MsojiVUQk6lRHNC0zKoJ4d
 9N28Rbf4v0XKAmTQpVdIHSw8jsm2DyDfgpxJMNDMjh03loszBo4bmkk2q7jIruxhMGVgy/RI6T
 fR+jF569ZN3/r3s3Ub98Q3PcDQD7LHXUAAAA=
X-Change-ID: 20261107-maintainers_mglru-1e0a28d68060
To: Andrew Morton <akpm@linux-foundation.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Muchun Song <muchun.song@linux.dev>, 
 Lance Yang <lance.yang@linux.dev>, Ridong Chen <ridong.chen@linux.dev>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org, 
 "David Hildenbrand (Arm)" <david@kernel.org>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=536; i=david@kernel.org;
 h=from:subject:message-id; bh=TA1+wI8uMEcNe/abtsKifPKm/0Cjd9+34i3ZWYsn7tY=;
 b=owGbwMvMwCF2/OVpCdfQ3ZWMp9WSGLI+Cc7aLHf4btC1Gxe3PXYISWMvaJ7D0dJe3OYhqHbix
 J8lmrusOkpZGMQ4GGTFFFmCgu8bvHy5rrbajY8ZZg4rE8gQBi5OAZiI0ANGhmePc5cLfrr9QCre
 d4G1Q5aDVmaOS0/PtJoyjXJ18ZzpVQw/Gef2FRRO2+tpU7Vo9bTbj+0177CxSXnrPhE+YnVa7Ck
 fHwA=
X-Developer-Key: i=david@kernel.org; a=openpgp;
 fpr=1BD9CAAD735C4C3A460DFCCA4DDE10F700FF835A
X-Rspamd-Queue-Id: 386CB100008
X-Rspamd-Server: rspam12
X-Stat-Signature: cb1ngi3a3oakypgfs1rru96kxw53uths
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794249121-775252
X-HE-Meta: U2FsdGVkX19cPVG4tVtEGRLNyZ7Jgrg2DHhZ04HTzE2vyaVS8/xbnoOouIbCIJn60KKetaenuxq/ltS65vfF0xnmZj7lY/RrXETP9WOhvOeESivY5M2NP9aguCSK0Vr8t1k5BU3YbF4ChaxS/YEXJXaIRwbuCxnQK4r8r4qvxv8WDNqh008GXczVZzzqDtXLxGUuXbI4W+UJIy/MPmienuL9WQzFieu2igeUFdYGycIOTu7fcWXqhiY0qzi4crGm5PP2gJlt3VKZJ7pv+7tm+Ef24aIrI4vuX/3nmahEhbKsnU0y201eurcfBhG/9v8gFiUV7aIeNUzog4g1ws68vs7GT1Zd/nfWTtNmM+bL6fS/5A3e2LSwshVeJbbDioKTYtUKHQ1A8c08fhLFcAywExbrqb1qPf1dKbFE+WKhfVxZaWKfaTqLKpvcFSQPEXAI5meFFhLVAZDIQABD0qLdNILWVOMs3c8qoaofRt4WuP43ErZhJ2tvY+XIyK+pD1/yM2hENITJTRmDQqGenzOhsEKeWNSP+mwFjHgQMHY/Gll7qBIcS4uykyXkg69t9Mzyb4H2oS544aSpPObj1z7ce+XaK384q995V093PN2XrRnxOmU4c+kf4/a0PVYlcap5iSmq3hqjC0feAB3DSJOdcfHlEewWRIt4zYEhEdlEaktr7wCseP8pEjtQD+rE53FZqtdT7mmi+ZFdhCUUDZeOvKgvPZpOTJ0p6okUfFN58amTsK2OuCERmK9sPtXOg3ZJVYPNLyS7IBUeLPmjDMhDWVpVVFf05s7QM6vTz0cXIrWrKAWYPBibTwRGVqvpz9E4zqiGgsHJaEuveaTf7XNHOAEyC0wU1PpLrzb3z33vbX/JurHa8E5xprsvALYeTgUIolZc2s+1pRyaGMrs5dJI6AhheFfFXlKxF2AAUePAJhOTy8s0JwStP1OaPxlD7EgrzpfCFjZNuf34kpSdGF9
 N16LDaHp
 l5Zxfm485oGMmUZprN5dvlyrmCVxLcEDtuqdlCTzhdRXLJ0slWgyzCLZ0KEDnATwPWYzxYaNEeaSNyejrVI/cYYD0sng7TT29ClBe99xQFW+Jl1buMtRYkcw2qLEJfQJeVhUCaihpCPTgWzUmgHSxcgwDjL4WzOmU/5jtiGxB4axl/RtXjhMcK6czzY8cpPBy0kvdZX4P76zEuVbvjg+UnUkKvfNBTrfSnYQinYmoJ8qPO1txIJXmvfeKzMJ4ratxzJmnPSkFBNCZkEUywcwWy+pNmt1Bc04cpevDi4dp4zciMKwJnuIIBHBCJQx6GYmW2UU9Xp3RcGj77V2NOVbl00m/xtkBuP05HX/HRJxj3JEHmqg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Hi,

some more MAINTAINERS updates with a focus on MGLRU and reclaim this
time.

Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
---
David Hildenbrand (Arm) (2):
      MAINTAINERS: MEMORY MANAGEMENT - MGLRU (MULTI-GEN LRU) update
      MAINTAINERS: remove myself from MEMORY MANAGEMENT - RECLAIM

 MAINTAINERS | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

---

base-commit: 7475ea8b58616b33c04afb976cf0fbaad9dd63fb

change-id: 20261107-maintainers_mglru-1e0a28d68060

--

Cheers,

David


