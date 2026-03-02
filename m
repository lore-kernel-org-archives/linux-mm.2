Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id F3799E9B365
	for <linux-mm@archiver.kernel.org>; Mon,  2 Mar 2026 11:47:47 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 0DCB76B0005; Mon,  2 Mar 2026 06:47:47 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 08ABD6B0089; Mon,  2 Mar 2026 06:47:47 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id EAE506B008A; Mon,  2 Mar 2026 06:47:46 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id D92E66B0005
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 06:47:46 -0500 (EST)
Received: from smtpin24.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id 84E6A1CEAB
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:47:46 +0000 (UTC)
X-FDA: 84500948532.24.186CB98
Received: from mail-lj1-f175.google.com (mail-lj1-f175.google.com [209.85.208.175])
	by imf01.hostedemail.com (Postfix) with ESMTP id BE74440002
	for <linux-mm@kvack.org>; Mon,  2 Mar 2026 11:47:44 +0000 (UTC)
Authentication-Results: imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K3e5CVjd;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1772452064;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:references:dkim-signature;
	bh=RRCdKKvPiApTBPbA+MVq+nK6IvIHTol2lBtHSKLnd6s=;
	b=5y2PI3EwRLEBG/l4JV34QBY5qwtcfY1cCcgiUr3FiuhXHEyk2f7iFjY9f1YDAP4NFHCTF7
	99fDrZy8YvxjZG0quxUK6HKZ0GBaMcIta0nZi/U1W/CdAQHu8HF6wV4/puiWN+6JjF/Lcv
	eCUThZqDj13cEGX4UvY7hkUs2psHIWA=
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1772452064; a=rsa-sha256;
	cv=none;
	b=4a6oZZQFgEbtrvAJcDMjqq9Aim/urOKvLQWmP5HKeiZOKGaeqnZilg5tYWGzYyNQM1f6Us
	yrdbMkyRDZMsMoA/sJUlQsrR0zNt5kdoHEPMBKLBxSGzLfkikikADNGMoNEisqTsDc3j/u
	ayvOie5uTvigE545znFi+UErRArEwKM=
ARC-Authentication-Results: i=1;
	imf01.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b=K3e5CVjd;
	spf=pass (imf01.hostedemail.com: domain of urezki@gmail.com designates 209.85.208.175 as permitted sender) smtp.mailfrom=urezki@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-lj1-f175.google.com with SMTP id 38308e7fff4ca-38709888abeso2736531fa.1
        for <linux-mm@kvack.org>; Mon, 02 Mar 2026 03:47:44 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1772452063; x=1773056863; darn=kvack.org;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=RRCdKKvPiApTBPbA+MVq+nK6IvIHTol2lBtHSKLnd6s=;
        b=K3e5CVjdYckf4305aUCBlnZ1IXWv5i/QD2tgMI7ueu+KJTR0qKRoaTl6ipk60/6/sD
         CSGMf9htz9j+pLw0hRISzlCcbH8OW6zckPsmeVUnHObvlt8JEMNljWZcz9dnMmy1Vyzf
         urTKwM3BncL6ntljq5oFVbRalwaxLTDoBTRK3z0Md1iLxHNdTZd04DUiBQht4a3qKyha
         zCiO5QVWmAYHzW37Krjc2pU96U3lzePaRcHddUqDspTK1GyoJ/9SuAgcVemUPB3MbIRV
         NYdlNrOs5W+pe3rrxnmK+2L7EaytpMZZwoa9auc7Q3NKfo0eY+G4M9xrbu7MFU2sXUfb
         Qkwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772452063; x=1773056863;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RRCdKKvPiApTBPbA+MVq+nK6IvIHTol2lBtHSKLnd6s=;
        b=NHfIzGI8QJ3hQvw9MeJwzICiAnZd9opBQWDEAtZjiV0X1onGNVyHVqRLrPHhka3smB
         gKAKj/Rw2Pf3odUzjzgSbR97xCV/lVk7S8AzISQ2D6GELDiSfsOUARnZ9BEFxbJdzHtL
         x69rl7CQEuQK4ex+ENqZov5iNOU8984pBpnm2CAtxGYdtU5XT+pvVLZ9Yk2mQctZYYc1
         QynYn5TB0FLqBzU2c140DH30PMKYNmkoMGPegimE0HOQofgugUabbJFJksue9+WGyJn5
         5hJLVEGQGmzaGFIONxrZGAdox29L94saq4CqPTUJyb0PeaX8/zLlTFDvm4su/8Qzo5Ek
         +f3w==
X-Gm-Message-State: AOJu0Yw0ccZ93EPQPLIRxK/7iET670X31P7DmqDUNtvQFiCXKcKs8gmn
	PMdQUrlD2J+lmO0DtQ3bIfFxVt67+/0IZuq+z7Ir1yXTaykZe6F4j6EWOaXUcNiX
X-Gm-Gg: ATEYQzzgvsTlCdPbSRD1slPevjDwgyrFAfxrDB+QuKBSXb2WSwQM1/ZPRptexoUuqFE
	vOcNgr8qKgutRvDVjLkZ1I0S/oKZVKSJKBAy3AYKZg9OtYSfR1OldrWBVARKUW6tp6LGt4eClWJ
	MUQT3o9o7el+tWd9NM+q5JtyY60cYmg4C73ppMpn0p2NVozLUkBEDk16hUs+0bCQAoo3mffPUst
	VkCI6PquTZc/59aqGm3HH8sZHXkIEa5YkqjsFtYjLzVnsu9MS2t5lQpsrPk9k5Siq8zMuN/O0bd
	Yf5DAe9ESONVjaBXTEamHomp3+0dPuau/fHwwsmGcFjH87WXwr9XSgpPGjLW6zICU8q08nGcA95
	c8LklfmiXMrw6zq55midyvhIjeBmbeKKxXYIcjfnrqqBdXqdh6+R+m85978W864R2Xa0thQlEUB
	bPiYMk+XsryyTLt+4=
X-Received: by 2002:a05:651c:3044:b0:380:989:f615 with SMTP id 38308e7fff4ca-389ff116d7emr69597401fa.6.1772452062501;
        Mon, 02 Mar 2026 03:47:42 -0800 (PST)
Received: from localhost.localdomain ([2001:9b1:d5a0:a500::24b])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5a115bca02asm1603412e87.25.2026.03.02.03.47.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Mar 2026 03:47:42 -0800 (PST)
From: "Uladzislau Rezki (Sony)" <urezki@gmail.com>
To: linux-mm@kvack.org,
	Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.com>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Vishal Moola <vishal.moola@gmail.com>,
	Baoquan He <bhe@redhat.com>,
	LKML <linux-kernel@vger.kernel.org>,
	Uladzislau Rezki <urezki@gmail.com>
Subject: [PATCH] mm/vmalloc: Fix incorrect size reporting on allocation failure
Date: Mon,  2 Mar 2026 12:47:39 +0100
Message-ID: <20260302114740.2668450-1-urezki@gmail.com>
X-Mailer: git-send-email 2.47.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Stat-Signature: dcrk8er36go5oh44h9y1x7xei78y5sb7
X-Rspam-User: 
X-Rspamd-Queue-Id: BE74440002
X-Rspamd-Server: rspam12
X-HE-Tag: 1772452064-50472
X-HE-Meta: U2FsdGVkX18O0+O2ZD5cAoe00IPlCJlR4W+LAMP3mE6ZLbNnNZZ4NHbgwgepCe5y2/Vd6L5whgxbluBNth9ejYsS+u6znLz0Sw3XJG9e2SvJ076vCHX96XtkIMv2R+xnRmlByW/xCUjgx/VtzkjXr34qSaO56T3GmMg/Qp1rYhoKSuX9azjm6j6b6Ln3H5t4m1BAwBpfB2+BTSPQg5/iC1jak26FaSKJ+gJjGjXjAlieoIhnbuXlyLoJYOcCGZwOqnSMZDLdQZZfgsSfvuXPJu3Iy+Xt5nijA2XTI4+JXBo7h3c1+F6skG+nVAIHrkqVnShcVhncJToUiRQ1IsBV1Km7Xd2wFZ4jQiDZQXOFu5w/7nS6wT8JsE2EmKmfJM5shkpcGd9RG05eizb2+eEaQycoprp3ZDdbtHbj9OBlLRGg7tgeedgIBBj6fVgZNjcA4GrWyzomsnvwVTKrG6LV/bIIl4vaO1YV5p7BtA2E8zEVeGE6u0hMxId1d94Spwbvj9lKNf89Db+9TlDta+Ad4wld61NBjm11BcCro23cxw94Ilw/lz7tCbF74b5Ox/FV4e6h2aa5L4SY9/JF13/KOMWT61fw/0RaLYIYb6tcbE38Ei4uuzRdQp82eVDLGmt1LWUqEGzDyy3ncExYmjgbBxzpG8RlMZvRcbm3LjuHRWvMG+5gKDCjUs+eryE1Wdi+7OCGpW9+P8/pPkuHQJE84DYRxAgGG014uH3z+Vkeedy2MyQ6ySbnjtQMqayw57w30axMXf/sYbykHv1vwUOVMh98weqMuEPc6DDGUCPGQmcgjHGlhrM8MZ8nAF8HNcQm2TDvYWZB1DsW/w041mENnk3/VjLE1N90lie1uQmbGjzRZrpkRcZsBiTei9WxXrv7dBZJkt/jupnsYJCusHnqbVYe0oumetbleBogZKnG2sO8PzjhyVyX8D9d/I/G/sOrYKAbPvEkrKarWmuEQLG
 IUyOXjj2
 n/tNdRP6QjkqcYJ0jhJwaPHG6lbzkuuLBLdoQjBRaMi+pqPZbD+NrLLr6fY1EpUIHxDQuPhIwelPolW063nl7ez908RY2wiz83QGyaI7CYPCWFnMXCdi+Yj3BEIE2cSJVnvEzofbzZZdnqZROyOcMJ45+9q1cRY8lYO6+0ddmGMrkYgCaw885JCK3ZLBkEPx6HO+jwQ0j77Y/k5btY/NIStFJXIx4hhXW9AU7bqn6htDhCJpMW3VSBrte1Qer6K2bDXjO0d3yPIsGPwWKHllxpE6daC9UnIDcrVPjwzoc4H9ymVuckzrfygc6Or+hArMUsqLhlIlNkaUqxPsgF2A/2cwaRmVoNhoeZn3sFNwVGkne9vfX+0VP1UnnUnOLB9XcXMRW5dqNd2yzg5c8Dm3o39sD+pvJcWY1KmbWYb50WajKsqKJU46gxDE/HgeoQ4TmOoYh
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

When __vmalloc_area_node() fails to allocate pages, the failure
message may report an incorrect allocation size, for example:

  vmalloc error: size 0, failed to allocate pages, ...

This happens because the warning prints area->nr_pages * PAGE_SIZE.
At this point, area->nr_pages may be zero or partly populated thus
it is not valid.

Report the originally requested allocation size instead by using
nr_small_pages * PAGE_SIZE, which reflects the actual number of
pages being requested by user.

Signed-off-by: Uladzislau Rezki (Sony) <urezki@gmail.com>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 61caa55a4402..a06f4b3ea367 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -3901,7 +3901,7 @@ static void *__vmalloc_area_node(struct vm_struct *area, gfp_t gfp_mask,
 		if (!fatal_signal_pending(current) && page_order == 0)
 			warn_alloc(gfp_mask, NULL,
 				"vmalloc error: size %lu, failed to allocate pages",
-				area->nr_pages * PAGE_SIZE);
+				nr_small_pages * PAGE_SIZE);
 		goto fail;
 	}
 
-- 
2.47.3


