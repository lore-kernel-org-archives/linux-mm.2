Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 3ECD9F3ED58
	for <linux-mm@archiver.kernel.org>; Sat, 11 Apr 2026 16:49:42 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 44D5B6B0096; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 383096B0098; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 226686B0099; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 049396B0096
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 12:49:32 -0400 (EDT)
Received: from smtpin06.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id B7AC95B341
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:31 +0000 (UTC)
X-FDA: 84646860942.06.C14818A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf15.hostedemail.com (Postfix) with ESMTP id 1D1C6A000F
	for <linux-mm@kvack.org>; Sat, 11 Apr 2026 16:49:29 +0000 (UTC)
Authentication-Results: imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/FcJ+iy";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775926170; a=rsa-sha256;
	cv=none;
	b=Xn4VzxPJYNEfcvmyB+DLhyRHM4O5ge4Pf+gtgcHaLgYxYJc+5OWgM7gBfilTDGIe8Z2URX
	PxafEfYHsM158pTquomIE/8gM5lDboBgEmpkXRWs5i21tmfJCjhsUubXL/Wm5B4d5cTpfk
	nOQRMekgF+8g0/eCbWYZgXFNhct3EG4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775926170;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=eTSjVLYPguBmCdyYoU8/p+4xBT6J/c20Yd4o4tKZLuM=;
	b=1ClsgS6XP8nnVbObSaYPcRrpKVCsrWlLIGc3x3JmTWdpG9f3MTkeJLFY9iHcWr5wzGltC4
	M2l3OZllVh0X7IY8Om3HvVkWSZdZjkgOEJ1/av9Cqk2QUSXFoqTr3K0MJ9RWuNHmtZRRbi
	lyWOmKoBvu4mBe41dD3nsTkat2W1ufA=
ARC-Authentication-Results: i=1;
	imf15.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b="Z/FcJ+iy";
	spf=pass (imf15.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id CC51F44581;
	Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33A9FC2BC9E;
	Sat, 11 Apr 2026 16:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775926168;
	bh=x42u0yyujS0MNNJ5zIzlJ5WzcqjchBB5xjDhcoIlpNo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z/FcJ+iy9IwVcBSq8BZODV8vNmnfox9bfxN50LS2S7JpuBtsMGy/TH6y4AfGxoFTI
	 aH097i279rIn3CS/9PQ6QKDB41dcQ/O+VNln+dtk9i3m8t2XI+E8Hu9G3RzBPWBiqG
	 J2jfJ9wDMTXuTqMOjlkwI+Wbv45WSDrtaEgqOu5O/nwn9Qo3+aolLPhscezobi0G1z
	 qroOk625ZB0VTYVP56wUQV2J9B5GzSBL7Hd64WAQuW3fdCBJEuDF45yF16rs3BACyO
	 Wz34u4LrXYYdt8snbWg1avEc73bFWBquYhVdw48ChYEtk4ud1TzMvFOTT4sTs8CbRK
	 0iqoPmFepDJmg==
From: SeongJae Park <sj@kernel.org>
To: 
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	David Hildenbrand <david@kernel.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v5.1 05/11] Docs/mm/damon/design: document fail_charge_{num,denom}
Date: Sat, 11 Apr 2026 09:48:58 -0700
Message-ID: <20260411164908.77189-6-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260411164908.77189-1-sj@kernel.org>
References: <20260411164908.77189-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Rspamd-Queue-Id: 1D1C6A000F
X-Stat-Signature: ikysnu1srotfnwjezjcimzf3bnc67pwb
X-HE-Tag: 1775926169-714386
X-HE-Meta: U2FsdGVkX18fmHBImL5XMcDcxsGu5Bs6QZ2H8hB7X6UpUBx4gP6UVuYH6vz9zMrkxUj0IQBkY9lc03Y0c7NzCxHV9qcuf1q5WFIyLgWR7A3jovqSBldlluJ6MTxPyAJqY84MDrOAFGebJ1mQFWVcnv1bufWSCYqYcEXqIfrz4Rcz2u58NCm5sO51UCYt2rofYrytOXxm4xxhVoP6w56vfhOWBTSgVgRqTtTC+1Yqx3hss0EIwwaE4q3GcpcDU0ToUm4Wx2DNVgPt+kQ4JCoXsLHgljcHng06vtz33gZRfBKTFoqGyM746uZ8GxCOop+3qzfCVMihSxGAtjpMF6Ld53tIaHiN1L9Wf3FeXDB2mvJjDsJT+tzVEVcczSWaIRx9yTq8KZkJygiP4mvJKgxVQdNosZ/iebpT33SRNIFYE7bSIUDPd2Hdy5tALPYj5U/0bot83bQpgOrtuSCNocDNSYI/QzZckh1vaVRAKBMbUusFZI/+6eXqphDWTDkQt7gGCq+eBtOpc7tIS92c6Mc/DNBNsJtM1YsOVEUQz2PdFIKlmV4HsraRX06dx968GF4Cy3cn+Q/wjmZCVXJ4Fkosi1OqDPLWg2QfONUVP8Phd4UlIPW/gSSb6u8pMm11VdZ6r3DkYRzKxEUW7EOQr4rh9LVL75epKljXdviUWKY/sgArWO72NMqtS/kQ9s5ZL5WShGOp1izmP09/YAA51SPmAz4NKqeLBSN2wmZ+1zpmDC4kcBmhz2pwKusl1Y09ZaDiJ7doqaFVDtq/xi1FtleMD65AAY7uhVaN4KLu4upiADVdx4RZMro5DEaASZCOWK1cPeqLiqLcy6+6I14SKHB5OijrQZlBUrYUahR0fqqw8NuLCO/n714CRLNK0/pvbgx4F8j5MkTNYsr1kMGLmt8NWkYDl7kzdSbTgRfp2HadnP3lGsO40QoBF+aDQgTxPANuFlxF+edBfJ9NuR1Xvq+
 9jUUZdTC
 /+ps9OqMHc+cj/Fgww0803A/hkATZ6tZBrwj8P7OoT8glmVkEJyQuyni8GKjj2NneCT5aW2j6w0bbAGBRb+YpBouW0DOQSZbkUfdEpaEhByYBl7GyeXG3U9lMwbk31HpnaSZtVvNyGU2ovtcWczkbZskJ/ws3ByvvIovkTziAPnBO6Xc2wt0Vq+z1a+wbKVfE9zpGMzZlrbZP6leOhuq342e4PQCouefkkUUBCASqNyvOlG17hvGx//5lytS1BtTesJym4+Zaezz0lcyrM5y8AI0TxBTIq0oGEm9b
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON design document for the DAMOS action failed region quota
charge ratio.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/mm/damon/design.rst | 22 ++++++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/Documentation/mm/damon/design.rst b/Documentation/mm/damon/design.rst
index 622d24e35961e..fa7392b5a331d 100644
--- a/Documentation/mm/damon/design.rst
+++ b/Documentation/mm/damon/design.rst
@@ -576,6 +576,28 @@ interface <sysfs_interface>`, refer to :ref:`weights <sysfs_quotas>` part of
 the documentation.
 
 
+.. _damon_design_damos_quotas_failed_memory_charging_ratio:
+
+Action-failed Memory Charging Ratio
+^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
+
+DAMOS action to a given region can fail for some subsets of the memory of the
+region.  For example, if the action is ``pageout`` and the region has some
+unreclaimable pages, applying the action to the pages will fail.  The amount of
+system resource that is taken for such failed action applications is usually
+different from that for successful action applications.  For such cases, users
+can set different charging ratio for such failed memory.  The ratio can be
+specified using ``fail_charge_num`` and ``fail_charge_denom`` parameters.  The
+two parameters represent the numerator and denominator of the ratio.  The
+feature is enabled only if ``fail_charge_denom`` is not zero.
+
+For example, let's suppose a DAMOS action is applied to a region of 1,000 MiB
+size.  The action is successfully applied to only 700 MiB of the region.
+``fail_charge_num`` and ``fail_charge_denom`` are set to ``1`` and ``1024``,
+respectively.  Then only 700 MiB and 300 KiB of size (``700 MiB + 300 MiB * 1 /
+1024``) will be charged.
+
+
 .. _damon_design_damos_quotas_auto_tuning:
 
 Aim-oriented Feedback-driven Auto-tuning
-- 
2.47.3

