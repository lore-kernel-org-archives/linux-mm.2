Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8E774606A332
	for <linux-mm@archiver.kernel.org>; Sat, 14 Nov 2026 13:27:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=fJ8vpr+f
Received: by kanga.kvack.org (Postfix)
	id AE5C36B05B4; Sat, 14 Nov 2026 08:27:09 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id A96306B05B6; Sat, 14 Nov 2026 08:27:09 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 985926B05CB; Sat, 14 Nov 2026 08:27:09 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0010.hostedemail.com [216.40.44.10])
	by kanga.kvack.org (Postfix) with ESMTP id 702FB6B05B4
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 08:27:09 -0500 (EST)
Received: from smtpin15.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay10.hostedemail.com (Postfix) with ESMTP id DFB19C0404
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:27:08 +0000 (UTC)
X-FDA: 85433800536.15.90E5B41
Received: from mail-dl1-f53.google.com (mail-dl1-f53.google.com [74.125.82.53])
	by imf18.hostedemail.com (Postfix) with ESMTP id 379361C0008
	for <linux-mm@kvack.org>; Sat, 14 Nov 2026 13:27:07 +0000 (UTC)
Authentication-Results: imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fJ8vpr+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794662827;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=dgWMrdUfwgyu69vi+KlSZuYmoLLvzewc0VtmNAhXsrU=;
	b=lXBWXAAaQy75UZyIDsDNWrtJohlHO1oJZcq6rAr99VeEdN1r5vMdyaFvmCDsQMB2kLH6hX
	6UI/wbKqup21XfFhiDGQ5vmV6bST1U5K5dk7Bjm2Pn8j83XpBZHV/2r19QiTwlSowISaC/
	6DPM85aiBlV0t+z3t9Ru/DGZR4fGvJ0=
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794662827;
	b=uefl9W2bfFl7AiXdfmXjNJHy0RB+ehwV5vOlWclwJ3fwWzsNWkoN+/6/StzaHv+ji48mME
	YLxOK5ebdFuDdj1PqOTd7yuyI9KIOMyWV9mYv6epsQ0DrDGgSnTtnTPcjTIP3x7tKcudFA
	pDPQvdZP86/XiFtnas/gS5Jh+qRFS1E=
ARC-Authentication-Results: i=1;
	imf18.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b=fJ8vpr+f;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf18.hostedemail.com: domain of ekffu200098@gmail.com designates 74.125.82.53 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com
Received: by mail-dl1-f53.google.com with SMTP id a92af1059eb24-1b3beeaf6f9so2131246c88.0
        for <linux-mm@kvack.org>; Sat, 14 Nov 2026 05:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794662826; x=1795267626; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dgWMrdUfwgyu69vi+KlSZuYmoLLvzewc0VtmNAhXsrU=;
        b=fJ8vpr+fRBdVwmz7cl2zC7CAHLdBbwi1oejIMTxWB8iA4//EuuQ9sMjEJ4KQZ03UOo
         sdIyeGRGQXllEPnkwzUhz3EHCG/2qEyIjEEWvi4DExFjzZlK4xl0tGG9OcIPzDCD6GQJ
         uU3d9b9SpgvEqAVod6D6nO06nnN1BOM2lTFiu5zQxePANY0sh27V1aqjI8d1WhPLxoxF
         RQm3h+UoDNBSJqWpB4HYlM+N6VxWsp2J58Dxt4RMdE+a6loifVHu76QJ3bU6S63SWbh2
         zZe3KDvUgEhb9U8S7cT6EjkTOtA+2bIMzGal/Vz9JAu73+QvS3jOfFZrM4voZENWo+gP
         Bp/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794662826; x=1795267626;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dgWMrdUfwgyu69vi+KlSZuYmoLLvzewc0VtmNAhXsrU=;
        b=rrCqzy4F9Re+DoduV3U0t7DzjN/qhTdcqhJ3+psjhUhjBzWNjUTm6JE+wEseNwee0H
         FAfHRBDEw9+twP8HO0nM7twLNReKuiyUTr8n0q3vF+iPjNhfwrA+8l32JLoVKmsSrZeW
         j+PJ0JZ8NNWoLICsh3a0cDWrw+mCpqoT2hTW+Ou4brAgQRBx5HvgwaOoCC8LCQcbTttm
         Dkdb70PdHlAXUhwPG35JlxgjtWVvM9svQJRNlVZQ18YCP2pq8sCGLJOUx0w8cWmOMfhc
         GYy0VV7z0H8inDtusaJnpH6ffXeK4HIXtFKmiG3SsfrvVVCgJYyKJMfLH1WRW50v5IHX
         ghCQ==
X-Forwarded-Encrypted: i=1; AL+hErEv8/dffEHwQD7MU7vMklwe1DxGPcgQqPYUFHC6yTejZRD0zoLjnP9FgLXaPuQ3mjdOZj/qlu+79g==@kvack.org
X-Gm-Message-State: APuU4Z+LwLEj918yvPKEyH+mOrZzu0/Oat7HgXtiAp9Wm4f97YK1NIje
	73mySXHACdgIMwRhE3hf1VzDyeNo5hvMewuGjwnAc3LkeW+IhX9YHJiX
X-Gm-Gg: AYBFou14QPltHo3ZJYxHnkKn/wI7Rx20ypHREI1v2EU3WbDLChg9b1Jlb47WIgvBCZc
	lgkDML0l6sZdJ880mglflZQ5wUKh2GpAspSixNUNC669dBs1lX1iKoS6KWISG8J8TySSkqV2pFh
	8U2SMTXMmT/BQhrDhLqORIyCgOUbRDAwc1xKjp4bofoajDGxJmllr2WFwwThVxPA/kul86WYf9F
	TABUpHUt+q9DgwExIMoZEMbJHXulnQshd6Og6uE9IYbE+Se2q+FK4KjcshI87GoXLZ3/8moiYeB
	P5ba4Bxl02O+UGBDHjZWN8eiQxZ6QD8Ryp1/tnD1fYoc7vB463miv/wvs0RuycbuU4/nCGOfayx
	1o9/7Y08J4e1fEklH3ND8ok85DuOdvwSopkTh3ArcdPjR1hKi8AkUbHy9UD9OxAxAIbw0efunn/
	pepgaBdVN2NT9+rWBm5zTerH3nz6n5N4sqB99wK6uu1oJAFJ9Zy83ib5qE6d6+bHzW8sngWDeDJ
	niJG72vV8fparlphbb/l3krcND3zWFZT9JXsuQN4Z0oyB11ORS1EUuSO5h/XZlfwMvNf1SJYp9S
	YSd4NYCRyHEaeHbcwN8kJMbTbYW0ygepd0+wHgT+F5MfLrIvcVDl
X-Received: by 2002:a05:7022:170a:b0:1b2:366a:e7d1 with SMTP id a92af1059eb24-1b50312efa8mr4720603c88.32.1794662825563;
        Sat, 14 Nov 2026 05:27:05 -0800 (PST)
Received: from ubuntu ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-1b5031b98e5sm16965327c88.14.2026.11.14.05.27.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 Nov 2026 05:27:04 -0800 (PST)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>,
	Mike Rapoport <rppt@kernel.org>
Cc: Bruno Faccini <bfaccini@nvidia.com>,
	linux-mm@kvack.org
Subject: [PATCH] arch_numa: fix broken NUMA emulation with dummy_numa_init()
Date: Sat, 14 Nov 2026 22:26:24 +0900
Message-ID: <20261114132625.1710476-1-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.53.0
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: 1wsbg58u9ehbgsheunc3wmp66w7fwu4d
X-Rspam-User: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,USER_AGENT_GIT autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 379361C0008
X-HE-Tag: 1794662827-579934
X-HE-Meta: U2FsdGVkX19I504HvKPgMYflBdFkU18KyNc3lAPxzK/2HydF+qI9jwYBthSgm8gMSpXeItO8CiiNLGb1ZTwvuV5NS5l6Sgw1rrLESsI6vwQK3JVcjxsaWqQSal66btFO+u0nYYYfVxt0wyuuI2SvsStmPNFSpwx4GNiHCIhnZ46WDCmjmfTPIeeBTcHDTbRWBt0QaSPXaJknX5fd7Mr3d/cEoYGLJ4+Fn2TzUVBmMuS3unhOuc53Et6wCLCCbNJ6TebAwgjbEFbbArDrY+a4Jtbl1CMtSrcb6s1BZhEYFJ8nLjv1tUdfCebrIfUs2ahGgEfDTEp83WASaa0/aFy37tymPnvfYQ4v8vRk8+CmJwzcFcErkiCIZzfbEuAiT0r4LgKh7B47EPKImvwQOpzIiuKtOY5IUfzkI2pCHv3r2sZ/2UVp1rRoiA3j3etq719CT+VvVBabKFvSELmt4ejicptMuflpsR/NXi9hVmwUZLv1BrdvJtmFB6V57ja0fUaZvPkOUqJHORsoHBX+WGjKMt3gfXSmvqQGakwk5vFgag7ZExAQ+Ko8eN4xrhpBJDlCDZzTKE0ZR65bGobynRAxmFWXVsfFWvrlokT4YM6TK0BPC+s8jEP9p+LMP2G2rY/SlWecrHLq1SuSNLDGSLFgXGjmp2IH3bM0eUP7cSIsr/4WbZoFMmw/0FnqhCf2UpSngQ46/ovr3DxcoEI3s1IzNVuqi2WE3Dn6atNZdhDnJGIhA39pmb6so+XHgrq5ZNBr60wrWKEWYtTxWAyOAB2X+VWtDfC3JQ+003IxFPZhTbqgn0EIRthjkH9uA9U/kcfEcZRV72l+OMogI785cfE3KLg2VoXqkMKhgVLyTcoU+LIeOUhWgpSudCapIstkBFuV8hUztxh81Io8oyn1JvlpkA2oOR5mtlQLaEzOl0y8wsw7WndYVKv68HnKlzK+3c27SZpbs3HthVN7T6lsR0q
 T7JdtfUv
 D0vmrR0sBT/ApJktkQ5nv3v0bFMLLeW7YhM8hKNU3Rh+t37JfAt6XsNQS+NsfOgeveVF1XV455MAEijnLvOTiu/9OnhsfDaGVuu0hMf46+qcAnocCkVia51Vepou2dAAeN/1X4d77TYPFA3FH+7Y7mjQbfWM5fvFGhGRdOFrYwqdsm6l9eXslAg/4klgtpbiK7KG8QQRLtN8mF8NYdDdjfhWntDdacK4ej/wv9YyQKQ2egcms/3rvVcvXy+ud4qjfAdUv0AD3cFJUURP4z4ZCBAsAhoFumGyX34fXATMXzCrqReNjXuVcSDpkVjmO9mFWYCmcr4sahwcpN7gqfB8AjMpmMG4kcCQ1Pdy8+TbrWTAnKvoeDWu4uz04DDbVzf8lCsmNscs1PXF6kIEmYam2cKjQoDz02v3RVvoz/QaN6LdnDlhk1x4bj+4kDiLlMRVgLp/vfDX7PChIDMs=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

If arch_numa_init() falls back to dummy_numa_init(), numa_off is set
to true before numa_emulation() runs. Then numa_emulation() calls
fix_pxm_node_maps(), which fails when CONFIG_ACPI_NUMA is enabled and
numa_off is true, so numa=fake is ignored in that case.

So set numa_off in arch_numa_init() after numa_emulation() runs
instead.

Fixes: 63db8170bf34 ("mm/fake-numa: allow later numa node hotplug")
Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
---
 mm/arch_numa.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/arch_numa.c b/mm/arch_numa.c
index 940e6d5f0023..5742ca7d98be 100644
--- a/mm/arch_numa.c
+++ b/mm/arch_numa.c
@@ -265,7 +265,6 @@ static int __init dummy_numa_init(void)
 		return ret;
 	}
 
-	numa_off = true;
 	return 0;
 }
 
@@ -305,6 +304,7 @@ void __init arch_numa_init(void)
 	}
 
 	numa_init(dummy_numa_init);
+	numa_off = true;
 }
 
 #ifdef CONFIG_NUMA_EMU

base-commit: d9a27fa1050902a6e38bdb780b0277cbf1dfa5a5
-- 
2.53.0


