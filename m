Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id A2AA1CA5FA3
	for <linux-mm@archiver.kernel.org>; Mon, 28 Sep 2026 21:32:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 2B17D6B008C; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2611D6B0092; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 126236B0093; Mon, 28 Sep 2026 17:32:19 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D101F6B008C
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 17:32:18 -0400 (EDT)
Received: from smtpin30.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id B51B5160345
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:16 +0000 (UTC)
X-FDA: 85264469472.30.9B36BD7
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	by imf02.hostedemail.com (Postfix) with ESMTP id B48EB8000B
	for <linux-mm@kvack.org>; Mon, 28 Sep 2026 21:32:14 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0w2fQHyA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oOmX6cu8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s0z9NEtt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TgOEQmUv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1790631134;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=5N65SW2lnlUuWkywLaz0HQTuF2/HIV5pv7mL+4fQsx/FMUGCveQi9MbbG+VDyz0SEVL80n
	k/exo/fnxPd8woqQafW8hDNAkNTsnri3kTMnGi8RjJjN+27L7ygC9o/ZNs4LlcEvt5L06G
	TOWUqiVrR53VWCtefqEzDQQqeApTrrI=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=0w2fQHyA;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=oOmX6cu8;
	dkim=pass header.d=suse.de header.s=susede2_rsa header.b=s0z9NEtt;
	dkim=pass header.d=suse.de header.s=susede2_ed25519 header.b=TgOEQmUv;
	dmarc=pass (policy=none) header.from=suse.de;
	spf=pass (imf02.hostedemail.com: domain of krisman@suse.de designates 195.135.223.131 as permitted sender) smtp.mailfrom=krisman@suse.de
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1790631134;
	b=r9I4CMcN9ZbO2EKHcgiF2eq5fIxAsTxSjmu3XSCVpOJANtCE0MxFwJwca3d7Np+LbKjesi
	JdXGiBLOl3l0JBfOCvxEVabL2rfg6W0Ia+IA2BXmrF5P7+oxyY7J0TGwkPxNJ7dSKmc2Va
	Oq5bt5M34IGhQ/RI5/FlelFkZiO3pFo=
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 1530D1F399;
	Mon, 28 Sep 2026 21:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631129; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=0w2fQHyAcr8/hNkn1q6kWi4QHof21q5V//SgtFlybSbGAoS88w5Esn95j8d67fiqD/3/WD
	Dqo9UYVTDjpm0OXkIW7H+VKFvoX9sci6cDFFW2cJaHlI5p6YaqVDPZ52h63tBm+osuvG8I
	5nD39gaY3J4GN2w3ggFFsKAd9xMmDXs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631129;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=oOmX6cu8PaeLUh2yFxZ7+uZQZcIHN3tJXZaJtGRFS4EjClr79oIZb35JEpNtb/DdFfpR4R
	PUCoshraaYNvYUCg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1790631125; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=s0z9NEttE6n9iAaAuyBRYxWEFNScItaY0Nh+Gsc1J/WdhBkvSTh1OAZEa1F8i88+E2jFya
	EWteEDJBZQLif+w2jQ5f4aOrLVsDNNTZ1mBo8x/R28BApIrx97Jsnn3sG3Q72KjakWGXGD
	GASNm9lDhpjpRD1UdR1+W+TAtgspNgs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1790631125;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=EBW8VfSpfZ9PWZvy6KmzYcKLrex3/2Okopr+CK0VKew=;
	b=TgOEQmUvPyvvyilCHFezLEljruw2urh0b9a2Zfv9Vw0N/7ZD4UBi4uhzC6JQlDdp0h4DJ6
	s2bcXaydg8iz/WBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 76A89133F1;
	Mon, 28 Sep 2026 21:32:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +DMZDtTcumqMMwAAD6G6ig
	(envelope-from <krisman@suse.de>); Mon, 28 Sep 2026 21:32:04 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: linux-fsdevel@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@suse.de>,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	"Theodore Ts'o" <tytso@mit.edu>,
	Hugh Dickins <hughd@google.com>,
	Daniel Tang <danielzgtg.opensource@gmail.com>,
	linux-ext4@vger.kernel.org,
	Miklos Szeredi <miklos@szeredi.hu>,
	Amir Goldstein <amir73il@gmail.com>,
	linux-unionfs@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 0/4] Expose encoding information of volumes
Date: Mon, 28 Sep 2026 17:31:51 -0400
Message-ID: <20260928213155.2612039-1-krisman@suse.de>
X-Mailer: git-send-email 2.55.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: B48EB8000B
X-Rspam-User: 
X-Rspamd-Server: rspam07
X-Stat-Signature: 1q3fdsj383cybtfim4h556gjqf1d57sh
X-HE-Tag: 1790631134-239696
X-HE-Meta: U2FsdGVkX19kbO+Nkbw1VRSdwdMC9DLB62Dx6GiFZnNL6nI4vmhgZA8AOQb/x8LqFOHbCNOKO6Ckg+nCq/MwmytgVrqh+lLz+sqOmSi7eFtYi5Zolzfzi74HZInhCuHKngkVElhDvt8esbPZzORKKgrZHcc4DAbR2BK7u6EiJ5B61cE11Yb6yL8ubQRFQC9+nVRw0agfrbOUJoSuBa1alHwNL2SP7ucugM4R7Llo3dYKVf5BdpJCJZj9sHriOvUXbNjfi1800uzjPrHP1mjM0q/5va+V2zMqnHS372rTpkvZ3kDkf05KduMgZg/zY7/oPeV3kSvYCYGeiNWZqF9JdRbRzUYu7n78eC+rLOJs6kVlNxRqE07AcocLc2Gi8tDy3ZIe0m89Uxs0O4zDiQ7NbumkSSHSe5MLbX+yhMW/oWn72zkV90z3cuwNiWTu6hpc+hyaV9wJfm5cSLy4R+Oz3vayZi8sQtNMMW9JX53wwIl1n+RyNrrMe0TyesJdOAXYo3c4oxpYcHjU9LCTUXcoNcsPCXuvHuUg6a39OgFirLrIvpxm9VCaDP4iNqqX8UclcqhReLP8Qj5c92fGuSIi0iA/In1fs1WNRPTHoaoTKDH51+VBz8DMEUF0j0hD1eGpUNRaJBwR8tOp6NfyfAiGqn5z/zBvrpU15YkBDcGNSKoiAMp69YiNEv1P9T9lMbAlD30uCkwhkirShYXPrQtiTdwJ4bzdbt+qdENTn0HeU7B7Vyu1ZEINg3Igp3owWWL5RnGuOpiJNO/NpeZOFuDmuJZBL+NJmTwjfEa2VTdAudbcVxmzQantedCUBCBcHP7RX+2Ld82ttycV/Pc47HAmwP5PQR8h2/LsJujQQn/2qp/Hh3eGbDjWcnbIXtORn/wGjyFGye7fOg9SR3HIl6ERyskmPLxyNuAk/njbkXWO8JvJl8H0ra7/y8sl4Df+D5iub9PVjueDmafVfJtRra/
 lRmSeEIQ
 v+Se5OtMb1nacVx4tHNIHr/cuh+ieiVTDqF/I4RrQrTlTb/egtEvHgYq7Yc1kxnd0QHDCMBqOgMl3A4FIxOVBljcDe2AT17sOeGsvwgSEYZu3d2Ppri30T8meAC2I2mPLnAk9IH7vaLOCjP7Ht8rPXUqaN0RZbL1HyBAI7YTtTLO18os/ka8L+FYBzf46tQKX9en8xZF0lVxRqVcOldwwhPP/6JzSGvEMttUcMnKUjByZYSW3tTRpA/qT2DPgRa3qDFnXeexC3MJ7h5qSKpUs7NYj+vs4c6yZGVNzbLHujx/qDBUTRNvpzWKWJ8rMkBJc3RMTRShoZLpjkTsD4jz6bEY82gxyyr0XvZauCMLcnX4i6JlntXTpxCEyKhehlA5Fe31pqt2G/b6fjzIzT3PQiHkqMEMDDIChNCrqDydLlR4YbRzR4l7G2t/HnZuOxDC1SMKZNHcqUC55dOQwy6wYhQVipg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Daniel Tang reported [1] some inconsistencies in detecting filesystem
casefold support on shmem.  The problem is that we don't expose the
casefold arguments in /proc/mounts for shmem, requiring you to probe the
the filesystem to discover it.  More interestingly, it can be a problem
for programs that use /proc/mounts to remount filesystems, making them
to remount "case-sensitively'.  This apparently is a real use case in
linux utils, according to my favorite LLM.  shmem is fixed by patch 1.

This made me go look at how other casefolding filesystems expose this
information and found it to be very inconsistent.  f2fs is the only one
doing it properly over /sys/fs/<vol>/encoding.  Ext4 and ovl don't have
nice ways to expose it, so the remaining patches replicate the f2fs
interface for them.

I considered a /sys/fs interface for shmem as wel. It makes sense.  But
since shmem is the only filesystem where casefolding is a mount option,
it also makes sense for it to appear in /proc/mounts.  Considering it
doesn't have /sys/fs at the moment, it does fell like overkill to add it
just for this file.

ovl also doesn't have a /sys/fs/ entry.  But in its case, casefold is
derived from the lower/upper directories, so it cannot not be set in
/proc/mounts.  For this reason, I ended up plumbling /sys/fs/overlay and
wiring the encoding file just like ext4 and f2fs.

[1] https://lore.kernel.org/linux-fsdevel/5193732.31r3eYUQgx@daniel-desktop3/#

---
Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: "Theodore Ts'o" <tytso@mit.edu>
Cc: Hugh Dickins <hughd@google.com>
Cc: Daniel Tang <danielzgtg.opensource@gmail.com>
Cc: linux-ext4@vger.kernel.org
Cc: Miklos Szeredi <miklos@szeredi.hu>
Cc: Amir Goldstein <amir73il@gmail.com>
CC: linux-unionfs@vger.kernel.org
CC: linux-mm@kvack.org

Gabriel Krisman Bertazi (4):
  shmem: Report casefold setting in mount options
  ext4: Expose the filesystem encoding through sysfs
  ovl: Add /sys/fs/overlay plumbing
  ovl: Expose the filesystem encoding through sysfs

 Documentation/ABI/testing/sysfs-fs-ext4    |  21 ++++
 Documentation/ABI/testing/sysfs-fs-overlay |  13 +++
 MAINTAINERS                                |   1 +
 fs/ext4/sysfs.c                            |  29 ++++++
 fs/overlayfs/Makefile                      |   2 +-
 fs/overlayfs/overlayfs.h                   |   5 +
 fs/overlayfs/ovl_entry.h                   |   7 ++
 fs/overlayfs/super.c                       |  26 ++++-
 fs/overlayfs/sysfs.c                       | 116 +++++++++++++++++++++
 mm/shmem.c                                 |  11 ++
 10 files changed, 227 insertions(+), 4 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-fs-overlay
 create mode 100644 fs/overlayfs/sysfs.c

-- 
2.55.0


