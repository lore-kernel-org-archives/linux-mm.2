Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 81EFC103E163
	for <linux-mm@archiver.kernel.org>; Wed, 18 Mar 2026 10:59:12 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 9FA9D6B0174; Wed, 18 Mar 2026 06:59:11 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 9ABFD6B0176; Wed, 18 Mar 2026 06:59:11 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 8C2196B0177; Wed, 18 Mar 2026 06:59:11 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 7BD8C6B0174
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 06:59:11 -0400 (EDT)
Received: from smtpin20.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 4A3EC13B5D5
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:11 +0000 (UTC)
X-FDA: 84558886902.20.42B10AF
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf14.hostedemail.com (Postfix) with ESMTP id 9725E100010
	for <linux-mm@kvack.org>; Wed, 18 Mar 2026 10:59:09 +0000 (UTC)
Authentication-Results: imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F6uE4wnF;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1773831549;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=YL7pvZp59Pe1nW2NYzvHDNhH9ud22MdF0vy7DYMTjBY=;
	b=Wtgp2Tcml6j2WZFoZ6OL05YzrIaGRcPdMmmv0na5NkYTkMZ0blF9GbOrmJwUnZLKE3bWPM
	KdZfDFZZuwBpJ8LoZHVPKz+O1zPfSYhtAWDHtDUJ/uEnEvQH4HWFHBc9Aa0Lo3DMGSyxEf
	FwRuBUaSHfCRueoCQHxpVfnZtm8/lgs=
ARC-Authentication-Results: i=1;
	imf14.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=F6uE4wnF;
	spf=pass (imf14.hostedemail.com: domain of rppt@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=rppt@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1773831549; a=rsa-sha256;
	cv=none;
	b=hb4Tzi9q2OhehGCT3pi1ktMhPK+dlCSSv8N7ceUAlDZByjGr+yVvoRoICwBt5J/HBC1NWu
	tO6gtvn1heVhdZYrmM/g5/qm8q0j+E7ugL2C4E0H8RRLIK2W0exHKnHEcEo3cMFAWhdrXd
	BcVTa/ad3nXus96sDW643ayRT5NQJAM=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id E494444767;
	Wed, 18 Mar 2026 10:59:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4541BC2BCB9;
	Wed, 18 Mar 2026 10:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773831543;
	bh=eXHAfMqh6RkD93DEJUVdAwdOv0hR8c1CLNcm1BQYW+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F6uE4wnFoYpsxRBiKT/PjPuXliQ4seo8S9062AZ7tk37rf3ZX++agKVae57LX+29I
	 yOZFWkz8+D78t+J+kBeYs9Qs2oAecfpTnD+o1T2HG0HpEjZo810U5evd+qliij5IiW
	 IgYK3nOftqn6sOZlY2YDSpVWlBfQ8TEo4vTV4YniZHRCKn43nBCEaPD8oZfh0eyMZ+
	 QGWYVHomaz+gh+eL5gKQAhKHGEpiUT2Io7PAeJF3RBHLzyCpPPWb8FuXF0KgA94nWR
	 GlEeCRmq1FL9VNkiAAH6yRt6OeunWDVw1taBsLaZn/I5l4CSyZG2rax4i3zH87YD7F
	 F+nbWE7Og683g==
From: Mike Rapoport <rppt@kernel.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Alexander Potapenko <glider@google.com>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andreas Larsson <andreas@gaisler.com>,
	Ard Biesheuvel <ardb@kernel.org>,
	Borislav Petkov <bp@alien8.de>,
	Brendan Jackman <jackmanb@google.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Christian Brauner <brauner@kernel.org>,
	"David S. Miller" <davem@davemloft.net>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@kernel.org>,
	Dmitry Vyukov <dvyukov@google.com>,
	Ilias Apalodimas <ilias.apalodimas@linaro.org>,
	Ingo Molnar <mingo@redhat.com>,
	Jan Kara <jack@suse.cz>,
	Johannes Weiner <hannes@cmpxchg.org>,
	"Liam R. Howlett" <Liam.Howlett@oracle.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Marco Elver <elver@google.com>,
	Marek Szyprowski <m.szyprowski@samsung.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Michal Hocko <mhocko@suse.com>,
	Mike Rapoport <rppt@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Rob Herring <robh@kernel.org>,
	Robin Murphy <robin.murphy@arm.com>,
	Saravana Kannan <saravanak@kernel.org>,
	Suren Baghdasaryan <surenb@google.com>,
	Thomas Gleixner <tglx@kernel.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Will Deacon <will@kernel.org>,
	Zi Yan <ziy@nvidia.com>,
	devicetree@vger.kernel.org,
	iommu@lists.linux.dev,
	kasan-dev@googlegroups.com,
	linux-arm-kernel@lists.infradead.org,
	linux-efi@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	linux-trace-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	sparclinux@vger.kernel.org,
	x86@kernel.org
Subject: [PATCH 2/8] powerpc: opal-core: pair alloc_pages_exact() with free_pages_exact()
Date: Wed, 18 Mar 2026 12:58:21 +0200
Message-ID: <20260318105827.1358927-3-rppt@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260318105827.1358927-1-rppt@kernel.org>
References: <20260318105827.1358927-1-rppt@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 9725E100010
X-Stat-Signature: t3yz8iawkbexm3sw39p3upwc6yhumthn
X-Rspam-User: 
X-Rspamd-Server: rspam06
X-HE-Tag: 1773831549-150597
X-HE-Meta: U2FsdGVkX196MAkn7vH4ZhPrCENbT3zzJteH9SOrH4vCyHv/ixEb/KNUb4eu4P40hlhzIBTA/K3HtyThIFlkQYdz/UITxLGOZexFPxEF5xmBqRHIFi5yhxCSUIGqmeAFX7rK4rKqUYIKJMBmEoeu6si0DaiKQkaCApmowr23u7rPuZISNP1dblGk1KrAhXpFFTvE4za+t4w+XRbmdx8dX939XOpX56Z/bP9uYmlWBa9LXLlEYQAMVOSwEbLIixABgAL1sFjI3TFu9PI7TfnjVb0yzxzPwg9uifyHPjTBrzozY+3padmcqU8K7c4unZeMrk0d6AtDLi+ZBWh6+kzYmzSvtYhPIsxM8InqFewGCSbDouOvWHZ7AIJylLHLQ0XhckCBJHeg4R6DX1GWCpt2YWaTVlHodBcRMe0LsxlkEg5/okc53eK/ew74OmDyuo/FT2QijS/rY5Lw50V7kuPU4Skajpqs/qerA2UC+Mdnt3bc02+SJSUVaDyEHVDCsdGs6MHorRKSvn8G1ywSkrN6WYGfKTTKOuI+i2JtO0aFsYB331JP7qCBpVnzntbk7CaflLh5a95Ea+u3mUmH7+sfhZ0/lDN/6CDfUKFZDZMs36puupRbcZzUE8M88hPWKvkAva9xAI2H7idPVG0uRm4QfZum29rwBhCQja7LOSNfjd3gajLcwy3NSi/Stjyb/h9DpmSr4Wo4oalO2C5IFTj4hBPiLRWB39vw5saR9J/NFgD3lvaaH8cpOZO033WbO7r9C19H7tF6itN7mBe3XuCop1sCFDl0dZuQAfcPeN1yjlwGC0TizdRCwSMhYu+afMXUGushDo7aOeRDWPJNhorInyqwwHHLR3YkIFDz8G8mMpKYC5PHHWL4OdDZzSZtl1VdYqRRnIzxXG4vhAOkgnzwa1zPfUnQhfsBHpwEv/MZwI2ZVULWDWwFSmnvUPqVLkGRpxcWIMQUzpAjTrrDTKE
 mGeKyDyk
 u/iOUDQxVa08U/QPXhLW6dJ6s2NB5RKOz1okAdu1T2/vvvL1M46AhuaRwMnVnQZIIqNHPjMAgYHq+x6soOdBe/5z7RtfIY3eksvrnO5AuV+RUPhuL09WszfOriM7+aMlXkQf3OSUwsIlcz+YD6eaNk5m/u9qCej3mwY1R6/PH90XGiTgGVLxzCACXVP90QG73LF0X07HDuAZz1zudf1iyfr7h3UiDyvhtbiEmi3DkAKNtjPRw2zEnWPjfXUs2G2JXStTVdfPnyWEGFZ0AFmj20yPpDRYHE3v84Bpeau/wWx7XggEBtq8JJi5tABv14SUQtL4C
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: "Mike Rapoport (Microsoft)" <rppt@kernel.org>

opal-core allocates buffers with alloc_pages_exact(), but then
marks them as reserved and frees using free_reserved_area().

This is completely unnecessary and the pages allocated with
alloc_pages_exact() can be naturally freed with free_pages_exact().

Replace freeing of memory in opalcore_cleanup() with
free_pages_exact() and simplify allocation code so that it won't mark
allocated pages as reserved.

Signed-off-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
 arch/powerpc/platforms/powernv/opal-core.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/arch/powerpc/platforms/powernv/opal-core.c b/arch/powerpc/platforms/powernv/opal-core.c
index e76e462f55f6..abd99ddbf21f 100644
--- a/arch/powerpc/platforms/powernv/opal-core.c
+++ b/arch/powerpc/platforms/powernv/opal-core.c
@@ -303,7 +303,6 @@ static int __init create_opalcore(void)
 	struct device_node *dn;
 	struct opalcore *new;
 	loff_t opalcore_off;
-	struct page *page;
 	Elf64_Phdr *phdr;
 	Elf64_Ehdr *elf;
 	int i, ret;
@@ -329,9 +328,6 @@ static int __init create_opalcore(void)
 		return -ENOMEM;
 	}
 	count = oc_conf->opalcorebuf_sz / PAGE_SIZE;
-	page = virt_to_page(oc_conf->opalcorebuf);
-	for (i = 0; i < count; i++)
-		mark_page_reserved(page + i);
 
 	pr_debug("opalcorebuf = 0x%llx\n", (u64)oc_conf->opalcorebuf);
 
@@ -437,10 +433,7 @@ static void opalcore_cleanup(void)
 
 	/* free the buffer used for setting up OPAL core */
 	if (oc_conf->opalcorebuf) {
-		void *end = (void *)((u64)oc_conf->opalcorebuf +
-				     oc_conf->opalcorebuf_sz);
-
-		free_reserved_area(oc_conf->opalcorebuf, end, -1, NULL);
+		free_pages_exact(oc_conf->opalcorebuf, oc_conf->opalcorebuf_sz);
 		oc_conf->opalcorebuf = NULL;
 		oc_conf->opalcorebuf_sz = 0;
 	}
-- 
2.51.0


