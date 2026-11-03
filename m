Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2584606D803
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 15:55:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=muMo7dJ+
Received: by kanga.kvack.org (Postfix)
	id BB5F26B05B4; Tue,  3 Nov 2026 10:55:00 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B67F26B05B5; Tue,  3 Nov 2026 10:55:00 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A7E496B05B6; Tue,  3 Nov 2026 10:55:00 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 807506B05B4
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:55:00 -0500 (EST)
Received: from smtpin26.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 184701A047E
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:55:00 +0000 (UTC)
X-FDA: 85394256360.26.D83C420
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf29.hostedemail.com (Postfix) with ESMTP id 09A0E120004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 15:54:56 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=muMo7dJ+;
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793721298;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=Ck44c2UfWH+h/SZjs6hhnY4TSP8skS7HgYjW2Pc3Sw8=;
	b=OL+aBeqVPFFtYgjmvgXJTGP17vHVLnlBDEvjdiq0jEDmiWyxvycWGriVzdxwVF7n2IvkWb
	2LBAum7OLg7ltyHzMxzkGzDipPMxlox76lWCSsAFGiUhNEq+AkoKS0XMDTXtDAVabbk3it
	OgYNg4sSc2+lolA1R2Tbv09ScUApPeE=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=muMo7dJ+;
	spf=pass (imf29.hostedemail.com: domain of sashal@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=sashal@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793721298;
	b=b92+qkp6l29h0Yp2aG0OpGvwdElIOsMTVNLGh7+qASc/NmvDsPcymUBgHOicLRbpft9t0x
	XF8rbFPA6VC2pnXZMEt7JjMKPDirid4t72Q4PgjYXXGeMsL1C1dFG294bnDlpa81C1EJEY
	VgJMmCcO9lEDr+u1z0uEPaV7m6Eu7Rs=
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id 9334960A51;
	Tue,  3 Nov 2026 15:54:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC571F00A1D;
	Tue,  3 Nov 2026 15:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793721296;
	bh=Ck44c2UfWH+h/SZjs6hhnY4TSP8skS7HgYjW2Pc3Sw8=;
	h=From:To:Cc:Subject:Date;
	b=muMo7dJ+XRD3cJ3oFIwHl/jPZeP8jiC9wxWa1y734cCt4RL6GEyoT/YLz5Wp14p8H
	 tX/Dk+tFd8w0P191zFqGB5ErDAS5dxY8hMgyuYmseMWOoV1v0Y++TgJtY7erk17Gs5
	 w0uiiT+BIn54P4tiGOghaAasKgMYSmetD+wZGCvHGS0Nf2FEo4MwyW9P7J2XtPDG4R
	 fEQhh4dgFN2h8WL4E6MXQC1Sf2i+JFkDn5Yd8cv7GWnaBj1a/+I5EtP9mRq9K8N7gL
	 XbFE/pA0H7TTrmXBM5EFZpfjzIds8LFOpysf0OkaSe2Rb0YaNOkWHv7ASsIlpt8kM9
	 xB4Awo/sGIZQg==
From: Sasha Levin <sashal@kernel.org>
To: Suren Baghdasaryan <surenb@google.com>
Cc: Hao Ge <hao.ge@linux.dev>,
	Shuah Khan <shuah@kernel.org>,
	linux-mm@kvack.org,
	linux-kselftest@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH] kselftest: alloc_tag: use the ll64 types on powerpc64
Date: Tue,  3 Nov 2026 10:54:54 -0500
Message-ID: <20261103155454.534649-1-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: yh973w1wehqk5yzrirj7w4kk571gep1p
X-Rspamd-Server: rspam01
X-Rspam-User: 
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Queue-Id: 09A0E120004
X-HE-Tag: 1793721296-457832
X-HE-Meta: U2FsdGVkX1/Mg9u8vhJ0iDpyGjpMqVwW10Ks3inUPsjpFeClQUMH4MXhePGgd/eoLn/K/tk9nk+lt+dBcY2QFw2+Gv0Wy7vEvzJO+Sxej4mzZpbvtmR2H8NVIuIKl5BOSIjOrRsOf/hsDbo2qFmvNBbO9yTzSJCP78R+YB450BdiPB1E4iv2jHTYM5cXDDisTleb4dGXAc4tJOnAuh1Rxz/EFZzvGmnAN63svQMinhRNdP2PzyEsAQX1hR+EeJ2Al8YFHuOE6WGNgGLfN0Sf/oWsxovdBTO8XcqL0Lf0O+xYwt1jqYWXizrsUCSlTPFqm8k4SJb/4spNqHHPBMj0AtBfi8mHxBvqpPjBsV1x3BAMec9FbIKq7BIUveKNz7FCjEuyXoT8LkOst143seC4E9mUS0umrxfyBF0SewHAc6E8mpEl8wwY222r+nP3ijVd15RT61WJw56PR0sCPCmxuxNx8juD177OaZ7cgTC80hhow+bUKEe4crA7GrPsjdN0h23W5x/5P7B4ceeAFIEM/gedUN77n9RLirGVZ2BVW25PooYts891loLb/2Jzv6rBkjRQK+xM1SNAZsII0poNTJtx5/HfIMphqbZYhrjzvX06rj2AsFNox29vZ3dgvg1BMURM4yFISA1k/7f2Sa1cH1rVsU0hgEAO/OrKs3Rl5TFjpq1ph+oYl5uIOZEkzGTnaeuKGJSt0osx3ct95gVafvJe+XZdsZQAvY5zNXGsWJpKiPnAW0+gsJPpX+lt625DT2angMok1fYVLLySGFmjxPNk5Z213gBPw/XLTkiDm2X8lh2XzlC5nys/kmZJSIl8Rp6T4FLkxTwxCZpISvGpUILI+XDiTw+4AAY7zJcP2tqXq0MqcSnuVdB2aKqlo0ES1LWYS6wV9BACFEW6EuCOHKG/ez9WScG2fLtFZO2kikH78ve0xtfc5fSyHbS30dxKqpq8UiTuKMUAS7fBump
 8dNwmMut
 CL72MKdSNnPTghAw9nQ+IW8BKl71zK3RLwL+ouA6vu6LvyqZvq/DLKKaaRNbha/SjW3q78M0PKkHqG5dQieKZwOyCveoRTNkwMGZsI7DRQiHckQ80tKG4kgECtJVj5o8zjwE3J1VHGVk+tDU/ZFArpTyVtvZfpppQ5myUNlopZp71MipjpI/Rf6MjtzUQ9PI5TbIWmwVOW/a1pNO2tc6M688Vo5xcuv6cdR/vkJIrvmg6G3XgRcsnY9PxYn1eDOvdTMUV/gweb67fNGyGHYkfeCCkqQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

On powerpc64 __u64 is an unsigned long unless __SANE_USERSPACE_TYPES__
is defined, so printing and scanning the __u64 fields with %llu warns:

  allocinfo_ioctl_test.c:93:73: warning: format '%llu' expects argument of type 'long long unsigned int', but argument 2 has type '__u64' {aka 'long unsigned int'} [-Wformat=]

Define __SANE_USERSPACE_TYPES__, as other selftests do.

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
KernelCI's powerpc kselftest builds show this. The define makes the same
change on alpha and mips64 and none on the other architectures; the
x86_64 and 32-bit builds don't change.

 tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
index 74fd64b2370cc..18c761fecfde0 100644
--- a/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
+++ b/tools/testing/selftests/alloc_tag/allocinfo_ioctl_test.c
@@ -1,4 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
+#define __SANE_USERSPACE_TYPES__
 
 /* kselftest for allocinfo ioctl
  * allocinfo ioctl retrieves allocinfo data through ioctl
-- 
2.53.0


