Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A435DD64085
	for <linux-mm@archiver.kernel.org>; Wed, 17 Dec 2025 07:33:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 15F7B6B00B6; Wed, 17 Dec 2025 02:33:30 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 137AD6B00B7; Wed, 17 Dec 2025 02:33:30 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 035E36B00B9; Wed, 17 Dec 2025 02:33:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E11B96B00B6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 02:33:29 -0500 (EST)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 7DB47C08F6
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:29 +0000 (UTC)
X-FDA: 84228147738.22.A88F099
Received: from out-178.mta0.migadu.com (out-178.mta0.migadu.com [91.218.175.178])
	by imf30.hostedemail.com (Postfix) with ESMTP id D1E9D80008
	for <linux-mm@kvack.org>; Wed, 17 Dec 2025 07:33:27 +0000 (UTC)
Authentication-Results: imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Dusw2/39";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1765956808; a=rsa-sha256;
	cv=none;
	b=HYggwB/N0yb0127gC4c+I07l7MwvqF/ghmLK3Mhnk0/ggpZC+tM8TBBEUlpZPgmknixw4b
	yIOxvwk+aKhTHJzw/hFxhrV2kdYeBsgLtq8UFflY2QLFpmZIwpK3chAYkU52adVw2B22PZ
	W5j18J474/6ZXpyXjtabYuS/O9nfi3U=
ARC-Authentication-Results: i=1;
	imf30.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="Dusw2/39";
	dmarc=pass (policy=none) header.from=linux.dev;
	spf=pass (imf30.hostedemail.com: domain of qi.zheng@linux.dev designates 91.218.175.178 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1765956808;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=MLWSJF0nLNh7N5C/0x5tciJKSygGd9RMW0b7OeDmmlY=;
	b=rzF134792Wo9TB3aaZRX54CE/oepdHQ/LM+v3goj5ibRxmB45xrZoD+Y4/ZbxCwObFJWrQ
	NlLTgjc7JHDwx5DuBHBRD+xov0k1VMEEUy5G+r0ON5X+GjGaGAOmfwejlcfScjX8mjsnjR
	7WzggktBiW2hUXgIT1DakpUoVAtkeVU=
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1765956801;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=MLWSJF0nLNh7N5C/0x5tciJKSygGd9RMW0b7OeDmmlY=;
	b=Dusw2/39bPZpCKgWRmixvObH3oye1W0d2l/EI+/2d4touyB7sDcx41H6ThV+apVJtk/Yzi
	Mh3NZrd4Dfg10moPMGz7Vru+UO3Po4bUjn2yLFwclZU0w1iEms+dNnGleWkuQpAKJ4cqlr
	7M4Gnng6vNejpEIsBHdQU/5f4k5uVa0=
From: Qi Zheng <qi.zheng@linux.dev>
To: hannes@cmpxchg.org,
	hughd@google.com,
	mhocko@suse.com,
	roman.gushchin@linux.dev,
	shakeel.butt@linux.dev,
	muchun.song@linux.dev,
	david@kernel.org,
	lorenzo.stoakes@oracle.com,
	ziy@nvidia.com,
	harry.yoo@oracle.com,
	imran.f.khan@oracle.com,
	kamalesh.babulal@oracle.com,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	chenridong@huaweicloud.com,
	mkoutny@suse.com,
	akpm@linux-foundation.org,
	hamzamahfooz@linux.microsoft.com,
	apais@linux.microsoft.com,
	lance.yang@linux.dev
Cc: linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	cgroups@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>
Subject: [PATCH v2 22/28] mm: workingset: prevent lruvec release in workingset_activation()
Date: Wed, 17 Dec 2025 15:27:46 +0800
Message-ID: <195a8cb47b90e48cd1ec6cb93bc33a8e794847f6.1765956026.git.zhengqi.arch@bytedance.com>
In-Reply-To: <cover.1765956025.git.zhengqi.arch@bytedance.com>
References: <cover.1765956025.git.zhengqi.arch@bytedance.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Rspamd-Server: rspam01
X-Rspamd-Queue-Id: D1E9D80008
X-Stat-Signature: 9e5wwrz1o84dmb6h8prucxpajjc8wr7k
X-Rspam-User: 
X-HE-Tag: 1765956807-371779
X-HE-Meta: U2FsdGVkX19d9CEeKwPi97l4AtB+ehya9km0OwDSk+xlsq9bo94SQDU+n2FzXT8L/QTRwSALF2DZXeI62T4n4uTM8oIAcnGGcKw60RC3pZ34sW+q3wsikK2V5KD3s00RMIFoKREQU0Vv0XK559Hq0fP8Vul3m0Hu8KjKg3BUyTKZgljnJXnv0EhBPKh+hy2AOhlMYp2vuW0p/A6qrHZwpXU49f+IfkkiKa9DmyXZ7iQgLUSBVAtkUqo43TBjfm74um6gaiI/Dyf0T8JOqKvPnShsdMHoSBebaTzG5GUATeytRrlwIkOBr1sBkAOk5Rw7AQW9CDwohnulZaI/LH7i13vbdztUGYU3Y8FtNT3nItwRQHasPyHAi1CA7kNNdMFl2YebPdha4bCZe2w4xf4Gs6vcVPMak0MROaHzSiGCIsr1li8AKnGV3ojU47v61n3ioG43YHMT3nZqJ7w9WgjsFNCqwUoruyXDh4NW9MCOGfNKGpa5xwTR3C/U9S/wXz/vmkWBzc+Aaf6sBxfFQhCgGcM/PxI4L72hgdM/ydZpz4i4MVcNXFr9imfSeZueoe/cMssIHidm5oqSb/QXp4S2sv/cUUeKxjENptQDMe7rV5+KvRdEqs29LKATPRV4jx1aWV8hHbuCvep32hht9r9n52glZYZgsKMaib6Eb0RML18ZTkglPTh7lIUFPmtmvV+tyk004K19E8EPq/OfTLei2fq+OtdAJ4lc4hTgO0jrF9BduzxoPOEh2FSr579jPtWA9q2ZOuYAwN1VLw8oFonSy5aLGG6vOnCqU/rVg7gkTzPYu5blgQv0xeOvmFDBjiLNtPlZ7Sk+je23DAtrR485e4j6fssCv1fYCdEcWW8lM/+7lhATJhClY2LBme8RbRvL0A/wxq/mQRn4RDN1c18uzDVkqF9KUY6AIS7KzLP+Lw2eZwDbHoheAroBvwJtkXydBGiKDj1IXuRkYw2SPgV
 /1YTdb/d
 QPy45+LqFjNLxQgKtbsMkyM6SH9nfW26G2fuD/oyXSSFwJqz8uVMh59mRiOx9ahCIKMPrFjsDub/trXrJHg8FmA/NT8X1NCRhzHB6dC+Myr3dWMMnNxMkBcW/5/Rq0nokLki+raMKmvA09djmpXz+7A1Ol6t46UGULkSN+9KZZhHx9bXY99uqJhBvG0zahYUeXCW2PyaDT4IhvefJamddFkJYdwVgQwhJDP4hfpa4BG03U4eaSwxxwpskAaWFpRO1nib4
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Muchun Song <songmuchun@bytedance.com>

In the near future, a folio will no longer pin its corresponding
memory cgroup. So an lruvec returned by folio_lruvec() could be
released without the rcu read lock or a reference to its memory
cgroup.

In the current patch, the rcu read lock is employed to safeguard
against the release of the lruvec in workingset_activation().

This serves as a preparatory measure for the reparenting of the
LRU pages.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Reviewed-by: Harry Yoo <harry.yoo@oracle.com>
---
 mm/workingset.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/workingset.c b/mm/workingset.c
index 427ca1a5625e8..d6484f7a3ad28 100644
--- a/mm/workingset.c
+++ b/mm/workingset.c
@@ -595,8 +595,11 @@ void workingset_activation(struct folio *folio)
 	 * Filter non-memcg pages here, e.g. unmap can call
 	 * mark_page_accessed() on VDSO pages.
 	 */
-	if (mem_cgroup_disabled() || folio_memcg_charged(folio))
+	if (mem_cgroup_disabled() || folio_memcg_charged(folio)) {
+		rcu_read_lock();
 		workingset_age_nonresident(folio_lruvec(folio), folio_nr_pages(folio));
+		rcu_read_unlock();
+	}
 }
 
 /*
-- 
2.20.1


