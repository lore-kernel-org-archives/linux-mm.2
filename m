Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5B51FEB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:06 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id CF1226B00C4; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id AB54C6B00BF; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 796AB6B00BE; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id EA97D6B00B6
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id B8C9F140141
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:34 +0000 (UTC)
X-FDA: 84529998588.09.82397F0
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf01.hostedemail.com (Postfix) with ESMTP id 7F31340004
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=DinAmxq0;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=aTXKOI3Mh5/vrUWd7n6fziwiH0BpgJQteVCBFTyW0PA=;
	b=xwOSf6TbxJxGmeyyEUWrwIt+vsRrj9LiyP9GTJOHbr62Eni/wOoMXNYCMaoQ7KlQxYGbEd
	n09exO0uxfjGIAO+ipsWm+Nrl3zkxAXKt6Z9OHH0x0BP6060HsNVzq/Yk3aazQr9RBnakZ
	qQxWFiqGPTBfcBfvZrRowNvehc97J1Y=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=GNtLW4kCTBMe+VlcZv/8J8Q4Xk70TFR1oRVlC2fLNK/7rteDFxelqL20uuApfiqUTAzEnN
	nAJYuXMcIydBmrycT7c5C155c4TjGyPk6wkJ7om7Ys1oR7r3w+DsgzKmK30iCpnQh91VjE
	Lf9UC++fXFIBqL/v6Lf7DMLw8RoCfe0=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=DinAmxq0;
	dmarc=pass (policy=quarantine) header.from=avm.de;
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=xZ7JyJZFZn3iuOZoe5h922zZ5R4/JN/dDbwKPDTDpVg=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=DinAmxq0LdEBHgGBL7yN+mThFn/2Jhu9YOuH2jhyjRCQP7wX2xayjWDIl59Rrb4CK
	 4PIJ1T+7hTwTj8CuijTOHG0Dr5+uZ6nhOuL9PA+MuH5Ju5mtqzXJbLzXEHHZ0RMdiv
	 vPLvy7MaYVqTlmV0GJrDdkzJ4sI8MLKN5uuQ6tUg=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-b734-7f0000032729-7f000001c02e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:50 +0100
Subject: [PATCH 24/61] net/9p: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-24-bd63b656022d@avm.de>
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
Cc: Eric Van Hensbergen <ericvh@kernel.org>, 
 Latchesar Ionkov <lucho@ionkov.net>, 
 Dominique Martinet <asmadeus@codewreck.org>, 
 Christian Schoenebeck <linux_oss@crudebyte.com>, 
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=2017; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=xZ7JyJZFZn3iuOZoe5h922zZ5R4/JN/dDbwKPDTDpVg=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYnEtzR553dJZWqu5r4IUgVMywPaNyCn2Kl0
 rArZNDCQ6GJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGJwAKCRA0LQZT0ays
 22Q3B/0WDcaxg22CSV3J2yK2YCh66cZH85KFq38ggbwHyd5a8WjqQnka33Kdtc08oHARsU9ozqE
 P4ub42oqVPDyOyAfaW0nuVYHNlcCbmh/bxnwLHvjz7DvZynqqfi+81IpwDPL+nf3OHCqA45W3el
 wXFHM9DZ2DjwYG4MfnrZOmjwML1Qt1LKYUAR5WbU3bIh/t6NofmRATpZci0AEY2ACgSBKNBZ+xC
 yT5B0+MsE+np/c9UPC/BM2BZX3AZEATfPCVPaM5j6SGQ910wEhLc3aOja8ish65RkJANbgaQX9X
 HjK5HDFDjBbvCnKAA71XMeOX3I4/FbTzAL7Ez+9Tosk9xWKL
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-D2DE8A3D-E8744539/0/0
X-purgate-type: clean
X-purgate-size: 2019
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Server: rspam02
X-Rspamd-Queue-Id: 7F31340004
X-Stat-Signature: qfg1ctbrsy67zjo789u6sjik65sar1uh
X-Rspam-User: 
X-HE-Tag: 1773143732-999070
X-HE-Meta: U2FsdGVkX1/UVWodyr0nM23J9za8BxETsPJH/oROTXj6PkPzDjD6kl8sbdphyJPo4YCp7IdMB6UdH32zGrPIdG0f1vlOaA5BOIOy3kshf5jwegVZXQ/wq7Y8M5AbgdYBEcYwWB0KOFDSm7fvRcBbpM1UHIbbRsWYm3wH6p9jYMYZH4TOanUoBg8vBkW6izjlC9n0GhXm5wwHGuXrGSbaKFf4X78r9iODTwzdLryQso8/wZO/wmTLovq1VcpO2dNMmyhRzkZYgWfx8lAAi9wZrsnKZ86H2r0JE+iYfNoyOD1sqh7yYlrWGdPpuMufPu3dT85lfd3VBpjc092UKJi1dZr7IzGj+MTMGb32M1saC3mtcy7JLQ4zhrZqiQRQtMEDcCjl5rJVFRmraZwopfynCkqRpTxKLchC8tTZqIkDtS+cSuSBpiuRnJnSs+sWib3xY0iOoOLATDgegsv+ThiGEwdYVKQ8z8yxM0jRlQsA0HRZl6Mp3DbTkqt63hHYZKxLp94bC0aotYiYU3kFF6XR0XXAddKK70rTb5Q2Wue4YKonVrxqDF0MpPv5t/P8LzrdYjnW1fNxmaib9y4Pg4eNSHFUU5B92k3p5+7CgeJviPU/BMuK/Ch91RUUsM8wtQ9AY8P6Dhvsd2IrCZU++3IvRGasKIDV+HyNnacuSt9RutANrj1w9+dbFqncu/6TGrRc84t8vkDy6dswa9u5ZIplpvBxxfZFzSJANtTwworkzmz7UTBM6YIH8aX5szc/OQXx1/VCmJ5j8vFg6jHTv8ONXoxTRRulY7FzKq+TKy9fH5z/ueeqLm3M0JzqsJpKBLXX34nEvufG6QRrCwenx1rVnZoqTtfYta0mObPtmF4ZAjq9KxNIyaxLvYAu3395lNi7L4ZxuhRaYOEs+ErQ6+1I6tXsIDhown0I2nnMg4vy56VMOnSLaUWL5RJxQPqrK8QcMglqMnb5P075bDSR4El
 TweZeCnH
 8Il67NMbJXuhYPkqrONGulADMcdd/PZOSYPRDOH6Txr0uxKefkf21f7xKg2rUvpmAaJkt6MENRT9Kk5fn1VKut8fXEkOTMQ/iQkEwLT4dQrDRyITFtvXXQZ3WNg3JTgZwGEdWOywvpZfm28zyyUdCS6XgzFYR4OcJj6upIO+IWV+c/Z4p2dULesJOT3Fu+qhRgyCkUgidj4BZE+s6snEV1smSzuiyNOdRiO2jEVsiTEYjRQO3IN8cULSl79o/SRbZVmLzUkOl+V6VV6d7Owmw5MMXNPruuPD1cjPIzK+ovvsK2XhuTGS26dGyhxIHJUoBECH099gaE1TZRHTY/rT7DhRi4vp/kvXhx148jmLOSg1IQz4+z8ClB5GbzxIVu7IXESEWOpOIEMuU9zZzd1/h/ivR8zhMCZ8HSLZQuD+MqYVHqAk6+Xj+jXz0QSTSTUrod5r3KY9ei1GF9mreME8SyWHwY0hOTI9znQ4ZOXSsi8bJgmzZ2v4YeMac6wgN66GCCf2K+xemchIfeAywkuJOGoSOQvKyXxXmOMLy6/SNrCn90MqPBFntDk+h/hQfTDJZk44JCU4cz6+2DhK98GrlaLWFWBo+i/R9C8s6UAhcy8OGHFUNqLLIRFbT8J8FE6T9/U5hzHO6OYT+YPQ=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Eric Van Hensbergen <ericvh@kernel.org>
To: Latchesar Ionkov <lucho@ionkov.net>
To: Dominique Martinet <asmadeus@codewreck.org>
To: Christian Schoenebeck <linux_oss@crudebyte.com>
To: "David S. Miller" <davem@davemloft.net>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: v9fs@lists.linux.dev
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 include/net/9p/client.h | 2 +-
 net/9p/trans_rdma.c     | 8 ++++----
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/9p/client.h b/include/net/9p/client.h
index 838a94218b593f3fb19e6827c472753380193461..4bde6bd716f323c819745e64c7aac0dea7beb72f 100644
--- a/include/net/9p/client.h
+++ b/include/net/9p/client.h
@@ -364,7 +364,7 @@ static inline struct p9_fid *p9_fid_get(struct p9_fid *fid)
 
 static inline int p9_fid_put(struct p9_fid *fid)
 {
-	if (!fid || IS_ERR(fid))
+	if (IS_ERR_OR_NULL(fid))
 		return 0;
 
 	if (tracepoint_enabled(9p_fid_ref))
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index aa5bd74d333f3b5e6fd1e4344d26bc0201ff7f7f..60461344b536bcb6e94112aace75a88b6a99ad86 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -252,16 +252,16 @@ static void rdma_destroy_trans(struct p9_trans_rdma *rdma)
 	if (!rdma)
 		return;
 
-	if (rdma->qp && !IS_ERR(rdma->qp))
+	if (!IS_ERR_OR_NULL(rdma->qp))
 		ib_destroy_qp(rdma->qp);
 
-	if (rdma->pd && !IS_ERR(rdma->pd))
+	if (!IS_ERR_OR_NULL(rdma->pd))
 		ib_dealloc_pd(rdma->pd);
 
-	if (rdma->cq && !IS_ERR(rdma->cq))
+	if (!IS_ERR_OR_NULL(rdma->cq))
 		ib_free_cq(rdma->cq);
 
-	if (rdma->cm_id && !IS_ERR(rdma->cm_id))
+	if (!IS_ERR_OR_NULL(rdma->cm_id))
 		rdma_destroy_id(rdma->cm_id);
 
 	kfree(rdma);

-- 
2.43.0


