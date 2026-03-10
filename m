Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1066AEB1065
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:34 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 8336F6B00B9; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 66C766B00CD; Tue, 10 Mar 2026 07:55:37 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 1F8326B00CD; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id 1B6AB6B00CD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: from smtpin22.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id DB5D516014C
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.22.2B483FC
Received: from mail.avm.de (mail.avm.de [212.42.244.119])
	by imf01.hostedemail.com (Postfix) with ESMTP id A95CE4000F
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=OzCQWGEP;
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143734;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=UqoCfhfTnRmuJC079QUYeXoC3nkqphscNqN7PPxlKOk=;
	b=5MRQukbcqIH2scqchHKKLeHnTV07fOaBSf1hcsykwykrtc1D8d1P0Z3ZuKrQRl7X2O5xt5
	IFKzvdOfJnSSLCiliM1BuIZDfQGcYeNB+OIvdkHGreCU+rIcH2p4bul6w3TpyPqzQVhAas
	p58L9suhLxwb6pe3dV6z39radar2+i0=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143734; a=rsa-sha256;
	cv=none;
	b=AnM/Wii4GeCLeLmkrTjZF3/ECV/OnA3UuPpGJ7l2k13ZI1+tvbKVa0MG/fiFZSuHGddtta
	CROmrtKbkOU2A4TXgWnUI81Q2P2UvMYixt7Qaoc/MQWqCrkYilhUejO9hKzwO1bH5ivzI6
	CW9dLIoCsZl3bod1tAv2H+QILXK0rQE=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=OzCQWGEP;
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.119 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143729; bh=aOTa0J99wrUiCJDKciZIBaRSFy8AAIBeipk1P/Ry6Do=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=OzCQWGEP3xIWg4aft9Gi61CqVxzVTLKLAimjDrWeQqUc3hUkPv1N3tKeXtgO8+TTP
	 XhmqP+sFetcOut+NsJt0vEBnYbeIs2Hbr8gQtf+aklxbXgaq0RnUqAMfY7Dvjp000Y
	 AkX7mNRKwyV5huTmoXbZ4xAO9eyZ3soV+HNDBiK0=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b1-2367-7f0000032729-7f000001ca34-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:29 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:23 +0100
Subject: [PATCH 57/61] reset: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-57-bd63b656022d@avm.de>
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
Cc: Philipp Zabel <p.zabel@pengutronix.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=968; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=aOTa0J99wrUiCJDKciZIBaRSFy8AAIBeipk1P/Ry6Do=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaYTbMwEnKjO28t4NGQZrm6X1QSq5SK/k8qB
 qh4VPr1rLCJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGmAAKCRA0LQZT0ays
 21umCACxIKapQYseolYqqyBm7SyLTZbMM7MUu/ruXbxGyc49Ef4ha2YprHG4wuhRGtqa+VJappe
 JyX0Z9X9KMdJsI/T+BsTdbSpg720pNSAKbSG/WcuoRUIgTiyuqx3+IKJLG0jtFT86FOozZPOWEy
 PPGiUFAfCi7lTKlHGrGHOhGX9fNEHoC67p+hbdbdmFe+ifTERx6lzSSYvUcvltMUMt2tdHG0fgm
 mbuvPyYzKrB65Gooayr+TJ6lncMe1eo3kIkCgAS0gJFF08HI7PwP3Atbb7J7YpFYREokazErNBn
 540BWDngwOE49h53Z1ngLFPv4fl7uolW05pdRIimfw0qiceA
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-7B4FEE1F-3FF7DD9F/0/0
X-purgate-type: clean
X-purgate-size: 970
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Stat-Signature: hxqmmy67qnkbpaa7i8dx8du8x7zqfskn
X-Rspamd-Queue-Id: A95CE4000F
X-Rspamd-Server: rspam03
X-HE-Tag: 1773143733-142139
X-HE-Meta: U2FsdGVkX1+p8UPCqBTIoyYUUSU4JVBWJJwTNkjh58B4CnpQCW0PrGFQ3tLXxPtJLH4BPPSl3/fxN4fXbk7TaNpM/Eyu96lTPinj/FC3r4fyXgTvAqip44kEhZz/gojUzKsDAi5j7D1GmCqnLa8OgJMeIJYvh8xtoit3UVSMcsq6zbpz5WvALqhdWAt149WH7bKa8x1bs6Qc6rBZOCP8qUEIFCrzfYtVXxABqd9/tU6sqRwAmsf7ykabpe19Yk8pxGUHFR90yqSEuY1zGHldOoDjtSXcEN82RTBzQOaRGjkbY0yKAUkJt5h7syrZWUUd64jgixQkqCfYHxx5ppBn8CKCLIR/maY1Tu2LCKxwDYuSiwiAO0bxLWTPDeMkXlqTCskrTtKTX+TUP2hvBM3Tc0ncmEri9fC1YI1Hl337Hd4zTHIATPmqGVzPMD17mI0o22+LD4d1OVsxJG+O/irz1why+OizIGpm+IV+serOSe16K6CJvBXw1yjm0J/X46bQ0zRjKdv1d5tF8OrzBhQcoY0FMcMrLXlfMYK2fJgB3A43sqbs5wZmoIqLUvt1lnBYeHnwNizI6jfzHlLjvM7FxmNJ9sT4/yHgwEXuvTJ36QFN2qlWJP2qMkh7rsZ7zRiJk84kDcJCht8n49TFB/OXCwgx1d81aRy8CBj05CXeC41WXd5/GrZ+ZQKbI4UgNJob7+o47X+HIPQtM9OuuibEhuM7nBxxpUV5UfICg7QFSOn+hVOf6QToOl353+CwtQ0Bhlb/1tVw3Ekp1BkmaQRg9GwZxx8jKWz8ih30CgXC30HwomzNDomFt/LW1h1J+pg22IIeP8mmgyxroPsy424UThDEss9G7d8t80IM0iHiiGSrvi26s6aE3f07x5Gwh5On3nirqicFWU6g9MpGFkdzi0b2Z+uNRSFMOsG5JOiw/QcdMTRRMeg1D7zJCY7FBw5XUQdlZCiiOqL0ut+BYXT
 VL1UQwHv
 oySoKvWLvcavds7htnIix//hKEN4qHZ0yN5J2WxpKpnFOlgXWO34FvSKKgKz2dsrDScjWKS09Ur2zg6IqTyLX884mr6Fojy7+iVaogl1e0/Cp++72hPlwnGIgBq7+oVeG8q1LEpe5bpwNArHG5stimBTjbSdaUsc9Egc6o8XWFWptXpPOpSoGMLF1eoe53KUIlDe8bBhMt3hreTIqHiNSi5YEUxOtiHx8enst3GVRjQlHikbeMwaDfq55mjy0aJHtG64Nbw3mmKLPbX+zqOxW3rRlpufD5ZASHQEfQtdPrNNREc6emwXHQJXTkVyyhH1f0N1OSp/Zgn4Kv0LC3EBPWNTIlj6jVv4E9Ibm1G5OVRl1+ewVtEKqNgxfpsP+ZuLpZd8k
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Semantich change: Previously the code only printed the warning on error,
but not when the pointer was NULL. Now the warning is printed in both
cases!

Change found with coccinelle.

To: Philipp Zabel <p.zabel@pengutronix.de>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/reset/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/reset/core.c b/drivers/reset/core.c
index fceec45c8afc1e74fe46311bdc023ff257e8d770..649bb4ebabb20a09349ccbfc62f8280621df450e 100644
--- a/drivers/reset/core.c
+++ b/drivers/reset/core.c
@@ -715,7 +715,7 @@ EXPORT_SYMBOL_GPL(reset_control_bulk_acquire);
  */
 void reset_control_release(struct reset_control *rstc)
 {
-	if (!rstc || WARN_ON(IS_ERR(rstc)))
+	if (WARN_ON(IS_ERR_OR_NULL(rstc)))
 		return;
 
 	if (reset_control_is_array(rstc))

-- 
2.43.0


