Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 12825EFB7E9
	for <linux-mm@archiver.kernel.org>; Tue, 24 Feb 2026 02:29:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 5FD7B6B0088; Mon, 23 Feb 2026 21:29:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5A7B66B008C; Mon, 23 Feb 2026 21:29:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 4D4AD6B0092; Mon, 23 Feb 2026 21:29:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 3AE516B0088
	for <linux-mm@kvack.org>; Mon, 23 Feb 2026 21:29:22 -0500 (EST)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 075231B65A4
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:29:22 +0000 (UTC)
X-FDA: 84477768564.12.9972940
Received: from smtpbgbr2.qq.com (smtpbgbr2.qq.com [54.207.22.56])
	by imf16.hostedemail.com (Postfix) with ESMTP id 5FC4D180003
	for <linux-mm@kvack.org>; Tue, 24 Feb 2026 02:29:16 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=euvVEo6V;
	spf=pass (imf16.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.207.22.56 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1771900160;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=L6gGCDURJbi9D+++EtYTCKD6x84H1m2dP9Vpcs7fNgo=;
	b=Cise0JpqC/bF+pyx1Eh1KiU2NxZc2QuTBtoQ0rCEKS13PN7uZKYRcdlXQFiRUFFLbiguSB
	f8GW1I9RlcKE81YfPRv6diNb1OivPA8VnfjrhvF/IhT6aDWIz7g73l24a0K8pUGXFoB0OH
	N+Ph9gC2cM2vmgTlvEVp5H+WDGbjqkI=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=smail.nju.edu.cn header.s=iohv2404 header.b=euvVEo6V;
	spf=pass (imf16.hostedemail.com: domain of kexinsun@smail.nju.edu.cn designates 54.207.22.56 as permitted sender) smtp.mailfrom=kexinsun@smail.nju.edu.cn;
	dmarc=pass (policy=reject) header.from=smail.nju.edu.cn
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1771900160; a=rsa-sha256;
	cv=none;
	b=v50uci07G34J/0wP3P/mrxUucWviB8HwJzGI6DuW5kQak/lbqok7daLtDt32VE2kFhPKc6
	ZUYMOP/LwCCnA9ZnjvxBB1j17duu+jmmwJslNjV9gT995dXoFJs4igDko9fa2leXK8bgg6
	GpxPvsWF+9M7kiNMJfiPcFly7/irhMw=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=smail.nju.edu.cn;
	s=iohv2404; t=1771900127;
	bh=L6gGCDURJbi9D+++EtYTCKD6x84H1m2dP9Vpcs7fNgo=;
	h=From:To:Subject:Date:Message-Id:MIME-Version;
	b=euvVEo6Vub6me+dYcVKKhCeL5vzqHSGr1h4F52bMnTCL57DPE2PUjv50nQ0OEaR5z
	 7SwbTa36vxPOUcm+J058CVFOCnz606S7E5hXWvwrUF2xRFcmPAMQJBvl5rED/9NDGM
	 g/+duqa7w8zvilJ0jhwg47YBdwfDznGWH7dq/BJM=
X-QQ-mid: zesmtpgz3t1771900124t4a5b21de
X-QQ-Originating-IP: vaxd3IqHPEL5PZl/m1xBngUqWjiqMAJoXfpZt6DLGhU=
Received: from localhost.localdomain ( [116.172.93.199])
	by bizesmtp.qq.com (ESMTP) with 
	id ; Tue, 24 Feb 2026 10:28:42 +0800 (CST)
X-QQ-SSF: 0000000000000000000000000000000
X-QQ-GoodBg: 0
X-BIZMAIL-ID: 12279923767468614604
EX-QQ-RecipientCnt: 11
From: kexinsun <kexinsun@smail.nju.edu.cn>
To: muchun.song@linux.dev
Cc: osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	julia.lawall@inria.fr,
	xutong.ma@inria.fr,
	yunbolyu@smu.edu.sg,
	ratnadiraw@smu.edu.sg,
	kexinsun@smail.nju.edu.cn
Subject: [PATCH] mm/hugetlb_vmemmap: update outdated comment
Date: Tue, 24 Feb 2026 10:28:40 +0800
Message-Id: <20260224022840.1936-1-kexinsun@smail.nju.edu.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-QQ-SENDSIZE: 520
Feedback-ID: zesmtpgz:smail.nju.edu.cn:qybglogicsvrgz:qybglogicsvrgz5b-0
X-QQ-XMAILINFO: NdsFfOnJssvzppV8bQ+5cUt8isiDKo0d/MMc88i8/nBKj7MOVeHuOaOK
	Kh4fgBuHGv8WySQJyUMT52wvov+NPesIIp6uN+uAo4FA28MWjq+XwzZyzo6F0u9JE5XBrnp
	tM9or3kr2kDLY/TtQuKnaYFUUifDCLXPNNAmwIEV9dBbI3XzZFHFbdiknGFNuU8DnzG/cKC
	mGAC0SNA0JcqwMZMSTNMzvkzuNoOGwEpXp0wL6ftbObKsWp9f1UtHw+z1TcVOWpbW8EOZuK
	EuZYwPwDa4Z+EcaYfRMxnbKhoDMI+2FK28pVt9P619KhTpZsSPtfSokXIxLX82MyGLCW2mU
	x9IhMmInLWzLBxZ/veCN3X+CsuoRyCsbPAiqpV9CodCBfjKUAg/hv604U96SmXc0oimtD4h
	/dRDokslIqWrXlT1T8hTkm9JncrCYgfSCPaHk0Q9QEmo6t40bCPOLAASvYTDqrtQV+wy4Gz
	8Oo4fKyPLYUFR+bdx9X2Jfc6mI8syzIthICwuG62n5SAqsDHkYQ/Yc+3w9+3hS9Via1cTq9
	+Ky6MG7G23aomGUQVLKprwD+Bn4a2smVOrpNvhcCr54eRZ/BRmK3bTsffCAiug2+O9ilLpn
	PpzEFwrBi127J1jtcEORj91nr99hn3OME5rsqGfd7ITbY9P5eyKRkvkvV8sb07BF6kUQrBM
	bRlHkPsWnsJHVzPOFgCgXV8XWFF5a6+BoScbFBqC8FbvCGFgeL3BA4EI5NgbdR3Xkd8s93X
	DweHeAVVbEpguJcq+I1e0fvssrLYMoZAdZcDoWEylZMQrSYEhrF0xI9xd7Mq70GZiut0zkS
	LraYlQrSUmvMb1E1JMmhPqq7Kwhlw6a9j8LdmTc5JroxkiSc0wpDQRveqBT1fvYdBXL7lcY
	z/RfZZ5MyOTHaH6wKzeIju9yXUCtMeEVKhl0o42SUEUNgB+dZDaVILz4/tjfqz/cz5H8xho
	O1LQ9fKrwxh9bD3rGic20qQuiRARvtW5rsHw/ieBVd5Dg8KEDMEj6KibZMh33tYwyzJtX/q
	G3Q+fPL4p4g5TCZDal5byA3Fb/d7aL0F57qMEvbXWoxllPHbt38M459Mvl9AEYMv+xQslio
	06FDbNvQAYC
X-QQ-XMRINFO: OD9hHCdaPRBwH5bRRRw8tsiH4UAatJqXfg==
X-QQ-RECHKSPAM: 0
X-Stat-Signature: w48c8m8kew3chg7edm5zodeit395sxio
X-Rspam-User: 
X-Rspamd-Queue-Id: 5FC4D180003
X-Rspamd-Server: rspam01
X-HE-Tag: 1771900156-231746
X-HE-Meta: U2FsdGVkX1+vKgT2PiuLrYkrSdac3k1JTHWhD2rPEe2xec8VGCM5wjDqMsO5Jl5yMgkY+ZSgNWgCALdpcovLj0k82PUUhL9QxDfviZwE09RRg22PwQcDVov0vMovHgwkfq1v0tj0N+9PZwlv2+ZLX04auQ9uzRV3nE5/4cs5GvZZAIqEWtypnCnNilY+4NJcamOY0/WHFAREu2Zs5+IP/4VsskWvznIE0FZ+yWquxUFNWMQTx+D2KKX9eOvKJ9mtCf39wNM/qKIV8yiyaAhoe0zpQYRstDBFDPlEzWreNa33A6uhPtxhyRwIoGxNWWLNwi3/OyJmE36mO7ZTuzm2emyde32HPavRV4UrKAYtkhpvr06/FtU6lsD/YJKvDyVAAcqoSIJGWBrYGL0x9eQcZFN5nHOwVrIsLa+l1/1O0t22dmXAQQbQUSYT0r9H96yrjbP2Q9G1p7hmuW4/Pr2KPQw4pgJcAjEq+CbK7hGNmDWzBvaJvtN1eCzO+nANu7vdweUL8Rsdr5iuhfSAOJ6FdjvjPJpn9yhjG2Yt4Nlal/tHkk+ht+cs5q9ZCXZbOpiOvkZ5rrJOJIE6WtyYZDUzsLAwgSbvduBLecs0/spj9G5bd/TYknPvmastkfn8q22cWMdj696y719QC2FVC51bgBCHVIRs/CC21KW2ScvjhjpCulxTCP4+7rI4GyodtB1FBVN7P1EABRMjKt/4eH34T89mB6A9pikIWmJvpdOhylPdvFDBy+GZQ8JcO6lNuRvFrs0ZBnZ7+2mxWaQ5aviCiaVh7FLj+mU/ZyWucL/eFKRJ2LbVd2PKsSpuw4islk5/FPmIN0gHUh5IhAwKH4wqDwmrncXDjN3y1B41N8EJIoEsTqOgnUZycdnq6CGlgqGsSZCj0XDHrqC+0CzXMHroaTcG0ppWtnwmsK64FX+WyIHS5o7UFrtmnfi7zIzBOjU5dIqdyUhM9xIW5SEf6Em
 VvoTgsWp
 UyexFx4xDGJvbH+zYPf7RizJhkRGiOIPBCsp/GWMO12Hh52O1dDKjx6hy/kE5SGqZTyZkrzf01SPxHg6qLRswr8injou1r4q80EnXnnGM2Oe56ZtPrVwfJK6SL4nJjnsC4LVCT0mTJ7KtCIRBitb4yKCuloaszbbx7527w/mQnJ1FrqhanWG8GsKIEZUdJ+Mic+o0KY5k6hdbwMs3Tet5+W4YBs3pH3tPWSXRjbm1o9YPG0kj8ZYWaKtX+qaG/P0eixSmCCjlRjw1e6u22WkGV0r3UP3A+ZX0Qi5lMlq0mPIHzlOBzXCXqFVqjfc855R0Itoc8FjoGGUIesOQE8qrA/8bANhSfIs87ijP
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

The function vmemmap_pte_range() was refactored into vmemmap_pte_entry()
by commit fb93ed63345f ("mm: hugetlb_vmemmap: use walk_page_range_novma()
to simplify the code"). Both functions share the key behavior that the
reuse page is identified first before remapping begins. Update the
comment accordingly.

Signed-off-by: kexinsun <kexinsun@smail.nju.edu.cn>
---
 mm/hugetlb_vmemmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index a9280259e12a..5156e4038b5f 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -350,7 +350,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 	/*
 	 * In order to make remapping routine most efficient for the huge pages,
 	 * the routine of vmemmap page table walking has the following rules
-	 * (see more details from the vmemmap_pte_range()):
+	 * (see more details from the vmemmap_pte_entry()):
 	 *
 	 * - The range [@start, @end) and the range [@reuse, @reuse + PAGE_SIZE)
 	 *   should be continuous.
-- 
2.25.1


