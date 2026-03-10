Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 8322DEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A75C36B00BD; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 7F8E66B00B7; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47F226B00BB; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EE99F6B00B8
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin30.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BD2AD1BE73
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.30.6C57E1F
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf26.hostedemail.com (Postfix) with ESMTP id 613AD140009
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf26.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=IViq9CY9;
	spf=pass (imf26.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=g19AfTKf4q9FJ0WXDwCXipJJzRo8bRjXvJcmm21JHGs=;
	b=v6Adkovc2iH/fxV5aksEigRdf+i6lsHEPZGXkzBlO698W43UVXbThHPvEsyKZ2q/wWT3b/
	ERt+xFnBwR1Bvmp3naKuSaYabRNQxJ6oH03C1tDtO5vfCu4zRf2NRuAcqpeu0Un6O/LgWw
	KHkMTXaIEWfVM4yRbxg/+LeIskDfVj0=
ARC-Authentication-Results: i=1;
	imf26.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=IViq9CY9;
	spf=pass (imf26.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=giAsyIG85B66m2OEmgnBhR0nrD6EQ3Xz3CtpHNUAFOsgSjnzg/UcANj7xOZnI84MAuRO5n
	cDRXbCkC6OX4zbAHsIEcLkhrmaUVr8iJPDf50hGMkL26A3GWRLJDGuSS1muqo02fvqigXR
	zr7otA9jQeTuxds+wTSp4MId6xYipN0=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=c7VqPpX5FOMjU1fomf/slDzrk65Fe9+ZUNfqosDKTdI=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=IViq9CY9kXhTGFn2wUsXBESaNCGz69a5nG3mhGowHHuPZ1SldVYsbRj6+GmFeE33Z
	 /voEH0js7pDgeDh21Z+MjLukbWz6LUMqpwiLZaBJ7bgJ90kdMj+qEaksFeCP8FnFLU
	 ahCh3Altzen7MVBVZyzIJ7pSy8eLwZR3MIuEFpPs=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-2367-7f0000032729-7f0000019d84-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:49 +0100
Subject: [PATCH 23/61] net/ipv6: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-23-bd63b656022d@avm.de>
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
Cc: "David S. Miller" <davem@davemloft.net>, 
 David Ahern <dsahern@kernel.org>, Eric Dumazet <edumazet@google.com>, 
 Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, 
 Simon Horman <horms@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1558; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=c7VqPpX5FOMjU1fomf/slDzrk65Fe9+ZUNfqosDKTdI=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYkT2ujfxBt0/qzL4FNFAkOp+gWHYFk2Lkit
 DIh+cvm64iJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGJAAKCRA0LQZT0ays
 28wAB/9/0/0cpf5vUgxn9MJJYzgxi6whlUVZ+hEx14I9GPhNabUzF2GH9pZZve+bNpQXnutoTyU
 +K2sycG7CaZHe4KrWGw/XkousnHUY+/rbl34+pCGgHYhtioeCxrYnt9GpyhiDjCITZjPGFnwVQd
 tZoQ5ZBU+ihaHpCBS+WuTGNPnpJCCDmn98dooJV56KJmahzsCdhoR05xOLdt45OLH8bgiYvcsMo
 XA7dPRY2ZqI4sORPZUvgQgkReuo3OWATKHpGF0IEcgG6WPoIcp2tLoXu42clOKjzJCoMFBALo5l
 /DTaIDOUTWpiOr9bQY0VQkO8G6JfVgMRTCJghvSt33zKNrUt
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-85C93E1F-A15B4641/0/0
X-purgate-type: clean
X-purgate-size: 1560
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 613AD140009
X-Stat-Signature: e3tct6r64a8uxsf39koeoxqwpp9e5axg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1773143731-881692
X-HE-Meta: U2FsdGVkX1+5S8Z+RwkoKP+ZiwJQTL6Cytd/9yMoiUBe8ZPDHyttOYgCYieKvJpvhs8sRbu+hP0DLIeXZk62Qephl8F7Wmwmtw9FnSgZFDeWQuJ6t9vdFCIiH2STRh13QKxVxSlpzYl8ZM3IT1CvMVAryTlwq/ds3Z3jgYqnjAxqyygNQrXd1fsKFe4UrSf0f8vmXKVlqEDUbX7KNXp+tY+A5msMU9HdHPjRkRZvpQEN+yntVCTkmdxsamEOObHWYzNYrAs23d27jMRUEdweqpjjMjcctc/6osn+71QbXmhuGrqgXCQ+1CNNnaO8YB7BdOfXoyjEuvKUJ/sLoF6D7SRabRF9CIZJ+HDUu21fL+olWkjGrXdNp80fnpEiQK2TyKl8C45YApMZXWWHs/rXTED+mMB/gig8s2ZfUBl1s/ksB/Dbgfxb/fvj8G5PHY43FPZHEDjFlZ3j68OeaYdkVaOmWcqkDmlIfcAeY3bbuWl4YeK+dPTd7E22zXfbCYDsmgTL0s98Nbium/AaBCB6MAir1ViesdZeihCki/pf6k6gs669/DVmxwnvEcRrglVJQvJoxa5JkjTEcJAXLQyjuRAhFkH5Ib5wq79PuxJMTNPTgUrC2U/P1dm/ytZ+LHmbtL6RYTaPNzU9XbkZ4shDt51jMRW5Si2SHS0we2gPzi//qoMl1PLaem+OMwhQJG6+LeT7RoPN7L+XrIRMjQZNeS0fvY3EBPAcVWInO0qjtV6b+3iywee6PfwDUzkSW8pGcNb90Pmya/2KtuB6KReVczpi5BcS/7DoVmge40vgFfxMKqERQXVprtMHQE4xBsLb2XCrpQGrUXuiUlUlBqWqtKZsAamaBxCr3h4CzAI+vxrBdHJmV/EIg+JM2pehUh91lbiwINz7STIVN1y2/cvna3krslJp0okXHkKWiVmkU/lu+2tnC40rB1mcBQwytnwMfBt+BRUkUIF899tSK8M
 tEoU0rKl
 QJbnKI0SR3NBFMlavhiHBon+VACk1iih8bgwWLv6eYEDrgCp6+z9lHWz4qnGfwjxRkJUkmXhgfGBUlQplLspRTl2Ga/rpRevgRbpD57Zdw3wkZ30jPOf3fqpr1HWtBKFoYopxS7LHnc5J0Qgbq1oXMyypww7z56xY3oOzGirJPaGIPPE8SzENmsWrkEdXfL3mt+GxqLC/zQeQokIYjBhTsfyYHDRFS6+ssAY1IEBwFQNJZRaMzTOF79nxFxVPmLXnp3GTYZnlOQTLJJqlSD20YJyXAMuqMGmSaTcXbC2LQxxk7d6szAatUdcWnzEEQRMI9FgdRUAb1FnCiKQnZo6bbA7LnoSB7dJJ8+fSCr0y/4f6Fo/G4YxY4xQ74D/5ODkW7e8PSzU3K8shVONzl6OZ0IVRDriBJpKVfl6lFt4W8khg7JX39UzHjfxHmXiuGXLbNkMYgPegmeGo5uQ5kxEgQM+42g==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "David S. Miller" <davem@davemloft.net>
To: David Ahern <dsahern@kernel.org>
To: Eric Dumazet <edumazet@google.com>
To: Jakub Kicinski <kuba@kernel.org>
To: Paolo Abeni <pabeni@redhat.com>
To: Simon Horman <horms@kernel.org>
Cc: netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 net/ipv6/ila/ila_xlat.c | 2 +-
 net/ipv6/ndisc.c        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv6/ila/ila_xlat.c b/net/ipv6/ila/ila_xlat.c
index 8991805fc3d60cfd2499146e522da142f33ddc50..c5e3954488ab7a1b1c07aff86385f5000945f1e4 100644
--- a/net/ipv6/ila/ila_xlat.c
+++ b/net/ipv6/ila/ila_xlat.c
@@ -545,7 +545,7 @@ int ila_xlat_nl_dump(struct sk_buff *skb, struct netlink_callback *cb)
 	/* Get first entry */
 	ila = rhashtable_walk_peek(rhiter);
 
-	if (ila && !IS_ERR(ila) && skip) {
+	if (!IS_ERR_OR_NULL(ila) && skip) {
 		/* Skip over visited entries */
 
 		while (ila && skip) {
diff --git a/net/ipv6/ndisc.c b/net/ipv6/ndisc.c
index f6a5d8c73af9721741c11b543e5abeecdbf2079f..ab340f2489c0c7555f48c1f3f5215cb1d0b5b341 100644
--- a/net/ipv6/ndisc.c
+++ b/net/ipv6/ndisc.c
@@ -1083,7 +1083,7 @@ static enum skb_drop_reason ndisc_recv_na(struct sk_buff *skb)
 		}
 	}
 
-	if (neigh && !IS_ERR(neigh)) {
+	if (!IS_ERR_OR_NULL(neigh)) {
 		u8 old_flags = neigh->flags;
 		struct net *net = dev_net(dev);
 

-- 
2.43.0


