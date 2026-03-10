Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id B17E2EB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:30 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 88B316B00AB; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 648966B00AE; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 30B036B00AF; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id DAED56B00AC
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:32 -0400 (EDT)
Received: from smtpin09.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id A2E5D877FD
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:32 +0000 (UTC)
X-FDA: 84529998504.09.5A039A5
Received: from mail.avm.de (mail.avm.de [212.42.244.94])
	by imf01.hostedemail.com (Postfix) with ESMTP id 1633A40005
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="P4cFZP/3";
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143730;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=//Y/a1VUBV8babx9taOSwyphsfZ3m2eyCHZu5Ateoi4=;
	b=QQjjBi0s2Df76vTjxoSHAACfrbMoQe9ZIiffuUb4x19HagNTUEs7pJJ90ctLdDWyS7aDqe
	eu5nrRnsi3sDhctiTJ2mgsLG9gYW565poGfv8bA7Wzkj7LH7kUbruehNjh/vkkIMYKOI6H
	a970pfW3kyxhO91QTXAvr0XbLgrpdvM=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143730; a=rsa-sha256;
	cv=none;
	b=Q7BZZpNVvRpsxlfUhXsE2bD6KC73M6YLFYbJPACTPoQjnITd57VzLBS6os3dwbatnd4fAc
	1utStZ6VLGj5lwkWvZtxa2XnTjeeB4ilI5FUwkpyoo55kh5/6iDIMz1aidZLnXFWRrGCO4
	dxiT8MbA/QA3Ufi4e49o93fw097INys=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b="P4cFZP/3";
	spf=pass (imf01.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.94 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143726; bh=/e9fhAri3fvWicTXaGdDwpg1S0XTbSGg5f30RLJZwGo=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=P4cFZP/3ySCkqkvFmysB/zTqxbD/PjzdR54YsQWs2B7Ag1WfdJL7tNy9mM+YApj2D
	 ndVw5Z3V4gfnNIxLGP9hoQNh4xHTmaffyOwYpsHdTRxcA8+K0XD0gxaMwz/nUN0o0X
	 SCmLqyt5cLBWipGIDG9rrJsNtObMa14/gIb9ntNs=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ae-e21d-7f0000032729-7f000001da1e-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:26 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:26 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:49:01 +0100
Subject: [PATCH 35/61] arch/mips: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-35-bd63b656022d@avm.de>
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
Cc: John Crispin <john@phrozen.org>, 
 Thomas Bogendoerfer <tsbogend@alpha.franken.de>
X-Developer-Signature: v=1; a=openpgp-sha256; l=861; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=/e9fhAri3fvWicTXaGdDwpg1S0XTbSGg5f30RLJZwGo=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAZM2fTyCYVfDSlmEmcm8t3ybPKD3MDuGKTUj
 vCjhqZWFOmJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGTAAKCRA0LQZT0ays
 2z2rCAC7oYhghVATpgjsAoGRn4N5/GCkNEQ5d/YNbMHtku5Ne/hNSs0W+K9kYWVkFPm5TlrH0DE
 8/RGH1u5MDT7P37KNp17NEpcRPc+zR1hHTpFzNLygQMhigzbVOt/7U+vGXQh1CXjciuY8j7FckI
 dtMHKNN16hVWRN9J7DdvS7Q09vOysbfuZGn+o8hs1SmUg64a9Ig5/41sPHN38J7SQblPeyGhLri
 3JgxiG8Mz5G70Y5/Rddk73/lgtWO+z4F7ECaPWtfktQ/wSj5ZuFGkTm2dn045+qsqR71gKKNbgQ
 /lgkcaOekPRGDC/jtk9N/uPlc4vBw/GKHnCp8LPegSQzk/iw
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143726-86614F2F-8EE3A410/0/0
X-purgate-type: clean
X-purgate-size: 863
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1633A40005
X-Stat-Signature: a8ykanhtx4sbtt6n8xb6r39b6mznzia7
X-HE-Tag: 1773143729-56901
X-HE-Meta: U2FsdGVkX1/qojWPZ6kDDz3QT5CMiWQrH06E/rH9jqxsAwg2ZfESsQADPjss5/Nfo2mvtR7oKloZOu4MQA3mubyJM/DkzdLwAsccXmnwD2y7xSMfFM4wQcaDM8WpYiaDdEdULBVBvsTjqGQ1zU/VjeRyRZE0heLziWcJdx/M+HAQIyRugIqaKKd2qDf5IMwV7uVVne8gF9vwQOGdQ1UP0ajfhUvf/eU5c2CkXgLhtUwewpSVycc0al/5iAgyza1klL5kefAreyQLvmNsPSZ6930/dTz2+7lQh3wJG1IZ8MuIUccBo9BAIz3YCzApppR+e7hJn+ZK2EVlGcdpVPlGFchiVic1XthMwiHj0wHlYY81iGsifopYe+f6wbYS3AkuAQR3Dz1EylbfHRDENiyPZDcCY6PLjXFj7OfNBVse+8y9PqIchNCO3ljugujtcvxEjp26f3S3eqKkCXrWM/IzzOWXwqFxdyJfuTAOSIwtD8jC+6BYyJ/3brpA5R6R3QBoaCuDbHI0COQMRgM401zDQXT6QLw/oyw2rNL4Ruj+4U8PjidBaZKFDRGWod+PMPWY0/3LZycpcHDJsZmNDwF1GnWbGD7JgISb+CLSdCB8oBX6n9kPnMXGtD9k/3bXXraUhYOwTNmft7fkll93NTkw2D3C4GXxEVDyVepLU0eY/cbeqlt8AlF/rvOzt+YnPmnw9EBvEubYoj/vGIrpuqmz3SJnzCf67MKBG0osuj1FAmhc3oOGYWcDGTpiAJXokRnSBy8sJwDsBPOOeX6v/LTLKiqqBQ0vLaBM7Mtb4hbN7NN3NlOlxUvwAhLv/D+t7rmPf+dHXW1xQtXQUedqbAjdzilbGQSubGrdX2Gxv+D4RH1CFe0QzpBZiA0x/dI9AD28wr8m24MzM4vwjdyxp74tFS6a9jYvJJJdKPnTzYJHi9nrYafj4j0EcczyCWKwQfk3CYm418MdW+/VHi/frWs
 oB8Y5UwG
 ACnejbfDQaHdRdqVTgXvpHeskjnkFA8SVi9WzU1ozmMYWpwSJ/4hlGvHHwXkb3zXA8SJ7+GvU08RLjxgjqvMa1r82zlHjaD4hYJ5C2wFc9YtVe+ImDcOiBkQUwnymQ8SPAZEKt+CVH6Pv5xdjXDh52WMPYqUpNv6vm3mJpUGrEBEVobcXoyJ6IJnIa43xnMyY/1n4UGE0ahi85T1GZ+M+DpENcizEtwZ98mUpZS7EOeQXqd9/40x3gMtVjcbRtcMp/QRnZkgons4bA6f5H8aRT4ZpoKTE62e/oo/iW8EhSHdN9EbBJD5X6HSolnnQykg8SW19/uRCbeMuSexI54APGiSUPRcExIGi9JhKrd2/vxnTrMWyORZ/4FVZNf2TJ9Zekvmv2FKidtMQjQ8tf2cwKe+TWwe6ow4cmxHE5X4OLCD1O8tzBHLF5znF+A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: John Crispin <john@phrozen.org>
To: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: linux-mips@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 arch/mips/lantiq/clk.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/mips/lantiq/clk.c b/arch/mips/lantiq/clk.c
index 2d5a0bcb0cec156dc5f0daedbdd7c56ff8d62ca4..4ae271a887c39163370d070b49d9e5152a709bd7 100644
--- a/arch/mips/lantiq/clk.c
+++ b/arch/mips/lantiq/clk.c
@@ -60,7 +60,7 @@ EXPORT_SYMBOL_GPL(clk_get_ppe);
 
 static inline int clk_good(struct clk *clk)
 {
-	return clk && !IS_ERR(clk);
+	return !IS_ERR_OR_NULL(clk);
 }
 
 unsigned long clk_get_rate(struct clk *clk)

-- 
2.43.0


