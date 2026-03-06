Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 27F80F0182F
	for <linux-mm@archiver.kernel.org>; Fri,  6 Mar 2026 12:40:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 945C06B0098; Fri,  6 Mar 2026 07:40:11 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9248B6B0099; Fri,  6 Mar 2026 07:40:11 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8275E6B009B; Fri,  6 Mar 2026 07:40:11 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id 71C6C6B0098
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 07:40:11 -0500 (EST)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 102C21C390
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:11 +0000 (UTC)
X-FDA: 84515595822.06.909C1B5
Received: from stravinsky.debian.org (stravinsky.debian.org [82.195.75.108])
	by imf14.hostedemail.com (Postfix) with ESMTP id 0BD0C100005
	for <linux-mm@kvack.org>; Fri,  6 Mar 2026 12:40:08 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=n3mdsYCp
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772800809;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=ov55JeCCcCTI9x6RF1+xOgMdlYSvCZuzinIPQ6ZR/W8=;
	b=8Z9Nmke7T1J0PWmIi22dNJL4kaMvoP+3Rjo8MoDCP++2tUCumZjE3h60nRmbl+5u5GEhaT
	I1kd752RUydLDoqKL4FRHltB8H/pWSpBFJ12MRExTQ9UmvxfpzbOE86s52G4JgkOIG8gDs
	z+qmsg4uZ6Ng3QOzy7CJvVap6vSZLls=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=debian.org header.s=smtpauto.stravinsky header.b=n3mdsYCp;
	spf=none (imf14.hostedemail.com: domain of leitao@debian.org has no SPF policy when checking 82.195.75.108) smtp.mailfrom=leitao@debian.org;
	dmarc=none
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772800809; a=rsa-sha256;
	cv=none;
	b=gcHlfLuYhsyY8rIbt1jkN0aYxsHFDZtFkN/b3Wltxr8KoVV440HECZRJbWBj70PJD7B7hS
	IPjEQNZyF6OmOWSiP+jOGiXkjJyHhd5S4wgMwAsqMJIskmGgnhVqze5hyidbs2YDBTwgdi
	1npg2LKh9+I7rR925yA8ZzfnhJZJEsQ=
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
	s=smtpauto.stravinsky; h=X-Debian-User:Cc:To:In-Reply-To:References:
	Message-Id:Content-Transfer-Encoding:Content-Type:MIME-Version:Subject:Date:
	From:Reply-To:Content-ID:Content-Description;
	bh=ov55JeCCcCTI9x6RF1+xOgMdlYSvCZuzinIPQ6ZR/W8=; b=n3mdsYCpgoWo4ZadI4IRQMe2s3
	2igiPsHr8bu/s0uHunrTT4u0v2shTOqTNeX7FmzAUeEviKXBwzaRRXkBjScjnFw/gQd93Xm5J1ybI
	d5Q81YdkfiqgYdWDqW2dK+xwddNzEkoFxwlwgVbxZeYUsgZPJPdXwkS612XbG75kUC0WGGIlLwE+D
	A/pmENobybKc/tO68hBIjUuOlHPlgsSqbxdepPtw7f6JT8mqYKKfmPrRYlWuysrogb7DV6jdAJQEZ
	wHPrIZLLLqXYqZDxmzEzqll/Mj86ukQvvk7FtJ3rgNN0Ou3XqnRI64bpXTtnvm3d8VYXu7Akr8OCB
	9p9ylgQw==;
Received: from authenticated user
	by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
	(Exim 4.94.2)
	(envelope-from <leitao@debian.org>)
	id 1vyUTM-00HVRn-C6; Fri, 06 Mar 2026 12:40:04 +0000
From: Breno Leitao <leitao@debian.org>
Date: Fri, 06 Mar 2026 04:39:25 -0800
Subject: [PATCH v7 6/6] kho: document kexec-metadata tracking feature
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20260306-kho-v7-6-404d14c188bb@debian.org>
References: <20260306-kho-v7-0-404d14c188bb@debian.org>
In-Reply-To: <20260306-kho-v7-0-404d14c188bb@debian.org>
To: Alexander Graf <graf@amazon.com>, Mike Rapoport <rppt@kernel.org>, 
 Pasha Tatashin <pasha.tatashin@soleen.com>, 
 Pratyush Yadav <pratyush@kernel.org>
Cc: linux-kernel@vger.kernel.org, kexec@lists.infradead.org, 
 linux-mm@kvack.org, usamaarif642@gmail.com, 
 Breno Leitao <leitao@debian.org>, SeongJae Park <sj@kernel.org>, 
 kernel-team@meta.com
X-Mailer: b4 0.15-dev-363b9
X-Developer-Signature: v=1; a=openpgp-sha256; l=2486; i=leitao@debian.org;
 h=from:subject:message-id; bh=QTYE0HCCPpFCLiFL5V/nZqYT03OWnMpDhIbyr7syUIs=;
 b=owEBbQKS/ZANAwAIATWjk5/8eHdtAcsmYgBpqssGqwKfHdo2QxZJ6I25DRn3JnCg9iml8RDR5
 KBHqXz3mHiJAjMEAAEIAB0WIQSshTmm6PRnAspKQ5s1o5Of/Hh3bQUCaarLBgAKCRA1o5Of/Hh3
 bWTgD/4jWQiT2UnkeKb9NEgYI+ILjpkrxclkPGXdbg4z8XrpmcS7fzoREezM0yFZd9evwYRH+7T
 kbtvWRxfUeDI4XmFGQ2Ovrai/v50qE5nEHl7L/mfolZM1J+kktRv/zpGBICBb4lcJOYRtdKZhMi
 RDC30ctSlkl3OJLuIbhbNl3MxywiWvMHBXWPX4SAxKSIxkTQCZCOzITHKJltf9jZYZ++2X4+hDO
 x6NYMp0nswM4Oij3+hMgVjvVQ0nygvIPrl1j66yGA47gKa7kOhPigXcScQiEBwv5Y5kNCLztk+v
 Ex3OJd8XGNoFsqDvIKSIWNc2ssVgx/3wwRzLNuFYExoG+8//L9FmhaZJhxE0GOkh1ZvTsBnXpnQ
 44IZ+nnukzcjF4qfZ/LL8aXmGVsj2eYrHLGP6STMYu7yFlU6Nnh5R7d/8yFzqv8fMAaW7Z1fGgv
 xLcqCQNcOeL7YbxGf0g/sxdWGWJzmeP+RaQR1bNmuNFuzeqYqEc/2+J8Hp9doEP0HqY8wddKpkF
 uoiwhKDNMyb8tVIIu7q9LXULlz5kiqGvnokn+XBwEad9oeEVabEL9wiLz5do1tyOiQUzFYslwnf
 CyU7UUMJDyC63h0gbp4sPRARzaQlJMWiBfY1rJyoDPYKI9co06Bk7X2/h0G8o2ArlY6zwbuFt+x
 X+VwYWAubtbstLA==
X-Developer-Key: i=leitao@debian.org; a=openpgp;
 fpr=AC8539A6E8F46702CA4A439B35A3939FFC78776D
X-Debian-User: leitao
X-Rspamd-Queue-Id: 0BD0C100005
X-Stat-Signature: zuxkreqdxg9aem8nh597mk7oh31zfhwg
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772800808-790914
X-HE-Meta: U2FsdGVkX1/dZ01VqVtLUWCWIeQVkUv2jgUdVhuGlImFqmTUT76qBb+QEOIfcLLzTOP1dVm1IFSsTEsAZ8nB7NEQ8Qp0pbsGiJpdkPwPn6n0f9hF+xM4JBU1Qr2ZA0/WfujTSuq5zvzu4i48HXqefhNj7iVJMQgYefFr18nFIS53bFJd8lU2GZlHT1Sm5rnlTN3nPkubrmccF5RQ9enc0ROwodXdw1S2Tt3juMTkxu1ogTjEdBAiNj7na8VsBe5UhdkrpCCmCXeg/oOsiV3GZs71HKRsB32q6q53aJDXxzxwB7eaHdIHgBwY5Ng/ISmvh/+MQaDwuYINgPh7H4f+FmZoRERc1FxGlVTdFVsR7vNBLJztttFQu2/eo68gtAi6LwXTQPakePl+ujqLp75zBvucAdOCjZdN5ES+6n/VT41pHV2R+6TQ4EM/yXZC+gqGpZxxH0GEAIAIR4F66/TcFoXIjikNKAKqnT8E1XM84dwWH5MPf4s9C5+SB5ve2Gr8W/MoD9BiqxKkt9BkaYpEBdpomXOzfu6oEPZltIiPkST0J/JrD9Vw/FTUIK5yLHoZVwhIWgqvghtEVDrSYjLSyF8691+oj8lPHgVPf8r1DbUyJ7KnZHJYSqBtLAbEqhQseUPcVA0noH9qfn5rl3yJlfIEz1T8hFAcUWALKeBqXegqH0AoJxnPK2mlVf8J6/GFOHBiVjj47lcg+Tyd0DTC9zypj6qXdfrmROs4rYgt4FVSVnr7QoWgeQsscGYwnT+OqyM/SVdM4or4zCUM4PGvFx3Uq/RBJMN0HVwwnIhtmRKFlyA5YxuYuv1kmzR8DzcDZNE4warkmkjo1isSO41Eisz7qiEGUGMNB8S7zNzuYtfP08ykoAhLIICX+jQAGuXHlSfPawo0y3H7IGgcuhFMcOfLmGCxUsiDn6XbPCMxiDoDVVkkVUNxFZ+/+Tz2fRXVKoja46+ZtPyf31CAdfy
 AIJVpRbC
 P2BOPI6BHcdr0lDQNRct7G6CQv/Ri1602G4pOm2yB9JeZcw39GbIhLNuuF1zVA1Xf4aq7HnjbhJRVMwKsT5NRUnOcVfsnLfqu3mMPmDCFWCeI9IT2ZMh0Nd2k2QgjTrZqGdaV2IbuH6z6UUEqwm678wVYnchair48rOllEIVNluLNhyoR8w2Vylnchg==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Add documentation for the kexec-metadata feature that tracks the
previous kernel version and kexec boot count across kexec reboots.
This helps diagnose bugs that only reproduce when kexecing from
specific kernel versions.

Suggested-by: Mike Rapoport <rppt@kernel.org>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Signed-off-by: Breno Leitao <leitao@debian.org>
---
 Documentation/admin-guide/mm/kho.rst | 39 ++++++++++++++++++++++++++++++++++++
 1 file changed, 39 insertions(+)

diff --git a/Documentation/admin-guide/mm/kho.rst b/Documentation/admin-guide/mm/kho.rst
index cb9a20f649206..b439e4db152a4 100644
--- a/Documentation/admin-guide/mm/kho.rst
+++ b/Documentation/admin-guide/mm/kho.rst
@@ -42,6 +42,45 @@ For example, if you used ``reserve_mem`` command line parameter to create
 an early memory reservation, the new kernel will have that memory at the
 same physical address as the old kernel.
 
+Kexec Metadata
+==============
+
+KHO automatically tracks metadata about the kexec chain, passing information
+about the previous kernel to the next kernel. This feature helps diagnose
+bugs that only reproduce when kexecing from specific kernel versions.
+
+On each KHO kexec, the kernel logs the previous kernel's version and the
+number of kexec reboots since the last cold boot::
+
+    [    0.000000] KHO: exec from: 6.19.0-rc4-next-20260107 (count 1)
+
+The metadata includes:
+
+``previous_release``
+    The kernel version string (from ``uname -r``) of the kernel that
+    initiated the kexec.
+
+``kexec_count``
+    The number of kexec boots since the last cold boot. On cold boot,
+    this counter starts at 0 and increments with each kexec. This helps
+    identify issues that only manifest after multiple consecutive kexec
+    reboots.
+
+Use Cases
+---------
+
+This metadata is particularly useful for debugging kexec transition bugs,
+where a buggy kernel kexecs into a new kernel and the bug manifests only
+in the second kernel. Examples of such bugs include:
+
+- Memory corruption from the previous kernel affecting the new kernel
+- Incorrect hardware state left by the previous kernel
+- Firmware/ACPI state issues that only appear in kexec scenarios
+
+At scale, correlating crashes to the previous kernel version enables
+faster root cause analysis when issues only occur in specific kernel
+transition scenarios.
+
 debugfs Interfaces
 ==================
 

-- 
2.47.3


