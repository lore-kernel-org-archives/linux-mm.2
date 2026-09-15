Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 03D0BC88E77
	for <linux-mm@archiver.kernel.org>; Tue, 15 Sep 2026 23:42:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D11FC6B0092; Tue, 15 Sep 2026 19:42:45 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C9D3F6B0093; Tue, 15 Sep 2026 19:42:45 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B3C826B0095; Tue, 15 Sep 2026 19:42:45 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 7D3E66B0092
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:42:45 -0400 (EDT)
Received: from smtpin14.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 28FC41C2963
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:42:44 +0000 (UTC)
X-FDA: 85217623848.14.E3606A8
Received: from mx0a-00364e01.pphosted.com (mx0a-00364e01.pphosted.com [148.163.135.74])
	by imf07.hostedemail.com (Postfix) with ESMTP id 977EB40009
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 23:42:41 +0000 (UTC)
Authentication-Results: imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Oe2VLdiG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=J9M5IUiE;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789515761;
	b=lKIn9369Q1AG1aje8vtD5pSfhMUaggsPErLJy7jMIWiUv+92LS9ce4Mqelfmn+TkDgBCvA
	PwvEfXAjdH4g5cAlkEr4uAen1ys0qiHxCymqedsqKKLtzX5EeQMFNiih2Ua+wU74amIQia
	9BigzWmX4J5faTVb4XTyDNcv9N0+RwU=
ARC-Authentication-Results: i=1;
	imf07.hostedemail.com;
	dkim=pass header.d=columbia.edu header.s=pps01 header.b=Oe2VLdiG;
	dkim=pass header.d=columbia.edu header.s=lionmail header.b=J9M5IUiE;
	spf=pass (imf07.hostedemail.com: domain of tz2294@columbia.edu designates 148.163.135.74 as permitted sender) smtp.mailfrom=tz2294@columbia.edu;
	dmarc=pass (policy=none) header.from=columbia.edu
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789515761;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=uZE/najFT9R5zTEBz7Fhsb26kJqZDk8owuOeuq8Y1m4=;
	b=2oeAIFBiKR+chv7k291Iz2TdOEC8s1Sk5zqNE6u1NDc5BkVoMirDUgsziRnwO52EE5i85C
	zyjYRfURJ1sPvrNdh5+brz5WGuaa8JCOZv4VrZQABaGs07M4nKN+Vs9sHl/8P8Hp9QRFSS
	inJTOsRmbgzj981RoEH4uCwFXzudH8o=
Received: from pps.filterd (m0167068.ppops.net [127.0.0.1])
	by mx0a-00364e01.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 68FMcV5g3385848
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:42:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=columbia.edu; h=
	cc:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=pps01; bh=uZE/najFT9R5zTEBz7Fhsb26kJ
	qZDk8owuOeuq8Y1m4=; b=Oe2VLdiGVsKZ19PvlL2qhCRXsxSeze/p+R148PoKqk
	JQU/6vxvqL+/5CyvNmq2sQGAWD8vVOmyvHNISYnC9p3ROhXQnEreUKiaMH5vYHrx
	kDhMOv8vW/a+eatdK895SrrI4ycPRWs5yTEjZ+BZil5/f+Nnk91NTJQhfRcyR9ji
	CNOZ+aL8PXpF6epP7fFhIzf6sBllao8JxnOoACzvuMLEG1MlsW9KUArXfFrVMdaV
	PA0luBiyaa6kC7X+G/Vvc7YO0fsSf1t1qeDAZ2qhGMXPYJV3xqsa/cPyVn8q1nuF
	EUK6AdtpUGXuLk6siHS6BHAraJD1j9x34g3Z/hUl5ELg==
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com [209.85.160.197])
	by mx0a-00364e01.pphosted.com (PPS) with ESMTPS id 4gqbjfagff-1
	(version=TLSv1.3 cipher=TLS_AES_128_GCM_SHA256 bits=128 verify=NOT)
	for <linux-mm@kvack.org>; Tue, 15 Sep 2026 19:42:40 -0400 (EDT)
Received: by mail-qt1-f197.google.com with SMTP id d75a77b69052e-530d86d40acso101082891cf.3
        for <linux-mm@kvack.org>; Tue, 15 Sep 2026 16:42:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=columbia.edu; s=lionmail; t=1789515759; x=1790120559; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uZE/najFT9R5zTEBz7Fhsb26kJqZDk8owuOeuq8Y1m4=;
        b=J9M5IUiE9B2usJVC0swxUGqju7N62Sr0hUNJZouJK/Yd+wCLJH6C4v64SYCKiGT+Ne
         /UJRu7T9gO87siNkiRPvoB9313ObkUwHV0H8ax0LtTMUn1aZOKApvog/a1vxc0pNCV95
         xpufXlU1BpVsYzgGRmKy5PNkGh1rBWZdlUVIFttKskzX2jeTp+6sUukHrtVrzERAnFW+
         qG0nR3LdLDvKDXK/mbM6ji1JvvfyjDRvKQIa9J1/iZQC1r1BjafburMJzVjAzh4UC8c3
         qwchpqx5Ej3CleyXvhb0ylV2hXL3wAoGDZbLemt7KwNZhlj/UNDpQDAGBE6NlHo2nQJ1
         z8GQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789515759; x=1790120559;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=uZE/najFT9R5zTEBz7Fhsb26kJqZDk8owuOeuq8Y1m4=;
        b=ktgH/fGnbtFl4osFcsNRQUmh7sO66btrA0pzY1S26HwfA74rYqB+B/wC9KrPQj9qc+
         8vvNmEa3+T8+lZX7E8PvKze15FUgNs2gXI00jm3TMTtcGrxG2ZIjQ/UiKZ0/yUemQ2Rd
         zGHCYBLkuBFvGM11Sv8Dov75N5Aq5D559JwNgjS+UM8wFS5/BrdQbAonAJi3ldbJQG0G
         W5BFHincOrSxT8sUYYN9kktRVeytGI0+HrxfoaQLh1A/Mads70rO99HFcmOBxEnYpHBo
         0+UH0u0LHqHmV8cVHuvcKqjUWwdK79/SSOemqLp9Mp/Q3qGtvpbvN2t9BAruUkXF1PYq
         ZW+w==
X-Gm-Message-State: AFuF++nPn14cZbylh+eIlLCioN92OxNCyuu7nxSRtyMueKv72dGMwCcL
	MSB/hhRehjMcc8WEnaHFBs+t4mo9eXTsCP+b5AASNGLvaCRGZgRk6g+ZU1XhkE3o2bwZSOPaeqx
	faB/lCwY1QOR1ag0Dj6ZEKKF2/PDtNJUBaHTC4ZUOKTf5zJtm
X-Gm-Gg: AYBFou3WxowdJnN4pzGvkJfuAfdFajXGQyD8e0deBYkJa20Liv9oLLZDy35dWc5rco6
	L+ohqGW63AhT7/MtBf3GMcUOpJQRh3H2aWilUBzdqS2/wfZO5frrryGGyiTp/RHikPyD5RGwk/i
	idbhHwUOeLgq392r5Bfx/uQx62ytoGrkkYVVeGhcLkhczrc3ub7DrH7YKxTeTIMKUVohq2IHfxr
	TCjvC8UfdeBLfuz1ZlmsEjgEMe6tH936NnqeYlE+EE7+c8wHwuHAG0DOA1FvCfgJuZ+rs2qfJ7d
	lPbtuL9SGG+WmjVxIU0NC8HAawGsU7PPmmgyA6ZcTh9gxs1g0HiGVWmhVN2POspq8WC/+ST/RwO
	X9JcgJA98eNLgNMRpw53pwJ/qI0mm8Fr1+oKBSXG/2ahlodcG
X-Received: by 2002:a05:622a:14d1:b0:516:e10f:7140 with SMTP id d75a77b69052e-5327f1aaad1mr8805231cf.35.1789515759166;
        Tue, 15 Sep 2026 16:42:39 -0700 (PDT)
X-Received: by 2002:a05:622a:14d1:b0:516:e10f:7140 with SMTP id d75a77b69052e-5327f1aaad1mr8804961cf.35.1789515758797;
        Tue, 15 Sep 2026 16:42:38 -0700 (PDT)
Received: from [127.0.1.1] (nat-128-59-179-204.net.columbia.edu. [128.59.179.204])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-9123be7f316sm11399396d6.25.2026.09.15.16.42.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Sep 2026 16:42:38 -0700 (PDT)
From: Tal Zussman <tz2294@columbia.edu>
Date: Tue, 15 Sep 2026 19:42:15 -0400
Subject: [PATCH] vmcore: convert mmap_vmcore_fault() to use folios
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260915-vmcore-fault-folio-v1-1-a0cb6278670f@columbia.edu>
X-B4-Tracking: v=1; b=H4sIANbXqWoC/yXMQQ6CMBBG4auQWTtJHQ2oVzEsoP4DY5CaFogJ4
 e5WWX6L91ZKiIZEt2KliMWShTHjeCjI983Yge2RTeKkdFdX8fLyIYK1mYeJNQwW+NyeLgKoSim
 Uw3eE2uc/vde709w+4affibbtC9g6lTh2AAAA
X-Change-ID: 20260907-vmcore-fault-folio-4b382eeff262
To: Andrew Morton <akpm@linux-foundation.org>,
        Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>,
        Pasha Tatashin <pasha.tatashin@soleen.com>,
        Pratyush Yadav <pratyush@kernel.org>,
        Dave Young <ruirui.yang@linux.dev>
Cc: linux-mm@kvack.org, linux-s390@vger.kernel.org, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Tal Zussman <tz2294@columbia.edu>
X-Mailer: b4 0.17-dev-db0b7
X-Developer-Signature: v=1; a=ed25519-sha256; t=1789515757; l=2125;
 i=tz2294@columbia.edu; s=20250528; h=from:subject:message-id;
 bh=dxg52INW+Mj6Q6Lb2jquqMFPjl6/Rh2+AATGon4TcZU=;
 b=vdxoyuEon/H05Tmo1Fpa9qQA+JGXLiAWR1tlAA1+IiA+X8bmd6jRJvtBx0LctZl43TGXziRTe
 +GTwRByLmR/A0o+4UaXDSlvV8ydx7axk3vRrDxpQ8p2sw2e06k6g4vx
X-Developer-Key: i=tz2294@columbia.edu; a=ed25519;
 pk=BIj5KdACscEOyAC0oIkeZqLB3L94fzBnDccEooxeM5Y=
X-Authority-Analysis: v=2.4 cv=fNCsTpae c=1 sm=1 tr=0 ts=6aa9d7f0 cx=c_pps
 a=EVbN6Ke/fEF3bsl7X48z0g==:117 a=hXAsoc/zAxyCEdIRhrpmVw==:17
 a=IkcTkHD0fZMA:10 a=VdqzKS8jKosA:10 a=x7bEGLp0ZPQA:10 a=A0y_DWxS2BwA:10
 a=VkNPw1HP01LnGYTKEx00:22 a=Da8U98TiO7q1upZEImrf:22 a=usPcmh10W0ubT8QP8_c3:22
 a=LFCUUKIxLatyyoosy-EA:9 a=QEXdDO2ut3YA:10 a=a_PwQJl-kcHnX1M80qC6:22
X-Proofpoint-GUID: QB0Xnaf0rc6h1oInofa8VW5IyupI6-0d
X-Proofpoint-ORIG-GUID: QB0Xnaf0rc6h1oInofa8VW5IyupI6-0d
X-Proofpoint-Spam-Info: AW1haW4tMjYwOTE1MDM0NyBTYWx0ZWRfX0AtVnbMI2YU8
 JDhzjD6NbRNMyY74hP4DT3y7v2JYeNZ3W8LoBMHuZVvWVMXAU9Wbqu0658RbaEIFNVaecjFZNbS
 e2Al6Sukj6Kd085k304gIORhNcEamWIs0LLftv7YjcH8PeILA1gf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwOTE1MDM0NyBTYWx0ZWRfX2hyjxXiMEVjG
 gN54VeXx7gLgiCu5AoyJ+284I6MGOeCL6tHvooppswrzb8e/0ZYNRR3NYdtpnm9A5EBA/9aOlm3
 aSJY1PARmPjyAsSe9kb4fGgQH8bIG/eoGrfsnUhDvvBep6v+qhp86CiNqOPDuu/SCpGQK4PwiRZ
 /hUZey8YHt0kaYVE3Rgww4gwsX1ZD1WvOKQoqc4J+ODGN5WAUwaTTWHq6Wzn//9upzo165FAa/l
 OzP8dAiYuI/NI0yRVuJ4n9jQzT7d1v8Y/G2HBI6emab8JEo5a3iCwjslaHBHTkHsHo2odoHRS68
 8dWvHE7V2e/8alJuVm5KlA6Ef0cqJ8+W+OW9ZnzO0L1AcmppTBqPCCZlb87faW9fxDo+2F+k6bW
 BMPkUv1H11f7xl5TB6VA9a4K00Y2AGP+KyfIKmw6BVQjuy4RhEUaWA3Wzt+THTUggS/Jm0XB0oe
 M2/Y9wt7kdvEEOJdp9g==
X-Proofpoint-Virus-Version: vendor=nai engine=6900 definitions=11906
 signatures=596817
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 suspectscore=0 priorityscore=1501 impostorscore=10 adultscore=0 spamscore=0
 clxscore=1015 phishscore=0 malwarescore=0 bulkscore=10 lowpriorityscore=10
 classifier=typeunknown authscore=0 authtc= authcc= route=outbound adjust=0
 reason=mlx scancount=1 engine=8.22.0-2609040000 definitions=main-2609150347
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 977EB40009
X-Stat-Signature: u6if4y3bbyboqp6hnccamos6jrq9qok5
X-Rspam-User: 
X-HE-Tag: 1789515761-993372
X-HE-Meta: U2FsdGVkX19av8EUqp7tueJVezdGFnH/3LLrbK0jDdfypPKO0ixno53OfF+jQ99gOQc8kQ+ST3PxVl4ehicykml1BT0K+0Gl8S/eE8/ElfDSdKDE+H5mNMn/pFhgsKtsEZBHvsUlG/hNveWr8jKT1LQRgtaLCU9Dr5OC3WXM024Y3lWyA3iCKHC++MKUucScSOBBLprcyZbSjR77pLbPl+5ecW5BLLhtKEPybUsJFRgagd11lbNhzn4QEq+3SaHZkW5z6TMg7YoQyRNTzF4UXD9qYhTrmr5kitDUvT1Vx/edKzvGP2wcPs8LrBfFEH/rn66bAP+fFPn+WJYx4JE4tQ3Ldj5s0/JMJa5R9NrGDdceh1MlKS4FSho5ZPd2ZOfYUJ8OtBOO+WGaWnDg24U3/uLxr0NGsbLj7TqVEz7KOfP/lIJhvrwnQOCHWvQS6/DEanDeEuY5UdKzOETli1hhDe99zrHOWm+lDjcvctc1hA9+iCMXngkGrU2eKt+DQRWpGRN9oaPYhWFdBz3zwkZ307m61sBuOOQ5ilu+XnqMxox94c1qCWWqRjzNiAPQXEYv+Ah8+v37KB3cFzY8tbmDt8/NQSvoUHQo9ZRbE07Vsc407MQx1vr4Bs0HHtpCIGjFB2rvvqcplkUUGWXOLSoumZ26ev3b0glfpn4JiMnmiftFVSxK5YcSheIWGZZkEJU5R+Sw4Q6dCJJabhZoKhaUwACUC1v93iNgl/6voVE9An3PiG7bacFoJIpMt92t6mPzqy9q658/jQn9qcR3K0v2lk+3beJDm8lzWqSrUBn0tn+W/wJ8Kr+rz3u2GzSgPvsKeeSg9wSq6aj17idNWey0dN3SM9BjOtCN5er2RwBr25TqCgAYlPDrL4z0PauK0KToVM2LGL4M4/JziTKJk0Sb23n1ISS1FCo1ARRWJvWxirBRTCxIgrIWX26eyTx2hsZqFfPf93J50oKYJmKDyJ1
 8DURB17w
 EAAoqmXV3W8PkrtlRETZD3NvAhoUAkPFxvewZj44FcW0GAPHkq7e91SehbhdDreYZlVWAIdzPVRlflIqxZM9YXpQa3TJJD8pOY+BLqXO9hvb7Yq9p+Q+hdh5cnybnbdMNAw+CT9xJxZ2NuzyScxiFUgkLiTPu2bNrn2DOZURzeNYNH6uTp2fzr119UmIDvK6CWn9fqV+y8M4Jtmy8z4gFNltCHr6ZCQdpJHX+Uzyg5Ss4EgMV3i6+6rv+Ph/f3/mVfm9pexwotvW4uhwMK25yf69mwV2vvlxL6RJvOICNcn4z0agv9c2rsT5LxTITLvCDS3Tyt96/l7Zx7UvrWissAZQ1gbLTjHnq3A4SUpHYeq9+ORGBKlpY08Jtk6+qHZOt0XVLHmBxHmH9dYRv3twdckz+G917fGBWZZHeVE82WWCx2yY=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Use a folio for the page cache page the s390 fault handler reads the
old kernel's memory into. This removes four compound_head() calls and
one of the last callers of find_or_create_page().

The vmcore mapping only has order-0 folios, so the logic is unchanged.

Compile tested for s390.

Signed-off-by: Tal Zussman <tz2294@columbia.edu>
---
This is based on the kexec-next branch of the liveupdate tree.
---
 fs/proc/vmcore.c | 27 ++++++++++++++-------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/fs/proc/vmcore.c b/fs/proc/vmcore.c
index 44d15436439f..2dc3803aa11d 100644
--- a/fs/proc/vmcore.c
+++ b/fs/proc/vmcore.c
@@ -474,29 +474,30 @@ static vm_fault_t mmap_vmcore_fault(struct vm_fault *vmf)
 	pgoff_t index = vmf->pgoff;
 	struct iov_iter iter;
 	struct kvec kvec;
-	struct page *page;
+	struct folio *folio;
 	loff_t offset;
 	int rc;
 
-	page = find_or_create_page(mapping, index, GFP_KERNEL);
-	if (!page)
+	folio = __filemap_get_folio(mapping, index,
+			FGP_LOCK | FGP_ACCESSED | FGP_CREAT, GFP_KERNEL);
+	if (IS_ERR(folio))
 		return VM_FAULT_OOM;
-	if (!PageUptodate(page)) {
-		offset = (loff_t) index << PAGE_SHIFT;
-		kvec.iov_base = page_address(page);
-		kvec.iov_len = PAGE_SIZE;
-		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, PAGE_SIZE);
+	if (!folio_test_uptodate(folio)) {
+		offset = folio_pos(folio);
+		kvec.iov_base = folio_address(folio);
+		kvec.iov_len = folio_size(folio);
+		iov_iter_kvec(&iter, ITER_DEST, &kvec, 1, folio_size(folio));
 
 		rc = __read_vmcore(&iter, &offset);
 		if (rc < 0) {
-			unlock_page(page);
-			put_page(page);
+			folio_unlock(folio);
+			folio_put(folio);
 			return vmf_error(rc);
 		}
-		SetPageUptodate(page);
+		folio_mark_uptodate(folio);
 	}
-	unlock_page(page);
-	vmf->page = page;
+	folio_unlock(folio);
+	vmf->page = folio_file_page(folio, index);
 	return 0;
 #else
 	return VM_FAULT_SIGBUS;

---
base-commit: 4d17a004cfd5489f88ad0a7a151dea11a533338b
change-id: 20260907-vmcore-fault-folio-4b382eeff262

Best regards,
--  
Tal Zussman <tz2294@columbia.edu>


