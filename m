Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1A951C5AE49
	for <linux-mm@archiver.kernel.org>; Mon, 10 Aug 2026 14:21:20 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 251186B0099; Mon, 10 Aug 2026 10:21:15 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 229146B009B; Mon, 10 Aug 2026 10:21:15 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1178C6B009D; Mon, 10 Aug 2026 10:21:15 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id C5E396B0099
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:14 -0400 (EDT)
Received: from smtpin09.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3C906160194
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:14 +0000 (UTC)
X-FDA: 85085572068.09.DC34953
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf01.hostedemail.com (Postfix) with ESMTP id AD58A4000B
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 14:21:11 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=p7UYcBOs;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1786371671;
	b=U2UJf7VvnL4GSKW16eDqXcaNiUKqnrih8jk2V8/ThNo2eown9VeApBQvG+QZegjKf887tJ
	CNcbzP/4wYJp9HnFVk3U5oWNj5/VMKd5VPeVApl9HTCimZ2Mf6wEHHbCEGprJ/nsSRTSnH
	/zIpVqvUdNbM3Uuuvn/xOZJ5PcihoeE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=p7UYcBOs;
	spf=pass (imf01.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1786371671;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=lZAVMDkDi9w8ZU6GK98RKcAV+HW3xUm2lluu/vojFZM=;
	b=WXauYaxW49bskellpoRPc4SZbMWIKPt3y2VJA7IzfwzsjFAcl7Eqs89+sJAkmmxvYrhokx
	u/1wmRCOEWPC1tHk4ynMh1IsppdqjjOfI2dkowyHuDA/Tm9sFtAU0QfAwMkF/ASxBc6YFy
	0pMA6QpM44DXQFwCFjdE7OiKHWO+rrw=
Received: from pps.filterd (m0167069.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 67ACbOs73845142
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps01; bh=lZAV
	MDkDi9w8ZU6GK98RKcAV+HW3xUm2lluu/vojFZM=; b=p7UYcBOsaLr+pPgsuvLr
	R/MPvSANKRo7h+FTvLCjUg1W9gLw/P+sbm/usRn/2eddqqPspDB0T/nNH5kDnGWx
	WUhUaUmn2aQFPpG7arLYdteqS4NTxG8HBirKP976dPJY16902eRjwjbBIKybL1x4
	oz19MiM7Eaa37ABKsOoxc6eKS50e1dzLtzq6Ik00JFAI8wyJh1IEj3Lmy8vSG5xu
	+yRZ+mykZkceaNeTd5w4Kn3cb4zVT5SMe0CDw5x56ZVuMZ6SytgY0rho0+ZaDkpB
	QzErQ54R0Ev1ZPJMs1/Qf4lm8vz4Zih5lVgjEQIpHA8IERJjMSuuLVB9bOSwkMO1
	Vg==
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com [209.85.222.200])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4fxyb9bks3-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Mon, 10 Aug 2026 10:21:10 -0400 (EDT)
Received: by mail-qk1-f200.google.com with SMTP id af79cd13be357-934956beec8so365974685a.0
        for <linux-mm@kvack.org>; Mon, 10 Aug 2026 07:21:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786371669; x=1786976469;
        h=cc:to:in-reply-to:references:message-id:content-transfer-encoding
         :content-type:mime-version:subject:date:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lZAVMDkDi9w8ZU6GK98RKcAV+HW3xUm2lluu/vojFZM=;
        b=BrUXVHBIExUlOkAFnZd4Vmd9RGmT33C30OAlOdx55mNcAmBAlCKLowj0wwZo0t9JUK
         0SLmgRd1sZsEhDXT7BAD4C3GAd6Kzm+unTVUPIw//4iGP8O74NtuhExMaWQCBGxiapyr
         pl0IZJtMc2Xexqhsz6ZHaKdDObGPVo77AmtZBiOD1rEVwsGZS37G9hFJI7CI6gT6U3gm
         2Nuqlxu0uR41A6P/biCFO1hEZytu2iBTPwKXLohK4/LYI9iWzhojZ5L4SLp0RMh0xgYe
         1I2BbvufxeWnbvBw5jZlHFB4gADMsi+7Y9y3CF5fGos60tMOskC4HkBryrX/1fCWYCzh
         TNmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rotrwu8N5A5/x/ItWZsm93OSFnpLFYyMm0DNOtB16C+7JwAEFtbkSoWB9ipFlCaXUVFY84NSmWtlQ==@kvack.org
X-Gm-Message-State: AOJu0Yyd2nICFn56xPWry1n0ez+IQ2ZzQJer2RxJD9VDFWmiFTeVnGR6
	+xDjsRAg8YTHyZg55WCxeT488lNATQtUdIQkfDoGi3GmqJETHJ9s/QMsMvNvx1dMwa7PqDTAOn2
	dI3R1QGK6NApf4I8t5tmIgEt2OywcZLVPIoI0riDE8h1BG4Vp
X-Gm-Gg: AR+sD12LFqLT06DacK2b+WajjdgIwT9pe0q5Bg61j0AnrNsbClG7AaVCKlOPDu7qWOe
	065Ggs7ksU2kbXLhS4rDFyrovCtFQkPQcJXfF0PN/OHVfYpD9C/abZGBZ0xBl1uII/MXW5NxQ6a
	mZgeHdsrD1B340taTNQsZ+URPo/Z0h6cO/8b7hA5YlryF7tfyZmGARJ8VJtwRTxQ6DvqabCFWVs
	0SlSZhzFBgEn2Bze+73WY8JVlj2R5pFeWr6RKcWHuG56a7s3j5wU8P3Qf99Wz+G0RxZnC128CG5
	PA6Eu59PsBEcl+qGnjFheOVVDZb39CGdIITv+pl+fJwW1ORnFF8mUGunuWD1VOHkV7YXqqQcemY
	CFvcoIxJz
X-Received: by 2002:ac8:7d0f:0:b0:51e:47a4:4851 with SMTP id d75a77b69052e-52d0b003eafmr297600231cf.8.1786371669555;
        Mon, 10 Aug 2026 07:21:09 -0700 (PDT)
X-Received: by 2002:ac8:7d0f:0:b0:51e:47a4:4851 with SMTP id d75a77b69052e-52d0b003eafmr297598971cf.8.1786371668881;
        Mon, 10 Aug 2026 07:21:08 -0700 (PDT)
Received: from [127.0.1.1] ([77.137.77.155])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145589sm37383983f8f.1.2026.08.10.07.21.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Aug 2026 07:21:07 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Mon, 10 Aug 2026 10:20:14 -0400
Subject: [PATCH v3 03/12] ceph: add ceph_folio_snap_context()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260810-remove-wait-on-page-writeback-v3-3-dd7531704f26@columbia.edu>
References: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
In-Reply-To: <20260810-remove-wait-on-page-writeback-v3-0-dd7531704f26@columbia.edu>
To: Ilya Dryomov <idryomov@gmail.com>, Alex Markuze <amarkuze@redhat.com>,
        Viacheslav Dubeyko <slava@dubeyko.com>,
        "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        Jan Kara <jack@suse.cz>, Andrew Morton <akpm@linux-foundation.org>,
        David Hildenbrand <david@kernel.org>, Lorenzo Stoakes <ljs@kernel.org>,
        "Liam R. Howlett" <liam@infradead.org>,
        Vlastimil Babka <vbabka@kernel.org>, Mike Rapoport <rppt@kernel.org>,
        Suren Baghdasaryan <surenb@google.com>, Michal Hocko <mhocko@suse.com>,
        Zi Yan <ziy@nvidia.com>, Christian Brauner <brauner@kernel.org>,
        David Howells <dhowells@redhat.com>, Jeff Layton <jlayton@kernel.org>
Cc: ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.14.3-dev-d7477
X-Developer-Signature: v=1; a=ed25519-sha256; t=1786371655; l=2021;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=7O7yrVN4O0oLp3x/dLZGdiLj0pIUK9KzDcYDRFGgB18=;
 b=3gSQg6M47bO2pgURxJWAmFQ4PnvlGi8AWeaabt5bNBcjpfLt1y0znTJf5ZvHSRcsXLgqlAj71
 VOCHDcekvzuBKKOjVXYC/adYE5gwRzuUdjjSiA2b/54HZ5bpM8mfi62
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=QKxYgALL c=1 sm=1 tr=0 ts=6a79de56 cx=c_pps
 a=hnmNkyzTK/kJ09Xio7VxxA==:117 a=zHmcO6jMd5r4EZ4U0P0LQg==:17
 a=IkcTkHD0fZMA:10 a=Sv0fKeRqtYgA:10 a=x7bEGLp0ZPQA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=JR4YdQiviy7OQf72WyZ1:22
 a=JfrnYn6hAAAA:8 a=Ikd4Dj_1AAAA:8 a=bg0B0yAPDd754FioS-UA:9 a=QEXdDO2ut3YA:10
 a=PEH46H7Ffwr30OY-TuGO:22 a=1CNFftbPRP8L7MoqJWF3:22
X-Proofpoint-GUID: tF6ZosBkCxu4nhFFU3J5zQ_4GKiIp16M
X-Proofpoint-ORIG-GUID: tF6ZosBkCxu4nhFFU3J5zQ_4GKiIp16M
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX6AP3+1O3tUc3
 R15Zk082UBF5nySGF9Vog+T92hcYwgHN+ChHZdvTRbcc/XYlr5NBtkh0Bdk/GiDbZv+uAcQKYCb
 VeIt1VItMuDy7mXLCdLKZCPTfTqLA9hANBqd88cn74xjrDVb/w0/p0z1S497SwOWxI4+8+zblLv
 wBOnq7pcHVhFs+dYycb+d9CRIpfHMJ0ZyPU7BM+VTJbH1YMdVeLmqe+7Y2Of+6zL5zeSt4knwmd
 nrhR/cutslaKboNW4j1iX1I9LOw+R1+qeHsqFHFiztRHq1ZgLKzWfnJG148bWNUVIouOpmzOqzC
 lfuZ7MfQw6t4F7LPcP+3rlmhqxNQbjH0gyrKSXu65SZ3ctXPJtHQrYLtWrUhLi24ySyaI4Br7NP
 ey4JbsSeMhZXZJasgDYgQjqDJwfuRuBzpJq8qU3hUCEsk4iWpYMG449GZVvTjXge1JQGBQo6rlQ
 oZBIvdJEzDkXHHefn2Q==
X-Proofpoint-Spam-Info: AW1haW4tMjYwODEwMDEyMyBTYWx0ZWRfX1dhU+8dRGa0m
 CpqwoWQsuKl7J1UmKgK6ygTY/jIRpKSIBudyQHuHnCVAeLEL0B7jc+cCES6Y0Q+wHxWi8hZHlsH
 muxf/msQ3trcaH6O9LNGQI2hYKCRPCbWsQSqATs4Pbt0I1b9k5DI
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11870
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 spamscore=0 priorityscore=1501 malwarescore=0 lowpriorityscore=10
 clxscore=1015 impostorscore=10 adultscore=0 suspectscore=0 phishscore=0
 bulkscore=10 classifier=typeunknown authscore=0 authtc= authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.22.0-2606150000
 definitions=main-2608100123
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: AD58A4000B
X-Stat-Signature: pd577xff51dsycc3wizodz4pinzkbmxs
X-Rspam-User: 
X-HE-Tag: 1786371671-595383
X-HE-Meta: U2FsdGVkX1/1bMJ3hg46bBjDc5kzmnfiUmHSxDgDRIiCmSQyc8+y5+OreBRzAs2B1DxjuGnuDR3iNsi8KLDmcVjz7XPrt0SbMw1QvTfDffn4dbWyhg3/Iv6U1okF43nz0TKr/ybdlzMwreY0ONINJf881OfGUs0eYwOsEjwl4nXs5W+tdELCKfD7AZ2w0zOeKK4yC1dT/mVezP383AGqmFbENkhiRdX/RrE4RrxmCROQ6sBSM31pJ4B0/oVW143WA9C3YrKHFCG34vq0uR73JSgqX5Cwx3T0YzpRyYBIqvmBujbs1dCYut+RbxjGYBNrT3ubboUbBtzW+CKZl9i2yXUh3QyRqhiftryzyACKaH4NRJBaLsQpTQRm2+8kuctM2J0DfhqBjeiMMRMWJuf5QL+23aL8IijalqUF9pnLXkXpQHPRKzJPQOZniotsdfTW/n8GCWRNUm0oYvcP1kBHJ42864/4EcTNaHznmpC092Pv8Z0B2NHfgc8LOYikKnuzun1weTT8eDWvUbpMFusIW52LNVp5YdvXWZ/XZk3GGCmdAyGQJTmoDZ0lum4QjQQ6UjlNY3XXABbXYvq0dqCABJye7upgbxs7vR9cjyHNvDyKKiMjYsINRd2+7DQemrfs+d7yvCivCN1A/PCIoP6fzdiFmrMJL2shDg01XvIc9jFQVW7hP0bGBpZgHAo1AW3V92sV6UtxitxtaVF6Zh4I69+c335NjKWqfdxy3KbC33GUSNkmEoiuzXgVsyxxKB1DNTkbYUfFgHk9skm/j1RwizOnwpUTuzRlOo6O8ULQghz1GIm46syDNOnX5K8SU+XvUB7kmMJjrZzqsF9BmyFXaWUjkH9FGC6Sh6wAf4o2l5WYyAaNGlN+Gsp2eUlCbewizsWKA+jTcOLyt983e6qyoF+8a2LJKJw7EYjvq6Ff+jtZZrSNgv6E8ylHBiXY4OI2QqZU/DADydryf9/x9h+
 74UuLFXb
 +TfBTWl7qfctxGTPbitsoB5ukYt8GmGVVnPwd6111NHrUNhMzAje5958zQdO7Blp91p/Y4f9nR3xtgFRk7DRkOk+lMf6LPr3VAkel/Lz4iIzVhHg0L0y3uQOUk1NR3Ea/ZjvZZSfq05Thfcp0he+IacNDDFJeZCOEF+L2Nil8d/MuKikSJnEfWXOC1mHndDQ37jBPyMYXrNblVlr5kNfhpWYjCwsHZukuvoyJ+N6xhvclmY7cB61TmxLrkI6/LdVpdpg2Y1vDZ2QP7hTyNooUmeLBid8HE4+oW8GzBpfTcC3pgQM0QPAOms3zExJSAo0Y1H1VDOln1OTdMGSfzQiFxyutK1I8vYhfCeK+OvRn35BxH/6YVXgGGjwaACJFCh875qBT1LgLexHn5Z5OcMGg2a+3YjzEoA0ckiaZoB5Gb664WFCrcyx8dRbR/fbr4t3Kws3FDDwGdi4CRZ7HLXItRQ0gB8dH63xHGsiS
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add a folio-based counterpart to page_snap_context() that reads the
snap context from folio->private directly.

Convert the three writeback paths that passed &folio->page to
page_snap_context() to ceph_folio_snap_context(), removing three
open-coded folio-to-page conversions. No functional change.

Reviewed-by: Matthew Wilcox (Oracle) <willy@infradead.org>
Acked-by: Zi Yan <ziy@nvidia.com>
Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
 fs/ceph/addr.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index de0113b23940..3d86e4c85b06 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -75,6 +75,12 @@ static inline struct ceph_snap_context *page_snap_context(struct page *page)
 	return NULL;
 }
 
+static inline
+struct ceph_snap_context *ceph_folio_snap_context(const struct folio *folio)
+{
+	return folio->private;
+}
+
 /*
  * Dirty a page.  Optimistically adjust accounting, on the assumption
  * that we won't race with invalidate.  If we do, readjust.
@@ -758,7 +764,7 @@ static int write_folio_nounlock(struct folio *folio,
 		return -EIO;
 
 	/* verify this is a writeable snap context */
-	snapc = page_snap_context(&folio->page);
+	snapc = ceph_folio_snap_context(folio);
 	if (!snapc) {
 		doutc(cl, "%llx.%llx folio %p not dirty?\n", ceph_vinop(inode),
 		      folio);
@@ -1183,7 +1189,7 @@ int ceph_check_page_before_write(struct address_space *mapping,
 	}
 
 	/* only if matching snap context */
-	pgsnapc = page_snap_context(&folio->page);
+	pgsnapc = ceph_folio_snap_context(folio);
 	if (pgsnapc != ceph_wbc->snapc) {
 		doutc(cl, "folio snapc %p %lld != oldest %p %lld\n",
 		      pgsnapc, pgsnapc->seq,
@@ -1840,7 +1846,7 @@ ceph_find_incompatible(struct folio *folio)
 
 		folio_wait_writeback(folio);
 
-		snapc = page_snap_context(&folio->page);
+		snapc = ceph_folio_snap_context(folio);
 		if (!snapc || snapc == ci->i_head_snapc)
 			break;
 

-- 
2.39.5


