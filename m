Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12FBDC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 62F5F6B00A3; Mon, 20 Jul 2026 15:35:16 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5DEF26B00A4; Mon, 20 Jul 2026 15:35:16 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4CE1F6B00A5; Mon, 20 Jul 2026 15:35:16 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 21FD16B00A3
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:16 -0400 (EDT)
Received: from smtpin25.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 940B11A0297
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:15 +0000 (UTC)
X-FDA: 85010158590.25.4A2678F
Received: from mail-qk1-f178.google.com (mail-qk1-f178.google.com [209.85.222.178])
	by imf09.hostedemail.com (Postfix) with ESMTP id DCE1E140012
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:13 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GEOmCZyd;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576113;
	b=czq2qAXWVCgPlPXsrU8J/KPoyGmKmSHCX7i+qswv3UBuQkilRrDkh9yUEdBOpRVrQJjM2q
	UJDSbBNhmijdrTMIjLumvqBNuUWtjqmd8RMhaf4GilnNgf8d0trlrPxH0JTs6yASMAZwM3
	7/S75xXnWsaSUnClVmFECMyy7yekEyc=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=GEOmCZyd;
	spf=pass (imf09.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.178 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576113;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
	b=F/xiL2OGsF3EwKySPHpPhrAYml8fAOIeXOGBlw03zzbbEAnkNUrXjNfCos2QU/Bjj6pXN/
	/UTYNFBYvST3A15IkMxCt7wUv4dDGljWOtzcj0t8DpBJ9BcfxM5+27AnsC+JvDm16GvqcD
	sARvicm3XCXS3UeKWsySjhCFMwPB+Do=
Received: by mail-qk1-f178.google.com with SMTP id af79cd13be357-92e5b048375so757524385a.1
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576113; x=1785180913; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
        b=GEOmCZydLdBno1taiSJZu2YHjHB6/3Z1U9QA3otMyZFAew1wRsYkYlh+uY2bGCisME
         D8678Z7QP9l+0WKQWgqtIUeG6Fgi7BAVQY3KhNQucO0LDqIPGN2kHomi7tqYGiEuXIn9
         lsdDVMiEV3NlFI9FLse736GtiXS+rH12QRE7dKrC+TXImYd7DkjRgMwvQYEA3azxnIqh
         zqPK4pWdzbBge0za5iIG2iKiOMJ9DoVuASpIAghYv2PzxNRTFNMjTjxieblSo5+c1tfx
         nWelfUtfr9deOvAdFWKht47dJvs/Eg1bESe+1yrdjlocH+yJmeTQGtkSzry+L4so17nw
         NLbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576113; x=1785180913;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=dXwJlI/llosQi30lLS1O2+gV7rtKvgDC66cTY4z3y4o=;
        b=HS3tPjsSe9ZVzilpiHtjnV0RQxXqcIwYbfnhPgSyV/P7YZTQcRGD+3AfFAxz80hIj8
         UbV5m0qxVUKFbe/qYbD16//Ofsujg4sFbs0yJsXR6YMwYGm5Cl/fuSY4sKPMHMizH2hR
         XqYz/CEHjNpikIcFaIFdNKDbys5RC1rNQBufD/kW7OBCL0iuFaXFkc5LaGRE1LvxSlkl
         JCecnZSZR/KOsd0t/tLd1sQVLxWGBrkUKc5RciWlL8nW1DHgLcmUD/AwPF5LrgAWuLHX
         vNwmlFVf1WoiISBAC4FCDiWhT0r1FGZgIxOd5fcQGTz6X6yYYFpkTd/wrjO1qco9TuJ1
         YQrQ==
X-Gm-Message-State: AOJu0Yy3NfFVwio8OiUStDwiOrx6nhhML8x6cFo/RB0g7D/h9qVLQ+RN
	jET0z6ESLYIPOly5mIJdeRPHZZ+ts9bFVvF/UAYSO0FC+OUQZPnBVsTxmqQEm7tfNJ6eUAfuN7S
	6ZakU
X-Gm-Gg: AfdE7clyuf/BNPiojTYp8yLkYAy2c81TdhTgqHHOjqgCUwUgB+Es7zqiiEnlpYNxrZx
	PQxBsh+/f93605VJEFAjnusNRwpTX/BnF07dkoKRLrQ8ew+oapwJqWrJ3lhZV8yFAn3+oHOv/39
	3ii+TSuwAWbLnUyP+edZrQa0QXVctzh0kBdCUhnp4NBiEATv2ev2V1tKjWSNATHEBFNvQk2IDKr
	ufQUivJzAwyjfVOPxwRiu4aZFDgF6lWujmqwf7Ku8k+EcIRQGXrs7HxluhMgY8tZmcFAGzXQbeu
	wIfvq9HzIMH5nh6vOxYJhrwjS0zDVOqBeLyM9MtOWK/0mNbssXkyqrZ42IWqaDTOYGveouM8cTf
	Oe0A8oZPY+f1W2IcxzUMzXkTndhRKVTcFZvkC6BUcDPpuS1gmyAcsoaMVOEbZxLFLdhN3BafkFt
	2xXJ3kp4GtRqwEvPhTGaaqA+HH/HO7b2nRNWm1egw/RQI3lEaFVfIkz3hpkusTkGo=
X-Received: by 2002:a05:620a:45a4:b0:930:af44:c3f6 with SMTP id af79cd13be357-930b416db87mr1543521885a.43.1784576112837;
        Mon, 20 Jul 2026 12:35:12 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:12 -0700 (PDT)
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
Subject: [PATCH v5 13/36] mm/mempolicy: disallow NUMA Balancing prot_none on private nodes
Date: Mon, 20 Jul 2026 15:34:07 -0400
Message-ID: <20260720193431.3841992-14-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: t7fhipypj33refpyrttp1a63xe63nr9p
X-Rspamd-Server: rspam07
X-Rspamd-Queue-Id: DCE1E140012
X-Rspam-User: 
X-HE-Tag: 1784576113-551174
X-HE-Meta: U2FsdGVkX1/WAoIalphXtKhGnVVe20YuF17f5wZ5dsKMWHFOVPqWxhHqWEcT6ITWTBa7nV6F051CC2s0GkD7b9y38+y35VQ/fg3u3UO6gFmUBZQtrdRpjgocEuWnnV6tTJwqIXtyi8+Jvbn8yIsDgq3/uFOfUZI5lo1CWDHidtXvtFUCfNkhfHZAyMfGp5PCI67ObjNV3D6iTvUgROcSvee2W9HCxOWq2nHb+RWA51i+DREDmlKXODoKD7Im6aYT762U9sI33/Ym5ElbmqG4fOcyMLVTGfCuQDwbO7p1ZUmp9VSSLxc4wCwL2tfsGHVvAdYfuX+GQ9lOO7n7lubAq08DsUu6/MeDr1mCvE+LVwI/ClCziyFevJS58/nV4cUeFoufVwR2PpY3nydtOZOTFUh7mfcVjQ/9rTPe6y7NGMViah6P3g6g9S+PmCE4U9BEBGuZBAu6pCmgMW66n79AsKJqRJKxnkHnyWQkyXGhjrtPVoy1JpufbthmWWHjBoSREY/hochzV43QxHTUlX2OhgELrEE2B/bZfAVYDjdEyjZYN7DDI9Zea/0lh6HyAHG4+/G7eN8/tOJzxYznWHyRJoWWs4LGPQEup9HW+c8NRzQCNEDzlbEZuKeShdt1x9OHDnb1Y4tih3mwJcjGyTOvNBywxwTOdrjdt7FnUWsSSvXddmXOsZdqrg28gDnJPkoK4SFV9WhGmIvThOj4ULrF+Ki+oEqdy/ABpcFtlHN/xLdPks/1SYSfEBhBMWqvwzwxrgqZ3MtlDXYW+PAwx57PSt7/BR6BhS5jspTtSHyAeMlBp2yYMrg3SgGAMVbD5GKmyEZ8ujqe9QrhX6DRWGlUurkIG+02ybShHomgez3DnRJjeFY/71oXEHsjXkrFHRU/I+d9uvMRREJ5JYzZ5zLYTtwwrV3qpsF/c9xRQW3vcZGb5YkY4JC5DRKkovfm4X46CzNON0RQNelqDcS2gPC
 p0xq/7ey
 oSjOBKmSDtpyrXMGnOd6lTzC0fAcZpUZYSwnF8nrjxkA0pedXRglpVARwBnAJv5hIXWiklHeGe3COcFlg+Uyi69dQm4VzR64wC3HaSwi4v3q6tdZ7oix74t7lFq/ixhAzUn+3SY20ySYM4iEcOGgQsW2i8K6rO6gjau7PrfeDOwE/Xy2Uk+hTKNMcpXpWNVILZPZZU6ohn3KVk/yDvBGJOFN8JBVIbW57pwzPMVkXHLhIWasrqcFCDnCw7vikdYrsCTiUQy5K2V/4vJvBp0FAtP6nKZCOQvoiK/M+ThcPy7rFu53u/9N4ceWHI4faNT80DRqK2TwsuvBoB9GGjsdt0+g8CqNo7MVG4NAobWxqCfJunxgkoHZS8k/5OY5YYbtjdWXgMrrXq8H/SpDYmau5v9/OOJOIhA8mxPcw7z3NhnS3Z6U=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Skip private node memory the same way zone device memory is
skipped, since private nodes do not presently support migration.

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/mempolicy.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mempolicy.c b/mm/mempolicy.c
index 8e8763f6e5f5b..2b76c57a460c9 100644
--- a/mm/mempolicy.c
+++ b/mm/mempolicy.c
@@ -845,7 +845,7 @@ bool folio_can_map_prot_numa(struct folio *folio, struct vm_area_struct *vma,
 {
 	int nid;
 
-	if (!folio || folio_is_zone_device(folio) || folio_test_ksm(folio))
+	if (!folio || folio_is_private_managed(folio) || folio_test_ksm(folio))
 		return false;
 
 	/* Also skip shared copy-on-write folios */
-- 
2.53.0-Meta


