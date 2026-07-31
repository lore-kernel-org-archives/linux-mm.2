Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id D3C03C54F54
	for <linux-mm@archiver.kernel.org>; Fri, 31 Jul 2026 15:46:25 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id E00AC6B008A; Fri, 31 Jul 2026 11:46:24 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD7EB6B008C; Fri, 31 Jul 2026 11:46:24 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CA0296B0092; Fri, 31 Jul 2026 11:46:24 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0016.hostedemail.com [216.40.44.16])
	by kanga.kvack.org (Postfix) with ESMTP id 914AF6B008A
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 11:46:24 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 1BC8EA172E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:24 +0000 (UTC)
X-FDA: 85049498688.03.62337CF
Received: from flow-b4-smtp.messagingengine.com (flow-b4-smtp.messagingengine.com [202.12.124.139])
	by imf20.hostedemail.com (Postfix) with ESMTP id 1ED4D1C000E
	for <linux-mm@kvack.org>; Fri, 31 Jul 2026 15:46:22 +0000 (UTC)
Authentication-Results: imf20.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=Zd5q3mZN;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="N S5mY7Y";
	spf=pass (imf20.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1785512782;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=J5nIrNoSMiFUIl5DH8xWdANuglVgj8cbxwTsb9rwYoA=;
	b=AtBLDH/CREHZzgfygFW0djOJgvAAsxNMcNWVUCPlwDInSaydYksDU+mX58feNFS4O0fv94
	oj+i0Wp0w4knkcsTF7VMXJDldiqPmPW6zE7eyhTkEuROT5vGf+f1tdBPBfsMRuHFKpsMIz
	y7K61fo+n7OEljWi5XI4fY3nwKLf0v0=
ARC-Authentication-Results: i=1;
	imf20.hostedemail.com;
	dkim=pass header.d=jaseg.de header.s=fm2 header.b=Zd5q3mZN;
	dkim=pass header.d=messagingengine.com header.s=fm2 header.b="N S5mY7Y";
	spf=pass (imf20.hostedemail.com: domain of linux@jaseg.de designates 202.12.124.139 as permitted sender) smtp.mailfrom=linux@jaseg.de;
	dmarc=none
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1785512782;
	b=1PKln6wTEH6+Nj+Ao01U2MpoUTkRQVJJvHBQNk92Fws5gGwU6SlZ4qKxBt4JU9bqmtZE5w
	hqZZsY/huGTyBR9nl3K+Hc0f1WhKR21u973Ayi33T00TojL8o7WEoHXqKiWv4uFbbRq/iF
	L5CWkBpE6hj8ocyRitdCRK/uEkK4+/Y=
Received: from phl-compute-03.internal (phl-compute-03.internal [10.202.2.43])
	by mailflow.stl.internal (Postfix) with ESMTP id 07FC61300105;
	Fri, 31 Jul 2026 11:46:21 -0400 (EDT)
Received: from phl-frontend-03 ([10.202.2.162])
  by phl-compute-03.internal (MEProxy); Fri, 31 Jul 2026 11:46:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=jaseg.de; h=cc
	:cc:content-transfer-encoding:content-type:content-type:date
	:date:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to; s=fm2; t=1785512780;
	 x=1785519980; bh=J5nIrNoSMiFUIl5DH8xWdANuglVgj8cbxwTsb9rwYoA=; b=
	Zd5q3mZNwJF//qXudDTbJ8awtyCqW2iTV3y5rvDGFsBYk8EAd1ZoovsJ7nYgfIv5
	NCtmx919sFnWudMNQVU1o8Kb/MMtG78gdCoWrTi+GsAno9fZUS4nX/xdBL9NMqJY
	TMK3MVPwPW86eqgI00Ccuj1ODl8xJ/dtjRJV0FDa6TSt8ijyz+2mr3x6Fb+A+PTo
	gseH8y+/SQB2MXyLHVcQozCkuflbPSo3ZuN2RV8B4ljXzUTBH2aubYXtfXqYgvU0
	P3WrzXxrACURCoQj6pGtMoKbSNMus8cQtjACT1xggTf89SZGUp3ApXnJyEnAe1ut
	WmAismm9GhwS5bJFdpc64Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
	messagingengine.com; h=cc:cc:content-transfer-encoding
	:content-type:content-type:date:date:feedback-id:feedback-id
	:from:from:in-reply-to:in-reply-to:message-id:mime-version
	:references:reply-to:subject:subject:to:to:x-me-proxy
	:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; t=1785512780; x=
	1785519980; bh=J5nIrNoSMiFUIl5DH8xWdANuglVgj8cbxwTsb9rwYoA=; b=N
	S5mY7YnIyW+Hiu7OJXAh2gxoXAzrRXmf5kOi/AiWWmyfK5fIUBea6QLRHdt3FMC4
	ls1LT7C/LSl8b+JoV4e4/7L+Wf6lyX1V0MIIdFINUSG9AbXxod5msG/9vus2fOix
	LwUs4V+xMjDX4/E9R1SOxjMqp/f80kwFHDM7wnOWUsPDZhLQcoqLdhkA760VRx9b
	qBp+PceNCL2sTGMm5VYruQxVualnpATGhSPXdIka5iKVndjzT6vJ7Zxh2r4vc1rf
	gXS2YCg1weSuIidSLXLr5NytCNVw/zEVnUd5GoSf6QdJZDyAaLubSuZoThyhIIi7
	Yb4HZwYXGQSWtReCa8ZUw==
X-ME-Sender: <xms:TMNsal69Lf6skwkiLaNfWthjlmzsB3MHDHOZ_7MMszG2s7nxeN2ScQ>
    <xme:TMNsalphjpBU7tUU9UdieRXpze2oOSZuiHuYvPFJp_9O2ZluoeWpzQS6EUM9xdxhg
    71lIN-dGc9cA1a6A-UJuvArv2UFMbUQdxNuuKcZP6vVwN30--ISbQ>
X-ME-Received: <xmr:TMNsapXqatYtbR5Jf_WidMFHh_PAzaPh88d1sAk1VwJAQ1lY9stkzFm-2XSdL3-Lpu031bwe-xC91Et_3w>
X-ME-Proxy-Cause: dmFkZTE/BZlAVVxDq9/HeYo9P0/sW1MPOKOzDZ2zczt2A8za9TVFfqEYLK1+OkUHjXNeVE
    xlY3hzB0LLvX5gB9iYwoLGDmmqsrU5556smTDInmhhGhkvXGJPYIY9dA60V1rmC96sOsI0
    XHygQvS6a9K1hbqGvNlelDmHj9E3Ec86FFih5aSGF3F2tH8eUwQUnZN22O/3yPx1ZKBTV3
    xDZn8CjjGaejfmd2G7b5yAbKcRL7w3G3sNyGFJi3IBL1nqr+l7yrItuwDyFqrIuyqCsuPT
    nNwSp+6GfQ7Kugx/1btpxv047qEzH62cBeVY3JQwhsB2H5waeSkwx8HWbJQCRnbraO98UA
    IjotN0qm41ZSLVeEM8qEQ2/W9b3eQYO/tFXXHiItaQLD+T5tlmmwfsRqYpUvTfurO2gKit
    hVH5ql4+48mgd68VkFtCULSe0kwyxg1BMw3+jlH95v7kXsmNF69YakbhqROMbdUk8sTC2a
    /RyN6x0U6qtNOHh5Siy1KBanzU+no+ocJ1Heqg6RSKb/J5aG40m9LroFhXarZUSsbOvzBZ
    gzEHCmrfcHrqWQ+LEP529cg/E5oi6tyqXNygVHXYW7dQ3kJY81NCt5LuubRsX1FP71TBmz
    tlvGGMNDFhU7KJiizBPPrKlanfEEDUTpaHexVKTt60bTCtLfhVfsG191O6mw
X-ME-Proxy: <xmx:TMNsalpwos4_J7Ke-2E2GR_SEqAkFOitpQuOr_MLKFtaeXKdwp9-qg>
    <xmx:TMNsaguogeQHYNlEhH4oI0EAjHWCHemRh4vxaddYQa1841UFBpV2lg>
    <xmx:TMNsarTLvkCQWF9hCoNpNT5GtxUL6ARcOy7VT4QYYPkVTVDpWwBASw>
    <xmx:TMNsasryEv_UMI32lccco4T3EycU2lXWsIfTRTlXCGAZ6bKlECtFCg>
    <xmx:TMNsahLXmDnvvZGzAa2wugTD6lRPPfHZF8cnvy5zSuKtjeaoFyqBp7ya>
Feedback-ID: i60a14417:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 31 Jul 2026 11:46:17 -0400 (EDT)
From: =?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
To: Andrew Morton <akpm@linux-foundation.org>,
	Baoquan He <baoquan.he@linux.dev>,
	Mike Rapoport <rppt@kernel.org>,
	Pasha Tatashin <pasha.tatashin@soleen.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Dave Young <ruirui.yang@linux.dev>,
	David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Paul Moore <paul@paul-moore.com>,
	James Morris <jmorris@namei.org>,
	"Serge E. Hallyn" <serge@hallyn.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	=?UTF-8?q?Jan=20Sebastian=20G=C3=B6tte?= <linux@jaseg.de>
Cc: Rob Herring <robh@kernel.org>,
	Saravana Kannan <saravanak@kernel.org>, Coiby Xu <coxu@redhat.com>,
	"devicetree@vger.kernel.org"@kvack.org,
	"linux-kernel@vger.kernel.org"@kvack.org,
	"kexec@lists.infradead.org"@kvack.org,
	"keyrings@vger.kernel.org"@kvack.org, "linux-mm@kvack.org"@kvack.org,
	"linux-security-module@vger.kernel.org"@kvack.org,
	"linux-integrity@vger.kernel.org"@kvack.org
Subject: [PATCH 1/4] of/kexec: fix typo in comment (usable-memory-range)
Date: Fri, 31 Jul 2026 17:46:05 +0200
Message-ID: <20260731154608.153258-2-linux@jaseg.de>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260731154608.153258-1-linux@jaseg.de>
References: <20260731154608.153258-1-linux@jaseg.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam03
X-Rspamd-Queue-Id: 1ED4D1C000E
X-Stat-Signature: s5qmpc1r5onpaeeuhm16ug8ckt8etz5n
X-HE-Tag: 1785512781-886735
X-HE-Meta: U2FsdGVkX1/cj6KwTq8YAOtsMbGZcKAHV/EsPro2VV4Uz3EGuIpZqLxQ1Mj4nJ64wXLy3lDqCyyMUlpghfOemdeWptMGFCxS6J7kZ2Sx1oWpj5CJPmg+vguauBiKjWpuKPZ7ma3iKmOjH+Fy6UPfJ2CZ1znmr/ZUvlM8qBkCJJ16u5M9NFN9Ws372BGMGpm1DYztgA+LrAhXbD1sS12P+jtrCfx8fYtBz5oR0nIq2oFnXby171SzlZmJSlnBTzE86K/piekLRbKpQB0uUNLwG6F2gk8WYCKW44IfENtAFduW/J4UoeewRrOBDDrZmquSoJfJjUQ5/lbduhdLzRZuHnZ5VATkpvbUVxdrytnsJjZlPvNw3W3FBVlE/SkuHLVdMlQlZSThOt5EC22H4bszkwkdaWha172N6q4t9iwyhZayGPVIcf6cOCJZ9ahmVdwmUfJlf0WMXvuYm5gg/ErfSlE8Th5U5TcXBGu9iWS1dMDjNaupP43TzXjozpq+uMH2YYsEqipaTpUJVjyxbBxbMWhWPG/1PwvPg5JtbDQpJyA8UMy/lLmD4v8dTW+gAINEqk7HQDESfyPutoCR0TvPYXOJaDoeslRTVv6+fxkGOkwXpdGJf1g7B5Iz/eLoZ9FbtKywrIvAYwD1EdYNMQ1iD7dB/2TcgPIThvSk6Ndij7GFL5AmxO6unVeQ5hXndqKWxKmBaKvBgVe0lPO5UUiI6srxsiYjvAIV8iKVDHtE308cd3lwQ7kuDpP0Wj5xng2TUrr7RbatXJiweVhK0010YvrQ8CPulWX1Vz3eJzTgGPZ/x7lm7Z1Vqscga9SXCXkuWhD8EU8kgN9V1AHJStLktGaAp4Ycw+SvWAaaJTE+ZO49sWHQbG9UzXtW/YSznfii5HiAFW8NUiSKGYP8WMjY1evqyVAnSjA5vcUf+rdCYkUKZcqXxMIq8ovnK0r31qJdAmdp0dnUDLrsczZAN6R
 nf0D19Gk
 B100lVR4tcOch6MHwB9Wtp6Xhz8kOPBAhXCFnovRqpVT34uzQKXrmNW9s//cKxPM1746iAMsnC4GQRBO2rzn/H/6lEasFnF5o+4yS/Atqf2fZQ3JuURgIkZhXrVHziIB1GMzaYKrS+35r97N64X1kDqMm60I0m5j1Sj0hrUM3AA/tSXn3zqw0cYL7dG7iC0nTRt1DbbtZarG9HECNV2LllBq3oWy4CTOWR2+dWs1J3zku0tIzHFqYW02rqiDbrM9fOd95Wu/Mc9ucKWPmGNjkc3Kxd737mbX2gmiuecjKtaQYr7rO7mpwapZGiWqrzOx2gst+jiXvw6BCwHMtXY0QpkMrVEIim3SCkPE0FXKLI1K/uGrFe7MNOSl6Ctz5vjv3cSkMM+clJvwJ6iDx2UhtYE7VRYBiVXA+UaguT08CU7NAxhpWFtcImCaBCcadCNKr9GqioCD/t6TzZ6e3CcNSx5xOdD4+Q3n/mlBa0CjvNTZEolvEjkJcBLWAJJeObKpJuXWLgTmDh6hOBI1AWhVVKMWrD2AwI4qOk/gNCNdABMJs9E3cSIF0CPOiax9ZpdPA/FXzz+mUP5TCe7CJ2vc/lpUMGCYFDZLsErHhkv8ar8RP/bmzyndSRzFBnA7zh1R/O47PpWp9FSLUvyrP1NQ1K7wJDh4jUBCqCISeKz4bkbMLgH8q4HN4abPoIzQeOI8iPbVVo1PEAWwRC/nReSljnzhHPHsggj7BwZ9Ysu/1GbLZr5/H9owDtVMkd2aA8Vt8Q3or+ClvgKvcRvR3KUnb1iVaHO+TjxtSC43zEwC0Kjjl8DownxP3/YgMyuwtqkpqMIXg6zS3+Wg6k7uEiIoKIDeae4dFX6OVTR2WeO4yVpeog90Sqd+rSuvt+p4M7zCrHoedRKsax+peSAqIfmPl2s6oxD5G3DXMsAA+fg4+S7YWVcNdRWyQ7BDsmAERcqmztF+tDK4LCEVD6r1W4yFXKT2mKTIm
 T3KekP09
 lS4xMzEfKo8=
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Signed-off-by: Jan Sebastian Götte <linux@jaseg.de>
---
 drivers/of/kexec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/of/kexec.c b/drivers/of/kexec.c
index 029903b986cb..36635f6cb900 100644
--- a/drivers/of/kexec.c
+++ b/drivers/of/kexec.c
@@ -24,7 +24,7 @@
 
 /*
  * Additional space needed for the FDT buffer so that we can add initrd,
- * bootargs, kaslr-seed, rng-seed, useable-memory-range and elfcorehdr.
+ * bootargs, kaslr-seed, rng-seed, usable-memory-range and elfcorehdr.
  */
 #define FDT_EXTRA_SPACE 0x1000
 
-- 
2.53.0


