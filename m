Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 583EACA101F
	for <linux-mm@archiver.kernel.org>; Wed, 10 Sep 2025 16:08:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id B41538E0026; Wed, 10 Sep 2025 12:08:54 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AF1A98E0005; Wed, 10 Sep 2025 12:08:54 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 9B8B98E0026; Wed, 10 Sep 2025 12:08:54 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 835678E0005
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 12:08:54 -0400 (EDT)
Received: from smtpin03.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4DD29135D9B
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:08:54 +0000 (UTC)
X-FDA: 83873824188.03.DB8951A
Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	by imf09.hostedemail.com (Postfix) with ESMTP id 61F09140011
	for <linux-mm@kvack.org>; Wed, 10 Sep 2025 16:08:52 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G9lErkdm;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757520532;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+iG/DaIyXWsx1WWZmoqNKoMlpLoSTABw5yoCvRsMNiQ=;
	b=kVWbNDgchsxmsxF0rObJtbmBYLiqXBLey91omwWp6lJXBDFQxlO1a32qT6tfqI4gk3enqX
	Mov9LeoDahY4EByYnadHpL1ObBS5dqNas4HChXL9TqTC90GjGDCmwUtnniK4F+lX4Tah7f
	Qd9JA1nQIav9SYugS3iw5/tYbzdDWJI=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=G9lErkdm;
	spf=pass (imf09.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.210.169 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757520532; a=rsa-sha256;
	cv=none;
	b=ZyNtjhD7XDubDbD1eIs9x/IFp1G9hQoRS8XUKBCe9goA4jx2Y5P1BxhSKnN/P3+WRFknyq
	FYgh/qx+U/IK5wMr6sEusknJ6QYS53SgScD8ajuf/wG7+IWDqOWgPeBakriLtSoHzmM7kB
	THajJsk+pKZufYYAPv48xG5rwts16ak=
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-76e2ea933b7so868372b3a.1
        for <linux-mm@kvack.org>; Wed, 10 Sep 2025 09:08:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757520531; x=1758125331; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=+iG/DaIyXWsx1WWZmoqNKoMlpLoSTABw5yoCvRsMNiQ=;
        b=G9lErkdmmga0jMYLkOfiuOMvVM/Qs+b0E3rkknFRhXRbgoRMnmHkNZLo0cmaozvAa9
         6PHDOXZWwXldGZMza0u6QLQI05VF3DJ1eRkc6SN1fJU1NmGlgOgRUYsL3I/UD/KI9ZCx
         9EWAIclxouHuzKE2bjNusZdQ1eHx12sJ+0kcsPM6XHZX8Eci8rJOUlMwgYZnZmzr1Nu7
         thbSHL39WCLe+2RQarNT179XeVTqx6eDjb/bwTSsyVQmgmN8qrySLyI0DOsp8rwoe37R
         mhAvfR/kPrLX+ySVEjbNGbBmBHmQjbOV2TiXeBg/A+SfR0trAsPdzChC+qMAp505UnOz
         VpSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757520531; x=1758125331;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+iG/DaIyXWsx1WWZmoqNKoMlpLoSTABw5yoCvRsMNiQ=;
        b=OYiiiIXh/GwyfbT1qKRd4yr6Hl1UVjbiT1NhB09eq/s6GFI35yemAIwjw9etLK70oN
         C8GMunSQpsZ/wVYwK9CZiRSskyKbuan9YPnxAV1FH12kp/uOCKuAtWkzG0xt6g9f9cjU
         y1vPWXoLfapsCQK9K/r3fAVQJsZBG7/S/4wun9ymKPDoNAYxEfdDgXQaTDQg4r3jw8NI
         KLc2qlZyuoAXuNfXuouRtP93HAaYU92Ub8WJ9myLyfJVuMTXlWd6b8cUEOIo9qMxX6v7
         Zfbs8udrGyJILDmvkbuUut3pV+7iAN3/3ulSnwfknohlPvRZZ4pvVTqP12CPKn3untQF
         vckw==
X-Gm-Message-State: AOJu0Yw2ev90Zd6ayg1SgdWl7pjqms6nsMADIEPRp2p7IFCEgzYVAryL
	Jh3JO4IM/UfL8TfWIEnJGAzlVqLi41UAo7khQZfrtak9UaVn2Z/8DxTOagBc1dP1KtM=
X-Gm-Gg: ASbGncvXCnQ92+3L6DBbKAz1xravvHTp1Ez3N1yNOht0LWGgAU2OwgKzzSwPTdK6ENj
	W71za8nyTn7Yu+x9awJQYnC5GVSrTrEVbpNlqza1oCvW4MGuUIiENaGypk+unQKW38eOA8Pqh8k
	OEomwcFDWvvvlJxRPi1+bknstHh+9a4f3wD9SZEP6olv0OdjFjwmS41r83aCPnCr8R+m172YU59
	mG1aHN1vBEIbyo//Ca3bANq1r0rwCjhD6oyrCodUUAurilgGdIa2UD36ovHT0dyAtjiFDLjrseZ
	oZO2Cr8t/zgWfaXoYJVBk2M+6aLEGCu+Hbl5VxP04WbnuWZh6viUaqrd6Wj5Q2ACY7+O2iP/GQA
	NrRbFbMsocneGlBL7NHAkobSsCswBcBT2WAk10SSj0RtCbl8=
X-Google-Smtp-Source: AGHT+IHGtESNtbI/xZsyuKB3DJLeJiycjaitn//SnhhsXY3KbjYMDyPR0k+gvTRPXGFd9JgFnAJd4g==
X-Received: by 2002:a05:6a20:258e:b0:243:d3d3:61d4 with SMTP id adf61e73a8af0-25cf6c38869mr168609637.16.1757520530570;
        Wed, 10 Sep 2025 09:08:50 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b54998a1068sm1000142a12.31.2025.09.10.09.08.45
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Wed, 10 Sep 2025 09:08:50 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Kairui Song <ryncsn@gmail.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Matthew Wilcox <willy@infradead.org>,
	Hugh Dickins <hughd@google.com>,
	Chris Li <chrisl@kernel.org>,
	Barry Song <baohua@kernel.org>,
	Baoquan He <bhe@redhat.com>,
	Nhat Pham <nphamcs@gmail.com>,
	Kemeng Shi <shikemeng@huaweicloud.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Ying Huang <ying.huang@linux.alibaba.com>,
	Johannes Weiner <hannes@cmpxchg.org>,
	David Hildenbrand <david@redhat.com>,
	Yosry Ahmed <yosryahmed@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Zi Yan <ziy@nvidia.com>,
	linux-kernel@vger.kernel.org,
	Kairui Song <kasong@tencent.com>
Subject: [PATCH v3 01/15] docs/mm: add document for swap table
Date: Thu, 11 Sep 2025 00:08:19 +0800
Message-ID: <20250910160833.3464-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250910160833.3464-1-ryncsn@gmail.com>
References: <20250910160833.3464-1-ryncsn@gmail.com>
Reply-To: Kairui Song <ryncsn@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 61F09140011
X-Rspamd-Server: rspam05
X-Stat-Signature: acc5mqnr3hf5aexqy34izi9trx7c458r
X-Rspam-User: 
X-HE-Tag: 1757520532-162290
X-HE-Meta: U2FsdGVkX19Dmz4W7pq7KovRaGrxa7MuhXdyK0n3cI8LCtkZiFIp+Y2XHAd0QeF0ByeGvr3bY1FttkJdtZw2dO4weBMzZUWO4ajRmkf2tcPwH0Zj50QmrMkpPiRcABnmSkGxXUuICY1tk9uVbLkDsk4Y6LF6c8bfOCHX7KJyeSlEYkZev7yxsnhmXfe0XOocmajX1TcDxR7oPQDBE2iImds/ytV6yy4NBUHGGR0Nsk/Xo7QbPlAvsX8mVIwbP4EW2HxjPrJto+TGYxOwScte/08JGH8WV1i7fv0v1sV3jOPnpFNWupIcwiola9s8yVS3m8R1imlbHHDolbeNf1w0IRsM4MXksF8nlpFXKD4/cnanu7dyNAaYRmDKumGUy27hGqK9/vlaQq7kGAhcCr2/nrdMQCreMsnFpFGA3X0Nwp1l0JTYi/mbCR3eLaWlVU5QJDhCXX+iYTe6d78x9Ut3vbmdya7R/xY2rWdYYWk3JqcG7c/O0GsonWbxntn2ZLyh1/tHaDhWAmd5YxvLG2Cn0k7CMqFKO8PxZeK2VzZRgPEvkEB2ToazEOK0uxGv9vloKTgNQ21pQKjiW2S4jyj/TdJGrJapOXofTMlQtJo3TXLo0VCWHIrNGbhBYBj+CE0Y4eTwKu4SNTcT/JeKLM37TPsoCTkGBsYHG6k7DDP/YsY7O/+QqGZLh3xUxZIFza5FIamWh4y6oMbs3daNAr4HEn5Gb4XzgGa11MFM0CfabbHgtkZmBrr8XNHaoHGAfTxLuk7bmeJp3BTMBzU9Eiv4JWcQSSkpQ5bQTRq8y5/t0smNomRE/vfBJTbm0wi4BJf64K9jqK8AreiYQRb0mzjMV/XcLIhtqcCC3QSVWwkvVyIEir8bdY24LPfLGQDey6T5XY6l3k8axUHbVcwrorPJbl7ZiMVYigshFq1j1kohubXxa6DNUVQYNu/ufw8+jAvATFt4xn6v+tgfVRLgS3O
 FdwGdFUP
 Tayn7SttIoZx86WrZBEAHkSQ2H8vnPbCJBb3T8Arr7bD1TiwNq4+8mwZuvLu3a8/PydI4yZiqP9dC1VW1EvVoYNHpXmCLrGl5vcLI1+aPef9wcN+LJ1vIhIIzNXQo2BS2CBbooDTkH1zVyddpeTYcb0uYSbAQ+lYL+Cnw+iDdiIvdNxnSUyNfMYDG6GtDIburkXAYuLSfPBYyVCVS8s1LTjtMmafI8Htodq6HudzsfKd90n5i5rRK4jt1B0j69pVLtohoE81w7jmvyovVdYPIltq6xhhZItqSwh2RB4rTkxRxm7TZgCgf5mfeRxCZQJ+zAOpfE93sniVg6gix3rmQKwXj5dWeloq4ljkEq1A2iBnIZrywSAt7nrM6pehfBZsr6NlyFSBCuMPkNdLCUhFOIOtXie0FZQdb1Hm2hB6Lwcfq3tP/Cv5aynD5KE41CmRFFcjsW7x7zzZ95mQZCk0cEo1NIqj8jpSD1zDzcZC0MMfh60xRn+jf0EiP6YlXOh4rlO4gKS7fzQuFJOBZfkfIqa2IwuuhKQXiwF3YzIUG8Lp3St8Dps8iQQQNeGQBqDYUH5cCSs9EQHxFL28jyxar1OYqinUv4IiT1uN1
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kairui Song <kasong@tencent.com>

From: Chris Li <chrisl@kernel.org>

Swap table is the new swap cache.

Signed-off-by: Chris Li <chrisl@kernel.org>
Signed-off-by: Kairui Song <kasong@tencent.com>
---
 Documentation/mm/index.rst      |  1 +
 Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
 MAINTAINERS                     |  1 +
 3 files changed, 74 insertions(+)
 create mode 100644 Documentation/mm/swap-table.rst

diff --git a/Documentation/mm/index.rst b/Documentation/mm/index.rst
index fb45acba16ac..828ad9b019b3 100644
--- a/Documentation/mm/index.rst
+++ b/Documentation/mm/index.rst
@@ -57,6 +57,7 @@ documentation, or deleted if it has served its purpose.
    page_table_check
    remap_file_pages
    split_page_table_lock
+   swap-table
    transhuge
    unevictable-lru
    vmalloced-kernel-stacks
diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-table.rst
new file mode 100644
index 000000000000..acae6ceb4f7b
--- /dev/null
+++ b/Documentation/mm/swap-table.rst
@@ -0,0 +1,72 @@
+.. SPDX-License-Identifier: GPL-2.0
+
+:Author: Chris Li <chrisl@kernel.org>, Kairui Song <kasong@tencent.com>
+
+==========
+Swap Table
+==========
+
+Swap table implements swap cache as a per-cluster swap cache value array.
+
+Swap Entry
+----------
+
+A swap entry contains the information required to serve the anonymous page
+fault.
+
+Swap entry is encoded as two parts: swap type and swap offset.
+
+The swap type indicates which swap device to use.
+The swap offset is the offset of the swap file to read the page data from.
+
+Swap Cache
+----------
+
+Swap cache is a map to look up folios using swap entry as the key. The result
+value can have three possible types depending on which stage of this swap entry
+was in.
+
+1. NULL: This swap entry is not used.
+
+2. folio: A folio has been allocated and bound to this swap entry. This is
+   the transient state of swap out or swap in. The folio data can be in
+   the folio or swap file, or both.
+
+3. shadow: The shadow contains the working set information of the swapped
+   out folio. This is the normal state for a swapped out page.
+
+Swap Table Internals
+--------------------
+
+The previous swap cache is implemented by XArray. The XArray is a tree
+structure. Each lookup will go through multiple nodes. Can we do better?
+
+Notice that most of the time when we look up the swap cache, we are either
+in a swap in or swap out path. We should already have the swap cluster,
+which contains the swap entry.
+
+If we have a per-cluster array to store swap cache value in the cluster.
+Swap cache lookup within the cluster can be a very simple array lookup.
+
+We give such a per-cluster swap cache value array a name: the swap table.
+
+Each swap cluster contains 512 entries, so a swap table stores one cluster
+worth of swap cache values, which is exactly one page. This is not
+coincidental because the cluster size is determined by the huge page size.
+The swap table is holding an array of pointers. The pointer has the same
+size as the PTE. The size of the swap table should match to the second
+last level of the page table page, exactly one page.
+
+With swap table, swap cache lookup can achieve great locality, simpler,
+and faster.
+
+Locking
+-------
+
+Swap table modification requires taking the cluster lock. If a folio
+is being added to or removed from the swap table, the folio must be
+locked prior to the cluster lock. After adding or removing is done, the
+folio shall be unlocked.
+
+Swap table lookup is protected by RCU and atomic read. If the lookup
+returns a folio, the user must lock the folio before use.
diff --git a/MAINTAINERS b/MAINTAINERS
index 68d29f0220fc..3d113bfc3c82 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16225,6 +16225,7 @@ R:	Barry Song <baohua@kernel.org>
 R:	Chris Li <chrisl@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
-- 
2.51.0


