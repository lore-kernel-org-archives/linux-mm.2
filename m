Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 36C4AC55172
	for <linux-mm@archiver.kernel.org>; Sat,  1 Aug 2026 17:36:44 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 622386B009B; Sat,  1 Aug 2026 13:36:12 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5AB1E6B009D; Sat,  1 Aug 2026 13:36:12 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 49A8B6B009E; Sat,  1 Aug 2026 13:36:12 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1EA356B009B
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 13:36:12 -0400 (EDT)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 6B6F54036F
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:11 +0000 (UTC)
X-FDA: 85053404142.16.FEE5C59
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf01.hostedemail.com (Postfix) with ESMTP id C9D8F40009
	for <linux-mm@kvack.org>; Sat,  1 Aug 2026 17:36:09 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLT4gtqM;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785605769;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yKFkp73Zizuc7gexvqH7fNRh7GwZeAoSufeXbUk/pxY=;
	b=NYHhrKq3zpTzpekGKVsVmxlujMvzpiimMxeUlMLEAFZlBBD6TkbI6kcn3DyOhLR6JwJ47c
	yqKhzsMuj9O50sxj+3/NkAQv6TghnWdQOxywQv9/ihcxd3AEZlWMoKs6wmicdGcLzzZW55
	KJsVjsYF3cGQMPmM3J9XG+PfQ+3kmdY=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=bLT4gtqM;
	spf=pass (imf01.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785605769;
	b=qLqIoTFleXkfbWPozdHNbzvZxqBCY6ykBOEQ/P3kRqTTnBTntei7cA68fAxKcoKTEmppEf
	MdoX98QF09LsyGtC9Mi9ip6gNl20Y053Bu9dbry+OTMuVR2SrhOSpH2FJLzdIL6MSDklH8
	goKbQ2rVwCDhPPfsoNG/AMW7OqKJkZk=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id 5EBD943C9F;
	Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 132801F00ADB;
	Sat,  1 Aug 2026 17:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785605767;
	bh=yKFkp73Zizuc7gexvqH7fNRh7GwZeAoSufeXbUk/pxY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bLT4gtqMoalg2zLuDMjvtK/ef07qFRzpt+RM2ctRTcIZ3j9/K93AyBnxGZVuNwRng
	 Gopobsn1Fx/WJ0+EPpcLwkzkBIyGDzjtYzBPjMV84zQg8qjWyUZm2S/h0EGdVAGM97
	 8+ddelOUyoG40WvlZHuHGfMa4oVq/Q7lZQjm5vDVaU6vHW1HSRoL2qKTCb8fPT2DCb
	 8VbgD0EaeCNFedX9ba2aXObuYY/jOAyAh0LmpwssCEGEzmr2Lr9FhrYr05xvYJFC1g
	 QSnU8Y2im/ARKApd+jeszY1vR4bIsqgjhyWquzUzQ1/8vJpzmIjD43qOPfHm9UBe+n
	 TGZ7L9lrbZd0A==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH 8/9] mm/damon/core: handle extreme memory state in get_node_memcg_used_bp()
Date: Sat,  1 Aug 2026 10:35:51 -0700
Message-ID: <20260801173554.94710-9-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260801173554.94710-1-sj@kernel.org>
References: <20260801173554.94710-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: C9D8F40009
X-Stat-Signature: jhypqf9gth8cqiuh7fzqu8dqdfnh7op6
X-HE-Tag: 1785605769-698149
X-HE-Meta: U2FsdGVkX1+NKm+HiuPW/2BVLGgWCAxWL8prPr4oBYACBCZlPFDn7jzRbAlBp2O6lp6o7lQMNn33O7cWERISZvp4JXeFzDpSkAKn8MlrMPlTi+ZKM+/4MrEVbiv0RDE/yDBzw+3fn3OPn/ViakVpybT9txM7jxLhRH/wP9T1AoiAyIpARsJgk0TIJZd/G9eDGaU0coPuIt+bKUnbcI6z46RdFlQrd0BaWiXeRHsMCAeZEzFAo4Ujq+ruOl/SSHq+6f2lzjE4NgTGXiuqZ3oOc+avi9rTcUvtiv4RhvUSzJB8KCUa6lLoTE2ttB0RBbTB5ku6QrIxxJNHS2RbDDUO2cKsa0iAkWEbqs8uGdULwTsrjDPnkO+P1qb0zmGfEfidxjQqV2sTcpUuRXpgsVSN5MLji6zKbNWFJu3c3nVQo8vMBEjHQBSasIhz9fFv2YukV/Dx3b4UIJefizocXlb0hXJ9r3zzS1qBZoBvOQJ/RmWTKvvBK3bYECgqVDXFYahYX86rhEV0kzhKkfohZldyt4XVXyO9D7me5etEbKoYPfcQ31UX9y5CxgGW7xlEv/OGWzG1GHdI/FXp7FRSXmO3dIrn6ypgaPYz4KtWM4hE5DWL76LtoXi1E4LcNkaYV0v8Vlq78SBarOHOLg/muWH59fG0ZAsRlTLPS23lVzD+MmaCyxxlJpVHu9wCdPyzDRwfjc4bBkFjTkWP4uCyYiCQRB5voIO1Hgr3RAxXcWk/AwECWFygW80sCIhnEfZpCoJeo98i/oscvZfHNkH8WVkh+deQhWammsRYk39ubiBntWt8Lja0bpiE0mo1oq8SXTC5Jdh2zM0lheE+Qu8vAW979dT5QK2NpaTtTzGcmhneLyQMn5qD7QQGIZRRjdYtqqLXekbV1xk1s9Hxd329M0qMItqkV4V+f/4wMBnNGXwbcNPxVfOzOou/wAtn3+UXocaLI/zPifukIvufat3MahO
 T7JuQrbc
 TljhKR4ULLMV7BFAo4q78n0Y9SFSrPywqS+oXN1S6q+lnDBZJfXe7vzPfzwKQJvBOuQFR79xFrVn8yT3OcuN/ws+qo3zPbsm9MFuiBBK9H/QCbUvpqeXRZjGQ3g7G7e0SzoQmaagGgHurpFdRbMSkEKdQ2YBYTqgDHp6FGpIP9EPMlmXmQ4iCKO2wPXJDWozP73Vf2+y7I+houaIE/RnIBvb5fio30QssZ75nJZ6bAbjjsUQtA7UeM8RR8qiswksglrWClZcFMh2Vb7Rm74U67vq11w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

In extreme unlikely situations, total memory might be zero.  In less
extreme but still very unlikely situations, lruvec_page_state() calls
might let the caller show used memory larger than total memory.  In the
two cases, damos_get_node_memcg_used_bp() could cause division by zero,
or return underflowed value, respectively.  Handle the cases by
returning 100% and 0% for the two cases, respectively.

This issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260329154813.47382-1-sj@kernel.org

Fixes: b74a120bcf50 ("mm/damon/core: implement DAMOS_QUOTA_NODE_MEMCG_USED_BP")
Cc: <stable@vger.kernel.org> # 6.19.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 269865eb8fbfa..76764a2056f7c 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -2858,10 +2858,16 @@ static unsigned long damos_get_node_memcg_used_bp(
 	mem_cgroup_put(memcg);
 
 	si_meminfo_node(&i, goal->nid);
-	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP)
+	if (!i.totalram)
+		return 10000;
+	if (goal->metric == DAMOS_QUOTA_NODE_MEMCG_USED_BP) {
 		numerator = used_pages;
-	else	/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+	} else {
+		/* DAMOS_QUOTA_NODE_MEMCG_FREE_BP */
+		if (i.totalram < used_pages)
+			return 0;
 		numerator = i.totalram - used_pages;
+	}
 	return mult_frac(numerator, 10000, i.totalram);
 }
 
-- 
2.47.3

