Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DAD9606C6D8
	for <linux-mm@archiver.kernel.org>; Fri, 20 Nov 2026 18:10:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Rc2fPlPM
Received: by kanga.kvack.org (Postfix)
	id E8FBC6B05BE; Fri, 20 Nov 2026 13:10:03 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E3FD16B05BF; Fri, 20 Nov 2026 13:10:03 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C92976B05C0; Fri, 20 Nov 2026 13:10:03 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 993856B05BE
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 13:10:03 -0500 (EST)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 1CDB08013D
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:03 +0000 (UTC)
X-FDA: 85456286286.25.7A8D949
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf28.hostedemail.com (Postfix) with ESMTP id F4079C000C
	for <linux-mm@kvack.org>; Fri, 20 Nov 2026 18:10:00 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rc2fPlPM;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
ARC-Seal: i=2; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=pass;
	t=1795198201;
	b=PmQ38w4YVodSZ2r+s1REjifGD2n1h6bZ5Tr2FX4KuPc/nqpCqs6AGQCGP+gNRbfKFfJPhX
	QTX06ZJaGbSXPwyNfdwGAi2JbsQMGKwFLn8Pt/Qh/0plH3z6X4PWUYUNVpLZ8Lqzsxmiw9
	tf7kSB71djTxaaLss/gfA8hoT3h6pfo=
ARC-Message-Signature: i=2; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795198201;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gr73u4IkiOa9BCictU2VtS3g9h9o19ZGrPCxtMBrlkU=;
	b=o6EgHOxZThNynXERjTdUoNkB7pqU0G7dfvruiOwC47x9hTYPzX4TfVaZ+dmZ0g1dMXc7HZ
	1YeLLnb2pRAxjWBQwm2433ZJpGKtW9aq4pGBrCX9M7vL/e2oC/ZQmg+Jpf+/5jzH/XBT3O
	hMFmnoz2tNMYXZhUjDsRDaYRiMOHo/Q=
ARC-Authentication-Results: i=2;
	imf28.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rc2fPlPM;
	arc=pass ("kernel.org:s=arc20260519:i=1");
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (imf28.hostedemail.com: domain of devnull+gourry.gourry.net@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=devnull+gourry.gourry.net@kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 4197145F1C;
	Fri, 20 Nov 2026 18:10:00 +0000 (UTC)
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795198200;
	b=Ciz8Mg1PFyhLuZiJ8lBOiv8i0U8rEkGF8UplOYuVgappsi9R7/I4KK0vhw6r7KUHPQGu
	 lLpRozkGsEn6YKVAzjmCdwS60BEI5b5xCOIgqZhObBg7Qr4SCWDvQkjnd58lPE2IqYBYj
	 UXHJuttqx24FXNrz6aW3wimZ+MDW6ey9iFD6+qQjxwAjR1NjM2weXvy0B7u8AfreKvAEU
	 y2lIQH9UEqVGQkXz6ThboTflv4pqEC4GvMeQxmpz4Jn731FgEZpHsuCajfkYp2wKDJVIG
	 kDKucyoiDJ8MtlDbwPauw/fGvquXuOFYIwB5Bc2s/z8AEdsnHeUlHXM2T3k6GQtFgbA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795198200;
	h=DKIM-Signature:Received:From:Date:Subject:MIME-Version:Content-Type:
	 Message-Id:References:In-Reply-To:To:Cc:X-Mailer:
	 X-Developer-Signature:X-Developer-Key:X-Endpoint-Received:
	 X-Original-From:Reply-To:Content-Transfer-Encoding;
	bh=gr73u4IkiOa9BCictU2VtS3g9h9o19ZGrPCxtMBrlkU=;
	b=GyRyO729HLndq0Sp3OdpQdYyJaBeTlU4GUtdac2dZ+p0b0T+WjPWPXznVBkxiWMSqMGz
	 iSXeSfjuD2mTyyVfR0hyOHm7WYIC+ZE7ZfsrsoX30Y+lwJncy3LMsuyYPnTdKtRKI44rh
	 OiKlNqO+SpGg21dr/pYQsHbEf/CuHgCYoNbewr136mhugEqyE7D7/3I72yEpaxVhueYkg
	 d4zA71oB6lNpLEoRaiRXLQGSsQYaLs98N7HG1xHs1689xs9oh7B3Nse94uZrVHfx/aFBd
	 OXdGA1CQUWcidCdNlkW96850k0yqHZS38TLa7w5mcmoueY2Wms0MKWaQyoVIJQDrkOg==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	arc=none smtp.remote-ip=100.80.115.77
Received: from lkml.kernel.org (nexus.subspace.kernel.org [100.80.115.77])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8C95C1F000EC;
	Fri, 20 Nov 2026 18:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795198200;
	bh=gr73u4IkiOa9BCictU2VtS3g9h9o19ZGrPCxtMBrlkU=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:Reply-To;
	b=Rc2fPlPMLJGFC+PBLd1vrsie9/Cam+bY0i7Fw6T22fDZSQin4ZNpeGjZwiLYtRCAY
	 LVYXVPlAl1yck2iKmMg3api1WimxSYUA+XvMURQ6UG3W6OfsmWToKOkZ7xpmh9rt6Q
	 YTfbqGTrXP4EBmqW7C8Wo23yXl4lxzJE4YZgZ/7WKVJaUu2ojY9RE0IZqOy8R9nVDt
	 pmkq+onhlxtdfsnrfFtLBYgytRPXjORlgqQyQmd2m6gBmxCN/3enpEzc/sjMDNCRoF
	 nPgObodq5uizZ57K8Fqrv46XZw8MxjohwV9xFMbZGTyFNXFGghFBvlhQXKXBsdB/K7
	 59eY2D9YYVOCw==
Received: from nexus.subspace.kernel.org (localhost [IPv6:::1])
	by lkml.kernel.org (Postfix) with ESMTP id 175F44B8E5;
	Fri, 20 Nov 2026 18:09:18 +0000 (UTC)
From: Gregory Price via B4 Relay <devnull+gourry.gourry.net@kernel.org>
Date: Fri, 20 Nov 2026 13:09:00 -0500
Subject: [PATCH 09/60] mm/damon: reject migration destinations outside
 common memory
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Message-Id: <20261120-private_nodes_v6-v1-9-74f5f9a115c2@gourry.net>
References: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
In-Reply-To: <20261120-private_nodes_v6-v1-0-74f5f9a115c2@gourry.net>
To: Yury Norov <yury.norov@gmail.com>, 
 Rasmus Villemoes <linux@rasmusvillemoes.dk>, 
 David Hildenbrand <david@kernel.org>, 
 "Liam R. Howlett" <liam@infradead.org>, Vlastimil Babka <vbabka@kernel.org>, 
 Mike Rapoport <rppt@kernel.org>, Michal Hocko <mhocko@suse.com>, 
 Andrew Morton <akpm@linux-foundation.org>, 
 Oscar Salvador <osalvador@suse.de>, Johannes Weiner <hannes@cmpxchg.org>, 
 Suren Baghdasaryan <surenb@google.com>, 
 Brendan Jackman <brendan.jackman@linux.dev>, Zi Yan <ziy@nvidia.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
 "Rafael J. Wysocki" <rafael@kernel.org>, Danilo Krummrich <dakr@kernel.org>, 
 Johan Hovold <johan@kernel.org>, Joshua Hahn <joshua.hahnjy@gmail.com>, 
 Rakie Kim <rakie.kim@sk.com>, Ying Huang <ying.huang@linux.alibaba.com>, 
 Matthew Brost <matthew.brost@intel.com>, Byungchul Park <byungchul@sk.com>, 
 Alistair Popple <apopple@nvidia.com>, SJ Park <sj@kernel.org>, 
 Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, 
 Juri Lelli <juri.lelli@redhat.com>, 
 Vincent Guittot <vincent.guittot@linaro.org>, 
 Dietmar Eggemann <dietmar.eggemann@arm.com>, 
 Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, 
 Mel Gorman <mgorman@suse.de>, Valentin Schneider <vschneid@redhat.com>, 
 K Prateek Nayak <kprateek.nayak@amd.com>, Kees Cook <kees@kernel.org>, 
 Kairui Song <kasong@tencent.com>, Barry Song <baohua@kernel.org>, 
 Qi Zheng <qi.zheng@linux.dev>, Shakeel Butt <shakeel.butt@linux.dev>, 
 Axel Rasmussen <axelrasmussen@google.com>, Yuanchu Xie <yuanchu@google.com>, 
 Wei Xu <weixugc@google.com>, Baoquan He <baoquan.he@linux.dev>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 Michal Hocko <mhocko@kernel.org>, David Rientjes <rientjes@google.com>, 
 Pavel Machek <pavel@kernel.org>, Len Brown <lenb@kernel.org>, 
 Nico Pache <nico.pache@linux.dev>, Ryan Roberts <ryan.roberts@arm.com>, 
 Dev Jain <dev.jain@arm.com>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Xu Xin <xu.xin@linux.dev>, Chengming Zhou <chengming.zhou@linux.dev>, 
 Lorenzo Stoakes <ljs@kernel.org>, Pedro Falcato <pfalcato@suse.de>, 
 Jann Horn <jannh@google.com>, Chris Li <chrisl@kernel.org>, 
 Kemeng Shi <shikemeng@huaweicloud.com>, Nhat Pham <nphamcs@gmail.com>, 
 Youngjun Park <youngjun.park@lge.com>, 
 "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>, 
 Waiman Long <longman@redhat.com>, Ridong Chen <ridong.chen@linux.dev>, 
 Tejun Heo <tj@kernel.org>, 
 =?utf-8?q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>, 
 Dan Williams <djbw@kernel.org>, Vishal Verma <vishal.l.verma@intel.com>, 
 Dave Jiang <dave.jiang@intel.com>, 
 Alison Schofield <alison.schofield@intel.com>, 
 Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 linux-cxl@vger.kernel.org, linux-doc@vger.kernel.org, 
 driver-core@lists.linux.dev, damon@lists.linux.dev, 
 linux-pm@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 cgroups@vger.kernel.org, nvdimm@lists.linux.dev, 
 linux-kselftest@vger.kernel.org, "Gregory Price (Meta)" <gourry@gourry.net>
X-Mailer: b4 0.14.3
X-Developer-Signature: v=1; a=ed25519-sha256; t=1795198152; l=912;
 i=gourry@gourry.net; s=20261120; h=from:subject:message-id;
 bh=PHs1dwZV5jWDY/oD9jV+dBublSOMfq9XyD2sA1X67ls=;
 b=EHjtqMd7/8EaTbdZ+vJ1PCa8apdnUFyPwhm5wisIAr5smnjEwxj+N6vWTCoyNXJw98hRk2en0
 +blI33RHe8NCH5zVJHV0l2+J4bHQKjBy4yR6u86Gh0NgqVYPfJ4g5b/
X-Developer-Key: i=gourry@gourry.net; a=ed25519;
 pk=BZWDlx4htkR5KcvGjGtSDfx1tM0E5dlyBR43FEhjWVc=
X-Endpoint-Received: by B4 Relay for gourry@gourry.net/20261120 with
 auth_id=1586
X-Original-From: "Gregory Price (Meta)" <gourry@gourry.net>
Reply-To: gourry@gourry.net
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: F4079C000C
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: d8zsbs7rshwqordmujj5chtsu7n8prg4
X-Rspam-User:
X-HE-Tag: 1795198200-924555
X-HE-Meta: U2FsdGVkX18IFstm4NDGwfPmApm7+R1rp/Wn8fYIlF4sYvbI5zliQh+h8gt4FA1LC1IZy/hbQmGm3O/Vd7kzprX/Zw2XzHmc9OQTWNHAosKek2/i++jHUkvSI36Zy+ZXwLCu20Hu+3Vu8YEVVZKSycH8sGoeoMn/Ky77D+oQsF9qWVC0prtxou7lvzXjbbH97prjg0vG1RBTm4V85/OFbBmb/FHZBGt09mknLiupsmPLrHjPGHxbcI6c15lwrh1MLOTFMohERlWtu6e9jZzwe5bkKJLEOWIvJHSFQVwrAD0muUSAVOd2AVWKNBiRmxAsuT1ZJB3iC5JU4SF5rYpX5RTlQX7w9aAh04KRBzAlVotSNaiyLmM2TCfuhGqu4Pibx7vKqtyvoIyriT9XzNnBNaEGiTnSBBxxW4m9vkCMq97T1YgxFQeK5F9acyvsr2F5oNkcw6IT3J25ho/R1XV6sVw7YAaues+fe3/6xyxgiNOC6HWottQPgqP8TUdGmVuu3mJuR3ZTzOsC4Pz4SYJCxrKdyMZktbQrjEcreWGvy7bzlIiFuzVk+isFYEd5zt9KgAVluOREIVbuqzWuQAtCJ30gXqGBvf4wHgumidDB4RNkB0NEYQ+LG+Qw0H7Tqr3BuXimb8ZSjpAMlDmWBgGErTUIpysYeSy/J/STjHzqDoadG7ag5IztmTOlkLCclmPlgVSyBoOuS0OUQHCu0rVLQPyrlslq8zyTdX3ZJoBAc6qp5+V3VlRQEg/Ys5TvlXbZgvrCDzNVCxZfHgPSMr1tcVkI3REO3HTy5pxFxJYrEBewmlBIhxdLbcappJTgQEWjgY+wYbCU7ic+plzbSjcjFP8E7B6f+r9UhDy355FvENnD5iqR7yn7XXvOmKvuia8YPtc/ZHpKQ00vvgzpGX3yOQvaUJ9iWKLyUoYAjs6YByNESgyhX0hT/z3Rkl6hLo3748bTqh1i6x16Wf9/9bk
 T4f3qqQH
 Ekx3qdSEI6YqZwKaS91koIx/D76tZdz9t7iVWWEB1KpOZXdPAzoz4UzpYR5hlKxTsNkGq/XAJhp8uxBh6kACRftv6vjFlgSrP4Jhjju1C0hkBCFAZznIdx9Y9HGOApeVMpQUDA6wS0viG01p+rDl37aU9+Rjsyxs1LWkq9Atnq6Ml5EjrlJr/pjUINxHbc77sSMhijSRFSgk6r2smP04lHbS0D2JRhL4EyNRL8kQj4aweoonzoGxeTyJq7efKk6EAQvfG3O2enL/txP+jQ8IPtvuoRQqFmTvOEepm6mqrHB+ZodTbgbRXHxXNJohJ/G+Q6g2P1TTExGdew414vTYoNS7lwPIv4RtWb3ugExeqb9M+UhBhKEIod2Z6IBMwzdmDR8+rR6MMyHRcpKRoqEcS4Nj1rY2EnEUYsPZB8OqigNedbzMQfjLHuIk5gkeNQhiR99p1DpSIzAuKNTOfdL7YM4jdfVvPl/L0HJBtGA8dGua2PrzF3JXqltKCGreLLlhM0OlQ2XtBmCDWHefl+xkK+7qMRua4KGM7MiR9f5SQ68yk9MZhBOys3ReLxoGlfS7cgBRlMtDxFfdPBkSSSGRlznbaSYRS8fHUZ7kA9d3ABvqNyuNSDaTsm2j9BeSPL8HMqbFDBJwq35eDhcZ8Hcbw5aNuDuOmXy4q2BxjLjOxeOrT7j99bVF0OG/3i7Fxdj69WfBZGZeEm3Su/HF+CPj92iwSoK/XJHhxmKo5/3XjXvF/D9x485Z0hJbyp3TbDznk2t3EWieTe3VT5v8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: "Gregory Price (Meta)" <gourry@gourry.net>

DAMOS migration actions move folios to a node the user picks. As with
move_pages(2), the destination should be general purpose memory.

Reject a destination outside N_MEMORY_COMMON, exactly the same as a
node without memory is rejected today.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/damon/ops-common.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/ops-common.c b/mm/damon/ops-common.c
index 2216a0023154..15cabc79613b 100644
--- a/mm/damon/ops-common.c
+++ b/mm/damon/ops-common.c
@@ -498,7 +498,7 @@ unsigned long damon_migrate_pages(struct list_head *folio_list, int target_nid)
 		return nr_migrated;
 
 	if (target_nid < 0 || target_nid >= MAX_NUMNODES ||
-			!node_state(target_nid, N_MEMORY)) {
+			!node_state(target_nid, N_MEMORY_COMMON)) {
 		damon_putback_folio_list(folio_list);
 		return nr_migrated;
 	}

-- 
2.56.1



