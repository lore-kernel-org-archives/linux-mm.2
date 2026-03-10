Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 68B77EB1052
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:57:08 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 1A06B6B00C7; Tue, 10 Mar 2026 07:55:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 047266B00C3; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A61E06B00C0; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 692EC6B00BB
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:35 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 3B7EF160136
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:35 +0000 (UTC)
X-FDA: 84529998630.07.68AD970
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0A2CDC0005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=i31l4ZLC;
	spf=pass (imf22.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143733;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=C+GdyesCqjDCe4PZkQJNYjcFFIcNfAxTkK/W4yWnbYU=;
	b=NZ8UEK9DKW43N6t3X9M/7l8iHm50i+HbQ+lSe+zbnoM2muphR5sjZIcpa33oa+DQ7Ed619
	Wmfut0wxeF4PNoV9R5j+r/6h8gRONuQ233OiLHproEiKv6pXIJ/RvwvnE2TCyD8hCvlspj
	GGf+hLvQn3Pkv8tvnPYWUwnIX2w88vo=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=i31l4ZLC;
	spf=pass (imf22.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143733; a=rsa-sha256;
	cv=none;
	b=p/aHpDpEcCUvLCDj0CT9uznGyo4Ocp/6Rvf12qIoAHxbS63a1D6r7ms3LltVvJ/bLijI38
	+Dei7ICB8cE64uG2we/fGmtexSA5nurJjVGmj2FMx95Q9x2rIR0CUP8GIG9/XLTuuC2nbu
	J9Lpxb2C02EPSQqHKCzT/x1UhCkwBw8=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143727; bh=gXi6ivSyh7ZdNYhxQJgA68gjpGeiYyVoxWZ9PHNV1mk=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=i31l4ZLCMLhpXpaK7/Y2yOfuiAhnSJr8fMnqxjs25j5opOPrdqJNTkpsIEDFkqgSp
	 sZnvLSPj8tGgU4HRU29DH4iPyKhf4v+uoWFgpTspJJOsv7N1zoPc8cizNZidyZ8Q0X
	 jUywybPonMt30TuRnw66+h5bxhBLfRmMmaXnPfrQ=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006af-b734-7f0000032729-7f0000019c20-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:27 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:27 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:17 +0100
Subject: [PATCH 51/61] leds: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-51-bd63b656022d@avm.de>
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
Cc: Lee Jones <lee@kernel.org>, Pavel Machek <pavel@kernel.org>
X-Developer-Signature: v=1; a=openpgp-sha256; l=923; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=gXi6ivSyh7ZdNYhxQJgA68gjpGeiYyVoxWZ9PHNV1mk=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAaDRzpibZr08PkdSw8N3Wy2DsiAYuwbT7jaR
 Q+T5qeGz2qJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGgwAKCRA0LQZT0ays
 2y8ACACMKWU5TdDg1OYJ2RnR6HQxJ+2JBIhOyDk8x3FmHidd0wyjcAKA49FqYhtFEhdjGJpgNO3
 wlcNr4zJ0vDoKzMmVWNj4Kco49QymIlKxd4ko1v9jLom22gL6FIw+i0pd7JG7Dw9K0M9qv/g65X
 psKPmTQlkBRnjyq+gEp1UF+Z+aW8svU4fmV048TA2bEb7zgfrp0dmnA9hbj2JEYjWrt/pHjBWtC
 27oF1sxBbFSjPkNzuaBpb0y9RWyLO/07lImA1AItNHZGlvNpydtzvqp/I3qxgt9sXKt1PHRt8iZ
 u4zVb/lltaBI2wPScPn/3+nmKc5y9QbdtT1oK6vzRsjkH2h6
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143727-CD5F3A3D-F6F9F436/0/0
X-purgate-type: clean
X-purgate-size: 925
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 0A2CDC0005
X-Rspamd-Server: rspam07
X-Stat-Signature: zrz9hook18hqw78yq6qmwoxm5cndt69r
X-Rspam-User: 
X-HE-Tag: 1773143732-594358
X-HE-Meta: U2FsdGVkX19x+8f2yP3HhJFWIAJKnUqSZ3VPGDwc1Sjxi2VpWnFrEc8v323fmn8fnERb/c/Pv1jWWxlBj3V236Q9ZsztAFHyTPyaOGUyLbRF+tC5ppZac8AV5KHLOsn1/PIzW0DbI392et6u+Fzl/DyqMJ+2TNUPOl5j+VMi+K9dGwaWIXGn5N/SIwjQx2vuc919hoxdnkh1/q3LXDa5SFOyG0/0pQ66ikN+jTfrebVA+1DSgchFWACWMAMWpmbA5+cxxUjmCsT6N2ZGLJPB+YD3D4nrfNZVV0735+e+Bjbc9dtjYGVhLZmRqowMJrS8zv211Sw56VWhZq8mG8YB3Bq+AQI3JEYgDuM+GscalMAIMxSJiH1zcrlSeeCOrHw2QNfoJUIzVMqku3OK9ucBZe2dfGQ3IOs6NPA4KX0ZFitFAqQgoI3gvUJ7w/Yb2aKOjU2kOAWe4tzGA7tcRW76cMQ72B9OAK/b4A31eH8KBwPFNMizLl8YG8lQGM9lcN9so0FQFZGEK4aTleOl7wUtM1Zv2XbR1T0XWkpzEOdk4JlKSZbjUWPdHpaJ4HN7UirVOMBjEk9jZ5LAlSf6tqBYGedYtRfscufPhpYW4N/uf6AmE6X7PY+zqIkOeKoiykP5p5S1JLGarOI/o85lDXHCQmj9amrJBp45w8/lXyx35ClsUMfICtdHO/wFxy4RDiCb+rYAni7yy4BCamfRPl1wg/trBK8WShCaUgOoNkukXXdvhoadztigzoNPBVNfBT1jc/h1wvAyRPfsBLf5ulbX9TgrrxNpHUol8A0z/WwW0141Isjoevhi520VEd1/Y06ASH6UjebD15J68SM0Mehiwx+wGHxYOQQ/nlk0vbSogPLQH/eGR2wmaRMCTqeYb8K08CKUXirE62t8EmXY8SDt+D5L1UQskf+vEYHWBdkf8xQ4zZ5CoxyF4VbGVWhvpu4tP3JQ4MDuKJgrCLx8vtp
 bUu91Xej
 hieq27xh8H+VVRaCkJIAfFzn06Z67dRQyVuaiFvkAMV/iZDGCne8Ok1sqTImRpcCfzdc/xFP/X86jKYoPdYysITFzpVD5C4SKETOSwLYPE8jOw5selF+EJ5dvjafkDu/YISSqpuhRRY46FY9wX+navpsRCbG2EUWYQMRuBfPv85WSNjmCrYiMOOy0M3KNCpKaj0xkncwdkPl3eR2T30K0kZRZ3K/r6rse9UCzVG7gf1L5d92ASeYAs/2zcyNgroNftEeGvKxGdG9oO1bVaih6vmAPcz5a7yx/6HBv7mFktUsXzvAZYWU+p7Kar9UC584bqQNFrpKPJzVF6dFOBiuIey7E+uEaC7jaEjvVjO+/bdI9U6zHgVuvsA07ZcuQxjSBFs5N
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Lee Jones <lee@kernel.org>
To: Pavel Machek <pavel@kernel.org>
Cc: linux-leds@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/leds/trigger/ledtrig-tty.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/leds/trigger/ledtrig-tty.c b/drivers/leds/trigger/ledtrig-tty.c
index 8eb6286b33ac3cdcbb72ed9ad5ad7105e15d20b6..3725571144d910b225ca9605771fc0f0c8355efd 100644
--- a/drivers/leds/trigger/ledtrig-tty.c
+++ b/drivers/leds/trigger/ledtrig-tty.c
@@ -220,7 +220,7 @@ static void ledtrig_tty_work(struct work_struct *work)
 			goto out;
 
 		tty = tty_kopen_shared(devno);
-		if (IS_ERR(tty) || !tty)
+		if (IS_ERR_OR_NULL(tty))
 			/* What to do? retry or abort */
 			goto out;
 

-- 
2.43.0


