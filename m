Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3FDCB606A326
	for <linux-mm@archiver.kernel.org>; Fri,  6 Nov 2026 22:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=amazon.com header.i=@amazon.com header.a=rsa-sha256 header.s=amazoncorp2 header.b=CHV5qTc7
Received: by kanga.kvack.org (Postfix)
	id 2E5196B05B1; Fri,  6 Nov 2026 17:05:04 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 296126B05B2; Fri,  6 Nov 2026 17:05:04 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1AB616B05B3; Fri,  6 Nov 2026 17:05:04 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id EC8A06B05B1
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 17:05:03 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 69070C0207
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:05:03 +0000 (UTC)
X-FDA: 85406075286.17.CEBD0C7
Received: from pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com (pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com [52.34.181.151])
	by imf22.hostedemail.com (Postfix) with ESMTP id 26964C0009
	for <linux-mm@kvack.org>; Fri,  6 Nov 2026 22:05:00 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=CHV5qTc7;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com"
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794002701;
	b=iu+sEu1v0lQ5N7ycxYgHUGYiA1vVBkf4SyBQcGl5hoHkflsTEpSeHkraNhd/MbeUMaoHcV
	Qo45mfG25pnfgCPUBCps6y9w1u6Y24u9aFw0hymq2w/x9FpNctkJLtjsylun/xVZooHSGL
	D1GECxdVBAUpQvLc1EMvFhYJBkf43UE=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794002701;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=oLrmRPO4L41NIijXQyCjQuY95kcRuW8UwPMF6YfqEyc=;
	b=7p7XEshsA4GPzf9QsYH+PR8ht9ElEo3wSanrj9rvwRPcD9KhT4FOkeW3TPT5WHOuwOeT/L
	XVsbdU3QkksiYmCWUufFyo7LcmrYxBO1KNcHZGSTiMqL6dh6N0gxUeYsi5KB9k9KupR9g4
	pbGV26Ya/J2a3bZ/JDjIomLZ7GA29Lo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=amazon.com header.s=amazoncorp2 header.b=CHV5qTc7;
	dmarc=pass (policy=quarantine) header.from=amazon.com;
	spf=pass (imf22.hostedemail.com: domain of "prvs=76345edb3=mkbund@amazon.com" designates 52.34.181.151 as permitted sender) smtp.mailfrom="prvs=76345edb3=mkbund@amazon.com"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=amazon.com; i=@amazon.com; q=dns/txt; s=amazoncorp2;
  t=1794002701; x=1825538701;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=oLrmRPO4L41NIijXQyCjQuY95kcRuW8UwPMF6YfqEyc=;
  b=CHV5qTc7D1WxzmhIWmoU5ZoVLLmi8y2VZP3KGjrFqsOwkqoNTYJsDKrC
   YsxhNpXwghGiRzf/eoZr2kgpUNjwEQmzM0g6zmwK6oQBlJUmZzIOJ6oqs
   TeM5mf0FkKa+Eb8kshVXdRsurEeENEMRpSBYZ3yXphodbADqKm1aUG0bc
   VUgHqxJ2iHH8JoJ0XIygpSvgdF0sjqD1k8l4mDPMyPIYkbj1kRYGTfu6S
   yjo5jQtl81L7McmGCr4hMKM7E3Fwb71eY61nfyDV0vSTtFQH1fVtDeKx6
   8OLXz+oG2ieyAYbffgXV3RRzMM/5S89DaSqRfAJshtoAee1nNIOuGVVm4
   A==;
X-CSE-ConnectionGUID: T3CdrGdWTJWJ6GjmeSEA7A==
X-CSE-MsgGUID: lyuyMoCpT4KQU6TPQ5A6Fw==
X-IronPort-AV: E=Sophos;i="6.27,199,1787011200"; 
   d="scan'208";a="33352098"
Received: from ip-10-5-6-203.us-west-2.compute.internal (HELO smtpout.naws.us-west-2.prod.farcaster.email.amazon.dev) ([10.5.6.203])
  by internal-pdx-out-007.esa.us-west-2.outbound.mail-perimeter.amazon.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Nov 2026 22:04:59 +0000
Received: from EX19MTAUWC001.ant.amazon.com [205.251.233.53:28602]
 by smtpin.naws.us-west-2.prod.farcaster.email.amazon.dev [10.0.49.48:2525] with esmtp (Farcaster)
 id 6ca3e216-2074-4d18-a158-eea63cf6ce41; Fri, 6 Nov 2026 22:04:59 +0000 (UTC)
X-Farcaster-Flow-ID: 6ca3e216-2074-4d18-a158-eea63cf6ce41
Received: from EX19D001UWA001.ant.amazon.com (10.13.138.214) by
 EX19MTAUWC001.ant.amazon.com (10.250.64.174) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:04:59 +0000
Received: from dev-dsk-mkbund-2b-9ea2efba.us-west-2.amazon.com (10.2.100.138)
 by EX19D001UWA001.ant.amazon.com (10.13.138.214) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA) id 15.2.2562.56;
 Fri, 6 Nov 2026 22:04:59 +0000
From: Mark Bundschuh <mkbund@amazon.com>
To: <stable@vger.kernel.org>
CC: <sashal@kernel.org>, <linux-mm@kvack.org>, <david@kernel.org>, "Mark
 Bundschuh" <mkbund@amazon.com>
Subject: [PATCH v2 5.15 0/2] mm: replace free hugepage folios after migration
Date: Fri, 6 Nov 2026 22:04:42 +0000
Message-ID: <20261106220445.2859944-1-mkbund@amazon.com>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20261105070206.3094675-1-mkbund@amazon.com>
References: <20261105070206.3094675-1-mkbund@amazon.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: EX19D031UWC002.ant.amazon.com (10.13.139.212) To
 EX19D001UWA001.ant.amazon.com (10.13.138.214)
X-Rspamd-Queue-Id: 26964C0009
X-Stat-Signature: nmd3ph96iujggpjbigk1p61wi8ygzbhb
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	UNPARSEABLE_RELAY,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=4.0.1
X-Rspam-User:
X-Rspamd-Server: rspam12
X-HE-Tag: 1794002700-808051
X-HE-Meta: U2FsdGVkX1/Nv3eW+KDwuhqweFxqIZBGwFBXFshm6sdL94lSwmGduO2G/hDt9/sjLebwQDDdutZ3VkQvOouu8cwbCmg7V6T3Nt779SVxqT+dbpc8NZqLXRs1LUdYz+Hy5oiJU+uVmYVVbDt3gwA3UzXDYX7TQURvUp95xk3X3+iJx9OQFGnEbBYvRzWkIDPDjPRttXYTw9v/JwqcccDydwDYv9GhQOYe3XIVy7YopNYBbO30a+UpxWYPdUI9BqUfivnE0QJsqkrcfh+9xkzGJskh2V5GFM39CVyGvN7roGzIov7S4ItOde9Zf2WXTfcw0giNgArObaEsfHfoOvdRYLrv+UKor8ryW+jXzh9PYDmrGC31AsZisE5MNyyEBaOQFS+x2O4ybSmsjQFos9fyALZRN4/FWyLAy8cprxDUu+b3V5I89m4HRnmDOrKWgMTTKqxMvknfx20oGzDmuuP/vvuVepG5VXNoxxWEgXjGtIcKwU3sah8qqZfgcFD5eG/C5Tioa/gwkb4zqn5diorADIcLr4M9MgHIIY0CXgU909urN0VSaJnx04KonOhRIDJhlcQmx1roBtgJlIlm+DV6ZCXmnXIuGy2sjkdJNldE2q9c/7jUYMYfAzxzlQi70M7Y7vNETwzJCOXaqmeonsbw0mcjqsQrqYNfXvQCBdIDUT6PRULMadu57IqDPe4WnAR/ZQcdsjHGL6GBKVxG1WxWdR/BHEZb5cAyrVbBSUEaVlzvqpWwRGDGWla9Qu40l17PmdptkG+htnUVNHMpvkyUjuxhMqGD4Qu6dr8FZEa4sgvNNmtolCc+/vUYrHPP+hYGtjQfWpl/sENsMNr5cF+ApBwHIfLyAcfe2ZEboTHG0oYhGvINNVLIA8zlQzs2B8pO/NkqyqO01JZCrVYnYpoD5gR3D8anJvmu7jYR0J2xxSHr2HLPDTMohitTrHfZ8EOhp/VNFN496SHWm1OqnNi
 6tIKvraX
 AJuQevZ7Ia6XzeOuiHtA57CsGlcfACuZUsxSFSWPDmpaem4TkUgK34d3SmY5omLdDGuqbtinLu+As9q6xVcwZ0oQvovQwQnbEwj8Ypyezqw+CsOuXdwUqFF2+cAoZ7hIZj7XpKij5LgPAk9ErHNzmNrH88urF+kekaRJEA4yZvK0UQDt/Nm+SbQTnBcIEDdq5xK7aPm1bRTbVIBefnTVSoWAZgs2GUFk1cuyalRjvVTOmk5xv2Gl0a/SsuDtpFxKB6KzvzsrgCWQuXI0eXQUC7RlPdrq9FiVwMMj7qI5xwLUDPtlcjbF/rJEnAygBCFXGN8PI89LU3MMcCXuo0PA6GalCAuc1YCz1WWGnxqBEjEXNaFu8DsC5gEst73fz3fA0Ehsdwit9IKBAWted3fqx8sUWFueV0ZBsWKl3B6vwxgbgNKJywzx6OTV8TRQCg6l+kxxSqWXWCMhzCpATltgb/Z11DipluJs1mzkBWFyJOM+Ro+9aWcudNxQJOqTUOnIiXEvKiqfsrV9G4iVKoSy//nFCZ4S22wBlQ98zddjLUCExrmq61vDbSdeXgWLQChyzXdpHJIcbkBBV0wi5WI8PgbQruPp3CrR9t6XpkiUDe52EjgyE0KsUShHYrqxTx510b75Zr2bO5KhRQG2/j83YZ5Ok3KcqPuZHc7XCP+BaIzeEJbAytnRNkf+ePQ+QgDrNYHvuhAo5vbwMRZqdFlquBGpNWefdQPruTum+iOJqGNi8AigTXmbG5YMrwz1Cv2btuIP7fXXEgaaJdEM=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Full backport of 04f13d241b8b ("mm: replace free hugepage folios after
migration") with its fix 113ed54ad276.

Tested in a VM on 5.15.224: memory offline of a block with mapped huge
pages no longer livelocks, and cma_alloc() over mapped huge pages now
succeeds (it failed on 5.15.224 and with v1).

v1: https://lore.kernel.org/all/20261105070206.3094675-1-mkbund@amazon.com/

Ge Yang (1):
  mm/hugetlb: fix kernel NULL pointer dereference when replacing free
    hugetlb folios

yangge (1):
  mm: replace free hugepage folios after migration

 include/linux/hugetlb.h |  7 ++++++
 mm/hugetlb.c            | 49 +++++++++++++++++++++++++++++++++++++++++
 mm/page_alloc.c         | 12 +++++++++-
 3 files changed, 67 insertions(+), 1 deletion(-)

-- 
2.50.1


