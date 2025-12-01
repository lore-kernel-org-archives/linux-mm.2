Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 66D66D116F1
	for <linux-mm@archiver.kernel.org>; Mon,  1 Dec 2025 09:37:55 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id BA73E6B009B; Mon,  1 Dec 2025 04:37:54 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B7E7A6B009D; Mon,  1 Dec 2025 04:37:54 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ABB796B009E; Mon,  1 Dec 2025 04:37:54 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 9C33C6B009B
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 04:37:54 -0500 (EST)
Received: from smtpin29.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 5A56B1608B0
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:37:54 +0000 (UTC)
X-FDA: 84170400468.29.5ADB619
Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	by imf03.hostedemail.com (Postfix) with ESMTP id 971BC2000C
	for <linux-mm@kvack.org>; Mon,  1 Dec 2025 09:37:52 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iDu/OwXs";
	spf=pass (imf03.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1764581872;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=ZmBZg/AspfJwMWAbHxQpw6xsi94+/nXp0+CAmFuqGK0=;
	b=yUg1EvHiwp9zJOWuQopVZ2wTwVSa4UUKN9IZGMj60UDevz/xReJPgjui1344hU2+u/wfr3
	PfKXjJd6Dyo83rtNWi4K/k7wXPDHQrBxQDDTXedPfDVf3KTfI1S0xibuiCaWQqfS7L5n44
	SpnL7cd+AlgKaBaY85LpMBeGrBSno98=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="iDu/OwXs";
	spf=pass (imf03.hostedemail.com: domain of kartikey406@gmail.com designates 209.85.216.52 as permitted sender) smtp.mailfrom=kartikey406@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1764581872; a=rsa-sha256;
	cv=none;
	b=7WaWOhKqiZf/G123BblrsP2W8S/C1SpyvfMKLnXDa70gx36FHfSCkmqHzqTJbSU1CEzL8o
	6pXP9JeAWd5RjbzumCCY+WTUA78ufROTpTuiH2+AGifq/UyZfieTXFewc48F0Aec2AdppN
	r67cgXLB9+F6+it3qPl+KncH0Dd3vEg=
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-340e525487eso3238892a91.3
        for <linux-mm@kvack.org>; Mon, 01 Dec 2025 01:37:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1764581871; x=1765186671; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZmBZg/AspfJwMWAbHxQpw6xsi94+/nXp0+CAmFuqGK0=;
        b=iDu/OwXsQfrTX9DuSIlLYRHwkVRIaJa5B3YRhhH0EWTgPz7SdeV3XewVFvTCh+6F36
         3AC330alDGmOcAx8Dl6f2SvlDdAvFkXJ9fgBYT21IOAwRCWN2rmtPngcO/CXBOdh+3EU
         +hQY0liOnrKIdsCH1ue/HVZeqzYB/Jo5npRuxMWqrcBFSvi3lw4aMa92LPtLXX9F9vIh
         94PigCWRqK7lTRXtGfbWMj0B3LjS6vuBbRT3UVAE4SfkgV5OYTOOINXEZ3Gu0hbuHPt0
         oxo8iEXmQH3t5wtAOE7FbkzAp8b78rgUeljTsRZ+7zl2qGSAyPRZ7hC2qIK9wcT6MA8I
         V8qg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764581871; x=1765186671;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZmBZg/AspfJwMWAbHxQpw6xsi94+/nXp0+CAmFuqGK0=;
        b=fzHf+RufY8dpusC1gNP9yQAywGBmIt/WpYs+boAq1AVNHvjMN12CCxJpMk/isZoD2g
         awcdPWyeMF232zSz7YO3G4oRiZo07Pg8eHtYBeF7GQ+KXfX/7Jt9AQG48lhKcz4jIFjD
         47Fbqn9h4m5wB50fr5Wyd0xPvyP34d6lc8Izbiu75N0OjMa6Tc9c0BAdSNAppTZm/DdY
         c5drUx9K6CiVLZ/dDhvP6qaVwt/BBm9obFYl6Q3gUd1A6tkQV/aTb3uVrEkTUbTau/qH
         vXsxKuFrejbsuEibPqmx9dX1kkaB7TbTXWPeA32XmblFOOC7MmXLmvL0wp7LR3+Mp8Q3
         5Krg==
X-Gm-Message-State: AOJu0YxOeUtpNkbriTlLNRQWweIme2xIiIXmoxNHHC+jFQ01VMkLCgA6
	PjF479jFTLSZ2vE4NPJp48L7LxvALNOQfoNXu3CGXxqLCZE0I4DLKlsk
X-Gm-Gg: ASbGncu4IlX6dK0ZF60oqe8iVBClniY7T/S7ElBR04VDLY/znnlftx402fzIrjz/njp
	bthAMt6imND49k6PuspCFf6emIIFFgCTgNFoxKp2eyUDCawwRxMJy/5cRo9TaVhcr1r6+JV57p7
	ueLviR63n73lLOMV+md0G88M88EGE3jpd1DIprMA+jV5Iy3ld/i7aaXJQdsIKnkmbsJlUdwrOy8
	3n5WG91q+nPFMTObWzTbnQRkl2IBQ8AulBYRkj7cu5/WEy8rEM03ZFY1yfOj+qO9nixfvQFIPgt
	kPtnrCzAuOpwAo0on781exc4hpkii6qta0CCYTt0JmDgPeF3CDBjtPK0HXtFQBpND+yS8LiCfep
	elzbIdFwwSa2KP77tJhp/CeMKamTDnlOrL/AZRc/6WRCzMTC6vGtNr68SL9h9nRuz32jk0Jnox8
	sqkEBxGAIhiv7/Ws8887ZWS9rinsp0bekkkU0=
X-Google-Smtp-Source: AGHT+IFf85uva3wpenRB3RxU/SNOc74eGJ+nNFpIeeLMOSNaFOcoROiKut/1RQOxS8DLJPCUktgPbQ==
X-Received: by 2002:a17:90b:2dc4:b0:340:f05a:3ecb with SMTP id 98e67ed59e1d1-34733f3f1cbmr35208363a91.28.1764581871380;
        Mon, 01 Dec 2025 01:37:51 -0800 (PST)
Received: from deepanshu-kernel-hacker.. ([2405:201:682f:389d:9368:c4de:5396:f915])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-3476a5603bdsm16502947a91.8.2025.12.01.01.37.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 01 Dec 2025 01:37:50 -0800 (PST)
From: Deepanshu Kartikey <kartikey406@gmail.com>
To: akpm@linux-foundation.org,
	chrisl@kernel.org,
	kasong@tencent.com,
	shikemeng@huaweicloud.com,
	nphamcs@gmail.com,
	bhe@redhat.com,
	baohua@kernel.org
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Subject: [PATCH] mm/swapfile: validate swap offset in unuse_pte_range()
Date: Mon,  1 Dec 2025 15:07:41 +0530
Message-ID: <20251201093741.730884-1-kartikey406@gmail.com>
X-Mailer: git-send-email 2.43.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dd6fu1syhki7ap64pc11zkkafft6fy76
X-Rspam-User: 
X-Rspamd-Queue-Id: 971BC2000C
X-Rspamd-Server: rspam09
X-HE-Tag: 1764581872-155376
X-HE-Meta: U2FsdGVkX1/bamirIVyb05etqLEhbpV/KIJJZdjpVGr7ZVm2pZHi+KHKNg5xlNu414+rtmaCKiKRd+eV9Ny2uFbwDu3oRC8T/71VSpEyvwqM1goAEBU+CPKv9hHWTEmHF9BHVEn5hy1ttG8QTtLX5om/MDSoq5AxxFg8C4WdX/+Ysd5ZYDEpNrzGaWesCIbjWouimcAjiUomayJ20L2TM3SHtttZmuaI9NDX8ixRg0MrRXIi3vFV19mdSy97kBtCW5iET8voHxxcZGbcqNN3G9knjgxXT6qIIYntYBZ3B8eNaXZ4qGN0pQpSKYa/L5nVGgaqXVU4i27WC+m3KyG6jutV/+uYe1DNogctBrfpm73Lv4M6FG259PCM+aBOO7wSQ1KumQS4CZ+O1Z3/WMcMGJyY9zBK/6CP+fkx5lTC9Fkj0YW9HdmQ+dZ6ka+wPJRTgJhWX3PnYV58w0SJFjluvoUMScwTWOy03lrt917ObV7bvVqfDhKdT9GKMha9iqkyJ4V89n1+kJwcBSlRf3OnOqK7t9a6hf3/9vzoErX7I7LGW7CYv6BoLPRvM9PUe63lAfmJsCPk0g+h37QUpVxnYZ50roOsFPFr7tQ4NhAC3sfj16nmEI9cOVLlLX19xaL1skOR3wdI2E5ZdlJTNFmdhLt+zgQerq2iH89oF59/WrZMFOXgVVnDMk1u6KyqzIwKUxshTe7mAoD0a9p2U5Q9vEfBxBpMV5VXi1Aux8S9uJ1YnA91fVxtALeDkutmOKkJMxcgATNH7QsQpuYo1spAxyBz+0LjIhGiG8+rlK6b6yliX11GUwPi/RyFw6IJ9OhusVKrLk6Uc66YpgDix9dNLJ3SUb64Em5+LpeCVkTT/RSAcrsBpo1mUQ+xO+Wf4h3XldNRwzkyiO1jeZwO+FgsejlCNm+xfPLdZhwPpyW/k31Q0M2Kztb5Ivlv9cIL9Rk1hJImLxwxpDV4NPYhTgg
 +zBSb9zV
 gmYVLFrYvQhF6MACyyiQhwc8HxXujPza69Xw6XUNiOoLf9XUpmUQWYD20RrM/3qZWqDd7+rZsknSVgO9xqrOGO7NMh2WXUX9MkvdifKRXqQNbqO5+cWoctdl4DQpQ6paBLXDFBn5mnUHCB04czB+qDjyMVlDIVPdHRV7yIRp5YYSuwtd72CyTqtq3ONHaIy9ZE/Oxp8shFwuD5v/sZPhbX3xi1Z7QgF6uUE/kISWv3JK3RDrSAWJkt/utkU0ZiEJAFTMWDYiYIAs3gG7H5L+eoG28IKLA4nfYTNZK24TwUVTkW2eUcRM3/7AhdDavarp4Zu962hUVYm/qPs6Ip3ple7kcUwqk0XTEwH/mmNqDG9Lhx6keX+T3SS9xn9R1DsGh9rPMzg2Dd/8YMmPW3acZjWn/PskDq1K4h7siRcY72G+QTry/FyT5klVpww+CG/39cq3CymgykZVS/8DT+BPsSw+dS6cRTqSkXcNhJJH8ORgHtlcbzc4nGZz8OVsf4oyubYlYUQnSrlfXBQjKRzh1uDJa7G7vBtkTJUOQm2YQECKbetGVcJXpcfEW5+wZ7Amqpbg2q2OAmg8U/CJMqwd+aYt6w8879sx19iL2L0QyYeHaStFxzKQKfVqrzZh/Q9iHxTND5rGWcSsIKUen7NkAjbKvwvOnVnxSHcXuT3wN/sPZYIAqnDxgnJRvqWFHXt2DXXTuVJvU1hhtTqI=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

syzbot reported a WARNING in __swap_offset_to_cluster() triggered by
an invalid swap offset during swapoff:

  WARNING: CPU: 0 PID: 9861 at mm/swap.h:87 swap_cache_get_folio+0x186/0x200

The issue occurs because unuse_pte_range() extracts a swap entry from
a PTE and uses the offset without validating it is within bounds of
the swap area.

While the existing swp_type() check filters entries for other swap
areas, it cannot catch cases where the type bits are valid but the
offset is corrupted or stale - for example, due to a race condition
during PTE updates or memory corruption.

Add validation to ensure offset < si->max before using the swap entry.

Reported-by: syzbot+d7bc9ec4a100437aa7a2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7bc9ec4a100437aa7a2
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
---
 mm/swapfile.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 46d2008e4b99..fdf358df7116 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2277,6 +2277,8 @@ static int unuse_pte_range(struct vm_area_struct *vma, pmd_t *pmd,
 			continue;
 
 		offset = swp_offset(entry);
+		if (offset >= si->max)
+			continue;
 		pte_unmap(pte);
 		pte = NULL;
 
-- 
2.43.0


