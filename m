Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59A01606A330
	for <linux-mm@archiver.kernel.org>; Mon, 23 Nov 2026 20:08:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=outgoing.csail.mit.edu header.i=@outgoing.csail.mit.edu header.a=rsa-sha256 header.s=test20231205 header.b=oMZz/VYu
Received: by kanga.kvack.org (Postfix)
	id 208C96B05B8; Mon, 23 Nov 2026 15:08:18 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 1AFE06B05BA; Mon, 23 Nov 2026 15:08:18 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 0C5A86B05B8; Mon, 23 Nov 2026 15:08:18 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id D6CAC6B05B8
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 15:08:17 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id A43DE140942
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:16 +0000 (UTC)
X-FDA: 85467470592.20.F830D19
Received: from outgoing2021.csail.mit.edu (outgoing2021.csail.mit.edu [128.30.2.78])
	by imf08.hostedemail.com (Postfix) with ESMTP id EDD1D160002
	for <linux-mm@kvack.org>; Mon, 23 Nov 2026 20:08:14 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b="oMZz/VYu";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf08.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795464495;
	b=zSRw7vl7FQNviWy7OhfwPyf1PpsbdU0mMC2WL+pXvYUvLco4OxKd9xke8ruk/9XpNKXgGB
	JBS4Pj5dEpxFLimsezyzp5C2YXq4fdIbdzXr3q5DLWVn2dueNQRaU+Pxe3rabzHqZdvI4i
	NdYz++ivKOf11uybVepm91EuoUs4FHI=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795464495;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GX5aMCRIgJiZuuGkpcknd4x+6v9xITU+D6Sjcmd128Q=;
	b=rimaO8evsGoPmF7xfS4iLxkHFlZFPe/TKlOeYUcwKzuAxwGZcmVggzs63CJCXqJKz63p2D
	5/JNev6JZcAHWz/O9pn5Ka63yzBFqIyNeOGlLMKD01mlxpeCNt7c0UlC62wrPAitnD8Pux
	WGX+4BTGgmUt7xEhCFR7syMKsW6oMlg=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=outgoing.csail.mit.edu header.s=test20231205 header.b="oMZz/VYu";
	dmarc=pass (policy=none) header.from=mit.edu;
	spf=pass (imf08.hostedemail.com: domain of srivatsa@csail.mit.edu designates 128.30.2.78 as permitted sender) smtp.mailfrom=srivatsa@csail.mit.edu
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=outgoing.csail.mit.edu; s=test20231205; h=Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
	Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
	List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
	bh=GX5aMCRIgJiZuuGkpcknd4x+6v9xITU+D6Sjcmd128Q=; t=1795464494; x=1796328494; 
	b=oMZz/VYuZq/mqtt1ODf7SQgFWvKR9s0TiV0l/nHE59fWS+SSz5ZTQe/GNMu8f4jt9sYbUXl5fUT
	QH7QfUVsORdg7PF7zZzQZrohwSRy4X/g+9RUIBdZyy8BGSZ8Xnlv9bCMk1vpNiStyrm4/hm/D/ucc
	0KqQQurPECrqt/lClrT3R4tKBmYEVWH+Zckv/a+joPbAzOnyo/j/xXmE0qDEVh6zBBYobtnTI5XWw
	vTY2NCrJ9H5ecORLlzwLZ7dsRj5PRhG4tM4S3G/93Toclw4457aJu+vuUNk8cPzmSEKPOMmpjfcmI
	QSBWI6XRqlYnLCOc6PgXdDPAszp4NtRGOpog==;
Received: from [49.207.211.146] (helo=[127.0.1.1])
	by outgoing2021.csail.mit.edu with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.95)
	(envelope-from <srivatsa@csail.mit.edu>)
	id 1xVaKi-006jgv-4Z;
	Mon, 23 Nov 2026 15:08:12 -0500
From: "Srivatsa S. Bhat (Microsoft)" <srivatsa@csail.mit.edu>
Date: Tue, 24 Nov 2026 01:37:54 +0530
Subject: [PATCH 2/2] MAINTAINERS: Add missing files to KDUMP subsystem
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261124-fix-kexec-kdump-maintainers-v1-2-79c6a6144de4@csail.mit.edu>
References: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
In-Reply-To: <20261124-fix-kexec-kdump-maintainers-v1-0-79c6a6144de4@csail.mit.edu>
To: Andrew Morton <akpm@linux-foundation.org>, 
 Baoquan He <baoquan.he@linux.dev>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>, Alexander Graf <graf@amazon.com>
Cc: kexec@lists.infradead.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, "Srivatsa S. Bhat" <srivatsa@csail.mit.edu>
X-Mailer: b4 0.13.0
X-Spam-Status: No, score=-21.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 4kugqtc9a1iz9jkn85e7ahixc13kmnqf
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: EDD1D160002
X-Rspam-User:
X-HE-Tag: 1795464494-31513
X-HE-Meta: U2FsdGVkX1/bjF9T+PsbjJtPS8Ue3RVGyrIrlj/j47Sqi6MezP04j2aKoMFXQPcdYBtK6PaCJmFA84GRrZ/+dU2sNsYfZq0PwFUoXZGt8rosaIw9XBMJd+h2zJurejRxK4Sfrm/F0mSY7lRLuxHIDqdFdtDI25alGkFp+zRncqhyioeV2NUwbcvG+Pzq8Wp7DQtaLM/ovz+XZFC+3C5Gg3lboQSIjc76XBk+iWdcIDZvLNFejG1Xn+O0jbdroUSzPOtIbWEIpyjHXF58gJ5364hcFdf4HZWd1cxbkMOJnFdOTa+fxjFCCY9+KPdRhy4jcmJvYFslSDFGbKXiKkT1vxhRYkghRB/9zV7OK11uq95UY1kJUUW8l74kcjKV0Cy1FsoFABvuFHQnkREcjUWiqKE9JDhviAvdOYCgtXFOhfiwWUEZvzx+Pqf2tS29St9+rYZXkzcOGa4HBqXFPksaCHK0Qm8oxtazkEqoWbCK22+2N9lEXDopd7c3DdpLGOl6CsPiSz2Lk6FjsYaI082bQrYRgZDoksG2GJ3My/fmfpzQUncWevgBmKVftnW2wSNZnvahgpp73PRbzBQq4fStxEu+8gO7oZJEg4pDMoZgVKg689/Lh4p9J+L1G1nkXDwUCswCTIv+pNPM946//XhHhZIxxye8t3P94qFy9ZgE0Aceu3uqKw8i+2MbqgJqrSMu7Udpq5587p4oNXD32AKsPI1OFaUxeb3xPrudK1I+X6EwsgMpmhEO9k1tlddbqhodgUUs5SJ/K73CFzapKwB8t/Tg/2EtfZYzk6pR/rRo052p3ojHAGDiwD7xKWPNsgUkKTLGGrbOz4iIOYGTTCF3u0ym+GDE7wjmTBNs5Ns4OYa4R01SyOoF6yI8bd66AKgpn24tmfMqNfVCCx//oRTBZJvsH7kulaowjWM4oOEvQh3rCZ9hIRgs/zpihCKn7ugIK6M/5XtYVKe0pFGaISw
 RK3uLu5c
 7MHoiEg/FT4LgPcgwx/A+YsSBw9LPu9ii7MWDj/C2xBrBWb+GI5ZEKzCkkj7h379FSzB7TAjAZMN3sKp4eXdhm+arT80aIIosDlWof4rabAniHRva0Aw0D/2lxsSL2WEpMNS8OQ/W0bnyZYhYdNvkw8n3Iu9AJXjDRlTj+RezTiLactPp1kKI/juFQ3grUDD6en9uqlDMBSrF7XHDJGGmUQ8obLTwwihiM4m5ZkgaOObC+vFl/0ZmpatHDE/x7ZQjIJJSsRiapOFJ/+I5tIypLyYJMso/Xz5YQXD+oyAf5eZpR2WQPnSL4GlrIsmTitkzp6Tuci/jFoApeQEaltrfDauVaJ1iCGlY99SK1rD08u3VR7Dz5xNJ0JW/66lI8Jm6v1ZzTtZZH3mevwx52Qg/8kWhEl0gdERDtX8y5wG+5PP9zbo9Nq/RsNh1sHpCAV+p1bVSwbrepHJDyhXV0p8dKREeOHVsvGhn0YkkK+GccqrX0l7ci3wobnFJ+M9bJ7o7nBOH
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

The KDUMP entry covers crash-reservation code and the vmcore interface,
but omits the crash-reservation header and the vmcoreinfo implementation
and header. It also omits the dedicated kexec/kdump and vmcoreinfo sysfs
ABI documentation.

Add these files to KDUMP so that scripts/get_maintainer.pl can recommend
the subsystem maintainers and kexec mailing list for changes to them.

Signed-off-by: Srivatsa S. Bhat (Microsoft) <srivatsa@csail.mit.edu>
---
 MAINTAINERS | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index bb4d9c20db06..bb8e1c414394 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -14429,12 +14429,18 @@ M:	Pratyush Yadav <pratyush@kernel.org>
 L:	kexec@lists.infradead.org
 S:	Maintained
 T:	git git://git.kernel.org/pub/scm/linux/kernel/git/liveupdate/linux.git
+F:	Documentation/ABI/obsolete/sysfs-kernel-kexec-kdump
+F:	Documentation/ABI/testing/sysfs-kernel-kexec-kdump
+F:	Documentation/ABI/testing/sysfs-kernel-vmcoreinfo
 F:	Documentation/admin-guide/kdump/
 F:	fs/proc/vmcore.c
 F:	include/linux/crash_core.h
 F:	include/linux/crash_dump.h
+F:	include/linux/crash_reserve.h
+F:	include/linux/vmcore_info.h
 F:	include/uapi/linux/vmcore.h
 F:	kernel/crash_*.c
+F:	kernel/vmcore_info.c
 
 KEENE FM RADIO TRANSMITTER DRIVER
 M:	Hans Verkuil <hverkuil@kernel.org>

-- 
2.43.0


