Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id EDDBDCA0FF2
	for <linux-mm@archiver.kernel.org>; Sun, 31 Aug 2025 19:34:31 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 3A6038E0002; Sun, 31 Aug 2025 15:34:31 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 357738E0001; Sun, 31 Aug 2025 15:34:31 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 26CA98E0002; Sun, 31 Aug 2025 15:34:31 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 1218B8E0001
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 15:34:31 -0400 (EDT)
Received: from smtpin21.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 9603DB9573
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:34:30 +0000 (UTC)
X-FDA: 83838054300.21.9A3F456
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf08.hostedemail.com (Postfix) with ESMTP id CDA18160010
	for <linux-mm@kvack.org>; Sun, 31 Aug 2025 19:34:28 +0000 (UTC)
Authentication-Results: imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T4R8Q8dG;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1756668869; a=rsa-sha256;
	cv=none;
	b=ZVjnEV4wEDwEqkA2LJ7PMbDlsnMnCeLojPFpY6ptFVZ+2ykXogluZipyAesP0VO51/EhOy
	NVv+lyxi3AT+rx3f5urSYBo4A0+W/cmjB8wuD7VzF5x7FUDzwXjZMUnPTJIJIEi5FqLNwn
	WUGfx1GwuDcCqaNZ+NpcYc3EoQ2q9Nw=
ARC-Authentication-Results: i=1;
	imf08.hostedemail.com;
	dkim=pass header.d=linux-foundation.org header.s=korg header.b=T4R8Q8dG;
	dmarc=none;
	spf=pass (imf08.hostedemail.com: domain of akpm@linux-foundation.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=akpm@linux-foundation.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1756668869;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=hOvyE1q4vnGQzDP+EK/jTsSw+P41vsnueObvXPP/zrY=;
	b=PQ4sxhDrNFaigZiyG/fqfFhtZaiDqmt5FKZ1kqPJm2OJgnv5OfcULJHS9jNv1uRwVyfffa
	f6e5SzzlUMY0x9Fk5yoDbO/6OWXdUmKH3viGFXrUPqrfgL7SadVkOgj7h5IMqhirx7jkMb
	5NrbG9vJsp8i/49Z4fmBYGB7crLzr0s=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id B3C4440A98;
	Sun, 31 Aug 2025 19:34:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1BBC4CEED;
	Sun, 31 Aug 2025 19:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1756668867;
	bh=sJmdTCCbtiT1DW26qBy6SEwGQBpDJbkjKYDcCD3ZiuE=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=T4R8Q8dGwblsf+2ThAPyIuYBcyGkPZLoISXWArHmyzYuGcW0kJj8JM/BgXYGtmRCX
	 TWlenIN1eDcQEwvUfb8sWbjiLHbwDWMk+0eDNpwnHXKyUjlmJYop94iCA1FceDj5g6
	 1ZUWwK8S+WiFwCf5XlxG6OREwRfpv7XaeXeedwps=
Date: Sun, 31 Aug 2025 12:34:26 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joey Pabalinas <joeypabalinas@gmail.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, Baolin Wang
 <baolin.wang@linux.alibaba.com>, Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH] mm/memfd: remove redundant casts
Message-Id: <20250831123426.3ce56a2448b520aba75f8edc@linux-foundation.org>
In-Reply-To: <efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com>
References: <efbbe6093b64a5b19f974871d5262d6e75dff2c0.1756639225.git.joeypabalinas@gmail.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Rspamd-Server: rspam03
X-Rspam-User: 
X-Rspamd-Queue-Id: CDA18160010
X-Stat-Signature: gg8dopjws1hcxj8nfpatawu5w6az7as1
X-HE-Tag: 1756668868-830101
X-HE-Meta: U2FsdGVkX1+fwvJJEM9K6V1e6MWBndUEdOB3ONIwru1c9kUTSBFoW2ugdnS31f2J87MtAhpfQktHAvM7kOvM9/l8gkPWGCQCiiGFepFF1UpYplbqNrswLQFz8TLQf8+Je//wdzc16MK7TkfomEytU3s6mJbSBWHbY/w1Uecf/atC9ZzIuc6HaoMwuXhmbGHsgb6lbYe/RVK+FRtY8eYf07l8RB7LF3csOhGjFLm0luxCyly6+o3ZcmqCNqxutiFA7cQ6ptnQjo/loBkzTgr2X8jwgG1VMEWrLg4qre2/PY/qcSFEcpsLI8HPhEsnavkfOrYKs+ozdywzRDU2qLNPccvAPoiE61DyeuSAx7GMigcspXvmUJ82zbhidzL1ln2rH04OluZAH3A09zShemoVIlI2zFCm9if7dWK8QqvNA11+SnPLOTSIJ6WHCXS5EfMJU/ZBj+Ya5t7QMXKXXLyFTQ1B++o76guvKoxF0Y+PY4smfEeK1GbGJ96bkH7CnZjixXjKBw7icyKrqxWNua24tlr91wenXgg660y2kiXnYCQmpgLqemxPiTnC+RrW/EpcxhCXn+jVJtiug9zM67SEsHM45VCoCsghQe6GlT7zYBFQT1RxX1a7LMCUaNeU1d18yQQU314Rb1bqZKE7QEiy4ONMyruEANehvONQaR+jK7jm0DXOU6PExk/I2grALnfLdDgoH3ZBCrfvH96nj+UQy8s/QCgIWMx5F09Wk6M8SkXonCwRyXcoO+u8fCDS0/U+aNSg5sChXgWlH7ckdHaAQoK9uTrUH0bb+053hu/S2E0q4BWDHkNrfDi45itGx+X0rAyH/GmxCb3PFrVOgrbLdPBBHsugRkDqbnj0mNsI84Xm/u3ALWx9f09hhIeuc4h06bYeg1Uqv5so03xxZgBUN4D5CXocTIvxd3m38iYL8DbmZoQAOqCOjKo23lN3Hy5bYlkeuVfq6U5t/mAd+qS
 k//x87Gz
 Ac+b8rCGsgd7PdODauQyv1WMkPNL1FSCcpmRoLF5FaIzZdsG99dCHGMS7QLlRHjKHrFgj2Cwt+3g1GNS8gGXmo1k0bxT2xMHUOUDivjU03jzNlN2bFkNeRXWPFIFrIkT1gRaEe52Gog5ts2giTLxzaufI4bQQngT5nwJCqhiIRHGj9Lg8WnEhVke+A9tu4aDxN0YRzsdg/B/4evuEBNcskmGrn9TVQ0E7xlCK7Q10Y025yhWBMaD5KcBuM1I9dor8ObqlVNt5wh+HnGRlt7sNyLpD93jtCis7D18FIkMUEgZUHBYWdp8xU+hEzoLUVoV3924uA7EwMb2294Q=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

On Sun, 31 Aug 2025 01:47:48 -1000 Joey Pabalinas <joeypabalinas@gmail.com> wrote:

> MFD_ALL_FLAGS is already an unsigned int. Remove redundant casts to
> unsigned int.

lgtm.

It's rather annoying that the MFD_ALL_FLAGS definition is so far away
from the other MFD_* definitions.  What do peope think of this little
cleanup?

From: Andrew Morton <akpm@linux-foundation.org>
Subject: memfd: move MFD_ALL_FLAGS definition to memfd.h
Date: Sun Aug 31 12:29:57 PM PDT 2025

It's not part of the UAPI, but putting it here is better from a
maintainability POV.

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/uapi/linux/memfd.h |    2 ++
 mm/memfd.c                 |    2 --
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memfd.c~memfd-move-mfd_all_flags-definition-to-memfdh
+++ a/mm/memfd.c
@@ -313,8 +313,6 @@ long memfd_fcntl(struct file *file, unsi
 #define MFD_NAME_PREFIX_LEN (sizeof(MFD_NAME_PREFIX) - 1)
 #define MFD_NAME_MAX_LEN (NAME_MAX - MFD_NAME_PREFIX_LEN)
 
-#define MFD_ALL_FLAGS (MFD_CLOEXEC | MFD_ALLOW_SEALING | MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
-
 static int check_sysctl_memfd_noexec(unsigned int *flags)
 {
 #ifdef CONFIG_SYSCTL
--- a/include/uapi/linux/memfd.h~memfd-move-mfd_all_flags-definition-to-memfdh
+++ a/include/uapi/linux/memfd.h
@@ -12,6 +12,8 @@
 #define MFD_NOEXEC_SEAL		0x0008U
 /* executable */
 #define MFD_EXEC		0x0010U
+#define MFD_ALL_FLAGS		(MFD_CLOEXEC | MFD_ALLOW_SEALING | \
+				 MFD_HUGETLB | MFD_NOEXEC_SEAL | MFD_EXEC)
 
 /*
  * Huge page size encoding when MFD_HUGETLB is specified, and a huge page
_


