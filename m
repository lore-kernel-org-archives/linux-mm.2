Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 42D8A606A32F
	for <linux-mm@archiver.kernel.org>; Thu, 19 Nov 2026 13:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=virtuozzo.com header.i=@virtuozzo.com header.a=rsa-sha256 header.s=relay header.b=nJUV7HiT
Received: by kanga.kvack.org (Postfix)
	id 604B66B0628; Thu, 19 Nov 2026 08:44:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 58D7F6B0654; Thu, 19 Nov 2026 08:44:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 47C436B0629; Thu, 19 Nov 2026 08:44:42 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 1BA226B0654
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 08:44:42 -0500 (EST)
Received: from smtpin17.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id 9454D1A075F
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:41 +0000 (UTC)
X-FDA: 85451988762.17.7710013
Received: from relay.virtuozzo.com (relay.virtuozzo.com [130.117.225.111])
	by imf29.hostedemail.com (Postfix) with ESMTP id BCED612000D
	for <linux-mm@kvack.org>; Thu, 19 Nov 2026 13:44:39 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=nJUV7HiT;
	spf=pass (imf29.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1795095880;
	b=Tvb/KDxisHRMGrO7CXZRwXZ/qUCP2QQ/i2/yjcYELkfHc1SGyyUzZpYsRS71vZaGt68ukm
	xum0QzNFeK96qpKd0uCByw3uxRi6OGlkaCLc0uIYWJwOJCiJMsM8K+zjxTPaDvufYPGGlZ
	gbThiWaw3U/wSsXzrqR6bQhIH4JQWhk=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1795095880;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Avwvbw5yVGFVbipl1tuQaWsH+u0bWEZomnuCQzaz/wM=;
	b=cbPv76pZrxB7W2gxcuFY9wJnpp616xTF8YBtwJ4Cya5Zlw0UtJvCAoOinVJiAw70taDYPW
	QFSNz0Bm+4xE2OMKbvazhOw/HlAbG7HMKvF/0PlU1C2pS3wHKbQhv/+KXDFAuo9YDcgZVS
	/UnUT1uGqBwB3JsLMEF9HB0mtaLrAeQ=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=virtuozzo.com header.s=relay header.b=nJUV7HiT;
	spf=pass (imf29.hostedemail.com: domain of khorenko@virtuozzo.com designates 130.117.225.111 as permitted sender) smtp.mailfrom=khorenko@virtuozzo.com;
	dmarc=pass (policy=quarantine) header.from=virtuozzo.com
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=virtuozzo.com; s=relay; h=Message-Id:Content-Type:MIME-Version:Subject:Date
	:From; bh=Avwvbw5yVGFVbipl1tuQaWsH+u0bWEZomnuCQzaz/wM=; b=nJUV7HiTdclgnbZnBV+
	xGN/fk00ik+jXN9tHPLxJfjZW66pMws079Bt37EGbYHTV5T+1BLAZbtosglwm6ghIog/SQaviMf8/
	+ri0Zw71iVlBcEkSXcpU6cJdX3mWnJ16CXrIv+bsCE6DytUHWo0nNOJ5hHyCtSOVj5vi0ZvHCI1we
	580ZgAq14CFZohYZw9Q/8BP7iXXehnCXkAipiYHtZgHEw7DXw7QM/EfKZ9mO9TE/5ZH5/OjO+b+Er
	EWHkFhwPwdab50WF/GBK7KAU9UdLu+314KuxAnY/FzM/p6YR+jHL2vM/s0UUxXOeuh7ZYgpXzcUEi
	wmqN1//9ZlaxGhg==;
Received: from ch-demo-asa.virtuozzo.com ([130.117.225.8] helo=f0.sw.ru)
	by relay.virtuozzo.com with esmtp (Exim 4.96)
	(envelope-from <khorenko@virtuozzo.com>)
	id 1xU2R5-00FBqZ-1q;
	Thu, 19 Nov 2026 14:44:23 +0100
From: Konstantin Khorenko <khorenko@virtuozzo.com>
Date: Thu, 19 Nov 2026 14:44:02 +0100
Subject: [PATCH v6 1/4] mm/rmap: duplicate a PMD mapping as one in
 folio_dup_file_rmap_pmd()
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-1-efa7817a2bb3@virtuozzo.com>
References: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
In-Reply-To: <20261119-b4-prep-vstor-149847-copy_huge_pmd-recheck-special-pmd-v6-0-efa7817a2bb3@virtuozzo.com>
To: Andrew Morton <akpm@linux-foundation.org>, 
 "David Hildenbrand (Arm)" <david@kernel.org>, Zi Yan <ziy@nvidia.com>, 
 Baolin Wang <baolin.wang@linux.alibaba.com>, 
 "Liam R. Howlett" <liam@infradead.org>, Nico Pache <nico.pache@linux.dev>, 
 Ryan Roberts <ryan.roberts@arm.com>, Dev Jain <dev.jain@arm.com>, 
 Barry Song <baohua@kernel.org>, Lance Yang <lance.yang@linux.dev>, 
 Usama Arif <usama.arif@linux.dev>, Kiryl Shutsemau <kas@kernel.org>, 
 Peter Xu <peterx@redhat.com>
Cc: Alex Williamson <alex@shazbot.org>, kvm@vger.kernel.org, 
 =?utf-8?q?Lo=C3=AFc_Molinari?= <loic.molinari@collabora.com>, 
 Lorenzo Stoakes <ljs@kernel.org>, Shuah Khan <shuah@kernel.org>, 
 linux-kselftest@vger.kernel.org, dri-devel@lists.freedesktop.org, 
 Madhavan Srinivasan <maddy@linux.ibm.com>, 
 "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>, 
 linuxppc-dev@lists.ozlabs.org, linux-mm@kvack.org, 
 linux-kernel@vger.kernel.org, Konstantin Khorenko <khorenko@virtuozzo.com>, 
 Jason Gunthorpe <jgg@ziepe.ca>, stable@vger.kernel.org, 
 "Jose A. Perez de Azpillaga" <azpijr@gmail.com>
X-Mailer: b4 0.16.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1355;
 i=khorenko@virtuozzo.com; h=from:subject:message-id;
 bh=+iGJSVU2R69oAcxSbe2V0t1MH5H7H4D9RsN+PXcW2vM=;
 b=owEBbQKS/ZANAwAKAVGWCkf5YVwqAcsmYgBq/v02Zu43V/DlG+vTb7VK4NcMAFw3SzTFPDVM+
 +YbLiHc7l+JAjMEAAEKAB0WIQRWD23IPcXT0GO9CCxRlgpH+WFcKgUCav79NgAKCRBRlgpH+WFc
 KhVUD/4pdhUvXjEatrjVm+jK1BFrSOHbw9X0CfsIn+VWgL6wUjy6J6Enx/FE0MRtjtxUuGSP+rv
 LOu2pQQpRDBWsLf3rYPh4BaDE0/54hwlCxSOsShmzV/gd73uBUAms0Jtka4TPPqVhWjh52Z/1+2
 E7gevPrBJBp9AryoT+Uvv6igC2cbUumpyGl2uOtwOiehl9mnYM5hfHDFbNpPUsc2oLHdak53x29
 UlrTULEEPSZ89r1JWcyJvg4EoHRu5VpRSJLu+N4qrna6LP+7ZRuxUtE5LdvbSGvYaYwAc+iCOVN
 ZOv8p8SnQbUh7d5Veo+KDj7BdmC4PzAdFaiGj/JoLmT+u2NvA0pSmd/4tPK3B/tVlHh+hbp7lbu
 Dh2+uejGHvrz03qVU1Fu2XzqbbfDdkDVBSQq2XFOOwXrx1EFSPre+J+lHu6+QHO8MxxlLSAChCQ
 94YH9yJItBmMsKQsZM3kZIBkf3rychJwE5pqbSgu3twaI9TsYFliCL0rSdPAmpRvgwb+Tqnr9t3
 Vy1u/gNh+uXXx3itSQhJP/3RLqQcjIiRO3r1x7uXWqXBhiVgrI5Ff/H90QJpH6DpW1qYwKCf5DL
 r3FbC7ZmMGqI3wsw7OaKXZipJGYYBkEWj1SwNOTifZdBR2C3HwHqx/Fs4TTFGHUhP48Nj3qJfqT
 Xzfd0OUXQe+z+dg==
X-Developer-Key: i=khorenko@virtuozzo.com; a=openpgp;
 fpr=560F6DC83DC5D3D063BD082C51960A47F9615C2A
X-Stat-Signature: wij6cudfpkas8bbcxj4dwwd3c63s1h8j
X-Rspamd-Queue-Id: BCED612000D
X-Rspamd-Server: rspam12
X-Rspam-User:
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1795095879-731740
X-HE-Meta: U2FsdGVkX19oxEBIdaxUHlz8Vik8RiL4r161xtII2WJMnaJnEaZxj8Mo4ZQUkUuO2gnhRgZe0BtqL1fOAh1iQI2iOe5iIYu89SmVLHqkkdbHBVOJ/BNIlnvuKfI12ald6x6VTHfv3uRpoq6L9JfW9ZykEar/Z8tLKSl9fQN9+LWn68fAq9qamHJ+lk7ad/3kvpcLR9Mm/ggWN1xr134g87v9uTmG9kbY91Pc6FgrYSE/ZNisFoCSpj9OIbkFdma7ubr647KFnIELt2DZIRvlMw8mhXfxwqidILTZWGAIh9jzpwvMHiWNZ++R5Xkwq8NVqJobj8yQYRpIIbG0uLhrIie0me4Qt8uNefC2pTOyzLtw+Psh+pPeFvs06pgvHSAYinYVO6Bzw+zh7Sxfqk3eXoY9yXsoje05NZ8xu9hf8LZ3gOKRY0b7DpZP9pmzb4wP11CO/HpqfsFqwRtqmu3EgJK5889LWbsLX1jnCdkRx6zqupn/QMwfMbNC+p/BjS8Uxd8daeLhsdJZepX+MdqXhbCUfsSndBlsbOfHlRRteimYGmGlu04i7wIfwvtkBPQcp7FQfScYo6eGnh6lSDelN1MNrTdDLzuc7kif1PUtTx5ae0YC255NLd0UZsGvsHKTl5ahIcfCdTwKwGIoFspZWNwDpfkEJKvMhdMhJoNk0FJgtWJj4HVnV4O/JPW3C78l2fk7WZYBY/6Czp0O/5rN+GH16jOIYw6L13UNEVrsHNRG8lpVXkbJ6p8LLx5t7r3E1iH8YHbum5SEHw/0N8lhedIctfZ78fQmdV6FVPplM4024Mbitj8InG6F2yt9EeQ2el9he/2YxGnDji8AwUniZ7Plot2Yy76Y7PLAJ8EnUi0hCwbQxzkJsAqwnaeHTnI6QFFDkxaU5Pmo8VB5A4XMzBBPytifN4WEDic5kSoBDdvPSdlaswTQYlFf5g6Yn3gFHR5xlfaZQ6Lwpb0bFxJ
 aJGOUckf
 xdS4AzvscxYydBuz/g/0Br8nWNsfEtwSKr55OMtcWs6KCI+UlxfK6JQ2EXSJkkE9jwsILufB9sayhBINaX7AGrzPWHaeOw3wtwH2cUlqmkZaiNlq0BuE3idbNKA2TTkoyF4eIS0NhEKOpLkCMSbHsOq91jXghsqi846Cww9u2QDn88A7Juh0K5tYr8ufekcRUBREVON9Mr8nVXuhP7HYv2wqtxr5KtRTcWQcxaWrNvyjsq4UIz7CZpLJMIh91RfFXlkan4WqIAPKedanaqvl9Uu43LSIvUlYlmpuQuHv4GKfcBvTgo0RzeOjrHWUKIcvyZ01LVpwkG3lobLa88K/mNo/eNGleKJJnT4RstJWS2eoTkZtKaAwv6CtX0zcod57pNLNLWUbFrE6WPc5oWQIJQxyduXJ+44EbFCQBrG8PcUYRJRHMwWT157y7GA2lwF5OVfR4HrqzALZtT15bJVoiu+VDub5iQq5e+3+VwnjHUCRvJF2DdV1mnOQESzfxCToMLEFB8XD+8QLzue6R6Zs55/NL0C8DyFHCLYvpejm+lzqF+FOgATBp6a+25h2uh79sUFwQjCYqoDRgulM9837OpSgUsPhK6Q/5G2iHawKzJLyHiyZf21BC0XqnGw==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

folio_dup_file_rmap_pmd() passes PGTABLE_LEVEL_PTE to
__folio_dup_file_rmap() for HPAGE_PMD_NR pages, so it adds HPAGE_PMD_NR
PTE mappings to the folio instead of one PMD mapping.

The helper has no caller yet, the next patch adds the first one. Pass
PGTABLE_LEVEL_PMD, as folio_try_dup_anon_rmap_pmd() does.

Fixes: d8ef5e311d7b ("mm/rmap: convert page_dup_file_rmap() to folio_dup_file_rmap_[pte|ptes|pmd]()")
Cc: stable@vger.kernel.org
Reviewed-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Kiryl Shutsemau (Meta) <kas@kernel.org>
Acked-by: David Hildenbrand (Arm) <david@kernel.org>
Reviewed-by: Jose A. Perez de Azpillaga <azpijr@gmail.com>
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
---
 include/linux/rmap.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/include/linux/rmap.h b/include/linux/rmap.h
index 52fff8dc74213..9f5bfa317a5cf 100644
--- a/include/linux/rmap.h
+++ b/include/linux/rmap.h
@@ -558,7 +558,7 @@ static inline void folio_dup_file_rmap_pmd(struct folio *folio,
 		struct page *page, struct vm_area_struct *dst_vma)
 {
 #ifdef CONFIG_TRANSPARENT_HUGEPAGE
-	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PTE);
+	__folio_dup_file_rmap(folio, page, HPAGE_PMD_NR, dst_vma, PGTABLE_LEVEL_PMD);
 #else
 	WARN_ON_ONCE(true);
 #endif

-- 
2.43.0


