Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 29014C43458
	for <linux-mm@archiver.kernel.org>; Mon, 29 Jun 2026 12:24:51 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id A2AAC6B00BF; Mon, 29 Jun 2026 08:24:40 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9DA3E6B00C2; Mon, 29 Jun 2026 08:24:40 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 7DC546B00BF; Mon, 29 Jun 2026 08:24:40 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 488116B00BF
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 08:24:40 -0400 (EDT)
Received: from smtpin22.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id BA6B11C37CA
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:39 +0000 (UTC)
X-FDA: 84932868678.22.41ACB83
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf09.hostedemail.com (Postfix) with ESMTP id 286D914000C
	for <linux-mm@kvack.org>; Mon, 29 Jun 2026 12:24:37 +0000 (UTC)
Authentication-Results: imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CVHl/Wne";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782735878;
	b=l0f6TxdggKGTNgX/m4sNrrTdbQfiwWOgIySLpzp1sBHOvWsD0antVYtqW49CIgt4yah6jK
	DB3nJeF0stjjmiUngh7cadnLFV4FZpNOnTbgqZp4TQ+jA4wiomiE9igmATjyLFNXYBUUjW
	dU3xm2y0IO3lLaAOXpvBe3NXR6Q7x5I=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782735878;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=vpmpjU/D3Xgzh9vSCEEeHJeDXtgwlGe/yxbKQJIRHsw=;
	b=PFYK0p+xF6VrO8TALbR2e+3wkuopbq86Lvj4DeTu1LMMIAunuBBo7/JTMU2uZiu6vVUzzb
	4QQq2nZBPaXGHFv0WTqhj4JJLhsubKSYu70LZfCgK0PJAYCWCSQgAMgnMc7DqYt8E0moAi
	qEUtCc6znig/SB0Ewluehki8hM0ql+E=
ARC-Authentication-Results: i=1;
	imf09.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="CVHl/Wne";
	spf=pass (imf09.hostedemail.com: domain of ljs@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=ljs@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id B261C60008;
	Mon, 29 Jun 2026 12:24:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89D1A1F00A3A;
	Mon, 29 Jun 2026 12:24:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782735877;
	bh=vpmpjU/D3Xgzh9vSCEEeHJeDXtgwlGe/yxbKQJIRHsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CVHl/WneK15kXj08rtynXrVAL0HLjDePd2qB6E1hU1olGNlTQQjDyx8DLWpzdyYGg
	 3NK9UE4mvE2nPikzteRHK+Vz+xGCID1qTnWSb5IZfULG44HYN6ZgZsPPHRxDWnqLut
	 nlo1LWqmYeELhvvdICEFWIIPcwwNRUbtjucbe8lQ3oW4BLhZIxfcTdBTo3ItOYnpC+
	 lhYOWVWyKj/1WkUeKoBmVqkjhysaqzl/z77+xi0n//OsVrq5yBHDIuMw2A77x2ZEFj
	 D4/NU0V+3ldg7TSjkUwamocBuwizGWYqRmv639fwN+YwIKew36R/XprwKJNhSCT1Qj
	 3CXUt5U/3vg+w==
From: Lorenzo Stoakes <ljs@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Russell King <linux@armlinux.org.uk>,
	Dinh Nguyen <dinguyen@kernel.org>,
	Simon Schuster <schuster.simon@siemens-energy.com>,
	"James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
	Helge Deller <deller@gmx.de>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	Ian Abbott <abbotti@mev.co.uk>,
	H Hartley Sweeten <hsweeten@visionengravers.com>,
	Lucas Stach <l.stach@pengutronix.de>,
	David Airlie <airlied@gmail.com>,
	Simona Vetter <simona@ffwll.ch>,
	Patrik Jakobsson <patrik.r.jakobsson@gmail.com>,
	Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
	Maxime Ripard <mripard@kernel.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Rob Clark <robin.clark@oss.qualcomm.com>,
	Dmitry Baryshkov <lumag@kernel.org>,
	Tomi Valkeinen <tomi.valkeinen@ideasonboard.com>,
	Thierry Reding <thierry.reding@kernel.org>,
	Mikko Perttunen <mperttunen@nvidia.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Christian Koenig <christian.koenig@amd.com>,
	Huang Rui <ray.huang@amd.com>,
	Ankit Agrawal <ankita@nvidia.com>,
	Alex Williamson <alex@shazbot.org>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Christian Brauner <brauner@kernel.org>,
	Dan Williams <djbw@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	David Hildenbrand <david@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	"Liam R . Howlett" <liam@infradead.org>,
	Matthew Wilcox <willy@infradead.org>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Arnaldo Carvalho de Melo <acme@kernel.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	SeongJae Park <sj@kernel.org>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Hugh Dickins <hughd@google.com>,
	Mike Rapoport <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-parisc@vger.kernel.org,
	linux-sgx@vger.kernel.org,
	etnaviv@lists.freedesktop.org,
	dri-devel@lists.freedesktop.org,
	linux-arm-msm@vger.kernel.org,
	freedreno@lists.freedesktop.org,
	linux-tegra@vger.kernel.org,
	kvm@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	nvdimm@lists.linux.dev,
	linux-mm@kvack.org,
	iommu@lists.linux.dev,
	linux-perf-users@vger.kernel.org,
	linux-trace-kernel@vger.kernel.org,
	kasan-dev@googlegroups.com,
	damon@lists.linux.dev,
	Pedro Falcato <pfalcato@suse.de>,
	Rik van Riel <riel@surriel.com>,
	Harry Yoo <harry@kernel.org>,
	Jann Horn <jannh@google.com>
Subject: [PATCH 14/30] mm/vma: minor cleanup of expand_[upwards, downwards]()
Date: Mon, 29 Jun 2026 13:23:25 +0100
Message-ID: <b24f70b72f0a9e2a37b904e5b59d80b88bd42e4a.1782735110.git.ljs@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <cover.1782735110.git.ljs@kernel.org>
References: <cover.1782735110.git.ljs@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: joaifduak5xrqxhwmek41hp4agcqe39f
X-Rspamd-Queue-Id: 286D914000C
X-Rspam-User: 
X-Rspamd-Server: rspam01
X-HE-Tag: 1782735877-138667
X-HE-Meta: U2FsdGVkX1/Q+kFYvL6J1D2jA+iWuH2eQKlkRiEPmhqg0K0WypSNi7TpOg3MwajHbs8mhL1VdiO7pRpBHurLhv2JzKpMshWfEFaytcoC8euJSwvCq+MaqP09bnFkeFq2vIPmMfyE3jNKM8/v4R1MOeBujgGC/0FKCvw6HpfTyFJUfCXr38voSe+ov+QtlVm5iYprvB2iiedFY+E3DXKil547t7a94LANuFUZ9iLBRJyEVuVTLwLhd2WC1//jc9+dXZJ3DDR2nLEQssmPvSdiZS1QJA1KYn4OYHqXuOETTWUxf04rN5h0iMvcNotxozxTkDkCDv9AOFP+mQQiy4d9tvUvRvaIUcW1SQxie7T83uTrfwrIemBHL1IhUkrxChSeNs+ss9fBoJZpXASX2DScROGffbUZb8wNc5w4rsJ4lamA2n2Dcoe3Jz9MeQChULOYdKL++p2bBV9FCRcXcffDx4bjO4RD3lKE5V7pb7rW3yyyh9MITUPfApq0XOwgBbcVaZUeeqbaumU9fQ0+/9/NIbeAOBbcIxlCU8L4/LCpD1VAo3CwD124Kz7akPD+NUrqVRDOJplMiOBzyKNjUG0T208U/FptWP0y8ci+f7xWK9NU6XU0m8GoZUFFWf51ACzhllj7QoT65HyPquCzUh8v/wNqlthBHnoD7c5gKz3Uz/Pem+10LF5mEn9QWjM1ZBjniRMFFlx8O8X5dXQWLTn1obeRYsStBFf6vbxXE+WFUwMf5ScR1sTptufv0wWjsHhfdiyetnv0JvtE0aDhj+gCzRJDFet+cfmiBJAVYixM9PX7eCLEjWqOVfwv2TpX4QnIoKMAxMWjzKO5mWXG/gGX6RMMndmResM58NIks7cITGzmrMy5G5JUwJN5f0nUPrQWofOVn9rzdQHqzaIXzvhSZX7iXfsYAbzY15McaAka6WM+ZxjLmg97QmV5L5u9RCO16RQEhJntc5Mlo28L7Dq
 1VyS6gy0
 KPUXP51NWiqXxQC0Ukg8O7FC347Di2Mrho3erfWqnffN87DFiO89wlvxJaGfwTBIhsISoIld2tnp3hYg+uTr5hrBkU8YN9VRaJEmYlrjJh0kcGrYCsIZxgqtExafFS1IGKIyDFg4d5Mo76PWmzoSPxkvfNoO3wm2oGTyL0RDNta6Pg0JAht8P/toBCUj63fhLnYy5M3sJGeYo4cK/kQ8niQRssgkuouiGc6YgurhscgG/uEobQ06dmV5YaXiKG+NoFN8MWBGNy0PkvhqLjzOoXtb95ulEoWX8TbxRrELZiI8Vy5lero4QXh+/oupsFrb5PUxOwtqQyIT0r6JGQo7MEe6mUgfJlxQEwtSn
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Adjust the stack expansion functions expand_upwards() and
expand_downwards() such that they are expressed in terms of named constant
values, and make use of vma_start_pgoff().

This clearly documents that we are referencing the page offset of the start
of the VMA.

Additionally this cleans up the overflow check in expand_upwards().

No functional change intended.

Signed-off-by: Lorenzo Stoakes <ljs@kernel.org>
---
 mm/vma.c | 17 +++++++----------
 1 file changed, 7 insertions(+), 10 deletions(-)

diff --git a/mm/vma.c b/mm/vma.c
index 1e99fe8aa6ef..dc4c2c1077f4 100644
--- a/mm/vma.c
+++ b/mm/vma.c
@@ -3216,13 +3216,12 @@ int expand_upwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Somebody else might have raced and expanded it already */
 	if (address > vma->vm_end) {
-		unsigned long size, grow;
-
-		size = address - vma->vm_start;
-		grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const unsigned long size = address - vma->vm_start;
+		const unsigned long grow = (address - vma->vm_end) >> PAGE_SHIFT;
+		const pgoff_t pgoff = vma_start_pgoff(vma);
 
 		error = -ENOMEM;
-		if (vma->vm_pgoff + (size >> PAGE_SHIFT) >= vma->vm_pgoff) {
+		if (pgoff + (size >> PAGE_SHIFT) >= pgoff) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))
@@ -3295,13 +3294,11 @@ int expand_downwards(struct vm_area_struct *vma, unsigned long address)
 
 	/* Somebody else might have raced and expanded it already */
 	if (address < vma->vm_start) {
-		unsigned long size, grow;
-
-		size = vma->vm_end - address;
-		grow = (vma->vm_start - address) >> PAGE_SHIFT;
+		const unsigned long size = vma->vm_end - address;
+		const unsigned long grow = (vma->vm_start - address) >> PAGE_SHIFT;
 
 		error = -ENOMEM;
-		if (grow <= vma->vm_pgoff) {
+		if (grow <= vma_start_pgoff(vma)) {
 			error = acct_stack_growth(vma, size, grow);
 			if (!error) {
 				if (vma_test(vma, VMA_LOCKED_BIT))
-- 
2.54.0


