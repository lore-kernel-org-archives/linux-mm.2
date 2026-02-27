Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 7581FFEFB6E
	for <linux-mm@archiver.kernel.org>; Fri, 27 Feb 2026 17:56:43 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D4EE66B00AA; Fri, 27 Feb 2026 12:56:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id D0C256B00AC; Fri, 27 Feb 2026 12:56:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id C3C566B00AD; Fri, 27 Feb 2026 12:56:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0014.hostedemail.com [216.40.44.14])
	by kanga.kvack.org (Postfix) with ESMTP id AB5096B00AA
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 12:56:42 -0500 (EST)
Received: from smtpin28.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 4D3C21B8166
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:42 +0000 (UTC)
X-FDA: 84490991844.28.AEF99D6
Received: from foss.arm.com (foss.arm.com [217.140.110.172])
	by imf11.hostedemail.com (Postfix) with ESMTP id A08CC4000D
	for <linux-mm@kvack.org>; Fri, 27 Feb 2026 17:56:40 +0000 (UTC)
Authentication-Results: imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772215000;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=5POj2Ofb+H7GemIQSmIA5tk0MgesYP1DsFVJbMebO7E=;
	b=TaH9RsfJx0UVwZaLfW7Wrt0aqCDQY7GUFigVqrJDCQ2j4X1AqItA3zzQAiycEmmQopXf4L
	/qug0CJsbhV6V9O7obSiIZLtVnMuCbBj4naaRU4a2I5hziZb16nNS7gTSFW9a0I5JOLBLi
	4aEw9GJ+lCadTunfmW2+k5oIIZ7+/TI=
ARC-Authentication-Results: i=1;
	imf11.hostedemail.com;
	dkim=none;
	spf=pass (imf11.hostedemail.com: domain of kevin.brodsky@arm.com designates 217.140.110.172 as permitted sender) smtp.mailfrom=kevin.brodsky@arm.com;
	dmarc=pass (policy=none) header.from=arm.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772215000; a=rsa-sha256;
	cv=none;
	b=Uv+TVE8y7/GoEws9rU2COfhn21+XglW4bL60+RAaBN5Mi7G3fl19HOLCSujZL24VicpR8O
	30ILJfeENqrzDl/EH0ieYcovxFaid3PZbctBTUl66mvJ07dw2TURTmSMReTuXuiMz38x13
	r2I5MNZSj9dQNngwpODu9SZLYQbc4O8=
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
	by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8B0491516;
	Fri, 27 Feb 2026 09:56:33 -0800 (PST)
Received: from e123572-lin.arm.com (e123572-lin.cambridge.arm.com [10.1.194.54])
	by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPSA id 74D793F73B;
	Fri, 27 Feb 2026 09:56:35 -0800 (PST)
From: Kevin Brodsky <kevin.brodsky@arm.com>
To: linux-hardening@vger.kernel.org
Cc: linux-kernel@vger.kernel.org,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Andy Lutomirski <luto@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	David Hildenbrand <david@redhat.com>,
	Ira Weiny <ira.weiny@intel.com>,
	Jann Horn <jannh@google.com>,
	Jeff Xu <jeffxu@chromium.org>,
	Joey Gouly <joey.gouly@arm.com>,
	Kees Cook <kees@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Marc Zyngier <maz@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Matthew Wilcox <willy@infradead.org>,
	Maxwell Bland <mbland@motorola.com>,
	"Mike Rapoport (IBM)" <rppt@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>,
	Pierre Langlois <pierre.langlois@arm.com>,
	Quentin Perret <qperret@google.com>,
	Rick Edgecombe <rick.p.edgecombe@intel.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Vlastimil Babka <vbabka@suse.cz>,
	Will Deacon <will@kernel.org>,
	Yang Shi <yang@os.amperecomputing.com>,
	Yeoreum Yun <yeoreum.yun@arm.com>,
	linux-arm-kernel@lists.infradead.org,
	linux-mm@kvack.org,
	x86@kernel.org
Subject: [PATCH v6 12/30] set_memory: Introduce arch_has_pte_only_direct_map()
Date: Fri, 27 Feb 2026 17:55:00 +0000
Message-ID: <20260227175518.3728055-13-kevin.brodsky@arm.com>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20260227175518.3728055-1-kevin.brodsky@arm.com>
References: <20260227175518.3728055-1-kevin.brodsky@arm.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: A08CC4000D
X-Stat-Signature: becjtprfuhzip3meite8ajgsncjzf1m5
X-Rspam-User: 
X-Rspamd-Server: rspam05
X-HE-Tag: 1772215000-426040
X-HE-Meta: U2FsdGVkX1/ExM/YVIfJ3rjradzBHtZaraexHxoQ9w9XbE1qWU+/L4fAAQf6eNqQ6yXfOjqMbTnHSDL6+0fbIjjmEx15Rg31yfF4O6w8yxExF2kcyeNOoK0sXXiGx/51ITlk0CmFBXfn5FBCVEaJCZcWOn0VsVH2rjVTL1C5pO5Zaxdnx3ae51CVdKMIUXCRhOsaxoaLwlBvTbHPTsDhVK73jA+32ffVxI3CPEJXb8+FUr1/sAHBLIrjVOyJ89UvaCmVo2b3IbwrW1gqZuRZDYXWylti1KX/u3tlsGbEJgUHeM/oZaEoBX31zWhlg1TQxd04ZVHOFCDDsJElpJtgsYko0eKgVuNHox9x+ZIXz605f4gY/uyn4EEA6wRhdWIrduh8W8UvTALV/2oQznMBlmkrhonwX5YFNvZ0Fo4qGB9uyKWXv83GIN53zDjQu0+8pEwoBR4X2lU3CSOljaqEfqbCKQK9pN0z00jADjuk9GdTM+BUt5nphA965f6BwvkIxmfsVsyBJSnahmvxaBgj+uOeOBAxKo2XjrfO4Y/8jpN1h53nGInFFxF9iKob9LpkrEUjInUPu+AKuXjhd38lKgUpm1w2eHTCKakg2EF5NG9bR8ZOUU3opGoZTOKPS3V8KgT7AjlE3hN34SANMis73noB8G56cmsaQuV5ssseuQQQEE0f1SjSjs0xoD5YrtT2maejNDYqNwZC+svR9x0Uf7iwM3XvNt1/k8IG6tJEANFUvnrQzpaRSzmxfUOIVu4bWWYGAbe7JWFMXq9EhbuHacHyj87O1gZ4Thy2XHMwwdkYxRMKfQSPPCg//SZ/MOL8lQVdpDYRiaCSVLWdXh5r5AHGSQUGbz/MA698K62WDXeY3cyeSYVRhYO7edX6XfvQlqgrq7bZaqOBYC+xy1dzqDXI2teK+7fHEtt1+nQCF4GS5T8JckdsXNrdMyGCLGpmg+oOkeQ5XNXc65StlPq
 KefEyG6H
 4xL0mBqosc55v+RQCHcEnPJOVv3AtQkiKNPW+vEoDELuzsHv07L7V6bs8li5GSFiL8swc0UN4UV1pdH97LOyZAWxZvLyei5+ixY6Ztx1dluXmEhLJ/zZzbkMy8ZSlL8A695/JUHF7/Myu2cwr/0C++7z9brZ4qBv+2ogOrHCp0fVF1mEPlHoD7f4+6tgYl2uNTdGR6g+caxKqtxKcC7LJ9nF3PmqHcfQt+BeiIv5FBMwVkuA=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Introduce a helper that returns whether the linear map is fully
PTE-mapped (i.e. no block mapping is used). This is a runtime
decision for some architectures, hence the need for a new arch
helper.

Signed-off-by: Kevin Brodsky <kevin.brodsky@arm.com>
---
 include/linux/set_memory.h | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/include/linux/set_memory.h b/include/linux/set_memory.h
index 7b3a8bfde3c6..c6df55422da2 100644
--- a/include/linux/set_memory.h
+++ b/include/linux/set_memory.h
@@ -58,6 +58,19 @@ static inline bool can_set_direct_map(void)
 #endif
 #endif /* CONFIG_ARCH_HAS_SET_DIRECT_MAP */
 
+#ifndef arch_has_pte_only_direct_map
+/*
+ * The default assumption is that the direct map might be created using block
+ * mappings (PMD or higher). An architecture may override this if the direct
+ * map is fully PTE-mapped.
+ */
+static inline bool arch_has_pte_only_direct_map(void)
+{
+	return false;
+}
+#define arch_has_pte_only_direct_map arch_has_pte_only_direct_map
+#endif
+
 #ifdef CONFIG_X86_64
 int set_mce_nospec(unsigned long pfn);
 int clear_mce_nospec(unsigned long pfn);
-- 
2.51.2


