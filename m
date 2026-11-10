Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7FB18606A32A
	for <linux-mm@archiver.kernel.org>; Tue, 10 Nov 2026 20:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cPBryI9e
Received: by kanga.kvack.org (Postfix)
	id 8A7F66B05CA; Tue, 10 Nov 2026 15:21:50 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 8596C6B05CB; Tue, 10 Nov 2026 15:21:50 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 721C76B05CC; Tue, 10 Nov 2026 15:21:50 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id 406566B05CA
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 15:21:50 -0500 (EST)
Received: from smtpin24.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay04.hostedemail.com (Postfix) with ESMTP id BD1611A0987
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:49 +0000 (UTC)
X-FDA: 85420330338.24.25D9749
Received: from tor.source.kernel.org (tor.source.kernel.org [172.105.4.254])
	by imf02.hostedemail.com (Postfix) with ESMTP id 291E28000C
	for <linux-mm@kvack.org>; Tue, 10 Nov 2026 20:21:48 +0000 (UTC)
Authentication-Results: imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPBryI9e;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794342108;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=URh14fMZaM8Bg63O4PhG+H34HuBb6CdZm+GF2CGxa1g=;
	b=3AgmYprH8pfAA3BkRnUubTCv80p7Vl8r/Vn9wxdSQENSsX3xIpn/VnhRLXAmDGY9T2yArr
	p2by1WOXnnQ4xmUEjeBl+Wa8n5jk+gLtB1UOi8PEYUVl6XQjGeYp670uFsTPegNGzl4soj
	4RMGObmuKEBLtMR+cINiqp13UM9C3Pw=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794342108;
	b=Yva1CB/1HQr3BuNze4NrrjKbuqFJq/p9O0+6ssGmHFT9EbLC6f5vn4BJVB181Mb27Sn7a4
	pXY4AxnbHoNa3YhPplyzMk4SYMEr3adZlj93Fjnt8LSviBv2P4hgrracCive/9gP58EoSV
	UmKgBDHxUHnQYdFi1j8VM5pqk5hRoq4=
ARC-Authentication-Results: i=1;
	imf02.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=cPBryI9e;
	spf=pass (imf02.hostedemail.com: domain of baohua@kernel.org designates 172.105.4.254 as permitted sender) smtp.mailfrom=baohua@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by tor.source.kernel.org (Postfix) with ESMTP id BDA23601DF;
	Tue, 10 Nov 2026 20:21:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE9B91F008A1;
	Tue, 10 Nov 2026 20:21:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794342107;
	bh=URh14fMZaM8Bg63O4PhG+H34HuBb6CdZm+GF2CGxa1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cPBryI9ekENwM1kavqgmk64R2aWcmSAgZBqDKOiz9zDIYHpfaJx4NnvfWdHb7jjgQ
	 xUpXTX8f9XFCqKh/nn0gLhsHHWkI0Gdaf2PyzJJwptPP7zoaYBUWv4NG/F3sLR8M+J
	 kprkEegxIxrzUQsHyAaWbzuqII/BvqGfaWt7xn38YaspEvfHBM8Fn2GITYj3C4Sbkr
	 4R2VFX1s2Oh67zSYnT+mK5UxlE4Lh214UjFjEYF4Tg7j6Zb8JJG4BBPQw9b69XT9tp
	 n55fE6bjLQ/SZB8h4BJ3RtaDgfHYCE1V57KA6qN/wEdRr+IU55WUKt01hfExk1+PnA
	 x5w2Mes3vc19A==
From: "Barry Song (Xiaomi)" <baohua@kernel.org>
To: akpm@linux-foundation.org,
	linux-mm@kvack.org
Cc: axelrasmussen@google.com,
	baolin.wang@linux.alibaba.com,
	baoquan.he@linux.dev,
	hannes@cmpxchg.org,
	hui.zhu@linux.dev,
	kasong@tencent.com,
	kunwu.chan@gmail.com,
	liam@infradead.org,
	lianux.mm@gmail.com,
	linux-kernel@vger.kernel.org,
	liuxiang.277@bytedance.com,
	lyugaofei@xiaomi.com,
	mhocko@kernel.org,
	mhocko@suse.com,
	qi.zheng@linux.dev,
	ridong.chen@linux.dev,
	rppt@kernel.org,
	ryncsn@gmail.com,
	shakeel.butt@linux.dev,
	surenb@google.com,
	wangzicheng@honor.com,
	weixugc@google.com,
	yuanchu@google.com,
	zhangbo56@xiaomi.com,
	zhuhui@kylinos.cn,
	sidchintamaneni@gmail.com,
	"Barry Song (Xiaomi)" <baohua@kernel.org>
Subject: [PATCH v6 14/15] mm/mglru: Make swappiness=1 file reclaim more aggressive
Date: Wed, 11 Nov 2026 04:20:24 +0800
Message-Id: <20261110202025.25736-15-baohua@kernel.org>
X-Mailer: git-send-email 2.39.3 (Apple Git-146)
In-Reply-To: <20261110202025.25736-1-baohua@kernel.org>
References: <20261110202025.25736-1-baohua@kernel.org>
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-18.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,
	SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam09
X-Stat-Signature: fw996pdd59oko6xf4uyepyd594quueib
X-Rspamd-Queue-Id: 291E28000C
X-Rspam-User: 
X-HE-Tag: 1794342108-943344
X-HE-Meta: U2FsdGVkX1+Q9wtpEVeYARa+hug0gTDpcl8I9lUZoFST7Kr0pl5a3ESvOiwtIYopbs+d8eEGDgDjeazMzvOw7ifpEd14zh9ikZRxpbvgQJEo6R+fxCUU/2KKR7nnbVqOP+0iZAHx+kUGgQ/EfYe75JLvNCtCmEYKbHz3wX2eTIWmnZIssHekx/8selxQnr2d65wNgtpCDjQAHXNLyXjRSgE1FGUJ47Mp4ypLAer46e5O+zmNkGzTlc8nQyHFyz5xI5x6CVtFsJWMnUcuy7BqEU7Iepr/kJK8HJTHomqRn7tdlKCP/uRUXfqB99DuH+/+GYfdoliNcqh4xlsIHVsJh8x1M/+4Oq2I5VxP/91T+DYBv5op/Opq81OmS4DRHXzwtCHpUNcGFKTMxSNSCSTXLSZerDLTW/vd3FZxBZQLjBjb5nKiJDVbOM0OiCvhSdtZfo0zzRN48iXmjtHDL0Z/SlBsadtPfA6YpLLzefNm3iZr2SzVoXgO8/qQQHyibwFbTFsklwxeKQ2nMn6BMsSVAuS92FcSxjT6jBLpQz+6AVbnK/A0AP0bmQET/BWVMqi5dTEyl1PlFcDOsykc/RrU5C6MobTHjfMLzZrP0bYDMnMb3ixkHBm0weTQtAb8GUxx+36+vRiYKyxDgGT2Zydsj3Xgxh43HEkerqRZRJy/xXY7GYEEBvGtv23M37gzvzJMD9JRo6n2dAhDgTI6j8SWx9geufRz6ZCl/cBbkY7uop0efq+epW3FQI7hXlWVTBZJp7/hTF7YjKYoKED8rvZbAQHLg+J6OSijo39SDB6Ydna5fI6dc5a/OCgrDnVav9cKQpx4iifH4+4yf+uBTXt0rYFAUkEUbPNbjeDqabmdBhk2IqM6GLLZKKJ3UQz2xwDM9/DIJhWcdS2U+hFpvAfPBktl1bQwGD61sn+MKVuZZKaJTfLnIdtMiacf7w0we8Z88htQvdyHZr4vsCCKpYI
 lnCn2cGU
 pp4G+tvYDqO/to9kLBGPESvMldDpR0keoPD2tShEmWSXau31X8E/TS3FS0rx/igBthp0jr4ZXSfH5DLTguz68tS/tW1o+7JTTO1NKIAHzmX7hbFIt8jVT6XgSW2sKjuaxobtv9C36RyEWQT+uaNnzNPSQ3s2ejdcM/vBFlztUOH5Zi2j5WphwdmtMBImbUgLc4hFyu9/8Uoahmcg0j0sPuAt6BnAkYXREdwtoNUERJ8Yhh2avR+W1OGXEneLOvcGoge0OHy88OQZFFF1bsI6wG4Jt1uvevu2qVC0qW0bqPbEceto1NTkzMalRDQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

In MGLRU, swappiness=200 favors anon reclaim, while swappiness=1
favors file reclaim. Swappiness=0 allows only file reclaim, while
swappiness=201 allows only anon reclaim. Thus, swappiness=1 and
swappiness=200 are counterparts for file and anon reclaim,
respectively.

Before this patchset, get_type_to_scan() always returned
LRU_GEN_ANON for swappiness=200 and LRU_GEN_FILE for swappiness=1.

For swappiness=200, file_factor is set to 0 at higher reclaim
priorities. Similarly, anon_factor is set to 0 for swappiness=1
at higher reclaim priorities, making the two settings behave
similarly, although the thresholds are slightly different.

This allows file pages to be reclaimed more aggressively and
benefits workloads that prioritize file reclaim by using
swappiness=1.

Signed-off-by: Barry Song (Xiaomi) <baohua@kernel.org>
---
 mm/vmscan.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index 5d6fc5d4d761..379339220878 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -4945,7 +4945,11 @@ static void lru_gen_balance_scan(struct lruvec *lruvec, struct scan_control *sc,
 	anon_weight = nr[LRU_GEN_ANON] + nr[LRU_GEN_FILE] / size_bias;
 	file_weight = nr[LRU_GEN_FILE] + nr[LRU_GEN_ANON] / size_bias;
 
-	anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
+	if (swappiness == MIN_SWAPPINESS + 1)
+		anon_factor = sc->priority <= DEF_PRIORITY / 2 ?
+			      refault_rate[LRU_GEN_FILE] * anon_weight : 0;
+	else
+		anon_factor = (u64)swappiness * refault_rate[LRU_GEN_FILE] * anon_weight;
 	if (swappiness == MAX_SWAPPINESS)
 		file_factor = sc->priority < DEF_PRIORITY / 2 ?
 			      refault_rate[LRU_GEN_ANON] * file_weight : 0;
-- 
2.34.1


