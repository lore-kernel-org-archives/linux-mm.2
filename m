Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 24823EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:36 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 921C76B00C3; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 6CC396B00BB; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 2C8296B00BB; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 3BD3B6B00CF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id 03352C0287
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:36 +0000 (UTC)
X-FDA: 84529998672.12.4D25E5B
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf28.hostedemail.com (Postfix) with ESMTP id D4D72C000D
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf28.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=xKnBkg56;
	spf=pass (imf28.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=SsDTIIufDBFhlyEIKSZoh0ke1dsx9IoMTvg8hAIVw3s=;
	b=OdDbYu9KqOSzblKvukomfNqEYBtCZIJaAx7fL+mq2I8G4H8btOe1F6hB6bPSslC2uEFI2j
	FbPcoeygxjs5BYKjjBHUJP3gAcfUXmhuUTUy5vywpc9T5H0Z7UZ4KiunjeHnqeTUVIcLdc
	DreqbkReolVwrnIm0gyAzJZgpfwvOkU=
ARC-Authentication-Results: i=1;
	imf28.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=xKnBkg56;
	spf=pass (imf28.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143734; a=rsa-sha256;
	cv=none;
	b=O/FhSMkBMR8uftJlivIieGfWsVNHUnf+mPwu1SqMEqhlgjwCFRs92pbaLTPd7sOeJhtZae
	HXA/NeUV9I21DbayqAEkfcIkJbh1N7wuIcIohegYPmmy7aHobj8BSIRkmfCud9MV39LzQQ
	tWSGH1ieJlbGUdnrTPrN6cvEJyygszc=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143728; bh=sIEabNGpfTtaNmN5jdtpnoUYPpUdFMe596BbQNmq6Ew=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=xKnBkg5622xaCaFlGwFQ3bswFSgdcTVbCDHB3k8l65KFt6Ule9kyi3QR8HfOXuW5L
	 MKbugm+H1wq/E04UmM1cfkP9mUjiEZ3Ws7yzlEjYYTJHZ64lqewOtbO15JI10WApm1
	 CoPFx+DZxYAYXylALiT4nuOog37Am7eL2zh2ct4Q=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b0-e21d-7f0000032729-7f000001bae4-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:28 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:28 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:19 +0100
Subject: [PATCH 53/61] hyperv: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-53-bd63b656022d@avm.de>
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
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, 
 Haiyang Zhang <haiyangz@microsoft.com>, Wei Liu <wei.liu@kernel.org>, 
 Dexuan Cui <decui@microsoft.com>, Long Li <longli@microsoft.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1146; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=sIEabNGpfTtaNmN5jdtpnoUYPpUdFMe596BbQNmq6Ew=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaKQPK6RykE0QE2RJD5htL1ZvRNh+zI6jTmu
 VOYpL5CXyeJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGigAKCRA0LQZT0ays
 29fzB/oCGLAMazrUNiEmwKr9nq0MNT5XdhZH3wkJWE4yJ+UKMd35Xi9PPSb65qZMk+N4uMiZj2H
 T6Td1MreYgfIRLT7kTJk/n1BuSWWFP55nfvFZFjjhY5aoonvuH6RpMC7x9+9tNKQtJ7ne+y8JUp
 qmDL3C1GxXXFNKbwYmtZySONDO5gXmgMnGjDdckVFucnIkQYwHywWpIrPTZv3zUS9k6qS6F4HLs
 npSrcLjQ++9xnCfmtppGIezlVuCbkGtNbWVtJ6RuDAqRXXu4e1NER6f7pIlU/5AgYfpLOxyecDo
 JLi+d7tyzKhXU/h5ql9oJc0IZPZktOy6eLbVlaElpfc4YFhD
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143728-95676F2F-E8C255A2/0/0
X-purgate-type: clean
X-purgate-size: 1148
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Rspamd-Queue-Id: D4D72C000D
X-Rspamd-Server: rspam08
X-Stat-Signature: q5hip1sqg9iqbtahnopqe9y6sy4anka6
X-HE-Tag: 1773143733-49276
X-HE-Meta: U2FsdGVkX18QzAyW8AB/gPoYZYHrblc6wAMx1GxJPZtVN27LY3617F8A7iedUheL/AuJdD72ZQRrE/ME5nJn2WtBvItTK5MK+nPzyVRkcafmc0h7PdzTQly48KOvwg4t/W5pde3B4lKp/AFbY2bQ2Oo+s5iqH9iBMZD2srcNSWd2yZ9ZfntGGPzsI3CEx/vVtFC6Y8j+HvC7KTfZdOEo6fDKwTwIYm4TDNeFkldVX33YdxiIOqjoi146tUgAlIXpsi84hkh2503JtTBaF7ibdFsuI8pyvM/yHhEyUzWRGPVCLSZsR1uy2dpWkPB/FWu681iVuW4MvzNVFeFrRIXwIX+WtknhBelzm+xL+GqgSYbs32AuAmqvDbWgzo6Ro92NPl/St+9i5q8n9p/lG07TYxPBzs0jqRXBXLlHMReYxy0Pmp0xG3Pul836nw5jKgBXLGc3E3QqchTJ1GN58n2l0paPz2TIewV3ssou8pRzVddaar3pUUDjSqvhcmI4NIXJ8p2ApWpZRBVNGuWrwppVgOnNCr/YpgNteISNaZcudqBSdn90DvjNUC7OWE/yiC7ONgnohBRy9HWPGq6DjlBBdW2fXJyRiOW7Cw3pZjSFhdWCUDFcOAzndE+dpMhDI4sqHp504lDtMhYIiEbkXke6ymCSLGzCTlRmcdnCbUeBCpZEqttO2sRY3elNPYeVpgYp8h3/b8NLst/rFNIFh+lh3qetH89TPMf+wJDeJF6zJZrocTChGWtlHotwG3O5moceXe9VPtL1klrob7sBdf8TKWUrz7YDKhuHhjRHtvCkvNo679Cutzqt3TRVfIwpMVHT4Vfr5Pp1YGwcMHHeUt4IjuisT858cfC4C61l+VQalSN2sfKpMSGbITwyDRC5GMpovmYfhWJ2yIJkJ7mukniS7zT1yof/1lZlr1G2KqcljiBrGPyK1RpZBP9nBuOm9Yzz5+vkhwTUG4UYs+hdGt2
 bjs5zRRe
 64qbc1zBNR/+Fiemf3B5K2T2BwTHw8nkcKjAuIhqOMWr9H0NYBwjVY/R4C6ZoBtI/Fq0sjGmZR9yiLejKTU58J2yCIaAI30dXcrCv4ij3c19N3rmlZuBpR1tiSdmX2+qNgGRJEQm/C2fruXcndY1esdw3HLtj9GBMeDOA8xA/OsISGGx3eMErntnNQ23xLOlX1oHRk/sUZR7mN6OmImsGxH29Wmph73zvd1WtNy91leAAuceRWf0IRHDbuLLJfk9R7kW3ZfkE2q8/3xhb5k2Rj5+ZaH//HATPGH34xjgB/AiqQYlfOCsRKCTgWR1kCfrYqaXmFbCHGtAxpkLsPcEhcXW12u9khSv/N2DmudW1GlHv3oxtzarMppGVYiz6aKR1SC1A
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: "K. Y. Srinivasan" <kys@microsoft.com>
To: Haiyang Zhang <haiyangz@microsoft.com>
To: Wei Liu <wei.liu@kernel.org>
To: Dexuan Cui <decui@microsoft.com>
To: Long Li <longli@microsoft.com>
Cc: linux-hyperv@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/hv/mshv_eventfd.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hv/mshv_eventfd.c b/drivers/hv/mshv_eventfd.c
index d8471546e6a0c7e6eca933c640459f1d02152cb2..24dff7a498ac9c3edd31f4c9bc2f23729ba2a6ce 100644
--- a/drivers/hv/mshv_eventfd.c
+++ b/drivers/hv/mshv_eventfd.c
@@ -516,10 +516,10 @@ static int mshv_irqfd_assign(struct mshv_partition *pt,
 	if (irqfd->irqfd_resampler)
 		mshv_irqfd_resampler_shutdown(irqfd);
 
-	if (resamplefd && !IS_ERR(resamplefd))
+	if (!IS_ERR_OR_NULL(resamplefd))
 		eventfd_ctx_put(resamplefd);
 
-	if (eventfd && !IS_ERR(eventfd))
+	if (!IS_ERR_OR_NULL(eventfd))
 		eventfd_ctx_put(eventfd);
 
 out:

-- 
2.43.0


