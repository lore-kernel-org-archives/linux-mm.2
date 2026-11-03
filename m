Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F1517606A333
	for <linux-mm@archiver.kernel.org>; Tue,  3 Nov 2026 10:17:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=ooOtGPpH
Received: by kanga.kvack.org (Postfix)
	id 0C8376B05BD; Tue,  3 Nov 2026 05:17:42 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 0A01A6B05BE; Tue,  3 Nov 2026 05:17:42 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EF8066B05BF; Tue,  3 Nov 2026 05:17:41 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id BF48B6B05BD
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 05:17:41 -0500 (EST)
Received: from smtpin04.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay05.hostedemail.com (Postfix) with ESMTP id 51BFE40394
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:41 +0000 (UTC)
X-FDA: 85393406322.04.FC0AFD2
Received: from mail-dy1-f177.google.com (mail-dy1-f177.google.com [74.125.82.177])
	by imf12.hostedemail.com (Postfix) with ESMTP id 8355E40004
	for <linux-mm@kvack.org>; Tue,  3 Nov 2026 10:17:39 +0000 (UTC)
Authentication-Results: imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ooOtGPpH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793701059;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=LyGJat/C8ooo5bLDM+7UJK/pGeUEXPhrPklQUuKrBbo=;
	b=R/WDNHx978Ngn8wzWxwRO/YfNTl8+ANUBLP+FK7HA23lA+5/JJ8BsD3iicSZBwn52D9jhU
	akN5+h9RQcPFyx73OelSpuuWNexgED/sLm0kLs41rHPM04FRJbIt/tba4ObSau8eYao+mq
	NYYbTePzEqbYvdJt16B3rEznd5OFRDk=
ARC-Authentication-Results: i=1;
	imf12.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=ooOtGPpH;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf12.hostedemail.com: domain of jiangwenxiaomi@gmail.com designates 74.125.82.177 as permitted sender) smtp.mailfrom=jiangwenxiaomi@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793701059;
	b=kpkHWuq1FvcEyzGhC7cq1dOY2UXC/7wBmTUOkwNagArttHJLT1lE6W2dloDhPS27r1It8I
	OwE4VoS2bb8EuXKI5a3aqXLhM64B0DgRKcnW/V+ptgdepOK7prEjqncmbSaWdPXac0nIry
	GVypZUo3K1qCj/UwpAR7mFJ1PAKHV7U=
Received: by mail-dy1-f177.google.com with SMTP id 5a478bee46e88-353804b591eso6960314eec.0
        for <linux-mm@kvack.org>; Tue, 03 Nov 2026 02:17:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793701058; x=1794305858; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LyGJat/C8ooo5bLDM+7UJK/pGeUEXPhrPklQUuKrBbo=;
        b=ooOtGPpH5qkSuyIVtjFtJ1adnQGcbZ+3fz7cw/qyfjLlKXAu4HBLV2Jdp5Wr0+77uN
         8VyRAZVQFowTWwoLwfX8LYbrYG1UeeBjCbt3IoSU8UqnqatC5o5ynVt3KVil8+4MDdId
         4cVAz3H7pRU6PYv2ux4dWJHAgcU/2IxsAKn0GY9MT8Ihc6VAXu1P6zL5EtBmn4pwt4rF
         O9edajYK1oGh7zkNvqxKQD1+IqvAqTXbXp/Ud6q4PPmQYEzXecLBaDVd7/O8AGERlE6W
         e2qfR5L7NPjVCAwCuFo5rm+Ggls3PJq7s10GEsv9MP7ev01SCjz/7krnWcDgAGnSchJw
         cb3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793701058; x=1794305858;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=LyGJat/C8ooo5bLDM+7UJK/pGeUEXPhrPklQUuKrBbo=;
        b=xX5EVEGu9toGYymXn9QYjX0S50nf3bS9cMQlgnDBLuWwgy3PzWtrmVOmYpcA4XbM7M
         mshmXzfa3wMRuM94GGTDYKcfHBfi4sGdNrcPgtgJNxa+wIPl0SP/30a7bew91J6u/43t
         zgNXE+hNeLwVamZ9rQ9imz/05xauf2l13cY70B0PC/OnaYguq1QHvymDqrPEu3Z3AQAs
         UTXA2VrriXPmOaVkTssOy+WnmgMM33O9rJmX2D8hwQ7FLJ88sgmMZRNtKPSFOOUmAzn/
         cYsWV+k8GeEqjrO5ZEJSHsTntSOvYX/SFYY2CXYWSVQpIcRBmpngpY2TBQQwRmGFmUgT
         zfoA==
X-Forwarded-Encrypted: i=1; AKwUvBzxCO8pJEH96TKBuR/N2aKfyb9+oeUxv0cfwEEsmDE3h1TWHsu32Q8Ve4Tnzot/0sdxvKHQCj4b8w==@kvack.org
X-Gm-Message-State: APuU4Z//obQNfe/AUSid01ZA3cnTo9H5OTZYKA4yH2bFJfwIEktz9n7j
	3axQNuDa9Mq/svASIhobWxHfg+RTPvFpuT9793KoynoupcaFmP/A9Wc1
X-Gm-Gg: AYBFou3jGxLuOdrQn0p7Pkm2Er9YeM8R9sH6vOTHcWEwk/FHgUDA9inacoYj0aeCpg4
	jvk+RQFk7tx7w2nvd/OG16VusgJTkPr4Zal/bLRhr+WJfxgAACsngFaAJYrPv0hK2MhBD4DZlDh
	UH1JrklOtZD8fU0rDI7x2pimNwE9Xu2UdZGxJyVBK3VVxi9gTnORSt2y6o1c0awWlz+WEHFpvst
	7OwGknnoYhDB6XSlRMbIUTQyEfuGkItFLmk8Ez89ZCBeMci5Olp7JXHxer7X0RxhDyR9SuNk+wu
	0Qz8PCXlfcgJQpMR1TALw/crmayKQQV4dOFn0UP9IUg2nhiOuxDdHLmf6l7w7Mj+B4mBwupxqEV
	5EoqkV04iERjvkHySkM4zYTpaYRypZk6uRKaj+4Uu8A9h9icP3bucui7qRhaX5Tv9ppjxXDPDYy
	ChbCGIPoiUYPRyfkCzZdE257g9QUwWaU8AI5xkMtKa035YdltgN+LHbnTcVp++NM8X2sBgnS1xs
	NncXWRYwKLa4gtK/HXLQLSc0rSs5P024/yc7i7Y/tu49m0MYOgUkihf0k1OKTfRfA9NqtcRE/TE
	wq67JfqHnq/S5sEXUXszUPFU1EGFWQ==
X-Received: by 2002:a05:693c:638c:10b0:369:d8e1:7bb6 with SMTP id 5a478bee46e88-36a423c2ef8mr19548958eec.25.1793701058355;
        Tue, 03 Nov 2026 02:17:38 -0800 (PST)
Received: from 027.. ([2409:8a20:4a5:7150:84fc:ce3c:7b09:dbca])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-36a4291e38fsm53145387eec.15.2026.11.03.02.17.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 03 Nov 2026 02:17:37 -0800 (PST)
From: Wen Jiang <jiangwenxiaomi@gmail.com>
To: akpm@linux-foundation.org,
	catalin.marinas@arm.com,
	linux-mm@kvack.org,
	urezki@gmail.com,
	will@kernel.org
Cc: Xueyuan.chen21@gmail.com,
	ajd@linux.ibm.com,
	anshuman.khandual@arm.com,
	baohua@kernel.org,
	chleroy@kernel.org,
	david@kernel.org,
	dev.jain@arm.com,
	jiangwen6@xiaomi.com,
	leo.yan@arm.com,
	linux-arm-kernel@lists.infradead.org,
	linux-kernel@vger.kernel.org,
	linuxppc-dev@lists.ozlabs.org,
	maddy@linux.ibm.com,
	mpe@ellerman.id.au,
	npiggin@gmail.com,
	rppt@kernel.org,
	ryan.roberts@arm.com
Subject: [PATCH v11 04/10] arm64/hugetlb: drop the init_mm special case in clear_flush()
Date: Tue,  3 Nov 2026 18:16:52 +0800
Message-Id: <20261103101658.766905-5-jiangwenxiaomi@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
References: <20261103101658.766905-1-jiangwenxiaomi@gmail.com>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 8355E40004
X-Stat-Signature: b8papsqqr6csszpruwzz8moduc6drx73
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-HE-Tag: 1793701059-47035
X-HE-Meta: U2FsdGVkX18IOaX7jLCbtDWco4Y4X5wjRApi4W0uQHDTe6jYf+eS8a0sZoGMVVyVkxOSLkEjsazGHxeYTZRfIHneo4v5ltMiCmRJtK1nxMdQy3XHg0d9sztggO/xdal91bCF8JxlJ///elz3jdTwrxh0AmlwtdkfxZ0J0338QpHKrrwlsfgljUDDcLMrqZuGK0a2vENpvnrGQdDLuc6Tw9ZZf0wsGrv/89Eo4COzLx+Q2GpDbnrJHiqteacw7gwjUXt5v3QhmH1edR/L49krjMFUGcPmbB42yCVGw3bNWm/VE60Oty2aJtSaM4DVS/gN2UzDH2L2qw5lPb/Zkg5jD36N7pNSFIoumiH1AEZ1Lnz3vISsU0YNG0/pGtVU2C73klT7O8b5iO+dLCr4FWnT1w+vkZzhJX/n0nx0tWS+Vcocnl72/LmPdxFsKjrBwsVJ8d1rJWGUBNvTKfUxpAYkqm1LOdStMzHyb244tcmdh3U+xDkVpWG1akWUyhSlBNbBdqyEXCuE9pUBi7ioOu5Aqo9xa0iFRxQYGcqldjLgANRs6Pixr8DXNddlZMbPjDcpFUmqO+lhMuBy3KQZAxB69wCKBZtnSdtYL2i6bzMuAVEEm7yX/zPLSN06mH/caE4kF+a2MYQLuOyuDBS2voKkvX23fIfgiAsuSI62BhEUmO7bDHbWXV6a68zuglBJAkbNC9IMcI0QWL7UyKzSoXM51Kk+SsHnTEKtUw3MqZumCcr6v88stwcpKaB/yqJoZzX9rtXFHmF+Xoscvv0A+E+j5kx9+ltTaZh1XRmVqGw7nPCNbX8mxbXV8jlhc13OGFXvoy9OUMUNSGjy/M5UOhyh5+M5/CSsYCc1v2dFd6Yv1xTIDxqc9wV/lbjuoO349eput56Y+3SL4BesBdHqLLmmoIy7Fwu2kR2M7RyaBW2PyEbACu5oZIYHj6fpFHcXbK64SVnKcyhtYOCHo22mKjK
 ogjrt4pI
 BNqdC/4gBsKMm/Q83JWk3o0cv/QX1PUjonepIaucVFy2JGjGcZQSrJspA2i+S8vJZKlKutC84mH9a7hnuIhBd8qFrFcJUui7cTySIFzJPkQMw3XVnz5NPU1lFV4BOeNQBdlp3lD8ss3h+YPE79UMrigpgN9sn4hndxAgmuSDV4Q7+WJ3N2GU42PHvI2WXJ9KkMlP+dMFDJh2GV3HJ1uw4VXviwaCu4w/l8TnL43e6xtH3M41twhvwim01vWk9NIJ27Vr7gqk1XEh7pybOUqq+q07fTgVfewPx+rwq0cfaHOrKezdrVd99rsgs7mmM6aJy97kFdsZY6VM5ct1MFtMpQReWhrkfxCOez3CiF5MA56dpTAAeFii2U31pWAplJYE/PJoBWzGYaHIFcmj+H0PN2f9D8wchmw/bph7mAD+5Cii5p37JYih4Ne3Br4pn4WP+wqXzBTWwxkNeDozD6Ag0ZFjgzNqG/eFYIMZMBVZDu5m8x95VXhQOAcTbONyKbIzHYX22at6bd4BBftfuYVxd2wej0R+sSl2siT/I4wECXe3YkF+pkVz0UiJxcL50x6yvdnqOPHrwYNXHwa2Tffdd3EMWYJ1Ukzbgi63Nl/hgI37ngiIJk+SQVDVaQspIxIX14Mx4duddsWky194=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

From: Wen Jiang <jiangwen6@xiaomi.com>

clear_flush() calls flush_tlb_kernel_range() when mm is &init_mm. This
was added by commit 06fc959fcff7 ("arm64/mm: Support huge pte-mapped
pages in vmap") because vmap called set_huge_pte_at(&init_mm, ...).

Now that vmap uses vmap_pte_set_huge()/vmap_pte_clear_huge(),
mm/vmalloc.c is no longer a caller of set_huge_pte_at() on arm64. The
only remaining callers passing &init_mm are in arch/powerpc, which uses
its own implementation. Remove the dead branch.

No functional change.

Signed-off-by: Wen Jiang <jiangwen6@xiaomi.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
Reviewed-by: Dev Jain <dev.jain@arm.com>
---
 arch/arm64/mm/hugetlbpage.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/arch/arm64/mm/hugetlbpage.c b/arch/arm64/mm/hugetlbpage.c
index 8e799c1fe0aa..ce247b06fe03 100644
--- a/arch/arm64/mm/hugetlbpage.c
+++ b/arch/arm64/mm/hugetlbpage.c
@@ -206,10 +206,7 @@ static void clear_flush(struct mm_struct *mm,
 	for (i = 0; i < ncontig; i++, addr += pgsize, ptep++)
 		__ptep_get_and_clear_anysz(mm, addr, ptep, pgsize);
 
-	if (mm == &init_mm)
-		flush_tlb_kernel_range(saddr, addr);
-	else
-		__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
+	__flush_hugetlb_tlb_range(&vma, saddr, addr, pgsize, TLBF_NOWALKCACHE);
 }
 
 void set_huge_pte_at(struct mm_struct *mm, unsigned long addr,
-- 
2.34.1


