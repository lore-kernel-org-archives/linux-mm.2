Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4C355606A32F
	for <linux-mm@archiver.kernel.org>; Wed, 18 Nov 2026 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MNtaJ/TK
Received: by kanga.kvack.org (Postfix)
	id 614DC6B05B4; Wed, 18 Nov 2026 02:40:28 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 5EB8B6B05B6; Wed, 18 Nov 2026 02:40:28 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 503EE6B05B8; Wed, 18 Nov 2026 02:40:28 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0017.hostedemail.com [216.40.44.17])
	by kanga.kvack.org (Postfix) with ESMTP id 2D7206B05B4
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 02:40:28 -0500 (EST)
Received: from smtpin12.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay01.hostedemail.com (Postfix) with ESMTP id B4B101C3D3E
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:40:27 +0000 (UTC)
X-FDA: 85447442094.12.75C07A4
Received: from mail-pj2-f5.google.com (mail-pj2-f5.google.com [74.125.227.133])
	by imf06.hostedemail.com (Postfix) with ESMTP id D3D11180002
	for <linux-mm@kvack.org>; Wed, 18 Nov 2026 07:40:25 +0000 (UTC)
Authentication-Results: imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="MNtaJ/TK";
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1794987625;
	b=7b/HgOZQCMYbBrV3wTBJcPkvycCMWVW3plQ4wuv9XJU+wJw6b1h0CRuFCKQKSk9rjTo15a
	WN1ry6GTVvW/GoBh8tSt1JcuhMymNQefc0js0HCkbg/nv79g3uSvwMyoYrx+tuXd+LisZv
	aYrxf9mwIgEk6OJBff6EO7RCT6HGz1I=
ARC-Authentication-Results: i=1;
	imf06.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20260707 header.b="MNtaJ/TK";
	spf=pass (imf06.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.227.133 as permitted sender) smtp.mailfrom=jm5905938@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1794987625;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:in-reply-to:
	 references:dkim-signature; bh=V+Q/b4oQQRcc2ev9VIFrb3ozJoPLTXTZ4ZqHagDQPao=;
	b=GbnyUG/P/5TeOkcwspL5npLcMzYlq80RPGMYPxXBXaKNok7qNsQpQd5hTnWoxYrtE/+83e
	xpIVuK4iK8Jt5JLLoZVWDHMo/UhraxZFjxJCA9iV3A/AWvepLOKoI6HnBFiEDjH371wUmr
	JcJibR1fJfkRTNtMj+J/tdqBnP9vbKU=
Received: by mail-pj2-f5.google.com with SMTP id d9443c01a7336-2efd4a0bd68so2281795ad.0
        for <linux-mm@kvack.org>; Tue, 17 Nov 2026 23:40:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794987624; x=1795592424; darn=kvack.org;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=V+Q/b4oQQRcc2ev9VIFrb3ozJoPLTXTZ4ZqHagDQPao=;
        b=MNtaJ/TKgemaLy54fed0SpYzDbDMpc/ndQHVkvnFooRZZWbaHRlZyuj5UL/aiTyYV6
         X6xo+AMtuGkExEDeanE0IFttlgSWkelKMv0WqJVkDuZRJQuz2iX/kHKJc0s1qq3Xmfm7
         YAbo4bWgiek233F15IL6HX9tzp5vLMPGQ6dhm86ewVkx1Uf6ClQnAJacgR+Vq4x/nXvG
         rZpbyCfu5HgUau45QqO0X7HjCxG3Se4hrX5xqAETHesLDAjCUMFUCPFuqrl8w24mfAUJ
         2LwQvIeSR7NP5/ERw/dyjCg90dEwuD7Wm8ihjIAxAZGkhsrwlCUA05dhKF6bX6R+Q8xs
         t4JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794987624; x=1795592424;
        h=cc:to:message-id:content-transfer-encoding:content-type
         :mime-version:subject:date:from:x-gm-gg:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=V+Q/b4oQQRcc2ev9VIFrb3ozJoPLTXTZ4ZqHagDQPao=;
        b=vIF71vmD5SoJXL0WGS6Zr3WzI+ToICjiPFtTX9tgNfVP6d7YDEEKoIl0iA/omhusTs
         1N5ni6Q6LOnmNzw1xpswQVtaFz+FK+bLKhUMAQmhF6k671VRsUre9OjMBT6yiT3gpCm2
         OwHpZU6C3XI+MrJKxmaTdrRgvPLxVC6FaXHD8KOQYCHwFrKgZMF4MJB7EblUYei6s2r6
         2OMUB9VvmBd3mWSOvNmZJ4PKN5DK1n7qrEn75q29pvN/jfaDC6yxKoAGiUHWpNZFXKA9
         I3VPXPsbahg38TjEjQKK73smbL6gIneTa0380qc9nfTAh56YZNKhKJm3bS52dQRyQ5Kk
         RW0g==
X-Forwarded-Encrypted: i=1; AL+hErEhYQJqKzfaByPvSoWJRgN6IC+4MZJwHdxTwcVgpRJZXYPM2E2j+hnhUNwE+Cv1sYmIx0J9oqh2uA==@kvack.org
X-Gm-Message-State: APuU4Z8MO2a0pXySJthJqAkpQEbBaTpI3I7+IFT8aJD3q4x31XlbdbyY
	ilS/22Fb9QcuZ46j5LfHREJa+QfuxcxGmW2FNl1qbsrlIVfMHlPwObYm
X-Gm-Gg: AZFdTZd1JRwXXJSnQJW3LfEKgyungdVO6NmniI7a/DhWmBVAd7UpugYJht3oItqYlMJ
	d3ar/q9t90hHIVLZtfHJK74+J1dc2qdNBBF2HQErZhpw7ikrnuLYraWRv2ScZF60UIAvKaGQiZ3
	MNxiyOvX7/hL9Z1o7Xg2miL9lP4To8R0JpUCkFc3EH160uMHxrOjcyU6Gicty8hjoVciNrPzHXK
	xflALQBENtCC8jk7l82U6o+2oAKLfyT31LltLlpNO+Uyeb3UDfhLM8dZonGsN2KCPby6e/ko0nP
	jK+IvkFSiQQyY5Vq1J8+B7o3CuPsOiAaud1bLayFYic6os4/Jx4VifaLXhyz5Slo/mc5OAS/mFd
	huiFajimoZskkAtdso8zKUVKCLVpH9fPNuSXhixQuNQJn10ncUjccVjf+c0rMLcM0kyhxl8InZQ
	WaEhEKQ//JV8dGxH8+2X+GETKincROj0vumlcCjSK2VCdIWiIGW6uEadZjmM4Wz3Fby8+MUxVJ6
	9GRC8h2jBXnL2KyUsIChiTNKs1UpTXnbBHlDttvwiFu7Pi0Pt60blp9vJee5nisHGewCbkqf5Qx
	w6RHq3v2isIvwj4IfZMCA07+cJROveSsjmVBGIgSW9DnvOh6gu4W8NzNfCg7eiDHilwLcrizpDC
	X2EciGdvT0WPHV4UKUFRQpXWpnYhg1fasXL6gP8rsknDfbVw7fdh73d6kZtOkJg==
X-Received: by 2002:a17:902:d505:b0:2ef:e044:290c with SMTP id d9443c01a7336-2eff75451bdmr16959655ad.25.1794987624447;
        Tue, 17 Nov 2026 23:40:24 -0800 (PST)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2eff6214565sm8667315ad.42.2026.11.17.23.40.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Nov 2026 23:40:23 -0800 (PST)
From: Aveline Noir <jm5905938@gmail.com>
Date: Wed, 18 Nov 2026 03:24:28 +1100
Subject: [PATCH v2] mm/damon/paddr: skip non-LRU folios as a whole in
 pageout
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20261118-fix-damon-hugetlb-pageout-20261117-v2-1-547a65a3206e@gmail.com>
X-B4-Tracking: v=1; b=H4sIAAAAAAAC/z2N2w6CMBBEf4XssxsBRaO/QnzY0rWtkZb0IiaEf
 7eVhMczmTmzQGBvOMC9WsDzxwTjbIb2UMGgySpGIzNDW7eXpmmu+DRflDQ6izopjm+BEyl2KeJ
 eoTPXJ3mTHXUCsmjynFf/k/6xcUjixUMs5tIQFBiFJzvoEm3+OLvdeRxHtDzDuv4Ap29dr7IAA
 AA=
X-Change-ID: 20261117-fix-damon-hugetlb-pageout-20261117-a4e03d9d5a5b
To: SJ Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, damon@lists.linux.dev, 
 linux-mm@kvack.org, linux-kernel@vger.kernel.org, sashiko-bot@kernel.org, 
 sashiko-reviews@lists.linux.dev
X-Mailer: b4 0.16.0
X-Stat-Signature: shs7no58dazsdtpqutdenfhp9gdooebp
X-Spam-Status: No, score=-14.7 required=3.0 tests=BAYES_00,DATE_IN_PAST_12_24,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=4.0.1
X-Rspam-User: 
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: D3D11180002
X-HE-Tag: 1794987625-996547
X-HE-Meta: U2FsdGVkX1+prUH5E3mWz1O44Z4lEcDf3xlS+H4e49M61BpxViiVVuk3C+OCNARZJUeSekF8iv/LdAtIwSV/2ndsZN7frZr24VorYy8/BOi78kZFz1VylZ7vWpZtTgn0Zivu+GyFaI+M/iFjibhyRwMonKPByn0JJF43wEfSXECnTB0x6mPDeygur9boea8wdjt8Eg22DFnbRXkEUAmEljsHTK6XyKkX8EUAHTmSbvz+ugtbHzoD7nj1CcY6Fg1Jr2mPh3przfnxKPj29VbJUXMzVCEZ/nXmgxJC+LMljkNb3y9cLqOpFrf+6sYAEVqcppAs2J5pALBurCQXgaqnRGZYlsXYKsUW/v+v10UmrSun1QhunwcIh4ke0RcXOyBq1W4StfDnNDCUaXXG0VFSgcKfo5u2T4/jRwk7qoSpbfvR+0wE+p2dWJQB2PAkDRuSOW0mByS67+Ta8Q6A7n1/yaxI83v72Dsz6IPhHaaPkf2vXVtypXeQ6g9qZ3+h2RgCSZIY4OUNmEmor16dSZvIFhhLXWXLBxfUh2vzb4eox366UnSHi41CbO0UCkXNVGpfCYAF85kxJGDavyvqBGL8aWS5k8QYDiZUu83jQSxt4weXPv+eBNR9QTLN5nwFDd9/sKuga841gJrfVDAuSKHWlzXuhQ43PtvgpO6WCAThPK1C3OVh/CyfOUUqHaDmpWaBjr+Lw4L2qeSNCrfGOgt+pWofB0eNsVCxG7yKbaZSyQYIQK6INKpjSuEp20TC6+HC13kk4GdG2TFk54LiNnwmW60UaSQKwIEjhvoJk0yw5Mwmx0yTjRxbggCwE97V+A+AiXpS+t46hyJBCw7Ah5MOdjOwkuqRvdQ2a5H+aCTUZcpwMmVJqTdvcw9/Z5J38x9J6i0wCDDUCGM1FKAD4qMrbjlVHPblx8uPlBeUZkbDLYLN/dpyISnT1uQxoT2E7cLY79/aDFsC24jnSRz0NXO
 3eY6b+j5
 EkQ0Ewm7H8ZOn6sqfYGl0Lfo7XHVV3vMu67k6TuEOflzUvPRsT7QPbeb0p16Il1UtC22o40M55FHFmghKmO2Z5dxRYv3BsuyOEz3nIA9O09YSe6HdT+9fXpdHGJFRcLRaZusEq2I07YV8it3IaXl6hp8slfxTMrLVWRgnpLNArdPXeFfCYKmdwEUs7eFtI8iIK0qzchxZtm17k+0vdp7CtuDoECuv6XuVQGE5ODjaOD8O8D+QJXUrFVnSssunYtds9WYkEHxoaz56wMh7fjInHkgeOZvsO7a85iaGu88CAhh7AkyZ6KkAat56yOim0YhaNiJVSbX9cc5By7bQKNfh58KMiX7FikMy5xhaAArfCCcaUkRcymrO9aLd0eBZwqiip949AmNAkNQ0nuq7gNU0PHjeWGdz00j/SAcTHVNscZtfV+LV7ZXr9OtWtFtfpVzokOQhgC15H4YsOkJbp2kiObmZjQ==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

damon_pa_pageout() uses damon_get_folio(), which rejects folios that are
not on the LRU.  For a large non-LRU folio such as a hugetlb folio, the
loop then looks up the same folio once per base page even though
pageout cannot reclaim it.

Use damon_get_monitor_folio() and skip any returned non-LRU folio as a
whole by advancing to its end.  Do this before the filters, the
accounting and the last_applied check, so that adjacent regions within
the same non-LRU folio are not walked by base page either.

In an x86-64 KVM pageout microbenchmark, traversal time dropped by
about 99.7% for regions covering whole 2 MiB hugetlb folios. For
4 KiB regions within hugetlb folios, traversal took about 1 ns more
per region.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
Tested in x86-64 KVM guests.  DAMON KUnit tests all passed.  Ordinary-page
and THP controls passed the 3% non-inferiority bound in the microbenchmark.

Changes in v2:
- Drop the redundant hugetlb check and update the subject and description
  as suggested by SJ.
---
 mm/damon/paddr.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/mm/damon/paddr.c b/mm/damon/paddr.c
index 5b773012a876..0a205fa8d468 100644
--- a/mm/damon/paddr.c
+++ b/mm/damon/paddr.c
@@ -268,7 +268,9 @@ static unsigned long damon_pa_pageout(struct damon_region *r,
 
 	addr = damon_pa_phys_addr(r->ar.start, addr_unit);
 	while (addr < damon_pa_phys_addr(r->ar.end, addr_unit)) {
-		folio = damon_get_folio(PHYS_PFN(addr));
+		folio = damon_get_monitor_folio(PHYS_PFN(addr));
+		if (folio && !folio_test_lru(folio))
+			goto put_folio;
 		if (damon_pa_invalid_damos_folio(folio, s)) {
 			addr += PAGE_SIZE;
 			continue;

---
base-commit: 67f3b04b277373438f17300e056306adbd9edf7b
change-id: 20261117-fix-damon-hugetlb-pageout-20261117-a4e03d9d5a5b

Best regards,
--  
Aveline Noir <jm5905938@gmail.com>


