Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id DA4E3FEFB6F
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 16:41:33 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 303E56B0089; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2A4AE6B008A; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1A6996B008C; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 063A96B0089
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:33 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id A7419BAA41
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:41:32 +0000 (UTC)
X-FDA: 84490802424.06.6AE0EDC
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf28.hostedemail.com (Postfix) with ESMTP id 1D66DC000F
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 16:41:29 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PTddOnLl;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772210490;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=kqO9qkRdVrAKYYgOAexi6ZPIdSHNelQDaN7QKT4AcXo=;
	b=Z17ZBmLyp4w8BT2gucIEd22ZIsNOvTu882QDZyDtDutq2Q/gdUAYe2edC3rzo5BaHlNPRt
	uATBl27wNGUjLWvJLEXRFdgUOn7tQPQRqgobzHv8li4JRraClPWq+/xOMFzWm2lyTLqWfs
	nuMQtT+v2zfyDqO4jAf5fIhU3fGBcdA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772210490; a=rsa-sha256;
	cv=none;
	b=2gRYvskSQj75OwKevWMLTIlD9vHOGylvx26UmMq56UOFXc4daK+s5gX28AX0VR7xwLMJx6
	5kk7yaB1fPkHJddoCYpL9GGHc+1zGkkFvcnrhYL7fepXzS8V5jhLVGtvGLGmpuVzxTiHVO
	anUz6tK6PW66Tlvk3+5rLkzn3YE4PYo=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=PTddOnLl;
	spf=pass (imf28.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
Received: from pps.filterd (m0167070.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61RGNDDe1233790
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:29 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=kqO9
	qkRdVrAKYYgOAexi6ZPIdSHNelQDaN7QKT4AcXo=; b=PTddOnLlQSm+yYDiHtdN
	PTkRtJtY1GOXc7dzRBrSEut2qC0a5yoxWHLbFwBCXJNaXWQjRik3Q30/YoJAORs/
	tV8lysYFLlp1xdJdiQog0twPAOTDGBbUlCSYutNFCvkbYLj9+omnS2s47xac/ZPl
	XIUMao1s3jA2dOW9R0xlfNEVE0HSAJByDZZ/L5oHGO3KC69V0CGvYvveqjr6lcvA
	4uwVfEUMmU6zq2INQ6mjKFGjJJki+hAmHF6H6YzB1Ha9UXW9n0Mz4fbFHHg1LOWi
	bdKXXfabnIMKvxUYun8J0pi6dcYMwSKfMa7rBzNLgu5oGRom3FpR819asMlkhhyj
	Jw==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4cjwaydmuc-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 11:41:28 -0500 (EST)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-506549eb4b7so232199551cf.3
        for <linux-mm@kvack.org>; Fri, 27 Feb 2026 08:41:28 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772210488; x=1772815288;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to;
        bh=kqO9qkRdVrAKYYgOAexi6ZPIdSHNelQDaN7QKT4AcXo=;
        b=XR4+Bq+W73ee/Nt9TwVRuT3XWkLqz1Xec2JzZ6q/I3MH2pMGwH9dNN2j3gkVtZS92x
         0hIGTP831FNhCsSitGezF+SbYvDOgLxvisYq9bH2hNDP/L4ozIRzR1WONaIv2CBWN3hw
         CraTvdl8bpBx5IFy7QUMF29ZwiUoW8pLgvKHuhgR/j9lanxPtEml9elkIs+PaPpTL3A9
         MQy8ZlpnKSagmHfvirF4JZsomyP0uRmB6r+EnhwWBxuXWEzgQnQDM6oFF9ncKFUKS/du
         wEqqWmYjNQDwtE2TopMo2E5NVw9LRK1zdQD1wui9673/Rka62CoZ5pXB28/pm4DPopXE
         rPBQ==
X-Forwarded-Encrypted: i=1; AJvYcCXv6VgShLuO36xegfrGHOVkEgCoOMP8AoaAvNhXha+dlYkS3uOyafoEKomLnKt5WPLnE8T/3fn8FQ==@kvack.org
X-Gm-Message-State: AOJu0Yz39NdLSfTcJoUmYbP0ltG4KGdmgsNS/aC+MYRHcf1TPr1ZD94c
	rndJ411D8Uf2znSLAHutkp2nUb7wKMtH8ROjZZ70MBMIrcNiQwez4SU5ECg8Wbv7q3iDGo4qwFL
	MiEQy1rkz1fnLs7KfnbHUggTNusGCEO6i5mrwbQyJQt+OTf2a
X-Gm-Gg: ATEYQzw2jPeLEbxQBZGCzMp7FB1SlUmvj0iyNxfuxOKcW15d6lxhtgURb2zRoSAtn0I
	iD06a5EJwIYwV9JkT2K/r3DzWOriaxW60XXHdKEReMM3R0pda+GybK169k8GpHx/5S47PKuLyUn
	dB/HfQJ4yQp5Oj7f2HkDlsHbTcw/NOKdp67IpAdUXnTvYvSPcLzBrHfyeqt3Jcz7YxpO+sukZ1X
	JI1izYlieqelhIytBNX/rcM+sfNTkJ9DgR+j0vwmSCN6H2wvioAMMElughJ0mE/kLiqk7R2rgbU
	D2k+qVFtO9LTOiNAbXTn1biWw/wHWP3gmDH1eP4qVk9IvtbdDiRlakvH0I/aWjadXwE2gTAjzq/
	+tiWnxtSXeQYm5bJpTIyZfRbiot3x6wHXk2Z7elIL6fWDzIGqF2ET9HeBvferhyYtUbU=
X-Received: by 2002:ac8:584e:0:b0:506:1f48:9ffd with SMTP id d75a77b69052e-50752982c2cmr45010361cf.40.1772210487346;
        Fri, 27 Feb 2026 08:41:27 -0800 (PST)
X-Received: by 2002:ac8:584e:0:b0:506:1f48:9ffd with SMTP id d75a77b69052e-50752982c2cmr45009771cf.40.1772210486660;
        Fri, 27 Feb 2026 08:41:26 -0800 (PST)
Received: from [127.0.1.1] (dyn-160-39-33-242.dyn.columbia.edu. [160.39.33.242])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-899c716caebsm46535886d6.15.2026.02.27.08.41.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 27 Feb 2026 08:41:25 -0800 (PST)
From: Tal Zussman <tz2294@columbia.edu>
Date: Fri, 27 Feb 2026 11:41:07 -0500
Subject: [PATCH RFC v3 1/2] filemap: defer dropbehind invalidation from IRQ
 context
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260227-blk-dontcache-v3-1-cd309ccd5868@columbia.edu>
References: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
In-Reply-To: <20260227-blk-dontcache-v3-0-cd309ccd5868@columbia.edu>
To: "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>,
        Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
        "Liam R. Howlett" <Liam.Howlett@oracle.com>,
        Vlastimil Babka <vbabka@suse.cz>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Brendan Jackman <jackmanb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>, Zi Yan <ziy@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Cc: Christoph Hellwig <hch@infradead.org>, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1772210483; l=7573;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=RY/e80+/kZp0ndnWK8kJgTORmskriDz0+BRBasqpa+s=;
 b=5GcYGdmdWtXfKAIurXREVpzuab/QFgffaUCQqEN5lF8DAh34Uoemq2/kit/VagezIlDEV6Sb9
 UKFtKpmhpV5CPnT03p8sgafLGn7XkDEwTt1k4s69nfd83MAmaDzml1x
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Proofpoint-GUID: SFw61xlJBnqyLLOUqMmavYB3fiA5yV9X
X-Authority-Analysis: v=2.4 cv=d/z4CBjE c=1 sm=1 tr=0 ts=69a1c938 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=GaPK54s0Se3oFqK5NkZy0g==:17
 a=IkcTkHD0fZMA:10 a=HzLeVaNsDn8A:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=svvvyxlR1OQQkelhaPoB:22
 a=-hUk4XeFNW921M1lpgYA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-ORIG-GUID: SFw61xlJBnqyLLOUqMmavYB3fiA5yV9X
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjI3MDE0OCBTYWx0ZWRfX4HHJHBFU6zi3
 RRa8oZ4+AkF0YVGSppaqlCe6HAVMETcee1A0641W5vzuiJCjLT0ndBvgq51XosjyJC7P1kdbtv4
 1mTu/350UT39za3q00L9OVPTz23nsMcPwxdy0Huof8H7qwM3MwMaxbWeR4RaqqRxVsWsfZdi51/
 gW1qFLslAuBLetUaIv1iImAIBeGiNurlpS2AFRcq5uWU97/yIB0p69y14ZmIcLZNP0Bfsif1V1Y
 VhAxchqnWTcazKWrOBiA8fyupWexSwO5Bd1xeEQw0P/XwBp8vKK5gPj623tCKdbhTUPs6bUs3gq
 ukSdp2FJrGJ4PJl/oscZxW5hQEtGLkcZ1dh9KWeqf6y/A6goWoUiZWer3UWVG6+GoSXSoKdoX3Q
 rh/I/2kSFUEijFRenix0CwugPJ9Z8ENv9LP4gNJbSQOjx+x+zRJRqtcroqRWaVXj4EYAAChGsCN
 KInmhsNCsRJTiChzQRQ==
X-Proofpoint-Virus-Version: vendor=nai engine=6800 definitions=11714
 signatures=596818
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 impostorscore=10 malwarescore=0 suspectscore=0 bulkscore=10
 lowpriorityscore=10 priorityscore=1501 spamscore=0 adultscore=0 clxscore=1015
 phishscore=0 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2602130000
 definitions=main-2602270148
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: 1D66DC000F
X-Stat-Signature: akkjqipj57b5bno81ust7y86t7iu7w43
X-Rspam-User: 
X-HE-Tag: 1772210489-741720
X-HE-Meta: U2FsdGVkX1/XraA/oDCUZkWJqk3BKsjEyZTQ19svKVAwikBHF+3cOGVd3+1h7Hxm8yugnA9RI0yyJ9pp3Sl32aYd0yBYx7QHHOPBpkyQvpGILCnKZ/b4QTggW7d+Y1JH9ZaiJ4Y3B38DJ9qKZLfud5IPjO4nDgly2Whp9/22Oe3KE4qX48/j5uk3Fm257DlibKHw/buuztg92Sc3WHSdDJ+muCrmEQJ7NDakCxMzlrED2MPQm14XmO+N2FEWQ54+gdalEKqmMOA4M8nLyE+cPTEPBKd/NKDMgf1lCmeos9Ify+fUSa0WY5gwROpF4y4HStZnGLA3miEmVZqxpUx7xoRcffsSVsN3JSiBY/jqBUb2hbkBEfhdcGaZ00DKLZvjHTyWeCw+GnWOaMU4+9Dq3DDxjkCbMzNt3/XxwM7lIM+GjjAN4Gd4TZ5D5SRiGMiIp2vTKvGIjDOPKC9UcC+6dJGc8LyiCGSeqsO+ypw9BF2D0CDTV1rPegSbdSX25DZzQpJfy0rEQPKUsrIroGSdwkUo6nnWdKTYoMa6JUnDOoczSHWzMATavUf9S5TZ2EPlcr/P0IXNKT3TbNguX/OfZI91aa4n0+2qbHUUVjRtN5pXNhKO5OKlQGyv2zgwtjU44U+WaUhABZbDJ8JzsyMs0lzMilSYeDaqPRbf2nK+QeppxDhU1gAuKIXhMqVcvaXt9fuZBYtuBTJbtw1hu/MowmW49Ryijh0L5a5b1ZNniJm2KbdgPG+WNEK3pUM/TyMC6SMT0QfX8jVtzmRvX5KqN4jay7Evm9xlgOhW8GYi+1vwnOWq40M836Ot/D2ojrRuGaGSaWKxcIgfhon5PawVhuyI3qiUP9bpZBf3SvcllT4RZDFEo4i0C4dtFRBOzEIBdSJX8FzH4OVgsiirg2oPM6UkpoIDZFazXpZLnq6enmxnuapZUyIFge8hV5m8C6neXNMJ6KpLsXrghhCA1v6
 pQxodkNQ
 YlCla5tLe1E0ENRBliqRoeDPKO7I0Hp4PUiHDqy7bvgVrveCvxNy7kdD7K1dmEKUlszJu0WxRx99G1Wv1sq7Lhgxt8OxPNrOBCuNw1dK4Dt+kLOiLtmiFr3J0paV61uwQPzWgdppSKyjQcDCHb0BGyUGWX4GCmZJMYFh3LV9iJKBcGJOWdCbidv1nzH+/GAZQwkR/rs8gj3UcC3Bs2+JDE/aGxFpd3Rjf6in5RKFLMRk4NB0A5GgDrztA25J8YYfoZHnWhAuq/1Eq9qFy5z4yobHIttPI8sQeLsVQH+aQmeBoJ4osTVSFZpJt/WIs9l5KlqAizc1ka43cWy2EQyzYUJ/PkcETFbcOyN7fEhiTKn8zPZu8syTTuBXRycd9hkKtZi/YsBp8iFz1uNv+8QXVbclzc009icHCola9kghlBwavqCgwN5Z2+1wdsQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

folio_end_dropbehind() is called from folio_end_writeback(), which can
run in IRQ context through buffer_head completion.

Previously, when folio_end_dropbehind() detected !in_task(), it skipped
the invalidation entirely. This meant that folios marked for dropbehind
via RWF_DONTCACHE would remain in the page cache after writeback when
completed from IRQ context, defeating the purpose of using it.

Fix this by adding folio_end_dropbehind_irq() which defers the
invalidation to a workqueue. The folio is added to a per-cpu folio_batch
protected by a local_lock, and a work item pinned to that CPU drains the
batch. folio_end_writeback() dispatches between the task and IRQ paths
based on in_task().

A CPU hotplug dead callback drains any remaining folios from the
departing CPU's batch to avoid leaking folio references.

This unblocks enabling RWF_DONTCACHE for block devices and other
buffer_head-based I/O.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 include/linux/pagemap.h |   1 +
 mm/filemap.c            | 130 ++++++++++++++++++++++++++++++++++++++++++++----
 mm/page_alloc.c         |   1 +
 3 files changed, 123 insertions(+), 9 deletions(-)

diff --git a/include/linux/pagemap.h b/include/linux/pagemap.h
index ec442af3f886..ae0632cfdedd 100644
--- a/include/linux/pagemap.h
+++ b/include/linux/pagemap.h
@@ -1260,6 +1260,7 @@ void end_page_writeback(struct page *page);
 void folio_end_writeback(struct folio *folio);
 void folio_end_writeback_no_dropbehind(struct folio *folio);
 void folio_end_dropbehind(struct folio *folio);
+void dropbehind_drain_cpu(int cpu);
 void folio_wait_stable(struct folio *folio);
 void __folio_mark_dirty(struct folio *folio, struct address_space *, int warn);
 void folio_account_cleaned(struct folio *folio, struct bdi_writeback *wb);
diff --git a/mm/filemap.c b/mm/filemap.c
index ebd75684cb0a..b223dca708df 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -49,6 +49,7 @@
 #include <linux/sched/mm.h>
 #include <linux/sysctl.h>
 #include <linux/pgalloc.h>
+#include <linux/local_lock.h>
 
 #include <asm/tlbflush.h>
 #include "internal.h"
@@ -1085,6 +1086,8 @@ static const struct ctl_table filemap_sysctl_table[] = {
 	}
 };
 
+static void __init dropbehind_init(void);
+
 void __init pagecache_init(void)
 {
 	int i;
@@ -1092,6 +1095,7 @@ void __init pagecache_init(void)
 	for (i = 0; i < PAGE_WAIT_TABLE_SIZE; i++)
 		init_waitqueue_head(&folio_wait_table[i]);
 
+	dropbehind_init();
 	page_writeback_init();
 	register_sysctl_init("vm", filemap_sysctl_table);
 }
@@ -1613,26 +1617,131 @@ static void filemap_end_dropbehind(struct folio *folio)
  * If folio was marked as dropbehind, then pages should be dropped when writeback
  * completes. Do that now. If we fail, it's likely because of a big folio -
  * just reset dropbehind for that case and latter completions should invalidate.
+ *
+ * When called from IRQ context (e.g. buffer_head completion), we cannot lock
+ * the folio and invalidate. Defer to a workqueue so that callers like
+ * end_buffer_async_write() that complete in IRQ context still get their folios
+ * pruned.
+ */
+struct dropbehind_batch {
+	local_lock_t lock_irq;
+	struct folio_batch fbatch;
+	struct work_struct work;
+};
+
+static DEFINE_PER_CPU(struct dropbehind_batch, dropbehind_batch) = {
+	.lock_irq = INIT_LOCAL_LOCK(lock_irq),
+};
+
+static void dropbehind_work_fn(struct work_struct *w)
+{
+	struct dropbehind_batch *db_batch;
+	struct folio_batch fbatch;
+
+again:
+	local_lock_irq(&dropbehind_batch.lock_irq);
+	db_batch = this_cpu_ptr(&dropbehind_batch);
+	fbatch = db_batch->fbatch;
+	folio_batch_reinit(&db_batch->fbatch);
+	local_unlock_irq(&dropbehind_batch.lock_irq);
+
+	for (int i = 0; i < folio_batch_count(&fbatch); i++) {
+		struct folio *folio = fbatch.folios[i];
+
+		if (folio_trylock(folio)) {
+			filemap_end_dropbehind(folio);
+			folio_unlock(folio);
+		}
+		folio_put(folio);
+	}
+
+	/* Drain folios that were added while we were processing. */
+	local_lock_irq(&dropbehind_batch.lock_irq);
+	if (folio_batch_count(&db_batch->fbatch)) {
+		local_unlock_irq(&dropbehind_batch.lock_irq);
+		goto again;
+	}
+	local_unlock_irq(&dropbehind_batch.lock_irq);
+}
+
+/*
+ * Drain a dead CPU's dropbehind batch. The CPU is already dead so no
+ * locking is needed.
+ */
+void dropbehind_drain_cpu(int cpu)
+{
+	struct dropbehind_batch *db_batch = per_cpu_ptr(&dropbehind_batch, cpu);
+	struct folio_batch *fbatch = &db_batch->fbatch;
+
+	for (int i = 0; i < folio_batch_count(fbatch); i++) {
+		struct folio *folio = fbatch->folios[i];
+
+		if (folio_trylock(folio)) {
+			filemap_end_dropbehind(folio);
+			folio_unlock(folio);
+		}
+		folio_put(folio);
+	}
+	folio_batch_reinit(fbatch);
+}
+
+static void __init dropbehind_init(void)
+{
+	int cpu;
+
+	for_each_possible_cpu(cpu) {
+		struct dropbehind_batch *db_batch = per_cpu_ptr(&dropbehind_batch, cpu);
+
+		folio_batch_init(&db_batch->fbatch);
+		INIT_WORK(&db_batch->work, dropbehind_work_fn);
+	}
+}
+
+/*
+ * Must be called from task context. Use folio_end_dropbehind_irq() for
+ * IRQ context (e.g. buffer_head completion).
  */
 void folio_end_dropbehind(struct folio *folio)
 {
 	if (!folio_test_dropbehind(folio))
 		return;
 
-	/*
-	 * Hitting !in_task() should not happen off RWF_DONTCACHE writeback,
-	 * but can happen if normal writeback just happens to find dirty folios
-	 * that were created as part of uncached writeback, and that writeback
-	 * would otherwise not need non-IRQ handling. Just skip the
-	 * invalidation in that case.
-	 */
-	if (in_task() && folio_trylock(folio)) {
+	if (folio_trylock(folio)) {
 		filemap_end_dropbehind(folio);
 		folio_unlock(folio);
 	}
 }
 EXPORT_SYMBOL_GPL(folio_end_dropbehind);
 
+/*
+ * In IRQ context we cannot lock the folio or call into the invalidation
+ * path. Defer to a workqueue. This happens for buffer_head-based writeback
+ * which runs from bio IRQ context.
+ */
+static void folio_end_dropbehind_irq(struct folio *folio)
+{
+	struct dropbehind_batch *db_batch;
+	unsigned long flags;
+
+	if (!folio_test_dropbehind(folio))
+		return;
+
+	local_lock_irqsave(&dropbehind_batch.lock_irq, flags);
+	db_batch = this_cpu_ptr(&dropbehind_batch);
+
+	/* If there is no space in the folio_batch, skip the invalidation. */
+	if (!folio_batch_space(&db_batch->fbatch)) {
+		local_unlock_irqrestore(&dropbehind_batch.lock_irq, flags);
+		return;
+	}
+
+	folio_get(folio);
+	folio_batch_add(&db_batch->fbatch, folio);
+	local_unlock_irqrestore(&dropbehind_batch.lock_irq, flags);
+
+	schedule_work_on(smp_processor_id(), &db_batch->work);
+}
+
 /**
  * folio_end_writeback_no_dropbehind - End writeback against a folio.
  * @folio: The folio.
@@ -1685,7 +1794,10 @@ void folio_end_writeback(struct folio *folio)
 	 */
 	folio_get(folio);
 	folio_end_writeback_no_dropbehind(folio);
-	folio_end_dropbehind(folio);
+	if (in_task())
+		folio_end_dropbehind(folio);
+	else
+		folio_end_dropbehind_irq(folio);
 	folio_put(folio);
 }
 EXPORT_SYMBOL(folio_end_writeback);
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index cbf758e27aa2..8208223fd764 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -6277,6 +6277,7 @@ static int page_alloc_cpu_dead(unsigned int cpu)
 	struct zone *zone;
 
 	lru_add_drain_cpu(cpu);
+	dropbehind_drain_cpu(cpu);
 	mlock_drain_remote(cpu);
 	drain_pages(cpu);
 

-- 
2.39.5


