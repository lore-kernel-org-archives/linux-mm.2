Return-Path: <owner-linux-mm@kvack.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from kanga.kvack.org (kanga.kvack.org [205.233.56.17])
	(using TLSv1 with cipher DHE-RSA-AES256-SHA (256/256 bits))
	(No client certificate requested)
	by smtp.lore.kernel.org (Postfix) with ESMTPS id 73857E7490E
	for <linux-mm@archiver.kernel.org>; Wed, 24 Dec 2025 04:22:23 +0000 (UTC)
Received: by kanga.kvack.org (Postfix)
	id D14606B008A; Tue, 23 Dec 2025 23:22:22 -0500 (EST)
Received: by kanga.kvack.org (Postfix, from userid 40)
	id C3FB36B008C; Tue, 23 Dec 2025 23:22:22 -0500 (EST)
X-Delivered-To: int-list-linux-mm@kvack.org
Received: by kanga.kvack.org (Postfix, from userid 63042)
	id B2DE86B0092; Tue, 23 Dec 2025 23:22:22 -0500 (EST)
X-Delivered-To: linux-mm@kvack.org
Received: from relay.hostedemail.com (smtprelay0013.hostedemail.com [216.40.44.13])
	by kanga.kvack.org (Postfix) with ESMTP id A28396B008A
	for <linux-mm@kvack.org>; Tue, 23 Dec 2025 23:22:22 -0500 (EST)
Received: from smtpin16.hostedemail.com (a10.router.float.18 [10.200.18.1])
	by unirelay06.hostedemail.com (Postfix) with ESMTP id 6AD90137218
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:22 +0000 (UTC)
X-FDA: 84253067724.16.480CF82
Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	by imf29.hostedemail.com (Postfix) with ESMTP id 90867120006
	for <linux-mm@kvack.org>; Wed, 24 Dec 2025 04:22:20 +0000 (UTC)
Authentication-Results: imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jYEuUX/A";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of shu17az@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=shu17az@gmail.com
ARC-Seal: i=1; s=arc-20220608; d=hostedemail.com; t=1766550140; a=rsa-sha256;
	cv=none;
	b=UMZGLUAno6xiv1UjTNQjxbhrVqRHmMeDoh2XzcK454o/liiBY4FRDqAz6Np5vZZSz/CLPE
	xWjDqgIY4JZiAipBxhkm43kvNYo+lWvX/mwzxEnw9kRXO5PhFN5Oy8kZIV2rTLfW7pX2u1
	YoichFbfEXRA6ajPLe3i/cSDRXporaM=
ARC-Authentication-Results: i=1;
	imf29.hostedemail.com;
	dkim=pass header.d=gmail.com header.s=20230601 header.b="jYEuUX/A";
	dmarc=pass (policy=none) header.from=gmail.com;
	spf=pass (imf29.hostedemail.com: domain of shu17az@gmail.com designates 209.85.214.174 as permitted sender) smtp.mailfrom=shu17az@gmail.com
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=hostedemail.com;
	s=arc-20220608; t=1766550140;
	h=from:from:sender:reply-to:subject:subject:date:date:
	 message-id:message-id:to:to:cc:cc:mime-version:mime-version:
	 content-type:content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references:dkim-signature;
	bh=w276wAFp2rXYTfyoJfyMT1dCfO/MaZhkGr6Yu9YkzH8=;
	b=aTbKjQLN1nqC/pUVColQ5lPAGk+derxeUstyjkoSC4ACu8LSnlwIx4A+psE3YyRgv9BvTd
	u/ZkF7UmBVPxVHaxycKLNs5BuHUKhNzzvDgVgBY40w2yWZcM6PZmh2g0YLlspVYF6k211S
	d1ccmz5bOWcglwcpozpR3lilyOQ404k=
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-2a0fe77d141so60224135ad.1
        for <linux-mm@kvack.org>; Tue, 23 Dec 2025 20:22:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1766550139; x=1767154939; darn=kvack.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=w276wAFp2rXYTfyoJfyMT1dCfO/MaZhkGr6Yu9YkzH8=;
        b=jYEuUX/AVHS3yUEG75l34builo+xjqG99nCI3Rf2eCHmkws4rQOAUIGAZQRY5zFwi4
         jUINZdSPTT2ZYqhckM4IKBfWnF8G1W7eVnhzIdb26Q+DIQolUv2GZsN1VB38WEpuIfc3
         qKOAyjKDWerqNsMcSAWfHG/4uU1E/bwW0jY9RDGa8tITkqsRwM5SE/S7V7M6E8SNylM6
         c4exAPe5pKmLXOcV2/6vGN/ACKFMKBzvxfPWks7rONdv+mfJJeJnhRoCyNOZ08Npo2jX
         CuO0xIwgH8RMfJ8JZFcwNPD3N0/nQTFW4Xk4zy4x60t+jbAudX7yi/wh1ZTCqug+m487
         vndg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766550139; x=1767154939;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=w276wAFp2rXYTfyoJfyMT1dCfO/MaZhkGr6Yu9YkzH8=;
        b=M7X/WsvBXKUbTUD67l443D+1zdclrSV+HTwWx8lS4xxVq2TpF2SKqPArYYlR0p7rYi
         9kuuhRqoC/mHKBw4YOOIr35KZ2c8MTRKdYn0iRAwqaXFygPsDJ61KQ5o2eFIKfZZi3TR
         eD/T1myTszZ1GcJo+iGG66DwVQMjeCJ6CAyyDv4UeY3e4iWMuKLbbgub4tPMb3JPFdFk
         VQei3vgyM8LEDMVGLjQwU9KgS9SgCTtWa7LIjC9c0IYuv0I0Qcad6g+DS4CWBip2iOeu
         wlu1Y4Amjy0VqqXOyTQaVJw8+TYFiJlIXKcUnTpVIIf5h1iFvWrZMZtGBDlH6BI6wFen
         8+lA==
X-Forwarded-Encrypted: i=1; AJvYcCWERXLxJFCMVWlRdDFhxGr7qrrxImjFe53sTBkiB/nrhgiwqTRHgCcVQqZzBBCLmZLNqOzwSFsbng==@kvack.org
X-Gm-Message-State: AOJu0YzgwZH5CrphBn7kS3Sq8SBmth8+qCyHbRk7iRfzIrRKEZv2xDAL
	pZ3dGkTXkfdeazPo0MXA59EiekeQRDn0a7cF2JIgQLijE6kYCbwUDNxspcr3T0du
X-Gm-Gg: AY/fxX5s7Mc+4q/V1QFpDGrj05yT4psngT248kJUubQRVE9NToNFd5MEtHrXxXV130V
	cjc9mK/PDFvDTR9azxmvtNWFMw2py/unHL/8iIOF5Z76eF2zciZv5PcZjg0PgQkRDvT2fku7a7f
	osPGTWo2u0KlmK06jFXDXFjCeOh8PMHPJbsvj0aES1oPqz1QIy/cznyj5U06K33dfgAWkaOboYi
	kZ0nUV0rdRdJ54r/v1WGr2TGIUxL8kaW7u6mzS4xzmNQRllqZcjMS4R1iv4PTMvkoUAO55KhrsC
	GfFAz3LCGNw4lGGtVP88eg/2AOpTG/zzhjDlpuRnPkeHAw6bUOgwb9nv3ukOJQ73c8vChwoy0+D
	D40WgSph3axRMDhgcWPqhxjKX3Qj8sEWtBNsI2r99CdiTYFFI55ziogs60ILXEEP/G7lJj8fHVa
	Pa
X-Google-Smtp-Source: AGHT+IEhAqxGeTZKj23GyK+SQ0+Vt5x+PYbcQPiunLEQ2r5NzuypeF7Veg9StfYdXugSobiGJ1npaA==
X-Received: by 2002:a05:7022:e13:b0:11b:88a7:e1b0 with SMTP id a92af1059eb24-121722eb801mr18312939c88.26.1766550139363;
        Tue, 23 Dec 2025 20:22:19 -0800 (PST)
Received: from dev.. ([208.184.112.130])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121724de268sm48542031c88.8.2025.12.23.20.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 Dec 2025 20:22:19 -0800 (PST)
From: Shu Anzai <shu17az@gmail.com>
To: SeongJae Park <sj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
	damon@lists.linux.dev,
	linux-mm@kvack.org,
	linux-kernel@vger.kernel.org,
	Shu Anzai <shu17az@gmail.com>
Subject: [PATCH v2 2/5] mm/damon/tests/core-kunit: verify the 'age' and 'nr_accesses_bp' fields in damon_test_merge_two()
Date: Wed, 24 Dec 2025 04:21:57 +0000
Message-ID: <20251224042200.2061847-3-shu17az@gmail.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251224042200.2061847-1-shu17az@gmail.com>
References: <20251224042200.2061847-1-shu17az@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspam-User: 
X-Rspamd-Server: rspam09
X-Rspamd-Queue-Id: 90867120006
X-Stat-Signature: rsuni8f8npyq9b4cnakn94xrkhc4tt99
X-HE-Tag: 1766550140-15016
X-HE-Meta: U2FsdGVkX19l+hvgKhqg07iz8cdSGZo2+l9xXP/UN6J+bovJaxqHHWIDCU87TbA1657IOEQiUghIrDSTxEB1F8xifdS5xEDC0vFoQYX1tidt3hnLacKvB1MovT+/EIW1iYqfIwp5Fftlkz0tqD05qwy8gdPDnzj4OuIQLRAYCFA4NYwQM3ixXTXvfBugE5xZojZY1W69SFOKF2pShfQUqJxOGVpgP/H82tCMUUpblu2HIEtOpbkr9MAgrICJVp9ukjaluuvJsGk/NK7Xs87bZHMyHqTUDM4/TFPazZnu+Wvl6OnkpcpECGNAjeMkkSgpaEsnvIz+gyKShxW9l1Y+MOVrDt7UBEDGs3hPaKb8iNDd2N7UZNLZXu9CMPa60w5Oh0pc0YVKNeG7fjxKqf2E5KZ650XBI2x8Be+tR5UAMVrSM0McgPBaQYRledPdsEirEaUW5qLjR0wJiJSNatXZVelzaiPmN+pjiZjzHLdYFYLE/eDQWEHq4wo6CNAOh4OqeHoouYoeVVIFyNraTDRUVpCeqDwPi4qke0El8/dDOepFbot7I6V92umhJvvejyXD9isARnVTQp1SlJG3z6ZCJ3LDcTmGHyY7xSHTlexWTEHMOZ+JF3dWPunceUdMe1xDYAUkQwLMMyfkLKNueovT7rSmti2yqQGrEhaW4TWNLata/0uH5nIWWAVvGdA767EQee20nsN6fqczIJbRXl1zY1/hgtIZlu2Y8J1VcQvTVQCDkAkZExX95GpD6bt7roRJ9iNrhGF0i2do6RUMrh2/Pjty3kdJvQZIQimarg+4MjUZ1cf5eL2B5eP+ABlX//A7DBN1khTYBPk2ABMsdouzyVaTvrAXuP31+yoQjIlyWSUB4QyuPmVk00brzHLrjFxQMeAcwfF6EmHW5kve5CHopQVK8kTbrdqeezvVilgjaN8WTBxRMy2Fl+22a5ia7bQJequtMA992qEgt6ydDXj
 udMhQAdW
 tb7SxE3xal/vsuO9N3BLoTz9ItTlOz4MAQTxbZMrZPA4rVAk72xg6yVn7RsSk7inqhEGin4Jo7/6VxlsHzaOTNqk0ap+XI/UUXzo2kCPMlpNSk7VAjb99U4LhFUp4SQ9E7sqN0aPyJJKnCAXe5sNY1Hg6IWBDP/4aQKiWqgBxBKWedc7PBy53u9nLqlzOR58XLzYcxf4vY6I3hYOL16u4dDP1ojhNPjbxj9GqOiwFjpvDP/uOgvhbYMst8GOzUjr2S7VVVh4LnCCFa7NNcA11gGu1z67ihkwt98NcJVSqi795kBArSofVxEel3HEVnytOdiqbRGXKmLzXbnlVP1IlMCdPvaiKsZrirl5fbqorXSEJ2vs690NmGioiWC4iebwlOxKXWScbKG/7QQA5SyI3NPBYlm3CLtb6cty89BLzqvOzjLUysCw2RzaIwypNwqBE5i4JT6T+wk5mcyk=
X-Bogosity: Ham, tests=bogofilter, spamicity=0.000003, version=1.2.4
Sender: owner-linux-mm@kvack.org
Precedence: bulk
X-Loop: owner-majordomo@kvack.org
List-ID: <linux-mm.kvack.org>
List-Subscribe: <mailto:majordomo@kvack.org>
List-Unsubscribe: <mailto:majordomo@kvack.org>

Extend damon_test_merge_two() to verify the 'age' and 
'nr_accesses_bp' fields.

Signed-off-by: Shu Anzai <shu17az@gmail.com>
---
 mm/damon/tests/core-kunit.h | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/mm/damon/tests/core-kunit.h b/mm/damon/tests/core-kunit.h
index 88ec046f4942..6e301113e103 100644
--- a/mm/damon/tests/core-kunit.h
+++ b/mm/damon/tests/core-kunit.h
@@ -192,6 +192,7 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	r->nr_accesses = 10;
 	r->nr_accesses_bp = 100000;
+	r->age = 9;
 	damon_add_region(r, t);
 	r2 = damon_new_region(100, 300);
 	if (!r2) {
@@ -200,12 +201,15 @@ static void damon_test_merge_two(struct kunit *test)
 	}
 	r2->nr_accesses = 20;
 	r2->nr_accesses_bp = 200000;
+	r2->age = 21;
 	damon_add_region(r2, t);
 
 	damon_merge_two_regions(t, r, r2);
 	KUNIT_EXPECT_EQ(test, r->ar.start, 0ul);
 	KUNIT_EXPECT_EQ(test, r->ar.end, 300ul);
 	KUNIT_EXPECT_EQ(test, r->nr_accesses, 16u);
+	KUNIT_EXPECT_EQ(test, r->nr_accesses_bp, 160000u);
+	KUNIT_EXPECT_EQ(test, r->age, 17u);
 
 	i = 0;
 	damon_for_each_region(r3, t) {
-- 
2.43.0


