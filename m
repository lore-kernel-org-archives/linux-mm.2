Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 1387CEB1053
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:55:29 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id ED0446B008A; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E67046B0089; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CBD486B0092; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id B0A9C6B0089
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:28 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6ADDB1B6826
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:28 +0000 (UTC)
X-FDA: 84529998336.06.50589A4
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf04.hostedemail.com (Postfix) with ESMTP id 6040D40007
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:26 +0000 (UTC)
Authentication-Results: imf04.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=E8nt1Igf;
	spf=pass (imf04.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143726;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=yrziLFSnm0I9lFRRCdtdTeG5oxuLL9+866/OTbm9RKM=;
	b=qYmiKs8luILow6CfE3Fg4pe9bMdEuiRU8DZDAxC2pKHP2j2GJ5z5hYFMVRADPGMuCx6ZRC
	1Fiy4gSjrsMeN19EMZ7Gxt86qRpGaGILTIQTgldanhOH/mbeE+okRJJBZIfFMFyaIOGQqP
	PG8YqmzCOVx0LU6B/QdjfHaz+iCdFhU=
ARC-Authentication-Results: i=1;
	imf04.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=E8nt1Igf;
	spf=pass (imf04.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143726; a=rsa-sha256;
	cv=none;
	b=FafrZlZZNwoCheZyQcY0gr2ZRPAYSdZbuUhAdzcubH0LMeqcDfKUpjLhv/fm38oob8lMIt
	jzFXg3xpKNYyJIjTVny34D67EMzbC1lZrN3Re3euEbBLX9+cEE+brUn7IU5+SGissAYh/4
	ulXIwSpDaWfOrJR/+TpjtBdDBvFO65k=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143723; bh=5P0DiWaZEPF/d3SPdMB+rZQJk1DY1mVuY8d9xffySsA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=E8nt1Igfikzg1UTgOGISAzAMiKswf2ND49bi7Kfi9UIZL/Ebzc+UJJz79rFMcVayH
	 w+/EzW9fK7u4Bg5GlsqH3X/nHnzFmDjyW7AnMKYXmhb+RvNdMihtj8ZP/p/a51PpAe
	 gPrdgwP6uGn176nZZmhXnabbuO0mAOF/przWQZhQ=
Received: from [212.42.244.71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ab-b734-7f0000032729-7f000001bfd2-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:23 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [212.42.244.71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:23 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:39 +0100
Subject: [PATCH 13/61] squashfs: Prefer IS_ERR_OR_NULL over manual NULL
 check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-13-bd63b656022d@avm.de>
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
Cc: Phillip Lougher <phillip@squashfs.org.uk>
X-Developer-Signature: v=1; a=openpgp-sha256; l=775; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=5P0DiWaZEPF/d3SPdMB+rZQJk1DY1mVuY8d9xffySsA=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYCOfXcw6nKYZXjZ+DBieT/hiu2NsAfQUre0
 jlVRw6aXW2JATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGAgAKCRA0LQZT0ays
 213oB/sHjZoOpAMz20yPf5W58oaVS3VDOW1zZjyOZfXyKihmnOb8lV99cBPQClALjvBUcqLXemg
 tpELfmCMWmmS2DLDh38s8m7H4SkSFm3iB+qUl+u8a8NGrDjTz2g0nlLXJ2i4mzmAqWbDldfEhAp
 ePslhLAf6MqAOAwxF9goTetOQ472ZWbOa7vI5fCqcvwcF/q5QIEUmGs+z5b0yUklyrSflqQlQo4
 adffOC5kl3ETGEGqBgVXEIg3h8JiDkJe6MaBbDmB/JG3IQRjeJ8YfJc6t+cVg+eXVpCRQOreMFS
 jG7NgF/eCJBIlcELmHlOCy2pst+P0hiPrthj4RBlPC3hRS93
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143723-265C1A3D-EB4B679C/0/0
X-purgate-type: clean
X-purgate-size: 777
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: 6040D40007
X-Rspamd-Server: rspam07
X-Stat-Signature: pugu1kz3gq1ns7bwqzabrm9zxmym84r9
X-Rspam-User: 
X-HE-Tag: 1773143726-350891
X-HE-Meta: U2FsdGVkX1/0jd69GQSPNTIv6maFXz1Bb5LuOGN2nuJXkwz9KmHyP4tpKrqpLZeWvJpR1ourkT8EVSPRpVu/VgigvFzqeukVJhBjgM7kO3vxTCgVmPCDU3/dPcNQwBoFvEnGfG3nzB+QiIrcqJ3aAWH/QpLoHjMLUV6hLgOlZG6jN26nb3faPk2eOiTc/QXVqqhQWW/wjkFiZpofdFdZjOLEG98OlWUDrD0lX7YuCORbWHkT6JGS4ArvIagQxYOX7EJYYWM8+0Tt2Alqe0pjTiOFavfruzSPWH4OXgOLUSA71yzbnHMOg0EI4cP5pKbMOXMp6zNr0yYTYYgFZldBK2VOJu4zgzHsclMChvySLjfdpsNl6x3Pni/WDPckF8S+TxvYcFR7YV+YC4TPcybu0WwpxQHl3BvhpuOE5vV6BXRUuFZbofTH+n6qSl4jzFWRhid/pkv7HW1fvKz2QeoSyRPeJmAT7HZ3EwoqRk2KfRA9JbYzfQBO6ni/dNh5qeiESfO5YBaBgySGmAM4Kv6Vc8r0QNDFjAEJ/Odwxzots3/VSmwsixab+uGpdSUc1wFcjAM58CWKU6wyPxrjEmHxO7ddXsqhCVMKGoiwxJkKXfuJUEJkSryVcJ0kTUA0MO3nlLkjImayfXdJbZIF57PVfOEl0p7Q75eLLcuYOJiCIjxLErtyiuN7C/zHoMkEUdbfqELCu6blWvNzY1QULQVvc6R+INuM6Zklj2oJXI7fxeBU/KNJvH0CxctbCcn4d6vSKgBMbxrlDmmHHQt6VGCeleBHT6ed2k2ZidAKTH5z1ozaN0lBDQm1E/N6AcPpv1Z/M2V1357tZ/YvyWKSkvgS4XzElrACwId+uyM97Cu6c+DLV22iZ9kGRhoRIYyeh+w2wenPU4XYa339gRfHXrmIqtnEoq1X/Cn8xeIJJN2nMjkLnts+q3I56Fv8t/yxUc3Q/QLXhpVDDMA0HDngkhF
 /Lw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Phillip Lougher <phillip@squashfs.org.uk>
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 fs/squashfs/cache.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/squashfs/cache.c b/fs/squashfs/cache.c
index 67abd4dff222235e75d8c2b10d5e9b811d6e38d8..8888cc02966e2e33210c872c733205d4c581ecc9 100644
--- a/fs/squashfs/cache.c
+++ b/fs/squashfs/cache.c
@@ -198,7 +198,7 @@ void squashfs_cache_delete(struct squashfs_cache *cache)
 {
 	int i, j;
 
-	if (IS_ERR(cache) || cache == NULL)
+	if (IS_ERR_OR_NULL(cache))
 		return;
 
 	for (i = 0; i < cache->entries; i++) {

-- 
2.43.0


