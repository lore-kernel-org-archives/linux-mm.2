Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 2316DEB1055
	for <linux-mm@archiver.kernel.org>; Tue, 10 Mar 2026 11:56:41 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 174C96B00B2; Tue, 10 Mar 2026 07:55:34 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id ED2646B00B7; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B81406B00AA; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id 541A96B00AF
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 07:55:33 -0400 (EDT)
Received: from smtpin07.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 2332955B49
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:33 +0000 (UTC)
X-FDA: 84529998546.07.4104CD2
Received: from mail.avm.de (mail.avm.de [212.42.244.120])
	by imf16.hostedemail.com (Postfix) with ESMTP id C7C4A180011
	for <linux-mm@kvack.org>; Tue, 10 Mar 2026 11:55:30 +0000 (UTC)
Authentication-Results: imf16.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=helEnKZU;
	spf=pass (imf16.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773143731;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=VeyuMlBSXCUl2HyhMWtK62gNrN2xqJpTn5I2B2Zc2uk=;
	b=HZ6Pri1jokbGB1Fk26nrfwyzxPuSbBls9NJaZXi79kyACa95mx1zaHnKCrD7SEJaiX5TBm
	h/HChgWQY6RJs/d/YFxWL73kvscdYxP3kNttCEHVrejxB4cBwlNl/NXxlMMHdiX+LRlo14
	3rNbXkWSWI1QcNb6n0fs6CDZdnlyMRs=
ARC-Authentication-Results: i=1;
	imf16.hostedemail.com;
	dkim=pass header.d=avm.de header.s=mail header.b=helEnKZU;
	spf=pass (imf16.hostedemail.com: domain of phahn-oss@avm.de designates 212.42.244.120 as permitted sender) smtp.mailfrom=phahn-oss@avm.de;
	dmarc=pass (policy=quarantine) header.from=avm.de
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773143731; a=rsa-sha256;
	cv=none;
	b=nDZ51tbszhh/XvOvzs8vMnG20t43jQ8mln55iDF5YGhZ6LxXb/lhZFHsbLnO7retx9Qxp6
	9v89WiLEfuM/SY0uRl8D8vXhbiAfUjwrBvrfGjMqJTqjBweBbECqQ2oYvP2x/BIyhr3aYV
	U7Mw4HRPSFMCcsJ0+YVJezOdIIxopzk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
	t=1773143725; bh=xBKhBreRFiEpPz9/49OtWlCzYkq81mZihzEqekyK7xA=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=helEnKZUDYmuyC7r9itC+dVARlXrRlYpZWzDAaAXEYc5wN1FHoKQsdSjCaomchjhv
	 +41zqDKlH044FWtyvi2VX9TAdQF1rs14U237EegHWJogLxynx4m+2shwi9NDMEzjxe
	 k3vCUFrBTw+1/DCUt/wn8qmUGFq+b5Q0TC9ytTvc=
Received: from [2001:bf0:244:244::71] (helo=mail.avm.de)
	by mail.avm.de with ESMTP (eXpurgate 4.55.2)
	(envelope-from <phahn-oss@avm.de>)
	id 69b006ac-b734-7f0000032729-7f000001c024-1
	for <multiple-recipients>; Tue, 10 Mar 2026 12:55:24 +0100
Received: from mail-auth.avm.de (dovecot-mx-01.avm.de [IPv6:2001:bf0:244:244::71])
	by mail.avm.de (Postfix) with ESMTPS;
	Tue, 10 Mar 2026 12:55:24 +0100 (CET)
From: Philipp Hahn <phahn-oss@avm.de>
Date: Tue, 10 Mar 2026 12:48:48 +0100
Subject: [PATCH 22/61] md: Prefer IS_ERR_OR_NULL over manual NULL check
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260310-b4-is_err_or_null-v1-22-bd63b656022d@avm.de>
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
Cc: Alasdair Kergon <agk@redhat.com>, Mike Snitzer <snitzer@kernel.org>, 
 Mikulas Patocka <mpatocka@redhat.com>, 
 Benjamin Marzinski <bmarzins@redhat.com>
X-Developer-Signature: v=1; a=openpgp-sha256; l=1995; i=phahn-oss@avm.de;
 h=from:subject:message-id; bh=xBKhBreRFiEpPz9/49OtWlCzYkq81mZihzEqekyK7xA=;
 b=owEBbQGS/pANAwAKATQtBlPRrKzbAcsmYgBpsAYgLcFKxegL/bQqhgTo4RNQJgrnmxL3YCzsA
 NwbsOtNPYeJATMEAAEKAB0WIQQ5bPBtrWDUcDQCppg0LQZT0ays2wUCabAGIAAKCRA0LQZT0ays
 21bACACtmD+JNOZZE2WtYGgZs+OKFUvGXg8BvTcg2nAeuTAfDV15mPSXGDJtr1bOhVuDnL/Nw9l
 YuHe1nCI3Kb5gMl9oJ6QTc/nxqpUehwIiPaszmCzsqUT9Av4+JV9tbiRExsTnWgWp8/ohC7O/t7
 0F2HI97L08/EOhP6er3J/caSpZnOpbWXT+xXd1cfFQmhFO8426W+HbSPnqaYqXoPZvzXs04m+U7
 Y+HhZZm9gUaVM39bOf2O7FpXKP5lXlaxHXla0Syc5xOdqOCZGHEwLXH/1MeFU5JbVnp/DFE01i8
 2gpgUDB/Kr+8ov9qYVC2ZPrR+l2cjmrUojAxw0U8eiSwxKRA
X-Developer-Key: i=phahn-oss@avm.de; a=openpgp;
 fpr=58AF7C2E007CDBE62C59E078F50EFDCF8AD04B1A
X-purgate-ID: 149429::1773143724-71DC2A3D-384367F1/0/0
X-purgate-type: clean
X-purgate-size: 1997
X-purgate-Ad: Categorized by eleven eXpurgate (R) https://www.eleven.de
X-purgate: This mail is considered clean (visit https://www.eleven.de for further information)
X-purgate: clean
X-Rspamd-Queue-Id: C7C4A180011
X-Stat-Signature: ziy3dawa44muzgejpkuhjggu6er95jcs
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773143730-916114
X-HE-Meta: U2FsdGVkX18oMV0PLul4ZdCBXS12ToWr3c9C6t8gDwiXr93Z5/eGlc2wS9v24rV1WZ77TIiqhEfV3/9YgUBwv0pRrUglK+FMF8+aNwYGYzJJtr5tJ3cE7ma0Esx7kRecpXXZ0CDzwLafD5ncuH4lsF+6gPGuU40I5/NCxEqbfMQWBVJdgpiCJHnbkwxyoPfXBNv9SGfgwv/QbSNzQxQZh7EchEla7ngRHu/nXR21tH4a2Mf4dMsoFK7ZAe5RGHnVfzqZwc9crKHJgoPmMRI1XluMxsYS7izyk02eqrvN8+E4j5OCdV8pMqrZjEUryOf3zrj7iG78JcxfWU9RIWd5hywFvpa67V4aaR+0XiEl+3ChdNwDZQB3yLzUFjSk+uZBO2Zn9vBwf8q5SVWEvgrfMoQq667eddj5KlMztdHIQ5jaDTWO31NAUEVX816QY06jpCZohGkyU0L+YGbt/6vXzU6oZvfcEn4+eS0/Xgjj67gR3VmzN7dkS+Yql2ifM07xO0xXF1RxiB5WpXVGb7U8U6uSwK8c8AloitVhfXCpOYFe+4u6GvjGA3ogMt/h6iTxdqJFRLLN0tMhHE1tXel1Ehw3lmSCgrEx/O1UhifYl3+36r307/vfOhjgKPZVk/ThUEs1h1TXMKjLXsfCWt1tnHi74kI49i1uM06dNLU6YaM+MqU11TrWs9MO6G2LcZLRvim6jX5vnOKBtL+6Q2i4sfLqhPezTu5OqWYradvElZgpJez3SVo+8wlytgar2coE2g+Nerpl6lvI867sh1yFP0oMFxB4S3r5ciZkcmPBsD1S+WV40Fe32kwXfnfN3jutnAm52FfsU0BE5f5tVFmjSPYWu7pnR/jWVT8EED31M4rlGIdhVHdAqKZoXRz8cr0NO3bEadz8Tu4czV8/8xJv3Gly9h5UYpC+uxnonwt6dFvZz8LsMpXTsu65qQAlIXwqXWmMWd12070UmpD8Lia
 WUHBVcKz
 3d9KSPVvemVKqfnl6WkM4yVRYXra8xWAf+zXAyjE3i5D4bgLhJfuuE5Vhbh6kfIwyMZnNNeNtpcD5N/CYIB/3/ilJ16DZxW4R5CcyOMEgp/R+J9kyIr7W+WdiVjypMm/Opq1UTQ9m4lIKfJfUWn/sNR2Z3pR6+Pa6wHVRcBILG3vT5rbybNsP1okok9zWeg3Jm/86C7vAajmXC+CtqIXTwB45aFGAgiMAxR9ZlpbIrn6yFYVD7zWVwFAVM0O3qYAlsgEI89Zrxg8RhbsBnDZufiKp1MiF4XjP6xRNw7B+iOAmMx9t3MlmzNKqpCGnQ6CGvXGQPc/uZSNjaitawpr3ipOuLYYj1C4F7KPYgnveMDAlvqYWPDRxmgLHF9HYgxRP4BbyqRXiSSaDK8jKjbN5dfMr3pEd533fBVSFr3U3z9+VTte2zoL2FTiJawwG5xwxRDZ+QN9bsAPxDtg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Prefer using IS_ERR_OR_NULL() over using IS_ERR() and a manual NULL
check.

Change generated with coccinelle.

To: Alasdair Kergon <agk@redhat.com>
To: Mike Snitzer <snitzer@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
To: Benjamin Marzinski <bmarzins@redhat.com>
Cc: dm-devel@lists.linux.dev
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Philipp Hahn <phahn-oss@avm.de>
---
 drivers/md/dm-cache-metadata.c | 2 +-
 drivers/md/dm-crypt.c          | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/md/dm-cache-metadata.c b/drivers/md/dm-cache-metadata.c
index 57158c02d096ed38759d563bf27e7f1b3fe58ccc..32f7d25b83a181a30a78c663d48f7882cb97f7b5 100644
--- a/drivers/md/dm-cache-metadata.c
+++ b/drivers/md/dm-cache-metadata.c
@@ -1819,7 +1819,7 @@ int dm_cache_metadata_abort(struct dm_cache_metadata *cmd)
 	WRITE_UNLOCK(cmd);
 	dm_block_manager_destroy(old_bm);
 out:
-	if (new_bm && !IS_ERR(new_bm))
+	if (!IS_ERR_OR_NULL(new_bm))
 		dm_block_manager_destroy(new_bm);
 
 	return r;
diff --git a/drivers/md/dm-crypt.c b/drivers/md/dm-crypt.c
index 54823341c9fda46b2d8e13428cbd51f3edf642d5..05eae3d3c7df6baebd0b7a4219f7b6938f6e7f87 100644
--- a/drivers/md/dm-crypt.c
+++ b/drivers/md/dm-crypt.c
@@ -2295,7 +2295,7 @@ static void crypt_free_tfms_aead(struct crypt_config *cc)
 	if (!cc->cipher_tfm.tfms_aead)
 		return;
 
-	if (cc->cipher_tfm.tfms_aead[0] && !IS_ERR(cc->cipher_tfm.tfms_aead[0])) {
+	if (!IS_ERR_OR_NULL(cc->cipher_tfm.tfms_aead[0])) {
 		crypto_free_aead(cc->cipher_tfm.tfms_aead[0]);
 		cc->cipher_tfm.tfms_aead[0] = NULL;
 	}
@@ -2312,7 +2312,7 @@ static void crypt_free_tfms_skcipher(struct crypt_config *cc)
 		return;
 
 	for (i = 0; i < cc->tfms_count; i++)
-		if (cc->cipher_tfm.tfms[i] && !IS_ERR(cc->cipher_tfm.tfms[i])) {
+		if (!IS_ERR_OR_NULL(cc->cipher_tfm.tfms[i])) {
 			crypto_free_skcipher(cc->cipher_tfm.tfms[i]);
 			cc->cipher_tfm.tfms[i] = NULL;
 		}

-- 
2.43.0


