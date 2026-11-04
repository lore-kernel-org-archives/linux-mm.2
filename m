Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 716C2606A339
	for <linux-mm@archiver.kernel.org>; Wed,  4 Nov 2026 02:36:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=bytedance.com header.i=@bytedance.com header.a=rsa-sha256 header.s=google header.b=Ch0XGqgs
Received: by kanga.kvack.org (Postfix)
	id 45E076B05B8; Tue,  3 Nov 2026 21:36:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 435566B05B9; Tue,  3 Nov 2026 21:36:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 288B06B05BA; Tue,  3 Nov 2026 21:36:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0015.hostedemail.com [216.40.44.15])
	by kanga.kvack.org (Postfix) with ESMTP id DF0A06B05B8
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 21:36:08 -0500 (EST)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay02.hostedemail.com (Postfix) with ESMTP id 518491205F8
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:08 +0000 (UTC)
X-FDA: 85395872016.02.0C217D1
Received: from mail-pf1-f176.google.com (mail-pf1-f176.google.com [209.85.210.176])
	by imf25.hostedemail.com (Postfix) with ESMTP id 8672BA0007
	for <linux-mm@kvack.org>; Wed,  4 Nov 2026 02:36:06 +0000 (UTC)
Authentication-Results: imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ch0XGqgs;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793759766;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=rwz1upjxMhUq/LY8/yaJXrxultuUj0G45SVbaoLrqs8=;
	b=ItlzlqUVVrYQnGRVGUysv66S4Jc4bR3O+kXxKk/0g8lin1xmy+7Hfi+ZY2LctnRVvk92Qd
	CKgNFl7BrIekuwZIui++J/OYABfgO5OF9QLAhIKhkXSP8YMIYhRA7bZRgi4EAtsgka/BYb
	Bb5NCHZyo/pi7ZDVVQJ2e90rExudB20=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793759766;
	b=LohEVcBBRKwjHVPv1td3MKM/vqJ91vV6tm3dfrCuH9e4ryuzc3Ywslf7DlSUiXS9oVBkm0
	jnOIaIP45zHOvmKMfnGdFfnnihFMMGrFR7dSBRTAvTgx2QaB3mIY24WuS6CBsBFhMlT3nM
	GzEdcJGYoquw2xIyIl4oIn7n8Ahj3Sg=
ARC-Authentication-Results: i=1;
	imf25.hostedemail.com;
	dkim=pass header.d=bytedance.com header.s=google header.b=Ch0XGqgs;
	spf=pass (imf25.hostedemail.com: domain of songmuchun@bytedance.com designates 209.85.210.176 as permitted sender) smtp.mailfrom=songmuchun@bytedance.com;
	dmarc=pass (policy=quarantine) header.from=bytedance.com
Received: by mail-pf1-f176.google.com with SMTP id d2e1a72fcca58-8a058f74a54so73022b3a.1
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 18:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance.com; s=google; t=1793759765; x=1794364565; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=rwz1upjxMhUq/LY8/yaJXrxultuUj0G45SVbaoLrqs8=;
        b=Ch0XGqgsG9KeRF4b+XUgUqNoPW4C/hXFCHBcRD1LS52GvzfaHUJZCW2kWkxUBn9dgI
         hAF+BbZ2s5CxxYzpS83+9rkMAlv388yalD6xVUzp7kClHT1fznjQBa8ulogrh0SVYmCA
         Zk7Lb4rDNgPKkM20xE/fDzTCyZ6C5Ar7dlHEbhwaE9VksR7gkqG1Su1TeHacCGizFUAn
         nanUIk4UnQQsBDOKEUlvvJ8jGfMkesS8WlMlh8zx/9Vxehv9e9d/zkETOnLIR5WKBLVU
         atC7ilFq22H6mEfNRL02Ku/2ErJN3nJfMwkgxsop0e/p1im8bGPzF4sRCPRInDM8YGc2
         GtNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793759765; x=1794364565;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=rwz1upjxMhUq/LY8/yaJXrxultuUj0G45SVbaoLrqs8=;
        b=ZdCXoZhptrD/av4POZNnmOYJOw8y8HkoVW4WpRh5a5ekr83cd88sXgPSxXSDUmAyjR
         D5RyT4i+lbX62K+XPkBZIgW/3h6LJVhxlQiXDkxlWwZMn0UGLONl96eUaosn6JyedbOQ
         ucffiQ0f8wk2AiVlAT+Z51qjWQB0RtmSD1xFod6ToW2BaFrYs5u0xOgsdgtE5JKnR9QU
         V1oOXNT6Aui8KPoM2s7wr5fXe6shskB0lp6tPChonI4YkfUUEj1SPIOmR/6DCn52eD5N
         fOwmZSFngc5mZ6zB3WD3212RpwomAE212JlZUbDQuzFtt3sZsM8sb7hytrhDDVx2zHH5
         Sg4w==
X-Forwarded-Encrypted: i=1; AKwUvBx8OHpFxK1iEBTUxo39/dUzapr3sn2XTI0pxVurkEoFzttkb9NB0Qurt/AM0OkdvEEEgJ9hZTrtpA==@kvack.org
X-Gm-Message-State: APuU4Z+bflW4i24/oG0xRTekh0/R94nr+b0mZ4ANnr/Advnjhplgsog9
	11yrDMlyeI0W70Gu8nleIq56oB+MNNknh7wOOU6QOXZpvvuKBn/wyK6Ws0qxgmJ8wA8=
X-Gm-Gg: AYBFou3U1OWBTHMD4hiQ6Nua4B4sIoHbza7wX0gSpxUl2CEkxJvfnFuA7EF1KgMhwLF
	qzk2RofX1yje6bQ2sFe/RDAHufxChbBAzOcbBvEXuX/2ao1PQS1EoNGZNklEI2zcaZMGPdkRQwQ
	tzAdXvpq6Zt/KEvdiEzrHqdPLaRMxu5AO4I8ypu3UXbrbk4NBOSExh/AXCAvIjfkQVXABwyxsM5
	/c7SPH3p9Wrt3+HoaCE5OU0AwlSeM2FlzU+5vV7qo9t1u6M5AoURUFDiO7i2GGZ/judtQEX1iGl
	DArZXlyMbc55haU96kXNArxNRb+2ZF+OSz0qXnZXdwg95dB+A5CPjt2kN4dmdxq4EoOt+2PIeWa
	1rHJ9oTZOaj/GLSazTBJqyTiioauVK7L0fO1LnA9sC/3ncwmMLmqP3F/NDE92gCMNzTAaAW2NhS
	H1sbryX+VMqxo+b36TV8qKmSzFTeDWwH0G6GPWJ4uHQu04HkBj14IDqlFQx1ClBqKxCuZqRJwaW
	l11SyJbKB5Hteq105dtVnjiW+8DIvzVmnLqn+uUvso+frdX5ZSYX8UfcxOHv5yf+nAqPr5jYCs5
	S665sJuuBsZfSe0a+BIpTgY4uG4OhjBTQX3BORylmFW4alFQKd4=
X-Received: by 2002:aa7:88c6:0:b0:89f:7a1b:2bf4 with SMTP id d2e1a72fcca58-8a9be48babcmr12731066b3a.16.1793759765350;
        Tue, 03 Nov 2026 18:36:05 -0800 (PST)
Received: from n232-176-004.byted.org ([36.110.163.99])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8b09bc3d1f2sm240815b3a.50.2026.11.03.18.36.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 18:36:04 -0800 (PST)
From: Muchun Song <songmuchun@bytedance.com>
To: Oscar Salvador <osalvador@suse.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Qi Zheng <qi.zheng@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	James Houghton <jthoughton@google.com>,
	David Hildenbrand <david@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Muchun Song <songmuchun@bytedance.com>
Subject: [PATCH v3 06/12] mm: hugetlb_vmemmap: rename vmemmap_remap_pte() to vmemmap_optimize_pte()
Date: Wed,  4 Nov 2026 10:35:04 +0800
Message-ID: <20261104023510.260766-7-songmuchun@bytedance.com>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20261104023510.260766-1-songmuchun@bytedance.com>
References: <20261104023510.260766-1-songmuchun@bytedance.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: igq9sc7nytip1csz7apxui4u6pfmfsh9
X-Rspamd-Queue-Id: 8672BA0007
X-Rspam-User: 
X-Rspamd-Server: rspam08
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-HE-Tag: 1793759766-386877
X-HE-Meta: U2FsdGVkX1+yswlifs3PEs8Mt4bSVZIC7o1+o9uPMJEizx1OFt+95pbtnRX7EyezpHTOAPJKXjid8yHspaNfMgV0Igf33EGKesSNrG8mloueq2TivH1fVKvAr9pfaYNNmK9Q6sK07O7VNzNuF+9274xhdSRxThuy9XpMNdpX8TedMEaLU8dT2S4VCEe3e/ZPJ4ztNuxM2FsMK2+QsOcIxf0CkZhPL2t3Ztmc1gMIvBYxMIVREMD0GZcOkDUTUE/L4O2MreGwWwUnPqI3MHxBNgMnPYVS6bn78xw/BoZwe1vSnpHmyJV3A3K3eHaAWvYeL5649SSiNfl2cJp5XQs0gGtzWQ1jVgn2z0ZmhXUP3oWnc3ixzERniMgbc5IAQpbDxeh4ce4BsBsqcj+Hg9Njc1DeWc89UYhGlPumKhBYtUt4+5U5LyDGtJq0K6MXHXEvPYZ8JOMAPSValnHBMso6DIOuZFqNsZseMXjaNLGwJ23htXc4QV1zqS9hTec5StzxuY4jV9nB+313DTI/rSyKtBhZobAh+ltUBXJ5fP8ynrqWxjXn0bTY6qrjdWN2m2p4q2Ht1UHny+crnhtmkzCDAR4IB2NGkv+tIHmbrJ5yTa8t23oMXxMP+tdEmjKFPPA4TrbtrZfKx8fKTXUUAqdxBX2wfn540Mxlou3V9Dodhk9v2hL4C0W+79CytM2XcjJjcFNFZb8UolKvnvV9HBok1sJgGcxhFUp7MBcuYQ8NlMV+iCWfjyk6SDNLFVOH5amzxRONWL7w7l3Ch7GlYSwSSCfdNEHfPmtWQO5h7CRosyy5v8TawX0/TM05k9kxUL3gOeyVKSitFdFVmLhpP6Fk879lLqc1XavhUtuV0mJU2PycrtS+1i0zxFL1KOUhW9d824555t8QIcgdx5ut1ACK/tIYa20yr6fRNxdt/fbtwm0V1738YlhafYTn3oH2FirHE+S8OHBI7I+vtWnPSsl
 KBi6GNVj
 5t+DFLL4sOV7gdB6ekCVkW6L1y8iDeZaIkUZkB2aa24/+6VDmIXZRhacDG6TMJf0pAypRYEMofYs3tUEF2FY8du/SJYYyulmpSSQKdpHcRlGwR2+4jDuAyEdX/9pTNR58w3pKqnUv6sO7Zcb+Et7FliN8SHP4KkJuxnSOKPb6HlaQqJF1v0Hx12gHruko19McN66Vc2L5m3D+GzWDzZku8aOOYw9y2g1dknkfrGv76ghtiU7cWLMMWN+xO2w1Quf9c07rHjr3sMtPj/6s4NkwPhYZyVUwd7B/Bq/NdfMZp6kyFoYgLNA59c2CkUaqfb2ec1cRGUFWO+4V6qGz6zDkVHaAmcvkQ8a8fCzVg07W/sDOmvHSO//U9MJkF0vrRINQ2Dis
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

Both optimization and restoration update vmemmap PTEs by remapping them,
so "remap" does not identify the callback's role.  Use "optimize" for the
optimization callback to match "restore" and make the two directions
explicit and consistent.

No functional change intended.

Signed-off-by: Muchun Song <songmuchun@bytedance.com>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Reviewed-by: Qi Zheng <qi.zheng@linux.dev>
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
---
v3:
- Use two tabs for the renamed helper parameter continuation (suggested by
  Mike Rapoport)
- Collect Reviewed-by from Mike Rapoport

v2:
- Collect Reviewed-by from Lance Yang and Qi Zheng
---
 mm/hugetlb_vmemmap.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/mm/hugetlb_vmemmap.c b/mm/hugetlb_vmemmap.c
index 531150870aac..90175499b9eb 100644
--- a/mm/hugetlb_vmemmap.c
+++ b/mm/hugetlb_vmemmap.c
@@ -213,8 +213,8 @@ static struct page *vmemmap_dup_page_from_list(const struct page *src,
 	return dst;
 }
 
-static void vmemmap_remap_pte(pte_t *pte, unsigned long addr,
-			      struct vmemmap_remap_walk *walk)
+static void vmemmap_optimize_pte(pte_t *pte, unsigned long addr,
+		struct vmemmap_remap_walk *walk)
 {
 	struct page *page = pte_page(ptep_get(pte));
 	pte_t entry;
@@ -302,7 +302,7 @@ static int vmemmap_remap_free(unsigned long start, unsigned long end,
 {
 	int ret;
 	struct vmemmap_remap_walk walk = {
-		.remap_pte	= vmemmap_remap_pte,
+		.remap_pte	= vmemmap_optimize_pte,
 		.vmemmap_tail	= vmemmap_tail,
 		.vmemmap_pages	= vmemmap_pages,
 		.flags		= flags,
-- 
2.54.0


