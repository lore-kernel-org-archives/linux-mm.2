Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1D991CCD195
	for <linux-mm@archiver.kernel.org>; Wed, 22 Oct 2025 10:57:32 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 7D42E8E0009; Wed, 22 Oct 2025 06:57:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7AC2F8E0002; Wed, 22 Oct 2025 06:57:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 6C1A68E0009; Wed, 22 Oct 2025 06:57:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 5970B8E0002
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 06:57:31 -0400 (EDT)
Received: from smtpin04.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id CA3A9C04B4
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:57:30 +0000 (UTC)
X-FDA: 84025449060.04.7347F12
Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	by imf11.hostedemail.com (Postfix) with ESMTP id 08F8040009
	for <linux-mm@kvack.org>; Wed, 22 Oct 2025 10:57:28 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lgLgbV9l;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1761130649;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Kk2BPiYFNzn3CXG6RkzldSGrwb1ZpVic8o4pFAU0ZkE=;
	b=7mICk486A2p6mKV250lzNRKiGBEniPNOS1ZTR2l7sFXINUYMxM+FUxetHUY/TY/zEb3sZO
	95kztp0heOaKUDLEm22RwqVDFwBKI2+uEtK2IEhaYyINSuTVe3Fmi+V1AF3uMoHSR0MMnf
	xqz8B7OXB4y7zoCDJFWkLo7q62j3lBw=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=lgLgbV9l;
	spf=pass (imf11.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.178 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1761130649; a=rsa-sha256;
	cv=none;
	b=yoVgd9euy0r5d++ADS7yY7QOjaORqusKtV+lLjZS2YA2rmUWpMuDCnys/dGepbodh1ZcGV
	Lee4r+nygIh4HrTB6WKxbDZv7P7VyUisZDAZVwCMRnm1Hryo8Ie8PTbBuO9mzibeAYKWpl
	1WV/FuYZ6eKRkKmY6tuq5otQiUYixNw=
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-7835321bc98so6017696b3a.2
        for <linux-mm@kvack.org>; Wed, 22 Oct 2025 03:57:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1761130647; x=1761735447; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=Kk2BPiYFNzn3CXG6RkzldSGrwb1ZpVic8o4pFAU0ZkE=;
        b=lgLgbV9ldfgo34d6vJ8PvBQCsniNxrbqemoirSmDW2VUygYMUlBt0nU+e554hVKWHt
         6fXg1q8YcIyTRG2Q2wCcwHwKLHg+zWE5uIrLPWtbuhFEWjOW/2vUc3Uj2NeFwHmX+du+
         D7DisKVvNAGRF1WQL11jhAdvGOZNRNolT5qyXkLwVwucRfzqIpOJGjCOzJce78g+z5Xh
         S/nHnWq5vJoCNkdyLADGMIZcOUtsS+aHiTX540NRd8apVuohmNUrjxGZpbS/Ua3KO35m
         pxh4VZk7FMjxfT8kRDDWH9ggkUM5iBHylGWBRQ/yr9dcgvl1k9RQ8KbbaWGOxYBQxwXN
         b/Vg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761130647; x=1761735447;
        h=content-transfer-encoding:mime-version:reply-to:message-id:date
         :subject:cc:to:from:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Kk2BPiYFNzn3CXG6RkzldSGrwb1ZpVic8o4pFAU0ZkE=;
        b=nc1wMLaJLHTCtW/793krDjvrRP08Pd2ajy2+nMwPHCj5IZMogcuSJt0lB0EE8h9Ra3
         Uk/ylu7MK8foWHIvMIsjYPj39LyPNm8/h0HVib0X+OheN8sOCutOB8+ywzxqUIkZcJKD
         voEuKIspTTwAxb3S1c35tJOd89s/gKXbxaCHCjOwNFYrg/ck1mKz4Dg8X2WbByHzYJOf
         xIJdPuQlQ4jJ9ML8nN6w66ZAFwKx32bESz49rbsjhk4xl1ck7amjMTBsGjRfdNwS8a4Q
         3bDyCRLndJBnHnSR2rHd+JaBYqiHGRC9rQE2GpWGIhQSMO1FyyHAcvIka5kOj4B9sN5q
         9Imw==
X-Gm-Message-State: AOJu0Ywg+v3blVUduhamEC5iHpom3lKra9tDmlr/+r30uuevgcC23YMD
	vsDsGsQ9S/HOWM7Xsul8RcGGCa6ufRhSR/dytxQ4/Z7e+XrRCtetVZQLYWSIFki0rj4=
X-Gm-Gg: ASbGncv7MScUxl/RNFSVIfGTN8+QL3v1DcOcBC7YOGpV88QjqzznvykHM5/8iCOINEn
	Mk6UU7VSIufSxEiRy8+UMzDxT3dYRrapyNJZOeReueIJc522eVMlkIWfkIzFaHPMNgebhuStnuE
	GBtu8Vwd2rrvZjELaEOXXFJYZYd7jrK0UwrZxTuxiM3pcMYQgfOi0VgSsSlChIqncAQAWZ/DN/W
	iX0bDbm9E9rg2EsOskk3fP5KUlWt1bRSp2OQHNI2OOkxtmbHuq0GUzoHoZaFH7jeci7O3pQYW/u
	FR6eZVkilCxOAXrA2zLZQjU/ZX5WLxN9VSawq5fwnLY45QBuQmEOmg9SN221zQavW9Qim7Sa3JG
	t+LkkzKYwp2SAdnE1kiS7ku2ilW4vHdFSF13BcJIivGvnMqpp3lYpu0HSVnJBY6n/0nkAgm/lm6
	q+MB3bQ7vmoRNcyhKxR7pwo4qHqfgyVSo=
X-Google-Smtp-Source: AGHT+IFWysXp9eqMZj5Qi90FK5sw1pd9AH0StflzodduEPErD8Q0fn6Hmz60MpZnfpCZjB1sS9bTuA==
X-Received: by 2002:a05:6a20:5483:b0:334:93f3:9b28 with SMTP id adf61e73a8af0-334a8644249mr25233224637.56.1761130647394;
        Wed, 22 Oct 2025 03:57:27 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b6a76b35dadsm13346482a12.26.2025.10.22.03.57.23
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 22 Oct 2025 03:57:26 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Hugh Dickins <hughd@google.com>,
	Dev Jain <dev.jain@arm.com>,
	David Hildenbrand <david@redhat.com>,
	Barry Song <baohua@kernel.org>,
	Liam Howlett <liam.howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Mariano Pache <npache@redhat.com>,
	Matthew Wilcox <willy@infradead.org>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>,
	stable@vger.kernel.org
Subject: [PATCH v2] mm/shmem: fix THP allocation and fallback loop
Date: Wed, 22 Oct 2025 18:57:19 +0800
Message-ID: <20251022105719.18321-1-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 08F8040009
X-Stat-Signature: zdb778yy5kyoa45kjznxsc3uw4xjrp3j
X-Rspam-User: 
X-HE-Tag: 1761130648-13249
X-HE-Meta: U2FsdGVkX18+3jldXDtMXTBQkBdVJVi2MtDwwB+qST2hThPp8MtCtkFVHGruS80qunbBmjHeMqwoZv9Z5kYo8nPvvhS/7GNGcpw+R+rPmNnNftwsx+wxbzI+ZH02ESkJXkSF2tJgT4v8v5ht488S+LZUjQ4TdbI1yGNjbRQqbsAqxRe/G/XQkJikgEEOW6DPvEy3HkOKPw6Pp8H0tKVkfAdbeT1PIiztuJw8Ojqjc1NbePo5Bh4iSYE0+KIkL0BDA36KYPTgCP+oMBx6HnapyMroLIw7BtZ1Uw5OgrQIcNeBtDNWha9JksXZZsco2KqVcoPpnPX/b5/IKxfXu0jandNzq0GjOh+1yW7xaIxTZxZMJCARdZ+h9nKAGuP6/LLkMdmwJi28SRjtmNkUl7ev03rmPg+av20bi7D2psrt4U5VspzHdTQBlIfuzpVGhr37bkN7vYGGWL0pHV4PHyRhd97EuLhvuX5FQyZwmQN2Dz4CyhgzTvZB3SBvuj18JSJAfFUEq8PFSobtutsOSma92/GgN1A97Rg9aQaF8JKac0R1XgWBQjbgMEEorZx3rvL/y7tB/LekMoo/2okSTHKw+aqxCRESDH0X3j5O1lq8aIJckh/gWnDkui7d5J0/5b2k50oII7uh6Ek0Zi/ymBeVuau1SjJbfSpHYm6PKPQAbTpnF2SBHs1RQMSfgPKp6g/kUqzWB4q2w1nwMHxCuDklK+a7PIW7sMj4ESlqXlT6lD50tzIQ++Hi5wV/G3iPS10zLMU3hoYCIDGSRMwQw0Wfh47ioFJiAOpvrXvFNYQPQJzQQi6v1g8H+oFaDtlzxW2rnGRGsC+Zu5DZF0AD8RQjk8zVT7iW9ak6DzsH8QbQbSo9KDBt+SkZpKTd+1O5mCyUAag1GLyjYk4zIqzEPdjfZPMNDRgCQuJndQZDrnzUqIzz6TFhZ7SKIbFOYNu/HKH6p9wTvDQKvR4hTisD2mI
 Re7efB+z
 QPVS6Qywzq8REYtFpdBpIeZlNnSgSMZ7YOij0/n7v1bcTo07WjMJgKc0vRApvi37Oto0Tpyq2pxz18FSjeAIGwjXjL4gs1q//vB2fv/NGq+NTaLUz6R2dbRjfuLq9LNe4Wktnf/nwBVYu+QyJK6VIvDd55BOsyFi3IBBCvJX9+6H7awD40XI3kezYLPrLNiMS2oi5tvG+vkNS6PEhTawFZR79bzsxs78bBSJG0D74Tgrc856Bb/CX45jdJ74gIf+1h62tq0AooHf5+s+NWHsPtS21R4Ug7I0VdgihZTe7MB5aMoSeKewWkHfUz//nP/F4qk/hTgt+eH6J+UmhoVDwGVVsmnsOK5mW4a6Xme7CJJE2otCed+h8NKGX1vZvaP8E317pDb+TAdnpEKT9SYQLiP797K6rmPI/BF088DClw0vyz7SwCAm+AlrQl7aak8prmE3NFmY/R9Io/DuqHYHh1tubeRB0dkAQfwhOgFUshMzoLAsEDZvn7lar0SrvXLwM9Uy4xMRDfEcUO0KfQ9TkgYyy0Gjza4qE1S8NWoKyU2BiZPlJg0mibNbkjvmmeReV3wmAirI4Jlog07s2mMEPTk5TH0YwEGIBtG2kmAxUWKrQt/0=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

The order check and fallback loop is updating the index value on
every loop, this will cause the index to be aligned by a larger
value while the loop shrinks the order.

This may result in inserting and returning a folio of the wrong index
and cause data corruption with some userspace workloads [1].

Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5d ("mm: shmem: add mTHP support for anonymous shmem")
Signed-off-by: Kairui Song <kasong@tencent.com>
---

Changes from V1:
- Link to V1: https://lore.kernel.org/linux-mm/20251021190436.81682-1-ryncsn@gmail.com/
- Remove unnecessary cleanup and simplify the commit message.

 mm/shmem.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/mm/shmem.c b/mm/shmem.c
index b50ce7dbc84a..7559773ebb30 100644
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1895,10 +1895,11 @@ static struct folio *shmem_alloc_and_add_folio(struct vm_fault *vmf,
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
 			pages = 1UL << order;
-			index = round_down(index, pages);
-			folio = shmem_alloc_folio(gfp, order, info, index);
-			if (folio)
+			folio = shmem_alloc_folio(gfp, order, info, round_down(index, pages));
+			if (folio) {
+				index = round_down(index, pages);
 				goto allocated;
+			}
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);
-- 
2.51.0


