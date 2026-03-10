Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2B5A9EB105F
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:22 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D85C56B00BF; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C24D66B00B9; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 5A4C46B00C0; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id EB98F6B00C0
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B45FC160148
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.10.BB127A0
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf03.hostedemail.com (Postfix) with ESMTP id 7A60020011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
Authentication-Results: imf03.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=vpe0akhP;
	spf=pass (imf03.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=bwwsNpEuSxMWe0JpfJUzg0wYN6Lh2+T0V7r+oLFgaoc=;
	b=Ng8IxqJ1TTyUFXdyZ1n8+zBnt0Rh3CfjN6XZaLwl9j+can16mopq9lWscW0o1KSs9RovZa
	qfFDDr9cx6OfUZbEQ0dMmM79BY8gRCZn9NTWwWctTlPd0s9j+gOVsAzxtf5zXos+b86x2W
	MVFRUAEwY10DPt7J291whJPNcjs7z4g=
ARC-Authentication-Results: i=1;
	imf03.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=vpe0akhP;
	spf=pass (imf03.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=SIgEbmIqvPsYH/UXCsXcdZRsuMvG54mvXkExskF3OCTsFlUFn8ik7y5j5a4dQRPZDoZU9y
	rGiI2rFspgs7MYAba5UwkMYe9MBdD58rvBMVJ/R0Yyr/gYmnxUsh4TLx97LwUdrKH7NIVb
	IhovVB8d8ITxWufy8RtXJpdbSdOAsQE=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143729; bh=xxm4pfrA8vpE+55Nunaq1/3InG5TW5+yUEKOnNPaCHE=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=vpe0akhPijy+fdFGsJlWa9KadgjO2UW3S7CfTGj2Nb6xgJuadPCv9jJW3GCcgmmDp
	 NsscICFVG30n95MZjrlzYTppWlcYdN0G1O633y0snTb7dDyj/NfP2miiuKsPdNfmP+
	 vAwjLimypqw9PSgx5KgoEmL24wgMu4NPRFNkUtuM=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006b1-e21d-7f0000032729-7f000001bb0c-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:29 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:29 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:26 +0100
Subject: [PATCH 60/61] Input alps: Drop unlikely() around IS_ERR_OR_NULL()
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Message-Id: <20260310-b4-is_err_or_null-v1-60-bd63b656022d@avm.de>
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
Cc: =?utf-8?q?Pali_Roh=C3=A1r?= <pali@kernel.org>, 
 Dmitry Torokhov <dmitry.torokhov@gmail.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1263; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=xxm4pfrA8vpE+55Nunaq1/3InG5TW5+yUEKOnNPaCHE=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAai8jb0hbCBoPmYA/prWl4PUOkbFdhFm9gPO
 hWtVu2rtPaJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGogAKCRA0LQZT0ays
 28GYB/9rclpgBQgsqGF0yAXWM/97auTunqqLKOGDeyV/S4nC7HDn1d4UqQoeaSmUw2DOYO4u7t3
 FPnU9VUXE2nXM5FAQLfpjYhH7CG3jEkW4klm33iXRLo1nkpvx8klWZbYR7PMwPnVZTnxKNJmzgZ
 kL0ECVGQ0EahRXa5TL96qA0Z3YR0RjsX+MNWafES7VGwl+HS5Artyl+8jg+/p0RFHayhxpHi2hi
 Ftz0Ut7BpqlmrXUo0TzIlFmAGFe7tZCdcMDr5ii9ECIA4sGLz4jBK2uiDVL8YFZ25Y3k7DF6RQV
 m+hUB3KTG86705bO5a0t2DamRuiInU805Ah5rzh9tCueh4HO
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143729-373CFF2F-EC21F89B/0/0
X-purgate-type: clean
X-purgate-size: 1265
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 7A60020011
X-Rspamd-Server: rspam07
X-Stat-Signature: w7pgtmffnerjy39m63iq73ui6f6jcyw3
X-Rspam-User: 
X-HE-Tag: 1773143733-218406
X-HE-Meta: U2FsdGVkX1/WzemPn+Wu260CVV6X/ZJEtiQ27uwLTSwoXOIrMecYfqHN6HEyjTWSwvITj/CzDY6S9akj85F/tGoD1gvFb8cwXp3x9tyQyhdYmA3gMtcaK5ldraiWDzNHUqLv3fsl2B6EYhcYOghlIItaZbKwVqgqp0fw14SVMy6SeM2uefaGGiV5LTc64uEi+jLmtic/eh4RWVbV2J/V8TtT2QkqKExEhAhJm1JERICx1ZP1Bt7HN8RQzrLlq0Mqr3hx45mAtO3IB4Sh+85rzy1T80AWsAwWwGL2GlyTKntroBbN7QpAqixgXk385hI+EsL/lENZuXgGGbYFAiBBqGr/7UQrghZoX8dkTF0vjc99QGug0EqOOn5//cS7sb0ZNSHaOlfU0n0pv8lV5ZnPtbUQt20opyHyS/qAUNlh8FsDYFCcbNsUBpGDqOP1n7APuhVhFKtr+LiAqRJPsDUjZA0JL2w4BXiilzTJ0BbvzxEtVtNppOm1RLm/aHi0DsqvtTDzR7S6w8p5paSGZrWxVYGa7cIgnhS55HXEMlJrnfoRcy1pGcL9hcIoqXS/F+aBiXJWmmVIUgwa7Xjk3d3OxYSA1IX6ZIsdHcbvsg+38zjI/docOV3IymFPZFqs7v9FrwOvajuI7QLlSCWa5B09hgSMFoLkQKQ1n3OBP9zMpTfWCQsWoEDo0HjE09VfrMbhtQh25OqzTCHbc0hQKLFZRZPELnHZRFht+vmsSMy9VlySEKIhh+Y78dOR6+IodrlQViDXL89CoGLvfCnVdjw/sRhOYz285ODkQ8hSSOaQhsxwPW88RmELP21hGD6DLtQl8id6lFJFWcNhaH86blQuG8RWIOW74wAyWKQpQXCY9oT+AZCRr2s/4L5f/98f1dnEO7+/gjYDvUQBnNWvq4Q2/0DUqTth5isU91oWDu5Rr4IivGRxdkS64ihVmEq/sKZLovyoxeCf3I4AEzgjOUA
 YkDIRzIs
 CHzP5AJO6Vu2tiWH0OmLHYqeJc1iinQk8NAfdU8bSZ2H5e2T/9m/QYu9f9GLIK+/Ap9TJlQ2Ev1+bGpmHV4dMp7xPim+0AsI963xIj0NOcn9BXmG67ePucc47jhB4pDVhnrh/CVlmC8XTYpu7Y49n1P8Z51iKGo8gU8d/WqXqqB4OjJtysXLuaIoV7LY1z0/D8u0pijoj+Ls9xgELO68Pdppqn9b9W1S0hI0gGSJ76J44f8T0+nTSbC3aqkYrJl01flzEyDGzxSzrcYHOMJuzhhP6ipH3EdFom2hoLYy3akjT+dvVd0UKAKQ94ufHsufh4KrMPiQAC3Czb3CTZMa2qBx3XWB9UWF1ufrBfiezFqNqgv05JL/Nz4e8MsuFj+NKHNgcXJOctrgFSsLTt2mic+ClqnHoUrqT8tuJ5VCnVu0ACxzhqtlN6aJyyFB31+k0Yd9i8gU5HYfaKXAMLZHtEHjaPQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

IS_ERR_OR_NULL() already uses likely(!ptr) internally. checkpatch does
not like nesting it:
> WARNING: nested (un)?likely() calls, IS_ERR_OR_NULL already uses
> unlikely() internally
Remove the explicit use of unlikely().

Change generated with coccinelle.

To: "Pali Rohár" <pali@kernel.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/input/mouse/alps.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/input/mouse/alps.c b/drivers/input/mouse/alps.c
index f3d3b6b4e02d798e75a90333ace72a367befdbac..82e11efad7f7f02b4aaefde340f9b71fa792cf6b 100644
--- a/drivers/input/mouse/alps.c
+++ b/drivers/input/mouse/alps.c
@@ -1482,7 +1482,7 @@ static void alps_report_bare_ps2_packet(struct psmouse *psmouse,
 		/* On V2 devices the DualPoint Stick reports bare packets */
 		dev = priv->dev2;
 		dev2 = psmouse->dev;
-	} else if (unlikely(IS_ERR_OR_NULL(priv->dev3))) {
+	} else if (IS_ERR_OR_NULL(priv->dev3)) {
 		/* Register dev3 mouse if we received PS/2 packet first time */
 		if (!IS_ERR(priv->dev3))
 			psmouse_queue_work(psmouse, &priv->dev3_register_work,

-- 
2.43.0


