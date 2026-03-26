Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 345F4FEA800
	for <linux-mm@archiver.kernel.org>; Thu, 26 Mar 2026 03:27:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 657516B0005; Wed, 25 Mar 2026 23:27:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 608006B0092; Wed, 25 Mar 2026 23:27:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 544E66B0093; Wed, 25 Mar 2026 23:27:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 469766B0005
	for <linux-mm@kvack.org>; Wed, 25 Mar 2026 23:27:40 -0400 (EDT)
Received: from smtpin23.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 1C610160BB1
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:40 +0000 (UTC)
X-FDA: 84586779480.23.5BBAEF3
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1929B1C0004
	for <linux-mm@kvack.org>; Thu, 26 Mar 2026 03:27:37 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=de4xc4Ku;
	spf=pass (imf20.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=redhat.com header.s=mimecast20190719 header.b=de4xc4Ku;
	spf=pass (imf20.hostedemail.com: domain of liwang@redhat.com designates 170.10.133.124 as permitted sender) smtp.mailfrom=liwang@redhat.com;
	dmarc=pass (policy=quarantine) header.from=redhat.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1774495658; a=rsa-sha256;
	cv=none;
	b=ZtTC3OIjhbgB2M1BMeHjebnpK+srfZTeEQgMcCxQkkA3y0ArwtcRRnopQpwo8u/BCAL2nE
	0HeIcajGsFSq3/blKktiaV03MN+BPvrFzZ9mBLFRaBwhTAZ2t+r624GTqFUUq4qKgcI9MO
	/YoMXkXzxKkscvlPG9XatShLhJ3Jyv8=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1774495658;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mpe5+6BEENtzobjSR9FLGbgq/dfpUrP+sg7IFVwkji8=;
	b=nOhaG4VEVjr8By3tl4Qnru3J0ebB0QtSRxRqvIJSOaU3P5y9Ueh2nMY3I8Q4J8T8t9gx9a
	+4KjuH6R2TvL4zGlwhNT/li0/YJX4RtFhrwFu5ObDhFidrC0YLJcZLtFNZXeRE0lttwiZs
	4whHWjFgtCOaUkAYndh/iNV9JA8VRPI=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1774495657;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=mpe5+6BEENtzobjSR9FLGbgq/dfpUrP+sg7IFVwkji8=;
	b=de4xc4Kuc2F/t4nfDEaVaeXdUUlsvVB0TSzQXbIY3aGyr5yX2f+lOMP9OCWKYTAPzuwjnl
	vsMt8J2YYMFJTK9/Mjdlqbz1/YDP3sNUtu+eI+emN45EZaJMDCw+K08Uf4cpw24UlZwebN
	C7B6i4tk8zW5RDMCJCtrZyecbW4mTFE=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-606-f-2A5cPvMGCNGCUaiYzyXA-1; Wed,
 25 Mar 2026 23:27:33 -0400
X-MC-Unique: f-2A5cPvMGCNGCUaiYzyXA-1
X-Mimecast-MFC-AGG-ID: f-2A5cPvMGCNGCUaiYzyXA_1774495652
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D4AAD195608D;
	Thu, 26 Mar 2026 03:27:31 +0000 (UTC)
Received: from fedora-laptop-x1.redhat.com (unknown [10.72.112.83])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id B61DD1955D84;
	Thu, 26 Mar 2026 03:27:25 +0000 (UTC)
From: Li Wang <liwang@redhat.com>
To: akpm@linux-foundation.org,
	yosry@kernel.org,
	nphamcs@gmail.com,
	hannes@cmpxchg.org,
	mhocko@kernel.org,
	mkoutny@suse.com,
	muchun.song@linux.dev,
	tj@kernel.org,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev
Cc: longman@redhat.com,
	liwang@redhat.com,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v5 3/8] selftests/cgroup: use runtime page size for zswpin check
Date: Thu, 26 Mar 2026 11:26:53 +0800
Message-ID: <20260326032658.96819-4-liwang@redhat.com>
In-Reply-To: <20260326032658.96819-1-liwang@redhat.com>
References: <20260326032658.96819-1-liwang@redhat.com>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17
X-Mimecast-MFC-PROC-ID: fp_soEIu8FoC0Wh2rVFqB2RaA8-ogvWCLed7Qcodnr0_1774495652
X-Mimecast-Originator: redhat.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1929B1C0004
X-Stat-Signature: uto3ws6mak4fkjjdwj4ejrz53r8pq4en
X-Rspam-User: 
X-HE-Tag: 1774495657-405937
X-HE-Meta: U2FsdGVkX1+YIO+pGvM5OwMWnB9inNLX3Wj1oHrDA9CDAETeBpj6ZoEj0DeYxMb3PoxqiEQnFwUwkMM64wBe+PZKqLkTnF5EMcHEN31Z88Tt0iJhhvk2z4XWr4hd7nFzoMmjMkjFa0XOrUWYzse6UejUAn2lxAAzLNQ8WsAtwd/7wHwJwwu08pRhJwMhMdFBo3FMHkgnzU/2EsVvdEjIt9ZY715X3m+9K1djkLFWjwONrroVvyJijibm8Ynqshzgjj0nfBgr+PAbrBR/5PHChZQBKqnYu4Lq550AUejRIbErVYakGmKjH6lASN1TovLSKKYh0jKNjuWwQTHsAJjSSl/FdOMvrCwa2F/ceVnWQOLIT5NxmFVYakw2d8kxdYljUoZvK0oqVSpXnZE9ZdNl8QPwxLlE/YngQxsvT1ktX1B6udpi+oDsK8/p1K46Qrj2J8/5uI96TrLyj2dxenoA6X+z1+rwgS7b9pVtzBMSIqzI3hRRyDwvrgkrQU16kfcaaQpor7C41qE+hIRyeJPeR8yEXybXEER9ze4FAN6/GCwR6w737BPMw0bDPX91oMkbCj8Cv0yTm+htJ7xfstvfB7MAF8ixP+y/qWO4MICdr7adrWxDM0uioW5xnSHP7AJegvSmeIj8pQKiJn6aJQ7O6FuysZHGCivn7a4O4/a4OG2ABSpia9PbKjv8/2mFsTtlyVtQcNYWENvISR5HTcBgNGEYCT7Ys9SO/Hov9n459mZd2+8xYIYDRd/+1/zqjAlJL2CFHF2Fa+18Qac2Voii+Xnf/KfuXJ+JdGw1uuVmD3yNyf+tISlCBT1sADyUMOXk8+igfeVvhcwFAbw4x4zSnotj+LJPvssoVVBJxpc8NXn5GS14maDycf9sGoW1cWOl1Ly+IL9/NjHKOBMxI3Te4cseiC4tEA0wwe5cCTIV+3DkGXES3u/IRf1vguprNrDE9YKuZrr7odTLsN3ANa5
 xbIcUrTs
 oamKiCE0XRNMFeM8eVq1vvGjrM8eznp3DhPLigubPdaPC7jsITdrDH53991XPokcwU5TcDAUlWKPsVVvKvuPDstIVsbWC7G4Pk9CjInROxuCWOc6AsI1KxqoBH9x8+AtWpaBh+5TRV61fQcEyYn2H1EUDPfK/avvq/syBEVPlULmCrwDRNcY97mtBJrEUQ+mB+xJLoXenGzUUzNPfyqEe+005pfkIxMVfo4LcG6QudKIWF61O8nfXzj2knRIgzUsQqrLB98Uh9etEhqISmMXekBlekd4G0EEll/QUE4Jee5dHpHuaJ1xi8OLJOVPASDm8SKeUl2ONHWjnABqr0uD2AjpbJols1Pg/5hI919uu9o80ZTtoqtsK/Dk/5lcyMn+OuClE2zsPdGaFQDzrmr8G6nbZIuq95VHxvzieqTACJycR3ehvA9rudoOFOfIm/8DmtOHGm7Rc49aqykY+TcU6D4FGl+Mf+RVwVNzBljBEQLhxd6CB9alH+Gdz0Ao0tU5RjTPRThSSVoK+nGeQggZoFXOyVg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

test_zswapin compares memory.stat:zswpin (counted in pages) against a
byte threshold converted with PAGE_SIZE. In cgroup selftests, PAGE_SIZE
is hardcoded to 4096, which makes the conversion wrong on systems with
non-4K base pages (e.g. 64K).

As a result, the test requires too many pages to pass and fails
spuriously even when zswap is working.

Use sysconf(_SC_PAGESIZE) for the zswpin threshold conversion so the
check matches the actual system page size.

Signed-off-by: Li Wang <liwang@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Michal Koutný <mkoutny@suse.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Nhat Pham <nphamcs@gmail.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Shakeel Butt <shakeel.butt@linux.dev>
Reviewed-by: Yosry Ahmed <yosry@kernel.org>
---
 tools/testing/selftests/cgroup/test_zswap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/cgroup/test_zswap.c b/tools/testing/selftests/cgroup/test_zswap.c
index ed257d464bd6..516da5d52bfd 100644
--- a/tools/testing/selftests/cgroup/test_zswap.c
+++ b/tools/testing/selftests/cgroup/test_zswap.c
@@ -243,7 +243,7 @@ static int test_zswapin(const char *root)
 		goto out;
 	}
 
-	if (zswpin < MB(24) / PAGE_SIZE) {
+	if (zswpin < MB(24) / sysconf(_SC_PAGESIZE)) {
 		ksft_print_msg("at least 24MB should be brought back from zswap\n");
 		goto out;
 	}
-- 
2.53.0


