Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 01290CA1017
	for <linux-mm@archiver.kernel.org>; Fri,  5 Sep 2025 19:14:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5E3C08E0012; Fri,  5 Sep 2025 15:14:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5BBD38E0001; Fri,  5 Sep 2025 15:14:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4F90E8E0012; Fri,  5 Sep 2025 15:14:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 426C48E0001
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 15:14:19 -0400 (EDT)
Received: from smtpin18.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DA8A31601A2
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:18 +0000 (UTC)
X-FDA: 83856147396.18.56E4D22
Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	by imf22.hostedemail.com (Postfix) with ESMTP id E28A7C000A
	for <linux-mm@kvack.org>; Fri,  5 Sep 2025 19:14:16 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eb6wafiM;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1757099656;
	h=from:from:sender:reply-to:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=mDUEHfmrXgAZbUz97jq88NraGjuVdKEjUr0PaaBBO7Q=;
	b=Y0QjqsE45Dm9o7SdlQ9fEKqoJ9Co4bbV8Hg3/z/acUi51CQ1B3CTn5iNQ6FbRVXsFwDzm9
	zFmiXfiuAYE7nGw+1KncKc9q1syxOOYXO37mtbToMs6cOdOO4Q2TNRGnkGOW2aeV1Zb3rd
	mDLf5Yc9PNXgUeo57AtIjmJ8DsUTapI=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=Eb6wafiM;
	spf=pass (imf22.hostedemail.com: domain of ryncsn@gmail.com designates 209.85.216.46 as permitted sender) smtp.mailfrom=ryncsn@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1757099657; a=rsa-sha256;
	cv=none;
	b=0kZ9D8juTqUt0f0xUvLX/VM3TXNTq/hyRUTNPw01Y75e67i6h1HlWFjHoaiiAumL+pA/se
	3Rayk3PGtsTHwt2UiqQVnqslThsI2xSldrO+QG4noXeIVR4gzSKno6LRnHKUewQ6ynrcJM
	O6OmS5rG0yqBp8PoEhn/T/V8fW3srU4=
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-32b863ed6b6so2058805a91.2
        for <linux-mm@kvack.org>; Fri, 05 Sep 2025 12:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1757099655; x=1757704455; darn=kvack.org;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to;
        bh=mDUEHfmrXgAZbUz97jq88NraGjuVdKEjUr0PaaBBO7Q=;
        b=Eb6wafiMjyctDM4ml2D6fBjSvlpKJaN0jqUhUAyrks0vqWOC1mMPbJSfIAkabl8BRt
         J2m4LPVJ2XEj+mgy3buLVUFH3mSpzwmSCEyEeN7JVspSkuOYDmGeEsMAKf5dPoEV1YJf
         4qfh5A+1ocfagYTEDiIFzlp5ytpmTmN5xqcjSrrBgOe20m3lvmxKn3LlyhTmf3bRng2b
         1cxlCVs1TsVccU65HxhQC655MSy1vvucLfACsy35bZsIZ/9Lqlse9pbRvP3qKfrIT04x
         6KS1ohenT9qOjYTM1KvgT7nxrz9RgeErZz4O4LnQQpJ5OMaHvxySK/9VkGsKdrgktkeA
         S0fQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757099655; x=1757704455;
        h=content-transfer-encoding:mime-version:reply-to:references
         :in-reply-to:message-id:date:subject:cc:to:from:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mDUEHfmrXgAZbUz97jq88NraGjuVdKEjUr0PaaBBO7Q=;
        b=CGRfGYwpc6IRondhjFHqq96hLdPR0LuFhTyUYwcRx2VE7Igzsd18WCFl/VepZaaXb9
         pO8tNpo3YvW/N8IDbgyoQWzN41KYly1IVzlIauvs9LXr8lvihIUHtm3SzjRo1uycXC1+
         BhD7o2FTc+17fMljjljC74062oS1eFU389qvpBHQ6y9Q0s0ItrY0jyZgxePxJC6OmXWO
         QlfgFzg4qVvvjrQq56j9FT6tJlHqQ3GtoLFmjrz1d7LINJgQANyf1I5Q+ElzL2EelkzA
         KiTzxfVIFcbZzgMgA7yejlh0OnkjagdMavLUbbt1oohguIFM6QDWep6Bc/qTN0+b+tcp
         kbqQ==
X-Gm-Message-State: AOJu0Yztckv4zi02r0/CQKEn4AA6Bb8QeGg5hikQu4SKSGNI4PwiFDkU
	bOKjfvloK8KYU6bB0spNKgoQkDOOEth7cTfi802TZxm4l1gIcEbZA0uc+IjhzjJDcZo=
X-Gm-Gg: ASbGncv29auOQToopzhEwoKKVeuag8vRFgDLqD14Py5tQf/SyqGIzBaiCfXzGdGjmiV
	8B1v9gTVgtlAuCKGvZ3coSBE1TpK7rLdNhIMeNLlrb+dKWbhPX9pu87ewxDoMZbEDfCDbQEq9LB
	QpbK+SlKtbSktyXn4J3kwPEyAltZrvn7CAbbZF2hZ4xskSjbFk0X+Y3qfZj+BXUP3664zgjxsH4
	hUtQHhChCWxen9EJPKL1VgPahgJnLBn6kTWs8vQOhSPAFwoqldXNTa8VXCJ7UD6yKiMH9Asmpxt
	Zac6QKPWocdVQshb8pOw+p0iMNFRvjBLRUaq54FkLq9YAO5pXZ3WwYyTxmG+k815Uk138Qrlk/W
	jdtEXRRnDd5he7tbFz2y7wEyRuU1oL4XLkgJUGNG2KfdUCwx9oanL/eof9w==
X-Google-Smtp-Source: AGHT+IFPaS/I+N/+xz/fo7KOHBQ+1G56h6y7Mrud0IexC4riD+dfbvjDQQ24r7ZekKYjTXvTtyxS7A==
X-Received: by 2002:a17:90a:c2c7:b0:32b:dbf1:31b7 with SMTP id 98e67ed59e1d1-32d43f03db6mr11645a91.2.1757099655135;
        Fri, 05 Sep 2025 12:14:15 -0700 (PDT)
Received: from KASONG-MC4.tencent.com ([101.32.222.185])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-77256a0f916sm15871442b3a.63.2025.09.05.12.14.10
        (version=TLS1_3 cipher=TLS_CHACHA20_POLY1305_SHA256 bits=256/256);
        Fri, 05 Sep 2025 12:14:14 -0700 (PDT)
From: Kairui Song <ryncsn@gmail.com>
To: linux-mm@kvack.org
Cc: Andrew Morton <akpm@linux-foundation.org>,
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
Subject: [PATCH v2 01/15] docs/mm: add document for swap table
Date: Sat,  6 Sep 2025 03:13:43 +0800
Message-ID: <20250905191357.78298-2-ryncsn@gmail.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250905191357.78298-1-ryncsn@gmail.com>
References: <20250905191357.78298-1-ryncsn@gmail.com>
Reply-To: Kairui Song <kasong@tencent.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: xny5ujnfe4myzx6xujo3ogut6e8egofx
X-Rspam-User: 
X-Rspamd-Queue-Id: E28A7C000A
X-Rspamd-Server: rspam01
X-HE-Tag: 1757099656-992084
X-HE-Meta: U2FsdGVkX18Cu4SsrqXgfeS+K7WDalhnXCwos+WMFXbLkVrOYaP+JEu3ySIdzDraea/xy9+4+HpdXe00VinbP6f2YtpiJKJYgErOTh5iLgK4COywnU+RSSy3W7AhFYDQNvXl8TcgTrfZ7yXnWvdfMjSnk29T3SwrT9X+8CB88hJJKtjq+VciDH31HwUI4NscgYOrW5jIHy6K1lsPPPvAF4b8uMA2TC2d+AEqu/0swZ6loxX65GlQKWXSldGwwr/5V28IN1uD3sW+OABJ26CO/tVPBawKlyBsHFbC4KNI6+5FhNicEadB48ZBbULZH2DucVdDPgcJilwxgsICg1ln2LK4PqhvyYE6GdotgSwtAfT0SOSa2+oKB54bS3umNl2zncKRGuMuElvjOxjyukjM9epkSTzBV4/Ycu4lIfUFfVLWjttWdSMkdxoSH5NdakWqariQlzX9yrvNId/VOLl72HJt+ON+mwaAWDyCNkv2sTBZUQ6lTyuwBrsZtrsH+VpVf2QbHzSHW5YKxP1da88V4hQiceaQO/iE4/7IAcFeNcvkNM15BWwynsDNmwyCse4JANPw0WeutdF8BFNYqKj8AOoTss8mXvU26mZlxNUpOk9kJbK1LtyovifRGQNenO2mUNB/tV05FYyY1b1SvOzcmHDhR6gn7fjem3jGzZWIfTAyF+tEN2k4O8gpy8r2i81fRBZ0OyeyXb3sOXDF9u/n+ohrRo1RX/UOrW4tyWQpVzMai3GU1TtUTcq6XYXIpcsWLJDZV7Z0b9JPmv7g3PfMW1PcUMm5MgITXFAb4zVsxcUbk9mE5SayAqlxM8QRVfn1YXJqOX/y3ZQ3+ZrmcueO24izdjy4t4sqgOg93umn528SxgNE4gQmMam/xnqtw+vHbE68SJxTTxdbSnzrwsIyVTT3CfEy4SVvToajBlW73Aj6rgncJ7Q9PrL2LIRJy/wXHlH38wS4nQOukBsE+Om
 HzgBq2rT
 ZbxBs3RQn2718M2uU/U71dxeasbJM3gi6TM9U9FOI8kwB6eftNHbwkNlNsD1QPHGfA/G1r89WTW/5sGFqBwu2q48egEp8QhJOnoMlhKoBlSNEfAlPygX0v/XLgFKWX5scAhL0SG+H082fArLowDItuiPtLJOCHx1j/UAmpQgkD//1FwbJhjXQb3okJ4tTGqNMH4yt6VE9DczkX1Bz00IFr00srMkCWcnknVR4EsvNlGfSBSeyi3V6AVInpxOpp1OBPB7AwyO/jVxeCQkoYBUg+uLhUW9xP4H80PvND8pT/vm04e9Zf4+m+vmfFNQwW3xwWY8ZyXVoYc+EDrEm5M+wUe3q1nliPQgaCI6keLJ7YvUb5tE6N68LqmTZYaaHpDWYdhgtSRuSXSBRHwLyWIZqqftKLZNf9IOWAuBsNrnEaOTOAc5XZMvDgYjMPzn6bASuQGOKjqz1jU6QJrwG29B0eTp82eVL+RLc3i5OsBZ1c/wMni2rC/JfEIh5bW7M664KgSixwFIJBm6obkiYF8KFXnrs0XKI+h9/nfTr4860K6Kz4qSQC+Lf4zALYYj3yFvskFKxdv5bSkceuihPRbhBnTn6Ih97vSWV6euE4rQZ9z7/Pt+5roybUzJvU5l6NAj0F9WJvUn8PHm12J9V9AsniraTIg==
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
 Documentation/mm/swap-table.rst | 72 +++++++++++++++++++++++++++++++++
 MAINTAINERS                     |  1 +
 2 files changed, 73 insertions(+)
 create mode 100644 Documentation/mm/swap-table.rst

diff --git a/Documentation/mm/swap-table.rst b/Documentation/mm/swap-table.rst
new file mode 100644
index 000000000000..929cd91aa984
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
+3. shadow: The shadow contains the working set information of the swap
+   outed folio. This is the normal state for a swap outed page.
+
+Swap Table
+----------
+
+The previous swap cache is implemented by XAray. The XArray is a tree
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
index ec19be6c9917..1c8292c0318d 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -16219,6 +16219,7 @@ R:	Barry Song <baohua@kernel.org>
 R:	Chris Li <chrisl@kernel.org>
 L:	linux-mm@kvack.org
 S:	Maintained
+F:	Documentation/mm/swap-table.rst
 F:	include/linux/swap.h
 F:	include/linux/swapfile.h
 F:	include/linux/swapops.h
-- 
2.51.0


