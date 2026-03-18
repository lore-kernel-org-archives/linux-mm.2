Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 245BA1077612
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 20:04:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 735B86B0300; Wed, 18 Mar 2026 16:04:05 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6E45B6B0302; Wed, 18 Mar 2026 16:04:05 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5AC5C6B0303; Wed, 18 Mar 2026 16:04:05 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 46FFB6B0300
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 16:04:05 -0400 (EDT)
Received: from smtpin27.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id F04221C25B
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:04 +0000 (UTC)
X-FDA: 84560260008.27.0296138
Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	by imf18.hostedemail.com (Postfix) with ESMTP id 25E971C0010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 20:04:02 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=b4cAsB9Q;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773864243;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=xA2tsV+rhDOG+fLN+eXa3w2/CdlIulJXzLT7vmCgaLA=;
	b=2V6AN+xrA2VD7ipj2dv0O8vFiXH4yWzxFWYpt9exG1LPRMQIIi5c0lZfQZJXrFgVLGR4o6
	lB4SJySdpQlIkEyGY+N9r+H+qYFX80fFwl+8vnOOpWvoSrGCGPqr0D0vfHlFm8MFs69Bj8
	TC6KCdpFFTsLIo0O+cUpbe6ezvSghUY=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773864243; a=rsa-sha256;
	cv=none;
	b=rvJuPVkkkowrqnN8m4e1HO9/T5fdbvAGwhXgVlFLwQaTKhbU1bjWftEvkTtSX46O8D9ooE
	3fpuBQf1eTw2fsAnzAPKT9Pg1OvOqbviUip1KvDaaEsCaMg3D9dsg4aHWKdeK8ev8YnphL
	y0e9q8DsaYCGDNrKIwNdHu/ZsbT4p44=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=cmpxchg.org header.s=google header.b=b4cAsB9Q;
	spf=pass (imf18.hostedemail.com: domain of hannes@cmpxchg.org designates 209.85.160.182 as permitted sender) smtp.mailfrom=hannes@cmpxchg.org;
	dmarc=pass (policy=none) header.from=cmpxchg.org
Received: by mail-qt1-f182.google.com with SMTP id d75a77b69052e-5062fc5d86aso2025481cf.1
        for <linux-mm@kvack.org>; Wed, 18 Mar 2026 13:04:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773864242; x=1774469042; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xA2tsV+rhDOG+fLN+eXa3w2/CdlIulJXzLT7vmCgaLA=;
        b=b4cAsB9QrS71WXDQHJQF68HviXZjUPbKPzpWuIP9g0uZubIpsfNGAG1h24ft7zzDwf
         LyaW5pghk9kwC2vq3Wf3+mAH2j53WO8YoyRq+byeCuw2v417g6bllKsj3gE5XlGhAeXa
         58mieRJfJa2BjGU7ZbLWM18/izkV5pel4eSgkQb0MwcYXaWw5kstfA7ftdDPd2P/09x2
         cnElLCEI1NLXo7spaR1ogsGn5cKyWeSYbccr5n7cd3k2YHPtzIiihbNIe7UcYC5Fuv4L
         D39iPydYNX8/6lEnSzNFrhTnU0yxaq4+6rzYVSn6DkOehGrP9GRnnEtRNfBVc7wFxmbf
         J5XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773864242; x=1774469042;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xA2tsV+rhDOG+fLN+eXa3w2/CdlIulJXzLT7vmCgaLA=;
        b=tTDIbykVnnnvyntSm6DWiuGG+bvr+yfQgsD9AcvWgBl+LsEKzji9PFIVk5hrBaWqC+
         vgRFTsKg4b289eBoCkBlxaWzXUDpqGKTkTywZ+RYxRFTNjbLkQ4cxIj7TMH5DaFjWqU6
         Mg6tb2CWcRFM2rB3IFgO18XHUIeFrvG5LX4UXt5ug1cEgx/7hYwf9tz2m/O3HOGpVmfz
         mpVFpY1kpAaxu8YLVr5e1uZMdGK5rv0g+GNa/NRPf4LC/6CXRFlM5nGgFjHJpA6fIo9O
         bEHig6nLvWHHOc1PB+/7EHdjs6ts/RRjVORA06FknFB0jd8nVlr9IX1Fwv+iWGNTy1sv
         2b7A==
X-Forwarded-Encrypted: i=1; AJvYcCVl8sAhkcyGyxi4BQmJ36G4sSBKGPZaz2/4hZ1VISWeq5WCiWfI0QSNkT3Yhn2Gco2N+3IQMoeiyA==@kvack.org
X-Gm-Message-State: AOJu0Yyd9NSMDXKy+mWeDXt5KdQAf9NvHGSavCX1pS4yKIspBMAAYxzP
	BgIhtpgfjnYmq7rJgzcHe9j5orLgCOYW8oe0+xPju8AZM7Z5zW8w/fPFX/AsYUp2xEI=
X-Gm-Gg: ATEYQzw5yswZ9+lWGy27p4ihiJCG2LmkhhWJp749VoKEuikN0zjGpaeYNyVkCRCen2s
	gBRUp7ckLoNUfIGY7GsHXlZosdxyMs0zJz5LB8kIEKLionh1Gvk4F8u/70A1ZgcZ9w8DMRLE58F
	l4/9u4iESpjmwzM6xr8VevXSy7DaBafkjwcALkikGzp+4NfOUyOOJl+HGprI16j83fSR9ofgYdL
	LMijKCaKZlJnBFHFsq2crYDs7fFx+UCpcvcVUDjfqLb3dYGj7r6jNKv4nk4Qdg+EKU4z1pJv9xO
	1aVy6d5U4fFfomPxNuB3qYUmZsOS8GnUPChwnJ6WVCj4kJA9R1Twq79nYeOd9kCK+sK/fRXMj+2
	a760ki1jijb9Z5x0cMcqT5AXOqerd31tXvi7cX3Je0yWre7TVbaDHCHSF9XCpdxQ+GU1LajMyD7
	8imbPXM3TK11gwi3NGXem143uHHeRD5Sfy
X-Received: by 2002:ac8:7d47:0:b0:509:1987:7626 with SMTP id d75a77b69052e-50b148ec22bmr59111751cf.68.1773864242086;
        Wed, 18 Mar 2026 13:04:02 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id d75a77b69052e-50b135eeeebsm29705751cf.31.2026.03.18.13.04.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Mar 2026 13:04:00 -0700 (PDT)
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Hildenbrand <david@kernel.org>,
	Shakeel Butt <shakeel.butt@linux.dev>,
	Yosry Ahmed <yosry.ahmed@linux.dev>,
	Zi Yan <ziy@nvidia.com>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Usama Arif <usama.arif@linux.dev>,
	Kiryl Shutsemau <kas@kernel.org>,
	Dave Chinner <david@fromorbit.com>,
	Roman Gushchin <roman.gushchin@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 1/7] mm: list_lru: lock_list_lru_of_memcg() cannot return NULL if !skip_empty
Date: Wed, 18 Mar 2026 15:53:19 -0400
Message-ID: <20260318200352.1039011-2-hannes@cmpxchg.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260318200352.1039011-1-hannes@cmpxchg.org>
References: <20260318200352.1039011-1-hannes@cmpxchg.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 25E971C0010
X-Stat-Signature: nxurhi464jwyrxdjqdhs63r7xcdjpg3d
X-HE-Tag: 1773864242-216790
X-HE-Meta: U2FsdGVkX195rB3UNqs2JekruhnD9e1HIQCFqdTVVnuEd0lH/yIH4TF2E2RyF70/RtkXZiDhUd3IRGpcPy+BJ+dQ1Nqs5ZLWndJV+7/WIDwTx7m2YsFkLa/zvsEYe0w0Sc0umaqBXJpsdkCh5u3Pe7hgQOlEvCf9+WHOCBMIMY+ZCr4fdd9Ire1v5cMlqofqtDNdqu+UiX4nBxZAN3lR+T/zCFhE8P+tK96zrRniYWc+0EPQe9fF3TQW34mosl1tkdevOIQlnEnfgvQW2z/MWgzlqW8GGCTZ2X98nRxlPUcbF0fVsaQaLHe6APLmm++K4yT2SpkwG0OOH1ybS/6WSv/RTGvnaFJLTYrtvRNNlpWR/8ItoGo/RdmkOMX7f8qaXseZ81dLRhv+yznUruCxwY30o5lHIpWWUqF5rIihH0dHbyV5/0yjhMMNCM+Plf8S5ZMSO+4PHwnGIYrcGJCoc72Lu8VDmjsfWnT5vSmPxBoww0G34mtH47ZFkiPlJ0ugcoxYH+/A6522CuP/efADbCn8fbQDGrOliAqsYOBT4u3V0XL9ua95D1IhJD0dyopXte97gkyj/qiTMKk91p6CraI8FIbiAx0o0NudfFUvso1ng/c7xLOenGSQBdbGFe8jxsQkFwOBDUSsF0m2FC+nrtcnoztAjGyxki7XRqPdrq5686xzJ85sY0V6lY9hI1X3MRFtqxjtIR8z2fAQyvBctJAOJVX7IFwOLgjvIhHi+OzscATT0uek95JuDMi9HF3gbtqhJHqKWoCFnIbNfi6dSAYpXDEHS97IkiGwASi1r5rA8o8lsfEJF+Wzqbc98AHS4xGG+cqp0FA4IAyRbAu7FAY6M1uT+uOpb8apOQVkY1xtB+iFHEYt7DfmCGUhChytnlOmG7uFPpe8q4e+60sRnDJfjymZqXn0ffTMAxXyMryUZee3s6Qj2OjVAWVh+fVcyeSPT9MzR8U0SqAX660
 LPRztraC
 o8q8G/pn7MVxj2F5r/BFUD/9TWkRK9U0Zt0fkLy24eEKHTalH+HEhyuAFxaGEeSswil4uDeuzqYVeDWH5+JwaC/4N+w8pqTeIcIjae5fBfp4Gw0sJv6ucMBmAoc0dxfREq52i1HYIgtd/+JRDij79VasMbI6XAENCJMhIpO2VpACJ1HjmMZQdSBuZI0Fw5BXNSWMg7IgJWJrUjE+X1bzKhORJB0DU2BRY+2eCdSPMmPOp4Cjib1HicAxPZRbwG4lSiqpPsxkk6hJ4if7K+E+zxOXl4bSRjfFl4/GoEgIanjEoE6UjvvZTBwV6wxG6KzeOB/JnAc7rcnbL85c1o+bfvy+W6Or3iAIZkZRNvWx/Ri00JExl+EZ18RtK5vnXDz0EueoMdOvUleJFPejLdmZT3j1V4DACEtq5pzjXq7+71T28aEwh0HHr33BouZOpggXVdz5KGkzxZ3gWhxUojH/3BSXEn2l2N5RkHATAUprW1LNSUQBUIRtIFCLnSQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

skip_empty is only for the shrinker to abort and skip a list that's
empty or whose cgroup is being deleted.

For list additions and deletions, the cgroup hierarchy is walked
upwards until a valid list_lru head is found, or it will fall back to
the node list. Acquiring the lock won't fail. Remove the NULL checks
in those callers.

Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/list_lru.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/mm/list_lru.c b/mm/list_lru.c
index 26463ae29c64..d96fd50fc9af 100644
--- a/mm/list_lru.c
+++ b/mm/list_lru.c
@@ -165,8 +165,6 @@ bool list_lru_add(struct list_lru *lru, struct list_head *item, int nid,
 	struct list_lru_one *l;
 
 	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
 	if (list_empty(item)) {
 		list_add_tail(item, &l->list);
 		/* Set shrinker bit if the first element was added */
@@ -203,9 +201,8 @@ bool list_lru_del(struct list_lru *lru, struct list_head *item, int nid,
 {
 	struct list_lru_node *nlru = &lru->node[nid];
 	struct list_lru_one *l;
+
 	l = lock_list_lru_of_memcg(lru, nid, memcg, false, false);
-	if (!l)
-		return false;
 	if (!list_empty(item)) {
 		list_del_init(item);
 		l->nr_items--;
-- 
2.53.0


