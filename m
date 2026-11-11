Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7265606C92B
	for <linux-mm@archiver.kernel.org>; Wed, 11 Nov 2026 06:47:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=UC/ScjXC
Received: by kanga.kvack.org (Postfix)
	id BB1D26B05BC; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id B8AFE6B05BE; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id A2CC86B05C0; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 7DC5B6B05BC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 01:47:35 -0500 (EST)
Received: from smtpin16.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 1433D1401EC
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:35 +0000 (UTC)
X-FDA: 85421907270.16.B565175
Received: from mta1.migadu.com (out-85.mta1.migadu.com [95.215.58.85])
	by imf10.hostedemail.com (Postfix) with ESMTP id EFFF8C0005
	for <linux-mm@kvack.org>; Wed, 11 Nov 2026 06:47:32 +0000 (UTC)
Authentication-Results: imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UC/ScjXC";
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794379653;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=gCifWas0BpuNzXE9zytOMZSgJlGt46sndvW+hr71f/g=;
	b=pO7uZDnvcIx6fBqZ3SZZ7ip3WwffaueHM/uFyNX3A8by4rbg0DcHkAHmd8bKcp30CPyZqW
	6iste925w86bEXunV3OheK/UajBLMVuQa/qWLw2I9uxHDwIoZ6lFiK3VCOJ38+z0p8sVo5
	4JwgcTrV5oCA6bwE5Eo0Lfepn4DqqAg=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794379653;
	b=ENCsoEHlRd7a65Gh8xVygjBKR/FXYL4NblJdanu3PbX3Hehn9G2NdwGcrTJJSs1p0mmV30
	+sa1xowckXFXUtGzW4fUSWgx+dCgM/wciPwFG79AEHDGakKkzUvzqyh6nzuvmxSiHTjgJJ
	h7yW32+b8y+z0aM0igTwDFuILYALw64=
ARC-Authentication-Results: i=1;
	imf10.hostedemail.com;
	dkim=pass header.d=linux.dev header.s=key1 header.b="UC/ScjXC";
	spf=pass (imf10.hostedemail.com: domain of qi.zheng@linux.dev designates 95.215.58.85 as permitted sender) smtp.mailfrom=qi.zheng@linux.dev;
	dmarc=pass (policy=none) header.from=linux.dev
X-Envelope-To: linux-mm@kvack.org
DKIM-Signature: a=rsa-sha256; bh=/MVFvmVwbUPNerAUsqUVWH7M0FSKEB7lNQ5SvFhDebM=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794379651; v=1; x=1794984451;
 b=UC/ScjXC8Hg4G/mXfiuxfa+e7FGYJrqxxcEieg3yZJ3L0ECGkSJBOHoxsJe/BVAOozeY9jJS
 mPdc8VcKuAWRz/Fr7QwiMUxksU5oke8rEKDz3LeqCp0sNeopI90PkboxFy454e7lZEKK4e+QcJ2
 TZGbGQusAN8oDJqCi742vz9I=
X-Envelope-To: linux-mm@kvack.org
Received: by smtp.migadu.com with ESMTPS id a60f861f3b7ca6af;
	Wed, 11 Nov 2026 06:47:31 +0000
X-Mizu-Trace-ID: a60f861f3b7ca6af
X-Migadu-Flow: FLOW_OUT
From: Qi Zheng <qi.zheng@linux.dev>
To: muchun.song@linux.dev,
	osalvador@suse.de,
	david@kernel.org,
	akpm@linux-foundation.org,
	azpijr@gmail.com,
	lance.yang@linux.dev
Cc: linux-kernel@vger.kernel.org,
	linux-mm@kvack.org,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	stable@vger.kernel.org
Subject: [PATCH v4 1/3] x86: hugetlb: disable default CMA reservations on 32-bit kernel
Date: Wed, 11 Nov 2026 14:46:50 +0800
Message-ID: <95dc282ff09d27b79086f0a690aac75c93590977.1794379433.git.zhengqi.arch@bytedance.com>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <cover.1794379433.git.zhengqi.arch@bytedance.com>
References: <cover.1794379433.git.zhengqi.arch@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam04
X-Rspamd-Queue-Id: EFFF8C0005
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Stat-Signature: 46tuw7jdsbtez1dja5qseqzzpq6qmyf3
X-Rspam-User: 
X-HE-Tag: 1794379652-930075
X-HE-Meta: U2FsdGVkX18XOFpskxkusxwhhFknH0eYVKfKQWHPgDhUm/RRVAD/YqKVELaT445IQknpdu3/7TIYKxD9UPjmwKLF8QECC/E3hR3JH7vvGZwsy4MeH7Wre1jO45xfcOfDUk2564Kabe5PvaWkaXnuqmRAeoPy0mUHYuHJZ9fjoCo8W3cQOJK9LfZEImSY7iQROGzdksyyVxwolsI8siCCe7g5dPpZzqihmaPDq3uHru3LdQgzbWeSGegd3kqIS8F8Oe960n0y7YY/UVunKfVMLOhyEt5whOK5KXZGpW8+lzFXa0sbfiLkkFAZahfe+z9pO2IZvtw5SWceq4vPXAIRXfawTLU5laVO6wn9GeR18M8PHkBQEurcG4g2H6Gj5qRTmuX7h5B+lD8/hKGEYju8J8GzwpaM4DBDi3M/NRexMPF9RMVT5Qo4L+pgBqUhEAdkhdcauFvZ8QK5tri8hPKaaIBFT9fW/yBb7HBG/5stk5PilfPdckjsUoF4gMzCTUFA+btLcH5BgQVTQD/1mwhycWpNtquzi8Y1rxdQZdoXxh23IL4msNm4PwupxfCU0JNVVbDYBI7397Fhz5YqW5Ghw+5Zs/aye96FFy7TYgBbuoGG6qkShzLR8vw/oBrJ4uisYXDjDTkFc1AvxMFBDl7XHfhI9B6rdkSCsa/903OUcllzR6toVgP3v4HBRpK+9J5iwkkUDIeqIj9yGelfm0RyaAl1cmfXulqMJ4C4VtzxyqlKm58lFYD/9ob3XpOQlfimcndcSCo8gEed3HrNLWeGOXWbXMd9BUU6HPRr6qE+VDIh5ogdg54/Uk2I/YqyB8PEnOYfflXJMTdNgYIDnSiqyJimbOvy4CdUl76mGBUGj6rTmA1kjseGnGayZ0jj06ZHqXCrODttMSpN4yGG/KM2Ao+oNPEvFcThSxpg8qCPHQTry5HcRtMLfXRNMOmf+74cpJiN0pK87Y/vhfNgrN2
 E+oNph6p
 Lv0o4Ccgtr0Rnq6MEaA1fNT8Zx/FyO5ZkMZLWcgm4OeLTiQ+eyOrc5JrvekFz0tUWqyoKgRVhljOM40uiLC7BKPr2MTOX48cHCWQ7UOme1fXLjm05I0nWOHDKK0RgsaiRDQbpBUldgK+sgIJmAaFeCT2pcckJfQRAtLfgMi9HQ/NpipDzndmQy4NhAQ1b6gcdvTqfw355yF0MgL67QwfHvdlXP03RA+0CFcakXWactCAgK/70yrAoEzsR7gjyPo+A1csI
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Qi Zheng <zhengqi.arch@bytedance.com>

A 32-bit x86 kernel can run on a 64-bit-capable CPU advertising GBPAGES.
arch_hugetlb_cma_order() checks only this feature and returns a nonzero
order, although gigantic HugeTLB support on x86 requires CONFIG_X86_64.
Specifying hugetlb_cma= can therefore reserve a CMA area that cannot
serve the intended gigantic HugeTLB allocations.

On non-PAE kernels, the folded PUD_SHIFT yields a 4 MiB order, which is
equal to MAX_PAGE_ORDER. With CONFIG_DEBUG_VM enabled, this triggers the
VM_WARN_ON(order <= MAX_PAGE_ORDER) check in hugetlb_cma_reserve(),
warning that hugetlb_cma is attempting to reserve a non-gigantic order.

Require CONFIG_X86_64 as well as GBPAGES when selecting the default CMA
order to avoid these ineffective reservations.

Fixes: cf11e85fc08c ("mm: hugetlb: optionally allocate gigantic hugepages using cma")
Cc: stable@vger.kernel.org
Signed-off-by: Qi Zheng <zhengqi.arch@bytedance.com>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Acked-by: Oscar Salvador <osalvador@suse.de>
---
 arch/x86/mm/hugetlbpage.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/mm/hugetlbpage.c b/arch/x86/mm/hugetlbpage.c
index 3b26621c91286..70726a99ede7b 100644
--- a/arch/x86/mm/hugetlbpage.c
+++ b/arch/x86/mm/hugetlbpage.c
@@ -45,7 +45,7 @@ arch_initcall(gigantic_pages_init);
 
 unsigned int __init arch_hugetlb_cma_order(void)
 {
-	if (boot_cpu_has(X86_FEATURE_GBPAGES))
+	if (IS_ENABLED(CONFIG_X86_64) && boot_cpu_has(X86_FEATURE_GBPAGES))
 		return PUD_SHIFT - PAGE_SHIFT;
 
 	return 0;
-- 
2.54.0


