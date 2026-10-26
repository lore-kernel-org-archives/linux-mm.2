Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CAF51606A338
	for <linux-mm@archiver.kernel.org>; Mon, 26 Oct 2026 11:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=dFKZ5F6D
Received: by kanga.kvack.org (Postfix)
	id E02416B05B7; Mon, 26 Oct 2026 07:18:00 -0400 (EDT)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id DD95A6B05B8; Mon, 26 Oct 2026 07:18:00 -0400 (EDT)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id CC9256B05B9; Mon, 26 Oct 2026 07:18:00 -0400 (EDT)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0012.hostedemail.com [216.40.44.12])
	by kanga.kvack.org (Postfix) with ESMTP id A1BAA6B05B7
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 07:18:00 -0400 (EDT)
Received: from smtpin03.hostedemail.com (lb01a-stub [10.200.18.249])
	by unirelay03.hostedemail.com (Postfix) with ESMTP id 20890A074A
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:18:00 +0000 (UTC)
X-FDA: 85364527920.03.D4A4336
Received: from mail-pz2-f6.google.com (mail-pz2-f6.google.com [74.125.228.6])
	by imf24.hostedemail.com (Postfix) with ESMTP id 540EB180008
	for <linux-mm@kvack.org>; Mon, 26 Oct 2026 11:17:58 +0000 (UTC)
Authentication-Results: imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dFKZ5F6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1793013478;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=NRIkuKUZUAgjI71v50t8xrAuxWFu9ma5GeG76B0scz8=;
	b=0JDKT4dhtyv2h/fUB8qzVfLgMKrOdxBfe6TDffWr7nCqfDKPXsNq6JygBxkOP7kv0wMVaq
	O1Gi/+BYoTQTzsDl8D9FkVz4WcavhLItm6d4J6WuHYIHmBGmq1qi92BW/2E/miLLiUhNcG
	aNOUXwz4xFD2uhDOosMW3G0lRSFDnVI=
ARC-Authentication-Results: i=1;
	imf24.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20251104 header.b=dFKZ5F6D;
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf24.hostedemail.com: domain of jm5905938@gmail.com designates 74.125.228.6 as permitted sender) smtp.mailfrom=jm5905938@gmail.com
ARC-Seal: i=1; a=rsa-sha256; d=hostedemail.com; s=arc-20220608; cv=none;
	t=1793013478;
	b=nb4PiqOFdQrPV8QSJl9PPC5MEl99N2IQFl8ZpwWkileDhabSfhvEzzdopq5lQQBJDakjWr
	aFHnaWSSCDXgx1t/N2IuytvQ88d2/Dh7mbaTqqo0eFuNiwcPgI1dZbwn3WTgiZDFaYZSSj
	yLinPrTTeO6doxpA8NG8JxBvx+CAqEE=
Received: by mail-pz2-f6.google.com with SMTP id 41be03b00d2f7-cd613507bd1so265688a12.0
        for <linux-mm@kvack.org>; Mon, 26 Oct 2026 04:17:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793013477; x=1793618277; darn=kvack.org;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NRIkuKUZUAgjI71v50t8xrAuxWFu9ma5GeG76B0scz8=;
        b=dFKZ5F6DCQwZK/Y4mW+uaMhGThlzbQgSvcAU8Mc4yqVnRKITT66M6/IyYBNc1vGEUi
         DkXyECHhht/wWTRdrMqiJqspgCS16q3Tu61Iuk5Mp2DElKUIJ/z5giLl+8I+b07VWBPy
         emMTr0lQrTsXvk2A/qUGv87xrfY4WUaG5Tvb8fmZYt+XqBOFdxV7Qj0EMGDKaUHIour1
         3cftZeXWspXDdQm7vHG1gtg+L510zasPirYnhl4pankWt4DBDQUWF+QEPGuPFzyliGnH
         cBPHkx26pM+AOzFT2nXXprWQgohbKIw7TUTlcdKYVXgoF7WPf5IABTVztBY6K8cpTRFE
         4Vhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793013477; x=1793618277;
        h=references:in-reply-to:message-id:date:content-transfer-encoding
         :content-type:mime-version:subject:cc:to:from:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NRIkuKUZUAgjI71v50t8xrAuxWFu9ma5GeG76B0scz8=;
        b=sH64IEChqymNZK58A6nNZmZrp0XtJHUQ3ZIA9Vt3skzkQrBR7TanF/WZNAjsq/ZD+k
         0Wxoa6QNSlTzOCo8USFITXFYnEE1GnNVTR22gTksBXdkgmTR7ADjOWdsfUuya1cMhliR
         BsZP3MJDxspqqo9CedYmTnaQ7IcgK5P7kNMUvBMrAQSTu2sPSlMhtTh4kaZkhsy0/zN8
         Ht5ZEyK4/excUn9P2X21971nNVCwuB2UiMOjgko9iQUeyvEO5kuGtlUo3rAdPsNpi8Wh
         clkieCL5PfFcGJXw1CrqjuX6/zazR2kw8Tq4U+1hXRWEwRhcBCVhwaPLjaGXvUMatEle
         fUjQ==
X-Forwarded-Encrypted: i=1; AKwUvBwYPds3kDx/of8cRFNpa0W1FIfqm7lRCtHELlQQENNnGHf3jCviYYdo88usXbNlcZNytVqmvNjPLw==@kvack.org
X-Gm-Message-State: AFq9FYL+w03B0BtiMoN0V7Q340G93y6JbmFbwhgpK39BQp25t8NqT+YP
	G2CyXsbQo4Hk/ZSWxCiSLMPSI3OJrlaaEk2UywJXweLQY/TkDEfaHOmC
X-Gm-Gg: AYBFou2xwYCyEueE0lg2wyhC8T8Yrmxb48qrlKg+XaXQCKDxvwdeIlQjyhO2LCpJjWN
	m8dNODIF7o3Tdl6SyngZeNmn1mlpQfCljF92nspCTjk/s8L8XQg5LxZF30RmI0msTIidiC7huf7
	R6N7Y6ZBXtn1DESyQcj2K/uj7wc/PRkgL35oJBYw38ukAgFtumArnmK7SHBqRpgq2QUtS0BnpIc
	QzS35XyTx0WcrHP1G4nSyBZf61Kdj691maSVcl+oj7ZmqAJQAJdd9D0KpuG4CJJAsk+juju29oo
	20v8ybeFw31v7lL1KRZwS3V3G4cG7HSwoN7FvfRK4qOvdChFVUhsU0VDj//IoDtouKzEBpD8I+s
	y38PsTqiOYkrAdBLWspM9rQUdsADBfOo9RPhtPAE8aVnOnovYDecXdXH/7EZkiM4I3ilyMwkBtu
	N+Njqqb9Tyy2wI3SP+8b1IIXkR35bChZdUDy9kE5BoA2NQ0oVjKRmFeSl4wgACjRrTZnyeH2lSo
	nA01dsWzA00v1UEfS65wJqixJlQo2n1z3Lxpgf6Sf6s9s63KfdsmJvfnIiH0utQNT7xYdGuh4UG
	VdZ6eB6VsjyaLrjBOvW0MIMhFVkqv+rOPASRjYP/9UQ0+TLJ8viYYONNsnzo/pdvVhxNCGoKVAY
	=
X-Received: by 2002:a05:6a00:4005:b0:8a0:2914:5d27 with SMTP id d2e1a72fcca58-8a369168952mr5053901b3a.44.1793013477084;
        Mon, 26 Oct 2026 04:17:57 -0700 (PDT)
Received: from localhost (n106-71-19-159.sun21.vic.optusnet.com.au. [106.71.19.159])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-8a36acadefesm1240756b3a.19.2026.10.26.04.17.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 04:17:56 -0700 (PDT)
From: Aveline Noir <jm5905938@gmail.com>
To: SJ Park <sj@kernel.org>
Cc: Jonathan Corbet <corbet@lwn.net>,
 Shuah Khan <skhan@linuxfoundation.org>,
 Randy Dunlap <rdunlap@infradead.org>,
 Manuel Ebner <manuelebnerli@mailbox.org>,
 damon@lists.linux.dev,
 linux-mm@kvack.org,
 linux-doc@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: [PATCH 2/8] Docs/admin-guide/mm/damon/stat: fix pronoun agreement
X-Archived-By: <archiver.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 26 Oct 2026 22:14:34 +1100
Message-ID: <179301327249.2.17530814278215474568.damon-docs-grammar-2@gmail.com>
In-Reply-To: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
References: <179301327249.2.4690198998605536207.damon-docs-grammar-0@gmail.com>
X-Rspamd-Server: rspam10
X-Rspamd-Queue-Id: 540EB180008
X-Stat-Signature: ea1c68uywczs7bikq5wrx6hezdjz17pc
X-Spam-Status: No, score=-12.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_PASS,SPF_PASS autolearn=ham
	autolearn_force=no version=4.0.1
X-Rspam-User: 
X-HE-Tag: 1793013478-708439
X-HE-Meta: U2FsdGVkX18vn7sWjWLFKK9sTltEHMNcNamLamL5kgBpPHSMrV3HsBSLM8Bg+Cgyz39R8HqIecdjnhx2WkDqMrvVhzOCpV0bN8bOy59x0L9s7RoRzHUF7MmvDEGiEpr9a5XE34Ase4V4dOmTcgkCRbQAlJ0cjtCbOntenBYlsd8JtgSXfRNpEkDEtQsMQMTTmuw5MMMfU7qJWhu7/rgWO8Bh549XQE7gp27+CgX1lGVMCBItUcRJak0oqMmcPwVbwXqZAnOgJViGN1sK3W2onoBn4v2vLRnrUAKKo+mBoYCvJza14r4bP+FKvkhKSJ3Yrm2tBGObWxJx2UCespMjHCxOhlOkvAKTdrxyz6u2bxZ3qzIthTxehTvLJB6r7sCanHRHWvH4HL54qcGdGjCzOGTZJnkxKXra007Tvzga9Y3jk1PRsQh35P5i80AOI2z60sg5jewZoJocravWSCCF9LFfkR4TqamND58WkpAm82hgSB1yiLr9UURzQrPSdtYL5PrVSjFnr5jb7zscxf5MaCHEcf08DLqJKlNG4Msb2RFDGIHOLQpKiI3QrmJ+eWK+9/OclZwr1akzXR3nn8JsDdBOd8Jd0Pa18eRZbj/SeTXNxZOGEiz8LPyY/nXULrYFIu4gxoBSpGzGsVZOUP/sDZktUH9mY8Qos8q0f2yuIQcrAymj19K8XBxavbc0qwdVP7r4KV1hfmLfx56OgmShlZsgMHSxrVsPgtbbS7T93/q/5CAZtpRTM78pjlfvGhZ86TNXLpgeFq6cMNGNQNc9+g03RP4gaRDAOJ6RxrpvjjXbrKvP1xobWx+9F5EJIApghiZT0EWb1ljPy+4PV/UwIcqWqw3Ie3ConhC36lUJvOOJrYyZMNiPNvHAU153QOFv3fKrZ6y6d7WCCJ2Ph4GsQGK8MhdHjvTQQLQEdtAwkkDfQ105zIlhe8gRp6nB8GlL8nXvBKuJQIf5ANtcczk
 LNZ8MD9B
 s8bvdgkgkqx1WVt+zvIaQJ68BbuWGLnPFMyM92bQRRg0w6bhe/bFasK/TOUeZ+GnO+XDBAmsdu/7nY/iju1wy6CHzV/IxKws7SN1hPm1lAwGt/9VLkx7itmYM01OzVdRirCaWPeykfmL0KB18m5X5y6P3M5K4sAEguduavWDFfBLYa2NN3t4VjEpSXoHWA6i1aT9n7NSwryoDtcltyyu+cgeSC+Tg/NyMHyqdzh7W2onHNYskeSxovSVSdR/n8mMPr5PwNTn23EpYkgkbAMYrUC0G+d/pMR+MPRQ1Kwf4uFymSeMnFC6jk6/C8YldA4Dfo1VauHjszbGmo+HYuwKFsZ2LmeLq1h2at+Se6gputkD/E7jdLhbI14Xl+g2cPxnWcT+q5FVGeXrcpKc29USzsHvFvsmip1pZCF8CEULlMC5RY1sRVXM+GCLXue7xuzMf0TzhFlRZY39gA/RJvpJfMxIA0fuC/Wk+DybKbZY0EUk26vmZJB+ldXdEdA==
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
X-Spam-Checker-Version: SpamAssassin 4.0.1 (2024-03-26) on
	aws-us-west-2-korg-listserv-alma10-1

"converts it" refers to the access events, so I think it should be
"them".  Rewrap the paragraph while at it.

Signed-off-by: Aveline Noir <jm5905938@gmail.com>
---
 Documentation/admin-guide/mm/damon/stat.rst | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/Documentation/admin-guide/mm/damon/stat.rst b/Documentation/admin-guide/mm/damon/stat.rst
index 4a9db755a526..a93609649a5f 100644
--- a/Documentation/admin-guide/mm/damon/stat.rst
+++ b/Documentation/admin-guide/mm/damon/stat.rst
@@ -68,10 +68,10 @@ estimated_memory_bandwidth
 Estimated memory bandwidth consumption (bytes per second) of the system.
 
 DAMON_STAT reads observed access events on the current DAMON results snapshot
-and converts it to memory bandwidth consumption estimation in bytes per second.
-The resulting metric is exposed to user via this read-only parameter.  Because
-DAMON uses sampling, this is only an estimation of the access intensity rather
-than accurate memory bandwidth.
+and converts them to memory bandwidth consumption estimation in bytes per
+second.  The resulting metric is exposed to user via this read-only parameter.
+Because DAMON uses sampling, this is only an estimation of the access intensity
+rather than accurate memory bandwidth.
 
 memory_idle_ms_percentiles
 --------------------------

