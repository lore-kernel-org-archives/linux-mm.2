Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id C43FFEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:46 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 652B16B00AE; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5E90E6B00B7; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1722D6B00A7; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id B8D816B00B2
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 802EE874CA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.09.294B9E3
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf23.hostedemail.com (Postfix) with ESMTP id 4BD46140011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=QeZmxS4Y;
	spf=pass (imf23.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=JeJj0T69WHUPLsIPvgVGO/TfjBqV2iFp2koKUN8LMcY=;
	b=glEAVbRGDsblpvHXicO2p1OeUt0lU+6H4CU6uh+DSTognqi/cTU1b5zhvdDMNI/zVOB0mY
	8W51HtcHQ2qST3F7NA1c/E9LjimeypVvizldVqqNJo5aqSnMQLQAE2rruTG9hnyuS0daa8
	ucYLazlkCRV+rgnUX6XYC7Y1kNE1Bfw=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=h2nohVCqufafSrMpuu/BePqYaOQZ1pRLamhisPZRDtvfEQz62pTXGlkE5BcPDHBSLWn3Ks
	1ikixsfJvT55T64tJjDt/gZzfNUPXptGXvw0/fRlU/dstnwEVQUAPfqFoDEdjdLudD0ENA
	awsEpLWT2hzFdzuHQzKY0S71sgVa9PQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=QeZmxS4Y;
	spf=pass (imf23.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=w6c4PA3VGZ44yyLt8mghr+WTJ9TxkFa/GQpFHp0jaRg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=QeZmxS4Y9ZxzJ1P+c7PyBalRHGdguYBtzjQZ1WHuqnNfndJHBOWadzXneNpIO/Cpe
	 WtbDE01JXbjsGwDZW/SJl+0F8SgXDtITpS9jrWOZKuA2MxhvXL4esHAjK0cxyNxT8g
	 cX9nlCS2vI2XLhpV0lZEIvKvUcBSNRY+QxXEviZg=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-2367-7f0000032729-7f0000019da4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:56 +0100
Subject: [PATCH 30/61] net/sunrpc: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-30-bd63b656022d@avm.de>
References: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
In-Reply-To: <20260310-b4-is_err_or_null-v1-0-bd63b656022d@avm.de>
To: amd-gfx@lists.freedesktop.org, apparmor@lists.ubuntu.com, 
 bpf@vger.kernel.org, ceph-devel@vger.kernel.org, cocci@inria.fr, 
 dm-devel@lists.linux.dev, dri-devel@lists.freedesktop.org, 
 gfs2@lists.linux.dev, intel-gfx@lists.freedesktop.org, 
 intel-wired-lan@lists.osuosl.org, iommu@lists.linux.dev, 
 kvm@vger.kernel.org, linux-arm-kernel@lists.infradead.org, 
 linux-block@vger.kernel.org, linux-bluetooth@vger.kernel.org, 
 linux-btrfs@vger.kernel.org, linux-cifs@vger.kernel.org, 
 linux-clk@vger.kernel.org, linux-erofs@lists.ozlabs.org, 
 linux-ext4@vger.kernel.org, linux-fsdevel@vger.kernel.org, 
 linux-gpio@vger.kernel.org, linux-hyperv@vger.kernel.org, 
 linux-input@vger.kernel.org, linux-kernel@vger.kernel.org, 
 linux-leds@vger.kernel.org, linux-media@vger.kernel.org, 
 linux-mips@vger.kernel.org, linux-mm@kvack.org, 
 linux-modules@vger.kernel.org, linux-mtd@lists.infradead.org, 
 linux-nfs@vger.kernel.org, linux-omap@vger.kernel.org, 
 linux-phy@lists.infradead.org, linux-pm@vger.kernel.org, 
 linux-rockchip@lists.infradead.org, linux-s390@vger.kernel.org, 
 linux-scsi@vger.kernel.org, linux-sctp@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-sh@vger.kernel.org, 
 linux-sound@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com, 
 linux-trace-kernel@vger.kernel.org, linux-usb@vger.kernel.org, 
 linux-wireless@vger.kernel.org, netdev@vger.kernel.org, 
 ntfs3@lists.linux.dev, samba-technical@lists.samba.org, 
 sched-ext@lists.linux.dev, target-devel@vger.kernel.org, 
 tipc-discussion@lists.sourceforge.net, v9fs@lists.linux.dev, 
 Philipp Hahn <phahn-oss@avm.de>
Cc: Trond Myklebust <trondmy@kernel.org>, Anna Schumaker <anna@kernel.org>, 
 Chuck Lever <chuck.lever@oracle.com>, Jeff Layton <jlayton@kernel.org>, 
 NeilBrown <neil@brown.name>, Olga Kornievskaia <okorniev@redhat.com>, 
 Dai Ngo <Dai.Ngo@oracle.com>, Tom Talpey <tom@talpey.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2551; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=w6c4PA3VGZ44yyLt8mghr+WTJ9TxkFa/GQpFHp0jaRg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAY7O6x5f/jrEOlM2kM2YjYC7Xq22wW3Mikry
 9AY9ISieLCJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGOwAKCRA0LQZT0ays
 24W7CACaVIegavbFPh1+6gPSjqv5T1Ou5hQU0OcaZ20nx5fdOimad+jK3UuGfZrC9Vgv0QMm0ym
 3OSuSluEWbuIv6zcFp3UbdEj9aI7TM7en4Ha7pCkmDfNfPts09fhhi9VrPo390VGOMeNWeVMtD/
 CQde1U2q7DKI3QtGXyjY9I//uCPpAfeRw/e0X1QSKZ9eOdV+c4uWgQhNCPrPJZrHvycJx2lFn3Q
 ZNRGEplISNXY/bb/iuclRgqFYvGWnoUgBYQkpTrGJqDvFREwT8LcHN3+0nwKoz0xIqQbO7gBWgt
 +Dgbc3vk23keeP8aHFv6AZ7K16GCQyMm+zwDBr92eUq+pHvN
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-8A498E1F-7900509A/0/0
X-purgate-type: clean
X-purgate-size: 2553
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: conw85gtahsw18k7eebx3maezsufzmaa
X-Rspamd-Queue-Id: 4BD46140011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143731-176813
X-HE-Meta: U2FsdGVkX18dSH2IdLeyz/WVhapJQ30k3V3ajZOL/PAeGr+l/G84aZgtrDQ7GIykRnWtcSqCoJiOSwQiM+KdwM8A8lkOQIt/qhXY8f1gfJ7Wbe7ED+dH8emTxoJMBX/IZ2zTrvs15uRX27YxcYA2x71CsNxsCUe22T0e1eJct3+Q7GlZHRc++jAlJeLfnJ8Z/IyEGHCJBPD86eH9Aezum2nV8/L9yTvu1CeddPoNzpXrJxyq9FFEHizV+tUYtfvT9ZXvK9VapRBGJ/YrBXnmXnrKyaX3RR1WRunTR/zPmsVWZOfGsXskX/knZ5K3LA2maMRtHwz/t8UwQzlX0+LYlCim7nraOYEy5VfX59sJSoWBqwMcuQK0tjq50O5/3zHmJ5u58/VNl9AY6ZJpSkN5WEbLS3SkKM2JPbh+ipuiHyapPAxb/AzNq/XXvv0UOsLoLoYlqeGPJgIKTSU83t7QBOVU/ElUEqHm7T/3SfzOW2JPiSAhbS0ZunZKw6M+JnDzCM101nbs4g6W67cT67qPlVY3Jbk8gkrZm21fDV/M6TLxsTCWDj1bIUc8rb9fcZgeAZVEFjQrm/uj4MgSPuBXgaV5j1RzN+ypdrDXmijSAUBzgnsk76h0cLl5eoBOGkijTTAJU2TwNiNGRUgoikwJpND3egaYMvc1vHiJvorNuASozbKHz6KiA3toq476+roRYBMny+tsFxaFFtnG3Z5NYimRxto3qfASYHOTM+O4IAoWpokKJD98dXh9jT+7jX1Ac61P09x4YnGwCtypmDJULzscFru3FbhKVSXcceu6z0XkmZE0uoz7w4DNR8tleommzwUvIKeS/JHuGrcurYxZuQc8j0/TxYS5jDCcgDE4JR7M04fGHJx48j1VWKQQQpZcJLFkmzAoAxGTY2JPMQvvTq4QwPpEiSE8/sdpjU12u8ypW4WVsGan4bYBNto3D3ZTlrzvQco+gmbi9NVdItI
 BIShvSAM
 KKykou9TkTo1i7dj+sa8SaF7T1WX2YJ+CuOqRvxEXdXGzyXO98zYi/4CS90PLazsLB7opwA6/k3bOIFi+qEzqnq2PUIHhtGEq9zwj7j29m3N0RJqAeT1ovoVtW/I2gt/78O63DP7tWHV723a0J7QZeKt4tWoq7ndFLpEgsch/DikGvQ3PmJ+2mhepGgs0jDci0SOCx5cZReEn2PVc+PENrfpkCuOleNoXzrqoCc37O4on+fpx/t16F6wWNP5RTjGA7k34H63X45kz3xL29zeiMiZeHrivHAMpWwLjliKj/QKEMKK3W1x5tGJonzmDmI+OV+vSuLCWbvGcPkUINhzCK76+PrkKkjmwkeqzCdpIPUjRXRQFAOYi8MBR94VAsRVuD8EiW0LDYeD/V9r2fkHmKVbGK2MKIL3b5BK8q4Y2+7WCG8fHmcpbHvfd67SPQyIulcUTWzUu5Z7jcqUcHpXRVntpb8W4qPRxCG02s4vF6XuZfF8oIerus6CU0P1H7h1+jvpmhM0XeoAszIV7vSCLNqAkKuArzDx9qkpSMyzJTcgOEdU=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Trond Myklebust <trondmy@kernel.org>
To: Anna Schumaker <anna@kernel.org>
To: Chuck Lever <chuck.lever@oracle.com>
To: Jeff Layton <jlayton@kernel.org>
To: NeilBrown <neil@brown.name>
To: Olga Kornievskaia <okorniev@redhat.com>
To: Dai Ngo <Dai.Ngo@oracle.com>
To: Tom Talpey <tom@talpey.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: linux-nfs@vger.kernel.org
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/sunrpc/xprtrdma/svc_rdma_transport.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 9b623849723ed0eb74b827881c6f32d3434c891b..b4d03e59a8202f20360cff1e2e79b1e325396517 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -578,7 +578,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
  errout:
 	/* Take a reference in case the DTO handler runs */
 	svc_xprt_get(&newxprt->sc_xprt);
-	if (newxprt->sc_qp && !IS_ERR(newxprt->sc_qp))
+	if (!IS_ERR_OR_NULL(newxprt->sc_qp))
 		ib_destroy_qp(newxprt->sc_qp);
 	rdma_destroy_id(newxprt->sc_cm_id);
 	rpcrdma_rn_unregister(dev, &newxprt->sc_rn);
@@ -608,7 +608,7 @@ static void svc_rdma_free(struct svc_xprt *xprt)
 	might_sleep();
 
 	/* This blocks until the Completion Queues are empty */
-	if (rdma->sc_qp && !IS_ERR(rdma->sc_qp))
+	if (!IS_ERR_OR_NULL(rdma->sc_qp))
 		ib_drain_qp(rdma->sc_qp);
 	flush_workqueue(svcrdma_wq);
 
@@ -619,16 +619,16 @@ static void svc_rdma_free(struct svc_xprt *xprt)
 	svc_rdma_recv_ctxts_destroy(rdma);
 
 	/* Destroy the QP if present (not a listener) */
-	if (rdma->sc_qp && !IS_ERR(rdma->sc_qp))
+	if (!IS_ERR_OR_NULL(rdma->sc_qp))
 		ib_destroy_qp(rdma->sc_qp);
 
-	if (rdma->sc_sq_cq && !IS_ERR(rdma->sc_sq_cq))
+	if (!IS_ERR_OR_NULL(rdma->sc_sq_cq))
 		ib_free_cq(rdma->sc_sq_cq);
 
-	if (rdma->sc_rq_cq && !IS_ERR(rdma->sc_rq_cq))
+	if (!IS_ERR_OR_NULL(rdma->sc_rq_cq))
 		ib_free_cq(rdma->sc_rq_cq);
 
-	if (rdma->sc_pd && !IS_ERR(rdma->sc_pd))
+	if (!IS_ERR_OR_NULL(rdma->sc_pd))
 		ib_dealloc_pd(rdma->sc_pd);
 
 	/* Destroy the CM ID */

-- 
2.43.0


