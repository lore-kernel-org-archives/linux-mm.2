Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 52A8BEB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:54 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D10316B00AA; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A744C6B00BB; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7CE5E6B00B8; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1A88D6B00B5
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id D714955B1C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.16.7EC6E14
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf28.hostedemail.com (Postfix) with ESMTP id 964D4C0011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:31 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=rRX3stPQ;
	spf=pass (imf28.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=CMAEotzjl80q/k3AHUpFdsqecrdK0X6tjqiBMW6zbGo=;
	b=UJB8BFf0tOWa6MmgTPFZRcIiTAVt7iXEE0xlnBBaIszQ92xRqoDvhSlGvIVVqHG7HClkvR
	PZRsH8ISy5saRi2dJD2wY8VS+tpqrgJfNVhIDzGUXC3s9/7UTX9eTAwhLh3SXA1mBVrbPm
	P6VzgkNQpD/y1pkLA0Zk/QGk12fuxis=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=PdtYHM1D1ytXvzwHtkLev0EPR557AGBMdobJR3T4lle4X+7TyNYivoavQJN8tnwLEMt22S
	QZ0kFk1ny04zMQoJcR3/EcPYiTCxt4b5DV9DiPYDlE4AUFWyYR9upOrQrbVp3RCWiOsYa4
	jNnzXxSAGzceajKIw/YkSfgWQjbjThY=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=rRX3stPQ;
	spf=pass (imf28.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=g4FFdRUzUDur+rKeacaiCQZ+hQh7tI9Z6NjRyFnQc8w=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=rRX3stPQMInmxRJPEzximgG0zMf53EmXskDxqUtsKeYEkVQ/dYQttdiJ1RwUnbcpz
	 vUIyMp9GJewHbVUEmLcfea/7Tczz6UnxZqIBZpZCQjil3jUyfWJvjrL+lRSOeW+TzV
	 m1ne+0b2SGo4W3cNeV9kwvYwa/se7AsaBn9ffb+U=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ad-b734-7f0000032729-7f000001c092-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:25 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:25 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:05 +0100
Subject: [PATCH 39/61] irqchip: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-39-bd63b656022d@avm.de>
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
Cc: Marc Zyngier <maz@kernel.org>, Thomas Gleixner <tglx@kernel.org>, 
 Andrew Lunn <andrew@lunn.ch>, Gregory Clement <gregory.clement@bootlin.com>, 
 Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1797; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=g4FFdRUzUDur+rKeacaiCQZ+hQh7tI9Z6NjRyFnQc8w=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZajgCYubaE210ybXd9Qufza8n+eFtBCfTFO
 oQVV6kxanqJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGWgAKCRA0LQZT0ays
 28ISB/9piM+RbVSziEng1t7dun6orhPWKQV9naYfNjFW3SarwsnzmnBDz0nuaGgkwHFCge92/YT
 C6PE2tX58vKdugSVIB0D9NRq5gq4thjVq3D0H2GAQlza/oKxurc4wdXC5dXInbYl5OUB2w09WQy
 fMKAkwG0m3WFPKRgizEtCKM6l/9q3B4q2rnnpcRKQx0iNvhf+dUkY5BUPSwCcfQvJK7+4PoC/ZE
 ddAoJcpror4/MCI0j47/BVNaHIB5K9WykFVMhov3BZvNavqXT9C64hKXxD2btf1UcwShvWKloSd
 PxNXkra2HopfIdMjPOY9w4hG57NjkAcqg0vkRHvvtwjYvgsZ
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143725-DB5DFA3D-FD67F9DA/0/0
X-purgate-type: clean
X-purgate-size: 1799
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: pf9ngdcwdfxem31x14esh5otmz6oduuk
X-Rspamd-Queue-Id: 964D4C0011
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143731-50312
X-HE-Meta: U2FsdGVkX1/Ddi75RyeOa5a3UF7gmSpMDPFMv0ESQUzT4zhA5+GddBndurc4bJcOCoLNyvyllzxJPlw/DbwJBPJFds+w2uYrQ4tpLhfVnFS5pxlS5k30Oay0LgYjro9rpB0BIMGoFjj8NKGtFOaX/Rf0kAYnbQI0RJus0jGGQhPrBXqD1ByV4+NMPmQ4X9tueJwOsq4iET/4zTwOW7NqYmm6JK98Gt8vX5/Oq5rhYLWqU0XTk3kYuRz405v7/BaZRx/GeGr16M8W3xMBIlxjwPEFurLPzIKby3vn7cLiWrw6Y9eS/g9oPRPDww7hm073TgRhICAHIxH+hz2yWjJapxpBTockjb1c68j+ts2K9kR11zeKH1qpuHjRIaIuLvmspVlnRlKybnkV3gc22iUij8q1rgOuCIHv4NYhMddGnx3U6PdRTNbvxLc03VovnC3peCgCHASi1rJeIKhbM7H9b7ssAzsNW7doz8d+P7xqo0+lBRciig9ySK6uSE9khVJou84bw/sc9t1XerRsvwRh/EgXLXAfGHt1QUindhsYzsG78jaxffEY1DOJXctUAaNdAGQOEdieWZ5MYB1o/cBxPnjT7qCzXe31V8JpPtJy/xE/XXsmmtXvR50vDBudaemd+h9Sn2C31sySOqEkQSC7u2yTDocw8EJTNmYhpkHG0ZR/rPbbRXJZEcEQ936B3bw/XD4+q0sNc6pA3E/yG1p1U0ZYYEFnUwyCNcL2yADYV2SuP4YmHsc60E/CE+jplSUSc95DZJhFMQl5uK/g6kgcjskSJlN6IayUH0rWrtNNyyQWSThKnQ5R1dB26tw4NKVmkxQfuBb0wWYsprd7CLC3kVxVrGKzg+YPuHwz2xqE9bL+lG29yUBc3WpyT1FT21xsjD3mZxi9YEtax/fC6qk2C1tA0M5oCHWMTmY6/S9Jw0z/C74XaDs9GbqiGp+Z6oDhh5/wVgU7prHLbvGNFDb
 zVctG11m
 WiHlpqIDCyoWuYIExdwtrtu9gA0VN9JZtUDbw4SNAgAbvPhdJAjKUzRC+TirKRQOBZZ2313Ape7Gy/DlgywTg9Mp/AsB+6I61PhYqN4pZuQLzd0PfBwaO5Cr21tfBmVX32/D0uSOUnQLR1Q4bG2lmaIzZ1D3HIAancaAyHizfUul2+AHof/9N3Gv/+2J6lw9HODvd+czn3pVODDKQQaDjpUzeae9cc79YQjif+HTn2DHO9gQINn4K5IvTeF7hbJRi2NW+XCvYuCohSdpHS9nez73puq3bAhRbhO1OWz3j9Rd+TeafcQQk6Xm/BGoOe8CfGmd2txYNwvIAuzj/mJ+p5016/IlRH4iIbx2Gph6qVpQavqE3NAYVlKZBflVZU/QnCaYqy2lhWwYodSHRaQJH4ISgkyjcNbNLDCXoz0G+YTzL4CfuggF9BUY5J6GuKTIu2ORZayC0Q6PY5+W5vNZLLmEwseCQd9C+ga5e15z8BdhgpwgOfN+OoTtkVxRh6b5QUwIQSJ50fyoNbIuS8BdH+0XP2OwfAICo9yMv7XP57HiT1PlDCuTOmlUB3w==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Marc Zyngier <maz@kernel.org>
To: Thomas Gleixner <tglx@kernel.org>
To: Andrew Lunn <andrew@lunn.ch>
To: Gregory Clement <gregory.clement@bootlin.com>
To: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/irqchip/irq-gic-v3.c     | 2 +-
 drivers/irqchip/irq-mvebu-odmi.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 20f13b686ab22faf722dd2b24faf96af636a4bbd..6dc9827357a21ae05dd838fb717871c73f3c7562 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -2252,7 +2252,7 @@ static int __init gic_of_init(struct device_node *node, struct device_node *pare
 
 out_unmap_rdist:
 	for (i = 0; i < nr_redist_regions; i++)
-		if (rdist_regs[i].redist_base && !IS_ERR(rdist_regs[i].redist_base))
+		if (!IS_ERR_OR_NULL(rdist_regs[i].redist_base))
 			iounmap(rdist_regs[i].redist_base);
 	kfree(rdist_regs);
 out_unmap_dist:
diff --git a/drivers/irqchip/irq-mvebu-odmi.c b/drivers/irqchip/irq-mvebu-odmi.c
index b99ab9dcc14b3ba982876cf5525499d02bc1c997..94e7eda46e81833cfe0479b6fabba715bf4ef6b8 100644
--- a/drivers/irqchip/irq-mvebu-odmi.c
+++ b/drivers/irqchip/irq-mvebu-odmi.c
@@ -217,7 +217,7 @@ static int __init mvebu_odmi_init(struct device_node *node,
 	for (i = 0; i < odmis_count; i++) {
 		struct odmi_data *odmi = &odmis[i];
 
-		if (odmi->base && !IS_ERR(odmi->base))
+		if (!IS_ERR_OR_NULL(odmi->base))
 			iounmap(odmis[i].base);
 	}
 	bitmap_free(odmis_bm);

-- 
2.43.0


