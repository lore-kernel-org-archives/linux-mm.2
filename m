Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08A2B606B41F
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 07:10:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gourry.net header.i=@gourry.net header.a=rsa-sha256 header.s=google header.b=nEqb/IjR
Received: by kanga.kvack.org (Postfix)
	id 36A6A6B05C0; Sat, 14 Nov 2026 02:10:29 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 2F5406B05C1; Sat, 14 Nov 2026 02:10:29 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 16F3B6B05C2; Sat, 14 Nov 2026 02:10:29 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D11F46B05C0
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 02:10:28 -0500 (EST)
Received: from smtpin20.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay07.hostedemail.com (Postfix) with ESMTP id 591451601B5
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:28 +0000 (UTC)
X-FDA: 85432851336.20.5B375E4
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	by imf17.hostedemail.com (Postfix) with ESMTP id 8B7EF40006
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 07:10:26 +0000 (UTC)
Authentication-Results: imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="nEqb/IjR";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794640226;
	b=XwO5W7/nMv/CMkE5NbaH99I4JCiSwcsOZ12Z4UXXrKLGceu40y/OfxgEumORunJijQsTPO
	kWWpdFvOJlgI1iL48aKhNjdFE04m3WheI0FrFJO/IcogS1jX1mt902KFQ1C0Pr7MQxtyYO
	+mDLKNyh01pz/0W/t5kMSEgtDcoXU7o=
ARC-Authentication-Results: i=1;
	imf17.hostedemail.com;
	dkim=pass header.d=gourry.net header.s=google header.b="nEqb/IjR";
	spf=pass (imf17.hostedemail.com: domain of gourry@gourry.net designates 209.85.219.51 as permitted sender) smtp.mailfrom=gourry@gourry.net;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794640226;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=Tt496ll4IbdlqeCDi3ioSW9/vXDsw+lkgrGBEmtKDJU=;
	b=DJz0lCkM8wiQ0uIDk3t0+ZR3YDW3UW0EFZeiVcZl1f0Vl8O4vT+XOQR/3hU54L4LaXDTbv
	7fY+ZClkIcFZYxiDVY25Lki632oMBAjdWpDeLS3Od68lpmVGC9YsdwTplYWVHEk3amjhcH
	/DcEiE6RFCYGPt8W41AY/OJLnhiJr6w=
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-91f11161831so11379746d6.1
        for <linux-mm@kvack.org>; Fri, 13 Nov 2026 23:10:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gourry.net; s=google; t=1794640226; x=1795245026; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Tt496ll4IbdlqeCDi3ioSW9/vXDsw+lkgrGBEmtKDJU=;
        b=nEqb/IjRVoStW2/73GeiYVNV9kQqT8HDH3jGWTiB8McgxT6QJDOrI92cJTh9FEoHV9
         J5e+DLJmKgnwL2wl+PKwYTRZJEVNyAuVt7eMDyg9H55RWaFMYtSgfK8KMwknEFHRZJho
         2FyigJ5TRA5MH4Yg6NI/rfoZA6TFgSWlwjGC5lyQeNT0ZzrUyJXH5YLMll0ek/Raj+t/
         zxXth77nSR/VC3CUGWKud/glh/i5t8hVFbAionR++42Y0FSSSX4GGd6wGLJVhkAQ0oYl
         QLo6TJmi5uShCnWSivqqPN/rY0lho9psZ0mn7prsxnD1H4eEqLkvZwrRZ7A34rYIKh39
         fpow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794640226; x=1795245026;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=Tt496ll4IbdlqeCDi3ioSW9/vXDsw+lkgrGBEmtKDJU=;
        b=z2y+a7yQxXC0TH6OsDF1qYdD9SoB/cpEae1Z1owIfJA0qGyLJHiuUKO446yjJdA/9H
         /WA85vOGCzCcNYhnORv26qydNBl79NAzchY7ZMxGzRr5GJ/tC+b8O6MNB95zcFcbH15y
         Qv5BnebXX+dd2f3T05+HN8ddaPjQB4MGFmnEwsyDgNYXFqaugkW2Ro2asoAq4ba6kzac
         bjHJGGlnrIfzHdI2UiSb8vTZIWlAf+XzVIk67Zy2yk0QL+Zr/ejNcJIve16LgcqjVSFv
         4Idc4ULh19gJL6M56eFhM+UByIS6iYDDbf519G3e9FZOm1RTtY59gBrsqctJeoCeUpD3
         xupA==
X-Gm-Message-State: APuU4Z9Ps+c5w+3kuNXq/YHG9tJSmM5rqBg2Bk51U7OsLFkNcNMgUKq3
	ujYu6xS2SS/Idm/29WfGNhJmuD5HPap3ri5y/lEzDyDRvr419v0kQ2BBipRxBY1hZsrrAFCtr0E
	J8ujq
X-Gm-Gg: AYBFou2zvIoaZV0xaxIWM8rs3pm/H7gQQc5Tp1AI5E4nu0li6jUDYr+2o4E1f4SdTtZ
	GEP2n51+oIw37l0IFMyXIioPeNEofYQucCbOAllvEnMmoIL1llCwvn2gWdNkOFVg538S5UP/0F7
	6icCtDjIGXUCs7vJtInqkk8I0uJis+Qss3aV+L6YSbQVEIRGE2eYKurzYPZPjHKcbUm2G7dP2Yk
	IStcv/YtdnitjCz0J87JKQlH6kE/rMc5R2spmPIQZ5DUIDxp+dYckNqnMMYullvad8DS9eLtIco
	a14Q08NKIyA8CayAs3gFtkV6B/xoKxkwfdLo+xxv6mic6mwux/F0U7MpfEobS5f2ZK6LsjzMaVC
	8WJ24Edmic8ixWRI0b4pienhWKXi/7pLC2DjxZA5pCjYHpdYGM0u3M8OO5pp++zbw37BEIU0NeT
	EL4L6BOqhk0VD3PiRL5ioVVpJJAbXfDlizvaCF3xRs8YItwnRI7XBn+jcw/sZ4pt3WW+vqtfEWT
	FpXHx4/D1k3E4FlzfsL6qFsLzViIJM9rL9BY5JOkNF3G4I2MoaobHHVx2uDQEYEqhthECQLxGjv
	XzqIAFsimbbry+Mko4fcsekX4OOPunQtnkeNzG0gHORe3Fv1TPKLLzoibHkJtDg21QkvezxcZd/
	bchF6JjYVENS3Vko=
X-Received: by 2002:a05:6214:e8a:b0:91e:7bb7:fd65 with SMTP id 6a1803df08f44-91f24292699mr81332616d6.56.1794640225203;
        Fri, 13 Nov 2026 23:10:25 -0800 (PST)
Received: from gourry-fedora-PF4VCD3F (pool-71-191-145-202.washdc.fios.verizon.net. [71.191.145.202])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-91f23db3a99sm37730986d6.40.2026.11.13.23.10.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 23:10:24 -0800 (PST)
From: "Gregory Price (Meta)" <gourry@gourry.net>
To: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org,
	kernel-team@meta.com,
	linux-doc@vger.kernel.org,
	driver-core@lists.linux.dev,
	linux-serial@vger.kernel.org,
	linux-pm@vger.kernel.org,
	damon@lists.linux.dev,
	linux-cxl@vger.kernel.org,
	akpm@linux-foundation.org,
	david@kernel.org,
	liam@infradead.org,
	vbabka@kernel.org,
	rppt@kernel.org,
	surenb@google.com,
	mhocko@suse.com,
	corbet@lwn.net,
	skhan@linuxfoundation.org,
	rdunlap@infradead.org,
	gregkh@linuxfoundation.org,
	rafael@kernel.org,
	dakr@kernel.org,
	johan@kernel.org,
	jirislaby@kernel.org,
	kasong@tencent.com,
	qi.zheng@linux.dev,
	shakeel.butt@linux.dev,
	baohua@kernel.org,
	axelrasmussen@google.com,
	yuanchu@google.com,
	weixugc@google.com,
	baoquan.he@linux.dev,
	baolin.wang@linux.alibaba.com,
	yury.norov@gmail.com,
	linux@rasmusvillemoes.dk,
	pavel@kernel.org,
	lenb@kernel.org,
	hannes@cmpxchg.org,
	brendan.jackman@linux.dev,
	ziy@nvidia.com,
	sj@kernel.org,
	muchun.song@linux.dev,
	osalvador@suse.de,
	nico.pache@linux.dev,
	ryan.roberts@arm.com,
	dev.jain@arm.com,
	lance.yang@linux.dev,
	usama.arif@linux.dev,
	kas@kernel.org,
	xu.xin@linux.dev,
	chengming.zhou@linux.dev,
	gourry@gourry.net,
	joshua.hahnjy@gmail.com,
	rakie.kim@sk.com,
	ying.huang@linux.alibaba.com,
	matthew.brost@intel.com,
	byungchul@sk.com,
	apopple@nvidia.com,
	rientjes@google.com
Subject: [PATCH 10/22] mm/khugepaged: restrict collapse to common memory
Date: Sat, 14 Nov 2026 02:09:47 -0500
Message-ID: <20261114070959.3490008-11-gourry@gourry.net>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261114070959.3490008-1-gourry@gourry.net>
References: <20261114070959.3490008-1-gourry@gourry.net>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 66pz81hz5tsxdjufc6zbfzygn51kg5ru
X-Rspamd-Queue-Id: 8B7EF40006
X-Rspam-User: 
X-Rspamd-Server: rspam11
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1794640226-769466
X-HE-Meta: U2FsdGVkX19vf815jYnC04fKg0Er+qozEPfyYj1T7T3bYkl7MeJvegld5cWYg4wLlVX8rRBQLaNUxKwhjDFNmyKdE3Oh0j+8AtyUYzR57t//dr/++8eFlWpZ1sYz5TazRI3Yj/M84+aiTDNiSJpEX2aj+Z8qAy3hpR8xhlyOEHKmeZ8HecD4eg9URDCulFrb0XG47Rt62opCp+SftCM1j1xLySUFBc1TaifPNkIR+1iIhM6HhbjH9cWaj2G1O0mQHtmF9KSXozJ/gsuaZBJJT0BK/ayKt8U+c91zjxXBQYG/cXZ7Qj1R0UVdLPuOQFynMNmyxyHg8FgeJ9+HJqlWsbbii0lde6Qu/rxnVDqJOexMuY5D9CdDNFa/GcOZQfDX2hc1vUfpCGfqrv0WvelbWaYLkyRgp73MOnoHXIoVI0sxvesT8LS9FxWJQcaunKScO8xf00JRDNYhGy/SgW/bPgnsEU4V/j+zO0bSiFx/IYFWMZxOW2gYlzkjpTQ9HxkEaNw7w+gTMALkUwlwdK4IFIC5w5Qidwj6gz4EGSOLUv/1SYCaLMXMcqGZeR5kQ7w8wMFIEoExYawkVS3GRdhLXanzSvJQOtqst7Lkvon2jrjHLTFznzYOLxD8B+0feXnoiomuHpEBIVz+f60uHVDuwMUZmLk4ORqMgJsotjdOW0m1MB7JvcYWkBfOTqabIIKRmQPuNL2Ru9Z1HKqBdc0Jwua2kurTYpufpLyBdFyKQ2UX34jqebZJC3+Rn0w51jru7N/qOf8TcOjfpo/4AAcrEjtCxE7Bh9yQvPPGqAIWURbfZakuw4us+jag6Ld7Ao3QiaJJ3B3Sk1MlUW0RnwBVqiP3ldkkrXJT8+SwUzrXaPQRfr/KvMfP1cm3zM1NpDNhW0MO6tkkj74SbS6kJ58ZOcbje6XG/QgLdIsn/wAQxdkFFCH0t/epL6LJ5pwxpSsHCpk7kalAFcIJ3Qq5kHt
 14sA3cqs
 pjixWXw6+dAb/yUrCRvfwi6gpQjwtLOfnpwcd4jEovSGDnN/4K8vmnZwDSO35yjskKEBABDeeieSHBTXnappVgwwWb/P/jOIMU4VluslqVZ2LXNZH60lyiZ1oplmSO7CfarzStiZvlozr0QhHL+MJkac40i8oYwt6mgkyOgwp0W5t0ISkBKtBNjchN6YqNzHCOR+4a75KjemU8fGuR+ify2/Bmo02WBmmbxUx8cj3I10YEYsSUOUWBF6NIMe6yYQEc1FjEOe93IABjBcjj/uh8pWOFY3IF+dydh2TSs6w3j0hryxyANpee1Vdp2NAEX5agIprL7DsMVqxBdKeKTX89qdJ1eJzbcxlopWPa82n2sB2EVPxkm777cLYOuHNx4W5Q+Rs
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Collapse is an opportunistic MM service and should operate only on
common memory. The anonymous scan and isolation paths already filter
zone device for the same reason.

Replace the zone_device check with page_is_common_memory().

collapse_scan_file() gains a folio_is_common_memory() check. Page-cache
folios are never ZONE_DEVICE, so there it only filters memory outside
N_MEMORY_COMMON.

All memory is common at this point, so behavior is unchanged.

Signed-off-by: Gregory Price (Meta) <gourry@gourry.net>
---
 mm/khugepaged.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/khugepaged.c b/mm/khugepaged.c
index 4bbe319ef86fa..b4bd29f25c145 100644
--- a/mm/khugepaged.c
+++ b/mm/khugepaged.c
@@ -628,7 +628,7 @@ static enum scan_result __collapse_huge_page_isolate(struct vm_area_struct *vma,
 			goto out;
 		}
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(!page_is_common_memory(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out;
 		}
@@ -1673,7 +1673,7 @@ static enum scan_result collapse_scan_anon(struct vm_area_struct *vma,
 		}
 
 		page = vm_normal_page(vma, addr, pteval);
-		if (unlikely(!page) || unlikely(is_zone_device_page(page))) {
+		if (unlikely(!page) || unlikely(!page_is_common_memory(page))) {
 			result = SCAN_PAGE_NULL;
 			goto out_unmap;
 		}
@@ -2741,6 +2741,12 @@ static enum scan_result collapse_scan_file(struct mm_struct *mm,
 			break;
 		}
 
+		if (unlikely(!folio_is_common_memory(folio))) {
+			result = SCAN_PAGE_NULL;
+			failed_pfn = folio_pfn(folio);
+			folio_put(folio);
+			break;
+		}
 		node = folio_nid(folio);
 		if (collapse_scan_abort(node, cc)) {
 			result = SCAN_SCAN_ABORT;
-- 
2.53.1-Meta


