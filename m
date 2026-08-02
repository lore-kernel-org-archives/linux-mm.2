Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 35798C55171
	for <linux-mm@archiver.kernel.org>; Sun,  2 Aug 2026 16:27:19 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id EAB056B00A2; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id E5C176B00A4; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id D71636B00A3; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id B1E086B00A1
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 12:26:46 -0400 (EDT)
Received: from smtpin02.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id 11F11804BE
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:46 +0000 (UTC)
X-FDA: 85056858012.02.0F26C74
Received: from sea.source.kernel.org (sea.source.kernel.org [172.234.252.31])
	by imf23.hostedemail.com (Postfix) with ESMTP id 712D814000F
	for <linux-mm@kvack.org>; Sun,  2 Aug 2026 16:26:44 +0000 (UTC)
Authentication-Results: imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofUbJFVR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785688004;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=FjpIc++QZPjZOYYyTcv8UZquOm4P+vQqtVegyQJWS98=;
	b=kHqddmFYVFD8Md3oD9YVmaK2Xk/CsFcZb4U0fOYODspDnKDlcW6YrX+DNI6J7djhoxt/e9
	Wu+TZlzCUfUtDrY7ANWD8dQtAYG0TVDZj4H3ghR/vYCSQLAaObl6oixBEqzjKcuyjUm8gD
	gsXsL0/Hh4bnV0GatqUGR9qaQi3ja+Y=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785688004;
	b=sJl7BDbQ3gFVHVLZz6E5SV9gzJYJpimGg33F5ODMm868SgNo/YBor1T7t1OLzEM0LENzpZ
	2SOVdGlR1Q7elOhSiuvDytlp9xwESUzziYYb1flDJklDc24iWceaVGZvDLaOHAZ2appVj9
	3pFamLl6Wb92rCwFMSptAGJ6PuCH+2I=
ARC-Authentication-Results: i=1;
	imf23.hostedemail.com;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=ofUbJFVR;
	spf=pass (imf23.hostedemail.com: domain of sj@kernel.org designates 172.234.252.31 as permitted sender) smtp.mailfrom=sj@kernel.org;
	dmarc=pass (policy=quarantine) header.from=kernel.org
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	by sea.source.kernel.org (Postfix) with ESMTP id A70F243FD8;
	Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E2AB1F00AC4;
	Sun,  2 Aug 2026 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785688003;
	bh=FjpIc++QZPjZOYYyTcv8UZquOm4P+vQqtVegyQJWS98=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ofUbJFVR7en0yO0u2gPuMSNQGF9LpRv6jXSWh8QWsDr0ac+40r0HMmVvt7WTuctK1
	 KQLtO97awGBVMnLh4R8Vqj+ZtTKLPAVpJXiGf5mLcmpdIqLCCAThLDY1lhwcaBm0cs
	 VW1NZJPqcEPC/AxOP1D/ukzLmOuZZQ6Ka0krAe4nah7mQm8hSpJtEmUMOyJnWHlyzW
	 5/sb1DYCZq8M60TAb7NKEFbgs1zJ30rqFC0apy1d3FYlAOr6nooymr0K0QaDyqGB+g
	 mx/1InCGj+lfKu+6C4CK9X2mqg3dDC3AR1olcCKFxgT+N8+TTvMDDxtLlzF30mykpc
	 WymgJ8KHGWQLQ==
From: SJ Park <sj@kernel.org>
To: 
Cc: SJ Park <sj@kernel.org>,
	stable@vger.kernel.org,
	Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-kernel@vger.kernel.org,
	linux-mm@kvack.org
Subject: [RFC PATCH v1.1 9/9] mm/damon/core: handle extreme memory state in get_in_active_mem_bp()
Date: Sun,  2 Aug 2026 09:26:30 -0700
Message-ID: <20260802162631.90304-10-sj@kernel.org>
X-Mailer: git-send-email 2.47.3
In-Reply-To: <20260802162631.90304-1-sj@kernel.org>
References: <20260802162631.90304-1-sj@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Queue-Id: 712D814000F
X-Stat-Signature: kpzp41kp59g3ofcq1u73nqrxgirkx9ra
X-Rspam-User: 
X-Rspamd-Server: rspam02
X-HE-Tag: 1785688004-971433
X-HE-Meta: U2FsdGVkX19DLGBwwiz5o4RRiEpY8VQ/Pu+khGvtzUc7xJJ/077HxoS+Wio/TJKtAJF4a8c/7WXdFJkcGPDowoLacOufGHS/vsbB+lVMuqXYKC5dl3xuCHBg/Nxun0gl2meT3KhB7BP/rvj/9ELlB3pXZ5KKI3aEFYhOWXrbmtb4uD1lSXXLOg2PyklKub/Hlzi21KZW55Hxlrw306/EBYaWXwWB6dGj9BGCFNEKlnmBTjToDJO06WVLzx3ihesBDMoikDlPmmMWRN36rFUp7/5PX+coLPiqsKzkXMo9A72LjqZVlKOsfxG5Ia9wMcHv7EACgjzqEo2+Cx4Y7nfcLjc5mg6tJcg+YiDVpFymnfHwqOA6WINmKT80bzLr92VGRr+NDpKOZK6ZU7vPFugIqQviKL2UUR0nvIKdYi67pSFY3x9KxIAFSVD0czE3gPAOkSnQbgAI4+YmQTPprKkiQlbns12+yyNVEKORwsQT6YzMdPCX/WHFDXR7L4by1I+oNAjZa+UoKNGVtZTuKqrmMpu7Mr1IsZzng4rJewhlihcdiFHxBvfophC2dhm+12uvQYBSQ7+dPNFxOhPmmgbdh1E+VYU8iJ4wOENuxicUZraW7O0wZCLCrBcDKJn0WgqLumCrjerbJmYXjpZrgJFh9dWa7GRQQQAeuli/RsiwlUSwvMnD8wCAmBvimSpA6AR/1eQDY1x2wZHegFjgdRGulMp/I1HSig+Lde2f6jh/odUYoAW1UgBXeFcXO41bzOI2ncjVhGtLR8+xkJ9ruwx03OtQOYj19bg49AoT01UNDj9v9T0jiyavd6jKc6yIR9ZDEUXTeg/xctO3vHWl/mD3Od2nv5EZ3Cibj+p0EFYv8AQq4UucgYG6JfagV8na3TqZOjkL1j9KkfsLgiu2l2PzkolJ/SttqiyNa4a8v2eXrU530r3cLBHYA7nVbtYtGonz/Ym+yKGfReqhH2hp6dR
 YcZruZGx
 S/AI1pph1T/rnNE8wzXsxp/lxriKrT3gVozpRKdVMnHJshvTJraG5bT6HASAurCIEVfTgARzqMvZq30oMsZR9maeZf5XKNsAnBHYOBYQeTO/jAX7/jl79gK0Fo9Nb8TOHSi6iE5QvgefDndAzF7xdjA+tNeNsx3wq+7pw3LbUo95DKGofLMLCp5hnVz/vbEIuAbYeExC3Kpgh6hX1V4J5AcnYYToAm44PaQfpyTsZYBVUzxMMx+U9m0vIocD/sc2mO1dPjmVTvs30ZiD/9C44NaZK7A==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

damos_get_in_active_mem_bp() uses the sum of the active and inactive
memory amount as a denominator.  In an extreme and unlikely environment,
active and inactive memory might be zero.  In this case, hence, it
results in a divide by zero problem.  Avoid it by changing the
denominator to one if it is zero, before it is being used.

The issue was discovered [1] by Sashiko.

[1] https://lore.kernel.org/20260721034756.147011-1-sj@kernel.org

Fixes: 4835e2871321 ("mm/damon/core: introduce [in]active memory ratio damos quota goal metric")
Cc: <stable@vger.kernel.org> # 7.0.x
Signed-off-by: SJ Park <sj@kernel.org>
---
 mm/damon/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/damon/core.c b/mm/damon/core.c
index 67ad1f07c29a4..c79b854e1a971 100644
--- a/mm/damon/core.c
+++ b/mm/damon/core.c
@@ -3014,7 +3014,7 @@ static unsigned int damos_get_in_active_mem_bp(bool active_ratio)
 		global_node_page_state(NR_LRU_BASE + LRU_ACTIVE_FILE);
 	inactive = global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_ANON) +
 		global_node_page_state(NR_LRU_BASE + LRU_INACTIVE_FILE);
-	total = active + inactive;
+	total = max(active + inactive, 1);
 	if (active_ratio)
 		return mult_frac(active, 10000, total);
 	return mult_frac(inactive, 10000, total);
-- 
2.47.3

