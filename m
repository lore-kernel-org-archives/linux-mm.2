Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1F47160A3808
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=An8XHT+K
Received: by kanga.kvack.org (Postfix)
	id B598F6B05C1; Sat, 14 Nov 2026 02:10:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B119B6B05C2; Sat, 14 Nov 2026 02:10:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 95DC26B05C3; Sat, 14 Nov 2026 02:10:30 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id 6FD5F6B05C1
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:30 -0500 (EST)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id F26CEA0253
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:29 +0000 (UTC)
X-FDA: 85432851420.09.FDCE57B
Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	by imf24.hostedemail.com (Postfix) with ESMTP id 4519A180004
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:28 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=An8XHT+K;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640228;
	b=vcO72NlWFLQgxux3lymvWezcdPXMp3oa7nkpGdnzGVm+nozL0tjzc4NK7WnmSSlKbjwL+X
	l8nn4SwNxWcNKdot51USdnWYzi8P8SwkuB3O96MK5eR0odm/Vcq/fZQXhxresbIo4TFd2H
	ia2BfUBYKvZTauQDbq4/sku7nPw9yA0=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640228;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ug/CLwAsG6XPyYIr9OCoTcVisBprjwnxP+sIccpst3I=;
	b=q4pEql68tfHgIwTOmz/lM3qWBq+O4d2nGwne5ceB8s0n18mabSuwV4eTJn3lweSYtPOoys
	Srm38fMCwaI9Mhdfbxw6/eAPYMXh5kc36E/zTbyNbTdWNxrkx1q08x5Mg9oiENFKAu+Tct
	/P1VMCgHCZeGeCWOmE4yiQkWgrqUcxY=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=An8XHT+K;
	dmarc=none;
	spf=pass (imf24.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.42 as permitted sender) smtp.mailfrom=gourry@gourry.net
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-91f2b826fe9so19623076d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640227; x=1795245027; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ug/CLwAsG6XPyYIr9OCoTcVisBprjwnxP+sIccpst3I=;
        b=An8XHT+KKnmQ7URnEKI37NdDYi1Xy1Nbd2Cku7F3hCaLY2jr+B3rp+oeu8j4LWDmwk
         0ckp62llGIcm6zzB95k72YKcAcfITWs/Fzw8lucd0/UZ9/WtMJ56rOSP9QDYh3/oC5nS
         vXJjB+pBtUViKUTyGbtJ4vr9Yh5oCA7c0POxh3x50CNmlINdTws5OYx7PjGT4HE3VHog
         0BiuKF4vDtt3c2S7xxngKP4l7Ju96TBMy1KJyZjoUvheDBOmZQm6pTt8hkaSrNlvxMLp
         xOqqrDFIpJ4WAUs3+15pCGVffC9Z2wgwVaqBlAa25gEboqz8FjjGuIHDckFin0vogSgM
         XGgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640227; x=1795245027;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=ug/CLwAsG6XPyYIr9OCoTcVisBprjwnxP+sIccpst3I=;
        b=O94mwpWbqGJlSb+NWCWNmlDOeo+8g83kSSQvLwrNC0PtM/tLCRKzGaruSla02HlK/A
         NT1H3nW4eEEvbCRQwSuLug+u2ofaeYCmPJzM7QnlJpiKXwhDbaJoOt5Nu3s/zGEgxJwo
         oG7H1mWkijUYo+3YVflWlbQZhMD4PXKW9evFHxjDkf+Jg98N5/9mpG4A7qJj5/GpFxEs
         2GL70D/r3iLy4IdxJSA8G58yVgx2pXjcimgYxjNOX2hvlnMKnyk3wjLrBnPKr7D4HZVt
         TKcU5kUAqg0TGdn+dSAwhHOikYfbiJNCP1+OOhgZD1UWQVm4BxnNmQAqUAioxd3YH6Ui
         OZRA==
X-Gm-Message-State: APuU4Z9yx04yq53DKvn9axbrkVOyMA940DZERdNWQ8f3+Yk0TisTEI7B
	g1f/SmckN+X3cwOZSnFNVeKTgMU9yBDFMcQOAA/rvjmnRKMmursAcBT0+2yryWw6zCJXKbg8cmW
	BHosb
X-Gm-Gg: AYBFou1P+YvEBBRkBGDHxiiqBRaRvbpXDSFjCShskJHNKNnWe02ILpVQ62kf+a/7Xsg
	96w8hUq0xZVt4pC9wwIQlCoI/8HgEi1iQD0i9AHYCj9ZeL8Xd6WGP1cq9LER4Ofsw6Nkh3Ux36J
	uLRQpCZlZG9MUgUknvgSiCe9kazPWoT0sImPQBNAeKf7C9V3tUTljs0AndzWpnV1+JYhXVmswDe
	5WsuHV2tGdSjIToKsLzJlT/2kKpsdErNLQpBopRk6I9uWApQ11+TNwXQFPGVH5SNQYgHiJwojqS
	AnkA+VYQ/wHEQSzKGGsVXCp7XYAFsU+nFG59aEI1H+uFRrN8PPwOEtCjZ2DVhHc7nzTaBrm1OTe
	sN165RryRkl2B9QAZg00/VX5fisEIykmKcMajKW5klpNT3O4XxNF2uPPFB3qidFjVyOcI80N/Sk
	hXDaRE4H6OuQPuz6zFgW6vWRRxH9Tl45ka4MyMwltrFLC8VEP3dSYiPojFENrotJFwk9310vN+H
	OsYI0RozuH6SDSxeNbmk0yRJFd5eTO28Z/+j34s0efzq1UTkLBgt+WiSDtso+xESStiPrqlMcf0
	mPVC9wwwzm68LysQqAZtbQbGD96AiLET9n73tz22uIyq6DFl6HU5DIyTBcDwGAnPqDkE67BEhvA
	wPsgL0NwgkpT06Y8=
X-Received: by 2002:a05:6214:dc1:b0:91f:1bc7:b779 with SMTP id 6a1803df08f44-91f24251f4dmr78714166d6.56.1794640227399;
        Fri, 13 Nov 2026 23:10:27 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:27 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 11/22] mm/mempolicy: don't NUMA-hint folios outside common memory
Date: Sat, 14 Nov 2026 02:09:48 -0500
Message-ID: <20261114070959.3490008-12-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 4519A180004
X-Rspamd-Server: rspam12
X-Stat-Signature: n8t7ze1efa4xp7caum6phbpfeeyw4wa8
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640228-74237
X-HE-Meta: U2FsdGVkX18RPXmJChPSZRqU5uT8TuVwWqF9R5RDz6OlAOkfDhnsaw3j0kWAp+1gqXQfrgdL4LRyB115Bt9cNVrGGk25Voplq+hwlS0qzpjYzJM/vLIzsa/84TBhr/vviB3vl4qwnw3Z9nmTv0Ow5036HwASnyEgPZahwIcjEKE/gIzWscFdZmZgjYtF5IMPPjb8WX2aJ6uVhD+BExVJuRL6PeKLA6+zurrQGInQfo1V3ofvB6k3+crWY++37h+IUHIz8mADhQIdWbXAi9Fj92BlcjlqZS/+fUKBzgJrZBkEC+n6fmA5nQYmXgQQZxmmZT1py2R2jgUdldmiDaDnzjkPnMpfpDXFh37ptMmGI2/Vu0YpRY3VOV5/3l2CEoPzbs/tK53M1Ihkq9FzPiO2nI4sal8vUTvaWgnhX8IVaM1cNP1mmZri3S5d7av0bj6afgUHJEsOZ2n/dQc1RrmU43uhzzdWB68ZzkSEjuqH6qCCB0jNRpN+s7eILIp7VuDYOl8wC3hahe4oLPj8OyHOTY+kHq7z6LZ5Dmt+4tdUn0BEtgqhmOb1M8Hjh22pgWxzb4jSTf1/ll8I0mDeubJGFlPFmNTEgMmXtVN0cKLPSEYHGBE5SVVA2UjiG6VjJqH34n3OlOPO773oXLo3lBozFpzSzDmSN9lklhHSfviyLzodUpDhqD8Z2v1vxB7iaUOjzFDEJBDaSxjN5Co1s/uG34qGw92elR33qg/t4RDHyU6aC7pyPDyCJc5TpN4pDmgnNNtSd0yPAPqnDsARfCCWop82ZlCeY6DMs2oOxBn/RBD8xQZbD8L3hbTxb5Oa8L2/Pyr4hSk1cQ+OKk6hUQoto8fGeCXQf61UoI0SQwDdFkuAaM3Hrw7H2EvnxZWTIY1VID3OfpX3ieAcgiea1Dyym6URHCzOmlMnIcoBIGuJGWVMKLSAagnmspN24FMH8NT87J76IMr0h4KvQw6KTnu
 k67E7pz9
 XrbYQiVhmfelqWSs2LYvSllrI6JF1QcLO1nLauT9SZ7qJYIDR6fklGZic1kJngIIVcTP2eVIOVSCsWBjOkVrTIfTLRKRrLTF0B1LYOoyXpYxT/WuBwSn9hmPEDEjGgFUOBgHPer52C1ycyOVr45BWxven3ccqeZFvWHQzfWO14SEY7SYh3j1eF6Zsl9lP2EbemTL75ReNlxrDYepIdZcfPKApaBCt+P4cjwPpd0qddlXG/dRMRAUzCOVLZVbeIsmqcfa87rUDK7uaNF0f5dFyWDQ5dS/VS8XmfmV9Z+7dQbWO8Bh6NrNZSUsIJq1OyUUE6JJsM+9K+iu4AbAGiFkZFWjshaylxw/jLFvFf5Qp2V32OP+lLsz+60ZEvsox6ObTXUCjD89G2ZyRykhHa0Z0UGsIkoWAl2eL/eMPXDKCXFEwy16MWGYsdDEiQqwMITixY1f0DGVwJRqoinRVKZafNKAfvikv/gDRMNOLXDS+G2oHcNs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The NUMA balancing scanner installs PROT_NONE only on folios that
balancing may migrate.

folio_can_map_prot_numa() already skips ZONE_DEVICE folios. Skip folios
outside the common memory pool (N_MEMORY_COMMON) as well. Do not inject
hint faults on those folios or migrate them.

Convert the zone_device check to a common memory check (which includes
the zone device check explicitly).

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 662ab420fe03c..619970f0eb954 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -863,7 +863,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+	if (!folio || !folio_is_common_memory(folio) || folio_test_ksm(folio))
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-- 
2.53.1-Meta


