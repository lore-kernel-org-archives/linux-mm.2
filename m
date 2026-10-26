Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D0DAC606A324
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 08:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=DfcaYETo
Received: by kanga.kvack.org (Postfix)
	id 011776B05B4; Mon, 26 Oct 2026 04:02:56 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id F2C306B05B5; Mon, 26 Oct 2026 04:02:55 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id E41486B05B6; Mon, 26 Oct 2026 04:02:55 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id BC0B96B05B4
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:02:55 -0400 (EDT)
Received: from smtpin23.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 3E4CE12045C
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:55 +0000 (UTC)
X-FDA: 85364036310.23.52BA54B
Received: from mta1.migadu.com (out-242.mta1.migadu.com [95.215.58.242])
	by imf20.hostedemail.com (Postfix) with ESMTP id 0E3FE1C0006
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 08:02:52 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfcaYETo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793001773;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=zmy3LH0dL65AyxAOzx2otQGK/mLaqXxkxMSe8fA4quA=;
	b=ydtyzO+fPORcUPtF9q64N9KFWon3V4nmVLBH0TV2780mNecrOTYKx7U0NDG35FmADtz9S0
	Y/uVT/LvRJUYJsfDyPbAqnlz7htf3zvstWMl9PtCnM5iySvun0t3k2rkbIIxkpsAcs1kQ0
	ZueqFid+bIIAjEjmIM9yV3/EatYdHOY=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b=DfcaYETo;
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf20.hostedemail.com: domain of hao.ge@linux.dev designates 95.215.58.242 as permitted sender) smtp.mailfrom=hao.ge@linux.dev
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793001773;
	b=lZ1QiXrhDfvYxyxjGC7q6i8W+yQ1plPJNIpbA26jL59ioskB4jM1BxZxvZuPJgYx5yi6p/
	xQAS9XbRUDa3DNdSLBGieq/G5JMC/DjkD9Jo+f56jS31Of/yCPlrYZMf+532hQT7yMI7Dg
	tQdEGdn6Hn6Hqx+zmshmXa/1sk/MR0Q=
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=rcaYfxcJJLBaD/Nimy7cPxQcpSG7l5aC5JBRtkuZ3MU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1793001771; v=1; x=1793606571;
 b=DfcaYEToOO05oj5XAMAuaH+q8d6pgLJ6lXHw/QEd/bWVV9BNdC9VlOhrYPLyBfBVzZ02bIlK
 hO2vnwexCD5YN6nHcqqYKLkTQtXJsMqDUoPka3SnTX2wcJyLp31rrn+cqTqMePnv7jymh8xCMvp
 DykbHKCboQtxsdddbh9NhyO4=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id 5dcbb4fe83952587;
	Mon, 26 Oct 2026 08:02:51 +0000
X-Mizu-Trace-ID: 5dcbb4fe83952587
X-Migadu-Flow: FLOW_OUT
From: Hao Ge <hao.ge@linux.dev>
To: Madhavan Srinivasan <maddy@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Nicholas Piggin <npiggin@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Shrikanth Hegde <sshegde@linux.ibm.com>,
	Alexander Potapenko <glider@google.com>,
	Marco Elver <elver@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Dennis Zhou <dennis@kernel.org>,
	Tejun Heo <tj@kernel.org>,
	Christoph Lameter <cl@gentwo.org>,
	Uladzislau Rezki <urezki@gmail.com>,
	Hao Ge <hao.ge@linux.dev>,
	Suren Baghdasaryan <surenb@google.com>,
	Dev Jain <dev.jain@arm.com>
Cc: linuxppc-dev@lists.ozlabs.org,
	linux-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	linux-mm@kvack.org,
	Sashiko <sashiko-bot@kernel.org>
Subject: [PATCH v3 03/10] mm/vmalloc: clamp an unaligned range in vunmap_pte_range()
Date: Mon, 26 Oct 2026 16:03:22 +0800
Message-Id: <20261026080329.140244-4-hao.ge@linux.dev>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20261026080329.140244-1-hao.ge@linux.dev>
References: <20261026080329.140244-1-hao.ge@linux.dev>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 0E3FE1C0006
X-Stat-Signature: qd31yrueette36h7txzgupuyxbttupmw
X-Rspamd-Server: rspam06
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793001772-286800
X-HE-Meta: U2FsdGVkX1+Zbp5YldjGsD+EeiB67QXl9VVSPx0UquFrsxbYSmj1+sT3XA91mhnsVLZP/lIgDlKq1V9ljHKMuh9yYD68VqxFfgU2c26sWxuXBq1VkbAlvFBSzfF0ytwimYlm5FvBLPKSJUJHwAXZDsyl00/w2pOd+W2e98aGX9YGxqbYto2puKrzA+lp/PLmlYDT9W/+2iQeecKt0dOE9s4Oq1KcJ2w5IF33fUwoOcVm9WF44pFGF5SwxiJohL64o4R0iNLq7VXdq+TsHWSWzhoyww2MeMQJ7IOOp33/OXk6D7ybcbAr8NNfNB/+74sXl0pAceUDbnMSvLhT8CtMubNIkG8jiur+rDUzCQbkIhGtSovw+ux5rPjx1y9zqGFEg+UOjw7VAZRCZ0eMmth/ysAwAVeLUjJ+SZ+A2jxusqC2lEiwgA/II/tfxRvVDPHLyjDYEr/ondLTMbh8nQ0nV4Dy8wr3gfxAIL3XhUf0FuCZurjdzuvQ1Creuis08uVuwdG6t9wCkoiUL8zowRTc1VVRyJ9Kq2GfFEFZj3xPcur+1pCkn87knn0hb1XhXVs24fzo43UblEO2rZX8EphRDMx9s3iFS4IkqAOSqQyznYUzSAuhvSh5LUqlI+Va3k4o8YVlbwh7jd2+mcRmubcfT6m1lJ9fCAzfBheEv6L/v2LdyIsmG8io+g4U12fmLQbvyWsdxRXNSC4/IqGjJR0bF2PbSEQyLPxHIqduiMlzM0V2Ti8ulcN9p9IWAgV0IbRUyrzOwoeiDK+fA+mZsw1KUKBv/WyoHFWKENFKkpg9P/6notWff0ci/CqS5HBfrNqgRRYUXMoSsEiAL83DZFPiu1kUBBMXDY+3QGYk/+Qb0Pwu1lDoQADAkfPFBRMP9RY1AUeRulGYeFotsBFFylMeNSp3E7G+NOjZ9qTchuopQo6yxpy2lCX2uq2KUcKO1NWRaH9LEsIzCAtd4+Sms7A
 SRQuRSox
 ajPVg1oP7JxPpEJEDvpx3Z/BchJXsOXpVrLy3vXnS7kCx1AkUovgR0JrjemNe4dDSGtIuyLnlWxWkNPDY/31EdRuY7JW4i35h5l3aasqneJ0bHZjacahcF01RqC0vUa4c548xH8z0htd+CsBSaIcowF4xyj9FJo5WVqN7q882pee3Ge6zrFSpHPJQHNxhQ4GNfxK6gvDIKJD4BwV2K7g5+vfUyr5DhhKeJLG0Y1XGDRldJJ9Ov66MAAuApIgXnYviqveEAxkbEgwIFMPLn0y250/hDwIG3/8N4luKrck6Lt1GSQIk9OUj0AUqM05b8KCBWFnOhgu/JmtF0ur2Xh5weLqVzFRDKmdfBOO3DEY6krFG+gnwRiczxBNpYg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

commit a739e6b557af ("mm: vmalloc: WARN_ON if mapping size is not
PAGE_SIZE aligned") made vmap_pte_range() warn and bail out when the
size is not a multiple of PAGE_SIZE. That loop steps in page
multiples and stops only at addr == end; with an unaligned size addr
never lands on end, so the loop cannot terminate and walks off the
end of the page table.

vunmap_pte_range() has the same loop without any guard, so an
unaligned range would clear PTEs past end without ever stopping,
walking off the end of the page table.

Add the check there too. The range is clamped down to the last full
page rather than dropped, and the loop is skipped when nothing is
left, so a buggy caller still gets its PTEs cleared as far as they
go.

Reported-by: Sashiko <sashiko-bot@kernel.org>
Signed-off-by: Hao Ge <hao.ge@linux.dev>
---
 mm/vmalloc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 44e0eb32708f..7131f60d1a8e 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -393,6 +393,11 @@ static void vunmap_pte_range(pmd_t *pmd, unsigned long addr, unsigned long end,
 	pte_t ptent;
 	unsigned long size = PAGE_SIZE;
 
+	if (WARN_ON_ONCE(!PAGE_ALIGNED(end - addr)))
+		end = addr + PAGE_ALIGN_DOWN(end - addr);
+	if (end == addr)
+		return;
+
 	pte = pte_offset_kernel(pmd, addr);
 	lazy_mmu_mode_enable();
 
-- 
2.25.1


