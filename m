Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 9961AC43458
	for <linux-mm@archiver.kernel.org>; Tue, 30 Jun 2026 15:04:50 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id 860A16B00B4; Tue, 30 Jun 2026 11:04:49 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id 837C96B00B5; Tue, 30 Jun 2026 11:04:49 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id 774926B00B6; Tue, 30 Jun 2026 11:04:49 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 514776B00B4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 11:04:49 -0400 (EDT)
Received: from smtpin21.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay09.hostedemail.com (Postfix) with ESMTP id C59268ECB4
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:48 +0000 (UTC)
X-FDA: 84936901056.21.58F4385
Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	by imf13.hostedemail.com (Postfix) with ESMTP id 061292000D
	for <linux-mm@kvack.org>; Tue, 30 Jun 2026 15:04:46 +0000 (UTC)
Authentication-Results: imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m2r+YLkt;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1782831887;
	b=s2mKC8t84gAZJXxagMchyzKgRa22tyDWJ5qnzqORgl9vwOJtyyhr9MKexyDm84AJGdPMKx
	JkXpxEclgT2U+Xx6WlhCLlLWBOP+rx3cMMZsA8j2gSv7DgdV6Bym2xi7LbTwncXThdpAxM
	txnkQ4hFGAo3eZUn2QJ9ygQxXF/SvuQ=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1782831887;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=a/OCyHXptIZem7abs2ebHUlpV5sUt3WFWdltwFGFKKo=;
	b=1OpYR4HtD2exv2xhcNoYeDPTLL4S3S+UoYZMZWC8WMZEh6x005L2AUJN9NnvQsOQytPy2U
	xNJO6lpOzD4CIB/0zCha4k4XPCTu7rMGGF21enzQSD3w5qm3Sdv6v8HlQ9VOk6IoPkk7H2
	E3YhVRXb6/N8aYS6P5ArwW42R5EJ68g=
ARC-Authentication-Results: i=1;
	imf13.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=m2r+YLkt;
	spf=pass (imf13.hostedemail.com: domain of ekffu200098@gmail.com designates 209.85.214.173 as permitted sender) smtp.mailfrom=ekffu200098@gmail.com;
	dmarc=pass (policy=none) header.from=gmail.com
Received: by mail-pl1-f173.google.com with SMTP id d9443c01a7336-2c825c88744so28612555ad.1
        for <linux-mm@kvack.org>; Tue, 30 Jun 2026 08:04:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1782831886; x=1783436686; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=a/OCyHXptIZem7abs2ebHUlpV5sUt3WFWdltwFGFKKo=;
        b=m2r+YLktp01UNQyBwKZW2KmEjLqy20ab2Wj0e0sKtnv98YqiKieuG94ceoRBgE4l5j
         nzQjPlMI/HRU3Rte5My5LoHS8IhBYaRUezMpBUGy4H6m69hlDvN9RwuBwHuOrIxVEku0
         mQ2d3kO6mBZKngIGwf4tdQ8f1r4XOrs6uB+4EIbu7YjZ+Wcihv4c41BsqJoQ6scT/fgy
         tgyYLanLNOdRfAiR+p21QdsmnGRayD5VcO3J/NEVmBr8MsLWcgphS7PMWxlY1hwQnXC6
         i8Ss0Z4wthu/r22JnGAusgw0NdvoergCSS/ZbIG9myxR7K3b+6Tz/q8kL75Hey7dyeJg
         pXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782831886; x=1783436686;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=a/OCyHXptIZem7abs2ebHUlpV5sUt3WFWdltwFGFKKo=;
        b=So2qYFlBkZmObtEdM9dcjYBsFdQ8iYFL5BJunRSC7BnsF8jqxcGuRSrQ7ZylWJW5bg
         qnQrDk2BhH4meykFSHkzRYIPxcNUB8yLqir4mCVRwJ+h8lLjeCiEFgVcCaXr0p111SHB
         eWiYmTqV4mxX0sBJaAJK5K/dLsQ1fYO/3ckMd0PoHFA7mxhpeGFwtAW1DVBFx7vCsMG1
         fptwJAH35QJxKLojbrz6nmK3feUqUv5D1pOZe7VTU05cWEIxYvKoQwLSLJCrJNaraLg1
         gtGSKP+wjj+y4klUn/Jpg30W8oXEDJxenJigb8UmLqv4RBH8bnH5H/rfPNsIHJP0u5yi
         /wMQ==
X-Gm-Message-State: AOJu0YzD6WMh9TyQhkUHdrietjKB7eicBOSEKhajbIZuM8+uU1dCm3rt
	+3OAM2aujuRWrp6zQ1/o8mfkfDabsQphxOOPIAlSbs0HAB48zzvGacaF
X-Gm-Gg: AfdE7cm9jzUphl4OsUfxCSOkGsNEWFIqqs7TGNfFh6EO1OnJ4siv6HDYvdysL0TgFI2
	pqOs5xrEUciWxbukZCy2BZ9cooZJY21z9cOiLhH3tT7zQDQahRlpXPqBaGUFzxDtyGW0x+sRB32
	3CPDT+Ia+R82EzlD35coRbilCg/m4sj29WOAhxyYInAZzK2ZBq0+xbnzlboaEFXhlVKa54eY/FY
	2Av2DBoy5W32qHYGgn4d7uTE9oocFwAZSJN00B3zeZ7jJwiU7aQk8JZMivhYU6vBQZNB6s5iiT1
	49gt3x2N2PHQlnKsjaLheU+vb05VL9dEgbNGyoRXJWwmR68Vkj0h5WwJmOt8JLV0LsInidXOZsh
	cRyB38XDi6m5+wyLSW6eNT86i5rOD5tNVkt+dWfRIjzItOa/hnxnyTB3IHpVsB/Q1FgOagBCTTh
	3xSdWtWHQ=
X-Received: by 2002:a17:903:2b03:b0:2ca:de3:15e1 with SMTP id d9443c01a7336-2ca2e713ebcmr29887815ad.31.1782831885805;
        Tue, 30 Jun 2026 08:04:45 -0700 (PDT)
Received: from ubuntu.. ([110.9.142.4])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2ca37a70bc0sm16250465ad.10.2026.06.30.08.04.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 30 Jun 2026 08:04:45 -0700 (PDT)
From: Sang-Heon Jeon <ekffu200098@gmail.com>
To: rppt@kernel.org,
	Paul Walmsley <pjw@kernel.org>,
	Palmer Dabbelt <palmer@dabbelt.com>,
	Albert Ou <aou@eecs.berkeley.edu>
Cc: linux-mm@kvack.org,
	Sang-Heon Jeon <ekffu200098@gmail.com>,
	Alexandre Ghiti <alex@ghiti.fr>,
	linux-kernel@vger.kernel.org,
	linux-riscv@lists.infradead.org,
	Charlie Jenkins <thecharlesjenkins@gmail.com>
Subject: [PATCH v3 3/8] riscv: remove unreachable invalid range check in create_linear_mapping_page_table()
Date: Wed,  1 Jul 2026 00:04:08 +0900
Message-ID: <20260630150413.1718632-4-ekffu200098@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260630150413.1718632-1-ekffu200098@gmail.com>
References: <20260630150413.1718632-1-ekffu200098@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam12
X-Rspamd-Queue-Id: 061292000D
X-Stat-Signature: deitttcd1z18nwtye1qnhuh1im6xa8qe
X-HE-Tag: 1782831886-18906
X-HE-Meta: U2FsdGVkX18tG5/B9ebaEotwK1WidVs4dXMcPyNhS3+16n0CMxWyhgGiBLby8vh7XGLoZuA57iLEG6P23SyrUE1pzHZa4D3Q4Glp53+mRP1VgG0hhs9LHgJ1IWAuYP8QA32Otiiq2ZiitD1qKC4bwGxmRvp94unQtY+/HS4YWXcKbfyGUdF8yMjBpz23hvXhe3jU+NwS5mgsfUGWW2ilWlxwTTtAq2TaQ/ewsL0bS+3U7ZmcL4SLeIa1x83rxcZws0TSKByBtYCTADGhfqb7u8BvHCwjPeve6G8u6vb+4P1JZUlS/2AM4h0hxJAhROT3l0j5OSK+TlTjEYzOh6TtjK1m8bMx6Hg/6882AlUSUFKqMx9gwiyVCs6LryYD740K7An6QoDyuyi5fiX2OJts7ACwXuwBtG+RTBtvMqzhPzkruP8xosTEqlM+xmjj5aABpmNBHgJQfu9Kkocmy6nydb0Hp7ru+jW8ogPlI6eiUjdieqb4m94Y1Yvs+/WomKnsklMS4fpFezyIJFM1xPkhr0OQKpyJOSGuATwTYQpfaYTAqi8qpyAoDHU0/Dtsxju/tcSDIFelWhovcSGzg5i/UihJ638ZE4hVvLrHx7Xni8YEbXZvE1vVG72vvqezGSoJ8Ys1zPqv3+arqtD3W4HO9h2y4ayT/uCbAGooyMg4luzOrzUaF2JaTErsbADBN4RpnrDX0QseFwtxHaV7XHfVKBySr/LhJC39mnkIbJnmzrd3kq5XbrGyOXPFS4WKvSNj/9knSh5tYgS5hgwpohypYGLlskHb2UwVhM4TMwgz0XXuUBUhqjb9VdBcHEMSExvozBW+3y6mnncp9CXwPola0c0n2BNdd6Ej66K8SV1/sNv5ViS0GLfNYT+NvLYUt4oJsZt/HY/S/wvK8CAwXP33KizJoc0IoLa9IZuEcmkrFXYTGP6xNUGaTrbcpoc84fRt5oKuLpiqKVhujgwm8d4
 xmvd0S0u
 EM7HZDOw2ytSuVbicWCf/JIKpV/1EkxC6z6NAi7rMyUNYFysVVUb1juunALIFw0SLnn2JsGbyLLNHkand9kBvb4UebFi8/lfzmc/pNbteUdpi0TnVAqWSHzF0mxUSlnuIRfHa+ty+36R4C/nZcE163Y7vGS5HnS53DaDKcvAXvzjya/HJjPjvInHjP2fvkooX/biIIhsWXEKpqkcLZpyeIWVvX2Ndl1sGDpXUw77VIlzmsuTWSuPCgdT8B60DacOp5+YgroTMYp72fpeikAmIN5GBOrq7hf4pLl7rDlG6+JC56lsVpqQEl/9fQZCfJKQrVOZBzXzLcktfA+kB+CRc3xeTEa3Bk7UyIWSOdKyu+UFiI4VALL69BUIVDG8Vkq4W4gTYR3ia/mvx4hqcTpuyYxPXkR0ZRHHyJwBYZO/84+CGm6MPddRx8WDg10rFYLPwVtDea1DBR1Z57cg=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

create_linear_mapping_page_table() iterates memblock regions with
for_each_mem_range() and breaks the loop when start >= end.
for_each_mem_range() never returns an invalid range, so start < end always.

Therefore the start >= end check is unreachable, so remove it.

No functional change.

Signed-off-by: Sang-Heon Jeon <ekffu200098@gmail.com>
Reviewed-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
Tested-by: Charlie Jenkins <thecharlesjenkins@gmail.com>
---
 arch/riscv/mm/init.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/riscv/mm/init.c b/arch/riscv/mm/init.c
index 5b1b3c88b4d1..eb93c2ac05a6 100644
--- a/arch/riscv/mm/init.c
+++ b/arch/riscv/mm/init.c
@@ -1229,8 +1229,6 @@ static void __init create_linear_mapping_page_table(void)
 
 	/* Map all memory banks in the linear mapping */
 	for_each_mem_range(i, &start, &end) {
-		if (start >= end)
-			break;
 		if (start <= __pa(PAGE_OFFSET) &&
 		    __pa(PAGE_OFFSET) < end)
 			start = __pa(PAGE_OFFSET);
-- 
2.43.0


