Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id AB14BC44529
	for <linux-mm@archiver.kernel.org>; Mon, 20 Jul 2026 19:35:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D33196B00A7; Mon, 20 Jul 2026 15:35:23 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id CE3506B00A9; Mon, 20 Jul 2026 15:35:23 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B373B6B00AB; Mon, 20 Jul 2026 15:35:23 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7FFDA6B00A7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 15:35:23 -0400 (EDT)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id F33051602B7
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:22 +0000 (UTC)
X-FDA: 85010158884.26.55BFDEC
Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	by imf20.hostedemail.com (Postfix) with ESMTP id 47D641C000F
	for <linux-mm@kvack.org>; Mon, 20 Jul 2026 19:35:21 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tEOoaoST;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1784576121;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=t6FOiK4vob/RxKMxAQwNd3dgf0KAGjN7gNG/YIVjxjc=;
	b=tVzaxMOIUiz/bDYZL/MzhiiytRDZNFQnPkEnHE3oh8HmB6yAtqopxrzBCo3xqjcUVVY4qe
	lKxDLCAyzzbgHLUJBMjqiat0TRv65gHzfp8/vIIVOijbWX3iptR5XaKo4XS9W0FgoSzUpT
	4k3eaZoVXzIv+YmTxbR4fuQtozpXKZI=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1784576121;
	b=z+ig2tVzIt4ZNoES2SB9V1ihvik++/77IP2bgPZ4fpmRFgI5DbQS/cZwDiXzz56LnFAbMB
	XiI6HRWKh6XQwQq7oplO8UzqQBsuKpJhVb+uYWVY0HU8+0luwsuijOCi6ZCXWTqgG5Xhxj
	X5n+0AFKUVI0z5qLIg6nGVuZT7a9cGk=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b=tEOoaoST;
	spf=pass (imf20.hostedemail.com: domain of gourry@gourry.net designates 209.85.222.181 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-92eafc94c9cso824379785a.0
        for <linux-mm@kvack.org>; Mon, 20 Jul 2026 12:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1784576120; x=1785180920; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=t6FOiK4vob/RxKMxAQwNd3dgf0KAGjN7gNG/YIVjxjc=;
        b=tEOoaoST228w9k/NYuVtPvrmOJ+JOOSn5eMc+1TmPp5ydcmeL6+v2A0iwrnJ5TwGJO
         k2sAaw5zqYRE6ZAT5qpxWcoQV7luts//KS130dmrB4EvEe2EyVxcjroDUjRsoglE0RIX
         cutzUwxoZUT4r9lcl0ooXFCLYqzPyHKO5Ls4SjeFbTlNcCZDzvkRl5lv2njcUB2um+tp
         nAeumRWXLvtuudURWdD9tVOskKB4RGPEc1qsNJMEQtyVpWDiHlc0jo9x0ecDPMjz9eUQ
         Rvyp7UTFViwlRu9ePnM0OVcWaORMW5l1OqszL6rY95qMVWfcBLKY6PIrctiDqKNkpnhS
         mipw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784576120; x=1785180920;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=t6FOiK4vob/RxKMxAQwNd3dgf0KAGjN7gNG/YIVjxjc=;
        b=WlzGdOAKKrFMDlTYswdfNVDKVAHtT6+TNAkHBMg69+YEdBBTId4s5PymlURz5wTf56
         vTCo3R1/FASFLeiR4pc4TRwKkDoAeRuCLCSlfIG5IbUIPlnTACCRmx4zK6CVhik5MjTW
         HMcLO2/dep4O9XzEhtFxSWv8vpQehohqWFoXSYZxYvI+FzTgQqlUg/6KyThURQZkPp1f
         HH61XSAPNysV75IctZhhzEmyfdnmL2gyudfn+2Vx/3Z5FCmOX+0BI2Cn12joV5Q5v6cp
         CPZ2h6V3MkI2kPVvNaE+gsNe+rdqsDk+c4lmHY3NlGRTPIrnx1ruHB5sxDM1uRO9cqpd
         xE5A==
X-Gm-Message-State: AOJu0Yxx894kz3SE6u7QZLaq//4Urc12Kg1Ktu+yhev2oC7aZNdex4ys
	5s6+/2EQ5sYR+S+Lmkhvt2Ha8Ll2DNqMs1PShqA224KmHN6QMTw7MkJdm48567UbZ8B1HgDoXax
	h9CqB
X-Gm-Gg: AfdE7cmp5VXfp67IiLq9su2rzc0Zmkv7A2vGaOO6HldWOpgxeovPvzLQXsOyxIH5C+4
	YNg24xBBtetv/IRv+8+q9ZXa/p33p021idwJC+SQUdUEt+nFoDtW3zx6WJEnAayhEJNNYqwxxNN
	MfNd1SEF19K4m9OGIT7aCjTPOIYBdF8Pu55h15GiTSYRReenjVPEPhyvxPvZDGOOvp7Qb6kP+QE
	ugqw+YbE0UCDqvz78Ruspy7eZhVCIAifqqJTAXo7lmxjPz+NVIcHDvemcVY/jwXTyLAHVzc+FVI
	tl62apg2ZMQwpGb5aZu9mWT5Te1h7F2pNPyxvf2JLPDDsFeJG8nWIqdDWDz4iTZI5qkXpSjzp7W
	Rpf/2iuo2efFY5gVci21uPxlyLI2VJ75OijSI9CSNFB5gvqlEqyqNArYxLVrgQ69Knxus5loO1s
	5c+nol0Ei2ffd5AN5AjOG+R76FZMl2nlHPwiwfPeR884OtiNffoOmNSDcEOVI+TLw=
X-Received: by 2002:a05:620a:290a:b0:92e:7745:9a3a with SMTP id af79cd13be357-930b3e4e1f3mr1582641285a.18.1784576120209;
        Mon, 20 Jul 2026 12:35:20 -0700 (PDT)
Received: from gourry-fedora-PF4VCD3F.lan (pool-173-79-60-52.washdc.fios.verizon.net. [173.79.60.52])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-930b545e47bsm957792285a.35.2026.07.20.12.35.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Jul 2026 12:35:19 -0700 (PDT)
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
Subject: [PATCH v5 16/36] mm/khugepaged: skip private node folios when trying to collapse.
Date: Mon, 20 Jul 2026 15:34:10 -0400
Message-ID: <20260720193431.3841992-17-gourry@gourry.net>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260720193431.3841992-1-gourry@gourry.net>
References: <20260720193431.3841992-1-gourry@gourry.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: h1a7nxumcejfsizfq7fxk6udw6sbna6a
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 47D641C000F
X-HE-Tag: 1784576121-850694
X-HE-Meta: U2FsdGVkX1+JkHTulxppYHhgFM7Nuy+8wmdwpV4WxOmZkM1Ho3rmWHtrqyf5qoHlsJeTQDFts5FWpurD9Qv/Chb+3uSQU/Ry5qIyhRigaCk/mOoYTIFAgCazU6ElhDDwB/8n9M7L6ezDH1gTCe8VKwFb9RUhggBNBVSGBTkGKXV62khkvtfEsXdRmHSlwI74cG6kBTeiIn6eUkwon6PgGKaYlNlTtMzF/lmpauJM8MNF+tv9iE7xA/goW0P5uNIX6UaigrCZ/lN1lWimXPWMlXWRpHuNuS53hSX2Epkdmuef+geF3iab7sCsKHBi4BA164Z7lnKZCxI4aPDfUv0XbwTEaeqn0Iv0W1Mn0GuPBAATgMHk7k3yR6R4nEWvs3gYSDsrxXg7nhb16ECNPZQyqGy9+EiBafIIeXR4Y0MQQDwuLU0oxrOCZyHmKmZB1SHlivXFf0BNd7glEYoXki47QPTOWrv2PnBMDzgOZ5oySE52agb5+/5fs9/Od77W7wENHyRQ7HvT25mwjw/mgIBa9oI9IHD5IDnGZ2ld+9hDxtIEgK2+kd/30MCq0pGBLQ/rfeHZAgJxprG3OxZHB7ujlEbymtaZKer+53fuw7xGQ5p1aIXliaM/LGF0JcVLRbEGcbQrCMAEycjIoiUHAZV6qh3Lv82KRUqKzP8PJhYVnsVRLNXbqFiA5eDNlhjP4u3n+mxVRT3VhGLpMsbWoeytXxNjiYIPFoevwTERpH+10+F4I/CLyxAvRzn8U5JKo1K9Xez3a1vz+zKcrIl+8BQqluivVRKd4E4f9pIUK8tLeu21klEF6V+FwQo5D0MxFeJVOuvB0ruPSDTpzJ1N1bMmrzSN4lphf6nWUKPcb3BIZPQfRIv25YfaQsYtRwwSjBAdbE7ZgxnXQcC5ZPeUXGjagxa33sDKDXamsoP2OX20e2yF23pHxf9Jt3HNp3BM0VRe9GIe3/NRJjHv45ZCUc+
 gXWIyliG
 CzqJzjwn2p9SOO845pBerJrKZrS7l83ThDCnf7G7J/H6MxynfOXr7VnW1tTNyhq7cJugbovXU/xR+3ErLBMN1aBPaCKzqzQrtBjE2hOKsYGeZQIrru+ixQRcXDBEhOIAaoPYRiLmW4GdQkigwG0i+lw5e8uDK58De5WtbIP2h+4PJ/ZHWcaKXzkRp9MnjycYaAJEnVYEY4rnYOXwVhXoHZKlwskNX6F0Hzt3uRG8lBRg7co4XqMrHNltoLrB6kxetHGQYUUllxsAaR5BF9O2Myz/RF/DmctNTSasxALCcWLFID/YSDCyBTBZ3OdsmsfOpxeoQUJc3lq20cSq3ueJQhNy0q4wW+/6KG+xGktjgaox12LqSFfr6KVbT3QKpEy4R1656
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

A collapse operation causes new THP allocation to occur, and may
migrate memory from one node to another.

Handle this the same as zone_device for now (disallow collapse).

Signed-off-by: Gregory Price <gourry@gourry.net>
---
 mm/khugepaged.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 89ce6bcbc376b..fb4378cc17b10 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -700,7 +700,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1687,7 +1687,7 @@ static enum scan_result collapse_scan_pmd(struct mm_struct *mm,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(page_is_private_managed(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -1944,7 +1944,7 @@ static enum scan_result try_collapse_pte_mapped_thp(struct mm_struct *mm, unsign
 		}
 
 		page = vm_normal_page(vma, addr, ptent);
-		if (WARN_ON_ONCE(page && is_zone_device_page(page)))
+		if (WARN_ON_ONCE(page && page_is_private_managed(page)))
 			page = NULL;
 		/*
 		 * Note that uprobe, debugger, or MAP_PRIVATE may change the
-- 
2.53.0-Meta


