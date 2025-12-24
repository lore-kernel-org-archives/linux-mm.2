Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 587FCE75450
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 17:34:09 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 479F36B0089; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 424406B0088; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 32A6D6B008C; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 1F8996B0088
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 12:34:08 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id A54F4138A5B
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:07 +0000 (UTC)
X-FDA: 84255062934.28.50CF967
Received: from smtpout.efficios.com (smtpout.efficios.com [158.69.130.18])
	by imf19.hostedemail.com (Postfix) with ESMTP id 335761A0015
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 17:34:06 +0000 (UTC)
Authentication-Results: imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="lsN/xG7J";
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766597646;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=0/mQaUiHM70bBczLVLafy0D3SjjlawsO2OOWMSQWL5A=;
	b=HeLxWDCsrc7V8FGr9JAciuKjzg+75JZb8nktrXn2w3eE5+BKkRvXkMX1CGnnY5XjeLoMgd
	6mQzi3ce7Bc9XcNnFPEhb/EKfTQpZ0vWVkcjCaQyJlUNq+s50BZ+j7bKNrjz27qufiAEqy
	EmO5rI3fhUCKmMumuGxxX6pP16wDW78=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766597646; a=rsa-sha256;
	cv=none;
	b=UBrQcqsduzNfYg2ArSs0fZvYdEMSOlOpL123HDAfWe9SkCweaYXGUvYtOgIOGylsSuGbAC
	dT+QVYHomWtpDN10ZBBiKAqxxVSBXBaTyrr9uthqjvHJEIF/ZRowhH1dk+UMYcdY/7sMye
	+VjQe8Udmn+Xlx5dyBjJKaVQoBFkaG4=
ARC-Authentication-Results: i=1;
	imf19.hostedemail.com;
	dkim=pass header.d=efficios.com header.s=smtpout1 header.b="lsN/xG7J";
	spf=pass (imf19.hostedemail.com: domain of mathieu.desnoyers@efficios.com designates 158.69.130.18 as permitted sender) smtp.mailfrom=mathieu.desnoyers@efficios.com;
	dmarc=pass (policy=none) header.from=efficios.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=efficios.com;
	s=smtpout1; t=1766597645;
	bh=0/mQaUiHM70bBczLVLafy0D3SjjlawsO2OOWMSQWL5A=;
	h=From:To:Cc:Subject:Date:From;
	b=lsN/xG7JJcUpgZ1+8MQ69LoqMCE2OzrJMR+NToR/r+zJAKYvq7lMQaYXloj5oyZhk
	 MB6b3AOBcXhUP+5CGFNQ5b3xE3LTuFY7g5WsieZ13kGTq7gkfMP0hUeoNjhQ7I5JaG
	 Yyt0fxVkGayDExYqrK37CBtNF/EzTWgiq5tyg9/vIpw5yMaAq4dkcRl/HhDSYyBJiJ
	 cTo99VJfi09klCAWnh+I5foY96IUMN3ncxBPpbPyjV2nUah5oI+GuW9DHnD2Ask4Yb
	 U47d174ndv3fPqPwpiz0qvFVtgc+hWXc0xVkMXFb0WUxKO/tSRezozu6vq6bRzJdZ9
	 LMJpPkmwTOZuA==
Received: from thinkos.internal.efficios.com (mtl.efficios.com [216.120.195.104])
	by smtpout.efficios.com (Postfix) with ESMTPSA id 4dbzWd1xMjzfHn;
	Wed, 24 Dec 2025 12:34:05 -0500 (EST)
From: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	stable@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH v1 0/3] mm: mm_cid static initialization fixes
Date: Wed, 24 Dec 2025 12:33:55 -0500
Message-Id: <20251224173358.647691-1-mathieu.desnoyers@efficios.com>
X-Mailer: git-send-email 2.39.5
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 69t7sr4qr995yu6eyyoqdpkda1x93wsi
X-Rspamd-Server: rspam05
X-Rspamd-Queue-Id: 335761A0015
X-Rspam-User: 
X-HE-Tag: 1766597646-980310
X-HE-Meta: U2FsdGVkX1/9wO0bY3RarE3zCWpBYbovV0kfpBRwRdEoz2SoWOzzygwRYZCA0wo0DyO5BZ9YB2WhqKiZIhzymHhQc+HjSz3ZemiGILiGeHMWG7wqr/5p0v1MFLw50UIgX/+HsQy8PExlxKpMdE1/Asb2cPvAfNi/N8joTyK4ud1NhgLi6vHkI0i7G/dpOqXkho7AEVRWEWt7FkPROBGm2ppHcO9BsgVBVxAePaOd/U/OeKqtaqxjg9Li4NwXtO0N80TsK74jrO0bBJI7gJ6/SvoYY4FWqr2fnQAw7W0c/f8syontD5WvGx0mz4r/bAzOvaf4KvS+LX3V+9KiDqctcu7g1PWo7FGOGiKY/Dfd6cOl0K0iGCNX+ddYzPKKXgGwozn79rgS2kCoFe+1ATDiwJ4vFslsrik1lo8YssauaAGEGO6Cs87TsLPysNOQtP17+zPvufnZ32Imn36PLrJmP311X25UG27+evcknAO1aHtnE4ZAnG+xk+ieHW8d5uj00FLj4/AednSBLA/m9dSlLULDtOzRkRVU601jqbUkBI5R7BVtnthjGqXsmQA0FHT+4slbHVdT/clqm7dBn8sATAZVBWGfqJCTxCg05lVNeUm+uQWGcbBMMV/RQhkARYbK1za4XoRaMHhCeATxovvAz3MZT1/cPWi4jOl3WZgejWc+LmGzrGhNfybCaqt6rft4hq7ewS2G90eK4z9JTD8LutzEZt3Zj7QT6pXZ4HHeXYUw0SDC3KtK+cSWFAbxqsF/fH8vwUOd3yS3f5s3WlFRO/pKAwMkElYIq1AU2k4CezU4RtyYdSPBweqsCPuUjrWR3lG5eDTLHBbxxr6tv4+aIV04xD8FGHte0dhQdScP2KCiZo3FPJi399rDVWRDCwjua0b4Va9k9fJSz5AkxXMWnjnIhzJ0V6VSbkM8pxn9S3fPyp2nVaeYT0c8iAl+WA+U5pi/dgGA4HAvKy6dvTT
 LjWlaUF5
 iGPEdoZNy41cnmiGBHFCpmo82blAEcpYhSuI5tM0IRnroYT8OCLQLz8F8Ouq9vxFl4WnTtwC6nQ9EKsRJfNlnvklvD52CaEIRzCPqSlNG4lRiFX9MehNLkyAw0pSdq9FgcDOAoVguT/e7XKzGSFJ6KdmoATUNPupAAGHrss/PT5IxBTeD3bzI9DErYwZAWy476T0njyeorj/KtZUp7HPaB7wtX3f/JJzClnMnqV/bYrTcjncStnyi4RQ98yIF85WrcYXKt/ulC2KehxFNDElzGWIIvWhn0bDEMGCsVFA3QJA5mFsZ1rlzZyQNG0iBHVsE3hPd/XHL1C106XGSn4urpnbYvzyXar+sB0UWAoDofiKxoyHvwjESzm0VYasBL22ZTGS6Pdl5Cq9dW+6XE67egamjxYdZk4S5fJ6j6upY1uwpPYlN54gKdEvyS5Gva4JHyD/FRfmglPA4b0Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Hi Andrew,

Here are 2 fixes for missing mm_cid fields for init_mm and efi_mm static
initialization. The renaming of cpu_bitmap to flexible_array (patch 2)
is needed for patch 3.

Those are relevant for mainline, with CC stable. They are based on
v6.19-rc2.

Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Cc: linux-mm@kvack.org

Mathieu Desnoyers (3):
  mm: Add missing static initializer for init_mm::mm_cid.lock
  mm: Rename cpu_bitmap field to flexible_array
  mm: Take into account mm_cid size for mm_struct static definitions

 drivers/firmware/efi/efi.c |  2 +-
 include/linux/mm_types.h   | 18 +++++++++++++-----
 mm/init-mm.c               |  5 ++++-
 3 files changed, 18 insertions(+), 7 deletions(-)

-- 
2.39.5

