Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D7C53E668B6
	for <linux-mm@archiver.kernel.org>; Sat, 20 Dec 2025 15:10:27 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 103886B0088; Sat, 20 Dec 2025 10:10:27 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 087406B0089; Sat, 20 Dec 2025 10:10:27 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id ED4EB6B008A; Sat, 20 Dec 2025 10:10:26 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0011.hostedemail.com [216.40.44.11])
	by kanga.kvack.org (Postfix) with ESMTP id D94826B0088
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 10:10:26 -0500 (EST)
Received: from smtpin19.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay08.hostedemail.com (Postfix) with ESMTP id 84AFE140614
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:10:26 +0000 (UTC)
X-FDA: 84240185652.19.3101977
Received: from mail-wm1-f53.google.com (mail-wm1-f53.google.com [209.85.128.53])
	by imf23.hostedemail.com (Postfix) with ESMTP id C1878140006
	for <linux-mm@kvack.org>; Sat, 20 Dec 2025 15:10:24 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T/WYMZ6F";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766243424; a=rsa-sha256;
	cv=none;
	b=YPemIaf4cUnayMTynu2l1RjnGRbGbD9h3QcwD+PzCAFO5gM4M1GMiC32ZO+WdI+HBABuaC
	8EYJdMNI9idsLc0jX/HYmrzVeBem8k33geSCrbQ2dGVtbfXSPoFLlmxLs2hsoXF4ONPqtA
	4EQweMHXmInyrJ7XJgrIKAiKp1SZfWQ=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="T/WYMZ6F";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf23.hostedemail.com: domain of klourencodev@gmail.com designates 209.85.128.53 as permitted sender) smtp.mailfrom=klourencodev@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766243424;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=4pRFBDVthdqqaxQ2bcD0cfzZVLFsuAZhmcRd/6/xmtg=;
	b=1WeXG8vdr7GH3iDiJr2oyvqk3cHJ2jETOrxZ/fyFRuRVxqUT6qVrJsiVwY2XXJdrHgWMe6
	4ArNHhxnWsgAczSDEi1F1OIFKAcG00jDjt/eeCoBWFGyxo6NCP8y5WXLrHlcD0LfUzVMFU
	dK3L/qHhAUXXjVEewQjurlcHlOIczuk=
Received: by mail-wm1-f53.google.com with SMTP id 5b1f17b1804b1-477b198f4bcso18008815e9.3
        for <linux-mm@kvack.org>; Sat, 20 Dec 2025 07:10:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766243423; x=1766848223; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=4pRFBDVthdqqaxQ2bcD0cfzZVLFsuAZhmcRd/6/xmtg=;
        b=T/WYMZ6Fuc3i92onQ7AjHHkVyYFe12lb42hq7D2VpUJHCHkGgBty42PtqUnfWD+V0/
         sTvlYdZOinZK48+BrXBQ5Gf7aFYdQwJ0s60OqD/N24A8ypRXNT0VSb4tJoh/hFJsoRc5
         XmRRLsCg/PoP/0kCZfv8PJmxAFGNiUv3vxK4VL0Prt4V8/+cBpC0wtSKTcVohaKHkgWK
         ElhSuVrImVGSIHiHXLlC2BuiAj5EMtutyguP8RFTJdKOx2yDGr6a+y6PvfjelH+7i3Mw
         XuKUH/cM5SXMEu6BWgTO9GDsUQGVOl+pE4z9Azd/qZtLea+9r1+u3BvCdbjAx6g8rhvU
         FW7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766243423; x=1766848223;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4pRFBDVthdqqaxQ2bcD0cfzZVLFsuAZhmcRd/6/xmtg=;
        b=vVkaBV1KIUk6/gIgAujDOSgbH2oCqMmgO2fi5JQk/qV8OnN34EfH/3z8QdPTCaHzdz
         U6OfxWl4YkRUMMfUhbzZs6yyxSBHjCWWHVYwkLB9Ph+jZR1OYCFp4+jV8kb29zMp3Ku5
         NZFdmKVZ/pkF9pPBlWY2/gU/ET+djCDbzOdbH6fSZRFwjFSQY2DFul7qGz8x/tRJwzxR
         nFvv5LMdxTb9On1fLQZXrSHakmq7m7lvqJyPtcBQSCUot5Vz89KLIBSij9dnUt/y/pW8
         XRz9AbOf8GNVlmUuDi1lGOwyEOv5P1bQXdVJMQYiWek3DkG1vyIiq5ljUUWYBZqk/Q9p
         Wpmg==
X-Gm-Message-State: AOJu0YzES35uDPlGIjLiaEeqmL/Ebxpww32OpIngEXLtyruAEjgPTN7t
	iASpkfCdSIJNRbElPk+YwFWj3zO5Jr6SPC6sbxnUXvzjxkmsKBYzFWfa3U7rmQ==
X-Gm-Gg: AY/fxX5DX8UzXIb7xKcIArGtLCyzMKrnDSLTnzqk8BsBAvzjeQS0mYgW2Sq/Sf+AtDC
	HUlrEa9HpYih/GiysAvjIFKMfXzBdaqDQNopIyQ5v+cz2TkGzVqVXeZBjr/GQFLA9uyUt4ivhM5
	ZsojKgTY1mkoGlH8XcUtc74lgw+S20Vw03jv3vhTnyfxLvK3Eclr32F5zOIZlRivhTcl4fHcRaf
	pCSxjhtxsX9vcAXynJ0aclehuT/xR9lvFAhRzNtEFIDGLOS+p5Njge60qj6GpRUGaC1Vv4VPdzB
	HpJRbrSN3myW22Bk9Eeu9wpwnAkP6+1EwhMMhm6FGWL758r0UH40EWWcna4xOTaUSJf1ruTRofe
	zw/hkq37b0rU2ZNdxcmXeh4+jKgg3PjYKJOdkgO4hE6q6bEGSy3TREdbC6NVa5psqbLuVC5H6+C
	d63k857chJQQMs6IVg3qhv/VtU4msJLap9YfdxaJHo8CuCnrBWUtbguIbeU6eDJfrJK6f1bkVwu
	IyxQnj4tdcnyGyXLw==
X-Google-Smtp-Source: AGHT+IFyonXEOs7iSrYuyCY/eJq3lys1NL/18EPNFRtSP71UNnfd6pdmwLwXoKaKQuDlp08wcDd19A==
X-Received: by 2002:a05:600c:c086:b0:47b:e0ff:60f9 with SMTP id 5b1f17b1804b1-47d19577114mr45324505e9.20.1766243422826;
        Sat, 20 Dec 2025 07:10:22 -0800 (PST)
Received: from desktop-mu90jgd.home (2a01cb0006769b001185461c960a9b50.ipv6.abo.wanadoo.fr. [2a01:cb00:676:9b00:1185:461c:960a:9b50])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-47d19352306sm93891405e9.5.2025.12.20.07.10.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 20 Dec 2025 07:10:22 -0800 (PST)
From: klourencodev@gmail.com
To: linux-mm@kvack.org
Cc: rppt@kernel.org,
	Kevin Lourenco <klourencodev@gmail.com>
Subject: [PATCH] mm/memtest: prevent arithmetic underflow in end pointer calculation
Date: Sat, 20 Dec 2025 16:10:19 +0100
Message-ID: <20251220151019.19473-1-klourencodev@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Queue-Id: C1878140006
X-Rspamd-Server: rspam10
X-Stat-Signature: ez5swokhe1tx1yqabdfpktk3a5uubm87
X-HE-Tag: 1766243424-487907
X-HE-Meta: U2FsdGVkX1/AiH2ePv9vyTY53eTF/FBMA7Rim2tYuG50Jtsw2N0nsm6TpTMUk+CHmzvycZWYPw4uxLM9KszvxcPBLKPc5YEQZEW+Msq84yPMf/dz2JTuvWDuRFREQ2THBny7InmeEjo9nn0xllBUcRsLtotpIOh0qbGP5Ap+yPUXEJSM8ghheqAKd49KcoPaS+zJ4B5qv+kr0p9NCUmZBTiAAAGiFNBqWzjIOZfZ7H32803CKovOz+89w6U5TqzKFRW9TCMLy0mKh+VKpSmOHecCrSnJMczKgK6WbMjRvHTgqcwJSjucBMn473B/tlCU6iYh0zbwJ8aSk4q82lX83NSbSZZ5L9kv9RTefAeztJfzaOYK6oWulC0n4Z7NGoFOe3WPN77y/nWe6pwWeiq73D1hftmNpzr0/rxt3eNsFgRRfTqILB3jo33UQoC1Sk1ocOBLRw9K9DSZJUUGeMqxHGMZIGnxlV3GLC7W67UH9hH4A7FKc3XhsTmJpivjZiMmdvcPnke82p0VEdFnUHAwveuAqsRiwYu6kvlbyQIfYw0pTSZYYft9Ir5YKiBLpbuuPF/gqmLr1yyeLECgvcziqjAVKyBhhyfVh/YBU6tErqShSLwIPP6ziAThvomJAsmeQ1RgPHItIl7gKX3Z/CqbGSguiL9/93BAzHoUlIyRFPNV5+qhZxkA6jbioInRj2Gn0qCvyZi+3MndEkAJ0xoMzGaT3D1cWoGg3TvvCwtvlUS/Ru1FkaAYlZs1rOD174DWe6I3JIcX0Nvoi5rzanSjJ53Kmbhp7pblRNMcujcbj/UoJqHI4Q4dnEYbqNRO52VJUNOHWQ+sf6uSUwSNtDqBilgmruyQVj0cZ/pvW1iywoQMC/5Qwn1NFfV6z1pDxhMhjbCeRfvT30iPDBVZtAIxkgxzm+OvSyy37iQo33HLXef9QgilzFRFhBZcw8nEMQ04Nc5kCDieINK7ZDbdHOe
 ocI6tZtL
 Ly+hTE1OEJs/6C/ulm4UFOO+772UsXF9cuF1kfxffvrvyj0q93O+0GBd4flg0QkFiyulcax2/p2RO7LGi9Y0rE4Ai+LVtvdCly6Rn/L4yBjQR+xmQc2XdJiFBnMEs+x3+uDQtIaMYQDySRuU/xY7OBz3dPz0jeFjO4nXbYjIO7dgdPsoj3fISILanbNtNFVsETPYvCTvyx6WuOn6lbCGWHGcGPloVOpFhQZFThtk+Ix6GkCCQDJrN+AF5LPxYNHlRWG44Di8HuBK61vGIexID/f1pJ2NKGXVHn5qMPND6mQH2Qm1IB2UNxGVbbErVqa4x2PiH9OEUe0lgNnduo5CQHtdy053ch/iCuqKPq75hZYNdaVLUHGRuuZ3N2xZLiBfZaoykWfco3sqbrAGJOuzYYpldL+rGXDQeLAJy
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000000, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

From: Kevin Lourenco <klourencodev@gmail.com>

The computation of the loop end pointer can underflow when size is
smaller than the alignment offset:

    (size - (start_phys_aligned - start_phys))

If size < offset, the unsigned subtraction wraps to ~0, causing a
massive loop iteration that writes far beyond the intended region,
leading to memory corruption during early boot.

While unlikely in practice (memblock regions are typically KB/MB), cost is negligible
(one comparison), but it prevents catastrophic memory corruption in
edge cases.

Signed-off-by: Kevin Lourenco <klourencodev@gmail.com>
---
 mm/memtest.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memtest.c b/mm/memtest.c
index c2c609c39119..d86c41f1c189 100644
--- a/mm/memtest.c
+++ b/mm/memtest.c
@@ -41,12 +41,17 @@ static void __init memtest(u64 pattern, phys_addr_t start_phys, phys_addr_t size
 {
 	u64 *p, *start, *end;
 	phys_addr_t start_bad, last_bad;
-	phys_addr_t start_phys_aligned;
+	phys_addr_t start_phys_aligned, offset;
 	const size_t incr = sizeof(pattern);
 
 	start_phys_aligned = ALIGN(start_phys, incr);
 	start = __va(start_phys_aligned);
-	end = start + (size - (start_phys_aligned - start_phys)) / incr;
+	
+	offset = start_phys_aligned - start_phys;
+	if (size < offset)
+		return;
+
+	end = start + (size - offset) / incr;
 	start_bad = 0;
 	last_bad = 0;
 
-- 
2.47.3


