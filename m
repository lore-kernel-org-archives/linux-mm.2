Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 5681CEB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:56 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2A3106B00BA; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 223436B00B9; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B6B036B00B6; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 837096B00BA
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: from smtpin15.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 564B31B6A69
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:34 +0000 (UTC)
X-FDA: 84529998588.15.0DA6715
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf13.hostedemail.com (Postfix) with ESMTP id 2FA6E20018
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=PKx4gVlk;
	spf=pass (imf13.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143732;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=+mEgDc6W6dmx2m0hBCrDKrYdyaZdhiJE+p4uCpJlqL8=;
	b=EtK0XHe7ZaDBFkywYOim2SUk081u1fOR3ZxZR7WgNrkiHGuUrv37K8sLduu/tzDwc9D+Mc
	/6vaALx9IppgDCNzUAkx/5eznQmh3ANpxd5ZDpU3pu9WcANadBkOTEDrJ0hahilsPkRPEp
	vH9Q7IRCSUOrArc3s0ifT2Dm63Uavkc=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=PKx4gVlk;
	spf=pass (imf13.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143732; a=rsa-sha256;
	cv=none;
	b=b59EgtHF5NqG4fFc3ypbwTKdoP2j+zY3AasLSVD3QH6IAfWyARIeHSII6Qe0/v43VSAuf4
	OiGNSE0/WgPam/SkdhwJFCP1q56cZBa3ES4aF8SJ0qYIdiuDiMkiPA+GboAVlA6eXxAngr
	315N/r3qxpPMG4qTQz8Pz5NUbfpSuvg=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=MCi9bfMt/yjRjpkUd1ZhwbiaE2CmX7FKcN3LCeZC+s8=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=PKx4gVlkKTdBK4hC8DhkZHv6XjY3aXLFzpRRf+9yfpJ7sETH73wJIPUWVun5ApODc
	 fB1HpEzfhSmPsza3W/UlEsW+FK27FdFsyHgYe+IbnAc85JpgiLO0UqynRTi7RRWY3c
	 Qcjq/1RWaavgSPFWfIRpI/rqChIvo10IblUQ9PGA=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-2367-7f0000032729-7f000001c98c-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:00 +0100
Subject: [PATCH 34/61] arch/arm: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-34-bd63b656022d@avm.de>
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
Cc: Russell King <linux@armlinux.org.uk>
X-Developer-Signature: v=1; a=openpgp-sha256; l=925; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=MCi9bfMt/yjRjpkUd1ZhwbiaE2CmX7FKcN3LCeZC+s8=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZJPXZg3WsXcrZtjOff8m1jvG6yKXz3axEvS
 kboSQL/SpuJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGSQAKCRA0LQZT0ays
 2zfACACzyLECzgi3MrIMlJkcwSfYhn2m+PRIL8f9uOY3XlWqWmweHlYuZj3OMlVlJtGjvYSQaMR
 9+D2tmynuqJf309fIXDWVkgzjy8866w+a/UJmSXv/T4izax84D3f8LghtIzFi7mZ97slccnBaIH
 bYp2esZnYrGMRYLzsh/aOQvmQdhErxNZysqZJWPMzNnDfK6XoXYg2wPfHrL2waLBmLBd1ruAh8/
 q/1mTUtEwi8tnMzF9vKrDxFY8VrHUkQh/DKxepIobrtB7u/NL1zHZyVzUjIKrp3fP30IB0/fbFP
 nBUcDJnBx61wdRtaxbBVJBgZihX6FfH11PRkPQUNc/WVeaiP
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-8AC99E1F-6B772227/0/0
X-purgate-type: clean
X-purgate-size: 927
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 2FA6E20018
X-Rspamd-Server: rspam07
X-Stat-Signature: 43eo5yk8e9je4g1ij9isstfkamkhpgji
X-Rspam-User: 
X-HE-Tag: 1773143731-787677
X-HE-Meta: U2FsdGVkX18dbbTZ+Sgl4Q21MgHauh51CLa08hEk08ZUsD94eZPsfVNAvUdhiQjqDQIkEVZCvWuOqprIudFoU3gbir2kfLT44VIDArAR0LoNap+f3aN4PluJK7KFOHRB3uMWs5K6NtFtmZSI3ARcBqcw5aY0M08K9EeazfkvR7KDbJ47g3SPiYwR2OHpaW2LOu6k03a9QqZdmTCYG8y+NfeuqGWiHwku/4YQlKMr5QBdTn9aq6Xt0/i1PGG81qIicnzx3AW3UvnwRLcYf40YFyfxQJYVDCOKavOMJXukzSrHR8PLZxJQVkwiQN3zF1DTs3iSozcpMnA/Q4YjrbiSzWU4L16ip7/nhkTP4u1eFiUays+6dYUzpxsnn/I9ytxU3lbsK2KK5YYnBnxgFQBnSslWHhreuMO7//cA2Gw14FcofimxhpVixaVlxckwEwJ/uRoLnKPyb8F113bBLPFL5571dxQB/F6CiOn6NDaPyvOpZE7rhr9f9azrksDanp1XFbhp3OlVA+IylG7tO0/+Db8+jZ0fqEIRX3nx6w2dMZMk//PT8pt1UHexr4Lx7AFDW+3pUOUk90nrrSqdPkL59MRs/sokInFKA1Ag3quAnqMzwiNXMamXBy2Y4Yu31eU5mXXYFZy7XgaoVFPmqWhmi1PZs9ck7p61ZV8moN44eG+RLrqf6Xhn++x3kxMg4JaXAHpJq0+rY80Nxl8gDhtFkyvNuG6K11PAAK0K/X9klxTXZ5qUqULwW3ys540CLKA3FbX7girj7o5/7VAYrX4uiUJ1sFE0HHnScRVZ4RoH0aF25z05lEokB6jEgIxT8zKI2rwyf5AzR+O0d+n7YyQOlRFwV8CK5pfuTP4LqXUhHGkCRx6SDRZ899s1BAG831zRiHfLT6M3Fm8dbo9FUZJ2CPrzNa2rkW7WI3JDJhRPNkxPFgrkCCbuZcQqVZ1uPmq+cy5LCm7/rPVUZCFxzsG
 OrJnDkqE
 GPFymy7CzSK3XnUktoi7rO0t06sgDp1ViMlYbh1GXqJWCFHMeZKaTafJktMzn4eRfgN2KOJOR+5E8GdXMrs5ICDrukT5sYDxS1a7c/8th9lQ59r/plq+KRwvt5Ml5MDNT04sWJyuMj+GZNuU8uie2MhNVomi6o+6PVLIEgu5HZVjsoBSfPzwPKUIh/E5JFLDbbWnTocQHrMhIWhgXPgxZ04lqQ0wW3ATXEtr5pZsdlWPo2hXEICaf6p+0OTAXkZxu9C63i02fh1hpJh7C3Q5DMq5iXQN12NDi2eO0g0KXbvsWleEqDmLJqfcRfYpGpeYh/6/YfptDyuUnbYY2wugVTsEC5EnE3goHf0YF/cU8iIS3nfIsP/daHO0WJ5VH50/ykbS+sWy83IJan+4fAvHJCKYxKHi4nsa9q0ZnqqhupzZtdZ6n2dI4U3xU50lPfJYzlClEiWZWGqxe1R3+/Jmum+XcKPCOpMK3Smmi
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Russell King <linux@armlinux.org.uk>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 arch/arm/common/bL_switcher.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/common/bL_switcher.c b/arch/arm/common/bL_switcher.c
index d1e82a318e3b22bf6f54e9a8d5366ddc7a6e44ca..46cbb5caf9f17a22a7c42e4254cb68c6cdebc4e4 100644
--- a/arch/arm/common/bL_switcher.c
+++ b/arch/arm/common/bL_switcher.c
@@ -628,7 +628,7 @@ static void bL_switcher_disable(void)
 		t = &bL_threads[cpu];
 		task = t->task;
 		t->task = NULL;
-		if (!task || IS_ERR(task))
+		if (IS_ERR_OR_NULL(task))
 			continue;
 		kthread_stop(task);
 		/* no more switch may happen on this CPU at this point */

-- 
2.43.0


