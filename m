Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A1EECC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5DF6F6B009E; Mon, 20 Jul 2026 15:35:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5B7156B009F; Mon, 20 Jul 2026 15:35:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F486B00A0; Mon, 20 Jul 2026 15:35:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1D1AE6B009E
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:05 -0400 (EDT)
Received: from smtpin01.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 8AD6B802AC
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:04 +0000 (UTC)
X-FDA: 85010158128.01.D5AEFFC
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	by imf08.hostedemail.com (Postfix) with ESMTP id BFCCC160005
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:02 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SEkunHOX;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576102;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=pZmCSk3Ktta7GM7YUNaW3uB9vhWdsptSIGrgvbOB7hc=;
	b=h9PSmRM47mDc1r6rHBPFbJp8usc2lu9KzAE7ZEPIN5xEr6cKsJKAx9TkzWp2e37HJTw3GB
	6/Vz4eyKpnKkoxCrSTby8p/mEdRh+g6AejpFmniZVdHEtbrtLyA3XPG1HZ9xBQUyJEstsm
	OQMcEtHd5Jm2SIdp2KFtQcQPgKQkio8=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576102;
	b=dAzcC94t77roRtibJQGvfYWhoFOtnplUzivDIvHcpT5bzlQdbPfDq1/WC/u0Rrjl3qWxyb
	2hxoVcIMHmGjUo3lWqO2OrtNkL7Rz3IVP6a4YjIjBwiJr58bQOHDwzyt/uCzKPsB94TO0I
	aE0kWIfQeS2BRObwTeieLLtwdn5pwJ8=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=SEkunHOX;
	spf=pass (imf08.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.177 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e5c9211d2so926768285a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576102; x=1785180902; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pZmCSk3Ktta7GM7YUNaW3uB9vhWdsptSIGrgvbOB7hc=;
        b=SEkunHOXRmfBbFSN61y98oma7l6cehPhmot0FWwioPnPE5yjUtPm7ya5WOHvlPpgFR
         9LGNb5RvAFTLS91AyOZYQOhA7DjXYYpXLw3aP3h0zSZqIeI/5mg0cNwdQOsOD6C5GgNc
         T6S1xOUoohN2dywLXqvEvbs+qwRzfNJ3drE4Bj+p2nWPSyyYg8N2i+Af9d5hen2rCM44
         Z08cjQAdnRcrTIL0/URLtQZh/ByxNE+FdFpC99Y5QFRDDT6Fd0zWPuReQIne4Exn5ddJ
         RuuF3bx27LHBLh5jas9PxIlfbpmPKSLZL+Sw+JMYvAdhgrnJ87Iea2lb96rSzyRr3yXJ
         FINQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576102; x=1785180902;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=pZmCSk3Ktta7GM7YUNaW3uB9vhWdsptSIGrgvbOB7hc=;
        b=TrRaminWfOiGEDdUO/rkM16r87x4Ljkjk/B/omXWdwX2u9vpEnLEDqElJSRr1RwqyP
         dKO+iPu72LdCGr4Uzf/yAiH+RavUsPWbpUYNAllXrJ/TT37eGR2L3MD9ajjq+fu9WTwc
         mlFExMyELo81isydVvcupYj/yOxzelATyjeYbqFl5ZiQlVWCGLL6R0hqzCwFKOBdNiyd
         zoBI8MFnQaPge/TAlbmeJWTRz6nSJxhACd79XjC+9uBX3NKzfNBkyfBnkqNW9pTrn2Xn
         3lgFPLai8U68I0rl68VCfqu/D6DAo+vDvLeVyBaA6e1T6YqEjcafPzmgTLhQvpvAcxut
         N5Jw==
X-Gm-Message-State: AOJu0YyUMUxbzZ7VOP2UNKstL5mwDK3Xg8rWLp1V3F2XYJ+6Hp3DJHzO
	4cfItv+pQ7ZbBoto3ojMvz6r++AFAFgMJzdLAmTV9NZ5wtQsne1tS04/bUYy6faen1A5XiInR1p
	HI84U
X-Gm-Gg: AfdE7ckqN1atXAMM98UpyBFDvFIXV23Oxy9U5DfMfSLTEQVvh5UCV3itiJTj9u6Z9MI
	nYMTHxPc59Uyjhk1vRadkL0xgmmJtMIPT9+rd+L3SDxYUNL5n0ruj57aJQu8s2rMz1OWe5XZt6m
	SC/zLV0xpYkjyoqBASQXeVCTRtw8MRgO5/UgZwLKLDiW+FJLHsGI4j4qGtCTfAIC/aTAkFLoCeT
	+IqbQ2hMWinWjdb+HxpqxtlJpR+TAuae+P1w4rmZvJKPd03I5XGjj50KqnJOJL+pXD2ogyuLqCf
	5nDCInickxseIAf7tgcUFZ4JRiZXhjS9aFuXp+Zpj4RLHkThc/S7Szrj1PTSudjf3lIe13EV9no
	8GITMQE113GJ61PHxM70CtFSD5PbRf22oIVotumaX2Zr4RecbtRc5+KdbCnT/EqPDRlu/27vPPX
	K/VACZRqFKT+O2Hidn9cNYKPeh67XuJ+RPxmFCsqi4wAaj5Ag12xd8CMIhKNB5xf2S9ZfQ+Q9IB
	pZ4DFdOUsdS
X-Received: by 2002:a05:620a:a481:b0:92e:cac7:9706 with SMTP id af79cd13be357-930b431c958mr1298084185a.52.1784576101920;
        Mon, 20 Jul 2026 12:35:01 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:01 -0700 (PDT)
From: Gregory Price <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: Zhigang.Luo@amd.com,
	arun.george@samsung.com,
	balbirs@nvidia.com,
	brendan.jackman@linux.dev,
	yuzenghui@huawei.com,
	apopple@nvidia.com,
	alucerop@amd.com,
	matthew.brost@intel.com,
	akpm@linux-foundation.org,
	david@kernel.org,
	ljs@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	djbw@kernel.org,
	vishal.l.verma@intel.com,
	dave.jiang@intel.com,
	alison.schofield@intel.com,
	osandov@osandov.com,
	jannh@google.com,
	pfalcato@suse.de,
	jackmanb@google.com,
	hannes@cmpxchg.org,
	ziy@nvidia.com,
	pbonzini@redhat.com,
	osalvador@suse.de,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	byungchul@sk.com,
	gourry@gourry.net,
	ying.huang@linux.alibaba.com,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	longman@redhat.com,
	ridong.chen@linux.dev,
	tj@kernel.org,
	mkoutny@suse.com,
	sj@kernel.org,
	jgg@ziepe.ca,
	jhubbard@nvidia.com,
	peterx@redhat.com,
	baolin.wang@linux.alibaba.com,
	npache@redhat.com,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	xu.xin16@zte.com.cn,
	chengming.zhou@linux.dev,
	roman.gushchin@linux.dev,
	muchun.song@linux.dev,
	linux-kernel@vger.kernel.org,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	nvdimm@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	linux-debuggers@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	kvm@vger.kernel.org,
	cgroups@vger.kernel.org,
	damon@lists.linux.dev,
	linux-kselftest@vger.kernel.org,
	kernel-team@meta.com
Subject: [PATCH v5 09/36] mm/migrate: disallow userland driven migration for private nodes
Date: Mon, 20 Jul 2026 15:34:03 -0400
Message-ID: <20260720193431.3841992-10-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: BFCCC160005
X-Stat-Signature: epdxeyjzouxx9hk9sef5g4gf8bguguet
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1784576102-172968
X-HE-Meta: U2FsdGVkX1/x3NhidXUjcFROFrhUNmTgDvq3NXhwns201T4sX5zlL24P0fPJBTr5KQJo3fgNCy0+qb97+LHC2YuW4yzGueD5feT6GvAzrm5QhNd1pi4qP9lbjWqcr1CNwjCVofsztiqAA6tEW1JNf0vQKJhfwUQb50qlugAZaKxNU85L7t9OaPNhENXvAscbk6p2UZYsZWP7u0t/0PRgz+j0dhrMi7R86UBF64sSM2DH1l/z/CErjmW/PpVylFuzZZMQ7nLCpZhESlUO50kHiP3NEIc1lstvl0lGwMf+/ppI2lMragXNNmMreYncu2Hxw2d0r5lwCR43KxVG39wGhAFXAWVVPtGP59fUdC8OiyRGWRfHLV8Q+N6yG6k/qN9dNPnd1gDeTLgutUv9J7VaEnZErn7goHETss/XBgDqdfvoxCiwexrPEJ3psGmbZbVi/+c5hvm1OF6HW6E+1xu5eJJiI46IT4TaSpgQHh3JCwgYT1S/YIuKE/54Gp1rwfzmfciE4RQO2J58EayLsEYFjsF7M92PiJ81NrsfjnO56sMOr5hUeYhHqGUGY0sNRuJVuYvbeN3uqr1cbtcHFHRObCsnyrCPUuJbetypIN0GU3S4YAktIiUh8DBPHnWrro3aBqkMRHdBuQAQn+TgNXtbM7stWBzAr7/PUOG/2baYKnS3aGEqzHB4F+VXQ44NT2fQQif4NgJuhIqPVnaDuitLlyIhg+j0tKZ8iGxVRKmxd6Gt61t9VpJFtFFHg1a5Y+dJTzUJ0qRruaNscKZz0npJmNQarndy5M7lGZiJlc0XU+QjvBzNJW359SGIvnfCs4qZ8KGSRlwLPaLqtHmRiHTIt7l2xwzhXJcCLmxt7V8qof8IZ+6Q/34TKi9uElcM18iC/lS0sKb0PMvqC/4z2H3zSqHSw0OSTyAtjunk1u8NFlzPSjLGdMoOlIqb2OECFkHUi0Q6qlpjHP0v4k+c1m8
 DUeY5bo5
 8Zt6xu2CjHSaFZLEZSewljBjHzyVR8d+jmEVbPcQDqBHmK314I1PPdQCgq+/Y7rjNnBsPfTow4DKyiW7P237PhgYczzerNZuJs6HAIgC0SuXhjDkrabCwNkWANCq4uideXuLI7n3l4FdxVlf+kj7Rx30FqfKiecQ4aCplHJWpZ7IvZ1LGWU7nt0rSnooWAQ5Km9eB6AA441tqnaAF0ePfJx044Qkk0eFwTUiJCwOJEsVNX31pzrVuJWRQeLfqjEiDASWFZxLZunXzg4PDIgnd+Zx8BD3Szrm16xroBGYwQSouKOG5/Lm0h/AK1ZQR1o4FQHdUEYD+NH0GWLqPRlORgA/2rhtEpFQgQe7YeIrhZYJyHQbYQo34egQkr6jx62LGpoIZ
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use the same filter locations as zone_device folios to disallow
userland driven migration requests for private node memory.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/migrate.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/migrate.c b/mm/migrate.c
index a8a86141dbb54..d20674c07b947 100644
--- a/mm/migrate.c
+++ b/mm/migrate.c
@@ -2268,7 +2268,7 @@ static int __add_folio_for_migration(struct folio *folio, int node,
 	if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 		return -EFAULT;
 
-	if (folio_is_zone_device(folio))
+	if (folio_is_private_managed(folio))
 		return -ENOENT;
 
 	if (folio_nid(folio) == node)
@@ -2477,7 +2477,7 @@ static void do_pages_stat_array(struct mm_struct *mm, unsigned long nr_pages,
 		if (folio) {
 			if (is_zero_folio(folio) || is_huge_zero_folio(folio))
 				err = -EFAULT;
-			else if (folio_is_zone_device(folio))
+			else if (folio_is_private_managed(folio))
 				err = -ENOENT;
 			else
 				err = folio_nid(folio);
-- 
2.53.0-Meta


