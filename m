Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id BC734CD4F3D
	for <linux-mm@archiver.kernel.org>; Wed, 20 May 2026 20:50:53 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 553D36B009B; Wed, 20 May 2026 16:50:44 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4B5E46B009D; Wed, 20 May 2026 16:50:44 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 37CCF6B009E; Wed, 20 May 2026 16:50:44 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 1B7256B009B
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:44 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id E1D061C1047
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:43 +0000 (UTC)
X-FDA: 84788991966.10.29BF630
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf19.hostedemail.com (Postfix) with ESMTP id 69D521A0009
	for <linux-mm@kvack.org>; Wed, 20 May 2026 20:50:41 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=B0T0AnEW;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1779310241;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=sToOR/Pf9Se6n6q9d83MywFIBvA3eA1y47gZuXeAAaE=;
	b=uBMpBHIBhj7P5GQWRZKveaYA4adhAZIskfOgVY5NbHbsQDKpPzBza4ShfWCZLXEPmLjTMj
	qp4URSJovokfSaDKcRiKfLqs7dteonwFdH+K7PGaXmkcjiHFet30iaTku1bjNDCXR+Fb9L
	6Kh7bC8YpQ8LrQRRyC3s0xaqCkfoCRQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1779310241; a=rsa-sha256;
	cv=none;
	b=FRYQwDM8JD59+3yOq1Aud99jShBnKmXt+RcoS+0N8DsHrZSnejG02CFDaTXVPG4xL5zjFG
	NF8wWgHwsavyFFYzIHpvvUEcL0JLVYIqWcNvTLSMWdBhxgRz4cgJsnL9nGCGLwjpWhlUxm
	57zpJuMEyZ8YpF/0Ko/+wQT0PGnxums=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=B0T0AnEW;
	spf=pass (imf19.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167072.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 64KKO9bB2093952
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=sToO
	R/Pf9Se6n6q9d83MywFIBvA3eA1y47gZuXeAAaE=; b=B0T0AnEW8S1XAAxYRdDC
	Jd/njvke3xOxdIRYA722oTLR9w1rS83qi2Xp/XDadg2RZ+8QRAuRaruu3txhGiA3
	WcAY2ChK5Axkc6i1dUYeDzaiPGtTmG6btqv4svi1AzfXKUxyfoU5EodM0i5uGh23
	x2xzAkPIz87g6dPT0sjt9VI9w6jwiBO+VSPSwfPFtK9zKdtSPZ+yZ9vACywTq4JE
	YI48gAATuweguQyGWHYhDCRN2/puaW69TUVcCLHFylJ3q4EmA41rhDmy9uhUvA/M
	KwbYBh3TbT9t5d9IGqAdrbF3hRkt5T1kOdVsC2L5+Q0xHZz1vyoaL5P3LSXSqmpu
	4g==
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com [209.85.222.199])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4e9kja0c9y-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Wed, 20 May 2026 16:50:40 -0400 (EDT)
Received: by mail-qk1-f199.google.com with SMTP id af79cd13be357-90d175ae52bso1167898685a.0
        for <linux-mm@kvack.org>; Wed, 20 May 2026 13:50:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779310239; x=1779915039;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=sToOR/Pf9Se6n6q9d83MywFIBvA3eA1y47gZuXeAAaE=;
        b=YqmHCsOO9OMDZPbu74NdN1mnvgi89TpNYZeIPGKdzwA8uK+bRwY3KYH4PgBAZ7Ehmk
         R+/xGHBOh5vifkg4fOzqiGcoIqv7NI0TnMN18euekyzIDmc3oc76YKhk97eN/xbwA/ub
         QjxMNfONodDHz5VNoKCBnvNOi9HfRoPisFU4yCsckUexXy4oOrRamAN3jWLFAyVvmANx
         VKVg53l5J+ZGZO5YBBbuQ7rX8MDOaGo01sHby1Jx9kiZQhZJtgsHHd2WhvAnpkc+Ir4O
         2WLttqvSXrJedFF8Tux+Y2vuiHD/H2aKdkkCxoLaoSERKaaKw8glQFQ/R1kMVYY28Wmn
         nh0A==
X-Forwarded-Encrypted: i=1; AFNElJ/0Uie/ZTTs6MwpwE/k9ZoPg3Iin8takgrRxrDHD6AYL1bpuHYzX4Lox9J0OlSjO3xLSOgR+UcVTA==@kvack.org
X-Gm-Message-State: AOJu0YyGoTH9amWiDYNDHY2a1M0hXwarrLKGjlxxvxmh3Q6dmHbwqpgU
	nBo/SCUHpijWtYImhLF9lsGX4R0Ffh6vxkdT6T1tEMBPMXHeHIoSJH3PYzDwHx+7Rnd/dDrJOhw
	xis2Vx+RxJYAvv7rzZ00Q1UUD8brb8oSSHM3AilzJ6uAysFiP
X-Gm-Gg: Acq92OGDd/HkjONXRcsESePrztSWHOkB/LoWtk/m5IU04XlEsC5TI2Se9hbj6i88/hC
	AnBnexFht62fynmdjmsU/EWOtvLnX1L2Yxrk2bzUUREegFJLq1nPejfet756ooBGLCb9+nbyDhc
	KRwKEabLYJ+dpQnsKNPwxz4hBho9D9JY89seBe3sSFSTWO20ZxJAq94WNh369iry0cKT+o/3uzK
	gpUdEjBP9R10oovcK23PwAVV2Hdxa7w7qFhnq4FGlwfKOgRMo5/qFZ3/uceNZUGwwdXn+kIuLY0
	mnXk0O39mgwFnJ27hSv37okQB37YycjEJVIFPbS7gYd732eimWDShEeYPNn7b0N/6Hcf87hvu7q
	2vI8cjNzHtP4xvlWS9lsRBbqC/kPU8aPchJvOi/ZSIEL1VXIHBNi8CFOb2h66uKyENXs=
X-Received: by 2002:a05:620a:f15:b0:913:e19b:2f56 with SMTP id af79cd13be357-913e19b63d0mr2524458585a.10.1779310239187;
        Wed, 20 May 2026 13:50:39 -0700 (PDT)
X-Received: by 2002:a05:620a:f15:b0:913:e19b:2f56 with SMTP id af79cd13be357-913e19b63d0mr2524452485a.10.1779310238647;
        Wed, 20 May 2026 13:50:38 -0700 (PDT)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-910bcf37274sm2232692085a.37.2026.05.20.13.50.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2026 13:50:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Wed, 20 May 2026 16:48:58 -0400
Subject: [PATCH RFC 07/11] folio_wait: convert VM_BUG_ON_FOLIO() to
 VM_WARN_ON_ONCE_FOLIO()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260520-filemap-split-v1-7-c36ddc2b6cf2@columbia.edu>
References: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
In-Reply-To: <20260520-filemap-split-v1-0-c36ddc2b6cf2@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>, Jan Kara <jack@suse.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, io-uring@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1779310229; l=1934;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=jJu/raWzDXHDrGY3OmHYJ5IRBMbRwIJjRLBSVuVduxw=;
 b=aWk4flyPY3yiLsLPfjIZ128cQrOIzopXW9sJDfGsMadODQh9UbsXyooxIwmWJlV2xXqudRhGw
 BU3URuIRQ6lDLnXcm0mJlBPdMp+Mm+NXsFS8CdLq15K50p/AHbAIbje
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNTIwMDIwMyBTYWx0ZWRfXx4rX45xOf7FT
 dfDQQ3kXRyXwnbhgLn/C622vbY2JiLNX+Xs0ZBXuI2fpCnkaUFyVOP7taj6ot7eYfEy444i1roa
 iKR4CWkVZL+lV+vMLlIWLQ15WN23WeEsUUlrp9BcVW+popxsIbo0QbE58bU9gQLgNOonDmVGMwX
 yFmKpX7wYna0RwsWcFMATnRBNZU0QPNPtn0AOxx4CplIlzwdEU96vc6/9IZoWknfj5yNhLo80Jk
 kBrMQHu9dOvKsqUnMShDTHH/cpNDOo/j4+v7kKrGvFDHsteSK5JL2S6QMQylH42mNWLrZiklEl7
 F/O0YQk593E0CqpWerdY1xmoJKg65yyxF1gny1N0g6Xb88KxvvLrRz8MBSszV4FyBVAzTS/Okiv
 ru7vUh5y6PCI5z7MMz9rnNs5kuuXeSKBzWw9LHj/AAvvFCm0zIhOp34VlV+og/Ze5Fo7+YexEG6
 v49tk3+RGA3O2BbLc7w==
X-Authority-Analysis: v=2.4 cv=EeD4hvmC c=1 sm=1 tr=0 ts=6a0e1ea0 cx=c_pps
 a=HLyN3IcIa5EE8TELMZ618Q==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=NGcC8JguVDcA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=SsB-OO3BMngHh3ZO9fOt:22
 a=VwQbUJbxAAAA:8 a=M6LSvAv_FjuMSCFMCIwA:9 a=QEXdDO2ut3YA:10
 a=bTQJ7kPSJx9SKPbeHEYW:22
X-Proofpoint-ORIG-GUID: V2Hz7AGlAvNPXF4z8Q3FoWl14s5KOGBG
X-Proofpoint-GUID: V2Hz7AGlAvNPXF4z8Q3FoWl14s5KOGBG
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11792
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 spamscore=0 clxscore=1015 phishscore=0 malwarescore=0
 adultscore=0 priorityscore=1501 bulkscore=10 lowpriorityscore=10
 suspectscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2605130000
 definitions=main-2605200203
X-Rspam-User: 
X-Rspamd-Queue-Id: 69D521A0009
X-Stat-Signature: rwaifxs57z7i9mn55ph8ctnd5q8m7wx1
X-Rspamd-Server: rspam06
X-HE-Tag: 1779310241-281583
X-HE-Meta: U2FsdGVkX1/Z3QXGihaEgk9uTwmF+bRcD3GHg5m0OKGIovQLYU2k1GhgqNMAZAaFZsctDOlXixnJksWuj4e+IBlY45Q8whOnJwu5RxnIQhmA2Q1CLQKKB36aTWT+EzQUOVCrDhe7Poeuy7+9YnWIYNnYagpsWZ3yPT6ix4S+cziekREiLa6ZfJvOYYW0E8zZDY+FW08QcUVJZ1moo7x0IXZ6Qm++OGTBPiPJrON1E6DWTxiIPhX/kHzFcCTdtifNcCZS7yBK8+qDPpUWxGNbDra10+COwkWor9RMLcZz0L5sKylOfqclEstK9p2KduJ5ZHPD/WCprQlSo+0TqY9YDj7zTN6nxbM4VMmfr1BumnWut/8OUnEkpJAFYq4AgDWXlxG0xAgnoM096pNFN8pjjABuJWBBED4lHruK/K3z4A0mMb0cXOYLq0WHu3tD72eKYtwBmwg5+pmdgglfiePnQEWBp8MR7HrYo4rXrhNQnvu6NL/fX7cTakG6kjzrAMPy3YHTwlrqB2JpsNPwQxYVs8Vp57+Kwav8rqMceiT/968Q3dzCKCuBHbiSzjXGfbvIzUCZaX0CyzTPPCGltt4CQHTF3FIgxO7P4m+pa9Hmcz8+HVeDDA6+b+fmMDXcIKBqMkEyKeBPXcHlF1Rk1xJPunA92aySyCvE9D/Elvfpq7crEAtlF5h/jyh1AIzcpI2lFQPvB0zvxkqENJhDYlNSw4eKVe2pBFhGpzUwFvo3JbFTTb+h1aewGlwEDJmtDvbUj16WVNLWjRtjTTECESTcEXdBh+CPp/MRavDnkWhLqtd2usXt1oQ0XwwKBg3gAvVVPXINDhL/iZTGqEoJAEieaAbzwmMVCvob+DTMRy1T9gLdQ+S/Ln9r8uEgpMNrCTsDj9Li8cIgXahdK9dCRUvVpJeMtX5Yg4UQi8ju6CZlLAHYj7am6qW9uitegH9tBKuluvLmgGonZOBMUGNNdWg
 gPO1ucWI
 LV8TRNFButv+T7nq65f7o5iMsXmelIymJXPcZ7/Fm9whZQZLZn14Ns3xNZ18Du07ayXftUpRlj3AszjNBBrjeYirDGNa0UnuSrdb87/MsJ6LuCNtuqeHcuOVqH2uEe2iuFrTPfpzizZJPNAFO90C6tqhbThiLwpW0v5pJyaZ/RHqKhzLNZX/aFr2p2aphXydpJm+P0MsP4+ksONnLE9PwKqGf41FalrWd8HEGxJFRuMSTbKBpMcfXCvXjyCeu0RN1BdILCjV6dUkth9MGQ2puG2mV0km6VPR+GlQbu8nWygZqN2krTe66epRr+02T5Mfwd1aXnqpuToovFMxEihKQbbm9PZYX7yq6RFfz9I/zwfj5EX8ZuavRV1RxExZwDPvXGMk7un94Js2k2hjHoSHU8S/D7A97gn+M8fE5w3wviW+yPRA7GlertjdzYhTQvtBVW1MaLADP31ooSHy4KOfBjtYf79DaSc7+QS8NO4cbLQZFGurHt/lpc5uDQ4NrVfJuvb9t0JSoSB8+1CpnddyjPGto1DPJ2KLmv3zIb82HayDUELQhRXmI4hoEtA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

BUG_ON() is deprecated [1]. The VM_BUG_ON_FOLIO() assertions in
folio_unlock(), folio_end_read(), and folio_end_private_2() verify folio
state invariants and are already debug checks. There is no additional
benefit gained by crashing the system.

Convert them to VM_WARN_ON_ONCE_FOLIO(), as is now preferred for such
checks.

[1] https://www.kernel.org/doc/html/latest/process/coding-style.html#use-warn-rather-than-bug

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 mm/folio_wait.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/folio_wait.c b/mm/folio_wait.c
index 70f808729f9c..52d336bc7fe0 100644
--- a/mm/folio_wait.c
+++ b/mm/folio_wait.c
@@ -465,7 +465,7 @@ void folio_unlock(struct folio *folio)
 	/* Bit 7 allows x86 to check the byte's sign bit */
 	BUILD_BUG_ON(PG_waiters != 7);
 	BUILD_BUG_ON(PG_locked > 7);
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
 	if (folio_xor_flags_has_waiters(folio, 1 << PG_locked))
 		folio_wake_bit(folio, PG_locked);
 }
@@ -490,8 +490,8 @@ void folio_end_read(struct folio *folio, bool success)
 
 	/* Must be in bottom byte for x86 to work */
 	BUILD_BUG_ON(PG_uptodate > 7);
-	VM_BUG_ON_FOLIO(!folio_test_locked(folio), folio);
-	VM_BUG_ON_FOLIO(success && folio_test_uptodate(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_locked(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(success && folio_test_uptodate(folio), folio);
 
 	if (likely(success))
 		mask |= 1 << PG_uptodate;
@@ -513,7 +513,7 @@ EXPORT_SYMBOL(folio_end_read);
  */
 void folio_end_private_2(struct folio *folio)
 {
-	VM_BUG_ON_FOLIO(!folio_test_private_2(folio), folio);
+	VM_WARN_ON_ONCE_FOLIO(!folio_test_private_2(folio), folio);
 	clear_bit_unlock(PG_private_2, folio_flags(folio, 0));
 	folio_wake_bit(folio, PG_private_2);
 	folio_put(folio);

-- 
2.39.5


