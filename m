Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 4FA27C982D1
	for <linux-mm@archiver.kernel.org>; Thu, 17 Sep 2026 13:48:15 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 545CB6B009E; Thu, 17 Sep 2026 09:48:14 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 4F6076B009F; Thu, 17 Sep 2026 09:48:14 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 3BE406B00A0; Thu, 17 Sep 2026 09:48:14 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 0DEB66B009E
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 09:48:14 -0400 (EDT)
Received: from smtpin19.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id A1A7840378
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:48:13 +0000 (UTC)
X-FDA: 85223383266.19.CD81F11
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf24.hostedemail.com (Postfix) with ESMTP id D2E02180002
	for <linux-mm@kvack.org>; Thu, 17 Sep 2026 13:48:11 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="AJQr/362";
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1789652892;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FJzQcNI6ERpoXaAHSV1A2WIicaI84oaHobrpffLzFwo=;
	b=QLGBrGHorBTRtS4pGIZX1jlceA1ePxKx+hKhbGTFuhEeQJsf0G0v1AP6pW6h6T3MJi20Ze
	DSJN8NgYI84b2k9y3lIUoWjLtfeelmqTyKajrvS6FyfXRdKI68LfCY3Os20Yh4b28c/Dw6
	3jBs1cRFB5lIjsFHp2Z9tNPVQDSRkPE=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1789652892;
	b=VW21oorhzgTmAr/GIGkBKo29nYhho+30l4FbhK5bNQCU3I9aRONvkCfGJczmcU6v4qnKE4
	0g33XmHjGjTcWPdz7e2elcTYvS5jK4CTcI1XDjSUthRg5aJnNNqKdP6inS1qCJtrv++1QL
	33BBV29BpeOwjB7YNfXjCrT+mnyvd4M=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b="AJQr/362";
	spf=pass (imf24.hostedemail.com: domain of leitao@debian.org designates 82.195.75.108 as permitted sender) smtp.mailfrom=leitao@debian.org;
	dmarc=pass (policy=none) header.from=debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=FJzQcNI6ERpoXaAHSV1A2WIicaI84oaHobrpffLzFwo=; b=AJQr/362+8Dn/1bQmS3G6lbGp9
	TQhbJJirbYuCXe79pG2OsxmjdEIi6JcALZvo57jSw1uhKe9RFGPJw30oEcnRKXHHNaAzFC+gTUHhj
	KDHi01VMQK1ej46sFVY5tYAPnueEnTfkRUcWEWxUEYBqtOZDOjeuXLT2SRSD2TOZY0r+H/Dgcib6C
	fAsu9JS0QREFQk8gteX2rDKndhp4XeGbolWPn0WzntUgO8z76QlUyIZdJWDemmsVZfgzJsvSiEhcA
	LHUNlW3wPsyeXpd2njRns35wwSaIdUjo5pa40ulSxNPEYVVj+7uMKgC02Oqd6PnXCIoCyippBQNZl
	TAgrazaQ==;
Received: from authenticated-user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.96)
	(envelope-from <leitao@debian.org>)
	id 1x7CT4-005zBu-0p;
	Thu, 17 Sep 2026 13:48:03 +0000
From: Breno Leitao <leitao@debian.org>
Date: Thu, 17 Sep 2026 06:47:37 -0700
Subject: [PATCH 3/3] mm: kmemleak: raise min_unref_scans to 3 for verbose
 auto-scan
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260917-b4-kmemleak-doc-v1-3-84fde6d1f749@debian.org>
References: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
In-Reply-To: <20260917-b4-kmemleak-doc-v1-0-84fde6d1f749@debian.org>
To: Catalin Marinas <catalin.marinas@arm.com>, 
 Jonathan Corbet <corbet@lwn.net>, Shuah Khan <skhan@linuxfoundation.org>, 
 Randy Dunlap <rdunlap@infradead.org>, 
 Andrew Morton <akpm@linux-foundation.org>
Cc: workflows@vger.kernel.org, linux-doc@vger.kernel.org, 
 linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
 Breno Leitao <leitao@debian.org>, kernel-team@meta.com
X-Mailer: b4 0.15-dev-47773
X-Developer-Signature: v=1; a=openpgp-sha256; l=2472; i=leitao@debian.org;
 h=from:subject:message-id; bh=+q6xDl34YUOS8Avf5cU8XdLmZVvvs+tZYTzpjpHrFfE=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBqq+97HiS12bKDm59NAUX6612dYs4+CKNi1kW0B
 Sye5XuP6jWJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaqvvewAKCRA1o5Of/Hh3
 bRXZD/9gOr2ZVF/m47Q7MyVKTJ/pd5BoLlLNCHSYpmV1T8x5aMO9Pc6TVnsLOVtlO3cpWIA7+YN
 fanPS0vkin+q7U47J2sLd7XHMVOEGmEE7Qr0MZ1c4GcTZpg/edkYDZgQ2Rjtd/wigKKdyl0a44/
 3uKSmBukPPCeq+E2F7yx87ERv5NANBYmU1crrR1O3imSN6PDVWiZtXM7Y9PtByrSc/bcJl70Q/5
 zkpns8QDBr/QgSclq8oWGlva5LQt8bZIqRKz+VwngVR97OOX7y1H6KSBZGQaCmyhEy1AgvjDEMT
 f4FVVk242Z93y7HdXp2W9ZHNhdcenhDoQrlTJcqsrpFQRv4fTt8tfwD/IuNuX9Rfv7XIO5rBxEq
 UIDPmahLS9rXcQk+pOSSHV4cGogL66IEPC52bGcRlPNyGdE2rcuJr7CqtU6gWYxMLtuhQwZcYW/
 gT05/1Rz8p39fm8ccG930jhfh/uNteROrYxEE8r7Z1Uh0yp6smXjt9IavDkHyt4ljbz4QDVXN1g
 bX0kvFKB0eDTlPw8R3o9ct57FyoqFTCE/3PFtB3hPCuwrevYTfdun50E3AFy1uaKaea1UiAprJH
 4/o+AWUdDBxBAn9QuWm645trNK/QV2k8aZ0JpS5oqbHLE2GK23ba6FYH/FeDn7LYNdbcKu8+bgb
 EYLTQSDazJ6jmAQ==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Server: rspam04
X-Rspam-User: 
X-Stat-Signature: qcz6f13edaa865snp7nmdrgrew1mjei7
X-Rspamd-Queue-Id: D2E02180002
X-HE-Tag: 1789652891-704504
X-HE-Meta: U2FsdGVkX19VJPEqQNX0PdBqLTge2du6jf5WXzmcZ4KXCoiqVqtCIC7hF8ln8Vr01fipSOeMkAqQYyPi3tSN0LZyDWUh5qy4xB46+zeQD1tH65EqzQk52mNf5C4Wi+m/jXYX2k3mxw8BDtyRo7YZkpj+pGKE4B7Y9pcZarQmXPDR3Qrfgm5R3NAEYAyRiLykzesX+BIqLbKc0LSZfTRoBsIIKTiVXkiBNaCoscnTxmzDwP4kMcJzg9udM1OP09n42joUgba6gXnwJAnWgabj1jegRb9W+K+MTiJDy+x95enGDcNLo2vvNSwJmjof7pFtQxlsKlsCOky/QrQRLwsZ4f90Ifod74btcR4Ic3S13cdJybQBleWfKP5vyGCR/onbyISe6r839mmxn6Dtyb4Xg61F1pry84eVnOUVeJbvoUWfClBrjfkVPotd0awB6iScNqizS+vMv6bcILF+amuTSrhKSD5VS75zLmOL3REQjGSFuacVI7qPeV2JZ0Tm3btP0sp0pW2HncMsJVIm6jSp6olUHlbGvfYr7NW7oHJv57Nkc90opsiA3fl3hu0bUD1Wiav5MKxvG1QDB06hE6xlXswFztZe+F1xGMmwaFU9cjj1+nngzWyBkQMR5eHV+xgRn3MluSJN7ekRmM1yJ2ASp29mRafkmzTuvIoH9QVbTdG727nKitsS55lEvwrkUglD+7k4eEXzLXkzR65l9MF6B0T5K0PBl4Qzqb784ktjQjjqY/4baTx35z4LRChgMjaIRQX83wPu9tcoXO3Rp/+5iBlKbMa/IV5m7+tegrX0zpFCFrE6L8c7FWnBLIHjqQisH+GeQ72VnHawKK7AQoUCpmaHJEgjxzqZnizg9OL73ANTBz6PueA4V2iRcMTTbjS2mv/3ggSd7J369uzc4xwNf9oaitaQFJ7R6wnBr5+x97rJNMbP9px2cqFTInc+Qa0xbMbTa/Cwvxv8Kx7XFX3
 Lmwb4Ba/
 bBsfd8CBYtCuuR28V+siaxaXu5CF3BV6gLDw8qOUjqGZ4wVZN+96N43CuKQRPU2y0i66WjX+ZdY/dhQYyNGKTxouDAPNRRJWV4eFGSlDCb9LfQRirvNBEAhWaQbvOYb4MVGxbq8JXo3GfIox+edmxiDQF3cArdJjkoPOyXL72ZQ0Acxtjck6dx48mHlmifZ4JiUi/Ux/r2aDqZEWH63hLb2bUXCzG6bzNEFiH/tLSYoIUJlgCEWFFX2XkQ2KQDpLqy8ZDfZuTlvBvbtiydusnWVjpBIS6yZZ2WyTzizoB6Y2asxIHAc61O/ZrH9AIsToepjduiFTXOvV2jJ8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

CONFIG_DEBUG_KMEMLEAK_VERBOSE sends every report to the console, so a
transient false positive there is broadcast to whatever collects the
kernel log rather than sitting in the debugfs file until someone looks.
That asymmetry justifies being more conservative than the general case.

Require one more consecutive unreferenced scan before reporting. The
only cost is that a genuine leak is reported one scan interval later
(600s by default); the value stays writable at run time through the
module parameter.

Kernels without CONFIG_DEBUG_KMEMLEAK_VERBOSE keep reporting on the
first unreferenced scan.

I've been running constant upstream kernel with
CONFIG_DEBUG_KMEMLEAK_VERBOSE set, and I am still seeing some rare false
positive, that goes away with min_unref_scans=3, so, making it the
default based on my heuristic.

Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/dev-tools/kmemleak.rst | 2 +-
 mm/kmemleak.c                        | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/dev-tools/kmemleak.rst b/Documentation/dev-tools/kmemleak.rst
index b5fe7e671d0f8..c0d3293723425 100644
--- a/Documentation/dev-tools/kmemleak.rst
+++ b/Documentation/dev-tools/kmemleak.rst
@@ -206,7 +206,7 @@ the minimum age of an object to be reported as a memory leak.
 
 The ``min_unref_scans`` module parameter requires an object to be seen
 unreferenced in that many consecutive scans before it is reported. It
-defaults to 2 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
+defaults to 3 when CONFIG_DEBUG_KMEMLEAK_VERBOSE is enabled, where the
 periodic scan thread confirms a leak on its own, and to 1 otherwise. A
 value of 1 preserves the historical behaviour; higher values filter the
 transient false positives described above, at the cost of delaying genuine
diff --git a/mm/kmemleak.c b/mm/kmemleak.c
index 8fa409a4f9fb2..5d0daea93c471 100644
--- a/mm/kmemleak.c
+++ b/mm/kmemleak.c
@@ -238,7 +238,7 @@ static struct task_struct *scan_thread;
 static unsigned long jiffies_min_age;
 /* consecutive scans an object must stay unreferenced before reporting */
 static unsigned int min_unref_scans =
-	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 2 : 1;
+	IS_ENABLED(CONFIG_DEBUG_KMEMLEAK_VERBOSE) ? 3 : 1;
 module_param(min_unref_scans, uint, 0644);
 static unsigned long jiffies_last_scan;
 /* delay between automatic memory scannings */

-- 
2.53.0-Meta


