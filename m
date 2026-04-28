Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 6E3F1FF8864
	for <linux-mm@archiver.kernel.org>; Tue, 28 Apr 2026 01:34:49 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 10F886B0098; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0E7866B0099; Mon, 27 Apr 2026 21:34:36 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 023496B009B; Mon, 27 Apr 2026 21:34:35 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id E63916B0098
	for <linux-mm@kvack.org>; Mon, 27 Apr 2026 21:34:35 -0400 (EDT)
Received: from smtpin10.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 9C0C0403C7
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:35 +0000 (UTC)
X-FDA: 84706244910.10.14FA90A
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf22.hostedemail.com (Postfix) with ESMTP id 0AFD7C0007
	for <linux-mm@kvack.org>; Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
Authentication-Results: imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMYK+IiU;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1777340074;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=GMUCrJ+gvGwaDfmPiXkEDkPCzQINbFEnETxptdhOtNc=;
	b=YF/cyQ4f6dPXPf+RXfJ0cYC1MeOdtfNPgMjKB0deRoa1hcoMO23nkcsl/yOfFWm2sim0kj
	65tgeYviiKcUSk8EUcvWE8wU/lwROTNcU1xKzAjfy0u9Lp62WnvLjWzn4lwDCpLbum0Xhd
	JnrITKBkWQSI08jRDSc8xSnhzY0PngQ=
ARC-Authentication-Results: i=1;
	imf22.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=DMYK+IiU;
	spf=pass (imf22.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1777340074; a=rsa-sha256;
	cv=none;
	b=y3BKGmw+tZwRMo7HCyQxmEGYBHcP9ge7lj1HwaiB3dsn5Jb2s8MZo4ltJ8t1IWgZbge2Yk
	sFuYhCbvHvgjhOn7FN1mHqJXGBFuhR3GQ/34d16R/qVE5cgk46dFHtrCcBZ9hIRu+KUloG
	7rzu95mOKwq2MOyZEzz3l36DgUq/+hU=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 3113B42BB7;
	Tue, 28 Apr 2026 01:34:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CCD1C2BCC6;
	Tue, 28 Apr 2026 01:34:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1777340073;
	bh=WgiRHi50zFvHwjFSQiNfyV/FQHY8WOkdhFM9Jv3jqj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DMYK+IiUNblpb/DS7qK8c0PyqQD0wR6G2o3EsZVQRVZUJmrtesZ02gBM/MBsMoiyg
	 sKRH3pY9Yxe4tOsO0XtkzxoaiNaXMTkwsfNedGmsOkQfQkWTd6y6aalRlhHBF5ihwE
	 RSGJuA2HbeqrqXF3KdgcvvaeXAXXqhQdZU+gj+jvzJud6iEYWBQA+xt8ab2FXxYb6e
	 CidzCwsvtZPTUh4ERLj00ORoK2rxzZHaSohjDglTG6nqdi4d6I++NoH3hzJoZ7wyZ/
	 KDC1hifafdow9/8DnkApYaMdcrUCduOnSpwcJSe3HQ/O65ad/nc51+RG37qcFTqNMr
	 hmS0LHv6/pfgA==
From: SeongJae Park <sj@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: SeongJae Park <sj@kernel.org>,
	"Liam R. Howlett" <liam@infradead.org>,
	David Hildenbrand <david@kernel.org>,
	Lorenzo Stoakes <ljs@kernel.org>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [PATCH 07/11] Docs/ABI/damon: document fail_charge_{num,denom}
Date: Mon, 27 Apr 2026 18:33:56 -0700
Message-ID: <20260428013402.115171-8-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260428013402.115171-1-sj@kernel.org>
References: <20260428013402.115171-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 0AFD7C0007
X-Stat-Signature: jx3mdet4sy8n6bcq88sgcxa755nayaf8
X-HE-Tag: 1777340073-806474
X-HE-Meta: U2FsdGVkX1/F0xxY5mXSNmSqf8ROqX6KSMp0s+HHCrOirWcX3tWIN7AukQI81Dkp3XC6TD/CGRH8HitGFc0YHHPtUMx5/LVvPtcgXYcLzz6fEyl5rDnO7uOLfzgMEJL9i0y6516Q46K2qhEpT2AmU8Yu9Tw3lad2xm/dG1OvOmbYSyYUv+dsazxDsC7kVLLGbI5WP0RhbQjvGcr+4ssOLT0nDtDLT+0wg2+iA0uTKiLU5Ok3QIOafCd2kyr72a+obHK4Y5Y+8AdDAx1NXKBgdNj3fTtsISI4EwFh0LaVmysfTm5Yp2lK8+uMA1Ou/3wTEobdey75hv9C9GAst6JrszDkEwSpgRbr7sPAb3zgJky/p7T8WytxXNxQuTKClzZ1W8VhIZK9Fs+wgovjnX+yRCR9ZgeJO0CdVL8GHfOtLjl6j4+IUNTomF0lAv92sOryuonPuO+LXHxTN1WNVhlNyIMZQgWM7z4F3ArLjdVjE4N+ZeMHjNTreIvrvWvgupxnThGw2TZm+x9L6pwa5O3m3xTEYhGgAZdL6RS0E9d+b4Cw3M8MmYIvyQgf+ezX25xu+jT0t6QQsX7FgR/eBXjXMkcGS6bMtdU2DPMaXJJ+p5NdyW0ne6C/nxPJqUhpn9a3rNl/Ni5DlTnyLoe4F1VCTmPN+d2hNyEzFSoU0Cak6KPY5q9x5p/TfXr3O5lpYgZsvIusa1v+ZeZYUB6pqZ3lpSrtntsWF6WYI/7sGctvBZ+JKA82hVvkpwE2AjfKT/4/s3SdtJnclmgT6Bv1tOD/trjmTkFI4Cmw1o/Vae0NqrYvu88+gweommu5CknSncB64n6Ce/iXqxsNQemiPMQhTbm3pfOgornPYXkhCusFJnTtWCXkq6TsHtylM+wJmSfUUxzJOLVjCkWNwxuw3vkFC0cMjURuWGkq/GA3u30ebRDdbE9d0Xliv2T34nIgyxwuG1fLxSQioUeGYdvjeoH
 2dasLtIk
 nW0e+T1ZB33XhUvw0zlKMZgqaXDGc9mfAx5wOCiduiRyfTOgULlKmPrkAt05GXzn50ax2t63+vrjt7SFXnhoQ9/tyxUHxHTc8MRBTHJH7EZtDWem3AktARPYUlHFzVGxwCjCtU9950jyPoqOZ4fsL4AqGclk8DcKeyyrxnHL0RFEjJCssjxqufpDA50DhS+AgwoExzqrsacF5E0BRuikg0XwpgaAEKSSXHWell9FCaB+bp3LjI5jG9DIfPJ+a3X98yVvAUgjEFCFQN3v7metiKhMJ2/7O3CoB3/mkHS5FduZf7HTWfjoIno+b9D059DxbArfO
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Update DAMON ABI document for the DAMOS action failed regions quota
charge ratio control sysfs files.

Signed-off-by: SeongJae Park <sj@kernel.org>
---
 Documentation/ABI/testing/sysfs-kernel-mm-damon | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-kernel-mm-damon b/Documentation/ABI/testing/sysfs-kernel-mm-damon
index 7059f540940f0..971c22e34e722 100644
--- a/Documentation/ABI/testing/sysfs-kernel-mm-damon
+++ b/Documentation/ABI/testing/sysfs-kernel-mm-damon
@@ -329,6 +329,18 @@ Contact:	SeongJae Park <sj@kernel.org>
 Description:	Writing to and reading from this file sets and gets the
 		goal-based effective quota auto-tuning algorithm to use.
 
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_num
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio numerator.
+
+What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/fail_charge_denom
+Date:		Mar 2026
+Contact:	SeongJae Park <sj@kernel.org>
+Description:	Writing to and reading from this file sets and gets the
+		action-failed memory quota charging ratio denominator.
+
 What:		/sys/kernel/mm/damon/admin/kdamonds/<K>/contexts/<C>/schemes/<S>/quotas/weights/sz_permil
 Date:		Mar 2022
 Contact:	SeongJae Park <sj@kernel.org>
-- 
2.47.3

