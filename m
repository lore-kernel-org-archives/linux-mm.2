Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 09D51105D996
	for <linux-mm@archiver.kernel.org>; Wed,  8 Apr 2026 02:51:40 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 6426C6B0089; Tue,  7 Apr 2026 22:51:39 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 61A106B008C; Tue,  7 Apr 2026 22:51:39 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 557686B0092; Tue,  7 Apr 2026 22:51:39 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 473236B0089
	for <linux-mm@kvack.org>; Tue,  7 Apr 2026 22:51:39 -0400 (EDT)
Received: from smtpin17.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id E39191A08EF
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:38 +0000 (UTC)
X-FDA: 84633863076.17.B5B8F93
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf12.hostedemail.com (Postfix) with ESMTP id 3CA6B40009
	for <linux-mm@kvack.org>; Wed,  8 Apr 2026 02:51:37 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BzW0ige8;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1775616697;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=m8O2Q+OOohPaG3znAvecqv/xmF0EiFxUP+dvhSeqtjI=;
	b=KpmZLn6uN7DbBd7aGfPaOdzOOcZwRpFY/ne6zc2EE3Pi/gTdyzNZbRE3t6R21aDug7Zw8f
	D9N1H5EM86yYv/+Qo3quxoCH47EgQ9tDvlJkDqRT+S7zRnSYZ3hX7iVCmIhS5Y/odCno65
	ab8HRQ9mGvA8jBq+RYMQEYjvmoM/8GU=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20201202 header.b=BzW0ige8;
	spf=pass (imf12.hostedemail.com: domain of baohua@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1775616697; a=rsa-sha256;
	cv=none;
	b=OjaB514bbGwshWIWl5h/hlWY9Ntq707UQDWUM+DRsvs8qZGF6OlIQ/qkv/jdZwJlZadCAO
	vPlLrP5/f5Lv0pecbmcmU75o8lHMSjweRS6+Ww3h876YG7AhXyEudiYPxYz1ER15jHadgK
	I74VeeJDQKk4adke8AmAh+XMaWBQjD8=
Received: from smtp.kernel.org (transwarp.subspace.kernel.org [100.75.92.58])
	by sea.source.kernel.org (Postfix) with ESMTP id 25E7840B92;
	Wed,  8 Apr 2026 02:51:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A765C19421;
	Wed,  8 Apr 2026 02:51:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1775616696;
	bh=4KmW52ojotdS2xyp5e7cHouikLW+lgqmv208rSJWWic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BzW0ige8moHKxCsRbPugd62Yndyj4ujFsahw2nRcpTm9uavw9pSg+Cl3QXZMbhbOs
	 CRJ/obpvlt+QtfpvDJqG8erfrQUDxd/jWu23tqqnM6x+1x30CnyupCQeq5j9qD0kxm
	 JCSvjzPRI2QgUgvpr9pYX6THqbL5wDqC0F8YDbumK+wvx3tKpJxUN8VB+WXAk1WGa5
	 RJuGyF0FkI25BxDdvd7tqG7jgI2YTJ7vwg7NSKi9reKMPaQ8jeRM/iCXcV5rbidTje
	 H40htvvu58zYGzXh1d37lXzt0+aPfGvRwj8LGEX24mIvIpT14Bwm7cRX5l5Wy4tBOb
	 SutlY4vi8RBXQ==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: linux-mm@kvack.org,
	linux-arm-kernel@lists.infradead.org,
	catalin.marinas@arm.com,
	will@kernel.org,
	akpm@linux-foundation.org,
	urezki@gmail.com
Cc: linux-kernel@vger.kernel.org,
	anshuman.khandual@arm.com,
	ryan.roberts@arm.com,
	ajd@linux.ibm.com,
	rppt@kernel.org,
	david@kernel.org,
	Xueyuan.chen21@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [RFC PATCH 1/8] arm64/hugetlb: Extend batching of multiple CONT_PTE in a single PTE setup
Date: Wed,  8 Apr 2026 10:51:08 +0800
Message-Id: <20260408025115.27368-2-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20260408025115.27368-1-baohua@kernel.org>
References: <20260408025115.27368-1-baohua@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: 3CA6B40009
X-Stat-Signature: p31k79tmc4dtz5esmoe3zyuts1baqzbf
X-Rspamd-Server: rspam06
X-HE-Tag: 1775616697-895861
X-HE-Meta: U2FsdGVkX19tJWLMAZrTpofsJJpCApkDdde/rVXbmthWvhmnHJCh8c/lPRCUUBG0SiUtXum87LazDn74zRr/gZpjRQC5ea08XteanVpsghYjv3rKaWyStL6pmNqxz2Eo/LV5jnTVXcg+PB5FzC5+/OswP1GCPCGfbOpM0e83b3HZZvoh8PUMlm2lFTpzB8lXOTXKjXz8JjnoGKCYHjFt9QyeD/g8GGRiLQ7t41WwPZAnaFQNbhXDcwDwONE++eqDKSjx3rPjRQMgHI+v3z4jrXKb24deAYbuYKQhrukxEPPvyvPvbnhSanHxzDPNYO4lbZBe74OIe7tyMbFdab6l/r7lLk9Vg6zXlZRz+wzvcav4DymjiqzM73lbTOfnyz8cSHKz3SeKcbJp4jFHzKh+g3bdClvS8lt4UeW+g3MytAEJAxUIFOiw1q+sfemKYln17EWAtkLkaSk0R8kS7g+n62N8xfU4YWjJFUVT4GsxLiMgsgWUMI+J1cf5J5VqVbIIR05eWOu+Kb8Nz3qgexK8ZgByLzlFcQnKVa7sYZhWL7r28jye6ZnIz+DC/18qsVbsIxKKa46LwflgScsa6410uOBDDz+Lqw/KK8r5ugEksCCPVmyEQMbMS96ZPGGouy/jF+vZTcuorKJC+hzxu968ugAumm20KeNaenoW7CF2jZIzn5Sq4HkOg7Pijy/UIMTjtPVMQ4mwgEwnTGbkfm38SOvGJfjXsA97OuAUUKkLUxHOz022dQ7Me1sk4voWXMSBplG2ysDsdUY+lpiPgHh1iQKvvMhIpX/rMMssQ2Zhf32dNXxvPly9jGjMUcrG0g3XxeLf2rr+anV2kkDZJ6/YnuMhPupiIYmJKJr31aMGtaTY6nMMkZuaVBo4fSHyCy0BOz+imynNDTWRAYYrx8BHTKqpMUrMimOxGZ/he8T6MHqPUUgTwvMrzM9c84KRkfUr/d1H4Y1VzaW9Ab9Q6qG
 ckDYWvkS
 25jdlBD4r2CmI7aScxwb2LvF4ZaYsVU0VAkwrzZaQKvH+efHSJVGwGgxZE6DZ2ZJGY6Gj+qaOIGAc449R+e/ESrlYPXvP0eW4i6nnut5FvtZ0J52vcotPx1wePDae+FPPHHmUbUT/ko7zXbSUJXIZx0MQIBCCr/dHSQDLHcy0uTeUFmwopTPmdygIikDn/IUA3Zg5U5afotNlQfyEkMfNiOouL5w7CiiPySAZlaiL50EKaUWaPGAaiiCrGE8mFsaWuTRqum2cJuGdlYNm4KTDoTKi0t+8jVECiOaGIW76TQIv2Y5MUdtw3KApvkGgQPFQz2Zfg0Xo6ZoGddwtBD1Lo+ySD3ytgPtXILFX
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

For sizes aligned to CONT_PTE_SIZE and smaller than PMD_SIZE,
we can batch CONT_PTE settings instead of handling them individually.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 arch/arm64/mm/hugetlbpage.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index a42c05cf5640..bf31c11ebd3b 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -110,6 +110,12 @@ static inline int num_contig_ptes(unsigned long size, size_t *pgsize)
 		contig_ptes = CONT_PTES;
 		break;
 	default:
+		if (size < CONT_PMD_SIZE && size > 0 &&
+				IS_ALIGNED(size, CONT_PTE_SIZE)) {
+			contig_ptes = size >> PAGE_SHIFT;
+			*pgsize = PAGE_SIZE;
+			break;
+		}
 		WARN_ON(!__hugetlb_valid_size(size));
 	}
 
@@ -359,6 +365,10 @@ pte_t arch_make_huge_pte(pte_t entry, unsigned int shift, vm_flags_t flags)
 	case CONT_PTE_SIZE:
 		return pte_mkcont(entry);
 	default:
+		if (pagesize < CONT_PMD_SIZE && pagesize > 0 &&
+				IS_ALIGNED(pagesize, CONT_PTE_SIZE))
+			return pte_mkcont(entry);
+
 		break;
 	}
 	pr_warn("%s: unrecognized huge page size 0x%lx\n",
-- 
2.39.3 (Apple Git-146)


