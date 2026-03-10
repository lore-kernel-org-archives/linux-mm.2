Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 59D8FEB1054
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:04 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A62DF6B00C1; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 94BA06B00C4; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7AA616B00B9; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1CAE86B00BF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin12.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id E136A1B6B98
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:34 +0000 (UTC)
X-FDA: 84529998588.12.02EC777
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf25.hostedemail.com (Postfix) with ESMTP id A7961A000E
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=xkT1xwtn;
	spf=pass (imf25.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=fjJobOr1hAQHKATPAuWIHrWpFe9f0JfxfPXIwwWzS6A=;
	b=qvbM15TCOX4bw8sZ7luv8cs+yY8Ou+SRrQ9MYja6Q925Zc2nBrouVFSZsYMZTtPwCdyU7F
	7m1kxb6QcOa5RQU1kjLjz1+BnqhBGm5NkSbFxJJBH3VWdodvBDG1bzNgZE7DFCsgPZyeVO
	r4GuMwHHrJZJqyhuURx5gpQzCRB9zqQ=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=XBIEdF8hJi+jEwxhlHNN+Surhw6vi5nTFKVkZUzwMChVuZ+OK0ZYyca+Rm8/bWPYn+vvK/
	GPD3oEXTUK7GWe05oyCiTrHxTQ3S/pvG7HmXvLPIRYAV01LQ5MfsVN+pnGooueA04D1fHE
	DLWzi8mKEKamyQ2NRTUZvFwKbK1h39I=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=xkT1xwtn;
	spf=pass (imf25.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=7QEjQvc53kHdYvJikGIe0XIqNo63J0gbffxhQyvvDmc=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=xkT1xwtnaKnF5zwky80U90tVBtgjXUcX+GeykmrAvdmpppC5+8VK/cr2uIrG8dU1M
	 7wm2m1OyU4JV6u1islMHTFtIiUXXXY5n/w/md+c+5C+f1bhtmzGNVLxiuCLq3+FykP
	 yZ+BZpZfQ6y4Yx2gZPgoiPOharwFnkzMOEjjrW34=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-2367-7f0000032729-7f000001c9aa-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:07 +0100
Subject: [PATCH 41/61] pinctrl: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-41-bd63b656022d@avm.de>
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
Cc: Linus Walleij <linusw@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=974; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=7QEjQvc53kHdYvJikGIe0XIqNo63J0gbffxhQyvvDmc=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZht0v/gzetsO7BqEut/SimpAgjLSUxejqDN
 jYPITjd+qeJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGYQAKCRA0LQZT0ays
 2w/2B/4pX609pdZXvqHfb+Vqmmi/TuKtxSLe3zgXgKoCJW/gh17vsp/T22wIBqf6SXS4OIznDwc
 CqIbsgeOEAAlNDyBRYAY6KPNdElI/rv3fa2ORfx9RdjhIHa4x5wKb3P01gEbIVxJDT7L+eaQBY5
 W5yNdsizunhdj+FuJcUWkiWweG/sakXiGLIkqX5NlLESVIppvEGGOaxwjbsMisZ9PSaDKihHXQV
 LTJsTcuZgnx6Ly3LMJ0SQkiMEfMsx1Sbu6dG9rRM3ckN2uFTC5HrsnBNmmT4sZqY9FpULICBCkq
 q7sHGVDOpWpuw1oJ3VO2Y9YZsG2cD9KHQpB9olXNSESNKBcu
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-86C91E1F-25F0153A/0/0
X-purgate-type: clean
X-purgate-size: 976
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: A7961A000E
X-Stat-Signature: 1y998wr9ijhhzudf31155xyc8bht93nd
X-HE-Tag: 1773143732-908457
X-HE-Meta: U2FsdGVkX18RoLWnH52IyUi2168xWYF/trzppQb6q08BmJ2b6tEwlHtMwPjxGRKaray+n4Ite63P6Q6WH/4MHGz0T52m2JFqf7eblX0C91EfS/zkx325p7AkGWLU8dplTYC6+p28Z8PcA2qfEJealBTpI0bmKVU6waaTFHGdxqV5KCvZsuYhLdZM2M5bga4Ah5DNmfuBcWFdBBodbx6ZTwInklwSh1bEaguWgj65WAmP2yQZsauQ0QZ3itDld/z+BOqNhCBwBVpBLCc+6AaGDPx9G/i7mWLTDhLBcOZTxdEhMfq8VhU/hP+f8R3dNOJbB5i9kVJLgQMZ/gUzikaw8ig5b7dD2rUynLh5CJonORA0pz5/ZprYG/2W9M2o72yteT+buR1205fWm3+kXGMZbNrsVZFRbR64z0k8OIIsecZyJVgQhF7B3udW3xcILsrxEBc9TAlfvUEEv2Z7hXARnequwmbI2hG2S0F4Pqj2sAoVkyM51fA5yqIRo+I068mMv54UVsVTDWhOITMNYVC9460hbC9eAoAV2qa/6dZCmE4PDAFggVGTOXipHLpbIj5WUoWg6/nsmD5MG0djM5DUc/eolB0+r6/oKpmz9oLwE4f51W7Gkile87X5F674FpY8KmIciKWnnze+AbgQs9mkuLvWtIFb2Aq27uN3EEoIe3+VM9Pqz15t5emVG/mnGmWyKBhsQLioRuDU9nZ5GsgmY/bRuGJ08mV3sMCEjt7fNYdwRgiXWowpGnF+NPG9UFg8LeOxFkTP+Avx/zFC4WUDeo2KVgd27TAZjdgyqnNZhikv06wjweP9ggwEHXg6yDWv8JywuKFOgkXZ7kXrXNT1yAcYedYo920QFF1DItgNfMFa5MfNC0dpqjYnQvh/0f+mMK7XnMQ8y4aJJnFLGgWkOuiOjilZEY3UeQ+EQLrvWmWjt7tmYYvTHFEdgDFuK5eXqmPxWgsGRaJF43Dv5Kt
 pjgGruUS
 ZTAJckPc6YhuvhEjixn7B+EVL0bvUg7AjHE57L5LHrsNeV1mEtT6jbfTkQ9Is17Pa1BvJ6AD8iWkMcra0xLE/abgTdAUmPU0vTtxVI2yNN57W8IsoPAU+ACvHGWc29SDqYL10ybQj1aspDeax5iSEtA7RZ6zkHhz1ybJnGm1tA7fcpGAIhMZhaOWNJuFicKb/pz1UXF11/i+NOG01V+xoyUojOg9UKRJrbFhWYEauTnuEgQn8/9QHQxmAEeVPCcHkWyxCu3DJqi0L+4mTDzNBU9scKeOSuhOP4nY0i0CwaBlkx8Eicui3/63x41G2oerPhXxoeUjJVr0Hswbs1NqLM764AnPu4lIO6oasHfS9AXRc67s=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Linus Walleij <linusw@kernel.org>
Cc: linux-gpio@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/pinctrl/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/pinctrl/core.c b/drivers/pinctrl/core.c
index b5e97689589fbf1b6750620fc193bc820012be2b..97a80989601abbe969d4b64cb0f3926fd4f291f5 100644
--- a/drivers/pinctrl/core.c
+++ b/drivers/pinctrl/core.c
@@ -1991,7 +1991,7 @@ static void pinctrl_init_device_debugfs(struct pinctrl_dev *pctldev)
 	device_root = debugfs_create_dir(debugfs_name, debugfs_root);
 	pctldev->device_root = device_root;
 
-	if (IS_ERR(device_root) || !device_root) {
+	if (IS_ERR_OR_NULL(device_root)) {
 		pr_warn("failed to create debugfs directory for %s\n",
 			dev_name(pctldev->dev));
 		return;

-- 
2.43.0


