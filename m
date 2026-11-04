Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E7605606A332
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 09:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ftxirbjq
Received: by kanga.kvack.org (Postfix)
	id 0ED786B05BB; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A0A56B05BC; Wed,  4 Nov 2026 04:59:13 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ECECF6B05BD; Wed,  4 Nov 2026 04:59:12 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C6C1B6B05BA
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 04:59:12 -0500 (EST)
Received: from smtpin06.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 3BEF31C3F27
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:12 +0000 (UTC)
X-FDA: 85396988544.06.7CB27C6
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf07.hostedemail.com (Postfix) with ESMTP id 3060340003
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 09:59:10 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftxirbjq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793786350;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=3Sob1uMONq6SSsdxxC9IdsMSiFRpVas+YBu0+aDW3Z4=;
	b=NOORchYLXtOh4yUNon7PQFy+Vg56TMWgzNacvAH7r4rygaWk5cezaMr7G2JYHYwRyOKtPk
	l37qsjOo1mm0ECAXPO8wFQVIBhqlqCrhLQSRNGIeS6cOjeq+sz9fTAQ9jfd7TgiZ4gZyBG
	16iUlfkGYla1mIkQmG7viHyzyjF36xA=
ARC-Authentication-Results: i=2;
	imf07.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ftxirbjq;
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	spf=pass (imf07.hostedemail.com: domain of devnull+daejun7.park.samsung.com@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+daejun7.park.samsung.com@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1793786350;
	b=ye51sDcwfe6kWkGsPkrHhDSImnwlzlUvOE82EzHubwk6qofJwVMCd3WU/u/ItqN+eSoFxV
	RpnlXiUoyDbJzEnYGtz+MhQjn21JT/yBVww40wVUKOlgDURmjouvfvaA0fIoGd5XlV1qH/
	Jpf+vTJDDZ7+CcbWcANrmEdAmAunntI=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5861F417A4;
	Wed,  4 Nov 2026 09:59:09 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1793786349;
	b=QbvIEBrRsN2y0APf8IQnv5jkZBZP8uHgUdqlrHmum5L9irwFiEv+s0iqvuKusyJTFFgb
	 /0kKG59Tkdz3ezE7HK4hXSzGz+7DDc7+GEQ9o26VBSBOLvRn8TWjxroaETBj6T7wT7Wtv
	 emHN5QjcA4R5ck3hdwc8mfQ3GAnFoPBLa/AER2s9oT2/TL0t8GpXxIz2mT0A9ljDtE+E5
	 Uf2EbQ7kKFpJmVyRhwyt3yuV0bVAUScBlgEDZ8vTGKdu5YuQRdHlimQwbQ6OmG4avVQT3
	 IfINuh9pC/2g3hjnv+kldo+NB35b60FwUmZLv1q1wSRR0f8iaR7j2GEzY/D8EHzYYfA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1793786349;
	h=DKIM-Signature:Received:From:Subject:Date:Message-Id:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:X-B4-Tracking:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To;
	bh=3Sob1uMONq6SSsdxxC9IdsMSiFRpVas+YBu0+aDW3Z4=;
	b=KG/NPaTXs19rpk4K+h7lxcqsAmDliyrcrBc13fH2um1wFzVLYL6yB1YiKxJ4HczTAYpZ
	 Zx6RGqA+gg9L9DPRzEtH8K4WSvLCnQlL/qQ/j80kpmJ3c1rqxenRBYYGq24eH6VsULSbY
	 RjlcFT1d7v0LiRazsB1K7B/Cpimad9oH3gnFbwiMd3pQfN0MjrNY1EX+eVg5FMr+4p5us
	 fdXLIoiwcKqOnym64vNuPza3pq2sWNCDxZivanqI0QLZTgqw/239SvNwLuirRh0uvWFF7
	 JoxdFHkAJHZBoucVeXVTlxlUPHGxPn0Lx08+THJr6vkXTIoFpSHE2JA3zyipgm+oO6g==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id B6CE31F00919;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793786349;
	bh=3Sob1uMONq6SSsdxxC9IdsMSiFRpVas+YBu0+aDW3Z4=;
	h=From:Subject:Date:To:Cc:Reply-To;
	b=ftxirbjqa58cGKoYms+B2+AEZvxmfkOYxeogVZSSXcP0RYRHRPMUxesvr7n4wybyh
	 4QnHr/4yTVZH4n3qvXvkRsIPCyvGjkBqFGNZuRFbqhidPF/Vv5GuKe7bISZorErXiq
	 OYJyYQ8MnOeh3LEbJM65/j5kCqLYHq8+w/Rm9C1utUJbnDbD56DYbPLUILs7n5jLn8
	 Sh0P23rRZr+Riol4iQNJUEDLvNgWIxv+zBFZAHQuDwdiiyoFvfnUS0pvFBWAQOUu+N
	 aDPudopCw0QujRlcT7khXfCAZLawyvCWOzxp2yOCletO8c0CRmhPHIHqM0sak503my
	 JY/2exbYfF9QA==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 134E746D91;
	Wed,  4 Nov 2026 09:59:08 +0000 (UTC)
From: Daejun Park via B4 Relay <devnull+daejun7.park.samsung.com@kernel.org>
Subject: [PATCH 0/2] mm: fix memcg_data reads during a THP split
Date: Wed, 04 Nov 2026 18:59:07 +0900
Message-Id: <20261104-kpagecgroup-split-v1-0-f70e947fec85@samsung.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-B4-Tracking: v=1; b=H4sIAOsB62oC/x3MQQqAIBRF0a3EHyeYRFlbiQZiL/sUJVoRSHtPG
 p7BvYkiAiNSXyQKuDnysWdUZUF2MbuD4CmblFRNJZUWqzcO1oXj8iL6jU+hTVt3tgFUC8qdD5j
 5+Z/D+L4feHUaV2MAAAA=
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Tao Yi <escape@deepseek.com>, Johannes Weiner <hannes@cmpxchg.org>, 
 Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, 
 Shakeel Butt <shakeel.butt@linux.dev>, Muchun Song <muchun.song@linux.dev>, 
 David Hildenbrand <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Matthew Wilcox <willy@infradead.org>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Vlastimil Babka <vbabka@kernel.org>, Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, linux-mm@kvack.org, 
 cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, 
 stable@vger.kernel.org, Daejun Park <daejun7.park@samsung.com>
X-Mailer: b4 0.13.0
X-Developer-Signature: v=1; a=ed25519-sha256; t=1793786347; l=1142;
 i=daejun7.park@samsung.com; s=20261006; h=from:subject:message-id;
 bh=y+BIdTbHzrH+8Uu1YnmKDz/Hk8zUyXmI5VDnrLuv9PY=;
 b=0+otGc3rNezYaJu/zwXPPYuiIecNe6HZUqy7esh0CFuBqce5P1RDP0GxbRJvib69MJuiM1e+o
 VoK4dvibbOeC6yGIvA864Y0zKn7FrlYCtd9M/sFikqiNwtBE7itbRNL
X-Developer-Key: i=daejun7.park@samsung.com; a=ed25519;
 pk=4yUfDqGRZTIj0Ik43z1GoMZRWCNm/rgX6uJuM9dtNIg=
X-Endpoint-Received: by B4 Relay for daejun7.park@samsung.com/20261006 with
 auth_id=1122
X-Original-From: Daejun Park <daejun7.park@samsung.com>
Reply-To: daejun7.park@samsung.com
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 3060340003
X-Stat-Signature: f17gipr5atj9arm7wa6f487m87pkch8r
X-Rspam-User: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793786350-32118
X-HE-Meta: U2FsdGVkX1/49DyD+9wrGyh0us6VB0t/yuaPMCgskP9ALbf2VxgvLTub/fQd7fqJ7T1BbwVvqEusP6KkhO3VWhlRqqOWASG8/1U0dxkZwHkSVgFEXCEI9dfRMSCQahgiiD1KsM3v4XQXjQTz39ACoFYA20Jyh8mrDH/UTl1VXxT8uGOYem8M6TjIyEjKXcB791dZ1ZQDKXvrCh1cFSAVCrweT3mNnEOJoh8lnHfzDmMW2ZlmdUh/B0i6Gul/tw86zPYDQ8wbs+8SfKSEDfZIOHJjiUVJWziSsQLhkE1XMQTpg1hE44IV75MRB7W8WEicd6lOuHR+gm3YgC9dajF952J37LhehqJAYZ4rKudAhj5hGXtRLgrHIgbnbdQtaeFeNgK1ZFZWrgbMS88LLEFxuM6aHcu0uUXcxM8DMmrI8/v98emWgYkYjOI4Ymd1VKzRjITJL1Yh2bz5iWCdS+BH/gfkZaY19kNVk8ss1mW5CGyNiKcnZdgzDFX0nngbRPl8IlS9vusBGuHv+B+qklNP9R5+l+Ln3ffY/u18uNcdddb/f4nx5FjHwsgJ95Qq/4OjJQlGJN3jQkHdf7a1TgzxBTiuMsSPD9Q85eh924vt5WDOIdrPWHTGGypkXRBbiyCQEpPaA+NPITqRix/8DoqkpIHyGCs3iu1ovT+GxIJtl9munIP1YG0Ve/vtsMDIuiZb/clFrQ3Io12yd/+YvJzZTGrBFvI1uFacLcoAnUULWCeDqsYm09j7TCUFr4hdk0ul6TOnO5kEReuxntrW23/VeSx2rB7TDmYNKQcdt02JkPHsUVBLG2tQguKWtoHKgZ1X6YetS5rpdai9CMTjD2WCkdp8No3f2zN/APASJVKkpC6KB5hGc4CHK1aewhT52Jzy0RHHgYLljKSsJbq8HnIi7zl+U0hy8W4mwBOVIa1uujoVMBiaHgwCNMfxcdXexMkp1C2pFnpdJMHaN9viav/
 gY98Gosq
 VOjY1pO0dS+oZcFVsnBZpkugUIF9cPHb3tKynvjH2nCX/hrd/uRE7fD5bXB/mlO6+O4iwZCeAh48xSvEhUbHEP0P/WZg0tTtSExzntjReDYXc9zz7rb1rHv2X28OjezpnesPfYWTiCGl95qE46wIV9Z+wxsvJlMDvczPUyAwI1tQsYFvDotUj1Z22YoSrXq8XUI3gNKmZqWdWSRkWNtgkrCOJ0hS9ZMTlMnefVPGqrJJy0SSifQrQkohiBZzqKmVLSpEQy4WnPu0MGBHSiVGOr2NH9Dfuqlez9e2P6zR/9YThT38wLXjIU3zUBCok42WU4ZrX0fojV/yEy4NB35qQ5ull44sqaBFGbZiB4tmIANiDZtLgSkA4mjPycmxR1mDG08zGAkLe/EpijC2u3NT9cuCfz/nrnEG0esBn0chnx1hhCN0ggYmxYEaECQAs2Qvpb32lBK74L2vRqBo5VvRDtMmrp+TpdskuItuqhQrOduU2T4w26KWnXWHYyPaPcgDzGrn5ySGLt/3S9IWI3uRYpWWdYF4gO9/cYzLEJDTMSZCb3EOwcFkv8KMlg4ReXCQgUUWDQEIE1V+kLOdqXf2Cyan8W3rF79jmENktr4T5c1Mry7I=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Tao Yi reported an oops in page_cgroup_ino() while reading
/proc/kpagecgroup and traced it to the THP split in an RFC [1]. The
RFC skips frozen folios in the reader. Patch 1 moves the memcg_data
copy in the split instead. Patch 2 orders the same loads in
page_owner and needs patch 1.

Charged large kmalloc pages are frozen, so the RFC would report them
as uncharged. My review of the RFC [2] got no reply. Tested on x86_64
with KASAN, see patch 1.

[1] https://lore.kernel.org/all/20260907124001.1544655-1-escape@deepseek.com/
[2] https://lore.kernel.org/all/20261028040418epcms2p7ac0f584cdfdc6a0ea9b7f20eadeada3d@epcms2p7/

---
Daejun Park (2):
      mm/huge_memory: set memcg_data before a split page leaves the folio
      mm/page_owner: also check PageTail before reading memcg_data

 mm/huge_memory.c | 17 +++++++++++++----
 mm/memcontrol.c  |  9 ++++++++-
 mm/page_owner.c  |  7 +++++++
 3 files changed, 28 insertions(+), 5 deletions(-)
---
base-commit: a13b500946e5dc467976838572b8ddd2fd777ca7
change-id: 20261028-kpagecgroup-split-8a749c6ee27e

Best regards,
-- 
Daejun Park <daejun7.park@samsung.com>



